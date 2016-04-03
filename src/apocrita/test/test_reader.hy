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
        [apocrita.evaluator [eval-]])

(defn test-read-eval-simple []
  "read-eval with simple number returns that number"
  (assert (= (-> (read- "15")
                 (eval- {}))
             15)))

(defn test-read-eval-expression []
  "read-eval of simple expression works"
  (assert (= (-> (read- "(+ 1 2)")
                 (eval- {}))
             3)))

(defn test-read-eval-nested []
  "read-eval of nested expressions works"
  (assert (= (-> (read- "(+ 1 2 (- 4 3))")
                 (eval- {}))
             4)))

(defn test-read-eval-more-nesting []
  "read-eval (+ 3 4 (- 5 4 2) (+ 1 2 3 (+ 4 5 6)))"
  (assert (= (-> (read- "(+ 3 4 (- 5 4 2) (+ 1 2 3 (+ 4 5 6)))")
                 (eval- {}))
             27)))

(defn test-read-eval-with-environment []
  "read-eval (+ x y) produces correct answer"
  (assert (= (-> (read- "(+ x y)")
                 (eval- {"x" 5 "y" 6}))
             11)))

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

(defn test-read-nested-expressions []
  "nested expressions are handled with grace"
  (assert (= (group-elements "(+ 1 2 (+ 3 4))")
             ["(" "+" "1" "2" "(" "+" "3" "4" ")" ")"])))
