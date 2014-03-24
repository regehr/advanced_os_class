
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	53                   	push   %ebx
   7:	83 ec 1c             	sub    $0x1c,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  11:	00 
  12:	c7 04 24 95 08 00 00 	movl   $0x895,(%esp)
  19:	e8 5a 03 00 00       	call   378 <open>
  1e:	85 c0                	test   %eax,%eax
  20:	0f 88 af 00 00 00    	js     d5 <main+0xd5>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2d:	e8 7e 03 00 00       	call   3b0 <dup>
  dup(0);  // stderr
  32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  39:	e8 72 03 00 00       	call   3b0 <dup>
  3e:	66 90                	xchg   %ax,%ax

  for(;;){
    printf(1, "init: starting sh\n");
  40:	c7 44 24 04 9d 08 00 	movl   $0x89d,0x4(%esp)
  47:	00 
  48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4f:	e8 2c 04 00 00       	call   480 <printf>
    pid = fork();
  54:	e8 d7 02 00 00       	call   330 <fork>
    if(pid < 0){
  59:	83 f8 00             	cmp    $0x0,%eax
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
  5c:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  5e:	7c 28                	jl     88 <main+0x88>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  60:	74 46                	je     a8 <main+0xa8>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  62:	e8 d9 02 00 00       	call   340 <wait>
  67:	85 c0                	test   %eax,%eax
  69:	78 d5                	js     40 <main+0x40>
  6b:	39 c3                	cmp    %eax,%ebx
  6d:	8d 76 00             	lea    0x0(%esi),%esi
  70:	74 ce                	je     40 <main+0x40>
      printf(1, "zombie!\n");
  72:	c7 44 24 04 dc 08 00 	movl   $0x8dc,0x4(%esp)
  79:	00 
  7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  81:	e8 fa 03 00 00       	call   480 <printf>
  86:	eb da                	jmp    62 <main+0x62>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  88:	c7 44 24 04 b0 08 00 	movl   $0x8b0,0x4(%esp)
  8f:	00 
  90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  97:	e8 e4 03 00 00       	call   480 <printf>
      exit();
  9c:	e8 97 02 00 00       	call   338 <exit>
  a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    if(pid == 0){
      exec("sh", argv);
  a8:	c7 44 24 04 00 09 00 	movl   $0x900,0x4(%esp)
  af:	00 
  b0:	c7 04 24 c3 08 00 00 	movl   $0x8c3,(%esp)
  b7:	e8 b4 02 00 00       	call   370 <exec>
      printf(1, "init: exec sh failed\n");
  bc:	c7 44 24 04 c6 08 00 	movl   $0x8c6,0x4(%esp)
  c3:	00 
  c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  cb:	e8 b0 03 00 00       	call   480 <printf>
      exit();
  d0:	e8 63 02 00 00       	call   338 <exit>
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
  d5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  dc:	00 
  dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 95 08 00 00 	movl   $0x895,(%esp)
  ec:	e8 8f 02 00 00       	call   380 <mknod>
    open("console", O_RDWR);
  f1:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  f8:	00 
  f9:	c7 04 24 95 08 00 00 	movl   $0x895,(%esp)
 100:	e8 73 02 00 00       	call   378 <open>
 105:	e9 1c ff ff ff       	jmp    26 <main+0x26>
 10a:	90                   	nop
 10b:	90                   	nop
 10c:	90                   	nop
 10d:	90                   	nop
 10e:	90                   	nop
 10f:	90                   	nop

00000110 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 110:	55                   	push   %ebp
 111:	31 d2                	xor    %edx,%edx
 113:	89 e5                	mov    %esp,%ebp
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	53                   	push   %ebx
 119:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 120:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 124:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 127:	83 c2 01             	add    $0x1,%edx
 12a:	84 c9                	test   %cl,%cl
 12c:	75 f2                	jne    120 <strcpy+0x10>
    ;
  return os;
}
 12e:	5b                   	pop    %ebx
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    
 131:	eb 0d                	jmp    140 <strcmp>
 133:	90                   	nop
 134:	90                   	nop
 135:	90                   	nop
 136:	90                   	nop
 137:	90                   	nop
 138:	90                   	nop
 139:	90                   	nop
 13a:	90                   	nop
 13b:	90                   	nop
 13c:	90                   	nop
 13d:	90                   	nop
 13e:	90                   	nop
 13f:	90                   	nop

00000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 4d 08             	mov    0x8(%ebp),%ecx
 146:	53                   	push   %ebx
 147:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 14a:	0f b6 01             	movzbl (%ecx),%eax
 14d:	84 c0                	test   %al,%al
 14f:	75 14                	jne    165 <strcmp+0x25>
 151:	eb 25                	jmp    178 <strcmp+0x38>
 153:	90                   	nop
 154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 158:	83 c1 01             	add    $0x1,%ecx
 15b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 15e:	0f b6 01             	movzbl (%ecx),%eax
 161:	84 c0                	test   %al,%al
 163:	74 13                	je     178 <strcmp+0x38>
 165:	0f b6 1a             	movzbl (%edx),%ebx
 168:	38 d8                	cmp    %bl,%al
 16a:	74 ec                	je     158 <strcmp+0x18>
 16c:	0f b6 db             	movzbl %bl,%ebx
 16f:	0f b6 c0             	movzbl %al,%eax
 172:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 174:	5b                   	pop    %ebx
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    
 177:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 178:	0f b6 1a             	movzbl (%edx),%ebx
 17b:	31 c0                	xor    %eax,%eax
 17d:	0f b6 db             	movzbl %bl,%ebx
 180:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 182:	5b                   	pop    %ebx
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    
 185:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000190 <strlen>:

uint
strlen(char *s)
{
 190:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 191:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 193:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 195:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 197:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 19a:	80 39 00             	cmpb   $0x0,(%ecx)
 19d:	74 0c                	je     1ab <strlen+0x1b>
 19f:	90                   	nop
 1a0:	83 c2 01             	add    $0x1,%edx
 1a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1a7:	89 d0                	mov    %edx,%eax
 1a9:	75 f5                	jne    1a0 <strlen+0x10>
    ;
  return n;
}
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    
 1ad:	8d 76 00             	lea    0x0(%esi),%esi

000001b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 55 08             	mov    0x8(%ebp),%edx
 1b6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bd:	89 d7                	mov    %edx,%edi
 1bf:	fc                   	cld    
 1c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1c2:	89 d0                	mov    %edx,%eax
 1c4:	5f                   	pop    %edi
 1c5:	5d                   	pop    %ebp
 1c6:	c3                   	ret    
 1c7:	89 f6                	mov    %esi,%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1da:	0f b6 10             	movzbl (%eax),%edx
 1dd:	84 d2                	test   %dl,%dl
 1df:	75 11                	jne    1f2 <strchr+0x22>
 1e1:	eb 15                	jmp    1f8 <strchr+0x28>
 1e3:	90                   	nop
 1e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e8:	83 c0 01             	add    $0x1,%eax
 1eb:	0f b6 10             	movzbl (%eax),%edx
 1ee:	84 d2                	test   %dl,%dl
 1f0:	74 06                	je     1f8 <strchr+0x28>
    if(*s == c)
 1f2:	38 ca                	cmp    %cl,%dl
 1f4:	75 f2                	jne    1e8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1f6:	5d                   	pop    %ebp
 1f7:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f8:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 1fa:	5d                   	pop    %ebp
 1fb:	90                   	nop
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 200:	c3                   	ret    
 201:	eb 0d                	jmp    210 <atoi>
 203:	90                   	nop
 204:	90                   	nop
 205:	90                   	nop
 206:	90                   	nop
 207:	90                   	nop
 208:	90                   	nop
 209:	90                   	nop
 20a:	90                   	nop
 20b:	90                   	nop
 20c:	90                   	nop
 20d:	90                   	nop
 20e:	90                   	nop
 20f:	90                   	nop

00000210 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 210:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 211:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 213:	89 e5                	mov    %esp,%ebp
 215:	8b 4d 08             	mov    0x8(%ebp),%ecx
 218:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 219:	0f b6 11             	movzbl (%ecx),%edx
 21c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 21f:	80 fb 09             	cmp    $0x9,%bl
 222:	77 1c                	ja     240 <atoi+0x30>
 224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 228:	0f be d2             	movsbl %dl,%edx
 22b:	83 c1 01             	add    $0x1,%ecx
 22e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 231:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 235:	0f b6 11             	movzbl (%ecx),%edx
 238:	8d 5a d0             	lea    -0x30(%edx),%ebx
 23b:	80 fb 09             	cmp    $0x9,%bl
 23e:	76 e8                	jbe    228 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 240:	5b                   	pop    %ebx
 241:	5d                   	pop    %ebp
 242:	c3                   	ret    
 243:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000250 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	56                   	push   %esi
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	53                   	push   %ebx
 258:	8b 5d 10             	mov    0x10(%ebp),%ebx
 25b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25e:	85 db                	test   %ebx,%ebx
 260:	7e 14                	jle    276 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 262:	31 d2                	xor    %edx,%edx
 264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 268:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 26c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 26f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 272:	39 da                	cmp    %ebx,%edx
 274:	75 f2                	jne    268 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 276:	5b                   	pop    %ebx
 277:	5e                   	pop    %esi
 278:	5d                   	pop    %ebp
 279:	c3                   	ret    
 27a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000280 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 286:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 289:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 28c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 28f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 294:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 29b:	00 
 29c:	89 04 24             	mov    %eax,(%esp)
 29f:	e8 d4 00 00 00       	call   378 <open>
  if(fd < 0)
 2a4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2a8:	78 19                	js     2c3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	89 1c 24             	mov    %ebx,(%esp)
 2b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b4:	e8 d7 00 00 00       	call   390 <fstat>
  close(fd);
 2b9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2bc:	89 c6                	mov    %eax,%esi
  close(fd);
 2be:	e8 9d 00 00 00       	call   360 <close>
  return r;
}
 2c3:	89 f0                	mov    %esi,%eax
 2c5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2c8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2cb:	89 ec                	mov    %ebp,%esp
 2cd:	5d                   	pop    %ebp
 2ce:	c3                   	ret    
 2cf:	90                   	nop

000002d0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	56                   	push   %esi
 2d5:	31 f6                	xor    %esi,%esi
 2d7:	53                   	push   %ebx
 2d8:	83 ec 2c             	sub    $0x2c,%esp
 2db:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2de:	eb 06                	jmp    2e6 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2e0:	3c 0a                	cmp    $0xa,%al
 2e2:	74 39                	je     31d <gets+0x4d>
 2e4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e6:	8d 5e 01             	lea    0x1(%esi),%ebx
 2e9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2ec:	7d 31                	jge    31f <gets+0x4f>
    cc = read(0, &c, 1);
 2ee:	8d 45 e7             	lea    -0x19(%ebp),%eax
 2f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2f8:	00 
 2f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 304:	e8 47 00 00 00       	call   350 <read>
    if(cc < 1)
 309:	85 c0                	test   %eax,%eax
 30b:	7e 12                	jle    31f <gets+0x4f>
      break;
    buf[i++] = c;
 30d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 311:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 315:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 319:	3c 0d                	cmp    $0xd,%al
 31b:	75 c3                	jne    2e0 <gets+0x10>
 31d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 31f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 323:	89 f8                	mov    %edi,%eax
 325:	83 c4 2c             	add    $0x2c,%esp
 328:	5b                   	pop    %ebx
 329:	5e                   	pop    %esi
 32a:	5f                   	pop    %edi
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
 32d:	90                   	nop
 32e:	90                   	nop
 32f:	90                   	nop

00000330 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 330:	b8 01 00 00 00       	mov    $0x1,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <exit>:
SYSCALL(exit)
 338:	b8 02 00 00 00       	mov    $0x2,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <wait>:
SYSCALL(wait)
 340:	b8 03 00 00 00       	mov    $0x3,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <pipe>:
SYSCALL(pipe)
 348:	b8 04 00 00 00       	mov    $0x4,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <read>:
SYSCALL(read)
 350:	b8 05 00 00 00       	mov    $0x5,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <write>:
SYSCALL(write)
 358:	b8 10 00 00 00       	mov    $0x10,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <close>:
SYSCALL(close)
 360:	b8 15 00 00 00       	mov    $0x15,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <kill>:
SYSCALL(kill)
 368:	b8 06 00 00 00       	mov    $0x6,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <exec>:
SYSCALL(exec)
 370:	b8 07 00 00 00       	mov    $0x7,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <open>:
SYSCALL(open)
 378:	b8 0f 00 00 00       	mov    $0xf,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <mknod>:
SYSCALL(mknod)
 380:	b8 11 00 00 00       	mov    $0x11,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <unlink>:
SYSCALL(unlink)
 388:	b8 12 00 00 00       	mov    $0x12,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <fstat>:
SYSCALL(fstat)
 390:	b8 08 00 00 00       	mov    $0x8,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <link>:
SYSCALL(link)
 398:	b8 13 00 00 00       	mov    $0x13,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <mkdir>:
SYSCALL(mkdir)
 3a0:	b8 14 00 00 00       	mov    $0x14,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <chdir>:
SYSCALL(chdir)
 3a8:	b8 09 00 00 00       	mov    $0x9,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <dup>:
SYSCALL(dup)
 3b0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <getpid>:
SYSCALL(getpid)
 3b8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <sbrk>:
SYSCALL(sbrk)
 3c0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <sleep>:
SYSCALL(sleep)
 3c8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <uptime>:
SYSCALL(uptime)
 3d0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <gettime>:
SYSCALL(gettime)
 3d8:	b8 16 00 00 00       	mov    $0x16,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <shmget>:
SYSCALL(shmget)
 3e0:	b8 17 00 00 00       	mov    $0x17,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    
 3e8:	90                   	nop
 3e9:	90                   	nop
 3ea:	90                   	nop
 3eb:	90                   	nop
 3ec:	90                   	nop
 3ed:	90                   	nop
 3ee:	90                   	nop
 3ef:	90                   	nop

000003f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	89 cf                	mov    %ecx,%edi
 3f6:	56                   	push   %esi
 3f7:	89 c6                	mov    %eax,%esi
 3f9:	53                   	push   %ebx
 3fa:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 400:	85 c9                	test   %ecx,%ecx
 402:	74 04                	je     408 <printint+0x18>
 404:	85 d2                	test   %edx,%edx
 406:	78 68                	js     470 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 408:	89 d0                	mov    %edx,%eax
 40a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 411:	31 c9                	xor    %ecx,%ecx
 413:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 416:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 418:	31 d2                	xor    %edx,%edx
 41a:	f7 f7                	div    %edi
 41c:	0f b6 92 ec 08 00 00 	movzbl 0x8ec(%edx),%edx
 423:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 426:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 429:	85 c0                	test   %eax,%eax
 42b:	75 eb                	jne    418 <printint+0x28>
  if(neg)
 42d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 430:	85 c0                	test   %eax,%eax
 432:	74 08                	je     43c <printint+0x4c>
    buf[i++] = '-';
 434:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 439:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 43c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 43f:	90                   	nop
 440:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
 444:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 447:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 44e:	00 
 44f:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 452:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 455:	8d 45 e7             	lea    -0x19(%ebp),%eax
 458:	89 44 24 04          	mov    %eax,0x4(%esp)
 45c:	e8 f7 fe ff ff       	call   358 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 461:	83 ff ff             	cmp    $0xffffffff,%edi
 464:	75 da                	jne    440 <printint+0x50>
    putc(fd, buf[i]);
}
 466:	83 c4 4c             	add    $0x4c,%esp
 469:	5b                   	pop    %ebx
 46a:	5e                   	pop    %esi
 46b:	5f                   	pop    %edi
 46c:	5d                   	pop    %ebp
 46d:	c3                   	ret    
 46e:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 470:	89 d0                	mov    %edx,%eax
 472:	f7 d8                	neg    %eax
 474:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 47b:	eb 94                	jmp    411 <printint+0x21>
 47d:	8d 76 00             	lea    0x0(%esi),%esi

