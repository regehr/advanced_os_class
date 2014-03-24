
_pipetest:     file format elf32-i386


Disassembly of section .text:

00000000 <_lrand48>:
  xseed[1] = temp[1];
  xseed[2] = (unsigned short) accu;
}

int _lrand48(struct _rand48_state *s)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 10             	sub    $0x10,%esp
   6:	8b 55 08             	mov    0x8(%ebp),%edx
   9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
   c:	89 7d fc             	mov    %edi,-0x4(%ebp)
   f:	89 75 f8             	mov    %esi,-0x8(%ebp)

static void _dorand48 (unsigned short *xseed)
{
  unsigned int accu;
  unsigned short temp[2];
  accu = (unsigned int) _rand48_mult[0] * (unsigned int) xseed[0] + (unsigned int) _rand48_add;
  12:	0f b7 0a             	movzwl (%edx),%ecx
  temp[0] = (unsigned short) accu;
  accu >>= sizeof(unsigned short) * 8;
  accu += 
    (unsigned int) _rand48_mult[0] * (unsigned int) xseed[1] + 
  15:	0f b7 72 02          	movzwl 0x2(%edx),%esi

static void _dorand48 (unsigned short *xseed)
{
  unsigned int accu;
  unsigned short temp[2];
  accu = (unsigned int) _rand48_mult[0] * (unsigned int) xseed[0] + (unsigned int) _rand48_add;
  19:	69 c1 6d e6 00 00    	imul   $0xe66d,%ecx,%eax
  temp[0] = (unsigned short) accu;
  accu >>= sizeof(unsigned short) * 8;
  accu += 
    (unsigned int) _rand48_mult[0] * (unsigned int) xseed[1] + 
  1f:	69 de 6d e6 00 00    	imul   $0xe66d,%esi,%ebx
    (unsigned int) _rand48_mult[1] * (unsigned int) xseed[0];
  temp[1] = (unsigned short) accu;
  accu >>= sizeof(unsigned short) * 8;
  accu += 
  25:	69 f6 ec de 00 00    	imul   $0xdeec,%esi,%esi

static void _dorand48 (unsigned short *xseed)
{
  unsigned int accu;
  unsigned short temp[2];
  accu = (unsigned int) _rand48_mult[0] * (unsigned int) xseed[0] + (unsigned int) _rand48_add;
  2b:	83 c0 0b             	add    $0xb,%eax
  temp[0] = (unsigned short) accu;
  accu >>= sizeof(unsigned short) * 8;
  accu += 
    (unsigned int) _rand48_mult[0] * (unsigned int) xseed[1] + 
  2e:	89 c7                	mov    %eax,%edi
  30:	c1 ef 10             	shr    $0x10,%edi
  33:	8d 1c 1f             	lea    (%edi,%ebx,1),%ebx
  unsigned int accu;
  unsigned short temp[2];
  accu = (unsigned int) _rand48_mult[0] * (unsigned int) xseed[0] + (unsigned int) _rand48_add;
  temp[0] = (unsigned short) accu;
  accu >>= sizeof(unsigned short) * 8;
  accu += 
  36:	69 f9 ec de 00 00    	imul   $0xdeec,%ecx,%edi
  3c:	01 fb                	add    %edi,%ebx
    (unsigned int) _rand48_mult[0] * (unsigned int) xseed[1] + 
    (unsigned int) _rand48_mult[1] * (unsigned int) xseed[0];
  temp[1] = (unsigned short) accu;
  accu >>= sizeof(unsigned short) * 8;
  3e:	89 df                	mov    %ebx,%edi
  40:	c1 ef 10             	shr    $0x10,%edi
  43:	89 7d f0             	mov    %edi,-0x10(%ebp)
  accu += 
  46:	0f b7 7a 04          	movzwl 0x4(%edx),%edi
  4a:	69 ff 6d e6 00 00    	imul   $0xe66d,%edi,%edi
  50:	8d 34 37             	lea    (%edi,%esi,1),%esi
  53:	8d 3c 89             	lea    (%ecx,%ecx,4),%edi
  56:	01 fe                	add    %edi,%esi
  58:	03 75 f0             	add    -0x10(%ebp),%esi
    (unsigned int) _rand48_mult[0] * xseed[2] + 
    (unsigned int) _rand48_mult[1] * xseed[1] + 
    (unsigned int) _rand48_mult[2] * xseed[0];
  xseed[0] = temp[0];
  xseed[1] = temp[1];
  5b:	66 89 5a 02          	mov    %bx,0x2(%edx)
  xseed[2] = (unsigned short) accu;
  5f:	66 d1 eb             	shr    %bx
  accu >>= sizeof(unsigned short) * 8;
  accu += 
    (unsigned int) _rand48_mult[0] * xseed[2] + 
    (unsigned int) _rand48_mult[1] * xseed[1] + 
    (unsigned int) _rand48_mult[2] * xseed[0];
  xseed[0] = temp[0];
  62:	66 89 02             	mov    %ax,(%edx)
  xseed[1] = temp[1];
  xseed[2] = (unsigned short) accu;
  65:	0f b7 c3             	movzwl %bx,%eax
  68:	66 89 72 04          	mov    %si,0x4(%edx)
  6c:	0f b7 f6             	movzwl %si,%esi
int _lrand48(struct _rand48_state *s)
{
  unsigned short *_rand48_seed = &(s->seed[0]);
  _dorand48(_rand48_seed);
  return ((int) _rand48_seed[2] << 15) + ((int) _rand48_seed[1] >> 1);
}
  6f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    (unsigned int) _rand48_mult[0] * xseed[2] + 
    (unsigned int) _rand48_mult[1] * xseed[1] + 
    (unsigned int) _rand48_mult[2] * xseed[0];
  xseed[0] = temp[0];
  xseed[1] = temp[1];
  xseed[2] = (unsigned short) accu;
  72:	c1 e6 0f             	shl    $0xf,%esi
int _lrand48(struct _rand48_state *s)
{
  unsigned short *_rand48_seed = &(s->seed[0]);
  _dorand48(_rand48_seed);
  return ((int) _rand48_seed[2] << 15) + ((int) _rand48_seed[1] >> 1);
}
  75:	8b 7d fc             	mov    -0x4(%ebp),%edi
    (unsigned int) _rand48_mult[0] * xseed[2] + 
    (unsigned int) _rand48_mult[1] * xseed[1] + 
    (unsigned int) _rand48_mult[2] * xseed[0];
  xseed[0] = temp[0];
  xseed[1] = temp[1];
  xseed[2] = (unsigned short) accu;
  78:	8d 04 06             	lea    (%esi,%eax,1),%eax
int _lrand48(struct _rand48_state *s)
{
  unsigned short *_rand48_seed = &(s->seed[0]);
  _dorand48(_rand48_seed);
  return ((int) _rand48_seed[2] << 15) + ((int) _rand48_seed[1] >> 1);
}
  7b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  7e:	89 ec                	mov    %ebp,%esp
  80:	5d                   	pop    %ebp
  81:	c3                   	ret    
  82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000090 <_srand48>:

void _srand48(struct _rand48_state *s, int seed)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  s->seed[0] = seed;
  96:	8b 55 0c             	mov    0xc(%ebp),%edx
  s->seed[1] = 0;
  99:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  return ((int) _rand48_seed[2] << 15) + ((int) _rand48_seed[1] >> 1);
}

void _srand48(struct _rand48_state *s, int seed)
{
  s->seed[0] = seed;
  9f:	66 89 10             	mov    %dx,(%eax)
  s->seed[1] = 0;
  s->seed[2] = 0;
  a2:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
}
  a8:	5d                   	pop    %ebp
  a9:	c3                   	ret    
  aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000000b0 <get_ms>:
#define Exit(x) exit()
#define Printf(x,fmt,...) printf(x,fmt,__VA_ARGS__)
#define Wait() wait()

static unsigned long get_ms (void)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	83 ec 28             	sub    $0x28,%esp
  unsigned long msec;
  unsigned long sec; 
  if(gettime(&msec,&sec)<0){
  b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  c0:	89 04 24             	mov    %eax,(%esp)
  c3:	e8 80 06 00 00       	call   748 <gettime>
  c8:	85 c0                	test   %eax,%eax
  ca:	78 0c                	js     d8 <get_ms+0x28>
    printf(1,"Error on gettime");
    exit();
  cc:	69 45 f0 e8 03 00 00 	imul   $0x3e8,-0x10(%ebp),%eax
  d3:	03 45 f4             	add    -0xc(%ebp),%eax
  }
  long t = (sec * 1000) + msec;
  return t;
}
  d6:	c9                   	leave  
  d7:	c3                   	ret    
static unsigned long get_ms (void)
{
  unsigned long msec;
  unsigned long sec; 
  if(gettime(&msec,&sec)<0){
    printf(1,"Error on gettime");
  d8:	c7 44 24 04 58 0b 00 	movl   $0xb58,0x4(%esp)
  df:	00 
  e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e7:	e8 04 07 00 00       	call   7f0 <printf>
    exit();
  ec:	e8 b7 05 00 00       	call   6a8 <exit>
  f1:	eb 0d                	jmp    100 <AssertionFailure.clone.0>
  f3:	90                   	nop
  f4:	90                   	nop
  f5:	90                   	nop
  f6:	90                   	nop
  f7:	90                   	nop
  f8:	90                   	nop
  f9:	90                   	nop
  fa:	90                   	nop
  fb:	90                   	nop
  fc:	90                   	nop
  fd:	90                   	nop
  fe:	90                   	nop
  ff:	90                   	nop

00000100 <AssertionFailure.clone.0>:
  return t;
}

#endif

static void AssertionFailure(char *exp, char *file, int line)
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	83 ec 28             	sub    $0x28,%esp
{
  Printf (1, "Assertion '%s' failed at line %d of file %s\n", exp, line, file);
 106:	89 54 24 0c          	mov    %edx,0xc(%esp)
 10a:	89 44 24 08          	mov    %eax,0x8(%esp)
 10e:	c7 44 24 10 69 0b 00 	movl   $0xb69,0x10(%esp)
 115:	00 
 116:	c7 44 24 04 e8 0b 00 	movl   $0xbe8,0x4(%esp)
 11d:	00 
 11e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 125:	e8 c6 06 00 00       	call   7f0 <printf>
  Exit(-1);
 12a:	e8 79 05 00 00       	call   6a8 <exit>
 12f:	90                   	nop

00000130 <main>:
  } while (bytes_wrote < BYTES);
  Printf (1, "%d bytes written in %d calls to write()\n", bytes_wrote, writes);
}

int main (void)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	83 e4 f0             	and    $0xfffffff0,%esp
 136:	57                   	push   %edi
 137:	56                   	push   %esi
 138:	53                   	push   %ebx
 139:	83 ec 34             	sub    $0x34,%esp
#ifdef CHECK
  _srand48(&s, getpid());
 13c:	e8 e7 05 00 00       	call   728 <getpid>
}

