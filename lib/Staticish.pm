use v6;

=begin pod

=head1 NAME

Staticish - make a singleton class with "static" method wrappers

=head1 SYNOPSIS

=begin code

    use Staticish;

    class Foo is Static {
        has Str $.bar is rw;
    }

    Foo.bar = "There you go";
    say Foo.bar; # > "There you go";

=end code

=head1 DESCRIPTION

This provides a mechanism whereby a class can be treated as a "singleton"
and all of its methods wrapped such that if they are called as "class"
or "static" methods they will actually be called on the single instance.
It does this by applying a role to the class itself which provides a
constructor "new()"  that will always return the same instance of the
object, and by applying a role to the classes Meta class which over-rides
the "add_method" method in order to wrap the programmer supplied methods
such that if the method is called on the type object (i.e. as a class
method) then the single instance will be obtained and the method will
be called with that as the invocant.

This might be useful for a class such as a configuration parser or
logger where a single set of parameters will be used globally within an
application and it doesn't make sense to pass a single object around.

There are no methods in this module, it is sufficient to use the module
in the scope that your class is declared, and then declare the class with
"is Static" as in the synopis above.  This may look like the introduction
of a base class but the "is" is over-ridden (it just made more sense than
the other trait introducing verbs to me.)

=end pod

module Staticish:ver<v0.0.1>:auth<github:jonathanstowe> {
    role MetamodelX::StaticHOW {
        my %bypass = :new, :bless, :BUILDALL, :BUILD, 'dispatch:<!>' => True;
        method add_method(Mu \type, $name, $code) {
            if not %bypass{$name}:exists {
                $code.wrap(method ( $self: |c) {
                    my $new-self = $self;
                    if not $new-self.defined {
                        $new-self = $self.new;
                    }
                    callwith($new-self,|c);
                });
            }
            nextsame;
        }
    }

    role Singleton {
        my $instance;
        method new(|c) {
            if not $instance.defined {
                $instance = self.bless(|c);
            }
            $instance;
        }
    }

    multi sub trait_mod:<is>(Mu:U $doee, :$Static!) is export {
        $doee.HOW does MetamodelX::StaticHOW;
        $doee.^add_role(Singleton);
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
