require 'pg'
require './lib/task'
require './lib/list'

DB = PG.connect({:dbname => 'to_do'})

def main_menu
  puts "\n"
  puts 'Welcome to the To Do List!'
  puts '--------------------------'
  puts 'Type "a" to view all tasks'
  puts 'Type "c" to create a new list'
  puts 'Type "v" to view all lists and add tasks to those lists'
  puts 'Type "x" to exit'
  user_input = gets.chomp

  if user_input == 'c'
    add_list
  elsif user_input == 'a'
    view_all_tasks
  elsif user_input == 'v'
    view_lists
  elsif user_input == 'x'
    puts "Goodbye"
  else
    puts "Invalid choice"
    main_menu
  end
end

def add_list
  puts "Type the name of the list"
  input_list = gets.chomp
  new_list = List.new(input_list)
  new_list.save

  puts "#{new_list.name} added to database."
  main_menu
end

def view_all_tasks
  if Task.all.empty?
    puts "Tasks empty.  Add a task first."
    main_menu
  else
    puts "\n"
    puts "All Tasks"
    puts "---------"
    Task.all.each_with_index do |task, index|
      if task.complete == 't'
        puts "#{index + 1} #{task.name}  --- COMPLETED"
      else
        puts "#{index + 1}.  #{task.name}"
      end
    end
    main_menu
  end
end

def view_lists
  if List.all.empty?
    puts "No lists created.  Add a list first."
    main_menu
  else
    puts "\n"
    puts "Current Lists:"
    puts "--------------"
    List.all.each_with_index do |list, index|
      puts "#{index + 1}.) #{list.name}"
    end
    puts "\n"
    puts "Type 'v' to view all tasks for a list."
    puts "Type 'a' to add tasks to a list."
    puts "Type 'd' to delete a list."
    puts "Type 'm' to return to main menu."

    user_input = gets.chomp

    if user_input == 'm'
      main_menu
    elsif user_input == 'd'
      puts 'Type the list number to delete that list'
      input_index = gets.chomp
      current_list = List.all[input_index.to_i - 1]
      delete_list(current_list)
    elsif user_input == 'a'
      puts 'Type the list number to add to that list'
      input_index = gets.chomp
      current_list = List.all[input_index.to_i - 1]
      add_task(current_list)
    elsif user_input == 'v'
      puts 'Type the list number to view all tasks for that list'
      input_index= gets.chomp
      current_list = List.all[input_index.to_i - 1]
      view_tasks(current_list)
    else
      puts 'Invalid choice.'
      view_lists
    end
  end
end

def add_task(current_list)
  puts "Type the task name"
  input_name = gets.chomp

  new_task = Task.new(input_name.capitalize, current_list.id)
  new_task.save
  puts "\n"
  puts "#{new_task.name} added to list. \n"
  puts "Type 'a' to add another task or 'm' to return to main menu."
  user_input = gets.chomp

  if user_input == 'a'
    add_task(current_list)
  elsif user_input == 'm'
    main_menu
  else
    puts 'Invalid input.  Returning to main menu...'
    main_menu
  end
end

def delete_task(current_list)
  puts "Type the number of the task to delete."
  user_input = gets.chomp

  selected_task = current_list.tasks[user_input.to_i - 1]
  selected_task.delete

  puts "Task deleted."
  view_tasks(current_list)
end

def delete_list(current_list)
  puts "Are you sure you want to delete #{current_list.name}? Y or N?"
  user_input = gets.chomp

  if user_input.downcase == 'y'
    current_list.delete
    view_lists
  elsif user_input.downcase == 'n'
    puts "#{current_list.name} saved.  Returning to list view."
    view_lists
  else
    main_menu
  end
end

def view_tasks(current_list)
  if Task.all.empty?
    puts "\n"
    puts "No tasks.  Add a task first."
    puts "\n"
    main_menu
  else
    puts "\n"
    puts "Current Tasks:"
    puts "--------------"
    current_list.tasks.each_with_index do |task, index|
      if task.complete == 't'
        puts "#{index + 1} #{task.name}  --- COMPLETED"
      else
        puts "#{index + 1}.  #{task.name}"
      end
    end
    puts "\n"
    puts "Type 'a' to add tasks to this list."
    puts "Type 'c' to complete a task."
    puts "Type 'd' to delete a task."
    puts "Type 'm' to return to main menu."
    user_input = gets.chomp

    if user_input == 'm'
      main_menu
    elsif user_input == 'c'
      puts "Select a task to complete"
      user_task = gets.chomp
      current_task = current_list.tasks[user_task.to_i - 1]
      complete_task(current_task)
    elsif user_input == 'a'
      add_task(current_list)
    elsif user_input == 'd'
      delete_task(current_list)
    else
      "Invalid choice. Returning to main menu..."
      main_menu
    end
  end
end

def complete_task(current_task)
  current_task.completed
  puts "#{current_task.name} completed."
  main_menu
end


main_menu
