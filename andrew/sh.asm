
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <nulterminate>:
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	53                   	push   %ebx
       4:	83 ec 14             	sub    $0x14,%esp
       7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       a:	85 db                	test   %ebx,%ebx
       c:	74 05                	je     13 <nulterminate+0x13>
    return 0;
  
  switch(cmd->type){
       e:	83 3b 05             	cmpl   $0x5,(%ebx)
      11:	76 0d                	jbe    20 <nulterminate+0x20>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      13:	89 d8                	mov    %ebx,%eax
      15:	83 c4 14             	add    $0x14,%esp
      18:	5b                   	pop    %ebx
      19:	5d                   	pop    %ebp
      1a:	c3                   	ret    
      1b:	90                   	nop
      1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;
  
  switch(cmd->type){
      20:	8b 03                	mov    (%ebx),%eax
      22:	ff 24 85 18 13 00 00 	jmp    *0x1318(,%eax,4)
      29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    nulterminate(pcmd->right);
    break;
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
      30:	8b 43 04             	mov    0x4(%ebx),%eax
      33:	89 04 24             	mov    %eax,(%esp)
      36:	e8 c5 ff ff ff       	call   0 <nulterminate>
    nulterminate(lcmd->right);
      3b:	8b 43 08             	mov    0x8(%ebx),%eax
      3e:	89 04 24             	mov    %eax,(%esp)
      41:	e8 ba ff ff ff       	call   0 <nulterminate>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      46:	89 d8                	mov    %ebx,%eax
      48:	83 c4 14             	add    $0x14,%esp
      4b:	5b                   	pop    %ebx
      4c:	5d                   	pop    %ebp
      4d:	c3                   	ret    
      4e:	66 90                	xchg   %ax,%ax
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
      50:	8b 43 04             	mov    0x4(%ebx),%eax
      53:	89 04 24             	mov    %eax,(%esp)
      56:	e8 a5 ff ff ff       	call   0 <nulterminate>
    break;
  }
  return cmd;
}
      5b:	89 d8                	mov    %ebx,%eax
      5d:	83 c4 14             	add    $0x14,%esp
      60:	5b                   	pop    %ebx
      61:	5d                   	pop    %ebp
      62:	c3                   	ret    
      63:	90                   	nop
      64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
      68:	8b 43 04             	mov    0x4(%ebx),%eax
      6b:	89 04 24             	mov    %eax,(%esp)
      6e:	e8 8d ff ff ff       	call   0 <nulterminate>
    *rcmd->efile = 0;
      73:	8b 43 0c             	mov    0xc(%ebx),%eax
      76:	c6 00 00             	movb   $0x0,(%eax)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      79:	89 d8                	mov    %ebx,%eax
      7b:	83 c4 14             	add    $0x14,%esp
      7e:	5b                   	pop    %ebx
      7f:	5d                   	pop    %ebp
      80:	c3                   	ret    
      81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      88:	8b 43 04             	mov    0x4(%ebx),%eax
      8b:	85 c0                	test   %eax,%eax
      8d:	74 84                	je     13 <nulterminate+0x13>
      8f:	89 d8                	mov    %ebx,%eax
      91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
      98:	8b 50 2c             	mov    0x2c(%eax),%edx
      9b:	c6 02 00             	movb   $0x0,(%edx)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      9e:	8b 50 08             	mov    0x8(%eax),%edx
      a1:	83 c0 04             	add    $0x4,%eax
      a4:	85 d2                	test   %edx,%edx
      a6:	75 f0                	jne    98 <nulterminate+0x98>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      a8:	89 d8                	mov    %ebx,%eax
      aa:	83 c4 14             	add    $0x14,%esp
      ad:	5b                   	pop    %ebx
      ae:	5d                   	pop    %ebp
      af:	c3                   	ret    

