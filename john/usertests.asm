
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <opentest>:
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
       6:	a1 3c 58 00 00       	mov    0x583c,%eax
       b:	c7 44 24 04 72 41 00 	movl   $0x4172,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 7a 3d 00 00       	call   3d95 <printf>
      1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      22:	00 
      23:	c7 04 24 5c 41 00 00 	movl   $0x415c,(%esp)
      2a:	e8 2d 3c 00 00       	call   3c5c <open>
      2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      36:	79 1a                	jns    52 <opentest+0x52>
      38:	a1 3c 58 00 00       	mov    0x583c,%eax
      3d:	c7 44 24 04 7d 41 00 	movl   $0x417d,0x4(%esp)
      44:	00 
      45:	89 04 24             	mov    %eax,(%esp)
      48:	e8 48 3d 00 00       	call   3d95 <printf>
      4d:	e8 ca 3b 00 00       	call   3c1c <exit>
      52:	8b 45 f4             	mov    -0xc(%ebp),%eax
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 e7 3b 00 00       	call   3c44 <close>
      5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      64:	00 
      65:	c7 04 24 90 41 00 00 	movl   $0x4190,(%esp)
      6c:	e8 eb 3b 00 00       	call   3c5c <open>
      71:	89 45 f4             	mov    %eax,-0xc(%ebp)
      74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      78:	78 1a                	js     94 <opentest+0x94>
      7a:	a1 3c 58 00 00       	mov    0x583c,%eax
      7f:	c7 44 24 04 9d 41 00 	movl   $0x419d,0x4(%esp)
      86:	00 
      87:	89 04 24             	mov    %eax,(%esp)
      8a:	e8 06 3d 00 00       	call   3d95 <printf>
      8f:	e8 88 3b 00 00       	call   3c1c <exit>
      94:	a1 3c 58 00 00       	mov    0x583c,%eax
      99:	c7 44 24 04 bb 41 00 	movl   $0x41bb,0x4(%esp)
      a0:	00 
      a1:	89 04 24             	mov    %eax,(%esp)
      a4:	e8 ec 3c 00 00       	call   3d95 <printf>
      a9:	c9                   	leave  
      aa:	c3                   	ret    

000000ab <writetest>:
      ab:	55                   	push   %ebp
      ac:	89 e5                	mov    %esp,%ebp
      ae:	83 ec 28             	sub    $0x28,%esp
      b1:	a1 3c 58 00 00       	mov    0x583c,%eax
      b6:	c7 44 24 04 c9 41 00 	movl   $0x41c9,0x4(%esp)
      bd:	00 
      be:	89 04 24             	mov    %eax,(%esp)
      c1:	e8 cf 3c 00 00       	call   3d95 <printf>
      c6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
      cd:	00 
      ce:	c7 04 24 da 41 00 00 	movl   $0x41da,(%esp)
      d5:	e8 82 3b 00 00       	call   3c5c <open>
      da:	89 45 f0             	mov    %eax,-0x10(%ebp)
      dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
      e1:	78 21                	js     104 <writetest+0x59>
      e3:	a1 3c 58 00 00       	mov    0x583c,%eax
      e8:	c7 44 24 04 e0 41 00 	movl   $0x41e0,0x4(%esp)
      ef:	00 
      f0:	89 04 24             	mov    %eax,(%esp)
      f3:	e8 9d 3c 00 00       	call   3d95 <printf>
      f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      ff:	e9 a0 00 00 00       	jmp    1a4 <writetest+0xf9>
     104:	a1 3c 58 00 00       	mov    0x583c,%eax
     109:	c7 44 24 04 fb 41 00 	movl   $0x41fb,0x4(%esp)
     110:	00 
     111:	89 04 24             	mov    %eax,(%esp)
     114:	e8 7c 3c 00 00       	call   3d95 <printf>
     119:	e8 fe 3a 00 00       	call   3c1c <exit>
     11e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     125:	00 
     126:	c7 44 24 04 17 42 00 	movl   $0x4217,0x4(%esp)
     12d:	00 
     12e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     131:	89 04 24             	mov    %eax,(%esp)
     134:	e8 03 3b 00 00       	call   3c3c <write>
     139:	83 f8 0a             	cmp    $0xa,%eax
     13c:	74 21                	je     15f <writetest+0xb4>
     13e:	a1 3c 58 00 00       	mov    0x583c,%eax
     143:	8b 55 f4             	mov    -0xc(%ebp),%edx
     146:	89 54 24 08          	mov    %edx,0x8(%esp)
     14a:	c7 44 24 04 24 42 00 	movl   $0x4224,0x4(%esp)
     151:	00 
     152:	89 04 24             	mov    %eax,(%esp)
     155:	e8 3b 3c 00 00       	call   3d95 <printf>
     15a:	e8 bd 3a 00 00       	call   3c1c <exit>
     15f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     166:	00 
     167:	c7 44 24 04 48 42 00 	movl   $0x4248,0x4(%esp)
     16e:	00 
     16f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     172:	89 04 24             	mov    %eax,(%esp)
     175:	e8 c2 3a 00 00       	call   3c3c <write>
     17a:	83 f8 0a             	cmp    $0xa,%eax
     17d:	74 21                	je     1a0 <writetest+0xf5>
     17f:	a1 3c 58 00 00       	mov    0x583c,%eax
     184:	8b 55 f4             	mov    -0xc(%ebp),%edx
     187:	89 54 24 08          	mov    %edx,0x8(%esp)
     18b:	c7 44 24 04 54 42 00 	movl   $0x4254,0x4(%esp)
     192:	00 
     193:	89 04 24             	mov    %eax,(%esp)
     196:	e8 fa 3b 00 00       	call   3d95 <printf>
     19b:	e8 7c 3a 00 00       	call   3c1c <exit>
     1a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     1a4:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     1a8:	0f 8e 70 ff ff ff    	jle    11e <writetest+0x73>
     1ae:	a1 3c 58 00 00       	mov    0x583c,%eax
     1b3:	c7 44 24 04 78 42 00 	movl   $0x4278,0x4(%esp)
     1ba:	00 
     1bb:	89 04 24             	mov    %eax,(%esp)
     1be:	e8 d2 3b 00 00       	call   3d95 <printf>
     1c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     1c6:	89 04 24             	mov    %eax,(%esp)
     1c9:	e8 76 3a 00 00       	call   3c44 <close>
     1ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     1d5:	00 
     1d6:	c7 04 24 da 41 00 00 	movl   $0x41da,(%esp)
     1dd:	e8 7a 3a 00 00       	call   3c5c <open>
     1e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     1e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1e9:	78 3e                	js     229 <writetest+0x17e>
     1eb:	a1 3c 58 00 00       	mov    0x583c,%eax
     1f0:	c7 44 24 04 83 42 00 	movl   $0x4283,0x4(%esp)
     1f7:	00 
     1f8:	89 04 24             	mov    %eax,(%esp)
     1fb:	e8 95 3b 00 00       	call   3d95 <printf>
     200:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
     207:	00 
     208:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
     20f:	00 
     210:	8b 45 f0             	mov    -0x10(%ebp),%eax
     213:	89 04 24             	mov    %eax,(%esp)
     216:	e8 19 3a 00 00       	call   3c34 <read>
     21b:	89 45 f4             	mov    %eax,-0xc(%ebp)
     21e:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     225:	74 1c                	je     243 <writetest+0x198>
     227:	eb 4c                	jmp    275 <writetest+0x1ca>
     229:	a1 3c 58 00 00       	mov    0x583c,%eax
     22e:	c7 44 24 04 9c 42 00 	movl   $0x429c,0x4(%esp)
     235:	00 
     236:	89 04 24             	mov    %eax,(%esp)
     239:	e8 57 3b 00 00       	call   3d95 <printf>
     23e:	e8 d9 39 00 00       	call   3c1c <exit>
     243:	a1 3c 58 00 00       	mov    0x583c,%eax
     248:	c7 44 24 04 b7 42 00 	movl   $0x42b7,0x4(%esp)
     24f:	00 
     250:	89 04 24             	mov    %eax,(%esp)
     253:	e8 3d 3b 00 00       	call   3d95 <printf>
     258:	8b 45 f0             	mov    -0x10(%ebp),%eax
     25b:	89 04 24             	mov    %eax,(%esp)
     25e:	e8 e1 39 00 00       	call   3c44 <close>
     263:	c7 04 24 da 41 00 00 	movl   $0x41da,(%esp)
     26a:	e8 fd 39 00 00       	call   3c6c <unlink>
     26f:	85 c0                	test   %eax,%eax
     271:	78 1c                	js     28f <writetest+0x1e4>
     273:	eb 34                	jmp    2a9 <writetest+0x1fe>
     275:	a1 3c 58 00 00       	mov    0x583c,%eax
     27a:	c7 44 24 04 ca 42 00 	movl   $0x42ca,0x4(%esp)
     281:	00 
     282:	89 04 24             	mov    %eax,(%esp)
     285:	e8 0b 3b 00 00       	call   3d95 <printf>
     28a:	e8 8d 39 00 00       	call   3c1c <exit>
     28f:	a1 3c 58 00 00       	mov    0x583c,%eax
     294:	c7 44 24 04 d7 42 00 	movl   $0x42d7,0x4(%esp)
     29b:	00 
     29c:	89 04 24             	mov    %eax,(%esp)
     29f:	e8 f1 3a 00 00       	call   3d95 <printf>
     2a4:	e8 73 39 00 00       	call   3c1c <exit>
     2a9:	a1 3c 58 00 00       	mov    0x583c,%eax
     2ae:	c7 44 24 04 ec 42 00 	movl   $0x42ec,0x4(%esp)
     2b5:	00 
     2b6:	89 04 24             	mov    %eax,(%esp)
     2b9:	e8 d7 3a 00 00       	call   3d95 <printf>
     2be:	c9                   	leave  
     2bf:	c3                   	ret    

000002c0 <writetest1>:
     2c0:	55                   	push   %ebp
     2c1:	89 e5                	mov    %esp,%ebp
     2c3:	83 ec 28             	sub    $0x28,%esp
     2c6:	a1 3c 58 00 00       	mov    0x583c,%eax
     2cb:	c7 44 24 04 00 43 00 	movl   $0x4300,0x4(%esp)
     2d2:	00 
     2d3:	89 04 24             	mov    %eax,(%esp)
     2d6:	e8 ba 3a 00 00       	call   3d95 <printf>
     2db:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     2e2:	00 
     2e3:	c7 04 24 10 43 00 00 	movl   $0x4310,(%esp)
     2ea:	e8 6d 39 00 00       	call   3c5c <open>
     2ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
     2f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     2f6:	79 1a                	jns    312 <writetest1+0x52>
     2f8:	a1 3c 58 00 00       	mov    0x583c,%eax
     2fd:	c7 44 24 04 14 43 00 	movl   $0x4314,0x4(%esp)
     304:	00 
     305:	89 04 24             	mov    %eax,(%esp)
     308:	e8 88 3a 00 00       	call   3d95 <printf>
     30d:	e8 0a 39 00 00       	call   3c1c <exit>
     312:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     319:	eb 51                	jmp    36c <writetest1+0xac>
     31b:	b8 20 80 00 00       	mov    $0x8020,%eax
     320:	8b 55 ec             	mov    -0x14(%ebp),%edx
     323:	89 10                	mov    %edx,(%eax)
     325:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     32c:	00 
     32d:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
     334:	00 
     335:	8b 45 f0             	mov    -0x10(%ebp),%eax
     338:	89 04 24             	mov    %eax,(%esp)
     33b:	e8 fc 38 00 00       	call   3c3c <write>
     340:	3d 00 02 00 00       	cmp    $0x200,%eax
     345:	74 21                	je     368 <writetest1+0xa8>
     347:	a1 3c 58 00 00       	mov    0x583c,%eax
     34c:	8b 55 ec             	mov    -0x14(%ebp),%edx
     34f:	89 54 24 08          	mov    %edx,0x8(%esp)
     353:	c7 44 24 04 2e 43 00 	movl   $0x432e,0x4(%esp)
     35a:	00 
     35b:	89 04 24             	mov    %eax,(%esp)
     35e:	e8 32 3a 00 00       	call   3d95 <printf>
     363:	e8 b4 38 00 00       	call   3c1c <exit>
     368:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     36c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     36f:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     374:	76 a5                	jbe    31b <writetest1+0x5b>
     376:	8b 45 f0             	mov    -0x10(%ebp),%eax
     379:	89 04 24             	mov    %eax,(%esp)
     37c:	e8 c3 38 00 00       	call   3c44 <close>
     381:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     388:	00 
     389:	c7 04 24 10 43 00 00 	movl   $0x4310,(%esp)
     390:	e8 c7 38 00 00       	call   3c5c <open>
     395:	89 45 f0             	mov    %eax,-0x10(%ebp)
     398:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     39c:	79 1a                	jns    3b8 <writetest1+0xf8>
     39e:	a1 3c 58 00 00       	mov    0x583c,%eax
     3a3:	c7 44 24 04 4c 43 00 	movl   $0x434c,0x4(%esp)
     3aa:	00 
     3ab:	89 04 24             	mov    %eax,(%esp)
     3ae:	e8 e2 39 00 00       	call   3d95 <printf>
     3b3:	e8 64 38 00 00       	call   3c1c <exit>
     3b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3bf:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     3c6:	00 
     3c7:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
     3ce:	00 
     3cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3d2:	89 04 24             	mov    %eax,(%esp)
     3d5:	e8 5a 38 00 00       	call   3c34 <read>
     3da:	89 45 ec             	mov    %eax,-0x14(%ebp)
     3dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     3e1:	75 2e                	jne    411 <writetest1+0x151>
     3e3:	81 7d f4 8b 00 00 00 	cmpl   $0x8b,-0xc(%ebp)
     3ea:	0f 85 8c 00 00 00    	jne    47c <writetest1+0x1bc>
     3f0:	a1 3c 58 00 00       	mov    0x583c,%eax
     3f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
     3f8:	89 54 24 08          	mov    %edx,0x8(%esp)
     3fc:	c7 44 24 04 65 43 00 	movl   $0x4365,0x4(%esp)
     403:	00 
     404:	89 04 24             	mov    %eax,(%esp)
     407:	e8 89 39 00 00       	call   3d95 <printf>
     40c:	e8 0b 38 00 00       	call   3c1c <exit>
     411:	81 7d ec 00 02 00 00 	cmpl   $0x200,-0x14(%ebp)
     418:	74 21                	je     43b <writetest1+0x17b>
     41a:	a1 3c 58 00 00       	mov    0x583c,%eax
     41f:	8b 55 ec             	mov    -0x14(%ebp),%edx
     422:	89 54 24 08          	mov    %edx,0x8(%esp)
     426:	c7 44 24 04 82 43 00 	movl   $0x4382,0x4(%esp)
     42d:	00 
     42e:	89 04 24             	mov    %eax,(%esp)
     431:	e8 5f 39 00 00       	call   3d95 <printf>
     436:	e8 e1 37 00 00       	call   3c1c <exit>
     43b:	b8 20 80 00 00       	mov    $0x8020,%eax
     440:	8b 00                	mov    (%eax),%eax
     442:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     445:	74 2c                	je     473 <writetest1+0x1b3>
     447:	b8 20 80 00 00       	mov    $0x8020,%eax
     44c:	8b 10                	mov    (%eax),%edx
     44e:	a1 3c 58 00 00       	mov    0x583c,%eax
     453:	89 54 24 0c          	mov    %edx,0xc(%esp)
     457:	8b 55 f4             	mov    -0xc(%ebp),%edx
     45a:	89 54 24 08          	mov    %edx,0x8(%esp)
     45e:	c7 44 24 04 94 43 00 	movl   $0x4394,0x4(%esp)
     465:	00 
     466:	89 04 24             	mov    %eax,(%esp)
     469:	e8 27 39 00 00       	call   3d95 <printf>
     46e:	e8 a9 37 00 00       	call   3c1c <exit>
     473:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     477:	e9 43 ff ff ff       	jmp    3bf <writetest1+0xff>
     47c:	90                   	nop
     47d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     480:	89 04 24             	mov    %eax,(%esp)
     483:	e8 bc 37 00 00       	call   3c44 <close>
     488:	c7 04 24 10 43 00 00 	movl   $0x4310,(%esp)
     48f:	e8 d8 37 00 00       	call   3c6c <unlink>
     494:	85 c0                	test   %eax,%eax
     496:	79 1a                	jns    4b2 <writetest1+0x1f2>
     498:	a1 3c 58 00 00       	mov    0x583c,%eax
     49d:	c7 44 24 04 b4 43 00 	movl   $0x43b4,0x4(%esp)
     4a4:	00 
     4a5:	89 04 24             	mov    %eax,(%esp)
     4a8:	e8 e8 38 00 00       	call   3d95 <printf>
     4ad:	e8 6a 37 00 00       	call   3c1c <exit>
     4b2:	a1 3c 58 00 00       	mov    0x583c,%eax
     4b7:	c7 44 24 04 c7 43 00 	movl   $0x43c7,0x4(%esp)
     4be:	00 
     4bf:	89 04 24             	mov    %eax,(%esp)
     4c2:	e8 ce 38 00 00       	call   3d95 <printf>
     4c7:	c9                   	leave  
     4c8:	c3                   	ret    

000004c9 <createtest>:
     4c9:	55                   	push   %ebp
     4ca:	89 e5                	mov    %esp,%ebp
     4cc:	83 ec 28             	sub    $0x28,%esp
     4cf:	a1 3c 58 00 00       	mov    0x583c,%eax
     4d4:	c7 44 24 04 d8 43 00 	movl   $0x43d8,0x4(%esp)
     4db:	00 
     4dc:	89 04 24             	mov    %eax,(%esp)
     4df:	e8 b1 38 00 00       	call   3d95 <printf>
     4e4:	c6 05 20 a0 00 00 61 	movb   $0x61,0xa020
     4eb:	c6 05 22 a0 00 00 00 	movb   $0x0,0xa022
     4f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     4f9:	eb 31                	jmp    52c <createtest+0x63>
     4fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4fe:	83 c0 30             	add    $0x30,%eax
     501:	a2 21 a0 00 00       	mov    %al,0xa021
     506:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     50d:	00 
     50e:	c7 04 24 20 a0 00 00 	movl   $0xa020,(%esp)
     515:	e8 42 37 00 00       	call   3c5c <open>
     51a:	89 45 f4             	mov    %eax,-0xc(%ebp)
     51d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     520:	89 04 24             	mov    %eax,(%esp)
     523:	e8 1c 37 00 00       	call   3c44 <close>
     528:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     52c:	83 7d f0 33          	cmpl   $0x33,-0x10(%ebp)
     530:	7e c9                	jle    4fb <createtest+0x32>
     532:	c6 05 20 a0 00 00 61 	movb   $0x61,0xa020
     539:	c6 05 22 a0 00 00 00 	movb   $0x0,0xa022
     540:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     547:	eb 1b                	jmp    564 <createtest+0x9b>
     549:	8b 45 f0             	mov    -0x10(%ebp),%eax
     54c:	83 c0 30             	add    $0x30,%eax
     54f:	a2 21 a0 00 00       	mov    %al,0xa021
     554:	c7 04 24 20 a0 00 00 	movl   $0xa020,(%esp)
     55b:	e8 0c 37 00 00       	call   3c6c <unlink>
     560:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     564:	83 7d f0 33          	cmpl   $0x33,-0x10(%ebp)
     568:	7e df                	jle    549 <createtest+0x80>
     56a:	a1 3c 58 00 00       	mov    0x583c,%eax
     56f:	c7 44 24 04 00 44 00 	movl   $0x4400,0x4(%esp)
     576:	00 
     577:	89 04 24             	mov    %eax,(%esp)
     57a:	e8 16 38 00 00       	call   3d95 <printf>
     57f:	c9                   	leave  
     580:	c3                   	ret    

00000581 <dirtest>:
     581:	55                   	push   %ebp
     582:	89 e5                	mov    %esp,%ebp
     584:	83 ec 18             	sub    $0x18,%esp
     587:	a1 3c 58 00 00       	mov    0x583c,%eax
     58c:	c7 44 24 04 26 44 00 	movl   $0x4426,0x4(%esp)
     593:	00 
     594:	89 04 24             	mov    %eax,(%esp)
     597:	e8 f9 37 00 00       	call   3d95 <printf>
     59c:	c7 04 24 32 44 00 00 	movl   $0x4432,(%esp)
     5a3:	e8 dc 36 00 00       	call   3c84 <mkdir>
     5a8:	85 c0                	test   %eax,%eax
     5aa:	79 1a                	jns    5c6 <dirtest+0x45>
     5ac:	a1 3c 58 00 00       	mov    0x583c,%eax
     5b1:	c7 44 24 04 37 44 00 	movl   $0x4437,0x4(%esp)
     5b8:	00 
     5b9:	89 04 24             	mov    %eax,(%esp)
     5bc:	e8 d4 37 00 00       	call   3d95 <printf>
     5c1:	e8 56 36 00 00       	call   3c1c <exit>
     5c6:	c7 04 24 32 44 00 00 	movl   $0x4432,(%esp)
     5cd:	e8 ba 36 00 00       	call   3c8c <chdir>
     5d2:	85 c0                	test   %eax,%eax
     5d4:	79 1a                	jns    5f0 <dirtest+0x6f>
     5d6:	a1 3c 58 00 00       	mov    0x583c,%eax
     5db:	c7 44 24 04 45 44 00 	movl   $0x4445,0x4(%esp)
     5e2:	00 
     5e3:	89 04 24             	mov    %eax,(%esp)
     5e6:	e8 aa 37 00 00       	call   3d95 <printf>
     5eb:	e8 2c 36 00 00       	call   3c1c <exit>
     5f0:	c7 04 24 58 44 00 00 	movl   $0x4458,(%esp)
     5f7:	e8 90 36 00 00       	call   3c8c <chdir>
     5fc:	85 c0                	test   %eax,%eax
     5fe:	79 1a                	jns    61a <dirtest+0x99>
     600:	a1 3c 58 00 00       	mov    0x583c,%eax
     605:	c7 44 24 04 5b 44 00 	movl   $0x445b,0x4(%esp)
     60c:	00 
     60d:	89 04 24             	mov    %eax,(%esp)
     610:	e8 80 37 00 00       	call   3d95 <printf>
     615:	e8 02 36 00 00       	call   3c1c <exit>
     61a:	c7 04 24 32 44 00 00 	movl   $0x4432,(%esp)
     621:	e8 46 36 00 00       	call   3c6c <unlink>
     626:	85 c0                	test   %eax,%eax
     628:	79 1a                	jns    644 <dirtest+0xc3>
     62a:	a1 3c 58 00 00       	mov    0x583c,%eax
     62f:	c7 44 24 04 6c 44 00 	movl   $0x446c,0x4(%esp)
     636:	00 
     637:	89 04 24             	mov    %eax,(%esp)
     63a:	e8 56 37 00 00       	call   3d95 <printf>
     63f:	e8 d8 35 00 00       	call   3c1c <exit>
     644:	a1 3c 58 00 00       	mov    0x583c,%eax
     649:	c7 44 24 04 26 44 00 	movl   $0x4426,0x4(%esp)
     650:	00 
     651:	89 04 24             	mov    %eax,(%esp)
     654:	e8 3c 37 00 00       	call   3d95 <printf>
     659:	c9                   	leave  
     65a:	c3                   	ret    

0000065b <exectest>:
     65b:	55                   	push   %ebp
     65c:	89 e5                	mov    %esp,%ebp
     65e:	83 ec 18             	sub    $0x18,%esp
     661:	a1 3c 58 00 00       	mov    0x583c,%eax
     666:	c7 44 24 04 80 44 00 	movl   $0x4480,0x4(%esp)
     66d:	00 
     66e:	89 04 24             	mov    %eax,(%esp)
     671:	e8 1f 37 00 00       	call   3d95 <printf>
     676:	c7 44 24 04 28 58 00 	movl   $0x5828,0x4(%esp)
     67d:	00 
     67e:	c7 04 24 5c 41 00 00 	movl   $0x415c,(%esp)
     685:	e8 ca 35 00 00       	call   3c54 <exec>
     68a:	85 c0                	test   %eax,%eax
     68c:	79 1a                	jns    6a8 <exectest+0x4d>
     68e:	a1 3c 58 00 00       	mov    0x583c,%eax
     693:	c7 44 24 04 8b 44 00 	movl   $0x448b,0x4(%esp)
     69a:	00 
     69b:	89 04 24             	mov    %eax,(%esp)
     69e:	e8 f2 36 00 00       	call   3d95 <printf>
     6a3:	e8 74 35 00 00       	call   3c1c <exit>
     6a8:	c9                   	leave  
     6a9:	c3                   	ret    

000006aa <pipe1>:
     6aa:	55                   	push   %ebp
     6ab:	89 e5                	mov    %esp,%ebp
     6ad:	83 ec 38             	sub    $0x38,%esp
     6b0:	8d 45 d8             	lea    -0x28(%ebp),%eax
     6b3:	89 04 24             	mov    %eax,(%esp)
     6b6:	e8 71 35 00 00       	call   3c2c <pipe>
     6bb:	85 c0                	test   %eax,%eax
     6bd:	74 19                	je     6d8 <pipe1+0x2e>
     6bf:	c7 44 24 04 9d 44 00 	movl   $0x449d,0x4(%esp)
     6c6:	00 
     6c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6ce:	e8 c2 36 00 00       	call   3d95 <printf>
     6d3:	e8 44 35 00 00       	call   3c1c <exit>
     6d8:	e8 37 35 00 00       	call   3c14 <fork>
     6dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
     6e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
     6e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     6eb:	0f 85 84 00 00 00    	jne    775 <pipe1+0xcb>
     6f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
     6f4:	89 04 24             	mov    %eax,(%esp)
     6f7:	e8 48 35 00 00       	call   3c44 <close>
     6fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     703:	eb 65                	jmp    76a <pipe1+0xc0>
     705:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     70c:	eb 14                	jmp    722 <pipe1+0x78>
     70e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     711:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     714:	88 90 20 80 00 00    	mov    %dl,0x8020(%eax)
     71a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     71e:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
     722:	81 7d e8 08 04 00 00 	cmpl   $0x408,-0x18(%ebp)
     729:	7e e3                	jle    70e <pipe1+0x64>
     72b:	8b 45 dc             	mov    -0x24(%ebp),%eax
     72e:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
     735:	00 
     736:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
     73d:	00 
     73e:	89 04 24             	mov    %eax,(%esp)
     741:	e8 f6 34 00 00       	call   3c3c <write>
     746:	3d 09 04 00 00       	cmp    $0x409,%eax
     74b:	74 19                	je     766 <pipe1+0xbc>
     74d:	c7 44 24 04 ac 44 00 	movl   $0x44ac,0x4(%esp)
     754:	00 
     755:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     75c:	e8 34 36 00 00       	call   3d95 <printf>
     761:	e8 b6 34 00 00       	call   3c1c <exit>
     766:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     76a:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     76e:	7e 95                	jle    705 <pipe1+0x5b>
     770:	e8 a7 34 00 00       	call   3c1c <exit>
     775:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     779:	0f 8e fb 00 00 00    	jle    87a <pipe1+0x1d0>
     77f:	8b 45 dc             	mov    -0x24(%ebp),%eax
     782:	89 04 24             	mov    %eax,(%esp)
     785:	e8 ba 34 00 00       	call   3c44 <close>
     78a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     791:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     798:	eb 6a                	jmp    804 <pipe1+0x15a>
     79a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     7a1:	eb 3f                	jmp    7e2 <pipe1+0x138>
     7a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7a6:	0f b6 80 20 80 00 00 	movzbl 0x8020(%eax),%eax
     7ad:	0f be c0             	movsbl %al,%eax
     7b0:	33 45 e4             	xor    -0x1c(%ebp),%eax
     7b3:	25 ff 00 00 00       	and    $0xff,%eax
     7b8:	85 c0                	test   %eax,%eax
     7ba:	0f 95 c0             	setne  %al
     7bd:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     7c1:	84 c0                	test   %al,%al
     7c3:	74 19                	je     7de <pipe1+0x134>
     7c5:	c7 44 24 04 ba 44 00 	movl   $0x44ba,0x4(%esp)
     7cc:	00 
     7cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     7d4:	e8 bc 35 00 00       	call   3d95 <printf>
     7d9:	e9 b5 00 00 00       	jmp    893 <pipe1+0x1e9>
     7de:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
     7e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     7e8:	7c b9                	jl     7a3 <pipe1+0xf9>
     7ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
     7ed:	01 45 f4             	add    %eax,-0xc(%ebp)
     7f0:	d1 65 f0             	shll   -0x10(%ebp)
     7f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7f6:	3d 00 20 00 00       	cmp    $0x2000,%eax
     7fb:	76 07                	jbe    804 <pipe1+0x15a>
     7fd:	c7 45 f0 00 20 00 00 	movl   $0x2000,-0x10(%ebp)
     804:	8b 45 d8             	mov    -0x28(%ebp),%eax
     807:	8b 55 f0             	mov    -0x10(%ebp),%edx
     80a:	89 54 24 08          	mov    %edx,0x8(%esp)
     80e:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
     815:	00 
     816:	89 04 24             	mov    %eax,(%esp)
     819:	e8 16 34 00 00       	call   3c34 <read>
     81e:	89 45 ec             	mov    %eax,-0x14(%ebp)
     821:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     825:	0f 8f 6f ff ff ff    	jg     79a <pipe1+0xf0>
     82b:	81 7d f4 2d 14 00 00 	cmpl   $0x142d,-0xc(%ebp)
     832:	74 20                	je     854 <pipe1+0x1aa>
     834:	8b 45 f4             	mov    -0xc(%ebp),%eax
     837:	89 44 24 08          	mov    %eax,0x8(%esp)
     83b:	c7 44 24 04 c8 44 00 	movl   $0x44c8,0x4(%esp)
     842:	00 
     843:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     84a:	e8 46 35 00 00       	call   3d95 <printf>
     84f:	e8 c8 33 00 00       	call   3c1c <exit>
     854:	8b 45 d8             	mov    -0x28(%ebp),%eax
     857:	89 04 24             	mov    %eax,(%esp)
     85a:	e8 e5 33 00 00       	call   3c44 <close>
     85f:	e8 c0 33 00 00       	call   3c24 <wait>
     864:	c7 44 24 04 df 44 00 	movl   $0x44df,0x4(%esp)
     86b:	00 
     86c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     873:	e8 1d 35 00 00       	call   3d95 <printf>
     878:	eb 19                	jmp    893 <pipe1+0x1e9>
     87a:	c7 44 24 04 e9 44 00 	movl   $0x44e9,0x4(%esp)
     881:	00 
     882:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     889:	e8 07 35 00 00       	call   3d95 <printf>
     88e:	e8 89 33 00 00       	call   3c1c <exit>
     893:	c9                   	leave  
     894:	c3                   	ret    

