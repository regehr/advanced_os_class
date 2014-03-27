
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  2c:	c7 44 24 04 5b 09 00 	movl   $0x95b,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 55 05 00 00       	call   595 <printf>
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 1a 02 00 00       	call   276 <memset>
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 11                	jmp    7a <main+0x7a>
  69:	e8 a6 03 00 00       	call   414 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7f 14                	jg     86 <main+0x86>
  72:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  79:	01 
  7a:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  81:	03 
  82:	7e e5                	jle    69 <main+0x69>
  84:	eb 01                	jmp    87 <main+0x87>
  86:	90                   	nop
  87:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  92:	c7 44 24 04 6e 09 00 	movl   $0x96e,0x4(%esp)
  99:	00 
  9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a1:	e8 ef 04 00 00       	call   595 <printf>
  a6:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ad:	00 
  ae:	89 c2                	mov    %eax,%edx
  b0:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b7:	8d 04 02             	lea    (%edx,%eax,1),%eax
  ba:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  c1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c8:	00 
  c9:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  d0:	89 04 24             	mov    %eax,(%esp)
  d3:	e8 84 03 00 00       	call   45c <open>
  d8:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  df:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e6:	00 00 00 00 
  ea:	eb 27                	jmp    113 <main+0x113>
  ec:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f3:	00 
  f4:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  fc:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 103:	89 04 24             	mov    %eax,(%esp)
 106:	e8 31 03 00 00       	call   43c <write>
 10b:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 112:	01 
 113:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 11a:	13 
 11b:	7e cf                	jle    ec <main+0xec>
 11d:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 124:	89 04 24             	mov    %eax,(%esp)
 127:	e8 18 03 00 00       	call   444 <close>
 12c:	c7 44 24 04 78 09 00 	movl   $0x978,0x4(%esp)
 133:	00 
 134:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13b:	e8 55 04 00 00       	call   595 <printf>
 140:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 147:	00 
 148:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14f:	89 04 24             	mov    %eax,(%esp)
 152:	e8 05 03 00 00       	call   45c <open>
 157:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
 15e:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 165:	00 00 00 00 
 169:	eb 27                	jmp    192 <main+0x192>
 16b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 172:	00 
 173:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 177:	89 44 24 04          	mov    %eax,0x4(%esp)
 17b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 182:	89 04 24             	mov    %eax,(%esp)
 185:	e8 aa 02 00 00       	call   434 <read>
 18a:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 191:	01 
 192:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 199:	13 
 19a:	7e cf                	jle    16b <main+0x16b>
 19c:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a3:	89 04 24             	mov    %eax,(%esp)
 1a6:	e8 99 02 00 00       	call   444 <close>
 1ab:	e8 74 02 00 00       	call   424 <wait>
 1b0:	e8 67 02 00 00       	call   41c <exit>
 1b5:	66 90                	xchg   %ax,%ax
 1b7:	90                   	nop

000001b8 <stosb>:
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	57                   	push   %edi
 1bc:	53                   	push   %ebx
 1bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c0:	8b 55 10             	mov    0x10(%ebp),%edx
 1c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c6:	89 cb                	mov    %ecx,%ebx
 1c8:	89 df                	mov    %ebx,%edi
 1ca:	89 d1                	mov    %edx,%ecx
 1cc:	fc                   	cld    
 1cd:	f3 aa                	rep stos %al,%es:(%edi)
 1cf:	89 ca                	mov    %ecx,%edx
 1d1:	89 fb                	mov    %edi,%ebx
 1d3:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d6:	89 55 10             	mov    %edx,0x10(%ebp)
 1d9:	5b                   	pop    %ebx
 1da:	5f                   	pop    %edi
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    

000001dd <strcpy>:
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 10             	sub    $0x10,%esp
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 1e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ec:	0f b6 10             	movzbl (%eax),%edx
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	88 10                	mov    %dl,(%eax)
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	0f b6 00             	movzbl (%eax),%eax
 1fa:	84 c0                	test   %al,%al
 1fc:	0f 95 c0             	setne  %al
 1ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 203:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 207:	84 c0                	test   %al,%al
 209:	75 de                	jne    1e9 <strcpy+0xc>
 20b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 20e:	c9                   	leave  
 20f:	c3                   	ret    