000000b0 <peek>:
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
      b0:	55                   	push   %ebp
      b1:	89 e5                	mov    %esp,%ebp
      b3:	57                   	push   %edi
      b4:	56                   	push   %esi
      b5:	53                   	push   %ebx
      b6:	83 ec 1c             	sub    $0x1c,%esp
      b9:	8b 7d 08             	mov    0x8(%ebp),%edi
      bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;
  
  s = *ps;
      bf:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
      c1:	39 f3                	cmp    %esi,%ebx
      c3:	72 0a                	jb     cf <peek+0x1f>
      c5:	eb 1f                	jmp    e6 <peek+0x36>
      c7:	90                   	nop
    s++;
      c8:	83 c3 01             	add    $0x1,%ebx
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
      cb:	39 de                	cmp    %ebx,%esi
      cd:	76 17                	jbe    e6 <peek+0x36>
      cf:	0f be 03             	movsbl (%ebx),%eax
      d2:	c7 04 24 18 14 00 00 	movl   $0x1418,(%esp)
      d9:	89 44 24 04          	mov    %eax,0x4(%esp)
      dd:	e8 1e 0c 00 00       	call   d00 <strchr>
      e2:	85 c0                	test   %eax,%eax
      e4:	75 e2                	jne    c8 <peek+0x18>
    s++;
  *ps = s;
      e6:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
      e8:	0f b6 13             	movzbl (%ebx),%edx
      eb:	31 c0                	xor    %eax,%eax
      ed:	84 d2                	test   %dl,%dl
      ef:	75 0f                	jne    100 <peek+0x50>
}
      f1:	83 c4 1c             	add    $0x1c,%esp
      f4:	5b                   	pop    %ebx
      f5:	5e                   	pop    %esi
      f6:	5f                   	pop    %edi
      f7:	5d                   	pop    %ebp
      f8:	c3                   	ret    
      f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
     100:	8b 45 10             	mov    0x10(%ebp),%eax
     103:	0f be d2             	movsbl %dl,%edx
     106:	89 54 24 04          	mov    %edx,0x4(%esp)
     10a:	89 04 24             	mov    %eax,(%esp)
     10d:	e8 ee 0b 00 00       	call   d00 <strchr>
     112:	85 c0                	test   %eax,%eax
     114:	0f 95 c0             	setne  %al
}
     117:	83 c4 1c             	add    $0x1c,%esp
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
     11a:	0f b6 c0             	movzbl %al,%eax
}
     11d:	5b                   	pop    %ebx
     11e:	5e                   	pop    %esi
     11f:	5f                   	pop    %edi
     120:	5d                   	pop    %ebp
     121:	c3                   	ret    
     122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     130:	55                   	push   %ebp
     131:	89 e5                	mov    %esp,%ebp
     133:	57                   	push   %edi
     134:	56                   	push   %esi
     135:	53                   	push   %ebx
     136:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int ret;
  
  s = *ps;
     139:	8b 45 08             	mov    0x8(%ebp),%eax
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     13c:	8b 75 0c             	mov    0xc(%ebp),%esi
     13f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;
  
  s = *ps;
     142:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
     144:	39 f3                	cmp    %esi,%ebx
     146:	72 0f                	jb     157 <gettoken+0x27>
     148:	eb 24                	jmp    16e <gettoken+0x3e>
     14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     150:	83 c3 01             	add    $0x1,%ebx
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     153:	39 de                	cmp    %ebx,%esi
     155:	76 17                	jbe    16e <gettoken+0x3e>
     157:	0f be 03             	movsbl (%ebx),%eax
     15a:	c7 04 24 18 14 00 00 	movl   $0x1418,(%esp)
     161:	89 44 24 04          	mov    %eax,0x4(%esp)
     165:	e8 96 0b 00 00       	call   d00 <strchr>
     16a:	85 c0                	test   %eax,%eax
     16c:	75 e2                	jne    150 <gettoken+0x20>
    s++;
  if(q)
     16e:	85 ff                	test   %edi,%edi
     170:	74 02                	je     174 <gettoken+0x44>
    *q = s;
     172:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
     174:	0f b6 13             	movzbl (%ebx),%edx
     177:	0f be fa             	movsbl %dl,%edi
  switch(*s){
     17a:	80 fa 3c             	cmp    $0x3c,%dl
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
     17d:	89 f8                	mov    %edi,%eax
  switch(*s){
     17f:	7f 4f                	jg     1d0 <gettoken+0xa0>
     181:	80 fa 3b             	cmp    $0x3b,%dl
     184:	0f 8c 9e 00 00 00    	jl     228 <gettoken+0xf8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     18a:	83 c3 01             	add    $0x1,%ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     18d:	8b 55 14             	mov    0x14(%ebp),%edx
     190:	85 d2                	test   %edx,%edx
     192:	74 05                	je     199 <gettoken+0x69>
    *eq = s;
     194:	8b 45 14             	mov    0x14(%ebp),%eax
     197:	89 18                	mov    %ebx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     199:	39 f3                	cmp    %esi,%ebx
     19b:	72 0a                	jb     1a7 <gettoken+0x77>
     19d:	eb 1f                	jmp    1be <gettoken+0x8e>
     19f:	90                   	nop
    s++;
     1a0:	83 c3 01             	add    $0x1,%ebx
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     1a3:	39 de                	cmp    %ebx,%esi
     1a5:	76 17                	jbe    1be <gettoken+0x8e>
     1a7:	0f be 03             	movsbl (%ebx),%eax
     1aa:	c7 04 24 18 14 00 00 	movl   $0x1418,(%esp)
     1b1:	89 44 24 04          	mov    %eax,0x4(%esp)
     1b5:	e8 46 0b 00 00       	call   d00 <strchr>
     1ba:	85 c0                	test   %eax,%eax
     1bc:	75 e2                	jne    1a0 <gettoken+0x70>
    s++;
  *ps = s;
     1be:	8b 45 08             	mov    0x8(%ebp),%eax
     1c1:	89 18                	mov    %ebx,(%eax)
  return ret;
}
     1c3:	83 c4 1c             	add    $0x1c,%esp
     1c6:	89 f8                	mov    %edi,%eax
     1c8:	5b                   	pop    %ebx
     1c9:	5e                   	pop    %esi
     1ca:	5f                   	pop    %edi
     1cb:	5d                   	pop    %ebp
     1cc:	c3                   	ret    
     1cd:	8d 76 00             	lea    0x0(%esi),%esi
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     1d0:	80 fa 3e             	cmp    $0x3e,%dl
     1d3:	74 73                	je     248 <gettoken+0x118>
     1d5:	80 fa 7c             	cmp    $0x7c,%dl
     1d8:	74 b0                	je     18a <gettoken+0x5a>
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     1da:	39 de                	cmp    %ebx,%esi
     1dc:	77 2b                	ja     209 <gettoken+0xd9>
     1de:	66 90                	xchg   %ax,%ax
     1e0:	eb 3b                	jmp    21d <gettoken+0xed>
     1e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     1e8:	0f be 03             	movsbl (%ebx),%eax
     1eb:	c7 04 24 1e 14 00 00 	movl   $0x141e,(%esp)
     1f2:	89 44 24 04          	mov    %eax,0x4(%esp)
     1f6:	e8 05 0b 00 00       	call   d00 <strchr>
     1fb:	85 c0                	test   %eax,%eax
     1fd:	75 1e                	jne    21d <gettoken+0xed>
      s++;
     1ff:	83 c3 01             	add    $0x1,%ebx
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     202:	39 de                	cmp    %ebx,%esi
     204:	76 17                	jbe    21d <gettoken+0xed>
     206:	0f be 03             	movsbl (%ebx),%eax
     209:	89 44 24 04          	mov    %eax,0x4(%esp)
     20d:	c7 04 24 18 14 00 00 	movl   $0x1418,(%esp)
     214:	e8 e7 0a 00 00       	call   d00 <strchr>
     219:	85 c0                	test   %eax,%eax
     21b:	74 cb                	je     1e8 <gettoken+0xb8>
     21d:	bf 61 00 00 00       	mov    $0x61,%edi
     222:	e9 66 ff ff ff       	jmp    18d <gettoken+0x5d>
     227:	90                   	nop
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     228:	80 fa 29             	cmp    $0x29,%dl
     22b:	7f ad                	jg     1da <gettoken+0xaa>
     22d:	80 fa 28             	cmp    $0x28,%dl
     230:	0f 8d 54 ff ff ff    	jge    18a <gettoken+0x5a>
     236:	84 d2                	test   %dl,%dl
     238:	0f 84 4f ff ff ff    	je     18d <gettoken+0x5d>
     23e:	80 fa 26             	cmp    $0x26,%dl
     241:	75 97                	jne    1da <gettoken+0xaa>
     243:	e9 42 ff ff ff       	jmp    18a <gettoken+0x5a>
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
     248:	83 c3 01             	add    $0x1,%ebx
    if(*s == '>'){
     24b:	80 3b 3e             	cmpb   $0x3e,(%ebx)
     24e:	66 90                	xchg   %ax,%ax
     250:	0f 85 37 ff ff ff    	jne    18d <gettoken+0x5d>
      ret = '+';
      s++;
     256:	83 c3 01             	add    $0x1,%ebx
     259:	bf 2b 00 00 00       	mov    $0x2b,%edi
     25e:	e9 2a ff ff ff       	jmp    18d <gettoken+0x5d>
     263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <backcmd>:
  return (struct cmd*)cmd;
}

struct cmd*
backcmd(struct cmd *subcmd)
{
     270:	55                   	push   %ebp
     271:	89 e5                	mov    %esp,%ebp
     273:	53                   	push   %ebx
     274:	83 ec 14             	sub    $0x14,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     277:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     27e:	e8 ad 0f 00 00       	call   1230 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     283:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     28a:	00 
     28b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     292:	00 
struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     293:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     295:	89 04 24             	mov    %eax,(%esp)
     298:	e8 43 0a 00 00       	call   ce0 <memset>
  cmd->type = BACK;
     29d:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     2a3:	8b 45 08             	mov    0x8(%ebp),%eax
     2a6:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     2a9:	89 d8                	mov    %ebx,%eax
     2ab:	83 c4 14             	add    $0x14,%esp
     2ae:	5b                   	pop    %ebx
     2af:	5d                   	pop    %ebp
     2b0:	c3                   	ret    
     2b1:	eb 0d                	jmp    2c0 <listcmd>
     2b3:	90                   	nop
     2b4:	90                   	nop
     2b5:	90                   	nop
     2b6:	90                   	nop
     2b7:	90                   	nop
     2b8:	90                   	nop
     2b9:	90                   	nop
     2ba:	90                   	nop
     2bb:	90                   	nop
     2bc:	90                   	nop
     2bd:	90                   	nop
     2be:	90                   	nop
     2bf:	90                   	nop

000002c0 <listcmd>:
  return (struct cmd*)cmd;
}

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     2c0:	55                   	push   %ebp
     2c1:	89 e5                	mov    %esp,%ebp
     2c3:	53                   	push   %ebx
     2c4:	83 ec 14             	sub    $0x14,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2c7:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     2ce:	e8 5d 0f 00 00       	call   1230 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     2d3:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     2da:	00 
     2db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2e2:	00 
struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2e3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2e5:	89 04 24             	mov    %eax,(%esp)
     2e8:	e8 f3 09 00 00       	call   ce0 <memset>
  cmd->type = LIST;
     2ed:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     2f3:	8b 45 08             	mov    0x8(%ebp),%eax
     2f6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     2f9:	8b 45 0c             	mov    0xc(%ebp),%eax
     2fc:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     2ff:	89 d8                	mov    %ebx,%eax
     301:	83 c4 14             	add    $0x14,%esp
     304:	5b                   	pop    %ebx
     305:	5d                   	pop    %ebp
     306:	c3                   	ret    
     307:	89 f6                	mov    %esi,%esi
     309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000310 <pipecmd>:
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     310:	55                   	push   %ebp
     311:	89 e5                	mov    %esp,%ebp
     313:	53                   	push   %ebx
     314:	83 ec 14             	sub    $0x14,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     317:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     31e:	e8 0d 0f 00 00       	call   1230 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     323:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     32a:	00 
     32b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     332:	00 
struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     333:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     335:	89 04 24             	mov    %eax,(%esp)
     338:	e8 a3 09 00 00       	call   ce0 <memset>
  cmd->type = PIPE;
     33d:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     343:	8b 45 08             	mov    0x8(%ebp),%eax
     346:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     349:	8b 45 0c             	mov    0xc(%ebp),%eax
     34c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     34f:	89 d8                	mov    %ebx,%eax
     351:	83 c4 14             	add    $0x14,%esp
     354:	5b                   	pop    %ebx
     355:	5d                   	pop    %ebp
     356:	c3                   	ret    
     357:	89 f6                	mov    %esi,%esi
     359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000360 <redircmd>:
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     360:	55                   	push   %ebp
     361:	89 e5                	mov    %esp,%ebp
     363:	53                   	push   %ebx
     364:	83 ec 14             	sub    $0x14,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     367:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     36e:	e8 bd 0e 00 00       	call   1230 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     373:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     37a:	00 
     37b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     382:	00 
struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     383:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     385:	89 04 24             	mov    %eax,(%esp)
     388:	e8 53 09 00 00       	call   ce0 <memset>
  cmd->type = REDIR;
     38d:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     393:	8b 45 08             	mov    0x8(%ebp),%eax
     396:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     399:	8b 45 0c             	mov    0xc(%ebp),%eax
     39c:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     39f:	8b 45 10             	mov    0x10(%ebp),%eax
     3a2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     3a5:	8b 45 14             	mov    0x14(%ebp),%eax
     3a8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     3ab:	8b 45 18             	mov    0x18(%ebp),%eax
     3ae:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     3b1:	89 d8                	mov    %ebx,%eax
     3b3:	83 c4 14             	add    $0x14,%esp
     3b6:	5b                   	pop    %ebx
     3b7:	5d                   	pop    %ebp
     3b8:	c3                   	ret    
     3b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003c0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3c0:	55                   	push   %ebp
     3c1:	89 e5                	mov    %esp,%ebp
     3c3:	53                   	push   %ebx
     3c4:	83 ec 14             	sub    $0x14,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3c7:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3ce:	e8 5d 0e 00 00       	call   1230 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3d3:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     3da:	00 
     3db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3e2:	00 
struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3e5:	89 04 24             	mov    %eax,(%esp)
     3e8:	e8 f3 08 00 00       	call   ce0 <memset>
  cmd->type = EXEC;
  return (struct cmd*)cmd;
}
     3ed:	89 d8                	mov    %ebx,%eax
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = EXEC;
     3ef:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     3f5:	83 c4 14             	add    $0x14,%esp
     3f8:	5b                   	pop    %ebx
     3f9:	5d                   	pop    %ebp
     3fa:	c3                   	ret    
     3fb:	90                   	nop
     3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000400 <panic>:
  exit();
}

