
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
   f:	c7 44 24 04 1f 08 00 	movl   $0x81f,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 36 04 00 00       	call   459 <printf>
  23:	e8 b8 02 00 00       	call   2e0 <exit>
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
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 32 08 00 	movl   $0x832,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 e5 03 00 00       	call   459 <printf>
  74:	e8 67 02 00 00       	call   2e0 <exit>
  79:	66 90                	xchg   %ax,%ax
  7b:	90                   	nop

0000007c <stosb>:
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	57                   	push   %edi
  80:	53                   	push   %ebx
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
  9d:	5b                   	pop    %ebx
  9e:	5f                   	pop    %edi
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strcpy>:
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 10             	sub    $0x10,%esp
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
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
  cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  d2:	c9                   	leave  
  d3:	c3                   	ret    

000000d4 <strcmp>:
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	eb 08                	jmp    e1 <strcmp+0xd>
  d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  dd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
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
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	0f b6 d0             	movzbl %al,%edx
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	0f b6 00             	movzbl (%eax),%eax
 10a:	0f b6 c0             	movzbl %al,%eax
 10d:	89 d1                	mov    %edx,%ecx
 10f:	29 c1                	sub    %eax,%ecx
 111:	89 c8                	mov    %ecx,%eax
 113:	5d                   	pop    %ebp
 114:	c3                   	ret    

00000115 <strlen>:
 115:	55                   	push   %ebp
 116:	89 e5                	mov    %esp,%ebp
 118:	83 ec 10             	sub    $0x10,%esp
 11b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 122:	eb 04                	jmp    128 <strlen+0x13>
 124:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 128:	8b 45 fc             	mov    -0x4(%ebp),%eax
 12b:	03 45 08             	add    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	84 c0                	test   %al,%al
 133:	75 ef                	jne    124 <strlen+0xf>
 135:	8b 45 fc             	mov    -0x4(%ebp),%eax
 138:	c9                   	leave  
 139:	c3                   	ret    

0000013a <memset>:
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	83 ec 0c             	sub    $0xc,%esp
 140:	8b 45 10             	mov    0x10(%ebp),%eax
 143:	89 44 24 08          	mov    %eax,0x8(%esp)
 147:	8b 45 0c             	mov    0xc(%ebp),%eax
 14a:	89 44 24 04          	mov    %eax,0x4(%esp)
 14e:	8b 45 08             	mov    0x8(%ebp),%eax
 151:	89 04 24             	mov    %eax,(%esp)
 154:	e8 23 ff ff ff       	call   7c <stosb>
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	c9                   	leave  
 15d:	c3                   	ret    

0000015e <strchr>:
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
 161:	83 ec 04             	sub    $0x4,%esp
 164:	8b 45 0c             	mov    0xc(%ebp),%eax
 167:	88 45 fc             	mov    %al,-0x4(%ebp)
 16a:	eb 14                	jmp    180 <strchr+0x22>
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	3a 45 fc             	cmp    -0x4(%ebp),%al
 175:	75 05                	jne    17c <strchr+0x1e>
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	eb 13                	jmp    18f <strchr+0x31>
 17c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	0f b6 00             	movzbl (%eax),%eax
 186:	84 c0                	test   %al,%al
 188:	75 e2                	jne    16c <strchr+0xe>
 18a:	b8 00 00 00 00       	mov    $0x0,%eax
 18f:	c9                   	leave  
 190:	c3                   	ret    

00000191 <gets>:
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
 194:	83 ec 28             	sub    $0x28,%esp
 197:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 19e:	eb 44                	jmp    1e4 <gets+0x53>
 1a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1a7:	00 
 1a8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 1af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b6:	e8 3d 01 00 00       	call   2f8 <read>
 1bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 1be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c2:	7e 2d                	jle    1f1 <gets+0x60>
 1c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1c7:	03 45 08             	add    0x8(%ebp),%eax
 1ca:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1ce:	88 10                	mov    %dl,(%eax)
 1d0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 1d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d8:	3c 0a                	cmp    $0xa,%al
 1da:	74 16                	je     1f2 <gets+0x61>
 1dc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e0:	3c 0d                	cmp    $0xd,%al
 1e2:	74 0e                	je     1f2 <gets+0x61>
 1e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1e7:	83 c0 01             	add    $0x1,%eax
 1ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ed:	7c b1                	jl     1a0 <gets+0xf>
 1ef:	eb 01                	jmp    1f2 <gets+0x61>
 1f1:	90                   	nop
 1f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1f5:	03 45 08             	add    0x8(%ebp),%eax
 1f8:	c6 00 00             	movb   $0x0,(%eax)
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	c9                   	leave  
 1ff:	c3                   	ret    

