#ifndef RING_H
#define RING_H

#include "types.h"

#define RING_SIZE 0x7F000
#define PGSIZE 0x1000

volatile unsigned int * RING_START = 0x7FF00000;

volatile unsigned int * READ_HEAD = 0x7FF7F000;
volatile unsigned int * WRITE_HEAD = 0x7FF7F040;
volatile unsigned int * WR_HEAD = 0x7FF7F080;
volatile unsigned int * RR_HEAD = 0X7FF7F0C0;

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
