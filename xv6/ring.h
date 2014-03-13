#ifndef RING_H
#define RING_H

#include "types.h"


#define RING_SIZE 0x0007F000
#define RING_PAGE 0x1000
#define RING_START 0x7FF00000

/* Define our pointers */
volatile struct  {
  unsigned int read = 0x7FF80000;
  unsigned int read_reserve = 0x7FF80040;
  unsigned int write = 0x7FF80080;
  unsigned int write_reserve = 0x7FF800C0;
} pointer;


#define RING_SPACE_USED (*pointer->write_reserve - *pointer->read)
#define RING_SPACE_FREE (RING_SIZE - RING_SPACE_USED)




struct ring {
  unsigned tok;
  void *buf;
};

struct ring_res {
  unsigned size;
  void *buf;
};

struct ring *ring_attach(uint token);
int ring_size(uint token);
int ring_detach(uint token);
struct ring_res ring_write_reserve(struct ring *r, int bytes);
void ring_write_notify(struct ring *r, int bytes);
struct ring_res ring_read_reserve(struct ring *r, int bytes);
void ring_read_notify(struct ring *r, int bytes);
int ring_write(struct ring *r, void *buf, int bytes);
int ring_read(struct ring *r, void *buf, int bytes);

#endif
