#include "file.h"
#include "../app.h"
#include "../logger/log.h"

extern App app;

void init_file_table(u64 max_entries) {
  app.oft.len = max_entries ? max_entries : MAX_ENTRY_SIZE;
  app.oft.entries = malloc(app.oft.len);
  app.oft.count = 0;
  c_info("Inited file table");
}

file_buffer *open_file(const char *path, char *mode) {
  file_buffer *fb = malloc(sizeof(file_buffer));

  fb->fp = fopen(path, mode);

  if (!fb->fp) {
    c_crit_error(FILE_OPEN_FAILURE, "Could not open file %s", path);
  }

  return fb;
};

bool insert_to_file_table(file_buffer *fb, u64 priority) {
  if (!fb->fp) {
    c_error(FILE_OPEN_FAILURE, "Cound not insert file into global table");
    return false;
  }

  if (app.oft.count >= MAX_ENTRY_SIZE - 2) {
    c_error(OPEN_FILE_TABLE_MAX_REACHED, "max open files reached");
    return false;
  }

  u64 i = app.oft.count++;
  app.oft.entries[i].fb = fb;
  app.oft.entries[i].priority = priority;

  return true;
}

bool remove_from_file_table_id(u64 idx) {

} 

bool remove_from_file_table_name(u64 idx) {

} 

bool process_input_file(file_buffer *fb) {
  // read and tokenize strings
}
