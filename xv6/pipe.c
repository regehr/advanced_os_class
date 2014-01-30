#include "types.h"
#include "defs.h"
#include "param.h"
#include "mmu.h"
#include "proc.h"
#include "fs.h"
#include "file.h"
#include "spinlock.h"

//#define PIPESIZE 512
#define PIPESIZE 3072

/* Andrew Riley */

struct pipe {
  struct spinlock lock;
  char data[PIPESIZE];
  uint nread;     // number of bytes read
  uint nwrite;    // number of bytes written
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

int writeCurrent = 0;

// I successfully removed the modulo function from
// the memory copy yet I did not see any increase
// in performance.
int
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;
  int j = writeCurrent; // our current index in the buffer

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
	writeCurrent = j;
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }

    if (j == PIPESIZE) j = 0; // reset the index pointer at end of buffer

    p->data[j++] = addr[i];
    p->nwrite++;

    //p->data[p->nwrite++ % PIPESIZE] = addr[i];

  }

  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  writeCurrent = j;
  
  return n;
}

int readCurrent = 0;

int
piperead(struct pipe *p, char *addr, int n)
{
  int i;
  int j = readCurrent; // our current index in the buffer

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      readCurrent = j;
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
      break;
    
    if (j == PIPESIZE) j = 0; // reset the index pointer at end of buffer

    addr[i] = p->data[j++];
    p->nread++; // increment our pointers


    //addr[i] = p->data[p->nread++ % PIPESIZE];
  }

  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  readCurrent = j;

  return i;
}
