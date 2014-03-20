#ifndef RING_H
#define RING_H

#include "types.h"

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