00000895 <preempt>:
     895:	55                   	push   %ebp
     896:	89 e5                	mov    %esp,%ebp
     898:	83 ec 38             	sub    $0x38,%esp
     89b:	c7 44 24 04 f8 44 00 	movl   $0x44f8,0x4(%esp)
     8a2:	00 
     8a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8aa:	e8 e6 34 00 00       	call   3d95 <printf>
     8af:	e8 60 33 00 00       	call   3c14 <fork>
     8b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
     8b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     8bb:	75 02                	jne    8bf <preempt+0x2a>
     8bd:	eb fe                	jmp    8bd <preempt+0x28>
     8bf:	e8 50 33 00 00       	call   3c14 <fork>
     8c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
     8c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8cb:	75 02                	jne    8cf <preempt+0x3a>
     8cd:	eb fe                	jmp    8cd <preempt+0x38>
     8cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     8d2:	89 04 24             	mov    %eax,(%esp)
     8d5:	e8 52 33 00 00       	call   3c2c <pipe>
     8da:	e8 35 33 00 00       	call   3c14 <fork>
     8df:	89 45 f4             	mov    %eax,-0xc(%ebp)
     8e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     8e6:	75 4c                	jne    934 <preempt+0x9f>
     8e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8eb:	89 04 24             	mov    %eax,(%esp)
     8ee:	e8 51 33 00 00       	call   3c44 <close>
     8f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8f6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     8fd:	00 
     8fe:	c7 44 24 04 02 45 00 	movl   $0x4502,0x4(%esp)
     905:	00 
     906:	89 04 24             	mov    %eax,(%esp)
     909:	e8 2e 33 00 00       	call   3c3c <write>
     90e:	83 f8 01             	cmp    $0x1,%eax
     911:	74 14                	je     927 <preempt+0x92>
     913:	c7 44 24 04 04 45 00 	movl   $0x4504,0x4(%esp)
     91a:	00 
     91b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     922:	e8 6e 34 00 00       	call   3d95 <printf>
     927:	8b 45 e8             	mov    -0x18(%ebp),%eax
     92a:	89 04 24             	mov    %eax,(%esp)
     92d:	e8 12 33 00 00       	call   3c44 <close>
     932:	eb fe                	jmp    932 <preempt+0x9d>
     934:	8b 45 e8             	mov    -0x18(%ebp),%eax
     937:	89 04 24             	mov    %eax,(%esp)
     93a:	e8 05 33 00 00       	call   3c44 <close>
     93f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     942:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     949:	00 
     94a:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
     951:	00 
     952:	89 04 24             	mov    %eax,(%esp)
     955:	e8 da 32 00 00       	call   3c34 <read>
     95a:	83 f8 01             	cmp    $0x1,%eax
     95d:	74 16                	je     975 <preempt+0xe0>
     95f:	c7 44 24 04 18 45 00 	movl   $0x4518,0x4(%esp)
     966:	00 
     967:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     96e:	e8 22 34 00 00       	call   3d95 <printf>
     973:	eb 77                	jmp    9ec <preempt+0x157>
     975:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     978:	89 04 24             	mov    %eax,(%esp)
     97b:	e8 c4 32 00 00       	call   3c44 <close>
     980:	c7 44 24 04 2b 45 00 	movl   $0x452b,0x4(%esp)
     987:	00 
     988:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     98f:	e8 01 34 00 00       	call   3d95 <printf>
     994:	8b 45 ec             	mov    -0x14(%ebp),%eax
     997:	89 04 24             	mov    %eax,(%esp)
     99a:	e8 ad 32 00 00       	call   3c4c <kill>
     99f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9a2:	89 04 24             	mov    %eax,(%esp)
     9a5:	e8 a2 32 00 00       	call   3c4c <kill>
     9aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9ad:	89 04 24             	mov    %eax,(%esp)
     9b0:	e8 97 32 00 00       	call   3c4c <kill>
     9b5:	c7 44 24 04 34 45 00 	movl   $0x4534,0x4(%esp)
     9bc:	00 
     9bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9c4:	e8 cc 33 00 00       	call   3d95 <printf>
     9c9:	e8 56 32 00 00       	call   3c24 <wait>
     9ce:	e8 51 32 00 00       	call   3c24 <wait>
     9d3:	e8 4c 32 00 00       	call   3c24 <wait>
     9d8:	c7 44 24 04 3d 45 00 	movl   $0x453d,0x4(%esp)
     9df:	00 
     9e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9e7:	e8 a9 33 00 00       	call   3d95 <printf>
     9ec:	c9                   	leave  
     9ed:	c3                   	ret    

000009ee <exitwait>:
     9ee:	55                   	push   %ebp
     9ef:	89 e5                	mov    %esp,%ebp
     9f1:	83 ec 28             	sub    $0x28,%esp
     9f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     9fb:	eb 53                	jmp    a50 <exitwait+0x62>
     9fd:	e8 12 32 00 00       	call   3c14 <fork>
     a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
     a05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     a09:	79 16                	jns    a21 <exitwait+0x33>
     a0b:	c7 44 24 04 49 45 00 	movl   $0x4549,0x4(%esp)
     a12:	00 
     a13:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a1a:	e8 76 33 00 00       	call   3d95 <printf>
     a1f:	eb 49                	jmp    a6a <exitwait+0x7c>
     a21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     a25:	74 20                	je     a47 <exitwait+0x59>
     a27:	e8 f8 31 00 00       	call   3c24 <wait>
     a2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     a2f:	74 1b                	je     a4c <exitwait+0x5e>
     a31:	c7 44 24 04 56 45 00 	movl   $0x4556,0x4(%esp)
     a38:	00 
     a39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a40:	e8 50 33 00 00       	call   3d95 <printf>
     a45:	eb 23                	jmp    a6a <exitwait+0x7c>
     a47:	e8 d0 31 00 00       	call   3c1c <exit>
     a4c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     a50:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
     a54:	7e a7                	jle    9fd <exitwait+0xf>
     a56:	c7 44 24 04 66 45 00 	movl   $0x4566,0x4(%esp)
     a5d:	00 
     a5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a65:	e8 2b 33 00 00       	call   3d95 <printf>
     a6a:	c9                   	leave  
     a6b:	c3                   	ret    

00000a6c <mem>:
     a6c:	55                   	push   %ebp
     a6d:	89 e5                	mov    %esp,%ebp
     a6f:	83 ec 28             	sub    $0x28,%esp
     a72:	c7 44 24 04 73 45 00 	movl   $0x4573,0x4(%esp)
     a79:	00 
     a7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a81:	e8 0f 33 00 00       	call   3d95 <printf>
     a86:	e8 11 32 00 00       	call   3c9c <getpid>
     a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
     a8e:	e8 81 31 00 00       	call   3c14 <fork>
     a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a9a:	0f 85 aa 00 00 00    	jne    b4a <mem+0xde>
     aa0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     aa7:	eb 0e                	jmp    ab7 <mem+0x4b>
     aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
     aac:	8b 55 e8             	mov    -0x18(%ebp),%edx
     aaf:	89 10                	mov    %edx,(%eax)
     ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ab4:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ab7:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
     abe:	e8 b8 35 00 00       	call   407b <malloc>
     ac3:	89 45 ec             	mov    %eax,-0x14(%ebp)
     ac6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     aca:	75 dd                	jne    aa9 <mem+0x3d>
     acc:	eb 19                	jmp    ae7 <mem+0x7b>
     ace:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ad1:	8b 00                	mov    (%eax),%eax
     ad3:	89 45 ec             	mov    %eax,-0x14(%ebp)
     ad6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ad9:	89 04 24             	mov    %eax,(%esp)
     adc:	e8 6b 34 00 00       	call   3f4c <free>
     ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ae4:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ae7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     aeb:	75 e1                	jne    ace <mem+0x62>
     aed:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
     af4:	e8 82 35 00 00       	call   407b <malloc>
     af9:	89 45 e8             	mov    %eax,-0x18(%ebp)
     afc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b00:	75 24                	jne    b26 <mem+0xba>
     b02:	c7 44 24 04 7d 45 00 	movl   $0x457d,0x4(%esp)
     b09:	00 
     b0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b11:	e8 7f 32 00 00       	call   3d95 <printf>
     b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b19:	89 04 24             	mov    %eax,(%esp)
     b1c:	e8 2b 31 00 00       	call   3c4c <kill>
     b21:	e8 f6 30 00 00       	call   3c1c <exit>
     b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b29:	89 04 24             	mov    %eax,(%esp)
     b2c:	e8 1b 34 00 00       	call   3f4c <free>
     b31:	c7 44 24 04 97 45 00 	movl   $0x4597,0x4(%esp)
     b38:	00 
     b39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b40:	e8 50 32 00 00       	call   3d95 <printf>
     b45:	e8 d2 30 00 00       	call   3c1c <exit>
     b4a:	e8 d5 30 00 00       	call   3c24 <wait>
     b4f:	c9                   	leave  
     b50:	c3                   	ret    

00000b51 <sharedfd>:
     b51:	55                   	push   %ebp
     b52:	89 e5                	mov    %esp,%ebp
     b54:	83 ec 48             	sub    $0x48,%esp
     b57:	c7 44 24 04 9f 45 00 	movl   $0x459f,0x4(%esp)
     b5e:	00 
     b5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b66:	e8 2a 32 00 00       	call   3d95 <printf>
     b6b:	c7 04 24 ae 45 00 00 	movl   $0x45ae,(%esp)
     b72:	e8 f5 30 00 00       	call   3c6c <unlink>
     b77:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     b7e:	00 
     b7f:	c7 04 24 ae 45 00 00 	movl   $0x45ae,(%esp)
     b86:	e8 d1 30 00 00       	call   3c5c <open>
     b8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
     b8e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     b92:	79 19                	jns    bad <sharedfd+0x5c>
     b94:	c7 44 24 04 b8 45 00 	movl   $0x45b8,0x4(%esp)
     b9b:	00 
     b9c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ba3:	e8 ed 31 00 00       	call   3d95 <printf>
     ba8:	e9 9b 01 00 00       	jmp    d48 <sharedfd+0x1f7>
     bad:	e8 62 30 00 00       	call   3c14 <fork>
     bb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     bb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     bb9:	75 07                	jne    bc2 <sharedfd+0x71>
     bbb:	b8 63 00 00 00       	mov    $0x63,%eax
     bc0:	eb 05                	jmp    bc7 <sharedfd+0x76>
     bc2:	b8 70 00 00 00       	mov    $0x70,%eax
     bc7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     bce:	00 
     bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
     bd3:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     bd6:	89 04 24             	mov    %eax,(%esp)
     bd9:	e8 98 2e 00 00       	call   3a76 <memset>
     bde:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     be5:	eb 39                	jmp    c20 <sharedfd+0xcf>
     be7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     bee:	00 
     bef:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     bf2:	89 44 24 04          	mov    %eax,0x4(%esp)
     bf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
     bf9:	89 04 24             	mov    %eax,(%esp)
     bfc:	e8 3b 30 00 00       	call   3c3c <write>
     c01:	83 f8 0a             	cmp    $0xa,%eax
     c04:	74 16                	je     c1c <sharedfd+0xcb>
     c06:	c7 44 24 04 e4 45 00 	movl   $0x45e4,0x4(%esp)
     c0d:	00 
     c0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c15:	e8 7b 31 00 00       	call   3d95 <printf>
     c1a:	eb 0d                	jmp    c29 <sharedfd+0xd8>
     c1c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
     c20:	81 7d e8 e7 03 00 00 	cmpl   $0x3e7,-0x18(%ebp)
     c27:	7e be                	jle    be7 <sharedfd+0x96>
     c29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     c2d:	75 05                	jne    c34 <sharedfd+0xe3>
     c2f:	e8 e8 2f 00 00       	call   3c1c <exit>
     c34:	e8 eb 2f 00 00       	call   3c24 <wait>
     c39:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c3c:	89 04 24             	mov    %eax,(%esp)
     c3f:	e8 00 30 00 00       	call   3c44 <close>
     c44:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c4b:	00 
     c4c:	c7 04 24 ae 45 00 00 	movl   $0x45ae,(%esp)
     c53:	e8 04 30 00 00       	call   3c5c <open>
     c58:	89 45 e0             	mov    %eax,-0x20(%ebp)
     c5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     c5f:	79 19                	jns    c7a <sharedfd+0x129>
     c61:	c7 44 24 04 04 46 00 	movl   $0x4604,0x4(%esp)
     c68:	00 
     c69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c70:	e8 20 31 00 00       	call   3d95 <printf>
     c75:	e9 ce 00 00 00       	jmp    d48 <sharedfd+0x1f7>
     c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
     c87:	eb 35                	jmp    cbe <sharedfd+0x16d>
     c89:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     c90:	eb 24                	jmp    cb6 <sharedfd+0x165>
     c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c95:	0f b6 44 05 d6       	movzbl -0x2a(%ebp,%eax,1),%eax
     c9a:	3c 63                	cmp    $0x63,%al
     c9c:	75 04                	jne    ca2 <sharedfd+0x151>
     c9e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     ca2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ca5:	0f b6 44 05 d6       	movzbl -0x2a(%ebp,%eax,1),%eax
     caa:	3c 70                	cmp    $0x70,%al
     cac:	75 04                	jne    cb2 <sharedfd+0x161>
     cae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     cb2:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
     cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cb9:	83 f8 09             	cmp    $0x9,%eax
     cbc:	76 d4                	jbe    c92 <sharedfd+0x141>
     cbe:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     cc5:	00 
     cc6:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     cc9:	89 44 24 04          	mov    %eax,0x4(%esp)
     ccd:	8b 45 e0             	mov    -0x20(%ebp),%eax
     cd0:	89 04 24             	mov    %eax,(%esp)
     cd3:	e8 5c 2f 00 00       	call   3c34 <read>
     cd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
     cdb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     cdf:	7f a8                	jg     c89 <sharedfd+0x138>
     ce1:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ce4:	89 04 24             	mov    %eax,(%esp)
     ce7:	e8 58 2f 00 00       	call   3c44 <close>
     cec:	c7 04 24 ae 45 00 00 	movl   $0x45ae,(%esp)
     cf3:	e8 74 2f 00 00       	call   3c6c <unlink>
     cf8:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     cff:	75 20                	jne    d21 <sharedfd+0x1d0>
     d01:	81 7d f4 10 27 00 00 	cmpl   $0x2710,-0xc(%ebp)
     d08:	75 17                	jne    d21 <sharedfd+0x1d0>
     d0a:	c7 44 24 04 2f 46 00 	movl   $0x462f,0x4(%esp)
     d11:	00 
     d12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d19:	e8 77 30 00 00       	call   3d95 <printf>
     d1e:	90                   	nop
     d1f:	eb 27                	jmp    d48 <sharedfd+0x1f7>
     d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d24:	89 44 24 0c          	mov    %eax,0xc(%esp)
     d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d2b:	89 44 24 08          	mov    %eax,0x8(%esp)
     d2f:	c7 44 24 04 3c 46 00 	movl   $0x463c,0x4(%esp)
     d36:	00 
     d37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d3e:	e8 52 30 00 00       	call   3d95 <printf>
     d43:	e8 d4 2e 00 00       	call   3c1c <exit>
     d48:	c9                   	leave  
     d49:	c3                   	ret    

00000d4a <twofiles>:
     d4a:	55                   	push   %ebp
     d4b:	89 e5                	mov    %esp,%ebp
     d4d:	83 ec 38             	sub    $0x38,%esp
     d50:	c7 44 24 04 51 46 00 	movl   $0x4651,0x4(%esp)
     d57:	00 
     d58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d5f:	e8 31 30 00 00       	call   3d95 <printf>
     d64:	c7 04 24 60 46 00 00 	movl   $0x4660,(%esp)
     d6b:	e8 fc 2e 00 00       	call   3c6c <unlink>
     d70:	c7 04 24 63 46 00 00 	movl   $0x4663,(%esp)
     d77:	e8 f0 2e 00 00       	call   3c6c <unlink>
     d7c:	e8 93 2e 00 00       	call   3c14 <fork>
     d81:	89 45 e0             	mov    %eax,-0x20(%ebp)
     d84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     d88:	79 19                	jns    da3 <twofiles+0x59>
     d8a:	c7 44 24 04 49 45 00 	movl   $0x4549,0x4(%esp)
     d91:	00 
     d92:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d99:	e8 f7 2f 00 00       	call   3d95 <printf>
     d9e:	e8 79 2e 00 00       	call   3c1c <exit>
     da3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     da7:	74 07                	je     db0 <twofiles+0x66>
     da9:	b8 60 46 00 00       	mov    $0x4660,%eax
     dae:	eb 05                	jmp    db5 <twofiles+0x6b>
     db0:	b8 63 46 00 00       	mov    $0x4663,%eax
     db5:	89 45 f4             	mov    %eax,-0xc(%ebp)
     db8:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     dbf:	00 
     dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dc3:	89 04 24             	mov    %eax,(%esp)
     dc6:	e8 91 2e 00 00       	call   3c5c <open>
     dcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
     dce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
     dd2:	79 19                	jns    ded <twofiles+0xa3>
     dd4:	c7 44 24 04 66 46 00 	movl   $0x4666,0x4(%esp)
     ddb:	00 
     ddc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     de3:	e8 ad 2f 00 00       	call   3d95 <printf>
     de8:	e8 2f 2e 00 00       	call   3c1c <exit>
     ded:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     df1:	74 07                	je     dfa <twofiles+0xb0>
     df3:	b8 70 00 00 00       	mov    $0x70,%eax
     df8:	eb 05                	jmp    dff <twofiles+0xb5>
     dfa:	b8 63 00 00 00       	mov    $0x63,%eax
     dff:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     e06:	00 
     e07:	89 44 24 04          	mov    %eax,0x4(%esp)
     e0b:	c7 04 24 20 80 00 00 	movl   $0x8020,(%esp)
     e12:	e8 5f 2c 00 00       	call   3a76 <memset>
     e17:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
     e1e:	eb 4b                	jmp    e6b <twofiles+0x121>
     e20:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
     e27:	00 
     e28:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
     e2f:	00 
     e30:	8b 45 dc             	mov    -0x24(%ebp),%eax
     e33:	89 04 24             	mov    %eax,(%esp)
     e36:	e8 01 2e 00 00       	call   3c3c <write>
     e3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
     e3e:	81 7d ec f4 01 00 00 	cmpl   $0x1f4,-0x14(%ebp)
     e45:	74 20                	je     e67 <twofiles+0x11d>
     e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e4a:	89 44 24 08          	mov    %eax,0x8(%esp)
     e4e:	c7 44 24 04 75 46 00 	movl   $0x4675,0x4(%esp)
     e55:	00 
     e56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e5d:	e8 33 2f 00 00       	call   3d95 <printf>
     e62:	e8 b5 2d 00 00       	call   3c1c <exit>
     e67:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     e6b:	83 7d e4 0b          	cmpl   $0xb,-0x1c(%ebp)
     e6f:	7e af                	jle    e20 <twofiles+0xd6>
     e71:	8b 45 dc             	mov    -0x24(%ebp),%eax
     e74:	89 04 24             	mov    %eax,(%esp)
     e77:	e8 c8 2d 00 00       	call   3c44 <close>
     e7c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     e80:	74 11                	je     e93 <twofiles+0x149>
     e82:	e8 9d 2d 00 00       	call   3c24 <wait>
     e87:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
     e8e:	e9 e6 00 00 00       	jmp    f79 <twofiles+0x22f>
     e93:	e8 84 2d 00 00       	call   3c1c <exit>
     e98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     e9c:	74 07                	je     ea5 <twofiles+0x15b>
     e9e:	b8 60 46 00 00       	mov    $0x4660,%eax
     ea3:	eb 05                	jmp    eaa <twofiles+0x160>
     ea5:	b8 63 46 00 00       	mov    $0x4663,%eax
     eaa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     eb1:	00 
     eb2:	89 04 24             	mov    %eax,(%esp)
     eb5:	e8 a2 2d 00 00       	call   3c5c <open>
     eba:	89 45 dc             	mov    %eax,-0x24(%ebp)
     ebd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     ec4:	eb 57                	jmp    f1d <twofiles+0x1d3>
     ec6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     ecd:	eb 40                	jmp    f0f <twofiles+0x1c5>
     ecf:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ed2:	0f b6 80 20 80 00 00 	movzbl 0x8020(%eax),%eax
     ed9:	0f be d0             	movsbl %al,%edx
     edc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     ee0:	74 07                	je     ee9 <twofiles+0x19f>
     ee2:	b8 70 00 00 00       	mov    $0x70,%eax
     ee7:	eb 05                	jmp    eee <twofiles+0x1a4>
     ee9:	b8 63 00 00 00       	mov    $0x63,%eax
     eee:	39 c2                	cmp    %eax,%edx
     ef0:	74 19                	je     f0b <twofiles+0x1c1>
     ef2:	c7 44 24 04 86 46 00 	movl   $0x4686,0x4(%esp)
     ef9:	00 
     efa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f01:	e8 8f 2e 00 00       	call   3d95 <printf>
     f06:	e8 11 2d 00 00       	call   3c1c <exit>
     f0b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
     f0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f12:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     f15:	7c b8                	jl     ecf <twofiles+0x185>
     f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f1a:	01 45 f0             	add    %eax,-0x10(%ebp)
     f1d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     f24:	00 
     f25:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
     f2c:	00 
     f2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     f30:	89 04 24             	mov    %eax,(%esp)
     f33:	e8 fc 2c 00 00       	call   3c34 <read>
     f38:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f3f:	7f 85                	jg     ec6 <twofiles+0x17c>
     f41:	8b 45 dc             	mov    -0x24(%ebp),%eax
     f44:	89 04 24             	mov    %eax,(%esp)
     f47:	e8 f8 2c 00 00       	call   3c44 <close>
     f4c:	81 7d f0 70 17 00 00 	cmpl   $0x1770,-0x10(%ebp)
     f53:	74 20                	je     f75 <twofiles+0x22b>
     f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f58:	89 44 24 08          	mov    %eax,0x8(%esp)
     f5c:	c7 44 24 04 92 46 00 	movl   $0x4692,0x4(%esp)
     f63:	00 
     f64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f6b:	e8 25 2e 00 00       	call   3d95 <printf>
     f70:	e8 a7 2c 00 00       	call   3c1c <exit>
     f75:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     f79:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
     f7d:	0f 8e 15 ff ff ff    	jle    e98 <twofiles+0x14e>
     f83:	c7 04 24 60 46 00 00 	movl   $0x4660,(%esp)
     f8a:	e8 dd 2c 00 00       	call   3c6c <unlink>
     f8f:	c7 04 24 63 46 00 00 	movl   $0x4663,(%esp)
     f96:	e8 d1 2c 00 00       	call   3c6c <unlink>
     f9b:	c7 44 24 04 a3 46 00 	movl   $0x46a3,0x4(%esp)
     fa2:	00 
     fa3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     faa:	e8 e6 2d 00 00       	call   3d95 <printf>
     faf:	c9                   	leave  
     fb0:	c3                   	ret    

