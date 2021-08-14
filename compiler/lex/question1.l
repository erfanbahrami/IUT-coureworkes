

%{ 
#include<stdio.h> 
#include<string.h> 

char word [100];
int count = 0; 
int line_num=1;
int line [100];


%} 


%% 

[a-zA-Z]+ {if (strcmp(word, yytext)==0)
						{
							line[count]=line_num;
							count++;
						}
					}				

[\n]		{

					line_num++;}
. ;		 
%% 


int yywrap() 
{ 
	return 1; 
} 

int main(int argc, char** argv) 
{ 
		extern FILE *yyin, *yyout; 
		
		
		strcpy(word, argv[2]);

		yyin=fopen(argv[1], "r"); 
		yylex(); 
		
		printf("%d\n", count);
		
		FILE *in_file  = fopen(argv[1], "r");
		char lline [200];
		
		int r=0;
		
		for (int i=1; i<line_num; i++)
		{
			fgets(lline, 199, in_file);
			
			while (i==line[r])
			{
			
				
				printf("%d  :  %s \n",line[r], lline);
				r++;
			}
			

		}
		
		fclose(in_file);
		
		
		
} 

