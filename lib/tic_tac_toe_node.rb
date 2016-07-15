require_relative 'tic_tac_toe'

require 'byebug'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @prev_move_pos = prev_move_pos
    @board = board
    @next_mover_mark = next_mover_mark
    @possible_moves = children
  end

  def losing_node?(evaluator)
    if @board.over?
      if @board.winner.nil?
        return true
      elsif @board.winner == evaluator
        return false
      else
        return true
      end
    end

    return any_possible(evaluator) || all_possible(evaluator)
    # if evaluator == next_mover_mark
    #   return any_possible(evaluator) || all_possible(evaluator)
    # else
    #   return any_possible(evaluator) || all_possible(evaluator)
    # end
  end

  def any_possible(evaluator)
    @possible_moves.any? do |node|
      node.losing_node?(switch_mark(evaluator))
    end
  end

  def all_possible(evaluator)
    @possible_moves.all? do |node|
      node.losing_node?(switch_mark(evaluator))
    end
  end

  def winning_node?(evaluator)
    #base cases
    if @board.over?
      if @board.winner.nil?
        return false
      elsif @board.winner == evaluator
        return true
      else
        return false
      end
    end

    # output = false
    if evaluator == next_mover_mark
      return @possible_moves.all? do |node|
          node.winning_node?(switch_mark(evaluator))
      end
    else
      return @possible_moves.any? do |node|
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
