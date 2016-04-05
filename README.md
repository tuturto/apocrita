Apocrita is a lisp interpreter written in Hy

System Requirements
===================
- Python 3.4
- hy 0.11.0

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

Numbers can be added and subtracted:

```
=> (+ 1 1)
2
=> (+ 1 2 3 (- 4 5))
5
=> (+ 2.5 2.5)
5.0
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

When done, just exit the repl:

```
=> (exit)
```

Credits
=======
The software is copyrighted by Tuukka Turto and released under MIT license.

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its terms.
