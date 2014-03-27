
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 45                	jmp    58 <main+0x58>
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 0b 08 00 00       	mov    $0x80b,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 0d 08 00 00       	mov    $0x80d,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	c1 e2 02             	shl    $0x2,%edx
  32:	03 55 0c             	add    0xc(%ebp),%edx
  35:	8b 12                	mov    (%edx),%edx
  37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  3f:	c7 44 24 04 0f 08 00 	movl   $0x80f,0x4(%esp)
  46:	00 
  47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4e:	e8 f2 03 00 00       	call   445 <printf>
  53:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  58:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  5f:	7c b2                	jl     13 <main+0x13>
  61:	e8 66 02 00 00       	call   2cc <exit>
  66:	66 90                	xchg   %ax,%ax

00000068 <stosb>:
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	57                   	push   %edi
  6c:	53                   	push   %ebx
  6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  70:	8b 55 10             	mov    0x10(%ebp),%edx
  73:	8b 45 0c             	mov    0xc(%ebp),%eax
  76:	89 cb                	mov    %ecx,%ebx
  78:	89 df                	mov    %ebx,%edi
  7a:	89 d1                	mov    %edx,%ecx
  7c:	fc                   	cld    
  7d:	f3 aa                	rep stos %al,%es:(%edi)
  7f:	89 ca                	mov    %ecx,%edx
  81:	89 fb                	mov    %edi,%ebx
  83:	89 5d 08             	mov    %ebx,0x8(%ebp)
  86:	89 55 10             	mov    %edx,0x10(%ebp)
  89:	5b                   	pop    %ebx
  8a:	5f                   	pop    %edi
  8b:	5d                   	pop    %ebp
  8c:	c3                   	ret    

