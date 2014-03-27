
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 be 08 00 00 	movl   $0x8be,(%esp)
  18:	e8 9f 03 00 00       	call   3bc <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 be 08 00 00 	movl   $0x8be,(%esp)
  38:	e8 87 03 00 00       	call   3c4 <mknod>
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 be 08 00 00 	movl   $0x8be,(%esp)
  4c:	e8 6b 03 00 00       	call   3bc <open>
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 97 03 00 00       	call   3f4 <dup>
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 8b 03 00 00       	call   3f4 <dup>
  69:	eb 01                	jmp    6c <main+0x6c>
  6b:	90                   	nop
  6c:	c7 44 24 04 c6 08 00 	movl   $0x8c6,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 75 04 00 00       	call   4f5 <printf>
  80:	e8 ef 02 00 00       	call   374 <fork>
  85:	89 44 24 18          	mov    %eax,0x18(%esp)
  89:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
  90:	c7 44 24 04 d9 08 00 	movl   $0x8d9,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 51 04 00 00       	call   4f5 <printf>
  a4:	e8 d3 02 00 00       	call   37c <exit>
  a9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  ae:	75 43                	jne    f3 <main+0xf3>
  b0:	c7 44 24 04 14 09 00 	movl   $0x914,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 bb 08 00 00 	movl   $0x8bb,(%esp)
  bf:	e8 f0 02 00 00       	call   3b4 <exec>
  c4:	c7 44 24 04 ec 08 00 	movl   $0x8ec,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 1d 04 00 00       	call   4f5 <printf>
  d8:	e8 9f 02 00 00       	call   37c <exit>
  dd:	c7 44 24 04 02 09 00 	movl   $0x902,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 04 04 00 00       	call   4f5 <printf>
  f1:	eb 01                	jmp    f4 <main+0xf4>
  f3:	90                   	nop
  f4:	e8 8b 02 00 00       	call   384 <wait>
  f9:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  fd:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 102:	0f 88 63 ff ff ff    	js     6b <main+0x6b>
 108:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10c:	3b 44 24 18          	cmp    0x18(%esp),%eax
 110:	75 cb                	jne    dd <main+0xdd>
 112:	e9 55 ff ff ff       	jmp    6c <main+0x6c>
 117:	90                   	nop

00000118 <stosb>:
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	57                   	push   %edi
 11c:	53                   	push   %ebx
 11d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 120:	8b 55 10             	mov    0x10(%ebp),%edx
 123:	8b 45 0c             	mov    0xc(%ebp),%eax
 126:	89 cb                	mov    %ecx,%ebx
 128:	89 df                	mov    %ebx,%edi
 12a:	89 d1                	mov    %edx,%ecx
 12c:	fc                   	cld    
 12d:	f3 aa                	rep stos %al,%es:(%edi)
 12f:	89 ca                	mov    %ecx,%edx
 131:	89 fb                	mov    %edi,%ebx
 133:	89 5d 08             	mov    %ebx,0x8(%ebp)
 136:	89 55 10             	mov    %edx,0x10(%ebp)
 139:	5b                   	pop    %ebx
 13a:	5f                   	pop    %edi
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <strcpy>:
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	83 ec 10             	sub    $0x10,%esp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	89 45 fc             	mov    %eax,-0x4(%ebp)
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	0f b6 10             	movzbl (%eax),%edx
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	88 10                	mov    %dl,(%eax)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	84 c0                	test   %al,%al
 15c:	0f 95 c0             	setne  %al
 15f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 163:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 167:	84 c0                	test   %al,%al
 169:	75 de                	jne    149 <strcpy+0xc>
 16b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 16e:	c9                   	leave  
 16f:	c3                   	ret    

