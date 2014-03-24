
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
   6:	57                   	push   %edi
   7:	56                   	push   %esi
   8:	53                   	push   %ebx

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
    if(fork() > 0)
   9:	31 db                	xor    %ebx,%ebx
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   b:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));
  11:	8d 74 24 16          	lea    0x16(%esp),%esi

int
main(int argc, char *argv[])
{
  int fd, i;
  char path[] = "stressfs0";
  15:	c7 84 24 16 02 00 00 	movl   $0x65727473,0x216(%esp)
  1c:	73 74 72 65 
  20:	c7 84 24 1a 02 00 00 	movl   $0x73667373,0x21a(%esp)
  27:	73 73 66 73 
  2b:	66 c7 84 24 1e 02 00 	movw   $0x30,0x21e(%esp)
  32:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  35:	c7 44 24 04 e5 08 00 	movl   $0x8e5,0x4(%esp)
  3c:	00 
  3d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  44:	e8 87 04 00 00       	call   4d0 <printf>
  memset(data, 'a', sizeof(data));
  49:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  50:	00 
  51:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  58:	00 
  59:	89 34 24             	mov    %esi,(%esp)
  5c:	e8 9f 01 00 00       	call   200 <memset>

  for(i = 0; i < 4; i++)
    if(fork() > 0)
  61:	e8 1a 03 00 00       	call   380 <fork>
  66:	85 c0                	test   %eax,%eax
  68:	7f 2b                	jg     95 <main+0x95>
  6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  70:	e8 0b 03 00 00       	call   380 <fork>
  75:	b3 01                	mov    $0x1,%bl
  77:	85 c0                	test   %eax,%eax
  79:	7f 1a                	jg     95 <main+0x95>
  7b:	e8 00 03 00 00       	call   380 <fork>
  80:	b3 02                	mov    $0x2,%bl
  82:	85 c0                	test   %eax,%eax
  84:	7f 0f                	jg     95 <main+0x95>
  86:	e8 f5 02 00 00       	call   380 <fork>
  8b:	31 db                	xor    %ebx,%ebx
  8d:	85 c0                	test   %eax,%eax
  8f:	0f 9e c3             	setle  %bl
  92:	83 c3 03             	add    $0x3,%ebx
      break;

  printf(1, "write %d\n", i);
  95:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  99:	c7 44 24 04 f8 08 00 	movl   $0x8f8,0x4(%esp)
  a0:	00 
  a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a8:	e8 23 04 00 00       	call   4d0 <printf>

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  ad:	8d 84 24 16 02 00 00 	lea    0x216(%esp),%eax
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);

  path[8] += i;
  b4:	00 9c 24 1e 02 00 00 	add    %bl,0x21e(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  bb:	31 db                	xor    %ebx,%ebx
  bd:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c4:	00 
  c5:	89 04 24             	mov    %eax,(%esp)
  c8:	e8 fb 02 00 00       	call   3c8 <open>
  cd:	89 c7                	mov    %eax,%edi
  cf:	90                   	nop
  for(i = 0; i < 20; i++)
  d0:	83 c3 01             	add    $0x1,%ebx
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  d3:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  da:	00 
  db:	89 74 24 04          	mov    %esi,0x4(%esp)
  df:	89 3c 24             	mov    %edi,(%esp)
  e2:	e8 c1 02 00 00       	call   3a8 <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  e7:	83 fb 14             	cmp    $0x14,%ebx
  ea:	75 e4                	jne    d0 <main+0xd0>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  ec:	89 3c 24             	mov    %edi,(%esp)

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  ef:	30 db                	xor    %bl,%bl
  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  f1:	e8 ba 02 00 00       	call   3b0 <close>

  printf(1, "read\n");
  f6:	c7 44 24 04 02 09 00 	movl   $0x902,0x4(%esp)
  fd:	00 
  fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 105:	e8 c6 03 00 00       	call   4d0 <printf>

  fd = open(path, O_RDONLY);
 10a:	8d 84 24 16 02 00 00 	lea    0x216(%esp),%eax
 111:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 118:	00 
 119:	89 04 24             	mov    %eax,(%esp)
 11c:	e8 a7 02 00 00       	call   3c8 <open>
 121:	89 c7                	mov    %eax,%edi
 123:	90                   	nop
 124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i < 20; i++)
 128:	83 c3 01             	add    $0x1,%ebx
    read(fd, data, sizeof(data));
 12b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 132:	00 
 133:	89 74 24 04          	mov    %esi,0x4(%esp)
 137:	89 3c 24             	mov    %edi,(%esp)
 13a:	e8 61 02 00 00       	call   3a0 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 13f:	83 fb 14             	cmp    $0x14,%ebx
 142:	75 e4                	jne    128 <main+0x128>
    read(fd, data, sizeof(data));
  close(fd);
 144:	89 3c 24             	mov    %edi,(%esp)
 147:	e8 64 02 00 00       	call   3b0 <close>

  wait();
 14c:	e8 3f 02 00 00       	call   390 <wait>
  
  exit();
 151:	e8 32 02 00 00       	call   388 <exit>
 156:	90                   	nop
 157:	90                   	nop
 158:	90                   	nop
 159:	90                   	nop
 15a:	90                   	nop
 15b:	90                   	nop
 15c:	90                   	nop
 15d:	90                   	nop
 15e:	90                   	nop
 15f:	90                   	nop

