#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);

use Test::More;
use Test::Command::Simple;
use Test::File::Contents;

my $pxzgrep;
my $call_xzgrep;

my @default_options = qw(--append);

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

# Two files with the same name, serial
run_ok($pxzgrep, @default_options, 'foo', '../source/append/1/f.xz', '../source/append/2/f.xz');
is(stdout, '', 'STDOUT empty on two same name files (serial)');
is(stderr, '', 'STDERR empty on two same name files (serial)');
file_contents_like('f', qr(\Afoo(aaa\nfoobbb|bbb\nfooaaa)\n\Z));
unlink('f');

# Two files with the same name, parallel
run_ok(qw(xargs -a ../source/append/files.txt -n1 -P 2), $pxzgrep, @default_options, 'foo');
is(stdout, '', 'STDOUT empty on two same name files (parallel)');
is(stderr, '', 'STDERR empty on two same name files (parallel)');
file_contents_like('f', qr(\Afoo(aaa\nfoobbb|bbb\nfooaaa)\n\Z));
unlink('f');

# Finished
done_testing();