00000fb1 <createdelete>:
     fb1:	55                   	push   %ebp
     fb2:	89 e5                	mov    %esp,%ebp
     fb4:	83 ec 48             	sub    $0x48,%esp
     fb7:	c7 44 24 04 b0 46 00 	movl   $0x46b0,0x4(%esp)
     fbe:	00 
     fbf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fc6:	e8 ca 2d 00 00       	call   3d95 <printf>
     fcb:	e8 44 2c 00 00       	call   3c14 <fork>
     fd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fd7:	79 19                	jns    ff2 <createdelete+0x41>
     fd9:	c7 44 24 04 49 45 00 	movl   $0x4549,0x4(%esp)
     fe0:	00 
     fe1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fe8:	e8 a8 2d 00 00       	call   3d95 <printf>
     fed:	e8 2a 2c 00 00       	call   3c1c <exit>
     ff2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ff6:	74 07                	je     fff <createdelete+0x4e>
     ff8:	b8 70 00 00 00       	mov    $0x70,%eax
     ffd:	eb 05                	jmp    1004 <createdelete+0x53>
     fff:	b8 63 00 00 00       	mov    $0x63,%eax
    1004:	88 45 cc             	mov    %al,-0x34(%ebp)
    1007:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
    100b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1012:	e9 98 00 00 00       	jmp    10af <createdelete+0xfe>
    1017:	8b 45 f0             	mov    -0x10(%ebp),%eax
    101a:	83 c0 30             	add    $0x30,%eax
    101d:	88 45 cd             	mov    %al,-0x33(%ebp)
    1020:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1027:	00 
    1028:	8d 45 cc             	lea    -0x34(%ebp),%eax
    102b:	89 04 24             	mov    %eax,(%esp)
    102e:	e8 29 2c 00 00       	call   3c5c <open>
    1033:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1036:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    103a:	79 19                	jns    1055 <createdelete+0xa4>
    103c:	c7 44 24 04 66 46 00 	movl   $0x4666,0x4(%esp)
    1043:	00 
    1044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    104b:	e8 45 2d 00 00       	call   3d95 <printf>
    1050:	e8 c7 2b 00 00       	call   3c1c <exit>
    1055:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1058:	89 04 24             	mov    %eax,(%esp)
    105b:	e8 e4 2b 00 00       	call   3c44 <close>
    1060:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1064:	7e 45                	jle    10ab <createdelete+0xfa>
    1066:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1069:	83 e0 01             	and    $0x1,%eax
    106c:	85 c0                	test   %eax,%eax
    106e:	75 3b                	jne    10ab <createdelete+0xfa>
    1070:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1073:	89 c2                	mov    %eax,%edx
    1075:	c1 ea 1f             	shr    $0x1f,%edx
    1078:	8d 04 02             	lea    (%edx,%eax,1),%eax
    107b:	d1 f8                	sar    %eax
    107d:	83 c0 30             	add    $0x30,%eax
    1080:	88 45 cd             	mov    %al,-0x33(%ebp)
    1083:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1086:	89 04 24             	mov    %eax,(%esp)
    1089:	e8 de 2b 00 00       	call   3c6c <unlink>
    108e:	85 c0                	test   %eax,%eax
    1090:	79 19                	jns    10ab <createdelete+0xfa>
    1092:	c7 44 24 04 c3 46 00 	movl   $0x46c3,0x4(%esp)
    1099:	00 
    109a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10a1:	e8 ef 2c 00 00       	call   3d95 <printf>
    10a6:	e8 71 2b 00 00       	call   3c1c <exit>
    10ab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    10af:	83 7d f0 13          	cmpl   $0x13,-0x10(%ebp)
    10b3:	0f 8e 5e ff ff ff    	jle    1017 <createdelete+0x66>
    10b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10bd:	75 05                	jne    10c4 <createdelete+0x113>
    10bf:	e8 58 2b 00 00       	call   3c1c <exit>
    10c4:	e8 5b 2b 00 00       	call   3c24 <wait>
    10c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    10d0:	e9 34 01 00 00       	jmp    1209 <createdelete+0x258>
    10d5:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    10d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10dc:	83 c0 30             	add    $0x30,%eax
    10df:	88 45 cd             	mov    %al,-0x33(%ebp)
    10e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10e9:	00 
    10ea:	8d 45 cc             	lea    -0x34(%ebp),%eax
    10ed:	89 04 24             	mov    %eax,(%esp)
    10f0:	e8 67 2b 00 00       	call   3c5c <open>
    10f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    10f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10fc:	74 06                	je     1104 <createdelete+0x153>
    10fe:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
    1102:	7e 26                	jle    112a <createdelete+0x179>
    1104:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1108:	79 20                	jns    112a <createdelete+0x179>
    110a:	8d 45 cc             	lea    -0x34(%ebp),%eax
    110d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1111:	c7 44 24 04 d4 46 00 	movl   $0x46d4,0x4(%esp)
    1118:	00 
    1119:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1120:	e8 70 2c 00 00       	call   3d95 <printf>
    1125:	e8 f2 2a 00 00       	call   3c1c <exit>
    112a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    112e:	7e 2c                	jle    115c <createdelete+0x1ab>
    1130:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
    1134:	7f 26                	jg     115c <createdelete+0x1ab>
    1136:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    113a:	78 20                	js     115c <createdelete+0x1ab>
    113c:	8d 45 cc             	lea    -0x34(%ebp),%eax
    113f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1143:	c7 44 24 04 f8 46 00 	movl   $0x46f8,0x4(%esp)
    114a:	00 
    114b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1152:	e8 3e 2c 00 00       	call   3d95 <printf>
    1157:	e8 c0 2a 00 00       	call   3c1c <exit>
    115c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1160:	78 0b                	js     116d <createdelete+0x1bc>
    1162:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1165:	89 04 24             	mov    %eax,(%esp)
    1168:	e8 d7 2a 00 00       	call   3c44 <close>
    116d:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    1171:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1174:	83 c0 30             	add    $0x30,%eax
    1177:	88 45 cd             	mov    %al,-0x33(%ebp)
    117a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1181:	00 
    1182:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1185:	89 04 24             	mov    %eax,(%esp)
    1188:	e8 cf 2a 00 00       	call   3c5c <open>
    118d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1190:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1194:	74 06                	je     119c <createdelete+0x1eb>
    1196:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
    119a:	7e 26                	jle    11c2 <createdelete+0x211>
    119c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11a0:	79 20                	jns    11c2 <createdelete+0x211>
    11a2:	8d 45 cc             	lea    -0x34(%ebp),%eax
    11a5:	89 44 24 08          	mov    %eax,0x8(%esp)
    11a9:	c7 44 24 04 d4 46 00 	movl   $0x46d4,0x4(%esp)
    11b0:	00 
    11b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11b8:	e8 d8 2b 00 00       	call   3d95 <printf>
    11bd:	e8 5a 2a 00 00       	call   3c1c <exit>
    11c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11c6:	7e 2c                	jle    11f4 <createdelete+0x243>
    11c8:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
    11cc:	7f 26                	jg     11f4 <createdelete+0x243>
    11ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11d2:	78 20                	js     11f4 <createdelete+0x243>
    11d4:	8d 45 cc             	lea    -0x34(%ebp),%eax
    11d7:	89 44 24 08          	mov    %eax,0x8(%esp)
    11db:	c7 44 24 04 f8 46 00 	movl   $0x46f8,0x4(%esp)
    11e2:	00 
    11e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11ea:	e8 a6 2b 00 00       	call   3d95 <printf>
    11ef:	e8 28 2a 00 00       	call   3c1c <exit>
    11f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11f8:	78 0b                	js     1205 <createdelete+0x254>
    11fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11fd:	89 04 24             	mov    %eax,(%esp)
    1200:	e8 3f 2a 00 00       	call   3c44 <close>
    1205:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1209:	83 7d f0 13          	cmpl   $0x13,-0x10(%ebp)
    120d:	0f 8e c2 fe ff ff    	jle    10d5 <createdelete+0x124>
    1213:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    121a:	eb 2b                	jmp    1247 <createdelete+0x296>
    121c:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    1220:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1223:	83 c0 30             	add    $0x30,%eax
    1226:	88 45 cd             	mov    %al,-0x33(%ebp)
    1229:	8d 45 cc             	lea    -0x34(%ebp),%eax
    122c:	89 04 24             	mov    %eax,(%esp)
    122f:	e8 38 2a 00 00       	call   3c6c <unlink>
    1234:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    1238:	8d 45 cc             	lea    -0x34(%ebp),%eax
    123b:	89 04 24             	mov    %eax,(%esp)
    123e:	e8 29 2a 00 00       	call   3c6c <unlink>
    1243:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1247:	83 7d f0 13          	cmpl   $0x13,-0x10(%ebp)
    124b:	7e cf                	jle    121c <createdelete+0x26b>
    124d:	c7 44 24 04 18 47 00 	movl   $0x4718,0x4(%esp)
    1254:	00 
    1255:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    125c:	e8 34 2b 00 00       	call   3d95 <printf>
    1261:	c9                   	leave  
    1262:	c3                   	ret    

00001263 <unlinkread>:
    1263:	55                   	push   %ebp
    1264:	89 e5                	mov    %esp,%ebp
    1266:	83 ec 28             	sub    $0x28,%esp
    1269:	c7 44 24 04 29 47 00 	movl   $0x4729,0x4(%esp)
    1270:	00 
    1271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1278:	e8 18 2b 00 00       	call   3d95 <printf>
    127d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1284:	00 
    1285:	c7 04 24 3a 47 00 00 	movl   $0x473a,(%esp)
    128c:	e8 cb 29 00 00       	call   3c5c <open>
    1291:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1294:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1298:	79 19                	jns    12b3 <unlinkread+0x50>
    129a:	c7 44 24 04 45 47 00 	movl   $0x4745,0x4(%esp)
    12a1:	00 
    12a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12a9:	e8 e7 2a 00 00       	call   3d95 <printf>
    12ae:	e8 69 29 00 00       	call   3c1c <exit>
    12b3:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    12ba:	00 
    12bb:	c7 44 24 04 5f 47 00 	movl   $0x475f,0x4(%esp)
    12c2:	00 
    12c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12c6:	89 04 24             	mov    %eax,(%esp)
    12c9:	e8 6e 29 00 00       	call   3c3c <write>
    12ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12d1:	89 04 24             	mov    %eax,(%esp)
    12d4:	e8 6b 29 00 00       	call   3c44 <close>
    12d9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    12e0:	00 
    12e1:	c7 04 24 3a 47 00 00 	movl   $0x473a,(%esp)
    12e8:	e8 6f 29 00 00       	call   3c5c <open>
    12ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    12f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12f4:	79 19                	jns    130f <unlinkread+0xac>
    12f6:	c7 44 24 04 65 47 00 	movl   $0x4765,0x4(%esp)
    12fd:	00 
    12fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1305:	e8 8b 2a 00 00       	call   3d95 <printf>
    130a:	e8 0d 29 00 00       	call   3c1c <exit>
    130f:	c7 04 24 3a 47 00 00 	movl   $0x473a,(%esp)
    1316:	e8 51 29 00 00       	call   3c6c <unlink>
    131b:	85 c0                	test   %eax,%eax
    131d:	74 19                	je     1338 <unlinkread+0xd5>
    131f:	c7 44 24 04 7d 47 00 	movl   $0x477d,0x4(%esp)
    1326:	00 
    1327:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    132e:	e8 62 2a 00 00       	call   3d95 <printf>
    1333:	e8 e4 28 00 00       	call   3c1c <exit>
    1338:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    133f:	00 
    1340:	c7 04 24 3a 47 00 00 	movl   $0x473a,(%esp)
    1347:	e8 10 29 00 00       	call   3c5c <open>
    134c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    134f:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    1356:	00 
    1357:	c7 44 24 04 97 47 00 	movl   $0x4797,0x4(%esp)
    135e:	00 
    135f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1362:	89 04 24             	mov    %eax,(%esp)
    1365:	e8 d2 28 00 00       	call   3c3c <write>
    136a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    136d:	89 04 24             	mov    %eax,(%esp)
    1370:	e8 cf 28 00 00       	call   3c44 <close>
    1375:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    137c:	00 
    137d:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
    1384:	00 
    1385:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1388:	89 04 24             	mov    %eax,(%esp)
    138b:	e8 a4 28 00 00       	call   3c34 <read>
    1390:	83 f8 05             	cmp    $0x5,%eax
    1393:	74 19                	je     13ae <unlinkread+0x14b>
    1395:	c7 44 24 04 9b 47 00 	movl   $0x479b,0x4(%esp)
    139c:	00 
    139d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13a4:	e8 ec 29 00 00       	call   3d95 <printf>
    13a9:	e8 6e 28 00 00       	call   3c1c <exit>
    13ae:	0f b6 05 20 80 00 00 	movzbl 0x8020,%eax
    13b5:	3c 68                	cmp    $0x68,%al
    13b7:	74 19                	je     13d2 <unlinkread+0x16f>
    13b9:	c7 44 24 04 b2 47 00 	movl   $0x47b2,0x4(%esp)
    13c0:	00 
    13c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13c8:	e8 c8 29 00 00       	call   3d95 <printf>
    13cd:	e8 4a 28 00 00       	call   3c1c <exit>
    13d2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    13d9:	00 
    13da:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
    13e1:	00 
    13e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13e5:	89 04 24             	mov    %eax,(%esp)
    13e8:	e8 4f 28 00 00       	call   3c3c <write>
    13ed:	83 f8 0a             	cmp    $0xa,%eax
    13f0:	74 19                	je     140b <unlinkread+0x1a8>
    13f2:	c7 44 24 04 c9 47 00 	movl   $0x47c9,0x4(%esp)
    13f9:	00 
    13fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1401:	e8 8f 29 00 00       	call   3d95 <printf>
    1406:	e8 11 28 00 00       	call   3c1c <exit>
    140b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    140e:	89 04 24             	mov    %eax,(%esp)
    1411:	e8 2e 28 00 00       	call   3c44 <close>
    1416:	c7 04 24 3a 47 00 00 	movl   $0x473a,(%esp)
    141d:	e8 4a 28 00 00       	call   3c6c <unlink>
    1422:	c7 44 24 04 e2 47 00 	movl   $0x47e2,0x4(%esp)
    1429:	00 
    142a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1431:	e8 5f 29 00 00       	call   3d95 <printf>
    1436:	c9                   	leave  
    1437:	c3                   	ret    

00001438 <linktest>:
    1438:	55                   	push   %ebp
    1439:	89 e5                	mov    %esp,%ebp
    143b:	83 ec 28             	sub    $0x28,%esp
    143e:	c7 44 24 04 f1 47 00 	movl   $0x47f1,0x4(%esp)
    1445:	00 
    1446:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    144d:	e8 43 29 00 00       	call   3d95 <printf>
    1452:	c7 04 24 fb 47 00 00 	movl   $0x47fb,(%esp)
    1459:	e8 0e 28 00 00       	call   3c6c <unlink>
    145e:	c7 04 24 ff 47 00 00 	movl   $0x47ff,(%esp)
    1465:	e8 02 28 00 00       	call   3c6c <unlink>
    146a:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1471:	00 
    1472:	c7 04 24 fb 47 00 00 	movl   $0x47fb,(%esp)
    1479:	e8 de 27 00 00       	call   3c5c <open>
    147e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1481:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1485:	79 19                	jns    14a0 <linktest+0x68>
    1487:	c7 44 24 04 03 48 00 	movl   $0x4803,0x4(%esp)
    148e:	00 
    148f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1496:	e8 fa 28 00 00       	call   3d95 <printf>
    149b:	e8 7c 27 00 00       	call   3c1c <exit>
    14a0:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    14a7:	00 
    14a8:	c7 44 24 04 5f 47 00 	movl   $0x475f,0x4(%esp)
    14af:	00 
    14b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b3:	89 04 24             	mov    %eax,(%esp)
    14b6:	e8 81 27 00 00       	call   3c3c <write>
    14bb:	83 f8 05             	cmp    $0x5,%eax
    14be:	74 19                	je     14d9 <linktest+0xa1>
    14c0:	c7 44 24 04 16 48 00 	movl   $0x4816,0x4(%esp)
    14c7:	00 
    14c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14cf:	e8 c1 28 00 00       	call   3d95 <printf>
    14d4:	e8 43 27 00 00       	call   3c1c <exit>
    14d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14dc:	89 04 24             	mov    %eax,(%esp)
    14df:	e8 60 27 00 00       	call   3c44 <close>
    14e4:	c7 44 24 04 ff 47 00 	movl   $0x47ff,0x4(%esp)
    14eb:	00 
    14ec:	c7 04 24 fb 47 00 00 	movl   $0x47fb,(%esp)
    14f3:	e8 84 27 00 00       	call   3c7c <link>
    14f8:	85 c0                	test   %eax,%eax
    14fa:	79 19                	jns    1515 <linktest+0xdd>
    14fc:	c7 44 24 04 28 48 00 	movl   $0x4828,0x4(%esp)
    1503:	00 
    1504:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    150b:	e8 85 28 00 00       	call   3d95 <printf>
    1510:	e8 07 27 00 00       	call   3c1c <exit>
    1515:	c7 04 24 fb 47 00 00 	movl   $0x47fb,(%esp)
    151c:	e8 4b 27 00 00       	call   3c6c <unlink>
    1521:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1528:	00 
    1529:	c7 04 24 fb 47 00 00 	movl   $0x47fb,(%esp)
    1530:	e8 27 27 00 00       	call   3c5c <open>
    1535:	85 c0                	test   %eax,%eax
    1537:	78 19                	js     1552 <linktest+0x11a>
    1539:	c7 44 24 04 40 48 00 	movl   $0x4840,0x4(%esp)
    1540:	00 
    1541:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1548:	e8 48 28 00 00       	call   3d95 <printf>
    154d:	e8 ca 26 00 00       	call   3c1c <exit>
    1552:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1559:	00 
    155a:	c7 04 24 ff 47 00 00 	movl   $0x47ff,(%esp)
    1561:	e8 f6 26 00 00       	call   3c5c <open>
    1566:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1569:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    156d:	79 19                	jns    1588 <linktest+0x150>
    156f:	c7 44 24 04 65 48 00 	movl   $0x4865,0x4(%esp)
    1576:	00 
    1577:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    157e:	e8 12 28 00 00       	call   3d95 <printf>
    1583:	e8 94 26 00 00       	call   3c1c <exit>
    1588:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    158f:	00 
    1590:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
    1597:	00 
    1598:	8b 45 f4             	mov    -0xc(%ebp),%eax
    159b:	89 04 24             	mov    %eax,(%esp)
    159e:	e8 91 26 00 00       	call   3c34 <read>
    15a3:	83 f8 05             	cmp    $0x5,%eax
    15a6:	74 19                	je     15c1 <linktest+0x189>
    15a8:	c7 44 24 04 76 48 00 	movl   $0x4876,0x4(%esp)
    15af:	00 
    15b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15b7:	e8 d9 27 00 00       	call   3d95 <printf>
    15bc:	e8 5b 26 00 00       	call   3c1c <exit>
    15c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15c4:	89 04 24             	mov    %eax,(%esp)
    15c7:	e8 78 26 00 00       	call   3c44 <close>
    15cc:	c7 44 24 04 ff 47 00 	movl   $0x47ff,0x4(%esp)
    15d3:	00 
    15d4:	c7 04 24 ff 47 00 00 	movl   $0x47ff,(%esp)
    15db:	e8 9c 26 00 00       	call   3c7c <link>
    15e0:	85 c0                	test   %eax,%eax
    15e2:	78 19                	js     15fd <linktest+0x1c5>
    15e4:	c7 44 24 04 87 48 00 	movl   $0x4887,0x4(%esp)
    15eb:	00 
    15ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15f3:	e8 9d 27 00 00       	call   3d95 <printf>
    15f8:	e8 1f 26 00 00       	call   3c1c <exit>
    15fd:	c7 04 24 ff 47 00 00 	movl   $0x47ff,(%esp)
    1604:	e8 63 26 00 00       	call   3c6c <unlink>
    1609:	c7 44 24 04 fb 47 00 	movl   $0x47fb,0x4(%esp)
    1610:	00 
    1611:	c7 04 24 ff 47 00 00 	movl   $0x47ff,(%esp)
    1618:	e8 5f 26 00 00       	call   3c7c <link>
    161d:	85 c0                	test   %eax,%eax
    161f:	78 19                	js     163a <linktest+0x202>
    1621:	c7 44 24 04 a8 48 00 	movl   $0x48a8,0x4(%esp)
    1628:	00 
    1629:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1630:	e8 60 27 00 00       	call   3d95 <printf>
    1635:	e8 e2 25 00 00       	call   3c1c <exit>
    163a:	c7 44 24 04 fb 47 00 	movl   $0x47fb,0x4(%esp)
    1641:	00 
    1642:	c7 04 24 cb 48 00 00 	movl   $0x48cb,(%esp)
    1649:	e8 2e 26 00 00       	call   3c7c <link>
    164e:	85 c0                	test   %eax,%eax
    1650:	78 19                	js     166b <linktest+0x233>
    1652:	c7 44 24 04 cd 48 00 	movl   $0x48cd,0x4(%esp)
    1659:	00 
    165a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1661:	e8 2f 27 00 00       	call   3d95 <printf>
    1666:	e8 b1 25 00 00       	call   3c1c <exit>
    166b:	c7 44 24 04 e9 48 00 	movl   $0x48e9,0x4(%esp)
    1672:	00 
    1673:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    167a:	e8 16 27 00 00       	call   3d95 <printf>
    167f:	c9                   	leave  
    1680:	c3                   	ret    

00001681 <concreate>:
    1681:	55                   	push   %ebp
    1682:	89 e5                	mov    %esp,%ebp
    1684:	83 ec 68             	sub    $0x68,%esp
    1687:	c7 44 24 04 f6 48 00 	movl   $0x48f6,0x4(%esp)
    168e:	00 
    168f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1696:	e8 fa 26 00 00       	call   3d95 <printf>
    169b:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
    169f:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
    16a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    16aa:	e9 f7 00 00 00       	jmp    17a6 <concreate+0x125>
    16af:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16b2:	83 c0 30             	add    $0x30,%eax
    16b5:	88 45 e6             	mov    %al,-0x1a(%ebp)
    16b8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16bb:	89 04 24             	mov    %eax,(%esp)
    16be:	e8 a9 25 00 00       	call   3c6c <unlink>
    16c3:	e8 4c 25 00 00       	call   3c14 <fork>
    16c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16cf:	74 3a                	je     170b <concreate+0x8a>
    16d1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    16d4:	ba 56 55 55 55       	mov    $0x55555556,%edx
    16d9:	89 c8                	mov    %ecx,%eax
    16db:	f7 ea                	imul   %edx
    16dd:	89 c8                	mov    %ecx,%eax
    16df:	c1 f8 1f             	sar    $0x1f,%eax
    16e2:	29 c2                	sub    %eax,%edx
    16e4:	89 d0                	mov    %edx,%eax
    16e6:	01 c0                	add    %eax,%eax
    16e8:	01 d0                	add    %edx,%eax
    16ea:	89 ca                	mov    %ecx,%edx
    16ec:	29 c2                	sub    %eax,%edx
    16ee:	83 fa 01             	cmp    $0x1,%edx
    16f1:	75 18                	jne    170b <concreate+0x8a>
    16f3:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16f6:	89 44 24 04          	mov    %eax,0x4(%esp)
    16fa:	c7 04 24 06 49 00 00 	movl   $0x4906,(%esp)
    1701:	e8 76 25 00 00       	call   3c7c <link>
    1706:	e9 87 00 00 00       	jmp    1792 <concreate+0x111>
    170b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    170f:	75 3a                	jne    174b <concreate+0xca>
    1711:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    1714:	ba 67 66 66 66       	mov    $0x66666667,%edx
    1719:	89 c8                	mov    %ecx,%eax
    171b:	f7 ea                	imul   %edx
    171d:	d1 fa                	sar    %edx
    171f:	89 c8                	mov    %ecx,%eax
    1721:	c1 f8 1f             	sar    $0x1f,%eax
    1724:	29 c2                	sub    %eax,%edx
    1726:	89 d0                	mov    %edx,%eax
    1728:	c1 e0 02             	shl    $0x2,%eax
    172b:	01 d0                	add    %edx,%eax
    172d:	89 ca                	mov    %ecx,%edx
    172f:	29 c2                	sub    %eax,%edx
    1731:	83 fa 01             	cmp    $0x1,%edx
    1734:	75 15                	jne    174b <concreate+0xca>
    1736:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1739:	89 44 24 04          	mov    %eax,0x4(%esp)
    173d:	c7 04 24 06 49 00 00 	movl   $0x4906,(%esp)
    1744:	e8 33 25 00 00       	call   3c7c <link>
    1749:	eb 47                	jmp    1792 <concreate+0x111>
    174b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1752:	00 
    1753:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1756:	89 04 24             	mov    %eax,(%esp)
    1759:	e8 fe 24 00 00       	call   3c5c <open>
    175e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1761:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1765:	79 20                	jns    1787 <concreate+0x106>
    1767:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    176a:	89 44 24 08          	mov    %eax,0x8(%esp)
    176e:	c7 44 24 04 09 49 00 	movl   $0x4909,0x4(%esp)
    1775:	00 
    1776:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    177d:	e8 13 26 00 00       	call   3d95 <printf>
    1782:	e8 95 24 00 00       	call   3c1c <exit>
    1787:	8b 45 f4             	mov    -0xc(%ebp),%eax
    178a:	89 04 24             	mov    %eax,(%esp)
    178d:	e8 b2 24 00 00       	call   3c44 <close>
    1792:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1796:	75 05                	jne    179d <concreate+0x11c>
    1798:	e8 7f 24 00 00       	call   3c1c <exit>
    179d:	e8 82 24 00 00       	call   3c24 <wait>
    17a2:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    17a6:	83 7d e8 27          	cmpl   $0x27,-0x18(%ebp)
    17aa:	0f 8e ff fe ff ff    	jle    16af <concreate+0x2e>
    17b0:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    17b7:	00 
    17b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17bf:	00 
    17c0:	8d 45 bd             	lea    -0x43(%ebp),%eax
    17c3:	89 04 24             	mov    %eax,(%esp)
    17c6:	e8 ab 22 00 00       	call   3a76 <memset>
    17cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17d2:	00 
    17d3:	c7 04 24 cb 48 00 00 	movl   $0x48cb,(%esp)
    17da:	e8 7d 24 00 00       	call   3c5c <open>
    17df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    17e9:	e9 9d 00 00 00       	jmp    188b <concreate+0x20a>
    17ee:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    17f2:	66 85 c0             	test   %ax,%ax
    17f5:	0f 84 8f 00 00 00    	je     188a <concreate+0x209>
    17fb:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    17ff:	3c 43                	cmp    $0x43,%al
    1801:	0f 85 84 00 00 00    	jne    188b <concreate+0x20a>
    1807:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    180b:	84 c0                	test   %al,%al
    180d:	75 7c                	jne    188b <concreate+0x20a>
    180f:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1813:	0f be c0             	movsbl %al,%eax
    1816:	83 e8 30             	sub    $0x30,%eax
    1819:	89 45 e8             	mov    %eax,-0x18(%ebp)
    181c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1820:	78 08                	js     182a <concreate+0x1a9>
    1822:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1825:	83 f8 27             	cmp    $0x27,%eax
    1828:	76 23                	jbe    184d <concreate+0x1cc>
    182a:	8d 45 ac             	lea    -0x54(%ebp),%eax
    182d:	83 c0 02             	add    $0x2,%eax
    1830:	89 44 24 08          	mov    %eax,0x8(%esp)
    1834:	c7 44 24 04 25 49 00 	movl   $0x4925,0x4(%esp)
    183b:	00 
    183c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1843:	e8 4d 25 00 00       	call   3d95 <printf>
    1848:	e8 cf 23 00 00       	call   3c1c <exit>
    184d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1850:	0f b6 44 05 bd       	movzbl -0x43(%ebp,%eax,1),%eax
    1855:	84 c0                	test   %al,%al
    1857:	74 23                	je     187c <concreate+0x1fb>
    1859:	8d 45 ac             	lea    -0x54(%ebp),%eax
    185c:	83 c0 02             	add    $0x2,%eax
    185f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1863:	c7 44 24 04 3e 49 00 	movl   $0x493e,0x4(%esp)
    186a:	00 
    186b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1872:	e8 1e 25 00 00       	call   3d95 <printf>
    1877:	e8 a0 23 00 00       	call   3c1c <exit>
    187c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    187f:	c6 44 05 bd 01       	movb   $0x1,-0x43(%ebp,%eax,1)
    1884:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1888:	eb 01                	jmp    188b <concreate+0x20a>
    188a:	90                   	nop
    188b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1892:	00 
    1893:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1896:	89 44 24 04          	mov    %eax,0x4(%esp)
    189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189d:	89 04 24             	mov    %eax,(%esp)
    18a0:	e8 8f 23 00 00       	call   3c34 <read>
    18a5:	85 c0                	test   %eax,%eax
    18a7:	0f 8f 41 ff ff ff    	jg     17ee <concreate+0x16d>
    18ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b0:	89 04 24             	mov    %eax,(%esp)
    18b3:	e8 8c 23 00 00       	call   3c44 <close>
    18b8:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    18bc:	74 19                	je     18d7 <concreate+0x256>
    18be:	c7 44 24 04 5c 49 00 	movl   $0x495c,0x4(%esp)
    18c5:	00 
    18c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18cd:	e8 c3 24 00 00       	call   3d95 <printf>
    18d2:	e8 45 23 00 00       	call   3c1c <exit>
    18d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    18de:	e9 2d 01 00 00       	jmp    1a10 <concreate+0x38f>
    18e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18e6:	83 c0 30             	add    $0x30,%eax
    18e9:	88 45 e6             	mov    %al,-0x1a(%ebp)
    18ec:	e8 23 23 00 00       	call   3c14 <fork>
    18f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    18f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    18f8:	79 19                	jns    1913 <concreate+0x292>
    18fa:	c7 44 24 04 49 45 00 	movl   $0x4549,0x4(%esp)
    1901:	00 
    1902:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1909:	e8 87 24 00 00       	call   3d95 <printf>
    190e:	e8 09 23 00 00       	call   3c1c <exit>
    1913:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    1916:	ba 56 55 55 55       	mov    $0x55555556,%edx
    191b:	89 c8                	mov    %ecx,%eax
    191d:	f7 ea                	imul   %edx
    191f:	89 c8                	mov    %ecx,%eax
    1921:	c1 f8 1f             	sar    $0x1f,%eax
    1924:	29 c2                	sub    %eax,%edx
    1926:	89 d0                	mov    %edx,%eax
    1928:	01 c0                	add    %eax,%eax
    192a:	01 d0                	add    %edx,%eax
    192c:	89 ca                	mov    %ecx,%edx
    192e:	29 c2                	sub    %eax,%edx
    1930:	85 d2                	test   %edx,%edx
    1932:	75 06                	jne    193a <concreate+0x2b9>
    1934:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1938:	74 28                	je     1962 <concreate+0x2e1>
    193a:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    193d:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1942:	89 c8                	mov    %ecx,%eax
    1944:	f7 ea                	imul   %edx
    1946:	89 c8                	mov    %ecx,%eax
    1948:	c1 f8 1f             	sar    $0x1f,%eax
    194b:	29 c2                	sub    %eax,%edx
    194d:	89 d0                	mov    %edx,%eax
    194f:	01 c0                	add    %eax,%eax
    1951:	01 d0                	add    %edx,%eax
    1953:	89 ca                	mov    %ecx,%edx
    1955:	29 c2                	sub    %eax,%edx
    1957:	83 fa 01             	cmp    $0x1,%edx
    195a:	75 74                	jne    19d0 <concreate+0x34f>
    195c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1960:	74 6e                	je     19d0 <concreate+0x34f>
    1962:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1969:	00 
    196a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    196d:	89 04 24             	mov    %eax,(%esp)
    1970:	e8 e7 22 00 00       	call   3c5c <open>
    1975:	89 04 24             	mov    %eax,(%esp)
    1978:	e8 c7 22 00 00       	call   3c44 <close>
    197d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1984:	00 
    1985:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1988:	89 04 24             	mov    %eax,(%esp)
    198b:	e8 cc 22 00 00       	call   3c5c <open>
    1990:	89 04 24             	mov    %eax,(%esp)
    1993:	e8 ac 22 00 00       	call   3c44 <close>
    1998:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    199f:	00 
    19a0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19a3:	89 04 24             	mov    %eax,(%esp)
    19a6:	e8 b1 22 00 00       	call   3c5c <open>
    19ab:	89 04 24             	mov    %eax,(%esp)
    19ae:	e8 91 22 00 00       	call   3c44 <close>
    19b3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    19ba:	00 
    19bb:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19be:	89 04 24             	mov    %eax,(%esp)
    19c1:	e8 96 22 00 00       	call   3c5c <open>
    19c6:	89 04 24             	mov    %eax,(%esp)
    19c9:	e8 76 22 00 00       	call   3c44 <close>
    19ce:	eb 2c                	jmp    19fc <concreate+0x37b>
    19d0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19d3:	89 04 24             	mov    %eax,(%esp)
    19d6:	e8 91 22 00 00       	call   3c6c <unlink>
    19db:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19de:	89 04 24             	mov    %eax,(%esp)
    19e1:	e8 86 22 00 00       	call   3c6c <unlink>
    19e6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19e9:	89 04 24             	mov    %eax,(%esp)
    19ec:	e8 7b 22 00 00       	call   3c6c <unlink>
    19f1:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19f4:	89 04 24             	mov    %eax,(%esp)
    19f7:	e8 70 22 00 00       	call   3c6c <unlink>
    19fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a00:	75 05                	jne    1a07 <concreate+0x386>
    1a02:	e8 15 22 00 00       	call   3c1c <exit>
    1a07:	e8 18 22 00 00       	call   3c24 <wait>
    1a0c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1a10:	83 7d e8 27          	cmpl   $0x27,-0x18(%ebp)
    1a14:	0f 8e c9 fe ff ff    	jle    18e3 <concreate+0x262>
    1a1a:	c7 44 24 04 8d 49 00 	movl   $0x498d,0x4(%esp)
    1a21:	00 
    1a22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a29:	e8 67 23 00 00       	call   3d95 <printf>
    1a2e:	c9                   	leave  
    1a2f:	c3                   	ret    

