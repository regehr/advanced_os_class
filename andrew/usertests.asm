
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <validateint>:
  printf(stdout, "sbrk test OK\n");
}

void
validateint(int *p)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
       3:	5d                   	pop    %ebp
       4:	c3                   	ret    
       5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
       9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000010 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
  randstate = randstate * 1664525 + 1013904223;
      10:	69 05 18 54 00 00 0d 	imul   $0x19660d,0x5418,%eax
      17:	66 19 00 
}

unsigned long randstate = 1;
unsigned int
rand()
{
      1a:	55                   	push   %ebp
      1b:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
  return randstate;
}
      1d:	5d                   	pop    %ebp

unsigned long randstate = 1;
unsigned int
rand()
{
  randstate = randstate * 1664525 + 1013904223;
      1e:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
      23:	a3 18 54 00 00       	mov    %eax,0x5418
  return randstate;
}
      28:	c3                   	ret    
      29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000030 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
      30:	55                   	push   %ebp
      31:	89 e5                	mov    %esp,%ebp
      33:	83 ec 18             	sub    $0x18,%esp
  int i;

  printf(stdout, "bss test\n");
      36:	a1 14 54 00 00       	mov    0x5414,%eax
      3b:	c7 44 24 04 98 3d 00 	movl   $0x3d98,0x4(%esp)
      42:	00 
      43:	89 04 24             	mov    %eax,(%esp)
      46:	e8 e5 39 00 00       	call   3a30 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    if(uninit[i] != '\0'){
      4b:	80 3d c0 54 00 00 00 	cmpb   $0x0,0x54c0
      52:	75 36                	jne    8a <bsstest+0x5a>
      54:	b8 01 00 00 00       	mov    $0x1,%eax
      59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      60:	80 b8 c0 54 00 00 00 	cmpb   $0x0,0x54c0(%eax)
      67:	75 21                	jne    8a <bsstest+0x5a>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
      69:	83 c0 01             	add    $0x1,%eax
      6c:	3d 10 27 00 00       	cmp    $0x2710,%eax
      71:	75 ed                	jne    60 <bsstest+0x30>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
      73:	a1 14 54 00 00       	mov    0x5414,%eax
      78:	c7 44 24 04 b3 3d 00 	movl   $0x3db3,0x4(%esp)
      7f:	00 
      80:	89 04 24             	mov    %eax,(%esp)
      83:	e8 a8 39 00 00       	call   3a30 <printf>
}
      88:	c9                   	leave  
      89:	c3                   	ret    
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      8a:	a1 14 54 00 00       	mov    0x5414,%eax
      8f:	c7 44 24 04 a2 3d 00 	movl   $0x3da2,0x4(%esp)
      96:	00 
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 91 39 00 00       	call   3a30 <printf>
      exit();
      9f:	e8 44 38 00 00       	call   38e8 <exit>
      a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000b0 <opentest>:

// simple file system tests

