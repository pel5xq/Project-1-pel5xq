%{
#include "symtab.h"
#include "turtle.tab.h"
%}

%%

\/\/.*          ;
[[:space:]]     ;

GO              return GO;
TURN            return TURN; 
VAR             return VAR;
JUMP            return JUMP;
FOR             return FOR;
STEP            return STEP;
TO              return TO;
DO              return DO;
BEGIN           return CBEGIN;
END          	return CEND;
IF		return IF;
THEN		return THEN;
ELSE		return ELSE;
WHILE		return WHILE;

sin             return SIN;
cos             return COS;
sqrt            return SQRT;

;               return SEMICOLON;
\+              return ADD;
-               return SUBTRACT;
\*              return MULT;
\/              return DIV;
\(              return OPENPAREN;
\)              return CLOSEPAREN;
=               return ASSIGN;
==		return EQUALS;
!=		return NOTEQUALS;
<=		reutrn LESSOREQUAL;
<		return LESSTHAN;
>		return GREATERTHAN;
>=		return GREATEROREQUAL;
\{		return OPENBRACKET;
\}		return CLOSEBRACKET;

[a-z]+          { yylval.n = lookup(yytext); 
                  if (yylval.n==NULL)
		    yylval.n = insert(yytext);
                  return ID;
		}
    
[0-9]+\.[0-9]+  yylval.d = atof(yytext);  return FLOAT;
[0-9]+          yylval.i = atoi(yytext);  return INT;

.               fprintf(stderr,"Unexpected character %c (%2X)\n",yytext[0],yytext[0]);

%%

