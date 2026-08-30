/*
 * Bison grammar for the exam-file format:
 *
 *   exam           : EXAM question_list
 *   question_list  : question_list question | empty
 *   question       : QUESTION NUM TOPIC section_list
 *   section_list   : section_list section | empty
 *   section        : SECTION NUM SCORE NUM
 *
 * Semantic values (NUM's int, TOPIC's string, and the running score
 * totals) are carried entirely through the %union / $$ / $1.. bison
 * mechanism, exactly as flex writes them into yylval. No extra
 * global variables are used to pass data between rules.
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *msg);
%}

%union {
    int   num;
    char *str;
}

%token EXAM QUESTION SECTION SCORE
%token <num> NUM
%token <str> TOPIC

%type <num> question_list question section_list section

%%

exam:
    EXAM question_list
    {
        if ($2 == 100) {
            printf("Valid input: the scores add up to 100.\n");
        } else {
            printf("Invalid input: the scores do not add up to 100 (total = %d).\n", $2);
        }
    }
    ;

question_list:
      question_list question   { $$ = $1 + $2; }
    | /* empty */               { $$ = 0; }
    ;

question:
    QUESTION NUM TOPIC section_list
    {
        printf("Question %d:\n%s\nTotal score: %d\n", $2, $3, $4);
        free($3);
        $$ = $4;
    }
    ;

section_list:
      section_list section   { $$ = $1 + $2; }
    | /* empty */             { $$ = 0; }
    ;

section:
    SECTION NUM SCORE NUM
    {
        /* $2 is the section number - not needed for the output */
        $$ = $4;
    }
    ;

%%

void yyerror(const char *msg) {
    fprintf(stderr, "Syntax error: %s\n", msg);
}

int main(void) {
    int result = yyparse();
    return result;
}
