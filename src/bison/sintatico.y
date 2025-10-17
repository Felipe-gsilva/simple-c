%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *s);

extern int current_line;
extern int current_col;
%}

%union {
    char* str_val;
    int   int_val;
    float float_val;
    char  char_val;
}

%start programa

%token <str_val>   IDENTIFICADOR STRING_LITERAL
%token <int_val>   INT_LITERAL BOOLEAN_LITERAL
%token <float_val> FLOAT_LITERAL
%token <char_val>  CHAR_LITERAL

%token KEYWORD_INT KEYWORD_FLOAT KEYWORD_CHAR KEYWORD_STRING KEYWORD_VOID KEYWORD_BOOL
%token KEYWORD_IF KEYWORD_ELSE KEYWORD_FOR KEYWORD_WHILE KEYWORD_DO
%token KEYWORD_SWITCH KEYWORD_CASE KEYWORD_DEFAULT KEYWORD_BREAK KEYWORD_CONTINUE KEYWORD_RETURN

%token OP_SOMA OP_SUB OP_MULT OP_DIV OP_MOD OP_ATRIBUICAO OP_INC_ATRIBUICAO OP_DEC_ATRIBUICAO
%token OP_MULT_ATRIBUICAO OP_DIV_ATRIBUICAO OP_INC OP_DEC OP_IGUAL OP_DIFERENTE
%token OP_MENOR OP_MAIOR OP_MENOR_IGUAL OP_MAIOR_IGUAL OP_AND OP_OR OP_NOT

%token PONTO_VIRGULA DOIS_PONTOS VIRGULA ABRE_PARENTESES FECHA_PARENTESES
%token ABRE_CHAVES FECHA_CHAVES ABRE_COLCHETES FECHA_COLCHETES

%right OP_ATRIBUICAO OP_INC_ATRIBUICAO OP_DEC_ATRIBUICAO OP_MULT_ATRIBUICAO OP_DIV_ATRIBUICAO
%left  OP_OR
%left  OP_AND
%left  OP_IGUAL OP_DIFERENTE
%left  OP_MENOR OP_MAIOR OP_MENOR_IGUAL OP_MAIOR_IGUAL
%left  OP_SOMA OP_SUB
%left  OP_MULT OP_DIV OP_MOD
%right OP_NOT
%nonassoc "then"
%nonassoc KEYWORD_ELSE

%%
/* ======================== Regras da Gramática ======================== */

programa:
    | lista_declaracoes_globais
    ;

lista_declaracoes_globais:
    declaracao_global
    | lista_declaracoes_globais declaracao_global
    ;

declaracao_global:
    declaracao_funcao
    | definicao_funcao
    ;

declaracao_funcao:
    tipo_retorno IDENTIFICADOR ABRE_PARENTESES params FECHA_PARENTESES PONTO_VIRGULA
    { printf("INFO: Protótipo de função '%s' reconhecido.\n", $2); free($2); }
    ;

definicao_funcao:
    tipo_retorno IDENTIFICADOR ABRE_PARENTESES params FECHA_PARENTESES bloco
    { printf("INFO: Definição de função '%s' reconhecida.\n", $2); free($2); }
    ;

tipo_retorno:
    tipo
    | KEYWORD_VOID
    ;

tipo:
    KEYWORD_INT
    | KEYWORD_FLOAT
    | KEYWORD_CHAR
    | KEYWORD_STRING
    | KEYWORD_BOOL
    ;

params:
    | lista_params
    ;

lista_params:
    param
    | lista_params VIRGULA param
    ;

param:
    tipo IDENTIFICADOR { free($2); }
    ;

bloco:
    ABRE_CHAVES lista_comandos FECHA_CHAVES
    ;

lista_comandos:
    | lista_comandos comando
    ;

comando:
    comando_expressao
    | declaracao_variavel
    | comando_if
    | comando_for
    | comando_while
    | comando_do_while
    | comando_switch
    | comando_return
    | comando_break
    | comando_continue
    | bloco
    ;

