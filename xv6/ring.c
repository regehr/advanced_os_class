#include "ring.h"
#include "user.h"




#define RING_SIZE 0x0007F000
#define PAGE_SIZE 0x1000


// Hard coded virtual address I'd like to map my shmget
// region to, as well as locations for important ptrs
#define START_ADDR 0x7FF00000



// TODO: put these on their own cache lines, I guess
#define READ 0x7FF80000
#define READ_RES 0x7FF80040
#define WRITE 0x7FF80080
#define WRITE_RES 0x7FF800C0



struct ring *ring_attach(uint token)
{
  if(shmget(token, START_ADDR, RING_SIZE+PAGE_SIZE) < 0)
    return NULL;
  struct ring* ret = malloc(sizeof(struct ring));
  if (ret == NULL)
    return NULL;



  ret->tok = token;
  ret->buf = (void *)START_ADDR;
  return ret;
  
}

int ring_size(uint token)
{
  return RING_SIZE;
}

int ring_detach(uint token)
{
  return 1;
}


struct ring_res ring_write_reserve(struct ring *r, int bytes)
{
  
  // Round bytes down so it is 0 modulo 4
  // I don't think we should do this
  //  bytes = bytes + (bytes % 4);

  
  unsigned int *write_res_ptr = (unsigned int*)WRITE_RES;
  unsigned int write_res = *write_res_ptr;
  unsigned int *read_ptr = (unsigned int*)READ; 
  unsigned int read = *read_ptr;

  unsigned int free_space = RING_SIZE - (write_res- read); 


  //first deal with the case where we go over the edge 
  struct ring_res* ret = malloc(sizeof(struct ring_res));
  if (ret == NULL)
    return NULL;
      

  if(bytes > free_space)
    {
      //fail if we don't have as much space as they want
      return NULL; 
    }
  //need to check if we are going to go over end
  if(((write_res % RING_SIZE) + free_space) > RING_SIZE )
    {
      int ret_size = RING_SIZE - (write_res % RING_SIZE);
      ret->size = ret_size;
      ret->buf = (void *)write_res_ptr;
      write_res += ret_size;
      return ret;
    }
  else
    {
      ret->buf = (void *) write_res_ptr; 
      ret->size = bytes;
      write_res += bytes;
      return ret; 
    }
}

void ring_write_notify(struct ring *r, int bytes)
{


  unsigned int *write_res_ptr = (unsigned int*)WRITE_RES;
  unsigned int write_res = *write_res_ptr;
  unsigned int *write_ptr = (unsigned int*)READ; 
  unsigned int write = *write_ptr;

  if (bytes > (RING_SIZE - (write_res - write)))
    {
      printf(1, "ERROR - Requested to write-notify too many bytes\n");
      exit();
    }

  // Increment write head:
  write += bytes;
}

struct ring_res ring_read_reserve(struct ring *r, int bytes)
{

  
  unsigned int *read_res_ptr = (unsigned int*)READ_RES;
  unsigned int read_res = *read_res_ptr;
  unsigned int *write_ptr = (unsigned int*)WRITE; 
  unsigned int write = *write_ptr;

  unsigned int free_space = RING_SIZE - (read_res - write); 


  
  struct ring_res* ret = malloc(sizeof(struct ring_res));
  if (ret == NULL)
    return NULL;
      

  if(bytes > free_space)
    {
      //need to check if we are going to go over end
      if(((read_res % RING_SIZE) + free_space) > RING_SIZE )
	{
	  int ret_size = RING_SIZE - (write_res % RING_SIZE);
	  ret->size = ret_size;
	  ret->buf = (void *)read_res_ptr;
	  read_res += ret_size;
	  return ret;
	}
      else //we know that it doesn't go over boundery just send back to write head
	{
	  int ret_size = write-read_res;
	  ret->size = ret_size;
	  ret->buff = (void *)read_res_ptr;
	  read_res += ret_size;
	  return ret;
	}
    }
  else
    {
      ret->buf = (void *) read_res_ptr; 
      ret->size = bytes;
      read_res += bytes;
      return ret; 
    }
  
  
  
}

void ring_read_notify(struct ring *r, int bytes)
{

  unsigned int *read_res_ptr = (unsigned int*)READ_RES;
  unsigned int read_res = *read_res_ptr;
  unsigned int *read_ptr = (unsigned int*)READ; 
  unsigned int read = *read_ptr;
  // TODO: return error code? For now, just print bad message and exit
  if (bytes > (RING_SIZE - (read_res - read)))
    {
      printf(1, "ERROR - Requested to write-notify too many bytes\n");
      exit();
    }

  // Increment write head:
  read += bytes;
}

void ring_write(struct ring *r, void *buf, int bytes)
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



