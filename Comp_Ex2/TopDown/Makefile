CC = gcc
CFLAGS = -Wall

all: parser

parser: lex.yy.c parser.c tokens.h
	$(CC) $(CFLAGS) -o parser lex.yy.c parser.c

lex.yy.c: lexer.l tokens.h
	flex lexer.l

test: parser
	./parser < input.txt

clean:
	rm -f parser lex.yy.c *.o