00000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 160:	55                   	push   %ebp
 161:	31 d2                	xor    %edx,%edx
 163:	89 e5                	mov    %esp,%ebp
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	53                   	push   %ebx
 169:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 170:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 174:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 177:	83 c2 01             	add    $0x1,%edx
 17a:	84 c9                	test   %cl,%cl
 17c:	75 f2                	jne    170 <strcpy+0x10>
    ;
  return os;
}
 17e:	5b                   	pop    %ebx
 17f:	5d                   	pop    %ebp
 180:	c3                   	ret    
 181:	eb 0d                	jmp    190 <strcmp>
 183:	90                   	nop
 184:	90                   	nop
 185:	90                   	nop
 186:	90                   	nop
 187:	90                   	nop
 188:	90                   	nop
 189:	90                   	nop
 18a:	90                   	nop
 18b:	90                   	nop
 18c:	90                   	nop
 18d:	90                   	nop
 18e:	90                   	nop
 18f:	90                   	nop

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 4d 08             	mov    0x8(%ebp),%ecx
 196:	53                   	push   %ebx
 197:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 19a:	0f b6 01             	movzbl (%ecx),%eax
 19d:	84 c0                	test   %al,%al
 19f:	75 14                	jne    1b5 <strcmp+0x25>
 1a1:	eb 25                	jmp    1c8 <strcmp+0x38>
 1a3:	90                   	nop
 1a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 1a8:	83 c1 01             	add    $0x1,%ecx
 1ab:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ae:	0f b6 01             	movzbl (%ecx),%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	74 13                	je     1c8 <strcmp+0x38>
 1b5:	0f b6 1a             	movzbl (%edx),%ebx
 1b8:	38 d8                	cmp    %bl,%al
 1ba:	74 ec                	je     1a8 <strcmp+0x18>
 1bc:	0f b6 db             	movzbl %bl,%ebx
 1bf:	0f b6 c0             	movzbl %al,%eax
 1c2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 1c4:	5b                   	pop    %ebx
 1c5:	5d                   	pop    %ebp
 1c6:	c3                   	ret    
 1c7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1c8:	0f b6 1a             	movzbl (%edx),%ebx
 1cb:	31 c0                	xor    %eax,%eax
 1cd:	0f b6 db             	movzbl %bl,%ebx
 1d0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 1d2:	5b                   	pop    %ebx
 1d3:	5d                   	pop    %ebp
 1d4:	c3                   	ret    
 1d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <strlen>:

uint
strlen(char *s)
{
 1e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 1e1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1e3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 1e5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1ea:	80 39 00             	cmpb   $0x0,(%ecx)
 1ed:	74 0c                	je     1fb <strlen+0x1b>
 1ef:	90                   	nop
 1f0:	83 c2 01             	add    $0x1,%edx
 1f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1f7:	89 d0                	mov    %edx,%eax
 1f9:	75 f5                	jne    1f0 <strlen+0x10>
    ;
  return n;
}
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    
 1fd:	8d 76 00             	lea    0x0(%esi),%esi

00000200 <memset>:

