
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 27 08 00 	movl   $0x827,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 3e 04 00 00       	call   461 <printf>
    exit();
  23:	e8 b8 02 00 00       	call   2e0 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 fc 02 00 00       	call   340 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 3a 08 00 	movl   $0x83a,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 ed 03 00 00       	call   461 <printf>
  exit();
  74:	e8 67 02 00 00       	call   2e0 <exit>
  79:	90                   	nop
  7a:	90                   	nop
  7b:	90                   	nop

0000007c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	57                   	push   %edi
  80:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  84:	8b 55 10             	mov    0x10(%ebp),%edx
  87:	8b 45 0c             	mov    0xc(%ebp),%eax
  8a:	89 cb                	mov    %ecx,%ebx
  8c:	89 df                	mov    %ebx,%edi
  8e:	89 d1                	mov    %edx,%ecx
  90:	fc                   	cld    
  91:	f3 aa                	rep stos %al,%es:(%edi)
  93:	89 ca                	mov    %ecx,%edx
  95:	89 fb                	mov    %edi,%ebx
  97:	89 5d 08             	mov    %ebx,0x8(%ebp)
  9a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9d:	5b                   	pop    %ebx
  9e:	5f                   	pop    %edi
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  b0:	0f b6 10             	movzbl (%eax),%edx
  b3:	8b 45 08             	mov    0x8(%ebp),%eax
  b6:	88 10                	mov    %dl,(%eax)
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	0f b6 00             	movzbl (%eax),%eax
  be:	84 c0                	test   %al,%al
  c0:	0f 95 c0             	setne  %al
  c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  cb:	84 c0                	test   %al,%al
  cd:	75 de                	jne    ad <strcpy+0xc>
    ;
  return os;
  cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d2:	c9                   	leave  
  d3:	c3                   	ret    

000000d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d7:	eb 08                	jmp    e1 <strcmp+0xd>
    p++, q++;
  d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  dd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 00             	movzbl (%eax),%eax
  e7:	84 c0                	test   %al,%al
  e9:	74 10                	je     fb <strcmp+0x27>
  eb:	8b 45 08             	mov    0x8(%ebp),%eax
  ee:	0f b6 10             	movzbl (%eax),%edx
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	38 c2                	cmp    %al,%dl
  f9:	74 de                	je     d9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	0f b6 d0             	movzbl %al,%edx
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	0f b6 00             	movzbl (%eax),%eax
 10a:	0f b6 c0             	movzbl %al,%eax
 10d:	89 d1                	mov    %edx,%ecx
 10f:	29 c1                	sub    %eax,%ecx
 111:	89 c8                	mov    %ecx,%eax
}
 113:	5d                   	pop    %ebp
 114:	c3                   	ret    

00000115 <strlen>:

