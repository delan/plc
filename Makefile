CC = clang
LEX = flex
CFLAGS = -std=c99
LDLIBS = -lfl

lexer: lexer.o

lexer.o: lexer.c

lexer.c: lexer.l

clean:
	rm -f *.c *.o lexer

.PHONY: clean
