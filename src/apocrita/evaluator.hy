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

(import [apocrita.types [Symbol Expression Closure PrimitiveOperation
                         number? symbol? expression? primitive? boolean?]]
        [apocrita.core [op-add op-subtract op-smaller op-greater op-equal
                        op-exit]])

(defn lookup [expr env]
  (get env expr.expr))

(defn apply-primop [proc args]
  "apply a primitive operation"
  (cond [(= proc.expr "+") (op-add args)]
        [(= proc.expr "-") (op-subtract args)]
        [(= proc.expr "<") (op-smaller args)]
        [(= proc.expr ">") (op-greater args)]
        [(= proc.expr "=") (op-equal args)]
        [(= proc.expr "exit") (op-exit (first args))])) ;; TODO: rest?

(defn apply- [proc args]
  "apply procedure to arguments"
  (cond [(primitive? proc) (apply-primop proc args)]))

(defn evlist [exprs env]
  "evaluate list of parameters in environment"
  (list (map (fn [it] (eval- it env)) exprs)))

(defn eval- [expr env]
  "evaluate an expression in environment"
  (cond [(number? expr) expr]
        [(boolean? expr) expr]
        [(symbol? expr) (lookup expr env)]
        [(primitive? expr) expr]
        [true (apply- (eval- (first expr) env)
                      (evlist (rest expr) env))]))
