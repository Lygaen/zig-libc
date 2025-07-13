# ZIG LIBC
A rewrite of the LIBC library in Zig !
Currently in a very, *very* alpha state, doesn't do a lot of things.
It aims to **ONLY** depend on zig's std.
If the behavior is different from `musl`/`glibc`/... then it is a **bug**. It aims for seamless integration / replacement.
It also has a **tracing** feature to allow you to follow your libc calls.

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
