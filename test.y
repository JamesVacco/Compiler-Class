%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>

	#define noop 0
	#define prnt 1
	#define gtoo 2


	int yylex();
	void yyerror (const char*);
	void gotinstruction (int, int);
	void prninstruction (int, char*);

	struct ins
	{
		int opcode;
		int p0;
		int p1;
		char *string;
	};

	
%}

%union
{
	char *string;
	int value;
}

%token <value>NUMBER
%token ADDOP
%token SUBOP
%token MULTOP
%token DIVOP
%token ASSIGN
%token FOR
%token GTOO
%token PRINT
%token <string> WORD

%%
exps:		exps exp;
		|
		exp;

exp:	prn_exp;
		|
		got_exp;

		

prn_exp:	NUMBER PRINT WORD
		{
			prninstruction($1, $3);
		}
		;
got_exp:	NUMBER GTOO NUMBER
		{
			gotinstruction($1, $3);
		}
%%

struct ins instruction[100];

int main (int argc, char *argv[])
	{
		FILE *fp;
		extern FILE *yyin;
		extern int yyparse();
		int i;
		
		

		for (i = 0; i < 100; i++)
		{
			instruction[i].opcode = noop;
		}
		
		

		if (argc > 1)
		{
			fp = fopen (argv[1], "r");
			if ((fp = fopen (argv[1], "r")) == 0)
			{
				printf ("Could not open %s", argv[1]);
			}
			else
			{
				yyin = fp;
				yyparse();
				int current_instruction = 0;
				
				
				
				
				while (current_instruction < 100)
				{	
					if(instruction[current_instruction].opcode==prnt)
					{
						printf("%s\n",
							instruction[current_instruction].string);
					}
					else if(instruction[current_instruction].opcode==gtoo)
					{
						current_instruction = (instruction[current_instruction].p0 - 1);
					}
					current_instruction++;
				}
			}

		}
		else
		{
			printf("Usage: %s <filename>\n", argv[0]);
		}

	}

	
	void prninstruction (int l, char *n0)
	{
		
		if(instruction[l].opcode == noop)
		{
			instruction[l].opcode = prnt;
			instruction[l].string = n0;

		}
		else
		{
			yyerror("Cannot use two of same line");
			exit(0);
		}
	}
	
	void gotinstruction (int l, int n0)
	{
		if(instruction[l].opcode == noop)
		{
			instruction[l].opcode = gtoo;
			instruction[l].p0 = n0;
			printf("goto hit");
		}
		else
		{
			yyerror("Cannot use two of same line");
			exit(0);
		}
	}

	void yyerror (const char *err)
	{
		printf ("Error: %s\n", err);
	}
