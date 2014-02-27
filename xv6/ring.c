#include "ring.h"
#include "user.h"

#ifndef NULL
#define NULL 0
#endif

// We'll have 64 pages allocated for our ring, excluding
// the extra page used for our purposes
#define RING_SIZE 262144
#define ALLOC_SIZE = (RING_SIZE+4096)
#define RING_SPACE (RING_SIZE>>2)

// Hard coded virtual address I'd like to map my shmget
// region to, as well as locations for important ptrs
#define START_ADDR (0x08000000-ALLOC_SIZE-4096)
// TODO: put these on their own cache lines, I guess
#define READ RING_SPACE
#define READ_RES (READ+1)
#define WRITE (READ_RES+1)
#define WRITE_RES (WRITE+1)

struct ring *ring_attach(uint token)
{
    if(shmget(token, START_ADDR, ALLOC_SIZE) < 0)
        return NULL;
    struct ring* ret = malloc(sizeof(struct ring));
    if (ring == NULL)
        return NULL;

    ret->tok = token;
    ret->buf = (void*)START_ADDR;
    // Initially all ptrs in the ring point to the
    // starting position:
    int* tmp = (int*)(ret->buf);
    tmp[READ]      = 0;
    tmp[READ_RES]  = 0;
    tmp[WRITE]     = 0;
    tmp[WRITE_RES] = 0;

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

#define MASK (RING_SPACE-1)
#define WRITE_FREE_SPACE (RING_SPACE-((*write_res_ptr)-(*read_ptr)))
#define READ_FREE_SPACE ((*write_ptr)-(*read_res_ptr))
#define WRITE_TO_END (RING_SPACE-((*write_res_ptr)&MASK))
#define READ_TO_END (RING_SPACE-((*read_res_ptr)&MASK))
#define RESERVED_WRITE ((*write_res_ptr)-(*write_ptr))
#define RESERVED_READ ((*read_res_ptr)-(*read_ptr))

struct ring_res ring_write_reserve(struct ring *r, int bytes)
{
    // Round bytes down so it is 0 modulo 4
    bytes = bytes - (bytes & 0x3);

    // We return the smallest of the following:
    //  1) The space from write_res to read
    //  2) The space from write_res to the end of the buffer
    //  3) The requested number of bytes
    int ret_size = MIN(MIN(bytes, WRITE_TO_END), WRITE_FREE_SPACE);
    int* tmp = (int*)(r->buf);

    // Setup return struct
    struct ring_res ret =
    {
        ret_size << 2,
        tmp + tmp[WRITE_RES]
    };

    tmp[WRITE_RES] += ret_size;

    return ret;
}

void ring_write_notify(struct ring *r, int bytes)
{
    // Round bytes down so it is 0 modulo 4
    bytes = bytes - (bytes & 0x3);

    // TODO: return error code? For now, just print bad message and exit
    if (bytes > RESERVED_WRITE)
    {
        printf(1, "ERROR - Requested to write-notify too many bytes\n");
        exit();
    }

    // Increment write head:
    int* tmp = (int*)(r->buf);
    tmp[WRITE] += (bytes >> 2);
}

struct ring_res ring_read_reserve(struct ring *r, int bytes)
{
    // Round bytes down so it is 0 modulo 4
    bytes = bytes - (bytes & 0x3);

    // We return the smallest of the following:
    //  1) The space from read_res to write
    //  2) The space from read_res to the end of the buffer
    //  3) The requested number of bytes
    int ret_size = MIN(MIN(bytes, READ_TO_END), READ_FREE_SPACE);
    int* tmp = (int*)(r->buf);

    // Setup return struct
    struct ring_res ret =
    {
        ret_size << 2,
        tmp + tmp[READ_RES]
    };

    tmp[READ_RES] += ret_size;

    return ret;
}

void ring_read_notify(struct ring *r, int bytes)
{
    // Round bytes down so it is 0 modulo 4
    bytes = bytes - (bytes & 0x3);

    // TODO: return error code? For now, just print bad message and exit
    if (bytes > RESERVED_READ)
    {
        printf(1, "ERROR - Requested to read-notify too many bytes\n");
        exit();
    }

    // Increment write head:
    int* tmp = (int*)(r->buf);
    tmp[READ] += (bytes >> 2);
}

void ring_write(struct ring *r, void *buf, int bytes)
{
    // TODO
}

void ring_read(struct ring *r, void *buf, int bytes)
{
    // TODO
}