00000210 <strcmp>:
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	eb 08                	jmp    21d <strcmp+0xd>
 215:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 219:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	0f b6 00             	movzbl (%eax),%eax
 223:	84 c0                	test   %al,%al
 225:	74 10                	je     237 <strcmp+0x27>
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	0f b6 10             	movzbl (%eax),%edx
 22d:	8b 45 0c             	mov    0xc(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	38 c2                	cmp    %al,%dl
 235:	74 de                	je     215 <strcmp+0x5>
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	0f b6 d0             	movzbl %al,%edx
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	0f b6 c0             	movzbl %al,%eax
 249:	89 d1                	mov    %edx,%ecx
 24b:	29 c1                	sub    %eax,%ecx
 24d:	89 c8                	mov    %ecx,%eax
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    

00000251 <strlen>:
 251:	55                   	push   %ebp
 252:	89 e5                	mov    %esp,%ebp
 254:	83 ec 10             	sub    $0x10,%esp
 257:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25e:	eb 04                	jmp    264 <strlen+0x13>
 260:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 264:	8b 45 fc             	mov    -0x4(%ebp),%eax
 267:	03 45 08             	add    0x8(%ebp),%eax
 26a:	0f b6 00             	movzbl (%eax),%eax
 26d:	84 c0                	test   %al,%al
 26f:	75 ef                	jne    260 <strlen+0xf>
 271:	8b 45 fc             	mov    -0x4(%ebp),%eax
 274:	c9                   	leave  
 275:	c3                   	ret    

00000276 <memset>:
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	83 ec 0c             	sub    $0xc,%esp
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	89 44 24 08          	mov    %eax,0x8(%esp)
 283:	8b 45 0c             	mov    0xc(%ebp),%eax
 286:	89 44 24 04          	mov    %eax,0x4(%esp)
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 04 24             	mov    %eax,(%esp)
 290:	e8 23 ff ff ff       	call   1b8 <stosb>
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <strchr>:
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 04             	sub    $0x4,%esp
 2a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a3:	88 45 fc             	mov    %al,-0x4(%ebp)
 2a6:	eb 14                	jmp    2bc <strchr+0x22>
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b1:	75 05                	jne    2b8 <strchr+0x1e>
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	eb 13                	jmp    2cb <strchr+0x31>
 2b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	0f b6 00             	movzbl (%eax),%eax
 2c2:	84 c0                	test   %al,%al
 2c4:	75 e2                	jne    2a8 <strchr+0xe>
 2c6:	b8 00 00 00 00       	mov    $0x0,%eax
 2cb:	c9                   	leave  
 2cc:	c3                   	ret    

000002cd <gets>:
 2cd:	55                   	push   %ebp
 2ce:	89 e5                	mov    %esp,%ebp
 2d0:	83 ec 28             	sub    $0x28,%esp
 2d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 2da:	eb 44                	jmp    320 <gets+0x53>
 2dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2e3:	00 
 2e4:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 2eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2f2:	e8 3d 01 00 00       	call   434 <read>
 2f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 2fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2fe:	7e 2d                	jle    32d <gets+0x60>
 300:	8b 45 f0             	mov    -0x10(%ebp),%eax
 303:	03 45 08             	add    0x8(%ebp),%eax
 306:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 30a:	88 10                	mov    %dl,(%eax)
 30c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 310:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 314:	3c 0a                	cmp    $0xa,%al
 316:	74 16                	je     32e <gets+0x61>
 318:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31c:	3c 0d                	cmp    $0xd,%al
 31e:	74 0e                	je     32e <gets+0x61>
 320:	8b 45 f0             	mov    -0x10(%ebp),%eax
 323:	83 c0 01             	add    $0x1,%eax
 326:	3b 45 0c             	cmp    0xc(%ebp),%eax
 329:	7c b1                	jl     2dc <gets+0xf>
 32b:	eb 01                	jmp    32e <gets+0x61>
 32d:	90                   	nop
 32e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 331:	03 45 08             	add    0x8(%ebp),%eax
 334:	c6 00 00             	movb   $0x0,(%eax)
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	c9                   	leave  
 33b:	c3                   	ret    

0000033c <stat>:
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	83 ec 28             	sub    $0x28,%esp
 342:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 349:	00 
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	89 04 24             	mov    %eax,(%esp)
 350:	e8 07 01 00 00       	call   45c <open>
 355:	89 45 f0             	mov    %eax,-0x10(%ebp)
 358:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 35c:	79 07                	jns    365 <stat+0x29>
 35e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 363:	eb 23                	jmp    388 <stat+0x4c>
 365:	8b 45 0c             	mov    0xc(%ebp),%eax
 368:	89 44 24 04          	mov    %eax,0x4(%esp)
 36c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 36f:	89 04 24             	mov    %eax,(%esp)
 372:	e8 fd 00 00 00       	call   474 <fstat>
 377:	89 45 f4             	mov    %eax,-0xc(%ebp)
 37a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 37d:	89 04 24             	mov    %eax,(%esp)
 380:	e8 bf 00 00 00       	call   444 <close>
 385:	8b 45 f4             	mov    -0xc(%ebp),%eax
 388:	c9                   	leave  
 389:	c3                   	ret    

0000038a <atoi>:
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 10             	sub    $0x10,%esp
 390:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 397:	eb 24                	jmp    3bd <atoi+0x33>
 399:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39c:	89 d0                	mov    %edx,%eax
 39e:	c1 e0 02             	shl    $0x2,%eax
 3a1:	01 d0                	add    %edx,%eax
 3a3:	01 c0                	add    %eax,%eax
 3a5:	89 c2                	mov    %eax,%edx
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	0f b6 00             	movzbl (%eax),%eax
 3ad:	0f be c0             	movsbl %al,%eax
 3b0:	8d 04 02             	lea    (%edx,%eax,1),%eax
 3b3:	83 e8 30             	sub    $0x30,%eax
 3b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	3c 2f                	cmp    $0x2f,%al
 3c5:	7e 0a                	jle    3d1 <atoi+0x47>
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	3c 39                	cmp    $0x39,%al
 3cf:	7e c8                	jle    399 <atoi+0xf>
 3d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d4:	c9                   	leave  
 3d5:	c3                   	ret    

000003d6 <memmove>:
 3d6:	55                   	push   %ebp
 3d7:	89 e5                	mov    %esp,%ebp
 3d9:	83 ec 10             	sub    $0x10,%esp
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	89 45 f8             	mov    %eax,-0x8(%ebp)
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3e8:	eb 13                	jmp    3fd <memmove+0x27>
 3ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ed:	0f b6 10             	movzbl (%eax),%edx
 3f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3f3:	88 10                	mov    %dl,(%eax)
 3f5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 3f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 401:	0f 9f c0             	setg   %al
 404:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 408:	84 c0                	test   %al,%al
 40a:	75 de                	jne    3ea <memmove+0x14>
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
 40f:	c9                   	leave  
 410:	c3                   	ret    
 411:	66 90                	xchg   %ax,%ax
 413:	90                   	nop

00000414 <fork>:
 414:	b8 01 00 00 00       	mov    $0x1,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <exit>:
 41c:	b8 02 00 00 00       	mov    $0x2,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <wait>:
 424:	b8 03 00 00 00       	mov    $0x3,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <pipe>:
 42c:	b8 04 00 00 00       	mov    $0x4,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <read>:
 434:	b8 05 00 00 00       	mov    $0x5,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <write>:
 43c:	b8 10 00 00 00       	mov    $0x10,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <close>:
 444:	b8 15 00 00 00       	mov    $0x15,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <kill>:
 44c:	b8 06 00 00 00       	mov    $0x6,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <exec>:
 454:	b8 07 00 00 00       	mov    $0x7,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <open>:
 45c:	b8 0f 00 00 00       	mov    $0xf,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <mknod>:
 464:	b8 11 00 00 00       	mov    $0x11,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <unlink>:
 46c:	b8 12 00 00 00       	mov    $0x12,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <fstat>:
 474:	b8 08 00 00 00       	mov    $0x8,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <link>:
 47c:	b8 13 00 00 00       	mov    $0x13,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <mkdir>:
 484:	b8 14 00 00 00       	mov    $0x14,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <chdir>:
 48c:	b8 09 00 00 00       	mov    $0x9,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <dup>:
 494:	b8 0a 00 00 00       	mov    $0xa,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <getpid>:
 49c:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <sbrk>:
 4a4:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <sleep>:
 4ac:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <uptime>:
 4b4:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <putc>:
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	83 ec 28             	sub    $0x28,%esp
 4c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c5:	88 45 f4             	mov    %al,-0xc(%ebp)
 4c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4cf:	00 
 4d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	89 04 24             	mov    %eax,(%esp)
 4dd:	e8 5a ff ff ff       	call   43c <write>
 4e2:	c9                   	leave  
 4e3:	c3                   	ret    

000004e4 <printint>:
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	53                   	push   %ebx
 4e8:	83 ec 44             	sub    $0x44,%esp
 4eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4f6:	74 17                	je     50f <printint+0x2b>
 4f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4fc:	79 11                	jns    50f <printint+0x2b>
 4fe:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
 505:	8b 45 0c             	mov    0xc(%ebp),%eax
 508:	f7 d8                	neg    %eax
 50a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 50d:	eb 06                	jmp    515 <printint+0x31>
 50f:	8b 45 0c             	mov    0xc(%ebp),%eax
 512:	89 45 f4             	mov    %eax,-0xc(%ebp)
 515:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 51c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 51f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 522:	8b 45 f4             	mov    -0xc(%ebp),%eax
 525:	ba 00 00 00 00       	mov    $0x0,%edx
 52a:	f7 f3                	div    %ebx
 52c:	89 d0                	mov    %edx,%eax
 52e:	0f b6 80 88 09 00 00 	movzbl 0x988(%eax),%eax
 535:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 539:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 53d:	8b 45 10             	mov    0x10(%ebp),%eax
 540:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 543:	8b 45 f4             	mov    -0xc(%ebp),%eax
 546:	ba 00 00 00 00       	mov    $0x0,%edx
 54b:	f7 75 d4             	divl   -0x2c(%ebp)
 54e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 555:	75 c5                	jne    51c <printint+0x38>
 557:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 55b:	74 28                	je     585 <printint+0xa1>
 55d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 560:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 565:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 569:	eb 1a                	jmp    585 <printint+0xa1>
 56b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56e:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 573:	0f be c0             	movsbl %al,%eax
 576:	89 44 24 04          	mov    %eax,0x4(%esp)
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	89 04 24             	mov    %eax,(%esp)
 580:	e8 37 ff ff ff       	call   4bc <putc>
 585:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 589:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 58d:	79 dc                	jns    56b <printint+0x87>
 58f:	83 c4 44             	add    $0x44,%esp
 592:	5b                   	pop    %ebx
 593:	5d                   	pop    %ebp
 594:	c3                   	ret    

00000595 <printf>:
 595:	55                   	push   %ebp
 596:	89 e5                	mov    %esp,%ebp
 598:	83 ec 38             	sub    $0x38,%esp
 59b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5a2:	8d 45 0c             	lea    0xc(%ebp),%eax
 5a5:	83 c0 04             	add    $0x4,%eax
 5a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 5b2:	e9 7e 01 00 00       	jmp    735 <printf+0x1a0>
 5b7:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5bd:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5c0:	0f b6 00             	movzbl (%eax),%eax
 5c3:	0f be c0             	movsbl %al,%eax
 5c6:	25 ff 00 00 00       	and    $0xff,%eax
 5cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
 5ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5d2:	75 2c                	jne    600 <printf+0x6b>
 5d4:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5d8:	75 0c                	jne    5e6 <printf+0x51>
 5da:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 5e1:	e9 4b 01 00 00       	jmp    731 <printf+0x19c>
 5e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e9:	0f be c0             	movsbl %al,%eax
 5ec:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f0:	8b 45 08             	mov    0x8(%ebp),%eax
 5f3:	89 04 24             	mov    %eax,(%esp)
 5f6:	e8 c1 fe ff ff       	call   4bc <putc>
 5fb:	e9 31 01 00 00       	jmp    731 <printf+0x19c>
 600:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 604:	0f 85 27 01 00 00    	jne    731 <printf+0x19c>
 60a:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 60e:	75 2d                	jne    63d <printf+0xa8>
 610:	8b 45 f4             	mov    -0xc(%ebp),%eax
 613:	8b 00                	mov    (%eax),%eax
 615:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 61c:	00 
 61d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 624:	00 
 625:	89 44 24 04          	mov    %eax,0x4(%esp)
 629:	8b 45 08             	mov    0x8(%ebp),%eax
 62c:	89 04 24             	mov    %eax,(%esp)
 62f:	e8 b0 fe ff ff       	call   4e4 <printint>
 634:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 638:	e9 ed 00 00 00       	jmp    72a <printf+0x195>
 63d:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 641:	74 06                	je     649 <printf+0xb4>
 643:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 647:	75 2d                	jne    676 <printf+0xe1>
 649:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 655:	00 
 656:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 65d:	00 
 65e:	89 44 24 04          	mov    %eax,0x4(%esp)
 662:	8b 45 08             	mov    0x8(%ebp),%eax
 665:	89 04 24             	mov    %eax,(%esp)
 668:	e8 77 fe ff ff       	call   4e4 <printint>
 66d:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 671:	e9 b4 00 00 00       	jmp    72a <printf+0x195>
 676:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 67a:	75 46                	jne    6c2 <printf+0x12d>
 67c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67f:	8b 00                	mov    (%eax),%eax
 681:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 684:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 688:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 68c:	75 27                	jne    6b5 <printf+0x120>
 68e:	c7 45 e4 7e 09 00 00 	movl   $0x97e,-0x1c(%ebp)
 695:	eb 1f                	jmp    6b6 <printf+0x121>
 697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69a:	0f b6 00             	movzbl (%eax),%eax
 69d:	0f be c0             	movsbl %al,%eax
 6a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a4:	8b 45 08             	mov    0x8(%ebp),%eax
 6a7:	89 04 24             	mov    %eax,(%esp)
 6aa:	e8 0d fe ff ff       	call   4bc <putc>
 6af:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 6b3:	eb 01                	jmp    6b6 <printf+0x121>
 6b5:	90                   	nop
 6b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b9:	0f b6 00             	movzbl (%eax),%eax
 6bc:	84 c0                	test   %al,%al
 6be:	75 d7                	jne    697 <printf+0x102>
 6c0:	eb 68                	jmp    72a <printf+0x195>
 6c2:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 6c6:	75 1d                	jne    6e5 <printf+0x150>
 6c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6cb:	8b 00                	mov    (%eax),%eax
 6cd:	0f be c0             	movsbl %al,%eax
 6d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d4:	8b 45 08             	mov    0x8(%ebp),%eax
 6d7:	89 04 24             	mov    %eax,(%esp)
 6da:	e8 dd fd ff ff       	call   4bc <putc>
 6df:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 6e3:	eb 45                	jmp    72a <printf+0x195>
 6e5:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 6e9:	75 17                	jne    702 <printf+0x16d>
 6eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ee:	0f be c0             	movsbl %al,%eax
 6f1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f5:	8b 45 08             	mov    0x8(%ebp),%eax
 6f8:	89 04 24             	mov    %eax,(%esp)
 6fb:	e8 bc fd ff ff       	call   4bc <putc>
 700:	eb 28                	jmp    72a <printf+0x195>
 702:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 709:	00 
 70a:	8b 45 08             	mov    0x8(%ebp),%eax
 70d:	89 04 24             	mov    %eax,(%esp)
 710:	e8 a7 fd ff ff       	call   4bc <putc>
 715:	8b 45 e8             	mov    -0x18(%ebp),%eax
 718:	0f be c0             	movsbl %al,%eax
 71b:	89 44 24 04          	mov    %eax,0x4(%esp)
 71f:	8b 45 08             	mov    0x8(%ebp),%eax
 722:	89 04 24             	mov    %eax,(%esp)
 725:	e8 92 fd ff ff       	call   4bc <putc>
 72a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 731:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 735:	8b 55 0c             	mov    0xc(%ebp),%edx
 738:	8b 45 ec             	mov    -0x14(%ebp),%eax
 73b:	8d 04 02             	lea    (%edx,%eax,1),%eax
 73e:	0f b6 00             	movzbl (%eax),%eax
 741:	84 c0                	test   %al,%al
 743:	0f 85 6e fe ff ff    	jne    5b7 <printf+0x22>
 749:	c9                   	leave  
 74a:	c3                   	ret    
 74b:	90                   	nop

0000074c <free>:
 74c:	55                   	push   %ebp
 74d:	89 e5                	mov    %esp,%ebp
 74f:	83 ec 10             	sub    $0x10,%esp
 752:	8b 45 08             	mov    0x8(%ebp),%eax
 755:	83 e8 08             	sub    $0x8,%eax
 758:	89 45 f8             	mov    %eax,-0x8(%ebp)
 75b:	a1 a4 09 00 00       	mov    0x9a4,%eax
 760:	89 45 fc             	mov    %eax,-0x4(%ebp)
 763:	eb 24                	jmp    789 <free+0x3d>
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	8b 00                	mov    (%eax),%eax
 76a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76d:	77 12                	ja     781 <free+0x35>
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 775:	77 24                	ja     79b <free+0x4f>
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	8b 00                	mov    (%eax),%eax
 77c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 77f:	77 1a                	ja     79b <free+0x4f>
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	8b 00                	mov    (%eax),%eax
 786:	89 45 fc             	mov    %eax,-0x4(%ebp)
 789:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 78f:	76 d4                	jbe    765 <free+0x19>
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 799:	76 ca                	jbe    765 <free+0x19>
 79b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79e:	8b 40 04             	mov    0x4(%eax),%eax
 7a1:	c1 e0 03             	shl    $0x3,%eax
 7a4:	89 c2                	mov    %eax,%edx
 7a6:	03 55 f8             	add    -0x8(%ebp),%edx
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	8b 00                	mov    (%eax),%eax
 7ae:	39 c2                	cmp    %eax,%edx
 7b0:	75 24                	jne    7d6 <free+0x8a>
 7b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b5:	8b 50 04             	mov    0x4(%eax),%edx
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 00                	mov    (%eax),%eax
 7bd:	8b 40 04             	mov    0x4(%eax),%eax
 7c0:	01 c2                	add    %eax,%edx
 7c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c5:	89 50 04             	mov    %edx,0x4(%eax)
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	8b 00                	mov    (%eax),%eax
 7cd:	8b 10                	mov    (%eax),%edx
 7cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d2:	89 10                	mov    %edx,(%eax)
 7d4:	eb 0a                	jmp    7e0 <free+0x94>
 7d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d9:	8b 10                	mov    (%eax),%edx
 7db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7de:	89 10                	mov    %edx,(%eax)
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	8b 40 04             	mov    0x4(%eax),%eax
 7e6:	c1 e0 03             	shl    $0x3,%eax
 7e9:	03 45 fc             	add    -0x4(%ebp),%eax
 7ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ef:	75 20                	jne    811 <free+0xc5>
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	8b 50 04             	mov    0x4(%eax),%edx
 7f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fa:	8b 40 04             	mov    0x4(%eax),%eax
 7fd:	01 c2                	add    %eax,%edx
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	89 50 04             	mov    %edx,0x4(%eax)
 805:	8b 45 f8             	mov    -0x8(%ebp),%eax
 808:	8b 10                	mov    (%eax),%edx
 80a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80d:	89 10                	mov    %edx,(%eax)
 80f:	eb 08                	jmp    819 <free+0xcd>
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	8b 55 f8             	mov    -0x8(%ebp),%edx
 817:	89 10                	mov    %edx,(%eax)
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	a3 a4 09 00 00       	mov    %eax,0x9a4
 821:	c9                   	leave  
 822:	c3                   	ret    

00000823 <morecore>:
 823:	55                   	push   %ebp
 824:	89 e5                	mov    %esp,%ebp
 826:	83 ec 28             	sub    $0x28,%esp
 829:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 830:	77 07                	ja     839 <morecore+0x16>
 832:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
 839:	8b 45 08             	mov    0x8(%ebp),%eax
 83c:	c1 e0 03             	shl    $0x3,%eax
 83f:	89 04 24             	mov    %eax,(%esp)
 842:	e8 5d fc ff ff       	call   4a4 <sbrk>
 847:	89 45 f0             	mov    %eax,-0x10(%ebp)
 84a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 84e:	75 07                	jne    857 <morecore+0x34>
 850:	b8 00 00 00 00       	mov    $0x0,%eax
 855:	eb 22                	jmp    879 <morecore+0x56>
 857:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	8b 55 08             	mov    0x8(%ebp),%edx
 863:	89 50 04             	mov    %edx,0x4(%eax)
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	83 c0 08             	add    $0x8,%eax
 86c:	89 04 24             	mov    %eax,(%esp)
 86f:	e8 d8 fe ff ff       	call   74c <free>
 874:	a1 a4 09 00 00       	mov    0x9a4,%eax
 879:	c9                   	leave  
 87a:	c3                   	ret    

0000087b <malloc>:
 87b:	55                   	push   %ebp
 87c:	89 e5                	mov    %esp,%ebp
 87e:	83 ec 28             	sub    $0x28,%esp
 881:	8b 45 08             	mov    0x8(%ebp),%eax
 884:	83 c0 07             	add    $0x7,%eax
 887:	c1 e8 03             	shr    $0x3,%eax
 88a:	83 c0 01             	add    $0x1,%eax
 88d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 890:	a1 a4 09 00 00       	mov    0x9a4,%eax
 895:	89 45 f0             	mov    %eax,-0x10(%ebp)
 898:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 89c:	75 23                	jne    8c1 <malloc+0x46>
 89e:	c7 45 f0 9c 09 00 00 	movl   $0x99c,-0x10(%ebp)
 8a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a8:	a3 a4 09 00 00       	mov    %eax,0x9a4
 8ad:	a1 a4 09 00 00       	mov    0x9a4,%eax
 8b2:	a3 9c 09 00 00       	mov    %eax,0x99c
 8b7:	c7 05 a0 09 00 00 00 	movl   $0x0,0x9a0
 8be:	00 00 00 
 8c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c4:	8b 00                	mov    (%eax),%eax
 8c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8cc:	8b 40 04             	mov    0x4(%eax),%eax
 8cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8d2:	72 4d                	jb     921 <malloc+0xa6>
 8d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8d7:	8b 40 04             	mov    0x4(%eax),%eax
 8da:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8dd:	75 0c                	jne    8eb <malloc+0x70>
 8df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8e2:	8b 10                	mov    (%eax),%edx
 8e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e7:	89 10                	mov    %edx,(%eax)
 8e9:	eb 26                	jmp    911 <malloc+0x96>
 8eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ee:	8b 40 04             	mov    0x4(%eax),%eax
 8f1:	89 c2                	mov    %eax,%edx
 8f3:	2b 55 f4             	sub    -0xc(%ebp),%edx
 8f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f9:	89 50 04             	mov    %edx,0x4(%eax)
 8fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ff:	8b 40 04             	mov    0x4(%eax),%eax
 902:	c1 e0 03             	shl    $0x3,%eax
 905:	01 45 ec             	add    %eax,-0x14(%ebp)
 908:	8b 45 ec             	mov    -0x14(%ebp),%eax
 90b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 90e:	89 50 04             	mov    %edx,0x4(%eax)
 911:	8b 45 f0             	mov    -0x10(%ebp),%eax
 914:	a3 a4 09 00 00       	mov    %eax,0x9a4
 919:	8b 45 ec             	mov    -0x14(%ebp),%eax
 91c:	83 c0 08             	add    $0x8,%eax
 91f:	eb 38                	jmp    959 <malloc+0xde>
 921:	a1 a4 09 00 00       	mov    0x9a4,%eax
 926:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 929:	75 1b                	jne    946 <malloc+0xcb>
 92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92e:	89 04 24             	mov    %eax,(%esp)
 931:	e8 ed fe ff ff       	call   823 <morecore>
 936:	89 45 ec             	mov    %eax,-0x14(%ebp)
 939:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 93d:	75 07                	jne    946 <malloc+0xcb>
 93f:	b8 00 00 00 00       	mov    $0x0,%eax
 944:	eb 13                	jmp    959 <malloc+0xde>
 946:	8b 45 ec             	mov    -0x14(%ebp),%eax
 949:	89 45 f0             	mov    %eax,-0x10(%ebp)
 94c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 94f:	8b 00                	mov    (%eax),%eax
 951:	89 45 ec             	mov    %eax,-0x14(%ebp)
 954:	e9 70 ff ff ff       	jmp    8c9 <malloc+0x4e>
 959:	c9                   	leave  
 95a:	c3                   	ret    