void*
memset(void *dst, int c, uint n)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 55 08             	mov    0x8(%ebp),%edx
 206:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 207:	8b 4d 10             	mov    0x10(%ebp),%ecx
 20a:	8b 45 0c             	mov    0xc(%ebp),%eax
 20d:	89 d7                	mov    %edx,%edi
 20f:	fc                   	cld    
 210:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 212:	89 d0                	mov    %edx,%eax
 214:	5f                   	pop    %edi
 215:	5d                   	pop    %ebp
 216:	c3                   	ret    
 217:	89 f6                	mov    %esi,%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 22a:	0f b6 10             	movzbl (%eax),%edx
 22d:	84 d2                	test   %dl,%dl
 22f:	75 11                	jne    242 <strchr+0x22>
 231:	eb 15                	jmp    248 <strchr+0x28>
 233:	90                   	nop
 234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 238:	83 c0 01             	add    $0x1,%eax
 23b:	0f b6 10             	movzbl (%eax),%edx
 23e:	84 d2                	test   %dl,%dl
 240:	74 06                	je     248 <strchr+0x28>
    if(*s == c)
 242:	38 ca                	cmp    %cl,%dl
 244:	75 f2                	jne    238 <strchr+0x18>
      return (char*)s;
  return 0;
}
 246:	5d                   	pop    %ebp
 247:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 248:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 24a:	5d                   	pop    %ebp
 24b:	90                   	nop
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 250:	c3                   	ret    
 251:	eb 0d                	jmp    260 <atoi>
 253:	90                   	nop
 254:	90                   	nop
 255:	90                   	nop
 256:	90                   	nop
 257:	90                   	nop
 258:	90                   	nop
 259:	90                   	nop
 25a:	90                   	nop
 25b:	90                   	nop
 25c:	90                   	nop
 25d:	90                   	nop
 25e:	90                   	nop
 25f:	90                   	nop

00000260 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 260:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 261:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 263:	89 e5                	mov    %esp,%ebp
 265:	8b 4d 08             	mov    0x8(%ebp),%ecx
 268:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 269:	0f b6 11             	movzbl (%ecx),%edx
 26c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 26f:	80 fb 09             	cmp    $0x9,%bl
 272:	77 1c                	ja     290 <atoi+0x30>
 274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 278:	0f be d2             	movsbl %dl,%edx
 27b:	83 c1 01             	add    $0x1,%ecx
 27e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 281:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 285:	0f b6 11             	movzbl (%ecx),%edx
 288:	8d 5a d0             	lea    -0x30(%edx),%ebx
 28b:	80 fb 09             	cmp    $0x9,%bl
 28e:	76 e8                	jbe    278 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 290:	5b                   	pop    %ebx
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    
 293:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	56                   	push   %esi
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	53                   	push   %ebx
 2a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ae:	85 db                	test   %ebx,%ebx
 2b0:	7e 14                	jle    2c6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 2b2:	31 d2                	xor    %edx,%edx
 2b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 2b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2bf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c2:	39 da                	cmp    %ebx,%edx
 2c4:	75 f2                	jne    2b8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 2c6:	5b                   	pop    %ebx
 2c7:	5e                   	pop    %esi
 2c8:	5d                   	pop    %ebp
 2c9:	c3                   	ret    
 2ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002d0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2d9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 2dc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 2df:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2eb:	00 
 2ec:	89 04 24             	mov    %eax,(%esp)
 2ef:	e8 d4 00 00 00       	call   3c8 <open>
  if(fd < 0)
 2f4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2f8:	78 19                	js     313 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 2fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fd:	89 1c 24             	mov    %ebx,(%esp)
 300:	89 44 24 04          	mov    %eax,0x4(%esp)
 304:	e8 d7 00 00 00       	call   3e0 <fstat>
  close(fd);
 309:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 30c:	89 c6                	mov    %eax,%esi
  close(fd);
 30e:	e8 9d 00 00 00       	call   3b0 <close>
  return r;
}
 313:	89 f0                	mov    %esi,%eax
 315:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 318:	8b 75 fc             	mov    -0x4(%ebp),%esi
 31b:	89 ec                	mov    %ebp,%esp
 31d:	5d                   	pop    %ebp
 31e:	c3                   	ret    
 31f:	90                   	nop

