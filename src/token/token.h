#ifndef __TOKEN
#define __TOKEN

typedef struct __Token {
  const char *value;
  int line;
  int column;
} Token;

typedef struct __TokenTable {
  Token *tokens;
  int size;
  int capacity;
} token_table;

#endif
