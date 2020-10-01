#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);

use Test::More;
use Test::Command::Simple;
use Test::File::Contents;

my $pxzgrep;

# Check if running under Debian and Ubuntu's autopkgtest. If so, test
# the installed script.
if ($ENV{AUTOPKGTEST_TMP}) {
    $pxzgrep = '/usr/bin/pxzgrep';
} else {
    $pxzgrep = "$Bin/../pxzgrep";
}

# current working directory needs to be the target directory
chdir("$Bin/target");

# Single file
run_ok($pxzgrep, 'foo', '../source/f1.txt.xz');
is(stdout, '', 'STDOUT empty with single file');
is(stderr, '', 'STDERR empty with single file');
file_contents_eq('f1.txt', "foo1\nfoo1.1\n1.2foo\n");
unlink('f1.txt');

# Single file, no match (once with contents, once without)
foreach my $file (qw(f1 f0)) {
    run($pxzgrep, 'gnarz', "../source/$file.txt.xz");
    isnt(rc, 0, "Exit code maybe should be zero even if nothing was found ($file.txt.xz)");
    is(stdout, '', "STDOUT empty with empty file ($file.txt.xz)");
    is(stderr, '', "STDERR empty with empty file ($file.txt.xz)");
    file_contents_eq("$file.txt", '');
    unlink("$file.txt");
}

# Multiple files
run_ok($pxzgrep, 'foo', glob('../source/*.txt.xz'));
is(stdout, '', 'STDOUT empty with multiple files');
is(stderr, '', 'STDERR empty with multiple files');
&check_all_files();
unlink(glob('*.txt'));

# Multiple files with "-p 3"
run_ok($pxzgrep, qw(-p 3 foo), glob('../source/*.txt.xz'));
is(stdout, '', 'STDOUT empty with multiple files with "-p 3"');
is(stderr, '', 'STDERR empty with multiple files with "-p 3"');
&check_all_files();
unlink(glob('*.txt'));

# Multiple files with "-p3"
run_ok($pxzgrep, qw(-p3 foo), glob('../source/*.txt.xz'));
is(stdout, '', 'STDOUT empty with multiple files with "-p3"');
is(stderr, '', 'STDERR empty with multiple files with "-p3"');
&check_all_files();
unlink(glob('*.txt'));

# Same, but with -V
run_ok($pxzgrep, '-V', 'foo', glob('../source/*.txt.xz'));
is(stdout, '', 'STDOUT empty with multiple files and -V');
is(stderr, <<'EOT', 'STDERR as expected with multiple files and -V');
sh -c 'xzgrep  '\''foo'\'' ../source/f0.txt.xz > ./$(basename ../source/f0.txt)' 
sh -c 'xzgrep  '\''foo'\'' ../source/f1.txt.xz > ./$(basename ../source/f1.txt)' 
sh -c 'xzgrep  '\''foo'\'' ../source/f2.txt.xz > ./$(basename ../source/f2.txt)' 
sh -c 'xzgrep  '\''foo'\'' ../source/f3.txt.xz > ./$(basename ../source/f3.txt)' 
sh -c 'xzgrep  '\''foo'\'' ../source/f4.txt.xz > ./$(basename ../source/f4.txt)' 
sh -c 'xzgrep  '\''foo'\'' ../source/f5.txt.xz > ./$(basename ../source/f5.txt)' 
sh -c 'xzgrep  '\''foo'\'' ../source/f6.txt.xz > ./$(basename ../source/f6.txt)' 
EOT
&check_all_files();
unlink(glob('*.txt'));

# Same, but with -V and -p2
run_ok($pxzgrep, qw(-V -p2 foo), glob('../source/*.txt.xz'));
is(stdout, '', 'STDOUT empty with multiple files and -V -p2');
is(stderr, <<'EOT', 'STDERR as expected with multiple files and -V and -p2');
sh -c 'xzgrep  '\''foo'\'' ../source/f0.txt.xz > ./$(basename ../source/f0.txt)' 
sh -c 'xzgrep  '\''foo'\'' ../source/f1.txt.xz > ./$(basename ../source/f1.txt)' 
sh -c 'xzgrep  '\''foo'\'' ../source/f2.txt.xz > ./$(basename ../source/f2.txt)' 
sh -c 'xzgrep  '\''foo'\'' ../source/f3.txt.xz > ./$(basename ../source/f3.txt)' 
sh -c 'xzgrep  '\''foo'\'' ../source/f4.txt.xz > ./$(basename ../source/f4.txt)' 
sh -c 'xzgrep  '\''foo'\'' ../source/f5.txt.xz > ./$(basename ../source/f5.txt)' 
sh -c 'xzgrep  '\''foo'\'' ../source/f6.txt.xz > ./$(basename ../source/f6.txt)' 
EOT
&check_all_files();
unlink(glob('*.txt'));

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