00000320 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
 325:	31 f6                	xor    %esi,%esi
 327:	53                   	push   %ebx
 328:	83 ec 2c             	sub    $0x2c,%esp
 32b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32e:	eb 06                	jmp    336 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 330:	3c 0a                	cmp    $0xa,%al
 332:	74 39                	je     36d <gets+0x4d>
 334:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 336:	8d 5e 01             	lea    0x1(%esi),%ebx
 339:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 33c:	7d 31                	jge    36f <gets+0x4f>
    cc = read(0, &c, 1);
 33e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 341:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 348:	00 
 349:	89 44 24 04          	mov    %eax,0x4(%esp)
 34d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 354:	e8 47 00 00 00       	call   3a0 <read>
    if(cc < 1)
 359:	85 c0                	test   %eax,%eax
 35b:	7e 12                	jle    36f <gets+0x4f>
      break;
    buf[i++] = c;
 35d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 361:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 365:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 369:	3c 0d                	cmp    $0xd,%al
 36b:	75 c3                	jne    330 <gets+0x10>
 36d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 36f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 373:	89 f8                	mov    %edi,%eax
 375:	83 c4 2c             	add    $0x2c,%esp
 378:	5b                   	pop    %ebx
 379:	5e                   	pop    %esi
 37a:	5f                   	pop    %edi
 37b:	5d                   	pop    %ebp
 37c:	c3                   	ret    
 37d:	90                   	nop
 37e:	90                   	nop
 37f:	90                   	nop

00000380 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 380:	b8 01 00 00 00       	mov    $0x1,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <exit>:
SYSCALL(exit)
 388:	b8 02 00 00 00       	mov    $0x2,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <wait>:
SYSCALL(wait)
 390:	b8 03 00 00 00       	mov    $0x3,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <pipe>:
SYSCALL(pipe)
 398:	b8 04 00 00 00       	mov    $0x4,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <read>:
SYSCALL(read)
 3a0:	b8 05 00 00 00       	mov    $0x5,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <write>:
SYSCALL(write)
 3a8:	b8 10 00 00 00       	mov    $0x10,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <close>:
SYSCALL(close)
 3b0:	b8 15 00 00 00       	mov    $0x15,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <kill>:
SYSCALL(kill)
 3b8:	b8 06 00 00 00       	mov    $0x6,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <exec>:
SYSCALL(exec)
 3c0:	b8 07 00 00 00       	mov    $0x7,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <open>:
SYSCALL(open)
 3c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <mknod>:
SYSCALL(mknod)
 3d0:	b8 11 00 00 00       	mov    $0x11,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <unlink>:
SYSCALL(unlink)
 3d8:	b8 12 00 00 00       	mov    $0x12,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <fstat>:
SYSCALL(fstat)
 3e0:	b8 08 00 00 00       	mov    $0x8,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <link>:
SYSCALL(link)
 3e8:	b8 13 00 00 00       	mov    $0x13,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <mkdir>:
SYSCALL(mkdir)
 3f0:	b8 14 00 00 00       	mov    $0x14,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <chdir>:
SYSCALL(chdir)
 3f8:	b8 09 00 00 00       	mov    $0x9,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <dup>:
SYSCALL(dup)
 400:	b8 0a 00 00 00       	mov    $0xa,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <getpid>:
SYSCALL(getpid)
 408:	b8 0b 00 00 00       	mov    $0xb,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <sbrk>:
SYSCALL(sbrk)
 410:	b8 0c 00 00 00       	mov    $0xc,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <sleep>:
SYSCALL(sleep)
 418:	b8 0d 00 00 00       	mov    $0xd,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <uptime>:
SYSCALL(uptime)
 420:	b8 0e 00 00 00       	mov    $0xe,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <gettime>:
SYSCALL(gettime)
 428:	b8 16 00 00 00       	mov    $0x16,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <shmget>:
SYSCALL(shmget)
 430:	b8 17 00 00 00       	mov    $0x17,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    
 438:	90                   	nop
 439:	90                   	nop
 43a:	90                   	nop
 43b:	90                   	nop
 43c:	90                   	nop
 43d:	90                   	nop
 43e:	90                   	nop
 43f:	90                   	nop