00001a30 <linkunlink>:
    1a30:	55                   	push   %ebp
    1a31:	89 e5                	mov    %esp,%ebp
    1a33:	83 ec 28             	sub    $0x28,%esp
    1a36:	c7 44 24 04 9b 49 00 	movl   $0x499b,0x4(%esp)
    1a3d:	00 
    1a3e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a45:	e8 4b 23 00 00       	call   3d95 <printf>
    1a4a:	c7 04 24 02 45 00 00 	movl   $0x4502,(%esp)
    1a51:	e8 16 22 00 00       	call   3c6c <unlink>
    1a56:	e8 b9 21 00 00       	call   3c14 <fork>
    1a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1a5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a62:	79 19                	jns    1a7d <linkunlink+0x4d>
    1a64:	c7 44 24 04 49 45 00 	movl   $0x4549,0x4(%esp)
    1a6b:	00 
    1a6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a73:	e8 1d 23 00 00       	call   3d95 <printf>
    1a78:	e8 9f 21 00 00       	call   3c1c <exit>
    1a7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a81:	74 07                	je     1a8a <linkunlink+0x5a>
    1a83:	b8 01 00 00 00       	mov    $0x1,%eax
    1a88:	eb 05                	jmp    1a8f <linkunlink+0x5f>
    1a8a:	b8 61 00 00 00       	mov    $0x61,%eax
    1a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a92:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1a99:	e9 8e 00 00 00       	jmp    1b2c <linkunlink+0xfc>
    1a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa1:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1aa7:	05 39 30 00 00       	add    $0x3039,%eax
    1aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1aaf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1ab2:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1ab7:	89 c8                	mov    %ecx,%eax
    1ab9:	f7 e2                	mul    %edx
    1abb:	d1 ea                	shr    %edx
    1abd:	89 d0                	mov    %edx,%eax
    1abf:	01 c0                	add    %eax,%eax
    1ac1:	01 d0                	add    %edx,%eax
    1ac3:	89 ca                	mov    %ecx,%edx
    1ac5:	29 c2                	sub    %eax,%edx
    1ac7:	85 d2                	test   %edx,%edx
    1ac9:	75 1e                	jne    1ae9 <linkunlink+0xb9>
    1acb:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1ad2:	00 
    1ad3:	c7 04 24 02 45 00 00 	movl   $0x4502,(%esp)
    1ada:	e8 7d 21 00 00       	call   3c5c <open>
    1adf:	89 04 24             	mov    %eax,(%esp)
    1ae2:	e8 5d 21 00 00       	call   3c44 <close>
    1ae7:	eb 3f                	jmp    1b28 <linkunlink+0xf8>
    1ae9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1aec:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1af1:	89 c8                	mov    %ecx,%eax
    1af3:	f7 e2                	mul    %edx
    1af5:	d1 ea                	shr    %edx
    1af7:	89 d0                	mov    %edx,%eax
    1af9:	01 c0                	add    %eax,%eax
    1afb:	01 d0                	add    %edx,%eax
    1afd:	89 ca                	mov    %ecx,%edx
    1aff:	29 c2                	sub    %eax,%edx
    1b01:	83 fa 01             	cmp    $0x1,%edx
    1b04:	75 16                	jne    1b1c <linkunlink+0xec>
    1b06:	c7 44 24 04 02 45 00 	movl   $0x4502,0x4(%esp)
    1b0d:	00 
    1b0e:	c7 04 24 ac 49 00 00 	movl   $0x49ac,(%esp)
    1b15:	e8 62 21 00 00       	call   3c7c <link>
    1b1a:	eb 0c                	jmp    1b28 <linkunlink+0xf8>
    1b1c:	c7 04 24 02 45 00 00 	movl   $0x4502,(%esp)
    1b23:	e8 44 21 00 00       	call   3c6c <unlink>
    1b28:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1b2c:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
    1b30:	0f 8e 68 ff ff ff    	jle    1a9e <linkunlink+0x6e>
    1b36:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b3a:	74 1b                	je     1b57 <linkunlink+0x127>
    1b3c:	e8 e3 20 00 00       	call   3c24 <wait>
    1b41:	c7 44 24 04 b0 49 00 	movl   $0x49b0,0x4(%esp)
    1b48:	00 
    1b49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b50:	e8 40 22 00 00       	call   3d95 <printf>
    1b55:	c9                   	leave  
    1b56:	c3                   	ret    
    1b57:	e8 c0 20 00 00       	call   3c1c <exit>

00001b5c <bigdir>:
    1b5c:	55                   	push   %ebp
    1b5d:	89 e5                	mov    %esp,%ebp
    1b5f:	83 ec 38             	sub    $0x38,%esp
    1b62:	c7 44 24 04 bf 49 00 	movl   $0x49bf,0x4(%esp)
    1b69:	00 
    1b6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b71:	e8 1f 22 00 00       	call   3d95 <printf>
    1b76:	c7 04 24 cc 49 00 00 	movl   $0x49cc,(%esp)
    1b7d:	e8 ea 20 00 00       	call   3c6c <unlink>
    1b82:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1b89:	00 
    1b8a:	c7 04 24 cc 49 00 00 	movl   $0x49cc,(%esp)
    1b91:	e8 c6 20 00 00       	call   3c5c <open>
    1b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b9d:	79 19                	jns    1bb8 <bigdir+0x5c>
    1b9f:	c7 44 24 04 cf 49 00 	movl   $0x49cf,0x4(%esp)
    1ba6:	00 
    1ba7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bae:	e8 e2 21 00 00       	call   3d95 <printf>
    1bb3:	e8 64 20 00 00       	call   3c1c <exit>
    1bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bbb:	89 04 24             	mov    %eax,(%esp)
    1bbe:	e8 81 20 00 00       	call   3c44 <close>
    1bc3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1bca:	eb 68                	jmp    1c34 <bigdir+0xd8>
    1bcc:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    1bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1bd3:	8d 50 3f             	lea    0x3f(%eax),%edx
    1bd6:	85 c0                	test   %eax,%eax
    1bd8:	0f 48 c2             	cmovs  %edx,%eax
    1bdb:	c1 f8 06             	sar    $0x6,%eax
    1bde:	83 c0 30             	add    $0x30,%eax
    1be1:	88 45 e7             	mov    %al,-0x19(%ebp)
    1be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1be7:	89 c2                	mov    %eax,%edx
    1be9:	c1 fa 1f             	sar    $0x1f,%edx
    1bec:	c1 ea 1a             	shr    $0x1a,%edx
    1bef:	01 d0                	add    %edx,%eax
    1bf1:	83 e0 3f             	and    $0x3f,%eax
    1bf4:	29 d0                	sub    %edx,%eax
    1bf6:	83 c0 30             	add    $0x30,%eax
    1bf9:	88 45 e8             	mov    %al,-0x18(%ebp)
    1bfc:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    1c00:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1c03:	89 44 24 04          	mov    %eax,0x4(%esp)
    1c07:	c7 04 24 cc 49 00 00 	movl   $0x49cc,(%esp)
    1c0e:	e8 69 20 00 00       	call   3c7c <link>
    1c13:	85 c0                	test   %eax,%eax
    1c15:	74 19                	je     1c30 <bigdir+0xd4>
    1c17:	c7 44 24 04 e5 49 00 	movl   $0x49e5,0x4(%esp)
    1c1e:	00 
    1c1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c26:	e8 6a 21 00 00       	call   3d95 <printf>
    1c2b:	e8 ec 1f 00 00       	call   3c1c <exit>
    1c30:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1c34:	81 7d f0 f3 01 00 00 	cmpl   $0x1f3,-0x10(%ebp)
    1c3b:	7e 8f                	jle    1bcc <bigdir+0x70>
    1c3d:	c7 04 24 cc 49 00 00 	movl   $0x49cc,(%esp)
    1c44:	e8 23 20 00 00       	call   3c6c <unlink>
    1c49:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1c50:	eb 60                	jmp    1cb2 <bigdir+0x156>
    1c52:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    1c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c59:	8d 50 3f             	lea    0x3f(%eax),%edx
    1c5c:	85 c0                	test   %eax,%eax
    1c5e:	0f 48 c2             	cmovs  %edx,%eax
    1c61:	c1 f8 06             	sar    $0x6,%eax
    1c64:	83 c0 30             	add    $0x30,%eax
    1c67:	88 45 e7             	mov    %al,-0x19(%ebp)
    1c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c6d:	89 c2                	mov    %eax,%edx
    1c6f:	c1 fa 1f             	sar    $0x1f,%edx
    1c72:	c1 ea 1a             	shr    $0x1a,%edx
    1c75:	01 d0                	add    %edx,%eax
    1c77:	83 e0 3f             	and    $0x3f,%eax
    1c7a:	29 d0                	sub    %edx,%eax
    1c7c:	83 c0 30             	add    $0x30,%eax
    1c7f:	88 45 e8             	mov    %al,-0x18(%ebp)
    1c82:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    1c86:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1c89:	89 04 24             	mov    %eax,(%esp)
    1c8c:	e8 db 1f 00 00       	call   3c6c <unlink>
    1c91:	85 c0                	test   %eax,%eax
    1c93:	74 19                	je     1cae <bigdir+0x152>
    1c95:	c7 44 24 04 f9 49 00 	movl   $0x49f9,0x4(%esp)
    1c9c:	00 
    1c9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ca4:	e8 ec 20 00 00       	call   3d95 <printf>
    1ca9:	e8 6e 1f 00 00       	call   3c1c <exit>
    1cae:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1cb2:	81 7d f0 f3 01 00 00 	cmpl   $0x1f3,-0x10(%ebp)
    1cb9:	7e 97                	jle    1c52 <bigdir+0xf6>
    1cbb:	c7 44 24 04 0e 4a 00 	movl   $0x4a0e,0x4(%esp)
    1cc2:	00 
    1cc3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cca:	e8 c6 20 00 00       	call   3d95 <printf>
    1ccf:	c9                   	leave  
    1cd0:	c3                   	ret    

00001cd1 <subdir>:
    1cd1:	55                   	push   %ebp
    1cd2:	89 e5                	mov    %esp,%ebp
    1cd4:	83 ec 28             	sub    $0x28,%esp
    1cd7:	c7 44 24 04 19 4a 00 	movl   $0x4a19,0x4(%esp)
    1cde:	00 
    1cdf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ce6:	e8 aa 20 00 00       	call   3d95 <printf>
    1ceb:	c7 04 24 26 4a 00 00 	movl   $0x4a26,(%esp)
    1cf2:	e8 75 1f 00 00       	call   3c6c <unlink>
    1cf7:	c7 04 24 29 4a 00 00 	movl   $0x4a29,(%esp)
    1cfe:	e8 81 1f 00 00       	call   3c84 <mkdir>
    1d03:	85 c0                	test   %eax,%eax
    1d05:	74 19                	je     1d20 <subdir+0x4f>
    1d07:	c7 44 24 04 2c 4a 00 	movl   $0x4a2c,0x4(%esp)
    1d0e:	00 
    1d0f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d16:	e8 7a 20 00 00       	call   3d95 <printf>
    1d1b:	e8 fc 1e 00 00       	call   3c1c <exit>
    1d20:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d27:	00 
    1d28:	c7 04 24 44 4a 00 00 	movl   $0x4a44,(%esp)
    1d2f:	e8 28 1f 00 00       	call   3c5c <open>
    1d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1d37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1d3b:	79 19                	jns    1d56 <subdir+0x85>
    1d3d:	c7 44 24 04 4a 4a 00 	movl   $0x4a4a,0x4(%esp)
    1d44:	00 
    1d45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d4c:	e8 44 20 00 00       	call   3d95 <printf>
    1d51:	e8 c6 1e 00 00       	call   3c1c <exit>
    1d56:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1d5d:	00 
    1d5e:	c7 44 24 04 26 4a 00 	movl   $0x4a26,0x4(%esp)
    1d65:	00 
    1d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d69:	89 04 24             	mov    %eax,(%esp)
    1d6c:	e8 cb 1e 00 00       	call   3c3c <write>
    1d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d74:	89 04 24             	mov    %eax,(%esp)
    1d77:	e8 c8 1e 00 00       	call   3c44 <close>
    1d7c:	c7 04 24 29 4a 00 00 	movl   $0x4a29,(%esp)
    1d83:	e8 e4 1e 00 00       	call   3c6c <unlink>
    1d88:	85 c0                	test   %eax,%eax
    1d8a:	78 19                	js     1da5 <subdir+0xd4>
    1d8c:	c7 44 24 04 60 4a 00 	movl   $0x4a60,0x4(%esp)
    1d93:	00 
    1d94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d9b:	e8 f5 1f 00 00       	call   3d95 <printf>
    1da0:	e8 77 1e 00 00       	call   3c1c <exit>
    1da5:	c7 04 24 86 4a 00 00 	movl   $0x4a86,(%esp)
    1dac:	e8 d3 1e 00 00       	call   3c84 <mkdir>
    1db1:	85 c0                	test   %eax,%eax
    1db3:	74 19                	je     1dce <subdir+0xfd>
    1db5:	c7 44 24 04 8d 4a 00 	movl   $0x4a8d,0x4(%esp)
    1dbc:	00 
    1dbd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1dc4:	e8 cc 1f 00 00       	call   3d95 <printf>
    1dc9:	e8 4e 1e 00 00       	call   3c1c <exit>
    1dce:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1dd5:	00 
    1dd6:	c7 04 24 a8 4a 00 00 	movl   $0x4aa8,(%esp)
    1ddd:	e8 7a 1e 00 00       	call   3c5c <open>
    1de2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1de5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1de9:	79 19                	jns    1e04 <subdir+0x133>
    1deb:	c7 44 24 04 b1 4a 00 	movl   $0x4ab1,0x4(%esp)
    1df2:	00 
    1df3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1dfa:	e8 96 1f 00 00       	call   3d95 <printf>
    1dff:	e8 18 1e 00 00       	call   3c1c <exit>
    1e04:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1e0b:	00 
    1e0c:	c7 44 24 04 c9 4a 00 	movl   $0x4ac9,0x4(%esp)
    1e13:	00 
    1e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e17:	89 04 24             	mov    %eax,(%esp)
    1e1a:	e8 1d 1e 00 00       	call   3c3c <write>
    1e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e22:	89 04 24             	mov    %eax,(%esp)
    1e25:	e8 1a 1e 00 00       	call   3c44 <close>
    1e2a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1e31:	00 
    1e32:	c7 04 24 cc 4a 00 00 	movl   $0x4acc,(%esp)
    1e39:	e8 1e 1e 00 00       	call   3c5c <open>
    1e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1e41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e45:	79 19                	jns    1e60 <subdir+0x18f>
    1e47:	c7 44 24 04 d8 4a 00 	movl   $0x4ad8,0x4(%esp)
    1e4e:	00 
    1e4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e56:	e8 3a 1f 00 00       	call   3d95 <printf>
    1e5b:	e8 bc 1d 00 00       	call   3c1c <exit>
    1e60:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1e67:	00 
    1e68:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
    1e6f:	00 
    1e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e73:	89 04 24             	mov    %eax,(%esp)
    1e76:	e8 b9 1d 00 00       	call   3c34 <read>
    1e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1e7e:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
    1e82:	75 0b                	jne    1e8f <subdir+0x1be>
    1e84:	0f b6 05 20 80 00 00 	movzbl 0x8020,%eax
    1e8b:	3c 66                	cmp    $0x66,%al
    1e8d:	74 19                	je     1ea8 <subdir+0x1d7>
    1e8f:	c7 44 24 04 f1 4a 00 	movl   $0x4af1,0x4(%esp)
    1e96:	00 
    1e97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e9e:	e8 f2 1e 00 00       	call   3d95 <printf>
    1ea3:	e8 74 1d 00 00       	call   3c1c <exit>
    1ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1eab:	89 04 24             	mov    %eax,(%esp)
    1eae:	e8 91 1d 00 00       	call   3c44 <close>
    1eb3:	c7 44 24 04 0c 4b 00 	movl   $0x4b0c,0x4(%esp)
    1eba:	00 
    1ebb:	c7 04 24 a8 4a 00 00 	movl   $0x4aa8,(%esp)
    1ec2:	e8 b5 1d 00 00       	call   3c7c <link>
    1ec7:	85 c0                	test   %eax,%eax
    1ec9:	74 19                	je     1ee4 <subdir+0x213>
    1ecb:	c7 44 24 04 18 4b 00 	movl   $0x4b18,0x4(%esp)
    1ed2:	00 
    1ed3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1eda:	e8 b6 1e 00 00       	call   3d95 <printf>
    1edf:	e8 38 1d 00 00       	call   3c1c <exit>
    1ee4:	c7 04 24 a8 4a 00 00 	movl   $0x4aa8,(%esp)
    1eeb:	e8 7c 1d 00 00       	call   3c6c <unlink>
    1ef0:	85 c0                	test   %eax,%eax
    1ef2:	74 19                	je     1f0d <subdir+0x23c>
    1ef4:	c7 44 24 04 39 4b 00 	movl   $0x4b39,0x4(%esp)
    1efb:	00 
    1efc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f03:	e8 8d 1e 00 00       	call   3d95 <printf>
    1f08:	e8 0f 1d 00 00       	call   3c1c <exit>
    1f0d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1f14:	00 
    1f15:	c7 04 24 a8 4a 00 00 	movl   $0x4aa8,(%esp)
    1f1c:	e8 3b 1d 00 00       	call   3c5c <open>
    1f21:	85 c0                	test   %eax,%eax
    1f23:	78 19                	js     1f3e <subdir+0x26d>
    1f25:	c7 44 24 04 54 4b 00 	movl   $0x4b54,0x4(%esp)
    1f2c:	00 
    1f2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f34:	e8 5c 1e 00 00       	call   3d95 <printf>
    1f39:	e8 de 1c 00 00       	call   3c1c <exit>
    1f3e:	c7 04 24 29 4a 00 00 	movl   $0x4a29,(%esp)
    1f45:	e8 42 1d 00 00       	call   3c8c <chdir>
    1f4a:	85 c0                	test   %eax,%eax
    1f4c:	74 19                	je     1f67 <subdir+0x296>
    1f4e:	c7 44 24 04 78 4b 00 	movl   $0x4b78,0x4(%esp)
    1f55:	00 
    1f56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f5d:	e8 33 1e 00 00       	call   3d95 <printf>
    1f62:	e8 b5 1c 00 00       	call   3c1c <exit>
    1f67:	c7 04 24 89 4b 00 00 	movl   $0x4b89,(%esp)
    1f6e:	e8 19 1d 00 00       	call   3c8c <chdir>
    1f73:	85 c0                	test   %eax,%eax
    1f75:	74 19                	je     1f90 <subdir+0x2bf>
    1f77:	c7 44 24 04 95 4b 00 	movl   $0x4b95,0x4(%esp)
    1f7e:	00 
    1f7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f86:	e8 0a 1e 00 00       	call   3d95 <printf>
    1f8b:	e8 8c 1c 00 00       	call   3c1c <exit>
    1f90:	c7 04 24 af 4b 00 00 	movl   $0x4baf,(%esp)
    1f97:	e8 f0 1c 00 00       	call   3c8c <chdir>
    1f9c:	85 c0                	test   %eax,%eax
    1f9e:	74 19                	je     1fb9 <subdir+0x2e8>
    1fa0:	c7 44 24 04 95 4b 00 	movl   $0x4b95,0x4(%esp)
    1fa7:	00 
    1fa8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1faf:	e8 e1 1d 00 00       	call   3d95 <printf>
    1fb4:	e8 63 1c 00 00       	call   3c1c <exit>
    1fb9:	c7 04 24 be 4b 00 00 	movl   $0x4bbe,(%esp)
    1fc0:	e8 c7 1c 00 00       	call   3c8c <chdir>
    1fc5:	85 c0                	test   %eax,%eax
    1fc7:	74 19                	je     1fe2 <subdir+0x311>
    1fc9:	c7 44 24 04 c3 4b 00 	movl   $0x4bc3,0x4(%esp)
    1fd0:	00 
    1fd1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fd8:	e8 b8 1d 00 00       	call   3d95 <printf>
    1fdd:	e8 3a 1c 00 00       	call   3c1c <exit>
    1fe2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1fe9:	00 
    1fea:	c7 04 24 0c 4b 00 00 	movl   $0x4b0c,(%esp)
    1ff1:	e8 66 1c 00 00       	call   3c5c <open>
    1ff6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1ff9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1ffd:	79 19                	jns    2018 <subdir+0x347>
    1fff:	c7 44 24 04 d6 4b 00 	movl   $0x4bd6,0x4(%esp)
    2006:	00 
    2007:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    200e:	e8 82 1d 00 00       	call   3d95 <printf>
    2013:	e8 04 1c 00 00       	call   3c1c <exit>
    2018:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    201f:	00 
    2020:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
    2027:	00 
    2028:	8b 45 f0             	mov    -0x10(%ebp),%eax
    202b:	89 04 24             	mov    %eax,(%esp)
    202e:	e8 01 1c 00 00       	call   3c34 <read>
    2033:	83 f8 02             	cmp    $0x2,%eax
    2036:	74 19                	je     2051 <subdir+0x380>
    2038:	c7 44 24 04 ee 4b 00 	movl   $0x4bee,0x4(%esp)
    203f:	00 
    2040:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2047:	e8 49 1d 00 00       	call   3d95 <printf>
    204c:	e8 cb 1b 00 00       	call   3c1c <exit>
    2051:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2054:	89 04 24             	mov    %eax,(%esp)
    2057:	e8 e8 1b 00 00       	call   3c44 <close>
    205c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2063:	00 
    2064:	c7 04 24 a8 4a 00 00 	movl   $0x4aa8,(%esp)
    206b:	e8 ec 1b 00 00       	call   3c5c <open>
    2070:	85 c0                	test   %eax,%eax
    2072:	78 19                	js     208d <subdir+0x3bc>
    2074:	c7 44 24 04 0c 4c 00 	movl   $0x4c0c,0x4(%esp)
    207b:	00 
    207c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2083:	e8 0d 1d 00 00       	call   3d95 <printf>
    2088:	e8 8f 1b 00 00       	call   3c1c <exit>
    208d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2094:	00 
    2095:	c7 04 24 31 4c 00 00 	movl   $0x4c31,(%esp)
    209c:	e8 bb 1b 00 00       	call   3c5c <open>
    20a1:	85 c0                	test   %eax,%eax
    20a3:	78 19                	js     20be <subdir+0x3ed>
    20a5:	c7 44 24 04 3a 4c 00 	movl   $0x4c3a,0x4(%esp)
    20ac:	00 
    20ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20b4:	e8 dc 1c 00 00       	call   3d95 <printf>
    20b9:	e8 5e 1b 00 00       	call   3c1c <exit>
    20be:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    20c5:	00 
    20c6:	c7 04 24 56 4c 00 00 	movl   $0x4c56,(%esp)
    20cd:	e8 8a 1b 00 00       	call   3c5c <open>
    20d2:	85 c0                	test   %eax,%eax
    20d4:	78 19                	js     20ef <subdir+0x41e>
    20d6:	c7 44 24 04 5f 4c 00 	movl   $0x4c5f,0x4(%esp)
    20dd:	00 
    20de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20e5:	e8 ab 1c 00 00       	call   3d95 <printf>
    20ea:	e8 2d 1b 00 00       	call   3c1c <exit>
    20ef:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    20f6:	00 
    20f7:	c7 04 24 29 4a 00 00 	movl   $0x4a29,(%esp)
    20fe:	e8 59 1b 00 00       	call   3c5c <open>
    2103:	85 c0                	test   %eax,%eax
    2105:	78 19                	js     2120 <subdir+0x44f>
    2107:	c7 44 24 04 7b 4c 00 	movl   $0x4c7b,0x4(%esp)
    210e:	00 
    210f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2116:	e8 7a 1c 00 00       	call   3d95 <printf>
    211b:	e8 fc 1a 00 00       	call   3c1c <exit>
    2120:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2127:	00 
    2128:	c7 04 24 29 4a 00 00 	movl   $0x4a29,(%esp)
    212f:	e8 28 1b 00 00       	call   3c5c <open>
    2134:	85 c0                	test   %eax,%eax
    2136:	78 19                	js     2151 <subdir+0x480>
    2138:	c7 44 24 04 91 4c 00 	movl   $0x4c91,0x4(%esp)
    213f:	00 
    2140:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2147:	e8 49 1c 00 00       	call   3d95 <printf>
    214c:	e8 cb 1a 00 00       	call   3c1c <exit>
    2151:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    2158:	00 
    2159:	c7 04 24 29 4a 00 00 	movl   $0x4a29,(%esp)
    2160:	e8 f7 1a 00 00       	call   3c5c <open>
    2165:	85 c0                	test   %eax,%eax
    2167:	78 19                	js     2182 <subdir+0x4b1>
    2169:	c7 44 24 04 aa 4c 00 	movl   $0x4caa,0x4(%esp)
    2170:	00 
    2171:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2178:	e8 18 1c 00 00       	call   3d95 <printf>
    217d:	e8 9a 1a 00 00       	call   3c1c <exit>
    2182:	c7 44 24 04 c5 4c 00 	movl   $0x4cc5,0x4(%esp)
    2189:	00 
    218a:	c7 04 24 31 4c 00 00 	movl   $0x4c31,(%esp)
    2191:	e8 e6 1a 00 00       	call   3c7c <link>
    2196:	85 c0                	test   %eax,%eax
    2198:	75 19                	jne    21b3 <subdir+0x4e2>
    219a:	c7 44 24 04 d0 4c 00 	movl   $0x4cd0,0x4(%esp)
    21a1:	00 
    21a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21a9:	e8 e7 1b 00 00       	call   3d95 <printf>
    21ae:	e8 69 1a 00 00       	call   3c1c <exit>
    21b3:	c7 44 24 04 c5 4c 00 	movl   $0x4cc5,0x4(%esp)
    21ba:	00 
    21bb:	c7 04 24 56 4c 00 00 	movl   $0x4c56,(%esp)
    21c2:	e8 b5 1a 00 00       	call   3c7c <link>
    21c7:	85 c0                	test   %eax,%eax
    21c9:	75 19                	jne    21e4 <subdir+0x513>
    21cb:	c7 44 24 04 f4 4c 00 	movl   $0x4cf4,0x4(%esp)
    21d2:	00 
    21d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21da:	e8 b6 1b 00 00       	call   3d95 <printf>
    21df:	e8 38 1a 00 00       	call   3c1c <exit>
    21e4:	c7 44 24 04 0c 4b 00 	movl   $0x4b0c,0x4(%esp)
    21eb:	00 
    21ec:	c7 04 24 44 4a 00 00 	movl   $0x4a44,(%esp)
    21f3:	e8 84 1a 00 00       	call   3c7c <link>
    21f8:	85 c0                	test   %eax,%eax
    21fa:	75 19                	jne    2215 <subdir+0x544>
    21fc:	c7 44 24 04 18 4d 00 	movl   $0x4d18,0x4(%esp)
    2203:	00 
    2204:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    220b:	e8 85 1b 00 00       	call   3d95 <printf>
    2210:	e8 07 1a 00 00       	call   3c1c <exit>
    2215:	c7 04 24 31 4c 00 00 	movl   $0x4c31,(%esp)
    221c:	e8 63 1a 00 00       	call   3c84 <mkdir>
    2221:	85 c0                	test   %eax,%eax
    2223:	75 19                	jne    223e <subdir+0x56d>
    2225:	c7 44 24 04 3a 4d 00 	movl   $0x4d3a,0x4(%esp)
    222c:	00 
    222d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2234:	e8 5c 1b 00 00       	call   3d95 <printf>
    2239:	e8 de 19 00 00       	call   3c1c <exit>
    223e:	c7 04 24 56 4c 00 00 	movl   $0x4c56,(%esp)
    2245:	e8 3a 1a 00 00       	call   3c84 <mkdir>
    224a:	85 c0                	test   %eax,%eax
    224c:	75 19                	jne    2267 <subdir+0x596>
    224e:	c7 44 24 04 55 4d 00 	movl   $0x4d55,0x4(%esp)
    2255:	00 
    2256:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    225d:	e8 33 1b 00 00       	call   3d95 <printf>
    2262:	e8 b5 19 00 00       	call   3c1c <exit>
    2267:	c7 04 24 0c 4b 00 00 	movl   $0x4b0c,(%esp)
    226e:	e8 11 1a 00 00       	call   3c84 <mkdir>
    2273:	85 c0                	test   %eax,%eax
    2275:	75 19                	jne    2290 <subdir+0x5bf>
    2277:	c7 44 24 04 70 4d 00 	movl   $0x4d70,0x4(%esp)
    227e:	00 
    227f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2286:	e8 0a 1b 00 00       	call   3d95 <printf>
    228b:	e8 8c 19 00 00       	call   3c1c <exit>
    2290:	c7 04 24 56 4c 00 00 	movl   $0x4c56,(%esp)
    2297:	e8 d0 19 00 00       	call   3c6c <unlink>
    229c:	85 c0                	test   %eax,%eax
    229e:	75 19                	jne    22b9 <subdir+0x5e8>
    22a0:	c7 44 24 04 8d 4d 00 	movl   $0x4d8d,0x4(%esp)
    22a7:	00 
    22a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22af:	e8 e1 1a 00 00       	call   3d95 <printf>
    22b4:	e8 63 19 00 00       	call   3c1c <exit>
    22b9:	c7 04 24 31 4c 00 00 	movl   $0x4c31,(%esp)
    22c0:	e8 a7 19 00 00       	call   3c6c <unlink>
    22c5:	85 c0                	test   %eax,%eax
    22c7:	75 19                	jne    22e2 <subdir+0x611>
    22c9:	c7 44 24 04 a9 4d 00 	movl   $0x4da9,0x4(%esp)
    22d0:	00 
    22d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22d8:	e8 b8 1a 00 00       	call   3d95 <printf>
    22dd:	e8 3a 19 00 00       	call   3c1c <exit>
    22e2:	c7 04 24 44 4a 00 00 	movl   $0x4a44,(%esp)
    22e9:	e8 9e 19 00 00       	call   3c8c <chdir>
    22ee:	85 c0                	test   %eax,%eax
    22f0:	75 19                	jne    230b <subdir+0x63a>
    22f2:	c7 44 24 04 c5 4d 00 	movl   $0x4dc5,0x4(%esp)
    22f9:	00 
    22fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2301:	e8 8f 1a 00 00       	call   3d95 <printf>
    2306:	e8 11 19 00 00       	call   3c1c <exit>
    230b:	c7 04 24 dd 4d 00 00 	movl   $0x4ddd,(%esp)
    2312:	e8 75 19 00 00       	call   3c8c <chdir>
    2317:	85 c0                	test   %eax,%eax
    2319:	75 19                	jne    2334 <subdir+0x663>
    231b:	c7 44 24 04 e3 4d 00 	movl   $0x4de3,0x4(%esp)
    2322:	00 
    2323:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    232a:	e8 66 1a 00 00       	call   3d95 <printf>
    232f:	e8 e8 18 00 00       	call   3c1c <exit>
    2334:	c7 04 24 0c 4b 00 00 	movl   $0x4b0c,(%esp)
    233b:	e8 2c 19 00 00       	call   3c6c <unlink>
    2340:	85 c0                	test   %eax,%eax
    2342:	74 19                	je     235d <subdir+0x68c>
    2344:	c7 44 24 04 39 4b 00 	movl   $0x4b39,0x4(%esp)
    234b:	00 
    234c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2353:	e8 3d 1a 00 00       	call   3d95 <printf>
    2358:	e8 bf 18 00 00       	call   3c1c <exit>
    235d:	c7 04 24 44 4a 00 00 	movl   $0x4a44,(%esp)
    2364:	e8 03 19 00 00       	call   3c6c <unlink>
    2369:	85 c0                	test   %eax,%eax
    236b:	74 19                	je     2386 <subdir+0x6b5>
    236d:	c7 44 24 04 fb 4d 00 	movl   $0x4dfb,0x4(%esp)
    2374:	00 
    2375:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    237c:	e8 14 1a 00 00       	call   3d95 <printf>
    2381:	e8 96 18 00 00       	call   3c1c <exit>
    2386:	c7 04 24 29 4a 00 00 	movl   $0x4a29,(%esp)
    238d:	e8 da 18 00 00       	call   3c6c <unlink>
    2392:	85 c0                	test   %eax,%eax
    2394:	75 19                	jne    23af <subdir+0x6de>
    2396:	c7 44 24 04 10 4e 00 	movl   $0x4e10,0x4(%esp)
    239d:	00 
    239e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23a5:	e8 eb 19 00 00       	call   3d95 <printf>
    23aa:	e8 6d 18 00 00       	call   3c1c <exit>
    23af:	c7 04 24 30 4e 00 00 	movl   $0x4e30,(%esp)
    23b6:	e8 b1 18 00 00       	call   3c6c <unlink>
    23bb:	85 c0                	test   %eax,%eax
    23bd:	79 19                	jns    23d8 <subdir+0x707>
    23bf:	c7 44 24 04 36 4e 00 	movl   $0x4e36,0x4(%esp)
    23c6:	00 
    23c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23ce:	e8 c2 19 00 00       	call   3d95 <printf>
    23d3:	e8 44 18 00 00       	call   3c1c <exit>
    23d8:	c7 04 24 29 4a 00 00 	movl   $0x4a29,(%esp)
    23df:	e8 88 18 00 00       	call   3c6c <unlink>
    23e4:	85 c0                	test   %eax,%eax
    23e6:	79 19                	jns    2401 <subdir+0x730>
    23e8:	c7 44 24 04 4b 4e 00 	movl   $0x4e4b,0x4(%esp)
    23ef:	00 
    23f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23f7:	e8 99 19 00 00       	call   3d95 <printf>
    23fc:	e8 1b 18 00 00       	call   3c1c <exit>
    2401:	c7 44 24 04 5d 4e 00 	movl   $0x4e5d,0x4(%esp)
    2408:	00 
    2409:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2410:	e8 80 19 00 00       	call   3d95 <printf>
    2415:	c9                   	leave  
    2416:	c3                   	ret    

