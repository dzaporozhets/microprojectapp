#!/usr/bin/env ruby
# frozen_string_literal: true

# MicroProject MCP Server
# Standalone Ruby script — no gem dependencies (stdlib only)
#
# Config via env vars:
#   MICROPROJECT_API_URL    - Base URL of the MicroProject instance (e.g. https://app.example.com)
#   MICROPROJECT_API_TOKEN  - API token from the Account page
#   MICROPROJECT_PROJECT_ID - Default project ID

require 'json'
require 'net/http'
require 'uri'

class MicroProjectMCP
  TOOLS = [
    {
      name: 'list_tasks',
      description: 'List tasks in a MicroProject project. Returns task names with checkbox notation.',
      inputSchema: {
        type: 'object',
        properties: {
          status: {
            type: 'string',
            enum: %w[todo done all],
            description: 'Filter by status: todo, done, or all (default: all)'
          },
          project_id: {
            type: 'string',
            description: 'Project ID (uses default from MICROPROJECT_PROJECT_ID if omitted)'
          }
        }
      }
    },
    {
      name: 'get_task',
      description: 'Get full details of a task including description and comments.',
      inputSchema: {
        type: 'object',
        properties: {
          task_id: {
            type: 'string',
            description: 'Task ID'
          },
          project_id: {
            type: 'string',
            description: 'Project ID (uses default from MICROPROJECT_PROJECT_ID if omitted)'
          }
        },
        required: ['task_id']
      }
    },
    {
      name: 'toggle_task_done',
      description: 'Toggle a task between done and not done.',
      inputSchema: {
        type: 'object',
        properties: {
          task_id: {
            type: 'string',
            description: 'Task ID'
          },
          project_id: {
            type: 'string',
            description: 'Project ID (uses default from MICROPROJECT_PROJECT_ID if omitted)'
          }
        },
        required: ['task_id']
      }
    }
  ].freeze

  def initialize
    @api_url = ENV.fetch('MICROPROJECT_API_URL') { abort 'MICROPROJECT_API_URL not set' }.chomp('/')
    @api_token = ENV.fetch('MICROPROJECT_API_TOKEN') { abort 'MICROPROJECT_API_TOKEN not set' }
    @default_project_id = ENV['MICROPROJECT_PROJECT_ID']
  end

  def run
    $stdout.sync = true
    $stderr.sync = true

    while (line = $stdin.gets)
      request = JSON.parse(line)
      response = handle(request)
      $stdout.puts(JSON.generate(response)) if response
    end
  end

  private

  def handle(request)
    id = request['id']
    method = request['method']

    case method
    when 'initialize'
      jsonrpc_result(id, {
        protocolVersion: '2024-11-05',
        capabilities: { tools: {} },
        serverInfo: { name: 'microproject', version: '1.0.0' }
      })
    when 'notifications/initialized'
      nil # no response for notifications
    when 'tools/list'
      jsonrpc_result(id, { tools: TOOLS })
    when 'tools/call'
      handle_tool_call(id, request['params'])
    when 'ping'
      jsonrpc_result(id, {})
    else
      jsonrpc_error(id, -32601, "Method not found: #{method}")
    end
  end

  def handle_tool_call(id, params)
    tool_name = params['name']
    args = params['arguments'] || {}

    result = case tool_name
             when 'list_tasks'   then call_list_tasks(args)
             when 'get_task'     then call_get_task(args)
             when 'toggle_task_done' then call_toggle_task_done(args)
             else return jsonrpc_error(id, -32602, "Unknown tool: #{tool_name}")
             end

    jsonrpc_result(id, { content: [{ type: 'text', text: result }] })
  rescue => e
    jsonrpc_result(id, {
      content: [{ type: 'text', text: "Error: #{e.message}" }],
      isError: true
    })
  end

  def call_list_tasks(args)
    project_id = resolve_project_id(args)
    status = args['status'] || 'all'
    path = "/api/v1/projects/#{project_id}/tasks?status=#{status}"
    data = api_get(path)

    project = data['project']
    tasks = data['tasks']

    lines = ["## #{project['name']} — Tasks (#{status})", ""]

    tasks.each do |t|
      checkbox = t['done'] ? '[x]' : '[ ]'
      star = t['star'] ? ' *' : ''
      due = t['due_date'] ? " (due #{t['due_date']})" : ''
      comments = t['comment_count'] > 0 ? " [#{t['comment_count']} comments]" : ''
      lines << "- #{checkbox} ##{t['id']} #{t['name']}#{star}#{due}#{comments}"
    end

    lines << "" << "#{tasks.size} task(s)"
    lines.join("\n")
  end

  def call_get_task(args)
    project_id = resolve_project_id(args)
    task_id = args.fetch('task_id')
    path = "/api/v1/projects/#{project_id}/tasks/#{task_id}"
    data = api_get(path)
    t = data['task']

    lines = []
    lines << "## ##{t['id']} #{t['name']}"
    lines << ""
    lines << "**Status:** #{t['done'] ? 'Done' : 'To do'}"
    lines << "**Star:** #{t['star'] ? 'Yes' : 'No'}"
    lines << "**Due:** #{t['due_date'] || 'None'}"
    lines << "**Assigned:** #{t['assigned_user_email'] || 'Unassigned'}"
    lines << "**Created:** #{t['created_at']}"
    lines << "**Updated:** #{t['updated_at']}"

    if t['description'] && !t['description'].empty?
      lines << "" << "### Description" << "" << t['description']
    end

    comments = t['comments'] || []

    if comments.any?
      lines << "" << "### Comments (#{comments.size})" << ""

      comments.each do |c|
        lines << "**#{c['user_email']}** (#{c['created_at']}):"
        lines << c['body']
        lines << ""
      end
    end

    lines.join("\n")
  end

  def call_toggle_task_done(args)
    project_id = resolve_project_id(args)
    task_id = args.fetch('task_id')
    path = "/api/v1/projects/#{project_id}/tasks/#{task_id}/toggle_done"
    data = api_patch(path)
    t = data['task']

    status = t['done'] ? 'done' : 'to do'
    "Task ##{t['id']} \"#{t['name']}\" marked as **#{status}**."
  end

  def resolve_project_id(args)
    args['project_id'] || @default_project_id || raise('No project_id provided and MICROPROJECT_PROJECT_ID not set')
  end

  def api_get(path)
    uri = URI("#{@api_url}#{path}")
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{@api_token}"
    req['Accept'] = 'application/json'
    perform_request(uri, req)
  end

  def api_patch(path)
    uri = URI("#{@api_url}#{path}")
    req = Net::HTTP::Patch.new(uri)
    req['Authorization'] = "Bearer #{@api_token}"
    req['Accept'] = 'application/json'
    req['Content-Type'] = 'application/json'
    perform_request(uri, req)
  end

  def perform_request(uri, req)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    http.open_timeout = 10
    http.read_timeout = 15

    resp = http.request(req)

    unless resp.is_a?(Net::HTTPSuccess)
      body = JSON.parse(resp.body) rescue {}
      raise "API error #{resp.code}: #{body['error'] || resp.message}"
    end

    JSON.parse(resp.body)
  end

  def jsonrpc_result(id, result)
    { jsonrpc: '2.0', id: id, result: result }
  end

  def jsonrpc_error(id, code, message)
    { jsonrpc: '2.0', id: id, error: { code: code, message: message } }
  end
end

MicroProjectMCP.new.run
