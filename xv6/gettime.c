#include "types.h"
#include "user.h"





int main(void){
  
  unsigned long msec;
  unsigned long sec; 
  
  

  if(gettime(&msec,&sec)<0){
    printf(1,"Error on gettime");
    exit();
  }
  printf(1,"msec: %d and sec: %d\n",msec,sec); 
  exit();
}
