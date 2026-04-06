use Recipe::Grammar;
use Recipe::Actions;

sub MAIN(:$input) {
    my $m = Recipe::Grammar.parsefile($input, actions => Recipe::Actions.new).made;
    .say for @$m;
}
