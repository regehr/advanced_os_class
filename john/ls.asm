
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	89 04 24             	mov    %eax,(%esp)
   d:	e8 db 03 00 00       	call   3ed <strlen>
  12:	03 45 08             	add    0x8(%ebp),%eax
  15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  18:	eb 04                	jmp    1e <fmtname+0x1e>
  1a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  21:	3b 45 08             	cmp    0x8(%ebp),%eax
  24:	72 0a                	jb     30 <fmtname+0x30>
  26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  29:	0f b6 00             	movzbl (%eax),%eax
  2c:	3c 2f                	cmp    $0x2f,%al
  2e:	75 ea                	jne    1a <fmtname+0x1a>
  30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  37:	89 04 24             	mov    %eax,(%esp)
  3a:	e8 ae 03 00 00       	call   3ed <strlen>
  3f:	83 f8 0d             	cmp    $0xd,%eax
  42:	76 05                	jbe    49 <fmtname+0x49>
  44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  47:	eb 5f                	jmp    a8 <fmtname+0xa8>
  49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 99 03 00 00       	call   3ed <strlen>
  54:	89 44 24 08          	mov    %eax,0x8(%esp)
  58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  5f:	c7 04 24 5c 0b 00 00 	movl   $0xb5c,(%esp)
  66:	e8 07 05 00 00       	call   572 <memmove>
  6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6e:	89 04 24             	mov    %eax,(%esp)
  71:	e8 77 03 00 00       	call   3ed <strlen>
  76:	ba 0e 00 00 00       	mov    $0xe,%edx
  7b:	89 d3                	mov    %edx,%ebx
  7d:	29 c3                	sub    %eax,%ebx
  7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  82:	89 04 24             	mov    %eax,(%esp)
  85:	e8 63 03 00 00       	call   3ed <strlen>
  8a:	05 5c 0b 00 00       	add    $0xb5c,%eax
  8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  93:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  9a:	00 
  9b:	89 04 24             	mov    %eax,(%esp)
  9e:	e8 6f 03 00 00       	call   412 <memset>
  a3:	b8 5c 0b 00 00       	mov    $0xb5c,%eax
  a8:	83 c4 24             	add    $0x24,%esp
  ab:	5b                   	pop    %ebx
  ac:	5d                   	pop    %ebp
  ad:	c3                   	ret    

