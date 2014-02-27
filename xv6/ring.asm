
ring.o:     file format elf32-i386


Disassembly of section .text:

00000000 <ring_size>:
   0:	55                   	push   %ebp
   1:	b8 00 00 04 00       	mov    $0x40000,%eax
   6:	89 e5                	mov    %esp,%ebp
   8:	5d                   	pop    %ebp
   9:	c3                   	ret    
   a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000010 <ring_detach>:
  10:	55                   	push   %ebp
  11:	31 c0                	xor    %eax,%eax
  13:	89 e5                	mov    %esp,%ebp
  15:	5d                   	pop    %ebp
  16:	c3                   	ret    
  17:	89 f6                	mov    %esi,%esi
  19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000020 <ring_write_reserve>:
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	83 ec 10             	sub    $0x10,%esp
  26:	8b 55 0c             	mov    0xc(%ebp),%edx
  29:	89 75 f8             	mov    %esi,-0x8(%ebp)
  2c:	8b 75 10             	mov    0x10(%ebp),%esi
  2f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  32:	8b 45 08             	mov    0x8(%ebp),%eax
  35:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  38:	8b 4a 04             	mov    0x4(%edx),%ecx
  3b:	ba 00 00 01 00       	mov    $0x10000,%edx
  40:	8b 99 0c 00 04 00    	mov    0x4000c(%ecx),%ebx
  46:	0f b7 fb             	movzwl %bx,%edi
  49:	29 da                	sub    %ebx,%edx
  4b:	2b 91 00 00 04 00    	sub    0x40000(%ecx),%edx
  51:	89 7d f0             	mov    %edi,-0x10(%ebp)
  54:	bf 00 00 01 00       	mov    $0x10000,%edi
  59:	2b 7d f0             	sub    -0x10(%ebp),%edi
  5c:	39 fa                	cmp    %edi,%edx
  5e:	0f 4f d7             	cmovg  %edi,%edx
  61:	83 e6 fc             	and    $0xfffffffc,%esi
  64:	39 f2                	cmp    %esi,%edx
  66:	0f 4f d6             	cmovg  %esi,%edx
  69:	8d 34 1a             	lea    (%edx,%ebx,1),%esi
  6c:	89 b1 0c 00 04 00    	mov    %esi,0x4000c(%ecx)
  72:	c1 e2 02             	shl    $0x2,%edx
  75:	8d 0c 99             	lea    (%ecx,%ebx,4),%ecx
  78:	89 48 04             	mov    %ecx,0x4(%eax)
  7b:	89 10                	mov    %edx,(%eax)
  7d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80:	8b 75 f8             	mov    -0x8(%ebp),%esi
  83:	8b 7d fc             	mov    -0x4(%ebp),%edi
  86:	89 ec                	mov    %ebp,%esp
  88:	5d                   	pop    %ebp
  89:	c2 04 00             	ret    $0x4
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000090 <ring_read_reserve>:
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	83 ec 0c             	sub    $0xc,%esp
  96:	8b 55 0c             	mov    0xc(%ebp),%edx
  99:	89 1c 24             	mov    %ebx,(%esp)
  9c:	8b 45 08             	mov    0x8(%ebp),%eax
  9f:	89 74 24 04          	mov    %esi,0x4(%esp)
  a3:	8b 75 10             	mov    0x10(%ebp),%esi
  a6:	89 7c 24 08          	mov    %edi,0x8(%esp)
  aa:	8b 4a 04             	mov    0x4(%edx),%ecx
  ad:	83 e6 fc             	and    $0xfffffffc,%esi
  b0:	8b 99 04 00 04 00    	mov    0x40004(%ecx),%ebx
  b6:	8b 91 08 00 04 00    	mov    0x40008(%ecx),%edx
  bc:	29 da                	sub    %ebx,%edx
  be:	39 f2                	cmp    %esi,%edx
  c0:	0f 4f d6             	cmovg  %esi,%edx
  c3:	0f b7 fb             	movzwl %bx,%edi
  c6:	be 00 00 01 00       	mov    $0x10000,%esi
  cb:	29 fe                	sub    %edi,%esi
  cd:	39 f2                	cmp    %esi,%edx
  cf:	0f 4f d6             	cmovg  %esi,%edx
  d2:	8d 34 1a             	lea    (%edx,%ebx,1),%esi
  d5:	89 b1 04 00 04 00    	mov    %esi,0x40004(%ecx)
  db:	c1 e2 02             	shl    $0x2,%edx
  de:	8d 0c 99             	lea    (%ecx,%ebx,4),%ecx
  e1:	89 48 04             	mov    %ecx,0x4(%eax)
  e4:	89 10                	mov    %edx,(%eax)
  e6:	8b 1c 24             	mov    (%esp),%ebx
  e9:	8b 74 24 04          	mov    0x4(%esp),%esi
  ed:	8b 7c 24 08          	mov    0x8(%esp),%edi
  f1:	89 ec                	mov    %ebp,%esp
  f3:	5d                   	pop    %ebp
  f4:	c2 04 00             	ret    $0x4
  f7:	89 f6                	mov    %esi,%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <ring_write>:
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    
 105:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000110 <ring_read>:
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	5d                   	pop    %ebp
 114:	c3                   	ret    
 115:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000120 <ring_read_notify>:
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	53                   	push   %ebx
 124:	83 ec 14             	sub    $0x14,%esp
 127:	8b 55 08             	mov    0x8(%ebp),%edx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	8b 4a 04             	mov    0x4(%edx),%ecx
 130:	83 e0 fc             	and    $0xfffffffc,%eax
 133:	8b 99 00 00 04 00    	mov    0x40000(%ecx),%ebx
 139:	8b 91 04 00 04 00    	mov    0x40004(%ecx),%edx
 13f:	29 da                	sub    %ebx,%edx
 141:	39 d0                	cmp    %edx,%eax
 143:	7f 12                	jg     157 <ring_read_notify+0x37>
 145:	c1 f8 02             	sar    $0x2,%eax
 148:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
 14b:	89 99 00 00 04 00    	mov    %ebx,0x40000(%ecx)
 151:	83 c4 14             	add    $0x14,%esp
 154:	5b                   	pop    %ebx
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    
 157:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 15e:	00 
 15f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 166:	e8 fc ff ff ff       	call   167 <ring_read_notify+0x47>
 16b:	e8 fc ff ff ff       	call   16c <ring_read_notify+0x4c>

00000170 <ring_write_notify>:
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	53                   	push   %ebx
 174:	83 ec 14             	sub    $0x14,%esp
 177:	8b 55 08             	mov    0x8(%ebp),%edx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	8b 4a 04             	mov    0x4(%edx),%ecx
 180:	83 e0 fc             	and    $0xfffffffc,%eax
 183:	8b 99 08 00 04 00    	mov    0x40008(%ecx),%ebx
 189:	8b 91 0c 00 04 00    	mov    0x4000c(%ecx),%edx
 18f:	29 da                	sub    %ebx,%edx
 191:	39 d0                	cmp    %edx,%eax
 193:	7f 12                	jg     1a7 <ring_write_notify+0x37>
 195:	c1 f8 02             	sar    $0x2,%eax
 198:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
 19b:	89 99 08 00 04 00    	mov    %ebx,0x40008(%ecx)
 1a1:	83 c4 14             	add    $0x14,%esp
 1a4:	5b                   	pop    %ebx
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    
 1a7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
 1ae:	00 
 1af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b6:	e8 fc ff ff ff       	call   1b7 <ring_write_notify+0x47>
 1bb:	e8 fc ff ff ff       	call   1bc <ring_write_notify+0x4c>