00000440 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	89 cf                	mov    %ecx,%edi
 446:	56                   	push   %esi
 447:	89 c6                	mov    %eax,%esi
 449:	53                   	push   %ebx
 44a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 450:	85 c9                	test   %ecx,%ecx
 452:	74 04                	je     458 <printint+0x18>
 454:	85 d2                	test   %edx,%edx
 456:	78 68                	js     4c0 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 458:	89 d0                	mov    %edx,%eax
 45a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 461:	31 c9                	xor    %ecx,%ecx
 463:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 466:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 468:	31 d2                	xor    %edx,%edx
 46a:	f7 f7                	div    %edi
 46c:	0f b6 92 0f 09 00 00 	movzbl 0x90f(%edx),%edx
 473:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 476:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 479:	85 c0                	test   %eax,%eax
 47b:	75 eb                	jne    468 <printint+0x28>
  if(neg)
 47d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 480:	85 c0                	test   %eax,%eax
 482:	74 08                	je     48c <printint+0x4c>
    buf[i++] = '-';
 484:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 489:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 48c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 48f:	90                   	nop
 490:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
 494:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 497:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 49e:	00 
 49f:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4a2:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4a5:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ac:	e8 f7 fe ff ff       	call   3a8 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4b1:	83 ff ff             	cmp    $0xffffffff,%edi
 4b4:	75 da                	jne    490 <printint+0x50>
    putc(fd, buf[i]);
}
 4b6:	83 c4 4c             	add    $0x4c,%esp
 4b9:	5b                   	pop    %ebx
 4ba:	5e                   	pop    %esi
 4bb:	5f                   	pop    %edi
 4bc:	5d                   	pop    %ebp
 4bd:	c3                   	ret    
 4be:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4c0:	89 d0                	mov    %edx,%eax
 4c2:	f7 d8                	neg    %eax
 4c4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 4cb:	eb 94                	jmp    461 <printint+0x21>
 4cd:	8d 76 00             	lea    0x0(%esi),%esi

