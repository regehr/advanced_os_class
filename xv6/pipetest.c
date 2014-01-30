// comment out this line before doing bandwidth tests
// #define CHECK 1

// define VERBOSE 1

#ifdef __XV6__

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

#define Exit(x) exit()
#define Printf(x,fmt,...) printf(x,fmt,__VA_ARGS__)
#define Wait() wait()

static unsigned long get_ms (void)
{
  unsigned long msec;
  unsigned long sec; 
  if(gettime(&msec,&sec)<0){
    printf(1,"Error on gettime");
    exit();
  }
  long t = (sec * 1000) + msec;
  return t;
}

#else /* not __XV6 __ */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <sys/time.h>

#define Exit(x) exit(x)
#define Printf(x,fmt,...) printf(fmt,__VA_ARGS__)
#define Wait() wait(NULL)

static unsigned long get_ms (void)
{
  struct timeval tv;
  gettimeofday (&tv, NULL);
  long t = (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
  return t;
}

#endif

static void AssertionFailure(char *exp, char *file, int line)
{
  Printf (1, "Assertion '%s' failed at line %d of file %s\n", exp, line, file);
  Exit(-1);
}

#define Assert(exp) if (exp) ; else AssertionFailure( #exp, __FILE__,  __LINE__ ) 

#define BLOCK_SIZE 8192
static unsigned char buf[BLOCK_SIZE];

static const int BYTES = 10*1000*1000;

#ifdef CHECK

// do this the cheesy way to avoid makefile hacking
#include "rand48.c"

static struct _rand48_state s, s2;

#endif

static int reads, writes;

static int _read (int fd, unsigned char *buf, int len)
{
  reads++;
#ifdef CHECK
  len = (_lrand48(&s2)%len) + 1;
#endif
  return read (fd, buf, len);
}

static int _write (int fd, unsigned char *buf, int len)
{
  writes++;
#ifdef CHECK
  len = (_lrand48(&s2)%len) + 1;
#endif
  return write (fd, buf, len);
}

static void reader (int fd)
{
  int bytes_read = 0;
  int z;
  do {
    z = _read (fd, buf, BLOCK_SIZE);
#ifdef VERBOSE
    Printf (1, "read %d bytes\n", z);
#endif
    Assert (z != -1);      
    bytes_read += z;
#ifdef CHECK
    {
      int i;
      for (i=0; i<z; i++) {
	unsigned char expect = _lrand48(&s);
	Assert (buf[i] == expect);
      }
    }
#endif
  } while (z != 0);
  Printf (1, "%d bytes read in %d calls to read()\n", bytes_read, reads);
}

static void writer (int fd)
{  
  int bytes_wrote = 0;
#ifdef CHECK
  int last_pos = BLOCK_SIZE;
#endif
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
      }
    }
#endif
    int z = _write (fd, buf, BLOCK_SIZE);
#ifdef VERBOSE
    Printf (1, "wrote %d bytes\n", z);
#endif
    Assert (z != 0);
#ifdef CHECK
    last_pos = z;
#endif
    bytes_wrote += z;
  } while (bytes_wrote < BYTES);
  Printf (1, "%d bytes written in %d calls to write()\n", bytes_wrote, writes);
}

int main (void)
{
#ifdef CHECK
  _srand48(&s, getpid());
  _srand48(&s2, getpid()+77);
  Printf (1, "running in checked mode\n%s", "");
#endif

  long start = get_ms();
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
    Exit (0);
  } else {
    int res = close(pipefd[0]);
    Assert (res == 0);
    writer(pipefd[1]);
    res = close(pipefd[1]);
    Assert (res == 0);
    res = Wait();
    Assert (res != -1);
  }
  long duration = get_ms() - start;
  Printf (1, "elapsed time = %d ms\n", (int)duration);

  Exit(0);
}
