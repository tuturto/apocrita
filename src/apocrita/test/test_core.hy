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

(import [apocrita.core [op-add op-subtract op-smaller op-greater]])

(defn test-add []
  "adding numbers produce their sum"
  (assert (= (op-add [1 2 3])
             6)))

(defn test-subtract []
  "subtracting numbers work"
  (assert (= (op-subtract [5 1 2])
             2)))

(defn test-smaller-true []
  "testing (< 1 2 3) results true"
  (let [[res (op-smaller [1 2 3])]]
    (assert (= res.value true))))

(defn test-smaller-false []
  "testing (< 3 2 1) results false"
  (let [[res (op-smaller [3 2 1])]]
    (assert (= res.value false))))

(defn test-greater-true []
  "testing (> 3 2 1) results true"
  (let [[res (op-greater [3 2 1])]]
    (assert (= res.value true))))

(defn test-greater-false []
  "testing (> 1 2 3) results false"
  (let [[res (op-greater [1 2 3])]]
    (assert (= res.value false))))
