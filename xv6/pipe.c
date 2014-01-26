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

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
    int toWrite;
    int canWrite = 0;

    acquire(&p->lock);
    for(toWrite = n; toWrite > 0; toWrite -= canWrite){
        while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
            if(p->readopen == 0 || proc->killed){
                release(&p->lock);
                return -1;
            }
            wakeup(&p->nread);
            sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
        }
        
        int i;
        int space = p->nread + PIPESIZE - p->nwrite;
        canWrite = (toWrite > space) ? space : toWrite;
        //cprintf("%d\n", canWrite);
        for (i = 0; i < canWrite; i++)
            p->data[p->nwrite++ % PIPESIZE] = addr[n - toWrite + i];
    }
    wakeup(&p->nread);  //DOC: pipewrite-wakeup1
    release(&p->lock);
    return n;
  
  /*
    int toWrite;
    int canWrite = 0;
    cprintf("write before acquire\n");
    acquire(&p->lock);
    cprintf("write after acquire\n");

    for (toWrite = n; toWrite > 0; toWrite -= canWrite)
    {
        // Pipe full? Sleep until there's space
        while(p->nwrite == PIPESIZE){  //DOC: pipewrite-full
            if(p->readopen == 0 || proc->killed){
                cprintf("a\n");
                release(&p->lock);
                cprintf("b\n");
                return -1;
            }
            cprintf("c\n");
            wakeup(&p->nread);
            cprintf("d\n");
            sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
            cprintf("e\n");
        }

        // Write as much into the buffer as we can
        canWrite = (toWrite > (PIPESIZE - p->nwrite)) ? PIPESIZE - p->nwrite : toWrite;
        toWrite -= canWrite;
        p->nwrite += toWrite;
        cprintf("f\n");
        memmove(p->data+p->nwrite, addr+(n-toWrite), canWrite);
        cprintf("g\n");
    }

    // We finished, so wake up the reader (in case they're waiting), and release the locks!
    cprintf("write before release\n");
    wakeup(&p->nread);
    release(&p->lock);
    cprintf("write after release\n");

    return n;
    */
}

int
piperead(struct pipe *p, char *addr, int n)
{
  int toRead;
  int canRead = 0;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(toRead = n; toRead > 0; toRead -= canRead){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
      break;
    
    int i;
    int written = p->nwrite - p->nread;
    canRead = (toRead > written) ? written : toRead;
    for (i = 0; i < canRead; i++)
        addr[n - toRead + i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return n - toRead;

    /*
    int canRead;

    cprintf("read before acquire\n");
    acquire(&p->lock);
    cprintf("read after acquire\n");

    // While empty:
    while (p->nwrite == 0 && p->writeopen){
        if (proc->killed){
            release(&p->lock);
            return -1;
        }
        sleep(&p->nread, &p->lock);
    }
    
    // Read everything we can:
    canRead = (n > p->nwrite) ? p->nwrite : n;
    p->nwrite -= canRead;
    memmove(addr, p->data, canRead);

    // Wakeup writer in case it's waiting, and release the locks!
    cprintf("read before release\n");
    wakeup(&p->nwrite);
    release(&p->lock);
    cprintf("read after release\n");

    return canRead;
    */
}
