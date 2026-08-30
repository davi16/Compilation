/*
 * Recursive-descent parser for:
 *
 *   exam           : EXAM question_list
 *   question_list  : question_list question | empty
 *   question       : QUESTION NUM TOPIC section_list
 *   section_list   : section_list section | empty
 *   section        : SECTION NUM SCORE NUM
 *
 * Design note: the exercise asks us to avoid global variables and
 * instead pass semantic values around (as flex does with yylval).
 * The only piece of state kept at file scope is curToken, the
 * lookahead token, which is inherent to how a recursive-descent
 * parser works (every predictive parser needs to know "what token
 * am I looking at right now"). All the actual DATA - question
 * numbers, topics, scores, running totals - are passed as function
 * parameters and return values, never stored in extra globals.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokens.h"

extern int yylex(void);
extern YYSTYPE yylval;

#define END_OF_INPUT 0

static int curToken;

static void advance(void) {
    curToken = yylex();
}

static void expect(int expected, const char *what) {
    if (curToken != expected) {
        fprintf(stderr, "Syntax error: expected %s but got token code %d\n",
                what, curToken);
        exit(1);
    }
}

/* Forward declarations, in grammar order */
static void parseExam(void);
static int  parseQuestionList(void);   /* returns sum of all questions' scores */
static int  parseQuestion(void);       /* returns this question's total score */
static int  parseSectionList(void);    /* returns sum of this question's sections */
static int  parseSection(void);        /* returns this section's score */

int main(void) {
    advance();          /* prime the lookahead */
    parseExam();
    if (curToken != END_OF_INPUT) {
        fprintf(stderr, "Syntax error: unexpected extra input after exam\n");
        return 1;
    }
    return 0;
}

/* exam : EXAM question_list */
static void parseExam(void) {
    expect(EXAM, "'[exam]'");
    advance();

    int total = parseQuestionList();

    if (total == 100) {
        printf("Valid input: the scores add up to 100.\n");
    } else {
        printf("Invalid input: the scores do not add up to 100 (total = %d).\n", total);
    }
}

/* question_list : question_list question | empty
 * FIRST(question) = { QUESTION }, so as long as we see QUESTION we
 * keep consuming questions; anything else means the list is done. */
static int parseQuestionList(void) {
    int sum = 0;
    while (curToken == QUESTION) {
        sum += parseQuestion();
    }
    return sum;
}

/* question : QUESTION NUM TOPIC section_list */
static int parseQuestion(void) {
    expect(QUESTION, "'[question]'");
    advance();

    expect(NUM, "a question number");
    int questionNum = yylval.num;   /* capture value BEFORE advancing */
    advance();

    expect(TOPIC, "a quoted topic string");
    char *topic = yylval.str;       /* ownership passes to us */
    advance();

    int total = parseSectionList();

    printf("Question %d:\n%s\nTotal score: %d\n", questionNum, topic, total);

    free(topic);
    return total;
}

/* section_list : section_list section | empty */
static int parseSectionList(void) {
    int sum = 0;
    while (curToken == SECTION) {
        sum += parseSection();
    }
    return sum;
}

/* section : SECTION NUM SCORE NUM */
static int parseSection(void) {
    expect(SECTION, "'[section]'");
    advance();

    expect(NUM, "a section number");
    /* section number itself isn't needed for the output, so we
     * don't even bother capturing it in a named variable. */
    advance();

    expect(SCORE, "'[score]'");
    advance();

    expect(NUM, "a score value");
    int score = yylval.num;
    advance();

    return score;
}
