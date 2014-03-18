require 'pg'

class Task
  attr_reader(:name, :list_id, :complete)

  def initialize(name, list_id, complete=false)
    @name = name
    @list_id = list_id
    @complete = complete
  end

  def self.all
    results = DB.exec('SELECT * FROM tasks;')
    tasks = []
    results.each do |result|
      name = result['name']
      list_id = result['list_id'].to_i
      tasks << Task.new(name, list_id)
    end
    tasks
  end

  def save
    DB.exec("INSERT INTO tasks (name, list_id) VALUES ('#{@name}', '#{@list_id}');")
  end

  def ==(another_task)
    self.name == another_task.name && self.list_id == another_task.list_id
  end

  def delete
    DB.exec("DELETE FROM tasks WHERE name = '#{@name}';")
  end

  def completed
    DB.exec("UPDATE tasks SET complete = true WHERE name= '#{@name}';")
  end
end
