test "str operations":
  check "x" * 5 == "xxxxx"
  check 'h' * 2 == "hh"
  check 'h' == "h"
  check 'h' + "ell" + 'o' == "hello"
  check '0' + "1" + '2' == "012"
  check ' '.join(["hello", "world"]) == "hello world"
  check "\t\n ".isspace()

test "str methods":
  checkpoint "split whitespace"
  template eqList(a, b) =
    check @a == @b
  eqList str("a\u2000 \u2000b").split(), [str("a"),str("b")] ## \u2000 is of Unicode spaces
  eqList str("1   2   3").split(maxsplit=1), [str("1"), str("2   3")]

  checkpoint "split with char sep"
  eqList str("1 _2_   3").split('_'), [str"1 ", str"2", str"   3"]

  checkpoint "split with str sep"
  eqList "1 _2_   3".split("_ "), [str"1 _2", str"  3"]

  checkpoint "rsplit"
  eqList str("abc.list.txt").rsplit('.', 1), [str"abc.list", str"txt"]

  checkpoint "splitlines"
  eqList str("1\u20282").splitlines(), [str"1", str"2"]
  eqList str("1\u20282").splitlines(keepends=True), [str("1\u2028"), str"2"]

  check capitalize("aBΔ") == "Abδ"

  check "a".center(9) == "    a    "
  check "a".center(1) == "a"

  check "HELLO WORLD".casefold == "hello world"

  check " ".join([1, 2, 3, 4, 5, 6, 7, 8, 9]) == "1 2 3 4 5 6 7 8 9"
  check " ".join(['a', 'b', 'c', 'd', 'e']) == "a b c d e"

  check " ".isspace
  check "                   ".isspace

  check "hello world".index("w") == 6

  check "a" or "b" == "a"
  check "" or "b" == "b"

  check fr"{666.0} Hello {42} World {true} ! {1 + 2}" == "666.0 Hello 42 World true ! 3"
  check fr"" == ""
  check fr" " == " "
  check fr"""""" == ""
  check fr""" """ == " "
  check fr"hello {42}" & " world" == "hello 42 world"

  check not "abc".endswith("bc", 0, 2)
  check     "abc".endswith("bc", 0, 3)

  check "abc".endswith(("1", "c"))

  check "123".count("") == 4
