#include "scanner.h"
#include "../logger/log.h"
#include "../token/token.h"

bool scan_str(const char *str) {
  char c;
  state curr_state = q0;

  while (c != '\0') {
    if (curr_state == q0 && c >= 'a' && c <= 'z')
      curr_state = q1;
    else if (curr_state == q1 &&
             ((c >= '0' && c <= '9') || (c >= 'a' && c <= 'z')))
      continue;
    else
      break;
  }

  if (curr_state == q1) {
    c_info("String %s accepeted", str);
    if (insert_into_token_table(tokenize_string(str))) {
      return true;
    };
  }

  return false;
}
