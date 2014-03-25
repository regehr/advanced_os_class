
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
   d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 e8             	mov    %eax,-0x18(%ebp)
  inword = 0;
  19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 66                	jmp    88 <wc+0x88>
    for(i=0; i<n; i++){
  22:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  29:	eb 55                	jmp    80 <wc+0x80>
      c++;
  2b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  32:	0f b6 80 e0 09 00 00 	movzbl 0x9e0(%eax),%eax
  39:	3c 0a                	cmp    $0xa,%al
  3b:	75 04                	jne    41 <wc+0x41>
        l++;
  3d:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  44:	0f b6 80 e0 09 00 00 	movzbl 0x9e0(%eax),%eax
  4b:	0f be c0             	movsbl %al,%eax
  4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  52:	c7 04 24 67 09 00 00 	movl   $0x967,(%esp)
  59:	e8 48 02 00 00       	call   2a6 <strchr>
  5e:	85 c0                	test   %eax,%eax
  60:	74 09                	je     6b <wc+0x6b>
        inword = 0;
  62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  69:	eb 11                	jmp    7c <wc+0x7c>
      else if(!inword){
  6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  6f:	75 0b                	jne    7c <wc+0x7c>
        w++;
  71:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  75:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  83:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  86:	7c a3                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  88:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8f:	00 
  90:	c7 44 24 04 e0 09 00 	movl   $0x9e0,0x4(%esp)
  97:	00 
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	89 04 24             	mov    %eax,(%esp)
  9e:	e8 9d 03 00 00       	call   440 <read>
  a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  b4:	79 19                	jns    cf <wc+0xcf>
    printf(1, "wc: read error\n");
  b6:	c7 44 24 04 6d 09 00 	movl   $0x96d,0x4(%esp)
  bd:	00 
  be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c5:	e8 d7 04 00 00       	call   5a1 <printf>
    exit();
  ca:	e8 59 03 00 00       	call   428 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  d2:	89 44 24 14          	mov    %eax,0x14(%esp)
  d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  eb:	c7 44 24 04 7d 09 00 	movl   $0x97d,0x4(%esp)
  f2:	00 
  f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fa:	e8 a2 04 00 00       	call   5a1 <printf>
}
  ff:	c9                   	leave  
 100:	c3                   	ret    

00000101 <main>:

int
main(int argc, char *argv[])
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 e4 f0             	and    $0xfffffff0,%esp
 107:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 10a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 10e:	7f 19                	jg     129 <main+0x28>
    wc(0, "");
 110:	c7 44 24 04 8a 09 00 	movl   $0x98a,0x4(%esp)
 117:	00 
 118:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11f:	e8 dc fe ff ff       	call   0 <wc>
    exit();
 124:	e8 ff 02 00 00       	call   428 <exit>
  }

  for(i = 1; i < argc; i++){
 129:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 130:	00 
 131:	eb 7d                	jmp    1b0 <main+0xaf>
    if((fd = open(argv[i], 0)) < 0){
 133:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 137:	c1 e0 02             	shl    $0x2,%eax
 13a:	03 45 0c             	add    0xc(%ebp),%eax
 13d:	8b 00                	mov    (%eax),%eax
 13f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 146:	00 
 147:	89 04 24             	mov    %eax,(%esp)
 14a:	e8 19 03 00 00       	call   468 <open>
 14f:	89 44 24 18          	mov    %eax,0x18(%esp)
 153:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 158:	79 29                	jns    183 <main+0x82>
      printf(1, "wc: cannot open %s\n", argv[i]);
 15a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 15e:	c1 e0 02             	shl    $0x2,%eax
 161:	03 45 0c             	add    0xc(%ebp),%eax
 164:	8b 00                	mov    (%eax),%eax
 166:	89 44 24 08          	mov    %eax,0x8(%esp)
 16a:	c7 44 24 04 8b 09 00 	movl   $0x98b,0x4(%esp)
 171:	00 
 172:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 179:	e8 23 04 00 00       	call   5a1 <printf>
      exit();
 17e:	e8 a5 02 00 00       	call   428 <exit>
    }
    wc(fd, argv[i]);
 183:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 187:	c1 e0 02             	shl    $0x2,%eax
 18a:	03 45 0c             	add    0xc(%ebp),%eax
 18d:	8b 00                	mov    (%eax),%eax
 18f:	89 44 24 04          	mov    %eax,0x4(%esp)
 193:	8b 44 24 18          	mov    0x18(%esp),%eax
 197:	89 04 24             	mov    %eax,(%esp)
 19a:	e8 61 fe ff ff       	call   0 <wc>
    close(fd);
 19f:	8b 44 24 18          	mov    0x18(%esp),%eax
 1a3:	89 04 24             	mov    %eax,(%esp)
 1a6:	e8 a5 02 00 00       	call   450 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1ab:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1b0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1b4:	3b 45 08             	cmp    0x8(%ebp),%eax
 1b7:	0f 8c 76 ff ff ff    	jl     133 <main+0x32>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1bd:	e8 66 02 00 00       	call   428 <exit>
 1c2:	90                   	nop
 1c3:	90                   	nop

000001c4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
 1c8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1cc:	8b 55 10             	mov    0x10(%ebp),%edx
 1cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d2:	89 cb                	mov    %ecx,%ebx
 1d4:	89 df                	mov    %ebx,%edi
 1d6:	89 d1                	mov    %edx,%ecx
 1d8:	fc                   	cld    
 1d9:	f3 aa                	rep stos %al,%es:(%edi)
 1db:	89 ca                	mov    %ecx,%edx
 1dd:	89 fb                	mov    %edi,%ebx
 1df:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1e2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1e5:	5b                   	pop    %ebx
 1e6:	5f                   	pop    %edi
 1e7:	5d                   	pop    %ebp
 1e8:	c3                   	ret    

000001e9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f8:	0f b6 10             	movzbl (%eax),%edx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	88 10                	mov    %dl,(%eax)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	84 c0                	test   %al,%al
 208:	0f 95 c0             	setne  %al
 20b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 20f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 213:	84 c0                	test   %al,%al
 215:	75 de                	jne    1f5 <strcpy+0xc>
    ;
  return os;
 217:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21a:	c9                   	leave  
 21b:	c3                   	ret    

0000021c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 21f:	eb 08                	jmp    229 <strcmp+0xd>
    p++, q++;
 221:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 225:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	84 c0                	test   %al,%al
 231:	74 10                	je     243 <strcmp+0x27>
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	0f b6 10             	movzbl (%eax),%edx
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	0f b6 00             	movzbl (%eax),%eax
 23f:	38 c2                	cmp    %al,%dl
 241:	74 de                	je     221 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 d0             	movzbl %al,%edx
 24c:	8b 45 0c             	mov    0xc(%ebp),%eax
 24f:	0f b6 00             	movzbl (%eax),%eax
 252:	0f b6 c0             	movzbl %al,%eax
 255:	89 d1                	mov    %edx,%ecx
 257:	29 c1                	sub    %eax,%ecx
 259:	89 c8                	mov    %ecx,%eax
}
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    