00002417 <bigwrite>:
    2417:	55                   	push   %ebp
    2418:	89 e5                	mov    %esp,%ebp
    241a:	83 ec 28             	sub    $0x28,%esp
    241d:	c7 44 24 04 68 4e 00 	movl   $0x4e68,0x4(%esp)
    2424:	00 
    2425:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    242c:	e8 64 19 00 00       	call   3d95 <printf>
    2431:	c7 04 24 77 4e 00 00 	movl   $0x4e77,(%esp)
    2438:	e8 2f 18 00 00       	call   3c6c <unlink>
    243d:	c7 45 ec f3 01 00 00 	movl   $0x1f3,-0x14(%ebp)
    2444:	e9 b3 00 00 00       	jmp    24fc <bigwrite+0xe5>
    2449:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2450:	00 
    2451:	c7 04 24 77 4e 00 00 	movl   $0x4e77,(%esp)
    2458:	e8 ff 17 00 00       	call   3c5c <open>
    245d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    2460:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2464:	79 19                	jns    247f <bigwrite+0x68>
    2466:	c7 44 24 04 80 4e 00 	movl   $0x4e80,0x4(%esp)
    246d:	00 
    246e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2475:	e8 1b 19 00 00       	call   3d95 <printf>
    247a:	e8 9d 17 00 00       	call   3c1c <exit>
    247f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2486:	eb 50                	jmp    24d8 <bigwrite+0xc1>
    2488:	8b 45 ec             	mov    -0x14(%ebp),%eax
    248b:	89 44 24 08          	mov    %eax,0x8(%esp)
    248f:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
    2496:	00 
    2497:	8b 45 e8             	mov    -0x18(%ebp),%eax
    249a:	89 04 24             	mov    %eax,(%esp)
    249d:	e8 9a 17 00 00       	call   3c3c <write>
    24a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    24a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    24ab:	74 27                	je     24d4 <bigwrite+0xbd>
    24ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
    24b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    24b7:	89 44 24 08          	mov    %eax,0x8(%esp)
    24bb:	c7 44 24 04 98 4e 00 	movl   $0x4e98,0x4(%esp)
    24c2:	00 
    24c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24ca:	e8 c6 18 00 00       	call   3d95 <printf>
    24cf:	e8 48 17 00 00       	call   3c1c <exit>
    24d4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    24d8:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    24dc:	7e aa                	jle    2488 <bigwrite+0x71>
    24de:	8b 45 e8             	mov    -0x18(%ebp),%eax
    24e1:	89 04 24             	mov    %eax,(%esp)
    24e4:	e8 5b 17 00 00       	call   3c44 <close>
    24e9:	c7 04 24 77 4e 00 00 	movl   $0x4e77,(%esp)
    24f0:	e8 77 17 00 00       	call   3c6c <unlink>
    24f5:	81 45 ec d7 01 00 00 	addl   $0x1d7,-0x14(%ebp)
    24fc:	81 7d ec ff 17 00 00 	cmpl   $0x17ff,-0x14(%ebp)
    2503:	0f 8e 40 ff ff ff    	jle    2449 <bigwrite+0x32>
    2509:	c7 44 24 04 aa 4e 00 	movl   $0x4eaa,0x4(%esp)
    2510:	00 
    2511:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2518:	e8 78 18 00 00       	call   3d95 <printf>
    251d:	c9                   	leave  
    251e:	c3                   	ret    

0000251f <bigfile>:
    251f:	55                   	push   %ebp
    2520:	89 e5                	mov    %esp,%ebp
    2522:	83 ec 28             	sub    $0x28,%esp
    2525:	c7 44 24 04 b7 4e 00 	movl   $0x4eb7,0x4(%esp)
    252c:	00 
    252d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2534:	e8 5c 18 00 00       	call   3d95 <printf>
    2539:	c7 04 24 c5 4e 00 00 	movl   $0x4ec5,(%esp)
    2540:	e8 27 17 00 00       	call   3c6c <unlink>
    2545:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    254c:	00 
    254d:	c7 04 24 c5 4e 00 00 	movl   $0x4ec5,(%esp)
    2554:	e8 03 17 00 00       	call   3c5c <open>
    2559:	89 45 e8             	mov    %eax,-0x18(%ebp)
    255c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2560:	79 19                	jns    257b <bigfile+0x5c>
    2562:	c7 44 24 04 cd 4e 00 	movl   $0x4ecd,0x4(%esp)
    2569:	00 
    256a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2571:	e8 1f 18 00 00       	call   3d95 <printf>
    2576:	e8 a1 16 00 00       	call   3c1c <exit>
    257b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    2582:	eb 5a                	jmp    25de <bigfile+0xbf>
    2584:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    258b:	00 
    258c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    258f:	89 44 24 04          	mov    %eax,0x4(%esp)
    2593:	c7 04 24 20 80 00 00 	movl   $0x8020,(%esp)
    259a:	e8 d7 14 00 00       	call   3a76 <memset>
    259f:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    25a6:	00 
    25a7:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
    25ae:	00 
    25af:	8b 45 e8             	mov    -0x18(%ebp),%eax
    25b2:	89 04 24             	mov    %eax,(%esp)
    25b5:	e8 82 16 00 00       	call   3c3c <write>
    25ba:	3d 58 02 00 00       	cmp    $0x258,%eax
    25bf:	74 19                	je     25da <bigfile+0xbb>
    25c1:	c7 44 24 04 e3 4e 00 	movl   $0x4ee3,0x4(%esp)
    25c8:	00 
    25c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25d0:	e8 c0 17 00 00       	call   3d95 <printf>
    25d5:	e8 42 16 00 00       	call   3c1c <exit>
    25da:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    25de:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
    25e2:	7e a0                	jle    2584 <bigfile+0x65>
    25e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    25e7:	89 04 24             	mov    %eax,(%esp)
    25ea:	e8 55 16 00 00       	call   3c44 <close>
    25ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    25f6:	00 
    25f7:	c7 04 24 c5 4e 00 00 	movl   $0x4ec5,(%esp)
    25fe:	e8 59 16 00 00       	call   3c5c <open>
    2603:	89 45 e8             	mov    %eax,-0x18(%ebp)
    2606:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    260a:	79 19                	jns    2625 <bigfile+0x106>
    260c:	c7 44 24 04 f9 4e 00 	movl   $0x4ef9,0x4(%esp)
    2613:	00 
    2614:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    261b:	e8 75 17 00 00       	call   3d95 <printf>
    2620:	e8 f7 15 00 00       	call   3c1c <exit>
    2625:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    262c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    2633:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    263a:	00 
    263b:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
    2642:	00 
    2643:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2646:	89 04 24             	mov    %eax,(%esp)
    2649:	e8 e6 15 00 00       	call   3c34 <read>
    264e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2651:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2655:	79 19                	jns    2670 <bigfile+0x151>
    2657:	c7 44 24 04 0e 4f 00 	movl   $0x4f0e,0x4(%esp)
    265e:	00 
    265f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2666:	e8 2a 17 00 00       	call   3d95 <printf>
    266b:	e8 ac 15 00 00       	call   3c1c <exit>
    2670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2674:	0f 84 80 00 00 00    	je     26fa <bigfile+0x1db>
    267a:	81 7d f4 2c 01 00 00 	cmpl   $0x12c,-0xc(%ebp)
    2681:	74 19                	je     269c <bigfile+0x17d>
    2683:	c7 44 24 04 23 4f 00 	movl   $0x4f23,0x4(%esp)
    268a:	00 
    268b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2692:	e8 fe 16 00 00       	call   3d95 <printf>
    2697:	e8 80 15 00 00       	call   3c1c <exit>
    269c:	0f b6 05 20 80 00 00 	movzbl 0x8020,%eax
    26a3:	0f be d0             	movsbl %al,%edx
    26a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    26a9:	89 c1                	mov    %eax,%ecx
    26ab:	c1 e9 1f             	shr    $0x1f,%ecx
    26ae:	8d 04 01             	lea    (%ecx,%eax,1),%eax
    26b1:	d1 f8                	sar    %eax
    26b3:	39 c2                	cmp    %eax,%edx
    26b5:	75 1b                	jne    26d2 <bigfile+0x1b3>
    26b7:	0f b6 05 4b 81 00 00 	movzbl 0x814b,%eax
    26be:	0f be d0             	movsbl %al,%edx
    26c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    26c4:	89 c1                	mov    %eax,%ecx
    26c6:	c1 e9 1f             	shr    $0x1f,%ecx
    26c9:	8d 04 01             	lea    (%ecx,%eax,1),%eax
    26cc:	d1 f8                	sar    %eax
    26ce:	39 c2                	cmp    %eax,%edx
    26d0:	74 19                	je     26eb <bigfile+0x1cc>
    26d2:	c7 44 24 04 37 4f 00 	movl   $0x4f37,0x4(%esp)
    26d9:	00 
    26da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26e1:	e8 af 16 00 00       	call   3d95 <printf>
    26e6:	e8 31 15 00 00       	call   3c1c <exit>
    26eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26ee:	01 45 f0             	add    %eax,-0x10(%ebp)
    26f1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    26f5:	e9 39 ff ff ff       	jmp    2633 <bigfile+0x114>
    26fa:	90                   	nop
    26fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    26fe:	89 04 24             	mov    %eax,(%esp)
    2701:	e8 3e 15 00 00       	call   3c44 <close>
    2706:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    270d:	74 19                	je     2728 <bigfile+0x209>
    270f:	c7 44 24 04 50 4f 00 	movl   $0x4f50,0x4(%esp)
    2716:	00 
    2717:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    271e:	e8 72 16 00 00       	call   3d95 <printf>
    2723:	e8 f4 14 00 00       	call   3c1c <exit>
    2728:	c7 04 24 c5 4e 00 00 	movl   $0x4ec5,(%esp)
    272f:	e8 38 15 00 00       	call   3c6c <unlink>
    2734:	c7 44 24 04 6a 4f 00 	movl   $0x4f6a,0x4(%esp)
    273b:	00 
    273c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2743:	e8 4d 16 00 00       	call   3d95 <printf>
    2748:	c9                   	leave  
    2749:	c3                   	ret    

0000274a <fourteen>:
    274a:	55                   	push   %ebp
    274b:	89 e5                	mov    %esp,%ebp
    274d:	83 ec 28             	sub    $0x28,%esp
    2750:	c7 44 24 04 7b 4f 00 	movl   $0x4f7b,0x4(%esp)
    2757:	00 
    2758:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    275f:	e8 31 16 00 00       	call   3d95 <printf>
    2764:	c7 04 24 8a 4f 00 00 	movl   $0x4f8a,(%esp)
    276b:	e8 14 15 00 00       	call   3c84 <mkdir>
    2770:	85 c0                	test   %eax,%eax
    2772:	74 19                	je     278d <fourteen+0x43>
    2774:	c7 44 24 04 99 4f 00 	movl   $0x4f99,0x4(%esp)
    277b:	00 
    277c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2783:	e8 0d 16 00 00       	call   3d95 <printf>
    2788:	e8 8f 14 00 00       	call   3c1c <exit>
    278d:	c7 04 24 b8 4f 00 00 	movl   $0x4fb8,(%esp)
    2794:	e8 eb 14 00 00       	call   3c84 <mkdir>
    2799:	85 c0                	test   %eax,%eax
    279b:	74 19                	je     27b6 <fourteen+0x6c>
    279d:	c7 44 24 04 d8 4f 00 	movl   $0x4fd8,0x4(%esp)
    27a4:	00 
    27a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27ac:	e8 e4 15 00 00       	call   3d95 <printf>
    27b1:	e8 66 14 00 00       	call   3c1c <exit>
    27b6:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    27bd:	00 
    27be:	c7 04 24 08 50 00 00 	movl   $0x5008,(%esp)
    27c5:	e8 92 14 00 00       	call   3c5c <open>
    27ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    27cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    27d1:	79 19                	jns    27ec <fourteen+0xa2>
    27d3:	c7 44 24 04 38 50 00 	movl   $0x5038,0x4(%esp)
    27da:	00 
    27db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27e2:	e8 ae 15 00 00       	call   3d95 <printf>
    27e7:	e8 30 14 00 00       	call   3c1c <exit>
    27ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    27ef:	89 04 24             	mov    %eax,(%esp)
    27f2:	e8 4d 14 00 00       	call   3c44 <close>
    27f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    27fe:	00 
    27ff:	c7 04 24 78 50 00 00 	movl   $0x5078,(%esp)
    2806:	e8 51 14 00 00       	call   3c5c <open>
    280b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    280e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2812:	79 19                	jns    282d <fourteen+0xe3>
    2814:	c7 44 24 04 a8 50 00 	movl   $0x50a8,0x4(%esp)
    281b:	00 
    281c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2823:	e8 6d 15 00 00       	call   3d95 <printf>
    2828:	e8 ef 13 00 00       	call   3c1c <exit>
    282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2830:	89 04 24             	mov    %eax,(%esp)
    2833:	e8 0c 14 00 00       	call   3c44 <close>
    2838:	c7 04 24 e2 50 00 00 	movl   $0x50e2,(%esp)
    283f:	e8 40 14 00 00       	call   3c84 <mkdir>
    2844:	85 c0                	test   %eax,%eax
    2846:	75 19                	jne    2861 <fourteen+0x117>
    2848:	c7 44 24 04 00 51 00 	movl   $0x5100,0x4(%esp)
    284f:	00 
    2850:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2857:	e8 39 15 00 00       	call   3d95 <printf>
    285c:	e8 bb 13 00 00       	call   3c1c <exit>
    2861:	c7 04 24 30 51 00 00 	movl   $0x5130,(%esp)
    2868:	e8 17 14 00 00       	call   3c84 <mkdir>
    286d:	85 c0                	test   %eax,%eax
    286f:	75 19                	jne    288a <fourteen+0x140>
    2871:	c7 44 24 04 50 51 00 	movl   $0x5150,0x4(%esp)
    2878:	00 
    2879:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2880:	e8 10 15 00 00       	call   3d95 <printf>
    2885:	e8 92 13 00 00       	call   3c1c <exit>
    288a:	c7 44 24 04 81 51 00 	movl   $0x5181,0x4(%esp)
    2891:	00 
    2892:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2899:	e8 f7 14 00 00       	call   3d95 <printf>
    289e:	c9                   	leave  
    289f:	c3                   	ret    

000028a0 <rmdot>:
    28a0:	55                   	push   %ebp
    28a1:	89 e5                	mov    %esp,%ebp
    28a3:	83 ec 18             	sub    $0x18,%esp
    28a6:	c7 44 24 04 8e 51 00 	movl   $0x518e,0x4(%esp)
    28ad:	00 
    28ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28b5:	e8 db 14 00 00       	call   3d95 <printf>
    28ba:	c7 04 24 9a 51 00 00 	movl   $0x519a,(%esp)
    28c1:	e8 be 13 00 00       	call   3c84 <mkdir>
    28c6:	85 c0                	test   %eax,%eax
    28c8:	74 19                	je     28e3 <rmdot+0x43>
    28ca:	c7 44 24 04 9f 51 00 	movl   $0x519f,0x4(%esp)
    28d1:	00 
    28d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28d9:	e8 b7 14 00 00       	call   3d95 <printf>
    28de:	e8 39 13 00 00       	call   3c1c <exit>
    28e3:	c7 04 24 9a 51 00 00 	movl   $0x519a,(%esp)
    28ea:	e8 9d 13 00 00       	call   3c8c <chdir>
    28ef:	85 c0                	test   %eax,%eax
    28f1:	74 19                	je     290c <rmdot+0x6c>
    28f3:	c7 44 24 04 b2 51 00 	movl   $0x51b2,0x4(%esp)
    28fa:	00 
    28fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2902:	e8 8e 14 00 00       	call   3d95 <printf>
    2907:	e8 10 13 00 00       	call   3c1c <exit>
    290c:	c7 04 24 cb 48 00 00 	movl   $0x48cb,(%esp)
    2913:	e8 54 13 00 00       	call   3c6c <unlink>
    2918:	85 c0                	test   %eax,%eax
    291a:	75 19                	jne    2935 <rmdot+0x95>
    291c:	c7 44 24 04 c5 51 00 	movl   $0x51c5,0x4(%esp)
    2923:	00 
    2924:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    292b:	e8 65 14 00 00       	call   3d95 <printf>
    2930:	e8 e7 12 00 00       	call   3c1c <exit>
    2935:	c7 04 24 58 44 00 00 	movl   $0x4458,(%esp)
    293c:	e8 2b 13 00 00       	call   3c6c <unlink>
    2941:	85 c0                	test   %eax,%eax
    2943:	75 19                	jne    295e <rmdot+0xbe>
    2945:	c7 44 24 04 d3 51 00 	movl   $0x51d3,0x4(%esp)
    294c:	00 
    294d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2954:	e8 3c 14 00 00       	call   3d95 <printf>
    2959:	e8 be 12 00 00       	call   3c1c <exit>
    295e:	c7 04 24 e2 51 00 00 	movl   $0x51e2,(%esp)
    2965:	e8 22 13 00 00       	call   3c8c <chdir>
    296a:	85 c0                	test   %eax,%eax
    296c:	74 19                	je     2987 <rmdot+0xe7>
    296e:	c7 44 24 04 e4 51 00 	movl   $0x51e4,0x4(%esp)
    2975:	00 
    2976:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    297d:	e8 13 14 00 00       	call   3d95 <printf>
    2982:	e8 95 12 00 00       	call   3c1c <exit>
    2987:	c7 04 24 f4 51 00 00 	movl   $0x51f4,(%esp)
    298e:	e8 d9 12 00 00       	call   3c6c <unlink>
    2993:	85 c0                	test   %eax,%eax
    2995:	75 19                	jne    29b0 <rmdot+0x110>
    2997:	c7 44 24 04 fb 51 00 	movl   $0x51fb,0x4(%esp)
    299e:	00 
    299f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29a6:	e8 ea 13 00 00       	call   3d95 <printf>
    29ab:	e8 6c 12 00 00       	call   3c1c <exit>
    29b0:	c7 04 24 12 52 00 00 	movl   $0x5212,(%esp)
    29b7:	e8 b0 12 00 00       	call   3c6c <unlink>
    29bc:	85 c0                	test   %eax,%eax
    29be:	75 19                	jne    29d9 <rmdot+0x139>
    29c0:	c7 44 24 04 1a 52 00 	movl   $0x521a,0x4(%esp)
    29c7:	00 
    29c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29cf:	e8 c1 13 00 00       	call   3d95 <printf>
    29d4:	e8 43 12 00 00       	call   3c1c <exit>
    29d9:	c7 04 24 9a 51 00 00 	movl   $0x519a,(%esp)
    29e0:	e8 87 12 00 00       	call   3c6c <unlink>
    29e5:	85 c0                	test   %eax,%eax
    29e7:	74 19                	je     2a02 <rmdot+0x162>
    29e9:	c7 44 24 04 32 52 00 	movl   $0x5232,0x4(%esp)
    29f0:	00 
    29f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29f8:	e8 98 13 00 00       	call   3d95 <printf>
    29fd:	e8 1a 12 00 00       	call   3c1c <exit>
    2a02:	c7 44 24 04 47 52 00 	movl   $0x5247,0x4(%esp)
    2a09:	00 
    2a0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a11:	e8 7f 13 00 00       	call   3d95 <printf>
    2a16:	c9                   	leave  
    2a17:	c3                   	ret    