00000170 <strcmp>:
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	eb 08                	jmp    17d <strcmp+0xd>
 175:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 179:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	0f b6 00             	movzbl (%eax),%eax
 183:	84 c0                	test   %al,%al
 185:	74 10                	je     197 <strcmp+0x27>
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	0f b6 10             	movzbl (%eax),%edx
 18d:	8b 45 0c             	mov    0xc(%ebp),%eax
 190:	0f b6 00             	movzbl (%eax),%eax
 193:	38 c2                	cmp    %al,%dl
 195:	74 de                	je     175 <strcmp+0x5>
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	0f b6 00             	movzbl (%eax),%eax
 19d:	0f b6 d0             	movzbl %al,%edx
 1a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	0f b6 c0             	movzbl %al,%eax
 1a9:	89 d1                	mov    %edx,%ecx
 1ab:	29 c1                	sub    %eax,%ecx
 1ad:	89 c8                	mov    %ecx,%eax
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <strlen>:
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	83 ec 10             	sub    $0x10,%esp
 1b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1be:	eb 04                	jmp    1c4 <strlen+0x13>
 1c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1c7:	03 45 08             	add    0x8(%ebp),%eax
 1ca:	0f b6 00             	movzbl (%eax),%eax
 1cd:	84 c0                	test   %al,%al
 1cf:	75 ef                	jne    1c0 <strlen+0xf>
 1d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1d4:	c9                   	leave  
 1d5:	c3                   	ret    

000001d6 <memset>:
 1d6:	55                   	push   %ebp
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	83 ec 0c             	sub    $0xc,%esp
 1dc:	8b 45 10             	mov    0x10(%ebp),%eax
 1df:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	89 04 24             	mov    %eax,(%esp)
 1f0:	e8 23 ff ff ff       	call   118 <stosb>
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	c9                   	leave  
 1f9:	c3                   	ret    

000001fa <strchr>:
 1fa:	55                   	push   %ebp
 1fb:	89 e5                	mov    %esp,%ebp
 1fd:	83 ec 04             	sub    $0x4,%esp
 200:	8b 45 0c             	mov    0xc(%ebp),%eax
 203:	88 45 fc             	mov    %al,-0x4(%ebp)
 206:	eb 14                	jmp    21c <strchr+0x22>
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	0f b6 00             	movzbl (%eax),%eax
 20e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 211:	75 05                	jne    218 <strchr+0x1e>
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	eb 13                	jmp    22b <strchr+0x31>
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	0f b6 00             	movzbl (%eax),%eax
 222:	84 c0                	test   %al,%al
 224:	75 e2                	jne    208 <strchr+0xe>
 226:	b8 00 00 00 00       	mov    $0x0,%eax
 22b:	c9                   	leave  
 22c:	c3                   	ret    

0000022d <gets>:
 22d:	55                   	push   %ebp
 22e:	89 e5                	mov    %esp,%ebp
 230:	83 ec 28             	sub    $0x28,%esp
 233:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 23a:	eb 44                	jmp    280 <gets+0x53>
 23c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 243:	00 
 244:	8d 45 ef             	lea    -0x11(%ebp),%eax
 247:	89 44 24 04          	mov    %eax,0x4(%esp)
 24b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 252:	e8 3d 01 00 00       	call   394 <read>
 257:	89 45 f4             	mov    %eax,-0xc(%ebp)
 25a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 25e:	7e 2d                	jle    28d <gets+0x60>
 260:	8b 45 f0             	mov    -0x10(%ebp),%eax
 263:	03 45 08             	add    0x8(%ebp),%eax
 266:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 26a:	88 10                	mov    %dl,(%eax)
 26c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 270:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 274:	3c 0a                	cmp    $0xa,%al
 276:	74 16                	je     28e <gets+0x61>
 278:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27c:	3c 0d                	cmp    $0xd,%al
 27e:	74 0e                	je     28e <gets+0x61>
 280:	8b 45 f0             	mov    -0x10(%ebp),%eax
 283:	83 c0 01             	add    $0x1,%eax
 286:	3b 45 0c             	cmp    0xc(%ebp),%eax
 289:	7c b1                	jl     23c <gets+0xf>
 28b:	eb 01                	jmp    28e <gets+0x61>
 28d:	90                   	nop
 28e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 291:	03 45 08             	add    0x8(%ebp),%eax
 294:	c6 00 00             	movb   $0x0,(%eax)
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <stat>:
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	83 ec 28             	sub    $0x28,%esp
 2a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a9:	00 
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	89 04 24             	mov    %eax,(%esp)
 2b0:	e8 07 01 00 00       	call   3bc <open>
 2b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 2b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2bc:	79 07                	jns    2c5 <stat+0x29>
 2be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c3:	eb 23                	jmp    2e8 <stat+0x4c>
 2c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 2cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2cf:	89 04 24             	mov    %eax,(%esp)
 2d2:	e8 fd 00 00 00       	call   3d4 <fstat>
 2d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 2da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2dd:	89 04 24             	mov    %eax,(%esp)
 2e0:	e8 bf 00 00 00       	call   3a4 <close>
 2e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e8:	c9                   	leave  
 2e9:	c3                   	ret    