void
panic(char *s)
{
     400:	55                   	push   %ebp
     401:	89 e5                	mov    %esp,%ebp
     403:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     406:	8b 45 08             	mov    0x8(%ebp),%eax
     409:	c7 44 24 04 b1 13 00 	movl   $0x13b1,0x4(%esp)
     410:	00 
     411:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     418:	89 44 24 08          	mov    %eax,0x8(%esp)
     41c:	e8 8f 0b 00 00       	call   fb0 <printf>
  exit();
     421:	e8 42 0a 00 00       	call   e68 <exit>
     426:	8d 76 00             	lea    0x0(%esi),%esi
     429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     430:	55                   	push   %ebp
     431:	89 e5                	mov    %esp,%ebp
     433:	57                   	push   %edi
     434:	56                   	push   %esi
     435:	53                   	push   %ebx
     436:	83 ec 3c             	sub    $0x3c,%esp
     439:	8b 7d 0c             	mov    0xc(%ebp),%edi
     43c:	8b 75 10             	mov    0x10(%ebp),%esi
     43f:	90                   	nop
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     440:	c7 44 24 08 65 13 00 	movl   $0x1365,0x8(%esp)
     447:	00 
     448:	89 74 24 04          	mov    %esi,0x4(%esp)
     44c:	89 3c 24             	mov    %edi,(%esp)
     44f:	e8 5c fc ff ff       	call   b0 <peek>
     454:	85 c0                	test   %eax,%eax
     456:	0f 84 a4 00 00 00    	je     500 <parseredirs+0xd0>
    tok = gettoken(ps, es, 0, 0);
     45c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     463:	00 
     464:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     46b:	00 
     46c:	89 74 24 04          	mov    %esi,0x4(%esp)
     470:	89 3c 24             	mov    %edi,(%esp)
     473:	e8 b8 fc ff ff       	call   130 <gettoken>
    if(gettoken(ps, es, &q, &eq) != 'a')
     478:	89 74 24 04          	mov    %esi,0x4(%esp)
     47c:	89 3c 24             	mov    %edi,(%esp)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
     47f:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
     481:	8d 45 e0             	lea    -0x20(%ebp),%eax
     484:	89 44 24 0c          	mov    %eax,0xc(%esp)
     488:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     48b:	89 44 24 08          	mov    %eax,0x8(%esp)
     48f:	e8 9c fc ff ff       	call   130 <gettoken>
     494:	83 f8 61             	cmp    $0x61,%eax
     497:	74 0c                	je     4a5 <parseredirs+0x75>
      panic("missing file for redirection");
     499:	c7 04 24 48 13 00 00 	movl   $0x1348,(%esp)
     4a0:	e8 5b ff ff ff       	call   400 <panic>
    switch(tok){
     4a5:	83 fb 3c             	cmp    $0x3c,%ebx
     4a8:	74 3e                	je     4e8 <parseredirs+0xb8>
     4aa:	83 fb 3e             	cmp    $0x3e,%ebx
     4ad:	74 05                	je     4b4 <parseredirs+0x84>
     4af:	83 fb 2b             	cmp    $0x2b,%ebx
     4b2:	75 8c                	jne    440 <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     4b4:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     4bb:	00 
     4bc:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     4c3:	00 
     4c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
     4c7:	89 44 24 08          	mov    %eax,0x8(%esp)
     4cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     4ce:	89 44 24 04          	mov    %eax,0x4(%esp)
     4d2:	8b 45 08             	mov    0x8(%ebp),%eax
     4d5:	89 04 24             	mov    %eax,(%esp)
     4d8:	e8 83 fe ff ff       	call   360 <redircmd>
     4dd:	89 45 08             	mov    %eax,0x8(%ebp)
     4e0:	e9 5b ff ff ff       	jmp    440 <parseredirs+0x10>
     4e5:	8d 76 00             	lea    0x0(%esi),%esi
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4e8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     4ef:	00 
     4f0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     4f7:	00 
     4f8:	eb ca                	jmp    4c4 <parseredirs+0x94>
     4fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
}
     500:	8b 45 08             	mov    0x8(%ebp),%eax
     503:	83 c4 3c             	add    $0x3c,%esp
     506:	5b                   	pop    %ebx
     507:	5e                   	pop    %esi
     508:	5f                   	pop    %edi
     509:	5d                   	pop    %ebp
     50a:	c3                   	ret    
     50b:	90                   	nop
     50c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000510 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     510:	55                   	push   %ebp
     511:	89 e5                	mov    %esp,%ebp
     513:	57                   	push   %edi
     514:	56                   	push   %esi
     515:	53                   	push   %ebx
     516:	83 ec 3c             	sub    $0x3c,%esp
     519:	8b 75 08             	mov    0x8(%ebp),%esi
     51c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     51f:	c7 44 24 08 68 13 00 	movl   $0x1368,0x8(%esp)
     526:	00 
     527:	89 34 24             	mov    %esi,(%esp)
     52a:	89 7c 24 04          	mov    %edi,0x4(%esp)
     52e:	e8 7d fb ff ff       	call   b0 <peek>
     533:	85 c0                	test   %eax,%eax
     535:	0f 85 cd 00 00 00    	jne    608 <parseexec+0xf8>
    return parseblock(ps, es);

  ret = execcmd();
     53b:	e8 80 fe ff ff       	call   3c0 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     540:	31 db                	xor    %ebx,%ebx
     542:	89 7c 24 08          	mov    %edi,0x8(%esp)
     546:	89 74 24 04          	mov    %esi,0x4(%esp)
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
     54a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     54d:	89 04 24             	mov    %eax,(%esp)
     550:	e8 db fe ff ff       	call   430 <parseredirs>
     555:	89 45 d0             	mov    %eax,-0x30(%ebp)
  while(!peek(ps, es, "|)&;")){
     558:	eb 1c                	jmp    576 <parseexec+0x66>
     55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     560:	8b 45 d0             	mov    -0x30(%ebp),%eax
     563:	89 7c 24 08          	mov    %edi,0x8(%esp)
     567:	89 74 24 04          	mov    %esi,0x4(%esp)
     56b:	89 04 24             	mov    %eax,(%esp)
     56e:	e8 bd fe ff ff       	call   430 <parseredirs>
     573:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     576:	c7 44 24 08 7f 13 00 	movl   $0x137f,0x8(%esp)
     57d:	00 
     57e:	89 7c 24 04          	mov    %edi,0x4(%esp)
     582:	89 34 24             	mov    %esi,(%esp)
     585:	e8 26 fb ff ff       	call   b0 <peek>
     58a:	85 c0                	test   %eax,%eax
     58c:	75 5a                	jne    5e8 <parseexec+0xd8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     58e:	8d 45 e0             	lea    -0x20(%ebp),%eax
     591:	8d 55 e4             	lea    -0x1c(%ebp),%edx
     594:	89 44 24 0c          	mov    %eax,0xc(%esp)
     598:	89 54 24 08          	mov    %edx,0x8(%esp)
     59c:	89 7c 24 04          	mov    %edi,0x4(%esp)
     5a0:	89 34 24             	mov    %esi,(%esp)
     5a3:	e8 88 fb ff ff       	call   130 <gettoken>
     5a8:	85 c0                	test   %eax,%eax
     5aa:	74 3c                	je     5e8 <parseexec+0xd8>
      break;
    if(tok != 'a')
     5ac:	83 f8 61             	cmp    $0x61,%eax
     5af:	74 0c                	je     5bd <parseexec+0xad>
      panic("syntax");
     5b1:	c7 04 24 6a 13 00 00 	movl   $0x136a,(%esp)
     5b8:	e8 43 fe ff ff       	call   400 <panic>
    cmd->argv[argc] = q;
     5bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     5c3:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     5c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     5ca:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     5ce:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     5d1:	83 fb 09             	cmp    $0x9,%ebx
     5d4:	7e 8a                	jle    560 <parseexec+0x50>
      panic("too many args");
     5d6:	c7 04 24 71 13 00 00 	movl   $0x1371,(%esp)
     5dd:	e8 1e fe ff ff       	call   400 <panic>
     5e2:	e9 79 ff ff ff       	jmp    560 <parseexec+0x50>
     5e7:	90                   	nop
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     5e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     5eb:	c7 44 9a 04 00 00 00 	movl   $0x0,0x4(%edx,%ebx,4)
     5f2:	00 
  cmd->eargv[argc] = 0;
     5f3:	c7 44 9a 2c 00 00 00 	movl   $0x0,0x2c(%edx,%ebx,4)
     5fa:	00 
  return ret;
}
     5fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
     5fe:	83 c4 3c             	add    $0x3c,%esp
     601:	5b                   	pop    %ebx
     602:	5e                   	pop    %esi
     603:	5f                   	pop    %edi
     604:	5d                   	pop    %ebp
     605:	c3                   	ret    
     606:	66 90                	xchg   %ax,%ax
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    return parseblock(ps, es);
     608:	89 7c 24 04          	mov    %edi,0x4(%esp)
     60c:	89 34 24             	mov    %esi,(%esp)
     60f:	e8 6c 01 00 00       	call   780 <parseblock>
     614:	89 45 d0             	mov    %eax,-0x30(%ebp)
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     617:	8b 45 d0             	mov    -0x30(%ebp),%eax
     61a:	83 c4 3c             	add    $0x3c,%esp
     61d:	5b                   	pop    %ebx
     61e:	5e                   	pop    %esi
     61f:	5f                   	pop    %edi
     620:	5d                   	pop    %ebp
     621:	c3                   	ret    
     622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000630 <parsepipe>:
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
     630:	55                   	push   %ebp
     631:	89 e5                	mov    %esp,%ebp
     633:	83 ec 28             	sub    $0x28,%esp
     636:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     639:	8b 5d 08             	mov    0x8(%ebp),%ebx
     63c:	89 75 f8             	mov    %esi,-0x8(%ebp)
     63f:	8b 75 0c             	mov    0xc(%ebp),%esi
     642:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     645:	89 1c 24             	mov    %ebx,(%esp)
     648:	89 74 24 04          	mov    %esi,0x4(%esp)
     64c:	e8 bf fe ff ff       	call   510 <parseexec>
  if(peek(ps, es, "|")){
     651:	c7 44 24 08 84 13 00 	movl   $0x1384,0x8(%esp)
     658:	00 
     659:	89 74 24 04          	mov    %esi,0x4(%esp)
     65d:	89 1c 24             	mov    %ebx,(%esp)
struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     660:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
     662:	e8 49 fa ff ff       	call   b0 <peek>
     667:	85 c0                	test   %eax,%eax
     669:	75 15                	jne    680 <parsepipe+0x50>
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}
     66b:	89 f8                	mov    %edi,%eax
     66d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     670:	8b 75 f8             	mov    -0x8(%ebp),%esi
     673:	8b 7d fc             	mov    -0x4(%ebp),%edi
     676:	89 ec                	mov    %ebp,%esp
     678:	5d                   	pop    %ebp
     679:	c3                   	ret    
     67a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
     680:	89 74 24 04          	mov    %esi,0x4(%esp)
     684:	89 1c 24             	mov    %ebx,(%esp)
     687:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     68e:	00 
     68f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     696:	00 
     697:	e8 94 fa ff ff       	call   130 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     69c:	89 74 24 04          	mov    %esi,0x4(%esp)
     6a0:	89 1c 24             	mov    %ebx,(%esp)
     6a3:	e8 88 ff ff ff       	call   630 <parsepipe>
  }
  return cmd;
}
     6a8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ab:	89 7d 08             	mov    %edi,0x8(%ebp)
  }
  return cmd;
}
     6ae:	8b 75 f8             	mov    -0x8(%ebp),%esi
     6b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6b4:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
     6b7:	89 ec                	mov    %ebp,%esp
     6b9:	5d                   	pop    %ebp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ba:	e9 51 fc ff ff       	jmp    310 <pipecmd>
     6bf:	90                   	nop

