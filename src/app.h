#ifndef __APP
#define __APP

#include "logger/log.h"
#include "token/token.h"
#include "parser/parser.h"

typedef struct __App {
  const char *name;
  bool debug;
  log_level min_log_level;
  token_table tkt;
} App;


int main(int argc, char **argv);

#endif
