#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);

use Test::More;
use Test::Command::Simple;

my $pxzgrep;

# Check if running under Debian and Ubuntu's autopkgtest. If so, test
# the installed script.
if ($ENV{AUTOPKGTEST_TMP}) {
    $pxzgrep = '/usr/bin/pxzgrep';
} else {
    $pxzgrep = "$Bin/../pxzgrep";
}

# Option "--help" both show the usage
run_ok($pxzgrep, '--help');
like(stdout, qr/^Usage:/,"Shows usage output with \"--help\".");

# Finished
done_testing();