0000025d <strlen>:

uint
strlen(char *s)
{
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 26a:	eb 04                	jmp    270 <strlen+0x13>
 26c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 270:	8b 45 fc             	mov    -0x4(%ebp),%eax
 273:	03 45 08             	add    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	84 c0                	test   %al,%al
 27b:	75 ef                	jne    26c <strlen+0xf>
    ;
  return n;
 27d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 280:	c9                   	leave  
 281:	c3                   	ret    

00000282 <memset>:

void*
memset(void *dst, int c, uint n)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 288:	8b 45 10             	mov    0x10(%ebp),%eax
 28b:	89 44 24 08          	mov    %eax,0x8(%esp)
 28f:	8b 45 0c             	mov    0xc(%ebp),%eax
 292:	89 44 24 04          	mov    %eax,0x4(%esp)
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	89 04 24             	mov    %eax,(%esp)
 29c:	e8 23 ff ff ff       	call   1c4 <stosb>
  return dst;
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a4:	c9                   	leave  
 2a5:	c3                   	ret    

000002a6 <strchr>:

char*
strchr(const char *s, char c)
{
 2a6:	55                   	push   %ebp
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	83 ec 04             	sub    $0x4,%esp
 2ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 2af:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2b2:	eb 14                	jmp    2c8 <strchr+0x22>
    if(*s == c)
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	0f b6 00             	movzbl (%eax),%eax
 2ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2bd:	75 05                	jne    2c4 <strchr+0x1e>
      return (char*)s;
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	eb 13                	jmp    2d7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	0f b6 00             	movzbl (%eax),%eax
 2ce:	84 c0                	test   %al,%al
 2d0:	75 e2                	jne    2b4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d7:	c9                   	leave  
 2d8:	c3                   	ret    

000002d9 <gets>:

char*
gets(char *buf, int max)
{
 2d9:	55                   	push   %ebp
 2da:	89 e5                	mov    %esp,%ebp
 2dc:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 2e6:	eb 44                	jmp    32c <gets+0x53>
    cc = read(0, &c, 1);
 2e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2ef:	00 
 2f0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2fe:	e8 3d 01 00 00       	call   440 <read>
 303:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 306:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 30a:	7e 2d                	jle    339 <gets+0x60>
      break;
    buf[i++] = c;
 30c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 30f:	03 45 08             	add    0x8(%ebp),%eax
 312:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 316:	88 10                	mov    %dl,(%eax)
 318:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 31c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 320:	3c 0a                	cmp    $0xa,%al
 322:	74 16                	je     33a <gets+0x61>
 324:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 328:	3c 0d                	cmp    $0xd,%al
 32a:	74 0e                	je     33a <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 32f:	83 c0 01             	add    $0x1,%eax
 332:	3b 45 0c             	cmp    0xc(%ebp),%eax
 335:	7c b1                	jl     2e8 <gets+0xf>
 337:	eb 01                	jmp    33a <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 339:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 33a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 33d:	03 45 08             	add    0x8(%ebp),%eax
 340:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 343:	8b 45 08             	mov    0x8(%ebp),%eax
}
 346:	c9                   	leave  
 347:	c3                   	ret    

00000348 <stat>:

int
stat(char *n, struct stat *st)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 34e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 355:	00 
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	89 04 24             	mov    %eax,(%esp)
 35c:	e8 07 01 00 00       	call   468 <open>
 361:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 364:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 368:	79 07                	jns    371 <stat+0x29>
    return -1;
 36a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 36f:	eb 23                	jmp    394 <stat+0x4c>
  r = fstat(fd, st);
 371:	8b 45 0c             	mov    0xc(%ebp),%eax
 374:	89 44 24 04          	mov    %eax,0x4(%esp)
 378:	8b 45 f0             	mov    -0x10(%ebp),%eax
 37b:	89 04 24             	mov    %eax,(%esp)
 37e:	e8 fd 00 00 00       	call   480 <fstat>
 383:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 386:	8b 45 f0             	mov    -0x10(%ebp),%eax
 389:	89 04 24             	mov    %eax,(%esp)
 38c:	e8 bf 00 00 00       	call   450 <close>
  return r;
 391:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 394:	c9                   	leave  
 395:	c3                   	ret    

00000396 <atoi>:

int
atoi(const char *s)
{
 396:	55                   	push   %ebp
 397:	89 e5                	mov    %esp,%ebp
 399:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 39c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3a3:	eb 24                	jmp    3c9 <atoi+0x33>
    n = n*10 + *s++ - '0';
 3a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a8:	89 d0                	mov    %edx,%eax
 3aa:	c1 e0 02             	shl    $0x2,%eax
 3ad:	01 d0                	add    %edx,%eax
 3af:	01 c0                	add    %eax,%eax
 3b1:	89 c2                	mov    %eax,%edx
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	0f be c0             	movsbl %al,%eax
 3bc:	8d 04 02             	lea    (%edx,%eax,1),%eax
 3bf:	83 e8 30             	sub    $0x30,%eax
 3c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	3c 2f                	cmp    $0x2f,%al
 3d1:	7e 0a                	jle    3dd <atoi+0x47>
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	3c 39                	cmp    $0x39,%al
 3db:	7e c8                	jle    3a5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e0:	c9                   	leave  
 3e1:	c3                   	ret    

000003e2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3e2:	55                   	push   %ebp
 3e3:	89 e5                	mov    %esp,%ebp
 3e5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 3f4:	eb 13                	jmp    409 <memmove+0x27>
    *dst++ = *src++;
 3f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3f9:	0f b6 10             	movzbl (%eax),%edx
 3fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ff:	88 10                	mov    %dl,(%eax)
 401:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 405:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 409:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 40d:	0f 9f c0             	setg   %al
 410:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 414:	84 c0                	test   %al,%al
 416:	75 de                	jne    3f6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 418:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41b:	c9                   	leave  
 41c:	c3                   	ret    
 41d:	90                   	nop
 41e:	90                   	nop
 41f:	90                   	nop

00000420 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 420:	b8 01 00 00 00       	mov    $0x1,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <exit>:
SYSCALL(exit)
 428:	b8 02 00 00 00       	mov    $0x2,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <wait>:
SYSCALL(wait)
 430:	b8 03 00 00 00       	mov    $0x3,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <pipe>:
SYSCALL(pipe)
 438:	b8 04 00 00 00       	mov    $0x4,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <read>:
SYSCALL(read)
 440:	b8 05 00 00 00       	mov    $0x5,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <write>:
SYSCALL(write)
 448:	b8 10 00 00 00       	mov    $0x10,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <close>:
SYSCALL(close)
 450:	b8 15 00 00 00       	mov    $0x15,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <kill>:
SYSCALL(kill)
 458:	b8 06 00 00 00       	mov    $0x6,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <exec>:
SYSCALL(exec)
 460:	b8 07 00 00 00       	mov    $0x7,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <open>:
SYSCALL(open)
 468:	b8 0f 00 00 00       	mov    $0xf,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <mknod>:
SYSCALL(mknod)
 470:	b8 11 00 00 00       	mov    $0x11,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <unlink>:
SYSCALL(unlink)
 478:	b8 12 00 00 00       	mov    $0x12,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <fstat>:
SYSCALL(fstat)
 480:	b8 08 00 00 00       	mov    $0x8,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <link>:
SYSCALL(link)
 488:	b8 13 00 00 00       	mov    $0x13,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <mkdir>:
SYSCALL(mkdir)
 490:	b8 14 00 00 00       	mov    $0x14,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <chdir>:
SYSCALL(chdir)
 498:	b8 09 00 00 00       	mov    $0x9,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <dup>:
SYSCALL(dup)
 4a0:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <getpid>:
SYSCALL(getpid)
 4a8:	b8 0b 00 00 00       	mov    $0xb,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <sbrk>:
SYSCALL(sbrk)
 4b0:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <sleep>:
SYSCALL(sleep)
 4b8:	b8 0d 00 00 00       	mov    $0xd,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <uptime>:
SYSCALL(uptime)
 4c0:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c8:	55                   	push   %ebp
 4c9:	89 e5                	mov    %esp,%ebp
 4cb:	83 ec 28             	sub    $0x28,%esp
 4ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4db:	00 
 4dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4df:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	89 04 24             	mov    %eax,(%esp)
 4e9:	e8 5a ff ff ff       	call   448 <write>
}
 4ee:	c9                   	leave  
 4ef:	c3                   	ret    

000004f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	53                   	push   %ebx
 4f4:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4fe:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 502:	74 17                	je     51b <printint+0x2b>
 504:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 508:	79 11                	jns    51b <printint+0x2b>
    neg = 1;
 50a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 511:	8b 45 0c             	mov    0xc(%ebp),%eax
 514:	f7 d8                	neg    %eax
 516:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 519:	eb 06                	jmp    521 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 51b:	8b 45 0c             	mov    0xc(%ebp),%eax
 51e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 521:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 528:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 52b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 52e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 531:	ba 00 00 00 00       	mov    $0x0,%edx
 536:	f7 f3                	div    %ebx
 538:	89 d0                	mov    %edx,%eax
 53a:	0f b6 80 a8 09 00 00 	movzbl 0x9a8(%eax),%eax
 541:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 545:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 549:	8b 45 10             	mov    0x10(%ebp),%eax
 54c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 54f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 552:	ba 00 00 00 00       	mov    $0x0,%edx
 557:	f7 75 d4             	divl   -0x2c(%ebp)
 55a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 55d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 561:	75 c5                	jne    528 <printint+0x38>
  if(neg)
 563:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 567:	74 28                	je     591 <printint+0xa1>
    buf[i++] = '-';
 569:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 571:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 575:	eb 1a                	jmp    591 <printint+0xa1>
    putc(fd, buf[i]);
 577:	8b 45 ec             	mov    -0x14(%ebp),%eax
 57a:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 57f:	0f be c0             	movsbl %al,%eax
 582:	89 44 24 04          	mov    %eax,0x4(%esp)
 586:	8b 45 08             	mov    0x8(%ebp),%eax
 589:	89 04 24             	mov    %eax,(%esp)
 58c:	e8 37 ff ff ff       	call   4c8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 591:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 595:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 599:	79 dc                	jns    577 <printint+0x87>
    putc(fd, buf[i]);
}
 59b:	83 c4 44             	add    $0x44,%esp
 59e:	5b                   	pop    %ebx
 59f:	5d                   	pop    %ebp
 5a0:	c3                   	ret    

000005a1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a1:	55                   	push   %ebp
 5a2:	89 e5                	mov    %esp,%ebp
 5a4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ae:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b1:	83 c0 04             	add    $0x4,%eax
 5b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 5b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 5be:	e9 7e 01 00 00       	jmp    741 <printf+0x1a0>
    c = fmt[i] & 0xff;
 5c3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c9:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5cc:	0f b6 00             	movzbl (%eax),%eax
 5cf:	0f be c0             	movsbl %al,%eax
 5d2:	25 ff 00 00 00       	and    $0xff,%eax
 5d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 5da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5de:	75 2c                	jne    60c <printf+0x6b>
      if(c == '%'){
 5e0:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5e4:	75 0c                	jne    5f2 <printf+0x51>
        state = '%';
 5e6:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 5ed:	e9 4b 01 00 00       	jmp    73d <printf+0x19c>
      } else {
        putc(fd, c);
 5f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f5:	0f be c0             	movsbl %al,%eax
 5f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fc:	8b 45 08             	mov    0x8(%ebp),%eax
 5ff:	89 04 24             	mov    %eax,(%esp)
 602:	e8 c1 fe ff ff       	call   4c8 <putc>
 607:	e9 31 01 00 00       	jmp    73d <printf+0x19c>
      }
    } else if(state == '%'){
 60c:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 610:	0f 85 27 01 00 00    	jne    73d <printf+0x19c>
      if(c == 'd'){
 616:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 61a:	75 2d                	jne    649 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 61c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 628:	00 
 629:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 630:	00 
 631:	89 44 24 04          	mov    %eax,0x4(%esp)
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	89 04 24             	mov    %eax,(%esp)
 63b:	e8 b0 fe ff ff       	call   4f0 <printint>
        ap++;
 640:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 644:	e9 ed 00 00 00       	jmp    736 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 649:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 64d:	74 06                	je     655 <printf+0xb4>
 64f:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 653:	75 2d                	jne    682 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 655:	8b 45 f4             	mov    -0xc(%ebp),%eax
 658:	8b 00                	mov    (%eax),%eax
 65a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 661:	00 
 662:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 669:	00 
 66a:	89 44 24 04          	mov    %eax,0x4(%esp)
 66e:	8b 45 08             	mov    0x8(%ebp),%eax
 671:	89 04 24             	mov    %eax,(%esp)
 674:	e8 77 fe ff ff       	call   4f0 <printint>
        ap++;
 679:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 67d:	e9 b4 00 00 00       	jmp    736 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 682:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 686:	75 46                	jne    6ce <printf+0x12d>
        s = (char*)*ap;
 688:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 690:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 694:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 698:	75 27                	jne    6c1 <printf+0x120>
          s = "(null)";
 69a:	c7 45 e4 9f 09 00 00 	movl   $0x99f,-0x1c(%ebp)
        while(*s != 0){
 6a1:	eb 1f                	jmp    6c2 <printf+0x121>
          putc(fd, *s);
 6a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a6:	0f b6 00             	movzbl (%eax),%eax
 6a9:	0f be c0             	movsbl %al,%eax
 6ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b0:	8b 45 08             	mov    0x8(%ebp),%eax
 6b3:	89 04 24             	mov    %eax,(%esp)
 6b6:	e8 0d fe ff ff       	call   4c8 <putc>
          s++;
 6bb:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 6bf:	eb 01                	jmp    6c2 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c1:	90                   	nop
 6c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c5:	0f b6 00             	movzbl (%eax),%eax
 6c8:	84 c0                	test   %al,%al
 6ca:	75 d7                	jne    6a3 <printf+0x102>
 6cc:	eb 68                	jmp    736 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ce:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 6d2:	75 1d                	jne    6f1 <printf+0x150>
        putc(fd, *ap);
 6d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	0f be c0             	movsbl %al,%eax
 6dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e0:	8b 45 08             	mov    0x8(%ebp),%eax
 6e3:	89 04 24             	mov    %eax,(%esp)
 6e6:	e8 dd fd ff ff       	call   4c8 <putc>
        ap++;
 6eb:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 6ef:	eb 45                	jmp    736 <printf+0x195>
      } else if(c == '%'){
 6f1:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 6f5:	75 17                	jne    70e <printf+0x16d>
        putc(fd, c);
 6f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fa:	0f be c0             	movsbl %al,%eax
 6fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 701:	8b 45 08             	mov    0x8(%ebp),%eax
 704:	89 04 24             	mov    %eax,(%esp)
 707:	e8 bc fd ff ff       	call   4c8 <putc>
 70c:	eb 28                	jmp    736 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 70e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 715:	00 
 716:	8b 45 08             	mov    0x8(%ebp),%eax
 719:	89 04 24             	mov    %eax,(%esp)
 71c:	e8 a7 fd ff ff       	call   4c8 <putc>
        putc(fd, c);
 721:	8b 45 e8             	mov    -0x18(%ebp),%eax
 724:	0f be c0             	movsbl %al,%eax
 727:	89 44 24 04          	mov    %eax,0x4(%esp)
 72b:	8b 45 08             	mov    0x8(%ebp),%eax
 72e:	89 04 24             	mov    %eax,(%esp)
 731:	e8 92 fd ff ff       	call   4c8 <putc>
      }
      state = 0;
 736:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 73d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 741:	8b 55 0c             	mov    0xc(%ebp),%edx
 744:	8b 45 ec             	mov    -0x14(%ebp),%eax
 747:	8d 04 02             	lea    (%edx,%eax,1),%eax
 74a:	0f b6 00             	movzbl (%eax),%eax
 74d:	84 c0                	test   %al,%al
 74f:	0f 85 6e fe ff ff    	jne    5c3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 755:	c9                   	leave  
 756:	c3                   	ret    
 757:	90                   	nop

00000758 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75e:	8b 45 08             	mov    0x8(%ebp),%eax
 761:	83 e8 08             	sub    $0x8,%eax
 764:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 767:	a1 c8 09 00 00       	mov    0x9c8,%eax
 76c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76f:	eb 24                	jmp    795 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 779:	77 12                	ja     78d <free+0x35>
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 781:	77 24                	ja     7a7 <free+0x4f>
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78b:	77 1a                	ja     7a7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	8b 00                	mov    (%eax),%eax
 792:	89 45 fc             	mov    %eax,-0x4(%ebp)
 795:	8b 45 f8             	mov    -0x8(%ebp),%eax
 798:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79b:	76 d4                	jbe    771 <free+0x19>
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 00                	mov    (%eax),%eax
 7a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a5:	76 ca                	jbe    771 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	c1 e0 03             	shl    $0x3,%eax
 7b0:	89 c2                	mov    %eax,%edx
 7b2:	03 55 f8             	add    -0x8(%ebp),%edx
 7b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b8:	8b 00                	mov    (%eax),%eax
 7ba:	39 c2                	cmp    %eax,%edx
 7bc:	75 24                	jne    7e2 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	8b 50 04             	mov    0x4(%eax),%edx
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	8b 00                	mov    (%eax),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	01 c2                	add    %eax,%edx
 7ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	8b 10                	mov    (%eax),%edx
 7db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7de:	89 10                	mov    %edx,(%eax)
 7e0:	eb 0a                	jmp    7ec <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	8b 10                	mov    (%eax),%edx
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ef:	8b 40 04             	mov    0x4(%eax),%eax
 7f2:	c1 e0 03             	shl    $0x3,%eax
 7f5:	03 45 fc             	add    -0x4(%ebp),%eax
 7f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fb:	75 20                	jne    81d <free+0xc5>
    p->s.size += bp->s.size;
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	8b 50 04             	mov    0x4(%eax),%edx
 803:	8b 45 f8             	mov    -0x8(%ebp),%eax
 806:	8b 40 04             	mov    0x4(%eax),%eax
 809:	01 c2                	add    %eax,%edx
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 811:	8b 45 f8             	mov    -0x8(%ebp),%eax
 814:	8b 10                	mov    (%eax),%edx
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	89 10                	mov    %edx,(%eax)
 81b:	eb 08                	jmp    825 <free+0xcd>
  } else
    p->s.ptr = bp;
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	8b 55 f8             	mov    -0x8(%ebp),%edx
 823:	89 10                	mov    %edx,(%eax)
  freep = p;
 825:	8b 45 fc             	mov    -0x4(%ebp),%eax
 828:	a3 c8 09 00 00       	mov    %eax,0x9c8
}
 82d:	c9                   	leave  
 82e:	c3                   	ret    

