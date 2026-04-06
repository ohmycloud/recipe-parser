NAME
====

Recipe::Parser - Parser implementation of recipe-lang.

SYNOPSIS
========

```raku
use Recipe::Grammar;
use Recipe::Actions;

my $m = Recipe::Grammar.parse($input, actions => Recipe::Actions.new).made;
.say for @$m;
```

DESCRIPTION
===========

Recipe::Parser is a parser implementation of recipe-lang.

AUTHOR
======

ohmycloud <ohmycloudy@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2026 ohmycloud

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.
