#!perl6

use v6;

use Test;

use lib $*PROGRAM.parent.child('lib').Str;

use-ok "StaticFoo", "can use an externally defined module";


done-testing;
# vim: expandtab shiftwidth=4 ft=perl6
