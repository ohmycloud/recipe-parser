use Grammar::Debugger;
use Grammar::Tracer;

unit grammar Recipe::Grammar;

use Recipe::Token;

# A valid string can contain alphanumeric characters as well as certain symbols and spaces.
token valid-string {
    <[\w] + [\t \ / \- _ @ . , % # ']>+
}

# Parse comments in the form of:
#
# ```recp
# /* */
# ```
token comment {
    '/*' $<body>=([\s\S]*?) '*/' \h*
}

# Parse curly braces delimited utf-8
#
# ```recp
# {salt}
# {tomatoes}
# ```
token curly {
    '{' <valid-string> '}'
}

# The amount of an ingredient must be numeric
# with a few symbols allowed.
#
# ```recp
# 1
# 3.2
# 3,2
# 3_000_000
# 2/3
# ```
token quantity {
    \d+ % <[.,/_]>
}

# match units like kg, kilograms, pinch, etc.
token unit {
    <valid-string>
}

#  Ingredient amounts are surrounded by parenthesis
token ingredient-amount {
    '(' \h* <quantity>? \h* <unit>? \h* ')'
}

token ingredient {
    <curly> <ingredient-amount>?
}

token material {
    '&' <curly>
}

token timer {
    't' <curly>
}

token recipe-ref {
    '@' <curly> <ingredient-amount>?
}

token metadata {
    '>>' \h* $<key>=(<-[:\n]>+) ':' \h* $<value>=(\N*)
}

token backstory {
    \n \s* '---' \n \s* $<reset>=([\s\S]*)
}

token word {
    \S+
}

token recipe-value {
    | <metadata>
    | <material>
    | <timer>
    | <ingredient>
    | <recipe-ref>
    | <backstory>
    | <comment>
    | <word>
    | \s+
}

token TOP {
    <recipe-value>*
}

=begin pod

=head1 NAME

Recipe::Grammar - Parser implementation of recipe-lang

=head1 SYNOPSIS

=begin code :lang<raku>

use Recipe::Grammar;
use Recipe::Actions;

sub MAIN(:$input) {
    my $m = Recipe::Grammar.parse($input, actions => Recipe::Actions.new).made;
    say $m;
}

=end code

=head1 DESCRIPTION

Recipe::Grammar is ...

=head1 AUTHOR

ohmycloud <ohmycloudy@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2026 ohmycloud

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
