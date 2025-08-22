%option noyywrap
%{ 
  #include <stdio.h>
  void print(char*);
%}

NUM [0-9]+
ID [A-Za-z]+[A-Za-z0-9_]*
STRING   \"[^"\n]*\"
CHAR     \'[^\']\'
ARIT_OP \=|\+|\*|\/|\%|\-
COND_OP \>|\<|\>\>|

%%

[ \t\n]+ { print("IGNORA BRO"); }
{ID} { print("identificador"); }
{NUM} { print("INT"); }
{NUM}\.{NUM} { print("FLOAT"); };
{STRING} { print("STRING"); } 
{ARIT_OP} { print("ARITHMETIC_OP"); }
{COND_OP} { print("CONDITIONAL_OP"); }
{CHAR} { print("CHAR"); }
. { print("ERROR"); }

%%

void print(char *token) {
  printf("%s\t=>\t%s\n", token, yytext);
}

int main(void) {
  printf("Pressione CTRL+C para encerrar\n");
  yylex();
}
