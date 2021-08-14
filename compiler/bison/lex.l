%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "gram.tab.h"

char* variable_names[100]; 

int variable_set[100];

int variable_counter = 0; 

double variable_values[100];


int add_variable(char* var_name)
{
	int x; 
	

	for (x = 0; x<variable_counter; x++) {
		if (strcmp(var_name, variable_names[x]) == 0) {
				return x;
		}
	}

	variable_counter++;
	variable_names[x] = strdup(var_name);
	return x;
}

int set_variable(int index, double val)
{
	variable_values[index] = val;
	variable_set[index] = 1;
	
	return val;
}

%}

%option noyywrap


%%
[ \t]
[0-9]+(\.[0-9]+)?          					{ yylval.num = atof(yytext); return NUMBER; }
"+"                         					{ return ADD; }
"-"                         					{ return SUB; }
"*"                         					{ return MUL; }
"/"                         					{ return DIV; }
"^"                         					{ return EXP; }
"="																		{ return EQUALS; }
("exp")|("EXP")												{	return EXP; }
("sqrt")|("SQRT")											{ return SQRT; }
("log")|("LOG")												{ return LOG; }
[a-zA-Z0-9]+  												{ yylval.index = add_variable(yytext); return VARIABLE; }
[\n]                        					{ return EOL; }
. 																		{ yyerror("Undefined symbol"); exit(1); } 
%%
