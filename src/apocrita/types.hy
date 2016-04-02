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

(defclass Symbol []
  "Symbol"
  [[--init-- (fn [self expr]
               (setv self.expr expr)
               nil)]
   [--str-- (fn [self]
              (str (. self expr)))]
   [--repr-- (fn [self]
               (str (. self expr)))]])

(defclass Expression []
  "expression"
  [[--init-- (fn [self &optional [expr nil]]
               (if expr
                 (setv self.expr expr)
                 (setv self.expr []))
               nil)]
   [append (fn [self expr]
             (.append (. self expr) expr))]
   [--str-- (fn [self]
              (str (. self expr)))]
   [--iter-- (fn [self]
               (.--iter-- self.expr))]])

(defclass Closure []
  "closure is function and environment"
  [[--init-- (fn [self params body env]
               (setv self.params params)
               (setv self.body body)
               (setv self.env env)
               nil)]])

(defclass PrimitiveOperation []
  "primitive operation"
  [[--init-- (fn [self expr]
               (setv self.expr expr)
               nil)]
   [--str-- (fn [self]
              (str (. self expr)))]])

(defn number? [expr]
  "is this expression a number?"
  (or (integer? expr)
      (float? expr)))

(defn symbol? [expr]
  "is this expression a symbol"
  (is (type expr) Symbol))

(defn expression? [expr]
  "is this expression"
  (is (type expr) Expression))

(defn primitive? [expr]
  "is this a primitive"
  (is (type expr) PrimitiveOperation))
