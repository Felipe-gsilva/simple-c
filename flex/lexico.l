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
COND_OP \>|\<|\>\>
BRACKETS [\{\}\[\]\(\)]

%%

[ \t\n]+ { }
{NUM}{ID}  { print("UNVALID VARIABLE DECLARATION"); }
{NUM}\. { print("UNFINISHED FLOAT"); }


{ID} { print("IDENTIFICADOR"); }
{NUM} { print("INT"); }
{NUM}\.{NUM} { print("FLOAT"); };
\.{NUM} { print("FLOAT"); }
{STRING} { print("STRING"); } 
{ARIT_OP} { print("ARITHMETIC_OP"); }
{COND_OP} { print("CONDITIONAL_OP"); }
{CHAR} { print("CHAR"); }
\;\n { print("ENDL"); }
{BRACKETS} { print("BRACKETS"); }
. { print("ERROR"); }

%%

void print(char *token) {
  printf("%s\t=>\t%s\n", token, yytext);
}

int main(void) {
  printf("Pressione CTRL+C para encerrar\n");
  yylex();
}
