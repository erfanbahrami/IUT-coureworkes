%{ 
#include<stdio.h> 
#include<string.h> 
char addr[20];  
char replace_with[20]; 
char replace[20]; 
  
  
%} 
  

  
%% 
[a-zA-Z]+    { if(strcmp(yytext, replace)==0) 
                   fprintf(yyout, "%s", replace_with); 
                else
                    fprintf(yyout, "%s", yytext);} 
.            fprintf(yyout, "%s", yytext); 
%% 
  
  
int yywrap() 
{ 
    return 1; 
} 
  
/* code section */
int main() 
{

    printf("\naddress file:\n");
	scanf("%s", addr);

    printf("Word 1:\n");
	scanf("%s", replace);
	 
    printf("Word 1:\n");
	scanf("%s", replace_with);

    
    extern FILE *yyin, *yyout; 
    yyin=fopen(addr,"r");	
	yyout=fopen("out.c","w");
	yylex();
	fclose(yyout);
	fclose(yyin);
	remove(addr);
	rename("out.c", addr);


return 0;
} 