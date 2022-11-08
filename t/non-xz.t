#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);

use Test::More;
use Test::Command::Simple;
use Test::File::Contents;
use Test::Differences;

my $pxzgrep;
my $call_xzgrep;

# Check if running under Debian and Ubuntu's autopkgtest. If so, test
# the installed script.
if ($ENV{AUTOPKGTEST_TMP}) {
    $pxzgrep = '/usr/bin/pxzgrep';
} else {
    $pxzgrep = "$Bin/../pxzgrep";
}
$call_xzgrep = "$pxzgrep --call-xzgrep";

# current working directory needs to be the target directory
chdir("$Bin/target");

# Single file, gz
run_ok($pxzgrep, 'foo', '../source-non-xz/f1.txt.gz');
is(stdout, '', 'STDOUT empty with single file');
is(stderr, '', 'STDERR empty with single file');
file_contents_eq('f1.txt', "foo1\nfoo1.1\n1.2foo\n");
unlink('f1.txt');

# Single file, bz2
run_ok($pxzgrep, 'foo', '../source-non-xz/f2.txt.bz2');
is(stdout, '', 'STDOUT empty with single file');
is(stderr, '', 'STDERR empty with single file');
file_contents_eq('f2.txt', "foo2\n");
unlink('f2.txt');

# Single file, lzo
run_ok($pxzgrep, 'fnord', '../source-non-xz/f3.txt.lzo');
is(stdout, '', 'STDOUT empty with single file');
is(stderr, '', 'STDERR empty with single file');
file_contents_eq('f3.txt', "fnord3\n");
unlink('f3.txt');

# Single file, zst
run_ok($pxzgrep, 'foo', '../source-non-xz/f4.txt.zst');
is(stdout, '', 'STDOUT empty with single file');
is(stderr, '', 'STDERR empty with single file');
file_contents_eq('f4.txt', "foobar4\n");
unlink('f5.txt');

# Single file, Z
run_ok($pxzgrep, 'gnarz', '../source-non-xz/f5.txt.Z');
is(stdout, '', 'STDOUT empty with single file');
is(stderr, '', 'STDERR empty with single file');
file_contents_eq('f5.txt', "gnarz5\n");
unlink('f5.txt');

# Single file, lzma
run_ok($pxzgrep, '66', '../source-non-xz/f6.txt.lzma');
is(stdout, '', 'STDOUT empty with single file');
is(stderr, '', 'STDERR empty with single file');
file_contents_eq('f6.txt', "666\n");
unlink('f6.txt');

# Single file, no match (once with contents, once without)
foreach my $file (qw(f1 f0)) {
    run($pxzgrep, 'gnarz', "../source-non-xz/$file.txt.gz");
    isnt(rc, 0, "Exit code maybe should be zero even if nothing was found ($file.txt.gz)");
    is(stdout, '', "STDOUT empty with empty file ($file.txt.gz)");
    is(stderr, '', "STDERR empty with empty file ($file.txt.gz)");
    file_contents_eq("$file.txt", '');
    unlink("$file.txt");
}

# Multiple files
run_ok($pxzgrep, 'foo', glob('../source-non-xz/*.txt.*'));
is(stdout, '', 'STDOUT empty with multiple files');
is(stderr, '', 'STDERR empty with multiple files');
&check_all_files();
unlink(glob('*.txt'));

# Multiple files with "-p 3"
run_ok($pxzgrep, qw(-p 3 foo), glob('../source-non-xz/*.txt.*'));
is(stdout, '', 'STDOUT empty with multiple files with "-p 3"');
is(stderr, '', 'STDERR empty with multiple files with "-p 3"');
&check_all_files();
unlink(glob('*.txt'));

# Multiple files with "-p3"
run_ok($pxzgrep, qw(-p3 foo), glob('../source-non-xz/*.txt.*'));
is(stdout, '', 'STDOUT empty with multiple files with "-p3"');
is(stderr, '', 'STDERR empty with multiple files with "-p3"');
&check_all_files();
unlink(glob('*.txt'));