000004d0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
 4d5:	53                   	push   %ebx
 4d6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dc:	0f b6 10             	movzbl (%eax),%edx
 4df:	84 d2                	test   %dl,%dl
 4e1:	0f 84 c1 00 00 00    	je     5a8 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4e7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4ea:	31 ff                	xor    %edi,%edi
 4ec:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 4ef:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f1:	8d 75 e7             	lea    -0x19(%ebp),%esi
 4f4:	eb 1e                	jmp    514 <printf+0x44>
 4f6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4f8:	83 fa 25             	cmp    $0x25,%edx
 4fb:	0f 85 af 00 00 00    	jne    5b0 <printf+0xe0>
 501:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 505:	83 c3 01             	add    $0x1,%ebx
 508:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 50c:	84 d2                	test   %dl,%dl
 50e:	0f 84 94 00 00 00    	je     5a8 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
 514:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 516:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 519:	74 dd                	je     4f8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 51b:	83 ff 25             	cmp    $0x25,%edi
 51e:	75 e5                	jne    505 <printf+0x35>
      if(c == 'd'){
 520:	83 fa 64             	cmp    $0x64,%edx
 523:	0f 84 3f 01 00 00    	je     668 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 529:	83 fa 70             	cmp    $0x70,%edx
 52c:	0f 84 a6 00 00 00    	je     5d8 <printf+0x108>
 532:	83 fa 78             	cmp    $0x78,%edx
 535:	0f 84 9d 00 00 00    	je     5d8 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 53b:	83 fa 73             	cmp    $0x73,%edx
 53e:	66 90                	xchg   %ax,%ax
 540:	0f 84 ba 00 00 00    	je     600 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 546:	83 fa 63             	cmp    $0x63,%edx
 549:	0f 84 41 01 00 00    	je     690 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 54f:	83 fa 25             	cmp    $0x25,%edx
 552:	0f 84 00 01 00 00    	je     658 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 558:	8b 4d 08             	mov    0x8(%ebp),%ecx
 55b:	89 55 cc             	mov    %edx,-0x34(%ebp)
 55e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 562:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 569:	00 
 56a:	89 74 24 04          	mov    %esi,0x4(%esp)
 56e:	89 0c 24             	mov    %ecx,(%esp)
 571:	e8 32 fe ff ff       	call   3a8 <write>
 576:	8b 55 cc             	mov    -0x34(%ebp),%edx
 579:	88 55 e7             	mov    %dl,-0x19(%ebp)
 57c:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 57f:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 582:	31 ff                	xor    %edi,%edi
 584:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 58b:	00 
 58c:	89 74 24 04          	mov    %esi,0x4(%esp)
 590:	89 04 24             	mov    %eax,(%esp)
 593:	e8 10 fe ff ff       	call   3a8 <write>
 598:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 59b:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 59f:	84 d2                	test   %dl,%dl
 5a1:	0f 85 6d ff ff ff    	jne    514 <printf+0x44>
 5a7:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5a8:	83 c4 3c             	add    $0x3c,%esp
 5ab:	5b                   	pop    %ebx
 5ac:	5e                   	pop    %esi
 5ad:	5f                   	pop    %edi
 5ae:	5d                   	pop    %ebp
 5af:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5b3:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5bd:	00 
 5be:	89 74 24 04          	mov    %esi,0x4(%esp)
 5c2:	89 04 24             	mov    %eax,(%esp)
 5c5:	e8 de fd ff ff       	call   3a8 <write>
 5ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 5cd:	e9 33 ff ff ff       	jmp    505 <printf+0x35>
 5d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5db:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 5e0:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5e9:	8b 10                	mov    (%eax),%edx
 5eb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ee:	e8 4d fe ff ff       	call   440 <printint>
 5f3:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5f6:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5fa:	e9 06 ff ff ff       	jmp    505 <printf+0x35>
 5ff:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 600:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 603:	b9 08 09 00 00       	mov    $0x908,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 608:	8b 3a                	mov    (%edx),%edi
        ap++;
 60a:	83 c2 04             	add    $0x4,%edx
 60d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 610:	85 ff                	test   %edi,%edi
 612:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 615:	0f b6 17             	movzbl (%edi),%edx
 618:	84 d2                	test   %dl,%dl
 61a:	74 33                	je     64f <printf+0x17f>
 61c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 61f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 628:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 62b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 62e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 635:	00 
 636:	89 74 24 04          	mov    %esi,0x4(%esp)
 63a:	89 1c 24             	mov    %ebx,(%esp)
 63d:	e8 66 fd ff ff       	call   3a8 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 642:	0f b6 17             	movzbl (%edi),%edx
 645:	84 d2                	test   %dl,%dl
 647:	75 df                	jne    628 <printf+0x158>
 649:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 64c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 64f:	31 ff                	xor    %edi,%edi
 651:	e9 af fe ff ff       	jmp    505 <printf+0x35>
 656:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 658:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 65c:	e9 1b ff ff ff       	jmp    57c <printf+0xac>
 661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 668:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 66b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 670:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 673:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 67a:	8b 10                	mov    (%eax),%edx
 67c:	8b 45 08             	mov    0x8(%ebp),%eax
 67f:	e8 bc fd ff ff       	call   440 <printint>
 684:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 687:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 68b:	e9 75 fe ff ff       	jmp    505 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 690:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 693:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 695:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 698:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 69a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6a1:	00 
 6a2:	89 74 24 04          	mov    %esi,0x4(%esp)
 6a6:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6a9:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6ac:	e8 f7 fc ff ff       	call   3a8 <write>
 6b1:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 6b4:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6b8:	e9 48 fe ff ff       	jmp    505 <printf+0x35>
 6bd:	90                   	nop
 6be:	90                   	nop
 6bf:	90                   	nop

000006c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c1:	a1 28 09 00 00       	mov    0x928,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c6:	89 e5                	mov    %esp,%ebp
 6c8:	57                   	push   %edi
 6c9:	56                   	push   %esi
 6ca:	53                   	push   %ebx
 6cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d1:	39 c8                	cmp    %ecx,%eax
 6d3:	73 1d                	jae    6f2 <free+0x32>
 6d5:	8d 76 00             	lea    0x0(%esi),%esi
 6d8:	8b 10                	mov    (%eax),%edx
 6da:	39 d1                	cmp    %edx,%ecx
 6dc:	72 1a                	jb     6f8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6de:	39 d0                	cmp    %edx,%eax
 6e0:	72 08                	jb     6ea <free+0x2a>
 6e2:	39 c8                	cmp    %ecx,%eax
 6e4:	72 12                	jb     6f8 <free+0x38>
 6e6:	39 d1                	cmp    %edx,%ecx
 6e8:	72 0e                	jb     6f8 <free+0x38>
 6ea:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ec:	39 c8                	cmp    %ecx,%eax
 6ee:	66 90                	xchg   %ax,%ax
 6f0:	72 e6                	jb     6d8 <free+0x18>
 6f2:	8b 10                	mov    (%eax),%edx
 6f4:	eb e8                	jmp    6de <free+0x1e>
 6f6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f8:	8b 71 04             	mov    0x4(%ecx),%esi
 6fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6fe:	39 d7                	cmp    %edx,%edi
 700:	74 19                	je     71b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 702:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 705:	8b 50 04             	mov    0x4(%eax),%edx
 708:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 70b:	39 ce                	cmp    %ecx,%esi
 70d:	74 23                	je     732 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 70f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 711:	a3 28 09 00 00       	mov    %eax,0x928
}
 716:	5b                   	pop    %ebx
 717:	5e                   	pop    %esi
 718:	5f                   	pop    %edi
 719:	5d                   	pop    %ebp
 71a:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 71b:	03 72 04             	add    0x4(%edx),%esi
 71e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 721:	8b 10                	mov    (%eax),%edx
 723:	8b 12                	mov    (%edx),%edx
 725:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 728:	8b 50 04             	mov    0x4(%eax),%edx
 72b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 72e:	39 ce                	cmp    %ecx,%esi
 730:	75 dd                	jne    70f <free+0x4f>
    p->s.size += bp->s.size;
 732:	03 51 04             	add    0x4(%ecx),%edx
 735:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 738:	8b 53 f8             	mov    -0x8(%ebx),%edx
 73b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 73d:	a3 28 09 00 00       	mov    %eax,0x928
}
 742:	5b                   	pop    %ebx
 743:	5e                   	pop    %esi
 744:	5f                   	pop    %edi
 745:	5d                   	pop    %ebp
 746:	c3                   	ret    
 747:	89 f6                	mov    %esi,%esi
 749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000750 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	57                   	push   %edi
 754:	56                   	push   %esi
 755:	53                   	push   %ebx
 756:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 759:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 75c:	8b 0d 28 09 00 00    	mov    0x928,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 762:	83 c3 07             	add    $0x7,%ebx
 765:	c1 eb 03             	shr    $0x3,%ebx
 768:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 76b:	85 c9                	test   %ecx,%ecx
 76d:	0f 84 9b 00 00 00    	je     80e <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 773:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 775:	8b 50 04             	mov    0x4(%eax),%edx
 778:	39 d3                	cmp    %edx,%ebx
 77a:	76 27                	jbe    7a3 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 77c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 783:	be 00 80 00 00       	mov    $0x8000,%esi
 788:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 78b:	90                   	nop
 78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 790:	3b 05 28 09 00 00    	cmp    0x928,%eax
 796:	74 30                	je     7c8 <malloc+0x78>
 798:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79a:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 79c:	8b 50 04             	mov    0x4(%eax),%edx
 79f:	39 d3                	cmp    %edx,%ebx
 7a1:	77 ed                	ja     790 <malloc+0x40>
      if(p->s.size == nunits)
 7a3:	39 d3                	cmp    %edx,%ebx
 7a5:	74 61                	je     808 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7a7:	29 da                	sub    %ebx,%edx
 7a9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ac:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 7af:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 7b2:	89 0d 28 09 00 00    	mov    %ecx,0x928
      return (void*)(p + 1);
 7b8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7bb:	83 c4 2c             	add    $0x2c,%esp
 7be:	5b                   	pop    %ebx
 7bf:	5e                   	pop    %esi
 7c0:	5f                   	pop    %edi
 7c1:	5d                   	pop    %ebp
 7c2:	c3                   	ret    
 7c3:	90                   	nop
 7c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 7c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7cb:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 7d1:	bf 00 10 00 00       	mov    $0x1000,%edi
 7d6:	0f 43 fb             	cmovae %ebx,%edi
 7d9:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 7dc:	89 04 24             	mov    %eax,(%esp)
 7df:	e8 2c fc ff ff       	call   410 <sbrk>
  if(p == (char*)-1)
 7e4:	83 f8 ff             	cmp    $0xffffffff,%eax
 7e7:	74 18                	je     801 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7e9:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 7ec:	83 c0 08             	add    $0x8,%eax
 7ef:	89 04 24             	mov    %eax,(%esp)
 7f2:	e8 c9 fe ff ff       	call   6c0 <free>
  return freep;
 7f7:	8b 0d 28 09 00 00    	mov    0x928,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 7fd:	85 c9                	test   %ecx,%ecx
 7ff:	75 99                	jne    79a <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 801:	31 c0                	xor    %eax,%eax
 803:	eb b6                	jmp    7bb <malloc+0x6b>
 805:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 808:	8b 10                	mov    (%eax),%edx
 80a:	89 11                	mov    %edx,(%ecx)
 80c:	eb a4                	jmp    7b2 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 80e:	c7 05 28 09 00 00 20 	movl   $0x920,0x928
 815:	09 00 00 
    base.s.size = 0;
 818:	b9 20 09 00 00       	mov    $0x920,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 81d:	c7 05 20 09 00 00 20 	movl   $0x920,0x920
 824:	09 00 00 
    base.s.size = 0;
 827:	c7 05 24 09 00 00 00 	movl   $0x0,0x924
 82e:	00 00 00 
 831:	e9 3d ff ff ff       	jmp    773 <malloc+0x23>
 836:	90                   	nop
 837:	90                   	nop
 838:	90                   	nop
 839:	90                   	nop
 83a:	90                   	nop
 83b:	90                   	nop
 83c:	90                   	nop
 83d:	90                   	nop
 83e:	90                   	nop
 83f:	90                   	nop

