require 'pp'
require 'set'

# this is a ruby port of http://codepumpkin.com/sudoku-solver-using-backtracking/
# improved with rules taken from http://byteauthor.com/2010/08/sudoku-solver/
# list of difficult puzzles: http://staffhome.ecm.uwa.edu.au/~00013890/sudoku17

# Abstractly, a Tag is used for is coordinating change sets.
# Specifically, every time the backtracking solver makes a guess about a given cell's value, it tags that guess with a tag,
# and then any inferences that we can make assuming the guess is correct will result in changes being made to other cells.
# Those inferences/changes made to other cells are also tagged with the same tag. That way, if it is ever determined that
# the original guess was bad, we can roll back all changes to any cell that was modified as a result of that original guess.
# The Tag could be implemented as a monotonically increasing global integer variable that increments every time you need a new tag.
class Tag
  def self.instance
    @instance ||= new
  end

  def self.gen
    instance.gen
  end

  def initialize
    @i = 0
  end

  def gen
    @i += 1
  end
end

# Note: I use the word "cell" to mean one of the 81 squares on the 81-square grid, and I use the
# word "box" to mean one of the nine 3x3 boxes (each consisting of 9 cells) that make up a grid.

class Cell
  attr_reader :index, :row_index, :col_index

  def initialize(value, index, row_index, col_index)
    @index = index
    @row_index = row_index
    @col_index = col_index
    candidate_values = value ? Set.new : Set.new(1..9)
    @stack = [ [:init, value, candidate_values] ]   # the stack consists of 3-tuples of the form [tag, value, candidate_value_set]
  end

  def coords
    @coords ||= [row_index, col_index]
  end

  def value
    @stack.last[1]
  end

  def candidate_values
    @stack.last[2]
  end

  def set(v, tag)
    if @stack.last[0] == tag
      @stack.last[1] = v
      @stack.last[2] = Set.new
    else
      new_tuple = [tag, v, Set.new]
      @stack.push(new_tuple)
    end
  end

  def reject_candidates(tag, *candidate_values_to_reject)
    if @stack.last[0] == tag
      candidate_values.subtract(candidate_values_to_reject.flatten)
    else
      new_tuple = [tag, value, candidate_values - candidate_values_to_reject.flatten]
      @stack.push(new_tuple)
    end
  end

  def rollback(tag)
    index = @stack.index {|tuple| tuple[0] == tag }

    if index
      @stack = @stack[0...index]
    end
  end

  def to_s
    value || '.'
  end

  def inspect
    "index: #{index}   value: #{to_s}   tag: #{@stack.last[0]}   candidates: #{candidate_values.to_a.sort.join}"
  end
end

