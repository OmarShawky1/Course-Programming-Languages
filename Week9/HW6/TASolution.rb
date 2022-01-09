=begin
. Structure
First, let's evaluate the general structure of the solution. Are there classes \verb|MyTetris|MyTetris, \verb|MyPiece|MyPiece, and \verb|MyBoard|MyBoard subclassing the appropriate classes as in the provided code? Are there no other classes? (There really should not be any need for other classes, but it is plausible an extra class is good style somehow.) Does each class definition have well-formatted method definitions?

2. Key bindings
Here we evaluate how the solution adds key bindings (related to enhancements 1 and 3) to the program. The relevant part of the sample solution looks like this (in class \verb|MyTetris|MyTetris):
=end
def key_bindings
    super
    @root.bind('u', proc { @board.rotate_clockwise; @board.rotate_clockwise })
    @root.bind('c', proc { @board.maybe_cheat })
  end
=begin
Note that \verb|maybe_cheat|maybe_cheat is a method defined in \verb|MyBoard|MyBoard that we will consider later. Overall, we are looking for a similarly short and clean way to add the two key bindings, but there are many different ways to do this:

If the solution overrides \verb|key_bindings|key_bindings, does not call \verb|super|super, and copies all the key bindings from the superclass into this method, give a 4 (which is possibly generous for so much code copying).

If the solution does not override \verb|key_bindings|key_bindings but instead puts the new bindings in a different method (or methods), that can still get a 5. The code probably needs to override \verb|initialize|initialize for \verb|MyTetris|MyTetris, including a call to \verb|super|super in \verb|initialize|initialize. As in the previous point, generously give a 4 if they override \verb|initialize|initialize but without a call to \verb|super|super.

If the new key bindings are in a poorly named method like \verb|buttons|buttons, give a 3.

We are flexible about exactly what methods the blocks passed to \verb|proc|proc use, but these blocks should be short. Deduct a point if they are more than 2-3 lines long.

3. 180-degree rotation
Here we evaluate the code for performing 180-degree-rotation. As already seen above, the sample solution uses this block:
=end
{ @board.rotate_clockwise; @board.rotate_clockwise }
#Here is another fine solution:
{ @board.rotate_counter_clockwise; @board.rotate_counter_clockwise }
#A third fine solution is to add a method to \verb|MyBoard|MyBoard and call it. Such a method could look like this:
  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2) # or 2 can be -2
    end
    draw
  end

=begin
For any solutions longer or more complicated than this, deduct at least one point.

4. Defining \verb|All_My_Pieces|All_My_Pieces
We now start considering changes needed for enhancement 2. Here we consider the class constant \verb|All_My_Pieces|All_My_Pieces in class \verb|MyPiece|MyPiece as required by the assignment. The sample solution sets this constant like this:
=end
  All_My_Pieces = All_Pieces + [
     [[[0, 0], [-1, 0], [1, 0], [2, 0], [-2,0]], # 5-long
        [[0, 0], [0, -1], [0, 1], [0, 2], [0, -2]]],
     rotations([[0, 0], [-1, 0], [1, 0], [0, -1], [-1,-1]]), # utah
     rotations([[0, 0], [1, 0], [0, 1]]) # short-L
  ]

=begin
Deduct a point if all the pieces from \verb|All_Pieces|All_Pieces are copied over into this file.

Deduct a point if the solution does not use \verb|rotations|rotations for at least one of the pieces.

5. Using \verb|All_My_Pieces|All_My_Pieces
A disappointing amount of overriding and code copying is needed to get the game to use \verb|All_My_Pieces|All_My_Pieces instead of the \verb|All_Pieces|All_Pieces constant in the superclass. The sample solution includes these relevant methods:
=end
# in MyTetris:
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self) # notice change
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
# in MyPiece:
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board) # notice change
  end
# in MyBoard:
  def initialize (game)
    @cheat = false # related to cheat piece, discussed more later
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self) # notice change
    @score = 0
    @game = game
    @delay = 500
  end

=begin
(We also override \verb|next_piece|next_piece and \verb|store_current|store_current in \verb|MyBoard|MyBoard, but we will look at those separately.) For this assessment question, see if the solution copies a roughly similar amount of code in order to use \verb|All_My_Pieces|All_My_Pieces. If much more is copied but the code is still readable, give a 4. If almost all the provided code is copied, give at most a 3, probably a 2.

6. Overriding \verb|store_current|store_current
The last necessary change for enhancement 2 is to override store_current in \verb|MyBoard|MyBoard because the provided code is broken if a Tetris piece does not have exactly 4 blocks in it. This unfortunately requires copying some code. The sample solution does it like this:
=end

# in MyPiece:
  def num_blocks
    @all_rotations[0].size
  end
# in MyBoard:
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0...(@current_block.num_blocks)).each{|index|  # notice change
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] =
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

=begin
There are various ways for an instance of \verb|MyPiece|MyPiece to compute how many blocks it has. For example, it is fine style for it to be in an instance variable of \verb|MyPiece|MyPiece that is set in \verb|initialize|initialize. It is also possible and fine for \verb|MyBoard|MyBoard to store the number of blocks in \verb|@current_block|@current_block rather than re-asking every time \verb|store_current|store_current is called.

As an example of a longer solution deserving a 3, suppose \verb|store_current|store_current was basically 4 times as long, with separate cases for when \verb|@current_block|@current_block has 1, 3, 4, or 5 blocks.

7. Remembering to use the cheat piece
We now start considering the changes needed for enhancement 3, the cheat piece. Here we consider the code to "remember" that the next piece should be the cheat piece and the code to adjust the score. The sample solution uses an instance variable \verb|@cheat|@cheat in \verb|MyBoard|MyBoard for this purpose, though the name is not important.
=end

# in MyTetris:
  def key_bindings # as already assessed above
    super
    @root.bind('u', proc { @board.rotate_clockwise; @board.rotate_clockwise })
    @root.bind('c', proc { @board.maybe_cheat })
 end
# in MyBoard:
  def maybe_cheat
    if @score >= 100 and !@cheat
      @score -= 100
      @cheat = true
    end
  end

=begin
Some specific comments:

It is fine for a solution not to deduct 100 points until later, when the cheat piece actually appears. So look to see if the update of \verb|@score|@score occurs in \verb|next_piece|next_piece instead, which is fine.

Deduct a point if the logic for deducting the score only once and not having multiple-cheats (while one piece is dropping) matter is much more complicated than in the sample solution.

8. Creating and using the cheat piece
Finally, we assess the logic for creating and using the cheat piece. The sample solution does this by overriding \verb|next_piece|next_piece (which also needs overriding just for enhancement 2):
=end

# in MyPiece:
  def self.next_cheat_piece (board)
    MyPiece.new([[[0, 0]]], board)
  end
# in MyBoard:
  def next_piece
    if (@cheat)
       @current_block = MyPiece.next_cheat_piece(self)
       @cheat = false
    else
       @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

=begin
The use of the helper method \verb|MyPiece.next_cheat_piece|MyPiece.next_cheat_piece is not needed -- you can give a 5 if the \verb|MyPiece.new([[[0,0]]], board)|MyPiece.new([[[0,0]]], board) is in \verb|next_piece|next_piece. Follow general guidelines to deduct points for solutions significantly more complicated.
=end
