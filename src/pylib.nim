when defined(nimHasStrictFuncs):
  {.experimental: "strictFuncs".}

import std/[
  strutils, tables, times, os,
]

export tables

when not defined(js):
  import pylib/io
  export io
import pylib/private/trans_imp

impExp pylib,
  noneType, pybool, builtins,
  numTypes, radixCvt, ops,
  pystring, 
  pysugar

when not defined(pylibNoLenient):
  {.warning: "'lenientops' module was imported automatically. Compile with -d:pylibNoLenient to disable it if you wish to do int->float conversions yourself".}
  import std/lenientops
  export lenientops


const
  platform* = (system: hostOS, machine: hostCPU, processor: hostCPU)  ## Platform info.
  version_info* = (
    major: NimMajor,
    minor: NimMinor,
    micro: NimPatch,
    releaselevel: "final",
    serial: 0
  )  ## Version information (SemVer).
  sys* = (
    platform:     hostOS,
    maxsize:      high(BiggestInt),
    version:      NimVersion,
    version_info: version_info,
    byteorder:    $cpuEndian,
    copyright:    "MIT",
    hexversion:   NimVersion.toHex.toLowerAscii(),
    api_version:  NimVersion
  )  ## From http://devdocs.io/python~3.7/library/sys

type
  Platform* = typeof(platform)
  VersionInfo* = typeof(version_info)
  Sys* = typeof(sys)


template timeit*(repetitions: int, statements: untyped): untyped =
  ## Mimics Pythons ``timeit.timeit()``, output shows more information than Pythons.
  bind times.`$`
  template cpuTimeImpl(): untyped =
    when defined(js): now() else: cpuTime()
  let
    started = now()
    cpuStarted = cpuTimeImpl()
  for i in 0 .. repetitions:
    statements
  echo "$1 TimeIt: $2 Repetitions on $3, CPU Time $4.".format(
    $now(), repetitions, $(now() - started), $(cpuTimeImpl() - cpuStarted))
