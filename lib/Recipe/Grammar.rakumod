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
# /* hello */
# ```
token comment {
    '/*' $<body>=( [ <!before '*/'> . ]* ) '*/' \h*
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
    (\d+)+ % <[.,/_]>
}

# match units like kg, kilograms, pinch, etc.
token unit {
    <valid-string>
}

#  Ingredient amounts are surrounded by parenthesis
token ingredient-amount {
    '(' \h* <quantity>+ \h* <unit>? \h* ')'
}

# Ingredients come in these formats:
#
# ```recp
# {quinoa}(200gr)
# {tomatoes}(2)
# {sweet potatoes}(2)
# ```
token ingredient {
    <curly> <ingredient-amount>?
}

# Materials format:
#
# ```recp
# &{pot}
# &{small jar}
# &{stick}
# ```
token material {
    '&' <curly>
}

# Timer format:
#
# ```recp
# t{25 minutes}
# t{10 sec}
# ```
token timer {
    't' <curly>
}

# Parse a reference to another recipe
#
# ```recp
# @{woile/special-tomato-sauce}
# @{woile/special-tomato-sauce}(100 ml)
# ```
token recipe-ref {
    '@' <curly> <ingredient-amount>?
}

# Tokens are separated into words
token word {
    \S+
}

# Metadata format:
# ```recp
# >> name: hummus classic
# >> tags: vegan, high-protein, high-fiber
# >> lang: en
# ```
token metadata {
    '>>' \h* $<key>=(<-[:\n]>+) ':' \h* $<value>=(\N*) \s*
}

# The backstory is separated by `---`, and it consumes till the end
# ```recp
# my recipe bla with {ingredient1}
# ---
# This recipe was given by my grandma
# ```
token backstory {
    \n \s* '---' \n \s* $<rest>=(.*)
}

token recipe-value {
    || <metadata>
    || <material>
    || <timer>
    || <ingredient>
    || <recipe-ref>
    || <backstory>
    || <comment>
    || <word>
    || \s+
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

Recipe::Grammar a parser implementation of recipe-lang.

=head1 AUTHOR

ohmycloud <ohmycloudy@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2026 ohmycloud

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
