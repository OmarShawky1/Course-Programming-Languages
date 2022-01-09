# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  # class array holding all the pieces and their rotations
  # The Below code is much concantenated and avoids repetition but the grader will give you zero 
  # because Ruby 2.3 did not have append method.
  # All_My_Pieces = All_Pieces.append(rotations([[0, 0], [1, 0], [0, 1], [1, 1], [0,2]]), # first shape
  #                                    rotations([[0, 0], [-1, 0], [1, 0], [2, 0], [-2, 0]]), # second shape
  #                                    rotations([[0, 0], [1, 0], [1, 1]])) # third shape
  All_My_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
                  rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
                  [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
                  [[0, 0], [0, -1], [0, 1], [0, 2]]],
                  rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
                  rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
                  rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
                  rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
                  rotations([[0, 0], [1, 0], [0, 1], [1, 1], [0,2]]), # first shape
                  rotations([[0, 0], [-1, 0], [1, 0], [2, 0], [-2, 0]]), # second shape
                  rotations([[0, 0], [1, 0], [1, 1]])] # third shape
  # your enhancements here
  # class method to choose the next piece
  def self.next_piece (board)
    if @cheat
      board.decrease_100_score
      @cheat = false
      MyPiece.new([[0,0]], board)
    else
      MyPiece.new(All_My_Pieces.sample, board)
    end
  end

  def self.next_cheat_piece
    @cheat = true
  end
end

class MyBoard < Board
  # your enhancements here

  def initialize (game)
    super
    @current_block = MyPiece.next_piece(self)
  end

  # gets the next piece
  def next_piece
    @current_block = MyPiece.next_piece(self)
    @current_pos = nil
  end

  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, -2)
    end
    draw
  end

  # overriding store-current to support new pieces
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.size - 1)).each{|index|
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] =
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end


  def cheat
    if @score >= 100
      next_cheat_piece
    end
  end

  def decrease_100_score
    @score -= 100
  end
  
  def next_cheat_piece
    MyPiece.next_cheat_piece
  end

end

class MyTetris < Tetris
  # your enhancements here
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings  
    super
    @root.bind('u', proc {@board.rotate_180})
    @root.bind('c', proc {@board.cheat})
  end
end
