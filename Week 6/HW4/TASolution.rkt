;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname TASolution) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below

(define (sequence low high stride)
  (if (> low high)
      null
      (cons low (sequence (+ low stride) high stride))))
#|
On this and all problems, do not penalize using the longer form \verb|(define sequence (lambda (low high stride) ... |(define sequence (lambda (low high stride) ...  instead of using the syntactic sugar for function definitions as in the sample above.

There is little need for a solution more complicated than the one above, but it is okay to give a 5 to a solution that uses a local helper function to avoid passing \verb|high|high and \verb|stride|stride recursively. It is also okay to use \verb|cond|cond instead of \verb|if|if although \verb|if|if is usually better style when there are only two cases.

Remember that you are grading on general style, not how close to the sample solution a student solution is. It is perfectly fine for a solution to be significantly different from the sample, as long as it has good style.
|#

(define (string-append-map xs suffix)
  (map (lambda (s) (string-append s suffix)) xs))

#|
The auto-grader already penalized solutions that did not use \verb|string-append|string-append and \verb|map|map as helper functions, so we do not need peer assessment to judge this same issue.

There is little benefit to a longer solution here, so probably give at most a 4 to solutions that use some form of \verb|let|let-expression.

Remember that you are grading on general style, not how close to the sample solution a student solution is. It is perfectly fine for a solution to be significantly different from the sample, as long as it has good style.
|#

(define (list-nth-mod xs n)
  (cond [(< n 0) (error "list-nth-mod: n must be non-negative")]
        [(null? xs) (error "list-nth-mod: list must be non-empty")]
        [#t (let* ([len (length xs)]
                   [posn (remainder n len)])
              (car (list-tail xs posn)))]))
#|
There are many reasonable style choices here, so mostly follow general guidelines for readable code.

A \verb|cond|cond is probably better here than if because there are 3 clear cases, but a fine alternative is checking \verb|(< n 0)|(< n 0) once outside of a local recursive helper function. It is also fine (probably even a little better than the sample above) to compute the length of \verb|xs|xs once outside a local helper function.

It is not necessary to use a \verb|let|let-expression or \verb|let*|let*-expression like in the sample above.

The auto-grader did not require using \verb|length|length, \verb|remainder|remainder, and \verb|list-tail|list-tail because these were listed as "hints." You also do not need to check for these functions, but you should penalize solutions that are significantly more complicated because they are not using them.

Remember that you are grading on general style, not how close to the sample solution a student solution is. It is perfectly fine for a solution to be significantly different from the sample, as long as it has good style.
|#

(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (let ([next (s)])
        (cons (car next) (stream-for-n-steps (cdr next) (- n 1))))))

#|
The most important thing to check for is that each thunk in the stream is evaluated at most once, which is why the code above has a \verb|let|let-expression rather than \verb|(car (s))|(car (s)) and \verb|(cdr (s))|(cdr (s)). Give at most a 4 if \verb|s|s is called twice. While such a solution is not horrible, it does matter in cases where stream elements have side effects or are expensive to compute. We expect this deduction to be common.

It is poor style to have extra unnecessary function wrapping related to thunks. For example, we would penalize the sample solution if \verb|(cdr next)|(cdr next) were instead \verb|(lambda () ((cdr next))|(lambda () ((cdr next)). Give at most a 4 for such a thing, or 3 if combined with the previous style issue (e.g., \verb|(lambda () ((cdr (s))))|(lambda () ((cdr (s))))).

Remember that you are grading on general style, not how close to the sample solution a student solution is. It is perfectly fine for a solution to be significantly different from the sample, as long as it has good style.
|#

(define funny-number-stream 
  (letrec ([f (lambda (n) (cons (if (= (remainder n 5) 0) (- n) n)
                                (lambda () (f (+ n 1)))))])
    (lambda () (f 1))))

#|
While a local helper function (with \verb|letrec|letrec or a local \verb|define|define) is better style than a helper function at top-level, be lenient here and allow a 5 even with a top-level helper function.

There are various fine-style ways to implement the logic where the sample solution has \verb|(if (= (remainder n 5) 0) (- n) n)|(if (= (remainder n 5) 0) (- n) n).

There should definitely not be any call to code that uses \verb|stream-for-n-steps|stream-for-n-steps or similar stream-processing code. The purpose here is to create a stream other code can use. Give at most a 2 for such code. However, there are elegant solutions that define \verb|funny-number-stream|funny-number-stream in terms of other streams using higher-order functions (the student would have to define) such as a map function over streams. Such code can receive a 5. If you see such code, it is probably used for problems 6-8 as well and you can continue to give high scores for an approach different from the sample solutions.

Remember that you are grading on general style, not how close to the sample solution a student solution is. It is perfectly fine for a solution to be significantly different from the sample, as long as it has good style.
|#

;; Here are three different sample solutions:
(define dan-then-dog
  (letrec ([dan-st (lambda () (cons "dan.jpg" dog-st))]
           [dog-st (lambda () (cons "dog.jpg" dan-st))])
    dan-st))

#; (define (dan-then-dog)
     (cons "dan.jpg"
           (lambda () (cons "dog.jpg" dan-then-dog))))

#; (define dan-then-dog
     (letrec ([f (lambda (b) 
                   (if b
                       (cons "dan.jpg" (lambda () (f #f)))
                       (cons "dog.jpg" (lambda () (f #t)))))])
       (lambda () (f #t))))

#|
As in the previous problem, be lenient and do not penalize solutions that put helper functions at top-level.

Give at most a 4 for code that has unnecessary function wrapping, such as replacing \verb|dog-st|dog-st or \verb|dan-st|dan-st in the first solution above with \verb|(lambda () (dog-st))|(lambda () (dog-st)) or \verb|(lambda () (dan-st))|(lambda () (dan-st)).

There should definitely not be any call to \verb|stream-for-n-steps|stream-for-n-steps or similar functions. Give at most a 2 for such code (but as necessary see comments in Problem 5 for solutions using higher-order stream functions).

Remember that you are grading on general style, not how close to the sample solution a student solution is. It is perfectly fine for a solution to be significantly different from the sample, as long as it has good style.
|#

(define (stream-add-zero s)
  (lambda ()
    (let ([next (s)])
      (cons (cons 0 (car next)) (stream-add-zero (cdr next))))))

#|
As in Problem 4, the most important thing to check for is that each thunk in the stream is evaluated at most once, which is why the code above has a \verb|let|let-expression rather than \verb|(car (s))|(car (s)) and \verb|(cdr (s))|(cdr (s)). Give at most a 4 if \verb|s|s is called twice. While such a solution is not horrible, it does matter in cases where stream elements have side effects or are expensive to compute. We expect this deduction to be common.

As in Problem 5 and Problem 6, give at most a 4 for unnecessary function wrapping, such as \verb|(lambda () ((cdr next)))|(lambda () ((cdr next))) instead of \verb|(cdr next)|(cdr next).

Remember that you are grading on general style, not how close  to the sample solution a student solution is. It is perfectly fine for a  solution to be significantly different from the sample, as long as it  has good style.
|#

(define (cycle-lists xs ys)
  (letrec ([loop (lambda (n)
                   (cons (cons (list-nth-mod xs n)
                               (list-nth-mod ys n))
                         (lambda () (loop (+ n 1)))))])
    (lambda () (loop 0))))

#|
As in previous problems, be lenient and do not penalize using a top-level helper function.

There are elegant solutions that do not use \verb|list-nth-mod|list-nth-mod, but such solutions should not be significantly longer than the sample solution.

Remember that you are grading on general style, not how close to the sample solution a student solution is. It is perfectly fine for a solution to be significantly different from the sample, as long as it has good style.
|#

(define (vector-assoc v vec)
  (letrec ([loop (lambda (i)
                   (if (= i (vector-length vec))
                       #f
                       (let ([x (vector-ref vec i)])
                         (if (and (cons? x) (equal? (car x) v))
                             x
                             (loop (+ i 1))))))])
    (loop 0)))

#|
The auto-grader already penalized solutions that did not use \verb|vector-length|vector-length, \verb|equal?|equal?, and \verb|vector-ref|vector-ref as helper functions, so we do not need peer assessment to judge this same issue.

While it is slightly better style to call \verb|vector-ref|vector-ref and \verb|vector-length|vector-length only once per iteration of the helper function as in the sample solution above, this is not required as long as the code is readable and elegant.

Remember that you are grading on general style, not how close to the sample solution a student solution is. It is perfectly fine for a solution to be significantly different from the sample, as long as it has good style.
|#

(define (cached-assoc lst n)
  (let ([cache (make-vector n #f)]
        [next-to-replace 0])
    (lambda (v)
      (or (vector-assoc v cache)
          (let ([ans (assoc v lst)])
            (and ans
                 (begin (vector-set! cache next-to-replace ans)
                        (set! next-to-replace 
                              (if (= (+ next-to-replace 1) n)
                                  0
                                  (+ next-to-replace 1)))
                        ans)))))))

#|
The auto-grader already penalized solutions that did not use \verb|vector|vector, \verb|assoc|assoc, and \verb|vector-set!|vector-set! as helper functions, so we do not need peer assessment to judge this same issue.

The essential thing to check (since it is too difficult for the auto-grader to do so) is that the cache and \verb|next-to-replace|next-to-replace logic is in a \verb|let|let-expression (or \verb|let*|let*-expression) outside the function bound to \verb|cached-assoc|cached-assoc as otherwise the cache is not actually being used. Give at most a 2 if every call to the function returned by \verb|cached-assoc|cached-assoc makes a new empty cache.

While the sample solution uses \verb|or|or and \verb|and|and, other logic, such as using \verb|if|if, is fine and in fact may be easier to read.

Similarly, the logic for the updated value of \verb|next-to-replace|next-to-replace can be performed in various ways, such as using \verb|remainder|remainder.

Remember that you are grading on general style, not how close to the sample solution a student solution is. It is perfectly fine for a solution to be significantly different from the sample, as long as it has good style.
|#

;; You do not need to assess the challenge problem, but you are welcome to provide text feedback for it if you wish. Here is a sample solution:
(define-syntax while-less
  (syntax-rules (do)
    ((while-less x do y)
     (let ([z x])
       (letrec ([loop (lambda ()
                        (let ([w y])
                          (if (or (not (number? w)) (>= w z))
                              #t
                              (loop))))])
         (loop))))))
