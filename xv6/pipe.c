#include "types.h"
#include "defs.h"
#include "param.h"
#include "mmu.h"
#include "proc.h"
#include "fs.h"
#include "file.h"
#include "spinlock.h"

//#define PIPESIZE 512
//#define PIPESIZE 1024
#define PIPESIZE 2048
//#define PIPESIZE 4096
//#define PIPESIZE 8192

struct pipe {
  struct spinlock lock;
  char data[PIPESIZE];
  uint nread;     // number of bytes read
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

void * pmemcpy(void *dst, const void *src, int count)
{
  void * start_dst  = dst;
  int * dst32       = (int*)dst;
  const int * src32 = (const int*)src;
  while(count > 3) {
    *dst32++ = *src32++;
    count -= 4;
  }

  dst = dst32;
  src = src32;

  char *dst8       = (char*)dst;
  const char *src8 = (const char*)src;

  while(count--) {
    *dst8++ = *src8++;
  }
  return start_dst;
}

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

#define NORMAL_READ  1
#define NORMAL_WRITE 0

#if NORMAL_WRITE
//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
#else
//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  i = 0;
  while(i < n){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
//    p->data[p->nwrite++ % PIPESIZE] = addr[i++];
//    memmove(p->data + (p->nwrite % PIPESIZE),addr + i,1);
    int pipepos = p->nwrite % PIPESIZE;
    int left = PIPESIZE + p->nread - p->nwrite;
    int towrite = PIPESIZE > n ? n : PIPESIZE;
    towrite = towrite > pipepos ? pipepos : towrite;
    towrite = towrite > left ? left : towrite;
    if(!towrite) {
      break;
    }
    pmemcpy(&p->data[pipepos], addr + i, towrite);
    p->nwrite += towrite;
    i += towrite;
/*
    pmemcpy(p->data + (p->nwrite % PIPESIZE),addr + i,1);
    p->nwrite += 1;
    i += 1;
*/
/*
    if(PIPESIZE<=n-i) {
      memmove(p->data,addr,PIPESIZE);
      p->nwrite+=PIPESIZE;
      i+=PIPESIZE;
    } else {
      memmove(p->data,addr,n-i);
      p->nwrite+=n-i;
      i+=n-i;
    }
*/
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
#endif

#if NORMAL_READ
int
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
#else
int
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  if(p->nwrite - p->nread == PIPESIZE) {
    memmove(addr, p->data, PIPESIZE);
    p->nread += PIPESIZE;
    i += PIPESIZE;
  } else {
    memmove(addr, p->data, p->nwrite - p->nread);
    p->nread = p->nwrite;
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
#endif