00000200 <stat>:
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 28             	sub    $0x28,%esp
 206:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 20d:	00 
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	89 04 24             	mov    %eax,(%esp)
 214:	e8 07 01 00 00       	call   320 <open>
 219:	89 45 f0             	mov    %eax,-0x10(%ebp)
 21c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 220:	79 07                	jns    229 <stat+0x29>
 222:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 227:	eb 23                	jmp    24c <stat+0x4c>
 229:	8b 45 0c             	mov    0xc(%ebp),%eax
 22c:	89 44 24 04          	mov    %eax,0x4(%esp)
 230:	8b 45 f0             	mov    -0x10(%ebp),%eax
 233:	89 04 24             	mov    %eax,(%esp)
 236:	e8 fd 00 00 00       	call   338 <fstat>
 23b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 23e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 241:	89 04 24             	mov    %eax,(%esp)
 244:	e8 bf 00 00 00       	call   308 <close>
 249:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <atoi>:
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 10             	sub    $0x10,%esp
 254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25b:	eb 24                	jmp    281 <atoi+0x33>
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
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	3c 2f                	cmp    $0x2f,%al
 289:	7e 0a                	jle    295 <atoi+0x47>
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	0f b6 00             	movzbl (%eax),%eax
 291:	3c 39                	cmp    $0x39,%al
 293:	7e c8                	jle    25d <atoi+0xf>
 295:	8b 45 fc             	mov    -0x4(%ebp),%eax
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <memmove>:
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 10             	sub    $0x10,%esp
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 2ac:	eb 13                	jmp    2c1 <memmove+0x27>
 2ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b1:	0f b6 10             	movzbl (%eax),%edx
 2b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b7:	88 10                	mov    %dl,(%eax)
 2b9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2c5:	0f 9f c0             	setg   %al
 2c8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2cc:	84 c0                	test   %al,%al
 2ce:	75 de                	jne    2ae <memmove+0x14>
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    
 2d5:	66 90                	xchg   %ax,%ax
 2d7:	90                   	nop

000002d8 <fork>:
 2d8:	b8 01 00 00 00       	mov    $0x1,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <exit>:
 2e0:	b8 02 00 00 00       	mov    $0x2,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <wait>:
 2e8:	b8 03 00 00 00       	mov    $0x3,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <pipe>:
 2f0:	b8 04 00 00 00       	mov    $0x4,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <read>:
 2f8:	b8 05 00 00 00       	mov    $0x5,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <write>:
 300:	b8 10 00 00 00       	mov    $0x10,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <close>:
 308:	b8 15 00 00 00       	mov    $0x15,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <kill>:
 310:	b8 06 00 00 00       	mov    $0x6,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <exec>:
 318:	b8 07 00 00 00       	mov    $0x7,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <open>:
 320:	b8 0f 00 00 00       	mov    $0xf,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <mknod>:
 328:	b8 11 00 00 00       	mov    $0x11,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <unlink>:
 330:	b8 12 00 00 00       	mov    $0x12,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <fstat>:
 338:	b8 08 00 00 00       	mov    $0x8,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <link>:
 340:	b8 13 00 00 00       	mov    $0x13,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <mkdir>:
 348:	b8 14 00 00 00       	mov    $0x14,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <chdir>:
 350:	b8 09 00 00 00       	mov    $0x9,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <dup>:
 358:	b8 0a 00 00 00       	mov    $0xa,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <getpid>:
 360:	b8 0b 00 00 00       	mov    $0xb,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <sbrk>:
 368:	b8 0c 00 00 00       	mov    $0xc,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <sleep>:
 370:	b8 0d 00 00 00       	mov    $0xd,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <uptime>:
 378:	b8 0e 00 00 00       	mov    $0xe,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <putc>:
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 28             	sub    $0x28,%esp
 386:	8b 45 0c             	mov    0xc(%ebp),%eax
 389:	88 45 f4             	mov    %al,-0xc(%ebp)
 38c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 393:	00 
 394:	8d 45 f4             	lea    -0xc(%ebp),%eax
 397:	89 44 24 04          	mov    %eax,0x4(%esp)
 39b:	8b 45 08             	mov    0x8(%ebp),%eax
 39e:	89 04 24             	mov    %eax,(%esp)
 3a1:	e8 5a ff ff ff       	call   300 <write>
 3a6:	c9                   	leave  
 3a7:	c3                   	ret    

