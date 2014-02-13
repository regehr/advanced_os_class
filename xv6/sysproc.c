#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "traps.h"
#include "vm.c"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;
  
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}


int sys_gettime(void)
{
  unsigned long *msec;
  unsigned long *sec;
  uint ticks1;

  if((argptr(0,(char**)&msec, sizeof(unsigned long)) < 0) || 
     (argptr(1,(char**)&sec, sizeof(unsigned long)) < 0)){
    return -1;
  }
  
  //assert(msec != NULL);
  //assert(sec != NULL);

  acquire(&tickslock);
  ticks1 = ticks;
  release(&tickslock);
  
  //ticks occur every 10ms
  *msec = 10 * (ticks1 % 100);
  *sec = (ticks1 / 100);
  
  return 0;
  

}

//we will start with just a page table, then we will move up
//if size = 0 we are receving, 


uint shmget_key;
pde_t *shmget_page;


int
sys_shmget(void)
{

  uint key;
  unsigned long start_address;
  uint size;
  bool found = false; 
  
  struct proc *p;
  pte_t *pte;
  uint physical_address;
  int i =0;
  

  if((argptr(0,(char*)&key, sizeof(uint)) < 0) ||
     (argptr(1,(char*)&start_address, sizeof(unsigned long)) < 0)|| 
     (argptr(2,(char*)&size, sizeof(unsigned long)) < 0))
    {
      cprintf("wrong paramaters to shmget\n");
      return -1;
    }


  if(start_address >= KERNBASE && (start_address+size) >= KERNBASE && (start_address % PGSIZE)!=0){
    cprintf("Address outside of bounds\n");
    return -1;
  }

  //setting up shared mem
  if(size != 0)
    {
      if(allocAt(proc->pgdir, size, start_address) < 0)
	{
	  cprintf("error in creating shared memory shmget\n");
	  return -1;
	} 
      proc->shm_key = key;
      proc->start_address = start_address;
      proc->size; 
      switchuvm(proc);
      return 0; 
    }
  //becasue size is 0 we are looking for a matching key. 
  //we don't have any garentee that the key will be
  // as we don't know what order the process write in. 
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if(p != UNUSED)
	{
	  if(p->shm_key == key)
	    {
	      found = true;
	      release(&ptable.lock);
	      break;
	    }
	  }
    }
  if(!found)
    {
      release(&ptable.lock);
      return -1;
    }
  
  size = PGROUNDUP(p->shmem_size);
  for(;i<size; i+=PGSIZE){
    pte = walkpgdir((pde_t*)p->pgdir, ((char *)p->start_address), 0);
    if(!pte)
      {
	cprintf("Error pte error in shmget.\n");
	return -1;
    }
    if(*pte!= 0)
      {
	physical_address = PTE_ADDR(*pte);
	if(physical_address == 0)
	  {
	    cprintf("Error physical address is 0.\n");
	    return -1;
	  }
	mappages(proc->pgdir, (char*)start_address + i, PGSIZE, physical_address, PTE_W|PTE_U);
      }
  }
  switchuvm(proc);
  return 0;
}
