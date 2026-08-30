# Makefile for Flex assignment (ex1)

CC = gcc
CFLAGS = -Wall -g
TARGET = ex1
LEX_FILE = ex1.lex

all: $(TARGET)

$(TARGET): lex.yy.c
	$(CC) $(CFLAGS) -o $(TARGET) lex.yy.c

lex.yy.c: $(LEX_FILE)
	flex $(LEX_FILE)

clean:
	rm -f $(TARGET) lex.yy.c
