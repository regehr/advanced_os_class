#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

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

int
sys_set_priority(void)
{
  int pid, priority;
  struct proc *p, *p_remove, *p_add;

  // Get pid and priority from user
  if((argint(0,&pid) < 0) ||
    (argint(1,&priority) < 0)) {
    cprintf("Failed to get user args\n");
    return -1;
  }

  // Find process p with correct pid
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->pid == pid)
      goto found;
  release(&ptable.lock);
  // Failure
  cprintf("Process with pid does not exist\n");
  return -1;

  // Success!!
  found:
  p->priority = priority;

  // remove from current priority queue
  p_remove = priority_q[p->priority];
  if(p_remove == NULL)
    goto add; //somehow the current process wasn't in a queue
  // If we are removing the first item
  if(p_remove->pid == p->pid) {
    priority_q[p->priority]= p_remove->next;
    p->next = NULL;
    goto add;
  }
  while(p_remove->next != NULL) {
    if(p_remove->next->pid == p->pid) {
      p_remove->next = p->next;
      p->next = NULL;
      goto add;
    }
    p_remove = p_remove->next;
  }

add:
  // add to new priority queue
  if(priority_q[p->priority] == NULL) {
    priority_q[p->priority] = p;
    goto end;
  }
  p_add = priority_q[p->priority];
  while(p_add->next != NULL) {
    p_add = p_add->next;
  }
  p_add->next = p;
  p->next = NULL;

end:
  release(&ptable.lock);
  return 0;
}