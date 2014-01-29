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
    int toWrite;
    int addrPos = 0;
    int canWrite1 = 0;  // Amount of space we can write before reaching end of the buffer
    int canWrite2 = 0;  // Amount of space we can write assuming we wrap around the buffer

    acquire(&p->lock);
    for(toWrite = n; toWrite > 0;){
        while(p->written == PIPESIZE){
            if(p->readopen == 0 || proc->killed){
                release(&p->lock);
                return -1;
            }
            wakeup(&p->nread);
            sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
        }
        
        int i;
        int frontSpace, backSpace;
        
        // Write toward end of pipe if we're ahead of the reader:
        if (p->nwrite >= p->nread)
        {
            frontSpace = PIPESIZE - p->nwrite;
            canWrite1 = (toWrite > frontSpace) ? frontSpace : toWrite;
            toWrite -= canWrite1;
            p->written += canWrite1;
            for (i = 0; i < canWrite1; i++)
                p->data[p->nwrite++] = addr[addrPos++];
        }
        
        // Reset to front if we got to the end of the buffer:
        if (p->nwrite == PIPESIZE)
            p->nwrite = 0;
        
        // Write from front if there's anything left:
        if (toWrite > 0)
        {
            backSpace = p->nread - p->nwrite;
            canWrite2 = (toWrite > backSpace) ? backSpace : toWrite;
            toWrite -= canWrite2;
            p->written += canWrite2;
            for (i = 0; i < canWrite2; i++)
                p->data[p->nwrite++] = addr[addrPos++];
        }
    }

    wakeup(&p->nread);  //DOC: pipewrite-wakeup1
    release(&p->lock);
    return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  int toRead;
  int canRead1 = 0;
  int canRead2 = 0;
  int addrPos = 0;

  acquire(&p->lock);
  
  // While empty:
  while((p->written == 0) && p->writeopen){
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock);
  }

  for(toRead = n; toRead > 0;){
    int i;
    int frontSpace, backSpace;

    // Read up to the front of the buffer if we're ahead of the writer:
    if (p->nread >= p->nwrite)
    {
        frontSpace = PIPESIZE - p->nread;
        canRead1 = (toRead > frontSpace) ? frontSpace : toRead;
        toRead -= canRead1;
        p->written -= canRead1;
        for (i = 0; i < canRead1; i++)
            addr[addrPos++] = p->data[p->nread++];
    }

    // Reset read head if appropriate:
    if (p->nread == PIPESIZE)
        p->nread = 0;

    // Read towards the write head if we're looking for more:
    if (toRead > 0)
    {
        backSpace = p->nwrite - p->nread;
        canRead2 = (toRead > backSpace) ? backSpace : toRead;
        toRead -= canRead2;
        p->written -= canRead2;
        for (i = 0; i < canRead2; i++)
            addr[addrPos++] = p->data[p->nread++];
    }

    // If we've emptied the pipe and we must return:
    if(p->written == 0)
      break;
  }
 
  wakeup(&p->nwrite);
  release(&p->lock);
  return n - toRead;
}