000006c0 <parseline>:
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
     6c0:	55                   	push   %ebp
     6c1:	89 e5                	mov    %esp,%ebp
     6c3:	57                   	push   %edi
     6c4:	56                   	push   %esi
     6c5:	53                   	push   %ebx
     6c6:	83 ec 1c             	sub    $0x1c,%esp
     6c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     6cf:	89 1c 24             	mov    %ebx,(%esp)
     6d2:	89 74 24 04          	mov    %esi,0x4(%esp)
     6d6:	e8 55 ff ff ff       	call   630 <parsepipe>
     6db:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     6dd:	eb 27                	jmp    706 <parseline+0x46>
     6df:	90                   	nop
    gettoken(ps, es, 0, 0);
     6e0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     6e7:	00 
     6e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     6ef:	00 
     6f0:	89 74 24 04          	mov    %esi,0x4(%esp)
     6f4:	89 1c 24             	mov    %ebx,(%esp)
     6f7:	e8 34 fa ff ff       	call   130 <gettoken>
    cmd = backcmd(cmd);
     6fc:	89 3c 24             	mov    %edi,(%esp)
     6ff:	e8 6c fb ff ff       	call   270 <backcmd>
     704:	89 c7                	mov    %eax,%edi
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     706:	c7 44 24 08 86 13 00 	movl   $0x1386,0x8(%esp)
     70d:	00 
     70e:	89 74 24 04          	mov    %esi,0x4(%esp)
     712:	89 1c 24             	mov    %ebx,(%esp)
     715:	e8 96 f9 ff ff       	call   b0 <peek>
     71a:	85 c0                	test   %eax,%eax
     71c:	75 c2                	jne    6e0 <parseline+0x20>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     71e:	c7 44 24 08 82 13 00 	movl   $0x1382,0x8(%esp)
     725:	00 
     726:	89 74 24 04          	mov    %esi,0x4(%esp)
     72a:	89 1c 24             	mov    %ebx,(%esp)
     72d:	e8 7e f9 ff ff       	call   b0 <peek>
     732:	85 c0                	test   %eax,%eax
     734:	75 0a                	jne    740 <parseline+0x80>
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}
     736:	83 c4 1c             	add    $0x1c,%esp
     739:	89 f8                	mov    %edi,%eax
     73b:	5b                   	pop    %ebx
     73c:	5e                   	pop    %esi
     73d:	5f                   	pop    %edi
     73e:	5d                   	pop    %ebp
     73f:	c3                   	ret    
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
     740:	89 74 24 04          	mov    %esi,0x4(%esp)
     744:	89 1c 24             	mov    %ebx,(%esp)
     747:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     74e:	00 
     74f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     756:	00 
     757:	e8 d4 f9 ff ff       	call   130 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     75c:	89 74 24 04          	mov    %esi,0x4(%esp)
     760:	89 1c 24             	mov    %ebx,(%esp)
     763:	e8 58 ff ff ff       	call   6c0 <parseline>
     768:	89 7d 08             	mov    %edi,0x8(%ebp)
     76b:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
     76e:	83 c4 1c             	add    $0x1c,%esp
     771:	5b                   	pop    %ebx
     772:	5e                   	pop    %esi
     773:	5f                   	pop    %edi
     774:	5d                   	pop    %ebp
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
     775:	e9 46 fb ff ff       	jmp    2c0 <listcmd>
     77a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000780 <parseblock>:
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
     780:	55                   	push   %ebp
     781:	89 e5                	mov    %esp,%ebp
     783:	83 ec 28             	sub    $0x28,%esp
     786:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     789:	8b 5d 08             	mov    0x8(%ebp),%ebx
     78c:	89 75 f8             	mov    %esi,-0x8(%ebp)
     78f:	8b 75 0c             	mov    0xc(%ebp),%esi
     792:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     795:	c7 44 24 08 68 13 00 	movl   $0x1368,0x8(%esp)
     79c:	00 
     79d:	89 1c 24             	mov    %ebx,(%esp)
     7a0:	89 74 24 04          	mov    %esi,0x4(%esp)
     7a4:	e8 07 f9 ff ff       	call   b0 <peek>
     7a9:	85 c0                	test   %eax,%eax
     7ab:	0f 84 87 00 00 00    	je     838 <parseblock+0xb8>
    panic("parseblock");
  gettoken(ps, es, 0, 0);
     7b1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7b8:	00 
     7b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7c0:	00 
     7c1:	89 74 24 04          	mov    %esi,0x4(%esp)
     7c5:	89 1c 24             	mov    %ebx,(%esp)
     7c8:	e8 63 f9 ff ff       	call   130 <gettoken>
  cmd = parseline(ps, es);
     7cd:	89 74 24 04          	mov    %esi,0x4(%esp)
     7d1:	89 1c 24             	mov    %ebx,(%esp)
     7d4:	e8 e7 fe ff ff       	call   6c0 <parseline>
  if(!peek(ps, es, ")"))
     7d9:	c7 44 24 08 a4 13 00 	movl   $0x13a4,0x8(%esp)
     7e0:	00 
     7e1:	89 74 24 04          	mov    %esi,0x4(%esp)
     7e5:	89 1c 24             	mov    %ebx,(%esp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
     7e8:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     7ea:	e8 c1 f8 ff ff       	call   b0 <peek>
     7ef:	85 c0                	test   %eax,%eax
     7f1:	75 0c                	jne    7ff <parseblock+0x7f>
    panic("syntax - missing )");
     7f3:	c7 04 24 93 13 00 00 	movl   $0x1393,(%esp)
     7fa:	e8 01 fc ff ff       	call   400 <panic>
  gettoken(ps, es, 0, 0);
     7ff:	89 74 24 04          	mov    %esi,0x4(%esp)
     803:	89 1c 24             	mov    %ebx,(%esp)
     806:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     80d:	00 
     80e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     815:	00 
     816:	e8 15 f9 ff ff       	call   130 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     81b:	89 74 24 08          	mov    %esi,0x8(%esp)
     81f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     823:	89 3c 24             	mov    %edi,(%esp)
     826:	e8 05 fc ff ff       	call   430 <parseredirs>
  return cmd;
}
     82b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     82e:	8b 75 f8             	mov    -0x8(%ebp),%esi
     831:	8b 7d fc             	mov    -0x4(%ebp),%edi
     834:	89 ec                	mov    %ebp,%esp
     836:	5d                   	pop    %ebp
     837:	c3                   	ret    
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
     838:	c7 04 24 88 13 00 00 	movl   $0x1388,(%esp)
     83f:	e8 bc fb ff ff       	call   400 <panic>
     844:	e9 68 ff ff ff       	jmp    7b1 <parseblock+0x31>
     849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000850 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     850:	55                   	push   %ebp
     851:	89 e5                	mov    %esp,%ebp
     853:	56                   	push   %esi
     854:	53                   	push   %ebx
     855:	83 ec 10             	sub    $0x10,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     858:	8b 5d 08             	mov    0x8(%ebp),%ebx
     85b:	89 1c 24             	mov    %ebx,(%esp)
     85e:	e8 5d 04 00 00       	call   cc0 <strlen>
     863:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     865:	8d 45 08             	lea    0x8(%ebp),%eax
     868:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     86c:	89 04 24             	mov    %eax,(%esp)
     86f:	e8 4c fe ff ff       	call   6c0 <parseline>
  peek(&s, es, "");
     874:	c7 44 24 08 d3 13 00 	movl   $0x13d3,0x8(%esp)
     87b:	00 
     87c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
     880:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     882:	8d 45 08             	lea    0x8(%ebp),%eax
     885:	89 04 24             	mov    %eax,(%esp)
     888:	e8 23 f8 ff ff       	call   b0 <peek>
  if(s != es){
     88d:	8b 45 08             	mov    0x8(%ebp),%eax
     890:	39 d8                	cmp    %ebx,%eax
     892:	74 24                	je     8b8 <parsecmd+0x68>
    printf(2, "leftovers: %s\n", s);
     894:	89 44 24 08          	mov    %eax,0x8(%esp)
     898:	c7 44 24 04 a6 13 00 	movl   $0x13a6,0x4(%esp)
     89f:	00 
     8a0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     8a7:	e8 04 07 00 00       	call   fb0 <printf>
    panic("syntax");
     8ac:	c7 04 24 6a 13 00 00 	movl   $0x136a,(%esp)
     8b3:	e8 48 fb ff ff       	call   400 <panic>
  }
  nulterminate(cmd);
     8b8:	89 34 24             	mov    %esi,(%esp)
     8bb:	e8 40 f7 ff ff       	call   0 <nulterminate>
  return cmd;
}
     8c0:	83 c4 10             	add    $0x10,%esp
     8c3:	89 f0                	mov    %esi,%eax
     8c5:	5b                   	pop    %ebx
     8c6:	5e                   	pop    %esi
     8c7:	5d                   	pop    %ebp
     8c8:	c3                   	ret    
     8c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008d0 <fork1>:
  exit();
}

