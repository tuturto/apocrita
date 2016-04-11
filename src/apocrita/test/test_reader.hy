;; -*- coding: utf-8 -*-
;;
;; Copyright (c) 2016 Tuukka Turto
;; 
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:
;; 
;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.
;; 
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;; THE SOFTWARE.

(import [apocrita.reader [read- group-elements]]
        [apocrita.evaluator [eval-]]
        [apocrita.core [std-env]]
        [apocrita.types [true? false?]])

(defn read-eval [expr env]
  "reads and evaluates expression"
  (-> (read- expr)
      (eval- env)))

(defn test-read-eval-simple []
  "read-eval with simple number returns that number"
  (assert (= (read-eval "15" (std-env))
             15)))

(defn test-read-eval-expression []
  "read-eval of simple expression works"
  (assert (= (read-eval "(+ 1 2)" (std-env))
             3)))

(defn test-read-eval-nested []
  "read-eval of nested expressions works"
  (assert (= (read-eval "(+ 1 2 (- 4 3))" (std-env))
             4)))

(defn test-read-eval-more-nesting []
  "read-eval (+ 3 4 (- 5 4 2) (+ 1 2 3 (+ 4 5 6)))"
  (assert (= (read-eval "(+ 3 4 (- 5 4 2) (+ 1 2 3 (+ 4 5 6)))" (std-env))
             27)))

(defn test-read-eval-with-environment []
  "read-eval (+ x y) produces correct answer"
  (setv env (std-env))
  (read-eval "(define x 5)" env)
  (read-eval "(define y 6)" env)
  (assert (= (read-eval "(+ x y)" env)
             11)))

(defn test-smaller-than-true []
  "smaller than returns #t when succesfull"
  (assert (true? (read-eval "(< 1 2 3)" (std-env)))))

(defn test-smaller-than-false []
  "smaller than returns #f when failing"
  (assert (false? (read-eval "(< 3 2 1)" (std-env)))))

(defn test-cond []
  "cond returns value of true branch"
  (setv env (std-env))
  (read-eval "(define a 6)" env)
  (read-eval "(define b 7)" env)
  (assert (= (read-eval "(cond ((> a b) a)
                               ((> b a) b)
                               ((= a b) a))"
                        env)
             7)))

(defn test-cond-eval []
  "cond returns value of true branch after evaluating it correctly"
  (setv env (std-env))
  (read-eval "(define a 6)" env)  
  (read-eval "(define b 7)" env)
  (assert (= (read-eval "(cond ((< a b) (+ a 10))
                               ((< b a) (+ b 10))
                               ((= a b) a))" env)
             16)))

(defn test-lambda []
  (setv env (std-env))
  (-> (read- "(define factorial
                (lambda (n)
                  (cond ((= n 0) 1)
                        (#t (* n (factorial (- n 1)))))))")
      (eval- env))
  (assert (= (-> (read- "(factorial 4)")
                 (eval- env))
             24)))

(defn test-eval-define-lambda []
  "short form of define lambda"
  (setv env (std-env))
  (read-eval "(define (foo a b) (+ a b))" env)
  (assert (= (read-eval "(foo 1 2)" env)
             3)))

(defn test-group-single-character []
  "even single character should be grouped correctly"
  (assert (= (group-elements "5")
             ["5"])))

(defn test-group-sum []
  "stream of single s-expr results correct structure"
  (assert (= (group-elements "(+ 5 5)")
             ["(" "+" "5" "5" ")"])))

(defn test-group-larger-symbols []
  "multicharacter symbols are grouped ok"
  (assert (= (group-elements "(+ 10 5)")
             ["(" "+" "10" "5" ")"])))

(defn test-group-nested-expressions []
  "nested expressions are handled with grace"
  (assert (= (group-elements "(+ 1 2 (+ 3 4))")
             ["(" "+" "1" "2" "(" "+" "3" "4" ")" ")"])))
