#include "ring.h"

struct ring *ring_attach(uint token)
{
  return 0;
}

int ring_size(uint token)
{
  return 0;
}

int ring_detach(uint token)
{
  return 0;
}

struct ring_res ring_write_reserve(struct ring *r, int bytes)
{
  struct ring_res ret = {0, 0};
  return ret;
}

void ring_write_notify(struct ring *r, int bytes)
{

}

struct ring_res ring_read_reserve(struct ring *r, int bytes)
{
  struct ring_res ret = {0, 0};
  return ret;
}

void ring_read_notify(struct ring *r, int bytes)
{

}

void ring_write(struct ring *r, void *buf, int bytes)
{

}

void ring_read(struct ring *r, void *buf, int bytes)
{

}
