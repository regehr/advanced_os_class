
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 72 02 00 00       	call   280 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 fa 02 00 00       	call   318 <sleep>
  exit();
  1e:	e8 65 02 00 00       	call   288 <exit>
  23:	90                   	nop

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	5b                   	pop    %ebx
  46:	5f                   	pop    %edi
  47:	5d                   	pop    %ebp
  48:	c3                   	ret    

00000049 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  49:	55                   	push   %ebp
  4a:	89 e5                	mov    %esp,%ebp
  4c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4f:	8b 45 08             	mov    0x8(%ebp),%eax
  52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  55:	8b 45 0c             	mov    0xc(%ebp),%eax
  58:	0f b6 10             	movzbl (%eax),%edx
  5b:	8b 45 08             	mov    0x8(%ebp),%eax
  5e:	88 10                	mov    %dl,(%eax)
  60:	8b 45 08             	mov    0x8(%ebp),%eax
  63:	0f b6 00             	movzbl (%eax),%eax
  66:	84 c0                	test   %al,%al
  68:	0f 95 c0             	setne  %al
  6b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  6f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  73:	84 c0                	test   %al,%al
  75:	75 de                	jne    55 <strcpy+0xc>
    ;
  return os;
  77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7a:	c9                   	leave  
  7b:	c3                   	ret    

0000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7f:	eb 08                	jmp    89 <strcmp+0xd>
    p++, q++;
  81:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  85:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  89:	8b 45 08             	mov    0x8(%ebp),%eax
  8c:	0f b6 00             	movzbl (%eax),%eax
  8f:	84 c0                	test   %al,%al
  91:	74 10                	je     a3 <strcmp+0x27>
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	0f b6 10             	movzbl (%eax),%edx
  99:	8b 45 0c             	mov    0xc(%ebp),%eax
  9c:	0f b6 00             	movzbl (%eax),%eax
  9f:	38 c2                	cmp    %al,%dl
  a1:	74 de                	je     81 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	0f b6 00             	movzbl (%eax),%eax
  a9:	0f b6 d0             	movzbl %al,%edx
  ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	0f b6 c0             	movzbl %al,%eax
  b5:	89 d1                	mov    %edx,%ecx
  b7:	29 c1                	sub    %eax,%ecx
  b9:	89 c8                	mov    %ecx,%eax
}
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    

000000bd <strlen>:

uint
strlen(char *s)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ca:	eb 04                	jmp    d0 <strlen+0x13>
  cc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  d3:	03 45 08             	add    0x8(%ebp),%eax
  d6:	0f b6 00             	movzbl (%eax),%eax
  d9:	84 c0                	test   %al,%al
  db:	75 ef                	jne    cc <strlen+0xf>
    ;
  return n;
  dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e0:	c9                   	leave  
  e1:	c3                   	ret    

000000e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e2:	55                   	push   %ebp
  e3:	89 e5                	mov    %esp,%ebp
  e5:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  e8:	8b 45 10             	mov    0x10(%ebp),%eax
  eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	89 04 24             	mov    %eax,(%esp)
  fc:	e8 23 ff ff ff       	call   24 <stosb>
  return dst;
 101:	8b 45 08             	mov    0x8(%ebp),%eax
}
 104:	c9                   	leave  
 105:	c3                   	ret    

00000106 <strchr>:

char*
strchr(const char *s, char c)
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 ec 04             	sub    $0x4,%esp
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 112:	eb 14                	jmp    128 <strchr+0x22>
    if(*s == c)
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	0f b6 00             	movzbl (%eax),%eax
 11a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 11d:	75 05                	jne    124 <strchr+0x1e>
      return (char*)s;
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	eb 13                	jmp    137 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 124:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 128:	8b 45 08             	mov    0x8(%ebp),%eax
 12b:	0f b6 00             	movzbl (%eax),%eax
 12e:	84 c0                	test   %al,%al
 130:	75 e2                	jne    114 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 132:	b8 00 00 00 00       	mov    $0x0,%eax
}
 137:	c9                   	leave  
 138:	c3                   	ret    

00000139 <gets>:

