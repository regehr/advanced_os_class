#include "ring.h"

#include "user.h"
 #define PAGE_SIZE  4096
#define RING_SIZE  32*PAGE_SIZE
#define ALLOC_SIZE RING_SIZE+PAGE_SIZE
#define SPACE (RING_SIZE>>2)

#define START 0x08000000

#define BUFFER(r) ((volatile uint*)((r)->buf))
#define READ SPACE
#define READ_RES (READ+1)
#define WRITE (READ_RES+1)
#define WRITE_RES (WRITE+1)
#define MASK (SPACE-1)

struct ring *ring_attach(uint token)
{
  if(shmget(token, (void*)START, ALLOC_SIZE) < 0) {
    return 0;
  }
  struct ring * r = malloc(sizeof(struct ring));
  if(!r) {
    return 0;
  }
  r->tok = token;
  r->buf = (void*)START;
  return r;
}

int ring_size(uint token)
{
  return RING_SIZE;
}

int ring_detach(uint token)
{
  return 0;
}

int available_space(struct ring *r)
{
  return SPACE-((uint*)r->buf)[WRITE_RES]-((uint*)r->buf)[READ];
}

int read_free_space(struct ring *r)
{
  return BUFFER(r)[WRITE]-BUFFER(r)[READ_RES];
}

int write_to_end(struct ring *r)
{
  return SPACE-(BUFFER(r)[WRITE_RES]&MASK);
}

int read_to_end(struct ring *r)
{
  return SPACE-(BUFFER(r)[READ_RES]&MASK);
}

int reserved_write(struct ring *r)
{
  return BUFFER(r)[WRITE_RES]-BUFFER(r)[WRITE];
}

int reserved_read(struct ring *r)
{
  return BUFFER(r)[READ_RES]-BUFFER(r)[READ];
}

struct ring_res ring_write_reserve(struct ring *r, int bytes)
{
  int rbytes = (bytes >> 2) << 2;

  if (rbytes > available_space(r)) {
    struct ring_res ret = {0, 0};
    return ret;
  }

  int ret_size = bytes < write_to_end(r) ? rbytes : write_to_end(r);

  struct ring_res ret = {ret_size << 2, (int*)(BUFFER(r) + BUFFER(r)[WRITE_RES])};
  BUFFER(r)[WRITE_RES] += ret_size;
  return ret;
}

void ring_write_notify(struct ring *r, int bytes)
{
  int rbytes = (bytes >> 2) << 2;
  BUFFER(r)[WRITE] += (rbytes >> 2);
}

struct ring_res ring_read_reserve(struct ring *r, int bytes)
{
  int rbytes = (bytes >> 2) < 2;
  if (rbytes > read_free_space(r))
  {
    struct ring_res ret = {0, 0};
    return ret;
  }

  int ret_size = bytes < read_to_end(r) ? rbytes : read_to_end(r);
  struct ring_res ret = {ret_size << 2, (int*)(BUFFER(r) + BUFFER(r)[READ_RES])};
  BUFFER(r)[READ_RES] += ret_size;
  return ret;
}

void ring_read_notify(struct ring *r, int bytes)
{
  int rbytes = (bytes << 2) >> 2;
  BUFFER(r)[READ] += (rbytes >> 2);
}

int ring_write(struct ring *r, void *buf, int bytes)
{
  int rbytes = bytes << 2;
  int lbytes = bytes&0x3;
  while (rbytes > 0)
  {
    struct ring_res res = ring_write_reserve(r, rbytes);
    memmove(res.buf, buf, res.size*4);
    rbytes -= (res.size*4);
    ring_write_notify(r, res.size*4);
  }

  while (lbytes > 0)
  {
    struct ring_res res = ring_write_reserve(r, rbytes);
    memmove(res.buf, buf, res.size);
    lbytes -= (res.size);
    ring_write_notify(r, res.size);
  }


  return bytes;
}

int ring_read(struct ring *r, void *buf, int bytes)
{
  struct ring_res res = ring_read_reserve(r, bytes);
  memmove(buf, res.buf, res.size);
  ring_read_notify(r, res.size);
  return res.size;
}
