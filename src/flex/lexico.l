%option noyywrap
%{
  #include <stdio.h>
  #include <string.h>

  int current_line = 1;
  int current_col = 1;

  void print_token(char* token);
  void print_error(char* error_type);

  void update_col() {
    current_col += yyleng;
  }
%}

%x IN_COMMENT IN_STRING

ID        [a-zA-Z_][a-zA-Z0-9_]*
INT       0|[+-]?[1-9][0-9]*
FLOAT     [+-]?([0-9]+\.[0-9]*|\.[0-9]+)

%%

\n        { current_line++; current_col = 1; }
[ \t]+    { update_col(); }

\/\/.*\n   { current_line++; current_col = 1; }

"/*"       { BEGIN(IN_COMMENT); update_col(); }
<IN_COMMENT>"*/" { BEGIN(INITIAL); update_col(); }
<IN_COMMENT>\n   { current_line++; current_col = 1; }
<IN_COMMENT>.    { update_col(); }
<IN_COMMENT><<EOF>> {
    print_error("Comentário de bloco não foi fechado");
    return 0;
}

"int"      { print_token("KEYWORD_INT"); update_col(); }
"float"    { print_token("KEYWORD_FLOAT"); update_col(); }
"char"     { print_token("KEYWORD_CHAR"); update_col(); }
"string"   { print_token("KEYWORD_STRING"); update_col(); }
"void"     { print_token("KEYWORD_VOID"); update_col(); }
"bool"     { print_token("KEYWORD_BOOL"); update_col(); }
"if"       { print_token("KEYWORD_IF"); update_col(); }
"else"     { print_token("KEYWORD_ELSE"); update_col(); }
"for"      { print_token("KEYWORD_FOR"); update_col(); }
"break"    { print_token("KEYWORD_BREAK"); update_col(); }
"continue" { print_token("KEYWORD_CONTINUE"); update_col(); }
"switch"   { print_token("KEYWORD_SWITCH"); update_col(); }
"case"     { print_token("KEYWORD_CASE"); update_col(); }
"default"  { print_token("KEYWORD_DEFAULT"); update_col(); }
"do"       { print_token("KEYWORD_DO"); update_col(); }
"while"    { print_token("KEYWORD_WHILE"); update_col(); }
"return"   { print_token("KEYWORD_RETURN"); update_col(); }

"true"    { print_token("BOOLEAN_LITERAL"); update_col(); }
"false"   { print_token("BOOLEAN_LITERAL"); update_col(); }

\"                         { BEGIN(IN_STRING); yymore(); }
<IN_STRING>(\\.|[^\\"\n])+ { yymore(); }
<IN_STRING>\"              { print_token("STRING"); update_col(); BEGIN(INITIAL); }
<IN_STRING>\n              {
                            print_error("String multilinha não permitida");
                            current_line++; current_col = 1;
                            BEGIN(INITIAL);
                           }
<IN_STRING><<EOF>>         {
                            print_error("String não foi fechada");
                            return 0;
                           }

{FLOAT}   { print_token("FLOAT"); update_col(); }
[+-]?0[0-9]+ { print_error("Literal inteiro não pode ter zeros à esquerda"); update_col(); }
{INT}     { print_token("INT"); update_col(); }

{ID}      { print_token("IDENTIFICADOR"); update_col(); }
\'(\\.|[^'\\])\'   { print_token("CHAR"); update_col(); }

\=\=      { print_token("OP_IGUAL"); update_col(); }
\!=      { print_token("OP_DIFERENTE"); update_col(); }
\<\=      { print_token("OP_MENOR_IGUAL"); update_col(); }
\>\=      { print_token("OP_MAIOR_IGUAL"); update_col(); }
\<       { print_token("OP_MENOR"); update_col(); }
\>       { print_token("OP_MAIOR"); update_col(); }
!        { print_token("OP_NOT"); update_col(); }
\&\&      { print_token("OP_AND"); update_col(); }
\|\|      { print_token("OP_OR"); update_col(); }
\=       { print_token("OP_ATRIBUICAO"); update_col(); }
\+       { print_token("OP_SOMA"); update_col(); }
\-       { print_token("OP_SUB"); update_col(); }
\*       { print_token("OP_MULT"); update_col(); }
\/       { print_token("OP_DIV"); update_col(); }
\+\=      { print_token("OP_INC_ATRIBUICAO"); update_col(); }
\-\=     { print_token("OP_DEC_ATRIBUICAO"); update_col(); }
\/\=    { print_token("OP_DIV_ATRIBUICAO"); update_col(); }
\*\=    { print_token("OP_MULT_ATRIBUICAO"); update_col(); }
\-\-     { print_token("OP_DEC"); update_col(); }
\+\+     { print_token("OP_INC"); update_col(); }
\%       { print_token("OP_MOD"); update_col(); }

\;       { print_token("PONTO_VIRGULA"); update_col(); }
\:       { print_token("DOIS_PONTOS"); update_col(); }
\(       { print_token("ABRE_PARENTESES"); update_col(); }
\)       { print_token("FECHA_PARENTESES"); update_col(); }
\{       { print_token("ABRE_CHAVES"); update_col(); }
\}       { print_token("FECHA_CHAVES"); update_col(); }
\,       { print_token("VIRGULA"); update_col(); }
\[       { print_token("ABRE_COLCHETES"); update_col(); }
\]       { print_token("FECHA_COLCHETES"); update_col(); }

{INT}{ID} { print_error("Identificador não pode começar com número"); update_col(); }
\'([^']{2,})\' { print_error("Literal de char mal formado, contém múltiplos caracteres"); update_col(); }
.         { print_error("Caractere inesperado ou desconhecido"); update_col(); }

%%
void print_token(char *token) {
  printf("Linha %03d, Col %03d | %-20s =>\t%s\n", current_line, current_col, token, yytext);
}

void print_error(char* error_type) {
  fprintf(stderr, 
    "Erro Léxico na Linha %d, Coluna %d: %s. Token problemático: \"%s\"\n", 
    current_line, 
    current_col,
    error_type,
    yytext
  );
}

int main(void) {
  printf("Analisador Léxico com análise de erro.\n");
  printf("Pressione CTRL+D (Linux) ou CTRL+Z (Windows) para encerrar.\n\n");
  yylex();
  return 0;
}
