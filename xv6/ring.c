#include "ring.h"


struct ring *ring_attach(uint token)
{
  static uint init;
  struct ring * ret;
  ret = malloc(sizeof(struct ring));
  if(ret == NULL)
    return ret;
  if(shmget(token, RING_START, RING_SIZE + PGSIZE) < 0)
    {
      free(ret);
      return NULL;
    }
  if(!init)
    {
      *READ_HEAD = 0;
      *WRITE_HEAD = 0;
      *WR_HEAD = 0;
      *RR_HEAD = 0;
      init = 1;
    }
  ret->tok = token;
  ret->buf = RING_START;
  return ret;
}

int ring_size(uint token)
{
  return RING_SIZE;
}

int ring_detach(uint token)
{
  return 0;
}

struct ring_res ring_write_reserve(struct ring *r, int bytes)
{
  unsigned int free = RING_SIZE - (*WR_HEAD - *READ_HEAD);
  unsigned int oldWR = *WR_HEAD;
  unsigned int mask = RING_SIZE - 1;
  unsigned int size = 0;
  struct ring_res ret = { size , NULL};
  if(bytes > free)
    return ret; //fail?
  if ((*WR_HEAD % RING_SIZE) < bytes)
    {
      size = (RING_SIZE - (*WR_HEAD % RING_SIZE));
      *WR_HEAD += (RING_SIZE - (*WR_HEAD % RING_SIZE));
    }
  else
    {
      *WR_HEAD += bytes;
      size = bytes;
    }
  
  ret.size = size;
  ret.buf = RING_START + (oldWR & mask);
  return ret;
}

void ring_write_notify(struct ring *r, int bytes)
{
  // check number of reserved bytes
  unsigned int reserved = *WR_HEAD - *WRITE_HEAD;
    // check that bytes is less than reserved
  if(bytes > reserved)
    return;
  *WRITE_HEAD += bytes;
  return;
}

struct ring_res ring_read_reserve(struct ring *r, int bytes)
{
  unsigned int free = *WRITE_HEAD - *READ_HEAD;
  unsigned int size = 0;
  unsigned int oldRR = *RR_HEAD;
  unsigned int mask = RING_SIZE - 1;
  struct ring_res ret = {size, NULL};
  if(bytes > free)
    return ret; //fail? 
  if((*RR_HEAD % RING_SIZE) < bytes)
    {
      size = (RING_SIZE - (*WR_HEAD % RING_SIZE));
      *RR_HEAD += (RING_SIZE - (*RR_HEAD % RING_SIZE));
    }
  else
    {
      *WR_HEAD += bytes;
      size = bytes;
    }

  ret.size = size;
  ret.buf = RING_START + (oldRR & mask);
  return ret;
}

void ring_read_notify(struct ring *r, int bytes)
{
  unsigned int reserved = *RR_HEAD - *READ_HEAD;
  if(bytes > reserved)
    return;
  *WRITE_HEAD += bytes;
  return;
}

void ring_write(struct ring *r, void *buf, int bytes)
{

}

void ring_read(struct ring *r, void *buf, int bytes)
{

}