int
fork1(void)
{
     8d0:	55                   	push   %ebp
     8d1:	89 e5                	mov    %esp,%ebp
     8d3:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     8d6:	e8 85 05 00 00       	call   e60 <fork>
  if(pid == -1)
     8db:	83 f8 ff             	cmp    $0xffffffff,%eax
     8de:	74 08                	je     8e8 <fork1+0x18>
    panic("fork");
  return pid;
}
     8e0:	c9                   	leave  
     8e1:	c3                   	ret    
     8e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int pid;
  
  pid = fork();
  if(pid == -1)
    panic("fork");
     8e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
     8eb:	c7 04 24 b5 13 00 00 	movl   $0x13b5,(%esp)
     8f2:	e8 09 fb ff ff       	call   400 <panic>
     8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  return pid;
}
     8fa:	c9                   	leave  
     8fb:	c3                   	ret    
     8fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000900 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
     900:	55                   	push   %ebp
     901:	89 e5                	mov    %esp,%ebp
     903:	83 ec 18             	sub    $0x18,%esp
     906:	89 5d f8             	mov    %ebx,-0x8(%ebp)
     909:	8b 5d 08             	mov    0x8(%ebp),%ebx
     90c:	89 75 fc             	mov    %esi,-0x4(%ebp)
     90f:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
     912:	c7 44 24 04 ba 13 00 	movl   $0x13ba,0x4(%esp)
     919:	00 
     91a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     921:	e8 8a 06 00 00       	call   fb0 <printf>
  memset(buf, 0, nbuf);
     926:	89 74 24 08          	mov    %esi,0x8(%esp)
     92a:	89 1c 24             	mov    %ebx,(%esp)
     92d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     934:	00 
     935:	e8 a6 03 00 00       	call   ce0 <memset>
  gets(buf, nbuf);
     93a:	89 74 24 04          	mov    %esi,0x4(%esp)
     93e:	89 1c 24             	mov    %ebx,(%esp)
     941:	e8 ba 04 00 00       	call   e00 <gets>
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}
     946:	8b 75 fc             	mov    -0x4(%ebp),%esi
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
     949:	80 3b 01             	cmpb   $0x1,(%ebx)
    return -1;
  return 0;
}
     94c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
     94f:	19 c0                	sbb    %eax,%eax
    return -1;
  return 0;
}
     951:	89 ec                	mov    %ebp,%esp
     953:	5d                   	pop    %ebp
     954:	c3                   	ret    
     955:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000960 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
     960:	55                   	push   %ebp
     961:	89 e5                	mov    %esp,%ebp
     963:	53                   	push   %ebx
     964:	83 ec 24             	sub    $0x24,%esp
     967:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     96a:	85 db                	test   %ebx,%ebx
     96c:	74 42                	je     9b0 <runcmd+0x50>
    exit();
  
  switch(cmd->type){
     96e:	83 3b 05             	cmpl   $0x5,(%ebx)
     971:	76 45                	jbe    9b8 <runcmd+0x58>
  default:
    panic("runcmd");
     973:	c7 04 24 bd 13 00 00 	movl   $0x13bd,(%esp)
     97a:	e8 81 fa ff ff       	call   400 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
     97f:	8b 43 04             	mov    0x4(%ebx),%eax
     982:	85 c0                	test   %eax,%eax
     984:	74 2a                	je     9b0 <runcmd+0x50>
      exit();
    exec(ecmd->argv[0], ecmd->argv);
     986:	8d 53 04             	lea    0x4(%ebx),%edx
     989:	89 54 24 04          	mov    %edx,0x4(%esp)
     98d:	89 04 24             	mov    %eax,(%esp)
     990:	e8 0b 05 00 00       	call   ea0 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     995:	8b 43 04             	mov    0x4(%ebx),%eax
     998:	c7 44 24 04 c4 13 00 	movl   $0x13c4,0x4(%esp)
     99f:	00 
     9a0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     9a7:	89 44 24 08          	mov    %eax,0x8(%esp)
     9ab:	e8 00 06 00 00       	call   fb0 <printf>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     9b0:	e8 b3 04 00 00       	call   e68 <exit>
     9b5:	8d 76 00             	lea    0x0(%esi),%esi
  struct redircmd *rcmd;

  if(cmd == 0)
    exit();
  
  switch(cmd->type){
     9b8:	8b 03                	mov    (%ebx),%eax
     9ba:	ff 24 85 30 13 00 00 	jmp    *0x1330(,%eax,4)
     9c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wait();
    break;
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
     9c8:	e8 03 ff ff ff       	call   8d0 <fork1>
     9cd:	85 c0                	test   %eax,%eax
     9cf:	90                   	nop
     9d0:	0f 84 a7 00 00 00    	je     a7d <runcmd+0x11d>
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     9d6:	e8 8d 04 00 00       	call   e68 <exit>
     9db:	90                   	nop
     9dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    runcmd(rcmd->cmd);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
     9e0:	e8 eb fe ff ff       	call   8d0 <fork1>
     9e5:	85 c0                	test   %eax,%eax
     9e7:	0f 84 a3 00 00 00    	je     a90 <runcmd+0x130>
     9ed:	8d 76 00             	lea    0x0(%esi),%esi
      runcmd(lcmd->left);
    wait();
     9f0:	e8 7b 04 00 00       	call   e70 <wait>
    runcmd(lcmd->right);
     9f5:	8b 43 08             	mov    0x8(%ebx),%eax
     9f8:	89 04 24             	mov    %eax,(%esp)
     9fb:	e8 60 ff ff ff       	call   960 <runcmd>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     a00:	e8 63 04 00 00       	call   e68 <exit>
     a05:	8d 76 00             	lea    0x0(%esi),%esi
    runcmd(lcmd->right);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
     a08:	8d 45 f0             	lea    -0x10(%ebp),%eax
     a0b:	89 04 24             	mov    %eax,(%esp)
     a0e:	e8 65 04 00 00       	call   e78 <pipe>
     a13:	85 c0                	test   %eax,%eax
     a15:	0f 88 25 01 00 00    	js     b40 <runcmd+0x1e0>
      panic("pipe");
    if(fork1() == 0){
     a1b:	e8 b0 fe ff ff       	call   8d0 <fork1>
     a20:	85 c0                	test   %eax,%eax
     a22:	0f 84 b8 00 00 00    	je     ae0 <runcmd+0x180>
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
     a28:	e8 a3 fe ff ff       	call   8d0 <fork1>
     a2d:	85 c0                	test   %eax,%eax
     a2f:	90                   	nop
     a30:	74 6e                	je     aa0 <runcmd+0x140>
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right);
    }
    close(p[0]);
     a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a35:	89 04 24             	mov    %eax,(%esp)
     a38:	e8 53 04 00 00       	call   e90 <close>
    close(p[1]);
     a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a40:	89 04 24             	mov    %eax,(%esp)
     a43:	e8 48 04 00 00       	call   e90 <close>
    wait();
     a48:	e8 23 04 00 00       	call   e70 <wait>
    wait();
     a4d:	e8 1e 04 00 00       	call   e70 <wait>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     a52:	e8 11 04 00 00       	call   e68 <exit>
     a57:	90                   	nop
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
     a58:	8b 43 14             	mov    0x14(%ebx),%eax
     a5b:	89 04 24             	mov    %eax,(%esp)
     a5e:	e8 2d 04 00 00       	call   e90 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     a63:	8b 43 10             	mov    0x10(%ebx),%eax
     a66:	89 44 24 04          	mov    %eax,0x4(%esp)
     a6a:	8b 43 08             	mov    0x8(%ebx),%eax
     a6d:	89 04 24             	mov    %eax,(%esp)
     a70:	e8 33 04 00 00       	call   ea8 <open>
     a75:	85 c0                	test   %eax,%eax
     a77:	0f 88 a3 00 00 00    	js     b20 <runcmd+0x1c0>
    break;
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
     a7d:	8b 43 04             	mov    0x4(%ebx),%eax
     a80:	89 04 24             	mov    %eax,(%esp)
     a83:	e8 d8 fe ff ff       	call   960 <runcmd>
    break;
  }
  exit();
     a88:	e8 db 03 00 00       	call   e68 <exit>
     a8d:	8d 76 00             	lea    0x0(%esi),%esi
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
      runcmd(lcmd->left);
     a90:	8b 43 04             	mov    0x4(%ebx),%eax
     a93:	89 04 24             	mov    %eax,(%esp)
     a96:	e8 c5 fe ff ff       	call   960 <runcmd>
     a9b:	e9 4d ff ff ff       	jmp    9ed <runcmd+0x8d>
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
      close(0);
     aa0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     aa7:	e8 e4 03 00 00       	call   e90 <close>
      dup(p[0]);
     aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
     aaf:	89 04 24             	mov    %eax,(%esp)
     ab2:	e8 29 04 00 00       	call   ee0 <dup>
      close(p[0]);
     ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     aba:	89 04 24             	mov    %eax,(%esp)
     abd:	e8 ce 03 00 00       	call   e90 <close>
      close(p[1]);
     ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac5:	89 04 24             	mov    %eax,(%esp)
     ac8:	e8 c3 03 00 00       	call   e90 <close>
      runcmd(pcmd->right);
     acd:	8b 43 08             	mov    0x8(%ebx),%eax
     ad0:	89 04 24             	mov    %eax,(%esp)
     ad3:	e8 88 fe ff ff       	call   960 <runcmd>
     ad8:	e9 55 ff ff ff       	jmp    a32 <runcmd+0xd2>
     add:	8d 76 00             	lea    0x0(%esi),%esi
  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    if(fork1() == 0){
      close(1);
     ae0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ae7:	e8 a4 03 00 00       	call   e90 <close>
      dup(p[1]);
     aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aef:	89 04 24             	mov    %eax,(%esp)
     af2:	e8 e9 03 00 00       	call   ee0 <dup>
      close(p[0]);
     af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     afa:	89 04 24             	mov    %eax,(%esp)
     afd:	e8 8e 03 00 00       	call   e90 <close>
      close(p[1]);
     b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b05:	89 04 24             	mov    %eax,(%esp)
     b08:	e8 83 03 00 00       	call   e90 <close>
      runcmd(pcmd->left);
     b0d:	8b 43 04             	mov    0x4(%ebx),%eax
     b10:	89 04 24             	mov    %eax,(%esp)
     b13:	e8 48 fe ff ff       	call   960 <runcmd>
     b18:	e9 0b ff ff ff       	jmp    a28 <runcmd+0xc8>
     b1d:	8d 76 00             	lea    0x0(%esi),%esi

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
     b20:	8b 43 08             	mov    0x8(%ebx),%eax
     b23:	c7 44 24 04 d4 13 00 	movl   $0x13d4,0x4(%esp)
     b2a:	00 
     b2b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     b32:	89 44 24 08          	mov    %eax,0x8(%esp)
     b36:	e8 75 04 00 00       	call   fb0 <printf>
      exit();
     b3b:	e8 28 03 00 00       	call   e68 <exit>
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
     b40:	c7 04 24 e4 13 00 00 	movl   $0x13e4,(%esp)
     b47:	e8 b4 f8 ff ff       	call   400 <panic>
     b4c:	e9 ca fe ff ff       	jmp    a1b <runcmd+0xbb>
     b51:	eb 0d                	jmp    b60 <main>
     b53:	90                   	nop
     b54:	90                   	nop
     b55:	90                   	nop
     b56:	90                   	nop
     b57:	90                   	nop
     b58:	90                   	nop
     b59:	90                   	nop
     b5a:	90                   	nop
     b5b:	90                   	nop
     b5c:	90                   	nop
     b5d:	90                   	nop
     b5e:	90                   	nop
     b5f:	90                   	nop

00000b60 <main>:
  return 0;
}

