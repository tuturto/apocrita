Apocrita is a lisp interpreter written in Hy

System Requirements
===================
- Python 3.4
- hy 0.12.0

Usage
=====

Start interactive repl:

```
hy apocrita/repl.hy
'It is by will alone I set my mind in motion'
Apocrita v. 0.1
=> 
```

There are two types of data, numbers and booleans:

```
=> 5
5
=> 2.5
2.5
=> #t
#t
=> #f
#f
```

Basic arithmetic can be performed with numbers:

```
=> (+ 1 1)
2
=> (+ 1 2 3 (- 4 5))
5
=> (+ 2.5 2.5)
5.0
=> (* 2 3)
6
```

Simple comparisons are supported:

```
=> (> 5 4 3)
#t
=> (= 3 4)
#f
```

Conditional are done with cond form:

```
=> (cond ((> 5 6) (+ 5 5))
...      ((< 5 6) (+ 6 6)))
12
```

If no branch match in cond, an error is raised:

```
=> (cond (#f #f))
no match in cond: (cond (#f #f))
```

Value of a symbol can be defined and later used in program:

```
=> (define a 5)
5
=> (define b 6)
6
=> (> a b)
#f
```

Functions are defined with lambda keyword or with shortform:

```
=> (define factorial
...  (lambda (n)
...    (cond ((= n 0) 1)
...          (#t (* n (factorial (- n 1)))))))
<closure: n>
=> (factorial 4)
24

=> (define (factorial n)
...  (cond ((= n 0) 1)
...        (#t (* n (factorial (- n 1))))))
<closure: n>
=> (factorial 4)
24
```

Functions are auto-curried:

```
=> (define (add a b)
...  (+ a b)
<closure: a b>
=> (define add-1 (add 1))
<closure: b>
=> (add-1 5)
6
```

Sometimes sequential execution is useful:

```
=> (define (example a b)
...  (do (define (max a b)
...        (cond ((> a b) a)
...              ((> b a) b)
...              (#t a)))
...      (define bigger (max a b))
...      (* 2 bigger)))
<closure: a b>
=> (example 1 2)
4
=> (example 2 1)
4
```

When done, just exit the repl:

```
=> (exit)
```

Credits
=======
The software is copyrighted by Tuukka Turto and released under MIT license.

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its terms.
