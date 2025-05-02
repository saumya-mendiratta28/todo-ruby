class TasksController < ApplicationController
  def index
    tasks = Task.all
    render json: tasks
  end

  def show
    begin
      task = Task.find(params[:id])
      render json: task
    rescue ActiveRecord::RecordNotFound
      render json: { message: "Task not found" }, status: :not_found
    end
  end

  def create
    task = Task.new(task_params)
    if task.save
      render json: task, status: :created
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def update
    begin
      task = Task.find(params[:id])
      task.update!(task_params)
      render json: task
    rescue ActiveRecord::RecordNotFound
      render json: { message: "Task not found" }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: "Validation failed", errors: e.record.errors }, status: :unprocessable_entity
    rescue => e
      render json: { message: "Unexpected error", error: e.message }, status: :internal_server_error
    end
  end


  def destroy
    begin
      task = Task.find(params[:id])
      task.destroy!
      head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { message: "Task not found" }, status: :not_found
    rescue => e
      render json: { message: "Error deleting task", error: e.message }, status: :internal_server_error
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description)
  end
end
