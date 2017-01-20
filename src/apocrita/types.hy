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
  (defn --init-- [self expr]
    (setv self.expr expr))
  (defn --str-- [self]
    (str (. self expr)))
  (defn --repr-- [self]
    (str (. self expr))))

(defclass Boolean []
  "Boolean value"  
  [--init-- (fn [self value]
              (setv self.value value))
   --str-- (fn [self]
             (if (. self value)
               "#t"
               "#f"))
   --repr-- (fn [self]
              (str (. self value)))])

(defclass Expression []
  "expression"
  [--init-- (fn [self &optional [expr None]]
              (if expr
                (setv self.expr expr)
                (setv self.expr [])))
   append (fn [self expr]
            (.append (. self expr) expr))
   --str-- (fn [self]
             (+ "("
                (.join " " (map str (. self expr)))
                ")"))
   --repr-- (fn [self]
              (str self))
   --iter-- (fn [self]
              (.--iter-- self.expr))])

(defclass Closure []
  "closure is function and environment"
  [--init-- (fn [self params body env]
              (setv self.params params)
              (setv self.body body)
              (setv self.env env))
   --str-- (fn [self]
             (+ "<closure: "
                (.join " " (map str (. self params)))
                ">"))
   --repr-- (fn [self]
              "<closure>")])

(defclass PrimitiveOperation []
  "primitive operation"
  [--init-- (fn [self expr]
              (setv self.expr expr))
   --str-- (fn [self]
             (str (. self expr)))
   --repr-- (fn [self]
              (str (. self expr)))])

(defclass ApocritaException [Exception]
  "base class for all exceptions"
  [--init-- (fn [self expr message]
              (-> (super)
                  (.--init--))
              (setv self.message message)
              (setv self.expr expr))])

(defclass UnboundSymbol [ApocritaException]
  "error raised when trying to access value of unbound symbol"
  [--init-- (fn [self expr]
              (-> (super)
                  (.--init-- expr "unbound symbol")))
   --str-- (fn [self]
             (.format "{0}: {1}"
                      self.message
                      self.expr))])

(defclass TooManyParameters [ApocritaException]
  "error raised when too many parameters was specified"
  [--init-- (fn [self param-list params]
              (-> (super)
                  (.--init-- nil "too many parameters"))
              (setv self.params params)
              (setv self.param-list param-list))
   --str-- (fn [self]
             (.format "{0}: expected {1} '{2}', got {3} '{4}'"
                      self.message
                      (len self.param-list.expr)
                      self.param-list
                      (len self.params)
                      (+ "("
                         (.join " " (map str (. self params)))
                         ")")))])

(defclass TooFewParameters [ApocritaException]
  "error raised when too few parameters was specified"
  [--init-- (fn [self param-list params]
              (-> (super)
                  (.--init-- nil "too few parameters"))
              (setv self.params params)
              (setv self.param-list param-list))
   --str-- (fn [self]
             (.format "{0}: expected {1} '{2}', got {3} '{4}'"
                      self.message
                      (len self.param-list.expr)
                      self.param-list
                      (len self.params)
                      (+ "("
                         (.join " " (map str (. self params)))
                         ")")))])

(defclass NoMatchInCond [ApocritaException]
  "error raised when cond doesn't execute"
  [--init-- (fn [self expr]
              (-> (super)
                  (.--init-- expr "no match in cond")))
   --str-- (fn [self]
             (.format "{0}: {1}"
                      self.message
                      self.expr))])

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

(defn boolean? [expr]
  "is this boolean"
  (is (type expr) Boolean))

(defn true? [expr]
  "is this symbol #t"
  (and (is (type expr) Boolean)
       expr.value))

(defn false? [expr]
  "is this symbol #f"
  (and (is (type expr) Boolean)
       (not expr.value)))