000001c0 <ring_attach>:
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	83 ec 14             	sub    $0x14,%esp
 1c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1ca:	c7 44 24 08 00 10 04 	movl   $0x41000,0x8(%esp)
 1d1:	00 
 1d2:	c7 44 24 04 00 e0 fb 	movl   $0x7fbe000,0x4(%esp)
 1d9:	07 
 1da:	89 1c 24             	mov    %ebx,(%esp)
 1dd:	e8 fc ff ff ff       	call   1de <ring_attach+0x1e>
 1e2:	89 c2                	mov    %eax,%edx
 1e4:	31 c0                	xor    %eax,%eax
 1e6:	85 d2                	test   %edx,%edx
 1e8:	79 06                	jns    1f0 <ring_attach+0x30>
 1ea:	83 c4 14             	add    $0x14,%esp
 1ed:	5b                   	pop    %ebx
 1ee:	5d                   	pop    %ebp
 1ef:	c3                   	ret    
 1f0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 1f7:	e8 fc ff ff ff       	call   1f8 <ring_attach+0x38>
 1fc:	85 c0                	test   %eax,%eax
 1fe:	74 ea                	je     1ea <ring_attach+0x2a>
 200:	89 18                	mov    %ebx,(%eax)
 202:	c7 40 04 00 e0 fb 07 	movl   $0x7fbe000,0x4(%eax)
 209:	c7 05 00 e0 ff 07 00 	movl   $0x0,0x7ffe000
 210:	00 00 00 
 213:	c7 05 04 e0 ff 07 00 	movl   $0x0,0x7ffe004
 21a:	00 00 00 
 21d:	c7 05 08 e0 ff 07 00 	movl   $0x0,0x7ffe008
 224:	00 00 00 
 227:	c7 05 0c e0 ff 07 00 	movl   $0x0,0x7ffe00c
 22e:	00 00 00 
 231:	eb b7                	jmp    1ea <ring_attach+0x2a>

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	01 11                	add    %edx,(%ecx)
   2:	01 25 0e 13 0b 03    	add    %esp,0x30b130e
   8:	0e                   	push   %cs
   9:	1b 0e                	sbb    (%esi),%ecx
   b:	11 01                	adc    %eax,(%ecx)
   d:	12 01                	adc    (%ecx),%al
   f:	10 06                	adc    %al,(%esi)
  11:	00 00                	add    %al,(%eax)
  13:	02 16                	add    (%esi),%dl
  15:	00 03                	add    %al,(%ebx)
  17:	0e                   	push   %cs
  18:	3a 0b                	cmp    (%ebx),%cl
  1a:	3b 0b                	cmp    (%ebx),%ecx
  1c:	49                   	dec    %ecx
  1d:	13 00                	adc    (%eax),%eax
  1f:	00 03                	add    %al,(%ebx)
  21:	24 00                	and    $0x0,%al
  23:	0b 0b                	or     (%ebx),%ecx
  25:	3e 0b 03             	or     %ds:(%ebx),%eax
  28:	0e                   	push   %cs
  29:	00 00                	add    %al,(%eax)
  2b:	04 13                	add    $0x13,%al
  2d:	01 03                	add    %eax,(%ebx)
  2f:	0e                   	push   %cs
  30:	0b 0b                	or     (%ebx),%ecx
  32:	3a 0b                	cmp    (%ebx),%cl
  34:	3b 0b                	cmp    (%ebx),%ecx
  36:	01 13                	add    %edx,(%ebx)
  38:	00 00                	add    %al,(%eax)
  3a:	05 0d 00 03 08       	add    $0x803000d,%eax
  3f:	3a 0b                	cmp    (%ebx),%cl
  41:	3b 0b                	cmp    (%ebx),%ecx
  43:	49                   	dec    %ecx
  44:	13 38                	adc    (%eax),%edi
  46:	0d 00 00 06 0f       	or     $0xf060000,%eax
  4b:	00 0b                	add    %cl,(%ebx)
  4d:	0b 00                	or     (%eax),%eax
  4f:	00 07                	add    %al,(%edi)
  51:	0d 00 03 0e 3a       	or     $0x3a0e0300,%eax
  56:	0b 3b                	or     (%ebx),%edi
  58:	0b 49 13             	or     0x13(%ecx),%ecx
  5b:	38 0d 00 00 08 2e    	cmp    %cl,0x2e080000
  61:	01 3f                	add    %edi,(%edi)
  63:	0c 03                	or     $0x3,%al
  65:	0e                   	push   %cs
  66:	3a 0b                	cmp    (%ebx),%cl
  68:	3b 0b                	cmp    (%ebx),%ecx
  6a:	27                   	daa    
  6b:	0c 49                	or     $0x49,%al
  6d:	13 11                	adc    (%ecx),%edx
  6f:	01 12                	add    %edx,(%edx)
  71:	01 40 0a             	add    %eax,0xa(%eax)
  74:	01 13                	add    %edx,(%ebx)
  76:	00 00                	add    %al,(%eax)
  78:	09 05 00 03 0e 3a    	or     %eax,0x3a0e0300
  7e:	0b 3b                	or     (%ebx),%edi
  80:	0b 49 13             	or     0x13(%ecx),%ecx
  83:	02 0a                	add    (%edx),%cl
  85:	00 00                	add    %al,(%eax)
  87:	0a 24 00             	or     (%eax,%eax,1),%ah
  8a:	0b 0b                	or     (%ebx),%ecx
  8c:	3e 0b 03             	or     %ds:(%ebx),%eax
  8f:	08 00                	or     %al,(%eax)
  91:	00 0b                	add    %cl,(%ebx)
  93:	05 00 03 08 3a       	add    $0x3a080300,%eax
  98:	0b 3b                	or     (%ebx),%edi
  9a:	0b 49 13             	or     0x13(%ecx),%ecx
  9d:	02 0a                	add    (%edx),%cl
  9f:	00 00                	add    %al,(%eax)
  a1:	0c 05                	or     $0x5,%al
  a3:	00 03                	add    %al,(%ebx)
  a5:	0e                   	push   %cs
  a6:	3a 0b                	cmp    (%ebx),%cl
  a8:	3b 0b                	cmp    (%ebx),%ecx
  aa:	49                   	dec    %ecx
  ab:	13 02                	adc    (%edx),%eax
  ad:	06                   	push   %es
  ae:	00 00                	add    %al,(%eax)
  b0:	0d 34 00 03 0e       	or     $0xe030034,%eax
  b5:	3a 0b                	cmp    (%ebx),%cl
  b7:	3b 0b                	cmp    (%ebx),%ecx
  b9:	49                   	dec    %ecx
  ba:	13 02                	adc    (%edx),%eax
  bc:	06                   	push   %es
  bd:	00 00                	add    %al,(%eax)
  bf:	0e                   	push   %cs
  c0:	34 00                	xor    $0x0,%al
  c2:	03 08                	add    (%eax),%ecx
  c4:	3a 0b                	cmp    (%ebx),%cl
  c6:	3b 0b                	cmp    (%ebx),%ecx
  c8:	49                   	dec    %ecx
  c9:	13 02                	adc    (%edx),%eax
  cb:	06                   	push   %es
  cc:	00 00                	add    %al,(%eax)
  ce:	0f                   	(bad)  
  cf:	0f 00 0b             	str    (%ebx)
  d2:	0b 49 13             	or     0x13(%ecx),%ecx
  d5:	00 00                	add    %al,(%eax)
  d7:	10 2e                	adc    %ch,(%esi)
  d9:	01 3f                	add    %edi,(%edi)
  db:	0c 03                	or     $0x3,%al
  dd:	0e                   	push   %cs
  de:	3a 0b                	cmp    (%ebx),%cl
  e0:	3b 0b                	cmp    (%ebx),%ecx
  e2:	27                   	daa    
  e3:	0c 11                	or     $0x11,%al
  e5:	01 12                	add    %edx,(%edx)
  e7:	01 40 0a             	add    %eax,0xa(%eax)
  ea:	01 13                	add    %edx,(%ebx)
  ec:	00 00                	add    %al,(%eax)
  ee:	11 34 00             	adc    %esi,(%eax,%eax,1)
  f1:	03 08                	add    (%eax),%ecx
  f3:	3a 0b                	cmp    (%ebx),%cl
  f5:	3b 0b                	cmp    (%ebx),%ecx
  f7:	49                   	dec    %ecx
  f8:	13 02                	adc    (%edx),%eax
  fa:	0a 00                	or     (%eax),%al
  fc:	00 12                	add    %dl,(%edx)
  fe:	34 00                	xor    $0x0,%al
 100:	03 08                	add    (%eax),%ecx
 102:	3a 0b                	cmp    (%ebx),%cl
 104:	3b 0b                	cmp    (%ebx),%ecx
 106:	49                   	dec    %ecx
 107:	13 1c 06             	adc    (%esi,%eax,1),%ebx
 10a:	00 00                	add    %al,(%eax)
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	cb                   	lret   
   1:	02 00                	add    (%eax),%al
   3:	00 03                	add    %al,(%ebx)
   5:	00 00                	add    %al,(%eax)
   7:	00 00                	add    %al,(%eax)
   9:	00 04 01             	add    %al,(%ecx,%eax,1)
   c:	b8 00 00 00 01       	mov    $0x1000000,%eax
  11:	36 00 00             	add    %al,%ss:(%eax)
  14:	00 59 00             	add    %bl,0x0(%ecx)
  17:	00 00                	add    %al,(%eax)
  19:	00 00                	add    %al,(%eax)
  1b:	00 00                	add    %al,(%eax)
  1d:	33 02                	xor    (%edx),%eax
  1f:	00 00                	add    %al,(%eax)
  21:	00 00                	add    %al,(%eax)
  23:	00 00                	add    %al,(%eax)
  25:	02 3d 00 00 00 03    	add    0x3000000,%bh
  2b:	01 30                	add    %esi,(%eax)
  2d:	00 00                	add    %al,(%eax)
  2f:	00 03                	add    %al,(%ebx)
  31:	04 07                	add    $0x7,%al
  33:	1f                   	pop    %ds
  34:	00 00                	add    %al,(%eax)
  36:	00 03                	add    %al,(%ebx)
  38:	02 07                	add    (%edi),%al
  3a:	f0 00 00             	lock add %al,(%eax)
  3d:	00 03                	add    %al,(%ebx)
  3f:	01 08                	add    %ecx,(%eax)
  41:	a1 00 00 00 04       	mov    0x4000000,%eax
  46:	54                   	push   %esp
  47:	00 00                	add    %al,(%eax)
  49:	00 08                	add    %cl,(%eax)
  4b:	02 06                	add    (%esi),%al
  4d:	6a 00                	push   $0x0
  4f:	00 00                	add    %al,(%eax)
  51:	05 74 6f 6b 00       	add    $0x6b6f74,%eax
  56:	02 07                	add    (%edi),%al
  58:	30 00                	xor    %al,(%eax)
  5a:	00 00                	add    %al,(%eax)
  5c:	00 05 62 75 66 00    	add    %al,0x667562
  62:	02 08                	add    (%eax),%cl
  64:	6a 00                	push   $0x0
  66:	00 00                	add    %al,(%eax)
  68:	04 00                	add    $0x0,%al
  6a:	06                   	push   %es
  6b:	04 04                	add    $0x4,%al
  6d:	af                   	scas   %es:(%edi),%eax
  6e:	00 00                	add    %al,(%eax)
  70:	00 08                	add    %cl,(%eax)
  72:	02 0b                	add    (%ebx),%cl
  74:	91                   	xchg   %eax,%ecx
  75:	00 00                	add    %al,(%eax)
  77:	00 07                	add    %al,(%edi)
  79:	0d 01 00 00 02       	or     $0x2000001,%eax
  7e:	0c 30                	or     $0x30,%al
  80:	00 00                	add    %al,(%eax)
  82:	00 00                	add    %al,(%eax)
  84:	05 62 75 66 00       	add    $0x667562,%eax
  89:	02 0d 6a 00 00 00    	add    0x6a,%cl
  8f:	04 00                	add    $0x0,%al
  91:	08 01                	or     %al,(%ecx)
  93:	2c 00                	sub    $0x0,%al
  95:	00 00                	add    %al,(%eax)
  97:	01 30                	add    %esi,(%eax)
  99:	01 bb 00 00 00 00    	add    %edi,0x0(%ebx)
  9f:	00 00                	add    %al,(%eax)
  a1:	00 0a                	add    %cl,(%edx)
  a3:	00 00                	add    %al,(%eax)
  a5:	00 01                	add    %al,(%ecx)
  a7:	9c                   	pushf  
  a8:	bb 00 00 00 09       	mov    $0x9000000,%ebx
  ad:	24 01                	and    $0x1,%al
  af:	00 00                	add    %al,(%eax)
  b1:	01 30                	add    %esi,(%eax)
  b3:	25 00 00 00 02       	and    $0x2000000,%eax
  b8:	91                   	xchg   %eax,%ecx
  b9:	00 00                	add    %al,(%eax)
  bb:	0a 04 05 69 6e 74 00 	or     0x746e69(,%eax,1),%al
  c2:	08 01                	or     %al,(%ecx)
  c4:	18 01                	sbb    %al,(%ecx)
  c6:	00 00                	add    %al,(%eax)
  c8:	01 35 01 bb 00 00    	add    %esi,0xbb01
  ce:	00 10                	add    %dl,(%eax)
  d0:	00 00                	add    %al,(%eax)
  d2:	00 17                	add    %dl,(%edi)
  d4:	00 00                	add    %al,(%eax)
  d6:	00 01                	add    %al,(%ecx)
  d8:	9c                   	pushf  
  d9:	ec                   	in     (%dx),%al
  da:	00 00                	add    %al,(%eax)
  dc:	00 09                	add    %cl,(%ecx)
  de:	24 01                	and    $0x1,%al
  e0:	00 00                	add    %al,(%eax)
  e2:	01 35 25 00 00 00    	add    %esi,0x25
  e8:	02 91 00 00 08 01    	add    0x1080000(%ecx),%dl
  ee:	0c 00                	or     $0x0,%al
  f0:	00 00                	add    %al,(%eax)
  f2:	01 45 01             	add    %eax,0x1(%ebp)
  f5:	6c                   	insb   (%dx),%es:(%edi)
  f6:	00 00                	add    %al,(%eax)
  f8:	00 20                	add    %ah,(%eax)
  fa:	00 00                	add    %al,(%eax)
  fc:	00 8c 00 00 00 01 9c 	add    %cl,-0x63ff0000(%eax,%eax,1)
 103:	41                   	inc    %ecx
 104:	01 00                	add    %eax,(%eax)
 106:	00 0b                	add    %cl,(%ebx)
 108:	72 00                	jb     10a <.debug_info+0x10a>
 10a:	01 45 41             	add    %eax,0x41(%ebp)
 10d:	01 00                	add    %eax,(%eax)
 10f:	00 02                	add    %al,(%edx)
 111:	91                   	xchg   %eax,%ecx
 112:	04 0c                	add    $0xc,%al
 114:	12 01                	adc    (%ecx),%al
 116:	00 00                	add    %al,(%eax)
 118:	01 45 bb             	add    %eax,-0x45(%ebp)
 11b:	00 00                	add    %al,(%eax)
 11d:	00 00                	add    %al,(%eax)
 11f:	00 00                	add    %al,(%eax)
 121:	00 0d 2a 01 00 00    	add    %cl,0x12a
 127:	01 4e bb             	add    %ecx,-0x45(%esi)
 12a:	00 00                	add    %al,(%eax)
 12c:	00 25 00 00 00 0e    	add    %ah,0xe000000
 132:	72 65                	jb     199 <.debug_info+0x199>
 134:	74 00                	je     136 <.debug_info+0x136>
 136:	01 51 6c             	add    %edx,0x6c(%ecx)
 139:	00 00                	add    %al,(%eax)
 13b:	00 38                	add    %bh,(%eax)
 13d:	00 00                	add    %al,(%eax)
 13f:	00 00                	add    %al,(%eax)
 141:	0f 04                	(bad)  
 143:	45                   	inc    %ebp
 144:	00 00                	add    %al,(%eax)
 146:	00 08                	add    %cl,(%eax)
 148:	01 42 00             	add    %eax,0x0(%edx)
 14b:	00 00                	add    %al,(%eax)
 14d:	01 6c 01 6c          	add    %ebp,0x6c(%ecx,%eax,1)
 151:	00 00                	add    %al,(%eax)
 153:	00 90 00 00 00 f7    	add    %dl,-0x9000000(%eax)
 159:	00 00                	add    %al,(%eax)
 15b:	00 01                	add    %al,(%ecx)
 15d:	9c                   	pushf  
 15e:	9c                   	pushf  
 15f:	01 00                	add    %eax,(%eax)
 161:	00 0b                	add    %cl,(%ebx)
 163:	72 00                	jb     165 <.debug_info+0x165>
 165:	01 6c 41 01          	add    %ebp,0x1(%ecx,%eax,2)
 169:	00 00                	add    %al,(%eax)
 16b:	02 91 04 0c 12 01    	add    0x1120c04(%ecx),%dl
 171:	00 00                	add    %al,(%eax)
 173:	01 6c bb 00          	add    %ebp,0x0(%ebx,%edi,4)
 177:	00 00                	add    %al,(%eax)
 179:	72 00                	jb     17b <.debug_info+0x17b>
 17b:	00 00                	add    %al,(%eax)
 17d:	0d 2a 01 00 00       	or     $0x12a,%eax
 182:	01 75 bb             	add    %esi,-0x45(%ebp)
 185:	00 00                	add    %al,(%eax)
 187:	00 97 00 00 00 0e    	add    %dl,0xe000000(%edi)
 18d:	72 65                	jb     1f4 <.debug_info+0x1f4>
 18f:	74 00                	je     191 <.debug_info+0x191>
 191:	01 78 6c             	add    %edi,0x6c(%eax)
 194:	00 00                	add    %al,(%eax)
 196:	00 aa 00 00 00 00    	add    %ch,0x0(%edx)
 19c:	10 01                	adc    %al,(%ecx)
 19e:	96                   	xchg   %eax,%esi
 19f:	00 00                	add    %al,(%eax)
 1a1:	00 01                	add    %al,(%ecx)
 1a3:	93                   	xchg   %eax,%ebx
 1a4:	01 00                	add    %eax,(%eax)
 1a6:	01 00                	add    %eax,(%eax)
 1a8:	00 05 01 00 00 01    	add    %al,0x1000001
 1ae:	9c                   	pushf  
 1af:	dc 01                	faddl  (%ecx)
 1b1:	00 00                	add    %al,(%eax)
 1b3:	0b 72 00             	or     0x0(%edx),%esi
 1b6:	01 93 41 01 00 00    	add    %edx,0x141(%ebx)
 1bc:	02 91 00 0b 62 75    	add    0x75620b00(%ecx),%dl
 1c2:	66                   	data16
 1c3:	00 01                	add    %al,(%ecx)
 1c5:	93                   	xchg   %eax,%ebx
 1c6:	6a 00                	push   $0x0
 1c8:	00 00                	add    %al,(%eax)
 1ca:	02 91 04 09 12 01    	add    0x1120904(%ecx),%dl
 1d0:	00 00                	add    %al,(%eax)
 1d2:	01 93 bb 00 00 00    	add    %edx,0xbb(%ebx)
 1d8:	02 91 08 00 10 01    	add    0x1100008(%ecx),%dl
 1de:	03 01                	add    (%ecx),%eax
 1e0:	00 00                	add    %al,(%eax)
 1e2:	01 98 01 10 01 00    	add    %ebx,0x11001(%eax)
 1e8:	00 15 01 00 00 01    	add    %dl,0x1000001
 1ee:	9c                   	pushf  
 1ef:	1c 02                	sbb    $0x2,%al
 1f1:	00 00                	add    %al,(%eax)
 1f3:	0b 72 00             	or     0x0(%edx),%esi
 1f6:	01 98 41 01 00 00    	add    %ebx,0x141(%eax)
 1fc:	02 91 00 0b 62 75    	add    0x75620b00(%ecx),%dl
 202:	66                   	data16
 203:	00 01                	add    %al,(%ecx)
 205:	98                   	cwtl   
 206:	6a 00                	push   $0x0
 208:	00 00                	add    %al,(%eax)
 20a:	02 91 04 09 12 01    	add    0x1120904(%ecx),%dl
 210:	00 00                	add    %al,(%eax)
 212:	01 98 bb 00 00 00    	add    %ebx,0xbb(%eax)
 218:	02 91 08 00 10 01    	add    0x1100008(%ecx),%dl
 21e:	df 00                	fild   (%eax)
 220:	00 00                	add    %al,(%eax)
 222:	01 83 01 20 01 00    	add    %eax,0x12001(%ebx)
 228:	00 70 01             	add    %dh,0x1(%eax)
 22b:	00 00                	add    %al,(%eax)
 22d:	01 9c 4f 02 00 00 0b 	add    %ebx,0xb000002(%edi,%ecx,2)
 234:	72 00                	jb     236 <.debug_info+0x236>
 236:	01 83 41 01 00 00    	add    %eax,0x141(%ebx)
 23c:	02 91 00 0c 12 01    	add    0x1120c00(%ecx),%dl
 242:	00 00                	add    %al,(%eax)
 244:	01 83 bb 00 00 00    	add    %eax,0xbb(%ebx)
 24a:	e4 00                	in     $0x0,%al
 24c:	00 00                	add    %al,(%eax)
 24e:	00 10                	add    %dl,(%eax)
 250:	01 84 00 00 00 01 5c 	add    %eax,0x5c010000(%eax,%eax,1)
 257:	01 70 01             	add    %esi,0x1(%eax)
 25a:	00 00                	add    %al,(%eax)
 25c:	c0 01 00             	rolb   $0x0,(%ecx)
 25f:	00 01                	add    %al,(%ecx)
 261:	9c                   	pushf  
 262:	82                   	(bad)  
 263:	02 00                	add    (%eax),%al
 265:	00 0b                	add    %cl,(%ebx)
 267:	72 00                	jb     269 <.debug_info+0x269>
 269:	01 5c 41 01          	add    %ebx,0x1(%ecx,%eax,2)
 26d:	00 00                	add    %al,(%eax)
 26f:	02 91 00 0c 12 01    	add    0x1120c00(%ecx),%dl
 275:	00 00                	add    %al,(%eax)
 277:	01 5c bb 00          	add    %ebx,0x0(%ebx,%edi,4)
 27b:	00 00                	add    %al,(%eax)
 27d:	0e                   	push   %cs
 27e:	01 00                	add    %eax,(%eax)
 280:	00 00                	add    %al,(%eax)
 282:	08 01                	or     %al,(%ecx)
 284:	00 00                	add    %al,(%eax)
 286:	00 00                	add    %al,(%eax)
 288:	01 1b                	add    %ebx,(%ebx)
 28a:	01 41 01             	add    %eax,0x1(%ecx)
 28d:	00 00                	add    %al,(%eax)
 28f:	c0 01 00             	rolb   $0x0,(%ecx)
 292:	00 33                	add    %dh,(%ebx)
 294:	02 00                	add    (%eax),%al
 296:	00 01                	add    %al,(%ecx)
 298:	9c                   	pushf  
 299:	c8 02 00 00          	enter  $0x2,$0x0
 29d:	09 24 01             	or     %esp,(%ecx,%eax,1)
 2a0:	00 00                	add    %al,(%eax)
 2a2:	01 1b                	add    %ebx,(%ebx)
 2a4:	25 00 00 00 02       	and    $0x2000000,%eax
 2a9:	91                   	xchg   %eax,%ecx
 2aa:	00 11                	add    %dl,(%ecx)
 2ac:	72 65                	jb     313 <ring_attach+0x153>
 2ae:	74 00                	je     2b0 <.debug_info+0x2b0>
 2b0:	01 1f                	add    %ebx,(%edi)
 2b2:	41                   	inc    %ecx
 2b3:	01 00                	add    %eax,(%eax)
 2b5:	00 01                	add    %al,(%ecx)
 2b7:	50                   	push   %eax
 2b8:	12 74 6d 70          	adc    0x70(%ebp,%ebp,2),%dh
 2bc:	00 01                	add    %al,(%ecx)
 2be:	27                   	daa    
 2bf:	c8 02 00 00          	enter  $0x2,$0x0
 2c3:	00 e0                	add    %ah,%al
 2c5:	fb                   	sti    
 2c6:	07                   	pop    %es
 2c7:	00 0f                	add    %cl,(%edi)
 2c9:	04 bb                	add    $0xbb,%al
 2cb:	00 00                	add    %al,(%eax)
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	aa                   	stos   %al,%es:(%edi)
   1:	00 00                	add    %al,(%eax)
   3:	00 02                	add    %al,(%edx)
   5:	00 32                	add    %dh,(%edx)
   7:	00 00                	add    %al,(%eax)
   9:	00 01                	add    %al,(%ecx)
   b:	01 fb                	add    %edi,%ebx
   d:	0e                   	push   %cs
   e:	0d 00 01 01 01       	or     $0x1010100,%eax
  13:	01 00                	add    %eax,(%eax)
  15:	00 00                	add    %al,(%eax)
  17:	01 00                	add    %eax,(%eax)
  19:	00 01                	add    %al,(%ecx)
  1b:	00 72 69             	add    %dh,0x69(%edx)
  1e:	6e                   	outsb  %ds:(%esi),(%dx)
  1f:	67 2e 63 00          	arpl   %ax,%cs:(%bx,%si)
  23:	00 00                	add    %al,(%eax)
  25:	00 72 69             	add    %dh,0x69(%edx)
  28:	6e                   	outsb  %ds:(%esi),(%dx)
  29:	67                   	addr16
  2a:	2e                   	cs
  2b:	68 00 00 00 00       	push   $0x0
  30:	74 79                	je     ab <.debug_line+0xab>
  32:	70 65                	jo     99 <.debug_line+0x99>
  34:	73 2e                	jae    64 <.debug_line+0x64>
  36:	68 00 00 00 00       	push   $0x0
  3b:	00 00                	add    %al,(%eax)
  3d:	05 02 00 00 00       	add    $0x2,%eax
  42:	00 03                	add    %al,(%ebx)
  44:	30 01                	xor    %al,(%ecx)
  46:	22 56 30             	and    0x30(%esi),%dl
  49:	85 24 2a             	test   %esp,(%edx,%ebp,1)
  4c:	32 03                	xor    (%ebx),%al
  4e:	0c ac                	or     $0xac,%al
  50:	6e                   	outsb  %ds:(%esi),(%dx)
  51:	03 78 3c             	add    0x3c(%eax),%edi
  54:	ec                   	in     (%dx),%al
  55:	03 09                	add    (%ecx),%ecx
  57:	02 31                	add    (%ecx),%dh
  59:	01 92 ad 03 13 08    	add    %edx,0x81303ad(%edx)
  5f:	2e 6e                	outsb  %cs:(%esi),(%dx)
  61:	03 78 3c             	add    0x3c(%eax),%edi
  64:	08 1a                	or     %bl,(%edx)
  66:	03 09                	add    (%ecx),%ecx
  68:	02 28                	add    (%eax),%ch
  6a:	01 92 ad 03 13 08    	add    %edx,0x81303ad(%edx)
  70:	90                   	nop
  71:	3e                   	ds
  72:	cb                   	lret   
  73:	3e 03 69 c8          	add    %ds:-0x38(%ecx),%ebp
  77:	79 37                	jns    b0 <ring_read_reserve+0x20>
  79:	41                   	inc    %ecx
  7a:	39 3f                	cmp    %edi,(%edi)
  7c:	08 27                	or     %ah,(%edi)
  7e:	bb 03 7a 66 08       	mov    $0x8667a03,%ebx
  83:	3d 03 51 58 79       	cmp    $0x79585103,%eax
  88:	37                   	aaa    
  89:	41                   	inc    %ecx
  8a:	39 3f                	cmp    %edi,(%edi)
  8c:	08 27                	or     %ah,(%edi)
  8e:	bb 03 7a 66 08       	mov    $0x8667a03,%ebx
  93:	3d 03 b7 7f 58       	cmp    $0x587fb703,%eax
  98:	74 3d                	je     d7 <ring_read_reserve+0x47>
  9a:	03 11                	add    (%ecx),%edx
  9c:	08 e4                	or     %ah,%ah
  9e:	03 71 66             	add    0x66(%ecx),%esi
  a1:	bb 4d 2f 78 9f       	mov    $0x9f782f4d,%ebx
  a6:	9f                   	lahf   
  a7:	9f                   	lahf   
  a8:	a0 02 02 00 01       	mov    0x1000202,%al
  ad:	01                   	.byte 0x1

