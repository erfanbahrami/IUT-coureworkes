%{
  #include <stdio.h>
  #include <string.h>
  
  char address[100];
  int line = 0, words = 0, characters = 0, capital = 0, lower = 0;
%}

%%
"\n"                {line += 1;}
[A-Z][A-Za-z0-9]*   {words += 1; capital += 1;characters += strlen(yytext);}

[a-z][A-Za-z0-9]*   {words += 1; lower += 1;characters += strlen(yytext);}

.        {characters += 1;}
%%

int yywrap() {}

int main()
{
  printf("address file:\n");
  scanf("%s", address);
  yyin = fopen(address, "r");
  yylex();

  printf("\nWords : %d\n", words);
  printf("lines : %d\n", line);
  printf("Characters : %d\n", characters);
  printf("Words start with Capital letter: %d\n", capital);
}