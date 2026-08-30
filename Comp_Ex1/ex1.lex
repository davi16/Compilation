%{
#include <stdio.h>
#include <stdlib.h>

#define QUESTION 1
#define NUM      2
#define TOPIC    3
#define SECTION  4
#define SCORE    5

int total_score = 0;
int expecting_score_value = 0;
%}

%option yylineno
%option noyywrap
%option nounput
%option noinputצשל

%%

"[question]"        { return QUESTION; }
"[section]"         { return SECTION; }
"[score]"           { return SCORE; }
[1-9][0-9]?         { return NUM; }
\"[A-Za-z ]*\"      { return TOPIC; }
[ \t\r\n]+          { /* skip whitespace */ }
.                   { printf("Error: illegal character '%s' in line %d\n", yytext, yylineno); }

%%

int main(void) {
    int token;
    printf("%-10s%s\n", "Token", "Lexeme");

    while ((token = yylex())) {
        switch (token) {
            case QUESTION:
                printf("%-10s%s\n", "QUESTION", yytext);
                break;
            case SECTION:
                printf("%-10s%s\n", "SECTION", yytext);
                break;
            case SCORE:
                printf("%-10s%s\n", "SCORE", yytext);
                expecting_score_value = 1;
                break;
            case NUM:
                printf("%-10s%s\n", "NUM", yytext);
                if (expecting_score_value) {
                    total_score += atoi(yytext);
                    expecting_score_value = 0;
                }
                break;
            case TOPIC:
                printf("%-10s%s\n", "TOPIC", yytext);
                break;
        }
    }

    if (total_score == 100) {
        printf("Valid input: the scores add up to 100.\n");
    } else {
        printf("Invalid input: the scores add up to %d, not 100.\n", total_score);
    }

    return 0;
}
