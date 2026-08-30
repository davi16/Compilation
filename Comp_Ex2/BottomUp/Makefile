CC = gcc
CFLAGS = -Wall

all: parser

parser: lex.yy.c parser.tab.c
	$(CC) $(CFLAGS) -o parser lex.yy.c parser.tab.c

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

test: parser
	./parser < input.txt

clean:
	rm -f parser lex.yy.c parser.tab.c parser.tab.h *.o
