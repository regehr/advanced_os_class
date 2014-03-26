
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 63 09 00 	movl   $0x963,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 5d 05 00 00       	call   59d <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 1a 02 00 00       	call   276 <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 11                	jmp    7a <main+0x7a>
    if(fork() > 0)
  69:	e8 a6 03 00 00       	call   414 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7f 14                	jg     86 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  72:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  79:	01 
  7a:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  81:	03 
  82:	7e e5                	jle    69 <main+0x69>
  84:	eb 01                	jmp    87 <main+0x87>
    if(fork() > 0)
      break;
  86:	90                   	nop

  printf(1, "write %d\n", i);
  87:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  92:	c7 44 24 04 76 09 00 	movl   $0x976,0x4(%esp)
  99:	00 
  9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a1:	e8 f7 04 00 00       	call   59d <printf>

  path[8] += i;
  a6:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ad:	00 
  ae:	89 c2                	mov    %eax,%edx
  b0:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b7:	8d 04 02             	lea    (%edx,%eax,1),%eax
  ba:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  c1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c8:	00 
  c9:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  d0:	89 04 24             	mov    %eax,(%esp)
  d3:	e8 84 03 00 00       	call   45c <open>
  d8:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  df:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e6:	00 00 00 00 
  ea:	eb 27                	jmp    113 <main+0x113>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ec:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f3:	00 
  f4:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  fc:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 103:	89 04 24             	mov    %eax,(%esp)
 106:	e8 31 03 00 00       	call   43c <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 10b:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 112:	01 
 113:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 11a:	13 
 11b:	7e cf                	jle    ec <main+0xec>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 11d:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 124:	89 04 24             	mov    %eax,(%esp)
 127:	e8 18 03 00 00       	call   444 <close>

  printf(1, "read\n");
 12c:	c7 44 24 04 80 09 00 	movl   $0x980,0x4(%esp)
 133:	00 
 134:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13b:	e8 5d 04 00 00       	call   59d <printf>

  fd = open(path, O_RDONLY);
 140:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 147:	00 
 148:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14f:	89 04 24             	mov    %eax,(%esp)
 152:	e8 05 03 00 00       	call   45c <open>
 157:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15e:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 165:	00 00 00 00 
 169:	eb 27                	jmp    192 <main+0x192>
    read(fd, data, sizeof(data));
 16b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 172:	00 
 173:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 177:	89 44 24 04          	mov    %eax,0x4(%esp)
 17b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 182:	89 04 24             	mov    %eax,(%esp)
 185:	e8 aa 02 00 00       	call   434 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 18a:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 191:	01 
 192:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 199:	13 
 19a:	7e cf                	jle    16b <main+0x16b>
    read(fd, data, sizeof(data));
  close(fd);
 19c:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a3:	89 04 24             	mov    %eax,(%esp)
 1a6:	e8 99 02 00 00       	call   444 <close>

  wait();
 1ab:	e8 74 02 00 00       	call   424 <wait>
  
  exit();
 1b0:	e8 67 02 00 00       	call   41c <exit>
 1b5:	90                   	nop
 1b6:	90                   	nop
 1b7:	90                   	nop

000001b8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	57                   	push   %edi
 1bc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c0:	8b 55 10             	mov    0x10(%ebp),%edx
 1c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c6:	89 cb                	mov    %ecx,%ebx
 1c8:	89 df                	mov    %ebx,%edi
 1ca:	89 d1                	mov    %edx,%ecx
 1cc:	fc                   	cld    
 1cd:	f3 aa                	rep stos %al,%es:(%edi)
 1cf:	89 ca                	mov    %ecx,%edx
 1d1:	89 fb                	mov    %edi,%ebx
 1d3:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d9:	5b                   	pop    %ebx
 1da:	5f                   	pop    %edi
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    

000001dd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ec:	0f b6 10             	movzbl (%eax),%edx
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	88 10                	mov    %dl,(%eax)
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	0f b6 00             	movzbl (%eax),%eax
 1fa:	84 c0                	test   %al,%al
 1fc:	0f 95 c0             	setne  %al
 1ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 203:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 207:	84 c0                	test   %al,%al
 209:	75 de                	jne    1e9 <strcpy+0xc>
    ;
  return os;
 20b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20e:	c9                   	leave  
 20f:	c3                   	ret    