000002ea <atoi>:
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	83 ec 10             	sub    $0x10,%esp
 2f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2f7:	eb 24                	jmp    31d <atoi+0x33>
 2f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fc:	89 d0                	mov    %edx,%eax
 2fe:	c1 e0 02             	shl    $0x2,%eax
 301:	01 d0                	add    %edx,%eax
 303:	01 c0                	add    %eax,%eax
 305:	89 c2                	mov    %eax,%edx
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	0f b6 00             	movzbl (%eax),%eax
 30d:	0f be c0             	movsbl %al,%eax
 310:	8d 04 02             	lea    (%edx,%eax,1),%eax
 313:	83 e8 30             	sub    $0x30,%eax
 316:	89 45 fc             	mov    %eax,-0x4(%ebp)
 319:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	0f b6 00             	movzbl (%eax),%eax
 323:	3c 2f                	cmp    $0x2f,%al
 325:	7e 0a                	jle    331 <atoi+0x47>
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	0f b6 00             	movzbl (%eax),%eax
 32d:	3c 39                	cmp    $0x39,%al
 32f:	7e c8                	jle    2f9 <atoi+0xf>
 331:	8b 45 fc             	mov    -0x4(%ebp),%eax
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <memmove>:
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	83 ec 10             	sub    $0x10,%esp
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	89 45 f8             	mov    %eax,-0x8(%ebp)
 342:	8b 45 0c             	mov    0xc(%ebp),%eax
 345:	89 45 fc             	mov    %eax,-0x4(%ebp)
 348:	eb 13                	jmp    35d <memmove+0x27>
 34a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34d:	0f b6 10             	movzbl (%eax),%edx
 350:	8b 45 f8             	mov    -0x8(%ebp),%eax
 353:	88 10                	mov    %dl,(%eax)
 355:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 359:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 35d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 361:	0f 9f c0             	setg   %al
 364:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 368:	84 c0                	test   %al,%al
 36a:	75 de                	jne    34a <memmove+0x14>
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
 36f:	c9                   	leave  
 370:	c3                   	ret    
 371:	66 90                	xchg   %ax,%ax
 373:	90                   	nop

00000374 <fork>:
 374:	b8 01 00 00 00       	mov    $0x1,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exit>:
 37c:	b8 02 00 00 00       	mov    $0x2,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <wait>:
 384:	b8 03 00 00 00       	mov    $0x3,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <pipe>:
 38c:	b8 04 00 00 00       	mov    $0x4,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <read>:
 394:	b8 05 00 00 00       	mov    $0x5,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <write>:
 39c:	b8 10 00 00 00       	mov    $0x10,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <close>:
 3a4:	b8 15 00 00 00       	mov    $0x15,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <kill>:
 3ac:	b8 06 00 00 00       	mov    $0x6,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <exec>:
 3b4:	b8 07 00 00 00       	mov    $0x7,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <open>:
 3bc:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <mknod>:
 3c4:	b8 11 00 00 00       	mov    $0x11,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <unlink>:
 3cc:	b8 12 00 00 00       	mov    $0x12,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <fstat>:
 3d4:	b8 08 00 00 00       	mov    $0x8,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <link>:
 3dc:	b8 13 00 00 00       	mov    $0x13,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <mkdir>:
 3e4:	b8 14 00 00 00       	mov    $0x14,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <chdir>:
 3ec:	b8 09 00 00 00       	mov    $0x9,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <dup>:
 3f4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <getpid>:
 3fc:	b8 0b 00 00 00       	mov    $0xb,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <sbrk>:
 404:	b8 0c 00 00 00       	mov    $0xc,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <sleep>:
 40c:	b8 0d 00 00 00       	mov    $0xd,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <uptime>:
 414:	b8 0e 00 00 00       	mov    $0xe,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <putc>:
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	83 ec 28             	sub    $0x28,%esp
 422:	8b 45 0c             	mov    0xc(%ebp),%eax
 425:	88 45 f4             	mov    %al,-0xc(%ebp)
 428:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 42f:	00 
 430:	8d 45 f4             	lea    -0xc(%ebp),%eax
 433:	89 44 24 04          	mov    %eax,0x4(%esp)
 437:	8b 45 08             	mov    0x8(%ebp),%eax
 43a:	89 04 24             	mov    %eax,(%esp)
 43d:	e8 5a ff ff ff       	call   39c <write>
 442:	c9                   	leave  
 443:	c3                   	ret    

