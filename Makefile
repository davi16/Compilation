# שם קובץ ההרצה שיווצר
TARGET = compiler

# קבצי המקור
LEX_FILE = lexer.l
BISON_FILE = parser.y

# מהדר ודגלים
CC = gcc
CFLAGS = -Wall -g

all: $(TARGET)

$(TARGET): y.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o $(TARGET) y.tab.c lex.yy.c

y.tab.c y.tab.h: $(BISON_FILE)
	bison -d $(BISON_FILE)

lex.yy.c: $(LEX_FILE) y.tab.h
	flex $(LEX_FILE)

# ניקוי קבצים זמניים (הרצה של make clean)
clean:
	rm -f $(TARGET) y.tab.c y.tab.h lex.yy.c