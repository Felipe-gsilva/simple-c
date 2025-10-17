%option noyywrap
%{
  #include <stdio.h>
  #include <string.h>
  #include "sintatico.tab.h"

  #define MAX_STR_LEN 8192
  char string_buf[MAX_STR_LEN];
  char *string_buf_ptr;

  int current_line = 1;
  int current_col = 1;

  void print_error(char* error_type);

  void update_col() {
    current_col += yyleng;
  }
  void add_char_to_string(char c) {
    if (string_buf_ptr < string_buf + MAX_STR_LEN - 1) {
      *string_buf_ptr++ = c;
    } else {
      print_error("Literal de string excedeu o tamanho máximo do buffer");
    }
  }
%}

%x IN_COMMENT IN_STRING IN_MULTI_STRING

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

"int"      { update_col();  return KEYWORD_INT; }
"float"    { update_col(); return KEYWORD_FLOAT; }
"char"     { update_col(); return KEYWORD_CHAR; }
"string"   { update_col(); return KEYWORD_STRING; }
"void"     { update_col(); return KEYWORD_VOID; }
"bool"     { update_col(); return KEYWORD_BOOL; }
"if"       { update_col(); return KEYWORD_IF; }
"else"     { update_col(); return KEYWORD_ELSE; }
"for"      { update_col(); return KEYWORD_FOR; }
"break"    { update_col(); return KEYWORD_BREAK; }
"continue" { update_col(); return KEYWORD_CONTINUE; }
"switch"   { update_col(); return KEYWORD_SWITCH; }
"case"     { update_col(); return KEYWORD_CASE; }
"default"  { update_col(); return KEYWORD_DEFAULT; }
"do"       { update_col(); return KEYWORD_DO; }
"while"    { update_col(); return KEYWORD_WHILE; }
"return"   { update_col(); return KEYWORD_RETURN; }

(true)      { yylval.int_val = 1; update_col(); return BOOLEAN_LITERAL; }
(false)     { yylval.int_val = 0; update_col(); return BOOLEAN_LITERAL; }


\"                  { 
  string_buf_ptr = string_buf;
  BEGIN(IN_STRING); 
}
<IN_STRING>{
  \"                { 
                        *string_buf_ptr = '\0';
                        yylval.str_val = strdup(string_buf);
                        update_col();
                        BEGIN(INITIAL);
                        return STRING_LITERAL;
                    }

  \n                {
                        print_error("Quebra de linha inesperada em literal de string");
                        current_line++; 
                        current_col = 1;
                        BEGIN(INITIAL);
                    }

  <<EOF>>           {
                        print_error("String não foi fechada (fim de arquivo inesperado)");
                        BEGIN(INITIAL);
                        return 0;
  }
  \\[ntr"\\']      { 
                        switch (yytext[1]) {
                            case 'n': add_char_to_string('\n'); break;
                            case 't': add_char_to_string('\t'); break;
                            case 'r': add_char_to_string('\r'); break;
                            case '"': add_char_to_string('\"'); break;
                            case '\\': add_char_to_string('\\'); break;
                            case '\'': add_char_to_string('\''); break;
                        }
                    }

  [^\\"\n]+         { 
                        char *yptr = yytext;
                        while (*yptr) {
                            add_char_to_string(*yptr++);
                        }
                    }
}

\"\"\"               { 
                        string_buf_ptr = string_buf;
                        BEGIN(IN_MULTI_STRING); 
                    }
<IN_MULTI_STRING>{
  \"\"\"             { 
                        *string_buf_ptr = '\0';
                        yylval.str_val = strdup(string_buf);
                        update_col();
                        BEGIN(INITIAL);
                        return STRING_LITERAL;
                    }

  \n                {
                        add_char_to_string('\n');
                        current_line++; 
                        current_col = 1;
                    }

  <<EOF>>           {
                        print_error("String multilinha não foi fechada (fim de arquivo inesperado)");
                        BEGIN(INITIAL);
                        return 0;
                    }

  \\[ntr"\\']      { 
                        // Processa sequências de escape (mesma lógica da string de linha única)
                        switch (yytext[1]) {
                            case 'n': add_char_to_string('\n'); break;
                            case 't': add_char_to_string('\t'); break;
                            case 'r': add_char_to_string('\r'); break;
                            case '"': add_char_to_string('\"'); break;
                            case '\\': add_char_to_string('\\'); break;
                            case '\'': add_char_to_string('\''); break;
                        }
                    }

  [^\\"\n]+         { 
                        char *yptr = yytext;
                        while (*yptr) {
                            add_char_to_string(*yptr++);
                        }
                    }
}


{FLOAT}   { 
  yylval.float_val = atof(yytext);
  update_col(); 
  return FLOAT_LITERAL;
}

[+-]?0[0-9]+ { print_error("Literal inteiro não pode ter zeros à esquerda"); update_col(); }
{INT}     { 
  yylval.int_val = atoi(yytext);
  update_col(); 
  return INT_LITERAL;
}


{ID}      {
  yylval.str_val = strdup(yytext);
  update_col(); 
  return IDENTIFICADOR;
}

\'(\\.|[^'\\])\'   { 
  yylval.char_val = yytext[1];
  update_col(); 
  return CHAR_LITERAL;
}

\=\=     { update_col(); return OP_IGUAL; }
\!=      { update_col(); return OP_DIFERENTE; }
\<\=     { update_col(); return OP_MENOR_IGUAL; }
\>\=     { update_col(); return OP_MAIOR_IGUAL; }
\<       { update_col(); return OP_MENOR; }
\>       { update_col(); return OP_MAIOR; }
!        { update_col(); return OP_NOT; }
\&\&     { update_col(); return OP_AND; }
\|\|     { update_col(); return OP_OR; }
\=       { update_col(); return OP_ATRIBUICAO; }
\+       { update_col(); return OP_SOMA; }
\-       { update_col(); return OP_SUB; }
\*       { update_col(); return OP_MULT; }
\/       { update_col(); return OP_DIV; }
\+\=     { update_col(); return OP_INC_ATRIBUICAO; }
\-\=     { update_col(); return OP_DEC_ATRIBUICAO; }
\/\=     { update_col(); return OP_DIV_ATRIBUICAO; }
\*\=     { update_col(); return OP_MULT_ATRIBUICAO; }
\-\-     { update_col(); return OP_DEC; }
\+\+     { update_col(); return OP_INC; }
\%       { update_col(); return OP_MOD; }

\;       { update_col(); return PONTO_VIRGULA; }
\:       { update_col(); return DOIS_PONTOS; }
\(       { update_col(); return ABRE_PARENTESES; }
\)       { update_col(); return FECHA_PARENTESES; }
\{       { update_col(); return ABRE_CHAVES; }
\}       { update_col(); return FECHA_CHAVES; }
\,       { update_col(); return VIRGULA; }
\[       { update_col(); return ABRE_COLCHETES; }
\]       { update_col(); return FECHA_COLCHETES; }

{INT}{ID} { print_error("Identificador não pode começar com número"); update_col(); }
\'([^']{2,})\' { print_error("Literal de char mal formado, contém múltiplos caracteres"); update_col(); }
.         { print_error("Caractere inesperado ou desconhecido"); update_col(); }

%%

void print_error(char* error_type) {
  fprintf(stderr, 
    "Erro Léxico na Linha %d, Coluna %d: %s. Token problemático: \"%s\"\n", 
    current_line, 
    current_col,
    error_type,
    yytext
  );
}