00000444 <printint>:
 444:	55                   	push   %ebp
 445:	89 e5                	mov    %esp,%ebp
 447:	53                   	push   %ebx
 448:	83 ec 44             	sub    $0x44,%esp
 44b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 452:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 456:	74 17                	je     46f <printint+0x2b>
 458:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 45c:	79 11                	jns    46f <printint+0x2b>
 45e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
 465:	8b 45 0c             	mov    0xc(%ebp),%eax
 468:	f7 d8                	neg    %eax
 46a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 46d:	eb 06                	jmp    475 <printint+0x31>
 46f:	8b 45 0c             	mov    0xc(%ebp),%eax
 472:	89 45 f4             	mov    %eax,-0xc(%ebp)
 475:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 47c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 47f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 482:	8b 45 f4             	mov    -0xc(%ebp),%eax
 485:	ba 00 00 00 00       	mov    $0x0,%edx
 48a:	f7 f3                	div    %ebx
 48c:	89 d0                	mov    %edx,%eax
 48e:	0f b6 80 1c 09 00 00 	movzbl 0x91c(%eax),%eax
 495:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 499:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 49d:	8b 45 10             	mov    0x10(%ebp),%eax
 4a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a6:	ba 00 00 00 00       	mov    $0x0,%edx
 4ab:	f7 75 d4             	divl   -0x2c(%ebp)
 4ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b5:	75 c5                	jne    47c <printint+0x38>
 4b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4bb:	74 28                	je     4e5 <printint+0xa1>
 4bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 4c5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 4c9:	eb 1a                	jmp    4e5 <printint+0xa1>
 4cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ce:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 4d3:	0f be c0             	movsbl %al,%eax
 4d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 4da:	8b 45 08             	mov    0x8(%ebp),%eax
 4dd:	89 04 24             	mov    %eax,(%esp)
 4e0:	e8 37 ff ff ff       	call   41c <putc>
 4e5:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 4e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ed:	79 dc                	jns    4cb <printint+0x87>
 4ef:	83 c4 44             	add    $0x44,%esp
 4f2:	5b                   	pop    %ebx
 4f3:	5d                   	pop    %ebp
 4f4:	c3                   	ret    

