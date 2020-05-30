pxzgrep, a parallel xzgrep wrapper
==================================

If you need to grep through terabytes of compressed log files, this
can take a lot of time if you do it serial — even on fast hardware.

But since such amounts of logs are usually not stored in a single file
and most servers today have multiple cores anyway, you can get a
massive speed up if you run multiple `xzgrep` processes in parallel.

### Note on supported compression algorithms

Citing from the [xzgrep(1) man page](https://linux.die.net/man/1/xzgrep):

> […] either uncompressed or compressed with xz(1), lzma(1), gzip(1),
> bzip2(1), or lzop(1).


Requirements
------------

* Bourne shell (typically `/bin/sh`, does not need to be a Bash),
  `sed`, `xargs`

* `xzgrep` (and hence also `grep` ;-) as usually shipped with `xz`
  itself.

Usage
-----

### Synopsis

```
pxzgrep [-p<n>] [-V] [<xzgrep options>] <pattern> <file1> <file2> [<more files>]
```

### Parameters

Takes xz-compressed files as parameters.

The grep result is saved per file in a file with the same basename
(e.g. `abc.xz` becomes `abc`), but in the __current__ working directory.

### Options

`-p`
: Takes a number as parameter and is passed to xargs as `-P` (number
  of parallel processes spawned). Defaults to amount of cores
  present in the running system.

`-V`
: Verbose, passes `--verbose` to `xargs`.

All other options are passed to `xzgrep`, especially `-F` and `-E`.

### Environment

Citing from the [xzgrep(1) man page](https://linux.die.net/man/1/xzgrep):

> `GREP`
> : If the GREP environment variable is set, xzgrep uses it instead of
>   grep(1), egrep(1), or fgrep(1).

(But you can also just use `-E` or `-F`.)


Author
------

Axel Beckert <axel@ethz.ch> for the [ETH Zurich IT Security
Center](http://www.security.ethz.ch/).


Copyright and License
---------------------

© 2020 Axel Beckert <axel@ethz.ch>, ETH Zurich IT Security Center

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