uint
strlen(char *s)
{
 115:	55                   	push   %ebp
 116:	89 e5                	mov    %esp,%ebp
 118:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 122:	eb 04                	jmp    128 <strlen+0x13>
 124:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 128:	8b 45 fc             	mov    -0x4(%ebp),%eax
 12b:	03 45 08             	add    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	84 c0                	test   %al,%al
 133:	75 ef                	jne    124 <strlen+0xf>
    ;
  return n;
 135:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 138:	c9                   	leave  
 139:	c3                   	ret    

0000013a <memset>:

void*
memset(void *dst, int c, uint n)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 140:	8b 45 10             	mov    0x10(%ebp),%eax
 143:	89 44 24 08          	mov    %eax,0x8(%esp)
 147:	8b 45 0c             	mov    0xc(%ebp),%eax
 14a:	89 44 24 04          	mov    %eax,0x4(%esp)
 14e:	8b 45 08             	mov    0x8(%ebp),%eax
 151:	89 04 24             	mov    %eax,(%esp)
 154:	e8 23 ff ff ff       	call   7c <stosb>
  return dst;
 159:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15c:	c9                   	leave  
 15d:	c3                   	ret    

0000015e <strchr>:

char*
strchr(const char *s, char c)
{
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
 161:	83 ec 04             	sub    $0x4,%esp
 164:	8b 45 0c             	mov    0xc(%ebp),%eax
 167:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16a:	eb 14                	jmp    180 <strchr+0x22>
    if(*s == c)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	3a 45 fc             	cmp    -0x4(%ebp),%al
 175:	75 05                	jne    17c <strchr+0x1e>
      return (char*)s;
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	eb 13                	jmp    18f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 17c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	0f b6 00             	movzbl (%eax),%eax
 186:	84 c0                	test   %al,%al
 188:	75 e2                	jne    16c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 18a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18f:	c9                   	leave  
 190:	c3                   	ret    

00000191 <gets>:

char*
gets(char *buf, int max)
{
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
 194:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 197:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 19e:	eb 44                	jmp    1e4 <gets+0x53>
    cc = read(0, &c, 1);
 1a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1a7:	00 
 1a8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 1af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b6:	e8 3d 01 00 00       	call   2f8 <read>
 1bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 1be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c2:	7e 2d                	jle    1f1 <gets+0x60>
      break;
    buf[i++] = c;
 1c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1c7:	03 45 08             	add    0x8(%ebp),%eax
 1ca:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1ce:	88 10                	mov    %dl,(%eax)
 1d0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 1d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d8:	3c 0a                	cmp    $0xa,%al
 1da:	74 16                	je     1f2 <gets+0x61>
 1dc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e0:	3c 0d                	cmp    $0xd,%al
 1e2:	74 0e                	je     1f2 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1e7:	83 c0 01             	add    $0x1,%eax
 1ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ed:	7c b1                	jl     1a0 <gets+0xf>
 1ef:	eb 01                	jmp    1f2 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f1:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1f5:	03 45 08             	add    0x8(%ebp),%eax
 1f8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fe:	c9                   	leave  
 1ff:	c3                   	ret    

00000200 <stat>:

int
stat(char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 20d:	00 
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	89 04 24             	mov    %eax,(%esp)
 214:	e8 07 01 00 00       	call   320 <open>
 219:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 21c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 220:	79 07                	jns    229 <stat+0x29>
    return -1;
 222:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 227:	eb 23                	jmp    24c <stat+0x4c>
  r = fstat(fd, st);
 229:	8b 45 0c             	mov    0xc(%ebp),%eax
 22c:	89 44 24 04          	mov    %eax,0x4(%esp)
 230:	8b 45 f0             	mov    -0x10(%ebp),%eax
 233:	89 04 24             	mov    %eax,(%esp)
 236:	e8 fd 00 00 00       	call   338 <fstat>
 23b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 23e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 241:	89 04 24             	mov    %eax,(%esp)
 244:	e8 bf 00 00 00       	call   308 <close>
  return r;
 249:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <atoi>:

int
atoi(const char *s)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25b:	eb 24                	jmp    281 <atoi+0x33>
    n = n*10 + *s++ - '0';
 25d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 260:	89 d0                	mov    %edx,%eax
 262:	c1 e0 02             	shl    $0x2,%eax
 265:	01 d0                	add    %edx,%eax
 267:	01 c0                	add    %eax,%eax
 269:	89 c2                	mov    %eax,%edx
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	0f be c0             	movsbl %al,%eax
 274:	8d 04 02             	lea    (%edx,%eax,1),%eax
 277:	83 e8 30             	sub    $0x30,%eax
 27a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 27d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	3c 2f                	cmp    $0x2f,%al
 289:	7e 0a                	jle    295 <atoi+0x47>
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	0f b6 00             	movzbl (%eax),%eax
 291:	3c 39                	cmp    $0x39,%al
 293:	7e c8                	jle    25d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 2a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 2ac:	eb 13                	jmp    2c1 <memmove+0x27>
    *dst++ = *src++;
 2ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b1:	0f b6 10             	movzbl (%eax),%edx
 2b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b7:	88 10                	mov    %dl,(%eax)
 2b9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2c5:	0f 9f c0             	setg   %al
 2c8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2cc:	84 c0                	test   %al,%al
 2ce:	75 de                	jne    2ae <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    
 2d5:	90                   	nop
 2d6:	90                   	nop
 2d7:	90                   	nop

000002d8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d8:	b8 01 00 00 00       	mov    $0x1,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <exit>:
SYSCALL(exit)
 2e0:	b8 02 00 00 00       	mov    $0x2,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <wait>:
SYSCALL(wait)
 2e8:	b8 03 00 00 00       	mov    $0x3,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <pipe>:
SYSCALL(pipe)
 2f0:	b8 04 00 00 00       	mov    $0x4,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <read>:
SYSCALL(read)
 2f8:	b8 05 00 00 00       	mov    $0x5,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <write>:
SYSCALL(write)
 300:	b8 10 00 00 00       	mov    $0x10,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <close>:
SYSCALL(close)
 308:	b8 15 00 00 00       	mov    $0x15,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <kill>:
SYSCALL(kill)
 310:	b8 06 00 00 00       	mov    $0x6,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <exec>:
SYSCALL(exec)
 318:	b8 07 00 00 00       	mov    $0x7,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <open>:
SYSCALL(open)
 320:	b8 0f 00 00 00       	mov    $0xf,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <mknod>:
SYSCALL(mknod)
 328:	b8 11 00 00 00       	mov    $0x11,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <unlink>:
SYSCALL(unlink)
 330:	b8 12 00 00 00       	mov    $0x12,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <fstat>:
SYSCALL(fstat)
 338:	b8 08 00 00 00       	mov    $0x8,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <link>:
SYSCALL(link)
 340:	b8 13 00 00 00       	mov    $0x13,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <mkdir>:
SYSCALL(mkdir)
 348:	b8 14 00 00 00       	mov    $0x14,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <chdir>:
SYSCALL(chdir)
 350:	b8 09 00 00 00       	mov    $0x9,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <dup>:
SYSCALL(dup)
 358:	b8 0a 00 00 00       	mov    $0xa,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <getpid>:
SYSCALL(getpid)
 360:	b8 0b 00 00 00       	mov    $0xb,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <sbrk>:
SYSCALL(sbrk)
 368:	b8 0c 00 00 00       	mov    $0xc,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <sleep>:
SYSCALL(sleep)
 370:	b8 0d 00 00 00       	mov    $0xd,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <uptime>:
SYSCALL(uptime)
 378:	b8 0e 00 00 00       	mov    $0xe,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <setpriority>:
 380:	b8 16 00 00 00       	mov    $0x16,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 388:	55                   	push   %ebp
 389:	89 e5                	mov    %esp,%ebp
 38b:	83 ec 28             	sub    $0x28,%esp
 38e:	8b 45 0c             	mov    0xc(%ebp),%eax
 391:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 394:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 39b:	00 
 39c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39f:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	89 04 24             	mov    %eax,(%esp)
 3a9:	e8 52 ff ff ff       	call   300 <write>
}
 3ae:	c9                   	leave  
 3af:	c3                   	ret    

000003b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	53                   	push   %ebx
 3b4:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3be:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c2:	74 17                	je     3db <printint+0x2b>
 3c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c8:	79 11                	jns    3db <printint+0x2b>
    neg = 1;
 3ca:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	f7 d8                	neg    %eax
 3d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d9:	eb 06                	jmp    3e1 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 3e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 3eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f1:	ba 00 00 00 00       	mov    $0x0,%edx
 3f6:	f7 f3                	div    %ebx
 3f8:	89 d0                	mov    %edx,%eax
 3fa:	0f b6 80 58 08 00 00 	movzbl 0x858(%eax),%eax
 401:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 405:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 409:	8b 45 10             	mov    0x10(%ebp),%eax
 40c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 40f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 412:	ba 00 00 00 00       	mov    $0x0,%edx
 417:	f7 75 d4             	divl   -0x2c(%ebp)
 41a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 41d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 421:	75 c5                	jne    3e8 <printint+0x38>
  if(neg)
 423:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 427:	74 28                	je     451 <printint+0xa1>
    buf[i++] = '-';
 429:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 431:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 435:	eb 1a                	jmp    451 <printint+0xa1>
    putc(fd, buf[i]);
 437:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43a:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 43f:	0f be c0             	movsbl %al,%eax
 442:	89 44 24 04          	mov    %eax,0x4(%esp)
 446:	8b 45 08             	mov    0x8(%ebp),%eax
 449:	89 04 24             	mov    %eax,(%esp)
 44c:	e8 37 ff ff ff       	call   388 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 451:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 455:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 459:	79 dc                	jns    437 <printint+0x87>
    putc(fd, buf[i]);
}
 45b:	83 c4 44             	add    $0x44,%esp
 45e:	5b                   	pop    %ebx
 45f:	5d                   	pop    %ebp
 460:	c3                   	ret    

00000461 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 461:	55                   	push   %ebp
 462:	89 e5                	mov    %esp,%ebp
 464:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 467:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46e:	8d 45 0c             	lea    0xc(%ebp),%eax
 471:	83 c0 04             	add    $0x4,%eax
 474:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 477:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 47e:	e9 7e 01 00 00       	jmp    601 <printf+0x1a0>
    c = fmt[i] & 0xff;
 483:	8b 55 0c             	mov    0xc(%ebp),%edx
 486:	8b 45 ec             	mov    -0x14(%ebp),%eax
 489:	8d 04 02             	lea    (%edx,%eax,1),%eax
 48c:	0f b6 00             	movzbl (%eax),%eax
 48f:	0f be c0             	movsbl %al,%eax
 492:	25 ff 00 00 00       	and    $0xff,%eax
 497:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 49a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 49e:	75 2c                	jne    4cc <printf+0x6b>
      if(c == '%'){
 4a0:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 4a4:	75 0c                	jne    4b2 <printf+0x51>
        state = '%';
 4a6:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 4ad:	e9 4b 01 00 00       	jmp    5fd <printf+0x19c>
      } else {
        putc(fd, c);
 4b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b5:	0f be c0             	movsbl %al,%eax
 4b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
 4bf:	89 04 24             	mov    %eax,(%esp)
 4c2:	e8 c1 fe ff ff       	call   388 <putc>
 4c7:	e9 31 01 00 00       	jmp    5fd <printf+0x19c>
      }
    } else if(state == '%'){
 4cc:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 4d0:	0f 85 27 01 00 00    	jne    5fd <printf+0x19c>
      if(c == 'd'){
 4d6:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 4da:	75 2d                	jne    509 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 4dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4df:	8b 00                	mov    (%eax),%eax
 4e1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4e8:	00 
 4e9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4f0:	00 
 4f1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	89 04 24             	mov    %eax,(%esp)
 4fb:	e8 b0 fe ff ff       	call   3b0 <printint>
        ap++;
 500:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 504:	e9 ed 00 00 00       	jmp    5f6 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 509:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 50d:	74 06                	je     515 <printf+0xb4>
 50f:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 513:	75 2d                	jne    542 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 515:	8b 45 f4             	mov    -0xc(%ebp),%eax
 518:	8b 00                	mov    (%eax),%eax
 51a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 521:	00 
 522:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 529:	00 
 52a:	89 44 24 04          	mov    %eax,0x4(%esp)
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	89 04 24             	mov    %eax,(%esp)
 534:	e8 77 fe ff ff       	call   3b0 <printint>
        ap++;
 539:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 53d:	e9 b4 00 00 00       	jmp    5f6 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 542:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 546:	75 46                	jne    58e <printf+0x12d>
        s = (char*)*ap;
 548:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54b:	8b 00                	mov    (%eax),%eax
 54d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 550:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 554:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 558:	75 27                	jne    581 <printf+0x120>
          s = "(null)";
 55a:	c7 45 e4 4e 08 00 00 	movl   $0x84e,-0x1c(%ebp)
        while(*s != 0){
 561:	eb 1f                	jmp    582 <printf+0x121>
          putc(fd, *s);
 563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 566:	0f b6 00             	movzbl (%eax),%eax
 569:	0f be c0             	movsbl %al,%eax
 56c:	89 44 24 04          	mov    %eax,0x4(%esp)
 570:	8b 45 08             	mov    0x8(%ebp),%eax
 573:	89 04 24             	mov    %eax,(%esp)
 576:	e8 0d fe ff ff       	call   388 <putc>
          s++;
 57b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 57f:	eb 01                	jmp    582 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 581:	90                   	nop
 582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 585:	0f b6 00             	movzbl (%eax),%eax
 588:	84 c0                	test   %al,%al
 58a:	75 d7                	jne    563 <printf+0x102>
 58c:	eb 68                	jmp    5f6 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58e:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 592:	75 1d                	jne    5b1 <printf+0x150>
        putc(fd, *ap);
 594:	8b 45 f4             	mov    -0xc(%ebp),%eax
 597:	8b 00                	mov    (%eax),%eax
 599:	0f be c0             	movsbl %al,%eax
 59c:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a0:	8b 45 08             	mov    0x8(%ebp),%eax
 5a3:	89 04 24             	mov    %eax,(%esp)
 5a6:	e8 dd fd ff ff       	call   388 <putc>
        ap++;
 5ab:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5af:	eb 45                	jmp    5f6 <printf+0x195>
      } else if(c == '%'){
 5b1:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5b5:	75 17                	jne    5ce <printf+0x16d>
        putc(fd, c);
 5b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c1:	8b 45 08             	mov    0x8(%ebp),%eax
 5c4:	89 04 24             	mov    %eax,(%esp)
 5c7:	e8 bc fd ff ff       	call   388 <putc>
 5cc:	eb 28                	jmp    5f6 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ce:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5d5:	00 
 5d6:	8b 45 08             	mov    0x8(%ebp),%eax
 5d9:	89 04 24             	mov    %eax,(%esp)
 5dc:	e8 a7 fd ff ff       	call   388 <putc>
        putc(fd, c);
 5e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e4:	0f be c0             	movsbl %al,%eax
 5e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5eb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ee:	89 04 24             	mov    %eax,(%esp)
 5f1:	e8 92 fd ff ff       	call   388 <putc>
      }
      state = 0;
 5f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5fd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 601:	8b 55 0c             	mov    0xc(%ebp),%edx
 604:	8b 45 ec             	mov    -0x14(%ebp),%eax
 607:	8d 04 02             	lea    (%edx,%eax,1),%eax
 60a:	0f b6 00             	movzbl (%eax),%eax
 60d:	84 c0                	test   %al,%al
 60f:	0f 85 6e fe ff ff    	jne    483 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 615:	c9                   	leave  
 616:	c3                   	ret    
 617:	90                   	nop

00000618 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 618:	55                   	push   %ebp
 619:	89 e5                	mov    %esp,%ebp
 61b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61e:	8b 45 08             	mov    0x8(%ebp),%eax
 621:	83 e8 08             	sub    $0x8,%eax
 624:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 627:	a1 74 08 00 00       	mov    0x874,%eax
 62c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62f:	eb 24                	jmp    655 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 639:	77 12                	ja     64d <free+0x35>
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 641:	77 24                	ja     667 <free+0x4f>
 643:	8b 45 fc             	mov    -0x4(%ebp),%eax
 646:	8b 00                	mov    (%eax),%eax
 648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64b:	77 1a                	ja     667 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	89 45 fc             	mov    %eax,-0x4(%ebp)
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65b:	76 d4                	jbe    631 <free+0x19>
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 665:	76 ca                	jbe    631 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	8b 40 04             	mov    0x4(%eax),%eax
 66d:	c1 e0 03             	shl    $0x3,%eax
 670:	89 c2                	mov    %eax,%edx
 672:	03 55 f8             	add    -0x8(%ebp),%edx
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	39 c2                	cmp    %eax,%edx
 67c:	75 24                	jne    6a2 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	8b 50 04             	mov    0x4(%eax),%edx
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	8b 40 04             	mov    0x4(%eax),%eax
 68c:	01 c2                	add    %eax,%edx
 68e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 691:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	8b 00                	mov    (%eax),%eax
 699:	8b 10                	mov    (%eax),%edx
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	89 10                	mov    %edx,(%eax)
 6a0:	eb 0a                	jmp    6ac <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 10                	mov    (%eax),%edx
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 40 04             	mov    0x4(%eax),%eax
 6b2:	c1 e0 03             	shl    $0x3,%eax
 6b5:	03 45 fc             	add    -0x4(%ebp),%eax
 6b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bb:	75 20                	jne    6dd <free+0xc5>
    p->s.size += bp->s.size;
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 50 04             	mov    0x4(%eax),%edx
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	8b 40 04             	mov    0x4(%eax),%eax
 6c9:	01 c2                	add    %eax,%edx
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d4:	8b 10                	mov    (%eax),%edx
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	89 10                	mov    %edx,(%eax)
 6db:	eb 08                	jmp    6e5 <free+0xcd>
  } else
    p->s.ptr = bp;
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e3:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	a3 74 08 00 00       	mov    %eax,0x874
}
 6ed:	c9                   	leave  
 6ee:	c3                   	ret    

000006ef <morecore>:

static Header*
morecore(uint nu)
{
 6ef:	55                   	push   %ebp
 6f0:	89 e5                	mov    %esp,%ebp
 6f2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6fc:	77 07                	ja     705 <morecore+0x16>
    nu = 4096;
 6fe:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 705:	8b 45 08             	mov    0x8(%ebp),%eax
 708:	c1 e0 03             	shl    $0x3,%eax
 70b:	89 04 24             	mov    %eax,(%esp)
 70e:	e8 55 fc ff ff       	call   368 <sbrk>
 713:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 716:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 71a:	75 07                	jne    723 <morecore+0x34>
    return 0;
 71c:	b8 00 00 00 00       	mov    $0x0,%eax
 721:	eb 22                	jmp    745 <morecore+0x56>
  hp = (Header*)p;
 723:	8b 45 f0             	mov    -0x10(%ebp),%eax
 726:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 729:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72c:	8b 55 08             	mov    0x8(%ebp),%edx
 72f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 732:	8b 45 f4             	mov    -0xc(%ebp),%eax
 735:	83 c0 08             	add    $0x8,%eax
 738:	89 04 24             	mov    %eax,(%esp)
 73b:	e8 d8 fe ff ff       	call   618 <free>
  return freep;
 740:	a1 74 08 00 00       	mov    0x874,%eax
}
 745:	c9                   	leave  
 746:	c3                   	ret    

00000747 <malloc>:

void*
malloc(uint nbytes)
{
 747:	55                   	push   %ebp
 748:	89 e5                	mov    %esp,%ebp
 74a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74d:	8b 45 08             	mov    0x8(%ebp),%eax
 750:	83 c0 07             	add    $0x7,%eax
 753:	c1 e8 03             	shr    $0x3,%eax
 756:	83 c0 01             	add    $0x1,%eax
 759:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 75c:	a1 74 08 00 00       	mov    0x874,%eax
 761:	89 45 f0             	mov    %eax,-0x10(%ebp)
 764:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 768:	75 23                	jne    78d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 76a:	c7 45 f0 6c 08 00 00 	movl   $0x86c,-0x10(%ebp)
 771:	8b 45 f0             	mov    -0x10(%ebp),%eax
 774:	a3 74 08 00 00       	mov    %eax,0x874
 779:	a1 74 08 00 00       	mov    0x874,%eax
 77e:	a3 6c 08 00 00       	mov    %eax,0x86c
    base.s.size = 0;
 783:	c7 05 70 08 00 00 00 	movl   $0x0,0x870
 78a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 790:	8b 00                	mov    (%eax),%eax
 792:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 795:	8b 45 ec             	mov    -0x14(%ebp),%eax
 798:	8b 40 04             	mov    0x4(%eax),%eax
 79b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 79e:	72 4d                	jb     7ed <malloc+0xa6>
      if(p->s.size == nunits)
 7a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a3:	8b 40 04             	mov    0x4(%eax),%eax
 7a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7a9:	75 0c                	jne    7b7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ae:	8b 10                	mov    (%eax),%edx
 7b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b3:	89 10                	mov    %edx,(%eax)
 7b5:	eb 26                	jmp    7dd <malloc+0x96>
      else {
        p->s.size -= nunits;
 7b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ba:	8b 40 04             	mov    0x4(%eax),%eax
 7bd:	89 c2                	mov    %eax,%edx
 7bf:	2b 55 f4             	sub    -0xc(%ebp),%edx
 7c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7cb:	8b 40 04             	mov    0x4(%eax),%eax
 7ce:	c1 e0 03             	shl    $0x3,%eax
 7d1:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 7d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7da:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e0:	a3 74 08 00 00       	mov    %eax,0x874
      return (void*)(p + 1);
 7e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e8:	83 c0 08             	add    $0x8,%eax
 7eb:	eb 38                	jmp    825 <malloc+0xde>
    }
    if(p == freep)
 7ed:	a1 74 08 00 00       	mov    0x874,%eax
 7f2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7f5:	75 1b                	jne    812 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	89 04 24             	mov    %eax,(%esp)
 7fd:	e8 ed fe ff ff       	call   6ef <morecore>
 802:	89 45 ec             	mov    %eax,-0x14(%ebp)
 805:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 809:	75 07                	jne    812 <malloc+0xcb>
        return 0;
 80b:	b8 00 00 00 00       	mov    $0x0,%eax
 810:	eb 13                	jmp    825 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 812:	8b 45 ec             	mov    -0x14(%ebp),%eax
 815:	89 45 f0             	mov    %eax,-0x10(%ebp)
 818:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81b:	8b 00                	mov    (%eax),%eax
 81d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 820:	e9 70 ff ff ff       	jmp    795 <malloc+0x4e>
}
 825:	c9                   	leave  
 826:	c3                   	ret    
