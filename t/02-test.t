#!perl6

use v6;

use Test;

use lib 'lib';

use Staticish;

class Foo is Static {
    has $.foo is rw;
    method say-foo() {
        "say " ~ $!foo;
    }
}

my $a;

lives-ok { $a = Foo.new(foo => "this one") }, "create an object with the trait";
ok($a === Foo.new, "and it is the same object when new called again");
is($a.say-foo, "say this one", "object got the correct value (check wrapper)");
is(Foo.say-foo, "say this one", "called as a class method got the attribute");

done;
# vim: expandtab shiftwidth=4 ft=perl6
