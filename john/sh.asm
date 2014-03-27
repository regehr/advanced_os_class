
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
       c:	e8 4b 0f 00 00       	call   f5c <exit>
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 c8 14 00 00 	mov    0x14c8(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
      24:	c7 04 24 9c 14 00 00 	movl   $0x149c,(%esp)
      2b:	e8 29 03 00 00       	call   359 <panic>
      30:	8b 45 08             	mov    0x8(%ebp),%eax
      33:	89 45 e8             	mov    %eax,-0x18(%ebp)
      36:	8b 45 e8             	mov    -0x18(%ebp),%eax
      39:	8b 40 04             	mov    0x4(%eax),%eax
      3c:	85 c0                	test   %eax,%eax
      3e:	75 05                	jne    45 <runcmd+0x45>
      40:	e8 17 0f 00 00       	call   f5c <exit>
      45:	8b 45 e8             	mov    -0x18(%ebp),%eax
      48:	8d 50 04             	lea    0x4(%eax),%edx
      4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
      4e:	8b 40 04             	mov    0x4(%eax),%eax
      51:	89 54 24 04          	mov    %edx,0x4(%esp)
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 37 0f 00 00       	call   f94 <exec>
      5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
      60:	8b 40 04             	mov    0x4(%eax),%eax
      63:	89 44 24 08          	mov    %eax,0x8(%esp)
      67:	c7 44 24 04 a3 14 00 	movl   $0x14a3,0x4(%esp)
      6e:	00 
      6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      76:	e8 5a 10 00 00       	call   10d5 <printf>
      7b:	e9 83 01 00 00       	jmp    203 <runcmd+0x203>
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f4             	mov    %eax,-0xc(%ebp)
      86:	8b 45 f4             	mov    -0xc(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 f0 0e 00 00       	call   f84 <close>
      94:	8b 45 f4             	mov    -0xc(%ebp),%eax
      97:	8b 50 10             	mov    0x10(%eax),%edx
      9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      9d:	8b 40 08             	mov    0x8(%eax),%eax
      a0:	89 54 24 04          	mov    %edx,0x4(%esp)
      a4:	89 04 24             	mov    %eax,(%esp)
      a7:	e8 f0 0e 00 00       	call   f9c <open>
      ac:	85 c0                	test   %eax,%eax
      ae:	79 23                	jns    d3 <runcmd+0xd3>
      b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
      b3:	8b 40 08             	mov    0x8(%eax),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	c7 44 24 04 b3 14 00 	movl   $0x14b3,0x4(%esp)
      c1:	00 
      c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c9:	e8 07 10 00 00       	call   10d5 <printf>
      ce:	e8 89 0e 00 00       	call   f5c <exit>
      d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	89 04 24             	mov    %eax,(%esp)
      dc:	e8 1f ff ff ff       	call   0 <runcmd>
      e1:	e9 1d 01 00 00       	jmp    203 <runcmd+0x203>
      e6:	8b 45 08             	mov    0x8(%ebp),%eax
      e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
      ec:	e8 8e 02 00 00       	call   37f <fork1>
      f1:	85 c0                	test   %eax,%eax
      f3:	75 0e                	jne    103 <runcmd+0x103>
      f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
      f8:	8b 40 04             	mov    0x4(%eax),%eax
      fb:	89 04 24             	mov    %eax,(%esp)
      fe:	e8 fd fe ff ff       	call   0 <runcmd>
     103:	e8 5c 0e 00 00       	call   f64 <wait>
     108:	8b 45 ec             	mov    -0x14(%ebp),%eax
     10b:	8b 40 08             	mov    0x8(%eax),%eax
     10e:	89 04 24             	mov    %eax,(%esp)
     111:	e8 ea fe ff ff       	call   0 <runcmd>
     116:	e9 e8 00 00 00       	jmp    203 <runcmd+0x203>
     11b:	8b 45 08             	mov    0x8(%ebp),%eax
     11e:	89 45 f0             	mov    %eax,-0x10(%ebp)
     121:	8d 45 dc             	lea    -0x24(%ebp),%eax
     124:	89 04 24             	mov    %eax,(%esp)
     127:	e8 40 0e 00 00       	call   f6c <pipe>
     12c:	85 c0                	test   %eax,%eax
     12e:	79 0c                	jns    13c <runcmd+0x13c>
     130:	c7 04 24 c3 14 00 00 	movl   $0x14c3,(%esp)
     137:	e8 1d 02 00 00       	call   359 <panic>
     13c:	e8 3e 02 00 00       	call   37f <fork1>
     141:	85 c0                	test   %eax,%eax
     143:	75 3b                	jne    180 <runcmd+0x180>
     145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     14c:	e8 33 0e 00 00       	call   f84 <close>
     151:	8b 45 e0             	mov    -0x20(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 78 0e 00 00       	call   fd4 <dup>
     15c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     15f:	89 04 24             	mov    %eax,(%esp)
     162:	e8 1d 0e 00 00       	call   f84 <close>
     167:	8b 45 e0             	mov    -0x20(%ebp),%eax
     16a:	89 04 24             	mov    %eax,(%esp)
     16d:	e8 12 0e 00 00       	call   f84 <close>
     172:	8b 45 f0             	mov    -0x10(%ebp),%eax
     175:	8b 40 04             	mov    0x4(%eax),%eax
     178:	89 04 24             	mov    %eax,(%esp)
     17b:	e8 80 fe ff ff       	call   0 <runcmd>
     180:	e8 fa 01 00 00       	call   37f <fork1>
     185:	85 c0                	test   %eax,%eax
     187:	75 3b                	jne    1c4 <runcmd+0x1c4>
     189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     190:	e8 ef 0d 00 00       	call   f84 <close>
     195:	8b 45 dc             	mov    -0x24(%ebp),%eax
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 34 0e 00 00       	call   fd4 <dup>
     1a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1a3:	89 04 24             	mov    %eax,(%esp)
     1a6:	e8 d9 0d 00 00       	call   f84 <close>
     1ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ae:	89 04 24             	mov    %eax,(%esp)
     1b1:	e8 ce 0d 00 00       	call   f84 <close>
     1b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     1b9:	8b 40 08             	mov    0x8(%eax),%eax
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 3c fe ff ff       	call   0 <runcmd>
     1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c7:	89 04 24             	mov    %eax,(%esp)
     1ca:	e8 b5 0d 00 00       	call   f84 <close>
     1cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 aa 0d 00 00       	call   f84 <close>
     1da:	e8 85 0d 00 00       	call   f64 <wait>
     1df:	e8 80 0d 00 00       	call   f64 <wait>
     1e4:	eb 1d                	jmp    203 <runcmd+0x203>
     1e6:	8b 45 08             	mov    0x8(%ebp),%eax
     1e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     1ec:	e8 8e 01 00 00       	call   37f <fork1>
     1f1:	85 c0                	test   %eax,%eax
     1f3:	75 0e                	jne    203 <runcmd+0x203>
     1f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1f8:	8b 40 04             	mov    0x4(%eax),%eax
     1fb:	89 04 24             	mov    %eax,(%esp)
     1fe:	e8 fd fd ff ff       	call   0 <runcmd>
     203:	e8 54 0d 00 00       	call   f5c <exit>

00000208 <getcmd>:
     208:	55                   	push   %ebp
     209:	89 e5                	mov    %esp,%ebp
     20b:	83 ec 18             	sub    $0x18,%esp
     20e:	c7 44 24 04 e0 14 00 	movl   $0x14e0,0x4(%esp)
     215:	00 
     216:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     21d:	e8 b3 0e 00 00       	call   10d5 <printf>
     222:	8b 45 0c             	mov    0xc(%ebp),%eax
     225:	89 44 24 08          	mov    %eax,0x8(%esp)
     229:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     230:	00 
     231:	8b 45 08             	mov    0x8(%ebp),%eax
     234:	89 04 24             	mov    %eax,(%esp)
     237:	e8 7a 0b 00 00       	call   db6 <memset>
     23c:	8b 45 0c             	mov    0xc(%ebp),%eax
     23f:	89 44 24 04          	mov    %eax,0x4(%esp)
     243:	8b 45 08             	mov    0x8(%ebp),%eax
     246:	89 04 24             	mov    %eax,(%esp)
     249:	e8 bf 0b 00 00       	call   e0d <gets>
     24e:	8b 45 08             	mov    0x8(%ebp),%eax
     251:	0f b6 00             	movzbl (%eax),%eax
     254:	84 c0                	test   %al,%al
     256:	75 07                	jne    25f <getcmd+0x57>
     258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     25d:	eb 05                	jmp    264 <getcmd+0x5c>
     25f:	b8 00 00 00 00       	mov    $0x0,%eax
     264:	c9                   	leave  
     265:	c3                   	ret    

00000266 <main>:
     266:	55                   	push   %ebp
     267:	89 e5                	mov    %esp,%ebp
     269:	83 e4 f0             	and    $0xfffffff0,%esp
     26c:	83 ec 20             	sub    $0x20,%esp
     26f:	eb 19                	jmp    28a <main+0x24>
     271:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
     276:	7e 12                	jle    28a <main+0x24>
     278:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     27c:	89 04 24             	mov    %eax,(%esp)
     27f:	e8 00 0d 00 00       	call   f84 <close>
     284:	90                   	nop
     285:	e9 ae 00 00 00       	jmp    338 <main+0xd2>
     28a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     291:	00 
     292:	c7 04 24 e3 14 00 00 	movl   $0x14e3,(%esp)
     299:	e8 fe 0c 00 00       	call   f9c <open>
     29e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
     2a2:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
     2a7:	79 c8                	jns    271 <main+0xb>
     2a9:	e9 8a 00 00 00       	jmp    338 <main+0xd2>
     2ae:	0f b6 05 c0 15 00 00 	movzbl 0x15c0,%eax
     2b5:	3c 63                	cmp    $0x63,%al
     2b7:	75 5a                	jne    313 <main+0xad>
     2b9:	0f b6 05 c1 15 00 00 	movzbl 0x15c1,%eax
     2c0:	3c 64                	cmp    $0x64,%al
     2c2:	75 4f                	jne    313 <main+0xad>
     2c4:	0f b6 05 c2 15 00 00 	movzbl 0x15c2,%eax
     2cb:	3c 20                	cmp    $0x20,%al
     2cd:	75 44                	jne    313 <main+0xad>
     2cf:	c7 04 24 c0 15 00 00 	movl   $0x15c0,(%esp)
     2d6:	e8 b6 0a 00 00       	call   d91 <strlen>
     2db:	83 e8 01             	sub    $0x1,%eax
     2de:	c6 80 c0 15 00 00 00 	movb   $0x0,0x15c0(%eax)
     2e5:	c7 04 24 c3 15 00 00 	movl   $0x15c3,(%esp)
     2ec:	e8 db 0c 00 00       	call   fcc <chdir>
     2f1:	85 c0                	test   %eax,%eax
     2f3:	79 42                	jns    337 <main+0xd1>
     2f5:	c7 44 24 08 c3 15 00 	movl   $0x15c3,0x8(%esp)
     2fc:	00 
     2fd:	c7 44 24 04 eb 14 00 	movl   $0x14eb,0x4(%esp)
     304:	00 
     305:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     30c:	e8 c4 0d 00 00       	call   10d5 <printf>
     311:	eb 25                	jmp    338 <main+0xd2>
     313:	e8 67 00 00 00       	call   37f <fork1>
     318:	85 c0                	test   %eax,%eax
     31a:	75 14                	jne    330 <main+0xca>
     31c:	c7 04 24 c0 15 00 00 	movl   $0x15c0,(%esp)
     323:	e8 c6 03 00 00       	call   6ee <parsecmd>
     328:	89 04 24             	mov    %eax,(%esp)
     32b:	e8 d0 fc ff ff       	call   0 <runcmd>
     330:	e8 2f 0c 00 00       	call   f64 <wait>
     335:	eb 01                	jmp    338 <main+0xd2>
     337:	90                   	nop
     338:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     33f:	00 
     340:	c7 04 24 c0 15 00 00 	movl   $0x15c0,(%esp)
     347:	e8 bc fe ff ff       	call   208 <getcmd>
     34c:	85 c0                	test   %eax,%eax
     34e:	0f 89 5a ff ff ff    	jns    2ae <main+0x48>
     354:	e8 03 0c 00 00       	call   f5c <exit>

00000359 <panic>:
     359:	55                   	push   %ebp
     35a:	89 e5                	mov    %esp,%ebp
     35c:	83 ec 18             	sub    $0x18,%esp
     35f:	8b 45 08             	mov    0x8(%ebp),%eax
     362:	89 44 24 08          	mov    %eax,0x8(%esp)
     366:	c7 44 24 04 f9 14 00 	movl   $0x14f9,0x4(%esp)
     36d:	00 
     36e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     375:	e8 5b 0d 00 00       	call   10d5 <printf>
     37a:	e8 dd 0b 00 00       	call   f5c <exit>

0000037f <fork1>:
     37f:	55                   	push   %ebp
     380:	89 e5                	mov    %esp,%ebp
     382:	83 ec 28             	sub    $0x28,%esp
     385:	e8 ca 0b 00 00       	call   f54 <fork>
     38a:	89 45 f4             	mov    %eax,-0xc(%ebp)
     38d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     391:	75 0c                	jne    39f <fork1+0x20>
     393:	c7 04 24 fd 14 00 00 	movl   $0x14fd,(%esp)
     39a:	e8 ba ff ff ff       	call   359 <panic>
     39f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3a2:	c9                   	leave  
     3a3:	c3                   	ret    

000003a4 <execcmd>:
     3a4:	55                   	push   %ebp
     3a5:	89 e5                	mov    %esp,%ebp
     3a7:	83 ec 28             	sub    $0x28,%esp
     3aa:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3b1:	e8 05 10 00 00       	call   13bb <malloc>
     3b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     3b9:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     3c0:	00 
     3c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3c8:	00 
     3c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3cc:	89 04 24             	mov    %eax,(%esp)
     3cf:	e8 e2 09 00 00       	call   db6 <memset>
     3d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
     3dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3e0:	c9                   	leave  
     3e1:	c3                   	ret    

000003e2 <redircmd>:
     3e2:	55                   	push   %ebp
     3e3:	89 e5                	mov    %esp,%ebp
     3e5:	83 ec 28             	sub    $0x28,%esp
     3e8:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     3ef:	e8 c7 0f 00 00       	call   13bb <malloc>
     3f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
     3f7:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     3fe:	00 
     3ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     406:	00 
     407:	8b 45 f4             	mov    -0xc(%ebp),%eax
     40a:	89 04 24             	mov    %eax,(%esp)
     40d:	e8 a4 09 00 00       	call   db6 <memset>
     412:	8b 45 f4             	mov    -0xc(%ebp),%eax
     415:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
     41b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     41e:	8b 55 08             	mov    0x8(%ebp),%edx
     421:	89 50 04             	mov    %edx,0x4(%eax)
     424:	8b 45 f4             	mov    -0xc(%ebp),%eax
     427:	8b 55 0c             	mov    0xc(%ebp),%edx
     42a:	89 50 08             	mov    %edx,0x8(%eax)
     42d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     430:	8b 55 10             	mov    0x10(%ebp),%edx
     433:	89 50 0c             	mov    %edx,0xc(%eax)
     436:	8b 45 f4             	mov    -0xc(%ebp),%eax
     439:	8b 55 14             	mov    0x14(%ebp),%edx
     43c:	89 50 10             	mov    %edx,0x10(%eax)
     43f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     442:	8b 55 18             	mov    0x18(%ebp),%edx
     445:	89 50 14             	mov    %edx,0x14(%eax)
     448:	8b 45 f4             	mov    -0xc(%ebp),%eax
     44b:	c9                   	leave  
     44c:	c3                   	ret    

0000044d <pipecmd>:
     44d:	55                   	push   %ebp
     44e:	89 e5                	mov    %esp,%ebp
     450:	83 ec 28             	sub    $0x28,%esp
     453:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     45a:	e8 5c 0f 00 00       	call   13bb <malloc>
     45f:	89 45 f4             	mov    %eax,-0xc(%ebp)
     462:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     469:	00 
     46a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     471:	00 
     472:	8b 45 f4             	mov    -0xc(%ebp),%eax
     475:	89 04 24             	mov    %eax,(%esp)
     478:	e8 39 09 00 00       	call   db6 <memset>
     47d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     480:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
     486:	8b 45 f4             	mov    -0xc(%ebp),%eax
     489:	8b 55 08             	mov    0x8(%ebp),%edx
     48c:	89 50 04             	mov    %edx,0x4(%eax)
     48f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     492:	8b 55 0c             	mov    0xc(%ebp),%edx
     495:	89 50 08             	mov    %edx,0x8(%eax)
     498:	8b 45 f4             	mov    -0xc(%ebp),%eax
     49b:	c9                   	leave  
     49c:	c3                   	ret    

0000049d <listcmd>:
     49d:	55                   	push   %ebp
     49e:	89 e5                	mov    %esp,%ebp
     4a0:	83 ec 28             	sub    $0x28,%esp
     4a3:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     4aa:	e8 0c 0f 00 00       	call   13bb <malloc>
     4af:	89 45 f4             	mov    %eax,-0xc(%ebp)
     4b2:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     4b9:	00 
     4ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4c1:	00 
     4c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c5:	89 04 24             	mov    %eax,(%esp)
     4c8:	e8 e9 08 00 00       	call   db6 <memset>
     4cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d0:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
     4d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d9:	8b 55 08             	mov    0x8(%ebp),%edx
     4dc:	89 50 04             	mov    %edx,0x4(%eax)
     4df:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e2:	8b 55 0c             	mov    0xc(%ebp),%edx
     4e5:	89 50 08             	mov    %edx,0x8(%eax)
     4e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4eb:	c9                   	leave  
     4ec:	c3                   	ret    

000004ed <backcmd>:
     4ed:	55                   	push   %ebp
     4ee:	89 e5                	mov    %esp,%ebp
     4f0:	83 ec 28             	sub    $0x28,%esp
     4f3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     4fa:	e8 bc 0e 00 00       	call   13bb <malloc>
     4ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
     502:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     509:	00 
     50a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     511:	00 
     512:	8b 45 f4             	mov    -0xc(%ebp),%eax
     515:	89 04 24             	mov    %eax,(%esp)
     518:	e8 99 08 00 00       	call   db6 <memset>
     51d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     520:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
     526:	8b 45 f4             	mov    -0xc(%ebp),%eax
     529:	8b 55 08             	mov    0x8(%ebp),%edx
     52c:	89 50 04             	mov    %edx,0x4(%eax)
     52f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     532:	c9                   	leave  
     533:	c3                   	ret    

00000534 <gettoken>:
     534:	55                   	push   %ebp
     535:	89 e5                	mov    %esp,%ebp
     537:	83 ec 28             	sub    $0x28,%esp
     53a:	8b 45 08             	mov    0x8(%ebp),%eax
     53d:	8b 00                	mov    (%eax),%eax
     53f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     542:	eb 04                	jmp    548 <gettoken+0x14>
     544:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     548:	8b 45 f0             	mov    -0x10(%ebp),%eax
     54b:	3b 45 0c             	cmp    0xc(%ebp),%eax
     54e:	73 1d                	jae    56d <gettoken+0x39>
     550:	8b 45 f0             	mov    -0x10(%ebp),%eax
     553:	0f b6 00             	movzbl (%eax),%eax
     556:	0f be c0             	movsbl %al,%eax
     559:	89 44 24 04          	mov    %eax,0x4(%esp)
     55d:	c7 04 24 94 15 00 00 	movl   $0x1594,(%esp)
     564:	e8 71 08 00 00       	call   dda <strchr>
     569:	85 c0                	test   %eax,%eax
     56b:	75 d7                	jne    544 <gettoken+0x10>
     56d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     571:	74 08                	je     57b <gettoken+0x47>
     573:	8b 45 10             	mov    0x10(%ebp),%eax
     576:	8b 55 f0             	mov    -0x10(%ebp),%edx
     579:	89 10                	mov    %edx,(%eax)
     57b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     57e:	0f b6 00             	movzbl (%eax),%eax
     581:	0f be c0             	movsbl %al,%eax
     584:	89 45 f4             	mov    %eax,-0xc(%ebp)
     587:	8b 45 f0             	mov    -0x10(%ebp),%eax
     58a:	0f b6 00             	movzbl (%eax),%eax
     58d:	0f be c0             	movsbl %al,%eax
     590:	83 f8 3c             	cmp    $0x3c,%eax
     593:	7f 1e                	jg     5b3 <gettoken+0x7f>
     595:	83 f8 3b             	cmp    $0x3b,%eax
     598:	7d 23                	jge    5bd <gettoken+0x89>
     59a:	83 f8 29             	cmp    $0x29,%eax
     59d:	7f 3f                	jg     5de <gettoken+0xaa>
     59f:	83 f8 28             	cmp    $0x28,%eax
     5a2:	7d 19                	jge    5bd <gettoken+0x89>
     5a4:	85 c0                	test   %eax,%eax
     5a6:	0f 84 83 00 00 00    	je     62f <gettoken+0xfb>
     5ac:	83 f8 26             	cmp    $0x26,%eax
     5af:	74 0c                	je     5bd <gettoken+0x89>
     5b1:	eb 2b                	jmp    5de <gettoken+0xaa>
     5b3:	83 f8 3e             	cmp    $0x3e,%eax
     5b6:	74 0b                	je     5c3 <gettoken+0x8f>
     5b8:	83 f8 7c             	cmp    $0x7c,%eax
     5bb:	75 21                	jne    5de <gettoken+0xaa>
     5bd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     5c1:	eb 70                	jmp    633 <gettoken+0xff>
     5c3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     5c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5ca:	0f b6 00             	movzbl (%eax),%eax
     5cd:	3c 3e                	cmp    $0x3e,%al
     5cf:	75 61                	jne    632 <gettoken+0xfe>
     5d1:	c7 45 f4 2b 00 00 00 	movl   $0x2b,-0xc(%ebp)
     5d8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     5dc:	eb 55                	jmp    633 <gettoken+0xff>
     5de:	c7 45 f4 61 00 00 00 	movl   $0x61,-0xc(%ebp)
     5e5:	eb 04                	jmp    5eb <gettoken+0xb7>
     5e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     5eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5f1:	73 40                	jae    633 <gettoken+0xff>
     5f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5f6:	0f b6 00             	movzbl (%eax),%eax
     5f9:	0f be c0             	movsbl %al,%eax
     5fc:	89 44 24 04          	mov    %eax,0x4(%esp)
     600:	c7 04 24 94 15 00 00 	movl   $0x1594,(%esp)
     607:	e8 ce 07 00 00       	call   dda <strchr>
     60c:	85 c0                	test   %eax,%eax
     60e:	75 23                	jne    633 <gettoken+0xff>
     610:	8b 45 f0             	mov    -0x10(%ebp),%eax
     613:	0f b6 00             	movzbl (%eax),%eax
     616:	0f be c0             	movsbl %al,%eax
     619:	89 44 24 04          	mov    %eax,0x4(%esp)
     61d:	c7 04 24 9a 15 00 00 	movl   $0x159a,(%esp)
     624:	e8 b1 07 00 00       	call   dda <strchr>
     629:	85 c0                	test   %eax,%eax
     62b:	74 ba                	je     5e7 <gettoken+0xb3>
     62d:	eb 04                	jmp    633 <gettoken+0xff>
     62f:	90                   	nop
     630:	eb 01                	jmp    633 <gettoken+0xff>
     632:	90                   	nop
     633:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     637:	74 0e                	je     647 <gettoken+0x113>
     639:	8b 45 14             	mov    0x14(%ebp),%eax
     63c:	8b 55 f0             	mov    -0x10(%ebp),%edx
     63f:	89 10                	mov    %edx,(%eax)
     641:	eb 04                	jmp    647 <gettoken+0x113>
     643:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     647:	8b 45 f0             	mov    -0x10(%ebp),%eax
     64a:	3b 45 0c             	cmp    0xc(%ebp),%eax
     64d:	73 1d                	jae    66c <gettoken+0x138>
     64f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     652:	0f b6 00             	movzbl (%eax),%eax
     655:	0f be c0             	movsbl %al,%eax
     658:	89 44 24 04          	mov    %eax,0x4(%esp)
     65c:	c7 04 24 94 15 00 00 	movl   $0x1594,(%esp)
     663:	e8 72 07 00 00       	call   dda <strchr>
     668:	85 c0                	test   %eax,%eax
     66a:	75 d7                	jne    643 <gettoken+0x10f>
     66c:	8b 45 08             	mov    0x8(%ebp),%eax
     66f:	8b 55 f0             	mov    -0x10(%ebp),%edx
     672:	89 10                	mov    %edx,(%eax)
     674:	8b 45 f4             	mov    -0xc(%ebp),%eax
     677:	c9                   	leave  
     678:	c3                   	ret    

00000679 <peek>:
     679:	55                   	push   %ebp
     67a:	89 e5                	mov    %esp,%ebp
     67c:	83 ec 28             	sub    $0x28,%esp
     67f:	8b 45 08             	mov    0x8(%ebp),%eax
     682:	8b 00                	mov    (%eax),%eax
     684:	89 45 f4             	mov    %eax,-0xc(%ebp)
     687:	eb 04                	jmp    68d <peek+0x14>
     689:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     68d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     690:	3b 45 0c             	cmp    0xc(%ebp),%eax
     693:	73 1d                	jae    6b2 <peek+0x39>
     695:	8b 45 f4             	mov    -0xc(%ebp),%eax
     698:	0f b6 00             	movzbl (%eax),%eax
     69b:	0f be c0             	movsbl %al,%eax
     69e:	89 44 24 04          	mov    %eax,0x4(%esp)
     6a2:	c7 04 24 94 15 00 00 	movl   $0x1594,(%esp)
     6a9:	e8 2c 07 00 00       	call   dda <strchr>
     6ae:	85 c0                	test   %eax,%eax
     6b0:	75 d7                	jne    689 <peek+0x10>
     6b2:	8b 45 08             	mov    0x8(%ebp),%eax
     6b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6b8:	89 10                	mov    %edx,(%eax)
     6ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6bd:	0f b6 00             	movzbl (%eax),%eax
     6c0:	84 c0                	test   %al,%al
     6c2:	74 23                	je     6e7 <peek+0x6e>
     6c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c7:	0f b6 00             	movzbl (%eax),%eax
     6ca:	0f be c0             	movsbl %al,%eax
     6cd:	89 44 24 04          	mov    %eax,0x4(%esp)
     6d1:	8b 45 10             	mov    0x10(%ebp),%eax
     6d4:	89 04 24             	mov    %eax,(%esp)
     6d7:	e8 fe 06 00 00       	call   dda <strchr>
     6dc:	85 c0                	test   %eax,%eax
     6de:	74 07                	je     6e7 <peek+0x6e>
     6e0:	b8 01 00 00 00       	mov    $0x1,%eax
     6e5:	eb 05                	jmp    6ec <peek+0x73>
     6e7:	b8 00 00 00 00       	mov    $0x0,%eax
     6ec:	c9                   	leave  
     6ed:	c3                   	ret    

000006ee <parsecmd>:
     6ee:	55                   	push   %ebp
     6ef:	89 e5                	mov    %esp,%ebp
     6f1:	53                   	push   %ebx
     6f2:	83 ec 24             	sub    $0x24,%esp
     6f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6f8:	8b 45 08             	mov    0x8(%ebp),%eax
     6fb:	89 04 24             	mov    %eax,(%esp)
     6fe:	e8 8e 06 00 00       	call   d91 <strlen>
     703:	8d 04 03             	lea    (%ebx,%eax,1),%eax
     706:	89 45 f0             	mov    %eax,-0x10(%ebp)
     709:	8b 45 f0             	mov    -0x10(%ebp),%eax
     70c:	89 44 24 04          	mov    %eax,0x4(%esp)
     710:	8d 45 08             	lea    0x8(%ebp),%eax
     713:	89 04 24             	mov    %eax,(%esp)
     716:	e8 60 00 00 00       	call   77b <parseline>
     71b:	89 45 f4             	mov    %eax,-0xc(%ebp)
     71e:	c7 44 24 08 02 15 00 	movl   $0x1502,0x8(%esp)
     725:	00 
     726:	8b 45 f0             	mov    -0x10(%ebp),%eax
     729:	89 44 24 04          	mov    %eax,0x4(%esp)
     72d:	8d 45 08             	lea    0x8(%ebp),%eax
     730:	89 04 24             	mov    %eax,(%esp)
     733:	e8 41 ff ff ff       	call   679 <peek>
     738:	8b 45 08             	mov    0x8(%ebp),%eax
     73b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     73e:	74 27                	je     767 <parsecmd+0x79>
     740:	8b 45 08             	mov    0x8(%ebp),%eax
     743:	89 44 24 08          	mov    %eax,0x8(%esp)
     747:	c7 44 24 04 03 15 00 	movl   $0x1503,0x4(%esp)
     74e:	00 
     74f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     756:	e8 7a 09 00 00       	call   10d5 <printf>
     75b:	c7 04 24 12 15 00 00 	movl   $0x1512,(%esp)
     762:	e8 f2 fb ff ff       	call   359 <panic>
     767:	8b 45 f4             	mov    -0xc(%ebp),%eax
     76a:	89 04 24             	mov    %eax,(%esp)
     76d:	e8 a4 04 00 00       	call   c16 <nulterminate>
     772:	8b 45 f4             	mov    -0xc(%ebp),%eax
     775:	83 c4 24             	add    $0x24,%esp
     778:	5b                   	pop    %ebx
     779:	5d                   	pop    %ebp
     77a:	c3                   	ret    

0000077b <parseline>:
     77b:	55                   	push   %ebp
     77c:	89 e5                	mov    %esp,%ebp
     77e:	83 ec 28             	sub    $0x28,%esp
     781:	8b 45 0c             	mov    0xc(%ebp),%eax
     784:	89 44 24 04          	mov    %eax,0x4(%esp)
     788:	8b 45 08             	mov    0x8(%ebp),%eax
     78b:	89 04 24             	mov    %eax,(%esp)
     78e:	e8 bc 00 00 00       	call   84f <parsepipe>
     793:	89 45 f4             	mov    %eax,-0xc(%ebp)
     796:	eb 30                	jmp    7c8 <parseline+0x4d>
     798:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     79f:	00 
     7a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7a7:	00 
     7a8:	8b 45 0c             	mov    0xc(%ebp),%eax
     7ab:	89 44 24 04          	mov    %eax,0x4(%esp)
     7af:	8b 45 08             	mov    0x8(%ebp),%eax
     7b2:	89 04 24             	mov    %eax,(%esp)
     7b5:	e8 7a fd ff ff       	call   534 <gettoken>
     7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7bd:	89 04 24             	mov    %eax,(%esp)
     7c0:	e8 28 fd ff ff       	call   4ed <backcmd>
     7c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
     7c8:	c7 44 24 08 19 15 00 	movl   $0x1519,0x8(%esp)
     7cf:	00 
     7d0:	8b 45 0c             	mov    0xc(%ebp),%eax
     7d3:	89 44 24 04          	mov    %eax,0x4(%esp)
     7d7:	8b 45 08             	mov    0x8(%ebp),%eax
     7da:	89 04 24             	mov    %eax,(%esp)
     7dd:	e8 97 fe ff ff       	call   679 <peek>
     7e2:	85 c0                	test   %eax,%eax
     7e4:	75 b2                	jne    798 <parseline+0x1d>
     7e6:	c7 44 24 08 1b 15 00 	movl   $0x151b,0x8(%esp)
     7ed:	00 
     7ee:	8b 45 0c             	mov    0xc(%ebp),%eax
     7f1:	89 44 24 04          	mov    %eax,0x4(%esp)
     7f5:	8b 45 08             	mov    0x8(%ebp),%eax
     7f8:	89 04 24             	mov    %eax,(%esp)
     7fb:	e8 79 fe ff ff       	call   679 <peek>
     800:	85 c0                	test   %eax,%eax
     802:	74 46                	je     84a <parseline+0xcf>
     804:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     80b:	00 
     80c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     813:	00 
     814:	8b 45 0c             	mov    0xc(%ebp),%eax
     817:	89 44 24 04          	mov    %eax,0x4(%esp)
     81b:	8b 45 08             	mov    0x8(%ebp),%eax
     81e:	89 04 24             	mov    %eax,(%esp)
     821:	e8 0e fd ff ff       	call   534 <gettoken>
     826:	8b 45 0c             	mov    0xc(%ebp),%eax
     829:	89 44 24 04          	mov    %eax,0x4(%esp)
     82d:	8b 45 08             	mov    0x8(%ebp),%eax
     830:	89 04 24             	mov    %eax,(%esp)
     833:	e8 43 ff ff ff       	call   77b <parseline>
     838:	89 44 24 04          	mov    %eax,0x4(%esp)
     83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     83f:	89 04 24             	mov    %eax,(%esp)
     842:	e8 56 fc ff ff       	call   49d <listcmd>
     847:	89 45 f4             	mov    %eax,-0xc(%ebp)
     84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     84d:	c9                   	leave  
     84e:	c3                   	ret    

0000084f <parsepipe>:
     84f:	55                   	push   %ebp
     850:	89 e5                	mov    %esp,%ebp
     852:	83 ec 28             	sub    $0x28,%esp
     855:	8b 45 0c             	mov    0xc(%ebp),%eax
     858:	89 44 24 04          	mov    %eax,0x4(%esp)
     85c:	8b 45 08             	mov    0x8(%ebp),%eax
     85f:	89 04 24             	mov    %eax,(%esp)
     862:	e8 67 02 00 00       	call   ace <parseexec>
     867:	89 45 f4             	mov    %eax,-0xc(%ebp)
     86a:	c7 44 24 08 1d 15 00 	movl   $0x151d,0x8(%esp)
     871:	00 
     872:	8b 45 0c             	mov    0xc(%ebp),%eax
     875:	89 44 24 04          	mov    %eax,0x4(%esp)
     879:	8b 45 08             	mov    0x8(%ebp),%eax
     87c:	89 04 24             	mov    %eax,(%esp)
     87f:	e8 f5 fd ff ff       	call   679 <peek>
     884:	85 c0                	test   %eax,%eax
     886:	74 46                	je     8ce <parsepipe+0x7f>
     888:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     88f:	00 
     890:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     897:	00 
     898:	8b 45 0c             	mov    0xc(%ebp),%eax
     89b:	89 44 24 04          	mov    %eax,0x4(%esp)
     89f:	8b 45 08             	mov    0x8(%ebp),%eax
     8a2:	89 04 24             	mov    %eax,(%esp)
     8a5:	e8 8a fc ff ff       	call   534 <gettoken>
     8aa:	8b 45 0c             	mov    0xc(%ebp),%eax
     8ad:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b1:	8b 45 08             	mov    0x8(%ebp),%eax
     8b4:	89 04 24             	mov    %eax,(%esp)
     8b7:	e8 93 ff ff ff       	call   84f <parsepipe>
     8bc:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c3:	89 04 24             	mov    %eax,(%esp)
     8c6:	e8 82 fb ff ff       	call   44d <pipecmd>
     8cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
     8ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8d1:	c9                   	leave  
     8d2:	c3                   	ret    

000008d3 <parseredirs>:
     8d3:	55                   	push   %ebp
     8d4:	89 e5                	mov    %esp,%ebp
     8d6:	83 ec 38             	sub    $0x38,%esp
     8d9:	e9 f5 00 00 00       	jmp    9d3 <parseredirs+0x100>
     8de:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     8e5:	00 
     8e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     8ed:	00 
     8ee:	8b 45 10             	mov    0x10(%ebp),%eax
     8f1:	89 44 24 04          	mov    %eax,0x4(%esp)
     8f5:	8b 45 0c             	mov    0xc(%ebp),%eax
     8f8:	89 04 24             	mov    %eax,(%esp)
     8fb:	e8 34 fc ff ff       	call   534 <gettoken>
     900:	89 45 f4             	mov    %eax,-0xc(%ebp)
     903:	8d 45 ec             	lea    -0x14(%ebp),%eax
     906:	89 44 24 0c          	mov    %eax,0xc(%esp)
     90a:	8d 45 f0             	lea    -0x10(%ebp),%eax
     90d:	89 44 24 08          	mov    %eax,0x8(%esp)
     911:	8b 45 10             	mov    0x10(%ebp),%eax
     914:	89 44 24 04          	mov    %eax,0x4(%esp)
     918:	8b 45 0c             	mov    0xc(%ebp),%eax
     91b:	89 04 24             	mov    %eax,(%esp)
     91e:	e8 11 fc ff ff       	call   534 <gettoken>
     923:	83 f8 61             	cmp    $0x61,%eax
     926:	74 0c                	je     934 <parseredirs+0x61>
     928:	c7 04 24 1f 15 00 00 	movl   $0x151f,(%esp)
     92f:	e8 25 fa ff ff       	call   359 <panic>
     934:	8b 45 f4             	mov    -0xc(%ebp),%eax
     937:	83 f8 3c             	cmp    $0x3c,%eax
     93a:	74 0f                	je     94b <parseredirs+0x78>
     93c:	83 f8 3e             	cmp    $0x3e,%eax
     93f:	74 38                	je     979 <parseredirs+0xa6>
     941:	83 f8 2b             	cmp    $0x2b,%eax
     944:	74 61                	je     9a7 <parseredirs+0xd4>
     946:	e9 88 00 00 00       	jmp    9d3 <parseredirs+0x100>
     94b:	8b 55 ec             	mov    -0x14(%ebp),%edx
     94e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     951:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     958:	00 
     959:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     960:	00 
     961:	89 54 24 08          	mov    %edx,0x8(%esp)
     965:	89 44 24 04          	mov    %eax,0x4(%esp)
     969:	8b 45 08             	mov    0x8(%ebp),%eax
     96c:	89 04 24             	mov    %eax,(%esp)
     96f:	e8 6e fa ff ff       	call   3e2 <redircmd>
     974:	89 45 08             	mov    %eax,0x8(%ebp)
     977:	eb 5a                	jmp    9d3 <parseredirs+0x100>
     979:	8b 55 ec             	mov    -0x14(%ebp),%edx
     97c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     97f:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     986:	00 
     987:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     98e:	00 
     98f:	89 54 24 08          	mov    %edx,0x8(%esp)
     993:	89 44 24 04          	mov    %eax,0x4(%esp)
     997:	8b 45 08             	mov    0x8(%ebp),%eax
     99a:	89 04 24             	mov    %eax,(%esp)
     99d:	e8 40 fa ff ff       	call   3e2 <redircmd>
     9a2:	89 45 08             	mov    %eax,0x8(%ebp)
     9a5:	eb 2c                	jmp    9d3 <parseredirs+0x100>
     9a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
     9aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9ad:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     9b4:	00 
     9b5:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     9bc:	00 
     9bd:	89 54 24 08          	mov    %edx,0x8(%esp)
     9c1:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c5:	8b 45 08             	mov    0x8(%ebp),%eax
     9c8:	89 04 24             	mov    %eax,(%esp)
     9cb:	e8 12 fa ff ff       	call   3e2 <redircmd>
     9d0:	89 45 08             	mov    %eax,0x8(%ebp)
     9d3:	c7 44 24 08 3c 15 00 	movl   $0x153c,0x8(%esp)
     9da:	00 
     9db:	8b 45 10             	mov    0x10(%ebp),%eax
     9de:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e2:	8b 45 0c             	mov    0xc(%ebp),%eax
     9e5:	89 04 24             	mov    %eax,(%esp)
     9e8:	e8 8c fc ff ff       	call   679 <peek>
     9ed:	85 c0                	test   %eax,%eax
     9ef:	0f 85 e9 fe ff ff    	jne    8de <parseredirs+0xb>
     9f5:	8b 45 08             	mov    0x8(%ebp),%eax
     9f8:	c9                   	leave  
     9f9:	c3                   	ret    

000009fa <parseblock>:
     9fa:	55                   	push   %ebp
     9fb:	89 e5                	mov    %esp,%ebp
     9fd:	83 ec 28             	sub    $0x28,%esp
     a00:	c7 44 24 08 3f 15 00 	movl   $0x153f,0x8(%esp)
     a07:	00 
     a08:	8b 45 0c             	mov    0xc(%ebp),%eax
     a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
     a0f:	8b 45 08             	mov    0x8(%ebp),%eax
     a12:	89 04 24             	mov    %eax,(%esp)
     a15:	e8 5f fc ff ff       	call   679 <peek>
     a1a:	85 c0                	test   %eax,%eax
     a1c:	75 0c                	jne    a2a <parseblock+0x30>
     a1e:	c7 04 24 41 15 00 00 	movl   $0x1541,(%esp)
     a25:	e8 2f f9 ff ff       	call   359 <panic>
     a2a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a31:	00 
     a32:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a39:	00 
     a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
     a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
     a41:	8b 45 08             	mov    0x8(%ebp),%eax
     a44:	89 04 24             	mov    %eax,(%esp)
     a47:	e8 e8 fa ff ff       	call   534 <gettoken>
     a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
     a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
     a53:	8b 45 08             	mov    0x8(%ebp),%eax
     a56:	89 04 24             	mov    %eax,(%esp)
     a59:	e8 1d fd ff ff       	call   77b <parseline>
     a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     a61:	c7 44 24 08 4c 15 00 	movl   $0x154c,0x8(%esp)
     a68:	00 
     a69:	8b 45 0c             	mov    0xc(%ebp),%eax
     a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
     a70:	8b 45 08             	mov    0x8(%ebp),%eax
     a73:	89 04 24             	mov    %eax,(%esp)
     a76:	e8 fe fb ff ff       	call   679 <peek>
     a7b:	85 c0                	test   %eax,%eax
     a7d:	75 0c                	jne    a8b <parseblock+0x91>
     a7f:	c7 04 24 4e 15 00 00 	movl   $0x154e,(%esp)
     a86:	e8 ce f8 ff ff       	call   359 <panic>
     a8b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a92:	00 
     a93:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a9a:	00 
     a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
     a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
     aa2:	8b 45 08             	mov    0x8(%ebp),%eax
     aa5:	89 04 24             	mov    %eax,(%esp)
     aa8:	e8 87 fa ff ff       	call   534 <gettoken>
     aad:	8b 45 0c             	mov    0xc(%ebp),%eax
     ab0:	89 44 24 08          	mov    %eax,0x8(%esp)
     ab4:	8b 45 08             	mov    0x8(%ebp),%eax
     ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
     abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     abe:	89 04 24             	mov    %eax,(%esp)
     ac1:	e8 0d fe ff ff       	call   8d3 <parseredirs>
     ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     acc:	c9                   	leave  
     acd:	c3                   	ret    

00000ace <parseexec>:
     ace:	55                   	push   %ebp
     acf:	89 e5                	mov    %esp,%ebp
     ad1:	83 ec 38             	sub    $0x38,%esp
     ad4:	c7 44 24 08 3f 15 00 	movl   $0x153f,0x8(%esp)
     adb:	00 
     adc:	8b 45 0c             	mov    0xc(%ebp),%eax
     adf:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae3:	8b 45 08             	mov    0x8(%ebp),%eax
     ae6:	89 04 24             	mov    %eax,(%esp)
     ae9:	e8 8b fb ff ff       	call   679 <peek>
     aee:	85 c0                	test   %eax,%eax
     af0:	74 17                	je     b09 <parseexec+0x3b>
     af2:	8b 45 0c             	mov    0xc(%ebp),%eax
     af5:	89 44 24 04          	mov    %eax,0x4(%esp)
     af9:	8b 45 08             	mov    0x8(%ebp),%eax
     afc:	89 04 24             	mov    %eax,(%esp)
     aff:	e8 f6 fe ff ff       	call   9fa <parseblock>
     b04:	e9 0b 01 00 00       	jmp    c14 <parseexec+0x146>
     b09:	e8 96 f8 ff ff       	call   3a4 <execcmd>
     b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b17:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
     b21:	89 44 24 08          	mov    %eax,0x8(%esp)
     b25:	8b 45 08             	mov    0x8(%ebp),%eax
     b28:	89 44 24 04          	mov    %eax,0x4(%esp)
     b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b2f:	89 04 24             	mov    %eax,(%esp)
     b32:	e8 9c fd ff ff       	call   8d3 <parseredirs>
     b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
     b3a:	e9 8e 00 00 00       	jmp    bcd <parseexec+0xff>
     b3f:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b42:	89 44 24 0c          	mov    %eax,0xc(%esp)
     b46:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b49:	89 44 24 08          	mov    %eax,0x8(%esp)
     b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
     b50:	89 44 24 04          	mov    %eax,0x4(%esp)
     b54:	8b 45 08             	mov    0x8(%ebp),%eax
     b57:	89 04 24             	mov    %eax,(%esp)
     b5a:	e8 d5 f9 ff ff       	call   534 <gettoken>
     b5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
     b62:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b66:	0f 84 85 00 00 00    	je     bf1 <parseexec+0x123>
     b6c:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     b70:	74 0c                	je     b7e <parseexec+0xb0>
     b72:	c7 04 24 12 15 00 00 	movl   $0x1512,(%esp)
     b79:	e8 db f7 ff ff       	call   359 <panic>
     b7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b81:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b87:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
     b8b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
     b8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b94:	83 c1 08             	add    $0x8,%ecx
     b97:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
     b9b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     b9f:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
     ba3:	7e 0c                	jle    bb1 <parseexec+0xe3>
     ba5:	c7 04 24 61 15 00 00 	movl   $0x1561,(%esp)
     bac:	e8 a8 f7 ff ff       	call   359 <panic>
     bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb4:	89 44 24 08          	mov    %eax,0x8(%esp)
     bb8:	8b 45 08             	mov    0x8(%ebp),%eax
     bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
     bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bc2:	89 04 24             	mov    %eax,(%esp)
     bc5:	e8 09 fd ff ff       	call   8d3 <parseredirs>
     bca:	89 45 f4             	mov    %eax,-0xc(%ebp)
     bcd:	c7 44 24 08 6f 15 00 	movl   $0x156f,0x8(%esp)
     bd4:	00 
     bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
     bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
     bdc:	8b 45 08             	mov    0x8(%ebp),%eax
     bdf:	89 04 24             	mov    %eax,(%esp)
     be2:	e8 92 fa ff ff       	call   679 <peek>
     be7:	85 c0                	test   %eax,%eax
     be9:	0f 84 50 ff ff ff    	je     b3f <parseexec+0x71>
     bef:	eb 01                	jmp    bf2 <parseexec+0x124>
     bf1:	90                   	nop
     bf2:	8b 55 ec             	mov    -0x14(%ebp),%edx
     bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bf8:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     bff:	00 
     c00:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c06:	83 c2 08             	add    $0x8,%edx
     c09:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     c10:	00 
     c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c14:	c9                   	leave  
     c15:	c3                   	ret    

00000c16 <nulterminate>:
     c16:	55                   	push   %ebp
     c17:	89 e5                	mov    %esp,%ebp
     c19:	83 ec 38             	sub    $0x38,%esp
     c1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     c20:	75 0a                	jne    c2c <nulterminate+0x16>
     c22:	b8 00 00 00 00       	mov    $0x0,%eax
     c27:	e9 c8 00 00 00       	jmp    cf4 <nulterminate+0xde>
     c2c:	8b 45 08             	mov    0x8(%ebp),%eax
     c2f:	8b 00                	mov    (%eax),%eax
     c31:	83 f8 05             	cmp    $0x5,%eax
     c34:	0f 87 b7 00 00 00    	ja     cf1 <nulterminate+0xdb>
     c3a:	8b 04 85 74 15 00 00 	mov    0x1574(,%eax,4),%eax
     c41:	ff e0                	jmp    *%eax
     c43:	8b 45 08             	mov    0x8(%ebp),%eax
     c46:	89 45 e8             	mov    %eax,-0x18(%ebp)
     c49:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
     c50:	eb 14                	jmp    c66 <nulterminate+0x50>
     c52:	8b 55 e0             	mov    -0x20(%ebp),%edx
     c55:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c58:	83 c2 08             	add    $0x8,%edx
     c5b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     c5f:	c6 00 00             	movb   $0x0,(%eax)
     c62:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
     c66:	8b 55 e0             	mov    -0x20(%ebp),%edx
     c69:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c6c:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     c70:	85 c0                	test   %eax,%eax
     c72:	75 de                	jne    c52 <nulterminate+0x3c>
     c74:	eb 7b                	jmp    cf1 <nulterminate+0xdb>
     c76:	8b 45 08             	mov    0x8(%ebp),%eax
     c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
     c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c7f:	8b 40 04             	mov    0x4(%eax),%eax
     c82:	89 04 24             	mov    %eax,(%esp)
     c85:	e8 8c ff ff ff       	call   c16 <nulterminate>
     c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c8d:	8b 40 0c             	mov    0xc(%eax),%eax
     c90:	c6 00 00             	movb   $0x0,(%eax)
     c93:	eb 5c                	jmp    cf1 <nulterminate+0xdb>
     c95:	8b 45 08             	mov    0x8(%ebp),%eax
     c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
     c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c9e:	8b 40 04             	mov    0x4(%eax),%eax
     ca1:	89 04 24             	mov    %eax,(%esp)
     ca4:	e8 6d ff ff ff       	call   c16 <nulterminate>
     ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cac:	8b 40 08             	mov    0x8(%eax),%eax
     caf:	89 04 24             	mov    %eax,(%esp)
     cb2:	e8 5f ff ff ff       	call   c16 <nulterminate>
     cb7:	eb 38                	jmp    cf1 <nulterminate+0xdb>
     cb9:	8b 45 08             	mov    0x8(%ebp),%eax
     cbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
     cbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cc2:	8b 40 04             	mov    0x4(%eax),%eax
     cc5:	89 04 24             	mov    %eax,(%esp)
     cc8:	e8 49 ff ff ff       	call   c16 <nulterminate>
     ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cd0:	8b 40 08             	mov    0x8(%eax),%eax
     cd3:	89 04 24             	mov    %eax,(%esp)
     cd6:	e8 3b ff ff ff       	call   c16 <nulterminate>
     cdb:	eb 14                	jmp    cf1 <nulterminate+0xdb>
     cdd:	8b 45 08             	mov    0x8(%ebp),%eax
     ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     ce3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ce6:	8b 40 04             	mov    0x4(%eax),%eax
     ce9:	89 04 24             	mov    %eax,(%esp)
     cec:	e8 25 ff ff ff       	call   c16 <nulterminate>
     cf1:	8b 45 08             	mov    0x8(%ebp),%eax
     cf4:	c9                   	leave  
     cf5:	c3                   	ret    
     cf6:	66 90                	xchg   %ax,%ax

00000cf8 <stosb>:
     cf8:	55                   	push   %ebp
     cf9:	89 e5                	mov    %esp,%ebp
     cfb:	57                   	push   %edi
     cfc:	53                   	push   %ebx
     cfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d00:	8b 55 10             	mov    0x10(%ebp),%edx
     d03:	8b 45 0c             	mov    0xc(%ebp),%eax
     d06:	89 cb                	mov    %ecx,%ebx
     d08:	89 df                	mov    %ebx,%edi
     d0a:	89 d1                	mov    %edx,%ecx
     d0c:	fc                   	cld    
     d0d:	f3 aa                	rep stos %al,%es:(%edi)
     d0f:	89 ca                	mov    %ecx,%edx
     d11:	89 fb                	mov    %edi,%ebx
     d13:	89 5d 08             	mov    %ebx,0x8(%ebp)
     d16:	89 55 10             	mov    %edx,0x10(%ebp)
     d19:	5b                   	pop    %ebx
     d1a:	5f                   	pop    %edi
     d1b:	5d                   	pop    %ebp
     d1c:	c3                   	ret    

00000d1d <strcpy>:
     d1d:	55                   	push   %ebp
     d1e:	89 e5                	mov    %esp,%ebp
     d20:	83 ec 10             	sub    $0x10,%esp
     d23:	8b 45 08             	mov    0x8(%ebp),%eax
     d26:	89 45 fc             	mov    %eax,-0x4(%ebp)
     d29:	8b 45 0c             	mov    0xc(%ebp),%eax
     d2c:	0f b6 10             	movzbl (%eax),%edx
     d2f:	8b 45 08             	mov    0x8(%ebp),%eax
     d32:	88 10                	mov    %dl,(%eax)
     d34:	8b 45 08             	mov    0x8(%ebp),%eax
     d37:	0f b6 00             	movzbl (%eax),%eax
     d3a:	84 c0                	test   %al,%al
     d3c:	0f 95 c0             	setne  %al
     d3f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d43:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     d47:	84 c0                	test   %al,%al
     d49:	75 de                	jne    d29 <strcpy+0xc>
     d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     d4e:	c9                   	leave  
     d4f:	c3                   	ret    

00000d50 <strcmp>:
     d50:	55                   	push   %ebp
     d51:	89 e5                	mov    %esp,%ebp
     d53:	eb 08                	jmp    d5d <strcmp+0xd>
     d55:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d59:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     d5d:	8b 45 08             	mov    0x8(%ebp),%eax
     d60:	0f b6 00             	movzbl (%eax),%eax
     d63:	84 c0                	test   %al,%al
     d65:	74 10                	je     d77 <strcmp+0x27>
     d67:	8b 45 08             	mov    0x8(%ebp),%eax
     d6a:	0f b6 10             	movzbl (%eax),%edx
     d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
     d70:	0f b6 00             	movzbl (%eax),%eax
     d73:	38 c2                	cmp    %al,%dl
     d75:	74 de                	je     d55 <strcmp+0x5>
     d77:	8b 45 08             	mov    0x8(%ebp),%eax
     d7a:	0f b6 00             	movzbl (%eax),%eax
     d7d:	0f b6 d0             	movzbl %al,%edx
     d80:	8b 45 0c             	mov    0xc(%ebp),%eax
     d83:	0f b6 00             	movzbl (%eax),%eax
     d86:	0f b6 c0             	movzbl %al,%eax
     d89:	89 d1                	mov    %edx,%ecx
     d8b:	29 c1                	sub    %eax,%ecx
     d8d:	89 c8                	mov    %ecx,%eax
     d8f:	5d                   	pop    %ebp
     d90:	c3                   	ret    

00000d91 <strlen>:
     d91:	55                   	push   %ebp
     d92:	89 e5                	mov    %esp,%ebp
     d94:	83 ec 10             	sub    $0x10,%esp
     d97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     d9e:	eb 04                	jmp    da4 <strlen+0x13>
     da0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     da4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     da7:	03 45 08             	add    0x8(%ebp),%eax
     daa:	0f b6 00             	movzbl (%eax),%eax
     dad:	84 c0                	test   %al,%al
     daf:	75 ef                	jne    da0 <strlen+0xf>
     db1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     db4:	c9                   	leave  
     db5:	c3                   	ret    

00000db6 <memset>:
     db6:	55                   	push   %ebp
     db7:	89 e5                	mov    %esp,%ebp
     db9:	83 ec 0c             	sub    $0xc,%esp
     dbc:	8b 45 10             	mov    0x10(%ebp),%eax
     dbf:	89 44 24 08          	mov    %eax,0x8(%esp)
     dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
     dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
     dca:	8b 45 08             	mov    0x8(%ebp),%eax
     dcd:	89 04 24             	mov    %eax,(%esp)
     dd0:	e8 23 ff ff ff       	call   cf8 <stosb>
     dd5:	8b 45 08             	mov    0x8(%ebp),%eax
     dd8:	c9                   	leave  
     dd9:	c3                   	ret    

00000dda <strchr>:
     dda:	55                   	push   %ebp
     ddb:	89 e5                	mov    %esp,%ebp
     ddd:	83 ec 04             	sub    $0x4,%esp
     de0:	8b 45 0c             	mov    0xc(%ebp),%eax
     de3:	88 45 fc             	mov    %al,-0x4(%ebp)
     de6:	eb 14                	jmp    dfc <strchr+0x22>
     de8:	8b 45 08             	mov    0x8(%ebp),%eax
     deb:	0f b6 00             	movzbl (%eax),%eax
     dee:	3a 45 fc             	cmp    -0x4(%ebp),%al
     df1:	75 05                	jne    df8 <strchr+0x1e>
     df3:	8b 45 08             	mov    0x8(%ebp),%eax
     df6:	eb 13                	jmp    e0b <strchr+0x31>
     df8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     dfc:	8b 45 08             	mov    0x8(%ebp),%eax
     dff:	0f b6 00             	movzbl (%eax),%eax
     e02:	84 c0                	test   %al,%al
     e04:	75 e2                	jne    de8 <strchr+0xe>
     e06:	b8 00 00 00 00       	mov    $0x0,%eax
     e0b:	c9                   	leave  
     e0c:	c3                   	ret    

00000e0d <gets>:
     e0d:	55                   	push   %ebp
     e0e:	89 e5                	mov    %esp,%ebp
     e10:	83 ec 28             	sub    $0x28,%esp
     e13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     e1a:	eb 44                	jmp    e60 <gets+0x53>
     e1c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e23:	00 
     e24:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e27:	89 44 24 04          	mov    %eax,0x4(%esp)
     e2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e32:	e8 3d 01 00 00       	call   f74 <read>
     e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
     e3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e3e:	7e 2d                	jle    e6d <gets+0x60>
     e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e43:	03 45 08             	add    0x8(%ebp),%eax
     e46:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     e4a:	88 10                	mov    %dl,(%eax)
     e4c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     e50:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e54:	3c 0a                	cmp    $0xa,%al
     e56:	74 16                	je     e6e <gets+0x61>
     e58:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e5c:	3c 0d                	cmp    $0xd,%al
     e5e:	74 0e                	je     e6e <gets+0x61>
     e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e63:	83 c0 01             	add    $0x1,%eax
     e66:	3b 45 0c             	cmp    0xc(%ebp),%eax
     e69:	7c b1                	jl     e1c <gets+0xf>
     e6b:	eb 01                	jmp    e6e <gets+0x61>
     e6d:	90                   	nop
     e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e71:	03 45 08             	add    0x8(%ebp),%eax
     e74:	c6 00 00             	movb   $0x0,(%eax)
     e77:	8b 45 08             	mov    0x8(%ebp),%eax
     e7a:	c9                   	leave  
     e7b:	c3                   	ret    

00000e7c <stat>:
     e7c:	55                   	push   %ebp
     e7d:	89 e5                	mov    %esp,%ebp
     e7f:	83 ec 28             	sub    $0x28,%esp
     e82:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     e89:	00 
     e8a:	8b 45 08             	mov    0x8(%ebp),%eax
     e8d:	89 04 24             	mov    %eax,(%esp)
     e90:	e8 07 01 00 00       	call   f9c <open>
     e95:	89 45 f0             	mov    %eax,-0x10(%ebp)
     e98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e9c:	79 07                	jns    ea5 <stat+0x29>
     e9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ea3:	eb 23                	jmp    ec8 <stat+0x4c>
     ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
     ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
     eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eaf:	89 04 24             	mov    %eax,(%esp)
     eb2:	e8 fd 00 00 00       	call   fb4 <fstat>
     eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
     eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ebd:	89 04 24             	mov    %eax,(%esp)
     ec0:	e8 bf 00 00 00       	call   f84 <close>
     ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ec8:	c9                   	leave  
     ec9:	c3                   	ret    

00000eca <atoi>:
     eca:	55                   	push   %ebp
     ecb:	89 e5                	mov    %esp,%ebp
     ecd:	83 ec 10             	sub    $0x10,%esp
     ed0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     ed7:	eb 24                	jmp    efd <atoi+0x33>
     ed9:	8b 55 fc             	mov    -0x4(%ebp),%edx
     edc:	89 d0                	mov    %edx,%eax
     ede:	c1 e0 02             	shl    $0x2,%eax
     ee1:	01 d0                	add    %edx,%eax
     ee3:	01 c0                	add    %eax,%eax
     ee5:	89 c2                	mov    %eax,%edx
     ee7:	8b 45 08             	mov    0x8(%ebp),%eax
     eea:	0f b6 00             	movzbl (%eax),%eax
     eed:	0f be c0             	movsbl %al,%eax
     ef0:	8d 04 02             	lea    (%edx,%eax,1),%eax
     ef3:	83 e8 30             	sub    $0x30,%eax
     ef6:	89 45 fc             	mov    %eax,-0x4(%ebp)
     ef9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     efd:	8b 45 08             	mov    0x8(%ebp),%eax
     f00:	0f b6 00             	movzbl (%eax),%eax
     f03:	3c 2f                	cmp    $0x2f,%al
     f05:	7e 0a                	jle    f11 <atoi+0x47>
     f07:	8b 45 08             	mov    0x8(%ebp),%eax
     f0a:	0f b6 00             	movzbl (%eax),%eax
     f0d:	3c 39                	cmp    $0x39,%al
     f0f:	7e c8                	jle    ed9 <atoi+0xf>
     f11:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f14:	c9                   	leave  
     f15:	c3                   	ret    

00000f16 <memmove>:
     f16:	55                   	push   %ebp
     f17:	89 e5                	mov    %esp,%ebp
     f19:	83 ec 10             	sub    $0x10,%esp
     f1c:	8b 45 08             	mov    0x8(%ebp),%eax
     f1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
     f22:	8b 45 0c             	mov    0xc(%ebp),%eax
     f25:	89 45 fc             	mov    %eax,-0x4(%ebp)
     f28:	eb 13                	jmp    f3d <memmove+0x27>
     f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f2d:	0f b6 10             	movzbl (%eax),%edx
     f30:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f33:	88 10                	mov    %dl,(%eax)
     f35:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
     f39:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     f41:	0f 9f c0             	setg   %al
     f44:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     f48:	84 c0                	test   %al,%al
     f4a:	75 de                	jne    f2a <memmove+0x14>
     f4c:	8b 45 08             	mov    0x8(%ebp),%eax
     f4f:	c9                   	leave  
     f50:	c3                   	ret    
     f51:	66 90                	xchg   %ax,%ax
     f53:	90                   	nop

00000f54 <fork>:
     f54:	b8 01 00 00 00       	mov    $0x1,%eax
     f59:	cd 40                	int    $0x40
     f5b:	c3                   	ret    

00000f5c <exit>:
     f5c:	b8 02 00 00 00       	mov    $0x2,%eax
     f61:	cd 40                	int    $0x40
     f63:	c3                   	ret    

00000f64 <wait>:
     f64:	b8 03 00 00 00       	mov    $0x3,%eax
     f69:	cd 40                	int    $0x40
     f6b:	c3                   	ret    

00000f6c <pipe>:
     f6c:	b8 04 00 00 00       	mov    $0x4,%eax
     f71:	cd 40                	int    $0x40
     f73:	c3                   	ret    

00000f74 <read>:
     f74:	b8 05 00 00 00       	mov    $0x5,%eax
     f79:	cd 40                	int    $0x40
     f7b:	c3                   	ret    

00000f7c <write>:
     f7c:	b8 10 00 00 00       	mov    $0x10,%eax
     f81:	cd 40                	int    $0x40
     f83:	c3                   	ret    

00000f84 <close>:
     f84:	b8 15 00 00 00       	mov    $0x15,%eax
     f89:	cd 40                	int    $0x40
     f8b:	c3                   	ret    

00000f8c <kill>:
     f8c:	b8 06 00 00 00       	mov    $0x6,%eax
     f91:	cd 40                	int    $0x40
     f93:	c3                   	ret    

00000f94 <exec>:
     f94:	b8 07 00 00 00       	mov    $0x7,%eax
     f99:	cd 40                	int    $0x40
     f9b:	c3                   	ret    

00000f9c <open>:
     f9c:	b8 0f 00 00 00       	mov    $0xf,%eax
     fa1:	cd 40                	int    $0x40
     fa3:	c3                   	ret    

00000fa4 <mknod>:
     fa4:	b8 11 00 00 00       	mov    $0x11,%eax
     fa9:	cd 40                	int    $0x40
     fab:	c3                   	ret    

00000fac <unlink>:
     fac:	b8 12 00 00 00       	mov    $0x12,%eax
     fb1:	cd 40                	int    $0x40
     fb3:	c3                   	ret    

00000fb4 <fstat>:
     fb4:	b8 08 00 00 00       	mov    $0x8,%eax
     fb9:	cd 40                	int    $0x40
     fbb:	c3                   	ret    

00000fbc <link>:
     fbc:	b8 13 00 00 00       	mov    $0x13,%eax
     fc1:	cd 40                	int    $0x40
     fc3:	c3                   	ret    

00000fc4 <mkdir>:
     fc4:	b8 14 00 00 00       	mov    $0x14,%eax
     fc9:	cd 40                	int    $0x40
     fcb:	c3                   	ret    

00000fcc <chdir>:
     fcc:	b8 09 00 00 00       	mov    $0x9,%eax
     fd1:	cd 40                	int    $0x40
     fd3:	c3                   	ret    

00000fd4 <dup>:
     fd4:	b8 0a 00 00 00       	mov    $0xa,%eax
     fd9:	cd 40                	int    $0x40
     fdb:	c3                   	ret    

00000fdc <getpid>:
     fdc:	b8 0b 00 00 00       	mov    $0xb,%eax
     fe1:	cd 40                	int    $0x40
     fe3:	c3                   	ret    

00000fe4 <sbrk>:
     fe4:	b8 0c 00 00 00       	mov    $0xc,%eax
     fe9:	cd 40                	int    $0x40
     feb:	c3                   	ret    

00000fec <sleep>:
     fec:	b8 0d 00 00 00       	mov    $0xd,%eax
     ff1:	cd 40                	int    $0x40
     ff3:	c3                   	ret    

00000ff4 <uptime>:
     ff4:	b8 0e 00 00 00       	mov    $0xe,%eax
     ff9:	cd 40                	int    $0x40
     ffb:	c3                   	ret    

00000ffc <putc>:
     ffc:	55                   	push   %ebp
     ffd:	89 e5                	mov    %esp,%ebp
     fff:	83 ec 28             	sub    $0x28,%esp
    1002:	8b 45 0c             	mov    0xc(%ebp),%eax
    1005:	88 45 f4             	mov    %al,-0xc(%ebp)
    1008:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    100f:	00 
    1010:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1013:	89 44 24 04          	mov    %eax,0x4(%esp)
    1017:	8b 45 08             	mov    0x8(%ebp),%eax
    101a:	89 04 24             	mov    %eax,(%esp)
    101d:	e8 5a ff ff ff       	call   f7c <write>
    1022:	c9                   	leave  
    1023:	c3                   	ret    

00001024 <printint>:
    1024:	55                   	push   %ebp
    1025:	89 e5                	mov    %esp,%ebp
    1027:	53                   	push   %ebx
    1028:	83 ec 44             	sub    $0x44,%esp
    102b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1032:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1036:	74 17                	je     104f <printint+0x2b>
    1038:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    103c:	79 11                	jns    104f <printint+0x2b>
    103e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    1045:	8b 45 0c             	mov    0xc(%ebp),%eax
    1048:	f7 d8                	neg    %eax
    104a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    104d:	eb 06                	jmp    1055 <printint+0x31>
    104f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1052:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1055:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    105c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    105f:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1062:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1065:	ba 00 00 00 00       	mov    $0x0,%edx
    106a:	f7 f3                	div    %ebx
    106c:	89 d0                	mov    %edx,%eax
    106e:	0f b6 80 a4 15 00 00 	movzbl 0x15a4(%eax),%eax
    1075:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
    1079:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    107d:	8b 45 10             	mov    0x10(%ebp),%eax
    1080:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1083:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1086:	ba 00 00 00 00       	mov    $0x0,%edx
    108b:	f7 75 d4             	divl   -0x2c(%ebp)
    108e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1091:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1095:	75 c5                	jne    105c <printint+0x38>
    1097:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    109b:	74 28                	je     10c5 <printint+0xa1>
    109d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10a0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
    10a5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    10a9:	eb 1a                	jmp    10c5 <printint+0xa1>
    10ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10ae:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
    10b3:	0f be c0             	movsbl %al,%eax
    10b6:	89 44 24 04          	mov    %eax,0x4(%esp)
    10ba:	8b 45 08             	mov    0x8(%ebp),%eax
    10bd:	89 04 24             	mov    %eax,(%esp)
    10c0:	e8 37 ff ff ff       	call   ffc <putc>
    10c5:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
    10c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10cd:	79 dc                	jns    10ab <printint+0x87>
    10cf:	83 c4 44             	add    $0x44,%esp
    10d2:	5b                   	pop    %ebx
    10d3:	5d                   	pop    %ebp
    10d4:	c3                   	ret    

000010d5 <printf>:
    10d5:	55                   	push   %ebp
    10d6:	89 e5                	mov    %esp,%ebp
    10d8:	83 ec 38             	sub    $0x38,%esp
    10db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    10e2:	8d 45 0c             	lea    0xc(%ebp),%eax
    10e5:	83 c0 04             	add    $0x4,%eax
    10e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    10eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    10f2:	e9 7e 01 00 00       	jmp    1275 <printf+0x1a0>
    10f7:	8b 55 0c             	mov    0xc(%ebp),%edx
    10fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10fd:	8d 04 02             	lea    (%edx,%eax,1),%eax
    1100:	0f b6 00             	movzbl (%eax),%eax
    1103:	0f be c0             	movsbl %al,%eax
    1106:	25 ff 00 00 00       	and    $0xff,%eax
    110b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    110e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1112:	75 2c                	jne    1140 <printf+0x6b>
    1114:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
    1118:	75 0c                	jne    1126 <printf+0x51>
    111a:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
    1121:	e9 4b 01 00 00       	jmp    1271 <printf+0x19c>
    1126:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1129:	0f be c0             	movsbl %al,%eax
    112c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1130:	8b 45 08             	mov    0x8(%ebp),%eax
    1133:	89 04 24             	mov    %eax,(%esp)
    1136:	e8 c1 fe ff ff       	call   ffc <putc>
    113b:	e9 31 01 00 00       	jmp    1271 <printf+0x19c>
    1140:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
    1144:	0f 85 27 01 00 00    	jne    1271 <printf+0x19c>
    114a:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
    114e:	75 2d                	jne    117d <printf+0xa8>
    1150:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1153:	8b 00                	mov    (%eax),%eax
    1155:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    115c:	00 
    115d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1164:	00 
    1165:	89 44 24 04          	mov    %eax,0x4(%esp)
    1169:	8b 45 08             	mov    0x8(%ebp),%eax
    116c:	89 04 24             	mov    %eax,(%esp)
    116f:	e8 b0 fe ff ff       	call   1024 <printint>
    1174:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    1178:	e9 ed 00 00 00       	jmp    126a <printf+0x195>
    117d:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
    1181:	74 06                	je     1189 <printf+0xb4>
    1183:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
    1187:	75 2d                	jne    11b6 <printf+0xe1>
    1189:	8b 45 f4             	mov    -0xc(%ebp),%eax
    118c:	8b 00                	mov    (%eax),%eax
    118e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1195:	00 
    1196:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    119d:	00 
    119e:	89 44 24 04          	mov    %eax,0x4(%esp)
    11a2:	8b 45 08             	mov    0x8(%ebp),%eax
    11a5:	89 04 24             	mov    %eax,(%esp)
    11a8:	e8 77 fe ff ff       	call   1024 <printint>
    11ad:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    11b1:	e9 b4 00 00 00       	jmp    126a <printf+0x195>
    11b6:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
    11ba:	75 46                	jne    1202 <printf+0x12d>
    11bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11bf:	8b 00                	mov    (%eax),%eax
    11c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    11c4:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    11c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    11cc:	75 27                	jne    11f5 <printf+0x120>
    11ce:	c7 45 e4 8c 15 00 00 	movl   $0x158c,-0x1c(%ebp)
    11d5:	eb 1f                	jmp    11f6 <printf+0x121>
    11d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11da:	0f b6 00             	movzbl (%eax),%eax
    11dd:	0f be c0             	movsbl %al,%eax
    11e0:	89 44 24 04          	mov    %eax,0x4(%esp)
    11e4:	8b 45 08             	mov    0x8(%ebp),%eax
    11e7:	89 04 24             	mov    %eax,(%esp)
    11ea:	e8 0d fe ff ff       	call   ffc <putc>
    11ef:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    11f3:	eb 01                	jmp    11f6 <printf+0x121>
    11f5:	90                   	nop
    11f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11f9:	0f b6 00             	movzbl (%eax),%eax
    11fc:	84 c0                	test   %al,%al
    11fe:	75 d7                	jne    11d7 <printf+0x102>
    1200:	eb 68                	jmp    126a <printf+0x195>
    1202:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
    1206:	75 1d                	jne    1225 <printf+0x150>
    1208:	8b 45 f4             	mov    -0xc(%ebp),%eax
    120b:	8b 00                	mov    (%eax),%eax
    120d:	0f be c0             	movsbl %al,%eax
    1210:	89 44 24 04          	mov    %eax,0x4(%esp)
    1214:	8b 45 08             	mov    0x8(%ebp),%eax
    1217:	89 04 24             	mov    %eax,(%esp)
    121a:	e8 dd fd ff ff       	call   ffc <putc>
    121f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    1223:	eb 45                	jmp    126a <printf+0x195>
    1225:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
    1229:	75 17                	jne    1242 <printf+0x16d>
    122b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    122e:	0f be c0             	movsbl %al,%eax
    1231:	89 44 24 04          	mov    %eax,0x4(%esp)
    1235:	8b 45 08             	mov    0x8(%ebp),%eax
    1238:	89 04 24             	mov    %eax,(%esp)
    123b:	e8 bc fd ff ff       	call   ffc <putc>
    1240:	eb 28                	jmp    126a <printf+0x195>
    1242:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1249:	00 
    124a:	8b 45 08             	mov    0x8(%ebp),%eax
    124d:	89 04 24             	mov    %eax,(%esp)
    1250:	e8 a7 fd ff ff       	call   ffc <putc>
    1255:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1258:	0f be c0             	movsbl %al,%eax
    125b:	89 44 24 04          	mov    %eax,0x4(%esp)
    125f:	8b 45 08             	mov    0x8(%ebp),%eax
    1262:	89 04 24             	mov    %eax,(%esp)
    1265:	e8 92 fd ff ff       	call   ffc <putc>
    126a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1271:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    1275:	8b 55 0c             	mov    0xc(%ebp),%edx
    1278:	8b 45 ec             	mov    -0x14(%ebp),%eax
    127b:	8d 04 02             	lea    (%edx,%eax,1),%eax
    127e:	0f b6 00             	movzbl (%eax),%eax
    1281:	84 c0                	test   %al,%al
    1283:	0f 85 6e fe ff ff    	jne    10f7 <printf+0x22>
    1289:	c9                   	leave  
    128a:	c3                   	ret    
    128b:	90                   	nop

0000128c <free>:
    128c:	55                   	push   %ebp
    128d:	89 e5                	mov    %esp,%ebp
    128f:	83 ec 10             	sub    $0x10,%esp
    1292:	8b 45 08             	mov    0x8(%ebp),%eax
    1295:	83 e8 08             	sub    $0x8,%eax
    1298:	89 45 f8             	mov    %eax,-0x8(%ebp)
    129b:	a1 2c 16 00 00       	mov    0x162c,%eax
    12a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12a3:	eb 24                	jmp    12c9 <free+0x3d>
    12a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a8:	8b 00                	mov    (%eax),%eax
    12aa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12ad:	77 12                	ja     12c1 <free+0x35>
    12af:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12b5:	77 24                	ja     12db <free+0x4f>
    12b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12ba:	8b 00                	mov    (%eax),%eax
    12bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12bf:	77 1a                	ja     12db <free+0x4f>
    12c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c4:	8b 00                	mov    (%eax),%eax
    12c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12cf:	76 d4                	jbe    12a5 <free+0x19>
    12d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12d4:	8b 00                	mov    (%eax),%eax
    12d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12d9:	76 ca                	jbe    12a5 <free+0x19>
    12db:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12de:	8b 40 04             	mov    0x4(%eax),%eax
    12e1:	c1 e0 03             	shl    $0x3,%eax
    12e4:	89 c2                	mov    %eax,%edx
    12e6:	03 55 f8             	add    -0x8(%ebp),%edx
    12e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12ec:	8b 00                	mov    (%eax),%eax
    12ee:	39 c2                	cmp    %eax,%edx
    12f0:	75 24                	jne    1316 <free+0x8a>
    12f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12f5:	8b 50 04             	mov    0x4(%eax),%edx
    12f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12fb:	8b 00                	mov    (%eax),%eax
    12fd:	8b 40 04             	mov    0x4(%eax),%eax
    1300:	01 c2                	add    %eax,%edx
    1302:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1305:	89 50 04             	mov    %edx,0x4(%eax)
    1308:	8b 45 fc             	mov    -0x4(%ebp),%eax
    130b:	8b 00                	mov    (%eax),%eax
    130d:	8b 10                	mov    (%eax),%edx
    130f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1312:	89 10                	mov    %edx,(%eax)
    1314:	eb 0a                	jmp    1320 <free+0x94>
    1316:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1319:	8b 10                	mov    (%eax),%edx
    131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    131e:	89 10                	mov    %edx,(%eax)
    1320:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1323:	8b 40 04             	mov    0x4(%eax),%eax
    1326:	c1 e0 03             	shl    $0x3,%eax
    1329:	03 45 fc             	add    -0x4(%ebp),%eax
    132c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    132f:	75 20                	jne    1351 <free+0xc5>
    1331:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1334:	8b 50 04             	mov    0x4(%eax),%edx
    1337:	8b 45 f8             	mov    -0x8(%ebp),%eax
    133a:	8b 40 04             	mov    0x4(%eax),%eax
    133d:	01 c2                	add    %eax,%edx
    133f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1342:	89 50 04             	mov    %edx,0x4(%eax)
    1345:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1348:	8b 10                	mov    (%eax),%edx
    134a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    134d:	89 10                	mov    %edx,(%eax)
    134f:	eb 08                	jmp    1359 <free+0xcd>
    1351:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1354:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1357:	89 10                	mov    %edx,(%eax)
    1359:	8b 45 fc             	mov    -0x4(%ebp),%eax
    135c:	a3 2c 16 00 00       	mov    %eax,0x162c
    1361:	c9                   	leave  
    1362:	c3                   	ret    

00001363 <morecore>:
    1363:	55                   	push   %ebp
    1364:	89 e5                	mov    %esp,%ebp
    1366:	83 ec 28             	sub    $0x28,%esp
    1369:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1370:	77 07                	ja     1379 <morecore+0x16>
    1372:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
    1379:	8b 45 08             	mov    0x8(%ebp),%eax
    137c:	c1 e0 03             	shl    $0x3,%eax
    137f:	89 04 24             	mov    %eax,(%esp)
    1382:	e8 5d fc ff ff       	call   fe4 <sbrk>
    1387:	89 45 f0             	mov    %eax,-0x10(%ebp)
    138a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
    138e:	75 07                	jne    1397 <morecore+0x34>
    1390:	b8 00 00 00 00       	mov    $0x0,%eax
    1395:	eb 22                	jmp    13b9 <morecore+0x56>
    1397:	8b 45 f0             	mov    -0x10(%ebp),%eax
    139a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    139d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a0:	8b 55 08             	mov    0x8(%ebp),%edx
    13a3:	89 50 04             	mov    %edx,0x4(%eax)
    13a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a9:	83 c0 08             	add    $0x8,%eax
    13ac:	89 04 24             	mov    %eax,(%esp)
    13af:	e8 d8 fe ff ff       	call   128c <free>
    13b4:	a1 2c 16 00 00       	mov    0x162c,%eax
    13b9:	c9                   	leave  
    13ba:	c3                   	ret    

000013bb <malloc>:
    13bb:	55                   	push   %ebp
    13bc:	89 e5                	mov    %esp,%ebp
    13be:	83 ec 28             	sub    $0x28,%esp
    13c1:	8b 45 08             	mov    0x8(%ebp),%eax
    13c4:	83 c0 07             	add    $0x7,%eax
    13c7:	c1 e8 03             	shr    $0x3,%eax
    13ca:	83 c0 01             	add    $0x1,%eax
    13cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13d0:	a1 2c 16 00 00       	mov    0x162c,%eax
    13d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    13d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13dc:	75 23                	jne    1401 <malloc+0x46>
    13de:	c7 45 f0 24 16 00 00 	movl   $0x1624,-0x10(%ebp)
    13e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13e8:	a3 2c 16 00 00       	mov    %eax,0x162c
    13ed:	a1 2c 16 00 00       	mov    0x162c,%eax
    13f2:	a3 24 16 00 00       	mov    %eax,0x1624
    13f7:	c7 05 28 16 00 00 00 	movl   $0x0,0x1628
    13fe:	00 00 00 
    1401:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1404:	8b 00                	mov    (%eax),%eax
    1406:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1409:	8b 45 ec             	mov    -0x14(%ebp),%eax
    140c:	8b 40 04             	mov    0x4(%eax),%eax
    140f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1412:	72 4d                	jb     1461 <malloc+0xa6>
    1414:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1417:	8b 40 04             	mov    0x4(%eax),%eax
    141a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    141d:	75 0c                	jne    142b <malloc+0x70>
    141f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1422:	8b 10                	mov    (%eax),%edx
    1424:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1427:	89 10                	mov    %edx,(%eax)
    1429:	eb 26                	jmp    1451 <malloc+0x96>
    142b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    142e:	8b 40 04             	mov    0x4(%eax),%eax
    1431:	89 c2                	mov    %eax,%edx
    1433:	2b 55 f4             	sub    -0xc(%ebp),%edx
    1436:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1439:	89 50 04             	mov    %edx,0x4(%eax)
    143c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    143f:	8b 40 04             	mov    0x4(%eax),%eax
    1442:	c1 e0 03             	shl    $0x3,%eax
    1445:	01 45 ec             	add    %eax,-0x14(%ebp)
    1448:	8b 45 ec             	mov    -0x14(%ebp),%eax
    144b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    144e:	89 50 04             	mov    %edx,0x4(%eax)
    1451:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1454:	a3 2c 16 00 00       	mov    %eax,0x162c
    1459:	8b 45 ec             	mov    -0x14(%ebp),%eax
    145c:	83 c0 08             	add    $0x8,%eax
    145f:	eb 38                	jmp    1499 <malloc+0xde>
    1461:	a1 2c 16 00 00       	mov    0x162c,%eax
    1466:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    1469:	75 1b                	jne    1486 <malloc+0xcb>
    146b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    146e:	89 04 24             	mov    %eax,(%esp)
    1471:	e8 ed fe ff ff       	call   1363 <morecore>
    1476:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1479:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    147d:	75 07                	jne    1486 <malloc+0xcb>
    147f:	b8 00 00 00 00       	mov    $0x0,%eax
    1484:	eb 13                	jmp    1499 <malloc+0xde>
    1486:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1489:	89 45 f0             	mov    %eax,-0x10(%ebp)
    148c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    148f:	8b 00                	mov    (%eax),%eax
    1491:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1494:	e9 70 ff ff ff       	jmp    1409 <malloc+0x4e>
    1499:	c9                   	leave  
    149a:	c3                   	ret    
