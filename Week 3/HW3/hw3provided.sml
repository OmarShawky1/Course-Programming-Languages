(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

(* string list -> string list *)
(* Produces the list items that is only Capitalized *)
fun only_capitals los = List.filter (fn s => (Char.isUpper(String.sub(s, 0)))) los;

(* string list -> string *)
(* Produces the longest string in a list *)
fun longest_string1 los = foldl (fn (s,acc) => 
									(if (String.size(s) > String.size(acc)) 
										then s 
										else acc)) 
						  "" los;

(* string list -> string *)
(* Produces the longest string in a list *)
fun longest_string2 los = foldl (fn (s,acc) => 
									(if (String.size(s) >= String.size(acc)) 
										then s 
										else acc)) 
						  "" los;

(* (int * int -> bool) -> string list -> string *)
fun longest_string_helper f los = foldl (fn (s,acc) => if (f (String.size(s), String.size(acc))) then s else acc) "" los;

val longest_string3 = longest_string_helper (fn (s, acc) => s > acc);

val longest_string4 = longest_string_helper (fn (s, acc) => s >= acc);

(* string list -> string *)
fun longest_capitalized los = longest_string3 (only_capitals(los));

(* string -> string *)
fun rev_string s = (implode o rev o explode) s;

(* (’a -> ’b option) -> ’a list -> ’b *)
fun first_answer f lop = 
	case lop of
		 [] => raise NoAnswer
	|	lop::lop' => (case (f lop) of
							NONE => first_answer f lop'
						|	SOME x => x)

(* (’a -> ’b list option) -> ’a list -> ’b list option *)
(* Both answers are similar *)
fun all_answers f lop =
	let
		fun all_answers_acc acc lop = 
			case lop of
				[] => SOME acc
			|	lop::lop' => (case (f lop) of
									NONE => NONE
								|	SOME x => all_answers_acc (x@acc) lop');
	in
		all_answers_acc [] lop
	end
	
(* fun all_answers f lop =
	let
		fun all_answers_acc acc lop = 
			case lop of
				[] => acc
			|	lop::lop' => (case (f lop) of
									NONE => []
								|	SOME [x] => all_answers_acc (x::acc) lop');

	in
		if null (all_answers_acc [] lop) then NONE else SOME (all_answers_acc [] lop)
	end *)

(* pattern -> int *)
val count_wildcards = g (fn () => 1) (fn x => 0)

(* pattern -> int *)
val count_wild_and_variable_lengths = g (fn () => 1) (fn x => String.size (x))

(* string * pattern -> int *)
fun count_some_var (s, p) = g (fn () => 0) (fn (p) => if (s = p) then 1 else 0) p

(* ListOfPattern -> Pattern -> String List -> List.exists (function) ->  bool*)
val check_pat =
    let fun patternToVars p =
            case p of
                Variable s => [s]
              | TupleP lop => List.foldl (fn (p, acc) => (patternToVars p) @ acc) [] lop
			  | ConstructorP (_,p) => patternToVars p
              | _ => []
        
		fun isDuplicated lov =
            case lov of
                [] => false
              | lov::lov' => List.exists (fn prevString => prevString = lov) lov' orelse isDuplicated lov'
    in
        not o isDuplicated o patternToVars 
		(* TODO: Cannot understand why `not o` works but `not` does not, duplicate returns bool in all 
		cases and there is no need for piping*)
	end

(* valu * pattern -> (string * valu) list option *)
fun match (v, p) = 
	case (v,p) of
		(_, Wildcard) =>  SOME []
	|	(_, Variable s) => SOME [(s, v)]
	|	(Unit, UnitP) => SOME []
	|	(Const i, ConstP j) => if i=j then SOME [] else NONE
	|	(Tuple vs, TupleP ps) => (if (length (vs) = length(ps))
									then all_answers match (ListPair.zip(vs, ps))
									else NONE)
	|	(Constructor(sv, v), ConstructorP (sp, p)) => (if (sv=sp) then (match (v,p)) else NONE)
	|   _ => NONE

(* valu -> pattern list -> (string * valu) list option *)
fun first_match v lop = 
	SOME (first_answer (fn p => match(v, p)) lop) handle NoAnswer => NONE