000004f5 <printf>:
 4f5:	55                   	push   %ebp
 4f6:	89 e5                	mov    %esp,%ebp
 4f8:	83 ec 38             	sub    $0x38,%esp
 4fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 502:	8d 45 0c             	lea    0xc(%ebp),%eax
 505:	83 c0 04             	add    $0x4,%eax
 508:	89 45 f4             	mov    %eax,-0xc(%ebp)
 50b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 512:	e9 7e 01 00 00       	jmp    695 <printf+0x1a0>
 517:	8b 55 0c             	mov    0xc(%ebp),%edx
 51a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 51d:	8d 04 02             	lea    (%edx,%eax,1),%eax
 520:	0f b6 00             	movzbl (%eax),%eax
 523:	0f be c0             	movsbl %al,%eax
 526:	25 ff 00 00 00       	and    $0xff,%eax
 52b:	89 45 e8             	mov    %eax,-0x18(%ebp)
 52e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 532:	75 2c                	jne    560 <printf+0x6b>
 534:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 538:	75 0c                	jne    546 <printf+0x51>
 53a:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 541:	e9 4b 01 00 00       	jmp    691 <printf+0x19c>
 546:	8b 45 e8             	mov    -0x18(%ebp),%eax
 549:	0f be c0             	movsbl %al,%eax
 54c:	89 44 24 04          	mov    %eax,0x4(%esp)
 550:	8b 45 08             	mov    0x8(%ebp),%eax
 553:	89 04 24             	mov    %eax,(%esp)
 556:	e8 c1 fe ff ff       	call   41c <putc>
 55b:	e9 31 01 00 00       	jmp    691 <printf+0x19c>
 560:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 564:	0f 85 27 01 00 00    	jne    691 <printf+0x19c>
 56a:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 56e:	75 2d                	jne    59d <printf+0xa8>
 570:	8b 45 f4             	mov    -0xc(%ebp),%eax
 573:	8b 00                	mov    (%eax),%eax
 575:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 57c:	00 
 57d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 584:	00 
 585:	89 44 24 04          	mov    %eax,0x4(%esp)
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	89 04 24             	mov    %eax,(%esp)
 58f:	e8 b0 fe ff ff       	call   444 <printint>
 594:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 598:	e9 ed 00 00 00       	jmp    68a <printf+0x195>
 59d:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 5a1:	74 06                	je     5a9 <printf+0xb4>
 5a3:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 5a7:	75 2d                	jne    5d6 <printf+0xe1>
 5a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ac:	8b 00                	mov    (%eax),%eax
 5ae:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5b5:	00 
 5b6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5bd:	00 
 5be:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c2:	8b 45 08             	mov    0x8(%ebp),%eax
 5c5:	89 04 24             	mov    %eax,(%esp)
 5c8:	e8 77 fe ff ff       	call   444 <printint>
 5cd:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5d1:	e9 b4 00 00 00       	jmp    68a <printf+0x195>
 5d6:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 5da:	75 46                	jne    622 <printf+0x12d>
 5dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5df:	8b 00                	mov    (%eax),%eax
 5e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 5e4:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 5ec:	75 27                	jne    615 <printf+0x120>
 5ee:	c7 45 e4 0b 09 00 00 	movl   $0x90b,-0x1c(%ebp)
 5f5:	eb 1f                	jmp    616 <printf+0x121>
 5f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fa:	0f b6 00             	movzbl (%eax),%eax
 5fd:	0f be c0             	movsbl %al,%eax
 600:	89 44 24 04          	mov    %eax,0x4(%esp)
 604:	8b 45 08             	mov    0x8(%ebp),%eax
 607:	89 04 24             	mov    %eax,(%esp)
 60a:	e8 0d fe ff ff       	call   41c <putc>
 60f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 613:	eb 01                	jmp    616 <printf+0x121>
 615:	90                   	nop
 616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 619:	0f b6 00             	movzbl (%eax),%eax
 61c:	84 c0                	test   %al,%al
 61e:	75 d7                	jne    5f7 <printf+0x102>
 620:	eb 68                	jmp    68a <printf+0x195>
 622:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 626:	75 1d                	jne    645 <printf+0x150>
 628:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62b:	8b 00                	mov    (%eax),%eax
 62d:	0f be c0             	movsbl %al,%eax
 630:	89 44 24 04          	mov    %eax,0x4(%esp)
 634:	8b 45 08             	mov    0x8(%ebp),%eax
 637:	89 04 24             	mov    %eax,(%esp)
 63a:	e8 dd fd ff ff       	call   41c <putc>
 63f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 643:	eb 45                	jmp    68a <printf+0x195>
 645:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 649:	75 17                	jne    662 <printf+0x16d>
 64b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64e:	0f be c0             	movsbl %al,%eax
 651:	89 44 24 04          	mov    %eax,0x4(%esp)
 655:	8b 45 08             	mov    0x8(%ebp),%eax
 658:	89 04 24             	mov    %eax,(%esp)
 65b:	e8 bc fd ff ff       	call   41c <putc>
 660:	eb 28                	jmp    68a <printf+0x195>
 662:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 669:	00 
 66a:	8b 45 08             	mov    0x8(%ebp),%eax
 66d:	89 04 24             	mov    %eax,(%esp)
 670:	e8 a7 fd ff ff       	call   41c <putc>
 675:	8b 45 e8             	mov    -0x18(%ebp),%eax
 678:	0f be c0             	movsbl %al,%eax
 67b:	89 44 24 04          	mov    %eax,0x4(%esp)
 67f:	8b 45 08             	mov    0x8(%ebp),%eax
 682:	89 04 24             	mov    %eax,(%esp)
 685:	e8 92 fd ff ff       	call   41c <putc>
 68a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 691:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 695:	8b 55 0c             	mov    0xc(%ebp),%edx
 698:	8b 45 ec             	mov    -0x14(%ebp),%eax
 69b:	8d 04 02             	lea    (%edx,%eax,1),%eax
 69e:	0f b6 00             	movzbl (%eax),%eax
 6a1:	84 c0                	test   %al,%al
 6a3:	0f 85 6e fe ff ff    	jne    517 <printf+0x22>
 6a9:	c9                   	leave  
 6aa:	c3                   	ret    
 6ab:	90                   	nop