000003a8 <printint>:
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	53                   	push   %ebx
 3ac:	83 ec 44             	sub    $0x44,%esp
 3af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 3b6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ba:	74 17                	je     3d3 <printint+0x2b>
 3bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c0:	79 11                	jns    3d3 <printint+0x2b>
 3c2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
 3c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cc:	f7 d8                	neg    %eax
 3ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3d1:	eb 06                	jmp    3d9 <printint+0x31>
 3d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 3e0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 3e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e9:	ba 00 00 00 00       	mov    $0x0,%edx
 3ee:	f7 f3                	div    %ebx
 3f0:	89 d0                	mov    %edx,%eax
 3f2:	0f b6 80 50 08 00 00 	movzbl 0x850(%eax),%eax
 3f9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 3fd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 401:	8b 45 10             	mov    0x10(%ebp),%eax
 404:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 407:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40a:	ba 00 00 00 00       	mov    $0x0,%edx
 40f:	f7 75 d4             	divl   -0x2c(%ebp)
 412:	89 45 f4             	mov    %eax,-0xc(%ebp)
 415:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 419:	75 c5                	jne    3e0 <printint+0x38>
 41b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 41f:	74 28                	je     449 <printint+0xa1>
 421:	8b 45 ec             	mov    -0x14(%ebp),%eax
 424:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 429:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 42d:	eb 1a                	jmp    449 <printint+0xa1>
 42f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 432:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 437:	0f be c0             	movsbl %al,%eax
 43a:	89 44 24 04          	mov    %eax,0x4(%esp)
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	89 04 24             	mov    %eax,(%esp)
 444:	e8 37 ff ff ff       	call   380 <putc>
 449:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 44d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 451:	79 dc                	jns    42f <printint+0x87>
 453:	83 c4 44             	add    $0x44,%esp
 456:	5b                   	pop    %ebx
 457:	5d                   	pop    %ebp
 458:	c3                   	ret    