000000ae <ls>:
  ae:	55                   	push   %ebp
  af:	89 e5                	mov    %esp,%ebp
  b1:	57                   	push   %edi
  b2:	56                   	push   %esi
  b3:	53                   	push   %ebx
  b4:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c1:	00 
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	89 04 24             	mov    %eax,(%esp)
  c8:	e8 2b 05 00 00       	call   5f8 <open>
  cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d4:	79 20                	jns    f6 <ls+0x48>
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  dd:	c7 44 24 04 f7 0a 00 	movl   $0xaf7,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ec:	e8 40 06 00 00       	call   731 <printf>
  f1:	e9 01 02 00 00       	jmp    2f7 <ls+0x249>
  f6:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 103:	89 04 24             	mov    %eax,(%esp)
 106:	e8 05 05 00 00       	call   610 <fstat>
 10b:	85 c0                	test   %eax,%eax
 10d:	79 2b                	jns    13a <ls+0x8c>
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	89 44 24 08          	mov    %eax,0x8(%esp)
 116:	c7 44 24 04 0b 0b 00 	movl   $0xb0b,0x4(%esp)
 11d:	00 
 11e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 125:	e8 07 06 00 00       	call   731 <printf>
 12a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12d:	89 04 24             	mov    %eax,(%esp)
 130:	e8 ab 04 00 00       	call   5e0 <close>
 135:	e9 bd 01 00 00       	jmp    2f7 <ls+0x249>
 13a:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 141:	98                   	cwtl   
 142:	83 f8 01             	cmp    $0x1,%eax
 145:	74 53                	je     19a <ls+0xec>
 147:	83 f8 02             	cmp    $0x2,%eax
 14a:	0f 85 9c 01 00 00    	jne    2ec <ls+0x23e>
 150:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 156:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 163:	0f bf d8             	movswl %ax,%ebx
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	89 04 24             	mov    %eax,(%esp)
 16c:	e8 8f fe ff ff       	call   0 <fmtname>
 171:	89 7c 24 14          	mov    %edi,0x14(%esp)
 175:	89 74 24 10          	mov    %esi,0x10(%esp)
 179:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 17d:	89 44 24 08          	mov    %eax,0x8(%esp)
 181:	c7 44 24 04 1f 0b 00 	movl   $0xb1f,0x4(%esp)
 188:	00 
 189:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 190:	e8 9c 05 00 00       	call   731 <printf>
 195:	e9 52 01 00 00       	jmp    2ec <ls+0x23e>
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	89 04 24             	mov    %eax,(%esp)
 1a0:	e8 48 02 00 00       	call   3ed <strlen>
 1a5:	83 c0 10             	add    $0x10,%eax
 1a8:	3d 00 02 00 00       	cmp    $0x200,%eax
 1ad:	76 19                	jbe    1c8 <ls+0x11a>
 1af:	c7 44 24 04 2c 0b 00 	movl   $0xb2c,0x4(%esp)
 1b6:	00 
 1b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1be:	e8 6e 05 00 00       	call   731 <printf>
 1c3:	e9 24 01 00 00       	jmp    2ec <ls+0x23e>
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 1cf:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d5:	89 04 24             	mov    %eax,(%esp)
 1d8:	e8 9c 01 00 00       	call   379 <strcpy>
 1dd:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e3:	89 04 24             	mov    %eax,(%esp)
 1e6:	e8 02 02 00 00       	call   3ed <strlen>
 1eb:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1f1:	8d 04 02             	lea    (%edx,%eax,1),%eax
 1f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 1f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1fa:	c6 00 2f             	movb   $0x2f,(%eax)
 1fd:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
 201:	e9 c0 00 00 00       	jmp    2c6 <ls+0x218>
 206:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 20d:	66 85 c0             	test   %ax,%ax
 210:	0f 84 af 00 00 00    	je     2c5 <ls+0x217>
 216:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 21d:	00 
 21e:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 224:	83 c0 02             	add    $0x2,%eax
 227:	89 44 24 04          	mov    %eax,0x4(%esp)
 22b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22e:	89 04 24             	mov    %eax,(%esp)
 231:	e8 3c 03 00 00       	call   572 <memmove>
 236:	8b 45 e0             	mov    -0x20(%ebp),%eax
 239:	83 c0 0e             	add    $0xe,%eax
 23c:	c6 00 00             	movb   $0x0,(%eax)
 23f:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 245:	89 44 24 04          	mov    %eax,0x4(%esp)
 249:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 24f:	89 04 24             	mov    %eax,(%esp)
 252:	e8 81 02 00 00       	call   4d8 <stat>
 257:	85 c0                	test   %eax,%eax
 259:	79 20                	jns    27b <ls+0x1cd>
 25b:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 261:	89 44 24 08          	mov    %eax,0x8(%esp)
 265:	c7 44 24 04 0b 0b 00 	movl   $0xb0b,0x4(%esp)
 26c:	00 
 26d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 274:	e8 b8 04 00 00       	call   731 <printf>
 279:	eb 4b                	jmp    2c6 <ls+0x218>
 27b:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 281:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 287:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 28e:	0f bf d8             	movswl %ax,%ebx
 291:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 297:	89 04 24             	mov    %eax,(%esp)
 29a:	e8 61 fd ff ff       	call   0 <fmtname>
 29f:	89 7c 24 14          	mov    %edi,0x14(%esp)
 2a3:	89 74 24 10          	mov    %esi,0x10(%esp)
 2a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2ab:	89 44 24 08          	mov    %eax,0x8(%esp)
 2af:	c7 44 24 04 1f 0b 00 	movl   $0xb1f,0x4(%esp)
 2b6:	00 
 2b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2be:	e8 6e 04 00 00       	call   731 <printf>
 2c3:	eb 01                	jmp    2c6 <ls+0x218>
 2c5:	90                   	nop
 2c6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 2cd:	00 
 2ce:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2db:	89 04 24             	mov    %eax,(%esp)
 2de:	e8 ed 02 00 00       	call   5d0 <read>
 2e3:	83 f8 10             	cmp    $0x10,%eax
 2e6:	0f 84 1a ff ff ff    	je     206 <ls+0x158>
 2ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2ef:	89 04 24             	mov    %eax,(%esp)
 2f2:	e8 e9 02 00 00       	call   5e0 <close>
 2f7:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2fd:	5b                   	pop    %ebx
 2fe:	5e                   	pop    %esi
 2ff:	5f                   	pop    %edi
 300:	5d                   	pop    %ebp
 301:	c3                   	ret    

00000302 <main>:
 302:	55                   	push   %ebp
 303:	89 e5                	mov    %esp,%ebp
 305:	83 e4 f0             	and    $0xfffffff0,%esp
 308:	83 ec 20             	sub    $0x20,%esp
 30b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 30f:	7f 11                	jg     322 <main+0x20>
 311:	c7 04 24 3f 0b 00 00 	movl   $0xb3f,(%esp)
 318:	e8 91 fd ff ff       	call   ae <ls>
 31d:	e8 96 02 00 00       	call   5b8 <exit>
 322:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 329:	00 
 32a:	eb 19                	jmp    345 <main+0x43>
 32c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 330:	c1 e0 02             	shl    $0x2,%eax
 333:	03 45 0c             	add    0xc(%ebp),%eax
 336:	8b 00                	mov    (%eax),%eax
 338:	89 04 24             	mov    %eax,(%esp)
 33b:	e8 6e fd ff ff       	call   ae <ls>
 340:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 345:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 349:	3b 45 08             	cmp    0x8(%ebp),%eax
 34c:	7c de                	jl     32c <main+0x2a>
 34e:	e8 65 02 00 00       	call   5b8 <exit>
 353:	90                   	nop

