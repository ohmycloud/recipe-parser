#!/usr/bin/env raku

use Recipe::Grammar;
use Terminal::ANSIColor;
use Recipe::Token;
use Recipe;

sub title-case(Str $s --> Str) {
    $s.words.map(*.tc).join(' ')
}

sub pad-visible(Str $colored-text, Str $raw-text, Int $width --> Str) {
    my $pad = $width - $raw-text.chars;
    $colored-text ~ ' ' x ($pad max 0)
}

multi MAIN('show', *@recipes) { show-recipes(@recipes) }
multi MAIN('s',    *@recipes) { show-recipes(@recipes) }

sub show-recipes(@paths) {
    for @paths -> $path {
        my $content = $path.IO.slurp;
        my $recipe = try recipe-from($content);

        if $! {
            note $!.message;
            exit 1;
        }

        with $recipe.name {
            say colored(title-case($_), 'bold blue') ~ "\n";
        }

        if $recipe.ingredients || $recipe.recipes-refs {
            say colored("Ingredients", 'underline') ~ "\n";
        }

        for $recipe.ingredients -> $ing {
            my $amount = join ' ', ($ing.quantity // ''), ($ing.unit // '');
            $amount .= trim;

            my $display = pad-visible(
                colored($ing.name, 'bold cyan'),
                $ing.name,
                32,
            );
            say "  $display $amount";
        }

        for $recipe.recipes-refs -> $ref {
            my $amount = join ' ', ($ref.quantity // ''), ($ref.unit // '');
            $amount .= trim;

            my $display = pad-visible(
                colored($ref.name, 'bold magenta'),
                $ref.name,
                32,
            );
            say "  $display $amount";
        }

        say "\n\n" ~ colored("Instructions", 'bold underline') ~ "\n";

        my @toks = $recipe.instructions.map: -> $tok {
            given $tok {
                when Metadata { Nil }
                when Comment   { Nil }
                when Backstory { Nil }
                when Ingredient {
                    colored($tok.name, 'bold cyan')
                }
                when RecipeRef {
                    colored($tok.name, 'magenta')
                }
                when Timer {
                    colored($tok.value, 'bold red')
                }
                when Material {
                    colored($tok.value, 'yellow')
                }
                when Word | Space {
                    $tok.value
                }
                default { Nil }
            }
        }

        my $instructions = @toks.grep(*.defined).join;
        say $instructions.trim;
    }
}
