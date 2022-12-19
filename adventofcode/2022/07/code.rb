# typed: false
# frozen_string_literal: true

require("pry")

@root = { files: [], dirs: [], parent: nil, name: "root" }
@current_dir = @root

def load_input(line)
  # fix the first line
  line = line[2..-1] if line.start_with?("$ ")

  if line.start_with?("cd /")
    @current_dir = @root
    return
  end

  if line.start_with?("cd ..")
    @current_dir = @current_dir[:parent]
    return
  end

  if line.start_with?("cd")
    @current_dir[:dirs].each do |dir|
      if dir[:name] == line.split(" ")[1].strip
        @current_dir = dir
        break
      end
    end
    return
  end

  if line.start_with?("ls")
    line.split("\n").each do |entry|
      next if entry == "ls"

      spl = entry.split(" ")
      if entry.start_with?("dir")
        @current_dir[:dirs] << { name: spl[1], dirs: [], files: [], parent: @current_dir }
      else
        @current_dir[:files] << { name: spl[0], size: spl[0].to_i }
      end
    end
  end
end

def populate_directory_sizes
  @root[:size] = get_size(@root)
end

def get_size(directory)
  size = 0
  directory[:files].each do |file|
    size += file[:size]
  end

  directory[:dirs].each do |dir|
    if dir[:size].nil?
      s = get_size(dir)
      dir[:size] = s
      size += s
    else
      size += dir[:size]
    end
  end

  size
end

def find_sum_of_sub_100k_directories
  sum = 0
  sum += sub100k_sum(@root)
  sum
end

def sub100k_sum(directory)
  sum = 0
  sum += directory[:size] if directory[:size] <= 100000
  directory[:dirs].each do |dir|
    sum += sub100k_sum(dir)
  end
  sum
end

def a(input)
  input.split("\n$ ").each do |line|
    load_input(line)
  end

  populate_directory_sizes

  find_sum_of_sub_100k_directories
end

@currently_smallest = { size: 9999999999999999999999 }
@space_needed = 0

def find_smallest_deletable_folder
  @space_needed = 30_000_000 - (70_000_000 - @root[:size])

  check_size(@root)
  @currently_smallest[:size]
end

def check_size(directory)
  directory[:dirs].each do |dir|
    if dir[:size] <= @currently_smallest[:size] && dir[:size] >= @space_needed
      @currently_smallest = dir
    end
    check_size(dir)
  end
end

def b(input)
  find_smallest_deletable_folder
end

input = File.read(File.join(__dir__, "input.txt"))
puts "part A: " + a(input).to_s + "\n"
puts "part B: " + b(input).to_s + "\n"
