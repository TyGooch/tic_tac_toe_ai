require_relative 'tic_tac_toe'

require 'byebug'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @prev_move_pos = prev_move_pos
    @board = board
    @next_mover_mark = next_mover_mark
  end

  def losing_node?(evaluator)
    if @board.over?
      return @board.won? && board.winner != evaluator
    end

    if evaluator == next_mover_mark
      children.all? {|node| node.losing_node?(evaluator)}
    else
      children.any? {|node| node.losing_node?(evaluator)}
    end

  end

  def winning_node?(evaluator)
    #base cases
    if @board.over?
      return @board.winner == evaluator
    end

    # output = false
    if evaluator == next_mover_mark
      return children.any? do |node|
        node.winning_node?(switch_mark(evaluator))
      end
    else
      return children.all? do |node|
          node.winning_node?(switch_mark(evaluator))
      end
    end
    # false
  end

  def switch_mark(mark)
    mark == :x ? :o : :x
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    possible = []
    @board.rows.each_with_index do |r, row|
      r.each_with_index do |square, col|
        possible << create_child([row, col]) if square.nil?
      end
    end
    @possible_moves = possible
  end

  def create_child(pos)
    child_board = board.dup
    child_board[pos] = next_mover_mark
    child_next_mark = switch_mark(next_mover_mark)
    child = TicTacToeNode.new(child_board, child_next_mark, pos)
    #child
  end

end
