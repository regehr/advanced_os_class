
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

#define Exit(x) exit()
#define Printf(x,fmt,...) printf(x,fmt,__VA_ARGS__)
#define Wait() wait()

int main(void)
{
  shmget(1, 1, (void*)0xffff0000, 0);
  Exit(0);
}
