#include "types.h"
#include "defs.h"
#include "param.h"
#include "mmu.h"
#include "proc.h"
#include "fs.h"
#include "file.h"
#include "spinlock.h"

<<<<<<< HEAD
#define PIPESIZE 3072
=======
#define PIPESIZE 2048
>>>>>>> johnNew

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

int min (int a, int b)
{
  if (a<b) return a;
  return b;
}

void* memcpy2(void* dest, const void* src, int count) {

  int* dst32 = (int*)dest;
  int* src32 = (int*)src;      
  while (count > 3) {
    *dst32 = *src32;
    count -= 4;
    dst32++;
    src32++;
  }
  dest = dst32;
  src = src32;

  char* dst8 = (char*)dest;
  char* src8 = (char*)src;
  
  while (count--) {
    *dst8++ = *src8++;
  }
  return dest;
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
  int written = 0;
  acquire(&p->lock);
 restart: 
  ;
  int pipe_pos = p->nwrite % PIPESIZE;
  int bytes_left = PIPESIZE + p->nread - p->nwrite;
  int towrite = PIPESIZE;                        // for speed, we'd like to write this many bytes
  towrite = min (towrite, n);                    // but we can write at most n
  towrite = min (towrite, PIPESIZE - pipe_pos);  // and at most to the end of the buffer
  towrite = min (towrite, bytes_left);           // and at most until the pipe becomes full
  if (towrite == 0) {

      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
        return -1;
      } else {
	wakeup(&p->nread);
	sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
	goto restart;
      }

  }
  memcpy2 (&p->data[pipe_pos], addr + written, towrite);  
  written += towrite;
  p->nwrite += towrite;



  int bytes_left_in_front = bytes_left - pipe_pos;
  if(bytes_left_in_front > 0)
    {
      memcpy2 (&p->data[0], addr + written, bytes_left_in_front);
      written += bytes_left_in_front;
      p->nwrite += bytes_left_in_front;
    }

  wakeup(&p->nread);
  release(&p->lock);  
  if(n != written)
    {
      goto restart;
    }
  
  return written;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  int read = 0;
  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen) {
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock);
  }
  if (p->nread == p->nwrite) {
    release(&p->lock);
    return read;
  }
  int pipe_pos = p->nread % PIPESIZE;
  int bytes_left = p->nwrite - p->nread;
  int toread = PIPESIZE;
  toread = min (toread, n);
  toread = min (toread, bytes_left);
  toread = min (toread, PIPESIZE - pipe_pos);
  memcpy2 (addr, &p->data[pipe_pos], toread);
  p->nread += toread;
  read += toread;

  int bytes_left_in_front = bytes_left - pipe_pos;
  if(bytes_left_in_front > 0)
    {
      memcpy2 (addr + read, &p->data[0], bytes_left_in_front);
      read += bytes_left_in_front;
      p->nread += bytes_left_in_front;
    }


  wakeup(&p->nwrite);
  release(&p->lock);
  return read;
}
