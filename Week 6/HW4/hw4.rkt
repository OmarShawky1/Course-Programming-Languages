#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;(require test-engine/racket-tests)

;; put your code below

;; int * int * int -> ListOf Int
;; Produce a countup numbers starting at low till high and step stride
#; (define (sequence low high stride) null) ;stub ;null can be null

#|
(check-expect (sequence 0 5 1) (list 0 1 2 3 4 5))
(check-expect (sequence 3 11 2) (list 3 5 7 9 11))
(check-expect (sequence 3 8 3) (list 3 6))
(check-expect (sequence 3 2 1) null)
|#

(define (sequence low high stride)
  (local [(define (loop low high stride acc)
            (cond [(> low high) (reverse acc)]                                        ;BASE CASE
                  [else (loop (+ low stride) high stride (cons low acc))]))]          ;String
    (loop low high stride null)))


;; ListOf string * string -> string
;; append suffix to each element in listofstring.
#; (define (string-append-map los s) null) ;stub

#; (check-expect (string-append-map 
                  (list "dan" "dog" "curry" "dog2") 
                  ".jpg") '("dan.jpg" "dog.jpg" "curry.jpg" "dog2.jpg"))

(define (string-append-map los s)
  (map (λ (los) (string-append los s)) los))


;; ListOf int * int -> int
;; Interp:
;;  - If the number is negative,terminate the computation with (error "list-nth-mod: negative number").
;;  - If the list is null, terminate the computation with (error "list-nth-mod: null list").
;;  - Else return the ith element of the list where we count from zero and i is the
;;    remainder produced when dividing n by the list’s length
#; (define (list-nth-mod lon n) 0) ;stub

#|
(check-expect (list-nth-mod (list 1) -1) "list-nth-mod: negative number")
(check-expect (list-nth-mod null 1) "list-nth-mod: null list")
(check-expect (list-nth-mod (list 1 2 3) 1) (list-ref (list 1 2 3)
                                                      (remainder
                                                       1
                                                       (length (list 1 2 3)))))
(check-expect (list-nth-mod (list 0 1 2 3 4) 2) 2)
|#

(define (list-nth-mod lon n)
  (cond [(< n 0) (error "list-nth-mod: negative number")]
        [(null? lon) (error "list-nth-mod: null list")]
        [else (list-ref lon
                        (remainder n (length lon)))
              ]))

;; ListOf ('a, selfRef) * int -> ListOf ('a)
;; Interp. Produce stream of 'a for n values.
#; (define (stream-for-n-steps s n) null) ;stub

;; Producing check-expect complicated the implementation due to the different languages used.

(define (stream-for-n-steps s n)
  (letrec ([f (λ (s los acc)
                (if (= acc n)
                    (reverse los) ;not needed in case of ones
                    (f (cdr (s)) (cons (car (s)) los) (+ acc 1))))])
    (f s null 0)))


(define funny-number-stream
  (letrec ([f (λ (x) 
                (if (zero? (remainder x 5))
                    (cons (* x -1) (λ () (f (+ x 1))))
                    (cons x (λ () (f (+ x 1))))))])
    (λ () (f 1))))

(define dan-then-dog
  (letrec ([f (λ (x) 
                (if (= x 1)
                    (cons "dan.jpg" (λ () (f (+ x 1))))
                    (cons "dog.jpg" (λ () (f (- x 1))))))])
    (λ () (f 1))))


;; ListOf 'a -> ListOf (0, 'a) OR stream -> stream
(define (stream-add-zero s)
  (λ () (cons (cons 0 (car (s))) (stream-add-zero (cdr (s))))))

(define (cycle-lists xs ys)
  (letrec ([f (λ (n) (cons (cons (list-nth-mod xs n)
                                 (list-nth-mod ys n))
                           (λ () (f (+ n 1)))))])
    (λ () (f 0))))


;; Takes a value <v> and a vector <vec>. It should behave like Racket’s assoc
;; library function except:
;; (1) it processes a vector (Racket’s name for an array) instead of a list.
;; (2) it allows vector elements not to be pairs in which case it skips them.
;; (3) it always takes exactly two arguments.
;; 1- Process the vector elements in order starting from 0.
;; 2- Use:
;;        1) vector-length
;;        2) vector-ref
;;        3) equal?
;; 3- Return #f if no vector element is a pair with a car field equal to <v>
;; 4- Else return the first pair with an equal car field.
;; Sample solution is 9 lines, using one local recursive helper function.
#; (define (vector-assoc v vec) false) ;stub

(define (vector-assoc v vec)
  (letrec ([f (λ (i)
                (cond [(= i (vector-length vec)) false] ;check position reached outOfBound,produce false if not found
                      [else (let ([el (vector-ref vec i)])
                              (if (and (pair? el) (= v (car el))) ;check if it is a pair
                                  el
                                  (f (+ i 1))))]))]) ;skip if false
    (f 0)))

(define (cached-assoc xs n)
  (let* [(cached-vector (make-vector n))
         (cached-index 0)
         (inc-index (λ (i) (remainder (+ i 1) n)))
         (cache&return (λ (v) (let [(assoc-result (assoc v xs))]
                                (if assoc-result
                                    (begin (vector-set! cached-vector cached-index assoc-result)
                                           (set! cached-index (inc-index cached-index))
                                           assoc-result)
                                    false))))]
    (λ (v) (let [(cached-result (vector-assoc v cached-vector))]
             (if cached-result
                 cached-result
                 (cache&return v))))))