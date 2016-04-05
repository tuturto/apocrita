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

(require hy.contrib.anaphoric)

(import [apocrita.types [Symbol Expression PrimitiveOperation Boolean]])

(defn read- [stream]
  "read stream of characters and produce structure for eval to evaluate"
  (tokenize (group-elements stream)))

(defn tokenize [stream]
  "take stream of strings and create respective expressions and symbols"  
  (defn try-casting [expr]
    "try casting expression to a number or primitive operation"
    (setv res expr)
    (try
     (setv res (int expr))
     (catch [e ValueError]
       (try
        (setv res (float expr))
        (catch [e ValueError] 
          (cond [(= "+" expr) (setv res (PrimitiveOperation "+"))]
                [(= "-" expr) (setv res (PrimitiveOperation "-"))]
                [(= "<" expr) (setv res (PrimitiveOperation "<"))]
                [(= ">" expr) (setv res (PrimitiveOperation ">"))]
                [(= "=" expr) (setv res (PrimitiveOperation "="))]
                [(= "#t" expr) (setv res (Boolean true))]
                [(= "#f" expr) (setv res (Boolean false))]
                [(= "exit" expr) (setv res (PrimitiveOperation "exit"))]
                [true (setv res (Symbol expr))])))))
    res)

  (let [[current-expression nil]
        [expression-stack []]
        [res nil]]
    (for [elem stream]
         (cond [(and (not current-expression)
                     (= "(" elem))
                (setv current-expression (Expression))]
               [(and current-expression
                     (= "(" elem))
                (do (.append expression-stack current-expression)
                    (setv current-expression (Expression)))]
               [(and current-expression
                     expression-stack
                     (= ")" elem))
                (do (setv parent (.pop expression-stack))
                    (.append parent current-expression)
                    (setv current-expression parent))]
               [(and current-expression
                     (not expression-stack)
                     (= ")" elem))
                (setv res current-expression)]
               [current-expression
                (.append current-expression (try-casting elem))]
               [(not current-expression)
                (do (setv current-expression (try-casting elem))
                    (setv res current-expression))]))
    res))

(defn group-elements [stream]
  "group characters in a stream into groups according to their usage"
  (setv parsed 
        (reduce (fn [acc it]
                  (cond [(and (not (first acc))
                              (= it "("))  (.append (first acc) "(")]
                        [(and (first acc)
                              (= it "(")) (do (when (second acc)
                                                (.append (first acc)
                                                         (.join "" (second acc))))
                                              (.append (first acc) "(")
                                              (.clear (second acc)))]
                        [(and (not (second acc))
                              (= it ")")) (.append (first acc) ")")]
                        [(and (second acc)
                              (= it ")")) (do (.append (first acc)
                                                       (.join "" (second acc)))
                                              (.append (first acc) ")")
                                              (.clear (second acc)))]
                        [(and (second acc)
                              (.isspace it)) (do (.append (first acc)
                                                          (.join "" (second acc))) 
                                                 (.clear (second acc)))]
                        [(not (.isspace it)) (.append (second acc) it)])
                  acc)
                stream
                (, [] [])))
  (when (second parsed)
    (.append (first parsed) (.join "" (second parsed))))
  (first parsed))