int
main(void)
{
     b60:	55                   	push   %ebp
     b61:	89 e5                	mov    %esp,%ebp
     b63:	83 e4 f0             	and    $0xfffffff0,%esp
     b66:	83 ec 10             	sub    $0x10,%esp
     b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     b70:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     b77:	00 
     b78:	c7 04 24 e9 13 00 00 	movl   $0x13e9,(%esp)
     b7f:	e8 24 03 00 00       	call   ea8 <open>
     b84:	85 c0                	test   %eax,%eax
     b86:	78 28                	js     bb0 <main+0x50>
    if(fd >= 3){
     b88:	83 f8 02             	cmp    $0x2,%eax
     b8b:	7e e3                	jle    b70 <main+0x10>
      close(fd);
     b8d:	89 04 24             	mov    %eax,(%esp)
     b90:	e8 fb 02 00 00       	call   e90 <close>
      break;
     b95:	eb 19                	jmp    bb0 <main+0x50>
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
     b97:	c7 04 24 40 14 00 00 	movl   $0x1440,(%esp)
     b9e:	e8 ad fc ff ff       	call   850 <parsecmd>
     ba3:	89 04 24             	mov    %eax,(%esp)
     ba6:	e8 b5 fd ff ff       	call   960 <runcmd>
    wait();
     bab:	e8 c0 02 00 00       	call   e70 <wait>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     bb0:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     bb7:	00 
     bb8:	c7 04 24 40 14 00 00 	movl   $0x1440,(%esp)
     bbf:	e8 3c fd ff ff       	call   900 <getcmd>
     bc4:	85 c0                	test   %eax,%eax
     bc6:	78 70                	js     c38 <main+0xd8>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     bc8:	80 3d 40 14 00 00 63 	cmpb   $0x63,0x1440
     bcf:	75 09                	jne    bda <main+0x7a>
     bd1:	80 3d 41 14 00 00 64 	cmpb   $0x64,0x1441
     bd8:	74 0e                	je     be8 <main+0x88>
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
     bda:	e8 f1 fc ff ff       	call   8d0 <fork1>
     bdf:	85 c0                	test   %eax,%eax
     be1:	75 c8                	jne    bab <main+0x4b>
     be3:	eb b2                	jmp    b97 <main+0x37>
     be5:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     be8:	80 3d 42 14 00 00 20 	cmpb   $0x20,0x1442
     bef:	90                   	nop
     bf0:	75 e8                	jne    bda <main+0x7a>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     bf2:	c7 04 24 40 14 00 00 	movl   $0x1440,(%esp)
     bf9:	e8 c2 00 00 00       	call   cc0 <strlen>
      if(chdir(buf+3) < 0)
     bfe:	c7 04 24 43 14 00 00 	movl   $0x1443,(%esp)
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     c05:	c6 80 3f 14 00 00 00 	movb   $0x0,0x143f(%eax)
      if(chdir(buf+3) < 0)
     c0c:	e8 c7 02 00 00       	call   ed8 <chdir>
     c11:	85 c0                	test   %eax,%eax
     c13:	79 9b                	jns    bb0 <main+0x50>
        printf(2, "cannot cd %s\n", buf+3);
     c15:	c7 44 24 08 43 14 00 	movl   $0x1443,0x8(%esp)
     c1c:	00 
     c1d:	c7 44 24 04 f1 13 00 	movl   $0x13f1,0x4(%esp)
     c24:	00 
     c25:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     c2c:	e8 7f 03 00 00       	call   fb0 <printf>
     c31:	e9 7a ff ff ff       	jmp    bb0 <main+0x50>
     c36:	66 90                	xchg   %ax,%ax
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     c38:	e8 2b 02 00 00       	call   e68 <exit>
     c3d:	90                   	nop
     c3e:	90                   	nop
     c3f:	90                   	nop

00000c40 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     c40:	55                   	push   %ebp
     c41:	31 d2                	xor    %edx,%edx
     c43:	89 e5                	mov    %esp,%ebp
     c45:	8b 45 08             	mov    0x8(%ebp),%eax
     c48:	53                   	push   %ebx
     c49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c50:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
     c54:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     c57:	83 c2 01             	add    $0x1,%edx
     c5a:	84 c9                	test   %cl,%cl
     c5c:	75 f2                	jne    c50 <strcpy+0x10>
    ;
  return os;
}
     c5e:	5b                   	pop    %ebx
     c5f:	5d                   	pop    %ebp
     c60:	c3                   	ret    
     c61:	eb 0d                	jmp    c70 <strcmp>
     c63:	90                   	nop
     c64:	90                   	nop
     c65:	90                   	nop
     c66:	90                   	nop
     c67:	90                   	nop
     c68:	90                   	nop
     c69:	90                   	nop
     c6a:	90                   	nop
     c6b:	90                   	nop
     c6c:	90                   	nop
     c6d:	90                   	nop
     c6e:	90                   	nop
     c6f:	90                   	nop

00000c70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c70:	55                   	push   %ebp
     c71:	89 e5                	mov    %esp,%ebp
     c73:	8b 4d 08             	mov    0x8(%ebp),%ecx
     c76:	53                   	push   %ebx
     c77:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     c7a:	0f b6 01             	movzbl (%ecx),%eax
     c7d:	84 c0                	test   %al,%al
     c7f:	75 14                	jne    c95 <strcmp+0x25>
     c81:	eb 25                	jmp    ca8 <strcmp+0x38>
     c83:	90                   	nop
     c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
     c88:	83 c1 01             	add    $0x1,%ecx
     c8b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     c8e:	0f b6 01             	movzbl (%ecx),%eax
     c91:	84 c0                	test   %al,%al
     c93:	74 13                	je     ca8 <strcmp+0x38>
     c95:	0f b6 1a             	movzbl (%edx),%ebx
     c98:	38 d8                	cmp    %bl,%al
     c9a:	74 ec                	je     c88 <strcmp+0x18>
     c9c:	0f b6 db             	movzbl %bl,%ebx
     c9f:	0f b6 c0             	movzbl %al,%eax
     ca2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     ca4:	5b                   	pop    %ebx
     ca5:	5d                   	pop    %ebp
     ca6:	c3                   	ret    
     ca7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     ca8:	0f b6 1a             	movzbl (%edx),%ebx
     cab:	31 c0                	xor    %eax,%eax
     cad:	0f b6 db             	movzbl %bl,%ebx
     cb0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     cb2:	5b                   	pop    %ebx
     cb3:	5d                   	pop    %ebp
     cb4:	c3                   	ret    
     cb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000cc0 <strlen>:

uint
strlen(char *s)
{
     cc0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
     cc1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
     cc3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
     cc5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
     cc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     cca:	80 39 00             	cmpb   $0x0,(%ecx)
     ccd:	74 0c                	je     cdb <strlen+0x1b>
     ccf:	90                   	nop
     cd0:	83 c2 01             	add    $0x1,%edx
     cd3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     cd7:	89 d0                	mov    %edx,%eax
     cd9:	75 f5                	jne    cd0 <strlen+0x10>
    ;
  return n;
}
     cdb:	5d                   	pop    %ebp
     cdc:	c3                   	ret    
     cdd:	8d 76 00             	lea    0x0(%esi),%esi

00000ce0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     ce0:	55                   	push   %ebp
     ce1:	89 e5                	mov    %esp,%ebp
     ce3:	8b 55 08             	mov    0x8(%ebp),%edx
     ce6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     ce7:	8b 4d 10             	mov    0x10(%ebp),%ecx
     cea:	8b 45 0c             	mov    0xc(%ebp),%eax
     ced:	89 d7                	mov    %edx,%edi
     cef:	fc                   	cld    
     cf0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     cf2:	89 d0                	mov    %edx,%eax
     cf4:	5f                   	pop    %edi
     cf5:	5d                   	pop    %ebp
     cf6:	c3                   	ret    
     cf7:	89 f6                	mov    %esi,%esi
     cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d00 <strchr>:

char*
strchr(const char *s, char c)
{
     d00:	55                   	push   %ebp
     d01:	89 e5                	mov    %esp,%ebp
     d03:	8b 45 08             	mov    0x8(%ebp),%eax
     d06:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     d0a:	0f b6 10             	movzbl (%eax),%edx
     d0d:	84 d2                	test   %dl,%dl
     d0f:	75 11                	jne    d22 <strchr+0x22>
     d11:	eb 15                	jmp    d28 <strchr+0x28>
     d13:	90                   	nop
     d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d18:	83 c0 01             	add    $0x1,%eax
     d1b:	0f b6 10             	movzbl (%eax),%edx
     d1e:	84 d2                	test   %dl,%dl
     d20:	74 06                	je     d28 <strchr+0x28>
    if(*s == c)
     d22:	38 ca                	cmp    %cl,%dl
     d24:	75 f2                	jne    d18 <strchr+0x18>
      return (char*)s;
  return 0;
}
     d26:	5d                   	pop    %ebp
     d27:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     d28:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
     d2a:	5d                   	pop    %ebp
     d2b:	90                   	nop
     d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d30:	c3                   	ret    
     d31:	eb 0d                	jmp    d40 <atoi>
     d33:	90                   	nop
     d34:	90                   	nop
     d35:	90                   	nop
     d36:	90                   	nop
     d37:	90                   	nop
     d38:	90                   	nop
     d39:	90                   	nop
     d3a:	90                   	nop
     d3b:	90                   	nop
     d3c:	90                   	nop
     d3d:	90                   	nop
     d3e:	90                   	nop
     d3f:	90                   	nop

00000d40 <atoi>:
  return r;
}

int
atoi(const char *s)
{
     d40:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d41:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
     d43:	89 e5                	mov    %esp,%ebp
     d45:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d48:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d49:	0f b6 11             	movzbl (%ecx),%edx
     d4c:	8d 5a d0             	lea    -0x30(%edx),%ebx
     d4f:	80 fb 09             	cmp    $0x9,%bl
     d52:	77 1c                	ja     d70 <atoi+0x30>
     d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
     d58:	0f be d2             	movsbl %dl,%edx
     d5b:	83 c1 01             	add    $0x1,%ecx
     d5e:	8d 04 80             	lea    (%eax,%eax,4),%eax
     d61:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d65:	0f b6 11             	movzbl (%ecx),%edx
     d68:	8d 5a d0             	lea    -0x30(%edx),%ebx
     d6b:	80 fb 09             	cmp    $0x9,%bl
     d6e:	76 e8                	jbe    d58 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
     d70:	5b                   	pop    %ebx
     d71:	5d                   	pop    %ebp
     d72:	c3                   	ret    
     d73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d80 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     d80:	55                   	push   %ebp
     d81:	89 e5                	mov    %esp,%ebp
     d83:	56                   	push   %esi
     d84:	8b 45 08             	mov    0x8(%ebp),%eax
     d87:	53                   	push   %ebx
     d88:	8b 5d 10             	mov    0x10(%ebp),%ebx
     d8b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d8e:	85 db                	test   %ebx,%ebx
     d90:	7e 14                	jle    da6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
     d92:	31 d2                	xor    %edx,%edx
     d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
     d98:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     d9c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     d9f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     da2:	39 da                	cmp    %ebx,%edx
     da4:	75 f2                	jne    d98 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
     da6:	5b                   	pop    %ebx
     da7:	5e                   	pop    %esi
     da8:	5d                   	pop    %ebp
     da9:	c3                   	ret    
     daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000db0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
     db0:	55                   	push   %ebp
     db1:	89 e5                	mov    %esp,%ebp
     db3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     db6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
     db9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
     dbc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
     dbf:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dc4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     dcb:	00 
     dcc:	89 04 24             	mov    %eax,(%esp)
     dcf:	e8 d4 00 00 00       	call   ea8 <open>
  if(fd < 0)
     dd4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dd6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
     dd8:	78 19                	js     df3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
     dda:	8b 45 0c             	mov    0xc(%ebp),%eax
     ddd:	89 1c 24             	mov    %ebx,(%esp)
     de0:	89 44 24 04          	mov    %eax,0x4(%esp)
     de4:	e8 d7 00 00 00       	call   ec0 <fstat>
  close(fd);
     de9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
     dec:	89 c6                	mov    %eax,%esi
  close(fd);
     dee:	e8 9d 00 00 00       	call   e90 <close>
  return r;
}
     df3:	89 f0                	mov    %esi,%eax
     df5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
     df8:	8b 75 fc             	mov    -0x4(%ebp),%esi
     dfb:	89 ec                	mov    %ebp,%esp
     dfd:	5d                   	pop    %ebp
     dfe:	c3                   	ret    
     dff:	90                   	nop

00000e00 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
     e00:	55                   	push   %ebp
     e01:	89 e5                	mov    %esp,%ebp
     e03:	57                   	push   %edi
     e04:	56                   	push   %esi
     e05:	31 f6                	xor    %esi,%esi
     e07:	53                   	push   %ebx
     e08:	83 ec 2c             	sub    $0x2c,%esp
     e0b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e0e:	eb 06                	jmp    e16 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     e10:	3c 0a                	cmp    $0xa,%al
     e12:	74 39                	je     e4d <gets+0x4d>
     e14:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e16:	8d 5e 01             	lea    0x1(%esi),%ebx
     e19:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     e1c:	7d 31                	jge    e4f <gets+0x4f>
    cc = read(0, &c, 1);
     e1e:	8d 45 e7             	lea    -0x19(%ebp),%eax
     e21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e28:	00 
     e29:	89 44 24 04          	mov    %eax,0x4(%esp)
     e2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e34:	e8 47 00 00 00       	call   e80 <read>
    if(cc < 1)
     e39:	85 c0                	test   %eax,%eax
     e3b:	7e 12                	jle    e4f <gets+0x4f>
      break;
    buf[i++] = c;
     e3d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     e41:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
     e45:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     e49:	3c 0d                	cmp    $0xd,%al
     e4b:	75 c3                	jne    e10 <gets+0x10>
     e4d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
     e4f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
     e53:	89 f8                	mov    %edi,%eax
     e55:	83 c4 2c             	add    $0x2c,%esp
     e58:	5b                   	pop    %ebx
     e59:	5e                   	pop    %esi
     e5a:	5f                   	pop    %edi
     e5b:	5d                   	pop    %ebp
     e5c:	c3                   	ret    
     e5d:	90                   	nop
     e5e:	90                   	nop
     e5f:	90                   	nop

