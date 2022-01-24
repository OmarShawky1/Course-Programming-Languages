=begin
1. \verb|eval_prog|eval_prog for geometry values
Here we will assess implementing \verb|eval_prog|eval_prog for the subclasses of \verb|GeometryValue|GeometryValue, i.e., classes \verb|NoPoints|NoPoints (which was provided), \verb|Point|Point, \verb|Line|Line, \verb|VerticalLine|VerticalLine, and \verb|LineSegment|LineSegment. In all cases the correct solution is just:
=end

  def eval_prog env
    self
  end

=begin
Give a 5 for two different solutions: Putting such a method definition in each class or putting one such definition in the \verb|GeometryValue|GeometryValue superclass. (The inheritance approach is good OOP style, but it is less similar to the provided ML code, which did not use the analogous approach of a wildcard pattern.) You can also give a 5 for solutions that return copies, such as the method in \verb|Point|Point returning \verb|Point.new(@x,@y)|Point.new(@x,@y). This is unnecessary since the objects do not have setter methods, but it is not terrible style.

2. \verb|eval_prog|eval_prog for non-value geometry expressions
Here we will assess the \verb|eval_prog|eval_prog methods for the non-value classes (\verb|Intersect|Intersect, \verb|Let|Let, \verb|Var|Var, and \verb|Shift|Shift). Here are sample solutions:
=end
# in Intersect
   def eval_prog env
    @e1.eval_prog(env).intersect @e2.eval_prog(env)
  end
# in Let
  def eval_prog env
    @e2.eval_prog([[@s,@e1.eval_prog(env)]] + env)
  end
# in Var
  def eval_prog env
    pr = env.assoc @s
    raise "undefined variable" if pr.nil?
    pr[1]
  end
# in Shift
  def eval_prog env
    @e.eval_prog(env).shift(@dx,@dy)
  end

=begin
18
# in Intersect
   def eval_prog env
    @e1.eval_prog(env).intersect @e2.eval_prog(env)
  end
# in Let
  def eval_prog env
    @e2.eval_prog([[@s,@e1.eval_prog(env)]] + env)
  end
# in Var
  def eval_prog env
    pr = env.assoc @s
    raise "undefined variable" if pr.nil?
    pr[1]
  end
# in Shift
  def eval_prog env
    @e.eval_prog(env).shift(@dx,@dy)
  end
The key thing to evaluate is that the solutions invoke methods on the results of the recursion, particularly the \verb|intersect|intersect method call in the \verb|Intersect|Intersect class and the \verb|shift|shift method call in the \verb|Shift|Shift class. Give at most a 3 for not using such a coding pattern. Be more flexible on other details of the method definitions. For example, it is fine to use local variables more than the sample solution.

3. \verb|preprocess_prog|preprocess_prog for geometry values
Here we assess the \verb|preprocess_prog|preprocess_prog methods in the subclasses of \verb|GeometryValue|GeometryValue. Here are sample solutions:
=end

# in Point
  def preprocess_prog
    self
  end
# in Line
  def preprocess_prog
    self
  end
# in VerticalLine
  def preprocess_prog
    self
  end
# in LineSegment
  def preprocess_prog
    if real_close_point(@x1,@y1,@x2,@y2)
      Point.new(@x1,@y1)
    elsif real_close(@x1,@x2)
      if @y1 > @y2
        LineSegment.new(@x2,@y2,@x1,@y1)
      else
        self
      end
    elsif @x1 > @x2
      LineSegment.new(@x2,@y2,@x1,@y1)
    else
      self
    end
  end

=begin
As when assessing \verb|eval_prog|eval_prog for the subclasses of \verb|GeometryValue|GeometryValue, it is also fine to define a method in \verb|GeometryValue|GeometryValue that returns \verb|self|self. You then still need a definition in \verb|LineSegment|LineSegment that overrides this method.

Also as with \verb|eval_prog|eval_prog, it is okay, although a bit wasteful, to return copies of objects instead of \verb|self|self.

For the \verb|LineSegment|LineSegment case, look for clear logic for the four different cases: converting to a point, flipping order for a non-vertical segment, flipping order for a vertical segment, and not changing anything.

4. \verb|preprocess_prog|preprocess_prog for non-value geometry expressions
Here we will assess the \verb|preprocess_prog|preprocess_prog methods for the non-value classes (\verb|Intersect|Intersect, \verb|Let|Let, \verb|Var|Var, and \verb|Shift|Shift). Here are sample solutions:
=end
# in Intersect
  def preprocess_prog
    Intersect.new(@e1.preprocess_prog,
                  @e2.preprocess_prog)
  end