void _srand48(struct _rand48_state *s, int seed)
{
  s->seed[0] = seed;
  s->seed[1] = 0;
 141:	66 c7 05 a2 2c 00 00 	movw   $0x0,0x2ca2
 148:	00 00 
  s->seed[2] = 0;
 14a:	66 c7 05 a4 2c 00 00 	movw   $0x0,0x2ca4
 151:	00 00 
  return ((int) _rand48_seed[2] << 15) + ((int) _rand48_seed[1] >> 1);
}

void _srand48(struct _rand48_state *s, int seed)
{
  s->seed[0] = seed;
 153:	66 a3 a0 2c 00 00    	mov    %ax,0x2ca0
  _srand48(&s2, getpid()+77);
 159:	e8 ca 05 00 00       	call   728 <getpid>
  s->seed[1] = 0;
 15e:	66 c7 05 a8 2c 00 00 	movw   $0x0,0x2ca8
 165:	00 00 
  s->seed[2] = 0;
 167:	66 c7 05 aa 2c 00 00 	movw   $0x0,0x2caa
 16e:	00 00 
  Printf (1, "running in checked mode\n%s", "");
 170:	c7 44 24 08 e7 0b 00 	movl   $0xbe7,0x8(%esp)
 177:	00 
 178:	c7 44 24 04 74 0b 00 	movl   $0xb74,0x4(%esp)
 17f:	00 
 180:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  return ((int) _rand48_seed[2] << 15) + ((int) _rand48_seed[1] >> 1);
}