00000e60 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     e60:	b8 01 00 00 00       	mov    $0x1,%eax
     e65:	cd 40                	int    $0x40
     e67:	c3                   	ret    

00000e68 <exit>:
SYSCALL(exit)
     e68:	b8 02 00 00 00       	mov    $0x2,%eax
     e6d:	cd 40                	int    $0x40
     e6f:	c3                   	ret    

00000e70 <wait>:
SYSCALL(wait)
     e70:	b8 03 00 00 00       	mov    $0x3,%eax
     e75:	cd 40                	int    $0x40
     e77:	c3                   	ret    

00000e78 <pipe>:
SYSCALL(pipe)
     e78:	b8 04 00 00 00       	mov    $0x4,%eax
     e7d:	cd 40                	int    $0x40
     e7f:	c3                   	ret    

00000e80 <read>:
SYSCALL(read)
     e80:	b8 05 00 00 00       	mov    $0x5,%eax
     e85:	cd 40                	int    $0x40
     e87:	c3                   	ret    

00000e88 <write>:
SYSCALL(write)
     e88:	b8 10 00 00 00       	mov    $0x10,%eax
     e8d:	cd 40                	int    $0x40
     e8f:	c3                   	ret    

00000e90 <close>:
SYSCALL(close)
     e90:	b8 15 00 00 00       	mov    $0x15,%eax
     e95:	cd 40                	int    $0x40
     e97:	c3                   	ret    

00000e98 <kill>:
SYSCALL(kill)
     e98:	b8 06 00 00 00       	mov    $0x6,%eax
     e9d:	cd 40                	int    $0x40
     e9f:	c3                   	ret    

00000ea0 <exec>:
SYSCALL(exec)
     ea0:	b8 07 00 00 00       	mov    $0x7,%eax
     ea5:	cd 40                	int    $0x40
     ea7:	c3                   	ret    

00000ea8 <open>:
SYSCALL(open)
     ea8:	b8 0f 00 00 00       	mov    $0xf,%eax
     ead:	cd 40                	int    $0x40
     eaf:	c3                   	ret    

00000eb0 <mknod>:
SYSCALL(mknod)
     eb0:	b8 11 00 00 00       	mov    $0x11,%eax
     eb5:	cd 40                	int    $0x40
     eb7:	c3                   	ret    

00000eb8 <unlink>:
SYSCALL(unlink)
     eb8:	b8 12 00 00 00       	mov    $0x12,%eax
     ebd:	cd 40                	int    $0x40
     ebf:	c3                   	ret    

00000ec0 <fstat>:
SYSCALL(fstat)
     ec0:	b8 08 00 00 00       	mov    $0x8,%eax
     ec5:	cd 40                	int    $0x40
     ec7:	c3                   	ret    

00000ec8 <link>:
SYSCALL(link)
     ec8:	b8 13 00 00 00       	mov    $0x13,%eax
     ecd:	cd 40                	int    $0x40
     ecf:	c3                   	ret    

00000ed0 <mkdir>:
SYSCALL(mkdir)
     ed0:	b8 14 00 00 00       	mov    $0x14,%eax
     ed5:	cd 40                	int    $0x40
     ed7:	c3                   	ret    

00000ed8 <chdir>:
SYSCALL(chdir)
     ed8:	b8 09 00 00 00       	mov    $0x9,%eax
     edd:	cd 40                	int    $0x40
     edf:	c3                   	ret    

00000ee0 <dup>:
SYSCALL(dup)
     ee0:	b8 0a 00 00 00       	mov    $0xa,%eax
     ee5:	cd 40                	int    $0x40
     ee7:	c3                   	ret    

00000ee8 <getpid>:
SYSCALL(getpid)
     ee8:	b8 0b 00 00 00       	mov    $0xb,%eax
     eed:	cd 40                	int    $0x40
     eef:	c3                   	ret    

00000ef0 <sbrk>:
SYSCALL(sbrk)
     ef0:	b8 0c 00 00 00       	mov    $0xc,%eax
     ef5:	cd 40                	int    $0x40
     ef7:	c3                   	ret    

00000ef8 <sleep>:
SYSCALL(sleep)
     ef8:	b8 0d 00 00 00       	mov    $0xd,%eax
     efd:	cd 40                	int    $0x40
     eff:	c3                   	ret    

00000f00 <uptime>:
SYSCALL(uptime)
     f00:	b8 0e 00 00 00       	mov    $0xe,%eax
     f05:	cd 40                	int    $0x40
     f07:	c3                   	ret    

00000f08 <gettime>:
SYSCALL(gettime)
     f08:	b8 16 00 00 00       	mov    $0x16,%eax
     f0d:	cd 40                	int    $0x40
     f0f:	c3                   	ret    

00000f10 <shared>:
SYSCALL(shared)
     f10:	b8 17 00 00 00       	mov    $0x17,%eax
     f15:	cd 40                	int    $0x40
     f17:	c3                   	ret    
     f18:	90                   	nop
     f19:	90                   	nop
     f1a:	90                   	nop
     f1b:	90                   	nop
     f1c:	90                   	nop
     f1d:	90                   	nop
     f1e:	90                   	nop
     f1f:	90                   	nop

00000f20 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     f20:	55                   	push   %ebp
     f21:	89 e5                	mov    %esp,%ebp
     f23:	57                   	push   %edi
     f24:	89 cf                	mov    %ecx,%edi
     f26:	56                   	push   %esi
     f27:	89 c6                	mov    %eax,%esi
     f29:	53                   	push   %ebx
     f2a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
     f30:	85 c9                	test   %ecx,%ecx
     f32:	74 04                	je     f38 <printint+0x18>
     f34:	85 d2                	test   %edx,%edx
     f36:	78 68                	js     fa0 <printint+0x80>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f38:	89 d0                	mov    %edx,%eax
     f3a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     f41:	31 c9                	xor    %ecx,%ecx
     f43:	8d 5d d7             	lea    -0x29(%ebp),%ebx
     f46:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
     f48:	31 d2                	xor    %edx,%edx
     f4a:	f7 f7                	div    %edi
     f4c:	0f b6 92 06 14 00 00 	movzbl 0x1406(%edx),%edx
     f53:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
     f56:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
     f59:	85 c0                	test   %eax,%eax
     f5b:	75 eb                	jne    f48 <printint+0x28>
  if(neg)
     f5d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     f60:	85 c0                	test   %eax,%eax
     f62:	74 08                	je     f6c <printint+0x4c>
    buf[i++] = '-';
     f64:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
     f69:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
     f6c:	8d 79 ff             	lea    -0x1(%ecx),%edi
     f6f:	90                   	nop
     f70:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
     f74:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
     f77:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     f7e:	00 
     f7f:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     f82:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
     f85:	8d 45 e7             	lea    -0x19(%ebp),%eax
     f88:	89 44 24 04          	mov    %eax,0x4(%esp)
     f8c:	e8 f7 fe ff ff       	call   e88 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     f91:	83 ff ff             	cmp    $0xffffffff,%edi
     f94:	75 da                	jne    f70 <printint+0x50>
    putc(fd, buf[i]);
}
     f96:	83 c4 4c             	add    $0x4c,%esp
     f99:	5b                   	pop    %ebx
     f9a:	5e                   	pop    %esi
     f9b:	5f                   	pop    %edi
     f9c:	5d                   	pop    %ebp
     f9d:	c3                   	ret    
     f9e:	66 90                	xchg   %ax,%ax
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     fa0:	89 d0                	mov    %edx,%eax
     fa2:	f7 d8                	neg    %eax
     fa4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
     fab:	eb 94                	jmp    f41 <printint+0x21>
     fad:	8d 76 00             	lea    0x0(%esi),%esi

