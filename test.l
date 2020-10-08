%{
#include "test.tab.h"
%}

number		[0-9]+
addop		[+]
subop		[-]
multop		[*]
divop		[/]
assign		"assign"
for		"for"
goto		"goto"
print		"print"
word		["]*[a-zA-z0-9]*\s*["]*

%%
{number}	{
			yylval.value = atoi(yytext);
			return NUMBER;
		}
{addop}		return ADDOP;
		
{subop}		return SUBOP;

{multop}	return MULTOP;
	
{divop}		return DIVOP;

{assign}	return ASSIGN;

{for}		return FOR;

{goto}		return GTOO;

{print}		return PRINT;

{word}		{
				yylval.string = strdup(yytext);
				return WORD;
			}

.		{}
%%