# in Let
  def preprocess_prog
    Let.new(@s, @e1.preprocess_prog, @e2.preprocess_prog)
  end
# in Var
  def preprocess_prog
    self
  end
# in Shift
  def preprocess_prog
    Shift.new(@dx,@dy,@e.preprocess_prog)
  end

=begin
All these cases should have the simple recursive form above, though of course the coding details need not be identical. It is okay if the case for \verb|Var|Var makes a new object, like \verb|Var.new(@s)|Var.new(@s). Give at most a 4 for significantly more complicated solutions, which may result if the solution tries to avoid creating new objects when the subexpressions do not change. (There is some small benefit in this, but it is not worth the complication.)

5. Shifting
Here we assess implementing shifting by having a \verb|shift|shift method in each of the subclasses of \verb|GeometryValue|GeometryValue. Give at most a 3 if there are shift methods in the other classes (e.g., \verb|Intersect|Intersect) as this is not necessary -- such methods would never be used. (You can give a 5 if these methods exist but immediately raise an error.) Here are sample solutions:
=end
# in Point
  def shift(dx,dy) 
    Point.new(@x + dx, @y + dy)
  end
# in Line
  def shift(dx,dy)
    Line.new(@m, @m*(-dx) + @b + dy)
  end
# in VerticalLine
  def shift(dx,dy)
    VerticalLine.new(@x+dx)
  end
# in LineSegment
  def shift(dx,dy)
    LineSegment.new(@x1+dx,@y1+dy,@x2+dx,@y2+dy)
  end

=begin
Give at most a 3 if these classes do not each have a \verb|shift|shift method. Other coding details are not important. In particular, it is fine to use getter methods, like \verb|x1|x1 or \verb|x1()|x1() instead of \verb|@x1|@x1.

6. \verb|intersect|intersect for geometry values
Here we assess the \verb|intersect|intersect methods in the subclasses of \verb|GeometryValue|GeometryValue. These implement the first dispatch in the double-dispatch pattern. They should look like this:
=end

# in Point
  def intersect other
    other.intersectPoint self
  end
# in Line
  def intersect other
    other.intersectLine self
  end
# in VerticalLine
  def intersect other
    other.intersectVerticalLine self
  end
# in LineSegment
  def intersect other
    other.intersectLineSegment self
  end

=begin
Give at most a 3 for significantly more complicated solutions or solutions that use something like \verb|is_a?|is_a?. Give at most a 3 for solutions that include \verb|intersect|intersect methods in non-value classes, unless those methods immediately raise an explicit error.

7. Intersection (not involving \verb|NoPoints|NoPoints or \verb|LineSegment|LineSegment)
Here we assess the 9 cases of intersection that involve neither instances of \verb|NoPoints|NoPoints nor instances of \verb|LineSegment|LineSegment. These 9 cases should be handled with methods called \verb|intersectPoint|intersectPoint, \verb|intersectLine|intersectLine, and \verb|intersectVerticalLine|intersectVerticalLine in each of the classes \verb|Point|Point, \verb|Line|Line, and \verb|VerticalLine|VerticalLine (9 methods total). In the sample solution below, we use commutativity to avoid repeating computations, but it is okay if a solution does not do this or if it reverses which cases rely on which others using commutativity.
=end
# in Point
  def intersectPoint p
    if real_close_point(@x,@y,p.x,p.y) then self else NoPoints.new end
  end
  def intersectLine line
    if real_close(@y, line.m * @x + line.b) then self else NoPoints.new end
  end
  def intersectVerticalLine vline
    if real_close(@x, vline.x) then self else NoPoints.new end
  end
# in Line
  def intersectPoint p
    p.intersectLine self
  end
  def intersectLine line
    if real_close(m,line.m)
      (if real_close(b,line.b)
         self # same line
       else
         NoPoints.new # parallel lines do not intersect
       end)
    else # one-point intersection
      x = (line.b - b).to_f / (m - line.m)
      y = m * x + b
      Point.new(x,y)
    end
  end
  def intersectVerticalLine vline
    Point.new(vline.x, m * vline.x + b)
  end