0000082f <morecore>:

static Header*
morecore(uint nu)
{
 82f:	55                   	push   %ebp
 830:	89 e5                	mov    %esp,%ebp
 832:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 835:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 83c:	77 07                	ja     845 <morecore+0x16>
    nu = 4096;
 83e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 845:	8b 45 08             	mov    0x8(%ebp),%eax
 848:	c1 e0 03             	shl    $0x3,%eax
 84b:	89 04 24             	mov    %eax,(%esp)
 84e:	e8 5d fc ff ff       	call   4b0 <sbrk>
 853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 856:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 85a:	75 07                	jne    863 <morecore+0x34>
    return 0;
 85c:	b8 00 00 00 00       	mov    $0x0,%eax
 861:	eb 22                	jmp    885 <morecore+0x56>
  hp = (Header*)p;
 863:	8b 45 f0             	mov    -0x10(%ebp),%eax
 866:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8b 55 08             	mov    0x8(%ebp),%edx
 86f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	83 c0 08             	add    $0x8,%eax
 878:	89 04 24             	mov    %eax,(%esp)
 87b:	e8 d8 fe ff ff       	call   758 <free>
  return freep;
 880:	a1 c8 09 00 00       	mov    0x9c8,%eax
}
 885:	c9                   	leave  
 886:	c3                   	ret    

