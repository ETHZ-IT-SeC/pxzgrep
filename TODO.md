pxzgrep TODO
============

Planned Features
----------------

* **Append by default instead of overwriting.** Solves the issue of
  searching files with the same name in different directories, e.g. in
  directory structures with date based files names of the scheme
  `YYYY-MM/HH:MM.log.xz`.

* **Behave more grep-like**: In the end, output all hits to STDOUT by
  concatenating all output files in sorted order. Maybe use a
  temporary directory for those files and optionally delete them
  again. (The old behaviour still needs to stay available respectively
  might be used in the background, e.g. by temporarily saving all the
  results in a directory under `$TMPDIR`.)
  
* **Commandline option to select target directory instead of current
  working directory**, maybe `--target` or maybe analoguos to `cp` and
  `mv` rather `--target-directory=DIRECTORY` and `-t` (luckily so far
  unused in `grep`).
  
Ideas
-----

* Support `grep`'s `-r` despite `xzgrep` doesn't.

* Support other decompressors like `gzip`, `bzip2`, `zstd`, `lzop`,
  `lzip`, `lz4`, `rzip`, `brotli`, `zopfli`, `lzma`, etc.  (`lzma`
  might just need some suffix handling as IIRC the family of `xz`
  tools already can handle `lzma` as it's `xz`'s predecessor.)

  + Support working with
    [zutils](https://www.nongnu.org/zutils/zutils.html).

  + Might need some renaming. `pzgrep` is a potential name as `pgrep`
    is already in use for GNU Grep's PCRE grep variant. (Not to
    confuse with `pcregrep` which is a different implementation.)
    
  + Would require some exception handling code what happens if files
    with the same base file name, but different suffixes exist,
    e.g. `file.gz` and `file.xz`. Possible solution: Name the output
    files `file_gz` and `file_xz` instead of currently just `file`.

* Reimplement the whole thing in Perl. It's getting too complex to be
  easily maintainable in shell code.
  
  + Also the verbose output can be made be less awkward then.
  
  + Open question here: Shall we still use `xargs` or some equivalent
    in Perl like one of the modules from the `Parallel::*` hierachy?
