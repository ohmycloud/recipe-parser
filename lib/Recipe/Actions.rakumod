unit class Recipe::Actions;

use Recipe::Token;

method TOP($/) { make $<recipe-value>».made }

method recipe-value($/) {
    make (
            $<metadata>   ?? $<metadata>.made   !!
            $<material>   ?? $<material>.made   !!
            $<timer>      ?? $<timer>.made      !!
            $<ingredient> ?? $<ingredient>.made !!
            $<recipe-ref> ?? $<recipe-ref>.made !!
            $<backstory>  ?? $<backstory>.made  !!
            $<comment>    ?? $<comment>.made    !!
            $<word>       ?? Word.new(value => ~$<word>) !!
                             Space.new(value => ~$/)
    )
}

method metadata($/) {
    make Metadata.new(
        key => ~$<key>.trim,
        value => ~$<value>.trim
    )
}

method material($/)  { make Material.new(value => ~$<curly><valid-string>.trim) }
method timer($/)     { make Timer.new(value => ~$<curly><valid-string>.trim) }
method comment($/)   { make Comment.new(value => ~$<body>.trim) }
method backstory($/) { make Backstory.new(value => ~$<reset>) }

method !make-ingredient($class, $/) {
    my $name = ~$<curly><valid-string>.trim;
    my ($qty, $unit) = (Str, Str);
    if $<ingredient-amount> -> $amt {
        $qty = $amt<quantity> ?? ~$amt<quantity> !! Str;
        $unit = $amt<unit> ?? ~$amt<unit>.trim   !! Str;
    }
    $class.new(:$name, quantity => $qty, unit => $unit);
}

method ingredient($/) { make self!make-ingredient(Ingredient, $/) }
method recipe-ref($/) { make self!make-ingredient(RecipeRef, $/)  }