00002a18 <dirfile>:
    2a18:	55                   	push   %ebp
    2a19:	89 e5                	mov    %esp,%ebp
    2a1b:	83 ec 28             	sub    $0x28,%esp
    2a1e:	c7 44 24 04 51 52 00 	movl   $0x5251,0x4(%esp)
    2a25:	00 
    2a26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a2d:	e8 63 13 00 00       	call   3d95 <printf>
    2a32:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2a39:	00 
    2a3a:	c7 04 24 5e 52 00 00 	movl   $0x525e,(%esp)
    2a41:	e8 16 12 00 00       	call   3c5c <open>
    2a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2a49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a4d:	79 19                	jns    2a68 <dirfile+0x50>
    2a4f:	c7 44 24 04 66 52 00 	movl   $0x5266,0x4(%esp)
    2a56:	00 
    2a57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a5e:	e8 32 13 00 00       	call   3d95 <printf>
    2a63:	e8 b4 11 00 00       	call   3c1c <exit>
    2a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a6b:	89 04 24             	mov    %eax,(%esp)
    2a6e:	e8 d1 11 00 00       	call   3c44 <close>
    2a73:	c7 04 24 5e 52 00 00 	movl   $0x525e,(%esp)
    2a7a:	e8 0d 12 00 00       	call   3c8c <chdir>
    2a7f:	85 c0                	test   %eax,%eax
    2a81:	75 19                	jne    2a9c <dirfile+0x84>
    2a83:	c7 44 24 04 7d 52 00 	movl   $0x527d,0x4(%esp)
    2a8a:	00 
    2a8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a92:	e8 fe 12 00 00       	call   3d95 <printf>
    2a97:	e8 80 11 00 00       	call   3c1c <exit>
    2a9c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2aa3:	00 
    2aa4:	c7 04 24 97 52 00 00 	movl   $0x5297,(%esp)
    2aab:	e8 ac 11 00 00       	call   3c5c <open>
    2ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2ab3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2ab7:	78 19                	js     2ad2 <dirfile+0xba>
    2ab9:	c7 44 24 04 a2 52 00 	movl   $0x52a2,0x4(%esp)
    2ac0:	00 
    2ac1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ac8:	e8 c8 12 00 00       	call   3d95 <printf>
    2acd:	e8 4a 11 00 00       	call   3c1c <exit>
    2ad2:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2ad9:	00 
    2ada:	c7 04 24 97 52 00 00 	movl   $0x5297,(%esp)
    2ae1:	e8 76 11 00 00       	call   3c5c <open>
    2ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2ae9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2aed:	78 19                	js     2b08 <dirfile+0xf0>
    2aef:	c7 44 24 04 a2 52 00 	movl   $0x52a2,0x4(%esp)
    2af6:	00 
    2af7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2afe:	e8 92 12 00 00       	call   3d95 <printf>
    2b03:	e8 14 11 00 00       	call   3c1c <exit>
    2b08:	c7 04 24 97 52 00 00 	movl   $0x5297,(%esp)
    2b0f:	e8 70 11 00 00       	call   3c84 <mkdir>
    2b14:	85 c0                	test   %eax,%eax
    2b16:	75 19                	jne    2b31 <dirfile+0x119>
    2b18:	c7 44 24 04 c0 52 00 	movl   $0x52c0,0x4(%esp)
    2b1f:	00 
    2b20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b27:	e8 69 12 00 00       	call   3d95 <printf>
    2b2c:	e8 eb 10 00 00       	call   3c1c <exit>
    2b31:	c7 04 24 97 52 00 00 	movl   $0x5297,(%esp)
    2b38:	e8 2f 11 00 00       	call   3c6c <unlink>
    2b3d:	85 c0                	test   %eax,%eax
    2b3f:	75 19                	jne    2b5a <dirfile+0x142>
    2b41:	c7 44 24 04 dd 52 00 	movl   $0x52dd,0x4(%esp)
    2b48:	00 
    2b49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b50:	e8 40 12 00 00       	call   3d95 <printf>
    2b55:	e8 c2 10 00 00       	call   3c1c <exit>
    2b5a:	c7 44 24 04 97 52 00 	movl   $0x5297,0x4(%esp)
    2b61:	00 
    2b62:	c7 04 24 fb 52 00 00 	movl   $0x52fb,(%esp)
    2b69:	e8 0e 11 00 00       	call   3c7c <link>
    2b6e:	85 c0                	test   %eax,%eax
    2b70:	75 19                	jne    2b8b <dirfile+0x173>
    2b72:	c7 44 24 04 04 53 00 	movl   $0x5304,0x4(%esp)
    2b79:	00 
    2b7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b81:	e8 0f 12 00 00       	call   3d95 <printf>
    2b86:	e8 91 10 00 00       	call   3c1c <exit>
    2b8b:	c7 04 24 5e 52 00 00 	movl   $0x525e,(%esp)
    2b92:	e8 d5 10 00 00       	call   3c6c <unlink>
    2b97:	85 c0                	test   %eax,%eax
    2b99:	74 19                	je     2bb4 <dirfile+0x19c>
    2b9b:	c7 44 24 04 23 53 00 	movl   $0x5323,0x4(%esp)
    2ba2:	00 
    2ba3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2baa:	e8 e6 11 00 00       	call   3d95 <printf>
    2baf:	e8 68 10 00 00       	call   3c1c <exit>
    2bb4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2bbb:	00 
    2bbc:	c7 04 24 cb 48 00 00 	movl   $0x48cb,(%esp)
    2bc3:	e8 94 10 00 00       	call   3c5c <open>
    2bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2bcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2bcf:	78 19                	js     2bea <dirfile+0x1d2>
    2bd1:	c7 44 24 04 3c 53 00 	movl   $0x533c,0x4(%esp)
    2bd8:	00 
    2bd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2be0:	e8 b0 11 00 00       	call   3d95 <printf>
    2be5:	e8 32 10 00 00       	call   3c1c <exit>
    2bea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2bf1:	00 
    2bf2:	c7 04 24 cb 48 00 00 	movl   $0x48cb,(%esp)
    2bf9:	e8 5e 10 00 00       	call   3c5c <open>
    2bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2c01:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2c08:	00 
    2c09:	c7 44 24 04 02 45 00 	movl   $0x4502,0x4(%esp)
    2c10:	00 
    2c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2c14:	89 04 24             	mov    %eax,(%esp)
    2c17:	e8 20 10 00 00       	call   3c3c <write>
    2c1c:	85 c0                	test   %eax,%eax
    2c1e:	7e 19                	jle    2c39 <dirfile+0x221>
    2c20:	c7 44 24 04 5b 53 00 	movl   $0x535b,0x4(%esp)
    2c27:	00 
    2c28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c2f:	e8 61 11 00 00       	call   3d95 <printf>
    2c34:	e8 e3 0f 00 00       	call   3c1c <exit>
    2c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2c3c:	89 04 24             	mov    %eax,(%esp)
    2c3f:	e8 00 10 00 00       	call   3c44 <close>
    2c44:	c7 44 24 04 6f 53 00 	movl   $0x536f,0x4(%esp)
    2c4b:	00 
    2c4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c53:	e8 3d 11 00 00       	call   3d95 <printf>
    2c58:	c9                   	leave  
    2c59:	c3                   	ret    

00002c5a <iref>:
    2c5a:	55                   	push   %ebp
    2c5b:	89 e5                	mov    %esp,%ebp
    2c5d:	83 ec 28             	sub    $0x28,%esp
    2c60:	c7 44 24 04 7f 53 00 	movl   $0x537f,0x4(%esp)
    2c67:	00 
    2c68:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c6f:	e8 21 11 00 00       	call   3d95 <printf>
    2c74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2c7b:	e9 d2 00 00 00       	jmp    2d52 <iref+0xf8>
    2c80:	c7 04 24 90 53 00 00 	movl   $0x5390,(%esp)
    2c87:	e8 f8 0f 00 00       	call   3c84 <mkdir>
    2c8c:	85 c0                	test   %eax,%eax
    2c8e:	74 19                	je     2ca9 <iref+0x4f>
    2c90:	c7 44 24 04 96 53 00 	movl   $0x5396,0x4(%esp)
    2c97:	00 
    2c98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c9f:	e8 f1 10 00 00       	call   3d95 <printf>
    2ca4:	e8 73 0f 00 00       	call   3c1c <exit>
    2ca9:	c7 04 24 90 53 00 00 	movl   $0x5390,(%esp)
    2cb0:	e8 d7 0f 00 00       	call   3c8c <chdir>
    2cb5:	85 c0                	test   %eax,%eax
    2cb7:	74 19                	je     2cd2 <iref+0x78>
    2cb9:	c7 44 24 04 aa 53 00 	movl   $0x53aa,0x4(%esp)
    2cc0:	00 
    2cc1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cc8:	e8 c8 10 00 00       	call   3d95 <printf>
    2ccd:	e8 4a 0f 00 00       	call   3c1c <exit>
    2cd2:	c7 04 24 be 53 00 00 	movl   $0x53be,(%esp)
    2cd9:	e8 a6 0f 00 00       	call   3c84 <mkdir>
    2cde:	c7 44 24 04 be 53 00 	movl   $0x53be,0x4(%esp)
    2ce5:	00 
    2ce6:	c7 04 24 fb 52 00 00 	movl   $0x52fb,(%esp)
    2ced:	e8 8a 0f 00 00       	call   3c7c <link>
    2cf2:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2cf9:	00 
    2cfa:	c7 04 24 be 53 00 00 	movl   $0x53be,(%esp)
    2d01:	e8 56 0f 00 00       	call   3c5c <open>
    2d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2d09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d0d:	78 0b                	js     2d1a <iref+0xc0>
    2d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2d12:	89 04 24             	mov    %eax,(%esp)
    2d15:	e8 2a 0f 00 00       	call   3c44 <close>
    2d1a:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d21:	00 
    2d22:	c7 04 24 bf 53 00 00 	movl   $0x53bf,(%esp)
    2d29:	e8 2e 0f 00 00       	call   3c5c <open>
    2d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2d31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d35:	78 0b                	js     2d42 <iref+0xe8>
    2d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2d3a:	89 04 24             	mov    %eax,(%esp)
    2d3d:	e8 02 0f 00 00       	call   3c44 <close>
    2d42:	c7 04 24 bf 53 00 00 	movl   $0x53bf,(%esp)
    2d49:	e8 1e 0f 00 00       	call   3c6c <unlink>
    2d4e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2d52:	83 7d f0 32          	cmpl   $0x32,-0x10(%ebp)
    2d56:	0f 8e 24 ff ff ff    	jle    2c80 <iref+0x26>
    2d5c:	c7 04 24 e2 51 00 00 	movl   $0x51e2,(%esp)
    2d63:	e8 24 0f 00 00       	call   3c8c <chdir>
    2d68:	c7 44 24 04 c2 53 00 	movl   $0x53c2,0x4(%esp)
    2d6f:	00 
    2d70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d77:	e8 19 10 00 00       	call   3d95 <printf>
    2d7c:	c9                   	leave  
    2d7d:	c3                   	ret    

00002d7e <forktest>:
    2d7e:	55                   	push   %ebp
    2d7f:	89 e5                	mov    %esp,%ebp
    2d81:	83 ec 28             	sub    $0x28,%esp
    2d84:	c7 44 24 04 d6 53 00 	movl   $0x53d6,0x4(%esp)
    2d8b:	00 
    2d8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d93:	e8 fd 0f 00 00       	call   3d95 <printf>
    2d98:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2d9f:	eb 1d                	jmp    2dbe <forktest+0x40>
    2da1:	e8 6e 0e 00 00       	call   3c14 <fork>
    2da6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    2da9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2dad:	78 1a                	js     2dc9 <forktest+0x4b>
    2daf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2db3:	75 05                	jne    2dba <forktest+0x3c>
    2db5:	e8 62 0e 00 00       	call   3c1c <exit>
    2dba:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2dbe:	81 7d f0 e7 03 00 00 	cmpl   $0x3e7,-0x10(%ebp)
    2dc5:	7e da                	jle    2da1 <forktest+0x23>
    2dc7:	eb 01                	jmp    2dca <forktest+0x4c>
    2dc9:	90                   	nop
    2dca:	81 7d f0 e8 03 00 00 	cmpl   $0x3e8,-0x10(%ebp)
    2dd1:	75 3f                	jne    2e12 <forktest+0x94>
    2dd3:	c7 44 24 04 e4 53 00 	movl   $0x53e4,0x4(%esp)
    2dda:	00 
    2ddb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2de2:	e8 ae 0f 00 00       	call   3d95 <printf>
    2de7:	e8 30 0e 00 00       	call   3c1c <exit>
    2dec:	e8 33 0e 00 00       	call   3c24 <wait>
    2df1:	85 c0                	test   %eax,%eax
    2df3:	79 19                	jns    2e0e <forktest+0x90>
    2df5:	c7 44 24 04 06 54 00 	movl   $0x5406,0x4(%esp)
    2dfc:	00 
    2dfd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e04:	e8 8c 0f 00 00       	call   3d95 <printf>
    2e09:	e8 0e 0e 00 00       	call   3c1c <exit>
    2e0e:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
    2e12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2e16:	7f d4                	jg     2dec <forktest+0x6e>
    2e18:	e8 07 0e 00 00       	call   3c24 <wait>
    2e1d:	83 f8 ff             	cmp    $0xffffffff,%eax
    2e20:	74 19                	je     2e3b <forktest+0xbd>
    2e22:	c7 44 24 04 1a 54 00 	movl   $0x541a,0x4(%esp)
    2e29:	00 
    2e2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e31:	e8 5f 0f 00 00       	call   3d95 <printf>
    2e36:	e8 e1 0d 00 00       	call   3c1c <exit>
    2e3b:	c7 44 24 04 2d 54 00 	movl   $0x542d,0x4(%esp)
    2e42:	00 
    2e43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e4a:	e8 46 0f 00 00       	call   3d95 <printf>
    2e4f:	c9                   	leave  
    2e50:	c3                   	ret    

00002e51 <sbrktest>:
    2e51:	55                   	push   %ebp
    2e52:	89 e5                	mov    %esp,%ebp
    2e54:	53                   	push   %ebx
    2e55:	81 ec 84 00 00 00    	sub    $0x84,%esp
    2e5b:	a1 3c 58 00 00       	mov    0x583c,%eax
    2e60:	c7 44 24 04 3b 54 00 	movl   $0x543b,0x4(%esp)
    2e67:	00 
    2e68:	89 04 24             	mov    %eax,(%esp)
    2e6b:	e8 25 0f 00 00       	call   3d95 <printf>
    2e70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e77:	e8 28 0e 00 00       	call   3ca4 <sbrk>
    2e7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    2e7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e86:	e8 19 0e 00 00       	call   3ca4 <sbrk>
    2e8b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    2e8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2e95:	eb 59                	jmp    2ef0 <sbrktest+0x9f>
    2e97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e9e:	e8 01 0e 00 00       	call   3ca4 <sbrk>
    2ea3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    2ea6:	8b 45 dc             	mov    -0x24(%ebp),%eax
    2ea9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    2eac:	74 2f                	je     2edd <sbrktest+0x8c>
    2eae:	a1 3c 58 00 00       	mov    0x583c,%eax
    2eb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
    2eb6:	89 54 24 10          	mov    %edx,0x10(%esp)
    2eba:	8b 55 d8             	mov    -0x28(%ebp),%edx
    2ebd:	89 54 24 0c          	mov    %edx,0xc(%esp)
    2ec1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2ec4:	89 54 24 08          	mov    %edx,0x8(%esp)
    2ec8:	c7 44 24 04 46 54 00 	movl   $0x5446,0x4(%esp)
    2ecf:	00 
    2ed0:	89 04 24             	mov    %eax,(%esp)
    2ed3:	e8 bd 0e 00 00       	call   3d95 <printf>
    2ed8:	e8 3f 0d 00 00       	call   3c1c <exit>
    2edd:	8b 45 dc             	mov    -0x24(%ebp),%eax
    2ee0:	c6 00 01             	movb   $0x1,(%eax)
    2ee3:	8b 45 dc             	mov    -0x24(%ebp),%eax
    2ee6:	83 c0 01             	add    $0x1,%eax
    2ee9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    2eec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2ef0:	81 7d f4 87 13 00 00 	cmpl   $0x1387,-0xc(%ebp)
    2ef7:	7e 9e                	jle    2e97 <sbrktest+0x46>
    2ef9:	e8 16 0d 00 00       	call   3c14 <fork>
    2efe:	89 45 d0             	mov    %eax,-0x30(%ebp)
    2f01:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    2f05:	79 1a                	jns    2f21 <sbrktest+0xd0>
    2f07:	a1 3c 58 00 00       	mov    0x583c,%eax
    2f0c:	c7 44 24 04 61 54 00 	movl   $0x5461,0x4(%esp)
    2f13:	00 
    2f14:	89 04 24             	mov    %eax,(%esp)
    2f17:	e8 79 0e 00 00       	call   3d95 <printf>
    2f1c:	e8 fb 0c 00 00       	call   3c1c <exit>
    2f21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f28:	e8 77 0d 00 00       	call   3ca4 <sbrk>
    2f2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    2f30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f37:	e8 68 0d 00 00       	call   3ca4 <sbrk>
    2f3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    2f3f:	8b 45 d8             	mov    -0x28(%ebp),%eax
    2f42:	83 c0 01             	add    $0x1,%eax
    2f45:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    2f48:	74 1a                	je     2f64 <sbrktest+0x113>
    2f4a:	a1 3c 58 00 00       	mov    0x583c,%eax
    2f4f:	c7 44 24 04 78 54 00 	movl   $0x5478,0x4(%esp)
    2f56:	00 
    2f57:	89 04 24             	mov    %eax,(%esp)
    2f5a:	e8 36 0e 00 00       	call   3d95 <printf>
    2f5f:	e8 b8 0c 00 00       	call   3c1c <exit>
    2f64:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    2f68:	75 05                	jne    2f6f <sbrktest+0x11e>
    2f6a:	e8 ad 0c 00 00       	call   3c1c <exit>
    2f6f:	e8 b0 0c 00 00       	call   3c24 <wait>
    2f74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f7b:	e8 24 0d 00 00       	call   3ca4 <sbrk>
    2f80:	89 45 d8             	mov    %eax,-0x28(%ebp)
    2f83:	8b 45 d8             	mov    -0x28(%ebp),%eax
    2f86:	ba 00 00 40 06       	mov    $0x6400000,%edx
    2f8b:	89 d1                	mov    %edx,%ecx
    2f8d:	29 c1                	sub    %eax,%ecx
    2f8f:	89 c8                	mov    %ecx,%eax
    2f91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    2f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2f97:	89 04 24             	mov    %eax,(%esp)
    2f9a:	e8 05 0d 00 00       	call   3ca4 <sbrk>
    2f9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    2fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2fa5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    2fa8:	74 1a                	je     2fc4 <sbrktest+0x173>
    2faa:	a1 3c 58 00 00       	mov    0x583c,%eax
    2faf:	c7 44 24 04 94 54 00 	movl   $0x5494,0x4(%esp)
    2fb6:	00 
    2fb7:	89 04 24             	mov    %eax,(%esp)
    2fba:	e8 d6 0d 00 00       	call   3d95 <printf>
    2fbf:	e8 58 0c 00 00       	call   3c1c <exit>
    2fc4:	c7 45 e4 ff ff 3f 06 	movl   $0x63fffff,-0x1c(%ebp)
    2fcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2fce:	c6 00 63             	movb   $0x63,(%eax)
    2fd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fd8:	e8 c7 0c 00 00       	call   3ca4 <sbrk>
    2fdd:	89 45 d8             	mov    %eax,-0x28(%ebp)
    2fe0:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    2fe7:	e8 b8 0c 00 00       	call   3ca4 <sbrk>
    2fec:	89 45 e0             	mov    %eax,-0x20(%ebp)
    2fef:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    2ff3:	75 1a                	jne    300f <sbrktest+0x1be>
    2ff5:	a1 3c 58 00 00       	mov    0x583c,%eax
    2ffa:	c7 44 24 04 d2 54 00 	movl   $0x54d2,0x4(%esp)
    3001:	00 
    3002:	89 04 24             	mov    %eax,(%esp)
    3005:	e8 8b 0d 00 00       	call   3d95 <printf>
    300a:	e8 0d 0c 00 00       	call   3c1c <exit>
    300f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3016:	e8 89 0c 00 00       	call   3ca4 <sbrk>
    301b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    301e:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3021:	2d 00 10 00 00       	sub    $0x1000,%eax
    3026:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    3029:	74 28                	je     3053 <sbrktest+0x202>
    302b:	a1 3c 58 00 00       	mov    0x583c,%eax
    3030:	8b 55 e0             	mov    -0x20(%ebp),%edx
    3033:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3037:	8b 55 d8             	mov    -0x28(%ebp),%edx
    303a:	89 54 24 08          	mov    %edx,0x8(%esp)
    303e:	c7 44 24 04 f0 54 00 	movl   $0x54f0,0x4(%esp)
    3045:	00 
    3046:	89 04 24             	mov    %eax,(%esp)
    3049:	e8 47 0d 00 00       	call   3d95 <printf>
    304e:	e8 c9 0b 00 00       	call   3c1c <exit>
    3053:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    305a:	e8 45 0c 00 00       	call   3ca4 <sbrk>
    305f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    3062:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    3069:	e8 36 0c 00 00       	call   3ca4 <sbrk>
    306e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    3071:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3074:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    3077:	75 19                	jne    3092 <sbrktest+0x241>
    3079:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3080:	e8 1f 0c 00 00       	call   3ca4 <sbrk>
    3085:	8b 55 d8             	mov    -0x28(%ebp),%edx
    3088:	81 c2 00 10 00 00    	add    $0x1000,%edx
    308e:	39 d0                	cmp    %edx,%eax
    3090:	74 28                	je     30ba <sbrktest+0x269>
    3092:	a1 3c 58 00 00       	mov    0x583c,%eax
    3097:	8b 55 e0             	mov    -0x20(%ebp),%edx
    309a:	89 54 24 0c          	mov    %edx,0xc(%esp)
    309e:	8b 55 d8             	mov    -0x28(%ebp),%edx
    30a1:	89 54 24 08          	mov    %edx,0x8(%esp)
    30a5:	c7 44 24 04 28 55 00 	movl   $0x5528,0x4(%esp)
    30ac:	00 
    30ad:	89 04 24             	mov    %eax,(%esp)
    30b0:	e8 e0 0c 00 00       	call   3d95 <printf>
    30b5:	e8 62 0b 00 00       	call   3c1c <exit>
    30ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    30bd:	0f b6 00             	movzbl (%eax),%eax
    30c0:	3c 63                	cmp    $0x63,%al
    30c2:	75 1a                	jne    30de <sbrktest+0x28d>
    30c4:	a1 3c 58 00 00       	mov    0x583c,%eax
    30c9:	c7 44 24 04 50 55 00 	movl   $0x5550,0x4(%esp)
    30d0:	00 
    30d1:	89 04 24             	mov    %eax,(%esp)
    30d4:	e8 bc 0c 00 00       	call   3d95 <printf>
    30d9:	e8 3e 0b 00 00       	call   3c1c <exit>
    30de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    30e5:	e8 ba 0b 00 00       	call   3ca4 <sbrk>
    30ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
    30ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
    30f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    30f7:	e8 a8 0b 00 00       	call   3ca4 <sbrk>
    30fc:	89 da                	mov    %ebx,%edx
    30fe:	29 c2                	sub    %eax,%edx
    3100:	89 d0                	mov    %edx,%eax
    3102:	89 04 24             	mov    %eax,(%esp)
    3105:	e8 9a 0b 00 00       	call   3ca4 <sbrk>
    310a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    310d:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3110:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    3113:	74 28                	je     313d <sbrktest+0x2ec>
    3115:	a1 3c 58 00 00       	mov    0x583c,%eax
    311a:	8b 55 e0             	mov    -0x20(%ebp),%edx
    311d:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3121:	8b 55 d8             	mov    -0x28(%ebp),%edx
    3124:	89 54 24 08          	mov    %edx,0x8(%esp)
    3128:	c7 44 24 04 80 55 00 	movl   $0x5580,0x4(%esp)
    312f:	00 
    3130:	89 04 24             	mov    %eax,(%esp)
    3133:	e8 5d 0c 00 00       	call   3d95 <printf>
    3138:	e8 df 0a 00 00       	call   3c1c <exit>
    313d:	c7 45 d8 00 00 00 80 	movl   $0x80000000,-0x28(%ebp)
    3144:	eb 7b                	jmp    31c1 <sbrktest+0x370>
    3146:	e8 51 0b 00 00       	call   3c9c <getpid>
    314b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    314e:	e8 c1 0a 00 00       	call   3c14 <fork>
    3153:	89 45 d0             	mov    %eax,-0x30(%ebp)
    3156:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    315a:	79 1a                	jns    3176 <sbrktest+0x325>
    315c:	a1 3c 58 00 00       	mov    0x583c,%eax
    3161:	c7 44 24 04 49 45 00 	movl   $0x4549,0x4(%esp)
    3168:	00 
    3169:	89 04 24             	mov    %eax,(%esp)
    316c:	e8 24 0c 00 00       	call   3d95 <printf>
    3171:	e8 a6 0a 00 00       	call   3c1c <exit>
    3176:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    317a:	75 39                	jne    31b5 <sbrktest+0x364>
    317c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    317f:	0f b6 00             	movzbl (%eax),%eax
    3182:	0f be d0             	movsbl %al,%edx
    3185:	a1 3c 58 00 00       	mov    0x583c,%eax
    318a:	89 54 24 0c          	mov    %edx,0xc(%esp)
    318e:	8b 55 d8             	mov    -0x28(%ebp),%edx
    3191:	89 54 24 08          	mov    %edx,0x8(%esp)
    3195:	c7 44 24 04 a1 55 00 	movl   $0x55a1,0x4(%esp)
    319c:	00 
    319d:	89 04 24             	mov    %eax,(%esp)
    31a0:	e8 f0 0b 00 00       	call   3d95 <printf>
    31a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    31a8:	89 04 24             	mov    %eax,(%esp)
    31ab:	e8 9c 0a 00 00       	call   3c4c <kill>
    31b0:	e8 67 0a 00 00       	call   3c1c <exit>
    31b5:	e8 6a 0a 00 00       	call   3c24 <wait>
    31ba:	81 45 d8 50 c3 00 00 	addl   $0xc350,-0x28(%ebp)
    31c1:	81 7d d8 7f 84 1e 80 	cmpl   $0x801e847f,-0x28(%ebp)
    31c8:	0f 86 78 ff ff ff    	jbe    3146 <sbrktest+0x2f5>
    31ce:	8d 45 c8             	lea    -0x38(%ebp),%eax
    31d1:	89 04 24             	mov    %eax,(%esp)
    31d4:	e8 53 0a 00 00       	call   3c2c <pipe>
    31d9:	85 c0                	test   %eax,%eax
    31db:	74 19                	je     31f6 <sbrktest+0x3a5>
    31dd:	c7 44 24 04 9d 44 00 	movl   $0x449d,0x4(%esp)
    31e4:	00 
    31e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31ec:	e8 a4 0b 00 00       	call   3d95 <printf>
    31f1:	e8 26 0a 00 00       	call   3c1c <exit>
    31f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    31fd:	e9 86 00 00 00       	jmp    3288 <sbrktest+0x437>
    3202:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3205:	e8 0a 0a 00 00       	call   3c14 <fork>
    320a:	89 44 9d a0          	mov    %eax,-0x60(%ebp,%ebx,4)
    320e:	8b 44 9d a0          	mov    -0x60(%ebp,%ebx,4),%eax
    3212:	85 c0                	test   %eax,%eax
    3214:	75 48                	jne    325e <sbrktest+0x40d>
    3216:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    321d:	e8 82 0a 00 00       	call   3ca4 <sbrk>
    3222:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3227:	89 d1                	mov    %edx,%ecx
    3229:	29 c1                	sub    %eax,%ecx
    322b:	89 c8                	mov    %ecx,%eax
    322d:	89 04 24             	mov    %eax,(%esp)
    3230:	e8 6f 0a 00 00       	call   3ca4 <sbrk>
    3235:	8b 45 cc             	mov    -0x34(%ebp),%eax
    3238:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    323f:	00 
    3240:	c7 44 24 04 02 45 00 	movl   $0x4502,0x4(%esp)
    3247:	00 
    3248:	89 04 24             	mov    %eax,(%esp)
    324b:	e8 ec 09 00 00       	call   3c3c <write>
    3250:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    3257:	e8 50 0a 00 00       	call   3cac <sleep>
    325c:	eb f2                	jmp    3250 <sbrktest+0x3ff>
    325e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3261:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3265:	83 f8 ff             	cmp    $0xffffffff,%eax
    3268:	74 1a                	je     3284 <sbrktest+0x433>
    326a:	8b 45 c8             	mov    -0x38(%ebp),%eax
    326d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3274:	00 
    3275:	8d 55 9f             	lea    -0x61(%ebp),%edx
    3278:	89 54 24 04          	mov    %edx,0x4(%esp)
    327c:	89 04 24             	mov    %eax,(%esp)
    327f:	e8 b0 09 00 00       	call   3c34 <read>
    3284:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3288:	8b 45 f4             	mov    -0xc(%ebp),%eax
    328b:	83 f8 09             	cmp    $0x9,%eax
    328e:	0f 86 6e ff ff ff    	jbe    3202 <sbrktest+0x3b1>
    3294:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    329b:	e8 04 0a 00 00       	call   3ca4 <sbrk>
    32a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    32a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    32aa:	eb 27                	jmp    32d3 <sbrktest+0x482>
    32ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32af:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    32b3:	83 f8 ff             	cmp    $0xffffffff,%eax
    32b6:	74 16                	je     32ce <sbrktest+0x47d>
    32b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32bb:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    32bf:	89 04 24             	mov    %eax,(%esp)
    32c2:	e8 85 09 00 00       	call   3c4c <kill>
    32c7:	e8 58 09 00 00       	call   3c24 <wait>
    32cc:	eb 01                	jmp    32cf <sbrktest+0x47e>
    32ce:	90                   	nop
    32cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    32d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32d6:	83 f8 09             	cmp    $0x9,%eax
    32d9:	76 d1                	jbe    32ac <sbrktest+0x45b>
    32db:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    32df:	75 1a                	jne    32fb <sbrktest+0x4aa>
    32e1:	a1 3c 58 00 00       	mov    0x583c,%eax
    32e6:	c7 44 24 04 ba 55 00 	movl   $0x55ba,0x4(%esp)
    32ed:	00 
    32ee:	89 04 24             	mov    %eax,(%esp)
    32f1:	e8 9f 0a 00 00       	call   3d95 <printf>
    32f6:	e8 21 09 00 00       	call   3c1c <exit>
    32fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3302:	e8 9d 09 00 00       	call   3ca4 <sbrk>
    3307:	3b 45 e8             	cmp    -0x18(%ebp),%eax
    330a:	76 1d                	jbe    3329 <sbrktest+0x4d8>
    330c:	8b 5d e8             	mov    -0x18(%ebp),%ebx
    330f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3316:	e8 89 09 00 00       	call   3ca4 <sbrk>
    331b:	89 da                	mov    %ebx,%edx
    331d:	29 c2                	sub    %eax,%edx
    331f:	89 d0                	mov    %edx,%eax
    3321:	89 04 24             	mov    %eax,(%esp)
    3324:	e8 7b 09 00 00       	call   3ca4 <sbrk>
    3329:	a1 3c 58 00 00       	mov    0x583c,%eax
    332e:	c7 44 24 04 d5 55 00 	movl   $0x55d5,0x4(%esp)
    3335:	00 
    3336:	89 04 24             	mov    %eax,(%esp)
    3339:	e8 57 0a 00 00       	call   3d95 <printf>
    333e:	81 c4 84 00 00 00    	add    $0x84,%esp
    3344:	5b                   	pop    %ebx
    3345:	5d                   	pop    %ebp
    3346:	c3                   	ret    