00000354 <stosb>:
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	57                   	push   %edi
 358:	53                   	push   %ebx
 359:	8b 4d 08             	mov    0x8(%ebp),%ecx
 35c:	8b 55 10             	mov    0x10(%ebp),%edx
 35f:	8b 45 0c             	mov    0xc(%ebp),%eax
 362:	89 cb                	mov    %ecx,%ebx
 364:	89 df                	mov    %ebx,%edi
 366:	89 d1                	mov    %edx,%ecx
 368:	fc                   	cld    
 369:	f3 aa                	rep stos %al,%es:(%edi)
 36b:	89 ca                	mov    %ecx,%edx
 36d:	89 fb                	mov    %edi,%ebx
 36f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 372:	89 55 10             	mov    %edx,0x10(%ebp)
 375:	5b                   	pop    %ebx
 376:	5f                   	pop    %edi
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    

00000379 <strcpy>:
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	83 ec 10             	sub    $0x10,%esp
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	89 45 fc             	mov    %eax,-0x4(%ebp)
 385:	8b 45 0c             	mov    0xc(%ebp),%eax
 388:	0f b6 10             	movzbl (%eax),%edx
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	88 10                	mov    %dl,(%eax)
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	0f b6 00             	movzbl (%eax),%eax
 396:	84 c0                	test   %al,%al
 398:	0f 95 c0             	setne  %al
 39b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 39f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3a3:	84 c0                	test   %al,%al
 3a5:	75 de                	jne    385 <strcpy+0xc>
 3a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <strcmp>:
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	eb 08                	jmp    3b9 <strcmp+0xd>
 3b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3b9:	8b 45 08             	mov    0x8(%ebp),%eax
 3bc:	0f b6 00             	movzbl (%eax),%eax
 3bf:	84 c0                	test   %al,%al
 3c1:	74 10                	je     3d3 <strcmp+0x27>
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 10             	movzbl (%eax),%edx
 3c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	38 c2                	cmp    %al,%dl
 3d1:	74 de                	je     3b1 <strcmp+0x5>
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	0f b6 d0             	movzbl %al,%edx
 3dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3df:	0f b6 00             	movzbl (%eax),%eax
 3e2:	0f b6 c0             	movzbl %al,%eax
 3e5:	89 d1                	mov    %edx,%ecx
 3e7:	29 c1                	sub    %eax,%ecx
 3e9:	89 c8                	mov    %ecx,%eax
 3eb:	5d                   	pop    %ebp
 3ec:	c3                   	ret    

000003ed <strlen>:
 3ed:	55                   	push   %ebp
 3ee:	89 e5                	mov    %esp,%ebp
 3f0:	83 ec 10             	sub    $0x10,%esp
 3f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3fa:	eb 04                	jmp    400 <strlen+0x13>
 3fc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 400:	8b 45 fc             	mov    -0x4(%ebp),%eax
 403:	03 45 08             	add    0x8(%ebp),%eax
 406:	0f b6 00             	movzbl (%eax),%eax
 409:	84 c0                	test   %al,%al
 40b:	75 ef                	jne    3fc <strlen+0xf>
 40d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 410:	c9                   	leave  
 411:	c3                   	ret    

00000412 <memset>:
 412:	55                   	push   %ebp
 413:	89 e5                	mov    %esp,%ebp
 415:	83 ec 0c             	sub    $0xc,%esp
 418:	8b 45 10             	mov    0x10(%ebp),%eax
 41b:	89 44 24 08          	mov    %eax,0x8(%esp)
 41f:	8b 45 0c             	mov    0xc(%ebp),%eax
 422:	89 44 24 04          	mov    %eax,0x4(%esp)
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	89 04 24             	mov    %eax,(%esp)
 42c:	e8 23 ff ff ff       	call   354 <stosb>
 431:	8b 45 08             	mov    0x8(%ebp),%eax
 434:	c9                   	leave  
 435:	c3                   	ret    

00000436 <strchr>:
 436:	55                   	push   %ebp
 437:	89 e5                	mov    %esp,%ebp
 439:	83 ec 04             	sub    $0x4,%esp
 43c:	8b 45 0c             	mov    0xc(%ebp),%eax
 43f:	88 45 fc             	mov    %al,-0x4(%ebp)
 442:	eb 14                	jmp    458 <strchr+0x22>
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	0f b6 00             	movzbl (%eax),%eax
 44a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 44d:	75 05                	jne    454 <strchr+0x1e>
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	eb 13                	jmp    467 <strchr+0x31>
 454:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	0f b6 00             	movzbl (%eax),%eax
 45e:	84 c0                	test   %al,%al
 460:	75 e2                	jne    444 <strchr+0xe>
 462:	b8 00 00 00 00       	mov    $0x0,%eax
 467:	c9                   	leave  
 468:	c3                   	ret    

