
import ../builtins/complex

import std/complex as ncomplex except complex
from std/math import ln
from ./math import isinf, isfinite, pi, e, tau, inf, nan
export pi, e, tau, inf, nan

const nanj*: PyComplex[float64] = complex(0.0, nan)
const infj*: PyComplex[float64] = complex(0.0, inf)


template expCC(sym) =
  template sym*(z: PyComplex): PyComplex =
    bind toNimComplex, pycomplex, sym
    sym(z.toNimComplex).pycomplex


func rect*[T](r, phi: T): PyComplex[T] =
  ncomplex.rect(r, phi).toNimComplex

expCC phase
expCC polar
expCC exp
expCC log10
expCC sqrt
expCC sin


#func isclose*(a,b: Complex, rel_tol=1e-09, abs_tol=0.0): bool =
  


func log*(z: PyComplex): PyComplex = ln(z)  ## ln(z)
func log*(z: PyComplex, base: SomeNumber|PyComplex): PyComplex = (ln(z) / ln(base)).pycomplex

func log2*(z: PyComplex): PyComplex = (ln(z)/ln(2)).pycomplex

template expAs(sym, alias) =
  template alias*(x: PyComplex): untyped =
    bind pycomplex
    sym(x).pycomplex

expAs arccos, acos
expAs arcsin, asin
expAs arctan, atan
expAs arccosh, acosh
expAs arcsinh, asinh
expAs arctanh, atanh

template both(fn) =
  func fn*(z: PyComplex): bool = z.re.fn and z.im.fn

both isfinite
both isnan