00000459 <printf>:
 459:	55                   	push   %ebp
 45a:	89 e5                	mov    %esp,%ebp
 45c:	83 ec 38             	sub    $0x38,%esp
 45f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 466:	8d 45 0c             	lea    0xc(%ebp),%eax
 469:	83 c0 04             	add    $0x4,%eax
 46c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 46f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 476:	e9 7e 01 00 00       	jmp    5f9 <printf+0x1a0>
 47b:	8b 55 0c             	mov    0xc(%ebp),%edx
 47e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 481:	8d 04 02             	lea    (%edx,%eax,1),%eax
 484:	0f b6 00             	movzbl (%eax),%eax
 487:	0f be c0             	movsbl %al,%eax
 48a:	25 ff 00 00 00       	and    $0xff,%eax
 48f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 492:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 496:	75 2c                	jne    4c4 <printf+0x6b>
 498:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 49c:	75 0c                	jne    4aa <printf+0x51>
 49e:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 4a5:	e9 4b 01 00 00       	jmp    5f5 <printf+0x19c>
 4aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ad:	0f be c0             	movsbl %al,%eax
 4b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b4:	8b 45 08             	mov    0x8(%ebp),%eax
 4b7:	89 04 24             	mov    %eax,(%esp)
 4ba:	e8 c1 fe ff ff       	call   380 <putc>
 4bf:	e9 31 01 00 00       	jmp    5f5 <printf+0x19c>
 4c4:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 4c8:	0f 85 27 01 00 00    	jne    5f5 <printf+0x19c>
 4ce:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 4d2:	75 2d                	jne    501 <printf+0xa8>
 4d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d7:	8b 00                	mov    (%eax),%eax
 4d9:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4e0:	00 
 4e1:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4e8:	00 
 4e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ed:	8b 45 08             	mov    0x8(%ebp),%eax
 4f0:	89 04 24             	mov    %eax,(%esp)
 4f3:	e8 b0 fe ff ff       	call   3a8 <printint>
 4f8:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 4fc:	e9 ed 00 00 00       	jmp    5ee <printf+0x195>
 501:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 505:	74 06                	je     50d <printf+0xb4>
 507:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 50b:	75 2d                	jne    53a <printf+0xe1>
 50d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 510:	8b 00                	mov    (%eax),%eax
 512:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 519:	00 
 51a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 521:	00 
 522:	89 44 24 04          	mov    %eax,0x4(%esp)
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	89 04 24             	mov    %eax,(%esp)
 52c:	e8 77 fe ff ff       	call   3a8 <printint>
 531:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 535:	e9 b4 00 00 00       	jmp    5ee <printf+0x195>
 53a:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 53e:	75 46                	jne    586 <printf+0x12d>
 540:	8b 45 f4             	mov    -0xc(%ebp),%eax
 543:	8b 00                	mov    (%eax),%eax
 545:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 548:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 54c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 550:	75 27                	jne    579 <printf+0x120>
 552:	c7 45 e4 46 08 00 00 	movl   $0x846,-0x1c(%ebp)
 559:	eb 1f                	jmp    57a <printf+0x121>
 55b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55e:	0f b6 00             	movzbl (%eax),%eax
 561:	0f be c0             	movsbl %al,%eax
 564:	89 44 24 04          	mov    %eax,0x4(%esp)
 568:	8b 45 08             	mov    0x8(%ebp),%eax
 56b:	89 04 24             	mov    %eax,(%esp)
 56e:	e8 0d fe ff ff       	call   380 <putc>
 573:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 577:	eb 01                	jmp    57a <printf+0x121>
 579:	90                   	nop
 57a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 57d:	0f b6 00             	movzbl (%eax),%eax
 580:	84 c0                	test   %al,%al
 582:	75 d7                	jne    55b <printf+0x102>
 584:	eb 68                	jmp    5ee <printf+0x195>
 586:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 58a:	75 1d                	jne    5a9 <printf+0x150>
 58c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58f:	8b 00                	mov    (%eax),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	89 44 24 04          	mov    %eax,0x4(%esp)
 598:	8b 45 08             	mov    0x8(%ebp),%eax
 59b:	89 04 24             	mov    %eax,(%esp)
 59e:	e8 dd fd ff ff       	call   380 <putc>
 5a3:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5a7:	eb 45                	jmp    5ee <printf+0x195>
 5a9:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5ad:	75 17                	jne    5c6 <printf+0x16d>
 5af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b2:	0f be c0             	movsbl %al,%eax
 5b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
 5bc:	89 04 24             	mov    %eax,(%esp)
 5bf:	e8 bc fd ff ff       	call   380 <putc>
 5c4:	eb 28                	jmp    5ee <printf+0x195>
 5c6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5cd:	00 
 5ce:	8b 45 08             	mov    0x8(%ebp),%eax
 5d1:	89 04 24             	mov    %eax,(%esp)
 5d4:	e8 a7 fd ff ff       	call   380 <putc>
 5d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5dc:	0f be c0             	movsbl %al,%eax
 5df:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	89 04 24             	mov    %eax,(%esp)
 5e9:	e8 92 fd ff ff       	call   380 <putc>
 5ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5f5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 5f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 5fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5ff:	8d 04 02             	lea    (%edx,%eax,1),%eax
 602:	0f b6 00             	movzbl (%eax),%eax
 605:	84 c0                	test   %al,%al
 607:	0f 85 6e fe ff ff    	jne    47b <printf+0x22>
 60d:	c9                   	leave  
 60e:	c3                   	ret    
 60f:	90                   	nop