00000469 <gets>:
 469:	55                   	push   %ebp
 46a:	89 e5                	mov    %esp,%ebp
 46c:	83 ec 28             	sub    $0x28,%esp
 46f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 476:	eb 44                	jmp    4bc <gets+0x53>
 478:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 47f:	00 
 480:	8d 45 ef             	lea    -0x11(%ebp),%eax
 483:	89 44 24 04          	mov    %eax,0x4(%esp)
 487:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 48e:	e8 3d 01 00 00       	call   5d0 <read>
 493:	89 45 f4             	mov    %eax,-0xc(%ebp)
 496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 49a:	7e 2d                	jle    4c9 <gets+0x60>
 49c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 49f:	03 45 08             	add    0x8(%ebp),%eax
 4a2:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 4a6:	88 10                	mov    %dl,(%eax)
 4a8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 4ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b0:	3c 0a                	cmp    $0xa,%al
 4b2:	74 16                	je     4ca <gets+0x61>
 4b4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b8:	3c 0d                	cmp    $0xd,%al
 4ba:	74 0e                	je     4ca <gets+0x61>
 4bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4bf:	83 c0 01             	add    $0x1,%eax
 4c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4c5:	7c b1                	jl     478 <gets+0xf>
 4c7:	eb 01                	jmp    4ca <gets+0x61>
 4c9:	90                   	nop
 4ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4cd:	03 45 08             	add    0x8(%ebp),%eax
 4d0:	c6 00 00             	movb   $0x0,(%eax)
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	c9                   	leave  
 4d7:	c3                   	ret    

000004d8 <stat>:
 4d8:	55                   	push   %ebp
 4d9:	89 e5                	mov    %esp,%ebp
 4db:	83 ec 28             	sub    $0x28,%esp
 4de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4e5:	00 
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	89 04 24             	mov    %eax,(%esp)
 4ec:	e8 07 01 00 00       	call   5f8 <open>
 4f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 4f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f8:	79 07                	jns    501 <stat+0x29>
 4fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4ff:	eb 23                	jmp    524 <stat+0x4c>
 501:	8b 45 0c             	mov    0xc(%ebp),%eax
 504:	89 44 24 04          	mov    %eax,0x4(%esp)
 508:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50b:	89 04 24             	mov    %eax,(%esp)
 50e:	e8 fd 00 00 00       	call   610 <fstat>
 513:	89 45 f4             	mov    %eax,-0xc(%ebp)
 516:	8b 45 f0             	mov    -0x10(%ebp),%eax
 519:	89 04 24             	mov    %eax,(%esp)
 51c:	e8 bf 00 00 00       	call   5e0 <close>
 521:	8b 45 f4             	mov    -0xc(%ebp),%eax
 524:	c9                   	leave  
 525:	c3                   	ret    

00000526 <atoi>:
 526:	55                   	push   %ebp
 527:	89 e5                	mov    %esp,%ebp
 529:	83 ec 10             	sub    $0x10,%esp
 52c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 533:	eb 24                	jmp    559 <atoi+0x33>
 535:	8b 55 fc             	mov    -0x4(%ebp),%edx
 538:	89 d0                	mov    %edx,%eax
 53a:	c1 e0 02             	shl    $0x2,%eax
 53d:	01 d0                	add    %edx,%eax
 53f:	01 c0                	add    %eax,%eax
 541:	89 c2                	mov    %eax,%edx
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	0f b6 00             	movzbl (%eax),%eax
 549:	0f be c0             	movsbl %al,%eax
 54c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 54f:	83 e8 30             	sub    $0x30,%eax
 552:	89 45 fc             	mov    %eax,-0x4(%ebp)
 555:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 559:	8b 45 08             	mov    0x8(%ebp),%eax
 55c:	0f b6 00             	movzbl (%eax),%eax
 55f:	3c 2f                	cmp    $0x2f,%al
 561:	7e 0a                	jle    56d <atoi+0x47>
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	0f b6 00             	movzbl (%eax),%eax
 569:	3c 39                	cmp    $0x39,%al
 56b:	7e c8                	jle    535 <atoi+0xf>
 56d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 570:	c9                   	leave  
 571:	c3                   	ret    