comando_expressao:
    expressao PONTO_VIRGULA
    ;

declaracao_variavel:
    tipo IDENTIFICADOR PONTO_VIRGULA { free($2); }
    | tipo IDENTIFICADOR OP_ATRIBUICAO expressao PONTO_VIRGULA { free($2); }
    ;

comando_if:
    KEYWORD_IF ABRE_PARENTESES expressao FECHA_PARENTESES comando %prec "then"
    | KEYWORD_IF ABRE_PARENTESES expressao FECHA_PARENTESES comando KEYWORD_ELSE comando
    ;

comando_for:
    KEYWORD_FOR ABRE_PARENTESES declaracao_variavel expressao PONTO_VIRGULA expressao FECHA_PARENTESES comando
    ;

comando_while:
    KEYWORD_WHILE ABRE_PARENTESES expressao FECHA_PARENTESES comando
    ;

comando_do_while:
    KEYWORD_DO comando KEYWORD_WHILE ABRE_PARENTESES expressao FECHA_PARENTESES PONTO_VIRGULA
    ;

comando_return:
    KEYWORD_RETURN expressao PONTO_VIRGULA
    ;

comando_break:
    KEYWORD_BREAK PONTO_VIRGULA
    ;

comando_continue:
    KEYWORD_CONTINUE PONTO_VIRGULA
    ;

comando_switch:
    KEYWORD_SWITCH ABRE_PARENTESES expressao FECHA_PARENTESES ABRE_CHAVES lista_casos FECHA_CHAVES
    ;

lista_casos:
    /* vazio */
    | lista_casos caso
    ;

caso:
    KEYWORD_CASE literal DOIS_PONTOS lista_comandos
    | KEYWORD_DEFAULT DOIS_PONTOS lista_comandos
    ;


expressao:
    IDENTIFICADOR { free($1); }
    | literal
    | expressao OP_SOMA expressao
    | expressao OP_SUB expressao
    | expressao OP_MULT expressao
    | expressao OP_DIV expressao
    | expressao OP_MOD expressao
    | expressao OP_MENOR expressao
    | expressao OP_MAIOR expressao
    | expressao OP_MENOR_IGUAL expressao
    | expressao OP_MAIOR_IGUAL expressao
    | expressao OP_IGUAL expressao
    | expressao OP_DIFERENTE expressao
    | expressao OP_AND expressao
    | expressao OP_OR expressao
    | OP_NOT expressao
    | OP_SUB expressao %prec OP_NOT /* Unary minus precedence */
    | IDENTIFICADOR OP_ATRIBUICAO expressao { free($1); }
    | IDENTIFICADOR OP_INC_ATRIBUICAO expressao { free($1); }
    | IDENTIFICADOR OP_DEC_ATRIBUICAO expressao { free($1); }
    | IDENTIFICADOR OP_MULT_ATRIBUICAO expressao { free($1); }
    | IDENTIFICADOR OP_DIV_ATRIBUICAO expressao { free($1); }
    | IDENTIFICADOR OP_INC { free($1); }
    | IDENTIFICADOR OP_DEC { free($1); }
    | ABRE_PARENTESES expressao FECHA_PARENTESES
    ;

literal:
    INT_LITERAL
    | FLOAT_LITERAL
    | CHAR_LITERAL
    | STRING_LITERAL { free($1); }
    | BOOLEAN_LITERAL
    ;

%%

int main(int argc, char **argv) {
    printf("Analisador Sintático Completo para a linguagem Simple C.\n");
    printf("Iniciando a análise...\n\n");
    yyparse();
    printf("\nAnálise sintática concluída com sucesso.\n");
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr,
        "Erro Sintático na Linha %d, Coluna %d: %s\n",
        current_line,
        current_col,
        s
    );
    exit(1);
}