00000480 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	53                   	push   %ebx
 486:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 489:	8b 45 0c             	mov    0xc(%ebp),%eax
 48c:	0f b6 10             	movzbl (%eax),%edx
 48f:	84 d2                	test   %dl,%dl
 491:	0f 84 c1 00 00 00    	je     558 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 497:	8d 4d 10             	lea    0x10(%ebp),%ecx
 49a:	31 ff                	xor    %edi,%edi
 49c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 49f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4a1:	8d 75 e7             	lea    -0x19(%ebp),%esi
 4a4:	eb 1e                	jmp    4c4 <printf+0x44>
 4a6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4a8:	83 fa 25             	cmp    $0x25,%edx
 4ab:	0f 85 af 00 00 00    	jne    560 <printf+0xe0>
 4b1:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b5:	83 c3 01             	add    $0x1,%ebx
 4b8:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 4bc:	84 d2                	test   %dl,%dl
 4be:	0f 84 94 00 00 00    	je     558 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
 4c4:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4c6:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 4c9:	74 dd                	je     4a8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4cb:	83 ff 25             	cmp    $0x25,%edi
 4ce:	75 e5                	jne    4b5 <printf+0x35>
      if(c == 'd'){
 4d0:	83 fa 64             	cmp    $0x64,%edx
 4d3:	0f 84 3f 01 00 00    	je     618 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4d9:	83 fa 70             	cmp    $0x70,%edx
 4dc:	0f 84 a6 00 00 00    	je     588 <printf+0x108>
 4e2:	83 fa 78             	cmp    $0x78,%edx
 4e5:	0f 84 9d 00 00 00    	je     588 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4eb:	83 fa 73             	cmp    $0x73,%edx
 4ee:	66 90                	xchg   %ax,%ax
 4f0:	0f 84 ba 00 00 00    	je     5b0 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4f6:	83 fa 63             	cmp    $0x63,%edx
 4f9:	0f 84 41 01 00 00    	je     640 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4ff:	83 fa 25             	cmp    $0x25,%edx
 502:	0f 84 00 01 00 00    	je     608 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 508:	8b 4d 08             	mov    0x8(%ebp),%ecx
 50b:	89 55 cc             	mov    %edx,-0x34(%ebp)
 50e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 512:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 519:	00 
 51a:	89 74 24 04          	mov    %esi,0x4(%esp)
 51e:	89 0c 24             	mov    %ecx,(%esp)
 521:	e8 32 fe ff ff       	call   358 <write>
 526:	8b 55 cc             	mov    -0x34(%ebp),%edx
 529:	88 55 e7             	mov    %dl,-0x19(%ebp)
 52c:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 52f:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 532:	31 ff                	xor    %edi,%edi
 534:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 53b:	00 
 53c:	89 74 24 04          	mov    %esi,0x4(%esp)
 540:	89 04 24             	mov    %eax,(%esp)
 543:	e8 10 fe ff ff       	call   358 <write>
 548:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 54b:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 54f:	84 d2                	test   %dl,%dl
 551:	0f 85 6d ff ff ff    	jne    4c4 <printf+0x44>
 557:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 558:	83 c4 3c             	add    $0x3c,%esp
 55b:	5b                   	pop    %ebx
 55c:	5e                   	pop    %esi
 55d:	5f                   	pop    %edi
 55e:	5d                   	pop    %ebp
 55f:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 560:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 563:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 566:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 56d:	00 
 56e:	89 74 24 04          	mov    %esi,0x4(%esp)
 572:	89 04 24             	mov    %eax,(%esp)
 575:	e8 de fd ff ff       	call   358 <write>
 57a:	8b 45 0c             	mov    0xc(%ebp),%eax
 57d:	e9 33 ff ff ff       	jmp    4b5 <printf+0x35>
 582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 58b:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 590:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 592:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 599:	8b 10                	mov    (%eax),%edx
 59b:	8b 45 08             	mov    0x8(%ebp),%eax
 59e:	e8 4d fe ff ff       	call   3f0 <printint>
 5a3:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5a6:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5aa:	e9 06 ff ff ff       	jmp    4b5 <printf+0x35>
 5af:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 5b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 5b3:	b9 e5 08 00 00       	mov    $0x8e5,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 5b8:	8b 3a                	mov    (%edx),%edi
        ap++;
 5ba:	83 c2 04             	add    $0x4,%edx
 5bd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 5c0:	85 ff                	test   %edi,%edi
 5c2:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 5c5:	0f b6 17             	movzbl (%edi),%edx
 5c8:	84 d2                	test   %dl,%dl
 5ca:	74 33                	je     5ff <printf+0x17f>
 5cc:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 5d8:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5db:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5de:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5e5:	00 
 5e6:	89 74 24 04          	mov    %esi,0x4(%esp)
 5ea:	89 1c 24             	mov    %ebx,(%esp)
 5ed:	e8 66 fd ff ff       	call   358 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f2:	0f b6 17             	movzbl (%edi),%edx
 5f5:	84 d2                	test   %dl,%dl
 5f7:	75 df                	jne    5d8 <printf+0x158>
 5f9:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5fc:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ff:	31 ff                	xor    %edi,%edi
 601:	e9 af fe ff ff       	jmp    4b5 <printf+0x35>
 606:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 608:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 60c:	e9 1b ff ff ff       	jmp    52c <printf+0xac>
 611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 618:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 61b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 620:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 623:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 62a:	8b 10                	mov    (%eax),%edx
 62c:	8b 45 08             	mov    0x8(%ebp),%eax
 62f:	e8 bc fd ff ff       	call   3f0 <printint>
 634:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 637:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 63b:	e9 75 fe ff ff       	jmp    4b5 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 640:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 643:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 645:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 648:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 64a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 651:	00 
 652:	89 74 24 04          	mov    %esi,0x4(%esp)
 656:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 659:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 65c:	e8 f7 fc ff ff       	call   358 <write>
 661:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 664:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 668:	e9 48 fe ff ff       	jmp    4b5 <printf+0x35>
 66d:	90                   	nop
 66e:	90                   	nop
 66f:	90                   	nop

00000670 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 670:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 671:	a1 10 09 00 00       	mov    0x910,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 676:	89 e5                	mov    %esp,%ebp
 678:	57                   	push   %edi
 679:	56                   	push   %esi
 67a:	53                   	push   %ebx
 67b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 681:	39 c8                	cmp    %ecx,%eax
 683:	73 1d                	jae    6a2 <free+0x32>
 685:	8d 76 00             	lea    0x0(%esi),%esi
 688:	8b 10                	mov    (%eax),%edx
 68a:	39 d1                	cmp    %edx,%ecx
 68c:	72 1a                	jb     6a8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68e:	39 d0                	cmp    %edx,%eax
 690:	72 08                	jb     69a <free+0x2a>
 692:	39 c8                	cmp    %ecx,%eax
 694:	72 12                	jb     6a8 <free+0x38>
 696:	39 d1                	cmp    %edx,%ecx
 698:	72 0e                	jb     6a8 <free+0x38>
 69a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69c:	39 c8                	cmp    %ecx,%eax
 69e:	66 90                	xchg   %ax,%ax
 6a0:	72 e6                	jb     688 <free+0x18>
 6a2:	8b 10                	mov    (%eax),%edx
 6a4:	eb e8                	jmp    68e <free+0x1e>
 6a6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a8:	8b 71 04             	mov    0x4(%ecx),%esi
 6ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ae:	39 d7                	cmp    %edx,%edi
 6b0:	74 19                	je     6cb <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6b2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6b5:	8b 50 04             	mov    0x4(%eax),%edx
 6b8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6bb:	39 ce                	cmp    %ecx,%esi
 6bd:	74 23                	je     6e2 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6bf:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6c1:	a3 10 09 00 00       	mov    %eax,0x910
}
 6c6:	5b                   	pop    %ebx
 6c7:	5e                   	pop    %esi
 6c8:	5f                   	pop    %edi
 6c9:	5d                   	pop    %ebp
 6ca:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6cb:	03 72 04             	add    0x4(%edx),%esi
 6ce:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d1:	8b 10                	mov    (%eax),%edx
 6d3:	8b 12                	mov    (%edx),%edx
 6d5:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6d8:	8b 50 04             	mov    0x4(%eax),%edx
 6db:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6de:	39 ce                	cmp    %ecx,%esi
 6e0:	75 dd                	jne    6bf <free+0x4f>
    p->s.size += bp->s.size;
 6e2:	03 51 04             	add    0x4(%ecx),%edx
 6e5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6eb:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 6ed:	a3 10 09 00 00       	mov    %eax,0x910
}
 6f2:	5b                   	pop    %ebx
 6f3:	5e                   	pop    %esi
 6f4:	5f                   	pop    %edi
 6f5:	5d                   	pop    %ebp
 6f6:	c3                   	ret    
 6f7:	89 f6                	mov    %esi,%esi
 6f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000700 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	57                   	push   %edi
 704:	56                   	push   %esi
 705:	53                   	push   %ebx
 706:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 709:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 70c:	8b 0d 10 09 00 00    	mov    0x910,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 712:	83 c3 07             	add    $0x7,%ebx
 715:	c1 eb 03             	shr    $0x3,%ebx
 718:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 71b:	85 c9                	test   %ecx,%ecx
 71d:	0f 84 9b 00 00 00    	je     7be <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 723:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 725:	8b 50 04             	mov    0x4(%eax),%edx
 728:	39 d3                	cmp    %edx,%ebx
 72a:	76 27                	jbe    753 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 72c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 733:	be 00 80 00 00       	mov    $0x8000,%esi
 738:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 73b:	90                   	nop
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 740:	3b 05 10 09 00 00    	cmp    0x910,%eax
 746:	74 30                	je     778 <malloc+0x78>
 748:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74a:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 74c:	8b 50 04             	mov    0x4(%eax),%edx
 74f:	39 d3                	cmp    %edx,%ebx
 751:	77 ed                	ja     740 <malloc+0x40>
      if(p->s.size == nunits)
 753:	39 d3                	cmp    %edx,%ebx
 755:	74 61                	je     7b8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 757:	29 da                	sub    %ebx,%edx
 759:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 75c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 75f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 762:	89 0d 10 09 00 00    	mov    %ecx,0x910
      return (void*)(p + 1);
 768:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 76b:	83 c4 2c             	add    $0x2c,%esp
 76e:	5b                   	pop    %ebx
 76f:	5e                   	pop    %esi
 770:	5f                   	pop    %edi
 771:	5d                   	pop    %ebp
 772:	c3                   	ret    
 773:	90                   	nop
 774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 77b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 781:	bf 00 10 00 00       	mov    $0x1000,%edi
 786:	0f 43 fb             	cmovae %ebx,%edi
 789:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 78c:	89 04 24             	mov    %eax,(%esp)
 78f:	e8 2c fc ff ff       	call   3c0 <sbrk>
  if(p == (char*)-1)
 794:	83 f8 ff             	cmp    $0xffffffff,%eax
 797:	74 18                	je     7b1 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 799:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 79c:	83 c0 08             	add    $0x8,%eax
 79f:	89 04 24             	mov    %eax,(%esp)
 7a2:	e8 c9 fe ff ff       	call   670 <free>
  return freep;
 7a7:	8b 0d 10 09 00 00    	mov    0x910,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 7ad:	85 c9                	test   %ecx,%ecx
 7af:	75 99                	jne    74a <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7b1:	31 c0                	xor    %eax,%eax
 7b3:	eb b6                	jmp    76b <malloc+0x6b>
 7b5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7b8:	8b 10                	mov    (%eax),%edx
 7ba:	89 11                	mov    %edx,(%ecx)
 7bc:	eb a4                	jmp    762 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7be:	c7 05 10 09 00 00 08 	movl   $0x908,0x910
 7c5:	09 00 00 
    base.s.size = 0;
 7c8:	b9 08 09 00 00       	mov    $0x908,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7cd:	c7 05 08 09 00 00 08 	movl   $0x908,0x908
 7d4:	09 00 00 
    base.s.size = 0;
 7d7:	c7 05 0c 09 00 00 00 	movl   $0x0,0x90c
 7de:	00 00 00 
 7e1:	e9 3d ff ff ff       	jmp    723 <malloc+0x23>
 7e6:	90                   	nop
 7e7:	90                   	nop
 7e8:	90                   	nop
 7e9:	90                   	nop
 7ea:	90                   	nop
 7eb:	90                   	nop
 7ec:	90                   	nop
 7ed:	90                   	nop
 7ee:	90                   	nop
 7ef:	90                   	nop

