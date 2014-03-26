
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  write(fd, s, strlen(s));
   6:	8b 45 0c             	mov    0xc(%ebp),%eax
   9:	89 04 24             	mov    %eax,(%esp)
   c:	e8 9c 01 00 00       	call   1ad <strlen>
  11:	89 44 24 08          	mov    %eax,0x8(%esp)
  15:	8b 45 0c             	mov    0xc(%ebp),%eax
  18:	89 44 24 04          	mov    %eax,0x4(%esp)
  1c:	8b 45 08             	mov    0x8(%ebp),%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 71 03 00 00       	call   398 <write>
}
  27:	c9                   	leave  
  28:	c3                   	ret    

00000029 <forktest>:

void
forktest(void)
{
  29:	55                   	push   %ebp
  2a:	89 e5                	mov    %esp,%ebp
  2c:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
  2f:	c7 44 24 04 20 04 00 	movl   $0x420,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 bd ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  43:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  4a:	eb 1d                	jmp    69 <forktest+0x40>
    pid = fork();
  4c:	e8 1f 03 00 00       	call   370 <fork>
  51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0)
  54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  58:	78 1a                	js     74 <forktest+0x4b>
      break;
    if(pid == 0)
  5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  5e:	75 05                	jne    65 <forktest+0x3c>
      exit();
  60:	e8 13 03 00 00       	call   378 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  65:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  69:	81 7d f0 e7 03 00 00 	cmpl   $0x3e7,-0x10(%ebp)
  70:	7e da                	jle    4c <forktest+0x23>
  72:	eb 01                	jmp    75 <forktest+0x4c>
    pid = fork();
    if(pid < 0)
      break;
  74:	90                   	nop
    if(pid == 0)
      exit();
  }
  
  if(n == N){
  75:	81 7d f0 e8 03 00 00 	cmpl   $0x3e8,-0x10(%ebp)
  7c:	75 47                	jne    c5 <forktest+0x9c>
    printf(1, "fork claimed to work N times!\n", N);
  7e:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
  85:	00 
  86:	c7 44 24 04 2c 04 00 	movl   $0x42c,0x4(%esp)
  8d:	00 
  8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  95:	e8 66 ff ff ff       	call   0 <printf>
    exit();
  9a:	e8 d9 02 00 00       	call   378 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
  9f:	e8 dc 02 00 00       	call   380 <wait>
  a4:	85 c0                	test   %eax,%eax
  a6:	79 19                	jns    c1 <forktest+0x98>
      printf(1, "wait stopped early\n");
  a8:	c7 44 24 04 4b 04 00 	movl   $0x44b,0x4(%esp)
  af:	00 
  b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b7:	e8 44 ff ff ff       	call   0 <printf>
      exit();
  bc:	e8 b7 02 00 00       	call   378 <exit>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }
  
  for(; n > 0; n--){
  c1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
  c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  c9:	7f d4                	jg     9f <forktest+0x76>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
  cb:	e8 b0 02 00 00       	call   380 <wait>
  d0:	83 f8 ff             	cmp    $0xffffffff,%eax
  d3:	74 19                	je     ee <forktest+0xc5>
    printf(1, "wait got too many\n");
  d5:	c7 44 24 04 5f 04 00 	movl   $0x45f,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 17 ff ff ff       	call   0 <printf>
    exit();
  e9:	e8 8a 02 00 00       	call   378 <exit>
  }
  
  printf(1, "fork test OK\n");
  ee:	c7 44 24 04 72 04 00 	movl   $0x472,0x4(%esp)
  f5:	00 
  f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fd:	e8 fe fe ff ff       	call   0 <printf>
}
 102:	c9                   	leave  
 103:	c3                   	ret    

00000104 <main>:

int
main(void)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
 10a:	e8 1a ff ff ff       	call   29 <forktest>
  exit();
 10f:	e8 64 02 00 00       	call   378 <exit>

00000114 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 119:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11c:	8b 55 10             	mov    0x10(%ebp),%edx
 11f:	8b 45 0c             	mov    0xc(%ebp),%eax
 122:	89 cb                	mov    %ecx,%ebx
 124:	89 df                	mov    %ebx,%edi
 126:	89 d1                	mov    %edx,%ecx
 128:	fc                   	cld    
 129:	f3 aa                	rep stos %al,%es:(%edi)
 12b:	89 ca                	mov    %ecx,%edx
 12d:	89 fb                	mov    %edi,%ebx
 12f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 132:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 135:	5b                   	pop    %ebx
 136:	5f                   	pop    %edi
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    

