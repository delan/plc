CC = clang
LEX = flex
CFLAGS = -ansi
LDLIBS = -lfl

lexer: lexer.o

lexer.o: lexer.c

lexer.c: lexer.l

clean:
	rm -f *.c *.o lexer

.PHONY: clean
