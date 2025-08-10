#ifndef _FILE_H
#define _FILE_H

#include "../defines.h"

#define MAX_ENTRY_SIZE 4096

typedef struct __file_buffer {
  const char *name;
  FILE *fp;
} file_buffer;

typedef struct __open_file_table_entry {
  u64 priority;
  file_buffer *fb;
} open_file_table_entry;

typedef struct __open_file_table {
  open_file_table_entry *entries;
  u16 count;
  u64 len;
} open_file_table;

// procedures
file_buffer *open_file(const char *path, char *mode);

void init_file_table(u64 max_entries);

bool insert_to_file_table(file_buffer *fb, u64 priority);

#endif