00000572 <memmove>:
 572:	55                   	push   %ebp
 573:	89 e5                	mov    %esp,%ebp
 575:	83 ec 10             	sub    $0x10,%esp
 578:	8b 45 08             	mov    0x8(%ebp),%eax
 57b:	89 45 f8             	mov    %eax,-0x8(%ebp)
 57e:	8b 45 0c             	mov    0xc(%ebp),%eax
 581:	89 45 fc             	mov    %eax,-0x4(%ebp)
 584:	eb 13                	jmp    599 <memmove+0x27>
 586:	8b 45 fc             	mov    -0x4(%ebp),%eax
 589:	0f b6 10             	movzbl (%eax),%edx
 58c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 58f:	88 10                	mov    %dl,(%eax)
 591:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 595:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 599:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 59d:	0f 9f c0             	setg   %al
 5a0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 5a4:	84 c0                	test   %al,%al
 5a6:	75 de                	jne    586 <memmove+0x14>
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	c9                   	leave  
 5ac:	c3                   	ret    
 5ad:	66 90                	xchg   %ax,%ax
 5af:	90                   	nop

000005b0 <fork>:
 5b0:	b8 01 00 00 00       	mov    $0x1,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <exit>:
 5b8:	b8 02 00 00 00       	mov    $0x2,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <wait>:
 5c0:	b8 03 00 00 00       	mov    $0x3,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <pipe>:
 5c8:	b8 04 00 00 00       	mov    $0x4,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <read>:
 5d0:	b8 05 00 00 00       	mov    $0x5,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <write>:
 5d8:	b8 10 00 00 00       	mov    $0x10,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <close>:
 5e0:	b8 15 00 00 00       	mov    $0x15,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <kill>:
 5e8:	b8 06 00 00 00       	mov    $0x6,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <exec>:
 5f0:	b8 07 00 00 00       	mov    $0x7,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <open>:
 5f8:	b8 0f 00 00 00       	mov    $0xf,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <mknod>:
 600:	b8 11 00 00 00       	mov    $0x11,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <unlink>:
 608:	b8 12 00 00 00       	mov    $0x12,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <fstat>:
 610:	b8 08 00 00 00       	mov    $0x8,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <link>:
 618:	b8 13 00 00 00       	mov    $0x13,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <mkdir>:
 620:	b8 14 00 00 00       	mov    $0x14,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <chdir>:
 628:	b8 09 00 00 00       	mov    $0x9,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <dup>:
 630:	b8 0a 00 00 00       	mov    $0xa,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <getpid>:
 638:	b8 0b 00 00 00       	mov    $0xb,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <sbrk>:
 640:	b8 0c 00 00 00       	mov    $0xc,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <sleep>:
 648:	b8 0d 00 00 00       	mov    $0xd,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <uptime>:
 650:	b8 0e 00 00 00       	mov    $0xe,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <putc>:
 658:	55                   	push   %ebp
 659:	89 e5                	mov    %esp,%ebp
 65b:	83 ec 28             	sub    $0x28,%esp
 65e:	8b 45 0c             	mov    0xc(%ebp),%eax
 661:	88 45 f4             	mov    %al,-0xc(%ebp)
 664:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 66b:	00 
 66c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 66f:	89 44 24 04          	mov    %eax,0x4(%esp)
 673:	8b 45 08             	mov    0x8(%ebp),%eax
 676:	89 04 24             	mov    %eax,(%esp)
 679:	e8 5a ff ff ff       	call   5d8 <write>
 67e:	c9                   	leave  
 67f:	c3                   	ret    

00000680 <printint>:
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	53                   	push   %ebx
 684:	83 ec 44             	sub    $0x44,%esp
 687:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 68e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 692:	74 17                	je     6ab <printint+0x2b>
 694:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 698:	79 11                	jns    6ab <printint+0x2b>
 69a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
 6a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a4:	f7 d8                	neg    %eax
 6a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6a9:	eb 06                	jmp    6b1 <printint+0x31>
 6ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 6b8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 6bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c1:	ba 00 00 00 00       	mov    $0x0,%edx
 6c6:	f7 f3                	div    %ebx
 6c8:	89 d0                	mov    %edx,%eax
 6ca:	0f b6 80 48 0b 00 00 	movzbl 0xb48(%eax),%eax
 6d1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 6d5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 6d9:	8b 45 10             	mov    0x10(%ebp),%eax
 6dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e2:	ba 00 00 00 00       	mov    $0x0,%edx
 6e7:	f7 75 d4             	divl   -0x2c(%ebp)
 6ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f1:	75 c5                	jne    6b8 <printint+0x38>
 6f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6f7:	74 28                	je     721 <printint+0xa1>
 6f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6fc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 701:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 705:	eb 1a                	jmp    721 <printint+0xa1>
 707:	8b 45 ec             	mov    -0x14(%ebp),%eax
 70a:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 70f:	0f be c0             	movsbl %al,%eax
 712:	89 44 24 04          	mov    %eax,0x4(%esp)
 716:	8b 45 08             	mov    0x8(%ebp),%eax
 719:	89 04 24             	mov    %eax,(%esp)
 71c:	e8 37 ff ff ff       	call   658 <putc>
 721:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 725:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 729:	79 dc                	jns    707 <printint+0x87>
 72b:	83 c4 44             	add    $0x44,%esp
 72e:	5b                   	pop    %ebx
 72f:	5d                   	pop    %ebp
 730:	c3                   	ret    