00000fb0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     fb0:	55                   	push   %ebp
     fb1:	89 e5                	mov    %esp,%ebp
     fb3:	57                   	push   %edi
     fb4:	56                   	push   %esi
     fb5:	53                   	push   %ebx
     fb6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
     fbc:	0f b6 10             	movzbl (%eax),%edx
     fbf:	84 d2                	test   %dl,%dl
     fc1:	0f 84 c1 00 00 00    	je     1088 <printf+0xd8>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
     fc7:	8d 4d 10             	lea    0x10(%ebp),%ecx
     fca:	31 ff                	xor    %edi,%edi
     fcc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
     fcf:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
     fd1:	8d 75 e7             	lea    -0x19(%ebp),%esi
     fd4:	eb 1e                	jmp    ff4 <printf+0x44>
     fd6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
     fd8:	83 fa 25             	cmp    $0x25,%edx
     fdb:	0f 85 af 00 00 00    	jne    1090 <printf+0xe0>
     fe1:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     fe5:	83 c3 01             	add    $0x1,%ebx
     fe8:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
     fec:	84 d2                	test   %dl,%dl
     fee:	0f 84 94 00 00 00    	je     1088 <printf+0xd8>
    c = fmt[i] & 0xff;
    if(state == 0){
     ff4:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
     ff6:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
     ff9:	74 dd                	je     fd8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ffb:	83 ff 25             	cmp    $0x25,%edi
     ffe:	75 e5                	jne    fe5 <printf+0x35>
      if(c == 'd'){
    1000:	83 fa 64             	cmp    $0x64,%edx
    1003:	0f 84 3f 01 00 00    	je     1148 <printf+0x198>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1009:	83 fa 70             	cmp    $0x70,%edx
    100c:	0f 84 a6 00 00 00    	je     10b8 <printf+0x108>
    1012:	83 fa 78             	cmp    $0x78,%edx
    1015:	0f 84 9d 00 00 00    	je     10b8 <printf+0x108>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    101b:	83 fa 73             	cmp    $0x73,%edx
    101e:	66 90                	xchg   %ax,%ax
    1020:	0f 84 ba 00 00 00    	je     10e0 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1026:	83 fa 63             	cmp    $0x63,%edx
    1029:	0f 84 41 01 00 00    	je     1170 <printf+0x1c0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    102f:	83 fa 25             	cmp    $0x25,%edx
    1032:	0f 84 00 01 00 00    	je     1138 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1038:	8b 4d 08             	mov    0x8(%ebp),%ecx
    103b:	89 55 cc             	mov    %edx,-0x34(%ebp)
    103e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    1042:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1049:	00 
    104a:	89 74 24 04          	mov    %esi,0x4(%esp)
    104e:	89 0c 24             	mov    %ecx,(%esp)
    1051:	e8 32 fe ff ff       	call   e88 <write>
    1056:	8b 55 cc             	mov    -0x34(%ebp),%edx
    1059:	88 55 e7             	mov    %dl,-0x19(%ebp)
    105c:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    105f:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1062:	31 ff                	xor    %edi,%edi
    1064:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    106b:	00 
    106c:	89 74 24 04          	mov    %esi,0x4(%esp)
    1070:	89 04 24             	mov    %eax,(%esp)
    1073:	e8 10 fe ff ff       	call   e88 <write>
    1078:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    107b:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
    107f:	84 d2                	test   %dl,%dl
    1081:	0f 85 6d ff ff ff    	jne    ff4 <printf+0x44>
    1087:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1088:	83 c4 3c             	add    $0x3c,%esp
    108b:	5b                   	pop    %ebx
    108c:	5e                   	pop    %esi
    108d:	5f                   	pop    %edi
    108e:	5d                   	pop    %ebp
    108f:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1090:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1093:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1096:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    109d:	00 
    109e:	89 74 24 04          	mov    %esi,0x4(%esp)
    10a2:	89 04 24             	mov    %eax,(%esp)
    10a5:	e8 de fd ff ff       	call   e88 <write>
    10aa:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ad:	e9 33 ff ff ff       	jmp    fe5 <printf+0x35>
    10b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    10b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    10bb:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
    10c0:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    10c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    10c9:	8b 10                	mov    (%eax),%edx
    10cb:	8b 45 08             	mov    0x8(%ebp),%eax
    10ce:	e8 4d fe ff ff       	call   f20 <printint>
    10d3:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    10d6:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    10da:	e9 06 ff ff ff       	jmp    fe5 <printf+0x35>
    10df:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
    10e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
    10e3:	b9 ff 13 00 00       	mov    $0x13ff,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
    10e8:	8b 3a                	mov    (%edx),%edi
        ap++;
    10ea:	83 c2 04             	add    $0x4,%edx
    10ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
    10f0:	85 ff                	test   %edi,%edi
    10f2:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
    10f5:	0f b6 17             	movzbl (%edi),%edx
    10f8:	84 d2                	test   %dl,%dl
    10fa:	74 33                	je     112f <printf+0x17f>
    10fc:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    10ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
    1108:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    110b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    110e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1115:	00 
    1116:	89 74 24 04          	mov    %esi,0x4(%esp)
    111a:	89 1c 24             	mov    %ebx,(%esp)
    111d:	e8 66 fd ff ff       	call   e88 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1122:	0f b6 17             	movzbl (%edi),%edx
    1125:	84 d2                	test   %dl,%dl
    1127:	75 df                	jne    1108 <printf+0x158>
    1129:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    112c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    112f:	31 ff                	xor    %edi,%edi
    1131:	e9 af fe ff ff       	jmp    fe5 <printf+0x35>
    1136:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1138:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    113c:	e9 1b ff ff ff       	jmp    105c <printf+0xac>
    1141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    1148:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    114b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
    1150:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    1153:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    115a:	8b 10                	mov    (%eax),%edx
    115c:	8b 45 08             	mov    0x8(%ebp),%eax
    115f:	e8 bc fd ff ff       	call   f20 <printint>
    1164:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    1167:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    116b:	e9 75 fe ff ff       	jmp    fe5 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1170:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
    1173:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1175:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1178:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    117a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1181:	00 
    1182:	89 74 24 04          	mov    %esi,0x4(%esp)
    1186:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1189:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    118c:	e8 f7 fc ff ff       	call   e88 <write>
    1191:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    1194:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    1198:	e9 48 fe ff ff       	jmp    fe5 <printf+0x35>
    119d:	90                   	nop
    119e:	90                   	nop
    119f:	90                   	nop

000011a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11a1:	a1 ac 14 00 00       	mov    0x14ac,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    11a6:	89 e5                	mov    %esp,%ebp
    11a8:	57                   	push   %edi
    11a9:	56                   	push   %esi
    11aa:	53                   	push   %ebx
    11ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11b1:	39 c8                	cmp    %ecx,%eax
    11b3:	73 1d                	jae    11d2 <free+0x32>
    11b5:	8d 76 00             	lea    0x0(%esi),%esi
    11b8:	8b 10                	mov    (%eax),%edx
    11ba:	39 d1                	cmp    %edx,%ecx
    11bc:	72 1a                	jb     11d8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11be:	39 d0                	cmp    %edx,%eax
    11c0:	72 08                	jb     11ca <free+0x2a>
    11c2:	39 c8                	cmp    %ecx,%eax
    11c4:	72 12                	jb     11d8 <free+0x38>
    11c6:	39 d1                	cmp    %edx,%ecx
    11c8:	72 0e                	jb     11d8 <free+0x38>
    11ca:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11cc:	39 c8                	cmp    %ecx,%eax
    11ce:	66 90                	xchg   %ax,%ax
    11d0:	72 e6                	jb     11b8 <free+0x18>
    11d2:	8b 10                	mov    (%eax),%edx
    11d4:	eb e8                	jmp    11be <free+0x1e>
    11d6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    11d8:	8b 71 04             	mov    0x4(%ecx),%esi
    11db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    11de:	39 d7                	cmp    %edx,%edi
    11e0:	74 19                	je     11fb <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    11e2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    11e5:	8b 50 04             	mov    0x4(%eax),%edx
    11e8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    11eb:	39 ce                	cmp    %ecx,%esi
    11ed:	74 23                	je     1212 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    11ef:	89 08                	mov    %ecx,(%eax)
  freep = p;
    11f1:	a3 ac 14 00 00       	mov    %eax,0x14ac
}
    11f6:	5b                   	pop    %ebx
    11f7:	5e                   	pop    %esi
    11f8:	5f                   	pop    %edi
    11f9:	5d                   	pop    %ebp
    11fa:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11fb:	03 72 04             	add    0x4(%edx),%esi
    11fe:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1201:	8b 10                	mov    (%eax),%edx
    1203:	8b 12                	mov    (%edx),%edx
    1205:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1208:	8b 50 04             	mov    0x4(%eax),%edx
    120b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    120e:	39 ce                	cmp    %ecx,%esi
    1210:	75 dd                	jne    11ef <free+0x4f>
    p->s.size += bp->s.size;
    1212:	03 51 04             	add    0x4(%ecx),%edx
    1215:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1218:	8b 53 f8             	mov    -0x8(%ebx),%edx
    121b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
    121d:	a3 ac 14 00 00       	mov    %eax,0x14ac
}
    1222:	5b                   	pop    %ebx
    1223:	5e                   	pop    %esi
    1224:	5f                   	pop    %edi
    1225:	5d                   	pop    %ebp
    1226:	c3                   	ret    
    1227:	89 f6                	mov    %esi,%esi
    1229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001230 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1230:	55                   	push   %ebp
    1231:	89 e5                	mov    %esp,%ebp
    1233:	57                   	push   %edi
    1234:	56                   	push   %esi
    1235:	53                   	push   %ebx
    1236:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1239:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
    123c:	8b 0d ac 14 00 00    	mov    0x14ac,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1242:	83 c3 07             	add    $0x7,%ebx
    1245:	c1 eb 03             	shr    $0x3,%ebx
    1248:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    124b:	85 c9                	test   %ecx,%ecx
    124d:	0f 84 9b 00 00 00    	je     12ee <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1253:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    1255:	8b 50 04             	mov    0x4(%eax),%edx
    1258:	39 d3                	cmp    %edx,%ebx
    125a:	76 27                	jbe    1283 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    125c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    1263:	be 00 80 00 00       	mov    $0x8000,%esi
    1268:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    126b:	90                   	nop
    126c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1270:	3b 05 ac 14 00 00    	cmp    0x14ac,%eax
    1276:	74 30                	je     12a8 <malloc+0x78>
    1278:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    127a:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    127c:	8b 50 04             	mov    0x4(%eax),%edx
    127f:	39 d3                	cmp    %edx,%ebx
    1281:	77 ed                	ja     1270 <malloc+0x40>
      if(p->s.size == nunits)
    1283:	39 d3                	cmp    %edx,%ebx
    1285:	74 61                	je     12e8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1287:	29 da                	sub    %ebx,%edx
    1289:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    128c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    128f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1292:	89 0d ac 14 00 00    	mov    %ecx,0x14ac
      return (void*)(p + 1);
    1298:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    129b:	83 c4 2c             	add    $0x2c,%esp
    129e:	5b                   	pop    %ebx
    129f:	5e                   	pop    %esi
    12a0:	5f                   	pop    %edi
    12a1:	5d                   	pop    %ebp
    12a2:	c3                   	ret    
    12a3:	90                   	nop
    12a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    12a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12ab:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    12b1:	bf 00 10 00 00       	mov    $0x1000,%edi
    12b6:	0f 43 fb             	cmovae %ebx,%edi
    12b9:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    12bc:	89 04 24             	mov    %eax,(%esp)
    12bf:	e8 2c fc ff ff       	call   ef0 <sbrk>
  if(p == (char*)-1)
    12c4:	83 f8 ff             	cmp    $0xffffffff,%eax
    12c7:	74 18                	je     12e1 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    12c9:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    12cc:	83 c0 08             	add    $0x8,%eax
    12cf:	89 04 24             	mov    %eax,(%esp)
    12d2:	e8 c9 fe ff ff       	call   11a0 <free>
  return freep;
    12d7:	8b 0d ac 14 00 00    	mov    0x14ac,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    12dd:	85 c9                	test   %ecx,%ecx
    12df:	75 99                	jne    127a <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    12e1:	31 c0                	xor    %eax,%eax
    12e3:	eb b6                	jmp    129b <malloc+0x6b>
    12e5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    12e8:	8b 10                	mov    (%eax),%edx
    12ea:	89 11                	mov    %edx,(%ecx)
    12ec:	eb a4                	jmp    1292 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    12ee:	c7 05 ac 14 00 00 a4 	movl   $0x14a4,0x14ac
    12f5:	14 00 00 
    base.s.size = 0;
    12f8:	b9 a4 14 00 00       	mov    $0x14a4,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    12fd:	c7 05 a4 14 00 00 a4 	movl   $0x14a4,0x14a4
    1304:	14 00 00 
    base.s.size = 0;
    1307:	c7 05 a8 14 00 00 00 	movl   $0x0,0x14a8
    130e:	00 00 00 
    1311:	e9 3d ff ff ff       	jmp    1253 <malloc+0x23>