00000610 <free>:
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	83 ec 10             	sub    $0x10,%esp
 616:	8b 45 08             	mov    0x8(%ebp),%eax
 619:	83 e8 08             	sub    $0x8,%eax
 61c:	89 45 f8             	mov    %eax,-0x8(%ebp)
 61f:	a1 6c 08 00 00       	mov    0x86c,%eax
 624:	89 45 fc             	mov    %eax,-0x4(%ebp)
 627:	eb 24                	jmp    64d <free+0x3d>
 629:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62c:	8b 00                	mov    (%eax),%eax
 62e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 631:	77 12                	ja     645 <free+0x35>
 633:	8b 45 f8             	mov    -0x8(%ebp),%eax
 636:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 639:	77 24                	ja     65f <free+0x4f>
 63b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63e:	8b 00                	mov    (%eax),%eax
 640:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 643:	77 1a                	ja     65f <free+0x4f>
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 650:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 653:	76 d4                	jbe    629 <free+0x19>
 655:	8b 45 fc             	mov    -0x4(%ebp),%eax
 658:	8b 00                	mov    (%eax),%eax
 65a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65d:	76 ca                	jbe    629 <free+0x19>
 65f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 662:	8b 40 04             	mov    0x4(%eax),%eax
 665:	c1 e0 03             	shl    $0x3,%eax
 668:	89 c2                	mov    %eax,%edx
 66a:	03 55 f8             	add    -0x8(%ebp),%edx
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	39 c2                	cmp    %eax,%edx
 674:	75 24                	jne    69a <free+0x8a>
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	8b 50 04             	mov    0x4(%eax),%edx
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 00                	mov    (%eax),%eax
 681:	8b 40 04             	mov    0x4(%eax),%eax
 684:	01 c2                	add    %eax,%edx
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	89 50 04             	mov    %edx,0x4(%eax)
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	8b 10                	mov    (%eax),%edx
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	89 10                	mov    %edx,(%eax)
 698:	eb 0a                	jmp    6a4 <free+0x94>
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 10                	mov    (%eax),%edx
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	89 10                	mov    %edx,(%eax)
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 40 04             	mov    0x4(%eax),%eax
 6aa:	c1 e0 03             	shl    $0x3,%eax
 6ad:	03 45 fc             	add    -0x4(%ebp),%eax
 6b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b3:	75 20                	jne    6d5 <free+0xc5>
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 50 04             	mov    0x4(%eax),%edx
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	8b 40 04             	mov    0x4(%eax),%eax
 6c1:	01 c2                	add    %eax,%edx
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	89 50 04             	mov    %edx,0x4(%eax)
 6c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cc:	8b 10                	mov    (%eax),%edx
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	89 10                	mov    %edx,(%eax)
 6d3:	eb 08                	jmp    6dd <free+0xcd>
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6db:	89 10                	mov    %edx,(%eax)
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	a3 6c 08 00 00       	mov    %eax,0x86c
 6e5:	c9                   	leave  
 6e6:	c3                   	ret    

000006e7 <morecore>:
 6e7:	55                   	push   %ebp
 6e8:	89 e5                	mov    %esp,%ebp
 6ea:	83 ec 28             	sub    $0x28,%esp
 6ed:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f4:	77 07                	ja     6fd <morecore+0x16>
 6f6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
 6fd:	8b 45 08             	mov    0x8(%ebp),%eax
 700:	c1 e0 03             	shl    $0x3,%eax
 703:	89 04 24             	mov    %eax,(%esp)
 706:	e8 5d fc ff ff       	call   368 <sbrk>
 70b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 70e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 712:	75 07                	jne    71b <morecore+0x34>
 714:	b8 00 00 00 00       	mov    $0x0,%eax
 719:	eb 22                	jmp    73d <morecore+0x56>
 71b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 721:	8b 45 f4             	mov    -0xc(%ebp),%eax
 724:	8b 55 08             	mov    0x8(%ebp),%edx
 727:	89 50 04             	mov    %edx,0x4(%eax)
 72a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72d:	83 c0 08             	add    $0x8,%eax
 730:	89 04 24             	mov    %eax,(%esp)
 733:	e8 d8 fe ff ff       	call   610 <free>
 738:	a1 6c 08 00 00       	mov    0x86c,%eax
 73d:	c9                   	leave  
 73e:	c3                   	ret    

