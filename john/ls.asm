
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 ec 10             	sub    $0x10,%esp
   8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   b:	89 1c 24             	mov    %ebx,(%esp)
   e:	e8 cd 03 00 00       	call   3e0 <strlen>
  13:	01 d8                	add    %ebx,%eax
  15:	73 10                	jae    27 <fmtname+0x27>
  17:	eb 13                	jmp    2c <fmtname+0x2c>
  19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  20:	83 e8 01             	sub    $0x1,%eax
  23:	39 c3                	cmp    %eax,%ebx
  25:	77 05                	ja     2c <fmtname+0x2c>
  27:	80 38 2f             	cmpb   $0x2f,(%eax)
  2a:	75 f4                	jne    20 <fmtname+0x20>
    ;
  p++;
  2c:	8d 58 01             	lea    0x1(%eax),%ebx
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  2f:	89 1c 24             	mov    %ebx,(%esp)
  32:	e8 a9 03 00 00       	call   3e0 <strlen>
  37:	83 f8 0d             	cmp    $0xd,%eax
  3a:	77 53                	ja     8f <fmtname+0x8f>
    return p;
  memmove(buf, p, strlen(p));
  3c:	89 1c 24             	mov    %ebx,(%esp)
  3f:	e8 9c 03 00 00       	call   3e0 <strlen>
  44:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  48:	c7 04 24 48 0b 00 00 	movl   $0xb48,(%esp)
  4f:	89 44 24 08          	mov    %eax,0x8(%esp)
  53:	e8 48 04 00 00       	call   4a0 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  58:	89 1c 24             	mov    %ebx,(%esp)
  5b:	e8 80 03 00 00       	call   3e0 <strlen>
  60:	89 1c 24             	mov    %ebx,(%esp)
  63:	bb 48 0b 00 00       	mov    $0xb48,%ebx
  68:	89 c6                	mov    %eax,%esi
  6a:	e8 71 03 00 00       	call   3e0 <strlen>
  6f:	ba 0e 00 00 00       	mov    $0xe,%edx
  74:	29 f2                	sub    %esi,%edx
  76:	89 54 24 08          	mov    %edx,0x8(%esp)
  7a:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  81:	00 
  82:	05 48 0b 00 00       	add    $0xb48,%eax
  87:	89 04 24             	mov    %eax,(%esp)
  8a:	e8 71 03 00 00       	call   400 <memset>
  return buf;
}
  8f:	83 c4 10             	add    $0x10,%esp
  92:	89 d8                	mov    %ebx,%eax
  94:	5b                   	pop    %ebx
  95:	5e                   	pop    %esi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    
  98:	90                   	nop
  99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000a0 <ls>:

void
ls(char *path)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	57                   	push   %edi
  a4:	56                   	push   %esi
  a5:	53                   	push   %ebx
  a6:	81 ec 6c 02 00 00    	sub    $0x26c,%esp
  ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  b6:	00 
  b7:	89 3c 24             	mov    %edi,(%esp)
  ba:	e8 09 05 00 00       	call   5c8 <open>
  bf:	85 c0                	test   %eax,%eax
  c1:	89 c3                	mov    %eax,%ebx
  c3:	0f 88 c7 01 00 00    	js     290 <ls+0x1f0>
    printf(2, "ls: cannot open %s\n", path);
    return;
  }
  
  if(fstat(fd, &st) < 0){
  c9:	8d 75 c4             	lea    -0x3c(%ebp),%esi
  cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  d0:	89 04 24             	mov    %eax,(%esp)
  d3:	e8 08 05 00 00       	call   5e0 <fstat>
  d8:	85 c0                	test   %eax,%eax
  da:	0f 88 00 02 00 00    	js     2e0 <ls+0x240>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }
  
  switch(st.type){
  e0:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
  e4:	66 83 f8 01          	cmp    $0x1,%ax
  e8:	74 66                	je     150 <ls+0xb0>
  ea:	66 83 f8 02          	cmp    $0x2,%ax
  ee:	74 18                	je     108 <ls+0x68>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
  f0:	89 1c 24             	mov    %ebx,(%esp)
  f3:	e8 b8 04 00 00       	call   5b0 <close>
}
  f8:	81 c4 6c 02 00 00    	add    $0x26c,%esp
  fe:	5b                   	pop    %ebx
  ff:	5e                   	pop    %esi
 100:	5f                   	pop    %edi
 101:	5d                   	pop    %ebp
 102:	c3                   	ret    
 103:	90                   	nop
 104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  
  switch(st.type){
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 108:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 10b:	8b 75 cc             	mov    -0x34(%ebp),%esi
 10e:	89 3c 24             	mov    %edi,(%esp)
 111:	89 95 ac fd ff ff    	mov    %edx,-0x254(%ebp)
 117:	e8 e4 fe ff ff       	call   0 <fmtname>
 11c:	8b 95 ac fd ff ff    	mov    -0x254(%ebp),%edx
 122:	89 74 24 10          	mov    %esi,0x10(%esp)
 126:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
 12d:	00 
 12e:	c7 44 24 04 0d 0b 00 	movl   $0xb0d,0x4(%esp)
 135:	00 
 136:	89 54 24 14          	mov    %edx,0x14(%esp)
 13a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 141:	89 44 24 08          	mov    %eax,0x8(%esp)
 145:	e8 86 05 00 00       	call   6d0 <printf>
    break;
 14a:	eb a4                	jmp    f0 <ls+0x50>
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 150:	89 3c 24             	mov    %edi,(%esp)
 153:	e8 88 02 00 00       	call   3e0 <strlen>
 158:	83 c0 10             	add    $0x10,%eax
 15b:	3d 00 02 00 00       	cmp    $0x200,%eax
 160:	0f 87 0a 01 00 00    	ja     270 <ls+0x1d0>
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
 166:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 16c:	89 7c 24 04          	mov    %edi,0x4(%esp)
 170:	8d 7d d8             	lea    -0x28(%ebp),%edi
 173:	89 04 24             	mov    %eax,(%esp)
 176:	e8 e5 01 00 00       	call   360 <strcpy>
    p = buf+strlen(buf);
 17b:	8d 95 c4 fd ff ff    	lea    -0x23c(%ebp),%edx
 181:	89 14 24             	mov    %edx,(%esp)
 184:	e8 57 02 00 00       	call   3e0 <strlen>
 189:	8d 95 c4 fd ff ff    	lea    -0x23c(%ebp),%edx
 18f:	8d 04 02             	lea    (%edx,%eax,1),%eax
    *p++ = '/';
 192:	c6 00 2f             	movb   $0x2f,(%eax)
 195:	83 c0 01             	add    $0x1,%eax
 198:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 19e:	66 90                	xchg   %ax,%ax
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 1a7:	00 
 1a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1ac:	89 1c 24             	mov    %ebx,(%esp)
 1af:	e8 ec 03 00 00       	call   5a0 <read>
 1b4:	83 f8 10             	cmp    $0x10,%eax
 1b7:	0f 85 33 ff ff ff    	jne    f0 <ls+0x50>
      if(de.inum == 0)
 1bd:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
 1c2:	74 dc                	je     1a0 <ls+0x100>
        continue;
      memmove(p, de.name, DIRSIZ);
 1c4:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 1ca:	8d 45 da             	lea    -0x26(%ebp),%eax
 1cd:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 1d4:	00 
 1d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d9:	89 14 24             	mov    %edx,(%esp)
 1dc:	e8 bf 02 00 00       	call   4a0 <memmove>
      p[DIRSIZ] = 0;
 1e1:	8b 85 b4 fd ff ff    	mov    -0x24c(%ebp),%eax
      if(stat(buf, &st) < 0){
 1e7:	8d 95 c4 fd ff ff    	lea    -0x23c(%ebp),%edx
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
 1ed:	c6 40 0e 00          	movb   $0x0,0xe(%eax)
      if(stat(buf, &st) < 0){
 1f1:	89 74 24 04          	mov    %esi,0x4(%esp)
 1f5:	89 14 24             	mov    %edx,(%esp)
 1f8:	e8 d3 02 00 00       	call   4d0 <stat>
 1fd:	85 c0                	test   %eax,%eax
 1ff:	0f 88 b3 00 00 00    	js     2b8 <ls+0x218>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 205:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
 209:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 20c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
 20f:	89 85 b0 fd ff ff    	mov    %eax,-0x250(%ebp)
 215:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 21b:	89 95 ac fd ff ff    	mov    %edx,-0x254(%ebp)
 221:	89 8d a8 fd ff ff    	mov    %ecx,-0x258(%ebp)
 227:	89 04 24             	mov    %eax,(%esp)
 22a:	e8 d1 fd ff ff       	call   0 <fmtname>
 22f:	8b 95 ac fd ff ff    	mov    -0x254(%ebp),%edx
 235:	8b 8d a8 fd ff ff    	mov    -0x258(%ebp),%ecx
 23b:	c7 44 24 04 0d 0b 00 	movl   $0xb0d,0x4(%esp)
 242:	00 
 243:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 24a:	89 54 24 14          	mov    %edx,0x14(%esp)
 24e:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 254:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 258:	89 44 24 08          	mov    %eax,0x8(%esp)
 25c:	89 54 24 0c          	mov    %edx,0xc(%esp)
 260:	e8 6b 04 00 00       	call   6d0 <printf>
 265:	e9 36 ff ff ff       	jmp    1a0 <ls+0x100>
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
 270:	c7 44 24 04 1a 0b 00 	movl   $0xb1a,0x4(%esp)
 277:	00 
 278:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 27f:	e8 4c 04 00 00       	call   6d0 <printf>
      break;
 284:	e9 67 fe ff ff       	jmp    f0 <ls+0x50>
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
    printf(2, "ls: cannot open %s\n", path);
 290:	89 7c 24 08          	mov    %edi,0x8(%esp)
 294:	c7 44 24 04 e5 0a 00 	movl   $0xae5,0x4(%esp)
 29b:	00 
 29c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2a3:	e8 28 04 00 00       	call   6d0 <printf>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
}
 2a8:	81 c4 6c 02 00 00    	add    $0x26c,%esp
 2ae:	5b                   	pop    %ebx
 2af:	5e                   	pop    %esi
 2b0:	5f                   	pop    %edi
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    
 2b3:	90                   	nop
 2b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf(1, "ls: cannot stat %s\n", buf);
 2b8:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 2be:	89 44 24 08          	mov    %eax,0x8(%esp)
 2c2:	c7 44 24 04 f9 0a 00 	movl   $0xaf9,0x4(%esp)
 2c9:	00 
 2ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2d1:	e8 fa 03 00 00       	call   6d0 <printf>
        continue;
 2d6:	e9 c5 fe ff ff       	jmp    1a0 <ls+0x100>
 2db:	90                   	nop
 2dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }
  
  if(fstat(fd, &st) < 0){
    printf(2, "ls: cannot stat %s\n", path);
 2e0:	89 7c 24 08          	mov    %edi,0x8(%esp)
 2e4:	c7 44 24 04 f9 0a 00 	movl   $0xaf9,0x4(%esp)
 2eb:	00 
 2ec:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2f3:	e8 d8 03 00 00       	call   6d0 <printf>
    close(fd);
 2f8:	89 1c 24             	mov    %ebx,(%esp)
 2fb:	e8 b0 02 00 00       	call   5b0 <close>
    return;
 300:	e9 f3 fd ff ff       	jmp    f8 <ls+0x58>
 305:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000310 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 e4 f0             	and    $0xfffffff0,%esp
 316:	57                   	push   %edi
 317:	56                   	push   %esi
 318:	53                   	push   %ebx
  int i;

  if(argc < 2){
    ls(".");
    exit();
 319:	bb 01 00 00 00       	mov    $0x1,%ebx
  close(fd);
}

int
main(int argc, char *argv[])
{
 31e:	83 ec 14             	sub    $0x14,%esp
 321:	8b 75 08             	mov    0x8(%ebp),%esi
 324:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  if(argc < 2){
 327:	83 fe 01             	cmp    $0x1,%esi
 32a:	7e 1c                	jle    348 <main+0x38>
 32c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 330:	8b 04 9f             	mov    (%edi,%ebx,4),%eax

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 333:	83 c3 01             	add    $0x1,%ebx
    ls(argv[i]);
 336:	89 04 24             	mov    %eax,(%esp)
 339:	e8 62 fd ff ff       	call   a0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 33e:	39 de                	cmp    %ebx,%esi
 340:	7f ee                	jg     330 <main+0x20>
    ls(argv[i]);
  exit();
 342:	e8 41 02 00 00       	call   588 <exit>
 347:	90                   	nop
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
    ls(".");
 348:	c7 04 24 2d 0b 00 00 	movl   $0xb2d,(%esp)
 34f:	e8 4c fd ff ff       	call   a0 <ls>
    exit();
 354:	e8 2f 02 00 00       	call   588 <exit>
 359:	90                   	nop
 35a:	90                   	nop
 35b:	90                   	nop
 35c:	90                   	nop
 35d:	90                   	nop
 35e:	90                   	nop
 35f:	90                   	nop

00000360 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 360:	55                   	push   %ebp
 361:	31 d2                	xor    %edx,%edx
 363:	89 e5                	mov    %esp,%ebp
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	53                   	push   %ebx
 369:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 370:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 374:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 377:	83 c2 01             	add    $0x1,%edx
 37a:	84 c9                	test   %cl,%cl
 37c:	75 f2                	jne    370 <strcpy+0x10>
    ;
  return os;
}
 37e:	5b                   	pop    %ebx
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    
 381:	eb 0d                	jmp    390 <strcmp>
 383:	90                   	nop
 384:	90                   	nop
 385:	90                   	nop
 386:	90                   	nop
 387:	90                   	nop
 388:	90                   	nop
 389:	90                   	nop
 38a:	90                   	nop
 38b:	90                   	nop
 38c:	90                   	nop
 38d:	90                   	nop
 38e:	90                   	nop
 38f:	90                   	nop

00000390 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	8b 4d 08             	mov    0x8(%ebp),%ecx
 396:	53                   	push   %ebx
 397:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 39a:	0f b6 01             	movzbl (%ecx),%eax
 39d:	84 c0                	test   %al,%al
 39f:	75 14                	jne    3b5 <strcmp+0x25>
 3a1:	eb 25                	jmp    3c8 <strcmp+0x38>
 3a3:	90                   	nop
 3a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 3a8:	83 c1 01             	add    $0x1,%ecx
 3ab:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3ae:	0f b6 01             	movzbl (%ecx),%eax
 3b1:	84 c0                	test   %al,%al
 3b3:	74 13                	je     3c8 <strcmp+0x38>
 3b5:	0f b6 1a             	movzbl (%edx),%ebx
 3b8:	38 d8                	cmp    %bl,%al
 3ba:	74 ec                	je     3a8 <strcmp+0x18>
 3bc:	0f b6 db             	movzbl %bl,%ebx
 3bf:	0f b6 c0             	movzbl %al,%eax
 3c2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3c4:	5b                   	pop    %ebx
 3c5:	5d                   	pop    %ebp
 3c6:	c3                   	ret    
 3c7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3c8:	0f b6 1a             	movzbl (%edx),%ebx
 3cb:	31 c0                	xor    %eax,%eax
 3cd:	0f b6 db             	movzbl %bl,%ebx
 3d0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3d2:	5b                   	pop    %ebx
 3d3:	5d                   	pop    %ebp
 3d4:	c3                   	ret    
 3d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <strlen>:

uint
strlen(char *s)
{
 3e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 3e1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3e3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 3e5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3ea:	80 39 00             	cmpb   $0x0,(%ecx)
 3ed:	74 0c                	je     3fb <strlen+0x1b>
 3ef:	90                   	nop
 3f0:	83 c2 01             	add    $0x1,%edx
 3f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3f7:	89 d0                	mov    %edx,%eax
 3f9:	75 f5                	jne    3f0 <strlen+0x10>
    ;
  return n;
}
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    
 3fd:	8d 76 00             	lea    0x0(%esi),%esi

00000400 <memset>:

void*
memset(void *dst, int c, uint n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	8b 55 08             	mov    0x8(%ebp),%edx
 406:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 407:	8b 4d 10             	mov    0x10(%ebp),%ecx
 40a:	8b 45 0c             	mov    0xc(%ebp),%eax
 40d:	89 d7                	mov    %edx,%edi
 40f:	fc                   	cld    
 410:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 412:	89 d0                	mov    %edx,%eax
 414:	5f                   	pop    %edi
 415:	5d                   	pop    %ebp
 416:	c3                   	ret    
 417:	89 f6                	mov    %esi,%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000420 <strchr>:

char*
strchr(const char *s, char c)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 42a:	0f b6 10             	movzbl (%eax),%edx
 42d:	84 d2                	test   %dl,%dl
 42f:	75 11                	jne    442 <strchr+0x22>
 431:	eb 15                	jmp    448 <strchr+0x28>
 433:	90                   	nop
 434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 438:	83 c0 01             	add    $0x1,%eax
 43b:	0f b6 10             	movzbl (%eax),%edx
 43e:	84 d2                	test   %dl,%dl
 440:	74 06                	je     448 <strchr+0x28>
    if(*s == c)
 442:	38 ca                	cmp    %cl,%dl
 444:	75 f2                	jne    438 <strchr+0x18>
      return (char*)s;
  return 0;
}
 446:	5d                   	pop    %ebp
 447:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 448:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 44a:	5d                   	pop    %ebp
 44b:	90                   	nop
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 450:	c3                   	ret    
 451:	eb 0d                	jmp    460 <atoi>
 453:	90                   	nop
 454:	90                   	nop
 455:	90                   	nop
 456:	90                   	nop
 457:	90                   	nop
 458:	90                   	nop
 459:	90                   	nop
 45a:	90                   	nop
 45b:	90                   	nop
 45c:	90                   	nop
 45d:	90                   	nop
 45e:	90                   	nop
 45f:	90                   	nop

00000460 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 460:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 461:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 463:	89 e5                	mov    %esp,%ebp
 465:	8b 4d 08             	mov    0x8(%ebp),%ecx
 468:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 469:	0f b6 11             	movzbl (%ecx),%edx
 46c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 46f:	80 fb 09             	cmp    $0x9,%bl
 472:	77 1c                	ja     490 <atoi+0x30>
 474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 478:	0f be d2             	movsbl %dl,%edx
 47b:	83 c1 01             	add    $0x1,%ecx
 47e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 481:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 485:	0f b6 11             	movzbl (%ecx),%edx
 488:	8d 5a d0             	lea    -0x30(%edx),%ebx
 48b:	80 fb 09             	cmp    $0x9,%bl
 48e:	76 e8                	jbe    478 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 490:	5b                   	pop    %ebx
 491:	5d                   	pop    %ebp
 492:	c3                   	ret    
 493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	56                   	push   %esi
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	53                   	push   %ebx
 4a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ae:	85 db                	test   %ebx,%ebx
 4b0:	7e 14                	jle    4c6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 4b2:	31 d2                	xor    %edx,%edx
 4b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 4b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4bf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4c2:	39 da                	cmp    %ebx,%edx
 4c4:	75 f2                	jne    4b8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 4c6:	5b                   	pop    %ebx
 4c7:	5e                   	pop    %esi
 4c8:	5d                   	pop    %ebp
 4c9:	c3                   	ret    
 4ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004d0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 4d9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 4dc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 4df:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4eb:	00 
 4ec:	89 04 24             	mov    %eax,(%esp)
 4ef:	e8 d4 00 00 00       	call   5c8 <open>
  if(fd < 0)
 4f4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 4f8:	78 19                	js     513 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 4fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fd:	89 1c 24             	mov    %ebx,(%esp)
 500:	89 44 24 04          	mov    %eax,0x4(%esp)
 504:	e8 d7 00 00 00       	call   5e0 <fstat>
  close(fd);
 509:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 50c:	89 c6                	mov    %eax,%esi
  close(fd);
 50e:	e8 9d 00 00 00       	call   5b0 <close>
  return r;
}
 513:	89 f0                	mov    %esi,%eax
 515:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 518:	8b 75 fc             	mov    -0x4(%ebp),%esi
 51b:	89 ec                	mov    %ebp,%esp
 51d:	5d                   	pop    %ebp
 51e:	c3                   	ret    
 51f:	90                   	nop

00000520 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	31 f6                	xor    %esi,%esi
 527:	53                   	push   %ebx
 528:	83 ec 2c             	sub    $0x2c,%esp
 52b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 52e:	eb 06                	jmp    536 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 530:	3c 0a                	cmp    $0xa,%al
 532:	74 39                	je     56d <gets+0x4d>
 534:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 536:	8d 5e 01             	lea    0x1(%esi),%ebx
 539:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 53c:	7d 31                	jge    56f <gets+0x4f>
    cc = read(0, &c, 1);
 53e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 541:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 548:	00 
 549:	89 44 24 04          	mov    %eax,0x4(%esp)
 54d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 554:	e8 47 00 00 00       	call   5a0 <read>
    if(cc < 1)
 559:	85 c0                	test   %eax,%eax
 55b:	7e 12                	jle    56f <gets+0x4f>
      break;
    buf[i++] = c;
 55d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 561:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 565:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 569:	3c 0d                	cmp    $0xd,%al
 56b:	75 c3                	jne    530 <gets+0x10>
 56d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 56f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 573:	89 f8                	mov    %edi,%eax
 575:	83 c4 2c             	add    $0x2c,%esp
 578:	5b                   	pop    %ebx
 579:	5e                   	pop    %esi
 57a:	5f                   	pop    %edi
 57b:	5d                   	pop    %ebp
 57c:	c3                   	ret    
 57d:	90                   	nop
 57e:	90                   	nop
 57f:	90                   	nop

00000580 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 580:	b8 01 00 00 00       	mov    $0x1,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <exit>:
SYSCALL(exit)
 588:	b8 02 00 00 00       	mov    $0x2,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <wait>:
SYSCALL(wait)
 590:	b8 03 00 00 00       	mov    $0x3,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <pipe>:
SYSCALL(pipe)
 598:	b8 04 00 00 00       	mov    $0x4,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <read>:
SYSCALL(read)
 5a0:	b8 05 00 00 00       	mov    $0x5,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <write>:
SYSCALL(write)
 5a8:	b8 10 00 00 00       	mov    $0x10,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <close>:
SYSCALL(close)
 5b0:	b8 15 00 00 00       	mov    $0x15,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <kill>:
SYSCALL(kill)
 5b8:	b8 06 00 00 00       	mov    $0x6,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <exec>:
SYSCALL(exec)
 5c0:	b8 07 00 00 00       	mov    $0x7,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <open>:
SYSCALL(open)
 5c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <mknod>:
SYSCALL(mknod)
 5d0:	b8 11 00 00 00       	mov    $0x11,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <unlink>:
SYSCALL(unlink)
 5d8:	b8 12 00 00 00       	mov    $0x12,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <fstat>:
SYSCALL(fstat)
 5e0:	b8 08 00 00 00       	mov    $0x8,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <link>:
SYSCALL(link)
 5e8:	b8 13 00 00 00       	mov    $0x13,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <mkdir>:
SYSCALL(mkdir)
 5f0:	b8 14 00 00 00       	mov    $0x14,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <chdir>:
SYSCALL(chdir)
 5f8:	b8 09 00 00 00       	mov    $0x9,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <dup>:
SYSCALL(dup)
 600:	b8 0a 00 00 00       	mov    $0xa,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <getpid>:
SYSCALL(getpid)
 608:	b8 0b 00 00 00       	mov    $0xb,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <sbrk>:
SYSCALL(sbrk)
 610:	b8 0c 00 00 00       	mov    $0xc,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <sleep>:
SYSCALL(sleep)
 618:	b8 0d 00 00 00       	mov    $0xd,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <uptime>:
SYSCALL(uptime)
 620:	b8 0e 00 00 00       	mov    $0xe,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <gettime>:
SYSCALL(gettime)
 628:	b8 16 00 00 00       	mov    $0x16,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <shmget>:
SYSCALL(shmget)
 630:	b8 17 00 00 00       	mov    $0x17,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    
 638:	90                   	nop
 639:	90                   	nop
 63a:	90                   	nop
 63b:	90                   	nop
 63c:	90                   	nop
 63d:	90                   	nop
 63e:	90                   	nop
 63f:	90                   	nop

00000640 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	89 cf                	mov    %ecx,%edi
 646:	56                   	push   %esi
 647:	89 c6                	mov    %eax,%esi
 649:	53                   	push   %ebx
 64a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 64d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 650:	85 c9                	test   %ecx,%ecx
 652:	74 04                	je     658 <printint+0x18>
 654:	85 d2                	test   %edx,%edx
 656:	78 68                	js     6c0 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 658:	89 d0                	mov    %edx,%eax
 65a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 661:	31 c9                	xor    %ecx,%ecx
 663:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 666:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 668:	31 d2                	xor    %edx,%edx
 66a:	f7 f7                	div    %edi
 66c:	0f b6 92 36 0b 00 00 	movzbl 0xb36(%edx),%edx
 673:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 676:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 679:	85 c0                	test   %eax,%eax
 67b:	75 eb                	jne    668 <printint+0x28>
  if(neg)
 67d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 680:	85 c0                	test   %eax,%eax
 682:	74 08                	je     68c <printint+0x4c>
    buf[i++] = '-';
 684:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 689:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 68c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 68f:	90                   	nop
 690:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
 694:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 697:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 69e:	00 
 69f:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6a2:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6a5:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ac:	e8 f7 fe ff ff       	call   5a8 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6b1:	83 ff ff             	cmp    $0xffffffff,%edi
 6b4:	75 da                	jne    690 <printint+0x50>
    putc(fd, buf[i]);
}
 6b6:	83 c4 4c             	add    $0x4c,%esp
 6b9:	5b                   	pop    %ebx
 6ba:	5e                   	pop    %esi
 6bb:	5f                   	pop    %edi
 6bc:	5d                   	pop    %ebp
 6bd:	c3                   	ret    
 6be:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6c0:	89 d0                	mov    %edx,%eax
 6c2:	f7 d8                	neg    %eax
 6c4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 6cb:	eb 94                	jmp    661 <printint+0x21>
 6cd:	8d 76 00             	lea    0x0(%esi),%esi

000006d0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 6dc:	0f b6 10             	movzbl (%eax),%edx
 6df:	84 d2                	test   %dl,%dl
 6e1:	0f 84 c1 00 00 00    	je     7a8 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 6e7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 6ea:	31 ff                	xor    %edi,%edi
 6ec:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 6ef:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6f1:	8d 75 e7             	lea    -0x19(%ebp),%esi
 6f4:	eb 1e                	jmp    714 <printf+0x44>
 6f6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 6f8:	83 fa 25             	cmp    $0x25,%edx
 6fb:	0f 85 af 00 00 00    	jne    7b0 <printf+0xe0>
 701:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 705:	83 c3 01             	add    $0x1,%ebx
 708:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 70c:	84 d2                	test   %dl,%dl
 70e:	0f 84 94 00 00 00    	je     7a8 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
 714:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 716:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 719:	74 dd                	je     6f8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 71b:	83 ff 25             	cmp    $0x25,%edi
 71e:	75 e5                	jne    705 <printf+0x35>
      if(c == 'd'){
 720:	83 fa 64             	cmp    $0x64,%edx
 723:	0f 84 3f 01 00 00    	je     868 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 729:	83 fa 70             	cmp    $0x70,%edx
 72c:	0f 84 a6 00 00 00    	je     7d8 <printf+0x108>
 732:	83 fa 78             	cmp    $0x78,%edx
 735:	0f 84 9d 00 00 00    	je     7d8 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 73b:	83 fa 73             	cmp    $0x73,%edx
 73e:	66 90                	xchg   %ax,%ax
 740:	0f 84 ba 00 00 00    	je     800 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 746:	83 fa 63             	cmp    $0x63,%edx
 749:	0f 84 41 01 00 00    	je     890 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 74f:	83 fa 25             	cmp    $0x25,%edx
 752:	0f 84 00 01 00 00    	je     858 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 758:	8b 4d 08             	mov    0x8(%ebp),%ecx
 75b:	89 55 cc             	mov    %edx,-0x34(%ebp)
 75e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 762:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 769:	00 
 76a:	89 74 24 04          	mov    %esi,0x4(%esp)
 76e:	89 0c 24             	mov    %ecx,(%esp)
 771:	e8 32 fe ff ff       	call   5a8 <write>
 776:	8b 55 cc             	mov    -0x34(%ebp),%edx
 779:	88 55 e7             	mov    %dl,-0x19(%ebp)
 77c:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 77f:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 782:	31 ff                	xor    %edi,%edi
 784:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 78b:	00 
 78c:	89 74 24 04          	mov    %esi,0x4(%esp)
 790:	89 04 24             	mov    %eax,(%esp)
 793:	e8 10 fe ff ff       	call   5a8 <write>
 798:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 79b:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 79f:	84 d2                	test   %dl,%dl
 7a1:	0f 85 6d ff ff ff    	jne    714 <printf+0x44>
 7a7:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7a8:	83 c4 3c             	add    $0x3c,%esp
 7ab:	5b                   	pop    %ebx
 7ac:	5e                   	pop    %esi
 7ad:	5f                   	pop    %edi
 7ae:	5d                   	pop    %ebp
 7af:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7b0:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 7b3:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7b6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7bd:	00 
 7be:	89 74 24 04          	mov    %esi,0x4(%esp)
 7c2:	89 04 24             	mov    %eax,(%esp)
 7c5:	e8 de fd ff ff       	call   5a8 <write>
 7ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 7cd:	e9 33 ff ff ff       	jmp    705 <printf+0x35>
 7d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 7db:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 7e0:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 7e9:	8b 10                	mov    (%eax),%edx
 7eb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ee:	e8 4d fe ff ff       	call   640 <printint>
 7f3:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 7f6:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 7fa:	e9 06 ff ff ff       	jmp    705 <printf+0x35>
 7ff:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 800:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 803:	b9 2f 0b 00 00       	mov    $0xb2f,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 808:	8b 3a                	mov    (%edx),%edi
        ap++;
 80a:	83 c2 04             	add    $0x4,%edx
 80d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 810:	85 ff                	test   %edi,%edi
 812:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 815:	0f b6 17             	movzbl (%edi),%edx
 818:	84 d2                	test   %dl,%dl
 81a:	74 33                	je     84f <printf+0x17f>
 81c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 81f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 828:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 82b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 82e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 835:	00 
 836:	89 74 24 04          	mov    %esi,0x4(%esp)
 83a:	89 1c 24             	mov    %ebx,(%esp)
 83d:	e8 66 fd ff ff       	call   5a8 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 842:	0f b6 17             	movzbl (%edi),%edx
 845:	84 d2                	test   %dl,%dl
 847:	75 df                	jne    828 <printf+0x158>
 849:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 84c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 84f:	31 ff                	xor    %edi,%edi
 851:	e9 af fe ff ff       	jmp    705 <printf+0x35>
 856:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 858:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 85c:	e9 1b ff ff ff       	jmp    77c <printf+0xac>
 861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 868:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 86b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 870:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 873:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 87a:	8b 10                	mov    (%eax),%edx
 87c:	8b 45 08             	mov    0x8(%ebp),%eax
 87f:	e8 bc fd ff ff       	call   640 <printint>
 884:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 887:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 88b:	e9 75 fe ff ff       	jmp    705 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 890:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 893:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 895:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 898:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 89a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8a1:	00 
 8a2:	89 74 24 04          	mov    %esi,0x4(%esp)
 8a6:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8a9:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8ac:	e8 f7 fc ff ff       	call   5a8 <write>
 8b1:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 8b4:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 8b8:	e9 48 fe ff ff       	jmp    705 <printf+0x35>
 8bd:	90                   	nop
 8be:	90                   	nop
 8bf:	90                   	nop

000008c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c1:	a1 60 0b 00 00       	mov    0xb60,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c6:	89 e5                	mov    %esp,%ebp
 8c8:	57                   	push   %edi
 8c9:	56                   	push   %esi
 8ca:	53                   	push   %ebx
 8cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d1:	39 c8                	cmp    %ecx,%eax
 8d3:	73 1d                	jae    8f2 <free+0x32>
 8d5:	8d 76 00             	lea    0x0(%esi),%esi
 8d8:	8b 10                	mov    (%eax),%edx
 8da:	39 d1                	cmp    %edx,%ecx
 8dc:	72 1a                	jb     8f8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8de:	39 d0                	cmp    %edx,%eax
 8e0:	72 08                	jb     8ea <free+0x2a>
 8e2:	39 c8                	cmp    %ecx,%eax
 8e4:	72 12                	jb     8f8 <free+0x38>
 8e6:	39 d1                	cmp    %edx,%ecx
 8e8:	72 0e                	jb     8f8 <free+0x38>
 8ea:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ec:	39 c8                	cmp    %ecx,%eax
 8ee:	66 90                	xchg   %ax,%ax
 8f0:	72 e6                	jb     8d8 <free+0x18>
 8f2:	8b 10                	mov    (%eax),%edx
 8f4:	eb e8                	jmp    8de <free+0x1e>
 8f6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f8:	8b 71 04             	mov    0x4(%ecx),%esi
 8fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8fe:	39 d7                	cmp    %edx,%edi
 900:	74 19                	je     91b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 902:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 905:	8b 50 04             	mov    0x4(%eax),%edx
 908:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 90b:	39 ce                	cmp    %ecx,%esi
 90d:	74 23                	je     932 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 90f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 911:	a3 60 0b 00 00       	mov    %eax,0xb60
}
 916:	5b                   	pop    %ebx
 917:	5e                   	pop    %esi
 918:	5f                   	pop    %edi
 919:	5d                   	pop    %ebp
 91a:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 91b:	03 72 04             	add    0x4(%edx),%esi
 91e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 921:	8b 10                	mov    (%eax),%edx
 923:	8b 12                	mov    (%edx),%edx
 925:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 928:	8b 50 04             	mov    0x4(%eax),%edx
 92b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 92e:	39 ce                	cmp    %ecx,%esi
 930:	75 dd                	jne    90f <free+0x4f>
    p->s.size += bp->s.size;
 932:	03 51 04             	add    0x4(%ecx),%edx
 935:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 938:	8b 53 f8             	mov    -0x8(%ebx),%edx
 93b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 93d:	a3 60 0b 00 00       	mov    %eax,0xb60
}
 942:	5b                   	pop    %ebx
 943:	5e                   	pop    %esi
 944:	5f                   	pop    %edi
 945:	5d                   	pop    %ebp
 946:	c3                   	ret    
 947:	89 f6                	mov    %esi,%esi
 949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000950 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	57                   	push   %edi
 954:	56                   	push   %esi
 955:	53                   	push   %ebx
 956:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 959:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 95c:	8b 0d 60 0b 00 00    	mov    0xb60,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 962:	83 c3 07             	add    $0x7,%ebx
 965:	c1 eb 03             	shr    $0x3,%ebx
 968:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 96b:	85 c9                	test   %ecx,%ecx
 96d:	0f 84 9b 00 00 00    	je     a0e <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 973:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 975:	8b 50 04             	mov    0x4(%eax),%edx
 978:	39 d3                	cmp    %edx,%ebx
 97a:	76 27                	jbe    9a3 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 97c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 983:	be 00 80 00 00       	mov    $0x8000,%esi
 988:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 98b:	90                   	nop
 98c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 990:	3b 05 60 0b 00 00    	cmp    0xb60,%eax
 996:	74 30                	je     9c8 <malloc+0x78>
 998:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99a:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 99c:	8b 50 04             	mov    0x4(%eax),%edx
 99f:	39 d3                	cmp    %edx,%ebx
 9a1:	77 ed                	ja     990 <malloc+0x40>
      if(p->s.size == nunits)
 9a3:	39 d3                	cmp    %edx,%ebx
 9a5:	74 61                	je     a08 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 9a7:	29 da                	sub    %ebx,%edx
 9a9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9ac:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 9af:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 9b2:	89 0d 60 0b 00 00    	mov    %ecx,0xb60
      return (void*)(p + 1);
 9b8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9bb:	83 c4 2c             	add    $0x2c,%esp
 9be:	5b                   	pop    %ebx
 9bf:	5e                   	pop    %esi
 9c0:	5f                   	pop    %edi
 9c1:	5d                   	pop    %ebp
 9c2:	c3                   	ret    
 9c3:	90                   	nop
 9c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 9c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9cb:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 9d1:	bf 00 10 00 00       	mov    $0x1000,%edi
 9d6:	0f 43 fb             	cmovae %ebx,%edi
 9d9:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 9dc:	89 04 24             	mov    %eax,(%esp)
 9df:	e8 2c fc ff ff       	call   610 <sbrk>
  if(p == (char*)-1)
 9e4:	83 f8 ff             	cmp    $0xffffffff,%eax
 9e7:	74 18                	je     a01 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 9e9:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 9ec:	83 c0 08             	add    $0x8,%eax
 9ef:	89 04 24             	mov    %eax,(%esp)
 9f2:	e8 c9 fe ff ff       	call   8c0 <free>
  return freep;
 9f7:	8b 0d 60 0b 00 00    	mov    0xb60,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 9fd:	85 c9                	test   %ecx,%ecx
 9ff:	75 99                	jne    99a <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 a01:	31 c0                	xor    %eax,%eax
 a03:	eb b6                	jmp    9bb <malloc+0x6b>
 a05:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 a08:	8b 10                	mov    (%eax),%edx
 a0a:	89 11                	mov    %edx,(%ecx)
 a0c:	eb a4                	jmp    9b2 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a0e:	c7 05 60 0b 00 00 58 	movl   $0xb58,0xb60
 a15:	0b 00 00 
    base.s.size = 0;
 a18:	b9 58 0b 00 00       	mov    $0xb58,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a1d:	c7 05 58 0b 00 00 58 	movl   $0xb58,0xb58
 a24:	0b 00 00 
    base.s.size = 0;
 a27:	c7 05 5c 0b 00 00 00 	movl   $0x0,0xb5c
 a2e:	00 00 00 
 a31:	e9 3d ff ff ff       	jmp    973 <malloc+0x23>
 a36:	90                   	nop
 a37:	90                   	nop
 a38:	90                   	nop
 a39:	90                   	nop
 a3a:	90                   	nop
 a3b:	90                   	nop
 a3c:	90                   	nop
 a3d:	90                   	nop
 a3e:	90                   	nop
 a3f:	90                   	nop