void
opentest(void)
{
      b0:	55                   	push   %ebp
      b1:	89 e5                	mov    %esp,%ebp
      b3:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
      b6:	a1 14 54 00 00       	mov    0x5414,%eax
      bb:	c7 44 24 04 c0 3d 00 	movl   $0x3dc0,0x4(%esp)
      c2:	00 
      c3:	89 04 24             	mov    %eax,(%esp)
      c6:	e8 65 39 00 00       	call   3a30 <printf>
  fd = open("echo", 0);
      cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      d2:	00 
      d3:	c7 04 24 cb 3d 00 00 	movl   $0x3dcb,(%esp)
      da:	e8 49 38 00 00       	call   3928 <open>
  if(fd < 0){
      df:	85 c0                	test   %eax,%eax
      e1:	78 37                	js     11a <opentest+0x6a>
    printf(stdout, "open echo failed!\n");
    exit();
  }
  close(fd);
      e3:	89 04 24             	mov    %eax,(%esp)
      e6:	e8 25 38 00 00       	call   3910 <close>
  fd = open("doesnotexist", 0);
      eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      f2:	00 
      f3:	c7 04 24 e3 3d 00 00 	movl   $0x3de3,(%esp)
      fa:	e8 29 38 00 00       	call   3928 <open>
  if(fd >= 0){
      ff:	85 c0                	test   %eax,%eax
     101:	79 31                	jns    134 <opentest+0x84>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit();
  }
  printf(stdout, "open test ok\n");
     103:	a1 14 54 00 00       	mov    0x5414,%eax
     108:	c7 44 24 04 0e 3e 00 	movl   $0x3e0e,0x4(%esp)
     10f:	00 
     110:	89 04 24             	mov    %eax,(%esp)
     113:	e8 18 39 00 00       	call   3a30 <printf>
}
     118:	c9                   	leave  
     119:	c3                   	ret    
  int fd;

  printf(stdout, "open test\n");
  fd = open("echo", 0);
  if(fd < 0){
    printf(stdout, "open echo failed!\n");
     11a:	a1 14 54 00 00       	mov    0x5414,%eax
     11f:	c7 44 24 04 d0 3d 00 	movl   $0x3dd0,0x4(%esp)
     126:	00 
     127:	89 04 24             	mov    %eax,(%esp)
     12a:	e8 01 39 00 00       	call   3a30 <printf>
    exit();
     12f:	e8 b4 37 00 00       	call   38e8 <exit>
  }
  close(fd);
  fd = open("doesnotexist", 0);
  if(fd >= 0){
    printf(stdout, "open doesnotexist succeeded!\n");
     134:	a1 14 54 00 00       	mov    0x5414,%eax
     139:	c7 44 24 04 f0 3d 00 	movl   $0x3df0,0x4(%esp)
     140:	00 
     141:	89 04 24             	mov    %eax,(%esp)
     144:	e8 e7 38 00 00       	call   3a30 <printf>
    exit();
     149:	e8 9a 37 00 00       	call   38e8 <exit>
     14e:	66 90                	xchg   %ax,%ax

00000150 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
     150:	55                   	push   %ebp
     151:	89 e5                	mov    %esp,%ebp
     153:	57                   	push   %edi
     154:	56                   	push   %esi
     155:	53                   	push   %ebx
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
     156:	31 db                	xor    %ebx,%ebx

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
     158:	83 ec 5c             	sub    $0x5c,%esp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
     15b:	c7 44 24 04 1c 3e 00 	movl   $0x3e1c,0x4(%esp)
     162:	00 
     163:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     16a:	e8 c1 38 00 00       	call   3a30 <printf>
     16f:	90                   	nop

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     170:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
     175:	89 d9                	mov    %ebx,%ecx
     177:	f7 eb                	imul   %ebx
     179:	c1 f9 1f             	sar    $0x1f,%ecx

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
     17c:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
     180:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     184:	c1 fa 06             	sar    $0x6,%edx
     187:	29 ca                	sub    %ecx,%edx
    name[2] = '0' + (nfiles % 1000) / 100;
     189:	69 f2 e8 03 00 00    	imul   $0x3e8,%edx,%esi
  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     18f:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
     192:	89 da                	mov    %ebx,%edx
  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     194:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
     197:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf(1, "writing %s\n", name);
     19c:	c7 44 24 04 29 3e 00 	movl   $0x3e29,0x4(%esp)
     1a3:	00 

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
     1a4:	29 f2                	sub    %esi,%edx
     1a6:	89 d6                	mov    %edx,%esi
     1a8:	f7 ea                	imul   %edx
    name[3] = '0' + (nfiles % 100) / 10;
     1aa:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
     1af:	c1 fe 1f             	sar    $0x1f,%esi
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf(1, "writing %s\n", name);
     1b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
     1b9:	c1 fa 05             	sar    $0x5,%edx
     1bc:	29 f2                	sub    %esi,%edx
    name[3] = '0' + (nfiles % 100) / 10;
     1be:	be 67 66 66 66       	mov    $0x66666667,%esi

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
     1c3:	83 c2 30             	add    $0x30,%edx
     1c6:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
     1c9:	f7 eb                	imul   %ebx
     1cb:	c1 fa 05             	sar    $0x5,%edx
     1ce:	29 ca                	sub    %ecx,%edx
     1d0:	6b fa 64             	imul   $0x64,%edx,%edi
     1d3:	89 da                	mov    %ebx,%edx
     1d5:	29 fa                	sub    %edi,%edx
     1d7:	89 d0                	mov    %edx,%eax
     1d9:	89 d7                	mov    %edx,%edi
     1db:	f7 ee                	imul   %esi
    name[4] = '0' + (nfiles % 10);
     1dd:	89 d8                	mov    %ebx,%eax
  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
     1df:	c1 ff 1f             	sar    $0x1f,%edi
     1e2:	c1 fa 02             	sar    $0x2,%edx
     1e5:	29 fa                	sub    %edi,%edx
     1e7:	83 c2 30             	add    $0x30,%edx
     1ea:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
     1ed:	f7 ee                	imul   %esi
     1ef:	c1 fa 02             	sar    $0x2,%edx
     1f2:	29 ca                	sub    %ecx,%edx
     1f4:	8d 04 92             	lea    (%edx,%edx,4),%eax
     1f7:	89 da                	mov    %ebx,%edx
     1f9:	01 c0                	add    %eax,%eax
     1fb:	29 c2                	sub    %eax,%edx
     1fd:	89 d0                	mov    %edx,%eax
     1ff:	83 c0 30             	add    $0x30,%eax
     202:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    printf(1, "writing %s\n", name);
     205:	8d 45 a8             	lea    -0x58(%ebp),%eax
     208:	89 44 24 08          	mov    %eax,0x8(%esp)
     20c:	e8 1f 38 00 00       	call   3a30 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
     211:	8d 55 a8             	lea    -0x58(%ebp),%edx
     214:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     21b:	00 
     21c:	89 14 24             	mov    %edx,(%esp)
     21f:	e8 04 37 00 00       	call   3928 <open>
    if(fd < 0){
     224:	85 c0                	test   %eax,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf(1, "writing %s\n", name);
    int fd = open(name, O_CREATE|O_RDWR);
     226:	89 c7                	mov    %eax,%edi
    if(fd < 0){
     228:	78 53                	js     27d <fsfull+0x12d>
      printf(1, "open %s failed\n", name);
      break;
     22a:	31 f6                	xor    %esi,%esi
     22c:	eb 04                	jmp    232 <fsfull+0xe2>
     22e:	66 90                	xchg   %ax,%ax
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
      total += cc;
     230:	01 c6                	add    %eax,%esi
      printf(1, "open %s failed\n", name);
      break;
    }
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
     232:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     239:	00 
     23a:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
     241:	00 
     242:	89 3c 24             	mov    %edi,(%esp)
     245:	e8 be 36 00 00       	call   3908 <write>
      if(cc < 512)
     24a:	3d ff 01 00 00       	cmp    $0x1ff,%eax
     24f:	7f df                	jg     230 <fsfull+0xe0>
        break;
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
     251:	89 74 24 08          	mov    %esi,0x8(%esp)
     255:	c7 44 24 04 45 3e 00 	movl   $0x3e45,0x4(%esp)
     25c:	00 
     25d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     264:	e8 c7 37 00 00       	call   3a30 <printf>
    close(fd);
     269:	89 3c 24             	mov    %edi,(%esp)
     26c:	e8 9f 36 00 00       	call   3910 <close>
    if(total == 0)
     271:	85 f6                	test   %esi,%esi
     273:	74 23                	je     298 <fsfull+0x148>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
     275:	83 c3 01             	add    $0x1,%ebx
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
     278:	e9 f3 fe ff ff       	jmp    170 <fsfull+0x20>
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf(1, "writing %s\n", name);
    int fd = open(name, O_CREATE|O_RDWR);
    if(fd < 0){
      printf(1, "open %s failed\n", name);
     27d:	8d 45 a8             	lea    -0x58(%ebp),%eax
     280:	89 44 24 08          	mov    %eax,0x8(%esp)
     284:	c7 44 24 04 35 3e 00 	movl   $0x3e35,0x4(%esp)
     28b:	00 
     28c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     293:	e8 98 37 00 00       	call   3a30 <printf>
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     298:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
     29d:	89 d9                	mov    %ebx,%ecx
     29f:	f7 eb                	imul   %ebx
     2a1:	c1 f9 1f             	sar    $0x1f,%ecx
      break;
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
     2a4:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
     2a8:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     2ac:	c1 fa 06             	sar    $0x6,%edx
     2af:	29 ca                	sub    %ecx,%edx
    name[2] = '0' + (nfiles % 1000) / 100;
     2b1:	69 f2 e8 03 00 00    	imul   $0x3e8,%edx,%esi
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     2b7:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
     2ba:	89 da                	mov    %ebx,%edx
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
     2bc:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
     2bf:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
     2c4:	29 f2                	sub    %esi,%edx
     2c6:	89 d6                	mov    %edx,%esi
     2c8:	f7 ea                	imul   %edx
    name[3] = '0' + (nfiles % 100) / 10;
     2ca:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
     2cf:	c1 fe 1f             	sar    $0x1f,%esi
     2d2:	c1 fa 05             	sar    $0x5,%edx
     2d5:	29 f2                	sub    %esi,%edx
    name[3] = '0' + (nfiles % 100) / 10;
     2d7:	be 67 66 66 66       	mov    $0x66666667,%esi

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
     2dc:	83 c2 30             	add    $0x30,%edx
     2df:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
     2e2:	f7 eb                	imul   %ebx
     2e4:	c1 fa 05             	sar    $0x5,%edx
     2e7:	29 ca                	sub    %ecx,%edx
     2e9:	6b fa 64             	imul   $0x64,%edx,%edi
     2ec:	89 da                	mov    %ebx,%edx
     2ee:	29 fa                	sub    %edi,%edx
     2f0:	89 d0                	mov    %edx,%eax
     2f2:	89 d7                	mov    %edx,%edi
     2f4:	f7 ee                	imul   %esi
    name[4] = '0' + (nfiles % 10);
     2f6:	89 d8                	mov    %ebx,%eax
  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
     2f8:	c1 ff 1f             	sar    $0x1f,%edi
     2fb:	c1 fa 02             	sar    $0x2,%edx
     2fe:	29 fa                	sub    %edi,%edx
     300:	83 c2 30             	add    $0x30,%edx
     303:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
     306:	f7 ee                	imul   %esi
     308:	c1 fa 02             	sar    $0x2,%edx
     30b:	29 ca                	sub    %ecx,%edx
     30d:	8d 04 92             	lea    (%edx,%edx,4),%eax
     310:	89 da                	mov    %ebx,%edx
     312:	01 c0                	add    %eax,%eax
    name[5] = '\0';
    unlink(name);
    nfiles--;
     314:	83 eb 01             	sub    $0x1,%ebx
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
     317:	29 c2                	sub    %eax,%edx
     319:	89 d0                	mov    %edx,%eax
     31b:	83 c0 30             	add    $0x30,%eax
     31e:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    unlink(name);
     321:	8d 45 a8             	lea    -0x58(%ebp),%eax
     324:	89 04 24             	mov    %eax,(%esp)
     327:	e8 0c 36 00 00       	call   3938 <unlink>
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
     32c:	83 fb ff             	cmp    $0xffffffff,%ebx
     32f:	0f 85 63 ff ff ff    	jne    298 <fsfull+0x148>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
     335:	c7 44 24 04 55 3e 00 	movl   $0x3e55,0x4(%esp)
     33c:	00 
     33d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     344:	e8 e7 36 00 00       	call   3a30 <printf>
}
     349:	83 c4 5c             	add    $0x5c,%esp
     34c:	5b                   	pop    %ebx
     34d:	5e                   	pop    %esi
     34e:	5f                   	pop    %edi
     34f:	5d                   	pop    %ebp
     350:	c3                   	ret    
     351:	eb 0d                	jmp    360 <bigwrite>
     353:	90                   	nop
     354:	90                   	nop
     355:	90                   	nop
     356:	90                   	nop
     357:	90                   	nop
     358:	90                   	nop
     359:	90                   	nop
     35a:	90                   	nop
     35b:	90                   	nop
     35c:	90                   	nop
     35d:	90                   	nop
     35e:	90                   	nop
     35f:	90                   	nop

00000360 <bigwrite>:
}

// test writes that are larger than the log.
void
bigwrite(void)
{
     360:	55                   	push   %ebp
     361:	89 e5                	mov    %esp,%ebp
     363:	56                   	push   %esi
     364:	53                   	push   %ebx
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
     365:	bb f3 01 00 00       	mov    $0x1f3,%ebx
}

// test writes that are larger than the log.
void
bigwrite(void)
{
     36a:	83 ec 10             	sub    $0x10,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
     36d:	c7 44 24 04 6b 3e 00 	movl   $0x3e6b,0x4(%esp)
     374:	00 
     375:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     37c:	e8 af 36 00 00       	call   3a30 <printf>

  unlink("bigwrite");
     381:	c7 04 24 7a 3e 00 00 	movl   $0x3e7a,(%esp)
     388:	e8 ab 35 00 00       	call   3938 <unlink>
     38d:	8d 76 00             	lea    0x0(%esi),%esi
  for(sz = 499; sz < 12*512; sz += 471){
    fd = open("bigwrite", O_CREATE | O_RDWR);
     390:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     397:	00 
     398:	c7 04 24 7a 3e 00 00 	movl   $0x3e7a,(%esp)
     39f:	e8 84 35 00 00       	call   3928 <open>
    if(fd < 0){
     3a4:	85 c0                	test   %eax,%eax

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    fd = open("bigwrite", O_CREATE | O_RDWR);
     3a6:	89 c6                	mov    %eax,%esi
    if(fd < 0){
     3a8:	0f 88 8e 00 00 00    	js     43c <bigwrite+0xdc>
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
     3ae:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     3b2:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
     3b9:	00 
     3ba:	89 04 24             	mov    %eax,(%esp)
     3bd:	e8 46 35 00 00       	call   3908 <write>
      if(cc != sz){
     3c2:	39 c3                	cmp    %eax,%ebx
     3c4:	75 55                	jne    41b <bigwrite+0xbb>
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
     3c6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     3ca:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
     3d1:	00 
     3d2:	89 34 24             	mov    %esi,(%esp)
     3d5:	e8 2e 35 00 00       	call   3908 <write>
      if(cc != sz){
     3da:	39 d8                	cmp    %ebx,%eax
     3dc:	75 3d                	jne    41b <bigwrite+0xbb>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
     3de:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
     3e4:	89 34 24             	mov    %esi,(%esp)
     3e7:	e8 24 35 00 00       	call   3910 <close>
    unlink("bigwrite");
     3ec:	c7 04 24 7a 3e 00 00 	movl   $0x3e7a,(%esp)
     3f3:	e8 40 35 00 00       	call   3938 <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
     3f8:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
     3fe:	75 90                	jne    390 <bigwrite+0x30>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
     400:	c7 44 24 04 ad 3e 00 	movl   $0x3ead,0x4(%esp)
     407:	00 
     408:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     40f:	e8 1c 36 00 00       	call   3a30 <printf>
}
     414:	83 c4 10             	add    $0x10,%esp
     417:	5b                   	pop    %ebx
     418:	5e                   	pop    %esi
     419:	5d                   	pop    %ebp
     41a:	c3                   	ret    
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
     41b:	89 44 24 0c          	mov    %eax,0xc(%esp)
     41f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     423:	c7 44 24 04 9b 3e 00 	movl   $0x3e9b,0x4(%esp)
     42a:	00 
     42b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     432:	e8 f9 35 00 00       	call   3a30 <printf>
        exit();
     437:	e8 ac 34 00 00       	call   38e8 <exit>

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    fd = open("bigwrite", O_CREATE | O_RDWR);
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
     43c:	c7 44 24 04 83 3e 00 	movl   $0x3e83,0x4(%esp)
     443:	00 
     444:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     44b:	e8 e0 35 00 00       	call   3a30 <printf>
      exit();
     450:	e8 93 34 00 00       	call   38e8 <exit>
     455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000460 <createtest>:
  printf(stdout, "big files ok\n");
}

void
createtest(void)
{
     460:	55                   	push   %ebp
     461:	89 e5                	mov    %esp,%ebp
     463:	53                   	push   %ebx
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
     464:	bb 30 00 00 00       	mov    $0x30,%ebx
  printf(stdout, "big files ok\n");
}

void
createtest(void)
{
     469:	83 ec 14             	sub    $0x14,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     46c:	a1 14 54 00 00       	mov    0x5414,%eax
     471:	c7 44 24 04 bc 4c 00 	movl   $0x4cbc,0x4(%esp)
     478:	00 
     479:	89 04 24             	mov    %eax,(%esp)
     47c:	e8 af 35 00 00       	call   3a30 <printf>

  name[0] = 'a';
     481:	c6 05 e0 9b 00 00 61 	movb   $0x61,0x9be0
  name[2] = '\0';
     488:	c6 05 e2 9b 00 00 00 	movb   $0x0,0x9be2
     48f:	90                   	nop
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     490:	88 1d e1 9b 00 00    	mov    %bl,0x9be1
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
     496:	83 c3 01             	add    $0x1,%ebx

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
     499:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     4a0:	00 
     4a1:	c7 04 24 e0 9b 00 00 	movl   $0x9be0,(%esp)
     4a8:	e8 7b 34 00 00       	call   3928 <open>
    close(fd);
     4ad:	89 04 24             	mov    %eax,(%esp)
     4b0:	e8 5b 34 00 00       	call   3910 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     4b5:	80 fb 64             	cmp    $0x64,%bl
     4b8:	75 d6                	jne    490 <createtest+0x30>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     4ba:	c6 05 e0 9b 00 00 61 	movb   $0x61,0x9be0
  name[2] = '\0';
     4c1:	bb 30 00 00 00       	mov    $0x30,%ebx
     4c6:	c6 05 e2 9b 00 00 00 	movb   $0x0,0x9be2
     4cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     4d0:	88 1d e1 9b 00 00    	mov    %bl,0x9be1
    unlink(name);
     4d6:	83 c3 01             	add    $0x1,%ebx
     4d9:	c7 04 24 e0 9b 00 00 	movl   $0x9be0,(%esp)
     4e0:	e8 53 34 00 00       	call   3938 <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     4e5:	80 fb 64             	cmp    $0x64,%bl
     4e8:	75 e6                	jne    4d0 <createtest+0x70>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     4ea:	a1 14 54 00 00       	mov    0x5414,%eax
     4ef:	c7 44 24 04 e4 4c 00 	movl   $0x4ce4,0x4(%esp)
     4f6:	00 
     4f7:	89 04 24             	mov    %eax,(%esp)
     4fa:	e8 31 35 00 00       	call   3a30 <printf>
}
     4ff:	83 c4 14             	add    $0x14,%esp
     502:	5b                   	pop    %ebx
     503:	5d                   	pop    %ebp
     504:	c3                   	ret    
     505:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000510 <exectest>:
  printf(stdout, "mkdir test\n");
}

void
exectest(void)
{
     510:	55                   	push   %ebp
     511:	89 e5                	mov    %esp,%ebp
     513:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
     516:	a1 14 54 00 00       	mov    0x5414,%eax
     51b:	c7 44 24 04 ba 3e 00 	movl   $0x3eba,0x4(%esp)
     522:	00 
     523:	89 04 24             	mov    %eax,(%esp)
     526:	e8 05 35 00 00       	call   3a30 <printf>
  if(exec("echo", echoargv) < 0){
     52b:	c7 44 24 04 00 54 00 	movl   $0x5400,0x4(%esp)
     532:	00 
     533:	c7 04 24 cb 3d 00 00 	movl   $0x3dcb,(%esp)
     53a:	e8 e1 33 00 00       	call   3920 <exec>
     53f:	85 c0                	test   %eax,%eax
     541:	78 02                	js     545 <exectest+0x35>
    printf(stdout, "exec echo failed\n");
    exit();
  }
}
     543:	c9                   	leave  
     544:	c3                   	ret    
void
exectest(void)
{
  printf(stdout, "exec test\n");
  if(exec("echo", echoargv) < 0){
    printf(stdout, "exec echo failed\n");
     545:	a1 14 54 00 00       	mov    0x5414,%eax
     54a:	c7 44 24 04 c5 3e 00 	movl   $0x3ec5,0x4(%esp)
     551:	00 
     552:	89 04 24             	mov    %eax,(%esp)
     555:	e8 d6 34 00 00       	call   3a30 <printf>
    exit();
     55a:	e8 89 33 00 00       	call   38e8 <exit>
     55f:	90                   	nop

00000560 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
     560:	55                   	push   %ebp
     561:	89 e5                	mov    %esp,%ebp
     563:	83 ec 18             	sub    $0x18,%esp
  int pid, fd;

  unlink("bigarg-ok");
     566:	c7 04 24 d7 3e 00 00 	movl   $0x3ed7,(%esp)
     56d:	e8 c6 33 00 00       	call   3938 <unlink>
  pid = fork();
     572:	e8 69 33 00 00       	call   38e0 <fork>
  if(pid == 0){
     577:	83 f8 00             	cmp    $0x0,%eax
     57a:	74 44                	je     5c0 <bigargtest+0x60>
     57c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exec("echo", args);
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit();
  } else if(pid < 0){
     580:	0f 8c d0 00 00 00    	jl     656 <bigargtest+0xf6>
    printf(stdout, "bigargtest: fork failed\n");
    exit();
  }
  wait();
     586:	e8 65 33 00 00       	call   38f0 <wait>
  fd = open("bigarg-ok", 0);
     58b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     592:	00 
     593:	c7 04 24 d7 3e 00 00 	movl   $0x3ed7,(%esp)
     59a:	e8 89 33 00 00       	call   3928 <open>
  if(fd < 0){
     59f:	85 c0                	test   %eax,%eax
     5a1:	0f 88 95 00 00 00    	js     63c <bigargtest+0xdc>
    printf(stdout, "bigarg test failed!\n");
    exit();
  }
  close(fd);
     5a7:	89 04 24             	mov    %eax,(%esp)
     5aa:	e8 61 33 00 00       	call   3910 <close>
  unlink("bigarg-ok");
     5af:	c7 04 24 d7 3e 00 00 	movl   $0x3ed7,(%esp)
     5b6:	e8 7d 33 00 00       	call   3938 <unlink>
}
     5bb:	c9                   	leave  
     5bc:	c3                   	ret    
     5bd:	8d 76 00             	lea    0x0(%esi),%esi
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
     5c0:	c7 04 85 20 54 00 00 	movl   $0x4d0c,0x5420(,%eax,4)
     5c7:	0c 4d 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
     5cb:	83 c0 01             	add    $0x1,%eax
     5ce:	83 f8 1f             	cmp    $0x1f,%eax
     5d1:	75 ed                	jne    5c0 <bigargtest+0x60>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    printf(stdout, "bigarg test\n");
     5d3:	a1 14 54 00 00       	mov    0x5414,%eax
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
     5d8:	c7 05 9c 54 00 00 00 	movl   $0x0,0x549c
     5df:	00 00 00 
    printf(stdout, "bigarg test\n");
     5e2:	c7 44 24 04 e1 3e 00 	movl   $0x3ee1,0x4(%esp)
     5e9:	00 
     5ea:	89 04 24             	mov    %eax,(%esp)
     5ed:	e8 3e 34 00 00       	call   3a30 <printf>
    exec("echo", args);
     5f2:	c7 44 24 04 20 54 00 	movl   $0x5420,0x4(%esp)
     5f9:	00 
     5fa:	c7 04 24 cb 3d 00 00 	movl   $0x3dcb,(%esp)
     601:	e8 1a 33 00 00       	call   3920 <exec>
    printf(stdout, "bigarg test ok\n");
     606:	a1 14 54 00 00       	mov    0x5414,%eax
     60b:	c7 44 24 04 ee 3e 00 	movl   $0x3eee,0x4(%esp)
     612:	00 
     613:	89 04 24             	mov    %eax,(%esp)
     616:	e8 15 34 00 00       	call   3a30 <printf>
    fd = open("bigarg-ok", O_CREATE);
     61b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     622:	00 
     623:	c7 04 24 d7 3e 00 00 	movl   $0x3ed7,(%esp)
     62a:	e8 f9 32 00 00       	call   3928 <open>
    close(fd);
     62f:	89 04 24             	mov    %eax,(%esp)
     632:	e8 d9 32 00 00       	call   3910 <close>
    exit();
     637:	e8 ac 32 00 00       	call   38e8 <exit>
    exit();
  }
  wait();
  fd = open("bigarg-ok", 0);
  if(fd < 0){
    printf(stdout, "bigarg test failed!\n");
     63c:	a1 14 54 00 00       	mov    0x5414,%eax
     641:	c7 44 24 04 17 3f 00 	movl   $0x3f17,0x4(%esp)
     648:	00 
     649:	89 04 24             	mov    %eax,(%esp)
     64c:	e8 df 33 00 00       	call   3a30 <printf>
    exit();
     651:	e8 92 32 00 00       	call   38e8 <exit>
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit();
  } else if(pid < 0){
    printf(stdout, "bigargtest: fork failed\n");
     656:	a1 14 54 00 00       	mov    0x5414,%eax
     65b:	c7 44 24 04 fe 3e 00 	movl   $0x3efe,0x4(%esp)
     662:	00 
     663:	89 04 24             	mov    %eax,(%esp)
     666:	e8 c5 33 00 00       	call   3a30 <printf>
    exit();
     66b:	e8 78 32 00 00       	call   38e8 <exit>

00000670 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
     670:	55                   	push   %ebp
     671:	89 e5                	mov    %esp,%ebp
     673:	53                   	push   %ebx
  int n, pid;

  printf(1, "fork test\n");
     674:	31 db                	xor    %ebx,%ebx
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
     676:	83 ec 14             	sub    $0x14,%esp
  int n, pid;

  printf(1, "fork test\n");
     679:	c7 44 24 04 2c 3f 00 	movl   $0x3f2c,0x4(%esp)
     680:	00 
     681:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     688:	e8 a3 33 00 00       	call   3a30 <printf>
     68d:	eb 0e                	jmp    69d <forktest+0x2d>
     68f:	90                   	nop

  for(n=0; n<1000; n++){
    pid = fork();
    if(pid < 0)
      break;
    if(pid == 0)
     690:	74 6a                	je     6fc <forktest+0x8c>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
     692:	83 c3 01             	add    $0x1,%ebx
     695:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
     69b:	74 4b                	je     6e8 <forktest+0x78>
    pid = fork();
     69d:	e8 3e 32 00 00       	call   38e0 <fork>
    if(pid < 0)
     6a2:	83 f8 00             	cmp    $0x0,%eax
     6a5:	7d e9                	jge    690 <forktest+0x20>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
     6a7:	85 db                	test   %ebx,%ebx
     6a9:	74 13                	je     6be <forktest+0x4e>
     6ab:	90                   	nop
     6ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(wait() < 0){
     6b0:	e8 3b 32 00 00       	call   38f0 <wait>
     6b5:	85 c0                	test   %eax,%eax
     6b7:	78 48                	js     701 <forktest+0x91>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
     6b9:	83 eb 01             	sub    $0x1,%ebx
     6bc:	75 f2                	jne    6b0 <forktest+0x40>
     6be:	66 90                	xchg   %ax,%ax
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
     6c0:	e8 2b 32 00 00       	call   38f0 <wait>
     6c5:	83 f8 ff             	cmp    $0xffffffff,%eax
     6c8:	75 50                	jne    71a <forktest+0xaa>
    printf(1, "wait got too many\n");
    exit();
  }
  
  printf(1, "fork test OK\n");
     6ca:	c7 44 24 04 5e 3f 00 	movl   $0x3f5e,0x4(%esp)
     6d1:	00 
     6d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6d9:	e8 52 33 00 00       	call   3a30 <printf>
}
     6de:	83 c4 14             	add    $0x14,%esp
     6e1:	5b                   	pop    %ebx
     6e2:	5d                   	pop    %ebp
     6e3:	c3                   	ret    
     6e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
     6e8:	c7 44 24 04 ec 4d 00 	movl   $0x4dec,0x4(%esp)
     6ef:	00 
     6f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6f7:	e8 34 33 00 00       	call   3a30 <printf>
    exit();
     6fc:	e8 e7 31 00 00       	call   38e8 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
     701:	c7 44 24 04 37 3f 00 	movl   $0x3f37,0x4(%esp)
     708:	00 
     709:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     710:	e8 1b 33 00 00       	call   3a30 <printf>
      exit();
     715:	e8 ce 31 00 00       	call   38e8 <exit>
    }
  }
  
  if(wait() != -1){
    printf(1, "wait got too many\n");
     71a:	c7 44 24 04 4b 3f 00 	movl   $0x3f4b,0x4(%esp)
     721:	00 
     722:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     729:	e8 02 33 00 00       	call   3a30 <printf>
    exit();
     72e:	e8 b5 31 00 00       	call   38e8 <exit>
     733:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000740 <createdelete>:
}

// two processes create and delete different files in same directory
void
createdelete(void)
{
     740:	55                   	push   %ebp
     741:	89 e5                	mov    %esp,%ebp
     743:	57                   	push   %edi
     744:	56                   	push   %esi
     745:	53                   	push   %ebx
     746:	83 ec 4c             	sub    $0x4c,%esp
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
     749:	c7 44 24 04 6c 3f 00 	movl   $0x3f6c,0x4(%esp)
     750:	00 
     751:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     758:	e8 d3 32 00 00       	call   3a30 <printf>
  pid = fork();
     75d:	e8 7e 31 00 00       	call   38e0 <fork>
  if(pid < 0){
     762:	85 c0                	test   %eax,%eax
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
  pid = fork();
     764:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  if(pid < 0){
     767:	0f 88 12 02 00 00    	js     97f <createdelete+0x23f>
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
     76d:	83 7d c4 01          	cmpl   $0x1,-0x3c(%ebp)
  name[2] = '\0';
     771:	bf 01 00 00 00       	mov    $0x1,%edi
     776:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
     77a:	8d 75 c8             	lea    -0x38(%ebp),%esi
  if(pid < 0){
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
     77d:	19 c0                	sbb    %eax,%eax
  name[2] = '\0';
     77f:	31 db                	xor    %ebx,%ebx
  if(pid < 0){
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
     781:	83 e0 f3             	and    $0xfffffff3,%eax
     784:	83 c0 70             	add    $0x70,%eax
     787:	88 45 c8             	mov    %al,-0x38(%ebp)
     78a:	eb 0f                	jmp    79b <createdelete+0x5b>
     78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  name[2] = '\0';
  for(i = 0; i < N; i++){
     790:	83 ff 13             	cmp    $0x13,%edi
     793:	7f 6b                	jg     800 <createdelete+0xc0>
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
  name[2] = '\0';
     795:	83 c3 01             	add    $0x1,%ebx
     798:	83 c7 01             	add    $0x1,%edi
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
     79b:	8d 43 30             	lea    0x30(%ebx),%eax
     79e:	88 45 c9             	mov    %al,-0x37(%ebp)
    fd = open(name, O_CREATE | O_RDWR);
     7a1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     7a8:	00 
     7a9:	89 34 24             	mov    %esi,(%esp)
     7ac:	e8 77 31 00 00       	call   3928 <open>
    if(fd < 0){
     7b1:	85 c0                	test   %eax,%eax
     7b3:	0f 88 3e 01 00 00    	js     8f7 <createdelete+0x1b7>
      printf(1, "create failed\n");
      exit();
    }
    close(fd);
     7b9:	89 04 24             	mov    %eax,(%esp)
     7bc:	e8 4f 31 00 00       	call   3910 <close>
    if(i > 0 && (i % 2 ) == 0){
     7c1:	85 db                	test   %ebx,%ebx
     7c3:	74 d0                	je     795 <createdelete+0x55>
     7c5:	f6 c3 01             	test   $0x1,%bl
     7c8:	75 c6                	jne    790 <createdelete+0x50>
      name[1] = '0' + (i / 2);
     7ca:	89 d8                	mov    %ebx,%eax
     7cc:	d1 f8                	sar    %eax
     7ce:	83 c0 30             	add    $0x30,%eax
     7d1:	88 45 c9             	mov    %al,-0x37(%ebp)
      if(unlink(name) < 0){
     7d4:	89 34 24             	mov    %esi,(%esp)
     7d7:	e8 5c 31 00 00       	call   3938 <unlink>
     7dc:	85 c0                	test   %eax,%eax
     7de:	79 b0                	jns    790 <createdelete+0x50>
        printf(1, "unlink failed\n");
     7e0:	c7 44 24 04 7f 3f 00 	movl   $0x3f7f,0x4(%esp)
     7e7:	00 
     7e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     7ef:	e8 3c 32 00 00       	call   3a30 <printf>
        exit();
     7f4:	e8 ef 30 00 00       	call   38e8 <exit>
     7f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      }
    }
  }

  if(pid==0)
     800:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     803:	85 c0                	test   %eax,%eax
     805:	0f 84 6f 01 00 00    	je     97a <createdelete+0x23a>
    exit();
  else
    wait();
     80b:	e8 e0 30 00 00       	call   38f0 <wait>
     810:	31 db                	xor    %ebx,%ebx
     812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(i = 0; i < N; i++){
    name[0] = 'p';
     818:	8d 7b 30             	lea    0x30(%ebx),%edi
    name[1] = '0' + i;
     81b:	89 f8                	mov    %edi,%eax
    exit();
  else
    wait();

  for(i = 0; i < N; i++){
    name[0] = 'p';
     81d:	c6 45 c8 70          	movb   $0x70,-0x38(%ebp)
    name[1] = '0' + i;
     821:	88 45 c9             	mov    %al,-0x37(%ebp)
    fd = open(name, 0);
     824:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     82b:	00 
     82c:	89 34 24             	mov    %esi,(%esp)
     82f:	e8 f4 30 00 00       	call   3928 <open>
    if((i == 0 || i >= N/2) && fd < 0){
     834:	83 fb 09             	cmp    $0x9,%ebx
     837:	0f 9f c1             	setg   %cl
     83a:	85 db                	test   %ebx,%ebx
     83c:	0f 94 c2             	sete   %dl
     83f:	08 d1                	or     %dl,%cl
     841:	88 4d c3             	mov    %cl,-0x3d(%ebp)
     844:	74 08                	je     84e <createdelete+0x10e>
     846:	85 c0                	test   %eax,%eax
     848:	0f 88 14 01 00 00    	js     962 <createdelete+0x222>
      printf(1, "oops createdelete %s didn't exist\n", name);
      exit();
    } else if((i >= 1 && i < N/2) && fd >= 0){
     84e:	8d 53 ff             	lea    -0x1(%ebx),%edx
     851:	83 fa 08             	cmp    $0x8,%edx
     854:	89 c2                	mov    %eax,%edx
     856:	f7 d2                	not    %edx
     858:	0f 96 45 c4          	setbe  -0x3c(%ebp)
     85c:	c1 ea 1f             	shr    $0x1f,%edx
     85f:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
     863:	0f 85 b7 00 00 00    	jne    920 <createdelete+0x1e0>
      printf(1, "oops createdelete %s did exist\n", name);
      exit();
    }
    if(fd >= 0)
     869:	84 d2                	test   %dl,%dl
     86b:	74 08                	je     875 <createdelete+0x135>
      close(fd);
     86d:	89 04 24             	mov    %eax,(%esp)
     870:	e8 9b 30 00 00       	call   3910 <close>

    name[0] = 'c';
    name[1] = '0' + i;
     875:	89 f8                	mov    %edi,%eax
      exit();
    }
    if(fd >= 0)
      close(fd);

    name[0] = 'c';
     877:	c6 45 c8 63          	movb   $0x63,-0x38(%ebp)
    name[1] = '0' + i;
     87b:	88 45 c9             	mov    %al,-0x37(%ebp)
    fd = open(name, 0);
     87e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     885:	00 
     886:	89 34 24             	mov    %esi,(%esp)
     889:	e8 9a 30 00 00       	call   3928 <open>
    if((i == 0 || i >= N/2) && fd < 0){
     88e:	80 7d c3 00          	cmpb   $0x0,-0x3d(%ebp)
     892:	74 08                	je     89c <createdelete+0x15c>
     894:	85 c0                	test   %eax,%eax
     896:	0f 88 a9 00 00 00    	js     945 <createdelete+0x205>
      printf(1, "oops createdelete %s didn't exist\n", name);
      exit();
    } else if((i >= 1 && i < N/2) && fd >= 0){
     89c:	85 c0                	test   %eax,%eax
     89e:	66 90                	xchg   %ax,%ax
     8a0:	79 6e                	jns    910 <createdelete+0x1d0>
  if(pid==0)
    exit();
  else
    wait();

  for(i = 0; i < N; i++){
     8a2:	83 c3 01             	add    $0x1,%ebx
     8a5:	83 fb 14             	cmp    $0x14,%ebx
     8a8:	0f 85 6a ff ff ff    	jne    818 <createdelete+0xd8>
     8ae:	bb 30 00 00 00       	mov    $0x30,%ebx
     8b3:	90                   	nop
     8b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      close(fd);
  }

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
     8b8:	88 5d c9             	mov    %bl,-0x37(%ebp)
    unlink(name);
    name[0] = 'c';
    unlink(name);
     8bb:	83 c3 01             	add    $0x1,%ebx
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    name[0] = 'p';
     8be:	c6 45 c8 70          	movb   $0x70,-0x38(%ebp)
    name[1] = '0' + i;
    unlink(name);
     8c2:	89 34 24             	mov    %esi,(%esp)
     8c5:	e8 6e 30 00 00       	call   3938 <unlink>
    name[0] = 'c';
     8ca:	c6 45 c8 63          	movb   $0x63,-0x38(%ebp)
    unlink(name);
     8ce:	89 34 24             	mov    %esi,(%esp)
     8d1:	e8 62 30 00 00       	call   3938 <unlink>
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
     8d6:	80 fb 44             	cmp    $0x44,%bl
     8d9:	75 dd                	jne    8b8 <createdelete+0x178>
    unlink(name);
    name[0] = 'c';
    unlink(name);
  }

  printf(1, "createdelete ok\n");
     8db:	c7 44 24 04 8e 3f 00 	movl   $0x3f8e,0x4(%esp)
     8e2:	00 
     8e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8ea:	e8 41 31 00 00       	call   3a30 <printf>
}
     8ef:	83 c4 4c             	add    $0x4c,%esp
     8f2:	5b                   	pop    %ebx
     8f3:	5e                   	pop    %esi
     8f4:	5f                   	pop    %edi
     8f5:	5d                   	pop    %ebp
     8f6:	c3                   	ret    
  name[2] = '\0';
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
    fd = open(name, O_CREATE | O_RDWR);
    if(fd < 0){
      printf(1, "create failed\n");
     8f7:	c7 44 24 04 13 40 00 	movl   $0x4013,0x4(%esp)
     8fe:	00 
     8ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     906:	e8 25 31 00 00       	call   3a30 <printf>
      exit();
     90b:	e8 d8 2f 00 00       	call   38e8 <exit>
    name[1] = '0' + i;
    fd = open(name, 0);
    if((i == 0 || i >= N/2) && fd < 0){
      printf(1, "oops createdelete %s didn't exist\n", name);
      exit();
    } else if((i >= 1 && i < N/2) && fd >= 0){
     910:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
     914:	75 12                	jne    928 <createdelete+0x1e8>
      printf(1, "oops createdelete %s did exist\n", name);
      exit();
    }
    if(fd >= 0)
      close(fd);
     916:	89 04 24             	mov    %eax,(%esp)
     919:	e8 f2 2f 00 00       	call   3910 <close>
     91e:	eb 82                	jmp    8a2 <createdelete+0x162>
    name[1] = '0' + i;
    fd = open(name, 0);
    if((i == 0 || i >= N/2) && fd < 0){
      printf(1, "oops createdelete %s didn't exist\n", name);
      exit();
    } else if((i >= 1 && i < N/2) && fd >= 0){
     920:	84 d2                	test   %dl,%dl
     922:	0f 84 4d ff ff ff    	je     875 <createdelete+0x135>
    fd = open(name, 0);
    if((i == 0 || i >= N/2) && fd < 0){
      printf(1, "oops createdelete %s didn't exist\n", name);
      exit();
    } else if((i >= 1 && i < N/2) && fd >= 0){
      printf(1, "oops createdelete %s did exist\n", name);
     928:	89 74 24 08          	mov    %esi,0x8(%esp)
     92c:	c7 44 24 04 34 4e 00 	movl   $0x4e34,0x4(%esp)
     933:	00 
     934:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     93b:	e8 f0 30 00 00       	call   3a30 <printf>
      exit();
     940:	e8 a3 2f 00 00       	call   38e8 <exit>

    name[0] = 'c';
    name[1] = '0' + i;
    fd = open(name, 0);
    if((i == 0 || i >= N/2) && fd < 0){
      printf(1, "oops createdelete %s didn't exist\n", name);
     945:	89 74 24 08          	mov    %esi,0x8(%esp)
     949:	c7 44 24 04 10 4e 00 	movl   $0x4e10,0x4(%esp)
     950:	00 
     951:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     958:	e8 d3 30 00 00       	call   3a30 <printf>
      exit();
     95d:	e8 86 2f 00 00       	call   38e8 <exit>
  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
    fd = open(name, 0);
    if((i == 0 || i >= N/2) && fd < 0){
      printf(1, "oops createdelete %s didn't exist\n", name);
     962:	89 74 24 08          	mov    %esi,0x8(%esp)
     966:	c7 44 24 04 10 4e 00 	movl   $0x4e10,0x4(%esp)
     96d:	00 
     96e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     975:	e8 b6 30 00 00       	call   3a30 <printf>
      exit();
     97a:	e8 69 2f 00 00       	call   38e8 <exit>
  char name[32];

  printf(1, "createdelete test\n");
  pid = fork();
  if(pid < 0){
    printf(1, "fork failed\n");
     97f:	c7 44 24 04 0a 3f 00 	movl   $0x3f0a,0x4(%esp)
     986:	00 
     987:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     98e:	e8 9d 30 00 00       	call   3a30 <printf>
    exit();
     993:	e8 50 2f 00 00       	call   38e8 <exit>
     998:	90                   	nop
     999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000009a0 <exitwait>:
}

// try to find any races between exit and wait
void
exitwait(void)
{
     9a0:	55                   	push   %ebp
     9a1:	89 e5                	mov    %esp,%ebp
     9a3:	56                   	push   %esi
     9a4:	31 f6                	xor    %esi,%esi
     9a6:	53                   	push   %ebx
     9a7:	83 ec 10             	sub    $0x10,%esp
     9aa:	eb 17                	jmp    9c3 <exitwait+0x23>
     9ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
     9b0:	74 79                	je     a2b <exitwait+0x8b>
      if(wait() != pid){
     9b2:	e8 39 2f 00 00       	call   38f0 <wait>
     9b7:	39 c3                	cmp    %eax,%ebx
     9b9:	75 35                	jne    9f0 <exitwait+0x50>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     9bb:	83 c6 01             	add    $0x1,%esi
     9be:	83 fe 64             	cmp    $0x64,%esi
     9c1:	74 4d                	je     a10 <exitwait+0x70>
    pid = fork();
     9c3:	e8 18 2f 00 00       	call   38e0 <fork>
    if(pid < 0){
     9c8:	83 f8 00             	cmp    $0x0,%eax
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
    pid = fork();
     9cb:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     9cd:	7d e1                	jge    9b0 <exitwait+0x10>
      printf(1, "fork failed\n");
     9cf:	c7 44 24 04 0a 3f 00 	movl   $0x3f0a,0x4(%esp)
     9d6:	00 
     9d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9de:	e8 4d 30 00 00       	call   3a30 <printf>
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
}
     9e3:	83 c4 10             	add    $0x10,%esp
     9e6:	5b                   	pop    %ebx
     9e7:	5e                   	pop    %esi
     9e8:	5d                   	pop    %ebp
     9e9:	c3                   	ret    
     9ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
      if(wait() != pid){
        printf(1, "wait wrong pid\n");
     9f0:	c7 44 24 04 9f 3f 00 	movl   $0x3f9f,0x4(%esp)
     9f7:	00 
     9f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9ff:	e8 2c 30 00 00       	call   3a30 <printf>
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
}
     a04:	83 c4 10             	add    $0x10,%esp
     a07:	5b                   	pop    %ebx
     a08:	5e                   	pop    %esi
     a09:	5d                   	pop    %ebp
     a0a:	c3                   	ret    
     a0b:	90                   	nop
     a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     a10:	c7 44 24 04 af 3f 00 	movl   $0x3faf,0x4(%esp)
     a17:	00 
     a18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a1f:	e8 0c 30 00 00       	call   3a30 <printf>
}
     a24:	83 c4 10             	add    $0x10,%esp
     a27:	5b                   	pop    %ebx
     a28:	5e                   	pop    %esi
     a29:	5d                   	pop    %ebp
     a2a:	c3                   	ret    
      if(wait() != pid){
        printf(1, "wait wrong pid\n");
        return;
      }
    } else {
      exit();
     a2b:	e8 b8 2e 00 00       	call   38e8 <exit>

00000a30 <validatetest>:
      "ebx");
}

void
validatetest(void)
{
     a30:	55                   	push   %ebp
     a31:	89 e5                	mov    %esp,%ebp
     a33:	56                   	push   %esi
     a34:	53                   	push   %ebx
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
     a35:	31 db                	xor    %ebx,%ebx
      "ebx");
}

void
validatetest(void)
{
     a37:	83 ec 10             	sub    $0x10,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
     a3a:	a1 14 54 00 00       	mov    0x5414,%eax
     a3f:	c7 44 24 04 bc 3f 00 	movl   $0x3fbc,0x4(%esp)
     a46:	00 
     a47:	89 04 24             	mov    %eax,(%esp)
     a4a:	e8 e1 2f 00 00       	call   3a30 <printf>
     a4f:	90                   	nop
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    if((pid = fork()) == 0){
     a50:	e8 8b 2e 00 00       	call   38e0 <fork>
     a55:	85 c0                	test   %eax,%eax
     a57:	89 c6                	mov    %eax,%esi
     a59:	74 79                	je     ad4 <validatetest+0xa4>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
      exit();
    }
    sleep(0);
     a5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a62:	e8 11 2f 00 00       	call   3978 <sleep>
    sleep(0);
     a67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a6e:	e8 05 2f 00 00       	call   3978 <sleep>
    kill(pid);
     a73:	89 34 24             	mov    %esi,(%esp)
     a76:	e8 9d 2e 00 00       	call   3918 <kill>
    wait();
     a7b:	e8 70 2e 00 00       	call   38f0 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
     a80:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     a84:	c7 04 24 cb 3f 00 00 	movl   $0x3fcb,(%esp)
     a8b:	e8 b8 2e 00 00       	call   3948 <link>
     a90:	83 f8 ff             	cmp    $0xffffffff,%eax
     a93:	75 2a                	jne    abf <validatetest+0x8f>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
     a95:	81 c3 00 10 00 00    	add    $0x1000,%ebx
     a9b:	81 fb 00 40 11 00    	cmp    $0x114000,%ebx
     aa1:	75 ad                	jne    a50 <validatetest+0x20>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
     aa3:	a1 14 54 00 00       	mov    0x5414,%eax
     aa8:	c7 44 24 04 ef 3f 00 	movl   $0x3fef,0x4(%esp)
     aaf:	00 
     ab0:	89 04 24             	mov    %eax,(%esp)
     ab3:	e8 78 2f 00 00       	call   3a30 <printf>
}
     ab8:	83 c4 10             	add    $0x10,%esp
     abb:	5b                   	pop    %ebx
     abc:	5e                   	pop    %esi
     abd:	5d                   	pop    %ebp
     abe:	c3                   	ret    
    kill(pid);
    wait();

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
      printf(stdout, "link should not succeed\n");
     abf:	a1 14 54 00 00       	mov    0x5414,%eax
     ac4:	c7 44 24 04 d6 3f 00 	movl   $0x3fd6,0x4(%esp)
     acb:	00 
     acc:	89 04 24             	mov    %eax,(%esp)
     acf:	e8 5c 2f 00 00       	call   3a30 <printf>
      exit();
     ad4:	e8 0f 2e 00 00       	call   38e8 <exit>
     ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000ae0 <bigdir>:
}

// directory that uses indirect blocks
void
bigdir(void)
{
     ae0:	55                   	push   %ebp
     ae1:	89 e5                	mov    %esp,%ebp
     ae3:	56                   	push   %esi
     ae4:	53                   	push   %ebx
     ae5:	83 ec 20             	sub    $0x20,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
     ae8:	c7 44 24 04 fc 3f 00 	movl   $0x3ffc,0x4(%esp)
     aef:	00 
     af0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     af7:	e8 34 2f 00 00       	call   3a30 <printf>
  unlink("bd");
     afc:	c7 04 24 09 40 00 00 	movl   $0x4009,(%esp)
     b03:	e8 30 2e 00 00       	call   3938 <unlink>

  fd = open("bd", O_CREATE);
     b08:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     b0f:	00 
     b10:	c7 04 24 09 40 00 00 	movl   $0x4009,(%esp)
     b17:	e8 0c 2e 00 00       	call   3928 <open>
  if(fd < 0){
     b1c:	85 c0                	test   %eax,%eax
     b1e:	0f 88 e6 00 00 00    	js     c0a <bigdir+0x12a>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
     b24:	89 04 24             	mov    %eax,(%esp)
     b27:	31 db                	xor    %ebx,%ebx
     b29:	e8 e2 2d 00 00       	call   3910 <close>
     b2e:	8d 75 ee             	lea    -0x12(%ebp),%esi
     b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
     b38:	89 d8                	mov    %ebx,%eax
     b3a:	c1 f8 06             	sar    $0x6,%eax
     b3d:	83 c0 30             	add    $0x30,%eax
     b40:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
     b43:	89 d8                	mov    %ebx,%eax
     b45:	83 e0 3f             	and    $0x3f,%eax
     b48:	83 c0 30             	add    $0x30,%eax
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    name[0] = 'x';
     b4b:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
     b4f:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
     b52:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(link("bd", name) != 0){
     b56:	89 74 24 04          	mov    %esi,0x4(%esp)
     b5a:	c7 04 24 09 40 00 00 	movl   $0x4009,(%esp)
     b61:	e8 e2 2d 00 00       	call   3948 <link>
     b66:	85 c0                	test   %eax,%eax
     b68:	75 6e                	jne    bd8 <bigdir+0xf8>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
     b6a:	83 c3 01             	add    $0x1,%ebx
     b6d:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
     b73:	75 c3                	jne    b38 <bigdir+0x58>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
     b75:	c7 04 24 09 40 00 00 	movl   $0x4009,(%esp)
     b7c:	66 31 db             	xor    %bx,%bx
     b7f:	e8 b4 2d 00 00       	call   3938 <unlink>
     b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
     b88:	89 d8                	mov    %ebx,%eax
     b8a:	c1 f8 06             	sar    $0x6,%eax
     b8d:	83 c0 30             	add    $0x30,%eax
     b90:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
     b93:	89 d8                	mov    %ebx,%eax
     b95:	83 e0 3f             	and    $0x3f,%eax
     b98:	83 c0 30             	add    $0x30,%eax
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    name[0] = 'x';
     b9b:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
     b9f:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
     ba2:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(unlink(name) != 0){
     ba6:	89 34 24             	mov    %esi,(%esp)
     ba9:	e8 8a 2d 00 00       	call   3938 <unlink>
     bae:	85 c0                	test   %eax,%eax
     bb0:	75 3f                	jne    bf1 <bigdir+0x111>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
     bb2:	83 c3 01             	add    $0x1,%ebx
     bb5:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
     bbb:	75 cb                	jne    b88 <bigdir+0xa8>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
     bbd:	c7 44 24 04 4b 40 00 	movl   $0x404b,0x4(%esp)
     bc4:	00 
     bc5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     bcc:	e8 5f 2e 00 00       	call   3a30 <printf>
}
     bd1:	83 c4 20             	add    $0x20,%esp
     bd4:	5b                   	pop    %ebx
     bd5:	5e                   	pop    %esi
     bd6:	5d                   	pop    %ebp
     bd7:	c3                   	ret    
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
      printf(1, "bigdir link failed\n");
     bd8:	c7 44 24 04 22 40 00 	movl   $0x4022,0x4(%esp)
     bdf:	00 
     be0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     be7:	e8 44 2e 00 00       	call   3a30 <printf>
      exit();
     bec:	e8 f7 2c 00 00       	call   38e8 <exit>
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(unlink(name) != 0){
      printf(1, "bigdir unlink failed");
     bf1:	c7 44 24 04 36 40 00 	movl   $0x4036,0x4(%esp)
     bf8:	00 
     bf9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c00:	e8 2b 2e 00 00       	call   3a30 <printf>
      exit();
     c05:	e8 de 2c 00 00       	call   38e8 <exit>
  printf(1, "bigdir test\n");
  unlink("bd");

  fd = open("bd", O_CREATE);
  if(fd < 0){
    printf(1, "bigdir create failed\n");
     c0a:	c7 44 24 04 0c 40 00 	movl   $0x400c,0x4(%esp)
     c11:	00 
     c12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c19:	e8 12 2e 00 00       	call   3a30 <printf>
    exit();
     c1e:	e8 c5 2c 00 00       	call   38e8 <exit>
     c23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c30 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
     c30:	55                   	push   %ebp
     c31:	89 e5                	mov    %esp,%ebp
     c33:	57                   	push   %edi
     c34:	56                   	push   %esi
     c35:	53                   	push   %ebx
     c36:	83 ec 2c             	sub    $0x2c,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
     c39:	c7 44 24 04 56 40 00 	movl   $0x4056,0x4(%esp)
     c40:	00 
     c41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c48:	e8 e3 2d 00 00       	call   3a30 <printf>

  unlink("x");
     c4d:	c7 04 24 4e 49 00 00 	movl   $0x494e,(%esp)
     c54:	e8 df 2c 00 00       	call   3938 <unlink>
  pid = fork();
     c59:	e8 82 2c 00 00       	call   38e0 <fork>
  if(pid < 0){
     c5e:	85 c0                	test   %eax,%eax
  int pid, i;

  printf(1, "linkunlink test\n");

  unlink("x");
  pid = fork();
     c60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
     c63:	0f 88 b0 00 00 00    	js     d19 <linkunlink+0xe9>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
     c69:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
     c6d:	bf ab aa aa aa       	mov    $0xaaaaaaab,%edi
  if(pid < 0){
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
     c72:	19 db                	sbb    %ebx,%ebx
     c74:	31 f6                	xor    %esi,%esi
     c76:	83 e3 60             	and    $0x60,%ebx
     c79:	83 c3 01             	add    $0x1,%ebx
     c7c:	eb 1b                	jmp    c99 <linkunlink+0x69>
     c7e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
      close(open("x", O_RDWR | O_CREATE));
    } else if((x % 3) == 1){
     c80:	83 f8 01             	cmp    $0x1,%eax
     c83:	74 7b                	je     d00 <linkunlink+0xd0>
      link("cat", "x");
    } else {
      unlink("x");
     c85:	c7 04 24 4e 49 00 00 	movl   $0x494e,(%esp)
     c8c:	e8 a7 2c 00 00       	call   3938 <unlink>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
     c91:	83 c6 01             	add    $0x1,%esi
     c94:	83 fe 64             	cmp    $0x64,%esi
     c97:	74 3f                	je     cd8 <linkunlink+0xa8>
    x = x * 1103515245 + 12345;
     c99:	69 db 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%ebx
     c9f:	81 c3 39 30 00 00    	add    $0x3039,%ebx
    if((x % 3) == 0){
     ca5:	89 d8                	mov    %ebx,%eax
     ca7:	f7 e7                	mul    %edi
     ca9:	89 d8                	mov    %ebx,%eax
     cab:	d1 ea                	shr    %edx
     cad:	8d 14 52             	lea    (%edx,%edx,2),%edx
     cb0:	29 d0                	sub    %edx,%eax
     cb2:	75 cc                	jne    c80 <linkunlink+0x50>
      close(open("x", O_RDWR | O_CREATE));
     cb4:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     cbb:	00 
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
     cbc:	83 c6 01             	add    $0x1,%esi
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
      close(open("x", O_RDWR | O_CREATE));
     cbf:	c7 04 24 4e 49 00 00 	movl   $0x494e,(%esp)
     cc6:	e8 5d 2c 00 00       	call   3928 <open>
     ccb:	89 04 24             	mov    %eax,(%esp)
     cce:	e8 3d 2c 00 00       	call   3910 <close>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
     cd3:	83 fe 64             	cmp    $0x64,%esi
     cd6:	75 c1                	jne    c99 <linkunlink+0x69>
    } else {
      unlink("x");
    }
  }

  if(pid)
     cd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     cdb:	85 d2                	test   %edx,%edx
     cdd:	74 53                	je     d32 <linkunlink+0x102>
    wait();
     cdf:	e8 0c 2c 00 00       	call   38f0 <wait>
  else 
    exit();

  printf(1, "linkunlink ok\n");
     ce4:	c7 44 24 04 6b 40 00 	movl   $0x406b,0x4(%esp)
     ceb:	00 
     cec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cf3:	e8 38 2d 00 00       	call   3a30 <printf>
}
     cf8:	83 c4 2c             	add    $0x2c,%esp
     cfb:	5b                   	pop    %ebx
     cfc:	5e                   	pop    %esi
     cfd:	5f                   	pop    %edi
     cfe:	5d                   	pop    %ebp
     cff:	c3                   	ret    
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
      close(open("x", O_RDWR | O_CREATE));
    } else if((x % 3) == 1){
      link("cat", "x");
     d00:	c7 44 24 04 4e 49 00 	movl   $0x494e,0x4(%esp)
     d07:	00 
     d08:	c7 04 24 67 40 00 00 	movl   $0x4067,(%esp)
     d0f:	e8 34 2c 00 00       	call   3948 <link>
     d14:	e9 78 ff ff ff       	jmp    c91 <linkunlink+0x61>
  printf(1, "linkunlink test\n");

  unlink("x");
  pid = fork();
  if(pid < 0){
    printf(1, "fork failed\n");
     d19:	c7 44 24 04 0a 3f 00 	movl   $0x3f0a,0x4(%esp)
     d20:	00 
     d21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d28:	e8 03 2d 00 00       	call   3a30 <printf>
    exit();
     d2d:	e8 b6 2b 00 00       	call   38e8 <exit>
  }

  if(pid)
    wait();
  else 
    exit();
     d32:	e8 b1 2b 00 00       	call   38e8 <exit>
     d37:	89 f6                	mov    %esi,%esi
     d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d40 <sbrktest>:
  printf(1, "fork test OK\n");
}

void
sbrktest(void)
{
     d40:	55                   	push   %ebp
     d41:	89 e5                	mov    %esp,%ebp
     d43:	57                   	push   %edi
     d44:	56                   	push   %esi

  printf(stdout, "sbrk test\n");
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
     d45:	31 f6                	xor    %esi,%esi
  printf(1, "fork test OK\n");
}

void
sbrktest(void)
{
     d47:	53                   	push   %ebx
     d48:	83 ec 7c             	sub    $0x7c,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
     d4b:	a1 14 54 00 00       	mov    0x5414,%eax
     d50:	c7 44 24 04 7a 40 00 	movl   $0x407a,0x4(%esp)
     d57:	00 
     d58:	89 04 24             	mov    %eax,(%esp)
     d5b:	e8 d0 2c 00 00       	call   3a30 <printf>
  oldbrk = sbrk(0);
     d60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     d67:	e8 04 2c 00 00       	call   3970 <sbrk>

  // can one sbrk() less than a page?
  a = sbrk(0);
     d6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
  oldbrk = sbrk(0);
     d73:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
     d76:	e8 f5 2b 00 00       	call   3970 <sbrk>
     d7b:	89 c3                	mov    %eax,%ebx
     d7d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;
  for(i = 0; i < 5000; i++){ 
    b = sbrk(1);
     d80:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d87:	e8 e4 2b 00 00       	call   3970 <sbrk>
    if(b != a){
     d8c:	39 c3                	cmp    %eax,%ebx
     d8e:	0f 85 82 02 00 00    	jne    1016 <sbrktest+0x2d6>
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
     d94:	83 c6 01             	add    $0x1,%esi
    b = sbrk(1);
    if(b != a){
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
      exit();
    }
    *b = 1;
     d97:	c6 03 01             	movb   $0x1,(%ebx)
    a = b + 1;
     d9a:	83 c3 01             	add    $0x1,%ebx
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
     d9d:	81 fe 88 13 00 00    	cmp    $0x1388,%esi
     da3:	75 db                	jne    d80 <sbrktest+0x40>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
     da5:	e8 36 2b 00 00       	call   38e0 <fork>
  if(pid < 0){
     daa:	85 c0                	test   %eax,%eax
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
     dac:	89 c6                	mov    %eax,%esi
  if(pid < 0){
     dae:	0f 88 d0 03 00 00    	js     1184 <sbrktest+0x444>
    printf(stdout, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
     db4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c = sbrk(1);
  if(c != a + 1){
     dbb:	83 c3 01             	add    $0x1,%ebx
  pid = fork();
  if(pid < 0){
    printf(stdout, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
     dbe:	e8 ad 2b 00 00       	call   3970 <sbrk>
  c = sbrk(1);
     dc3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     dca:	e8 a1 2b 00 00       	call   3970 <sbrk>
  if(c != a + 1){
     dcf:	39 d8                	cmp    %ebx,%eax
     dd1:	0f 85 93 03 00 00    	jne    116a <sbrktest+0x42a>
    printf(stdout, "sbrk test failed post-fork\n");
    exit();
  }
  if(pid == 0)
     dd7:	85 f6                	test   %esi,%esi
     dd9:	0f 84 86 03 00 00    	je     1165 <sbrktest+0x425>
     ddf:	90                   	nop
    exit();
  wait();
     de0:	e8 0b 2b 00 00       	call   38f0 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
     de5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     dec:	e8 7f 2b 00 00       	call   3970 <sbrk>
     df1:	89 c3                	mov    %eax,%ebx
  amt = (BIG) - (uint)a;
  p = sbrk(amt);
     df3:	b8 00 00 40 06       	mov    $0x6400000,%eax
     df8:	29 d8                	sub    %ebx,%eax
     dfa:	89 04 24             	mov    %eax,(%esp)
     dfd:	e8 6e 2b 00 00       	call   3970 <sbrk>
  if (p != a) { 
     e02:	39 c3                	cmp    %eax,%ebx
     e04:	0f 85 46 03 00 00    	jne    1150 <sbrktest+0x410>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    exit();
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
     e0a:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff

  // can one de-allocate?
  a = sbrk(0);
     e11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e18:	e8 53 2b 00 00       	call   3970 <sbrk>
  c = sbrk(-4096);
     e1d:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;

  // can one de-allocate?
  a = sbrk(0);
     e24:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
     e26:	e8 45 2b 00 00       	call   3970 <sbrk>
  if(c == (char*)0xffffffff){
     e2b:	83 f8 ff             	cmp    $0xffffffff,%eax
     e2e:	0f 84 02 03 00 00    	je     1136 <sbrktest+0x3f6>
    printf(stdout, "sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
     e34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e3b:	e8 30 2b 00 00       	call   3970 <sbrk>
  if(c != a - 4096){
     e40:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
     e46:	39 d0                	cmp    %edx,%eax
     e48:	0f 85 c6 02 00 00    	jne    1114 <sbrktest+0x3d4>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
     e4e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e55:	e8 16 2b 00 00       	call   3970 <sbrk>
  c = sbrk(4096);
     e5a:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
     e61:	89 c3                	mov    %eax,%ebx
  c = sbrk(4096);
     e63:	e8 08 2b 00 00       	call   3970 <sbrk>
  if(c != a || sbrk(0) != a + 4096){
     e68:	39 c3                	cmp    %eax,%ebx
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
  c = sbrk(4096);
     e6a:	89 c6                	mov    %eax,%esi
  if(c != a || sbrk(0) != a + 4096){
     e6c:	0f 85 80 02 00 00    	jne    10f2 <sbrktest+0x3b2>
     e72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e79:	e8 f2 2a 00 00       	call   3970 <sbrk>
     e7e:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
     e84:	39 d0                	cmp    %edx,%eax
     e86:	0f 85 66 02 00 00    	jne    10f2 <sbrktest+0x3b2>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
     e8c:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
     e93:	0f 84 3f 02 00 00    	je     10d8 <sbrktest+0x398>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
     e99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  c = sbrk(-(sbrk(0) - oldbrk));
  if(c != a){
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
     ea0:	bb 00 00 00 80       	mov    $0x80000000,%ebx
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
     ea5:	e8 c6 2a 00 00       	call   3970 <sbrk>
  c = sbrk(-(sbrk(0) - oldbrk));
     eaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
     eb1:	89 c6                	mov    %eax,%esi
  c = sbrk(-(sbrk(0) - oldbrk));
     eb3:	e8 b8 2a 00 00       	call   3970 <sbrk>
     eb8:	8b 55 a4             	mov    -0x5c(%ebp),%edx
     ebb:	29 c2                	sub    %eax,%edx
     ebd:	89 14 24             	mov    %edx,(%esp)
     ec0:	e8 ab 2a 00 00       	call   3970 <sbrk>
  if(c != a){
     ec5:	39 c6                	cmp    %eax,%esi
     ec7:	0f 85 e9 01 00 00    	jne    10b6 <sbrktest+0x376>
     ecd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    ppid = getpid();
     ed0:	e8 93 2a 00 00       	call   3968 <getpid>
     ed5:	89 c6                	mov    %eax,%esi
    pid = fork();
     ed7:	e8 04 2a 00 00       	call   38e0 <fork>
    if(pid < 0){
     edc:	83 f8 00             	cmp    $0x0,%eax
     edf:	0f 8c b7 01 00 00    	jl     109c <sbrktest+0x35c>
      printf(stdout, "fork failed\n");
      exit();
    }
    if(pid == 0){
     ee5:	0f 84 84 01 00 00    	je     106f <sbrktest+0x32f>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     eeb:	81 c3 50 c3 00 00    	add    $0xc350,%ebx
    if(pid == 0){
      printf(stdout, "oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit();
    }
    wait();
     ef1:	e8 fa 29 00 00       	call   38f0 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     ef6:	81 fb 80 84 1e 80    	cmp    $0x801e8480,%ebx
     efc:	75 d2                	jne    ed0 <sbrktest+0x190>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
     efe:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f01:	89 04 24             	mov    %eax,(%esp)
     f04:	e8 ef 29 00 00       	call   38f8 <pipe>
     f09:	85 c0                	test   %eax,%eax
     f0b:	0f 85 45 01 00 00    	jne    1056 <sbrktest+0x316>
    printf(1, "pipe() failed\n");
    exit();
     f11:	31 db                	xor    %ebx,%ebx
     f13:	8d 7d b4             	lea    -0x4c(%ebp),%edi
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
     f16:	e8 c5 29 00 00       	call   38e0 <fork>
     f1b:	85 c0                	test   %eax,%eax
     f1d:	89 c6                	mov    %eax,%esi
     f1f:	0f 84 a7 00 00 00    	je     fcc <sbrktest+0x28c>
      sbrk(BIG - (uint)sbrk(0));
      write(fds[1], "x", 1);
      // sit around until killed
      for(;;) sleep(1000);
    }
    if(pids[i] != -1)
     f25:	83 f8 ff             	cmp    $0xffffffff,%eax
     f28:	74 1a                	je     f44 <sbrktest+0x204>
      read(fds[0], &scratch, 1);
     f2a:	8d 45 e7             	lea    -0x19(%ebp),%eax
     f2d:	89 44 24 04          	mov    %eax,0x4(%esp)
     f31:	8b 45 dc             	mov    -0x24(%ebp),%eax
     f34:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     f3b:	00 
     f3c:	89 04 24             	mov    %eax,(%esp)
     f3f:	e8 bc 29 00 00       	call   3900 <read>
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
     f44:	89 34 9f             	mov    %esi,(%edi,%ebx,4)
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
     f47:	83 c3 01             	add    $0x1,%ebx
     f4a:	83 fb 0a             	cmp    $0xa,%ebx
     f4d:	75 c7                	jne    f16 <sbrktest+0x1d6>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
     f4f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     f56:	30 db                	xor    %bl,%bl
     f58:	e8 13 2a 00 00       	call   3970 <sbrk>
     f5d:	89 c6                	mov    %eax,%esi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
     f5f:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
     f62:	83 f8 ff             	cmp    $0xffffffff,%eax
     f65:	74 0d                	je     f74 <sbrktest+0x234>
      continue;
    kill(pids[i]);
     f67:	89 04 24             	mov    %eax,(%esp)
     f6a:	e8 a9 29 00 00       	call   3918 <kill>
    wait();
     f6f:	e8 7c 29 00 00       	call   38f0 <wait>
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
     f74:	83 c3 01             	add    $0x1,%ebx
     f77:	83 fb 0a             	cmp    $0xa,%ebx
     f7a:	75 e3                	jne    f5f <sbrktest+0x21f>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
     f7c:	83 fe ff             	cmp    $0xffffffff,%esi
     f7f:	0f 84 b7 00 00 00    	je     103c <sbrktest+0x2fc>
    printf(stdout, "failed sbrk leaked memory\n");
    exit();
  }

  if(sbrk(0) > oldbrk)
     f85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     f8c:	e8 df 29 00 00       	call   3970 <sbrk>
     f91:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
     f94:	73 19                	jae    faf <sbrktest+0x26f>
    sbrk(-(sbrk(0) - oldbrk));
     f96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     f9d:	e8 ce 29 00 00       	call   3970 <sbrk>
     fa2:	8b 55 a4             	mov    -0x5c(%ebp),%edx
     fa5:	29 c2                	sub    %eax,%edx
     fa7:	89 14 24             	mov    %edx,(%esp)
     faa:	e8 c1 29 00 00       	call   3970 <sbrk>

  printf(stdout, "sbrk test OK\n");
     faf:	a1 14 54 00 00       	mov    0x5414,%eax
     fb4:	c7 44 24 04 31 41 00 	movl   $0x4131,0x4(%esp)
     fbb:	00 
     fbc:	89 04 24             	mov    %eax,(%esp)
     fbf:	e8 6c 2a 00 00       	call   3a30 <printf>
}
     fc4:	83 c4 7c             	add    $0x7c,%esp
     fc7:	5b                   	pop    %ebx
     fc8:	5e                   	pop    %esi
     fc9:	5f                   	pop    %edi
     fca:	5d                   	pop    %ebp
     fcb:	c3                   	ret    
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
     fcc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     fd3:	e8 98 29 00 00       	call   3970 <sbrk>
     fd8:	ba 00 00 40 06       	mov    $0x6400000,%edx
     fdd:	29 c2                	sub    %eax,%edx
     fdf:	89 14 24             	mov    %edx,(%esp)
     fe2:	e8 89 29 00 00       	call   3970 <sbrk>
      write(fds[1], "x", 1);
     fe7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     fea:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     ff1:	00 
     ff2:	c7 44 24 04 4e 49 00 	movl   $0x494e,0x4(%esp)
     ff9:	00 
     ffa:	89 04 24             	mov    %eax,(%esp)
     ffd:	e8 06 29 00 00       	call   3908 <write>
    1002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      // sit around until killed
      for(;;) sleep(1000);
    1008:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    100f:	e8 64 29 00 00       	call   3978 <sleep>
    1014:	eb f2                	jmp    1008 <sbrktest+0x2c8>
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    b = sbrk(1);
    if(b != a){
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    1016:	89 44 24 10          	mov    %eax,0x10(%esp)
    101a:	a1 14 54 00 00       	mov    0x5414,%eax
    101f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    1023:	89 74 24 08          	mov    %esi,0x8(%esp)
    1027:	c7 44 24 04 85 40 00 	movl   $0x4085,0x4(%esp)
    102e:	00 
    102f:	89 04 24             	mov    %eax,(%esp)
    1032:	e8 f9 29 00 00       	call   3a30 <printf>
      exit();
    1037:	e8 ac 28 00 00       	call   38e8 <exit>
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    printf(stdout, "failed sbrk leaked memory\n");
    103c:	a1 14 54 00 00       	mov    0x5414,%eax
    1041:	c7 44 24 04 16 41 00 	movl   $0x4116,0x4(%esp)
    1048:	00 
    1049:	89 04 24             	mov    %eax,(%esp)
    104c:	e8 df 29 00 00       	call   3a30 <printf>
    exit();
    1051:	e8 92 28 00 00       	call   38e8 <exit>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    1056:	c7 44 24 04 07 41 00 	movl   $0x4107,0x4(%esp)
    105d:	00 
    105e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1065:	e8 c6 29 00 00       	call   3a30 <printf>
    exit();
    106a:	e8 79 28 00 00       	call   38e8 <exit>
    if(pid < 0){
      printf(stdout, "fork failed\n");
      exit();
    }
    if(pid == 0){
      printf(stdout, "oops could read %x = %x\n", a, *a);
    106f:	0f be 03             	movsbl (%ebx),%eax
    1072:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1076:	c7 44 24 04 ee 40 00 	movl   $0x40ee,0x4(%esp)
    107d:	00 
    107e:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1082:	a1 14 54 00 00       	mov    0x5414,%eax
    1087:	89 04 24             	mov    %eax,(%esp)
    108a:	e8 a1 29 00 00       	call   3a30 <printf>
      kill(ppid);
    108f:	89 34 24             	mov    %esi,(%esp)
    1092:	e8 81 28 00 00       	call   3918 <kill>
      exit();
    1097:	e8 4c 28 00 00       	call   38e8 <exit>
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    ppid = getpid();
    pid = fork();
    if(pid < 0){
      printf(stdout, "fork failed\n");
    109c:	a1 14 54 00 00       	mov    0x5414,%eax
    10a1:	c7 44 24 04 0a 3f 00 	movl   $0x3f0a,0x4(%esp)
    10a8:	00 
    10a9:	89 04 24             	mov    %eax,(%esp)
    10ac:	e8 7f 29 00 00       	call   3a30 <printf>
      exit();
    10b1:	e8 32 28 00 00       	call   38e8 <exit>
  }

  a = sbrk(0);
  c = sbrk(-(sbrk(0) - oldbrk));
  if(c != a){
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    10b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
    10ba:	a1 14 54 00 00       	mov    0x5414,%eax
    10bf:	89 74 24 08          	mov    %esi,0x8(%esp)
    10c3:	c7 44 24 04 24 4f 00 	movl   $0x4f24,0x4(%esp)
    10ca:	00 
    10cb:	89 04 24             	mov    %eax,(%esp)
    10ce:	e8 5d 29 00 00       	call   3a30 <printf>
    exit();
    10d3:	e8 10 28 00 00       	call   38e8 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    10d8:	a1 14 54 00 00       	mov    0x5414,%eax
    10dd:	c7 44 24 04 f4 4e 00 	movl   $0x4ef4,0x4(%esp)
    10e4:	00 
    10e5:	89 04 24             	mov    %eax,(%esp)
    10e8:	e8 43 29 00 00       	call   3a30 <printf>
    exit();
    10ed:	e8 f6 27 00 00       	call   38e8 <exit>

  // can one re-allocate that page?
  a = sbrk(0);
  c = sbrk(4096);
  if(c != a || sbrk(0) != a + 4096){
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    10f2:	a1 14 54 00 00       	mov    0x5414,%eax
    10f7:	89 74 24 0c          	mov    %esi,0xc(%esp)
    10fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    10ff:	c7 44 24 04 cc 4e 00 	movl   $0x4ecc,0x4(%esp)
    1106:	00 
    1107:	89 04 24             	mov    %eax,(%esp)
    110a:	e8 21 29 00 00       	call   3a30 <printf>
    exit();
    110f:	e8 d4 27 00 00       	call   38e8 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
  if(c != a - 4096){
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    1114:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1118:	a1 14 54 00 00       	mov    0x5414,%eax
    111d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1121:	c7 44 24 04 94 4e 00 	movl   $0x4e94,0x4(%esp)
    1128:	00 
    1129:	89 04 24             	mov    %eax,(%esp)
    112c:	e8 ff 28 00 00       	call   3a30 <printf>
    exit();
    1131:	e8 b2 27 00 00       	call   38e8 <exit>

  // can one de-allocate?
  a = sbrk(0);
  c = sbrk(-4096);
  if(c == (char*)0xffffffff){
    printf(stdout, "sbrk could not deallocate\n");
    1136:	a1 14 54 00 00       	mov    0x5414,%eax
    113b:	c7 44 24 04 d3 40 00 	movl   $0x40d3,0x4(%esp)
    1142:	00 
    1143:	89 04 24             	mov    %eax,(%esp)
    1146:	e8 e5 28 00 00       	call   3a30 <printf>
    exit();
    114b:	e8 98 27 00 00       	call   38e8 <exit>
#define BIG (100*1024*1024)
  a = sbrk(0);
  amt = (BIG) - (uint)a;
  p = sbrk(amt);
  if (p != a) { 
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    1150:	a1 14 54 00 00       	mov    0x5414,%eax
    1155:	c7 44 24 04 54 4e 00 	movl   $0x4e54,0x4(%esp)
    115c:	00 
    115d:	89 04 24             	mov    %eax,(%esp)
    1160:	e8 cb 28 00 00       	call   3a30 <printf>
    exit();
    1165:	e8 7e 27 00 00       	call   38e8 <exit>
    exit();
  }
  c = sbrk(1);
  c = sbrk(1);
  if(c != a + 1){
    printf(stdout, "sbrk test failed post-fork\n");
    116a:	a1 14 54 00 00       	mov    0x5414,%eax
    116f:	c7 44 24 04 b7 40 00 	movl   $0x40b7,0x4(%esp)
    1176:	00 
    1177:	89 04 24             	mov    %eax,(%esp)
    117a:	e8 b1 28 00 00       	call   3a30 <printf>
    exit();
    117f:	e8 64 27 00 00       	call   38e8 <exit>
    *b = 1;
    a = b + 1;
  }
  pid = fork();
  if(pid < 0){
    printf(stdout, "sbrk test fork failed\n");
    1184:	a1 14 54 00 00       	mov    0x5414,%eax
    1189:	c7 44 24 04 a0 40 00 	movl   $0x40a0,0x4(%esp)
    1190:	00 
    1191:	89 04 24             	mov    %eax,(%esp)
    1194:	e8 97 28 00 00       	call   3a30 <printf>
    exit();
    1199:	e8 4a 27 00 00       	call   38e8 <exit>
    119e:	66 90                	xchg   %ax,%ax

000011a0 <linktest>:
  printf(1, "unlinkread ok\n");
}

void
linktest(void)
{
    11a0:	55                   	push   %ebp
    11a1:	89 e5                	mov    %esp,%ebp
    11a3:	53                   	push   %ebx
    11a4:	83 ec 14             	sub    $0x14,%esp
  int fd;

  printf(1, "linktest\n");
    11a7:	c7 44 24 04 3f 41 00 	movl   $0x413f,0x4(%esp)
    11ae:	00 
    11af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11b6:	e8 75 28 00 00       	call   3a30 <printf>

  unlink("lf1");
    11bb:	c7 04 24 49 41 00 00 	movl   $0x4149,(%esp)
    11c2:	e8 71 27 00 00       	call   3938 <unlink>
  unlink("lf2");
    11c7:	c7 04 24 4d 41 00 00 	movl   $0x414d,(%esp)
    11ce:	e8 65 27 00 00       	call   3938 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    11d3:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    11da:	00 
    11db:	c7 04 24 49 41 00 00 	movl   $0x4149,(%esp)
    11e2:	e8 41 27 00 00       	call   3928 <open>
  if(fd < 0){
    11e7:	85 c0                	test   %eax,%eax
  printf(1, "linktest\n");

  unlink("lf1");
  unlink("lf2");

  fd = open("lf1", O_CREATE|O_RDWR);
    11e9:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    11eb:	0f 88 26 01 00 00    	js     1317 <linktest+0x177>
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    11f1:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    11f8:	00 
    11f9:	c7 44 24 04 64 41 00 	movl   $0x4164,0x4(%esp)
    1200:	00 
    1201:	89 04 24             	mov    %eax,(%esp)
    1204:	e8 ff 26 00 00       	call   3908 <write>
    1209:	83 f8 05             	cmp    $0x5,%eax
    120c:	0f 85 cd 01 00 00    	jne    13df <linktest+0x23f>
    printf(1, "write lf1 failed\n");
    exit();
  }
  close(fd);
    1212:	89 1c 24             	mov    %ebx,(%esp)
    1215:	e8 f6 26 00 00       	call   3910 <close>

  if(link("lf1", "lf2") < 0){
    121a:	c7 44 24 04 4d 41 00 	movl   $0x414d,0x4(%esp)
    1221:	00 
    1222:	c7 04 24 49 41 00 00 	movl   $0x4149,(%esp)
    1229:	e8 1a 27 00 00       	call   3948 <link>
    122e:	85 c0                	test   %eax,%eax
    1230:	0f 88 90 01 00 00    	js     13c6 <linktest+0x226>
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    1236:	c7 04 24 49 41 00 00 	movl   $0x4149,(%esp)
    123d:	e8 f6 26 00 00       	call   3938 <unlink>

  if(open("lf1", 0) >= 0){
    1242:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1249:	00 
    124a:	c7 04 24 49 41 00 00 	movl   $0x4149,(%esp)
    1251:	e8 d2 26 00 00       	call   3928 <open>
    1256:	85 c0                	test   %eax,%eax
    1258:	0f 89 4f 01 00 00    	jns    13ad <linktest+0x20d>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    125e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1265:	00 
    1266:	c7 04 24 4d 41 00 00 	movl   $0x414d,(%esp)
    126d:	e8 b6 26 00 00       	call   3928 <open>
  if(fd < 0){
    1272:	85 c0                	test   %eax,%eax
  if(open("lf1", 0) >= 0){
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1274:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1276:	0f 88 18 01 00 00    	js     1394 <linktest+0x1f4>
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    127c:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1283:	00 
    1284:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    128b:	00 
    128c:	89 04 24             	mov    %eax,(%esp)
    128f:	e8 6c 26 00 00       	call   3900 <read>
    1294:	83 f8 05             	cmp    $0x5,%eax
    1297:	0f 85 de 00 00 00    	jne    137b <linktest+0x1db>
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);
    129d:	89 1c 24             	mov    %ebx,(%esp)
    12a0:	e8 6b 26 00 00       	call   3910 <close>

  if(link("lf2", "lf2") >= 0){
    12a5:	c7 44 24 04 4d 41 00 	movl   $0x414d,0x4(%esp)
    12ac:	00 
    12ad:	c7 04 24 4d 41 00 00 	movl   $0x414d,(%esp)
    12b4:	e8 8f 26 00 00       	call   3948 <link>
    12b9:	85 c0                	test   %eax,%eax
    12bb:	0f 89 a1 00 00 00    	jns    1362 <linktest+0x1c2>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    12c1:	c7 04 24 4d 41 00 00 	movl   $0x414d,(%esp)
    12c8:	e8 6b 26 00 00       	call   3938 <unlink>
  if(link("lf2", "lf1") >= 0){
    12cd:	c7 44 24 04 49 41 00 	movl   $0x4149,0x4(%esp)
    12d4:	00 
    12d5:	c7 04 24 4d 41 00 00 	movl   $0x414d,(%esp)
    12dc:	e8 67 26 00 00       	call   3948 <link>
    12e1:	85 c0                	test   %eax,%eax
    12e3:	79 64                	jns    1349 <linktest+0x1a9>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    12e5:	c7 44 24 04 49 41 00 	movl   $0x4149,0x4(%esp)
    12ec:	00 
    12ed:	c7 04 24 6b 48 00 00 	movl   $0x486b,(%esp)
    12f4:	e8 4f 26 00 00       	call   3948 <link>
    12f9:	85 c0                	test   %eax,%eax
    12fb:	79 33                	jns    1330 <linktest+0x190>
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
    12fd:	c7 44 24 04 ed 41 00 	movl   $0x41ed,0x4(%esp)
    1304:	00 
    1305:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    130c:	e8 1f 27 00 00       	call   3a30 <printf>
}
    1311:	83 c4 14             	add    $0x14,%esp
    1314:	5b                   	pop    %ebx
    1315:	5d                   	pop    %ebp
    1316:	c3                   	ret    
  unlink("lf1");
  unlink("lf2");

  fd = open("lf1", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "create lf1 failed\n");
    1317:	c7 44 24 04 51 41 00 	movl   $0x4151,0x4(%esp)
    131e:	00 
    131f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1326:	e8 05 27 00 00       	call   3a30 <printf>
    exit();
    132b:	e8 b8 25 00 00       	call   38e8 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    printf(1, "link . lf1 succeeded! oops\n");
    1330:	c7 44 24 04 d1 41 00 	movl   $0x41d1,0x4(%esp)
    1337:	00 
    1338:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    133f:	e8 ec 26 00 00       	call   3a30 <printf>
    exit();
    1344:	e8 9f 25 00 00       	call   38e8 <exit>
    exit();
  }

  unlink("lf2");
  if(link("lf2", "lf1") >= 0){
    printf(1, "link non-existant succeeded! oops\n");
    1349:	c7 44 24 04 70 4f 00 	movl   $0x4f70,0x4(%esp)
    1350:	00 
    1351:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1358:	e8 d3 26 00 00       	call   3a30 <printf>
    exit();
    135d:	e8 86 25 00 00       	call   38e8 <exit>
    exit();
  }
  close(fd);

  if(link("lf2", "lf2") >= 0){
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1362:	c7 44 24 04 b3 41 00 	movl   $0x41b3,0x4(%esp)
    1369:	00 
    136a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1371:	e8 ba 26 00 00       	call   3a30 <printf>
    exit();
    1376:	e8 6d 25 00 00       	call   38e8 <exit>
  if(fd < 0){
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "read lf2 failed\n");
    137b:	c7 44 24 04 a2 41 00 	movl   $0x41a2,0x4(%esp)
    1382:	00 
    1383:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    138a:	e8 a1 26 00 00       	call   3a30 <printf>
    exit();
    138f:	e8 54 25 00 00       	call   38e8 <exit>
    exit();
  }

  fd = open("lf2", 0);
  if(fd < 0){
    printf(1, "open lf2 failed\n");
    1394:	c7 44 24 04 91 41 00 	movl   $0x4191,0x4(%esp)
    139b:	00 
    139c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13a3:	e8 88 26 00 00       	call   3a30 <printf>
    exit();
    13a8:	e8 3b 25 00 00       	call   38e8 <exit>
    exit();
  }
  unlink("lf1");

  if(open("lf1", 0) >= 0){
    printf(1, "unlinked lf1 but it is still there!\n");
    13ad:	c7 44 24 04 48 4f 00 	movl   $0x4f48,0x4(%esp)
    13b4:	00 
    13b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13bc:	e8 6f 26 00 00       	call   3a30 <printf>
    exit();
    13c1:	e8 22 25 00 00       	call   38e8 <exit>
    exit();
  }
  close(fd);

  if(link("lf1", "lf2") < 0){
    printf(1, "link lf1 lf2 failed\n");
    13c6:	c7 44 24 04 7c 41 00 	movl   $0x417c,0x4(%esp)
    13cd:	00 
    13ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13d5:	e8 56 26 00 00       	call   3a30 <printf>
    exit();
    13da:	e8 09 25 00 00       	call   38e8 <exit>
  if(fd < 0){
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    printf(1, "write lf1 failed\n");
    13df:	c7 44 24 04 6a 41 00 	movl   $0x416a,0x4(%esp)
    13e6:	00 
    13e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13ee:	e8 3d 26 00 00       	call   3a30 <printf>
    exit();
    13f3:	e8 f0 24 00 00       	call   38e8 <exit>
    13f8:	90                   	nop
    13f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001400 <unlinkread>:
}

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1400:	55                   	push   %ebp
    1401:	89 e5                	mov    %esp,%ebp
    1403:	56                   	push   %esi
    1404:	53                   	push   %ebx
    1405:	83 ec 10             	sub    $0x10,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1408:	c7 44 24 04 fa 41 00 	movl   $0x41fa,0x4(%esp)
    140f:	00 
    1410:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1417:	e8 14 26 00 00       	call   3a30 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    141c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1423:	00 
    1424:	c7 04 24 0b 42 00 00 	movl   $0x420b,(%esp)
    142b:	e8 f8 24 00 00       	call   3928 <open>
  if(fd < 0){
    1430:	85 c0                	test   %eax,%eax
unlinkread(void)
{
  int fd, fd1;

  printf(1, "unlinkread test\n");
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1432:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1434:	0f 88 fe 00 00 00    	js     1538 <unlinkread+0x138>
    printf(1, "create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", 5);
    143a:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1441:	00 
    1442:	c7 44 24 04 64 41 00 	movl   $0x4164,0x4(%esp)
    1449:	00 
    144a:	89 04 24             	mov    %eax,(%esp)
    144d:	e8 b6 24 00 00       	call   3908 <write>
  close(fd);
    1452:	89 1c 24             	mov    %ebx,(%esp)
    1455:	e8 b6 24 00 00       	call   3910 <close>

  fd = open("unlinkread", O_RDWR);
    145a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1461:	00 
    1462:	c7 04 24 0b 42 00 00 	movl   $0x420b,(%esp)
    1469:	e8 ba 24 00 00       	call   3928 <open>
  if(fd < 0){
    146e:	85 c0                	test   %eax,%eax
    exit();
  }
  write(fd, "hello", 5);
  close(fd);

  fd = open("unlinkread", O_RDWR);
    1470:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1472:	0f 88 3d 01 00 00    	js     15b5 <unlinkread+0x1b5>
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    1478:	c7 04 24 0b 42 00 00 	movl   $0x420b,(%esp)
    147f:	e8 b4 24 00 00       	call   3938 <unlink>
    1484:	85 c0                	test   %eax,%eax
    1486:	0f 85 10 01 00 00    	jne    159c <unlinkread+0x19c>
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    148c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1493:	00 
    1494:	c7 04 24 0b 42 00 00 	movl   $0x420b,(%esp)
    149b:	e8 88 24 00 00       	call   3928 <open>
  write(fd1, "yyy", 3);
    14a0:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    14a7:	00 
    14a8:	c7 44 24 04 62 42 00 	movl   $0x4262,0x4(%esp)
    14af:	00 
  if(unlink("unlinkread") != 0){
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    14b0:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    14b2:	89 04 24             	mov    %eax,(%esp)
    14b5:	e8 4e 24 00 00       	call   3908 <write>
  close(fd1);
    14ba:	89 34 24             	mov    %esi,(%esp)
    14bd:	e8 4e 24 00 00       	call   3910 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    14c2:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    14c9:	00 
    14ca:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    14d1:	00 
    14d2:	89 1c 24             	mov    %ebx,(%esp)
    14d5:	e8 26 24 00 00       	call   3900 <read>
    14da:	83 f8 05             	cmp    $0x5,%eax
    14dd:	0f 85 a0 00 00 00    	jne    1583 <unlinkread+0x183>
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    14e3:	80 3d e0 7b 00 00 68 	cmpb   $0x68,0x7be0
    14ea:	75 7e                	jne    156a <unlinkread+0x16a>
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    14ec:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14f3:	00 
    14f4:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    14fb:	00 
    14fc:	89 1c 24             	mov    %ebx,(%esp)
    14ff:	e8 04 24 00 00       	call   3908 <write>
    1504:	83 f8 0a             	cmp    $0xa,%eax
    1507:	75 48                	jne    1551 <unlinkread+0x151>
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
    1509:	89 1c 24             	mov    %ebx,(%esp)
    150c:	e8 ff 23 00 00       	call   3910 <close>
  unlink("unlinkread");
    1511:	c7 04 24 0b 42 00 00 	movl   $0x420b,(%esp)
    1518:	e8 1b 24 00 00       	call   3938 <unlink>
  printf(1, "unlinkread ok\n");
    151d:	c7 44 24 04 ad 42 00 	movl   $0x42ad,0x4(%esp)
    1524:	00 
    1525:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    152c:	e8 ff 24 00 00       	call   3a30 <printf>
}
    1531:	83 c4 10             	add    $0x10,%esp
    1534:	5b                   	pop    %ebx
    1535:	5e                   	pop    %esi
    1536:	5d                   	pop    %ebp
    1537:	c3                   	ret    
  int fd, fd1;

  printf(1, "unlinkread test\n");
  fd = open("unlinkread", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create unlinkread failed\n");
    1538:	c7 44 24 04 16 42 00 	movl   $0x4216,0x4(%esp)
    153f:	00 
    1540:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1547:	e8 e4 24 00 00       	call   3a30 <printf>
    exit();
    154c:	e8 97 23 00 00       	call   38e8 <exit>
  if(buf[0] != 'h'){
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    printf(1, "unlinkread write failed\n");
    1551:	c7 44 24 04 94 42 00 	movl   $0x4294,0x4(%esp)
    1558:	00 
    1559:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1560:	e8 cb 24 00 00       	call   3a30 <printf>
    exit();
    1565:	e8 7e 23 00 00       	call   38e8 <exit>
  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    printf(1, "unlinkread wrong data\n");
    156a:	c7 44 24 04 7d 42 00 	movl   $0x427d,0x4(%esp)
    1571:	00 
    1572:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1579:	e8 b2 24 00 00       	call   3a30 <printf>
    exit();
    157e:	e8 65 23 00 00       	call   38e8 <exit>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
  write(fd1, "yyy", 3);
  close(fd1);

  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "unlinkread read failed");
    1583:	c7 44 24 04 66 42 00 	movl   $0x4266,0x4(%esp)
    158a:	00 
    158b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1592:	e8 99 24 00 00       	call   3a30 <printf>
    exit();
    1597:	e8 4c 23 00 00       	call   38e8 <exit>
  if(fd < 0){
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    printf(1, "unlink unlinkread failed\n");
    159c:	c7 44 24 04 48 42 00 	movl   $0x4248,0x4(%esp)
    15a3:	00 
    15a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15ab:	e8 80 24 00 00       	call   3a30 <printf>
    exit();
    15b0:	e8 33 23 00 00       	call   38e8 <exit>
  write(fd, "hello", 5);
  close(fd);

  fd = open("unlinkread", O_RDWR);
  if(fd < 0){
    printf(1, "open unlinkread failed\n");
    15b5:	c7 44 24 04 30 42 00 	movl   $0x4230,0x4(%esp)
    15bc:	00 
    15bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15c4:	e8 67 24 00 00       	call   3a30 <printf>
    exit();
    15c9:	e8 1a 23 00 00       	call   38e8 <exit>
    15ce:	66 90                	xchg   %ax,%ax

000015d0 <preempt>:
}

// meant to be run w/ at most two CPUs
void
preempt(void)
{
    15d0:	55                   	push   %ebp
    15d1:	89 e5                	mov    %esp,%ebp
    15d3:	57                   	push   %edi
    15d4:	56                   	push   %esi
    15d5:	53                   	push   %ebx
    15d6:	83 ec 2c             	sub    $0x2c,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
    15d9:	c7 44 24 04 bc 42 00 	movl   $0x42bc,0x4(%esp)
    15e0:	00 
    15e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15e8:	e8 43 24 00 00       	call   3a30 <printf>
  pid1 = fork();
    15ed:	e8 ee 22 00 00       	call   38e0 <fork>
  if(pid1 == 0)
    15f2:	85 c0                	test   %eax,%eax
{
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
  pid1 = fork();
    15f4:	89 c7                	mov    %eax,%edi
  if(pid1 == 0)
    15f6:	75 02                	jne    15fa <preempt+0x2a>
    15f8:	eb fe                	jmp    15f8 <preempt+0x28>
    15fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(;;)
      ;

  pid2 = fork();
    1600:	e8 db 22 00 00       	call   38e0 <fork>
  if(pid2 == 0)
    1605:	85 c0                	test   %eax,%eax
  pid1 = fork();
  if(pid1 == 0)
    for(;;)
      ;

  pid2 = fork();
    1607:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
    1609:	75 02                	jne    160d <preempt+0x3d>
    160b:	eb fe                	jmp    160b <preempt+0x3b>
    for(;;)
      ;

  pipe(pfds);
    160d:	8d 45 e0             	lea    -0x20(%ebp),%eax
    1610:	89 04 24             	mov    %eax,(%esp)
    1613:	e8 e0 22 00 00       	call   38f8 <pipe>
  pid3 = fork();
    1618:	e8 c3 22 00 00       	call   38e0 <fork>
  if(pid3 == 0){
    161d:	85 c0                	test   %eax,%eax
  if(pid2 == 0)
    for(;;)
      ;

  pipe(pfds);
  pid3 = fork();
    161f:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
    1621:	75 4c                	jne    166f <preempt+0x9f>
    close(pfds[0]);
    1623:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1626:	89 04 24             	mov    %eax,(%esp)
    1629:	e8 e2 22 00 00       	call   3910 <close>
    if(write(pfds[1], "x", 1) != 1)
    162e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1631:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1638:	00 
    1639:	c7 44 24 04 4e 49 00 	movl   $0x494e,0x4(%esp)
    1640:	00 
    1641:	89 04 24             	mov    %eax,(%esp)
    1644:	e8 bf 22 00 00       	call   3908 <write>
    1649:	83 f8 01             	cmp    $0x1,%eax
    164c:	74 14                	je     1662 <preempt+0x92>
      printf(1, "preempt write error");
    164e:	c7 44 24 04 c6 42 00 	movl   $0x42c6,0x4(%esp)
    1655:	00 
    1656:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    165d:	e8 ce 23 00 00       	call   3a30 <printf>
    close(pfds[1]);
    1662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1665:	89 04 24             	mov    %eax,(%esp)
    1668:	e8 a3 22 00 00       	call   3910 <close>
    166d:	eb fe                	jmp    166d <preempt+0x9d>
    for(;;)
      ;
  }

  close(pfds[1]);
    166f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1672:	89 04 24             	mov    %eax,(%esp)
    1675:	e8 96 22 00 00       	call   3910 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    167a:	8b 45 e0             	mov    -0x20(%ebp),%eax
    167d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1684:	00 
    1685:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    168c:	00 
    168d:	89 04 24             	mov    %eax,(%esp)
    1690:	e8 6b 22 00 00       	call   3900 <read>
    1695:	83 f8 01             	cmp    $0x1,%eax
    1698:	74 1c                	je     16b6 <preempt+0xe6>
    printf(1, "preempt read error");
    169a:	c7 44 24 04 da 42 00 	movl   $0x42da,0x4(%esp)
    16a1:	00 
    16a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16a9:	e8 82 23 00 00       	call   3a30 <printf>
  printf(1, "wait... ");
  wait();
  wait();
  wait();
  printf(1, "preempt ok\n");
}
    16ae:	83 c4 2c             	add    $0x2c,%esp
    16b1:	5b                   	pop    %ebx
    16b2:	5e                   	pop    %esi
    16b3:	5f                   	pop    %edi
    16b4:	5d                   	pop    %ebp
    16b5:	c3                   	ret    
  close(pfds[1]);
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    printf(1, "preempt read error");
    return;
  }
  close(pfds[0]);
    16b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
    16b9:	89 04 24             	mov    %eax,(%esp)
    16bc:	e8 4f 22 00 00       	call   3910 <close>
  printf(1, "kill... ");
    16c1:	c7 44 24 04 ed 42 00 	movl   $0x42ed,0x4(%esp)
    16c8:	00 
    16c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16d0:	e8 5b 23 00 00       	call   3a30 <printf>
  kill(pid1);
    16d5:	89 3c 24             	mov    %edi,(%esp)
    16d8:	e8 3b 22 00 00       	call   3918 <kill>
  kill(pid2);
    16dd:	89 34 24             	mov    %esi,(%esp)
    16e0:	e8 33 22 00 00       	call   3918 <kill>
  kill(pid3);
    16e5:	89 1c 24             	mov    %ebx,(%esp)
    16e8:	e8 2b 22 00 00       	call   3918 <kill>
  printf(1, "wait... ");
    16ed:	c7 44 24 04 f6 42 00 	movl   $0x42f6,0x4(%esp)
    16f4:	00 
    16f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16fc:	e8 2f 23 00 00       	call   3a30 <printf>
  wait();
    1701:	e8 ea 21 00 00       	call   38f0 <wait>
  wait();
    1706:	e8 e5 21 00 00       	call   38f0 <wait>
    170b:	90                   	nop
    170c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  wait();
    1710:	e8 db 21 00 00       	call   38f0 <wait>
  printf(1, "preempt ok\n");
    1715:	c7 44 24 04 ff 42 00 	movl   $0x42ff,0x4(%esp)
    171c:	00 
    171d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1724:	e8 07 23 00 00       	call   3a30 <printf>
    1729:	eb 83                	jmp    16ae <preempt+0xde>
    172b:	90                   	nop
    172c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001730 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
    1730:	55                   	push   %ebp
    1731:	89 e5                	mov    %esp,%ebp
    1733:	57                   	push   %edi
    1734:	56                   	push   %esi
    1735:	53                   	push   %ebx
    1736:	83 ec 2c             	sub    $0x2c,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    1739:	8d 45 e0             	lea    -0x20(%ebp),%eax
    173c:	89 04 24             	mov    %eax,(%esp)
    173f:	e8 b4 21 00 00       	call   38f8 <pipe>
    1744:	85 c0                	test   %eax,%eax
    1746:	0f 85 3b 01 00 00    	jne    1887 <pipe1+0x157>
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
    174c:	e8 8f 21 00 00       	call   38e0 <fork>
  seq = 0;
  if(pid == 0){
    1751:	83 f8 00             	cmp    $0x0,%eax
    1754:	0f 84 80 00 00 00    	je     17da <pipe1+0xaa>
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
    175a:	0f 8e 40 01 00 00    	jle    18a0 <pipe1+0x170>
    close(fds[1]);
    1760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1763:	31 ff                	xor    %edi,%edi
    1765:	be 01 00 00 00       	mov    $0x1,%esi
    176a:	31 db                	xor    %ebx,%ebx
    176c:	89 04 24             	mov    %eax,(%esp)
    176f:	e8 9c 21 00 00       	call   3910 <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
    1774:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1777:	89 74 24 08          	mov    %esi,0x8(%esp)
    177b:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    1782:	00 
    1783:	89 04 24             	mov    %eax,(%esp)
    1786:	e8 75 21 00 00       	call   3900 <read>
    178b:	85 c0                	test   %eax,%eax
    178d:	0f 8e a9 00 00 00    	jle    183c <pipe1+0x10c>
    1793:	31 d2                	xor    %edx,%edx
    1795:	8d 76 00             	lea    0x0(%esi),%esi
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1798:	38 9a e0 7b 00 00    	cmp    %bl,0x7be0(%edx)
    179e:	75 1e                	jne    17be <pipe1+0x8e>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
    17a0:	83 c2 01             	add    $0x1,%edx
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17a3:	83 c3 01             	add    $0x1,%ebx
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
    17a6:	39 d0                	cmp    %edx,%eax
    17a8:	7f ee                	jg     1798 <pipe1+0x68>
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
      cc = cc * 2;
    17aa:	01 f6                	add    %esi,%esi
      if(cc > sizeof(buf))
    17ac:	ba 00 20 00 00       	mov    $0x2000,%edx
    17b1:	81 fe 01 20 00 00    	cmp    $0x2001,%esi
    17b7:	0f 43 f2             	cmovae %edx,%esi
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
    17ba:	01 c7                	add    %eax,%edi
    17bc:	eb b6                	jmp    1774 <pipe1+0x44>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
    17be:	c7 44 24 04 19 43 00 	movl   $0x4319,0x4(%esp)
    17c5:	00 
    17c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17cd:	e8 5e 22 00 00       	call   3a30 <printf>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
}
    17d2:	83 c4 2c             	add    $0x2c,%esp
    17d5:	5b                   	pop    %ebx
    17d6:	5e                   	pop    %esi
    17d7:	5f                   	pop    %edi
    17d8:	5d                   	pop    %ebp
    17d9:	c3                   	ret    
    exit();
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    17da:	8b 45 e0             	mov    -0x20(%ebp),%eax
    17dd:	31 db                	xor    %ebx,%ebx
    17df:	89 04 24             	mov    %eax,(%esp)
    17e2:	e8 29 21 00 00       	call   3910 <close>
    for(n = 0; n < 5; n++){
    17e7:	31 c0                	xor    %eax,%eax
    17e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < 1033; i++)
        buf[i] = seq++;
    17f0:	8d 14 03             	lea    (%ebx,%eax,1),%edx
    17f3:	88 90 e0 7b 00 00    	mov    %dl,0x7be0(%eax)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
    17f9:	83 c0 01             	add    $0x1,%eax
    17fc:	3d 09 04 00 00       	cmp    $0x409,%eax
    1801:	75 ed                	jne    17f0 <pipe1+0xc0>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
    1803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
    1806:	81 c3 09 04 00 00    	add    $0x409,%ebx
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
    180c:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
    1813:	00 
    1814:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    181b:	00 
    181c:	89 04 24             	mov    %eax,(%esp)
    181f:	e8 e4 20 00 00       	call   3908 <write>
    1824:	3d 09 04 00 00       	cmp    $0x409,%eax
    1829:	0f 85 8a 00 00 00    	jne    18b9 <pipe1+0x189>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
    182f:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
    1835:	75 b0                	jne    17e7 <pipe1+0xb7>
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
      printf(1, "pipe1 oops 3 total %d\n", total);
      exit();
    1837:	e8 ac 20 00 00       	call   38e8 <exit>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
    183c:	81 ff 2d 14 00 00    	cmp    $0x142d,%edi
    1842:	75 29                	jne    186d <pipe1+0x13d>
      printf(1, "pipe1 oops 3 total %d\n", total);
      exit();
    }
    close(fds[0]);
    1844:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1847:	89 04 24             	mov    %eax,(%esp)
    184a:	e8 c1 20 00 00       	call   3910 <close>
    wait();
    184f:	e8 9c 20 00 00       	call   38f0 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
    1854:	c7 44 24 04 3e 43 00 	movl   $0x433e,0x4(%esp)
    185b:	00 
    185c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1863:	e8 c8 21 00 00       	call   3a30 <printf>
    1868:	e9 65 ff ff ff       	jmp    17d2 <pipe1+0xa2>
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
      printf(1, "pipe1 oops 3 total %d\n", total);
    186d:	89 7c 24 08          	mov    %edi,0x8(%esp)
    1871:	c7 44 24 04 27 43 00 	movl   $0x4327,0x4(%esp)
    1878:	00 
    1879:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1880:	e8 ab 21 00 00       	call   3a30 <printf>
    1885:	eb b0                	jmp    1837 <pipe1+0x107>
{
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    1887:	c7 44 24 04 07 41 00 	movl   $0x4107,0x4(%esp)
    188e:	00 
    188f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1896:	e8 95 21 00 00       	call   3a30 <printf>
    exit();
    189b:	e8 48 20 00 00       	call   38e8 <exit>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
    18a0:	c7 44 24 04 48 43 00 	movl   $0x4348,0x4(%esp)
    18a7:	00 
    18a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18af:	e8 7c 21 00 00       	call   3a30 <printf>
    exit();
    18b4:	e8 2f 20 00 00       	call   38e8 <exit>
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
    18b9:	c7 44 24 04 0b 43 00 	movl   $0x430b,0x4(%esp)
    18c0:	00 
    18c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18c8:	e8 63 21 00 00       	call   3a30 <printf>
        exit();
    18cd:	e8 16 20 00 00       	call   38e8 <exit>
    18d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    18d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000018e0 <writetest1>:
  printf(stdout, "small file test ok\n");
}

void
writetest1(void)
{
    18e0:	55                   	push   %ebp
    18e1:	89 e5                	mov    %esp,%ebp
    18e3:	56                   	push   %esi
    18e4:	53                   	push   %ebx
    18e5:	83 ec 10             	sub    $0x10,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
    18e8:	a1 14 54 00 00       	mov    0x5414,%eax
    18ed:	c7 44 24 04 57 43 00 	movl   $0x4357,0x4(%esp)
    18f4:	00 
    18f5:	89 04 24             	mov    %eax,(%esp)
    18f8:	e8 33 21 00 00       	call   3a30 <printf>

  fd = open("big", O_CREATE|O_RDWR);
    18fd:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1904:	00 
    1905:	c7 04 24 d1 43 00 00 	movl   $0x43d1,(%esp)
    190c:	e8 17 20 00 00       	call   3928 <open>
  if(fd < 0){
    1911:	85 c0                	test   %eax,%eax
{
  int i, fd, n;

  printf(stdout, "big files test\n");

  fd = open("big", O_CREATE|O_RDWR);
    1913:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    1915:	0f 88 7a 01 00 00    	js     1a95 <writetest1+0x1b5>
    printf(stdout, "error: creat big failed!\n");
    exit();
    191b:	31 db                	xor    %ebx,%ebx
    191d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  for(i = 0; i < MAXFILE; i++){
    ((int*)buf)[0] = i;
    1920:	89 1d e0 7b 00 00    	mov    %ebx,0x7be0
    if(write(fd, buf, 512) != 512){
    1926:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    192d:	00 
    192e:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    1935:	00 
    1936:	89 34 24             	mov    %esi,(%esp)
    1939:	e8 ca 1f 00 00       	call   3908 <write>
    193e:	3d 00 02 00 00       	cmp    $0x200,%eax
    1943:	0f 85 b2 00 00 00    	jne    19fb <writetest1+0x11b>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
    1949:	83 c3 01             	add    $0x1,%ebx
    194c:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
    1952:	75 cc                	jne    1920 <writetest1+0x40>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
    1954:	89 34 24             	mov    %esi,(%esp)
    1957:	e8 b4 1f 00 00       	call   3910 <close>

  fd = open("big", O_RDONLY);
    195c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1963:	00 
    1964:	c7 04 24 d1 43 00 00 	movl   $0x43d1,(%esp)
    196b:	e8 b8 1f 00 00       	call   3928 <open>
  if(fd < 0){
    1970:	85 c0                	test   %eax,%eax
    }
  }

  close(fd);

  fd = open("big", O_RDONLY);
    1972:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    1974:	0f 88 01 01 00 00    	js     1a7b <writetest1+0x19b>
    printf(stdout, "error: open big failed!\n");
    exit();
    197a:	31 db                	xor    %ebx,%ebx
    197c:	eb 1d                	jmp    199b <writetest1+0xbb>
    197e:	66 90                	xchg   %ax,%ax
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
    1980:	3d 00 02 00 00       	cmp    $0x200,%eax
    1985:	0f 85 b0 00 00 00    	jne    1a3b <writetest1+0x15b>
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
    198b:	a1 e0 7b 00 00       	mov    0x7be0,%eax
    1990:	39 d8                	cmp    %ebx,%eax
    1992:	0f 85 81 00 00 00    	jne    1a19 <writetest1+0x139>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
    1998:	83 c3 01             	add    $0x1,%ebx
    exit();
  }

  n = 0;
  for(;;){
    i = read(fd, buf, 512);
    199b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    19a2:	00 
    19a3:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    19aa:	00 
    19ab:	89 34 24             	mov    %esi,(%esp)
    19ae:	e8 4d 1f 00 00       	call   3900 <read>
    if(i == 0){
    19b3:	85 c0                	test   %eax,%eax
    19b5:	75 c9                	jne    1980 <writetest1+0xa0>
      if(n == MAXFILE - 1){
    19b7:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
    19bd:	0f 84 96 00 00 00    	je     1a59 <writetest1+0x179>
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
    19c3:	89 34 24             	mov    %esi,(%esp)
    19c6:	e8 45 1f 00 00       	call   3910 <close>
  if(unlink("big") < 0){
    19cb:	c7 04 24 d1 43 00 00 	movl   $0x43d1,(%esp)
    19d2:	e8 61 1f 00 00       	call   3938 <unlink>
    19d7:	85 c0                	test   %eax,%eax
    19d9:	0f 88 d0 00 00 00    	js     1aaf <writetest1+0x1cf>
    printf(stdout, "unlink big failed\n");
    exit();
  }
  printf(stdout, "big files ok\n");
    19df:	a1 14 54 00 00       	mov    0x5414,%eax
    19e4:	c7 44 24 04 f8 43 00 	movl   $0x43f8,0x4(%esp)
    19eb:	00 
    19ec:	89 04 24             	mov    %eax,(%esp)
    19ef:	e8 3c 20 00 00       	call   3a30 <printf>
}
    19f4:	83 c4 10             	add    $0x10,%esp
    19f7:	5b                   	pop    %ebx
    19f8:	5e                   	pop    %esi
    19f9:	5d                   	pop    %ebp
    19fa:	c3                   	ret    
  }

  for(i = 0; i < MAXFILE; i++){
    ((int*)buf)[0] = i;
    if(write(fd, buf, 512) != 512){
      printf(stdout, "error: write big file failed\n", i);
    19fb:	a1 14 54 00 00       	mov    0x5414,%eax
    1a00:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1a04:	c7 44 24 04 81 43 00 	movl   $0x4381,0x4(%esp)
    1a0b:	00 
    1a0c:	89 04 24             	mov    %eax,(%esp)
    1a0f:	e8 1c 20 00 00       	call   3a30 <printf>
      exit();
    1a14:	e8 cf 1e 00 00       	call   38e8 <exit>
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
    1a19:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1a1d:	a1 14 54 00 00       	mov    0x5414,%eax
    1a22:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1a26:	c7 44 24 04 94 4f 00 	movl   $0x4f94,0x4(%esp)
    1a2d:	00 
    1a2e:	89 04 24             	mov    %eax,(%esp)
    1a31:	e8 fa 1f 00 00       	call   3a30 <printf>
             n, ((int*)buf)[0]);
      exit();
    1a36:	e8 ad 1e 00 00       	call   38e8 <exit>
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
    1a3b:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a3f:	a1 14 54 00 00       	mov    0x5414,%eax
    1a44:	c7 44 24 04 d5 43 00 	movl   $0x43d5,0x4(%esp)
    1a4b:	00 
    1a4c:	89 04 24             	mov    %eax,(%esp)
    1a4f:	e8 dc 1f 00 00       	call   3a30 <printf>
      exit();
    1a54:	e8 8f 1e 00 00       	call   38e8 <exit>
  n = 0;
  for(;;){
    i = read(fd, buf, 512);
    if(i == 0){
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
    1a59:	a1 14 54 00 00       	mov    0x5414,%eax
    1a5e:	c7 44 24 08 8b 00 00 	movl   $0x8b,0x8(%esp)
    1a65:	00 
    1a66:	c7 44 24 04 b8 43 00 	movl   $0x43b8,0x4(%esp)
    1a6d:	00 
    1a6e:	89 04 24             	mov    %eax,(%esp)
    1a71:	e8 ba 1f 00 00       	call   3a30 <printf>
        exit();
    1a76:	e8 6d 1e 00 00       	call   38e8 <exit>

  close(fd);

  fd = open("big", O_RDONLY);
  if(fd < 0){
    printf(stdout, "error: open big failed!\n");
    1a7b:	a1 14 54 00 00       	mov    0x5414,%eax
    1a80:	c7 44 24 04 9f 43 00 	movl   $0x439f,0x4(%esp)
    1a87:	00 
    1a88:	89 04 24             	mov    %eax,(%esp)
    1a8b:	e8 a0 1f 00 00       	call   3a30 <printf>
    exit();
    1a90:	e8 53 1e 00 00       	call   38e8 <exit>

  printf(stdout, "big files test\n");

  fd = open("big", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    1a95:	a1 14 54 00 00       	mov    0x5414,%eax
    1a9a:	c7 44 24 04 67 43 00 	movl   $0x4367,0x4(%esp)
    1aa1:	00 
    1aa2:	89 04 24             	mov    %eax,(%esp)
    1aa5:	e8 86 1f 00 00       	call   3a30 <printf>
    exit();
    1aaa:	e8 39 1e 00 00       	call   38e8 <exit>
    }
    n++;
  }
  close(fd);
  if(unlink("big") < 0){
    printf(stdout, "unlink big failed\n");
    1aaf:	a1 14 54 00 00       	mov    0x5414,%eax
    1ab4:	c7 44 24 04 e5 43 00 	movl   $0x43e5,0x4(%esp)
    1abb:	00 
    1abc:	89 04 24             	mov    %eax,(%esp)
    1abf:	e8 6c 1f 00 00       	call   3a30 <printf>
    exit();
    1ac4:	e8 1f 1e 00 00       	call   38e8 <exit>
    1ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001ad0 <writetest>:
  printf(stdout, "open test ok\n");
}

void
writetest(void)
{
    1ad0:	55                   	push   %ebp
    1ad1:	89 e5                	mov    %esp,%ebp
    1ad3:	56                   	push   %esi
    1ad4:	53                   	push   %ebx
    1ad5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
    1ad8:	a1 14 54 00 00       	mov    0x5414,%eax
    1add:	c7 44 24 04 06 44 00 	movl   $0x4406,0x4(%esp)
    1ae4:	00 
    1ae5:	89 04 24             	mov    %eax,(%esp)
    1ae8:	e8 43 1f 00 00       	call   3a30 <printf>
  fd = open("small", O_CREATE|O_RDWR);
    1aed:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1af4:	00 
    1af5:	c7 04 24 17 44 00 00 	movl   $0x4417,(%esp)
    1afc:	e8 27 1e 00 00       	call   3928 <open>
  if(fd >= 0){
    1b01:	85 c0                	test   %eax,%eax
{
  int fd;
  int i;

  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
    1b03:	89 c6                	mov    %eax,%esi
  if(fd >= 0){
    1b05:	0f 88 b1 01 00 00    	js     1cbc <writetest+0x1ec>
    printf(stdout, "creat small succeeded; ok\n");
    1b0b:	a1 14 54 00 00       	mov    0x5414,%eax
    1b10:	31 db                	xor    %ebx,%ebx
    1b12:	c7 44 24 04 1d 44 00 	movl   $0x441d,0x4(%esp)
    1b19:	00 
    1b1a:	89 04 24             	mov    %eax,(%esp)
    1b1d:	e8 0e 1f 00 00       	call   3a30 <printf>
    1b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
    1b28:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1b2f:	00 
    1b30:	c7 44 24 04 54 44 00 	movl   $0x4454,0x4(%esp)
    1b37:	00 
    1b38:	89 34 24             	mov    %esi,(%esp)
    1b3b:	e8 c8 1d 00 00       	call   3908 <write>
    1b40:	83 f8 0a             	cmp    $0xa,%eax
    1b43:	0f 85 e9 00 00 00    	jne    1c32 <writetest+0x162>
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
    1b49:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1b50:	00 
    1b51:	c7 44 24 04 5f 44 00 	movl   $0x445f,0x4(%esp)
    1b58:	00 
    1b59:	89 34 24             	mov    %esi,(%esp)
    1b5c:	e8 a7 1d 00 00       	call   3908 <write>
    1b61:	83 f8 0a             	cmp    $0xa,%eax
    1b64:	0f 85 e6 00 00 00    	jne    1c50 <writetest+0x180>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
    1b6a:	83 c3 01             	add    $0x1,%ebx
    1b6d:	83 fb 64             	cmp    $0x64,%ebx
    1b70:	75 b6                	jne    1b28 <writetest+0x58>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
    1b72:	a1 14 54 00 00       	mov    0x5414,%eax
    1b77:	c7 44 24 04 6a 44 00 	movl   $0x446a,0x4(%esp)
    1b7e:	00 
    1b7f:	89 04 24             	mov    %eax,(%esp)
    1b82:	e8 a9 1e 00 00       	call   3a30 <printf>
  close(fd);
    1b87:	89 34 24             	mov    %esi,(%esp)
    1b8a:	e8 81 1d 00 00       	call   3910 <close>
  fd = open("small", O_RDONLY);
    1b8f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1b96:	00 
    1b97:	c7 04 24 17 44 00 00 	movl   $0x4417,(%esp)
    1b9e:	e8 85 1d 00 00       	call   3928 <open>
  if(fd >= 0){
    1ba3:	85 c0                	test   %eax,%eax
      exit();
    }
  }
  printf(stdout, "writes ok\n");
  close(fd);
  fd = open("small", O_RDONLY);
    1ba5:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
    1ba7:	0f 88 c1 00 00 00    	js     1c6e <writetest+0x19e>
    printf(stdout, "open small succeeded ok\n");
    1bad:	a1 14 54 00 00       	mov    0x5414,%eax
    1bb2:	c7 44 24 04 75 44 00 	movl   $0x4475,0x4(%esp)
    1bb9:	00 
    1bba:	89 04 24             	mov    %eax,(%esp)
    1bbd:	e8 6e 1e 00 00       	call   3a30 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
    1bc2:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
    1bc9:	00 
    1bca:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    1bd1:	00 
    1bd2:	89 1c 24             	mov    %ebx,(%esp)
    1bd5:	e8 26 1d 00 00       	call   3900 <read>
  if(i == 2000){
    1bda:	3d d0 07 00 00       	cmp    $0x7d0,%eax
    1bdf:	0f 85 a3 00 00 00    	jne    1c88 <writetest+0x1b8>
    printf(stdout, "read succeeded ok\n");
    1be5:	a1 14 54 00 00       	mov    0x5414,%eax
    1bea:	c7 44 24 04 a9 44 00 	movl   $0x44a9,0x4(%esp)
    1bf1:	00 
    1bf2:	89 04 24             	mov    %eax,(%esp)
    1bf5:	e8 36 1e 00 00       	call   3a30 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
    1bfa:	89 1c 24             	mov    %ebx,(%esp)
    1bfd:	e8 0e 1d 00 00       	call   3910 <close>

  if(unlink("small") < 0){
    1c02:	c7 04 24 17 44 00 00 	movl   $0x4417,(%esp)
    1c09:	e8 2a 1d 00 00       	call   3938 <unlink>
    1c0e:	85 c0                	test   %eax,%eax
    1c10:	0f 88 8c 00 00 00    	js     1ca2 <writetest+0x1d2>
    printf(stdout, "unlink small failed\n");
    exit();
  }
  printf(stdout, "small file test ok\n");
    1c16:	a1 14 54 00 00       	mov    0x5414,%eax
    1c1b:	c7 44 24 04 d1 44 00 	movl   $0x44d1,0x4(%esp)
    1c22:	00 
    1c23:	89 04 24             	mov    %eax,(%esp)
    1c26:	e8 05 1e 00 00       	call   3a30 <printf>
}
    1c2b:	83 c4 10             	add    $0x10,%esp
    1c2e:	5b                   	pop    %ebx
    1c2f:	5e                   	pop    %esi
    1c30:	5d                   	pop    %ebp
    1c31:	c3                   	ret    
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
      printf(stdout, "error: write aa %d new file failed\n", i);
    1c32:	a1 14 54 00 00       	mov    0x5414,%eax
    1c37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1c3b:	c7 44 24 04 b4 4f 00 	movl   $0x4fb4,0x4(%esp)
    1c42:	00 
    1c43:	89 04 24             	mov    %eax,(%esp)
    1c46:	e8 e5 1d 00 00       	call   3a30 <printf>
      exit();
    1c4b:	e8 98 1c 00 00       	call   38e8 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
    1c50:	a1 14 54 00 00       	mov    0x5414,%eax
    1c55:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1c59:	c7 44 24 04 d8 4f 00 	movl   $0x4fd8,0x4(%esp)
    1c60:	00 
    1c61:	89 04 24             	mov    %eax,(%esp)
    1c64:	e8 c7 1d 00 00       	call   3a30 <printf>
      exit();
    1c69:	e8 7a 1c 00 00       	call   38e8 <exit>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
    1c6e:	a1 14 54 00 00       	mov    0x5414,%eax
    1c73:	c7 44 24 04 8e 44 00 	movl   $0x448e,0x4(%esp)
    1c7a:	00 
    1c7b:	89 04 24             	mov    %eax,(%esp)
    1c7e:	e8 ad 1d 00 00       	call   3a30 <printf>
    exit();
    1c83:	e8 60 1c 00 00       	call   38e8 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
    1c88:	a1 14 54 00 00       	mov    0x5414,%eax
    1c8d:	c7 44 24 04 23 42 00 	movl   $0x4223,0x4(%esp)
    1c94:	00 
    1c95:	89 04 24             	mov    %eax,(%esp)
    1c98:	e8 93 1d 00 00       	call   3a30 <printf>
    exit();
    1c9d:	e8 46 1c 00 00       	call   38e8 <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
    1ca2:	a1 14 54 00 00       	mov    0x5414,%eax
    1ca7:	c7 44 24 04 bc 44 00 	movl   $0x44bc,0x4(%esp)
    1cae:	00 
    1caf:	89 04 24             	mov    %eax,(%esp)
    1cb2:	e8 79 1d 00 00       	call   3a30 <printf>
    exit();
    1cb7:	e8 2c 1c 00 00       	call   38e8 <exit>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    1cbc:	a1 14 54 00 00       	mov    0x5414,%eax
    1cc1:	c7 44 24 04 38 44 00 	movl   $0x4438,0x4(%esp)
    1cc8:	00 
    1cc9:	89 04 24             	mov    %eax,(%esp)
    1ccc:	e8 5f 1d 00 00       	call   3a30 <printf>
    exit();
    1cd1:	e8 12 1c 00 00       	call   38e8 <exit>
    1cd6:	8d 76 00             	lea    0x0(%esi),%esi
    1cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001ce0 <fourteen>:
  printf(1, "bigfile test ok\n");
}

void
fourteen(void)
{
    1ce0:	55                   	push   %ebp
    1ce1:	89 e5                	mov    %esp,%ebp
    1ce3:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    1ce6:	c7 44 24 04 e5 44 00 	movl   $0x44e5,0x4(%esp)
    1ced:	00 
    1cee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cf5:	e8 36 1d 00 00       	call   3a30 <printf>

  if(mkdir("12345678901234") != 0){
    1cfa:	c7 04 24 20 45 00 00 	movl   $0x4520,(%esp)
    1d01:	e8 4a 1c 00 00       	call   3950 <mkdir>
    1d06:	85 c0                	test   %eax,%eax
    1d08:	0f 85 92 00 00 00    	jne    1da0 <fourteen+0xc0>
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    1d0e:	c7 04 24 fc 4f 00 00 	movl   $0x4ffc,(%esp)
    1d15:	e8 36 1c 00 00       	call   3950 <mkdir>
    1d1a:	85 c0                	test   %eax,%eax
    1d1c:	0f 85 fb 00 00 00    	jne    1e1d <fourteen+0x13d>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    1d22:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1d29:	00 
    1d2a:	c7 04 24 4c 50 00 00 	movl   $0x504c,(%esp)
    1d31:	e8 f2 1b 00 00       	call   3928 <open>
  if(fd < 0){
    1d36:	85 c0                	test   %eax,%eax
    1d38:	0f 88 c6 00 00 00    	js     1e04 <fourteen+0x124>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
    1d3e:	89 04 24             	mov    %eax,(%esp)
    1d41:	e8 ca 1b 00 00       	call   3910 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    1d46:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1d4d:	00 
    1d4e:	c7 04 24 bc 50 00 00 	movl   $0x50bc,(%esp)
    1d55:	e8 ce 1b 00 00       	call   3928 <open>
  if(fd < 0){
    1d5a:	85 c0                	test   %eax,%eax
    1d5c:	0f 88 89 00 00 00    	js     1deb <fourteen+0x10b>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
    1d62:	89 04 24             	mov    %eax,(%esp)
    1d65:	e8 a6 1b 00 00       	call   3910 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    1d6a:	c7 04 24 11 45 00 00 	movl   $0x4511,(%esp)
    1d71:	e8 da 1b 00 00       	call   3950 <mkdir>
    1d76:	85 c0                	test   %eax,%eax
    1d78:	74 58                	je     1dd2 <fourteen+0xf2>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    1d7a:	c7 04 24 58 51 00 00 	movl   $0x5158,(%esp)
    1d81:	e8 ca 1b 00 00       	call   3950 <mkdir>
    1d86:	85 c0                	test   %eax,%eax
    1d88:	74 2f                	je     1db9 <fourteen+0xd9>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf(1, "fourteen ok\n");
    1d8a:	c7 44 24 04 2f 45 00 	movl   $0x452f,0x4(%esp)
    1d91:	00 
    1d92:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d99:	e8 92 1c 00 00       	call   3a30 <printf>
}
    1d9e:	c9                   	leave  
    1d9f:	c3                   	ret    

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");

  if(mkdir("12345678901234") != 0){
    printf(1, "mkdir 12345678901234 failed\n");
    1da0:	c7 44 24 04 f4 44 00 	movl   $0x44f4,0x4(%esp)
    1da7:	00 
    1da8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1daf:	e8 7c 1c 00 00       	call   3a30 <printf>
    exit();
    1db4:	e8 2f 1b 00 00       	call   38e8 <exit>
  if(mkdir("12345678901234/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    1db9:	c7 44 24 04 78 51 00 	movl   $0x5178,0x4(%esp)
    1dc0:	00 
    1dc1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1dc8:	e8 63 1c 00 00       	call   3a30 <printf>
    exit();
    1dcd:	e8 16 1b 00 00       	call   38e8 <exit>
    exit();
  }
  close(fd);

  if(mkdir("12345678901234/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    1dd2:	c7 44 24 04 28 51 00 	movl   $0x5128,0x4(%esp)
    1dd9:	00 
    1dda:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1de1:	e8 4a 1c 00 00       	call   3a30 <printf>
    exit();
    1de6:	e8 fd 1a 00 00       	call   38e8 <exit>
    exit();
  }
  close(fd);
  fd = open("12345678901234/12345678901234/12345678901234", 0);
  if(fd < 0){
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    1deb:	c7 44 24 04 ec 50 00 	movl   $0x50ec,0x4(%esp)
    1df2:	00 
    1df3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1dfa:	e8 31 1c 00 00       	call   3a30 <printf>
    exit();
    1dff:	e8 e4 1a 00 00       	call   38e8 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
  if(fd < 0){
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    1e04:	c7 44 24 04 7c 50 00 	movl   $0x507c,0x4(%esp)
    1e0b:	00 
    1e0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e13:	e8 18 1c 00 00       	call   3a30 <printf>
    exit();
    1e18:	e8 cb 1a 00 00       	call   38e8 <exit>
  if(mkdir("12345678901234") != 0){
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    1e1d:	c7 44 24 04 1c 50 00 	movl   $0x501c,0x4(%esp)
    1e24:	00 
    1e25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e2c:	e8 ff 1b 00 00       	call   3a30 <printf>
    exit();
    1e31:	e8 b2 1a 00 00       	call   38e8 <exit>
    1e36:	8d 76 00             	lea    0x0(%esi),%esi
    1e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001e40 <iref>:
}

// test that iput() is called at the end of _namei()
void
iref(void)
{
    1e40:	55                   	push   %ebp
    1e41:	89 e5                	mov    %esp,%ebp
    1e43:	53                   	push   %ebx
  int i, fd;

  printf(1, "empty file name\n");
    1e44:	31 db                	xor    %ebx,%ebx
}

// test that iput() is called at the end of _namei()
void
iref(void)
{
    1e46:	83 ec 14             	sub    $0x14,%esp
  int i, fd;

  printf(1, "empty file name\n");
    1e49:	c7 44 24 04 3c 45 00 	movl   $0x453c,0x4(%esp)
    1e50:	00 
    1e51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e58:	e8 d3 1b 00 00       	call   3a30 <printf>
    1e5d:	8d 76 00             	lea    0x0(%esi),%esi

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
    1e60:	c7 04 24 4d 45 00 00 	movl   $0x454d,(%esp)
    1e67:	e8 e4 1a 00 00       	call   3950 <mkdir>
    1e6c:	85 c0                	test   %eax,%eax
    1e6e:	0f 85 b2 00 00 00    	jne    1f26 <iref+0xe6>
      printf(1, "mkdir irefd failed\n");
      exit();
    }
    if(chdir("irefd") != 0){
    1e74:	c7 04 24 4d 45 00 00 	movl   $0x454d,(%esp)
    1e7b:	e8 d8 1a 00 00       	call   3958 <chdir>
    1e80:	85 c0                	test   %eax,%eax
    1e82:	0f 85 b7 00 00 00    	jne    1f3f <iref+0xff>
      printf(1, "chdir irefd failed\n");
      exit();
    }

    mkdir("");
    1e88:	c7 04 24 7f 4c 00 00 	movl   $0x4c7f,(%esp)
    1e8f:	e8 bc 1a 00 00       	call   3950 <mkdir>
    link("README", "");
    1e94:	c7 44 24 04 7f 4c 00 	movl   $0x4c7f,0x4(%esp)
    1e9b:	00 
    1e9c:	c7 04 24 7b 45 00 00 	movl   $0x457b,(%esp)
    1ea3:	e8 a0 1a 00 00       	call   3948 <link>
    fd = open("", O_CREATE);
    1ea8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1eaf:	00 
    1eb0:	c7 04 24 7f 4c 00 00 	movl   $0x4c7f,(%esp)
    1eb7:	e8 6c 1a 00 00       	call   3928 <open>
    if(fd >= 0)
    1ebc:	85 c0                	test   %eax,%eax
    1ebe:	78 08                	js     1ec8 <iref+0x88>
      close(fd);
    1ec0:	89 04 24             	mov    %eax,(%esp)
    1ec3:	e8 48 1a 00 00       	call   3910 <close>
    fd = open("xx", O_CREATE);
    1ec8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1ecf:	00 
    1ed0:	c7 04 24 4d 49 00 00 	movl   $0x494d,(%esp)
    1ed7:	e8 4c 1a 00 00       	call   3928 <open>
    if(fd >= 0)
    1edc:	85 c0                	test   %eax,%eax
    1ede:	78 08                	js     1ee8 <iref+0xa8>
      close(fd);
    1ee0:	89 04 24             	mov    %eax,(%esp)
    1ee3:	e8 28 1a 00 00       	call   3910 <close>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    1ee8:	83 c3 01             	add    $0x1,%ebx
    if(fd >= 0)
      close(fd);
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
    1eeb:	c7 04 24 4d 49 00 00 	movl   $0x494d,(%esp)
    1ef2:	e8 41 1a 00 00       	call   3938 <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    1ef7:	83 fb 33             	cmp    $0x33,%ebx
    1efa:	0f 85 60 ff ff ff    	jne    1e60 <iref+0x20>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    1f00:	c7 04 24 82 45 00 00 	movl   $0x4582,(%esp)
    1f07:	e8 4c 1a 00 00       	call   3958 <chdir>
  printf(1, "empty file name OK\n");
    1f0c:	c7 44 24 04 84 45 00 	movl   $0x4584,0x4(%esp)
    1f13:	00 
    1f14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f1b:	e8 10 1b 00 00       	call   3a30 <printf>
}
    1f20:	83 c4 14             	add    $0x14,%esp
    1f23:	5b                   	pop    %ebx
    1f24:	5d                   	pop    %ebp
    1f25:	c3                   	ret    
  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
    1f26:	c7 44 24 04 53 45 00 	movl   $0x4553,0x4(%esp)
    1f2d:	00 
    1f2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f35:	e8 f6 1a 00 00       	call   3a30 <printf>
      exit();
    1f3a:	e8 a9 19 00 00       	call   38e8 <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
    1f3f:	c7 44 24 04 67 45 00 	movl   $0x4567,0x4(%esp)
    1f46:	00 
    1f47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f4e:	e8 dd 1a 00 00       	call   3a30 <printf>
      exit();
    1f53:	e8 90 19 00 00       	call   38e8 <exit>
    1f58:	90                   	nop
    1f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001f60 <dirfile>:
  printf(1, "rmdot ok\n");
}

void
dirfile(void)
{
    1f60:	55                   	push   %ebp
    1f61:	89 e5                	mov    %esp,%ebp
    1f63:	53                   	push   %ebx
    1f64:	83 ec 14             	sub    $0x14,%esp
  int fd;

  printf(1, "dir vs file\n");
    1f67:	c7 44 24 04 98 45 00 	movl   $0x4598,0x4(%esp)
    1f6e:	00 
    1f6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f76:	e8 b5 1a 00 00       	call   3a30 <printf>

  fd = open("dirfile", O_CREATE);
    1f7b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1f82:	00 
    1f83:	c7 04 24 a5 45 00 00 	movl   $0x45a5,(%esp)
    1f8a:	e8 99 19 00 00       	call   3928 <open>
  if(fd < 0){
    1f8f:	85 c0                	test   %eax,%eax
    1f91:	0f 88 4e 01 00 00    	js     20e5 <dirfile+0x185>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
    1f97:	89 04 24             	mov    %eax,(%esp)
    1f9a:	e8 71 19 00 00       	call   3910 <close>
  if(chdir("dirfile") == 0){
    1f9f:	c7 04 24 a5 45 00 00 	movl   $0x45a5,(%esp)
    1fa6:	e8 ad 19 00 00       	call   3958 <chdir>
    1fab:	85 c0                	test   %eax,%eax
    1fad:	0f 84 19 01 00 00    	je     20cc <dirfile+0x16c>
    printf(1, "chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
    1fb3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1fba:	00 
    1fbb:	c7 04 24 de 45 00 00 	movl   $0x45de,(%esp)
    1fc2:	e8 61 19 00 00       	call   3928 <open>
  if(fd >= 0){
    1fc7:	85 c0                	test   %eax,%eax
    1fc9:	0f 89 e4 00 00 00    	jns    20b3 <dirfile+0x153>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
    1fcf:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1fd6:	00 
    1fd7:	c7 04 24 de 45 00 00 	movl   $0x45de,(%esp)
    1fde:	e8 45 19 00 00       	call   3928 <open>
  if(fd >= 0){
    1fe3:	85 c0                	test   %eax,%eax
    1fe5:	0f 89 c8 00 00 00    	jns    20b3 <dirfile+0x153>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    1feb:	c7 04 24 de 45 00 00 	movl   $0x45de,(%esp)
    1ff2:	e8 59 19 00 00       	call   3950 <mkdir>
    1ff7:	85 c0                	test   %eax,%eax
    1ff9:	0f 84 7c 01 00 00    	je     217b <dirfile+0x21b>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    1fff:	c7 04 24 de 45 00 00 	movl   $0x45de,(%esp)
    2006:	e8 2d 19 00 00       	call   3938 <unlink>
    200b:	85 c0                	test   %eax,%eax
    200d:	0f 84 4f 01 00 00    	je     2162 <dirfile+0x202>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    2013:	c7 44 24 04 de 45 00 	movl   $0x45de,0x4(%esp)
    201a:	00 
    201b:	c7 04 24 7b 45 00 00 	movl   $0x457b,(%esp)
    2022:	e8 21 19 00 00       	call   3948 <link>
    2027:	85 c0                	test   %eax,%eax
    2029:	0f 84 1a 01 00 00    	je     2149 <dirfile+0x1e9>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    202f:	c7 04 24 a5 45 00 00 	movl   $0x45a5,(%esp)
    2036:	e8 fd 18 00 00       	call   3938 <unlink>
    203b:	85 c0                	test   %eax,%eax
    203d:	0f 85 ed 00 00 00    	jne    2130 <dirfile+0x1d0>
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
    2043:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    204a:	00 
    204b:	c7 04 24 6b 48 00 00 	movl   $0x486b,(%esp)
    2052:	e8 d1 18 00 00       	call   3928 <open>
  if(fd >= 0){
    2057:	85 c0                	test   %eax,%eax
    2059:	0f 89 b8 00 00 00    	jns    2117 <dirfile+0x1b7>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    205f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2066:	00 
    2067:	c7 04 24 6b 48 00 00 	movl   $0x486b,(%esp)
    206e:	e8 b5 18 00 00       	call   3928 <open>
  if(write(fd, "x", 1) > 0){
    2073:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    207a:	00 
    207b:	c7 44 24 04 4e 49 00 	movl   $0x494e,0x4(%esp)
    2082:	00 
  fd = open(".", O_RDWR);
  if(fd >= 0){
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    2083:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    2085:	89 04 24             	mov    %eax,(%esp)
    2088:	e8 7b 18 00 00       	call   3908 <write>
    208d:	85 c0                	test   %eax,%eax
    208f:	7f 6d                	jg     20fe <dirfile+0x19e>
    printf(1, "write . succeeded!\n");
    exit();
  }
  close(fd);
    2091:	89 1c 24             	mov    %ebx,(%esp)
    2094:	e8 77 18 00 00       	call   3910 <close>

  printf(1, "dir vs file OK\n");
    2099:	c7 44 24 04 6e 46 00 	movl   $0x466e,0x4(%esp)
    20a0:	00 
    20a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20a8:	e8 83 19 00 00       	call   3a30 <printf>
}
    20ad:	83 c4 14             	add    $0x14,%esp
    20b0:	5b                   	pop    %ebx
    20b1:	5d                   	pop    %ebp
    20b2:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
  if(fd >= 0){
    printf(1, "create dirfile/xx succeeded!\n");
    20b3:	c7 44 24 04 e9 45 00 	movl   $0x45e9,0x4(%esp)
    20ba:	00 
    20bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20c2:	e8 69 19 00 00       	call   3a30 <printf>
    exit();
    20c7:	e8 1c 18 00 00       	call   38e8 <exit>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
  if(chdir("dirfile") == 0){
    printf(1, "chdir dirfile succeeded!\n");
    20cc:	c7 44 24 04 c4 45 00 	movl   $0x45c4,0x4(%esp)
    20d3:	00 
    20d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20db:	e8 50 19 00 00       	call   3a30 <printf>
    exit();
    20e0:	e8 03 18 00 00       	call   38e8 <exit>

  printf(1, "dir vs file\n");

  fd = open("dirfile", O_CREATE);
  if(fd < 0){
    printf(1, "create dirfile failed\n");
    20e5:	c7 44 24 04 ad 45 00 	movl   $0x45ad,0x4(%esp)
    20ec:	00 
    20ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20f4:	e8 37 19 00 00       	call   3a30 <printf>
    exit();
    20f9:	e8 ea 17 00 00       	call   38e8 <exit>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
  if(write(fd, "x", 1) > 0){
    printf(1, "write . succeeded!\n");
    20fe:	c7 44 24 04 5a 46 00 	movl   $0x465a,0x4(%esp)
    2105:	00 
    2106:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    210d:	e8 1e 19 00 00       	call   3a30 <printf>
    exit();
    2112:	e8 d1 17 00 00       	call   38e8 <exit>
    exit();
  }

  fd = open(".", O_RDWR);
  if(fd >= 0){
    printf(1, "open . for writing succeeded!\n");
    2117:	c7 44 24 04 cc 51 00 	movl   $0x51cc,0x4(%esp)
    211e:	00 
    211f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2126:	e8 05 19 00 00       	call   3a30 <printf>
    exit();
    212b:	e8 b8 17 00 00       	call   38e8 <exit>
  if(link("README", "dirfile/xx") == 0){
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    printf(1, "unlink dirfile failed!\n");
    2130:	c7 44 24 04 42 46 00 	movl   $0x4642,0x4(%esp)
    2137:	00 
    2138:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    213f:	e8 ec 18 00 00       	call   3a30 <printf>
    exit();
    2144:	e8 9f 17 00 00       	call   38e8 <exit>
  if(unlink("dirfile/xx") == 0){
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    printf(1, "link to dirfile/xx succeeded!\n");
    2149:	c7 44 24 04 ac 51 00 	movl   $0x51ac,0x4(%esp)
    2150:	00 
    2151:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2158:	e8 d3 18 00 00       	call   3a30 <printf>
    exit();
    215d:	e8 86 17 00 00       	call   38e8 <exit>
  if(mkdir("dirfile/xx") == 0){
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    printf(1, "unlink dirfile/xx succeeded!\n");
    2162:	c7 44 24 04 24 46 00 	movl   $0x4624,0x4(%esp)
    2169:	00 
    216a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2171:	e8 ba 18 00 00       	call   3a30 <printf>
    exit();
    2176:	e8 6d 17 00 00       	call   38e8 <exit>
  if(fd >= 0){
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    printf(1, "mkdir dirfile/xx succeeded!\n");
    217b:	c7 44 24 04 07 46 00 	movl   $0x4607,0x4(%esp)
    2182:	00 
    2183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    218a:	e8 a1 18 00 00       	call   3a30 <printf>
    exit();
    218f:	e8 54 17 00 00       	call   38e8 <exit>
    2194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    219a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000021a0 <rmdot>:
  printf(1, "fourteen ok\n");
}

void
rmdot(void)
{
    21a0:	55                   	push   %ebp
    21a1:	89 e5                	mov    %esp,%ebp
    21a3:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    21a6:	c7 44 24 04 7e 46 00 	movl   $0x467e,0x4(%esp)
    21ad:	00 
    21ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21b5:	e8 76 18 00 00       	call   3a30 <printf>
  if(mkdir("dots") != 0){
    21ba:	c7 04 24 8a 46 00 00 	movl   $0x468a,(%esp)
    21c1:	e8 8a 17 00 00       	call   3950 <mkdir>
    21c6:	85 c0                	test   %eax,%eax
    21c8:	0f 85 9a 00 00 00    	jne    2268 <rmdot+0xc8>
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    21ce:	c7 04 24 8a 46 00 00 	movl   $0x468a,(%esp)
    21d5:	e8 7e 17 00 00       	call   3958 <chdir>
    21da:	85 c0                	test   %eax,%eax
    21dc:	0f 85 35 01 00 00    	jne    2317 <rmdot+0x177>
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    21e2:	c7 04 24 6b 48 00 00 	movl   $0x486b,(%esp)
    21e9:	e8 4a 17 00 00       	call   3938 <unlink>
    21ee:	85 c0                	test   %eax,%eax
    21f0:	0f 84 08 01 00 00    	je     22fe <rmdot+0x15e>
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    21f6:	c7 04 24 6a 48 00 00 	movl   $0x486a,(%esp)
    21fd:	e8 36 17 00 00       	call   3938 <unlink>
    2202:	85 c0                	test   %eax,%eax
    2204:	0f 84 db 00 00 00    	je     22e5 <rmdot+0x145>
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    220a:	c7 04 24 82 45 00 00 	movl   $0x4582,(%esp)
    2211:	e8 42 17 00 00       	call   3958 <chdir>
    2216:	85 c0                	test   %eax,%eax
    2218:	0f 85 ae 00 00 00    	jne    22cc <rmdot+0x12c>
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    221e:	c7 04 24 e2 46 00 00 	movl   $0x46e2,(%esp)
    2225:	e8 0e 17 00 00       	call   3938 <unlink>
    222a:	85 c0                	test   %eax,%eax
    222c:	0f 84 81 00 00 00    	je     22b3 <rmdot+0x113>
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    2232:	c7 04 24 00 47 00 00 	movl   $0x4700,(%esp)
    2239:	e8 fa 16 00 00       	call   3938 <unlink>
    223e:	85 c0                	test   %eax,%eax
    2240:	74 58                	je     229a <rmdot+0xfa>
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    2242:	c7 04 24 8a 46 00 00 	movl   $0x468a,(%esp)
    2249:	e8 ea 16 00 00       	call   3938 <unlink>
    224e:	85 c0                	test   %eax,%eax
    2250:	75 2f                	jne    2281 <rmdot+0xe1>
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
    2252:	c7 44 24 04 35 47 00 	movl   $0x4735,0x4(%esp)
    2259:	00 
    225a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2261:	e8 ca 17 00 00       	call   3a30 <printf>
}
    2266:	c9                   	leave  
    2267:	c3                   	ret    
void
rmdot(void)
{
  printf(1, "rmdot test\n");
  if(mkdir("dots") != 0){
    printf(1, "mkdir dots failed\n");
    2268:	c7 44 24 04 8f 46 00 	movl   $0x468f,0x4(%esp)
    226f:	00 
    2270:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2277:	e8 b4 17 00 00       	call   3a30 <printf>
    exit();
    227c:	e8 67 16 00 00       	call   38e8 <exit>
  if(unlink("dots/..") == 0){
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    printf(1, "unlink dots failed!\n");
    2281:	c7 44 24 04 20 47 00 	movl   $0x4720,0x4(%esp)
    2288:	00 
    2289:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2290:	e8 9b 17 00 00       	call   3a30 <printf>
    exit();
    2295:	e8 4e 16 00 00       	call   38e8 <exit>
  if(unlink("dots/.") == 0){
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    printf(1, "unlink dots/.. worked!\n");
    229a:	c7 44 24 04 08 47 00 	movl   $0x4708,0x4(%esp)
    22a1:	00 
    22a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22a9:	e8 82 17 00 00       	call   3a30 <printf>
    exit();
    22ae:	e8 35 16 00 00       	call   38e8 <exit>
  if(chdir("/") != 0){
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    printf(1, "unlink dots/. worked!\n");
    22b3:	c7 44 24 04 e9 46 00 	movl   $0x46e9,0x4(%esp)
    22ba:	00 
    22bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22c2:	e8 69 17 00 00       	call   3a30 <printf>
    exit();
    22c7:	e8 1c 16 00 00       	call   38e8 <exit>
  if(unlink("..") == 0){
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    printf(1, "chdir / failed\n");
    22cc:	c7 44 24 04 d2 46 00 	movl   $0x46d2,0x4(%esp)
    22d3:	00 
    22d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22db:	e8 50 17 00 00       	call   3a30 <printf>
    exit();
    22e0:	e8 03 16 00 00       	call   38e8 <exit>
  if(unlink(".") == 0){
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    printf(1, "rm .. worked!\n");
    22e5:	c7 44 24 04 c3 46 00 	movl   $0x46c3,0x4(%esp)
    22ec:	00 
    22ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22f4:	e8 37 17 00 00       	call   3a30 <printf>
    exit();
    22f9:	e8 ea 15 00 00       	call   38e8 <exit>
  if(chdir("dots") != 0){
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    printf(1, "rm . worked!\n");
    22fe:	c7 44 24 04 b5 46 00 	movl   $0x46b5,0x4(%esp)
    2305:	00 
    2306:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    230d:	e8 1e 17 00 00       	call   3a30 <printf>
    exit();
    2312:	e8 d1 15 00 00       	call   38e8 <exit>
  if(mkdir("dots") != 0){
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    printf(1, "chdir dots failed\n");
    2317:	c7 44 24 04 a2 46 00 	movl   $0x46a2,0x4(%esp)
    231e:	00 
    231f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2326:	e8 05 17 00 00       	call   3a30 <printf>
    exit();
    232b:	e8 b8 15 00 00       	call   38e8 <exit>

00002330 <subdir>:
  printf(1, "bigdir ok\n");
}

void
subdir(void)
{
    2330:	55                   	push   %ebp
    2331:	89 e5                	mov    %esp,%ebp
    2333:	53                   	push   %ebx
    2334:	83 ec 14             	sub    $0x14,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    2337:	c7 44 24 04 3f 47 00 	movl   $0x473f,0x4(%esp)
    233e:	00 
    233f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2346:	e8 e5 16 00 00       	call   3a30 <printf>

  unlink("ff");
    234b:	c7 04 24 c8 47 00 00 	movl   $0x47c8,(%esp)
    2352:	e8 e1 15 00 00       	call   3938 <unlink>
  if(mkdir("dd") != 0){
    2357:	c7 04 24 65 48 00 00 	movl   $0x4865,(%esp)
    235e:	e8 ed 15 00 00       	call   3950 <mkdir>
    2363:	85 c0                	test   %eax,%eax
    2365:	0f 85 07 06 00 00    	jne    2972 <subdir+0x642>
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    236b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2372:	00 
    2373:	c7 04 24 9e 47 00 00 	movl   $0x479e,(%esp)
    237a:	e8 a9 15 00 00       	call   3928 <open>
  if(fd < 0){
    237f:	85 c0                	test   %eax,%eax
  if(mkdir("dd") != 0){
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    2381:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2383:	0f 88 d0 05 00 00    	js     2959 <subdir+0x629>
    printf(1, "create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
    2389:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    2390:	00 
    2391:	c7 44 24 04 c8 47 00 	movl   $0x47c8,0x4(%esp)
    2398:	00 
    2399:	89 04 24             	mov    %eax,(%esp)
    239c:	e8 67 15 00 00       	call   3908 <write>
  close(fd);
    23a1:	89 1c 24             	mov    %ebx,(%esp)
    23a4:	e8 67 15 00 00       	call   3910 <close>
  
  if(unlink("dd") >= 0){
    23a9:	c7 04 24 65 48 00 00 	movl   $0x4865,(%esp)
    23b0:	e8 83 15 00 00       	call   3938 <unlink>
    23b5:	85 c0                	test   %eax,%eax
    23b7:	0f 89 83 05 00 00    	jns    2940 <subdir+0x610>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    23bd:	c7 04 24 79 47 00 00 	movl   $0x4779,(%esp)
    23c4:	e8 87 15 00 00       	call   3950 <mkdir>
    23c9:	85 c0                	test   %eax,%eax
    23cb:	0f 85 56 05 00 00    	jne    2927 <subdir+0x5f7>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    23d1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    23d8:	00 
    23d9:	c7 04 24 9b 47 00 00 	movl   $0x479b,(%esp)
    23e0:	e8 43 15 00 00       	call   3928 <open>
  if(fd < 0){
    23e5:	85 c0                	test   %eax,%eax
  if(mkdir("/dd/dd") != 0){
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    23e7:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    23e9:	0f 88 25 04 00 00    	js     2814 <subdir+0x4e4>
    printf(1, "create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    23ef:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    23f6:	00 
    23f7:	c7 44 24 04 bc 47 00 	movl   $0x47bc,0x4(%esp)
    23fe:	00 
    23ff:	89 04 24             	mov    %eax,(%esp)
    2402:	e8 01 15 00 00       	call   3908 <write>
  close(fd);
    2407:	89 1c 24             	mov    %ebx,(%esp)
    240a:	e8 01 15 00 00       	call   3910 <close>

  fd = open("dd/dd/../ff", 0);
    240f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2416:	00 
    2417:	c7 04 24 bf 47 00 00 	movl   $0x47bf,(%esp)
    241e:	e8 05 15 00 00       	call   3928 <open>
  if(fd < 0){
    2423:	85 c0                	test   %eax,%eax
    exit();
  }
  write(fd, "FF", 2);
  close(fd);

  fd = open("dd/dd/../ff", 0);
    2425:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2427:	0f 88 ce 03 00 00    	js     27fb <subdir+0x4cb>
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    242d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2434:	00 
    2435:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    243c:	00 
    243d:	89 04 24             	mov    %eax,(%esp)
    2440:	e8 bb 14 00 00       	call   3900 <read>
  if(cc != 2 || buf[0] != 'f'){
    2445:	83 f8 02             	cmp    $0x2,%eax
    2448:	0f 85 fe 02 00 00    	jne    274c <subdir+0x41c>
    244e:	80 3d e0 7b 00 00 66 	cmpb   $0x66,0x7be0
    2455:	0f 85 f1 02 00 00    	jne    274c <subdir+0x41c>
    printf(1, "dd/dd/../ff wrong content\n");
    exit();
  }
  close(fd);
    245b:	89 1c 24             	mov    %ebx,(%esp)
    245e:	e8 ad 14 00 00       	call   3910 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2463:	c7 44 24 04 ff 47 00 	movl   $0x47ff,0x4(%esp)
    246a:	00 
    246b:	c7 04 24 9b 47 00 00 	movl   $0x479b,(%esp)
    2472:	e8 d1 14 00 00       	call   3948 <link>
    2477:	85 c0                	test   %eax,%eax
    2479:	0f 85 c7 03 00 00    	jne    2846 <subdir+0x516>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    247f:	c7 04 24 9b 47 00 00 	movl   $0x479b,(%esp)
    2486:	e8 ad 14 00 00       	call   3938 <unlink>
    248b:	85 c0                	test   %eax,%eax
    248d:	0f 85 eb 02 00 00    	jne    277e <subdir+0x44e>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2493:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    249a:	00 
    249b:	c7 04 24 9b 47 00 00 	movl   $0x479b,(%esp)
    24a2:	e8 81 14 00 00       	call   3928 <open>
    24a7:	85 c0                	test   %eax,%eax
    24a9:	0f 89 5f 04 00 00    	jns    290e <subdir+0x5de>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    24af:	c7 04 24 65 48 00 00 	movl   $0x4865,(%esp)
    24b6:	e8 9d 14 00 00       	call   3958 <chdir>
    24bb:	85 c0                	test   %eax,%eax
    24bd:	0f 85 32 04 00 00    	jne    28f5 <subdir+0x5c5>
    printf(1, "chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    24c3:	c7 04 24 33 48 00 00 	movl   $0x4833,(%esp)
    24ca:	e8 89 14 00 00       	call   3958 <chdir>
    24cf:	85 c0                	test   %eax,%eax
    24d1:	0f 85 8e 02 00 00    	jne    2765 <subdir+0x435>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    24d7:	c7 04 24 59 48 00 00 	movl   $0x4859,(%esp)
    24de:	e8 75 14 00 00       	call   3958 <chdir>
    24e3:	85 c0                	test   %eax,%eax
    24e5:	0f 85 7a 02 00 00    	jne    2765 <subdir+0x435>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    24eb:	c7 04 24 68 48 00 00 	movl   $0x4868,(%esp)
    24f2:	e8 61 14 00 00       	call   3958 <chdir>
    24f7:	85 c0                	test   %eax,%eax
    24f9:	0f 85 2e 03 00 00    	jne    282d <subdir+0x4fd>
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    24ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2506:	00 
    2507:	c7 04 24 ff 47 00 00 	movl   $0x47ff,(%esp)
    250e:	e8 15 14 00 00       	call   3928 <open>
  if(fd < 0){
    2513:	85 c0                	test   %eax,%eax
  if(chdir("./..") != 0){
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    2515:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2517:	0f 88 81 05 00 00    	js     2a9e <subdir+0x76e>
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    251d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2524:	00 
    2525:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    252c:	00 
    252d:	89 04 24             	mov    %eax,(%esp)
    2530:	e8 cb 13 00 00       	call   3900 <read>
    2535:	83 f8 02             	cmp    $0x2,%eax
    2538:	0f 85 47 05 00 00    	jne    2a85 <subdir+0x755>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    253e:	89 1c 24             	mov    %ebx,(%esp)
    2541:	e8 ca 13 00 00       	call   3910 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2546:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    254d:	00 
    254e:	c7 04 24 9b 47 00 00 	movl   $0x479b,(%esp)
    2555:	e8 ce 13 00 00       	call   3928 <open>
    255a:	85 c0                	test   %eax,%eax
    255c:	0f 89 4e 02 00 00    	jns    27b0 <subdir+0x480>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2562:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2569:	00 
    256a:	c7 04 24 b3 48 00 00 	movl   $0x48b3,(%esp)
    2571:	e8 b2 13 00 00       	call   3928 <open>
    2576:	85 c0                	test   %eax,%eax
    2578:	0f 89 19 02 00 00    	jns    2797 <subdir+0x467>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    257e:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2585:	00 
    2586:	c7 04 24 d8 48 00 00 	movl   $0x48d8,(%esp)
    258d:	e8 96 13 00 00       	call   3928 <open>
    2592:	85 c0                	test   %eax,%eax
    2594:	0f 89 42 03 00 00    	jns    28dc <subdir+0x5ac>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    259a:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    25a1:	00 
    25a2:	c7 04 24 65 48 00 00 	movl   $0x4865,(%esp)
    25a9:	e8 7a 13 00 00       	call   3928 <open>
    25ae:	85 c0                	test   %eax,%eax
    25b0:	0f 89 0d 03 00 00    	jns    28c3 <subdir+0x593>
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    25b6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    25bd:	00 
    25be:	c7 04 24 65 48 00 00 	movl   $0x4865,(%esp)
    25c5:	e8 5e 13 00 00       	call   3928 <open>
    25ca:	85 c0                	test   %eax,%eax
    25cc:	0f 89 d8 02 00 00    	jns    28aa <subdir+0x57a>
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    25d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    25d9:	00 
    25da:	c7 04 24 65 48 00 00 	movl   $0x4865,(%esp)
    25e1:	e8 42 13 00 00       	call   3928 <open>
    25e6:	85 c0                	test   %eax,%eax
    25e8:	0f 89 a3 02 00 00    	jns    2891 <subdir+0x561>
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    25ee:	c7 44 24 04 47 49 00 	movl   $0x4947,0x4(%esp)
    25f5:	00 
    25f6:	c7 04 24 b3 48 00 00 	movl   $0x48b3,(%esp)
    25fd:	e8 46 13 00 00       	call   3948 <link>
    2602:	85 c0                	test   %eax,%eax
    2604:	0f 84 6e 02 00 00    	je     2878 <subdir+0x548>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    260a:	c7 44 24 04 47 49 00 	movl   $0x4947,0x4(%esp)
    2611:	00 
    2612:	c7 04 24 d8 48 00 00 	movl   $0x48d8,(%esp)
    2619:	e8 2a 13 00 00       	call   3948 <link>
    261e:	85 c0                	test   %eax,%eax
    2620:	0f 84 39 02 00 00    	je     285f <subdir+0x52f>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2626:	c7 44 24 04 ff 47 00 	movl   $0x47ff,0x4(%esp)
    262d:	00 
    262e:	c7 04 24 9e 47 00 00 	movl   $0x479e,(%esp)
    2635:	e8 0e 13 00 00       	call   3948 <link>
    263a:	85 c0                	test   %eax,%eax
    263c:	0f 84 a0 01 00 00    	je     27e2 <subdir+0x4b2>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    2642:	c7 04 24 b3 48 00 00 	movl   $0x48b3,(%esp)
    2649:	e8 02 13 00 00       	call   3950 <mkdir>
    264e:	85 c0                	test   %eax,%eax
    2650:	0f 84 73 01 00 00    	je     27c9 <subdir+0x499>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    2656:	c7 04 24 d8 48 00 00 	movl   $0x48d8,(%esp)
    265d:	e8 ee 12 00 00       	call   3950 <mkdir>
    2662:	85 c0                	test   %eax,%eax
    2664:	0f 84 02 04 00 00    	je     2a6c <subdir+0x73c>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    266a:	c7 04 24 ff 47 00 00 	movl   $0x47ff,(%esp)
    2671:	e8 da 12 00 00       	call   3950 <mkdir>
    2676:	85 c0                	test   %eax,%eax
    2678:	0f 84 d5 03 00 00    	je     2a53 <subdir+0x723>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    267e:	c7 04 24 d8 48 00 00 	movl   $0x48d8,(%esp)
    2685:	e8 ae 12 00 00       	call   3938 <unlink>
    268a:	85 c0                	test   %eax,%eax
    268c:	0f 84 a8 03 00 00    	je     2a3a <subdir+0x70a>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    2692:	c7 04 24 b3 48 00 00 	movl   $0x48b3,(%esp)
    2699:	e8 9a 12 00 00       	call   3938 <unlink>
    269e:	85 c0                	test   %eax,%eax
    26a0:	0f 84 7b 03 00 00    	je     2a21 <subdir+0x6f1>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    26a6:	c7 04 24 9e 47 00 00 	movl   $0x479e,(%esp)
    26ad:	e8 a6 12 00 00       	call   3958 <chdir>
    26b2:	85 c0                	test   %eax,%eax
    26b4:	0f 84 4e 03 00 00    	je     2a08 <subdir+0x6d8>
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    26ba:	c7 04 24 4a 49 00 00 	movl   $0x494a,(%esp)
    26c1:	e8 92 12 00 00       	call   3958 <chdir>
    26c6:	85 c0                	test   %eax,%eax
    26c8:	0f 84 21 03 00 00    	je     29ef <subdir+0x6bf>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    26ce:	c7 04 24 ff 47 00 00 	movl   $0x47ff,(%esp)
    26d5:	e8 5e 12 00 00       	call   3938 <unlink>
    26da:	85 c0                	test   %eax,%eax
    26dc:	0f 85 9c 00 00 00    	jne    277e <subdir+0x44e>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    26e2:	c7 04 24 9e 47 00 00 	movl   $0x479e,(%esp)
    26e9:	e8 4a 12 00 00       	call   3938 <unlink>
    26ee:	85 c0                	test   %eax,%eax
    26f0:	0f 85 e0 02 00 00    	jne    29d6 <subdir+0x6a6>
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    26f6:	c7 04 24 65 48 00 00 	movl   $0x4865,(%esp)
    26fd:	e8 36 12 00 00       	call   3938 <unlink>
    2702:	85 c0                	test   %eax,%eax
    2704:	0f 84 b3 02 00 00    	je     29bd <subdir+0x68d>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    270a:	c7 04 24 7a 47 00 00 	movl   $0x477a,(%esp)
    2711:	e8 22 12 00 00       	call   3938 <unlink>
    2716:	85 c0                	test   %eax,%eax
    2718:	0f 88 86 02 00 00    	js     29a4 <subdir+0x674>
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    271e:	c7 04 24 65 48 00 00 	movl   $0x4865,(%esp)
    2725:	e8 0e 12 00 00       	call   3938 <unlink>
    272a:	85 c0                	test   %eax,%eax
    272c:	0f 88 59 02 00 00    	js     298b <subdir+0x65b>
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
    2732:	c7 44 24 04 47 4a 00 	movl   $0x4a47,0x4(%esp)
    2739:	00 
    273a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2741:	e8 ea 12 00 00       	call   3a30 <printf>
}
    2746:	83 c4 14             	add    $0x14,%esp
    2749:	5b                   	pop    %ebx
    274a:	5d                   	pop    %ebp
    274b:	c3                   	ret    
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
  if(cc != 2 || buf[0] != 'f'){
    printf(1, "dd/dd/../ff wrong content\n");
    274c:	c7 44 24 04 e4 47 00 	movl   $0x47e4,0x4(%esp)
    2753:	00 
    2754:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    275b:	e8 d0 12 00 00       	call   3a30 <printf>
    exit();
    2760:	e8 83 11 00 00       	call   38e8 <exit>
  if(chdir("dd/../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    2765:	c7 44 24 04 3f 48 00 	movl   $0x483f,0x4(%esp)
    276c:	00 
    276d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2774:	e8 b7 12 00 00       	call   3a30 <printf>
    exit();
    2779:	e8 6a 11 00 00       	call   38e8 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    277e:	c7 44 24 04 0a 48 00 	movl   $0x480a,0x4(%esp)
    2785:	00 
    2786:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    278d:	e8 9e 12 00 00       	call   3a30 <printf>
    exit();
    2792:	e8 51 11 00 00       	call   38e8 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/ff/ff succeeded!\n");
    2797:	c7 44 24 04 bc 48 00 	movl   $0x48bc,0x4(%esp)
    279e:	00 
    279f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27a6:	e8 85 12 00 00       	call   3a30 <printf>
    exit();
    27ab:	e8 38 11 00 00       	call   38e8 <exit>
    exit();
  }
  close(fd);

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    27b0:	c7 44 24 04 5c 52 00 	movl   $0x525c,0x4(%esp)
    27b7:	00 
    27b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27bf:	e8 6c 12 00 00       	call   3a30 <printf>
    exit();
    27c4:	e8 1f 11 00 00       	call   38e8 <exit>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    27c9:	c7 44 24 04 50 49 00 	movl   $0x4950,0x4(%esp)
    27d0:	00 
    27d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27d8:	e8 53 12 00 00       	call   3a30 <printf>
    exit();
    27dd:	e8 06 11 00 00       	call   38e8 <exit>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    27e2:	c7 44 24 04 cc 52 00 	movl   $0x52cc,0x4(%esp)
    27e9:	00 
    27ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27f1:	e8 3a 12 00 00       	call   3a30 <printf>
    exit();
    27f6:	e8 ed 10 00 00       	call   38e8 <exit>
  write(fd, "FF", 2);
  close(fd);

  fd = open("dd/dd/../ff", 0);
  if(fd < 0){
    printf(1, "open dd/dd/../ff failed\n");
    27fb:	c7 44 24 04 cb 47 00 	movl   $0x47cb,0x4(%esp)
    2802:	00 
    2803:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    280a:	e8 21 12 00 00       	call   3a30 <printf>
    exit();
    280f:	e8 d4 10 00 00       	call   38e8 <exit>
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create dd/dd/ff failed\n");
    2814:	c7 44 24 04 a4 47 00 	movl   $0x47a4,0x4(%esp)
    281b:	00 
    281c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2823:	e8 08 12 00 00       	call   3a30 <printf>
    exit();
    2828:	e8 bb 10 00 00       	call   38e8 <exit>
  if(chdir("dd/../../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    printf(1, "chdir ./.. failed\n");
    282d:	c7 44 24 04 6d 48 00 	movl   $0x486d,0x4(%esp)
    2834:	00 
    2835:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    283c:	e8 ef 11 00 00       	call   3a30 <printf>
    exit();
    2841:	e8 a2 10 00 00       	call   38e8 <exit>
    exit();
  }
  close(fd);

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2846:	c7 44 24 04 14 52 00 	movl   $0x5214,0x4(%esp)
    284d:	00 
    284e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2855:	e8 d6 11 00 00       	call   3a30 <printf>
    exit();
    285a:	e8 89 10 00 00       	call   38e8 <exit>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    285f:	c7 44 24 04 a8 52 00 	movl   $0x52a8,0x4(%esp)
    2866:	00 
    2867:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    286e:	e8 bd 11 00 00       	call   3a30 <printf>
    exit();
    2873:	e8 70 10 00 00       	call   38e8 <exit>
  if(open("dd", O_WRONLY) >= 0){
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    2878:	c7 44 24 04 84 52 00 	movl   $0x5284,0x4(%esp)
    287f:	00 
    2880:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2887:	e8 a4 11 00 00       	call   3a30 <printf>
    exit();
    288c:	e8 57 10 00 00       	call   38e8 <exit>
  if(open("dd", O_RDWR) >= 0){
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    printf(1, "open dd wronly succeeded!\n");
    2891:	c7 44 24 04 2c 49 00 	movl   $0x492c,0x4(%esp)
    2898:	00 
    2899:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28a0:	e8 8b 11 00 00       	call   3a30 <printf>
    exit();
    28a5:	e8 3e 10 00 00       	call   38e8 <exit>
  if(open("dd", O_CREATE) >= 0){
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    printf(1, "open dd rdwr succeeded!\n");
    28aa:	c7 44 24 04 13 49 00 	movl   $0x4913,0x4(%esp)
    28b1:	00 
    28b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28b9:	e8 72 11 00 00       	call   3a30 <printf>
    exit();
    28be:	e8 25 10 00 00       	call   38e8 <exit>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    printf(1, "create dd succeeded!\n");
    28c3:	c7 44 24 04 fd 48 00 	movl   $0x48fd,0x4(%esp)
    28ca:	00 
    28cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28d2:	e8 59 11 00 00       	call   3a30 <printf>
    exit();
    28d7:	e8 0c 10 00 00       	call   38e8 <exit>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/xx/ff succeeded!\n");
    28dc:	c7 44 24 04 e1 48 00 	movl   $0x48e1,0x4(%esp)
    28e3:	00 
    28e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28eb:	e8 40 11 00 00       	call   3a30 <printf>
    exit();
    28f0:	e8 f3 0f 00 00       	call   38e8 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    printf(1, "chdir dd failed\n");
    28f5:	c7 44 24 04 22 48 00 	movl   $0x4822,0x4(%esp)
    28fc:	00 
    28fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2904:	e8 27 11 00 00       	call   3a30 <printf>
    exit();
    2909:	e8 da 0f 00 00       	call   38e8 <exit>
  if(unlink("dd/dd/ff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    290e:	c7 44 24 04 38 52 00 	movl   $0x5238,0x4(%esp)
    2915:	00 
    2916:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    291d:	e8 0e 11 00 00       	call   3a30 <printf>
    exit();
    2922:	e8 c1 0f 00 00       	call   38e8 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    printf(1, "subdir mkdir dd/dd failed\n");
    2927:	c7 44 24 04 80 47 00 	movl   $0x4780,0x4(%esp)
    292e:	00 
    292f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2936:	e8 f5 10 00 00       	call   3a30 <printf>
    exit();
    293b:	e8 a8 0f 00 00       	call   38e8 <exit>
  }
  write(fd, "ff", 2);
  close(fd);
  
  if(unlink("dd") >= 0){
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2940:	c7 44 24 04 ec 51 00 	movl   $0x51ec,0x4(%esp)
    2947:	00 
    2948:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    294f:	e8 dc 10 00 00       	call   3a30 <printf>
    exit();
    2954:	e8 8f 0f 00 00       	call   38e8 <exit>
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create dd/ff failed\n");
    2959:	c7 44 24 04 64 47 00 	movl   $0x4764,0x4(%esp)
    2960:	00 
    2961:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2968:	e8 c3 10 00 00       	call   3a30 <printf>
    exit();
    296d:	e8 76 0f 00 00       	call   38e8 <exit>

  printf(1, "subdir test\n");

  unlink("ff");
  if(mkdir("dd") != 0){
    printf(1, "subdir mkdir dd failed\n");
    2972:	c7 44 24 04 4c 47 00 	movl   $0x474c,0x4(%esp)
    2979:	00 
    297a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2981:	e8 aa 10 00 00       	call   3a30 <printf>
    exit();
    2986:	e8 5d 0f 00 00       	call   38e8 <exit>
  if(unlink("dd/dd") < 0){
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    printf(1, "unlink dd failed\n");
    298b:	c7 44 24 04 35 4a 00 	movl   $0x4a35,0x4(%esp)
    2992:	00 
    2993:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    299a:	e8 91 10 00 00       	call   3a30 <printf>
    exit();
    299f:	e8 44 0f 00 00       	call   38e8 <exit>
  if(unlink("dd") == 0){
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    printf(1, "unlink dd/dd failed\n");
    29a4:	c7 44 24 04 20 4a 00 	movl   $0x4a20,0x4(%esp)
    29ab:	00 
    29ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29b3:	e8 78 10 00 00       	call   3a30 <printf>
    exit();
    29b8:	e8 2b 0f 00 00       	call   38e8 <exit>
  if(unlink("dd/ff") != 0){
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    printf(1, "unlink non-empty dd succeeded!\n");
    29bd:	c7 44 24 04 f0 52 00 	movl   $0x52f0,0x4(%esp)
    29c4:	00 
    29c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29cc:	e8 5f 10 00 00       	call   3a30 <printf>
    exit();
    29d1:	e8 12 0f 00 00       	call   38e8 <exit>
  if(unlink("dd/dd/ffff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    printf(1, "unlink dd/ff failed\n");
    29d6:	c7 44 24 04 0b 4a 00 	movl   $0x4a0b,0x4(%esp)
    29dd:	00 
    29de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29e5:	e8 46 10 00 00       	call   3a30 <printf>
    exit();
    29ea:	e8 f9 0e 00 00       	call   38e8 <exit>
  if(chdir("dd/ff") == 0){
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    printf(1, "chdir dd/xx succeeded!\n");
    29ef:	c7 44 24 04 f3 49 00 	movl   $0x49f3,0x4(%esp)
    29f6:	00 
    29f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29fe:	e8 2d 10 00 00       	call   3a30 <printf>
    exit();
    2a03:	e8 e0 0e 00 00       	call   38e8 <exit>
  if(unlink("dd/ff/ff") == 0){
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    printf(1, "chdir dd/ff succeeded!\n");
    2a08:	c7 44 24 04 db 49 00 	movl   $0x49db,0x4(%esp)
    2a0f:	00 
    2a10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a17:	e8 14 10 00 00       	call   3a30 <printf>
    exit();
    2a1c:	e8 c7 0e 00 00       	call   38e8 <exit>
  if(unlink("dd/xx/ff") == 0){
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2a21:	c7 44 24 04 bf 49 00 	movl   $0x49bf,0x4(%esp)
    2a28:	00 
    2a29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a30:	e8 fb 0f 00 00       	call   3a30 <printf>
    exit();
    2a35:	e8 ae 0e 00 00       	call   38e8 <exit>
  if(mkdir("dd/dd/ffff") == 0){
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2a3a:	c7 44 24 04 a3 49 00 	movl   $0x49a3,0x4(%esp)
    2a41:	00 
    2a42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a49:	e8 e2 0f 00 00       	call   3a30 <printf>
    exit();
    2a4e:	e8 95 0e 00 00       	call   38e8 <exit>
  if(mkdir("dd/xx/ff") == 0){
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2a53:	c7 44 24 04 86 49 00 	movl   $0x4986,0x4(%esp)
    2a5a:	00 
    2a5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a62:	e8 c9 0f 00 00       	call   3a30 <printf>
    exit();
    2a67:	e8 7c 0e 00 00       	call   38e8 <exit>
  if(mkdir("dd/ff/ff") == 0){
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2a6c:	c7 44 24 04 6b 49 00 	movl   $0x496b,0x4(%esp)
    2a73:	00 
    2a74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a7b:	e8 b0 0f 00 00       	call   3a30 <printf>
    exit();
    2a80:	e8 63 0e 00 00       	call   38e8 <exit>
  if(fd < 0){
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    printf(1, "read dd/dd/ffff wrong len\n");
    2a85:	c7 44 24 04 98 48 00 	movl   $0x4898,0x4(%esp)
    2a8c:	00 
    2a8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a94:	e8 97 0f 00 00       	call   3a30 <printf>
    exit();
    2a99:	e8 4a 0e 00 00       	call   38e8 <exit>
    exit();
  }

  fd = open("dd/dd/ffff", 0);
  if(fd < 0){
    printf(1, "open dd/dd/ffff failed\n");
    2a9e:	c7 44 24 04 80 48 00 	movl   $0x4880,0x4(%esp)
    2aa5:	00 
    2aa6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2aad:	e8 7e 0f 00 00       	call   3a30 <printf>
    exit();
    2ab2:	e8 31 0e 00 00       	call   38e8 <exit>
    2ab7:	89 f6                	mov    %esi,%esi
    2ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002ac0 <dirtest>:
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
}

void dirtest(void)
{
    2ac0:	55                   	push   %ebp
    2ac1:	89 e5                	mov    %esp,%ebp
    2ac3:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
    2ac6:	a1 14 54 00 00       	mov    0x5414,%eax
    2acb:	c7 44 24 04 52 4a 00 	movl   $0x4a52,0x4(%esp)
    2ad2:	00 
    2ad3:	89 04 24             	mov    %eax,(%esp)
    2ad6:	e8 55 0f 00 00       	call   3a30 <printf>

  if(mkdir("dir0") < 0){
    2adb:	c7 04 24 5e 4a 00 00 	movl   $0x4a5e,(%esp)
    2ae2:	e8 69 0e 00 00       	call   3950 <mkdir>
    2ae7:	85 c0                	test   %eax,%eax
    2ae9:	78 4b                	js     2b36 <dirtest+0x76>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
    2aeb:	c7 04 24 5e 4a 00 00 	movl   $0x4a5e,(%esp)
    2af2:	e8 61 0e 00 00       	call   3958 <chdir>
    2af7:	85 c0                	test   %eax,%eax
    2af9:	0f 88 85 00 00 00    	js     2b84 <dirtest+0xc4>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
    2aff:	c7 04 24 6a 48 00 00 	movl   $0x486a,(%esp)
    2b06:	e8 4d 0e 00 00       	call   3958 <chdir>
    2b0b:	85 c0                	test   %eax,%eax
    2b0d:	78 5b                	js     2b6a <dirtest+0xaa>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
    2b0f:	c7 04 24 5e 4a 00 00 	movl   $0x4a5e,(%esp)
    2b16:	e8 1d 0e 00 00       	call   3938 <unlink>
    2b1b:	85 c0                	test   %eax,%eax
    2b1d:	78 31                	js     2b50 <dirtest+0x90>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test\n");
    2b1f:	a1 14 54 00 00       	mov    0x5414,%eax
    2b24:	c7 44 24 04 52 4a 00 	movl   $0x4a52,0x4(%esp)
    2b2b:	00 
    2b2c:	89 04 24             	mov    %eax,(%esp)
    2b2f:	e8 fc 0e 00 00       	call   3a30 <printf>
}
    2b34:	c9                   	leave  
    2b35:	c3                   	ret    
void dirtest(void)
{
  printf(stdout, "mkdir test\n");

  if(mkdir("dir0") < 0){
    printf(stdout, "mkdir failed\n");
    2b36:	a1 14 54 00 00       	mov    0x5414,%eax
    2b3b:	c7 44 24 04 63 4a 00 	movl   $0x4a63,0x4(%esp)
    2b42:	00 
    2b43:	89 04 24             	mov    %eax,(%esp)
    2b46:	e8 e5 0e 00 00       	call   3a30 <printf>
    exit();
    2b4b:	e8 98 0d 00 00       	call   38e8 <exit>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
    printf(stdout, "unlink dir0 failed\n");
    2b50:	a1 14 54 00 00       	mov    0x5414,%eax
    2b55:	c7 44 24 04 95 4a 00 	movl   $0x4a95,0x4(%esp)
    2b5c:	00 
    2b5d:	89 04 24             	mov    %eax,(%esp)
    2b60:	e8 cb 0e 00 00       	call   3a30 <printf>
    exit();
    2b65:	e8 7e 0d 00 00       	call   38e8 <exit>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
    printf(stdout, "chdir .. failed\n");
    2b6a:	a1 14 54 00 00       	mov    0x5414,%eax
    2b6f:	c7 44 24 04 84 4a 00 	movl   $0x4a84,0x4(%esp)
    2b76:	00 
    2b77:	89 04 24             	mov    %eax,(%esp)
    2b7a:	e8 b1 0e 00 00       	call   3a30 <printf>
    exit();
    2b7f:	e8 64 0d 00 00       	call   38e8 <exit>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
    printf(stdout, "chdir dir0 failed\n");
    2b84:	a1 14 54 00 00       	mov    0x5414,%eax
    2b89:	c7 44 24 04 71 4a 00 	movl   $0x4a71,0x4(%esp)
    2b90:	00 
    2b91:	89 04 24             	mov    %eax,(%esp)
    2b94:	e8 97 0e 00 00       	call   3a30 <printf>
    exit();
    2b99:	e8 4a 0d 00 00       	call   38e8 <exit>
    2b9e:	66 90                	xchg   %ax,%ax

00002ba0 <bigfile>:
  printf(1, "bigwrite ok\n");
}

void
bigfile(void)
{
    2ba0:	55                   	push   %ebp
    2ba1:	89 e5                	mov    %esp,%ebp
    2ba3:	57                   	push   %edi
    2ba4:	56                   	push   %esi
    2ba5:	53                   	push   %ebx
    2ba6:	83 ec 1c             	sub    $0x1c,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    2ba9:	c7 44 24 04 a9 4a 00 	movl   $0x4aa9,0x4(%esp)
    2bb0:	00 
    2bb1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bb8:	e8 73 0e 00 00       	call   3a30 <printf>

  unlink("bigfile");
    2bbd:	c7 04 24 c5 4a 00 00 	movl   $0x4ac5,(%esp)
    2bc4:	e8 6f 0d 00 00       	call   3938 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2bc9:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2bd0:	00 
    2bd1:	c7 04 24 c5 4a 00 00 	movl   $0x4ac5,(%esp)
    2bd8:	e8 4b 0d 00 00       	call   3928 <open>
  if(fd < 0){
    2bdd:	85 c0                	test   %eax,%eax
  int fd, i, total, cc;

  printf(1, "bigfile test\n");

  unlink("bigfile");
  fd = open("bigfile", O_CREATE | O_RDWR);
    2bdf:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    2be1:	0f 88 7f 01 00 00    	js     2d66 <bigfile+0x1c6>
    printf(1, "cannot create bigfile");
    exit();
    2be7:	31 db                	xor    %ebx,%ebx
    2be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  for(i = 0; i < 20; i++){
    memset(buf, i, 600);
    2bf0:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    2bf7:	00 
    2bf8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    2bfc:	c7 04 24 e0 7b 00 00 	movl   $0x7be0,(%esp)
    2c03:	e8 58 0b 00 00       	call   3760 <memset>
    if(write(fd, buf, 600) != 600){
    2c08:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    2c0f:	00 
    2c10:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    2c17:	00 
    2c18:	89 34 24             	mov    %esi,(%esp)
    2c1b:	e8 e8 0c 00 00       	call   3908 <write>
    2c20:	3d 58 02 00 00       	cmp    $0x258,%eax
    2c25:	0f 85 09 01 00 00    	jne    2d34 <bigfile+0x194>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    2c2b:	83 c3 01             	add    $0x1,%ebx
    2c2e:	83 fb 14             	cmp    $0x14,%ebx
    2c31:	75 bd                	jne    2bf0 <bigfile+0x50>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2c33:	89 34 24             	mov    %esi,(%esp)
    2c36:	e8 d5 0c 00 00       	call   3910 <close>

  fd = open("bigfile", 0);
    2c3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2c42:	00 
    2c43:	c7 04 24 c5 4a 00 00 	movl   $0x4ac5,(%esp)
    2c4a:	e8 d9 0c 00 00       	call   3928 <open>
  if(fd < 0){
    2c4f:	85 c0                	test   %eax,%eax
      exit();
    }
  }
  close(fd);

  fd = open("bigfile", 0);
    2c51:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    2c53:	0f 88 f4 00 00 00    	js     2d4d <bigfile+0x1ad>
    printf(1, "cannot open bigfile\n");
    exit();
    2c59:	31 f6                	xor    %esi,%esi
    2c5b:	31 db                	xor    %ebx,%ebx
    2c5d:	eb 2f                	jmp    2c8e <bigfile+0xee>
    2c5f:	90                   	nop
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
    2c60:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    2c65:	0f 85 97 00 00 00    	jne    2d02 <bigfile+0x162>
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    2c6b:	0f be 05 e0 7b 00 00 	movsbl 0x7be0,%eax
    2c72:	89 da                	mov    %ebx,%edx
    2c74:	d1 fa                	sar    %edx
    2c76:	39 d0                	cmp    %edx,%eax
    2c78:	75 6f                	jne    2ce9 <bigfile+0x149>
    2c7a:	0f be 15 0b 7d 00 00 	movsbl 0x7d0b,%edx
    2c81:	39 d0                	cmp    %edx,%eax
    2c83:	75 64                	jne    2ce9 <bigfile+0x149>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
    2c85:	81 c6 2c 01 00 00    	add    $0x12c,%esi
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    2c8b:	83 c3 01             	add    $0x1,%ebx
    cc = read(fd, buf, 300);
    2c8e:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    2c95:	00 
    2c96:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    2c9d:	00 
    2c9e:	89 3c 24             	mov    %edi,(%esp)
    2ca1:	e8 5a 0c 00 00       	call   3900 <read>
    if(cc < 0){
    2ca6:	83 f8 00             	cmp    $0x0,%eax
    2ca9:	7c 70                	jl     2d1b <bigfile+0x17b>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
    2cab:	75 b3                	jne    2c60 <bigfile+0xc0>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    2cad:	89 3c 24             	mov    %edi,(%esp)
    2cb0:	e8 5b 0c 00 00       	call   3910 <close>
  if(total != 20*600){
    2cb5:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
    2cbb:	0f 85 be 00 00 00    	jne    2d7f <bigfile+0x1df>
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
    2cc1:	c7 04 24 c5 4a 00 00 	movl   $0x4ac5,(%esp)
    2cc8:	e8 6b 0c 00 00       	call   3938 <unlink>

  printf(1, "bigfile test ok\n");
    2ccd:	c7 44 24 04 54 4b 00 	movl   $0x4b54,0x4(%esp)
    2cd4:	00 
    2cd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cdc:	e8 4f 0d 00 00       	call   3a30 <printf>
}
    2ce1:	83 c4 1c             	add    $0x1c,%esp
    2ce4:	5b                   	pop    %ebx
    2ce5:	5e                   	pop    %esi
    2ce6:	5f                   	pop    %edi
    2ce7:	5d                   	pop    %ebp
    2ce8:	c3                   	ret    
    if(cc != 300){
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
    2ce9:	c7 44 24 04 21 4b 00 	movl   $0x4b21,0x4(%esp)
    2cf0:	00 
    2cf1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cf8:	e8 33 0d 00 00       	call   3a30 <printf>
      exit();
    2cfd:	e8 e6 0b 00 00       	call   38e8 <exit>
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
      printf(1, "short read bigfile\n");
    2d02:	c7 44 24 04 0d 4b 00 	movl   $0x4b0d,0x4(%esp)
    2d09:	00 
    2d0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d11:	e8 1a 0d 00 00       	call   3a30 <printf>
      exit();
    2d16:	e8 cd 0b 00 00       	call   38e8 <exit>
  }
  total = 0;
  for(i = 0; ; i++){
    cc = read(fd, buf, 300);
    if(cc < 0){
      printf(1, "read bigfile failed\n");
    2d1b:	c7 44 24 04 f8 4a 00 	movl   $0x4af8,0x4(%esp)
    2d22:	00 
    2d23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d2a:	e8 01 0d 00 00       	call   3a30 <printf>
      exit();
    2d2f:	e8 b4 0b 00 00       	call   38e8 <exit>
    exit();
  }
  for(i = 0; i < 20; i++){
    memset(buf, i, 600);
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
    2d34:	c7 44 24 04 cd 4a 00 	movl   $0x4acd,0x4(%esp)
    2d3b:	00 
    2d3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d43:	e8 e8 0c 00 00       	call   3a30 <printf>
      exit();
    2d48:	e8 9b 0b 00 00       	call   38e8 <exit>
  }
  close(fd);

  fd = open("bigfile", 0);
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    2d4d:	c7 44 24 04 e3 4a 00 	movl   $0x4ae3,0x4(%esp)
    2d54:	00 
    2d55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d5c:	e8 cf 0c 00 00       	call   3a30 <printf>
    exit();
    2d61:	e8 82 0b 00 00       	call   38e8 <exit>
  printf(1, "bigfile test\n");

  unlink("bigfile");
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    2d66:	c7 44 24 04 b7 4a 00 	movl   $0x4ab7,0x4(%esp)
    2d6d:	00 
    2d6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d75:	e8 b6 0c 00 00       	call   3a30 <printf>
    exit();
    2d7a:	e8 69 0b 00 00       	call   38e8 <exit>
    }
    total += cc;
  }
  close(fd);
  if(total != 20*600){
    printf(1, "read bigfile wrong total\n");
    2d7f:	c7 44 24 04 3a 4b 00 	movl   $0x4b3a,0x4(%esp)
    2d86:	00 
    2d87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d8e:	e8 9d 0c 00 00       	call   3a30 <printf>
    exit();
    2d93:	e8 50 0b 00 00       	call   38e8 <exit>
    2d98:	90                   	nop
    2d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00002da0 <concreate>:
}

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    2da0:	55                   	push   %ebp
    2da1:	89 e5                	mov    %esp,%ebp
    2da3:	57                   	push   %edi
    2da4:	56                   	push   %esi
    2da5:	53                   	push   %ebx
    char name[14];
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
    2da6:	31 db                	xor    %ebx,%ebx
}

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    2da8:	83 ec 6c             	sub    $0x6c,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    2dab:	c7 44 24 04 65 4b 00 	movl   $0x4b65,0x4(%esp)
    2db2:	00 
    2db3:	8d 75 e5             	lea    -0x1b(%ebp),%esi
    2db6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dbd:	e8 6e 0c 00 00       	call   3a30 <printf>
  file[0] = 'C';
    2dc2:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    2dc6:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
    2dca:	eb 4f                	jmp    2e1b <concreate+0x7b>
    2dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
    2dd0:	b8 56 55 55 55       	mov    $0x55555556,%eax
    2dd5:	f7 eb                	imul   %ebx
    2dd7:	89 d8                	mov    %ebx,%eax
    2dd9:	c1 f8 1f             	sar    $0x1f,%eax
    2ddc:	29 c2                	sub    %eax,%edx
    2dde:	8d 04 52             	lea    (%edx,%edx,2),%eax
    2de1:	89 da                	mov    %ebx,%edx
    2de3:	29 c2                	sub    %eax,%edx
    2de5:	83 fa 01             	cmp    $0x1,%edx
    2de8:	74 7e                	je     2e68 <concreate+0xc8>
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    2dea:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2df1:	00 
    2df2:	89 34 24             	mov    %esi,(%esp)
    2df5:	e8 2e 0b 00 00       	call   3928 <open>
      if(fd < 0){
    2dfa:	85 c0                	test   %eax,%eax
    2dfc:	0f 88 53 02 00 00    	js     3055 <concreate+0x2b5>
        printf(1, "concreate create %s failed\n", file);
        exit();
      }
      close(fd);
    2e02:	89 04 24             	mov    %eax,(%esp)
    2e05:	e8 06 0b 00 00       	call   3910 <close>
    }
    if(pid == 0)
    2e0a:	85 ff                	test   %edi,%edi
    2e0c:	74 52                	je     2e60 <concreate+0xc0>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    2e0e:	83 c3 01             	add    $0x1,%ebx
      close(fd);
    }
    if(pid == 0)
      exit();
    else
      wait();
    2e11:	e8 da 0a 00 00       	call   38f0 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    2e16:	83 fb 28             	cmp    $0x28,%ebx
    2e19:	74 6d                	je     2e88 <concreate+0xe8>
    file[1] = '0' + i;
    2e1b:	8d 43 30             	lea    0x30(%ebx),%eax
    2e1e:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    2e21:	89 34 24             	mov    %esi,(%esp)
    2e24:	e8 0f 0b 00 00       	call   3938 <unlink>
    pid = fork();
    2e29:	e8 b2 0a 00 00       	call   38e0 <fork>
    if(pid && (i % 3) == 1){
    2e2e:	85 c0                	test   %eax,%eax
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    2e30:	89 c7                	mov    %eax,%edi
    if(pid && (i % 3) == 1){
    2e32:	75 9c                	jne    2dd0 <concreate+0x30>
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
    2e34:	b8 67 66 66 66       	mov    $0x66666667,%eax
    2e39:	f7 eb                	imul   %ebx
    2e3b:	89 d8                	mov    %ebx,%eax
    2e3d:	c1 f8 1f             	sar    $0x1f,%eax
    2e40:	d1 fa                	sar    %edx
    2e42:	29 c2                	sub    %eax,%edx
    2e44:	8d 04 92             	lea    (%edx,%edx,4),%eax
    2e47:	89 da                	mov    %ebx,%edx
    2e49:	29 c2                	sub    %eax,%edx
    2e4b:	83 fa 01             	cmp    $0x1,%edx
    2e4e:	75 9a                	jne    2dea <concreate+0x4a>
      link("C0", file);
    2e50:	89 74 24 04          	mov    %esi,0x4(%esp)
    2e54:	c7 04 24 75 4b 00 00 	movl   $0x4b75,(%esp)
    2e5b:	e8 e8 0a 00 00       	call   3948 <link>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
        exit();
    2e60:	e8 83 0a 00 00       	call   38e8 <exit>
    2e65:	8d 76 00             	lea    0x0(%esi),%esi
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    2e68:	83 c3 01             	add    $0x1,%ebx
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
      link("C0", file);
    2e6b:	89 74 24 04          	mov    %esi,0x4(%esp)
    2e6f:	c7 04 24 75 4b 00 00 	movl   $0x4b75,(%esp)
    2e76:	e8 cd 0a 00 00       	call   3948 <link>
      close(fd);
    }
    if(pid == 0)
      exit();
    else
      wait();
    2e7b:	e8 70 0a 00 00       	call   38f0 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    2e80:	83 fb 28             	cmp    $0x28,%ebx
    2e83:	75 96                	jne    2e1b <concreate+0x7b>
    2e85:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    2e88:	8d 45 ac             	lea    -0x54(%ebp),%eax
    2e8b:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    2e92:	00 
    2e93:	8d 7d d4             	lea    -0x2c(%ebp),%edi
    2e96:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2e9d:	00 
    2e9e:	89 04 24             	mov    %eax,(%esp)
    2ea1:	e8 ba 08 00 00       	call   3760 <memset>
  fd = open(".", 0);
    2ea6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2ead:	00 
    2eae:	c7 04 24 6b 48 00 00 	movl   $0x486b,(%esp)
    2eb5:	e8 6e 0a 00 00       	call   3928 <open>
    2eba:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
    2ec1:	89 c3                	mov    %eax,%ebx
    2ec3:	90                   	nop
    2ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    2ec8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    2ecf:	00 
    2ed0:	89 7c 24 04          	mov    %edi,0x4(%esp)
    2ed4:	89 1c 24             	mov    %ebx,(%esp)
    2ed7:	e8 24 0a 00 00       	call   3900 <read>
    2edc:	85 c0                	test   %eax,%eax
    2ede:	7e 40                	jle    2f20 <concreate+0x180>
    if(de.inum == 0)
    2ee0:	66 83 7d d4 00       	cmpw   $0x0,-0x2c(%ebp)
    2ee5:	74 e1                	je     2ec8 <concreate+0x128>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    2ee7:	80 7d d6 43          	cmpb   $0x43,-0x2a(%ebp)
    2eeb:	75 db                	jne    2ec8 <concreate+0x128>
    2eed:	80 7d d8 00          	cmpb   $0x0,-0x28(%ebp)
    2ef1:	75 d5                	jne    2ec8 <concreate+0x128>
      i = de.name[1] - '0';
    2ef3:	0f be 45 d7          	movsbl -0x29(%ebp),%eax
    2ef7:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    2efa:	83 f8 27             	cmp    $0x27,%eax
    2efd:	0f 87 6f 01 00 00    	ja     3072 <concreate+0x2d2>
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
    2f03:	80 7c 05 ac 00       	cmpb   $0x0,-0x54(%ebp,%eax,1)
    2f08:	0f 85 9d 01 00 00    	jne    30ab <concreate+0x30b>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    2f0e:	c6 44 05 ac 01       	movb   $0x1,-0x54(%ebp,%eax,1)
      n++;
    2f13:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
    2f17:	eb af                	jmp    2ec8 <concreate+0x128>
    2f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }
  close(fd);
    2f20:	89 1c 24             	mov    %ebx,(%esp)
    2f23:	e8 e8 09 00 00       	call   3910 <close>

  if(n != 40){
    2f28:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    2f2c:	0f 85 60 01 00 00    	jne    3092 <concreate+0x2f2>
    printf(1, "concreate not enough files in directory listing\n");
    exit();
    2f32:	31 db                	xor    %ebx,%ebx
    2f34:	e9 8d 00 00 00       	jmp    2fc6 <concreate+0x226>
    2f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    2f40:	83 f8 01             	cmp    $0x1,%eax
    2f43:	0f 85 b1 00 00 00    	jne    2ffa <concreate+0x25a>
    2f49:	85 ff                	test   %edi,%edi
    2f4b:	0f 84 a9 00 00 00    	je     2ffa <concreate+0x25a>
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    2f51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2f58:	00 
    2f59:	89 34 24             	mov    %esi,(%esp)
    2f5c:	e8 c7 09 00 00       	call   3928 <open>
    2f61:	89 04 24             	mov    %eax,(%esp)
    2f64:	e8 a7 09 00 00       	call   3910 <close>
      close(open(file, 0));
    2f69:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2f70:	00 
    2f71:	89 34 24             	mov    %esi,(%esp)
    2f74:	e8 af 09 00 00       	call   3928 <open>
    2f79:	89 04 24             	mov    %eax,(%esp)
    2f7c:	e8 8f 09 00 00       	call   3910 <close>
      close(open(file, 0));
    2f81:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2f88:	00 
    2f89:	89 34 24             	mov    %esi,(%esp)
    2f8c:	e8 97 09 00 00       	call   3928 <open>
    2f91:	89 04 24             	mov    %eax,(%esp)
    2f94:	e8 77 09 00 00       	call   3910 <close>
      close(open(file, 0));
    2f99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2fa0:	00 
    2fa1:	89 34 24             	mov    %esi,(%esp)
    2fa4:	e8 7f 09 00 00       	call   3928 <open>
    2fa9:	89 04 24             	mov    %eax,(%esp)
    2fac:	e8 5f 09 00 00       	call   3910 <close>
      unlink(file);
      unlink(file);
      unlink(file);
      unlink(file);
    }
    if(pid == 0)
    2fb1:	85 ff                	test   %edi,%edi
    2fb3:	0f 84 a7 fe ff ff    	je     2e60 <concreate+0xc0>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    2fb9:	83 c3 01             	add    $0x1,%ebx
      unlink(file);
    }
    if(pid == 0)
      exit();
    else
      wait();
    2fbc:	e8 2f 09 00 00       	call   38f0 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    2fc1:	83 fb 28             	cmp    $0x28,%ebx
    2fc4:	74 5a                	je     3020 <concreate+0x280>
    file[1] = '0' + i;
    2fc6:	8d 43 30             	lea    0x30(%ebx),%eax
    2fc9:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    2fcc:	e8 0f 09 00 00       	call   38e0 <fork>
    if(pid < 0){
    2fd1:	85 c0                	test   %eax,%eax
    exit();
  }

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    pid = fork();
    2fd3:	89 c7                	mov    %eax,%edi
    if(pid < 0){
    2fd5:	78 65                	js     303c <concreate+0x29c>
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    2fd7:	b8 56 55 55 55       	mov    $0x55555556,%eax
    2fdc:	f7 eb                	imul   %ebx
    2fde:	89 d8                	mov    %ebx,%eax
    2fe0:	c1 f8 1f             	sar    $0x1f,%eax
    2fe3:	29 c2                	sub    %eax,%edx
    2fe5:	89 d8                	mov    %ebx,%eax
    2fe7:	8d 14 52             	lea    (%edx,%edx,2),%edx
    2fea:	29 d0                	sub    %edx,%eax
    2fec:	0f 85 4e ff ff ff    	jne    2f40 <concreate+0x1a0>
    2ff2:	85 ff                	test   %edi,%edi
    2ff4:	0f 84 57 ff ff ff    	je     2f51 <concreate+0x1b1>
      close(open(file, 0));
      close(open(file, 0));
      close(open(file, 0));
      close(open(file, 0));
    } else {
      unlink(file);
    2ffa:	89 34 24             	mov    %esi,(%esp)
    2ffd:	e8 36 09 00 00       	call   3938 <unlink>
      unlink(file);
    3002:	89 34 24             	mov    %esi,(%esp)
    3005:	e8 2e 09 00 00       	call   3938 <unlink>
      unlink(file);
    300a:	89 34 24             	mov    %esi,(%esp)
    300d:	e8 26 09 00 00       	call   3938 <unlink>
      unlink(file);
    3012:	89 34 24             	mov    %esi,(%esp)
    3015:	e8 1e 09 00 00       	call   3938 <unlink>
    301a:	eb 95                	jmp    2fb1 <concreate+0x211>
    301c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    3020:	c7 44 24 04 ca 4b 00 	movl   $0x4bca,0x4(%esp)
    3027:	00 
    3028:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    302f:	e8 fc 09 00 00       	call   3a30 <printf>
}
    3034:	83 c4 6c             	add    $0x6c,%esp
    3037:	5b                   	pop    %ebx
    3038:	5e                   	pop    %esi
    3039:	5f                   	pop    %edi
    303a:	5d                   	pop    %ebp
    303b:	c3                   	ret    

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
    303c:	c7 44 24 04 0a 3f 00 	movl   $0x3f0a,0x4(%esp)
    3043:	00 
    3044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    304b:	e8 e0 09 00 00       	call   3a30 <printf>
      exit();
    3050:	e8 93 08 00 00       	call   38e8 <exit>
    } else if(pid == 0 && (i % 5) == 1){
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
      if(fd < 0){
        printf(1, "concreate create %s failed\n", file);
    3055:	89 74 24 08          	mov    %esi,0x8(%esp)
    3059:	c7 44 24 04 78 4b 00 	movl   $0x4b78,0x4(%esp)
    3060:	00 
    3061:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3068:	e8 c3 09 00 00       	call   3a30 <printf>
        exit();
    306d:	e8 76 08 00 00       	call   38e8 <exit>
    if(de.inum == 0)
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
    3072:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    3075:	89 44 24 08          	mov    %eax,0x8(%esp)
    3079:	c7 44 24 04 94 4b 00 	movl   $0x4b94,0x4(%esp)
    3080:	00 
    3081:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3088:	e8 a3 09 00 00       	call   3a30 <printf>
    308d:	e9 ce fd ff ff       	jmp    2e60 <concreate+0xc0>
    }
  }
  close(fd);

  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    3092:	c7 44 24 04 10 53 00 	movl   $0x5310,0x4(%esp)
    3099:	00 
    309a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30a1:	e8 8a 09 00 00       	call   3a30 <printf>
    exit();
    30a6:	e8 3d 08 00 00       	call   38e8 <exit>
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
        printf(1, "concreate duplicate file %s\n", de.name);
    30ab:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    30ae:	89 44 24 08          	mov    %eax,0x8(%esp)
    30b2:	c7 44 24 04 ad 4b 00 	movl   $0x4bad,0x4(%esp)
    30b9:	00 
    30ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30c1:	e8 6a 09 00 00       	call   3a30 <printf>
        exit();
    30c6:	e8 1d 08 00 00       	call   38e8 <exit>
    30cb:	90                   	nop
    30cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000030d0 <twofiles>:

// two processes write two different files at the same
// time, to test block allocation.
void
twofiles(void)
{
    30d0:	55                   	push   %ebp
    30d1:	89 e5                	mov    %esp,%ebp
    30d3:	57                   	push   %edi
    30d4:	56                   	push   %esi
    30d5:	53                   	push   %ebx
    30d6:	83 ec 2c             	sub    $0x2c,%esp
  int fd, pid, i, j, n, total;
  char *fname;

  printf(1, "twofiles test\n");
    30d9:	c7 44 24 04 d8 4b 00 	movl   $0x4bd8,0x4(%esp)
    30e0:	00 
    30e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30e8:	e8 43 09 00 00       	call   3a30 <printf>

  unlink("f1");
    30ed:	c7 04 24 4a 41 00 00 	movl   $0x414a,(%esp)
    30f4:	e8 3f 08 00 00       	call   3938 <unlink>
  unlink("f2");
    30f9:	c7 04 24 4e 41 00 00 	movl   $0x414e,(%esp)
    3100:	e8 33 08 00 00       	call   3938 <unlink>

  pid = fork();
    3105:	e8 d6 07 00 00       	call   38e0 <fork>
  if(pid < 0){
    310a:	83 f8 00             	cmp    $0x0,%eax
  printf(1, "twofiles test\n");

  unlink("f1");
  unlink("f2");

  pid = fork();
    310d:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    310f:	0f 8c 8d 01 00 00    	jl     32a2 <twofiles+0x1d2>
    printf(1, "fork failed\n");
    exit();
  }

  fname = pid ? "f1" : "f2";
    3115:	ba 4a 41 00 00       	mov    $0x414a,%edx
    311a:	b8 4e 41 00 00       	mov    $0x414e,%eax
    311f:	0f 45 c2             	cmovne %edx,%eax
  fd = open(fname, O_CREATE | O_RDWR);
    3122:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    3129:	00 
    312a:	89 04 24             	mov    %eax,(%esp)
    312d:	e8 f6 07 00 00       	call   3928 <open>
  if(fd < 0){
    3132:	85 c0                	test   %eax,%eax
    printf(1, "fork failed\n");
    exit();
  }

  fname = pid ? "f1" : "f2";
  fd = open(fname, O_CREATE | O_RDWR);
    3134:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    3136:	0f 88 7f 01 00 00    	js     32bb <twofiles+0x1eb>
    printf(1, "create failed\n");
    exit();
  }

  memset(buf, pid?'p':'c', 512);
    313c:	83 ff 01             	cmp    $0x1,%edi
    313f:	19 c0                	sbb    %eax,%eax
    3141:	31 db                	xor    %ebx,%ebx
    3143:	83 e0 f3             	and    $0xfffffff3,%eax
    3146:	83 c0 70             	add    $0x70,%eax
    3149:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    3150:	00 
    3151:	89 44 24 04          	mov    %eax,0x4(%esp)
    3155:	c7 04 24 e0 7b 00 00 	movl   $0x7be0,(%esp)
    315c:	e8 ff 05 00 00       	call   3760 <memset>
    3161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < 12; i++){
    if((n = write(fd, buf, 500)) != 500){
    3168:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    316f:	00 
    3170:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    3177:	00 
    3178:	89 34 24             	mov    %esi,(%esp)
    317b:	e8 88 07 00 00       	call   3908 <write>
    3180:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    3185:	0f 85 fa 00 00 00    	jne    3285 <twofiles+0x1b5>
    printf(1, "create failed\n");
    exit();
  }

  memset(buf, pid?'p':'c', 512);
  for(i = 0; i < 12; i++){
    318b:	83 c3 01             	add    $0x1,%ebx
    318e:	83 fb 0c             	cmp    $0xc,%ebx
    3191:	75 d5                	jne    3168 <twofiles+0x98>
    if((n = write(fd, buf, 500)) != 500){
      printf(1, "write failed %d\n", n);
      exit();
    }
  }
  close(fd);
    3193:	89 34 24             	mov    %esi,(%esp)
    3196:	e8 75 07 00 00       	call   3910 <close>
  if(pid)
    319b:	85 ff                	test   %edi,%edi
    319d:	0f 84 dd 00 00 00    	je     3280 <twofiles+0x1b0>
    wait();
    31a3:	e8 48 07 00 00       	call   38f0 <wait>
    31a8:	30 db                	xor    %bl,%bl
    31aa:	b8 4e 41 00 00       	mov    $0x414e,%eax
  else
    exit();

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    31af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    31b6:	00 
    31b7:	31 f6                	xor    %esi,%esi
    31b9:	89 04 24             	mov    %eax,(%esp)
    31bc:	e8 67 07 00 00       	call   3928 <open>
    31c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    31c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    31c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    31cb:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    31d2:	00 
    31d3:	c7 44 24 04 e0 7b 00 	movl   $0x7be0,0x4(%esp)
    31da:	00 
    31db:	89 04 24             	mov    %eax,(%esp)
    31de:	e8 1d 07 00 00       	call   3900 <read>
    31e3:	85 c0                	test   %eax,%eax
    31e5:	7e 2a                	jle    3211 <twofiles+0x141>
    31e7:	31 c9                	xor    %ecx,%ecx
    31e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(j = 0; j < n; j++){
        if(buf[j] != (i?'p':'c')){
    31f0:	83 fb 01             	cmp    $0x1,%ebx
    31f3:	0f be b9 e0 7b 00 00 	movsbl 0x7be0(%ecx),%edi
    31fa:	19 d2                	sbb    %edx,%edx
    31fc:	83 e2 f3             	and    $0xfffffff3,%edx
    31ff:	83 c2 70             	add    $0x70,%edx
    3202:	39 d7                	cmp    %edx,%edi
    3204:	75 66                	jne    326c <twofiles+0x19c>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    3206:	83 c1 01             	add    $0x1,%ecx
    3209:	39 c8                	cmp    %ecx,%eax
    320b:	7f e3                	jg     31f0 <twofiles+0x120>
        if(buf[j] != (i?'p':'c')){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    320d:	01 c6                	add    %eax,%esi
    320f:	eb b7                	jmp    31c8 <twofiles+0xf8>
    }
    close(fd);
    3211:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3214:	89 04 24             	mov    %eax,(%esp)
    3217:	e8 f4 06 00 00       	call   3910 <close>
    if(total != 12*500){
    321c:	81 fe 70 17 00 00    	cmp    $0x1770,%esi
    3222:	0f 85 ac 00 00 00    	jne    32d4 <twofiles+0x204>
  if(pid)
    wait();
  else
    exit();

  for(i = 0; i < 2; i++){
    3228:	83 fb 01             	cmp    $0x1,%ebx
      total += n;
    }
    close(fd);
    if(total != 12*500){
      printf(1, "wrong length %d\n", total);
      exit();
    322b:	b8 4a 41 00 00       	mov    $0x414a,%eax
  if(pid)
    wait();
  else
    exit();

  for(i = 0; i < 2; i++){
    3230:	75 30                	jne    3262 <twofiles+0x192>
      printf(1, "wrong length %d\n", total);
      exit();
    }
  }

  unlink("f1");
    3232:	89 04 24             	mov    %eax,(%esp)
    3235:	e8 fe 06 00 00       	call   3938 <unlink>
  unlink("f2");
    323a:	c7 04 24 4e 41 00 00 	movl   $0x414e,(%esp)
    3241:	e8 f2 06 00 00       	call   3938 <unlink>

  printf(1, "twofiles ok\n");
    3246:	c7 44 24 04 15 4c 00 	movl   $0x4c15,0x4(%esp)
    324d:	00 
    324e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3255:	e8 d6 07 00 00       	call   3a30 <printf>
}
    325a:	83 c4 2c             	add    $0x2c,%esp
    325d:	5b                   	pop    %ebx
    325e:	5e                   	pop    %esi
    325f:	5f                   	pop    %edi
    3260:	5d                   	pop    %ebp
    3261:	c3                   	ret    
  }
  close(fd);
  if(pid)
    wait();
  else
    exit();
    3262:	bb 01 00 00 00       	mov    $0x1,%ebx
    3267:	e9 43 ff ff ff       	jmp    31af <twofiles+0xdf>
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
        if(buf[j] != (i?'p':'c')){
          printf(1, "wrong char\n");
    326c:	c7 44 24 04 f8 4b 00 	movl   $0x4bf8,0x4(%esp)
    3273:	00 
    3274:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    327b:	e8 b0 07 00 00       	call   3a30 <printf>
          exit();
    3280:	e8 63 06 00 00       	call   38e8 <exit>
  }

  memset(buf, pid?'p':'c', 512);
  for(i = 0; i < 12; i++){
    if((n = write(fd, buf, 500)) != 500){
      printf(1, "write failed %d\n", n);
    3285:	89 44 24 08          	mov    %eax,0x8(%esp)
    3289:	c7 44 24 04 e7 4b 00 	movl   $0x4be7,0x4(%esp)
    3290:	00 
    3291:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3298:	e8 93 07 00 00       	call   3a30 <printf>
      exit();
    329d:	e8 46 06 00 00       	call   38e8 <exit>
  unlink("f1");
  unlink("f2");

  pid = fork();
  if(pid < 0){
    printf(1, "fork failed\n");
    32a2:	c7 44 24 04 0a 3f 00 	movl   $0x3f0a,0x4(%esp)
    32a9:	00 
    32aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    32b1:	e8 7a 07 00 00       	call   3a30 <printf>
    exit();
    32b6:	e8 2d 06 00 00       	call   38e8 <exit>
  }

  fname = pid ? "f1" : "f2";
  fd = open(fname, O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create failed\n");
    32bb:	c7 44 24 04 13 40 00 	movl   $0x4013,0x4(%esp)
    32c2:	00 
    32c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    32ca:	e8 61 07 00 00       	call   3a30 <printf>
    exit();
    32cf:	e8 14 06 00 00       	call   38e8 <exit>
      }
      total += n;
    }
    close(fd);
    if(total != 12*500){
      printf(1, "wrong length %d\n", total);
    32d4:	89 74 24 08          	mov    %esi,0x8(%esp)
    32d8:	c7 44 24 04 04 4c 00 	movl   $0x4c04,0x4(%esp)
    32df:	00 
    32e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    32e7:	e8 44 07 00 00       	call   3a30 <printf>
      exit();
    32ec:	e8 f7 05 00 00       	call   38e8 <exit>
    32f1:	eb 0d                	jmp    3300 <sharedfd>
    32f3:	90                   	nop
    32f4:	90                   	nop
    32f5:	90                   	nop
    32f6:	90                   	nop
    32f7:	90                   	nop
    32f8:	90                   	nop
    32f9:	90                   	nop
    32fa:	90                   	nop
    32fb:	90                   	nop
    32fc:	90                   	nop
    32fd:	90                   	nop
    32fe:	90                   	nop
    32ff:	90                   	nop

00003300 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    3300:	55                   	push   %ebp
    3301:	89 e5                	mov    %esp,%ebp
    3303:	57                   	push   %edi
    3304:	56                   	push   %esi
    3305:	53                   	push   %ebx
    3306:	83 ec 3c             	sub    $0x3c,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
    3309:	c7 44 24 04 22 4c 00 	movl   $0x4c22,0x4(%esp)
    3310:	00 
    3311:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3318:	e8 13 07 00 00       	call   3a30 <printf>

  unlink("sharedfd");
    331d:	c7 04 24 31 4c 00 00 	movl   $0x4c31,(%esp)
    3324:	e8 0f 06 00 00       	call   3938 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3329:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    3330:	00 
    3331:	c7 04 24 31 4c 00 00 	movl   $0x4c31,(%esp)
    3338:	e8 eb 05 00 00       	call   3928 <open>
  if(fd < 0){
    333d:	85 c0                	test   %eax,%eax
  char buf[10];

  printf(1, "sharedfd test\n");

  unlink("sharedfd");
  fd = open("sharedfd", O_CREATE|O_RDWR);
    333f:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    3341:	0f 88 2d 01 00 00    	js     3474 <sharedfd+0x174>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    3347:	e8 94 05 00 00       	call   38e0 <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
    334c:	8d 75 de             	lea    -0x22(%ebp),%esi
    334f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    3356:	00 
    3357:	89 34 24             	mov    %esi,(%esp)
    335a:	83 f8 01             	cmp    $0x1,%eax
  fd = open("sharedfd", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    335d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3360:	19 c0                	sbb    %eax,%eax
    3362:	31 db                	xor    %ebx,%ebx
    3364:	83 e0 f3             	and    $0xfffffff3,%eax
    3367:	83 c0 70             	add    $0x70,%eax
    336a:	89 44 24 04          	mov    %eax,0x4(%esp)
    336e:	e8 ed 03 00 00       	call   3760 <memset>
    3373:	eb 0e                	jmp    3383 <sharedfd+0x83>
    3375:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < 1000; i++){
    3378:	83 c3 01             	add    $0x1,%ebx
    337b:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    3381:	74 2d                	je     33b0 <sharedfd+0xb0>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3383:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    338a:	00 
    338b:	89 74 24 04          	mov    %esi,0x4(%esp)
    338f:	89 3c 24             	mov    %edi,(%esp)
    3392:	e8 71 05 00 00       	call   3908 <write>
    3397:	83 f8 0a             	cmp    $0xa,%eax
    339a:	74 dc                	je     3378 <sharedfd+0x78>
      printf(1, "fstests: write sharedfd failed\n");
    339c:	c7 44 24 04 70 53 00 	movl   $0x5370,0x4(%esp)
    33a3:	00 
    33a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    33ab:	e8 80 06 00 00       	call   3a30 <printf>
      break;
    }
  }
  if(pid == 0)
    33b0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    33b3:	85 c9                	test   %ecx,%ecx
    33b5:	0f 84 07 01 00 00    	je     34c2 <sharedfd+0x1c2>
    exit();
  else
    wait();
    33bb:	e8 30 05 00 00       	call   38f0 <wait>
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    33c0:	31 db                	xor    %ebx,%ebx
  }
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
    33c2:	89 3c 24             	mov    %edi,(%esp)
  fd = open("sharedfd", 0);
  if(fd < 0){
    33c5:	31 ff                	xor    %edi,%edi
  }
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
    33c7:	e8 44 05 00 00       	call   3910 <close>
  fd = open("sharedfd", 0);
    33cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    33d3:	00 
    33d4:	c7 04 24 31 4c 00 00 	movl   $0x4c31,(%esp)
    33db:	e8 48 05 00 00       	call   3928 <open>
  if(fd < 0){
    33e0:	85 c0                	test   %eax,%eax
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
  fd = open("sharedfd", 0);
    33e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  if(fd < 0){
    33e5:	0f 88 a5 00 00 00    	js     3490 <sharedfd+0x190>
    33eb:	90                   	nop
    33ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    33f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    33f3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    33fa:	00 
    33fb:	89 74 24 04          	mov    %esi,0x4(%esp)
    33ff:	89 04 24             	mov    %eax,(%esp)
    3402:	e8 f9 04 00 00       	call   3900 <read>
    3407:	85 c0                	test   %eax,%eax
    3409:	7e 26                	jle    3431 <sharedfd+0x131>
    wait();
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
    340b:	31 c0                	xor    %eax,%eax
    340d:	eb 14                	jmp    3423 <sharedfd+0x123>
    340f:	90                   	nop
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
        nc++;
      if(buf[i] == 'p')
        np++;
    3410:	80 fa 70             	cmp    $0x70,%dl
    3413:	0f 94 c2             	sete   %dl
    3416:	0f b6 d2             	movzbl %dl,%edx
    3419:	01 d3                	add    %edx,%ebx
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
    341b:	83 c0 01             	add    $0x1,%eax
    341e:	83 f8 0a             	cmp    $0xa,%eax
    3421:	74 cd                	je     33f0 <sharedfd+0xf0>
      if(buf[i] == 'c')
    3423:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
    3427:	80 fa 63             	cmp    $0x63,%dl
    342a:	75 e4                	jne    3410 <sharedfd+0x110>
        nc++;
    342c:	83 c7 01             	add    $0x1,%edi
    342f:	eb ea                	jmp    341b <sharedfd+0x11b>
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
    3431:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3434:	89 04 24             	mov    %eax,(%esp)
    3437:	e8 d4 04 00 00       	call   3910 <close>
  unlink("sharedfd");
    343c:	c7 04 24 31 4c 00 00 	movl   $0x4c31,(%esp)
    3443:	e8 f0 04 00 00       	call   3938 <unlink>
  if(nc == 10000 && np == 10000){
    3448:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
    344e:	75 56                	jne    34a6 <sharedfd+0x1a6>
    3450:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
    3456:	75 4e                	jne    34a6 <sharedfd+0x1a6>
    printf(1, "sharedfd ok\n");
    3458:	c7 44 24 04 3a 4c 00 	movl   $0x4c3a,0x4(%esp)
    345f:	00 
    3460:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3467:	e8 c4 05 00 00       	call   3a30 <printf>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
    346c:	83 c4 3c             	add    $0x3c,%esp
    346f:	5b                   	pop    %ebx
    3470:	5e                   	pop    %esi
    3471:	5f                   	pop    %edi
    3472:	5d                   	pop    %ebp
    3473:	c3                   	ret    
  printf(1, "sharedfd test\n");

  unlink("sharedfd");
  fd = open("sharedfd", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for writing");
    3474:	c7 44 24 04 44 53 00 	movl   $0x5344,0x4(%esp)
    347b:	00 
    347c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3483:	e8 a8 05 00 00       	call   3a30 <printf>
    printf(1, "sharedfd ok\n");
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
    3488:	83 c4 3c             	add    $0x3c,%esp
    348b:	5b                   	pop    %ebx
    348c:	5e                   	pop    %esi
    348d:	5f                   	pop    %edi
    348e:	5d                   	pop    %ebp
    348f:	c3                   	ret    
  else
    wait();
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    3490:	c7 44 24 04 90 53 00 	movl   $0x5390,0x4(%esp)
    3497:	00 
    3498:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    349f:	e8 8c 05 00 00       	call   3a30 <printf>
    return;
    34a4:	eb c6                	jmp    346c <sharedfd+0x16c>
  close(fd);
  unlink("sharedfd");
  if(nc == 10000 && np == 10000){
    printf(1, "sharedfd ok\n");
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    34a6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    34aa:	89 7c 24 08          	mov    %edi,0x8(%esp)
    34ae:	c7 44 24 04 47 4c 00 	movl   $0x4c47,0x4(%esp)
    34b5:	00 
    34b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    34bd:	e8 6e 05 00 00       	call   3a30 <printf>
    exit();
    34c2:	e8 21 04 00 00       	call   38e8 <exit>
    34c7:	89 f6                	mov    %esi,%esi
    34c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000034d0 <mem>:
  printf(1, "exitwait ok\n");
}

void
mem(void)
{
    34d0:	55                   	push   %ebp
    34d1:	89 e5                	mov    %esp,%ebp
    34d3:	57                   	push   %edi
    34d4:	56                   	push   %esi
    34d5:	53                   	push   %ebx
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    34d6:	31 db                	xor    %ebx,%ebx
  printf(1, "exitwait ok\n");
}

void
mem(void)
{
    34d8:	83 ec 1c             	sub    $0x1c,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
    34db:	c7 44 24 04 5c 4c 00 	movl   $0x4c5c,0x4(%esp)
    34e2:	00 
    34e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    34ea:	e8 41 05 00 00       	call   3a30 <printf>
  ppid = getpid();
    34ef:	e8 74 04 00 00       	call   3968 <getpid>
    34f4:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
    34f6:	e8 e5 03 00 00       	call   38e0 <fork>
    34fb:	85 c0                	test   %eax,%eax
    34fd:	74 0d                	je     350c <mem+0x3c>
    34ff:	90                   	nop
    3500:	eb 5f                	jmp    3561 <mem+0x91>
    3502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
    3508:	89 18                	mov    %ebx,(%eax)
    350a:	89 c3                	mov    %eax,%ebx

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
    350c:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
    3513:	e8 98 07 00 00       	call   3cb0 <malloc>
    3518:	85 c0                	test   %eax,%eax
    351a:	75 ec                	jne    3508 <mem+0x38>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
    351c:	85 db                	test   %ebx,%ebx
    351e:	74 10                	je     3530 <mem+0x60>
      m2 = *(char**)m1;
    3520:	8b 3b                	mov    (%ebx),%edi
      free(m1);
    3522:	89 1c 24             	mov    %ebx,(%esp)
    3525:	e8 f6 06 00 00       	call   3c20 <free>
    352a:	89 fb                	mov    %edi,%ebx
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
    352c:	85 db                	test   %ebx,%ebx
    352e:	75 f0                	jne    3520 <mem+0x50>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
    3530:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
    3537:	e8 74 07 00 00       	call   3cb0 <malloc>
    if(m1 == 0){
    353c:	85 c0                	test   %eax,%eax
    353e:	74 30                	je     3570 <mem+0xa0>
      printf(1, "couldn't allocate mem?!!\n");
      kill(ppid);
      exit();
    }
    free(m1);
    3540:	89 04 24             	mov    %eax,(%esp)
    3543:	e8 d8 06 00 00       	call   3c20 <free>
    printf(1, "mem ok\n");
    3548:	c7 44 24 04 80 4c 00 	movl   $0x4c80,0x4(%esp)
    354f:	00 
    3550:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3557:	e8 d4 04 00 00       	call   3a30 <printf>
    exit();
    355c:	e8 87 03 00 00       	call   38e8 <exit>
  } else {
    wait();
  }
}
    3561:	83 c4 1c             	add    $0x1c,%esp
    3564:	5b                   	pop    %ebx
    3565:	5e                   	pop    %esi
    3566:	5f                   	pop    %edi
    3567:	5d                   	pop    %ebp
    }
    free(m1);
    printf(1, "mem ok\n");
    exit();
  } else {
    wait();
    3568:	e9 83 03 00 00       	jmp    38f0 <wait>
    356d:	8d 76 00             	lea    0x0(%esi),%esi
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
    if(m1 == 0){
      printf(1, "couldn't allocate mem?!!\n");
    3570:	c7 44 24 04 66 4c 00 	movl   $0x4c66,0x4(%esp)
    3577:	00 
    3578:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    357f:	e8 ac 04 00 00       	call   3a30 <printf>
      kill(ppid);
    3584:	89 34 24             	mov    %esi,(%esp)
    3587:	e8 8c 03 00 00       	call   3918 <kill>
      exit();
    358c:	e8 57 03 00 00       	call   38e8 <exit>
    3591:	eb 0d                	jmp    35a0 <main>
    3593:	90                   	nop
    3594:	90                   	nop
    3595:	90                   	nop
    3596:	90                   	nop
    3597:	90                   	nop
    3598:	90                   	nop
    3599:	90                   	nop
    359a:	90                   	nop
    359b:	90                   	nop
    359c:	90                   	nop
    359d:	90                   	nop
    359e:	90                   	nop
    359f:	90                   	nop

000035a0 <main>:
  return randstate;
}

int
main(int argc, char *argv[])
{
    35a0:	55                   	push   %ebp
    35a1:	89 e5                	mov    %esp,%ebp
    35a3:	83 e4 f0             	and    $0xfffffff0,%esp
    35a6:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    35a9:	c7 44 24 04 88 4c 00 	movl   $0x4c88,0x4(%esp)
    35b0:	00 
    35b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    35b8:	e8 73 04 00 00       	call   3a30 <printf>

  if(open("usertests.ran", 0) >= 0){
    35bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    35c4:	00 
    35c5:	c7 04 24 9c 4c 00 00 	movl   $0x4c9c,(%esp)
    35cc:	e8 57 03 00 00       	call   3928 <open>
    35d1:	85 c0                	test   %eax,%eax
    35d3:	78 1b                	js     35f0 <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    35d5:	c7 44 24 04 bc 53 00 	movl   $0x53bc,0x4(%esp)
    35dc:	00 
    35dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    35e4:	e8 47 04 00 00       	call   3a30 <printf>
    exit();
    35e9:	e8 fa 02 00 00       	call   38e8 <exit>
    35ee:	66 90                	xchg   %ax,%ax
  }
  close(open("usertests.ran", O_CREATE));
    35f0:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    35f7:	00 
    35f8:	c7 04 24 9c 4c 00 00 	movl   $0x4c9c,(%esp)
    35ff:	e8 24 03 00 00       	call   3928 <open>
    3604:	89 04 24             	mov    %eax,(%esp)
    3607:	e8 04 03 00 00       	call   3910 <close>

  bigargtest();
    360c:	e8 4f cf ff ff       	call   560 <bigargtest>
  bigwrite();
    3611:	e8 4a cd ff ff       	call   360 <bigwrite>
  bigargtest();
    3616:	e8 45 cf ff ff       	call   560 <bigargtest>
    361b:	90                   	nop
    361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bsstest();
    3620:	e8 0b ca ff ff       	call   30 <bsstest>
  sbrktest();
    3625:	e8 16 d7 ff ff       	call   d40 <sbrktest>
  validatetest();
    362a:	e8 01 d4 ff ff       	call   a30 <validatetest>
    362f:	90                   	nop

  opentest();
    3630:	e8 7b ca ff ff       	call   b0 <opentest>
  writetest();
    3635:	e8 96 e4 ff ff       	call   1ad0 <writetest>
  writetest1();
    363a:	e8 a1 e2 ff ff       	call   18e0 <writetest1>
    363f:	90                   	nop
  createtest();
    3640:	e8 1b ce ff ff       	call   460 <createtest>

  mem();
    3645:	e8 86 fe ff ff       	call   34d0 <mem>
  pipe1();
    364a:	e8 e1 e0 ff ff       	call   1730 <pipe1>
    364f:	90                   	nop
  preempt();
    3650:	e8 7b df ff ff       	call   15d0 <preempt>
  exitwait();
    3655:	e8 46 d3 ff ff       	call   9a0 <exitwait>

  rmdot();
    365a:	e8 41 eb ff ff       	call   21a0 <rmdot>
    365f:	90                   	nop
  fourteen();
    3660:	e8 7b e6 ff ff       	call   1ce0 <fourteen>
  bigfile();
    3665:	e8 36 f5 ff ff       	call   2ba0 <bigfile>
  subdir();
    366a:	e8 c1 ec ff ff       	call   2330 <subdir>
    366f:	90                   	nop
  concreate();
    3670:	e8 2b f7 ff ff       	call   2da0 <concreate>
  linkunlink();
    3675:	e8 b6 d5 ff ff       	call   c30 <linkunlink>
  linktest();
    367a:	e8 21 db ff ff       	call   11a0 <linktest>
    367f:	90                   	nop
  unlinkread();
    3680:	e8 7b dd ff ff       	call   1400 <unlinkread>
  createdelete();
    3685:	e8 b6 d0 ff ff       	call   740 <createdelete>
  twofiles();
    368a:	e8 41 fa ff ff       	call   30d0 <twofiles>
    368f:	90                   	nop
  sharedfd();
    3690:	e8 6b fc ff ff       	call   3300 <sharedfd>
  dirfile();
    3695:	e8 c6 e8 ff ff       	call   1f60 <dirfile>
  iref();
    369a:	e8 a1 e7 ff ff       	call   1e40 <iref>
    369f:	90                   	nop
  forktest();
    36a0:	e8 cb cf ff ff       	call   670 <forktest>
  bigdir(); // slow
    36a5:	e8 36 d4 ff ff       	call   ae0 <bigdir>

  exectest();
    36aa:	e8 61 ce ff ff       	call   510 <exectest>
    36af:	90                   	nop

  exit();
    36b0:	e8 33 02 00 00       	call   38e8 <exit>
    36b5:	90                   	nop
    36b6:	90                   	nop
    36b7:	90                   	nop
    36b8:	90                   	nop
    36b9:	90                   	nop
    36ba:	90                   	nop
    36bb:	90                   	nop
    36bc:	90                   	nop
    36bd:	90                   	nop
    36be:	90                   	nop
    36bf:	90                   	nop

000036c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    36c0:	55                   	push   %ebp
    36c1:	31 d2                	xor    %edx,%edx
    36c3:	89 e5                	mov    %esp,%ebp
    36c5:	8b 45 08             	mov    0x8(%ebp),%eax
    36c8:	53                   	push   %ebx
    36c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    36cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    36d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
    36d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    36d7:	83 c2 01             	add    $0x1,%edx
    36da:	84 c9                	test   %cl,%cl
    36dc:	75 f2                	jne    36d0 <strcpy+0x10>
    ;
  return os;
}
    36de:	5b                   	pop    %ebx
    36df:	5d                   	pop    %ebp
    36e0:	c3                   	ret    
    36e1:	eb 0d                	jmp    36f0 <strcmp>
    36e3:	90                   	nop
    36e4:	90                   	nop
    36e5:	90                   	nop
    36e6:	90                   	nop
    36e7:	90                   	nop
    36e8:	90                   	nop
    36e9:	90                   	nop
    36ea:	90                   	nop
    36eb:	90                   	nop
    36ec:	90                   	nop
    36ed:	90                   	nop
    36ee:	90                   	nop
    36ef:	90                   	nop

000036f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    36f0:	55                   	push   %ebp
    36f1:	89 e5                	mov    %esp,%ebp
    36f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
    36f6:	53                   	push   %ebx
    36f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    36fa:	0f b6 01             	movzbl (%ecx),%eax
    36fd:	84 c0                	test   %al,%al
    36ff:	75 14                	jne    3715 <strcmp+0x25>
    3701:	eb 25                	jmp    3728 <strcmp+0x38>
    3703:	90                   	nop
    3704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
    3708:	83 c1 01             	add    $0x1,%ecx
    370b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    370e:	0f b6 01             	movzbl (%ecx),%eax
    3711:	84 c0                	test   %al,%al
    3713:	74 13                	je     3728 <strcmp+0x38>
    3715:	0f b6 1a             	movzbl (%edx),%ebx
    3718:	38 d8                	cmp    %bl,%al
    371a:	74 ec                	je     3708 <strcmp+0x18>
    371c:	0f b6 db             	movzbl %bl,%ebx
    371f:	0f b6 c0             	movzbl %al,%eax
    3722:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
    3724:	5b                   	pop    %ebx
    3725:	5d                   	pop    %ebp
    3726:	c3                   	ret    
    3727:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3728:	0f b6 1a             	movzbl (%edx),%ebx
    372b:	31 c0                	xor    %eax,%eax
    372d:	0f b6 db             	movzbl %bl,%ebx
    3730:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
    3732:	5b                   	pop    %ebx
    3733:	5d                   	pop    %ebp
    3734:	c3                   	ret    
    3735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003740 <strlen>:

uint
strlen(char *s)
{
    3740:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
    3741:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    3743:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
    3745:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    3747:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    374a:	80 39 00             	cmpb   $0x0,(%ecx)
    374d:	74 0c                	je     375b <strlen+0x1b>
    374f:	90                   	nop
    3750:	83 c2 01             	add    $0x1,%edx
    3753:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    3757:	89 d0                	mov    %edx,%eax
    3759:	75 f5                	jne    3750 <strlen+0x10>
    ;
  return n;
}
    375b:	5d                   	pop    %ebp
    375c:	c3                   	ret    
    375d:	8d 76 00             	lea    0x0(%esi),%esi

00003760 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3760:	55                   	push   %ebp
    3761:	89 e5                	mov    %esp,%ebp
    3763:	8b 55 08             	mov    0x8(%ebp),%edx
    3766:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    3767:	8b 4d 10             	mov    0x10(%ebp),%ecx
    376a:	8b 45 0c             	mov    0xc(%ebp),%eax
    376d:	89 d7                	mov    %edx,%edi
    376f:	fc                   	cld    
    3770:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3772:	89 d0                	mov    %edx,%eax
    3774:	5f                   	pop    %edi
    3775:	5d                   	pop    %ebp
    3776:	c3                   	ret    
    3777:	89 f6                	mov    %esi,%esi
    3779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003780 <strchr>:

char*
strchr(const char *s, char c)
{
    3780:	55                   	push   %ebp
    3781:	89 e5                	mov    %esp,%ebp
    3783:	8b 45 08             	mov    0x8(%ebp),%eax
    3786:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    378a:	0f b6 10             	movzbl (%eax),%edx
    378d:	84 d2                	test   %dl,%dl
    378f:	75 11                	jne    37a2 <strchr+0x22>
    3791:	eb 15                	jmp    37a8 <strchr+0x28>
    3793:	90                   	nop
    3794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3798:	83 c0 01             	add    $0x1,%eax
    379b:	0f b6 10             	movzbl (%eax),%edx
    379e:	84 d2                	test   %dl,%dl
    37a0:	74 06                	je     37a8 <strchr+0x28>
    if(*s == c)
    37a2:	38 ca                	cmp    %cl,%dl
    37a4:	75 f2                	jne    3798 <strchr+0x18>
      return (char*)s;
  return 0;
}
    37a6:	5d                   	pop    %ebp
    37a7:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    37a8:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
    37aa:	5d                   	pop    %ebp
    37ab:	90                   	nop
    37ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    37b0:	c3                   	ret    
    37b1:	eb 0d                	jmp    37c0 <atoi>
    37b3:	90                   	nop
    37b4:	90                   	nop
    37b5:	90                   	nop
    37b6:	90                   	nop
    37b7:	90                   	nop
    37b8:	90                   	nop
    37b9:	90                   	nop
    37ba:	90                   	nop
    37bb:	90                   	nop
    37bc:	90                   	nop
    37bd:	90                   	nop
    37be:	90                   	nop
    37bf:	90                   	nop

000037c0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
    37c0:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    37c1:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
    37c3:	89 e5                	mov    %esp,%ebp
    37c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
    37c8:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    37c9:	0f b6 11             	movzbl (%ecx),%edx
    37cc:	8d 5a d0             	lea    -0x30(%edx),%ebx
    37cf:	80 fb 09             	cmp    $0x9,%bl
    37d2:	77 1c                	ja     37f0 <atoi+0x30>
    37d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
    37d8:	0f be d2             	movsbl %dl,%edx
    37db:	83 c1 01             	add    $0x1,%ecx
    37de:	8d 04 80             	lea    (%eax,%eax,4),%eax
    37e1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    37e5:	0f b6 11             	movzbl (%ecx),%edx
    37e8:	8d 5a d0             	lea    -0x30(%edx),%ebx
    37eb:	80 fb 09             	cmp    $0x9,%bl
    37ee:	76 e8                	jbe    37d8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
    37f0:	5b                   	pop    %ebx
    37f1:	5d                   	pop    %ebp
    37f2:	c3                   	ret    
    37f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    37f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003800 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3800:	55                   	push   %ebp
    3801:	89 e5                	mov    %esp,%ebp
    3803:	56                   	push   %esi
    3804:	8b 45 08             	mov    0x8(%ebp),%eax
    3807:	53                   	push   %ebx
    3808:	8b 5d 10             	mov    0x10(%ebp),%ebx
    380b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    380e:	85 db                	test   %ebx,%ebx
    3810:	7e 14                	jle    3826 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
    3812:	31 d2                	xor    %edx,%edx
    3814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
    3818:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    381c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    381f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3822:	39 da                	cmp    %ebx,%edx
    3824:	75 f2                	jne    3818 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
    3826:	5b                   	pop    %ebx
    3827:	5e                   	pop    %esi
    3828:	5d                   	pop    %ebp
    3829:	c3                   	ret    
    382a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003830 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
    3830:	55                   	push   %ebp
    3831:	89 e5                	mov    %esp,%ebp
    3833:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3836:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
    3839:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    383c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    383f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3844:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    384b:	00 
    384c:	89 04 24             	mov    %eax,(%esp)
    384f:	e8 d4 00 00 00       	call   3928 <open>
  if(fd < 0)
    3854:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3856:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    3858:	78 19                	js     3873 <stat+0x43>
    return -1;
  r = fstat(fd, st);
    385a:	8b 45 0c             	mov    0xc(%ebp),%eax
    385d:	89 1c 24             	mov    %ebx,(%esp)
    3860:	89 44 24 04          	mov    %eax,0x4(%esp)
    3864:	e8 d7 00 00 00       	call   3940 <fstat>
  close(fd);
    3869:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    386c:	89 c6                	mov    %eax,%esi
  close(fd);
    386e:	e8 9d 00 00 00       	call   3910 <close>
  return r;
}
    3873:	89 f0                	mov    %esi,%eax
    3875:	8b 5d f8             	mov    -0x8(%ebp),%ebx
    3878:	8b 75 fc             	mov    -0x4(%ebp),%esi
    387b:	89 ec                	mov    %ebp,%esp
    387d:	5d                   	pop    %ebp
    387e:	c3                   	ret    
    387f:	90                   	nop

00003880 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
    3880:	55                   	push   %ebp
    3881:	89 e5                	mov    %esp,%ebp
    3883:	57                   	push   %edi
    3884:	56                   	push   %esi
    3885:	31 f6                	xor    %esi,%esi
    3887:	53                   	push   %ebx
    3888:	83 ec 2c             	sub    $0x2c,%esp
    388b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    388e:	eb 06                	jmp    3896 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    3890:	3c 0a                	cmp    $0xa,%al
    3892:	74 39                	je     38cd <gets+0x4d>
    3894:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3896:	8d 5e 01             	lea    0x1(%esi),%ebx
    3899:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    389c:	7d 31                	jge    38cf <gets+0x4f>
    cc = read(0, &c, 1);
    389e:	8d 45 e7             	lea    -0x19(%ebp),%eax
    38a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    38a8:	00 
    38a9:	89 44 24 04          	mov    %eax,0x4(%esp)
    38ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    38b4:	e8 47 00 00 00       	call   3900 <read>
    if(cc < 1)
    38b9:	85 c0                	test   %eax,%eax
    38bb:	7e 12                	jle    38cf <gets+0x4f>
      break;
    buf[i++] = c;
    38bd:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    38c1:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
    38c5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    38c9:	3c 0d                	cmp    $0xd,%al
    38cb:	75 c3                	jne    3890 <gets+0x10>
    38cd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    38cf:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    38d3:	89 f8                	mov    %edi,%eax
    38d5:	83 c4 2c             	add    $0x2c,%esp
    38d8:	5b                   	pop    %ebx
    38d9:	5e                   	pop    %esi
    38da:	5f                   	pop    %edi
    38db:	5d                   	pop    %ebp
    38dc:	c3                   	ret    
    38dd:	90                   	nop
    38de:	90                   	nop
    38df:	90                   	nop

000038e0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    38e0:	b8 01 00 00 00       	mov    $0x1,%eax
    38e5:	cd 40                	int    $0x40
    38e7:	c3                   	ret    

000038e8 <exit>:
SYSCALL(exit)
    38e8:	b8 02 00 00 00       	mov    $0x2,%eax
    38ed:	cd 40                	int    $0x40
    38ef:	c3                   	ret    

000038f0 <wait>:
SYSCALL(wait)
    38f0:	b8 03 00 00 00       	mov    $0x3,%eax
    38f5:	cd 40                	int    $0x40
    38f7:	c3                   	ret    

000038f8 <pipe>:
SYSCALL(pipe)
    38f8:	b8 04 00 00 00       	mov    $0x4,%eax
    38fd:	cd 40                	int    $0x40
    38ff:	c3                   	ret    

00003900 <read>:
SYSCALL(read)
    3900:	b8 05 00 00 00       	mov    $0x5,%eax
    3905:	cd 40                	int    $0x40
    3907:	c3                   	ret    

00003908 <write>:
SYSCALL(write)
    3908:	b8 10 00 00 00       	mov    $0x10,%eax
    390d:	cd 40                	int    $0x40
    390f:	c3                   	ret    

00003910 <close>:
SYSCALL(close)
    3910:	b8 15 00 00 00       	mov    $0x15,%eax
    3915:	cd 40                	int    $0x40
    3917:	c3                   	ret    

00003918 <kill>:
SYSCALL(kill)
    3918:	b8 06 00 00 00       	mov    $0x6,%eax
    391d:	cd 40                	int    $0x40
    391f:	c3                   	ret    

00003920 <exec>:
SYSCALL(exec)
    3920:	b8 07 00 00 00       	mov    $0x7,%eax
    3925:	cd 40                	int    $0x40
    3927:	c3                   	ret    

00003928 <open>:
SYSCALL(open)
    3928:	b8 0f 00 00 00       	mov    $0xf,%eax
    392d:	cd 40                	int    $0x40
    392f:	c3                   	ret    

00003930 <mknod>:
SYSCALL(mknod)
    3930:	b8 11 00 00 00       	mov    $0x11,%eax
    3935:	cd 40                	int    $0x40
    3937:	c3                   	ret    

00003938 <unlink>:
SYSCALL(unlink)
    3938:	b8 12 00 00 00       	mov    $0x12,%eax
    393d:	cd 40                	int    $0x40
    393f:	c3                   	ret    

00003940 <fstat>:
SYSCALL(fstat)
    3940:	b8 08 00 00 00       	mov    $0x8,%eax
    3945:	cd 40                	int    $0x40
    3947:	c3                   	ret    

00003948 <link>:
SYSCALL(link)
    3948:	b8 13 00 00 00       	mov    $0x13,%eax
    394d:	cd 40                	int    $0x40
    394f:	c3                   	ret    

00003950 <mkdir>:
SYSCALL(mkdir)
    3950:	b8 14 00 00 00       	mov    $0x14,%eax
    3955:	cd 40                	int    $0x40
    3957:	c3                   	ret    

00003958 <chdir>:
SYSCALL(chdir)
    3958:	b8 09 00 00 00       	mov    $0x9,%eax
    395d:	cd 40                	int    $0x40
    395f:	c3                   	ret    

00003960 <dup>:
SYSCALL(dup)
    3960:	b8 0a 00 00 00       	mov    $0xa,%eax
    3965:	cd 40                	int    $0x40
    3967:	c3                   	ret    

00003968 <getpid>:
SYSCALL(getpid)
    3968:	b8 0b 00 00 00       	mov    $0xb,%eax
    396d:	cd 40                	int    $0x40
    396f:	c3                   	ret    

00003970 <sbrk>:
SYSCALL(sbrk)
    3970:	b8 0c 00 00 00       	mov    $0xc,%eax
    3975:	cd 40                	int    $0x40
    3977:	c3                   	ret    

00003978 <sleep>:
SYSCALL(sleep)
    3978:	b8 0d 00 00 00       	mov    $0xd,%eax
    397d:	cd 40                	int    $0x40
    397f:	c3                   	ret    

00003980 <uptime>:
SYSCALL(uptime)
    3980:	b8 0e 00 00 00       	mov    $0xe,%eax
    3985:	cd 40                	int    $0x40
    3987:	c3                   	ret    

00003988 <gettime>:
SYSCALL(gettime)
    3988:	b8 16 00 00 00       	mov    $0x16,%eax
    398d:	cd 40                	int    $0x40
    398f:	c3                   	ret    

00003990 <shared>:
SYSCALL(shared)
    3990:	b8 17 00 00 00       	mov    $0x17,%eax
    3995:	cd 40                	int    $0x40
    3997:	c3                   	ret    
    3998:	90                   	nop
    3999:	90                   	nop
    399a:	90                   	nop
    399b:	90                   	nop
    399c:	90                   	nop
    399d:	90                   	nop
    399e:	90                   	nop
    399f:	90                   	nop

000039a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    39a0:	55                   	push   %ebp
    39a1:	89 e5                	mov    %esp,%ebp
    39a3:	57                   	push   %edi
    39a4:	89 cf                	mov    %ecx,%edi
    39a6:	56                   	push   %esi
    39a7:	89 c6                	mov    %eax,%esi
    39a9:	53                   	push   %ebx
    39aa:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    39ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
    39b0:	85 c9                	test   %ecx,%ecx
    39b2:	74 04                	je     39b8 <printint+0x18>
    39b4:	85 d2                	test   %edx,%edx
    39b6:	78 68                	js     3a20 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    39b8:	89 d0                	mov    %edx,%eax
    39ba:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    39c1:	31 c9                	xor    %ecx,%ecx
    39c3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    39c6:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    39c8:	31 d2                	xor    %edx,%edx
    39ca:	f7 f7                	div    %edi
    39cc:	0f b6 92 ef 53 00 00 	movzbl 0x53ef(%edx),%edx
    39d3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
    39d6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
    39d9:	85 c0                	test   %eax,%eax
    39db:	75 eb                	jne    39c8 <printint+0x28>
  if(neg)
    39dd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    39e0:	85 c0                	test   %eax,%eax
    39e2:	74 08                	je     39ec <printint+0x4c>
    buf[i++] = '-';
    39e4:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
    39e9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
    39ec:	8d 79 ff             	lea    -0x1(%ecx),%edi
    39ef:	90                   	nop
    39f0:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
    39f4:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    39f7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    39fe:	00 
    39ff:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    3a02:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3a05:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3a08:	89 44 24 04          	mov    %eax,0x4(%esp)
    3a0c:	e8 f7 fe ff ff       	call   3908 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    3a11:	83 ff ff             	cmp    $0xffffffff,%edi
    3a14:	75 da                	jne    39f0 <printint+0x50>
    putc(fd, buf[i]);
}
    3a16:	83 c4 4c             	add    $0x4c,%esp
    3a19:	5b                   	pop    %ebx
    3a1a:	5e                   	pop    %esi
    3a1b:	5f                   	pop    %edi
    3a1c:	5d                   	pop    %ebp
    3a1d:	c3                   	ret    
    3a1e:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    3a20:	89 d0                	mov    %edx,%eax
    3a22:	f7 d8                	neg    %eax
    3a24:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    3a2b:	eb 94                	jmp    39c1 <printint+0x21>
    3a2d:	8d 76 00             	lea    0x0(%esi),%esi

00003a30 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    3a30:	55                   	push   %ebp
    3a31:	89 e5                	mov    %esp,%ebp
    3a33:	57                   	push   %edi
    3a34:	56                   	push   %esi
    3a35:	53                   	push   %ebx
    3a36:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3a39:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a3c:	0f b6 10             	movzbl (%eax),%edx
    3a3f:	84 d2                	test   %dl,%dl
    3a41:	0f 84 c1 00 00 00    	je     3b08 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    3a47:	8d 4d 10             	lea    0x10(%ebp),%ecx
    3a4a:	31 ff                	xor    %edi,%edi
    3a4c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    3a4f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3a51:	8d 75 e7             	lea    -0x19(%ebp),%esi
    3a54:	eb 1e                	jmp    3a74 <printf+0x44>
    3a56:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    3a58:	83 fa 25             	cmp    $0x25,%edx
    3a5b:	0f 85 af 00 00 00    	jne    3b10 <printf+0xe0>
    3a61:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3a65:	83 c3 01             	add    $0x1,%ebx
    3a68:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
    3a6c:	84 d2                	test   %dl,%dl
    3a6e:	0f 84 94 00 00 00    	je     3b08 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
    3a74:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    3a76:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
    3a79:	74 dd                	je     3a58 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    3a7b:	83 ff 25             	cmp    $0x25,%edi
    3a7e:	75 e5                	jne    3a65 <printf+0x35>
      if(c == 'd'){
    3a80:	83 fa 64             	cmp    $0x64,%edx
    3a83:	0f 84 3f 01 00 00    	je     3bc8 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    3a89:	83 fa 70             	cmp    $0x70,%edx
    3a8c:	0f 84 a6 00 00 00    	je     3b38 <printf+0x108>
    3a92:	83 fa 78             	cmp    $0x78,%edx
    3a95:	0f 84 9d 00 00 00    	je     3b38 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    3a9b:	83 fa 73             	cmp    $0x73,%edx
    3a9e:	66 90                	xchg   %ax,%ax
    3aa0:	0f 84 ba 00 00 00    	je     3b60 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3aa6:	83 fa 63             	cmp    $0x63,%edx
    3aa9:	0f 84 41 01 00 00    	je     3bf0 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3aaf:	83 fa 25             	cmp    $0x25,%edx
    3ab2:	0f 84 00 01 00 00    	je     3bb8 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3ab8:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3abb:	89 55 cc             	mov    %edx,-0x34(%ebp)
    3abe:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    3ac2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3ac9:	00 
    3aca:	89 74 24 04          	mov    %esi,0x4(%esp)
    3ace:	89 0c 24             	mov    %ecx,(%esp)
    3ad1:	e8 32 fe ff ff       	call   3908 <write>
    3ad6:	8b 55 cc             	mov    -0x34(%ebp),%edx
    3ad9:	88 55 e7             	mov    %dl,-0x19(%ebp)
    3adc:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3adf:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3ae2:	31 ff                	xor    %edi,%edi
    3ae4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3aeb:	00 
    3aec:	89 74 24 04          	mov    %esi,0x4(%esp)
    3af0:	89 04 24             	mov    %eax,(%esp)
    3af3:	e8 10 fe ff ff       	call   3908 <write>
    3af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3afb:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
    3aff:	84 d2                	test   %dl,%dl
    3b01:	0f 85 6d ff ff ff    	jne    3a74 <printf+0x44>
    3b07:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    3b08:	83 c4 3c             	add    $0x3c,%esp
    3b0b:	5b                   	pop    %ebx
    3b0c:	5e                   	pop    %esi
    3b0d:	5f                   	pop    %edi
    3b0e:	5d                   	pop    %ebp
    3b0f:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3b10:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    3b13:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3b16:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3b1d:	00 
    3b1e:	89 74 24 04          	mov    %esi,0x4(%esp)
    3b22:	89 04 24             	mov    %eax,(%esp)
    3b25:	e8 de fd ff ff       	call   3908 <write>
    3b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3b2d:	e9 33 ff ff ff       	jmp    3a65 <printf+0x35>
    3b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    3b38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3b3b:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
    3b40:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    3b42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3b49:	8b 10                	mov    (%eax),%edx
    3b4b:	8b 45 08             	mov    0x8(%ebp),%eax
    3b4e:	e8 4d fe ff ff       	call   39a0 <printint>
    3b53:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    3b56:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    3b5a:	e9 06 ff ff ff       	jmp    3a65 <printf+0x35>
    3b5f:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
    3b60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
    3b63:	b9 e8 53 00 00       	mov    $0x53e8,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
    3b68:	8b 3a                	mov    (%edx),%edi
        ap++;
    3b6a:	83 c2 04             	add    $0x4,%edx
    3b6d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
    3b70:	85 ff                	test   %edi,%edi
    3b72:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
    3b75:	0f b6 17             	movzbl (%edi),%edx
    3b78:	84 d2                	test   %dl,%dl
    3b7a:	74 33                	je     3baf <printf+0x17f>
    3b7c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    3b7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
    3b88:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    3b8b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3b8e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3b95:	00 
    3b96:	89 74 24 04          	mov    %esi,0x4(%esp)
    3b9a:	89 1c 24             	mov    %ebx,(%esp)
    3b9d:	e8 66 fd ff ff       	call   3908 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    3ba2:	0f b6 17             	movzbl (%edi),%edx
    3ba5:	84 d2                	test   %dl,%dl
    3ba7:	75 df                	jne    3b88 <printf+0x158>
    3ba9:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    3bac:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3baf:	31 ff                	xor    %edi,%edi
    3bb1:	e9 af fe ff ff       	jmp    3a65 <printf+0x35>
    3bb6:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3bb8:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    3bbc:	e9 1b ff ff ff       	jmp    3adc <printf+0xac>
    3bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    3bc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3bcb:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
    3bd0:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    3bd3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3bda:	8b 10                	mov    (%eax),%edx
    3bdc:	8b 45 08             	mov    0x8(%ebp),%eax
    3bdf:	e8 bc fd ff ff       	call   39a0 <printint>
    3be4:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    3be7:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    3beb:	e9 75 fe ff ff       	jmp    3a65 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3bf0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
    3bf3:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3bf5:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3bf8:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3bfa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3c01:	00 
    3c02:	89 74 24 04          	mov    %esi,0x4(%esp)
    3c06:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3c09:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3c0c:	e8 f7 fc ff ff       	call   3908 <write>
    3c11:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    3c14:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    3c18:	e9 48 fe ff ff       	jmp    3a65 <printf+0x35>
    3c1d:	90                   	nop
    3c1e:	90                   	nop
    3c1f:	90                   	nop

00003c20 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3c20:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3c21:	a1 a8 54 00 00       	mov    0x54a8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    3c26:	89 e5                	mov    %esp,%ebp
    3c28:	57                   	push   %edi
    3c29:	56                   	push   %esi
    3c2a:	53                   	push   %ebx
    3c2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3c2e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3c31:	39 c8                	cmp    %ecx,%eax
    3c33:	73 1d                	jae    3c52 <free+0x32>
    3c35:	8d 76 00             	lea    0x0(%esi),%esi
    3c38:	8b 10                	mov    (%eax),%edx
    3c3a:	39 d1                	cmp    %edx,%ecx
    3c3c:	72 1a                	jb     3c58 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3c3e:	39 d0                	cmp    %edx,%eax
    3c40:	72 08                	jb     3c4a <free+0x2a>
    3c42:	39 c8                	cmp    %ecx,%eax
    3c44:	72 12                	jb     3c58 <free+0x38>
    3c46:	39 d1                	cmp    %edx,%ecx
    3c48:	72 0e                	jb     3c58 <free+0x38>
    3c4a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3c4c:	39 c8                	cmp    %ecx,%eax
    3c4e:	66 90                	xchg   %ax,%ax
    3c50:	72 e6                	jb     3c38 <free+0x18>
    3c52:	8b 10                	mov    (%eax),%edx
    3c54:	eb e8                	jmp    3c3e <free+0x1e>
    3c56:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    3c58:	8b 71 04             	mov    0x4(%ecx),%esi
    3c5b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3c5e:	39 d7                	cmp    %edx,%edi
    3c60:	74 19                	je     3c7b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3c62:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3c65:	8b 50 04             	mov    0x4(%eax),%edx
    3c68:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3c6b:	39 ce                	cmp    %ecx,%esi
    3c6d:	74 23                	je     3c92 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3c6f:	89 08                	mov    %ecx,(%eax)
  freep = p;
    3c71:	a3 a8 54 00 00       	mov    %eax,0x54a8
}
    3c76:	5b                   	pop    %ebx
    3c77:	5e                   	pop    %esi
    3c78:	5f                   	pop    %edi
    3c79:	5d                   	pop    %ebp
    3c7a:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    3c7b:	03 72 04             	add    0x4(%edx),%esi
    3c7e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3c81:	8b 10                	mov    (%eax),%edx
    3c83:	8b 12                	mov    (%edx),%edx
    3c85:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    3c88:	8b 50 04             	mov    0x4(%eax),%edx
    3c8b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3c8e:	39 ce                	cmp    %ecx,%esi
    3c90:	75 dd                	jne    3c6f <free+0x4f>
    p->s.size += bp->s.size;
    3c92:	03 51 04             	add    0x4(%ecx),%edx
    3c95:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3c98:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3c9b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
    3c9d:	a3 a8 54 00 00       	mov    %eax,0x54a8
}
    3ca2:	5b                   	pop    %ebx
    3ca3:	5e                   	pop    %esi
    3ca4:	5f                   	pop    %edi
    3ca5:	5d                   	pop    %ebp
    3ca6:	c3                   	ret    
    3ca7:	89 f6                	mov    %esi,%esi
    3ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003cb0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3cb0:	55                   	push   %ebp
    3cb1:	89 e5                	mov    %esp,%ebp
    3cb3:	57                   	push   %edi
    3cb4:	56                   	push   %esi
    3cb5:	53                   	push   %ebx
    3cb6:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3cb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
    3cbc:	8b 0d a8 54 00 00    	mov    0x54a8,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3cc2:	83 c3 07             	add    $0x7,%ebx
    3cc5:	c1 eb 03             	shr    $0x3,%ebx
    3cc8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    3ccb:	85 c9                	test   %ecx,%ecx
    3ccd:	0f 84 9b 00 00 00    	je     3d6e <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3cd3:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    3cd5:	8b 50 04             	mov    0x4(%eax),%edx
    3cd8:	39 d3                	cmp    %edx,%ebx
    3cda:	76 27                	jbe    3d03 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    3cdc:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    3ce3:	be 00 80 00 00       	mov    $0x8000,%esi
    3ce8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    3ceb:	90                   	nop
    3cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    3cf0:	3b 05 a8 54 00 00    	cmp    0x54a8,%eax
    3cf6:	74 30                	je     3d28 <malloc+0x78>
    3cf8:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3cfa:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    3cfc:	8b 50 04             	mov    0x4(%eax),%edx
    3cff:	39 d3                	cmp    %edx,%ebx
    3d01:	77 ed                	ja     3cf0 <malloc+0x40>
      if(p->s.size == nunits)
    3d03:	39 d3                	cmp    %edx,%ebx
    3d05:	74 61                	je     3d68 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    3d07:	29 da                	sub    %ebx,%edx
    3d09:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    3d0c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    3d0f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    3d12:	89 0d a8 54 00 00    	mov    %ecx,0x54a8
      return (void*)(p + 1);
    3d18:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    3d1b:	83 c4 2c             	add    $0x2c,%esp
    3d1e:	5b                   	pop    %ebx
    3d1f:	5e                   	pop    %esi
    3d20:	5f                   	pop    %edi
    3d21:	5d                   	pop    %ebp
    3d22:	c3                   	ret    
    3d23:	90                   	nop
    3d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    3d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3d2b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    3d31:	bf 00 10 00 00       	mov    $0x1000,%edi
    3d36:	0f 43 fb             	cmovae %ebx,%edi
    3d39:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    3d3c:	89 04 24             	mov    %eax,(%esp)
    3d3f:	e8 2c fc ff ff       	call   3970 <sbrk>
  if(p == (char*)-1)
    3d44:	83 f8 ff             	cmp    $0xffffffff,%eax
    3d47:	74 18                	je     3d61 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    3d49:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    3d4c:	83 c0 08             	add    $0x8,%eax
    3d4f:	89 04 24             	mov    %eax,(%esp)
    3d52:	e8 c9 fe ff ff       	call   3c20 <free>
  return freep;
    3d57:	8b 0d a8 54 00 00    	mov    0x54a8,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    3d5d:	85 c9                	test   %ecx,%ecx
    3d5f:	75 99                	jne    3cfa <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    3d61:	31 c0                	xor    %eax,%eax
    3d63:	eb b6                	jmp    3d1b <malloc+0x6b>
    3d65:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    3d68:	8b 10                	mov    (%eax),%edx
    3d6a:	89 11                	mov    %edx,(%ecx)
    3d6c:	eb a4                	jmp    3d12 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    3d6e:	c7 05 a8 54 00 00 a0 	movl   $0x54a0,0x54a8
    3d75:	54 00 00 
    base.s.size = 0;
    3d78:	b9 a0 54 00 00       	mov    $0x54a0,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    3d7d:	c7 05 a0 54 00 00 a0 	movl   $0x54a0,0x54a0
    3d84:	54 00 00 
    base.s.size = 0;
    3d87:	c7 05 a4 54 00 00 00 	movl   $0x0,0x54a4
    3d8e:	00 00 00 
    3d91:	e9 3d ff ff ff       	jmp    3cd3 <malloc+0x23>
