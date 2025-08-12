#ifndef _TOKEN
#define _TOKEN

#include "../defines.h"

#define MAX_TOKEN_SIZE 96

typedef enum __token_type {
  t_identifier = 0,
  t_operator = 1,
} token_type;

typedef struct __token {
  u64 idx;
  token_type t;
  char value[MAX_TOKEN_SIZE];
} token;

typedef struct __token_table {
  token *list;
  int len;
} token_table;

token tokenize_string(const char *input);

bool insert_into_token_table(token t);

#endif
