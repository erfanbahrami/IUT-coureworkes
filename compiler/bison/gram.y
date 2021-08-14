%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gram.tab.h"


extern double variable_values[100];
extern int variable_set[100];


extern int yylex(void);
extern void yyterminate();
void yyerror(const char *s);
extern FILE* yyin;
%}

%union {
	int index;
	double num;
}

%token<num> NUMBER
%token<num> DIV MUL ADD SUB EQUALS
%token<num> EXP SQRT
%token<num> LOG
%token<num> VAR_KEYWORD 
%token<index> VARIABLE
%token<num> EOL
%type<num> program_input
%type<num> line
%type<num> calculation
%type<num> expr
%type<num> function
%type<num> log_function
%type<num> assignment


%left SUB 
%left ADD
%left MUL 
%left DIV 
%left POW SQRT 

%%
program_input:
	| program_input line
	;
	
line: 
			EOL 						 { printf("Please enter a calculation:\n"); }
		| calculation EOL  { printf("=%.2f\n",$1); }
    ;

calculation:
		  expr
		| function
		| assignment
		;
		
		
expr:
			SUB expr					{ $$ = -$2; }
    | NUMBER            { $$ = $1; }
		| VARIABLE					{ $$ = variable_values[$1]; }	
		| function
		| expr DIV expr     { if ($3 == 0) { yyerror("Cannot divide by zero"); exit(1); } else $$ = $1 / $3; }
		| expr MUL expr     { $$ = $1 * $3; }
		| expr ADD expr     { $$ = $1 + $3; }
		| expr SUB expr   	{ $$ = $1 - $3; }
		| expr EXP expr     { $$ = pow($1, $3); }
    ;
		
function: 
		 log_function
		|	SQRT expr      		{ $$ = sqrt($2); }


log_function:
		 LOG expr 				{ $$ = log10($2); }
		;
		
		
assignment: 
		VAR_KEYWORD VARIABLE EQUALS calculation { $$ = set_variable($2, $4); }
		;
%%

/* Entry point */
int main(int argc, char **argv)
{
		yyin = stdin;
		yyparse();
	
}

void yyerror(const char *s)
{
	printf("ERROR: %s\n", s);
}
