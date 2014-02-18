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
  *msec = 10 * (ticks1 % 100);
  *sec = (ticks1 / 100);
  
  return 0;
  

}

pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc);
int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);

int
sys_shmget(void)
{
  uint key;
  uint size;
  unsigned long address;

  if((arguint(0,&key) < 0)   ||
     (argulong(1,&address) < 0) ||
     (arguint(2,&size) < 0)) {
    cprintf("shmget: can't get variables.\n");
    return -1;
  }

  int create_new = 1;
  acquire(&ptable.lock);
  void *page = 0;
  struct proc *p;
  if(size == 0) {
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
      if(p->state != UNUSED && p->sh_mem_token == key) {
        create_new = 0;
      }
    }
  }
  int bytes = PGROUNDUP(size);
  int i = 0;
  for(i = 0; i < bytes; i += PGSIZE) {
    if(create_new) {
      if(!(page = kalloc())) {
        cprintf("shmget: Can't kalloc page\n");
      }
    } else {
      if(!(page = walkpgdir(p->pgdir, (char *)p->start_address+i, 0))) {
        release(&ptable.lock);
        cprintf("shmget: Can't get existing page.\n");
        return -1;
      }
    }
    memset(page, 0, PGSIZE);
    mappages(proc->pgdir, (char*)(address+i), PGSIZE, v2p(page), PTE_W|PTE_U);
/*
    if(!mappages(proc->pgdir, (char*)(address+i), PGSIZE, v2p(page), PTE_W|PTE_U)) {
      release(&ptable.lock);
      cprintf("shmget: can't mappages\n");
      return -10;
    }
*/
  }

  proc->sh_mem_token  = key;
  proc->start_address = address;
  proc->size          = size;
  release(&ptable.lock);
  switchuvm(proc);

  return 0;
}

