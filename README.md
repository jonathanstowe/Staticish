# Staticish

Make a singleton class that wraps the methods so they appear like class methods

![Build Status](https://github.com/jonathanstowe/Staticish/workflows/CI/badge.svg)

## Synopsis

    use Staticish;

    class Foo is Static {
        has Str $.bar is rw;
    }

    Foo.bar = "There you go";
    say Foo.bar; # > "There you go";


## Description

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

It may not deal with every possible use case properly, but it largely
does what I need it to.  Suggestions, patches etc are welcome.

## Installation

Assuming you have a working Rakudo installation you should be able to install this with *zef* :

    # From the source directory
   
    zef install .

    # Remote installation

    zef install Staticish


## Support

This has never worked quite as well as I'd hoped when pre-compiled into another module as it 
flies too close to the wind of what will work.  If you find you hit a problem with it then you
should try adding `no precompilation;` to your module before the `use Staticish;`.

Suggestions/patches are welcomed via [github](https://github.com/jonathanstowe/Staticish/issues)

## Licence

This is free software.

Please see the [LICENCE](LICENCE) file in the distribution

© Jonathan Stowe 2015 - 2021
