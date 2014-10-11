%{
	#define TOKE(KIND) printf(#KIND "\n");
	#define TOKA(KIND) printf(#KIND ":%s\n", yytext);
	#define DIE(WHY) { \
		fputs("fatal error: " #WHY "\n", stderr); \
		exit(1); \
	}
%}
%%
ARRAY           TOKE(ARRAY)
BEGIN           TOKE(BEGIN)
CALL            TOKE(CALL)
CONST           TOKE(CONST)
DO              TOKE(DO)
DECLARATION     TOKE(DECLARATION)
END             TOKE(END)
FOR             TOKE(FOR)
FUNCTION        TOKE(FUNCTION)
IF              TOKE(IF)
IMPLEMENTATION  TOKE(IMPLEMENTATION)
OF              TOKE(OF)
PROCEDURE       TOKE(PROCEDURE)
THEN            TOKE(THEN)
TYPE            TOKE(TYPE)
VAR             TOKE(VAR)
WHILE           TOKE(WHILE)
\:              TOKE(COLON)
\;              TOKE(SEMICOLON)
\,              TOKE(COMMA)
\.              TOKE(DOT)
=               TOKE(EQUALS)
:=              TOKE(ASSIGN)
\+              TOKE(ADD)
\-              TOKE(SUBTRACT)
\*              TOKE(MULTIPLY)
\/              TOKE(DIVIDE)
\[              TOKE(LSQUARE)
\]              TOKE(RSQUARE)
\{              TOKE(LCURLY)
\}              TOKE(RCURLY)
\(              TOKE(LPAREN)
\)              TOKE(RPAREN)
\.\.            TOKE(TO)
[0-9]+          TOKA(NUMBER)
[a-z]+          TOKA(IDENT)
[ \t\r\n]+      ;
.               DIE(unexpected input)