void _srand48(struct _rand48_state *s, int seed)
{
  s->seed[0] = seed;
 187:	83 c0 4d             	add    $0x4d,%eax
 18a:	66 a3 a6 2c 00 00    	mov    %ax,0x2ca6
 190:	e8 5b 06 00 00       	call   7f0 <printf>
#endif

  long start = get_ms();
 195:	e8 16 ff ff ff       	call   b0 <get_ms>
 19a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  int pipefd[2];
  int res = pipe (pipefd);
 19e:	8d 44 24 28          	lea    0x28(%esp),%eax
 1a2:	89 04 24             	mov    %eax,(%esp)
 1a5:	e8 0e 05 00 00       	call   6b8 <pipe>
  Assert (res==0);
 1aa:	85 c0                	test   %eax,%eax
 1ac:	0f 85 1e 02 00 00    	jne    3d0 <main+0x2a0>
  int pid = fork();
 1b2:	e8 e9 04 00 00       	call   6a0 <fork>
  Assert (pid >= 0);
 1b7:	83 f8 00             	cmp    $0x0,%eax
 1ba:	0f 8c c6 00 00 00    	jl     286 <main+0x156>
  if (pid == 0) {
 1c0:	0f 85 cf 00 00 00    	jne    295 <main+0x165>
    int res = close(pipefd[1]);
 1c6:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 1ca:	89 04 24             	mov    %eax,(%esp)
 1cd:	e8 fe 04 00 00       	call   6d0 <close>
    Assert (res == 0);
 1d2:	85 c0                	test   %eax,%eax
 1d4:	0f 85 1b 02 00 00    	jne    3f5 <main+0x2c5>
    reader(pipefd[0]);
 1da:	8b 44 24 28          	mov    0x28(%esp),%eax
 1de:	31 ff                	xor    %edi,%edi
 1e0:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 1e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

static int reads, writes;

static int _read (int fd, unsigned char *buf, int len)
{
  reads++;
 1e8:	83 05 ac 2c 00 00 01 	addl   $0x1,0x2cac
#ifdef CHECK
  len = (_lrand48(&s2)%len) + 1;
 1ef:	c7 04 24 a6 2c 00 00 	movl   $0x2ca6,(%esp)
 1f6:	e8 05 fe ff ff       	call   0 <_lrand48>
#endif
  return read (fd, buf, len);
 1fb:	c7 44 24 04 a0 0c 00 	movl   $0xca0,0x4(%esp)
 202:	00 
 203:	89 c2                	mov    %eax,%edx
 205:	c1 fa 1f             	sar    $0x1f,%edx
 208:	c1 ea 13             	shr    $0x13,%edx
 20b:	01 d0                	add    %edx,%eax
 20d:	25 ff 1f 00 00       	and    $0x1fff,%eax
 212:	29 d0                	sub    %edx,%eax
 214:	83 c0 01             	add    $0x1,%eax
 217:	89 44 24 08          	mov    %eax,0x8(%esp)
 21b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 21f:	89 04 24             	mov    %eax,(%esp)
 222:	e8 99 04 00 00       	call   6c0 <read>
{
  int bytes_read = 0;
  int z;
  do {
    z = _read (fd, buf, BLOCK_SIZE);
    Assert (z != -1);      
 227:	83 f8 ff             	cmp    $0xffffffff,%eax
{
  reads++;
#ifdef CHECK
  len = (_lrand48(&s2)%len) + 1;
#endif
  return read (fd, buf, len);
 22a:	89 c6                	mov    %eax,%esi
{
  int bytes_read = 0;
  int z;
  do {
    z = _read (fd, buf, BLOCK_SIZE);
    Assert (z != -1);      
 22c:	74 41                	je     26f <main+0x13f>
    bytes_read += z;
 22e:	01 c7                	add    %eax,%edi
#ifdef CHECK
    {
      int i;
      for (i=0; i<z; i++) {
 230:	83 f8 00             	cmp    $0x0,%eax
 233:	0f 8e f8 01 00 00    	jle    431 <main+0x301>
 239:	31 db                	xor    %ebx,%ebx
 23b:	90                   	nop
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	unsigned char expect = _lrand48(&s);
 240:	c7 04 24 a0 2c 00 00 	movl   $0x2ca0,(%esp)
 247:	e8 b4 fd ff ff       	call   0 <_lrand48>
	Assert (buf[i] == expect);
 24c:	38 83 a0 0c 00 00    	cmp    %al,0xca0(%ebx)
 252:	74 0f                	je     263 <main+0x133>
 254:	ba 6a 00 00 00       	mov    $0x6a,%edx
 259:	b8 b0 0b 00 00       	mov    $0xbb0,%eax
 25e:	e8 9d fe ff ff       	call   100 <AssertionFailure.clone.0>
    Assert (z != -1);      
    bytes_read += z;
#ifdef CHECK
    {
      int i;
      for (i=0; i<z; i++) {
 263:	83 c3 01             	add    $0x1,%ebx
 266:	39 de                	cmp    %ebx,%esi
 268:	7f d6                	jg     240 <main+0x110>
 26a:	e9 79 ff ff ff       	jmp    1e8 <main+0xb8>
{
  int bytes_read = 0;
  int z;
  do {
    z = _read (fd, buf, BLOCK_SIZE);
    Assert (z != -1);      
 26f:	ba 63 00 00 00       	mov    $0x63,%edx
 274:	b8 a8 0b 00 00       	mov    $0xba8,%eax
 279:	e8 82 fe ff ff       	call   100 <AssertionFailure.clone.0>
    bytes_read += z;
 27e:	83 ef 01             	sub    $0x1,%edi
 281:	e9 62 ff ff ff       	jmp    1e8 <main+0xb8>
  long start = get_ms();
  int pipefd[2];
  int res = pipe (pipefd);
  Assert (res==0);
  int pid = fork();
  Assert (pid >= 0);
 286:	ba 9d 00 00 00       	mov    $0x9d,%edx
 28b:	b8 96 0b 00 00       	mov    $0xb96,%eax
 290:	e8 6b fe ff ff       	call   100 <AssertionFailure.clone.0>
    reader(pipefd[0]);
    res = close(pipefd[0]);
    Assert (res == 0);
    Exit (0);
  } else {
    int res = close(pipefd[0]);
 295:	8b 44 24 28          	mov    0x28(%esp),%eax
 299:	89 04 24             	mov    %eax,(%esp)
 29c:	e8 2f 04 00 00       	call   6d0 <close>
    Assert (res == 0);
 2a1:	85 c0                	test   %eax,%eax
 2a3:	0f 85 60 01 00 00    	jne    409 <main+0x2d9>
    writer(pipefd[1]);
 2a9:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
 2ad:	bb 00 20 00 00       	mov    $0x2000,%ebx
 2b2:	31 f6                	xor    %esi,%esi
 2b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2b8:	31 d2                	xor    %edx,%edx
 2ba:	eb 1f                	jmp    2db <main+0x1ab>
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#ifdef CHECK
    {
      int i;
      for (i=0; i<BLOCK_SIZE; i++) {	
	if (last_pos < BLOCK_SIZE) {
	  buf[i] = buf[last_pos];
 2c0:	0f b6 83 a0 0c 00 00 	movzbl 0xca0(%ebx),%eax
	  last_pos++;
 2c7:	83 c3 01             	add    $0x1,%ebx
#ifdef CHECK
    {
      int i;
      for (i=0; i<BLOCK_SIZE; i++) {	
	if (last_pos < BLOCK_SIZE) {
	  buf[i] = buf[last_pos];
 2ca:	88 82 a0 0c 00 00    	mov    %al,0xca0(%edx)
#endif
  do {
#ifdef CHECK
    {
      int i;
      for (i=0; i<BLOCK_SIZE; i++) {	
 2d0:	83 c2 01             	add    $0x1,%edx
 2d3:	81 fa 00 20 00 00    	cmp    $0x2000,%edx
 2d9:	74 2d                	je     308 <main+0x1d8>
	if (last_pos < BLOCK_SIZE) {
 2db:	81 fb ff 1f 00 00    	cmp    $0x1fff,%ebx
 2e1:	7e dd                	jle    2c0 <main+0x190>
	  buf[i] = buf[last_pos];
	  last_pos++;
	} else {
	  buf[i] = _lrand48(&s);
 2e3:	89 54 24 18          	mov    %edx,0x18(%esp)
 2e7:	c7 04 24 a0 2c 00 00 	movl   $0x2ca0,(%esp)
 2ee:	e8 0d fd ff ff       	call   0 <_lrand48>
 2f3:	8b 54 24 18          	mov    0x18(%esp),%edx
 2f7:	88 82 a0 0c 00 00    	mov    %al,0xca0(%edx)
#endif
  do {
#ifdef CHECK
    {
      int i;
      for (i=0; i<BLOCK_SIZE; i++) {	
 2fd:	83 c2 01             	add    $0x1,%edx
 300:	81 fa 00 20 00 00    	cmp    $0x2000,%edx
 306:	75 d3                	jne    2db <main+0x1ab>
  return read (fd, buf, len);
}

static int _write (int fd, unsigned char *buf, int len)
{
  writes++;
 308:	83 05 b0 2c 00 00 01 	addl   $0x1,0x2cb0
#ifdef CHECK
  len = (_lrand48(&s2)%len) + 1;
 30f:	c7 04 24 a6 2c 00 00 	movl   $0x2ca6,(%esp)
 316:	e8 e5 fc ff ff       	call   0 <_lrand48>
#endif
  return write (fd, buf, len);
 31b:	c7 44 24 04 a0 0c 00 	movl   $0xca0,0x4(%esp)
 322:	00 
 323:	89 3c 24             	mov    %edi,(%esp)
 326:	89 c2                	mov    %eax,%edx
 328:	c1 fa 1f             	sar    $0x1f,%edx
 32b:	c1 ea 13             	shr    $0x13,%edx
 32e:	01 d0                	add    %edx,%eax
 330:	25 ff 1f 00 00       	and    $0x1fff,%eax
 335:	29 d0                	sub    %edx,%eax
 337:	83 c0 01             	add    $0x1,%eax
 33a:	89 44 24 08          	mov    %eax,0x8(%esp)
 33e:	e8 85 03 00 00       	call   6c8 <write>
	}
      }
    }
#endif
    int z = _write (fd, buf, BLOCK_SIZE);
    Assert (z != 0);
 343:	85 c0                	test   %eax,%eax
{
  writes++;
#ifdef CHECK
  len = (_lrand48(&s2)%len) + 1;
#endif
  return write (fd, buf, len);
 345:	89 c3                	mov    %eax,%ebx
	}
      }
    }
#endif
    int z = _write (fd, buf, BLOCK_SIZE);
    Assert (z != 0);
 347:	74 73                	je     3bc <main+0x28c>
#ifdef CHECK
    last_pos = z;
#endif
    bytes_wrote += z;
 349:	01 de                	add    %ebx,%esi
  } while (bytes_wrote < BYTES);
 34b:	81 fe ff c9 9a 3b    	cmp    $0x3b9ac9ff,%esi
 351:	0f 8e 61 ff ff ff    	jle    2b8 <main+0x188>
  Printf (1, "%d bytes written in %d calls to write()\n", bytes_wrote, writes);
 357:	a1 b0 2c 00 00       	mov    0x2cb0,%eax
 35c:	89 74 24 08          	mov    %esi,0x8(%esp)
 360:	c7 44 24 04 40 0c 00 	movl   $0xc40,0x4(%esp)
 367:	00 
 368:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 36f:	89 44 24 0c          	mov    %eax,0xc(%esp)
 373:	e8 78 04 00 00       	call   7f0 <printf>
    Exit (0);
  } else {
    int res = close(pipefd[0]);
    Assert (res == 0);
    writer(pipefd[1]);
    res = close(pipefd[1]);
 378:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 37c:	89 04 24             	mov    %eax,(%esp)
 37f:	e8 4c 03 00 00       	call   6d0 <close>
    Assert (res == 0);
 384:	85 c0                	test   %eax,%eax
 386:	75 5c                	jne    3e4 <main+0x2b4>
    res = Wait();
 388:	e8 23 03 00 00       	call   6b0 <wait>
    Assert (res != -1);
 38d:	83 f8 ff             	cmp    $0xffffffff,%eax
 390:	0f 84 87 00 00 00    	je     41d <main+0x2ed>
  }
  long duration = get_ms() - start;
 396:	e8 15 fd ff ff       	call   b0 <get_ms>
  Printf (1, "elapsed time = %d ms\n", (int)duration);
 39b:	c7 44 24 04 d2 0b 00 	movl   $0xbd2,0x4(%esp)
 3a2:	00 
 3a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3aa:	2b 44 24 1c          	sub    0x1c(%esp),%eax
 3ae:	89 44 24 08          	mov    %eax,0x8(%esp)
 3b2:	e8 39 04 00 00       	call   7f0 <printf>

  Exit(0);
 3b7:	e8 ec 02 00 00       	call   6a8 <exit>
	}
      }
    }
#endif
    int z = _write (fd, buf, BLOCK_SIZE);
    Assert (z != 0);
 3bc:	ba 87 00 00 00       	mov    $0x87,%edx
 3c1:	b8 c1 0b 00 00       	mov    $0xbc1,%eax
 3c6:	e8 35 fd ff ff       	call   100 <AssertionFailure.clone.0>
 3cb:	e9 79 ff ff ff       	jmp    349 <main+0x219>
#endif

  long start = get_ms();
  int pipefd[2];
  int res = pipe (pipefd);
  Assert (res==0);
 3d0:	ba 9b 00 00 00       	mov    $0x9b,%edx
 3d5:	b8 8f 0b 00 00       	mov    $0xb8f,%eax
 3da:	e8 21 fd ff ff       	call   100 <AssertionFailure.clone.0>
 3df:	e9 ce fd ff ff       	jmp    1b2 <main+0x82>
  } else {
    int res = close(pipefd[0]);
    Assert (res == 0);
    writer(pipefd[1]);
    res = close(pipefd[1]);
    Assert (res == 0);
 3e4:	ba aa 00 00 00       	mov    $0xaa,%edx
 3e9:	b8 9f 0b 00 00       	mov    $0xb9f,%eax
 3ee:	e8 0d fd ff ff       	call   100 <AssertionFailure.clone.0>
 3f3:	eb 93                	jmp    388 <main+0x258>
  Assert (res==0);
  int pid = fork();
  Assert (pid >= 0);
  if (pid == 0) {
    int res = close(pipefd[1]);
    Assert (res == 0);
 3f5:	ba a0 00 00 00       	mov    $0xa0,%edx
 3fa:	b8 9f 0b 00 00       	mov    $0xb9f,%eax
 3ff:	e8 fc fc ff ff       	call   100 <AssertionFailure.clone.0>
 404:	e9 d1 fd ff ff       	jmp    1da <main+0xaa>
    res = close(pipefd[0]);
    Assert (res == 0);
    Exit (0);
  } else {
    int res = close(pipefd[0]);
    Assert (res == 0);
 409:	ba a7 00 00 00       	mov    $0xa7,%edx
 40e:	b8 9f 0b 00 00       	mov    $0xb9f,%eax
 413:	e8 e8 fc ff ff       	call   100 <AssertionFailure.clone.0>
 418:	e9 8c fe ff ff       	jmp    2a9 <main+0x179>
    writer(pipefd[1]);
    res = close(pipefd[1]);
    Assert (res == 0);
    res = Wait();
    Assert (res != -1);
 41d:	ba ac 00 00 00       	mov    $0xac,%edx
 422:	b8 c8 0b 00 00       	mov    $0xbc8,%eax
 427:	e8 d4 fc ff ff       	call   100 <AssertionFailure.clone.0>
 42c:	e9 65 ff ff ff       	jmp    396 <main+0x266>
	unsigned char expect = _lrand48(&s);
	Assert (buf[i] == expect);
      }
    }
#endif
  } while (z != 0);
 431:	0f 85 b1 fd ff ff    	jne    1e8 <main+0xb8>
  Printf (1, "%d bytes read in %d calls to read()\n", bytes_read, reads);
 437:	a1 ac 2c 00 00       	mov    0x2cac,%eax
 43c:	89 7c 24 08          	mov    %edi,0x8(%esp)
 440:	c7 44 24 04 18 0c 00 	movl   $0xc18,0x4(%esp)
 447:	00 
 448:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 44f:	89 44 24 0c          	mov    %eax,0xc(%esp)
 453:	e8 98 03 00 00       	call   7f0 <printf>
  Assert (pid >= 0);
  if (pid == 0) {
    int res = close(pipefd[1]);
    Assert (res == 0);
    reader(pipefd[0]);
    res = close(pipefd[0]);
 458:	8b 44 24 28          	mov    0x28(%esp),%eax
 45c:	89 04 24             	mov    %eax,(%esp)
 45f:	e8 6c 02 00 00       	call   6d0 <close>
    Assert (res == 0);
 464:	85 c0                	test   %eax,%eax
 466:	0f 84 4b ff ff ff    	je     3b7 <main+0x287>
 46c:	ba a3 00 00 00       	mov    $0xa3,%edx
 471:	b8 9f 0b 00 00       	mov    $0xb9f,%eax
 476:	e8 85 fc ff ff       	call   100 <AssertionFailure.clone.0>
 47b:	e9 37 ff ff ff       	jmp    3b7 <main+0x287>

00000480 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 480:	55                   	push   %ebp
 481:	31 d2                	xor    %edx,%edx
 483:	89 e5                	mov    %esp,%ebp
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	53                   	push   %ebx
 489:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 490:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 494:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 497:	83 c2 01             	add    $0x1,%edx
 49a:	84 c9                	test   %cl,%cl
 49c:	75 f2                	jne    490 <strcpy+0x10>
    ;
  return os;
}
 49e:	5b                   	pop    %ebx
 49f:	5d                   	pop    %ebp
 4a0:	c3                   	ret    
 4a1:	eb 0d                	jmp    4b0 <strcmp>
 4a3:	90                   	nop
 4a4:	90                   	nop
 4a5:	90                   	nop
 4a6:	90                   	nop
 4a7:	90                   	nop
 4a8:	90                   	nop
 4a9:	90                   	nop
 4aa:	90                   	nop
 4ab:	90                   	nop
 4ac:	90                   	nop
 4ad:	90                   	nop
 4ae:	90                   	nop
 4af:	90                   	nop

000004b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4b6:	53                   	push   %ebx
 4b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 4ba:	0f b6 01             	movzbl (%ecx),%eax
 4bd:	84 c0                	test   %al,%al
 4bf:	75 14                	jne    4d5 <strcmp+0x25>
 4c1:	eb 25                	jmp    4e8 <strcmp+0x38>
 4c3:	90                   	nop
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 4c8:	83 c1 01             	add    $0x1,%ecx
 4cb:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 4ce:	0f b6 01             	movzbl (%ecx),%eax
 4d1:	84 c0                	test   %al,%al
 4d3:	74 13                	je     4e8 <strcmp+0x38>
 4d5:	0f b6 1a             	movzbl (%edx),%ebx
 4d8:	38 d8                	cmp    %bl,%al
 4da:	74 ec                	je     4c8 <strcmp+0x18>
 4dc:	0f b6 db             	movzbl %bl,%ebx
 4df:	0f b6 c0             	movzbl %al,%eax
 4e2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 4e4:	5b                   	pop    %ebx
 4e5:	5d                   	pop    %ebp
 4e6:	c3                   	ret    
 4e7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 4e8:	0f b6 1a             	movzbl (%edx),%ebx
 4eb:	31 c0                	xor    %eax,%eax
 4ed:	0f b6 db             	movzbl %bl,%ebx
 4f0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 4f2:	5b                   	pop    %ebx
 4f3:	5d                   	pop    %ebp
 4f4:	c3                   	ret    
 4f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000500 <strlen>:

uint
strlen(char *s)
{
 500:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 501:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 503:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 505:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 507:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 50a:	80 39 00             	cmpb   $0x0,(%ecx)
 50d:	74 0c                	je     51b <strlen+0x1b>
 50f:	90                   	nop
 510:	83 c2 01             	add    $0x1,%edx
 513:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 517:	89 d0                	mov    %edx,%eax
 519:	75 f5                	jne    510 <strlen+0x10>
    ;
  return n;
}
 51b:	5d                   	pop    %ebp
 51c:	c3                   	ret    
 51d:	8d 76 00             	lea    0x0(%esi),%esi

00000520 <memset>:

void*
memset(void *dst, int c, uint n)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	8b 55 08             	mov    0x8(%ebp),%edx
 526:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 527:	8b 4d 10             	mov    0x10(%ebp),%ecx
 52a:	8b 45 0c             	mov    0xc(%ebp),%eax
 52d:	89 d7                	mov    %edx,%edi
 52f:	fc                   	cld    
 530:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 532:	89 d0                	mov    %edx,%eax
 534:	5f                   	pop    %edi
 535:	5d                   	pop    %ebp
 536:	c3                   	ret    
 537:	89 f6                	mov    %esi,%esi
 539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000540 <strchr>:

char*
strchr(const char *s, char c)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 54a:	0f b6 10             	movzbl (%eax),%edx
 54d:	84 d2                	test   %dl,%dl
 54f:	75 11                	jne    562 <strchr+0x22>
 551:	eb 15                	jmp    568 <strchr+0x28>
 553:	90                   	nop
 554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 558:	83 c0 01             	add    $0x1,%eax
 55b:	0f b6 10             	movzbl (%eax),%edx
 55e:	84 d2                	test   %dl,%dl
 560:	74 06                	je     568 <strchr+0x28>
    if(*s == c)
 562:	38 ca                	cmp    %cl,%dl
 564:	75 f2                	jne    558 <strchr+0x18>
      return (char*)s;
  return 0;
}
 566:	5d                   	pop    %ebp
 567:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 568:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 56a:	5d                   	pop    %ebp
 56b:	90                   	nop
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 570:	c3                   	ret    
 571:	eb 0d                	jmp    580 <atoi>
 573:	90                   	nop
 574:	90                   	nop
 575:	90                   	nop
 576:	90                   	nop
 577:	90                   	nop
 578:	90                   	nop
 579:	90                   	nop
 57a:	90                   	nop
 57b:	90                   	nop
 57c:	90                   	nop
 57d:	90                   	nop
 57e:	90                   	nop
 57f:	90                   	nop

00000580 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 580:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 581:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 583:	89 e5                	mov    %esp,%ebp
 585:	8b 4d 08             	mov    0x8(%ebp),%ecx
 588:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 589:	0f b6 11             	movzbl (%ecx),%edx
 58c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 58f:	80 fb 09             	cmp    $0x9,%bl
 592:	77 1c                	ja     5b0 <atoi+0x30>
 594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 598:	0f be d2             	movsbl %dl,%edx
 59b:	83 c1 01             	add    $0x1,%ecx
 59e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 5a1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5a5:	0f b6 11             	movzbl (%ecx),%edx
 5a8:	8d 5a d0             	lea    -0x30(%edx),%ebx
 5ab:	80 fb 09             	cmp    $0x9,%bl
 5ae:	76 e8                	jbe    598 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 5b0:	5b                   	pop    %ebx
 5b1:	5d                   	pop    %ebp
 5b2:	c3                   	ret    
 5b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005c0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	56                   	push   %esi
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	53                   	push   %ebx
 5c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5ce:	85 db                	test   %ebx,%ebx
 5d0:	7e 14                	jle    5e6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 5d2:	31 d2                	xor    %edx,%edx
 5d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 5d8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 5dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 5df:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5e2:	39 da                	cmp    %ebx,%edx
 5e4:	75 f2                	jne    5d8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 5e6:	5b                   	pop    %ebx
 5e7:	5e                   	pop    %esi
 5e8:	5d                   	pop    %ebp
 5e9:	c3                   	ret    
 5ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000005f0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5f6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 5f9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 5fc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 5ff:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 604:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 60b:	00 
 60c:	89 04 24             	mov    %eax,(%esp)
 60f:	e8 d4 00 00 00       	call   6e8 <open>
  if(fd < 0)
 614:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 616:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 618:	78 19                	js     633 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 61a:	8b 45 0c             	mov    0xc(%ebp),%eax
 61d:	89 1c 24             	mov    %ebx,(%esp)
 620:	89 44 24 04          	mov    %eax,0x4(%esp)
 624:	e8 d7 00 00 00       	call   700 <fstat>
  close(fd);
 629:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 62c:	89 c6                	mov    %eax,%esi
  close(fd);
 62e:	e8 9d 00 00 00       	call   6d0 <close>
  return r;
}
 633:	89 f0                	mov    %esi,%eax
 635:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 638:	8b 75 fc             	mov    -0x4(%ebp),%esi
 63b:	89 ec                	mov    %ebp,%esp
 63d:	5d                   	pop    %ebp
 63e:	c3                   	ret    
 63f:	90                   	nop

00000640 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	31 f6                	xor    %esi,%esi
 647:	53                   	push   %ebx
 648:	83 ec 2c             	sub    $0x2c,%esp
 64b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 64e:	eb 06                	jmp    656 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 650:	3c 0a                	cmp    $0xa,%al
 652:	74 39                	je     68d <gets+0x4d>
 654:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 656:	8d 5e 01             	lea    0x1(%esi),%ebx
 659:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 65c:	7d 31                	jge    68f <gets+0x4f>
    cc = read(0, &c, 1);
 65e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 661:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 668:	00 
 669:	89 44 24 04          	mov    %eax,0x4(%esp)
 66d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 674:	e8 47 00 00 00       	call   6c0 <read>
    if(cc < 1)
 679:	85 c0                	test   %eax,%eax
 67b:	7e 12                	jle    68f <gets+0x4f>
      break;
    buf[i++] = c;
 67d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 681:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 685:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 689:	3c 0d                	cmp    $0xd,%al
 68b:	75 c3                	jne    650 <gets+0x10>
 68d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 68f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 693:	89 f8                	mov    %edi,%eax
 695:	83 c4 2c             	add    $0x2c,%esp
 698:	5b                   	pop    %ebx
 699:	5e                   	pop    %esi
 69a:	5f                   	pop    %edi
 69b:	5d                   	pop    %ebp
 69c:	c3                   	ret    
 69d:	90                   	nop
 69e:	90                   	nop
 69f:	90                   	nop

000006a0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6a0:	b8 01 00 00 00       	mov    $0x1,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <exit>:
SYSCALL(exit)
 6a8:	b8 02 00 00 00       	mov    $0x2,%eax
 6ad:	cd 40                	int    $0x40
 6af:	c3                   	ret    

000006b0 <wait>:
SYSCALL(wait)
 6b0:	b8 03 00 00 00       	mov    $0x3,%eax
 6b5:	cd 40                	int    $0x40
 6b7:	c3                   	ret    

000006b8 <pipe>:
SYSCALL(pipe)
 6b8:	b8 04 00 00 00       	mov    $0x4,%eax
 6bd:	cd 40                	int    $0x40
 6bf:	c3                   	ret    

000006c0 <read>:
SYSCALL(read)
 6c0:	b8 05 00 00 00       	mov    $0x5,%eax
 6c5:	cd 40                	int    $0x40
 6c7:	c3                   	ret    

000006c8 <write>:
SYSCALL(write)
 6c8:	b8 10 00 00 00       	mov    $0x10,%eax
 6cd:	cd 40                	int    $0x40
 6cf:	c3                   	ret    

000006d0 <close>:
SYSCALL(close)
 6d0:	b8 15 00 00 00       	mov    $0x15,%eax
 6d5:	cd 40                	int    $0x40
 6d7:	c3                   	ret    

000006d8 <kill>:
SYSCALL(kill)
 6d8:	b8 06 00 00 00       	mov    $0x6,%eax
 6dd:	cd 40                	int    $0x40
 6df:	c3                   	ret    

000006e0 <exec>:
SYSCALL(exec)
 6e0:	b8 07 00 00 00       	mov    $0x7,%eax
 6e5:	cd 40                	int    $0x40
 6e7:	c3                   	ret    

000006e8 <open>:
SYSCALL(open)
 6e8:	b8 0f 00 00 00       	mov    $0xf,%eax
 6ed:	cd 40                	int    $0x40
 6ef:	c3                   	ret    

000006f0 <mknod>:
SYSCALL(mknod)
 6f0:	b8 11 00 00 00       	mov    $0x11,%eax
 6f5:	cd 40                	int    $0x40
 6f7:	c3                   	ret    

000006f8 <unlink>:
SYSCALL(unlink)
 6f8:	b8 12 00 00 00       	mov    $0x12,%eax
 6fd:	cd 40                	int    $0x40
 6ff:	c3                   	ret    

00000700 <fstat>:
SYSCALL(fstat)
 700:	b8 08 00 00 00       	mov    $0x8,%eax
 705:	cd 40                	int    $0x40
 707:	c3                   	ret    

00000708 <link>:
SYSCALL(link)
 708:	b8 13 00 00 00       	mov    $0x13,%eax
 70d:	cd 40                	int    $0x40
 70f:	c3                   	ret    

00000710 <mkdir>:
SYSCALL(mkdir)
 710:	b8 14 00 00 00       	mov    $0x14,%eax
 715:	cd 40                	int    $0x40
 717:	c3                   	ret    

00000718 <chdir>:
SYSCALL(chdir)
 718:	b8 09 00 00 00       	mov    $0x9,%eax
 71d:	cd 40                	int    $0x40
 71f:	c3                   	ret    

00000720 <dup>:
SYSCALL(dup)
 720:	b8 0a 00 00 00       	mov    $0xa,%eax
 725:	cd 40                	int    $0x40
 727:	c3                   	ret    

00000728 <getpid>:
SYSCALL(getpid)
 728:	b8 0b 00 00 00       	mov    $0xb,%eax
 72d:	cd 40                	int    $0x40
 72f:	c3                   	ret    

00000730 <sbrk>:
SYSCALL(sbrk)
 730:	b8 0c 00 00 00       	mov    $0xc,%eax
 735:	cd 40                	int    $0x40
 737:	c3                   	ret    

00000738 <sleep>:
SYSCALL(sleep)
 738:	b8 0d 00 00 00       	mov    $0xd,%eax
 73d:	cd 40                	int    $0x40
 73f:	c3                   	ret    

00000740 <uptime>:
SYSCALL(uptime)
 740:	b8 0e 00 00 00       	mov    $0xe,%eax
 745:	cd 40                	int    $0x40
 747:	c3                   	ret    

00000748 <gettime>:
SYSCALL(gettime)
 748:	b8 16 00 00 00       	mov    $0x16,%eax
 74d:	cd 40                	int    $0x40
 74f:	c3                   	ret    

00000750 <shared>:
SYSCALL(shared)
 750:	b8 17 00 00 00       	mov    $0x17,%eax
 755:	cd 40                	int    $0x40
 757:	c3                   	ret    
 758:	90                   	nop
 759:	90                   	nop
 75a:	90                   	nop
 75b:	90                   	nop
 75c:	90                   	nop
 75d:	90                   	nop
 75e:	90                   	nop
 75f:	90                   	nop

00000760 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	57                   	push   %edi
 764:	89 cf                	mov    %ecx,%edi
 766:	56                   	push   %esi
 767:	89 c6                	mov    %eax,%esi
 769:	53                   	push   %ebx
 76a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 76d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 770:	85 c9                	test   %ecx,%ecx
 772:	74 04                	je     778 <printint+0x18>
 774:	85 d2                	test   %edx,%edx
 776:	78 68                	js     7e0 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 778:	89 d0                	mov    %edx,%eax
 77a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 781:	31 c9                	xor    %ecx,%ecx
 783:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 786:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 788:	31 d2                	xor    %edx,%edx
 78a:	f7 f7                	div    %edi
 78c:	0f b6 92 73 0c 00 00 	movzbl 0xc73(%edx),%edx
 793:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 796:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 799:	85 c0                	test   %eax,%eax
 79b:	75 eb                	jne    788 <printint+0x28>
  if(neg)
 79d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 7a0:	85 c0                	test   %eax,%eax
 7a2:	74 08                	je     7ac <printint+0x4c>
    buf[i++] = '-';
 7a4:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 7a9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 7ac:	8d 79 ff             	lea    -0x1(%ecx),%edi
 7af:	90                   	nop
 7b0:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
 7b4:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7b7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7be:	00 
 7bf:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7c2:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7c5:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7cc:	e8 f7 fe ff ff       	call   6c8 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7d1:	83 ff ff             	cmp    $0xffffffff,%edi
 7d4:	75 da                	jne    7b0 <printint+0x50>
    putc(fd, buf[i]);
}
 7d6:	83 c4 4c             	add    $0x4c,%esp
 7d9:	5b                   	pop    %ebx
 7da:	5e                   	pop    %esi
 7db:	5f                   	pop    %edi
 7dc:	5d                   	pop    %ebp
 7dd:	c3                   	ret    
 7de:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 7e0:	89 d0                	mov    %edx,%eax
 7e2:	f7 d8                	neg    %eax
 7e4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 7eb:	eb 94                	jmp    781 <printint+0x21>
 7ed:	8d 76 00             	lea    0x0(%esi),%esi

000007f0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7f0:	55                   	push   %ebp
 7f1:	89 e5                	mov    %esp,%ebp
 7f3:	57                   	push   %edi
 7f4:	56                   	push   %esi
 7f5:	53                   	push   %ebx
 7f6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 7fc:	0f b6 10             	movzbl (%eax),%edx
 7ff:	84 d2                	test   %dl,%dl
 801:	0f 84 c1 00 00 00    	je     8c8 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 807:	8d 4d 10             	lea    0x10(%ebp),%ecx
 80a:	31 ff                	xor    %edi,%edi
 80c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 80f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 811:	8d 75 e7             	lea    -0x19(%ebp),%esi
 814:	eb 1e                	jmp    834 <printf+0x44>
 816:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 818:	83 fa 25             	cmp    $0x25,%edx
 81b:	0f 85 af 00 00 00    	jne    8d0 <printf+0xe0>
 821:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 825:	83 c3 01             	add    $0x1,%ebx
 828:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 82c:	84 d2                	test   %dl,%dl
 82e:	0f 84 94 00 00 00    	je     8c8 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
 834:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 836:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 839:	74 dd                	je     818 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 83b:	83 ff 25             	cmp    $0x25,%edi
 83e:	75 e5                	jne    825 <printf+0x35>
      if(c == 'd'){
 840:	83 fa 64             	cmp    $0x64,%edx
 843:	0f 84 3f 01 00 00    	je     988 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 849:	83 fa 70             	cmp    $0x70,%edx
 84c:	0f 84 a6 00 00 00    	je     8f8 <printf+0x108>
 852:	83 fa 78             	cmp    $0x78,%edx
 855:	0f 84 9d 00 00 00    	je     8f8 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 85b:	83 fa 73             	cmp    $0x73,%edx
 85e:	66 90                	xchg   %ax,%ax
 860:	0f 84 ba 00 00 00    	je     920 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 866:	83 fa 63             	cmp    $0x63,%edx
 869:	0f 84 41 01 00 00    	je     9b0 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 86f:	83 fa 25             	cmp    $0x25,%edx
 872:	0f 84 00 01 00 00    	je     978 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 878:	8b 4d 08             	mov    0x8(%ebp),%ecx
 87b:	89 55 cc             	mov    %edx,-0x34(%ebp)
 87e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 882:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 889:	00 
 88a:	89 74 24 04          	mov    %esi,0x4(%esp)
 88e:	89 0c 24             	mov    %ecx,(%esp)
 891:	e8 32 fe ff ff       	call   6c8 <write>
 896:	8b 55 cc             	mov    -0x34(%ebp),%edx
 899:	88 55 e7             	mov    %dl,-0x19(%ebp)
 89c:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 89f:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8a2:	31 ff                	xor    %edi,%edi
 8a4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8ab:	00 
 8ac:	89 74 24 04          	mov    %esi,0x4(%esp)
 8b0:	89 04 24             	mov    %eax,(%esp)
 8b3:	e8 10 fe ff ff       	call   6c8 <write>
 8b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8bb:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 8bf:	84 d2                	test   %dl,%dl
 8c1:	0f 85 6d ff ff ff    	jne    834 <printf+0x44>
 8c7:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8c8:	83 c4 3c             	add    $0x3c,%esp
 8cb:	5b                   	pop    %ebx
 8cc:	5e                   	pop    %esi
 8cd:	5f                   	pop    %edi
 8ce:	5d                   	pop    %ebp
 8cf:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8d0:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 8d3:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8d6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8dd:	00 
 8de:	89 74 24 04          	mov    %esi,0x4(%esp)
 8e2:	89 04 24             	mov    %eax,(%esp)
 8e5:	e8 de fd ff ff       	call   6c8 <write>
 8ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 8ed:	e9 33 ff ff ff       	jmp    825 <printf+0x35>
 8f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 8f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 8fb:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 900:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 902:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 909:	8b 10                	mov    (%eax),%edx
 90b:	8b 45 08             	mov    0x8(%ebp),%eax
 90e:	e8 4d fe ff ff       	call   760 <printint>
 913:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 916:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 91a:	e9 06 ff ff ff       	jmp    825 <printf+0x35>
 91f:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 920:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 923:	b9 6c 0c 00 00       	mov    $0xc6c,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 928:	8b 3a                	mov    (%edx),%edi
        ap++;
 92a:	83 c2 04             	add    $0x4,%edx
 92d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 930:	85 ff                	test   %edi,%edi
 932:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 935:	0f b6 17             	movzbl (%edi),%edx
 938:	84 d2                	test   %dl,%dl
 93a:	74 33                	je     96f <printf+0x17f>
 93c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 93f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 948:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 94b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 94e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 955:	00 
 956:	89 74 24 04          	mov    %esi,0x4(%esp)
 95a:	89 1c 24             	mov    %ebx,(%esp)
 95d:	e8 66 fd ff ff       	call   6c8 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 962:	0f b6 17             	movzbl (%edi),%edx
 965:	84 d2                	test   %dl,%dl
 967:	75 df                	jne    948 <printf+0x158>
 969:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 96c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 96f:	31 ff                	xor    %edi,%edi
 971:	e9 af fe ff ff       	jmp    825 <printf+0x35>
 976:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 978:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 97c:	e9 1b ff ff ff       	jmp    89c <printf+0xac>
 981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 988:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 98b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 990:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 993:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 99a:	8b 10                	mov    (%eax),%edx
 99c:	8b 45 08             	mov    0x8(%ebp),%eax
 99f:	e8 bc fd ff ff       	call   760 <printint>
 9a4:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 9a7:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 9ab:	e9 75 fe ff ff       	jmp    825 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 9b3:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 9b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9b8:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 9ba:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 9c1:	00 
 9c2:	89 74 24 04          	mov    %esi,0x4(%esp)
 9c6:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9c9:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 9cc:	e8 f7 fc ff ff       	call   6c8 <write>
 9d1:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 9d4:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 9d8:	e9 48 fe ff ff       	jmp    825 <printf+0x35>
 9dd:	90                   	nop
 9de:	90                   	nop
 9df:	90                   	nop

000009e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9e1:	a1 bc 2c 00 00       	mov    0x2cbc,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 9e6:	89 e5                	mov    %esp,%ebp
 9e8:	57                   	push   %edi
 9e9:	56                   	push   %esi
 9ea:	53                   	push   %ebx
 9eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f1:	39 c8                	cmp    %ecx,%eax
 9f3:	73 1d                	jae    a12 <free+0x32>
 9f5:	8d 76 00             	lea    0x0(%esi),%esi
 9f8:	8b 10                	mov    (%eax),%edx
 9fa:	39 d1                	cmp    %edx,%ecx
 9fc:	72 1a                	jb     a18 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9fe:	39 d0                	cmp    %edx,%eax
 a00:	72 08                	jb     a0a <free+0x2a>
 a02:	39 c8                	cmp    %ecx,%eax
 a04:	72 12                	jb     a18 <free+0x38>
 a06:	39 d1                	cmp    %edx,%ecx
 a08:	72 0e                	jb     a18 <free+0x38>
 a0a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a0c:	39 c8                	cmp    %ecx,%eax
 a0e:	66 90                	xchg   %ax,%ax
 a10:	72 e6                	jb     9f8 <free+0x18>
 a12:	8b 10                	mov    (%eax),%edx
 a14:	eb e8                	jmp    9fe <free+0x1e>
 a16:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a18:	8b 71 04             	mov    0x4(%ecx),%esi
 a1b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 a1e:	39 d7                	cmp    %edx,%edi
 a20:	74 19                	je     a3b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 a22:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 a25:	8b 50 04             	mov    0x4(%eax),%edx
 a28:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 a2b:	39 ce                	cmp    %ecx,%esi
 a2d:	74 23                	je     a52 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 a2f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 a31:	a3 bc 2c 00 00       	mov    %eax,0x2cbc
}
 a36:	5b                   	pop    %ebx
 a37:	5e                   	pop    %esi
 a38:	5f                   	pop    %edi
 a39:	5d                   	pop    %ebp
 a3a:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a3b:	03 72 04             	add    0x4(%edx),%esi
 a3e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 a41:	8b 10                	mov    (%eax),%edx
 a43:	8b 12                	mov    (%edx),%edx
 a45:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 a48:	8b 50 04             	mov    0x4(%eax),%edx
 a4b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 a4e:	39 ce                	cmp    %ecx,%esi
 a50:	75 dd                	jne    a2f <free+0x4f>
    p->s.size += bp->s.size;
 a52:	03 51 04             	add    0x4(%ecx),%edx
 a55:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a58:	8b 53 f8             	mov    -0x8(%ebx),%edx
 a5b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 a5d:	a3 bc 2c 00 00       	mov    %eax,0x2cbc
}
 a62:	5b                   	pop    %ebx
 a63:	5e                   	pop    %esi
 a64:	5f                   	pop    %edi
 a65:	5d                   	pop    %ebp
 a66:	c3                   	ret    
 a67:	89 f6                	mov    %esi,%esi
 a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a70 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a70:	55                   	push   %ebp
 a71:	89 e5                	mov    %esp,%ebp
 a73:	57                   	push   %edi
 a74:	56                   	push   %esi
 a75:	53                   	push   %ebx
 a76:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 a7c:	8b 0d bc 2c 00 00    	mov    0x2cbc,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a82:	83 c3 07             	add    $0x7,%ebx
 a85:	c1 eb 03             	shr    $0x3,%ebx
 a88:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 a8b:	85 c9                	test   %ecx,%ecx
 a8d:	0f 84 9b 00 00 00    	je     b2e <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a93:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 a95:	8b 50 04             	mov    0x4(%eax),%edx
 a98:	39 d3                	cmp    %edx,%ebx
 a9a:	76 27                	jbe    ac3 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 a9c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 aa3:	be 00 80 00 00       	mov    $0x8000,%esi
 aa8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 aab:	90                   	nop
 aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ab0:	3b 05 bc 2c 00 00    	cmp    0x2cbc,%eax
 ab6:	74 30                	je     ae8 <malloc+0x78>
 ab8:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aba:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 abc:	8b 50 04             	mov    0x4(%eax),%edx
 abf:	39 d3                	cmp    %edx,%ebx
 ac1:	77 ed                	ja     ab0 <malloc+0x40>
      if(p->s.size == nunits)
 ac3:	39 d3                	cmp    %edx,%ebx
 ac5:	74 61                	je     b28 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 ac7:	29 da                	sub    %ebx,%edx
 ac9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 acc:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 acf:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 ad2:	89 0d bc 2c 00 00    	mov    %ecx,0x2cbc
      return (void*)(p + 1);
 ad8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 adb:	83 c4 2c             	add    $0x2c,%esp
 ade:	5b                   	pop    %ebx
 adf:	5e                   	pop    %esi
 ae0:	5f                   	pop    %edi
 ae1:	5d                   	pop    %ebp
 ae2:	c3                   	ret    
 ae3:	90                   	nop
 ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 ae8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 aeb:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 af1:	bf 00 10 00 00       	mov    $0x1000,%edi
 af6:	0f 43 fb             	cmovae %ebx,%edi
 af9:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 afc:	89 04 24             	mov    %eax,(%esp)
 aff:	e8 2c fc ff ff       	call   730 <sbrk>
  if(p == (char*)-1)
 b04:	83 f8 ff             	cmp    $0xffffffff,%eax
 b07:	74 18                	je     b21 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 b09:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 b0c:	83 c0 08             	add    $0x8,%eax
 b0f:	89 04 24             	mov    %eax,(%esp)
 b12:	e8 c9 fe ff ff       	call   9e0 <free>
  return freep;
 b17:	8b 0d bc 2c 00 00    	mov    0x2cbc,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 b1d:	85 c9                	test   %ecx,%ecx
 b1f:	75 99                	jne    aba <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 b21:	31 c0                	xor    %eax,%eax
 b23:	eb b6                	jmp    adb <malloc+0x6b>
 b25:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 b28:	8b 10                	mov    (%eax),%edx
 b2a:	89 11                	mov    %edx,(%ecx)
 b2c:	eb a4                	jmp    ad2 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 b2e:	c7 05 bc 2c 00 00 b4 	movl   $0x2cb4,0x2cbc
 b35:	2c 00 00 
    base.s.size = 0;
 b38:	b9 b4 2c 00 00       	mov    $0x2cb4,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 b3d:	c7 05 b4 2c 00 00 b4 	movl   $0x2cb4,0x2cb4
 b44:	2c 00 00 
    base.s.size = 0;
 b47:	c7 05 b8 2c 00 00 00 	movl   $0x0,0x2cb8
 b4e:	00 00 00 
 b51:	e9 3d ff ff ff       	jmp    a93 <malloc+0x23>