00000a40 <ring_attach>:
#include "ring.h"

struct ring *ring_attach(uint token)
{
 a40:	55                   	push   %ebp
  return 0;
}
 a41:	31 c0                	xor    %eax,%eax
#include "ring.h"

struct ring *ring_attach(uint token)
{
 a43:	89 e5                	mov    %esp,%ebp
  return 0;
}
 a45:	5d                   	pop    %ebp
 a46:	c3                   	ret    
 a47:	89 f6                	mov    %esi,%esi
 a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a50 <ring_size>:

int ring_size(uint token)
{
 a50:	55                   	push   %ebp
  return 0;
}
 a51:	31 c0                	xor    %eax,%eax
{
  return 0;
}

int ring_size(uint token)
{
 a53:	89 e5                	mov    %esp,%ebp
  return 0;
}
 a55:	5d                   	pop    %ebp
 a56:	c3                   	ret    
 a57:	89 f6                	mov    %esi,%esi
 a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a60 <ring_detach>:

int ring_detach(uint token)
{
 a60:	55                   	push   %ebp
  return 0;
}
 a61:	31 c0                	xor    %eax,%eax
{
  return 0;
}

int ring_detach(uint token)
{
 a63:	89 e5                	mov    %esp,%ebp
  return 0;
}
 a65:	5d                   	pop    %ebp
 a66:	c3                   	ret    
 a67:	89 f6                	mov    %esi,%esi
 a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a70 <ring_write_reserve>:

struct ring_res ring_write_reserve(struct ring *r, int bytes)
{
 a70:	55                   	push   %ebp
 a71:	89 e5                	mov    %esp,%ebp
 a73:	8b 45 08             	mov    0x8(%ebp),%eax
  struct ring_res ret = {0, 0};
  return ret;
 a76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 a7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 a83:	5d                   	pop    %ebp
 a84:	c2 04 00             	ret    $0x4
 a87:	89 f6                	mov    %esi,%esi
 a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a90 <ring_write_notify>:

void ring_write_notify(struct ring *r, int bytes)
{
 a90:	55                   	push   %ebp
 a91:	89 e5                	mov    %esp,%ebp

}
 a93:	5d                   	pop    %ebp
 a94:	c3                   	ret    
 a95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000aa0 <ring_read_reserve>:

struct ring_res ring_read_reserve(struct ring *r, int bytes)
{
 aa0:	55                   	push   %ebp
 aa1:	89 e5                	mov    %esp,%ebp
 aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  struct ring_res ret = {0, 0};
  return ret;
 aa6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 aad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 ab3:	5d                   	pop    %ebp
 ab4:	c2 04 00             	ret    $0x4
 ab7:	89 f6                	mov    %esi,%esi
 ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000ac0 <ring_read_notify>:

void ring_read_notify(struct ring *r, int bytes)
{
 ac0:	55                   	push   %ebp
 ac1:	89 e5                	mov    %esp,%ebp

}
 ac3:	5d                   	pop    %ebp
 ac4:	c3                   	ret    
 ac5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000ad0 <ring_write>:

void ring_write(struct ring *r, void *buf, int bytes)
{
 ad0:	55                   	push   %ebp
 ad1:	89 e5                	mov    %esp,%ebp

}
 ad3:	5d                   	pop    %ebp
 ad4:	c3                   	ret    
 ad5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000ae0 <ring_read>:

void ring_read(struct ring *r, void *buf, int bytes)
{
 ae0:	55                   	push   %ebp
 ae1:	89 e5                	mov    %esp,%ebp

}
 ae3:	5d                   	pop    %ebp
 ae4:	c3                   	ret    
