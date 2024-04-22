import std/math


# Power templates for different types of arguments
template `**`*[T](a: T, b: Natural): T = a ^ b
template `**`*[T: SomeFloat](a, b: T): T = pow(a, b)
template `**`*[A: SomeFloat, B: SomeInteger](a: A, b: B): A = pow(a, b)
template `**`*[A: SomeInteger; B: SomeFloat](a: A, b: B): B = pow(B(a), b)

# Comparasion operators. We only need 3 of them :<, <=, ==.
# Other comparasion operators are just shortcuts to these
template `<`*[A: SomeInteger, B: SomeFloat](a: A, b: B): bool = B(a) < b
template `<`*[A: SomeFloat, B: SomeInteger](a: A, b: B): bool = a < A(b)

template `<=`*[A: SomeInteger, B: SomeFloat](a: A, b: B): bool = B(a) <= b
template `<=`*[A: SomeFloat, B: SomeInteger](a: A, b: B): bool = a <= A(b)

template `==`*[A: SomeInteger, B: SomeFloat](a: A, b: B): bool = B(a) == b
template `==`*[A: SomeFloat, B: SomeInteger](a: A, b: B): bool = a == A(b)

template `<>`*[A: SomeInteger, B: SomeFloat](a: A, b: B): bool = B(a) != b # Python 1.x and 2.x
template `<>`*[A: SomeFloat, B: SomeInteger](a: A, b: B): bool = a != A(b) # Python 1.x and 2.x

template `/`*(x: SomeInteger, y: SomeInteger): float = system.`/`(float(x), float(y))

type
  ArithmeticError* = object of CatchableError
  ZeroDivisionError* = object of ArithmeticError

template zeRaise(x) =
  if x == typeof(x)(0):
    raise newException(ZeroDivisionError, "division or modulo by zero")

func `%`*[T: SomeNumber](a, b: T): T =
  ## Python-like modulo
  runnableExamples:
    assert 13 % -3 == -2
    assert -13 % 3 == 2
  zeRaise b
  # Nim's `mod` is the same as `a - b * (a // b)` (i.e. remainder), while Py's is not.
  floorMod a,b

template `%`*[A: SomeFloat, B: SomeInteger](a: A, b: B): A = a % A(b)
template `%`*[A: SomeInteger; B: SomeFloat](a: A, b: B): B = B(a) % b


func `//`*[A, B: SomeFloat | SomeInteger](a: A, b: B): SomeNumber {.inline.} =
  ## Python-like floor division
  runnableExamples:
    assert 13 // -3 == -5
    assert 13 div -3 == -4
  when A is SomeInteger and B is SomeInteger:
    (a - a % b) div b
  else:
    (a.float - a % b) / b.float

func divmod*[T: SomeNumber](x, y: T): (T, T) = 
  ## differs from std/math divmod
  (x//y, x%y)

template `==`*(a, b: typedesc): bool =
  ## Compare 2 typedesc like Python.
  runnableExamples: doAssert type(1) == type(2)
  a is b