Disassembly of section .rodata.str1.4:

00000000 <.rodata.str1.4>:
   0:	45                   	inc    %ebp
   1:	52                   	push   %edx
   2:	52                   	push   %edx
   3:	4f                   	dec    %edi
   4:	52                   	push   %edx
   5:	20 2d 20 52 65 71    	and    %ch,0x71655220
   b:	75 65                	jne    72 <ring_write_reserve+0x52>
   d:	73 74                	jae    83 <ring_write_reserve+0x63>
   f:	65 64 20 74 6f 20    	gs and %dh,%fs:%gs:0x20(%edi,%ebp,2)
  15:	72 65                	jb     7c <ring_write_reserve+0x5c>
  17:	61                   	popa   
  18:	64                   	fs
  19:	2d 6e 6f 74 69       	sub    $0x69746f6e,%eax
  1e:	66                   	data16
  1f:	79 20                	jns    41 <.rodata.str1.4+0x41>
  21:	74 6f                	je     92 <ring_read_reserve+0x2>
  23:	6f                   	outsl  %ds:(%esi),(%dx)
  24:	20 6d 61             	and    %ch,0x61(%ebp)
  27:	6e                   	outsb  %ds:(%esi),(%dx)
  28:	79 20                	jns    4a <.rodata.str1.4+0x4a>
  2a:	62 79 74             	bound  %edi,0x74(%ecx)
  2d:	65                   	gs
  2e:	73 0a                	jae    3a <.rodata.str1.4+0x3a>
  30:	00 00                	add    %al,(%eax)
  32:	00 00                	add    %al,(%eax)
  34:	45                   	inc    %ebp
  35:	52                   	push   %edx
  36:	52                   	push   %edx
  37:	4f                   	dec    %edi
  38:	52                   	push   %edx
  39:	20 2d 20 52 65 71    	and    %ch,0x71655220
  3f:	75 65                	jne    a6 <ring_read_reserve+0x16>
  41:	73 74                	jae    b7 <ring_read_reserve+0x27>
  43:	65 64 20 74 6f 20    	gs and %dh,%fs:%gs:0x20(%edi,%ebp,2)
  49:	77 72                	ja     bd <ring_read_reserve+0x2d>
  4b:	69 74 65 2d 6e 6f 74 	imul   $0x69746f6e,0x2d(%ebp,%eiz,2),%esi
  52:	69 
  53:	66                   	data16
  54:	79 20                	jns    76 <ring_write_reserve+0x56>
  56:	74 6f                	je     c7 <ring_read_reserve+0x37>
  58:	6f                   	outsl  %ds:(%esi),(%dx)
  59:	20 6d 61             	and    %ch,0x61(%ebp)
  5c:	6e                   	outsb  %ds:(%esi),(%dx)
  5d:	79 20                	jns    7f <ring_write_reserve+0x5f>
  5f:	62 79 74             	bound  %edi,0x74(%ecx)
  62:	65                   	gs
  63:	73 0a                	jae    6f <ring_write_reserve+0x4f>
	...