00000731 <printf>:
 731:	55                   	push   %ebp
 732:	89 e5                	mov    %esp,%ebp
 734:	83 ec 38             	sub    $0x38,%esp
 737:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 73e:	8d 45 0c             	lea    0xc(%ebp),%eax
 741:	83 c0 04             	add    $0x4,%eax
 744:	89 45 f4             	mov    %eax,-0xc(%ebp)
 747:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 74e:	e9 7e 01 00 00       	jmp    8d1 <printf+0x1a0>
 753:	8b 55 0c             	mov    0xc(%ebp),%edx
 756:	8b 45 ec             	mov    -0x14(%ebp),%eax
 759:	8d 04 02             	lea    (%edx,%eax,1),%eax
 75c:	0f b6 00             	movzbl (%eax),%eax
 75f:	0f be c0             	movsbl %al,%eax
 762:	25 ff 00 00 00       	and    $0xff,%eax
 767:	89 45 e8             	mov    %eax,-0x18(%ebp)
 76a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76e:	75 2c                	jne    79c <printf+0x6b>
 770:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 774:	75 0c                	jne    782 <printf+0x51>
 776:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 77d:	e9 4b 01 00 00       	jmp    8cd <printf+0x19c>
 782:	8b 45 e8             	mov    -0x18(%ebp),%eax
 785:	0f be c0             	movsbl %al,%eax
 788:	89 44 24 04          	mov    %eax,0x4(%esp)
 78c:	8b 45 08             	mov    0x8(%ebp),%eax
 78f:	89 04 24             	mov    %eax,(%esp)
 792:	e8 c1 fe ff ff       	call   658 <putc>
 797:	e9 31 01 00 00       	jmp    8cd <printf+0x19c>
 79c:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 7a0:	0f 85 27 01 00 00    	jne    8cd <printf+0x19c>
 7a6:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 7aa:	75 2d                	jne    7d9 <printf+0xa8>
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 00                	mov    (%eax),%eax
 7b1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7b8:	00 
 7b9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7c0:	00 
 7c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c5:	8b 45 08             	mov    0x8(%ebp),%eax
 7c8:	89 04 24             	mov    %eax,(%esp)
 7cb:	e8 b0 fe ff ff       	call   680 <printint>
 7d0:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 7d4:	e9 ed 00 00 00       	jmp    8c6 <printf+0x195>
 7d9:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 7dd:	74 06                	je     7e5 <printf+0xb4>
 7df:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 7e3:	75 2d                	jne    812 <printf+0xe1>
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	8b 00                	mov    (%eax),%eax
 7ea:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7f1:	00 
 7f2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7f9:	00 
 7fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fe:	8b 45 08             	mov    0x8(%ebp),%eax
 801:	89 04 24             	mov    %eax,(%esp)
 804:	e8 77 fe ff ff       	call   680 <printint>
 809:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 80d:	e9 b4 00 00 00       	jmp    8c6 <printf+0x195>
 812:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 816:	75 46                	jne    85e <printf+0x12d>
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	8b 00                	mov    (%eax),%eax
 81d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 820:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 824:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 828:	75 27                	jne    851 <printf+0x120>
 82a:	c7 45 e4 41 0b 00 00 	movl   $0xb41,-0x1c(%ebp)
 831:	eb 1f                	jmp    852 <printf+0x121>
 833:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 836:	0f b6 00             	movzbl (%eax),%eax
 839:	0f be c0             	movsbl %al,%eax
 83c:	89 44 24 04          	mov    %eax,0x4(%esp)
 840:	8b 45 08             	mov    0x8(%ebp),%eax
 843:	89 04 24             	mov    %eax,(%esp)
 846:	e8 0d fe ff ff       	call   658 <putc>
 84b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 84f:	eb 01                	jmp    852 <printf+0x121>
 851:	90                   	nop
 852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 855:	0f b6 00             	movzbl (%eax),%eax
 858:	84 c0                	test   %al,%al
 85a:	75 d7                	jne    833 <printf+0x102>
 85c:	eb 68                	jmp    8c6 <printf+0x195>
 85e:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 862:	75 1d                	jne    881 <printf+0x150>
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	8b 00                	mov    (%eax),%eax
 869:	0f be c0             	movsbl %al,%eax
 86c:	89 44 24 04          	mov    %eax,0x4(%esp)
 870:	8b 45 08             	mov    0x8(%ebp),%eax
 873:	89 04 24             	mov    %eax,(%esp)
 876:	e8 dd fd ff ff       	call   658 <putc>
 87b:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 87f:	eb 45                	jmp    8c6 <printf+0x195>
 881:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 885:	75 17                	jne    89e <printf+0x16d>
 887:	8b 45 e8             	mov    -0x18(%ebp),%eax
 88a:	0f be c0             	movsbl %al,%eax
 88d:	89 44 24 04          	mov    %eax,0x4(%esp)
 891:	8b 45 08             	mov    0x8(%ebp),%eax
 894:	89 04 24             	mov    %eax,(%esp)
 897:	e8 bc fd ff ff       	call   658 <putc>
 89c:	eb 28                	jmp    8c6 <printf+0x195>
 89e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8a5:	00 
 8a6:	8b 45 08             	mov    0x8(%ebp),%eax
 8a9:	89 04 24             	mov    %eax,(%esp)
 8ac:	e8 a7 fd ff ff       	call   658 <putc>
 8b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8b4:	0f be c0             	movsbl %al,%eax
 8b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 8bb:	8b 45 08             	mov    0x8(%ebp),%eax
 8be:	89 04 24             	mov    %eax,(%esp)
 8c1:	e8 92 fd ff ff       	call   658 <putc>
 8c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8cd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 8d1:	8b 55 0c             	mov    0xc(%ebp),%edx
 8d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8d7:	8d 04 02             	lea    (%edx,%eax,1),%eax
 8da:	0f b6 00             	movzbl (%eax),%eax
 8dd:	84 c0                	test   %al,%al
 8df:	0f 85 6e fe ff ff    	jne    753 <printf+0x22>
 8e5:	c9                   	leave  
 8e6:	c3                   	ret    
 8e7:	90                   	nop

