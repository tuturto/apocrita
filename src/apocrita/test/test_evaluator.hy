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

(import [apocrita.evaluator [eval- apply- Symbol Expression Closure
                             primitive? PrimitiveOperation]])

(defn test-evaluate-integer []
  "evaluating integer will return same integer"
  (assert (= (eval- 42 nil)
             42)))

(defn test-evaluate-float []
  "evaluating float will return same float"
  (assert (= (eval- 3.14 nil)
             3.14)))

(defn test-evaluate-symbol []
  "evaluating symbol will return value of that symbol in environment"
  (assert (= (eval- (Symbol "foo") {"foo" 5})
             5)))

(defn test-plus-primitive []
  "+ is recognized as primitive operator"
  (assert (primitive? (PrimitiveOperation "+"))))

(defn test-apply-plus []
  "evaluating + produces a sum"
  (assert (= (apply- (PrimitiveOperation "+") [1 2])
             3)))

(defn test-minus-primitive []
  "- is recognized as primitive operator"
  (assert (primitive? (PrimitiveOperation "-"))))

(defn test-apply-minus []
  "evaluating - produces subtraction"
  (assert (= (apply- (PrimitiveOperation "-") [5 4 3])
             -2)))

(defn test-evaluate-params []
  "evlist can evaluate list of parameters"
  (assert (= (eval- (Expression [(PrimitiveOperation "+")
                                 3 4])
                    {})
             7)))

(defn test-evaluate-nested-form []
  "evaluating (+ 2 (+ 5 4 3) (- 2 4) (+ (+ 1 2) 3)) results 18"
  (assert (= (eval- 
              (Expression [(PrimitiveOperation "+")
                           2
                           (Expression [(PrimitiveOperation "+")
                                        5 4 3])
                           (Expression [(PrimitiveOperation "-")
                                        2 4])
                           (Expression [(PrimitiveOperation "+")
                                        (Expression [(PrimitiveOperation "+")
                                                     1 2])
                                        3])])
              {})
             18)))