0000008d <strcpy>:
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	83 ec 10             	sub    $0x10,%esp
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  99:	8b 45 0c             	mov    0xc(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	88 10                	mov    %dl,(%eax)
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	0f b6 00             	movzbl (%eax),%eax
  aa:	84 c0                	test   %al,%al
  ac:	0f 95 c0             	setne  %al
  af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  b7:	84 c0                	test   %al,%al
  b9:	75 de                	jne    99 <strcpy+0xc>
  bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  be:	c9                   	leave  
  bf:	c3                   	ret    

000000c0 <strcmp>:
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	eb 08                	jmp    cd <strcmp+0xd>
  c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	0f b6 00             	movzbl (%eax),%eax
  d3:	84 c0                	test   %al,%al
  d5:	74 10                	je     e7 <strcmp+0x27>
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 10             	movzbl (%eax),%edx
  dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  e0:	0f b6 00             	movzbl (%eax),%eax
  e3:	38 c2                	cmp    %al,%dl
  e5:	74 de                	je     c5 <strcmp+0x5>
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	0f b6 d0             	movzbl %al,%edx
  f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  f3:	0f b6 00             	movzbl (%eax),%eax
  f6:	0f b6 c0             	movzbl %al,%eax
  f9:	89 d1                	mov    %edx,%ecx
  fb:	29 c1                	sub    %eax,%ecx
  fd:	89 c8                	mov    %ecx,%eax
  ff:	5d                   	pop    %ebp
 100:	c3                   	ret    

00000101 <strlen>:
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 ec 10             	sub    $0x10,%esp
 107:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10e:	eb 04                	jmp    114 <strlen+0x13>
 110:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 114:	8b 45 fc             	mov    -0x4(%ebp),%eax
 117:	03 45 08             	add    0x8(%ebp),%eax
 11a:	0f b6 00             	movzbl (%eax),%eax
 11d:	84 c0                	test   %al,%al
 11f:	75 ef                	jne    110 <strlen+0xf>
 121:	8b 45 fc             	mov    -0x4(%ebp),%eax
 124:	c9                   	leave  
 125:	c3                   	ret    

00000126 <memset>:
 126:	55                   	push   %ebp
 127:	89 e5                	mov    %esp,%ebp
 129:	83 ec 0c             	sub    $0xc,%esp
 12c:	8b 45 10             	mov    0x10(%ebp),%eax
 12f:	89 44 24 08          	mov    %eax,0x8(%esp)
 133:	8b 45 0c             	mov    0xc(%ebp),%eax
 136:	89 44 24 04          	mov    %eax,0x4(%esp)
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	89 04 24             	mov    %eax,(%esp)
 140:	e8 23 ff ff ff       	call   68 <stosb>
 145:	8b 45 08             	mov    0x8(%ebp),%eax
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strchr>:
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
 156:	eb 14                	jmp    16c <strchr+0x22>
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 161:	75 05                	jne    168 <strchr+0x1e>
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
 176:	b8 00 00 00 00       	mov    $0x0,%eax
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <gets>:
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 28             	sub    $0x28,%esp
 183:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 18a:	eb 44                	jmp    1d0 <gets+0x53>
 18c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 193:	00 
 194:	8d 45 ef             	lea    -0x11(%ebp),%eax
 197:	89 44 24 04          	mov    %eax,0x4(%esp)
 19b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a2:	e8 3d 01 00 00       	call   2e4 <read>
 1a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 1aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ae:	7e 2d                	jle    1dd <gets+0x60>
 1b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1b3:	03 45 08             	add    0x8(%ebp),%eax
 1b6:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1ba:	88 10                	mov    %dl,(%eax)
 1bc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 1c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c4:	3c 0a                	cmp    $0xa,%al
 1c6:	74 16                	je     1de <gets+0x61>
 1c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cc:	3c 0d                	cmp    $0xd,%al
 1ce:	74 0e                	je     1de <gets+0x61>
 1d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1d3:	83 c0 01             	add    $0x1,%eax
 1d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d9:	7c b1                	jl     18c <gets+0xf>
 1db:	eb 01                	jmp    1de <gets+0x61>
 1dd:	90                   	nop
 1de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1e1:	03 45 08             	add    0x8(%ebp),%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <stat>:
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 28             	sub    $0x28,%esp
 1f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1f9:	00 
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	89 04 24             	mov    %eax,(%esp)
 200:	e8 07 01 00 00       	call   30c <open>
 205:	89 45 f0             	mov    %eax,-0x10(%ebp)
 208:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 20c:	79 07                	jns    215 <stat+0x29>
 20e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 213:	eb 23                	jmp    238 <stat+0x4c>
 215:	8b 45 0c             	mov    0xc(%ebp),%eax
 218:	89 44 24 04          	mov    %eax,0x4(%esp)
 21c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 21f:	89 04 24             	mov    %eax,(%esp)
 222:	e8 fd 00 00 00       	call   324 <fstat>
 227:	89 45 f4             	mov    %eax,-0xc(%ebp)
 22a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 22d:	89 04 24             	mov    %eax,(%esp)
 230:	e8 bf 00 00 00       	call   2f4 <close>
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	c9                   	leave  
 239:	c3                   	ret    

0000023a <atoi>:
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	83 ec 10             	sub    $0x10,%esp
 240:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 247:	eb 24                	jmp    26d <atoi+0x33>
 249:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24c:	89 d0                	mov    %edx,%eax
 24e:	c1 e0 02             	shl    $0x2,%eax
 251:	01 d0                	add    %edx,%eax
 253:	01 c0                	add    %eax,%eax
 255:	89 c2                	mov    %eax,%edx
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	0f b6 00             	movzbl (%eax),%eax
 25d:	0f be c0             	movsbl %al,%eax
 260:	8d 04 02             	lea    (%edx,%eax,1),%eax
 263:	83 e8 30             	sub    $0x30,%eax
 266:	89 45 fc             	mov    %eax,-0x4(%ebp)
 269:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x47>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c8                	jle    249 <atoi+0xf>
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memmove>:
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 f8             	mov    %eax,-0x8(%ebp)
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 fc             	mov    %eax,-0x4(%ebp)
 298:	eb 13                	jmp    2ad <memmove+0x27>
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29d:	0f b6 10             	movzbl (%eax),%edx
 2a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2a3:	88 10                	mov    %dl,(%eax)
 2a5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2b1:	0f 9f c0             	setg   %al
 2b4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2b8:	84 c0                	test   %al,%al
 2ba:	75 de                	jne    29a <memmove+0x14>
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    
 2c1:	66 90                	xchg   %ax,%ax
 2c3:	90                   	nop

000002c4 <fork>:
 2c4:	b8 01 00 00 00       	mov    $0x1,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <exit>:
 2cc:	b8 02 00 00 00       	mov    $0x2,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <wait>:
 2d4:	b8 03 00 00 00       	mov    $0x3,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <pipe>:
 2dc:	b8 04 00 00 00       	mov    $0x4,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <read>:
 2e4:	b8 05 00 00 00       	mov    $0x5,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <write>:
 2ec:	b8 10 00 00 00       	mov    $0x10,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <close>:
 2f4:	b8 15 00 00 00       	mov    $0x15,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <kill>:
 2fc:	b8 06 00 00 00       	mov    $0x6,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <exec>:
 304:	b8 07 00 00 00       	mov    $0x7,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <open>:
 30c:	b8 0f 00 00 00       	mov    $0xf,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <mknod>:
 314:	b8 11 00 00 00       	mov    $0x11,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <unlink>:
 31c:	b8 12 00 00 00       	mov    $0x12,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <fstat>:
 324:	b8 08 00 00 00       	mov    $0x8,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <link>:
 32c:	b8 13 00 00 00       	mov    $0x13,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <mkdir>:
 334:	b8 14 00 00 00       	mov    $0x14,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <chdir>:
 33c:	b8 09 00 00 00       	mov    $0x9,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <dup>:
 344:	b8 0a 00 00 00       	mov    $0xa,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <getpid>:
 34c:	b8 0b 00 00 00       	mov    $0xb,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <sbrk>:
 354:	b8 0c 00 00 00       	mov    $0xc,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <sleep>:
 35c:	b8 0d 00 00 00       	mov    $0xd,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <uptime>:
 364:	b8 0e 00 00 00       	mov    $0xe,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <putc>:
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 28             	sub    $0x28,%esp
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	88 45 f4             	mov    %al,-0xc(%ebp)
 378:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 37f:	00 
 380:	8d 45 f4             	lea    -0xc(%ebp),%eax
 383:	89 44 24 04          	mov    %eax,0x4(%esp)
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	89 04 24             	mov    %eax,(%esp)
 38d:	e8 5a ff ff ff       	call   2ec <write>
 392:	c9                   	leave  
 393:	c3                   	ret    

00000394 <printint>:
 394:	55                   	push   %ebp
 395:	89 e5                	mov    %esp,%ebp
 397:	53                   	push   %ebx
 398:	83 ec 44             	sub    $0x44,%esp
 39b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 3a2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a6:	74 17                	je     3bf <printint+0x2b>
 3a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ac:	79 11                	jns    3bf <printint+0x2b>
 3ae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
 3b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b8:	f7 d8                	neg    %eax
 3ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3bd:	eb 06                	jmp    3c5 <printint+0x31>
 3bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 3cc:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 3cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d5:	ba 00 00 00 00       	mov    $0x0,%edx
 3da:	f7 f3                	div    %ebx
 3dc:	89 d0                	mov    %edx,%eax
 3de:	0f b6 80 1c 08 00 00 	movzbl 0x81c(%eax),%eax
 3e5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 3e9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 3ed:	8b 45 10             	mov    0x10(%ebp),%eax
 3f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f6:	ba 00 00 00 00       	mov    $0x0,%edx
 3fb:	f7 75 d4             	divl   -0x2c(%ebp)
 3fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
 401:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 405:	75 c5                	jne    3cc <printint+0x38>
 407:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 40b:	74 28                	je     435 <printint+0xa1>
 40d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 410:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 415:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 419:	eb 1a                	jmp    435 <printint+0xa1>
 41b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41e:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 423:	0f be c0             	movsbl %al,%eax
 426:	89 44 24 04          	mov    %eax,0x4(%esp)
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	89 04 24             	mov    %eax,(%esp)
 430:	e8 37 ff ff ff       	call   36c <putc>
 435:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 439:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43d:	79 dc                	jns    41b <printint+0x87>
 43f:	83 c4 44             	add    $0x44,%esp
 442:	5b                   	pop    %ebx
 443:	5d                   	pop    %ebp
 444:	c3                   	ret    

00000445 <printf>:
 445:	55                   	push   %ebp
 446:	89 e5                	mov    %esp,%ebp
 448:	83 ec 38             	sub    $0x38,%esp
 44b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 452:	8d 45 0c             	lea    0xc(%ebp),%eax
 455:	83 c0 04             	add    $0x4,%eax
 458:	89 45 f4             	mov    %eax,-0xc(%ebp)
 45b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 462:	e9 7e 01 00 00       	jmp    5e5 <printf+0x1a0>
 467:	8b 55 0c             	mov    0xc(%ebp),%edx
 46a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46d:	8d 04 02             	lea    (%edx,%eax,1),%eax
 470:	0f b6 00             	movzbl (%eax),%eax
 473:	0f be c0             	movsbl %al,%eax
 476:	25 ff 00 00 00       	and    $0xff,%eax
 47b:	89 45 e8             	mov    %eax,-0x18(%ebp)
 47e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 482:	75 2c                	jne    4b0 <printf+0x6b>
 484:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 488:	75 0c                	jne    496 <printf+0x51>
 48a:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 491:	e9 4b 01 00 00       	jmp    5e1 <printf+0x19c>
 496:	8b 45 e8             	mov    -0x18(%ebp),%eax
 499:	0f be c0             	movsbl %al,%eax
 49c:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a0:	8b 45 08             	mov    0x8(%ebp),%eax
 4a3:	89 04 24             	mov    %eax,(%esp)
 4a6:	e8 c1 fe ff ff       	call   36c <putc>
 4ab:	e9 31 01 00 00       	jmp    5e1 <printf+0x19c>
 4b0:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 4b4:	0f 85 27 01 00 00    	jne    5e1 <printf+0x19c>
 4ba:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 4be:	75 2d                	jne    4ed <printf+0xa8>
 4c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c3:	8b 00                	mov    (%eax),%eax
 4c5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4cc:	00 
 4cd:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4d4:	00 
 4d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d9:	8b 45 08             	mov    0x8(%ebp),%eax
 4dc:	89 04 24             	mov    %eax,(%esp)
 4df:	e8 b0 fe ff ff       	call   394 <printint>
 4e4:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 4e8:	e9 ed 00 00 00       	jmp    5da <printf+0x195>
 4ed:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 4f1:	74 06                	je     4f9 <printf+0xb4>
 4f3:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 4f7:	75 2d                	jne    526 <printf+0xe1>
 4f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fc:	8b 00                	mov    (%eax),%eax
 4fe:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 505:	00 
 506:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 50d:	00 
 50e:	89 44 24 04          	mov    %eax,0x4(%esp)
 512:	8b 45 08             	mov    0x8(%ebp),%eax
 515:	89 04 24             	mov    %eax,(%esp)
 518:	e8 77 fe ff ff       	call   394 <printint>
 51d:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 521:	e9 b4 00 00 00       	jmp    5da <printf+0x195>
 526:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 52a:	75 46                	jne    572 <printf+0x12d>
 52c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52f:	8b 00                	mov    (%eax),%eax
 531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 534:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 538:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 53c:	75 27                	jne    565 <printf+0x120>
 53e:	c7 45 e4 14 08 00 00 	movl   $0x814,-0x1c(%ebp)
 545:	eb 1f                	jmp    566 <printf+0x121>
 547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54a:	0f b6 00             	movzbl (%eax),%eax
 54d:	0f be c0             	movsbl %al,%eax
 550:	89 44 24 04          	mov    %eax,0x4(%esp)
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	89 04 24             	mov    %eax,(%esp)
 55a:	e8 0d fe ff ff       	call   36c <putc>
 55f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 563:	eb 01                	jmp    566 <printf+0x121>
 565:	90                   	nop
 566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 569:	0f b6 00             	movzbl (%eax),%eax
 56c:	84 c0                	test   %al,%al
 56e:	75 d7                	jne    547 <printf+0x102>
 570:	eb 68                	jmp    5da <printf+0x195>
 572:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 576:	75 1d                	jne    595 <printf+0x150>
 578:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57b:	8b 00                	mov    (%eax),%eax
 57d:	0f be c0             	movsbl %al,%eax
 580:	89 44 24 04          	mov    %eax,0x4(%esp)
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	89 04 24             	mov    %eax,(%esp)
 58a:	e8 dd fd ff ff       	call   36c <putc>
 58f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 593:	eb 45                	jmp    5da <printf+0x195>
 595:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 599:	75 17                	jne    5b2 <printf+0x16d>
 59b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59e:	0f be c0             	movsbl %al,%eax
 5a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a5:	8b 45 08             	mov    0x8(%ebp),%eax
 5a8:	89 04 24             	mov    %eax,(%esp)
 5ab:	e8 bc fd ff ff       	call   36c <putc>
 5b0:	eb 28                	jmp    5da <printf+0x195>
 5b2:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5b9:	00 
 5ba:	8b 45 08             	mov    0x8(%ebp),%eax
 5bd:	89 04 24             	mov    %eax,(%esp)
 5c0:	e8 a7 fd ff ff       	call   36c <putc>
 5c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c8:	0f be c0             	movsbl %al,%eax
 5cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	89 04 24             	mov    %eax,(%esp)
 5d5:	e8 92 fd ff ff       	call   36c <putc>
 5da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5e1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 5e5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5eb:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5ee:	0f b6 00             	movzbl (%eax),%eax
 5f1:	84 c0                	test   %al,%al
 5f3:	0f 85 6e fe ff ff    	jne    467 <printf+0x22>
 5f9:	c9                   	leave  
 5fa:	c3                   	ret    
 5fb:	90                   	nop

000005fc <free>:
 5fc:	55                   	push   %ebp
 5fd:	89 e5                	mov    %esp,%ebp
 5ff:	83 ec 10             	sub    $0x10,%esp
 602:	8b 45 08             	mov    0x8(%ebp),%eax
 605:	83 e8 08             	sub    $0x8,%eax
 608:	89 45 f8             	mov    %eax,-0x8(%ebp)
 60b:	a1 38 08 00 00       	mov    0x838,%eax
 610:	89 45 fc             	mov    %eax,-0x4(%ebp)
 613:	eb 24                	jmp    639 <free+0x3d>
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61d:	77 12                	ja     631 <free+0x35>
 61f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 622:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 625:	77 24                	ja     64b <free+0x4f>
 627:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62a:	8b 00                	mov    (%eax),%eax
 62c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62f:	77 1a                	ja     64b <free+0x4f>
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	89 45 fc             	mov    %eax,-0x4(%ebp)
 639:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63f:	76 d4                	jbe    615 <free+0x19>
 641:	8b 45 fc             	mov    -0x4(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 649:	76 ca                	jbe    615 <free+0x19>
 64b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64e:	8b 40 04             	mov    0x4(%eax),%eax
 651:	c1 e0 03             	shl    $0x3,%eax
 654:	89 c2                	mov    %eax,%edx
 656:	03 55 f8             	add    -0x8(%ebp),%edx
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	39 c2                	cmp    %eax,%edx
 660:	75 24                	jne    686 <free+0x8a>
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	8b 50 04             	mov    0x4(%eax),%edx
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	8b 40 04             	mov    0x4(%eax),%eax
 670:	01 c2                	add    %eax,%edx
 672:	8b 45 f8             	mov    -0x8(%ebp),%eax
 675:	89 50 04             	mov    %edx,0x4(%eax)
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	8b 10                	mov    (%eax),%edx
 67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 682:	89 10                	mov    %edx,(%eax)
 684:	eb 0a                	jmp    690 <free+0x94>
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	89 10                	mov    %edx,(%eax)
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 40 04             	mov    0x4(%eax),%eax
 696:	c1 e0 03             	shl    $0x3,%eax
 699:	03 45 fc             	add    -0x4(%ebp),%eax
 69c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69f:	75 20                	jne    6c1 <free+0xc5>
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 50 04             	mov    0x4(%eax),%edx
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	8b 40 04             	mov    0x4(%eax),%eax
 6ad:	01 c2                	add    %eax,%edx
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	89 50 04             	mov    %edx,0x4(%eax)
 6b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b8:	8b 10                	mov    (%eax),%edx
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	89 10                	mov    %edx,(%eax)
 6bf:	eb 08                	jmp    6c9 <free+0xcd>
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c7:	89 10                	mov    %edx,(%eax)
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	a3 38 08 00 00       	mov    %eax,0x838
 6d1:	c9                   	leave  
 6d2:	c3                   	ret    

000006d3 <morecore>:
 6d3:	55                   	push   %ebp
 6d4:	89 e5                	mov    %esp,%ebp
 6d6:	83 ec 28             	sub    $0x28,%esp
 6d9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e0:	77 07                	ja     6e9 <morecore+0x16>
 6e2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ec:	c1 e0 03             	shl    $0x3,%eax
 6ef:	89 04 24             	mov    %eax,(%esp)
 6f2:	e8 5d fc ff ff       	call   354 <sbrk>
 6f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6fa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 6fe:	75 07                	jne    707 <morecore+0x34>
 700:	b8 00 00 00 00       	mov    $0x0,%eax
 705:	eb 22                	jmp    729 <morecore+0x56>
 707:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 70d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 710:	8b 55 08             	mov    0x8(%ebp),%edx
 713:	89 50 04             	mov    %edx,0x4(%eax)
 716:	8b 45 f4             	mov    -0xc(%ebp),%eax
 719:	83 c0 08             	add    $0x8,%eax
 71c:	89 04 24             	mov    %eax,(%esp)
 71f:	e8 d8 fe ff ff       	call   5fc <free>
 724:	a1 38 08 00 00       	mov    0x838,%eax
 729:	c9                   	leave  
 72a:	c3                   	ret    

0000072b <malloc>:
 72b:	55                   	push   %ebp
 72c:	89 e5                	mov    %esp,%ebp
 72e:	83 ec 28             	sub    $0x28,%esp
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	83 c0 07             	add    $0x7,%eax
 737:	c1 e8 03             	shr    $0x3,%eax
 73a:	83 c0 01             	add    $0x1,%eax
 73d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 740:	a1 38 08 00 00       	mov    0x838,%eax
 745:	89 45 f0             	mov    %eax,-0x10(%ebp)
 748:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74c:	75 23                	jne    771 <malloc+0x46>
 74e:	c7 45 f0 30 08 00 00 	movl   $0x830,-0x10(%ebp)
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	a3 38 08 00 00       	mov    %eax,0x838
 75d:	a1 38 08 00 00       	mov    0x838,%eax
 762:	a3 30 08 00 00       	mov    %eax,0x830
 767:	c7 05 34 08 00 00 00 	movl   $0x0,0x834
 76e:	00 00 00 
 771:	8b 45 f0             	mov    -0x10(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	89 45 ec             	mov    %eax,-0x14(%ebp)
 779:	8b 45 ec             	mov    -0x14(%ebp),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 782:	72 4d                	jb     7d1 <malloc+0xa6>
 784:	8b 45 ec             	mov    -0x14(%ebp),%eax
 787:	8b 40 04             	mov    0x4(%eax),%eax
 78a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 78d:	75 0c                	jne    79b <malloc+0x70>
 78f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 792:	8b 10                	mov    (%eax),%edx
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	89 10                	mov    %edx,(%eax)
 799:	eb 26                	jmp    7c1 <malloc+0x96>
 79b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 79e:	8b 40 04             	mov    0x4(%eax),%eax
 7a1:	89 c2                	mov    %eax,%edx
 7a3:	2b 55 f4             	sub    -0xc(%ebp),%edx
 7a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a9:	89 50 04             	mov    %edx,0x4(%eax)
 7ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	c1 e0 03             	shl    $0x3,%eax
 7b5:	01 45 ec             	add    %eax,-0x14(%ebp)
 7b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7be:	89 50 04             	mov    %edx,0x4(%eax)
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	a3 38 08 00 00       	mov    %eax,0x838
 7c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7cc:	83 c0 08             	add    $0x8,%eax
 7cf:	eb 38                	jmp    809 <malloc+0xde>
 7d1:	a1 38 08 00 00       	mov    0x838,%eax
 7d6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7d9:	75 1b                	jne    7f6 <malloc+0xcb>
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	89 04 24             	mov    %eax,(%esp)
 7e1:	e8 ed fe ff ff       	call   6d3 <morecore>
 7e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ed:	75 07                	jne    7f6 <malloc+0xcb>
 7ef:	b8 00 00 00 00       	mov    $0x0,%eax
 7f4:	eb 13                	jmp    809 <malloc+0xde>
 7f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ff:	8b 00                	mov    (%eax),%eax
 801:	89 45 ec             	mov    %eax,-0x14(%ebp)
 804:	e9 70 ff ff ff       	jmp    779 <malloc+0x4e>
 809:	c9                   	leave  
 80a:	c3                   	ret    