# in VerticalLine
  def intersectPoint p
    p.intersectVerticalLine self
  end
  def intersectLine line
    line.intersectVerticalLine self
  end
  def intersectVerticalLine vline
    if real_close(x,vline.x)
      self # same line
    else
      NoPoints.new # parallel
    end
  end

=begin
Give at most a 3 to solutions not having 9 methods as outlined above or having solutions that use \verb|is_a?|is_a? or similar methods. Within the method bodies, the code should be similar to the provided ML code but be flexible on the details. In particular, it is okay to return a new object rather than \verb|self|self in some places.

8. Other intersect methods in \verb|LineSegment|LineSegment
Here we assess that the \verb|LineSegment|LineSegment class also needs methods \verb|intersectPoint|intersectPoint, \verb|intersectLine|intersectLine, and \verb|intersectVerticalLine|intersectVerticalLine. Here is a sample solution:
=end

# in LineSegment
  def intersectPoint p
    p.intersectLineSegment self
  end
  def intersectLine line
    line.intersectLineSegment self
  end
  def intersectVerticalLine vline
    vline.intersectLineSegment self
  end
=begin
There may be other fine ways to implement this part of the assignment. But give a 4 for solutions that copy the code in the \verb|intersectLineSegment|intersectLineSegment method, for example:
=end
def intersectPoint p
    line_result = p.intersect(two_points_to_line(x1,y1,x2,y2))
    line_result.intersectWithSegmentAsLineResult self
  end

=begin
9. \verb|intersectWithSegmentAsLineResult|intersectWithSegmentAsLineResult
Finally, we assess the implementations of \verb|intersectWithSegmentAsLineResult|intersectWithSegmentAsLineResult. For the longer ones, the solution is unlikely to look exactly like the sample solution, which, as always, is fine. Give at most a 3 to solutions that use \verb|is_a?|is_a? or similar methods.
=end

# in Point
  def intersectWithSegmentAsLineResult seg
    if inbetween(@x,seg.x1,seg.x2) && inbetween(@y,seg.y1,seg.y2)
      self
    else
      NoPoints.new
    end
  end
  private
  def inbetween(v,end1,end2)
    eps = GeometryExpression::Epsilon
    ((end1 - eps <= v && v <= end2 + eps) ||
     (end2 - eps <= v && v <= end1 + eps))
  end
# in Line
  def intersectWithSegmentAsLineResult seg
    seg # so segment seg in on line represented by self
  end
# in Vertical Line
  def intersectWithSegmentAsLineResult seg
    seg # so segment seg in on vertical line represented by self
  end
# in LineSegment
  def intersectWithSegmentAsLineResult seg
    # the "hard case in the hard case" where self and seg are segments
    # on the same line (which could be vertical or not) and the segments
    # could be disjoint, overlapping, one inside the other or just touching
    if real_close(@x1,@x2)
      # the segments are on a vertical line
      # let segment a start at or below start of segment b
      aXstart,aYstart,aXend,aYend,bXstart,bYstart,bXend,bYend =
        if @y1 < seg.y1
          [@x1,@y1,@x2,@y2,seg.x1,seg.y1,seg.x2,seg.y2]
        else
          [seg.x1,seg.y1,seg.x2,seg.y2,@x1,@y1,@x2,@y2]
        end
      if real_close(aYend,bYstart)
        Point.new(aXend,aYend) # just touching
      elsif aYend < bYstart
        NoPoints.new # disjoint
      elsif aYend > bYend
        LineSegment.new(bXstart,bYstart,bXend,bYend) # b inside a
      else
        LineSegment.new(bXstart,bYstart,aXend,aYend) # overlapping
      end
    else
      # the segments are on a non-vertical line
      # let segment a start at or to the left of start of segment b
      aXstart,aYstart,aXend,aYend,bXstart,bYstart,bXend,bYend =
        if @x1 < seg.x1
          [@x1,@y1,@x2,@y2,seg.x1,seg.y1,seg.x2,seg.y2]
        else
          [seg.x1,seg.y1,seg.x2,seg.y2,@x1,@y1,@x2,@y2]
        end
      if real_close(aXend,bXstart)
        Point.new(aXend,aYend) # just touching
      elsif aXend < bXstart
        NoPoints.new # disjoint
      elsif aXend > bXend
        LineSegment.new(bXstart,bYstart,bXend,bYend) # b inside a
      else
        LineSegment.new(bXstart,bYstart,aXend,aYend) # overlapping
      end
    end
  end
