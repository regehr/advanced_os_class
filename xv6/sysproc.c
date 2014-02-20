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

int sys_shmget(void)
{
  int addr, i, size_rup;
  uint size, token;
  struct proc *p;
  char* mem;
  pte_t* pte;

  // Get args from user
  if((arguint(0,&token) < 0) ||
    (argint(1,&addr) < 0) ||
    (arguint(2,&size) < 0)) {
    cprintf("Failed to get user args\n");
    return -1;
  }

  size_rup = PGROUNDUP(size);

  acquire(&ptable.lock);

  // check procs for matching token
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if((p->state != UNUSED) & (p->sh_key == token)) {
      release(&ptable.lock);
      goto existing;
    }
  }
  release(&ptable.lock);

  // if none, create new shared memory area
  if (size > 0) {
    for(i = 0; i < size_rup; i+= PGSIZE) {
      mem = kalloc();
      if(!mem) {
        cprintf("Not enough memory\n");
        // Deallocate memory from the process
        deallocuvm(proc->pgdir, addr+i, addr);
        return -1;
      }

      // Set allocated memory to 0
      memset(mem, 0, PGSIZE);
      mappages(proc->pgdir, (void*)addr+i, PGSIZE, v2p(mem), PTE_U|PTE_W);
    }

    proc->sh_size = size;
    proc->sh_addr = (char*)addr;
    proc->sh_key = token;

    switchuvm(proc);
    return 0;
  }

  return -1;
  // otherwise, map shared memory together
existing:
  cprintf("in existing\n");

  size_rup = PGROUNDUP(p->sh_size);

  for(i = 0; i < size_rup; i += PGSIZE) {
    pte = walkpgdir((pde_t*)p->pgdir, ((char*)p->sh_addr), 0);
    if(!pte) {
      cprintf("Not enough memory\n");
      return -1;
    }
    if((*pte & PTE_P) != 0){
      uint pa = PTE_ADDR(*pte);
      if(!pa){
        cprintf("Physical address was zero\n");
        return -1;
      }
      mappages(proc->pgdir, (char*)addr+i, PGSIZE, pa, PTE_U|PTE_W);
    }
  }
  switchuvm(proc);
  return 0;
}
