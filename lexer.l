%{

#include <stdio.h>
#include "y.tab.h"

#define TOKE(KIND) { \
        printf("lexer: found PL_" #KIND "\n"); \
        return PL_ ## KIND; \
}

#define TOKV(KIND) { \
        printf("lexer: found PL_" #KIND ": %s\n", yytext); \
        return PL_ ## KIND; \
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
[0-9]+          TOKV(NUMBER)
[a-z]+          TOKV(IDENT)
[ \t\r\n]+      ;
.               {
                        fprintf(stderr, "lexer: error: unexpected "
                                        "input character: '%s' [%d]\n",
                                        yytext, *yytext);
                        exit(1);
                }