Disassembly of section .debug_loc:

00000000 <.debug_loc>:
   0:	20 00                	and    %al,(%eax)
   2:	00 00                	add    %al,(%eax)
   4:	2f                   	das    
   5:	00 00                	add    %al,(%eax)
   7:	00 02                	add    %al,(%edx)
   9:	00 91 08 2f 00 00    	add    %dl,0x2f08(%ecx)
   f:	00 8c 00 00 00 07 00 	add    %cl,0x70000(%eax,%eax,1)
  16:	91                   	xchg   %eax,%ecx
  17:	08 06                	or     %al,(%esi)
  19:	09 fc                	or     %edi,%esp
  1b:	1a 9f 00 00 00 00    	sbb    0x0(%edi),%bl
  21:	00 00                	add    %al,(%eax)
  23:	00 00                	add    %al,(%eax)
  25:	69 00 00 00 75 00    	imul   $0x750000,(%eax),%eax
  2b:	00 00                	add    %al,(%eax)
  2d:	01 00                	add    %eax,(%eax)
  2f:	52                   	push   %edx
	...
  38:	69 00 00 00 75 00    	imul   $0x750000,(%eax),%eax
  3e:	00 00                	add    %al,(%eax)
  40:	09 00                	or     %eax,(%eax)
  42:	72 00                	jb     44 <.debug_loc+0x44>
  44:	32 24 9f             	xor    (%edi,%ebx,4),%ah
  47:	93                   	xchg   %eax,%ebx
  48:	04 93                	add    $0x93,%al
  4a:	04 75                	add    $0x75,%al
  4c:	00 00                	add    %al,(%eax)
  4e:	00 78 00             	add    %bh,0x0(%eax)
  51:	00 00                	add    %al,(%eax)
  53:	05 00 52 93 04       	add    $0x4935200,%eax
  58:	93                   	xchg   %eax,%ebx
  59:	04 78                	add    $0x78,%al
  5b:	00 00                	add    %al,(%eax)
  5d:	00 8c 00 00 00 06 00 	add    %cl,0x60000(%eax,%eax,1)
  64:	52                   	push   %edx
  65:	93                   	xchg   %eax,%ebx
  66:	04 51                	add    $0x51,%al
  68:	93                   	xchg   %eax,%ebx
  69:	04 00                	add    $0x0,%al
  6b:	00 00                	add    %al,(%eax)
  6d:	00 00                	add    %al,(%eax)
  6f:	00 00                	add    %al,(%eax)
  71:	00 90 00 00 00 a6    	add    %dl,-0x5a000000(%eax)
  77:	00 00                	add    %al,(%eax)
  79:	00 02                	add    %al,(%edx)
  7b:	00 91 08 a6 00 00    	add    %dl,0xa608(%ecx)
  81:	00 f7                	add    %dh,%bh
  83:	00 00                	add    %al,(%eax)
  85:	00 07                	add    %al,(%edi)
  87:	00 91 08 06 09 fc    	add    %dl,-0x3f6f9f8(%ecx)
  8d:	1a 9f 00 00 00 00    	sbb    0x0(%edi),%bl
  93:	00 00                	add    %al,(%eax)
  95:	00 00                	add    %al,(%eax)
  97:	d2 00                	rolb   %cl,(%eax)
  99:	00 00                	add    %al,(%eax)
  9b:	de 00                	fiadd  (%eax)
  9d:	00 00                	add    %al,(%eax)
  9f:	01 00                	add    %eax,(%eax)
  a1:	52                   	push   %edx
	...
  aa:	d2 00                	rolb   %cl,(%eax)
  ac:	00 00                	add    %al,(%eax)
  ae:	de 00                	fiadd  (%eax)
  b0:	00 00                	add    %al,(%eax)
  b2:	09 00                	or     %eax,(%eax)
  b4:	72 00                	jb     b6 <.debug_loc+0xb6>
  b6:	32 24 9f             	xor    (%edi,%ebx,4),%ah
  b9:	93                   	xchg   %eax,%ebx
  ba:	04 93                	add    $0x93,%al
  bc:	04 de                	add    $0xde,%al
  be:	00 00                	add    %al,(%eax)
  c0:	00 e1                	add    %ah,%cl
  c2:	00 00                	add    %al,(%eax)
  c4:	00 05 00 52 93 04    	add    %al,0x4935200
  ca:	93                   	xchg   %eax,%ebx
  cb:	04 e1                	add    $0xe1,%al
  cd:	00 00                	add    %al,(%eax)
  cf:	00 f7                	add    %dh,%bh
  d1:	00 00                	add    %al,(%eax)
  d3:	00 06                	add    %al,(%esi)
  d5:	00 52 93             	add    %dl,-0x6d(%edx)
  d8:	04 51                	add    $0x51,%al
  da:	93                   	xchg   %eax,%ebx
  db:	04 00                	add    $0x0,%al
  dd:	00 00                	add    %al,(%eax)
  df:	00 00                	add    %al,(%eax)
  e1:	00 00                	add    %al,(%eax)
  e3:	00 20                	add    %ah,(%eax)
  e5:	01 00                	add    %eax,(%eax)
  e7:	00 33                	add    %dh,(%ebx)
  e9:	01 00                	add    %eax,(%eax)
  eb:	00 02                	add    %al,(%edx)
  ed:	00 91 04 33 01 00    	add    %dl,0x13304(%ecx)
  f3:	00 48 01             	add    %cl,0x1(%eax)
  f6:	00 00                	add    %al,(%eax)
  f8:	01 00                	add    %eax,(%eax)
  fa:	50                   	push   %eax
  fb:	57                   	push   %edi
  fc:	01 00                	add    %eax,(%eax)
  fe:	00 6a 01             	add    %ch,0x1(%edx)
 101:	00 00                	add    %al,(%eax)
 103:	01 00                	add    %eax,(%eax)
 105:	50                   	push   %eax
	...
 10e:	70 01                	jo     111 <.debug_loc+0x111>
 110:	00 00                	add    %al,(%eax)
 112:	83 01 00             	addl   $0x0,(%ecx)
 115:	00 02                	add    %al,(%edx)
 117:	00 91 04 83 01 00    	add    %dl,0x18304(%ecx)
 11d:	00 98 01 00 00 01    	add    %bl,0x1000001(%eax)
 123:	00 50 a7             	add    %dl,-0x59(%eax)
 126:	01 00                	add    %eax,(%eax)
 128:	00 ba 01 00 00 01    	add    %bh,0x1000001(%edx)
 12e:	00 50 00             	add    %dl,0x0(%eax)
 131:	00 00                	add    %al,(%eax)
 133:	00 00                	add    %al,(%eax)
 135:	00 00                	add    %al,(%eax)
	...

