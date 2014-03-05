#include "types.h"
#include "user.h"

int main(void){
  int i=0;
  int j=0;
  if(shmget(12,(char *)0x0000A000,4096)<0){
    printf(1,"error\n");
  }
  printf(1, "passed first test\n");

  char *test = (char*) 0x0000A000;
  char *temp = test;
  for(;i<128; i++){
    printf(1, "writing a: %p\n", test);
    *test = 'A';
    test++;
  }
  *test = '\0';
  test = temp;

  if(fork()==0){
    //child
    sleep(100);
    char *test1;
    if(shmget(12,(char *)0x20000000,0) < 0){
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