char*
gets(char *buf, int max)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 146:	eb 44                	jmp    18c <gets+0x53>
    cc = read(0, &c, 1);
 148:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 14f:	00 
 150:	8d 45 ef             	lea    -0x11(%ebp),%eax
 153:	89 44 24 04          	mov    %eax,0x4(%esp)
 157:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15e:	e8 3d 01 00 00       	call   2a0 <read>
 163:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 166:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 16a:	7e 2d                	jle    199 <gets+0x60>
      break;
    buf[i++] = c;
 16c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 16f:	03 45 08             	add    0x8(%ebp),%eax
 172:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 176:	88 10                	mov    %dl,(%eax)
 178:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 17c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 180:	3c 0a                	cmp    $0xa,%al
 182:	74 16                	je     19a <gets+0x61>
 184:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 188:	3c 0d                	cmp    $0xd,%al
 18a:	74 0e                	je     19a <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 18f:	83 c0 01             	add    $0x1,%eax
 192:	3b 45 0c             	cmp    0xc(%ebp),%eax
 195:	7c b1                	jl     148 <gets+0xf>
 197:	eb 01                	jmp    19a <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 199:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 19d:	03 45 08             	add    0x8(%ebp),%eax
 1a0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <stat>:

int
stat(char *n, struct stat *st)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
 1ab:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1b5:	00 
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	89 04 24             	mov    %eax,(%esp)
 1bc:	e8 07 01 00 00       	call   2c8 <open>
 1c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 1c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c8:	79 07                	jns    1d1 <stat+0x29>
    return -1;
 1ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1cf:	eb 23                	jmp    1f4 <stat+0x4c>
  r = fstat(fd, st);
 1d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1db:	89 04 24             	mov    %eax,(%esp)
 1de:	e8 fd 00 00 00       	call   2e0 <fstat>
 1e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 1e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1e9:	89 04 24             	mov    %eax,(%esp)
 1ec:	e8 bf 00 00 00       	call   2b0 <close>
  return r;
 1f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 1f4:	c9                   	leave  
 1f5:	c3                   	ret    

000001f6 <atoi>:

int
atoi(const char *s)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 203:	eb 24                	jmp    229 <atoi+0x33>
    n = n*10 + *s++ - '0';
 205:	8b 55 fc             	mov    -0x4(%ebp),%edx
 208:	89 d0                	mov    %edx,%eax
 20a:	c1 e0 02             	shl    $0x2,%eax
 20d:	01 d0                	add    %edx,%eax
 20f:	01 c0                	add    %eax,%eax
 211:	89 c2                	mov    %eax,%edx
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	0f b6 00             	movzbl (%eax),%eax
 219:	0f be c0             	movsbl %al,%eax
 21c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 21f:	83 e8 30             	sub    $0x30,%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
 225:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	3c 2f                	cmp    $0x2f,%al
 231:	7e 0a                	jle    23d <atoi+0x47>
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	0f b6 00             	movzbl (%eax),%eax
 239:	3c 39                	cmp    $0x39,%al
 23b:	7e c8                	jle    205 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 23d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 240:	c9                   	leave  
 241:	c3                   	ret    

00000242 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 242:	55                   	push   %ebp
 243:	89 e5                	mov    %esp,%ebp
 245:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 24e:	8b 45 0c             	mov    0xc(%ebp),%eax
 251:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 254:	eb 13                	jmp    269 <memmove+0x27>
    *dst++ = *src++;
 256:	8b 45 fc             	mov    -0x4(%ebp),%eax
 259:	0f b6 10             	movzbl (%eax),%edx
 25c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 25f:	88 10                	mov    %dl,(%eax)
 261:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 265:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 269:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 26d:	0f 9f c0             	setg   %al
 270:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 274:	84 c0                	test   %al,%al
 276:	75 de                	jne    256 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 278:	8b 45 08             	mov    0x8(%ebp),%eax
}
 27b:	c9                   	leave  
 27c:	c3                   	ret    
 27d:	90                   	nop
 27e:	90                   	nop
 27f:	90                   	nop

00000280 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 280:	b8 01 00 00 00       	mov    $0x1,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <exit>:
SYSCALL(exit)
 288:	b8 02 00 00 00       	mov    $0x2,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <wait>:
SYSCALL(wait)
 290:	b8 03 00 00 00       	mov    $0x3,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <pipe>:
SYSCALL(pipe)
 298:	b8 04 00 00 00       	mov    $0x4,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <read>:
SYSCALL(read)
 2a0:	b8 05 00 00 00       	mov    $0x5,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <write>:
SYSCALL(write)
 2a8:	b8 10 00 00 00       	mov    $0x10,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <close>:
SYSCALL(close)
 2b0:	b8 15 00 00 00       	mov    $0x15,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <kill>:
SYSCALL(kill)
 2b8:	b8 06 00 00 00       	mov    $0x6,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <exec>:
SYSCALL(exec)
 2c0:	b8 07 00 00 00       	mov    $0x7,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <open>:
SYSCALL(open)
 2c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <mknod>:
SYSCALL(mknod)
 2d0:	b8 11 00 00 00       	mov    $0x11,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <unlink>:
SYSCALL(unlink)
 2d8:	b8 12 00 00 00       	mov    $0x12,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <fstat>:
SYSCALL(fstat)
 2e0:	b8 08 00 00 00       	mov    $0x8,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <link>:
SYSCALL(link)
 2e8:	b8 13 00 00 00       	mov    $0x13,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <mkdir>:
SYSCALL(mkdir)
 2f0:	b8 14 00 00 00       	mov    $0x14,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <chdir>:
SYSCALL(chdir)
 2f8:	b8 09 00 00 00       	mov    $0x9,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <dup>:
SYSCALL(dup)
 300:	b8 0a 00 00 00       	mov    $0xa,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <getpid>:
SYSCALL(getpid)
 308:	b8 0b 00 00 00       	mov    $0xb,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <sbrk>:
SYSCALL(sbrk)
 310:	b8 0c 00 00 00       	mov    $0xc,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <sleep>:
SYSCALL(sleep)
 318:	b8 0d 00 00 00       	mov    $0xd,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <uptime>:
SYSCALL(uptime)
 320:	b8 0e 00 00 00       	mov    $0xe,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <setpriority>:
 328:	b8 16 00 00 00       	mov    $0x16,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	83 ec 28             	sub    $0x28,%esp
 336:	8b 45 0c             	mov    0xc(%ebp),%eax
 339:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 33c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 343:	00 
 344:	8d 45 f4             	lea    -0xc(%ebp),%eax
 347:	89 44 24 04          	mov    %eax,0x4(%esp)
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	89 04 24             	mov    %eax,(%esp)
 351:	e8 52 ff ff ff       	call   2a8 <write>
}
 356:	c9                   	leave  
 357:	c3                   	ret    

00000358 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	53                   	push   %ebx
 35c:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 35f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 366:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 36a:	74 17                	je     383 <printint+0x2b>
 36c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 370:	79 11                	jns    383 <printint+0x2b>
    neg = 1;
 372:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 379:	8b 45 0c             	mov    0xc(%ebp),%eax
 37c:	f7 d8                	neg    %eax
 37e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 381:	eb 06                	jmp    389 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 383:	8b 45 0c             	mov    0xc(%ebp),%eax
 386:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 389:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 390:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 393:	8b 5d 10             	mov    0x10(%ebp),%ebx
 396:	8b 45 f4             	mov    -0xc(%ebp),%eax
 399:	ba 00 00 00 00       	mov    $0x0,%edx
 39e:	f7 f3                	div    %ebx
 3a0:	89 d0                	mov    %edx,%eax
 3a2:	0f b6 80 d8 07 00 00 	movzbl 0x7d8(%eax),%eax
 3a9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 3ad:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 3b1:	8b 45 10             	mov    0x10(%ebp),%eax
 3b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ba:	ba 00 00 00 00       	mov    $0x0,%edx
 3bf:	f7 75 d4             	divl   -0x2c(%ebp)
 3c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3c9:	75 c5                	jne    390 <printint+0x38>
  if(neg)
 3cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3cf:	74 28                	je     3f9 <printint+0xa1>
    buf[i++] = '-';
 3d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 3d9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 3dd:	eb 1a                	jmp    3f9 <printint+0xa1>
    putc(fd, buf[i]);
 3df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e2:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 3e7:	0f be c0             	movsbl %al,%eax
 3ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	89 04 24             	mov    %eax,(%esp)
 3f4:	e8 37 ff ff ff       	call   330 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3f9:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 3fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 401:	79 dc                	jns    3df <printint+0x87>
    putc(fd, buf[i]);
}
 403:	83 c4 44             	add    $0x44,%esp
 406:	5b                   	pop    %ebx
 407:	5d                   	pop    %ebp
 408:	c3                   	ret    

