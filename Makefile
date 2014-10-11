CC = cc
LEX = lex
YACC = yacc
CFLAGS = -ansi
LDLIBS = -lfl
YFLAGS = -v

PL2014_check: lex.yy.c y.tab.c y.tab.h
	$(CC) $(CFLAGS) y.tab.c lex.yy.c $(LDLIBS) -o PL2014_check

lex.yy.c: lexer.l
	$(LEX) lexer.l

y.tab.c: parser.y
	$(YACC) $(YFLAGS) -o y.tab.c parser.y

y.tab.h: parser.y
	$(YACC) $(YFLAGS) -d -o y.tab.c parser.y

clean:
	rm -f *.c *.h *.o *.output *.out *.pdf *.aux *.log PL2014_check

test: PL2014_check
	cd test && ./run.sh

report.pdf: report.tex
	pdflatex report.tex

.PHONY: clean test