00000887 <malloc>:

void*
malloc(uint nbytes)
{
 887:	55                   	push   %ebp
 888:	89 e5                	mov    %esp,%ebp
 88a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88d:	8b 45 08             	mov    0x8(%ebp),%eax
 890:	83 c0 07             	add    $0x7,%eax
 893:	c1 e8 03             	shr    $0x3,%eax
 896:	83 c0 01             	add    $0x1,%eax
 899:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 89c:	a1 c8 09 00 00       	mov    0x9c8,%eax
 8a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8a8:	75 23                	jne    8cd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8aa:	c7 45 f0 c0 09 00 00 	movl   $0x9c0,-0x10(%ebp)
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	a3 c8 09 00 00       	mov    %eax,0x9c8
 8b9:	a1 c8 09 00 00       	mov    0x9c8,%eax
 8be:	a3 c0 09 00 00       	mov    %eax,0x9c0
    base.s.size = 0;
 8c3:	c7 05 c4 09 00 00 00 	movl   $0x0,0x9c4
 8ca:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d0:	8b 00                	mov    (%eax),%eax
 8d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 8d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8d8:	8b 40 04             	mov    0x4(%eax),%eax
 8db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8de:	72 4d                	jb     92d <malloc+0xa6>
      if(p->s.size == nunits)
 8e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8e3:	8b 40 04             	mov    0x4(%eax),%eax
 8e6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8e9:	75 0c                	jne    8f7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ee:	8b 10                	mov    (%eax),%edx
 8f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f3:	89 10                	mov    %edx,(%eax)
 8f5:	eb 26                	jmp    91d <malloc+0x96>
      else {
        p->s.size -= nunits;
 8f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8fa:	8b 40 04             	mov    0x4(%eax),%eax
 8fd:	89 c2                	mov    %eax,%edx
 8ff:	2b 55 f4             	sub    -0xc(%ebp),%edx
 902:	8b 45 ec             	mov    -0x14(%ebp),%eax
 905:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 908:	8b 45 ec             	mov    -0x14(%ebp),%eax
 90b:	8b 40 04             	mov    0x4(%eax),%eax
 90e:	c1 e0 03             	shl    $0x3,%eax
 911:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 914:	8b 45 ec             	mov    -0x14(%ebp),%eax
 917:	8b 55 f4             	mov    -0xc(%ebp),%edx
 91a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 91d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 920:	a3 c8 09 00 00       	mov    %eax,0x9c8
      return (void*)(p + 1);
 925:	8b 45 ec             	mov    -0x14(%ebp),%eax
 928:	83 c0 08             	add    $0x8,%eax
 92b:	eb 38                	jmp    965 <malloc+0xde>
    }
    if(p == freep)
 92d:	a1 c8 09 00 00       	mov    0x9c8,%eax
 932:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 935:	75 1b                	jne    952 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 937:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93a:	89 04 24             	mov    %eax,(%esp)
 93d:	e8 ed fe ff ff       	call   82f <morecore>
 942:	89 45 ec             	mov    %eax,-0x14(%ebp)
 945:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 949:	75 07                	jne    952 <malloc+0xcb>
        return 0;
 94b:	b8 00 00 00 00       	mov    $0x0,%eax
 950:	eb 13                	jmp    965 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 952:	8b 45 ec             	mov    -0x14(%ebp),%eax
 955:	89 45 f0             	mov    %eax,-0x10(%ebp)
 958:	8b 45 ec             	mov    -0x14(%ebp),%eax
 95b:	8b 00                	mov    (%eax),%eax
 95d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 960:	e9 70 ff ff ff       	jmp    8d5 <malloc+0x4e>
}
 965:	c9                   	leave  
 966:	c3                   	ret    
