#ifndef TOKENS_H
#define TOKENS_H

/*
 * Shared token definitions used by BOTH the flex lexer (lexer.l)
 * and the hand-written recursive-descent parser (parser.c).
 *
 * The semantic value that flex fills in for a token is stored in
 * the global yylval, which is a union (as required by the exercise).
 * This lets the lexer and parser cooperate without extra globals:
 * every time a NUM or TOPIC token is produced, its value travels
 * inside yylval, not in a separate global variable.
 */

/* Semantic value union, filled in by the lexer */
typedef union {
    int  num;   /* value of a NUM token   */
    char *str;  /* value of a TOPIC token */
} YYSTYPE;

extern YYSTYPE yylval;

/* Token codes. 0 is reserved for end-of-file (what flex/yylex
 * returns automatically when the input is exhausted), so all our
 * tokens start from 258, following the usual bison convention
 * (kept here too, just so the two parts of the exercise "feel"
 * consistent, though for TopDown any distinct positive values work).
 */
typedef enum {
    EXAM = 258,
    QUESTION,
    NUM,
    TOPIC,
    SECTION,
    SCORE
} TokenType;

#endif /* TOKENS_H */
