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
                         number? symbol? expression? primitive? boolean?
                         UnboundSymbol TooManyParameters NoMatchInCond
                         TooFewParameters]]
        [apocrita.core [op-add op-subtract op-smaller op-greater op-equal
                        op-exit op-multiply]])

(defn apply-primop [proc args]
  "apply a primitive operation"
  (cond [(= proc.expr "+") (op-add args)]
        [(= proc.expr "-") (op-subtract args)]
        [(= proc.expr "*") (op-multiply args)]
        [(= proc.expr "<") (op-smaller args)]
        [(= proc.expr ">") (op-greater args)]
        [(= proc.expr "=") (op-equal args)]
        [(= proc.expr "exit") (op-exit (first args))]))

(defn bind [params args env]
  "bind arguments to list of formal parameters"
  (when (> (len params.expr) (len args))
    (raise (TooFewParameters params args)))
  (when (< (len params.expr) (len args))
    (raise (TooManyParameters params args)))
  (setv combined (dict-comp (. (first pair) expr) (second pair)
                            [pair (zip params args)]))  
  (, combined env))

(defn needs-currying? [proc args]
  "does this application result to currying"
  (> (len (. proc params expr)) (len args)))

(defn curry [proc args]
  "curry a function"
  (let [[all-params (. proc params expr)]
        [arg-count (len args)]
        [unbound-params (slice all-params arg-count)]
        [bound-params (slice all-params 0 arg-count)]]
    (eval- (Expression [(Symbol "lambda")
                        (Expression unbound-params)
                        proc.body])
           (bind (Expression bound-params) args (. proc env)))))

(defn apply- [proc args]
  "apply procedure to arguments"
  (cond [(primitive? proc) (apply-primop proc args)]
        [(needs-currying? proc args) (curry proc args)]
        [true (eval- (. proc body)
                     (bind (. proc params) args (. proc env)))]))

(defn evlist [exprs env]
  "evaluate list of parameters in environment"
  (list (map (fn [it] (eval- it env)) exprs)))

(defn cond? [expr]
  "is this expression a cond?"
  (and (expression? expr)
       (symbol? (first expr))
       (= (. (first expr) expr) "cond")))

(defn eval-cond [expr env]
  "evaluate a cond form"
  (setv match-found false)
  (setv res nil)
  (for [branch (rest expr)]
    (when (= (str (eval- (first branch) env)) "#t")
      (setv match-found true)
      (setv res (eval- (second branch) env))
      (break)))
  (when (not match-found)
    (raise (NoMatchInCond expr)))
  res)

(defn define? [expr]
  "is this expression a define"
  (and (expression? expr)
       (symbol? (first expr))
       (= (. (first expr) expr) "define")))

(defn set-symbol-value [symbol value env]
  "set value of symbol"
  (assoc (first env) symbol.expr value))

(defn lookup [symbol env]
  "get value of symbol in nested environment"
  (setv found false)
  (setv res nil)
  (setv current-env env)
  (setv current-frame (first current-env)) 
  (while (not (is current-frame nil))
    (when (in symbol.expr current-frame)
      (setv found true)
      (setv res (get current-frame symbol.expr))
      (break))
    (setv current-env (second current-env))
    (if current-env
      (setv current-frame (first current-env))
      (setv current-frame nil)))
  (if found
    res
    (raise (UnboundSymbol symbol.expr))))

(defn eval-define [expr env]
  "evaluate define form"
  (cond [(symbol? (second expr))
         (do (set-symbol-value (get expr.expr 1)
                               (eval- (get expr.expr 2) env)
                               env)
             (lookup (get expr.expr 1) env))]
        [(expression? (second expr))
         (let [[header (second expr)]
               [fn-name (first header)]
               [param-list (list (rest header))]
               [body (get expr.expr 2)]]
           (set-symbol-value fn-name
                             (eval- (Expression [(Symbol "lambda")
                                                 (Expression param-list)
                                                 body])
                                    env)
                             env)
           (lookup fn-name env))]))

(defn lambda? [expr]
  "is this expression a lambda"
  (and (expression? expr)
       (symbol? (first expr))
       (in (. (first expr) expr) ["lambda" "λ"])))

(defn eval-lambda [expr env]
  "evaluate lambda"
  (Closure (get expr.expr 1) 
           (get expr.expr 2) env))

(defn do? [expr]
  "is this expression a do"
  (and (expression? expr)
       (symbol? (first expr))
       (= (. (first expr) expr) "do")))

(defn eval-do [expr env]
  "evaluate do block"
  (setv res nil)
  (for [item (rest expr)]
    (setv res (eval- item env)))
  res)

(defn eval- [expr env]
  "evaluate an expression in environment"
  (cond [(number? expr) expr]
        [(boolean? expr) expr]
        [(cond? expr) (eval-cond expr env)]
        [(define? expr) (eval-define expr env)]
        [(lambda? expr) (eval-lambda expr env)]
        [(do? expr) (eval-do expr env)]
        [(symbol? expr) (lookup expr env)]
        [(primitive? expr) expr]        
        [true (apply- (eval- (first expr) env)
                      (evlist (rest expr) env))]))
