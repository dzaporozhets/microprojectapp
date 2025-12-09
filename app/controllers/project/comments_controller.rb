class Project::CommentsController < Project::BaseController
  before_action :set_task

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      @project.add_activity(current_user, 'commented on', @task)

      respond_to do |format|
        format.html { redirect_to task_path, notice: 'Comment was successfully created.' }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to task_path, alert: 'Comment could not be created.' }
      end
    end
  end

  def destroy
    @comment = @task.comments.find(params[:id])
    @comment.update(removed_at: Time.current)

    respond_to do |format|
      format.html { redirect_to task_path, notice: 'Comment was successfully deleted.' }
      format.turbo_stream
    end
  end

  private

  def set_task
    @task = project.tasks.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :attachment)
  end

  def task_path
    details_project_task_path(project, @task)
  end
end
