unit class Recipe::Token;

role Token is export {
    method Str(--> Str) { '' }
}

class Metadata is export does Token {
    has Str $.key;
    has Str $.value;
}

class Ingredient is export does Token {
    has Str $.name;
    has Str $.quantity;
    has Str $.unit;

    method Str(--> Str) { $.name }
}

class RecipeRef is export does Token {
    has Str $.name;
    has Str $.quantity;
    has Str $.unit;

    method Str(--> Str) { $.name }
}

class Timer is export does Token {
    has Str $.value;

    method Str(--> Str) { $.value }
}

class Material is export does Token {
    has Str $.value;

    method Str(--> Str) { $.value }
}

class Word is export does Token {
    has Str $.value;

    method Str(--> Str) { $.value }
}

class Space is export does Token {
    has Str $.value;

    method Str(--> Str) { $.value }
}

class Comment is export does Token {
    has Str $.value;
}

class Backstory is export does Token {
    has Str $.value;

    method Str(--> Str) { $.value }
}
