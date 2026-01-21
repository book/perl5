#!./perl

BEGIN {
    chdir 't' if -d 't';
    require './test.pl';    # for fresh_perl_is() etc
    set_up_inc('../lib', '.', '../ext/re');
    require './charset_tools.pl';
    require './loc_tools.pl';
}

use Config;
use strict;
use warnings;

my $switches = "";

my $is_debugging_build = $Config{config_args} =~ /\bDDEBUGGING\b(*nla:=none)/;

our $TODO;

TODO: {
    local $::TODO = 'GH 21827';
    my $test = 18446744073709550592;
    my @warnings = capture_warnings(sub { localtime $test });
    {
        local $::TODO = 0;
        is(scalar @warnings, 2, 'Correct number of warnings captured; GH 21827');
    }
    for my $w (@warnings) {
        like($w, qr/localtime\($test\)/, 'localtime() warnings reports correct value when given too large of a number; GH 21827');
    }
}

done_testing();
