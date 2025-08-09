#ifndef __FILE_H
#define __FILE_H

#include "../defines.h"

typedef struct __file_buffer {
  const char *name;
  FILE *fp;
} file_buffer;

file_buffer *open_file(const char *path, char mode);

#endif
