class List
  attr_reader(:name, :id)

  def initialize(name, id=nil)
    @name = name
    @id = id
  end

  def ==(another_list)
    self.name == another_list.name && self.id == another_list.id
  end

  def save
    results = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def tasks
    results = DB.exec("SELECT * FROM tasks WHERE list_id = #{@id};")
    tasks = []
    results.each do |result|
      name = result['name']
      list_id = result['list_id'].to_i
      tasks << Task.new(name, list_id)
    end
    tasks
  end

  def delete
    DB.exec("DELETE FROM tasks WHERE list_id = #{@id};")
    DB.exec("DELETE FROM lists WHERE name = '#{@name}';")
  end

  def self.all
    results = DB.exec('SELECT * FROM lists;')
    lists = []
    results.each do |result|
      name = result['name']
      id = result['id'].to_i
      lists << List.new(name, id)
    end
    lists
  end
end
