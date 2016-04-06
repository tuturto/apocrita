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

(import [apocrita.evaluator [eval-]]
        [apocrita.reader [read-]])

(defn input-expression []
  "get complete expression"
  (setv res (input "=> "))
  (while (not (<= (.count res "(")
                  (.count res ")")))
    (setv res (+ res " " (input "... "))))
  res)

(defmain [args]
  "interactive shell"
  (print "'It is by will alone I set my mind in motion'")
  (print "Apocrita v. 0.1")
  (setv running true)
  (setv env {})
  (while running
    (try 
     (-> (input-expression)
         (read-)
         (eval- env)
         (print))
     (except [e SystemExit]
       (setv running false))
     (except [e Exception]
       (print "error:" e)))))


