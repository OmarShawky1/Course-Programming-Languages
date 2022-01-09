# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  # class array holding all the pieces and their rotations
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
      board.score -= 100
      MyPiece.new([[0,0]], board)
      @cheat = false
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

  # TODO: Implement this function:
          # 1- If score is less than 100, skip, otherwise, player loses 100 points & a new single box will drop
  def cheat
    if @score < 100
        puts "Can't cheat now" #Didn't know what to do to make it do nothing
    else
      # @score -= 100 ;should be done only when the cheat piece is done
      next_cheat_piece
    end
  end
  
  def next_cheat_piece
    # @current_block = MyPiece.next_cheat_piece(self)
    # @current_pos = nil
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
