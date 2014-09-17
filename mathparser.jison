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
    : expr EOF { return new Function('var tmp; return ' + $1 + ';'); }
    ;

expr
    : expr '+' expr { $$ = '(' + $1 + '+' + $3 + ')'; }
    | expr '-' expr { $$ = '(' + $1 + '-' + $3 + ')'; }
    | expr '*' expr { $$ = '(' + $1 + '*' + $3 + ')'; }
    | expr '/' expr { $$ = '(' + $1 + '/' + $3 + ')'; }
    | expr '^' expr { $$ = 'Math.pow(' + $1 + ',' + $3 + ')'; }
    | '-' expr %prec UMINUS { $$ = '(-' + $2 + ')'; }
    | '(' expr ')' { $$ = $2; }
    | NUMBER { $$ = ''+Number($1); }
    | IDENTIFIER {
        $$ = 'typeof (tmp = arguments[1][' + JSON.stringify($1) + ']) !== "undefined" ? tmp : (function() { throw new Error("No such variable with name: ' + $1 + '") })()'
    }
    | IDENTIFIER '(' arguments ')' {
        $$ = 'typeof (tmp = arguments[0][' + JSON.stringify($1) + ']) !== "undefined" ? tmp(' + $3.join(',') + ') : (function() { throw new Error("No such function with name: ' + $1 + '") })()'
    }
    ;

arguments
    : { $$ = []; }
    | expr { $$ = [$1]; }
    | arguments ',' expr { $$ = $1.slice(); $$.push($3); }
    ;
