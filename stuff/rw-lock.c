#include <assert.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include <stdint.h>

// http://jfdube.wordpress.com/2014/01/03/implementing-a-recursive-read-write-spinlock/
// http://jfdube.wordpress.com/2014/01/12/optimizing-the-recursive-read-write-spinlock/

struct RWSpinLock
{
  volatile uint32_t lock;
};

#if 1

void LockReader(struct RWSpinLock *l)
{
  while (1) {
    uint32_t OldLock = l->lock & 0x7fffffff;
    uint32_t NewLock = OldLock + 1;   
    if (__sync_val_compare_and_swap(&l->lock, OldLock, NewLock) == OldLock) return;
  }
}
  
void UnlockReader(struct RWSpinLock *l)
{
  assert ((l->lock & 0x7fffffff) > 0);
  __sync_sub_and_fetch(&l->lock, 1);
}

void LockWriter(struct RWSpinLock *l)
{
 again:
  {
    uint32_t OldLock = l->lock & 0x7fffffff;
    uint32_t NewLock = OldLock | 0x80000000;    
    if (!(__sync_val_compare_and_swap(&l->lock, OldLock, NewLock) == OldLock)) goto again;
    while (l->lock & 0x7fffffff) { }
  }
}

void UnlockWriter(struct RWSpinLock *l)
{
  assert(l->lock == 0x80000000);
  // this is necessary or else GCC will move operations out of the locked region!
  asm volatile("" ::: "memory");
  l->lock = 0;
}

#else

void LockReader(struct RWSpinLock *l)
{
  while (1) {
    uint32_t new = __sync_add_and_fetch(&l->lock, 1);
    if ((new & 0xffff0000) == 0) return;
    __sync_sub_and_fetch(&l->lock, 1);
  }
}
  
void UnlockReader(struct RWSpinLock *l)
{
  __sync_sub_and_fetch(&l->lock, 1);
}

void LockWriter(struct RWSpinLock *l)
{
  while (1) {
    uint32_t new = __sync_add_and_fetch(&l->lock, 0x10000);
    if ((new & 0xffff0000) == 0x10000) {
      while (l->lock & 0x0000ffff) { }
      return;
    }
    __sync_sub_and_fetch(&l->lock, 0x10000);
  }
}

void UnlockWriter(struct RWSpinLock *l)
{
  __sync_sub_and_fetch(&l->lock, 0x10000);
}

#endif

#ifdef BREAK

int important_data;
static struct RWSpinLock l;

void doit (void)
{
  LockWriter (&l);
  important_data /= 20;
  UnlockWriter (&l);
}
#endif

#ifdef TEST

#define N 4
static const int WORK = 0;
static const int duration = 60;

static struct RWSpinLock l;

struct per_thread {
  long work;
  int done;
  unsigned short seed[3];
  pthread_t t;
};

static struct per_thread thrds[N];

static volatile unsigned locked;

static const unsigned short _rand48_mult[3] = { 0xe66d, 0xdeec, 0x0005 };
static const unsigned short _rand48_add = 0x000b;

static void _dorand48 (unsigned short *xseed)
{
  unsigned long accu;
  unsigned short temp[2];
  accu = (unsigned long) _rand48_mult[0] * (unsigned long) xseed[0] + (unsigned long) _rand48_add;
  temp[0] = (unsigned short) accu;
  accu >>= sizeof(unsigned short) * 8;
  accu += 
    (unsigned long) _rand48_mult[0] * (unsigned long) xseed[1] + 
    (unsigned long) _rand48_mult[1] * (unsigned long) xseed[0];
  temp[1] = (unsigned short) accu;
  accu >>= sizeof(unsigned short) * 8;
  accu += 
    (unsigned long) _rand48_mult[0] * xseed[2] + 
    (unsigned long) _rand48_mult[1] * xseed[1] + 
    (unsigned long) _rand48_mult[2] * xseed[0];
  xseed[0] = temp[0];
  xseed[1] = temp[1];
  xseed[2] = (unsigned short) accu;
}

static long lrand48(int i)
{
  assert (i<N);
  unsigned short *_rand48_seed = thrds[i].seed;
  _dorand48(_rand48_seed);
  return ((long) _rand48_seed[2] << 15) + ((long) _rand48_seed[1] >> 1);
}

static void srand48(int i, int s)
{
  thrds[i].seed[0] = s;
}

static void *tester (void *arg)
{
  long i = (long) arg;
  srand48(i,i+getpid());
  while (!thrds[i].done) {
    LockReader (&l);
    if (WORK) {
      int count = lrand48(i) & 0xff;
      int c;
      unsigned x = locked;
      for (c=0; c<count; c++) {
	assert (x==locked);
      }
    }
    UnlockReader (&l);
    LockWriter (&l);
    if (WORK) {
      locked += lrand48(i);
      unsigned x = locked;
      int count = lrand48(i) & 0xff;
      int c;
      for (c=0; c<count; c++) {
	x++;
	locked++;
	assert (x==locked);
      }
    }
    UnlockWriter (&l);
    thrds[i].work++;
  }
  return NULL;
}

int main (void)
{
  long i;
  for (i=0; i<N; i++) {
    int res = pthread_create (&thrds[i].t, NULL, tester, (void *)i);
    assert (res==0);
  }
  sleep (duration);
  printf ("stopping...\n");
  for (i=0; i<N; i++) {
    thrds[i].done = 1;
  }
  for (i=0; i<N; i++) {
    int res = pthread_join (thrds[i].t, NULL);
    assert (res==0);
  }
  for (i=0; i<N; i++) {
    printf ("work[%ld] = %lf ops / sec\n", i, ((double)thrds[i].work)/duration);
  }
  return 0;
}

#endif
