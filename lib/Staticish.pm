use v6;

module Staticish {
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