00000210 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 213:	eb 08                	jmp    21d <strcmp+0xd>
    p++, q++;
 215:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 219:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	0f b6 00             	movzbl (%eax),%eax
 223:	84 c0                	test   %al,%al
 225:	74 10                	je     237 <strcmp+0x27>
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	0f b6 10             	movzbl (%eax),%edx
 22d:	8b 45 0c             	mov    0xc(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	38 c2                	cmp    %al,%dl
 235:	74 de                	je     215 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	0f b6 d0             	movzbl %al,%edx
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	0f b6 c0             	movzbl %al,%eax
 249:	89 d1                	mov    %edx,%ecx
 24b:	29 c1                	sub    %eax,%ecx
 24d:	89 c8                	mov    %ecx,%eax
}
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    

00000251 <strlen>:

uint
strlen(char *s)
{
 251:	55                   	push   %ebp
 252:	89 e5                	mov    %esp,%ebp
 254:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 257:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25e:	eb 04                	jmp    264 <strlen+0x13>
 260:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 264:	8b 45 fc             	mov    -0x4(%ebp),%eax
 267:	03 45 08             	add    0x8(%ebp),%eax
 26a:	0f b6 00             	movzbl (%eax),%eax
 26d:	84 c0                	test   %al,%al
 26f:	75 ef                	jne    260 <strlen+0xf>
    ;
  return n;
 271:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 274:	c9                   	leave  
 275:	c3                   	ret    

00000276 <memset>:

void*
memset(void *dst, int c, uint n)
{
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	89 44 24 08          	mov    %eax,0x8(%esp)
 283:	8b 45 0c             	mov    0xc(%ebp),%eax
 286:	89 44 24 04          	mov    %eax,0x4(%esp)
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 04 24             	mov    %eax,(%esp)
 290:	e8 23 ff ff ff       	call   1b8 <stosb>
  return dst;
 295:	8b 45 08             	mov    0x8(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <strchr>:

char*
strchr(const char *s, char c)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 04             	sub    $0x4,%esp
 2a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2a6:	eb 14                	jmp    2bc <strchr+0x22>
    if(*s == c)
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b1:	75 05                	jne    2b8 <strchr+0x1e>
      return (char*)s;
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	eb 13                	jmp    2cb <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	0f b6 00             	movzbl (%eax),%eax
 2c2:	84 c0                	test   %al,%al
 2c4:	75 e2                	jne    2a8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2cb:	c9                   	leave  
 2cc:	c3                   	ret    

000002cd <gets>:

char*
gets(char *buf, int max)
{
 2cd:	55                   	push   %ebp
 2ce:	89 e5                	mov    %esp,%ebp
 2d0:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 2da:	eb 44                	jmp    320 <gets+0x53>
    cc = read(0, &c, 1);
 2dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2e3:	00 
 2e4:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 2eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2f2:	e8 3d 01 00 00       	call   434 <read>
 2f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 2fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2fe:	7e 2d                	jle    32d <gets+0x60>
      break;
    buf[i++] = c;
 300:	8b 45 f0             	mov    -0x10(%ebp),%eax
 303:	03 45 08             	add    0x8(%ebp),%eax
 306:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 30a:	88 10                	mov    %dl,(%eax)
 30c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 310:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 314:	3c 0a                	cmp    $0xa,%al
 316:	74 16                	je     32e <gets+0x61>
 318:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31c:	3c 0d                	cmp    $0xd,%al
 31e:	74 0e                	je     32e <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 320:	8b 45 f0             	mov    -0x10(%ebp),%eax
 323:	83 c0 01             	add    $0x1,%eax
 326:	3b 45 0c             	cmp    0xc(%ebp),%eax
 329:	7c b1                	jl     2dc <gets+0xf>
 32b:	eb 01                	jmp    32e <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 32d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 32e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 331:	03 45 08             	add    0x8(%ebp),%eax
 334:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 337:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33a:	c9                   	leave  
 33b:	c3                   	ret    

0000033c <stat>:

int
stat(char *n, struct stat *st)
{
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 342:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 349:	00 
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	89 04 24             	mov    %eax,(%esp)
 350:	e8 07 01 00 00       	call   45c <open>
 355:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 358:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 35c:	79 07                	jns    365 <stat+0x29>
    return -1;
 35e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 363:	eb 23                	jmp    388 <stat+0x4c>
  r = fstat(fd, st);
 365:	8b 45 0c             	mov    0xc(%ebp),%eax
 368:	89 44 24 04          	mov    %eax,0x4(%esp)
 36c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 36f:	89 04 24             	mov    %eax,(%esp)
 372:	e8 fd 00 00 00       	call   474 <fstat>
 377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 37a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 37d:	89 04 24             	mov    %eax,(%esp)
 380:	e8 bf 00 00 00       	call   444 <close>
  return r;
 385:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 388:	c9                   	leave  
 389:	c3                   	ret    

0000038a <atoi>:

int
atoi(const char *s)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 390:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 397:	eb 24                	jmp    3bd <atoi+0x33>
    n = n*10 + *s++ - '0';
 399:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39c:	89 d0                	mov    %edx,%eax
 39e:	c1 e0 02             	shl    $0x2,%eax
 3a1:	01 d0                	add    %edx,%eax
 3a3:	01 c0                	add    %eax,%eax
 3a5:	89 c2                	mov    %eax,%edx
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	0f b6 00             	movzbl (%eax),%eax
 3ad:	0f be c0             	movsbl %al,%eax
 3b0:	8d 04 02             	lea    (%edx,%eax,1),%eax
 3b3:	83 e8 30             	sub    $0x30,%eax
 3b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	3c 2f                	cmp    $0x2f,%al
 3c5:	7e 0a                	jle    3d1 <atoi+0x47>
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	3c 39                	cmp    $0x39,%al
 3cf:	7e c8                	jle    399 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d4:	c9                   	leave  
 3d5:	c3                   	ret    

000003d6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3d6:	55                   	push   %ebp
 3d7:	89 e5                	mov    %esp,%ebp
 3d9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 3e8:	eb 13                	jmp    3fd <memmove+0x27>
    *dst++ = *src++;
 3ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ed:	0f b6 10             	movzbl (%eax),%edx
 3f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3f3:	88 10                	mov    %dl,(%eax)
 3f5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 3f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 401:	0f 9f c0             	setg   %al
 404:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 408:	84 c0                	test   %al,%al
 40a:	75 de                	jne    3ea <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40f:	c9                   	leave  
 410:	c3                   	ret    
 411:	90                   	nop
 412:	90                   	nop
 413:	90                   	nop

00000414 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 414:	b8 01 00 00 00       	mov    $0x1,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <exit>:
SYSCALL(exit)
 41c:	b8 02 00 00 00       	mov    $0x2,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <wait>:
SYSCALL(wait)
 424:	b8 03 00 00 00       	mov    $0x3,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <pipe>:
SYSCALL(pipe)
 42c:	b8 04 00 00 00       	mov    $0x4,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <read>:
SYSCALL(read)
 434:	b8 05 00 00 00       	mov    $0x5,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <write>:
SYSCALL(write)
 43c:	b8 10 00 00 00       	mov    $0x10,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <close>:
SYSCALL(close)
 444:	b8 15 00 00 00       	mov    $0x15,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <kill>:
SYSCALL(kill)
 44c:	b8 06 00 00 00       	mov    $0x6,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <exec>:
SYSCALL(exec)
 454:	b8 07 00 00 00       	mov    $0x7,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <open>:
SYSCALL(open)
 45c:	b8 0f 00 00 00       	mov    $0xf,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <mknod>:
SYSCALL(mknod)
 464:	b8 11 00 00 00       	mov    $0x11,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <unlink>:
SYSCALL(unlink)
 46c:	b8 12 00 00 00       	mov    $0x12,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <fstat>:
SYSCALL(fstat)
 474:	b8 08 00 00 00       	mov    $0x8,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <link>:
SYSCALL(link)
 47c:	b8 13 00 00 00       	mov    $0x13,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <mkdir>:
SYSCALL(mkdir)
 484:	b8 14 00 00 00       	mov    $0x14,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <chdir>:
SYSCALL(chdir)
 48c:	b8 09 00 00 00       	mov    $0x9,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <dup>:
SYSCALL(dup)
 494:	b8 0a 00 00 00       	mov    $0xa,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <getpid>:
SYSCALL(getpid)
 49c:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <sbrk>:
SYSCALL(sbrk)
 4a4:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <sleep>:
SYSCALL(sleep)
 4ac:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <uptime>:
SYSCALL(uptime)
 4b4:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <setpriority>:
 4bc:	b8 16 00 00 00       	mov    $0x16,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	83 ec 28             	sub    $0x28,%esp
 4ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d7:	00 
 4d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4db:	89 44 24 04          	mov    %eax,0x4(%esp)
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	89 04 24             	mov    %eax,(%esp)
 4e5:	e8 52 ff ff ff       	call   43c <write>
}
 4ea:	c9                   	leave  
 4eb:	c3                   	ret    

000004ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ec:	55                   	push   %ebp
 4ed:	89 e5                	mov    %esp,%ebp
 4ef:	53                   	push   %ebx
 4f0:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4fa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4fe:	74 17                	je     517 <printint+0x2b>
 500:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 504:	79 11                	jns    517 <printint+0x2b>
    neg = 1;
 506:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 50d:	8b 45 0c             	mov    0xc(%ebp),%eax
 510:	f7 d8                	neg    %eax
 512:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 515:	eb 06                	jmp    51d <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 517:	8b 45 0c             	mov    0xc(%ebp),%eax
 51a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 51d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 524:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 527:	8b 5d 10             	mov    0x10(%ebp),%ebx
 52a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52d:	ba 00 00 00 00       	mov    $0x0,%edx
 532:	f7 f3                	div    %ebx
 534:	89 d0                	mov    %edx,%eax
 536:	0f b6 80 90 09 00 00 	movzbl 0x990(%eax),%eax
 53d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 541:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 545:	8b 45 10             	mov    0x10(%ebp),%eax
 548:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 54b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54e:	ba 00 00 00 00       	mov    $0x0,%edx
 553:	f7 75 d4             	divl   -0x2c(%ebp)
 556:	89 45 f4             	mov    %eax,-0xc(%ebp)
 559:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55d:	75 c5                	jne    524 <printint+0x38>
  if(neg)
 55f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 563:	74 28                	je     58d <printint+0xa1>
    buf[i++] = '-';
 565:	8b 45 ec             	mov    -0x14(%ebp),%eax
 568:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 56d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 571:	eb 1a                	jmp    58d <printint+0xa1>
    putc(fd, buf[i]);
 573:	8b 45 ec             	mov    -0x14(%ebp),%eax
 576:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 57b:	0f be c0             	movsbl %al,%eax
 57e:	89 44 24 04          	mov    %eax,0x4(%esp)
 582:	8b 45 08             	mov    0x8(%ebp),%eax
 585:	89 04 24             	mov    %eax,(%esp)
 588:	e8 37 ff ff ff       	call   4c4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 58d:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 591:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 595:	79 dc                	jns    573 <printint+0x87>
    putc(fd, buf[i]);
}
 597:	83 c4 44             	add    $0x44,%esp
 59a:	5b                   	pop    %ebx
 59b:	5d                   	pop    %ebp
 59c:	c3                   	ret    

0000059d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 59d:	55                   	push   %ebp
 59e:	89 e5                	mov    %esp,%ebp
 5a0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5aa:	8d 45 0c             	lea    0xc(%ebp),%eax
 5ad:	83 c0 04             	add    $0x4,%eax
 5b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 5b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 5ba:	e9 7e 01 00 00       	jmp    73d <printf+0x1a0>
    c = fmt[i] & 0xff;
 5bf:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c5:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5c8:	0f b6 00             	movzbl (%eax),%eax
 5cb:	0f be c0             	movsbl %al,%eax
 5ce:	25 ff 00 00 00       	and    $0xff,%eax
 5d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 5d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5da:	75 2c                	jne    608 <printf+0x6b>
      if(c == '%'){
 5dc:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5e0:	75 0c                	jne    5ee <printf+0x51>
        state = '%';
 5e2:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 5e9:	e9 4b 01 00 00       	jmp    739 <printf+0x19c>
      } else {
        putc(fd, c);
 5ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f1:	0f be c0             	movsbl %al,%eax
 5f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f8:	8b 45 08             	mov    0x8(%ebp),%eax
 5fb:	89 04 24             	mov    %eax,(%esp)
 5fe:	e8 c1 fe ff ff       	call   4c4 <putc>
 603:	e9 31 01 00 00       	jmp    739 <printf+0x19c>
      }
    } else if(state == '%'){
 608:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 60c:	0f 85 27 01 00 00    	jne    739 <printf+0x19c>
      if(c == 'd'){
 612:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 616:	75 2d                	jne    645 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 618:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61b:	8b 00                	mov    (%eax),%eax
 61d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 624:	00 
 625:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 62c:	00 
 62d:	89 44 24 04          	mov    %eax,0x4(%esp)
 631:	8b 45 08             	mov    0x8(%ebp),%eax
 634:	89 04 24             	mov    %eax,(%esp)
 637:	e8 b0 fe ff ff       	call   4ec <printint>
        ap++;
 63c:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 640:	e9 ed 00 00 00       	jmp    732 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 645:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 649:	74 06                	je     651 <printf+0xb4>
 64b:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 64f:	75 2d                	jne    67e <printf+0xe1>
        printint(fd, *ap, 16, 0);
 651:	8b 45 f4             	mov    -0xc(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 65d:	00 
 65e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 665:	00 
 666:	89 44 24 04          	mov    %eax,0x4(%esp)
 66a:	8b 45 08             	mov    0x8(%ebp),%eax
 66d:	89 04 24             	mov    %eax,(%esp)
 670:	e8 77 fe ff ff       	call   4ec <printint>
        ap++;
 675:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 679:	e9 b4 00 00 00       	jmp    732 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 67e:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 682:	75 46                	jne    6ca <printf+0x12d>
        s = (char*)*ap;
 684:	8b 45 f4             	mov    -0xc(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 68c:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 690:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 694:	75 27                	jne    6bd <printf+0x120>
          s = "(null)";
 696:	c7 45 e4 86 09 00 00 	movl   $0x986,-0x1c(%ebp)
        while(*s != 0){
 69d:	eb 1f                	jmp    6be <printf+0x121>
          putc(fd, *s);
 69f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a2:	0f b6 00             	movzbl (%eax),%eax
 6a5:	0f be c0             	movsbl %al,%eax
 6a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	89 04 24             	mov    %eax,(%esp)
 6b2:	e8 0d fe ff ff       	call   4c4 <putc>
          s++;
 6b7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 6bb:	eb 01                	jmp    6be <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6bd:	90                   	nop
 6be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c1:	0f b6 00             	movzbl (%eax),%eax
 6c4:	84 c0                	test   %al,%al
 6c6:	75 d7                	jne    69f <printf+0x102>
 6c8:	eb 68                	jmp    732 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ca:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 6ce:	75 1d                	jne    6ed <printf+0x150>
        putc(fd, *ap);
 6d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d3:	8b 00                	mov    (%eax),%eax
 6d5:	0f be c0             	movsbl %al,%eax
 6d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6dc:	8b 45 08             	mov    0x8(%ebp),%eax
 6df:	89 04 24             	mov    %eax,(%esp)
 6e2:	e8 dd fd ff ff       	call   4c4 <putc>
        ap++;
 6e7:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 6eb:	eb 45                	jmp    732 <printf+0x195>
      } else if(c == '%'){
 6ed:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 6f1:	75 17                	jne    70a <printf+0x16d>
        putc(fd, c);
 6f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f6:	0f be c0             	movsbl %al,%eax
 6f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6fd:	8b 45 08             	mov    0x8(%ebp),%eax
 700:	89 04 24             	mov    %eax,(%esp)
 703:	e8 bc fd ff ff       	call   4c4 <putc>
 708:	eb 28                	jmp    732 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 70a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 711:	00 
 712:	8b 45 08             	mov    0x8(%ebp),%eax
 715:	89 04 24             	mov    %eax,(%esp)
 718:	e8 a7 fd ff ff       	call   4c4 <putc>
        putc(fd, c);
 71d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 720:	0f be c0             	movsbl %al,%eax
 723:	89 44 24 04          	mov    %eax,0x4(%esp)
 727:	8b 45 08             	mov    0x8(%ebp),%eax
 72a:	89 04 24             	mov    %eax,(%esp)
 72d:	e8 92 fd ff ff       	call   4c4 <putc>
      }
      state = 0;
 732:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 739:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 73d:	8b 55 0c             	mov    0xc(%ebp),%edx
 740:	8b 45 ec             	mov    -0x14(%ebp),%eax
 743:	8d 04 02             	lea    (%edx,%eax,1),%eax
 746:	0f b6 00             	movzbl (%eax),%eax
 749:	84 c0                	test   %al,%al
 74b:	0f 85 6e fe ff ff    	jne    5bf <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 751:	c9                   	leave  
 752:	c3                   	ret    
 753:	90                   	nop

00000754 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 754:	55                   	push   %ebp
 755:	89 e5                	mov    %esp,%ebp
 757:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
 75d:	83 e8 08             	sub    $0x8,%eax
 760:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 763:	a1 ac 09 00 00       	mov    0x9ac,%eax
 768:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76b:	eb 24                	jmp    791 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 00                	mov    (%eax),%eax
 772:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 775:	77 12                	ja     789 <free+0x35>
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 77d:	77 24                	ja     7a3 <free+0x4f>
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 00                	mov    (%eax),%eax
 784:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 787:	77 1a                	ja     7a3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 00                	mov    (%eax),%eax
 78e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 791:	8b 45 f8             	mov    -0x8(%ebp),%eax
 794:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 797:	76 d4                	jbe    76d <free+0x19>
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a1:	76 ca                	jbe    76d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a6:	8b 40 04             	mov    0x4(%eax),%eax
 7a9:	c1 e0 03             	shl    $0x3,%eax
 7ac:	89 c2                	mov    %eax,%edx
 7ae:	03 55 f8             	add    -0x8(%ebp),%edx
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 00                	mov    (%eax),%eax
 7b6:	39 c2                	cmp    %eax,%edx
 7b8:	75 24                	jne    7de <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 7ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bd:	8b 50 04             	mov    0x4(%eax),%edx
 7c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c3:	8b 00                	mov    (%eax),%eax
 7c5:	8b 40 04             	mov    0x4(%eax),%eax
 7c8:	01 c2                	add    %eax,%edx
 7ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	8b 00                	mov    (%eax),%eax
 7d5:	8b 10                	mov    (%eax),%edx
 7d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7da:	89 10                	mov    %edx,(%eax)
 7dc:	eb 0a                	jmp    7e8 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	8b 10                	mov    (%eax),%edx
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	c1 e0 03             	shl    $0x3,%eax
 7f1:	03 45 fc             	add    -0x4(%ebp),%eax
 7f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f7:	75 20                	jne    819 <free+0xc5>
    p->s.size += bp->s.size;
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	8b 50 04             	mov    0x4(%eax),%edx
 7ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 802:	8b 40 04             	mov    0x4(%eax),%eax
 805:	01 c2                	add    %eax,%edx
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 80d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 810:	8b 10                	mov    (%eax),%edx
 812:	8b 45 fc             	mov    -0x4(%ebp),%eax
 815:	89 10                	mov    %edx,(%eax)
 817:	eb 08                	jmp    821 <free+0xcd>
  } else
    p->s.ptr = bp;
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 81f:	89 10                	mov    %edx,(%eax)
  freep = p;
 821:	8b 45 fc             	mov    -0x4(%ebp),%eax
 824:	a3 ac 09 00 00       	mov    %eax,0x9ac
}
 829:	c9                   	leave  
 82a:	c3                   	ret    

0000082b <morecore>:

static Header*
morecore(uint nu)
{
 82b:	55                   	push   %ebp
 82c:	89 e5                	mov    %esp,%ebp
 82e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 831:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 838:	77 07                	ja     841 <morecore+0x16>
    nu = 4096;
 83a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 841:	8b 45 08             	mov    0x8(%ebp),%eax
 844:	c1 e0 03             	shl    $0x3,%eax
 847:	89 04 24             	mov    %eax,(%esp)
 84a:	e8 55 fc ff ff       	call   4a4 <sbrk>
 84f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 852:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 856:	75 07                	jne    85f <morecore+0x34>
    return 0;
 858:	b8 00 00 00 00       	mov    $0x0,%eax
 85d:	eb 22                	jmp    881 <morecore+0x56>
  hp = (Header*)p;
 85f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 862:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	8b 55 08             	mov    0x8(%ebp),%edx
 86b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	83 c0 08             	add    $0x8,%eax
 874:	89 04 24             	mov    %eax,(%esp)
 877:	e8 d8 fe ff ff       	call   754 <free>
  return freep;
 87c:	a1 ac 09 00 00       	mov    0x9ac,%eax
}
 881:	c9                   	leave  
 882:	c3                   	ret    

00000883 <malloc>:

void*
malloc(uint nbytes)
{
 883:	55                   	push   %ebp
 884:	89 e5                	mov    %esp,%ebp
 886:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 889:	8b 45 08             	mov    0x8(%ebp),%eax
 88c:	83 c0 07             	add    $0x7,%eax
 88f:	c1 e8 03             	shr    $0x3,%eax
 892:	83 c0 01             	add    $0x1,%eax
 895:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 898:	a1 ac 09 00 00       	mov    0x9ac,%eax
 89d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8a4:	75 23                	jne    8c9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8a6:	c7 45 f0 a4 09 00 00 	movl   $0x9a4,-0x10(%ebp)
 8ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b0:	a3 ac 09 00 00       	mov    %eax,0x9ac
 8b5:	a1 ac 09 00 00       	mov    0x9ac,%eax
 8ba:	a3 a4 09 00 00       	mov    %eax,0x9a4
    base.s.size = 0;
 8bf:	c7 05 a8 09 00 00 00 	movl   $0x0,0x9a8
 8c6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cc:	8b 00                	mov    (%eax),%eax
 8ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 8d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8d4:	8b 40 04             	mov    0x4(%eax),%eax
 8d7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8da:	72 4d                	jb     929 <malloc+0xa6>
      if(p->s.size == nunits)
 8dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8df:	8b 40 04             	mov    0x4(%eax),%eax
 8e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8e5:	75 0c                	jne    8f3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ea:	8b 10                	mov    (%eax),%edx
 8ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ef:	89 10                	mov    %edx,(%eax)
 8f1:	eb 26                	jmp    919 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f6:	8b 40 04             	mov    0x4(%eax),%eax
 8f9:	89 c2                	mov    %eax,%edx
 8fb:	2b 55 f4             	sub    -0xc(%ebp),%edx
 8fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 901:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 904:	8b 45 ec             	mov    -0x14(%ebp),%eax
 907:	8b 40 04             	mov    0x4(%eax),%eax
 90a:	c1 e0 03             	shl    $0x3,%eax
 90d:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 910:	8b 45 ec             	mov    -0x14(%ebp),%eax
 913:	8b 55 f4             	mov    -0xc(%ebp),%edx
 916:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 919:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91c:	a3 ac 09 00 00       	mov    %eax,0x9ac
      return (void*)(p + 1);
 921:	8b 45 ec             	mov    -0x14(%ebp),%eax
 924:	83 c0 08             	add    $0x8,%eax
 927:	eb 38                	jmp    961 <malloc+0xde>
    }
    if(p == freep)
 929:	a1 ac 09 00 00       	mov    0x9ac,%eax
 92e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 931:	75 1b                	jne    94e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 933:	8b 45 f4             	mov    -0xc(%ebp),%eax
 936:	89 04 24             	mov    %eax,(%esp)
 939:	e8 ed fe ff ff       	call   82b <morecore>
 93e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 941:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 945:	75 07                	jne    94e <malloc+0xcb>
        return 0;
 947:	b8 00 00 00 00       	mov    $0x0,%eax
 94c:	eb 13                	jmp    961 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 951:	89 45 f0             	mov    %eax,-0x10(%ebp)
 954:	8b 45 ec             	mov    -0x14(%ebp),%eax
 957:	8b 00                	mov    (%eax),%eax
 959:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 95c:	e9 70 ff ff ff       	jmp    8d1 <malloc+0x4e>
}
 961:	c9                   	leave  
 962:	c3                   	ret    
