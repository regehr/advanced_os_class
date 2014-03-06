#include "ring.h"
#include "user.h"


#define RINGSIZE 0x0007F000 //127 pages
#define PGSIZE   0x00001000 //1 page for maintenance


 struct ring *ring_attach(uint token)
 {
   struct ring *ret = malloc(sizeof(struct ring));
   if(!ret) return ret;
   ret->tok = token;
   ret->buf = (void*)0x7FF00000;
   if(shmget(token,(char*)0x7FF00000,(RINGSIZE+PGSIZE))<0){ 
     printf(1,"Error in ring attach with shmget\n");
     free(ret);
     return NULL;
   }

   /**************************************
    * I THINK WE MEMSET(0) all the pages *
    * IN THAT CASE THIS IS UNNECESSARY   *
    **************************************/
   //Set ptrs to 0
   /*
   *((unsigned int*)0x7FF80000) = 0; //read
   *((unsigned int*)0x7FF80040) = 0; //read_res cache line 1
   *((unsigned int*)0x7FF80080) = 0; //write cache line 2
   *((unsigned int*)0x7FF800C0) = 0: //write_res cache line 3*/
   return ret;
}

int ring_size(uint token)
{
  return RINGSIZE;
}

int ring_detach(uint token)
{
  return 0;
}




struct ring_res ring_write_reserve(struct ring *r, int bytes)
{
  struct ring_res ret = {0, 0};
  volatile unsigned int *write_res_ptr;
  volatile unsigned int *read_ptr;
  //  bytes = (bytes + (bytes % 4));
  write_res_ptr = (unsigned int *)0x7FF80080;
  read_ptr = (unsigned int *)0x7FF800000;
  register unsigned int write_res, read;
  write_res = *write_res_ptr;
  read = *read_ptr;
 
  
  //Wrap around. if the write reservation is already at the end of ring
  //see if there is atleast 1 byte at the front of the head.
  if(write_res == ringsize(-1) && read != 0){
    write_res = 0;
    *write_res_ptr = 0;
  }
  //if write_res is at end of buffer and no space at the front return 0 space
  else if(write_res == ringsize(-1) && read == 0){
    ret->size = 0;
    ret->buf = ((void*)0x7FF80000);
    return ret;
  }


  //determine if read is ahead of write
  //this is the case where write has wrapped around and read hasn't read around
  if(read > (write_res+bytes)){
    ret->size = (*write_res_ptr) =  write_res+bytes;
    ret->buf = ((char*)0x7FF00000)+(wrte_res+bytes);
    return ret;
  }
  else if(read < write_res){
    if((write_res + bytes) > ringsize(-1)){
      ret->size = (*write_res_ptr) = ringsize(-1)-write_res;
      ret->buf =  ((char*)0x7FF00000) + (ringsize(-1)-write_res);
      return ret;
    }
    else{
      ret->size = (*write_res_ptr) = write_res + bytes;
      ret->buf = ((char*)0x7FF00000)+(wrte_res+bytes);
      return ret;
    }
  }
  return ret;
}

void ring_write_notify(struct ring *r, int bytes)
{
  if(!r || !bytes) return;

  
  
}

struct ring_res ring_read_reserve(struct ring *r, int bytes)
{
  struct ring_res ret = {0, 0};
  
  volatile unsigned int *read_reserve_ptr = (unsigned int*)0x7FF80040;
  volatile unsigned int *write_ptr = (unsigned int*)0x7FF80080;
  register unsigned int read_res, write;
  
  read_res = *read_reserve_ptr;
  write = *write_ptr;
  
  

  if(read_res == write){ //no space
    ret->size = 0;
    ret->buf = (char*)0x7FF00000 + (read_res + bytes);
    return ret;
  }
  //write has wrapped around 
  if(read_res > write){
    if(read_res + bytes > ringsize(-1)){
      ret->size = (*read_reserve_ptr) = ringsize(-1)-read_res;
      ret->buf = (char*)0x7FF00000 + ret->size;
      return ret;
    }
      ret->size = (*read_reserve_ptr) = read_res + bytes;
      ret->buf = (char*)0x7FF00000 + bytes;
      return ret;
  }
  //else write hasn't wrapped around -- we'll be bumping up against write
  else{
    if(read_res + bytes >= write){
      ret->size = (*read_reserve_ptr) = write - read_res;
      ret->buf = (char*)0x7FF00000 + ret->size;
      return ret;
    }
    ret->size = (*read_reserve_ptr) = read_res + bytes;
    ret->buf = (char*)0x7FF000000 + ret->size;
    return ret;
  }
  return ret;
}

void ring_read_notify(struct ring *r, int bytes)
{

}

void ring_write(struct ring *r, void *buf, int bytes)
{
}

void ring_read(struct ring *r, void *buf, int bytes)
{
}
