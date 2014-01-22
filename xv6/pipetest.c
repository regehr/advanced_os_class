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
unsigned char buf[BLOCK_SIZE];

const int BYTES = 10*1000*1000;

#ifdef CHECK

// do this the cheesy way to avoid makefile hacking
#include "rand48.c"

struct _rand48_state s;

#endif

static int _read (int fd, unsigned char *buf, int len)
{
#ifdef BE_MEAN
  len = (rand()%len) + 1;
#endif
  return read (fd, buf, len);
}

static int _write (int fd, unsigned char *buf, int len)
{
#ifdef BE_MEAN
  len = (rand()%len) + 1;
#endif
  return write (fd, buf, len);
}

static void reader (int fd)
{
  int bytes_read = 0;
  int z;
  do {
    z = _read (fd, buf, BLOCK_SIZE);
    Assert (z != -1);      
    bytes_read += z;
#ifdef CHECK
    {
      int i;
      for (i=0; i<z; i++) {
	unsigned char expect = _lrand48(&s);
#ifdef VERBOSE
	printf( "read %02x, expected %02x\n", buf[i], expect);
#endif
	Assert (buf[i] == expect);
      }
    }
#endif
  } while (z != 0);
  Printf (1, "reader process read %d bytes\n", bytes_read);
}

static void writer (int fd)
{  
  int bytes_wrote = 0;
  int last_pos = BLOCK_SIZE;
  do {
#ifdef CHECK
    {
      int i;
      for (i=0; i<BLOCK_SIZE; i++) {	
	if (last_pos < BLOCK_SIZE) {
	  buf[i] = buf[last_pos];
	  last_pos++;
	} else {
	  buf[i] = _lrand48(&s);
	}
#ifdef VERBOSE
	printf( "writing %02x\n", buf[i]);
#endif
      }
    }
#endif
    int z = _write (fd, buf, BLOCK_SIZE);
    Assert (z != 0);
    last_pos = z;
    bytes_wrote += z;
  } while (bytes_wrote < BYTES);
  Printf (1, "writer process wrote %d bytes\n", bytes_wrote);
}

int main (void)
{
#ifdef CHECK
  _srand48(&s, getpid());
  Printf (1, "running in checked mode\n%s", "");
#endif
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