00000409 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp
 40c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 40f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 416:	8d 45 0c             	lea    0xc(%ebp),%eax
 419:	83 c0 04             	add    $0x4,%eax
 41c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 41f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 426:	e9 7e 01 00 00       	jmp    5a9 <printf+0x1a0>
    c = fmt[i] & 0xff;
 42b:	8b 55 0c             	mov    0xc(%ebp),%edx
 42e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 431:	8d 04 02             	lea    (%edx,%eax,1),%eax
 434:	0f b6 00             	movzbl (%eax),%eax
 437:	0f be c0             	movsbl %al,%eax
 43a:	25 ff 00 00 00       	and    $0xff,%eax
 43f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 442:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 446:	75 2c                	jne    474 <printf+0x6b>
      if(c == '%'){
 448:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 44c:	75 0c                	jne    45a <printf+0x51>
        state = '%';
 44e:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 455:	e9 4b 01 00 00       	jmp    5a5 <printf+0x19c>
      } else {
        putc(fd, c);
 45a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 45d:	0f be c0             	movsbl %al,%eax
 460:	89 44 24 04          	mov    %eax,0x4(%esp)
 464:	8b 45 08             	mov    0x8(%ebp),%eax
 467:	89 04 24             	mov    %eax,(%esp)
 46a:	e8 c1 fe ff ff       	call   330 <putc>
 46f:	e9 31 01 00 00       	jmp    5a5 <printf+0x19c>
      }
    } else if(state == '%'){
 474:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 478:	0f 85 27 01 00 00    	jne    5a5 <printf+0x19c>
      if(c == 'd'){
 47e:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 482:	75 2d                	jne    4b1 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 484:	8b 45 f4             	mov    -0xc(%ebp),%eax
 487:	8b 00                	mov    (%eax),%eax
 489:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 490:	00 
 491:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 498:	00 
 499:	89 44 24 04          	mov    %eax,0x4(%esp)
 49d:	8b 45 08             	mov    0x8(%ebp),%eax
 4a0:	89 04 24             	mov    %eax,(%esp)
 4a3:	e8 b0 fe ff ff       	call   358 <printint>
        ap++;
 4a8:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 4ac:	e9 ed 00 00 00       	jmp    59e <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 4b1:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 4b5:	74 06                	je     4bd <printf+0xb4>
 4b7:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 4bb:	75 2d                	jne    4ea <printf+0xe1>
        printint(fd, *ap, 16, 0);
 4bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c0:	8b 00                	mov    (%eax),%eax
 4c2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4c9:	00 
 4ca:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4d1:	00 
 4d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d6:	8b 45 08             	mov    0x8(%ebp),%eax
 4d9:	89 04 24             	mov    %eax,(%esp)
 4dc:	e8 77 fe ff ff       	call   358 <printint>
        ap++;
 4e1:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4e5:	e9 b4 00 00 00       	jmp    59e <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4ea:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 4ee:	75 46                	jne    536 <printf+0x12d>
        s = (char*)*ap;
 4f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f3:	8b 00                	mov    (%eax),%eax
 4f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 4f8:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 4fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 500:	75 27                	jne    529 <printf+0x120>
          s = "(null)";
 502:	c7 45 e4 cf 07 00 00 	movl   $0x7cf,-0x1c(%ebp)
        while(*s != 0){
 509:	eb 1f                	jmp    52a <printf+0x121>
          putc(fd, *s);
 50b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 50e:	0f b6 00             	movzbl (%eax),%eax
 511:	0f be c0             	movsbl %al,%eax
 514:	89 44 24 04          	mov    %eax,0x4(%esp)
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	89 04 24             	mov    %eax,(%esp)
 51e:	e8 0d fe ff ff       	call   330 <putc>
          s++;
 523:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 527:	eb 01                	jmp    52a <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 529:	90                   	nop
 52a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52d:	0f b6 00             	movzbl (%eax),%eax
 530:	84 c0                	test   %al,%al
 532:	75 d7                	jne    50b <printf+0x102>
 534:	eb 68                	jmp    59e <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 536:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 53a:	75 1d                	jne    559 <printf+0x150>
        putc(fd, *ap);
 53c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53f:	8b 00                	mov    (%eax),%eax
 541:	0f be c0             	movsbl %al,%eax
 544:	89 44 24 04          	mov    %eax,0x4(%esp)
 548:	8b 45 08             	mov    0x8(%ebp),%eax
 54b:	89 04 24             	mov    %eax,(%esp)
 54e:	e8 dd fd ff ff       	call   330 <putc>
        ap++;
 553:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 557:	eb 45                	jmp    59e <printf+0x195>
      } else if(c == '%'){
 559:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 55d:	75 17                	jne    576 <printf+0x16d>
        putc(fd, c);
 55f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 562:	0f be c0             	movsbl %al,%eax
 565:	89 44 24 04          	mov    %eax,0x4(%esp)
 569:	8b 45 08             	mov    0x8(%ebp),%eax
 56c:	89 04 24             	mov    %eax,(%esp)
 56f:	e8 bc fd ff ff       	call   330 <putc>
 574:	eb 28                	jmp    59e <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 576:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 57d:	00 
 57e:	8b 45 08             	mov    0x8(%ebp),%eax
 581:	89 04 24             	mov    %eax,(%esp)
 584:	e8 a7 fd ff ff       	call   330 <putc>
        putc(fd, c);
 589:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58c:	0f be c0             	movsbl %al,%eax
 58f:	89 44 24 04          	mov    %eax,0x4(%esp)
 593:	8b 45 08             	mov    0x8(%ebp),%eax
 596:	89 04 24             	mov    %eax,(%esp)
 599:	e8 92 fd ff ff       	call   330 <putc>
      }
      state = 0;
 59e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 5a9:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5af:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5b2:	0f b6 00             	movzbl (%eax),%eax
 5b5:	84 c0                	test   %al,%al
 5b7:	0f 85 6e fe ff ff    	jne    42b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5bd:	c9                   	leave  
 5be:	c3                   	ret    
 5bf:	90                   	nop

000005c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c6:	8b 45 08             	mov    0x8(%ebp),%eax
 5c9:	83 e8 08             	sub    $0x8,%eax
 5cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5cf:	a1 f4 07 00 00       	mov    0x7f4,%eax
 5d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d7:	eb 24                	jmp    5fd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5dc:	8b 00                	mov    (%eax),%eax
 5de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e1:	77 12                	ja     5f5 <free+0x35>
 5e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e9:	77 24                	ja     60f <free+0x4f>
 5eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ee:	8b 00                	mov    (%eax),%eax
 5f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f3:	77 1a                	ja     60f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f8:	8b 00                	mov    (%eax),%eax
 5fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 600:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 603:	76 d4                	jbe    5d9 <free+0x19>
 605:	8b 45 fc             	mov    -0x4(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 60d:	76 ca                	jbe    5d9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 60f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 612:	8b 40 04             	mov    0x4(%eax),%eax
 615:	c1 e0 03             	shl    $0x3,%eax
 618:	89 c2                	mov    %eax,%edx
 61a:	03 55 f8             	add    -0x8(%ebp),%edx
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	39 c2                	cmp    %eax,%edx
 624:	75 24                	jne    64a <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 626:	8b 45 f8             	mov    -0x8(%ebp),%eax
 629:	8b 50 04             	mov    0x4(%eax),%edx
 62c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62f:	8b 00                	mov    (%eax),%eax
 631:	8b 40 04             	mov    0x4(%eax),%eax
 634:	01 c2                	add    %eax,%edx
 636:	8b 45 f8             	mov    -0x8(%ebp),%eax
 639:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 63c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	8b 10                	mov    (%eax),%edx
 643:	8b 45 f8             	mov    -0x8(%ebp),%eax
 646:	89 10                	mov    %edx,(%eax)
 648:	eb 0a                	jmp    654 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	8b 10                	mov    (%eax),%edx
 64f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 652:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 40 04             	mov    0x4(%eax),%eax
 65a:	c1 e0 03             	shl    $0x3,%eax
 65d:	03 45 fc             	add    -0x4(%ebp),%eax
 660:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 663:	75 20                	jne    685 <free+0xc5>
    p->s.size += bp->s.size;
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 50 04             	mov    0x4(%eax),%edx
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	8b 40 04             	mov    0x4(%eax),%eax
 671:	01 c2                	add    %eax,%edx
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
 676:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 679:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67c:	8b 10                	mov    (%eax),%edx
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	89 10                	mov    %edx,(%eax)
 683:	eb 08                	jmp    68d <free+0xcd>
  } else
    p->s.ptr = bp;
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 55 f8             	mov    -0x8(%ebp),%edx
 68b:	89 10                	mov    %edx,(%eax)
  freep = p;
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	a3 f4 07 00 00       	mov    %eax,0x7f4
}
 695:	c9                   	leave  
 696:	c3                   	ret    

00000697 <morecore>:

static Header*
morecore(uint nu)
{
 697:	55                   	push   %ebp
 698:	89 e5                	mov    %esp,%ebp
 69a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 69d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6a4:	77 07                	ja     6ad <morecore+0x16>
    nu = 4096;
 6a6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ad:	8b 45 08             	mov    0x8(%ebp),%eax
 6b0:	c1 e0 03             	shl    $0x3,%eax
 6b3:	89 04 24             	mov    %eax,(%esp)
 6b6:	e8 55 fc ff ff       	call   310 <sbrk>
 6bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 6be:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 6c2:	75 07                	jne    6cb <morecore+0x34>
    return 0;
 6c4:	b8 00 00 00 00       	mov    $0x0,%eax
 6c9:	eb 22                	jmp    6ed <morecore+0x56>
  hp = (Header*)p;
 6cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 6d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d4:	8b 55 08             	mov    0x8(%ebp),%edx
 6d7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6dd:	83 c0 08             	add    $0x8,%eax
 6e0:	89 04 24             	mov    %eax,(%esp)
 6e3:	e8 d8 fe ff ff       	call   5c0 <free>
  return freep;
 6e8:	a1 f4 07 00 00       	mov    0x7f4,%eax
}
 6ed:	c9                   	leave  
 6ee:	c3                   	ret    

000006ef <malloc>:

void*
malloc(uint nbytes)
{
 6ef:	55                   	push   %ebp
 6f0:	89 e5                	mov    %esp,%ebp
 6f2:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f5:	8b 45 08             	mov    0x8(%ebp),%eax
 6f8:	83 c0 07             	add    $0x7,%eax
 6fb:	c1 e8 03             	shr    $0x3,%eax
 6fe:	83 c0 01             	add    $0x1,%eax
 701:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 704:	a1 f4 07 00 00       	mov    0x7f4,%eax
 709:	89 45 f0             	mov    %eax,-0x10(%ebp)
 70c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 710:	75 23                	jne    735 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 712:	c7 45 f0 ec 07 00 00 	movl   $0x7ec,-0x10(%ebp)
 719:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71c:	a3 f4 07 00 00       	mov    %eax,0x7f4
 721:	a1 f4 07 00 00       	mov    0x7f4,%eax
 726:	a3 ec 07 00 00       	mov    %eax,0x7ec
    base.s.size = 0;
 72b:	c7 05 f0 07 00 00 00 	movl   $0x0,0x7f0
 732:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 735:	8b 45 f0             	mov    -0x10(%ebp),%eax
 738:	8b 00                	mov    (%eax),%eax
 73a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 73d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 740:	8b 40 04             	mov    0x4(%eax),%eax
 743:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 746:	72 4d                	jb     795 <malloc+0xa6>
      if(p->s.size == nunits)
 748:	8b 45 ec             	mov    -0x14(%ebp),%eax
 74b:	8b 40 04             	mov    0x4(%eax),%eax
 74e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 751:	75 0c                	jne    75f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 753:	8b 45 ec             	mov    -0x14(%ebp),%eax
 756:	8b 10                	mov    (%eax),%edx
 758:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75b:	89 10                	mov    %edx,(%eax)
 75d:	eb 26                	jmp    785 <malloc+0x96>
      else {
        p->s.size -= nunits;
 75f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 762:	8b 40 04             	mov    0x4(%eax),%eax
 765:	89 c2                	mov    %eax,%edx
 767:	2b 55 f4             	sub    -0xc(%ebp),%edx
 76a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 76d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 770:	8b 45 ec             	mov    -0x14(%ebp),%eax
 773:	8b 40 04             	mov    0x4(%eax),%eax
 776:	c1 e0 03             	shl    $0x3,%eax
 779:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 77c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 77f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 782:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	a3 f4 07 00 00       	mov    %eax,0x7f4
      return (void*)(p + 1);
 78d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 790:	83 c0 08             	add    $0x8,%eax
 793:	eb 38                	jmp    7cd <malloc+0xde>
    }
    if(p == freep)
 795:	a1 f4 07 00 00       	mov    0x7f4,%eax
 79a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 79d:	75 1b                	jne    7ba <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	89 04 24             	mov    %eax,(%esp)
 7a5:	e8 ed fe ff ff       	call   697 <morecore>
 7aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7b1:	75 07                	jne    7ba <malloc+0xcb>
        return 0;
 7b3:	b8 00 00 00 00       	mov    $0x0,%eax
 7b8:	eb 13                	jmp    7cd <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c3:	8b 00                	mov    (%eax),%eax
 7c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7c8:	e9 70 ff ff ff       	jmp    73d <malloc+0x4e>
}
 7cd:	c9                   	leave  
 7ce:	c3                   	ret    