000008e8 <free>:
 8e8:	55                   	push   %ebp
 8e9:	89 e5                	mov    %esp,%ebp
 8eb:	83 ec 10             	sub    $0x10,%esp
 8ee:	8b 45 08             	mov    0x8(%ebp),%eax
 8f1:	83 e8 08             	sub    $0x8,%eax
 8f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
 8f7:	a1 74 0b 00 00       	mov    0xb74,%eax
 8fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8ff:	eb 24                	jmp    925 <free+0x3d>
 901:	8b 45 fc             	mov    -0x4(%ebp),%eax
 904:	8b 00                	mov    (%eax),%eax
 906:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 909:	77 12                	ja     91d <free+0x35>
 90b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 911:	77 24                	ja     937 <free+0x4f>
 913:	8b 45 fc             	mov    -0x4(%ebp),%eax
 916:	8b 00                	mov    (%eax),%eax
 918:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 91b:	77 1a                	ja     937 <free+0x4f>
 91d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 920:	8b 00                	mov    (%eax),%eax
 922:	89 45 fc             	mov    %eax,-0x4(%ebp)
 925:	8b 45 f8             	mov    -0x8(%ebp),%eax
 928:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 92b:	76 d4                	jbe    901 <free+0x19>
 92d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 930:	8b 00                	mov    (%eax),%eax
 932:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 935:	76 ca                	jbe    901 <free+0x19>
 937:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93a:	8b 40 04             	mov    0x4(%eax),%eax
 93d:	c1 e0 03             	shl    $0x3,%eax
 940:	89 c2                	mov    %eax,%edx
 942:	03 55 f8             	add    -0x8(%ebp),%edx
 945:	8b 45 fc             	mov    -0x4(%ebp),%eax
 948:	8b 00                	mov    (%eax),%eax
 94a:	39 c2                	cmp    %eax,%edx
 94c:	75 24                	jne    972 <free+0x8a>
 94e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 951:	8b 50 04             	mov    0x4(%eax),%edx
 954:	8b 45 fc             	mov    -0x4(%ebp),%eax
 957:	8b 00                	mov    (%eax),%eax
 959:	8b 40 04             	mov    0x4(%eax),%eax
 95c:	01 c2                	add    %eax,%edx
 95e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 961:	89 50 04             	mov    %edx,0x4(%eax)
 964:	8b 45 fc             	mov    -0x4(%ebp),%eax
 967:	8b 00                	mov    (%eax),%eax
 969:	8b 10                	mov    (%eax),%edx
 96b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96e:	89 10                	mov    %edx,(%eax)
 970:	eb 0a                	jmp    97c <free+0x94>
 972:	8b 45 fc             	mov    -0x4(%ebp),%eax
 975:	8b 10                	mov    (%eax),%edx
 977:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97a:	89 10                	mov    %edx,(%eax)
 97c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97f:	8b 40 04             	mov    0x4(%eax),%eax
 982:	c1 e0 03             	shl    $0x3,%eax
 985:	03 45 fc             	add    -0x4(%ebp),%eax
 988:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 98b:	75 20                	jne    9ad <free+0xc5>
 98d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 990:	8b 50 04             	mov    0x4(%eax),%edx
 993:	8b 45 f8             	mov    -0x8(%ebp),%eax
 996:	8b 40 04             	mov    0x4(%eax),%eax
 999:	01 c2                	add    %eax,%edx
 99b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99e:	89 50 04             	mov    %edx,0x4(%eax)
 9a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a4:	8b 10                	mov    (%eax),%edx
 9a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a9:	89 10                	mov    %edx,(%eax)
 9ab:	eb 08                	jmp    9b5 <free+0xcd>
 9ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9b3:	89 10                	mov    %edx,(%eax)
 9b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b8:	a3 74 0b 00 00       	mov    %eax,0xb74
 9bd:	c9                   	leave  
 9be:	c3                   	ret    