00000840 <ring_attach>:
#include "ring.h"

struct ring *ring_attach(uint token)
{
 840:	55                   	push   %ebp
  return 0;
}
 841:	31 c0                	xor    %eax,%eax
#include "ring.h"

struct ring *ring_attach(uint token)
{
 843:	89 e5                	mov    %esp,%ebp
  return 0;
}
 845:	5d                   	pop    %ebp
 846:	c3                   	ret    
 847:	89 f6                	mov    %esi,%esi
 849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000850 <ring_size>:

int ring_size(uint token)
{
 850:	55                   	push   %ebp
  return 0;
}
 851:	31 c0                	xor    %eax,%eax
{
  return 0;
}

int ring_size(uint token)
{
 853:	89 e5                	mov    %esp,%ebp
  return 0;
}
 855:	5d                   	pop    %ebp
 856:	c3                   	ret    
 857:	89 f6                	mov    %esi,%esi
 859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000860 <ring_detach>:

int ring_detach(uint token)
{
 860:	55                   	push   %ebp
  return 0;
}
 861:	31 c0                	xor    %eax,%eax
{
  return 0;
}

int ring_detach(uint token)
{
 863:	89 e5                	mov    %esp,%ebp
  return 0;
}
 865:	5d                   	pop    %ebp
 866:	c3                   	ret    
 867:	89 f6                	mov    %esi,%esi
 869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000870 <ring_write_reserve>:

