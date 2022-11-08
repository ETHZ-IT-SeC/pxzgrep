pxzgrep(1) - a parallel xzgrep wrapper
======================================

[![Build Status](https://travis-ci.org/ETHZ-IT-SeC/pxzgrep.svg?branch=master)](https://travis-ci.org/ETHZ-IT-SeC/pxzgrep)

SYNOPSIS
--------

```
pxzgrep [-p<n>] [-V] [<xzgrep options>] <pattern> <file1> <file2> [<more files>]
```


DESCRIPTION
-----------

If you need to grep through terabytes of compressed log files, this
can take a lot of time if you do it serial — even on fast hardware.

But since such amounts of logs are usually not stored in a single file
and most servers today have multiple cores anyway, you can get a
massive speed up if you run multiple `xzgrep` processes in parallel.

### Note on supported compression algorithms

Citing from the [xzgrep(1) man page](https://linux.die.net/man/1/xzgrep):

> […] either uncompressed or compressed with xz(1), lzma(1), gzip(1),
> bzip2(1), lzop(1) or zstd(1).

These file formats, especially their file suffixes `.xz`, `.lzma`,
`.gz`, `.bz2`, `.lzo`, `.zstd`, `.z` and `.Z` are recognised by
`pxzgrep` as well.


FILES
-----

Takes compressed files as parameters.

The grep result is saved per file in a file with the same basename
(e.g. `abc.xz` becomes `abc`), but in the __current__ working directory.


OPTIONS
-------

`-p`
: Takes a number as parameter and is passed to xargs as `-P` (number
  of parallel processes spawned). Defaults to amount of cores
  present in the running system.

`-V`
: Verbose, passes `--verbose` to `xargs`.

`--call-xzgrep`
: Used internally to run as wrapper around `xzgrep`.

All other options are passed to `xzgrep`, especially `-F` and `-E`.


CAVEATS
-------

* Since `xzgrep` doesn't support `grep`'s `-r` option for recursively
  grepping through directories, `pxzgrep` doesn't support the `-r`
  option either.


EXAMPLE
-------

    $ xzcat ../in/foo.xz
    foo
    fnordoo
    bar
    $ xzcat ../in/bar.xz
    foo
    fnordar
    bar
    $ pxzgrep -V fnord ../in/bar.xz ../in/foo.xz
    sh -c 'xzgrep  '\''fnord'\'' ../in/bar.xz > ./$(basename ../in/bar)' 
    sh -c 'xzgrep  '\''fnord'\'' ../in/foo.xz > ./$(basename ../in/foo)' 
    $ head foo bar
    ==> foo <==
    fnordoo
    
    ==> bar <==
    fnordar
    $


ENVIRONMENT
-----------

Citing from the [xzgrep(1) man page](https://linux.die.net/man/1/xzgrep):

> `GREP`
> : If the `GREP` environment variable is set, xzgrep uses it instead
>   of grep(1), egrep(1), or fgrep(1).

(But you can also just use `-E` or `-F`.)


RUN-TIME REQUIREMENTS
---------------------

* Bourne shell (typically `/bin/sh`, does not need to be a Bash),
  `sed`, `xargs`

* `xzgrep` (and hence also `grep` ;-) as usually shipped with `xz`
  itself (package `xz-utils` on Debian and Ubuntu).

* Optionally `gzip`, `bzip2`, `lzop` and `zstd` to grep through
  compression formats supported by these tools.

Note: The LZMA format is handled by `xz` itself, and the "deflate" or
"compress" format (suffixes `.z` and `.Z`) is handled by `gzip`.


BUILD REQUIREMENTS
------------------

For building the man page, [ronn](https://github.com/apjanke/ronn-ng)
and `gzip` are needed.


AUTHOR
------

Axel Beckert <axel@ethz.ch> for the [ETH Zurich IT Security
Center](http://www.security.ethz.ch/).


COPYRIGHT
---------

© 2020-2022 Axel Beckert <axel@ethz.ch>, ETH Zurich IT Security Center


LICENSE
-------

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
