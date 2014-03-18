require 'spec_helper'

describe List do
  it 'is initialized with a name' do
    list = List.new('Epicodus stuff')
    list.should be_an_instance_of List
  end

  it 'can be initialized with its database ID' do
    list = List.new('Epicodus stuff', 1)
    list.should be_an_instance_of List
  end

  it 'tells you its name' do
    list = List.new('Epicodus stuff')
    list.name.should eq 'Epicodus stuff'
  end

  it 'sets its ID when you save it' do
    list = List.new('learn SQL')
    list.save
    list.id.should be_an_instance_of Fixnum
  end

  it 'is the same last if it has the same name' do
    list1 = List.new('Epicodus stuff')
    list2 = List.new('Epicodus stuff')
    list1.should eq list2
  end

  it 'starts off with no lists' do
    List.all.should eq []
  end

  it 'lets you save lists to the database' do
    list = List.new('learn SQL')
    list.save
    List.all.should eq [list]
  end

  it 'returns all tasks in a particular list' do
    list = List.new('Code Projects')
    list.save
    task1 = Task.new('Learn SQL', list.id)
    task1.save
    task2 = Task.new('Learn Ruby', list.id)
    task2.save
    list.tasks.should eq [task1, task2]
  end

  it 'allows you to delete a list' do
    test_list2 = List.new('Exercise')
    test_list2.save
    exer_task1 = Task.new('Push ups', test_list2.id)
    exer_task1.save
    test_list = List.new('Gardening')
    test_list.save
    task1 = Task.new('Water the lawn', test_list.id)
    task1.save
    task2 = Task.new('Plant veg', test_list.id)
    test_list.delete
    List.all.should eq [test_list2]
    Task.all.should eq [exer_task1]
  end

end
