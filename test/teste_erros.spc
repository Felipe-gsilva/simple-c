// --- teste_erros.spc ---
// Arquivo de teste para validar o tratamento de erros do analisador lexico.

// Erro: Caractere inesperado ou desconhecido
// O analisador deve acusar o caractere '@' como invalido.
int a = 10 @ 20;

// Erro: Int mal formado
int c = -00000000012345;

// Erro: Literal de char mal formado (múltiplos caracteres)
// A regra de char só permite um caractere entre aspas simples.
char c = 'ab';

// Erro: Identificador não pode começar com número
// A regra de ID exige que o primeiro caractere seja uma letra ou _.
int 1variavel = 100;

// Erro: String multilinha não permitida
// A regra de string detecta a quebra de linha e gera um erro.
char* s = "esta string quebra
a linha";

// O programa continua para testar os erros de fim de arquivo (EOF).

/*
 * Os dois últimos erros precisam ocorrer no final do arquivo
 * para testar o comportamento do analisador com <<EOF>>.
 */
 
// Erro: Comentário de bloco não fechado
// O analisador chegará ao fim do arquivo dentro do estado IN_COMMENT.
/* Este comentário começa mas nunca termina...

// Erro: String não foi fechada no final do arquivo
// O analisador chegará ao fim do arquivo dentro do estado IN_STRING.
// ATENÇÃO: PARA TESTAR ESTE ERRO, COMENTE O ERRO 5 ACIMA.
// SÓ É POSSÍVEL TESTAR UM ERRO DE FIM DE ARQUIVO POR VEZ.
// char* final_error = "o arquivo acaba aqui sem fechar a aspa
