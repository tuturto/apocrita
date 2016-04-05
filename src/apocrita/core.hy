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

(import [sys [exit]]
        [apocrita.types [Boolean]])

(defn op-add [coll]
  "add operands together"
  (reduce + coll))

(defn op-subtract [coll]
  "subtract operands"
  (reduce - coll))

(defn op-smaller [coll]
  "test if every operand is smaller than the one before it"
  (setv res true)
  (setv previous (first coll))
  (for [current (rest coll)]
    (when (not (< previous current))
        (setv res false)
        (break))
    (setv previous current))
  (Boolean res))

(defn op-greater [coll]
  "test is every operand is larger that the one before it"
  (setv res true)
  (setv previous (first coll))
  (for [current (rest coll)]
    (when (not (> previous current))
        (setv res false)
        (break))
    (setv previous current))
  (Boolean res))

(defn op-equal [coll]
  "test is every operand is equal to the one before it"
  (setv res true)
  (setv previous (first coll))
  (for [current (rest coll)]
    (when (not (= previous current))
        (setv res false)
        (break))
    (setv previous current))
  (Boolean res))

(defn op-exit [code]
  "raises SystemExit exception in order to terminate the program"
  (exit code))
