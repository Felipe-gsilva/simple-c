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
INT       [0-9]+
FLOAT     [0-9]+\.[0-9]*|\.[0-9]+

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

"if"      { print_token("KEYWORD_IF"); update_col(); }
"else"    { print_token("KEYWORD_ELSE"); update_col(); }
"while"   { print_token("KEYWORD_WHILE"); update_col(); }
"int"     { print_token("KEYWORD_INT"); update_col(); }
"return"  { print_token("KEYWORD_RETURN"); update_col(); }

\"        { BEGIN(IN_STRING); update_col(); }
<IN_STRING>\"       { print_token("STRING"); update_col(); BEGIN(INITIAL); }
<IN_STRING>[^"\n]+  { }
<IN_STRING>\n       {
    print_error("String multilinha não permitida");
    current_line++; current_col = 1;
    BEGIN(INITIAL);
}
<IN_STRING><<EOF>>  {
    print_error("String não foi fechada");
    return 0;
}

{ID}      { print_token("IDENTIFICADOR"); update_col(); }
{FLOAT}   { print_token("FLOAT"); update_col(); }
{INT}     { print_token("INT"); update_col(); }
\'.\'   { print_token("CHAR"); update_col(); }

\=\=      { print_token("OP_IGUAL"); update_col(); }
\!=      { print_token("OP_DIFERENTE"); update_col(); }
\<\=      { print_token("OP_MENOR_IGUAL"); update_col(); }
\>\=      { print_token("OP_MAIOR_IGUAL"); update_col(); }
\&\&      { print_token("OP_AND"); update_col(); }
\|\|      { print_token("OP_OR"); update_col(); }
\=       { print_token("OP_ATRIBUICAO"); update_col(); }
\+       { print_token("OP_SOMA"); update_col(); }
\-       { print_token("OP_SUB"); update_col(); }
\*       { print_token("OP_MULT"); update_col(); }
\/       { print_token("OP_DIV"); update_col(); }
\;       { print_token("PONTO_VIRGULA"); update_col(); }
\(       { print_token("ABRE_PARENTESES"); update_col(); }
\)       { print_token("FECHA_PARENTESES"); update_col(); }
\{       { print_token("ABRE_CHAVES"); update_col(); }
\}       { print_token("FECHA_CHAVES"); update_col(); }

{INT}{ID} { print_error("Identificador não pode começar com número"); update_col(); }
\'([^']{2,})\' { print_error("Literal de char mal formado, contém múltiplos caracteres"); update_col(); }
.         { print_error("Caractere inesperado ou desconhecido"); update_col(); }

%%
void print_token(char *token) {
  printf("Linha %-3d, Col %-3d | %-20s =>\t%s\n", current_line, current_col, token, yytext);
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
