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
    task = Task.find_by(id: params[:id])
    if task.nil?
      render json: { message: "Task not found" }, status: :not_found
    elsif task.update(task_params)
      render json: task
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    task = Task.find_by(id: params[:id])
    if task
      task.destroy
      head :no_content
    else
      render json: { message: "Task not found" }, status: :not_found
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description)
  end
end
