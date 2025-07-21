# Zig LIBC

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://brainmade.org/white-logo.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://brainmade.org/black-logo.svg">
  <img alt="Humanmade mark." src="https://brainmade.org/black-logo.svg">
</picture>

[![Build and Test](https://github.com/Lygaen/zig-libc/actions/workflows/build.yml/badge.svg)](https://github.com/Lygaen/zig-libc/actions/workflows/build.yml)
![GitHub License](https://img.shields.io/github/license/Lygaen/zig-libc)

A rewrite of the LIBC library in Zig !
Currently in a very, *very* alpha state, doesn't do a lot of things.

It aims to **ONLY** depend on zig's std.

If the behavior is different from `musl`/`glibc`/... then it is a **bug**. It aims for seamless integration / replacement.

It also has a **tracing** feature to allow you to follow your libc calls.

## Summary
<!--ts-->
  * [Progress](#progress)
    * [C 89/90](#c-8990)
    * [C95 - CANNOT FIND ISO](#c95---cannot-find-iso)
    * [C99](#c99)
    * [C11](#c11)
    * [C23](#c23)
    * [C29 - CANNOT FIND ISO](#c29---cannot-find-iso)
  * [Usage / Build](#usage--build)
    * [Build](#build)
    * [Tests](#tests)
    * [Configuration](#configuration)
      * [Tracing](#tracing)
  * [Why ?](#why-)
  * [Acknowledgements](#acknowledgements)

<!-- Created by https://github.com/ekalinin/github-markdown-toc -->
<!-- Added by: mat, at: Mon Jul 21 12:34:12 PM CEST 2025 -->

<!--te-->

## Progress
Here is the current progress on the implementation of the different headers.

### C 89/90
See [headers iso](https://port70.net/%7Ensz/c/c89/c89-draft.html#4.).
 - [x] `assert.h`
 - [ ] `ctype.h`
 - [ ] `errno.h`
 - [ ] `float.h`
 - [ ] `limits.h`
 - [ ] `locale.h`
 - [ ] `math.h`
 - [ ] `setjmp.h`
 - [ ] `signal.h`
 - [x] `stdarg.h`
 - [ ] `stddef.h`
 - [ ] `stdio.h`
 - [ ] `stdlib.h`
 - [ ] `string.h`
 - [ ] `time.h`

### C95 - CANNOT FIND ISO
Because I cannot find the `C95` iso file for free online, I will not implement the following headers until it changes.
 - [ ] `iso646.h`
 - [ ] `wchar.h`
 - [ ] `wctype.h`

### C99
See [headers iso](https://port70.net/%7Ensz/c/c99/n1256.html#7).
 - [ ] `complex.h`
 - [ ] `fenv.h`
 - [ ] `inttypes.h`
 - [ ] `stdbool.h` (deprecated C23, to be removed ?)
 - [ ] `stdint.h`
 - [ ] `tgmath.h`

### C11
See [headers iso](https://port70.net/%7Ensz/c/c11/n1570.html#7).
 - [ ] `stdalign.h` (deprecated C23, to be removed ?)
 - [ ] `stdatomic.h`
 - [ ] `stdnoreturn.h`
 - [ ] `threads.h`
 - [ ] `uchar.h`

### C23
See [headers iso p.191](https://port70.net/%7Ensz/c/c23/n3220.pdf).
 - [ ] `stdbit.h`
 - [ ] `stdckdint.h`

### C29 - CANNOT FIND ISO
Same as for `C95`, cannot find a free iso online. Will not implement.
 - [ ] `stdmchar.h`

## Usage / Build
Exemple usage can be found in the `tests/` directory in the form of `*.c` files. Basically, use it like libc :D

### Build
For building, use the following command :
```sh
zig build
```
It will produce the following structure in the `zig-out` directory :
```tree
.
├── include
│   ├── assert.h
│   ├── stddef.h
│   └── ...
└── lib
    └── libzig_libc.a
```

### Tests
If you want to run and build the tests, do :
```sh
zig build test
```
which will generate :
```tree
.
├── bin
    └── hello_world
    └── ...
```

You can pass additional arguments to **all** the tests using :
```sh
zig build test -- arg1 arg2 ...
```

### Configuration
Additional parameters can be given at build time to modify the behavior of the library.

#### Tracing
```sh
zig build -Dtrace
```
Will output tracing to `stderr` which will satisfy the format :
```
[TRACE] LIBC '<function>' : <message>
```
This will clutter quite a lot your terminal but hopefully will help you trace back the error.

## Why ?
There a multiple reasons why I wanted to create this project :
  - The zig ecosystem still has a strong dependency on libc, which needs to then be distributed on all machines
  - Zig allows to generate information about the target machine ! It will allow to then have a cross-platform implementation of LIBC
  - It is a great project to learn various things
  - The current "ziglibc" project is dead (last commit >2y ago) and has many drawbacks and bad tooling
  - I feel like I can improve on the current solutions, and I want to try make an impact / help the zig ecosystem !

All these mad reasons have lead me to the most reasonable choice : write the entire LIBC in zig.

## Acknowledgements
A lot of inspiration and help was taken from the following projects :
  - [CPP Reference - Header page](https://cppreference.com/w/c/header.html)
  - [Jonathan Marler's ziglibc](https://github.com/marler8997/ziglibc) as well as [his talk](https://www.youtube.com/watch?v=1N85yU6RMcY)
  - [Musl's LIBC implementation](https://github.com/kraj/musl)
  - and more...
