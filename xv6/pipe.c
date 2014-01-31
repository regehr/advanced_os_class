#include "types.h"
#include "defs.h"
#include "param.h"
#include "mmu.h"
#include "proc.h"
#include "fs.h"
#include "file.h"
#include "spinlock.h"

// Can't make this much bigger:
// To close to 4096 or larger, and the program crashes on subsequent calls.
// (not sure why this is, exactly, but I assume it corresponds to pages being 4096 bytes)
// I can push it up a bit (say to 3584), but the speed isn't substantially improved when
// it is an unusual number like that (maybe mod is significantly slower?)
#define PIPESIZE 3072

struct pipe {
  struct spinlock lock;
  char data[PIPESIZE];
  uint nread;     // position of reader head
  uint nwrite;    // position of writer head
  int written;    // number of bytes currently written in buffer
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  p->written = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
    int toWrite = n;
    int addrPos = 0;
    int canWrite;

    acquire(&p->lock);

    while (toWrite > 0){
        // We need to wait on a reader as long as the pipe is full:
        while(p->written == PIPESIZE){
            if (p->readopen == 0 || proc->killed){
                release(&p->lock);
                return -1;
            }
            wakeup(&p->nread);
            sleep(&p->nwrite, &p->lock);
        }

        // Compute the space we can write to. If nwrite is ahead of nread,
        // that is the space to the end of the buffer. Otherwise, it is the
        // space towards nread.
        int space = (p->nwrite >= p->nread) ? PIPESIZE - p->nwrite : p->nread - p->nwrite;
        canWrite = (toWrite > space) ? space : toWrite;
        toWrite -= canWrite;
        p->written += canWrite;
        
        // Perform copy and adjust pointers appropriately:
        memmove(p->data+p->nwrite, addr+addrPos, canWrite);
        p->nwrite += canWrite;
        addrPos += canWrite;

        // If we wrote to the end of the buffer, move write head to the front:
        if (p->nwrite == PIPESIZE)
            p->nwrite = 0;
    }

    release(&p->lock);
    return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
    int toRead = n;
    int addrPos = 0;
    int canRead;

    acquire(&p->lock);

    // We need to wait on a writer as long as the pipe is empty,
    // and there is a writer to give us more bytes:
    while((p->written == 0) && p->writeopen){
        if(proc->killed){
            release(&p->lock);
            return-1;
        }
        sleep(&p->nread, &p->lock);
    }

    while (toRead > 0){
        // Although we escaped the above while loop, it's possible that
        // is because the writer is dead. If we have nothing now, we
        // exit with a 0 byte read.
        if (p->written == 0)
            break;

        // Compute the contiguous space we can write to. If we're ahead
        // of nwrite, that means we will write towards the end of the
        // buffer. Otherwise, we write towards nwrite:
        int space = (p->nread >= p->nwrite) ? PIPESIZE - p->nread : p->nwrite - p->nread;
        canRead = (toRead > space) ? space : toRead;
        toRead -= canRead;
        p->written -= canRead;

        // Perform write and adjust pointers appropriately:
        memmove(addr+addrPos, p->data+p->nread, canRead);
        addrPos += canRead;
        p->nread += canRead;

        // If we hit the end of the buffer, wrap nread back to the start:
        if (p->nread == PIPESIZE)
            p->nread = 0;
    }

    wakeup(&p->nwrite);
    release(&p->lock);
    return n - toRead;
}
