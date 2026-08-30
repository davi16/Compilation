%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokens.h"

/* The single global required by the exercise: the semantic value
 * union that the lexer fills in for every token it returns. */
YYSTYPE yylval;

static char *dupNoQuotes(const char *text);
%}

%option noyywrap nounput noinput

DIGIT   [0-9]

%%

"[exam]"        { return EXAM; }
"[question]"    { return QUESTION; }
"[section]"     { return SECTION; }
"[score]"       { return SCORE; }

{DIGIT}{1,2}    { yylval.num = atoi(yytext); return NUM; }

\"[A-Za-z ]*\"  { yylval.str = dupNoQuotes(yytext); return TOPIC; }

[ \t\r\n]+      { /* skip whitespace */ }

.               { fprintf(stderr, "Lexical error: unexpected character '%s'\n", yytext);
                  exit(1); }

%%

/* Copies the text of a quoted lexeme (e.g. "Greedy Algorithms")
 * into a freshly allocated string without the surrounding quotes.
 * The parser owns the returned string and is responsible for it. */
static char *dupNoQuotes(const char *text) {
    size_t len = strlen(text);
    /* len - 2: drop the opening and closing '"' characters */
    char *result = (char *)malloc(len - 1);
    if (!result) {
        fprintf(stderr, "Out of memory\n");
        exit(1);
    }
    memcpy(result, text + 1, len - 2);
    result[len - 2] = '\0';
    return result;
}
