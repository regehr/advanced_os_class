#include "types.h"
#include "user.h"

int main(void){
  int i=0;
  int j=0;
  if(shmget(12,0x0000A000,4096)<0){
    printf(1,"error\n");
  }

  char *test = (char*) 0x0000A000;
  char *temp = test;
  for(;i<128; i++){
    *test = 'A';
    test++;
  }
  *test = '\0';
  test = temp;

  if(fork()==0){
    //child
    char *test1;
    if(shmget(12,0x0000B000,0) < 0){
      printf(1,"Child error");
      exit();
    }
    test1 =(char*) 0x0000B000;
    for(;j<128;j++){
      printf(1,"%c",*test1);
      test1++;
    }
    printf(1,"Child exiting\n");
  }

  while(1){
    printf(1,"sleeping\n");
    sleep(25);
  }
 
  /*  int test1[15];
  int * test = malloc(4096);
  printf(1,"test is %p, %x, %d\n",test,test,test);
  printf(1,"test1 is %p, %x, %d\n",test1,test1,test1);*/
  exit();

}
