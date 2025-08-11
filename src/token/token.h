#ifndef _TOKEN
#define _TOKEN

#include "../defines.h"

typedef enum __token_type {
  t_identifier = 0,
  t_operator = 1,
} token_type;

typedef struct __token {
  u64 idx;
  token_type t;
} token;

typedef struct __token_table {
  token *list;
  int len;
} token_table;


bool tokenize_string(char *input);


bool insert_into_token_table (token t);

#endif