000007f0 <ring_attach>:
#include "ring.h"

struct ring *ring_attach(uint token)
{
 7f0:	55                   	push   %ebp
  return 0;
}
 7f1:	31 c0                	xor    %eax,%eax
#include "ring.h"

struct ring *ring_attach(uint token)
{
 7f3:	89 e5                	mov    %esp,%ebp
  return 0;
}
 7f5:	5d                   	pop    %ebp
 7f6:	c3                   	ret    
 7f7:	89 f6                	mov    %esi,%esi
 7f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000800 <ring_size>:

int ring_size(uint token)
{
 800:	55                   	push   %ebp
  return 0;
}
 801:	31 c0                	xor    %eax,%eax
{
  return 0;
}

int ring_size(uint token)
{
 803:	89 e5                	mov    %esp,%ebp
  return 0;
}
 805:	5d                   	pop    %ebp
 806:	c3                   	ret    
 807:	89 f6                	mov    %esi,%esi
 809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000810 <ring_detach>:

int ring_detach(uint token)
{
 810:	55                   	push   %ebp
  return 0;
}
 811:	31 c0                	xor    %eax,%eax
{
  return 0;
}

int ring_detach(uint token)
{
 813:	89 e5                	mov    %esp,%ebp
  return 0;
}
 815:	5d                   	pop    %ebp
 816:	c3                   	ret    
 817:	89 f6                	mov    %esi,%esi
 819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000820 <ring_write_reserve>:

struct ring_res ring_write_reserve(struct ring *r, int bytes)
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	8b 45 08             	mov    0x8(%ebp),%eax
  struct ring_res ret = {0, 0};
  return ret;
 826:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 82d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 833:	5d                   	pop    %ebp
 834:	c2 04 00             	ret    $0x4
 837:	89 f6                	mov    %esi,%esi
 839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000840 <ring_write_notify>:

void ring_write_notify(struct ring *r, int bytes)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp

}
 843:	5d                   	pop    %ebp
 844:	c3                   	ret    
 845:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000850 <ring_read_reserve>:

struct ring_res ring_read_reserve(struct ring *r, int bytes)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	8b 45 08             	mov    0x8(%ebp),%eax
  struct ring_res ret = {0, 0};
  return ret;
 856:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 85d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 863:	5d                   	pop    %ebp
 864:	c2 04 00             	ret    $0x4
 867:	89 f6                	mov    %esi,%esi
 869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000870 <ring_read_notify>:

void ring_read_notify(struct ring *r, int bytes)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp

}
 873:	5d                   	pop    %ebp
 874:	c3                   	ret    
 875:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000880 <ring_write>:

void ring_write(struct ring *r, void *buf, int bytes)
{
 880:	55                   	push   %ebp
 881:	89 e5                	mov    %esp,%ebp

}
 883:	5d                   	pop    %ebp
 884:	c3                   	ret    
 885:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000890 <ring_read>:

void ring_read(struct ring *r, void *buf, int bytes)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp

}
 893:	5d                   	pop    %ebp
 894:	c3                   	ret    
