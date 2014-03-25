
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 20 09 00 	movl   $0x920,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 71 03 00 00       	call   394 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 20 09 00 	movl   $0x920,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 4e 03 00 00       	call   38c <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 b3 08 00 	movl   $0x8b3,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 8c 04 00 00       	call   4ed <printf>
    exit();
  61:	e8 0e 03 00 00       	call   374 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(int argc, char *argv[])
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  71:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  75:	7f 11                	jg     88 <main+0x20>
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 7d ff ff ff       	call   0 <cat>
    exit();
  83:	e8 ec 02 00 00       	call   374 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 6d                	jmp    ff <main+0x97>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	c1 e0 02             	shl    $0x2,%eax
  99:	03 45 0c             	add    0xc(%ebp),%eax
  9c:	8b 00                	mov    (%eax),%eax
  9e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  a5:	00 
  a6:	89 04 24             	mov    %eax,(%esp)
  a9:	e8 06 03 00 00       	call   3b4 <open>
  ae:	89 44 24 18          	mov    %eax,0x18(%esp)
  b2:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  b7:	79 29                	jns    e2 <main+0x7a>
      printf(1, "cat: cannot open %s\n", argv[i]);
  b9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  bd:	c1 e0 02             	shl    $0x2,%eax
  c0:	03 45 0c             	add    0xc(%ebp),%eax
  c3:	8b 00                	mov    (%eax),%eax
  c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  c9:	c7 44 24 04 c4 08 00 	movl   $0x8c4,0x4(%esp)
  d0:	00 
  d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d8:	e8 10 04 00 00       	call   4ed <printf>
      exit();
  dd:	e8 92 02 00 00       	call   374 <exit>
    }
    cat(fd);
  e2:	8b 44 24 18          	mov    0x18(%esp),%eax
  e6:	89 04 24             	mov    %eax,(%esp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
    close(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 a2 02 00 00       	call   39c <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  fa:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  ff:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 103:	3b 45 08             	cmp    0x8(%ebp),%eax
 106:	7c 8a                	jl     92 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 108:	e8 67 02 00 00       	call   374 <exit>
 10d:	90                   	nop
 10e:	90                   	nop
 10f:	90                   	nop

00000110 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 115:	8b 4d 08             	mov    0x8(%ebp),%ecx
 118:	8b 55 10             	mov    0x10(%ebp),%edx
 11b:	8b 45 0c             	mov    0xc(%ebp),%eax
 11e:	89 cb                	mov    %ecx,%ebx
 120:	89 df                	mov    %ebx,%edi
 122:	89 d1                	mov    %edx,%ecx
 124:	fc                   	cld    
 125:	f3 aa                	rep stos %al,%es:(%edi)
 127:	89 ca                	mov    %ecx,%edx
 129:	89 fb                	mov    %edi,%ebx
 12b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	0f b6 10             	movzbl (%eax),%edx
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	88 10                	mov    %dl,(%eax)
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	0f b6 00             	movzbl (%eax),%eax
 152:	84 c0                	test   %al,%al
 154:	0f 95 c0             	setne  %al
 157:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 15f:	84 c0                	test   %al,%al
 161:	75 de                	jne    141 <strcpy+0xc>
    ;
  return os;
 163:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 166:	c9                   	leave  
 167:	c3                   	ret    

00000168 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16b:	eb 08                	jmp    175 <strcmp+0xd>
    p++, q++;
 16d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 171:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	0f b6 00             	movzbl (%eax),%eax
 17b:	84 c0                	test   %al,%al
 17d:	74 10                	je     18f <strcmp+0x27>
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 10             	movzbl (%eax),%edx
 185:	8b 45 0c             	mov    0xc(%ebp),%eax
 188:	0f b6 00             	movzbl (%eax),%eax
 18b:	38 c2                	cmp    %al,%dl
 18d:	74 de                	je     16d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	0f b6 d0             	movzbl %al,%edx
 198:	8b 45 0c             	mov    0xc(%ebp),%eax
 19b:	0f b6 00             	movzbl (%eax),%eax
 19e:	0f b6 c0             	movzbl %al,%eax
 1a1:	89 d1                	mov    %edx,%ecx
 1a3:	29 c1                	sub    %eax,%ecx
 1a5:	89 c8                	mov    %ecx,%eax
}
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    

000001a9 <strlen>:

uint
strlen(char *s)
{
 1a9:	55                   	push   %ebp
 1aa:	89 e5                	mov    %esp,%ebp
 1ac:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b6:	eb 04                	jmp    1bc <strlen+0x13>
 1b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1bf:	03 45 08             	add    0x8(%ebp),%eax
 1c2:	0f b6 00             	movzbl (%eax),%eax
 1c5:	84 c0                	test   %al,%al
 1c7:	75 ef                	jne    1b8 <strlen+0xf>
    ;
  return n;
 1c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1cc:	c9                   	leave  
 1cd:	c3                   	ret    

000001ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ce:	55                   	push   %ebp
 1cf:	89 e5                	mov    %esp,%ebp
 1d1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d4:	8b 45 10             	mov    0x10(%ebp),%eax
 1d7:	89 44 24 08          	mov    %eax,0x8(%esp)
 1db:	8b 45 0c             	mov    0xc(%ebp),%eax
 1de:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	89 04 24             	mov    %eax,(%esp)
 1e8:	e8 23 ff ff ff       	call   110 <stosb>
  return dst;
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f0:	c9                   	leave  
 1f1:	c3                   	ret    

000001f2 <strchr>:

char*
strchr(const char *s, char c)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	83 ec 04             	sub    $0x4,%esp
 1f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fe:	eb 14                	jmp    214 <strchr+0x22>
    if(*s == c)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	3a 45 fc             	cmp    -0x4(%ebp),%al
 209:	75 05                	jne    210 <strchr+0x1e>
      return (char*)s;
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	eb 13                	jmp    223 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 210:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	84 c0                	test   %al,%al
 21c:	75 e2                	jne    200 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 223:	c9                   	leave  
 224:	c3                   	ret    

00000225 <gets>:

char*
gets(char *buf, int max)
{
 225:	55                   	push   %ebp
 226:	89 e5                	mov    %esp,%ebp
 228:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 232:	eb 44                	jmp    278 <gets+0x53>
    cc = read(0, &c, 1);
 234:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 23b:	00 
 23c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23f:	89 44 24 04          	mov    %eax,0x4(%esp)
 243:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 24a:	e8 3d 01 00 00       	call   38c <read>
 24f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 252:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 256:	7e 2d                	jle    285 <gets+0x60>
      break;
    buf[i++] = c;
 258:	8b 45 f0             	mov    -0x10(%ebp),%eax
 25b:	03 45 08             	add    0x8(%ebp),%eax
 25e:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 262:	88 10                	mov    %dl,(%eax)
 264:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 268:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26c:	3c 0a                	cmp    $0xa,%al
 26e:	74 16                	je     286 <gets+0x61>
 270:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 274:	3c 0d                	cmp    $0xd,%al
 276:	74 0e                	je     286 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 278:	8b 45 f0             	mov    -0x10(%ebp),%eax
 27b:	83 c0 01             	add    $0x1,%eax
 27e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 281:	7c b1                	jl     234 <gets+0xf>
 283:	eb 01                	jmp    286 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 285:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 286:	8b 45 f0             	mov    -0x10(%ebp),%eax
 289:	03 45 08             	add    0x8(%ebp),%eax
 28c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 292:	c9                   	leave  
 293:	c3                   	ret    

00000294 <stat>:

int
stat(char *n, struct stat *st)
{
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a1:	00 
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	89 04 24             	mov    %eax,(%esp)
 2a8:	e8 07 01 00 00       	call   3b4 <open>
 2ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 2b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2b4:	79 07                	jns    2bd <stat+0x29>
    return -1;
 2b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2bb:	eb 23                	jmp    2e0 <stat+0x4c>
  r = fstat(fd, st);
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2c7:	89 04 24             	mov    %eax,(%esp)
 2ca:	e8 fd 00 00 00       	call   3cc <fstat>
 2cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 2d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2d5:	89 04 24             	mov    %eax,(%esp)
 2d8:	e8 bf 00 00 00       	call   39c <close>
  return r;
 2dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <atoi>:

int
atoi(const char *s)
{
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ef:	eb 24                	jmp    315 <atoi+0x33>
    n = n*10 + *s++ - '0';
 2f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f4:	89 d0                	mov    %edx,%eax
 2f6:	c1 e0 02             	shl    $0x2,%eax
 2f9:	01 d0                	add    %edx,%eax
 2fb:	01 c0                	add    %eax,%eax
 2fd:	89 c2                	mov    %eax,%edx
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	0f b6 00             	movzbl (%eax),%eax
 305:	0f be c0             	movsbl %al,%eax
 308:	8d 04 02             	lea    (%edx,%eax,1),%eax
 30b:	83 e8 30             	sub    $0x30,%eax
 30e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 311:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	0f b6 00             	movzbl (%eax),%eax
 31b:	3c 2f                	cmp    $0x2f,%al
 31d:	7e 0a                	jle    329 <atoi+0x47>
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	0f b6 00             	movzbl (%eax),%eax
 325:	3c 39                	cmp    $0x39,%al
 327:	7e c8                	jle    2f1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 329:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 32c:	c9                   	leave  
 32d:	c3                   	ret    

0000032e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 32e:	55                   	push   %ebp
 32f:	89 e5                	mov    %esp,%ebp
 331:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 33a:	8b 45 0c             	mov    0xc(%ebp),%eax
 33d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 340:	eb 13                	jmp    355 <memmove+0x27>
    *dst++ = *src++;
 342:	8b 45 fc             	mov    -0x4(%ebp),%eax
 345:	0f b6 10             	movzbl (%eax),%edx
 348:	8b 45 f8             	mov    -0x8(%ebp),%eax
 34b:	88 10                	mov    %dl,(%eax)
 34d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 351:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 355:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 359:	0f 9f c0             	setg   %al
 35c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 360:	84 c0                	test   %al,%al
 362:	75 de                	jne    342 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
}
 367:	c9                   	leave  
 368:	c3                   	ret    
 369:	90                   	nop
 36a:	90                   	nop
 36b:	90                   	nop

0000036c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 36c:	b8 01 00 00 00       	mov    $0x1,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <exit>:
SYSCALL(exit)
 374:	b8 02 00 00 00       	mov    $0x2,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <wait>:
SYSCALL(wait)
 37c:	b8 03 00 00 00       	mov    $0x3,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <pipe>:
SYSCALL(pipe)
 384:	b8 04 00 00 00       	mov    $0x4,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <read>:
SYSCALL(read)
 38c:	b8 05 00 00 00       	mov    $0x5,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <write>:
SYSCALL(write)
 394:	b8 10 00 00 00       	mov    $0x10,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <close>:
SYSCALL(close)
 39c:	b8 15 00 00 00       	mov    $0x15,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <kill>:
SYSCALL(kill)
 3a4:	b8 06 00 00 00       	mov    $0x6,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <exec>:
SYSCALL(exec)
 3ac:	b8 07 00 00 00       	mov    $0x7,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <open>:
SYSCALL(open)
 3b4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <mknod>:
SYSCALL(mknod)
 3bc:	b8 11 00 00 00       	mov    $0x11,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <unlink>:
SYSCALL(unlink)
 3c4:	b8 12 00 00 00       	mov    $0x12,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <fstat>:
SYSCALL(fstat)
 3cc:	b8 08 00 00 00       	mov    $0x8,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <link>:
SYSCALL(link)
 3d4:	b8 13 00 00 00       	mov    $0x13,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <mkdir>:
SYSCALL(mkdir)
 3dc:	b8 14 00 00 00       	mov    $0x14,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <chdir>:
SYSCALL(chdir)
 3e4:	b8 09 00 00 00       	mov    $0x9,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <dup>:
SYSCALL(dup)
 3ec:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <getpid>:
SYSCALL(getpid)
 3f4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <sbrk>:
SYSCALL(sbrk)
 3fc:	b8 0c 00 00 00       	mov    $0xc,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <sleep>:
SYSCALL(sleep)
 404:	b8 0d 00 00 00       	mov    $0xd,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <uptime>:
SYSCALL(uptime)
 40c:	b8 0e 00 00 00       	mov    $0xe,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	83 ec 28             	sub    $0x28,%esp
 41a:	8b 45 0c             	mov    0xc(%ebp),%eax
 41d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 420:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 427:	00 
 428:	8d 45 f4             	lea    -0xc(%ebp),%eax
 42b:	89 44 24 04          	mov    %eax,0x4(%esp)
 42f:	8b 45 08             	mov    0x8(%ebp),%eax
 432:	89 04 24             	mov    %eax,(%esp)
 435:	e8 5a ff ff ff       	call   394 <write>
}
 43a:	c9                   	leave  
 43b:	c3                   	ret    

0000043c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43c:	55                   	push   %ebp
 43d:	89 e5                	mov    %esp,%ebp
 43f:	53                   	push   %ebx
 440:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 443:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 44a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 44e:	74 17                	je     467 <printint+0x2b>
 450:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 454:	79 11                	jns    467 <printint+0x2b>
    neg = 1;
 456:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 45d:	8b 45 0c             	mov    0xc(%ebp),%eax
 460:	f7 d8                	neg    %eax
 462:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 465:	eb 06                	jmp    46d <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 467:	8b 45 0c             	mov    0xc(%ebp),%eax
 46a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 46d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 474:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 477:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47d:	ba 00 00 00 00       	mov    $0x0,%edx
 482:	f7 f3                	div    %ebx
 484:	89 d0                	mov    %edx,%eax
 486:	0f b6 80 e0 08 00 00 	movzbl 0x8e0(%eax),%eax
 48d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 491:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 495:	8b 45 10             	mov    0x10(%ebp),%eax
 498:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 49b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49e:	ba 00 00 00 00       	mov    $0x0,%edx
 4a3:	f7 75 d4             	divl   -0x2c(%ebp)
 4a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ad:	75 c5                	jne    474 <printint+0x38>
  if(neg)
 4af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b3:	74 28                	je     4dd <printint+0xa1>
    buf[i++] = '-';
 4b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 4bd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 4c1:	eb 1a                	jmp    4dd <printint+0xa1>
    putc(fd, buf[i]);
 4c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c6:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 4cb:	0f be c0             	movsbl %al,%eax
 4ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d2:	8b 45 08             	mov    0x8(%ebp),%eax
 4d5:	89 04 24             	mov    %eax,(%esp)
 4d8:	e8 37 ff ff ff       	call   414 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4dd:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 4e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e5:	79 dc                	jns    4c3 <printint+0x87>
    putc(fd, buf[i]);
}
 4e7:	83 c4 44             	add    $0x44,%esp
 4ea:	5b                   	pop    %ebx
 4eb:	5d                   	pop    %ebp
 4ec:	c3                   	ret    

000004ed <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4ed:	55                   	push   %ebp
 4ee:	89 e5                	mov    %esp,%ebp
 4f0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4fa:	8d 45 0c             	lea    0xc(%ebp),%eax
 4fd:	83 c0 04             	add    $0x4,%eax
 500:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 503:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 50a:	e9 7e 01 00 00       	jmp    68d <printf+0x1a0>
    c = fmt[i] & 0xff;
 50f:	8b 55 0c             	mov    0xc(%ebp),%edx
 512:	8b 45 ec             	mov    -0x14(%ebp),%eax
 515:	8d 04 02             	lea    (%edx,%eax,1),%eax
 518:	0f b6 00             	movzbl (%eax),%eax
 51b:	0f be c0             	movsbl %al,%eax
 51e:	25 ff 00 00 00       	and    $0xff,%eax
 523:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 526:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 52a:	75 2c                	jne    558 <printf+0x6b>
      if(c == '%'){
 52c:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 530:	75 0c                	jne    53e <printf+0x51>
        state = '%';
 532:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 539:	e9 4b 01 00 00       	jmp    689 <printf+0x19c>
      } else {
        putc(fd, c);
 53e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 541:	0f be c0             	movsbl %al,%eax
 544:	89 44 24 04          	mov    %eax,0x4(%esp)
 548:	8b 45 08             	mov    0x8(%ebp),%eax
 54b:	89 04 24             	mov    %eax,(%esp)
 54e:	e8 c1 fe ff ff       	call   414 <putc>
 553:	e9 31 01 00 00       	jmp    689 <printf+0x19c>
      }
    } else if(state == '%'){
 558:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 55c:	0f 85 27 01 00 00    	jne    689 <printf+0x19c>
      if(c == 'd'){
 562:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 566:	75 2d                	jne    595 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 568:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56b:	8b 00                	mov    (%eax),%eax
 56d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 574:	00 
 575:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 57c:	00 
 57d:	89 44 24 04          	mov    %eax,0x4(%esp)
 581:	8b 45 08             	mov    0x8(%ebp),%eax
 584:	89 04 24             	mov    %eax,(%esp)
 587:	e8 b0 fe ff ff       	call   43c <printint>
        ap++;
 58c:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 590:	e9 ed 00 00 00       	jmp    682 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 595:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 599:	74 06                	je     5a1 <printf+0xb4>
 59b:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 59f:	75 2d                	jne    5ce <printf+0xe1>
        printint(fd, *ap, 16, 0);
 5a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a4:	8b 00                	mov    (%eax),%eax
 5a6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5ad:	00 
 5ae:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5b5:	00 
 5b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ba:	8b 45 08             	mov    0x8(%ebp),%eax
 5bd:	89 04 24             	mov    %eax,(%esp)
 5c0:	e8 77 fe ff ff       	call   43c <printint>
        ap++;
 5c5:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5c9:	e9 b4 00 00 00       	jmp    682 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5ce:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 5d2:	75 46                	jne    61a <printf+0x12d>
        s = (char*)*ap;
 5d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d7:	8b 00                	mov    (%eax),%eax
 5d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 5dc:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 5e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 5e4:	75 27                	jne    60d <printf+0x120>
          s = "(null)";
 5e6:	c7 45 e4 d9 08 00 00 	movl   $0x8d9,-0x1c(%ebp)
        while(*s != 0){
 5ed:	eb 1f                	jmp    60e <printf+0x121>
          putc(fd, *s);
 5ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f2:	0f b6 00             	movzbl (%eax),%eax
 5f5:	0f be c0             	movsbl %al,%eax
 5f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fc:	8b 45 08             	mov    0x8(%ebp),%eax
 5ff:	89 04 24             	mov    %eax,(%esp)
 602:	e8 0d fe ff ff       	call   414 <putc>
          s++;
 607:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 60b:	eb 01                	jmp    60e <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 60d:	90                   	nop
 60e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 611:	0f b6 00             	movzbl (%eax),%eax
 614:	84 c0                	test   %al,%al
 616:	75 d7                	jne    5ef <printf+0x102>
 618:	eb 68                	jmp    682 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 61a:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 61e:	75 1d                	jne    63d <printf+0x150>
        putc(fd, *ap);
 620:	8b 45 f4             	mov    -0xc(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	0f be c0             	movsbl %al,%eax
 628:	89 44 24 04          	mov    %eax,0x4(%esp)
 62c:	8b 45 08             	mov    0x8(%ebp),%eax
 62f:	89 04 24             	mov    %eax,(%esp)
 632:	e8 dd fd ff ff       	call   414 <putc>
        ap++;
 637:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 63b:	eb 45                	jmp    682 <printf+0x195>
      } else if(c == '%'){
 63d:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 641:	75 17                	jne    65a <printf+0x16d>
        putc(fd, c);
 643:	8b 45 e8             	mov    -0x18(%ebp),%eax
 646:	0f be c0             	movsbl %al,%eax
 649:	89 44 24 04          	mov    %eax,0x4(%esp)
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
 650:	89 04 24             	mov    %eax,(%esp)
 653:	e8 bc fd ff ff       	call   414 <putc>
 658:	eb 28                	jmp    682 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 65a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 661:	00 
 662:	8b 45 08             	mov    0x8(%ebp),%eax
 665:	89 04 24             	mov    %eax,(%esp)
 668:	e8 a7 fd ff ff       	call   414 <putc>
        putc(fd, c);
 66d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 670:	0f be c0             	movsbl %al,%eax
 673:	89 44 24 04          	mov    %eax,0x4(%esp)
 677:	8b 45 08             	mov    0x8(%ebp),%eax
 67a:	89 04 24             	mov    %eax,(%esp)
 67d:	e8 92 fd ff ff       	call   414 <putc>
      }
      state = 0;
 682:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 689:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 68d:	8b 55 0c             	mov    0xc(%ebp),%edx
 690:	8b 45 ec             	mov    -0x14(%ebp),%eax
 693:	8d 04 02             	lea    (%edx,%eax,1),%eax
 696:	0f b6 00             	movzbl (%eax),%eax
 699:	84 c0                	test   %al,%al
 69b:	0f 85 6e fe ff ff    	jne    50f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6a1:	c9                   	leave  
 6a2:	c3                   	ret    
 6a3:	90                   	nop

000006a4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a4:	55                   	push   %ebp
 6a5:	89 e5                	mov    %esp,%ebp
 6a7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6aa:	8b 45 08             	mov    0x8(%ebp),%eax
 6ad:	83 e8 08             	sub    $0x8,%eax
 6b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b3:	a1 08 09 00 00       	mov    0x908,%eax
 6b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6bb:	eb 24                	jmp    6e1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c5:	77 12                	ja     6d9 <free+0x35>
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cd:	77 24                	ja     6f3 <free+0x4f>
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	8b 00                	mov    (%eax),%eax
 6d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d7:	77 1a                	ja     6f3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	8b 00                	mov    (%eax),%eax
 6de:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e7:	76 d4                	jbe    6bd <free+0x19>
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f1:	76 ca                	jbe    6bd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f6:	8b 40 04             	mov    0x4(%eax),%eax
 6f9:	c1 e0 03             	shl    $0x3,%eax
 6fc:	89 c2                	mov    %eax,%edx
 6fe:	03 55 f8             	add    -0x8(%ebp),%edx
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	39 c2                	cmp    %eax,%edx
 708:	75 24                	jne    72e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 70a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70d:	8b 50 04             	mov    0x4(%eax),%edx
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 00                	mov    (%eax),%eax
 715:	8b 40 04             	mov    0x4(%eax),%eax
 718:	01 c2                	add    %eax,%edx
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	8b 10                	mov    (%eax),%edx
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	89 10                	mov    %edx,(%eax)
 72c:	eb 0a                	jmp    738 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	8b 10                	mov    (%eax),%edx
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	8b 40 04             	mov    0x4(%eax),%eax
 73e:	c1 e0 03             	shl    $0x3,%eax
 741:	03 45 fc             	add    -0x4(%ebp),%eax
 744:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 747:	75 20                	jne    769 <free+0xc5>
    p->s.size += bp->s.size;
 749:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74c:	8b 50 04             	mov    0x4(%eax),%edx
 74f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 752:	8b 40 04             	mov    0x4(%eax),%eax
 755:	01 c2                	add    %eax,%edx
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 75d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 760:	8b 10                	mov    (%eax),%edx
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	89 10                	mov    %edx,(%eax)
 767:	eb 08                	jmp    771 <free+0xcd>
  } else
    p->s.ptr = bp;
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 76f:	89 10                	mov    %edx,(%eax)
  freep = p;
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	a3 08 09 00 00       	mov    %eax,0x908
}
 779:	c9                   	leave  
 77a:	c3                   	ret    

0000077b <morecore>:

static Header*
morecore(uint nu)
{
 77b:	55                   	push   %ebp
 77c:	89 e5                	mov    %esp,%ebp
 77e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 781:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 788:	77 07                	ja     791 <morecore+0x16>
    nu = 4096;
 78a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 791:	8b 45 08             	mov    0x8(%ebp),%eax
 794:	c1 e0 03             	shl    $0x3,%eax
 797:	89 04 24             	mov    %eax,(%esp)
 79a:	e8 5d fc ff ff       	call   3fc <sbrk>
 79f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 7a2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 7a6:	75 07                	jne    7af <morecore+0x34>
    return 0;
 7a8:	b8 00 00 00 00       	mov    $0x0,%eax
 7ad:	eb 22                	jmp    7d1 <morecore+0x56>
  hp = (Header*)p;
 7af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	8b 55 08             	mov    0x8(%ebp),%edx
 7bb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	83 c0 08             	add    $0x8,%eax
 7c4:	89 04 24             	mov    %eax,(%esp)
 7c7:	e8 d8 fe ff ff       	call   6a4 <free>
  return freep;
 7cc:	a1 08 09 00 00       	mov    0x908,%eax
}
 7d1:	c9                   	leave  
 7d2:	c3                   	ret    

000007d3 <malloc>:

void*
malloc(uint nbytes)
{
 7d3:	55                   	push   %ebp
 7d4:	89 e5                	mov    %esp,%ebp
 7d6:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d9:	8b 45 08             	mov    0x8(%ebp),%eax
 7dc:	83 c0 07             	add    $0x7,%eax
 7df:	c1 e8 03             	shr    $0x3,%eax
 7e2:	83 c0 01             	add    $0x1,%eax
 7e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 7e8:	a1 08 09 00 00       	mov    0x908,%eax
 7ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f4:	75 23                	jne    819 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7f6:	c7 45 f0 00 09 00 00 	movl   $0x900,-0x10(%ebp)
 7fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 800:	a3 08 09 00 00       	mov    %eax,0x908
 805:	a1 08 09 00 00       	mov    0x908,%eax
 80a:	a3 00 09 00 00       	mov    %eax,0x900
    base.s.size = 0;
 80f:	c7 05 04 09 00 00 00 	movl   $0x0,0x904
 816:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 819:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81c:	8b 00                	mov    (%eax),%eax
 81e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 821:	8b 45 ec             	mov    -0x14(%ebp),%eax
 824:	8b 40 04             	mov    0x4(%eax),%eax
 827:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 82a:	72 4d                	jb     879 <malloc+0xa6>
      if(p->s.size == nunits)
 82c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 82f:	8b 40 04             	mov    0x4(%eax),%eax
 832:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 835:	75 0c                	jne    843 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 837:	8b 45 ec             	mov    -0x14(%ebp),%eax
 83a:	8b 10                	mov    (%eax),%edx
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	89 10                	mov    %edx,(%eax)
 841:	eb 26                	jmp    869 <malloc+0x96>
      else {
        p->s.size -= nunits;
 843:	8b 45 ec             	mov    -0x14(%ebp),%eax
 846:	8b 40 04             	mov    0x4(%eax),%eax
 849:	89 c2                	mov    %eax,%edx
 84b:	2b 55 f4             	sub    -0xc(%ebp),%edx
 84e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 851:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 854:	8b 45 ec             	mov    -0x14(%ebp),%eax
 857:	8b 40 04             	mov    0x4(%eax),%eax
 85a:	c1 e0 03             	shl    $0x3,%eax
 85d:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 860:	8b 45 ec             	mov    -0x14(%ebp),%eax
 863:	8b 55 f4             	mov    -0xc(%ebp),%edx
 866:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 869:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86c:	a3 08 09 00 00       	mov    %eax,0x908
      return (void*)(p + 1);
 871:	8b 45 ec             	mov    -0x14(%ebp),%eax
 874:	83 c0 08             	add    $0x8,%eax
 877:	eb 38                	jmp    8b1 <malloc+0xde>
    }
    if(p == freep)
 879:	a1 08 09 00 00       	mov    0x908,%eax
 87e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 881:	75 1b                	jne    89e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	89 04 24             	mov    %eax,(%esp)
 889:	e8 ed fe ff ff       	call   77b <morecore>
 88e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 891:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 895:	75 07                	jne    89e <malloc+0xcb>
        return 0;
 897:	b8 00 00 00 00       	mov    $0x0,%eax
 89c:	eb 13                	jmp    8b1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a7:	8b 00                	mov    (%eax),%eax
 8a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8ac:	e9 70 ff ff ff       	jmp    821 <malloc+0x4e>
}
 8b1:	c9                   	leave  
 8b2:	c3                   	ret    
