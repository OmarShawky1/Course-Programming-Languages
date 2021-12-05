(* Data Definitions *)
(* Date D is <d : (int * int * int)>*)
(* D is integer list with length of 3; 
    First int represents year,  
    Second int represents month,
    Third int represents day*)
(* fun fn-for-d (d: (int * int * int)) =
    ... (#1 d)
        (#2 d)
        (#3 d)
        *)

(* Note i shold've implemented a list of dates data definition, 
but i wanted to make things quick because assignment is simple *)

(* ============================================================== *)
(* Functions *)

(* (int * int * int) -> Boolean *)
(* Checks if the date provided is real, if year is natural, month is >=1 or <=12 and if day is <31 *)
(* dateIsReal (d: (int * int * int)) = false (*stub*) *)
fun dateIsReal (d: (int * int * int)) =
    let
    val realYear = ((#1 d > 0))
    val realMonth = ((#2 d) >= 1) andalso ((#2 d) <= 12)
    val realDay = ((#3 d) >= 1) andalso ((#3 d) <= 31)
    in
    realYear andalso realMonth andalso realDay
    end



(* int * int -> Boolean *)
(* produce true if first number is smaller than the second; false otherwise *)
fun smaller (n1: int, n2: int) = 
    n1 < n2

(* int * int -> Boolean *)
(* produce true if first number equals second number; false otherwise *)
fun equal (n1: int, n2: int) = 
    n1 = n2

 (* (int * int * int) list * int -> int *)
(* produce true if the first date is smaller than second date; flase if it is younger, error otherwise *)
(* fun is_older (d1: (int * int * int), d2: (int * int * int))= false *) (* stub*)
fun is_older (d1: (int * int * int), d2: (int * int * int)) =
    let
    (* the simple functions and constants are introduced to make it more readable *)
        val year = smaller(((#1 d1), (#1 d2))) (*years yoounger*)
        val yearEq = equal ((#1 d1), (#1 d2))
        val month = yearEq andalso smaller ((#2 d1, (#2 d2))) (*months younger*)
        val monthEq = equal ((#2 d1), (#2 d2))
        val day = yearEq andalso monthEq andalso smaller ((#3 d1), (#3 d2)) (*days younger*)
    in 
    if dateIsReal (d1) andalso dateIsReal (d2)
        then year orelse month orelse day
        else false
    end



(* (int * int * int) * int -> boolean *)
(* produce true if months matches; false otherwise *)
fun monthsMatches (d: (int * int * int) ,m: int) =
    ((#2 d) = m)



(* (int * int * int) list * list -> int *)
(* Produce number of occurence of certain months within a certain list of dates*)
(* fun number_in_months(LoD: (int * int * int) list),m: int) = 0 *)
fun number_in_month (LoD: (int * int * int) list, m: int) = 
    (* Could've checked if the tail is null instead but that means twice questions each time and this is much lighter *)
    if null LoD
        then 0 (* return month 0 in order not to be counter and escape multiple checks*)
        else if monthsMatches(((hd LoD)), m)
            then number_in_month (tl LoD, m) + 1
            else number_in_month (tl LoD, m)



(* int list * int -> boolean *)
(* produces true if the list contains a specific number; false otherwise *)
(* This was used in commented functions and now it is commented because it is not used *)
(*
fun contains (lon, n) = 
    if null lon
        then false
        else if (hd lon) = n (*could have used monthsMatches but it will not serve anything*)
                then true
                else contains (tl lon, n)
*)
(* (int * int * int) list * int list -> int) *)
(* Produce number of occurence of certain months within a certain list of dates*)
(* fun number_in_months(LoD: (int * int * int) list),LoM: int list) = 0 *)
fun number_in_months (LoD: (int * int * int) list, LoM: int list) = 
    if null LoM
    then 0 
    else number_in_months(LoD, (tl LoM)) + number_in_month(LoD, (hd LoM))
(* An Alternative implementation that does not depend on the above functions
fun number_in_months (LoD: (int * int * int) list, LoM: int list) = 
    (* Could've checked if the tail is null instead but that means twice questions each time and this is much lighter *)
    if null LoD
        then 0 (* return month 0 in order not to be counter and escape multiple checks*)
        else if contains (LoM, (#2 (hd LoD)))
            then number_in_months (tl LoD, LoM) + 1
            else number_in_months (tl LoD, LoM)
*)


(* (int * int * int) list * int -> (int * int * int) list *)
(* produce the dates  that has specific month *)
(* fun dates_in_month (LoD: (int * int * int) list),m: int)= [] *)
fun dates_in_month (LoD: (int * int * int) list,m: int) =
    if null LoD
        then []
        else if monthsMatches(((hd LoD)), m)
            then [(hd LoD)]@dates_in_month (tl LoD, m) (* tailed recursion, couldn't resolve issue because not familiar with language*)
            else dates_in_month (tl LoD, m)


(* (int * int * int) list * int list -> (int * int * int) list *)
(* produce the dates  that has specific month *)
(* fun dates_in_month (LoD: (int * int * int) list),LoM: int list)= [] *)
fun dates_in_months (LoD: (int * int * int) list,LoM: int list) =
    if null LoM
    then dates_in_month(LoD, 0)
    else dates_in_month(LoD, (hd LoM))@dates_in_months(LoD, (tl LoM))
    (* The below is the tailed recursion which produces the same output as the test but reverted.
    did not want to change the test thus, i commented this out *)
    (* else dates_in_months(LoD, (tl LoM))@dates_in_month(LoD, (hd LoM)) *)

(* An Alternative implementation that does not depend on the above functions
fun dates_in_months (LoD: (int * int * int) list,LoM: int list) =
    if null LoD
        then []
        else if contains (LoM, (#2 (hd LoD)))
            then [(hd LoD)]@dates_in_months (tl LoD, LoM) (* tailed recursion, couldn't resolve issue because not familiar with language*)
            else dates_in_months (tl LoD, LoM)
*)


(* string list * int -> string *)
(* Produce the list nth element but counting from 1 instead of 0*)
(* fun get_nth(los: string list,n: int) = "" *) (*stub*)
fun get_nth(los: string list,n: int) =
    if null los
    then ""
    else if (n=1)
            then (hd los)
            else get_nth((tl los), n-1)
 


(* int * int * int -> string *)
(* convert date from list of int to string *)
(* fun date_to_string(y: int, m: int, d: int) = "" *) (*stub*)
fun date_to_string(y: int, m: int, d: int) =
    let
    val months = ["January", "February", "March", "April", "May", "June", "July", "August",
    "September", "October", "November", "December"]
    in
    get_nth(months, m)^" "^Int.toString(d)^", "^Int.toString(y)
    end



(*  int * int list -> int *)
(* produce the last index in a list that if all numbers before this index 
(and including index) are summed up, they will be less than the given number *)
(* fun number_before_reaching_sum(sum: int, list: int list) = 0 *)  (*stub*)
fun number_before_reaching_sum(sum: int, list: int list) =
    (* Could've used an accumulator to make it easier but it was not taught to us *)
    if null list
        then 0
        else if ((sum-(hd list)) > 0)
                then number_before_reaching_sum((sum-(hd list)), (tl list)) + 1
                else 0



(* int -> int *)
(* produce the current month from the day in a year *)
(* fun what_month (DiY: int) = 0 *) (*stub*)
fun what_month (DiY: int) =
    (* Old function that was quite simple yet the Prof required much sophisticated one
        if ((DiY mod 30) > 0)
            then (DiY div 30) +1
            else (DiY div 30)
    *)
    let
    val D = 365 (*Days in an entire year*)
    val December = D - 31
    val November = December - 30
    val October = November - 31
    val September = October - 30
    val August = September- 31
    val July = August - 31
    val June = July - 30
    val May = June - 31
    val April = May - 30
    val March = April - 31
    val February = March - 28
    val January = February - 31 (* Unecessary check, left for convenience *)
    in
        if DiY > December then 12
            else if DiY > November then 11
                else if DiY > October then 10
                    else if DiY > September then 9
                        else if DiY > August then 8
                            else if DiY > July then 7
                                else if DiY > June then 6
                                    else if DiY > May then 5
                                        else if DiY > April then 4
                                            else if DiY > March then 3
                                                else if DiY > February then 2
                                                    else 1
    end


(* : int * int -> int list *)
(* Produce the what_month of each day between D1 and D2 *)
(* fun month_range (D1: int, D2: int) = [] *) (*stub*)
fun month_range (D1: int, D2: int) =
    if (D1>D2)
        then []
        else [what_month(D1)]@month_range(D1+1, D2)



 (* (int * int * int) list -> (int * int * int) option *)
 (* Produce the oldest date of D1 & D2 *)
 (* fun oldest(LoD: (int * int * int) list) = SOME (hd LoD) *) (*stub*)
fun oldest(LoD: (int * int * int) list) = 
    let
    fun returnOlder (currentDate: int * int * int, dates: (int * int * int) list) = 
        if null dates
            then currentDate
            else if is_older(currentDate, (hd dates))
                    then (returnOlder (currentDate, (tl dates)))
                    else (returnOlder ((hd dates), (tl dates)))
    in
    if null LoD
        then NONE
        else SOME(returnOlder ((hd LoD), (tl LoD)))
    end


(* Challenge Problems *)

(* (int * int * int * int) -> (int * int * int) *)
(* Remove the duplication in time *)
fun correctLoDRep (LoDRep: (int * int * int * int) list) = 
    if null (tl LoDRep)
        then [((#1 (hd LoDRep)), (#3 (hd LoDRep)), (#4 (hd LoDRep)))]
        else [((#1 (hd LoDRep)), (#3 (hd LoDRep)), (#4 (hd LoDRep)))]@ correctLoDRep(tl LoDRep)

fun number_in_months_challenge (LoDRep: (int * int * int * int) list, LoM: int list) = 
    let
    val LoD = correctLoDRep(LoDRep)
    in 
    number_in_months (LoD, LoM)
    end

(* ============================================================== *)
(* Tests *)
(*
val test1 = is_older ((1,2,3),(2,3,4)) = true
val test2 = number_in_month ([(2012,2,28),(2013,12,1)],2) = 1
val test3 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = 3
val test4 = dates_in_month ([(2012,2,28),(2013,12,1)],2) = [(2012,2,28)]
val test5 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)]
val test6 = get_nth (["hi", "there", "how", "are", "you"], 2) = "there"
val test7 = date_to_string (2013, 6, 1) = "June 1, 2013"
val test8 = number_before_reaching_sum (10, [1,2,3,4,5]) = 3
val test9 = what_month 70 = 3
val test10 = month_range (31, 34) = [1,2,2,2]
val test11 = oldest([(2012,2,28),(2011,3,31),(2011,4,28)]) = SOME (2011,3,31)

(* Challenge Problems *)

val test12 = number_in_months_challenge ([(2012, 2, 2,28),(2013,12,12, 1),(2011, 3, 3,31),(2011, 4, 4,28)],[2,3,4]) = 3

*)