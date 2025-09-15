// --- teste_valido.spc ---
// Arquivo de teste para o analisador lexico da linguagem Simple C.
// Contem exemplos de todas as estruturas lexicais validas.

/*
  Este é um comentário de bloco
  que se estende por múltiplas linhas.
  Ele será ignorado pelo analisador.
*/

void uma_funcao_sem_retorno(int param1, float param2);

int main() {
    // Declaração de todos os tipos de dados primitivos
    int i = 12345;
    float _f = .5;
    char c = 'A';
    bool flag = true;
    char newline = '\n'; // Teste de escape em char
    int resultado_final = 0;

    // Teste de operadores de incremento e decremento
    i++;
    i--;

    // Teste de operadores de atribuição composta
    i += 10;
    i -= 2;
    i *= 3;
    i /= 4;
    
    // Expressão complexa com todos os operadores aritméticos
    float calculo = (i % 5) * 3.14 - 100. + _f;

    // Estrutura condicional 'if-else' com operadores lógicos e relacionais
    if (flag == true && (i < 1000 || i >= 2000)) {
        resultado_final = 1;
    } else if (!flag) {
        resultado_final = -1;
    }

    // Estrutura de repetição 'for' com break e continue
    for (int j = 0; j != 10; j++) {
        if (j <= 1) {
            continue; // Pula para a próxima iteração
        }
        if (j > 8) {
            break; // Interrompe o laço
        }
    }
    
    // Estruturas de repetição 'while' e 'do-while'
    int k = 10;
    while(k > 5) {
        k--;
    }
    
    do {
        k++;
    } while (k < 10);
    
    // Estrutura de seleção 'switch'
    switch (c) {
        case 'A':
            i = 1;
            break;
        case 'B':
            i = 2;
            break;
        default:
            i = 0;
    }

    // Teste de literais de string, incluindo escapes
    char* s = "Esta é uma string de teste com \"aspas\" escapadas.";
    char* outra_string_123 = "outra string";

    return resultado_final; // Fim do programa
}
