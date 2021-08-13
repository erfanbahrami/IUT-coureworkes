
%{
#include<stdio.h>
%}


%%

\/\/(.*) {};					

\/\*(.*\n)*.*\*\/  {};			
%%


int yywrap()
{
return 1;
}





int main(int argc, char** argv)
{
	yyin=fopen(argv[1],"r");	
	yyout=fopen("out.c","w");
	yylex();
	fclose(yyout);
	fclose(yyin);
	remove(argv[1]);
	rename("out.c", argv[1]);


return 0;

}