struct ring_res ring_write_reserve(struct ring *r, int bytes)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	8b 45 08             	mov    0x8(%ebp),%eax
  struct ring_res ret = {0, 0};
  return ret;
 876:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 87d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 883:	5d                   	pop    %ebp
 884:	c2 04 00             	ret    $0x4
 887:	89 f6                	mov    %esi,%esi
 889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000890 <ring_write_notify>:

void ring_write_notify(struct ring *r, int bytes)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp

}
 893:	5d                   	pop    %ebp
 894:	c3                   	ret    
 895:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008a0 <ring_read_reserve>:

struct ring_res ring_read_reserve(struct ring *r, int bytes)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	8b 45 08             	mov    0x8(%ebp),%eax
  struct ring_res ret = {0, 0};
  return ret;
 8a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 8ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 8b3:	5d                   	pop    %ebp
 8b4:	c2 04 00             	ret    $0x4
 8b7:	89 f6                	mov    %esi,%esi
 8b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008c0 <ring_read_notify>:

void ring_read_notify(struct ring *r, int bytes)
{
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp

}
 8c3:	5d                   	pop    %ebp
 8c4:	c3                   	ret    
 8c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008d0 <ring_write>:

void ring_write(struct ring *r, void *buf, int bytes)
{
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp

}
 8d3:	5d                   	pop    %ebp
 8d4:	c3                   	ret    
 8d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008e0 <ring_read>:

void ring_read(struct ring *r, void *buf, int bytes)
{
 8e0:	55                   	push   %ebp
 8e1:	89 e5                	mov    %esp,%ebp

}
 8e3:	5d                   	pop    %ebp
 8e4:	c3                   	ret    
