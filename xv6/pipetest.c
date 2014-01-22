#ifdef __XV6__

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

#define Exit(x) exit()
#define Printf(x,fmt,...) printf(x,fmt,__VA_ARGS__)
#define Wait() wait()

#else /* not __XV6 __ */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

#define Exit(x) exit(x)
#define Printf(x,fmt,...) printf(fmt,__VA_ARGS__)
#define Wait() wait(NULL)

#endif

void AssertionFailure(char *exp, char *file, int line)
{
  Printf (1, "Assertion '%s' failed at line %d of file %s\n", exp, line, file);
  Exit(-1);
}

#define Assert(exp) if (exp) ; else AssertionFailure( #exp, __FILE__,  __LINE__ ) 

#define BLOCK_SIZE 8192

const int N = 10*1000*1000;

char buf[BLOCK_SIZE];

void reader (int fd)
{
  int bytes_read = 0;
  int z;
  do {
    z = read (fd, buf, BLOCK_SIZE);
    Assert (z != -1);      
    bytes_read += z;
  } while (z != 0);
  Printf (1, "reader process read %d bytes\n", bytes_read);
}

void writer (int fd)
{  
  int bytes_wrote = 0;
  do {
    int z = write (fd, buf, BLOCK_SIZE);
    Assert (z != 0);
    bytes_wrote += z;
  } while (bytes_wrote < N);
  Printf (1, "writer process wrote %d bytes\n", bytes_wrote);
}

int main (void)
{
  int pipefd[2];
  int res = pipe (pipefd);
  Assert (res==0);
  int pid = fork();
  Assert (pid >= 0);
  if (pid == 0) {
    int res = close(pipefd[1]);
    Assert (res == 0);
    reader(pipefd[0]);
    res = close(pipefd[0]);
    Assert (res == 0);
  } else {
    int res = close(pipefd[0]);
    Assert (res == 0);
    writer(pipefd[1]);
    res = close(pipefd[1]);
    Assert (res == 0);
    res = Wait();
    Assert (res != -1);
  }
  Exit(0);
}
