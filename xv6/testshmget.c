#include "types.h"
#include "user.h"

int main(void){
  int i=0;
  int j=0;
  if(shmget(12,0x7FFF0000,20480)<0){
    printf(1,"error\n");
  }

  char *test = (char*) 0x7FFF0000;
  char *temp = test;
  for(;i<20479; i++){
    *test = 'A';
    test++;
  }
  *test = '\0';
  test = temp;

  if(fork()==0){
    //child
    sleep(100);
    char *test1;
    if(shmget(12,0x20000000,0) < 0){
      printf(1,"Child error");
      exit();
    }
    test1 =(char*) 0x20000000;
    for(;j<20479;j++){
      if(*test1 != 'A'){
	printf(1,"Fail\n");
      }
      test1++;
    }
    printf(1,"Child exiting with success!\n");
  }

  wait();
  /*  int test1[15];
  int * test = malloc(4096);
  printf(1,"test is %p, %x, %d\n",test,test,test);
  printf(1,"test1 is %p, %x, %d\n",test1,test1,test1);*/
  exit();

}
