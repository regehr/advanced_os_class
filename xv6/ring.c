#include "ring.h"

/* Attach Shemget to the ring? */
struct ring *ring_attach(uint token)
{
  return 0;
}

/* Return the entire size of the ring */
int ring_size(uint token)
{
  return RING_SIZE;
}

/* Dettach Shemget from the ring? */
int ring_detach(uint token)
{
  return 0;
}

/* Space that has been reserved and ready to be written in */
struct ring_res ring_write_reserve(struct ring *r, int bytes)
{
  struct ring_res ret = {0, 0};

  // base cases
  if (bytes > RING_SPACE_FREE)
	return ret

  unsigned int old = *poiner->write_reserve;
  *pointer->write_reserve += bytes

  ret->size = *pointer->write_reserve;
  ret->buf = RING_START + (old & (RING_SIZE - 1));
  return ret;
}

/* Notify writer they have space to write in */
void ring_write_notify(struct ring *r, int bytes)
{

}

/* Space that will be read and should not be reserved for writing just yet */
struct ring_res ring_read_reserve(struct ring *r, int bytes)
{
  struct ring_res ret = {0, 0};

  // base cases
  if (*pointer->read_reserve == *pointer->write)
	return ret

  unsigned int old = *poiner->read_reserve;
  *pointer->read_reserve += bytes

  ret->size = *pointer->read_reserve;
  ret->buf = RING_START + (old & (RING_SIZE - 1));
  return ret;
}

/* Notify reader they have space to read in */
void ring_read_notify(struct ring *r, int bytes)
{

}

/* Write in space */
int ring_write(struct ring *r, void *buf, int bytes)
{

}

/* Read in space */
int ring_read(struct ring *r, void *buf, int bytes)
{

}
