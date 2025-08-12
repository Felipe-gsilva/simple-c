#ifndef __SCANNER
#define __SCANNER

#include "../defines.h"

typedef enum __state { q0, q1, q2 } state;

bool scan_str(const char *str);

#endif