00003347 <validateint>:
    3347:	55                   	push   %ebp
    3348:	89 e5                	mov    %esp,%ebp
    334a:	53                   	push   %ebx
    334b:	83 ec 10             	sub    $0x10,%esp
    334e:	b8 0d 00 00 00       	mov    $0xd,%eax
    3353:	8b 55 08             	mov    0x8(%ebp),%edx
    3356:	89 d1                	mov    %edx,%ecx
    3358:	89 e3                	mov    %esp,%ebx
    335a:	89 cc                	mov    %ecx,%esp
    335c:	cd 40                	int    $0x40
    335e:	89 dc                	mov    %ebx,%esp
    3360:	89 45 f8             	mov    %eax,-0x8(%ebp)
    3363:	83 c4 10             	add    $0x10,%esp
    3366:	5b                   	pop    %ebx
    3367:	5d                   	pop    %ebp
    3368:	c3                   	ret    

00003369 <validatetest>:
    3369:	55                   	push   %ebp
    336a:	89 e5                	mov    %esp,%ebp
    336c:	83 ec 28             	sub    $0x28,%esp
    336f:	a1 3c 58 00 00       	mov    0x583c,%eax
    3374:	c7 44 24 04 e3 55 00 	movl   $0x55e3,0x4(%esp)
    337b:	00 
    337c:	89 04 24             	mov    %eax,(%esp)
    337f:	e8 11 0a 00 00       	call   3d95 <printf>
    3384:	c7 45 ec 00 30 11 00 	movl   $0x113000,-0x14(%ebp)
    338b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3392:	eb 7f                	jmp    3413 <validatetest+0xaa>
    3394:	e8 7b 08 00 00       	call   3c14 <fork>
    3399:	89 45 f0             	mov    %eax,-0x10(%ebp)
    339c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    33a0:	75 10                	jne    33b2 <validatetest+0x49>
    33a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    33a5:	89 04 24             	mov    %eax,(%esp)
    33a8:	e8 9a ff ff ff       	call   3347 <validateint>
    33ad:	e8 6a 08 00 00       	call   3c1c <exit>
    33b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33b9:	e8 ee 08 00 00       	call   3cac <sleep>
    33be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    33c5:	e8 e2 08 00 00       	call   3cac <sleep>
    33ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
    33cd:	89 04 24             	mov    %eax,(%esp)
    33d0:	e8 77 08 00 00       	call   3c4c <kill>
    33d5:	e8 4a 08 00 00       	call   3c24 <wait>
    33da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    33dd:	89 44 24 04          	mov    %eax,0x4(%esp)
    33e1:	c7 04 24 f2 55 00 00 	movl   $0x55f2,(%esp)
    33e8:	e8 8f 08 00 00       	call   3c7c <link>
    33ed:	83 f8 ff             	cmp    $0xffffffff,%eax
    33f0:	74 1a                	je     340c <validatetest+0xa3>
    33f2:	a1 3c 58 00 00       	mov    0x583c,%eax
    33f7:	c7 44 24 04 fd 55 00 	movl   $0x55fd,0x4(%esp)
    33fe:	00 
    33ff:	89 04 24             	mov    %eax,(%esp)
    3402:	e8 8e 09 00 00       	call   3d95 <printf>
    3407:	e8 10 08 00 00       	call   3c1c <exit>
    340c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    3413:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3416:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3419:	0f 83 75 ff ff ff    	jae    3394 <validatetest+0x2b>
    341f:	a1 3c 58 00 00       	mov    0x583c,%eax
    3424:	c7 44 24 04 16 56 00 	movl   $0x5616,0x4(%esp)
    342b:	00 
    342c:	89 04 24             	mov    %eax,(%esp)
    342f:	e8 61 09 00 00       	call   3d95 <printf>
    3434:	c9                   	leave  
    3435:	c3                   	ret    

00003436 <bsstest>:
    3436:	55                   	push   %ebp
    3437:	89 e5                	mov    %esp,%ebp
    3439:	83 ec 28             	sub    $0x28,%esp
    343c:	a1 3c 58 00 00       	mov    0x583c,%eax
    3441:	c7 44 24 04 23 56 00 	movl   $0x5623,0x4(%esp)
    3448:	00 
    3449:	89 04 24             	mov    %eax,(%esp)
    344c:	e8 44 09 00 00       	call   3d95 <printf>
    3451:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3458:	eb 2c                	jmp    3486 <bsstest+0x50>
    345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    345d:	0f b6 80 00 59 00 00 	movzbl 0x5900(%eax),%eax
    3464:	84 c0                	test   %al,%al
    3466:	74 1a                	je     3482 <bsstest+0x4c>
    3468:	a1 3c 58 00 00       	mov    0x583c,%eax
    346d:	c7 44 24 04 2d 56 00 	movl   $0x562d,0x4(%esp)
    3474:	00 
    3475:	89 04 24             	mov    %eax,(%esp)
    3478:	e8 18 09 00 00       	call   3d95 <printf>
    347d:	e8 9a 07 00 00       	call   3c1c <exit>
    3482:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3486:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3489:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    348e:	76 ca                	jbe    345a <bsstest+0x24>
    3490:	a1 3c 58 00 00       	mov    0x583c,%eax
    3495:	c7 44 24 04 3e 56 00 	movl   $0x563e,0x4(%esp)
    349c:	00 
    349d:	89 04 24             	mov    %eax,(%esp)
    34a0:	e8 f0 08 00 00       	call   3d95 <printf>
    34a5:	c9                   	leave  
    34a6:	c3                   	ret    

000034a7 <bigargtest>:
    34a7:	55                   	push   %ebp
    34a8:	89 e5                	mov    %esp,%ebp
    34aa:	83 ec 28             	sub    $0x28,%esp
    34ad:	c7 04 24 4b 56 00 00 	movl   $0x564b,(%esp)
    34b4:	e8 b3 07 00 00       	call   3c6c <unlink>
    34b9:	e8 56 07 00 00       	call   3c14 <fork>
    34be:	89 45 ec             	mov    %eax,-0x14(%ebp)
    34c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    34c5:	0f 85 90 00 00 00    	jne    355b <bigargtest+0xb4>
    34cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    34d2:	eb 12                	jmp    34e6 <bigargtest+0x3f>
    34d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34d7:	c7 04 85 60 58 00 00 	movl   $0x5658,0x5860(,%eax,4)
    34de:	58 56 00 00 
    34e2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    34e6:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    34ea:	7e e8                	jle    34d4 <bigargtest+0x2d>
    34ec:	c7 05 dc 58 00 00 00 	movl   $0x0,0x58dc
    34f3:	00 00 00 
    34f6:	a1 3c 58 00 00       	mov    0x583c,%eax
    34fb:	c7 44 24 04 35 57 00 	movl   $0x5735,0x4(%esp)
    3502:	00 
    3503:	89 04 24             	mov    %eax,(%esp)
    3506:	e8 8a 08 00 00       	call   3d95 <printf>
    350b:	c7 44 24 04 60 58 00 	movl   $0x5860,0x4(%esp)
    3512:	00 
    3513:	c7 04 24 5c 41 00 00 	movl   $0x415c,(%esp)
    351a:	e8 35 07 00 00       	call   3c54 <exec>
    351f:	a1 3c 58 00 00       	mov    0x583c,%eax
    3524:	c7 44 24 04 42 57 00 	movl   $0x5742,0x4(%esp)
    352b:	00 
    352c:	89 04 24             	mov    %eax,(%esp)
    352f:	e8 61 08 00 00       	call   3d95 <printf>
    3534:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    353b:	00 
    353c:	c7 04 24 4b 56 00 00 	movl   $0x564b,(%esp)
    3543:	e8 14 07 00 00       	call   3c5c <open>
    3548:	89 45 f0             	mov    %eax,-0x10(%ebp)
    354b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    354e:	89 04 24             	mov    %eax,(%esp)
    3551:	e8 ee 06 00 00       	call   3c44 <close>
    3556:	e8 c1 06 00 00       	call   3c1c <exit>
    355b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    355f:	79 1a                	jns    357b <bigargtest+0xd4>
    3561:	a1 3c 58 00 00       	mov    0x583c,%eax
    3566:	c7 44 24 04 52 57 00 	movl   $0x5752,0x4(%esp)
    356d:	00 
    356e:	89 04 24             	mov    %eax,(%esp)
    3571:	e8 1f 08 00 00       	call   3d95 <printf>
    3576:	e8 a1 06 00 00       	call   3c1c <exit>
    357b:	e8 a4 06 00 00       	call   3c24 <wait>
    3580:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3587:	00 
    3588:	c7 04 24 4b 56 00 00 	movl   $0x564b,(%esp)
    358f:	e8 c8 06 00 00       	call   3c5c <open>
    3594:	89 45 f0             	mov    %eax,-0x10(%ebp)
    3597:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    359b:	79 1a                	jns    35b7 <bigargtest+0x110>
    359d:	a1 3c 58 00 00       	mov    0x583c,%eax
    35a2:	c7 44 24 04 6b 57 00 	movl   $0x576b,0x4(%esp)
    35a9:	00 
    35aa:	89 04 24             	mov    %eax,(%esp)
    35ad:	e8 e3 07 00 00       	call   3d95 <printf>
    35b2:	e8 65 06 00 00       	call   3c1c <exit>
    35b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    35ba:	89 04 24             	mov    %eax,(%esp)
    35bd:	e8 82 06 00 00       	call   3c44 <close>
    35c2:	c7 04 24 4b 56 00 00 	movl   $0x564b,(%esp)
    35c9:	e8 9e 06 00 00       	call   3c6c <unlink>
    35ce:	c9                   	leave  
    35cf:	c3                   	ret    

000035d0 <fsfull>:
    35d0:	55                   	push   %ebp
    35d1:	89 e5                	mov    %esp,%ebp
    35d3:	53                   	push   %ebx
    35d4:	83 ec 74             	sub    $0x74,%esp
    35d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    35de:	c7 44 24 04 80 57 00 	movl   $0x5780,0x4(%esp)
    35e5:	00 
    35e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    35ed:	e8 a3 07 00 00       	call   3d95 <printf>
    35f2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    35f9:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    35fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    3600:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3605:	89 c8                	mov    %ecx,%eax
    3607:	f7 ea                	imul   %edx
    3609:	c1 fa 06             	sar    $0x6,%edx
    360c:	89 c8                	mov    %ecx,%eax
    360e:	c1 f8 1f             	sar    $0x1f,%eax
    3611:	89 d1                	mov    %edx,%ecx
    3613:	29 c1                	sub    %eax,%ecx
    3615:	89 c8                	mov    %ecx,%eax
    3617:	83 c0 30             	add    $0x30,%eax
    361a:	88 45 a5             	mov    %al,-0x5b(%ebp)
    361d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    3620:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3625:	89 d8                	mov    %ebx,%eax
    3627:	f7 ea                	imul   %edx
    3629:	c1 fa 06             	sar    $0x6,%edx
    362c:	89 d8                	mov    %ebx,%eax
    362e:	c1 f8 1f             	sar    $0x1f,%eax
    3631:	89 d1                	mov    %edx,%ecx
    3633:	29 c1                	sub    %eax,%ecx
    3635:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    363b:	89 d9                	mov    %ebx,%ecx
    363d:	29 c1                	sub    %eax,%ecx
    363f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3644:	89 c8                	mov    %ecx,%eax
    3646:	f7 ea                	imul   %edx
    3648:	c1 fa 05             	sar    $0x5,%edx
    364b:	89 c8                	mov    %ecx,%eax
    364d:	c1 f8 1f             	sar    $0x1f,%eax
    3650:	89 d1                	mov    %edx,%ecx
    3652:	29 c1                	sub    %eax,%ecx
    3654:	89 c8                	mov    %ecx,%eax
    3656:	83 c0 30             	add    $0x30,%eax
    3659:	88 45 a6             	mov    %al,-0x5a(%ebp)
    365c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    365f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3664:	89 d8                	mov    %ebx,%eax
    3666:	f7 ea                	imul   %edx
    3668:	c1 fa 05             	sar    $0x5,%edx
    366b:	89 d8                	mov    %ebx,%eax
    366d:	c1 f8 1f             	sar    $0x1f,%eax
    3670:	89 d1                	mov    %edx,%ecx
    3672:	29 c1                	sub    %eax,%ecx
    3674:	6b c1 64             	imul   $0x64,%ecx,%eax
    3677:	89 d9                	mov    %ebx,%ecx
    3679:	29 c1                	sub    %eax,%ecx
    367b:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3680:	89 c8                	mov    %ecx,%eax
    3682:	f7 ea                	imul   %edx
    3684:	c1 fa 02             	sar    $0x2,%edx
    3687:	89 c8                	mov    %ecx,%eax
    3689:	c1 f8 1f             	sar    $0x1f,%eax
    368c:	89 d1                	mov    %edx,%ecx
    368e:	29 c1                	sub    %eax,%ecx
    3690:	89 c8                	mov    %ecx,%eax
    3692:	83 c0 30             	add    $0x30,%eax
    3695:	88 45 a7             	mov    %al,-0x59(%ebp)
    3698:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    369b:	ba 67 66 66 66       	mov    $0x66666667,%edx
    36a0:	89 c8                	mov    %ecx,%eax
    36a2:	f7 ea                	imul   %edx
    36a4:	c1 fa 02             	sar    $0x2,%edx
    36a7:	89 c8                	mov    %ecx,%eax
    36a9:	c1 f8 1f             	sar    $0x1f,%eax
    36ac:	29 c2                	sub    %eax,%edx
    36ae:	89 d0                	mov    %edx,%eax
    36b0:	c1 e0 02             	shl    $0x2,%eax
    36b3:	01 d0                	add    %edx,%eax
    36b5:	01 c0                	add    %eax,%eax
    36b7:	89 ca                	mov    %ecx,%edx
    36b9:	29 c2                	sub    %eax,%edx
    36bb:	89 d0                	mov    %edx,%eax
    36bd:	83 c0 30             	add    $0x30,%eax
    36c0:	88 45 a8             	mov    %al,-0x58(%ebp)
    36c3:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    36c7:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    36ca:	89 44 24 08          	mov    %eax,0x8(%esp)
    36ce:	c7 44 24 04 8d 57 00 	movl   $0x578d,0x4(%esp)
    36d5:	00 
    36d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    36dd:	e8 b3 06 00 00       	call   3d95 <printf>
    36e2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    36e9:	00 
    36ea:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    36ed:	89 04 24             	mov    %eax,(%esp)
    36f0:	e8 67 05 00 00       	call   3c5c <open>
    36f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    36f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    36fc:	79 1d                	jns    371b <fsfull+0x14b>
    36fe:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3701:	89 44 24 08          	mov    %eax,0x8(%esp)
    3705:	c7 44 24 04 99 57 00 	movl   $0x5799,0x4(%esp)
    370c:	00 
    370d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3714:	e8 7c 06 00 00       	call   3d95 <printf>
    3719:	eb 72                	jmp    378d <fsfull+0x1bd>
    371b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3722:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    3729:	00 
    372a:	c7 44 24 04 20 80 00 	movl   $0x8020,0x4(%esp)
    3731:	00 
    3732:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3735:	89 04 24             	mov    %eax,(%esp)
    3738:	e8 ff 04 00 00       	call   3c3c <write>
    373d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3740:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%ebp)
    3747:	7e 0c                	jle    3755 <fsfull+0x185>
    3749:	8b 45 f4             	mov    -0xc(%ebp),%eax
    374c:	01 45 f0             	add    %eax,-0x10(%ebp)
    374f:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    3753:	eb cd                	jmp    3722 <fsfull+0x152>
    3755:	90                   	nop
    3756:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3759:	89 44 24 08          	mov    %eax,0x8(%esp)
    375d:	c7 44 24 04 a9 57 00 	movl   $0x57a9,0x4(%esp)
    3764:	00 
    3765:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    376c:	e8 24 06 00 00       	call   3d95 <printf>
    3771:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3774:	89 04 24             	mov    %eax,(%esp)
    3777:	e8 c8 04 00 00       	call   3c44 <close>
    377c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3780:	75 02                	jne    3784 <fsfull+0x1b4>
    3782:	eb 09                	jmp    378d <fsfull+0x1bd>
    3784:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    3788:	e9 6c fe ff ff       	jmp    35f9 <fsfull+0x29>
    378d:	e9 dd 00 00 00       	jmp    386f <fsfull+0x29f>
    3792:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    3796:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    3799:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    379e:	89 c8                	mov    %ecx,%eax
    37a0:	f7 ea                	imul   %edx
    37a2:	c1 fa 06             	sar    $0x6,%edx
    37a5:	89 c8                	mov    %ecx,%eax
    37a7:	c1 f8 1f             	sar    $0x1f,%eax
    37aa:	89 d1                	mov    %edx,%ecx
    37ac:	29 c1                	sub    %eax,%ecx
    37ae:	89 c8                	mov    %ecx,%eax
    37b0:	83 c0 30             	add    $0x30,%eax
    37b3:	88 45 a5             	mov    %al,-0x5b(%ebp)
    37b6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    37b9:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    37be:	89 d8                	mov    %ebx,%eax
    37c0:	f7 ea                	imul   %edx
    37c2:	c1 fa 06             	sar    $0x6,%edx
    37c5:	89 d8                	mov    %ebx,%eax
    37c7:	c1 f8 1f             	sar    $0x1f,%eax
    37ca:	89 d1                	mov    %edx,%ecx
    37cc:	29 c1                	sub    %eax,%ecx
    37ce:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    37d4:	89 d9                	mov    %ebx,%ecx
    37d6:	29 c1                	sub    %eax,%ecx
    37d8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    37dd:	89 c8                	mov    %ecx,%eax
    37df:	f7 ea                	imul   %edx
    37e1:	c1 fa 05             	sar    $0x5,%edx
    37e4:	89 c8                	mov    %ecx,%eax
    37e6:	c1 f8 1f             	sar    $0x1f,%eax
    37e9:	89 d1                	mov    %edx,%ecx
    37eb:	29 c1                	sub    %eax,%ecx
    37ed:	89 c8                	mov    %ecx,%eax
    37ef:	83 c0 30             	add    $0x30,%eax
    37f2:	88 45 a6             	mov    %al,-0x5a(%ebp)
    37f5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    37f8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    37fd:	89 d8                	mov    %ebx,%eax
    37ff:	f7 ea                	imul   %edx
    3801:	c1 fa 05             	sar    $0x5,%edx
    3804:	89 d8                	mov    %ebx,%eax
    3806:	c1 f8 1f             	sar    $0x1f,%eax
    3809:	89 d1                	mov    %edx,%ecx
    380b:	29 c1                	sub    %eax,%ecx
    380d:	6b c1 64             	imul   $0x64,%ecx,%eax
    3810:	89 d9                	mov    %ebx,%ecx
    3812:	29 c1                	sub    %eax,%ecx
    3814:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3819:	89 c8                	mov    %ecx,%eax
    381b:	f7 ea                	imul   %edx
    381d:	c1 fa 02             	sar    $0x2,%edx
    3820:	89 c8                	mov    %ecx,%eax
    3822:	c1 f8 1f             	sar    $0x1f,%eax
    3825:	89 d1                	mov    %edx,%ecx
    3827:	29 c1                	sub    %eax,%ecx
    3829:	89 c8                	mov    %ecx,%eax
    382b:	83 c0 30             	add    $0x30,%eax
    382e:	88 45 a7             	mov    %al,-0x59(%ebp)
    3831:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    3834:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3839:	89 c8                	mov    %ecx,%eax
    383b:	f7 ea                	imul   %edx
    383d:	c1 fa 02             	sar    $0x2,%edx
    3840:	89 c8                	mov    %ecx,%eax
    3842:	c1 f8 1f             	sar    $0x1f,%eax
    3845:	29 c2                	sub    %eax,%edx
    3847:	89 d0                	mov    %edx,%eax
    3849:	c1 e0 02             	shl    $0x2,%eax
    384c:	01 d0                	add    %edx,%eax
    384e:	01 c0                	add    %eax,%eax
    3850:	89 ca                	mov    %ecx,%edx
    3852:	29 c2                	sub    %eax,%edx
    3854:	89 d0                	mov    %edx,%eax
    3856:	83 c0 30             	add    $0x30,%eax
    3859:	88 45 a8             	mov    %al,-0x58(%ebp)
    385c:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    3860:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3863:	89 04 24             	mov    %eax,(%esp)
    3866:	e8 01 04 00 00       	call   3c6c <unlink>
    386b:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
    386f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3873:	0f 89 19 ff ff ff    	jns    3792 <fsfull+0x1c2>
    3879:	c7 44 24 04 b9 57 00 	movl   $0x57b9,0x4(%esp)
    3880:	00 
    3881:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3888:	e8 08 05 00 00       	call   3d95 <printf>
    388d:	83 c4 74             	add    $0x74,%esp
    3890:	5b                   	pop    %ebx
    3891:	5d                   	pop    %ebp
    3892:	c3                   	ret    

00003893 <rand>:
    3893:	55                   	push   %ebp
    3894:	89 e5                	mov    %esp,%ebp
    3896:	a1 40 58 00 00       	mov    0x5840,%eax
    389b:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    38a1:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    38a6:	a3 40 58 00 00       	mov    %eax,0x5840
    38ab:	a1 40 58 00 00       	mov    0x5840,%eax
    38b0:	5d                   	pop    %ebp
    38b1:	c3                   	ret    

000038b2 <main>:
    38b2:	55                   	push   %ebp
    38b3:	89 e5                	mov    %esp,%ebp
    38b5:	83 e4 f0             	and    $0xfffffff0,%esp
    38b8:	83 ec 10             	sub    $0x10,%esp
    38bb:	c7 44 24 04 cf 57 00 	movl   $0x57cf,0x4(%esp)
    38c2:	00 
    38c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38ca:	e8 c6 04 00 00       	call   3d95 <printf>
    38cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    38d6:	00 
    38d7:	c7 04 24 e3 57 00 00 	movl   $0x57e3,(%esp)
    38de:	e8 79 03 00 00       	call   3c5c <open>
    38e3:	85 c0                	test   %eax,%eax
    38e5:	78 19                	js     3900 <main+0x4e>
    38e7:	c7 44 24 04 f4 57 00 	movl   $0x57f4,0x4(%esp)
    38ee:	00 
    38ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38f6:	e8 9a 04 00 00       	call   3d95 <printf>
    38fb:	e8 1c 03 00 00       	call   3c1c <exit>
    3900:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3907:	00 
    3908:	c7 04 24 e3 57 00 00 	movl   $0x57e3,(%esp)
    390f:	e8 48 03 00 00       	call   3c5c <open>
    3914:	89 04 24             	mov    %eax,(%esp)
    3917:	e8 28 03 00 00       	call   3c44 <close>
    391c:	e8 86 fb ff ff       	call   34a7 <bigargtest>
    3921:	e8 f1 ea ff ff       	call   2417 <bigwrite>
    3926:	e8 7c fb ff ff       	call   34a7 <bigargtest>
    392b:	e8 06 fb ff ff       	call   3436 <bsstest>
    3930:	e8 1c f5 ff ff       	call   2e51 <sbrktest>
    3935:	e8 2f fa ff ff       	call   3369 <validatetest>
    393a:	e8 c1 c6 ff ff       	call   0 <opentest>
    393f:	e8 67 c7 ff ff       	call   ab <writetest>
    3944:	e8 77 c9 ff ff       	call   2c0 <writetest1>
    3949:	e8 7b cb ff ff       	call   4c9 <createtest>
    394e:	e8 19 d1 ff ff       	call   a6c <mem>
    3953:	e8 52 cd ff ff       	call   6aa <pipe1>
    3958:	e8 38 cf ff ff       	call   895 <preempt>
    395d:	e8 8c d0 ff ff       	call   9ee <exitwait>
    3962:	e8 39 ef ff ff       	call   28a0 <rmdot>
    3967:	e8 de ed ff ff       	call   274a <fourteen>
    396c:	e8 ae eb ff ff       	call   251f <bigfile>
    3971:	e8 5b e3 ff ff       	call   1cd1 <subdir>
    3976:	e8 06 dd ff ff       	call   1681 <concreate>
    397b:	e8 b0 e0 ff ff       	call   1a30 <linkunlink>
    3980:	e8 b3 da ff ff       	call   1438 <linktest>
    3985:	e8 d9 d8 ff ff       	call   1263 <unlinkread>
    398a:	e8 22 d6 ff ff       	call   fb1 <createdelete>
    398f:	e8 b6 d3 ff ff       	call   d4a <twofiles>
    3994:	e8 b8 d1 ff ff       	call   b51 <sharedfd>
    3999:	e8 7a f0 ff ff       	call   2a18 <dirfile>
    399e:	e8 b7 f2 ff ff       	call   2c5a <iref>
    39a3:	e8 d6 f3 ff ff       	call   2d7e <forktest>
    39a8:	e8 af e1 ff ff       	call   1b5c <bigdir>
    39ad:	e8 a9 cc ff ff       	call   65b <exectest>
    39b2:	e8 65 02 00 00       	call   3c1c <exit>
    39b7:	90                   	nop

000039b8 <stosb>:
    39b8:	55                   	push   %ebp
    39b9:	89 e5                	mov    %esp,%ebp
    39bb:	57                   	push   %edi
    39bc:	53                   	push   %ebx
    39bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
    39c0:	8b 55 10             	mov    0x10(%ebp),%edx
    39c3:	8b 45 0c             	mov    0xc(%ebp),%eax
    39c6:	89 cb                	mov    %ecx,%ebx
    39c8:	89 df                	mov    %ebx,%edi
    39ca:	89 d1                	mov    %edx,%ecx
    39cc:	fc                   	cld    
    39cd:	f3 aa                	rep stos %al,%es:(%edi)
    39cf:	89 ca                	mov    %ecx,%edx
    39d1:	89 fb                	mov    %edi,%ebx
    39d3:	89 5d 08             	mov    %ebx,0x8(%ebp)
    39d6:	89 55 10             	mov    %edx,0x10(%ebp)
    39d9:	5b                   	pop    %ebx
    39da:	5f                   	pop    %edi
    39db:	5d                   	pop    %ebp
    39dc:	c3                   	ret    

000039dd <strcpy>:
    39dd:	55                   	push   %ebp
    39de:	89 e5                	mov    %esp,%ebp
    39e0:	83 ec 10             	sub    $0x10,%esp
    39e3:	8b 45 08             	mov    0x8(%ebp),%eax
    39e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    39e9:	8b 45 0c             	mov    0xc(%ebp),%eax
    39ec:	0f b6 10             	movzbl (%eax),%edx
    39ef:	8b 45 08             	mov    0x8(%ebp),%eax
    39f2:	88 10                	mov    %dl,(%eax)
    39f4:	8b 45 08             	mov    0x8(%ebp),%eax
    39f7:	0f b6 00             	movzbl (%eax),%eax
    39fa:	84 c0                	test   %al,%al
    39fc:	0f 95 c0             	setne  %al
    39ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3a03:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    3a07:	84 c0                	test   %al,%al
    3a09:	75 de                	jne    39e9 <strcpy+0xc>
    3a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3a0e:	c9                   	leave  
    3a0f:	c3                   	ret    

00003a10 <strcmp>:
    3a10:	55                   	push   %ebp
    3a11:	89 e5                	mov    %esp,%ebp
    3a13:	eb 08                	jmp    3a1d <strcmp+0xd>
    3a15:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3a19:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    3a1d:	8b 45 08             	mov    0x8(%ebp),%eax
    3a20:	0f b6 00             	movzbl (%eax),%eax
    3a23:	84 c0                	test   %al,%al
    3a25:	74 10                	je     3a37 <strcmp+0x27>
    3a27:	8b 45 08             	mov    0x8(%ebp),%eax
    3a2a:	0f b6 10             	movzbl (%eax),%edx
    3a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a30:	0f b6 00             	movzbl (%eax),%eax
    3a33:	38 c2                	cmp    %al,%dl
    3a35:	74 de                	je     3a15 <strcmp+0x5>
    3a37:	8b 45 08             	mov    0x8(%ebp),%eax
    3a3a:	0f b6 00             	movzbl (%eax),%eax
    3a3d:	0f b6 d0             	movzbl %al,%edx
    3a40:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a43:	0f b6 00             	movzbl (%eax),%eax
    3a46:	0f b6 c0             	movzbl %al,%eax
    3a49:	89 d1                	mov    %edx,%ecx
    3a4b:	29 c1                	sub    %eax,%ecx
    3a4d:	89 c8                	mov    %ecx,%eax
    3a4f:	5d                   	pop    %ebp
    3a50:	c3                   	ret    

00003a51 <strlen>:
    3a51:	55                   	push   %ebp
    3a52:	89 e5                	mov    %esp,%ebp
    3a54:	83 ec 10             	sub    $0x10,%esp
    3a57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3a5e:	eb 04                	jmp    3a64 <strlen+0x13>
    3a60:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3a67:	03 45 08             	add    0x8(%ebp),%eax
    3a6a:	0f b6 00             	movzbl (%eax),%eax
    3a6d:	84 c0                	test   %al,%al
    3a6f:	75 ef                	jne    3a60 <strlen+0xf>
    3a71:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3a74:	c9                   	leave  
    3a75:	c3                   	ret    

