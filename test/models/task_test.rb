require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "should not save task without title" do
    task = Task.new(description: "Missing title")
    assert_not task.save, "Saved the task without a title"
  end


  test "should save valid task" do
    task = Task.new(title: "New Task", description: "Some description")
    assert task.save
  end
end
