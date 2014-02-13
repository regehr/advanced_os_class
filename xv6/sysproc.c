#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "traps.h"


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
  *msec = (ticks1 % 100);
  *sec = (ticks1 / 100);
  
  return 0;
  

}


// returns -1 if something goes wrong
// returns 0 otherwise, assumes address is page aligned
int sys_shmget(void)
{
  struct proc *p;
  uint token;
  char * addr;
  uint len;
  pte_t * pte;
  argint(0, (int *)&token);
  argint(1, (int *)&addr);
  argint(2, (int *)&len);
  // check if allowed address
  //  if(!(pte = walkpgdir(proc->pgdir, (void *) addr, 0)))
  //  return -1;
  // case 1: have unused token, but len is 0, return negative 1
  cprintf("in shmget");
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) // loop through process table
    {
      if(p->token == token) // looking for process with token
	goto found;
    }
  cprintf("len is: %d\n", len);
  if(len == 0)
    {
      release(&ptable.lock);
      return -1; // case 1
    }
  if(!shmget_allocuvm(proc->pgdir, addr, len))
    {
      release(&ptable.lock);
      return -1; // couldn't allocate space
    }
  proc->size = len;
  proc->token = token;
  proc->start_shared = addr;
  release(&ptable.lock);
  switchuvm(proc);
  cprintf("i offically don't know where the problem is\n");
  return 0;
 found:
  if(len != 0)
    {
      release(&ptable.lock);
      return -1; // token is already being used
    }
  // another process has been set up with this token, map those pages to this process
  pte = walkpgdir(p->pgdir, p->start_shared, 0);
  if(mappages(proc->pgdir, addr, p->size, PTE_ADDR(*pte), PTE_U | PTE_W) < 0)
    return -1;
  proc->size = p->size;
  proc->token = token;
  proc->start_shared = addr;
  release(&ptable.lock);
  switchuvm(proc);
  return 0;

}
