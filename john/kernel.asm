
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 2b 10 80       	mov    $0x80102b60,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
	...

80100040 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx
80100044:	83 ec 14             	sub    $0x14,%esp
80100047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((b->flags & B_BUSY) == 0)
8010004a:	f6 03 01             	testb  $0x1,(%ebx)
8010004d:	74 57                	je     801000a6 <brelse+0x66>
    panic("brelse");

  acquire(&bcache.lock);
8010004f:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100056:	e8 f5 3e 00 00       	call   80103f50 <acquire>

  b->next->prev = b->prev;
8010005b:	8b 43 10             	mov    0x10(%ebx),%eax
8010005e:	8b 53 0c             	mov    0xc(%ebx),%edx
80100061:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100064:	8b 43 0c             	mov    0xc(%ebx),%eax
80100067:	8b 53 10             	mov    0x10(%ebx),%edx
8010006a:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010006d:	a1 14 cb 10 80       	mov    0x8010cb14,%eax
  b->prev = &bcache.head;
80100072:	c7 43 0c 04 cb 10 80 	movl   $0x8010cb04,0xc(%ebx)

  acquire(&bcache.lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bcache.head.next;
80100079:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bcache.head;
  bcache.head.next->prev = b;
8010007c:	a1 14 cb 10 80       	mov    0x8010cb14,%eax
80100081:	89 58 0c             	mov    %ebx,0xc(%eax)
  bcache.head.next = b;
80100084:	89 1d 14 cb 10 80    	mov    %ebx,0x8010cb14

  b->flags &= ~B_BUSY;
8010008a:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  wakeup(b);
8010008d:	89 1c 24             	mov    %ebx,(%esp)
80100090:	e8 bb 34 00 00       	call   80103550 <wakeup>

  release(&bcache.lock);
80100095:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
8010009c:	83 c4 14             	add    $0x14,%esp
8010009f:	5b                   	pop    %ebx
801000a0:	5d                   	pop    %ebp
  bcache.head.next = b;

  b->flags &= ~B_BUSY;
  wakeup(b);

  release(&bcache.lock);
801000a1:	e9 5a 3e 00 00       	jmp    80103f00 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
801000a6:	c7 04 24 60 6a 10 80 	movl   $0x80106a60,(%esp)
801000ad:	e8 ce 06 00 00       	call   80100780 <panic>
801000b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000c0 <bwrite>:
}

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801000c0:	55                   	push   %ebp
801000c1:	89 e5                	mov    %esp,%ebp
801000c3:	83 ec 18             	sub    $0x18,%esp
801000c6:	8b 45 08             	mov    0x8(%ebp),%eax
  if((b->flags & B_BUSY) == 0)
801000c9:	8b 10                	mov    (%eax),%edx
801000cb:	f6 c2 01             	test   $0x1,%dl
801000ce:	74 0e                	je     801000de <bwrite+0x1e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801000d0:	83 ca 04             	or     $0x4,%edx
801000d3:	89 10                	mov    %edx,(%eax)
  iderw(b);
801000d5:	89 45 08             	mov    %eax,0x8(%ebp)
}
801000d8:	c9                   	leave  
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801000d9:	e9 a2 1e 00 00       	jmp    80101f80 <iderw>
// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
801000de:	c7 04 24 67 6a 10 80 	movl   $0x80106a67,(%esp)
801000e5:	e8 96 06 00 00       	call   80100780 <panic>
801000ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000f0 <bread>:
}

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801000f0:	55                   	push   %ebp
801000f1:	89 e5                	mov    %esp,%ebp
801000f3:	57                   	push   %edi
801000f4:	56                   	push   %esi
801000f5:	53                   	push   %ebx
801000f6:	83 ec 1c             	sub    $0x1c,%esp
801000f9:	8b 75 08             	mov    0x8(%ebp),%esi
801000fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint sector)
{
  struct buf *b;

  acquire(&bcache.lock);
801000ff:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100106:	e8 45 3e 00 00       	call   80103f50 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010010b:	8b 1d 14 cb 10 80    	mov    0x8010cb14,%ebx
80100111:	81 fb 04 cb 10 80    	cmp    $0x8010cb04,%ebx
80100117:	75 12                	jne    8010012b <bread+0x3b>
80100119:	eb 35                	jmp    80100150 <bread+0x60>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100120:	8b 5b 10             	mov    0x10(%ebx),%ebx
80100123:	81 fb 04 cb 10 80    	cmp    $0x8010cb04,%ebx
80100129:	74 25                	je     80100150 <bread+0x60>
    if(b->dev == dev && b->sector == sector){
8010012b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010012e:	75 f0                	jne    80100120 <bread+0x30>
80100130:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100133:	75 eb                	jne    80100120 <bread+0x30>
      if(!(b->flags & B_BUSY)){
80100135:	8b 03                	mov    (%ebx),%eax
80100137:	a8 01                	test   $0x1,%al
80100139:	74 64                	je     8010019f <bread+0xaf>
        b->flags |= B_BUSY;
        release(&bcache.lock);
        return b;
      }
      sleep(b, &bcache.lock);
8010013b:	c7 44 24 04 e0 b5 10 	movl   $0x8010b5e0,0x4(%esp)
80100142:	80 
80100143:	89 1c 24             	mov    %ebx,(%esp)
80100146:	e8 35 35 00 00       	call   80103680 <sleep>
8010014b:	eb be                	jmp    8010010b <bread+0x1b>
8010014d:	8d 76 00             	lea    0x0(%esi),%esi
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100150:	8b 1d 10 cb 10 80    	mov    0x8010cb10,%ebx
80100156:	81 fb 04 cb 10 80    	cmp    $0x8010cb04,%ebx
8010015c:	75 0d                	jne    8010016b <bread+0x7b>
8010015e:	eb 52                	jmp    801001b2 <bread+0xc2>
80100160:	8b 5b 0c             	mov    0xc(%ebx),%ebx
80100163:	81 fb 04 cb 10 80    	cmp    $0x8010cb04,%ebx
80100169:	74 47                	je     801001b2 <bread+0xc2>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010016b:	f6 03 05             	testb  $0x5,(%ebx)
8010016e:	75 f0                	jne    80100160 <bread+0x70>
      b->dev = dev;
80100170:	89 73 04             	mov    %esi,0x4(%ebx)
      b->sector = sector;
80100173:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = B_BUSY;
80100176:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      release(&bcache.lock);
8010017c:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100183:	e8 78 3d 00 00       	call   80103f00 <release>
bread(uint dev, uint sector)
{
  struct buf *b;

  b = bget(dev, sector);
  if(!(b->flags & B_VALID))
80100188:	f6 03 02             	testb  $0x2,(%ebx)
8010018b:	75 08                	jne    80100195 <bread+0xa5>
    iderw(b);
8010018d:	89 1c 24             	mov    %ebx,(%esp)
80100190:	e8 eb 1d 00 00       	call   80101f80 <iderw>
  return b;
}
80100195:	83 c4 1c             	add    $0x1c,%esp
80100198:	89 d8                	mov    %ebx,%eax
8010019a:	5b                   	pop    %ebx
8010019b:	5e                   	pop    %esi
8010019c:	5f                   	pop    %edi
8010019d:	5d                   	pop    %ebp
8010019e:	c3                   	ret    
 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    if(b->dev == dev && b->sector == sector){
      if(!(b->flags & B_BUSY)){
        b->flags |= B_BUSY;
8010019f:	83 c8 01             	or     $0x1,%eax
801001a2:	89 03                	mov    %eax,(%ebx)
        release(&bcache.lock);
801001a4:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801001ab:	e8 50 3d 00 00       	call   80103f00 <release>
801001b0:	eb d6                	jmp    80100188 <bread+0x98>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001b2:	c7 04 24 6e 6a 10 80 	movl   $0x80106a6e,(%esp)
801001b9:	e8 c2 05 00 00       	call   80100780 <panic>
801001be:	66 90                	xchg   %ax,%ax

801001c0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
801001c0:	55                   	push   %ebp
801001c1:	89 e5                	mov    %esp,%ebp
801001c3:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
801001c6:	c7 44 24 04 7f 6a 10 	movl   $0x80106a7f,0x4(%esp)
801001cd:	80 
801001ce:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801001d5:	e8 e6 3b 00 00       	call   80103dc0 <initlock>
  // head.next is most recently used.
  struct buf head;
} bcache;

void
binit(void)
801001da:	ba 04 cb 10 80       	mov    $0x8010cb04,%edx
801001df:	b8 14 b6 10 80       	mov    $0x8010b614,%eax

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
801001e4:	c7 05 10 cb 10 80 04 	movl   $0x8010cb04,0x8010cb10
801001eb:	cb 10 80 
  bcache.head.next = &bcache.head;
801001ee:	c7 05 14 cb 10 80 04 	movl   $0x8010cb04,0x8010cb14
801001f5:	cb 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
801001f8:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
801001fb:	c7 40 0c 04 cb 10 80 	movl   $0x8010cb04,0xc(%eax)
    b->dev = -1;
80100202:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
80100209:	8b 15 14 cb 10 80    	mov    0x8010cb14,%edx
8010020f:	89 42 0c             	mov    %eax,0xc(%edx)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100212:	89 c2                	mov    %eax,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
80100214:	a3 14 cb 10 80       	mov    %eax,0x8010cb14

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100219:	05 18 02 00 00       	add    $0x218,%eax
8010021e:	3d 04 cb 10 80       	cmp    $0x8010cb04,%eax
80100223:	75 d3                	jne    801001f8 <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
80100225:	c9                   	leave  
80100226:	c3                   	ret    
	...

80100230 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100230:	55                   	push   %ebp
80100231:	89 e5                	mov    %esp,%ebp
80100233:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100236:	c7 44 24 04 86 6a 10 	movl   $0x80106a86,0x4(%esp)
8010023d:	80 
8010023e:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
80100245:	e8 76 3b 00 00       	call   80103dc0 <initlock>
  initlock(&input.lock, "input");
8010024a:	c7 44 24 04 8e 6a 10 	movl   $0x80106a8e,0x4(%esp)
80100251:	80 
80100252:	c7 04 24 20 cd 10 80 	movl   $0x8010cd20,(%esp)
80100259:	e8 62 3b 00 00       	call   80103dc0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
8010025e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
consoleinit(void)
{
  initlock(&cons.lock, "console");
  initlock(&input.lock, "input");

  devsw[CONSOLE].write = consolewrite;
80100265:	c7 05 8c d7 10 80 10 	movl   $0x80100410,0x8010d78c
8010026c:	04 10 80 
  devsw[CONSOLE].read = consoleread;
8010026f:	c7 05 88 d7 10 80 00 	movl   $0x80100500,0x8010d788
80100276:	05 10 80 
  cons.locking = 1;
80100279:	c7 05 74 a5 10 80 01 	movl   $0x1,0x8010a574
80100280:	00 00 00 

  picenable(IRQ_KBD);
80100283:	e8 28 2d 00 00       	call   80102fb0 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100288:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010028f:	00 
80100290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100297:	e8 e4 1e 00 00       	call   80102180 <ioapicenable>
}
8010029c:	c9                   	leave  
8010029d:	c3                   	ret    
8010029e:	66 90                	xchg   %ax,%ax

801002a0 <consputc>:
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801002a0:	55                   	push   %ebp
801002a1:	89 e5                	mov    %esp,%ebp
801002a3:	57                   	push   %edi
801002a4:	56                   	push   %esi
801002a5:	89 c6                	mov    %eax,%esi
801002a7:	53                   	push   %ebx
801002a8:	83 ec 1c             	sub    $0x1c,%esp
  if(panicked){
801002ab:	83 3d 20 a5 10 80 00 	cmpl   $0x0,0x8010a520
801002b2:	74 03                	je     801002b7 <consputc+0x17>
}

static inline void
cli(void)
{
  asm volatile("cli");
801002b4:	fa                   	cli    
801002b5:	eb fe                	jmp    801002b5 <consputc+0x15>
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801002b7:	3d 00 01 00 00       	cmp    $0x100,%eax
801002bc:	0f 84 a0 00 00 00    	je     80100362 <consputc+0xc2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
801002c2:	89 04 24             	mov    %eax,(%esp)
801002c5:	e8 46 53 00 00       	call   80105610 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002ca:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
801002cf:	b8 0e 00 00 00       	mov    $0xe,%eax
801002d4:	89 ca                	mov    %ecx,%edx
801002d6:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002d7:	bf d5 03 00 00       	mov    $0x3d5,%edi
801002dc:	89 fa                	mov    %edi,%edx
801002de:	ec                   	in     (%dx),%al
{
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
801002df:	0f b6 d8             	movzbl %al,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e2:	89 ca                	mov    %ecx,%edx
801002e4:	c1 e3 08             	shl    $0x8,%ebx
801002e7:	b8 0f 00 00 00       	mov    $0xf,%eax
801002ec:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002ed:	89 fa                	mov    %edi,%edx
801002ef:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
801002f0:	0f b6 c0             	movzbl %al,%eax
801002f3:	09 c3                	or     %eax,%ebx

  if(c == '\n')
801002f5:	83 fe 0a             	cmp    $0xa,%esi
801002f8:	0f 84 ee 00 00 00    	je     801003ec <consputc+0x14c>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
801002fe:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100304:	0f 84 cb 00 00 00    	je     801003d5 <consputc+0x135>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010030a:	66 81 e6 ff 00       	and    $0xff,%si
8010030f:	66 81 ce 00 07       	or     $0x700,%si
80100314:	66 89 b4 1b 00 80 0b 	mov    %si,-0x7ff48000(%ebx,%ebx,1)
8010031b:	80 
8010031c:	83 c3 01             	add    $0x1,%ebx
  
  if((pos/80) >= 24){  // Scroll up.
8010031f:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100325:	8d 8c 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%ecx
8010032c:	7f 5d                	jg     8010038b <consputc+0xeb>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010032e:	be d4 03 00 00       	mov    $0x3d4,%esi
80100333:	b8 0e 00 00 00       	mov    $0xe,%eax
80100338:	89 f2                	mov    %esi,%edx
8010033a:	ee                   	out    %al,(%dx)
8010033b:	bf d5 03 00 00       	mov    $0x3d5,%edi
80100340:	89 d8                	mov    %ebx,%eax
80100342:	c1 f8 08             	sar    $0x8,%eax
80100345:	89 fa                	mov    %edi,%edx
80100347:	ee                   	out    %al,(%dx)
80100348:	b8 0f 00 00 00       	mov    $0xf,%eax
8010034d:	89 f2                	mov    %esi,%edx
8010034f:	ee                   	out    %al,(%dx)
80100350:	89 d8                	mov    %ebx,%eax
80100352:	89 fa                	mov    %edi,%edx
80100354:	ee                   	out    %al,(%dx)
  
  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
80100355:	66 c7 01 20 07       	movw   $0x720,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
8010035a:	83 c4 1c             	add    $0x1c,%esp
8010035d:	5b                   	pop    %ebx
8010035e:	5e                   	pop    %esi
8010035f:	5f                   	pop    %edi
80100360:	5d                   	pop    %ebp
80100361:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100362:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100369:	e8 a2 52 00 00       	call   80105610 <uartputc>
8010036e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100375:	e8 96 52 00 00       	call   80105610 <uartputc>
8010037a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100381:	e8 8a 52 00 00       	call   80105610 <uartputc>
80100386:	e9 3f ff ff ff       	jmp    801002ca <consputc+0x2a>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
8010038b:	83 eb 50             	sub    $0x50,%ebx
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010038e:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
80100395:	00 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100396:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010039d:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801003a4:	80 
801003a5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801003ac:	e8 0f 3d 00 00       	call   801040c0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801003b1:	b8 80 07 00 00       	mov    $0x780,%eax
801003b6:	29 d8                	sub    %ebx,%eax
801003b8:	01 c0                	add    %eax,%eax
801003ba:	89 44 24 08          	mov    %eax,0x8(%esp)
801003be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801003c5:	00 
801003c6:	89 34 24             	mov    %esi,(%esp)
801003c9:	e8 22 3c 00 00       	call   80103ff0 <memset>
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
801003ce:	89 f1                	mov    %esi,%ecx
801003d0:	e9 59 ff ff ff       	jmp    8010032e <consputc+0x8e>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
801003d5:	85 db                	test   %ebx,%ebx
801003d7:	8d 8c 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%ecx
801003de:	0f 8e 4a ff ff ff    	jle    8010032e <consputc+0x8e>
801003e4:	83 eb 01             	sub    $0x1,%ebx
801003e7:	e9 33 ff ff ff       	jmp    8010031f <consputc+0x7f>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
801003ec:	89 da                	mov    %ebx,%edx
801003ee:	89 d8                	mov    %ebx,%eax
801003f0:	b9 50 00 00 00       	mov    $0x50,%ecx
801003f5:	83 c3 50             	add    $0x50,%ebx
801003f8:	c1 fa 1f             	sar    $0x1f,%edx
801003fb:	f7 f9                	idiv   %ecx
801003fd:	29 d3                	sub    %edx,%ebx
801003ff:	e9 1b ff ff ff       	jmp    8010031f <consputc+0x7f>
80100404:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010040a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100410 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
80100419:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010041c:	8b 75 10             	mov    0x10(%ebp),%esi
8010041f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  iunlock(ip);
80100422:	89 04 24             	mov    %eax,(%esp)
80100425:	e8 56 17 00 00       	call   80101b80 <iunlock>
  acquire(&cons.lock);
8010042a:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
80100431:	e8 1a 3b 00 00       	call   80103f50 <acquire>
  for(i = 0; i < n; i++)
80100436:	85 f6                	test   %esi,%esi
80100438:	7e 16                	jle    80100450 <consolewrite+0x40>
8010043a:	31 db                	xor    %ebx,%ebx
8010043c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i] & 0xff);
80100440:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100444:	83 c3 01             	add    $0x1,%ebx
    consputc(buf[i] & 0xff);
80100447:	e8 54 fe ff ff       	call   801002a0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010044c:	39 de                	cmp    %ebx,%esi
8010044e:	7f f0                	jg     80100440 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100450:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
80100457:	e8 a4 3a 00 00       	call   80103f00 <release>
  ilock(ip);
8010045c:	8b 45 08             	mov    0x8(%ebp),%eax
8010045f:	89 04 24             	mov    %eax,(%esp)
80100462:	e8 89 17 00 00       	call   80101bf0 <ilock>

  return n;
}
80100467:	83 c4 1c             	add    $0x1c,%esp
8010046a:	89 f0                	mov    %esi,%eax
8010046c:	5b                   	pop    %ebx
8010046d:	5e                   	pop    %esi
8010046e:	5f                   	pop    %edi
8010046f:	5d                   	pop    %ebp
80100470:	c3                   	ret    
80100471:	eb 0d                	jmp    80100480 <printint>
80100473:	90                   	nop
80100474:	90                   	nop
80100475:	90                   	nop
80100476:	90                   	nop
80100477:	90                   	nop
80100478:	90                   	nop
80100479:	90                   	nop
8010047a:	90                   	nop
8010047b:	90                   	nop
8010047c:	90                   	nop
8010047d:	90                   	nop
8010047e:	90                   	nop
8010047f:	90                   	nop

80100480 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100480:	55                   	push   %ebp
80100481:	89 e5                	mov    %esp,%ebp
80100483:	57                   	push   %edi
80100484:	56                   	push   %esi
80100485:	89 d6                	mov    %edx,%esi
80100487:	53                   	push   %ebx
80100488:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010048b:	85 c9                	test   %ecx,%ecx
8010048d:	74 04                	je     80100493 <printint+0x13>
8010048f:	85 c0                	test   %eax,%eax
80100491:	78 55                	js     801004e8 <printint+0x68>
    x = -xx;
  else
    x = xx;
80100493:	31 ff                	xor    %edi,%edi
80100495:	31 c9                	xor    %ecx,%ecx
80100497:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010049a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  i = 0;
  do{
    buf[i++] = digits[x % base];
801004a0:	31 d2                	xor    %edx,%edx
801004a2:	f7 f6                	div    %esi
801004a4:	0f b6 92 b7 6a 10 80 	movzbl -0x7fef9549(%edx),%edx
801004ab:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
801004ae:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
801004b1:	85 c0                	test   %eax,%eax
801004b3:	75 eb                	jne    801004a0 <printint+0x20>

  if(sign)
801004b5:	85 ff                	test   %edi,%edi
801004b7:	74 08                	je     801004c1 <printint+0x41>
    buf[i++] = '-';
801004b9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801004be:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
801004c1:	8d 71 ff             	lea    -0x1(%ecx),%esi
801004c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801004c8:	0f be 04 33          	movsbl (%ebx,%esi,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801004cc:	83 ee 01             	sub    $0x1,%esi
    consputc(buf[i]);
801004cf:	e8 cc fd ff ff       	call   801002a0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801004d4:	83 fe ff             	cmp    $0xffffffff,%esi
801004d7:	75 ef                	jne    801004c8 <printint+0x48>
    consputc(buf[i]);
}
801004d9:	83 c4 1c             	add    $0x1c,%esp
801004dc:	5b                   	pop    %ebx
801004dd:	5e                   	pop    %esi
801004de:	5f                   	pop    %edi
801004df:	5d                   	pop    %ebp
801004e0:	c3                   	ret    
801004e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801004e8:	f7 d8                	neg    %eax
801004ea:	bf 01 00 00 00       	mov    $0x1,%edi
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801004ef:	eb a4                	jmp    80100495 <printint+0x15>
801004f1:	eb 0d                	jmp    80100500 <consoleread>
801004f3:	90                   	nop
801004f4:	90                   	nop
801004f5:	90                   	nop
801004f6:	90                   	nop
801004f7:	90                   	nop
801004f8:	90                   	nop
801004f9:	90                   	nop
801004fa:	90                   	nop
801004fb:	90                   	nop
801004fc:	90                   	nop
801004fd:	90                   	nop
801004fe:	90                   	nop
801004ff:	90                   	nop

80100500 <consoleread>:
  release(&input.lock);
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100500:	55                   	push   %ebp
80100501:	89 e5                	mov    %esp,%ebp
80100503:	57                   	push   %edi
80100504:	56                   	push   %esi
80100505:	53                   	push   %ebx
80100506:	83 ec 3c             	sub    $0x3c,%esp
80100509:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010050c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010050f:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
80100512:	89 3c 24             	mov    %edi,(%esp)
80100515:	e8 66 16 00 00       	call   80101b80 <iunlock>
  target = n;
8010051a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&input.lock);
8010051d:	c7 04 24 20 cd 10 80 	movl   $0x8010cd20,(%esp)
80100524:	e8 27 3a 00 00       	call   80103f50 <acquire>
  while(n > 0){
80100529:	85 db                	test   %ebx,%ebx
8010052b:	7f 2c                	jg     80100559 <consoleread+0x59>
8010052d:	e9 c0 00 00 00       	jmp    801005f2 <consoleread+0xf2>
80100532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(input.r == input.w){
      if(proc->killed){
80100538:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010053e:	8b 40 24             	mov    0x24(%eax),%eax
80100541:	85 c0                	test   %eax,%eax
80100543:	75 5b                	jne    801005a0 <consoleread+0xa0>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
80100545:	c7 44 24 04 20 cd 10 	movl   $0x8010cd20,0x4(%esp)
8010054c:	80 
8010054d:	c7 04 24 d4 cd 10 80 	movl   $0x8010cdd4,(%esp)
80100554:	e8 27 31 00 00       	call   80103680 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100559:	a1 d4 cd 10 80       	mov    0x8010cdd4,%eax
8010055e:	3b 05 d8 cd 10 80    	cmp    0x8010cdd8,%eax
80100564:	74 d2                	je     80100538 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100566:	89 c2                	mov    %eax,%edx
80100568:	83 e2 7f             	and    $0x7f,%edx
8010056b:	0f b6 8a 54 cd 10 80 	movzbl -0x7fef32ac(%edx),%ecx
80100572:	0f be d1             	movsbl %cl,%edx
80100575:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80100578:	8d 50 01             	lea    0x1(%eax),%edx
    if(c == C('D')){  // EOF
8010057b:	83 7d d4 04          	cmpl   $0x4,-0x2c(%ebp)
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
8010057f:	89 15 d4 cd 10 80    	mov    %edx,0x8010cdd4
    if(c == C('D')){  // EOF
80100585:	74 3a                	je     801005c1 <consoleread+0xc1>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100587:	88 0e                	mov    %cl,(%esi)
    --n;
80100589:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010058c:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
80100590:	74 39                	je     801005cb <consoleread+0xcb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100592:	85 db                	test   %ebx,%ebx
80100594:	7e 35                	jle    801005cb <consoleread+0xcb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100596:	83 c6 01             	add    $0x1,%esi
80100599:	eb be                	jmp    80100559 <consoleread+0x59>
8010059b:	90                   	nop
8010059c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&input.lock);
801005a0:	c7 04 24 20 cd 10 80 	movl   $0x8010cd20,(%esp)
801005a7:	e8 54 39 00 00       	call   80103f00 <release>
        ilock(ip);
801005ac:	89 3c 24             	mov    %edi,(%esp)
801005af:	e8 3c 16 00 00       	call   80101bf0 <ilock>
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}
801005b4:	83 c4 3c             	add    $0x3c,%esp
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&input.lock);
        ilock(ip);
801005b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}
801005bc:	5b                   	pop    %ebx
801005bd:	5e                   	pop    %esi
801005be:	5f                   	pop    %edi
801005bf:	5d                   	pop    %ebp
801005c0:	c3                   	ret    
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
801005c1:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
801005c4:	76 05                	jbe    801005cb <consoleread+0xcb>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801005c6:	a3 d4 cd 10 80       	mov    %eax,0x8010cdd4
801005cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801005ce:	29 d8                	sub    %ebx,%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
801005d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801005d3:	c7 04 24 20 cd 10 80 	movl   $0x8010cd20,(%esp)
801005da:	e8 21 39 00 00       	call   80103f00 <release>
  ilock(ip);
801005df:	89 3c 24             	mov    %edi,(%esp)
801005e2:	e8 09 16 00 00       	call   80101bf0 <ilock>
801005e7:	8b 45 e0             	mov    -0x20(%ebp),%eax

  return target - n;
}
801005ea:	83 c4 3c             	add    $0x3c,%esp
801005ed:	5b                   	pop    %ebx
801005ee:	5e                   	pop    %esi
801005ef:	5f                   	pop    %edi
801005f0:	5d                   	pop    %ebp
801005f1:	c3                   	ret    
  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
801005f2:	31 c0                	xor    %eax,%eax
801005f4:	eb da                	jmp    801005d0 <consoleread+0xd0>
801005f6:	8d 76 00             	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
80100604:	bf 50 cd 10 80       	mov    $0x8010cd50,%edi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100609:	56                   	push   %esi
8010060a:	53                   	push   %ebx
8010060b:	83 ec 1c             	sub    $0x1c,%esp
8010060e:	8b 75 08             	mov    0x8(%ebp),%esi
  int c;

  acquire(&input.lock);
80100611:	c7 04 24 20 cd 10 80 	movl   $0x8010cd20,(%esp)
80100618:	e8 33 39 00 00       	call   80103f50 <acquire>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
80100620:	ff d6                	call   *%esi
80100622:	85 c0                	test   %eax,%eax
80100624:	89 c3                	mov    %eax,%ebx
80100626:	0f 88 9c 00 00 00    	js     801006c8 <consoleintr+0xc8>
    switch(c){
8010062c:	83 fb 10             	cmp    $0x10,%ebx
8010062f:	90                   	nop
80100630:	0f 84 1a 01 00 00    	je     80100750 <consoleintr+0x150>
80100636:	0f 8f a4 00 00 00    	jg     801006e0 <consoleintr+0xe0>
8010063c:	83 fb 08             	cmp    $0x8,%ebx
8010063f:	90                   	nop
80100640:	0f 84 a8 00 00 00    	je     801006ee <consoleintr+0xee>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100646:	85 db                	test   %ebx,%ebx
80100648:	74 d6                	je     80100620 <consoleintr+0x20>
8010064a:	a1 dc cd 10 80       	mov    0x8010cddc,%eax
8010064f:	89 c2                	mov    %eax,%edx
80100651:	2b 15 d4 cd 10 80    	sub    0x8010cdd4,%edx
80100657:	83 fa 7f             	cmp    $0x7f,%edx
8010065a:	77 c4                	ja     80100620 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
8010065c:	83 fb 0d             	cmp    $0xd,%ebx
8010065f:	0f 84 f5 00 00 00    	je     8010075a <consoleintr+0x15a>
        input.buf[input.e++ % INPUT_BUF] = c;
80100665:	89 c2                	mov    %eax,%edx
80100667:	83 c0 01             	add    $0x1,%eax
8010066a:	83 e2 7f             	and    $0x7f,%edx
8010066d:	88 5c 17 04          	mov    %bl,0x4(%edi,%edx,1)
80100671:	a3 dc cd 10 80       	mov    %eax,0x8010cddc
        consputc(c);
80100676:	89 d8                	mov    %ebx,%eax
80100678:	e8 23 fc ff ff       	call   801002a0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010067d:	83 fb 04             	cmp    $0x4,%ebx
80100680:	0f 84 f0 00 00 00    	je     80100776 <consoleintr+0x176>
80100686:	83 fb 0a             	cmp    $0xa,%ebx
80100689:	0f 84 e7 00 00 00    	je     80100776 <consoleintr+0x176>
8010068f:	8b 15 d4 cd 10 80    	mov    0x8010cdd4,%edx
80100695:	a1 dc cd 10 80       	mov    0x8010cddc,%eax
8010069a:	83 ea 80             	sub    $0xffffff80,%edx
8010069d:	39 d0                	cmp    %edx,%eax
8010069f:	0f 85 7b ff ff ff    	jne    80100620 <consoleintr+0x20>
          input.w = input.e;
801006a5:	a3 d8 cd 10 80       	mov    %eax,0x8010cdd8
          wakeup(&input.r);
801006aa:	c7 04 24 d4 cd 10 80 	movl   $0x8010cdd4,(%esp)
801006b1:	e8 9a 2e 00 00       	call   80103550 <wakeup>
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801006b6:	ff d6                	call   *%esi
801006b8:	85 c0                	test   %eax,%eax
801006ba:	89 c3                	mov    %eax,%ebx
801006bc:	0f 89 6a ff ff ff    	jns    8010062c <consoleintr+0x2c>
801006c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        }
      }
      break;
    }
  }
  release(&input.lock);
801006c8:	c7 45 08 20 cd 10 80 	movl   $0x8010cd20,0x8(%ebp)
}
801006cf:	83 c4 1c             	add    $0x1c,%esp
801006d2:	5b                   	pop    %ebx
801006d3:	5e                   	pop    %esi
801006d4:	5f                   	pop    %edi
801006d5:	5d                   	pop    %ebp
        }
      }
      break;
    }
  }
  release(&input.lock);
801006d6:	e9 25 38 00 00       	jmp    80103f00 <release>
801006db:	90                   	nop
801006dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
801006e0:	83 fb 15             	cmp    $0x15,%ebx
801006e3:	74 57                	je     8010073c <consoleintr+0x13c>
801006e5:	83 fb 7f             	cmp    $0x7f,%ebx
801006e8:	0f 85 58 ff ff ff    	jne    80100646 <consoleintr+0x46>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801006ee:	a1 dc cd 10 80       	mov    0x8010cddc,%eax
801006f3:	3b 05 d8 cd 10 80    	cmp    0x8010cdd8,%eax
801006f9:	0f 84 21 ff ff ff    	je     80100620 <consoleintr+0x20>
        input.e--;
801006ff:	83 e8 01             	sub    $0x1,%eax
80100702:	a3 dc cd 10 80       	mov    %eax,0x8010cddc
        consputc(BACKSPACE);
80100707:	b8 00 01 00 00       	mov    $0x100,%eax
8010070c:	e8 8f fb ff ff       	call   801002a0 <consputc>
80100711:	e9 0a ff ff ff       	jmp    80100620 <consoleintr+0x20>
80100716:	66 90                	xchg   %ax,%ax
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100718:	83 e8 01             	sub    $0x1,%eax
8010071b:	89 c2                	mov    %eax,%edx
8010071d:	83 e2 7f             	and    $0x7f,%edx
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100720:	80 ba 54 cd 10 80 0a 	cmpb   $0xa,-0x7fef32ac(%edx)
80100727:	0f 84 f3 fe ff ff    	je     80100620 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010072d:	a3 dc cd 10 80       	mov    %eax,0x8010cddc
        consputc(BACKSPACE);
80100732:	b8 00 01 00 00       	mov    $0x100,%eax
80100737:	e8 64 fb ff ff       	call   801002a0 <consputc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010073c:	a1 dc cd 10 80       	mov    0x8010cddc,%eax
80100741:	3b 05 d8 cd 10 80    	cmp    0x8010cdd8,%eax
80100747:	75 cf                	jne    80100718 <consoleintr+0x118>
80100749:	e9 d2 fe ff ff       	jmp    80100620 <consoleintr+0x20>
8010074e:	66 90                	xchg   %ax,%ax

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
80100750:	e8 9b 2c 00 00       	call   801033f0 <procdump>
      break;
80100755:	e9 c6 fe ff ff       	jmp    80100620 <consoleintr+0x20>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010075a:	89 c2                	mov    %eax,%edx
8010075c:	83 c0 01             	add    $0x1,%eax
8010075f:	83 e2 7f             	and    $0x7f,%edx
80100762:	c6 44 17 04 0a       	movb   $0xa,0x4(%edi,%edx,1)
80100767:	a3 dc cd 10 80       	mov    %eax,0x8010cddc
        consputc(c);
8010076c:	b8 0a 00 00 00       	mov    $0xa,%eax
80100771:	e8 2a fb ff ff       	call   801002a0 <consputc>
80100776:	a1 dc cd 10 80       	mov    0x8010cddc,%eax
8010077b:	e9 25 ff ff ff       	jmp    801006a5 <consoleintr+0xa5>

80100780 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100780:	55                   	push   %ebp
80100781:	89 e5                	mov    %esp,%ebp
80100783:	56                   	push   %esi
80100784:	53                   	push   %ebx
80100785:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100788:	fa                   	cli    
  int i;
  uint pcs[10];
  
  cli();
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
80100789:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
8010078f:	8d 75 d0             	lea    -0x30(%ebp),%esi
80100792:	31 db                	xor    %ebx,%ebx
{
  int i;
  uint pcs[10];
  
  cli();
  cons.locking = 0;
80100794:	c7 05 74 a5 10 80 00 	movl   $0x0,0x8010a574
8010079b:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010079e:	0f b6 00             	movzbl (%eax),%eax
801007a1:	c7 04 24 94 6a 10 80 	movl   $0x80106a94,(%esp)
801007a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801007ac:	e8 4f 00 00 00       	call   80100800 <cprintf>
  cprintf(s);
801007b1:	8b 45 08             	mov    0x8(%ebp),%eax
801007b4:	89 04 24             	mov    %eax,(%esp)
801007b7:	e8 44 00 00 00       	call   80100800 <cprintf>
  cprintf("\n");
801007bc:	c7 04 24 d3 6e 10 80 	movl   $0x80106ed3,(%esp)
801007c3:	e8 38 00 00 00       	call   80100800 <cprintf>
  getcallerpcs(&s, pcs);
801007c8:	8d 45 08             	lea    0x8(%ebp),%eax
801007cb:	89 74 24 04          	mov    %esi,0x4(%esp)
801007cf:	89 04 24             	mov    %eax,(%esp)
801007d2:	e8 09 36 00 00       	call   80103de0 <getcallerpcs>
801007d7:	90                   	nop
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801007d8:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801007db:	83 c3 01             	add    $0x1,%ebx
    cprintf(" %p", pcs[i]);
801007de:	c7 04 24 a3 6a 10 80 	movl   $0x80106aa3,(%esp)
801007e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801007e9:	e8 12 00 00 00       	call   80100800 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801007ee:	83 fb 0a             	cmp    $0xa,%ebx
801007f1:	75 e5                	jne    801007d8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801007f3:	c7 05 20 a5 10 80 01 	movl   $0x1,0x8010a520
801007fa:	00 00 00 
801007fd:	eb fe                	jmp    801007fd <panic+0x7d>
801007ff:	90                   	nop

80100800 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100800:	55                   	push   %ebp
80100801:	89 e5                	mov    %esp,%ebp
80100803:	57                   	push   %edi
80100804:	56                   	push   %esi
80100805:	53                   	push   %ebx
80100806:	83 ec 2c             	sub    $0x2c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100809:	8b 3d 74 a5 10 80    	mov    0x8010a574,%edi
  if(locking)
8010080f:	85 ff                	test   %edi,%edi
80100811:	0f 85 31 01 00 00    	jne    80100948 <cprintf+0x148>
    acquire(&cons.lock);

  if (fmt == 0)
80100817:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010081a:	85 c9                	test   %ecx,%ecx
8010081c:	0f 84 37 01 00 00    	je     80100959 <cprintf+0x159>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100822:	0f b6 01             	movzbl (%ecx),%eax
80100825:	85 c0                	test   %eax,%eax
80100827:	0f 84 8b 00 00 00    	je     801008b8 <cprintf+0xb8>
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
8010082d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100830:	31 db                	xor    %ebx,%ebx
80100832:	eb 3f                	jmp    80100873 <cprintf+0x73>
80100834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100838:	83 fa 25             	cmp    $0x25,%edx
8010083b:	0f 84 af 00 00 00    	je     801008f0 <cprintf+0xf0>
80100841:	83 fa 64             	cmp    $0x64,%edx
80100844:	0f 84 86 00 00 00    	je     801008d0 <cprintf+0xd0>
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010084a:	b8 25 00 00 00       	mov    $0x25,%eax
8010084f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100852:	e8 49 fa ff ff       	call   801002a0 <consputc>
      consputc(c);
80100857:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010085a:	89 d0                	mov    %edx,%eax
8010085c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100860:	e8 3b fa ff ff       	call   801002a0 <consputc>
80100865:	8b 4d 08             	mov    0x8(%ebp),%ecx

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100868:	83 c3 01             	add    $0x1,%ebx
8010086b:	0f b6 04 19          	movzbl (%ecx,%ebx,1),%eax
8010086f:	85 c0                	test   %eax,%eax
80100871:	74 45                	je     801008b8 <cprintf+0xb8>
    if(c != '%'){
80100873:	83 f8 25             	cmp    $0x25,%eax
80100876:	75 e8                	jne    80100860 <cprintf+0x60>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100878:	83 c3 01             	add    $0x1,%ebx
8010087b:	0f b6 14 19          	movzbl (%ecx,%ebx,1),%edx
    if(c == 0)
8010087f:	85 d2                	test   %edx,%edx
80100881:	74 35                	je     801008b8 <cprintf+0xb8>
      break;
    switch(c){
80100883:	83 fa 70             	cmp    $0x70,%edx
80100886:	74 0f                	je     80100897 <cprintf+0x97>
80100888:	7e ae                	jle    80100838 <cprintf+0x38>
8010088a:	83 fa 73             	cmp    $0x73,%edx
8010088d:	8d 76 00             	lea    0x0(%esi),%esi
80100890:	74 76                	je     80100908 <cprintf+0x108>
80100892:	83 fa 78             	cmp    $0x78,%edx
80100895:	75 b3                	jne    8010084a <cprintf+0x4a>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100897:	8b 06                	mov    (%esi),%eax
80100899:	31 c9                	xor    %ecx,%ecx
8010089b:	ba 10 00 00 00       	mov    $0x10,%edx

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008a0:	83 c3 01             	add    $0x1,%ebx
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801008a3:	83 c6 04             	add    $0x4,%esi
801008a6:	e8 d5 fb ff ff       	call   80100480 <printint>
801008ab:	8b 4d 08             	mov    0x8(%ebp),%ecx

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008ae:	0f b6 04 19          	movzbl (%ecx,%ebx,1),%eax
801008b2:	85 c0                	test   %eax,%eax
801008b4:	75 bd                	jne    80100873 <cprintf+0x73>
801008b6:	66 90                	xchg   %ax,%ax
      consputc(c);
      break;
    }
  }

  if(locking)
801008b8:	85 ff                	test   %edi,%edi
801008ba:	74 0c                	je     801008c8 <cprintf+0xc8>
    release(&cons.lock);
801008bc:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801008c3:	e8 38 36 00 00       	call   80103f00 <release>
}
801008c8:	83 c4 2c             	add    $0x2c,%esp
801008cb:	5b                   	pop    %ebx
801008cc:	5e                   	pop    %esi
801008cd:	5f                   	pop    %edi
801008ce:	5d                   	pop    %ebp
801008cf:	c3                   	ret    
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
801008d0:	8b 06                	mov    (%esi),%eax
801008d2:	b9 01 00 00 00       	mov    $0x1,%ecx
801008d7:	ba 0a 00 00 00       	mov    $0xa,%edx
801008dc:	83 c6 04             	add    $0x4,%esi
801008df:	e8 9c fb ff ff       	call   80100480 <printint>
801008e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
      break;
801008e7:	e9 7c ff ff ff       	jmp    80100868 <cprintf+0x68>
801008ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801008f0:	b8 25 00 00 00       	mov    $0x25,%eax
801008f5:	e8 a6 f9 ff ff       	call   801002a0 <consputc>
801008fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
      break;
801008fd:	e9 66 ff ff ff       	jmp    80100868 <cprintf+0x68>
80100902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100908:	8b 16                	mov    (%esi),%edx
8010090a:	b8 b0 6a 10 80       	mov    $0x80106ab0,%eax
8010090f:	83 c6 04             	add    $0x4,%esi
80100912:	85 d2                	test   %edx,%edx
80100914:	0f 44 d0             	cmove  %eax,%edx
        s = "(null)";
      for(; *s; s++)
80100917:	0f b6 02             	movzbl (%edx),%eax
8010091a:	84 c0                	test   %al,%al
8010091c:	0f 84 46 ff ff ff    	je     80100868 <cprintf+0x68>
80100922:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100925:	89 d3                	mov    %edx,%ebx
80100927:	90                   	nop
        consputc(*s);
80100928:	0f be c0             	movsbl %al,%eax
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
8010092b:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
8010092e:	e8 6d f9 ff ff       	call   801002a0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100933:	0f b6 03             	movzbl (%ebx),%eax
80100936:	84 c0                	test   %al,%al
80100938:	75 ee                	jne    80100928 <cprintf+0x128>
8010093a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010093d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100940:	e9 23 ff ff ff       	jmp    80100868 <cprintf+0x68>
80100945:	8d 76 00             	lea    0x0(%esi),%esi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100948:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
8010094f:	e8 fc 35 00 00       	call   80103f50 <acquire>
80100954:	e9 be fe ff ff       	jmp    80100817 <cprintf+0x17>

  if (fmt == 0)
    panic("null fmt");
80100959:	c7 04 24 a7 6a 10 80 	movl   $0x80106aa7,(%esp)
80100960:	e8 1b fe ff ff       	call   80100780 <panic>
	...

80100970 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100970:	55                   	push   %ebp
80100971:	89 e5                	mov    %esp,%ebp
80100973:	57                   	push   %edi
80100974:	56                   	push   %esi
80100975:	53                   	push   %ebx
80100976:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
8010097c:	8b 45 08             	mov    0x8(%ebp),%eax
8010097f:	89 04 24             	mov    %eax,(%esp)
80100982:	e8 09 15 00 00       	call   80101e90 <namei>
80100987:	85 c0                	test   %eax,%eax
80100989:	89 c7                	mov    %eax,%edi
8010098b:	0f 84 1d 01 00 00    	je     80100aae <exec+0x13e>
    return -1;
  ilock(ip);
80100991:	89 04 24             	mov    %eax,(%esp)
80100994:	e8 57 12 00 00       	call   80101bf0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100999:	8d 45 94             	lea    -0x6c(%ebp),%eax
8010099c:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009a3:	00 
801009a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ab:	00 
801009ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801009b0:	89 3c 24             	mov    %edi,(%esp)
801009b3:	e8 f8 0c 00 00       	call   801016b0 <readi>
801009b8:	83 f8 33             	cmp    $0x33,%eax
801009bb:	0f 86 df 01 00 00    	jbe    80100ba0 <exec+0x230>
    goto bad;
  if(elf.magic != ELF_MAGIC)
801009c1:	81 7d 94 7f 45 4c 46 	cmpl   $0x464c457f,-0x6c(%ebp)
801009c8:	0f 85 d2 01 00 00    	jne    80100ba0 <exec+0x230>
    goto bad;

  if((pgdir = setupkvm()) == 0)
801009ce:	e8 ad 59 00 00       	call   80106380 <setupkvm>
801009d3:	85 c0                	test   %eax,%eax
801009d5:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009db:	0f 84 bf 01 00 00    	je     80100ba0 <exec+0x230>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009e1:	66 83 7d c0 00       	cmpw   $0x0,-0x40(%ebp)
801009e6:	8b 75 b0             	mov    -0x50(%ebp),%esi
801009e9:	0f 84 ae 02 00 00    	je     80100c9d <exec+0x32d>
801009ef:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
801009f6:	00 00 00 
801009f9:	31 db                	xor    %ebx,%ebx
801009fb:	eb 15                	jmp    80100a12 <exec+0xa2>
801009fd:	8d 76 00             	lea    0x0(%esi),%esi
80100a00:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80100a04:	83 c3 01             	add    $0x1,%ebx
80100a07:	39 d8                	cmp    %ebx,%eax
80100a09:	0f 8e b1 00 00 00    	jle    80100ac0 <exec+0x150>
80100a0f:	83 c6 20             	add    $0x20,%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a12:	8d 55 c8             	lea    -0x38(%ebp),%edx
80100a15:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a1c:	00 
80100a1d:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a21:	89 54 24 04          	mov    %edx,0x4(%esp)
80100a25:	89 3c 24             	mov    %edi,(%esp)
80100a28:	e8 83 0c 00 00       	call   801016b0 <readi>
80100a2d:	83 f8 20             	cmp    $0x20,%eax
80100a30:	75 66                	jne    80100a98 <exec+0x128>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a32:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
80100a36:	75 c8                	jne    80100a00 <exec+0x90>
      continue;
    if(ph.memsz < ph.filesz)
80100a38:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100a3b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
80100a3e:	72 58                	jb     80100a98 <exec+0x128>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a40:	03 45 d0             	add    -0x30(%ebp),%eax
80100a43:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100a49:	89 44 24 08          	mov    %eax,0x8(%esp)
80100a4d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80100a57:	89 04 24             	mov    %eax,(%esp)
80100a5a:	e8 71 5c 00 00       	call   801066d0 <allocuvm>
80100a5f:	85 c0                	test   %eax,%eax
80100a61:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a67:	74 2f                	je     80100a98 <exec+0x128>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100a6c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100a72:	89 7c 24 08          	mov    %edi,0x8(%esp)
80100a76:	89 44 24 10          	mov    %eax,0x10(%esp)
80100a7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100a7d:	89 14 24             	mov    %edx,(%esp)
80100a80:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100a84:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	e8 30 5d 00 00       	call   801067c0 <loaduvm>
80100a90:	85 c0                	test   %eax,%eax
80100a92:	0f 89 68 ff ff ff    	jns    80100a00 <exec+0x90>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100a98:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a9e:	89 04 24             	mov    %eax,(%esp)
80100aa1:	e8 da 5a 00 00       	call   80106580 <freevm>
  if(ip)
80100aa6:	85 ff                	test   %edi,%edi
80100aa8:	0f 85 f2 00 00 00    	jne    80100ba0 <exec+0x230>
    iunlockput(ip);
80100aae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
80100ab3:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100ab9:	5b                   	pop    %ebx
80100aba:	5e                   	pop    %esi
80100abb:	5f                   	pop    %edi
80100abc:	5d                   	pop    %ebp
80100abd:	c3                   	ret    
80100abe:	66 90                	xchg   %ax,%ax
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ac0:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100ac6:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
80100acc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80100ad2:	8d b3 00 20 00 00    	lea    0x2000(%ebx),%esi
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100ad8:	89 3c 24             	mov    %edi,(%esp)
80100adb:	e8 f0 10 00 00       	call   80101bd0 <iunlockput>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ae0:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100ae6:	89 74 24 08          	mov    %esi,0x8(%esp)
80100aea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100aee:	89 0c 24             	mov    %ecx,(%esp)
80100af1:	e8 da 5b 00 00       	call   801066d0 <allocuvm>
80100af6:	85 c0                	test   %eax,%eax
80100af8:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100afe:	0f 84 93 00 00 00    	je     80100b97 <exec+0x227>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b04:	2d 00 20 00 00       	sub    $0x2000,%eax
80100b09:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b0d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b13:	89 04 24             	mov    %eax,(%esp)
80100b16:	e8 05 59 00 00       	call   80106420 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
80100b1e:	8b 02                	mov    (%edx),%eax
80100b20:	85 c0                	test   %eax,%eax
80100b22:	0f 84 81 01 00 00    	je     80100ca9 <exec+0x339>
80100b28:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100b2b:	31 f6                	xor    %esi,%esi
80100b2d:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100b33:	eb 25                	jmp    80100b5a <exec+0x1ea>
80100b35:	8d 76 00             	lea    0x0(%esi),%esi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100b38:	89 9c b5 10 ff ff ff 	mov    %ebx,-0xf0(%ebp,%esi,4)
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
80100b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b42:	83 c6 01             	add    $0x1,%esi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100b45:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
80100b4b:	8d 3c b0             	lea    (%eax,%esi,4),%edi
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b4e:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100b51:	85 c0                	test   %eax,%eax
80100b53:	74 5d                	je     80100bb2 <exec+0x242>
    if(argc >= MAXARG)
80100b55:	83 fe 20             	cmp    $0x20,%esi
80100b58:	74 3d                	je     80100b97 <exec+0x227>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b5a:	89 04 24             	mov    %eax,(%esp)
80100b5d:	e8 be 36 00 00       	call   80104220 <strlen>
80100b62:	f7 d0                	not    %eax
80100b64:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b67:	8b 07                	mov    (%edi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b69:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b6c:	89 04 24             	mov    %eax,(%esp)
80100b6f:	e8 ac 36 00 00       	call   80104220 <strlen>
80100b74:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100b7a:	83 c0 01             	add    $0x1,%eax
80100b7d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100b81:	8b 07                	mov    (%edi),%eax
80100b83:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100b87:	89 0c 24             	mov    %ecx,(%esp)
80100b8a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100b8e:	e8 cd 56 00 00       	call   80106260 <copyout>
80100b93:	85 c0                	test   %eax,%eax
80100b95:	79 a1                	jns    80100b38 <exec+0x1c8>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip)
    iunlockput(ip);
80100b97:	31 ff                	xor    %edi,%edi
80100b99:	e9 fa fe ff ff       	jmp    80100a98 <exec+0x128>
80100b9e:	66 90                	xchg   %ax,%ax
80100ba0:	89 3c 24             	mov    %edi,(%esp)
80100ba3:	e8 28 10 00 00       	call   80101bd0 <iunlockput>
80100ba8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bad:	e9 01 ff ff ff       	jmp    80100ab3 <exec+0x143>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bb2:	8d 4e 03             	lea    0x3(%esi),%ecx
80100bb5:	8d 3c b5 04 00 00 00 	lea    0x4(,%esi,4),%edi
80100bbc:	8d 04 b5 10 00 00 00 	lea    0x10(,%esi,4),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100bc3:	c7 84 8d 04 ff ff ff 	movl   $0x0,-0xfc(%ebp,%ecx,4)
80100bca:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100bce:	89 d9                	mov    %ebx,%ecx

  sp -= (3+argc+1) * 4;
80100bd0:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100bd2:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bd6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100bdc:	29 f9                	sub    %edi,%ecx
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100bde:	c7 85 04 ff ff ff ff 	movl   $0xffffffff,-0xfc(%ebp)
80100be5:	ff ff ff 
  ustack[1] = argc;
80100be8:	89 b5 08 ff ff ff    	mov    %esi,-0xf8(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100bee:	89 8d 0c ff ff ff    	mov    %ecx,-0xf4(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100bf4:	89 54 24 08          	mov    %edx,0x8(%esp)
80100bf8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100bfc:	89 04 24             	mov    %eax,(%esp)
80100bff:	e8 5c 56 00 00       	call   80106260 <copyout>
80100c04:	85 c0                	test   %eax,%eax
80100c06:	78 8f                	js     80100b97 <exec+0x227>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c08:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100c0b:	0f b6 11             	movzbl (%ecx),%edx
80100c0e:	84 d2                	test   %dl,%dl
80100c10:	74 16                	je     80100c28 <exec+0x2b8>
80100c12:	89 c8                	mov    %ecx,%eax
80100c14:	83 c0 01             	add    $0x1,%eax
80100c17:	90                   	nop
    if(*s == '/')
80100c18:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c1b:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
80100c1e:	0f 44 c8             	cmove  %eax,%ecx
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c21:	83 c0 01             	add    $0x1,%eax
80100c24:	84 d2                	test   %dl,%dl
80100c26:	75 f0                	jne    80100c18 <exec+0x2a8>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100c28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80100c32:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100c39:	00 
80100c3a:	83 c0 6c             	add    $0x6c,%eax
80100c3d:	89 04 24             	mov    %eax,(%esp)
80100c40:	e8 9b 35 00 00       	call   801041e0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100c45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100c4b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100c51:	8b 70 04             	mov    0x4(%eax),%esi
  proc->pgdir = pgdir;
80100c54:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100c57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c5d:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c63:	89 08                	mov    %ecx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100c65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c6b:	8b 55 ac             	mov    -0x54(%ebp),%edx
80100c6e:	8b 40 18             	mov    0x18(%eax),%eax
80100c71:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100c74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c7a:	8b 40 18             	mov    0x18(%eax),%eax
80100c7d:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(proc);
80100c80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c86:	89 04 24             	mov    %eax,(%esp)
80100c89:	e8 f2 5b 00 00       	call   80106880 <switchuvm>
  freevm(oldpgdir);
80100c8e:	89 34 24             	mov    %esi,(%esp)
80100c91:	e8 ea 58 00 00       	call   80106580 <freevm>
80100c96:	31 c0                	xor    %eax,%eax
  return 0;
80100c98:	e9 16 fe ff ff       	jmp    80100ab3 <exec+0x143>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c9d:	be 00 20 00 00       	mov    $0x2000,%esi
80100ca2:	31 db                	xor    %ebx,%ebx
80100ca4:	e9 2f fe ff ff       	jmp    80100ad8 <exec+0x168>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ca9:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100caf:	b0 10                	mov    $0x10,%al
80100cb1:	bf 04 00 00 00       	mov    $0x4,%edi
80100cb6:	b9 03 00 00 00       	mov    $0x3,%ecx
80100cbb:	31 f6                	xor    %esi,%esi
80100cbd:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
80100cc3:	e9 fb fe ff ff       	jmp    80100bc3 <exec+0x253>
	...

80100cd0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100cd0:	55                   	push   %ebp
80100cd1:	89 e5                	mov    %esp,%ebp
80100cd3:	57                   	push   %edi
80100cd4:	56                   	push   %esi
80100cd5:	53                   	push   %ebx
80100cd6:	83 ec 2c             	sub    $0x2c,%esp
80100cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100cdf:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ce2:	8b 45 10             	mov    0x10(%ebp),%eax
80100ce5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ce8:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
80100cec:	0f 84 ae 00 00 00    	je     80100da0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100cf2:	8b 03                	mov    (%ebx),%eax
80100cf4:	83 f8 01             	cmp    $0x1,%eax
80100cf7:	0f 84 c2 00 00 00    	je     80100dbf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100cfd:	83 f8 02             	cmp    $0x2,%eax
80100d00:	0f 85 d7 00 00 00    	jne    80100ddd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100d06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d09:	31 f6                	xor    %esi,%esi
80100d0b:	85 c0                	test   %eax,%eax
80100d0d:	7f 31                	jg     80100d40 <filewrite+0x70>
80100d0f:	e9 9c 00 00 00       	jmp    80100db0 <filewrite+0xe0>
80100d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_trans();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100d18:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
80100d1b:	8b 53 10             	mov    0x10(%ebx),%edx
80100d1e:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100d21:	89 14 24             	mov    %edx,(%esp)
80100d24:	e8 57 0e 00 00       	call   80101b80 <iunlock>
      commit_trans();
80100d29:	e8 82 1c 00 00       	call   801029b0 <commit_trans>
80100d2e:	8b 45 dc             	mov    -0x24(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80100d31:	39 f8                	cmp    %edi,%eax
80100d33:	0f 85 98 00 00 00    	jne    80100dd1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80100d39:	01 c6                	add    %eax,%esi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100d3b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80100d3e:	7e 70                	jle    80100db0 <filewrite+0xe0>
      int n1 = n - i;
80100d40:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80100d43:	b8 00 06 00 00       	mov    $0x600,%eax
80100d48:	29 f7                	sub    %esi,%edi
80100d4a:	81 ff 00 06 00 00    	cmp    $0x600,%edi
80100d50:	0f 4f f8             	cmovg  %eax,%edi
      if(n1 > max)
        n1 = max;

      begin_trans();
80100d53:	e8 b8 1c 00 00       	call   80102a10 <begin_trans>
      ilock(f->ip);
80100d58:	8b 43 10             	mov    0x10(%ebx),%eax
80100d5b:	89 04 24             	mov    %eax,(%esp)
80100d5e:	e8 8d 0e 00 00       	call   80101bf0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100d63:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100d67:	8b 43 14             	mov    0x14(%ebx),%eax
80100d6a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d71:	01 f0                	add    %esi,%eax
80100d73:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d77:	8b 43 10             	mov    0x10(%ebx),%eax
80100d7a:	89 04 24             	mov    %eax,(%esp)
80100d7d:	e8 0e 08 00 00       	call   80101590 <writei>
80100d82:	85 c0                	test   %eax,%eax
80100d84:	7f 92                	jg     80100d18 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80100d86:	8b 53 10             	mov    0x10(%ebx),%edx
80100d89:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100d8c:	89 14 24             	mov    %edx,(%esp)
80100d8f:	e8 ec 0d 00 00       	call   80101b80 <iunlock>
      commit_trans();
80100d94:	e8 17 1c 00 00       	call   801029b0 <commit_trans>

      if(r < 0)
80100d99:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d9c:	85 c0                	test   %eax,%eax
80100d9e:	74 91                	je     80100d31 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80100da0:	83 c4 2c             	add    $0x2c,%esp
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
80100da3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100da8:	5b                   	pop    %ebx
80100da9:	5e                   	pop    %esi
80100daa:	5f                   	pop    %edi
80100dab:	5d                   	pop    %ebp
80100dac:	c3                   	ret    
80100dad:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80100db0:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  }
  panic("filewrite");
80100db3:	89 f0                	mov    %esi,%eax
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80100db5:	75 e9                	jne    80100da0 <filewrite+0xd0>
  }
  panic("filewrite");
}
80100db7:	83 c4 2c             	add    $0x2c,%esp
80100dba:	5b                   	pop    %ebx
80100dbb:	5e                   	pop    %esi
80100dbc:	5f                   	pop    %edi
80100dbd:	5d                   	pop    %ebp
80100dbe:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
80100dbf:	8b 43 0c             	mov    0xc(%ebx),%eax
80100dc2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80100dc5:	83 c4 2c             	add    $0x2c,%esp
80100dc8:	5b                   	pop    %ebx
80100dc9:	5e                   	pop    %esi
80100dca:	5f                   	pop    %edi
80100dcb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
80100dcc:	e9 af 23 00 00       	jmp    80103180 <pipewrite>
      commit_trans();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80100dd1:	c7 04 24 c8 6a 10 80 	movl   $0x80106ac8,(%esp)
80100dd8:	e8 a3 f9 ff ff       	call   80100780 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
80100ddd:	c7 04 24 ce 6a 10 80 	movl   $0x80106ace,(%esp)
80100de4:	e8 97 f9 ff ff       	call   80100780 <panic>
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <fileread>:
}

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	83 ec 38             	sub    $0x38,%esp
80100df6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80100df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100dfc:	89 75 f8             	mov    %esi,-0x8(%ebp)
80100dff:	8b 75 0c             	mov    0xc(%ebp),%esi
80100e02:	89 7d fc             	mov    %edi,-0x4(%ebp)
80100e05:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100e08:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e0c:	74 5a                	je     80100e68 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100e0e:	8b 03                	mov    (%ebx),%eax
80100e10:	83 f8 01             	cmp    $0x1,%eax
80100e13:	74 6b                	je     80100e80 <fileread+0x90>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e15:	83 f8 02             	cmp    $0x2,%eax
80100e18:	75 7d                	jne    80100e97 <fileread+0xa7>
    ilock(f->ip);
80100e1a:	8b 43 10             	mov    0x10(%ebx),%eax
80100e1d:	89 04 24             	mov    %eax,(%esp)
80100e20:	e8 cb 0d 00 00       	call   80101bf0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100e29:	8b 43 14             	mov    0x14(%ebx),%eax
80100e2c:	89 74 24 04          	mov    %esi,0x4(%esp)
80100e30:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e34:	8b 43 10             	mov    0x10(%ebx),%eax
80100e37:	89 04 24             	mov    %eax,(%esp)
80100e3a:	e8 71 08 00 00       	call   801016b0 <readi>
80100e3f:	85 c0                	test   %eax,%eax
80100e41:	7e 03                	jle    80100e46 <fileread+0x56>
      f->off += r;
80100e43:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e46:	8b 53 10             	mov    0x10(%ebx),%edx
80100e49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100e4c:	89 14 24             	mov    %edx,(%esp)
80100e4f:	e8 2c 0d 00 00       	call   80101b80 <iunlock>
    return r;
80100e54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
80100e57:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100e5a:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100e5d:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100e60:	89 ec                	mov    %ebp,%esp
80100e62:	5d                   	pop    %ebp
80100e63:	c3                   	ret    
80100e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e68:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100e6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e70:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100e73:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100e76:	89 ec                	mov    %ebp,%esp
80100e78:	5d                   	pop    %ebp
80100e79:	c3                   	ret    
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100e80:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100e83:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100e86:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100e89:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100e8c:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100e8f:	89 ec                	mov    %ebp,%esp
80100e91:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100e92:	e9 e9 21 00 00       	jmp    80103080 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100e97:	c7 04 24 d8 6a 10 80 	movl   $0x80106ad8,(%esp)
80100e9e:	e8 dd f8 ff ff       	call   80100780 <panic>
80100ea3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100eb0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100eb0:	55                   	push   %ebp
  if(f->type == FD_INODE){
80100eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100eb6:	89 e5                	mov    %esp,%ebp
80100eb8:	53                   	push   %ebx
80100eb9:	83 ec 14             	sub    $0x14,%esp
80100ebc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ebf:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ec2:	74 0c                	je     80100ed0 <filestat+0x20>
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
}
80100ec4:	83 c4 14             	add    $0x14,%esp
80100ec7:	5b                   	pop    %ebx
80100ec8:	5d                   	pop    %ebp
80100ec9:	c3                   	ret    
80100eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
80100ed0:	8b 43 10             	mov    0x10(%ebx),%eax
80100ed3:	89 04 24             	mov    %eax,(%esp)
80100ed6:	e8 15 0d 00 00       	call   80101bf0 <ilock>
    stati(f->ip, st);
80100edb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ede:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ee2:	8b 43 10             	mov    0x10(%ebx),%eax
80100ee5:	89 04 24             	mov    %eax,(%esp)
80100ee8:	e8 e3 01 00 00       	call   801010d0 <stati>
    iunlock(f->ip);
80100eed:	8b 43 10             	mov    0x10(%ebx),%eax
80100ef0:	89 04 24             	mov    %eax,(%esp)
80100ef3:	e8 88 0c 00 00       	call   80101b80 <iunlock>
    return 0;
  }
  return -1;
}
80100ef8:	83 c4 14             	add    $0x14,%esp
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
80100efb:	31 c0                	xor    %eax,%eax
    return 0;
  }
  return -1;
}
80100efd:	5b                   	pop    %ebx
80100efe:	5d                   	pop    %ebp
80100eff:	c3                   	ret    

80100f00 <filedup>:
}

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 14             	sub    $0x14,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f0a:	c7 04 24 e0 cd 10 80 	movl   $0x8010cde0,(%esp)
80100f11:	e8 3a 30 00 00       	call   80103f50 <acquire>
  if(f->ref < 1)
80100f16:	8b 43 04             	mov    0x4(%ebx),%eax
80100f19:	85 c0                	test   %eax,%eax
80100f1b:	7e 1a                	jle    80100f37 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100f1d:	83 c0 01             	add    $0x1,%eax
80100f20:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f23:	c7 04 24 e0 cd 10 80 	movl   $0x8010cde0,(%esp)
80100f2a:	e8 d1 2f 00 00       	call   80103f00 <release>
  return f;
}
80100f2f:	89 d8                	mov    %ebx,%eax
80100f31:	83 c4 14             	add    $0x14,%esp
80100f34:	5b                   	pop    %ebx
80100f35:	5d                   	pop    %ebp
80100f36:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100f37:	c7 04 24 e1 6a 10 80 	movl   $0x80106ae1,(%esp)
80100f3e:	e8 3d f8 ff ff       	call   80100780 <panic>
80100f43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f50 <filealloc>:
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	53                   	push   %ebx
  initlock(&ftable.lock, "ftable");
}

// Allocate a file structure.
struct file*
filealloc(void)
80100f54:	bb 2c ce 10 80       	mov    $0x8010ce2c,%ebx
{
80100f59:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f5c:	c7 04 24 e0 cd 10 80 	movl   $0x8010cde0,(%esp)
80100f63:	e8 e8 2f 00 00       	call   80103f50 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
80100f68:	8b 0d 18 ce 10 80    	mov    0x8010ce18,%ecx
80100f6e:	85 c9                	test   %ecx,%ecx
80100f70:	75 11                	jne    80100f83 <filealloc+0x33>
80100f72:	eb 4a                	jmp    80100fbe <filealloc+0x6e>
80100f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f78:	83 c3 18             	add    $0x18,%ebx
80100f7b:	81 fb 74 d7 10 80    	cmp    $0x8010d774,%ebx
80100f81:	74 25                	je     80100fa8 <filealloc+0x58>
    if(f->ref == 0){
80100f83:	8b 53 04             	mov    0x4(%ebx),%edx
80100f86:	85 d2                	test   %edx,%edx
80100f88:	75 ee                	jne    80100f78 <filealloc+0x28>
      f->ref = 1;
80100f8a:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f91:	c7 04 24 e0 cd 10 80 	movl   $0x8010cde0,(%esp)
80100f98:	e8 63 2f 00 00       	call   80103f00 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f9d:	89 d8                	mov    %ebx,%eax
80100f9f:	83 c4 14             	add    $0x14,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5d                   	pop    %ebp
80100fa4:	c3                   	ret    
80100fa5:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fa8:	31 db                	xor    %ebx,%ebx
80100faa:	c7 04 24 e0 cd 10 80 	movl   $0x8010cde0,(%esp)
80100fb1:	e8 4a 2f 00 00       	call   80103f00 <release>
  return 0;
}
80100fb6:	89 d8                	mov    %ebx,%eax
80100fb8:	83 c4 14             	add    $0x14,%esp
80100fbb:	5b                   	pop    %ebx
80100fbc:	5d                   	pop    %ebp
80100fbd:	c3                   	ret    
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
80100fbe:	bb 14 ce 10 80       	mov    $0x8010ce14,%ebx
80100fc3:	eb c5                	jmp    80100f8a <filealloc+0x3a>
80100fc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fd0 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	83 ec 38             	sub    $0x38,%esp
80100fd6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80100fd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fdc:	89 75 f8             	mov    %esi,-0x8(%ebp)
80100fdf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct file ff;

  acquire(&ftable.lock);
80100fe2:	c7 04 24 e0 cd 10 80 	movl   $0x8010cde0,(%esp)
80100fe9:	e8 62 2f 00 00       	call   80103f50 <acquire>
  if(f->ref < 1)
80100fee:	8b 43 04             	mov    0x4(%ebx),%eax
80100ff1:	85 c0                	test   %eax,%eax
80100ff3:	0f 8e a4 00 00 00    	jle    8010109d <fileclose+0xcd>
    panic("fileclose");
  if(--f->ref > 0){
80100ff9:	83 e8 01             	sub    $0x1,%eax
80100ffc:	85 c0                	test   %eax,%eax
80100ffe:	89 43 04             	mov    %eax,0x4(%ebx)
80101001:	74 1d                	je     80101020 <fileclose+0x50>
    release(&ftable.lock);
80101003:	c7 45 08 e0 cd 10 80 	movl   $0x8010cde0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_trans();
    iput(ff.ip);
    commit_trans();
  }
}
8010100a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010100d:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101010:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101013:	89 ec                	mov    %ebp,%esp
80101015:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80101016:	e9 e5 2e 00 00       	jmp    80103f00 <release>
8010101b:	90                   	nop
8010101c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80101020:	8b 43 0c             	mov    0xc(%ebx),%eax
80101023:	8b 7b 10             	mov    0x10(%ebx),%edi
80101026:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101029:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010102d:	88 45 e7             	mov    %al,-0x19(%ebp)
80101030:	8b 33                	mov    (%ebx),%esi
  f->ref = 0;
80101032:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80101039:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
8010103f:	c7 04 24 e0 cd 10 80 	movl   $0x8010cde0,(%esp)
80101046:	e8 b5 2e 00 00       	call   80103f00 <release>
  
  if(ff.type == FD_PIPE)
8010104b:	83 fe 01             	cmp    $0x1,%esi
8010104e:	74 38                	je     80101088 <fileclose+0xb8>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101050:	83 fe 02             	cmp    $0x2,%esi
80101053:	74 13                	je     80101068 <fileclose+0x98>
    begin_trans();
    iput(ff.ip);
    commit_trans();
  }
}
80101055:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101058:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010105b:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010105e:	89 ec                	mov    %ebp,%esp
80101060:	5d                   	pop    %ebp
80101061:	c3                   	ret    
80101062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ftable.lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_trans();
80101068:	e8 a3 19 00 00       	call   80102a10 <begin_trans>
    iput(ff.ip);
8010106d:	89 3c 24             	mov    %edi,(%esp)
80101070:	e8 cb 08 00 00       	call   80101940 <iput>
    commit_trans();
  }
}
80101075:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101078:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010107b:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010107e:	89 ec                	mov    %ebp,%esp
80101080:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_trans();
    iput(ff.ip);
    commit_trans();
80101081:	e9 2a 19 00 00       	jmp    801029b0 <commit_trans>
80101086:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80101088:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
8010108c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101090:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101093:	89 04 24             	mov    %eax,(%esp)
80101096:	e8 d5 21 00 00       	call   80103270 <pipeclose>
8010109b:	eb b8                	jmp    80101055 <fileclose+0x85>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
8010109d:	c7 04 24 e9 6a 10 80 	movl   $0x80106ae9,(%esp)
801010a4:	e8 d7 f6 ff ff       	call   80100780 <panic>
801010a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801010b0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
801010b6:	c7 44 24 04 f3 6a 10 	movl   $0x80106af3,0x4(%esp)
801010bd:	80 
801010be:	c7 04 24 e0 cd 10 80 	movl   $0x8010cde0,(%esp)
801010c5:	e8 f6 2c 00 00       	call   80103dc0 <initlock>
}
801010ca:	c9                   	leave  
801010cb:	c3                   	ret    
801010cc:	00 00                	add    %al,(%eax)
	...

801010d0 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	8b 55 08             	mov    0x8(%ebp),%edx
801010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801010d9:	8b 0a                	mov    (%edx),%ecx
801010db:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801010de:	8b 4a 04             	mov    0x4(%edx),%ecx
801010e1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801010e4:	0f b7 4a 10          	movzwl 0x10(%edx),%ecx
801010e8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801010eb:	0f b7 4a 16          	movzwl 0x16(%edx),%ecx
801010ef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801010f3:	8b 52 18             	mov    0x18(%edx),%edx
801010f6:	89 50 10             	mov    %edx,0x10(%eax)
}
801010f9:	5d                   	pop    %ebp
801010fa:	c3                   	ret    
801010fb:	90                   	nop
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	53                   	push   %ebx
80101104:	83 ec 14             	sub    $0x14,%esp
80101107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010110a:	c7 04 24 e0 d7 10 80 	movl   $0x8010d7e0,(%esp)
80101111:	e8 3a 2e 00 00       	call   80103f50 <acquire>
  ip->ref++;
80101116:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010111a:	c7 04 24 e0 d7 10 80 	movl   $0x8010d7e0,(%esp)
80101121:	e8 da 2d 00 00       	call   80103f00 <release>
  return ip;
}
80101126:	89 d8                	mov    %ebx,%eax
80101128:	83 c4 14             	add    $0x14,%esp
8010112b:	5b                   	pop    %ebx
8010112c:	5d                   	pop    %ebp
8010112d:	c3                   	ret    
8010112e:	66 90                	xchg   %ax,%ax

80101130 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	57                   	push   %edi
80101134:	89 d7                	mov    %edx,%edi
80101136:	56                   	push   %esi

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
80101137:	31 f6                	xor    %esi,%esi
{
80101139:	53                   	push   %ebx
8010113a:	89 c3                	mov    %eax,%ebx
8010113c:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010113f:	c7 04 24 e0 d7 10 80 	movl   $0x8010d7e0,(%esp)
80101146:	e8 05 2e 00 00       	call   80103f50 <acquire>

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
8010114b:	b8 14 d8 10 80       	mov    $0x8010d814,%eax
80101150:	eb 14                	jmp    80101166 <iget+0x36>
80101152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101158:	85 f6                	test   %esi,%esi
8010115a:	74 3c                	je     80101198 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010115c:	83 c0 50             	add    $0x50,%eax
8010115f:	3d b4 e7 10 80       	cmp    $0x8010e7b4,%eax
80101164:	74 42                	je     801011a8 <iget+0x78>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101166:	8b 48 08             	mov    0x8(%eax),%ecx
80101169:	85 c9                	test   %ecx,%ecx
8010116b:	7e eb                	jle    80101158 <iget+0x28>
8010116d:	39 18                	cmp    %ebx,(%eax)
8010116f:	75 e7                	jne    80101158 <iget+0x28>
80101171:	39 78 04             	cmp    %edi,0x4(%eax)
80101174:	75 e2                	jne    80101158 <iget+0x28>
      ip->ref++;
80101176:	83 c1 01             	add    $0x1,%ecx
80101179:	89 48 08             	mov    %ecx,0x8(%eax)
      release(&icache.lock);
8010117c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010117f:	c7 04 24 e0 d7 10 80 	movl   $0x8010d7e0,(%esp)
80101186:	e8 75 2d 00 00       	call   80103f00 <release>
      return ip;
8010118b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010118e:	83 c4 2c             	add    $0x2c,%esp
80101191:	5b                   	pop    %ebx
80101192:	5e                   	pop    %esi
80101193:	5f                   	pop    %edi
80101194:	5d                   	pop    %ebp
80101195:	c3                   	ret    
80101196:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101198:	85 c9                	test   %ecx,%ecx
8010119a:	0f 44 f0             	cmove  %eax,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010119d:	83 c0 50             	add    $0x50,%eax
801011a0:	3d b4 e7 10 80       	cmp    $0x8010e7b4,%eax
801011a5:	75 bf                	jne    80101166 <iget+0x36>
801011a7:	90                   	nop
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801011a8:	85 f6                	test   %esi,%esi
801011aa:	74 29                	je     801011d5 <iget+0xa5>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801011ac:	89 1e                	mov    %ebx,(%esi)
  ip->inum = inum;
801011ae:	89 7e 04             	mov    %edi,0x4(%esi)
  ip->ref = 1;
801011b1:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
801011b8:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  release(&icache.lock);
801011bf:	c7 04 24 e0 d7 10 80 	movl   $0x8010d7e0,(%esp)
801011c6:	e8 35 2d 00 00       	call   80103f00 <release>

  return ip;
}
801011cb:	83 c4 2c             	add    $0x2c,%esp
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
801011ce:	89 f0                	mov    %esi,%eax

  return ip;
}
801011d0:	5b                   	pop    %ebx
801011d1:	5e                   	pop    %esi
801011d2:	5f                   	pop    %edi
801011d3:	5d                   	pop    %ebp
801011d4:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801011d5:	c7 04 24 fa 6a 10 80 	movl   $0x80106afa,(%esp)
801011dc:	e8 9f f5 ff ff       	call   80100780 <panic>
801011e1:	eb 0d                	jmp    801011f0 <namecmp>
801011e3:	90                   	nop
801011e4:	90                   	nop
801011e5:	90                   	nop
801011e6:	90                   	nop
801011e7:	90                   	nop
801011e8:	90                   	nop
801011e9:	90                   	nop
801011ea:	90                   	nop
801011eb:	90                   	nop
801011ec:	90                   	nop
801011ed:	90                   	nop
801011ee:	90                   	nop
801011ef:	90                   	nop

801011f0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801011f9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101200:	00 
80101201:	89 44 24 04          	mov    %eax,0x4(%esp)
80101205:	8b 45 08             	mov    0x8(%ebp),%eax
80101208:	89 04 24             	mov    %eax,(%esp)
8010120b:	e8 20 2f 00 00       	call   80104130 <strncmp>
}
80101210:	c9                   	leave  
80101211:	c3                   	ret    
80101212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101220 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	56                   	push   %esi
80101224:	53                   	push   %ebx
80101225:	83 ec 10             	sub    $0x10,%esp
80101228:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
8010122b:	8b 43 04             	mov    0x4(%ebx),%eax
8010122e:	c1 e8 03             	shr    $0x3,%eax
80101231:	83 c0 02             	add    $0x2,%eax
80101234:	89 44 24 04          	mov    %eax,0x4(%esp)
80101238:	8b 03                	mov    (%ebx),%eax
8010123a:	89 04 24             	mov    %eax,(%esp)
8010123d:	e8 ae ee ff ff       	call   801000f0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101242:	0f b7 53 10          	movzwl 0x10(%ebx),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
80101246:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101248:	8b 43 04             	mov    0x4(%ebx),%eax
8010124b:	83 e0 07             	and    $0x7,%eax
8010124e:	c1 e0 06             	shl    $0x6,%eax
80101251:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
  dip->type = ip->type;
80101255:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101258:	0f b7 53 12          	movzwl 0x12(%ebx),%edx
8010125c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101260:	0f b7 53 14          	movzwl 0x14(%ebx),%edx
80101264:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101268:	0f b7 53 16          	movzwl 0x16(%ebx),%edx
8010126c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101270:	8b 53 18             	mov    0x18(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101273:	83 c3 1c             	add    $0x1c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
80101276:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101279:	83 c0 0c             	add    $0xc,%eax
8010127c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101280:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101287:	00 
80101288:	89 04 24             	mov    %eax,(%esp)
8010128b:	e8 30 2e 00 00       	call   801040c0 <memmove>
  log_write(bp);
80101290:	89 34 24             	mov    %esi,(%esp)
80101293:	e8 18 15 00 00       	call   801027b0 <log_write>
  brelse(bp);
80101298:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010129b:	83 c4 10             	add    $0x10,%esp
8010129e:	5b                   	pop    %ebx
8010129f:	5e                   	pop    %esi
801012a0:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801012a1:	e9 9a ed ff ff       	jmp    80100040 <brelse>
801012a6:	8d 76 00             	lea    0x0(%esi),%esi
801012a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012b0 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012b6:	8b 45 08             	mov    0x8(%ebp),%eax
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012b9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801012bc:	89 75 fc             	mov    %esi,-0x4(%ebp)
801012bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;
  
  bp = bread(dev, 1);
801012c2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801012c9:	00 
801012ca:	89 04 24             	mov    %eax,(%esp)
801012cd:	e8 1e ee ff ff       	call   801000f0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801012d2:	89 34 24             	mov    %esi,(%esp)
801012d5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801012dc:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;
  
  bp = bread(dev, 1);
801012dd:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801012df:	8d 40 18             	lea    0x18(%eax),%eax
801012e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801012e6:	e8 d5 2d 00 00       	call   801040c0 <memmove>
  brelse(bp);
}
801012eb:	8b 75 fc             	mov    -0x4(%ebp),%esi
{
  struct buf *bp;
  
  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801012ee:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801012f1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801012f4:	89 ec                	mov    %ebp,%esp
801012f6:	5d                   	pop    %ebp
{
  struct buf *bp;
  
  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801012f7:	e9 44 ed ff ff       	jmp    80100040 <brelse>
801012fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101300 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	83 ec 38             	sub    $0x38,%esp
80101306:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101309:	89 c3                	mov    %eax,%ebx
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
8010130b:	8d 45 d8             	lea    -0x28(%ebp),%eax
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010130e:	89 75 f8             	mov    %esi,-0x8(%ebp)
80101311:	89 d6                	mov    %edx,%esi
80101313:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101316:	89 44 24 04          	mov    %eax,0x4(%esp)
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 8e ff ff ff       	call   801012b0 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101322:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101325:	89 f2                	mov    %esi,%edx
80101327:	c1 ea 0c             	shr    $0xc,%edx
8010132a:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
8010132d:	89 f3                	mov    %esi,%ebx
8010132f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101335:	c1 e8 03             	shr    $0x3,%eax
80101338:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
8010133c:	89 44 24 04          	mov    %eax,0x4(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
80101340:	c1 fb 03             	sar    $0x3,%ebx
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101343:	e8 a8 ed ff ff       	call   801000f0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101348:	89 f1                	mov    %esi,%ecx
8010134a:	be 01 00 00 00       	mov    $0x1,%esi
8010134f:	83 e1 07             	and    $0x7,%ecx
80101352:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
80101354:	0f b6 54 18 18       	movzbl 0x18(%eax,%ebx,1),%edx
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101359:	89 c7                	mov    %eax,%edi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010135b:	0f b6 c2             	movzbl %dl,%eax
8010135e:	85 f0                	test   %esi,%eax
80101360:	74 27                	je     80101389 <bfree+0x89>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101362:	89 f0                	mov    %esi,%eax
80101364:	f7 d0                	not    %eax
80101366:	21 d0                	and    %edx,%eax
80101368:	88 44 1f 18          	mov    %al,0x18(%edi,%ebx,1)
  log_write(bp);
8010136c:	89 3c 24             	mov    %edi,(%esp)
8010136f:	e8 3c 14 00 00       	call   801027b0 <log_write>
  brelse(bp);
80101374:	89 3c 24             	mov    %edi,(%esp)
80101377:	e8 c4 ec ff ff       	call   80100040 <brelse>
}
8010137c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010137f:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101382:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101385:	89 ec                	mov    %ebp,%esp
80101387:	5d                   	pop    %ebp
80101388:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101389:	c7 04 24 0a 6b 10 80 	movl   $0x80106b0a,(%esp)
80101390:	e8 eb f3 ff ff       	call   80100780 <panic>
80101395:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013a0 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	56                   	push   %esi
801013a5:	53                   	push   %ebx
801013a6:	83 ec 4c             	sub    $0x4c,%esp
801013a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
801013ac:	8d 45 d8             	lea    -0x28(%ebp),%eax
801013af:	89 44 24 04          	mov    %eax,0x4(%esp)
801013b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
801013b6:	89 04 24             	mov    %eax,(%esp)
801013b9:	e8 f2 fe ff ff       	call   801012b0 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013be:	8b 45 d8             	mov    -0x28(%ebp),%eax
801013c1:	85 c0                	test   %eax,%eax
801013c3:	0f 84 8d 00 00 00    	je     80101456 <balloc+0xb6>
801013c9:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013d3:	8b 55 cc             	mov    -0x34(%ebp),%edx
801013d6:	c1 e8 03             	shr    $0x3,%eax
801013d9:	c1 fa 0c             	sar    $0xc,%edx
801013dc:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
801013e0:	8b 55 c8             	mov    -0x38(%ebp),%edx
801013e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801013e7:	89 14 24             	mov    %edx,(%esp)
801013ea:	e8 01 ed ff ff       	call   801000f0 <bread>
801013ef:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801013f2:	8b 5d cc             	mov    -0x34(%ebp),%ebx
801013f5:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801013f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801013fb:	31 c0                	xor    %eax,%eax
801013fd:	eb 34                	jmp    80101433 <balloc+0x93>
801013ff:	90                   	nop
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101400:	89 c1                	mov    %eax,%ecx
80101402:	bf 01 00 00 00       	mov    $0x1,%edi
80101407:	83 e1 07             	and    $0x7,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010140a:	89 c2                	mov    %eax,%edx
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010140c:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010140e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80101411:	c1 fa 03             	sar    $0x3,%edx
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101414:	89 7d c4             	mov    %edi,-0x3c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101417:	0f b6 74 11 18       	movzbl 0x18(%ecx,%edx,1),%esi
8010141c:	89 f1                	mov    %esi,%ecx
8010141e:	0f b6 f9             	movzbl %cl,%edi
80101421:	85 7d c4             	test   %edi,-0x3c(%ebp)
80101424:	74 42                	je     80101468 <balloc+0xc8>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101426:	83 c0 01             	add    $0x1,%eax
80101429:	83 c3 01             	add    $0x1,%ebx
8010142c:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101431:	74 05                	je     80101438 <balloc+0x98>
80101433:	3b 5d d0             	cmp    -0x30(%ebp),%ebx
80101436:	72 c8                	jb     80101400 <balloc+0x60>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101438:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010143b:	89 14 24             	mov    %edx,(%esp)
8010143e:	e8 fd eb ff ff       	call   80100040 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
80101443:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
8010144a:	8b 4d cc             	mov    -0x34(%ebp),%ecx
8010144d:	39 4d d8             	cmp    %ecx,-0x28(%ebp)
80101450:	0f 87 7a ff ff ff    	ja     801013d0 <balloc+0x30>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101456:	c7 04 24 1d 6b 10 80 	movl   $0x80106b1d,(%esp)
8010145d:	e8 1e f3 ff ff       	call   80100780 <panic>
80101462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101468:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
8010146b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
8010146e:	09 f1                	or     %esi,%ecx
80101470:	88 4c 17 18          	mov    %cl,0x18(%edi,%edx,1)
        log_write(bp);
80101474:	89 3c 24             	mov    %edi,(%esp)
80101477:	e8 34 13 00 00       	call   801027b0 <log_write>
        brelse(bp);
8010147c:	89 3c 24             	mov    %edi,(%esp)
8010147f:	e8 bc eb ff ff       	call   80100040 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
80101484:	8b 45 c8             	mov    -0x38(%ebp),%eax
80101487:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010148b:	89 04 24             	mov    %eax,(%esp)
8010148e:	e8 5d ec ff ff       	call   801000f0 <bread>
  memset(bp->data, 0, BSIZE);
80101493:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010149a:	00 
8010149b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801014a2:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
801014a3:	89 c6                	mov    %eax,%esi
  memset(bp->data, 0, BSIZE);
801014a5:	8d 40 18             	lea    0x18(%eax),%eax
801014a8:	89 04 24             	mov    %eax,(%esp)
801014ab:	e8 40 2b 00 00       	call   80103ff0 <memset>
  log_write(bp);
801014b0:	89 34 24             	mov    %esi,(%esp)
801014b3:	e8 f8 12 00 00       	call   801027b0 <log_write>
  brelse(bp);
801014b8:	89 34 24             	mov    %esi,(%esp)
801014bb:	e8 80 eb ff ff       	call   80100040 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801014c0:	83 c4 4c             	add    $0x4c,%esp
801014c3:	89 d8                	mov    %ebx,%eax
801014c5:	5b                   	pop    %ebx
801014c6:	5e                   	pop    %esi
801014c7:	5f                   	pop    %edi
801014c8:	5d                   	pop    %ebp
801014c9:	c3                   	ret    
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801014d0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014d0:	55                   	push   %ebp
801014d1:	89 e5                	mov    %esp,%ebp
801014d3:	83 ec 38             	sub    $0x38,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014d6:	83 fa 0b             	cmp    $0xb,%edx

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014d9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801014dc:	89 c3                	mov    %eax,%ebx
801014de:	89 75 f8             	mov    %esi,-0x8(%ebp)
801014e1:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014e4:	77 1a                	ja     80101500 <bmap+0x30>
    if((addr = ip->addrs[bn]) == 0)
801014e6:	8d 7a 04             	lea    0x4(%edx),%edi
801014e9:	8b 44 b8 0c          	mov    0xc(%eax,%edi,4),%eax
801014ed:	85 c0                	test   %eax,%eax
801014ef:	74 6f                	je     80101560 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801014f1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801014f4:	8b 75 f8             	mov    -0x8(%ebp),%esi
801014f7:	8b 7d fc             	mov    -0x4(%ebp),%edi
801014fa:	89 ec                	mov    %ebp,%esp
801014fc:	5d                   	pop    %ebp
801014fd:	c3                   	ret    
801014fe:	66 90                	xchg   %ax,%ax
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101500:	8d 7a f4             	lea    -0xc(%edx),%edi

  if(bn < NINDIRECT){
80101503:	83 ff 7f             	cmp    $0x7f,%edi
80101506:	77 7c                	ja     80101584 <bmap+0xb4>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101508:	8b 40 4c             	mov    0x4c(%eax),%eax
8010150b:	85 c0                	test   %eax,%eax
8010150d:	74 69                	je     80101578 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010150f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101513:	8b 03                	mov    (%ebx),%eax
80101515:	89 04 24             	mov    %eax,(%esp)
80101518:	e8 d3 eb ff ff       	call   801000f0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010151d:	8d 7c b8 18          	lea    0x18(%eax,%edi,4),%edi

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101521:	89 c6                	mov    %eax,%esi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101523:	8b 07                	mov    (%edi),%eax
80101525:	85 c0                	test   %eax,%eax
80101527:	75 17                	jne    80101540 <bmap+0x70>
      a[bn] = addr = balloc(ip->dev);
80101529:	8b 03                	mov    (%ebx),%eax
8010152b:	e8 70 fe ff ff       	call   801013a0 <balloc>
80101530:	89 07                	mov    %eax,(%edi)
      log_write(bp);
80101532:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101535:	89 34 24             	mov    %esi,(%esp)
80101538:	e8 73 12 00 00       	call   801027b0 <log_write>
8010153d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    }
    brelse(bp);
80101540:	89 34 24             	mov    %esi,(%esp)
80101543:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101546:	e8 f5 ea ff ff       	call   80100040 <brelse>
    return addr;
8010154b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }

  panic("bmap: out of range");
}
8010154e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101551:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101554:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101557:	89 ec                	mov    %ebp,%esp
80101559:	5d                   	pop    %ebp
8010155a:	c3                   	ret    
8010155b:	90                   	nop
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101560:	8b 03                	mov    (%ebx),%eax
80101562:	e8 39 fe ff ff       	call   801013a0 <balloc>
80101567:	89 44 bb 0c          	mov    %eax,0xc(%ebx,%edi,4)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010156b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010156e:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101571:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101574:	89 ec                	mov    %ebp,%esp
80101576:	5d                   	pop    %ebp
80101577:	c3                   	ret    
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101578:	8b 03                	mov    (%ebx),%eax
8010157a:	e8 21 fe ff ff       	call   801013a0 <balloc>
8010157f:	89 43 4c             	mov    %eax,0x4c(%ebx)
80101582:	eb 8b                	jmp    8010150f <bmap+0x3f>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101584:	c7 04 24 33 6b 10 80 	movl   $0x80106b33,(%esp)
8010158b:	e8 f0 f1 ff ff       	call   80100780 <panic>

80101590 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	83 ec 38             	sub    $0x38,%esp
80101596:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101599:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010159c:	89 75 f8             	mov    %esi,-0x8(%ebp)
8010159f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801015a2:	89 7d fc             	mov    %edi,-0x4(%ebp)
801015a5:	8b 75 10             	mov    0x10(%ebp),%esi
801015a8:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801015ab:	66 83 7b 10 03       	cmpw   $0x3,0x10(%ebx)
801015b0:	74 1e                	je     801015d0 <writei+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801015b2:	39 73 18             	cmp    %esi,0x18(%ebx)
801015b5:	73 41                	jae    801015f8 <writei+0x68>

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
801015b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801015bc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801015bf:	8b 75 f8             	mov    -0x8(%ebp),%esi
801015c2:	8b 7d fc             	mov    -0x4(%ebp),%edi
801015c5:	89 ec                	mov    %ebp,%esp
801015c7:	5d                   	pop    %ebp
801015c8:	c3                   	ret    
801015c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801015d0:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
801015d4:	66 83 f8 09          	cmp    $0x9,%ax
801015d8:	77 dd                	ja     801015b7 <writei+0x27>
801015da:	98                   	cwtl   
801015db:	8b 04 c5 84 d7 10 80 	mov    -0x7fef287c(,%eax,8),%eax
801015e2:	85 c0                	test   %eax,%eax
801015e4:	74 d1                	je     801015b7 <writei+0x27>
      return -1;
    return devsw[ip->major].write(ip, src, n);
801015e6:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
801015e9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801015ec:	8b 75 f8             	mov    -0x8(%ebp),%esi
801015ef:	8b 7d fc             	mov    -0x4(%ebp),%edi
801015f2:	89 ec                	mov    %ebp,%esp
801015f4:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
801015f5:	ff e0                	jmp    *%eax
801015f7:	90                   	nop
  }

  if(off > ip->size || off + n < off)
801015f8:	89 f8                	mov    %edi,%eax
801015fa:	01 f0                	add    %esi,%eax
801015fc:	72 b9                	jb     801015b7 <writei+0x27>
    return -1;
  if(off + n > MAXFILE*BSIZE)
801015fe:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101603:	77 b2                	ja     801015b7 <writei+0x27>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101605:	85 ff                	test   %edi,%edi
80101607:	0f 84 8a 00 00 00    	je     80101697 <writei+0x107>
8010160d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101614:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101617:	89 7d dc             	mov    %edi,-0x24(%ebp)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010161a:	89 f2                	mov    %esi,%edx
8010161c:	89 d8                	mov    %ebx,%eax
8010161e:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101621:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101626:	e8 a5 fe ff ff       	call   801014d0 <bmap>
8010162b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010162f:	8b 03                	mov    (%ebx),%eax
80101631:	89 04 24             	mov    %eax,(%esp)
80101634:	e8 b7 ea ff ff       	call   801000f0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101639:	8b 4d dc             	mov    -0x24(%ebp),%ecx
8010163c:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010163f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101641:	89 f0                	mov    %esi,%eax
80101643:	25 ff 01 00 00       	and    $0x1ff,%eax
80101648:	29 c7                	sub    %eax,%edi
8010164a:	39 cf                	cmp    %ecx,%edi
8010164c:	0f 47 f9             	cmova  %ecx,%edi
    memmove(bp->data + off%BSIZE, src, m);
8010164f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101652:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101656:	01 fe                	add    %edi,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101658:	89 55 d8             	mov    %edx,-0x28(%ebp)
8010165b:	89 7c 24 08          	mov    %edi,0x8(%esp)
8010165f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80101663:	89 04 24             	mov    %eax,(%esp)
80101666:	e8 55 2a 00 00       	call   801040c0 <memmove>
    log_write(bp);
8010166b:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010166e:	89 14 24             	mov    %edx,(%esp)
80101671:	e8 3a 11 00 00       	call   801027b0 <log_write>
    brelse(bp);
80101676:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101679:	89 14 24             	mov    %edx,(%esp)
8010167c:	e8 bf e9 ff ff       	call   80100040 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101681:	01 7d e4             	add    %edi,-0x1c(%ebp)
80101684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101687:	01 7d e0             	add    %edi,-0x20(%ebp)
8010168a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
8010168d:	77 8b                	ja     8010161a <writei+0x8a>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010168f:	3b 73 18             	cmp    0x18(%ebx),%esi
80101692:	8b 7d dc             	mov    -0x24(%ebp),%edi
80101695:	77 07                	ja     8010169e <writei+0x10e>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101697:	89 f8                	mov    %edi,%eax
80101699:	e9 1e ff ff ff       	jmp    801015bc <writei+0x2c>
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
8010169e:	89 73 18             	mov    %esi,0x18(%ebx)
    iupdate(ip);
801016a1:	89 1c 24             	mov    %ebx,(%esp)
801016a4:	e8 77 fb ff ff       	call   80101220 <iupdate>
  }
  return n;
801016a9:	89 f8                	mov    %edi,%eax
801016ab:	e9 0c ff ff ff       	jmp    801015bc <writei+0x2c>

801016b0 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	83 ec 38             	sub    $0x38,%esp
801016b6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801016b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801016bc:	89 75 f8             	mov    %esi,-0x8(%ebp)
801016bf:	8b 4d 14             	mov    0x14(%ebp),%ecx
801016c2:	89 7d fc             	mov    %edi,-0x4(%ebp)
801016c5:	8b 75 10             	mov    0x10(%ebp),%esi
801016c8:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801016cb:	66 83 7b 10 03       	cmpw   $0x3,0x10(%ebx)
801016d0:	74 1e                	je     801016f0 <readi+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801016d2:	8b 43 18             	mov    0x18(%ebx),%eax
801016d5:	39 f0                	cmp    %esi,%eax
801016d7:	73 3f                	jae    80101718 <readi+0x68>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801016d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801016de:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801016e1:	8b 75 f8             	mov    -0x8(%ebp),%esi
801016e4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801016e7:	89 ec                	mov    %ebp,%esp
801016e9:	5d                   	pop    %ebp
801016ea:	c3                   	ret    
801016eb:	90                   	nop
801016ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801016f0:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
801016f4:	66 83 f8 09          	cmp    $0x9,%ax
801016f8:	77 df                	ja     801016d9 <readi+0x29>
801016fa:	98                   	cwtl   
801016fb:	8b 04 c5 80 d7 10 80 	mov    -0x7fef2880(,%eax,8),%eax
80101702:	85 c0                	test   %eax,%eax
80101704:	74 d3                	je     801016d9 <readi+0x29>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101706:	89 4d 10             	mov    %ecx,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101709:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010170c:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010170f:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101712:	89 ec                	mov    %ebp,%esp
80101714:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101715:	ff e0                	jmp    *%eax
80101717:	90                   	nop
  }

  if(off > ip->size || off + n < off)
80101718:	89 ca                	mov    %ecx,%edx
8010171a:	01 f2                	add    %esi,%edx
8010171c:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010171f:	72 b8                	jb     801016d9 <readi+0x29>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101721:	89 c2                	mov    %eax,%edx
80101723:	29 f2                	sub    %esi,%edx
80101725:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80101728:	0f 42 ca             	cmovb  %edx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010172b:	85 c9                	test   %ecx,%ecx
8010172d:	74 7e                	je     801017ad <readi+0xfd>
8010172f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101736:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101739:	89 4d dc             	mov    %ecx,-0x24(%ebp)
8010173c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101740:	89 f2                	mov    %esi,%edx
80101742:	89 d8                	mov    %ebx,%eax
80101744:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101747:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010174c:	e8 7f fd ff ff       	call   801014d0 <bmap>
80101751:	89 44 24 04          	mov    %eax,0x4(%esp)
80101755:	8b 03                	mov    (%ebx),%eax
80101757:	89 04 24             	mov    %eax,(%esp)
8010175a:	e8 91 e9 ff ff       	call   801000f0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010175f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80101762:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101765:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101767:	89 f0                	mov    %esi,%eax
80101769:	25 ff 01 00 00       	and    $0x1ff,%eax
8010176e:	29 c7                	sub    %eax,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101770:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101774:	39 cf                	cmp    %ecx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101776:	89 44 24 04          	mov    %eax,0x4(%esp)
8010177a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
8010177d:	0f 47 f9             	cmova  %ecx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101780:	89 55 d8             	mov    %edx,-0x28(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101783:	01 fe                	add    %edi,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101785:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101789:	89 04 24             	mov    %eax,(%esp)
8010178c:	e8 2f 29 00 00       	call   801040c0 <memmove>
    brelse(bp);
80101791:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101794:	89 14 24             	mov    %edx,(%esp)
80101797:	e8 a4 e8 ff ff       	call   80100040 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010179c:	01 7d e4             	add    %edi,-0x1c(%ebp)
8010179f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801017a2:	01 7d e0             	add    %edi,-0x20(%ebp)
801017a5:	39 55 dc             	cmp    %edx,-0x24(%ebp)
801017a8:	77 96                	ja     80101740 <readi+0x90>
801017aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801017ad:	89 c8                	mov    %ecx,%eax
801017af:	e9 2a ff ff ff       	jmp    801016de <readi+0x2e>
801017b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017c0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 2c             	sub    $0x2c,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801017cc:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
801017d1:	0f 85 8c 00 00 00    	jne    80101863 <dirlookup+0xa3>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801017d7:	8b 4b 18             	mov    0x18(%ebx),%ecx
801017da:	85 c9                	test   %ecx,%ecx
801017dc:	74 4c                	je     8010182a <dirlookup+0x6a>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
801017de:	8d 7d d8             	lea    -0x28(%ebp),%edi
801017e1:	31 f6                	xor    %esi,%esi
801017e3:	90                   	nop
801017e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801017e8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801017ef:	00 
801017f0:	89 74 24 08          	mov    %esi,0x8(%esp)
801017f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
801017f8:	89 1c 24             	mov    %ebx,(%esp)
801017fb:	e8 b0 fe ff ff       	call   801016b0 <readi>
80101800:	83 f8 10             	cmp    $0x10,%eax
80101803:	75 52                	jne    80101857 <dirlookup+0x97>
      panic("dirlink read");
    if(de.inum == 0)
80101805:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010180a:	74 16                	je     80101822 <dirlookup+0x62>
      continue;
    if(namecmp(name, de.name) == 0){
8010180c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010180f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101813:	8b 45 0c             	mov    0xc(%ebp),%eax
80101816:	89 04 24             	mov    %eax,(%esp)
80101819:	e8 d2 f9 ff ff       	call   801011f0 <namecmp>
8010181e:	85 c0                	test   %eax,%eax
80101820:	74 16                	je     80101838 <dirlookup+0x78>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101822:	83 c6 10             	add    $0x10,%esi
80101825:	39 73 18             	cmp    %esi,0x18(%ebx)
80101828:	77 be                	ja     801017e8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
8010182a:	83 c4 2c             	add    $0x2c,%esp
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010182d:	31 c0                	xor    %eax,%eax
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
8010182f:	5b                   	pop    %ebx
80101830:	5e                   	pop    %esi
80101831:	5f                   	pop    %edi
80101832:	5d                   	pop    %ebp
80101833:	c3                   	ret    
80101834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
      // entry matches path element
      if(poff)
80101838:	8b 55 10             	mov    0x10(%ebp),%edx
8010183b:	85 d2                	test   %edx,%edx
8010183d:	74 05                	je     80101844 <dirlookup+0x84>
        *poff = off;
8010183f:	8b 45 10             	mov    0x10(%ebp),%eax
80101842:	89 30                	mov    %esi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101844:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101848:	8b 03                	mov    (%ebx),%eax
8010184a:	e8 e1 f8 ff ff       	call   80101130 <iget>
    }
  }

  return 0;
}
8010184f:	83 c4 2c             	add    $0x2c,%esp
80101852:	5b                   	pop    %ebx
80101853:	5e                   	pop    %esi
80101854:	5f                   	pop    %edi
80101855:	5d                   	pop    %ebp
80101856:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101857:	c7 04 24 58 6b 10 80 	movl   $0x80106b58,(%esp)
8010185e:	e8 1d ef ff ff       	call   80100780 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101863:	c7 04 24 46 6b 10 80 	movl   $0x80106b46,(%esp)
8010186a:	e8 11 ef ff ff       	call   80100780 <panic>
8010186f:	90                   	nop

80101870 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	57                   	push   %edi
80101874:	56                   	push   %esi
80101875:	53                   	push   %ebx
80101876:	83 ec 3c             	sub    $0x3c,%esp
80101879:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
8010187d:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101881:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101884:	89 44 24 04          	mov    %eax,0x4(%esp)
80101888:	8b 45 08             	mov    0x8(%ebp),%eax
8010188b:	89 04 24             	mov    %eax,(%esp)
8010188e:	e8 1d fa ff ff       	call   801012b0 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
80101893:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
80101897:	0f 86 97 00 00 00    	jbe    80101934 <ialloc+0xc4>
8010189d:	be 01 00 00 00       	mov    $0x1,%esi
801018a2:	bb 01 00 00 00       	mov    $0x1,%ebx
801018a7:	eb 19                	jmp    801018c2 <ialloc+0x52>
801018a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b0:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801018b3:	89 3c 24             	mov    %edi,(%esp)
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801018b6:	89 de                	mov    %ebx,%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801018b8:	e8 83 e7 ff ff       	call   80100040 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801018bd:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
801018c0:	76 72                	jbe    80101934 <ialloc+0xc4>
    bp = bread(dev, IBLOCK(inum));
801018c2:	89 f0                	mov    %esi,%eax
801018c4:	c1 e8 03             	shr    $0x3,%eax
801018c7:	83 c0 02             	add    $0x2,%eax
801018ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801018ce:	8b 45 08             	mov    0x8(%ebp),%eax
801018d1:	89 04 24             	mov    %eax,(%esp)
801018d4:	e8 17 e8 ff ff       	call   801000f0 <bread>
801018d9:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801018db:	89 f0                	mov    %esi,%eax
801018dd:	83 e0 07             	and    $0x7,%eax
801018e0:	c1 e0 06             	shl    $0x6,%eax
801018e3:	8d 54 07 18          	lea    0x18(%edi,%eax,1),%edx
    if(dip->type == 0){  // a free inode
801018e7:	66 83 3a 00          	cmpw   $0x0,(%edx)
801018eb:	75 c3                	jne    801018b0 <ialloc+0x40>
      memset(dip, 0, sizeof(*dip));
801018ed:	89 14 24             	mov    %edx,(%esp)
801018f0:	89 55 d0             	mov    %edx,-0x30(%ebp)
801018f3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801018fa:	00 
801018fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101902:	00 
80101903:	e8 e8 26 00 00       	call   80103ff0 <memset>
      dip->type = type;
80101908:	8b 55 d0             	mov    -0x30(%ebp),%edx
8010190b:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
8010190f:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
80101912:	89 3c 24             	mov    %edi,(%esp)
80101915:	e8 96 0e 00 00       	call   801027b0 <log_write>
      brelse(bp);
8010191a:	89 3c 24             	mov    %edi,(%esp)
8010191d:	e8 1e e7 ff ff       	call   80100040 <brelse>
      return iget(dev, inum);
80101922:	8b 45 08             	mov    0x8(%ebp),%eax
80101925:	89 f2                	mov    %esi,%edx
80101927:	e8 04 f8 ff ff       	call   80101130 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
8010192c:	83 c4 3c             	add    $0x3c,%esp
8010192f:	5b                   	pop    %ebx
80101930:	5e                   	pop    %esi
80101931:	5f                   	pop    %edi
80101932:	5d                   	pop    %ebp
80101933:	c3                   	ret    
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101934:	c7 04 24 65 6b 10 80 	movl   $0x80106b65,(%esp)
8010193b:	e8 40 ee ff ff       	call   80100780 <panic>

80101940 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 2c             	sub    $0x2c,%esp
80101949:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010194c:	c7 04 24 e0 d7 10 80 	movl   $0x8010d7e0,(%esp)
80101953:	e8 f8 25 00 00       	call   80103f50 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101958:	8b 46 08             	mov    0x8(%esi),%eax
8010195b:	83 f8 01             	cmp    $0x1,%eax
8010195e:	0f 85 a1 00 00 00    	jne    80101a05 <iput+0xc5>
80101964:	8b 56 0c             	mov    0xc(%esi),%edx
80101967:	f6 c2 02             	test   $0x2,%dl
8010196a:	0f 84 95 00 00 00    	je     80101a05 <iput+0xc5>
80101970:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
80101975:	0f 85 8a 00 00 00    	jne    80101a05 <iput+0xc5>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
8010197b:	f6 c2 01             	test   $0x1,%dl
8010197e:	0f 85 fa 00 00 00    	jne    80101a7e <iput+0x13e>
      panic("iput busy");
    ip->flags |= I_BUSY;
80101984:	83 ca 01             	or     $0x1,%edx
    release(&icache.lock);
80101987:	89 f3                	mov    %esi,%ebx
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
80101989:	89 56 0c             	mov    %edx,0xc(%esi)
// If that was the last reference, the inode cache entry can
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
8010198c:	8d 7e 30             	lea    0x30(%esi),%edi
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
8010198f:	c7 04 24 e0 d7 10 80 	movl   $0x8010d7e0,(%esp)
80101996:	e8 65 25 00 00       	call   80103f00 <release>
8010199b:	eb 0a                	jmp    801019a7 <iput+0x67>
8010199d:	8d 76 00             	lea    0x0(%esi),%esi
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
801019a0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019a3:	39 fb                	cmp    %edi,%ebx
801019a5:	74 1c                	je     801019c3 <iput+0x83>
    if(ip->addrs[i]){
801019a7:	8b 53 1c             	mov    0x1c(%ebx),%edx
801019aa:	85 d2                	test   %edx,%edx
801019ac:	74 f2                	je     801019a0 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
801019ae:	8b 06                	mov    (%esi),%eax
801019b0:	e8 4b f9 ff ff       	call   80101300 <bfree>
      ip->addrs[i] = 0;
801019b5:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
801019bc:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019bf:	39 fb                	cmp    %edi,%ebx
801019c1:	75 e4                	jne    801019a7 <iput+0x67>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
801019c3:	8b 46 4c             	mov    0x4c(%esi),%eax
801019c6:	85 c0                	test   %eax,%eax
801019c8:	75 56                	jne    80101a20 <iput+0xe0>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801019ca:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
801019d1:	89 34 24             	mov    %esi,(%esp)
801019d4:	e8 47 f8 ff ff       	call   80101220 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
801019d9:	66 c7 46 10 00 00    	movw   $0x0,0x10(%esi)
    iupdate(ip);
801019df:	89 34 24             	mov    %esi,(%esp)
801019e2:	e8 39 f8 ff ff       	call   80101220 <iupdate>
    acquire(&icache.lock);
801019e7:	c7 04 24 e0 d7 10 80 	movl   $0x8010d7e0,(%esp)
801019ee:	e8 5d 25 00 00       	call   80103f50 <acquire>
    ip->flags = 0;
801019f3:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    wakeup(ip);
801019fa:	89 34 24             	mov    %esi,(%esp)
801019fd:	e8 4e 1b 00 00       	call   80103550 <wakeup>
80101a02:	8b 46 08             	mov    0x8(%esi),%eax
  }
  ip->ref--;
80101a05:	83 e8 01             	sub    $0x1,%eax
80101a08:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
80101a0b:	c7 45 08 e0 d7 10 80 	movl   $0x8010d7e0,0x8(%ebp)
}
80101a12:	83 c4 2c             	add    $0x2c,%esp
80101a15:	5b                   	pop    %ebx
80101a16:	5e                   	pop    %esi
80101a17:	5f                   	pop    %edi
80101a18:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags = 0;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
80101a19:	e9 e2 24 00 00       	jmp    80103f00 <release>
80101a1e:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a20:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a24:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
80101a26:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a28:	89 04 24             	mov    %eax,(%esp)
80101a2b:	e8 c0 e6 ff ff       	call   801000f0 <bread>
    a = (uint*)bp->data;
80101a30:	89 c7                	mov    %eax,%edi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101a35:	83 c7 18             	add    $0x18,%edi
80101a38:	31 c0                	xor    %eax,%eax
80101a3a:	eb 11                	jmp    80101a4d <iput+0x10d>
80101a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(j = 0; j < NINDIRECT; j++){
80101a40:	83 c3 01             	add    $0x1,%ebx
80101a43:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101a49:	89 d8                	mov    %ebx,%eax
80101a4b:	74 10                	je     80101a5d <iput+0x11d>
      if(a[j])
80101a4d:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101a50:	85 d2                	test   %edx,%edx
80101a52:	74 ec                	je     80101a40 <iput+0x100>
        bfree(ip->dev, a[j]);
80101a54:	8b 06                	mov    (%esi),%eax
80101a56:	e8 a5 f8 ff ff       	call   80101300 <bfree>
80101a5b:	eb e3                	jmp    80101a40 <iput+0x100>
    }
    brelse(bp);
80101a5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a60:	89 04 24             	mov    %eax,(%esp)
80101a63:	e8 d8 e5 ff ff       	call   80100040 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a68:	8b 56 4c             	mov    0x4c(%esi),%edx
80101a6b:	8b 06                	mov    (%esi),%eax
80101a6d:	e8 8e f8 ff ff       	call   80101300 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a72:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101a79:	e9 4c ff ff ff       	jmp    801019ca <iput+0x8a>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
80101a7e:	c7 04 24 77 6b 10 80 	movl   $0x80106b77,(%esp)
80101a85:	e8 f6 ec ff ff       	call   80100780 <panic>
80101a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a90 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 2c             	sub    $0x2c,%esp
80101a99:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a9f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101aa6:	00 
80101aa7:	89 34 24             	mov    %esi,(%esp)
80101aaa:	89 44 24 04          	mov    %eax,0x4(%esp)
80101aae:	e8 0d fd ff ff       	call   801017c0 <dirlookup>
80101ab3:	85 c0                	test   %eax,%eax
80101ab5:	0f 85 89 00 00 00    	jne    80101b44 <dirlink+0xb4>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101abb:	8b 5e 18             	mov    0x18(%esi),%ebx
80101abe:	85 db                	test   %ebx,%ebx
80101ac0:	0f 84 8d 00 00 00    	je     80101b53 <dirlink+0xc3>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
80101ac6:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101ac9:	31 db                	xor    %ebx,%ebx
80101acb:	eb 0b                	jmp    80101ad8 <dirlink+0x48>
80101acd:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ad0:	83 c3 10             	add    $0x10,%ebx
80101ad3:	39 5e 18             	cmp    %ebx,0x18(%esi)
80101ad6:	76 24                	jbe    80101afc <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ad8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101adf:	00 
80101ae0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101ae4:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101ae8:	89 34 24             	mov    %esi,(%esp)
80101aeb:	e8 c0 fb ff ff       	call   801016b0 <readi>
80101af0:	83 f8 10             	cmp    $0x10,%eax
80101af3:	75 65                	jne    80101b5a <dirlink+0xca>
      panic("dirlink read");
    if(de.inum == 0)
80101af5:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101afa:	75 d4                	jne    80101ad0 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101afc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101aff:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b06:	00 
80101b07:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b0b:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b0e:	89 04 24             	mov    %eax,(%esp)
80101b11:	e8 7a 26 00 00       	call   80104190 <strncpy>
  de.inum = inum;
80101b16:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b19:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101b20:	00 
80101b21:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b25:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101b29:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b2d:	89 34 24             	mov    %esi,(%esp)
80101b30:	e8 5b fa ff ff       	call   80101590 <writei>
80101b35:	83 f8 10             	cmp    $0x10,%eax
80101b38:	75 2c                	jne    80101b66 <dirlink+0xd6>
    panic("dirlink");
80101b3a:	31 c0                	xor    %eax,%eax
  
  return 0;
}
80101b3c:	83 c4 2c             	add    $0x2c,%esp
80101b3f:	5b                   	pop    %ebx
80101b40:	5e                   	pop    %esi
80101b41:	5f                   	pop    %edi
80101b42:	5d                   	pop    %ebp
80101b43:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101b44:	89 04 24             	mov    %eax,(%esp)
80101b47:	e8 f4 fd ff ff       	call   80101940 <iput>
80101b4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
80101b51:	eb e9                	jmp    80101b3c <dirlink+0xac>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b53:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101b56:	31 db                	xor    %ebx,%ebx
80101b58:	eb a2                	jmp    80101afc <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101b5a:	c7 04 24 58 6b 10 80 	movl   $0x80106b58,(%esp)
80101b61:	e8 1a ec ff ff       	call   80100780 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101b66:	c7 04 24 06 71 10 80 	movl   $0x80107106,(%esp)
80101b6d:	e8 0e ec ff ff       	call   80100780 <panic>
80101b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	53                   	push   %ebx
80101b84:	83 ec 14             	sub    $0x14,%esp
80101b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101b8a:	85 db                	test   %ebx,%ebx
80101b8c:	74 36                	je     80101bc4 <iunlock+0x44>
80101b8e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
80101b92:	74 30                	je     80101bc4 <iunlock+0x44>
80101b94:	8b 43 08             	mov    0x8(%ebx),%eax
80101b97:	85 c0                	test   %eax,%eax
80101b99:	7e 29                	jle    80101bc4 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
80101b9b:	c7 04 24 e0 d7 10 80 	movl   $0x8010d7e0,(%esp)
80101ba2:	e8 a9 23 00 00       	call   80103f50 <acquire>
  ip->flags &= ~I_BUSY;
80101ba7:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
80101bab:	89 1c 24             	mov    %ebx,(%esp)
80101bae:	e8 9d 19 00 00       	call   80103550 <wakeup>
  release(&icache.lock);
80101bb3:	c7 45 08 e0 d7 10 80 	movl   $0x8010d7e0,0x8(%ebp)
}
80101bba:	83 c4 14             	add    $0x14,%esp
80101bbd:	5b                   	pop    %ebx
80101bbe:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
80101bbf:	e9 3c 23 00 00       	jmp    80103f00 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
80101bc4:	c7 04 24 81 6b 10 80 	movl   $0x80106b81,(%esp)
80101bcb:	e8 b0 eb ff ff       	call   80100780 <panic>

80101bd0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	53                   	push   %ebx
80101bd4:	83 ec 14             	sub    $0x14,%esp
80101bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101bda:	89 1c 24             	mov    %ebx,(%esp)
80101bdd:	e8 9e ff ff ff       	call   80101b80 <iunlock>
  iput(ip);
80101be2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101be5:	83 c4 14             	add    $0x14,%esp
80101be8:	5b                   	pop    %ebx
80101be9:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101bea:	e9 51 fd ff ff       	jmp    80101940 <iput>
80101bef:	90                   	nop

80101bf0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	56                   	push   %esi
80101bf4:	53                   	push   %ebx
80101bf5:	83 ec 10             	sub    $0x10,%esp
80101bf8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101bfb:	85 db                	test   %ebx,%ebx
80101bfd:	0f 84 e5 00 00 00    	je     80101ce8 <ilock+0xf8>
80101c03:	8b 53 08             	mov    0x8(%ebx),%edx
80101c06:	85 d2                	test   %edx,%edx
80101c08:	0f 8e da 00 00 00    	jle    80101ce8 <ilock+0xf8>
    panic("ilock");

  acquire(&icache.lock);
80101c0e:	c7 04 24 e0 d7 10 80 	movl   $0x8010d7e0,(%esp)
80101c15:	e8 36 23 00 00       	call   80103f50 <acquire>
  while(ip->flags & I_BUSY)
80101c1a:	8b 43 0c             	mov    0xc(%ebx),%eax
80101c1d:	a8 01                	test   $0x1,%al
80101c1f:	74 1e                	je     80101c3f <ilock+0x4f>
80101c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
80101c28:	c7 44 24 04 e0 d7 10 	movl   $0x8010d7e0,0x4(%esp)
80101c2f:	80 
80101c30:	89 1c 24             	mov    %ebx,(%esp)
80101c33:	e8 48 1a 00 00       	call   80103680 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101c38:	8b 43 0c             	mov    0xc(%ebx),%eax
80101c3b:	a8 01                	test   $0x1,%al
80101c3d:	75 e9                	jne    80101c28 <ilock+0x38>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101c3f:	83 c8 01             	or     $0x1,%eax
80101c42:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
80101c45:	c7 04 24 e0 d7 10 80 	movl   $0x8010d7e0,(%esp)
80101c4c:	e8 af 22 00 00       	call   80103f00 <release>

  if(!(ip->flags & I_VALID)){
80101c51:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
80101c55:	74 09                	je     80101c60 <ilock+0x70>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101c57:	83 c4 10             	add    $0x10,%esp
80101c5a:	5b                   	pop    %ebx
80101c5b:	5e                   	pop    %esi
80101c5c:	5d                   	pop    %ebp
80101c5d:	c3                   	ret    
80101c5e:	66 90                	xchg   %ax,%ax
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101c60:	8b 43 04             	mov    0x4(%ebx),%eax
80101c63:	c1 e8 03             	shr    $0x3,%eax
80101c66:	83 c0 02             	add    $0x2,%eax
80101c69:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c6d:	8b 03                	mov    (%ebx),%eax
80101c6f:	89 04 24             	mov    %eax,(%esp)
80101c72:	e8 79 e4 ff ff       	call   801000f0 <bread>
80101c77:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c79:	8b 43 04             	mov    0x4(%ebx),%eax
80101c7c:	83 e0 07             	and    $0x7,%eax
80101c7f:	c1 e0 06             	shl    $0x6,%eax
80101c82:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
    ip->type = dip->type;
80101c86:	0f b7 10             	movzwl (%eax),%edx
80101c89:	66 89 53 10          	mov    %dx,0x10(%ebx)
    ip->major = dip->major;
80101c8d:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101c91:	66 89 53 12          	mov    %dx,0x12(%ebx)
    ip->minor = dip->minor;
80101c95:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101c99:	66 89 53 14          	mov    %dx,0x14(%ebx)
    ip->nlink = dip->nlink;
80101c9d:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101ca1:	66 89 53 16          	mov    %dx,0x16(%ebx)
    ip->size = dip->size;
80101ca5:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ca8:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
80101cab:	89 53 18             	mov    %edx,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cae:	89 44 24 04          	mov    %eax,0x4(%esp)
80101cb2:	8d 43 1c             	lea    0x1c(%ebx),%eax
80101cb5:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101cbc:	00 
80101cbd:	89 04 24             	mov    %eax,(%esp)
80101cc0:	e8 fb 23 00 00       	call   801040c0 <memmove>
    brelse(bp);
80101cc5:	89 34 24             	mov    %esi,(%esp)
80101cc8:	e8 73 e3 ff ff       	call   80100040 <brelse>
    ip->flags |= I_VALID;
80101ccd:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
80101cd1:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
80101cd6:	0f 85 7b ff ff ff    	jne    80101c57 <ilock+0x67>
      panic("ilock: no type");
80101cdc:	c7 04 24 8f 6b 10 80 	movl   $0x80106b8f,(%esp)
80101ce3:	e8 98 ea ff ff       	call   80100780 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101ce8:	c7 04 24 89 6b 10 80 	movl   $0x80106b89,(%esp)
80101cef:	e8 8c ea ff ff       	call   80100780 <panic>
80101cf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101d00 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	89 c3                	mov    %eax,%ebx
80101d08:	83 ec 2c             	sub    $0x2c,%esp
80101d0b:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d0e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101d11:	80 38 2f             	cmpb   $0x2f,(%eax)
80101d14:	0f 84 14 01 00 00    	je     80101e2e <namex+0x12e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101d1a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101d20:	8b 40 68             	mov    0x68(%eax),%eax
80101d23:	89 04 24             	mov    %eax,(%esp)
80101d26:	e8 d5 f3 ff ff       	call   80101100 <idup>
80101d2b:	89 c7                	mov    %eax,%edi
80101d2d:	eb 04                	jmp    80101d33 <namex+0x33>
80101d2f:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d30:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d33:	0f b6 03             	movzbl (%ebx),%eax
80101d36:	3c 2f                	cmp    $0x2f,%al
80101d38:	74 f6                	je     80101d30 <namex+0x30>
    path++;
  if(*path == 0)
80101d3a:	84 c0                	test   %al,%al
80101d3c:	75 1a                	jne    80101d58 <namex+0x58>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d3e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101d41:	85 c9                	test   %ecx,%ecx
80101d43:	0f 85 0d 01 00 00    	jne    80101e56 <namex+0x156>
    iput(ip);
    return 0;
  }
  return ip;
}
80101d49:	83 c4 2c             	add    $0x2c,%esp
80101d4c:	89 f8                	mov    %edi,%eax
80101d4e:	5b                   	pop    %ebx
80101d4f:	5e                   	pop    %esi
80101d50:	5f                   	pop    %edi
80101d51:	5d                   	pop    %ebp
80101d52:	c3                   	ret    
80101d53:	90                   	nop
80101d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d58:	3c 2f                	cmp    $0x2f,%al
80101d5a:	0f 84 91 00 00 00    	je     80101df1 <namex+0xf1>
80101d60:	89 de                	mov    %ebx,%esi
80101d62:	eb 08                	jmp    80101d6c <namex+0x6c>
80101d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d68:	3c 2f                	cmp    $0x2f,%al
80101d6a:	74 0a                	je     80101d76 <namex+0x76>
    path++;
80101d6c:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d6f:	0f b6 06             	movzbl (%esi),%eax
80101d72:	84 c0                	test   %al,%al
80101d74:	75 f2                	jne    80101d68 <namex+0x68>
80101d76:	89 f2                	mov    %esi,%edx
80101d78:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d7a:	83 fa 0d             	cmp    $0xd,%edx
80101d7d:	7e 79                	jle    80101df8 <namex+0xf8>
    memmove(name, s, DIRSIZ);
80101d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d82:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d89:	00 
80101d8a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d8e:	89 04 24             	mov    %eax,(%esp)
80101d91:	e8 2a 23 00 00       	call   801040c0 <memmove>
80101d96:	eb 03                	jmp    80101d9b <namex+0x9b>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
80101d98:	83 c6 01             	add    $0x1,%esi
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d9b:	80 3e 2f             	cmpb   $0x2f,(%esi)
80101d9e:	74 f8                	je     80101d98 <namex+0x98>
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80101da0:	85 f6                	test   %esi,%esi
80101da2:	74 9a                	je     80101d3e <namex+0x3e>
    ilock(ip);
80101da4:	89 3c 24             	mov    %edi,(%esp)
80101da7:	e8 44 fe ff ff       	call   80101bf0 <ilock>
    if(ip->type != T_DIR){
80101dac:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
80101db1:	75 67                	jne    80101e1a <namex+0x11a>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101db3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101db6:	85 db                	test   %ebx,%ebx
80101db8:	74 09                	je     80101dc3 <namex+0xc3>
80101dba:	80 3e 00             	cmpb   $0x0,(%esi)
80101dbd:	0f 84 81 00 00 00    	je     80101e44 <namex+0x144>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dc6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101dcd:	00 
80101dce:	89 3c 24             	mov    %edi,(%esp)
80101dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101dd5:	e8 e6 f9 ff ff       	call   801017c0 <dirlookup>
80101dda:	85 c0                	test   %eax,%eax
80101ddc:	89 c3                	mov    %eax,%ebx
80101dde:	74 3a                	je     80101e1a <namex+0x11a>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
80101de0:	89 3c 24             	mov    %edi,(%esp)
80101de3:	89 df                	mov    %ebx,%edi
80101de5:	89 f3                	mov    %esi,%ebx
80101de7:	e8 e4 fd ff ff       	call   80101bd0 <iunlockput>
80101dec:	e9 42 ff ff ff       	jmp    80101d33 <namex+0x33>
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101df1:	89 de                	mov    %ebx,%esi
80101df3:	31 d2                	xor    %edx,%edx
80101df5:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101df8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dfb:	89 54 24 08          	mov    %edx,0x8(%esp)
80101dff:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e02:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101e06:	89 04 24             	mov    %eax,(%esp)
80101e09:	e8 b2 22 00 00       	call   801040c0 <memmove>
    name[len] = 0;
80101e0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e14:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
80101e18:	eb 81                	jmp    80101d9b <namex+0x9b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
80101e1a:	89 3c 24             	mov    %edi,(%esp)
80101e1d:	31 ff                	xor    %edi,%edi
80101e1f:	e8 ac fd ff ff       	call   80101bd0 <iunlockput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e24:	83 c4 2c             	add    $0x2c,%esp
80101e27:	89 f8                	mov    %edi,%eax
80101e29:	5b                   	pop    %ebx
80101e2a:	5e                   	pop    %esi
80101e2b:	5f                   	pop    %edi
80101e2c:	5d                   	pop    %ebp
80101e2d:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e2e:	ba 01 00 00 00       	mov    $0x1,%edx
80101e33:	b8 01 00 00 00       	mov    $0x1,%eax
80101e38:	e8 f3 f2 ff ff       	call   80101130 <iget>
80101e3d:	89 c7                	mov    %eax,%edi
80101e3f:	e9 ef fe ff ff       	jmp    80101d33 <namex+0x33>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e44:	89 3c 24             	mov    %edi,(%esp)
80101e47:	e8 34 fd ff ff       	call   80101b80 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e4c:	83 c4 2c             	add    $0x2c,%esp
80101e4f:	89 f8                	mov    %edi,%eax
80101e51:	5b                   	pop    %ebx
80101e52:	5e                   	pop    %esi
80101e53:	5f                   	pop    %edi
80101e54:	5d                   	pop    %ebp
80101e55:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e56:	89 3c 24             	mov    %edi,(%esp)
80101e59:	31 ff                	xor    %edi,%edi
80101e5b:	e8 e0 fa ff ff       	call   80101940 <iput>
    return 0;
80101e60:	e9 e4 fe ff ff       	jmp    80101d49 <namex+0x49>
80101e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e70 <nameiparent>:
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101e70:	55                   	push   %ebp
  return namex(path, 1, name);
80101e71:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101e76:	89 e5                	mov    %esp,%ebp
80101e78:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101e7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101e7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101e81:	c9                   	leave  
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101e82:	e9 79 fe ff ff       	jmp    80101d00 <namex>
80101e87:	89 f6                	mov    %esi,%esi
80101e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e90 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101e90:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e91:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101e93:	89 e5                	mov    %esp,%ebp
80101e95:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e98:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101e9e:	e8 5d fe ff ff       	call   80101d00 <namex>
}
80101ea3:	c9                   	leave  
80101ea4:	c3                   	ret    
80101ea5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101eb0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101eb0:	55                   	push   %ebp
80101eb1:	89 e5                	mov    %esp,%ebp
80101eb3:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
80101eb6:	c7 44 24 04 9e 6b 10 	movl   $0x80106b9e,0x4(%esp)
80101ebd:	80 
80101ebe:	c7 04 24 e0 d7 10 80 	movl   $0x8010d7e0,(%esp)
80101ec5:	e8 f6 1e 00 00       	call   80103dc0 <initlock>
}
80101eca:	c9                   	leave  
80101ecb:	c3                   	ret    
80101ecc:	00 00                	add    %al,(%eax)
	...

80101ed0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ed0:	55                   	push   %ebp
80101ed1:	89 e5                	mov    %esp,%ebp
80101ed3:	56                   	push   %esi
80101ed4:	89 c6                	mov    %eax,%esi
80101ed6:	83 ec 14             	sub    $0x14,%esp
  if(b == 0)
80101ed9:	85 c0                	test   %eax,%eax
80101edb:	0f 84 8d 00 00 00    	je     80101f6e <idestart+0x9e>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ee1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ee6:	66 90                	xchg   %ax,%ax
80101ee8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80101ee9:	25 c0 00 00 00       	and    $0xc0,%eax
80101eee:	83 f8 40             	cmp    $0x40,%eax
80101ef1:	75 f5                	jne    80101ee8 <idestart+0x18>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ef3:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ef8:	31 c0                	xor    %eax,%eax
80101efa:	ee                   	out    %al,(%dx)
80101efb:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f00:	b8 01 00 00 00       	mov    $0x1,%eax
80101f05:	ee                   	out    %al,(%dx)
    panic("idestart");

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
80101f06:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f09:	b2 f3                	mov    $0xf3,%dl
80101f0b:	89 c8                	mov    %ecx,%eax
80101f0d:	ee                   	out    %al,(%dx)
80101f0e:	89 c8                	mov    %ecx,%eax
80101f10:	b2 f4                	mov    $0xf4,%dl
80101f12:	c1 e8 08             	shr    $0x8,%eax
80101f15:	ee                   	out    %al,(%dx)
80101f16:	89 c8                	mov    %ecx,%eax
80101f18:	b2 f5                	mov    $0xf5,%dl
80101f1a:	c1 e8 10             	shr    $0x10,%eax
80101f1d:	ee                   	out    %al,(%dx)
80101f1e:	8b 46 04             	mov    0x4(%esi),%eax
80101f21:	c1 e9 18             	shr    $0x18,%ecx
80101f24:	b2 f6                	mov    $0xf6,%dl
80101f26:	83 e1 0f             	and    $0xf,%ecx
80101f29:	83 e0 01             	and    $0x1,%eax
80101f2c:	c1 e0 04             	shl    $0x4,%eax
80101f2f:	09 c8                	or     %ecx,%eax
80101f31:	83 c8 e0             	or     $0xffffffe0,%eax
80101f34:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f35:	f6 06 04             	testb  $0x4,(%esi)
80101f38:	75 16                	jne    80101f50 <idestart+0x80>
80101f3a:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f3f:	b8 20 00 00 00       	mov    $0x20,%eax
80101f44:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80101f45:	83 c4 14             	add    $0x14,%esp
80101f48:	5e                   	pop    %esi
80101f49:	5d                   	pop    %ebp
80101f4a:	c3                   	ret    
80101f4b:	90                   	nop
80101f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f50:	b2 f7                	mov    $0xf7,%dl
80101f52:	b8 30 00 00 00       	mov    $0x30,%eax
80101f57:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f58:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f5d:	83 c6 18             	add    $0x18,%esi
80101f60:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101f65:	fc                   	cld    
80101f66:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101f68:	83 c4 14             	add    $0x14,%esp
80101f6b:	5e                   	pop    %esi
80101f6c:	5d                   	pop    %ebp
80101f6d:	c3                   	ret    
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101f6e:	c7 04 24 a5 6b 10 80 	movl   $0x80106ba5,(%esp)
80101f75:	e8 06 e8 ff ff       	call   80100780 <panic>
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f80 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101f80:	55                   	push   %ebp
80101f81:	89 e5                	mov    %esp,%ebp
80101f83:	53                   	push   %ebx
80101f84:	83 ec 14             	sub    $0x14,%esp
80101f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80101f8a:	8b 03                	mov    (%ebx),%eax
80101f8c:	a8 01                	test   $0x1,%al
80101f8e:	0f 84 90 00 00 00    	je     80102024 <iderw+0xa4>
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101f94:	83 e0 06             	and    $0x6,%eax
80101f97:	83 f8 02             	cmp    $0x2,%eax
80101f9a:	0f 84 9c 00 00 00    	je     8010203c <iderw+0xbc>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101fa0:	8b 53 04             	mov    0x4(%ebx),%edx
80101fa3:	85 d2                	test   %edx,%edx
80101fa5:	74 0d                	je     80101fb4 <iderw+0x34>
80101fa7:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80101fac:	85 c0                	test   %eax,%eax
80101fae:	0f 84 7c 00 00 00    	je     80102030 <iderw+0xb0>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101fb4:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80101fbb:	e8 90 1f 00 00       	call   80103f50 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101fc0:	ba b4 a5 10 80       	mov    $0x8010a5b4,%edx
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80101fc5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
80101fcc:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101fd1:	85 c0                	test   %eax,%eax
80101fd3:	74 0d                	je     80101fe2 <iderw+0x62>
80101fd5:	8d 76 00             	lea    0x0(%esi),%esi
80101fd8:	8d 50 14             	lea    0x14(%eax),%edx
80101fdb:	8b 40 14             	mov    0x14(%eax),%eax
80101fde:	85 c0                	test   %eax,%eax
80101fe0:	75 f6                	jne    80101fd8 <iderw+0x58>
    ;
  *pp = b;
80101fe2:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(idequeue == b)
80101fe4:	39 1d b4 a5 10 80    	cmp    %ebx,0x8010a5b4
80101fea:	75 14                	jne    80102000 <iderw+0x80>
80101fec:	eb 2d                	jmp    8010201b <iderw+0x9b>
80101fee:	66 90                	xchg   %ax,%ax
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101ff0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
80101ff7:	80 
80101ff8:	89 1c 24             	mov    %ebx,(%esp)
80101ffb:	e8 80 16 00 00       	call   80103680 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102000:	8b 03                	mov    (%ebx),%eax
80102002:	83 e0 06             	and    $0x6,%eax
80102005:	83 f8 02             	cmp    $0x2,%eax
80102008:	75 e6                	jne    80101ff0 <iderw+0x70>
    sleep(b, &idelock);
  }

  release(&idelock);
8010200a:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102011:	83 c4 14             	add    $0x14,%esp
80102014:	5b                   	pop    %ebx
80102015:	5d                   	pop    %ebp
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
80102016:	e9 e5 1e 00 00       	jmp    80103f00 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
8010201b:	89 d8                	mov    %ebx,%eax
8010201d:	e8 ae fe ff ff       	call   80101ed0 <idestart>
80102022:	eb dc                	jmp    80102000 <iderw+0x80>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
80102024:	c7 04 24 ae 6b 10 80 	movl   $0x80106bae,(%esp)
8010202b:	e8 50 e7 ff ff       	call   80100780 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102030:	c7 04 24 d7 6b 10 80 	movl   $0x80106bd7,(%esp)
80102037:	e8 44 e7 ff ff       	call   80100780 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
8010203c:	c7 04 24 c2 6b 10 80 	movl   $0x80106bc2,(%esp)
80102043:	e8 38 e7 ff ff       	call   80100780 <panic>
80102048:	90                   	nop
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	53                   	push   %ebx
80102055:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102058:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
8010205f:	e8 ec 1e 00 00       	call   80103f50 <acquire>
  if((b = idequeue) == 0){
80102064:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
8010206a:	85 db                	test   %ebx,%ebx
8010206c:	74 2d                	je     8010209b <ideintr+0x4b>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
8010206e:	8b 43 14             	mov    0x14(%ebx),%eax
80102071:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102076:	8b 0b                	mov    (%ebx),%ecx
80102078:	f6 c1 04             	test   $0x4,%cl
8010207b:	74 33                	je     801020b0 <ideintr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
8010207d:	83 c9 02             	or     $0x2,%ecx
80102080:	83 e1 fb             	and    $0xfffffffb,%ecx
80102083:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102085:	89 1c 24             	mov    %ebx,(%esp)
80102088:	e8 c3 14 00 00       	call   80103550 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010208d:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
80102092:	85 c0                	test   %eax,%eax
80102094:	74 05                	je     8010209b <ideintr+0x4b>
    idestart(idequeue);
80102096:	e8 35 fe ff ff       	call   80101ed0 <idestart>

  release(&idelock);
8010209b:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020a2:	e8 59 1e 00 00       	call   80103f00 <release>
}
801020a7:	83 c4 10             	add    $0x10,%esp
801020aa:	5b                   	pop    %ebx
801020ab:	5f                   	pop    %edi
801020ac:	5d                   	pop    %ebp
801020ad:	c3                   	ret    
801020ae:	66 90                	xchg   %ax,%ax
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b5:	8d 76 00             	lea    0x0(%esi),%esi
801020b8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801020b9:	0f b6 c0             	movzbl %al,%eax
801020bc:	89 c7                	mov    %eax,%edi
801020be:	81 e7 c0 00 00 00    	and    $0xc0,%edi
801020c4:	83 ff 40             	cmp    $0x40,%edi
801020c7:	75 ef                	jne    801020b8 <ideintr+0x68>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020c9:	a8 21                	test   $0x21,%al
801020cb:	75 b0                	jne    8010207d <ideintr+0x2d>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020cd:	8d 7b 18             	lea    0x18(%ebx),%edi
801020d0:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d5:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020da:	fc                   	cld    
801020db:	f3 6d                	rep insl (%dx),%es:(%edi)
801020dd:	8b 0b                	mov    (%ebx),%ecx
801020df:	eb 9c                	jmp    8010207d <ideintr+0x2d>
801020e1:	eb 0d                	jmp    801020f0 <ideinit>
801020e3:	90                   	nop
801020e4:	90                   	nop
801020e5:	90                   	nop
801020e6:	90                   	nop
801020e7:	90                   	nop
801020e8:	90                   	nop
801020e9:	90                   	nop
801020ea:	90                   	nop
801020eb:	90                   	nop
801020ec:	90                   	nop
801020ed:	90                   	nop
801020ee:	90                   	nop
801020ef:	90                   	nop

801020f0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
801020f6:	c7 44 24 04 f5 6b 10 	movl   $0x80106bf5,0x4(%esp)
801020fd:	80 
801020fe:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102105:	e8 b6 1c 00 00       	call   80103dc0 <initlock>
  picenable(IRQ_IDE);
8010210a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102111:	e8 9a 0e 00 00       	call   80102fb0 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102116:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
8010211b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102122:	83 e8 01             	sub    $0x1,%eax
80102125:	89 44 24 04          	mov    %eax,0x4(%esp)
80102129:	e8 52 00 00 00       	call   80102180 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010212e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102133:	90                   	nop
80102134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102138:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102139:	25 c0 00 00 00       	and    $0xc0,%eax
8010213e:	83 f8 40             	cmp    $0x40,%eax
80102141:	75 f5                	jne    80102138 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102143:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102148:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010214d:	ee                   	out    %al,(%dx)
8010214e:	31 c9                	xor    %ecx,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102150:	b2 f7                	mov    $0xf7,%dl
80102152:	eb 0f                	jmp    80102163 <ideinit+0x73>
80102154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102158:	83 c1 01             	add    $0x1,%ecx
8010215b:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
80102161:	74 0f                	je     80102172 <ideinit+0x82>
80102163:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102164:	84 c0                	test   %al,%al
80102166:	74 f0                	je     80102158 <ideinit+0x68>
      havedisk1 = 1;
80102168:	c7 05 b8 a5 10 80 01 	movl   $0x1,0x8010a5b8
8010216f:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102172:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102177:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010217c:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010217d:	c9                   	leave  
8010217e:	c3                   	ret    
	...

80102180 <ioapicenable>:
}

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
80102180:	8b 15 84 e8 10 80    	mov    0x8010e884,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102186:	55                   	push   %ebp
80102187:	89 e5                	mov    %esp,%ebp
80102189:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
8010218c:	85 d2                	test   %edx,%edx
8010218e:	74 31                	je     801021c1 <ioapicenable+0x41>
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102190:	8b 15 b4 e7 10 80    	mov    0x8010e7b4,%edx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102196:	8d 48 20             	lea    0x20(%eax),%ecx
80102199:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010219d:	89 02                	mov    %eax,(%edx)
  ioapic->data = data;
8010219f:	8b 15 b4 e7 10 80    	mov    0x8010e7b4,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801021a5:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801021a8:	89 4a 10             	mov    %ecx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801021ab:	8b 0d b4 e7 10 80    	mov    0x8010e7b4,%ecx

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801021b1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801021b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801021b6:	a1 b4 e7 10 80       	mov    0x8010e7b4,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801021bb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801021be:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801021c1:	5d                   	pop    %ebp
801021c2:	c3                   	ret    
801021c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	56                   	push   %esi
801021d4:	53                   	push   %ebx
801021d5:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
801021d8:	8b 0d 84 e8 10 80    	mov    0x8010e884,%ecx
801021de:	85 c9                	test   %ecx,%ecx
801021e0:	0f 84 9e 00 00 00    	je     80102284 <ioapicinit+0xb4>
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021e6:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021ed:	00 00 00 
  return ioapic->data;
801021f0:	8b 35 10 00 c0 fe    	mov    0xfec00010,%esi
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801021f6:	bb 00 00 c0 fe       	mov    $0xfec00000,%ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021fb:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
80102202:	00 00 00 
  return ioapic->data;
80102205:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010220a:	0f b6 15 80 e8 10 80 	movzbl 0x8010e880,%edx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102211:	c7 05 b4 e7 10 80 00 	movl   $0xfec00000,0x8010e7b4
80102218:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010221b:	c1 ee 10             	shr    $0x10,%esi
  id = ioapicread(REG_ID) >> 24;
8010221e:	c1 e8 18             	shr    $0x18,%eax

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102221:	81 e6 ff 00 00 00    	and    $0xff,%esi
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102227:	39 c2                	cmp    %eax,%edx
80102229:	74 12                	je     8010223d <ioapicinit+0x6d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010222b:	c7 04 24 fc 6b 10 80 	movl   $0x80106bfc,(%esp)
80102232:	e8 c9 e5 ff ff       	call   80100800 <cprintf>
80102237:	8b 1d b4 e7 10 80    	mov    0x8010e7b4,%ebx
8010223d:	ba 10 00 00 00       	mov    $0x10,%edx
80102242:	31 c0                	xor    %eax,%eax
80102244:	eb 08                	jmp    8010224e <ioapicinit+0x7e>
80102246:	66 90                	xchg   %ax,%ax

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102248:	8b 1d b4 e7 10 80    	mov    0x8010e7b4,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010224e:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
80102250:	8b 1d b4 e7 10 80    	mov    0x8010e7b4,%ebx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102256:	8d 48 20             	lea    0x20(%eax),%ecx
80102259:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010225f:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102262:	89 4b 10             	mov    %ecx,0x10(%ebx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102265:	8b 0d b4 e7 10 80    	mov    0x8010e7b4,%ecx
8010226b:	8d 5a 01             	lea    0x1(%edx),%ebx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010226e:	83 c2 02             	add    $0x2,%edx
80102271:	39 c6                	cmp    %eax,%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102273:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102275:	8b 0d b4 e7 10 80    	mov    0x8010e7b4,%ecx
8010227b:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102282:	7d c4                	jge    80102248 <ioapicinit+0x78>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102284:	83 c4 10             	add    $0x10,%esp
80102287:	5b                   	pop    %ebx
80102288:	5e                   	pop    %esi
80102289:	5d                   	pop    %ebp
8010228a:	c3                   	ret    
8010228b:	00 00                	add    %al,(%eax)
8010228d:	00 00                	add    %al,(%eax)
	...

80102290 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	53                   	push   %ebx
80102294:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102297:	8b 15 f4 e7 10 80    	mov    0x8010e7f4,%edx
8010229d:	85 d2                	test   %edx,%edx
8010229f:	75 2f                	jne    801022d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801022a1:	8b 1d f8 e7 10 80    	mov    0x8010e7f8,%ebx
  if(r)
801022a7:	85 db                	test   %ebx,%ebx
801022a9:	74 07                	je     801022b2 <kalloc+0x22>
    kmem.freelist = r->next;
801022ab:	8b 03                	mov    (%ebx),%eax
801022ad:	a3 f8 e7 10 80       	mov    %eax,0x8010e7f8
  if(kmem.use_lock)
801022b2:	a1 f4 e7 10 80       	mov    0x8010e7f4,%eax
801022b7:	85 c0                	test   %eax,%eax
801022b9:	74 0c                	je     801022c7 <kalloc+0x37>
    release(&kmem.lock);
801022bb:	c7 04 24 c0 e7 10 80 	movl   $0x8010e7c0,(%esp)
801022c2:	e8 39 1c 00 00       	call   80103f00 <release>
  return (char*)r;
}
801022c7:	89 d8                	mov    %ebx,%eax
801022c9:	83 c4 14             	add    $0x14,%esp
801022cc:	5b                   	pop    %ebx
801022cd:	5d                   	pop    %ebp
801022ce:	c3                   	ret    
801022cf:	90                   	nop
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801022d0:	c7 04 24 c0 e7 10 80 	movl   $0x8010e7c0,(%esp)
801022d7:	e8 74 1c 00 00       	call   80103f50 <acquire>
801022dc:	eb c3                	jmp    801022a1 <kalloc+0x11>
801022de:	66 90                	xchg   %ax,%ax

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 14             	sub    $0x14,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 7c                	jne    8010236e <kfree+0x8e>
801022f2:	81 fb 7c 16 11 80    	cmp    $0x8011167c,%ebx
801022f8:	72 74                	jb     8010236e <kfree+0x8e>
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 67                	ja     8010236e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010230e:	00 
8010230f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102316:	00 
80102317:	89 1c 24             	mov    %ebx,(%esp)
8010231a:	e8 d1 1c 00 00       	call   80103ff0 <memset>

  if(kmem.use_lock)
8010231f:	a1 f4 e7 10 80       	mov    0x8010e7f4,%eax
80102324:	85 c0                	test   %eax,%eax
80102326:	75 38                	jne    80102360 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102328:	a1 f8 e7 10 80       	mov    0x8010e7f8,%eax
8010232d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010232f:	8b 0d f4 e7 10 80    	mov    0x8010e7f4,%ecx

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102335:	89 1d f8 e7 10 80    	mov    %ebx,0x8010e7f8
  if(kmem.use_lock)
8010233b:	85 c9                	test   %ecx,%ecx
8010233d:	75 09                	jne    80102348 <kfree+0x68>
    release(&kmem.lock);
}
8010233f:	83 c4 14             	add    $0x14,%esp
80102342:	5b                   	pop    %ebx
80102343:	5d                   	pop    %ebp
80102344:	c3                   	ret    
80102345:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102348:	c7 45 08 c0 e7 10 80 	movl   $0x8010e7c0,0x8(%ebp)
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102354:	e9 a7 1b 00 00       	jmp    80103f00 <release>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102360:	c7 04 24 c0 e7 10 80 	movl   $0x8010e7c0,(%esp)
80102367:	e8 e4 1b 00 00       	call   80103f50 <acquire>
8010236c:	eb ba                	jmp    80102328 <kfree+0x48>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
    panic("kfree");
8010236e:	c7 04 24 2e 6c 10 80 	movl   $0x80106c2e,(%esp)
80102375:	e8 06 e4 ff ff       	call   80100780 <panic>
8010237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102380 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
80102385:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102388:	8b 55 08             	mov    0x8(%ebp),%edx
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010238b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010238e:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
80102394:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023a0:	39 f3                	cmp    %esi,%ebx
801023a2:	76 08                	jbe    801023ac <freerange+0x2c>
801023a4:	eb 18                	jmp    801023be <freerange+0x3e>
801023a6:	66 90                	xchg   %ax,%ax
801023a8:	89 da                	mov    %ebx,%edx
801023aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023ac:	89 14 24             	mov    %edx,(%esp)
801023af:	e8 2c ff ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ba:	39 f0                	cmp    %esi,%eax
801023bc:	76 ea                	jbe    801023a8 <freerange+0x28>
    kfree(p);
}
801023be:	83 c4 10             	add    $0x10,%esp
801023c1:	5b                   	pop    %ebx
801023c2:	5e                   	pop    %esi
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
801023c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <kinit2>:
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
801023d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801023d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801023dd:	8b 45 08             	mov    0x8(%ebp),%eax
801023e0:	89 04 24             	mov    %eax,(%esp)
801023e3:	e8 98 ff ff ff       	call   80102380 <freerange>
  kmem.use_lock = 1;
801023e8:	c7 05 f4 e7 10 80 01 	movl   $0x1,0x8010e7f4
801023ef:	00 00 00 
}
801023f2:	c9                   	leave  
801023f3:	c3                   	ret    
801023f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801023fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102400 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	83 ec 18             	sub    $0x18,%esp
80102406:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80102409:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010240c:	89 75 fc             	mov    %esi,-0x4(%ebp)
8010240f:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102412:	c7 44 24 04 34 6c 10 	movl   $0x80106c34,0x4(%esp)
80102419:	80 
8010241a:	c7 04 24 c0 e7 10 80 	movl   $0x8010e7c0,(%esp)
80102421:	e8 9a 19 00 00       	call   80103dc0 <initlock>
  kmem.use_lock = 0;
  freerange(vstart, vend);
80102426:	89 75 0c             	mov    %esi,0xc(%ebp)
}
80102429:	8b 75 fc             	mov    -0x4(%ebp),%esi
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
8010242c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010242f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102432:	c7 05 f4 e7 10 80 00 	movl   $0x0,0x8010e7f4
80102439:	00 00 00 
  freerange(vstart, vend);
}
8010243c:	89 ec                	mov    %ebp,%esp
8010243e:	5d                   	pop    %ebp
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
8010243f:	e9 3c ff ff ff       	jmp    80102380 <freerange>
	...

80102450 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102450:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102451:	ba 64 00 00 00       	mov    $0x64,%edx
80102456:	89 e5                	mov    %esp,%ebp
80102458:	ec                   	in     (%dx),%al
80102459:	89 c2                	mov    %eax,%edx
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010245b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102460:	83 e2 01             	and    $0x1,%edx
80102463:	74 41                	je     801024a6 <kbdgetc+0x56>
80102465:	ba 60 00 00 00       	mov    $0x60,%edx
8010246a:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010246b:	0f b6 c0             	movzbl %al,%eax

  if(data == 0xE0){
8010246e:	3d e0 00 00 00       	cmp    $0xe0,%eax
80102473:	0f 84 7f 00 00 00    	je     801024f8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102479:	84 c0                	test   %al,%al
8010247b:	79 2b                	jns    801024a8 <kbdgetc+0x58>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010247d:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80102483:	89 c1                	mov    %eax,%ecx
80102485:	83 e1 7f             	and    $0x7f,%ecx
80102488:	f6 c2 40             	test   $0x40,%dl
8010248b:	0f 44 c1             	cmove  %ecx,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010248e:	0f b6 80 40 6c 10 80 	movzbl -0x7fef93c0(%eax),%eax
80102495:	83 c8 40             	or     $0x40,%eax
80102498:	0f b6 c0             	movzbl %al,%eax
8010249b:	f7 d0                	not    %eax
8010249d:	21 d0                	and    %edx,%eax
8010249f:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
801024a4:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801024a6:	5d                   	pop    %ebp
801024a7:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801024a8:	8b 0d bc a5 10 80    	mov    0x8010a5bc,%ecx
801024ae:	f6 c1 40             	test   $0x40,%cl
801024b1:	74 05                	je     801024b8 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801024b3:	0c 80                	or     $0x80,%al
    shift &= ~E0ESC;
801024b5:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801024b8:	0f b6 90 40 6c 10 80 	movzbl -0x7fef93c0(%eax),%edx
801024bf:	09 ca                	or     %ecx,%edx
801024c1:	0f b6 88 40 6d 10 80 	movzbl -0x7fef92c0(%eax),%ecx
801024c8:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801024ca:	89 d1                	mov    %edx,%ecx
801024cc:	83 e1 03             	and    $0x3,%ecx
801024cf:	8b 0c 8d 40 6e 10 80 	mov    -0x7fef91c0(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801024d6:	89 15 bc a5 10 80    	mov    %edx,0x8010a5bc
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
801024dc:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801024df:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  if(shift & CAPSLOCK){
801024e3:	74 c1                	je     801024a6 <kbdgetc+0x56>
    if('a' <= c && c <= 'z')
801024e5:	8d 50 9f             	lea    -0x61(%eax),%edx
801024e8:	83 fa 19             	cmp    $0x19,%edx
801024eb:	77 1b                	ja     80102508 <kbdgetc+0xb8>
      c += 'A' - 'a';
801024ed:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801024f0:	5d                   	pop    %ebp
801024f1:	c3                   	ret    
801024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801024f8:	30 c0                	xor    %al,%al
801024fa:	83 0d bc a5 10 80 40 	orl    $0x40,0x8010a5bc
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102501:	5d                   	pop    %ebp
80102502:	c3                   	ret    
80102503:	90                   	nop
80102504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102508:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010250b:	8d 50 20             	lea    0x20(%eax),%edx
8010250e:	83 f9 19             	cmp    $0x19,%ecx
80102511:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
80102514:	5d                   	pop    %ebp
80102515:	c3                   	ret    
80102516:	8d 76 00             	lea    0x0(%esi),%esi
80102519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102520 <kbdintr>:

void
kbdintr(void)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102526:	c7 04 24 50 24 10 80 	movl   $0x80102450,(%esp)
8010252d:	e8 ce e0 ff ff       	call   80100600 <consoleintr>
}
80102532:	c9                   	leave  
80102533:	c3                   	ret    
	...

80102540 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic) 
80102540:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
80102545:	55                   	push   %ebp
80102546:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102548:	85 c0                	test   %eax,%eax
8010254a:	0f 84 09 01 00 00    	je     80102659 <lapicinit+0x119>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102550:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102557:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010255a:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
8010255f:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102562:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102569:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010256c:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
80102571:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102574:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010257b:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
8010257e:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
80102583:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102586:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010258d:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102590:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
80102595:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102598:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010259f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801025a2:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
801025a7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025aa:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801025b1:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801025b4:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
801025b9:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801025bc:	8b 50 30             	mov    0x30(%eax),%edx
801025bf:	c1 ea 10             	shr    $0x10,%edx
801025c2:	80 fa 03             	cmp    $0x3,%dl
801025c5:	0f 87 95 00 00 00    	ja     80102660 <lapicinit+0x120>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025cb:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801025d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025d5:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
801025da:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025dd:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801025e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025e7:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
801025ec:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025ef:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801025f6:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025f9:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
801025fe:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102601:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102608:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010260b:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
80102610:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102613:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
8010261a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010261d:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
80102622:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102625:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010262c:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
8010262f:	8b 0d fc e7 10 80    	mov    0x8010e7fc,%ecx
80102635:	8b 41 20             	mov    0x20(%ecx),%eax
80102638:	8d 91 00 03 00 00    	lea    0x300(%ecx),%edx
8010263e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102640:	8b 02                	mov    (%edx),%eax
80102642:	f6 c4 10             	test   $0x10,%ah
80102645:	75 f9                	jne    80102640 <lapicinit+0x100>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102647:	c7 81 80 00 00 00 00 	movl   $0x0,0x80(%ecx)
8010264e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102651:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
80102656:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102659:	5d                   	pop    %ebp
8010265a:	c3                   	ret    
8010265b:	90                   	nop
8010265c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102660:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102667:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010266a:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
8010266f:	8b 50 20             	mov    0x20(%eax),%edx
80102672:	e9 54 ff ff ff       	jmp    801025cb <lapicinit+0x8b>
80102677:	89 f6                	mov    %esi,%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102680:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102685:	55                   	push   %ebp
80102686:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102688:	85 c0                	test   %eax,%eax
8010268a:	74 12                	je     8010269e <lapiceoi+0x1e>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102693:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102696:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
8010269b:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
8010269e:	5d                   	pop    %ebp
8010269f:	c3                   	ret    

801026a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
}
801026a3:	5d                   	pop    %ebp
801026a4:	c3                   	ret    
801026a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801026b0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026b1:	ba 70 00 00 00       	mov    $0x70,%edx
801026b6:	89 e5                	mov    %esp,%ebp
801026b8:	b8 0f 00 00 00       	mov    $0xf,%eax
801026bd:	53                   	push   %ebx
801026be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026c1:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
801026c5:	ee                   	out    %al,(%dx)
801026c6:	b8 0a 00 00 00       	mov    $0xa,%eax
801026cb:	b2 71                	mov    $0x71,%dl
801026cd:	ee                   	out    %al,(%dx)
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801026ce:	89 c8                	mov    %ecx,%eax
801026d0:	c1 e8 04             	shr    $0x4,%eax
801026d3:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d9:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
801026de:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801026e1:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801026e8:	00 00 

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
801026ea:	c1 e9 0c             	shr    $0xc,%ecx
801026ed:	80 cd 06             	or     $0x6,%ch
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f0:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801026f6:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
801026fb:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026fe:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102705:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102708:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
8010270d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102710:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102717:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
8010271f:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102722:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102728:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
8010272d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102730:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102736:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
8010273b:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010273e:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102744:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
80102749:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010274c:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102752:	a1 fc e7 10 80       	mov    0x8010e7fc,%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102757:	5b                   	pop    %ebx
80102758:	5d                   	pop    %ebp

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
80102759:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010275c:	c3                   	ret    
8010275d:	8d 76 00             	lea    0x0(%esi),%esi

80102760 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102766:	9c                   	pushf  
80102767:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102768:	f6 c4 02             	test   $0x2,%ah
8010276b:	74 12                	je     8010277f <cpunum+0x1f>
    static int n;
    if(n++ == 0)
8010276d:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80102772:	8d 50 01             	lea    0x1(%eax),%edx
80102775:	85 c0                	test   %eax,%eax
80102777:	89 15 c0 a5 10 80    	mov    %edx,0x8010a5c0
8010277d:	74 19                	je     80102798 <cpunum+0x38>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if(lapic)
8010277f:	8b 15 fc e7 10 80    	mov    0x8010e7fc,%edx
80102785:	31 c0                	xor    %eax,%eax
80102787:	85 d2                	test   %edx,%edx
80102789:	74 06                	je     80102791 <cpunum+0x31>
    return lapic[ID]>>24;
8010278b:	8b 42 20             	mov    0x20(%edx),%eax
8010278e:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
80102791:	c9                   	leave  
80102792:	c3                   	ret    
80102793:	90                   	nop
80102794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
80102798:	8b 45 04             	mov    0x4(%ebp),%eax
8010279b:	c7 04 24 50 6e 10 80 	movl   $0x80106e50,(%esp)
801027a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801027a6:	e8 55 e0 ff ff       	call   80100800 <cprintf>
801027ab:	eb d2                	jmp    8010277f <cpunum+0x1f>
801027ad:	00 00                	add    %al,(%eax)
	...

801027b0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	57                   	push   %edi
801027b4:	56                   	push   %esi
801027b5:	53                   	push   %ebx
801027b6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801027b9:	a1 44 e8 10 80       	mov    0x8010e844,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801027be:	8b 75 08             	mov    0x8(%ebp),%esi
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801027c1:	83 f8 09             	cmp    $0x9,%eax
801027c4:	0f 8f b4 00 00 00    	jg     8010287e <log_write+0xce>
801027ca:	8b 15 38 e8 10 80    	mov    0x8010e838,%edx
801027d0:	83 ea 01             	sub    $0x1,%edx
801027d3:	39 d0                	cmp    %edx,%eax
801027d5:	0f 8d a3 00 00 00    	jge    8010287e <log_write+0xce>
    panic("too big a transaction");
  if (!log.busy)
801027db:	8b 15 3c e8 10 80    	mov    0x8010e83c,%edx
801027e1:	85 d2                	test   %edx,%edx
801027e3:	0f 84 a1 00 00 00    	je     8010288a <log_write+0xda>
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
801027e9:	85 c0                	test   %eax,%eax
801027eb:	0f 8e 86 00 00 00    	jle    80102877 <log_write+0xc7>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801027f1:	8b 56 08             	mov    0x8(%esi),%edx
801027f4:	31 db                	xor    %ebx,%ebx
801027f6:	39 15 48 e8 10 80    	cmp    %edx,0x8010e848
801027fc:	75 0b                	jne    80102809 <log_write+0x59>
801027fe:	eb 10                	jmp    80102810 <log_write+0x60>
80102800:	39 14 9d 48 e8 10 80 	cmp    %edx,-0x7fef17b8(,%ebx,4)
80102807:	74 07                	je     80102810 <log_write+0x60>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80102809:	83 c3 01             	add    $0x1,%ebx
8010280c:	39 d8                	cmp    %ebx,%eax
8010280e:	7f f0                	jg     80102800 <log_write+0x50>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
  }
  log.lh.sector[i] = b->sector;
80102810:	89 14 9d 48 e8 10 80 	mov    %edx,-0x7fef17b8(,%ebx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80102817:	a1 34 e8 10 80       	mov    0x8010e834,%eax
8010281c:	8d 44 03 01          	lea    0x1(%ebx,%eax,1),%eax
80102820:	89 44 24 04          	mov    %eax,0x4(%esp)
80102824:	8b 46 04             	mov    0x4(%esi),%eax
80102827:	89 04 24             	mov    %eax,(%esp)
8010282a:	e8 c1 d8 ff ff       	call   801000f0 <bread>
  memmove(lbuf->data, b->data, BSIZE);
8010282f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102836:	00 
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
  }
  log.lh.sector[i] = b->sector;
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80102837:	89 c7                	mov    %eax,%edi
  memmove(lbuf->data, b->data, BSIZE);
80102839:	8d 46 18             	lea    0x18(%esi),%eax
8010283c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102840:	8d 47 18             	lea    0x18(%edi),%eax
80102843:	89 04 24             	mov    %eax,(%esp)
80102846:	e8 75 18 00 00       	call   801040c0 <memmove>
  bwrite(lbuf);
8010284b:	89 3c 24             	mov    %edi,(%esp)
8010284e:	e8 6d d8 ff ff       	call   801000c0 <bwrite>
  brelse(lbuf);
80102853:	89 3c 24             	mov    %edi,(%esp)
80102856:	e8 e5 d7 ff ff       	call   80100040 <brelse>
  if (i == log.lh.n)
8010285b:	39 1d 44 e8 10 80    	cmp    %ebx,0x8010e844
80102861:	75 09                	jne    8010286c <log_write+0xbc>
    log.lh.n++;
80102863:	83 c3 01             	add    $0x1,%ebx
80102866:	89 1d 44 e8 10 80    	mov    %ebx,0x8010e844
  b->flags |= B_DIRTY; // XXX prevent eviction
8010286c:	83 0e 04             	orl    $0x4,(%esi)
}
8010286f:	83 c4 1c             	add    $0x1c,%esp
80102872:	5b                   	pop    %ebx
80102873:	5e                   	pop    %esi
80102874:	5f                   	pop    %edi
80102875:	5d                   	pop    %ebp
80102876:	c3                   	ret    
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80102877:	8b 56 08             	mov    0x8(%esi),%edx
8010287a:	31 db                	xor    %ebx,%ebx
8010287c:	eb 92                	jmp    80102810 <log_write+0x60>
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
8010287e:	c7 04 24 7c 6e 10 80 	movl   $0x80106e7c,(%esp)
80102885:	e8 f6 de ff ff       	call   80100780 <panic>
  if (!log.busy)
    panic("write outside of trans");
8010288a:	c7 04 24 92 6e 10 80 	movl   $0x80106e92,(%esp)
80102891:	e8 ea de ff ff       	call   80100780 <panic>
80102896:	8d 76 00             	lea    0x0(%esi),%esi
80102899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028a0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801028a0:	55                   	push   %ebp
801028a1:	89 e5                	mov    %esp,%ebp
801028a3:	57                   	push   %edi
801028a4:	56                   	push   %esi
801028a5:	53                   	push   %ebx
801028a6:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801028a9:	8b 0d 44 e8 10 80    	mov    0x8010e844,%ecx
801028af:	85 c9                	test   %ecx,%ecx
801028b1:	7e 78                	jle    8010292b <install_trans+0x8b>
801028b3:	31 db                	xor    %ebx,%ebx
801028b5:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801028b8:	a1 34 e8 10 80       	mov    0x8010e834,%eax
801028bd:	8d 44 03 01          	lea    0x1(%ebx,%eax,1),%eax
801028c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801028c5:	a1 40 e8 10 80       	mov    0x8010e840,%eax
801028ca:	89 04 24             	mov    %eax,(%esp)
801028cd:	e8 1e d8 ff ff       	call   801000f0 <bread>
801028d2:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801028d4:	8b 04 9d 48 e8 10 80 	mov    -0x7fef17b8(,%ebx,4),%eax
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801028db:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801028de:	89 44 24 04          	mov    %eax,0x4(%esp)
801028e2:	a1 40 e8 10 80       	mov    0x8010e840,%eax
801028e7:	89 04 24             	mov    %eax,(%esp)
801028ea:	e8 01 d8 ff ff       	call   801000f0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801028ef:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801028f6:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801028f7:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801028f9:	8d 47 18             	lea    0x18(%edi),%eax
801028fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80102900:	8d 46 18             	lea    0x18(%esi),%eax
80102903:	89 04 24             	mov    %eax,(%esp)
80102906:	e8 b5 17 00 00       	call   801040c0 <memmove>
    bwrite(dbuf);  // write dst to disk
8010290b:	89 34 24             	mov    %esi,(%esp)
8010290e:	e8 ad d7 ff ff       	call   801000c0 <bwrite>
    brelse(lbuf); 
80102913:	89 3c 24             	mov    %edi,(%esp)
80102916:	e8 25 d7 ff ff       	call   80100040 <brelse>
    brelse(dbuf);
8010291b:	89 34 24             	mov    %esi,(%esp)
8010291e:	e8 1d d7 ff ff       	call   80100040 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102923:	39 1d 44 e8 10 80    	cmp    %ebx,0x8010e844
80102929:	7f 8d                	jg     801028b8 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010292b:	83 c4 1c             	add    $0x1c,%esp
8010292e:	5b                   	pop    %ebx
8010292f:	5e                   	pop    %esi
80102930:	5f                   	pop    %edi
80102931:	5d                   	pop    %ebp
80102932:	c3                   	ret    
80102933:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102940 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
80102943:	56                   	push   %esi
80102944:	53                   	push   %ebx
80102945:	83 ec 10             	sub    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102948:	a1 34 e8 10 80       	mov    0x8010e834,%eax
8010294d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102951:	a1 40 e8 10 80       	mov    0x8010e840,%eax
80102956:	89 04 24             	mov    %eax,(%esp)
80102959:	e8 92 d7 ff ff       	call   801000f0 <bread>
8010295e:	89 c6                	mov    %eax,%esi
  struct logheader *hb = (struct logheader *) (buf->data);
80102960:	8d 58 18             	lea    0x18(%eax),%ebx
  int i;
  hb->n = log.lh.n;
80102963:	a1 44 e8 10 80       	mov    0x8010e844,%eax
80102968:	89 46 18             	mov    %eax,0x18(%esi)
  for (i = 0; i < log.lh.n; i++) {
8010296b:	a1 44 e8 10 80       	mov    0x8010e844,%eax
80102970:	85 c0                	test   %eax,%eax
80102972:	7e 1a                	jle    8010298e <write_head+0x4e>
80102974:	31 d2                	xor    %edx,%edx
80102976:	66 90                	xchg   %ax,%ax
    hb->sector[i] = log.lh.sector[i];
80102978:	8b 0c 95 48 e8 10 80 	mov    -0x7fef17b8(,%edx,4),%ecx
8010297f:	89 4c 93 04          	mov    %ecx,0x4(%ebx,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102983:	83 c2 01             	add    $0x1,%edx
80102986:	39 15 44 e8 10 80    	cmp    %edx,0x8010e844
8010298c:	7f ea                	jg     80102978 <write_head+0x38>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
8010298e:	89 34 24             	mov    %esi,(%esp)
80102991:	e8 2a d7 ff ff       	call   801000c0 <bwrite>
  brelse(buf);
80102996:	89 34 24             	mov    %esi,(%esp)
80102999:	e8 a2 d6 ff ff       	call   80100040 <brelse>
}
8010299e:	83 c4 10             	add    $0x10,%esp
801029a1:	5b                   	pop    %ebx
801029a2:	5e                   	pop    %esi
801029a3:	5d                   	pop    %ebp
801029a4:	c3                   	ret    
801029a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029b0 <commit_trans>:
  release(&log.lock);
}

void
commit_trans(void)
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
801029b6:	8b 15 44 e8 10 80    	mov    0x8010e844,%edx
801029bc:	85 d2                	test   %edx,%edx
801029be:	7e 19                	jle    801029d9 <commit_trans+0x29>
    write_head();    // Write header to disk -- the real commit
801029c0:	e8 7b ff ff ff       	call   80102940 <write_head>
    install_trans(); // Now install writes to home locations
801029c5:	e8 d6 fe ff ff       	call   801028a0 <install_trans>
    log.lh.n = 0; 
801029ca:	c7 05 44 e8 10 80 00 	movl   $0x0,0x8010e844
801029d1:	00 00 00 
    write_head();    // Erase the transaction from the log
801029d4:	e8 67 ff ff ff       	call   80102940 <write_head>
  }
  
  acquire(&log.lock);
801029d9:	c7 04 24 00 e8 10 80 	movl   $0x8010e800,(%esp)
801029e0:	e8 6b 15 00 00       	call   80103f50 <acquire>
  log.busy = 0;
  wakeup(&log);
801029e5:	c7 04 24 00 e8 10 80 	movl   $0x8010e800,(%esp)
    log.lh.n = 0; 
    write_head();    // Erase the transaction from the log
  }
  
  acquire(&log.lock);
  log.busy = 0;
801029ec:	c7 05 3c e8 10 80 00 	movl   $0x0,0x8010e83c
801029f3:	00 00 00 
  wakeup(&log);
801029f6:	e8 55 0b 00 00       	call   80103550 <wakeup>
  release(&log.lock);
801029fb:	c7 04 24 00 e8 10 80 	movl   $0x8010e800,(%esp)
80102a02:	e8 f9 14 00 00       	call   80103f00 <release>
}
80102a07:	c9                   	leave  
80102a08:	c3                   	ret    
80102a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a10 <begin_trans>:
  write_head(); // clear the log
}

void
begin_trans(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102a16:	c7 04 24 00 e8 10 80 	movl   $0x8010e800,(%esp)
80102a1d:	e8 2e 15 00 00       	call   80103f50 <acquire>
  while (log.busy) {
80102a22:	a1 3c e8 10 80       	mov    0x8010e83c,%eax
80102a27:	85 c0                	test   %eax,%eax
80102a29:	74 23                	je     80102a4e <begin_trans+0x3e>
80102a2b:	90                   	nop
80102a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(&log, &log.lock);
80102a30:	c7 44 24 04 00 e8 10 	movl   $0x8010e800,0x4(%esp)
80102a37:	80 
80102a38:	c7 04 24 00 e8 10 80 	movl   $0x8010e800,(%esp)
80102a3f:	e8 3c 0c 00 00       	call   80103680 <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80102a44:	8b 0d 3c e8 10 80    	mov    0x8010e83c,%ecx
80102a4a:	85 c9                	test   %ecx,%ecx
80102a4c:	75 e2                	jne    80102a30 <begin_trans+0x20>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
  release(&log.lock);
80102a4e:	c7 04 24 00 e8 10 80 	movl   $0x8010e800,(%esp)
{
  acquire(&log.lock);
  while (log.busy) {
    sleep(&log, &log.lock);
  }
  log.busy = 1;
80102a55:	c7 05 3c e8 10 80 01 	movl   $0x1,0x8010e83c
80102a5c:	00 00 00 
  release(&log.lock);
80102a5f:	e8 9c 14 00 00       	call   80103f00 <release>
}
80102a64:	c9                   	leave  
80102a65:	c3                   	ret    
80102a66:	8d 76 00             	lea    0x0(%esi),%esi
80102a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a70 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	56                   	push   %esi
80102a74:	53                   	push   %ebx
80102a75:	83 ec 20             	sub    $0x20,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102a78:	c7 44 24 04 a9 6e 10 	movl   $0x80106ea9,0x4(%esp)
80102a7f:	80 
80102a80:	c7 04 24 00 e8 10 80 	movl   $0x8010e800,(%esp)
80102a87:	e8 34 13 00 00       	call   80103dc0 <initlock>
  readsb(ROOTDEV, &sb);
80102a8c:	8d 45 e8             	lea    -0x18(%ebp),%eax
80102a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102a9a:	e8 11 e8 ff ff       	call   801012b0 <readsb>
  log.start = sb.size - sb.nlog;
80102a9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102aa2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  log.size = sb.nlog;
  log.dev = ROOTDEV;
80102aa5:	c7 05 40 e8 10 80 01 	movl   $0x1,0x8010e840
80102aac:	00 00 00 

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aaf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(ROOTDEV, &sb);
  log.start = sb.size - sb.nlog;
  log.size = sb.nlog;
80102ab6:	89 15 38 e8 10 80    	mov    %edx,0x8010e838
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(ROOTDEV, &sb);
  log.start = sb.size - sb.nlog;
80102abc:	29 d0                	sub    %edx,%eax
80102abe:	a3 34 e8 10 80       	mov    %eax,0x8010e834

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ac7:	e8 24 d6 ff ff       	call   801000f0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102acc:	8b 58 18             	mov    0x18(%eax),%ebx
// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
80102acf:	8d 70 18             	lea    0x18(%eax),%esi
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ad2:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ad4:	89 1d 44 e8 10 80    	mov    %ebx,0x8010e844
  for (i = 0; i < log.lh.n; i++) {
80102ada:	7e 16                	jle    80102af2 <initlog+0x82>
80102adc:	31 d2                	xor    %edx,%edx
80102ade:	66 90                	xchg   %ax,%ax
    log.lh.sector[i] = lh->sector[i];
80102ae0:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102ae4:	89 0c 95 48 e8 10 80 	mov    %ecx,-0x7fef17b8(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102aeb:	83 c2 01             	add    $0x1,%edx
80102aee:	39 da                	cmp    %ebx,%edx
80102af0:	75 ee                	jne    80102ae0 <initlog+0x70>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80102af2:	89 04 24             	mov    %eax,(%esp)
80102af5:	e8 46 d5 ff ff       	call   80100040 <brelse>

static void
recover_from_log(void)
{
  read_head();      
  install_trans(); // if committed, copy from log to disk
80102afa:	e8 a1 fd ff ff       	call   801028a0 <install_trans>
  log.lh.n = 0;
80102aff:	c7 05 44 e8 10 80 00 	movl   $0x0,0x8010e844
80102b06:	00 00 00 
  write_head(); // clear the log
80102b09:	e8 32 fe ff ff       	call   80102940 <write_head>
  readsb(ROOTDEV, &sb);
  log.start = sb.size - sb.nlog;
  log.size = sb.nlog;
  log.dev = ROOTDEV;
  recover_from_log();
}
80102b0e:	83 c4 20             	add    $0x20,%esp
80102b11:	5b                   	pop    %ebx
80102b12:	5e                   	pop    %esi
80102b13:	5d                   	pop    %ebp
80102b14:	c3                   	ret    
	...

80102b20 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80102b26:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80102b2c:	0f b6 00             	movzbl (%eax),%eax
80102b2f:	c7 04 24 ad 6e 10 80 	movl   $0x80106ead,(%esp)
80102b36:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b3a:	e8 c1 dc ff ff       	call   80100800 <cprintf>
  idtinit();       // load idt register
80102b3f:	e8 6c 27 00 00       	call   801052b0 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102b44:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102b4b:	b8 01 00 00 00       	mov    $0x1,%eax
80102b50:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102b57:	e8 34 0c 00 00       	call   80103790 <scheduler>
80102b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b60 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	83 e4 f0             	and    $0xfffffff0,%esp
80102b66:	53                   	push   %ebx
80102b67:	83 ec 1c             	sub    $0x1c,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102b6a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102b71:	80 
80102b72:	c7 04 24 7c 16 11 80 	movl   $0x8011167c,(%esp)
80102b79:	e8 82 f8 ff ff       	call   80102400 <kinit1>
  kvmalloc();      // kernel page table
80102b7e:	e8 7d 38 00 00       	call   80106400 <kvmalloc>
  mpinit();        // collect info about this machine
80102b83:	e8 f8 01 00 00       	call   80102d80 <mpinit>
  lapicinit();
80102b88:	e8 b3 f9 ff ff       	call   80102540 <lapicinit>
80102b8d:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // set up segments
80102b90:	e8 9b 3d 00 00       	call   80106930 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80102b95:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80102b9b:	0f b6 00             	movzbl (%eax),%eax
80102b9e:	c7 04 24 be 6e 10 80 	movl   $0x80106ebe,(%esp)
80102ba5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ba9:	e8 52 dc ff ff       	call   80100800 <cprintf>
  picinit();       // interrupt controller
80102bae:	e8 2d 04 00 00       	call   80102fe0 <picinit>
  ioapicinit();    // another interrupt controller
80102bb3:	e8 18 f6 ff ff       	call   801021d0 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80102bb8:	e8 73 d6 ff ff       	call   80100230 <consoleinit>
80102bbd:	8d 76 00             	lea    0x0(%esi),%esi
  uartinit();      // serial port
80102bc0:	e8 9b 2a 00 00       	call   80105660 <uartinit>
  pinit();         // process table
80102bc5:	e8 d6 11 00 00       	call   80103da0 <pinit>
  tvinit();        // trap vectors
80102bca:	e8 61 29 00 00       	call   80105530 <tvinit>
80102bcf:	90                   	nop
  binit();         // buffer cache
80102bd0:	e8 eb d5 ff ff       	call   801001c0 <binit>
  fileinit();      // file table
80102bd5:	e8 d6 e4 ff ff       	call   801010b0 <fileinit>
  iinit();         // inode cache
80102bda:	e8 d1 f2 ff ff       	call   80101eb0 <iinit>
80102bdf:	90                   	nop
  ideinit();       // disk
80102be0:	e8 0b f5 ff ff       	call   801020f0 <ideinit>
  if(!ismp)
80102be5:	a1 84 e8 10 80       	mov    0x8010e884,%eax
80102bea:	85 c0                	test   %eax,%eax
80102bec:	0f 84 cf 00 00 00    	je     80102cc1 <main+0x161>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102bf2:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102bf9:	00 
80102bfa:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102c01:	80 
80102c02:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102c09:	e8 b2 14 00 00       	call   801040c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102c0e:	69 05 80 ee 10 80 bc 	imul   $0xbc,0x8010ee80,%eax
80102c15:	00 00 00 
80102c18:	05 a0 e8 10 80       	add    $0x8010e8a0,%eax
80102c1d:	3d a0 e8 10 80       	cmp    $0x8010e8a0,%eax
80102c22:	76 7f                	jbe    80102ca3 <main+0x143>
80102c24:	bb a0 e8 10 80       	mov    $0x8010e8a0,%ebx
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpunum())  // We've started already.
80102c30:	e8 2b fb ff ff       	call   80102760 <cpunum>
80102c35:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102c3b:	05 a0 e8 10 80       	add    $0x8010e8a0,%eax
80102c40:	39 c3                	cmp    %eax,%ebx
80102c42:	74 46                	je     80102c8a <main+0x12a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102c44:	e8 47 f6 ff ff       	call   80102290 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102c49:	c7 05 f8 6f 00 80 d0 	movl   $0x80102cd0,0x80006ff8
80102c50:	2c 10 80 
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80102c53:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102c5a:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102c5d:	05 00 10 00 00       	add    $0x1000,%eax
80102c62:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) v2p(entrypgdir);

    lapicstartap(c->id, v2p(code));
80102c67:	0f b6 03             	movzbl (%ebx),%eax
80102c6a:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102c71:	00 
80102c72:	89 04 24             	mov    %eax,(%esp)
80102c75:	e8 36 fa ff ff       	call   801026b0 <lapicstartap>
80102c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102c80:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102c86:	85 c0                	test   %eax,%eax
80102c88:	74 f6                	je     80102c80 <main+0x120>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102c8a:	69 05 80 ee 10 80 bc 	imul   $0xbc,0x8010ee80,%eax
80102c91:	00 00 00 
80102c94:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80102c9a:	05 a0 e8 10 80       	add    $0x8010e8a0,%eax
80102c9f:	39 c3                	cmp    %eax,%ebx
80102ca1:	72 8d                	jb     80102c30 <main+0xd0>
  iinit();         // inode cache
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ca3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102caa:	8e 
80102cab:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102cb2:	e8 19 f7 ff ff       	call   801023d0 <kinit2>
  userinit();      // first user process
80102cb7:	e8 f4 0f 00 00       	call   80103cb0 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80102cbc:	e8 5f fe ff ff       	call   80102b20 <mpmain>
  binit();         // buffer cache
  fileinit();      // file table
  iinit();         // inode cache
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80102cc1:	e8 8a 25 00 00       	call   80105250 <timerinit>
80102cc6:	e9 27 ff ff ff       	jmp    80102bf2 <main+0x92>
80102ccb:	90                   	nop
80102ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102cd0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80102cd6:	e8 b5 34 00 00       	call   80106190 <switchkvm>
  seginit();
80102cdb:	e8 50 3c 00 00       	call   80106930 <seginit>
  lapicinit();
80102ce0:	e8 5b f8 ff ff       	call   80102540 <lapicinit>
  mpmain();
80102ce5:	e8 36 fe ff ff       	call   80102b20 <mpmain>
80102cea:	00 00                	add    %al,(%eax)
80102cec:	00 00                	add    %al,(%eax)
	...

80102cf0 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80102cf0:	a1 c4 a5 10 80       	mov    0x8010a5c4,%eax
80102cf5:	55                   	push   %ebp
80102cf6:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
80102cf8:	5d                   	pop    %ebp
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80102cf9:	2d a0 e8 10 80       	sub    $0x8010e8a0,%eax
80102cfe:	c1 f8 02             	sar    $0x2,%eax
80102d01:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
  return bcpu-cpus;
}
80102d07:	c3                   	ret    
80102d08:	90                   	nop
80102d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d10 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	56                   	push   %esi
80102d14:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = p2v(a);
80102d15:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102d1b:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
80102d1e:	8d 34 13             	lea    (%ebx,%edx,1),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102d21:	39 f3                	cmp    %esi,%ebx
80102d23:	73 3c                	jae    80102d61 <mpsearch1+0x51>
80102d25:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102d28:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102d2f:	00 
80102d30:	c7 44 24 04 d5 6e 10 	movl   $0x80106ed5,0x4(%esp)
80102d37:	80 
80102d38:	89 1c 24             	mov    %ebx,(%esp)
80102d3b:	e8 20 13 00 00       	call   80104060 <memcmp>
80102d40:	85 c0                	test   %eax,%eax
80102d42:	75 16                	jne    80102d5a <mpsearch1+0x4a>
80102d44:	31 d2                	xor    %edx,%edx
80102d46:	66 90                	xchg   %ax,%ax
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102d48:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80102d4c:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80102d4f:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80102d51:	83 f8 10             	cmp    $0x10,%eax
80102d54:	75 f2                	jne    80102d48 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102d56:	84 d2                	test   %dl,%dl
80102d58:	74 10                	je     80102d6a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102d5a:	83 c3 10             	add    $0x10,%ebx
80102d5d:	39 de                	cmp    %ebx,%esi
80102d5f:	77 c7                	ja     80102d28 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102d61:	83 c4 10             	add    $0x10,%esp
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102d64:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102d66:	5b                   	pop    %ebx
80102d67:	5e                   	pop    %esi
80102d68:	5d                   	pop    %ebp
80102d69:	c3                   	ret    
80102d6a:	83 c4 10             	add    $0x10,%esp

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
80102d6d:	89 d8                	mov    %ebx,%eax
  return 0;
}
80102d6f:	5b                   	pop    %ebx
80102d70:	5e                   	pop    %esi
80102d71:	5d                   	pop    %ebp
80102d72:	c3                   	ret    
80102d73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d80 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	57                   	push   %edi
80102d84:	56                   	push   %esi
80102d85:	53                   	push   %ebx
80102d86:	83 ec 2c             	sub    $0x2c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102d89:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102d90:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80102d97:	c7 05 c4 a5 10 80 a0 	movl   $0x8010e8a0,0x8010a5c4
80102d9e:	e8 10 80 
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102da1:	c1 e0 08             	shl    $0x8,%eax
80102da4:	09 d0                	or     %edx,%eax
80102da6:	c1 e0 04             	shl    $0x4,%eax
80102da9:	85 c0                	test   %eax,%eax
80102dab:	75 1b                	jne    80102dc8 <mpinit+0x48>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80102dad:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102db4:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102dbb:	c1 e0 08             	shl    $0x8,%eax
80102dbe:	09 d0                	or     %edx,%eax
80102dc0:	c1 e0 0a             	shl    $0xa,%eax
80102dc3:	2d 00 04 00 00       	sub    $0x400,%eax
80102dc8:	ba 00 04 00 00       	mov    $0x400,%edx
80102dcd:	e8 3e ff ff ff       	call   80102d10 <mpsearch1>
80102dd2:	85 c0                	test   %eax,%eax
80102dd4:	89 c6                	mov    %eax,%esi
80102dd6:	0f 84 c4 00 00 00    	je     80102ea0 <mpinit+0x120>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102ddc:	8b 7e 04             	mov    0x4(%esi),%edi
80102ddf:	85 ff                	test   %edi,%edi
80102de1:	75 08                	jne    80102deb <mpinit+0x6b>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80102de3:	83 c4 2c             	add    $0x2c,%esp
80102de6:	5b                   	pop    %ebx
80102de7:	5e                   	pop    %esi
80102de8:	5f                   	pop    %edi
80102de9:	5d                   	pop    %ebp
80102dea:	c3                   	ret    
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80102deb:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80102df1:	89 d3                	mov    %edx,%ebx
  if(memcmp(conf, "PCMP", 4) != 0)
80102df3:	89 14 24             	mov    %edx,(%esp)
80102df6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102df9:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102e00:	00 
80102e01:	c7 44 24 04 da 6e 10 	movl   $0x80106eda,0x4(%esp)
80102e08:	80 
80102e09:	e8 52 12 00 00       	call   80104060 <memcmp>
80102e0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102e11:	85 c0                	test   %eax,%eax
80102e13:	75 ce                	jne    80102de3 <mpinit+0x63>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102e15:	0f b6 42 06          	movzbl 0x6(%edx),%eax
80102e19:	3c 04                	cmp    $0x4,%al
80102e1b:	74 04                	je     80102e21 <mpinit+0xa1>
80102e1d:	3c 01                	cmp    $0x1,%al
80102e1f:	75 c2                	jne    80102de3 <mpinit+0x63>
  *pmp = mp;
  return conf;
}

void
mpinit(void)
80102e21:	0f b7 42 04          	movzwl 0x4(%edx),%eax
80102e25:	8d 8c 07 00 00 00 80 	lea    -0x80000000(%edi,%eax,1),%ecx
80102e2c:	31 c0                	xor    %eax,%eax
80102e2e:	eb 08                	jmp    80102e38 <mpinit+0xb8>
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102e30:	0f b6 3a             	movzbl (%edx),%edi
80102e33:	83 c2 01             	add    $0x1,%edx
80102e36:	01 f8                	add    %edi,%eax
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80102e38:	39 ca                	cmp    %ecx,%edx
80102e3a:	75 f4                	jne    80102e30 <mpinit+0xb0>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102e3c:	84 c0                	test   %al,%al
80102e3e:	75 a3                	jne    80102de3 <mpinit+0x63>
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
80102e40:	c7 05 84 e8 10 80 01 	movl   $0x1,0x8010e884
80102e47:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80102e4a:	8b 43 24             	mov    0x24(%ebx),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102e4d:	8d 7b 2c             	lea    0x2c(%ebx),%edi

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102e50:	a3 fc e7 10 80       	mov    %eax,0x8010e7fc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102e55:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
80102e59:	01 c3                	add    %eax,%ebx
80102e5b:	39 df                	cmp    %ebx,%edi
80102e5d:	72 2a                	jb     80102e89 <mpinit+0x109>
80102e5f:	eb 7b                	jmp    80102edc <mpinit+0x15c>
80102e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80102e68:	0f b6 c0             	movzbl %al,%eax
80102e6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e6f:	c7 04 24 fc 6e 10 80 	movl   $0x80106efc,(%esp)
80102e76:	e8 85 d9 ff ff       	call   80100800 <cprintf>
      ismp = 0;
80102e7b:	c7 05 84 e8 10 80 00 	movl   $0x0,0x8010e884
80102e82:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102e85:	39 fb                	cmp    %edi,%ebx
80102e87:	76 46                	jbe    80102ecf <mpinit+0x14f>
    switch(*p){
80102e89:	0f b6 07             	movzbl (%edi),%eax
80102e8c:	3c 04                	cmp    $0x4,%al
80102e8e:	77 d8                	ja     80102e68 <mpinit+0xe8>
80102e90:	0f b6 c0             	movzbl %al,%eax
80102e93:	ff 24 85 1c 6f 10 80 	jmp    *-0x7fef90e4(,%eax,4)
80102e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102ea0:	ba 00 00 01 00       	mov    $0x10000,%edx
80102ea5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102eaa:	e8 61 fe ff ff       	call   80102d10 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102eaf:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102eb1:	89 c6                	mov    %eax,%esi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102eb3:	0f 85 23 ff ff ff    	jne    80102ddc <mpinit+0x5c>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80102eb9:	83 c4 2c             	add    $0x2c,%esp
80102ebc:	5b                   	pop    %ebx
80102ebd:	5e                   	pop    %esi
80102ebe:	5f                   	pop    %edi
80102ebf:	5d                   	pop    %ebp
80102ec0:	c3                   	ret    
80102ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102ec8:	83 c7 08             	add    $0x8,%edi
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102ecb:	39 fb                	cmp    %edi,%ebx
80102ecd:	77 ba                	ja     80102e89 <mpinit+0x109>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80102ecf:	a1 84 e8 10 80       	mov    0x8010e884,%eax
80102ed4:	85 c0                	test   %eax,%eax
80102ed6:	0f 84 a4 00 00 00    	je     80102f80 <mpinit+0x200>
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
80102edc:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80102ee0:	0f 84 fd fe ff ff    	je     80102de3 <mpinit+0x63>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ee6:	ba 22 00 00 00       	mov    $0x22,%edx
80102eeb:	b8 70 00 00 00       	mov    $0x70,%eax
80102ef0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ef1:	b2 23                	mov    $0x23,%dl
80102ef3:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ef4:	83 c8 01             	or     $0x1,%eax
80102ef7:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80102ef8:	83 c4 2c             	add    $0x2c,%esp
80102efb:	5b                   	pop    %ebx
80102efc:	5e                   	pop    %esi
80102efd:	5f                   	pop    %edi
80102efe:	5d                   	pop    %ebp
80102eff:	c3                   	ret    
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu != proc->apicid){
80102f00:	0f b6 57 01          	movzbl 0x1(%edi),%edx
80102f04:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
80102f09:	39 c2                	cmp    %eax,%edx
80102f0b:	74 23                	je     80102f30 <mpinit+0x1b0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80102f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f11:	89 54 24 08          	mov    %edx,0x8(%esp)
80102f15:	c7 04 24 df 6e 10 80 	movl   $0x80106edf,(%esp)
80102f1c:	e8 df d8 ff ff       	call   80100800 <cprintf>
        ismp = 0;
80102f21:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
80102f26:	c7 05 84 e8 10 80 00 	movl   $0x0,0x8010e884
80102f2d:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80102f30:	f6 47 03 02          	testb  $0x2,0x3(%edi)
80102f34:	74 12                	je     80102f48 <mpinit+0x1c8>
        bcpu = &cpus[ncpu];
80102f36:	69 d0 bc 00 00 00    	imul   $0xbc,%eax,%edx
80102f3c:	81 c2 a0 e8 10 80    	add    $0x8010e8a0,%edx
80102f42:	89 15 c4 a5 10 80    	mov    %edx,0x8010a5c4
      cpus[ncpu].id = ncpu;
80102f48:	69 d0 bc 00 00 00    	imul   $0xbc,%eax,%edx
      ncpu++;
      p += sizeof(struct mpproc);
80102f4e:	83 c7 14             	add    $0x14,%edi
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
        ismp = 0;
      }
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      cpus[ncpu].id = ncpu;
80102f51:	88 82 a0 e8 10 80    	mov    %al,-0x7fef1760(%edx)
      ncpu++;
80102f57:	83 c0 01             	add    $0x1,%eax
80102f5a:	a3 80 ee 10 80       	mov    %eax,0x8010ee80
      p += sizeof(struct mpproc);
      continue;
80102f5f:	e9 21 ff ff ff       	jmp    80102e85 <mpinit+0x105>
80102f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80102f68:	0f b6 47 01          	movzbl 0x1(%edi),%eax
      p += sizeof(struct mpioapic);
80102f6c:	83 c7 08             	add    $0x8,%edi
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80102f6f:	a2 80 e8 10 80       	mov    %al,0x8010e880
      p += sizeof(struct mpioapic);
      continue;
80102f74:	e9 0c ff ff ff       	jmp    80102e85 <mpinit+0x105>
80102f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ismp = 0;
    }
  }
  if(!ismp){
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80102f80:	c7 05 80 ee 10 80 01 	movl   $0x1,0x8010ee80
80102f87:	00 00 00 
    lapic = 0;
80102f8a:	c7 05 fc e7 10 80 00 	movl   $0x0,0x8010e7fc
80102f91:	00 00 00 
    ioapicid = 0;
80102f94:	c6 05 80 e8 10 80 00 	movb   $0x0,0x8010e880
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80102f9b:	83 c4 2c             	add    $0x2c,%esp
80102f9e:	5b                   	pop    %ebx
80102f9f:	5e                   	pop    %esi
80102fa0:	5f                   	pop    %edi
80102fa1:	5d                   	pop    %ebp
80102fa2:	c3                   	ret    
	...

80102fb0 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80102fb0:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80102fb1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80102fb6:	89 e5                	mov    %esp,%ebp
80102fb8:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
80102fbd:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102fc0:	d3 c0                	rol    %cl,%eax
80102fc2:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
80102fc9:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
80102fcf:	ee                   	out    %al,(%dx)
80102fd0:	66 c1 e8 08          	shr    $0x8,%ax
80102fd4:	b2 a1                	mov    $0xa1,%dl
80102fd6:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
80102fd7:	5d                   	pop    %ebp
80102fd8:	c3                   	ret    
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fe0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	b9 21 00 00 00       	mov    $0x21,%ecx
80102fe6:	89 e5                	mov    %esp,%ebp
80102fe8:	83 ec 0c             	sub    $0xc,%esp
80102feb:	89 1c 24             	mov    %ebx,(%esp)
80102fee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ff3:	89 ca                	mov    %ecx,%edx
80102ff5:	89 74 24 04          	mov    %esi,0x4(%esp)
80102ff9:	89 7c 24 08          	mov    %edi,0x8(%esp)
80102ffd:	ee                   	out    %al,(%dx)
80102ffe:	bb a1 00 00 00       	mov    $0xa1,%ebx
80103003:	89 da                	mov    %ebx,%edx
80103005:	ee                   	out    %al,(%dx)
80103006:	be 11 00 00 00       	mov    $0x11,%esi
8010300b:	b2 20                	mov    $0x20,%dl
8010300d:	89 f0                	mov    %esi,%eax
8010300f:	ee                   	out    %al,(%dx)
80103010:	b8 20 00 00 00       	mov    $0x20,%eax
80103015:	89 ca                	mov    %ecx,%edx
80103017:	ee                   	out    %al,(%dx)
80103018:	b8 04 00 00 00       	mov    $0x4,%eax
8010301d:	ee                   	out    %al,(%dx)
8010301e:	bf 03 00 00 00       	mov    $0x3,%edi
80103023:	89 f8                	mov    %edi,%eax
80103025:	ee                   	out    %al,(%dx)
80103026:	b1 a0                	mov    $0xa0,%cl
80103028:	89 f0                	mov    %esi,%eax
8010302a:	89 ca                	mov    %ecx,%edx
8010302c:	ee                   	out    %al,(%dx)
8010302d:	b8 28 00 00 00       	mov    $0x28,%eax
80103032:	89 da                	mov    %ebx,%edx
80103034:	ee                   	out    %al,(%dx)
80103035:	b8 02 00 00 00       	mov    $0x2,%eax
8010303a:	ee                   	out    %al,(%dx)
8010303b:	89 f8                	mov    %edi,%eax
8010303d:	ee                   	out    %al,(%dx)
8010303e:	be 68 00 00 00       	mov    $0x68,%esi
80103043:	b2 20                	mov    $0x20,%dl
80103045:	89 f0                	mov    %esi,%eax
80103047:	ee                   	out    %al,(%dx)
80103048:	bb 0a 00 00 00       	mov    $0xa,%ebx
8010304d:	89 d8                	mov    %ebx,%eax
8010304f:	ee                   	out    %al,(%dx)
80103050:	89 f0                	mov    %esi,%eax
80103052:	89 ca                	mov    %ecx,%edx
80103054:	ee                   	out    %al,(%dx)
80103055:	89 d8                	mov    %ebx,%eax
80103057:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103058:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
8010305f:	66 83 f8 ff          	cmp    $0xffffffff,%ax
80103063:	74 0a                	je     8010306f <picinit+0x8f>
80103065:	b2 21                	mov    $0x21,%dl
80103067:	ee                   	out    %al,(%dx)
80103068:	66 c1 e8 08          	shr    $0x8,%ax
8010306c:	b2 a1                	mov    $0xa1,%dl
8010306e:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
8010306f:	8b 1c 24             	mov    (%esp),%ebx
80103072:	8b 74 24 04          	mov    0x4(%esp),%esi
80103076:	8b 7c 24 08          	mov    0x8(%esp),%edi
8010307a:	89 ec                	mov    %ebp,%esp
8010307c:	5d                   	pop    %ebp
8010307d:	c3                   	ret    
	...

80103080 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	57                   	push   %edi
80103084:	56                   	push   %esi
80103085:	53                   	push   %ebx
80103086:	83 ec 1c             	sub    $0x1c,%esp
80103089:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010308c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010308f:	89 1c 24             	mov    %ebx,(%esp)
80103092:	e8 b9 0e 00 00       	call   80103f50 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103097:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
8010309d:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
801030a3:	75 58                	jne    801030fd <piperead+0x7d>
801030a5:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801030ab:	85 f6                	test   %esi,%esi
801030ad:	74 4e                	je     801030fd <piperead+0x7d>
    if(proc->killed){
801030af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801030b5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
801030bb:	8b 48 24             	mov    0x24(%eax),%ecx
801030be:	85 c9                	test   %ecx,%ecx
801030c0:	74 21                	je     801030e3 <piperead+0x63>
801030c2:	e9 99 00 00 00       	jmp    80103160 <piperead+0xe0>
801030c7:	90                   	nop
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801030c8:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801030ce:	85 c0                	test   %eax,%eax
801030d0:	74 2b                	je     801030fd <piperead+0x7d>
    if(proc->killed){
801030d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801030d8:	8b 50 24             	mov    0x24(%eax),%edx
801030db:	85 d2                	test   %edx,%edx
801030dd:	0f 85 7d 00 00 00    	jne    80103160 <piperead+0xe0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801030e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801030e7:	89 34 24             	mov    %esi,(%esp)
801030ea:	e8 91 05 00 00       	call   80103680 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801030ef:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801030f5:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
801030fb:	74 cb                	je     801030c8 <piperead+0x48>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801030fd:	85 ff                	test   %edi,%edi
801030ff:	7e 76                	jle    80103177 <piperead+0xf7>
    if(p->nread == p->nwrite)
80103101:	31 f6                	xor    %esi,%esi
80103103:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
80103109:	75 0d                	jne    80103118 <piperead+0x98>
8010310b:	eb 6a                	jmp    80103177 <piperead+0xf7>
8010310d:	8d 76 00             	lea    0x0(%esi),%esi
80103110:	39 93 38 02 00 00    	cmp    %edx,0x238(%ebx)
80103116:	74 22                	je     8010313a <piperead+0xba>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103118:	89 d0                	mov    %edx,%eax
8010311a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010311d:	83 c2 01             	add    $0x1,%edx
80103120:	25 ff 01 00 00       	and    $0x1ff,%eax
80103125:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
8010312a:	88 04 31             	mov    %al,(%ecx,%esi,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010312d:	83 c6 01             	add    $0x1,%esi
80103130:	39 f7                	cmp    %esi,%edi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103132:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103138:	7f d6                	jg     80103110 <piperead+0x90>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010313a:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103140:	89 04 24             	mov    %eax,(%esp)
80103143:	e8 08 04 00 00       	call   80103550 <wakeup>
  release(&p->lock);
80103148:	89 1c 24             	mov    %ebx,(%esp)
8010314b:	e8 b0 0d 00 00       	call   80103f00 <release>
  return i;
}
80103150:	83 c4 1c             	add    $0x1c,%esp
80103153:	89 f0                	mov    %esi,%eax
80103155:	5b                   	pop    %ebx
80103156:	5e                   	pop    %esi
80103157:	5f                   	pop    %edi
80103158:	5d                   	pop    %ebp
80103159:	c3                   	ret    
8010315a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
80103160:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103165:	89 1c 24             	mov    %ebx,(%esp)
80103168:	e8 93 0d 00 00       	call   80103f00 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
8010316d:	83 c4 1c             	add    $0x1c,%esp
80103170:	89 f0                	mov    %esi,%eax
80103172:	5b                   	pop    %ebx
80103173:	5e                   	pop    %esi
80103174:	5f                   	pop    %edi
80103175:	5d                   	pop    %ebp
80103176:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103177:	31 f6                	xor    %esi,%esi
80103179:	eb bf                	jmp    8010313a <piperead+0xba>
8010317b:	90                   	nop
8010317c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103180 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
80103185:	53                   	push   %ebx
80103186:	83 ec 3c             	sub    $0x3c,%esp
80103189:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010318c:	89 1c 24             	mov    %ebx,(%esp)
8010318f:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
80103195:	e8 b6 0d 00 00       	call   80103f50 <acquire>
  for(i = 0; i < n; i++){
8010319a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010319d:	85 c9                	test   %ecx,%ecx
8010319f:	0f 8e 8d 00 00 00    	jle    80103232 <pipewrite+0xb2>
801031a5:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801031ab:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
801031b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801031b8:	eb 37                	jmp    801031f1 <pipewrite+0x71>
801031ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801031c0:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801031c6:	85 c0                	test   %eax,%eax
801031c8:	74 7e                	je     80103248 <pipewrite+0xc8>
801031ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801031d0:	8b 50 24             	mov    0x24(%eax),%edx
801031d3:	85 d2                	test   %edx,%edx
801031d5:	75 71                	jne    80103248 <pipewrite+0xc8>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801031d7:	89 34 24             	mov    %esi,(%esp)
801031da:	e8 71 03 00 00       	call   80103550 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801031df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801031e3:	89 3c 24             	mov    %edi,(%esp)
801031e6:	e8 95 04 00 00       	call   80103680 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801031eb:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801031f1:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801031f7:	81 c2 00 02 00 00    	add    $0x200,%edx
801031fd:	39 d0                	cmp    %edx,%eax
801031ff:	74 bf                	je     801031c0 <pipewrite+0x40>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103201:	89 c2                	mov    %eax,%edx
80103203:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103206:	83 c0 01             	add    $0x1,%eax
80103209:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010320f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80103212:	8b 55 0c             	mov    0xc(%ebp),%edx
80103215:	0f b6 0c 0a          	movzbl (%edx,%ecx,1),%ecx
80103219:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010321c:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
80103220:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103226:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010322a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010322d:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103230:	7f bf                	jg     801031f1 <pipewrite+0x71>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103232:	89 34 24             	mov    %esi,(%esp)
80103235:	e8 16 03 00 00       	call   80103550 <wakeup>
  release(&p->lock);
8010323a:	89 1c 24             	mov    %ebx,(%esp)
8010323d:	e8 be 0c 00 00       	call   80103f00 <release>
  return n;
80103242:	eb 13                	jmp    80103257 <pipewrite+0xd7>
80103244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103248:	89 1c 24             	mov    %ebx,(%esp)
8010324b:	e8 b0 0c 00 00       	call   80103f00 <release>
80103250:	c7 45 10 ff ff ff ff 	movl   $0xffffffff,0x10(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103257:	8b 45 10             	mov    0x10(%ebp),%eax
8010325a:	83 c4 3c             	add    $0x3c,%esp
8010325d:	5b                   	pop    %ebx
8010325e:	5e                   	pop    %esi
8010325f:	5f                   	pop    %edi
80103260:	5d                   	pop    %ebp
80103261:	c3                   	ret    
80103262:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103270 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	83 ec 18             	sub    $0x18,%esp
80103276:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80103279:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010327c:	89 75 fc             	mov    %esi,-0x4(%ebp)
8010327f:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103282:	89 1c 24             	mov    %ebx,(%esp)
80103285:	e8 c6 0c 00 00       	call   80103f50 <acquire>
  if(writable){
8010328a:	85 f6                	test   %esi,%esi
8010328c:	74 42                	je     801032d0 <pipeclose+0x60>
    p->writeopen = 0;
8010328e:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103295:	00 00 00 
    wakeup(&p->nread);
80103298:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010329e:	89 04 24             	mov    %eax,(%esp)
801032a1:	e8 aa 02 00 00       	call   80103550 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032a6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801032ac:	85 c0                	test   %eax,%eax
801032ae:	75 0a                	jne    801032ba <pipeclose+0x4a>
801032b0:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801032b6:	85 f6                	test   %esi,%esi
801032b8:	74 36                	je     801032f0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032ba:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032bd:	8b 75 fc             	mov    -0x4(%ebp),%esi
801032c0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801032c3:	89 ec                	mov    %ebp,%esp
801032c5:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032c6:	e9 35 0c 00 00       	jmp    80103f00 <release>
801032cb:	90                   	nop
801032cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801032d0:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032d7:	00 00 00 
    wakeup(&p->nwrite);
801032da:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801032e0:	89 04 24             	mov    %eax,(%esp)
801032e3:	e8 68 02 00 00       	call   80103550 <wakeup>
801032e8:	eb bc                	jmp    801032a6 <pipeclose+0x36>
801032ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801032f0:	89 1c 24             	mov    %ebx,(%esp)
801032f3:	e8 08 0c 00 00       	call   80103f00 <release>
    kfree((char*)p);
  } else
    release(&p->lock);
}
801032f8:	8b 75 fc             	mov    -0x4(%ebp),%esi
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801032fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
801032fe:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80103301:	89 ec                	mov    %ebp,%esp
80103303:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103304:	e9 d7 ef ff ff       	jmp    801022e0 <kfree>
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103310 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103310:	55                   	push   %ebp
80103311:	89 e5                	mov    %esp,%ebp
80103313:	57                   	push   %edi
80103314:	56                   	push   %esi
80103315:	53                   	push   %ebx
80103316:	83 ec 1c             	sub    $0x1c,%esp
80103319:	8b 75 08             	mov    0x8(%ebp),%esi
8010331c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010331f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103325:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010332b:	e8 20 dc ff ff       	call   80100f50 <filealloc>
80103330:	85 c0                	test   %eax,%eax
80103332:	89 06                	mov    %eax,(%esi)
80103334:	0f 84 9c 00 00 00    	je     801033d6 <pipealloc+0xc6>
8010333a:	e8 11 dc ff ff       	call   80100f50 <filealloc>
8010333f:	85 c0                	test   %eax,%eax
80103341:	89 03                	mov    %eax,(%ebx)
80103343:	0f 84 7f 00 00 00    	je     801033c8 <pipealloc+0xb8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103349:	e8 42 ef ff ff       	call   80102290 <kalloc>
8010334e:	85 c0                	test   %eax,%eax
80103350:	89 c7                	mov    %eax,%edi
80103352:	74 74                	je     801033c8 <pipealloc+0xb8>
    goto bad;
  p->readopen = 1;
80103354:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010335b:	00 00 00 
  p->writeopen = 1;
8010335e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103365:	00 00 00 
  p->nwrite = 0;
80103368:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010336f:	00 00 00 
  p->nread = 0;
80103372:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103379:	00 00 00 
  initlock(&p->lock, "pipe");
8010337c:	89 04 24             	mov    %eax,(%esp)
8010337f:	c7 44 24 04 30 6f 10 	movl   $0x80106f30,0x4(%esp)
80103386:	80 
80103387:	e8 34 0a 00 00       	call   80103dc0 <initlock>
  (*f0)->type = FD_PIPE;
8010338c:	8b 06                	mov    (%esi),%eax
8010338e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103394:	8b 06                	mov    (%esi),%eax
80103396:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010339a:	8b 06                	mov    (%esi),%eax
8010339c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033a0:	8b 06                	mov    (%esi),%eax
801033a2:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033a5:	8b 03                	mov    (%ebx),%eax
801033a7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033ad:	8b 03                	mov    (%ebx),%eax
801033af:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033b3:	8b 03                	mov    (%ebx),%eax
801033b5:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033b9:	8b 03                	mov    (%ebx),%eax
801033bb:	89 78 0c             	mov    %edi,0xc(%eax)
801033be:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801033c0:	83 c4 1c             	add    $0x1c,%esp
801033c3:	5b                   	pop    %ebx
801033c4:	5e                   	pop    %esi
801033c5:	5f                   	pop    %edi
801033c6:	5d                   	pop    %ebp
801033c7:	c3                   	ret    

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801033c8:	8b 06                	mov    (%esi),%eax
801033ca:	85 c0                	test   %eax,%eax
801033cc:	74 08                	je     801033d6 <pipealloc+0xc6>
    fileclose(*f0);
801033ce:	89 04 24             	mov    %eax,(%esp)
801033d1:	e8 fa db ff ff       	call   80100fd0 <fileclose>
  if(*f1)
801033d6:	8b 13                	mov    (%ebx),%edx
801033d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033dd:	85 d2                	test   %edx,%edx
801033df:	74 df                	je     801033c0 <pipealloc+0xb0>
    fileclose(*f1);
801033e1:	89 14 24             	mov    %edx,(%esp)
801033e4:	e8 e7 db ff ff       	call   80100fd0 <fileclose>
801033e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033ee:	eb d0                	jmp    801033c0 <pipealloc+0xb0>

801033f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
801033f6:	bb d4 ee 10 80       	mov    $0x8010eed4,%ebx
{
801033fb:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
801033fe:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103401:	eb 4b                	jmp    8010344e <procdump+0x5e>
80103403:	90                   	nop
80103404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103408:	8b 04 85 08 70 10 80 	mov    -0x7fef8ff8(,%eax,4),%eax
8010340f:	85 c0                	test   %eax,%eax
80103411:	74 47                	je     8010345a <procdump+0x6a>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
80103413:	8b 53 10             	mov    0x10(%ebx),%edx
80103416:	8d 4b 6c             	lea    0x6c(%ebx),%ecx
80103419:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010341d:	89 44 24 08          	mov    %eax,0x8(%esp)
80103421:	c7 04 24 39 6f 10 80 	movl   $0x80106f39,(%esp)
80103428:	89 54 24 04          	mov    %edx,0x4(%esp)
8010342c:	e8 cf d3 ff ff       	call   80100800 <cprintf>
    if(p->state == SLEEPING){
80103431:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103435:	74 31                	je     80103468 <procdump+0x78>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103437:	c7 04 24 d3 6e 10 80 	movl   $0x80106ed3,(%esp)
8010343e:	e8 bd d3 ff ff       	call   80100800 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103443:	83 c3 7c             	add    $0x7c,%ebx
80103446:	81 fb d4 0d 11 80    	cmp    $0x80110dd4,%ebx
8010344c:	74 5a                	je     801034a8 <procdump+0xb8>
    if(p->state == UNUSED)
8010344e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103451:	85 c0                	test   %eax,%eax
80103453:	74 ee                	je     80103443 <procdump+0x53>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103455:	83 f8 05             	cmp    $0x5,%eax
80103458:	76 ae                	jbe    80103408 <procdump+0x18>
8010345a:	b8 35 6f 10 80       	mov    $0x80106f35,%eax
8010345f:	eb b2                	jmp    80103413 <procdump+0x23>
80103461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103468:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010346b:	31 f6                	xor    %esi,%esi
8010346d:	89 7c 24 04          	mov    %edi,0x4(%esp)
80103471:	8b 40 0c             	mov    0xc(%eax),%eax
80103474:	83 c0 08             	add    $0x8,%eax
80103477:	89 04 24             	mov    %eax,(%esp)
8010347a:	e8 61 09 00 00       	call   80103de0 <getcallerpcs>
8010347f:	90                   	nop
      for(i=0; i<10 && pc[i] != 0; i++)
80103480:	8b 04 b7             	mov    (%edi,%esi,4),%eax
80103483:	85 c0                	test   %eax,%eax
80103485:	74 b0                	je     80103437 <procdump+0x47>
80103487:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[i]);
8010348a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010348e:	c7 04 24 a3 6a 10 80 	movl   $0x80106aa3,(%esp)
80103495:	e8 66 d3 ff ff       	call   80100800 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010349a:	83 fe 0a             	cmp    $0xa,%esi
8010349d:	75 e1                	jne    80103480 <procdump+0x90>
8010349f:	eb 96                	jmp    80103437 <procdump+0x47>
801034a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801034a8:	83 c4 4c             	add    $0x4c,%esp
801034ab:	5b                   	pop    %ebx
801034ac:	5e                   	pop    %esi
801034ad:	5f                   	pop    %edi
801034ae:	5d                   	pop    %ebp
801034af:	90                   	nop
801034b0:	c3                   	ret    
801034b1:	eb 0d                	jmp    801034c0 <kill>
801034b3:	90                   	nop
801034b4:	90                   	nop
801034b5:	90                   	nop
801034b6:	90                   	nop
801034b7:	90                   	nop
801034b8:	90                   	nop
801034b9:	90                   	nop
801034ba:	90                   	nop
801034bb:	90                   	nop
801034bc:	90                   	nop
801034bd:	90                   	nop
801034be:	90                   	nop
801034bf:	90                   	nop

801034c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	53                   	push   %ebx
801034c4:	83 ec 14             	sub    $0x14,%esp
801034c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801034ca:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
801034d1:	e8 7a 0a 00 00       	call   80103f50 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
801034d6:	8b 15 e4 ee 10 80    	mov    0x8010eee4,%edx

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
801034dc:	b8 50 ef 10 80       	mov    $0x8010ef50,%eax
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
801034e1:	39 da                	cmp    %ebx,%edx
801034e3:	75 0d                	jne    801034f2 <kill+0x32>
801034e5:	eb 60                	jmp    80103547 <kill+0x87>
801034e7:	90                   	nop
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801034e8:	83 c0 7c             	add    $0x7c,%eax
801034eb:	3d d4 0d 11 80       	cmp    $0x80110dd4,%eax
801034f0:	74 3e                	je     80103530 <kill+0x70>
    if(p->pid == pid){
801034f2:	8b 50 10             	mov    0x10(%eax),%edx
801034f5:	39 da                	cmp    %ebx,%edx
801034f7:	75 ef                	jne    801034e8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801034f9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
801034fd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103504:	74 1a                	je     80103520 <kill+0x60>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103506:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
8010350d:	e8 ee 09 00 00       	call   80103f00 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103512:	83 c4 14             	add    $0x14,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
80103515:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103517:	5b                   	pop    %ebx
80103518:	5d                   	pop    %ebp
80103519:	c3                   	ret    
8010351a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103520:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103527:	eb dd                	jmp    80103506 <kill+0x46>
80103529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103530:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80103537:	e8 c4 09 00 00       	call   80103f00 <release>
  return -1;
}
8010353c:	83 c4 14             	add    $0x14,%esp
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
8010353f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
80103544:	5b                   	pop    %ebx
80103545:	5d                   	pop    %ebp
80103546:	c3                   	ret    
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
80103547:	b8 d4 ee 10 80       	mov    $0x8010eed4,%eax
8010354c:	eb ab                	jmp    801034f9 <kill+0x39>
8010354e:	66 90                	xchg   %ax,%ax

80103550 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	53                   	push   %ebx
80103554:	83 ec 14             	sub    $0x14,%esp
80103557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010355a:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80103561:	e8 ea 09 00 00       	call   80103f50 <acquire>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
80103566:	b8 d4 ee 10 80       	mov    $0x8010eed4,%eax
8010356b:	eb 0d                	jmp    8010357a <wakeup+0x2a>
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103570:	83 c0 7c             	add    $0x7c,%eax
80103573:	3d d4 0d 11 80       	cmp    $0x80110dd4,%eax
80103578:	74 1e                	je     80103598 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
8010357a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010357e:	75 f0                	jne    80103570 <wakeup+0x20>
80103580:	3b 58 20             	cmp    0x20(%eax),%ebx
80103583:	75 eb                	jne    80103570 <wakeup+0x20>
      p->state = RUNNABLE;
80103585:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010358c:	83 c0 7c             	add    $0x7c,%eax
8010358f:	3d d4 0d 11 80       	cmp    $0x80110dd4,%eax
80103594:	75 e4                	jne    8010357a <wakeup+0x2a>
80103596:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103598:	c7 45 08 a0 ee 10 80 	movl   $0x8010eea0,0x8(%ebp)
}
8010359f:	83 c4 14             	add    $0x14,%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801035a4:	e9 57 09 00 00       	jmp    80103f00 <release>
801035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035b6:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
801035bd:	e8 3e 09 00 00       	call   80103f00 <release>

  if (first) {
801035c2:	a1 08 a0 10 80       	mov    0x8010a008,%eax
801035c7:	85 c0                	test   %eax,%eax
801035c9:	75 05                	jne    801035d0 <forkret+0x20>
    first = 0;
    initlog();
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801035cb:	c9                   	leave  
801035cc:	c3                   	ret    
801035cd:	8d 76 00             	lea    0x0(%esi),%esi

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801035d0:	c7 05 08 a0 10 80 00 	movl   $0x0,0x8010a008
801035d7:	00 00 00 
    initlog();
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801035da:	c9                   	leave  
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    initlog();
801035db:	e9 90 f4 ff ff       	jmp    80102a70 <initlog>

801035e0 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	53                   	push   %ebx
801035e4:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
801035e7:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
801035ee:	e8 4d 08 00 00       	call   80103e40 <holding>
801035f3:	85 c0                	test   %eax,%eax
801035f5:	74 4d                	je     80103644 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
801035f7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801035fd:	83 b8 ac 00 00 00 01 	cmpl   $0x1,0xac(%eax)
80103604:	75 62                	jne    80103668 <sched+0x88>
    panic("sched locks");
  if(proc->state == RUNNING)
80103606:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010360d:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
80103611:	74 49                	je     8010365c <sched+0x7c>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103613:	9c                   	pushf  
80103614:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103615:	80 e5 02             	and    $0x2,%ch
80103618:	75 36                	jne    80103650 <sched+0x70>
    panic("sched interruptible");
  intena = cpu->intena;
8010361a:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
  swtch(&proc->context, cpu->scheduler);
80103620:	83 c2 1c             	add    $0x1c,%edx
80103623:	8b 40 04             	mov    0x4(%eax),%eax
80103626:	89 14 24             	mov    %edx,(%esp)
80103629:	89 44 24 04          	mov    %eax,0x4(%esp)
8010362d:	e8 0a 0c 00 00       	call   8010423c <swtch>
  cpu->intena = intena;
80103632:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103638:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
8010363e:	83 c4 14             	add    $0x14,%esp
80103641:	5b                   	pop    %ebx
80103642:	5d                   	pop    %ebp
80103643:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103644:	c7 04 24 42 6f 10 80 	movl   $0x80106f42,(%esp)
8010364b:	e8 30 d1 ff ff       	call   80100780 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103650:	c7 04 24 6e 6f 10 80 	movl   $0x80106f6e,(%esp)
80103657:	e8 24 d1 ff ff       	call   80100780 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
8010365c:	c7 04 24 60 6f 10 80 	movl   $0x80106f60,(%esp)
80103663:	e8 18 d1 ff ff       	call   80100780 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103668:	c7 04 24 54 6f 10 80 	movl   $0x80106f54,(%esp)
8010366f:	e8 0c d1 ff ff       	call   80100780 <panic>
80103674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010367a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103680 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	56                   	push   %esi
80103684:	53                   	push   %ebx
80103685:	83 ec 10             	sub    $0x10,%esp
  if(proc == 0)
80103688:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
8010368e:	8b 75 08             	mov    0x8(%ebp),%esi
80103691:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103694:	85 c0                	test   %eax,%eax
80103696:	0f 84 a1 00 00 00    	je     8010373d <sleep+0xbd>
    panic("sleep");

  if(lk == 0)
8010369c:	85 db                	test   %ebx,%ebx
8010369e:	0f 84 8d 00 00 00    	je     80103731 <sleep+0xb1>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801036a4:	81 fb a0 ee 10 80    	cmp    $0x8010eea0,%ebx
801036aa:	74 5c                	je     80103708 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801036ac:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
801036b3:	e8 98 08 00 00       	call   80103f50 <acquire>
    release(lk);
801036b8:	89 1c 24             	mov    %ebx,(%esp)
801036bb:	e8 40 08 00 00       	call   80103f00 <release>
  }

  // Go to sleep.
  proc->chan = chan;
801036c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801036c6:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
801036c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801036cf:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801036d6:	e8 05 ff ff ff       	call   801035e0 <sched>

  // Tidy up.
  proc->chan = 0;
801036db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801036e1:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
801036e8:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
801036ef:	e8 0c 08 00 00       	call   80103f00 <release>
    acquire(lk);
801036f4:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
801036f7:	83 c4 10             	add    $0x10,%esp
801036fa:	5b                   	pop    %ebx
801036fb:	5e                   	pop    %esi
801036fc:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
801036fd:	e9 4e 08 00 00       	jmp    80103f50 <acquire>
80103702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103708:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
8010370b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103711:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103718:	e8 c3 fe ff ff       	call   801035e0 <sched>

  // Tidy up.
  proc->chan = 0;
8010371d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103723:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
8010372a:	83 c4 10             	add    $0x10,%esp
8010372d:	5b                   	pop    %ebx
8010372e:	5e                   	pop    %esi
8010372f:	5d                   	pop    %ebp
80103730:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103731:	c7 04 24 88 6f 10 80 	movl   $0x80106f88,(%esp)
80103738:	e8 43 d0 ff ff       	call   80100780 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
8010373d:	c7 04 24 82 6f 10 80 	movl   $0x80106f82,(%esp)
80103744:	e8 37 d0 ff ff       	call   80100780 <panic>
80103749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103750 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103756:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
8010375d:	e8 ee 07 00 00       	call   80103f50 <acquire>
  proc->state = RUNNABLE;
80103762:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103768:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010376f:	e8 6c fe ff ff       	call   801035e0 <sched>
  release(&ptable.lock);
80103774:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
8010377b:	e8 80 07 00 00       	call   80103f00 <release>
}
80103780:	c9                   	leave  
80103781:	c3                   	ret    
80103782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103790 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
80103794:	83 ec 14             	sub    $0x14,%esp
80103797:	90                   	nop
}

static inline void
sti(void)
{
  asm volatile("sti");
80103798:	fb                   	sti    
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
80103799:	bb d4 ee 10 80       	mov    $0x8010eed4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
8010379e:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
801037a5:	e8 a6 07 00 00       	call   80103f50 <acquire>
801037aa:	eb 0f                	jmp    801037bb <scheduler+0x2b>
801037ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037b0:	83 c3 7c             	add    $0x7c,%ebx
801037b3:	81 fb d4 0d 11 80    	cmp    $0x80110dd4,%ebx
801037b9:	74 55                	je     80103810 <scheduler+0x80>
      if(p->state != RUNNABLE)
801037bb:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801037bf:	75 ef                	jne    801037b0 <scheduler+0x20>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
801037c1:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      switchuvm(p);
801037c8:	89 1c 24             	mov    %ebx,(%esp)
801037cb:	e8 b0 30 00 00       	call   80106880 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, proc->context);
801037d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
801037d6:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037dd:	83 c3 7c             	add    $0x7c,%ebx
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&cpu->scheduler, proc->context);
801037e0:	8b 40 1c             	mov    0x1c(%eax),%eax
801037e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801037e7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801037ed:	83 c0 04             	add    $0x4,%eax
801037f0:	89 04 24             	mov    %eax,(%esp)
801037f3:	e8 44 0a 00 00       	call   8010423c <swtch>
      switchkvm();
801037f8:	e8 93 29 00 00       	call   80106190 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037fd:	81 fb d4 0d 11 80    	cmp    $0x80110dd4,%ebx
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103803:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010380a:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010380e:	75 ab                	jne    801037bb <scheduler+0x2b>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103810:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80103817:	e8 e4 06 00 00       	call   80103f00 <release>

  }
8010381c:	e9 77 ff ff ff       	jmp    80103798 <scheduler+0x8>
80103821:	eb 0d                	jmp    80103830 <wait>
80103823:	90                   	nop
80103824:	90                   	nop
80103825:	90                   	nop
80103826:	90                   	nop
80103827:	90                   	nop
80103828:	90                   	nop
80103829:	90                   	nop
8010382a:	90                   	nop
8010382b:	90                   	nop
8010382c:	90                   	nop
8010382d:	90                   	nop
8010382e:	90                   	nop
8010382f:	90                   	nop

80103830 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103834:	bb d4 ee 10 80       	mov    $0x8010eed4,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103839:	83 ec 24             	sub    $0x24,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
8010383c:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80103843:	e8 08 07 00 00       	call   80103f50 <acquire>
80103848:	31 c0                	xor    %eax,%eax
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103850:	81 fb d4 0d 11 80    	cmp    $0x80110dd4,%ebx
80103856:	72 30                	jb     80103888 <wait+0x58>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103858:	85 c0                	test   %eax,%eax
8010385a:	74 54                	je     801038b0 <wait+0x80>
8010385c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103862:	8b 50 24             	mov    0x24(%eax),%edx
80103865:	85 d2                	test   %edx,%edx
80103867:	75 47                	jne    801038b0 <wait+0x80>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103869:	bb d4 ee 10 80       	mov    $0x8010eed4,%ebx
8010386e:	89 04 24             	mov    %eax,(%esp)
80103871:	c7 44 24 04 a0 ee 10 	movl   $0x8010eea0,0x4(%esp)
80103878:	80 
80103879:	e8 02 fe ff ff       	call   80103680 <sleep>
8010387e:	31 c0                	xor    %eax,%eax

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103880:	81 fb d4 0d 11 80    	cmp    $0x80110dd4,%ebx
80103886:	73 d0                	jae    80103858 <wait+0x28>
      if(p->parent != proc)
80103888:	8b 53 14             	mov    0x14(%ebx),%edx
8010388b:	65 3b 15 04 00 00 00 	cmp    %gs:0x4,%edx
80103892:	74 0c                	je     801038a0 <wait+0x70>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103894:	83 c3 7c             	add    $0x7c,%ebx
80103897:	eb b7                	jmp    80103850 <wait+0x20>
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
801038a0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801038a4:	74 21                	je     801038c7 <wait+0x97>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
801038a6:	b8 01 00 00 00       	mov    $0x1,%eax
801038ab:	eb e7                	jmp    80103894 <wait+0x64>
801038ad:	8d 76 00             	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
801038b0:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
801038b7:	e8 44 06 00 00       	call   80103f00 <release>
801038bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
801038c1:	83 c4 24             	add    $0x24,%esp
801038c4:	5b                   	pop    %ebx
801038c5:	5d                   	pop    %ebp
801038c6:	c3                   	ret    
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
801038c7:	8b 43 10             	mov    0x10(%ebx),%eax
        kfree(p->kstack);
801038ca:	8b 53 08             	mov    0x8(%ebx),%edx
801038cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801038d0:	89 14 24             	mov    %edx,(%esp)
801038d3:	e8 08 ea ff ff       	call   801022e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
801038d8:	8b 53 04             	mov    0x4(%ebx),%edx
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
801038db:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801038e2:	89 14 24             	mov    %edx,(%esp)
801038e5:	e8 96 2c 00 00       	call   80106580 <freevm>
        p->state = UNUSED;
801038ea:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
801038f1:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801038f8:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801038ff:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103903:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        release(&ptable.lock);
8010390a:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80103911:	e8 ea 05 00 00       	call   80103f00 <release>
        return pid;
80103916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103919:	eb a6                	jmp    801038c1 <wait+0x91>
8010391b:	90                   	nop
8010391c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103920 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	56                   	push   %esi
80103924:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103925:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103927:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
8010392a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103931:	3b 15 c8 a5 10 80    	cmp    0x8010a5c8,%edx
80103937:	0f 84 fe 00 00 00    	je     80103a3b <exit+0x11b>
8010393d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103940:	8d 73 08             	lea    0x8(%ebx),%esi
80103943:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103947:	85 c0                	test   %eax,%eax
80103949:	74 1d                	je     80103968 <exit+0x48>
      fileclose(proc->ofile[fd]);
8010394b:	89 04 24             	mov    %eax,(%esp)
8010394e:	e8 7d d6 ff ff       	call   80100fd0 <fileclose>
      proc->ofile[fd] = 0;
80103953:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103959:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80103960:	00 
80103961:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103968:	83 c3 01             	add    $0x1,%ebx
8010396b:	83 fb 10             	cmp    $0x10,%ebx
8010396e:	75 d0                	jne    80103940 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
80103970:	8b 42 68             	mov    0x68(%edx),%eax
80103973:	89 04 24             	mov    %eax,(%esp)
80103976:	e8 c5 df ff ff       	call   80101940 <iput>
  proc->cwd = 0;
8010397b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103981:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103988:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
8010398f:	e8 bc 05 00 00       	call   80103f50 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103994:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
8010399b:	b9 d4 0d 11 80       	mov    $0x80110dd4,%ecx
801039a0:	b8 d4 ee 10 80       	mov    $0x8010eed4,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801039a5:	8b 53 14             	mov    0x14(%ebx),%edx
801039a8:	eb 10                	jmp    801039ba <exit+0x9a>
801039aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039b0:	83 c0 7c             	add    $0x7c,%eax
801039b3:	3d d4 0d 11 80       	cmp    $0x80110dd4,%eax
801039b8:	74 1c                	je     801039d6 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
801039ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801039be:	75 f0                	jne    801039b0 <exit+0x90>
801039c0:	3b 50 20             	cmp    0x20(%eax),%edx
801039c3:	75 eb                	jne    801039b0 <exit+0x90>
      p->state = RUNNABLE;
801039c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039cc:	83 c0 7c             	add    $0x7c,%eax
801039cf:	3d d4 0d 11 80       	cmp    $0x80110dd4,%eax
801039d4:	75 e4                	jne    801039ba <exit+0x9a>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
801039d6:	8b 35 c8 a5 10 80    	mov    0x8010a5c8,%esi
801039dc:	ba d4 ee 10 80       	mov    $0x8010eed4,%edx
801039e1:	eb 0c                	jmp    801039ef <exit+0xcf>
801039e3:	90                   	nop
801039e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039e8:	83 c2 7c             	add    $0x7c,%edx
801039eb:	39 d1                	cmp    %edx,%ecx
801039ed:	74 34                	je     80103a23 <exit+0x103>
    if(p->parent == proc){
801039ef:	3b 5a 14             	cmp    0x14(%edx),%ebx
801039f2:	75 f4                	jne    801039e8 <exit+0xc8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
801039f4:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
801039f8:	89 72 14             	mov    %esi,0x14(%edx)
      if(p->state == ZOMBIE)
801039fb:	75 eb                	jne    801039e8 <exit+0xc8>
801039fd:	b8 d4 ee 10 80       	mov    $0x8010eed4,%eax
80103a02:	eb 0b                	jmp    80103a0f <exit+0xef>
80103a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a08:	83 c0 7c             	add    $0x7c,%eax
80103a0b:	39 c1                	cmp    %eax,%ecx
80103a0d:	74 d9                	je     801039e8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103a0f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103a13:	75 f3                	jne    80103a08 <exit+0xe8>
80103a15:	3b 70 20             	cmp    0x20(%eax),%esi
80103a18:	75 ee                	jne    80103a08 <exit+0xe8>
      p->state = RUNNABLE;
80103a1a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103a21:	eb e5                	jmp    80103a08 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103a23:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103a2a:	e8 b1 fb ff ff       	call   801035e0 <sched>
  panic("zombie exit");
80103a2f:	c7 04 24 a6 6f 10 80 	movl   $0x80106fa6,(%esp)
80103a36:	e8 45 cd ff ff       	call   80100780 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103a3b:	c7 04 24 99 6f 10 80 	movl   $0x80106f99,(%esp)
80103a42:	e8 39 cd ff ff       	call   80100780 <panic>
80103a47:	89 f6                	mov    %esi,%esi
80103a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a50 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
80103a54:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103a57:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80103a5e:	e8 ed 04 00 00       	call   80103f50 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
80103a63:	8b 1d e0 ee 10 80    	mov    0x8010eee0,%ebx
80103a69:	85 db                	test   %ebx,%ebx
80103a6b:	0f 84 a5 00 00 00    	je     80103b16 <allocproc+0xc6>
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
80103a71:	bb 50 ef 10 80       	mov    $0x8010ef50,%ebx
80103a76:	eb 0b                	jmp    80103a83 <allocproc+0x33>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a78:	83 c3 7c             	add    $0x7c,%ebx
80103a7b:	81 fb d4 0d 11 80    	cmp    $0x80110dd4,%ebx
80103a81:	74 7d                	je     80103b00 <allocproc+0xb0>
    if(p->state == UNUSED)
80103a83:	8b 4b 0c             	mov    0xc(%ebx),%ecx
80103a86:	85 c9                	test   %ecx,%ecx
80103a88:	75 ee                	jne    80103a78 <allocproc+0x28>
      goto found;
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103a8a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103a91:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103a96:	89 43 10             	mov    %eax,0x10(%ebx)
80103a99:	83 c0 01             	add    $0x1,%eax
80103a9c:	a3 04 a0 10 80       	mov    %eax,0x8010a004
  release(&ptable.lock);
80103aa1:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80103aa8:	e8 53 04 00 00       	call   80103f00 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103aad:	e8 de e7 ff ff       	call   80102290 <kalloc>
80103ab2:	85 c0                	test   %eax,%eax
80103ab4:	89 43 08             	mov    %eax,0x8(%ebx)
80103ab7:	74 67                	je     80103b20 <allocproc+0xd0>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ab9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
80103abf:	89 53 18             	mov    %edx,0x18(%ebx)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103ac2:	c7 80 b0 0f 00 00 a0 	movl   $0x801052a0,0xfb0(%eax)
80103ac9:	52 10 80 

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103acc:	05 9c 0f 00 00       	add    $0xf9c,%eax
80103ad1:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ad4:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103adb:	00 
80103adc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103ae3:	00 
80103ae4:	89 04 24             	mov    %eax,(%esp)
80103ae7:	e8 04 05 00 00       	call   80103ff0 <memset>
  p->context->eip = (uint)forkret;
80103aec:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103aef:	c7 40 10 b0 35 10 80 	movl   $0x801035b0,0x10(%eax)

  return p;
}
80103af6:	89 d8                	mov    %ebx,%eax
80103af8:	83 c4 14             	add    $0x14,%esp
80103afb:	5b                   	pop    %ebx
80103afc:	5d                   	pop    %ebp
80103afd:	c3                   	ret    
80103afe:	66 90                	xchg   %ax,%ax

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80103b00:	31 db                	xor    %ebx,%ebx
80103b02:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80103b09:	e8 f2 03 00 00       	call   80103f00 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103b0e:	89 d8                	mov    %ebx,%eax
80103b10:	83 c4 14             	add    $0x14,%esp
80103b13:	5b                   	pop    %ebx
80103b14:	5d                   	pop    %ebp
80103b15:	c3                   	ret    
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;
80103b16:	bb d4 ee 10 80       	mov    $0x8010eed4,%ebx
80103b1b:	e9 6a ff ff ff       	jmp    80103a8a <allocproc+0x3a>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103b20:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80103b27:	31 db                	xor    %ebx,%ebx
    return 0;
80103b29:	eb cb                	jmp    80103af6 <allocproc+0xa6>
80103b2b:	90                   	nop
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b30 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	57                   	push   %edi
80103b34:	56                   	push   %esi
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80103b35:	be ff ff ff ff       	mov    $0xffffffff,%esi
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103b3a:	53                   	push   %ebx
80103b3b:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80103b3e:	e8 0d ff ff ff       	call   80103a50 <allocproc>
80103b43:	85 c0                	test   %eax,%eax
80103b45:	89 c3                	mov    %eax,%ebx
80103b47:	0f 84 be 00 00 00    	je     80103c0b <fork+0xdb>
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103b4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b53:	8b 10                	mov    (%eax),%edx
80103b55:	89 54 24 04          	mov    %edx,0x4(%esp)
80103b59:	8b 40 04             	mov    0x4(%eax),%eax
80103b5c:	89 04 24             	mov    %eax,(%esp)
80103b5f:	e8 9c 2a 00 00       	call   80106600 <copyuvm>
80103b64:	85 c0                	test   %eax,%eax
80103b66:	89 43 04             	mov    %eax,0x4(%ebx)
80103b69:	0f 84 a6 00 00 00    	je     80103c15 <fork+0xe5>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103b6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103b75:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103b7a:	8b 00                	mov    (%eax),%eax
80103b7c:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103b7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b84:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103b87:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103b8e:	8b 43 18             	mov    0x18(%ebx),%eax
80103b91:	8b 72 18             	mov    0x18(%edx),%esi
80103b94:	89 c7                	mov    %eax,%edi
80103b96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103b98:	31 f6                	xor    %esi,%esi
80103b9a:	8b 43 18             	mov    0x18(%ebx),%eax
80103b9d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103ba4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103bab:	90                   	nop
80103bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103bb0:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103bb4:	85 c0                	test   %eax,%eax
80103bb6:	74 13                	je     80103bcb <fork+0x9b>
      np->ofile[i] = filedup(proc->ofile[i]);
80103bb8:	89 04 24             	mov    %eax,(%esp)
80103bbb:	e8 40 d3 ff ff       	call   80100f00 <filedup>
80103bc0:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103bc4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103bcb:	83 c6 01             	add    $0x1,%esi
80103bce:	83 fe 10             	cmp    $0x10,%esi
80103bd1:	75 dd                	jne    80103bb0 <fork+0x80>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103bd3:	8b 42 68             	mov    0x68(%edx),%eax
80103bd6:	89 04 24             	mov    %eax,(%esp)
80103bd9:	e8 22 d5 ff ff       	call   80101100 <idup>
 
  pid = np->pid;
80103bde:	8b 73 10             	mov    0x10(%ebx),%esi
  np->state = RUNNABLE;
80103be1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103be8:	89 43 68             	mov    %eax,0x68(%ebx)
 
  pid = np->pid;
  np->state = RUNNABLE;
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103beb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103bf1:	83 c3 6c             	add    $0x6c,%ebx
80103bf4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103bfb:	00 
80103bfc:	89 1c 24             	mov    %ebx,(%esp)
80103bff:	83 c0 6c             	add    $0x6c,%eax
80103c02:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c06:	e8 d5 05 00 00       	call   801041e0 <safestrcpy>
  return pid;
}
80103c0b:	83 c4 1c             	add    $0x1c,%esp
80103c0e:	89 f0                	mov    %esi,%eax
80103c10:	5b                   	pop    %ebx
80103c11:	5e                   	pop    %esi
80103c12:	5f                   	pop    %edi
80103c13:	5d                   	pop    %ebp
80103c14:	c3                   	ret    
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103c15:	8b 43 08             	mov    0x8(%ebx),%eax
80103c18:	89 04 24             	mov    %eax,(%esp)
80103c1b:	e8 c0 e6 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
80103c20:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103c27:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c2e:	eb db                	jmp    80103c0b <fork+0xdb>

80103c30 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80103c36:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103c3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;
  
  sz = proc->sz;
80103c40:	8b 02                	mov    (%edx),%eax
  if(n > 0){
80103c42:	83 f9 00             	cmp    $0x0,%ecx
80103c45:	7f 19                	jg     80103c60 <growproc+0x30>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103c47:	75 39                	jne    80103c82 <growproc+0x52>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
80103c49:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
80103c4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c51:	89 04 24             	mov    %eax,(%esp)
80103c54:	e8 27 2c 00 00       	call   80106880 <switchuvm>
80103c59:	31 c0                	xor    %eax,%eax
  return 0;
}
80103c5b:	c9                   	leave  
80103c5c:	c3                   	ret    
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103c60:	01 c1                	add    %eax,%ecx
80103c62:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80103c66:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c6a:	8b 42 04             	mov    0x4(%edx),%eax
80103c6d:	89 04 24             	mov    %eax,(%esp)
80103c70:	e8 5b 2a 00 00       	call   801066d0 <allocuvm>
80103c75:	85 c0                	test   %eax,%eax
80103c77:	74 27                	je     80103ca0 <growproc+0x70>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103c79:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c80:	eb c7                	jmp    80103c49 <growproc+0x19>
80103c82:	01 c1                	add    %eax,%ecx
80103c84:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80103c88:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c8c:	8b 42 04             	mov    0x4(%edx),%eax
80103c8f:	89 04 24             	mov    %eax,(%esp)
80103c92:	e8 49 28 00 00       	call   801064e0 <deallocuvm>
80103c97:	85 c0                	test   %eax,%eax
80103c99:	75 de                	jne    80103c79 <growproc+0x49>
80103c9b:	90                   	nop
80103c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
80103ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ca5:	c9                   	leave  
80103ca6:	c3                   	ret    
80103ca7:	89 f6                	mov    %esi,%esi
80103ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cb0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	53                   	push   %ebx
80103cb4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80103cb7:	e8 94 fd ff ff       	call   80103a50 <allocproc>
80103cbc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103cbe:	a3 c8 a5 10 80       	mov    %eax,0x8010a5c8
  if((p->pgdir = setupkvm()) == 0)
80103cc3:	e8 b8 26 00 00       	call   80106380 <setupkvm>
80103cc8:	85 c0                	test   %eax,%eax
80103cca:	89 43 04             	mov    %eax,0x4(%ebx)
80103ccd:	0f 84 b6 00 00 00    	je     80103d89 <userinit+0xd9>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103cd3:	89 04 24             	mov    %eax,(%esp)
80103cd6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
80103cdd:	00 
80103cde:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103ce5:	80 
80103ce6:	e8 65 27 00 00       	call   80106450 <inituvm>
  p->sz = PGSIZE;
80103ceb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103cf1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103cf8:	00 
80103cf9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103d00:	00 
80103d01:	8b 43 18             	mov    0x18(%ebx),%eax
80103d04:	89 04 24             	mov    %eax,(%esp)
80103d07:	e8 e4 02 00 00       	call   80103ff0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103d0f:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d15:	8b 43 18             	mov    0x18(%ebx),%eax
80103d18:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d1e:	8b 43 18             	mov    0x18(%ebx),%eax
80103d21:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d25:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d29:	8b 43 18             	mov    0x18(%ebx),%eax
80103d2c:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d30:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d34:	8b 43 18             	mov    0x18(%ebx),%eax
80103d37:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d3e:	8b 43 18             	mov    0x18(%ebx),%eax
80103d41:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d48:	8b 43 18             	mov    0x18(%ebx),%eax
80103d4b:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d52:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d55:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103d5c:	00 
80103d5d:	c7 44 24 04 cb 6f 10 	movl   $0x80106fcb,0x4(%esp)
80103d64:	80 
80103d65:	89 04 24             	mov    %eax,(%esp)
80103d68:	e8 73 04 00 00       	call   801041e0 <safestrcpy>
  p->cwd = namei("/");
80103d6d:	c7 04 24 d4 6f 10 80 	movl   $0x80106fd4,(%esp)
80103d74:	e8 17 e1 ff ff       	call   80101e90 <namei>

  p->state = RUNNABLE;
80103d79:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");
80103d80:	89 43 68             	mov    %eax,0x68(%ebx)

  p->state = RUNNABLE;
}
80103d83:	83 c4 14             	add    $0x14,%esp
80103d86:	5b                   	pop    %ebx
80103d87:	5d                   	pop    %ebp
80103d88:	c3                   	ret    
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103d89:	c7 04 24 b2 6f 10 80 	movl   $0x80106fb2,(%esp)
80103d90:	e8 eb c9 ff ff       	call   80100780 <panic>
80103d95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103da0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103da6:	c7 44 24 04 d6 6f 10 	movl   $0x80106fd6,0x4(%esp)
80103dad:	80 
80103dae:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80103db5:	e8 06 00 00 00       	call   80103dc0 <initlock>
}
80103dba:	c9                   	leave  
80103dbb:	c3                   	ret    
80103dbc:	00 00                	add    %al,(%eax)
	...

80103dc0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80103dc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
80103dcf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80103dd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103dd9:	5d                   	pop    %ebp
80103dda:	c3                   	ret    
80103ddb:	90                   	nop
80103ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103de0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103de0:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80103de1:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103de3:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80103de5:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103de8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103deb:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80103dec:	83 ea 08             	sub    $0x8,%edx
80103def:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103df0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103df6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103dfc:	77 1a                	ja     80103e18 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103dfe:	8b 5a 04             	mov    0x4(%edx),%ebx
80103e01:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80103e04:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80103e07:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80103e09:	83 f8 0a             	cmp    $0xa,%eax
80103e0c:	75 e2                	jne    80103df0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80103e0e:	5b                   	pop    %ebx
80103e0f:	5d                   	pop    %ebp
80103e10:	c3                   	ret    
80103e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80103e18:	83 f8 09             	cmp    $0x9,%eax
80103e1b:	7f f1                	jg     80103e0e <getcallerpcs+0x2e>
80103e1d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80103e20:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80103e27:	83 c0 01             	add    $0x1,%eax
80103e2a:	83 f8 0a             	cmp    $0xa,%eax
80103e2d:	75 f1                	jne    80103e20 <getcallerpcs+0x40>
    pcs[i] = 0;
}
80103e2f:	5b                   	pop    %ebx
80103e30:	5d                   	pop    %ebp
80103e31:	c3                   	ret    
80103e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e40 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80103e40:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
80103e41:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80103e43:	89 e5                	mov    %esp,%ebp
80103e45:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80103e48:	8b 0a                	mov    (%edx),%ecx
80103e4a:	85 c9                	test   %ecx,%ecx
80103e4c:	74 10                	je     80103e5e <holding+0x1e>
80103e4e:	8b 42 08             	mov    0x8(%edx),%eax
80103e51:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
80103e58:	0f 94 c0             	sete   %al
80103e5b:	0f b6 c0             	movzbl %al,%eax
}
80103e5e:	5d                   	pop    %ebp
80103e5f:	c3                   	ret    

80103e60 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e64:	9c                   	pushf  
80103e65:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80103e66:	fa                   	cli    
  int eflags;
  
  eflags = readeflags();
  cli();
  if(cpu->ncli++ == 0)
80103e67:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103e6e:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80103e74:	8d 48 01             	lea    0x1(%eax),%ecx
80103e77:	85 c0                	test   %eax,%eax
80103e79:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80103e7f:	75 12                	jne    80103e93 <pushcli+0x33>
    cpu->intena = eflags & FL_IF;
80103e81:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103e87:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103e8d:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103e93:	5b                   	pop    %ebx
80103e94:	5d                   	pop    %ebp
80103e95:	c3                   	ret    
80103e96:	8d 76 00             	lea    0x0(%esi),%esi
80103e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ea0 <popcli>:

void
popcli(void)
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ea6:	9c                   	pushf  
80103ea7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ea8:	f6 c4 02             	test   $0x2,%ah
80103eab:	75 43                	jne    80103ef0 <popcli+0x50>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
80103ead:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103eb4:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80103eba:	83 e8 01             	sub    $0x1,%eax
80103ebd:	85 c0                	test   %eax,%eax
80103ebf:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
80103ec5:	78 1d                	js     80103ee4 <popcli+0x44>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
80103ec7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103ecd:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103ed3:	85 d2                	test   %edx,%edx
80103ed5:	75 0b                	jne    80103ee2 <popcli+0x42>
80103ed7:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80103edd:	85 c0                	test   %eax,%eax
80103edf:	74 01                	je     80103ee2 <popcli+0x42>
}

static inline void
sti(void)
{
  asm volatile("sti");
80103ee1:	fb                   	sti    
    sti();
}
80103ee2:	c9                   	leave  
80103ee3:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
80103ee4:	c7 04 24 37 70 10 80 	movl   $0x80107037,(%esp)
80103eeb:	e8 90 c8 ff ff       	call   80100780 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80103ef0:	c7 04 24 20 70 10 80 	movl   $0x80107020,(%esp)
80103ef7:	e8 84 c8 ff ff       	call   80100780 <panic>
80103efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f00 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	83 ec 18             	sub    $0x18,%esp
80103f06:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80103f09:	8b 0a                	mov    (%edx),%ecx
80103f0b:	85 c9                	test   %ecx,%ecx
80103f0d:	74 0c                	je     80103f1b <release+0x1b>
80103f0f:	8b 42 08             	mov    0x8(%edx),%eax
80103f12:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
80103f19:	74 0d                	je     80103f28 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80103f1b:	c7 04 24 3e 70 10 80 	movl   $0x8010703e,(%esp)
80103f22:	e8 59 c8 ff ff       	call   80100780 <panic>
80103f27:	90                   	nop

  lk->pcs[0] = 0;
80103f28:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103f2f:	31 c0                	xor    %eax,%eax
  lk->cpu = 0;
80103f31:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
80103f38:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);

  popcli();
}
80103f3b:	c9                   	leave  
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);

  popcli();
80103f3c:	e9 5f ff ff ff       	jmp    80103ea0 <popcli>
80103f41:	eb 0d                	jmp    80103f50 <acquire>
80103f43:	90                   	nop
80103f44:	90                   	nop
80103f45:	90                   	nop
80103f46:	90                   	nop
80103f47:	90                   	nop
80103f48:	90                   	nop
80103f49:	90                   	nop
80103f4a:	90                   	nop
80103f4b:	90                   	nop
80103f4c:	90                   	nop
80103f4d:	90                   	nop
80103f4e:	90                   	nop
80103f4f:	90                   	nop

80103f50 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	53                   	push   %ebx
80103f54:	83 ec 14             	sub    $0x14,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f57:	9c                   	pushf  
80103f58:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80103f59:	fa                   	cli    
{
  int eflags;
  
  eflags = readeflags();
  cli();
  if(cpu->ncli++ == 0)
80103f5a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103f61:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80103f67:	8d 48 01             	lea    0x1(%eax),%ecx
80103f6a:	85 c0                	test   %eax,%eax
80103f6c:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80103f72:	75 12                	jne    80103f86 <acquire+0x36>
    cpu->intena = eflags & FL_IF;
80103f74:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103f7a:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103f80:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
80103f86:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80103f89:	8b 1a                	mov    (%edx),%ebx
80103f8b:	85 db                	test   %ebx,%ebx
80103f8d:	74 0c                	je     80103f9b <acquire+0x4b>
80103f8f:	8b 42 08             	mov    0x8(%edx),%eax
80103f92:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
80103f99:	74 45                	je     80103fe0 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103f9b:	b9 01 00 00 00       	mov    $0x1,%ecx
80103fa0:	eb 09                	jmp    80103fab <acquire+0x5b>
80103fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("acquire");

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80103fa8:	8b 55 08             	mov    0x8(%ebp),%edx
80103fab:	89 c8                	mov    %ecx,%eax
80103fad:	f0 87 02             	lock xchg %eax,(%edx)
80103fb0:	85 c0                	test   %eax,%eax
80103fb2:	75 f4                	jne    80103fa8 <acquire+0x58>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80103fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103fbe:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80103fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc4:	83 c0 0c             	add    $0xc,%eax
80103fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fcb:	8d 45 08             	lea    0x8(%ebp),%eax
80103fce:	89 04 24             	mov    %eax,(%esp)
80103fd1:	e8 0a fe ff ff       	call   80103de0 <getcallerpcs>
}
80103fd6:	83 c4 14             	add    $0x14,%esp
80103fd9:	5b                   	pop    %ebx
80103fda:	5d                   	pop    %ebp
80103fdb:	c3                   	ret    
80103fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80103fe0:	c7 04 24 46 70 10 80 	movl   $0x80107046,(%esp)
80103fe7:	e8 94 c7 ff ff       	call   80100780 <panic>
80103fec:	00 00                	add    %al,(%eax)
	...

80103ff0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	83 ec 08             	sub    $0x8,%esp
80103ff6:	8b 55 08             	mov    0x8(%ebp),%edx
80103ff9:	89 1c 24             	mov    %ebx,(%esp)
80103ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fff:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104003:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104006:	f6 c2 03             	test   $0x3,%dl
80104009:	75 05                	jne    80104010 <memset+0x20>
8010400b:	f6 c1 03             	test   $0x3,%cl
8010400e:	74 18                	je     80104028 <memset+0x38>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104010:	89 d7                	mov    %edx,%edi
80104012:	fc                   	cld    
80104013:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104015:	89 d0                	mov    %edx,%eax
80104017:	8b 1c 24             	mov    (%esp),%ebx
8010401a:	8b 7c 24 04          	mov    0x4(%esp),%edi
8010401e:	89 ec                	mov    %ebp,%esp
80104020:	5d                   	pop    %ebp
80104021:	c3                   	ret    
80104022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104028:	0f b6 f8             	movzbl %al,%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010402b:	89 f8                	mov    %edi,%eax
8010402d:	89 fb                	mov    %edi,%ebx
8010402f:	c1 e0 18             	shl    $0x18,%eax
80104032:	c1 e3 10             	shl    $0x10,%ebx
80104035:	09 d8                	or     %ebx,%eax
80104037:	09 f8                	or     %edi,%eax
80104039:	c1 e7 08             	shl    $0x8,%edi
8010403c:	09 f8                	or     %edi,%eax
8010403e:	89 d7                	mov    %edx,%edi
80104040:	c1 e9 02             	shr    $0x2,%ecx
80104043:	fc                   	cld    
80104044:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104046:	89 d0                	mov    %edx,%eax
80104048:	8b 1c 24             	mov    (%esp),%ebx
8010404b:	8b 7c 24 04          	mov    0x4(%esp),%edi
8010404f:	89 ec                	mov    %ebp,%esp
80104051:	5d                   	pop    %ebp
80104052:	c3                   	ret    
80104053:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104060 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	8b 55 10             	mov    0x10(%ebp),%edx
80104066:	57                   	push   %edi
80104067:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010406a:	56                   	push   %esi
8010406b:	8b 75 08             	mov    0x8(%ebp),%esi
8010406e:	53                   	push   %ebx
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010406f:	85 d2                	test   %edx,%edx
80104071:	74 2d                	je     801040a0 <memcmp+0x40>
    if(*s1 != *s2)
80104073:	0f b6 1e             	movzbl (%esi),%ebx
80104076:	0f b6 0f             	movzbl (%edi),%ecx
80104079:	38 cb                	cmp    %cl,%bl
8010407b:	75 2b                	jne    801040a8 <memcmp+0x48>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010407d:	83 ea 01             	sub    $0x1,%edx
80104080:	31 c0                	xor    %eax,%eax
80104082:	eb 18                	jmp    8010409c <memcmp+0x3c>
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s1 != *s2)
80104088:	0f b6 5c 06 01       	movzbl 0x1(%esi,%eax,1),%ebx
8010408d:	83 ea 01             	sub    $0x1,%edx
80104090:	0f b6 4c 07 01       	movzbl 0x1(%edi,%eax,1),%ecx
80104095:	83 c0 01             	add    $0x1,%eax
80104098:	38 cb                	cmp    %cl,%bl
8010409a:	75 0c                	jne    801040a8 <memcmp+0x48>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010409c:	85 d2                	test   %edx,%edx
8010409e:	75 e8                	jne    80104088 <memcmp+0x28>
801040a0:	31 c0                	xor    %eax,%eax
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801040a2:	5b                   	pop    %ebx
801040a3:	5e                   	pop    %esi
801040a4:	5f                   	pop    %edi
801040a5:	5d                   	pop    %ebp
801040a6:	c3                   	ret    
801040a7:	90                   	nop
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801040a8:	0f b6 c3             	movzbl %bl,%eax
801040ab:	0f b6 c9             	movzbl %cl,%ecx
801040ae:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801040b0:	5b                   	pop    %ebx
801040b1:	5e                   	pop    %esi
801040b2:	5f                   	pop    %edi
801040b3:	5d                   	pop    %ebp
801040b4:	c3                   	ret    
801040b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	57                   	push   %edi
801040c4:	8b 45 08             	mov    0x8(%ebp),%eax
801040c7:	56                   	push   %esi
801040c8:	8b 75 0c             	mov    0xc(%ebp),%esi
801040cb:	53                   	push   %ebx
801040cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801040cf:	39 c6                	cmp    %eax,%esi
801040d1:	73 2d                	jae    80104100 <memmove+0x40>
801040d3:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
801040d6:	39 f8                	cmp    %edi,%eax
801040d8:	73 26                	jae    80104100 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
801040da:	85 db                	test   %ebx,%ebx
801040dc:	74 1d                	je     801040fb <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
801040de:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801040e1:	31 d2                	xor    %edx,%edx
801040e3:	90                   	nop
801040e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
801040e8:	0f b6 4c 17 ff       	movzbl -0x1(%edi,%edx,1),%ecx
801040ed:	88 4c 16 ff          	mov    %cl,-0x1(%esi,%edx,1)
801040f1:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801040f4:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
801040f7:	85 c9                	test   %ecx,%ecx
801040f9:	75 ed                	jne    801040e8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801040fb:	5b                   	pop    %ebx
801040fc:	5e                   	pop    %esi
801040fd:	5f                   	pop    %edi
801040fe:	5d                   	pop    %ebp
801040ff:	c3                   	ret    
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104100:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
80104102:	85 db                	test   %ebx,%ebx
80104104:	74 f5                	je     801040fb <memmove+0x3b>
80104106:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104108:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
8010410c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
8010410f:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104112:	39 d3                	cmp    %edx,%ebx
80104114:	75 f2                	jne    80104108 <memmove+0x48>
      *d++ = *s++;

  return dst;
}
80104116:	5b                   	pop    %ebx
80104117:	5e                   	pop    %esi
80104118:	5f                   	pop    %edi
80104119:	5d                   	pop    %ebp
8010411a:	c3                   	ret    
8010411b:	90                   	nop
8010411c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104120 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104123:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104124:	e9 97 ff ff ff       	jmp    801040c0 <memmove>
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104130 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	57                   	push   %edi
80104134:	8b 7d 10             	mov    0x10(%ebp),%edi
80104137:	56                   	push   %esi
80104138:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010413b:	53                   	push   %ebx
8010413c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010413f:	85 ff                	test   %edi,%edi
80104141:	74 3d                	je     80104180 <strncmp+0x50>
80104143:	0f b6 01             	movzbl (%ecx),%eax
80104146:	84 c0                	test   %al,%al
80104148:	75 18                	jne    80104162 <strncmp+0x32>
8010414a:	eb 3c                	jmp    80104188 <strncmp+0x58>
8010414c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104150:	83 ef 01             	sub    $0x1,%edi
80104153:	74 2b                	je     80104180 <strncmp+0x50>
    n--, p++, q++;
80104155:	83 c1 01             	add    $0x1,%ecx
80104158:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010415b:	0f b6 01             	movzbl (%ecx),%eax
8010415e:	84 c0                	test   %al,%al
80104160:	74 26                	je     80104188 <strncmp+0x58>
80104162:	0f b6 33             	movzbl (%ebx),%esi
80104165:	89 f2                	mov    %esi,%edx
80104167:	38 d0                	cmp    %dl,%al
80104169:	74 e5                	je     80104150 <strncmp+0x20>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010416b:	81 e6 ff 00 00 00    	and    $0xff,%esi
80104171:	0f b6 c0             	movzbl %al,%eax
80104174:	29 f0                	sub    %esi,%eax
}
80104176:	5b                   	pop    %ebx
80104177:	5e                   	pop    %esi
80104178:	5f                   	pop    %edi
80104179:	5d                   	pop    %ebp
8010417a:	c3                   	ret    
8010417b:	90                   	nop
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104180:	31 c0                	xor    %eax,%eax
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104182:	5b                   	pop    %ebx
80104183:	5e                   	pop    %esi
80104184:	5f                   	pop    %edi
80104185:	5d                   	pop    %ebp
80104186:	c3                   	ret    
80104187:	90                   	nop
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104188:	0f b6 33             	movzbl (%ebx),%esi
8010418b:	eb de                	jmp    8010416b <strncmp+0x3b>
8010418d:	8d 76 00             	lea    0x0(%esi),%esi

80104190 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	8b 45 08             	mov    0x8(%ebp),%eax
80104196:	56                   	push   %esi
80104197:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010419a:	53                   	push   %ebx
8010419b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010419e:	89 c3                	mov    %eax,%ebx
801041a0:	eb 09                	jmp    801041ab <strncpy+0x1b>
801041a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801041a8:	83 c6 01             	add    $0x1,%esi
801041ab:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
801041ae:	8d 51 01             	lea    0x1(%ecx),%edx
{
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801041b1:	85 d2                	test   %edx,%edx
801041b3:	7e 0c                	jle    801041c1 <strncpy+0x31>
801041b5:	0f b6 16             	movzbl (%esi),%edx
801041b8:	88 13                	mov    %dl,(%ebx)
801041ba:	83 c3 01             	add    $0x1,%ebx
801041bd:	84 d2                	test   %dl,%dl
801041bf:	75 e7                	jne    801041a8 <strncpy+0x18>
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
801041c1:	31 d2                	xor    %edx,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801041c3:	85 c9                	test   %ecx,%ecx
801041c5:	7e 0c                	jle    801041d3 <strncpy+0x43>
801041c7:	90                   	nop
    *s++ = 0;
801041c8:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
801041cc:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801041cf:	39 ca                	cmp    %ecx,%edx
801041d1:	75 f5                	jne    801041c8 <strncpy+0x38>
    *s++ = 0;
  return os;
}
801041d3:	5b                   	pop    %ebx
801041d4:	5e                   	pop    %esi
801041d5:	5d                   	pop    %ebp
801041d6:	c3                   	ret    
801041d7:	89 f6                	mov    %esi,%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	8b 55 10             	mov    0x10(%ebp),%edx
801041e6:	56                   	push   %esi
801041e7:	8b 45 08             	mov    0x8(%ebp),%eax
801041ea:	53                   	push   %ebx
801041eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;
  
  os = s;
  if(n <= 0)
801041ee:	85 d2                	test   %edx,%edx
801041f0:	7e 1f                	jle    80104211 <safestrcpy+0x31>
801041f2:	89 c1                	mov    %eax,%ecx
801041f4:	eb 05                	jmp    801041fb <safestrcpy+0x1b>
801041f6:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801041f8:	83 c6 01             	add    $0x1,%esi
801041fb:	83 ea 01             	sub    $0x1,%edx
801041fe:	85 d2                	test   %edx,%edx
80104200:	7e 0c                	jle    8010420e <safestrcpy+0x2e>
80104202:	0f b6 1e             	movzbl (%esi),%ebx
80104205:	88 19                	mov    %bl,(%ecx)
80104207:	83 c1 01             	add    $0x1,%ecx
8010420a:	84 db                	test   %bl,%bl
8010420c:	75 ea                	jne    801041f8 <safestrcpy+0x18>
    ;
  *s = 0;
8010420e:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104211:	5b                   	pop    %ebx
80104212:	5e                   	pop    %esi
80104213:	5d                   	pop    %ebp
80104214:	c3                   	ret    
80104215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <strlen>:

int
strlen(const char *s)
{
80104220:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104221:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104223:	89 e5                	mov    %esp,%ebp
80104225:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104228:	80 3a 00             	cmpb   $0x0,(%edx)
8010422b:	74 0c                	je     80104239 <strlen+0x19>
8010422d:	8d 76 00             	lea    0x0(%esi),%esi
80104230:	83 c0 01             	add    $0x1,%eax
80104233:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104237:	75 f7                	jne    80104230 <strlen+0x10>
    ;
  return n;
}
80104239:	5d                   	pop    %ebp
8010423a:	c3                   	ret    
	...

8010423c <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010423c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104240:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104244:	55                   	push   %ebp
  pushl %ebx
80104245:	53                   	push   %ebx
  pushl %esi
80104246:	56                   	push   %esi
  pushl %edi
80104247:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104248:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010424a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010424c:	5f                   	pop    %edi
  popl %esi
8010424d:	5e                   	pop    %esi
  popl %ebx
8010424e:	5b                   	pop    %ebx
  popl %ebp
8010424f:	5d                   	pop    %ebp
  ret
80104250:	c3                   	ret    
	...

80104260 <fetchint>:

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104260:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104267:	55                   	push   %ebp
80104268:	89 e5                	mov    %esp,%ebp
8010426a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
8010426d:	8b 12                	mov    (%edx),%edx
8010426f:	39 c2                	cmp    %eax,%edx
80104271:	77 0d                	ja     80104280 <fetchint+0x20>
    return -1;
  *ip = *(int*)(addr);
  return 0;
80104273:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104278:	5d                   	pop    %ebp
80104279:	c3                   	ret    
8010427a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104280:	8d 48 04             	lea    0x4(%eax),%ecx
80104283:	39 ca                	cmp    %ecx,%edx
80104285:	72 ec                	jb     80104273 <fetchint+0x13>
    return -1;
  *ip = *(int*)(addr);
80104287:	8b 10                	mov    (%eax),%edx
80104289:	8b 45 0c             	mov    0xc(%ebp),%eax
8010428c:	89 10                	mov    %edx,(%eax)
8010428e:	31 c0                	xor    %eax,%eax
  return 0;
}
80104290:	5d                   	pop    %ebp
80104291:	c3                   	ret    
80104292:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042a0 <fetchstr>:
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801042a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801042a6:	55                   	push   %ebp
801042a7:	89 e5                	mov    %esp,%ebp
801042a9:	8b 55 08             	mov    0x8(%ebp),%edx
801042ac:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= proc->sz)
801042ad:	39 10                	cmp    %edx,(%eax)
801042af:	77 0f                	ja     801042c0 <fetchstr+0x20>
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801042b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
801042b6:	5b                   	pop    %ebx
801042b7:	5d                   	pop    %ebp
801042b8:	c3                   	ret    
801042b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
801042c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801042c3:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801042c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042cb:	8b 18                	mov    (%eax),%ebx
  for(s = *pp; s < ep; s++)
801042cd:	39 da                	cmp    %ebx,%edx
801042cf:	73 e0                	jae    801042b1 <fetchstr+0x11>
    if(*s == 0)
801042d1:	31 c0                	xor    %eax,%eax
801042d3:	89 d1                	mov    %edx,%ecx
801042d5:	80 3a 00             	cmpb   $0x0,(%edx)
801042d8:	74 dc                	je     801042b6 <fetchstr+0x16>
801042da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801042e0:	83 c1 01             	add    $0x1,%ecx
801042e3:	39 cb                	cmp    %ecx,%ebx
801042e5:	76 ca                	jbe    801042b1 <fetchstr+0x11>
    if(*s == 0)
801042e7:	80 39 00             	cmpb   $0x0,(%ecx)
801042ea:	75 f4                	jne    801042e0 <fetchstr+0x40>
801042ec:	89 c8                	mov    %ecx,%eax
801042ee:	29 d0                	sub    %edx,%eax
801042f0:	eb c4                	jmp    801042b6 <fetchstr+0x16>
801042f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104300 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104300:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104306:	55                   	push   %ebp
80104307:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104309:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010430c:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010430f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104311:	8b 52 44             	mov    0x44(%edx),%edx
80104314:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104318:	39 c2                	cmp    %eax,%edx
8010431a:	72 0c                	jb     80104328 <argint+0x28>
    return -1;
  *ip = *(int*)(addr);
8010431c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104321:	5d                   	pop    %ebp
80104322:	c3                   	ret    
80104323:	90                   	nop
80104324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104328:	8d 4a 04             	lea    0x4(%edx),%ecx
8010432b:	39 c8                	cmp    %ecx,%eax
8010432d:	72 ed                	jb     8010431c <argint+0x1c>
    return -1;
  *ip = *(int*)(addr);
8010432f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104332:	8b 12                	mov    (%edx),%edx
80104334:	89 10                	mov    %edx,(%eax)
80104336:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104338:	5d                   	pop    %ebp
80104339:	c3                   	ret    
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104340:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104346:	55                   	push   %ebp
80104347:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104349:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010434c:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010434f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104351:	8b 52 44             	mov    0x44(%edx),%edx
80104354:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104358:	39 c2                	cmp    %eax,%edx
8010435a:	73 07                	jae    80104363 <argptr+0x23>
8010435c:	8d 4a 04             	lea    0x4(%edx),%ecx
8010435f:	39 c8                	cmp    %ecx,%eax
80104361:	73 0d                	jae    80104370 <argptr+0x30>
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
80104363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104368:	5d                   	pop    %ebp
80104369:	c3                   	ret    
8010436a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104370:	8b 12                	mov    (%edx),%edx
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80104372:	39 c2                	cmp    %eax,%edx
80104374:	73 ed                	jae    80104363 <argptr+0x23>
80104376:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104379:	01 d1                	add    %edx,%ecx
8010437b:	39 c1                	cmp    %eax,%ecx
8010437d:	77 e4                	ja     80104363 <argptr+0x23>
    return -1;
  *pp = (char*)i;
8010437f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104382:	89 10                	mov    %edx,(%eax)
80104384:	31 c0                	xor    %eax,%eax
  return 0;
}
80104386:	5d                   	pop    %ebp
80104387:	c3                   	ret    
80104388:	90                   	nop
80104389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104390 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104390:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104396:	55                   	push   %ebp
80104397:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104399:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010439c:	8b 50 18             	mov    0x18(%eax),%edx
8010439f:	8b 52 44             	mov    0x44(%edx),%edx
801043a2:	8d 4c 8a 04          	lea    0x4(%edx,%ecx,4),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801043a6:	8b 10                	mov    (%eax),%edx
801043a8:	39 d1                	cmp    %edx,%ecx
801043aa:	73 07                	jae    801043b3 <argstr+0x23>
801043ac:	8d 41 04             	lea    0x4(%ecx),%eax
801043af:	39 c2                	cmp    %eax,%edx
801043b1:	73 0d                	jae    801043c0 <argstr+0x30>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801043b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801043b8:	5d                   	pop    %ebp
801043b9:	c3                   	ret    
801043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
801043c0:	8b 09                	mov    (%ecx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801043c2:	39 d1                	cmp    %edx,%ecx
801043c4:	73 ed                	jae    801043b3 <argstr+0x23>
    return -1;
  *pp = (char*)addr;
801043c6:	8b 55 0c             	mov    0xc(%ebp),%edx
801043c9:	89 c8                	mov    %ecx,%eax
801043cb:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801043cd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801043d4:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801043d6:	39 d1                	cmp    %edx,%ecx
801043d8:	73 d9                	jae    801043b3 <argstr+0x23>
    if(*s == 0)
801043da:	80 39 00             	cmpb   $0x0,(%ecx)
801043dd:	75 13                	jne    801043f2 <argstr+0x62>
801043df:	eb 1f                	jmp    80104400 <argstr+0x70>
801043e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043e8:	80 38 00             	cmpb   $0x0,(%eax)
801043eb:	90                   	nop
801043ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043f0:	74 0e                	je     80104400 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801043f2:	83 c0 01             	add    $0x1,%eax
801043f5:	39 c2                	cmp    %eax,%edx
801043f7:	77 ef                	ja     801043e8 <argstr+0x58>
801043f9:	eb b8                	jmp    801043b3 <argstr+0x23>
801043fb:	90                   	nop
801043fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
80104400:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104402:	5d                   	pop    %ebp
80104403:	c3                   	ret    
80104404:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010440a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104410 <syscall>:
[SYS_shmget]  sys_shmget,
};

void
syscall(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	53                   	push   %ebx
80104414:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80104417:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010441e:	8b 5a 18             	mov    0x18(%edx),%ebx
80104421:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104424:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104427:	83 f9 16             	cmp    $0x16,%ecx
8010442a:	77 1c                	ja     80104448 <syscall+0x38>
8010442c:	8b 0c 85 80 70 10 80 	mov    -0x7fef8f80(,%eax,4),%ecx
80104433:	85 c9                	test   %ecx,%ecx
80104435:	74 11                	je     80104448 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80104437:	ff d1                	call   *%ecx
80104439:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
8010443c:	83 c4 14             	add    $0x14,%esp
8010443f:	5b                   	pop    %ebx
80104440:	5d                   	pop    %ebp
80104441:	c3                   	ret    
80104442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104448:	8b 4a 10             	mov    0x10(%edx),%ecx
8010444b:	83 c2 6c             	add    $0x6c,%edx
8010444e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80104452:	89 54 24 08          	mov    %edx,0x8(%esp)
80104456:	c7 04 24 4e 70 10 80 	movl   $0x8010704e,(%esp)
8010445d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80104461:	e8 9a c3 ff ff       	call   80100800 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80104466:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010446c:	8b 40 18             	mov    0x18(%eax),%eax
8010446f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104476:	83 c4 14             	add    $0x14,%esp
80104479:	5b                   	pop    %ebx
8010447a:	5d                   	pop    %ebp
8010447b:	c3                   	ret    
8010447c:	00 00                	add    %al,(%eax)
	...

80104480 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104486:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80104489:	89 5d f8             	mov    %ebx,-0x8(%ebp)
8010448c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010448f:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80104496:	00 
80104497:	89 44 24 04          	mov    %eax,0x4(%esp)
8010449b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801044a2:	e8 99 fe ff ff       	call   80104340 <argptr>
801044a7:	85 c0                	test   %eax,%eax
801044a9:	79 15                	jns    801044c0 <sys_pipe+0x40>
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801044ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801044b0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801044b3:	8b 75 fc             	mov    -0x4(%ebp),%esi
801044b6:	89 ec                	mov    %ebp,%esp
801044b8:	5d                   	pop    %ebp
801044b9:	c3                   	ret    
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801044c0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801044c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801044c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801044ca:	89 04 24             	mov    %eax,(%esp)
801044cd:	e8 3e ee ff ff       	call   80103310 <pipealloc>
801044d2:	85 c0                	test   %eax,%eax
801044d4:	78 d5                	js     801044ab <sys_pipe+0x2b>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801044d6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801044d9:	31 c0                	xor    %eax,%eax
801044db:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801044e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801044e8:	8b 5c 82 28          	mov    0x28(%edx,%eax,4),%ebx
801044ec:	85 db                	test   %ebx,%ebx
801044ee:	74 28                	je     80104518 <sys_pipe+0x98>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801044f0:	83 c0 01             	add    $0x1,%eax
801044f3:	83 f8 10             	cmp    $0x10,%eax
801044f6:	75 f0                	jne    801044e8 <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
801044f8:	89 0c 24             	mov    %ecx,(%esp)
801044fb:	e8 d0 ca ff ff       	call   80100fd0 <fileclose>
    fileclose(wf);
80104500:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104503:	89 04 24             	mov    %eax,(%esp)
80104506:	e8 c5 ca ff ff       	call   80100fd0 <fileclose>
8010450b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
80104510:	eb 9e                	jmp    801044b0 <sys_pipe+0x30>
80104512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104518:	8d 58 08             	lea    0x8(%eax),%ebx
8010451b:	89 4c 9a 08          	mov    %ecx,0x8(%edx,%ebx,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010451f:	8b 75 ec             	mov    -0x14(%ebp),%esi
80104522:	31 d2                	xor    %edx,%edx
80104524:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
8010452b:	90                   	nop
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80104530:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
80104535:	74 19                	je     80104550 <sys_pipe+0xd0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104537:	83 c2 01             	add    $0x1,%edx
8010453a:	83 fa 10             	cmp    $0x10,%edx
8010453d:	75 f1                	jne    80104530 <sys_pipe+0xb0>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
8010453f:	c7 44 99 08 00 00 00 	movl   $0x0,0x8(%ecx,%ebx,4)
80104546:	00 
80104547:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010454a:	eb ac                	jmp    801044f8 <sys_pipe+0x78>
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104550:	89 74 91 28          	mov    %esi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104554:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104557:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80104559:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455c:	89 50 04             	mov    %edx,0x4(%eax)
8010455f:	31 c0                	xor    %eax,%eax
  return 0;
80104561:	e9 4a ff ff ff       	jmp    801044b0 <sys_pipe+0x30>
80104566:	8d 76 00             	lea    0x0(%esi),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	81 ec b8 00 00 00    	sub    $0xb8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104579:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010457c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
8010457f:	89 75 f8             	mov    %esi,-0x8(%ebp)
80104582:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104585:	89 44 24 04          	mov    %eax,0x4(%esp)
80104589:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104590:	e8 fb fd ff ff       	call   80104390 <argstr>
80104595:	85 c0                	test   %eax,%eax
80104597:	79 17                	jns    801045b0 <sys_exec+0x40>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
80104599:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
8010459e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801045a1:	8b 75 f8             	mov    -0x8(%ebp),%esi
801045a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801045a7:	89 ec                	mov    %ebp,%esp
801045a9:	5d                   	pop    %ebp
801045aa:	c3                   	ret    
801045ab:	90                   	nop
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801045b0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801045b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801045b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801045be:	e8 3d fd ff ff       	call   80104300 <argint>
801045c3:	85 c0                	test   %eax,%eax
801045c5:	78 d2                	js     80104599 <sys_exec+0x29>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801045c7:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
801045cd:	31 f6                	xor    %esi,%esi
801045cf:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801045d6:	00 
801045d7:	31 db                	xor    %ebx,%ebx
801045d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801045e0:	00 
801045e1:	89 3c 24             	mov    %edi,(%esp)
801045e4:	e8 07 fa ff ff       	call   80103ff0 <memset>
801045e9:	eb 22                	jmp    8010460d <sys_exec+0x9d>
801045eb:	90                   	nop
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801045f0:	8d 14 b7             	lea    (%edi,%esi,4),%edx
801045f3:	89 54 24 04          	mov    %edx,0x4(%esp)
801045f7:	89 04 24             	mov    %eax,(%esp)
801045fa:	e8 a1 fc ff ff       	call   801042a0 <fetchstr>
801045ff:	85 c0                	test   %eax,%eax
80104601:	78 96                	js     80104599 <sys_exec+0x29>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80104603:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80104606:	83 fb 20             	cmp    $0x20,%ebx

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80104609:	89 de                	mov    %ebx,%esi
    if(i >= NELEM(argv))
8010460b:	74 8c                	je     80104599 <sys_exec+0x29>
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010460d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80104610:	89 44 24 04          	mov    %eax,0x4(%esp)
80104614:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
8010461b:	03 45 e0             	add    -0x20(%ebp),%eax
8010461e:	89 04 24             	mov    %eax,(%esp)
80104621:	e8 3a fc ff ff       	call   80104260 <fetchint>
80104626:	85 c0                	test   %eax,%eax
80104628:	0f 88 6b ff ff ff    	js     80104599 <sys_exec+0x29>
      return -1;
    if(uarg == 0){
8010462e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104631:	85 c0                	test   %eax,%eax
80104633:	75 bb                	jne    801045f0 <sys_exec+0x80>
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104638:	c7 84 9d 5c ff ff ff 	movl   $0x0,-0xa4(%ebp,%ebx,4)
8010463f:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104643:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104647:	89 04 24             	mov    %eax,(%esp)
8010464a:	e8 21 c3 ff ff       	call   80100970 <exec>
8010464f:	e9 4a ff ff ff       	jmp    8010459e <sys_exec+0x2e>
80104654:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010465a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104660 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80104667:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010466a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010466e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104675:	e8 16 fd ff ff       	call   80104390 <argstr>
8010467a:	85 c0                	test   %eax,%eax
8010467c:	79 12                	jns    80104690 <sys_chdir+0x30>
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  proc->cwd = ip;
  return 0;
8010467e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104683:	83 c4 24             	add    $0x24,%esp
80104686:	5b                   	pop    %ebx
80104687:	5d                   	pop    %ebp
80104688:	c3                   	ret    
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80104690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104693:	89 04 24             	mov    %eax,(%esp)
80104696:	e8 f5 d7 ff ff       	call   80101e90 <namei>
8010469b:	85 c0                	test   %eax,%eax
8010469d:	89 c3                	mov    %eax,%ebx
8010469f:	74 dd                	je     8010467e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
801046a1:	89 04 24             	mov    %eax,(%esp)
801046a4:	e8 47 d5 ff ff       	call   80101bf0 <ilock>
  if(ip->type != T_DIR){
801046a9:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
801046ae:	75 26                	jne    801046d6 <sys_chdir+0x76>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
801046b0:	89 1c 24             	mov    %ebx,(%esp)
801046b3:	e8 c8 d4 ff ff       	call   80101b80 <iunlock>
  iput(proc->cwd);
801046b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046be:	8b 40 68             	mov    0x68(%eax),%eax
801046c1:	89 04 24             	mov    %eax,(%esp)
801046c4:	e8 77 d2 ff ff       	call   80101940 <iput>
  proc->cwd = ip;
801046c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046cf:	89 58 68             	mov    %ebx,0x68(%eax)
801046d2:	31 c0                	xor    %eax,%eax
  return 0;
801046d4:	eb ad                	jmp    80104683 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801046d6:	89 1c 24             	mov    %ebx,(%esp)
801046d9:	e8 f2 d4 ff ff       	call   80101bd0 <iunlockput>
801046de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
801046e3:	eb 9e                	jmp    80104683 <sys_chdir+0x23>
801046e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046f0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	83 ec 58             	sub    $0x58,%esp
801046f6:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
801046f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046fc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801046ff:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104702:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104705:	31 db                	xor    %ebx,%ebx
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104707:	89 7d fc             	mov    %edi,-0x4(%ebp)
8010470a:	89 d7                	mov    %edx,%edi
8010470c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010470f:	89 74 24 04          	mov    %esi,0x4(%esp)
80104713:	89 04 24             	mov    %eax,(%esp)
80104716:	e8 55 d7 ff ff       	call   80101e70 <nameiparent>
8010471b:	85 c0                	test   %eax,%eax
8010471d:	74 47                	je     80104766 <create+0x76>
    return 0;
  ilock(dp);
8010471f:	89 04 24             	mov    %eax,(%esp)
80104722:	89 45 bc             	mov    %eax,-0x44(%ebp)
80104725:	e8 c6 d4 ff ff       	call   80101bf0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010472a:	8b 55 bc             	mov    -0x44(%ebp),%edx
8010472d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104730:	89 44 24 08          	mov    %eax,0x8(%esp)
80104734:	89 74 24 04          	mov    %esi,0x4(%esp)
80104738:	89 14 24             	mov    %edx,(%esp)
8010473b:	e8 80 d0 ff ff       	call   801017c0 <dirlookup>
80104740:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104743:	85 c0                	test   %eax,%eax
80104745:	89 c3                	mov    %eax,%ebx
80104747:	74 4f                	je     80104798 <create+0xa8>
    iunlockput(dp);
80104749:	89 14 24             	mov    %edx,(%esp)
8010474c:	e8 7f d4 ff ff       	call   80101bd0 <iunlockput>
    ilock(ip);
80104751:	89 1c 24             	mov    %ebx,(%esp)
80104754:	e8 97 d4 ff ff       	call   80101bf0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104759:	66 83 ff 02          	cmp    $0x2,%di
8010475d:	75 19                	jne    80104778 <create+0x88>
8010475f:	66 83 7b 10 02       	cmpw   $0x2,0x10(%ebx)
80104764:	75 12                	jne    80104778 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104766:	89 d8                	mov    %ebx,%eax
80104768:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010476b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010476e:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104771:	89 ec                	mov    %ebp,%esp
80104773:	5d                   	pop    %ebp
80104774:	c3                   	ret    
80104775:	8d 76 00             	lea    0x0(%esi),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104778:	89 1c 24             	mov    %ebx,(%esp)
8010477b:	31 db                	xor    %ebx,%ebx
8010477d:	e8 4e d4 ff ff       	call   80101bd0 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104782:	89 d8                	mov    %ebx,%eax
80104784:	8b 75 f8             	mov    -0x8(%ebp),%esi
80104787:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010478a:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010478d:	89 ec                	mov    %ebp,%esp
8010478f:	5d                   	pop    %ebp
80104790:	c3                   	ret    
80104791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104798:	0f bf c7             	movswl %di,%eax
8010479b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010479f:	8b 02                	mov    (%edx),%eax
801047a1:	89 55 bc             	mov    %edx,-0x44(%ebp)
801047a4:	89 04 24             	mov    %eax,(%esp)
801047a7:	e8 c4 d0 ff ff       	call   80101870 <ialloc>
801047ac:	8b 55 bc             	mov    -0x44(%ebp),%edx
801047af:	85 c0                	test   %eax,%eax
801047b1:	89 c3                	mov    %eax,%ebx
801047b3:	0f 84 cb 00 00 00    	je     80104884 <create+0x194>
    panic("create: ialloc");

  ilock(ip);
801047b9:	89 55 bc             	mov    %edx,-0x44(%ebp)
801047bc:	89 04 24             	mov    %eax,(%esp)
801047bf:	e8 2c d4 ff ff       	call   80101bf0 <ilock>
  ip->major = major;
801047c4:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
801047c8:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
801047cc:	0f b7 4d c0          	movzwl -0x40(%ebp),%ecx
  ip->nlink = 1;
801047d0:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
801047d6:	66 89 4b 14          	mov    %cx,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
801047da:	89 1c 24             	mov    %ebx,(%esp)
801047dd:	e8 3e ca ff ff       	call   80101220 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801047e2:	66 83 ff 01          	cmp    $0x1,%di
801047e6:	8b 55 bc             	mov    -0x44(%ebp),%edx
801047e9:	74 3d                	je     80104828 <create+0x138>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801047eb:	8b 43 04             	mov    0x4(%ebx),%eax
801047ee:	89 14 24             	mov    %edx,(%esp)
801047f1:	89 55 bc             	mov    %edx,-0x44(%ebp)
801047f4:	89 74 24 04          	mov    %esi,0x4(%esp)
801047f8:	89 44 24 08          	mov    %eax,0x8(%esp)
801047fc:	e8 8f d2 ff ff       	call   80101a90 <dirlink>
80104801:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104804:	85 c0                	test   %eax,%eax
80104806:	0f 88 84 00 00 00    	js     80104890 <create+0x1a0>
    panic("create: dirlink");

  iunlockput(dp);
8010480c:	89 14 24             	mov    %edx,(%esp)
8010480f:	e8 bc d3 ff ff       	call   80101bd0 <iunlockput>

  return ip;
}
80104814:	89 d8                	mov    %ebx,%eax
80104816:	8b 75 f8             	mov    -0x8(%ebp),%esi
80104819:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010481c:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010481f:	89 ec                	mov    %ebp,%esp
80104821:	5d                   	pop    %ebp
80104822:	c3                   	ret    
80104823:	90                   	nop
80104824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104828:	66 83 42 16 01       	addw   $0x1,0x16(%edx)
    iupdate(dp);
8010482d:	89 14 24             	mov    %edx,(%esp)
80104830:	89 55 bc             	mov    %edx,-0x44(%ebp)
80104833:	e8 e8 c9 ff ff       	call   80101220 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104838:	8b 43 04             	mov    0x4(%ebx),%eax
8010483b:	c7 44 24 04 f0 70 10 	movl   $0x801070f0,0x4(%esp)
80104842:	80 
80104843:	89 1c 24             	mov    %ebx,(%esp)
80104846:	89 44 24 08          	mov    %eax,0x8(%esp)
8010484a:	e8 41 d2 ff ff       	call   80101a90 <dirlink>
8010484f:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104852:	85 c0                	test   %eax,%eax
80104854:	78 22                	js     80104878 <create+0x188>
80104856:	8b 42 04             	mov    0x4(%edx),%eax
80104859:	c7 44 24 04 ef 70 10 	movl   $0x801070ef,0x4(%esp)
80104860:	80 
80104861:	89 1c 24             	mov    %ebx,(%esp)
80104864:	89 44 24 08          	mov    %eax,0x8(%esp)
80104868:	e8 23 d2 ff ff       	call   80101a90 <dirlink>
8010486d:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104870:	85 c0                	test   %eax,%eax
80104872:	0f 89 73 ff ff ff    	jns    801047eb <create+0xfb>
      panic("create dots");
80104878:	c7 04 24 f2 70 10 80 	movl   $0x801070f2,(%esp)
8010487f:	e8 fc be ff ff       	call   80100780 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104884:	c7 04 24 e0 70 10 80 	movl   $0x801070e0,(%esp)
8010488b:	e8 f0 be ff ff       	call   80100780 <panic>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104890:	c7 04 24 fe 70 10 80 	movl   $0x801070fe,(%esp)
80104897:	e8 e4 be ff ff       	call   80100780 <panic>
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048a0 <sys_mknod>:
  return 0;
}

int
sys_mknod(void)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
801048a6:	e8 65 e1 ff ff       	call   80102a10 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
801048ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801048b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048b9:	e8 d2 fa ff ff       	call   80104390 <argstr>
801048be:	85 c0                	test   %eax,%eax
801048c0:	78 5e                	js     80104920 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801048c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801048c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801048c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801048d0:	e8 2b fa ff ff       	call   80104300 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
801048d5:	85 c0                	test   %eax,%eax
801048d7:	78 47                	js     80104920 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801048d9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801048dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801048e0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801048e7:	e8 14 fa ff ff       	call   80104300 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
801048ec:	85 c0                	test   %eax,%eax
801048ee:	78 30                	js     80104920 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801048f0:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
801048f4:	ba 03 00 00 00       	mov    $0x3,%edx
801048f9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801048fd:	89 04 24             	mov    %eax,(%esp)
80104900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104903:	e8 e8 fd ff ff       	call   801046f0 <create>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80104908:	85 c0                	test   %eax,%eax
8010490a:	74 14                	je     80104920 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
    return -1;
  }
  iunlockput(ip);
8010490c:	89 04 24             	mov    %eax,(%esp)
8010490f:	e8 bc d2 ff ff       	call   80101bd0 <iunlockput>
  commit_trans();
80104914:	e8 97 e0 ff ff       	call   801029b0 <commit_trans>
80104919:	31 c0                	xor    %eax,%eax
  return 0;
}
8010491b:	c9                   	leave  
8010491c:	c3                   	ret    
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80104920:	e8 8b e0 ff ff       	call   801029b0 <commit_trans>
80104925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  }
  iunlockput(ip);
  commit_trans();
  return 0;
}
8010492a:	c9                   	leave  
8010492b:	c3                   	ret    
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104930 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80104936:	e8 d5 e0 ff ff       	call   80102a10 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010493b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010493e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104942:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104949:	e8 42 fa ff ff       	call   80104390 <argstr>
8010494e:	85 c0                	test   %eax,%eax
80104950:	78 2e                	js     80104980 <sys_mkdir+0x50>
80104952:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104955:	31 c9                	xor    %ecx,%ecx
80104957:	ba 01 00 00 00       	mov    $0x1,%edx
8010495c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104963:	e8 88 fd ff ff       	call   801046f0 <create>
80104968:	85 c0                	test   %eax,%eax
8010496a:	74 14                	je     80104980 <sys_mkdir+0x50>
    commit_trans();
    return -1;
  }
  iunlockput(ip);
8010496c:	89 04 24             	mov    %eax,(%esp)
8010496f:	e8 5c d2 ff ff       	call   80101bd0 <iunlockput>
  commit_trans();
80104974:	e8 37 e0 ff ff       	call   801029b0 <commit_trans>
80104979:	31 c0                	xor    %eax,%eax
  return 0;
}
8010497b:	c9                   	leave  
8010497c:	c3                   	ret    
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_trans();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    commit_trans();
80104980:	e8 2b e0 ff ff       	call   801029b0 <commit_trans>
80104985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  }
  iunlockput(ip);
  commit_trans();
  return 0;
}
8010498a:	c9                   	leave  
8010498b:	c3                   	ret    
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104990 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	83 ec 48             	sub    $0x48,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104996:	8d 45 e0             	lea    -0x20(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104999:	89 5d f4             	mov    %ebx,-0xc(%ebp)
8010499c:	89 75 f8             	mov    %esi,-0x8(%ebp)
8010499f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801049a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801049a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049ad:	e8 de f9 ff ff       	call   80104390 <argstr>
801049b2:	85 c0                	test   %eax,%eax
801049b4:	79 12                	jns    801049c8 <sys_link+0x38>
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  commit_trans();
  return -1;
801049b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049bb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801049be:	8b 75 f8             	mov    -0x8(%ebp),%esi
801049c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
801049c4:	89 ec                	mov    %ebp,%esp
801049c6:	5d                   	pop    %ebp
801049c7:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801049c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801049cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801049cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801049d6:	e8 b5 f9 ff ff       	call   80104390 <argstr>
801049db:	85 c0                	test   %eax,%eax
801049dd:	78 d7                	js     801049b6 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
801049df:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049e2:	89 04 24             	mov    %eax,(%esp)
801049e5:	e8 a6 d4 ff ff       	call   80101e90 <namei>
801049ea:	85 c0                	test   %eax,%eax
801049ec:	89 c3                	mov    %eax,%ebx
801049ee:	74 c6                	je     801049b6 <sys_link+0x26>
    return -1;

  begin_trans();
801049f0:	e8 1b e0 ff ff       	call   80102a10 <begin_trans>

  ilock(ip);
801049f5:	89 1c 24             	mov    %ebx,(%esp)
801049f8:	e8 f3 d1 ff ff       	call   80101bf0 <ilock>
  if(ip->type == T_DIR){
801049fd:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104a02:	0f 84 8b 00 00 00    	je     80104a93 <sys_link+0x103>
    iunlockput(ip);
    commit_trans();
    return -1;
  }

  ip->nlink++;
80104a08:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104a0d:	8d 7d d2             	lea    -0x2e(%ebp),%edi
    commit_trans();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104a10:	89 1c 24             	mov    %ebx,(%esp)
80104a13:	e8 08 c8 ff ff       	call   80101220 <iupdate>
  iunlock(ip);
80104a18:	89 1c 24             	mov    %ebx,(%esp)
80104a1b:	e8 60 d1 ff ff       	call   80101b80 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104a23:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104a27:	89 04 24             	mov    %eax,(%esp)
80104a2a:	e8 41 d4 ff ff       	call   80101e70 <nameiparent>
80104a2f:	85 c0                	test   %eax,%eax
80104a31:	89 c6                	mov    %eax,%esi
80104a33:	74 49                	je     80104a7e <sys_link+0xee>
    goto bad;
  ilock(dp);
80104a35:	89 04 24             	mov    %eax,(%esp)
80104a38:	e8 b3 d1 ff ff       	call   80101bf0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104a3d:	8b 06                	mov    (%esi),%eax
80104a3f:	3b 03                	cmp    (%ebx),%eax
80104a41:	75 33                	jne    80104a76 <sys_link+0xe6>
80104a43:	8b 43 04             	mov    0x4(%ebx),%eax
80104a46:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104a4a:	89 34 24             	mov    %esi,(%esp)
80104a4d:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a51:	e8 3a d0 ff ff       	call   80101a90 <dirlink>
80104a56:	85 c0                	test   %eax,%eax
80104a58:	78 1c                	js     80104a76 <sys_link+0xe6>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104a5a:	89 34 24             	mov    %esi,(%esp)
80104a5d:	e8 6e d1 ff ff       	call   80101bd0 <iunlockput>
  iput(ip);
80104a62:	89 1c 24             	mov    %ebx,(%esp)
80104a65:	e8 d6 ce ff ff       	call   80101940 <iput>

  commit_trans();
80104a6a:	e8 41 df ff ff       	call   801029b0 <commit_trans>
80104a6f:	31 c0                	xor    %eax,%eax

  return 0;
80104a71:	e9 45 ff ff ff       	jmp    801049bb <sys_link+0x2b>

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104a76:	89 34 24             	mov    %esi,(%esp)
80104a79:	e8 52 d1 ff ff       	call   80101bd0 <iunlockput>
  commit_trans();

  return 0;

bad:
  ilock(ip);
80104a7e:	89 1c 24             	mov    %ebx,(%esp)
80104a81:	e8 6a d1 ff ff       	call   80101bf0 <ilock>
  ip->nlink--;
80104a86:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80104a8b:	89 1c 24             	mov    %ebx,(%esp)
80104a8e:	e8 8d c7 ff ff       	call   80101220 <iupdate>
  iunlockput(ip);
80104a93:	89 1c 24             	mov    %ebx,(%esp)
80104a96:	e8 35 d1 ff ff       	call   80101bd0 <iunlockput>
  commit_trans();
80104a9b:	e8 10 df ff ff       	call   801029b0 <commit_trans>
80104aa0:	83 c8 ff             	or     $0xffffffff,%eax
  return -1;
80104aa3:	e9 13 ff ff ff       	jmp    801049bb <sys_link+0x2b>
80104aa8:	90                   	nop
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ab0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104ab6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80104ab9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80104abc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104abf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ac3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104aca:	e8 c1 f8 ff ff       	call   80104390 <argstr>
80104acf:	85 c0                	test   %eax,%eax
80104ad1:	79 15                	jns    80104ae8 <sys_open+0x38>

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
80104ad3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104ad8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104adb:	8b 75 fc             	mov    -0x4(%ebp),%esi
80104ade:	89 ec                	mov    %ebp,%esp
80104ae0:	5d                   	pop    %ebp
80104ae1:	c3                   	ret    
80104ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104ae8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104af6:	e8 05 f8 ff ff       	call   80104300 <argint>
80104afb:	85 c0                	test   %eax,%eax
80104afd:	78 d4                	js     80104ad3 <sys_open+0x23>
    return -1;
  if(omode & O_CREATE){
80104aff:	f6 45 f1 02          	testb  $0x2,-0xf(%ebp)
80104b03:	74 6b                	je     80104b70 <sys_open+0xc0>
    begin_trans();
80104b05:	e8 06 df ff ff       	call   80102a10 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80104b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0d:	31 c9                	xor    %ecx,%ecx
80104b0f:	ba 02 00 00 00       	mov    $0x2,%edx
80104b14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104b1b:	e8 d0 fb ff ff       	call   801046f0 <create>
80104b20:	89 c3                	mov    %eax,%ebx
    commit_trans();
80104b22:	e8 89 de ff ff       	call   801029b0 <commit_trans>
    if(ip == 0)
80104b27:	85 db                	test   %ebx,%ebx
80104b29:	74 a8                	je     80104ad3 <sys_open+0x23>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104b2b:	e8 20 c4 ff ff       	call   80100f50 <filealloc>
80104b30:	85 c0                	test   %eax,%eax
80104b32:	89 c6                	mov    %eax,%esi
80104b34:	74 22                	je     80104b58 <sys_open+0xa8>
80104b36:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b3d:	31 c0                	xor    %eax,%eax
80104b3f:	90                   	nop
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80104b40:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
80104b44:	85 c9                	test   %ecx,%ecx
80104b46:	74 58                	je     80104ba0 <sys_open+0xf0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104b48:	83 c0 01             	add    $0x1,%eax
80104b4b:	83 f8 10             	cmp    $0x10,%eax
80104b4e:	75 f0                	jne    80104b40 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104b50:	89 34 24             	mov    %esi,(%esp)
80104b53:	e8 78 c4 ff ff       	call   80100fd0 <fileclose>
    iunlockput(ip);
80104b58:	89 1c 24             	mov    %ebx,(%esp)
80104b5b:	e8 70 d0 ff ff       	call   80101bd0 <iunlockput>
80104b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
80104b65:	e9 6e ff ff ff       	jmp    80104ad8 <sys_open+0x28>
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ip = create(path, T_FILE, 0, 0);
    commit_trans();
    if(ip == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
80104b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b73:	89 04 24             	mov    %eax,(%esp)
80104b76:	e8 15 d3 ff ff       	call   80101e90 <namei>
80104b7b:	85 c0                	test   %eax,%eax
80104b7d:	89 c3                	mov    %eax,%ebx
80104b7f:	0f 84 4e ff ff ff    	je     80104ad3 <sys_open+0x23>
      return -1;
    ilock(ip);
80104b85:	89 04 24             	mov    %eax,(%esp)
80104b88:	e8 63 d0 ff ff       	call   80101bf0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104b8d:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104b92:	75 97                	jne    80104b2b <sys_open+0x7b>
80104b94:	8b 75 f0             	mov    -0x10(%ebp),%esi
80104b97:	85 f6                	test   %esi,%esi
80104b99:	74 90                	je     80104b2b <sys_open+0x7b>
80104b9b:	eb bb                	jmp    80104b58 <sys_open+0xa8>
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104ba0:	89 74 82 28          	mov    %esi,0x28(%edx,%eax,4)
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
80104ba4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104ba7:	89 1c 24             	mov    %ebx,(%esp)
80104baa:	e8 d1 cf ff ff       	call   80101b80 <iunlock>

  f->type = FD_INODE;
80104baf:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
80104bb5:	89 5e 10             	mov    %ebx,0x10(%esi)
  f->off = 0;
80104bb8:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80104bbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104bc2:	83 f2 01             	xor    $0x1,%edx
80104bc5:	83 e2 01             	and    $0x1,%edx
80104bc8:	88 56 08             	mov    %dl,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104bcb:	f6 45 f0 03          	testb  $0x3,-0x10(%ebp)
80104bcf:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
80104bd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104bd6:	e9 fd fe ff ff       	jmp    80104ad8 <sys_open+0x28>
80104bdb:	90                   	nop
80104bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104be0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	83 ec 78             	sub    $0x78,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104be6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104be9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80104bec:	89 75 f8             	mov    %esi,-0x8(%ebp)
80104bef:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104bf2:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bf6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104bfd:	e8 8e f7 ff ff       	call   80104390 <argstr>
80104c02:	85 c0                	test   %eax,%eax
80104c04:	79 12                	jns    80104c18 <sys_unlink+0x38>
  return 0;

bad:
  iunlockput(dp);
  commit_trans();
  return -1;
80104c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c0b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80104c0e:	8b 75 f8             	mov    -0x8(%ebp),%esi
80104c11:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104c14:	89 ec                	mov    %ebp,%esp
80104c16:	5d                   	pop    %ebp
80104c17:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
80104c18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104c1b:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
80104c1e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c22:	89 04 24             	mov    %eax,(%esp)
80104c25:	e8 46 d2 ff ff       	call   80101e70 <nameiparent>
80104c2a:	85 c0                	test   %eax,%eax
80104c2c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
80104c2f:	74 d5                	je     80104c06 <sys_unlink+0x26>
    return -1;

  begin_trans();
80104c31:	e8 da dd ff ff       	call   80102a10 <begin_trans>

  ilock(dp);
80104c36:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104c39:	89 04 24             	mov    %eax,(%esp)
80104c3c:	e8 af cf ff ff       	call   80101bf0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104c41:	c7 44 24 04 f0 70 10 	movl   $0x801070f0,0x4(%esp)
80104c48:	80 
80104c49:	89 1c 24             	mov    %ebx,(%esp)
80104c4c:	e8 9f c5 ff ff       	call   801011f0 <namecmp>
80104c51:	85 c0                	test   %eax,%eax
80104c53:	0f 84 97 00 00 00    	je     80104cf0 <sys_unlink+0x110>
80104c59:	c7 44 24 04 ef 70 10 	movl   $0x801070ef,0x4(%esp)
80104c60:	80 
80104c61:	89 1c 24             	mov    %ebx,(%esp)
80104c64:	e8 87 c5 ff ff       	call   801011f0 <namecmp>
80104c69:	85 c0                	test   %eax,%eax
80104c6b:	0f 84 7f 00 00 00    	je     80104cf0 <sys_unlink+0x110>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104c71:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104c74:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c78:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104c7b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c7f:	89 04 24             	mov    %eax,(%esp)
80104c82:	e8 39 cb ff ff       	call   801017c0 <dirlookup>
80104c87:	85 c0                	test   %eax,%eax
80104c89:	89 c6                	mov    %eax,%esi
80104c8b:	74 63                	je     80104cf0 <sys_unlink+0x110>
    goto bad;
  ilock(ip);
80104c8d:	89 04 24             	mov    %eax,(%esp)
80104c90:	e8 5b cf ff ff       	call   80101bf0 <ilock>

  if(ip->nlink < 1)
80104c95:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
80104c9a:	0f 8e 0b 01 00 00    	jle    80104dab <sys_unlink+0x1cb>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104ca0:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
80104ca5:	75 69                	jne    80104d10 <sys_unlink+0x130>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104ca7:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
80104cab:	76 63                	jbe    80104d10 <sys_unlink+0x130>
80104cad:	8d 7d b2             	lea    -0x4e(%ebp),%edi
80104cb0:	bb 20 00 00 00       	mov    $0x20,%ebx
80104cb5:	eb 09                	jmp    80104cc0 <sys_unlink+0xe0>
80104cb7:	90                   	nop
80104cb8:	83 c3 10             	add    $0x10,%ebx
80104cbb:	3b 5e 18             	cmp    0x18(%esi),%ebx
80104cbe:	73 50                	jae    80104d10 <sys_unlink+0x130>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104cc0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104cc7:	00 
80104cc8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80104ccc:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104cd0:	89 34 24             	mov    %esi,(%esp)
80104cd3:	e8 d8 c9 ff ff       	call   801016b0 <readi>
80104cd8:	83 f8 10             	cmp    $0x10,%eax
80104cdb:	0f 85 b2 00 00 00    	jne    80104d93 <sys_unlink+0x1b3>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104ce1:	66 83 7d b2 00       	cmpw   $0x0,-0x4e(%ebp)
80104ce6:	74 d0                	je     80104cb8 <sys_unlink+0xd8>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104ce8:	89 34 24             	mov    %esi,(%esp)
80104ceb:	e8 e0 ce ff ff       	call   80101bd0 <iunlockput>
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
80104cf0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104cf3:	89 04 24             	mov    %eax,(%esp)
80104cf6:	e8 d5 ce ff ff       	call   80101bd0 <iunlockput>
  commit_trans();
80104cfb:	e8 b0 dc ff ff       	call   801029b0 <commit_trans>
80104d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
80104d05:	e9 01 ff ff ff       	jmp    80104c0b <sys_unlink+0x2b>
80104d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104d10:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
80104d13:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104d1a:	00 
80104d1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104d22:	00 
80104d23:	89 1c 24             	mov    %ebx,(%esp)
80104d26:	e8 c5 f2 ff ff       	call   80103ff0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d2e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104d35:	00 
80104d36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d3a:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d3e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104d41:	89 04 24             	mov    %eax,(%esp)
80104d44:	e8 47 c8 ff ff       	call   80101590 <writei>
80104d49:	83 f8 10             	cmp    $0x10,%eax
80104d4c:	75 51                	jne    80104d9f <sys_unlink+0x1bf>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104d4e:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
80104d53:	74 2c                	je     80104d81 <sys_unlink+0x1a1>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104d55:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104d58:	89 04 24             	mov    %eax,(%esp)
80104d5b:	e8 70 ce ff ff       	call   80101bd0 <iunlockput>

  ip->nlink--;
80104d60:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
80104d65:	89 34 24             	mov    %esi,(%esp)
80104d68:	e8 b3 c4 ff ff       	call   80101220 <iupdate>
  iunlockput(ip);
80104d6d:	89 34 24             	mov    %esi,(%esp)
80104d70:	e8 5b ce ff ff       	call   80101bd0 <iunlockput>

  commit_trans();
80104d75:	e8 36 dc ff ff       	call   801029b0 <commit_trans>
80104d7a:	31 c0                	xor    %eax,%eax

  return 0;
80104d7c:	e9 8a fe ff ff       	jmp    80104c0b <sys_unlink+0x2b>

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104d81:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104d84:	66 83 68 16 01       	subw   $0x1,0x16(%eax)
    iupdate(dp);
80104d89:	89 04 24             	mov    %eax,(%esp)
80104d8c:	e8 8f c4 ff ff       	call   80101220 <iupdate>
80104d91:	eb c2                	jmp    80104d55 <sys_unlink+0x175>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104d93:	c7 04 24 20 71 10 80 	movl   $0x80107120,(%esp)
80104d9a:	e8 e1 b9 ff ff       	call   80100780 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104d9f:	c7 04 24 32 71 10 80 	movl   $0x80107132,(%esp)
80104da6:	e8 d5 b9 ff ff       	call   80100780 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104dab:	c7 04 24 0e 71 10 80 	movl   $0x8010710e,(%esp)
80104db2:	e8 c9 b9 ff ff       	call   80100780 <panic>
80104db7:	89 f6                	mov    %esi,%esi
80104db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dc0 <argfd.clone.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	83 ec 28             	sub    $0x28,%esp
80104dc6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80104dc9:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104dcb:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104dce:	89 75 fc             	mov    %esi,-0x4(%ebp)
80104dd1:	89 d6                	mov    %edx,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104dde:	e8 1d f5 ff ff       	call   80104300 <argint>
80104de3:	85 c0                	test   %eax,%eax
80104de5:	79 11                	jns    80104df8 <argfd.clone.0+0x38>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
80104de7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
80104dec:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104def:	8b 75 fc             	mov    -0x4(%ebp),%esi
80104df2:	89 ec                	mov    %ebp,%esp
80104df4:	5d                   	pop    %ebp
80104df5:	c3                   	ret    
80104df6:	66 90                	xchg   %ax,%ax
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dfb:	83 f8 0f             	cmp    $0xf,%eax
80104dfe:	77 e7                	ja     80104de7 <argfd.clone.0+0x27>
80104e00:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e07:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
80104e0b:	85 d2                	test   %edx,%edx
80104e0d:	74 d8                	je     80104de7 <argfd.clone.0+0x27>
    return -1;
  if(pfd)
80104e0f:	85 db                	test   %ebx,%ebx
80104e11:	74 02                	je     80104e15 <argfd.clone.0+0x55>
    *pfd = fd;
80104e13:	89 03                	mov    %eax,(%ebx)
  if(pf)
80104e15:	31 c0                	xor    %eax,%eax
80104e17:	85 f6                	test   %esi,%esi
80104e19:	74 d1                	je     80104dec <argfd.clone.0+0x2c>
    *pf = f;
80104e1b:	89 16                	mov    %edx,(%esi)
80104e1d:	eb cd                	jmp    80104dec <argfd.clone.0+0x2c>
80104e1f:	90                   	nop

80104e20 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104e20:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80104e21:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104e23:	89 e5                	mov    %esp,%ebp
80104e25:	53                   	push   %ebx
80104e26:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80104e29:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e2c:	e8 8f ff ff ff       	call   80104dc0 <argfd.clone.0>
80104e31:	85 c0                	test   %eax,%eax
80104e33:	79 13                	jns    80104e48 <sys_dup+0x28>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104e35:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104e3a:	89 d8                	mov    %ebx,%eax
80104e3c:	83 c4 24             	add    $0x24,%esp
80104e3f:	5b                   	pop    %ebx
80104e40:	5d                   	pop    %ebp
80104e41:	c3                   	ret    
80104e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104e48:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e4b:	31 db                	xor    %ebx,%ebx
80104e4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e53:	eb 0b                	jmp    80104e60 <sys_dup+0x40>
80104e55:	8d 76 00             	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104e58:	83 c3 01             	add    $0x1,%ebx
80104e5b:	83 fb 10             	cmp    $0x10,%ebx
80104e5e:	74 d5                	je     80104e35 <sys_dup+0x15>
    if(proc->ofile[fd] == 0){
80104e60:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104e64:	85 c9                	test   %ecx,%ecx
80104e66:	75 f0                	jne    80104e58 <sys_dup+0x38>
      proc->ofile[fd] = f;
80104e68:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e6f:	89 04 24             	mov    %eax,(%esp)
80104e72:	e8 89 c0 ff ff       	call   80100f00 <filedup>
  return fd;
80104e77:	eb c1                	jmp    80104e3a <sys_dup+0x1a>
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e80 <sys_read>:
}

int
sys_read(void)
{
80104e80:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e81:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104e83:	89 e5                	mov    %esp,%ebp
80104e85:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e88:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e8b:	e8 30 ff ff ff       	call   80104dc0 <argfd.clone.0>
80104e90:	85 c0                	test   %eax,%eax
80104e92:	79 0c                	jns    80104ea0 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
80104e94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e99:	c9                   	leave  
80104e9a:	c3                   	ret    
80104e9b:	90                   	nop
80104e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ea0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ea3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ea7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104eae:	e8 4d f4 ff ff       	call   80104300 <argint>
80104eb3:	85 c0                	test   %eax,%eax
80104eb5:	78 dd                	js     80104e94 <sys_read+0x14>
80104eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ec1:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ec5:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104ec8:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ecc:	e8 6f f4 ff ff       	call   80104340 <argptr>
80104ed1:	85 c0                	test   %eax,%eax
80104ed3:	78 bf                	js     80104e94 <sys_read+0x14>
    return -1;
  return fileread(f, p, n);
80104ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ed8:	89 44 24 08          	mov    %eax,0x8(%esp)
80104edc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104edf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee6:	89 04 24             	mov    %eax,(%esp)
80104ee9:	e8 02 bf ff ff       	call   80100df0 <fileread>
}
80104eee:	c9                   	leave  
80104eef:	c3                   	ret    

80104ef0 <sys_write>:

int
sys_write(void)
{
80104ef0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ef1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104ef3:	89 e5                	mov    %esp,%ebp
80104ef5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ef8:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104efb:	e8 c0 fe ff ff       	call   80104dc0 <argfd.clone.0>
80104f00:	85 c0                	test   %eax,%eax
80104f02:	79 0c                	jns    80104f10 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
80104f04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f09:	c9                   	leave  
80104f0a:	c3                   	ret    
80104f0b:	90                   	nop
80104f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f10:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f13:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104f1e:	e8 dd f3 ff ff       	call   80104300 <argint>
80104f23:	85 c0                	test   %eax,%eax
80104f25:	78 dd                	js     80104f04 <sys_write+0x14>
80104f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f31:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f35:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104f38:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f3c:	e8 ff f3 ff ff       	call   80104340 <argptr>
80104f41:	85 c0                	test   %eax,%eax
80104f43:	78 bf                	js     80104f04 <sys_write+0x14>
    return -1;
  return filewrite(f, p, n);
80104f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f48:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f56:	89 04 24             	mov    %eax,(%esp)
80104f59:	e8 72 bd ff ff       	call   80100cd0 <filewrite>
}
80104f5e:	c9                   	leave  
80104f5f:	c3                   	ret    

80104f60 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
80104f60:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f61:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104f63:	89 e5                	mov    %esp,%ebp
80104f65:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f68:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f6b:	e8 50 fe ff ff       	call   80104dc0 <argfd.clone.0>
80104f70:	85 c0                	test   %eax,%eax
80104f72:	79 0c                	jns    80104f80 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
80104f74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f79:	c9                   	leave  
80104f7a:	c3                   	ret    
80104f7b:	90                   	nop
80104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f80:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f83:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104f8a:	00 
80104f8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f96:	e8 a5 f3 ff ff       	call   80104340 <argptr>
80104f9b:	85 c0                	test   %eax,%eax
80104f9d:	78 d5                	js     80104f74 <sys_fstat+0x14>
    return -1;
  return filestat(f, st);
80104f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fa2:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa9:	89 04 24             	mov    %eax,(%esp)
80104fac:	e8 ff be ff ff       	call   80100eb0 <filestat>
}
80104fb1:	c9                   	leave  
80104fb2:	c3                   	ret    
80104fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fc0 <sys_close>:
  return filewrite(f, p, n);
}

int
sys_close(void)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80104fc6:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104fc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fcc:	e8 ef fd ff ff       	call   80104dc0 <argfd.clone.0>
80104fd1:	89 c2                	mov    %eax,%edx
80104fd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd8:	85 d2                	test   %edx,%edx
80104fda:	78 1e                	js     80104ffa <sys_close+0x3a>
    return -1;
  proc->ofile[fd] = 0;
80104fdc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fe2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fe5:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104fec:	00 
  fileclose(f);
80104fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ff0:	89 04 24             	mov    %eax,(%esp)
80104ff3:	e8 d8 bf ff ff       	call   80100fd0 <fileclose>
80104ff8:	31 c0                	xor    %eax,%eax
  return 0;
}
80104ffa:	c9                   	leave  
80104ffb:	c3                   	ret    
80104ffc:	00 00                	add    %al,(%eax)
	...

80105000 <sys_getpid>:
}

int
sys_getpid(void)
{
  return proc->pid;
80105000:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
80105006:	55                   	push   %ebp
80105007:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
80105009:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
8010500a:	8b 40 10             	mov    0x10(%eax),%eax
}
8010500d:	c3                   	ret    
8010500e:	66 90                	xchg   %ax,%ax

80105010 <sys_shmget>:

}

int
sys_shmget(void)
{
80105010:	55                   	push   %ebp
  return 0;
}
80105011:	31 c0                	xor    %eax,%eax

}

int
sys_shmget(void)
{
80105013:	89 e5                	mov    %esp,%ebp
  return 0;
}
80105015:	5d                   	pop    %ebp
80105016:	c3                   	ret    
80105017:	89 f6                	mov    %esi,%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <sys_gettime>:
  return xticks;
}


int sys_gettime(void)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	53                   	push   %ebx
80105024:	83 ec 24             	sub    $0x24,%esp
  unsigned long *msec;
  unsigned long *sec;
  uint ticks1;

  if((argptr(0,(char**)&msec, sizeof(unsigned long)) < 0) || 
80105027:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010502a:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105031:	00 
80105032:	89 44 24 04          	mov    %eax,0x4(%esp)
80105036:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010503d:	e8 fe f2 ff ff       	call   80104340 <argptr>
80105042:	85 c0                	test   %eax,%eax
80105044:	79 12                	jns    80105058 <sys_gettime+0x38>
  
  //ticks occur every 10ms
  *msec = 10 * (ticks1 % 100);
  *sec = (ticks1 / 100);
  
  return 0;
80105046:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  

}
8010504b:	83 c4 24             	add    $0x24,%esp
8010504e:	5b                   	pop    %ebx
8010504f:	5d                   	pop    %ebp
80105050:	c3                   	ret    
80105051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  unsigned long *msec;
  unsigned long *sec;
  uint ticks1;

  if((argptr(0,(char**)&msec, sizeof(unsigned long)) < 0) || 
     (argptr(1,(char**)&sec, sizeof(unsigned long)) < 0)){
80105058:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010505b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105062:	00 
80105063:	89 44 24 04          	mov    %eax,0x4(%esp)
80105067:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010506e:	e8 cd f2 ff ff       	call   80104340 <argptr>
{
  unsigned long *msec;
  unsigned long *sec;
  uint ticks1;

  if((argptr(0,(char**)&msec, sizeof(unsigned long)) < 0) || 
80105073:	85 c0                	test   %eax,%eax
80105075:	78 cf                	js     80105046 <sys_gettime+0x26>
  }
  
  //assert(msec != NULL);
  //assert(sec != NULL);

  acquire(&tickslock);
80105077:	c7 04 24 e0 0d 11 80 	movl   $0x80110de0,(%esp)
8010507e:	e8 cd ee ff ff       	call   80103f50 <acquire>
  ticks1 = ticks;
80105083:	8b 1d 20 16 11 80    	mov    0x80111620,%ebx
  release(&tickslock);
80105089:	c7 04 24 e0 0d 11 80 	movl   $0x80110de0,(%esp)
80105090:	e8 6b ee ff ff       	call   80103f00 <release>
  
  //ticks occur every 10ms
  *msec = 10 * (ticks1 % 100);
80105095:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010509a:	89 d8                	mov    %ebx,%eax
8010509c:	f7 e2                	mul    %edx
8010509e:	c1 ea 05             	shr    $0x5,%edx
801050a1:	6b c2 64             	imul   $0x64,%edx,%eax
801050a4:	29 c3                	sub    %eax,%ebx
801050a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a9:	8d 0c 9b             	lea    (%ebx,%ebx,4),%ecx
801050ac:	01 c9                	add    %ecx,%ecx
801050ae:	89 08                	mov    %ecx,(%eax)
  *sec = (ticks1 / 100);
801050b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050b3:	89 10                	mov    %edx,(%eax)
801050b5:	31 c0                	xor    %eax,%eax
  
  return 0;
801050b7:	eb 92                	jmp    8010504b <sys_gettime+0x2b>
801050b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801050c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	53                   	push   %ebx
801050c4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;
  
  acquire(&tickslock);
801050c7:	c7 04 24 e0 0d 11 80 	movl   $0x80110de0,(%esp)
801050ce:	e8 7d ee ff ff       	call   80103f50 <acquire>
  xticks = ticks;
801050d3:	8b 1d 20 16 11 80    	mov    0x80111620,%ebx
  release(&tickslock);
801050d9:	c7 04 24 e0 0d 11 80 	movl   $0x80110de0,(%esp)
801050e0:	e8 1b ee ff ff       	call   80103f00 <release>
  return xticks;
}
801050e5:	83 c4 14             	add    $0x14,%esp
801050e8:	89 d8                	mov    %ebx,%eax
801050ea:	5b                   	pop    %ebx
801050eb:	5d                   	pop    %ebp
801050ec:	c3                   	ret    
801050ed:	8d 76 00             	lea    0x0(%esi),%esi

801050f0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	53                   	push   %ebx
801050f4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801050f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801050fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105105:	e8 f6 f1 ff ff       	call   80104300 <argint>
8010510a:	89 c2                	mov    %eax,%edx
8010510c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105111:	85 d2                	test   %edx,%edx
80105113:	78 59                	js     8010516e <sys_sleep+0x7e>
    return -1;
  acquire(&tickslock);
80105115:	c7 04 24 e0 0d 11 80 	movl   $0x80110de0,(%esp)
8010511c:	e8 2f ee ff ff       	call   80103f50 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105121:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105124:	8b 1d 20 16 11 80    	mov    0x80111620,%ebx
  while(ticks - ticks0 < n){
8010512a:	85 d2                	test   %edx,%edx
8010512c:	75 22                	jne    80105150 <sys_sleep+0x60>
8010512e:	eb 48                	jmp    80105178 <sys_sleep+0x88>
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105130:	c7 44 24 04 e0 0d 11 	movl   $0x80110de0,0x4(%esp)
80105137:	80 
80105138:	c7 04 24 20 16 11 80 	movl   $0x80111620,(%esp)
8010513f:	e8 3c e5 ff ff       	call   80103680 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105144:	a1 20 16 11 80       	mov    0x80111620,%eax
80105149:	29 d8                	sub    %ebx,%eax
8010514b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010514e:	73 28                	jae    80105178 <sys_sleep+0x88>
    if(proc->killed){
80105150:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105156:	8b 40 24             	mov    0x24(%eax),%eax
80105159:	85 c0                	test   %eax,%eax
8010515b:	74 d3                	je     80105130 <sys_sleep+0x40>
      release(&tickslock);
8010515d:	c7 04 24 e0 0d 11 80 	movl   $0x80110de0,(%esp)
80105164:	e8 97 ed ff ff       	call   80103f00 <release>
80105169:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010516e:	83 c4 24             	add    $0x24,%esp
80105171:	5b                   	pop    %ebx
80105172:	5d                   	pop    %ebp
80105173:	c3                   	ret    
80105174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105178:	c7 04 24 e0 0d 11 80 	movl   $0x80110de0,(%esp)
8010517f:	e8 7c ed ff ff       	call   80103f00 <release>
  return 0;
}
80105184:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105187:	31 c0                	xor    %eax,%eax
  return 0;
}
80105189:	5b                   	pop    %ebx
8010518a:	5d                   	pop    %ebp
8010518b:	c3                   	ret    
8010518c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105190 <sys_sbrk>:
  return proc->pid;
}

int
sys_sbrk(void)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	53                   	push   %ebx
80105194:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105197:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010519a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010519e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051a5:	e8 56 f1 ff ff       	call   80104300 <argint>
801051aa:	85 c0                	test   %eax,%eax
801051ac:	79 12                	jns    801051c0 <sys_sbrk+0x30>
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
801051ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051b3:	83 c4 24             	add    $0x24,%esp
801051b6:	5b                   	pop    %ebx
801051b7:	5d                   	pop    %ebp
801051b8:	c3                   	ret    
801051b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
801051c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051c6:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801051c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051cb:	89 04 24             	mov    %eax,(%esp)
801051ce:	e8 5d ea ff ff       	call   80103c30 <growproc>
801051d3:	89 c2                	mov    %eax,%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
801051d5:	89 d8                	mov    %ebx,%eax
  if(growproc(n) < 0)
801051d7:	85 d2                	test   %edx,%edx
801051d9:	79 d8                	jns    801051b3 <sys_sbrk+0x23>
801051db:	eb d1                	jmp    801051ae <sys_sbrk+0x1e>
801051dd:	8d 76 00             	lea    0x0(%esi),%esi

801051e0 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801051e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051f4:	e8 07 f1 ff ff       	call   80104300 <argint>
801051f9:	89 c2                	mov    %eax,%edx
801051fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105200:	85 d2                	test   %edx,%edx
80105202:	78 0b                	js     8010520f <sys_kill+0x2f>
    return -1;
  return kill(pid);
80105204:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105207:	89 04 24             	mov    %eax,(%esp)
8010520a:	e8 b1 e2 ff ff       	call   801034c0 <kill>
}
8010520f:	c9                   	leave  
80105210:	c3                   	ret    
80105211:	eb 0d                	jmp    80105220 <sys_wait>
80105213:	90                   	nop
80105214:	90                   	nop
80105215:	90                   	nop
80105216:	90                   	nop
80105217:	90                   	nop
80105218:	90                   	nop
80105219:	90                   	nop
8010521a:	90                   	nop
8010521b:	90                   	nop
8010521c:	90                   	nop
8010521d:	90                   	nop
8010521e:	90                   	nop
8010521f:	90                   	nop

80105220 <sys_wait>:
  return 0;  // not reached
}

int
sys_wait(void)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
80105226:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
80105227:	e9 04 e6 ff ff       	jmp    80103830 <wait>
8010522c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105230 <sys_exit>:
  return fork();
}

int
sys_exit(void)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	83 ec 08             	sub    $0x8,%esp
  exit();
80105236:	e8 e5 e6 ff ff       	call   80103920 <exit>
  return 0;  // not reached
}
8010523b:	31 c0                	xor    %eax,%eax
8010523d:	c9                   	leave  
8010523e:	c3                   	ret    
8010523f:	90                   	nop

80105240 <sys_fork>:
#include "traps.h"


int
sys_fork(void)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	83 ec 08             	sub    $0x8,%esp
  return fork();
}
80105246:	c9                   	leave  


int
sys_fork(void)
{
  return fork();
80105247:	e9 e4 e8 ff ff       	jmp    80103b30 <fork>
8010524c:	00 00                	add    %al,(%eax)
	...

80105250 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105250:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105251:	ba 43 00 00 00       	mov    $0x43,%edx
80105256:	89 e5                	mov    %esp,%ebp
80105258:	83 ec 18             	sub    $0x18,%esp
8010525b:	b8 34 00 00 00       	mov    $0x34,%eax
80105260:	ee                   	out    %al,(%dx)
80105261:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
80105266:	b2 40                	mov    $0x40,%dl
80105268:	ee                   	out    %al,(%dx)
80105269:	b8 2e 00 00 00       	mov    $0x2e,%eax
8010526e:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
8010526f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105276:	e8 35 dd ff ff       	call   80102fb0 <picenable>
}
8010527b:	c9                   	leave  
8010527c:	c3                   	ret    
8010527d:	00 00                	add    %al,(%eax)
	...

80105280 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105280:	1e                   	push   %ds
  pushl %es
80105281:	06                   	push   %es
  pushl %fs
80105282:	0f a0                	push   %fs
  pushl %gs
80105284:	0f a8                	push   %gs
  pushal
80105286:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105287:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010528b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010528d:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010528f:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105293:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105295:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105297:	54                   	push   %esp
  call trap
80105298:	e8 43 00 00 00       	call   801052e0 <trap>
  addl $4, %esp
8010529d:	83 c4 04             	add    $0x4,%esp

801052a0 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801052a0:	61                   	popa   
  popl %gs
801052a1:	0f a9                	pop    %gs
  popl %fs
801052a3:	0f a1                	pop    %fs
  popl %es
801052a5:	07                   	pop    %es
  popl %ds
801052a6:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801052a7:	83 c4 08             	add    $0x8,%esp
  iret
801052aa:	cf                   	iret   
801052ab:	00 00                	add    %al,(%eax)
801052ad:	00 00                	add    %al,(%eax)
	...

801052b0 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
801052b0:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
801052b1:	b8 20 0e 11 80       	mov    $0x80110e20,%eax
801052b6:	89 e5                	mov    %esp,%ebp
801052b8:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801052bb:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
801052c1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801052c5:	c1 e8 10             	shr    $0x10,%eax
801052c8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801052cc:	8d 45 fa             	lea    -0x6(%ebp),%eax
801052cf:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801052d2:	c9                   	leave  
801052d3:	c3                   	ret    
801052d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801052da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801052e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	56                   	push   %esi
801052e4:	53                   	push   %ebx
801052e5:	83 ec 20             	sub    $0x20,%esp
801052e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801052eb:	8b 43 30             	mov    0x30(%ebx),%eax
801052ee:	83 f8 40             	cmp    $0x40,%eax
801052f1:	0f 84 c9 00 00 00    	je     801053c0 <trap+0xe0>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801052f7:	8d 50 e0             	lea    -0x20(%eax),%edx
801052fa:	83 fa 1f             	cmp    $0x1f,%edx
801052fd:	0f 86 b5 00 00 00    	jbe    801053b8 <trap+0xd8>
    lapiceoi();
    break;
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80105303:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010530a:	85 d2                	test   %edx,%edx
8010530c:	0f 84 de 01 00 00    	je     801054f0 <trap+0x210>
80105312:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105316:	0f 84 d4 01 00 00    	je     801054f0 <trap+0x210>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010531c:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010531f:	8b 4a 10             	mov    0x10(%edx),%ecx
80105322:	83 c2 6c             	add    $0x6c,%edx
80105325:	89 74 24 1c          	mov    %esi,0x1c(%esp)
80105329:	8b 73 38             	mov    0x38(%ebx),%esi
8010532c:	89 74 24 18          	mov    %esi,0x18(%esp)
80105330:	65 8b 35 00 00 00 00 	mov    %gs:0x0,%esi
80105337:	0f b6 36             	movzbl (%esi),%esi
8010533a:	89 74 24 14          	mov    %esi,0x14(%esp)
8010533e:	8b 73 34             	mov    0x34(%ebx),%esi
80105341:	89 44 24 0c          	mov    %eax,0xc(%esp)
80105345:	89 54 24 08          	mov    %edx,0x8(%esp)
80105349:	89 4c 24 04          	mov    %ecx,0x4(%esp)
8010534d:	89 74 24 10          	mov    %esi,0x10(%esp)
80105351:	c7 04 24 9c 71 10 80 	movl   $0x8010719c,(%esp)
80105358:	e8 a3 b4 ff ff       	call   80100800 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
8010535d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105363:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010536a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105370:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105376:	85 c0                	test   %eax,%eax
80105378:	74 34                	je     801053ae <trap+0xce>
8010537a:	8b 50 24             	mov    0x24(%eax),%edx
8010537d:	85 d2                	test   %edx,%edx
8010537f:	74 10                	je     80105391 <trap+0xb1>
80105381:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105385:	83 e2 03             	and    $0x3,%edx
80105388:	83 fa 03             	cmp    $0x3,%edx
8010538b:	0f 84 47 01 00 00    	je     801054d8 <trap+0x1f8>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105391:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105395:	0f 84 15 01 00 00    	je     801054b0 <trap+0x1d0>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010539b:	8b 40 24             	mov    0x24(%eax),%eax
8010539e:	85 c0                	test   %eax,%eax
801053a0:	74 0c                	je     801053ae <trap+0xce>
801053a2:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801053a6:	83 e0 03             	and    $0x3,%eax
801053a9:	83 f8 03             	cmp    $0x3,%eax
801053ac:	74 34                	je     801053e2 <trap+0x102>
    exit();
}
801053ae:	83 c4 20             	add    $0x20,%esp
801053b1:	5b                   	pop    %ebx
801053b2:	5e                   	pop    %esi
801053b3:	5d                   	pop    %ebp
801053b4:	c3                   	ret    
801053b5:	8d 76 00             	lea    0x0(%esi),%esi
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801053b8:	ff 24 95 ec 71 10 80 	jmp    *-0x7fef8e14(,%edx,4)
801053bf:	90                   	nop
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
801053c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053c6:	8b 70 24             	mov    0x24(%eax),%esi
801053c9:	85 f6                	test   %esi,%esi
801053cb:	75 23                	jne    801053f0 <trap+0x110>
      exit();
    proc->tf = tf;
801053cd:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801053d0:	e8 3b f0 ff ff       	call   80104410 <syscall>
    if(proc->killed)
801053d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053db:	8b 48 24             	mov    0x24(%eax),%ecx
801053de:	85 c9                	test   %ecx,%ecx
801053e0:	74 cc                	je     801053ae <trap+0xce>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801053e2:	83 c4 20             	add    $0x20,%esp
801053e5:	5b                   	pop    %ebx
801053e6:	5e                   	pop    %esi
801053e7:	5d                   	pop    %ebp
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
801053e8:	e9 33 e5 ff ff       	jmp    80103920 <exit>
801053ed:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
801053f0:	e8 2b e5 ff ff       	call   80103920 <exit>
801053f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053fb:	eb d0                	jmp    801053cd <trap+0xed>
801053fd:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105400:	e8 4b cc ff ff       	call   80102050 <ideintr>
    lapiceoi();
80105405:	e8 76 d2 ff ff       	call   80102680 <lapiceoi>
    break;
8010540a:	e9 61 ff ff ff       	jmp    80105370 <trap+0x90>
8010540f:	90                   	nop
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105410:	8b 43 38             	mov    0x38(%ebx),%eax
80105413:	89 44 24 0c          	mov    %eax,0xc(%esp)
80105417:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010541b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010541f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105425:	0f b6 00             	movzbl (%eax),%eax
80105428:	c7 04 24 44 71 10 80 	movl   $0x80107144,(%esp)
8010542f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105433:	e8 c8 b3 ff ff       	call   80100800 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80105438:	e8 43 d2 ff ff       	call   80102680 <lapiceoi>
    break;
8010543d:	e9 2e ff ff ff       	jmp    80105370 <trap+0x90>
80105442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105448:	90                   	nop
80105449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105450:	e8 9b 01 00 00       	call   801055f0 <uartintr>
    lapiceoi();
80105455:	e8 26 d2 ff ff       	call   80102680 <lapiceoi>
    break;
8010545a:	e9 11 ff ff ff       	jmp    80105370 <trap+0x90>
8010545f:	90                   	nop
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105460:	e8 bb d0 ff ff       	call   80102520 <kbdintr>
    lapiceoi();
80105465:	e8 16 d2 ff ff       	call   80102680 <lapiceoi>
    break;
8010546a:	e9 01 ff ff ff       	jmp    80105370 <trap+0x90>
8010546f:	90                   	nop
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80105470:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105476:	80 38 00             	cmpb   $0x0,(%eax)
80105479:	75 8a                	jne    80105405 <trap+0x125>
      acquire(&tickslock);
8010547b:	c7 04 24 e0 0d 11 80 	movl   $0x80110de0,(%esp)
80105482:	e8 c9 ea ff ff       	call   80103f50 <acquire>
      ticks++;
80105487:	83 05 20 16 11 80 01 	addl   $0x1,0x80111620
      wakeup(&ticks);
8010548e:	c7 04 24 20 16 11 80 	movl   $0x80111620,(%esp)
80105495:	e8 b6 e0 ff ff       	call   80103550 <wakeup>
      release(&tickslock);
8010549a:	c7 04 24 e0 0d 11 80 	movl   $0x80110de0,(%esp)
801054a1:	e8 5a ea ff ff       	call   80103f00 <release>
801054a6:	e9 5a ff ff ff       	jmp    80105405 <trap+0x125>
801054ab:	90                   	nop
801054ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801054b0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801054b4:	0f 85 e1 fe ff ff    	jne    8010539b <trap+0xbb>
801054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    yield();
801054c0:	e8 8b e2 ff ff       	call   80103750 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801054c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054cb:	85 c0                	test   %eax,%eax
801054cd:	0f 85 c8 fe ff ff    	jne    8010539b <trap+0xbb>
801054d3:	e9 d6 fe ff ff       	jmp    801053ae <trap+0xce>

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
801054d8:	e8 43 e4 ff ff       	call   80103920 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801054dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054e3:	85 c0                	test   %eax,%eax
801054e5:	0f 85 a6 fe ff ff    	jne    80105391 <trap+0xb1>
801054eb:	e9 be fe ff ff       	jmp    801053ae <trap+0xce>
801054f0:	0f 20 d2             	mov    %cr2,%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801054f3:	89 54 24 10          	mov    %edx,0x10(%esp)
801054f7:	8b 53 38             	mov    0x38(%ebx),%edx
801054fa:	89 54 24 0c          	mov    %edx,0xc(%esp)
801054fe:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105505:	0f b6 12             	movzbl (%edx),%edx
80105508:	89 44 24 04          	mov    %eax,0x4(%esp)
8010550c:	c7 04 24 68 71 10 80 	movl   $0x80107168,(%esp)
80105513:	89 54 24 08          	mov    %edx,0x8(%esp)
80105517:	e8 e4 b2 ff ff       	call   80100800 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010551c:	c7 04 24 df 71 10 80 	movl   $0x801071df,(%esp)
80105523:	e8 58 b2 ff ff       	call   80100780 <panic>
80105528:	90                   	nop
80105529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105530 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105530:	55                   	push   %ebp
80105531:	31 c0                	xor    %eax,%eax
80105533:	89 e5                	mov    %esp,%ebp
80105535:	ba 20 0e 11 80       	mov    $0x80110e20,%edx
8010553a:	83 ec 18             	sub    $0x18,%esp
8010553d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105540:	8b 0c 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%ecx
80105547:	66 89 0c c5 20 0e 11 	mov    %cx,-0x7feef1e0(,%eax,8)
8010554e:	80 
8010554f:	c1 e9 10             	shr    $0x10,%ecx
80105552:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
80105559:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
8010555e:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
80105563:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105568:	83 c0 01             	add    $0x1,%eax
8010556b:	3d 00 01 00 00       	cmp    $0x100,%eax
80105570:	75 ce                	jne    80105540 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105572:	a1 0c a1 10 80       	mov    0x8010a10c,%eax
  
  initlock(&tickslock, "time");
80105577:	c7 44 24 04 e4 71 10 	movl   $0x801071e4,0x4(%esp)
8010557e:	80 
8010557f:	c7 04 24 e0 0d 11 80 	movl   $0x80110de0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105586:	66 c7 05 22 10 11 80 	movw   $0x8,0x80111022
8010558d:	08 00 
8010558f:	66 a3 20 10 11 80    	mov    %ax,0x80111020
80105595:	c1 e8 10             	shr    $0x10,%eax
80105598:	c6 05 24 10 11 80 00 	movb   $0x0,0x80111024
8010559f:	c6 05 25 10 11 80 ef 	movb   $0xef,0x80111025
801055a6:	66 a3 26 10 11 80    	mov    %ax,0x80111026
  
  initlock(&tickslock, "time");
801055ac:	e8 0f e8 ff ff       	call   80103dc0 <initlock>
}
801055b1:	c9                   	leave  
801055b2:	c3                   	ret    
	...

801055c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801055c0:	a1 cc a5 10 80       	mov    0x8010a5cc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801055c5:	55                   	push   %ebp
801055c6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801055c8:	85 c0                	test   %eax,%eax
801055ca:	75 0c                	jne    801055d8 <uartgetc+0x18>
    return -1;
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
801055cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055d1:	5d                   	pop    %ebp
801055d2:	c3                   	ret    
801055d3:	90                   	nop
801055d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801055d8:	ba fd 03 00 00       	mov    $0x3fd,%edx
801055dd:	ec                   	in     (%dx),%al
static int
uartgetc(void)
{
  if(!uart)
    return -1;
  if(!(inb(COM1+5) & 0x01))
801055de:	a8 01                	test   $0x1,%al
801055e0:	74 ea                	je     801055cc <uartgetc+0xc>
801055e2:	b2 f8                	mov    $0xf8,%dl
801055e4:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801055e5:	0f b6 c0             	movzbl %al,%eax
}
801055e8:	5d                   	pop    %ebp
801055e9:	c3                   	ret    
801055ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801055f0 <uartintr>:

void
uartintr(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801055f6:	c7 04 24 c0 55 10 80 	movl   $0x801055c0,(%esp)
801055fd:	e8 fe af ff ff       	call   80100600 <consoleintr>
}
80105602:	c9                   	leave  
80105603:	c3                   	ret    
80105604:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010560a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105610 <uartputc>:
    uartputc(*p);
}

void
uartputc(int c)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	56                   	push   %esi
80105614:	be fd 03 00 00       	mov    $0x3fd,%esi
80105619:	53                   	push   %ebx
  int i;

  if(!uart)
8010561a:	31 db                	xor    %ebx,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
8010561c:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
8010561f:	8b 15 cc a5 10 80    	mov    0x8010a5cc,%edx
80105625:	85 d2                	test   %edx,%edx
80105627:	75 1e                	jne    80105647 <uartputc+0x37>
80105629:	eb 2c                	jmp    80105657 <uartputc+0x47>
8010562b:	90                   	nop
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105630:	83 c3 01             	add    $0x1,%ebx
    microdelay(10);
80105633:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
8010563a:	e8 61 d0 ff ff       	call   801026a0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010563f:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80105645:	74 07                	je     8010564e <uartputc+0x3e>
80105647:	89 f2                	mov    %esi,%edx
80105649:	ec                   	in     (%dx),%al
8010564a:	a8 20                	test   $0x20,%al
8010564c:	74 e2                	je     80105630 <uartputc+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010564e:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105653:	8b 45 08             	mov    0x8(%ebp),%eax
80105656:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105657:	83 c4 10             	add    $0x10,%esp
8010565a:	5b                   	pop    %ebx
8010565b:	5e                   	pop    %esi
8010565c:	5d                   	pop    %ebp
8010565d:	c3                   	ret    
8010565e:	66 90                	xchg   %ax,%ax

80105660 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105660:	55                   	push   %ebp
80105661:	31 c9                	xor    %ecx,%ecx
80105663:	89 e5                	mov    %esp,%ebp
80105665:	89 c8                	mov    %ecx,%eax
80105667:	57                   	push   %edi
80105668:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010566d:	56                   	push   %esi
8010566e:	89 fa                	mov    %edi,%edx
80105670:	53                   	push   %ebx
80105671:	83 ec 1c             	sub    $0x1c,%esp
80105674:	ee                   	out    %al,(%dx)
80105675:	bb fb 03 00 00       	mov    $0x3fb,%ebx
8010567a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010567f:	89 da                	mov    %ebx,%edx
80105681:	ee                   	out    %al,(%dx)
80105682:	b8 0c 00 00 00       	mov    $0xc,%eax
80105687:	b2 f8                	mov    $0xf8,%dl
80105689:	ee                   	out    %al,(%dx)
8010568a:	be f9 03 00 00       	mov    $0x3f9,%esi
8010568f:	89 c8                	mov    %ecx,%eax
80105691:	89 f2                	mov    %esi,%edx
80105693:	ee                   	out    %al,(%dx)
80105694:	b8 03 00 00 00       	mov    $0x3,%eax
80105699:	89 da                	mov    %ebx,%edx
8010569b:	ee                   	out    %al,(%dx)
8010569c:	b2 fc                	mov    $0xfc,%dl
8010569e:	89 c8                	mov    %ecx,%eax
801056a0:	ee                   	out    %al,(%dx)
801056a1:	b8 01 00 00 00       	mov    $0x1,%eax
801056a6:	89 f2                	mov    %esi,%edx
801056a8:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801056a9:	b2 fd                	mov    $0xfd,%dl
801056ab:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801056ac:	3c ff                	cmp    $0xff,%al
801056ae:	74 55                	je     80105705 <uartinit+0xa5>
    return;
  uart = 1;
801056b0:	c7 05 cc a5 10 80 01 	movl   $0x1,0x8010a5cc
801056b7:	00 00 00 
801056ba:	89 fa                	mov    %edi,%edx
801056bc:	ec                   	in     (%dx),%al
801056bd:	b2 f8                	mov    $0xf8,%dl
801056bf:	ec                   	in     (%dx),%al
  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
801056c0:	bb 6c 72 10 80       	mov    $0x8010726c,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
801056c5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801056cc:	e8 df d8 ff ff       	call   80102fb0 <picenable>
  ioapicenable(IRQ_COM1, 0);
801056d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801056d8:	00 
801056d9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801056e0:	e8 9b ca ff ff       	call   80102180 <ioapicenable>
801056e5:	b8 78 00 00 00       	mov    $0x78,%eax
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
801056f0:	0f be c0             	movsbl %al,%eax
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801056f3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
801056f6:	89 04 24             	mov    %eax,(%esp)
801056f9:	e8 12 ff ff ff       	call   80105610 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801056fe:	0f b6 03             	movzbl (%ebx),%eax
80105701:	84 c0                	test   %al,%al
80105703:	75 eb                	jne    801056f0 <uartinit+0x90>
    uartputc(*p);
}
80105705:	83 c4 1c             	add    $0x1c,%esp
80105708:	5b                   	pop    %ebx
80105709:	5e                   	pop    %esi
8010570a:	5f                   	pop    %edi
8010570b:	5d                   	pop    %ebp
8010570c:	c3                   	ret    
8010570d:	00 00                	add    %al,(%eax)
	...

80105710 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105710:	6a 00                	push   $0x0
  pushl $0
80105712:	6a 00                	push   $0x0
  jmp alltraps
80105714:	e9 67 fb ff ff       	jmp    80105280 <alltraps>

80105719 <vector1>:
.globl vector1
vector1:
  pushl $0
80105719:	6a 00                	push   $0x0
  pushl $1
8010571b:	6a 01                	push   $0x1
  jmp alltraps
8010571d:	e9 5e fb ff ff       	jmp    80105280 <alltraps>

80105722 <vector2>:
.globl vector2
vector2:
  pushl $0
80105722:	6a 00                	push   $0x0
  pushl $2
80105724:	6a 02                	push   $0x2
  jmp alltraps
80105726:	e9 55 fb ff ff       	jmp    80105280 <alltraps>

8010572b <vector3>:
.globl vector3
vector3:
  pushl $0
8010572b:	6a 00                	push   $0x0
  pushl $3
8010572d:	6a 03                	push   $0x3
  jmp alltraps
8010572f:	e9 4c fb ff ff       	jmp    80105280 <alltraps>

80105734 <vector4>:
.globl vector4
vector4:
  pushl $0
80105734:	6a 00                	push   $0x0
  pushl $4
80105736:	6a 04                	push   $0x4
  jmp alltraps
80105738:	e9 43 fb ff ff       	jmp    80105280 <alltraps>

8010573d <vector5>:
.globl vector5
vector5:
  pushl $0
8010573d:	6a 00                	push   $0x0
  pushl $5
8010573f:	6a 05                	push   $0x5
  jmp alltraps
80105741:	e9 3a fb ff ff       	jmp    80105280 <alltraps>

80105746 <vector6>:
.globl vector6
vector6:
  pushl $0
80105746:	6a 00                	push   $0x0
  pushl $6
80105748:	6a 06                	push   $0x6
  jmp alltraps
8010574a:	e9 31 fb ff ff       	jmp    80105280 <alltraps>

8010574f <vector7>:
.globl vector7
vector7:
  pushl $0
8010574f:	6a 00                	push   $0x0
  pushl $7
80105751:	6a 07                	push   $0x7
  jmp alltraps
80105753:	e9 28 fb ff ff       	jmp    80105280 <alltraps>

80105758 <vector8>:
.globl vector8
vector8:
  pushl $8
80105758:	6a 08                	push   $0x8
  jmp alltraps
8010575a:	e9 21 fb ff ff       	jmp    80105280 <alltraps>

8010575f <vector9>:
.globl vector9
vector9:
  pushl $0
8010575f:	6a 00                	push   $0x0
  pushl $9
80105761:	6a 09                	push   $0x9
  jmp alltraps
80105763:	e9 18 fb ff ff       	jmp    80105280 <alltraps>

80105768 <vector10>:
.globl vector10
vector10:
  pushl $10
80105768:	6a 0a                	push   $0xa
  jmp alltraps
8010576a:	e9 11 fb ff ff       	jmp    80105280 <alltraps>

8010576f <vector11>:
.globl vector11
vector11:
  pushl $11
8010576f:	6a 0b                	push   $0xb
  jmp alltraps
80105771:	e9 0a fb ff ff       	jmp    80105280 <alltraps>

80105776 <vector12>:
.globl vector12
vector12:
  pushl $12
80105776:	6a 0c                	push   $0xc
  jmp alltraps
80105778:	e9 03 fb ff ff       	jmp    80105280 <alltraps>

8010577d <vector13>:
.globl vector13
vector13:
  pushl $13
8010577d:	6a 0d                	push   $0xd
  jmp alltraps
8010577f:	e9 fc fa ff ff       	jmp    80105280 <alltraps>

80105784 <vector14>:
.globl vector14
vector14:
  pushl $14
80105784:	6a 0e                	push   $0xe
  jmp alltraps
80105786:	e9 f5 fa ff ff       	jmp    80105280 <alltraps>

8010578b <vector15>:
.globl vector15
vector15:
  pushl $0
8010578b:	6a 00                	push   $0x0
  pushl $15
8010578d:	6a 0f                	push   $0xf
  jmp alltraps
8010578f:	e9 ec fa ff ff       	jmp    80105280 <alltraps>

80105794 <vector16>:
.globl vector16
vector16:
  pushl $0
80105794:	6a 00                	push   $0x0
  pushl $16
80105796:	6a 10                	push   $0x10
  jmp alltraps
80105798:	e9 e3 fa ff ff       	jmp    80105280 <alltraps>

8010579d <vector17>:
.globl vector17
vector17:
  pushl $17
8010579d:	6a 11                	push   $0x11
  jmp alltraps
8010579f:	e9 dc fa ff ff       	jmp    80105280 <alltraps>

801057a4 <vector18>:
.globl vector18
vector18:
  pushl $0
801057a4:	6a 00                	push   $0x0
  pushl $18
801057a6:	6a 12                	push   $0x12
  jmp alltraps
801057a8:	e9 d3 fa ff ff       	jmp    80105280 <alltraps>

801057ad <vector19>:
.globl vector19
vector19:
  pushl $0
801057ad:	6a 00                	push   $0x0
  pushl $19
801057af:	6a 13                	push   $0x13
  jmp alltraps
801057b1:	e9 ca fa ff ff       	jmp    80105280 <alltraps>

801057b6 <vector20>:
.globl vector20
vector20:
  pushl $0
801057b6:	6a 00                	push   $0x0
  pushl $20
801057b8:	6a 14                	push   $0x14
  jmp alltraps
801057ba:	e9 c1 fa ff ff       	jmp    80105280 <alltraps>

801057bf <vector21>:
.globl vector21
vector21:
  pushl $0
801057bf:	6a 00                	push   $0x0
  pushl $21
801057c1:	6a 15                	push   $0x15
  jmp alltraps
801057c3:	e9 b8 fa ff ff       	jmp    80105280 <alltraps>

801057c8 <vector22>:
.globl vector22
vector22:
  pushl $0
801057c8:	6a 00                	push   $0x0
  pushl $22
801057ca:	6a 16                	push   $0x16
  jmp alltraps
801057cc:	e9 af fa ff ff       	jmp    80105280 <alltraps>

801057d1 <vector23>:
.globl vector23
vector23:
  pushl $0
801057d1:	6a 00                	push   $0x0
  pushl $23
801057d3:	6a 17                	push   $0x17
  jmp alltraps
801057d5:	e9 a6 fa ff ff       	jmp    80105280 <alltraps>

801057da <vector24>:
.globl vector24
vector24:
  pushl $0
801057da:	6a 00                	push   $0x0
  pushl $24
801057dc:	6a 18                	push   $0x18
  jmp alltraps
801057de:	e9 9d fa ff ff       	jmp    80105280 <alltraps>

801057e3 <vector25>:
.globl vector25
vector25:
  pushl $0
801057e3:	6a 00                	push   $0x0
  pushl $25
801057e5:	6a 19                	push   $0x19
  jmp alltraps
801057e7:	e9 94 fa ff ff       	jmp    80105280 <alltraps>

801057ec <vector26>:
.globl vector26
vector26:
  pushl $0
801057ec:	6a 00                	push   $0x0
  pushl $26
801057ee:	6a 1a                	push   $0x1a
  jmp alltraps
801057f0:	e9 8b fa ff ff       	jmp    80105280 <alltraps>

801057f5 <vector27>:
.globl vector27
vector27:
  pushl $0
801057f5:	6a 00                	push   $0x0
  pushl $27
801057f7:	6a 1b                	push   $0x1b
  jmp alltraps
801057f9:	e9 82 fa ff ff       	jmp    80105280 <alltraps>

801057fe <vector28>:
.globl vector28
vector28:
  pushl $0
801057fe:	6a 00                	push   $0x0
  pushl $28
80105800:	6a 1c                	push   $0x1c
  jmp alltraps
80105802:	e9 79 fa ff ff       	jmp    80105280 <alltraps>

80105807 <vector29>:
.globl vector29
vector29:
  pushl $0
80105807:	6a 00                	push   $0x0
  pushl $29
80105809:	6a 1d                	push   $0x1d
  jmp alltraps
8010580b:	e9 70 fa ff ff       	jmp    80105280 <alltraps>

80105810 <vector30>:
.globl vector30
vector30:
  pushl $0
80105810:	6a 00                	push   $0x0
  pushl $30
80105812:	6a 1e                	push   $0x1e
  jmp alltraps
80105814:	e9 67 fa ff ff       	jmp    80105280 <alltraps>

80105819 <vector31>:
.globl vector31
vector31:
  pushl $0
80105819:	6a 00                	push   $0x0
  pushl $31
8010581b:	6a 1f                	push   $0x1f
  jmp alltraps
8010581d:	e9 5e fa ff ff       	jmp    80105280 <alltraps>

80105822 <vector32>:
.globl vector32
vector32:
  pushl $0
80105822:	6a 00                	push   $0x0
  pushl $32
80105824:	6a 20                	push   $0x20
  jmp alltraps
80105826:	e9 55 fa ff ff       	jmp    80105280 <alltraps>

8010582b <vector33>:
.globl vector33
vector33:
  pushl $0
8010582b:	6a 00                	push   $0x0
  pushl $33
8010582d:	6a 21                	push   $0x21
  jmp alltraps
8010582f:	e9 4c fa ff ff       	jmp    80105280 <alltraps>

80105834 <vector34>:
.globl vector34
vector34:
  pushl $0
80105834:	6a 00                	push   $0x0
  pushl $34
80105836:	6a 22                	push   $0x22
  jmp alltraps
80105838:	e9 43 fa ff ff       	jmp    80105280 <alltraps>

8010583d <vector35>:
.globl vector35
vector35:
  pushl $0
8010583d:	6a 00                	push   $0x0
  pushl $35
8010583f:	6a 23                	push   $0x23
  jmp alltraps
80105841:	e9 3a fa ff ff       	jmp    80105280 <alltraps>

80105846 <vector36>:
.globl vector36
vector36:
  pushl $0
80105846:	6a 00                	push   $0x0
  pushl $36
80105848:	6a 24                	push   $0x24
  jmp alltraps
8010584a:	e9 31 fa ff ff       	jmp    80105280 <alltraps>

8010584f <vector37>:
.globl vector37
vector37:
  pushl $0
8010584f:	6a 00                	push   $0x0
  pushl $37
80105851:	6a 25                	push   $0x25
  jmp alltraps
80105853:	e9 28 fa ff ff       	jmp    80105280 <alltraps>

80105858 <vector38>:
.globl vector38
vector38:
  pushl $0
80105858:	6a 00                	push   $0x0
  pushl $38
8010585a:	6a 26                	push   $0x26
  jmp alltraps
8010585c:	e9 1f fa ff ff       	jmp    80105280 <alltraps>

80105861 <vector39>:
.globl vector39
vector39:
  pushl $0
80105861:	6a 00                	push   $0x0
  pushl $39
80105863:	6a 27                	push   $0x27
  jmp alltraps
80105865:	e9 16 fa ff ff       	jmp    80105280 <alltraps>

8010586a <vector40>:
.globl vector40
vector40:
  pushl $0
8010586a:	6a 00                	push   $0x0
  pushl $40
8010586c:	6a 28                	push   $0x28
  jmp alltraps
8010586e:	e9 0d fa ff ff       	jmp    80105280 <alltraps>

80105873 <vector41>:
.globl vector41
vector41:
  pushl $0
80105873:	6a 00                	push   $0x0
  pushl $41
80105875:	6a 29                	push   $0x29
  jmp alltraps
80105877:	e9 04 fa ff ff       	jmp    80105280 <alltraps>

8010587c <vector42>:
.globl vector42
vector42:
  pushl $0
8010587c:	6a 00                	push   $0x0
  pushl $42
8010587e:	6a 2a                	push   $0x2a
  jmp alltraps
80105880:	e9 fb f9 ff ff       	jmp    80105280 <alltraps>

80105885 <vector43>:
.globl vector43
vector43:
  pushl $0
80105885:	6a 00                	push   $0x0
  pushl $43
80105887:	6a 2b                	push   $0x2b
  jmp alltraps
80105889:	e9 f2 f9 ff ff       	jmp    80105280 <alltraps>

8010588e <vector44>:
.globl vector44
vector44:
  pushl $0
8010588e:	6a 00                	push   $0x0
  pushl $44
80105890:	6a 2c                	push   $0x2c
  jmp alltraps
80105892:	e9 e9 f9 ff ff       	jmp    80105280 <alltraps>

80105897 <vector45>:
.globl vector45
vector45:
  pushl $0
80105897:	6a 00                	push   $0x0
  pushl $45
80105899:	6a 2d                	push   $0x2d
  jmp alltraps
8010589b:	e9 e0 f9 ff ff       	jmp    80105280 <alltraps>

801058a0 <vector46>:
.globl vector46
vector46:
  pushl $0
801058a0:	6a 00                	push   $0x0
  pushl $46
801058a2:	6a 2e                	push   $0x2e
  jmp alltraps
801058a4:	e9 d7 f9 ff ff       	jmp    80105280 <alltraps>

801058a9 <vector47>:
.globl vector47
vector47:
  pushl $0
801058a9:	6a 00                	push   $0x0
  pushl $47
801058ab:	6a 2f                	push   $0x2f
  jmp alltraps
801058ad:	e9 ce f9 ff ff       	jmp    80105280 <alltraps>

801058b2 <vector48>:
.globl vector48
vector48:
  pushl $0
801058b2:	6a 00                	push   $0x0
  pushl $48
801058b4:	6a 30                	push   $0x30
  jmp alltraps
801058b6:	e9 c5 f9 ff ff       	jmp    80105280 <alltraps>

801058bb <vector49>:
.globl vector49
vector49:
  pushl $0
801058bb:	6a 00                	push   $0x0
  pushl $49
801058bd:	6a 31                	push   $0x31
  jmp alltraps
801058bf:	e9 bc f9 ff ff       	jmp    80105280 <alltraps>

801058c4 <vector50>:
.globl vector50
vector50:
  pushl $0
801058c4:	6a 00                	push   $0x0
  pushl $50
801058c6:	6a 32                	push   $0x32
  jmp alltraps
801058c8:	e9 b3 f9 ff ff       	jmp    80105280 <alltraps>

801058cd <vector51>:
.globl vector51
vector51:
  pushl $0
801058cd:	6a 00                	push   $0x0
  pushl $51
801058cf:	6a 33                	push   $0x33
  jmp alltraps
801058d1:	e9 aa f9 ff ff       	jmp    80105280 <alltraps>

801058d6 <vector52>:
.globl vector52
vector52:
  pushl $0
801058d6:	6a 00                	push   $0x0
  pushl $52
801058d8:	6a 34                	push   $0x34
  jmp alltraps
801058da:	e9 a1 f9 ff ff       	jmp    80105280 <alltraps>

801058df <vector53>:
.globl vector53
vector53:
  pushl $0
801058df:	6a 00                	push   $0x0
  pushl $53
801058e1:	6a 35                	push   $0x35
  jmp alltraps
801058e3:	e9 98 f9 ff ff       	jmp    80105280 <alltraps>

801058e8 <vector54>:
.globl vector54
vector54:
  pushl $0
801058e8:	6a 00                	push   $0x0
  pushl $54
801058ea:	6a 36                	push   $0x36
  jmp alltraps
801058ec:	e9 8f f9 ff ff       	jmp    80105280 <alltraps>

801058f1 <vector55>:
.globl vector55
vector55:
  pushl $0
801058f1:	6a 00                	push   $0x0
  pushl $55
801058f3:	6a 37                	push   $0x37
  jmp alltraps
801058f5:	e9 86 f9 ff ff       	jmp    80105280 <alltraps>

801058fa <vector56>:
.globl vector56
vector56:
  pushl $0
801058fa:	6a 00                	push   $0x0
  pushl $56
801058fc:	6a 38                	push   $0x38
  jmp alltraps
801058fe:	e9 7d f9 ff ff       	jmp    80105280 <alltraps>

80105903 <vector57>:
.globl vector57
vector57:
  pushl $0
80105903:	6a 00                	push   $0x0
  pushl $57
80105905:	6a 39                	push   $0x39
  jmp alltraps
80105907:	e9 74 f9 ff ff       	jmp    80105280 <alltraps>

8010590c <vector58>:
.globl vector58
vector58:
  pushl $0
8010590c:	6a 00                	push   $0x0
  pushl $58
8010590e:	6a 3a                	push   $0x3a
  jmp alltraps
80105910:	e9 6b f9 ff ff       	jmp    80105280 <alltraps>

80105915 <vector59>:
.globl vector59
vector59:
  pushl $0
80105915:	6a 00                	push   $0x0
  pushl $59
80105917:	6a 3b                	push   $0x3b
  jmp alltraps
80105919:	e9 62 f9 ff ff       	jmp    80105280 <alltraps>

8010591e <vector60>:
.globl vector60
vector60:
  pushl $0
8010591e:	6a 00                	push   $0x0
  pushl $60
80105920:	6a 3c                	push   $0x3c
  jmp alltraps
80105922:	e9 59 f9 ff ff       	jmp    80105280 <alltraps>

80105927 <vector61>:
.globl vector61
vector61:
  pushl $0
80105927:	6a 00                	push   $0x0
  pushl $61
80105929:	6a 3d                	push   $0x3d
  jmp alltraps
8010592b:	e9 50 f9 ff ff       	jmp    80105280 <alltraps>

80105930 <vector62>:
.globl vector62
vector62:
  pushl $0
80105930:	6a 00                	push   $0x0
  pushl $62
80105932:	6a 3e                	push   $0x3e
  jmp alltraps
80105934:	e9 47 f9 ff ff       	jmp    80105280 <alltraps>

80105939 <vector63>:
.globl vector63
vector63:
  pushl $0
80105939:	6a 00                	push   $0x0
  pushl $63
8010593b:	6a 3f                	push   $0x3f
  jmp alltraps
8010593d:	e9 3e f9 ff ff       	jmp    80105280 <alltraps>

80105942 <vector64>:
.globl vector64
vector64:
  pushl $0
80105942:	6a 00                	push   $0x0
  pushl $64
80105944:	6a 40                	push   $0x40
  jmp alltraps
80105946:	e9 35 f9 ff ff       	jmp    80105280 <alltraps>

8010594b <vector65>:
.globl vector65
vector65:
  pushl $0
8010594b:	6a 00                	push   $0x0
  pushl $65
8010594d:	6a 41                	push   $0x41
  jmp alltraps
8010594f:	e9 2c f9 ff ff       	jmp    80105280 <alltraps>

80105954 <vector66>:
.globl vector66
vector66:
  pushl $0
80105954:	6a 00                	push   $0x0
  pushl $66
80105956:	6a 42                	push   $0x42
  jmp alltraps
80105958:	e9 23 f9 ff ff       	jmp    80105280 <alltraps>

8010595d <vector67>:
.globl vector67
vector67:
  pushl $0
8010595d:	6a 00                	push   $0x0
  pushl $67
8010595f:	6a 43                	push   $0x43
  jmp alltraps
80105961:	e9 1a f9 ff ff       	jmp    80105280 <alltraps>

80105966 <vector68>:
.globl vector68
vector68:
  pushl $0
80105966:	6a 00                	push   $0x0
  pushl $68
80105968:	6a 44                	push   $0x44
  jmp alltraps
8010596a:	e9 11 f9 ff ff       	jmp    80105280 <alltraps>

8010596f <vector69>:
.globl vector69
vector69:
  pushl $0
8010596f:	6a 00                	push   $0x0
  pushl $69
80105971:	6a 45                	push   $0x45
  jmp alltraps
80105973:	e9 08 f9 ff ff       	jmp    80105280 <alltraps>

80105978 <vector70>:
.globl vector70
vector70:
  pushl $0
80105978:	6a 00                	push   $0x0
  pushl $70
8010597a:	6a 46                	push   $0x46
  jmp alltraps
8010597c:	e9 ff f8 ff ff       	jmp    80105280 <alltraps>

80105981 <vector71>:
.globl vector71
vector71:
  pushl $0
80105981:	6a 00                	push   $0x0
  pushl $71
80105983:	6a 47                	push   $0x47
  jmp alltraps
80105985:	e9 f6 f8 ff ff       	jmp    80105280 <alltraps>

8010598a <vector72>:
.globl vector72
vector72:
  pushl $0
8010598a:	6a 00                	push   $0x0
  pushl $72
8010598c:	6a 48                	push   $0x48
  jmp alltraps
8010598e:	e9 ed f8 ff ff       	jmp    80105280 <alltraps>

80105993 <vector73>:
.globl vector73
vector73:
  pushl $0
80105993:	6a 00                	push   $0x0
  pushl $73
80105995:	6a 49                	push   $0x49
  jmp alltraps
80105997:	e9 e4 f8 ff ff       	jmp    80105280 <alltraps>

8010599c <vector74>:
.globl vector74
vector74:
  pushl $0
8010599c:	6a 00                	push   $0x0
  pushl $74
8010599e:	6a 4a                	push   $0x4a
  jmp alltraps
801059a0:	e9 db f8 ff ff       	jmp    80105280 <alltraps>

801059a5 <vector75>:
.globl vector75
vector75:
  pushl $0
801059a5:	6a 00                	push   $0x0
  pushl $75
801059a7:	6a 4b                	push   $0x4b
  jmp alltraps
801059a9:	e9 d2 f8 ff ff       	jmp    80105280 <alltraps>

801059ae <vector76>:
.globl vector76
vector76:
  pushl $0
801059ae:	6a 00                	push   $0x0
  pushl $76
801059b0:	6a 4c                	push   $0x4c
  jmp alltraps
801059b2:	e9 c9 f8 ff ff       	jmp    80105280 <alltraps>

801059b7 <vector77>:
.globl vector77
vector77:
  pushl $0
801059b7:	6a 00                	push   $0x0
  pushl $77
801059b9:	6a 4d                	push   $0x4d
  jmp alltraps
801059bb:	e9 c0 f8 ff ff       	jmp    80105280 <alltraps>

801059c0 <vector78>:
.globl vector78
vector78:
  pushl $0
801059c0:	6a 00                	push   $0x0
  pushl $78
801059c2:	6a 4e                	push   $0x4e
  jmp alltraps
801059c4:	e9 b7 f8 ff ff       	jmp    80105280 <alltraps>

801059c9 <vector79>:
.globl vector79
vector79:
  pushl $0
801059c9:	6a 00                	push   $0x0
  pushl $79
801059cb:	6a 4f                	push   $0x4f
  jmp alltraps
801059cd:	e9 ae f8 ff ff       	jmp    80105280 <alltraps>

801059d2 <vector80>:
.globl vector80
vector80:
  pushl $0
801059d2:	6a 00                	push   $0x0
  pushl $80
801059d4:	6a 50                	push   $0x50
  jmp alltraps
801059d6:	e9 a5 f8 ff ff       	jmp    80105280 <alltraps>

801059db <vector81>:
.globl vector81
vector81:
  pushl $0
801059db:	6a 00                	push   $0x0
  pushl $81
801059dd:	6a 51                	push   $0x51
  jmp alltraps
801059df:	e9 9c f8 ff ff       	jmp    80105280 <alltraps>

801059e4 <vector82>:
.globl vector82
vector82:
  pushl $0
801059e4:	6a 00                	push   $0x0
  pushl $82
801059e6:	6a 52                	push   $0x52
  jmp alltraps
801059e8:	e9 93 f8 ff ff       	jmp    80105280 <alltraps>

801059ed <vector83>:
.globl vector83
vector83:
  pushl $0
801059ed:	6a 00                	push   $0x0
  pushl $83
801059ef:	6a 53                	push   $0x53
  jmp alltraps
801059f1:	e9 8a f8 ff ff       	jmp    80105280 <alltraps>

801059f6 <vector84>:
.globl vector84
vector84:
  pushl $0
801059f6:	6a 00                	push   $0x0
  pushl $84
801059f8:	6a 54                	push   $0x54
  jmp alltraps
801059fa:	e9 81 f8 ff ff       	jmp    80105280 <alltraps>

801059ff <vector85>:
.globl vector85
vector85:
  pushl $0
801059ff:	6a 00                	push   $0x0
  pushl $85
80105a01:	6a 55                	push   $0x55
  jmp alltraps
80105a03:	e9 78 f8 ff ff       	jmp    80105280 <alltraps>

80105a08 <vector86>:
.globl vector86
vector86:
  pushl $0
80105a08:	6a 00                	push   $0x0
  pushl $86
80105a0a:	6a 56                	push   $0x56
  jmp alltraps
80105a0c:	e9 6f f8 ff ff       	jmp    80105280 <alltraps>

80105a11 <vector87>:
.globl vector87
vector87:
  pushl $0
80105a11:	6a 00                	push   $0x0
  pushl $87
80105a13:	6a 57                	push   $0x57
  jmp alltraps
80105a15:	e9 66 f8 ff ff       	jmp    80105280 <alltraps>

80105a1a <vector88>:
.globl vector88
vector88:
  pushl $0
80105a1a:	6a 00                	push   $0x0
  pushl $88
80105a1c:	6a 58                	push   $0x58
  jmp alltraps
80105a1e:	e9 5d f8 ff ff       	jmp    80105280 <alltraps>

80105a23 <vector89>:
.globl vector89
vector89:
  pushl $0
80105a23:	6a 00                	push   $0x0
  pushl $89
80105a25:	6a 59                	push   $0x59
  jmp alltraps
80105a27:	e9 54 f8 ff ff       	jmp    80105280 <alltraps>

80105a2c <vector90>:
.globl vector90
vector90:
  pushl $0
80105a2c:	6a 00                	push   $0x0
  pushl $90
80105a2e:	6a 5a                	push   $0x5a
  jmp alltraps
80105a30:	e9 4b f8 ff ff       	jmp    80105280 <alltraps>

80105a35 <vector91>:
.globl vector91
vector91:
  pushl $0
80105a35:	6a 00                	push   $0x0
  pushl $91
80105a37:	6a 5b                	push   $0x5b
  jmp alltraps
80105a39:	e9 42 f8 ff ff       	jmp    80105280 <alltraps>

80105a3e <vector92>:
.globl vector92
vector92:
  pushl $0
80105a3e:	6a 00                	push   $0x0
  pushl $92
80105a40:	6a 5c                	push   $0x5c
  jmp alltraps
80105a42:	e9 39 f8 ff ff       	jmp    80105280 <alltraps>

80105a47 <vector93>:
.globl vector93
vector93:
  pushl $0
80105a47:	6a 00                	push   $0x0
  pushl $93
80105a49:	6a 5d                	push   $0x5d
  jmp alltraps
80105a4b:	e9 30 f8 ff ff       	jmp    80105280 <alltraps>

80105a50 <vector94>:
.globl vector94
vector94:
  pushl $0
80105a50:	6a 00                	push   $0x0
  pushl $94
80105a52:	6a 5e                	push   $0x5e
  jmp alltraps
80105a54:	e9 27 f8 ff ff       	jmp    80105280 <alltraps>

80105a59 <vector95>:
.globl vector95
vector95:
  pushl $0
80105a59:	6a 00                	push   $0x0
  pushl $95
80105a5b:	6a 5f                	push   $0x5f
  jmp alltraps
80105a5d:	e9 1e f8 ff ff       	jmp    80105280 <alltraps>

80105a62 <vector96>:
.globl vector96
vector96:
  pushl $0
80105a62:	6a 00                	push   $0x0
  pushl $96
80105a64:	6a 60                	push   $0x60
  jmp alltraps
80105a66:	e9 15 f8 ff ff       	jmp    80105280 <alltraps>

80105a6b <vector97>:
.globl vector97
vector97:
  pushl $0
80105a6b:	6a 00                	push   $0x0
  pushl $97
80105a6d:	6a 61                	push   $0x61
  jmp alltraps
80105a6f:	e9 0c f8 ff ff       	jmp    80105280 <alltraps>

80105a74 <vector98>:
.globl vector98
vector98:
  pushl $0
80105a74:	6a 00                	push   $0x0
  pushl $98
80105a76:	6a 62                	push   $0x62
  jmp alltraps
80105a78:	e9 03 f8 ff ff       	jmp    80105280 <alltraps>

80105a7d <vector99>:
.globl vector99
vector99:
  pushl $0
80105a7d:	6a 00                	push   $0x0
  pushl $99
80105a7f:	6a 63                	push   $0x63
  jmp alltraps
80105a81:	e9 fa f7 ff ff       	jmp    80105280 <alltraps>

80105a86 <vector100>:
.globl vector100
vector100:
  pushl $0
80105a86:	6a 00                	push   $0x0
  pushl $100
80105a88:	6a 64                	push   $0x64
  jmp alltraps
80105a8a:	e9 f1 f7 ff ff       	jmp    80105280 <alltraps>

80105a8f <vector101>:
.globl vector101
vector101:
  pushl $0
80105a8f:	6a 00                	push   $0x0
  pushl $101
80105a91:	6a 65                	push   $0x65
  jmp alltraps
80105a93:	e9 e8 f7 ff ff       	jmp    80105280 <alltraps>

80105a98 <vector102>:
.globl vector102
vector102:
  pushl $0
80105a98:	6a 00                	push   $0x0
  pushl $102
80105a9a:	6a 66                	push   $0x66
  jmp alltraps
80105a9c:	e9 df f7 ff ff       	jmp    80105280 <alltraps>

80105aa1 <vector103>:
.globl vector103
vector103:
  pushl $0
80105aa1:	6a 00                	push   $0x0
  pushl $103
80105aa3:	6a 67                	push   $0x67
  jmp alltraps
80105aa5:	e9 d6 f7 ff ff       	jmp    80105280 <alltraps>

80105aaa <vector104>:
.globl vector104
vector104:
  pushl $0
80105aaa:	6a 00                	push   $0x0
  pushl $104
80105aac:	6a 68                	push   $0x68
  jmp alltraps
80105aae:	e9 cd f7 ff ff       	jmp    80105280 <alltraps>

80105ab3 <vector105>:
.globl vector105
vector105:
  pushl $0
80105ab3:	6a 00                	push   $0x0
  pushl $105
80105ab5:	6a 69                	push   $0x69
  jmp alltraps
80105ab7:	e9 c4 f7 ff ff       	jmp    80105280 <alltraps>

80105abc <vector106>:
.globl vector106
vector106:
  pushl $0
80105abc:	6a 00                	push   $0x0
  pushl $106
80105abe:	6a 6a                	push   $0x6a
  jmp alltraps
80105ac0:	e9 bb f7 ff ff       	jmp    80105280 <alltraps>

80105ac5 <vector107>:
.globl vector107
vector107:
  pushl $0
80105ac5:	6a 00                	push   $0x0
  pushl $107
80105ac7:	6a 6b                	push   $0x6b
  jmp alltraps
80105ac9:	e9 b2 f7 ff ff       	jmp    80105280 <alltraps>

80105ace <vector108>:
.globl vector108
vector108:
  pushl $0
80105ace:	6a 00                	push   $0x0
  pushl $108
80105ad0:	6a 6c                	push   $0x6c
  jmp alltraps
80105ad2:	e9 a9 f7 ff ff       	jmp    80105280 <alltraps>

80105ad7 <vector109>:
.globl vector109
vector109:
  pushl $0
80105ad7:	6a 00                	push   $0x0
  pushl $109
80105ad9:	6a 6d                	push   $0x6d
  jmp alltraps
80105adb:	e9 a0 f7 ff ff       	jmp    80105280 <alltraps>

80105ae0 <vector110>:
.globl vector110
vector110:
  pushl $0
80105ae0:	6a 00                	push   $0x0
  pushl $110
80105ae2:	6a 6e                	push   $0x6e
  jmp alltraps
80105ae4:	e9 97 f7 ff ff       	jmp    80105280 <alltraps>

80105ae9 <vector111>:
.globl vector111
vector111:
  pushl $0
80105ae9:	6a 00                	push   $0x0
  pushl $111
80105aeb:	6a 6f                	push   $0x6f
  jmp alltraps
80105aed:	e9 8e f7 ff ff       	jmp    80105280 <alltraps>

80105af2 <vector112>:
.globl vector112
vector112:
  pushl $0
80105af2:	6a 00                	push   $0x0
  pushl $112
80105af4:	6a 70                	push   $0x70
  jmp alltraps
80105af6:	e9 85 f7 ff ff       	jmp    80105280 <alltraps>

80105afb <vector113>:
.globl vector113
vector113:
  pushl $0
80105afb:	6a 00                	push   $0x0
  pushl $113
80105afd:	6a 71                	push   $0x71
  jmp alltraps
80105aff:	e9 7c f7 ff ff       	jmp    80105280 <alltraps>

80105b04 <vector114>:
.globl vector114
vector114:
  pushl $0
80105b04:	6a 00                	push   $0x0
  pushl $114
80105b06:	6a 72                	push   $0x72
  jmp alltraps
80105b08:	e9 73 f7 ff ff       	jmp    80105280 <alltraps>

80105b0d <vector115>:
.globl vector115
vector115:
  pushl $0
80105b0d:	6a 00                	push   $0x0
  pushl $115
80105b0f:	6a 73                	push   $0x73
  jmp alltraps
80105b11:	e9 6a f7 ff ff       	jmp    80105280 <alltraps>

80105b16 <vector116>:
.globl vector116
vector116:
  pushl $0
80105b16:	6a 00                	push   $0x0
  pushl $116
80105b18:	6a 74                	push   $0x74
  jmp alltraps
80105b1a:	e9 61 f7 ff ff       	jmp    80105280 <alltraps>

80105b1f <vector117>:
.globl vector117
vector117:
  pushl $0
80105b1f:	6a 00                	push   $0x0
  pushl $117
80105b21:	6a 75                	push   $0x75
  jmp alltraps
80105b23:	e9 58 f7 ff ff       	jmp    80105280 <alltraps>

80105b28 <vector118>:
.globl vector118
vector118:
  pushl $0
80105b28:	6a 00                	push   $0x0
  pushl $118
80105b2a:	6a 76                	push   $0x76
  jmp alltraps
80105b2c:	e9 4f f7 ff ff       	jmp    80105280 <alltraps>

80105b31 <vector119>:
.globl vector119
vector119:
  pushl $0
80105b31:	6a 00                	push   $0x0
  pushl $119
80105b33:	6a 77                	push   $0x77
  jmp alltraps
80105b35:	e9 46 f7 ff ff       	jmp    80105280 <alltraps>

80105b3a <vector120>:
.globl vector120
vector120:
  pushl $0
80105b3a:	6a 00                	push   $0x0
  pushl $120
80105b3c:	6a 78                	push   $0x78
  jmp alltraps
80105b3e:	e9 3d f7 ff ff       	jmp    80105280 <alltraps>

80105b43 <vector121>:
.globl vector121
vector121:
  pushl $0
80105b43:	6a 00                	push   $0x0
  pushl $121
80105b45:	6a 79                	push   $0x79
  jmp alltraps
80105b47:	e9 34 f7 ff ff       	jmp    80105280 <alltraps>

80105b4c <vector122>:
.globl vector122
vector122:
  pushl $0
80105b4c:	6a 00                	push   $0x0
  pushl $122
80105b4e:	6a 7a                	push   $0x7a
  jmp alltraps
80105b50:	e9 2b f7 ff ff       	jmp    80105280 <alltraps>

80105b55 <vector123>:
.globl vector123
vector123:
  pushl $0
80105b55:	6a 00                	push   $0x0
  pushl $123
80105b57:	6a 7b                	push   $0x7b
  jmp alltraps
80105b59:	e9 22 f7 ff ff       	jmp    80105280 <alltraps>

80105b5e <vector124>:
.globl vector124
vector124:
  pushl $0
80105b5e:	6a 00                	push   $0x0
  pushl $124
80105b60:	6a 7c                	push   $0x7c
  jmp alltraps
80105b62:	e9 19 f7 ff ff       	jmp    80105280 <alltraps>

80105b67 <vector125>:
.globl vector125
vector125:
  pushl $0
80105b67:	6a 00                	push   $0x0
  pushl $125
80105b69:	6a 7d                	push   $0x7d
  jmp alltraps
80105b6b:	e9 10 f7 ff ff       	jmp    80105280 <alltraps>

80105b70 <vector126>:
.globl vector126
vector126:
  pushl $0
80105b70:	6a 00                	push   $0x0
  pushl $126
80105b72:	6a 7e                	push   $0x7e
  jmp alltraps
80105b74:	e9 07 f7 ff ff       	jmp    80105280 <alltraps>

80105b79 <vector127>:
.globl vector127
vector127:
  pushl $0
80105b79:	6a 00                	push   $0x0
  pushl $127
80105b7b:	6a 7f                	push   $0x7f
  jmp alltraps
80105b7d:	e9 fe f6 ff ff       	jmp    80105280 <alltraps>

80105b82 <vector128>:
.globl vector128
vector128:
  pushl $0
80105b82:	6a 00                	push   $0x0
  pushl $128
80105b84:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105b89:	e9 f2 f6 ff ff       	jmp    80105280 <alltraps>

80105b8e <vector129>:
.globl vector129
vector129:
  pushl $0
80105b8e:	6a 00                	push   $0x0
  pushl $129
80105b90:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105b95:	e9 e6 f6 ff ff       	jmp    80105280 <alltraps>

80105b9a <vector130>:
.globl vector130
vector130:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $130
80105b9c:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105ba1:	e9 da f6 ff ff       	jmp    80105280 <alltraps>

80105ba6 <vector131>:
.globl vector131
vector131:
  pushl $0
80105ba6:	6a 00                	push   $0x0
  pushl $131
80105ba8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105bad:	e9 ce f6 ff ff       	jmp    80105280 <alltraps>

80105bb2 <vector132>:
.globl vector132
vector132:
  pushl $0
80105bb2:	6a 00                	push   $0x0
  pushl $132
80105bb4:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105bb9:	e9 c2 f6 ff ff       	jmp    80105280 <alltraps>

80105bbe <vector133>:
.globl vector133
vector133:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $133
80105bc0:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105bc5:	e9 b6 f6 ff ff       	jmp    80105280 <alltraps>

80105bca <vector134>:
.globl vector134
vector134:
  pushl $0
80105bca:	6a 00                	push   $0x0
  pushl $134
80105bcc:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105bd1:	e9 aa f6 ff ff       	jmp    80105280 <alltraps>

80105bd6 <vector135>:
.globl vector135
vector135:
  pushl $0
80105bd6:	6a 00                	push   $0x0
  pushl $135
80105bd8:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105bdd:	e9 9e f6 ff ff       	jmp    80105280 <alltraps>

80105be2 <vector136>:
.globl vector136
vector136:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $136
80105be4:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105be9:	e9 92 f6 ff ff       	jmp    80105280 <alltraps>

80105bee <vector137>:
.globl vector137
vector137:
  pushl $0
80105bee:	6a 00                	push   $0x0
  pushl $137
80105bf0:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105bf5:	e9 86 f6 ff ff       	jmp    80105280 <alltraps>

80105bfa <vector138>:
.globl vector138
vector138:
  pushl $0
80105bfa:	6a 00                	push   $0x0
  pushl $138
80105bfc:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105c01:	e9 7a f6 ff ff       	jmp    80105280 <alltraps>

80105c06 <vector139>:
.globl vector139
vector139:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $139
80105c08:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105c0d:	e9 6e f6 ff ff       	jmp    80105280 <alltraps>

80105c12 <vector140>:
.globl vector140
vector140:
  pushl $0
80105c12:	6a 00                	push   $0x0
  pushl $140
80105c14:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105c19:	e9 62 f6 ff ff       	jmp    80105280 <alltraps>

80105c1e <vector141>:
.globl vector141
vector141:
  pushl $0
80105c1e:	6a 00                	push   $0x0
  pushl $141
80105c20:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105c25:	e9 56 f6 ff ff       	jmp    80105280 <alltraps>

80105c2a <vector142>:
.globl vector142
vector142:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $142
80105c2c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105c31:	e9 4a f6 ff ff       	jmp    80105280 <alltraps>

80105c36 <vector143>:
.globl vector143
vector143:
  pushl $0
80105c36:	6a 00                	push   $0x0
  pushl $143
80105c38:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105c3d:	e9 3e f6 ff ff       	jmp    80105280 <alltraps>

80105c42 <vector144>:
.globl vector144
vector144:
  pushl $0
80105c42:	6a 00                	push   $0x0
  pushl $144
80105c44:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105c49:	e9 32 f6 ff ff       	jmp    80105280 <alltraps>

80105c4e <vector145>:
.globl vector145
vector145:
  pushl $0
80105c4e:	6a 00                	push   $0x0
  pushl $145
80105c50:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105c55:	e9 26 f6 ff ff       	jmp    80105280 <alltraps>

80105c5a <vector146>:
.globl vector146
vector146:
  pushl $0
80105c5a:	6a 00                	push   $0x0
  pushl $146
80105c5c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105c61:	e9 1a f6 ff ff       	jmp    80105280 <alltraps>

80105c66 <vector147>:
.globl vector147
vector147:
  pushl $0
80105c66:	6a 00                	push   $0x0
  pushl $147
80105c68:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105c6d:	e9 0e f6 ff ff       	jmp    80105280 <alltraps>

80105c72 <vector148>:
.globl vector148
vector148:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $148
80105c74:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105c79:	e9 02 f6 ff ff       	jmp    80105280 <alltraps>

80105c7e <vector149>:
.globl vector149
vector149:
  pushl $0
80105c7e:	6a 00                	push   $0x0
  pushl $149
80105c80:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105c85:	e9 f6 f5 ff ff       	jmp    80105280 <alltraps>

80105c8a <vector150>:
.globl vector150
vector150:
  pushl $0
80105c8a:	6a 00                	push   $0x0
  pushl $150
80105c8c:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105c91:	e9 ea f5 ff ff       	jmp    80105280 <alltraps>

80105c96 <vector151>:
.globl vector151
vector151:
  pushl $0
80105c96:	6a 00                	push   $0x0
  pushl $151
80105c98:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105c9d:	e9 de f5 ff ff       	jmp    80105280 <alltraps>

80105ca2 <vector152>:
.globl vector152
vector152:
  pushl $0
80105ca2:	6a 00                	push   $0x0
  pushl $152
80105ca4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105ca9:	e9 d2 f5 ff ff       	jmp    80105280 <alltraps>

80105cae <vector153>:
.globl vector153
vector153:
  pushl $0
80105cae:	6a 00                	push   $0x0
  pushl $153
80105cb0:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105cb5:	e9 c6 f5 ff ff       	jmp    80105280 <alltraps>

80105cba <vector154>:
.globl vector154
vector154:
  pushl $0
80105cba:	6a 00                	push   $0x0
  pushl $154
80105cbc:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105cc1:	e9 ba f5 ff ff       	jmp    80105280 <alltraps>

80105cc6 <vector155>:
.globl vector155
vector155:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $155
80105cc8:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105ccd:	e9 ae f5 ff ff       	jmp    80105280 <alltraps>

80105cd2 <vector156>:
.globl vector156
vector156:
  pushl $0
80105cd2:	6a 00                	push   $0x0
  pushl $156
80105cd4:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105cd9:	e9 a2 f5 ff ff       	jmp    80105280 <alltraps>

80105cde <vector157>:
.globl vector157
vector157:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $157
80105ce0:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105ce5:	e9 96 f5 ff ff       	jmp    80105280 <alltraps>

80105cea <vector158>:
.globl vector158
vector158:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $158
80105cec:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105cf1:	e9 8a f5 ff ff       	jmp    80105280 <alltraps>

80105cf6 <vector159>:
.globl vector159
vector159:
  pushl $0
80105cf6:	6a 00                	push   $0x0
  pushl $159
80105cf8:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105cfd:	e9 7e f5 ff ff       	jmp    80105280 <alltraps>

80105d02 <vector160>:
.globl vector160
vector160:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $160
80105d04:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105d09:	e9 72 f5 ff ff       	jmp    80105280 <alltraps>

80105d0e <vector161>:
.globl vector161
vector161:
  pushl $0
80105d0e:	6a 00                	push   $0x0
  pushl $161
80105d10:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105d15:	e9 66 f5 ff ff       	jmp    80105280 <alltraps>

80105d1a <vector162>:
.globl vector162
vector162:
  pushl $0
80105d1a:	6a 00                	push   $0x0
  pushl $162
80105d1c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105d21:	e9 5a f5 ff ff       	jmp    80105280 <alltraps>

80105d26 <vector163>:
.globl vector163
vector163:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $163
80105d28:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105d2d:	e9 4e f5 ff ff       	jmp    80105280 <alltraps>

80105d32 <vector164>:
.globl vector164
vector164:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $164
80105d34:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105d39:	e9 42 f5 ff ff       	jmp    80105280 <alltraps>

80105d3e <vector165>:
.globl vector165
vector165:
  pushl $0
80105d3e:	6a 00                	push   $0x0
  pushl $165
80105d40:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105d45:	e9 36 f5 ff ff       	jmp    80105280 <alltraps>

80105d4a <vector166>:
.globl vector166
vector166:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $166
80105d4c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105d51:	e9 2a f5 ff ff       	jmp    80105280 <alltraps>

80105d56 <vector167>:
.globl vector167
vector167:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $167
80105d58:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105d5d:	e9 1e f5 ff ff       	jmp    80105280 <alltraps>

80105d62 <vector168>:
.globl vector168
vector168:
  pushl $0
80105d62:	6a 00                	push   $0x0
  pushl $168
80105d64:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105d69:	e9 12 f5 ff ff       	jmp    80105280 <alltraps>

80105d6e <vector169>:
.globl vector169
vector169:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $169
80105d70:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105d75:	e9 06 f5 ff ff       	jmp    80105280 <alltraps>

80105d7a <vector170>:
.globl vector170
vector170:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $170
80105d7c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105d81:	e9 fa f4 ff ff       	jmp    80105280 <alltraps>

80105d86 <vector171>:
.globl vector171
vector171:
  pushl $0
80105d86:	6a 00                	push   $0x0
  pushl $171
80105d88:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105d8d:	e9 ee f4 ff ff       	jmp    80105280 <alltraps>

80105d92 <vector172>:
.globl vector172
vector172:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $172
80105d94:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105d99:	e9 e2 f4 ff ff       	jmp    80105280 <alltraps>

80105d9e <vector173>:
.globl vector173
vector173:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $173
80105da0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105da5:	e9 d6 f4 ff ff       	jmp    80105280 <alltraps>

80105daa <vector174>:
.globl vector174
vector174:
  pushl $0
80105daa:	6a 00                	push   $0x0
  pushl $174
80105dac:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105db1:	e9 ca f4 ff ff       	jmp    80105280 <alltraps>

80105db6 <vector175>:
.globl vector175
vector175:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $175
80105db8:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105dbd:	e9 be f4 ff ff       	jmp    80105280 <alltraps>

80105dc2 <vector176>:
.globl vector176
vector176:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $176
80105dc4:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105dc9:	e9 b2 f4 ff ff       	jmp    80105280 <alltraps>

80105dce <vector177>:
.globl vector177
vector177:
  pushl $0
80105dce:	6a 00                	push   $0x0
  pushl $177
80105dd0:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105dd5:	e9 a6 f4 ff ff       	jmp    80105280 <alltraps>

80105dda <vector178>:
.globl vector178
vector178:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $178
80105ddc:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105de1:	e9 9a f4 ff ff       	jmp    80105280 <alltraps>

80105de6 <vector179>:
.globl vector179
vector179:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $179
80105de8:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105ded:	e9 8e f4 ff ff       	jmp    80105280 <alltraps>

80105df2 <vector180>:
.globl vector180
vector180:
  pushl $0
80105df2:	6a 00                	push   $0x0
  pushl $180
80105df4:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105df9:	e9 82 f4 ff ff       	jmp    80105280 <alltraps>

80105dfe <vector181>:
.globl vector181
vector181:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $181
80105e00:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105e05:	e9 76 f4 ff ff       	jmp    80105280 <alltraps>

80105e0a <vector182>:
.globl vector182
vector182:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $182
80105e0c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105e11:	e9 6a f4 ff ff       	jmp    80105280 <alltraps>

80105e16 <vector183>:
.globl vector183
vector183:
  pushl $0
80105e16:	6a 00                	push   $0x0
  pushl $183
80105e18:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105e1d:	e9 5e f4 ff ff       	jmp    80105280 <alltraps>

80105e22 <vector184>:
.globl vector184
vector184:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $184
80105e24:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105e29:	e9 52 f4 ff ff       	jmp    80105280 <alltraps>

80105e2e <vector185>:
.globl vector185
vector185:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $185
80105e30:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105e35:	e9 46 f4 ff ff       	jmp    80105280 <alltraps>

80105e3a <vector186>:
.globl vector186
vector186:
  pushl $0
80105e3a:	6a 00                	push   $0x0
  pushl $186
80105e3c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105e41:	e9 3a f4 ff ff       	jmp    80105280 <alltraps>

80105e46 <vector187>:
.globl vector187
vector187:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $187
80105e48:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105e4d:	e9 2e f4 ff ff       	jmp    80105280 <alltraps>

80105e52 <vector188>:
.globl vector188
vector188:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $188
80105e54:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105e59:	e9 22 f4 ff ff       	jmp    80105280 <alltraps>

80105e5e <vector189>:
.globl vector189
vector189:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $189
80105e60:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105e65:	e9 16 f4 ff ff       	jmp    80105280 <alltraps>

80105e6a <vector190>:
.globl vector190
vector190:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $190
80105e6c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105e71:	e9 0a f4 ff ff       	jmp    80105280 <alltraps>

80105e76 <vector191>:
.globl vector191
vector191:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $191
80105e78:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105e7d:	e9 fe f3 ff ff       	jmp    80105280 <alltraps>

80105e82 <vector192>:
.globl vector192
vector192:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $192
80105e84:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105e89:	e9 f2 f3 ff ff       	jmp    80105280 <alltraps>

80105e8e <vector193>:
.globl vector193
vector193:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $193
80105e90:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105e95:	e9 e6 f3 ff ff       	jmp    80105280 <alltraps>

80105e9a <vector194>:
.globl vector194
vector194:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $194
80105e9c:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105ea1:	e9 da f3 ff ff       	jmp    80105280 <alltraps>

80105ea6 <vector195>:
.globl vector195
vector195:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $195
80105ea8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105ead:	e9 ce f3 ff ff       	jmp    80105280 <alltraps>

80105eb2 <vector196>:
.globl vector196
vector196:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $196
80105eb4:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105eb9:	e9 c2 f3 ff ff       	jmp    80105280 <alltraps>

80105ebe <vector197>:
.globl vector197
vector197:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $197
80105ec0:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105ec5:	e9 b6 f3 ff ff       	jmp    80105280 <alltraps>

80105eca <vector198>:
.globl vector198
vector198:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $198
80105ecc:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105ed1:	e9 aa f3 ff ff       	jmp    80105280 <alltraps>

80105ed6 <vector199>:
.globl vector199
vector199:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $199
80105ed8:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105edd:	e9 9e f3 ff ff       	jmp    80105280 <alltraps>

80105ee2 <vector200>:
.globl vector200
vector200:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $200
80105ee4:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105ee9:	e9 92 f3 ff ff       	jmp    80105280 <alltraps>

80105eee <vector201>:
.globl vector201
vector201:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $201
80105ef0:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105ef5:	e9 86 f3 ff ff       	jmp    80105280 <alltraps>

80105efa <vector202>:
.globl vector202
vector202:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $202
80105efc:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105f01:	e9 7a f3 ff ff       	jmp    80105280 <alltraps>

80105f06 <vector203>:
.globl vector203
vector203:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $203
80105f08:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105f0d:	e9 6e f3 ff ff       	jmp    80105280 <alltraps>

80105f12 <vector204>:
.globl vector204
vector204:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $204
80105f14:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105f19:	e9 62 f3 ff ff       	jmp    80105280 <alltraps>

80105f1e <vector205>:
.globl vector205
vector205:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $205
80105f20:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105f25:	e9 56 f3 ff ff       	jmp    80105280 <alltraps>

80105f2a <vector206>:
.globl vector206
vector206:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $206
80105f2c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105f31:	e9 4a f3 ff ff       	jmp    80105280 <alltraps>

80105f36 <vector207>:
.globl vector207
vector207:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $207
80105f38:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105f3d:	e9 3e f3 ff ff       	jmp    80105280 <alltraps>

80105f42 <vector208>:
.globl vector208
vector208:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $208
80105f44:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105f49:	e9 32 f3 ff ff       	jmp    80105280 <alltraps>

80105f4e <vector209>:
.globl vector209
vector209:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $209
80105f50:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105f55:	e9 26 f3 ff ff       	jmp    80105280 <alltraps>

80105f5a <vector210>:
.globl vector210
vector210:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $210
80105f5c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105f61:	e9 1a f3 ff ff       	jmp    80105280 <alltraps>

80105f66 <vector211>:
.globl vector211
vector211:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $211
80105f68:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105f6d:	e9 0e f3 ff ff       	jmp    80105280 <alltraps>

80105f72 <vector212>:
.globl vector212
vector212:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $212
80105f74:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105f79:	e9 02 f3 ff ff       	jmp    80105280 <alltraps>

80105f7e <vector213>:
.globl vector213
vector213:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $213
80105f80:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105f85:	e9 f6 f2 ff ff       	jmp    80105280 <alltraps>

80105f8a <vector214>:
.globl vector214
vector214:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $214
80105f8c:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105f91:	e9 ea f2 ff ff       	jmp    80105280 <alltraps>

80105f96 <vector215>:
.globl vector215
vector215:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $215
80105f98:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105f9d:	e9 de f2 ff ff       	jmp    80105280 <alltraps>

80105fa2 <vector216>:
.globl vector216
vector216:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $216
80105fa4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105fa9:	e9 d2 f2 ff ff       	jmp    80105280 <alltraps>

80105fae <vector217>:
.globl vector217
vector217:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $217
80105fb0:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105fb5:	e9 c6 f2 ff ff       	jmp    80105280 <alltraps>

80105fba <vector218>:
.globl vector218
vector218:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $218
80105fbc:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105fc1:	e9 ba f2 ff ff       	jmp    80105280 <alltraps>

80105fc6 <vector219>:
.globl vector219
vector219:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $219
80105fc8:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105fcd:	e9 ae f2 ff ff       	jmp    80105280 <alltraps>

80105fd2 <vector220>:
.globl vector220
vector220:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $220
80105fd4:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105fd9:	e9 a2 f2 ff ff       	jmp    80105280 <alltraps>

80105fde <vector221>:
.globl vector221
vector221:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $221
80105fe0:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105fe5:	e9 96 f2 ff ff       	jmp    80105280 <alltraps>

80105fea <vector222>:
.globl vector222
vector222:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $222
80105fec:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105ff1:	e9 8a f2 ff ff       	jmp    80105280 <alltraps>

80105ff6 <vector223>:
.globl vector223
vector223:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $223
80105ff8:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105ffd:	e9 7e f2 ff ff       	jmp    80105280 <alltraps>

80106002 <vector224>:
.globl vector224
vector224:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $224
80106004:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106009:	e9 72 f2 ff ff       	jmp    80105280 <alltraps>

8010600e <vector225>:
.globl vector225
vector225:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $225
80106010:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106015:	e9 66 f2 ff ff       	jmp    80105280 <alltraps>

8010601a <vector226>:
.globl vector226
vector226:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $226
8010601c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106021:	e9 5a f2 ff ff       	jmp    80105280 <alltraps>

80106026 <vector227>:
.globl vector227
vector227:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $227
80106028:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010602d:	e9 4e f2 ff ff       	jmp    80105280 <alltraps>

80106032 <vector228>:
.globl vector228
vector228:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $228
80106034:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106039:	e9 42 f2 ff ff       	jmp    80105280 <alltraps>

8010603e <vector229>:
.globl vector229
vector229:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $229
80106040:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106045:	e9 36 f2 ff ff       	jmp    80105280 <alltraps>

8010604a <vector230>:
.globl vector230
vector230:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $230
8010604c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106051:	e9 2a f2 ff ff       	jmp    80105280 <alltraps>

80106056 <vector231>:
.globl vector231
vector231:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $231
80106058:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010605d:	e9 1e f2 ff ff       	jmp    80105280 <alltraps>

80106062 <vector232>:
.globl vector232
vector232:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $232
80106064:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106069:	e9 12 f2 ff ff       	jmp    80105280 <alltraps>

8010606e <vector233>:
.globl vector233
vector233:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $233
80106070:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106075:	e9 06 f2 ff ff       	jmp    80105280 <alltraps>

8010607a <vector234>:
.globl vector234
vector234:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $234
8010607c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106081:	e9 fa f1 ff ff       	jmp    80105280 <alltraps>

80106086 <vector235>:
.globl vector235
vector235:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $235
80106088:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010608d:	e9 ee f1 ff ff       	jmp    80105280 <alltraps>

80106092 <vector236>:
.globl vector236
vector236:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $236
80106094:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106099:	e9 e2 f1 ff ff       	jmp    80105280 <alltraps>

8010609e <vector237>:
.globl vector237
vector237:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $237
801060a0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801060a5:	e9 d6 f1 ff ff       	jmp    80105280 <alltraps>

801060aa <vector238>:
.globl vector238
vector238:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $238
801060ac:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801060b1:	e9 ca f1 ff ff       	jmp    80105280 <alltraps>

801060b6 <vector239>:
.globl vector239
vector239:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $239
801060b8:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801060bd:	e9 be f1 ff ff       	jmp    80105280 <alltraps>

801060c2 <vector240>:
.globl vector240
vector240:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $240
801060c4:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801060c9:	e9 b2 f1 ff ff       	jmp    80105280 <alltraps>

801060ce <vector241>:
.globl vector241
vector241:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $241
801060d0:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801060d5:	e9 a6 f1 ff ff       	jmp    80105280 <alltraps>

801060da <vector242>:
.globl vector242
vector242:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $242
801060dc:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801060e1:	e9 9a f1 ff ff       	jmp    80105280 <alltraps>

801060e6 <vector243>:
.globl vector243
vector243:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $243
801060e8:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801060ed:	e9 8e f1 ff ff       	jmp    80105280 <alltraps>

801060f2 <vector244>:
.globl vector244
vector244:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $244
801060f4:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801060f9:	e9 82 f1 ff ff       	jmp    80105280 <alltraps>

801060fe <vector245>:
.globl vector245
vector245:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $245
80106100:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106105:	e9 76 f1 ff ff       	jmp    80105280 <alltraps>

8010610a <vector246>:
.globl vector246
vector246:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $246
8010610c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106111:	e9 6a f1 ff ff       	jmp    80105280 <alltraps>

80106116 <vector247>:
.globl vector247
vector247:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $247
80106118:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010611d:	e9 5e f1 ff ff       	jmp    80105280 <alltraps>

80106122 <vector248>:
.globl vector248
vector248:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $248
80106124:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106129:	e9 52 f1 ff ff       	jmp    80105280 <alltraps>

8010612e <vector249>:
.globl vector249
vector249:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $249
80106130:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106135:	e9 46 f1 ff ff       	jmp    80105280 <alltraps>

8010613a <vector250>:
.globl vector250
vector250:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $250
8010613c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106141:	e9 3a f1 ff ff       	jmp    80105280 <alltraps>

80106146 <vector251>:
.globl vector251
vector251:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $251
80106148:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010614d:	e9 2e f1 ff ff       	jmp    80105280 <alltraps>

80106152 <vector252>:
.globl vector252
vector252:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $252
80106154:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106159:	e9 22 f1 ff ff       	jmp    80105280 <alltraps>

8010615e <vector253>:
.globl vector253
vector253:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $253
80106160:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106165:	e9 16 f1 ff ff       	jmp    80105280 <alltraps>

8010616a <vector254>:
.globl vector254
vector254:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $254
8010616c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106171:	e9 0a f1 ff ff       	jmp    80105280 <alltraps>

80106176 <vector255>:
.globl vector255
vector255:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $255
80106178:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010617d:	e9 fe f0 ff ff       	jmp    80105280 <alltraps>
	...

80106190 <switchkvm>:
}

static inline void
lcr3(uint val) 
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106190:	a1 78 16 11 80       	mov    0x80111678,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106195:	55                   	push   %ebp
80106196:	89 e5                	mov    %esp,%ebp
80106198:	2d 00 00 00 80       	sub    $0x80000000,%eax
8010619d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(v2p(kpgdir));   // switch to the kernel page table
}
801061a0:	5d                   	pop    %ebp
801061a1:	c3                   	ret    
801061a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	83 ec 28             	sub    $0x28,%esp
801061b6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801061b9:	89 d3                	mov    %edx,%ebx
801061bb:	c1 eb 16             	shr    $0x16,%ebx
801061be:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801061c1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801061c4:	8b 33                	mov    (%ebx),%esi
801061c6:	f7 c6 01 00 00 00    	test   $0x1,%esi
801061cc:	74 22                	je     801061f0 <walkpgdir+0x40>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801061ce:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801061d4:	81 ee 00 00 00 80    	sub    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801061da:	c1 ea 0a             	shr    $0xa,%edx
801061dd:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801061e3:	8d 04 16             	lea    (%esi,%edx,1),%eax
}
801061e6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801061e9:	8b 75 fc             	mov    -0x4(%ebp),%esi
801061ec:	89 ec                	mov    %ebp,%esp
801061ee:	5d                   	pop    %ebp
801061ef:	c3                   	ret    

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801061f0:	85 c9                	test   %ecx,%ecx
801061f2:	75 04                	jne    801061f8 <walkpgdir+0x48>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801061f4:	31 c0                	xor    %eax,%eax
801061f6:	eb ee                	jmp    801061e6 <walkpgdir+0x36>

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801061f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
801061fb:	e8 90 c0 ff ff       	call   80102290 <kalloc>
80106200:	85 c0                	test   %eax,%eax
80106202:	89 c6                	mov    %eax,%esi
80106204:	74 ee                	je     801061f4 <walkpgdir+0x44>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106206:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010620d:	00 
8010620e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106215:	00 
80106216:	89 04 24             	mov    %eax,(%esp)
80106219:	e8 d2 dd ff ff       	call   80103ff0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
8010621e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106224:	83 c8 07             	or     $0x7,%eax
80106227:	89 03                	mov    %eax,(%ebx)
80106229:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010622c:	eb ac                	jmp    801061da <walkpgdir+0x2a>
8010622e:	66 90                	xchg   %ax,%ax

80106230 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106230:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106231:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106233:	89 e5                	mov    %esp,%ebp
80106235:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106238:	8b 55 0c             	mov    0xc(%ebp),%edx
8010623b:	8b 45 08             	mov    0x8(%ebp),%eax
8010623e:	e8 6d ff ff ff       	call   801061b0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106243:	8b 00                	mov    (%eax),%eax
80106245:	a8 01                	test   $0x1,%al
80106247:	75 07                	jne    80106250 <uva2ka+0x20>
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)p2v(PTE_ADDR(*pte));
80106249:	31 c0                	xor    %eax,%eax
}
8010624b:	c9                   	leave  
8010624c:	c3                   	ret    
8010624d:	8d 76 00             	lea    0x0(%esi),%esi
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
80106250:	a8 04                	test   $0x4,%al
80106252:	74 f5                	je     80106249 <uva2ka+0x19>
    return 0;
  return (char*)p2v(PTE_ADDR(*pte));
80106254:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106259:	2d 00 00 00 80       	sub    $0x80000000,%eax
}
8010625e:	c9                   	leave  
8010625f:	c3                   	ret    

80106260 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	57                   	push   %edi
80106264:	56                   	push   %esi
80106265:	53                   	push   %ebx
80106266:	83 ec 2c             	sub    $0x2c,%esp
80106269:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010626c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010626f:	85 db                	test   %ebx,%ebx
80106271:	74 75                	je     801062e8 <copyout+0x88>
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80106273:	8b 45 10             	mov    0x10(%ebp),%eax
80106276:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106279:	eb 39                	jmp    801062b4 <copyout+0x54>
8010627b:	90                   	nop
8010627c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106280:	89 f7                	mov    %esi,%edi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106282:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106285:	29 d7                	sub    %edx,%edi
80106287:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010628d:	39 df                	cmp    %ebx,%edi
8010628f:	0f 47 fb             	cmova  %ebx,%edi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106292:	29 f2                	sub    %esi,%edx
80106294:	8d 14 10             	lea    (%eax,%edx,1),%edx
80106297:	89 7c 24 08          	mov    %edi,0x8(%esp)
8010629b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
8010629f:	89 14 24             	mov    %edx,(%esp)
801062a2:	e8 19 de ff ff       	call   801040c0 <memmove>
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801062a7:	29 fb                	sub    %edi,%ebx
801062a9:	74 3d                	je     801062e8 <copyout+0x88>
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
801062ab:	01 7d e4             	add    %edi,-0x1c(%ebp)
    va = va0 + PGSIZE;
801062ae:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
801062b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801062b7:	89 d6                	mov    %edx,%esi
801062b9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801062bf:	89 55 e0             	mov    %edx,-0x20(%ebp)
801062c2:	89 74 24 04          	mov    %esi,0x4(%esp)
801062c6:	89 0c 24             	mov    %ecx,(%esp)
801062c9:	e8 62 ff ff ff       	call   80106230 <uva2ka>
    if(pa0 == 0)
801062ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
801062d1:	85 c0                	test   %eax,%eax
801062d3:	75 ab                	jne    80106280 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801062d5:	83 c4 2c             	add    $0x2c,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
801062d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801062dd:	5b                   	pop    %ebx
801062de:	5e                   	pop    %esi
801062df:	5f                   	pop    %edi
801062e0:	5d                   	pop    %ebp
801062e1:	c3                   	ret    
801062e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801062e8:	83 c4 2c             	add    $0x2c,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
801062eb:	31 c0                	xor    %eax,%eax
  }
  return 0;
}
801062ed:	5b                   	pop    %ebx
801062ee:	5e                   	pop    %esi
801062ef:	5f                   	pop    %edi
801062f0:	5d                   	pop    %ebp
801062f1:	c3                   	ret    
801062f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106300 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106300:	55                   	push   %ebp
80106301:	89 e5                	mov    %esp,%ebp
80106303:	57                   	push   %edi
80106304:	56                   	push   %esi
80106305:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80106306:	89 d3                	mov    %edx,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106308:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010630c:	83 ec 2c             	sub    $0x2c,%esp
8010630f:	8b 75 08             	mov    0x8(%ebp),%esi
80106312:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80106315:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010631b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106321:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
80106325:	eb 1d                	jmp    80106344 <mappages+0x44>
80106327:	90                   	nop
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106328:	f6 00 01             	testb  $0x1,(%eax)
8010632b:	75 45                	jne    80106372 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
8010632d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106330:	09 f2                	or     %esi,%edx
    if(a == last)
80106332:	39 fb                	cmp    %edi,%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106334:	89 10                	mov    %edx,(%eax)
    if(a == last)
80106336:	74 30                	je     80106368 <mappages+0x68>
      break;
    a += PGSIZE;
80106338:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
8010633e:	81 c6 00 10 00 00    	add    $0x1000,%esi
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106344:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106347:	b9 01 00 00 00       	mov    $0x1,%ecx
8010634c:	89 da                	mov    %ebx,%edx
8010634e:	e8 5d fe ff ff       	call   801061b0 <walkpgdir>
80106353:	85 c0                	test   %eax,%eax
80106355:	75 d1                	jne    80106328 <mappages+0x28>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106357:	83 c4 2c             	add    $0x2c,%esp
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
8010635a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
8010635f:	5b                   	pop    %ebx
80106360:	5e                   	pop    %esi
80106361:	5f                   	pop    %edi
80106362:	5d                   	pop    %ebp
80106363:	c3                   	ret    
80106364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106368:	83 c4 2c             	add    $0x2c,%esp
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
8010636b:	31 c0                	xor    %eax,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010636d:	5b                   	pop    %ebx
8010636e:	5e                   	pop    %esi
8010636f:	5f                   	pop    %edi
80106370:	5d                   	pop    %ebp
80106371:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106372:	c7 04 24 74 72 10 80 	movl   $0x80107274,(%esp)
80106379:	e8 02 a4 ff ff       	call   80100780 <panic>
8010637e:	66 90                	xchg   %ax,%ax

80106380 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	56                   	push   %esi
80106384:	53                   	push   %ebx
80106385:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106388:	e8 03 bf ff ff       	call   80102290 <kalloc>
8010638d:	85 c0                	test   %eax,%eax
8010638f:	89 c6                	mov    %eax,%esi
80106391:	74 53                	je     801063e6 <setupkvm+0x66>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106393:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010639a:	00 
8010639b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801063a2:	00 
801063a3:	89 04 24             	mov    %eax,(%esp)
801063a6:	e8 45 dc ff ff       	call   80103ff0 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801063ab:	b8 60 a4 10 80       	mov    $0x8010a460,%eax
801063b0:	3d 20 a4 10 80       	cmp    $0x8010a420,%eax
801063b5:	76 2f                	jbe    801063e6 <setupkvm+0x66>
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
801063b7:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801063bc:	8b 53 0c             	mov    0xc(%ebx),%edx
801063bf:	8b 43 04             	mov    0x4(%ebx),%eax
801063c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801063c5:	89 54 24 04          	mov    %edx,0x4(%esp)
801063c9:	8b 13                	mov    (%ebx),%edx
801063cb:	89 04 24             	mov    %eax,(%esp)
801063ce:	29 c1                	sub    %eax,%ecx
801063d0:	89 f0                	mov    %esi,%eax
801063d2:	e8 29 ff ff ff       	call   80106300 <mappages>
801063d7:	85 c0                	test   %eax,%eax
801063d9:	78 15                	js     801063f0 <setupkvm+0x70>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801063db:	83 c3 10             	add    $0x10,%ebx
801063de:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801063e4:	75 d6                	jne    801063bc <setupkvm+0x3c>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801063e6:	83 c4 10             	add    $0x10,%esp
801063e9:	89 f0                	mov    %esi,%eax
801063eb:	5b                   	pop    %ebx
801063ec:	5e                   	pop    %esi
801063ed:	5d                   	pop    %ebp
801063ee:	c3                   	ret    
801063ef:	90                   	nop
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801063f0:	31 f6                	xor    %esi,%esi
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801063f2:	83 c4 10             	add    $0x10,%esp
801063f5:	89 f0                	mov    %esi,%eax
801063f7:	5b                   	pop    %ebx
801063f8:	5e                   	pop    %esi
801063f9:	5d                   	pop    %ebp
801063fa:	c3                   	ret    
801063fb:	90                   	nop
801063fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106400 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106400:	55                   	push   %ebp
80106401:	89 e5                	mov    %esp,%ebp
80106403:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106406:	e8 75 ff ff ff       	call   80106380 <setupkvm>
8010640b:	a3 78 16 11 80       	mov    %eax,0x80111678
80106410:	2d 00 00 00 80       	sub    $0x80000000,%eax
80106415:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106418:	c9                   	leave  
80106419:	c3                   	ret    
8010641a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106420 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106420:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106421:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106423:	89 e5                	mov    %esp,%ebp
80106425:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106428:	8b 55 0c             	mov    0xc(%ebp),%edx
8010642b:	8b 45 08             	mov    0x8(%ebp),%eax
8010642e:	e8 7d fd ff ff       	call   801061b0 <walkpgdir>
  if(pte == 0)
80106433:	85 c0                	test   %eax,%eax
80106435:	74 05                	je     8010643c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106437:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010643a:	c9                   	leave  
8010643b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010643c:	c7 04 24 7a 72 10 80 	movl   $0x8010727a,(%esp)
80106443:	e8 38 a3 ff ff       	call   80100780 <panic>
80106448:	90                   	nop
80106449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106450 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	83 ec 38             	sub    $0x38,%esp
80106456:	89 75 f8             	mov    %esi,-0x8(%ebp)
80106459:	8b 75 10             	mov    0x10(%ebp),%esi
8010645c:	8b 45 08             	mov    0x8(%ebp),%eax
8010645f:	89 7d fc             	mov    %edi,-0x4(%ebp)
80106462:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106465:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  char *mem;
  
  if(sz >= PGSIZE)
80106468:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010646e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;
  
  if(sz >= PGSIZE)
80106471:	77 59                	ja     801064cc <inituvm+0x7c>
    panic("inituvm: more than a page");
  mem = kalloc();
80106473:	e8 18 be ff ff       	call   80102290 <kalloc>
  memset(mem, 0, PGSIZE);
80106478:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010647f:	00 
80106480:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106487:	00 
{
  char *mem;
  
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106488:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010648a:	89 04 24             	mov    %eax,(%esp)
8010648d:	e8 5e db ff ff       	call   80103ff0 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80106492:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106498:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010649d:	89 04 24             	mov    %eax,(%esp)
801064a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064a3:	31 d2                	xor    %edx,%edx
801064a5:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
801064ac:	00 
801064ad:	e8 4e fe ff ff       	call   80106300 <mappages>
  memmove(mem, init, sz);
801064b2:	89 75 10             	mov    %esi,0x10(%ebp)
}
801064b5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801064b8:	89 7d 0c             	mov    %edi,0xc(%ebp)
}
801064bb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801064be:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801064c1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801064c4:	89 ec                	mov    %ebp,%esp
801064c6:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801064c7:	e9 f4 db ff ff       	jmp    801040c0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;
  
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801064cc:	c7 04 24 84 72 10 80 	movl   $0x80107284,(%esp)
801064d3:	e8 a8 a2 ff ff       	call   80100780 <panic>
801064d8:	90                   	nop
801064d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064e0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801064e0:	55                   	push   %ebp
801064e1:	89 e5                	mov    %esp,%ebp
801064e3:	57                   	push   %edi
801064e4:	56                   	push   %esi
801064e5:	53                   	push   %ebx
801064e6:	83 ec 2c             	sub    $0x2c,%esp
801064e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801064ec:	39 75 10             	cmp    %esi,0x10(%ebp)
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801064ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
801064f2:	89 f0                	mov    %esi,%eax
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801064f4:	73 75                	jae    8010656b <deallocuvm+0x8b>
    return oldsz;

  a = PGROUNDUP(newsz);
801064f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801064f9:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
801064ff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106505:	39 de                	cmp    %ebx,%esi
80106507:	77 3a                	ja     80106543 <deallocuvm+0x63>
80106509:	eb 5d                	jmp    80106568 <deallocuvm+0x88>
8010650b:	90                   	nop
8010650c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
80106510:	8b 10                	mov    (%eax),%edx
80106512:	f6 c2 01             	test   $0x1,%dl
80106515:	74 22                	je     80106539 <deallocuvm+0x59>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106517:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010651d:	74 54                	je     80106573 <deallocuvm+0x93>
        panic("kfree");
      char *v = p2v(pa);
      kfree(v);
8010651f:	81 ea 00 00 00 80    	sub    $0x80000000,%edx
80106525:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106528:	89 14 24             	mov    %edx,(%esp)
8010652b:	e8 b0 bd ff ff       	call   801022e0 <kfree>
      *pte = 0;
80106530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106533:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106539:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010653f:	39 de                	cmp    %ebx,%esi
80106541:	76 25                	jbe    80106568 <deallocuvm+0x88>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106543:	31 c9                	xor    %ecx,%ecx
80106545:	89 da                	mov    %ebx,%edx
80106547:	89 f8                	mov    %edi,%eax
80106549:	e8 62 fc ff ff       	call   801061b0 <walkpgdir>
    if(!pte)
8010654e:	85 c0                	test   %eax,%eax
80106550:	75 be                	jne    80106510 <deallocuvm+0x30>
      a += (NPTENTRIES - 1) * PGSIZE;
80106552:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106558:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010655e:	39 de                	cmp    %ebx,%esi
80106560:	77 e1                	ja     80106543 <deallocuvm+0x63>
80106562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80106568:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010656b:	83 c4 2c             	add    $0x2c,%esp
8010656e:	5b                   	pop    %ebx
8010656f:	5e                   	pop    %esi
80106570:	5f                   	pop    %edi
80106571:	5d                   	pop    %ebp
80106572:	c3                   	ret    
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106573:	c7 04 24 2e 6c 10 80 	movl   $0x80106c2e,(%esp)
8010657a:	e8 01 a2 ff ff       	call   80100780 <panic>
8010657f:	90                   	nop

80106580 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	56                   	push   %esi
80106584:	53                   	push   %ebx
80106585:	83 ec 10             	sub    $0x10,%esp
80106588:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint i;

  if(pgdir == 0)
8010658b:	85 db                	test   %ebx,%ebx
8010658d:	74 5e                	je     801065ed <freevm+0x6d>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
8010658f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106596:	00 
80106597:	31 f6                	xor    %esi,%esi
80106599:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
801065a0:	80 
801065a1:	89 1c 24             	mov    %ebx,(%esp)
801065a4:	e8 37 ff ff ff       	call   801064e0 <deallocuvm>
801065a9:	eb 10                	jmp    801065bb <freevm+0x3b>
801065ab:	90                   	nop
801065ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < NPDENTRIES; i++){
801065b0:	83 c6 01             	add    $0x1,%esi
801065b3:	81 fe 00 04 00 00    	cmp    $0x400,%esi
801065b9:	74 24                	je     801065df <freevm+0x5f>
    if(pgdir[i] & PTE_P){
801065bb:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
801065be:	a8 01                	test   $0x1,%al
801065c0:	74 ee                	je     801065b0 <freevm+0x30>
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
801065c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801065c7:	83 c6 01             	add    $0x1,%esi
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
801065ca:	2d 00 00 00 80       	sub    $0x80000000,%eax
801065cf:	89 04 24             	mov    %eax,(%esp)
801065d2:	e8 09 bd ff ff       	call   801022e0 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801065d7:	81 fe 00 04 00 00    	cmp    $0x400,%esi
801065dd:	75 dc                	jne    801065bb <freevm+0x3b>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801065df:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801065e2:	83 c4 10             	add    $0x10,%esp
801065e5:	5b                   	pop    %ebx
801065e6:	5e                   	pop    %esi
801065e7:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801065e8:	e9 f3 bc ff ff       	jmp    801022e0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801065ed:	c7 04 24 9e 72 10 80 	movl   $0x8010729e,(%esp)
801065f4:	e8 87 a1 ff ff       	call   80100780 <panic>
801065f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106600 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	57                   	push   %edi
80106604:	56                   	push   %esi
80106605:	53                   	push   %ebx
80106606:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106609:	e8 72 fd ff ff       	call   80106380 <setupkvm>
8010660e:	85 c0                	test   %eax,%eax
80106610:	89 c6                	mov    %eax,%esi
80106612:	0f 84 91 00 00 00    	je     801066a9 <copyuvm+0xa9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106618:	8b 45 0c             	mov    0xc(%ebp),%eax
8010661b:	85 c0                	test   %eax,%eax
8010661d:	0f 84 86 00 00 00    	je     801066a9 <copyuvm+0xa9>
80106623:	31 db                	xor    %ebx,%ebx
80106625:	eb 54                	jmp    8010667b <copyuvm+0x7b>
80106627:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80106628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010662b:	89 3c 24             	mov    %edi,(%esp)
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010662e:	81 ef 00 00 00 80    	sub    $0x80000000,%edi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80106634:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010663b:	00 
8010663c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106641:	2d 00 00 00 80       	sub    $0x80000000,%eax
80106646:	89 44 24 04          	mov    %eax,0x4(%esp)
8010664a:	e8 71 da ff ff       	call   801040c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010664f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106652:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106657:	89 da                	mov    %ebx,%edx
80106659:	89 3c 24             	mov    %edi,(%esp)
8010665c:	25 ff 0f 00 00       	and    $0xfff,%eax
80106661:	89 44 24 04          	mov    %eax,0x4(%esp)
80106665:	89 f0                	mov    %esi,%eax
80106667:	e8 94 fc ff ff       	call   80106300 <mappages>
8010666c:	85 c0                	test   %eax,%eax
8010666e:	78 2f                	js     8010669f <copyuvm+0x9f>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106670:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106676:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106679:	76 2e                	jbe    801066a9 <copyuvm+0xa9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010667b:	8b 45 08             	mov    0x8(%ebp),%eax
8010667e:	31 c9                	xor    %ecx,%ecx
80106680:	89 da                	mov    %ebx,%edx
80106682:	e8 29 fb ff ff       	call   801061b0 <walkpgdir>
80106687:	85 c0                	test   %eax,%eax
80106689:	74 28                	je     801066b3 <copyuvm+0xb3>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
8010668b:	8b 00                	mov    (%eax),%eax
8010668d:	a8 01                	test   $0x1,%al
8010668f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106692:	74 2b                	je     801066bf <copyuvm+0xbf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106694:	e8 f7 bb ff ff       	call   80102290 <kalloc>
80106699:	85 c0                	test   %eax,%eax
8010669b:	89 c7                	mov    %eax,%edi
8010669d:	75 89                	jne    80106628 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
8010669f:	89 34 24             	mov    %esi,(%esp)
801066a2:	31 f6                	xor    %esi,%esi
801066a4:	e8 d7 fe ff ff       	call   80106580 <freevm>
  return 0;
}
801066a9:	83 c4 2c             	add    $0x2c,%esp
801066ac:	89 f0                	mov    %esi,%eax
801066ae:	5b                   	pop    %ebx
801066af:	5e                   	pop    %esi
801066b0:	5f                   	pop    %edi
801066b1:	5d                   	pop    %ebp
801066b2:	c3                   	ret    

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801066b3:	c7 04 24 af 72 10 80 	movl   $0x801072af,(%esp)
801066ba:	e8 c1 a0 ff ff       	call   80100780 <panic>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801066bf:	c7 04 24 c9 72 10 80 	movl   $0x801072c9,(%esp)
801066c6:	e8 b5 a0 ff ff       	call   80100780 <panic>
801066cb:	90                   	nop
801066cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801066d0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	57                   	push   %edi
801066d4:	56                   	push   %esi
801066d5:	53                   	push   %ebx
801066d6:	83 ec 2c             	sub    $0x2c,%esp
801066d9:	8b 75 10             	mov    0x10(%ebp),%esi
801066dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801066df:	85 f6                	test   %esi,%esi
801066e1:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801066e4:	0f 88 bc 00 00 00    	js     801067a6 <allocuvm+0xd6>
    return 0;
  if(newsz < oldsz)
801066ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801066ed:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
801066f0:	72 74                	jb     80106766 <allocuvm+0x96>
    return oldsz;

  a = PGROUNDUP(oldsz);
801066f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801066f5:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
801066fb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106701:	39 de                	cmp    %ebx,%esi
80106703:	76 64                	jbe    80106769 <allocuvm+0x99>
    mem = kalloc();
80106705:	e8 86 bb ff ff       	call   80102290 <kalloc>
    if(mem == 0){
8010670a:	85 c0                	test   %eax,%eax
8010670c:	74 79                	je     80106787 <allocuvm+0xb7>
8010670e:	66 90                	xchg   %ax,%ax
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106710:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106717:	00 
80106718:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010671f:	00 
80106720:	89 04 24             	mov    %eax,(%esp)
80106723:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106726:	e8 c5 d8 ff ff       	call   80103ff0 <memset>
    int res = mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010672b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010672e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106733:	89 f8                	mov    %edi,%eax
80106735:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
8010673c:	00 
8010673d:	81 ea 00 00 00 80    	sub    $0x80000000,%edx
80106743:	89 14 24             	mov    %edx,(%esp)
80106746:	89 da                	mov    %ebx,%edx
80106748:	e8 b3 fb ff ff       	call   80106300 <mappages>
    //assert (res==0);
    while(res) {
8010674d:	85 c0                	test   %eax,%eax
8010674f:	74 23                	je     80106774 <allocuvm+0xa4>
80106751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("vm: Res invalid");
80106758:	c7 04 24 fb 72 10 80 	movl   $0x801072fb,(%esp)
8010675f:	e8 9c a0 ff ff       	call   80100800 <cprintf>
80106764:	eb f2                	jmp    80106758 <allocuvm+0x88>
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;
80106766:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    while(res) {
      cprintf("vm: Res invalid");
    }
  }
  return newsz;
}
80106769:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010676c:	83 c4 2c             	add    $0x2c,%esp
8010676f:	5b                   	pop    %ebx
80106770:	5e                   	pop    %esi
80106771:	5f                   	pop    %edi
80106772:	5d                   	pop    %ebp
80106773:	c3                   	ret    
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106774:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010677a:	39 de                	cmp    %ebx,%esi
8010677c:	76 eb                	jbe    80106769 <allocuvm+0x99>
    mem = kalloc();
8010677e:	e8 0d bb ff ff       	call   80102290 <kalloc>
    if(mem == 0){
80106783:	85 c0                	test   %eax,%eax
80106785:	75 89                	jne    80106710 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106787:	c7 04 24 e3 72 10 80 	movl   $0x801072e3,(%esp)
8010678e:	e8 6d a0 ff ff       	call   80100800 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106793:	8b 45 0c             	mov    0xc(%ebp),%eax
80106796:	89 74 24 04          	mov    %esi,0x4(%esp)
8010679a:	89 3c 24             	mov    %edi,(%esp)
8010679d:	89 44 24 08          	mov    %eax,0x8(%esp)
801067a1:	e8 3a fd ff ff       	call   801064e0 <deallocuvm>
801067a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    while(res) {
      cprintf("vm: Res invalid");
    }
  }
  return newsz;
}
801067ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067b0:	83 c4 2c             	add    $0x2c,%esp
801067b3:	5b                   	pop    %ebx
801067b4:	5e                   	pop    %esi
801067b5:	5f                   	pop    %edi
801067b6:	5d                   	pop    %ebp
801067b7:	c3                   	ret    
801067b8:	90                   	nop
801067b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067c0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	57                   	push   %edi
801067c4:	56                   	push   %esi
801067c5:	53                   	push   %ebx
801067c6:	83 ec 2c             	sub    $0x2c,%esp
801067c9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801067cc:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
801067d2:	0f 85 96 00 00 00    	jne    8010686e <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
801067d8:	8b 75 18             	mov    0x18(%ebp),%esi
801067db:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < sz; i += PGSIZE){
801067dd:	85 f6                	test   %esi,%esi
801067df:	75 18                	jne    801067f9 <loaduvm+0x39>
801067e1:	eb 75                	jmp    80106858 <loaduvm+0x98>
801067e3:	90                   	nop
801067e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067ee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801067f4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801067f7:	76 5f                	jbe    80106858 <loaduvm+0x98>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801067f9:	8b 45 08             	mov    0x8(%ebp),%eax
801067fc:	31 c9                	xor    %ecx,%ecx
801067fe:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80106801:	e8 aa f9 ff ff       	call   801061b0 <walkpgdir>
80106806:	85 c0                	test   %eax,%eax
80106808:	74 58                	je     80106862 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010680a:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
8010680c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106812:	ba 00 10 00 00       	mov    $0x1000,%edx
80106817:	0f 42 d6             	cmovb  %esi,%edx
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010681a:	8b 4d 14             	mov    0x14(%ebp),%ecx
8010681d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106821:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106824:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106829:	2d 00 00 00 80       	sub    $0x80000000,%eax
8010682e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106832:	8b 45 10             	mov    0x10(%ebp),%eax
80106835:	8d 0c 0b             	lea    (%ebx,%ecx,1),%ecx
80106838:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010683c:	89 04 24             	mov    %eax,(%esp)
8010683f:	e8 6c ae ff ff       	call   801016b0 <readi>
80106844:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106847:	39 d0                	cmp    %edx,%eax
80106849:	74 9d                	je     801067e8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010684b:	83 c4 2c             	add    $0x2c,%esp
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010684e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return 0;
}
80106853:	5b                   	pop    %ebx
80106854:	5e                   	pop    %esi
80106855:	5f                   	pop    %edi
80106856:	5d                   	pop    %ebp
80106857:	c3                   	ret    
80106858:	83 c4 2c             	add    $0x2c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010685b:	31 c0                	xor    %eax,%eax
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}
8010685d:	5b                   	pop    %ebx
8010685e:	5e                   	pop    %esi
8010685f:	5f                   	pop    %edi
80106860:	5d                   	pop    %ebp
80106861:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106862:	c7 04 24 0b 73 10 80 	movl   $0x8010730b,(%esp)
80106869:	e8 12 9f ff ff       	call   80100780 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
8010686e:	c7 04 24 40 73 10 80 	movl   $0x80107340,(%esp)
80106875:	e8 06 9f ff ff       	call   80100780 <panic>
8010687a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106880 <switchuvm>:
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	53                   	push   %ebx
80106884:	83 ec 14             	sub    $0x14,%esp
80106887:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010688a:	e8 d1 d5 ff ff       	call   80103e60 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010688f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106895:	8d 50 08             	lea    0x8(%eax),%edx
80106898:	89 d1                	mov    %edx,%ecx
8010689a:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
801068a1:	c1 e9 10             	shr    $0x10,%ecx
801068a4:	c1 ea 18             	shr    $0x18,%edx
801068a7:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
801068ad:	c6 80 a5 00 00 00 99 	movb   $0x99,0xa5(%eax)
801068b4:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
801068ba:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801068c1:	67 00 
801068c3:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801068ca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801068d0:	80 a0 a5 00 00 00 ef 	andb   $0xef,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801068d7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801068dd:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801068e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068e9:	8b 50 08             	mov    0x8(%eax),%edx
801068ec:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801068f2:	81 c2 00 10 00 00    	add    $0x1000,%edx
801068f8:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801068fb:	b8 30 00 00 00       	mov    $0x30,%eax
80106900:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
80106903:	8b 43 04             	mov    0x4(%ebx),%eax
80106906:	85 c0                	test   %eax,%eax
80106908:	74 12                	je     8010691c <switchuvm+0x9c>
}

static inline void
lcr3(uint val) 
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010690a:	2d 00 00 00 80       	sub    $0x80000000,%eax
8010690f:	0f 22 d8             	mov    %eax,%cr3
    panic("switchuvm: no pgdir");
  lcr3(v2p(p->pgdir));  // switch to new address space
  popcli();
}
80106912:	83 c4 14             	add    $0x14,%esp
80106915:	5b                   	pop    %ebx
80106916:	5d                   	pop    %ebp
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
  lcr3(v2p(p->pgdir));  // switch to new address space
  popcli();
80106917:	e9 84 d5 ff ff       	jmp    80103ea0 <popcli>
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010691c:	c7 04 24 29 73 10 80 	movl   $0x80107329,(%esp)
80106923:	e8 58 9e ff ff       	call   80100780 <panic>
80106928:	90                   	nop
80106929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106930 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106936:	e8 25 be ff ff       	call   80102760 <cpunum>
8010693b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106941:	05 a0 e8 10 80       	add    $0x8010e8a0,%eax
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106946:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
8010694c:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
80106953:	89 d1                	mov    %edx,%ecx
80106955:	c1 ea 18             	shr    $0x18,%edx
80106958:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)
8010695e:	c1 e9 10             	shr    $0x10,%ecx

  lgdt(c->gdt, sizeof(c->gdt));
80106961:	8d 50 70             	lea    0x70(%eax),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106964:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010696a:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80106970:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80106974:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
80106978:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
8010697c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106980:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80106987:	ff ff 
80106989:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80106990:	00 00 
80106992:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80106999:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
801069a0:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
801069a7:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801069ae:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801069b5:	ff ff 
801069b7:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801069be:	00 00 
801069c0:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801069c7:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
801069ce:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
801069d5:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801069dc:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801069e3:	ff ff 
801069e5:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801069ec:	00 00 
801069ee:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801069f5:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
801069fc:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)
80106a03:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106a0a:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80106a11:	00 00 
80106a13:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80106a19:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
80106a20:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106a27:	66 c7 45 f2 37 00    	movw   $0x37,-0xe(%ebp)
  pd[1] = (uint)p;
80106a2d:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a31:	c1 ea 10             	shr    $0x10,%edx
80106a34:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106a38:	8d 55 f2             	lea    -0xe(%ebp),%edx
80106a3b:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
80106a3e:	ba 18 00 00 00       	mov    $0x18,%edx
80106a43:	8e ea                	mov    %edx,%gs

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);
  
  // Initialize cpu-local storage.
  cpu = c;
80106a45:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80106a4b:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106a52:	00 00 00 00 
}
80106a56:	c9                   	leave  
80106a57:	c3                   	ret    
