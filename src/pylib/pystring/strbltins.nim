
import std/strutils
from std/unicode import runeAt, utf8, runeLen, Rune, `$`
import ./strimpl
from ../pyerrors import TypeError
import ../builtins/[reprImpl, asciiImpl]

func reversed*(s: PyStr): PyStr =
  unicode.reversed s

func chr*(a: SomeInteger): PyStr =
  if a.int notin 0..0x110000:
    raise newException(ValueError, "chr() arg not in range(0x110000)")
  result = $Rune(a)


func ord1*(a: PyStr): int =
  runnableExamples:
    assert ord1("123") == ord("1")
  result = system.int(a.runeAt(0))

proc ord*(a: PyStr): int =
  ## Raises TypeError if len(a) is not 1.
  runnableExamples:
    doAssert ord("δ") == 0x03b4

  when not defined(release):
    let ulen = a.len
    if ulen != 1:
      raise newException(TypeError, 
        "TypeError: ord() expected a character, but string of length " & $ulen & " found")
  result = ord1 a

func pyrepr*(s: StringLike): PyStr =
  ## Shortcut for `str(pyreprImpl($s)))`
  runnableExamples:
    # NOTE: string literal's `repr` is `system.repr`, as following. 
    assert repr("\"") == "\"\\\"\""   # string literal of "\""
    # use pyrepr for any StringLike and returns a PyStr
    assert pyrepr("\"") == "'\"'"
  str pyreprImpl $s

func repr*(x: PyStr): string =
  ## Overwites `system.repr` for `PyStr`
  ## 
  ## The same as `proc ascii`_ except for unicode chars being remained AS-IS,
  ## and returns Nim's `string`.
  pyreprImpl $x

func ascii*(us: string): PyStr =
  runnableExamples:
    assert ascii("𐀀") == r"'\U00010000'"
    assert ascii("đ") == r"'\u0111'"
    assert ascii("和") == r"'\u548c'"
    let s = ascii("v我\n\e")
    when not defined(useNimCharEsc):
      let rs = r"'v\u6211\n\x1b'"
    else:
      let rs = r"'v\u6211\n\e'"
    assert s == rs
    assert ascii("\"") == "'\"'"
    assert ascii("\"'") == "'\"\\''"
    let s2 = ascii("'")
    when not defined(singQuotedStr):
      let rs2 = "\"'\""
    else:
      let rs2 = r"'\''"
    assert s2 == rs2
  str pyasciiImpl pyreprImpl us

func ascii*(us: PyStr): PyStr =
  str pyasciiImpl repr us

template ascii*(c: char): PyStr =
  ## we regard 'x' as a str (so as in python)
  runnableExamples:
    assert ascii('c') == "'c'"
  bind pyasciiImpl, str, pyreprImpl
  str pyasciiImpl(pyreprImpl($c))

template ascii*(a: untyped): PyStr =
  ## As repr(), return a string containing a printable representation
  ## of an object, but escape the non-ASCII characters in the string returned
  ##  by repr() using \x, \u, or \U escapes
  runnableExamples:
    assert ascii(6) == "6"
  bind pyasciiImpl, str
  str pyasciiImpl(repr(a))
