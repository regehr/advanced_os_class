#include "ring.h"
#include "user.h"

// TODO:
//   - Can't null out ptrs at attach time (writer may reserve/write before reader attaches)
//   - A few spec changes (not exiting on notify bad, read returns int, etc.)


#ifndef NULL
#define NULL 0
#endif

#ifndef MIN
#define MIN(x,y) ((x)<(y) ? (x) : (y))
#endif

// We'll have 64 pages allocated for our ring, excluding
// the extra page used for our purposes
#define RING_SIZE 262144
#define ALLOC_SIZE (RING_SIZE+4096)
#define RING_SPACE (RING_SIZE>>2)

// Hard coded virtual address I'd like to map my shmget
// region to, as well as locations for important ptrs
#define START_ADDR (0x08000000-ALLOC_SIZE-4096)
// TODO: put these on their own cache lines, I guess
#define READ RING_SPACE
#define READ_RES (READ+1)
#define WRITE (READ_RES+1)
#define WRITE_RES (WRITE+1)

#define MASK (RING_SPACE-1)
#define BUF(r) ((volatile uint*)((r)->buf))
#define WRITE_FREE_SPACE(r) (RING_SPACE-(BUF(r)[WRITE_RES])-(BUF(r)[READ]))
#define READ_FREE_SPACE(r) ((BUF(r)[WRITE])-(BUF(r)[READ_RES]))
#define WRITE_TO_END(r) (RING_SPACE-((BUF(r)[WRITE_RES])&MASK))
#define READ_TO_END(r) (RING_SPACE-((BUF(r)[READ_RES])&MASK))
#define RESERVED_WRITE(r) ((BUF(r)[WRITE_RES])-(BUF(r)[WRITE]))
#define RESERVED_READ(r) ((BUF(r)[READ_RES])-(BUF(r)[READ]))

struct ring *ring_attach(uint token)
{
    if(shmget(token, START_ADDR, ALLOC_SIZE) < 0)
        return NULL;
    struct ring* ret = malloc(sizeof(struct ring));
    if (ret == NULL)
        return NULL;

    ret->tok = token;
    ret->buf = (void*)START_ADDR;

    return ret;
}

int ring_size(uint token)
{
    return RING_SIZE;
}

int ring_detach(uint token)
{
    // Presently a NOP, since freeing shared memory
    // isn't implemented.
    return 0;
}


struct ring_res ring_write_reserve(struct ring *r, int bytes)
{
    // Round bytes down so it is 0 modulo 4
    bytes = bytes - (bytes & 0x3);
    
    
    // If there is insufficient space in the buffer to allocate, reserve 0 instead:
    if (bytes > WRITE_FREE_SPACE(r))
    {
        struct ring_res ret = { 0, NULL };
        return ret;
    }
    
    // Otherwise, do a short reserve if we hit the end of the buffer:
    int ret_size = MIN(bytes, WRITE_TO_END(r));

    // Setup return struct
    struct ring_res ret =
    {
        ret_size << 2,
        (int*)(BUF(r) + BUF(r)[WRITE_RES])
    };

    BUF(r)[WRITE_RES] += ret_size;

    return ret;
}

void ring_write_notify(struct ring *r, int bytes)
{
    // Round bytes down so it is 0 modulo 4
    bytes = bytes - (bytes & 0x3);

    // Increment write head:
    BUF(r)[WRITE] += (bytes >> 2);
}

struct ring_res ring_read_reserve(struct ring *r, int bytes)
{
    // Round bytes down so it is 0 modulo 4
    bytes = bytes - (bytes & 0x3);
    
    // If there is insufficient space in the buffer to allocate, reserve 0 instead:
    if (bytes > READ_FREE_SPACE(r))
    {
        struct ring_res ret = { 0, NULL };
        return ret;
    }

    // Otherwise, do a short reserve if we hit the end of the buffer:
    int ret_size = MIN(bytes, READ_TO_END(r));

    // Setup return struct
    struct ring_res ret =
    {
        ret_size << 2,
        (int*)(BUF(r) + BUF(r)[READ_RES])
    };

    BUF(r)[READ_RES] += ret_size;

    return ret;
}

void ring_read_notify(struct ring *r, int bytes)
{
    // Round bytes down so it is 0 modulo 4
    bytes = bytes - (bytes & 0x3);

    // Increment write head:
    BUF(r)[READ] += (bytes >> 2);
}

int ring_write(struct ring *r, void *buf, int bytes)
{
    while (bytes > 0)
    {
        struct ring_res write_res = ring_write_reserve(r, bytes);
        // ?!?!?!?!
        // So, I was defining another function that did this in terms of integers, and suddenly
        // mkfs was failing on building (seriously - make stopped working!) and I can't figure
        // what could be going on. For now, we'll copy by bytes even though that's terrible. :|
        memmove(write_res.buf, buf, write_res.size);
        bytes -= (write_res.size);
        ring_write_notify(r, write_res.size);
    }

    return bytes;
}

int ring_read(struct ring *r, void *buf, int bytes)
{
    struct ring_res read_res = ring_read_reserve(r, bytes);
    memmove(buf, read_res.buf, read_res.size);
    ring_read_notify(r, read_res.size);
    return read_res.size;
}