Disassembly of section .debug_pubnames:

00000000 <.debug_pubnames>:
   0:	b1 00                	mov    $0x0,%cl
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	00 00                	add    %al,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	cf                   	iret   
   b:	02 00                	add    (%eax),%al
   d:	00 91 00 00 00 72    	add    %dl,0x72000000(%ecx)
  13:	69 6e 67 5f 73 69 7a 	imul   $0x7a69735f,0x67(%esi),%ebp
  1a:	65                   	gs
  1b:	00 c2                	add    %al,%dl
  1d:	00 00                	add    %al,(%eax)
  1f:	00 72 69             	add    %dh,0x69(%edx)
  22:	6e                   	outsb  %ds:(%esi),(%dx)
  23:	67 5f                	addr16 pop %edi
  25:	64                   	fs
  26:	65                   	gs
  27:	74 61                	je     8a <.debug_pubnames+0x8a>
  29:	63 68 00             	arpl   %bp,0x0(%eax)
  2c:	ec                   	in     (%dx),%al
  2d:	00 00                	add    %al,(%eax)
  2f:	00 72 69             	add    %dh,0x69(%edx)
  32:	6e                   	outsb  %ds:(%esi),(%dx)
  33:	67 5f                	addr16 pop %edi
  35:	77 72                	ja     a9 <.debug_pubnames+0xa9>
  37:	69 74 65 5f 72 65 73 	imul   $0x65736572,0x5f(%ebp,%eiz,2),%esi
  3e:	65 
  3f:	72 76                	jb     b7 <ring_read_reserve+0x27>
  41:	65 00 47 01          	add    %al,%gs:0x1(%edi)
  45:	00 00                	add    %al,(%eax)
  47:	72 69                	jb     b2 <.debug_pubnames+0xb2>
  49:	6e                   	outsb  %ds:(%esi),(%dx)
  4a:	67 5f                	addr16 pop %edi
  4c:	72 65                	jb     b3 <.debug_pubnames+0xb3>
  4e:	61                   	popa   
  4f:	64                   	fs
  50:	5f                   	pop    %edi
  51:	72 65                	jb     b8 <ring_read_reserve+0x28>
  53:	73 65                	jae    ba <ring_read_reserve+0x2a>
  55:	72 76                	jb     cd <ring_read_reserve+0x3d>
  57:	65 00 9c 01 00 00 72 	add    %bl,%gs:0x69720000(%ecx,%eax,1)
  5e:	69 
  5f:	6e                   	outsb  %ds:(%esi),(%dx)
  60:	67 5f                	addr16 pop %edi
  62:	77 72                	ja     d6 <ring_read_reserve+0x46>
  64:	69 74 65 00 dc 01 00 	imul   $0x1dc,0x0(%ebp,%eiz,2),%esi
  6b:	00 
  6c:	72 69                	jb     d7 <ring_read_reserve+0x47>
  6e:	6e                   	outsb  %ds:(%esi),(%dx)
  6f:	67 5f                	addr16 pop %edi
  71:	72 65                	jb     d8 <ring_read_reserve+0x48>
  73:	61                   	popa   
  74:	64 00 1c 02          	add    %bl,%fs:(%edx,%eax,1)
  78:	00 00                	add    %al,(%eax)
  7a:	72 69                	jb     e5 <ring_read_reserve+0x55>
  7c:	6e                   	outsb  %ds:(%esi),(%dx)
  7d:	67 5f                	addr16 pop %edi
  7f:	72 65                	jb     e6 <ring_read_reserve+0x56>
  81:	61                   	popa   
  82:	64                   	fs
  83:	5f                   	pop    %edi
  84:	6e                   	outsb  %ds:(%esi),(%dx)
  85:	6f                   	outsl  %ds:(%esi),(%dx)
  86:	74 69                	je     f1 <ring_read_reserve+0x61>
  88:	66                   	data16
  89:	79 00                	jns    8b <.debug_pubnames+0x8b>
  8b:	4f                   	dec    %edi
  8c:	02 00                	add    (%eax),%al
  8e:	00 72 69             	add    %dh,0x69(%edx)
  91:	6e                   	outsb  %ds:(%esi),(%dx)
  92:	67 5f                	addr16 pop %edi
  94:	77 72                	ja     108 <ring_write+0x8>
  96:	69 74 65 5f 6e 6f 74 	imul   $0x69746f6e,0x5f(%ebp,%eiz,2),%esi
  9d:	69 
  9e:	66                   	data16
  9f:	79 00                	jns    a1 <.debug_pubnames+0xa1>
  a1:	82                   	(bad)  
  a2:	02 00                	add    (%eax),%al
  a4:	00 72 69             	add    %dh,0x69(%edx)
  a7:	6e                   	outsb  %ds:(%esi),(%dx)
  a8:	67 5f                	addr16 pop %edi
  aa:	61                   	popa   
  ab:	74 74                	je     121 <ring_read_notify+0x1>
  ad:	61                   	popa   
  ae:	63 68 00             	arpl   %bp,0x0(%eax)
  b1:	00 00                	add    %al,(%eax)
	...

