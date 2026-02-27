require 'pp'
require 'set'

# this is a ruby port of http://codepumpkin.com/sudoku-solver-using-backtracking/
# list of difficult puzzles: http://staffhome.ecm.uwa.edu.au/~00013890/sudoku17

Cell = Struct.new(:value)
class Cell
  def set(v)
    self.value = v
  end

  def clear
    set(nil)
  end

  def to_s
    value || '.'
  end

  def inspect
    value || '.'
  end
end

class Grid
  # initial_grid is a string representing an unsolved puzzle, e.g.: "4972.....1..4....5....16.9862.3...4.3..9.......1.726....2..587....6....453..97.61"
  def initialize(initial_grid)
    @initial_grid = initial_grid
    @cells = @initial_grid.each_char.take(81).map {|char| char == '.' || char == '0' ? Cell.new(nil) : Cell.new(char.to_i) }
  end

  def rows
    @rows ||= @cells.each_slice(9).to_a
  end

  def cols
    @cols ||= rows.transpose
  end

  def three_by_three_boxes
    @boxes ||= [0,1,2].repeated_permutation(2).map do |box_coord|
      box_row, box_col = *box_coord
      col_offset = box_col * 3
      row(box_row * 3)[col_offset...(col_offset+3)] +
        row(box_row * 3 + 1)[col_offset...(col_offset+3)] +
        row(box_row * 3 + 2)[col_offset...(col_offset+3)]
    end
  end

  # converts an index position into the @cells array into the corresponding (row_index, col_index) pair that represents the same grid cell
  def cell_index_to_row_col_index(cell_index)
    row_index = cell_index / 9
    col_index = cell_index % 9
    [row_index, col_index]
  end

  def cell(row, col)
    @cells[row * 9 + col]
  end

  def row(i)
    rows[i]
  end

  def col(i)
    cols[i]
  end

  def box(box_row, box_col)
    three_by_three_boxes[box_row * 3 + box_col]
  end

  def box_by_cell_coords(cell_row, cell_col)
    box(cell_row / 3, cell_col / 3)
  end

  def row_contains?(row_index, number)
    row(row_index).any? {|cell| cell.value == number }
  end

  def col_contains?(col_index, number)
    col(col_index).any? {|cell| cell.value == number }
  end

  def box_contains?(cell_row, cell_col, number)
    box_by_cell_coords(cell_row, cell_col).any? {|cell| cell.value == number }
  end

  def valid_number_for_cell?(cell_row, cell_col, number)
    !row_contains?(cell_row, number) && !col_contains?(cell_col, number) && !box_contains?(cell_row, cell_col, number)
  end

  def to_s
    @cells.map(&:to_s).join
  end

  def to_grid
    rows.map {|cells| cells.map(&:to_s).join }.join("\n")
  end

  def transpose
    new_grid_str = cols.map {|cells| cells.map(&:to_s).join }.join
    Grid.new(new_grid_str)
  end

  def solve
    cell_index = @cells.index {|cell| cell.value == nil }
    return true unless cell_index

    cell = @cells[cell_index]

    row_index, col_index = *cell_index_to_row_col_index(cell_index)

    for number in 1..9
      if valid_number_for_cell?(row_index, col_index, number)
        cell.set(number)
        if solve
          return true
        else
          cell.clear
        end
      end
    end

    false
  end

  def valid_solution?
    check_set = Set.new(1..9)
    cell_sets = rows.map{|row| row.map(&:value).to_set } + 
      cols.map{|row| row.map(&:value).to_set } + 
      three_by_three_boxes.map{|row| row.map(&:value).to_set }
    cell_sets.all? {|cell_set| cell_set == check_set } 
  end
end

def main
  ARGV.each do |unsolved_puzzle|
    puts "puzzle:   #{unsolved_puzzle}"
    grid = Grid.new(unsolved_puzzle)
    
    puts grid.to_grid

    grid.solve
    puts "solution: #{grid.to_s}"
    puts grid.to_grid
    puts "valid solution? : #{grid.valid_solution?}"
  end
end

main