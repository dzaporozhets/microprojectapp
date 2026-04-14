class Api::V1::CommentsController < Api::V1::BaseController
  before_action :set_task

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = @current_api_user

    if @comment.save
      @project.add_activity(@current_api_user, 'commented on', @task)
      render json: { comment: comment_json(@comment) }, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = @project.tasks.find_by(id: params[:task_id])

    unless @task
      render json: { error: 'Not found' }, status: :not_found
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def comment_json(comment)
    {
      id: comment.id,
      body: comment.body,
      user_email: comment.user_email,
      created_at: comment.created_at
    }
  end
end