class Grid
  # initial_grid is a string representing an unsolved puzzle, e.g.: "4972.....1..4....5....16.9862.3...4.3..9.......1.726....2..587....6....453..97.61"
  def initialize(initial_grid)
    @initial_grid = initial_grid
    @cells = @initial_grid.each_char.with_index.take(81).map do |char, index|
      if char == '.' || char == '0'
        Cell.new(nil, index, *cell_index_to_row_col_index(index))
      else
        Cell.new(char.to_i, index, *cell_index_to_row_col_index(index))
      end
    end
    @grid_init_tag = Tag.gen
    @cells.each_with_index do |cell, cell_index|
      update_candidate_solutions_of_neighbor_cells(@grid_init_tag, cell)
    end
    raise "Invalid puzzle" unless propagate_rule_implications(@grid_init_tag)
    # @cells.each do |cell|
    #   puts cell.inspect
    # end
  end

  def rows
    @rows ||= @cells.each_slice(9).to_a
  end

  def cols
    @cols ||= rows.transpose
  end

  # Returns an array of 3x3 boxes, with each box being represented as an array of the 9 cells within that box
  # The boxes are enumerated in the following order: the first is the box in the top left corner of the puzzle grid,
  # followed by the remaining boxes on the top row (from left to right), followed by the boxes in the middle
  # row (from left to right), followed by the boxes on the bottom row (from left to right).
  # Within each box, the 9 cells that are within the box are in the following order: top left cell within the box, followed
  # by the remaining cells in the top row of the box (in order from left to right), followed by the cells in the middle row of
  # the box (from left to right), followed by the cells in the bottom row of the box (from left to right).
  def three_by_three_boxes
    @boxes ||= [0,1,2].repeated_permutation(2).map do |box_coord|
      box_row, box_col = *box_coord
      col_offset = box_col * 3
      row(box_row * 3)[col_offset...(col_offset+3)] +
        row(box_row * 3 + 1)[col_offset...(col_offset+3)] +
        row(box_row * 3 + 2)[col_offset...(col_offset+3)]
    end
  end

  def box_rows
    @box_rows ||= three_by_three_boxes.each_slice(3).to_a
  end

  def box_cols
    @box_cols ||= box_rows.transpose
  end

  def box_row(row)
    box_rows[row]
  end

  def box_cols(col)
    box_cols[col]
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

  def cells_in_same_box?(cells)
    cells.map {|cell| box_by_cell_coords(*cell.coords) }.uniq.count == 1
  end

  def row_valid?(row_index)
    row_vals = row(row_index).map(&:value).compact
    row_vals.count == row_vals.uniq.count
  end

  def col_valid?(col_index)
    col_vals = col(col_index).map(&:value).compact
    col_vals.count == col_vals.uniq.count
  end

  def box_valid?(cell_row, cell_col)
    box_vals = box_by_cell_coords(cell_row, cell_col).map(&:value).compact
    box_vals.count == box_vals.uniq.count
  end

  def cell_update_valid?(row_index, col_index)
    row_valid?(row_index) && col_valid?(col_index) && box_valid?(row_index, col_index)
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

    for number in cell.candidate_values
      # 1. capture cell states of all cells that are about to be updated
      tag = Tag.gen
      cell.set(number, tag)
      update_candidate_solutions_of_neighbor_cells(tag, cell)

      propagation_success = propagate_rule_implications(tag)

      if propagation_success && solve
        return true
      else
        # revert cell states captured in (1) back to the state they were in at (1)
        # puts "rollback #{tag}"
        @cells.each {|c| c.rollback(tag) }
      end
    end

    false
  end

  def update_candidate_solutions_of_neighbor_cells(tag, updated_cell)
    row_index, col_index = *updated_cell.coords

    # update neighbors in same row
    row(row_index).each {|cell| cell.reject_candidates(tag, updated_cell.value) }

    # update neighbors in same col
    col(col_index).each {|cell| cell.reject_candidates(tag, updated_cell.value) }

    # update neighbors in same box
    box_by_cell_coords(row_index, col_index).each {|cell| cell.reject_candidates(tag, updated_cell.value) }
  end

  # this method evaluates the search heuristics/rules that will narrow the search space of the candidates values for
  # the remaining cells based on the knowledge that the cell at (row_index, col_index) was just set to a value.
  # returns true if propagation was successfully completed without errors; false otherwise
  def propagate_rule_implications(tag)
    while true
      updated_cell_count = 0

      # Per rule #1 from http://byteauthor.com/2010/08/sudoku-solver/, any cells that only have a
      # single candidate value must resolve to that value, so just set the cell value to the single candidate solution
      # and then verify that the partial solution is still valid; if the partial solution is invalid, then we need to reject this
      # candidate solution and backtrack
      cells_with_implied_solution = @cells.select {|cell| cell.candidate_values.count == 1 }
      cells_with_implied_solution.each do |cell|
        return false unless update_cell(tag, cell, cell.candidate_values.first)
        updated_cell_count += 1
      end

      # Per rule #2 from http://byteauthor.com/2010/08/sudoku-solver/, within a given 3x3 box, if a cell in the
      # box has a candidate solution that no other cell in the same box has as a candidate solution, then the cell
      # with the unique candidate solution should be set to that unique value - that cell is solved.
      three_by_three_boxes.each do |box|
        count = deduce_cell_values_from_group_of_related_cells(tag, box)
        return false if count < 0
        updated_cell_count += count
      end

      # Per rule #3 from http://byteauthor.com/2010/08/sudoku-solver/, within a given 9-cell row or column, if a cell
      # in the row or column has a candidate solution that no other cell in the same row or column has as a candidate solution,
      # then the cell with the unique candidate solution should be set to that unique value - that cell is solved.
      rows.each do |row|
        count = deduce_cell_values_from_group_of_related_cells(tag, row)
        return false if count < 0
        updated_cell_count += count
      end
      cols.each do |col|
        count = deduce_cell_values_from_group_of_related_cells(tag, col)
        return false if count < 0
        updated_cell_count += count
      end

      # Per rule #4 from http://byteauthor.com/2010/08/sudoku-solver/, within each 3x3 box, if we observe that a given value
      # is only allowed in a single row or single column within the box, then, (1) in the case of a row, we can remove that
      # value from from the candidate values of the cells in the adjacent boxes on the same row, or, (2) in the case of a column,
      # we can remove that value from the candidate values of the cells in the adjacent boxes on the same column.
      three_by_three_boxes.each do |box_cells|
        cells_per_candidate_value = (1..9).reduce({}) do |memo, number|
          memo[number] = box_cells.select {|cell| cell.candidate_values.include?(number) }
          memo
        end

        cells_per_candidate_value.each do |candidate_value, cells|
          if cells.map(&:row_index).uniq.count == 1
            # this branch implies that all the cells within this 3x3 box that have <candidate_value> as a candidate value are all
            # on one row, therefore, <candidate_value> may not appear on the same row in other 3x3 boxes
            row_index = cells.first.row_index
            (row(row_index) - cells).each do |cell|
              pre_rejection_candidates = cell.candidate_values
              cell.reject_candidates(tag, candidate_value)
              post_rejection_candidates = cell.candidate_values
              updated_cell_count += 1 if pre_rejection_candidates.count != post_rejection_candidates.count
            end
          elsif cells.map(&:col_index).uniq.count == 1
            # this branch implies that all the cells within this 3x3 box that have <candidate_value> as a candidate value are all
            # on one column, therefore, <candidate_value> may not appear on the same column in other 3x3 boxes
            col_index = cells.first.col_index
            (col(col_index) - cells).each do |cell|
              pre_rejection_candidates = cell.candidate_values
              cell.reject_candidates(tag, candidate_value)
              post_rejection_candidates = cell.candidate_values
              updated_cell_count += 1 if pre_rejection_candidates.count != post_rejection_candidates.count
            end
          end
        end
      end

      # Per Naked Pairs Rule from http://byteauthor.com/2010/08/sudoku-solver-update/, for any given row (or column), if two cells
      # - let's call them A and B - on the same row (or column) have the exact same candidate values, such that the candidate
      # values consist only of two values, then no other cell on the same row (column) may be either of the two candidate values,
      # so we can remove the two values from the candidate value sets of every cell except A and B on that row (or column).
      # Note: the Naked Pairs rule is the same as rule #1 with a different length requirement.
      cells_with_two_candidate_values = @cells.select {|cell| cell.candidate_values.count == 2 }
      cells_grouped_by_row_index = cells_with_two_candidate_values.group_by(&:row_index)
      cells_grouped_by_col_index = cells_with_two_candidate_values.group_by(&:col_index)
      cells_grouped_by_row_index.each do |row_index, cells|
        cell_pairings = cells.combination(2).to_a
        cell_pairings.each do |cell1, cell2|
          if cell1.candidate_values == cell2.candidate_values
            (row(row_index) - [cell1, cell2]).each do |cell|
              pre_rejection_candidates = cell.candidate_values
              cell.reject_candidates(tag, cell1.candidate_values)
              post_rejection_candidates = cell.candidate_values
              updated_cell_count += 1 if pre_rejection_candidates.count != post_rejection_candidates.count
            end
          end
        end
      end
      cells_grouped_by_col_index.each do |col_index, cells|
        cell_pairings = cells.combination(2).to_a
        cell_pairings.each do |cell1, cell2|
          if cell1.candidate_values == cell2.candidate_values
            (col(col_index) - [cell1, cell2]).each do |cell|
              pre_rejection_candidates = cell.candidate_values
              cell.reject_candidates(tag, cell1.candidate_values)
              post_rejection_candidates = cell.candidate_values
              updated_cell_count += 1 if pre_rejection_candidates.count != post_rejection_candidates.count
            end
          end
        end
      end

      # Per Lines Rule from http://byteauthor.com/2010/08/sudoku-solver-update/, within each 3x3 box,
      # if we observe that a given value is only allowed in a single row or single column within the box, then, (1) in the case
      # of a row, we can remove that value from the candidate values of the cells in the other rows within the same box, or,
      # (2) in the case of a column, we can remove that value from the candidate values of the cells in the other columns within
      # the same box.
      rows.each do |row_cells|
        cells_per_candidate_value = (1..9).reduce({}) do |memo, number|
          memo[number] = row_cells.select {|cell| cell.candidate_values.include?(number) }
          memo
        end

        cells_per_candidate_value.select {|candidate_value, cells| cells_in_same_box?(cells) }.
                                  each do |candidate_value, cells_in_same_box|
          # we want to reject <candidate_value> from the candidate values of the cells in the same box at <cells.first>
          # in the other rows.
          (box_by_cell_coords(*cells_in_same_box.first.coords) - cells_in_same_box).each do |cell|
            pre_rejection_candidates = cell.candidate_values
            cell.reject_candidates(tag, candidate_value)
            post_rejection_candidates = cell.candidate_values
            updated_cell_count += 1 if pre_rejection_candidates.count != post_rejection_candidates.count
          end
        end
      end
      cols.each do |col_cells|
        cells_per_candidate_value = (1..9).reduce({}) do |memo, number|
          memo[number] = col_cells.select {|cell| cell.candidate_values.include?(number) }
          memo
        end

        cells_per_candidate_value.select {|candidate_value, cells| cells_in_same_box?(cells) }.
                                  each do |candidate_value, cells_in_same_box|
          # we want to reject <candidate_value> from the candidate values of the cells in the same box at <cells.first>
          # in the other columns.
          (box_by_cell_coords(*cells_in_same_box.first.coords) - cells_in_same_box).each do |cell|
            pre_rejection_candidates = cell.candidate_values
            cell.reject_candidates(tag, candidate_value)
            post_rejection_candidates = cell.candidate_values
            updated_cell_count += 1 if pre_rejection_candidates.count != post_rejection_candidates.count
          end
        end
      end

      break if updated_cell_count == 0
    end

    true
  end

  # returns -1 on failure; otherwise, returns the number of cells that were updated
  def deduce_cell_values_from_group_of_related_cells(tag, cell_group)
    updated_cell_count = 0
    candidate_number_to_cells_map = cell_group.reduce({}) do |memo, cell|
      cell.candidate_values.each do |candidate_value|
        memo[candidate_value] ||= []
        memo[candidate_value] << cell
      end
      memo
    end
    candidate_number_to_cells_map.
      select {|candidate_value, cells| cells.count == 1 }.
      each do |candidate_value, cells|
        only_cell_in_group_with_the_associated_candidate_value = cells.first
        return -1 unless update_cell(tag, only_cell_in_group_with_the_associated_candidate_value, candidate_value)
        updated_cell_count += 1
      end

    updated_cell_count
  end

  # returns true if the board is still valid after the update; false otherwise
  def update_cell(tag, cell, value)
    cell.set(value, tag)
    update_candidate_solutions_of_neighbor_cells(tag, cell)
    cell_update_valid?(*cell.coords)
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
  ARGF.each_line do |unsolved_puzzle|
    grid = Grid.new(unsolved_puzzle)

    t1 = Time.now
    grid.solve
    t2 = Time.now
    seconds_elapsed = t2 - t1

    if seconds_elapsed > 1
      puts "puzzle:   #{unsolved_puzzle}"
      # puts Grid.new(unsolved_puzzle).to_grid
      puts "time: #{t2 - t1}"
      puts "solution: #{grid.to_s}"
      # puts grid.to_grid
      puts "valid solution? : #{grid.valid_solution?}"
    end
  end
end

main
