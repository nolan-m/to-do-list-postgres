require 'spec_helper'

describe Task do
  it 'is intialized with a name and a list ID' do
    test_task = Task.new('learn SQL', 1)
    test_task.should be_an_instance_of Task
  end
  it 'tells you its name' do
    test_task = Task.new('learn SQL', 1)
    test_task.name.should eq 'learn SQL'
  end
  it 'tells you its list ID' do
    test_task = Task.new('learn SQL', 1)
    test_task.list_id.should eq 1
  end

  it 'starts off with no tasks' do
    Task.all.should eq []
  end
  it 'lets you save tasks to the database' do
    test_task = Task.new('walk the dog', 1)
    test_task.save
    Task.all.should eq [test_task]
  end

  it 'is the same task if it has the same name' do
    task1 = Task.new('learn SQL', 1)
    task2 = Task.new('learn SQL', 1)
    task1.should eq task2
  end

  it 'allows you to delete a task' do
    task1 = Task.new('Walk the Dog', 1)
    task1.save
    task2 = Task.new('Wash the car', 2)
    task2.save
    task1.delete
    Task.all.should eq [task2]
  end

  it 'allows you to mark tasks as completed without deleting them' do
    list = List.new('Gardening')
    list.save
    task1 = Task.new('Water the lawn', list.id)
    task1.save
    task2 = Task.new('Plant vegetables', list.id)
    task2.save
    task1.completed.should eq true
  end
end
