(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
(* ======================================================================= *)

(* string * string list -> string list option *)
(* Eliminate a specific string from a list of string*)
(* fun all_except_option (s, los) = [] *) (* stub *)
fun all_except_option (exc, los) =
    let
         fun all_except_option_acc (los, acc, f) = 
               case los of
                  [] => if f
                            then SOME acc
                            else NONE
               |  s::los' =>  if same_string (s, exc)
                                 then all_except_option_acc(los', acc,    true)
                                 else all_except_option_acc(los', s::acc, f)
    in
        all_except_option_acc(los,[], false)
    end



(* string list list * string -> string list *)
(* Produce a concatination of lists where each list has string <S> *)
fun get_substitutions1 (Llos, s) = 
       case Llos of
            [] => []
        |    Llos::Llos' => case all_except_option(s, Llos) of
                                NONE => get_substitutions1(Llos', s)
                            |   SOME los => get_substitutions1(Llos', s)@los



(* string list list * string -> string list *)
(* Produce a concatination of lists where each list has string <S> *)
fun get_substitutions2 (Llos, s) = 
   let
    fun get_substitutions2_acc (Llos, acc) = 
        case Llos of
            [] => acc
        |   Llos::Llos' => case all_except_option(s, Llos) of
                                NONE => get_substitutions2_acc(Llos', acc)
                            |   SOME los => get_substitutions2_acc(Llos', los@acc)
   in
    get_substitutions2_acc (Llos, [])
   end
 


(* string list list * {first:string, last:string, middle:string}-> 
                                                    {first:string, last:string, middle:string} list  *)
                                                    (*  *)
(* Produce the same middle and last name for the output of get substitution::the name we are searching with  *)
(* fun similar_names (Llos, {first, middle, last}) = [] *) (* stub *)

fun similar_names (Llos, {first=f, middle=m, last=l}) = 
    let
        val LOFN = f::get_substitutions2 (Llos, f)
        fun printNames (LOFN, acc) =
                case LOFN of 
                    [] => acc
                |   LOFN::LOFN' => printNames(LOFN', [{first=LOFN, middle=m, last=l}]@acc)
    in
        printNames(LOFN, [{first=f, middle=m, last=l}])
    end


(* ======================================================================= *)
(* Problem 2 *)

 (* card -> color *)
 (* Produce the color of a card *)
 (* fun card_color (s: suit, r: rank) = Red *)
 fun card_color (c) = 
    let 
        val (suit, rank) = c;
    in
        case suit of
            Clubs => Black
        |   Spades => Black
        |   _ => Red
    end



(*  card -> int *)
(* Produce value of card *)
fun card_value (c) = 
    let 
        val (suit, rank) = c;
    in
        case rank of
            Ace => 11
        |   King => 10
        |   Queen => 10
        |   Jack => 10
        |   Num(x) => x
    end



(* card list * card * exn -> card list *)
(* Removes only one card c and raises an exception if c not found *)
fun remove_card(cs, c,e) = 
    let
        val (suit, rank) = c;
        fun remove_card_acc (cs, acc) = 
            case cs of
                [] => raise e
            |  cs::cs' =>  if cs=c
                            then acc@cs'
                            else remove_card_acc(cs', cs::acc)
    in
        remove_card_acc(cs, [])
    end



(* card list -> bool *)
(* Produce true if all cards are the same color; false otherwise *)
fun all_same_color (cs) = 
    let
        val first::cs' = cs;
        val firstColor = card_color(first);
        
        fun all_same_color_int (cs, acc) = 
                case cs of
                    [] => acc
                |   cs::cs' => all_same_color_int(cs', acc andalso (card_color(cs) = firstColor))
    in
        all_same_color_int(cs', true)
    end



(* card list -> int *)
(* Sum values of all cards *)
fun sum_cards (cs) =
    let
        fun sum_cards_acc (cs,acc) =
            case cs of
                [] => acc
            |   cs::cs' => sum_cards_acc(cs', acc+card_value (cs))
    in
        sum_cards_acc(cs,0)
    end
(* fun sum_cards (cs) =
    case cs of
        [] => 0
    |   cs::cs' => card_value (cs) + sum_cards(cs') *)



(* card list * int -> int *)
fun score (cs, s) = 
    let
        val cardsScore = sum_cards(cs);
        val prelimScore = if cardsScore>= s then (cardsScore-s) * 3 else (s-cardsScore)

    in
        if all_same_color(cs)
            then prelimScore div 2
            else prelimScore
    end



(*  card list * move list * int -> int *)
(* Runs the game (as long as ml is not empty) *)
(* cs is held cards, ml is move list, g is goal or score *)
fun officiate(cs, ml, g) = 
    let
        fun play (cs, ml, heldCards) =
                case ml of
                    [] => score(heldCards, g)
                |  Draw::ml' => if sum_cards(heldCards) < g
                                then (case cs of
                                            [] => score(heldCards, g) (* This should be base case for self reference*)
                                        |   cs::cs' => play(cs', ml', cs::heldCards) (* This should be mutual recursion*)
                                    )
                                else score(heldCards, g)
                |   (Discard c)::ml' => play(cs, ml', remove_card(heldCards, c, IllegalMove))
    in
    play(cs, ml, [])
    end

(* ======================================================================= *)
(* Tests *)
(**)
val test1 = all_except_option ("string", ["string"]) = SOME []
(* val test1_2 = all_except_option ("string", []) = NONE
val test1_3 = all_except_option ("foo",["there"]) = NONE
val test1_4 = all_except_option ("foo",["there", "foo"]) = SOME ["there"] *)
val test2 = get_substitutions1 ([["foo"],["there"]], "foo") = []
(* val test2_2 = get_substitutions1([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],"Fred") = ["F","Freddie","Fredrick"]
val test2_3 = get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]],"Jeff") = ["Jeffrey","Geoff","Jeffrey"] *)
val test3 = get_substitutions2 ([["foo"],["there"]], "foo") = []
(* val test3_2 = get_substitutions1([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],"Fred") = ["F","Freddie","Fredrick"]
val test3_3 = get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]],"Jeff") = ["Jeffrey","Geoff","Jeffrey"] *)
val test4 = similar_names 
                ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]]
                , {first="Fred", middle="W", last="Smith"}) 
                =
	             [{first="Fredrick",last="Smith",middle="W"},{first="Freddie",last="Smith",middle="W"},
                  {first="F",last="Smith",middle="W"},{first="Fred",last="Smith",middle="W"},
                  {first="Fred",last="Smith",middle="W"}]
