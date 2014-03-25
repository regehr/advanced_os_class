
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 1c 34 10 80       	mov    $0x8010341c,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 84 82 10 	movl   $0x80108284,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 6c 4c 00 00       	call   80104cba <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 db 10 80 84 	movl   $0x8010db84,0x8010db90
80100055:	db 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 db 10 80 84 	movl   $0x8010db84,0x8010db94
8010005f:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 db 10 80       	mov    0x8010db94,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 db 10 80       	mov    %eax,0x8010db94

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	b8 84 db 10 80       	mov    $0x8010db84,%eax
801000aa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ad:	72 bc                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000af:	c9                   	leave  
801000b0:	c3                   	ret    

801000b1 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b1:	55                   	push   %ebp
801000b2:	89 e5                	mov    %esp,%ebp
801000b4:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b7:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000be:	e8 18 4c 00 00       	call   80104cdb <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c3:	a1 94 db 10 80       	mov    0x8010db94,%eax
801000c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000cb:	eb 63                	jmp    80100130 <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d0:	8b 40 04             	mov    0x4(%eax),%eax
801000d3:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d6:	75 4f                	jne    80100127 <bget+0x76>
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 08             	mov    0x8(%eax),%eax
801000de:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e1:	75 44                	jne    80100127 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 00                	mov    (%eax),%eax
801000e8:	83 e0 01             	and    $0x1,%eax
801000eb:	85 c0                	test   %eax,%eax
801000ed:	75 23                	jne    80100112 <bget+0x61>
        b->flags |= B_BUSY;
801000ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f2:	8b 00                	mov    (%eax),%eax
801000f4:	89 c2                	mov    %eax,%edx
801000f6:	83 ca 01             	or     $0x1,%edx
801000f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fc:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fe:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100105:	e8 32 4c 00 00       	call   80104d3c <release>
        return b;
8010010a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010d:	e9 93 00 00 00       	jmp    801001a5 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100112:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100119:	80 
8010011a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011d:	89 04 24             	mov    %eax,(%esp)
80100120:	e8 c7 48 00 00       	call   801049ec <sleep>
      goto loop;
80100125:	eb 9c                	jmp    801000c3 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012a:	8b 40 10             	mov    0x10(%eax),%eax
8010012d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100130:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100137:	75 94                	jne    801000cd <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100139:	a1 90 db 10 80       	mov    0x8010db90,%eax
8010013e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100141:	eb 4d                	jmp    80100190 <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100146:	8b 00                	mov    (%eax),%eax
80100148:	83 e0 01             	and    $0x1,%eax
8010014b:	85 c0                	test   %eax,%eax
8010014d:	75 38                	jne    80100187 <bget+0xd6>
8010014f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100152:	8b 00                	mov    (%eax),%eax
80100154:	83 e0 04             	and    $0x4,%eax
80100157:	85 c0                	test   %eax,%eax
80100159:	75 2c                	jne    80100187 <bget+0xd6>
      b->dev = dev;
8010015b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015e:	8b 55 08             	mov    0x8(%ebp),%edx
80100161:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100167:	8b 55 0c             	mov    0xc(%ebp),%edx
8010016a:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100170:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017d:	e8 ba 4b 00 00       	call   80104d3c <release>
      return b;
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	eb 1e                	jmp    801001a5 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010018a:	8b 40 0c             	mov    0xc(%eax),%eax
8010018d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100190:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100197:	75 aa                	jne    80100143 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100199:	c7 04 24 8b 82 10 80 	movl   $0x8010828b,(%esp)
801001a0:	e8 95 03 00 00       	call   8010053a <panic>
}
801001a5:	c9                   	leave  
801001a6:	c3                   	ret    

801001a7 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a7:	55                   	push   %ebp
801001a8:	89 e5                	mov    %esp,%ebp
801001aa:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b4:	8b 45 08             	mov    0x8(%ebp),%eax
801001b7:	89 04 24             	mov    %eax,(%esp)
801001ba:	e8 f2 fe ff ff       	call   801000b1 <bget>
801001bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c5:	8b 00                	mov    (%eax),%eax
801001c7:	83 e0 02             	and    $0x2,%eax
801001ca:	85 c0                	test   %eax,%eax
801001cc:	75 0b                	jne    801001d9 <bread+0x32>
    iderw(b);
801001ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d1:	89 04 24             	mov    %eax,(%esp)
801001d4:	e8 11 26 00 00       	call   801027ea <iderw>
  return b;
801001d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001dc:	c9                   	leave  
801001dd:	c3                   	ret    

801001de <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001de:	55                   	push   %ebp
801001df:	89 e5                	mov    %esp,%ebp
801001e1:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e4:	8b 45 08             	mov    0x8(%ebp),%eax
801001e7:	8b 00                	mov    (%eax),%eax
801001e9:	83 e0 01             	and    $0x1,%eax
801001ec:	85 c0                	test   %eax,%eax
801001ee:	75 0c                	jne    801001fc <bwrite+0x1e>
    panic("bwrite");
801001f0:	c7 04 24 9c 82 10 80 	movl   $0x8010829c,(%esp)
801001f7:	e8 3e 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fc:	8b 45 08             	mov    0x8(%ebp),%eax
801001ff:	8b 00                	mov    (%eax),%eax
80100201:	89 c2                	mov    %eax,%edx
80100203:	83 ca 04             	or     $0x4,%edx
80100206:	8b 45 08             	mov    0x8(%ebp),%eax
80100209:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020b:	8b 45 08             	mov    0x8(%ebp),%eax
8010020e:	89 04 24             	mov    %eax,(%esp)
80100211:	e8 d4 25 00 00       	call   801027ea <iderw>
}
80100216:	c9                   	leave  
80100217:	c3                   	ret    

80100218 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100218:	55                   	push   %ebp
80100219:	89 e5                	mov    %esp,%ebp
8010021b:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021e:	8b 45 08             	mov    0x8(%ebp),%eax
80100221:	8b 00                	mov    (%eax),%eax
80100223:	83 e0 01             	and    $0x1,%eax
80100226:	85 c0                	test   %eax,%eax
80100228:	75 0c                	jne    80100236 <brelse+0x1e>
    panic("brelse");
8010022a:	c7 04 24 a3 82 10 80 	movl   $0x801082a3,(%esp)
80100231:	e8 04 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100236:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023d:	e8 99 4a 00 00       	call   80104cdb <acquire>

  b->next->prev = b->prev;
80100242:	8b 45 08             	mov    0x8(%ebp),%eax
80100245:	8b 40 10             	mov    0x10(%eax),%eax
80100248:	8b 55 08             	mov    0x8(%ebp),%edx
8010024b:	8b 52 0c             	mov    0xc(%edx),%edx
8010024e:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100251:	8b 45 08             	mov    0x8(%ebp),%eax
80100254:	8b 40 0c             	mov    0xc(%eax),%eax
80100257:	8b 55 08             	mov    0x8(%ebp),%edx
8010025a:	8b 52 10             	mov    0x10(%edx),%edx
8010025d:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100260:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100266:	8b 45 08             	mov    0x8(%ebp),%eax
80100269:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
  bcache.head.next->prev = b;
80100276:	a1 94 db 10 80       	mov    0x8010db94,%eax
8010027b:	8b 55 08             	mov    0x8(%ebp),%edx
8010027e:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	a3 94 db 10 80       	mov    %eax,0x8010db94

  b->flags &= ~B_BUSY;
80100289:	8b 45 08             	mov    0x8(%ebp),%eax
8010028c:	8b 00                	mov    (%eax),%eax
8010028e:	89 c2                	mov    %eax,%edx
80100290:	83 e2 fe             	and    $0xfffffffe,%edx
80100293:	8b 45 08             	mov    0x8(%ebp),%eax
80100296:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100298:	8b 45 08             	mov    0x8(%ebp),%eax
8010029b:	89 04 24             	mov    %eax,(%esp)
8010029e:	e8 31 48 00 00       	call   80104ad4 <wakeup>

  release(&bcache.lock);
801002a3:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002aa:	e8 8d 4a 00 00       	call   80104d3c <release>
}
801002af:	c9                   	leave  
801002b0:	c3                   	ret    
801002b1:	00 00                	add    %al,(%eax)
	...

801002b4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b4:	55                   	push   %ebp
801002b5:	89 e5                	mov    %esp,%ebp
801002b7:	83 ec 14             	sub    $0x14,%esp
801002ba:	8b 45 08             	mov    0x8(%ebp),%eax
801002bd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002c1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c5:	89 c2                	mov    %eax,%edx
801002c7:	ec                   	in     (%dx),%al
801002c8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002cb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cf:	c9                   	leave  
801002d0:	c3                   	ret    

801002d1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002d1:	55                   	push   %ebp
801002d2:	89 e5                	mov    %esp,%ebp
801002d4:	83 ec 08             	sub    $0x8,%esp
801002d7:	8b 55 08             	mov    0x8(%ebp),%edx
801002da:	8b 45 0c             	mov    0xc(%ebp),%eax
801002dd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002e1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002ec:	ee                   	out    %al,(%dx)
}
801002ed:	c9                   	leave  
801002ee:	c3                   	ret    

801002ef <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002ef:	55                   	push   %ebp
801002f0:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002f2:	fa                   	cli    
}
801002f3:	5d                   	pop    %ebp
801002f4:	c3                   	ret    

801002f5 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f5:	55                   	push   %ebp
801002f6:	89 e5                	mov    %esp,%ebp
801002f8:	53                   	push   %ebx
801002f9:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100300:	74 19                	je     8010031b <printint+0x26>
80100302:	8b 45 08             	mov    0x8(%ebp),%eax
80100305:	c1 e8 1f             	shr    $0x1f,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x26>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100319:	eb 06                	jmp    80100321 <printint+0x2c>
    x = -xx;
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  i = 0;
80100321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010032b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010032e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100331:	ba 00 00 00 00       	mov    $0x0,%edx
80100336:	f7 f3                	div    %ebx
80100338:	89 d0                	mov    %edx,%eax
8010033a:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100341:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
80100345:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }while((x /= base) != 0);
80100349:	8b 45 0c             	mov    0xc(%ebp),%eax
8010034c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010034f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100352:	ba 00 00 00 00       	mov    $0x0,%edx
80100357:	f7 75 d4             	divl   -0x2c(%ebp)
8010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010035d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100361:	75 c5                	jne    80100328 <printint+0x33>

  if(sign)
80100363:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100367:	74 21                	je     8010038a <printint+0x95>
    buf[i++] = '-';
80100369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010036c:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)
80100371:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)

  while(--i >= 0)
80100375:	eb 13                	jmp    8010038a <printint+0x95>
    consputc(buf[i]);
80100377:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010037a:	0f b6 44 05 e0       	movzbl -0x20(%ebp,%eax,1),%eax
8010037f:	0f be c0             	movsbl %al,%eax
80100382:	89 04 24             	mov    %eax,(%esp)
80100385:	e8 c4 03 00 00       	call   8010074e <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
8010038e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100392:	79 e3                	jns    80100377 <printint+0x82>
    consputc(buf[i]);
}
80100394:	83 c4 44             	add    $0x44,%esp
80100397:	5b                   	pop    %ebx
80100398:	5d                   	pop    %ebp
80100399:	c3                   	ret    

8010039a <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
8010039a:	55                   	push   %ebp
8010039b:	89 e5                	mov    %esp,%ebp
8010039d:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a0:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(locking)
801003a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801003ac:	74 0c                	je     801003ba <cprintf+0x20>
    acquire(&cons.lock);
801003ae:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003b5:	e8 21 49 00 00       	call   80104cdb <acquire>

  if (fmt == 0)
801003ba:	8b 45 08             	mov    0x8(%ebp),%eax
801003bd:	85 c0                	test   %eax,%eax
801003bf:	75 0c                	jne    801003cd <cprintf+0x33>
    panic("null fmt");
801003c1:	c7 04 24 aa 82 10 80 	movl   $0x801082aa,(%esp)
801003c8:	e8 6d 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003cd:	8d 45 08             	lea    0x8(%ebp),%eax
801003d0:	83 c0 04             	add    $0x4,%eax
801003d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801003dd:	e9 20 01 00 00       	jmp    80100502 <cprintf+0x168>
    if(c != '%'){
801003e2:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
801003e6:	74 10                	je     801003f8 <cprintf+0x5e>
      consputc(c);
801003e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801003eb:	89 04 24             	mov    %eax,(%esp)
801003ee:	e8 5b 03 00 00       	call   8010074e <consputc>
      continue;
801003f3:	e9 06 01 00 00       	jmp    801004fe <cprintf+0x164>
    }
    c = fmt[++i] & 0xff;
801003f8:	8b 55 08             	mov    0x8(%ebp),%edx
801003fb:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801003ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100402:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100405:	0f b6 00             	movzbl (%eax),%eax
80100408:	0f be c0             	movsbl %al,%eax
8010040b:	25 ff 00 00 00       	and    $0xff,%eax
80100410:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(c == 0)
80100413:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100417:	0f 84 08 01 00 00    	je     80100525 <cprintf+0x18b>
      break;
    switch(c){
8010041d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100420:	83 f8 70             	cmp    $0x70,%eax
80100423:	74 4d                	je     80100472 <cprintf+0xd8>
80100425:	83 f8 70             	cmp    $0x70,%eax
80100428:	7f 13                	jg     8010043d <cprintf+0xa3>
8010042a:	83 f8 25             	cmp    $0x25,%eax
8010042d:	0f 84 a6 00 00 00    	je     801004d9 <cprintf+0x13f>
80100433:	83 f8 64             	cmp    $0x64,%eax
80100436:	74 14                	je     8010044c <cprintf+0xb2>
80100438:	e9 aa 00 00 00       	jmp    801004e7 <cprintf+0x14d>
8010043d:	83 f8 73             	cmp    $0x73,%eax
80100440:	74 53                	je     80100495 <cprintf+0xfb>
80100442:	83 f8 78             	cmp    $0x78,%eax
80100445:	74 2b                	je     80100472 <cprintf+0xd8>
80100447:	e9 9b 00 00 00       	jmp    801004e7 <cprintf+0x14d>
    case 'd':
      printint(*argp++, 10, 1);
8010044c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010044f:	8b 00                	mov    (%eax),%eax
80100451:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100455:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010045c:	00 
8010045d:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100464:	00 
80100465:	89 04 24             	mov    %eax,(%esp)
80100468:	e8 88 fe ff ff       	call   801002f5 <printint>
      break;
8010046d:	e9 8c 00 00 00       	jmp    801004fe <cprintf+0x164>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100472:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100475:	8b 00                	mov    (%eax),%eax
80100477:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
8010047b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100482:	00 
80100483:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010048a:	00 
8010048b:	89 04 24             	mov    %eax,(%esp)
8010048e:	e8 62 fe ff ff       	call   801002f5 <printint>
      break;
80100493:	eb 69                	jmp    801004fe <cprintf+0x164>
    case 's':
      if((s = (char*)*argp++) == 0)
80100495:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100498:	8b 00                	mov    (%eax),%eax
8010049a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010049d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801004a1:	0f 94 c0             	sete   %al
801004a4:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004a8:	84 c0                	test   %al,%al
801004aa:	74 20                	je     801004cc <cprintf+0x132>
        s = "(null)";
801004ac:	c7 45 f4 b3 82 10 80 	movl   $0x801082b3,-0xc(%ebp)
      for(; *s; s++)
801004b3:	eb 18                	jmp    801004cd <cprintf+0x133>
        consputc(*s);
801004b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801004b8:	0f b6 00             	movzbl (%eax),%eax
801004bb:	0f be c0             	movsbl %al,%eax
801004be:	89 04 24             	mov    %eax,(%esp)
801004c1:	e8 88 02 00 00       	call   8010074e <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801004ca:	eb 01                	jmp    801004cd <cprintf+0x133>
801004cc:	90                   	nop
801004cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801004d0:	0f b6 00             	movzbl (%eax),%eax
801004d3:	84 c0                	test   %al,%al
801004d5:	75 de                	jne    801004b5 <cprintf+0x11b>
        consputc(*s);
      break;
801004d7:	eb 25                	jmp    801004fe <cprintf+0x164>
    case '%':
      consputc('%');
801004d9:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e0:	e8 69 02 00 00       	call   8010074e <consputc>
      break;
801004e5:	eb 17                	jmp    801004fe <cprintf+0x164>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004e7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ee:	e8 5b 02 00 00       	call   8010074e <consputc>
      consputc(c);
801004f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801004f6:	89 04 24             	mov    %eax,(%esp)
801004f9:	e8 50 02 00 00       	call   8010074e <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801004fe:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100502:	8b 55 08             	mov    0x8(%ebp),%edx
80100505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100508:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010050b:	0f b6 00             	movzbl (%eax),%eax
8010050e:	0f be c0             	movsbl %al,%eax
80100511:	25 ff 00 00 00       	and    $0xff,%eax
80100516:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100519:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010051d:	0f 85 bf fe ff ff    	jne    801003e2 <cprintf+0x48>
80100523:	eb 01                	jmp    80100526 <cprintf+0x18c>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100525:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x19e>
    release(&cons.lock);
8010052c:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100533:	e8 04 48 00 00       	call   80104d3c <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 aa fd ff ff       	call   801002ef <cli>
  cons.locking = 0;
80100545:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 ba 82 10 80 	movl   $0x801082ba,(%esp)
80100566:	e8 2f fe ff ff       	call   8010039a <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 24 fe ff ff       	call   8010039a <cprintf>
  cprintf("\n");
80100576:	c7 04 24 c9 82 10 80 	movl   $0x801082c9,(%esp)
8010057d:	e8 18 fe ff ff       	call   8010039a <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 f7 47 00 00       	call   80104d8b <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 cb 82 10 80 	movl   $0x801082cb,(%esp)
801005af:	e8 e6 fd ff ff       	call   8010039a <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 ed fc ff ff       	call   801002d1 <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c4 fc ff ff       	call   801002b4 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c4 fc ff ff       	call   801002d1 <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 9b fc ff ff       	call   801002b4 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	89 ca                	mov    %ecx,%edx
80100647:	29 c2                	sub    %eax,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 33                	jmp    80100688 <cgaputc+0xbe>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 24                	jle    80100688 <cgaputc+0xbe>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 1e                	jmp    80100688 <cgaputc+0xbe>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	a1 00 90 10 80       	mov    0x80109000,%eax
8010066f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100672:	01 d2                	add    %edx,%edx
80100674:	8d 14 10             	lea    (%eax,%edx,1),%edx
80100677:	8b 45 08             	mov    0x8(%ebp),%eax
8010067a:	66 25 ff 00          	and    $0xff,%ax
8010067e:	80 cc 07             	or     $0x7,%ah
80100681:	66 89 02             	mov    %ax,(%edx)
80100684:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
80100688:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
8010068f:	7e 53                	jle    801006e4 <cgaputc+0x11a>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100691:	a1 00 90 10 80       	mov    0x80109000,%eax
80100696:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069c:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a1:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006a8:	00 
801006a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801006ad:	89 04 24             	mov    %eax,(%esp)
801006b0:	e8 48 49 00 00       	call   80104ffd <memmove>
    pos -= 80;
801006b5:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006b9:	b8 80 07 00 00       	mov    $0x780,%eax
801006be:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c1:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c4:	a1 00 90 10 80       	mov    0x80109000,%eax
801006c9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006cc:	01 c9                	add    %ecx,%ecx
801006ce:	01 c8                	add    %ecx,%eax
801006d0:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006db:	00 
801006dc:	89 04 24             	mov    %eax,(%esp)
801006df:	e8 46 48 00 00       	call   80104f2a <memset>
  }
  
  outb(CRTPORT, 14);
801006e4:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006eb:	00 
801006ec:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f3:	e8 d9 fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT+1, pos>>8);
801006f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fb:	c1 f8 08             	sar    $0x8,%eax
801006fe:	0f b6 c0             	movzbl %al,%eax
80100701:	89 44 24 04          	mov    %eax,0x4(%esp)
80100705:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070c:	e8 c0 fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT, 15);
80100711:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100718:	00 
80100719:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100720:	e8 ac fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT+1, pos);
80100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100728:	0f b6 c0             	movzbl %al,%eax
8010072b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010072f:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100736:	e8 96 fb ff ff       	call   801002d1 <outb>
  crt[pos] = ' ' | 0x0700;
8010073b:	a1 00 90 10 80       	mov    0x80109000,%eax
80100740:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100743:	01 d2                	add    %edx,%edx
80100745:	01 d0                	add    %edx,%eax
80100747:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074c:	c9                   	leave  
8010074d:	c3                   	ret    

8010074e <consputc>:

void
consputc(int c)
{
8010074e:	55                   	push   %ebp
8010074f:	89 e5                	mov    %esp,%ebp
80100751:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100754:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
80100759:	85 c0                	test   %eax,%eax
8010075b:	74 07                	je     80100764 <consputc+0x16>
    cli();
8010075d:	e8 8d fb ff ff       	call   801002ef <cli>
    for(;;)
      ;
80100762:	eb fe                	jmp    80100762 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100764:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076b:	75 26                	jne    80100793 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100774:	e8 5b 61 00 00       	call   801068d4 <uartputc>
80100779:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100780:	e8 4f 61 00 00       	call   801068d4 <uartputc>
80100785:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078c:	e8 43 61 00 00       	call   801068d4 <uartputc>
80100791:	eb 0b                	jmp    8010079e <consputc+0x50>
  } else
    uartputc(c);
80100793:	8b 45 08             	mov    0x8(%ebp),%eax
80100796:	89 04 24             	mov    %eax,(%esp)
80100799:	e8 36 61 00 00       	call   801068d4 <uartputc>
  cgaputc(c);
8010079e:	8b 45 08             	mov    0x8(%ebp),%eax
801007a1:	89 04 24             	mov    %eax,(%esp)
801007a4:	e8 21 fe ff ff       	call   801005ca <cgaputc>
}
801007a9:	c9                   	leave  
801007aa:	c3                   	ret    

801007ab <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ab:	55                   	push   %ebp
801007ac:	89 e5                	mov    %esp,%ebp
801007ae:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b1:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801007b8:	e8 1e 45 00 00       	call   80104cdb <acquire>
  while((c = getc()) >= 0){
801007bd:	e9 3e 01 00 00       	jmp    80100900 <consoleintr+0x155>
    switch(c){
801007c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c5:	83 f8 10             	cmp    $0x10,%eax
801007c8:	74 1e                	je     801007e8 <consoleintr+0x3d>
801007ca:	83 f8 10             	cmp    $0x10,%eax
801007cd:	7f 0a                	jg     801007d9 <consoleintr+0x2e>
801007cf:	83 f8 08             	cmp    $0x8,%eax
801007d2:	74 68                	je     8010083c <consoleintr+0x91>
801007d4:	e9 94 00 00 00       	jmp    8010086d <consoleintr+0xc2>
801007d9:	83 f8 15             	cmp    $0x15,%eax
801007dc:	74 2f                	je     8010080d <consoleintr+0x62>
801007de:	83 f8 7f             	cmp    $0x7f,%eax
801007e1:	74 59                	je     8010083c <consoleintr+0x91>
801007e3:	e9 85 00 00 00       	jmp    8010086d <consoleintr+0xc2>
    case C('P'):  // Process listing.
      procdump();
801007e8:	e8 99 43 00 00       	call   80104b86 <procdump>
      break;
801007ed:	e9 0e 01 00 00       	jmp    80100900 <consoleintr+0x155>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f2:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801007f7:	83 e8 01             	sub    $0x1,%eax
801007fa:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
801007ff:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100806:	e8 43 ff ff ff       	call   8010074e <consputc>
8010080b:	eb 01                	jmp    8010080e <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080d:	90                   	nop
8010080e:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100814:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100819:	39 c2                	cmp    %eax,%edx
8010081b:	0f 84 db 00 00 00    	je     801008fc <consoleintr+0x151>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100821:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100826:	83 e8 01             	sub    $0x1,%eax
80100829:	83 e0 7f             	and    $0x7f,%eax
8010082c:	0f b6 80 d4 dd 10 80 	movzbl -0x7fef222c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100833:	3c 0a                	cmp    $0xa,%al
80100835:	75 bb                	jne    801007f2 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100837:	e9 c4 00 00 00       	jmp    80100900 <consoleintr+0x155>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083c:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100842:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100847:	39 c2                	cmp    %eax,%edx
80100849:	0f 84 b0 00 00 00    	je     801008ff <consoleintr+0x154>
        input.e--;
8010084f:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100854:	83 e8 01             	sub    $0x1,%eax
80100857:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
8010085c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100863:	e8 e6 fe ff ff       	call   8010074e <consputc>
      }
      break;
80100868:	e9 93 00 00 00       	jmp    80100900 <consoleintr+0x155>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100871:	0f 84 89 00 00 00    	je     80100900 <consoleintr+0x155>
80100877:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010087d:	a1 54 de 10 80       	mov    0x8010de54,%eax
80100882:	89 d1                	mov    %edx,%ecx
80100884:	29 c1                	sub    %eax,%ecx
80100886:	89 c8                	mov    %ecx,%eax
80100888:	83 f8 7f             	cmp    $0x7f,%eax
8010088b:	77 73                	ja     80100900 <consoleintr+0x155>
        c = (c == '\r') ? '\n' : c;
8010088d:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
80100891:	74 05                	je     80100898 <consoleintr+0xed>
80100893:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100896:	eb 05                	jmp    8010089d <consoleintr+0xf2>
80100898:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008a0:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008a5:	89 c1                	mov    %eax,%ecx
801008a7:	83 e1 7f             	and    $0x7f,%ecx
801008aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008ad:	88 91 d4 dd 10 80    	mov    %dl,-0x7fef222c(%ecx)
801008b3:	83 c0 01             	add    $0x1,%eax
801008b6:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(c);
801008bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008be:	89 04 24             	mov    %eax,(%esp)
801008c1:	e8 88 fe ff ff       	call   8010074e <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c6:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008ca:	74 18                	je     801008e4 <consoleintr+0x139>
801008cc:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008d0:	74 12                	je     801008e4 <consoleintr+0x139>
801008d2:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008d7:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801008dd:	83 ea 80             	sub    $0xffffff80,%edx
801008e0:	39 d0                	cmp    %edx,%eax
801008e2:	75 1c                	jne    80100900 <consoleintr+0x155>
          input.w = input.e;
801008e4:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008e9:	a3 58 de 10 80       	mov    %eax,0x8010de58
          wakeup(&input.r);
801008ee:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
801008f5:	e8 da 41 00 00       	call   80104ad4 <wakeup>
801008fa:	eb 04                	jmp    80100900 <consoleintr+0x155>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008fc:	90                   	nop
801008fd:	eb 01                	jmp    80100900 <consoleintr+0x155>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008ff:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
80100900:	8b 45 08             	mov    0x8(%ebp),%eax
80100903:	ff d0                	call   *%eax
80100905:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010090c:	0f 89 b0 fe ff ff    	jns    801007c2 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100912:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100919:	e8 1e 44 00 00       	call   80104d3c <release>
}
8010091e:	c9                   	leave  
8010091f:	c3                   	ret    

80100920 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100920:	55                   	push   %ebp
80100921:	89 e5                	mov    %esp,%ebp
80100923:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100926:	8b 45 08             	mov    0x8(%ebp),%eax
80100929:	89 04 24             	mov    %eax,(%esp)
8010092c:	e8 c7 10 00 00       	call   801019f8 <iunlock>
  target = n;
80100931:	8b 45 10             	mov    0x10(%ebp),%eax
80100934:	89 45 f0             	mov    %eax,-0x10(%ebp)
  acquire(&input.lock);
80100937:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010093e:	e8 98 43 00 00       	call   80104cdb <acquire>
  while(n > 0){
80100943:	e9 a8 00 00 00       	jmp    801009f0 <consoleread+0xd0>
    while(input.r == input.w){
      if(proc->killed){
80100948:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094e:	8b 40 24             	mov    0x24(%eax),%eax
80100951:	85 c0                	test   %eax,%eax
80100953:	74 21                	je     80100976 <consoleread+0x56>
        release(&input.lock);
80100955:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010095c:	e8 db 43 00 00       	call   80104d3c <release>
        ilock(ip);
80100961:	8b 45 08             	mov    0x8(%ebp),%eax
80100964:	89 04 24             	mov    %eax,(%esp)
80100967:	e8 3b 0f 00 00       	call   801018a7 <ilock>
        return -1;
8010096c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100971:	e9 a9 00 00 00       	jmp    80100a1f <consoleread+0xff>
      }
      sleep(&input.r, &input.lock);
80100976:	c7 44 24 04 a0 dd 10 	movl   $0x8010dda0,0x4(%esp)
8010097d:	80 
8010097e:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
80100985:	e8 62 40 00 00       	call   801049ec <sleep>
8010098a:	eb 01                	jmp    8010098d <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
8010098c:	90                   	nop
8010098d:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
80100993:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100998:	39 c2                	cmp    %eax,%edx
8010099a:	74 ac                	je     80100948 <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
8010099c:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009a1:	89 c2                	mov    %eax,%edx
801009a3:	83 e2 7f             	and    $0x7f,%edx
801009a6:	0f b6 92 d4 dd 10 80 	movzbl -0x7fef222c(%edx),%edx
801009ad:	0f be d2             	movsbl %dl,%edx
801009b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
801009b3:	83 c0 01             	add    $0x1,%eax
801009b6:	a3 54 de 10 80       	mov    %eax,0x8010de54
    if(c == C('D')){  // EOF
801009bb:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801009bf:	75 17                	jne    801009d8 <consoleread+0xb8>
      if(n < target){
801009c1:	8b 45 10             	mov    0x10(%ebp),%eax
801009c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801009c7:	73 2f                	jae    801009f8 <consoleread+0xd8>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c9:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009ce:	83 e8 01             	sub    $0x1,%eax
801009d1:	a3 54 de 10 80       	mov    %eax,0x8010de54
      }
      break;
801009d6:	eb 24                	jmp    801009fc <consoleread+0xdc>
    }
    *dst++ = c;
801009d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801009db:	89 c2                	mov    %eax,%edx
801009dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801009e0:	88 10                	mov    %dl,(%eax)
801009e2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    --n;
801009e6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009ea:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801009ee:	74 0b                	je     801009fb <consoleread+0xdb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f4:	7f 96                	jg     8010098c <consoleread+0x6c>
801009f6:	eb 04                	jmp    801009fc <consoleread+0xdc>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
801009f8:	90                   	nop
801009f9:	eb 01                	jmp    801009fc <consoleread+0xdc>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
801009fb:	90                   	nop
  }
  release(&input.lock);
801009fc:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100a03:	e8 34 43 00 00       	call   80104d3c <release>
  ilock(ip);
80100a08:	8b 45 08             	mov    0x8(%ebp),%eax
80100a0b:	89 04 24             	mov    %eax,(%esp)
80100a0e:	e8 94 0e 00 00       	call   801018a7 <ilock>

  return target - n;
80100a13:	8b 45 10             	mov    0x10(%ebp),%eax
80100a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a19:	89 d1                	mov    %edx,%ecx
80100a1b:	29 c1                	sub    %eax,%ecx
80100a1d:	89 c8                	mov    %ecx,%eax
}
80100a1f:	c9                   	leave  
80100a20:	c3                   	ret    

80100a21 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a21:	55                   	push   %ebp
80100a22:	89 e5                	mov    %esp,%ebp
80100a24:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a27:	8b 45 08             	mov    0x8(%ebp),%eax
80100a2a:	89 04 24             	mov    %eax,(%esp)
80100a2d:	e8 c6 0f 00 00       	call   801019f8 <iunlock>
  acquire(&cons.lock);
80100a32:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a39:	e8 9d 42 00 00       	call   80104cdb <acquire>
  for(i = 0; i < n; i++)
80100a3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a45:	eb 1d                	jmp    80100a64 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a4a:	03 45 0c             	add    0xc(%ebp),%eax
80100a4d:	0f b6 00             	movzbl (%eax),%eax
80100a50:	0f be c0             	movsbl %al,%eax
80100a53:	25 ff 00 00 00       	and    $0xff,%eax
80100a58:	89 04 24             	mov    %eax,(%esp)
80100a5b:	e8 ee fc ff ff       	call   8010074e <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a60:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a67:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a6a:	7c db                	jl     80100a47 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a6c:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a73:	e8 c4 42 00 00       	call   80104d3c <release>
  ilock(ip);
80100a78:	8b 45 08             	mov    0x8(%ebp),%eax
80100a7b:	89 04 24             	mov    %eax,(%esp)
80100a7e:	e8 24 0e 00 00       	call   801018a7 <ilock>

  return n;
80100a83:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a86:	c9                   	leave  
80100a87:	c3                   	ret    

80100a88 <consoleinit>:

void
consoleinit(void)
{
80100a88:	55                   	push   %ebp
80100a89:	89 e5                	mov    %esp,%ebp
80100a8b:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a8e:	c7 44 24 04 cf 82 10 	movl   $0x801082cf,0x4(%esp)
80100a95:	80 
80100a96:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a9d:	e8 18 42 00 00       	call   80104cba <initlock>
  initlock(&input.lock, "input");
80100aa2:	c7 44 24 04 d7 82 10 	movl   $0x801082d7,0x4(%esp)
80100aa9:	80 
80100aaa:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100ab1:	e8 04 42 00 00       	call   80104cba <initlock>

  devsw[CONSOLE].write = consolewrite;
80100ab6:	c7 05 0c e8 10 80 21 	movl   $0x80100a21,0x8010e80c
80100abd:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ac0:	c7 05 08 e8 10 80 20 	movl   $0x80100920,0x8010e808
80100ac7:	09 10 80 
  cons.locking = 1;
80100aca:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100ad1:	00 00 00 

  picenable(IRQ_KBD);
80100ad4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100adb:	e8 dd 2f 00 00       	call   80103abd <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ae0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae7:	00 
80100ae8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aef:	e8 b6 1e 00 00       	call   801029aa <ioapicenable>
}
80100af4:	c9                   	leave  
80100af5:	c3                   	ret    
	...

80100af8 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100af8:	55                   	push   %ebp
80100af9:	89 e5                	mov    %esp,%ebp
80100afb:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100b01:	8b 45 08             	mov    0x8(%ebp),%eax
80100b04:	89 04 24             	mov    %eax,(%esp)
80100b07:	e8 43 19 00 00       	call   8010244f <namei>
80100b0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100b0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100b13:	75 0a                	jne    80100b1f <exec+0x27>
    return -1;
80100b15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1a:	e9 10 04 00 00       	jmp    80100f2f <exec+0x437>
  ilock(ip);
80100b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100b22:	89 04 24             	mov    %eax,(%esp)
80100b25:	e8 7d 0d 00 00       	call   801018a7 <ilock>
  pgdir = 0;
80100b2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b31:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b37:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b3e:	00 
80100b3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b46:	00 
80100b47:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100b4e:	89 04 24             	mov    %eax,(%esp)
80100b51:	e8 4a 12 00 00       	call   80101da0 <readi>
80100b56:	83 f8 33             	cmp    $0x33,%eax
80100b59:	0f 86 8a 03 00 00    	jbe    80100ee9 <exec+0x3f1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b5f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b65:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6a:	0f 85 7c 03 00 00    	jne    80100eec <exec+0x3f4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b70:	e8 a4 6e 00 00       	call   80107a19 <setupkvm>
80100b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100b78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100b7c:	0f 84 6d 03 00 00    	je     80100eef <exec+0x3f7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100b82:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b89:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80100b90:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100b96:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100b99:	e9 ca 00 00 00       	jmp    80100c68 <exec+0x170>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ba1:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100ba7:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bae:	00 
80100baf:	89 54 24 08          	mov    %edx,0x8(%esp)
80100bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100bba:	89 04 24             	mov    %eax,(%esp)
80100bbd:	e8 de 11 00 00       	call   80101da0 <readi>
80100bc2:	83 f8 20             	cmp    $0x20,%eax
80100bc5:	0f 85 27 03 00 00    	jne    80100ef2 <exec+0x3fa>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bcb:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bd1:	83 f8 01             	cmp    $0x1,%eax
80100bd4:	0f 85 80 00 00 00    	jne    80100c5a <exec+0x162>
      continue;
    if(ph.memsz < ph.filesz)
80100bda:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100be0:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100be6:	39 c2                	cmp    %eax,%edx
80100be8:	0f 82 07 03 00 00    	jb     80100ef5 <exec+0x3fd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bee:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bf4:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100bfa:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100bfd:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c04:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100c0b:	89 04 24             	mov    %eax,(%esp)
80100c0e:	e8 da 71 00 00       	call   80107ded <allocuvm>
80100c13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100c16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100c1a:	0f 84 d8 02 00 00    	je     80100ef8 <exec+0x400>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c20:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c26:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c2c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c32:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c36:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80100c3d:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c41:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100c48:	89 04 24             	mov    %eax,(%esp)
80100c4b:	e8 ad 70 00 00       	call   80107cfd <loaduvm>
80100c50:	85 c0                	test   %eax,%eax
80100c52:	0f 88 a3 02 00 00    	js     80100efb <exec+0x403>
80100c58:	eb 01                	jmp    80100c5b <exec+0x163>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c5a:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c5b:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
80100c5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100c62:	83 c0 20             	add    $0x20,%eax
80100c65:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100c68:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c6f:	0f b7 c0             	movzwl %ax,%eax
80100c72:	3b 45 d8             	cmp    -0x28(%ebp),%eax
80100c75:	0f 8f 23 ff ff ff    	jg     80100b9e <exec+0xa6>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100c7e:	89 04 24             	mov    %eax,(%esp)
80100c81:	e8 a8 0e 00 00       	call   80101b2e <iunlockput>
  ip = 0;
80100c86:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c90:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100c9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ca0:	05 00 20 00 00       	add    $0x2000,%eax
80100ca5:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cac:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100cb3:	89 04 24             	mov    %eax,(%esp)
80100cb6:	e8 32 71 00 00       	call   80107ded <allocuvm>
80100cbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100cbe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100cc2:	0f 84 36 02 00 00    	je     80100efe <exec+0x406>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ccb:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100cd7:	89 04 24             	mov    %eax,(%esp)
80100cda:	e8 32 73 00 00       	call   80108011 <clearpteu>
  sp = sz;
80100cdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ce2:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ce5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80100cec:	e9 81 00 00 00       	jmp    80100d72 <exec+0x27a>
    if(argc >= MAXARG)
80100cf1:	83 7d e0 1f          	cmpl   $0x1f,-0x20(%ebp)
80100cf5:	0f 87 06 02 00 00    	ja     80100f01 <exec+0x409>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cfe:	c1 e0 02             	shl    $0x2,%eax
80100d01:	03 45 0c             	add    0xc(%ebp),%eax
80100d04:	8b 00                	mov    (%eax),%eax
80100d06:	89 04 24             	mov    %eax,(%esp)
80100d09:	e8 9d 44 00 00       	call   801051ab <strlen>
80100d0e:	f7 d0                	not    %eax
80100d10:	03 45 e8             	add    -0x18(%ebp),%eax
80100d13:	83 e0 fc             	and    $0xfffffffc,%eax
80100d16:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d19:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d1c:	c1 e0 02             	shl    $0x2,%eax
80100d1f:	03 45 0c             	add    0xc(%ebp),%eax
80100d22:	8b 00                	mov    (%eax),%eax
80100d24:	89 04 24             	mov    %eax,(%esp)
80100d27:	e8 7f 44 00 00       	call   801051ab <strlen>
80100d2c:	83 c0 01             	add    $0x1,%eax
80100d2f:	89 c2                	mov    %eax,%edx
80100d31:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d34:	c1 e0 02             	shl    $0x2,%eax
80100d37:	03 45 0c             	add    0xc(%ebp),%eax
80100d3a:	8b 00                	mov    (%eax),%eax
80100d3c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d40:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d44:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d47:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100d4e:	89 04 24             	mov    %eax,(%esp)
80100d51:	e8 80 74 00 00       	call   801081d6 <copyout>
80100d56:	85 c0                	test   %eax,%eax
80100d58:	0f 88 a6 01 00 00    	js     80100f04 <exec+0x40c>
      goto bad;
    ustack[3+argc] = sp;
80100d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d61:	8d 50 03             	lea    0x3(%eax),%edx
80100d64:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d67:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d6e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80100d72:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d75:	c1 e0 02             	shl    $0x2,%eax
80100d78:	03 45 0c             	add    0xc(%ebp),%eax
80100d7b:	8b 00                	mov    (%eax),%eax
80100d7d:	85 c0                	test   %eax,%eax
80100d7f:	0f 85 6c ff ff ff    	jne    80100cf1 <exec+0x1f9>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100d85:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d88:	83 c0 03             	add    $0x3,%eax
80100d8b:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100d92:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100d96:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100d9d:	ff ff ff 
  ustack[1] = argc;
80100da0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da3:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100da9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dac:	83 c0 01             	add    $0x1,%eax
80100daf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100db6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100db9:	29 d0                	sub    %edx,%eax
80100dbb:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100dc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dc4:	83 c0 04             	add    $0x4,%eax
80100dc7:	c1 e0 02             	shl    $0x2,%eax
80100dca:	29 45 e8             	sub    %eax,-0x18(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dd0:	83 c0 04             	add    $0x4,%eax
80100dd3:	c1 e0 02             	shl    $0x2,%eax
80100dd6:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100dda:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100de0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100de4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100de7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100dee:	89 04 24             	mov    %eax,(%esp)
80100df1:	e8 e0 73 00 00       	call   801081d6 <copyout>
80100df6:	85 c0                	test   %eax,%eax
80100df8:	0f 88 09 01 00 00    	js     80100f07 <exec+0x40f>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100dfe:	8b 45 08             	mov    0x8(%ebp),%eax
80100e01:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100e04:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e07:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100e0a:	eb 17                	jmp    80100e23 <exec+0x32b>
    if(*s == '/')
80100e0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e0f:	0f b6 00             	movzbl (%eax),%eax
80100e12:	3c 2f                	cmp    $0x2f,%al
80100e14:	75 09                	jne    80100e1f <exec+0x327>
      last = s+1;
80100e16:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e19:	83 c0 01             	add    $0x1,%eax
80100e1c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e1f:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
80100e23:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e26:	0f b6 00             	movzbl (%eax),%eax
80100e29:	84 c0                	test   %al,%al
80100e2b:	75 df                	jne    80100e0c <exec+0x314>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e33:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e36:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e3d:	00 
80100e3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e41:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e45:	89 14 24             	mov    %edx,(%esp)
80100e48:	e8 10 43 00 00       	call   8010515d <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e53:	8b 40 04             	mov    0x4(%eax),%eax
80100e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->pgdir = pgdir;
80100e59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100e62:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100e6e:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e76:	8b 40 18             	mov    0x18(%eax),%eax
80100e79:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100e7f:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100e82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e88:	8b 40 18             	mov    0x18(%eax),%eax
80100e8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
80100e8e:	89 50 44             	mov    %edx,0x44(%eax)
  proc->next = 0;
80100e91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e97:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80100e9e:	00 00 00 
  proc->prev = 0;
80100ea1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea7:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  proc->state = RUNNABLE;
80100eae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  ready(proc);
80100ebb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec1:	89 04 24             	mov    %eax,(%esp)
80100ec4:	e8 5f 33 00 00       	call   80104228 <ready>
  switchuvm(proc);
80100ec9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ecf:	89 04 24             	mov    %eax,(%esp)
80100ed2:	e8 34 6c 00 00       	call   80107b0b <switchuvm>
  freevm(oldpgdir);
80100ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eda:	89 04 24             	mov    %eax,(%esp)
80100edd:	e8 a1 70 00 00       	call   80107f83 <freevm>
  return 0;
80100ee2:	b8 00 00 00 00       	mov    $0x0,%eax
80100ee7:	eb 46                	jmp    80100f2f <exec+0x437>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100ee9:	90                   	nop
80100eea:	eb 1c                	jmp    80100f08 <exec+0x410>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100eec:	90                   	nop
80100eed:	eb 19                	jmp    80100f08 <exec+0x410>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100eef:	90                   	nop
80100ef0:	eb 16                	jmp    80100f08 <exec+0x410>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100ef2:	90                   	nop
80100ef3:	eb 13                	jmp    80100f08 <exec+0x410>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ef5:	90                   	nop
80100ef6:	eb 10                	jmp    80100f08 <exec+0x410>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100ef8:	90                   	nop
80100ef9:	eb 0d                	jmp    80100f08 <exec+0x410>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100efb:	90                   	nop
80100efc:	eb 0a                	jmp    80100f08 <exec+0x410>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100efe:	90                   	nop
80100eff:	eb 07                	jmp    80100f08 <exec+0x410>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100f01:	90                   	nop
80100f02:	eb 04                	jmp    80100f08 <exec+0x410>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100f04:	90                   	nop
80100f05:	eb 01                	jmp    80100f08 <exec+0x410>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f07:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100f0c:	74 0b                	je     80100f19 <exec+0x421>
    freevm(pgdir);
80100f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100f11:	89 04 24             	mov    %eax,(%esp)
80100f14:	e8 6a 70 00 00       	call   80107f83 <freevm>
  if(ip)
80100f19:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100f1d:	74 0b                	je     80100f2a <exec+0x432>
    iunlockput(ip);
80100f1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100f22:	89 04 24             	mov    %eax,(%esp)
80100f25:	e8 04 0c 00 00       	call   80101b2e <iunlockput>
  return -1;
80100f2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f2f:	c9                   	leave  
80100f30:	c3                   	ret    
80100f31:	00 00                	add    %al,(%eax)
	...

80100f34 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f34:	55                   	push   %ebp
80100f35:	89 e5                	mov    %esp,%ebp
80100f37:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f3a:	c7 44 24 04 dd 82 10 	movl   $0x801082dd,0x4(%esp)
80100f41:	80 
80100f42:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f49:	e8 6c 3d 00 00       	call   80104cba <initlock>
}
80100f4e:	c9                   	leave  
80100f4f:	c3                   	ret    

80100f50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f56:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f5d:	e8 79 3d 00 00       	call   80104cdb <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f62:	c7 45 f4 94 de 10 80 	movl   $0x8010de94,-0xc(%ebp)
80100f69:	eb 29                	jmp    80100f94 <filealloc+0x44>
    if(f->ref == 0){
80100f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f6e:	8b 40 04             	mov    0x4(%eax),%eax
80100f71:	85 c0                	test   %eax,%eax
80100f73:	75 1b                	jne    80100f90 <filealloc+0x40>
      f->ref = 1;
80100f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f78:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f7f:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f86:	e8 b1 3d 00 00       	call   80104d3c <release>
      return f;
80100f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f8e:	eb 1f                	jmp    80100faf <filealloc+0x5f>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f90:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f94:	b8 f4 e7 10 80       	mov    $0x8010e7f4,%eax
80100f99:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100f9c:	72 cd                	jb     80100f6b <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f9e:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fa5:	e8 92 3d 00 00       	call   80104d3c <release>
  return 0;
80100faa:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100faf:	c9                   	leave  
80100fb0:	c3                   	ret    

80100fb1 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fb1:	55                   	push   %ebp
80100fb2:	89 e5                	mov    %esp,%ebp
80100fb4:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100fb7:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fbe:	e8 18 3d 00 00       	call   80104cdb <acquire>
  if(f->ref < 1)
80100fc3:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc6:	8b 40 04             	mov    0x4(%eax),%eax
80100fc9:	85 c0                	test   %eax,%eax
80100fcb:	7f 0c                	jg     80100fd9 <filedup+0x28>
    panic("filedup");
80100fcd:	c7 04 24 e4 82 10 80 	movl   $0x801082e4,(%esp)
80100fd4:	e8 61 f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fd9:	8b 45 08             	mov    0x8(%ebp),%eax
80100fdc:	8b 40 04             	mov    0x4(%eax),%eax
80100fdf:	8d 50 01             	lea    0x1(%eax),%edx
80100fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe5:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fe8:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fef:	e8 48 3d 00 00       	call   80104d3c <release>
  return f;
80100ff4:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100ff7:	c9                   	leave  
80100ff8:	c3                   	ret    

80100ff9 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ff9:	55                   	push   %ebp
80100ffa:	89 e5                	mov    %esp,%ebp
80100ffc:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fff:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101006:	e8 d0 3c 00 00       	call   80104cdb <acquire>
  if(f->ref < 1)
8010100b:	8b 45 08             	mov    0x8(%ebp),%eax
8010100e:	8b 40 04             	mov    0x4(%eax),%eax
80101011:	85 c0                	test   %eax,%eax
80101013:	7f 0c                	jg     80101021 <fileclose+0x28>
    panic("fileclose");
80101015:	c7 04 24 ec 82 10 80 	movl   $0x801082ec,(%esp)
8010101c:	e8 19 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80101021:	8b 45 08             	mov    0x8(%ebp),%eax
80101024:	8b 40 04             	mov    0x4(%eax),%eax
80101027:	8d 50 ff             	lea    -0x1(%eax),%edx
8010102a:	8b 45 08             	mov    0x8(%ebp),%eax
8010102d:	89 50 04             	mov    %edx,0x4(%eax)
80101030:	8b 45 08             	mov    0x8(%ebp),%eax
80101033:	8b 40 04             	mov    0x4(%eax),%eax
80101036:	85 c0                	test   %eax,%eax
80101038:	7e 11                	jle    8010104b <fileclose+0x52>
    release(&ftable.lock);
8010103a:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101041:	e8 f6 3c 00 00       	call   80104d3c <release>
    return;
80101046:	e9 82 00 00 00       	jmp    801010cd <fileclose+0xd4>
  }
  ff = *f;
8010104b:	8b 45 08             	mov    0x8(%ebp),%eax
8010104e:	8b 10                	mov    (%eax),%edx
80101050:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101053:	8b 50 04             	mov    0x4(%eax),%edx
80101056:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101059:	8b 50 08             	mov    0x8(%eax),%edx
8010105c:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010105f:	8b 50 0c             	mov    0xc(%eax),%edx
80101062:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101065:	8b 50 10             	mov    0x10(%eax),%edx
80101068:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010106b:	8b 40 14             	mov    0x14(%eax),%eax
8010106e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101071:	8b 45 08             	mov    0x8(%ebp),%eax
80101074:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010107b:	8b 45 08             	mov    0x8(%ebp),%eax
8010107e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101084:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
8010108b:	e8 ac 3c 00 00       	call   80104d3c <release>
  
  if(ff.type == FD_PIPE)
80101090:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101093:	83 f8 01             	cmp    $0x1,%eax
80101096:	75 18                	jne    801010b0 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101098:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010109c:	0f be d0             	movsbl %al,%edx
8010109f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010a2:	89 54 24 04          	mov    %edx,0x4(%esp)
801010a6:	89 04 24             	mov    %eax,(%esp)
801010a9:	e8 c9 2c 00 00       	call   80103d77 <pipeclose>
801010ae:	eb 1d                	jmp    801010cd <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b3:	83 f8 02             	cmp    $0x2,%eax
801010b6:	75 15                	jne    801010cd <fileclose+0xd4>
    begin_trans();
801010b8:	e8 81 21 00 00       	call   8010323e <begin_trans>
    iput(ff.ip);
801010bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010c0:	89 04 24             	mov    %eax,(%esp)
801010c3:	e8 95 09 00 00       	call   80101a5d <iput>
    commit_trans();
801010c8:	e8 ba 21 00 00       	call   80103287 <commit_trans>
  }
}
801010cd:	c9                   	leave  
801010ce:	c3                   	ret    

801010cf <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010cf:	55                   	push   %ebp
801010d0:	89 e5                	mov    %esp,%ebp
801010d2:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010d5:	8b 45 08             	mov    0x8(%ebp),%eax
801010d8:	8b 00                	mov    (%eax),%eax
801010da:	83 f8 02             	cmp    $0x2,%eax
801010dd:	75 38                	jne    80101117 <filestat+0x48>
    ilock(f->ip);
801010df:	8b 45 08             	mov    0x8(%ebp),%eax
801010e2:	8b 40 10             	mov    0x10(%eax),%eax
801010e5:	89 04 24             	mov    %eax,(%esp)
801010e8:	e8 ba 07 00 00       	call   801018a7 <ilock>
    stati(f->ip, st);
801010ed:	8b 45 08             	mov    0x8(%ebp),%eax
801010f0:	8b 40 10             	mov    0x10(%eax),%eax
801010f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801010f6:	89 54 24 04          	mov    %edx,0x4(%esp)
801010fa:	89 04 24             	mov    %eax,(%esp)
801010fd:	e8 59 0c 00 00       	call   80101d5b <stati>
    iunlock(f->ip);
80101102:	8b 45 08             	mov    0x8(%ebp),%eax
80101105:	8b 40 10             	mov    0x10(%eax),%eax
80101108:	89 04 24             	mov    %eax,(%esp)
8010110b:	e8 e8 08 00 00       	call   801019f8 <iunlock>
    return 0;
80101110:	b8 00 00 00 00       	mov    $0x0,%eax
80101115:	eb 05                	jmp    8010111c <filestat+0x4d>
  }
  return -1;
80101117:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010111c:	c9                   	leave  
8010111d:	c3                   	ret    

8010111e <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010111e:	55                   	push   %ebp
8010111f:	89 e5                	mov    %esp,%ebp
80101121:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101124:	8b 45 08             	mov    0x8(%ebp),%eax
80101127:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010112b:	84 c0                	test   %al,%al
8010112d:	75 0a                	jne    80101139 <fileread+0x1b>
    return -1;
8010112f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101134:	e9 9f 00 00 00       	jmp    801011d8 <fileread+0xba>
  if(f->type == FD_PIPE)
80101139:	8b 45 08             	mov    0x8(%ebp),%eax
8010113c:	8b 00                	mov    (%eax),%eax
8010113e:	83 f8 01             	cmp    $0x1,%eax
80101141:	75 1e                	jne    80101161 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101143:	8b 45 08             	mov    0x8(%ebp),%eax
80101146:	8b 40 0c             	mov    0xc(%eax),%eax
80101149:	8b 55 10             	mov    0x10(%ebp),%edx
8010114c:	89 54 24 08          	mov    %edx,0x8(%esp)
80101150:	8b 55 0c             	mov    0xc(%ebp),%edx
80101153:	89 54 24 04          	mov    %edx,0x4(%esp)
80101157:	89 04 24             	mov    %eax,(%esp)
8010115a:	e8 9a 2d 00 00       	call   80103ef9 <piperead>
8010115f:	eb 77                	jmp    801011d8 <fileread+0xba>
  if(f->type == FD_INODE){
80101161:	8b 45 08             	mov    0x8(%ebp),%eax
80101164:	8b 00                	mov    (%eax),%eax
80101166:	83 f8 02             	cmp    $0x2,%eax
80101169:	75 61                	jne    801011cc <fileread+0xae>
    ilock(f->ip);
8010116b:	8b 45 08             	mov    0x8(%ebp),%eax
8010116e:	8b 40 10             	mov    0x10(%eax),%eax
80101171:	89 04 24             	mov    %eax,(%esp)
80101174:	e8 2e 07 00 00       	call   801018a7 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101179:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010117c:	8b 45 08             	mov    0x8(%ebp),%eax
8010117f:	8b 50 14             	mov    0x14(%eax),%edx
80101182:	8b 45 08             	mov    0x8(%ebp),%eax
80101185:	8b 40 10             	mov    0x10(%eax),%eax
80101188:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010118c:	89 54 24 08          	mov    %edx,0x8(%esp)
80101190:	8b 55 0c             	mov    0xc(%ebp),%edx
80101193:	89 54 24 04          	mov    %edx,0x4(%esp)
80101197:	89 04 24             	mov    %eax,(%esp)
8010119a:	e8 01 0c 00 00       	call   80101da0 <readi>
8010119f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011a6:	7e 11                	jle    801011b9 <fileread+0x9b>
      f->off += r;
801011a8:	8b 45 08             	mov    0x8(%ebp),%eax
801011ab:	8b 50 14             	mov    0x14(%eax),%edx
801011ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011b1:	01 c2                	add    %eax,%edx
801011b3:	8b 45 08             	mov    0x8(%ebp),%eax
801011b6:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011b9:	8b 45 08             	mov    0x8(%ebp),%eax
801011bc:	8b 40 10             	mov    0x10(%eax),%eax
801011bf:	89 04 24             	mov    %eax,(%esp)
801011c2:	e8 31 08 00 00       	call   801019f8 <iunlock>
    return r;
801011c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ca:	eb 0c                	jmp    801011d8 <fileread+0xba>
  }
  panic("fileread");
801011cc:	c7 04 24 f6 82 10 80 	movl   $0x801082f6,(%esp)
801011d3:	e8 62 f3 ff ff       	call   8010053a <panic>
}
801011d8:	c9                   	leave  
801011d9:	c3                   	ret    

801011da <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011da:	55                   	push   %ebp
801011db:	89 e5                	mov    %esp,%ebp
801011dd:	53                   	push   %ebx
801011de:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011e1:	8b 45 08             	mov    0x8(%ebp),%eax
801011e4:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011e8:	84 c0                	test   %al,%al
801011ea:	75 0a                	jne    801011f6 <filewrite+0x1c>
    return -1;
801011ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011f1:	e9 23 01 00 00       	jmp    80101319 <filewrite+0x13f>
  if(f->type == FD_PIPE)
801011f6:	8b 45 08             	mov    0x8(%ebp),%eax
801011f9:	8b 00                	mov    (%eax),%eax
801011fb:	83 f8 01             	cmp    $0x1,%eax
801011fe:	75 21                	jne    80101221 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
80101200:	8b 45 08             	mov    0x8(%ebp),%eax
80101203:	8b 40 0c             	mov    0xc(%eax),%eax
80101206:	8b 55 10             	mov    0x10(%ebp),%edx
80101209:	89 54 24 08          	mov    %edx,0x8(%esp)
8010120d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101210:	89 54 24 04          	mov    %edx,0x4(%esp)
80101214:	89 04 24             	mov    %eax,(%esp)
80101217:	e8 ed 2b 00 00       	call   80103e09 <pipewrite>
8010121c:	e9 f8 00 00 00       	jmp    80101319 <filewrite+0x13f>
  if(f->type == FD_INODE){
80101221:	8b 45 08             	mov    0x8(%ebp),%eax
80101224:	8b 00                	mov    (%eax),%eax
80101226:	83 f8 02             	cmp    $0x2,%eax
80101229:	0f 85 de 00 00 00    	jne    8010130d <filewrite+0x133>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010122f:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101236:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(i < n){
8010123d:	e9 a8 00 00 00       	jmp    801012ea <filewrite+0x110>
      int n1 = n - i;
80101242:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101245:	8b 55 10             	mov    0x10(%ebp),%edx
80101248:	89 d1                	mov    %edx,%ecx
8010124a:	29 c1                	sub    %eax,%ecx
8010124c:	89 c8                	mov    %ecx,%eax
8010124e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(n1 > max)
80101251:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101254:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101257:	7e 06                	jle    8010125f <filewrite+0x85>
        n1 = max;
80101259:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010125c:	89 45 f4             	mov    %eax,-0xc(%ebp)

      begin_trans();
8010125f:	e8 da 1f 00 00       	call   8010323e <begin_trans>
      ilock(f->ip);
80101264:	8b 45 08             	mov    0x8(%ebp),%eax
80101267:	8b 40 10             	mov    0x10(%eax),%eax
8010126a:	89 04 24             	mov    %eax,(%esp)
8010126d:	e8 35 06 00 00       	call   801018a7 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101272:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101275:	8b 45 08             	mov    0x8(%ebp),%eax
80101278:	8b 48 14             	mov    0x14(%eax),%ecx
8010127b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010127e:	89 c2                	mov    %eax,%edx
80101280:	03 55 0c             	add    0xc(%ebp),%edx
80101283:	8b 45 08             	mov    0x8(%ebp),%eax
80101286:	8b 40 10             	mov    0x10(%eax),%eax
80101289:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010128d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101291:	89 54 24 04          	mov    %edx,0x4(%esp)
80101295:	89 04 24             	mov    %eax,(%esp)
80101298:	e8 6f 0c 00 00       	call   80101f0c <writei>
8010129d:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012a4:	7e 11                	jle    801012b7 <filewrite+0xdd>
        f->off += r;
801012a6:	8b 45 08             	mov    0x8(%ebp),%eax
801012a9:	8b 50 14             	mov    0x14(%eax),%edx
801012ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012af:	01 c2                	add    %eax,%edx
801012b1:	8b 45 08             	mov    0x8(%ebp),%eax
801012b4:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012b7:	8b 45 08             	mov    0x8(%ebp),%eax
801012ba:	8b 40 10             	mov    0x10(%eax),%eax
801012bd:	89 04 24             	mov    %eax,(%esp)
801012c0:	e8 33 07 00 00       	call   801019f8 <iunlock>
      commit_trans();
801012c5:	e8 bd 1f 00 00       	call   80103287 <commit_trans>

      if(r < 0)
801012ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012ce:	78 28                	js     801012f8 <filewrite+0x11e>
        break;
      if(r != n1)
801012d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801012d6:	74 0c                	je     801012e4 <filewrite+0x10a>
        panic("short filewrite");
801012d8:	c7 04 24 ff 82 10 80 	movl   $0x801082ff,(%esp)
801012df:	e8 56 f2 ff ff       	call   8010053a <panic>
      i += r;
801012e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012e7:	01 45 f0             	add    %eax,-0x10(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012ed:	3b 45 10             	cmp    0x10(%ebp),%eax
801012f0:	0f 8c 4c ff ff ff    	jl     80101242 <filewrite+0x68>
801012f6:	eb 01                	jmp    801012f9 <filewrite+0x11f>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
801012f8:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012fc:	3b 45 10             	cmp    0x10(%ebp),%eax
801012ff:	75 05                	jne    80101306 <filewrite+0x12c>
80101301:	8b 45 10             	mov    0x10(%ebp),%eax
80101304:	eb 05                	jmp    8010130b <filewrite+0x131>
80101306:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010130b:	eb 0c                	jmp    80101319 <filewrite+0x13f>
  }
  panic("filewrite");
8010130d:	c7 04 24 0f 83 10 80 	movl   $0x8010830f,(%esp)
80101314:	e8 21 f2 ff ff       	call   8010053a <panic>
}
80101319:	83 c4 24             	add    $0x24,%esp
8010131c:	5b                   	pop    %ebx
8010131d:	5d                   	pop    %ebp
8010131e:	c3                   	ret    
	...

80101320 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101326:	8b 45 08             	mov    0x8(%ebp),%eax
80101329:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101330:	00 
80101331:	89 04 24             	mov    %eax,(%esp)
80101334:	e8 6e ee ff ff       	call   801001a7 <bread>
80101339:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010133c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010133f:	83 c0 18             	add    $0x18,%eax
80101342:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101349:	00 
8010134a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010134e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101351:	89 04 24             	mov    %eax,(%esp)
80101354:	e8 a4 3c 00 00       	call   80104ffd <memmove>
  brelse(bp);
80101359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010135c:	89 04 24             	mov    %eax,(%esp)
8010135f:	e8 b4 ee ff ff       	call   80100218 <brelse>
}
80101364:	c9                   	leave  
80101365:	c3                   	ret    

80101366 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101366:	55                   	push   %ebp
80101367:	89 e5                	mov    %esp,%ebp
80101369:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010136c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010136f:	8b 45 08             	mov    0x8(%ebp),%eax
80101372:	89 54 24 04          	mov    %edx,0x4(%esp)
80101376:	89 04 24             	mov    %eax,(%esp)
80101379:	e8 29 ee ff ff       	call   801001a7 <bread>
8010137e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101384:	83 c0 18             	add    $0x18,%eax
80101387:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010138e:	00 
8010138f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101396:	00 
80101397:	89 04 24             	mov    %eax,(%esp)
8010139a:	e8 8b 3b 00 00       	call   80104f2a <memset>
  log_write(bp);
8010139f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a2:	89 04 24             	mov    %eax,(%esp)
801013a5:	e8 35 1f 00 00       	call   801032df <log_write>
  brelse(bp);
801013aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ad:	89 04 24             	mov    %eax,(%esp)
801013b0:	e8 63 ee ff ff       	call   80100218 <brelse>
}
801013b5:	c9                   	leave  
801013b6:	c3                   	ret    

801013b7 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013b7:	55                   	push   %ebp
801013b8:	89 e5                	mov    %esp,%ebp
801013ba:	53                   	push   %ebx
801013bb:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  readsb(dev, &sb);
801013c5:	8b 45 08             	mov    0x8(%ebp),%eax
801013c8:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013cb:	89 54 24 04          	mov    %edx,0x4(%esp)
801013cf:	89 04 24             	mov    %eax,(%esp)
801013d2:	e8 49 ff ff ff       	call   80101320 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
801013de:	e9 15 01 00 00       	jmp    801014f8 <balloc+0x141>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013e6:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013ec:	85 c0                	test   %eax,%eax
801013ee:	0f 48 c2             	cmovs  %edx,%eax
801013f1:	c1 f8 0c             	sar    $0xc,%eax
801013f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013f7:	c1 ea 03             	shr    $0x3,%edx
801013fa:	01 d0                	add    %edx,%eax
801013fc:	83 c0 03             	add    $0x3,%eax
801013ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80101403:	8b 45 08             	mov    0x8(%ebp),%eax
80101406:	89 04 24             	mov    %eax,(%esp)
80101409:	e8 99 ed ff ff       	call   801001a7 <bread>
8010140e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101411:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101418:	e9 aa 00 00 00       	jmp    801014c7 <balloc+0x110>
      m = 1 << (bi % 8);
8010141d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101420:	89 c2                	mov    %eax,%edx
80101422:	c1 fa 1f             	sar    $0x1f,%edx
80101425:	c1 ea 1d             	shr    $0x1d,%edx
80101428:	01 d0                	add    %edx,%eax
8010142a:	83 e0 07             	and    $0x7,%eax
8010142d:	29 d0                	sub    %edx,%eax
8010142f:	ba 01 00 00 00       	mov    $0x1,%edx
80101434:	89 d3                	mov    %edx,%ebx
80101436:	89 c1                	mov    %eax,%ecx
80101438:	d3 e3                	shl    %cl,%ebx
8010143a:	89 d8                	mov    %ebx,%eax
8010143c:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010143f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101442:	8d 50 07             	lea    0x7(%eax),%edx
80101445:	85 c0                	test   %eax,%eax
80101447:	0f 48 c2             	cmovs  %edx,%eax
8010144a:	c1 f8 03             	sar    $0x3,%eax
8010144d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101450:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101455:	0f b6 c0             	movzbl %al,%eax
80101458:	23 45 f0             	and    -0x10(%ebp),%eax
8010145b:	85 c0                	test   %eax,%eax
8010145d:	75 64                	jne    801014c3 <balloc+0x10c>
        bp->data[bi/8] |= m;  // Mark block in use.
8010145f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101462:	8d 50 07             	lea    0x7(%eax),%edx
80101465:	85 c0                	test   %eax,%eax
80101467:	0f 48 c2             	cmovs  %edx,%eax
8010146a:	c1 f8 03             	sar    $0x3,%eax
8010146d:	89 c2                	mov    %eax,%edx
8010146f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80101472:	0f b6 44 01 18       	movzbl 0x18(%ecx,%eax,1),%eax
80101477:	89 c1                	mov    %eax,%ecx
80101479:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010147c:	09 c8                	or     %ecx,%eax
8010147e:	89 c1                	mov    %eax,%ecx
80101480:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101483:	88 4c 10 18          	mov    %cl,0x18(%eax,%edx,1)
        log_write(bp);
80101487:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010148a:	89 04 24             	mov    %eax,(%esp)
8010148d:	e8 4d 1e 00 00       	call   801032df <log_write>
        brelse(bp);
80101492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101495:	89 04 24             	mov    %eax,(%esp)
80101498:	e8 7b ed ff ff       	call   80100218 <brelse>
        bzero(dev, b + bi);
8010149d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014a3:	01 c2                	add    %eax,%edx
801014a5:	8b 45 08             	mov    0x8(%ebp),%eax
801014a8:	89 54 24 04          	mov    %edx,0x4(%esp)
801014ac:	89 04 24             	mov    %eax,(%esp)
801014af:	e8 b2 fe ff ff       	call   80101366 <bzero>
        return b + bi;
801014b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014ba:	8d 04 02             	lea    (%edx,%eax,1),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801014bd:	83 c4 34             	add    $0x34,%esp
801014c0:	5b                   	pop    %ebx
801014c1:	5d                   	pop    %ebp
801014c2:	c3                   	ret    

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014c3:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801014c7:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
801014ce:	7f 16                	jg     801014e6 <balloc+0x12f>
801014d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014d6:	8d 04 02             	lea    (%edx,%eax,1),%eax
801014d9:	89 c2                	mov    %eax,%edx
801014db:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014de:	39 c2                	cmp    %eax,%edx
801014e0:	0f 82 37 ff ff ff    	jb     8010141d <balloc+0x66>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014e9:	89 04 24             	mov    %eax,(%esp)
801014ec:	e8 27 ed ff ff       	call   80100218 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014f1:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
801014f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014fe:	39 c2                	cmp    %eax,%edx
80101500:	0f 82 dd fe ff ff    	jb     801013e3 <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101506:	c7 04 24 19 83 10 80 	movl   $0x80108319,(%esp)
8010150d:	e8 28 f0 ff ff       	call   8010053a <panic>

80101512 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101512:	55                   	push   %ebp
80101513:	89 e5                	mov    %esp,%ebp
80101515:	53                   	push   %ebx
80101516:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101519:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010151c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101520:	8b 45 08             	mov    0x8(%ebp),%eax
80101523:	89 04 24             	mov    %eax,(%esp)
80101526:	e8 f5 fd ff ff       	call   80101320 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
8010152b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010152e:	89 c2                	mov    %eax,%edx
80101530:	c1 ea 0c             	shr    $0xc,%edx
80101533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101536:	c1 e8 03             	shr    $0x3,%eax
80101539:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010153c:	8d 50 03             	lea    0x3(%eax),%edx
8010153f:	8b 45 08             	mov    0x8(%ebp),%eax
80101542:	89 54 24 04          	mov    %edx,0x4(%esp)
80101546:	89 04 24             	mov    %eax,(%esp)
80101549:	e8 59 ec ff ff       	call   801001a7 <bread>
8010154e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  bi = b % BPB;
80101551:	8b 45 0c             	mov    0xc(%ebp),%eax
80101554:	25 ff 0f 00 00       	and    $0xfff,%eax
80101559:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010155c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010155f:	89 c2                	mov    %eax,%edx
80101561:	c1 fa 1f             	sar    $0x1f,%edx
80101564:	c1 ea 1d             	shr    $0x1d,%edx
80101567:	01 d0                	add    %edx,%eax
80101569:	83 e0 07             	and    $0x7,%eax
8010156c:	29 d0                	sub    %edx,%eax
8010156e:	ba 01 00 00 00       	mov    $0x1,%edx
80101573:	89 d3                	mov    %edx,%ebx
80101575:	89 c1                	mov    %eax,%ecx
80101577:	d3 e3                	shl    %cl,%ebx
80101579:	89 d8                	mov    %ebx,%eax
8010157b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010157e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101581:	8d 50 07             	lea    0x7(%eax),%edx
80101584:	85 c0                	test   %eax,%eax
80101586:	0f 48 c2             	cmovs  %edx,%eax
80101589:	c1 f8 03             	sar    $0x3,%eax
8010158c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010158f:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101594:	0f b6 c0             	movzbl %al,%eax
80101597:	23 45 f4             	and    -0xc(%ebp),%eax
8010159a:	85 c0                	test   %eax,%eax
8010159c:	75 0c                	jne    801015aa <bfree+0x98>
    panic("freeing free block");
8010159e:	c7 04 24 2f 83 10 80 	movl   $0x8010832f,(%esp)
801015a5:	e8 90 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
801015aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ad:	8d 50 07             	lea    0x7(%eax),%edx
801015b0:	85 c0                	test   %eax,%eax
801015b2:	0f 48 c2             	cmovs  %edx,%eax
801015b5:	c1 f8 03             	sar    $0x3,%eax
801015b8:	89 c2                	mov    %eax,%edx
801015ba:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015bd:	0f b6 44 01 18       	movzbl 0x18(%ecx,%eax,1),%eax
801015c2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801015c5:	f7 d1                	not    %ecx
801015c7:	21 c8                	and    %ecx,%eax
801015c9:	89 c1                	mov    %eax,%ecx
801015cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015ce:	88 4c 10 18          	mov    %cl,0x18(%eax,%edx,1)
  log_write(bp);
801015d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015d5:	89 04 24             	mov    %eax,(%esp)
801015d8:	e8 02 1d 00 00       	call   801032df <log_write>
  brelse(bp);
801015dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015e0:	89 04 24             	mov    %eax,(%esp)
801015e3:	e8 30 ec ff ff       	call   80100218 <brelse>
}
801015e8:	83 c4 34             	add    $0x34,%esp
801015eb:	5b                   	pop    %ebx
801015ec:	5d                   	pop    %ebp
801015ed:	c3                   	ret    

801015ee <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015ee:	55                   	push   %ebp
801015ef:	89 e5                	mov    %esp,%ebp
801015f1:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015f4:	c7 44 24 04 42 83 10 	movl   $0x80108342,0x4(%esp)
801015fb:	80 
801015fc:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101603:	e8 b2 36 00 00       	call   80104cba <initlock>
}
80101608:	c9                   	leave  
80101609:	c3                   	ret    

8010160a <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010160a:	55                   	push   %ebp
8010160b:	89 e5                	mov    %esp,%ebp
8010160d:	83 ec 48             	sub    $0x48,%esp
80101610:	8b 45 0c             	mov    0xc(%ebp),%eax
80101613:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101617:	8b 45 08             	mov    0x8(%ebp),%eax
8010161a:	8d 55 dc             	lea    -0x24(%ebp),%edx
8010161d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101621:	89 04 24             	mov    %eax,(%esp)
80101624:	e8 f7 fc ff ff       	call   80101320 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
80101630:	e9 98 00 00 00       	jmp    801016cd <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
80101635:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101638:	c1 e8 03             	shr    $0x3,%eax
8010163b:	83 c0 02             	add    $0x2,%eax
8010163e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101642:	8b 45 08             	mov    0x8(%ebp),%eax
80101645:	89 04 24             	mov    %eax,(%esp)
80101648:	e8 5a eb ff ff       	call   801001a7 <bread>
8010164d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101650:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101653:	83 c0 18             	add    $0x18,%eax
80101656:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101659:	83 e2 07             	and    $0x7,%edx
8010165c:	c1 e2 06             	shl    $0x6,%edx
8010165f:	01 d0                	add    %edx,%eax
80101661:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(dip->type == 0){  // a free inode
80101664:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101667:	0f b7 00             	movzwl (%eax),%eax
8010166a:	66 85 c0             	test   %ax,%ax
8010166d:	75 4f                	jne    801016be <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
8010166f:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101676:	00 
80101677:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010167e:	00 
8010167f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101682:	89 04 24             	mov    %eax,(%esp)
80101685:	e8 a0 38 00 00       	call   80104f2a <memset>
      dip->type = type;
8010168a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010168d:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101691:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101694:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101697:	89 04 24             	mov    %eax,(%esp)
8010169a:	e8 40 1c 00 00       	call   801032df <log_write>
      brelse(bp);
8010169f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a2:	89 04 24             	mov    %eax,(%esp)
801016a5:	e8 6e eb ff ff       	call   80100218 <brelse>
      return iget(dev, inum);
801016aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801016b1:	8b 45 08             	mov    0x8(%ebp),%eax
801016b4:	89 04 24             	mov    %eax,(%esp)
801016b7:	e8 e6 00 00 00       	call   801017a2 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801016bc:	c9                   	leave  
801016bd:	c3                   	ret    
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801016be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016c1:	89 04 24             	mov    %eax,(%esp)
801016c4:	e8 4f eb ff ff       	call   80100218 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016c9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801016cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016d3:	39 c2                	cmp    %eax,%edx
801016d5:	0f 82 5a ff ff ff    	jb     80101635 <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016db:	c7 04 24 49 83 10 80 	movl   $0x80108349,(%esp)
801016e2:	e8 53 ee ff ff       	call   8010053a <panic>

801016e7 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016e7:	55                   	push   %ebp
801016e8:	89 e5                	mov    %esp,%ebp
801016ea:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016ed:	8b 45 08             	mov    0x8(%ebp),%eax
801016f0:	8b 40 04             	mov    0x4(%eax),%eax
801016f3:	c1 e8 03             	shr    $0x3,%eax
801016f6:	8d 50 02             	lea    0x2(%eax),%edx
801016f9:	8b 45 08             	mov    0x8(%ebp),%eax
801016fc:	8b 00                	mov    (%eax),%eax
801016fe:	89 54 24 04          	mov    %edx,0x4(%esp)
80101702:	89 04 24             	mov    %eax,(%esp)
80101705:	e8 9d ea ff ff       	call   801001a7 <bread>
8010170a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101710:	83 c0 18             	add    $0x18,%eax
80101713:	89 c2                	mov    %eax,%edx
80101715:	8b 45 08             	mov    0x8(%ebp),%eax
80101718:	8b 40 04             	mov    0x4(%eax),%eax
8010171b:	83 e0 07             	and    $0x7,%eax
8010171e:	c1 e0 06             	shl    $0x6,%eax
80101721:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101724:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip->type = ip->type;
80101727:	8b 45 08             	mov    0x8(%ebp),%eax
8010172a:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010172e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101731:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101734:	8b 45 08             	mov    0x8(%ebp),%eax
80101737:	0f b7 50 12          	movzwl 0x12(%eax),%edx
8010173b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010173e:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101742:	8b 45 08             	mov    0x8(%ebp),%eax
80101745:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010174c:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101750:	8b 45 08             	mov    0x8(%ebp),%eax
80101753:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175a:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010175e:	8b 45 08             	mov    0x8(%ebp),%eax
80101761:	8b 50 18             	mov    0x18(%eax),%edx
80101764:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101767:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010176a:	8b 45 08             	mov    0x8(%ebp),%eax
8010176d:	8d 50 1c             	lea    0x1c(%eax),%edx
80101770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101773:	83 c0 0c             	add    $0xc,%eax
80101776:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010177d:	00 
8010177e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101782:	89 04 24             	mov    %eax,(%esp)
80101785:	e8 73 38 00 00       	call   80104ffd <memmove>
  log_write(bp);
8010178a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010178d:	89 04 24             	mov    %eax,(%esp)
80101790:	e8 4a 1b 00 00       	call   801032df <log_write>
  brelse(bp);
80101795:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101798:	89 04 24             	mov    %eax,(%esp)
8010179b:	e8 78 ea ff ff       	call   80100218 <brelse>
}
801017a0:	c9                   	leave  
801017a1:	c3                   	ret    

801017a2 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017a2:	55                   	push   %ebp
801017a3:	89 e5                	mov    %esp,%ebp
801017a5:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017a8:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801017af:	e8 27 35 00 00       	call   80104cdb <acquire>

  // Is the inode already cached?
  empty = 0;
801017b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017bb:	c7 45 f0 94 e8 10 80 	movl   $0x8010e894,-0x10(%ebp)
801017c2:	eb 59                	jmp    8010181d <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c7:	8b 40 08             	mov    0x8(%eax),%eax
801017ca:	85 c0                	test   %eax,%eax
801017cc:	7e 35                	jle    80101803 <iget+0x61>
801017ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d1:	8b 00                	mov    (%eax),%eax
801017d3:	3b 45 08             	cmp    0x8(%ebp),%eax
801017d6:	75 2b                	jne    80101803 <iget+0x61>
801017d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017db:	8b 40 04             	mov    0x4(%eax),%eax
801017de:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017e1:	75 20                	jne    80101803 <iget+0x61>
      ip->ref++;
801017e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e6:	8b 40 08             	mov    0x8(%eax),%eax
801017e9:	8d 50 01             	lea    0x1(%eax),%edx
801017ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ef:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017f2:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801017f9:	e8 3e 35 00 00       	call   80104d3c <release>
      return ip;
801017fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101801:	eb 70                	jmp    80101873 <iget+0xd1>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101803:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101807:	75 10                	jne    80101819 <iget+0x77>
80101809:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010180c:	8b 40 08             	mov    0x8(%eax),%eax
8010180f:	85 c0                	test   %eax,%eax
80101811:	75 06                	jne    80101819 <iget+0x77>
      empty = ip;
80101813:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101816:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101819:	83 45 f0 50          	addl   $0x50,-0x10(%ebp)
8010181d:	b8 34 f8 10 80       	mov    $0x8010f834,%eax
80101822:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80101825:	72 9d                	jb     801017c4 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101827:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010182b:	75 0c                	jne    80101839 <iget+0x97>
    panic("iget: no inodes");
8010182d:	c7 04 24 5b 83 10 80 	movl   $0x8010835b,(%esp)
80101834:	e8 01 ed ff ff       	call   8010053a <panic>

  ip = empty;
80101839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ip->dev = dev;
8010183f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101842:	8b 55 08             	mov    0x8(%ebp),%edx
80101845:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101847:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010184a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010184d:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101850:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101853:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010185a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010185d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101864:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010186b:	e8 cc 34 00 00       	call   80104d3c <release>

  return ip;
80101870:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80101873:	c9                   	leave  
80101874:	c3                   	ret    

80101875 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101875:	55                   	push   %ebp
80101876:	89 e5                	mov    %esp,%ebp
80101878:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010187b:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101882:	e8 54 34 00 00       	call   80104cdb <acquire>
  ip->ref++;
80101887:	8b 45 08             	mov    0x8(%ebp),%eax
8010188a:	8b 40 08             	mov    0x8(%eax),%eax
8010188d:	8d 50 01             	lea    0x1(%eax),%edx
80101890:	8b 45 08             	mov    0x8(%ebp),%eax
80101893:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101896:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010189d:	e8 9a 34 00 00       	call   80104d3c <release>
  return ip;
801018a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018a5:	c9                   	leave  
801018a6:	c3                   	ret    

801018a7 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018a7:	55                   	push   %ebp
801018a8:	89 e5                	mov    %esp,%ebp
801018aa:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018b1:	74 0a                	je     801018bd <ilock+0x16>
801018b3:	8b 45 08             	mov    0x8(%ebp),%eax
801018b6:	8b 40 08             	mov    0x8(%eax),%eax
801018b9:	85 c0                	test   %eax,%eax
801018bb:	7f 0c                	jg     801018c9 <ilock+0x22>
    panic("ilock");
801018bd:	c7 04 24 6b 83 10 80 	movl   $0x8010836b,(%esp)
801018c4:	e8 71 ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801018c9:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801018d0:	e8 06 34 00 00       	call   80104cdb <acquire>
  while(ip->flags & I_BUSY)
801018d5:	eb 13                	jmp    801018ea <ilock+0x43>
    sleep(ip, &icache.lock);
801018d7:	c7 44 24 04 60 e8 10 	movl   $0x8010e860,0x4(%esp)
801018de:	80 
801018df:	8b 45 08             	mov    0x8(%ebp),%eax
801018e2:	89 04 24             	mov    %eax,(%esp)
801018e5:	e8 02 31 00 00       	call   801049ec <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018ea:	8b 45 08             	mov    0x8(%ebp),%eax
801018ed:	8b 40 0c             	mov    0xc(%eax),%eax
801018f0:	83 e0 01             	and    $0x1,%eax
801018f3:	84 c0                	test   %al,%al
801018f5:	75 e0                	jne    801018d7 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018f7:	8b 45 08             	mov    0x8(%ebp),%eax
801018fa:	8b 40 0c             	mov    0xc(%eax),%eax
801018fd:	89 c2                	mov    %eax,%edx
801018ff:	83 ca 01             	or     $0x1,%edx
80101902:	8b 45 08             	mov    0x8(%ebp),%eax
80101905:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101908:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010190f:	e8 28 34 00 00       	call   80104d3c <release>

  if(!(ip->flags & I_VALID)){
80101914:	8b 45 08             	mov    0x8(%ebp),%eax
80101917:	8b 40 0c             	mov    0xc(%eax),%eax
8010191a:	83 e0 02             	and    $0x2,%eax
8010191d:	85 c0                	test   %eax,%eax
8010191f:	0f 85 d1 00 00 00    	jne    801019f6 <ilock+0x14f>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101925:	8b 45 08             	mov    0x8(%ebp),%eax
80101928:	8b 40 04             	mov    0x4(%eax),%eax
8010192b:	c1 e8 03             	shr    $0x3,%eax
8010192e:	8d 50 02             	lea    0x2(%eax),%edx
80101931:	8b 45 08             	mov    0x8(%ebp),%eax
80101934:	8b 00                	mov    (%eax),%eax
80101936:	89 54 24 04          	mov    %edx,0x4(%esp)
8010193a:	89 04 24             	mov    %eax,(%esp)
8010193d:	e8 65 e8 ff ff       	call   801001a7 <bread>
80101942:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101945:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101948:	83 c0 18             	add    $0x18,%eax
8010194b:	89 c2                	mov    %eax,%edx
8010194d:	8b 45 08             	mov    0x8(%ebp),%eax
80101950:	8b 40 04             	mov    0x4(%eax),%eax
80101953:	83 e0 07             	and    $0x7,%eax
80101956:	c1 e0 06             	shl    $0x6,%eax
80101959:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010195c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ip->type = dip->type;
8010195f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101962:	0f b7 10             	movzwl (%eax),%edx
80101965:	8b 45 08             	mov    0x8(%ebp),%eax
80101968:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010196c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196f:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101973:	8b 45 08             	mov    0x8(%ebp),%eax
80101976:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010197a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010197d:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101981:	8b 45 08             	mov    0x8(%ebp),%eax
80101984:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101988:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010198b:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010198f:	8b 45 08             	mov    0x8(%ebp),%eax
80101992:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101996:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101999:	8b 50 08             	mov    0x8(%eax),%edx
8010199c:	8b 45 08             	mov    0x8(%ebp),%eax
8010199f:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a5:	8d 50 0c             	lea    0xc(%eax),%edx
801019a8:	8b 45 08             	mov    0x8(%ebp),%eax
801019ab:	83 c0 1c             	add    $0x1c,%eax
801019ae:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801019b5:	00 
801019b6:	89 54 24 04          	mov    %edx,0x4(%esp)
801019ba:	89 04 24             	mov    %eax,(%esp)
801019bd:	e8 3b 36 00 00       	call   80104ffd <memmove>
    brelse(bp);
801019c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019c5:	89 04 24             	mov    %eax,(%esp)
801019c8:	e8 4b e8 ff ff       	call   80100218 <brelse>
    ip->flags |= I_VALID;
801019cd:	8b 45 08             	mov    0x8(%ebp),%eax
801019d0:	8b 40 0c             	mov    0xc(%eax),%eax
801019d3:	89 c2                	mov    %eax,%edx
801019d5:	83 ca 02             	or     $0x2,%edx
801019d8:	8b 45 08             	mov    0x8(%ebp),%eax
801019db:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019de:	8b 45 08             	mov    0x8(%ebp),%eax
801019e1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019e5:	66 85 c0             	test   %ax,%ax
801019e8:	75 0c                	jne    801019f6 <ilock+0x14f>
      panic("ilock: no type");
801019ea:	c7 04 24 71 83 10 80 	movl   $0x80108371,(%esp)
801019f1:	e8 44 eb ff ff       	call   8010053a <panic>
  }
}
801019f6:	c9                   	leave  
801019f7:	c3                   	ret    

801019f8 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019f8:	55                   	push   %ebp
801019f9:	89 e5                	mov    %esp,%ebp
801019fb:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a02:	74 17                	je     80101a1b <iunlock+0x23>
80101a04:	8b 45 08             	mov    0x8(%ebp),%eax
80101a07:	8b 40 0c             	mov    0xc(%eax),%eax
80101a0a:	83 e0 01             	and    $0x1,%eax
80101a0d:	85 c0                	test   %eax,%eax
80101a0f:	74 0a                	je     80101a1b <iunlock+0x23>
80101a11:	8b 45 08             	mov    0x8(%ebp),%eax
80101a14:	8b 40 08             	mov    0x8(%eax),%eax
80101a17:	85 c0                	test   %eax,%eax
80101a19:	7f 0c                	jg     80101a27 <iunlock+0x2f>
    panic("iunlock");
80101a1b:	c7 04 24 80 83 10 80 	movl   $0x80108380,(%esp)
80101a22:	e8 13 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101a27:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a2e:	e8 a8 32 00 00       	call   80104cdb <acquire>
  ip->flags &= ~I_BUSY;
80101a33:	8b 45 08             	mov    0x8(%ebp),%eax
80101a36:	8b 40 0c             	mov    0xc(%eax),%eax
80101a39:	89 c2                	mov    %eax,%edx
80101a3b:	83 e2 fe             	and    $0xfffffffe,%edx
80101a3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a41:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a44:	8b 45 08             	mov    0x8(%ebp),%eax
80101a47:	89 04 24             	mov    %eax,(%esp)
80101a4a:	e8 85 30 00 00       	call   80104ad4 <wakeup>
  release(&icache.lock);
80101a4f:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a56:	e8 e1 32 00 00       	call   80104d3c <release>
}
80101a5b:	c9                   	leave  
80101a5c:	c3                   	ret    

80101a5d <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a5d:	55                   	push   %ebp
80101a5e:	89 e5                	mov    %esp,%ebp
80101a60:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a63:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a6a:	e8 6c 32 00 00       	call   80104cdb <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a72:	8b 40 08             	mov    0x8(%eax),%eax
80101a75:	83 f8 01             	cmp    $0x1,%eax
80101a78:	0f 85 93 00 00 00    	jne    80101b11 <iput+0xb4>
80101a7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a81:	8b 40 0c             	mov    0xc(%eax),%eax
80101a84:	83 e0 02             	and    $0x2,%eax
80101a87:	85 c0                	test   %eax,%eax
80101a89:	0f 84 82 00 00 00    	je     80101b11 <iput+0xb4>
80101a8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a92:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a96:	66 85 c0             	test   %ax,%ax
80101a99:	75 76                	jne    80101b11 <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9e:	8b 40 0c             	mov    0xc(%eax),%eax
80101aa1:	83 e0 01             	and    $0x1,%eax
80101aa4:	84 c0                	test   %al,%al
80101aa6:	74 0c                	je     80101ab4 <iput+0x57>
      panic("iput busy");
80101aa8:	c7 04 24 88 83 10 80 	movl   $0x80108388,(%esp)
80101aaf:	e8 86 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab7:	8b 40 0c             	mov    0xc(%eax),%eax
80101aba:	89 c2                	mov    %eax,%edx
80101abc:	83 ca 01             	or     $0x1,%edx
80101abf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac2:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101ac5:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101acc:	e8 6b 32 00 00       	call   80104d3c <release>
    itrunc(ip);
80101ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad4:	89 04 24             	mov    %eax,(%esp)
80101ad7:	e8 72 01 00 00       	call   80101c4e <itrunc>
    ip->type = 0;
80101adc:	8b 45 08             	mov    0x8(%ebp),%eax
80101adf:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae8:	89 04 24             	mov    %eax,(%esp)
80101aeb:	e8 f7 fb ff ff       	call   801016e7 <iupdate>
    acquire(&icache.lock);
80101af0:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101af7:	e8 df 31 00 00       	call   80104cdb <acquire>
    ip->flags = 0;
80101afc:	8b 45 08             	mov    0x8(%ebp),%eax
80101aff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b06:	8b 45 08             	mov    0x8(%ebp),%eax
80101b09:	89 04 24             	mov    %eax,(%esp)
80101b0c:	e8 c3 2f 00 00       	call   80104ad4 <wakeup>
  }
  ip->ref--;
80101b11:	8b 45 08             	mov    0x8(%ebp),%eax
80101b14:	8b 40 08             	mov    0x8(%eax),%eax
80101b17:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1d:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b20:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101b27:	e8 10 32 00 00       	call   80104d3c <release>
}
80101b2c:	c9                   	leave  
80101b2d:	c3                   	ret    

80101b2e <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b2e:	55                   	push   %ebp
80101b2f:	89 e5                	mov    %esp,%ebp
80101b31:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b34:	8b 45 08             	mov    0x8(%ebp),%eax
80101b37:	89 04 24             	mov    %eax,(%esp)
80101b3a:	e8 b9 fe ff ff       	call   801019f8 <iunlock>
  iput(ip);
80101b3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b42:	89 04 24             	mov    %eax,(%esp)
80101b45:	e8 13 ff ff ff       	call   80101a5d <iput>
}
80101b4a:	c9                   	leave  
80101b4b:	c3                   	ret    

80101b4c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b4c:	55                   	push   %ebp
80101b4d:	89 e5                	mov    %esp,%ebp
80101b4f:	53                   	push   %ebx
80101b50:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b53:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b57:	77 3e                	ja     80101b97 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b59:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5f:	83 c2 04             	add    $0x4,%edx
80101b62:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b66:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101b69:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101b6d:	75 20                	jne    80101b8f <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b6f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80101b72:	8b 45 08             	mov    0x8(%ebp),%eax
80101b75:	8b 00                	mov    (%eax),%eax
80101b77:	89 04 24             	mov    %eax,(%esp)
80101b7a:	e8 38 f8 ff ff       	call   801013b7 <balloc>
80101b7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101b82:	8b 45 08             	mov    0x8(%ebp),%eax
80101b85:	8d 4b 04             	lea    0x4(%ebx),%ecx
80101b88:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101b8b:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101b92:	e9 b1 00 00 00       	jmp    80101c48 <bmap+0xfc>
  }
  bn -= NDIRECT;
80101b97:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b9b:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b9f:	0f 87 97 00 00 00    	ja     80101c3c <bmap+0xf0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba8:	8b 40 4c             	mov    0x4c(%eax),%eax
80101bab:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101bae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101bb2:	75 19                	jne    80101bcd <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb7:	8b 00                	mov    (%eax),%eax
80101bb9:	89 04 24             	mov    %eax,(%esp)
80101bbc:	e8 f6 f7 ff ff       	call   801013b7 <balloc>
80101bc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101bc4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101bca:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101bcd:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd0:	8b 00                	mov    (%eax),%eax
80101bd2:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101bd5:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bd9:	89 04 24             	mov    %eax,(%esp)
80101bdc:	e8 c6 e5 ff ff       	call   801001a7 <bread>
80101be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a = (uint*)bp->data;
80101be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101be7:	83 c0 18             	add    $0x18,%eax
80101bea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((addr = a[bn]) == 0){
80101bed:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bf0:	c1 e0 02             	shl    $0x2,%eax
80101bf3:	03 45 f0             	add    -0x10(%ebp),%eax
80101bf6:	8b 00                	mov    (%eax),%eax
80101bf8:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101bfb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101bff:	75 2b                	jne    80101c2c <bmap+0xe0>
      a[bn] = addr = balloc(ip->dev);
80101c01:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c04:	c1 e0 02             	shl    $0x2,%eax
80101c07:	89 c3                	mov    %eax,%ebx
80101c09:	03 5d f0             	add    -0x10(%ebp),%ebx
80101c0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0f:	8b 00                	mov    (%eax),%eax
80101c11:	89 04 24             	mov    %eax,(%esp)
80101c14:	e8 9e f7 ff ff       	call   801013b7 <balloc>
80101c19:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c1f:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c24:	89 04 24             	mov    %eax,(%esp)
80101c27:	e8 b3 16 00 00       	call   801032df <log_write>
    }
    brelse(bp);
80101c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c2f:	89 04 24             	mov    %eax,(%esp)
80101c32:	e8 e1 e5 ff ff       	call   80100218 <brelse>
    return addr;
80101c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c3a:	eb 0c                	jmp    80101c48 <bmap+0xfc>
  }

  panic("bmap: out of range");
80101c3c:	c7 04 24 92 83 10 80 	movl   $0x80108392,(%esp)
80101c43:	e8 f2 e8 ff ff       	call   8010053a <panic>
}
80101c48:	83 c4 24             	add    $0x24,%esp
80101c4b:	5b                   	pop    %ebx
80101c4c:	5d                   	pop    %ebp
80101c4d:	c3                   	ret    

80101c4e <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c4e:	55                   	push   %ebp
80101c4f:	89 e5                	mov    %esp,%ebp
80101c51:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80101c5b:	eb 44                	jmp    80101ca1 <itrunc+0x53>
    if(ip->addrs[i]){
80101c5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101c60:	8b 45 08             	mov    0x8(%ebp),%eax
80101c63:	83 c2 04             	add    $0x4,%edx
80101c66:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c6a:	85 c0                	test   %eax,%eax
80101c6c:	74 2f                	je     80101c9d <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c6e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101c71:	8b 45 08             	mov    0x8(%ebp),%eax
80101c74:	83 c2 04             	add    $0x4,%edx
80101c77:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7e:	8b 00                	mov    (%eax),%eax
80101c80:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c84:	89 04 24             	mov    %eax,(%esp)
80101c87:	e8 86 f8 ff ff       	call   80101512 <bfree>
      ip->addrs[i] = 0;
80101c8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101c8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c92:	83 c2 04             	add    $0x4,%edx
80101c95:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c9c:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c9d:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
80101ca1:	83 7d e8 0b          	cmpl   $0xb,-0x18(%ebp)
80101ca5:	7e b6                	jle    80101c5d <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80101caa:	8b 40 4c             	mov    0x4c(%eax),%eax
80101cad:	85 c0                	test   %eax,%eax
80101caf:	0f 84 8f 00 00 00    	je     80101d44 <itrunc+0xf6>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb8:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbe:	8b 00                	mov    (%eax),%eax
80101cc0:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cc4:	89 04 24             	mov    %eax,(%esp)
80101cc7:	e8 db e4 ff ff       	call   801001a7 <bread>
80101ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cd2:	83 c0 18             	add    $0x18,%eax
80101cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cd8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101cdf:	eb 2f                	jmp    80101d10 <itrunc+0xc2>
      if(a[j])
80101ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ce4:	c1 e0 02             	shl    $0x2,%eax
80101ce7:	03 45 f4             	add    -0xc(%ebp),%eax
80101cea:	8b 00                	mov    (%eax),%eax
80101cec:	85 c0                	test   %eax,%eax
80101cee:	74 1c                	je     80101d0c <itrunc+0xbe>
        bfree(ip->dev, a[j]);
80101cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cf3:	c1 e0 02             	shl    $0x2,%eax
80101cf6:	03 45 f4             	add    -0xc(%ebp),%eax
80101cf9:	8b 10                	mov    (%eax),%edx
80101cfb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfe:	8b 00                	mov    (%eax),%eax
80101d00:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d04:	89 04 24             	mov    %eax,(%esp)
80101d07:	e8 06 f8 ff ff       	call   80101512 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d0c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80101d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d13:	83 f8 7f             	cmp    $0x7f,%eax
80101d16:	76 c9                	jbe    80101ce1 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d1b:	89 04 24             	mov    %eax,(%esp)
80101d1e:	e8 f5 e4 ff ff       	call   80100218 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d23:	8b 45 08             	mov    0x8(%ebp),%eax
80101d26:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	8b 00                	mov    (%eax),%eax
80101d2e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d32:	89 04 24             	mov    %eax,(%esp)
80101d35:	e8 d8 f7 ff ff       	call   80101512 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3d:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d44:	8b 45 08             	mov    0x8(%ebp),%eax
80101d47:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d51:	89 04 24             	mov    %eax,(%esp)
80101d54:	e8 8e f9 ff ff       	call   801016e7 <iupdate>
}
80101d59:	c9                   	leave  
80101d5a:	c3                   	ret    

80101d5b <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d5b:	55                   	push   %ebp
80101d5c:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d61:	8b 00                	mov    (%eax),%eax
80101d63:	89 c2                	mov    %eax,%edx
80101d65:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d68:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6e:	8b 50 04             	mov    0x4(%eax),%edx
80101d71:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d74:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d77:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7a:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d81:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d84:	8b 45 08             	mov    0x8(%ebp),%eax
80101d87:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d8e:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d92:	8b 45 08             	mov    0x8(%ebp),%eax
80101d95:	8b 50 18             	mov    0x18(%eax),%edx
80101d98:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d9b:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d9e:	5d                   	pop    %ebp
80101d9f:	c3                   	ret    

80101da0 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	53                   	push   %ebx
80101da4:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101da7:	8b 45 08             	mov    0x8(%ebp),%eax
80101daa:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101dae:	66 83 f8 03          	cmp    $0x3,%ax
80101db2:	75 60                	jne    80101e14 <readi+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101db4:	8b 45 08             	mov    0x8(%ebp),%eax
80101db7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dbb:	66 85 c0             	test   %ax,%ax
80101dbe:	78 20                	js     80101de0 <readi+0x40>
80101dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dc7:	66 83 f8 09          	cmp    $0x9,%ax
80101dcb:	7f 13                	jg     80101de0 <readi+0x40>
80101dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dd4:	98                   	cwtl   
80101dd5:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101ddc:	85 c0                	test   %eax,%eax
80101dde:	75 0a                	jne    80101dea <readi+0x4a>
      return -1;
80101de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101de5:	e9 1c 01 00 00       	jmp    80101f06 <readi+0x166>
    return devsw[ip->major].read(ip, dst, n);
80101dea:	8b 45 08             	mov    0x8(%ebp),%eax
80101ded:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101df1:	98                   	cwtl   
80101df2:	8b 14 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%edx
80101df9:	8b 45 14             	mov    0x14(%ebp),%eax
80101dfc:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e00:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e03:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e07:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0a:	89 04 24             	mov    %eax,(%esp)
80101e0d:	ff d2                	call   *%edx
80101e0f:	e9 f2 00 00 00       	jmp    80101f06 <readi+0x166>
  }

  if(off > ip->size || off + n < off)
80101e14:	8b 45 08             	mov    0x8(%ebp),%eax
80101e17:	8b 40 18             	mov    0x18(%eax),%eax
80101e1a:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e1d:	72 0e                	jb     80101e2d <readi+0x8d>
80101e1f:	8b 45 14             	mov    0x14(%ebp),%eax
80101e22:	8b 55 10             	mov    0x10(%ebp),%edx
80101e25:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101e28:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e2b:	73 0a                	jae    80101e37 <readi+0x97>
    return -1;
80101e2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e32:	e9 cf 00 00 00       	jmp    80101f06 <readi+0x166>
  if(off + n > ip->size)
80101e37:	8b 45 14             	mov    0x14(%ebp),%eax
80101e3a:	8b 55 10             	mov    0x10(%ebp),%edx
80101e3d:	01 c2                	add    %eax,%edx
80101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e42:	8b 40 18             	mov    0x18(%eax),%eax
80101e45:	39 c2                	cmp    %eax,%edx
80101e47:	76 0c                	jbe    80101e55 <readi+0xb5>
    n = ip->size - off;
80101e49:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4c:	8b 40 18             	mov    0x18(%eax),%eax
80101e4f:	2b 45 10             	sub    0x10(%ebp),%eax
80101e52:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e55:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101e5c:	e9 96 00 00 00       	jmp    80101ef7 <readi+0x157>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e61:	8b 45 10             	mov    0x10(%ebp),%eax
80101e64:	c1 e8 09             	shr    $0x9,%eax
80101e67:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6e:	89 04 24             	mov    %eax,(%esp)
80101e71:	e8 d6 fc ff ff       	call   80101b4c <bmap>
80101e76:	8b 55 08             	mov    0x8(%ebp),%edx
80101e79:	8b 12                	mov    (%edx),%edx
80101e7b:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e7f:	89 14 24             	mov    %edx,(%esp)
80101e82:	e8 20 e3 ff ff       	call   801001a7 <bread>
80101e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e8a:	8b 45 10             	mov    0x10(%ebp),%eax
80101e8d:	89 c2                	mov    %eax,%edx
80101e8f:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101e95:	b8 00 02 00 00       	mov    $0x200,%eax
80101e9a:	89 c1                	mov    %eax,%ecx
80101e9c:	29 d1                	sub    %edx,%ecx
80101e9e:	89 ca                	mov    %ecx,%edx
80101ea0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ea3:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101ea6:	89 cb                	mov    %ecx,%ebx
80101ea8:	29 c3                	sub    %eax,%ebx
80101eaa:	89 d8                	mov    %ebx,%eax
80101eac:	39 c2                	cmp    %eax,%edx
80101eae:	0f 46 c2             	cmovbe %edx,%eax
80101eb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eb7:	8d 50 18             	lea    0x18(%eax),%edx
80101eba:	8b 45 10             	mov    0x10(%ebp),%eax
80101ebd:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ec2:	01 c2                	add    %eax,%edx
80101ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ec7:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ecb:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed2:	89 04 24             	mov    %eax,(%esp)
80101ed5:	e8 23 31 00 00       	call   80104ffd <memmove>
    brelse(bp);
80101eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101edd:	89 04 24             	mov    %eax,(%esp)
80101ee0:	e8 33 e3 ff ff       	call   80100218 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ee8:	01 45 ec             	add    %eax,-0x14(%ebp)
80101eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eee:	01 45 10             	add    %eax,0x10(%ebp)
80101ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ef4:	01 45 0c             	add    %eax,0xc(%ebp)
80101ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101efa:	3b 45 14             	cmp    0x14(%ebp),%eax
80101efd:	0f 82 5e ff ff ff    	jb     80101e61 <readi+0xc1>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f03:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f06:	83 c4 24             	add    $0x24,%esp
80101f09:	5b                   	pop    %ebx
80101f0a:	5d                   	pop    %ebp
80101f0b:	c3                   	ret    

80101f0c <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f0c:	55                   	push   %ebp
80101f0d:	89 e5                	mov    %esp,%ebp
80101f0f:	53                   	push   %ebx
80101f10:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f13:	8b 45 08             	mov    0x8(%ebp),%eax
80101f16:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f1a:	66 83 f8 03          	cmp    $0x3,%ax
80101f1e:	75 60                	jne    80101f80 <writei+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f20:	8b 45 08             	mov    0x8(%ebp),%eax
80101f23:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f27:	66 85 c0             	test   %ax,%ax
80101f2a:	78 20                	js     80101f4c <writei+0x40>
80101f2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f33:	66 83 f8 09          	cmp    $0x9,%ax
80101f37:	7f 13                	jg     80101f4c <writei+0x40>
80101f39:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f40:	98                   	cwtl   
80101f41:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101f48:	85 c0                	test   %eax,%eax
80101f4a:	75 0a                	jne    80101f56 <writei+0x4a>
      return -1;
80101f4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f51:	e9 48 01 00 00       	jmp    8010209e <writei+0x192>
    return devsw[ip->major].write(ip, src, n);
80101f56:	8b 45 08             	mov    0x8(%ebp),%eax
80101f59:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f5d:	98                   	cwtl   
80101f5e:	8b 14 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%edx
80101f65:	8b 45 14             	mov    0x14(%ebp),%eax
80101f68:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f73:	8b 45 08             	mov    0x8(%ebp),%eax
80101f76:	89 04 24             	mov    %eax,(%esp)
80101f79:	ff d2                	call   *%edx
80101f7b:	e9 1e 01 00 00       	jmp    8010209e <writei+0x192>
  }

  if(off > ip->size || off + n < off)
80101f80:	8b 45 08             	mov    0x8(%ebp),%eax
80101f83:	8b 40 18             	mov    0x18(%eax),%eax
80101f86:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f89:	72 0e                	jb     80101f99 <writei+0x8d>
80101f8b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f8e:	8b 55 10             	mov    0x10(%ebp),%edx
80101f91:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101f94:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f97:	73 0a                	jae    80101fa3 <writei+0x97>
    return -1;
80101f99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f9e:	e9 fb 00 00 00       	jmp    8010209e <writei+0x192>
  if(off + n > MAXFILE*BSIZE)
80101fa3:	8b 45 14             	mov    0x14(%ebp),%eax
80101fa6:	8b 55 10             	mov    0x10(%ebp),%edx
80101fa9:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101fac:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101fb1:	76 0a                	jbe    80101fbd <writei+0xb1>
    return -1;
80101fb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fb8:	e9 e1 00 00 00       	jmp    8010209e <writei+0x192>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fbd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101fc4:	e9 a1 00 00 00       	jmp    8010206a <writei+0x15e>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fc9:	8b 45 10             	mov    0x10(%ebp),%eax
80101fcc:	c1 e8 09             	shr    $0x9,%eax
80101fcf:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd6:	89 04 24             	mov    %eax,(%esp)
80101fd9:	e8 6e fb ff ff       	call   80101b4c <bmap>
80101fde:	8b 55 08             	mov    0x8(%ebp),%edx
80101fe1:	8b 12                	mov    (%edx),%edx
80101fe3:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fe7:	89 14 24             	mov    %edx,(%esp)
80101fea:	e8 b8 e1 ff ff       	call   801001a7 <bread>
80101fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ff2:	8b 45 10             	mov    0x10(%ebp),%eax
80101ff5:	89 c2                	mov    %eax,%edx
80101ff7:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101ffd:	b8 00 02 00 00       	mov    $0x200,%eax
80102002:	89 c1                	mov    %eax,%ecx
80102004:	29 d1                	sub    %edx,%ecx
80102006:	89 ca                	mov    %ecx,%edx
80102008:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010200b:	8b 4d 14             	mov    0x14(%ebp),%ecx
8010200e:	89 cb                	mov    %ecx,%ebx
80102010:	29 c3                	sub    %eax,%ebx
80102012:	89 d8                	mov    %ebx,%eax
80102014:	39 c2                	cmp    %eax,%edx
80102016:	0f 46 c2             	cmovbe %edx,%eax
80102019:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010201f:	8d 50 18             	lea    0x18(%eax),%edx
80102022:	8b 45 10             	mov    0x10(%ebp),%eax
80102025:	25 ff 01 00 00       	and    $0x1ff,%eax
8010202a:	01 c2                	add    %eax,%edx
8010202c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010202f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102033:	8b 45 0c             	mov    0xc(%ebp),%eax
80102036:	89 44 24 04          	mov    %eax,0x4(%esp)
8010203a:	89 14 24             	mov    %edx,(%esp)
8010203d:	e8 bb 2f 00 00       	call   80104ffd <memmove>
    log_write(bp);
80102042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102045:	89 04 24             	mov    %eax,(%esp)
80102048:	e8 92 12 00 00       	call   801032df <log_write>
    brelse(bp);
8010204d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102050:	89 04 24             	mov    %eax,(%esp)
80102053:	e8 c0 e1 ff ff       	call   80100218 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102058:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010205b:	01 45 ec             	add    %eax,-0x14(%ebp)
8010205e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102061:	01 45 10             	add    %eax,0x10(%ebp)
80102064:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102067:	01 45 0c             	add    %eax,0xc(%ebp)
8010206a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010206d:	3b 45 14             	cmp    0x14(%ebp),%eax
80102070:	0f 82 53 ff ff ff    	jb     80101fc9 <writei+0xbd>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102076:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010207a:	74 1f                	je     8010209b <writei+0x18f>
8010207c:	8b 45 08             	mov    0x8(%ebp),%eax
8010207f:	8b 40 18             	mov    0x18(%eax),%eax
80102082:	3b 45 10             	cmp    0x10(%ebp),%eax
80102085:	73 14                	jae    8010209b <writei+0x18f>
    ip->size = off;
80102087:	8b 45 08             	mov    0x8(%ebp),%eax
8010208a:	8b 55 10             	mov    0x10(%ebp),%edx
8010208d:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102090:	8b 45 08             	mov    0x8(%ebp),%eax
80102093:	89 04 24             	mov    %eax,(%esp)
80102096:	e8 4c f6 ff ff       	call   801016e7 <iupdate>
  }
  return n;
8010209b:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010209e:	83 c4 24             	add    $0x24,%esp
801020a1:	5b                   	pop    %ebx
801020a2:	5d                   	pop    %ebp
801020a3:	c3                   	ret    

801020a4 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020a4:	55                   	push   %ebp
801020a5:	89 e5                	mov    %esp,%ebp
801020a7:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801020aa:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020b1:	00 
801020b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801020b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801020b9:	8b 45 08             	mov    0x8(%ebp),%eax
801020bc:	89 04 24             	mov    %eax,(%esp)
801020bf:	e8 e1 2f 00 00       	call   801050a5 <strncmp>
}
801020c4:	c9                   	leave  
801020c5:	c3                   	ret    

801020c6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801020c6:	55                   	push   %ebp
801020c7:	89 e5                	mov    %esp,%ebp
801020c9:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020cc:	8b 45 08             	mov    0x8(%ebp),%eax
801020cf:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020d3:	66 83 f8 01          	cmp    $0x1,%ax
801020d7:	74 0c                	je     801020e5 <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020d9:	c7 04 24 a5 83 10 80 	movl   $0x801083a5,(%esp)
801020e0:	e8 55 e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801020ec:	e9 87 00 00 00       	jmp    80102178 <dirlookup+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020f4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020fb:	00 
801020fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801020ff:	89 54 24 08          	mov    %edx,0x8(%esp)
80102103:	89 44 24 04          	mov    %eax,0x4(%esp)
80102107:	8b 45 08             	mov    0x8(%ebp),%eax
8010210a:	89 04 24             	mov    %eax,(%esp)
8010210d:	e8 8e fc ff ff       	call   80101da0 <readi>
80102112:	83 f8 10             	cmp    $0x10,%eax
80102115:	74 0c                	je     80102123 <dirlookup+0x5d>
      panic("dirlink read");
80102117:	c7 04 24 b7 83 10 80 	movl   $0x801083b7,(%esp)
8010211e:	e8 17 e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
80102123:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102127:	66 85 c0             	test   %ax,%ax
8010212a:	74 47                	je     80102173 <dirlookup+0xad>
      continue;
    if(namecmp(name, de.name) == 0){
8010212c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010212f:	83 c0 02             	add    $0x2,%eax
80102132:	89 44 24 04          	mov    %eax,0x4(%esp)
80102136:	8b 45 0c             	mov    0xc(%ebp),%eax
80102139:	89 04 24             	mov    %eax,(%esp)
8010213c:	e8 63 ff ff ff       	call   801020a4 <namecmp>
80102141:	85 c0                	test   %eax,%eax
80102143:	75 2f                	jne    80102174 <dirlookup+0xae>
      // entry matches path element
      if(poff)
80102145:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102149:	74 08                	je     80102153 <dirlookup+0x8d>
        *poff = off;
8010214b:	8b 45 10             	mov    0x10(%ebp),%eax
8010214e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102151:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102153:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102157:	0f b7 c0             	movzwl %ax,%eax
8010215a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return iget(dp->dev, inum);
8010215d:	8b 45 08             	mov    0x8(%ebp),%eax
80102160:	8b 00                	mov    (%eax),%eax
80102162:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102165:	89 54 24 04          	mov    %edx,0x4(%esp)
80102169:	89 04 24             	mov    %eax,(%esp)
8010216c:	e8 31 f6 ff ff       	call   801017a2 <iget>
80102171:	eb 19                	jmp    8010218c <dirlookup+0xc6>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102173:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102174:	83 45 f0 10          	addl   $0x10,-0x10(%ebp)
80102178:	8b 45 08             	mov    0x8(%ebp),%eax
8010217b:	8b 40 18             	mov    0x18(%eax),%eax
8010217e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102181:	0f 87 6a ff ff ff    	ja     801020f1 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102187:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010218c:	c9                   	leave  
8010218d:	c3                   	ret    

8010218e <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010218e:	55                   	push   %ebp
8010218f:	89 e5                	mov    %esp,%ebp
80102191:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102194:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010219b:	00 
8010219c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010219f:	89 44 24 04          	mov    %eax,0x4(%esp)
801021a3:	8b 45 08             	mov    0x8(%ebp),%eax
801021a6:	89 04 24             	mov    %eax,(%esp)
801021a9:	e8 18 ff ff ff       	call   801020c6 <dirlookup>
801021ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801021b5:	74 15                	je     801021cc <dirlink+0x3e>
    iput(ip);
801021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ba:	89 04 24             	mov    %eax,(%esp)
801021bd:	e8 9b f8 ff ff       	call   80101a5d <iput>
    return -1;
801021c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021c7:	e9 b8 00 00 00       	jmp    80102284 <dirlink+0xf6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801021d3:	eb 44                	jmp    80102219 <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801021d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021db:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021e2:	00 
801021e3:	89 54 24 08          	mov    %edx,0x8(%esp)
801021e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801021eb:	8b 45 08             	mov    0x8(%ebp),%eax
801021ee:	89 04 24             	mov    %eax,(%esp)
801021f1:	e8 aa fb ff ff       	call   80101da0 <readi>
801021f6:	83 f8 10             	cmp    $0x10,%eax
801021f9:	74 0c                	je     80102207 <dirlink+0x79>
      panic("dirlink read");
801021fb:	c7 04 24 b7 83 10 80 	movl   $0x801083b7,(%esp)
80102202:	e8 33 e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
80102207:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010220b:	66 85 c0             	test   %ax,%ax
8010220e:	74 18                	je     80102228 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102210:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102213:	83 c0 10             	add    $0x10,%eax
80102216:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102219:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010221c:	8b 45 08             	mov    0x8(%ebp),%eax
8010221f:	8b 40 18             	mov    0x18(%eax),%eax
80102222:	39 c2                	cmp    %eax,%edx
80102224:	72 af                	jb     801021d5 <dirlink+0x47>
80102226:	eb 01                	jmp    80102229 <dirlink+0x9b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102228:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102229:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102230:	00 
80102231:	8b 45 0c             	mov    0xc(%ebp),%eax
80102234:	89 44 24 04          	mov    %eax,0x4(%esp)
80102238:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010223b:	83 c0 02             	add    $0x2,%eax
8010223e:	89 04 24             	mov    %eax,(%esp)
80102241:	e8 b7 2e 00 00       	call   801050fd <strncpy>
  de.inum = inum;
80102246:	8b 45 10             	mov    0x10(%ebp),%eax
80102249:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010224d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102250:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102253:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010225a:	00 
8010225b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010225f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102263:	8b 45 08             	mov    0x8(%ebp),%eax
80102266:	89 04 24             	mov    %eax,(%esp)
80102269:	e8 9e fc ff ff       	call   80101f0c <writei>
8010226e:	83 f8 10             	cmp    $0x10,%eax
80102271:	74 0c                	je     8010227f <dirlink+0xf1>
    panic("dirlink");
80102273:	c7 04 24 c4 83 10 80 	movl   $0x801083c4,(%esp)
8010227a:	e8 bb e2 ff ff       	call   8010053a <panic>
  
  return 0;
8010227f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102284:	c9                   	leave  
80102285:	c3                   	ret    

80102286 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102286:	55                   	push   %ebp
80102287:	89 e5                	mov    %esp,%ebp
80102289:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
8010228c:	eb 04                	jmp    80102292 <skipelem+0xc>
    path++;
8010228e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102292:	8b 45 08             	mov    0x8(%ebp),%eax
80102295:	0f b6 00             	movzbl (%eax),%eax
80102298:	3c 2f                	cmp    $0x2f,%al
8010229a:	74 f2                	je     8010228e <skipelem+0x8>
    path++;
  if(*path == 0)
8010229c:	8b 45 08             	mov    0x8(%ebp),%eax
8010229f:	0f b6 00             	movzbl (%eax),%eax
801022a2:	84 c0                	test   %al,%al
801022a4:	75 0a                	jne    801022b0 <skipelem+0x2a>
    return 0;
801022a6:	b8 00 00 00 00       	mov    $0x0,%eax
801022ab:	e9 86 00 00 00       	jmp    80102336 <skipelem+0xb0>
  s = path;
801022b0:	8b 45 08             	mov    0x8(%ebp),%eax
801022b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(*path != '/' && *path != 0)
801022b6:	eb 04                	jmp    801022bc <skipelem+0x36>
    path++;
801022b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022bc:	8b 45 08             	mov    0x8(%ebp),%eax
801022bf:	0f b6 00             	movzbl (%eax),%eax
801022c2:	3c 2f                	cmp    $0x2f,%al
801022c4:	74 0a                	je     801022d0 <skipelem+0x4a>
801022c6:	8b 45 08             	mov    0x8(%ebp),%eax
801022c9:	0f b6 00             	movzbl (%eax),%eax
801022cc:	84 c0                	test   %al,%al
801022ce:	75 e8                	jne    801022b8 <skipelem+0x32>
    path++;
  len = path - s;
801022d0:	8b 55 08             	mov    0x8(%ebp),%edx
801022d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022d6:	89 d1                	mov    %edx,%ecx
801022d8:	29 c1                	sub    %eax,%ecx
801022da:	89 c8                	mov    %ecx,%eax
801022dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(len >= DIRSIZ)
801022df:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801022e3:	7e 1c                	jle    80102301 <skipelem+0x7b>
    memmove(name, s, DIRSIZ);
801022e5:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022ec:	00 
801022ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801022f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801022f7:	89 04 24             	mov    %eax,(%esp)
801022fa:	e8 fe 2c 00 00       	call   80104ffd <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022ff:	eb 28                	jmp    80102329 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102304:	89 44 24 08          	mov    %eax,0x8(%esp)
80102308:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010230b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010230f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102312:	89 04 24             	mov    %eax,(%esp)
80102315:	e8 e3 2c 00 00       	call   80104ffd <memmove>
    name[len] = 0;
8010231a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010231d:	03 45 0c             	add    0xc(%ebp),%eax
80102320:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102323:	eb 04                	jmp    80102329 <skipelem+0xa3>
    path++;
80102325:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102329:	8b 45 08             	mov    0x8(%ebp),%eax
8010232c:	0f b6 00             	movzbl (%eax),%eax
8010232f:	3c 2f                	cmp    $0x2f,%al
80102331:	74 f2                	je     80102325 <skipelem+0x9f>
    path++;
  return path;
80102333:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102336:	c9                   	leave  
80102337:	c3                   	ret    

80102338 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102338:	55                   	push   %ebp
80102339:	89 e5                	mov    %esp,%ebp
8010233b:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010233e:	8b 45 08             	mov    0x8(%ebp),%eax
80102341:	0f b6 00             	movzbl (%eax),%eax
80102344:	3c 2f                	cmp    $0x2f,%al
80102346:	75 1c                	jne    80102364 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102348:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010234f:	00 
80102350:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102357:	e8 46 f4 ff ff       	call   801017a2 <iget>
8010235c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010235f:	e9 af 00 00 00       	jmp    80102413 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80102364:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010236a:	8b 40 68             	mov    0x68(%eax),%eax
8010236d:	89 04 24             	mov    %eax,(%esp)
80102370:	e8 00 f5 ff ff       	call   80101875 <idup>
80102375:	89 45 f0             	mov    %eax,-0x10(%ebp)

  while((path = skipelem(path, name)) != 0){
80102378:	e9 96 00 00 00       	jmp    80102413 <namex+0xdb>
    ilock(ip);
8010237d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102380:	89 04 24             	mov    %eax,(%esp)
80102383:	e8 1f f5 ff ff       	call   801018a7 <ilock>
    if(ip->type != T_DIR){
80102388:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010238b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010238f:	66 83 f8 01          	cmp    $0x1,%ax
80102393:	74 15                	je     801023aa <namex+0x72>
      iunlockput(ip);
80102395:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102398:	89 04 24             	mov    %eax,(%esp)
8010239b:	e8 8e f7 ff ff       	call   80101b2e <iunlockput>
      return 0;
801023a0:	b8 00 00 00 00       	mov    $0x0,%eax
801023a5:	e9 a3 00 00 00       	jmp    8010244d <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
801023aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023ae:	74 1d                	je     801023cd <namex+0x95>
801023b0:	8b 45 08             	mov    0x8(%ebp),%eax
801023b3:	0f b6 00             	movzbl (%eax),%eax
801023b6:	84 c0                	test   %al,%al
801023b8:	75 13                	jne    801023cd <namex+0x95>
      // Stop one level early.
      iunlock(ip);
801023ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023bd:	89 04 24             	mov    %eax,(%esp)
801023c0:	e8 33 f6 ff ff       	call   801019f8 <iunlock>
      return ip;
801023c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023c8:	e9 80 00 00 00       	jmp    8010244d <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023cd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023d4:	00 
801023d5:	8b 45 10             	mov    0x10(%ebp),%eax
801023d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801023dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023df:	89 04 24             	mov    %eax,(%esp)
801023e2:	e8 df fc ff ff       	call   801020c6 <dirlookup>
801023e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801023ee:	75 12                	jne    80102402 <namex+0xca>
      iunlockput(ip);
801023f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023f3:	89 04 24             	mov    %eax,(%esp)
801023f6:	e8 33 f7 ff ff       	call   80101b2e <iunlockput>
      return 0;
801023fb:	b8 00 00 00 00       	mov    $0x0,%eax
80102400:	eb 4b                	jmp    8010244d <namex+0x115>
    }
    iunlockput(ip);
80102402:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102405:	89 04 24             	mov    %eax,(%esp)
80102408:	e8 21 f7 ff ff       	call   80101b2e <iunlockput>
    ip = next;
8010240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102410:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102413:	8b 45 10             	mov    0x10(%ebp),%eax
80102416:	89 44 24 04          	mov    %eax,0x4(%esp)
8010241a:	8b 45 08             	mov    0x8(%ebp),%eax
8010241d:	89 04 24             	mov    %eax,(%esp)
80102420:	e8 61 fe ff ff       	call   80102286 <skipelem>
80102425:	89 45 08             	mov    %eax,0x8(%ebp)
80102428:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010242c:	0f 85 4b ff ff ff    	jne    8010237d <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102432:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102436:	74 12                	je     8010244a <namex+0x112>
    iput(ip);
80102438:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010243b:	89 04 24             	mov    %eax,(%esp)
8010243e:	e8 1a f6 ff ff       	call   80101a5d <iput>
    return 0;
80102443:	b8 00 00 00 00       	mov    $0x0,%eax
80102448:	eb 03                	jmp    8010244d <namex+0x115>
  }
  return ip;
8010244a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010244d:	c9                   	leave  
8010244e:	c3                   	ret    

8010244f <namei>:

struct inode*
namei(char *path)
{
8010244f:	55                   	push   %ebp
80102450:	89 e5                	mov    %esp,%ebp
80102452:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102455:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102458:	89 44 24 08          	mov    %eax,0x8(%esp)
8010245c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102463:	00 
80102464:	8b 45 08             	mov    0x8(%ebp),%eax
80102467:	89 04 24             	mov    %eax,(%esp)
8010246a:	e8 c9 fe ff ff       	call   80102338 <namex>
}
8010246f:	c9                   	leave  
80102470:	c3                   	ret    

80102471 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102471:	55                   	push   %ebp
80102472:	89 e5                	mov    %esp,%ebp
80102474:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102477:	8b 45 0c             	mov    0xc(%ebp),%eax
8010247a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010247e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102485:	00 
80102486:	8b 45 08             	mov    0x8(%ebp),%eax
80102489:	89 04 24             	mov    %eax,(%esp)
8010248c:	e8 a7 fe ff ff       	call   80102338 <namex>
}
80102491:	c9                   	leave  
80102492:	c3                   	ret    
	...

80102494 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102494:	55                   	push   %ebp
80102495:	89 e5                	mov    %esp,%ebp
80102497:	83 ec 14             	sub    $0x14,%esp
8010249a:	8b 45 08             	mov    0x8(%ebp),%eax
8010249d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024a1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801024a5:	89 c2                	mov    %eax,%edx
801024a7:	ec                   	in     (%dx),%al
801024a8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801024ab:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801024af:	c9                   	leave  
801024b0:	c3                   	ret    

801024b1 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024b1:	55                   	push   %ebp
801024b2:	89 e5                	mov    %esp,%ebp
801024b4:	57                   	push   %edi
801024b5:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024b6:	8b 55 08             	mov    0x8(%ebp),%edx
801024b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024bc:	8b 45 10             	mov    0x10(%ebp),%eax
801024bf:	89 cb                	mov    %ecx,%ebx
801024c1:	89 df                	mov    %ebx,%edi
801024c3:	89 c1                	mov    %eax,%ecx
801024c5:	fc                   	cld    
801024c6:	f3 6d                	rep insl (%dx),%es:(%edi)
801024c8:	89 c8                	mov    %ecx,%eax
801024ca:	89 fb                	mov    %edi,%ebx
801024cc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024cf:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024d2:	5b                   	pop    %ebx
801024d3:	5f                   	pop    %edi
801024d4:	5d                   	pop    %ebp
801024d5:	c3                   	ret    

801024d6 <outb>:

static inline void
outb(ushort port, uchar data)
{
801024d6:	55                   	push   %ebp
801024d7:	89 e5                	mov    %esp,%ebp
801024d9:	83 ec 08             	sub    $0x8,%esp
801024dc:	8b 55 08             	mov    0x8(%ebp),%edx
801024df:	8b 45 0c             	mov    0xc(%ebp),%eax
801024e2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024e6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024e9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024ed:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024f1:	ee                   	out    %al,(%dx)
}
801024f2:	c9                   	leave  
801024f3:	c3                   	ret    

801024f4 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024f4:	55                   	push   %ebp
801024f5:	89 e5                	mov    %esp,%ebp
801024f7:	56                   	push   %esi
801024f8:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024f9:	8b 55 08             	mov    0x8(%ebp),%edx
801024fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024ff:	8b 45 10             	mov    0x10(%ebp),%eax
80102502:	89 cb                	mov    %ecx,%ebx
80102504:	89 de                	mov    %ebx,%esi
80102506:	89 c1                	mov    %eax,%ecx
80102508:	fc                   	cld    
80102509:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010250b:	89 c8                	mov    %ecx,%eax
8010250d:	89 f3                	mov    %esi,%ebx
8010250f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102512:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102515:	5b                   	pop    %ebx
80102516:	5e                   	pop    %esi
80102517:	5d                   	pop    %ebp
80102518:	c3                   	ret    

80102519 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102519:	55                   	push   %ebp
8010251a:	89 e5                	mov    %esp,%ebp
8010251c:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010251f:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102526:	e8 69 ff ff ff       	call   80102494 <inb>
8010252b:	0f b6 c0             	movzbl %al,%eax
8010252e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102531:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102534:	25 c0 00 00 00       	and    $0xc0,%eax
80102539:	83 f8 40             	cmp    $0x40,%eax
8010253c:	75 e1                	jne    8010251f <idewait+0x6>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010253e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102542:	74 11                	je     80102555 <idewait+0x3c>
80102544:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102547:	83 e0 21             	and    $0x21,%eax
8010254a:	85 c0                	test   %eax,%eax
8010254c:	74 07                	je     80102555 <idewait+0x3c>
    return -1;
8010254e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102553:	eb 05                	jmp    8010255a <idewait+0x41>
  return 0;
80102555:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010255a:	c9                   	leave  
8010255b:	c3                   	ret    

8010255c <ideinit>:

void
ideinit(void)
{
8010255c:	55                   	push   %ebp
8010255d:	89 e5                	mov    %esp,%ebp
8010255f:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102562:	c7 44 24 04 cc 83 10 	movl   $0x801083cc,0x4(%esp)
80102569:	80 
8010256a:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102571:	e8 44 27 00 00       	call   80104cba <initlock>
  picenable(IRQ_IDE);
80102576:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010257d:	e8 3b 15 00 00       	call   80103abd <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102582:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80102587:	83 e8 01             	sub    $0x1,%eax
8010258a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010258e:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102595:	e8 10 04 00 00       	call   801029aa <ioapicenable>
  idewait(0);
8010259a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025a1:	e8 73 ff ff ff       	call   80102519 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025a6:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025ad:	00 
801025ae:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025b5:	e8 1c ff ff ff       	call   801024d6 <outb>
  for(i=0; i<1000; i++){
801025ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025c1:	eb 20                	jmp    801025e3 <ideinit+0x87>
    if(inb(0x1f7) != 0){
801025c3:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025ca:	e8 c5 fe ff ff       	call   80102494 <inb>
801025cf:	84 c0                	test   %al,%al
801025d1:	74 0c                	je     801025df <ideinit+0x83>
      havedisk1 = 1;
801025d3:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
801025da:	00 00 00 
      break;
801025dd:	eb 0d                	jmp    801025ec <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025df:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025e3:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025ea:	7e d7                	jle    801025c3 <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025ec:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025f3:	00 
801025f4:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025fb:	e8 d6 fe ff ff       	call   801024d6 <outb>
}
80102600:	c9                   	leave  
80102601:	c3                   	ret    

80102602 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102602:	55                   	push   %ebp
80102603:	89 e5                	mov    %esp,%ebp
80102605:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102608:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010260c:	75 0c                	jne    8010261a <idestart+0x18>
    panic("idestart");
8010260e:	c7 04 24 d0 83 10 80 	movl   $0x801083d0,(%esp)
80102615:	e8 20 df ff ff       	call   8010053a <panic>

  idewait(0);
8010261a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102621:	e8 f3 fe ff ff       	call   80102519 <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102626:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010262d:	00 
8010262e:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102635:	e8 9c fe ff ff       	call   801024d6 <outb>
  outb(0x1f2, 1);  // number of sectors
8010263a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102641:	00 
80102642:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102649:	e8 88 fe ff ff       	call   801024d6 <outb>
  outb(0x1f3, b->sector & 0xff);
8010264e:	8b 45 08             	mov    0x8(%ebp),%eax
80102651:	8b 40 08             	mov    0x8(%eax),%eax
80102654:	0f b6 c0             	movzbl %al,%eax
80102657:	89 44 24 04          	mov    %eax,0x4(%esp)
8010265b:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102662:	e8 6f fe ff ff       	call   801024d6 <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102667:	8b 45 08             	mov    0x8(%ebp),%eax
8010266a:	8b 40 08             	mov    0x8(%eax),%eax
8010266d:	c1 e8 08             	shr    $0x8,%eax
80102670:	0f b6 c0             	movzbl %al,%eax
80102673:	89 44 24 04          	mov    %eax,0x4(%esp)
80102677:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
8010267e:	e8 53 fe ff ff       	call   801024d6 <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
80102683:	8b 45 08             	mov    0x8(%ebp),%eax
80102686:	8b 40 08             	mov    0x8(%eax),%eax
80102689:	c1 e8 10             	shr    $0x10,%eax
8010268c:	0f b6 c0             	movzbl %al,%eax
8010268f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102693:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
8010269a:	e8 37 fe ff ff       	call   801024d6 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
8010269f:	8b 45 08             	mov    0x8(%ebp),%eax
801026a2:	8b 40 04             	mov    0x4(%eax),%eax
801026a5:	83 e0 01             	and    $0x1,%eax
801026a8:	89 c2                	mov    %eax,%edx
801026aa:	c1 e2 04             	shl    $0x4,%edx
801026ad:	8b 45 08             	mov    0x8(%ebp),%eax
801026b0:	8b 40 08             	mov    0x8(%eax),%eax
801026b3:	c1 e8 18             	shr    $0x18,%eax
801026b6:	83 e0 0f             	and    $0xf,%eax
801026b9:	09 d0                	or     %edx,%eax
801026bb:	83 c8 e0             	or     $0xffffffe0,%eax
801026be:	0f b6 c0             	movzbl %al,%eax
801026c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801026c5:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026cc:	e8 05 fe ff ff       	call   801024d6 <outb>
  if(b->flags & B_DIRTY){
801026d1:	8b 45 08             	mov    0x8(%ebp),%eax
801026d4:	8b 00                	mov    (%eax),%eax
801026d6:	83 e0 04             	and    $0x4,%eax
801026d9:	85 c0                	test   %eax,%eax
801026db:	74 34                	je     80102711 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026dd:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026e4:	00 
801026e5:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026ec:	e8 e5 fd ff ff       	call   801024d6 <outb>
    outsl(0x1f0, b->data, 512/4);
801026f1:	8b 45 08             	mov    0x8(%ebp),%eax
801026f4:	83 c0 18             	add    $0x18,%eax
801026f7:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026fe:	00 
801026ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80102703:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010270a:	e8 e5 fd ff ff       	call   801024f4 <outsl>
8010270f:	eb 14                	jmp    80102725 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102711:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80102718:	00 
80102719:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102720:	e8 b1 fd ff ff       	call   801024d6 <outb>
  }
}
80102725:	c9                   	leave  
80102726:	c3                   	ret    

80102727 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102727:	55                   	push   %ebp
80102728:	89 e5                	mov    %esp,%ebp
8010272a:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010272d:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102734:	e8 a2 25 00 00       	call   80104cdb <acquire>
  if((b = idequeue) == 0){
80102739:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010273e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102741:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102745:	75 11                	jne    80102758 <ideintr+0x31>
    release(&idelock);
80102747:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010274e:	e8 e9 25 00 00       	call   80104d3c <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102753:	e9 90 00 00 00       	jmp    801027e8 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102758:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010275b:	8b 40 14             	mov    0x14(%eax),%eax
8010275e:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102766:	8b 00                	mov    (%eax),%eax
80102768:	83 e0 04             	and    $0x4,%eax
8010276b:	85 c0                	test   %eax,%eax
8010276d:	75 2e                	jne    8010279d <ideintr+0x76>
8010276f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102776:	e8 9e fd ff ff       	call   80102519 <idewait>
8010277b:	85 c0                	test   %eax,%eax
8010277d:	78 1e                	js     8010279d <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
8010277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102782:	83 c0 18             	add    $0x18,%eax
80102785:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010278c:	00 
8010278d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102791:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102798:	e8 14 fd ff ff       	call   801024b1 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a0:	8b 00                	mov    (%eax),%eax
801027a2:	89 c2                	mov    %eax,%edx
801027a4:	83 ca 02             	or     $0x2,%edx
801027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027aa:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027af:	8b 00                	mov    (%eax),%eax
801027b1:	89 c2                	mov    %eax,%edx
801027b3:	83 e2 fb             	and    $0xfffffffb,%edx
801027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027b9:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027be:	89 04 24             	mov    %eax,(%esp)
801027c1:	e8 0e 23 00 00       	call   80104ad4 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801027c6:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801027cb:	85 c0                	test   %eax,%eax
801027cd:	74 0d                	je     801027dc <ideintr+0xb5>
    idestart(idequeue);
801027cf:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801027d4:	89 04 24             	mov    %eax,(%esp)
801027d7:	e8 26 fe ff ff       	call   80102602 <idestart>

  release(&idelock);
801027dc:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027e3:	e8 54 25 00 00       	call   80104d3c <release>
}
801027e8:	c9                   	leave  
801027e9:	c3                   	ret    

801027ea <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027ea:	55                   	push   %ebp
801027eb:	89 e5                	mov    %esp,%ebp
801027ed:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027f0:	8b 45 08             	mov    0x8(%ebp),%eax
801027f3:	8b 00                	mov    (%eax),%eax
801027f5:	83 e0 01             	and    $0x1,%eax
801027f8:	85 c0                	test   %eax,%eax
801027fa:	75 0c                	jne    80102808 <iderw+0x1e>
    panic("iderw: buf not busy");
801027fc:	c7 04 24 d9 83 10 80 	movl   $0x801083d9,(%esp)
80102803:	e8 32 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102808:	8b 45 08             	mov    0x8(%ebp),%eax
8010280b:	8b 00                	mov    (%eax),%eax
8010280d:	83 e0 06             	and    $0x6,%eax
80102810:	83 f8 02             	cmp    $0x2,%eax
80102813:	75 0c                	jne    80102821 <iderw+0x37>
    panic("iderw: nothing to do");
80102815:	c7 04 24 ed 83 10 80 	movl   $0x801083ed,(%esp)
8010281c:	e8 19 dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
80102821:	8b 45 08             	mov    0x8(%ebp),%eax
80102824:	8b 40 04             	mov    0x4(%eax),%eax
80102827:	85 c0                	test   %eax,%eax
80102829:	74 15                	je     80102840 <iderw+0x56>
8010282b:	a1 38 b6 10 80       	mov    0x8010b638,%eax
80102830:	85 c0                	test   %eax,%eax
80102832:	75 0c                	jne    80102840 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
80102834:	c7 04 24 02 84 10 80 	movl   $0x80108402,(%esp)
8010283b:	e8 fa dc ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102840:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102847:	e8 8f 24 00 00       	call   80104cdb <acquire>

  // Append b to idequeue.
  b->qnext = 0;
8010284c:	8b 45 08             	mov    0x8(%ebp),%eax
8010284f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102856:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
8010285d:	eb 0b                	jmp    8010286a <iderw+0x80>
8010285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102862:	8b 00                	mov    (%eax),%eax
80102864:	83 c0 14             	add    $0x14,%eax
80102867:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010286d:	8b 00                	mov    (%eax),%eax
8010286f:	85 c0                	test   %eax,%eax
80102871:	75 ec                	jne    8010285f <iderw+0x75>
    ;
  *pp = b;
80102873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102876:	8b 55 08             	mov    0x8(%ebp),%edx
80102879:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
8010287b:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102880:	3b 45 08             	cmp    0x8(%ebp),%eax
80102883:	75 22                	jne    801028a7 <iderw+0xbd>
    idestart(b);
80102885:	8b 45 08             	mov    0x8(%ebp),%eax
80102888:	89 04 24             	mov    %eax,(%esp)
8010288b:	e8 72 fd ff ff       	call   80102602 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102890:	eb 16                	jmp    801028a8 <iderw+0xbe>
    sleep(b, &idelock);
80102892:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
80102899:	80 
8010289a:	8b 45 08             	mov    0x8(%ebp),%eax
8010289d:	89 04 24             	mov    %eax,(%esp)
801028a0:	e8 47 21 00 00       	call   801049ec <sleep>
801028a5:	eb 01                	jmp    801028a8 <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028a7:	90                   	nop
801028a8:	8b 45 08             	mov    0x8(%ebp),%eax
801028ab:	8b 00                	mov    (%eax),%eax
801028ad:	83 e0 06             	and    $0x6,%eax
801028b0:	83 f8 02             	cmp    $0x2,%eax
801028b3:	75 dd                	jne    80102892 <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
801028b5:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801028bc:	e8 7b 24 00 00       	call   80104d3c <release>
}
801028c1:	c9                   	leave  
801028c2:	c3                   	ret    
	...

801028c4 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801028c4:	55                   	push   %ebp
801028c5:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028c7:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028cc:	8b 55 08             	mov    0x8(%ebp),%edx
801028cf:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801028d1:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028d6:	8b 40 10             	mov    0x10(%eax),%eax
}
801028d9:	5d                   	pop    %ebp
801028da:	c3                   	ret    

801028db <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028db:	55                   	push   %ebp
801028dc:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028de:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028e3:	8b 55 08             	mov    0x8(%ebp),%edx
801028e6:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028e8:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028ed:	8b 55 0c             	mov    0xc(%ebp),%edx
801028f0:	89 50 10             	mov    %edx,0x10(%eax)
}
801028f3:	5d                   	pop    %ebp
801028f4:	c3                   	ret    

801028f5 <ioapicinit>:

void
ioapicinit(void)
{
801028f5:	55                   	push   %ebp
801028f6:	89 e5                	mov    %esp,%ebp
801028f8:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028fb:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80102900:	85 c0                	test   %eax,%eax
80102902:	0f 84 9f 00 00 00    	je     801029a7 <ioapicinit+0xb2>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102908:	c7 05 34 f8 10 80 00 	movl   $0xfec00000,0x8010f834
8010290f:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102912:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102919:	e8 a6 ff ff ff       	call   801028c4 <ioapicread>
8010291e:	c1 e8 10             	shr    $0x10,%eax
80102921:	25 ff 00 00 00       	and    $0xff,%eax
80102926:	89 45 f4             	mov    %eax,-0xc(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102929:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102930:	e8 8f ff ff ff       	call   801028c4 <ioapicread>
80102935:	c1 e8 18             	shr    $0x18,%eax
80102938:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(id != ioapicid)
8010293b:	0f b6 05 00 f9 10 80 	movzbl 0x8010f900,%eax
80102942:	0f b6 c0             	movzbl %al,%eax
80102945:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102948:	74 0c                	je     80102956 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010294a:	c7 04 24 20 84 10 80 	movl   $0x80108420,(%esp)
80102951:	e8 44 da ff ff       	call   8010039a <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102956:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010295d:	eb 3e                	jmp    8010299d <ioapicinit+0xa8>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010295f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102962:	83 c0 20             	add    $0x20,%eax
80102965:	0d 00 00 01 00       	or     $0x10000,%eax
8010296a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010296d:	83 c2 08             	add    $0x8,%edx
80102970:	01 d2                	add    %edx,%edx
80102972:	89 44 24 04          	mov    %eax,0x4(%esp)
80102976:	89 14 24             	mov    %edx,(%esp)
80102979:	e8 5d ff ff ff       	call   801028db <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
8010297e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102981:	83 c0 08             	add    $0x8,%eax
80102984:	01 c0                	add    %eax,%eax
80102986:	83 c0 01             	add    $0x1,%eax
80102989:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102990:	00 
80102991:	89 04 24             	mov    %eax,(%esp)
80102994:	e8 42 ff ff ff       	call   801028db <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102999:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010299d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801029a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801029a3:	7e ba                	jle    8010295f <ioapicinit+0x6a>
801029a5:	eb 01                	jmp    801029a8 <ioapicinit+0xb3>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
801029a7:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029a8:	c9                   	leave  
801029a9:	c3                   	ret    

801029aa <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029aa:	55                   	push   %ebp
801029ab:	89 e5                	mov    %esp,%ebp
801029ad:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
801029b0:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801029b5:	85 c0                	test   %eax,%eax
801029b7:	74 39                	je     801029f2 <ioapicenable+0x48>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801029b9:	8b 45 08             	mov    0x8(%ebp),%eax
801029bc:	83 c0 20             	add    $0x20,%eax
801029bf:	8b 55 08             	mov    0x8(%ebp),%edx
801029c2:	83 c2 08             	add    $0x8,%edx
801029c5:	01 d2                	add    %edx,%edx
801029c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801029cb:	89 14 24             	mov    %edx,(%esp)
801029ce:	e8 08 ff ff ff       	call   801028db <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801029d6:	c1 e0 18             	shl    $0x18,%eax
801029d9:	8b 55 08             	mov    0x8(%ebp),%edx
801029dc:	83 c2 08             	add    $0x8,%edx
801029df:	01 d2                	add    %edx,%edx
801029e1:	83 c2 01             	add    $0x1,%edx
801029e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801029e8:	89 14 24             	mov    %edx,(%esp)
801029eb:	e8 eb fe ff ff       	call   801028db <ioapicwrite>
801029f0:	eb 01                	jmp    801029f3 <ioapicenable+0x49>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
801029f2:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801029f3:	c9                   	leave  
801029f4:	c3                   	ret    
801029f5:	00 00                	add    %al,(%eax)
	...

801029f8 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029f8:	55                   	push   %ebp
801029f9:	89 e5                	mov    %esp,%ebp
801029fb:	8b 45 08             	mov    0x8(%ebp),%eax
801029fe:	2d 00 00 00 80       	sub    $0x80000000,%eax
80102a03:	5d                   	pop    %ebp
80102a04:	c3                   	ret    

80102a05 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a05:	55                   	push   %ebp
80102a06:	89 e5                	mov    %esp,%ebp
80102a08:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a0b:	c7 44 24 04 52 84 10 	movl   $0x80108452,0x4(%esp)
80102a12:	80 
80102a13:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102a1a:	e8 9b 22 00 00       	call   80104cba <initlock>
  kmem.use_lock = 0;
80102a1f:	c7 05 74 f8 10 80 00 	movl   $0x0,0x8010f874
80102a26:	00 00 00 
  freerange(vstart, vend);
80102a29:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a30:	8b 45 08             	mov    0x8(%ebp),%eax
80102a33:	89 04 24             	mov    %eax,(%esp)
80102a36:	e8 26 00 00 00       	call   80102a61 <freerange>
}
80102a3b:	c9                   	leave  
80102a3c:	c3                   	ret    

80102a3d <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a3d:	55                   	push   %ebp
80102a3e:	89 e5                	mov    %esp,%ebp
80102a40:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a43:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a46:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a4a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a4d:	89 04 24             	mov    %eax,(%esp)
80102a50:	e8 0c 00 00 00       	call   80102a61 <freerange>
  kmem.use_lock = 1;
80102a55:	c7 05 74 f8 10 80 01 	movl   $0x1,0x8010f874
80102a5c:	00 00 00 
}
80102a5f:	c9                   	leave  
80102a60:	c3                   	ret    

80102a61 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a61:	55                   	push   %ebp
80102a62:	89 e5                	mov    %esp,%ebp
80102a64:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a67:	8b 45 08             	mov    0x8(%ebp),%eax
80102a6a:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a77:	eb 12                	jmp    80102a8b <freerange+0x2a>
    kfree(p);
80102a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a7c:	89 04 24             	mov    %eax,(%esp)
80102a7f:	e8 19 00 00 00       	call   80102a9d <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a84:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a8e:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
80102a94:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a97:	39 c2                	cmp    %eax,%edx
80102a99:	76 de                	jbe    80102a79 <freerange+0x18>
    kfree(p);
}
80102a9b:	c9                   	leave  
80102a9c:	c3                   	ret    

80102a9d <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a9d:	55                   	push   %ebp
80102a9e:	89 e5                	mov    %esp,%ebp
80102aa0:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa6:	25 ff 0f 00 00       	and    $0xfff,%eax
80102aab:	85 c0                	test   %eax,%eax
80102aad:	75 1b                	jne    80102aca <kfree+0x2d>
80102aaf:	81 7d 08 bc 2a 11 80 	cmpl   $0x80112abc,0x8(%ebp)
80102ab6:	72 12                	jb     80102aca <kfree+0x2d>
80102ab8:	8b 45 08             	mov    0x8(%ebp),%eax
80102abb:	89 04 24             	mov    %eax,(%esp)
80102abe:	e8 35 ff ff ff       	call   801029f8 <v2p>
80102ac3:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102ac8:	76 0c                	jbe    80102ad6 <kfree+0x39>
    panic("kfree");
80102aca:	c7 04 24 57 84 10 80 	movl   $0x80108457,(%esp)
80102ad1:	e8 64 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ad6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102add:	00 
80102ade:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102ae5:	00 
80102ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae9:	89 04 24             	mov    %eax,(%esp)
80102aec:	e8 39 24 00 00       	call   80104f2a <memset>

  if(kmem.use_lock)
80102af1:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102af6:	85 c0                	test   %eax,%eax
80102af8:	74 0c                	je     80102b06 <kfree+0x69>
    acquire(&kmem.lock);
80102afa:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b01:	e8 d5 21 00 00       	call   80104cdb <acquire>
  r = (struct run*)v;
80102b06:	8b 45 08             	mov    0x8(%ebp),%eax
80102b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b0c:	8b 15 78 f8 10 80    	mov    0x8010f878,%edx
80102b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b15:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1a:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102b1f:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b24:	85 c0                	test   %eax,%eax
80102b26:	74 0c                	je     80102b34 <kfree+0x97>
    release(&kmem.lock);
80102b28:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b2f:	e8 08 22 00 00       	call   80104d3c <release>
}
80102b34:	c9                   	leave  
80102b35:	c3                   	ret    

80102b36 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b36:	55                   	push   %ebp
80102b37:	89 e5                	mov    %esp,%ebp
80102b39:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b3c:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b41:	85 c0                	test   %eax,%eax
80102b43:	74 0c                	je     80102b51 <kalloc+0x1b>
    acquire(&kmem.lock);
80102b45:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b4c:	e8 8a 21 00 00       	call   80104cdb <acquire>
  r = kmem.freelist;
80102b51:	a1 78 f8 10 80       	mov    0x8010f878,%eax
80102b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b5d:	74 0a                	je     80102b69 <kalloc+0x33>
    kmem.freelist = r->next;
80102b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b62:	8b 00                	mov    (%eax),%eax
80102b64:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102b69:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b6e:	85 c0                	test   %eax,%eax
80102b70:	74 0c                	je     80102b7e <kalloc+0x48>
    release(&kmem.lock);
80102b72:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b79:	e8 be 21 00 00       	call   80104d3c <release>
  return (char*)r;
80102b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b81:	c9                   	leave  
80102b82:	c3                   	ret    
	...

80102b84 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b84:	55                   	push   %ebp
80102b85:	89 e5                	mov    %esp,%ebp
80102b87:	83 ec 14             	sub    $0x14,%esp
80102b8a:	8b 45 08             	mov    0x8(%ebp),%eax
80102b8d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b91:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b95:	89 c2                	mov    %eax,%edx
80102b97:	ec                   	in     (%dx),%al
80102b98:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b9b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b9f:	c9                   	leave  
80102ba0:	c3                   	ret    

80102ba1 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102ba1:	55                   	push   %ebp
80102ba2:	89 e5                	mov    %esp,%ebp
80102ba4:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102ba7:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102bae:	e8 d1 ff ff ff       	call   80102b84 <inb>
80102bb3:	0f b6 c0             	movzbl %al,%eax
80102bb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bbc:	83 e0 01             	and    $0x1,%eax
80102bbf:	85 c0                	test   %eax,%eax
80102bc1:	75 0a                	jne    80102bcd <kbdgetc+0x2c>
    return -1;
80102bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102bc8:	e9 20 01 00 00       	jmp    80102ced <kbdgetc+0x14c>
  data = inb(KBDATAP);
80102bcd:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102bd4:	e8 ab ff ff ff       	call   80102b84 <inb>
80102bd9:	0f b6 c0             	movzbl %al,%eax
80102bdc:	89 45 f8             	mov    %eax,-0x8(%ebp)

  if(data == 0xE0){
80102bdf:	81 7d f8 e0 00 00 00 	cmpl   $0xe0,-0x8(%ebp)
80102be6:	75 17                	jne    80102bff <kbdgetc+0x5e>
    shift |= E0ESC;
80102be8:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bed:	83 c8 40             	or     $0x40,%eax
80102bf0:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102bf5:	b8 00 00 00 00       	mov    $0x0,%eax
80102bfa:	e9 ee 00 00 00       	jmp    80102ced <kbdgetc+0x14c>
  } else if(data & 0x80){
80102bff:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c02:	25 80 00 00 00       	and    $0x80,%eax
80102c07:	85 c0                	test   %eax,%eax
80102c09:	74 44                	je     80102c4f <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c0b:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c10:	83 e0 40             	and    $0x40,%eax
80102c13:	85 c0                	test   %eax,%eax
80102c15:	75 08                	jne    80102c1f <kbdgetc+0x7e>
80102c17:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c1a:	83 e0 7f             	and    $0x7f,%eax
80102c1d:	eb 03                	jmp    80102c22 <kbdgetc+0x81>
80102c1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c22:	89 45 f8             	mov    %eax,-0x8(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c25:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c28:	0f b6 80 20 90 10 80 	movzbl -0x7fef6fe0(%eax),%eax
80102c2f:	83 c8 40             	or     $0x40,%eax
80102c32:	0f b6 c0             	movzbl %al,%eax
80102c35:	f7 d0                	not    %eax
80102c37:	89 c2                	mov    %eax,%edx
80102c39:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c3e:	21 d0                	and    %edx,%eax
80102c40:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c45:	b8 00 00 00 00       	mov    $0x0,%eax
80102c4a:	e9 9e 00 00 00       	jmp    80102ced <kbdgetc+0x14c>
  } else if(shift & E0ESC){
80102c4f:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c54:	83 e0 40             	and    $0x40,%eax
80102c57:	85 c0                	test   %eax,%eax
80102c59:	74 14                	je     80102c6f <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c5b:	81 4d f8 80 00 00 00 	orl    $0x80,-0x8(%ebp)
    shift &= ~E0ESC;
80102c62:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c67:	83 e0 bf             	and    $0xffffffbf,%eax
80102c6a:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102c6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c72:	0f b6 80 20 90 10 80 	movzbl -0x7fef6fe0(%eax),%eax
80102c79:	0f b6 d0             	movzbl %al,%edx
80102c7c:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c81:	09 d0                	or     %edx,%eax
80102c83:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102c88:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c8b:	0f b6 80 20 91 10 80 	movzbl -0x7fef6ee0(%eax),%eax
80102c92:	0f b6 d0             	movzbl %al,%edx
80102c95:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c9a:	31 d0                	xor    %edx,%eax
80102c9c:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102ca1:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102ca6:	83 e0 03             	and    $0x3,%eax
80102ca9:	8b 04 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%eax
80102cb0:	03 45 f8             	add    -0x8(%ebp),%eax
80102cb3:	0f b6 00             	movzbl (%eax),%eax
80102cb6:	0f b6 c0             	movzbl %al,%eax
80102cb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(shift & CAPSLOCK){
80102cbc:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cc1:	83 e0 08             	and    $0x8,%eax
80102cc4:	85 c0                	test   %eax,%eax
80102cc6:	74 22                	je     80102cea <kbdgetc+0x149>
    if('a' <= c && c <= 'z')
80102cc8:	83 7d fc 60          	cmpl   $0x60,-0x4(%ebp)
80102ccc:	76 0c                	jbe    80102cda <kbdgetc+0x139>
80102cce:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%ebp)
80102cd2:	77 06                	ja     80102cda <kbdgetc+0x139>
      c += 'A' - 'a';
80102cd4:	83 6d fc 20          	subl   $0x20,-0x4(%ebp)

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
80102cd8:	eb 10                	jmp    80102cea <kbdgetc+0x149>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102cda:	83 7d fc 40          	cmpl   $0x40,-0x4(%ebp)
80102cde:	76 0a                	jbe    80102cea <kbdgetc+0x149>
80102ce0:	83 7d fc 5a          	cmpl   $0x5a,-0x4(%ebp)
80102ce4:	77 04                	ja     80102cea <kbdgetc+0x149>
      c += 'a' - 'A';
80102ce6:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
  }
  return c;
80102cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102ced:	c9                   	leave  
80102cee:	c3                   	ret    

80102cef <kbdintr>:

void
kbdintr(void)
{
80102cef:	55                   	push   %ebp
80102cf0:	89 e5                	mov    %esp,%ebp
80102cf2:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102cf5:	c7 04 24 a1 2b 10 80 	movl   $0x80102ba1,(%esp)
80102cfc:	e8 aa da ff ff       	call   801007ab <consoleintr>
}
80102d01:	c9                   	leave  
80102d02:	c3                   	ret    
	...

80102d04 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d04:	55                   	push   %ebp
80102d05:	89 e5                	mov    %esp,%ebp
80102d07:	83 ec 08             	sub    $0x8,%esp
80102d0a:	8b 55 08             	mov    0x8(%ebp),%edx
80102d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d10:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102d14:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d17:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102d1b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102d1f:	ee                   	out    %al,(%dx)
}
80102d20:	c9                   	leave  
80102d21:	c3                   	ret    

80102d22 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d22:	55                   	push   %ebp
80102d23:	89 e5                	mov    %esp,%ebp
80102d25:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d28:	9c                   	pushf  
80102d29:	58                   	pop    %eax
80102d2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102d2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d30:	c9                   	leave  
80102d31:	c3                   	ret    

80102d32 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d32:	55                   	push   %ebp
80102d33:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d35:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d3a:	8b 55 08             	mov    0x8(%ebp),%edx
80102d3d:	c1 e2 02             	shl    $0x2,%edx
80102d40:	8d 14 10             	lea    (%eax,%edx,1),%edx
80102d43:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d46:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d48:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d4d:	83 c0 20             	add    $0x20,%eax
80102d50:	8b 00                	mov    (%eax),%eax
}
80102d52:	5d                   	pop    %ebp
80102d53:	c3                   	ret    

80102d54 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d54:	55                   	push   %ebp
80102d55:	89 e5                	mov    %esp,%ebp
80102d57:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d5a:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d5f:	85 c0                	test   %eax,%eax
80102d61:	0f 84 46 01 00 00    	je     80102ead <lapicinit+0x159>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d67:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d6e:	00 
80102d6f:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d76:	e8 b7 ff ff ff       	call   80102d32 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d7b:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d82:	00 
80102d83:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d8a:	e8 a3 ff ff ff       	call   80102d32 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d8f:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d96:	00 
80102d97:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d9e:	e8 8f ff ff ff       	call   80102d32 <lapicw>
  lapicw(TICR, 10000000); 
80102da3:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102daa:	00 
80102dab:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102db2:	e8 7b ff ff ff       	call   80102d32 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102db7:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dbe:	00 
80102dbf:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102dc6:	e8 67 ff ff ff       	call   80102d32 <lapicw>
  lapicw(LINT1, MASKED);
80102dcb:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dd2:	00 
80102dd3:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102dda:	e8 53 ff ff ff       	call   80102d32 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ddf:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102de4:	83 c0 30             	add    $0x30,%eax
80102de7:	8b 00                	mov    (%eax),%eax
80102de9:	c1 e8 10             	shr    $0x10,%eax
80102dec:	25 ff 00 00 00       	and    $0xff,%eax
80102df1:	83 f8 03             	cmp    $0x3,%eax
80102df4:	76 14                	jbe    80102e0a <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102df6:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dfd:	00 
80102dfe:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e05:	e8 28 ff ff ff       	call   80102d32 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e0a:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e11:	00 
80102e12:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e19:	e8 14 ff ff ff       	call   80102d32 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e1e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e25:	00 
80102e26:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e2d:	e8 00 ff ff ff       	call   80102d32 <lapicw>
  lapicw(ESR, 0);
80102e32:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e39:	00 
80102e3a:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e41:	e8 ec fe ff ff       	call   80102d32 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e46:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e4d:	00 
80102e4e:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e55:	e8 d8 fe ff ff       	call   80102d32 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e5a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e61:	00 
80102e62:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e69:	e8 c4 fe ff ff       	call   80102d32 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e6e:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e75:	00 
80102e76:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e7d:	e8 b0 fe ff ff       	call   80102d32 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e82:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e87:	05 00 03 00 00       	add    $0x300,%eax
80102e8c:	8b 00                	mov    (%eax),%eax
80102e8e:	25 00 10 00 00       	and    $0x1000,%eax
80102e93:	85 c0                	test   %eax,%eax
80102e95:	75 eb                	jne    80102e82 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e97:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e9e:	00 
80102e9f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102ea6:	e8 87 fe ff ff       	call   80102d32 <lapicw>
80102eab:	eb 01                	jmp    80102eae <lapicinit+0x15a>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102ead:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102eae:	c9                   	leave  
80102eaf:	c3                   	ret    

80102eb0 <cpunum>:

int
cpunum(void)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102eb6:	e8 67 fe ff ff       	call   80102d22 <readeflags>
80102ebb:	25 00 02 00 00       	and    $0x200,%eax
80102ec0:	85 c0                	test   %eax,%eax
80102ec2:	74 29                	je     80102eed <cpunum+0x3d>
    static int n;
    if(n++ == 0)
80102ec4:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102ec9:	85 c0                	test   %eax,%eax
80102ecb:	0f 94 c2             	sete   %dl
80102ece:	83 c0 01             	add    $0x1,%eax
80102ed1:	a3 40 b6 10 80       	mov    %eax,0x8010b640
80102ed6:	84 d2                	test   %dl,%dl
80102ed8:	74 13                	je     80102eed <cpunum+0x3d>
      cprintf("cpu called from %x with interrupts enabled\n",
80102eda:	8b 45 04             	mov    0x4(%ebp),%eax
80102edd:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ee1:	c7 04 24 60 84 10 80 	movl   $0x80108460,(%esp)
80102ee8:	e8 ad d4 ff ff       	call   8010039a <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102eed:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ef2:	85 c0                	test   %eax,%eax
80102ef4:	74 0f                	je     80102f05 <cpunum+0x55>
    return lapic[ID]>>24;
80102ef6:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102efb:	83 c0 20             	add    $0x20,%eax
80102efe:	8b 00                	mov    (%eax),%eax
80102f00:	c1 e8 18             	shr    $0x18,%eax
80102f03:	eb 05                	jmp    80102f0a <cpunum+0x5a>
  return 0;
80102f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f0a:	c9                   	leave  
80102f0b:	c3                   	ret    

80102f0c <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f0c:	55                   	push   %ebp
80102f0d:	89 e5                	mov    %esp,%ebp
80102f0f:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f12:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102f17:	85 c0                	test   %eax,%eax
80102f19:	74 14                	je     80102f2f <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f22:	00 
80102f23:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f2a:	e8 03 fe ff ff       	call   80102d32 <lapicw>
}
80102f2f:	c9                   	leave  
80102f30:	c3                   	ret    

80102f31 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f31:	55                   	push   %ebp
80102f32:	89 e5                	mov    %esp,%ebp
}
80102f34:	5d                   	pop    %ebp
80102f35:	c3                   	ret    

80102f36 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f36:	55                   	push   %ebp
80102f37:	89 e5                	mov    %esp,%ebp
80102f39:	83 ec 1c             	sub    $0x1c,%esp
80102f3c:	8b 45 08             	mov    0x8(%ebp),%eax
80102f3f:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102f42:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f49:	00 
80102f4a:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f51:	e8 ae fd ff ff       	call   80102d04 <outb>
  outb(IO_RTC+1, 0x0A);
80102f56:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f5d:	00 
80102f5e:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f65:	e8 9a fd ff ff       	call   80102d04 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f6a:	c7 45 fc 67 04 00 80 	movl   $0x80000467,-0x4(%ebp)
  wrv[0] = 0;
80102f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f74:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f7c:	8d 50 02             	lea    0x2(%eax),%edx
80102f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f82:	c1 e8 04             	shr    $0x4,%eax
80102f85:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f88:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f8c:	c1 e0 18             	shl    $0x18,%eax
80102f8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f93:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f9a:	e8 93 fd ff ff       	call   80102d32 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f9f:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102fa6:	00 
80102fa7:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fae:	e8 7f fd ff ff       	call   80102d32 <lapicw>
  microdelay(200);
80102fb3:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fba:	e8 72 ff ff ff       	call   80102f31 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102fbf:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102fc6:	00 
80102fc7:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fce:	e8 5f fd ff ff       	call   80102d32 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fd3:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102fda:	e8 52 ff ff ff       	call   80102f31 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fdf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80102fe6:	eb 40                	jmp    80103028 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102fe8:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fec:	c1 e0 18             	shl    $0x18,%eax
80102fef:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ff3:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102ffa:	e8 33 fd ff ff       	call   80102d32 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fff:	8b 45 0c             	mov    0xc(%ebp),%eax
80103002:	c1 e8 0c             	shr    $0xc,%eax
80103005:	80 cc 06             	or     $0x6,%ah
80103008:	89 44 24 04          	mov    %eax,0x4(%esp)
8010300c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103013:	e8 1a fd ff ff       	call   80102d32 <lapicw>
    microdelay(200);
80103018:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010301f:	e8 0d ff ff ff       	call   80102f31 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103024:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80103028:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
8010302c:	7e ba                	jle    80102fe8 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010302e:	c9                   	leave  
8010302f:	c3                   	ret    

80103030 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
80103036:	90                   	nop
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103037:	c7 44 24 04 8c 84 10 	movl   $0x8010848c,0x4(%esp)
8010303e:	80 
8010303f:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103046:	e8 6f 1c 00 00       	call   80104cba <initlock>
  readsb(ROOTDEV, &sb);
8010304b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010304e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103052:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103059:	e8 c2 e2 ff ff       	call   80101320 <readsb>
  log.start = sb.size - sb.nlog;
8010305e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103064:	89 d1                	mov    %edx,%ecx
80103066:	29 c1                	sub    %eax,%ecx
80103068:	89 c8                	mov    %ecx,%eax
8010306a:	a3 b4 f8 10 80       	mov    %eax,0x8010f8b4
  log.size = sb.nlog;
8010306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103072:	a3 b8 f8 10 80       	mov    %eax,0x8010f8b8
  log.dev = ROOTDEV;
80103077:	c7 05 c0 f8 10 80 01 	movl   $0x1,0x8010f8c0
8010307e:	00 00 00 
  recover_from_log();
80103081:	e8 97 01 00 00       	call   8010321d <recover_from_log>
}
80103086:	c9                   	leave  
80103087:	c3                   	ret    

80103088 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103088:	55                   	push   %ebp
80103089:	89 e5                	mov    %esp,%ebp
8010308b:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010308e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80103095:	e9 89 00 00 00       	jmp    80103123 <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010309a:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
8010309f:	03 45 ec             	add    -0x14(%ebp),%eax
801030a2:	83 c0 01             	add    $0x1,%eax
801030a5:	89 c2                	mov    %eax,%edx
801030a7:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801030ac:	89 54 24 04          	mov    %edx,0x4(%esp)
801030b0:	89 04 24             	mov    %eax,(%esp)
801030b3:	e8 ef d0 ff ff       	call   801001a7 <bread>
801030b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801030bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030be:	83 c0 10             	add    $0x10,%eax
801030c1:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
801030c8:	89 c2                	mov    %eax,%edx
801030ca:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801030cf:	89 54 24 04          	mov    %edx,0x4(%esp)
801030d3:	89 04 24             	mov    %eax,(%esp)
801030d6:	e8 cc d0 ff ff       	call   801001a7 <bread>
801030db:	89 45 f4             	mov    %eax,-0xc(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030e1:	8d 50 18             	lea    0x18(%eax),%edx
801030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030e7:	83 c0 18             	add    $0x18,%eax
801030ea:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801030f1:	00 
801030f2:	89 54 24 04          	mov    %edx,0x4(%esp)
801030f6:	89 04 24             	mov    %eax,(%esp)
801030f9:	e8 ff 1e 00 00       	call   80104ffd <memmove>
    bwrite(dbuf);  // write dst to disk
801030fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103101:	89 04 24             	mov    %eax,(%esp)
80103104:	e8 d5 d0 ff ff       	call   801001de <bwrite>
    brelse(lbuf); 
80103109:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010310c:	89 04 24             	mov    %eax,(%esp)
8010310f:	e8 04 d1 ff ff       	call   80100218 <brelse>
    brelse(dbuf);
80103114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103117:	89 04 24             	mov    %eax,(%esp)
8010311a:	e8 f9 d0 ff ff       	call   80100218 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010311f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80103123:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103128:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010312b:	0f 8f 69 ff ff ff    	jg     8010309a <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103131:	c9                   	leave  
80103132:	c3                   	ret    

80103133 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103133:	55                   	push   %ebp
80103134:	89 e5                	mov    %esp,%ebp
80103136:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103139:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
8010313e:	89 c2                	mov    %eax,%edx
80103140:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103145:	89 54 24 04          	mov    %edx,0x4(%esp)
80103149:	89 04 24             	mov    %eax,(%esp)
8010314c:	e8 56 d0 ff ff       	call   801001a7 <bread>
80103151:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103154:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103157:	83 c0 18             	add    $0x18,%eax
8010315a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  log.lh.n = lh->n;
8010315d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103160:	8b 00                	mov    (%eax),%eax
80103162:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  for (i = 0; i < log.lh.n; i++) {
80103167:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010316e:	eb 1b                	jmp    8010318b <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
80103170:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103173:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103176:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103179:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010317d:	8d 51 10             	lea    0x10(%ecx),%edx
80103180:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103187:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010318b:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103190:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103193:	7f db                	jg     80103170 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103195:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103198:	89 04 24             	mov    %eax,(%esp)
8010319b:	e8 78 d0 ff ff       	call   80100218 <brelse>
}
801031a0:	c9                   	leave  
801031a1:	c3                   	ret    

801031a2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801031a2:	55                   	push   %ebp
801031a3:	89 e5                	mov    %esp,%ebp
801031a5:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801031a8:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
801031ad:	89 c2                	mov    %eax,%edx
801031af:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801031b4:	89 54 24 04          	mov    %edx,0x4(%esp)
801031b8:	89 04 24             	mov    %eax,(%esp)
801031bb:	e8 e7 cf ff ff       	call   801001a7 <bread>
801031c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801031c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031c6:	83 c0 18             	add    $0x18,%eax
801031c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  hb->n = log.lh.n;
801031cc:	8b 15 c4 f8 10 80    	mov    0x8010f8c4,%edx
801031d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031d5:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801031d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031de:	eb 1b                	jmp    801031fb <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801031e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031e6:	83 c0 10             	add    $0x10,%eax
801031e9:	8b 0c 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%ecx
801031f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031f3:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801031f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031fb:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103200:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103203:	7f db                	jg     801031e0 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103205:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103208:	89 04 24             	mov    %eax,(%esp)
8010320b:	e8 ce cf ff ff       	call   801001de <bwrite>
  brelse(buf);
80103210:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103213:	89 04 24             	mov    %eax,(%esp)
80103216:	e8 fd cf ff ff       	call   80100218 <brelse>
}
8010321b:	c9                   	leave  
8010321c:	c3                   	ret    

8010321d <recover_from_log>:

static void
recover_from_log(void)
{
8010321d:	55                   	push   %ebp
8010321e:	89 e5                	mov    %esp,%ebp
80103220:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103223:	e8 0b ff ff ff       	call   80103133 <read_head>
  install_trans(); // if committed, copy from log to disk
80103228:	e8 5b fe ff ff       	call   80103088 <install_trans>
  log.lh.n = 0;
8010322d:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
80103234:	00 00 00 
  write_head(); // clear the log
80103237:	e8 66 ff ff ff       	call   801031a2 <write_head>
}
8010323c:	c9                   	leave  
8010323d:	c3                   	ret    

8010323e <begin_trans>:

void
begin_trans(void)
{
8010323e:	55                   	push   %ebp
8010323f:	89 e5                	mov    %esp,%ebp
80103241:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103244:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010324b:	e8 8b 1a 00 00       	call   80104cdb <acquire>
  while (log.busy) {
80103250:	eb 14                	jmp    80103266 <begin_trans+0x28>
    sleep(&log, &log.lock);
80103252:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
80103259:	80 
8010325a:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103261:	e8 86 17 00 00       	call   801049ec <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103266:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
8010326b:	85 c0                	test   %eax,%eax
8010326d:	75 e3                	jne    80103252 <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
8010326f:	c7 05 bc f8 10 80 01 	movl   $0x1,0x8010f8bc
80103276:	00 00 00 
  release(&log.lock);
80103279:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103280:	e8 b7 1a 00 00       	call   80104d3c <release>
}
80103285:	c9                   	leave  
80103286:	c3                   	ret    

80103287 <commit_trans>:

void
commit_trans(void)
{
80103287:	55                   	push   %ebp
80103288:	89 e5                	mov    %esp,%ebp
8010328a:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
8010328d:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103292:	85 c0                	test   %eax,%eax
80103294:	7e 19                	jle    801032af <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103296:	e8 07 ff ff ff       	call   801031a2 <write_head>
    install_trans(); // Now install writes to home locations
8010329b:	e8 e8 fd ff ff       	call   80103088 <install_trans>
    log.lh.n = 0; 
801032a0:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
801032a7:	00 00 00 
    write_head();    // Erase the transaction from the log
801032aa:	e8 f3 fe ff ff       	call   801031a2 <write_head>
  }
  
  acquire(&log.lock);
801032af:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801032b6:	e8 20 1a 00 00       	call   80104cdb <acquire>
  log.busy = 0;
801032bb:	c7 05 bc f8 10 80 00 	movl   $0x0,0x8010f8bc
801032c2:	00 00 00 
  wakeup(&log);
801032c5:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801032cc:	e8 03 18 00 00       	call   80104ad4 <wakeup>
  release(&log.lock);
801032d1:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801032d8:	e8 5f 1a 00 00       	call   80104d3c <release>
}
801032dd:	c9                   	leave  
801032de:	c3                   	ret    

801032df <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032df:	55                   	push   %ebp
801032e0:	89 e5                	mov    %esp,%ebp
801032e2:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032e5:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032ea:	83 f8 09             	cmp    $0x9,%eax
801032ed:	7f 12                	jg     80103301 <log_write+0x22>
801032ef:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032f4:	8b 15 b8 f8 10 80    	mov    0x8010f8b8,%edx
801032fa:	83 ea 01             	sub    $0x1,%edx
801032fd:	39 d0                	cmp    %edx,%eax
801032ff:	7c 0c                	jl     8010330d <log_write+0x2e>
    panic("too big a transaction");
80103301:	c7 04 24 90 84 10 80 	movl   $0x80108490,(%esp)
80103308:	e8 2d d2 ff ff       	call   8010053a <panic>
  if (!log.busy)
8010330d:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
80103312:	85 c0                	test   %eax,%eax
80103314:	75 0c                	jne    80103322 <log_write+0x43>
    panic("write outside of trans");
80103316:	c7 04 24 a6 84 10 80 	movl   $0x801084a6,(%esp)
8010331d:	e8 18 d2 ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
80103322:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80103329:	eb 1d                	jmp    80103348 <log_write+0x69>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
8010332b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010332e:	83 c0 10             	add    $0x10,%eax
80103331:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
80103338:	89 c2                	mov    %eax,%edx
8010333a:	8b 45 08             	mov    0x8(%ebp),%eax
8010333d:	8b 40 08             	mov    0x8(%eax),%eax
80103340:	39 c2                	cmp    %eax,%edx
80103342:	74 10                	je     80103354 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103344:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80103348:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010334d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103350:	7f d9                	jg     8010332b <log_write+0x4c>
80103352:	eb 01                	jmp    80103355 <log_write+0x76>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
80103354:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
80103355:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103358:	8b 45 08             	mov    0x8(%ebp),%eax
8010335b:	8b 40 08             	mov    0x8(%eax),%eax
8010335e:	83 c2 10             	add    $0x10,%edx
80103361:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103368:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
8010336d:	03 45 f0             	add    -0x10(%ebp),%eax
80103370:	83 c0 01             	add    $0x1,%eax
80103373:	89 c2                	mov    %eax,%edx
80103375:	8b 45 08             	mov    0x8(%ebp),%eax
80103378:	8b 40 04             	mov    0x4(%eax),%eax
8010337b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010337f:	89 04 24             	mov    %eax,(%esp)
80103382:	e8 20 ce ff ff       	call   801001a7 <bread>
80103387:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
8010338a:	8b 45 08             	mov    0x8(%ebp),%eax
8010338d:	8d 50 18             	lea    0x18(%eax),%edx
80103390:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103393:	83 c0 18             	add    $0x18,%eax
80103396:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010339d:	00 
8010339e:	89 54 24 04          	mov    %edx,0x4(%esp)
801033a2:	89 04 24             	mov    %eax,(%esp)
801033a5:	e8 53 1c 00 00       	call   80104ffd <memmove>
  bwrite(lbuf);
801033aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033ad:	89 04 24             	mov    %eax,(%esp)
801033b0:	e8 29 ce ff ff       	call   801001de <bwrite>
  brelse(lbuf);
801033b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033b8:	89 04 24             	mov    %eax,(%esp)
801033bb:	e8 58 ce ff ff       	call   80100218 <brelse>
  if (i == log.lh.n)
801033c0:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801033c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801033c8:	75 0d                	jne    801033d7 <log_write+0xf8>
    log.lh.n++;
801033ca:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801033cf:	83 c0 01             	add    $0x1,%eax
801033d2:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  b->flags |= B_DIRTY; // XXX prevent eviction
801033d7:	8b 45 08             	mov    0x8(%ebp),%eax
801033da:	8b 00                	mov    (%eax),%eax
801033dc:	89 c2                	mov    %eax,%edx
801033de:	83 ca 04             	or     $0x4,%edx
801033e1:	8b 45 08             	mov    0x8(%ebp),%eax
801033e4:	89 10                	mov    %edx,(%eax)
}
801033e6:	c9                   	leave  
801033e7:	c3                   	ret    

801033e8 <v2p>:
801033e8:	55                   	push   %ebp
801033e9:	89 e5                	mov    %esp,%ebp
801033eb:	8b 45 08             	mov    0x8(%ebp),%eax
801033ee:	2d 00 00 00 80       	sub    $0x80000000,%eax
801033f3:	5d                   	pop    %ebp
801033f4:	c3                   	ret    

801033f5 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801033f5:	55                   	push   %ebp
801033f6:	89 e5                	mov    %esp,%ebp
801033f8:	8b 45 08             	mov    0x8(%ebp),%eax
801033fb:	2d 00 00 00 80       	sub    $0x80000000,%eax
80103400:	5d                   	pop    %ebp
80103401:	c3                   	ret    

80103402 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103402:	55                   	push   %ebp
80103403:	89 e5                	mov    %esp,%ebp
80103405:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103408:	8b 55 08             	mov    0x8(%ebp),%edx
8010340b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010340e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103411:	f0 87 02             	lock xchg %eax,(%edx)
80103414:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103417:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010341a:	c9                   	leave  
8010341b:	c3                   	ret    

8010341c <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010341c:	55                   	push   %ebp
8010341d:	89 e5                	mov    %esp,%ebp
8010341f:	83 e4 f0             	and    $0xfffffff0,%esp
80103422:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103425:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
8010342c:	80 
8010342d:	c7 04 24 bc 2a 11 80 	movl   $0x80112abc,(%esp)
80103434:	e8 cc f5 ff ff       	call   80102a05 <kinit1>
  kvmalloc();      // kernel page table
80103439:	e8 99 46 00 00       	call   80107ad7 <kvmalloc>
  mpinit();        // collect info about this machine
8010343e:	e8 49 04 00 00       	call   8010388c <mpinit>
  lapicinit();
80103443:	e8 0c f9 ff ff       	call   80102d54 <lapicinit>
  seginit();       // set up segments
80103448:	e8 2c 40 00 00       	call   80107479 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010344d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103453:	0f b6 00             	movzbl (%eax),%eax
80103456:	0f b6 c0             	movzbl %al,%eax
80103459:	89 44 24 04          	mov    %eax,0x4(%esp)
8010345d:	c7 04 24 bd 84 10 80 	movl   $0x801084bd,(%esp)
80103464:	e8 31 cf ff ff       	call   8010039a <cprintf>
  picinit();       // interrupt controller
80103469:	e8 84 06 00 00       	call   80103af2 <picinit>
  ioapicinit();    // another interrupt controller
8010346e:	e8 82 f4 ff ff       	call   801028f5 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103473:	e8 10 d6 ff ff       	call   80100a88 <consoleinit>
  uartinit();      // serial port
80103478:	e8 46 33 00 00       	call   801067c3 <uartinit>
  pinit();         // process table
8010347d:	e8 80 0b 00 00       	call   80104002 <pinit>
  rqinit();
80103482:	e8 97 0b 00 00       	call   8010401e <rqinit>
  tvinit();        // trap vectors
80103487:	e8 ea 2e 00 00       	call   80106376 <tvinit>
  binit();         // buffer cache
8010348c:	e8 a3 cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103491:	e8 9e da ff ff       	call   80100f34 <fileinit>
  iinit();         // inode cache
80103496:	e8 53 e1 ff ff       	call   801015ee <iinit>
  ideinit();       // disk
8010349b:	e8 bc f0 ff ff       	call   8010255c <ideinit>
  if(!ismp)
801034a0:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801034a5:	85 c0                	test   %eax,%eax
801034a7:	75 05                	jne    801034ae <main+0x92>
    timerinit();   // uniprocessor timer
801034a9:	e8 10 2e 00 00       	call   801062be <timerinit>
  startothers();   // start other processors
801034ae:	e8 7f 00 00 00       	call   80103532 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034b3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801034ba:	8e 
801034bb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801034c2:	e8 76 f5 ff ff       	call   80102a3d <kinit2>
  userinit();      // first user process
801034c7:	e8 8d 0d 00 00       	call   80104259 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801034cc:	e8 1a 00 00 00       	call   801034eb <mpmain>

801034d1 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801034d1:	55                   	push   %ebp
801034d2:	89 e5                	mov    %esp,%ebp
801034d4:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801034d7:	e8 12 46 00 00       	call   80107aee <switchkvm>
  seginit();
801034dc:	e8 98 3f 00 00       	call   80107479 <seginit>
  lapicinit();
801034e1:	e8 6e f8 ff ff       	call   80102d54 <lapicinit>
  mpmain();
801034e6:	e8 00 00 00 00       	call   801034eb <mpmain>

801034eb <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034eb:	55                   	push   %ebp
801034ec:	89 e5                	mov    %esp,%ebp
801034ee:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801034f1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034f7:	0f b6 00             	movzbl (%eax),%eax
801034fa:	0f b6 c0             	movzbl %al,%eax
801034fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80103501:	c7 04 24 d4 84 10 80 	movl   $0x801084d4,(%esp)
80103508:	e8 8d ce ff ff       	call   8010039a <cprintf>
  idtinit();       // load idt register
8010350d:	e8 d4 2f 00 00       	call   801064e6 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103512:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103518:	05 a8 00 00 00       	add    $0xa8,%eax
8010351d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103524:	00 
80103525:	89 04 24             	mov    %eax,(%esp)
80103528:	e8 d5 fe ff ff       	call   80103402 <xchg>
  scheduler();     // start running processes
8010352d:	e8 b8 12 00 00       	call   801047ea <scheduler>

80103532 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103532:	55                   	push   %ebp
80103533:	89 e5                	mov    %esp,%ebp
80103535:	53                   	push   %ebx
80103536:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103539:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103540:	e8 b0 fe ff ff       	call   801033f5 <p2v>
80103545:	89 45 ec             	mov    %eax,-0x14(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103548:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010354d:	89 44 24 08          	mov    %eax,0x8(%esp)
80103551:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
80103558:	80 
80103559:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010355c:	89 04 24             	mov    %eax,(%esp)
8010355f:	e8 99 1a 00 00       	call   80104ffd <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103564:	c7 45 f0 20 f9 10 80 	movl   $0x8010f920,-0x10(%ebp)
8010356b:	e9 85 00 00 00       	jmp    801035f5 <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
80103570:	e8 3b f9 ff ff       	call   80102eb0 <cpunum>
80103575:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010357b:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103580:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103583:	74 68                	je     801035ed <startothers+0xbb>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103585:	e8 ac f5 ff ff       	call   80102b36 <kalloc>
8010358a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010358d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103590:	83 e8 04             	sub    $0x4,%eax
80103593:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103596:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010359c:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010359e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035a1:	83 e8 08             	sub    $0x8,%eax
801035a4:	c7 00 d1 34 10 80    	movl   $0x801034d1,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801035aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035ad:	8d 58 f4             	lea    -0xc(%eax),%ebx
801035b0:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
801035b7:	e8 2c fe ff ff       	call   801033e8 <v2p>
801035bc:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801035be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035c1:	89 04 24             	mov    %eax,(%esp)
801035c4:	e8 1f fe ff ff       	call   801033e8 <v2p>
801035c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801035cc:	0f b6 12             	movzbl (%edx),%edx
801035cf:	0f b6 d2             	movzbl %dl,%edx
801035d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801035d6:	89 14 24             	mov    %edx,(%esp)
801035d9:	e8 58 f9 ff ff       	call   80102f36 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035e1:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801035e7:	85 c0                	test   %eax,%eax
801035e9:	74 f3                	je     801035de <startothers+0xac>
801035eb:	eb 01                	jmp    801035ee <startothers+0xbc>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801035ed:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801035ee:	81 45 f0 bc 00 00 00 	addl   $0xbc,-0x10(%ebp)
801035f5:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801035fa:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103600:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103605:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103608:	0f 87 62 ff ff ff    	ja     80103570 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
8010360e:	83 c4 24             	add    $0x24,%esp
80103611:	5b                   	pop    %ebx
80103612:	5d                   	pop    %ebp
80103613:	c3                   	ret    

80103614 <p2v>:
80103614:	55                   	push   %ebp
80103615:	89 e5                	mov    %esp,%ebp
80103617:	8b 45 08             	mov    0x8(%ebp),%eax
8010361a:	2d 00 00 00 80       	sub    $0x80000000,%eax
8010361f:	5d                   	pop    %ebp
80103620:	c3                   	ret    

80103621 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103621:	55                   	push   %ebp
80103622:	89 e5                	mov    %esp,%ebp
80103624:	83 ec 14             	sub    $0x14,%esp
80103627:	8b 45 08             	mov    0x8(%ebp),%eax
8010362a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010362e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103632:	89 c2                	mov    %eax,%edx
80103634:	ec                   	in     (%dx),%al
80103635:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103638:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010363c:	c9                   	leave  
8010363d:	c3                   	ret    

8010363e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010363e:	55                   	push   %ebp
8010363f:	89 e5                	mov    %esp,%ebp
80103641:	83 ec 08             	sub    $0x8,%esp
80103644:	8b 55 08             	mov    0x8(%ebp),%edx
80103647:	8b 45 0c             	mov    0xc(%ebp),%eax
8010364a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010364e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103651:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103655:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103659:	ee                   	out    %al,(%dx)
}
8010365a:	c9                   	leave  
8010365b:	c3                   	ret    

8010365c <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
8010365c:	55                   	push   %ebp
8010365d:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
8010365f:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80103664:	89 c2                	mov    %eax,%edx
80103666:	b8 20 f9 10 80       	mov    $0x8010f920,%eax
8010366b:	89 d1                	mov    %edx,%ecx
8010366d:	29 c1                	sub    %eax,%ecx
8010366f:	89 c8                	mov    %ecx,%eax
80103671:	c1 f8 02             	sar    $0x2,%eax
80103674:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
8010367a:	5d                   	pop    %ebp
8010367b:	c3                   	ret    

8010367c <sum>:

static uchar
sum(uchar *addr, int len)
{
8010367c:	55                   	push   %ebp
8010367d:	89 e5                	mov    %esp,%ebp
8010367f:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103682:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(i=0; i<len; i++)
80103689:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80103690:	eb 13                	jmp    801036a5 <sum+0x29>
    sum += addr[i];
80103692:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103695:	03 45 08             	add    0x8(%ebp),%eax
80103698:	0f b6 00             	movzbl (%eax),%eax
8010369b:	0f b6 c0             	movzbl %al,%eax
8010369e:	01 45 fc             	add    %eax,-0x4(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
801036a1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801036a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801036a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801036ab:	7c e5                	jl     80103692 <sum+0x16>
    sum += addr[i];
  return sum;
801036ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801036b0:	c9                   	leave  
801036b1:	c3                   	ret    

801036b2 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801036b2:	55                   	push   %ebp
801036b3:	89 e5                	mov    %esp,%ebp
801036b5:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801036b8:	8b 45 08             	mov    0x8(%ebp),%eax
801036bb:	89 04 24             	mov    %eax,(%esp)
801036be:	e8 51 ff ff ff       	call   80103614 <p2v>
801036c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  e = addr+len;
801036c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801036c9:	03 45 f4             	add    -0xc(%ebp),%eax
801036cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801036cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801036d5:	eb 3f                	jmp    80103716 <mpsearch1+0x64>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036d7:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801036de:	00 
801036df:	c7 44 24 04 e8 84 10 	movl   $0x801084e8,0x4(%esp)
801036e6:	80 
801036e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036ea:	89 04 24             	mov    %eax,(%esp)
801036ed:	e8 af 18 00 00       	call   80104fa1 <memcmp>
801036f2:	85 c0                	test   %eax,%eax
801036f4:	75 1c                	jne    80103712 <mpsearch1+0x60>
801036f6:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801036fd:	00 
801036fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103701:	89 04 24             	mov    %eax,(%esp)
80103704:	e8 73 ff ff ff       	call   8010367c <sum>
80103709:	84 c0                	test   %al,%al
8010370b:	75 05                	jne    80103712 <mpsearch1+0x60>
      return (struct mp*)p;
8010370d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103710:	eb 11                	jmp    80103723 <mpsearch1+0x71>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103712:	83 45 f0 10          	addl   $0x10,-0x10(%ebp)
80103716:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103719:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010371c:	72 b9                	jb     801036d7 <mpsearch1+0x25>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
8010371e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103723:	c9                   	leave  
80103724:	c3                   	ret    

80103725 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103725:	55                   	push   %ebp
80103726:	89 e5                	mov    %esp,%ebp
80103728:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
8010372b:	c7 45 ec 00 04 00 80 	movl   $0x80000400,-0x14(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103732:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103735:	83 c0 0f             	add    $0xf,%eax
80103738:	0f b6 00             	movzbl (%eax),%eax
8010373b:	0f b6 c0             	movzbl %al,%eax
8010373e:	89 c2                	mov    %eax,%edx
80103740:	c1 e2 08             	shl    $0x8,%edx
80103743:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103746:	83 c0 0e             	add    $0xe,%eax
80103749:	0f b6 00             	movzbl (%eax),%eax
8010374c:	0f b6 c0             	movzbl %al,%eax
8010374f:	09 d0                	or     %edx,%eax
80103751:	c1 e0 04             	shl    $0x4,%eax
80103754:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103757:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010375b:	74 21                	je     8010377e <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
8010375d:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103764:	00 
80103765:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103768:	89 04 24             	mov    %eax,(%esp)
8010376b:	e8 42 ff ff ff       	call   801036b2 <mpsearch1>
80103770:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103773:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103777:	74 50                	je     801037c9 <mpsearch+0xa4>
      return mp;
80103779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010377c:	eb 5f                	jmp    801037dd <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
8010377e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103781:	83 c0 14             	add    $0x14,%eax
80103784:	0f b6 00             	movzbl (%eax),%eax
80103787:	0f b6 c0             	movzbl %al,%eax
8010378a:	89 c2                	mov    %eax,%edx
8010378c:	c1 e2 08             	shl    $0x8,%edx
8010378f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103792:	83 c0 13             	add    $0x13,%eax
80103795:	0f b6 00             	movzbl (%eax),%eax
80103798:	0f b6 c0             	movzbl %al,%eax
8010379b:	09 d0                	or     %edx,%eax
8010379d:	c1 e0 0a             	shl    $0xa,%eax
801037a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
801037a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037a6:	2d 00 04 00 00       	sub    $0x400,%eax
801037ab:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
801037b2:	00 
801037b3:	89 04 24             	mov    %eax,(%esp)
801037b6:	e8 f7 fe ff ff       	call   801036b2 <mpsearch1>
801037bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037c2:	74 05                	je     801037c9 <mpsearch+0xa4>
      return mp;
801037c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037c7:	eb 14                	jmp    801037dd <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
801037c9:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801037d0:	00 
801037d1:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
801037d8:	e8 d5 fe ff ff       	call   801036b2 <mpsearch1>
}
801037dd:	c9                   	leave  
801037de:	c3                   	ret    

801037df <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801037df:	55                   	push   %ebp
801037e0:	89 e5                	mov    %esp,%ebp
801037e2:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037e5:	e8 3b ff ff ff       	call   80103725 <mpsearch>
801037ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037f1:	74 0a                	je     801037fd <mpconfig+0x1e>
801037f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037f6:	8b 40 04             	mov    0x4(%eax),%eax
801037f9:	85 c0                	test   %eax,%eax
801037fb:	75 0a                	jne    80103807 <mpconfig+0x28>
    return 0;
801037fd:	b8 00 00 00 00       	mov    $0x0,%eax
80103802:	e9 83 00 00 00       	jmp    8010388a <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010380a:	8b 40 04             	mov    0x4(%eax),%eax
8010380d:	89 04 24             	mov    %eax,(%esp)
80103810:	e8 ff fd ff ff       	call   80103614 <p2v>
80103815:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103818:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010381f:	00 
80103820:	c7 44 24 04 ed 84 10 	movl   $0x801084ed,0x4(%esp)
80103827:	80 
80103828:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010382b:	89 04 24             	mov    %eax,(%esp)
8010382e:	e8 6e 17 00 00       	call   80104fa1 <memcmp>
80103833:	85 c0                	test   %eax,%eax
80103835:	74 07                	je     8010383e <mpconfig+0x5f>
    return 0;
80103837:	b8 00 00 00 00       	mov    $0x0,%eax
8010383c:	eb 4c                	jmp    8010388a <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
8010383e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103841:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103845:	3c 01                	cmp    $0x1,%al
80103847:	74 12                	je     8010385b <mpconfig+0x7c>
80103849:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010384c:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103850:	3c 04                	cmp    $0x4,%al
80103852:	74 07                	je     8010385b <mpconfig+0x7c>
    return 0;
80103854:	b8 00 00 00 00       	mov    $0x0,%eax
80103859:	eb 2f                	jmp    8010388a <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
8010385b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010385e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103862:	0f b7 d0             	movzwl %ax,%edx
80103865:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103868:	89 54 24 04          	mov    %edx,0x4(%esp)
8010386c:	89 04 24             	mov    %eax,(%esp)
8010386f:	e8 08 fe ff ff       	call   8010367c <sum>
80103874:	84 c0                	test   %al,%al
80103876:	74 07                	je     8010387f <mpconfig+0xa0>
    return 0;
80103878:	b8 00 00 00 00       	mov    $0x0,%eax
8010387d:	eb 0b                	jmp    8010388a <mpconfig+0xab>
  *pmp = mp;
8010387f:	8b 45 08             	mov    0x8(%ebp),%eax
80103882:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103885:	89 10                	mov    %edx,(%eax)
  return conf;
80103887:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010388a:	c9                   	leave  
8010388b:	c3                   	ret    

8010388c <mpinit>:

void
mpinit(void)
{
8010388c:	55                   	push   %ebp
8010388d:	89 e5                	mov    %esp,%ebp
8010388f:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103892:	c7 05 44 b6 10 80 20 	movl   $0x8010f920,0x8010b644
80103899:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
8010389c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010389f:	89 04 24             	mov    %eax,(%esp)
801038a2:	e8 38 ff ff ff       	call   801037df <mpconfig>
801038a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801038aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801038ae:	0f 84 9d 01 00 00    	je     80103a51 <mpinit+0x1c5>
    return;
  ismp = 1;
801038b4:	c7 05 04 f9 10 80 01 	movl   $0x1,0x8010f904
801038bb:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801038be:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038c1:	8b 40 24             	mov    0x24(%eax),%eax
801038c4:	a3 7c f8 10 80       	mov    %eax,0x8010f87c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038cc:	83 c0 2c             	add    $0x2c,%eax
801038cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801038d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038d8:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801038dc:	0f b7 c0             	movzwl %ax,%eax
801038df:	8d 04 02             	lea    (%edx,%eax,1),%eax
801038e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
801038e5:	e9 f2 00 00 00       	jmp    801039dc <mpinit+0x150>
    switch(*p){
801038ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801038ed:	0f b6 00             	movzbl (%eax),%eax
801038f0:	0f b6 c0             	movzbl %al,%eax
801038f3:	83 f8 04             	cmp    $0x4,%eax
801038f6:	0f 87 bd 00 00 00    	ja     801039b9 <mpinit+0x12d>
801038fc:	8b 04 85 30 85 10 80 	mov    -0x7fef7ad0(,%eax,4),%eax
80103903:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103908:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(ncpu != proc->apicid){
8010390b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010390e:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103912:	0f b6 d0             	movzbl %al,%edx
80103915:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010391a:	39 c2                	cmp    %eax,%edx
8010391c:	74 2d                	je     8010394b <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
8010391e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103921:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103925:	0f b6 d0             	movzbl %al,%edx
80103928:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010392d:	89 54 24 08          	mov    %edx,0x8(%esp)
80103931:	89 44 24 04          	mov    %eax,0x4(%esp)
80103935:	c7 04 24 f2 84 10 80 	movl   $0x801084f2,(%esp)
8010393c:	e8 59 ca ff ff       	call   8010039a <cprintf>
        ismp = 0;
80103941:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
80103948:	00 00 00 
      }
      if(proc->flags & MPBOOT)
8010394b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010394e:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103952:	0f b6 c0             	movzbl %al,%eax
80103955:	83 e0 02             	and    $0x2,%eax
80103958:	85 c0                	test   %eax,%eax
8010395a:	74 15                	je     80103971 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
8010395c:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103961:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103967:	05 20 f9 10 80       	add    $0x8010f920,%eax
8010396c:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103971:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103976:	8b 15 00 ff 10 80    	mov    0x8010ff00,%edx
8010397c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103982:	88 90 20 f9 10 80    	mov    %dl,-0x7fef06e0(%eax)
      ncpu++;
80103988:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010398d:	83 c0 01             	add    $0x1,%eax
80103990:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
      p += sizeof(struct mpproc);
80103995:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
      continue;
80103999:	eb 41                	jmp    801039dc <mpinit+0x150>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010399b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010399e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      ioapicid = ioapic->apicno;
801039a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039a4:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801039a8:	a2 00 f9 10 80       	mov    %al,0x8010f900
      p += sizeof(struct mpioapic);
801039ad:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
      continue;
801039b1:	eb 29                	jmp    801039dc <mpinit+0x150>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039b3:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
      continue;
801039b7:	eb 23                	jmp    801039dc <mpinit+0x150>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
801039b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039bc:	0f b6 00             	movzbl (%eax),%eax
801039bf:	0f b6 c0             	movzbl %al,%eax
801039c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801039c6:	c7 04 24 10 85 10 80 	movl   $0x80108510,(%esp)
801039cd:	e8 c8 c9 ff ff       	call   8010039a <cprintf>
      ismp = 0;
801039d2:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
801039d9:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039df:	3b 45 e8             	cmp    -0x18(%ebp),%eax
801039e2:	0f 82 02 ff ff ff    	jb     801038ea <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801039e8:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801039ed:	85 c0                	test   %eax,%eax
801039ef:	75 1d                	jne    80103a0e <mpinit+0x182>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039f1:	c7 05 00 ff 10 80 01 	movl   $0x1,0x8010ff00
801039f8:	00 00 00 
    lapic = 0;
801039fb:	c7 05 7c f8 10 80 00 	movl   $0x0,0x8010f87c
80103a02:	00 00 00 
    ioapicid = 0;
80103a05:	c6 05 00 f9 10 80 00 	movb   $0x0,0x8010f900
    return;
80103a0c:	eb 44                	jmp    80103a52 <mpinit+0x1c6>
  }

  if(mp->imcrp){
80103a0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103a11:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103a15:	84 c0                	test   %al,%al
80103a17:	74 39                	je     80103a52 <mpinit+0x1c6>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103a19:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103a20:	00 
80103a21:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103a28:	e8 11 fc ff ff       	call   8010363e <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103a2d:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a34:	e8 e8 fb ff ff       	call   80103621 <inb>
80103a39:	83 c8 01             	or     $0x1,%eax
80103a3c:	0f b6 c0             	movzbl %al,%eax
80103a3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a43:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a4a:	e8 ef fb ff ff       	call   8010363e <outb>
80103a4f:	eb 01                	jmp    80103a52 <mpinit+0x1c6>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103a51:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103a52:	c9                   	leave  
80103a53:	c3                   	ret    

80103a54 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a54:	55                   	push   %ebp
80103a55:	89 e5                	mov    %esp,%ebp
80103a57:	83 ec 08             	sub    $0x8,%esp
80103a5a:	8b 55 08             	mov    0x8(%ebp),%edx
80103a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a60:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a64:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a67:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a6b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a6f:	ee                   	out    %al,(%dx)
}
80103a70:	c9                   	leave  
80103a71:	c3                   	ret    

80103a72 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a72:	55                   	push   %ebp
80103a73:	89 e5                	mov    %esp,%ebp
80103a75:	83 ec 0c             	sub    $0xc,%esp
80103a78:	8b 45 08             	mov    0x8(%ebp),%eax
80103a7b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a7f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a83:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103a89:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a8d:	0f b6 c0             	movzbl %al,%eax
80103a90:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a94:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a9b:	e8 b4 ff ff ff       	call   80103a54 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103aa0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103aa4:	66 c1 e8 08          	shr    $0x8,%ax
80103aa8:	0f b6 c0             	movzbl %al,%eax
80103aab:	89 44 24 04          	mov    %eax,0x4(%esp)
80103aaf:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ab6:	e8 99 ff ff ff       	call   80103a54 <outb>
}
80103abb:	c9                   	leave  
80103abc:	c3                   	ret    

80103abd <picenable>:

void
picenable(int irq)
{
80103abd:	55                   	push   %ebp
80103abe:	89 e5                	mov    %esp,%ebp
80103ac0:	53                   	push   %ebx
80103ac1:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80103ac7:	ba 01 00 00 00       	mov    $0x1,%edx
80103acc:	89 d3                	mov    %edx,%ebx
80103ace:	89 c1                	mov    %eax,%ecx
80103ad0:	d3 e3                	shl    %cl,%ebx
80103ad2:	89 d8                	mov    %ebx,%eax
80103ad4:	89 c2                	mov    %eax,%edx
80103ad6:	f7 d2                	not    %edx
80103ad8:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103adf:	21 d0                	and    %edx,%eax
80103ae1:	0f b7 c0             	movzwl %ax,%eax
80103ae4:	89 04 24             	mov    %eax,(%esp)
80103ae7:	e8 86 ff ff ff       	call   80103a72 <picsetmask>
}
80103aec:	83 c4 04             	add    $0x4,%esp
80103aef:	5b                   	pop    %ebx
80103af0:	5d                   	pop    %ebp
80103af1:	c3                   	ret    

80103af2 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103af2:	55                   	push   %ebp
80103af3:	89 e5                	mov    %esp,%ebp
80103af5:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103af8:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103aff:	00 
80103b00:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b07:	e8 48 ff ff ff       	call   80103a54 <outb>
  outb(IO_PIC2+1, 0xFF);
80103b0c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b13:	00 
80103b14:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b1b:	e8 34 ff ff ff       	call   80103a54 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103b20:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b27:	00 
80103b28:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b2f:	e8 20 ff ff ff       	call   80103a54 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103b34:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103b3b:	00 
80103b3c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b43:	e8 0c ff ff ff       	call   80103a54 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b48:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b4f:	00 
80103b50:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b57:	e8 f8 fe ff ff       	call   80103a54 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b5c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b63:	00 
80103b64:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b6b:	e8 e4 fe ff ff       	call   80103a54 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b70:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b77:	00 
80103b78:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b7f:	e8 d0 fe ff ff       	call   80103a54 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b84:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b8b:	00 
80103b8c:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b93:	e8 bc fe ff ff       	call   80103a54 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b98:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103b9f:	00 
80103ba0:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ba7:	e8 a8 fe ff ff       	call   80103a54 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103bac:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103bb3:	00 
80103bb4:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bbb:	e8 94 fe ff ff       	call   80103a54 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103bc0:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bc7:	00 
80103bc8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103bcf:	e8 80 fe ff ff       	call   80103a54 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103bd4:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bdb:	00 
80103bdc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103be3:	e8 6c fe ff ff       	call   80103a54 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103be8:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bef:	00 
80103bf0:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bf7:	e8 58 fe ff ff       	call   80103a54 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103bfc:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103c03:	00 
80103c04:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c0b:	e8 44 fe ff ff       	call   80103a54 <outb>

  if(irqmask != 0xFFFF)
80103c10:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c17:	66 83 f8 ff          	cmp    $0xffffffff,%ax
80103c1b:	74 12                	je     80103c2f <picinit+0x13d>
    picsetmask(irqmask);
80103c1d:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c24:	0f b7 c0             	movzwl %ax,%eax
80103c27:	89 04 24             	mov    %eax,(%esp)
80103c2a:	e8 43 fe ff ff       	call   80103a72 <picsetmask>
}
80103c2f:	c9                   	leave  
80103c30:	c3                   	ret    
80103c31:	00 00                	add    %al,(%eax)
	...

80103c34 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c34:	55                   	push   %ebp
80103c35:	89 e5                	mov    %esp,%ebp
80103c37:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103c3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103c41:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c4d:	8b 10                	mov    (%eax),%edx
80103c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80103c52:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c54:	e8 f7 d2 ff ff       	call   80100f50 <filealloc>
80103c59:	8b 55 08             	mov    0x8(%ebp),%edx
80103c5c:	89 02                	mov    %eax,(%edx)
80103c5e:	8b 45 08             	mov    0x8(%ebp),%eax
80103c61:	8b 00                	mov    (%eax),%eax
80103c63:	85 c0                	test   %eax,%eax
80103c65:	0f 84 c8 00 00 00    	je     80103d33 <pipealloc+0xff>
80103c6b:	e8 e0 d2 ff ff       	call   80100f50 <filealloc>
80103c70:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c73:	89 02                	mov    %eax,(%edx)
80103c75:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c78:	8b 00                	mov    (%eax),%eax
80103c7a:	85 c0                	test   %eax,%eax
80103c7c:	0f 84 b1 00 00 00    	je     80103d33 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c82:	e8 af ee ff ff       	call   80102b36 <kalloc>
80103c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c8e:	0f 84 9e 00 00 00    	je     80103d32 <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
80103c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c97:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c9e:	00 00 00 
  p->writeopen = 1;
80103ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca4:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103cab:	00 00 00 
  p->nwrite = 0;
80103cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb1:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cb8:	00 00 00 
  p->nread = 0;
80103cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cbe:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103cc5:	00 00 00 
  initlock(&p->lock, "pipe");
80103cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ccb:	c7 44 24 04 44 85 10 	movl   $0x80108544,0x4(%esp)
80103cd2:	80 
80103cd3:	89 04 24             	mov    %eax,(%esp)
80103cd6:	e8 df 0f 00 00       	call   80104cba <initlock>
  (*f0)->type = FD_PIPE;
80103cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80103cde:	8b 00                	mov    (%eax),%eax
80103ce0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80103ce9:	8b 00                	mov    (%eax),%eax
80103ceb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103cef:	8b 45 08             	mov    0x8(%ebp),%eax
80103cf2:	8b 00                	mov    (%eax),%eax
80103cf4:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cf8:	8b 45 08             	mov    0x8(%ebp),%eax
80103cfb:	8b 00                	mov    (%eax),%eax
80103cfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d00:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d03:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d06:	8b 00                	mov    (%eax),%eax
80103d08:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d11:	8b 00                	mov    (%eax),%eax
80103d13:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d17:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d1a:	8b 00                	mov    (%eax),%eax
80103d1c:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d20:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d23:	8b 00                	mov    (%eax),%eax
80103d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d28:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103d2b:	b8 00 00 00 00       	mov    $0x0,%eax
80103d30:	eb 43                	jmp    80103d75 <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103d32:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103d33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d37:	74 0b                	je     80103d44 <pipealloc+0x110>
    kfree((char*)p);
80103d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d3c:	89 04 24             	mov    %eax,(%esp)
80103d3f:	e8 59 ed ff ff       	call   80102a9d <kfree>
  if(*f0)
80103d44:	8b 45 08             	mov    0x8(%ebp),%eax
80103d47:	8b 00                	mov    (%eax),%eax
80103d49:	85 c0                	test   %eax,%eax
80103d4b:	74 0d                	je     80103d5a <pipealloc+0x126>
    fileclose(*f0);
80103d4d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d50:	8b 00                	mov    (%eax),%eax
80103d52:	89 04 24             	mov    %eax,(%esp)
80103d55:	e8 9f d2 ff ff       	call   80100ff9 <fileclose>
  if(*f1)
80103d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d5d:	8b 00                	mov    (%eax),%eax
80103d5f:	85 c0                	test   %eax,%eax
80103d61:	74 0d                	je     80103d70 <pipealloc+0x13c>
    fileclose(*f1);
80103d63:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d66:	8b 00                	mov    (%eax),%eax
80103d68:	89 04 24             	mov    %eax,(%esp)
80103d6b:	e8 89 d2 ff ff       	call   80100ff9 <fileclose>
  return -1;
80103d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d75:	c9                   	leave  
80103d76:	c3                   	ret    

80103d77 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d77:	55                   	push   %ebp
80103d78:	89 e5                	mov    %esp,%ebp
80103d7a:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d80:	89 04 24             	mov    %eax,(%esp)
80103d83:	e8 53 0f 00 00       	call   80104cdb <acquire>
  if(writable){
80103d88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d8c:	74 1f                	je     80103dad <pipeclose+0x36>
    p->writeopen = 0;
80103d8e:	8b 45 08             	mov    0x8(%ebp),%eax
80103d91:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d98:	00 00 00 
    wakeup(&p->nread);
80103d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9e:	05 34 02 00 00       	add    $0x234,%eax
80103da3:	89 04 24             	mov    %eax,(%esp)
80103da6:	e8 29 0d 00 00       	call   80104ad4 <wakeup>
80103dab:	eb 1d                	jmp    80103dca <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103dad:	8b 45 08             	mov    0x8(%ebp),%eax
80103db0:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103db7:	00 00 00 
    wakeup(&p->nwrite);
80103dba:	8b 45 08             	mov    0x8(%ebp),%eax
80103dbd:	05 38 02 00 00       	add    $0x238,%eax
80103dc2:	89 04 24             	mov    %eax,(%esp)
80103dc5:	e8 0a 0d 00 00       	call   80104ad4 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103dca:	8b 45 08             	mov    0x8(%ebp),%eax
80103dcd:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103dd3:	85 c0                	test   %eax,%eax
80103dd5:	75 25                	jne    80103dfc <pipeclose+0x85>
80103dd7:	8b 45 08             	mov    0x8(%ebp),%eax
80103dda:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103de0:	85 c0                	test   %eax,%eax
80103de2:	75 18                	jne    80103dfc <pipeclose+0x85>
    release(&p->lock);
80103de4:	8b 45 08             	mov    0x8(%ebp),%eax
80103de7:	89 04 24             	mov    %eax,(%esp)
80103dea:	e8 4d 0f 00 00       	call   80104d3c <release>
    kfree((char*)p);
80103def:	8b 45 08             	mov    0x8(%ebp),%eax
80103df2:	89 04 24             	mov    %eax,(%esp)
80103df5:	e8 a3 ec ff ff       	call   80102a9d <kfree>
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103dfa:	eb 0b                	jmp    80103e07 <pipeclose+0x90>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80103dff:	89 04 24             	mov    %eax,(%esp)
80103e02:	e8 35 0f 00 00       	call   80104d3c <release>
}
80103e07:	c9                   	leave  
80103e08:	c3                   	ret    

80103e09 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e09:	55                   	push   %ebp
80103e0a:	89 e5                	mov    %esp,%ebp
80103e0c:	53                   	push   %ebx
80103e0d:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103e10:	8b 45 08             	mov    0x8(%ebp),%eax
80103e13:	89 04 24             	mov    %eax,(%esp)
80103e16:	e8 c0 0e 00 00       	call   80104cdb <acquire>
  for(i = 0; i < n; i++){
80103e1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103e22:	e9 a6 00 00 00       	jmp    80103ecd <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103e27:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2a:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e30:	85 c0                	test   %eax,%eax
80103e32:	74 0d                	je     80103e41 <pipewrite+0x38>
80103e34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e3a:	8b 40 24             	mov    0x24(%eax),%eax
80103e3d:	85 c0                	test   %eax,%eax
80103e3f:	74 15                	je     80103e56 <pipewrite+0x4d>
        release(&p->lock);
80103e41:	8b 45 08             	mov    0x8(%ebp),%eax
80103e44:	89 04 24             	mov    %eax,(%esp)
80103e47:	e8 f0 0e 00 00       	call   80104d3c <release>
        return -1;
80103e4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e51:	e9 9d 00 00 00       	jmp    80103ef3 <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e56:	8b 45 08             	mov    0x8(%ebp),%eax
80103e59:	05 34 02 00 00       	add    $0x234,%eax
80103e5e:	89 04 24             	mov    %eax,(%esp)
80103e61:	e8 6e 0c 00 00       	call   80104ad4 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e66:	8b 45 08             	mov    0x8(%ebp),%eax
80103e69:	8b 55 08             	mov    0x8(%ebp),%edx
80103e6c:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e72:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e76:	89 14 24             	mov    %edx,(%esp)
80103e79:	e8 6e 0b 00 00       	call   801049ec <sleep>
80103e7e:	eb 01                	jmp    80103e81 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e80:	90                   	nop
80103e81:	8b 45 08             	mov    0x8(%ebp),%eax
80103e84:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e8a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8d:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e93:	05 00 02 00 00       	add    $0x200,%eax
80103e98:	39 c2                	cmp    %eax,%edx
80103e9a:	74 8b                	je     80103e27 <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e9c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103ea5:	89 c3                	mov    %eax,%ebx
80103ea7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103eb0:	03 55 0c             	add    0xc(%ebp),%edx
80103eb3:	0f b6 0a             	movzbl (%edx),%ecx
80103eb6:	8b 55 08             	mov    0x8(%ebp),%edx
80103eb9:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103ebd:	8d 50 01             	lea    0x1(%eax),%edx
80103ec0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec3:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103ec9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed0:	3b 45 10             	cmp    0x10(%ebp),%eax
80103ed3:	7c ab                	jl     80103e80 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103ed5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed8:	05 34 02 00 00       	add    $0x234,%eax
80103edd:	89 04 24             	mov    %eax,(%esp)
80103ee0:	e8 ef 0b 00 00       	call   80104ad4 <wakeup>
  release(&p->lock);
80103ee5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee8:	89 04 24             	mov    %eax,(%esp)
80103eeb:	e8 4c 0e 00 00       	call   80104d3c <release>
  return n;
80103ef0:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103ef3:	83 c4 24             	add    $0x24,%esp
80103ef6:	5b                   	pop    %ebx
80103ef7:	5d                   	pop    %ebp
80103ef8:	c3                   	ret    

80103ef9 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ef9:	55                   	push   %ebp
80103efa:	89 e5                	mov    %esp,%ebp
80103efc:	53                   	push   %ebx
80103efd:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103f00:	8b 45 08             	mov    0x8(%ebp),%eax
80103f03:	89 04 24             	mov    %eax,(%esp)
80103f06:	e8 d0 0d 00 00       	call   80104cdb <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f0b:	eb 3a                	jmp    80103f47 <piperead+0x4e>
    if(proc->killed){
80103f0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f13:	8b 40 24             	mov    0x24(%eax),%eax
80103f16:	85 c0                	test   %eax,%eax
80103f18:	74 15                	je     80103f2f <piperead+0x36>
      release(&p->lock);
80103f1a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f1d:	89 04 24             	mov    %eax,(%esp)
80103f20:	e8 17 0e 00 00       	call   80104d3c <release>
      return -1;
80103f25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f2a:	e9 b6 00 00 00       	jmp    80103fe5 <piperead+0xec>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f32:	8b 55 08             	mov    0x8(%ebp),%edx
80103f35:	81 c2 34 02 00 00    	add    $0x234,%edx
80103f3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f3f:	89 14 24             	mov    %edx,(%esp)
80103f42:	e8 a5 0a 00 00       	call   801049ec <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f47:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f50:	8b 45 08             	mov    0x8(%ebp),%eax
80103f53:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f59:	39 c2                	cmp    %eax,%edx
80103f5b:	75 0d                	jne    80103f6a <piperead+0x71>
80103f5d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f60:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f66:	85 c0                	test   %eax,%eax
80103f68:	75 a3                	jne    80103f0d <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f71:	eb 49                	jmp    80103fbc <piperead+0xc3>
    if(p->nread == p->nwrite)
80103f73:	8b 45 08             	mov    0x8(%ebp),%eax
80103f76:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f7c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f85:	39 c2                	cmp    %eax,%edx
80103f87:	74 3d                	je     80103fc6 <piperead+0xcd>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f8c:	89 c2                	mov    %eax,%edx
80103f8e:	03 55 0c             	add    0xc(%ebp),%edx
80103f91:	8b 45 08             	mov    0x8(%ebp),%eax
80103f94:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f9a:	89 c3                	mov    %eax,%ebx
80103f9c:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103fa2:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103fa5:	0f b6 4c 19 34       	movzbl 0x34(%ecx,%ebx,1),%ecx
80103faa:	88 0a                	mov    %cl,(%edx)
80103fac:	8d 50 01             	lea    0x1(%eax),%edx
80103faf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb2:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fb8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fbf:	3b 45 10             	cmp    0x10(%ebp),%eax
80103fc2:	7c af                	jl     80103f73 <piperead+0x7a>
80103fc4:	eb 01                	jmp    80103fc7 <piperead+0xce>
    if(p->nread == p->nwrite)
      break;
80103fc6:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80103fca:	05 38 02 00 00       	add    $0x238,%eax
80103fcf:	89 04 24             	mov    %eax,(%esp)
80103fd2:	e8 fd 0a 00 00       	call   80104ad4 <wakeup>
  release(&p->lock);
80103fd7:	8b 45 08             	mov    0x8(%ebp),%eax
80103fda:	89 04 24             	mov    %eax,(%esp)
80103fdd:	e8 5a 0d 00 00       	call   80104d3c <release>
  return i;
80103fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103fe5:	83 c4 24             	add    $0x24,%esp
80103fe8:	5b                   	pop    %ebx
80103fe9:	5d                   	pop    %ebp
80103fea:	c3                   	ret    
	...

80103fec <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103fec:	55                   	push   %ebp
80103fed:	89 e5                	mov    %esp,%ebp
80103fef:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ff2:	9c                   	pushf  
80103ff3:	58                   	pop    %eax
80103ff4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103ff7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103ffa:	c9                   	leave  
80103ffb:	c3                   	ret    

80103ffc <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80103ffc:	55                   	push   %ebp
80103ffd:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103fff:	fb                   	sti    
}
80104000:	5d                   	pop    %ebp
80104001:	c3                   	ret    

80104002 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104002:	55                   	push   %ebp
80104003:	89 e5                	mov    %esp,%ebp
80104005:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104008:	c7 44 24 04 49 85 10 	movl   $0x80108549,0x4(%esp)
8010400f:	80 
80104010:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104017:	e8 9e 0c 00 00       	call   80104cba <initlock>
 
}
8010401c:	c9                   	leave  
8010401d:	c3                   	ret    

8010401e <rqinit>:

void
rqinit(void)
{
8010401e:	55                   	push   %ebp
8010401f:	89 e5                	mov    %esp,%ebp
80104021:	83 ec 28             	sub    $0x28,%esp
  int i;
  initlock(&ready_q.lock, "ready_q");
80104024:	c7 44 24 04 50 85 10 	movl   $0x80108550,0x4(%esp)
8010402b:	80 
8010402c:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104033:	e8 82 0c 00 00       	call   80104cba <initlock>
  for(i = 0; i < NPRIORITYS; i++)
80104038:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010403f:	eb 15                	jmp    80104056 <rqinit+0x38>
    {
      ready_q.proc[i] = 0; 
80104041:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104044:	83 c0 0c             	add    $0xc,%eax
80104047:	c7 04 85 24 ff 10 80 	movl   $0x0,-0x7fef00dc(,%eax,4)
8010404e:	00 00 00 00 
void
rqinit(void)
{
  int i;
  initlock(&ready_q.lock, "ready_q");
  for(i = 0; i < NPRIORITYS; i++)
80104052:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104056:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
8010405a:	7e e5                	jle    80104041 <rqinit+0x23>
    {
      ready_q.proc[i] = 0; 
    }
}
8010405c:	c9                   	leave  
8010405d:	c3                   	ret    

8010405e <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010405e:	55                   	push   %ebp
8010405f:	89 e5                	mov    %esp,%ebp
80104061:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104064:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
8010406b:	e8 6b 0c 00 00       	call   80104cdb <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104070:	c7 45 f0 14 00 11 80 	movl   $0x80110014,-0x10(%ebp)
80104077:	eb 11                	jmp    8010408a <allocproc+0x2c>
    if(p->state == UNUSED)
80104079:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010407c:	8b 40 0c             	mov    0xc(%eax),%eax
8010407f:	85 c0                	test   %eax,%eax
80104081:	74 27                	je     801040aa <allocproc+0x4c>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104083:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
8010408a:	b8 14 22 11 80       	mov    $0x80112214,%eax
8010408f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104092:	72 e5                	jb     80104079 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104094:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
8010409b:	e8 9c 0c 00 00       	call   80104d3c <release>
  return 0;
801040a0:	b8 00 00 00 00       	mov    $0x0,%eax
801040a5:	e9 d9 00 00 00       	jmp    80104183 <allocproc+0x125>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
801040aa:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801040ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040ae:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801040b5:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801040ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040bd:	89 42 10             	mov    %eax,0x10(%edx)
801040c0:	83 c0 01             	add    $0x1,%eax
801040c3:	a3 04 b0 10 80       	mov    %eax,0x8010b004
  //set high prority 
  p-> priority = 0; 
801040c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040cb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801040d2:	00 00 00 
  //need to malloc size??
   p->next = 0; 
801040d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040d8:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801040df:	00 00 00 
   p->prev = 0; 
801040e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040e5:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  release(&ptable.lock);
801040ec:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801040f3:	e8 44 0c 00 00       	call   80104d3c <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801040f8:	e8 39 ea ff ff       	call   80102b36 <kalloc>
801040fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104100:	89 42 08             	mov    %eax,0x8(%edx)
80104103:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104106:	8b 40 08             	mov    0x8(%eax),%eax
80104109:	85 c0                	test   %eax,%eax
8010410b:	75 11                	jne    8010411e <allocproc+0xc0>
    p->state = UNUSED;
8010410d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104110:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104117:	b8 00 00 00 00       	mov    $0x0,%eax
8010411c:	eb 65                	jmp    80104183 <allocproc+0x125>
  }
  sp = p->kstack + KSTACKSIZE;
8010411e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104121:	8b 40 08             	mov    0x8(%eax),%eax
80104124:	05 00 10 00 00       	add    $0x1000,%eax
80104129:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010412c:	83 6d f4 4c          	subl   $0x4c,-0xc(%ebp)
  p->tf = (struct trapframe*)sp;
80104130:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104133:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104136:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104139:	83 6d f4 04          	subl   $0x4,-0xc(%ebp)
  *(uint*)sp = (uint)trapret;
8010413d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104140:	ba 30 63 10 80       	mov    $0x80106330,%edx
80104145:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104147:	83 6d f4 14          	subl   $0x14,-0xc(%ebp)
  p->context = (struct context*)sp;
8010414b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010414e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104151:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104154:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104157:	8b 40 1c             	mov    0x1c(%eax),%eax
8010415a:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104161:	00 
80104162:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104169:	00 
8010416a:	89 04 24             	mov    %eax,(%esp)
8010416d:	e8 b8 0d 00 00       	call   80104f2a <memset>
  p->context->eip = (uint)forkret;
80104172:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104175:	8b 40 1c             	mov    0x1c(%eax),%eax
80104178:	ba c0 49 10 80       	mov    $0x801049c0,%edx
8010417d:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104180:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80104183:	c9                   	leave  
80104184:	c3                   	ret    

80104185 <ready1>:


int ready1(struct proc * process)
{
80104185:	55                   	push   %ebp
80104186:	89 e5                	mov    %esp,%ebp
80104188:	83 ec 10             	sub    $0x10,%esp
  struct proc *proc;
  if(!process)
8010418b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010418f:	75 0a                	jne    8010419b <ready1+0x16>
    return -1;
80104191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104196:	e9 8b 00 00 00       	jmp    80104226 <ready1+0xa1>
  if(process->priority > NPRIORITYS || process->priority < 0)
8010419b:	8b 45 08             	mov    0x8(%ebp),%eax
8010419e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801041a4:	83 f8 20             	cmp    $0x20,%eax
801041a7:	7f 0d                	jg     801041b6 <ready1+0x31>
801041a9:	8b 45 08             	mov    0x8(%ebp),%eax
801041ac:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801041b2:	85 c0                	test   %eax,%eax
801041b4:	79 07                	jns    801041bd <ready1+0x38>
    return -1; 
801041b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041bb:	eb 69                	jmp    80104226 <ready1+0xa1>
  if((proc = ready_q.proc[process->priority]))
801041bd:	8b 45 08             	mov    0x8(%ebp),%eax
801041c0:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801041c6:	83 c0 0c             	add    $0xc,%eax
801041c9:	8b 04 85 24 ff 10 80 	mov    -0x7fef00dc(,%eax,4),%eax
801041d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
801041d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801041d7:	74 32                	je     8010420b <ready1+0x86>
    {
      while(proc->next)
801041d9:	eb 0c                	jmp    801041e7 <ready1+0x62>
	{
	  proc = proc->next;
801041db:	8b 45 fc             	mov    -0x4(%ebp),%eax
801041de:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801041e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return -1;
  if(process->priority > NPRIORITYS || process->priority < 0)
    return -1; 
  if((proc = ready_q.proc[process->priority]))
    {
      while(proc->next)
801041e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801041ea:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801041f0:	85 c0                	test   %eax,%eax
801041f2:	75 e7                	jne    801041db <ready1+0x56>
	{
	  proc = proc->next;
	}
      proc->next = process; 
801041f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801041f7:	8b 55 08             	mov    0x8(%ebp),%edx
801041fa:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
      process->prev = proc;
80104200:	8b 45 08             	mov    0x8(%ebp),%eax
80104203:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104206:	89 50 7c             	mov    %edx,0x7c(%eax)
80104209:	eb 16                	jmp    80104221 <ready1+0x9c>
    }
  else
    {
      ready_q.proc[process->priority] = process; 
8010420b:	8b 45 08             	mov    0x8(%ebp),%eax
8010420e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104214:	8d 50 0c             	lea    0xc(%eax),%edx
80104217:	8b 45 08             	mov    0x8(%ebp),%eax
8010421a:	89 04 95 24 ff 10 80 	mov    %eax,-0x7fef00dc(,%edx,4)
    }
  //cprintf("pnt: %d, prio: %d\n", process,  process->priority );
  return 1; 
80104221:	b8 01 00 00 00       	mov    $0x1,%eax

}
80104226:	c9                   	leave  
80104227:	c3                   	ret    

80104228 <ready>:

int ready(struct proc * process)
{
80104228:	55                   	push   %ebp
80104229:	89 e5                	mov    %esp,%ebp
8010422b:	83 ec 28             	sub    $0x28,%esp
  int ret; 
  acquire(&ptable.lock);
8010422e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104235:	e8 a1 0a 00 00       	call   80104cdb <acquire>
  ret = ready1(process);
8010423a:	8b 45 08             	mov    0x8(%ebp),%eax
8010423d:	89 04 24             	mov    %eax,(%esp)
80104240:	e8 40 ff ff ff       	call   80104185 <ready1>
80104245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&ptable.lock);
80104248:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
8010424f:	e8 e8 0a 00 00       	call   80104d3c <release>
  return ret;
80104254:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104257:	c9                   	leave  
80104258:	c3                   	ret    

80104259 <userinit>:
// Set up first user process.


void
userinit(void)
{
80104259:	55                   	push   %ebp
8010425a:	89 e5                	mov    %esp,%ebp
8010425c:	83 ec 28             	sub    $0x28,%esp
  cprintf("userinit\n");
8010425f:	c7 04 24 58 85 10 80 	movl   $0x80108558,(%esp)
80104266:	e8 2f c1 ff ff       	call   8010039a <cprintf>
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
8010426b:	e8 ee fd ff ff       	call   8010405e <allocproc>
80104270:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104273:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104276:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
8010427b:	e8 99 37 00 00       	call   80107a19 <setupkvm>
80104280:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104283:	89 42 04             	mov    %eax,0x4(%edx)
80104286:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104289:	8b 40 04             	mov    0x4(%eax),%eax
8010428c:	85 c0                	test   %eax,%eax
8010428e:	75 0c                	jne    8010429c <userinit+0x43>
    panic("userinit: out of memory?");
80104290:	c7 04 24 62 85 10 80 	movl   $0x80108562,(%esp)
80104297:	e8 9e c2 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010429c:	ba 2c 00 00 00       	mov    $0x2c,%edx
801042a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a4:	8b 40 04             	mov    0x4(%eax),%eax
801042a7:	89 54 24 08          	mov    %edx,0x8(%esp)
801042ab:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
801042b2:	80 
801042b3:	89 04 24             	mov    %eax,(%esp)
801042b6:	e8 b7 39 00 00       	call   80107c72 <inituvm>
  p->sz = PGSIZE;
801042bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042be:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801042c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c7:	8b 40 18             	mov    0x18(%eax),%eax
801042ca:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801042d1:	00 
801042d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801042d9:	00 
801042da:	89 04 24             	mov    %eax,(%esp)
801042dd:	e8 48 0c 00 00       	call   80104f2a <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e5:	8b 40 18             	mov    0x18(%eax),%eax
801042e8:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f1:	8b 40 18             	mov    0x18(%eax),%eax
801042f4:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801042fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042fd:	8b 40 18             	mov    0x18(%eax),%eax
80104300:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104303:	8b 52 18             	mov    0x18(%edx),%edx
80104306:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010430a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010430e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104311:	8b 40 18             	mov    0x18(%eax),%eax
80104314:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104317:	8b 52 18             	mov    0x18(%edx),%edx
8010431a:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010431e:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104322:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104325:	8b 40 18             	mov    0x18(%eax),%eax
80104328:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010432f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104332:	8b 40 18             	mov    0x18(%eax),%eax
80104335:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010433c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010433f:	8b 40 18             	mov    0x18(%eax),%eax
80104342:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434c:	83 c0 6c             	add    $0x6c,%eax
8010434f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104356:	00 
80104357:	c7 44 24 04 7b 85 10 	movl   $0x8010857b,0x4(%esp)
8010435e:	80 
8010435f:	89 04 24             	mov    %eax,(%esp)
80104362:	e8 f6 0d 00 00       	call   8010515d <safestrcpy>
  p->cwd = namei("/");
80104367:	c7 04 24 84 85 10 80 	movl   $0x80108584,(%esp)
8010436e:	e8 dc e0 ff ff       	call   8010244f <namei>
80104373:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104376:	89 42 68             	mov    %eax,0x68(%edx)
  cprintf("here\n");
80104379:	c7 04 24 86 85 10 80 	movl   $0x80108586,(%esp)
80104380:	e8 15 c0 ff ff       	call   8010039a <cprintf>
  
  p->state = RUNNABLE;
80104385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104388:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  ready(p);
8010438f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104392:	89 04 24             	mov    %eax,(%esp)
80104395:	e8 8e fe ff ff       	call   80104228 <ready>

}
8010439a:	c9                   	leave  
8010439b:	c3                   	ret    

8010439c <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010439c:	55                   	push   %ebp
8010439d:	89 e5                	mov    %esp,%ebp
8010439f:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
801043a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043a8:	8b 00                	mov    (%eax),%eax
801043aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801043ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801043b1:	7e 34                	jle    801043e7 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801043b3:	8b 45 08             	mov    0x8(%ebp),%eax
801043b6:	89 c2                	mov    %eax,%edx
801043b8:	03 55 f4             	add    -0xc(%ebp),%edx
801043bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043c1:	8b 40 04             	mov    0x4(%eax),%eax
801043c4:	89 54 24 08          	mov    %edx,0x8(%esp)
801043c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043cb:	89 54 24 04          	mov    %edx,0x4(%esp)
801043cf:	89 04 24             	mov    %eax,(%esp)
801043d2:	e8 16 3a 00 00       	call   80107ded <allocuvm>
801043d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043de:	75 41                	jne    80104421 <growproc+0x85>
      return -1;
801043e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043e5:	eb 58                	jmp    8010443f <growproc+0xa3>
  } else if(n < 0){
801043e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801043eb:	79 34                	jns    80104421 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801043ed:	8b 45 08             	mov    0x8(%ebp),%eax
801043f0:	89 c2                	mov    %eax,%edx
801043f2:	03 55 f4             	add    -0xc(%ebp),%edx
801043f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043fb:	8b 40 04             	mov    0x4(%eax),%eax
801043fe:	89 54 24 08          	mov    %edx,0x8(%esp)
80104402:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104405:	89 54 24 04          	mov    %edx,0x4(%esp)
80104409:	89 04 24             	mov    %eax,(%esp)
8010440c:	e8 b6 3a 00 00       	call   80107ec7 <deallocuvm>
80104411:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104414:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104418:	75 07                	jne    80104421 <growproc+0x85>
      return -1;
8010441a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010441f:	eb 1e                	jmp    8010443f <growproc+0xa3>
  }
  proc->sz = sz;
80104421:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104427:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010442a:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
8010442c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104432:	89 04 24             	mov    %eax,(%esp)
80104435:	e8 d1 36 00 00       	call   80107b0b <switchuvm>
  return 0;
8010443a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010443f:	c9                   	leave  
80104440:	c3                   	ret    

80104441 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104441:	55                   	push   %ebp
80104442:	89 e5                	mov    %esp,%ebp
80104444:	57                   	push   %edi
80104445:	56                   	push   %esi
80104446:	53                   	push   %ebx
80104447:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010444a:	e8 0f fc ff ff       	call   8010405e <allocproc>
8010444f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104452:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80104456:	75 0a                	jne    80104462 <fork+0x21>
    return -1;
80104458:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010445d:	e9 45 01 00 00       	jmp    801045a7 <fork+0x166>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104462:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104468:	8b 10                	mov    (%eax),%edx
8010446a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104470:	8b 40 04             	mov    0x4(%eax),%eax
80104473:	89 54 24 04          	mov    %edx,0x4(%esp)
80104477:	89 04 24             	mov    %eax,(%esp)
8010447a:	e8 d8 3b 00 00       	call   80108057 <copyuvm>
8010447f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104482:	89 42 04             	mov    %eax,0x4(%edx)
80104485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104488:	8b 40 04             	mov    0x4(%eax),%eax
8010448b:	85 c0                	test   %eax,%eax
8010448d:	75 2c                	jne    801044bb <fork+0x7a>
    kfree(np->kstack);
8010448f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104492:	8b 40 08             	mov    0x8(%eax),%eax
80104495:	89 04 24             	mov    %eax,(%esp)
80104498:	e8 00 e6 ff ff       	call   80102a9d <kfree>
    np->kstack = 0;
8010449d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801044a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044aa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801044b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044b6:	e9 ec 00 00 00       	jmp    801045a7 <fork+0x166>
  }
  np->sz = proc->sz;
801044bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044c1:	8b 10                	mov    (%eax),%edx
801044c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044c6:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801044c8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801044cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044d2:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801044d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044d8:	8b 50 18             	mov    0x18(%eax),%edx
801044db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044e1:	8b 40 18             	mov    0x18(%eax),%eax
801044e4:	89 c3                	mov    %eax,%ebx
801044e6:	b8 13 00 00 00       	mov    $0x13,%eax
801044eb:	89 d7                	mov    %edx,%edi
801044ed:	89 de                	mov    %ebx,%esi
801044ef:	89 c1                	mov    %eax,%ecx
801044f1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801044f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044f6:	8b 40 18             	mov    0x18(%eax),%eax
801044f9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104500:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80104507:	eb 3d                	jmp    80104546 <fork+0x105>
    if(proc->ofile[i])
80104509:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010450f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104512:	83 c2 08             	add    $0x8,%edx
80104515:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104519:	85 c0                	test   %eax,%eax
8010451b:	74 25                	je     80104542 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
8010451d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80104520:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104526:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104529:	83 c2 08             	add    $0x8,%edx
8010452c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104530:	89 04 24             	mov    %eax,(%esp)
80104533:	e8 79 ca ff ff       	call   80100fb1 <filedup>
80104538:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010453b:	8d 4b 08             	lea    0x8(%ebx),%ecx
8010453e:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104542:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80104546:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
8010454a:	7e bd                	jle    80104509 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010454c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104552:	8b 40 68             	mov    0x68(%eax),%eax
80104555:	89 04 24             	mov    %eax,(%esp)
80104558:	e8 18 d3 ff ff       	call   80101875 <idup>
8010455d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104560:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
80104563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104566:	8b 40 10             	mov    0x10(%eax),%eax
80104569:	89 45 e0             	mov    %eax,-0x20(%ebp)
  np->state = RUNNABLE;
8010456c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010456f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  ready(np);
80104576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104579:	89 04 24             	mov    %eax,(%esp)
8010457c:	e8 a7 fc ff ff       	call   80104228 <ready>
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104581:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104587:	8d 50 6c             	lea    0x6c(%eax),%edx
8010458a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010458d:	83 c0 6c             	add    $0x6c,%eax
80104590:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104597:	00 
80104598:	89 54 24 04          	mov    %edx,0x4(%esp)
8010459c:	89 04 24             	mov    %eax,(%esp)
8010459f:	e8 b9 0b 00 00       	call   8010515d <safestrcpy>
  return pid;
801045a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
801045a7:	83 c4 2c             	add    $0x2c,%esp
801045aa:	5b                   	pop    %ebx
801045ab:	5e                   	pop    %esi
801045ac:	5f                   	pop    %edi
801045ad:	5d                   	pop    %ebp
801045ae:	c3                   	ret    

801045af <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801045af:	55                   	push   %ebp
801045b0:	89 e5                	mov    %esp,%ebp
801045b2:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801045b5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801045bc:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801045c1:	39 c2                	cmp    %eax,%edx
801045c3:	75 0c                	jne    801045d1 <exit+0x22>
    panic("init exiting");
801045c5:	c7 04 24 8c 85 10 80 	movl   $0x8010858c,(%esp)
801045cc:	e8 69 bf ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801045d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801045d8:	eb 44                	jmp    8010461e <exit+0x6f>
    if(proc->ofile[fd]){
801045da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045e3:	83 c2 08             	add    $0x8,%edx
801045e6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045ea:	85 c0                	test   %eax,%eax
801045ec:	74 2c                	je     8010461a <exit+0x6b>
      fileclose(proc->ofile[fd]);
801045ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045f7:	83 c2 08             	add    $0x8,%edx
801045fa:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045fe:	89 04 24             	mov    %eax,(%esp)
80104601:	e8 f3 c9 ff ff       	call   80100ff9 <fileclose>
      proc->ofile[fd] = 0;
80104606:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010460c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010460f:	83 c2 08             	add    $0x8,%edx
80104612:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104619:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010461a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010461e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104622:	7e b6                	jle    801045da <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
80104624:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010462a:	8b 40 68             	mov    0x68(%eax),%eax
8010462d:	89 04 24             	mov    %eax,(%esp)
80104630:	e8 28 d4 ff ff       	call   80101a5d <iput>
  proc->cwd = 0;
80104635:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010463b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  cprintf("acquire exit");
80104642:	c7 04 24 99 85 10 80 	movl   $0x80108599,(%esp)
80104649:	e8 4c bd ff ff       	call   8010039a <cprintf>
  acquire(&ptable.lock);
8010464e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104655:	e8 81 06 00 00       	call   80104cdb <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
8010465a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104660:	8b 40 14             	mov    0x14(%eax),%eax
80104663:	89 04 24             	mov    %eax,(%esp)
80104666:	e8 1c 04 00 00       	call   80104a87 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010466b:	c7 45 f0 14 00 11 80 	movl   $0x80110014,-0x10(%ebp)
80104672:	eb 3b                	jmp    801046af <exit+0x100>
    if(p->parent == proc){
80104674:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104677:	8b 50 14             	mov    0x14(%eax),%edx
8010467a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104680:	39 c2                	cmp    %eax,%edx
80104682:	75 24                	jne    801046a8 <exit+0xf9>
      p->parent = initproc;
80104684:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
8010468a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010468d:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104690:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104693:	8b 40 0c             	mov    0xc(%eax),%eax
80104696:	83 f8 05             	cmp    $0x5,%eax
80104699:	75 0d                	jne    801046a8 <exit+0xf9>
        wakeup1(initproc);
8010469b:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801046a0:	89 04 24             	mov    %eax,(%esp)
801046a3:	e8 df 03 00 00       	call   80104a87 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a8:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
801046af:	b8 14 22 11 80       	mov    $0x80112214,%eax
801046b4:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801046b7:	72 bb                	jb     80104674 <exit+0xc5>
        wakeup1(initproc);
    }
  }
  
  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801046b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046bf:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801046c6:	e8 03 02 00 00       	call   801048ce <sched>
  panic("zombie exit");
801046cb:	c7 04 24 a6 85 10 80 	movl   $0x801085a6,(%esp)
801046d2:	e8 63 be ff ff       	call   8010053a <panic>

801046d7 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801046d7:	55                   	push   %ebp
801046d8:	89 e5                	mov    %esp,%ebp
801046da:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801046dd:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801046e4:	e8 f2 05 00 00       	call   80104cdb <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801046e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046f0:	c7 45 ec 14 00 11 80 	movl   $0x80110014,-0x14(%ebp)
801046f7:	e9 9d 00 00 00       	jmp    80104799 <wait+0xc2>
      if(p->parent != proc)
801046fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046ff:	8b 50 14             	mov    0x14(%eax),%edx
80104702:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104708:	39 c2                	cmp    %eax,%edx
8010470a:	0f 85 81 00 00 00    	jne    80104791 <wait+0xba>
        continue;
      havekids = 1;
80104710:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104717:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010471a:	8b 40 0c             	mov    0xc(%eax),%eax
8010471d:	83 f8 05             	cmp    $0x5,%eax
80104720:	75 70                	jne    80104792 <wait+0xbb>
        // Found one.
        pid = p->pid;
80104722:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104725:	8b 40 10             	mov    0x10(%eax),%eax
80104728:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kfree(p->kstack);
8010472b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010472e:	8b 40 08             	mov    0x8(%eax),%eax
80104731:	89 04 24             	mov    %eax,(%esp)
80104734:	e8 64 e3 ff ff       	call   80102a9d <kfree>
        p->kstack = 0;
80104739:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010473c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104743:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104746:	8b 40 04             	mov    0x4(%eax),%eax
80104749:	89 04 24             	mov    %eax,(%esp)
8010474c:	e8 32 38 00 00       	call   80107f83 <freevm>
        p->state = UNUSED;
80104751:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104754:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
8010475b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010475e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104765:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104768:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010476f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104772:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104776:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104779:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104780:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104787:	e8 b0 05 00 00       	call   80104d3c <release>
        return pid;
8010478c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478f:	eb 57                	jmp    801047e8 <wait+0x111>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104791:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104792:	81 45 ec 88 00 00 00 	addl   $0x88,-0x14(%ebp)
80104799:	b8 14 22 11 80       	mov    $0x80112214,%eax
8010479e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801047a1:	0f 82 55 ff ff ff    	jb     801046fc <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801047a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801047ab:	74 0d                	je     801047ba <wait+0xe3>
801047ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b3:	8b 40 24             	mov    0x24(%eax),%eax
801047b6:	85 c0                	test   %eax,%eax
801047b8:	74 13                	je     801047cd <wait+0xf6>
      release(&ptable.lock);
801047ba:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801047c1:	e8 76 05 00 00       	call   80104d3c <release>
      return -1;
801047c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047cb:	eb 1b                	jmp    801047e8 <wait+0x111>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801047cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047d3:	c7 44 24 04 e0 ff 10 	movl   $0x8010ffe0,0x4(%esp)
801047da:	80 
801047db:	89 04 24             	mov    %eax,(%esp)
801047de:	e8 09 02 00 00       	call   801049ec <sleep>
  }
801047e3:	e9 01 ff ff ff       	jmp    801046e9 <wait+0x12>
}
801047e8:	c9                   	leave  
801047e9:	c3                   	ret    

801047ea <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801047ea:	55                   	push   %ebp
801047eb:	89 e5                	mov    %esp,%ebp
801047ed:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int i ;
  for(;;){
    // Enable interrupts on this processor.
    sti();
801047f0:	e8 07 f8 ff ff       	call   80103ffc <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801047f5:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801047fc:	e8 da 04 00 00       	call   80104cdb <acquire>
    for(i = 0; i < NPRIORITYS; i++)
80104801:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104808:	e9 a6 00 00 00       	jmp    801048b3 <scheduler+0xc9>
      {
	if((p = ready_q.proc[i]))
8010480d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104810:	83 c0 0c             	add    $0xc,%eax
80104813:	8b 04 85 24 ff 10 80 	mov    -0x7fef00dc(,%eax,4),%eax
8010481a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010481d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80104821:	0f 84 88 00 00 00    	je     801048af <scheduler+0xc5>
	  {
	    struct proc *temp = p->next; 
80104827:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010482a:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104830:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    p->next = 0;
80104833:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104836:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010483d:	00 00 00 
	    if(temp)
80104840:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104844:	74 0a                	je     80104850 <scheduler+0x66>
	      temp->prev = 0;
80104846:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104849:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
	    ready_q.proc[i] = temp; 
80104850:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104853:	8d 50 0c             	lea    0xc(%eax),%edx
80104856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104859:	89 04 95 24 ff 10 80 	mov    %eax,-0x7fef00dc(,%edx,4)


	    //cprintf("process found with pid:%d\n", p->pid);


	    proc = p;
80104860:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104863:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
	    switchuvm(p);
80104869:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010486c:	89 04 24             	mov    %eax,(%esp)
8010486f:	e8 97 32 00 00       	call   80107b0b <switchuvm>
	    p->state = RUNNING;
80104874:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104877:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
	    swtch(&cpu->scheduler, proc->context);
8010487e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104884:	8b 40 1c             	mov    0x1c(%eax),%eax
80104887:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010488e:	83 c2 04             	add    $0x4,%edx
80104891:	89 44 24 04          	mov    %eax,0x4(%esp)
80104895:	89 14 24             	mov    %edx,(%esp)
80104898:	e8 33 09 00 00       	call   801051d0 <swtch>
	    switchkvm();
8010489d:	e8 4c 32 00 00       	call   80107aee <switchkvm>
	    
	    // Process is done running for now.
	    // It should have changed its p->state before coming back.
	    proc = 0;
801048a2:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801048a9:	00 00 00 00 
 
	    break; 
801048ad:	eb 0e                	jmp    801048bd <scheduler+0xd3>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(i = 0; i < NPRIORITYS; i++)
801048af:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801048b3:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
801048b7:	0f 8e 50 ff ff ff    	jle    8010480d <scheduler+0x23>
 
	    break; 
	  }
      }  
  
    release(&ptable.lock);
801048bd:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801048c4:	e8 73 04 00 00       	call   80104d3c <release>
  }
801048c9:	e9 22 ff ff ff       	jmp    801047f0 <scheduler+0x6>

801048ce <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801048ce:	55                   	push   %ebp
801048cf:	89 e5                	mov    %esp,%ebp
801048d1:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
801048d4:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801048db:	e8 1a 05 00 00       	call   80104dfa <holding>
801048e0:	85 c0                	test   %eax,%eax
801048e2:	75 0c                	jne    801048f0 <sched+0x22>
    panic("sched ptable.lock");
801048e4:	c7 04 24 b2 85 10 80 	movl   $0x801085b2,(%esp)
801048eb:	e8 4a bc ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
801048f0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801048f6:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801048fc:	83 f8 01             	cmp    $0x1,%eax
801048ff:	74 0c                	je     8010490d <sched+0x3f>
    panic("sched locks");
80104901:	c7 04 24 c4 85 10 80 	movl   $0x801085c4,(%esp)
80104908:	e8 2d bc ff ff       	call   8010053a <panic>
  if(proc->state == RUNNING)
8010490d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104913:	8b 40 0c             	mov    0xc(%eax),%eax
80104916:	83 f8 04             	cmp    $0x4,%eax
80104919:	75 0c                	jne    80104927 <sched+0x59>
    panic("sched running");
8010491b:	c7 04 24 d0 85 10 80 	movl   $0x801085d0,(%esp)
80104922:	e8 13 bc ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
80104927:	e8 c0 f6 ff ff       	call   80103fec <readeflags>
8010492c:	25 00 02 00 00       	and    $0x200,%eax
80104931:	85 c0                	test   %eax,%eax
80104933:	74 0c                	je     80104941 <sched+0x73>
    panic("sched interruptible");
80104935:	c7 04 24 de 85 10 80 	movl   $0x801085de,(%esp)
8010493c:	e8 f9 bb ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104941:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104947:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010494d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104950:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104956:	8b 40 04             	mov    0x4(%eax),%eax
80104959:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104960:	83 c2 1c             	add    $0x1c,%edx
80104963:	89 44 24 04          	mov    %eax,0x4(%esp)
80104967:	89 14 24             	mov    %edx,(%esp)
8010496a:	e8 61 08 00 00       	call   801051d0 <swtch>
  cpu->intena = intena;
8010496f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104975:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104978:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010497e:	c9                   	leave  
8010497f:	c3                   	ret    

80104980 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	83 ec 18             	sub    $0x18,%esp
  
  acquire(&ptable.lock);  //DOC: yieldlock
80104986:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
8010498d:	e8 49 03 00 00       	call   80104cdb <acquire>
  ready1(proc);  
80104992:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104998:	89 04 24             	mov    %eax,(%esp)
8010499b:	e8 e5 f7 ff ff       	call   80104185 <ready1>
  proc->state = RUNNABLE; 
801049a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801049ad:	e8 1c ff ff ff       	call   801048ce <sched>
  release(&ptable.lock);
801049b2:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801049b9:	e8 7e 03 00 00       	call   80104d3c <release>
}
801049be:	c9                   	leave  
801049bf:	c3                   	ret    

801049c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	83 ec 18             	sub    $0x18,%esp
  release(&ptable.lock);
801049c6:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801049cd:	e8 6a 03 00 00       	call   80104d3c <release>
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  

  if (first) {
801049d2:	a1 20 b0 10 80       	mov    0x8010b020,%eax
801049d7:	85 c0                	test   %eax,%eax
801049d9:	74 0f                	je     801049ea <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801049db:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
801049e2:	00 00 00 
    initlog();
801049e5:	e8 46 e6 ff ff       	call   80103030 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801049ea:	c9                   	leave  
801049eb:	c3                   	ret    

801049ec <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801049ec:	55                   	push   %ebp
801049ed:	89 e5                	mov    %esp,%ebp
801049ef:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
801049f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049f8:	85 c0                	test   %eax,%eax
801049fa:	75 0c                	jne    80104a08 <sleep+0x1c>
    panic("sleep");
801049fc:	c7 04 24 f2 85 10 80 	movl   $0x801085f2,(%esp)
80104a03:	e8 32 bb ff ff       	call   8010053a <panic>

  if(lk == 0)
80104a08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104a0c:	75 0c                	jne    80104a1a <sleep+0x2e>
    panic("sleep without lk");
80104a0e:	c7 04 24 f8 85 10 80 	movl   $0x801085f8,(%esp)
80104a15:	e8 20 bb ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104a1a:	81 7d 0c e0 ff 10 80 	cmpl   $0x8010ffe0,0xc(%ebp)
80104a21:	74 17                	je     80104a3a <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104a23:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104a2a:	e8 ac 02 00 00       	call   80104cdb <acquire>
    release(lk);
80104a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a32:	89 04 24             	mov    %eax,(%esp)
80104a35:	e8 02 03 00 00       	call   80104d3c <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104a3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a40:	8b 55 08             	mov    0x8(%ebp),%edx
80104a43:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104a46:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a4c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104a53:	e8 76 fe ff ff       	call   801048ce <sched>

  // Tidy up.
  proc->chan = 0;
80104a58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a5e:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104a65:	81 7d 0c e0 ff 10 80 	cmpl   $0x8010ffe0,0xc(%ebp)
80104a6c:	74 17                	je     80104a85 <sleep+0x99>
    release(&ptable.lock);
80104a6e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104a75:	e8 c2 02 00 00       	call   80104d3c <release>
    acquire(lk);
80104a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a7d:	89 04 24             	mov    %eax,(%esp)
80104a80:	e8 56 02 00 00       	call   80104cdb <acquire>
  }
}
80104a85:	c9                   	leave  
80104a86:	c3                   	ret    

80104a87 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104a87:	55                   	push   %ebp
80104a88:	89 e5                	mov    %esp,%ebp
80104a8a:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a8d:	c7 45 fc 14 00 11 80 	movl   $0x80110014,-0x4(%ebp)
80104a94:	eb 32                	jmp    80104ac8 <wakeup1+0x41>
    {
      if(p->state == SLEEPING && p->chan == chan)
80104a96:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a99:	8b 40 0c             	mov    0xc(%eax),%eax
80104a9c:	83 f8 02             	cmp    $0x2,%eax
80104a9f:	75 20                	jne    80104ac1 <wakeup1+0x3a>
80104aa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104aa4:	8b 40 20             	mov    0x20(%eax),%eax
80104aa7:	3b 45 08             	cmp    0x8(%ebp),%eax
80104aaa:	75 15                	jne    80104ac1 <wakeup1+0x3a>
	{
	  //cprintf("wakeup\n");
	  p->state = RUNNABLE;
80104aac:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104aaf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
	  ready1(p);
80104ab6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ab9:	89 04 24             	mov    %eax,(%esp)
80104abc:	e8 c4 f6 ff ff       	call   80104185 <ready1>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ac1:	81 45 fc 88 00 00 00 	addl   $0x88,-0x4(%ebp)
80104ac8:	b8 14 22 11 80       	mov    $0x80112214,%eax
80104acd:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80104ad0:	72 c4                	jb     80104a96 <wakeup1+0xf>
	  //cprintf("wakeup\n");
	  p->state = RUNNABLE;
	  ready1(p);
	}
    }
}
80104ad2:	c9                   	leave  
80104ad3:	c3                   	ret    

80104ad4 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104ada:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104ae1:	e8 f5 01 00 00       	call   80104cdb <acquire>
  wakeup1(chan);
80104ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ae9:	89 04 24             	mov    %eax,(%esp)
80104aec:	e8 96 ff ff ff       	call   80104a87 <wakeup1>
  release(&ptable.lock);
80104af1:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104af8:	e8 3f 02 00 00       	call   80104d3c <release>
}
80104afd:	c9                   	leave  
80104afe:	c3                   	ret    

80104aff <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104aff:	55                   	push   %ebp
80104b00:	89 e5                	mov    %esp,%ebp
80104b02:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104b05:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104b0c:	e8 ca 01 00 00       	call   80104cdb <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b11:	c7 45 f4 14 00 11 80 	movl   $0x80110014,-0xc(%ebp)
80104b18:	eb 4f                	jmp    80104b69 <kill+0x6a>
    if(p->pid == pid){
80104b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1d:	8b 40 10             	mov    0x10(%eax),%eax
80104b20:	3b 45 08             	cmp    0x8(%ebp),%eax
80104b23:	75 3d                	jne    80104b62 <kill+0x63>
      p->killed = 1;
80104b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b28:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b32:	8b 40 0c             	mov    0xc(%eax),%eax
80104b35:	83 f8 02             	cmp    $0x2,%eax
80104b38:	75 15                	jne    80104b4f <kill+0x50>
	{
	  p->state = RUNNABLE;
80104b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b3d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
	  ready1(p);
80104b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b47:	89 04 24             	mov    %eax,(%esp)
80104b4a:	e8 36 f6 ff ff       	call   80104185 <ready1>
	}
	release(&ptable.lock);
80104b4f:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104b56:	e8 e1 01 00 00       	call   80104d3c <release>
      return 0;
80104b5b:	b8 00 00 00 00       	mov    $0x0,%eax
80104b60:	eb 22                	jmp    80104b84 <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b62:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104b69:	b8 14 22 11 80       	mov    $0x80112214,%eax
80104b6e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104b71:	72 a7                	jb     80104b1a <kill+0x1b>
	}
	release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104b73:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104b7a:	e8 bd 01 00 00       	call   80104d3c <release>
  return -1;
80104b7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b84:	c9                   	leave  
80104b85:	c3                   	ret    

80104b86 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104b86:	55                   	push   %ebp
80104b87:	89 e5                	mov    %esp,%ebp
80104b89:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b8c:	c7 45 f0 14 00 11 80 	movl   $0x80110014,-0x10(%ebp)
80104b93:	e9 db 00 00 00       	jmp    80104c73 <procdump+0xed>
    if(p->state == UNUSED)
80104b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b9b:	8b 40 0c             	mov    0xc(%eax),%eax
80104b9e:	85 c0                	test   %eax,%eax
80104ba0:	0f 84 c5 00 00 00    	je     80104c6b <procdump+0xe5>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ba9:	8b 40 0c             	mov    0xc(%eax),%eax
80104bac:	83 f8 05             	cmp    $0x5,%eax
80104baf:	77 23                	ja     80104bd4 <procdump+0x4e>
80104bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bb4:	8b 40 0c             	mov    0xc(%eax),%eax
80104bb7:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104bbe:	85 c0                	test   %eax,%eax
80104bc0:	74 12                	je     80104bd4 <procdump+0x4e>
      state = states[p->state];
80104bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bc5:	8b 40 0c             	mov    0xc(%eax),%eax
80104bc8:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104bd2:	eb 07                	jmp    80104bdb <procdump+0x55>
      state = states[p->state];
    else
      state = "???";
80104bd4:	c7 45 f4 09 86 10 80 	movl   $0x80108609,-0xc(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bde:	8d 50 6c             	lea    0x6c(%eax),%edx
80104be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104be4:	8b 40 10             	mov    0x10(%eax),%eax
80104be7:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104beb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bee:	89 54 24 08          	mov    %edx,0x8(%esp)
80104bf2:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bf6:	c7 04 24 0d 86 10 80 	movl   $0x8010860d,(%esp)
80104bfd:	e8 98 b7 ff ff       	call   8010039a <cprintf>
    if(p->state == SLEEPING){
80104c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c05:	8b 40 0c             	mov    0xc(%eax),%eax
80104c08:	83 f8 02             	cmp    $0x2,%eax
80104c0b:	75 50                	jne    80104c5d <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c10:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c13:	8b 40 0c             	mov    0xc(%eax),%eax
80104c16:	83 c0 08             	add    $0x8,%eax
80104c19:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104c1c:	89 54 24 04          	mov    %edx,0x4(%esp)
80104c20:	89 04 24             	mov    %eax,(%esp)
80104c23:	e8 63 01 00 00       	call   80104d8b <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c28:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104c2f:	eb 1b                	jmp    80104c4c <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c34:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c38:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c3c:	c7 04 24 16 86 10 80 	movl   $0x80108616,(%esp)
80104c43:	e8 52 b7 ff ff       	call   8010039a <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104c48:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104c4c:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
80104c50:	7f 0b                	jg     80104c5d <procdump+0xd7>
80104c52:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c55:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c59:	85 c0                	test   %eax,%eax
80104c5b:	75 d4                	jne    80104c31 <procdump+0xab>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104c5d:	c7 04 24 1a 86 10 80 	movl   $0x8010861a,(%esp)
80104c64:	e8 31 b7 ff ff       	call   8010039a <cprintf>
80104c69:	eb 01                	jmp    80104c6c <procdump+0xe6>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104c6b:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c6c:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
80104c73:	b8 14 22 11 80       	mov    $0x80112214,%eax
80104c78:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104c7b:	0f 82 17 ff ff ff    	jb     80104b98 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104c81:	c9                   	leave  
80104c82:	c3                   	ret    
	...

80104c84 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104c84:	55                   	push   %ebp
80104c85:	89 e5                	mov    %esp,%ebp
80104c87:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c8a:	9c                   	pushf  
80104c8b:	58                   	pop    %eax
80104c8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104c8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104c92:	c9                   	leave  
80104c93:	c3                   	ret    

80104c94 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104c97:	fa                   	cli    
}
80104c98:	5d                   	pop    %ebp
80104c99:	c3                   	ret    

80104c9a <sti>:

static inline void
sti(void)
{
80104c9a:	55                   	push   %ebp
80104c9b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104c9d:	fb                   	sti    
}
80104c9e:	5d                   	pop    %ebp
80104c9f:	c3                   	ret    

80104ca0 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104ca6:	8b 55 08             	mov    0x8(%ebp),%edx
80104ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cac:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104caf:	f0 87 02             	lock xchg %eax,(%edx)
80104cb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104cb8:	c9                   	leave  
80104cb9:	c3                   	ret    

80104cba <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104cba:	55                   	push   %ebp
80104cbb:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc0:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cc3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104cc6:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104ccf:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104cd9:	5d                   	pop    %ebp
80104cda:	c3                   	ret    

80104cdb <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104cdb:	55                   	push   %ebp
80104cdc:	89 e5                	mov    %esp,%ebp
80104cde:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104ce1:	e8 3e 01 00 00       	call   80104e24 <pushcli>
  if(holding(lk))
80104ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce9:	89 04 24             	mov    %eax,(%esp)
80104cec:	e8 09 01 00 00       	call   80104dfa <holding>
80104cf1:	85 c0                	test   %eax,%eax
80104cf3:	74 0c                	je     80104d01 <acquire+0x26>
    panic("acquire");
80104cf5:	c7 04 24 46 86 10 80 	movl   $0x80108646,(%esp)
80104cfc:	e8 39 b8 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104d01:	8b 45 08             	mov    0x8(%ebp),%eax
80104d04:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104d0b:	00 
80104d0c:	89 04 24             	mov    %eax,(%esp)
80104d0f:	e8 8c ff ff ff       	call   80104ca0 <xchg>
80104d14:	85 c0                	test   %eax,%eax
80104d16:	75 e9                	jne    80104d01 <acquire+0x26>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104d18:	8b 45 08             	mov    0x8(%ebp),%eax
80104d1b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104d22:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104d25:	8b 45 08             	mov    0x8(%ebp),%eax
80104d28:	83 c0 0c             	add    $0xc,%eax
80104d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d2f:	8d 45 08             	lea    0x8(%ebp),%eax
80104d32:	89 04 24             	mov    %eax,(%esp)
80104d35:	e8 51 00 00 00       	call   80104d8b <getcallerpcs>
}
80104d3a:	c9                   	leave  
80104d3b:	c3                   	ret    

80104d3c <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104d3c:	55                   	push   %ebp
80104d3d:	89 e5                	mov    %esp,%ebp
80104d3f:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104d42:	8b 45 08             	mov    0x8(%ebp),%eax
80104d45:	89 04 24             	mov    %eax,(%esp)
80104d48:	e8 ad 00 00 00       	call   80104dfa <holding>
80104d4d:	85 c0                	test   %eax,%eax
80104d4f:	75 0c                	jne    80104d5d <release+0x21>
    panic("release");
80104d51:	c7 04 24 4e 86 10 80 	movl   $0x8010864e,(%esp)
80104d58:	e8 dd b7 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80104d5d:	8b 45 08             	mov    0x8(%ebp),%eax
80104d60:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104d67:	8b 45 08             	mov    0x8(%ebp),%eax
80104d6a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104d71:	8b 45 08             	mov    0x8(%ebp),%eax
80104d74:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104d7b:	00 
80104d7c:	89 04 24             	mov    %eax,(%esp)
80104d7f:	e8 1c ff ff ff       	call   80104ca0 <xchg>

  popcli();
80104d84:	e8 e3 00 00 00       	call   80104e6c <popcli>
}
80104d89:	c9                   	leave  
80104d8a:	c3                   	ret    

80104d8b <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d8b:	55                   	push   %ebp
80104d8c:	89 e5                	mov    %esp,%ebp
80104d8e:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104d91:	8b 45 08             	mov    0x8(%ebp),%eax
80104d94:	83 e8 08             	sub    $0x8,%eax
80104d97:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(i = 0; i < 10; i++){
80104d9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104da1:	eb 34                	jmp    80104dd7 <getcallerpcs+0x4c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104da3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
80104da7:	74 49                	je     80104df2 <getcallerpcs+0x67>
80104da9:	81 7d f8 ff ff ff 7f 	cmpl   $0x7fffffff,-0x8(%ebp)
80104db0:	76 40                	jbe    80104df2 <getcallerpcs+0x67>
80104db2:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%ebp)
80104db6:	74 3a                	je     80104df2 <getcallerpcs+0x67>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104db8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dbb:	c1 e0 02             	shl    $0x2,%eax
80104dbe:	03 45 0c             	add    0xc(%ebp),%eax
80104dc1:	8b 55 f8             	mov    -0x8(%ebp),%edx
80104dc4:	83 c2 04             	add    $0x4,%edx
80104dc7:	8b 12                	mov    (%edx),%edx
80104dc9:	89 10                	mov    %edx,(%eax)
    ebp = (uint*)ebp[0]; // saved %ebp
80104dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104dce:	8b 00                	mov    (%eax),%eax
80104dd0:	89 45 f8             	mov    %eax,-0x8(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104dd3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104dd7:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
80104ddb:	7e c6                	jle    80104da3 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ddd:	eb 13                	jmp    80104df2 <getcallerpcs+0x67>
    pcs[i] = 0;
80104ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104de2:	c1 e0 02             	shl    $0x2,%eax
80104de5:	03 45 0c             	add    0xc(%ebp),%eax
80104de8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104dee:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104df2:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
80104df6:	7e e7                	jle    80104ddf <getcallerpcs+0x54>
    pcs[i] = 0;
}
80104df8:	c9                   	leave  
80104df9:	c3                   	ret    

80104dfa <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104dfa:	55                   	push   %ebp
80104dfb:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80104e00:	8b 00                	mov    (%eax),%eax
80104e02:	85 c0                	test   %eax,%eax
80104e04:	74 17                	je     80104e1d <holding+0x23>
80104e06:	8b 45 08             	mov    0x8(%ebp),%eax
80104e09:	8b 50 08             	mov    0x8(%eax),%edx
80104e0c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e12:	39 c2                	cmp    %eax,%edx
80104e14:	75 07                	jne    80104e1d <holding+0x23>
80104e16:	b8 01 00 00 00       	mov    $0x1,%eax
80104e1b:	eb 05                	jmp    80104e22 <holding+0x28>
80104e1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e22:	5d                   	pop    %ebp
80104e23:	c3                   	ret    

80104e24 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104e2a:	e8 55 fe ff ff       	call   80104c84 <readeflags>
80104e2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104e32:	e8 5d fe ff ff       	call   80104c94 <cli>
  if(cpu->ncli++ == 0)
80104e37:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e3d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104e43:	85 d2                	test   %edx,%edx
80104e45:	0f 94 c1             	sete   %cl
80104e48:	83 c2 01             	add    $0x1,%edx
80104e4b:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104e51:	84 c9                	test   %cl,%cl
80104e53:	74 15                	je     80104e6a <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
80104e55:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e5e:	81 e2 00 02 00 00    	and    $0x200,%edx
80104e64:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104e6a:	c9                   	leave  
80104e6b:	c3                   	ret    

80104e6c <popcli>:

void
popcli(void)
{
80104e6c:	55                   	push   %ebp
80104e6d:	89 e5                	mov    %esp,%ebp
80104e6f:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104e72:	e8 0d fe ff ff       	call   80104c84 <readeflags>
80104e77:	25 00 02 00 00       	and    $0x200,%eax
80104e7c:	85 c0                	test   %eax,%eax
80104e7e:	74 0c                	je     80104e8c <popcli+0x20>
    panic("popcli - interruptible");
80104e80:	c7 04 24 56 86 10 80 	movl   $0x80108656,(%esp)
80104e87:	e8 ae b6 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80104e8c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e92:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104e98:	83 ea 01             	sub    $0x1,%edx
80104e9b:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104ea1:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104ea7:	85 c0                	test   %eax,%eax
80104ea9:	79 0c                	jns    80104eb7 <popcli+0x4b>
    panic("popcli");
80104eab:	c7 04 24 6d 86 10 80 	movl   $0x8010866d,(%esp)
80104eb2:	e8 83 b6 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104eb7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ebd:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104ec3:	85 c0                	test   %eax,%eax
80104ec5:	75 15                	jne    80104edc <popcli+0x70>
80104ec7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ecd:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104ed3:	85 c0                	test   %eax,%eax
80104ed5:	74 05                	je     80104edc <popcli+0x70>
    sti();
80104ed7:	e8 be fd ff ff       	call   80104c9a <sti>
}
80104edc:	c9                   	leave  
80104edd:	c3                   	ret    
	...

80104ee0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	57                   	push   %edi
80104ee4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104ee5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ee8:	8b 55 10             	mov    0x10(%ebp),%edx
80104eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eee:	89 cb                	mov    %ecx,%ebx
80104ef0:	89 df                	mov    %ebx,%edi
80104ef2:	89 d1                	mov    %edx,%ecx
80104ef4:	fc                   	cld    
80104ef5:	f3 aa                	rep stos %al,%es:(%edi)
80104ef7:	89 ca                	mov    %ecx,%edx
80104ef9:	89 fb                	mov    %edi,%ebx
80104efb:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104efe:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104f01:	5b                   	pop    %ebx
80104f02:	5f                   	pop    %edi
80104f03:	5d                   	pop    %ebp
80104f04:	c3                   	ret    

80104f05 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80104f05:	55                   	push   %ebp
80104f06:	89 e5                	mov    %esp,%ebp
80104f08:	57                   	push   %edi
80104f09:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104f0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f0d:	8b 55 10             	mov    0x10(%ebp),%edx
80104f10:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f13:	89 cb                	mov    %ecx,%ebx
80104f15:	89 df                	mov    %ebx,%edi
80104f17:	89 d1                	mov    %edx,%ecx
80104f19:	fc                   	cld    
80104f1a:	f3 ab                	rep stos %eax,%es:(%edi)
80104f1c:	89 ca                	mov    %ecx,%edx
80104f1e:	89 fb                	mov    %edi,%ebx
80104f20:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104f23:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104f26:	5b                   	pop    %ebx
80104f27:	5f                   	pop    %edi
80104f28:	5d                   	pop    %ebp
80104f29:	c3                   	ret    

80104f2a <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f2a:	55                   	push   %ebp
80104f2b:	89 e5                	mov    %esp,%ebp
80104f2d:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80104f30:	8b 45 08             	mov    0x8(%ebp),%eax
80104f33:	83 e0 03             	and    $0x3,%eax
80104f36:	85 c0                	test   %eax,%eax
80104f38:	75 49                	jne    80104f83 <memset+0x59>
80104f3a:	8b 45 10             	mov    0x10(%ebp),%eax
80104f3d:	83 e0 03             	and    $0x3,%eax
80104f40:	85 c0                	test   %eax,%eax
80104f42:	75 3f                	jne    80104f83 <memset+0x59>
    c &= 0xFF;
80104f44:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f4b:	8b 45 10             	mov    0x10(%ebp),%eax
80104f4e:	c1 e8 02             	shr    $0x2,%eax
80104f51:	89 c2                	mov    %eax,%edx
80104f53:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f56:	89 c1                	mov    %eax,%ecx
80104f58:	c1 e1 18             	shl    $0x18,%ecx
80104f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f5e:	c1 e0 10             	shl    $0x10,%eax
80104f61:	09 c1                	or     %eax,%ecx
80104f63:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f66:	c1 e0 08             	shl    $0x8,%eax
80104f69:	09 c8                	or     %ecx,%eax
80104f6b:	0b 45 0c             	or     0xc(%ebp),%eax
80104f6e:	89 54 24 08          	mov    %edx,0x8(%esp)
80104f72:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f76:	8b 45 08             	mov    0x8(%ebp),%eax
80104f79:	89 04 24             	mov    %eax,(%esp)
80104f7c:	e8 84 ff ff ff       	call   80104f05 <stosl>
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
80104f81:	eb 19                	jmp    80104f9c <memset+0x72>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
80104f83:	8b 45 10             	mov    0x10(%ebp),%eax
80104f86:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f91:	8b 45 08             	mov    0x8(%ebp),%eax
80104f94:	89 04 24             	mov    %eax,(%esp)
80104f97:	e8 44 ff ff ff       	call   80104ee0 <stosb>
  return dst;
80104f9c:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104f9f:	c9                   	leave  
80104fa0:	c3                   	ret    

80104fa1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104fa1:	55                   	push   %ebp
80104fa2:	89 e5                	mov    %esp,%ebp
80104fa4:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80104fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80104faa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  s2 = v2;
80104fad:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0){
80104fb3:	eb 32                	jmp    80104fe7 <memcmp+0x46>
    if(*s1 != *s2)
80104fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fb8:	0f b6 10             	movzbl (%eax),%edx
80104fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fbe:	0f b6 00             	movzbl (%eax),%eax
80104fc1:	38 c2                	cmp    %al,%dl
80104fc3:	74 1a                	je     80104fdf <memcmp+0x3e>
      return *s1 - *s2;
80104fc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fc8:	0f b6 00             	movzbl (%eax),%eax
80104fcb:	0f b6 d0             	movzbl %al,%edx
80104fce:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fd1:	0f b6 00             	movzbl (%eax),%eax
80104fd4:	0f b6 c0             	movzbl %al,%eax
80104fd7:	89 d1                	mov    %edx,%ecx
80104fd9:	29 c1                	sub    %eax,%ecx
80104fdb:	89 c8                	mov    %ecx,%eax
80104fdd:	eb 1c                	jmp    80104ffb <memcmp+0x5a>
    s1++, s2++;
80104fdf:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104fe3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104fe7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104feb:	0f 95 c0             	setne  %al
80104fee:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104ff2:	84 c0                	test   %al,%al
80104ff4:	75 bf                	jne    80104fb5 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104ff6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ffb:	c9                   	leave  
80104ffc:	c3                   	ret    

80104ffd <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ffd:	55                   	push   %ebp
80104ffe:	89 e5                	mov    %esp,%ebp
80105000:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105003:	8b 45 0c             	mov    0xc(%ebp),%eax
80105006:	89 45 f8             	mov    %eax,-0x8(%ebp)
  d = dst;
80105009:	8b 45 08             	mov    0x8(%ebp),%eax
8010500c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(s < d && s + n > d){
8010500f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105012:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105015:	73 55                	jae    8010506c <memmove+0x6f>
80105017:	8b 45 10             	mov    0x10(%ebp),%eax
8010501a:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010501d:	8d 04 02             	lea    (%edx,%eax,1),%eax
80105020:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105023:	76 4a                	jbe    8010506f <memmove+0x72>
    s += n;
80105025:	8b 45 10             	mov    0x10(%ebp),%eax
80105028:	01 45 f8             	add    %eax,-0x8(%ebp)
    d += n;
8010502b:	8b 45 10             	mov    0x10(%ebp),%eax
8010502e:	01 45 fc             	add    %eax,-0x4(%ebp)
    while(n-- > 0)
80105031:	eb 13                	jmp    80105046 <memmove+0x49>
      *--d = *--s;
80105033:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105037:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010503b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010503e:	0f b6 10             	movzbl (%eax),%edx
80105041:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105044:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105046:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010504a:	0f 95 c0             	setne  %al
8010504d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105051:	84 c0                	test   %al,%al
80105053:	75 de                	jne    80105033 <memmove+0x36>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105055:	eb 28                	jmp    8010507f <memmove+0x82>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105057:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010505a:	0f b6 10             	movzbl (%eax),%edx
8010505d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105060:	88 10                	mov    %dl,(%eax)
80105062:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105066:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010506a:	eb 04                	jmp    80105070 <memmove+0x73>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010506c:	90                   	nop
8010506d:	eb 01                	jmp    80105070 <memmove+0x73>
8010506f:	90                   	nop
80105070:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105074:	0f 95 c0             	setne  %al
80105077:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010507b:	84 c0                	test   %al,%al
8010507d:	75 d8                	jne    80105057 <memmove+0x5a>
      *d++ = *s++;

  return dst;
8010507f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105082:	c9                   	leave  
80105083:	c3                   	ret    

80105084 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105084:	55                   	push   %ebp
80105085:	89 e5                	mov    %esp,%ebp
80105087:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
8010508a:	8b 45 10             	mov    0x10(%ebp),%eax
8010508d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105091:	8b 45 0c             	mov    0xc(%ebp),%eax
80105094:	89 44 24 04          	mov    %eax,0x4(%esp)
80105098:	8b 45 08             	mov    0x8(%ebp),%eax
8010509b:	89 04 24             	mov    %eax,(%esp)
8010509e:	e8 5a ff ff ff       	call   80104ffd <memmove>
}
801050a3:	c9                   	leave  
801050a4:	c3                   	ret    

801050a5 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801050a5:	55                   	push   %ebp
801050a6:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801050a8:	eb 0c                	jmp    801050b6 <strncmp+0x11>
    n--, p++, q++;
801050aa:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801050ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801050b2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801050b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050ba:	74 1a                	je     801050d6 <strncmp+0x31>
801050bc:	8b 45 08             	mov    0x8(%ebp),%eax
801050bf:	0f b6 00             	movzbl (%eax),%eax
801050c2:	84 c0                	test   %al,%al
801050c4:	74 10                	je     801050d6 <strncmp+0x31>
801050c6:	8b 45 08             	mov    0x8(%ebp),%eax
801050c9:	0f b6 10             	movzbl (%eax),%edx
801050cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801050cf:	0f b6 00             	movzbl (%eax),%eax
801050d2:	38 c2                	cmp    %al,%dl
801050d4:	74 d4                	je     801050aa <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801050d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050da:	75 07                	jne    801050e3 <strncmp+0x3e>
    return 0;
801050dc:	b8 00 00 00 00       	mov    $0x0,%eax
801050e1:	eb 18                	jmp    801050fb <strncmp+0x56>
  return (uchar)*p - (uchar)*q;
801050e3:	8b 45 08             	mov    0x8(%ebp),%eax
801050e6:	0f b6 00             	movzbl (%eax),%eax
801050e9:	0f b6 d0             	movzbl %al,%edx
801050ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ef:	0f b6 00             	movzbl (%eax),%eax
801050f2:	0f b6 c0             	movzbl %al,%eax
801050f5:	89 d1                	mov    %edx,%ecx
801050f7:	29 c1                	sub    %eax,%ecx
801050f9:	89 c8                	mov    %ecx,%eax
}
801050fb:	5d                   	pop    %ebp
801050fc:	c3                   	ret    

801050fd <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801050fd:	55                   	push   %ebp
801050fe:	89 e5                	mov    %esp,%ebp
80105100:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105103:	8b 45 08             	mov    0x8(%ebp),%eax
80105106:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105109:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010510d:	0f 9f c0             	setg   %al
80105110:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105114:	84 c0                	test   %al,%al
80105116:	74 30                	je     80105148 <strncpy+0x4b>
80105118:	8b 45 0c             	mov    0xc(%ebp),%eax
8010511b:	0f b6 10             	movzbl (%eax),%edx
8010511e:	8b 45 08             	mov    0x8(%ebp),%eax
80105121:	88 10                	mov    %dl,(%eax)
80105123:	8b 45 08             	mov    0x8(%ebp),%eax
80105126:	0f b6 00             	movzbl (%eax),%eax
80105129:	84 c0                	test   %al,%al
8010512b:	0f 95 c0             	setne  %al
8010512e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105132:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105136:	84 c0                	test   %al,%al
80105138:	75 cf                	jne    80105109 <strncpy+0xc>
    ;
  while(n-- > 0)
8010513a:	eb 0d                	jmp    80105149 <strncpy+0x4c>
    *s++ = 0;
8010513c:	8b 45 08             	mov    0x8(%ebp),%eax
8010513f:	c6 00 00             	movb   $0x0,(%eax)
80105142:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105146:	eb 01                	jmp    80105149 <strncpy+0x4c>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105148:	90                   	nop
80105149:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010514d:	0f 9f c0             	setg   %al
80105150:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105154:	84 c0                	test   %al,%al
80105156:	75 e4                	jne    8010513c <strncpy+0x3f>
    *s++ = 0;
  return os;
80105158:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010515b:	c9                   	leave  
8010515c:	c3                   	ret    

8010515d <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010515d:	55                   	push   %ebp
8010515e:	89 e5                	mov    %esp,%ebp
80105160:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105163:	8b 45 08             	mov    0x8(%ebp),%eax
80105166:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105169:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010516d:	7f 05                	jg     80105174 <safestrcpy+0x17>
    return os;
8010516f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105172:	eb 35                	jmp    801051a9 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
80105174:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105178:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010517c:	7e 22                	jle    801051a0 <safestrcpy+0x43>
8010517e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105181:	0f b6 10             	movzbl (%eax),%edx
80105184:	8b 45 08             	mov    0x8(%ebp),%eax
80105187:	88 10                	mov    %dl,(%eax)
80105189:	8b 45 08             	mov    0x8(%ebp),%eax
8010518c:	0f b6 00             	movzbl (%eax),%eax
8010518f:	84 c0                	test   %al,%al
80105191:	0f 95 c0             	setne  %al
80105194:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105198:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010519c:	84 c0                	test   %al,%al
8010519e:	75 d4                	jne    80105174 <safestrcpy+0x17>
    ;
  *s = 0;
801051a0:	8b 45 08             	mov    0x8(%ebp),%eax
801051a3:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801051a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801051a9:	c9                   	leave  
801051aa:	c3                   	ret    

801051ab <strlen>:

int
strlen(const char *s)
{
801051ab:	55                   	push   %ebp
801051ac:	89 e5                	mov    %esp,%ebp
801051ae:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801051b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801051b8:	eb 04                	jmp    801051be <strlen+0x13>
801051ba:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801051be:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051c1:	03 45 08             	add    0x8(%ebp),%eax
801051c4:	0f b6 00             	movzbl (%eax),%eax
801051c7:	84 c0                	test   %al,%al
801051c9:	75 ef                	jne    801051ba <strlen+0xf>
    ;
  return n;
801051cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801051ce:	c9                   	leave  
801051cf:	c3                   	ret    

801051d0 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801051d0:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801051d4:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801051d8:	55                   	push   %ebp
  pushl %ebx
801051d9:	53                   	push   %ebx
  pushl %esi
801051da:	56                   	push   %esi
  pushl %edi
801051db:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801051dc:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801051de:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801051e0:	5f                   	pop    %edi
  popl %esi
801051e1:	5e                   	pop    %esi
  popl %ebx
801051e2:	5b                   	pop    %ebx
  popl %ebp
801051e3:	5d                   	pop    %ebp
  ret
801051e4:	c3                   	ret    
801051e5:	00 00                	add    %al,(%eax)
	...

801051e8 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801051e8:	55                   	push   %ebp
801051e9:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801051eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051f1:	8b 00                	mov    (%eax),%eax
801051f3:	3b 45 08             	cmp    0x8(%ebp),%eax
801051f6:	76 12                	jbe    8010520a <fetchint+0x22>
801051f8:	8b 45 08             	mov    0x8(%ebp),%eax
801051fb:	8d 50 04             	lea    0x4(%eax),%edx
801051fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105204:	8b 00                	mov    (%eax),%eax
80105206:	39 c2                	cmp    %eax,%edx
80105208:	76 07                	jbe    80105211 <fetchint+0x29>
    return -1;
8010520a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520f:	eb 0f                	jmp    80105220 <fetchint+0x38>
  *ip = *(int*)(addr);
80105211:	8b 45 08             	mov    0x8(%ebp),%eax
80105214:	8b 10                	mov    (%eax),%edx
80105216:	8b 45 0c             	mov    0xc(%ebp),%eax
80105219:	89 10                	mov    %edx,(%eax)
  return 0;
8010521b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105220:	5d                   	pop    %ebp
80105221:	c3                   	ret    

80105222 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105222:	55                   	push   %ebp
80105223:	89 e5                	mov    %esp,%ebp
80105225:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105228:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010522e:	8b 00                	mov    (%eax),%eax
80105230:	3b 45 08             	cmp    0x8(%ebp),%eax
80105233:	77 07                	ja     8010523c <fetchstr+0x1a>
    return -1;
80105235:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010523a:	eb 48                	jmp    80105284 <fetchstr+0x62>
  *pp = (char*)addr;
8010523c:	8b 55 08             	mov    0x8(%ebp),%edx
8010523f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105242:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105244:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010524a:	8b 00                	mov    (%eax),%eax
8010524c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(s = *pp; s < ep; s++)
8010524f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105252:	8b 00                	mov    (%eax),%eax
80105254:	89 45 f8             	mov    %eax,-0x8(%ebp)
80105257:	eb 1e                	jmp    80105277 <fetchstr+0x55>
    if(*s == 0)
80105259:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010525c:	0f b6 00             	movzbl (%eax),%eax
8010525f:	84 c0                	test   %al,%al
80105261:	75 10                	jne    80105273 <fetchstr+0x51>
      return s - *pp;
80105263:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105266:	8b 45 0c             	mov    0xc(%ebp),%eax
80105269:	8b 00                	mov    (%eax),%eax
8010526b:	89 d1                	mov    %edx,%ecx
8010526d:	29 c1                	sub    %eax,%ecx
8010526f:	89 c8                	mov    %ecx,%eax
80105271:	eb 11                	jmp    80105284 <fetchstr+0x62>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105273:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105277:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010527a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
8010527d:	72 da                	jb     80105259 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
8010527f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105284:	c9                   	leave  
80105285:	c3                   	ret    

80105286 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105286:	55                   	push   %ebp
80105287:	89 e5                	mov    %esp,%ebp
80105289:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010528c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105292:	8b 40 18             	mov    0x18(%eax),%eax
80105295:	8b 50 44             	mov    0x44(%eax),%edx
80105298:	8b 45 08             	mov    0x8(%ebp),%eax
8010529b:	c1 e0 02             	shl    $0x2,%eax
8010529e:	8d 04 02             	lea    (%edx,%eax,1),%eax
801052a1:	8d 50 04             	lea    0x4(%eax),%edx
801052a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801052a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ab:	89 14 24             	mov    %edx,(%esp)
801052ae:	e8 35 ff ff ff       	call   801051e8 <fetchint>
}
801052b3:	c9                   	leave  
801052b4:	c3                   	ret    

801052b5 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801052b5:	55                   	push   %ebp
801052b6:	89 e5                	mov    %esp,%ebp
801052b8:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
801052bb:	8d 45 fc             	lea    -0x4(%ebp),%eax
801052be:	89 44 24 04          	mov    %eax,0x4(%esp)
801052c2:	8b 45 08             	mov    0x8(%ebp),%eax
801052c5:	89 04 24             	mov    %eax,(%esp)
801052c8:	e8 b9 ff ff ff       	call   80105286 <argint>
801052cd:	85 c0                	test   %eax,%eax
801052cf:	79 07                	jns    801052d8 <argptr+0x23>
    return -1;
801052d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052d6:	eb 3d                	jmp    80105315 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801052d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052db:	89 c2                	mov    %eax,%edx
801052dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052e3:	8b 00                	mov    (%eax),%eax
801052e5:	39 c2                	cmp    %eax,%edx
801052e7:	73 16                	jae    801052ff <argptr+0x4a>
801052e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052ec:	89 c2                	mov    %eax,%edx
801052ee:	8b 45 10             	mov    0x10(%ebp),%eax
801052f1:	01 c2                	add    %eax,%edx
801052f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052f9:	8b 00                	mov    (%eax),%eax
801052fb:	39 c2                	cmp    %eax,%edx
801052fd:	76 07                	jbe    80105306 <argptr+0x51>
    return -1;
801052ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105304:	eb 0f                	jmp    80105315 <argptr+0x60>
  *pp = (char*)i;
80105306:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105309:	89 c2                	mov    %eax,%edx
8010530b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010530e:	89 10                	mov    %edx,(%eax)
  return 0;
80105310:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105315:	c9                   	leave  
80105316:	c3                   	ret    

80105317 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105317:	55                   	push   %ebp
80105318:	89 e5                	mov    %esp,%ebp
8010531a:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010531d:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105320:	89 44 24 04          	mov    %eax,0x4(%esp)
80105324:	8b 45 08             	mov    0x8(%ebp),%eax
80105327:	89 04 24             	mov    %eax,(%esp)
8010532a:	e8 57 ff ff ff       	call   80105286 <argint>
8010532f:	85 c0                	test   %eax,%eax
80105331:	79 07                	jns    8010533a <argstr+0x23>
    return -1;
80105333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105338:	eb 12                	jmp    8010534c <argstr+0x35>
  return fetchstr(addr, pp);
8010533a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010533d:	8b 55 0c             	mov    0xc(%ebp),%edx
80105340:	89 54 24 04          	mov    %edx,0x4(%esp)
80105344:	89 04 24             	mov    %eax,(%esp)
80105347:	e8 d6 fe ff ff       	call   80105222 <fetchstr>
}
8010534c:	c9                   	leave  
8010534d:	c3                   	ret    

8010534e <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
8010534e:	55                   	push   %ebp
8010534f:	89 e5                	mov    %esp,%ebp
80105351:	53                   	push   %ebx
80105352:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105355:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010535b:	8b 40 18             	mov    0x18(%eax),%eax
8010535e:	8b 40 1c             	mov    0x1c(%eax),%eax
80105361:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105368:	7e 30                	jle    8010539a <syscall+0x4c>
8010536a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010536d:	83 f8 15             	cmp    $0x15,%eax
80105370:	77 28                	ja     8010539a <syscall+0x4c>
80105372:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105375:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010537c:	85 c0                	test   %eax,%eax
8010537e:	74 1a                	je     8010539a <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105380:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105386:	8b 58 18             	mov    0x18(%eax),%ebx
80105389:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010538c:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105393:	ff d0                	call   *%eax
80105395:	89 43 1c             	mov    %eax,0x1c(%ebx)
syscall(void)
{
  int num;

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105398:	eb 3d                	jmp    801053d7 <syscall+0x89>
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
8010539a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801053a0:	8d 48 6c             	lea    0x6c(%eax),%ecx
            proc->pid, proc->name, num);
801053a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801053a9:	8b 40 10             	mov    0x10(%eax),%eax
801053ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053af:	89 54 24 0c          	mov    %edx,0xc(%esp)
801053b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801053b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801053bb:	c7 04 24 74 86 10 80 	movl   $0x80108674,(%esp)
801053c2:	e8 d3 af ff ff       	call   8010039a <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801053c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053cd:	8b 40 18             	mov    0x18(%eax),%eax
801053d0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801053d7:	83 c4 24             	add    $0x24,%esp
801053da:	5b                   	pop    %ebx
801053db:	5d                   	pop    %ebp
801053dc:	c3                   	ret    
801053dd:	00 00                	add    %al,(%eax)
	...

801053e0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801053e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801053ed:	8b 45 08             	mov    0x8(%ebp),%eax
801053f0:	89 04 24             	mov    %eax,(%esp)
801053f3:	e8 8e fe ff ff       	call   80105286 <argint>
801053f8:	85 c0                	test   %eax,%eax
801053fa:	79 07                	jns    80105403 <argfd+0x23>
    return -1;
801053fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105401:	eb 50                	jmp    80105453 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105403:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105406:	85 c0                	test   %eax,%eax
80105408:	78 21                	js     8010542b <argfd+0x4b>
8010540a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010540d:	83 f8 0f             	cmp    $0xf,%eax
80105410:	7f 19                	jg     8010542b <argfd+0x4b>
80105412:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105418:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010541b:	83 c2 08             	add    $0x8,%edx
8010541e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105422:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105429:	75 07                	jne    80105432 <argfd+0x52>
    return -1;
8010542b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105430:	eb 21                	jmp    80105453 <argfd+0x73>
  if(pfd)
80105432:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105436:	74 08                	je     80105440 <argfd+0x60>
    *pfd = fd;
80105438:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010543b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010543e:	89 10                	mov    %edx,(%eax)
  if(pf)
80105440:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105444:	74 08                	je     8010544e <argfd+0x6e>
    *pf = f;
80105446:	8b 45 10             	mov    0x10(%ebp),%eax
80105449:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010544c:	89 10                	mov    %edx,(%eax)
  return 0;
8010544e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105453:	c9                   	leave  
80105454:	c3                   	ret    

80105455 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105455:	55                   	push   %ebp
80105456:	89 e5                	mov    %esp,%ebp
80105458:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010545b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105462:	eb 30                	jmp    80105494 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105464:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010546a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010546d:	83 c2 08             	add    $0x8,%edx
80105470:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105474:	85 c0                	test   %eax,%eax
80105476:	75 18                	jne    80105490 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105478:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010547e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105481:	8d 4a 08             	lea    0x8(%edx),%ecx
80105484:	8b 55 08             	mov    0x8(%ebp),%edx
80105487:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010548b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010548e:	eb 0f                	jmp    8010549f <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105490:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105494:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105498:	7e ca                	jle    80105464 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010549a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010549f:	c9                   	leave  
801054a0:	c3                   	ret    

801054a1 <sys_dup>:

int
sys_dup(void)
{
801054a1:	55                   	push   %ebp
801054a2:	89 e5                	mov    %esp,%ebp
801054a4:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801054a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054aa:	89 44 24 08          	mov    %eax,0x8(%esp)
801054ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801054b5:	00 
801054b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054bd:	e8 1e ff ff ff       	call   801053e0 <argfd>
801054c2:	85 c0                	test   %eax,%eax
801054c4:	79 07                	jns    801054cd <sys_dup+0x2c>
    return -1;
801054c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054cb:	eb 29                	jmp    801054f6 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801054cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054d0:	89 04 24             	mov    %eax,(%esp)
801054d3:	e8 7d ff ff ff       	call   80105455 <fdalloc>
801054d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801054db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054df:	79 07                	jns    801054e8 <sys_dup+0x47>
    return -1;
801054e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e6:	eb 0e                	jmp    801054f6 <sys_dup+0x55>
  filedup(f);
801054e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054eb:	89 04 24             	mov    %eax,(%esp)
801054ee:	e8 be ba ff ff       	call   80100fb1 <filedup>
  return fd;
801054f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801054f6:	c9                   	leave  
801054f7:	c3                   	ret    

801054f8 <sys_read>:

int
sys_read(void)
{
801054f8:	55                   	push   %ebp
801054f9:	89 e5                	mov    %esp,%ebp
801054fb:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105501:	89 44 24 08          	mov    %eax,0x8(%esp)
80105505:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010550c:	00 
8010550d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105514:	e8 c7 fe ff ff       	call   801053e0 <argfd>
80105519:	85 c0                	test   %eax,%eax
8010551b:	78 35                	js     80105552 <sys_read+0x5a>
8010551d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105520:	89 44 24 04          	mov    %eax,0x4(%esp)
80105524:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010552b:	e8 56 fd ff ff       	call   80105286 <argint>
80105530:	85 c0                	test   %eax,%eax
80105532:	78 1e                	js     80105552 <sys_read+0x5a>
80105534:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105537:	89 44 24 08          	mov    %eax,0x8(%esp)
8010553b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010553e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105542:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105549:	e8 67 fd ff ff       	call   801052b5 <argptr>
8010554e:	85 c0                	test   %eax,%eax
80105550:	79 07                	jns    80105559 <sys_read+0x61>
    return -1;
80105552:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105557:	eb 19                	jmp    80105572 <sys_read+0x7a>
  return fileread(f, p, n);
80105559:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010555c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010555f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105562:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105566:	89 54 24 04          	mov    %edx,0x4(%esp)
8010556a:	89 04 24             	mov    %eax,(%esp)
8010556d:	e8 ac bb ff ff       	call   8010111e <fileread>
}
80105572:	c9                   	leave  
80105573:	c3                   	ret    

80105574 <sys_write>:

int
sys_write(void)
{
80105574:	55                   	push   %ebp
80105575:	89 e5                	mov    %esp,%ebp
80105577:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010557a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010557d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105581:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105588:	00 
80105589:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105590:	e8 4b fe ff ff       	call   801053e0 <argfd>
80105595:	85 c0                	test   %eax,%eax
80105597:	78 35                	js     801055ce <sys_write+0x5a>
80105599:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010559c:	89 44 24 04          	mov    %eax,0x4(%esp)
801055a0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801055a7:	e8 da fc ff ff       	call   80105286 <argint>
801055ac:	85 c0                	test   %eax,%eax
801055ae:	78 1e                	js     801055ce <sys_write+0x5a>
801055b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055b3:	89 44 24 08          	mov    %eax,0x8(%esp)
801055b7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801055be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801055c5:	e8 eb fc ff ff       	call   801052b5 <argptr>
801055ca:	85 c0                	test   %eax,%eax
801055cc:	79 07                	jns    801055d5 <sys_write+0x61>
    return -1;
801055ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d3:	eb 19                	jmp    801055ee <sys_write+0x7a>
  return filewrite(f, p, n);
801055d5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801055d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801055db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055de:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801055e2:	89 54 24 04          	mov    %edx,0x4(%esp)
801055e6:	89 04 24             	mov    %eax,(%esp)
801055e9:	e8 ec bb ff ff       	call   801011da <filewrite>
}
801055ee:	c9                   	leave  
801055ef:	c3                   	ret    

801055f0 <sys_close>:

int
sys_close(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801055f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055f9:	89 44 24 08          	mov    %eax,0x8(%esp)
801055fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105600:	89 44 24 04          	mov    %eax,0x4(%esp)
80105604:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010560b:	e8 d0 fd ff ff       	call   801053e0 <argfd>
80105610:	85 c0                	test   %eax,%eax
80105612:	79 07                	jns    8010561b <sys_close+0x2b>
    return -1;
80105614:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105619:	eb 24                	jmp    8010563f <sys_close+0x4f>
  proc->ofile[fd] = 0;
8010561b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105621:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105624:	83 c2 08             	add    $0x8,%edx
80105627:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010562e:	00 
  fileclose(f);
8010562f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105632:	89 04 24             	mov    %eax,(%esp)
80105635:	e8 bf b9 ff ff       	call   80100ff9 <fileclose>
  return 0;
8010563a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010563f:	c9                   	leave  
80105640:	c3                   	ret    

80105641 <sys_fstat>:

int
sys_fstat(void)
{
80105641:	55                   	push   %ebp
80105642:	89 e5                	mov    %esp,%ebp
80105644:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105647:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010564a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010564e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105655:	00 
80105656:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010565d:	e8 7e fd ff ff       	call   801053e0 <argfd>
80105662:	85 c0                	test   %eax,%eax
80105664:	78 1f                	js     80105685 <sys_fstat+0x44>
80105666:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105669:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105670:	00 
80105671:	89 44 24 04          	mov    %eax,0x4(%esp)
80105675:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010567c:	e8 34 fc ff ff       	call   801052b5 <argptr>
80105681:	85 c0                	test   %eax,%eax
80105683:	79 07                	jns    8010568c <sys_fstat+0x4b>
    return -1;
80105685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568a:	eb 12                	jmp    8010569e <sys_fstat+0x5d>
  return filestat(f, st);
8010568c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010568f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105692:	89 54 24 04          	mov    %edx,0x4(%esp)
80105696:	89 04 24             	mov    %eax,(%esp)
80105699:	e8 31 ba ff ff       	call   801010cf <filestat>
}
8010569e:	c9                   	leave  
8010569f:	c3                   	ret    

801056a0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056a6:	8d 45 d8             	lea    -0x28(%ebp),%eax
801056a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801056ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056b4:	e8 5e fc ff ff       	call   80105317 <argstr>
801056b9:	85 c0                	test   %eax,%eax
801056bb:	78 17                	js     801056d4 <sys_link+0x34>
801056bd:	8d 45 dc             	lea    -0x24(%ebp),%eax
801056c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801056c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801056cb:	e8 47 fc ff ff       	call   80105317 <argstr>
801056d0:	85 c0                	test   %eax,%eax
801056d2:	79 0a                	jns    801056de <sys_link+0x3e>
    return -1;
801056d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d9:	e9 3c 01 00 00       	jmp    8010581a <sys_link+0x17a>
  if((ip = namei(old)) == 0)
801056de:	8b 45 d8             	mov    -0x28(%ebp),%eax
801056e1:	89 04 24             	mov    %eax,(%esp)
801056e4:	e8 66 cd ff ff       	call   8010244f <namei>
801056e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056f0:	75 0a                	jne    801056fc <sys_link+0x5c>
    return -1;
801056f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f7:	e9 1e 01 00 00       	jmp    8010581a <sys_link+0x17a>

  begin_trans();
801056fc:	e8 3d db ff ff       	call   8010323e <begin_trans>

  ilock(ip);
80105701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105704:	89 04 24             	mov    %eax,(%esp)
80105707:	e8 9b c1 ff ff       	call   801018a7 <ilock>
  if(ip->type == T_DIR){
8010570c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010570f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105713:	66 83 f8 01          	cmp    $0x1,%ax
80105717:	75 1a                	jne    80105733 <sys_link+0x93>
    iunlockput(ip);
80105719:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010571c:	89 04 24             	mov    %eax,(%esp)
8010571f:	e8 0a c4 ff ff       	call   80101b2e <iunlockput>
    commit_trans();
80105724:	e8 5e db ff ff       	call   80103287 <commit_trans>
    return -1;
80105729:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010572e:	e9 e7 00 00 00       	jmp    8010581a <sys_link+0x17a>
  }

  ip->nlink++;
80105733:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105736:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010573a:	8d 50 01             	lea    0x1(%eax),%edx
8010573d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105740:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105744:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105747:	89 04 24             	mov    %eax,(%esp)
8010574a:	e8 98 bf ff ff       	call   801016e7 <iupdate>
  iunlock(ip);
8010574f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105752:	89 04 24             	mov    %eax,(%esp)
80105755:	e8 9e c2 ff ff       	call   801019f8 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
8010575a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010575d:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105760:	89 54 24 04          	mov    %edx,0x4(%esp)
80105764:	89 04 24             	mov    %eax,(%esp)
80105767:	e8 05 cd ff ff       	call   80102471 <nameiparent>
8010576c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010576f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105773:	74 68                	je     801057dd <sys_link+0x13d>
    goto bad;
  ilock(dp);
80105775:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105778:	89 04 24             	mov    %eax,(%esp)
8010577b:	e8 27 c1 ff ff       	call   801018a7 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105780:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105783:	8b 10                	mov    (%eax),%edx
80105785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105788:	8b 00                	mov    (%eax),%eax
8010578a:	39 c2                	cmp    %eax,%edx
8010578c:	75 20                	jne    801057ae <sys_link+0x10e>
8010578e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105791:	8b 40 04             	mov    0x4(%eax),%eax
80105794:	89 44 24 08          	mov    %eax,0x8(%esp)
80105798:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010579b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010579f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057a2:	89 04 24             	mov    %eax,(%esp)
801057a5:	e8 e4 c9 ff ff       	call   8010218e <dirlink>
801057aa:	85 c0                	test   %eax,%eax
801057ac:	79 0d                	jns    801057bb <sys_link+0x11b>
    iunlockput(dp);
801057ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b1:	89 04 24             	mov    %eax,(%esp)
801057b4:	e8 75 c3 ff ff       	call   80101b2e <iunlockput>
    goto bad;
801057b9:	eb 23                	jmp    801057de <sys_link+0x13e>
  }
  iunlockput(dp);
801057bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057be:	89 04 24             	mov    %eax,(%esp)
801057c1:	e8 68 c3 ff ff       	call   80101b2e <iunlockput>
  iput(ip);
801057c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057c9:	89 04 24             	mov    %eax,(%esp)
801057cc:	e8 8c c2 ff ff       	call   80101a5d <iput>

  commit_trans();
801057d1:	e8 b1 da ff ff       	call   80103287 <commit_trans>

  return 0;
801057d6:	b8 00 00 00 00       	mov    $0x0,%eax
801057db:	eb 3d                	jmp    8010581a <sys_link+0x17a>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801057dd:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
801057de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e1:	89 04 24             	mov    %eax,(%esp)
801057e4:	e8 be c0 ff ff       	call   801018a7 <ilock>
  ip->nlink--;
801057e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ec:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801057f0:	8d 50 ff             	lea    -0x1(%eax),%edx
801057f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f6:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801057fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057fd:	89 04 24             	mov    %eax,(%esp)
80105800:	e8 e2 be ff ff       	call   801016e7 <iupdate>
  iunlockput(ip);
80105805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105808:	89 04 24             	mov    %eax,(%esp)
8010580b:	e8 1e c3 ff ff       	call   80101b2e <iunlockput>
  commit_trans();
80105810:	e8 72 da ff ff       	call   80103287 <commit_trans>
  return -1;
80105815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010581a:	c9                   	leave  
8010581b:	c3                   	ret    

8010581c <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010581c:	55                   	push   %ebp
8010581d:	89 e5                	mov    %esp,%ebp
8010581f:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105822:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105829:	eb 4b                	jmp    80105876 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010582b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010582e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105831:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105838:	00 
80105839:	89 54 24 08          	mov    %edx,0x8(%esp)
8010583d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105841:	8b 45 08             	mov    0x8(%ebp),%eax
80105844:	89 04 24             	mov    %eax,(%esp)
80105847:	e8 54 c5 ff ff       	call   80101da0 <readi>
8010584c:	83 f8 10             	cmp    $0x10,%eax
8010584f:	74 0c                	je     8010585d <isdirempty+0x41>
      panic("isdirempty: readi");
80105851:	c7 04 24 90 86 10 80 	movl   $0x80108690,(%esp)
80105858:	e8 dd ac ff ff       	call   8010053a <panic>
    if(de.inum != 0)
8010585d:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105861:	66 85 c0             	test   %ax,%ax
80105864:	74 07                	je     8010586d <isdirempty+0x51>
      return 0;
80105866:	b8 00 00 00 00       	mov    $0x0,%eax
8010586b:	eb 1b                	jmp    80105888 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010586d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105870:	83 c0 10             	add    $0x10,%eax
80105873:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105876:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105879:	8b 45 08             	mov    0x8(%ebp),%eax
8010587c:	8b 40 18             	mov    0x18(%eax),%eax
8010587f:	39 c2                	cmp    %eax,%edx
80105881:	72 a8                	jb     8010582b <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105883:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105888:	c9                   	leave  
80105889:	c3                   	ret    

8010588a <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010588a:	55                   	push   %ebp
8010588b:	89 e5                	mov    %esp,%ebp
8010588d:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105890:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105893:	89 44 24 04          	mov    %eax,0x4(%esp)
80105897:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010589e:	e8 74 fa ff ff       	call   80105317 <argstr>
801058a3:	85 c0                	test   %eax,%eax
801058a5:	79 0a                	jns    801058b1 <sys_unlink+0x27>
    return -1;
801058a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ac:	e9 aa 01 00 00       	jmp    80105a5b <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
801058b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801058b4:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801058b7:	89 54 24 04          	mov    %edx,0x4(%esp)
801058bb:	89 04 24             	mov    %eax,(%esp)
801058be:	e8 ae cb ff ff       	call   80102471 <nameiparent>
801058c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058ca:	75 0a                	jne    801058d6 <sys_unlink+0x4c>
    return -1;
801058cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d1:	e9 85 01 00 00       	jmp    80105a5b <sys_unlink+0x1d1>

  begin_trans();
801058d6:	e8 63 d9 ff ff       	call   8010323e <begin_trans>

  ilock(dp);
801058db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058de:	89 04 24             	mov    %eax,(%esp)
801058e1:	e8 c1 bf ff ff       	call   801018a7 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058e6:	c7 44 24 04 a2 86 10 	movl   $0x801086a2,0x4(%esp)
801058ed:	80 
801058ee:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801058f1:	89 04 24             	mov    %eax,(%esp)
801058f4:	e8 ab c7 ff ff       	call   801020a4 <namecmp>
801058f9:	85 c0                	test   %eax,%eax
801058fb:	0f 84 45 01 00 00    	je     80105a46 <sys_unlink+0x1bc>
80105901:	c7 44 24 04 a4 86 10 	movl   $0x801086a4,0x4(%esp)
80105908:	80 
80105909:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010590c:	89 04 24             	mov    %eax,(%esp)
8010590f:	e8 90 c7 ff ff       	call   801020a4 <namecmp>
80105914:	85 c0                	test   %eax,%eax
80105916:	0f 84 2a 01 00 00    	je     80105a46 <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010591c:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010591f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105923:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105926:	89 44 24 04          	mov    %eax,0x4(%esp)
8010592a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010592d:	89 04 24             	mov    %eax,(%esp)
80105930:	e8 91 c7 ff ff       	call   801020c6 <dirlookup>
80105935:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105938:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010593c:	0f 84 03 01 00 00    	je     80105a45 <sys_unlink+0x1bb>
    goto bad;
  ilock(ip);
80105942:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105945:	89 04 24             	mov    %eax,(%esp)
80105948:	e8 5a bf ff ff       	call   801018a7 <ilock>

  if(ip->nlink < 1)
8010594d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105950:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105954:	66 85 c0             	test   %ax,%ax
80105957:	7f 0c                	jg     80105965 <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
80105959:	c7 04 24 a7 86 10 80 	movl   $0x801086a7,(%esp)
80105960:	e8 d5 ab ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105965:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105968:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010596c:	66 83 f8 01          	cmp    $0x1,%ax
80105970:	75 1f                	jne    80105991 <sys_unlink+0x107>
80105972:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105975:	89 04 24             	mov    %eax,(%esp)
80105978:	e8 9f fe ff ff       	call   8010581c <isdirempty>
8010597d:	85 c0                	test   %eax,%eax
8010597f:	75 10                	jne    80105991 <sys_unlink+0x107>
    iunlockput(ip);
80105981:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105984:	89 04 24             	mov    %eax,(%esp)
80105987:	e8 a2 c1 ff ff       	call   80101b2e <iunlockput>
    goto bad;
8010598c:	e9 b5 00 00 00       	jmp    80105a46 <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
80105991:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105998:	00 
80105999:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801059a0:	00 
801059a1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059a4:	89 04 24             	mov    %eax,(%esp)
801059a7:	e8 7e f5 ff ff       	call   80104f2a <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059ac:	8b 55 c8             	mov    -0x38(%ebp),%edx
801059af:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059b2:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801059b9:	00 
801059ba:	89 54 24 08          	mov    %edx,0x8(%esp)
801059be:	89 44 24 04          	mov    %eax,0x4(%esp)
801059c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c5:	89 04 24             	mov    %eax,(%esp)
801059c8:	e8 3f c5 ff ff       	call   80101f0c <writei>
801059cd:	83 f8 10             	cmp    $0x10,%eax
801059d0:	74 0c                	je     801059de <sys_unlink+0x154>
    panic("unlink: writei");
801059d2:	c7 04 24 b9 86 10 80 	movl   $0x801086b9,(%esp)
801059d9:	e8 5c ab ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
801059de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801059e5:	66 83 f8 01          	cmp    $0x1,%ax
801059e9:	75 1c                	jne    80105a07 <sys_unlink+0x17d>
    dp->nlink--;
801059eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ee:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801059f2:	8d 50 ff             	lea    -0x1(%eax),%edx
801059f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f8:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801059fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ff:	89 04 24             	mov    %eax,(%esp)
80105a02:	e8 e0 bc ff ff       	call   801016e7 <iupdate>
  }
  iunlockput(dp);
80105a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0a:	89 04 24             	mov    %eax,(%esp)
80105a0d:	e8 1c c1 ff ff       	call   80101b2e <iunlockput>

  ip->nlink--;
80105a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a15:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a19:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1f:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a26:	89 04 24             	mov    %eax,(%esp)
80105a29:	e8 b9 bc ff ff       	call   801016e7 <iupdate>
  iunlockput(ip);
80105a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a31:	89 04 24             	mov    %eax,(%esp)
80105a34:	e8 f5 c0 ff ff       	call   80101b2e <iunlockput>

  commit_trans();
80105a39:	e8 49 d8 ff ff       	call   80103287 <commit_trans>

  return 0;
80105a3e:	b8 00 00 00 00       	mov    $0x0,%eax
80105a43:	eb 16                	jmp    80105a5b <sys_unlink+0x1d1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105a45:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
80105a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a49:	89 04 24             	mov    %eax,(%esp)
80105a4c:	e8 dd c0 ff ff       	call   80101b2e <iunlockput>
  commit_trans();
80105a51:	e8 31 d8 ff ff       	call   80103287 <commit_trans>
  return -1;
80105a56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a5b:	c9                   	leave  
80105a5c:	c3                   	ret    

80105a5d <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105a5d:	55                   	push   %ebp
80105a5e:	89 e5                	mov    %esp,%ebp
80105a60:	83 ec 48             	sub    $0x48,%esp
80105a63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105a66:	8b 55 10             	mov    0x10(%ebp),%edx
80105a69:	8b 45 14             	mov    0x14(%ebp),%eax
80105a6c:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105a70:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105a74:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105a78:	8d 45 de             	lea    -0x22(%ebp),%eax
80105a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80105a82:	89 04 24             	mov    %eax,(%esp)
80105a85:	e8 e7 c9 ff ff       	call   80102471 <nameiparent>
80105a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a91:	75 0a                	jne    80105a9d <create+0x40>
    return 0;
80105a93:	b8 00 00 00 00       	mov    $0x0,%eax
80105a98:	e9 7e 01 00 00       	jmp    80105c1b <create+0x1be>
  ilock(dp);
80105a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa0:	89 04 24             	mov    %eax,(%esp)
80105aa3:	e8 ff bd ff ff       	call   801018a7 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105aa8:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105aab:	89 44 24 08          	mov    %eax,0x8(%esp)
80105aaf:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab9:	89 04 24             	mov    %eax,(%esp)
80105abc:	e8 05 c6 ff ff       	call   801020c6 <dirlookup>
80105ac1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ac4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ac8:	74 47                	je     80105b11 <create+0xb4>
    iunlockput(dp);
80105aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105acd:	89 04 24             	mov    %eax,(%esp)
80105ad0:	e8 59 c0 ff ff       	call   80101b2e <iunlockput>
    ilock(ip);
80105ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ad8:	89 04 24             	mov    %eax,(%esp)
80105adb:	e8 c7 bd ff ff       	call   801018a7 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105ae0:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105ae5:	75 15                	jne    80105afc <create+0x9f>
80105ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aea:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105aee:	66 83 f8 02          	cmp    $0x2,%ax
80105af2:	75 08                	jne    80105afc <create+0x9f>
      return ip;
80105af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af7:	e9 1f 01 00 00       	jmp    80105c1b <create+0x1be>
    iunlockput(ip);
80105afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aff:	89 04 24             	mov    %eax,(%esp)
80105b02:	e8 27 c0 ff ff       	call   80101b2e <iunlockput>
    return 0;
80105b07:	b8 00 00 00 00       	mov    $0x0,%eax
80105b0c:	e9 0a 01 00 00       	jmp    80105c1b <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105b11:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b18:	8b 00                	mov    (%eax),%eax
80105b1a:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b1e:	89 04 24             	mov    %eax,(%esp)
80105b21:	e8 e4 ba ff ff       	call   8010160a <ialloc>
80105b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b2d:	75 0c                	jne    80105b3b <create+0xde>
    panic("create: ialloc");
80105b2f:	c7 04 24 c8 86 10 80 	movl   $0x801086c8,(%esp)
80105b36:	e8 ff a9 ff ff       	call   8010053a <panic>

  ilock(ip);
80105b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b3e:	89 04 24             	mov    %eax,(%esp)
80105b41:	e8 61 bd ff ff       	call   801018a7 <ilock>
  ip->major = major;
80105b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b49:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105b4d:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b54:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105b58:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b5f:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b68:	89 04 24             	mov    %eax,(%esp)
80105b6b:	e8 77 bb ff ff       	call   801016e7 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105b70:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105b75:	75 6a                	jne    80105be1 <create+0x184>
    dp->nlink++;  // for ".."
80105b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b7e:	8d 50 01             	lea    0x1(%eax),%edx
80105b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b84:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8b:	89 04 24             	mov    %eax,(%esp)
80105b8e:	e8 54 bb ff ff       	call   801016e7 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b96:	8b 40 04             	mov    0x4(%eax),%eax
80105b99:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b9d:	c7 44 24 04 a2 86 10 	movl   $0x801086a2,0x4(%esp)
80105ba4:	80 
80105ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ba8:	89 04 24             	mov    %eax,(%esp)
80105bab:	e8 de c5 ff ff       	call   8010218e <dirlink>
80105bb0:	85 c0                	test   %eax,%eax
80105bb2:	78 21                	js     80105bd5 <create+0x178>
80105bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb7:	8b 40 04             	mov    0x4(%eax),%eax
80105bba:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bbe:	c7 44 24 04 a4 86 10 	movl   $0x801086a4,0x4(%esp)
80105bc5:	80 
80105bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc9:	89 04 24             	mov    %eax,(%esp)
80105bcc:	e8 bd c5 ff ff       	call   8010218e <dirlink>
80105bd1:	85 c0                	test   %eax,%eax
80105bd3:	79 0c                	jns    80105be1 <create+0x184>
      panic("create dots");
80105bd5:	c7 04 24 d7 86 10 80 	movl   $0x801086d7,(%esp)
80105bdc:	e8 59 a9 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be4:	8b 40 04             	mov    0x4(%eax),%eax
80105be7:	89 44 24 08          	mov    %eax,0x8(%esp)
80105beb:	8d 45 de             	lea    -0x22(%ebp),%eax
80105bee:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf5:	89 04 24             	mov    %eax,(%esp)
80105bf8:	e8 91 c5 ff ff       	call   8010218e <dirlink>
80105bfd:	85 c0                	test   %eax,%eax
80105bff:	79 0c                	jns    80105c0d <create+0x1b0>
    panic("create: dirlink");
80105c01:	c7 04 24 e3 86 10 80 	movl   $0x801086e3,(%esp)
80105c08:	e8 2d a9 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80105c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c10:	89 04 24             	mov    %eax,(%esp)
80105c13:	e8 16 bf ff ff       	call   80101b2e <iunlockput>

  return ip;
80105c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105c1b:	c9                   	leave  
80105c1c:	c3                   	ret    

80105c1d <sys_open>:

int
sys_open(void)
{
80105c1d:	55                   	push   %ebp
80105c1e:	89 e5                	mov    %esp,%ebp
80105c20:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c23:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105c26:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c31:	e8 e1 f6 ff ff       	call   80105317 <argstr>
80105c36:	85 c0                	test   %eax,%eax
80105c38:	78 17                	js     80105c51 <sys_open+0x34>
80105c3a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105c48:	e8 39 f6 ff ff       	call   80105286 <argint>
80105c4d:	85 c0                	test   %eax,%eax
80105c4f:	79 0a                	jns    80105c5b <sys_open+0x3e>
    return -1;
80105c51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c56:	e9 46 01 00 00       	jmp    80105da1 <sys_open+0x184>
  if(omode & O_CREATE){
80105c5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c5e:	25 00 02 00 00       	and    $0x200,%eax
80105c63:	85 c0                	test   %eax,%eax
80105c65:	74 40                	je     80105ca7 <sys_open+0x8a>
    begin_trans();
80105c67:	e8 d2 d5 ff ff       	call   8010323e <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105c6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c6f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105c76:	00 
80105c77:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105c7e:	00 
80105c7f:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105c86:	00 
80105c87:	89 04 24             	mov    %eax,(%esp)
80105c8a:	e8 ce fd ff ff       	call   80105a5d <create>
80105c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105c92:	e8 f0 d5 ff ff       	call   80103287 <commit_trans>
    if(ip == 0)
80105c97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c9b:	75 5c                	jne    80105cf9 <sys_open+0xdc>
      return -1;
80105c9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca2:	e9 fa 00 00 00       	jmp    80105da1 <sys_open+0x184>
  } else {
    if((ip = namei(path)) == 0)
80105ca7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105caa:	89 04 24             	mov    %eax,(%esp)
80105cad:	e8 9d c7 ff ff       	call   8010244f <namei>
80105cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cb9:	75 0a                	jne    80105cc5 <sys_open+0xa8>
      return -1;
80105cbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc0:	e9 dc 00 00 00       	jmp    80105da1 <sys_open+0x184>
    ilock(ip);
80105cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc8:	89 04 24             	mov    %eax,(%esp)
80105ccb:	e8 d7 bb ff ff       	call   801018a7 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cd3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105cd7:	66 83 f8 01          	cmp    $0x1,%ax
80105cdb:	75 1c                	jne    80105cf9 <sys_open+0xdc>
80105cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ce0:	85 c0                	test   %eax,%eax
80105ce2:	74 15                	je     80105cf9 <sys_open+0xdc>
      iunlockput(ip);
80105ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce7:	89 04 24             	mov    %eax,(%esp)
80105cea:	e8 3f be ff ff       	call   80101b2e <iunlockput>
      return -1;
80105cef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cf4:	e9 a8 00 00 00       	jmp    80105da1 <sys_open+0x184>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105cf9:	e8 52 b2 ff ff       	call   80100f50 <filealloc>
80105cfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d05:	74 14                	je     80105d1b <sys_open+0xfe>
80105d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d0a:	89 04 24             	mov    %eax,(%esp)
80105d0d:	e8 43 f7 ff ff       	call   80105455 <fdalloc>
80105d12:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105d15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105d19:	79 23                	jns    80105d3e <sys_open+0x121>
    if(f)
80105d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d1f:	74 0b                	je     80105d2c <sys_open+0x10f>
      fileclose(f);
80105d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d24:	89 04 24             	mov    %eax,(%esp)
80105d27:	e8 cd b2 ff ff       	call   80100ff9 <fileclose>
    iunlockput(ip);
80105d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d2f:	89 04 24             	mov    %eax,(%esp)
80105d32:	e8 f7 bd ff ff       	call   80101b2e <iunlockput>
    return -1;
80105d37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3c:	eb 63                	jmp    80105da1 <sys_open+0x184>
  }
  iunlock(ip);
80105d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d41:	89 04 24             	mov    %eax,(%esp)
80105d44:	e8 af bc ff ff       	call   801019f8 <iunlock>

  f->type = FD_INODE;
80105d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d4c:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d58:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d5e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105d65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d68:	83 e0 01             	and    $0x1,%eax
80105d6b:	85 c0                	test   %eax,%eax
80105d6d:	0f 94 c2             	sete   %dl
80105d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d73:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d79:	83 e0 01             	and    $0x1,%eax
80105d7c:	84 c0                	test   %al,%al
80105d7e:	75 0a                	jne    80105d8a <sys_open+0x16d>
80105d80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d83:	83 e0 02             	and    $0x2,%eax
80105d86:	85 c0                	test   %eax,%eax
80105d88:	74 07                	je     80105d91 <sys_open+0x174>
80105d8a:	b8 01 00 00 00       	mov    $0x1,%eax
80105d8f:	eb 05                	jmp    80105d96 <sys_open+0x179>
80105d91:	b8 00 00 00 00       	mov    $0x0,%eax
80105d96:	89 c2                	mov    %eax,%edx
80105d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d9b:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105da1:	c9                   	leave  
80105da2:	c3                   	ret    

80105da3 <sys_mkdir>:

int
sys_mkdir(void)
{
80105da3:	55                   	push   %ebp
80105da4:	89 e5                	mov    %esp,%ebp
80105da6:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105da9:	e8 90 d4 ff ff       	call   8010323e <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105dae:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105db1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105db5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105dbc:	e8 56 f5 ff ff       	call   80105317 <argstr>
80105dc1:	85 c0                	test   %eax,%eax
80105dc3:	78 2c                	js     80105df1 <sys_mkdir+0x4e>
80105dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105dcf:	00 
80105dd0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105dd7:	00 
80105dd8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105ddf:	00 
80105de0:	89 04 24             	mov    %eax,(%esp)
80105de3:	e8 75 fc ff ff       	call   80105a5d <create>
80105de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105deb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105def:	75 0c                	jne    80105dfd <sys_mkdir+0x5a>
    commit_trans();
80105df1:	e8 91 d4 ff ff       	call   80103287 <commit_trans>
    return -1;
80105df6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfb:	eb 15                	jmp    80105e12 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e00:	89 04 24             	mov    %eax,(%esp)
80105e03:	e8 26 bd ff ff       	call   80101b2e <iunlockput>
  commit_trans();
80105e08:	e8 7a d4 ff ff       	call   80103287 <commit_trans>
  return 0;
80105e0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e12:	c9                   	leave  
80105e13:	c3                   	ret    

80105e14 <sys_mknod>:

int
sys_mknod(void)
{
80105e14:	55                   	push   %ebp
80105e15:	89 e5                	mov    %esp,%ebp
80105e17:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105e1a:	e8 1f d4 ff ff       	call   8010323e <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105e1f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e22:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e2d:	e8 e5 f4 ff ff       	call   80105317 <argstr>
80105e32:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e39:	78 5e                	js     80105e99 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80105e3b:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e49:	e8 38 f4 ff ff       	call   80105286 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105e4e:	85 c0                	test   %eax,%eax
80105e50:	78 47                	js     80105e99 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105e52:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e55:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e59:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105e60:	e8 21 f4 ff ff       	call   80105286 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105e65:	85 c0                	test   %eax,%eax
80105e67:	78 30                	js     80105e99 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e6c:	0f bf c8             	movswl %ax,%ecx
80105e6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e72:	0f bf d0             	movswl %ax,%edx
80105e75:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e78:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105e7c:	89 54 24 08          	mov    %edx,0x8(%esp)
80105e80:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105e87:	00 
80105e88:	89 04 24             	mov    %eax,(%esp)
80105e8b:	e8 cd fb ff ff       	call   80105a5d <create>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105e90:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e97:	75 0c                	jne    80105ea5 <sys_mknod+0x91>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80105e99:	e8 e9 d3 ff ff       	call   80103287 <commit_trans>
    return -1;
80105e9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea3:	eb 15                	jmp    80105eba <sys_mknod+0xa6>
  }
  iunlockput(ip);
80105ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea8:	89 04 24             	mov    %eax,(%esp)
80105eab:	e8 7e bc ff ff       	call   80101b2e <iunlockput>
  commit_trans();
80105eb0:	e8 d2 d3 ff ff       	call   80103287 <commit_trans>
  return 0;
80105eb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105eba:	c9                   	leave  
80105ebb:	c3                   	ret    

80105ebc <sys_chdir>:

int
sys_chdir(void)
{
80105ebc:	55                   	push   %ebp
80105ebd:	89 e5                	mov    %esp,%ebp
80105ebf:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105ec2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ec5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ec9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ed0:	e8 42 f4 ff ff       	call   80105317 <argstr>
80105ed5:	85 c0                	test   %eax,%eax
80105ed7:	78 14                	js     80105eed <sys_chdir+0x31>
80105ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105edc:	89 04 24             	mov    %eax,(%esp)
80105edf:	e8 6b c5 ff ff       	call   8010244f <namei>
80105ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ee7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105eeb:	75 07                	jne    80105ef4 <sys_chdir+0x38>
    return -1;
80105eed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef2:	eb 57                	jmp    80105f4b <sys_chdir+0x8f>
  ilock(ip);
80105ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef7:	89 04 24             	mov    %eax,(%esp)
80105efa:	e8 a8 b9 ff ff       	call   801018a7 <ilock>
  if(ip->type != T_DIR){
80105eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f02:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f06:	66 83 f8 01          	cmp    $0x1,%ax
80105f0a:	74 12                	je     80105f1e <sys_chdir+0x62>
    iunlockput(ip);
80105f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f0f:	89 04 24             	mov    %eax,(%esp)
80105f12:	e8 17 bc ff ff       	call   80101b2e <iunlockput>
    return -1;
80105f17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f1c:	eb 2d                	jmp    80105f4b <sys_chdir+0x8f>
  }
  iunlock(ip);
80105f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f21:	89 04 24             	mov    %eax,(%esp)
80105f24:	e8 cf ba ff ff       	call   801019f8 <iunlock>
  iput(proc->cwd);
80105f29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f2f:	8b 40 68             	mov    0x68(%eax),%eax
80105f32:	89 04 24             	mov    %eax,(%esp)
80105f35:	e8 23 bb ff ff       	call   80101a5d <iput>
  proc->cwd = ip;
80105f3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f43:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105f46:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f4b:	c9                   	leave  
80105f4c:	c3                   	ret    

80105f4d <sys_exec>:

int
sys_exec(void)
{
80105f4d:	55                   	push   %ebp
80105f4e:	89 e5                	mov    %esp,%ebp
80105f50:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f56:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f59:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f64:	e8 ae f3 ff ff       	call   80105317 <argstr>
80105f69:	85 c0                	test   %eax,%eax
80105f6b:	78 1a                	js     80105f87 <sys_exec+0x3a>
80105f6d:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105f73:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f77:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f7e:	e8 03 f3 ff ff       	call   80105286 <argint>
80105f83:	85 c0                	test   %eax,%eax
80105f85:	79 0a                	jns    80105f91 <sys_exec+0x44>
    return -1;
80105f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f8c:	e9 cd 00 00 00       	jmp    8010605e <sys_exec+0x111>
  }
  memset(argv, 0, sizeof(argv));
80105f91:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105f98:	00 
80105f99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105fa0:	00 
80105fa1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105fa7:	89 04 24             	mov    %eax,(%esp)
80105faa:	e8 7b ef ff ff       	call   80104f2a <memset>
  for(i=0;; i++){
80105faf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb9:	83 f8 1f             	cmp    $0x1f,%eax
80105fbc:	76 0a                	jbe    80105fc8 <sys_exec+0x7b>
      return -1;
80105fbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc3:	e9 96 00 00 00       	jmp    8010605e <sys_exec+0x111>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105fc8:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105fce:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fd1:	c1 e2 02             	shl    $0x2,%edx
80105fd4:	89 d1                	mov    %edx,%ecx
80105fd6:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
80105fdc:	8d 14 11             	lea    (%ecx,%edx,1),%edx
80105fdf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fe3:	89 14 24             	mov    %edx,(%esp)
80105fe6:	e8 fd f1 ff ff       	call   801051e8 <fetchint>
80105feb:	85 c0                	test   %eax,%eax
80105fed:	79 07                	jns    80105ff6 <sys_exec+0xa9>
      return -1;
80105fef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ff4:	eb 68                	jmp    8010605e <sys_exec+0x111>
    if(uarg == 0){
80105ff6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105ffc:	85 c0                	test   %eax,%eax
80105ffe:	75 26                	jne    80106026 <sys_exec+0xd9>
      argv[i] = 0;
80106000:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106003:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010600a:	00 00 00 00 
      break;
8010600e:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010600f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106012:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106018:	89 54 24 04          	mov    %edx,0x4(%esp)
8010601c:	89 04 24             	mov    %eax,(%esp)
8010601f:	e8 d4 aa ff ff       	call   80100af8 <exec>
80106024:	eb 38                	jmp    8010605e <sys_exec+0x111>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106029:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106030:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106036:	01 d0                	add    %edx,%eax
80106038:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
8010603e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106042:	89 14 24             	mov    %edx,(%esp)
80106045:	e8 d8 f1 ff ff       	call   80105222 <fetchstr>
8010604a:	85 c0                	test   %eax,%eax
8010604c:	79 07                	jns    80106055 <sys_exec+0x108>
      return -1;
8010604e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106053:	eb 09                	jmp    8010605e <sys_exec+0x111>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106055:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106059:	e9 58 ff ff ff       	jmp    80105fb6 <sys_exec+0x69>
  return exec(path, argv);
}
8010605e:	c9                   	leave  
8010605f:	c3                   	ret    

80106060 <sys_pipe>:

int
sys_pipe(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106066:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106069:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106070:	00 
80106071:	89 44 24 04          	mov    %eax,0x4(%esp)
80106075:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010607c:	e8 34 f2 ff ff       	call   801052b5 <argptr>
80106081:	85 c0                	test   %eax,%eax
80106083:	79 0a                	jns    8010608f <sys_pipe+0x2f>
    return -1;
80106085:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010608a:	e9 9b 00 00 00       	jmp    8010612a <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
8010608f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106092:	89 44 24 04          	mov    %eax,0x4(%esp)
80106096:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106099:	89 04 24             	mov    %eax,(%esp)
8010609c:	e8 93 db ff ff       	call   80103c34 <pipealloc>
801060a1:	85 c0                	test   %eax,%eax
801060a3:	79 07                	jns    801060ac <sys_pipe+0x4c>
    return -1;
801060a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060aa:	eb 7e                	jmp    8010612a <sys_pipe+0xca>
  fd0 = -1;
801060ac:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801060b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060b6:	89 04 24             	mov    %eax,(%esp)
801060b9:	e8 97 f3 ff ff       	call   80105455 <fdalloc>
801060be:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060c5:	78 14                	js     801060db <sys_pipe+0x7b>
801060c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060ca:	89 04 24             	mov    %eax,(%esp)
801060cd:	e8 83 f3 ff ff       	call   80105455 <fdalloc>
801060d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060d9:	79 37                	jns    80106112 <sys_pipe+0xb2>
    if(fd0 >= 0)
801060db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060df:	78 14                	js     801060f5 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
801060e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801060ea:	83 c2 08             	add    $0x8,%edx
801060ed:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801060f4:	00 
    fileclose(rf);
801060f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060f8:	89 04 24             	mov    %eax,(%esp)
801060fb:	e8 f9 ae ff ff       	call   80100ff9 <fileclose>
    fileclose(wf);
80106100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106103:	89 04 24             	mov    %eax,(%esp)
80106106:	e8 ee ae ff ff       	call   80100ff9 <fileclose>
    return -1;
8010610b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106110:	eb 18                	jmp    8010612a <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106112:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106115:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106118:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010611a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010611d:	8d 50 04             	lea    0x4(%eax),%edx
80106120:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106123:	89 02                	mov    %eax,(%edx)
  return 0;
80106125:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010612a:	c9                   	leave  
8010612b:	c3                   	ret    

8010612c <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010612c:	55                   	push   %ebp
8010612d:	89 e5                	mov    %esp,%ebp
8010612f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106132:	e8 0a e3 ff ff       	call   80104441 <fork>
}
80106137:	c9                   	leave  
80106138:	c3                   	ret    

80106139 <sys_exit>:

int
sys_exit(void)
{
80106139:	55                   	push   %ebp
8010613a:	89 e5                	mov    %esp,%ebp
8010613c:	83 ec 08             	sub    $0x8,%esp
  exit();
8010613f:	e8 6b e4 ff ff       	call   801045af <exit>
  return 0;  // not reached
80106144:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106149:	c9                   	leave  
8010614a:	c3                   	ret    

8010614b <sys_wait>:

int
sys_wait(void)
{
8010614b:	55                   	push   %ebp
8010614c:	89 e5                	mov    %esp,%ebp
8010614e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106151:	e8 81 e5 ff ff       	call   801046d7 <wait>
}
80106156:	c9                   	leave  
80106157:	c3                   	ret    

80106158 <sys_kill>:

int
sys_kill(void)
{
80106158:	55                   	push   %ebp
80106159:	89 e5                	mov    %esp,%ebp
8010615b:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010615e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106161:	89 44 24 04          	mov    %eax,0x4(%esp)
80106165:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010616c:	e8 15 f1 ff ff       	call   80105286 <argint>
80106171:	85 c0                	test   %eax,%eax
80106173:	79 07                	jns    8010617c <sys_kill+0x24>
    return -1;
80106175:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010617a:	eb 0b                	jmp    80106187 <sys_kill+0x2f>
  return kill(pid);
8010617c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010617f:	89 04 24             	mov    %eax,(%esp)
80106182:	e8 78 e9 ff ff       	call   80104aff <kill>
}
80106187:	c9                   	leave  
80106188:	c3                   	ret    

80106189 <sys_getpid>:

int
sys_getpid(void)
{
80106189:	55                   	push   %ebp
8010618a:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010618c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106192:	8b 40 10             	mov    0x10(%eax),%eax
}
80106195:	5d                   	pop    %ebp
80106196:	c3                   	ret    

80106197 <sys_sbrk>:

int
sys_sbrk(void)
{
80106197:	55                   	push   %ebp
80106198:	89 e5                	mov    %esp,%ebp
8010619a:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010619d:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801061a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061ab:	e8 d6 f0 ff ff       	call   80105286 <argint>
801061b0:	85 c0                	test   %eax,%eax
801061b2:	79 07                	jns    801061bb <sys_sbrk+0x24>
    return -1;
801061b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061b9:	eb 24                	jmp    801061df <sys_sbrk+0x48>
  addr = proc->sz;
801061bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061c1:	8b 00                	mov    (%eax),%eax
801061c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801061c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c9:	89 04 24             	mov    %eax,(%esp)
801061cc:	e8 cb e1 ff ff       	call   8010439c <growproc>
801061d1:	85 c0                	test   %eax,%eax
801061d3:	79 07                	jns    801061dc <sys_sbrk+0x45>
    return -1;
801061d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061da:	eb 03                	jmp    801061df <sys_sbrk+0x48>
  return addr;
801061dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801061df:	c9                   	leave  
801061e0:	c3                   	ret    

801061e1 <sys_sleep>:

int
sys_sleep(void)
{
801061e1:	55                   	push   %ebp
801061e2:	89 e5                	mov    %esp,%ebp
801061e4:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801061e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801061ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061f5:	e8 8c f0 ff ff       	call   80105286 <argint>
801061fa:	85 c0                	test   %eax,%eax
801061fc:	79 07                	jns    80106205 <sys_sleep+0x24>
    return -1;
801061fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106203:	eb 6c                	jmp    80106271 <sys_sleep+0x90>
  acquire(&tickslock);
80106205:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
8010620c:	e8 ca ea ff ff       	call   80104cdb <acquire>
  ticks0 = ticks;
80106211:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80106216:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106219:	eb 34                	jmp    8010624f <sys_sleep+0x6e>
    if(proc->killed){
8010621b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106221:	8b 40 24             	mov    0x24(%eax),%eax
80106224:	85 c0                	test   %eax,%eax
80106226:	74 13                	je     8010623b <sys_sleep+0x5a>
      release(&tickslock);
80106228:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
8010622f:	e8 08 eb ff ff       	call   80104d3c <release>
      return -1;
80106234:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106239:	eb 36                	jmp    80106271 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
8010623b:	c7 44 24 04 20 22 11 	movl   $0x80112220,0x4(%esp)
80106242:	80 
80106243:	c7 04 24 60 2a 11 80 	movl   $0x80112a60,(%esp)
8010624a:	e8 9d e7 ff ff       	call   801049ec <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010624f:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80106254:	89 c2                	mov    %eax,%edx
80106256:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106259:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010625c:	39 c2                	cmp    %eax,%edx
8010625e:	72 bb                	jb     8010621b <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106260:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80106267:	e8 d0 ea ff ff       	call   80104d3c <release>
  return 0;
8010626c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106271:	c9                   	leave  
80106272:	c3                   	ret    

80106273 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106273:	55                   	push   %ebp
80106274:	89 e5                	mov    %esp,%ebp
80106276:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106279:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80106280:	e8 56 ea ff ff       	call   80104cdb <acquire>
  xticks = ticks;
80106285:	a1 60 2a 11 80       	mov    0x80112a60,%eax
8010628a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010628d:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80106294:	e8 a3 ea ff ff       	call   80104d3c <release>
  return xticks;
80106299:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010629c:	c9                   	leave  
8010629d:	c3                   	ret    
	...

801062a0 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
801062a3:	83 ec 08             	sub    $0x8,%esp
801062a6:	8b 55 08             	mov    0x8(%ebp),%edx
801062a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801062ac:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801062b0:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062b3:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801062b7:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801062bb:	ee                   	out    %al,(%dx)
}
801062bc:	c9                   	leave  
801062bd:	c3                   	ret    

801062be <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801062be:	55                   	push   %ebp
801062bf:	89 e5                	mov    %esp,%ebp
801062c1:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801062c4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801062cb:	00 
801062cc:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801062d3:	e8 c8 ff ff ff       	call   801062a0 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801062d8:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
801062df:	00 
801062e0:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801062e7:	e8 b4 ff ff ff       	call   801062a0 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801062ec:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
801062f3:	00 
801062f4:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801062fb:	e8 a0 ff ff ff       	call   801062a0 <outb>
  picenable(IRQ_TIMER);
80106300:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106307:	e8 b1 d7 ff ff       	call   80103abd <picenable>
}
8010630c:	c9                   	leave  
8010630d:	c3                   	ret    
	...

80106310 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106310:	1e                   	push   %ds
  pushl %es
80106311:	06                   	push   %es
  pushl %fs
80106312:	0f a0                	push   %fs
  pushl %gs
80106314:	0f a8                	push   %gs
  pushal
80106316:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106317:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010631b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010631d:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010631f:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106323:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106325:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106327:	54                   	push   %esp
  call trap
80106328:	e8 d5 01 00 00       	call   80106502 <trap>
  addl $4, %esp
8010632d:	83 c4 04             	add    $0x4,%esp

80106330 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106330:	61                   	popa   
  popl %gs
80106331:	0f a9                	pop    %gs
  popl %fs
80106333:	0f a1                	pop    %fs
  popl %es
80106335:	07                   	pop    %es
  popl %ds
80106336:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106337:	83 c4 08             	add    $0x8,%esp
  iret
8010633a:	cf                   	iret   
	...

8010633c <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
8010633c:	55                   	push   %ebp
8010633d:	89 e5                	mov    %esp,%ebp
8010633f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106342:	8b 45 0c             	mov    0xc(%ebp),%eax
80106345:	83 e8 01             	sub    $0x1,%eax
80106348:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010634c:	8b 45 08             	mov    0x8(%ebp),%eax
8010634f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106353:	8b 45 08             	mov    0x8(%ebp),%eax
80106356:	c1 e8 10             	shr    $0x10,%eax
80106359:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010635d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106360:	0f 01 18             	lidtl  (%eax)
}
80106363:	c9                   	leave  
80106364:	c3                   	ret    

80106365 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106365:	55                   	push   %ebp
80106366:	89 e5                	mov    %esp,%ebp
80106368:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010636b:	0f 20 d0             	mov    %cr2,%eax
8010636e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106371:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106374:	c9                   	leave  
80106375:	c3                   	ret    

80106376 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106376:	55                   	push   %ebp
80106377:	89 e5                	mov    %esp,%ebp
80106379:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010637c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106383:	e9 bf 00 00 00       	jmp    80106447 <tvinit+0xd1>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106388:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010638b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010638e:	8b 14 95 98 b0 10 80 	mov    -0x7fef4f68(,%edx,4),%edx
80106395:	66 89 14 c5 60 22 11 	mov    %dx,-0x7feedda0(,%eax,8)
8010639c:	80 
8010639d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a0:	66 c7 04 c5 62 22 11 	movw   $0x8,-0x7feedd9e(,%eax,8)
801063a7:	80 08 00 
801063aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ad:	0f b6 14 c5 64 22 11 	movzbl -0x7feedd9c(,%eax,8),%edx
801063b4:	80 
801063b5:	83 e2 e0             	and    $0xffffffe0,%edx
801063b8:	88 14 c5 64 22 11 80 	mov    %dl,-0x7feedd9c(,%eax,8)
801063bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c2:	0f b6 14 c5 64 22 11 	movzbl -0x7feedd9c(,%eax,8),%edx
801063c9:	80 
801063ca:	83 e2 1f             	and    $0x1f,%edx
801063cd:	88 14 c5 64 22 11 80 	mov    %dl,-0x7feedd9c(,%eax,8)
801063d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d7:	0f b6 14 c5 65 22 11 	movzbl -0x7feedd9b(,%eax,8),%edx
801063de:	80 
801063df:	83 e2 f0             	and    $0xfffffff0,%edx
801063e2:	83 ca 0e             	or     $0xe,%edx
801063e5:	88 14 c5 65 22 11 80 	mov    %dl,-0x7feedd9b(,%eax,8)
801063ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ef:	0f b6 14 c5 65 22 11 	movzbl -0x7feedd9b(,%eax,8),%edx
801063f6:	80 
801063f7:	83 e2 ef             	and    $0xffffffef,%edx
801063fa:	88 14 c5 65 22 11 80 	mov    %dl,-0x7feedd9b(,%eax,8)
80106401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106404:	0f b6 14 c5 65 22 11 	movzbl -0x7feedd9b(,%eax,8),%edx
8010640b:	80 
8010640c:	83 e2 9f             	and    $0xffffff9f,%edx
8010640f:	88 14 c5 65 22 11 80 	mov    %dl,-0x7feedd9b(,%eax,8)
80106416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106419:	0f b6 14 c5 65 22 11 	movzbl -0x7feedd9b(,%eax,8),%edx
80106420:	80 
80106421:	83 ca 80             	or     $0xffffff80,%edx
80106424:	88 14 c5 65 22 11 80 	mov    %dl,-0x7feedd9b(,%eax,8)
8010642b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010642e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106431:	8b 14 95 98 b0 10 80 	mov    -0x7fef4f68(,%edx,4),%edx
80106438:	c1 ea 10             	shr    $0x10,%edx
8010643b:	66 89 14 c5 66 22 11 	mov    %dx,-0x7feedd9a(,%eax,8)
80106442:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106443:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106447:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010644e:	0f 8e 34 ff ff ff    	jle    80106388 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106454:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106459:	66 a3 60 24 11 80    	mov    %ax,0x80112460
8010645f:	66 c7 05 62 24 11 80 	movw   $0x8,0x80112462
80106466:	08 00 
80106468:	0f b6 05 64 24 11 80 	movzbl 0x80112464,%eax
8010646f:	83 e0 e0             	and    $0xffffffe0,%eax
80106472:	a2 64 24 11 80       	mov    %al,0x80112464
80106477:	0f b6 05 64 24 11 80 	movzbl 0x80112464,%eax
8010647e:	83 e0 1f             	and    $0x1f,%eax
80106481:	a2 64 24 11 80       	mov    %al,0x80112464
80106486:	0f b6 05 65 24 11 80 	movzbl 0x80112465,%eax
8010648d:	83 c8 0f             	or     $0xf,%eax
80106490:	a2 65 24 11 80       	mov    %al,0x80112465
80106495:	0f b6 05 65 24 11 80 	movzbl 0x80112465,%eax
8010649c:	83 e0 ef             	and    $0xffffffef,%eax
8010649f:	a2 65 24 11 80       	mov    %al,0x80112465
801064a4:	0f b6 05 65 24 11 80 	movzbl 0x80112465,%eax
801064ab:	83 c8 60             	or     $0x60,%eax
801064ae:	a2 65 24 11 80       	mov    %al,0x80112465
801064b3:	0f b6 05 65 24 11 80 	movzbl 0x80112465,%eax
801064ba:	83 c8 80             	or     $0xffffff80,%eax
801064bd:	a2 65 24 11 80       	mov    %al,0x80112465
801064c2:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801064c7:	c1 e8 10             	shr    $0x10,%eax
801064ca:	66 a3 66 24 11 80    	mov    %ax,0x80112466
  
  initlock(&tickslock, "time");
801064d0:	c7 44 24 04 f4 86 10 	movl   $0x801086f4,0x4(%esp)
801064d7:	80 
801064d8:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
801064df:	e8 d6 e7 ff ff       	call   80104cba <initlock>
}
801064e4:	c9                   	leave  
801064e5:	c3                   	ret    

801064e6 <idtinit>:

void
idtinit(void)
{
801064e6:	55                   	push   %ebp
801064e7:	89 e5                	mov    %esp,%ebp
801064e9:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801064ec:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801064f3:	00 
801064f4:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801064fb:	e8 3c fe ff ff       	call   8010633c <lidt>
}
80106500:	c9                   	leave  
80106501:	c3                   	ret    

80106502 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106502:	55                   	push   %ebp
80106503:	89 e5                	mov    %esp,%ebp
80106505:	57                   	push   %edi
80106506:	56                   	push   %esi
80106507:	53                   	push   %ebx
80106508:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
8010650b:	8b 45 08             	mov    0x8(%ebp),%eax
8010650e:	8b 40 30             	mov    0x30(%eax),%eax
80106511:	83 f8 40             	cmp    $0x40,%eax
80106514:	75 3e                	jne    80106554 <trap+0x52>
    if(proc->killed)
80106516:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010651c:	8b 40 24             	mov    0x24(%eax),%eax
8010651f:	85 c0                	test   %eax,%eax
80106521:	74 05                	je     80106528 <trap+0x26>
      exit();
80106523:	e8 87 e0 ff ff       	call   801045af <exit>
    proc->tf = tf;
80106528:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010652e:	8b 55 08             	mov    0x8(%ebp),%edx
80106531:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106534:	e8 15 ee ff ff       	call   8010534e <syscall>
    if(proc->killed)
80106539:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010653f:	8b 40 24             	mov    0x24(%eax),%eax
80106542:	85 c0                	test   %eax,%eax
80106544:	0f 84 34 02 00 00    	je     8010677e <trap+0x27c>
      exit();
8010654a:	e8 60 e0 ff ff       	call   801045af <exit>
    return;
8010654f:	e9 2b 02 00 00       	jmp    8010677f <trap+0x27d>
  }

  switch(tf->trapno){
80106554:	8b 45 08             	mov    0x8(%ebp),%eax
80106557:	8b 40 30             	mov    0x30(%eax),%eax
8010655a:	83 e8 20             	sub    $0x20,%eax
8010655d:	83 f8 1f             	cmp    $0x1f,%eax
80106560:	0f 87 bc 00 00 00    	ja     80106622 <trap+0x120>
80106566:	8b 04 85 9c 87 10 80 	mov    -0x7fef7864(,%eax,4),%eax
8010656d:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
8010656f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106575:	0f b6 00             	movzbl (%eax),%eax
80106578:	84 c0                	test   %al,%al
8010657a:	75 31                	jne    801065ad <trap+0xab>
      acquire(&tickslock);
8010657c:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80106583:	e8 53 e7 ff ff       	call   80104cdb <acquire>
      ticks++;
80106588:	a1 60 2a 11 80       	mov    0x80112a60,%eax
8010658d:	83 c0 01             	add    $0x1,%eax
80106590:	a3 60 2a 11 80       	mov    %eax,0x80112a60
      wakeup(&ticks);
80106595:	c7 04 24 60 2a 11 80 	movl   $0x80112a60,(%esp)
8010659c:	e8 33 e5 ff ff       	call   80104ad4 <wakeup>
      release(&tickslock);
801065a1:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
801065a8:	e8 8f e7 ff ff       	call   80104d3c <release>
    }
    lapiceoi();
801065ad:	e8 5a c9 ff ff       	call   80102f0c <lapiceoi>
    break;
801065b2:	e9 41 01 00 00       	jmp    801066f8 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801065b7:	e8 6b c1 ff ff       	call   80102727 <ideintr>
    lapiceoi();
801065bc:	e8 4b c9 ff ff       	call   80102f0c <lapiceoi>
    break;
801065c1:	e9 32 01 00 00       	jmp    801066f8 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801065c6:	e8 24 c7 ff ff       	call   80102cef <kbdintr>
    lapiceoi();
801065cb:	e8 3c c9 ff ff       	call   80102f0c <lapiceoi>
    break;
801065d0:	e9 23 01 00 00       	jmp    801066f8 <trap+0x1f6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801065d5:	e8 9d 03 00 00       	call   80106977 <uartintr>
    lapiceoi();
801065da:	e8 2d c9 ff ff       	call   80102f0c <lapiceoi>
    break;
801065df:	e9 14 01 00 00       	jmp    801066f8 <trap+0x1f6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801065e4:	8b 45 08             	mov    0x8(%ebp),%eax
801065e7:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801065ea:	8b 45 08             	mov    0x8(%ebp),%eax
801065ed:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801065f1:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801065f4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801065fa:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801065fd:	0f b6 c0             	movzbl %al,%eax
80106600:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106604:	89 54 24 08          	mov    %edx,0x8(%esp)
80106608:	89 44 24 04          	mov    %eax,0x4(%esp)
8010660c:	c7 04 24 fc 86 10 80 	movl   $0x801086fc,(%esp)
80106613:	e8 82 9d ff ff       	call   8010039a <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106618:	e8 ef c8 ff ff       	call   80102f0c <lapiceoi>
    break;
8010661d:	e9 d6 00 00 00       	jmp    801066f8 <trap+0x1f6>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106622:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106628:	85 c0                	test   %eax,%eax
8010662a:	74 11                	je     8010663d <trap+0x13b>
8010662c:	8b 45 08             	mov    0x8(%ebp),%eax
8010662f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106633:	0f b7 c0             	movzwl %ax,%eax
80106636:	83 e0 03             	and    $0x3,%eax
80106639:	85 c0                	test   %eax,%eax
8010663b:	75 46                	jne    80106683 <trap+0x181>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010663d:	e8 23 fd ff ff       	call   80106365 <rcr2>
80106642:	8b 55 08             	mov    0x8(%ebp),%edx
80106645:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106648:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010664f:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106652:	0f b6 ca             	movzbl %dl,%ecx
80106655:	8b 55 08             	mov    0x8(%ebp),%edx
80106658:	8b 52 30             	mov    0x30(%edx),%edx
8010665b:	89 44 24 10          	mov    %eax,0x10(%esp)
8010665f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106663:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106667:	89 54 24 04          	mov    %edx,0x4(%esp)
8010666b:	c7 04 24 20 87 10 80 	movl   $0x80108720,(%esp)
80106672:	e8 23 9d ff ff       	call   8010039a <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106677:	c7 04 24 52 87 10 80 	movl   $0x80108752,(%esp)
8010667e:	e8 b7 9e ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106683:	e8 dd fc ff ff       	call   80106365 <rcr2>
80106688:	89 c2                	mov    %eax,%edx
8010668a:	8b 45 08             	mov    0x8(%ebp),%eax
8010668d:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106690:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106696:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106699:	0f b6 f0             	movzbl %al,%esi
8010669c:	8b 45 08             	mov    0x8(%ebp),%eax
8010669f:	8b 58 34             	mov    0x34(%eax),%ebx
801066a2:	8b 45 08             	mov    0x8(%ebp),%eax
801066a5:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801066a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066ae:	83 c0 6c             	add    $0x6c,%eax
801066b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801066b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066ba:	8b 40 10             	mov    0x10(%eax),%eax
801066bd:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801066c1:	89 7c 24 18          	mov    %edi,0x18(%esp)
801066c5:	89 74 24 14          	mov    %esi,0x14(%esp)
801066c9:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801066cd:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801066d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801066d4:	89 54 24 08          	mov    %edx,0x8(%esp)
801066d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801066dc:	c7 04 24 58 87 10 80 	movl   $0x80108758,(%esp)
801066e3:	e8 b2 9c ff ff       	call   8010039a <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801066e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066ee:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801066f5:	eb 01                	jmp    801066f8 <trap+0x1f6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801066f7:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801066f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066fe:	85 c0                	test   %eax,%eax
80106700:	74 24                	je     80106726 <trap+0x224>
80106702:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106708:	8b 40 24             	mov    0x24(%eax),%eax
8010670b:	85 c0                	test   %eax,%eax
8010670d:	74 17                	je     80106726 <trap+0x224>
8010670f:	8b 45 08             	mov    0x8(%ebp),%eax
80106712:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106716:	0f b7 c0             	movzwl %ax,%eax
80106719:	83 e0 03             	and    $0x3,%eax
8010671c:	83 f8 03             	cmp    $0x3,%eax
8010671f:	75 05                	jne    80106726 <trap+0x224>
    exit();
80106721:	e8 89 de ff ff       	call   801045af <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106726:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010672c:	85 c0                	test   %eax,%eax
8010672e:	74 1e                	je     8010674e <trap+0x24c>
80106730:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106736:	8b 40 0c             	mov    0xc(%eax),%eax
80106739:	83 f8 04             	cmp    $0x4,%eax
8010673c:	75 10                	jne    8010674e <trap+0x24c>
8010673e:	8b 45 08             	mov    0x8(%ebp),%eax
80106741:	8b 40 30             	mov    0x30(%eax),%eax
80106744:	83 f8 20             	cmp    $0x20,%eax
80106747:	75 05                	jne    8010674e <trap+0x24c>
    yield();
80106749:	e8 32 e2 ff ff       	call   80104980 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010674e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106754:	85 c0                	test   %eax,%eax
80106756:	74 27                	je     8010677f <trap+0x27d>
80106758:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010675e:	8b 40 24             	mov    0x24(%eax),%eax
80106761:	85 c0                	test   %eax,%eax
80106763:	74 1a                	je     8010677f <trap+0x27d>
80106765:	8b 45 08             	mov    0x8(%ebp),%eax
80106768:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010676c:	0f b7 c0             	movzwl %ax,%eax
8010676f:	83 e0 03             	and    $0x3,%eax
80106772:	83 f8 03             	cmp    $0x3,%eax
80106775:	75 08                	jne    8010677f <trap+0x27d>
    exit();
80106777:	e8 33 de ff ff       	call   801045af <exit>
8010677c:	eb 01                	jmp    8010677f <trap+0x27d>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
8010677e:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
8010677f:	83 c4 3c             	add    $0x3c,%esp
80106782:	5b                   	pop    %ebx
80106783:	5e                   	pop    %esi
80106784:	5f                   	pop    %edi
80106785:	5d                   	pop    %ebp
80106786:	c3                   	ret    
	...

80106788 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106788:	55                   	push   %ebp
80106789:	89 e5                	mov    %esp,%ebp
8010678b:	83 ec 14             	sub    $0x14,%esp
8010678e:	8b 45 08             	mov    0x8(%ebp),%eax
80106791:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106795:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106799:	89 c2                	mov    %eax,%edx
8010679b:	ec                   	in     (%dx),%al
8010679c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010679f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801067a3:	c9                   	leave  
801067a4:	c3                   	ret    

801067a5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801067a5:	55                   	push   %ebp
801067a6:	89 e5                	mov    %esp,%ebp
801067a8:	83 ec 08             	sub    $0x8,%esp
801067ab:	8b 55 08             	mov    0x8(%ebp),%edx
801067ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801067b1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801067b5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801067b8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801067bc:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801067c0:	ee                   	out    %al,(%dx)
}
801067c1:	c9                   	leave  
801067c2:	c3                   	ret    

801067c3 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801067c3:	55                   	push   %ebp
801067c4:	89 e5                	mov    %esp,%ebp
801067c6:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801067c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067d0:	00 
801067d1:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801067d8:	e8 c8 ff ff ff       	call   801067a5 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801067dd:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801067e4:	00 
801067e5:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801067ec:	e8 b4 ff ff ff       	call   801067a5 <outb>
  outb(COM1+0, 115200/9600);
801067f1:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801067f8:	00 
801067f9:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106800:	e8 a0 ff ff ff       	call   801067a5 <outb>
  outb(COM1+1, 0);
80106805:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010680c:	00 
8010680d:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106814:	e8 8c ff ff ff       	call   801067a5 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106819:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106820:	00 
80106821:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106828:	e8 78 ff ff ff       	call   801067a5 <outb>
  outb(COM1+4, 0);
8010682d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106834:	00 
80106835:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
8010683c:	e8 64 ff ff ff       	call   801067a5 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106841:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106848:	00 
80106849:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106850:	e8 50 ff ff ff       	call   801067a5 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106855:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010685c:	e8 27 ff ff ff       	call   80106788 <inb>
80106861:	3c ff                	cmp    $0xff,%al
80106863:	74 6c                	je     801068d1 <uartinit+0x10e>
    return;
  uart = 1;
80106865:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
8010686c:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010686f:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106876:	e8 0d ff ff ff       	call   80106788 <inb>
  inb(COM1+0);
8010687b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106882:	e8 01 ff ff ff       	call   80106788 <inb>
  picenable(IRQ_COM1);
80106887:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010688e:	e8 2a d2 ff ff       	call   80103abd <picenable>
  ioapicenable(IRQ_COM1, 0);
80106893:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010689a:	00 
8010689b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801068a2:	e8 03 c1 ff ff       	call   801029aa <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801068a7:	c7 45 f4 1c 88 10 80 	movl   $0x8010881c,-0xc(%ebp)
801068ae:	eb 15                	jmp    801068c5 <uartinit+0x102>
    uartputc(*p);
801068b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b3:	0f b6 00             	movzbl (%eax),%eax
801068b6:	0f be c0             	movsbl %al,%eax
801068b9:	89 04 24             	mov    %eax,(%esp)
801068bc:	e8 13 00 00 00       	call   801068d4 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801068c1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801068c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c8:	0f b6 00             	movzbl (%eax),%eax
801068cb:	84 c0                	test   %al,%al
801068cd:	75 e1                	jne    801068b0 <uartinit+0xed>
801068cf:	eb 01                	jmp    801068d2 <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
801068d1:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
801068d2:	c9                   	leave  
801068d3:	c3                   	ret    

801068d4 <uartputc>:

void
uartputc(int c)
{
801068d4:	55                   	push   %ebp
801068d5:	89 e5                	mov    %esp,%ebp
801068d7:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801068da:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
801068df:	85 c0                	test   %eax,%eax
801068e1:	74 4d                	je     80106930 <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801068ea:	eb 10                	jmp    801068fc <uartputc+0x28>
    microdelay(10);
801068ec:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801068f3:	e8 39 c6 ff ff       	call   80102f31 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801068fc:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106900:	7f 16                	jg     80106918 <uartputc+0x44>
80106902:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106909:	e8 7a fe ff ff       	call   80106788 <inb>
8010690e:	0f b6 c0             	movzbl %al,%eax
80106911:	83 e0 20             	and    $0x20,%eax
80106914:	85 c0                	test   %eax,%eax
80106916:	74 d4                	je     801068ec <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106918:	8b 45 08             	mov    0x8(%ebp),%eax
8010691b:	0f b6 c0             	movzbl %al,%eax
8010691e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106922:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106929:	e8 77 fe ff ff       	call   801067a5 <outb>
8010692e:	eb 01                	jmp    80106931 <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106930:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106931:	c9                   	leave  
80106932:	c3                   	ret    

80106933 <uartgetc>:

static int
uartgetc(void)
{
80106933:	55                   	push   %ebp
80106934:	89 e5                	mov    %esp,%ebp
80106936:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106939:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
8010693e:	85 c0                	test   %eax,%eax
80106940:	75 07                	jne    80106949 <uartgetc+0x16>
    return -1;
80106942:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106947:	eb 2c                	jmp    80106975 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106949:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106950:	e8 33 fe ff ff       	call   80106788 <inb>
80106955:	0f b6 c0             	movzbl %al,%eax
80106958:	83 e0 01             	and    $0x1,%eax
8010695b:	85 c0                	test   %eax,%eax
8010695d:	75 07                	jne    80106966 <uartgetc+0x33>
    return -1;
8010695f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106964:	eb 0f                	jmp    80106975 <uartgetc+0x42>
  return inb(COM1+0);
80106966:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010696d:	e8 16 fe ff ff       	call   80106788 <inb>
80106972:	0f b6 c0             	movzbl %al,%eax
}
80106975:	c9                   	leave  
80106976:	c3                   	ret    

80106977 <uartintr>:

void
uartintr(void)
{
80106977:	55                   	push   %ebp
80106978:	89 e5                	mov    %esp,%ebp
8010697a:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
8010697d:	c7 04 24 33 69 10 80 	movl   $0x80106933,(%esp)
80106984:	e8 22 9e ff ff       	call   801007ab <consoleintr>
}
80106989:	c9                   	leave  
8010698a:	c3                   	ret    
	...

8010698c <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010698c:	6a 00                	push   $0x0
  pushl $0
8010698e:	6a 00                	push   $0x0
  jmp alltraps
80106990:	e9 7b f9 ff ff       	jmp    80106310 <alltraps>

80106995 <vector1>:
.globl vector1
vector1:
  pushl $0
80106995:	6a 00                	push   $0x0
  pushl $1
80106997:	6a 01                	push   $0x1
  jmp alltraps
80106999:	e9 72 f9 ff ff       	jmp    80106310 <alltraps>

8010699e <vector2>:
.globl vector2
vector2:
  pushl $0
8010699e:	6a 00                	push   $0x0
  pushl $2
801069a0:	6a 02                	push   $0x2
  jmp alltraps
801069a2:	e9 69 f9 ff ff       	jmp    80106310 <alltraps>

801069a7 <vector3>:
.globl vector3
vector3:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $3
801069a9:	6a 03                	push   $0x3
  jmp alltraps
801069ab:	e9 60 f9 ff ff       	jmp    80106310 <alltraps>

801069b0 <vector4>:
.globl vector4
vector4:
  pushl $0
801069b0:	6a 00                	push   $0x0
  pushl $4
801069b2:	6a 04                	push   $0x4
  jmp alltraps
801069b4:	e9 57 f9 ff ff       	jmp    80106310 <alltraps>

801069b9 <vector5>:
.globl vector5
vector5:
  pushl $0
801069b9:	6a 00                	push   $0x0
  pushl $5
801069bb:	6a 05                	push   $0x5
  jmp alltraps
801069bd:	e9 4e f9 ff ff       	jmp    80106310 <alltraps>

801069c2 <vector6>:
.globl vector6
vector6:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $6
801069c4:	6a 06                	push   $0x6
  jmp alltraps
801069c6:	e9 45 f9 ff ff       	jmp    80106310 <alltraps>

801069cb <vector7>:
.globl vector7
vector7:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $7
801069cd:	6a 07                	push   $0x7
  jmp alltraps
801069cf:	e9 3c f9 ff ff       	jmp    80106310 <alltraps>

801069d4 <vector8>:
.globl vector8
vector8:
  pushl $8
801069d4:	6a 08                	push   $0x8
  jmp alltraps
801069d6:	e9 35 f9 ff ff       	jmp    80106310 <alltraps>

801069db <vector9>:
.globl vector9
vector9:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $9
801069dd:	6a 09                	push   $0x9
  jmp alltraps
801069df:	e9 2c f9 ff ff       	jmp    80106310 <alltraps>

801069e4 <vector10>:
.globl vector10
vector10:
  pushl $10
801069e4:	6a 0a                	push   $0xa
  jmp alltraps
801069e6:	e9 25 f9 ff ff       	jmp    80106310 <alltraps>

801069eb <vector11>:
.globl vector11
vector11:
  pushl $11
801069eb:	6a 0b                	push   $0xb
  jmp alltraps
801069ed:	e9 1e f9 ff ff       	jmp    80106310 <alltraps>

801069f2 <vector12>:
.globl vector12
vector12:
  pushl $12
801069f2:	6a 0c                	push   $0xc
  jmp alltraps
801069f4:	e9 17 f9 ff ff       	jmp    80106310 <alltraps>

801069f9 <vector13>:
.globl vector13
vector13:
  pushl $13
801069f9:	6a 0d                	push   $0xd
  jmp alltraps
801069fb:	e9 10 f9 ff ff       	jmp    80106310 <alltraps>

80106a00 <vector14>:
.globl vector14
vector14:
  pushl $14
80106a00:	6a 0e                	push   $0xe
  jmp alltraps
80106a02:	e9 09 f9 ff ff       	jmp    80106310 <alltraps>

80106a07 <vector15>:
.globl vector15
vector15:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $15
80106a09:	6a 0f                	push   $0xf
  jmp alltraps
80106a0b:	e9 00 f9 ff ff       	jmp    80106310 <alltraps>

80106a10 <vector16>:
.globl vector16
vector16:
  pushl $0
80106a10:	6a 00                	push   $0x0
  pushl $16
80106a12:	6a 10                	push   $0x10
  jmp alltraps
80106a14:	e9 f7 f8 ff ff       	jmp    80106310 <alltraps>

80106a19 <vector17>:
.globl vector17
vector17:
  pushl $17
80106a19:	6a 11                	push   $0x11
  jmp alltraps
80106a1b:	e9 f0 f8 ff ff       	jmp    80106310 <alltraps>

80106a20 <vector18>:
.globl vector18
vector18:
  pushl $0
80106a20:	6a 00                	push   $0x0
  pushl $18
80106a22:	6a 12                	push   $0x12
  jmp alltraps
80106a24:	e9 e7 f8 ff ff       	jmp    80106310 <alltraps>

80106a29 <vector19>:
.globl vector19
vector19:
  pushl $0
80106a29:	6a 00                	push   $0x0
  pushl $19
80106a2b:	6a 13                	push   $0x13
  jmp alltraps
80106a2d:	e9 de f8 ff ff       	jmp    80106310 <alltraps>

80106a32 <vector20>:
.globl vector20
vector20:
  pushl $0
80106a32:	6a 00                	push   $0x0
  pushl $20
80106a34:	6a 14                	push   $0x14
  jmp alltraps
80106a36:	e9 d5 f8 ff ff       	jmp    80106310 <alltraps>

80106a3b <vector21>:
.globl vector21
vector21:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $21
80106a3d:	6a 15                	push   $0x15
  jmp alltraps
80106a3f:	e9 cc f8 ff ff       	jmp    80106310 <alltraps>

80106a44 <vector22>:
.globl vector22
vector22:
  pushl $0
80106a44:	6a 00                	push   $0x0
  pushl $22
80106a46:	6a 16                	push   $0x16
  jmp alltraps
80106a48:	e9 c3 f8 ff ff       	jmp    80106310 <alltraps>

80106a4d <vector23>:
.globl vector23
vector23:
  pushl $0
80106a4d:	6a 00                	push   $0x0
  pushl $23
80106a4f:	6a 17                	push   $0x17
  jmp alltraps
80106a51:	e9 ba f8 ff ff       	jmp    80106310 <alltraps>

80106a56 <vector24>:
.globl vector24
vector24:
  pushl $0
80106a56:	6a 00                	push   $0x0
  pushl $24
80106a58:	6a 18                	push   $0x18
  jmp alltraps
80106a5a:	e9 b1 f8 ff ff       	jmp    80106310 <alltraps>

80106a5f <vector25>:
.globl vector25
vector25:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $25
80106a61:	6a 19                	push   $0x19
  jmp alltraps
80106a63:	e9 a8 f8 ff ff       	jmp    80106310 <alltraps>

80106a68 <vector26>:
.globl vector26
vector26:
  pushl $0
80106a68:	6a 00                	push   $0x0
  pushl $26
80106a6a:	6a 1a                	push   $0x1a
  jmp alltraps
80106a6c:	e9 9f f8 ff ff       	jmp    80106310 <alltraps>

80106a71 <vector27>:
.globl vector27
vector27:
  pushl $0
80106a71:	6a 00                	push   $0x0
  pushl $27
80106a73:	6a 1b                	push   $0x1b
  jmp alltraps
80106a75:	e9 96 f8 ff ff       	jmp    80106310 <alltraps>

80106a7a <vector28>:
.globl vector28
vector28:
  pushl $0
80106a7a:	6a 00                	push   $0x0
  pushl $28
80106a7c:	6a 1c                	push   $0x1c
  jmp alltraps
80106a7e:	e9 8d f8 ff ff       	jmp    80106310 <alltraps>

80106a83 <vector29>:
.globl vector29
vector29:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $29
80106a85:	6a 1d                	push   $0x1d
  jmp alltraps
80106a87:	e9 84 f8 ff ff       	jmp    80106310 <alltraps>

80106a8c <vector30>:
.globl vector30
vector30:
  pushl $0
80106a8c:	6a 00                	push   $0x0
  pushl $30
80106a8e:	6a 1e                	push   $0x1e
  jmp alltraps
80106a90:	e9 7b f8 ff ff       	jmp    80106310 <alltraps>

80106a95 <vector31>:
.globl vector31
vector31:
  pushl $0
80106a95:	6a 00                	push   $0x0
  pushl $31
80106a97:	6a 1f                	push   $0x1f
  jmp alltraps
80106a99:	e9 72 f8 ff ff       	jmp    80106310 <alltraps>

80106a9e <vector32>:
.globl vector32
vector32:
  pushl $0
80106a9e:	6a 00                	push   $0x0
  pushl $32
80106aa0:	6a 20                	push   $0x20
  jmp alltraps
80106aa2:	e9 69 f8 ff ff       	jmp    80106310 <alltraps>

80106aa7 <vector33>:
.globl vector33
vector33:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $33
80106aa9:	6a 21                	push   $0x21
  jmp alltraps
80106aab:	e9 60 f8 ff ff       	jmp    80106310 <alltraps>

80106ab0 <vector34>:
.globl vector34
vector34:
  pushl $0
80106ab0:	6a 00                	push   $0x0
  pushl $34
80106ab2:	6a 22                	push   $0x22
  jmp alltraps
80106ab4:	e9 57 f8 ff ff       	jmp    80106310 <alltraps>

80106ab9 <vector35>:
.globl vector35
vector35:
  pushl $0
80106ab9:	6a 00                	push   $0x0
  pushl $35
80106abb:	6a 23                	push   $0x23
  jmp alltraps
80106abd:	e9 4e f8 ff ff       	jmp    80106310 <alltraps>

80106ac2 <vector36>:
.globl vector36
vector36:
  pushl $0
80106ac2:	6a 00                	push   $0x0
  pushl $36
80106ac4:	6a 24                	push   $0x24
  jmp alltraps
80106ac6:	e9 45 f8 ff ff       	jmp    80106310 <alltraps>

80106acb <vector37>:
.globl vector37
vector37:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $37
80106acd:	6a 25                	push   $0x25
  jmp alltraps
80106acf:	e9 3c f8 ff ff       	jmp    80106310 <alltraps>

80106ad4 <vector38>:
.globl vector38
vector38:
  pushl $0
80106ad4:	6a 00                	push   $0x0
  pushl $38
80106ad6:	6a 26                	push   $0x26
  jmp alltraps
80106ad8:	e9 33 f8 ff ff       	jmp    80106310 <alltraps>

80106add <vector39>:
.globl vector39
vector39:
  pushl $0
80106add:	6a 00                	push   $0x0
  pushl $39
80106adf:	6a 27                	push   $0x27
  jmp alltraps
80106ae1:	e9 2a f8 ff ff       	jmp    80106310 <alltraps>

80106ae6 <vector40>:
.globl vector40
vector40:
  pushl $0
80106ae6:	6a 00                	push   $0x0
  pushl $40
80106ae8:	6a 28                	push   $0x28
  jmp alltraps
80106aea:	e9 21 f8 ff ff       	jmp    80106310 <alltraps>

80106aef <vector41>:
.globl vector41
vector41:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $41
80106af1:	6a 29                	push   $0x29
  jmp alltraps
80106af3:	e9 18 f8 ff ff       	jmp    80106310 <alltraps>

80106af8 <vector42>:
.globl vector42
vector42:
  pushl $0
80106af8:	6a 00                	push   $0x0
  pushl $42
80106afa:	6a 2a                	push   $0x2a
  jmp alltraps
80106afc:	e9 0f f8 ff ff       	jmp    80106310 <alltraps>

80106b01 <vector43>:
.globl vector43
vector43:
  pushl $0
80106b01:	6a 00                	push   $0x0
  pushl $43
80106b03:	6a 2b                	push   $0x2b
  jmp alltraps
80106b05:	e9 06 f8 ff ff       	jmp    80106310 <alltraps>

80106b0a <vector44>:
.globl vector44
vector44:
  pushl $0
80106b0a:	6a 00                	push   $0x0
  pushl $44
80106b0c:	6a 2c                	push   $0x2c
  jmp alltraps
80106b0e:	e9 fd f7 ff ff       	jmp    80106310 <alltraps>

80106b13 <vector45>:
.globl vector45
vector45:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $45
80106b15:	6a 2d                	push   $0x2d
  jmp alltraps
80106b17:	e9 f4 f7 ff ff       	jmp    80106310 <alltraps>

80106b1c <vector46>:
.globl vector46
vector46:
  pushl $0
80106b1c:	6a 00                	push   $0x0
  pushl $46
80106b1e:	6a 2e                	push   $0x2e
  jmp alltraps
80106b20:	e9 eb f7 ff ff       	jmp    80106310 <alltraps>

80106b25 <vector47>:
.globl vector47
vector47:
  pushl $0
80106b25:	6a 00                	push   $0x0
  pushl $47
80106b27:	6a 2f                	push   $0x2f
  jmp alltraps
80106b29:	e9 e2 f7 ff ff       	jmp    80106310 <alltraps>

80106b2e <vector48>:
.globl vector48
vector48:
  pushl $0
80106b2e:	6a 00                	push   $0x0
  pushl $48
80106b30:	6a 30                	push   $0x30
  jmp alltraps
80106b32:	e9 d9 f7 ff ff       	jmp    80106310 <alltraps>

80106b37 <vector49>:
.globl vector49
vector49:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $49
80106b39:	6a 31                	push   $0x31
  jmp alltraps
80106b3b:	e9 d0 f7 ff ff       	jmp    80106310 <alltraps>

80106b40 <vector50>:
.globl vector50
vector50:
  pushl $0
80106b40:	6a 00                	push   $0x0
  pushl $50
80106b42:	6a 32                	push   $0x32
  jmp alltraps
80106b44:	e9 c7 f7 ff ff       	jmp    80106310 <alltraps>

80106b49 <vector51>:
.globl vector51
vector51:
  pushl $0
80106b49:	6a 00                	push   $0x0
  pushl $51
80106b4b:	6a 33                	push   $0x33
  jmp alltraps
80106b4d:	e9 be f7 ff ff       	jmp    80106310 <alltraps>

80106b52 <vector52>:
.globl vector52
vector52:
  pushl $0
80106b52:	6a 00                	push   $0x0
  pushl $52
80106b54:	6a 34                	push   $0x34
  jmp alltraps
80106b56:	e9 b5 f7 ff ff       	jmp    80106310 <alltraps>

80106b5b <vector53>:
.globl vector53
vector53:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $53
80106b5d:	6a 35                	push   $0x35
  jmp alltraps
80106b5f:	e9 ac f7 ff ff       	jmp    80106310 <alltraps>

80106b64 <vector54>:
.globl vector54
vector54:
  pushl $0
80106b64:	6a 00                	push   $0x0
  pushl $54
80106b66:	6a 36                	push   $0x36
  jmp alltraps
80106b68:	e9 a3 f7 ff ff       	jmp    80106310 <alltraps>

80106b6d <vector55>:
.globl vector55
vector55:
  pushl $0
80106b6d:	6a 00                	push   $0x0
  pushl $55
80106b6f:	6a 37                	push   $0x37
  jmp alltraps
80106b71:	e9 9a f7 ff ff       	jmp    80106310 <alltraps>

80106b76 <vector56>:
.globl vector56
vector56:
  pushl $0
80106b76:	6a 00                	push   $0x0
  pushl $56
80106b78:	6a 38                	push   $0x38
  jmp alltraps
80106b7a:	e9 91 f7 ff ff       	jmp    80106310 <alltraps>

80106b7f <vector57>:
.globl vector57
vector57:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $57
80106b81:	6a 39                	push   $0x39
  jmp alltraps
80106b83:	e9 88 f7 ff ff       	jmp    80106310 <alltraps>

80106b88 <vector58>:
.globl vector58
vector58:
  pushl $0
80106b88:	6a 00                	push   $0x0
  pushl $58
80106b8a:	6a 3a                	push   $0x3a
  jmp alltraps
80106b8c:	e9 7f f7 ff ff       	jmp    80106310 <alltraps>

80106b91 <vector59>:
.globl vector59
vector59:
  pushl $0
80106b91:	6a 00                	push   $0x0
  pushl $59
80106b93:	6a 3b                	push   $0x3b
  jmp alltraps
80106b95:	e9 76 f7 ff ff       	jmp    80106310 <alltraps>

80106b9a <vector60>:
.globl vector60
vector60:
  pushl $0
80106b9a:	6a 00                	push   $0x0
  pushl $60
80106b9c:	6a 3c                	push   $0x3c
  jmp alltraps
80106b9e:	e9 6d f7 ff ff       	jmp    80106310 <alltraps>

80106ba3 <vector61>:
.globl vector61
vector61:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $61
80106ba5:	6a 3d                	push   $0x3d
  jmp alltraps
80106ba7:	e9 64 f7 ff ff       	jmp    80106310 <alltraps>

80106bac <vector62>:
.globl vector62
vector62:
  pushl $0
80106bac:	6a 00                	push   $0x0
  pushl $62
80106bae:	6a 3e                	push   $0x3e
  jmp alltraps
80106bb0:	e9 5b f7 ff ff       	jmp    80106310 <alltraps>

80106bb5 <vector63>:
.globl vector63
vector63:
  pushl $0
80106bb5:	6a 00                	push   $0x0
  pushl $63
80106bb7:	6a 3f                	push   $0x3f
  jmp alltraps
80106bb9:	e9 52 f7 ff ff       	jmp    80106310 <alltraps>

80106bbe <vector64>:
.globl vector64
vector64:
  pushl $0
80106bbe:	6a 00                	push   $0x0
  pushl $64
80106bc0:	6a 40                	push   $0x40
  jmp alltraps
80106bc2:	e9 49 f7 ff ff       	jmp    80106310 <alltraps>

80106bc7 <vector65>:
.globl vector65
vector65:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $65
80106bc9:	6a 41                	push   $0x41
  jmp alltraps
80106bcb:	e9 40 f7 ff ff       	jmp    80106310 <alltraps>

80106bd0 <vector66>:
.globl vector66
vector66:
  pushl $0
80106bd0:	6a 00                	push   $0x0
  pushl $66
80106bd2:	6a 42                	push   $0x42
  jmp alltraps
80106bd4:	e9 37 f7 ff ff       	jmp    80106310 <alltraps>

80106bd9 <vector67>:
.globl vector67
vector67:
  pushl $0
80106bd9:	6a 00                	push   $0x0
  pushl $67
80106bdb:	6a 43                	push   $0x43
  jmp alltraps
80106bdd:	e9 2e f7 ff ff       	jmp    80106310 <alltraps>

80106be2 <vector68>:
.globl vector68
vector68:
  pushl $0
80106be2:	6a 00                	push   $0x0
  pushl $68
80106be4:	6a 44                	push   $0x44
  jmp alltraps
80106be6:	e9 25 f7 ff ff       	jmp    80106310 <alltraps>

80106beb <vector69>:
.globl vector69
vector69:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $69
80106bed:	6a 45                	push   $0x45
  jmp alltraps
80106bef:	e9 1c f7 ff ff       	jmp    80106310 <alltraps>

80106bf4 <vector70>:
.globl vector70
vector70:
  pushl $0
80106bf4:	6a 00                	push   $0x0
  pushl $70
80106bf6:	6a 46                	push   $0x46
  jmp alltraps
80106bf8:	e9 13 f7 ff ff       	jmp    80106310 <alltraps>

80106bfd <vector71>:
.globl vector71
vector71:
  pushl $0
80106bfd:	6a 00                	push   $0x0
  pushl $71
80106bff:	6a 47                	push   $0x47
  jmp alltraps
80106c01:	e9 0a f7 ff ff       	jmp    80106310 <alltraps>

80106c06 <vector72>:
.globl vector72
vector72:
  pushl $0
80106c06:	6a 00                	push   $0x0
  pushl $72
80106c08:	6a 48                	push   $0x48
  jmp alltraps
80106c0a:	e9 01 f7 ff ff       	jmp    80106310 <alltraps>

80106c0f <vector73>:
.globl vector73
vector73:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $73
80106c11:	6a 49                	push   $0x49
  jmp alltraps
80106c13:	e9 f8 f6 ff ff       	jmp    80106310 <alltraps>

80106c18 <vector74>:
.globl vector74
vector74:
  pushl $0
80106c18:	6a 00                	push   $0x0
  pushl $74
80106c1a:	6a 4a                	push   $0x4a
  jmp alltraps
80106c1c:	e9 ef f6 ff ff       	jmp    80106310 <alltraps>

80106c21 <vector75>:
.globl vector75
vector75:
  pushl $0
80106c21:	6a 00                	push   $0x0
  pushl $75
80106c23:	6a 4b                	push   $0x4b
  jmp alltraps
80106c25:	e9 e6 f6 ff ff       	jmp    80106310 <alltraps>

80106c2a <vector76>:
.globl vector76
vector76:
  pushl $0
80106c2a:	6a 00                	push   $0x0
  pushl $76
80106c2c:	6a 4c                	push   $0x4c
  jmp alltraps
80106c2e:	e9 dd f6 ff ff       	jmp    80106310 <alltraps>

80106c33 <vector77>:
.globl vector77
vector77:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $77
80106c35:	6a 4d                	push   $0x4d
  jmp alltraps
80106c37:	e9 d4 f6 ff ff       	jmp    80106310 <alltraps>

80106c3c <vector78>:
.globl vector78
vector78:
  pushl $0
80106c3c:	6a 00                	push   $0x0
  pushl $78
80106c3e:	6a 4e                	push   $0x4e
  jmp alltraps
80106c40:	e9 cb f6 ff ff       	jmp    80106310 <alltraps>

80106c45 <vector79>:
.globl vector79
vector79:
  pushl $0
80106c45:	6a 00                	push   $0x0
  pushl $79
80106c47:	6a 4f                	push   $0x4f
  jmp alltraps
80106c49:	e9 c2 f6 ff ff       	jmp    80106310 <alltraps>

80106c4e <vector80>:
.globl vector80
vector80:
  pushl $0
80106c4e:	6a 00                	push   $0x0
  pushl $80
80106c50:	6a 50                	push   $0x50
  jmp alltraps
80106c52:	e9 b9 f6 ff ff       	jmp    80106310 <alltraps>

80106c57 <vector81>:
.globl vector81
vector81:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $81
80106c59:	6a 51                	push   $0x51
  jmp alltraps
80106c5b:	e9 b0 f6 ff ff       	jmp    80106310 <alltraps>

80106c60 <vector82>:
.globl vector82
vector82:
  pushl $0
80106c60:	6a 00                	push   $0x0
  pushl $82
80106c62:	6a 52                	push   $0x52
  jmp alltraps
80106c64:	e9 a7 f6 ff ff       	jmp    80106310 <alltraps>

80106c69 <vector83>:
.globl vector83
vector83:
  pushl $0
80106c69:	6a 00                	push   $0x0
  pushl $83
80106c6b:	6a 53                	push   $0x53
  jmp alltraps
80106c6d:	e9 9e f6 ff ff       	jmp    80106310 <alltraps>

80106c72 <vector84>:
.globl vector84
vector84:
  pushl $0
80106c72:	6a 00                	push   $0x0
  pushl $84
80106c74:	6a 54                	push   $0x54
  jmp alltraps
80106c76:	e9 95 f6 ff ff       	jmp    80106310 <alltraps>

80106c7b <vector85>:
.globl vector85
vector85:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $85
80106c7d:	6a 55                	push   $0x55
  jmp alltraps
80106c7f:	e9 8c f6 ff ff       	jmp    80106310 <alltraps>

80106c84 <vector86>:
.globl vector86
vector86:
  pushl $0
80106c84:	6a 00                	push   $0x0
  pushl $86
80106c86:	6a 56                	push   $0x56
  jmp alltraps
80106c88:	e9 83 f6 ff ff       	jmp    80106310 <alltraps>

80106c8d <vector87>:
.globl vector87
vector87:
  pushl $0
80106c8d:	6a 00                	push   $0x0
  pushl $87
80106c8f:	6a 57                	push   $0x57
  jmp alltraps
80106c91:	e9 7a f6 ff ff       	jmp    80106310 <alltraps>

80106c96 <vector88>:
.globl vector88
vector88:
  pushl $0
80106c96:	6a 00                	push   $0x0
  pushl $88
80106c98:	6a 58                	push   $0x58
  jmp alltraps
80106c9a:	e9 71 f6 ff ff       	jmp    80106310 <alltraps>

80106c9f <vector89>:
.globl vector89
vector89:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $89
80106ca1:	6a 59                	push   $0x59
  jmp alltraps
80106ca3:	e9 68 f6 ff ff       	jmp    80106310 <alltraps>

80106ca8 <vector90>:
.globl vector90
vector90:
  pushl $0
80106ca8:	6a 00                	push   $0x0
  pushl $90
80106caa:	6a 5a                	push   $0x5a
  jmp alltraps
80106cac:	e9 5f f6 ff ff       	jmp    80106310 <alltraps>

80106cb1 <vector91>:
.globl vector91
vector91:
  pushl $0
80106cb1:	6a 00                	push   $0x0
  pushl $91
80106cb3:	6a 5b                	push   $0x5b
  jmp alltraps
80106cb5:	e9 56 f6 ff ff       	jmp    80106310 <alltraps>

80106cba <vector92>:
.globl vector92
vector92:
  pushl $0
80106cba:	6a 00                	push   $0x0
  pushl $92
80106cbc:	6a 5c                	push   $0x5c
  jmp alltraps
80106cbe:	e9 4d f6 ff ff       	jmp    80106310 <alltraps>

80106cc3 <vector93>:
.globl vector93
vector93:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $93
80106cc5:	6a 5d                	push   $0x5d
  jmp alltraps
80106cc7:	e9 44 f6 ff ff       	jmp    80106310 <alltraps>

80106ccc <vector94>:
.globl vector94
vector94:
  pushl $0
80106ccc:	6a 00                	push   $0x0
  pushl $94
80106cce:	6a 5e                	push   $0x5e
  jmp alltraps
80106cd0:	e9 3b f6 ff ff       	jmp    80106310 <alltraps>

80106cd5 <vector95>:
.globl vector95
vector95:
  pushl $0
80106cd5:	6a 00                	push   $0x0
  pushl $95
80106cd7:	6a 5f                	push   $0x5f
  jmp alltraps
80106cd9:	e9 32 f6 ff ff       	jmp    80106310 <alltraps>

80106cde <vector96>:
.globl vector96
vector96:
  pushl $0
80106cde:	6a 00                	push   $0x0
  pushl $96
80106ce0:	6a 60                	push   $0x60
  jmp alltraps
80106ce2:	e9 29 f6 ff ff       	jmp    80106310 <alltraps>

80106ce7 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $97
80106ce9:	6a 61                	push   $0x61
  jmp alltraps
80106ceb:	e9 20 f6 ff ff       	jmp    80106310 <alltraps>

80106cf0 <vector98>:
.globl vector98
vector98:
  pushl $0
80106cf0:	6a 00                	push   $0x0
  pushl $98
80106cf2:	6a 62                	push   $0x62
  jmp alltraps
80106cf4:	e9 17 f6 ff ff       	jmp    80106310 <alltraps>

80106cf9 <vector99>:
.globl vector99
vector99:
  pushl $0
80106cf9:	6a 00                	push   $0x0
  pushl $99
80106cfb:	6a 63                	push   $0x63
  jmp alltraps
80106cfd:	e9 0e f6 ff ff       	jmp    80106310 <alltraps>

80106d02 <vector100>:
.globl vector100
vector100:
  pushl $0
80106d02:	6a 00                	push   $0x0
  pushl $100
80106d04:	6a 64                	push   $0x64
  jmp alltraps
80106d06:	e9 05 f6 ff ff       	jmp    80106310 <alltraps>

80106d0b <vector101>:
.globl vector101
vector101:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $101
80106d0d:	6a 65                	push   $0x65
  jmp alltraps
80106d0f:	e9 fc f5 ff ff       	jmp    80106310 <alltraps>

80106d14 <vector102>:
.globl vector102
vector102:
  pushl $0
80106d14:	6a 00                	push   $0x0
  pushl $102
80106d16:	6a 66                	push   $0x66
  jmp alltraps
80106d18:	e9 f3 f5 ff ff       	jmp    80106310 <alltraps>

80106d1d <vector103>:
.globl vector103
vector103:
  pushl $0
80106d1d:	6a 00                	push   $0x0
  pushl $103
80106d1f:	6a 67                	push   $0x67
  jmp alltraps
80106d21:	e9 ea f5 ff ff       	jmp    80106310 <alltraps>

80106d26 <vector104>:
.globl vector104
vector104:
  pushl $0
80106d26:	6a 00                	push   $0x0
  pushl $104
80106d28:	6a 68                	push   $0x68
  jmp alltraps
80106d2a:	e9 e1 f5 ff ff       	jmp    80106310 <alltraps>

80106d2f <vector105>:
.globl vector105
vector105:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $105
80106d31:	6a 69                	push   $0x69
  jmp alltraps
80106d33:	e9 d8 f5 ff ff       	jmp    80106310 <alltraps>

80106d38 <vector106>:
.globl vector106
vector106:
  pushl $0
80106d38:	6a 00                	push   $0x0
  pushl $106
80106d3a:	6a 6a                	push   $0x6a
  jmp alltraps
80106d3c:	e9 cf f5 ff ff       	jmp    80106310 <alltraps>

80106d41 <vector107>:
.globl vector107
vector107:
  pushl $0
80106d41:	6a 00                	push   $0x0
  pushl $107
80106d43:	6a 6b                	push   $0x6b
  jmp alltraps
80106d45:	e9 c6 f5 ff ff       	jmp    80106310 <alltraps>

80106d4a <vector108>:
.globl vector108
vector108:
  pushl $0
80106d4a:	6a 00                	push   $0x0
  pushl $108
80106d4c:	6a 6c                	push   $0x6c
  jmp alltraps
80106d4e:	e9 bd f5 ff ff       	jmp    80106310 <alltraps>

80106d53 <vector109>:
.globl vector109
vector109:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $109
80106d55:	6a 6d                	push   $0x6d
  jmp alltraps
80106d57:	e9 b4 f5 ff ff       	jmp    80106310 <alltraps>

80106d5c <vector110>:
.globl vector110
vector110:
  pushl $0
80106d5c:	6a 00                	push   $0x0
  pushl $110
80106d5e:	6a 6e                	push   $0x6e
  jmp alltraps
80106d60:	e9 ab f5 ff ff       	jmp    80106310 <alltraps>

80106d65 <vector111>:
.globl vector111
vector111:
  pushl $0
80106d65:	6a 00                	push   $0x0
  pushl $111
80106d67:	6a 6f                	push   $0x6f
  jmp alltraps
80106d69:	e9 a2 f5 ff ff       	jmp    80106310 <alltraps>

80106d6e <vector112>:
.globl vector112
vector112:
  pushl $0
80106d6e:	6a 00                	push   $0x0
  pushl $112
80106d70:	6a 70                	push   $0x70
  jmp alltraps
80106d72:	e9 99 f5 ff ff       	jmp    80106310 <alltraps>

80106d77 <vector113>:
.globl vector113
vector113:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $113
80106d79:	6a 71                	push   $0x71
  jmp alltraps
80106d7b:	e9 90 f5 ff ff       	jmp    80106310 <alltraps>

80106d80 <vector114>:
.globl vector114
vector114:
  pushl $0
80106d80:	6a 00                	push   $0x0
  pushl $114
80106d82:	6a 72                	push   $0x72
  jmp alltraps
80106d84:	e9 87 f5 ff ff       	jmp    80106310 <alltraps>

80106d89 <vector115>:
.globl vector115
vector115:
  pushl $0
80106d89:	6a 00                	push   $0x0
  pushl $115
80106d8b:	6a 73                	push   $0x73
  jmp alltraps
80106d8d:	e9 7e f5 ff ff       	jmp    80106310 <alltraps>

80106d92 <vector116>:
.globl vector116
vector116:
  pushl $0
80106d92:	6a 00                	push   $0x0
  pushl $116
80106d94:	6a 74                	push   $0x74
  jmp alltraps
80106d96:	e9 75 f5 ff ff       	jmp    80106310 <alltraps>

80106d9b <vector117>:
.globl vector117
vector117:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $117
80106d9d:	6a 75                	push   $0x75
  jmp alltraps
80106d9f:	e9 6c f5 ff ff       	jmp    80106310 <alltraps>

80106da4 <vector118>:
.globl vector118
vector118:
  pushl $0
80106da4:	6a 00                	push   $0x0
  pushl $118
80106da6:	6a 76                	push   $0x76
  jmp alltraps
80106da8:	e9 63 f5 ff ff       	jmp    80106310 <alltraps>

80106dad <vector119>:
.globl vector119
vector119:
  pushl $0
80106dad:	6a 00                	push   $0x0
  pushl $119
80106daf:	6a 77                	push   $0x77
  jmp alltraps
80106db1:	e9 5a f5 ff ff       	jmp    80106310 <alltraps>

80106db6 <vector120>:
.globl vector120
vector120:
  pushl $0
80106db6:	6a 00                	push   $0x0
  pushl $120
80106db8:	6a 78                	push   $0x78
  jmp alltraps
80106dba:	e9 51 f5 ff ff       	jmp    80106310 <alltraps>

80106dbf <vector121>:
.globl vector121
vector121:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $121
80106dc1:	6a 79                	push   $0x79
  jmp alltraps
80106dc3:	e9 48 f5 ff ff       	jmp    80106310 <alltraps>

80106dc8 <vector122>:
.globl vector122
vector122:
  pushl $0
80106dc8:	6a 00                	push   $0x0
  pushl $122
80106dca:	6a 7a                	push   $0x7a
  jmp alltraps
80106dcc:	e9 3f f5 ff ff       	jmp    80106310 <alltraps>

80106dd1 <vector123>:
.globl vector123
vector123:
  pushl $0
80106dd1:	6a 00                	push   $0x0
  pushl $123
80106dd3:	6a 7b                	push   $0x7b
  jmp alltraps
80106dd5:	e9 36 f5 ff ff       	jmp    80106310 <alltraps>

80106dda <vector124>:
.globl vector124
vector124:
  pushl $0
80106dda:	6a 00                	push   $0x0
  pushl $124
80106ddc:	6a 7c                	push   $0x7c
  jmp alltraps
80106dde:	e9 2d f5 ff ff       	jmp    80106310 <alltraps>

80106de3 <vector125>:
.globl vector125
vector125:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $125
80106de5:	6a 7d                	push   $0x7d
  jmp alltraps
80106de7:	e9 24 f5 ff ff       	jmp    80106310 <alltraps>

80106dec <vector126>:
.globl vector126
vector126:
  pushl $0
80106dec:	6a 00                	push   $0x0
  pushl $126
80106dee:	6a 7e                	push   $0x7e
  jmp alltraps
80106df0:	e9 1b f5 ff ff       	jmp    80106310 <alltraps>

80106df5 <vector127>:
.globl vector127
vector127:
  pushl $0
80106df5:	6a 00                	push   $0x0
  pushl $127
80106df7:	6a 7f                	push   $0x7f
  jmp alltraps
80106df9:	e9 12 f5 ff ff       	jmp    80106310 <alltraps>

80106dfe <vector128>:
.globl vector128
vector128:
  pushl $0
80106dfe:	6a 00                	push   $0x0
  pushl $128
80106e00:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106e05:	e9 06 f5 ff ff       	jmp    80106310 <alltraps>

80106e0a <vector129>:
.globl vector129
vector129:
  pushl $0
80106e0a:	6a 00                	push   $0x0
  pushl $129
80106e0c:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106e11:	e9 fa f4 ff ff       	jmp    80106310 <alltraps>

80106e16 <vector130>:
.globl vector130
vector130:
  pushl $0
80106e16:	6a 00                	push   $0x0
  pushl $130
80106e18:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106e1d:	e9 ee f4 ff ff       	jmp    80106310 <alltraps>

80106e22 <vector131>:
.globl vector131
vector131:
  pushl $0
80106e22:	6a 00                	push   $0x0
  pushl $131
80106e24:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106e29:	e9 e2 f4 ff ff       	jmp    80106310 <alltraps>

80106e2e <vector132>:
.globl vector132
vector132:
  pushl $0
80106e2e:	6a 00                	push   $0x0
  pushl $132
80106e30:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106e35:	e9 d6 f4 ff ff       	jmp    80106310 <alltraps>

80106e3a <vector133>:
.globl vector133
vector133:
  pushl $0
80106e3a:	6a 00                	push   $0x0
  pushl $133
80106e3c:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106e41:	e9 ca f4 ff ff       	jmp    80106310 <alltraps>

80106e46 <vector134>:
.globl vector134
vector134:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $134
80106e48:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106e4d:	e9 be f4 ff ff       	jmp    80106310 <alltraps>

80106e52 <vector135>:
.globl vector135
vector135:
  pushl $0
80106e52:	6a 00                	push   $0x0
  pushl $135
80106e54:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106e59:	e9 b2 f4 ff ff       	jmp    80106310 <alltraps>

80106e5e <vector136>:
.globl vector136
vector136:
  pushl $0
80106e5e:	6a 00                	push   $0x0
  pushl $136
80106e60:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106e65:	e9 a6 f4 ff ff       	jmp    80106310 <alltraps>

80106e6a <vector137>:
.globl vector137
vector137:
  pushl $0
80106e6a:	6a 00                	push   $0x0
  pushl $137
80106e6c:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106e71:	e9 9a f4 ff ff       	jmp    80106310 <alltraps>

80106e76 <vector138>:
.globl vector138
vector138:
  pushl $0
80106e76:	6a 00                	push   $0x0
  pushl $138
80106e78:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106e7d:	e9 8e f4 ff ff       	jmp    80106310 <alltraps>

80106e82 <vector139>:
.globl vector139
vector139:
  pushl $0
80106e82:	6a 00                	push   $0x0
  pushl $139
80106e84:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106e89:	e9 82 f4 ff ff       	jmp    80106310 <alltraps>

80106e8e <vector140>:
.globl vector140
vector140:
  pushl $0
80106e8e:	6a 00                	push   $0x0
  pushl $140
80106e90:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106e95:	e9 76 f4 ff ff       	jmp    80106310 <alltraps>

80106e9a <vector141>:
.globl vector141
vector141:
  pushl $0
80106e9a:	6a 00                	push   $0x0
  pushl $141
80106e9c:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106ea1:	e9 6a f4 ff ff       	jmp    80106310 <alltraps>

80106ea6 <vector142>:
.globl vector142
vector142:
  pushl $0
80106ea6:	6a 00                	push   $0x0
  pushl $142
80106ea8:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106ead:	e9 5e f4 ff ff       	jmp    80106310 <alltraps>

80106eb2 <vector143>:
.globl vector143
vector143:
  pushl $0
80106eb2:	6a 00                	push   $0x0
  pushl $143
80106eb4:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106eb9:	e9 52 f4 ff ff       	jmp    80106310 <alltraps>

80106ebe <vector144>:
.globl vector144
vector144:
  pushl $0
80106ebe:	6a 00                	push   $0x0
  pushl $144
80106ec0:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106ec5:	e9 46 f4 ff ff       	jmp    80106310 <alltraps>

80106eca <vector145>:
.globl vector145
vector145:
  pushl $0
80106eca:	6a 00                	push   $0x0
  pushl $145
80106ecc:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106ed1:	e9 3a f4 ff ff       	jmp    80106310 <alltraps>

80106ed6 <vector146>:
.globl vector146
vector146:
  pushl $0
80106ed6:	6a 00                	push   $0x0
  pushl $146
80106ed8:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106edd:	e9 2e f4 ff ff       	jmp    80106310 <alltraps>

80106ee2 <vector147>:
.globl vector147
vector147:
  pushl $0
80106ee2:	6a 00                	push   $0x0
  pushl $147
80106ee4:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ee9:	e9 22 f4 ff ff       	jmp    80106310 <alltraps>

80106eee <vector148>:
.globl vector148
vector148:
  pushl $0
80106eee:	6a 00                	push   $0x0
  pushl $148
80106ef0:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ef5:	e9 16 f4 ff ff       	jmp    80106310 <alltraps>

80106efa <vector149>:
.globl vector149
vector149:
  pushl $0
80106efa:	6a 00                	push   $0x0
  pushl $149
80106efc:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106f01:	e9 0a f4 ff ff       	jmp    80106310 <alltraps>

80106f06 <vector150>:
.globl vector150
vector150:
  pushl $0
80106f06:	6a 00                	push   $0x0
  pushl $150
80106f08:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106f0d:	e9 fe f3 ff ff       	jmp    80106310 <alltraps>

80106f12 <vector151>:
.globl vector151
vector151:
  pushl $0
80106f12:	6a 00                	push   $0x0
  pushl $151
80106f14:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106f19:	e9 f2 f3 ff ff       	jmp    80106310 <alltraps>

80106f1e <vector152>:
.globl vector152
vector152:
  pushl $0
80106f1e:	6a 00                	push   $0x0
  pushl $152
80106f20:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106f25:	e9 e6 f3 ff ff       	jmp    80106310 <alltraps>

80106f2a <vector153>:
.globl vector153
vector153:
  pushl $0
80106f2a:	6a 00                	push   $0x0
  pushl $153
80106f2c:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106f31:	e9 da f3 ff ff       	jmp    80106310 <alltraps>

80106f36 <vector154>:
.globl vector154
vector154:
  pushl $0
80106f36:	6a 00                	push   $0x0
  pushl $154
80106f38:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106f3d:	e9 ce f3 ff ff       	jmp    80106310 <alltraps>

80106f42 <vector155>:
.globl vector155
vector155:
  pushl $0
80106f42:	6a 00                	push   $0x0
  pushl $155
80106f44:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106f49:	e9 c2 f3 ff ff       	jmp    80106310 <alltraps>

80106f4e <vector156>:
.globl vector156
vector156:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $156
80106f50:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106f55:	e9 b6 f3 ff ff       	jmp    80106310 <alltraps>

80106f5a <vector157>:
.globl vector157
vector157:
  pushl $0
80106f5a:	6a 00                	push   $0x0
  pushl $157
80106f5c:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106f61:	e9 aa f3 ff ff       	jmp    80106310 <alltraps>

80106f66 <vector158>:
.globl vector158
vector158:
  pushl $0
80106f66:	6a 00                	push   $0x0
  pushl $158
80106f68:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106f6d:	e9 9e f3 ff ff       	jmp    80106310 <alltraps>

80106f72 <vector159>:
.globl vector159
vector159:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $159
80106f74:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106f79:	e9 92 f3 ff ff       	jmp    80106310 <alltraps>

80106f7e <vector160>:
.globl vector160
vector160:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $160
80106f80:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106f85:	e9 86 f3 ff ff       	jmp    80106310 <alltraps>

80106f8a <vector161>:
.globl vector161
vector161:
  pushl $0
80106f8a:	6a 00                	push   $0x0
  pushl $161
80106f8c:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106f91:	e9 7a f3 ff ff       	jmp    80106310 <alltraps>

80106f96 <vector162>:
.globl vector162
vector162:
  pushl $0
80106f96:	6a 00                	push   $0x0
  pushl $162
80106f98:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106f9d:	e9 6e f3 ff ff       	jmp    80106310 <alltraps>

80106fa2 <vector163>:
.globl vector163
vector163:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $163
80106fa4:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106fa9:	e9 62 f3 ff ff       	jmp    80106310 <alltraps>

80106fae <vector164>:
.globl vector164
vector164:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $164
80106fb0:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106fb5:	e9 56 f3 ff ff       	jmp    80106310 <alltraps>

80106fba <vector165>:
.globl vector165
vector165:
  pushl $0
80106fba:	6a 00                	push   $0x0
  pushl $165
80106fbc:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106fc1:	e9 4a f3 ff ff       	jmp    80106310 <alltraps>

80106fc6 <vector166>:
.globl vector166
vector166:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $166
80106fc8:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106fcd:	e9 3e f3 ff ff       	jmp    80106310 <alltraps>

80106fd2 <vector167>:
.globl vector167
vector167:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $167
80106fd4:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106fd9:	e9 32 f3 ff ff       	jmp    80106310 <alltraps>

80106fde <vector168>:
.globl vector168
vector168:
  pushl $0
80106fde:	6a 00                	push   $0x0
  pushl $168
80106fe0:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106fe5:	e9 26 f3 ff ff       	jmp    80106310 <alltraps>

80106fea <vector169>:
.globl vector169
vector169:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $169
80106fec:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106ff1:	e9 1a f3 ff ff       	jmp    80106310 <alltraps>

80106ff6 <vector170>:
.globl vector170
vector170:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $170
80106ff8:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106ffd:	e9 0e f3 ff ff       	jmp    80106310 <alltraps>

80107002 <vector171>:
.globl vector171
vector171:
  pushl $0
80107002:	6a 00                	push   $0x0
  pushl $171
80107004:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107009:	e9 02 f3 ff ff       	jmp    80106310 <alltraps>

8010700e <vector172>:
.globl vector172
vector172:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $172
80107010:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107015:	e9 f6 f2 ff ff       	jmp    80106310 <alltraps>

8010701a <vector173>:
.globl vector173
vector173:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $173
8010701c:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107021:	e9 ea f2 ff ff       	jmp    80106310 <alltraps>

80107026 <vector174>:
.globl vector174
vector174:
  pushl $0
80107026:	6a 00                	push   $0x0
  pushl $174
80107028:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010702d:	e9 de f2 ff ff       	jmp    80106310 <alltraps>

80107032 <vector175>:
.globl vector175
vector175:
  pushl $0
80107032:	6a 00                	push   $0x0
  pushl $175
80107034:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107039:	e9 d2 f2 ff ff       	jmp    80106310 <alltraps>

8010703e <vector176>:
.globl vector176
vector176:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $176
80107040:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107045:	e9 c6 f2 ff ff       	jmp    80106310 <alltraps>

8010704a <vector177>:
.globl vector177
vector177:
  pushl $0
8010704a:	6a 00                	push   $0x0
  pushl $177
8010704c:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107051:	e9 ba f2 ff ff       	jmp    80106310 <alltraps>

80107056 <vector178>:
.globl vector178
vector178:
  pushl $0
80107056:	6a 00                	push   $0x0
  pushl $178
80107058:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010705d:	e9 ae f2 ff ff       	jmp    80106310 <alltraps>

80107062 <vector179>:
.globl vector179
vector179:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $179
80107064:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107069:	e9 a2 f2 ff ff       	jmp    80106310 <alltraps>

8010706e <vector180>:
.globl vector180
vector180:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $180
80107070:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107075:	e9 96 f2 ff ff       	jmp    80106310 <alltraps>

8010707a <vector181>:
.globl vector181
vector181:
  pushl $0
8010707a:	6a 00                	push   $0x0
  pushl $181
8010707c:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107081:	e9 8a f2 ff ff       	jmp    80106310 <alltraps>

80107086 <vector182>:
.globl vector182
vector182:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $182
80107088:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010708d:	e9 7e f2 ff ff       	jmp    80106310 <alltraps>

80107092 <vector183>:
.globl vector183
vector183:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $183
80107094:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107099:	e9 72 f2 ff ff       	jmp    80106310 <alltraps>

8010709e <vector184>:
.globl vector184
vector184:
  pushl $0
8010709e:	6a 00                	push   $0x0
  pushl $184
801070a0:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801070a5:	e9 66 f2 ff ff       	jmp    80106310 <alltraps>

801070aa <vector185>:
.globl vector185
vector185:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $185
801070ac:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801070b1:	e9 5a f2 ff ff       	jmp    80106310 <alltraps>

801070b6 <vector186>:
.globl vector186
vector186:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $186
801070b8:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801070bd:	e9 4e f2 ff ff       	jmp    80106310 <alltraps>

801070c2 <vector187>:
.globl vector187
vector187:
  pushl $0
801070c2:	6a 00                	push   $0x0
  pushl $187
801070c4:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801070c9:	e9 42 f2 ff ff       	jmp    80106310 <alltraps>

801070ce <vector188>:
.globl vector188
vector188:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $188
801070d0:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801070d5:	e9 36 f2 ff ff       	jmp    80106310 <alltraps>

801070da <vector189>:
.globl vector189
vector189:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $189
801070dc:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801070e1:	e9 2a f2 ff ff       	jmp    80106310 <alltraps>

801070e6 <vector190>:
.globl vector190
vector190:
  pushl $0
801070e6:	6a 00                	push   $0x0
  pushl $190
801070e8:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801070ed:	e9 1e f2 ff ff       	jmp    80106310 <alltraps>

801070f2 <vector191>:
.globl vector191
vector191:
  pushl $0
801070f2:	6a 00                	push   $0x0
  pushl $191
801070f4:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801070f9:	e9 12 f2 ff ff       	jmp    80106310 <alltraps>

801070fe <vector192>:
.globl vector192
vector192:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $192
80107100:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107105:	e9 06 f2 ff ff       	jmp    80106310 <alltraps>

8010710a <vector193>:
.globl vector193
vector193:
  pushl $0
8010710a:	6a 00                	push   $0x0
  pushl $193
8010710c:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107111:	e9 fa f1 ff ff       	jmp    80106310 <alltraps>

80107116 <vector194>:
.globl vector194
vector194:
  pushl $0
80107116:	6a 00                	push   $0x0
  pushl $194
80107118:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010711d:	e9 ee f1 ff ff       	jmp    80106310 <alltraps>

80107122 <vector195>:
.globl vector195
vector195:
  pushl $0
80107122:	6a 00                	push   $0x0
  pushl $195
80107124:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107129:	e9 e2 f1 ff ff       	jmp    80106310 <alltraps>

8010712e <vector196>:
.globl vector196
vector196:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $196
80107130:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107135:	e9 d6 f1 ff ff       	jmp    80106310 <alltraps>

8010713a <vector197>:
.globl vector197
vector197:
  pushl $0
8010713a:	6a 00                	push   $0x0
  pushl $197
8010713c:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107141:	e9 ca f1 ff ff       	jmp    80106310 <alltraps>

80107146 <vector198>:
.globl vector198
vector198:
  pushl $0
80107146:	6a 00                	push   $0x0
  pushl $198
80107148:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010714d:	e9 be f1 ff ff       	jmp    80106310 <alltraps>

80107152 <vector199>:
.globl vector199
vector199:
  pushl $0
80107152:	6a 00                	push   $0x0
  pushl $199
80107154:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107159:	e9 b2 f1 ff ff       	jmp    80106310 <alltraps>

8010715e <vector200>:
.globl vector200
vector200:
  pushl $0
8010715e:	6a 00                	push   $0x0
  pushl $200
80107160:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107165:	e9 a6 f1 ff ff       	jmp    80106310 <alltraps>

8010716a <vector201>:
.globl vector201
vector201:
  pushl $0
8010716a:	6a 00                	push   $0x0
  pushl $201
8010716c:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107171:	e9 9a f1 ff ff       	jmp    80106310 <alltraps>

80107176 <vector202>:
.globl vector202
vector202:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $202
80107178:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010717d:	e9 8e f1 ff ff       	jmp    80106310 <alltraps>

80107182 <vector203>:
.globl vector203
vector203:
  pushl $0
80107182:	6a 00                	push   $0x0
  pushl $203
80107184:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107189:	e9 82 f1 ff ff       	jmp    80106310 <alltraps>

8010718e <vector204>:
.globl vector204
vector204:
  pushl $0
8010718e:	6a 00                	push   $0x0
  pushl $204
80107190:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107195:	e9 76 f1 ff ff       	jmp    80106310 <alltraps>

8010719a <vector205>:
.globl vector205
vector205:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $205
8010719c:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801071a1:	e9 6a f1 ff ff       	jmp    80106310 <alltraps>

801071a6 <vector206>:
.globl vector206
vector206:
  pushl $0
801071a6:	6a 00                	push   $0x0
  pushl $206
801071a8:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801071ad:	e9 5e f1 ff ff       	jmp    80106310 <alltraps>

801071b2 <vector207>:
.globl vector207
vector207:
  pushl $0
801071b2:	6a 00                	push   $0x0
  pushl $207
801071b4:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801071b9:	e9 52 f1 ff ff       	jmp    80106310 <alltraps>

801071be <vector208>:
.globl vector208
vector208:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $208
801071c0:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801071c5:	e9 46 f1 ff ff       	jmp    80106310 <alltraps>

801071ca <vector209>:
.globl vector209
vector209:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $209
801071cc:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801071d1:	e9 3a f1 ff ff       	jmp    80106310 <alltraps>

801071d6 <vector210>:
.globl vector210
vector210:
  pushl $0
801071d6:	6a 00                	push   $0x0
  pushl $210
801071d8:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801071dd:	e9 2e f1 ff ff       	jmp    80106310 <alltraps>

801071e2 <vector211>:
.globl vector211
vector211:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $211
801071e4:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801071e9:	e9 22 f1 ff ff       	jmp    80106310 <alltraps>

801071ee <vector212>:
.globl vector212
vector212:
  pushl $0
801071ee:	6a 00                	push   $0x0
  pushl $212
801071f0:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801071f5:	e9 16 f1 ff ff       	jmp    80106310 <alltraps>

801071fa <vector213>:
.globl vector213
vector213:
  pushl $0
801071fa:	6a 00                	push   $0x0
  pushl $213
801071fc:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107201:	e9 0a f1 ff ff       	jmp    80106310 <alltraps>

80107206 <vector214>:
.globl vector214
vector214:
  pushl $0
80107206:	6a 00                	push   $0x0
  pushl $214
80107208:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010720d:	e9 fe f0 ff ff       	jmp    80106310 <alltraps>

80107212 <vector215>:
.globl vector215
vector215:
  pushl $0
80107212:	6a 00                	push   $0x0
  pushl $215
80107214:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107219:	e9 f2 f0 ff ff       	jmp    80106310 <alltraps>

8010721e <vector216>:
.globl vector216
vector216:
  pushl $0
8010721e:	6a 00                	push   $0x0
  pushl $216
80107220:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107225:	e9 e6 f0 ff ff       	jmp    80106310 <alltraps>

8010722a <vector217>:
.globl vector217
vector217:
  pushl $0
8010722a:	6a 00                	push   $0x0
  pushl $217
8010722c:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107231:	e9 da f0 ff ff       	jmp    80106310 <alltraps>

80107236 <vector218>:
.globl vector218
vector218:
  pushl $0
80107236:	6a 00                	push   $0x0
  pushl $218
80107238:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010723d:	e9 ce f0 ff ff       	jmp    80106310 <alltraps>

80107242 <vector219>:
.globl vector219
vector219:
  pushl $0
80107242:	6a 00                	push   $0x0
  pushl $219
80107244:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107249:	e9 c2 f0 ff ff       	jmp    80106310 <alltraps>

8010724e <vector220>:
.globl vector220
vector220:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $220
80107250:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107255:	e9 b6 f0 ff ff       	jmp    80106310 <alltraps>

8010725a <vector221>:
.globl vector221
vector221:
  pushl $0
8010725a:	6a 00                	push   $0x0
  pushl $221
8010725c:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107261:	e9 aa f0 ff ff       	jmp    80106310 <alltraps>

80107266 <vector222>:
.globl vector222
vector222:
  pushl $0
80107266:	6a 00                	push   $0x0
  pushl $222
80107268:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010726d:	e9 9e f0 ff ff       	jmp    80106310 <alltraps>

80107272 <vector223>:
.globl vector223
vector223:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $223
80107274:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107279:	e9 92 f0 ff ff       	jmp    80106310 <alltraps>

8010727e <vector224>:
.globl vector224
vector224:
  pushl $0
8010727e:	6a 00                	push   $0x0
  pushl $224
80107280:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107285:	e9 86 f0 ff ff       	jmp    80106310 <alltraps>

8010728a <vector225>:
.globl vector225
vector225:
  pushl $0
8010728a:	6a 00                	push   $0x0
  pushl $225
8010728c:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107291:	e9 7a f0 ff ff       	jmp    80106310 <alltraps>

80107296 <vector226>:
.globl vector226
vector226:
  pushl $0
80107296:	6a 00                	push   $0x0
  pushl $226
80107298:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010729d:	e9 6e f0 ff ff       	jmp    80106310 <alltraps>

801072a2 <vector227>:
.globl vector227
vector227:
  pushl $0
801072a2:	6a 00                	push   $0x0
  pushl $227
801072a4:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801072a9:	e9 62 f0 ff ff       	jmp    80106310 <alltraps>

801072ae <vector228>:
.globl vector228
vector228:
  pushl $0
801072ae:	6a 00                	push   $0x0
  pushl $228
801072b0:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801072b5:	e9 56 f0 ff ff       	jmp    80106310 <alltraps>

801072ba <vector229>:
.globl vector229
vector229:
  pushl $0
801072ba:	6a 00                	push   $0x0
  pushl $229
801072bc:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801072c1:	e9 4a f0 ff ff       	jmp    80106310 <alltraps>

801072c6 <vector230>:
.globl vector230
vector230:
  pushl $0
801072c6:	6a 00                	push   $0x0
  pushl $230
801072c8:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801072cd:	e9 3e f0 ff ff       	jmp    80106310 <alltraps>

801072d2 <vector231>:
.globl vector231
vector231:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $231
801072d4:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801072d9:	e9 32 f0 ff ff       	jmp    80106310 <alltraps>

801072de <vector232>:
.globl vector232
vector232:
  pushl $0
801072de:	6a 00                	push   $0x0
  pushl $232
801072e0:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801072e5:	e9 26 f0 ff ff       	jmp    80106310 <alltraps>

801072ea <vector233>:
.globl vector233
vector233:
  pushl $0
801072ea:	6a 00                	push   $0x0
  pushl $233
801072ec:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801072f1:	e9 1a f0 ff ff       	jmp    80106310 <alltraps>

801072f6 <vector234>:
.globl vector234
vector234:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $234
801072f8:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801072fd:	e9 0e f0 ff ff       	jmp    80106310 <alltraps>

80107302 <vector235>:
.globl vector235
vector235:
  pushl $0
80107302:	6a 00                	push   $0x0
  pushl $235
80107304:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107309:	e9 02 f0 ff ff       	jmp    80106310 <alltraps>

8010730e <vector236>:
.globl vector236
vector236:
  pushl $0
8010730e:	6a 00                	push   $0x0
  pushl $236
80107310:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107315:	e9 f6 ef ff ff       	jmp    80106310 <alltraps>

8010731a <vector237>:
.globl vector237
vector237:
  pushl $0
8010731a:	6a 00                	push   $0x0
  pushl $237
8010731c:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107321:	e9 ea ef ff ff       	jmp    80106310 <alltraps>

80107326 <vector238>:
.globl vector238
vector238:
  pushl $0
80107326:	6a 00                	push   $0x0
  pushl $238
80107328:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010732d:	e9 de ef ff ff       	jmp    80106310 <alltraps>

80107332 <vector239>:
.globl vector239
vector239:
  pushl $0
80107332:	6a 00                	push   $0x0
  pushl $239
80107334:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107339:	e9 d2 ef ff ff       	jmp    80106310 <alltraps>

8010733e <vector240>:
.globl vector240
vector240:
  pushl $0
8010733e:	6a 00                	push   $0x0
  pushl $240
80107340:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107345:	e9 c6 ef ff ff       	jmp    80106310 <alltraps>

8010734a <vector241>:
.globl vector241
vector241:
  pushl $0
8010734a:	6a 00                	push   $0x0
  pushl $241
8010734c:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107351:	e9 ba ef ff ff       	jmp    80106310 <alltraps>

80107356 <vector242>:
.globl vector242
vector242:
  pushl $0
80107356:	6a 00                	push   $0x0
  pushl $242
80107358:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010735d:	e9 ae ef ff ff       	jmp    80106310 <alltraps>

80107362 <vector243>:
.globl vector243
vector243:
  pushl $0
80107362:	6a 00                	push   $0x0
  pushl $243
80107364:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107369:	e9 a2 ef ff ff       	jmp    80106310 <alltraps>

8010736e <vector244>:
.globl vector244
vector244:
  pushl $0
8010736e:	6a 00                	push   $0x0
  pushl $244
80107370:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107375:	e9 96 ef ff ff       	jmp    80106310 <alltraps>

8010737a <vector245>:
.globl vector245
vector245:
  pushl $0
8010737a:	6a 00                	push   $0x0
  pushl $245
8010737c:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107381:	e9 8a ef ff ff       	jmp    80106310 <alltraps>

80107386 <vector246>:
.globl vector246
vector246:
  pushl $0
80107386:	6a 00                	push   $0x0
  pushl $246
80107388:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010738d:	e9 7e ef ff ff       	jmp    80106310 <alltraps>

80107392 <vector247>:
.globl vector247
vector247:
  pushl $0
80107392:	6a 00                	push   $0x0
  pushl $247
80107394:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107399:	e9 72 ef ff ff       	jmp    80106310 <alltraps>

8010739e <vector248>:
.globl vector248
vector248:
  pushl $0
8010739e:	6a 00                	push   $0x0
  pushl $248
801073a0:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801073a5:	e9 66 ef ff ff       	jmp    80106310 <alltraps>

801073aa <vector249>:
.globl vector249
vector249:
  pushl $0
801073aa:	6a 00                	push   $0x0
  pushl $249
801073ac:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801073b1:	e9 5a ef ff ff       	jmp    80106310 <alltraps>

801073b6 <vector250>:
.globl vector250
vector250:
  pushl $0
801073b6:	6a 00                	push   $0x0
  pushl $250
801073b8:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801073bd:	e9 4e ef ff ff       	jmp    80106310 <alltraps>

801073c2 <vector251>:
.globl vector251
vector251:
  pushl $0
801073c2:	6a 00                	push   $0x0
  pushl $251
801073c4:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801073c9:	e9 42 ef ff ff       	jmp    80106310 <alltraps>

801073ce <vector252>:
.globl vector252
vector252:
  pushl $0
801073ce:	6a 00                	push   $0x0
  pushl $252
801073d0:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801073d5:	e9 36 ef ff ff       	jmp    80106310 <alltraps>

801073da <vector253>:
.globl vector253
vector253:
  pushl $0
801073da:	6a 00                	push   $0x0
  pushl $253
801073dc:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801073e1:	e9 2a ef ff ff       	jmp    80106310 <alltraps>

801073e6 <vector254>:
.globl vector254
vector254:
  pushl $0
801073e6:	6a 00                	push   $0x0
  pushl $254
801073e8:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801073ed:	e9 1e ef ff ff       	jmp    80106310 <alltraps>

801073f2 <vector255>:
.globl vector255
vector255:
  pushl $0
801073f2:	6a 00                	push   $0x0
  pushl $255
801073f4:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801073f9:	e9 12 ef ff ff       	jmp    80106310 <alltraps>
	...

80107400 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107406:	8b 45 0c             	mov    0xc(%ebp),%eax
80107409:	83 e8 01             	sub    $0x1,%eax
8010740c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107410:	8b 45 08             	mov    0x8(%ebp),%eax
80107413:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107417:	8b 45 08             	mov    0x8(%ebp),%eax
8010741a:	c1 e8 10             	shr    $0x10,%eax
8010741d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107421:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107424:	0f 01 10             	lgdtl  (%eax)
}
80107427:	c9                   	leave  
80107428:	c3                   	ret    

80107429 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107429:	55                   	push   %ebp
8010742a:	89 e5                	mov    %esp,%ebp
8010742c:	83 ec 04             	sub    $0x4,%esp
8010742f:	8b 45 08             	mov    0x8(%ebp),%eax
80107432:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107436:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010743a:	0f 00 d8             	ltr    %ax
}
8010743d:	c9                   	leave  
8010743e:	c3                   	ret    

8010743f <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
8010743f:	55                   	push   %ebp
80107440:	89 e5                	mov    %esp,%ebp
80107442:	83 ec 04             	sub    $0x4,%esp
80107445:	8b 45 08             	mov    0x8(%ebp),%eax
80107448:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
8010744c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107450:	8e e8                	mov    %eax,%gs
}
80107452:	c9                   	leave  
80107453:	c3                   	ret    

80107454 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107454:	55                   	push   %ebp
80107455:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107457:	8b 45 08             	mov    0x8(%ebp),%eax
8010745a:	0f 22 d8             	mov    %eax,%cr3
}
8010745d:	5d                   	pop    %ebp
8010745e:	c3                   	ret    

8010745f <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010745f:	55                   	push   %ebp
80107460:	89 e5                	mov    %esp,%ebp
80107462:	8b 45 08             	mov    0x8(%ebp),%eax
80107465:	2d 00 00 00 80       	sub    $0x80000000,%eax
8010746a:	5d                   	pop    %ebp
8010746b:	c3                   	ret    

8010746c <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010746c:	55                   	push   %ebp
8010746d:	89 e5                	mov    %esp,%ebp
8010746f:	8b 45 08             	mov    0x8(%ebp),%eax
80107472:	2d 00 00 00 80       	sub    $0x80000000,%eax
80107477:	5d                   	pop    %ebp
80107478:	c3                   	ret    

80107479 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107479:	55                   	push   %ebp
8010747a:	89 e5                	mov    %esp,%ebp
8010747c:	53                   	push   %ebx
8010747d:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107480:	e8 2b ba ff ff       	call   80102eb0 <cpunum>
80107485:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010748b:	05 20 f9 10 80       	add    $0x8010f920,%eax
80107490:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107496:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010749c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010749f:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801074a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a8:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801074ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074af:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801074b3:	83 e2 f0             	and    $0xfffffff0,%edx
801074b6:	83 ca 0a             	or     $0xa,%edx
801074b9:	88 50 7d             	mov    %dl,0x7d(%eax)
801074bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074bf:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801074c3:	83 ca 10             	or     $0x10,%edx
801074c6:	88 50 7d             	mov    %dl,0x7d(%eax)
801074c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074cc:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801074d0:	83 e2 9f             	and    $0xffffff9f,%edx
801074d3:	88 50 7d             	mov    %dl,0x7d(%eax)
801074d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d9:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801074dd:	83 ca 80             	or     $0xffffff80,%edx
801074e0:	88 50 7d             	mov    %dl,0x7d(%eax)
801074e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801074ea:	83 ca 0f             	or     $0xf,%edx
801074ed:	88 50 7e             	mov    %dl,0x7e(%eax)
801074f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801074f7:	83 e2 ef             	and    $0xffffffef,%edx
801074fa:	88 50 7e             	mov    %dl,0x7e(%eax)
801074fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107500:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107504:	83 e2 df             	and    $0xffffffdf,%edx
80107507:	88 50 7e             	mov    %dl,0x7e(%eax)
8010750a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107511:	83 ca 40             	or     $0x40,%edx
80107514:	88 50 7e             	mov    %dl,0x7e(%eax)
80107517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010751a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010751e:	83 ca 80             	or     $0xffffff80,%edx
80107521:	88 50 7e             	mov    %dl,0x7e(%eax)
80107524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107527:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010752b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010752e:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107535:	ff ff 
80107537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010753a:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107541:	00 00 
80107543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107546:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010754d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107550:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107557:	83 e2 f0             	and    $0xfffffff0,%edx
8010755a:	83 ca 02             	or     $0x2,%edx
8010755d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107566:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010756d:	83 ca 10             	or     $0x10,%edx
80107570:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107576:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107579:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107580:	83 e2 9f             	and    $0xffffff9f,%edx
80107583:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107589:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010758c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107593:	83 ca 80             	or     $0xffffff80,%edx
80107596:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010759c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010759f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801075a6:	83 ca 0f             	or     $0xf,%edx
801075a9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b2:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801075b9:	83 e2 ef             	and    $0xffffffef,%edx
801075bc:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801075cc:	83 e2 df             	and    $0xffffffdf,%edx
801075cf:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d8:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801075df:	83 ca 40             	or     $0x40,%edx
801075e2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075eb:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801075f2:	83 ca 80             	or     $0xffffff80,%edx
801075f5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075fe:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107605:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107608:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010760f:	ff ff 
80107611:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107614:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010761b:	00 00 
8010761d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107620:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107627:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010762a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107631:	83 e2 f0             	and    $0xfffffff0,%edx
80107634:	83 ca 0a             	or     $0xa,%edx
80107637:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010763d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107640:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107647:	83 ca 10             	or     $0x10,%edx
8010764a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107650:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107653:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010765a:	83 ca 60             	or     $0x60,%edx
8010765d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107663:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107666:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010766d:	83 ca 80             	or     $0xffffff80,%edx
80107670:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107679:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107680:	83 ca 0f             	or     $0xf,%edx
80107683:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107689:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010768c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107693:	83 e2 ef             	and    $0xffffffef,%edx
80107696:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010769c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076a6:	83 e2 df             	and    $0xffffffdf,%edx
801076a9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b2:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076b9:	83 ca 40             	or     $0x40,%edx
801076bc:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076cc:	83 ca 80             	or     $0xffffff80,%edx
801076cf:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d8:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801076df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e2:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801076e9:	ff ff 
801076eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ee:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801076f5:	00 00 
801076f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076fa:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107704:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010770b:	83 e2 f0             	and    $0xfffffff0,%edx
8010770e:	83 ca 02             	or     $0x2,%edx
80107711:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010771a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107721:	83 ca 10             	or     $0x10,%edx
80107724:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010772a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010772d:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107734:	83 ca 60             	or     $0x60,%edx
80107737:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010773d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107740:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107747:	83 ca 80             	or     $0xffffff80,%edx
8010774a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107750:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107753:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010775a:	83 ca 0f             	or     $0xf,%edx
8010775d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107766:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010776d:	83 e2 ef             	and    $0xffffffef,%edx
80107770:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107779:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107780:	83 e2 df             	and    $0xffffffdf,%edx
80107783:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107789:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010778c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107793:	83 ca 40             	or     $0x40,%edx
80107796:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010779c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801077a6:	83 ca 80             	or     $0xffffff80,%edx
801077a9:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801077af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b2:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801077b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077bc:	05 b4 00 00 00       	add    $0xb4,%eax
801077c1:	89 c3                	mov    %eax,%ebx
801077c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c6:	05 b4 00 00 00       	add    $0xb4,%eax
801077cb:	c1 e8 10             	shr    $0x10,%eax
801077ce:	89 c1                	mov    %eax,%ecx
801077d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d3:	05 b4 00 00 00       	add    $0xb4,%eax
801077d8:	c1 e8 18             	shr    $0x18,%eax
801077db:	89 c2                	mov    %eax,%edx
801077dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e0:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801077e7:	00 00 
801077e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ec:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801077f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f6:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801077fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ff:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107806:	83 e1 f0             	and    $0xfffffff0,%ecx
80107809:	83 c9 02             	or     $0x2,%ecx
8010780c:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107812:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107815:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010781c:	83 c9 10             	or     $0x10,%ecx
8010781f:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107828:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010782f:	83 e1 9f             	and    $0xffffff9f,%ecx
80107832:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010783b:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107842:	83 c9 80             	or     $0xffffff80,%ecx
80107845:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010784b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784e:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107855:	83 e1 f0             	and    $0xfffffff0,%ecx
80107858:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010785e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107861:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107868:	83 e1 ef             	and    $0xffffffef,%ecx
8010786b:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107874:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010787b:	83 e1 df             	and    $0xffffffdf,%ecx
8010787e:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107884:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107887:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010788e:	83 c9 40             	or     $0x40,%ecx
80107891:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010789a:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801078a1:	83 c9 80             	or     $0xffffff80,%ecx
801078a4:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801078aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ad:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801078b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b6:	83 c0 70             	add    $0x70,%eax
801078b9:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
801078c0:	00 
801078c1:	89 04 24             	mov    %eax,(%esp)
801078c4:	e8 37 fb ff ff       	call   80107400 <lgdt>
  loadgs(SEG_KCPU << 3);
801078c9:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
801078d0:	e8 6a fb ff ff       	call   8010743f <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
801078d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d8:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801078de:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801078e5:	00 00 00 00 
}
801078e9:	83 c4 24             	add    $0x24,%esp
801078ec:	5b                   	pop    %ebx
801078ed:	5d                   	pop    %ebp
801078ee:	c3                   	ret    

801078ef <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801078ef:	55                   	push   %ebp
801078f0:	89 e5                	mov    %esp,%ebp
801078f2:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801078f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801078f8:	c1 e8 16             	shr    $0x16,%eax
801078fb:	c1 e0 02             	shl    $0x2,%eax
801078fe:	03 45 08             	add    0x8(%ebp),%eax
80107901:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107904:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107907:	8b 00                	mov    (%eax),%eax
80107909:	83 e0 01             	and    $0x1,%eax
8010790c:	84 c0                	test   %al,%al
8010790e:	74 17                	je     80107927 <walkpgdir+0x38>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107910:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107913:	8b 00                	mov    (%eax),%eax
80107915:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010791a:	89 04 24             	mov    %eax,(%esp)
8010791d:	e8 4a fb ff ff       	call   8010746c <p2v>
80107922:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107925:	eb 4b                	jmp    80107972 <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107927:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010792b:	74 0e                	je     8010793b <walkpgdir+0x4c>
8010792d:	e8 04 b2 ff ff       	call   80102b36 <kalloc>
80107932:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107939:	75 07                	jne    80107942 <walkpgdir+0x53>
      return 0;
8010793b:	b8 00 00 00 00       	mov    $0x0,%eax
80107940:	eb 41                	jmp    80107983 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107942:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107949:	00 
8010794a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107951:	00 
80107952:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107955:	89 04 24             	mov    %eax,(%esp)
80107958:	e8 cd d5 ff ff       	call   80104f2a <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
8010795d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107960:	89 04 24             	mov    %eax,(%esp)
80107963:	e8 f7 fa ff ff       	call   8010745f <v2p>
80107968:	89 c2                	mov    %eax,%edx
8010796a:	83 ca 07             	or     $0x7,%edx
8010796d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107970:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107972:	8b 45 0c             	mov    0xc(%ebp),%eax
80107975:	c1 e8 0c             	shr    $0xc,%eax
80107978:	25 ff 03 00 00       	and    $0x3ff,%eax
8010797d:	c1 e0 02             	shl    $0x2,%eax
80107980:	03 45 f4             	add    -0xc(%ebp),%eax
}
80107983:	c9                   	leave  
80107984:	c3                   	ret    

80107985 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107985:	55                   	push   %ebp
80107986:	89 e5                	mov    %esp,%ebp
80107988:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010798b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010798e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107993:	89 45 ec             	mov    %eax,-0x14(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107996:	8b 45 0c             	mov    0xc(%ebp),%eax
80107999:	03 45 10             	add    0x10(%ebp),%eax
8010799c:	83 e8 01             	sub    $0x1,%eax
8010799f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801079a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801079ae:	00 
801079af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801079b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801079b6:	8b 45 08             	mov    0x8(%ebp),%eax
801079b9:	89 04 24             	mov    %eax,(%esp)
801079bc:	e8 2e ff ff ff       	call   801078ef <walkpgdir>
801079c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801079c8:	75 07                	jne    801079d1 <mappages+0x4c>
      return -1;
801079ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079cf:	eb 46                	jmp    80107a17 <mappages+0x92>
    if(*pte & PTE_P)
801079d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d4:	8b 00                	mov    (%eax),%eax
801079d6:	83 e0 01             	and    $0x1,%eax
801079d9:	84 c0                	test   %al,%al
801079db:	74 0c                	je     801079e9 <mappages+0x64>
      panic("remap");
801079dd:	c7 04 24 24 88 10 80 	movl   $0x80108824,(%esp)
801079e4:	e8 51 8b ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
801079e9:	8b 45 18             	mov    0x18(%ebp),%eax
801079ec:	0b 45 14             	or     0x14(%ebp),%eax
801079ef:	89 c2                	mov    %eax,%edx
801079f1:	83 ca 01             	or     $0x1,%edx
801079f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f7:	89 10                	mov    %edx,(%eax)
    if(a == last)
801079f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801079fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801079ff:	74 10                	je     80107a11 <mappages+0x8c>
      break;
    a += PGSIZE;
80107a01:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
    pa += PGSIZE;
80107a08:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107a0f:	eb 96                	jmp    801079a7 <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107a11:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107a12:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107a17:	c9                   	leave  
80107a18:	c3                   	ret    

80107a19 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107a19:	55                   	push   %ebp
80107a1a:	89 e5                	mov    %esp,%ebp
80107a1c:	53                   	push   %ebx
80107a1d:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107a20:	e8 11 b1 ff ff       	call   80102b36 <kalloc>
80107a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a2c:	75 0a                	jne    80107a38 <setupkvm+0x1f>
    return 0;
80107a2e:	b8 00 00 00 00       	mov    $0x0,%eax
80107a33:	e9 99 00 00 00       	jmp    80107ad1 <setupkvm+0xb8>
  memset(pgdir, 0, PGSIZE);
80107a38:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107a3f:	00 
80107a40:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107a47:	00 
80107a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a4b:	89 04 24             	mov    %eax,(%esp)
80107a4e:	e8 d7 d4 ff ff       	call   80104f2a <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107a53:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107a5a:	e8 0d fa ff ff       	call   8010746c <p2v>
80107a5f:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107a64:	76 0c                	jbe    80107a72 <setupkvm+0x59>
    panic("PHYSTOP too high");
80107a66:	c7 04 24 2a 88 10 80 	movl   $0x8010882a,(%esp)
80107a6d:	e8 c8 8a ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a72:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107a79:	eb 49                	jmp    80107ac4 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a7e:	8b 48 0c             	mov    0xc(%eax),%ecx
80107a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a84:	8b 50 04             	mov    0x4(%eax),%edx
80107a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8a:	8b 58 08             	mov    0x8(%eax),%ebx
80107a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a90:	8b 40 04             	mov    0x4(%eax),%eax
80107a93:	29 c3                	sub    %eax,%ebx
80107a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a98:	8b 00                	mov    (%eax),%eax
80107a9a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107a9e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107aa2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
80107aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107aad:	89 04 24             	mov    %eax,(%esp)
80107ab0:	e8 d0 fe ff ff       	call   80107985 <mappages>
80107ab5:	85 c0                	test   %eax,%eax
80107ab7:	79 07                	jns    80107ac0 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107ab9:	b8 00 00 00 00       	mov    $0x0,%eax
80107abe:	eb 11                	jmp    80107ad1 <setupkvm+0xb8>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ac0:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107ac4:	b8 e0 b4 10 80       	mov    $0x8010b4e0,%eax
80107ac9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80107acc:	72 ad                	jb     80107a7b <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107ad1:	83 c4 34             	add    $0x34,%esp
80107ad4:	5b                   	pop    %ebx
80107ad5:	5d                   	pop    %ebp
80107ad6:	c3                   	ret    

80107ad7 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107ad7:	55                   	push   %ebp
80107ad8:	89 e5                	mov    %esp,%ebp
80107ada:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107add:	e8 37 ff ff ff       	call   80107a19 <setupkvm>
80107ae2:	a3 b8 2a 11 80       	mov    %eax,0x80112ab8
  switchkvm();
80107ae7:	e8 02 00 00 00       	call   80107aee <switchkvm>
}
80107aec:	c9                   	leave  
80107aed:	c3                   	ret    

80107aee <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107aee:	55                   	push   %ebp
80107aef:	89 e5                	mov    %esp,%ebp
80107af1:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107af4:	a1 b8 2a 11 80       	mov    0x80112ab8,%eax
80107af9:	89 04 24             	mov    %eax,(%esp)
80107afc:	e8 5e f9 ff ff       	call   8010745f <v2p>
80107b01:	89 04 24             	mov    %eax,(%esp)
80107b04:	e8 4b f9 ff ff       	call   80107454 <lcr3>
}
80107b09:	c9                   	leave  
80107b0a:	c3                   	ret    

80107b0b <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107b0b:	55                   	push   %ebp
80107b0c:	89 e5                	mov    %esp,%ebp
80107b0e:	53                   	push   %ebx
80107b0f:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107b12:	e8 0d d3 ff ff       	call   80104e24 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107b17:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b1d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107b24:	83 c2 08             	add    $0x8,%edx
80107b27:	89 d3                	mov    %edx,%ebx
80107b29:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107b30:	83 c2 08             	add    $0x8,%edx
80107b33:	c1 ea 10             	shr    $0x10,%edx
80107b36:	89 d1                	mov    %edx,%ecx
80107b38:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107b3f:	83 c2 08             	add    $0x8,%edx
80107b42:	c1 ea 18             	shr    $0x18,%edx
80107b45:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107b4c:	67 00 
80107b4e:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107b55:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107b5b:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107b62:	83 e1 f0             	and    $0xfffffff0,%ecx
80107b65:	83 c9 09             	or     $0x9,%ecx
80107b68:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107b6e:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107b75:	83 c9 10             	or     $0x10,%ecx
80107b78:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107b7e:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107b85:	83 e1 9f             	and    $0xffffff9f,%ecx
80107b88:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107b8e:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107b95:	83 c9 80             	or     $0xffffff80,%ecx
80107b98:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107b9e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107ba5:	83 e1 f0             	and    $0xfffffff0,%ecx
80107ba8:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107bae:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107bb5:	83 e1 ef             	and    $0xffffffef,%ecx
80107bb8:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107bbe:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107bc5:	83 e1 df             	and    $0xffffffdf,%ecx
80107bc8:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107bce:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107bd5:	83 c9 40             	or     $0x40,%ecx
80107bd8:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107bde:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107be5:	83 e1 7f             	and    $0x7f,%ecx
80107be8:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107bee:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107bf4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107bfa:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107c01:	83 e2 ef             	and    $0xffffffef,%edx
80107c04:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107c0a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c10:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107c16:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c1c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107c23:	8b 52 08             	mov    0x8(%edx),%edx
80107c26:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107c2c:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107c2f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107c36:	e8 ee f7 ff ff       	call   80107429 <ltr>
  if(p->pgdir == 0)
80107c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c3e:	8b 40 04             	mov    0x4(%eax),%eax
80107c41:	85 c0                	test   %eax,%eax
80107c43:	75 0c                	jne    80107c51 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107c45:	c7 04 24 3b 88 10 80 	movl   $0x8010883b,(%esp)
80107c4c:	e8 e9 88 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107c51:	8b 45 08             	mov    0x8(%ebp),%eax
80107c54:	8b 40 04             	mov    0x4(%eax),%eax
80107c57:	89 04 24             	mov    %eax,(%esp)
80107c5a:	e8 00 f8 ff ff       	call   8010745f <v2p>
80107c5f:	89 04 24             	mov    %eax,(%esp)
80107c62:	e8 ed f7 ff ff       	call   80107454 <lcr3>
  popcli();
80107c67:	e8 00 d2 ff ff       	call   80104e6c <popcli>
}
80107c6c:	83 c4 14             	add    $0x14,%esp
80107c6f:	5b                   	pop    %ebx
80107c70:	5d                   	pop    %ebp
80107c71:	c3                   	ret    

80107c72 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107c72:	55                   	push   %ebp
80107c73:	89 e5                	mov    %esp,%ebp
80107c75:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107c78:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107c7f:	76 0c                	jbe    80107c8d <inituvm+0x1b>
    panic("inituvm: more than a page");
80107c81:	c7 04 24 4f 88 10 80 	movl   $0x8010884f,(%esp)
80107c88:	e8 ad 88 ff ff       	call   8010053a <panic>
  mem = kalloc();
80107c8d:	e8 a4 ae ff ff       	call   80102b36 <kalloc>
80107c92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107c95:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c9c:	00 
80107c9d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107ca4:	00 
80107ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca8:	89 04 24             	mov    %eax,(%esp)
80107cab:	e8 7a d2 ff ff       	call   80104f2a <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb3:	89 04 24             	mov    %eax,(%esp)
80107cb6:	e8 a4 f7 ff ff       	call   8010745f <v2p>
80107cbb:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107cc2:	00 
80107cc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107cc7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107cce:	00 
80107ccf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107cd6:	00 
80107cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80107cda:	89 04 24             	mov    %eax,(%esp)
80107cdd:	e8 a3 fc ff ff       	call   80107985 <mappages>
  memmove(mem, init, sz);
80107ce2:	8b 45 10             	mov    0x10(%ebp),%eax
80107ce5:	89 44 24 08          	mov    %eax,0x8(%esp)
80107ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cec:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf3:	89 04 24             	mov    %eax,(%esp)
80107cf6:	e8 02 d3 ff ff       	call   80104ffd <memmove>
}
80107cfb:	c9                   	leave  
80107cfc:	c3                   	ret    

80107cfd <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107cfd:	55                   	push   %ebp
80107cfe:	89 e5                	mov    %esp,%ebp
80107d00:	53                   	push   %ebx
80107d01:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107d04:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d07:	25 ff 0f 00 00       	and    $0xfff,%eax
80107d0c:	85 c0                	test   %eax,%eax
80107d0e:	74 0c                	je     80107d1c <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107d10:	c7 04 24 6c 88 10 80 	movl   $0x8010886c,(%esp)
80107d17:	e8 1e 88 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107d1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80107d23:	e9 ae 00 00 00       	jmp    80107dd6 <loaduvm+0xd9>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107d28:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d2e:	8d 04 02             	lea    (%edx,%eax,1),%eax
80107d31:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107d38:	00 
80107d39:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d3d:	8b 45 08             	mov    0x8(%ebp),%eax
80107d40:	89 04 24             	mov    %eax,(%esp)
80107d43:	e8 a7 fb ff ff       	call   801078ef <walkpgdir>
80107d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107d4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107d4f:	75 0c                	jne    80107d5d <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107d51:	c7 04 24 8f 88 10 80 	movl   $0x8010888f,(%esp)
80107d58:	e8 dd 87 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80107d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d60:	8b 00                	mov    (%eax),%eax
80107d62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d67:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(sz - i < PGSIZE)
80107d6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d6d:	8b 55 18             	mov    0x18(%ebp),%edx
80107d70:	89 d1                	mov    %edx,%ecx
80107d72:	29 c1                	sub    %eax,%ecx
80107d74:	89 c8                	mov    %ecx,%eax
80107d76:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107d7b:	77 11                	ja     80107d8e <loaduvm+0x91>
      n = sz - i;
80107d7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d80:	8b 55 18             	mov    0x18(%ebp),%edx
80107d83:	89 d1                	mov    %edx,%ecx
80107d85:	29 c1                	sub    %eax,%ecx
80107d87:	89 c8                	mov    %ecx,%eax
80107d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d8c:	eb 07                	jmp    80107d95 <loaduvm+0x98>
    else
      n = PGSIZE;
80107d8e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107d95:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d98:	8b 55 14             	mov    0x14(%ebp),%edx
80107d9b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107da1:	89 04 24             	mov    %eax,(%esp)
80107da4:	e8 c3 f6 ff ff       	call   8010746c <p2v>
80107da9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107dac:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107db0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107db4:	89 44 24 04          	mov    %eax,0x4(%esp)
80107db8:	8b 45 10             	mov    0x10(%ebp),%eax
80107dbb:	89 04 24             	mov    %eax,(%esp)
80107dbe:	e8 dd 9f ff ff       	call   80101da0 <readi>
80107dc3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107dc6:	74 07                	je     80107dcf <loaduvm+0xd2>
      return -1;
80107dc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107dcd:	eb 18                	jmp    80107de7 <loaduvm+0xea>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107dcf:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
80107dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107dd9:	3b 45 18             	cmp    0x18(%ebp),%eax
80107ddc:	0f 82 46 ff ff ff    	jb     80107d28 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107de2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107de7:	83 c4 24             	add    $0x24,%esp
80107dea:	5b                   	pop    %ebx
80107deb:	5d                   	pop    %ebp
80107dec:	c3                   	ret    

80107ded <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ded:	55                   	push   %ebp
80107dee:	89 e5                	mov    %esp,%ebp
80107df0:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107df3:	8b 45 10             	mov    0x10(%ebp),%eax
80107df6:	85 c0                	test   %eax,%eax
80107df8:	79 0a                	jns    80107e04 <allocuvm+0x17>
    return 0;
80107dfa:	b8 00 00 00 00       	mov    $0x0,%eax
80107dff:	e9 c1 00 00 00       	jmp    80107ec5 <allocuvm+0xd8>
  if(newsz < oldsz)
80107e04:	8b 45 10             	mov    0x10(%ebp),%eax
80107e07:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e0a:	73 08                	jae    80107e14 <allocuvm+0x27>
    return oldsz;
80107e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e0f:	e9 b1 00 00 00       	jmp    80107ec5 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80107e14:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e17:	05 ff 0f 00 00       	add    $0xfff,%eax
80107e1c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107e24:	e9 8d 00 00 00       	jmp    80107eb6 <allocuvm+0xc9>
    mem = kalloc();
80107e29:	e8 08 ad ff ff       	call   80102b36 <kalloc>
80107e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107e31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e35:	75 2c                	jne    80107e63 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80107e37:	c7 04 24 ad 88 10 80 	movl   $0x801088ad,(%esp)
80107e3e:	e8 57 85 ff ff       	call   8010039a <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107e43:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e46:	89 44 24 08          	mov    %eax,0x8(%esp)
80107e4a:	8b 45 10             	mov    0x10(%ebp),%eax
80107e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e51:	8b 45 08             	mov    0x8(%ebp),%eax
80107e54:	89 04 24             	mov    %eax,(%esp)
80107e57:	e8 6b 00 00 00       	call   80107ec7 <deallocuvm>
      return 0;
80107e5c:	b8 00 00 00 00       	mov    $0x0,%eax
80107e61:	eb 62                	jmp    80107ec5 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80107e63:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e6a:	00 
80107e6b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107e72:	00 
80107e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e76:	89 04 24             	mov    %eax,(%esp)
80107e79:	e8 ac d0 ff ff       	call   80104f2a <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e81:	89 04 24             	mov    %eax,(%esp)
80107e84:	e8 d6 f5 ff ff       	call   8010745f <v2p>
80107e89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e8c:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107e93:	00 
80107e94:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107e98:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e9f:	00 
80107ea0:	89 54 24 04          	mov    %edx,0x4(%esp)
80107ea4:	8b 45 08             	mov    0x8(%ebp),%eax
80107ea7:	89 04 24             	mov    %eax,(%esp)
80107eaa:	e8 d6 fa ff ff       	call   80107985 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107eaf:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb9:	3b 45 10             	cmp    0x10(%ebp),%eax
80107ebc:	0f 82 67 ff ff ff    	jb     80107e29 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80107ec2:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107ec5:	c9                   	leave  
80107ec6:	c3                   	ret    

80107ec7 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ec7:	55                   	push   %ebp
80107ec8:	89 e5                	mov    %esp,%ebp
80107eca:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107ecd:	8b 45 10             	mov    0x10(%ebp),%eax
80107ed0:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ed3:	72 08                	jb     80107edd <deallocuvm+0x16>
    return oldsz;
80107ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ed8:	e9 a4 00 00 00       	jmp    80107f81 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80107edd:	8b 45 10             	mov    0x10(%ebp),%eax
80107ee0:	05 ff 0f 00 00       	add    $0xfff,%eax
80107ee5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107eea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107eed:	e9 80 00 00 00       	jmp    80107f72 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ef5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107efc:	00 
80107efd:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f01:	8b 45 08             	mov    0x8(%ebp),%eax
80107f04:	89 04 24             	mov    %eax,(%esp)
80107f07:	e8 e3 f9 ff ff       	call   801078ef <walkpgdir>
80107f0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(!pte)
80107f0f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107f13:	75 09                	jne    80107f1e <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80107f15:	81 45 ec 00 f0 3f 00 	addl   $0x3ff000,-0x14(%ebp)
80107f1c:	eb 4d                	jmp    80107f6b <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80107f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f21:	8b 00                	mov    (%eax),%eax
80107f23:	83 e0 01             	and    $0x1,%eax
80107f26:	84 c0                	test   %al,%al
80107f28:	74 41                	je     80107f6b <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80107f2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f2d:	8b 00                	mov    (%eax),%eax
80107f2f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f34:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(pa == 0)
80107f37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107f3b:	75 0c                	jne    80107f49 <deallocuvm+0x82>
        panic("kfree");
80107f3d:	c7 04 24 c5 88 10 80 	movl   $0x801088c5,(%esp)
80107f44:	e8 f1 85 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80107f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f4c:	89 04 24             	mov    %eax,(%esp)
80107f4f:	e8 18 f5 ff ff       	call   8010746c <p2v>
80107f54:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
80107f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5a:	89 04 24             	mov    %eax,(%esp)
80107f5d:	e8 3b ab ff ff       	call   80102a9d <kfree>
      *pte = 0;
80107f62:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107f6b:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
80107f72:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f75:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107f78:	0f 82 74 ff ff ff    	jb     80107ef2 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80107f7e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107f81:	c9                   	leave  
80107f82:	c3                   	ret    

80107f83 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107f83:	55                   	push   %ebp
80107f84:	89 e5                	mov    %esp,%ebp
80107f86:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80107f89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107f8d:	75 0c                	jne    80107f9b <freevm+0x18>
    panic("freevm: no pgdir");
80107f8f:	c7 04 24 cb 88 10 80 	movl   $0x801088cb,(%esp)
80107f96:	e8 9f 85 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107f9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107fa2:	00 
80107fa3:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107faa:	80 
80107fab:	8b 45 08             	mov    0x8(%ebp),%eax
80107fae:	89 04 24             	mov    %eax,(%esp)
80107fb1:	e8 11 ff ff ff       	call   80107ec7 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107fb6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80107fbd:	eb 3c                	jmp    80107ffb <freevm+0x78>
    if(pgdir[i] & PTE_P){
80107fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fc2:	c1 e0 02             	shl    $0x2,%eax
80107fc5:	03 45 08             	add    0x8(%ebp),%eax
80107fc8:	8b 00                	mov    (%eax),%eax
80107fca:	83 e0 01             	and    $0x1,%eax
80107fcd:	84 c0                	test   %al,%al
80107fcf:	74 26                	je     80107ff7 <freevm+0x74>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80107fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fd4:	c1 e0 02             	shl    $0x2,%eax
80107fd7:	03 45 08             	add    0x8(%ebp),%eax
80107fda:	8b 00                	mov    (%eax),%eax
80107fdc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fe1:	89 04 24             	mov    %eax,(%esp)
80107fe4:	e8 83 f4 ff ff       	call   8010746c <p2v>
80107fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
80107fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fef:	89 04 24             	mov    %eax,(%esp)
80107ff2:	e8 a6 aa ff ff       	call   80102a9d <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107ff7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80107ffb:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
80108002:	76 bb                	jbe    80107fbf <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108004:	8b 45 08             	mov    0x8(%ebp),%eax
80108007:	89 04 24             	mov    %eax,(%esp)
8010800a:	e8 8e aa ff ff       	call   80102a9d <kfree>
}
8010800f:	c9                   	leave  
80108010:	c3                   	ret    

80108011 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108011:	55                   	push   %ebp
80108012:	89 e5                	mov    %esp,%ebp
80108014:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108017:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010801e:	00 
8010801f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108022:	89 44 24 04          	mov    %eax,0x4(%esp)
80108026:	8b 45 08             	mov    0x8(%ebp),%eax
80108029:	89 04 24             	mov    %eax,(%esp)
8010802c:	e8 be f8 ff ff       	call   801078ef <walkpgdir>
80108031:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108034:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108038:	75 0c                	jne    80108046 <clearpteu+0x35>
    panic("clearpteu");
8010803a:	c7 04 24 dc 88 10 80 	movl   $0x801088dc,(%esp)
80108041:	e8 f4 84 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80108046:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108049:	8b 00                	mov    (%eax),%eax
8010804b:	89 c2                	mov    %eax,%edx
8010804d:	83 e2 fb             	and    $0xfffffffb,%edx
80108050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108053:	89 10                	mov    %edx,(%eax)
}
80108055:	c9                   	leave  
80108056:	c3                   	ret    

80108057 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108057:	55                   	push   %ebp
80108058:	89 e5                	mov    %esp,%ebp
8010805a:	53                   	push   %ebx
8010805b:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010805e:	e8 b6 f9 ff ff       	call   80107a19 <setupkvm>
80108063:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108066:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010806a:	75 0a                	jne    80108076 <copyuvm+0x1f>
    return 0;
8010806c:	b8 00 00 00 00       	mov    $0x0,%eax
80108071:	e9 fd 00 00 00       	jmp    80108173 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108076:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010807d:	e9 cc 00 00 00       	jmp    8010814e <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108082:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108085:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010808c:	00 
8010808d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108091:	8b 45 08             	mov    0x8(%ebp),%eax
80108094:	89 04 24             	mov    %eax,(%esp)
80108097:	e8 53 f8 ff ff       	call   801078ef <walkpgdir>
8010809c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010809f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801080a3:	75 0c                	jne    801080b1 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
801080a5:	c7 04 24 e6 88 10 80 	movl   $0x801088e6,(%esp)
801080ac:	e8 89 84 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
801080b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080b4:	8b 00                	mov    (%eax),%eax
801080b6:	83 e0 01             	and    $0x1,%eax
801080b9:	85 c0                	test   %eax,%eax
801080bb:	75 0c                	jne    801080c9 <copyuvm+0x72>
      panic("copyuvm: page not present");
801080bd:	c7 04 24 00 89 10 80 	movl   $0x80108900,(%esp)
801080c4:	e8 71 84 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
801080c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080cc:	8b 00                	mov    (%eax),%eax
801080ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801080d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080d9:	8b 00                	mov    (%eax),%eax
801080db:	25 ff 0f 00 00       	and    $0xfff,%eax
801080e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mem = kalloc()) == 0)
801080e3:	e8 4e aa ff ff       	call   80102b36 <kalloc>
801080e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801080ef:	74 6e                	je     8010815f <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801080f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801080f4:	89 04 24             	mov    %eax,(%esp)
801080f7:	e8 70 f3 ff ff       	call   8010746c <p2v>
801080fc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108103:	00 
80108104:	89 44 24 04          	mov    %eax,0x4(%esp)
80108108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810b:	89 04 24             	mov    %eax,(%esp)
8010810e:	e8 ea ce ff ff       	call   80104ffd <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108113:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80108116:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108119:	89 04 24             	mov    %eax,(%esp)
8010811c:	e8 3e f3 ff ff       	call   8010745f <v2p>
80108121:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108124:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108128:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010812c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108133:	00 
80108134:	89 54 24 04          	mov    %edx,0x4(%esp)
80108138:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010813b:	89 04 24             	mov    %eax,(%esp)
8010813e:	e8 42 f8 ff ff       	call   80107985 <mappages>
80108143:	85 c0                	test   %eax,%eax
80108145:	78 1b                	js     80108162 <copyuvm+0x10b>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108147:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
8010814e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108151:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108154:	0f 82 28 ff ff ff    	jb     80108082 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
8010815a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010815d:	eb 14                	jmp    80108173 <copyuvm+0x11c>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
8010815f:	90                   	nop
80108160:	eb 01                	jmp    80108163 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108162:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108163:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108166:	89 04 24             	mov    %eax,(%esp)
80108169:	e8 15 fe ff ff       	call   80107f83 <freevm>
  return 0;
8010816e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108173:	83 c4 44             	add    $0x44,%esp
80108176:	5b                   	pop    %ebx
80108177:	5d                   	pop    %ebp
80108178:	c3                   	ret    

80108179 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108179:	55                   	push   %ebp
8010817a:	89 e5                	mov    %esp,%ebp
8010817c:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010817f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108186:	00 
80108187:	8b 45 0c             	mov    0xc(%ebp),%eax
8010818a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010818e:	8b 45 08             	mov    0x8(%ebp),%eax
80108191:	89 04 24             	mov    %eax,(%esp)
80108194:	e8 56 f7 ff ff       	call   801078ef <walkpgdir>
80108199:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010819c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819f:	8b 00                	mov    (%eax),%eax
801081a1:	83 e0 01             	and    $0x1,%eax
801081a4:	85 c0                	test   %eax,%eax
801081a6:	75 07                	jne    801081af <uva2ka+0x36>
    return 0;
801081a8:	b8 00 00 00 00       	mov    $0x0,%eax
801081ad:	eb 25                	jmp    801081d4 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
801081af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b2:	8b 00                	mov    (%eax),%eax
801081b4:	83 e0 04             	and    $0x4,%eax
801081b7:	85 c0                	test   %eax,%eax
801081b9:	75 07                	jne    801081c2 <uva2ka+0x49>
    return 0;
801081bb:	b8 00 00 00 00       	mov    $0x0,%eax
801081c0:	eb 12                	jmp    801081d4 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
801081c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c5:	8b 00                	mov    (%eax),%eax
801081c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081cc:	89 04 24             	mov    %eax,(%esp)
801081cf:	e8 98 f2 ff ff       	call   8010746c <p2v>
}
801081d4:	c9                   	leave  
801081d5:	c3                   	ret    

801081d6 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801081d6:	55                   	push   %ebp
801081d7:	89 e5                	mov    %esp,%ebp
801081d9:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801081dc:	8b 45 10             	mov    0x10(%ebp),%eax
801081df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(len > 0){
801081e2:	e9 8b 00 00 00       	jmp    80108272 <copyout+0x9c>
    va0 = (uint)PGROUNDDOWN(va);
801081e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801081ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801081f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801081f9:	8b 45 08             	mov    0x8(%ebp),%eax
801081fc:	89 04 24             	mov    %eax,(%esp)
801081ff:	e8 75 ff ff ff       	call   80108179 <uva2ka>
80108204:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pa0 == 0)
80108207:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010820b:	75 07                	jne    80108214 <copyout+0x3e>
      return -1;
8010820d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108212:	eb 6d                	jmp    80108281 <copyout+0xab>
    n = PGSIZE - (va - va0);
80108214:	8b 45 0c             	mov    0xc(%ebp),%eax
80108217:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010821a:	89 d1                	mov    %edx,%ecx
8010821c:	29 c1                	sub    %eax,%ecx
8010821e:	89 c8                	mov    %ecx,%eax
80108220:	05 00 10 00 00       	add    $0x1000,%eax
80108225:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108228:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010822b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010822e:	76 06                	jbe    80108236 <copyout+0x60>
      n = len;
80108230:	8b 45 14             	mov    0x14(%ebp),%eax
80108233:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108236:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108239:	8b 55 0c             	mov    0xc(%ebp),%edx
8010823c:	89 d1                	mov    %edx,%ecx
8010823e:	29 c1                	sub    %eax,%ecx
80108240:	89 c8                	mov    %ecx,%eax
80108242:	03 45 ec             	add    -0x14(%ebp),%eax
80108245:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108248:	89 54 24 08          	mov    %edx,0x8(%esp)
8010824c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010824f:	89 54 24 04          	mov    %edx,0x4(%esp)
80108253:	89 04 24             	mov    %eax,(%esp)
80108256:	e8 a2 cd ff ff       	call   80104ffd <memmove>
    len -= n;
8010825b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010825e:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108261:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108264:	01 45 e8             	add    %eax,-0x18(%ebp)
    va = va0 + PGSIZE;
80108267:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826a:	05 00 10 00 00       	add    $0x1000,%eax
8010826f:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108272:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108276:	0f 85 6b ff ff ff    	jne    801081e7 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010827c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108281:	c9                   	leave  
80108282:	c3                   	ret    
