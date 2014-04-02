#include "types.h"
#include "stat.h"
#include "user.h"





int main(void){

  int pid[5];
  unsigned int counter = 1;
  int i =0;
  int temp_pid =0;
  setpriority(getpid(),30);
  for(;i<5;i++){
    temp_pid = fork();
    if(temp_pid==0){
      goto child;
    }
    pid[i] = temp_pid;
    printf(1,"spawned child %d\n",temp_pid);
  }
  setpriority(getpid(),0);
  goto parent;
  
  child:
  //INB4 everyone bitches about sleep. 
  sleep(5);
  while(counter++);
  printf(1,"done with child pid %d\n",getpid());
  exit();
 
 parent:
  for(i=0;i<5;i++){
    printf(1,"Parent setting child pid %d with priority %d\n",pid[i],15-i);
    setpriority(pid[i],15-i);
     temp_pid = pid[i];
  }
  wait();
  printf(1,"parent done\n");
  exit();
}