00003a76 <memset>:
    3a76:	55                   	push   %ebp
    3a77:	89 e5                	mov    %esp,%ebp
    3a79:	83 ec 0c             	sub    $0xc,%esp
    3a7c:	8b 45 10             	mov    0x10(%ebp),%eax
    3a7f:	89 44 24 08          	mov    %eax,0x8(%esp)
    3a83:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a86:	89 44 24 04          	mov    %eax,0x4(%esp)
    3a8a:	8b 45 08             	mov    0x8(%ebp),%eax
    3a8d:	89 04 24             	mov    %eax,(%esp)
    3a90:	e8 23 ff ff ff       	call   39b8 <stosb>
    3a95:	8b 45 08             	mov    0x8(%ebp),%eax
    3a98:	c9                   	leave  
    3a99:	c3                   	ret    

00003a9a <strchr>:
    3a9a:	55                   	push   %ebp
    3a9b:	89 e5                	mov    %esp,%ebp
    3a9d:	83 ec 04             	sub    $0x4,%esp
    3aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
    3aa3:	88 45 fc             	mov    %al,-0x4(%ebp)
    3aa6:	eb 14                	jmp    3abc <strchr+0x22>
    3aa8:	8b 45 08             	mov    0x8(%ebp),%eax
    3aab:	0f b6 00             	movzbl (%eax),%eax
    3aae:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3ab1:	75 05                	jne    3ab8 <strchr+0x1e>
    3ab3:	8b 45 08             	mov    0x8(%ebp),%eax
    3ab6:	eb 13                	jmp    3acb <strchr+0x31>
    3ab8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3abc:	8b 45 08             	mov    0x8(%ebp),%eax
    3abf:	0f b6 00             	movzbl (%eax),%eax
    3ac2:	84 c0                	test   %al,%al
    3ac4:	75 e2                	jne    3aa8 <strchr+0xe>
    3ac6:	b8 00 00 00 00       	mov    $0x0,%eax
    3acb:	c9                   	leave  
    3acc:	c3                   	ret    

00003acd <gets>:
    3acd:	55                   	push   %ebp
    3ace:	89 e5                	mov    %esp,%ebp
    3ad0:	83 ec 28             	sub    $0x28,%esp
    3ad3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3ada:	eb 44                	jmp    3b20 <gets+0x53>
    3adc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3ae3:	00 
    3ae4:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
    3aeb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3af2:	e8 3d 01 00 00       	call   3c34 <read>
    3af7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3afe:	7e 2d                	jle    3b2d <gets+0x60>
    3b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3b03:	03 45 08             	add    0x8(%ebp),%eax
    3b06:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
    3b0a:	88 10                	mov    %dl,(%eax)
    3b0c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3b10:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3b14:	3c 0a                	cmp    $0xa,%al
    3b16:	74 16                	je     3b2e <gets+0x61>
    3b18:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3b1c:	3c 0d                	cmp    $0xd,%al
    3b1e:	74 0e                	je     3b2e <gets+0x61>
    3b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3b23:	83 c0 01             	add    $0x1,%eax
    3b26:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3b29:	7c b1                	jl     3adc <gets+0xf>
    3b2b:	eb 01                	jmp    3b2e <gets+0x61>
    3b2d:	90                   	nop
    3b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3b31:	03 45 08             	add    0x8(%ebp),%eax
    3b34:	c6 00 00             	movb   $0x0,(%eax)
    3b37:	8b 45 08             	mov    0x8(%ebp),%eax
    3b3a:	c9                   	leave  
    3b3b:	c3                   	ret    

00003b3c <stat>:
    3b3c:	55                   	push   %ebp
    3b3d:	89 e5                	mov    %esp,%ebp
    3b3f:	83 ec 28             	sub    $0x28,%esp
    3b42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3b49:	00 
    3b4a:	8b 45 08             	mov    0x8(%ebp),%eax
    3b4d:	89 04 24             	mov    %eax,(%esp)
    3b50:	e8 07 01 00 00       	call   3c5c <open>
    3b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
    3b58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3b5c:	79 07                	jns    3b65 <stat+0x29>
    3b5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3b63:	eb 23                	jmp    3b88 <stat+0x4c>
    3b65:	8b 45 0c             	mov    0xc(%ebp),%eax
    3b68:	89 44 24 04          	mov    %eax,0x4(%esp)
    3b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3b6f:	89 04 24             	mov    %eax,(%esp)
    3b72:	e8 fd 00 00 00       	call   3c74 <fstat>
    3b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3b7d:	89 04 24             	mov    %eax,(%esp)
    3b80:	e8 bf 00 00 00       	call   3c44 <close>
    3b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b88:	c9                   	leave  
    3b89:	c3                   	ret    

00003b8a <atoi>:
    3b8a:	55                   	push   %ebp
    3b8b:	89 e5                	mov    %esp,%ebp
    3b8d:	83 ec 10             	sub    $0x10,%esp
    3b90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3b97:	eb 24                	jmp    3bbd <atoi+0x33>
    3b99:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3b9c:	89 d0                	mov    %edx,%eax
    3b9e:	c1 e0 02             	shl    $0x2,%eax
    3ba1:	01 d0                	add    %edx,%eax
    3ba3:	01 c0                	add    %eax,%eax
    3ba5:	89 c2                	mov    %eax,%edx
    3ba7:	8b 45 08             	mov    0x8(%ebp),%eax
    3baa:	0f b6 00             	movzbl (%eax),%eax
    3bad:	0f be c0             	movsbl %al,%eax
    3bb0:	8d 04 02             	lea    (%edx,%eax,1),%eax
    3bb3:	83 e8 30             	sub    $0x30,%eax
    3bb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3bb9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3bbd:	8b 45 08             	mov    0x8(%ebp),%eax
    3bc0:	0f b6 00             	movzbl (%eax),%eax
    3bc3:	3c 2f                	cmp    $0x2f,%al
    3bc5:	7e 0a                	jle    3bd1 <atoi+0x47>
    3bc7:	8b 45 08             	mov    0x8(%ebp),%eax
    3bca:	0f b6 00             	movzbl (%eax),%eax
    3bcd:	3c 39                	cmp    $0x39,%al
    3bcf:	7e c8                	jle    3b99 <atoi+0xf>
    3bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3bd4:	c9                   	leave  
    3bd5:	c3                   	ret    

00003bd6 <memmove>:
    3bd6:	55                   	push   %ebp
    3bd7:	89 e5                	mov    %esp,%ebp
    3bd9:	83 ec 10             	sub    $0x10,%esp
    3bdc:	8b 45 08             	mov    0x8(%ebp),%eax
    3bdf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    3be2:	8b 45 0c             	mov    0xc(%ebp),%eax
    3be5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3be8:	eb 13                	jmp    3bfd <memmove+0x27>
    3bea:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3bed:	0f b6 10             	movzbl (%eax),%edx
    3bf0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3bf3:	88 10                	mov    %dl,(%eax)
    3bf5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    3bf9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3bfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    3c01:	0f 9f c0             	setg   %al
    3c04:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    3c08:	84 c0                	test   %al,%al
    3c0a:	75 de                	jne    3bea <memmove+0x14>
    3c0c:	8b 45 08             	mov    0x8(%ebp),%eax
    3c0f:	c9                   	leave  
    3c10:	c3                   	ret    
    3c11:	66 90                	xchg   %ax,%ax
    3c13:	90                   	nop

00003c14 <fork>:
    3c14:	b8 01 00 00 00       	mov    $0x1,%eax
    3c19:	cd 40                	int    $0x40
    3c1b:	c3                   	ret    

00003c1c <exit>:
    3c1c:	b8 02 00 00 00       	mov    $0x2,%eax
    3c21:	cd 40                	int    $0x40
    3c23:	c3                   	ret    

00003c24 <wait>:
    3c24:	b8 03 00 00 00       	mov    $0x3,%eax
    3c29:	cd 40                	int    $0x40
    3c2b:	c3                   	ret    

00003c2c <pipe>:
    3c2c:	b8 04 00 00 00       	mov    $0x4,%eax
    3c31:	cd 40                	int    $0x40
    3c33:	c3                   	ret    

00003c34 <read>:
    3c34:	b8 05 00 00 00       	mov    $0x5,%eax
    3c39:	cd 40                	int    $0x40
    3c3b:	c3                   	ret    

00003c3c <write>:
    3c3c:	b8 10 00 00 00       	mov    $0x10,%eax
    3c41:	cd 40                	int    $0x40
    3c43:	c3                   	ret    

00003c44 <close>:
    3c44:	b8 15 00 00 00       	mov    $0x15,%eax
    3c49:	cd 40                	int    $0x40
    3c4b:	c3                   	ret    

00003c4c <kill>:
    3c4c:	b8 06 00 00 00       	mov    $0x6,%eax
    3c51:	cd 40                	int    $0x40
    3c53:	c3                   	ret    

00003c54 <exec>:
    3c54:	b8 07 00 00 00       	mov    $0x7,%eax
    3c59:	cd 40                	int    $0x40
    3c5b:	c3                   	ret    

00003c5c <open>:
    3c5c:	b8 0f 00 00 00       	mov    $0xf,%eax
    3c61:	cd 40                	int    $0x40
    3c63:	c3                   	ret    

00003c64 <mknod>:
    3c64:	b8 11 00 00 00       	mov    $0x11,%eax
    3c69:	cd 40                	int    $0x40
    3c6b:	c3                   	ret    

00003c6c <unlink>:
    3c6c:	b8 12 00 00 00       	mov    $0x12,%eax
    3c71:	cd 40                	int    $0x40
    3c73:	c3                   	ret    

00003c74 <fstat>:
    3c74:	b8 08 00 00 00       	mov    $0x8,%eax
    3c79:	cd 40                	int    $0x40
    3c7b:	c3                   	ret    

00003c7c <link>:
    3c7c:	b8 13 00 00 00       	mov    $0x13,%eax
    3c81:	cd 40                	int    $0x40
    3c83:	c3                   	ret    

00003c84 <mkdir>:
    3c84:	b8 14 00 00 00       	mov    $0x14,%eax
    3c89:	cd 40                	int    $0x40
    3c8b:	c3                   	ret    

00003c8c <chdir>:
    3c8c:	b8 09 00 00 00       	mov    $0x9,%eax
    3c91:	cd 40                	int    $0x40
    3c93:	c3                   	ret    

00003c94 <dup>:
    3c94:	b8 0a 00 00 00       	mov    $0xa,%eax
    3c99:	cd 40                	int    $0x40
    3c9b:	c3                   	ret    

00003c9c <getpid>:
    3c9c:	b8 0b 00 00 00       	mov    $0xb,%eax
    3ca1:	cd 40                	int    $0x40
    3ca3:	c3                   	ret    

00003ca4 <sbrk>:
    3ca4:	b8 0c 00 00 00       	mov    $0xc,%eax
    3ca9:	cd 40                	int    $0x40
    3cab:	c3                   	ret    

00003cac <sleep>:
    3cac:	b8 0d 00 00 00       	mov    $0xd,%eax
    3cb1:	cd 40                	int    $0x40
    3cb3:	c3                   	ret    

00003cb4 <uptime>:
    3cb4:	b8 0e 00 00 00       	mov    $0xe,%eax
    3cb9:	cd 40                	int    $0x40
    3cbb:	c3                   	ret    

00003cbc <putc>:
    3cbc:	55                   	push   %ebp
    3cbd:	89 e5                	mov    %esp,%ebp
    3cbf:	83 ec 28             	sub    $0x28,%esp
    3cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cc5:	88 45 f4             	mov    %al,-0xc(%ebp)
    3cc8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3ccf:	00 
    3cd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
    3cd7:	8b 45 08             	mov    0x8(%ebp),%eax
    3cda:	89 04 24             	mov    %eax,(%esp)
    3cdd:	e8 5a ff ff ff       	call   3c3c <write>
    3ce2:	c9                   	leave  
    3ce3:	c3                   	ret    

00003ce4 <printint>:
    3ce4:	55                   	push   %ebp
    3ce5:	89 e5                	mov    %esp,%ebp
    3ce7:	53                   	push   %ebx
    3ce8:	83 ec 44             	sub    $0x44,%esp
    3ceb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3cf2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3cf6:	74 17                	je     3d0f <printint+0x2b>
    3cf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3cfc:	79 11                	jns    3d0f <printint+0x2b>
    3cfe:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    3d05:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d08:	f7 d8                	neg    %eax
    3d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3d0d:	eb 06                	jmp    3d15 <printint+0x31>
    3d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3d15:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    3d1c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    3d1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
    3d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d25:	ba 00 00 00 00       	mov    $0x0,%edx
    3d2a:	f7 f3                	div    %ebx
    3d2c:	89 d0                	mov    %edx,%eax
    3d2e:	0f b6 80 44 58 00 00 	movzbl 0x5844(%eax),%eax
    3d35:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
    3d39:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    3d3d:	8b 45 10             	mov    0x10(%ebp),%eax
    3d40:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d46:	ba 00 00 00 00       	mov    $0x0,%edx
    3d4b:	f7 75 d4             	divl   -0x2c(%ebp)
    3d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3d51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3d55:	75 c5                	jne    3d1c <printint+0x38>
    3d57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3d5b:	74 28                	je     3d85 <printint+0xa1>
    3d5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3d60:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
    3d65:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    3d69:	eb 1a                	jmp    3d85 <printint+0xa1>
    3d6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3d6e:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
    3d73:	0f be c0             	movsbl %al,%eax
    3d76:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d7a:	8b 45 08             	mov    0x8(%ebp),%eax
    3d7d:	89 04 24             	mov    %eax,(%esp)
    3d80:	e8 37 ff ff ff       	call   3cbc <putc>
    3d85:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
    3d89:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3d8d:	79 dc                	jns    3d6b <printint+0x87>
    3d8f:	83 c4 44             	add    $0x44,%esp
    3d92:	5b                   	pop    %ebx
    3d93:	5d                   	pop    %ebp
    3d94:	c3                   	ret    

00003d95 <printf>:
    3d95:	55                   	push   %ebp
    3d96:	89 e5                	mov    %esp,%ebp
    3d98:	83 ec 38             	sub    $0x38,%esp
    3d9b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3da2:	8d 45 0c             	lea    0xc(%ebp),%eax
    3da5:	83 c0 04             	add    $0x4,%eax
    3da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3dab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    3db2:	e9 7e 01 00 00       	jmp    3f35 <printf+0x1a0>
    3db7:	8b 55 0c             	mov    0xc(%ebp),%edx
    3dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3dbd:	8d 04 02             	lea    (%edx,%eax,1),%eax
    3dc0:	0f b6 00             	movzbl (%eax),%eax
    3dc3:	0f be c0             	movsbl %al,%eax
    3dc6:	25 ff 00 00 00       	and    $0xff,%eax
    3dcb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    3dce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3dd2:	75 2c                	jne    3e00 <printf+0x6b>
    3dd4:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
    3dd8:	75 0c                	jne    3de6 <printf+0x51>
    3dda:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
    3de1:	e9 4b 01 00 00       	jmp    3f31 <printf+0x19c>
    3de6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3de9:	0f be c0             	movsbl %al,%eax
    3dec:	89 44 24 04          	mov    %eax,0x4(%esp)
    3df0:	8b 45 08             	mov    0x8(%ebp),%eax
    3df3:	89 04 24             	mov    %eax,(%esp)
    3df6:	e8 c1 fe ff ff       	call   3cbc <putc>
    3dfb:	e9 31 01 00 00       	jmp    3f31 <printf+0x19c>
    3e00:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
    3e04:	0f 85 27 01 00 00    	jne    3f31 <printf+0x19c>
    3e0a:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
    3e0e:	75 2d                	jne    3e3d <printf+0xa8>
    3e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e13:	8b 00                	mov    (%eax),%eax
    3e15:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    3e1c:	00 
    3e1d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    3e24:	00 
    3e25:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e29:	8b 45 08             	mov    0x8(%ebp),%eax
    3e2c:	89 04 24             	mov    %eax,(%esp)
    3e2f:	e8 b0 fe ff ff       	call   3ce4 <printint>
    3e34:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    3e38:	e9 ed 00 00 00       	jmp    3f2a <printf+0x195>
    3e3d:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
    3e41:	74 06                	je     3e49 <printf+0xb4>
    3e43:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
    3e47:	75 2d                	jne    3e76 <printf+0xe1>
    3e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e4c:	8b 00                	mov    (%eax),%eax
    3e4e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    3e55:	00 
    3e56:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    3e5d:	00 
    3e5e:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e62:	8b 45 08             	mov    0x8(%ebp),%eax
    3e65:	89 04 24             	mov    %eax,(%esp)
    3e68:	e8 77 fe ff ff       	call   3ce4 <printint>
    3e6d:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    3e71:	e9 b4 00 00 00       	jmp    3f2a <printf+0x195>
    3e76:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
    3e7a:	75 46                	jne    3ec2 <printf+0x12d>
    3e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e7f:	8b 00                	mov    (%eax),%eax
    3e81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    3e84:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    3e88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3e8c:	75 27                	jne    3eb5 <printf+0x120>
    3e8e:	c7 45 e4 1e 58 00 00 	movl   $0x581e,-0x1c(%ebp)
    3e95:	eb 1f                	jmp    3eb6 <printf+0x121>
    3e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3e9a:	0f b6 00             	movzbl (%eax),%eax
    3e9d:	0f be c0             	movsbl %al,%eax
    3ea0:	89 44 24 04          	mov    %eax,0x4(%esp)
    3ea4:	8b 45 08             	mov    0x8(%ebp),%eax
    3ea7:	89 04 24             	mov    %eax,(%esp)
    3eaa:	e8 0d fe ff ff       	call   3cbc <putc>
    3eaf:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    3eb3:	eb 01                	jmp    3eb6 <printf+0x121>
    3eb5:	90                   	nop
    3eb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3eb9:	0f b6 00             	movzbl (%eax),%eax
    3ebc:	84 c0                	test   %al,%al
    3ebe:	75 d7                	jne    3e97 <printf+0x102>
    3ec0:	eb 68                	jmp    3f2a <printf+0x195>
    3ec2:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
    3ec6:	75 1d                	jne    3ee5 <printf+0x150>
    3ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ecb:	8b 00                	mov    (%eax),%eax
    3ecd:	0f be c0             	movsbl %al,%eax
    3ed0:	89 44 24 04          	mov    %eax,0x4(%esp)
    3ed4:	8b 45 08             	mov    0x8(%ebp),%eax
    3ed7:	89 04 24             	mov    %eax,(%esp)
    3eda:	e8 dd fd ff ff       	call   3cbc <putc>
    3edf:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    3ee3:	eb 45                	jmp    3f2a <printf+0x195>
    3ee5:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
    3ee9:	75 17                	jne    3f02 <printf+0x16d>
    3eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3eee:	0f be c0             	movsbl %al,%eax
    3ef1:	89 44 24 04          	mov    %eax,0x4(%esp)
    3ef5:	8b 45 08             	mov    0x8(%ebp),%eax
    3ef8:	89 04 24             	mov    %eax,(%esp)
    3efb:	e8 bc fd ff ff       	call   3cbc <putc>
    3f00:	eb 28                	jmp    3f2a <printf+0x195>
    3f02:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    3f09:	00 
    3f0a:	8b 45 08             	mov    0x8(%ebp),%eax
    3f0d:	89 04 24             	mov    %eax,(%esp)
    3f10:	e8 a7 fd ff ff       	call   3cbc <putc>
    3f15:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3f18:	0f be c0             	movsbl %al,%eax
    3f1b:	89 44 24 04          	mov    %eax,0x4(%esp)
    3f1f:	8b 45 08             	mov    0x8(%ebp),%eax
    3f22:	89 04 24             	mov    %eax,(%esp)
    3f25:	e8 92 fd ff ff       	call   3cbc <putc>
    3f2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3f31:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    3f35:	8b 55 0c             	mov    0xc(%ebp),%edx
    3f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3f3b:	8d 04 02             	lea    (%edx,%eax,1),%eax
    3f3e:	0f b6 00             	movzbl (%eax),%eax
    3f41:	84 c0                	test   %al,%al
    3f43:	0f 85 6e fe ff ff    	jne    3db7 <printf+0x22>
    3f49:	c9                   	leave  
    3f4a:	c3                   	ret    
    3f4b:	90                   	nop

00003f4c <free>:
    3f4c:	55                   	push   %ebp
    3f4d:	89 e5                	mov    %esp,%ebp
    3f4f:	83 ec 10             	sub    $0x10,%esp
    3f52:	8b 45 08             	mov    0x8(%ebp),%eax
    3f55:	83 e8 08             	sub    $0x8,%eax
    3f58:	89 45 f8             	mov    %eax,-0x8(%ebp)
    3f5b:	a1 e8 58 00 00       	mov    0x58e8,%eax
    3f60:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3f63:	eb 24                	jmp    3f89 <free+0x3d>
    3f65:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f68:	8b 00                	mov    (%eax),%eax
    3f6a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3f6d:	77 12                	ja     3f81 <free+0x35>
    3f6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f72:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3f75:	77 24                	ja     3f9b <free+0x4f>
    3f77:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f7a:	8b 00                	mov    (%eax),%eax
    3f7c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    3f7f:	77 1a                	ja     3f9b <free+0x4f>
    3f81:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f84:	8b 00                	mov    (%eax),%eax
    3f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3f89:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f8c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3f8f:	76 d4                	jbe    3f65 <free+0x19>
    3f91:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f94:	8b 00                	mov    (%eax),%eax
    3f96:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    3f99:	76 ca                	jbe    3f65 <free+0x19>
    3f9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f9e:	8b 40 04             	mov    0x4(%eax),%eax
    3fa1:	c1 e0 03             	shl    $0x3,%eax
    3fa4:	89 c2                	mov    %eax,%edx
    3fa6:	03 55 f8             	add    -0x8(%ebp),%edx
    3fa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fac:	8b 00                	mov    (%eax),%eax
    3fae:	39 c2                	cmp    %eax,%edx
    3fb0:	75 24                	jne    3fd6 <free+0x8a>
    3fb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fb5:	8b 50 04             	mov    0x4(%eax),%edx
    3fb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fbb:	8b 00                	mov    (%eax),%eax
    3fbd:	8b 40 04             	mov    0x4(%eax),%eax
    3fc0:	01 c2                	add    %eax,%edx
    3fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fc5:	89 50 04             	mov    %edx,0x4(%eax)
    3fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fcb:	8b 00                	mov    (%eax),%eax
    3fcd:	8b 10                	mov    (%eax),%edx
    3fcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fd2:	89 10                	mov    %edx,(%eax)
    3fd4:	eb 0a                	jmp    3fe0 <free+0x94>
    3fd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fd9:	8b 10                	mov    (%eax),%edx
    3fdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fde:	89 10                	mov    %edx,(%eax)
    3fe0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fe3:	8b 40 04             	mov    0x4(%eax),%eax
    3fe6:	c1 e0 03             	shl    $0x3,%eax
    3fe9:	03 45 fc             	add    -0x4(%ebp),%eax
    3fec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    3fef:	75 20                	jne    4011 <free+0xc5>
    3ff1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3ff4:	8b 50 04             	mov    0x4(%eax),%edx
    3ff7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3ffa:	8b 40 04             	mov    0x4(%eax),%eax
    3ffd:	01 c2                	add    %eax,%edx
    3fff:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4002:	89 50 04             	mov    %edx,0x4(%eax)
    4005:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4008:	8b 10                	mov    (%eax),%edx
    400a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    400d:	89 10                	mov    %edx,(%eax)
    400f:	eb 08                	jmp    4019 <free+0xcd>
    4011:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4014:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4017:	89 10                	mov    %edx,(%eax)
    4019:	8b 45 fc             	mov    -0x4(%ebp),%eax
    401c:	a3 e8 58 00 00       	mov    %eax,0x58e8
    4021:	c9                   	leave  
    4022:	c3                   	ret    

00004023 <morecore>:
    4023:	55                   	push   %ebp
    4024:	89 e5                	mov    %esp,%ebp
    4026:	83 ec 28             	sub    $0x28,%esp
    4029:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    4030:	77 07                	ja     4039 <morecore+0x16>
    4032:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
    4039:	8b 45 08             	mov    0x8(%ebp),%eax
    403c:	c1 e0 03             	shl    $0x3,%eax
    403f:	89 04 24             	mov    %eax,(%esp)
    4042:	e8 5d fc ff ff       	call   3ca4 <sbrk>
    4047:	89 45 f0             	mov    %eax,-0x10(%ebp)
    404a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
    404e:	75 07                	jne    4057 <morecore+0x34>
    4050:	b8 00 00 00 00       	mov    $0x0,%eax
    4055:	eb 22                	jmp    4079 <morecore+0x56>
    4057:	8b 45 f0             	mov    -0x10(%ebp),%eax
    405a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    405d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4060:	8b 55 08             	mov    0x8(%ebp),%edx
    4063:	89 50 04             	mov    %edx,0x4(%eax)
    4066:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4069:	83 c0 08             	add    $0x8,%eax
    406c:	89 04 24             	mov    %eax,(%esp)
    406f:	e8 d8 fe ff ff       	call   3f4c <free>
    4074:	a1 e8 58 00 00       	mov    0x58e8,%eax
    4079:	c9                   	leave  
    407a:	c3                   	ret    

0000407b <malloc>:
    407b:	55                   	push   %ebp
    407c:	89 e5                	mov    %esp,%ebp
    407e:	83 ec 28             	sub    $0x28,%esp
    4081:	8b 45 08             	mov    0x8(%ebp),%eax
    4084:	83 c0 07             	add    $0x7,%eax
    4087:	c1 e8 03             	shr    $0x3,%eax
    408a:	83 c0 01             	add    $0x1,%eax
    408d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4090:	a1 e8 58 00 00       	mov    0x58e8,%eax
    4095:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4098:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    409c:	75 23                	jne    40c1 <malloc+0x46>
    409e:	c7 45 f0 e0 58 00 00 	movl   $0x58e0,-0x10(%ebp)
    40a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    40a8:	a3 e8 58 00 00       	mov    %eax,0x58e8
    40ad:	a1 e8 58 00 00       	mov    0x58e8,%eax
    40b2:	a3 e0 58 00 00       	mov    %eax,0x58e0
    40b7:	c7 05 e4 58 00 00 00 	movl   $0x0,0x58e4
    40be:	00 00 00 
    40c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    40c4:	8b 00                	mov    (%eax),%eax
    40c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    40c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    40cc:	8b 40 04             	mov    0x4(%eax),%eax
    40cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    40d2:	72 4d                	jb     4121 <malloc+0xa6>
    40d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    40d7:	8b 40 04             	mov    0x4(%eax),%eax
    40da:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    40dd:	75 0c                	jne    40eb <malloc+0x70>
    40df:	8b 45 ec             	mov    -0x14(%ebp),%eax
    40e2:	8b 10                	mov    (%eax),%edx
    40e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    40e7:	89 10                	mov    %edx,(%eax)
    40e9:	eb 26                	jmp    4111 <malloc+0x96>
    40eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    40ee:	8b 40 04             	mov    0x4(%eax),%eax
    40f1:	89 c2                	mov    %eax,%edx
    40f3:	2b 55 f4             	sub    -0xc(%ebp),%edx
    40f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    40f9:	89 50 04             	mov    %edx,0x4(%eax)
    40fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    40ff:	8b 40 04             	mov    0x4(%eax),%eax
    4102:	c1 e0 03             	shl    $0x3,%eax
    4105:	01 45 ec             	add    %eax,-0x14(%ebp)
    4108:	8b 45 ec             	mov    -0x14(%ebp),%eax
    410b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    410e:	89 50 04             	mov    %edx,0x4(%eax)
    4111:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4114:	a3 e8 58 00 00       	mov    %eax,0x58e8
    4119:	8b 45 ec             	mov    -0x14(%ebp),%eax
    411c:	83 c0 08             	add    $0x8,%eax
    411f:	eb 38                	jmp    4159 <malloc+0xde>
    4121:	a1 e8 58 00 00       	mov    0x58e8,%eax
    4126:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    4129:	75 1b                	jne    4146 <malloc+0xcb>
    412b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    412e:	89 04 24             	mov    %eax,(%esp)
    4131:	e8 ed fe ff ff       	call   4023 <morecore>
    4136:	89 45 ec             	mov    %eax,-0x14(%ebp)
    4139:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    413d:	75 07                	jne    4146 <malloc+0xcb>
    413f:	b8 00 00 00 00       	mov    $0x0,%eax
    4144:	eb 13                	jmp    4159 <malloc+0xde>
    4146:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4149:	89 45 f0             	mov    %eax,-0x10(%ebp)
    414c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    414f:	8b 00                	mov    (%eax),%eax
    4151:	89 45 ec             	mov    %eax,-0x14(%ebp)
    4154:	e9 70 ff ff ff       	jmp    40c9 <malloc+0x4e>
    4159:	c9                   	leave  
    415a:	c3                   	ret    