000006ac <free>:
 6ac:	55                   	push   %ebp
 6ad:	89 e5                	mov    %esp,%ebp
 6af:	83 ec 10             	sub    $0x10,%esp
 6b2:	8b 45 08             	mov    0x8(%ebp),%eax
 6b5:	83 e8 08             	sub    $0x8,%eax
 6b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
 6bb:	a1 38 09 00 00       	mov    0x938,%eax
 6c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c3:	eb 24                	jmp    6e9 <free+0x3d>
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cd:	77 12                	ja     6e1 <free+0x35>
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d5:	77 24                	ja     6fb <free+0x4f>
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6df:	77 1a                	ja     6fb <free+0x4f>
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 00                	mov    (%eax),%eax
 6e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ef:	76 d4                	jbe    6c5 <free+0x19>
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f9:	76 ca                	jbe    6c5 <free+0x19>
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	8b 40 04             	mov    0x4(%eax),%eax
 701:	c1 e0 03             	shl    $0x3,%eax
 704:	89 c2                	mov    %eax,%edx
 706:	03 55 f8             	add    -0x8(%ebp),%edx
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 00                	mov    (%eax),%eax
 70e:	39 c2                	cmp    %eax,%edx
 710:	75 24                	jne    736 <free+0x8a>
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	8b 50 04             	mov    0x4(%eax),%edx
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	8b 00                	mov    (%eax),%eax
 71d:	8b 40 04             	mov    0x4(%eax),%eax
 720:	01 c2                	add    %eax,%edx
 722:	8b 45 f8             	mov    -0x8(%ebp),%eax
 725:	89 50 04             	mov    %edx,0x4(%eax)
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 00                	mov    (%eax),%eax
 72d:	8b 10                	mov    (%eax),%edx
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	89 10                	mov    %edx,(%eax)
 734:	eb 0a                	jmp    740 <free+0x94>
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 10                	mov    (%eax),%edx
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	89 10                	mov    %edx,(%eax)
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 40 04             	mov    0x4(%eax),%eax
 746:	c1 e0 03             	shl    $0x3,%eax
 749:	03 45 fc             	add    -0x4(%ebp),%eax
 74c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 74f:	75 20                	jne    771 <free+0xc5>
 751:	8b 45 fc             	mov    -0x4(%ebp),%eax
 754:	8b 50 04             	mov    0x4(%eax),%edx
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	8b 40 04             	mov    0x4(%eax),%eax
 75d:	01 c2                	add    %eax,%edx
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	89 50 04             	mov    %edx,0x4(%eax)
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	8b 10                	mov    (%eax),%edx
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	89 10                	mov    %edx,(%eax)
 76f:	eb 08                	jmp    779 <free+0xcd>
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 55 f8             	mov    -0x8(%ebp),%edx
 777:	89 10                	mov    %edx,(%eax)
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	a3 38 09 00 00       	mov    %eax,0x938
 781:	c9                   	leave  
 782:	c3                   	ret    

00000783 <morecore>:
 783:	55                   	push   %ebp
 784:	89 e5                	mov    %esp,%ebp
 786:	83 ec 28             	sub    $0x28,%esp
 789:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 790:	77 07                	ja     799 <morecore+0x16>
 792:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
 799:	8b 45 08             	mov    0x8(%ebp),%eax
 79c:	c1 e0 03             	shl    $0x3,%eax
 79f:	89 04 24             	mov    %eax,(%esp)
 7a2:	e8 5d fc ff ff       	call   404 <sbrk>
 7a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7aa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 7ae:	75 07                	jne    7b7 <morecore+0x34>
 7b0:	b8 00 00 00 00       	mov    $0x0,%eax
 7b5:	eb 22                	jmp    7d9 <morecore+0x56>
 7b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 55 08             	mov    0x8(%ebp),%edx
 7c3:	89 50 04             	mov    %edx,0x4(%eax)
 7c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c9:	83 c0 08             	add    $0x8,%eax
 7cc:	89 04 24             	mov    %eax,(%esp)
 7cf:	e8 d8 fe ff ff       	call   6ac <free>
 7d4:	a1 38 09 00 00       	mov    0x938,%eax
 7d9:	c9                   	leave  
 7da:	c3                   	ret    

