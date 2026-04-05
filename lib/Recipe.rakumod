use Recipe::Grammar;
use Recipe::Actions;
use Recipe::Token;

class X::Recipe::Parse is export is Exception {
    has Str $.message is required;
    method message { "Failed to parse recipe:\n\n$.message" }
}

class Recipe is export {
    has Str        $.name;
    has            %.metadata;
    has Ingredient @.ingredients;
    has RecipeRef  @.recipes-refs;
    has Timer      @.timers;
    has Material   @.materials;
    has Str        $.backstory;
    has            @.instructions;
}

sub recipe-from(Str $input --> Recipe) is export {
    my @tokens = try Recipe::Grammar.parse($input.trim, actions => Recipe::Actions.new).made;

    if $! {
        X::Recipe::Parse.new(message => $!.message).throw
    }

    my %metadata;
    my @ingredients;
    my @recipes-refs;
    my @timers;
    my @materials;
    my $backstory = '';

    for @tokens -> $token {
        given $token {
            when Metadata {
                %metadata{$token.key} = $token.value;
            }
            when Ingredient {
                @ingredients.push: Ingredient.new(
                    name     => $token.name,
                    quantity => $token.quantity,
                    unit     => $token.unit,
                );
            }
            when RecipeRef {
                @recipes-refs.push: RecipeRef.new(
                    name     => $token.name,
                    quantity => $token.quantity,
                    unit     => $token.unit,
                );
            }
            when Timer     { @timers.push:    Timer.new(value => $token.value) }
            when Material  { @materials.push: Material.new(value  => $token.value) }
            when Backstory { $backstory ~= $token.value }
        }
    }

    Recipe.new(
        name         => %metadata<name> // Str,
        metadata     => %metadata,
        ingredients  => @ingredients,
        recipes-refs => @recipes-refs,
        timers       => @timers,
        materials    => @materials,
        backstory    => $backstory || Str,
        instructions => @tokens
    )
}