val test5 = card_color (Clubs, Num 2) = Black
(* val test5_2 = card_color (Spades, Num 2) = Black
val test5_3 = card_color (Diamonds, Num 2) = Red
val test5_4 = card_color (Hearts, Num 2) = Red *)
val test6 = card_value (Clubs, Num 2) = 2
(* val test6_2 = card_value (Diamonds, Num 9) = 9
val test6_3 = card_value (Spades, Num 7) = 7
val test6_4 = card_value (Spades, Ace) = 11
val test6_5 = card_value (Hearts, King) = 10
val test6_6 = card_value (Diamonds, Queen) = 10
val test6_7 = card_value (Clubs, Jack) = 10 *)
val test7 = remove_card ([(Hearts, Ace)], (Hearts, Ace), IllegalMove) = []
(* val test7_2 = remove_card ([(Hearts, Ace), (Hearts, Ace)], (Hearts, Ace), IllegalMove) = [(Hearts, Ace)] *)
val test8 = all_same_color [(Hearts, Ace), (Hearts, Ace)] = true
(* val test8_2 = all_same_color [(Clubs, Num 2), (Spades, Num 2), (Spades, Num 2)] = true
val test8_3 = all_same_color [(Diamonds, Num 2), (Hearts, Num 2)] = true
val test8_4 = all_same_color [(Clubs, Num 2), (Hearts, Num 2)] = false *)
val test9 = sum_cards [(Clubs, Num 2),(Clubs, Num 2)] = 4
val test10 = score ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4

val test11 = officiate ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6

val test12 = officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                        [Draw,Draw,Draw,Draw,Draw],
                        42)
             = 3

val test13 = ((officiate([(Clubs,Jack),(Spades,Num(8))],
                         [Draw,Discard(Hearts,Jack)],
                         42);
               false) 
              handle IllegalMove => true)
(**)              