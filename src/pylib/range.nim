import strutils, math

type
  Range*[T] = object
    start, stop: T
    step: int
    len: int

proc `$`*[T](rng: Range[T]): string = 
  ## Python-like stringify for range
  if rng.step != 1:
    "range($1, $2, $3)".format(rng.start, rng.stop, rng.step)
  else:
    "range($1, $2)".format(rng.start, rng.stop)

proc range*[T](start, stop: T, step: int): Range[T] = 
  assert(step != 0, "Step must not be zero!")
  result.start = start
  result.stop = stop
  result.step = step
  result.len = int(math.ceil((stop - start) / step))

template range*[T](start, stop: T): Range[T] = range(start, stop, 1)

template range*[T](stop: T): Range[T] = range(0, stop)

iterator items*[T](rng: Range[T]): T = 
  ## Python-like range iterator
  ## Supports negative values!
  # dummy is used to distinguish iterators from templates, so
  # templates wouldn't end in an endless recursion
  if rng.step > 0 and rng.stop > 0:
    for x in countup(rng.start, rng.stop - 1, rng.step):
      yield x
  elif rng.step < 0:
    for x in countdown(rng.start, rng.stop + 1, -rng.step):
      yield x

proc contains*[T](x: Range[T], y: T): bool = 
  ## Check if value in range. Doesn't iterate over full range,
  ## instead checks only for this value!
  result = 
    if x.step > 0: 
      y >= x.start and y < x.stop
    else:
      y > x.stop and y <= x.start
  result = result and ((y - x.start) mod x.step == 0)

proc list*[T](rng: Range[T]): seq[T] = 
  ## Python-like list procedure for range
  # Preallocate sequence for efficiency
  result = newSeq[T](rng.len)
  var i = 0
  for x in rng:
    result[i] = x
    inc i