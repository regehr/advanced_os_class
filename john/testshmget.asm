
_testshmget:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

//
int main(void){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	53                   	push   %ebx
   7:	83 ec 1c             	sub    $0x1c,%esp
  int i=0;
  int j=0;
  if(shmget(12,(char *)0x7FFF0000,20480)<0){
   a:	c7 44 24 08 00 50 00 	movl   $0x5000,0x8(%esp)
  11:	00 
  12:	c7 44 24 04 00 00 ff 	movl   $0x7fff0000,0x4(%esp)
  19:	7f 
  1a:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  21:	e8 aa 03 00 00       	call   3d0 <shmget>
  26:	85 c0                	test   %eax,%eax
  28:	0f 88 b4 00 00 00    	js     e2 <main+0xe2>
    printf(1,"error\n");
  2e:	b8 00 00 ff 7f       	mov    $0x7fff0000,%eax
  33:	90                   	nop
  34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  char *test = (char*) 0x7FFF0000;
  char *temp = test;
  for(;i<20479; i++){
    *test = 'A';
  38:	c6 00 41             	movb   $0x41,(%eax)
    test++;
  3b:	83 c0 01             	add    $0x1,%eax
    printf(1,"error\n");
  }

  char *test = (char*) 0x7FFF0000;
  char *temp = test;
  for(;i<20479; i++){
  3e:	3d ff 4f ff 7f       	cmp    $0x7fff4fff,%eax
  43:	75 f3                	jne    38 <main+0x38>
    *test = 'A';
    test++;
  }
  *test = '\0';
  45:	c6 00 00             	movb   $0x0,(%eax)
  test = temp;

  if(fork()==0){
  48:	e8 d3 02 00 00       	call   320 <fork>
  4d:	85 c0                	test   %eax,%eax
  4f:	0f 85 83 00 00 00    	jne    d8 <main+0xd8>
    //child
    sleep(100);
  55:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
    char *test1;
    if(shmget(12,(char *)0x20000000,0) < 0){
      printf(1,"Child error");
      exit();
  5c:	bb 00 00 00 20       	mov    $0x20000000,%ebx
  *test = '\0';
  test = temp;

  if(fork()==0){
    //child
    sleep(100);
  61:	e8 52 03 00 00       	call   3b8 <sleep>
    char *test1;
    if(shmget(12,(char *)0x20000000,0) < 0){
  66:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  6d:	00 
  6e:	c7 44 24 04 00 00 00 	movl   $0x20000000,0x4(%esp)
  75:	20 
  76:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  7d:	e8 4e 03 00 00       	call   3d0 <shmget>
  82:	85 c0                	test   %eax,%eax
  84:	79 1d                	jns    a3 <main+0xa3>
      printf(1,"Child error");
  86:	c7 44 24 04 8c 08 00 	movl   $0x88c,0x4(%esp)
  8d:	00 
  8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  95:	e8 d6 03 00 00       	call   470 <printf>
      exit();
  9a:	e8 89 02 00 00       	call   328 <exit>
  9f:	90                   	nop
    test1 =(char*) 0x20000000;
    for(;j<20479;j++){
      if(*test1 != 'A'){
	printf(1,"Fail\n");
      }
      test1++;
  a0:	83 c3 01             	add    $0x1,%ebx
      printf(1,"Child error");
      exit();
    }
    test1 =(char*) 0x20000000;
    for(;j<20479;j++){
      if(*test1 != 'A'){
  a3:	80 3b 41             	cmpb   $0x41,(%ebx)
  a6:	74 14                	je     bc <main+0xbc>
	printf(1,"Fail\n");
  a8:	c7 44 24 04 98 08 00 	movl   $0x898,0x4(%esp)
  af:	00 
  b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b7:	e8 b4 03 00 00       	call   470 <printf>
    if(shmget(12,(char *)0x20000000,0) < 0){
      printf(1,"Child error");
      exit();
    }
    test1 =(char*) 0x20000000;
    for(;j<20479;j++){
  bc:	81 fb fe 4f 00 20    	cmp    $0x20004ffe,%ebx
  c2:	75 dc                	jne    a0 <main+0xa0>
      if(*test1 != 'A'){
	printf(1,"Fail\n");
      }
      test1++;
    }
    printf(1,"Child exiting with success!\n");
  c4:	c7 44 24 04 9e 08 00 	movl   $0x89e,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 98 03 00 00       	call   470 <printf>
  }

  wait();
  d8:	e8 53 02 00 00       	call   330 <wait>
  /*  int test1[15];
  int * test = malloc(4096);
  printf(1,"test is %p, %x, %d\n",test,test,test);
  printf(1,"test1 is %p, %x, %d\n",test1,test1,test1);*/
  exit();
  dd:	e8 46 02 00 00       	call   328 <exit>
//
int main(void){
  int i=0;
  int j=0;
  if(shmget(12,(char *)0x7FFF0000,20480)<0){
    printf(1,"error\n");
  e2:	c7 44 24 04 85 08 00 	movl   $0x885,0x4(%esp)
  e9:	00 
  ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f1:	e8 7a 03 00 00       	call   470 <printf>
  f6:	e9 33 ff ff ff       	jmp    2e <main+0x2e>
  fb:	90                   	nop
  fc:	90                   	nop
  fd:	90                   	nop
  fe:	90                   	nop
  ff:	90                   	nop

00000100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 100:	55                   	push   %ebp
 101:	31 d2                	xor    %edx,%edx
 103:	89 e5                	mov    %esp,%ebp
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	53                   	push   %ebx
 109:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 110:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 114:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 117:	83 c2 01             	add    $0x1,%edx
 11a:	84 c9                	test   %cl,%cl
 11c:	75 f2                	jne    110 <strcpy+0x10>
    ;
  return os;
}
 11e:	5b                   	pop    %ebx
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret    
 121:	eb 0d                	jmp    130 <strcmp>
 123:	90                   	nop
 124:	90                   	nop
 125:	90                   	nop
 126:	90                   	nop
 127:	90                   	nop
 128:	90                   	nop
 129:	90                   	nop
 12a:	90                   	nop
 12b:	90                   	nop
 12c:	90                   	nop
 12d:	90                   	nop
 12e:	90                   	nop
 12f:	90                   	nop

00000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 4d 08             	mov    0x8(%ebp),%ecx
 136:	53                   	push   %ebx
 137:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 13a:	0f b6 01             	movzbl (%ecx),%eax
 13d:	84 c0                	test   %al,%al
 13f:	75 14                	jne    155 <strcmp+0x25>
 141:	eb 25                	jmp    168 <strcmp+0x38>
 143:	90                   	nop
 144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 148:	83 c1 01             	add    $0x1,%ecx
 14b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 14e:	0f b6 01             	movzbl (%ecx),%eax
 151:	84 c0                	test   %al,%al
 153:	74 13                	je     168 <strcmp+0x38>
 155:	0f b6 1a             	movzbl (%edx),%ebx
 158:	38 d8                	cmp    %bl,%al
 15a:	74 ec                	je     148 <strcmp+0x18>
 15c:	0f b6 db             	movzbl %bl,%ebx
 15f:	0f b6 c0             	movzbl %al,%eax
 162:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 164:	5b                   	pop    %ebx
 165:	5d                   	pop    %ebp
 166:	c3                   	ret    
 167:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 168:	0f b6 1a             	movzbl (%edx),%ebx
 16b:	31 c0                	xor    %eax,%eax
 16d:	0f b6 db             	movzbl %bl,%ebx
 170:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 172:	5b                   	pop    %ebx
 173:	5d                   	pop    %ebp
 174:	c3                   	ret    
 175:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <strlen>:

uint
strlen(char *s)
{
 180:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 181:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 183:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 185:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 187:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 18a:	80 39 00             	cmpb   $0x0,(%ecx)
 18d:	74 0c                	je     19b <strlen+0x1b>
 18f:	90                   	nop
 190:	83 c2 01             	add    $0x1,%edx
 193:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 197:	89 d0                	mov    %edx,%eax
 199:	75 f5                	jne    190 <strlen+0x10>
    ;
  return n;
}
 19b:	5d                   	pop    %ebp
 19c:	c3                   	ret    
 19d:	8d 76 00             	lea    0x0(%esi),%esi

000001a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	8b 55 08             	mov    0x8(%ebp),%edx
 1a6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ad:	89 d7                	mov    %edx,%edi
 1af:	fc                   	cld    
 1b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1b2:	89 d0                	mov    %edx,%eax
 1b4:	5f                   	pop    %edi
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
 1b7:	89 f6                	mov    %esi,%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <strchr>:

char*
strchr(const char *s, char c)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ca:	0f b6 10             	movzbl (%eax),%edx
 1cd:	84 d2                	test   %dl,%dl
 1cf:	75 11                	jne    1e2 <strchr+0x22>
 1d1:	eb 15                	jmp    1e8 <strchr+0x28>
 1d3:	90                   	nop
 1d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d8:	83 c0 01             	add    $0x1,%eax
 1db:	0f b6 10             	movzbl (%eax),%edx
 1de:	84 d2                	test   %dl,%dl
 1e0:	74 06                	je     1e8 <strchr+0x28>
    if(*s == c)
 1e2:	38 ca                	cmp    %cl,%dl
 1e4:	75 f2                	jne    1d8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1e6:	5d                   	pop    %ebp
 1e7:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1e8:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 1ea:	5d                   	pop    %ebp
 1eb:	90                   	nop
 1ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1f0:	c3                   	ret    
 1f1:	eb 0d                	jmp    200 <atoi>
 1f3:	90                   	nop
 1f4:	90                   	nop
 1f5:	90                   	nop
 1f6:	90                   	nop
 1f7:	90                   	nop
 1f8:	90                   	nop
 1f9:	90                   	nop
 1fa:	90                   	nop
 1fb:	90                   	nop
 1fc:	90                   	nop
 1fd:	90                   	nop
 1fe:	90                   	nop
 1ff:	90                   	nop

00000200 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 200:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 201:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 203:	89 e5                	mov    %esp,%ebp
 205:	8b 4d 08             	mov    0x8(%ebp),%ecx
 208:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 209:	0f b6 11             	movzbl (%ecx),%edx
 20c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 20f:	80 fb 09             	cmp    $0x9,%bl
 212:	77 1c                	ja     230 <atoi+0x30>
 214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 218:	0f be d2             	movsbl %dl,%edx
 21b:	83 c1 01             	add    $0x1,%ecx
 21e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 221:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 225:	0f b6 11             	movzbl (%ecx),%edx
 228:	8d 5a d0             	lea    -0x30(%edx),%ebx
 22b:	80 fb 09             	cmp    $0x9,%bl
 22e:	76 e8                	jbe    218 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 230:	5b                   	pop    %ebx
 231:	5d                   	pop    %ebp
 232:	c3                   	ret    
 233:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000240 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	56                   	push   %esi
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	53                   	push   %ebx
 248:	8b 5d 10             	mov    0x10(%ebp),%ebx
 24b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 24e:	85 db                	test   %ebx,%ebx
 250:	7e 14                	jle    266 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 252:	31 d2                	xor    %edx,%edx
 254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 258:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 25c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 25f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 262:	39 da                	cmp    %ebx,%edx
 264:	75 f2                	jne    258 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 266:	5b                   	pop    %ebx
 267:	5e                   	pop    %esi
 268:	5d                   	pop    %ebp
 269:	c3                   	ret    
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000270 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 276:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 279:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 27c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 27f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 284:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 28b:	00 
 28c:	89 04 24             	mov    %eax,(%esp)
 28f:	e8 d4 00 00 00       	call   368 <open>
  if(fd < 0)
 294:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 296:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 298:	78 19                	js     2b3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 29a:	8b 45 0c             	mov    0xc(%ebp),%eax
 29d:	89 1c 24             	mov    %ebx,(%esp)
 2a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2a4:	e8 d7 00 00 00       	call   380 <fstat>
  close(fd);
 2a9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2ac:	89 c6                	mov    %eax,%esi
  close(fd);
 2ae:	e8 9d 00 00 00       	call   350 <close>
  return r;
}
 2b3:	89 f0                	mov    %esi,%eax
 2b5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2b8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2bb:	89 ec                	mov    %ebp,%esp
 2bd:	5d                   	pop    %ebp
 2be:	c3                   	ret    
 2bf:	90                   	nop

000002c0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	56                   	push   %esi
 2c5:	31 f6                	xor    %esi,%esi
 2c7:	53                   	push   %ebx
 2c8:	83 ec 2c             	sub    $0x2c,%esp
 2cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ce:	eb 06                	jmp    2d6 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d0:	3c 0a                	cmp    $0xa,%al
 2d2:	74 39                	je     30d <gets+0x4d>
 2d4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d6:	8d 5e 01             	lea    0x1(%esi),%ebx
 2d9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2dc:	7d 31                	jge    30f <gets+0x4f>
    cc = read(0, &c, 1);
 2de:	8d 45 e7             	lea    -0x19(%ebp),%eax
 2e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2e8:	00 
 2e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2f4:	e8 47 00 00 00       	call   340 <read>
    if(cc < 1)
 2f9:	85 c0                	test   %eax,%eax
 2fb:	7e 12                	jle    30f <gets+0x4f>
      break;
    buf[i++] = c;
 2fd:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 301:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 305:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 309:	3c 0d                	cmp    $0xd,%al
 30b:	75 c3                	jne    2d0 <gets+0x10>
 30d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 30f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 313:	89 f8                	mov    %edi,%eax
 315:	83 c4 2c             	add    $0x2c,%esp
 318:	5b                   	pop    %ebx
 319:	5e                   	pop    %esi
 31a:	5f                   	pop    %edi
 31b:	5d                   	pop    %ebp
 31c:	c3                   	ret    
 31d:	90                   	nop
 31e:	90                   	nop
 31f:	90                   	nop

00000320 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 320:	b8 01 00 00 00       	mov    $0x1,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <exit>:
SYSCALL(exit)
 328:	b8 02 00 00 00       	mov    $0x2,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <wait>:
SYSCALL(wait)
 330:	b8 03 00 00 00       	mov    $0x3,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <pipe>:
SYSCALL(pipe)
 338:	b8 04 00 00 00       	mov    $0x4,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <read>:
SYSCALL(read)
 340:	b8 05 00 00 00       	mov    $0x5,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <write>:
SYSCALL(write)
 348:	b8 10 00 00 00       	mov    $0x10,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <close>:
SYSCALL(close)
 350:	b8 15 00 00 00       	mov    $0x15,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <kill>:
SYSCALL(kill)
 358:	b8 06 00 00 00       	mov    $0x6,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <exec>:
SYSCALL(exec)
 360:	b8 07 00 00 00       	mov    $0x7,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <open>:
SYSCALL(open)
 368:	b8 0f 00 00 00       	mov    $0xf,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <mknod>:
SYSCALL(mknod)
 370:	b8 11 00 00 00       	mov    $0x11,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <unlink>:
SYSCALL(unlink)
 378:	b8 12 00 00 00       	mov    $0x12,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <fstat>:
SYSCALL(fstat)
 380:	b8 08 00 00 00       	mov    $0x8,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <link>:
SYSCALL(link)
 388:	b8 13 00 00 00       	mov    $0x13,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <mkdir>:
SYSCALL(mkdir)
 390:	b8 14 00 00 00       	mov    $0x14,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <chdir>:
SYSCALL(chdir)
 398:	b8 09 00 00 00       	mov    $0x9,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <dup>:
SYSCALL(dup)
 3a0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <getpid>:
SYSCALL(getpid)
 3a8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <sbrk>:
SYSCALL(sbrk)
 3b0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <sleep>:
SYSCALL(sleep)
 3b8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <uptime>:
SYSCALL(uptime)
 3c0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <gettime>:
SYSCALL(gettime)
 3c8:	b8 16 00 00 00       	mov    $0x16,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <shmget>:
SYSCALL(shmget)
 3d0:	b8 17 00 00 00       	mov    $0x17,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    
 3d8:	90                   	nop
 3d9:	90                   	nop
 3da:	90                   	nop
 3db:	90                   	nop
 3dc:	90                   	nop
 3dd:	90                   	nop
 3de:	90                   	nop
 3df:	90                   	nop

000003e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	89 cf                	mov    %ecx,%edi
 3e6:	56                   	push   %esi
 3e7:	89 c6                	mov    %eax,%esi
 3e9:	53                   	push   %ebx
 3ea:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3f0:	85 c9                	test   %ecx,%ecx
 3f2:	74 04                	je     3f8 <printint+0x18>
 3f4:	85 d2                	test   %edx,%edx
 3f6:	78 68                	js     460 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f8:	89 d0                	mov    %edx,%eax
 3fa:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 401:	31 c9                	xor    %ecx,%ecx
 403:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 406:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 408:	31 d2                	xor    %edx,%edx
 40a:	f7 f7                	div    %edi
 40c:	0f b6 92 c2 08 00 00 	movzbl 0x8c2(%edx),%edx
 413:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 416:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 419:	85 c0                	test   %eax,%eax
 41b:	75 eb                	jne    408 <printint+0x28>
  if(neg)
 41d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 420:	85 c0                	test   %eax,%eax
 422:	74 08                	je     42c <printint+0x4c>
    buf[i++] = '-';
 424:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 429:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 42c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 42f:	90                   	nop
 430:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
 434:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 437:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 43e:	00 
 43f:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 442:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 445:	8d 45 e7             	lea    -0x19(%ebp),%eax
 448:	89 44 24 04          	mov    %eax,0x4(%esp)
 44c:	e8 f7 fe ff ff       	call   348 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 451:	83 ff ff             	cmp    $0xffffffff,%edi
 454:	75 da                	jne    430 <printint+0x50>
    putc(fd, buf[i]);
}
 456:	83 c4 4c             	add    $0x4c,%esp
 459:	5b                   	pop    %ebx
 45a:	5e                   	pop    %esi
 45b:	5f                   	pop    %edi
 45c:	5d                   	pop    %ebp
 45d:	c3                   	ret    
 45e:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 460:	89 d0                	mov    %edx,%eax
 462:	f7 d8                	neg    %eax
 464:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 46b:	eb 94                	jmp    401 <printint+0x21>
 46d:	8d 76 00             	lea    0x0(%esi),%esi

00000470 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 479:	8b 45 0c             	mov    0xc(%ebp),%eax
 47c:	0f b6 10             	movzbl (%eax),%edx
 47f:	84 d2                	test   %dl,%dl
 481:	0f 84 c1 00 00 00    	je     548 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 487:	8d 4d 10             	lea    0x10(%ebp),%ecx
 48a:	31 ff                	xor    %edi,%edi
 48c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 48f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 491:	8d 75 e7             	lea    -0x19(%ebp),%esi
 494:	eb 1e                	jmp    4b4 <printf+0x44>
 496:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 498:	83 fa 25             	cmp    $0x25,%edx
 49b:	0f 85 af 00 00 00    	jne    550 <printf+0xe0>
 4a1:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a5:	83 c3 01             	add    $0x1,%ebx
 4a8:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 4ac:	84 d2                	test   %dl,%dl
 4ae:	0f 84 94 00 00 00    	je     548 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
 4b4:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4b6:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 4b9:	74 dd                	je     498 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4bb:	83 ff 25             	cmp    $0x25,%edi
 4be:	75 e5                	jne    4a5 <printf+0x35>
      if(c == 'd'){
 4c0:	83 fa 64             	cmp    $0x64,%edx
 4c3:	0f 84 3f 01 00 00    	je     608 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4c9:	83 fa 70             	cmp    $0x70,%edx
 4cc:	0f 84 a6 00 00 00    	je     578 <printf+0x108>
 4d2:	83 fa 78             	cmp    $0x78,%edx
 4d5:	0f 84 9d 00 00 00    	je     578 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4db:	83 fa 73             	cmp    $0x73,%edx
 4de:	66 90                	xchg   %ax,%ax
 4e0:	0f 84 ba 00 00 00    	je     5a0 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4e6:	83 fa 63             	cmp    $0x63,%edx
 4e9:	0f 84 41 01 00 00    	je     630 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4ef:	83 fa 25             	cmp    $0x25,%edx
 4f2:	0f 84 00 01 00 00    	je     5f8 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4fb:	89 55 cc             	mov    %edx,-0x34(%ebp)
 4fe:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 502:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 509:	00 
 50a:	89 74 24 04          	mov    %esi,0x4(%esp)
 50e:	89 0c 24             	mov    %ecx,(%esp)
 511:	e8 32 fe ff ff       	call   348 <write>
 516:	8b 55 cc             	mov    -0x34(%ebp),%edx
 519:	88 55 e7             	mov    %dl,-0x19(%ebp)
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 51f:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 522:	31 ff                	xor    %edi,%edi
 524:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 52b:	00 
 52c:	89 74 24 04          	mov    %esi,0x4(%esp)
 530:	89 04 24             	mov    %eax,(%esp)
 533:	e8 10 fe ff ff       	call   348 <write>
 538:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 53b:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 53f:	84 d2                	test   %dl,%dl
 541:	0f 85 6d ff ff ff    	jne    4b4 <printf+0x44>
 547:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 548:	83 c4 3c             	add    $0x3c,%esp
 54b:	5b                   	pop    %ebx
 54c:	5e                   	pop    %esi
 54d:	5f                   	pop    %edi
 54e:	5d                   	pop    %ebp
 54f:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 550:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 553:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 556:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 55d:	00 
 55e:	89 74 24 04          	mov    %esi,0x4(%esp)
 562:	89 04 24             	mov    %eax,(%esp)
 565:	e8 de fd ff ff       	call   348 <write>
 56a:	8b 45 0c             	mov    0xc(%ebp),%eax
 56d:	e9 33 ff ff ff       	jmp    4a5 <printf+0x35>
 572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 578:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 57b:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 580:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 582:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 589:	8b 10                	mov    (%eax),%edx
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	e8 4d fe ff ff       	call   3e0 <printint>
 593:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 596:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 59a:	e9 06 ff ff ff       	jmp    4a5 <printf+0x35>
 59f:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 5a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 5a3:	b9 bb 08 00 00       	mov    $0x8bb,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 5a8:	8b 3a                	mov    (%edx),%edi
        ap++;
 5aa:	83 c2 04             	add    $0x4,%edx
 5ad:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 5b0:	85 ff                	test   %edi,%edi
 5b2:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 5b5:	0f b6 17             	movzbl (%edi),%edx
 5b8:	84 d2                	test   %dl,%dl
 5ba:	74 33                	je     5ef <printf+0x17f>
 5bc:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 5c8:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5cb:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5d5:	00 
 5d6:	89 74 24 04          	mov    %esi,0x4(%esp)
 5da:	89 1c 24             	mov    %ebx,(%esp)
 5dd:	e8 66 fd ff ff       	call   348 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e2:	0f b6 17             	movzbl (%edi),%edx
 5e5:	84 d2                	test   %dl,%dl
 5e7:	75 df                	jne    5c8 <printf+0x158>
 5e9:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5ec:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ef:	31 ff                	xor    %edi,%edi
 5f1:	e9 af fe ff ff       	jmp    4a5 <printf+0x35>
 5f6:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5f8:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5fc:	e9 1b ff ff ff       	jmp    51c <printf+0xac>
 601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 608:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 60b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 610:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 613:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 61a:	8b 10                	mov    (%eax),%edx
 61c:	8b 45 08             	mov    0x8(%ebp),%eax
 61f:	e8 bc fd ff ff       	call   3e0 <printint>
 624:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 627:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 62b:	e9 75 fe ff ff       	jmp    4a5 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 630:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 633:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 635:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 638:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 63a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 641:	00 
 642:	89 74 24 04          	mov    %esi,0x4(%esp)
 646:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 649:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 64c:	e8 f7 fc ff ff       	call   348 <write>
 651:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 654:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 658:	e9 48 fe ff ff       	jmp    4a5 <printf+0x35>
 65d:	90                   	nop
 65e:	90                   	nop
 65f:	90                   	nop

00000660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 660:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	a1 dc 08 00 00       	mov    0x8dc,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 666:	89 e5                	mov    %esp,%ebp
 668:	57                   	push   %edi
 669:	56                   	push   %esi
 66a:	53                   	push   %ebx
 66b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 671:	39 c8                	cmp    %ecx,%eax
 673:	73 1d                	jae    692 <free+0x32>
 675:	8d 76 00             	lea    0x0(%esi),%esi
 678:	8b 10                	mov    (%eax),%edx
 67a:	39 d1                	cmp    %edx,%ecx
 67c:	72 1a                	jb     698 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67e:	39 d0                	cmp    %edx,%eax
 680:	72 08                	jb     68a <free+0x2a>
 682:	39 c8                	cmp    %ecx,%eax
 684:	72 12                	jb     698 <free+0x38>
 686:	39 d1                	cmp    %edx,%ecx
 688:	72 0e                	jb     698 <free+0x38>
 68a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68c:	39 c8                	cmp    %ecx,%eax
 68e:	66 90                	xchg   %ax,%ax
 690:	72 e6                	jb     678 <free+0x18>
 692:	8b 10                	mov    (%eax),%edx
 694:	eb e8                	jmp    67e <free+0x1e>
 696:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 698:	8b 71 04             	mov    0x4(%ecx),%esi
 69b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 69e:	39 d7                	cmp    %edx,%edi
 6a0:	74 19                	je     6bb <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6a2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6a5:	8b 50 04             	mov    0x4(%eax),%edx
 6a8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6ab:	39 ce                	cmp    %ecx,%esi
 6ad:	74 23                	je     6d2 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6af:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6b1:	a3 dc 08 00 00       	mov    %eax,0x8dc
}
 6b6:	5b                   	pop    %ebx
 6b7:	5e                   	pop    %esi
 6b8:	5f                   	pop    %edi
 6b9:	5d                   	pop    %ebp
 6ba:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6bb:	03 72 04             	add    0x4(%edx),%esi
 6be:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c1:	8b 10                	mov    (%eax),%edx
 6c3:	8b 12                	mov    (%edx),%edx
 6c5:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6c8:	8b 50 04             	mov    0x4(%eax),%edx
 6cb:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6ce:	39 ce                	cmp    %ecx,%esi
 6d0:	75 dd                	jne    6af <free+0x4f>
    p->s.size += bp->s.size;
 6d2:	03 51 04             	add    0x4(%ecx),%edx
 6d5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6db:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 6dd:	a3 dc 08 00 00       	mov    %eax,0x8dc
}
 6e2:	5b                   	pop    %ebx
 6e3:	5e                   	pop    %esi
 6e4:	5f                   	pop    %edi
 6e5:	5d                   	pop    %ebp
 6e6:	c3                   	ret    
 6e7:	89 f6                	mov    %esi,%esi
 6e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
 6f5:	53                   	push   %ebx
 6f6:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 6fc:	8b 0d dc 08 00 00    	mov    0x8dc,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	83 c3 07             	add    $0x7,%ebx
 705:	c1 eb 03             	shr    $0x3,%ebx
 708:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 70b:	85 c9                	test   %ecx,%ecx
 70d:	0f 84 9b 00 00 00    	je     7ae <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 713:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 715:	8b 50 04             	mov    0x4(%eax),%edx
 718:	39 d3                	cmp    %edx,%ebx
 71a:	76 27                	jbe    743 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 71c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 723:	be 00 80 00 00       	mov    $0x8000,%esi
 728:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 72b:	90                   	nop
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 730:	3b 05 dc 08 00 00    	cmp    0x8dc,%eax
 736:	74 30                	je     768 <malloc+0x78>
 738:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73a:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 73c:	8b 50 04             	mov    0x4(%eax),%edx
 73f:	39 d3                	cmp    %edx,%ebx
 741:	77 ed                	ja     730 <malloc+0x40>
      if(p->s.size == nunits)
 743:	39 d3                	cmp    %edx,%ebx
 745:	74 61                	je     7a8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 747:	29 da                	sub    %ebx,%edx
 749:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 74c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 74f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 752:	89 0d dc 08 00 00    	mov    %ecx,0x8dc
      return (void*)(p + 1);
 758:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 75b:	83 c4 2c             	add    $0x2c,%esp
 75e:	5b                   	pop    %ebx
 75f:	5e                   	pop    %esi
 760:	5f                   	pop    %edi
 761:	5d                   	pop    %ebp
 762:	c3                   	ret    
 763:	90                   	nop
 764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 771:	bf 00 10 00 00       	mov    $0x1000,%edi
 776:	0f 43 fb             	cmovae %ebx,%edi
 779:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 77c:	89 04 24             	mov    %eax,(%esp)
 77f:	e8 2c fc ff ff       	call   3b0 <sbrk>
  if(p == (char*)-1)
 784:	83 f8 ff             	cmp    $0xffffffff,%eax
 787:	74 18                	je     7a1 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 789:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 78c:	83 c0 08             	add    $0x8,%eax
 78f:	89 04 24             	mov    %eax,(%esp)
 792:	e8 c9 fe ff ff       	call   660 <free>
  return freep;
 797:	8b 0d dc 08 00 00    	mov    0x8dc,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 79d:	85 c9                	test   %ecx,%ecx
 79f:	75 99                	jne    73a <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7a1:	31 c0                	xor    %eax,%eax
 7a3:	eb b6                	jmp    75b <malloc+0x6b>
 7a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7a8:	8b 10                	mov    (%eax),%edx
 7aa:	89 11                	mov    %edx,(%ecx)
 7ac:	eb a4                	jmp    752 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7ae:	c7 05 dc 08 00 00 d4 	movl   $0x8d4,0x8dc
 7b5:	08 00 00 
    base.s.size = 0;
 7b8:	b9 d4 08 00 00       	mov    $0x8d4,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7bd:	c7 05 d4 08 00 00 d4 	movl   $0x8d4,0x8d4
 7c4:	08 00 00 
    base.s.size = 0;
 7c7:	c7 05 d8 08 00 00 00 	movl   $0x0,0x8d8
 7ce:	00 00 00 
 7d1:	e9 3d ff ff ff       	jmp    713 <malloc+0x23>
 7d6:	90                   	nop
 7d7:	90                   	nop
 7d8:	90                   	nop
 7d9:	90                   	nop
 7da:	90                   	nop
 7db:	90                   	nop
 7dc:	90                   	nop
 7dd:	90                   	nop
 7de:	90                   	nop
 7df:	90                   	nop

000007e0 <ring_attach>:
#include "ring.h"

struct ring *ring_attach(uint token)
{
 7e0:	55                   	push   %ebp
  return 0;
}
 7e1:	31 c0                	xor    %eax,%eax
#include "ring.h"

struct ring *ring_attach(uint token)
{
 7e3:	89 e5                	mov    %esp,%ebp
  return 0;
}
 7e5:	5d                   	pop    %ebp
 7e6:	c3                   	ret    
 7e7:	89 f6                	mov    %esi,%esi
 7e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007f0 <ring_size>:

int ring_size(uint token)
{
 7f0:	55                   	push   %ebp
  return 0;
}
 7f1:	31 c0                	xor    %eax,%eax
{
  return 0;
}

int ring_size(uint token)
{
 7f3:	89 e5                	mov    %esp,%ebp
  return 0;
}
 7f5:	5d                   	pop    %ebp
 7f6:	c3                   	ret    
 7f7:	89 f6                	mov    %esi,%esi
 7f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000800 <ring_detach>:

int ring_detach(uint token)
{
 800:	55                   	push   %ebp
  return 0;
}
 801:	31 c0                	xor    %eax,%eax
{
  return 0;
}

int ring_detach(uint token)
{
 803:	89 e5                	mov    %esp,%ebp
  return 0;
}
 805:	5d                   	pop    %ebp
 806:	c3                   	ret    
 807:	89 f6                	mov    %esi,%esi
 809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000810 <ring_write_reserve>:

struct ring_res ring_write_reserve(struct ring *r, int bytes)
{
 810:	55                   	push   %ebp
 811:	89 e5                	mov    %esp,%ebp
 813:	8b 45 08             	mov    0x8(%ebp),%eax
  struct ring_res ret = {0, 0};
  return ret;
 816:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 81d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 823:	5d                   	pop    %ebp
 824:	c2 04 00             	ret    $0x4
 827:	89 f6                	mov    %esi,%esi
 829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000830 <ring_write_notify>:

void ring_write_notify(struct ring *r, int bytes)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp

}
 833:	5d                   	pop    %ebp
 834:	c3                   	ret    
 835:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000840 <ring_read_reserve>:

struct ring_res ring_read_reserve(struct ring *r, int bytes)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	8b 45 08             	mov    0x8(%ebp),%eax
  struct ring_res ret = {0, 0};
  return ret;
 846:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 84d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 853:	5d                   	pop    %ebp
 854:	c2 04 00             	ret    $0x4
 857:	89 f6                	mov    %esi,%esi
 859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000860 <ring_read_notify>:

void ring_read_notify(struct ring *r, int bytes)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp

}
 863:	5d                   	pop    %ebp
 864:	c3                   	ret    
 865:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000870 <ring_write>:

void ring_write(struct ring *r, void *buf, int bytes)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp

}
 873:	5d                   	pop    %ebp
 874:	c3                   	ret    
 875:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000880 <ring_read>:

void ring_read(struct ring *r, void *buf, int bytes)
{
 880:	55                   	push   %ebp
 881:	89 e5                	mov    %esp,%ebp

}
 883:	5d                   	pop    %ebp
 884:	c3                   	ret    