# Same, but with -V
run_ok($pxzgrep, '-V', 'foo', glob('../source-non-xz/*.txt.*'));
is(stdout, '', 'STDOUT empty with multiple files and -V');
# Cope with STDERR output change in xargs since 2019-11-25
# (i.e. release ≤ 4.7.0), see https://savannah.gnu.org/bugs/?57291
# (and not https://bugs.gnu.org/?57291 as referred to in the according
# findutils changelog entry).
my $stderr = stderr;
$stderr =~ s/ $//gm;
eq_or_diff($stderr, <<"EOT", 'STDERR as expected with multiple files and -V');
$call_xzgrep foo ../source-non-xz/f0.txt.gz
$call_xzgrep foo ../source-non-xz/f1.txt.gz
$call_xzgrep foo ../source-non-xz/f2.txt.bz2
$call_xzgrep foo ../source-non-xz/f3.txt.lzo
$call_xzgrep foo ../source-non-xz/f4.txt.zst
$call_xzgrep foo ../source-non-xz/f5.txt.Z
$call_xzgrep foo ../source-non-xz/f6.txt.lzma
EOT
&check_all_files();
unlink(glob('*.txt'));

# Same, but with -V and -p2
run_ok($pxzgrep, qw(-V -p2 foo), glob('../source-non-xz/*.txt.*'));
is(stdout, '', 'STDOUT empty with multiple files and -V -p2');
# Cope with STDERR output change in xargs since 2019-11-25
# (i.e. release ≤ 4.7.0), see https://savannah.gnu.org/bugs/?57291
# (and not https://bugs.gnu.org/?57291 as referred to in the according
# findutils changelog entry).
$stderr = stderr;
$stderr =~ s/ $//gm;
eq_or_diff($stderr, <<"EOT", 'STDERR as expected with multiple files and -V and -p2');
$call_xzgrep foo ../source-non-xz/f0.txt.gz
$call_xzgrep foo ../source-non-xz/f1.txt.gz
$call_xzgrep foo ../source-non-xz/f2.txt.bz2
$call_xzgrep foo ../source-non-xz/f3.txt.lzo
$call_xzgrep foo ../source-non-xz/f4.txt.zst
$call_xzgrep foo ../source-non-xz/f5.txt.Z
$call_xzgrep foo ../source-non-xz/f6.txt.lzma
EOT
&check_all_files();
unlink(glob('*.txt'));

# Single file with case insensitivity in different variants
foreach my $opt (qw(-i --ignore-case)) {
    run_ok($pxzgrep, $opt, 'foo', '../source-non-xz/f4.txt.zst');
    is(stdout, '', 'STDOUT empty with single file');
    is(stderr, '', 'STDERR empty with single file');
    file_contents_eq('f4.txt', "foobar4\nFoo4\n");
    unlink('f4.txt');
}

# Inverse match
run_ok($pxzgrep, qw(-v foo ../source-non-xz/f1.txt.gz ../source-non-xz/f4.txt.zst));
is(stdout, '', 'STDOUT empty with single file');
is(stderr, '', 'STDERR empty with single file');
file_contents_eq('f1.txt', "bar1\nfnord1\n");
file_contents_eq('f4.txt', "Foo4\n");
unlink(glob('f?.txt'));

# Regexp
run_ok($pxzgrep, qw(-E f.o ../source-non-xz/f1.txt.gz));
is(stdout, '', 'STDOUT empty with single file');
is(stderr, '', 'STDERR empty with single file');
file_contents_eq('f1.txt', "foo1\nfnord1\nfoo1.1\n1.2foo\n");
unlink('f1.txt');

# Finished
done_testing();

# Helper functions

sub check_all_files {
    file_contents_eq('f0.txt', "");
    file_contents_eq('f1.txt', "foo1\nfoo1.1\n1.2foo\n");
    file_contents_eq('f2.txt', "foo2\n");
    file_contents_eq('f3.txt', "");
    file_contents_eq('f4.txt', "foobar4\n");
    file_contents_eq('f5.txt', "");
    file_contents_eq('f6.txt', "");
}
