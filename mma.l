%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mma.tab.h"

int lineno = 1;
%}

%option noyywrap
%option case-insensitive

DIGITO   [0-9]
NUMERO   {DIGITO}+

%%

[ \t\r]+                ;
#.*                     ;
\n                      { lineno++; }

"peleador"              { return PELEADOR; }
"peso"                  { return PESO; }
"victoria"              { return VICTORIA; }
"derrota"               { return DERROTA; }
"empate"                { return EMPATE; }
"ko"                    { return KO; }
"sumision"              { return SUMISION; }
"decision"              { return DECISION; }
"ficha"                 { return FICHA; }

{NUMERO}                { yylval.num = atoi(yytext); return NUM; }

\"[^\"\n]*\"            { yylval.str = strdup(yytext + 1);
                          yylval.str[strlen(yylval.str) - 1] = '\0';
                          return CADENA; }

";"                     { return ';'; }

.                       { fprintf(stderr, "Linea %d, caracter raro '%s'\n", lineno, yytext); }

%%