000009bf <morecore>:
 9bf:	55                   	push   %ebp
 9c0:	89 e5                	mov    %esp,%ebp
 9c2:	83 ec 28             	sub    $0x28,%esp
 9c5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9cc:	77 07                	ja     9d5 <morecore+0x16>
 9ce:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
 9d5:	8b 45 08             	mov    0x8(%ebp),%eax
 9d8:	c1 e0 03             	shl    $0x3,%eax
 9db:	89 04 24             	mov    %eax,(%esp)
 9de:	e8 5d fc ff ff       	call   640 <sbrk>
 9e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9e6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 9ea:	75 07                	jne    9f3 <morecore+0x34>
 9ec:	b8 00 00 00 00       	mov    $0x0,%eax
 9f1:	eb 22                	jmp    a15 <morecore+0x56>
 9f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fc:	8b 55 08             	mov    0x8(%ebp),%edx
 9ff:	89 50 04             	mov    %edx,0x4(%eax)
 a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a05:	83 c0 08             	add    $0x8,%eax
 a08:	89 04 24             	mov    %eax,(%esp)
 a0b:	e8 d8 fe ff ff       	call   8e8 <free>
 a10:	a1 74 0b 00 00       	mov    0xb74,%eax
 a15:	c9                   	leave  
 a16:	c3                   	ret    

00000a17 <malloc>:
 a17:	55                   	push   %ebp
 a18:	89 e5                	mov    %esp,%ebp
 a1a:	83 ec 28             	sub    $0x28,%esp
 a1d:	8b 45 08             	mov    0x8(%ebp),%eax
 a20:	83 c0 07             	add    $0x7,%eax
 a23:	c1 e8 03             	shr    $0x3,%eax
 a26:	83 c0 01             	add    $0x1,%eax
 a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a2c:	a1 74 0b 00 00       	mov    0xb74,%eax
 a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a38:	75 23                	jne    a5d <malloc+0x46>
 a3a:	c7 45 f0 6c 0b 00 00 	movl   $0xb6c,-0x10(%ebp)
 a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a44:	a3 74 0b 00 00       	mov    %eax,0xb74
 a49:	a1 74 0b 00 00       	mov    0xb74,%eax
 a4e:	a3 6c 0b 00 00       	mov    %eax,0xb6c
 a53:	c7 05 70 0b 00 00 00 	movl   $0x0,0xb70
 a5a:	00 00 00 
 a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a60:	8b 00                	mov    (%eax),%eax
 a62:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a68:	8b 40 04             	mov    0x4(%eax),%eax
 a6b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 a6e:	72 4d                	jb     abd <malloc+0xa6>
 a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a73:	8b 40 04             	mov    0x4(%eax),%eax
 a76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 a79:	75 0c                	jne    a87 <malloc+0x70>
 a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a7e:	8b 10                	mov    (%eax),%edx
 a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a83:	89 10                	mov    %edx,(%eax)
 a85:	eb 26                	jmp    aad <malloc+0x96>
 a87:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a8a:	8b 40 04             	mov    0x4(%eax),%eax
 a8d:	89 c2                	mov    %eax,%edx
 a8f:	2b 55 f4             	sub    -0xc(%ebp),%edx
 a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a95:	89 50 04             	mov    %edx,0x4(%eax)
 a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a9b:	8b 40 04             	mov    0x4(%eax),%eax
 a9e:	c1 e0 03             	shl    $0x3,%eax
 aa1:	01 45 ec             	add    %eax,-0x14(%ebp)
 aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 aaa:	89 50 04             	mov    %edx,0x4(%eax)
 aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab0:	a3 74 0b 00 00       	mov    %eax,0xb74
 ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ab8:	83 c0 08             	add    $0x8,%eax
 abb:	eb 38                	jmp    af5 <malloc+0xde>
 abd:	a1 74 0b 00 00       	mov    0xb74,%eax
 ac2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 ac5:	75 1b                	jne    ae2 <malloc+0xcb>
 ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aca:	89 04 24             	mov    %eax,(%esp)
 acd:	e8 ed fe ff ff       	call   9bf <morecore>
 ad2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 ad5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ad9:	75 07                	jne    ae2 <malloc+0xcb>
 adb:	b8 00 00 00 00       	mov    $0x0,%eax
 ae0:	eb 13                	jmp    af5 <malloc+0xde>
 ae2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aeb:	8b 00                	mov    (%eax),%eax
 aed:	89 45 ec             	mov    %eax,-0x14(%ebp)
 af0:	e9 70 ff ff ff       	jmp    a65 <malloc+0x4e>
 af5:	c9                   	leave  
 af6:	c3                   	ret    
