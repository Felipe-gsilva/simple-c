#ifndef __APP
#define __APP

#include "file/file.h"
#include "logger/log.h"

typedef struct __App {
  const char *name;
  bool debug;
  log_level min_log_level;
  open_file_table oft;
} App;

typedef enum __token_type {
  t_identifier = 0,
  t_operator = 1,
} token_type;

typedef struct __token {
  u64 idx;
  token_type t;
} token;

int main(int argc, char **argv);

bool compile(file_buffer *fb);

#endif