(* This solution is working and passing all the tests but refused because he wants me to 
use first_answer and to handle NoAnswers *)
(* fun first_match (v, lop) = 
	case (v, lop) of 
		(v, []) => NONE
	|	(v, lop::lop') => case match (v, lop) of 
								NONE => first_match (v, lop')
							|	SOME [x] =>  SOME [x] *)

(* ========================================================================= *)
(* Tests *)

val test1   = only_capitals ["A","B","C"] = ["A","B","C"]
val test1_2 = only_capitals ["a","b","c"] = []
val test1_3 = only_capitals ["a","B","c"] = ["B"]

val test2   = longest_string1 ["A","bc","C"] = "bc"
val test2_2 = longest_string1 ["A","bc","C", ""] = "bc"
val test2_3 = longest_string1 ["A","b2c","C"] = "b2c"
val test2_4 = longest_string1 ["A","bc","CC"] = "bc"
val test2_5 = longest_string1 ["A","bc","CCc"] = "CCc"

val test3   = longest_string2 ["A","bc","C"] = "bc"
val test3_2 = longest_string2 ["A","bc","C", ""] = "bc"
val test3_3 = longest_string2 ["A","b2c","CC"] = "b2c"
val test3_4 = longest_string2 ["A","bc","CC"] = "CC"
val test3_5 = longest_string2 ["A","bc","CCc"] = "CCc"

val test4a   = longest_string3 ["A","bc","C"] = "bc"
val test4a_2 = longest_string3 ["A","bc","C", ""] = "bc"
val test4a_3 = longest_string3 ["A","b2c","C"] = "b2c"
val test4a_4 = longest_string3 ["A","bc","CC"] = "bc"
val test4a_5 = longest_string3 ["A","bc","CCc"] = "CCc"

val test4b   = longest_string4 ["A","B","C"] = "C"
val test4b_2 = longest_string4 ["A","bc","C", ""] = "bc"
val test4b_3 = longest_string4 ["A","b2c","CC"] = "b2c"
val test4b_4 = longest_string4 ["A","bc","CC"] = "CC"
val test4b_5 = longest_string4 ["A","bc","CCc"] = "CCc"

val test5   = longest_capitalized ["A","bc","C"] = "A"
val test5_2 = longest_capitalized ["A","Bc","C"] = "Bc"
val test5_3 = longest_capitalized ["A","BC","C"] = "BC"
val test5_4 = longest_capitalized ["A","bcawadw","C"] = "A"

val test6 = rev_string "abc" = "cba"

val test7 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4

val test8   = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE
val test8_2 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [1,1,1,1] = SOME [1,1,1,1]
val test8_3 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [1,1,1,2] = NONE

val test9a   = count_wildcards Wildcard = 1
val test9a_2 = count_wildcards (Variable "x") = 0
val test9a_3 = count_wildcards (TupleP [Variable("a"), Variable("b")]) = 0;
val test9a_4 = count_wildcards (TupleP [Variable("a"), Wildcard]) = 1;
val test9a_5 = count_wildcards (TupleP [Wildcard, Wildcard]) = 2;

val test9b   = count_wild_and_variable_lengths (Variable("a")) = 1
val test9b_2 = count_wild_and_variable_lengths (Variable("a")) = 1;
val test9b_3 = count_wild_and_variable_lengths (TupleP [Variable("abc"), Wildcard]) = 4;

val test9c   = count_some_var ("x", Variable("x")) = 1
val test9c_2 = count_some_var ("x", Variable("A")) = 0
val test9c_3 = count_some_var ("x", Variable("xA")) = 0

val test10   = check_pat (Variable("x")) = true
val test10_2 = check_pat (TupleP [Variable("x"), Variable("y"), Variable("x")]) = false;
val test10_3 = check_pat (TupleP [Variable("x"), Variable("y"), Variable("z")]) = true;
val test10_4 = check_pat (ConstructorP ("hi", TupleP[Variable "x",Variable "x"])) = false;
val test10_5 = check_pat (ConstructorP ("hi",TupleP[Variable "x",ConstructorP ("yo",TupleP[Variable "x",UnitP])])) = false;

val test11   = match (Const(1), UnitP) = NONE
val test11_2 = match (Tuple [Unit, Const 3, Const 2],      TupleP [Variable "1", ConstP 3, Wildcard]) 
			 = SOME [("1",Unit)];
val test11_3 = match (Tuple [Unit, Tuple [Const 3]],       TupleP [Variable "1", TupleP [Variable "123"]]) 
			 = SOME [("123",Const 3),("1",Unit)];
val test11_4 = match (Tuple [Unit, Tuple [Const 3, Unit]], TupleP [Variable "1", TupleP [Variable "123", ConstP 3]]) 
			 = NONE (*Because ConstP 3 and Unit (the very last item in each tuple) produce NONE which is makes the overall NONE*)

val test12   = first_match Unit [UnitP] = SOME []
val test12_2 = first_match (Const 3) [UnitP, ConstP 3] = SOME [];
val test12_3 = first_match (Const 3) [UnitP, Variable "f"] = SOME [("f", Const 3)];
val test12_4 = first_match (Const 3) [UnitP, TupleP[]] = NONE;