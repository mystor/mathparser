/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex

%%
\s+                   /* skip whitespace */
[0-9]+("."[0-9]+)?\b  return 'NUMBER';
[a-zA-Z]+             return 'IDENTIFIER';
"*"                   return '*';
"/"                   return '/';
"-"                   return '-';
"+"                   return '+';
"^"                   return '^';
"("                   return '(';
")"                   return ')';
","                   return ',';
<<EOF>>               return 'EOF';

/lex

/* operator associations and precedence */

%left '+' '-'
%left '*' '/'
%left '^'
%left UMINUS

%start equation

%% /* language grammar */


equation
    : expr EOF { return $1; }
    ;

expr
    : expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { $$ = $1 / $3; }
    | expr '^' expr { $$ = Math.pow($1, $3); }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | '(' expr ')' { $$ = $2; }
    | NUMBER { $$ = Number($1); }
    | IDENTIFIER {
        $$ = yy.var[$1];
        if (typeof $$ === 'undefined') throw new Error('No variable named ' + $1 + ' exists!');
    }
    | IDENTIFIER '(' arguments ')' {
        var fn = yy.fn[$1];
        if (typeof fn === 'undefined') throw new Error('No function named ' + $1 + ' exists!');
        $$ = fn.apply(null, $3);
    }
    ;

arguments
    : { $$ = []; }
    | expr { $$ = [$1]; }
    | arguments ',' expr { $$ = $1.slice(); $$.push($3); }
    ;
