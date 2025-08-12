#ifndef __APP
#define __APP

#include "file/file.h"
#include "logger/log.h"
#include "token/token.h"

typedef struct __App {
  const char *name;
  bool debug;
  log_level min_log_level;
  open_file_table oft;
  token_table tkt;
} App;


int main(int argc, char **argv);

bool compile(file_buffer *fb);

#endif