00000139 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 145:	8b 45 0c             	mov    0xc(%ebp),%eax
 148:	0f b6 10             	movzbl (%eax),%edx
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	88 10                	mov    %dl,(%eax)
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	0f b6 00             	movzbl (%eax),%eax
 156:	84 c0                	test   %al,%al
 158:	0f 95 c0             	setne  %al
 15b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 163:	84 c0                	test   %al,%al
 165:	75 de                	jne    145 <strcpy+0xc>
    ;
  return os;
 167:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16a:	c9                   	leave  
 16b:	c3                   	ret    

0000016c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16f:	eb 08                	jmp    179 <strcmp+0xd>
    p++, q++;
 171:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 175:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	0f b6 00             	movzbl (%eax),%eax
 17f:	84 c0                	test   %al,%al
 181:	74 10                	je     193 <strcmp+0x27>
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	0f b6 10             	movzbl (%eax),%edx
 189:	8b 45 0c             	mov    0xc(%ebp),%eax
 18c:	0f b6 00             	movzbl (%eax),%eax
 18f:	38 c2                	cmp    %al,%dl
 191:	74 de                	je     171 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	0f b6 00             	movzbl (%eax),%eax
 199:	0f b6 d0             	movzbl %al,%edx
 19c:	8b 45 0c             	mov    0xc(%ebp),%eax
 19f:	0f b6 00             	movzbl (%eax),%eax
 1a2:	0f b6 c0             	movzbl %al,%eax
 1a5:	89 d1                	mov    %edx,%ecx
 1a7:	29 c1                	sub    %eax,%ecx
 1a9:	89 c8                	mov    %ecx,%eax
}
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    

000001ad <strlen>:

uint
strlen(char *s)
{
 1ad:	55                   	push   %ebp
 1ae:	89 e5                	mov    %esp,%ebp
 1b0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ba:	eb 04                	jmp    1c0 <strlen+0x13>
 1bc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1c3:	03 45 08             	add    0x8(%ebp),%eax
 1c6:	0f b6 00             	movzbl (%eax),%eax
 1c9:	84 c0                	test   %al,%al
 1cb:	75 ef                	jne    1bc <strlen+0xf>
    ;
  return n;
 1cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d0:	c9                   	leave  
 1d1:	c3                   	ret    

000001d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d2:	55                   	push   %ebp
 1d3:	89 e5                	mov    %esp,%ebp
 1d5:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d8:	8b 45 10             	mov    0x10(%ebp),%eax
 1db:	89 44 24 08          	mov    %eax,0x8(%esp)
 1df:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	89 04 24             	mov    %eax,(%esp)
 1ec:	e8 23 ff ff ff       	call   114 <stosb>
  return dst;
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f4:	c9                   	leave  
 1f5:	c3                   	ret    

000001f6 <strchr>:

char*
strchr(const char *s, char c)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	83 ec 04             	sub    $0x4,%esp
 1fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ff:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 202:	eb 14                	jmp    218 <strchr+0x22>
    if(*s == c)
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 20d:	75 05                	jne    214 <strchr+0x1e>
      return (char*)s;
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	eb 13                	jmp    227 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 214:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	0f b6 00             	movzbl (%eax),%eax
 21e:	84 c0                	test   %al,%al
 220:	75 e2                	jne    204 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 222:	b8 00 00 00 00       	mov    $0x0,%eax
}
 227:	c9                   	leave  
 228:	c3                   	ret    

00000229 <gets>:

char*
gets(char *buf, int max)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
 22c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 236:	eb 44                	jmp    27c <gets+0x53>
    cc = read(0, &c, 1);
 238:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 23f:	00 
 240:	8d 45 ef             	lea    -0x11(%ebp),%eax
 243:	89 44 24 04          	mov    %eax,0x4(%esp)
 247:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 24e:	e8 3d 01 00 00       	call   390 <read>
 253:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 256:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 25a:	7e 2d                	jle    289 <gets+0x60>
      break;
    buf[i++] = c;
 25c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 25f:	03 45 08             	add    0x8(%ebp),%eax
 262:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 266:	88 10                	mov    %dl,(%eax)
 268:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 26c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 270:	3c 0a                	cmp    $0xa,%al
 272:	74 16                	je     28a <gets+0x61>
 274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 278:	3c 0d                	cmp    $0xd,%al
 27a:	74 0e                	je     28a <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 27f:	83 c0 01             	add    $0x1,%eax
 282:	3b 45 0c             	cmp    0xc(%ebp),%eax
 285:	7c b1                	jl     238 <gets+0xf>
 287:	eb 01                	jmp    28a <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 289:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 28d:	03 45 08             	add    0x8(%ebp),%eax
 290:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 293:	8b 45 08             	mov    0x8(%ebp),%eax
}
 296:	c9                   	leave  
 297:	c3                   	ret    

00000298 <stat>:

int
stat(char *n, struct stat *st)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a5:	00 
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	89 04 24             	mov    %eax,(%esp)
 2ac:	e8 07 01 00 00       	call   3b8 <open>
 2b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 2b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2b8:	79 07                	jns    2c1 <stat+0x29>
    return -1;
 2ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2bf:	eb 23                	jmp    2e4 <stat+0x4c>
  r = fstat(fd, st);
 2c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2cb:	89 04 24             	mov    %eax,(%esp)
 2ce:	e8 fd 00 00 00       	call   3d0 <fstat>
 2d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 2d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2d9:	89 04 24             	mov    %eax,(%esp)
 2dc:	e8 bf 00 00 00       	call   3a0 <close>
  return r;
 2e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <atoi>:

int
atoi(const char *s)
{
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f3:	eb 24                	jmp    319 <atoi+0x33>
    n = n*10 + *s++ - '0';
 2f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f8:	89 d0                	mov    %edx,%eax
 2fa:	c1 e0 02             	shl    $0x2,%eax
 2fd:	01 d0                	add    %edx,%eax
 2ff:	01 c0                	add    %eax,%eax
 301:	89 c2                	mov    %eax,%edx
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	0f b6 00             	movzbl (%eax),%eax
 309:	0f be c0             	movsbl %al,%eax
 30c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 30f:	83 e8 30             	sub    $0x30,%eax
 312:	89 45 fc             	mov    %eax,-0x4(%ebp)
 315:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	0f b6 00             	movzbl (%eax),%eax
 31f:	3c 2f                	cmp    $0x2f,%al
 321:	7e 0a                	jle    32d <atoi+0x47>
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	0f b6 00             	movzbl (%eax),%eax
 329:	3c 39                	cmp    $0x39,%al
 32b:	7e c8                	jle    2f5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 32d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 33e:	8b 45 0c             	mov    0xc(%ebp),%eax
 341:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 344:	eb 13                	jmp    359 <memmove+0x27>
    *dst++ = *src++;
 346:	8b 45 fc             	mov    -0x4(%ebp),%eax
 349:	0f b6 10             	movzbl (%eax),%edx
 34c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 34f:	88 10                	mov    %dl,(%eax)
 351:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 355:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 359:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 35d:	0f 9f c0             	setg   %al
 360:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 364:	84 c0                	test   %al,%al
 366:	75 de                	jne    346 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 368:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36b:	c9                   	leave  
 36c:	c3                   	ret    
 36d:	90                   	nop
 36e:	90                   	nop
 36f:	90                   	nop

00000370 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 370:	b8 01 00 00 00       	mov    $0x1,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <exit>:
SYSCALL(exit)
 378:	b8 02 00 00 00       	mov    $0x2,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <wait>:
SYSCALL(wait)
 380:	b8 03 00 00 00       	mov    $0x3,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <pipe>:
SYSCALL(pipe)
 388:	b8 04 00 00 00       	mov    $0x4,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <read>:
SYSCALL(read)
 390:	b8 05 00 00 00       	mov    $0x5,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <write>:
SYSCALL(write)
 398:	b8 10 00 00 00       	mov    $0x10,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <close>:
SYSCALL(close)
 3a0:	b8 15 00 00 00       	mov    $0x15,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <kill>:
SYSCALL(kill)
 3a8:	b8 06 00 00 00       	mov    $0x6,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <exec>:
SYSCALL(exec)
 3b0:	b8 07 00 00 00       	mov    $0x7,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <open>:
SYSCALL(open)
 3b8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <mknod>:
SYSCALL(mknod)
 3c0:	b8 11 00 00 00       	mov    $0x11,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <unlink>:
SYSCALL(unlink)
 3c8:	b8 12 00 00 00       	mov    $0x12,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <fstat>:
SYSCALL(fstat)
 3d0:	b8 08 00 00 00       	mov    $0x8,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <link>:
SYSCALL(link)
 3d8:	b8 13 00 00 00       	mov    $0x13,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <mkdir>:
SYSCALL(mkdir)
 3e0:	b8 14 00 00 00       	mov    $0x14,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <chdir>:
SYSCALL(chdir)
 3e8:	b8 09 00 00 00       	mov    $0x9,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <dup>:
SYSCALL(dup)
 3f0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <getpid>:
SYSCALL(getpid)
 3f8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <sbrk>:
SYSCALL(sbrk)
 400:	b8 0c 00 00 00       	mov    $0xc,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <sleep>:
SYSCALL(sleep)
 408:	b8 0d 00 00 00       	mov    $0xd,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <uptime>:
SYSCALL(uptime)
 410:	b8 0e 00 00 00       	mov    $0xe,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <setpriority>:
 418:	b8 16 00 00 00       	mov    $0x16,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    
