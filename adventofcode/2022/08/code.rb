# typed: false
# frozen_string_literal: true

require("pry")

@grid = []

def load_input(line)
  tmp = []
  line.split("").each do |entry|
    tmp << entry.to_i
  end
  @grid << tmp
end

def a(input)
  input.split("\n").each do |line|
    load_input(line)
  end

  visible_trees = 0

  @grid.each_with_index do |row, x|
    row.each_with_index do |_, y|
      # skip edges
      if x == 0 || y == 0 || x == row.length - 1 || y == row.length - 1
        next
      end

      if good_north?(@grid[y][x], x, y - 1) ||
          good_south?(@grid[y][x], x, y + 1) ||
          good_west?(@grid[y][x], x - 1, y) ||
          good_east?(@grid[y][x], x + 1, y)

        visible_trees += 1
      end
    end
  end
  visible_trees + (@grid.length * 4) - 4
end

def good_north?(check_height, x, y)
  # we are now at the edge
  if y == 0 || y == @grid[0].length
    if check_height > @grid[y][x]
      return true
    end
  end

  if check_height > @grid[y][x] && good_north?(check_height, x, y - 1)
    true
  else
    false
  end
end

def good_south?(check_height, x, y)
  # we are now at the edge
  if y == 0 || y == @grid[0].length - 1
    if check_height > @grid[y][x]
      return true
    end
  end

  if check_height > @grid[y][x] && good_south?(check_height, x, y + 1)
    true
  else
    false
  end
end

def good_west?(check_height, x, y)
  # we are now at the edge
  if x == 0 || x == @grid[0].length - 1
    if check_height > @grid[y][x]
      return true
    end
  end

  if check_height > @grid[y][x] && good_west?(check_height, x - 1, y)
    true
  else
    false
  end
end

def good_east?(check_height, x, y)
  # we are now at the edge
  if x == 0 || x == @grid[0].length - 1
    if check_height > @grid[y][x]
      return true
    end
  end

  if check_height > @grid[y][x] && good_east?(check_height, x + 1, y)
    true
  else
    false
  end
end

@highest_score = 0

def b(input)
  @grid.each_with_index do |row, y|
    row.each_with_index do |_, x|
      # skip edges
      if x == 0 || y == 0 || x == row.length - 1 || y == row.length - 1
        next
      end

      score_north = score_north(@grid[y][x], x, y - 1)
      score_south = score_south(@grid[y][x], x, y + 1)
      score_west = score_west(@grid[y][x], x - 1, y)
      score_east = score_east(@grid[y][x], x + 1, y)

      combined = score_north * score_south * score_west * score_east

      if combined > @highest_score
        @highest_score = combined
      end
    end
  end
  @highest_score
end

def score_north(check_height, x, y)
  score = 0
  # we are now at the edge
  if y == 0
    return 1
  end

  if check_height > @grid[y][x]
    score = 1 + score_north(check_height, x, y - 1)
  end

  if check_height <= @grid[y][x]
    score += 1
  end

  score
end

def score_south(check_height, x, y)
  score = 0
  # we are now at the edge
  if y == @grid.length - 1
    return 1
  end

  if check_height > @grid[y][x]
    score = 1 + score_south(check_height, x, y + 1)
  end

  if check_height <= @grid[y][x]
    score += 1
  end

  score
end

def score_west(check_height, x, y)
  score = 0
  # we are now at the edge
  if x == 0
    return 1
  end

  if check_height > @grid[y][x]
    score = 1 + score_west(check_height, x - 1, y)
  end

  if check_height <= @grid[y][x]
    score += 1
  end

  score
end

def score_east(check_height, x, y)
  score = 0
  # we are now at the edge
  if x == @grid[0].length - 1
    return 1
  end

  if check_height > @grid[y][x]
    score = 1 + score_east(check_height, x + 1, y)
  end

  if check_height <= @grid[y][x]
    score += 1
  end

  score
end

input = File.read(File.join(__dir__, "input.txt"))
puts "part A: " + a(input).to_s + "\n"
puts "part B: " + b(input).to_s + "\n"
