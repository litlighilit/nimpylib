import std/[strutils, unicode]

import ./strops


func index*(a: string, b: StringLike, start = 0, last = -1): int =
  var last = if last == -1: a.len else: last
  result = a.find(b, start, last)
  if result == -1:
    raise newException(ValueError, "substring not found")

func rindex*(a: string, b: StringLike, start = 0, last = 0): int =
  result = a.rfind(b, start, last)
  if result == -1:
    raise newException(ValueError, "substring not found")

template isspace*(a: StringLike): bool = unicode.isSpace($a)

template join*[T](sep: StringLike, a: openArray[T]): string =
  ## Mimics Python join() -> string
  a.join($sep)

template casefold*(a: StringLike): string =
  ## Mimics Python str.casefold() -> str
  unicode.toLower(a)

template center*(a: StringLike, width: Natural, fillchar = ' '): string =
  ## Mimics Python str.center(width: int, fillchar: str=" ") -> str
  let hWidth = width div 2
  repeat(fillchar, hWidth) & a & repeat(fillchar, hWidth)

iterator split*(a: StringLike, maxsplit = -1): string =
  ## with unicode whitespaces as sep.
  ## 
  ## treat runs of whitespaces as one sep (i.e.
  ##   discard empty strings from result),
  ## while Nim's `unicode.split(s)` doesn't

  # the following line is a implementation that only respect ASCII whitespace
  #for i in strutils.split($a): if i != "": yield i
  for i in unicode.split($a, maxsplit=maxsplit):
    if i != "": yield i

func split*(a: StringLike, maxsplit = -1): seq[string] =
  for i in strmeth.split(a, maxsplit): result.add i

iterator split*(a: StringLike,
    sep: StringLike, maxsplit = -1): string{.inline.} =
  for i in strutils.split($a, $sep, maxsplit): yield i
  
func split*(a: StringLike, sep: StringLike, maxsplit = -1): seq[string] =
  for i in strmeth.split(a, sep, maxsplit): result.add i

func capitalize*(a: StringLike): string =
  ## make the first character have upper case and the rest lower case.
  ## 
  ## while Nim's `unicode.capitalize` only make the first character upper-case.
  let s = $a
  if len(s) == 0:
    return ""
  var
    rune: Rune
    i = 0
  fastRuneAt(s, i, rune, doInc = true)
  result = $toUpper(rune) & toLower substr(s, i)