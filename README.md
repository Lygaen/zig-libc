<img align="left" width="76" height="84" src="./.github/icon.png" alt="Zig Libc Icon">

# Zig LIBC

[![Docs](https://github.com/Lygaen/zig-libc/actions/workflows/pages.yaml/badge.svg)](https://github.com/Lygaen/zig-libc/actions/workflows/pages.yaml)
[![Build](https://github.com/Lygaen/zig-libc/actions/workflows/build.yaml/badge.svg)](https://github.com/Lygaen/zig-libc/actions/workflows/build.yaml)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="/.github/white-logo.svg">
  <source media="(prefers-color-scheme: light)" srcset="/.github/black-logo.svg">
  <img align="right" width="128" height="40" alt="Humanmade mark". src="/.github/black-logo.svg">
</picture>

This is a re-implementation of Libc in Zig. It is following the C standard for their interface details. For the time being, this is more of a research / learning project. It may aim in the future to fully reimplement all of the Libc.

Projects that are similar may be `musl` (which helped me a lot) or [`ziglibc`](https://github.com/marler8997/ziglibc). The latter one feels outdated for the tooling and doesn't fully implement all of the libc.

This project is a big one, it may never be finished (`musl` is still being developed). However, Zig allows for sugar coating that can be added to it : tracing, thread safety, ... The project even configures its own headers depending on the target !

## Commands
The following can be done for building libc :
```sh
$ zig build install
```

It will generate a `zig-out/lib/` folder with the static library and a `zig-out/include/` with the configured headers.

You can also run :
```sh
$ zig build docs
```
to generate the documentation for the __zig__ side of things.
## Usage in Zig
For the time being, the library is not recommended to be used __anywhere__. If you want to go as far as using this library personnaly, you can anyway run the following :

```sh
$ zig fetch --save git+https://github.com/Lygaen/zig-libc
```

Then add to you `build.zig.zon` :
```diff
const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addModule("your-exe", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
+        .link_libc = false,
    });

    // -- snip --

+    const libc_dep = b.dependency("zig-libc", .{
+        .target = target,
+        .optimize = optimize,
+    });

+    // Where `exe` represents your executable/library to link to
+    exe.linkLibrary(libc_dep.artifact("zig-libc"));

    // -- snip --
}
```

And *voilà*, you've got yourself a working `libc` written in Zig.

## Status
Currently the goal is to implement `C89` (see [the standard](https://port70.net/%7Ensz/c/c89/c89-draft.html#4.)) :
  - [x] assert.h
  - [x] locale.h (it is a STUB)
  - [x] stddef.h
  - [x] ctype.h
  - [x] math.h
  - [ ] stdio.h
  - [x] errno.h
  - [ ] setjmp.h
  - [ ] stdlib.h
  - [x] float.h
  - [ ] signal.h
  - [ ] string.h
  - [x] limits.h
  - [x] stdarg.h
  - [ ] time.h
