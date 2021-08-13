%{
	#include<stdio.h>
	#include<string.h>
	char variable[255][10];
	int counter=0 , flag = 0;
%}

%%
\n	{}
"bool"  {flag = 1;}
"string" {flag = 1;}
"int" {flag = 1; }
"int main" {}
"char" {flag = 1; }
"float" {flag = 1;}
"," {if(flag==3 || flag==1){flag = 3;}}
";" {flag = 0; }
"=" {if(flag==1){flag = 2;} }
"string.h" {}
[a-zA-Z_-][a-zA-Z0-9_-]* {if(flag==1 || flag ==3){strcpy(variable[counter++],yytext);}}
. {}
%%

int yywrap() {}
int main()
{
	char address[100];
	printf("address file\n");
	scanf("%s",&address);
	FILE* f = fopen(address,"r");
	yyin = f;
	yylex();
	for(int k=0;k<counter;k++)
	printf("%s\n",variable[k]);
}
