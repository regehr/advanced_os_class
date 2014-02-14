#include "types.h"
#include "user.h"

#define CHECK

#ifdef CHECK

#include "rand48.c"

#endif

static struct _rand48_state rand;

int main(void)
{
    int token = 0xBADC0C0A;

#ifdef CHECK
    _srand48(&rand, getpid());
#endif
}