0000073f <malloc>:
 73f:	55                   	push   %ebp
 740:	89 e5                	mov    %esp,%ebp
 742:	83 ec 28             	sub    $0x28,%esp
 745:	8b 45 08             	mov    0x8(%ebp),%eax
 748:	83 c0 07             	add    $0x7,%eax
 74b:	c1 e8 03             	shr    $0x3,%eax
 74e:	83 c0 01             	add    $0x1,%eax
 751:	89 45 f4             	mov    %eax,-0xc(%ebp)
 754:	a1 6c 08 00 00       	mov    0x86c,%eax
 759:	89 45 f0             	mov    %eax,-0x10(%ebp)
 75c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 760:	75 23                	jne    785 <malloc+0x46>
 762:	c7 45 f0 64 08 00 00 	movl   $0x864,-0x10(%ebp)
 769:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76c:	a3 6c 08 00 00       	mov    %eax,0x86c
 771:	a1 6c 08 00 00       	mov    0x86c,%eax
 776:	a3 64 08 00 00       	mov    %eax,0x864
 77b:	c7 05 68 08 00 00 00 	movl   $0x0,0x868
 782:	00 00 00 
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 78d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 790:	8b 40 04             	mov    0x4(%eax),%eax
 793:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 796:	72 4d                	jb     7e5 <malloc+0xa6>
 798:	8b 45 ec             	mov    -0x14(%ebp),%eax
 79b:	8b 40 04             	mov    0x4(%eax),%eax
 79e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7a1:	75 0c                	jne    7af <malloc+0x70>
 7a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a6:	8b 10                	mov    (%eax),%edx
 7a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ab:	89 10                	mov    %edx,(%eax)
 7ad:	eb 26                	jmp    7d5 <malloc+0x96>
 7af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7b2:	8b 40 04             	mov    0x4(%eax),%eax
 7b5:	89 c2                	mov    %eax,%edx
 7b7:	2b 55 f4             	sub    -0xc(%ebp),%edx
 7ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7bd:	89 50 04             	mov    %edx,0x4(%eax)
 7c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c3:	8b 40 04             	mov    0x4(%eax),%eax
 7c6:	c1 e0 03             	shl    $0x3,%eax
 7c9:	01 45 ec             	add    %eax,-0x14(%ebp)
 7cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7d2:	89 50 04             	mov    %edx,0x4(%eax)
 7d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d8:	a3 6c 08 00 00       	mov    %eax,0x86c
 7dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e0:	83 c0 08             	add    $0x8,%eax
 7e3:	eb 38                	jmp    81d <malloc+0xde>
 7e5:	a1 6c 08 00 00       	mov    0x86c,%eax
 7ea:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7ed:	75 1b                	jne    80a <malloc+0xcb>
 7ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f2:	89 04 24             	mov    %eax,(%esp)
 7f5:	e8 ed fe ff ff       	call   6e7 <morecore>
 7fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 801:	75 07                	jne    80a <malloc+0xcb>
 803:	b8 00 00 00 00       	mov    $0x0,%eax
 808:	eb 13                	jmp    81d <malloc+0xde>
 80a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 810:	8b 45 ec             	mov    -0x14(%ebp),%eax
 813:	8b 00                	mov    (%eax),%eax
 815:	89 45 ec             	mov    %eax,-0x14(%ebp)
 818:	e9 70 ff ff ff       	jmp    78d <malloc+0x4e>
 81d:	c9                   	leave  
 81e:	c3                   	ret    
