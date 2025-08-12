#include "token.h"
#include "../app.h"

extern App app;

const char *const c_operators[] = {
    "=",  "==", "!=", ">",  "<",  ">=", "<=", "+", "-", "*",
    "/",  "%",  "&&", "||", "!",  "&",  "|",  "^", "~", "+=",
    "-=", "*=", "/=", "%=", "++", "--", "->", "."};

const size_t c_operators_count = sizeof(c_operators) / sizeof(c_operators[0]);

token tokenize_string(const char *input) {
  token t;
  bool isOp = false;

  if (strlen(input) == 1 || strlen(input) == 2) {
    for (int i = 0; i < c_operators_count; i++) {
      if (strcmp(input, c_operators[i]) == 0) {
        isOp = true;
        break;
      }
    }
  }

  t.t = isOp ? t_operator : t_identifier;
  strcpy(input, t.value);
  t.idx = app.tkt.len++;

  return t;
}

bool insert_into_token_table(token t) {
  if (app.tkt.len <= t.idx) {
    c_error(TOKEN_TABLE_ERROR, "Could not insert token");
    return false;
  }
  app.tkt.list[t.idx] = t;
  return true;
}