Disassembly of section .debug_pubtypes:

00000000 <.debug_pubtypes>:
   0:	2d 00 00 00 02       	sub    $0x2000000,%eax
   5:	00 00                	add    %al,(%eax)
   7:	00 00                	add    %al,(%eax)
   9:	00 cf                	add    %cl,%bh
   b:	02 00                	add    (%eax),%al
   d:	00 25 00 00 00 75    	add    %ah,0x75000000
  13:	69 6e 74 00 45 00 00 	imul   $0x4500,0x74(%esi),%ebp
  1a:	00 72 69             	add    %dh,0x69(%edx)
  1d:	6e                   	outsb  %ds:(%esi),(%dx)
  1e:	67 00 6c 00          	add    %ch,0x0(%si)
  22:	00 00                	add    %al,(%eax)
  24:	72 69                	jb     8f <ring_write_reserve+0x6f>
  26:	6e                   	outsb  %ds:(%esi),(%dx)
  27:	67 5f                	addr16 pop %edi
  29:	72 65                	jb     90 <ring_read_reserve>
  2b:	73 00                	jae    2d <.debug_pubtypes+0x2d>
  2d:	00 00                	add    %al,(%eax)
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	1c 00                	sbb    $0x0,%al
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	00 00                	add    %al,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	04 00                	add    $0x0,%al
	...
  14:	33 02                	xor    (%edx),%eax
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	72 69                	jb     6b <.debug_str+0x6b>
   2:	6e                   	outsb  %ds:(%esi),(%dx)
   3:	67 5f                	addr16 pop %edi
   5:	61                   	popa   
   6:	74 74                	je     7c <.debug_str+0x7c>
   8:	61                   	popa   
   9:	63 68 00             	arpl   %bp,0x0(%eax)
   c:	72 69                	jb     77 <.debug_str+0x77>
   e:	6e                   	outsb  %ds:(%esi),(%dx)
   f:	67 5f                	addr16 pop %edi
  11:	77 72                	ja     85 <.debug_str+0x85>
  13:	69 74 65 5f 72 65 73 	imul   $0x65736572,0x5f(%ebp,%eiz,2),%esi
  1a:	65 
  1b:	72 76                	jb     93 <.debug_str+0x93>
  1d:	65 00 75 6e          	add    %dh,%gs:0x6e(%ebp)
  21:	73 69                	jae    8c <.debug_str+0x8c>
  23:	67 6e                	outsb  %ds:(%si),(%dx)
  25:	65 64 20 69 6e       	gs and %ch,%fs:%gs:0x6e(%ecx)
  2a:	74 00                	je     2c <.debug_str+0x2c>
  2c:	72 69                	jb     97 <.debug_str+0x97>
  2e:	6e                   	outsb  %ds:(%esi),(%dx)
  2f:	67 5f                	addr16 pop %edi
  31:	73 69                	jae    9c <.debug_str+0x9c>
  33:	7a 65                	jp     9a <.debug_str+0x9a>
  35:	00 72 69             	add    %dh,0x69(%edx)
  38:	6e                   	outsb  %ds:(%esi),(%dx)
  39:	67 2e 63 00          	arpl   %ax,%cs:(%bx,%si)
  3d:	75 69                	jne    a8 <.debug_str+0xa8>
  3f:	6e                   	outsb  %ds:(%esi),(%dx)
  40:	74 00                	je     42 <.debug_str+0x42>
  42:	72 69                	jb     ad <.debug_str+0xad>
  44:	6e                   	outsb  %ds:(%esi),(%dx)
  45:	67 5f                	addr16 pop %edi
  47:	72 65                	jb     ae <.debug_str+0xae>
  49:	61                   	popa   
  4a:	64                   	fs
  4b:	5f                   	pop    %edi
  4c:	72 65                	jb     b3 <.debug_str+0xb3>
  4e:	73 65                	jae    b5 <.debug_str+0xb5>
  50:	72 76                	jb     c8 <.debug_str+0xc8>
  52:	65 00 72 69          	add    %dh,%gs:0x69(%edx)
  56:	6e                   	outsb  %ds:(%esi),(%dx)
  57:	67 00 2f             	add    %ch,(%bx)
  5a:	68 6f 6d 65 2f       	push   $0x2f656d6f
  5f:	61                   	popa   
  60:	70 61                	jo     c3 <.debug_str+0xc3>
  62:	72 6b                	jb     cf <.debug_str+0xcf>
  64:	69 6e 73 2f 41 64 76 	imul   $0x7664412f,0x73(%esi),%ebp
  6b:	4f                   	dec    %edi
  6c:	53                   	push   %ebx
  6d:	2f                   	das    
  6e:	61                   	popa   
  6f:	64                   	fs
  70:	76 61                	jbe    d3 <.debug_str+0xd3>
  72:	6e                   	outsb  %ds:(%esi),(%dx)
  73:	63 65 64             	arpl   %sp,0x64(%ebp)
  76:	5f                   	pop    %edi
  77:	6f                   	outsl  %ds:(%esi),(%dx)
  78:	73 5f                	jae    d9 <.debug_str+0xd9>
  7a:	63 6c 61 73          	arpl   %bp,0x73(%ecx,%eiz,2)
  7e:	73 2f                	jae    af <.debug_str+0xaf>
  80:	78 76                	js     f8 <.debug_str+0xf8>
  82:	36 00 72 69          	add    %dh,%ss:0x69(%edx)
  86:	6e                   	outsb  %ds:(%esi),(%dx)
  87:	67 5f                	addr16 pop %edi
  89:	77 72                	ja     fd <.debug_str+0xfd>
  8b:	69 74 65 5f 6e 6f 74 	imul   $0x69746f6e,0x5f(%ebp,%eiz,2),%esi
  92:	69 
  93:	66                   	data16
  94:	79 00                	jns    96 <.debug_str+0x96>
  96:	72 69                	jb     101 <.debug_str+0x101>
  98:	6e                   	outsb  %ds:(%esi),(%dx)
  99:	67 5f                	addr16 pop %edi
  9b:	77 72                	ja     10f <.debug_str+0x10f>
  9d:	69 74 65 00 75 6e 73 	imul   $0x69736e75,0x0(%ebp,%eiz,2),%esi
  a4:	69 
  a5:	67 6e                	outsb  %ds:(%si),(%dx)
  a7:	65 64 20 63 68       	gs and %ah,%fs:%gs:0x68(%ebx)
  ac:	61                   	popa   
  ad:	72 00                	jb     af <.debug_str+0xaf>
  af:	72 69                	jb     11a <.debug_str+0x11a>
  b1:	6e                   	outsb  %ds:(%esi),(%dx)
  b2:	67 5f                	addr16 pop %edi
  b4:	72 65                	jb     11b <.debug_str+0x11b>
  b6:	73 00                	jae    b8 <.debug_str+0xb8>
  b8:	47                   	inc    %edi
  b9:	4e                   	dec    %esi
  ba:	55                   	push   %ebp
  bb:	20 43 20             	and    %al,0x20(%ebx)
  be:	34 2e                	xor    $0x2e,%al
  c0:	34 2e                	xor    $0x2e,%al
  c2:	37                   	aaa    
  c3:	20 32                	and    %dh,(%edx)
  c5:	30 31                	xor    %dh,(%ecx)
  c7:	32 30                	xor    (%eax),%dh
  c9:	33 31                	xor    (%ecx),%esi
  cb:	33 20                	xor    (%eax),%esp
  cd:	28 52 65             	sub    %dl,0x65(%edx)
  d0:	64 20 48 61          	and    %cl,%fs:0x61(%eax)
  d4:	74 20                	je     f6 <.debug_str+0xf6>
  d6:	34 2e                	xor    $0x2e,%al
  d8:	34 2e                	xor    $0x2e,%al
  da:	37                   	aaa    
  db:	2d 33 29 00 72       	sub    $0x72002933,%eax
  e0:	69 6e 67 5f 72 65 61 	imul   $0x6165725f,0x67(%esi),%ebp
  e7:	64                   	fs
  e8:	5f                   	pop    %edi
  e9:	6e                   	outsb  %ds:(%esi),(%dx)
  ea:	6f                   	outsl  %ds:(%esi),(%dx)
  eb:	74 69                	je     156 <ring_read_notify+0x36>
  ed:	66                   	data16
  ee:	79 00                	jns    f0 <.debug_str+0xf0>
  f0:	73 68                	jae    15a <ring_read_notify+0x3a>
  f2:	6f                   	outsl  %ds:(%esi),(%dx)
  f3:	72 74                	jb     169 <ring_read_notify+0x49>
  f5:	20 75 6e             	and    %dh,0x6e(%ebp)
  f8:	73 69                	jae    163 <ring_read_notify+0x43>
  fa:	67 6e                	outsb  %ds:(%si),(%dx)
  fc:	65 64 20 69 6e       	gs and %ch,%fs:%gs:0x6e(%ecx)
 101:	74 00                	je     103 <.debug_str+0x103>
 103:	72 69                	jb     16e <ring_read_notify+0x4e>
 105:	6e                   	outsb  %ds:(%esi),(%dx)
 106:	67 5f                	addr16 pop %edi
 108:	72 65                	jb     16f <ring_read_notify+0x4f>
 10a:	61                   	popa   
 10b:	64 00 73 69          	add    %dh,%fs:0x69(%ebx)
 10f:	7a 65                	jp     176 <ring_write_notify+0x6>
 111:	00 62 79             	add    %ah,0x79(%edx)
 114:	74 65                	je     17b <ring_write_notify+0xb>
 116:	73 00                	jae    118 <.debug_str+0x118>
 118:	72 69                	jb     183 <ring_write_notify+0x13>
 11a:	6e                   	outsb  %ds:(%esi),(%dx)
 11b:	67 5f                	addr16 pop %edi
 11d:	64                   	fs
 11e:	65                   	gs
 11f:	74 61                	je     182 <ring_write_notify+0x12>
 121:	63 68 00             	arpl   %bp,0x0(%eax)
 124:	74 6f                	je     195 <ring_write_notify+0x25>
 126:	6b 65 6e 00          	imul   $0x0,0x6e(%ebp),%esp
 12a:	72 65                	jb     191 <ring_write_notify+0x21>
 12c:	74 5f                	je     18d <ring_write_notify+0x1d>
 12e:	73 69                	jae    199 <ring_write_notify+0x29>
 130:	7a 65                	jp     197 <ring_write_notify+0x27>
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	00 47 43             	add    %al,0x43(%edi)
   3:	43                   	inc    %ebx
   4:	3a 20                	cmp    (%eax),%ah
   6:	28 47 4e             	sub    %al,0x4e(%edi)
   9:	55                   	push   %ebp
   a:	29 20                	sub    %esp,(%eax)
   c:	34 2e                	xor    $0x2e,%al
   e:	34 2e                	xor    $0x2e,%al
  10:	37                   	aaa    
  11:	20 32                	and    %dh,(%edx)
  13:	30 31                	xor    %dh,(%ecx)
  15:	32 30                	xor    (%eax),%dh
  17:	33 31                	xor    (%ecx),%esi
  19:	33 20                	xor    (%eax),%esp
  1b:	28 52 65             	sub    %dl,0x65(%edx)
  1e:	64 20 48 61          	and    %cl,%fs:0x61(%eax)
  22:	74 20                	je     44 <ring_write_reserve+0x24>
  24:	34 2e                	xor    $0x2e,%al
  26:	34 2e                	xor    $0x2e,%al
  28:	37                   	aaa    
  29:	2d                   	.byte 0x2d
  2a:	33 29                	xor    (%ecx),%ebp
	...

Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	10 00                	adc    %al,(%eax)
   2:	00 00                	add    %al,(%eax)
   4:	ff                   	(bad)  
   5:	ff                   	(bad)  
   6:	ff                   	(bad)  
   7:	ff 01                	incl   (%ecx)
   9:	00 01                	add    %al,(%ecx)
   b:	7c 08                	jl     15 <.debug_frame+0x15>
   d:	0c 04                	or     $0x4,%al
   f:	04 88                	add    $0x88,%al
  11:	01 00                	add    %eax,(%eax)
  13:	00 1c 00             	add    %bl,(%eax,%eax,1)
	...
  1e:	00 00                	add    %al,(%eax)
  20:	0a 00                	or     (%eax),%al
  22:	00 00                	add    %al,(%eax)
  24:	41                   	inc    %ecx
  25:	0e                   	push   %cs
  26:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
  2c:	41                   	inc    %ecx
  2d:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  30:	04 00                	add    $0x0,%al
  32:	00 00                	add    %al,(%eax)
  34:	1c 00                	sbb    $0x0,%al
  36:	00 00                	add    %al,(%eax)
  38:	00 00                	add    %al,(%eax)
  3a:	00 00                	add    %al,(%eax)
  3c:	10 00                	adc    %al,(%eax)
  3e:	00 00                	add    %al,(%eax)
  40:	07                   	pop    %es
  41:	00 00                	add    %al,(%eax)
  43:	00 41 0e             	add    %al,0xe(%ecx)
  46:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  4c:	41                   	inc    %ecx
  4d:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  50:	04 00                	add    $0x0,%al
  52:	00 00                	add    %al,(%eax)
  54:	28 00                	sub    %al,(%eax)
  56:	00 00                	add    %al,(%eax)
  58:	00 00                	add    %al,(%eax)
  5a:	00 00                	add    %al,(%eax)
  5c:	20 00                	and    %al,(%eax)
  5e:	00 00                	add    %al,(%eax)
  60:	6c                   	insb   (%dx),%es:(%edi)
  61:	00 00                	add    %al,(%eax)
  63:	00 41 0e             	add    %al,0xe(%ecx)
  66:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  6c:	4c                   	dec    %esp
  6d:	86 04 57             	xchg   %al,(%edi,%edx,2)
  70:	83 05 87 03 02 42 0d 	addl   $0xd,0x42020387
  77:	04 c7                	add    $0xc7,%al
  79:	c6 c3 41             	mov    $0x41,%bl
  7c:	c5 0e                	lds    (%esi),%ecx
  7e:	04 00                	add    $0x0,%al
  80:	28 00                	sub    %al,(%eax)
  82:	00 00                	add    %al,(%eax)
  84:	00 00                	add    %al,(%eax)
  86:	00 00                	add    %al,(%eax)
  88:	90                   	nop
  89:	00 00                	add    %al,(%eax)
  8b:	00 67 00             	add    %ah,0x0(%edi)
  8e:	00 00                	add    %al,(%eax)
  90:	41                   	inc    %ecx
  91:	0e                   	push   %cs
  92:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  98:	53                   	push   %ebx
  99:	86 04 83             	xchg   %al,(%ebx,%eax,4)
  9c:	05 60 87 03 6d       	add    $0x6d038760,%eax
  a1:	0d 04 c7 c6 c3       	or     $0xc3c6c704,%eax
  a6:	41                   	inc    %ecx
  a7:	c5 0e                	lds    (%esi),%ecx
  a9:	04 00                	add    $0x0,%al
  ab:	00 1c 00             	add    %bl,(%eax,%eax,1)
  ae:	00 00                	add    %al,(%eax)
  b0:	00 00                	add    %al,(%eax)
  b2:	00 00                	add    %al,(%eax)
  b4:	00 01                	add    %al,(%ecx)
  b6:	00 00                	add    %al,(%eax)
  b8:	05 00 00 00 41       	add    $0x41000000,%eax
  bd:	0e                   	push   %cs
  be:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  c4:	41                   	inc    %ecx
  c5:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  c8:	04 00                	add    $0x0,%al
  ca:	00 00                	add    %al,(%eax)
  cc:	1c 00                	sbb    $0x0,%al
  ce:	00 00                	add    %al,(%eax)
  d0:	00 00                	add    %al,(%eax)
  d2:	00 00                	add    %al,(%eax)
  d4:	10 01                	adc    %al,(%ecx)
  d6:	00 00                	add    %al,(%eax)
  d8:	05 00 00 00 41       	add    $0x41000000,%eax
  dd:	0e                   	push   %cs
  de:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  e4:	41                   	inc    %ecx
  e5:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  e8:	04 00                	add    $0x0,%al
  ea:	00 00                	add    %al,(%eax)
  ec:	24 00                	and    $0x0,%al
  ee:	00 00                	add    %al,(%eax)
  f0:	00 00                	add    %al,(%eax)
  f2:	00 00                	add    %al,(%eax)
  f4:	20 01                	and    %al,(%ecx)
  f6:	00 00                	add    %al,(%eax)
  f8:	50                   	push   %eax
  f9:	00 00                	add    %al,(%eax)
  fb:	00 41 0e             	add    %al,0xe(%ecx)
  fe:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 104:	56                   	push   %esi
 105:	83 03 5c             	addl   $0x5c,(%ebx)
 108:	0a c3                	or     %bl,%al
 10a:	41                   	inc    %ecx
 10b:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 10e:	04 41                	add    $0x41,%al
 110:	0b 00                	or     (%eax),%eax
 112:	00 00                	add    %al,(%eax)
 114:	24 00                	and    $0x0,%al
 116:	00 00                	add    %al,(%eax)
 118:	00 00                	add    %al,(%eax)
 11a:	00 00                	add    %al,(%eax)
 11c:	70 01                	jo     11f <.debug_frame+0x11f>
 11e:	00 00                	add    %al,(%eax)
 120:	50                   	push   %eax
 121:	00 00                	add    %al,(%eax)
 123:	00 41 0e             	add    %al,0xe(%ecx)
 126:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 12c:	56                   	push   %esi
 12d:	83 03 5c             	addl   $0x5c,(%ebx)
 130:	0a c3                	or     %bl,%al
 132:	41                   	inc    %ecx
 133:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 136:	04 41                	add    $0x41,%al
 138:	0b 00                	or     (%eax),%eax
 13a:	00 00                	add    %al,(%eax)
 13c:	24 00                	and    $0x0,%al
 13e:	00 00                	add    %al,(%eax)
 140:	00 00                	add    %al,(%eax)
 142:	00 00                	add    %al,(%eax)
 144:	c0 01 00             	rolb   $0x0,(%ecx)
 147:	00 73 00             	add    %dh,0x0(%ebx)
 14a:	00 00                	add    %al,(%eax)
 14c:	41                   	inc    %ecx
 14d:	0e                   	push   %cs
 14e:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 154:	47                   	inc    %edi
 155:	83 03 64             	addl   $0x64,(%ebx)
 158:	0a c3                	or     %bl,%al
 15a:	41                   	inc    %ecx
 15b:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 15e:	04 41                	add    $0x41,%al
 160:	0b 00                	or     (%eax),%eax
	...