000007db <malloc>:
 7db:	55                   	push   %ebp
 7dc:	89 e5                	mov    %esp,%ebp
 7de:	83 ec 28             	sub    $0x28,%esp
 7e1:	8b 45 08             	mov    0x8(%ebp),%eax
 7e4:	83 c0 07             	add    $0x7,%eax
 7e7:	c1 e8 03             	shr    $0x3,%eax
 7ea:	83 c0 01             	add    $0x1,%eax
 7ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f0:	a1 38 09 00 00       	mov    0x938,%eax
 7f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7fc:	75 23                	jne    821 <malloc+0x46>
 7fe:	c7 45 f0 30 09 00 00 	movl   $0x930,-0x10(%ebp)
 805:	8b 45 f0             	mov    -0x10(%ebp),%eax
 808:	a3 38 09 00 00       	mov    %eax,0x938
 80d:	a1 38 09 00 00       	mov    0x938,%eax
 812:	a3 30 09 00 00       	mov    %eax,0x930
 817:	c7 05 34 09 00 00 00 	movl   $0x0,0x934
 81e:	00 00 00 
 821:	8b 45 f0             	mov    -0x10(%ebp),%eax
 824:	8b 00                	mov    (%eax),%eax
 826:	89 45 ec             	mov    %eax,-0x14(%ebp)
 829:	8b 45 ec             	mov    -0x14(%ebp),%eax
 82c:	8b 40 04             	mov    0x4(%eax),%eax
 82f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 832:	72 4d                	jb     881 <malloc+0xa6>
 834:	8b 45 ec             	mov    -0x14(%ebp),%eax
 837:	8b 40 04             	mov    0x4(%eax),%eax
 83a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 83d:	75 0c                	jne    84b <malloc+0x70>
 83f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 842:	8b 10                	mov    (%eax),%edx
 844:	8b 45 f0             	mov    -0x10(%ebp),%eax
 847:	89 10                	mov    %edx,(%eax)
 849:	eb 26                	jmp    871 <malloc+0x96>
 84b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 84e:	8b 40 04             	mov    0x4(%eax),%eax
 851:	89 c2                	mov    %eax,%edx
 853:	2b 55 f4             	sub    -0xc(%ebp),%edx
 856:	8b 45 ec             	mov    -0x14(%ebp),%eax
 859:	89 50 04             	mov    %edx,0x4(%eax)
 85c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 85f:	8b 40 04             	mov    0x4(%eax),%eax
 862:	c1 e0 03             	shl    $0x3,%eax
 865:	01 45 ec             	add    %eax,-0x14(%ebp)
 868:	8b 45 ec             	mov    -0x14(%ebp),%eax
 86b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 86e:	89 50 04             	mov    %edx,0x4(%eax)
 871:	8b 45 f0             	mov    -0x10(%ebp),%eax
 874:	a3 38 09 00 00       	mov    %eax,0x938
 879:	8b 45 ec             	mov    -0x14(%ebp),%eax
 87c:	83 c0 08             	add    $0x8,%eax
 87f:	eb 38                	jmp    8b9 <malloc+0xde>
 881:	a1 38 09 00 00       	mov    0x938,%eax
 886:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 889:	75 1b                	jne    8a6 <malloc+0xcb>
 88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88e:	89 04 24             	mov    %eax,(%esp)
 891:	e8 ed fe ff ff       	call   783 <morecore>
 896:	89 45 ec             	mov    %eax,-0x14(%ebp)
 899:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 89d:	75 07                	jne    8a6 <malloc+0xcb>
 89f:	b8 00 00 00 00       	mov    $0x0,%eax
 8a4:	eb 13                	jmp    8b9 <malloc+0xde>
 8a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8af:	8b 00                	mov    (%eax),%eax
 8b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8b4:	e9 70 ff ff ff       	jmp    829 <malloc+0x4e>
 8b9:	c9                   	leave  
 8ba:	c3                   	ret    
