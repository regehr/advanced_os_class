
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
8010002d:	b8 e4 33 10 80       	mov    $0x801033e4,%eax
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
8010003a:	c7 44 24 04 04 82 10 	movl   $0x80108204,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 ec 4b 00 00       	call   80104c3a <initlock>

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
801000be:	e8 98 4b 00 00       	call   80104c5b <acquire>

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
80100105:	e8 b2 4b 00 00       	call   80104cbc <release>
        return b;
8010010a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010d:	e9 93 00 00 00       	jmp    801001a5 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100112:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100119:	80 
8010011a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011d:	89 04 24             	mov    %eax,(%esp)
80100120:	e8 47 48 00 00       	call   8010496c <sleep>
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
8010017d:	e8 3a 4b 00 00       	call   80104cbc <release>
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
80100199:	c7 04 24 0b 82 10 80 	movl   $0x8010820b,(%esp)
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
801001d4:	e8 d9 25 00 00       	call   801027b2 <iderw>
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
801001f0:	c7 04 24 1c 82 10 80 	movl   $0x8010821c,(%esp)
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
80100211:	e8 9c 25 00 00       	call   801027b2 <iderw>
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
8010022a:	c7 04 24 23 82 10 80 	movl   $0x80108223,(%esp)
80100231:	e8 04 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100236:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023d:	e8 19 4a 00 00       	call   80104c5b <acquire>

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
8010029e:	e8 b1 47 00 00       	call   80104a54 <wakeup>

  release(&bcache.lock);
801002a3:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002aa:	e8 0d 4a 00 00       	call   80104cbc <release>
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
801003b5:	e8 a1 48 00 00       	call   80104c5b <acquire>

  if (fmt == 0)
801003ba:	8b 45 08             	mov    0x8(%ebp),%eax
801003bd:	85 c0                	test   %eax,%eax
801003bf:	75 0c                	jne    801003cd <cprintf+0x33>
    panic("null fmt");
801003c1:	c7 04 24 2a 82 10 80 	movl   $0x8010822a,(%esp)
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
801004ac:	c7 45 f4 33 82 10 80 	movl   $0x80108233,-0xc(%ebp)
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
80100533:	e8 84 47 00 00       	call   80104cbc <release>
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
8010055f:	c7 04 24 3a 82 10 80 	movl   $0x8010823a,(%esp)
80100566:	e8 2f fe ff ff       	call   8010039a <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 24 fe ff ff       	call   8010039a <cprintf>
  cprintf("\n");
80100576:	c7 04 24 49 82 10 80 	movl   $0x80108249,(%esp)
8010057d:	e8 18 fe ff ff       	call   8010039a <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 77 47 00 00       	call   80104d0b <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 4b 82 10 80 	movl   $0x8010824b,(%esp)
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
801006b0:	e8 c8 48 00 00       	call   80104f7d <memmove>
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
801006df:	e8 c6 47 00 00       	call   80104eaa <memset>
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
80100774:	e8 db 60 00 00       	call   80106854 <uartputc>
80100779:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100780:	e8 cf 60 00 00       	call   80106854 <uartputc>
80100785:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078c:	e8 c3 60 00 00       	call   80106854 <uartputc>
80100791:	eb 0b                	jmp    8010079e <consputc+0x50>
  } else
    uartputc(c);
80100793:	8b 45 08             	mov    0x8(%ebp),%eax
80100796:	89 04 24             	mov    %eax,(%esp)
80100799:	e8 b6 60 00 00       	call   80106854 <uartputc>
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
801007b8:	e8 9e 44 00 00       	call   80104c5b <acquire>
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
801007e8:	e8 19 43 00 00       	call   80104b06 <procdump>
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
801008f5:	e8 5a 41 00 00       	call   80104a54 <wakeup>
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
80100919:	e8 9e 43 00 00       	call   80104cbc <release>
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
8010092c:	e8 8f 10 00 00       	call   801019c0 <iunlock>
  target = n;
80100931:	8b 45 10             	mov    0x10(%ebp),%eax
80100934:	89 45 f0             	mov    %eax,-0x10(%ebp)
  acquire(&input.lock);
80100937:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010093e:	e8 18 43 00 00       	call   80104c5b <acquire>
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
8010095c:	e8 5b 43 00 00       	call   80104cbc <release>
        ilock(ip);
80100961:	8b 45 08             	mov    0x8(%ebp),%eax
80100964:	89 04 24             	mov    %eax,(%esp)
80100967:	e8 03 0f 00 00       	call   8010186f <ilock>
        return -1;
8010096c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100971:	e9 a9 00 00 00       	jmp    80100a1f <consoleread+0xff>
      }
      sleep(&input.r, &input.lock);
80100976:	c7 44 24 04 a0 dd 10 	movl   $0x8010dda0,0x4(%esp)
8010097d:	80 
8010097e:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
80100985:	e8 e2 3f 00 00       	call   8010496c <sleep>
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
80100a03:	e8 b4 42 00 00       	call   80104cbc <release>
  ilock(ip);
80100a08:	8b 45 08             	mov    0x8(%ebp),%eax
80100a0b:	89 04 24             	mov    %eax,(%esp)
80100a0e:	e8 5c 0e 00 00       	call   8010186f <ilock>

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
80100a2d:	e8 8e 0f 00 00       	call   801019c0 <iunlock>
  acquire(&cons.lock);
80100a32:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a39:	e8 1d 42 00 00       	call   80104c5b <acquire>
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
80100a73:	e8 44 42 00 00       	call   80104cbc <release>
  ilock(ip);
80100a78:	8b 45 08             	mov    0x8(%ebp),%eax
80100a7b:	89 04 24             	mov    %eax,(%esp)
80100a7e:	e8 ec 0d 00 00       	call   8010186f <ilock>

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
80100a8e:	c7 44 24 04 4f 82 10 	movl   $0x8010824f,0x4(%esp)
80100a95:	80 
80100a96:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a9d:	e8 98 41 00 00       	call   80104c3a <initlock>
  initlock(&input.lock, "input");
80100aa2:	c7 44 24 04 57 82 10 	movl   $0x80108257,0x4(%esp)
80100aa9:	80 
80100aaa:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100ab1:	e8 84 41 00 00       	call   80104c3a <initlock>

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
80100adb:	e8 a5 2f 00 00       	call   80103a85 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ae0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae7:	00 
80100ae8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aef:	e8 7e 1e 00 00       	call   80102972 <ioapicenable>
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
80100b07:	e8 0b 19 00 00       	call   80102417 <namei>
80100b0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100b0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100b13:	75 0a                	jne    80100b1f <exec+0x27>
    return -1;
80100b15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1a:	e9 d8 03 00 00       	jmp    80100ef7 <exec+0x3ff>
  ilock(ip);
80100b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100b22:	89 04 24             	mov    %eax,(%esp)
80100b25:	e8 45 0d 00 00       	call   8010186f <ilock>
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
80100b51:	e8 12 12 00 00       	call   80101d68 <readi>
80100b56:	83 f8 33             	cmp    $0x33,%eax
80100b59:	0f 86 52 03 00 00    	jbe    80100eb1 <exec+0x3b9>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b5f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b65:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6a:	0f 85 44 03 00 00    	jne    80100eb4 <exec+0x3bc>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b70:	e8 24 6e 00 00       	call   80107999 <setupkvm>
80100b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100b78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100b7c:	0f 84 35 03 00 00    	je     80100eb7 <exec+0x3bf>
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
80100bbd:	e8 a6 11 00 00       	call   80101d68 <readi>
80100bc2:	83 f8 20             	cmp    $0x20,%eax
80100bc5:	0f 85 ef 02 00 00    	jne    80100eba <exec+0x3c2>
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
80100be8:	0f 82 cf 02 00 00    	jb     80100ebd <exec+0x3c5>
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
80100c0e:	e8 5a 71 00 00       	call   80107d6d <allocuvm>
80100c13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100c16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100c1a:	0f 84 a0 02 00 00    	je     80100ec0 <exec+0x3c8>
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
80100c4b:	e8 2d 70 00 00       	call   80107c7d <loaduvm>
80100c50:	85 c0                	test   %eax,%eax
80100c52:	0f 88 6b 02 00 00    	js     80100ec3 <exec+0x3cb>
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
80100c81:	e8 70 0e 00 00       	call   80101af6 <iunlockput>
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
80100cb6:	e8 b2 70 00 00       	call   80107d6d <allocuvm>
80100cbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100cbe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100cc2:	0f 84 fe 01 00 00    	je     80100ec6 <exec+0x3ce>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ccb:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100cd7:	89 04 24             	mov    %eax,(%esp)
80100cda:	e8 b2 72 00 00       	call   80107f91 <clearpteu>
  sp = sz;
80100cdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ce2:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ce5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80100cec:	e9 81 00 00 00       	jmp    80100d72 <exec+0x27a>
    if(argc >= MAXARG)
80100cf1:	83 7d e0 1f          	cmpl   $0x1f,-0x20(%ebp)
80100cf5:	0f 87 ce 01 00 00    	ja     80100ec9 <exec+0x3d1>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cfe:	c1 e0 02             	shl    $0x2,%eax
80100d01:	03 45 0c             	add    0xc(%ebp),%eax
80100d04:	8b 00                	mov    (%eax),%eax
80100d06:	89 04 24             	mov    %eax,(%esp)
80100d09:	e8 1d 44 00 00       	call   8010512b <strlen>
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
80100d27:	e8 ff 43 00 00       	call   8010512b <strlen>
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
80100d51:	e8 00 74 00 00       	call   80108156 <copyout>
80100d56:	85 c0                	test   %eax,%eax
80100d58:	0f 88 6e 01 00 00    	js     80100ecc <exec+0x3d4>
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
80100df1:	e8 60 73 00 00       	call   80108156 <copyout>
80100df6:	85 c0                	test   %eax,%eax
80100df8:	0f 88 d1 00 00 00    	js     80100ecf <exec+0x3d7>
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
80100e48:	e8 90 42 00 00       	call   801050dd <safestrcpy>

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
  switchuvm(proc);
80100e91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e97:	89 04 24             	mov    %eax,(%esp)
80100e9a:	e8 ec 6b 00 00       	call   80107a8b <switchuvm>
  freevm(oldpgdir);
80100e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ea2:	89 04 24             	mov    %eax,(%esp)
80100ea5:	e8 59 70 00 00       	call   80107f03 <freevm>
  return 0;
80100eaa:	b8 00 00 00 00       	mov    $0x0,%eax
80100eaf:	eb 46                	jmp    80100ef7 <exec+0x3ff>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100eb1:	90                   	nop
80100eb2:	eb 1c                	jmp    80100ed0 <exec+0x3d8>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100eb4:	90                   	nop
80100eb5:	eb 19                	jmp    80100ed0 <exec+0x3d8>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100eb7:	90                   	nop
80100eb8:	eb 16                	jmp    80100ed0 <exec+0x3d8>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100eba:	90                   	nop
80100ebb:	eb 13                	jmp    80100ed0 <exec+0x3d8>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ebd:	90                   	nop
80100ebe:	eb 10                	jmp    80100ed0 <exec+0x3d8>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100ec0:	90                   	nop
80100ec1:	eb 0d                	jmp    80100ed0 <exec+0x3d8>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100ec3:	90                   	nop
80100ec4:	eb 0a                	jmp    80100ed0 <exec+0x3d8>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100ec6:	90                   	nop
80100ec7:	eb 07                	jmp    80100ed0 <exec+0x3d8>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100ec9:	90                   	nop
80100eca:	eb 04                	jmp    80100ed0 <exec+0x3d8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100ecc:	90                   	nop
80100ecd:	eb 01                	jmp    80100ed0 <exec+0x3d8>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100ecf:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100ed0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100ed4:	74 0b                	je     80100ee1 <exec+0x3e9>
    freevm(pgdir);
80100ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100ed9:	89 04 24             	mov    %eax,(%esp)
80100edc:	e8 22 70 00 00       	call   80107f03 <freevm>
  if(ip)
80100ee1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100ee5:	74 0b                	je     80100ef2 <exec+0x3fa>
    iunlockput(ip);
80100ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100eea:	89 04 24             	mov    %eax,(%esp)
80100eed:	e8 04 0c 00 00       	call   80101af6 <iunlockput>
  return -1;
80100ef2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ef7:	c9                   	leave  
80100ef8:	c3                   	ret    
80100ef9:	00 00                	add    %al,(%eax)
	...

80100efc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100efc:	55                   	push   %ebp
80100efd:	89 e5                	mov    %esp,%ebp
80100eff:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f02:	c7 44 24 04 5d 82 10 	movl   $0x8010825d,0x4(%esp)
80100f09:	80 
80100f0a:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f11:	e8 24 3d 00 00       	call   80104c3a <initlock>
}
80100f16:	c9                   	leave  
80100f17:	c3                   	ret    

80100f18 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f18:	55                   	push   %ebp
80100f19:	89 e5                	mov    %esp,%ebp
80100f1b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f1e:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f25:	e8 31 3d 00 00       	call   80104c5b <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f2a:	c7 45 f4 94 de 10 80 	movl   $0x8010de94,-0xc(%ebp)
80100f31:	eb 29                	jmp    80100f5c <filealloc+0x44>
    if(f->ref == 0){
80100f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f36:	8b 40 04             	mov    0x4(%eax),%eax
80100f39:	85 c0                	test   %eax,%eax
80100f3b:	75 1b                	jne    80100f58 <filealloc+0x40>
      f->ref = 1;
80100f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f40:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f47:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f4e:	e8 69 3d 00 00       	call   80104cbc <release>
      return f;
80100f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f56:	eb 1f                	jmp    80100f77 <filealloc+0x5f>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f58:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f5c:	b8 f4 e7 10 80       	mov    $0x8010e7f4,%eax
80100f61:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100f64:	72 cd                	jb     80100f33 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f66:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f6d:	e8 4a 3d 00 00       	call   80104cbc <release>
  return 0;
80100f72:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f77:	c9                   	leave  
80100f78:	c3                   	ret    

80100f79 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f79:	55                   	push   %ebp
80100f7a:	89 e5                	mov    %esp,%ebp
80100f7c:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f7f:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f86:	e8 d0 3c 00 00       	call   80104c5b <acquire>
  if(f->ref < 1)
80100f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80100f8e:	8b 40 04             	mov    0x4(%eax),%eax
80100f91:	85 c0                	test   %eax,%eax
80100f93:	7f 0c                	jg     80100fa1 <filedup+0x28>
    panic("filedup");
80100f95:	c7 04 24 64 82 10 80 	movl   $0x80108264,(%esp)
80100f9c:	e8 99 f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa4:	8b 40 04             	mov    0x4(%eax),%eax
80100fa7:	8d 50 01             	lea    0x1(%eax),%edx
80100faa:	8b 45 08             	mov    0x8(%ebp),%eax
80100fad:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fb0:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fb7:	e8 00 3d 00 00       	call   80104cbc <release>
  return f;
80100fbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fbf:	c9                   	leave  
80100fc0:	c3                   	ret    

80100fc1 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fc1:	55                   	push   %ebp
80100fc2:	89 e5                	mov    %esp,%ebp
80100fc4:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fc7:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fce:	e8 88 3c 00 00       	call   80104c5b <acquire>
  if(f->ref < 1)
80100fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd6:	8b 40 04             	mov    0x4(%eax),%eax
80100fd9:	85 c0                	test   %eax,%eax
80100fdb:	7f 0c                	jg     80100fe9 <fileclose+0x28>
    panic("fileclose");
80100fdd:	c7 04 24 6c 82 10 80 	movl   $0x8010826c,(%esp)
80100fe4:	e8 51 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80100fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80100fec:	8b 40 04             	mov    0x4(%eax),%eax
80100fef:	8d 50 ff             	lea    -0x1(%eax),%edx
80100ff2:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff5:	89 50 04             	mov    %edx,0x4(%eax)
80100ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffb:	8b 40 04             	mov    0x4(%eax),%eax
80100ffe:	85 c0                	test   %eax,%eax
80101000:	7e 11                	jle    80101013 <fileclose+0x52>
    release(&ftable.lock);
80101002:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101009:	e8 ae 3c 00 00       	call   80104cbc <release>
    return;
8010100e:	e9 82 00 00 00       	jmp    80101095 <fileclose+0xd4>
  }
  ff = *f;
80101013:	8b 45 08             	mov    0x8(%ebp),%eax
80101016:	8b 10                	mov    (%eax),%edx
80101018:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010101b:	8b 50 04             	mov    0x4(%eax),%edx
8010101e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101021:	8b 50 08             	mov    0x8(%eax),%edx
80101024:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101027:	8b 50 0c             	mov    0xc(%eax),%edx
8010102a:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010102d:	8b 50 10             	mov    0x10(%eax),%edx
80101030:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101033:	8b 40 14             	mov    0x14(%eax),%eax
80101036:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101039:	8b 45 08             	mov    0x8(%ebp),%eax
8010103c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101043:	8b 45 08             	mov    0x8(%ebp),%eax
80101046:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010104c:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101053:	e8 64 3c 00 00       	call   80104cbc <release>
  
  if(ff.type == FD_PIPE)
80101058:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010105b:	83 f8 01             	cmp    $0x1,%eax
8010105e:	75 18                	jne    80101078 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101060:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101064:	0f be d0             	movsbl %al,%edx
80101067:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010106a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010106e:	89 04 24             	mov    %eax,(%esp)
80101071:	e8 c9 2c 00 00       	call   80103d3f <pipeclose>
80101076:	eb 1d                	jmp    80101095 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101078:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010107b:	83 f8 02             	cmp    $0x2,%eax
8010107e:	75 15                	jne    80101095 <fileclose+0xd4>
    begin_trans();
80101080:	e8 81 21 00 00       	call   80103206 <begin_trans>
    iput(ff.ip);
80101085:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101088:	89 04 24             	mov    %eax,(%esp)
8010108b:	e8 95 09 00 00       	call   80101a25 <iput>
    commit_trans();
80101090:	e8 ba 21 00 00       	call   8010324f <commit_trans>
  }
}
80101095:	c9                   	leave  
80101096:	c3                   	ret    

80101097 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101097:	55                   	push   %ebp
80101098:	89 e5                	mov    %esp,%ebp
8010109a:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
8010109d:	8b 45 08             	mov    0x8(%ebp),%eax
801010a0:	8b 00                	mov    (%eax),%eax
801010a2:	83 f8 02             	cmp    $0x2,%eax
801010a5:	75 38                	jne    801010df <filestat+0x48>
    ilock(f->ip);
801010a7:	8b 45 08             	mov    0x8(%ebp),%eax
801010aa:	8b 40 10             	mov    0x10(%eax),%eax
801010ad:	89 04 24             	mov    %eax,(%esp)
801010b0:	e8 ba 07 00 00       	call   8010186f <ilock>
    stati(f->ip, st);
801010b5:	8b 45 08             	mov    0x8(%ebp),%eax
801010b8:	8b 40 10             	mov    0x10(%eax),%eax
801010bb:	8b 55 0c             	mov    0xc(%ebp),%edx
801010be:	89 54 24 04          	mov    %edx,0x4(%esp)
801010c2:	89 04 24             	mov    %eax,(%esp)
801010c5:	e8 59 0c 00 00       	call   80101d23 <stati>
    iunlock(f->ip);
801010ca:	8b 45 08             	mov    0x8(%ebp),%eax
801010cd:	8b 40 10             	mov    0x10(%eax),%eax
801010d0:	89 04 24             	mov    %eax,(%esp)
801010d3:	e8 e8 08 00 00       	call   801019c0 <iunlock>
    return 0;
801010d8:	b8 00 00 00 00       	mov    $0x0,%eax
801010dd:	eb 05                	jmp    801010e4 <filestat+0x4d>
  }
  return -1;
801010df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010e4:	c9                   	leave  
801010e5:	c3                   	ret    

801010e6 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010e6:	55                   	push   %ebp
801010e7:	89 e5                	mov    %esp,%ebp
801010e9:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801010ec:	8b 45 08             	mov    0x8(%ebp),%eax
801010ef:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801010f3:	84 c0                	test   %al,%al
801010f5:	75 0a                	jne    80101101 <fileread+0x1b>
    return -1;
801010f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010fc:	e9 9f 00 00 00       	jmp    801011a0 <fileread+0xba>
  if(f->type == FD_PIPE)
80101101:	8b 45 08             	mov    0x8(%ebp),%eax
80101104:	8b 00                	mov    (%eax),%eax
80101106:	83 f8 01             	cmp    $0x1,%eax
80101109:	75 1e                	jne    80101129 <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010110b:	8b 45 08             	mov    0x8(%ebp),%eax
8010110e:	8b 40 0c             	mov    0xc(%eax),%eax
80101111:	8b 55 10             	mov    0x10(%ebp),%edx
80101114:	89 54 24 08          	mov    %edx,0x8(%esp)
80101118:	8b 55 0c             	mov    0xc(%ebp),%edx
8010111b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010111f:	89 04 24             	mov    %eax,(%esp)
80101122:	e8 9a 2d 00 00       	call   80103ec1 <piperead>
80101127:	eb 77                	jmp    801011a0 <fileread+0xba>
  if(f->type == FD_INODE){
80101129:	8b 45 08             	mov    0x8(%ebp),%eax
8010112c:	8b 00                	mov    (%eax),%eax
8010112e:	83 f8 02             	cmp    $0x2,%eax
80101131:	75 61                	jne    80101194 <fileread+0xae>
    ilock(f->ip);
80101133:	8b 45 08             	mov    0x8(%ebp),%eax
80101136:	8b 40 10             	mov    0x10(%eax),%eax
80101139:	89 04 24             	mov    %eax,(%esp)
8010113c:	e8 2e 07 00 00       	call   8010186f <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101141:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101144:	8b 45 08             	mov    0x8(%ebp),%eax
80101147:	8b 50 14             	mov    0x14(%eax),%edx
8010114a:	8b 45 08             	mov    0x8(%ebp),%eax
8010114d:	8b 40 10             	mov    0x10(%eax),%eax
80101150:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101154:	89 54 24 08          	mov    %edx,0x8(%esp)
80101158:	8b 55 0c             	mov    0xc(%ebp),%edx
8010115b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010115f:	89 04 24             	mov    %eax,(%esp)
80101162:	e8 01 0c 00 00       	call   80101d68 <readi>
80101167:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010116a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010116e:	7e 11                	jle    80101181 <fileread+0x9b>
      f->off += r;
80101170:	8b 45 08             	mov    0x8(%ebp),%eax
80101173:	8b 50 14             	mov    0x14(%eax),%edx
80101176:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101179:	01 c2                	add    %eax,%edx
8010117b:	8b 45 08             	mov    0x8(%ebp),%eax
8010117e:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101181:	8b 45 08             	mov    0x8(%ebp),%eax
80101184:	8b 40 10             	mov    0x10(%eax),%eax
80101187:	89 04 24             	mov    %eax,(%esp)
8010118a:	e8 31 08 00 00       	call   801019c0 <iunlock>
    return r;
8010118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101192:	eb 0c                	jmp    801011a0 <fileread+0xba>
  }
  panic("fileread");
80101194:	c7 04 24 76 82 10 80 	movl   $0x80108276,(%esp)
8010119b:	e8 9a f3 ff ff       	call   8010053a <panic>
}
801011a0:	c9                   	leave  
801011a1:	c3                   	ret    

801011a2 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011a2:	55                   	push   %ebp
801011a3:	89 e5                	mov    %esp,%ebp
801011a5:	53                   	push   %ebx
801011a6:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011a9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ac:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011b0:	84 c0                	test   %al,%al
801011b2:	75 0a                	jne    801011be <filewrite+0x1c>
    return -1;
801011b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011b9:	e9 23 01 00 00       	jmp    801012e1 <filewrite+0x13f>
  if(f->type == FD_PIPE)
801011be:	8b 45 08             	mov    0x8(%ebp),%eax
801011c1:	8b 00                	mov    (%eax),%eax
801011c3:	83 f8 01             	cmp    $0x1,%eax
801011c6:	75 21                	jne    801011e9 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011c8:	8b 45 08             	mov    0x8(%ebp),%eax
801011cb:	8b 40 0c             	mov    0xc(%eax),%eax
801011ce:	8b 55 10             	mov    0x10(%ebp),%edx
801011d1:	89 54 24 08          	mov    %edx,0x8(%esp)
801011d5:	8b 55 0c             	mov    0xc(%ebp),%edx
801011d8:	89 54 24 04          	mov    %edx,0x4(%esp)
801011dc:	89 04 24             	mov    %eax,(%esp)
801011df:	e8 ed 2b 00 00       	call   80103dd1 <pipewrite>
801011e4:	e9 f8 00 00 00       	jmp    801012e1 <filewrite+0x13f>
  if(f->type == FD_INODE){
801011e9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ec:	8b 00                	mov    (%eax),%eax
801011ee:	83 f8 02             	cmp    $0x2,%eax
801011f1:	0f 85 de 00 00 00    	jne    801012d5 <filewrite+0x133>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801011f7:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801011fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(i < n){
80101205:	e9 a8 00 00 00       	jmp    801012b2 <filewrite+0x110>
      int n1 = n - i;
8010120a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010120d:	8b 55 10             	mov    0x10(%ebp),%edx
80101210:	89 d1                	mov    %edx,%ecx
80101212:	29 c1                	sub    %eax,%ecx
80101214:	89 c8                	mov    %ecx,%eax
80101216:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(n1 > max)
80101219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010121c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010121f:	7e 06                	jle    80101227 <filewrite+0x85>
        n1 = max;
80101221:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101224:	89 45 f4             	mov    %eax,-0xc(%ebp)

      begin_trans();
80101227:	e8 da 1f 00 00       	call   80103206 <begin_trans>
      ilock(f->ip);
8010122c:	8b 45 08             	mov    0x8(%ebp),%eax
8010122f:	8b 40 10             	mov    0x10(%eax),%eax
80101232:	89 04 24             	mov    %eax,(%esp)
80101235:	e8 35 06 00 00       	call   8010186f <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010123a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010123d:	8b 45 08             	mov    0x8(%ebp),%eax
80101240:	8b 48 14             	mov    0x14(%eax),%ecx
80101243:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101246:	89 c2                	mov    %eax,%edx
80101248:	03 55 0c             	add    0xc(%ebp),%edx
8010124b:	8b 45 08             	mov    0x8(%ebp),%eax
8010124e:	8b 40 10             	mov    0x10(%eax),%eax
80101251:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80101255:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101259:	89 54 24 04          	mov    %edx,0x4(%esp)
8010125d:	89 04 24             	mov    %eax,(%esp)
80101260:	e8 6f 0c 00 00       	call   80101ed4 <writei>
80101265:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101268:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010126c:	7e 11                	jle    8010127f <filewrite+0xdd>
        f->off += r;
8010126e:	8b 45 08             	mov    0x8(%ebp),%eax
80101271:	8b 50 14             	mov    0x14(%eax),%edx
80101274:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101277:	01 c2                	add    %eax,%edx
80101279:	8b 45 08             	mov    0x8(%ebp),%eax
8010127c:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010127f:	8b 45 08             	mov    0x8(%ebp),%eax
80101282:	8b 40 10             	mov    0x10(%eax),%eax
80101285:	89 04 24             	mov    %eax,(%esp)
80101288:	e8 33 07 00 00       	call   801019c0 <iunlock>
      commit_trans();
8010128d:	e8 bd 1f 00 00       	call   8010324f <commit_trans>

      if(r < 0)
80101292:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101296:	78 28                	js     801012c0 <filewrite+0x11e>
        break;
      if(r != n1)
80101298:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010129b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010129e:	74 0c                	je     801012ac <filewrite+0x10a>
        panic("short filewrite");
801012a0:	c7 04 24 7f 82 10 80 	movl   $0x8010827f,(%esp)
801012a7:	e8 8e f2 ff ff       	call   8010053a <panic>
      i += r;
801012ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012af:	01 45 f0             	add    %eax,-0x10(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012b5:	3b 45 10             	cmp    0x10(%ebp),%eax
801012b8:	0f 8c 4c ff ff ff    	jl     8010120a <filewrite+0x68>
801012be:	eb 01                	jmp    801012c1 <filewrite+0x11f>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
801012c0:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012c4:	3b 45 10             	cmp    0x10(%ebp),%eax
801012c7:	75 05                	jne    801012ce <filewrite+0x12c>
801012c9:	8b 45 10             	mov    0x10(%ebp),%eax
801012cc:	eb 05                	jmp    801012d3 <filewrite+0x131>
801012ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012d3:	eb 0c                	jmp    801012e1 <filewrite+0x13f>
  }
  panic("filewrite");
801012d5:	c7 04 24 8f 82 10 80 	movl   $0x8010828f,(%esp)
801012dc:	e8 59 f2 ff ff       	call   8010053a <panic>
}
801012e1:	83 c4 24             	add    $0x24,%esp
801012e4:	5b                   	pop    %ebx
801012e5:	5d                   	pop    %ebp
801012e6:	c3                   	ret    
	...

801012e8 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012e8:	55                   	push   %ebp
801012e9:	89 e5                	mov    %esp,%ebp
801012eb:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012ee:	8b 45 08             	mov    0x8(%ebp),%eax
801012f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801012f8:	00 
801012f9:	89 04 24             	mov    %eax,(%esp)
801012fc:	e8 a6 ee ff ff       	call   801001a7 <bread>
80101301:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101307:	83 c0 18             	add    $0x18,%eax
8010130a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101311:	00 
80101312:	89 44 24 04          	mov    %eax,0x4(%esp)
80101316:	8b 45 0c             	mov    0xc(%ebp),%eax
80101319:	89 04 24             	mov    %eax,(%esp)
8010131c:	e8 5c 3c 00 00       	call   80104f7d <memmove>
  brelse(bp);
80101321:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101324:	89 04 24             	mov    %eax,(%esp)
80101327:	e8 ec ee ff ff       	call   80100218 <brelse>
}
8010132c:	c9                   	leave  
8010132d:	c3                   	ret    

8010132e <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010132e:	55                   	push   %ebp
8010132f:	89 e5                	mov    %esp,%ebp
80101331:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101334:	8b 55 0c             	mov    0xc(%ebp),%edx
80101337:	8b 45 08             	mov    0x8(%ebp),%eax
8010133a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010133e:	89 04 24             	mov    %eax,(%esp)
80101341:	e8 61 ee ff ff       	call   801001a7 <bread>
80101346:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010134c:	83 c0 18             	add    $0x18,%eax
8010134f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101356:	00 
80101357:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010135e:	00 
8010135f:	89 04 24             	mov    %eax,(%esp)
80101362:	e8 43 3b 00 00       	call   80104eaa <memset>
  log_write(bp);
80101367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136a:	89 04 24             	mov    %eax,(%esp)
8010136d:	e8 35 1f 00 00       	call   801032a7 <log_write>
  brelse(bp);
80101372:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101375:	89 04 24             	mov    %eax,(%esp)
80101378:	e8 9b ee ff ff       	call   80100218 <brelse>
}
8010137d:	c9                   	leave  
8010137e:	c3                   	ret    

8010137f <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010137f:	55                   	push   %ebp
80101380:	89 e5                	mov    %esp,%ebp
80101382:	53                   	push   %ebx
80101383:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
80101386:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  readsb(dev, &sb);
8010138d:	8b 45 08             	mov    0x8(%ebp),%eax
80101390:	8d 55 d8             	lea    -0x28(%ebp),%edx
80101393:	89 54 24 04          	mov    %edx,0x4(%esp)
80101397:	89 04 24             	mov    %eax,(%esp)
8010139a:	e8 49 ff ff ff       	call   801012e8 <readsb>
  for(b = 0; b < sb.size; b += BPB){
8010139f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
801013a6:	e9 15 01 00 00       	jmp    801014c0 <balloc+0x141>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013ae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013b4:	85 c0                	test   %eax,%eax
801013b6:	0f 48 c2             	cmovs  %edx,%eax
801013b9:	c1 f8 0c             	sar    $0xc,%eax
801013bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013bf:	c1 ea 03             	shr    $0x3,%edx
801013c2:	01 d0                	add    %edx,%eax
801013c4:	83 c0 03             	add    $0x3,%eax
801013c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801013cb:	8b 45 08             	mov    0x8(%ebp),%eax
801013ce:	89 04 24             	mov    %eax,(%esp)
801013d1:	e8 d1 ed ff ff       	call   801001a7 <bread>
801013d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801013e0:	e9 aa 00 00 00       	jmp    8010148f <balloc+0x110>
      m = 1 << (bi % 8);
801013e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801013e8:	89 c2                	mov    %eax,%edx
801013ea:	c1 fa 1f             	sar    $0x1f,%edx
801013ed:	c1 ea 1d             	shr    $0x1d,%edx
801013f0:	01 d0                	add    %edx,%eax
801013f2:	83 e0 07             	and    $0x7,%eax
801013f5:	29 d0                	sub    %edx,%eax
801013f7:	ba 01 00 00 00       	mov    $0x1,%edx
801013fc:	89 d3                	mov    %edx,%ebx
801013fe:	89 c1                	mov    %eax,%ecx
80101400:	d3 e3                	shl    %cl,%ebx
80101402:	89 d8                	mov    %ebx,%eax
80101404:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101407:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010140a:	8d 50 07             	lea    0x7(%eax),%edx
8010140d:	85 c0                	test   %eax,%eax
8010140f:	0f 48 c2             	cmovs  %edx,%eax
80101412:	c1 f8 03             	sar    $0x3,%eax
80101415:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101418:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010141d:	0f b6 c0             	movzbl %al,%eax
80101420:	23 45 f0             	and    -0x10(%ebp),%eax
80101423:	85 c0                	test   %eax,%eax
80101425:	75 64                	jne    8010148b <balloc+0x10c>
        bp->data[bi/8] |= m;  // Mark block in use.
80101427:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010142a:	8d 50 07             	lea    0x7(%eax),%edx
8010142d:	85 c0                	test   %eax,%eax
8010142f:	0f 48 c2             	cmovs  %edx,%eax
80101432:	c1 f8 03             	sar    $0x3,%eax
80101435:	89 c2                	mov    %eax,%edx
80101437:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010143a:	0f b6 44 01 18       	movzbl 0x18(%ecx,%eax,1),%eax
8010143f:	89 c1                	mov    %eax,%ecx
80101441:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101444:	09 c8                	or     %ecx,%eax
80101446:	89 c1                	mov    %eax,%ecx
80101448:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010144b:	88 4c 10 18          	mov    %cl,0x18(%eax,%edx,1)
        log_write(bp);
8010144f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101452:	89 04 24             	mov    %eax,(%esp)
80101455:	e8 4d 1e 00 00       	call   801032a7 <log_write>
        brelse(bp);
8010145a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010145d:	89 04 24             	mov    %eax,(%esp)
80101460:	e8 b3 ed ff ff       	call   80100218 <brelse>
        bzero(dev, b + bi);
80101465:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101468:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010146b:	01 c2                	add    %eax,%edx
8010146d:	8b 45 08             	mov    0x8(%ebp),%eax
80101470:	89 54 24 04          	mov    %edx,0x4(%esp)
80101474:	89 04 24             	mov    %eax,(%esp)
80101477:	e8 b2 fe ff ff       	call   8010132e <bzero>
        return b + bi;
8010147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010147f:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101482:	8d 04 02             	lea    (%edx,%eax,1),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
80101485:	83 c4 34             	add    $0x34,%esp
80101488:	5b                   	pop    %ebx
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010148b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010148f:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
80101496:	7f 16                	jg     801014ae <balloc+0x12f>
80101498:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010149b:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010149e:	8d 04 02             	lea    (%edx,%eax,1),%eax
801014a1:	89 c2                	mov    %eax,%edx
801014a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014a6:	39 c2                	cmp    %eax,%edx
801014a8:	0f 82 37 ff ff ff    	jb     801013e5 <balloc+0x66>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014b1:	89 04 24             	mov    %eax,(%esp)
801014b4:	e8 5f ed ff ff       	call   80100218 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014b9:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
801014c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014c6:	39 c2                	cmp    %eax,%edx
801014c8:	0f 82 dd fe ff ff    	jb     801013ab <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014ce:	c7 04 24 99 82 10 80 	movl   $0x80108299,(%esp)
801014d5:	e8 60 f0 ff ff       	call   8010053a <panic>

801014da <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014da:	55                   	push   %ebp
801014db:	89 e5                	mov    %esp,%ebp
801014dd:	53                   	push   %ebx
801014de:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014e1:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801014e8:	8b 45 08             	mov    0x8(%ebp),%eax
801014eb:	89 04 24             	mov    %eax,(%esp)
801014ee:	e8 f5 fd ff ff       	call   801012e8 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801014f6:	89 c2                	mov    %eax,%edx
801014f8:	c1 ea 0c             	shr    $0xc,%edx
801014fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014fe:	c1 e8 03             	shr    $0x3,%eax
80101501:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101504:	8d 50 03             	lea    0x3(%eax),%edx
80101507:	8b 45 08             	mov    0x8(%ebp),%eax
8010150a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010150e:	89 04 24             	mov    %eax,(%esp)
80101511:	e8 91 ec ff ff       	call   801001a7 <bread>
80101516:	89 45 ec             	mov    %eax,-0x14(%ebp)
  bi = b % BPB;
80101519:	8b 45 0c             	mov    0xc(%ebp),%eax
8010151c:	25 ff 0f 00 00       	and    $0xfff,%eax
80101521:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101524:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101527:	89 c2                	mov    %eax,%edx
80101529:	c1 fa 1f             	sar    $0x1f,%edx
8010152c:	c1 ea 1d             	shr    $0x1d,%edx
8010152f:	01 d0                	add    %edx,%eax
80101531:	83 e0 07             	and    $0x7,%eax
80101534:	29 d0                	sub    %edx,%eax
80101536:	ba 01 00 00 00       	mov    $0x1,%edx
8010153b:	89 d3                	mov    %edx,%ebx
8010153d:	89 c1                	mov    %eax,%ecx
8010153f:	d3 e3                	shl    %cl,%ebx
80101541:	89 d8                	mov    %ebx,%eax
80101543:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101546:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101549:	8d 50 07             	lea    0x7(%eax),%edx
8010154c:	85 c0                	test   %eax,%eax
8010154e:	0f 48 c2             	cmovs  %edx,%eax
80101551:	c1 f8 03             	sar    $0x3,%eax
80101554:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101557:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010155c:	0f b6 c0             	movzbl %al,%eax
8010155f:	23 45 f4             	and    -0xc(%ebp),%eax
80101562:	85 c0                	test   %eax,%eax
80101564:	75 0c                	jne    80101572 <bfree+0x98>
    panic("freeing free block");
80101566:	c7 04 24 af 82 10 80 	movl   $0x801082af,(%esp)
8010156d:	e8 c8 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
80101572:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101575:	8d 50 07             	lea    0x7(%eax),%edx
80101578:	85 c0                	test   %eax,%eax
8010157a:	0f 48 c2             	cmovs  %edx,%eax
8010157d:	c1 f8 03             	sar    $0x3,%eax
80101580:	89 c2                	mov    %eax,%edx
80101582:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101585:	0f b6 44 01 18       	movzbl 0x18(%ecx,%eax,1),%eax
8010158a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010158d:	f7 d1                	not    %ecx
8010158f:	21 c8                	and    %ecx,%eax
80101591:	89 c1                	mov    %eax,%ecx
80101593:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101596:	88 4c 10 18          	mov    %cl,0x18(%eax,%edx,1)
  log_write(bp);
8010159a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010159d:	89 04 24             	mov    %eax,(%esp)
801015a0:	e8 02 1d 00 00       	call   801032a7 <log_write>
  brelse(bp);
801015a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015a8:	89 04 24             	mov    %eax,(%esp)
801015ab:	e8 68 ec ff ff       	call   80100218 <brelse>
}
801015b0:	83 c4 34             	add    $0x34,%esp
801015b3:	5b                   	pop    %ebx
801015b4:	5d                   	pop    %ebp
801015b5:	c3                   	ret    

801015b6 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015b6:	55                   	push   %ebp
801015b7:	89 e5                	mov    %esp,%ebp
801015b9:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015bc:	c7 44 24 04 c2 82 10 	movl   $0x801082c2,0x4(%esp)
801015c3:	80 
801015c4:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801015cb:	e8 6a 36 00 00       	call   80104c3a <initlock>
}
801015d0:	c9                   	leave  
801015d1:	c3                   	ret    

801015d2 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015d2:	55                   	push   %ebp
801015d3:	89 e5                	mov    %esp,%ebp
801015d5:	83 ec 48             	sub    $0x48,%esp
801015d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801015db:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015df:	8b 45 08             	mov    0x8(%ebp),%eax
801015e2:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015e5:	89 54 24 04          	mov    %edx,0x4(%esp)
801015e9:	89 04 24             	mov    %eax,(%esp)
801015ec:	e8 f7 fc ff ff       	call   801012e8 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015f1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
801015f8:	e9 98 00 00 00       	jmp    80101695 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
801015fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101600:	c1 e8 03             	shr    $0x3,%eax
80101603:	83 c0 02             	add    $0x2,%eax
80101606:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160a:	8b 45 08             	mov    0x8(%ebp),%eax
8010160d:	89 04 24             	mov    %eax,(%esp)
80101610:	e8 92 eb ff ff       	call   801001a7 <bread>
80101615:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101618:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010161b:	83 c0 18             	add    $0x18,%eax
8010161e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101621:	83 e2 07             	and    $0x7,%edx
80101624:	c1 e2 06             	shl    $0x6,%edx
80101627:	01 d0                	add    %edx,%eax
80101629:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(dip->type == 0){  // a free inode
8010162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010162f:	0f b7 00             	movzwl (%eax),%eax
80101632:	66 85 c0             	test   %ax,%ax
80101635:	75 4f                	jne    80101686 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101637:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010163e:	00 
8010163f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101646:	00 
80101647:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010164a:	89 04 24             	mov    %eax,(%esp)
8010164d:	e8 58 38 00 00       	call   80104eaa <memset>
      dip->type = type;
80101652:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101655:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101659:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010165c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165f:	89 04 24             	mov    %eax,(%esp)
80101662:	e8 40 1c 00 00       	call   801032a7 <log_write>
      brelse(bp);
80101667:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010166a:	89 04 24             	mov    %eax,(%esp)
8010166d:	e8 a6 eb ff ff       	call   80100218 <brelse>
      return iget(dev, inum);
80101672:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101675:	89 44 24 04          	mov    %eax,0x4(%esp)
80101679:	8b 45 08             	mov    0x8(%ebp),%eax
8010167c:	89 04 24             	mov    %eax,(%esp)
8010167f:	e8 e6 00 00 00       	call   8010176a <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101684:	c9                   	leave  
80101685:	c3                   	ret    
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101686:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101689:	89 04 24             	mov    %eax,(%esp)
8010168c:	e8 87 eb ff ff       	call   80100218 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
80101691:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80101695:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010169b:	39 c2                	cmp    %eax,%edx
8010169d:	0f 82 5a ff ff ff    	jb     801015fd <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016a3:	c7 04 24 c9 82 10 80 	movl   $0x801082c9,(%esp)
801016aa:	e8 8b ee ff ff       	call   8010053a <panic>

801016af <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016af:	55                   	push   %ebp
801016b0:	89 e5                	mov    %esp,%ebp
801016b2:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016b5:	8b 45 08             	mov    0x8(%ebp),%eax
801016b8:	8b 40 04             	mov    0x4(%eax),%eax
801016bb:	c1 e8 03             	shr    $0x3,%eax
801016be:	8d 50 02             	lea    0x2(%eax),%edx
801016c1:	8b 45 08             	mov    0x8(%ebp),%eax
801016c4:	8b 00                	mov    (%eax),%eax
801016c6:	89 54 24 04          	mov    %edx,0x4(%esp)
801016ca:	89 04 24             	mov    %eax,(%esp)
801016cd:	e8 d5 ea ff ff       	call   801001a7 <bread>
801016d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016d8:	83 c0 18             	add    $0x18,%eax
801016db:	89 c2                	mov    %eax,%edx
801016dd:	8b 45 08             	mov    0x8(%ebp),%eax
801016e0:	8b 40 04             	mov    0x4(%eax),%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 04 02             	lea    (%edx,%eax,1),%eax
801016ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip->type = ip->type;
801016ef:	8b 45 08             	mov    0x8(%ebp),%eax
801016f2:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801016f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016fc:	8b 45 08             	mov    0x8(%ebp),%eax
801016ff:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101706:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010170a:	8b 45 08             	mov    0x8(%ebp),%eax
8010170d:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101711:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101714:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101718:	8b 45 08             	mov    0x8(%ebp),%eax
8010171b:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010171f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101722:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101726:	8b 45 08             	mov    0x8(%ebp),%eax
80101729:	8b 50 18             	mov    0x18(%eax),%edx
8010172c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010172f:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101732:	8b 45 08             	mov    0x8(%ebp),%eax
80101735:	8d 50 1c             	lea    0x1c(%eax),%edx
80101738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010173b:	83 c0 0c             	add    $0xc,%eax
8010173e:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101745:	00 
80101746:	89 54 24 04          	mov    %edx,0x4(%esp)
8010174a:	89 04 24             	mov    %eax,(%esp)
8010174d:	e8 2b 38 00 00       	call   80104f7d <memmove>
  log_write(bp);
80101752:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101755:	89 04 24             	mov    %eax,(%esp)
80101758:	e8 4a 1b 00 00       	call   801032a7 <log_write>
  brelse(bp);
8010175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101760:	89 04 24             	mov    %eax,(%esp)
80101763:	e8 b0 ea ff ff       	call   80100218 <brelse>
}
80101768:	c9                   	leave  
80101769:	c3                   	ret    

8010176a <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010176a:	55                   	push   %ebp
8010176b:	89 e5                	mov    %esp,%ebp
8010176d:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101770:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101777:	e8 df 34 00 00       	call   80104c5b <acquire>

  // Is the inode already cached?
  empty = 0;
8010177c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101783:	c7 45 f0 94 e8 10 80 	movl   $0x8010e894,-0x10(%ebp)
8010178a:	eb 59                	jmp    801017e5 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010178c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010178f:	8b 40 08             	mov    0x8(%eax),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 35                	jle    801017cb <iget+0x61>
80101796:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101799:	8b 00                	mov    (%eax),%eax
8010179b:	3b 45 08             	cmp    0x8(%ebp),%eax
8010179e:	75 2b                	jne    801017cb <iget+0x61>
801017a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a3:	8b 40 04             	mov    0x4(%eax),%eax
801017a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017a9:	75 20                	jne    801017cb <iget+0x61>
      ip->ref++;
801017ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ae:	8b 40 08             	mov    0x8(%eax),%eax
801017b1:	8d 50 01             	lea    0x1(%eax),%edx
801017b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017b7:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017ba:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801017c1:	e8 f6 34 00 00       	call   80104cbc <release>
      return ip;
801017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c9:	eb 70                	jmp    8010183b <iget+0xd1>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801017cf:	75 10                	jne    801017e1 <iget+0x77>
801017d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d4:	8b 40 08             	mov    0x8(%eax),%eax
801017d7:	85 c0                	test   %eax,%eax
801017d9:	75 06                	jne    801017e1 <iget+0x77>
      empty = ip;
801017db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017de:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017e1:	83 45 f0 50          	addl   $0x50,-0x10(%ebp)
801017e5:	b8 34 f8 10 80       	mov    $0x8010f834,%eax
801017ea:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801017ed:	72 9d                	jb     8010178c <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801017f3:	75 0c                	jne    80101801 <iget+0x97>
    panic("iget: no inodes");
801017f5:	c7 04 24 db 82 10 80 	movl   $0x801082db,(%esp)
801017fc:	e8 39 ed ff ff       	call   8010053a <panic>

  ip = empty;
80101801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101804:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ip->dev = dev;
80101807:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010180a:	8b 55 08             	mov    0x8(%ebp),%edx
8010180d:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010180f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101812:	8b 55 0c             	mov    0xc(%ebp),%edx
80101815:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101818:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010181b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101822:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101825:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010182c:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101833:	e8 84 34 00 00       	call   80104cbc <release>

  return ip;
80101838:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010183b:	c9                   	leave  
8010183c:	c3                   	ret    

8010183d <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010183d:	55                   	push   %ebp
8010183e:	89 e5                	mov    %esp,%ebp
80101840:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101843:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010184a:	e8 0c 34 00 00       	call   80104c5b <acquire>
  ip->ref++;
8010184f:	8b 45 08             	mov    0x8(%ebp),%eax
80101852:	8b 40 08             	mov    0x8(%eax),%eax
80101855:	8d 50 01             	lea    0x1(%eax),%edx
80101858:	8b 45 08             	mov    0x8(%ebp),%eax
8010185b:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010185e:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101865:	e8 52 34 00 00       	call   80104cbc <release>
  return ip;
8010186a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010186d:	c9                   	leave  
8010186e:	c3                   	ret    

8010186f <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010186f:	55                   	push   %ebp
80101870:	89 e5                	mov    %esp,%ebp
80101872:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101875:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101879:	74 0a                	je     80101885 <ilock+0x16>
8010187b:	8b 45 08             	mov    0x8(%ebp),%eax
8010187e:	8b 40 08             	mov    0x8(%eax),%eax
80101881:	85 c0                	test   %eax,%eax
80101883:	7f 0c                	jg     80101891 <ilock+0x22>
    panic("ilock");
80101885:	c7 04 24 eb 82 10 80 	movl   $0x801082eb,(%esp)
8010188c:	e8 a9 ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101891:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101898:	e8 be 33 00 00       	call   80104c5b <acquire>
  while(ip->flags & I_BUSY)
8010189d:	eb 13                	jmp    801018b2 <ilock+0x43>
    sleep(ip, &icache.lock);
8010189f:	c7 44 24 04 60 e8 10 	movl   $0x8010e860,0x4(%esp)
801018a6:	80 
801018a7:	8b 45 08             	mov    0x8(%ebp),%eax
801018aa:	89 04 24             	mov    %eax,(%esp)
801018ad:	e8 ba 30 00 00       	call   8010496c <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018b2:	8b 45 08             	mov    0x8(%ebp),%eax
801018b5:	8b 40 0c             	mov    0xc(%eax),%eax
801018b8:	83 e0 01             	and    $0x1,%eax
801018bb:	84 c0                	test   %al,%al
801018bd:	75 e0                	jne    8010189f <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018bf:	8b 45 08             	mov    0x8(%ebp),%eax
801018c2:	8b 40 0c             	mov    0xc(%eax),%eax
801018c5:	89 c2                	mov    %eax,%edx
801018c7:	83 ca 01             	or     $0x1,%edx
801018ca:	8b 45 08             	mov    0x8(%ebp),%eax
801018cd:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018d0:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801018d7:	e8 e0 33 00 00       	call   80104cbc <release>

  if(!(ip->flags & I_VALID)){
801018dc:	8b 45 08             	mov    0x8(%ebp),%eax
801018df:	8b 40 0c             	mov    0xc(%eax),%eax
801018e2:	83 e0 02             	and    $0x2,%eax
801018e5:	85 c0                	test   %eax,%eax
801018e7:	0f 85 d1 00 00 00    	jne    801019be <ilock+0x14f>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018ed:	8b 45 08             	mov    0x8(%ebp),%eax
801018f0:	8b 40 04             	mov    0x4(%eax),%eax
801018f3:	c1 e8 03             	shr    $0x3,%eax
801018f6:	8d 50 02             	lea    0x2(%eax),%edx
801018f9:	8b 45 08             	mov    0x8(%ebp),%eax
801018fc:	8b 00                	mov    (%eax),%eax
801018fe:	89 54 24 04          	mov    %edx,0x4(%esp)
80101902:	89 04 24             	mov    %eax,(%esp)
80101905:	e8 9d e8 ff ff       	call   801001a7 <bread>
8010190a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010190d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101910:	83 c0 18             	add    $0x18,%eax
80101913:	89 c2                	mov    %eax,%edx
80101915:	8b 45 08             	mov    0x8(%ebp),%eax
80101918:	8b 40 04             	mov    0x4(%eax),%eax
8010191b:	83 e0 07             	and    $0x7,%eax
8010191e:	c1 e0 06             	shl    $0x6,%eax
80101921:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101924:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ip->type = dip->type;
80101927:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192a:	0f b7 10             	movzwl (%eax),%edx
8010192d:	8b 45 08             	mov    0x8(%ebp),%eax
80101930:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101937:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010193b:	8b 45 08             	mov    0x8(%ebp),%eax
8010193e:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101942:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101945:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101949:	8b 45 08             	mov    0x8(%ebp),%eax
8010194c:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101950:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101953:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101957:	8b 45 08             	mov    0x8(%ebp),%eax
8010195a:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
8010195e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101961:	8b 50 08             	mov    0x8(%eax),%edx
80101964:	8b 45 08             	mov    0x8(%ebp),%eax
80101967:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196d:	8d 50 0c             	lea    0xc(%eax),%edx
80101970:	8b 45 08             	mov    0x8(%ebp),%eax
80101973:	83 c0 1c             	add    $0x1c,%eax
80101976:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010197d:	00 
8010197e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101982:	89 04 24             	mov    %eax,(%esp)
80101985:	e8 f3 35 00 00       	call   80104f7d <memmove>
    brelse(bp);
8010198a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010198d:	89 04 24             	mov    %eax,(%esp)
80101990:	e8 83 e8 ff ff       	call   80100218 <brelse>
    ip->flags |= I_VALID;
80101995:	8b 45 08             	mov    0x8(%ebp),%eax
80101998:	8b 40 0c             	mov    0xc(%eax),%eax
8010199b:	89 c2                	mov    %eax,%edx
8010199d:	83 ca 02             	or     $0x2,%edx
801019a0:	8b 45 08             	mov    0x8(%ebp),%eax
801019a3:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019a6:	8b 45 08             	mov    0x8(%ebp),%eax
801019a9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019ad:	66 85 c0             	test   %ax,%ax
801019b0:	75 0c                	jne    801019be <ilock+0x14f>
      panic("ilock: no type");
801019b2:	c7 04 24 f1 82 10 80 	movl   $0x801082f1,(%esp)
801019b9:	e8 7c eb ff ff       	call   8010053a <panic>
  }
}
801019be:	c9                   	leave  
801019bf:	c3                   	ret    

801019c0 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019ca:	74 17                	je     801019e3 <iunlock+0x23>
801019cc:	8b 45 08             	mov    0x8(%ebp),%eax
801019cf:	8b 40 0c             	mov    0xc(%eax),%eax
801019d2:	83 e0 01             	and    $0x1,%eax
801019d5:	85 c0                	test   %eax,%eax
801019d7:	74 0a                	je     801019e3 <iunlock+0x23>
801019d9:	8b 45 08             	mov    0x8(%ebp),%eax
801019dc:	8b 40 08             	mov    0x8(%eax),%eax
801019df:	85 c0                	test   %eax,%eax
801019e1:	7f 0c                	jg     801019ef <iunlock+0x2f>
    panic("iunlock");
801019e3:	c7 04 24 00 83 10 80 	movl   $0x80108300,(%esp)
801019ea:	e8 4b eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019ef:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801019f6:	e8 60 32 00 00       	call   80104c5b <acquire>
  ip->flags &= ~I_BUSY;
801019fb:	8b 45 08             	mov    0x8(%ebp),%eax
801019fe:	8b 40 0c             	mov    0xc(%eax),%eax
80101a01:	89 c2                	mov    %eax,%edx
80101a03:	83 e2 fe             	and    $0xfffffffe,%edx
80101a06:	8b 45 08             	mov    0x8(%ebp),%eax
80101a09:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0f:	89 04 24             	mov    %eax,(%esp)
80101a12:	e8 3d 30 00 00       	call   80104a54 <wakeup>
  release(&icache.lock);
80101a17:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a1e:	e8 99 32 00 00       	call   80104cbc <release>
}
80101a23:	c9                   	leave  
80101a24:	c3                   	ret    

80101a25 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a25:	55                   	push   %ebp
80101a26:	89 e5                	mov    %esp,%ebp
80101a28:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a2b:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a32:	e8 24 32 00 00       	call   80104c5b <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a37:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3a:	8b 40 08             	mov    0x8(%eax),%eax
80101a3d:	83 f8 01             	cmp    $0x1,%eax
80101a40:	0f 85 93 00 00 00    	jne    80101ad9 <iput+0xb4>
80101a46:	8b 45 08             	mov    0x8(%ebp),%eax
80101a49:	8b 40 0c             	mov    0xc(%eax),%eax
80101a4c:	83 e0 02             	and    $0x2,%eax
80101a4f:	85 c0                	test   %eax,%eax
80101a51:	0f 84 82 00 00 00    	je     80101ad9 <iput+0xb4>
80101a57:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a5e:	66 85 c0             	test   %ax,%ax
80101a61:	75 76                	jne    80101ad9 <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a63:	8b 45 08             	mov    0x8(%ebp),%eax
80101a66:	8b 40 0c             	mov    0xc(%eax),%eax
80101a69:	83 e0 01             	and    $0x1,%eax
80101a6c:	84 c0                	test   %al,%al
80101a6e:	74 0c                	je     80101a7c <iput+0x57>
      panic("iput busy");
80101a70:	c7 04 24 08 83 10 80 	movl   $0x80108308,(%esp)
80101a77:	e8 be ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7f:	8b 40 0c             	mov    0xc(%eax),%eax
80101a82:	89 c2                	mov    %eax,%edx
80101a84:	83 ca 01             	or     $0x1,%edx
80101a87:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8a:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a8d:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a94:	e8 23 32 00 00       	call   80104cbc <release>
    itrunc(ip);
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	89 04 24             	mov    %eax,(%esp)
80101a9f:	e8 72 01 00 00       	call   80101c16 <itrunc>
    ip->type = 0;
80101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa7:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101aad:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab0:	89 04 24             	mov    %eax,(%esp)
80101ab3:	e8 f7 fb ff ff       	call   801016af <iupdate>
    acquire(&icache.lock);
80101ab8:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101abf:	e8 97 31 00 00       	call   80104c5b <acquire>
    ip->flags = 0;
80101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ace:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad1:	89 04 24             	mov    %eax,(%esp)
80101ad4:	e8 7b 2f 00 00       	call   80104a54 <wakeup>
  }
  ip->ref--;
80101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80101adc:	8b 40 08             	mov    0x8(%eax),%eax
80101adf:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae5:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ae8:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101aef:	e8 c8 31 00 00       	call   80104cbc <release>
}
80101af4:	c9                   	leave  
80101af5:	c3                   	ret    

80101af6 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101af6:	55                   	push   %ebp
80101af7:	89 e5                	mov    %esp,%ebp
80101af9:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101afc:	8b 45 08             	mov    0x8(%ebp),%eax
80101aff:	89 04 24             	mov    %eax,(%esp)
80101b02:	e8 b9 fe ff ff       	call   801019c0 <iunlock>
  iput(ip);
80101b07:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0a:	89 04 24             	mov    %eax,(%esp)
80101b0d:	e8 13 ff ff ff       	call   80101a25 <iput>
}
80101b12:	c9                   	leave  
80101b13:	c3                   	ret    

80101b14 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b14:	55                   	push   %ebp
80101b15:	89 e5                	mov    %esp,%ebp
80101b17:	53                   	push   %ebx
80101b18:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b1b:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b1f:	77 3e                	ja     80101b5f <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b21:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b24:	8b 45 08             	mov    0x8(%ebp),%eax
80101b27:	83 c2 04             	add    $0x4,%edx
80101b2a:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101b31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101b35:	75 20                	jne    80101b57 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b37:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80101b3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3d:	8b 00                	mov    (%eax),%eax
80101b3f:	89 04 24             	mov    %eax,(%esp)
80101b42:	e8 38 f8 ff ff       	call   8010137f <balloc>
80101b47:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4d:	8d 4b 04             	lea    0x4(%ebx),%ecx
80101b50:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101b53:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101b5a:	e9 b1 00 00 00       	jmp    80101c10 <bmap+0xfc>
  }
  bn -= NDIRECT;
80101b5f:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b63:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b67:	0f 87 97 00 00 00    	ja     80101c04 <bmap+0xf0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b73:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101b76:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101b7a:	75 19                	jne    80101b95 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7f:	8b 00                	mov    (%eax),%eax
80101b81:	89 04 24             	mov    %eax,(%esp)
80101b84:	e8 f6 f7 ff ff       	call   8010137f <balloc>
80101b89:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101b92:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b95:	8b 45 08             	mov    0x8(%ebp),%eax
80101b98:	8b 00                	mov    (%eax),%eax
80101b9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101b9d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ba1:	89 04 24             	mov    %eax,(%esp)
80101ba4:	e8 fe e5 ff ff       	call   801001a7 <bread>
80101ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a = (uint*)bp->data;
80101bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101baf:	83 c0 18             	add    $0x18,%eax
80101bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((addr = a[bn]) == 0){
80101bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bb8:	c1 e0 02             	shl    $0x2,%eax
80101bbb:	03 45 f0             	add    -0x10(%ebp),%eax
80101bbe:	8b 00                	mov    (%eax),%eax
80101bc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101bc3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101bc7:	75 2b                	jne    80101bf4 <bmap+0xe0>
      a[bn] = addr = balloc(ip->dev);
80101bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bcc:	c1 e0 02             	shl    $0x2,%eax
80101bcf:	89 c3                	mov    %eax,%ebx
80101bd1:	03 5d f0             	add    -0x10(%ebp),%ebx
80101bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd7:	8b 00                	mov    (%eax),%eax
80101bd9:	89 04 24             	mov    %eax,(%esp)
80101bdc:	e8 9e f7 ff ff       	call   8010137f <balloc>
80101be1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101be7:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bec:	89 04 24             	mov    %eax,(%esp)
80101bef:	e8 b3 16 00 00       	call   801032a7 <log_write>
    }
    brelse(bp);
80101bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bf7:	89 04 24             	mov    %eax,(%esp)
80101bfa:	e8 19 e6 ff ff       	call   80100218 <brelse>
    return addr;
80101bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c02:	eb 0c                	jmp    80101c10 <bmap+0xfc>
  }

  panic("bmap: out of range");
80101c04:	c7 04 24 12 83 10 80 	movl   $0x80108312,(%esp)
80101c0b:	e8 2a e9 ff ff       	call   8010053a <panic>
}
80101c10:	83 c4 24             	add    $0x24,%esp
80101c13:	5b                   	pop    %ebx
80101c14:	5d                   	pop    %ebp
80101c15:	c3                   	ret    

80101c16 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c16:	55                   	push   %ebp
80101c17:	89 e5                	mov    %esp,%ebp
80101c19:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c1c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80101c23:	eb 44                	jmp    80101c69 <itrunc+0x53>
    if(ip->addrs[i]){
80101c25:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101c28:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2b:	83 c2 04             	add    $0x4,%edx
80101c2e:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c32:	85 c0                	test   %eax,%eax
80101c34:	74 2f                	je     80101c65 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c36:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101c39:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3c:	83 c2 04             	add    $0x4,%edx
80101c3f:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c43:	8b 45 08             	mov    0x8(%ebp),%eax
80101c46:	8b 00                	mov    (%eax),%eax
80101c48:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c4c:	89 04 24             	mov    %eax,(%esp)
80101c4f:	e8 86 f8 ff ff       	call   801014da <bfree>
      ip->addrs[i] = 0;
80101c54:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101c57:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5a:	83 c2 04             	add    $0x4,%edx
80101c5d:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c64:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c65:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
80101c69:	83 7d e8 0b          	cmpl   $0xb,-0x18(%ebp)
80101c6d:	7e b6                	jle    80101c25 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c72:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c75:	85 c0                	test   %eax,%eax
80101c77:	0f 84 8f 00 00 00    	je     80101d0c <itrunc+0xf6>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c80:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c83:	8b 45 08             	mov    0x8(%ebp),%eax
80101c86:	8b 00                	mov    (%eax),%eax
80101c88:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c8c:	89 04 24             	mov    %eax,(%esp)
80101c8f:	e8 13 e5 ff ff       	call   801001a7 <bread>
80101c94:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c9a:	83 c0 18             	add    $0x18,%eax
80101c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ca0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101ca7:	eb 2f                	jmp    80101cd8 <itrunc+0xc2>
      if(a[j])
80101ca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cac:	c1 e0 02             	shl    $0x2,%eax
80101caf:	03 45 f4             	add    -0xc(%ebp),%eax
80101cb2:	8b 00                	mov    (%eax),%eax
80101cb4:	85 c0                	test   %eax,%eax
80101cb6:	74 1c                	je     80101cd4 <itrunc+0xbe>
        bfree(ip->dev, a[j]);
80101cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cbb:	c1 e0 02             	shl    $0x2,%eax
80101cbe:	03 45 f4             	add    -0xc(%ebp),%eax
80101cc1:	8b 10                	mov    (%eax),%edx
80101cc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc6:	8b 00                	mov    (%eax),%eax
80101cc8:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ccc:	89 04 24             	mov    %eax,(%esp)
80101ccf:	e8 06 f8 ff ff       	call   801014da <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101cd4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80101cd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cdb:	83 f8 7f             	cmp    $0x7f,%eax
80101cde:	76 c9                	jbe    80101ca9 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ce3:	89 04 24             	mov    %eax,(%esp)
80101ce6:	e8 2d e5 ff ff       	call   80100218 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cee:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf4:	8b 00                	mov    (%eax),%eax
80101cf6:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cfa:	89 04 24             	mov    %eax,(%esp)
80101cfd:	e8 d8 f7 ff ff       	call   801014da <bfree>
    ip->addrs[NDIRECT] = 0;
80101d02:	8b 45 08             	mov    0x8(%ebp),%eax
80101d05:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0f:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d16:	8b 45 08             	mov    0x8(%ebp),%eax
80101d19:	89 04 24             	mov    %eax,(%esp)
80101d1c:	e8 8e f9 ff ff       	call   801016af <iupdate>
}
80101d21:	c9                   	leave  
80101d22:	c3                   	ret    

80101d23 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d23:	55                   	push   %ebp
80101d24:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d26:	8b 45 08             	mov    0x8(%ebp),%eax
80101d29:	8b 00                	mov    (%eax),%eax
80101d2b:	89 c2                	mov    %eax,%edx
80101d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d30:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d33:	8b 45 08             	mov    0x8(%ebp),%eax
80101d36:	8b 50 04             	mov    0x4(%eax),%edx
80101d39:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d3c:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d42:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d46:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d49:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4f:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d53:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d56:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5d:	8b 50 18             	mov    0x18(%eax),%edx
80101d60:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d63:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d66:	5d                   	pop    %ebp
80101d67:	c3                   	ret    

80101d68 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d68:	55                   	push   %ebp
80101d69:	89 e5                	mov    %esp,%ebp
80101d6b:	53                   	push   %ebx
80101d6c:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d72:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d76:	66 83 f8 03          	cmp    $0x3,%ax
80101d7a:	75 60                	jne    80101ddc <readi+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d83:	66 85 c0             	test   %ax,%ax
80101d86:	78 20                	js     80101da8 <readi+0x40>
80101d88:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d8f:	66 83 f8 09          	cmp    $0x9,%ax
80101d93:	7f 13                	jg     80101da8 <readi+0x40>
80101d95:	8b 45 08             	mov    0x8(%ebp),%eax
80101d98:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d9c:	98                   	cwtl   
80101d9d:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101da4:	85 c0                	test   %eax,%eax
80101da6:	75 0a                	jne    80101db2 <readi+0x4a>
      return -1;
80101da8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dad:	e9 1c 01 00 00       	jmp    80101ece <readi+0x166>
    return devsw[ip->major].read(ip, dst, n);
80101db2:	8b 45 08             	mov    0x8(%ebp),%eax
80101db5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101db9:	98                   	cwtl   
80101dba:	8b 14 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%edx
80101dc1:	8b 45 14             	mov    0x14(%ebp),%eax
80101dc4:	89 44 24 08          	mov    %eax,0x8(%esp)
80101dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dcb:	89 44 24 04          	mov    %eax,0x4(%esp)
80101dcf:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd2:	89 04 24             	mov    %eax,(%esp)
80101dd5:	ff d2                	call   *%edx
80101dd7:	e9 f2 00 00 00       	jmp    80101ece <readi+0x166>
  }

  if(off > ip->size || off + n < off)
80101ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ddf:	8b 40 18             	mov    0x18(%eax),%eax
80101de2:	3b 45 10             	cmp    0x10(%ebp),%eax
80101de5:	72 0e                	jb     80101df5 <readi+0x8d>
80101de7:	8b 45 14             	mov    0x14(%ebp),%eax
80101dea:	8b 55 10             	mov    0x10(%ebp),%edx
80101ded:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101df0:	3b 45 10             	cmp    0x10(%ebp),%eax
80101df3:	73 0a                	jae    80101dff <readi+0x97>
    return -1;
80101df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dfa:	e9 cf 00 00 00       	jmp    80101ece <readi+0x166>
  if(off + n > ip->size)
80101dff:	8b 45 14             	mov    0x14(%ebp),%eax
80101e02:	8b 55 10             	mov    0x10(%ebp),%edx
80101e05:	01 c2                	add    %eax,%edx
80101e07:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0a:	8b 40 18             	mov    0x18(%eax),%eax
80101e0d:	39 c2                	cmp    %eax,%edx
80101e0f:	76 0c                	jbe    80101e1d <readi+0xb5>
    n = ip->size - off;
80101e11:	8b 45 08             	mov    0x8(%ebp),%eax
80101e14:	8b 40 18             	mov    0x18(%eax),%eax
80101e17:	2b 45 10             	sub    0x10(%ebp),%eax
80101e1a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e1d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101e24:	e9 96 00 00 00       	jmp    80101ebf <readi+0x157>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e29:	8b 45 10             	mov    0x10(%ebp),%eax
80101e2c:	c1 e8 09             	shr    $0x9,%eax
80101e2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e33:	8b 45 08             	mov    0x8(%ebp),%eax
80101e36:	89 04 24             	mov    %eax,(%esp)
80101e39:	e8 d6 fc ff ff       	call   80101b14 <bmap>
80101e3e:	8b 55 08             	mov    0x8(%ebp),%edx
80101e41:	8b 12                	mov    (%edx),%edx
80101e43:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e47:	89 14 24             	mov    %edx,(%esp)
80101e4a:	e8 58 e3 ff ff       	call   801001a7 <bread>
80101e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e52:	8b 45 10             	mov    0x10(%ebp),%eax
80101e55:	89 c2                	mov    %eax,%edx
80101e57:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101e5d:	b8 00 02 00 00       	mov    $0x200,%eax
80101e62:	89 c1                	mov    %eax,%ecx
80101e64:	29 d1                	sub    %edx,%ecx
80101e66:	89 ca                	mov    %ecx,%edx
80101e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e6b:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e6e:	89 cb                	mov    %ecx,%ebx
80101e70:	29 c3                	sub    %eax,%ebx
80101e72:	89 d8                	mov    %ebx,%eax
80101e74:	39 c2                	cmp    %eax,%edx
80101e76:	0f 46 c2             	cmovbe %edx,%eax
80101e79:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e7f:	8d 50 18             	lea    0x18(%eax),%edx
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
80101e85:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e8a:	01 c2                	add    %eax,%edx
80101e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e8f:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e93:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e97:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e9a:	89 04 24             	mov    %eax,(%esp)
80101e9d:	e8 db 30 00 00       	call   80104f7d <memmove>
    brelse(bp);
80101ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ea5:	89 04 24             	mov    %eax,(%esp)
80101ea8:	e8 6b e3 ff ff       	call   80100218 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eb0:	01 45 ec             	add    %eax,-0x14(%ebp)
80101eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eb6:	01 45 10             	add    %eax,0x10(%ebp)
80101eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ebc:	01 45 0c             	add    %eax,0xc(%ebp)
80101ebf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ec2:	3b 45 14             	cmp    0x14(%ebp),%eax
80101ec5:	0f 82 5e ff ff ff    	jb     80101e29 <readi+0xc1>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101ecb:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101ece:	83 c4 24             	add    $0x24,%esp
80101ed1:	5b                   	pop    %ebx
80101ed2:	5d                   	pop    %ebp
80101ed3:	c3                   	ret    

80101ed4 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ed4:	55                   	push   %ebp
80101ed5:	89 e5                	mov    %esp,%ebp
80101ed7:	53                   	push   %ebx
80101ed8:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101edb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ede:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ee2:	66 83 f8 03          	cmp    $0x3,%ax
80101ee6:	75 60                	jne    80101f48 <writei+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eef:	66 85 c0             	test   %ax,%ax
80101ef2:	78 20                	js     80101f14 <writei+0x40>
80101ef4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101efb:	66 83 f8 09          	cmp    $0x9,%ax
80101eff:	7f 13                	jg     80101f14 <writei+0x40>
80101f01:	8b 45 08             	mov    0x8(%ebp),%eax
80101f04:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f08:	98                   	cwtl   
80101f09:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101f10:	85 c0                	test   %eax,%eax
80101f12:	75 0a                	jne    80101f1e <writei+0x4a>
      return -1;
80101f14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f19:	e9 48 01 00 00       	jmp    80102066 <writei+0x192>
    return devsw[ip->major].write(ip, src, n);
80101f1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f21:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f25:	98                   	cwtl   
80101f26:	8b 14 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%edx
80101f2d:	8b 45 14             	mov    0x14(%ebp),%eax
80101f30:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f34:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f37:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3e:	89 04 24             	mov    %eax,(%esp)
80101f41:	ff d2                	call   *%edx
80101f43:	e9 1e 01 00 00       	jmp    80102066 <writei+0x192>
  }

  if(off > ip->size || off + n < off)
80101f48:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4b:	8b 40 18             	mov    0x18(%eax),%eax
80101f4e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f51:	72 0e                	jb     80101f61 <writei+0x8d>
80101f53:	8b 45 14             	mov    0x14(%ebp),%eax
80101f56:	8b 55 10             	mov    0x10(%ebp),%edx
80101f59:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101f5c:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f5f:	73 0a                	jae    80101f6b <writei+0x97>
    return -1;
80101f61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f66:	e9 fb 00 00 00       	jmp    80102066 <writei+0x192>
  if(off + n > MAXFILE*BSIZE)
80101f6b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f6e:	8b 55 10             	mov    0x10(%ebp),%edx
80101f71:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101f74:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f79:	76 0a                	jbe    80101f85 <writei+0xb1>
    return -1;
80101f7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f80:	e9 e1 00 00 00       	jmp    80102066 <writei+0x192>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f85:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101f8c:	e9 a1 00 00 00       	jmp    80102032 <writei+0x15e>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f91:	8b 45 10             	mov    0x10(%ebp),%eax
80101f94:	c1 e8 09             	shr    $0x9,%eax
80101f97:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9e:	89 04 24             	mov    %eax,(%esp)
80101fa1:	e8 6e fb ff ff       	call   80101b14 <bmap>
80101fa6:	8b 55 08             	mov    0x8(%ebp),%edx
80101fa9:	8b 12                	mov    (%edx),%edx
80101fab:	89 44 24 04          	mov    %eax,0x4(%esp)
80101faf:	89 14 24             	mov    %edx,(%esp)
80101fb2:	e8 f0 e1 ff ff       	call   801001a7 <bread>
80101fb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fba:	8b 45 10             	mov    0x10(%ebp),%eax
80101fbd:	89 c2                	mov    %eax,%edx
80101fbf:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101fc5:	b8 00 02 00 00       	mov    $0x200,%eax
80101fca:	89 c1                	mov    %eax,%ecx
80101fcc:	29 d1                	sub    %edx,%ecx
80101fce:	89 ca                	mov    %ecx,%edx
80101fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fd3:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fd6:	89 cb                	mov    %ecx,%ebx
80101fd8:	29 c3                	sub    %eax,%ebx
80101fda:	89 d8                	mov    %ebx,%eax
80101fdc:	39 c2                	cmp    %eax,%edx
80101fde:	0f 46 c2             	cmovbe %edx,%eax
80101fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fe7:	8d 50 18             	lea    0x18(%eax),%edx
80101fea:	8b 45 10             	mov    0x10(%ebp),%eax
80101fed:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ff2:	01 c2                	add    %eax,%edx
80101ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff7:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ffe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102002:	89 14 24             	mov    %edx,(%esp)
80102005:	e8 73 2f 00 00       	call   80104f7d <memmove>
    log_write(bp);
8010200a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010200d:	89 04 24             	mov    %eax,(%esp)
80102010:	e8 92 12 00 00       	call   801032a7 <log_write>
    brelse(bp);
80102015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102018:	89 04 24             	mov    %eax,(%esp)
8010201b:	e8 f8 e1 ff ff       	call   80100218 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102020:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102023:	01 45 ec             	add    %eax,-0x14(%ebp)
80102026:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102029:	01 45 10             	add    %eax,0x10(%ebp)
8010202c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010202f:	01 45 0c             	add    %eax,0xc(%ebp)
80102032:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102035:	3b 45 14             	cmp    0x14(%ebp),%eax
80102038:	0f 82 53 ff ff ff    	jb     80101f91 <writei+0xbd>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010203e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102042:	74 1f                	je     80102063 <writei+0x18f>
80102044:	8b 45 08             	mov    0x8(%ebp),%eax
80102047:	8b 40 18             	mov    0x18(%eax),%eax
8010204a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010204d:	73 14                	jae    80102063 <writei+0x18f>
    ip->size = off;
8010204f:	8b 45 08             	mov    0x8(%ebp),%eax
80102052:	8b 55 10             	mov    0x10(%ebp),%edx
80102055:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102058:	8b 45 08             	mov    0x8(%ebp),%eax
8010205b:	89 04 24             	mov    %eax,(%esp)
8010205e:	e8 4c f6 ff ff       	call   801016af <iupdate>
  }
  return n;
80102063:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102066:	83 c4 24             	add    $0x24,%esp
80102069:	5b                   	pop    %ebx
8010206a:	5d                   	pop    %ebp
8010206b:	c3                   	ret    

8010206c <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010206c:	55                   	push   %ebp
8010206d:	89 e5                	mov    %esp,%ebp
8010206f:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102072:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102079:	00 
8010207a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010207d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102081:	8b 45 08             	mov    0x8(%ebp),%eax
80102084:	89 04 24             	mov    %eax,(%esp)
80102087:	e8 99 2f 00 00       	call   80105025 <strncmp>
}
8010208c:	c9                   	leave  
8010208d:	c3                   	ret    

8010208e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010208e:	55                   	push   %ebp
8010208f:	89 e5                	mov    %esp,%ebp
80102091:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102094:	8b 45 08             	mov    0x8(%ebp),%eax
80102097:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010209b:	66 83 f8 01          	cmp    $0x1,%ax
8010209f:	74 0c                	je     801020ad <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020a1:	c7 04 24 25 83 10 80 	movl   $0x80108325,(%esp)
801020a8:	e8 8d e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801020b4:	e9 87 00 00 00       	jmp    80102140 <dirlookup+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020b9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020bc:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020c3:	00 
801020c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801020c7:	89 54 24 08          	mov    %edx,0x8(%esp)
801020cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801020cf:	8b 45 08             	mov    0x8(%ebp),%eax
801020d2:	89 04 24             	mov    %eax,(%esp)
801020d5:	e8 8e fc ff ff       	call   80101d68 <readi>
801020da:	83 f8 10             	cmp    $0x10,%eax
801020dd:	74 0c                	je     801020eb <dirlookup+0x5d>
      panic("dirlink read");
801020df:	c7 04 24 37 83 10 80 	movl   $0x80108337,(%esp)
801020e6:	e8 4f e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801020eb:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020ef:	66 85 c0             	test   %ax,%ax
801020f2:	74 47                	je     8010213b <dirlookup+0xad>
      continue;
    if(namecmp(name, de.name) == 0){
801020f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020f7:	83 c0 02             	add    $0x2,%eax
801020fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801020fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80102101:	89 04 24             	mov    %eax,(%esp)
80102104:	e8 63 ff ff ff       	call   8010206c <namecmp>
80102109:	85 c0                	test   %eax,%eax
8010210b:	75 2f                	jne    8010213c <dirlookup+0xae>
      // entry matches path element
      if(poff)
8010210d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102111:	74 08                	je     8010211b <dirlookup+0x8d>
        *poff = off;
80102113:	8b 45 10             	mov    0x10(%ebp),%eax
80102116:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102119:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010211b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010211f:	0f b7 c0             	movzwl %ax,%eax
80102122:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return iget(dp->dev, inum);
80102125:	8b 45 08             	mov    0x8(%ebp),%eax
80102128:	8b 00                	mov    (%eax),%eax
8010212a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010212d:	89 54 24 04          	mov    %edx,0x4(%esp)
80102131:	89 04 24             	mov    %eax,(%esp)
80102134:	e8 31 f6 ff ff       	call   8010176a <iget>
80102139:	eb 19                	jmp    80102154 <dirlookup+0xc6>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010213b:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010213c:	83 45 f0 10          	addl   $0x10,-0x10(%ebp)
80102140:	8b 45 08             	mov    0x8(%ebp),%eax
80102143:	8b 40 18             	mov    0x18(%eax),%eax
80102146:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102149:	0f 87 6a ff ff ff    	ja     801020b9 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010214f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102154:	c9                   	leave  
80102155:	c3                   	ret    

80102156 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102156:	55                   	push   %ebp
80102157:	89 e5                	mov    %esp,%ebp
80102159:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010215c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102163:	00 
80102164:	8b 45 0c             	mov    0xc(%ebp),%eax
80102167:	89 44 24 04          	mov    %eax,0x4(%esp)
8010216b:	8b 45 08             	mov    0x8(%ebp),%eax
8010216e:	89 04 24             	mov    %eax,(%esp)
80102171:	e8 18 ff ff ff       	call   8010208e <dirlookup>
80102176:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102179:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010217d:	74 15                	je     80102194 <dirlink+0x3e>
    iput(ip);
8010217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102182:	89 04 24             	mov    %eax,(%esp)
80102185:	e8 9b f8 ff ff       	call   80101a25 <iput>
    return -1;
8010218a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010218f:	e9 b8 00 00 00       	jmp    8010224c <dirlink+0xf6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102194:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010219b:	eb 44                	jmp    801021e1 <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010219d:	8b 55 f0             	mov    -0x10(%ebp),%edx
801021a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021a3:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021aa:	00 
801021ab:	89 54 24 08          	mov    %edx,0x8(%esp)
801021af:	89 44 24 04          	mov    %eax,0x4(%esp)
801021b3:	8b 45 08             	mov    0x8(%ebp),%eax
801021b6:	89 04 24             	mov    %eax,(%esp)
801021b9:	e8 aa fb ff ff       	call   80101d68 <readi>
801021be:	83 f8 10             	cmp    $0x10,%eax
801021c1:	74 0c                	je     801021cf <dirlink+0x79>
      panic("dirlink read");
801021c3:	c7 04 24 37 83 10 80 	movl   $0x80108337,(%esp)
801021ca:	e8 6b e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021cf:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021d3:	66 85 c0             	test   %ax,%ax
801021d6:	74 18                	je     801021f0 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021db:	83 c0 10             	add    $0x10,%eax
801021de:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801021e4:	8b 45 08             	mov    0x8(%ebp),%eax
801021e7:	8b 40 18             	mov    0x18(%eax),%eax
801021ea:	39 c2                	cmp    %eax,%edx
801021ec:	72 af                	jb     8010219d <dirlink+0x47>
801021ee:	eb 01                	jmp    801021f1 <dirlink+0x9b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801021f0:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801021f1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021f8:	00 
801021f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801021fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80102200:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102203:	83 c0 02             	add    $0x2,%eax
80102206:	89 04 24             	mov    %eax,(%esp)
80102209:	e8 6f 2e 00 00       	call   8010507d <strncpy>
  de.inum = inum;
8010220e:	8b 45 10             	mov    0x10(%ebp),%eax
80102211:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102215:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102218:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010221b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102222:	00 
80102223:	89 54 24 08          	mov    %edx,0x8(%esp)
80102227:	89 44 24 04          	mov    %eax,0x4(%esp)
8010222b:	8b 45 08             	mov    0x8(%ebp),%eax
8010222e:	89 04 24             	mov    %eax,(%esp)
80102231:	e8 9e fc ff ff       	call   80101ed4 <writei>
80102236:	83 f8 10             	cmp    $0x10,%eax
80102239:	74 0c                	je     80102247 <dirlink+0xf1>
    panic("dirlink");
8010223b:	c7 04 24 44 83 10 80 	movl   $0x80108344,(%esp)
80102242:	e8 f3 e2 ff ff       	call   8010053a <panic>
  
  return 0;
80102247:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010224c:	c9                   	leave  
8010224d:	c3                   	ret    

8010224e <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010224e:	55                   	push   %ebp
8010224f:	89 e5                	mov    %esp,%ebp
80102251:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102254:	eb 04                	jmp    8010225a <skipelem+0xc>
    path++;
80102256:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010225a:	8b 45 08             	mov    0x8(%ebp),%eax
8010225d:	0f b6 00             	movzbl (%eax),%eax
80102260:	3c 2f                	cmp    $0x2f,%al
80102262:	74 f2                	je     80102256 <skipelem+0x8>
    path++;
  if(*path == 0)
80102264:	8b 45 08             	mov    0x8(%ebp),%eax
80102267:	0f b6 00             	movzbl (%eax),%eax
8010226a:	84 c0                	test   %al,%al
8010226c:	75 0a                	jne    80102278 <skipelem+0x2a>
    return 0;
8010226e:	b8 00 00 00 00       	mov    $0x0,%eax
80102273:	e9 86 00 00 00       	jmp    801022fe <skipelem+0xb0>
  s = path;
80102278:	8b 45 08             	mov    0x8(%ebp),%eax
8010227b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(*path != '/' && *path != 0)
8010227e:	eb 04                	jmp    80102284 <skipelem+0x36>
    path++;
80102280:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102284:	8b 45 08             	mov    0x8(%ebp),%eax
80102287:	0f b6 00             	movzbl (%eax),%eax
8010228a:	3c 2f                	cmp    $0x2f,%al
8010228c:	74 0a                	je     80102298 <skipelem+0x4a>
8010228e:	8b 45 08             	mov    0x8(%ebp),%eax
80102291:	0f b6 00             	movzbl (%eax),%eax
80102294:	84 c0                	test   %al,%al
80102296:	75 e8                	jne    80102280 <skipelem+0x32>
    path++;
  len = path - s;
80102298:	8b 55 08             	mov    0x8(%ebp),%edx
8010229b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010229e:	89 d1                	mov    %edx,%ecx
801022a0:	29 c1                	sub    %eax,%ecx
801022a2:	89 c8                	mov    %ecx,%eax
801022a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(len >= DIRSIZ)
801022a7:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801022ab:	7e 1c                	jle    801022c9 <skipelem+0x7b>
    memmove(name, s, DIRSIZ);
801022ad:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022b4:	00 
801022b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801022bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801022bf:	89 04 24             	mov    %eax,(%esp)
801022c2:	e8 b6 2c 00 00       	call   80104f7d <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022c7:	eb 28                	jmp    801022f1 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022cc:	89 44 24 08          	mov    %eax,0x8(%esp)
801022d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801022da:	89 04 24             	mov    %eax,(%esp)
801022dd:	e8 9b 2c 00 00       	call   80104f7d <memmove>
    name[len] = 0;
801022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022e5:	03 45 0c             	add    0xc(%ebp),%eax
801022e8:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022eb:	eb 04                	jmp    801022f1 <skipelem+0xa3>
    path++;
801022ed:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022f1:	8b 45 08             	mov    0x8(%ebp),%eax
801022f4:	0f b6 00             	movzbl (%eax),%eax
801022f7:	3c 2f                	cmp    $0x2f,%al
801022f9:	74 f2                	je     801022ed <skipelem+0x9f>
    path++;
  return path;
801022fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022fe:	c9                   	leave  
801022ff:	c3                   	ret    

80102300 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102306:	8b 45 08             	mov    0x8(%ebp),%eax
80102309:	0f b6 00             	movzbl (%eax),%eax
8010230c:	3c 2f                	cmp    $0x2f,%al
8010230e:	75 1c                	jne    8010232c <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102310:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102317:	00 
80102318:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010231f:	e8 46 f4 ff ff       	call   8010176a <iget>
80102324:	89 45 f0             	mov    %eax,-0x10(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102327:	e9 af 00 00 00       	jmp    801023db <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010232c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102332:	8b 40 68             	mov    0x68(%eax),%eax
80102335:	89 04 24             	mov    %eax,(%esp)
80102338:	e8 00 f5 ff ff       	call   8010183d <idup>
8010233d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  while((path = skipelem(path, name)) != 0){
80102340:	e9 96 00 00 00       	jmp    801023db <namex+0xdb>
    ilock(ip);
80102345:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102348:	89 04 24             	mov    %eax,(%esp)
8010234b:	e8 1f f5 ff ff       	call   8010186f <ilock>
    if(ip->type != T_DIR){
80102350:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102353:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102357:	66 83 f8 01          	cmp    $0x1,%ax
8010235b:	74 15                	je     80102372 <namex+0x72>
      iunlockput(ip);
8010235d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102360:	89 04 24             	mov    %eax,(%esp)
80102363:	e8 8e f7 ff ff       	call   80101af6 <iunlockput>
      return 0;
80102368:	b8 00 00 00 00       	mov    $0x0,%eax
8010236d:	e9 a3 00 00 00       	jmp    80102415 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
80102372:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102376:	74 1d                	je     80102395 <namex+0x95>
80102378:	8b 45 08             	mov    0x8(%ebp),%eax
8010237b:	0f b6 00             	movzbl (%eax),%eax
8010237e:	84 c0                	test   %al,%al
80102380:	75 13                	jne    80102395 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
80102382:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102385:	89 04 24             	mov    %eax,(%esp)
80102388:	e8 33 f6 ff ff       	call   801019c0 <iunlock>
      return ip;
8010238d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102390:	e9 80 00 00 00       	jmp    80102415 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102395:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010239c:	00 
8010239d:	8b 45 10             	mov    0x10(%ebp),%eax
801023a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801023a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023a7:	89 04 24             	mov    %eax,(%esp)
801023aa:	e8 df fc ff ff       	call   8010208e <dirlookup>
801023af:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801023b6:	75 12                	jne    801023ca <namex+0xca>
      iunlockput(ip);
801023b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023bb:	89 04 24             	mov    %eax,(%esp)
801023be:	e8 33 f7 ff ff       	call   80101af6 <iunlockput>
      return 0;
801023c3:	b8 00 00 00 00       	mov    $0x0,%eax
801023c8:	eb 4b                	jmp    80102415 <namex+0x115>
    }
    iunlockput(ip);
801023ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023cd:	89 04 24             	mov    %eax,(%esp)
801023d0:	e8 21 f7 ff ff       	call   80101af6 <iunlockput>
    ip = next;
801023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023db:	8b 45 10             	mov    0x10(%ebp),%eax
801023de:	89 44 24 04          	mov    %eax,0x4(%esp)
801023e2:	8b 45 08             	mov    0x8(%ebp),%eax
801023e5:	89 04 24             	mov    %eax,(%esp)
801023e8:	e8 61 fe ff ff       	call   8010224e <skipelem>
801023ed:	89 45 08             	mov    %eax,0x8(%ebp)
801023f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023f4:	0f 85 4b ff ff ff    	jne    80102345 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023fe:	74 12                	je     80102412 <namex+0x112>
    iput(ip);
80102400:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102403:	89 04 24             	mov    %eax,(%esp)
80102406:	e8 1a f6 ff ff       	call   80101a25 <iput>
    return 0;
8010240b:	b8 00 00 00 00       	mov    $0x0,%eax
80102410:	eb 03                	jmp    80102415 <namex+0x115>
  }
  return ip;
80102412:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80102415:	c9                   	leave  
80102416:	c3                   	ret    

80102417 <namei>:

struct inode*
namei(char *path)
{
80102417:	55                   	push   %ebp
80102418:	89 e5                	mov    %esp,%ebp
8010241a:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010241d:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102420:	89 44 24 08          	mov    %eax,0x8(%esp)
80102424:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010242b:	00 
8010242c:	8b 45 08             	mov    0x8(%ebp),%eax
8010242f:	89 04 24             	mov    %eax,(%esp)
80102432:	e8 c9 fe ff ff       	call   80102300 <namex>
}
80102437:	c9                   	leave  
80102438:	c3                   	ret    

80102439 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102439:	55                   	push   %ebp
8010243a:	89 e5                	mov    %esp,%ebp
8010243c:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010243f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102442:	89 44 24 08          	mov    %eax,0x8(%esp)
80102446:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010244d:	00 
8010244e:	8b 45 08             	mov    0x8(%ebp),%eax
80102451:	89 04 24             	mov    %eax,(%esp)
80102454:	e8 a7 fe ff ff       	call   80102300 <namex>
}
80102459:	c9                   	leave  
8010245a:	c3                   	ret    
	...

8010245c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010245c:	55                   	push   %ebp
8010245d:	89 e5                	mov    %esp,%ebp
8010245f:	83 ec 14             	sub    $0x14,%esp
80102462:	8b 45 08             	mov    0x8(%ebp),%eax
80102465:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102469:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010246d:	89 c2                	mov    %eax,%edx
8010246f:	ec                   	in     (%dx),%al
80102470:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102473:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102477:	c9                   	leave  
80102478:	c3                   	ret    

80102479 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102479:	55                   	push   %ebp
8010247a:	89 e5                	mov    %esp,%ebp
8010247c:	57                   	push   %edi
8010247d:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010247e:	8b 55 08             	mov    0x8(%ebp),%edx
80102481:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102484:	8b 45 10             	mov    0x10(%ebp),%eax
80102487:	89 cb                	mov    %ecx,%ebx
80102489:	89 df                	mov    %ebx,%edi
8010248b:	89 c1                	mov    %eax,%ecx
8010248d:	fc                   	cld    
8010248e:	f3 6d                	rep insl (%dx),%es:(%edi)
80102490:	89 c8                	mov    %ecx,%eax
80102492:	89 fb                	mov    %edi,%ebx
80102494:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102497:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010249a:	5b                   	pop    %ebx
8010249b:	5f                   	pop    %edi
8010249c:	5d                   	pop    %ebp
8010249d:	c3                   	ret    

8010249e <outb>:

static inline void
outb(ushort port, uchar data)
{
8010249e:	55                   	push   %ebp
8010249f:	89 e5                	mov    %esp,%ebp
801024a1:	83 ec 08             	sub    $0x8,%esp
801024a4:	8b 55 08             	mov    0x8(%ebp),%edx
801024a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801024aa:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024ae:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024b1:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024b5:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024b9:	ee                   	out    %al,(%dx)
}
801024ba:	c9                   	leave  
801024bb:	c3                   	ret    

801024bc <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024bc:	55                   	push   %ebp
801024bd:	89 e5                	mov    %esp,%ebp
801024bf:	56                   	push   %esi
801024c0:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024c1:	8b 55 08             	mov    0x8(%ebp),%edx
801024c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024c7:	8b 45 10             	mov    0x10(%ebp),%eax
801024ca:	89 cb                	mov    %ecx,%ebx
801024cc:	89 de                	mov    %ebx,%esi
801024ce:	89 c1                	mov    %eax,%ecx
801024d0:	fc                   	cld    
801024d1:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024d3:	89 c8                	mov    %ecx,%eax
801024d5:	89 f3                	mov    %esi,%ebx
801024d7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024da:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024dd:	5b                   	pop    %ebx
801024de:	5e                   	pop    %esi
801024df:	5d                   	pop    %ebp
801024e0:	c3                   	ret    

801024e1 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024e1:	55                   	push   %ebp
801024e2:	89 e5                	mov    %esp,%ebp
801024e4:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024e7:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024ee:	e8 69 ff ff ff       	call   8010245c <inb>
801024f3:	0f b6 c0             	movzbl %al,%eax
801024f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024fc:	25 c0 00 00 00       	and    $0xc0,%eax
80102501:	83 f8 40             	cmp    $0x40,%eax
80102504:	75 e1                	jne    801024e7 <idewait+0x6>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102506:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010250a:	74 11                	je     8010251d <idewait+0x3c>
8010250c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010250f:	83 e0 21             	and    $0x21,%eax
80102512:	85 c0                	test   %eax,%eax
80102514:	74 07                	je     8010251d <idewait+0x3c>
    return -1;
80102516:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010251b:	eb 05                	jmp    80102522 <idewait+0x41>
  return 0;
8010251d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102522:	c9                   	leave  
80102523:	c3                   	ret    

80102524 <ideinit>:

void
ideinit(void)
{
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010252a:	c7 44 24 04 4c 83 10 	movl   $0x8010834c,0x4(%esp)
80102531:	80 
80102532:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102539:	e8 fc 26 00 00       	call   80104c3a <initlock>
  picenable(IRQ_IDE);
8010253e:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102545:	e8 3b 15 00 00       	call   80103a85 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010254a:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010254f:	83 e8 01             	sub    $0x1,%eax
80102552:	89 44 24 04          	mov    %eax,0x4(%esp)
80102556:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010255d:	e8 10 04 00 00       	call   80102972 <ioapicenable>
  idewait(0);
80102562:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102569:	e8 73 ff ff ff       	call   801024e1 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010256e:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102575:	00 
80102576:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010257d:	e8 1c ff ff ff       	call   8010249e <outb>
  for(i=0; i<1000; i++){
80102582:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102589:	eb 20                	jmp    801025ab <ideinit+0x87>
    if(inb(0x1f7) != 0){
8010258b:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102592:	e8 c5 fe ff ff       	call   8010245c <inb>
80102597:	84 c0                	test   %al,%al
80102599:	74 0c                	je     801025a7 <ideinit+0x83>
      havedisk1 = 1;
8010259b:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
801025a2:	00 00 00 
      break;
801025a5:	eb 0d                	jmp    801025b4 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025ab:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025b2:	7e d7                	jle    8010258b <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025b4:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025bb:	00 
801025bc:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025c3:	e8 d6 fe ff ff       	call   8010249e <outb>
}
801025c8:	c9                   	leave  
801025c9:	c3                   	ret    

801025ca <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025ca:	55                   	push   %ebp
801025cb:	89 e5                	mov    %esp,%ebp
801025cd:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025d4:	75 0c                	jne    801025e2 <idestart+0x18>
    panic("idestart");
801025d6:	c7 04 24 50 83 10 80 	movl   $0x80108350,(%esp)
801025dd:	e8 58 df ff ff       	call   8010053a <panic>

  idewait(0);
801025e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025e9:	e8 f3 fe ff ff       	call   801024e1 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025f5:	00 
801025f6:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025fd:	e8 9c fe ff ff       	call   8010249e <outb>
  outb(0x1f2, 1);  // number of sectors
80102602:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102609:	00 
8010260a:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102611:	e8 88 fe ff ff       	call   8010249e <outb>
  outb(0x1f3, b->sector & 0xff);
80102616:	8b 45 08             	mov    0x8(%ebp),%eax
80102619:	8b 40 08             	mov    0x8(%eax),%eax
8010261c:	0f b6 c0             	movzbl %al,%eax
8010261f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102623:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010262a:	e8 6f fe ff ff       	call   8010249e <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
8010262f:	8b 45 08             	mov    0x8(%ebp),%eax
80102632:	8b 40 08             	mov    0x8(%eax),%eax
80102635:	c1 e8 08             	shr    $0x8,%eax
80102638:	0f b6 c0             	movzbl %al,%eax
8010263b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010263f:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102646:	e8 53 fe ff ff       	call   8010249e <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010264b:	8b 45 08             	mov    0x8(%ebp),%eax
8010264e:	8b 40 08             	mov    0x8(%eax),%eax
80102651:	c1 e8 10             	shr    $0x10,%eax
80102654:	0f b6 c0             	movzbl %al,%eax
80102657:	89 44 24 04          	mov    %eax,0x4(%esp)
8010265b:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102662:	e8 37 fe ff ff       	call   8010249e <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102667:	8b 45 08             	mov    0x8(%ebp),%eax
8010266a:	8b 40 04             	mov    0x4(%eax),%eax
8010266d:	83 e0 01             	and    $0x1,%eax
80102670:	89 c2                	mov    %eax,%edx
80102672:	c1 e2 04             	shl    $0x4,%edx
80102675:	8b 45 08             	mov    0x8(%ebp),%eax
80102678:	8b 40 08             	mov    0x8(%eax),%eax
8010267b:	c1 e8 18             	shr    $0x18,%eax
8010267e:	83 e0 0f             	and    $0xf,%eax
80102681:	09 d0                	or     %edx,%eax
80102683:	83 c8 e0             	or     $0xffffffe0,%eax
80102686:	0f b6 c0             	movzbl %al,%eax
80102689:	89 44 24 04          	mov    %eax,0x4(%esp)
8010268d:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102694:	e8 05 fe ff ff       	call   8010249e <outb>
  if(b->flags & B_DIRTY){
80102699:	8b 45 08             	mov    0x8(%ebp),%eax
8010269c:	8b 00                	mov    (%eax),%eax
8010269e:	83 e0 04             	and    $0x4,%eax
801026a1:	85 c0                	test   %eax,%eax
801026a3:	74 34                	je     801026d9 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026a5:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026ac:	00 
801026ad:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026b4:	e8 e5 fd ff ff       	call   8010249e <outb>
    outsl(0x1f0, b->data, 512/4);
801026b9:	8b 45 08             	mov    0x8(%ebp),%eax
801026bc:	83 c0 18             	add    $0x18,%eax
801026bf:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026c6:	00 
801026c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801026cb:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026d2:	e8 e5 fd ff ff       	call   801024bc <outsl>
801026d7:	eb 14                	jmp    801026ed <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026d9:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026e0:	00 
801026e1:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026e8:	e8 b1 fd ff ff       	call   8010249e <outb>
  }
}
801026ed:	c9                   	leave  
801026ee:	c3                   	ret    

801026ef <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026ef:	55                   	push   %ebp
801026f0:	89 e5                	mov    %esp,%ebp
801026f2:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026f5:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801026fc:	e8 5a 25 00 00       	call   80104c5b <acquire>
  if((b = idequeue) == 0){
80102701:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102706:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102709:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010270d:	75 11                	jne    80102720 <ideintr+0x31>
    release(&idelock);
8010270f:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102716:	e8 a1 25 00 00       	call   80104cbc <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010271b:	e9 90 00 00 00       	jmp    801027b0 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102723:	8b 40 14             	mov    0x14(%eax),%eax
80102726:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010272e:	8b 00                	mov    (%eax),%eax
80102730:	83 e0 04             	and    $0x4,%eax
80102733:	85 c0                	test   %eax,%eax
80102735:	75 2e                	jne    80102765 <ideintr+0x76>
80102737:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010273e:	e8 9e fd ff ff       	call   801024e1 <idewait>
80102743:	85 c0                	test   %eax,%eax
80102745:	78 1e                	js     80102765 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274a:	83 c0 18             	add    $0x18,%eax
8010274d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102754:	00 
80102755:	89 44 24 04          	mov    %eax,0x4(%esp)
80102759:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102760:	e8 14 fd ff ff       	call   80102479 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102765:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102768:	8b 00                	mov    (%eax),%eax
8010276a:	89 c2                	mov    %eax,%edx
8010276c:	83 ca 02             	or     $0x2,%edx
8010276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102772:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102774:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102777:	8b 00                	mov    (%eax),%eax
80102779:	89 c2                	mov    %eax,%edx
8010277b:	83 e2 fb             	and    $0xfffffffb,%edx
8010277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102781:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102786:	89 04 24             	mov    %eax,(%esp)
80102789:	e8 c6 22 00 00       	call   80104a54 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010278e:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102793:	85 c0                	test   %eax,%eax
80102795:	74 0d                	je     801027a4 <ideintr+0xb5>
    idestart(idequeue);
80102797:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010279c:	89 04 24             	mov    %eax,(%esp)
8010279f:	e8 26 fe ff ff       	call   801025ca <idestart>

  release(&idelock);
801027a4:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027ab:	e8 0c 25 00 00       	call   80104cbc <release>
}
801027b0:	c9                   	leave  
801027b1:	c3                   	ret    

801027b2 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027b2:	55                   	push   %ebp
801027b3:	89 e5                	mov    %esp,%ebp
801027b5:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027b8:	8b 45 08             	mov    0x8(%ebp),%eax
801027bb:	8b 00                	mov    (%eax),%eax
801027bd:	83 e0 01             	and    $0x1,%eax
801027c0:	85 c0                	test   %eax,%eax
801027c2:	75 0c                	jne    801027d0 <iderw+0x1e>
    panic("iderw: buf not busy");
801027c4:	c7 04 24 59 83 10 80 	movl   $0x80108359,(%esp)
801027cb:	e8 6a dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027d0:	8b 45 08             	mov    0x8(%ebp),%eax
801027d3:	8b 00                	mov    (%eax),%eax
801027d5:	83 e0 06             	and    $0x6,%eax
801027d8:	83 f8 02             	cmp    $0x2,%eax
801027db:	75 0c                	jne    801027e9 <iderw+0x37>
    panic("iderw: nothing to do");
801027dd:	c7 04 24 6d 83 10 80 	movl   $0x8010836d,(%esp)
801027e4:	e8 51 dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027e9:	8b 45 08             	mov    0x8(%ebp),%eax
801027ec:	8b 40 04             	mov    0x4(%eax),%eax
801027ef:	85 c0                	test   %eax,%eax
801027f1:	74 15                	je     80102808 <iderw+0x56>
801027f3:	a1 38 b6 10 80       	mov    0x8010b638,%eax
801027f8:	85 c0                	test   %eax,%eax
801027fa:	75 0c                	jne    80102808 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027fc:	c7 04 24 82 83 10 80 	movl   $0x80108382,(%esp)
80102803:	e8 32 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102808:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010280f:	e8 47 24 00 00       	call   80104c5b <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102814:	8b 45 08             	mov    0x8(%ebp),%eax
80102817:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010281e:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
80102825:	eb 0b                	jmp    80102832 <iderw+0x80>
80102827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282a:	8b 00                	mov    (%eax),%eax
8010282c:	83 c0 14             	add    $0x14,%eax
8010282f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102832:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102835:	8b 00                	mov    (%eax),%eax
80102837:	85 c0                	test   %eax,%eax
80102839:	75 ec                	jne    80102827 <iderw+0x75>
    ;
  *pp = b;
8010283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010283e:	8b 55 08             	mov    0x8(%ebp),%edx
80102841:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102843:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102848:	3b 45 08             	cmp    0x8(%ebp),%eax
8010284b:	75 22                	jne    8010286f <iderw+0xbd>
    idestart(b);
8010284d:	8b 45 08             	mov    0x8(%ebp),%eax
80102850:	89 04 24             	mov    %eax,(%esp)
80102853:	e8 72 fd ff ff       	call   801025ca <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102858:	eb 16                	jmp    80102870 <iderw+0xbe>
    sleep(b, &idelock);
8010285a:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
80102861:	80 
80102862:	8b 45 08             	mov    0x8(%ebp),%eax
80102865:	89 04 24             	mov    %eax,(%esp)
80102868:	e8 ff 20 00 00       	call   8010496c <sleep>
8010286d:	eb 01                	jmp    80102870 <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010286f:	90                   	nop
80102870:	8b 45 08             	mov    0x8(%ebp),%eax
80102873:	8b 00                	mov    (%eax),%eax
80102875:	83 e0 06             	and    $0x6,%eax
80102878:	83 f8 02             	cmp    $0x2,%eax
8010287b:	75 dd                	jne    8010285a <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
8010287d:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102884:	e8 33 24 00 00       	call   80104cbc <release>
}
80102889:	c9                   	leave  
8010288a:	c3                   	ret    
	...

8010288c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010288c:	55                   	push   %ebp
8010288d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010288f:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102894:	8b 55 08             	mov    0x8(%ebp),%edx
80102897:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102899:	a1 34 f8 10 80       	mov    0x8010f834,%eax
8010289e:	8b 40 10             	mov    0x10(%eax),%eax
}
801028a1:	5d                   	pop    %ebp
801028a2:	c3                   	ret    

801028a3 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028a3:	55                   	push   %ebp
801028a4:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028a6:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028ab:	8b 55 08             	mov    0x8(%ebp),%edx
801028ae:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028b0:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028b5:	8b 55 0c             	mov    0xc(%ebp),%edx
801028b8:	89 50 10             	mov    %edx,0x10(%eax)
}
801028bb:	5d                   	pop    %ebp
801028bc:	c3                   	ret    

801028bd <ioapicinit>:

void
ioapicinit(void)
{
801028bd:	55                   	push   %ebp
801028be:	89 e5                	mov    %esp,%ebp
801028c0:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028c3:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801028c8:	85 c0                	test   %eax,%eax
801028ca:	0f 84 9f 00 00 00    	je     8010296f <ioapicinit+0xb2>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801028d0:	c7 05 34 f8 10 80 00 	movl   $0xfec00000,0x8010f834
801028d7:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028e1:	e8 a6 ff ff ff       	call   8010288c <ioapicread>
801028e6:	c1 e8 10             	shr    $0x10,%eax
801028e9:	25 ff 00 00 00       	and    $0xff,%eax
801028ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028f8:	e8 8f ff ff ff       	call   8010288c <ioapicread>
801028fd:	c1 e8 18             	shr    $0x18,%eax
80102900:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(id != ioapicid)
80102903:	0f b6 05 00 f9 10 80 	movzbl 0x8010f900,%eax
8010290a:	0f b6 c0             	movzbl %al,%eax
8010290d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102910:	74 0c                	je     8010291e <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102912:	c7 04 24 a0 83 10 80 	movl   $0x801083a0,(%esp)
80102919:	e8 7c da ff ff       	call   8010039a <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010291e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80102925:	eb 3e                	jmp    80102965 <ioapicinit+0xa8>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102927:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010292a:	83 c0 20             	add    $0x20,%eax
8010292d:	0d 00 00 01 00       	or     $0x10000,%eax
80102932:	8b 55 ec             	mov    -0x14(%ebp),%edx
80102935:	83 c2 08             	add    $0x8,%edx
80102938:	01 d2                	add    %edx,%edx
8010293a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010293e:	89 14 24             	mov    %edx,(%esp)
80102941:	e8 5d ff ff ff       	call   801028a3 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102946:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102949:	83 c0 08             	add    $0x8,%eax
8010294c:	01 c0                	add    %eax,%eax
8010294e:	83 c0 01             	add    $0x1,%eax
80102951:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102958:	00 
80102959:	89 04 24             	mov    %eax,(%esp)
8010295c:	e8 42 ff ff ff       	call   801028a3 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102961:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80102965:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102968:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010296b:	7e ba                	jle    80102927 <ioapicinit+0x6a>
8010296d:	eb 01                	jmp    80102970 <ioapicinit+0xb3>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
8010296f:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102970:	c9                   	leave  
80102971:	c3                   	ret    

80102972 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102972:	55                   	push   %ebp
80102973:	89 e5                	mov    %esp,%ebp
80102975:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102978:	a1 04 f9 10 80       	mov    0x8010f904,%eax
8010297d:	85 c0                	test   %eax,%eax
8010297f:	74 39                	je     801029ba <ioapicenable+0x48>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102981:	8b 45 08             	mov    0x8(%ebp),%eax
80102984:	83 c0 20             	add    $0x20,%eax
80102987:	8b 55 08             	mov    0x8(%ebp),%edx
8010298a:	83 c2 08             	add    $0x8,%edx
8010298d:	01 d2                	add    %edx,%edx
8010298f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102993:	89 14 24             	mov    %edx,(%esp)
80102996:	e8 08 ff ff ff       	call   801028a3 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010299b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010299e:	c1 e0 18             	shl    $0x18,%eax
801029a1:	8b 55 08             	mov    0x8(%ebp),%edx
801029a4:	83 c2 08             	add    $0x8,%edx
801029a7:	01 d2                	add    %edx,%edx
801029a9:	83 c2 01             	add    $0x1,%edx
801029ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b0:	89 14 24             	mov    %edx,(%esp)
801029b3:	e8 eb fe ff ff       	call   801028a3 <ioapicwrite>
801029b8:	eb 01                	jmp    801029bb <ioapicenable+0x49>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
801029ba:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801029bb:	c9                   	leave  
801029bc:	c3                   	ret    
801029bd:	00 00                	add    %al,(%eax)
	...

801029c0 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029c0:	55                   	push   %ebp
801029c1:	89 e5                	mov    %esp,%ebp
801029c3:	8b 45 08             	mov    0x8(%ebp),%eax
801029c6:	2d 00 00 00 80       	sub    $0x80000000,%eax
801029cb:	5d                   	pop    %ebp
801029cc:	c3                   	ret    

801029cd <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029cd:	55                   	push   %ebp
801029ce:	89 e5                	mov    %esp,%ebp
801029d0:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029d3:	c7 44 24 04 d2 83 10 	movl   $0x801083d2,0x4(%esp)
801029da:	80 
801029db:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
801029e2:	e8 53 22 00 00       	call   80104c3a <initlock>
  kmem.use_lock = 0;
801029e7:	c7 05 74 f8 10 80 00 	movl   $0x0,0x8010f874
801029ee:	00 00 00 
  freerange(vstart, vend);
801029f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801029f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f8:	8b 45 08             	mov    0x8(%ebp),%eax
801029fb:	89 04 24             	mov    %eax,(%esp)
801029fe:	e8 26 00 00 00       	call   80102a29 <freerange>
}
80102a03:	c9                   	leave  
80102a04:	c3                   	ret    

80102a05 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a05:	55                   	push   %ebp
80102a06:	89 e5                	mov    %esp,%ebp
80102a08:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a12:	8b 45 08             	mov    0x8(%ebp),%eax
80102a15:	89 04 24             	mov    %eax,(%esp)
80102a18:	e8 0c 00 00 00       	call   80102a29 <freerange>
  kmem.use_lock = 1;
80102a1d:	c7 05 74 f8 10 80 01 	movl   $0x1,0x8010f874
80102a24:	00 00 00 
}
80102a27:	c9                   	leave  
80102a28:	c3                   	ret    

80102a29 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a29:	55                   	push   %ebp
80102a2a:	89 e5                	mov    %esp,%ebp
80102a2c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a2f:	8b 45 08             	mov    0x8(%ebp),%eax
80102a32:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a3f:	eb 12                	jmp    80102a53 <freerange+0x2a>
    kfree(p);
80102a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a44:	89 04 24             	mov    %eax,(%esp)
80102a47:	e8 19 00 00 00       	call   80102a65 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a4c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a56:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
80102a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a5f:	39 c2                	cmp    %eax,%edx
80102a61:	76 de                	jbe    80102a41 <freerange+0x18>
    kfree(p);
}
80102a63:	c9                   	leave  
80102a64:	c3                   	ret    

80102a65 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a65:	55                   	push   %ebp
80102a66:	89 e5                	mov    %esp,%ebp
80102a68:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a6b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a6e:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a73:	85 c0                	test   %eax,%eax
80102a75:	75 1b                	jne    80102a92 <kfree+0x2d>
80102a77:	81 7d 08 bc 29 11 80 	cmpl   $0x801129bc,0x8(%ebp)
80102a7e:	72 12                	jb     80102a92 <kfree+0x2d>
80102a80:	8b 45 08             	mov    0x8(%ebp),%eax
80102a83:	89 04 24             	mov    %eax,(%esp)
80102a86:	e8 35 ff ff ff       	call   801029c0 <v2p>
80102a8b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a90:	76 0c                	jbe    80102a9e <kfree+0x39>
    panic("kfree");
80102a92:	c7 04 24 d7 83 10 80 	movl   $0x801083d7,(%esp)
80102a99:	e8 9c da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a9e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102aa5:	00 
80102aa6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102aad:	00 
80102aae:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab1:	89 04 24             	mov    %eax,(%esp)
80102ab4:	e8 f1 23 00 00       	call   80104eaa <memset>

  if(kmem.use_lock)
80102ab9:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102abe:	85 c0                	test   %eax,%eax
80102ac0:	74 0c                	je     80102ace <kfree+0x69>
    acquire(&kmem.lock);
80102ac2:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102ac9:	e8 8d 21 00 00       	call   80104c5b <acquire>
  r = (struct run*)v;
80102ace:	8b 45 08             	mov    0x8(%ebp),%eax
80102ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ad4:	8b 15 78 f8 10 80    	mov    0x8010f878,%edx
80102ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102add:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae2:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102ae7:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102aec:	85 c0                	test   %eax,%eax
80102aee:	74 0c                	je     80102afc <kfree+0x97>
    release(&kmem.lock);
80102af0:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102af7:	e8 c0 21 00 00       	call   80104cbc <release>
}
80102afc:	c9                   	leave  
80102afd:	c3                   	ret    

80102afe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102afe:	55                   	push   %ebp
80102aff:	89 e5                	mov    %esp,%ebp
80102b01:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b04:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b09:	85 c0                	test   %eax,%eax
80102b0b:	74 0c                	je     80102b19 <kalloc+0x1b>
    acquire(&kmem.lock);
80102b0d:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b14:	e8 42 21 00 00       	call   80104c5b <acquire>
  r = kmem.freelist;
80102b19:	a1 78 f8 10 80       	mov    0x8010f878,%eax
80102b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b25:	74 0a                	je     80102b31 <kalloc+0x33>
    kmem.freelist = r->next;
80102b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2a:	8b 00                	mov    (%eax),%eax
80102b2c:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102b31:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b36:	85 c0                	test   %eax,%eax
80102b38:	74 0c                	je     80102b46 <kalloc+0x48>
    release(&kmem.lock);
80102b3a:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b41:	e8 76 21 00 00       	call   80104cbc <release>
  return (char*)r;
80102b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b49:	c9                   	leave  
80102b4a:	c3                   	ret    
	...

80102b4c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b4c:	55                   	push   %ebp
80102b4d:	89 e5                	mov    %esp,%ebp
80102b4f:	83 ec 14             	sub    $0x14,%esp
80102b52:	8b 45 08             	mov    0x8(%ebp),%eax
80102b55:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b59:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b5d:	89 c2                	mov    %eax,%edx
80102b5f:	ec                   	in     (%dx),%al
80102b60:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b63:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b67:	c9                   	leave  
80102b68:	c3                   	ret    

80102b69 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b69:	55                   	push   %ebp
80102b6a:	89 e5                	mov    %esp,%ebp
80102b6c:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b6f:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b76:	e8 d1 ff ff ff       	call   80102b4c <inb>
80102b7b:	0f b6 c0             	movzbl %al,%eax
80102b7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b84:	83 e0 01             	and    $0x1,%eax
80102b87:	85 c0                	test   %eax,%eax
80102b89:	75 0a                	jne    80102b95 <kbdgetc+0x2c>
    return -1;
80102b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b90:	e9 20 01 00 00       	jmp    80102cb5 <kbdgetc+0x14c>
  data = inb(KBDATAP);
80102b95:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102b9c:	e8 ab ff ff ff       	call   80102b4c <inb>
80102ba1:	0f b6 c0             	movzbl %al,%eax
80102ba4:	89 45 f8             	mov    %eax,-0x8(%ebp)

  if(data == 0xE0){
80102ba7:	81 7d f8 e0 00 00 00 	cmpl   $0xe0,-0x8(%ebp)
80102bae:	75 17                	jne    80102bc7 <kbdgetc+0x5e>
    shift |= E0ESC;
80102bb0:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bb5:	83 c8 40             	or     $0x40,%eax
80102bb8:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102bbd:	b8 00 00 00 00       	mov    $0x0,%eax
80102bc2:	e9 ee 00 00 00       	jmp    80102cb5 <kbdgetc+0x14c>
  } else if(data & 0x80){
80102bc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102bca:	25 80 00 00 00       	and    $0x80,%eax
80102bcf:	85 c0                	test   %eax,%eax
80102bd1:	74 44                	je     80102c17 <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bd3:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bd8:	83 e0 40             	and    $0x40,%eax
80102bdb:	85 c0                	test   %eax,%eax
80102bdd:	75 08                	jne    80102be7 <kbdgetc+0x7e>
80102bdf:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102be2:	83 e0 7f             	and    $0x7f,%eax
80102be5:	eb 03                	jmp    80102bea <kbdgetc+0x81>
80102be7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102bea:	89 45 f8             	mov    %eax,-0x8(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102bed:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102bf0:	0f b6 80 20 90 10 80 	movzbl -0x7fef6fe0(%eax),%eax
80102bf7:	83 c8 40             	or     $0x40,%eax
80102bfa:	0f b6 c0             	movzbl %al,%eax
80102bfd:	f7 d0                	not    %eax
80102bff:	89 c2                	mov    %eax,%edx
80102c01:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c06:	21 d0                	and    %edx,%eax
80102c08:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c0d:	b8 00 00 00 00       	mov    $0x0,%eax
80102c12:	e9 9e 00 00 00       	jmp    80102cb5 <kbdgetc+0x14c>
  } else if(shift & E0ESC){
80102c17:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c1c:	83 e0 40             	and    $0x40,%eax
80102c1f:	85 c0                	test   %eax,%eax
80102c21:	74 14                	je     80102c37 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c23:	81 4d f8 80 00 00 00 	orl    $0x80,-0x8(%ebp)
    shift &= ~E0ESC;
80102c2a:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c2f:	83 e0 bf             	and    $0xffffffbf,%eax
80102c32:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102c37:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c3a:	0f b6 80 20 90 10 80 	movzbl -0x7fef6fe0(%eax),%eax
80102c41:	0f b6 d0             	movzbl %al,%edx
80102c44:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c49:	09 d0                	or     %edx,%eax
80102c4b:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102c50:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c53:	0f b6 80 20 91 10 80 	movzbl -0x7fef6ee0(%eax),%eax
80102c5a:	0f b6 d0             	movzbl %al,%edx
80102c5d:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c62:	31 d0                	xor    %edx,%eax
80102c64:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c69:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c6e:	83 e0 03             	and    $0x3,%eax
80102c71:	8b 04 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%eax
80102c78:	03 45 f8             	add    -0x8(%ebp),%eax
80102c7b:	0f b6 00             	movzbl (%eax),%eax
80102c7e:	0f b6 c0             	movzbl %al,%eax
80102c81:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(shift & CAPSLOCK){
80102c84:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c89:	83 e0 08             	and    $0x8,%eax
80102c8c:	85 c0                	test   %eax,%eax
80102c8e:	74 22                	je     80102cb2 <kbdgetc+0x149>
    if('a' <= c && c <= 'z')
80102c90:	83 7d fc 60          	cmpl   $0x60,-0x4(%ebp)
80102c94:	76 0c                	jbe    80102ca2 <kbdgetc+0x139>
80102c96:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%ebp)
80102c9a:	77 06                	ja     80102ca2 <kbdgetc+0x139>
      c += 'A' - 'a';
80102c9c:	83 6d fc 20          	subl   $0x20,-0x4(%ebp)

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
80102ca0:	eb 10                	jmp    80102cb2 <kbdgetc+0x149>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102ca2:	83 7d fc 40          	cmpl   $0x40,-0x4(%ebp)
80102ca6:	76 0a                	jbe    80102cb2 <kbdgetc+0x149>
80102ca8:	83 7d fc 5a          	cmpl   $0x5a,-0x4(%ebp)
80102cac:	77 04                	ja     80102cb2 <kbdgetc+0x149>
      c += 'a' - 'A';
80102cae:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
  }
  return c;
80102cb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102cb5:	c9                   	leave  
80102cb6:	c3                   	ret    

80102cb7 <kbdintr>:

void
kbdintr(void)
{
80102cb7:	55                   	push   %ebp
80102cb8:	89 e5                	mov    %esp,%ebp
80102cba:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102cbd:	c7 04 24 69 2b 10 80 	movl   $0x80102b69,(%esp)
80102cc4:	e8 e2 da ff ff       	call   801007ab <consoleintr>
}
80102cc9:	c9                   	leave  
80102cca:	c3                   	ret    
	...

80102ccc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102ccc:	55                   	push   %ebp
80102ccd:	89 e5                	mov    %esp,%ebp
80102ccf:	83 ec 08             	sub    $0x8,%esp
80102cd2:	8b 55 08             	mov    0x8(%ebp),%edx
80102cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cd8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102cdc:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cdf:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102ce3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102ce7:	ee                   	out    %al,(%dx)
}
80102ce8:	c9                   	leave  
80102ce9:	c3                   	ret    

80102cea <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102cea:	55                   	push   %ebp
80102ceb:	89 e5                	mov    %esp,%ebp
80102ced:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102cf0:	9c                   	pushf  
80102cf1:	58                   	pop    %eax
80102cf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102cf8:	c9                   	leave  
80102cf9:	c3                   	ret    

80102cfa <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102cfa:	55                   	push   %ebp
80102cfb:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102cfd:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d02:	8b 55 08             	mov    0x8(%ebp),%edx
80102d05:	c1 e2 02             	shl    $0x2,%edx
80102d08:	8d 14 10             	lea    (%eax,%edx,1),%edx
80102d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d0e:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d10:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d15:	83 c0 20             	add    $0x20,%eax
80102d18:	8b 00                	mov    (%eax),%eax
}
80102d1a:	5d                   	pop    %ebp
80102d1b:	c3                   	ret    

80102d1c <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d1c:	55                   	push   %ebp
80102d1d:	89 e5                	mov    %esp,%ebp
80102d1f:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d22:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d27:	85 c0                	test   %eax,%eax
80102d29:	0f 84 46 01 00 00    	je     80102e75 <lapicinit+0x159>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d2f:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d36:	00 
80102d37:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d3e:	e8 b7 ff ff ff       	call   80102cfa <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d43:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d4a:	00 
80102d4b:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d52:	e8 a3 ff ff ff       	call   80102cfa <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d57:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d5e:	00 
80102d5f:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d66:	e8 8f ff ff ff       	call   80102cfa <lapicw>
  lapicw(TICR, 10000000); 
80102d6b:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d72:	00 
80102d73:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d7a:	e8 7b ff ff ff       	call   80102cfa <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d7f:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d86:	00 
80102d87:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102d8e:	e8 67 ff ff ff       	call   80102cfa <lapicw>
  lapicw(LINT1, MASKED);
80102d93:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d9a:	00 
80102d9b:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102da2:	e8 53 ff ff ff       	call   80102cfa <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102da7:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102dac:	83 c0 30             	add    $0x30,%eax
80102daf:	8b 00                	mov    (%eax),%eax
80102db1:	c1 e8 10             	shr    $0x10,%eax
80102db4:	25 ff 00 00 00       	and    $0xff,%eax
80102db9:	83 f8 03             	cmp    $0x3,%eax
80102dbc:	76 14                	jbe    80102dd2 <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102dbe:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dc5:	00 
80102dc6:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102dcd:	e8 28 ff ff ff       	call   80102cfa <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102dd2:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102dd9:	00 
80102dda:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102de1:	e8 14 ff ff ff       	call   80102cfa <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102de6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ded:	00 
80102dee:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102df5:	e8 00 ff ff ff       	call   80102cfa <lapicw>
  lapicw(ESR, 0);
80102dfa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e01:	00 
80102e02:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e09:	e8 ec fe ff ff       	call   80102cfa <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e0e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e15:	00 
80102e16:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e1d:	e8 d8 fe ff ff       	call   80102cfa <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e29:	00 
80102e2a:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e31:	e8 c4 fe ff ff       	call   80102cfa <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e36:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e3d:	00 
80102e3e:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e45:	e8 b0 fe ff ff       	call   80102cfa <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e4a:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e4f:	05 00 03 00 00       	add    $0x300,%eax
80102e54:	8b 00                	mov    (%eax),%eax
80102e56:	25 00 10 00 00       	and    $0x1000,%eax
80102e5b:	85 c0                	test   %eax,%eax
80102e5d:	75 eb                	jne    80102e4a <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e66:	00 
80102e67:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e6e:	e8 87 fe ff ff       	call   80102cfa <lapicw>
80102e73:	eb 01                	jmp    80102e76 <lapicinit+0x15a>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102e75:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102e76:	c9                   	leave  
80102e77:	c3                   	ret    

80102e78 <cpunum>:

int
cpunum(void)
{
80102e78:	55                   	push   %ebp
80102e79:	89 e5                	mov    %esp,%ebp
80102e7b:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e7e:	e8 67 fe ff ff       	call   80102cea <readeflags>
80102e83:	25 00 02 00 00       	and    $0x200,%eax
80102e88:	85 c0                	test   %eax,%eax
80102e8a:	74 29                	je     80102eb5 <cpunum+0x3d>
    static int n;
    if(n++ == 0)
80102e8c:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102e91:	85 c0                	test   %eax,%eax
80102e93:	0f 94 c2             	sete   %dl
80102e96:	83 c0 01             	add    $0x1,%eax
80102e99:	a3 40 b6 10 80       	mov    %eax,0x8010b640
80102e9e:	84 d2                	test   %dl,%dl
80102ea0:	74 13                	je     80102eb5 <cpunum+0x3d>
      cprintf("cpu called from %x with interrupts enabled\n",
80102ea2:	8b 45 04             	mov    0x4(%ebp),%eax
80102ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ea9:	c7 04 24 e0 83 10 80 	movl   $0x801083e0,(%esp)
80102eb0:	e8 e5 d4 ff ff       	call   8010039a <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102eb5:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102eba:	85 c0                	test   %eax,%eax
80102ebc:	74 0f                	je     80102ecd <cpunum+0x55>
    return lapic[ID]>>24;
80102ebe:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ec3:	83 c0 20             	add    $0x20,%eax
80102ec6:	8b 00                	mov    (%eax),%eax
80102ec8:	c1 e8 18             	shr    $0x18,%eax
80102ecb:	eb 05                	jmp    80102ed2 <cpunum+0x5a>
  return 0;
80102ecd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ed2:	c9                   	leave  
80102ed3:	c3                   	ret    

80102ed4 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ed4:	55                   	push   %ebp
80102ed5:	89 e5                	mov    %esp,%ebp
80102ed7:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102eda:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102edf:	85 c0                	test   %eax,%eax
80102ee1:	74 14                	je     80102ef7 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102ee3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eea:	00 
80102eeb:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ef2:	e8 03 fe ff ff       	call   80102cfa <lapicw>
}
80102ef7:	c9                   	leave  
80102ef8:	c3                   	ret    

80102ef9 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ef9:	55                   	push   %ebp
80102efa:	89 e5                	mov    %esp,%ebp
}
80102efc:	5d                   	pop    %ebp
80102efd:	c3                   	ret    

80102efe <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102efe:	55                   	push   %ebp
80102eff:	89 e5                	mov    %esp,%ebp
80102f01:	83 ec 1c             	sub    $0x1c,%esp
80102f04:	8b 45 08             	mov    0x8(%ebp),%eax
80102f07:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102f0a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f11:	00 
80102f12:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f19:	e8 ae fd ff ff       	call   80102ccc <outb>
  outb(IO_RTC+1, 0x0A);
80102f1e:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f25:	00 
80102f26:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f2d:	e8 9a fd ff ff       	call   80102ccc <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f32:	c7 45 fc 67 04 00 80 	movl   $0x80000467,-0x4(%ebp)
  wrv[0] = 0;
80102f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f3c:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f41:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f44:	8d 50 02             	lea    0x2(%eax),%edx
80102f47:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f4a:	c1 e8 04             	shr    $0x4,%eax
80102f4d:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f50:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f54:	c1 e0 18             	shl    $0x18,%eax
80102f57:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f5b:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f62:	e8 93 fd ff ff       	call   80102cfa <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f67:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f6e:	00 
80102f6f:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f76:	e8 7f fd ff ff       	call   80102cfa <lapicw>
  microdelay(200);
80102f7b:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f82:	e8 72 ff ff ff       	call   80102ef9 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f87:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102f8e:	00 
80102f8f:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f96:	e8 5f fd ff ff       	call   80102cfa <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102f9b:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102fa2:	e8 52 ff ff ff       	call   80102ef9 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fa7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80102fae:	eb 40                	jmp    80102ff0 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102fb0:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fb4:	c1 e0 18             	shl    $0x18,%eax
80102fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fbb:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fc2:	e8 33 fd ff ff       	call   80102cfa <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fca:	c1 e8 0c             	shr    $0xc,%eax
80102fcd:	80 cc 06             	or     $0x6,%ah
80102fd0:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fd4:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fdb:	e8 1a fd ff ff       	call   80102cfa <lapicw>
    microdelay(200);
80102fe0:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fe7:	e8 0d ff ff ff       	call   80102ef9 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fec:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80102ff0:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
80102ff4:	7e ba                	jle    80102fb0 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102ff6:	c9                   	leave  
80102ff7:	c3                   	ret    

80102ff8 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80102ff8:	55                   	push   %ebp
80102ff9:	89 e5                	mov    %esp,%ebp
80102ffb:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
80102ffe:	90                   	nop
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102fff:	c7 44 24 04 0c 84 10 	movl   $0x8010840c,0x4(%esp)
80103006:	80 
80103007:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010300e:	e8 27 1c 00 00       	call   80104c3a <initlock>
  readsb(ROOTDEV, &sb);
80103013:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103016:	89 44 24 04          	mov    %eax,0x4(%esp)
8010301a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103021:	e8 c2 e2 ff ff       	call   801012e8 <readsb>
  log.start = sb.size - sb.nlog;
80103026:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103029:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010302c:	89 d1                	mov    %edx,%ecx
8010302e:	29 c1                	sub    %eax,%ecx
80103030:	89 c8                	mov    %ecx,%eax
80103032:	a3 b4 f8 10 80       	mov    %eax,0x8010f8b4
  log.size = sb.nlog;
80103037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010303a:	a3 b8 f8 10 80       	mov    %eax,0x8010f8b8
  log.dev = ROOTDEV;
8010303f:	c7 05 c0 f8 10 80 01 	movl   $0x1,0x8010f8c0
80103046:	00 00 00 
  recover_from_log();
80103049:	e8 97 01 00 00       	call   801031e5 <recover_from_log>
}
8010304e:	c9                   	leave  
8010304f:	c3                   	ret    

80103050 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103056:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010305d:	e9 89 00 00 00       	jmp    801030eb <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103062:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
80103067:	03 45 ec             	add    -0x14(%ebp),%eax
8010306a:	83 c0 01             	add    $0x1,%eax
8010306d:	89 c2                	mov    %eax,%edx
8010306f:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103074:	89 54 24 04          	mov    %edx,0x4(%esp)
80103078:	89 04 24             	mov    %eax,(%esp)
8010307b:	e8 27 d1 ff ff       	call   801001a7 <bread>
80103080:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103083:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103086:	83 c0 10             	add    $0x10,%eax
80103089:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
80103090:	89 c2                	mov    %eax,%edx
80103092:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103097:	89 54 24 04          	mov    %edx,0x4(%esp)
8010309b:	89 04 24             	mov    %eax,(%esp)
8010309e:	e8 04 d1 ff ff       	call   801001a7 <bread>
801030a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030a9:	8d 50 18             	lea    0x18(%eax),%edx
801030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030af:	83 c0 18             	add    $0x18,%eax
801030b2:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801030b9:	00 
801030ba:	89 54 24 04          	mov    %edx,0x4(%esp)
801030be:	89 04 24             	mov    %eax,(%esp)
801030c1:	e8 b7 1e 00 00       	call   80104f7d <memmove>
    bwrite(dbuf);  // write dst to disk
801030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030c9:	89 04 24             	mov    %eax,(%esp)
801030cc:	e8 0d d1 ff ff       	call   801001de <bwrite>
    brelse(lbuf); 
801030d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030d4:	89 04 24             	mov    %eax,(%esp)
801030d7:	e8 3c d1 ff ff       	call   80100218 <brelse>
    brelse(dbuf);
801030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030df:	89 04 24             	mov    %eax,(%esp)
801030e2:	e8 31 d1 ff ff       	call   80100218 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030e7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801030eb:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801030f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801030f3:	0f 8f 69 ff ff ff    	jg     80103062 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801030f9:	c9                   	leave  
801030fa:	c3                   	ret    

801030fb <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801030fb:	55                   	push   %ebp
801030fc:	89 e5                	mov    %esp,%ebp
801030fe:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103101:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
80103106:	89 c2                	mov    %eax,%edx
80103108:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
8010310d:	89 54 24 04          	mov    %edx,0x4(%esp)
80103111:	89 04 24             	mov    %eax,(%esp)
80103114:	e8 8e d0 ff ff       	call   801001a7 <bread>
80103119:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010311c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010311f:	83 c0 18             	add    $0x18,%eax
80103122:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  log.lh.n = lh->n;
80103125:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103128:	8b 00                	mov    (%eax),%eax
8010312a:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  for (i = 0; i < log.lh.n; i++) {
8010312f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103136:	eb 1b                	jmp    80103153 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
80103138:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010313b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010313e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103141:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103145:	8d 51 10             	lea    0x10(%ecx),%edx
80103148:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010314f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103153:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103158:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010315b:	7f db                	jg     80103138 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
8010315d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103160:	89 04 24             	mov    %eax,(%esp)
80103163:	e8 b0 d0 ff ff       	call   80100218 <brelse>
}
80103168:	c9                   	leave  
80103169:	c3                   	ret    

8010316a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010316a:	55                   	push   %ebp
8010316b:	89 e5                	mov    %esp,%ebp
8010316d:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103170:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
80103175:	89 c2                	mov    %eax,%edx
80103177:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
8010317c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103180:	89 04 24             	mov    %eax,(%esp)
80103183:	e8 1f d0 ff ff       	call   801001a7 <bread>
80103188:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010318b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010318e:	83 c0 18             	add    $0x18,%eax
80103191:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  hb->n = log.lh.n;
80103194:	8b 15 c4 f8 10 80    	mov    0x8010f8c4,%edx
8010319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010319d:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010319f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031a6:	eb 1b                	jmp    801031c3 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801031a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031ae:	83 c0 10             	add    $0x10,%eax
801031b1:	8b 0c 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%ecx
801031b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031bb:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801031bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031c3:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801031c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031cb:	7f db                	jg     801031a8 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801031cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031d0:	89 04 24             	mov    %eax,(%esp)
801031d3:	e8 06 d0 ff ff       	call   801001de <bwrite>
  brelse(buf);
801031d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031db:	89 04 24             	mov    %eax,(%esp)
801031de:	e8 35 d0 ff ff       	call   80100218 <brelse>
}
801031e3:	c9                   	leave  
801031e4:	c3                   	ret    

801031e5 <recover_from_log>:

static void
recover_from_log(void)
{
801031e5:	55                   	push   %ebp
801031e6:	89 e5                	mov    %esp,%ebp
801031e8:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801031eb:	e8 0b ff ff ff       	call   801030fb <read_head>
  install_trans(); // if committed, copy from log to disk
801031f0:	e8 5b fe ff ff       	call   80103050 <install_trans>
  log.lh.n = 0;
801031f5:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
801031fc:	00 00 00 
  write_head(); // clear the log
801031ff:	e8 66 ff ff ff       	call   8010316a <write_head>
}
80103204:	c9                   	leave  
80103205:	c3                   	ret    

80103206 <begin_trans>:

void
begin_trans(void)
{
80103206:	55                   	push   %ebp
80103207:	89 e5                	mov    %esp,%ebp
80103209:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
8010320c:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103213:	e8 43 1a 00 00       	call   80104c5b <acquire>
  while (log.busy) {
80103218:	eb 14                	jmp    8010322e <begin_trans+0x28>
    sleep(&log, &log.lock);
8010321a:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
80103221:	80 
80103222:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103229:	e8 3e 17 00 00       	call   8010496c <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
8010322e:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
80103233:	85 c0                	test   %eax,%eax
80103235:	75 e3                	jne    8010321a <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
80103237:	c7 05 bc f8 10 80 01 	movl   $0x1,0x8010f8bc
8010323e:	00 00 00 
  release(&log.lock);
80103241:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103248:	e8 6f 1a 00 00       	call   80104cbc <release>
}
8010324d:	c9                   	leave  
8010324e:	c3                   	ret    

8010324f <commit_trans>:

void
commit_trans(void)
{
8010324f:	55                   	push   %ebp
80103250:	89 e5                	mov    %esp,%ebp
80103252:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
80103255:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010325a:	85 c0                	test   %eax,%eax
8010325c:	7e 19                	jle    80103277 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
8010325e:	e8 07 ff ff ff       	call   8010316a <write_head>
    install_trans(); // Now install writes to home locations
80103263:	e8 e8 fd ff ff       	call   80103050 <install_trans>
    log.lh.n = 0; 
80103268:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
8010326f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103272:	e8 f3 fe ff ff       	call   8010316a <write_head>
  }
  
  acquire(&log.lock);
80103277:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010327e:	e8 d8 19 00 00       	call   80104c5b <acquire>
  log.busy = 0;
80103283:	c7 05 bc f8 10 80 00 	movl   $0x0,0x8010f8bc
8010328a:	00 00 00 
  wakeup(&log);
8010328d:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103294:	e8 bb 17 00 00       	call   80104a54 <wakeup>
  release(&log.lock);
80103299:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801032a0:	e8 17 1a 00 00       	call   80104cbc <release>
}
801032a5:	c9                   	leave  
801032a6:	c3                   	ret    

801032a7 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032a7:	55                   	push   %ebp
801032a8:	89 e5                	mov    %esp,%ebp
801032aa:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032ad:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032b2:	83 f8 09             	cmp    $0x9,%eax
801032b5:	7f 12                	jg     801032c9 <log_write+0x22>
801032b7:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032bc:	8b 15 b8 f8 10 80    	mov    0x8010f8b8,%edx
801032c2:	83 ea 01             	sub    $0x1,%edx
801032c5:	39 d0                	cmp    %edx,%eax
801032c7:	7c 0c                	jl     801032d5 <log_write+0x2e>
    panic("too big a transaction");
801032c9:	c7 04 24 10 84 10 80 	movl   $0x80108410,(%esp)
801032d0:	e8 65 d2 ff ff       	call   8010053a <panic>
  if (!log.busy)
801032d5:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
801032da:	85 c0                	test   %eax,%eax
801032dc:	75 0c                	jne    801032ea <log_write+0x43>
    panic("write outside of trans");
801032de:	c7 04 24 26 84 10 80 	movl   $0x80108426,(%esp)
801032e5:	e8 50 d2 ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
801032ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801032f1:	eb 1d                	jmp    80103310 <log_write+0x69>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801032f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032f6:	83 c0 10             	add    $0x10,%eax
801032f9:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
80103300:	89 c2                	mov    %eax,%edx
80103302:	8b 45 08             	mov    0x8(%ebp),%eax
80103305:	8b 40 08             	mov    0x8(%eax),%eax
80103308:	39 c2                	cmp    %eax,%edx
8010330a:	74 10                	je     8010331c <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
8010330c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80103310:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103315:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103318:	7f d9                	jg     801032f3 <log_write+0x4c>
8010331a:	eb 01                	jmp    8010331d <log_write+0x76>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
8010331c:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
8010331d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103320:	8b 45 08             	mov    0x8(%ebp),%eax
80103323:	8b 40 08             	mov    0x8(%eax),%eax
80103326:	83 c2 10             	add    $0x10,%edx
80103329:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103330:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
80103335:	03 45 f0             	add    -0x10(%ebp),%eax
80103338:	83 c0 01             	add    $0x1,%eax
8010333b:	89 c2                	mov    %eax,%edx
8010333d:	8b 45 08             	mov    0x8(%ebp),%eax
80103340:	8b 40 04             	mov    0x4(%eax),%eax
80103343:	89 54 24 04          	mov    %edx,0x4(%esp)
80103347:	89 04 24             	mov    %eax,(%esp)
8010334a:	e8 58 ce ff ff       	call   801001a7 <bread>
8010334f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103352:	8b 45 08             	mov    0x8(%ebp),%eax
80103355:	8d 50 18             	lea    0x18(%eax),%edx
80103358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010335b:	83 c0 18             	add    $0x18,%eax
8010335e:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103365:	00 
80103366:	89 54 24 04          	mov    %edx,0x4(%esp)
8010336a:	89 04 24             	mov    %eax,(%esp)
8010336d:	e8 0b 1c 00 00       	call   80104f7d <memmove>
  bwrite(lbuf);
80103372:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103375:	89 04 24             	mov    %eax,(%esp)
80103378:	e8 61 ce ff ff       	call   801001de <bwrite>
  brelse(lbuf);
8010337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103380:	89 04 24             	mov    %eax,(%esp)
80103383:	e8 90 ce ff ff       	call   80100218 <brelse>
  if (i == log.lh.n)
80103388:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010338d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103390:	75 0d                	jne    8010339f <log_write+0xf8>
    log.lh.n++;
80103392:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103397:	83 c0 01             	add    $0x1,%eax
8010339a:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  b->flags |= B_DIRTY; // XXX prevent eviction
8010339f:	8b 45 08             	mov    0x8(%ebp),%eax
801033a2:	8b 00                	mov    (%eax),%eax
801033a4:	89 c2                	mov    %eax,%edx
801033a6:	83 ca 04             	or     $0x4,%edx
801033a9:	8b 45 08             	mov    0x8(%ebp),%eax
801033ac:	89 10                	mov    %edx,(%eax)
}
801033ae:	c9                   	leave  
801033af:	c3                   	ret    

801033b0 <v2p>:
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	8b 45 08             	mov    0x8(%ebp),%eax
801033b6:	2d 00 00 00 80       	sub    $0x80000000,%eax
801033bb:	5d                   	pop    %ebp
801033bc:	c3                   	ret    

801033bd <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801033bd:	55                   	push   %ebp
801033be:	89 e5                	mov    %esp,%ebp
801033c0:	8b 45 08             	mov    0x8(%ebp),%eax
801033c3:	2d 00 00 00 80       	sub    $0x80000000,%eax
801033c8:	5d                   	pop    %ebp
801033c9:	c3                   	ret    

801033ca <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801033ca:	55                   	push   %ebp
801033cb:	89 e5                	mov    %esp,%ebp
801033cd:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033d0:	8b 55 08             	mov    0x8(%ebp),%edx
801033d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801033d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801033d9:	f0 87 02             	lock xchg %eax,(%edx)
801033dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801033df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801033e2:	c9                   	leave  
801033e3:	c3                   	ret    

801033e4 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801033e4:	55                   	push   %ebp
801033e5:	89 e5                	mov    %esp,%ebp
801033e7:	83 e4 f0             	and    $0xfffffff0,%esp
801033ea:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033ed:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801033f4:	80 
801033f5:	c7 04 24 bc 29 11 80 	movl   $0x801129bc,(%esp)
801033fc:	e8 cc f5 ff ff       	call   801029cd <kinit1>
  kvmalloc();      // kernel page table
80103401:	e8 51 46 00 00       	call   80107a57 <kvmalloc>
  mpinit();        // collect info about this machine
80103406:	e8 49 04 00 00       	call   80103854 <mpinit>
  lapicinit();
8010340b:	e8 0c f9 ff ff       	call   80102d1c <lapicinit>
  seginit();       // set up segments
80103410:	e8 e4 3f 00 00       	call   801073f9 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103415:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010341b:	0f b6 00             	movzbl (%eax),%eax
8010341e:	0f b6 c0             	movzbl %al,%eax
80103421:	89 44 24 04          	mov    %eax,0x4(%esp)
80103425:	c7 04 24 3d 84 10 80 	movl   $0x8010843d,(%esp)
8010342c:	e8 69 cf ff ff       	call   8010039a <cprintf>
  picinit();       // interrupt controller
80103431:	e8 84 06 00 00       	call   80103aba <picinit>
  ioapicinit();    // another interrupt controller
80103436:	e8 82 f4 ff ff       	call   801028bd <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010343b:	e8 48 d6 ff ff       	call   80100a88 <consoleinit>
  uartinit();      // serial port
80103440:	e8 fe 32 00 00       	call   80106743 <uartinit>
  pinit();         // process table
80103445:	e8 80 0b 00 00       	call   80103fca <pinit>
  rqinit();
8010344a:	e8 97 0b 00 00       	call   80103fe6 <rqinit>
  tvinit();        // trap vectors
8010344f:	e8 a2 2e 00 00       	call   801062f6 <tvinit>
  binit();         // buffer cache
80103454:	e8 db cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103459:	e8 9e da ff ff       	call   80100efc <fileinit>
  iinit();         // inode cache
8010345e:	e8 53 e1 ff ff       	call   801015b6 <iinit>
  ideinit();       // disk
80103463:	e8 bc f0 ff ff       	call   80102524 <ideinit>
  if(!ismp)
80103468:	a1 04 f9 10 80       	mov    0x8010f904,%eax
8010346d:	85 c0                	test   %eax,%eax
8010346f:	75 05                	jne    80103476 <main+0x92>
    timerinit();   // uniprocessor timer
80103471:	e8 c8 2d 00 00       	call   8010623e <timerinit>
  startothers();   // start other processors
80103476:	e8 7f 00 00 00       	call   801034fa <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010347b:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103482:	8e 
80103483:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
8010348a:	e8 76 f5 ff ff       	call   80102a05 <kinit2>
  userinit();      // first user process
8010348f:	e8 6b 0d 00 00       	call   801041ff <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103494:	e8 1a 00 00 00       	call   801034b3 <mpmain>

80103499 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103499:	55                   	push   %ebp
8010349a:	89 e5                	mov    %esp,%ebp
8010349c:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
8010349f:	e8 ca 45 00 00       	call   80107a6e <switchkvm>
  seginit();
801034a4:	e8 50 3f 00 00       	call   801073f9 <seginit>
  lapicinit();
801034a9:	e8 6e f8 ff ff       	call   80102d1c <lapicinit>
  mpmain();
801034ae:	e8 00 00 00 00       	call   801034b3 <mpmain>

801034b3 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034b3:	55                   	push   %ebp
801034b4:	89 e5                	mov    %esp,%ebp
801034b6:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801034b9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034bf:	0f b6 00             	movzbl (%eax),%eax
801034c2:	0f b6 c0             	movzbl %al,%eax
801034c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801034c9:	c7 04 24 54 84 10 80 	movl   $0x80108454,(%esp)
801034d0:	e8 c5 ce ff ff       	call   8010039a <cprintf>
  idtinit();       // load idt register
801034d5:	e8 8c 2f 00 00       	call   80106466 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034da:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034e0:	05 a8 00 00 00       	add    $0xa8,%eax
801034e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034ec:	00 
801034ed:	89 04 24             	mov    %eax,(%esp)
801034f0:	e8 d5 fe ff ff       	call   801033ca <xchg>
  scheduler();     // start running processes
801034f5:	e8 8a 12 00 00       	call   80104784 <scheduler>

801034fa <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801034fa:	55                   	push   %ebp
801034fb:	89 e5                	mov    %esp,%ebp
801034fd:	53                   	push   %ebx
801034fe:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103501:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103508:	e8 b0 fe ff ff       	call   801033bd <p2v>
8010350d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103510:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103515:	89 44 24 08          	mov    %eax,0x8(%esp)
80103519:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
80103520:	80 
80103521:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103524:	89 04 24             	mov    %eax,(%esp)
80103527:	e8 51 1a 00 00       	call   80104f7d <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010352c:	c7 45 f0 20 f9 10 80 	movl   $0x8010f920,-0x10(%ebp)
80103533:	e9 85 00 00 00       	jmp    801035bd <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
80103538:	e8 3b f9 ff ff       	call   80102e78 <cpunum>
8010353d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103543:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103548:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010354b:	74 68                	je     801035b5 <startothers+0xbb>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010354d:	e8 ac f5 ff ff       	call   80102afe <kalloc>
80103552:	89 45 f4             	mov    %eax,-0xc(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103555:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103558:	83 e8 04             	sub    $0x4,%eax
8010355b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010355e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103564:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103566:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103569:	83 e8 08             	sub    $0x8,%eax
8010356c:	c7 00 99 34 10 80    	movl   $0x80103499,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103572:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103575:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103578:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
8010357f:	e8 2c fe ff ff       	call   801033b0 <v2p>
80103584:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103586:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103589:	89 04 24             	mov    %eax,(%esp)
8010358c:	e8 1f fe ff ff       	call   801033b0 <v2p>
80103591:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103594:	0f b6 12             	movzbl (%edx),%edx
80103597:	0f b6 d2             	movzbl %dl,%edx
8010359a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010359e:	89 14 24             	mov    %edx,(%esp)
801035a1:	e8 58 f9 ff ff       	call   80102efe <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035a9:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801035af:	85 c0                	test   %eax,%eax
801035b1:	74 f3                	je     801035a6 <startothers+0xac>
801035b3:	eb 01                	jmp    801035b6 <startothers+0xbc>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801035b5:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801035b6:	81 45 f0 bc 00 00 00 	addl   $0xbc,-0x10(%ebp)
801035bd:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801035c2:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801035c8:	05 20 f9 10 80       	add    $0x8010f920,%eax
801035cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801035d0:	0f 87 62 ff ff ff    	ja     80103538 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801035d6:	83 c4 24             	add    $0x24,%esp
801035d9:	5b                   	pop    %ebx
801035da:	5d                   	pop    %ebp
801035db:	c3                   	ret    

801035dc <p2v>:
801035dc:	55                   	push   %ebp
801035dd:	89 e5                	mov    %esp,%ebp
801035df:	8b 45 08             	mov    0x8(%ebp),%eax
801035e2:	2d 00 00 00 80       	sub    $0x80000000,%eax
801035e7:	5d                   	pop    %ebp
801035e8:	c3                   	ret    

801035e9 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801035e9:	55                   	push   %ebp
801035ea:	89 e5                	mov    %esp,%ebp
801035ec:	83 ec 14             	sub    $0x14,%esp
801035ef:	8b 45 08             	mov    0x8(%ebp),%eax
801035f2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035f6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801035fa:	89 c2                	mov    %eax,%edx
801035fc:	ec                   	in     (%dx),%al
801035fd:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103600:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103604:	c9                   	leave  
80103605:	c3                   	ret    

80103606 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103606:	55                   	push   %ebp
80103607:	89 e5                	mov    %esp,%ebp
80103609:	83 ec 08             	sub    $0x8,%esp
8010360c:	8b 55 08             	mov    0x8(%ebp),%edx
8010360f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103612:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103616:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103619:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010361d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103621:	ee                   	out    %al,(%dx)
}
80103622:	c9                   	leave  
80103623:	c3                   	ret    

80103624 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103624:	55                   	push   %ebp
80103625:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103627:	a1 44 b6 10 80       	mov    0x8010b644,%eax
8010362c:	89 c2                	mov    %eax,%edx
8010362e:	b8 20 f9 10 80       	mov    $0x8010f920,%eax
80103633:	89 d1                	mov    %edx,%ecx
80103635:	29 c1                	sub    %eax,%ecx
80103637:	89 c8                	mov    %ecx,%eax
80103639:	c1 f8 02             	sar    $0x2,%eax
8010363c:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103642:	5d                   	pop    %ebp
80103643:	c3                   	ret    

80103644 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103644:	55                   	push   %ebp
80103645:	89 e5                	mov    %esp,%ebp
80103647:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
8010364a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(i=0; i<len; i++)
80103651:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80103658:	eb 13                	jmp    8010366d <sum+0x29>
    sum += addr[i];
8010365a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010365d:	03 45 08             	add    0x8(%ebp),%eax
80103660:	0f b6 00             	movzbl (%eax),%eax
80103663:	0f b6 c0             	movzbl %al,%eax
80103666:	01 45 fc             	add    %eax,-0x4(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103669:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010366d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103670:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103673:	7c e5                	jl     8010365a <sum+0x16>
    sum += addr[i];
  return sum;
80103675:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103678:	c9                   	leave  
80103679:	c3                   	ret    

8010367a <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010367a:	55                   	push   %ebp
8010367b:	89 e5                	mov    %esp,%ebp
8010367d:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103680:	8b 45 08             	mov    0x8(%ebp),%eax
80103683:	89 04 24             	mov    %eax,(%esp)
80103686:	e8 51 ff ff ff       	call   801035dc <p2v>
8010368b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  e = addr+len;
8010368e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103691:	03 45 f4             	add    -0xc(%ebp),%eax
80103694:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010369a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010369d:	eb 3f                	jmp    801036de <mpsearch1+0x64>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010369f:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801036a6:	00 
801036a7:	c7 44 24 04 68 84 10 	movl   $0x80108468,0x4(%esp)
801036ae:	80 
801036af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036b2:	89 04 24             	mov    %eax,(%esp)
801036b5:	e8 67 18 00 00       	call   80104f21 <memcmp>
801036ba:	85 c0                	test   %eax,%eax
801036bc:	75 1c                	jne    801036da <mpsearch1+0x60>
801036be:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801036c5:	00 
801036c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036c9:	89 04 24             	mov    %eax,(%esp)
801036cc:	e8 73 ff ff ff       	call   80103644 <sum>
801036d1:	84 c0                	test   %al,%al
801036d3:	75 05                	jne    801036da <mpsearch1+0x60>
      return (struct mp*)p;
801036d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036d8:	eb 11                	jmp    801036eb <mpsearch1+0x71>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801036da:	83 45 f0 10          	addl   $0x10,-0x10(%ebp)
801036de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036e1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801036e4:	72 b9                	jb     8010369f <mpsearch1+0x25>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801036e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801036eb:	c9                   	leave  
801036ec:	c3                   	ret    

801036ed <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801036ed:	55                   	push   %ebp
801036ee:	89 e5                	mov    %esp,%ebp
801036f0:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801036f3:	c7 45 ec 00 04 00 80 	movl   $0x80000400,-0x14(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036fd:	83 c0 0f             	add    $0xf,%eax
80103700:	0f b6 00             	movzbl (%eax),%eax
80103703:	0f b6 c0             	movzbl %al,%eax
80103706:	89 c2                	mov    %eax,%edx
80103708:	c1 e2 08             	shl    $0x8,%edx
8010370b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010370e:	83 c0 0e             	add    $0xe,%eax
80103711:	0f b6 00             	movzbl (%eax),%eax
80103714:	0f b6 c0             	movzbl %al,%eax
80103717:	09 d0                	or     %edx,%eax
80103719:	c1 e0 04             	shl    $0x4,%eax
8010371c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010371f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103723:	74 21                	je     80103746 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103725:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
8010372c:	00 
8010372d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103730:	89 04 24             	mov    %eax,(%esp)
80103733:	e8 42 ff ff ff       	call   8010367a <mpsearch1>
80103738:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010373b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010373f:	74 50                	je     80103791 <mpsearch+0xa4>
      return mp;
80103741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103744:	eb 5f                	jmp    801037a5 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103746:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103749:	83 c0 14             	add    $0x14,%eax
8010374c:	0f b6 00             	movzbl (%eax),%eax
8010374f:	0f b6 c0             	movzbl %al,%eax
80103752:	89 c2                	mov    %eax,%edx
80103754:	c1 e2 08             	shl    $0x8,%edx
80103757:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010375a:	83 c0 13             	add    $0x13,%eax
8010375d:	0f b6 00             	movzbl (%eax),%eax
80103760:	0f b6 c0             	movzbl %al,%eax
80103763:	09 d0                	or     %edx,%eax
80103765:	c1 e0 0a             	shl    $0xa,%eax
80103768:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
8010376b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010376e:	2d 00 04 00 00       	sub    $0x400,%eax
80103773:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
8010377a:	00 
8010377b:	89 04 24             	mov    %eax,(%esp)
8010377e:	e8 f7 fe ff ff       	call   8010367a <mpsearch1>
80103783:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103786:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010378a:	74 05                	je     80103791 <mpsearch+0xa4>
      return mp;
8010378c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010378f:	eb 14                	jmp    801037a5 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103791:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103798:	00 
80103799:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
801037a0:	e8 d5 fe ff ff       	call   8010367a <mpsearch1>
}
801037a5:	c9                   	leave  
801037a6:	c3                   	ret    

801037a7 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801037a7:	55                   	push   %ebp
801037a8:	89 e5                	mov    %esp,%ebp
801037aa:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037ad:	e8 3b ff ff ff       	call   801036ed <mpsearch>
801037b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037b9:	74 0a                	je     801037c5 <mpconfig+0x1e>
801037bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037be:	8b 40 04             	mov    0x4(%eax),%eax
801037c1:	85 c0                	test   %eax,%eax
801037c3:	75 0a                	jne    801037cf <mpconfig+0x28>
    return 0;
801037c5:	b8 00 00 00 00       	mov    $0x0,%eax
801037ca:	e9 83 00 00 00       	jmp    80103852 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801037cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037d2:	8b 40 04             	mov    0x4(%eax),%eax
801037d5:	89 04 24             	mov    %eax,(%esp)
801037d8:	e8 ff fd ff ff       	call   801035dc <p2v>
801037dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801037e0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801037e7:	00 
801037e8:	c7 44 24 04 6d 84 10 	movl   $0x8010846d,0x4(%esp)
801037ef:	80 
801037f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037f3:	89 04 24             	mov    %eax,(%esp)
801037f6:	e8 26 17 00 00       	call   80104f21 <memcmp>
801037fb:	85 c0                	test   %eax,%eax
801037fd:	74 07                	je     80103806 <mpconfig+0x5f>
    return 0;
801037ff:	b8 00 00 00 00       	mov    $0x0,%eax
80103804:	eb 4c                	jmp    80103852 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103806:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103809:	0f b6 40 06          	movzbl 0x6(%eax),%eax
8010380d:	3c 01                	cmp    $0x1,%al
8010380f:	74 12                	je     80103823 <mpconfig+0x7c>
80103811:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103814:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103818:	3c 04                	cmp    $0x4,%al
8010381a:	74 07                	je     80103823 <mpconfig+0x7c>
    return 0;
8010381c:	b8 00 00 00 00       	mov    $0x0,%eax
80103821:	eb 2f                	jmp    80103852 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103823:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103826:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010382a:	0f b7 d0             	movzwl %ax,%edx
8010382d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103830:	89 54 24 04          	mov    %edx,0x4(%esp)
80103834:	89 04 24             	mov    %eax,(%esp)
80103837:	e8 08 fe ff ff       	call   80103644 <sum>
8010383c:	84 c0                	test   %al,%al
8010383e:	74 07                	je     80103847 <mpconfig+0xa0>
    return 0;
80103840:	b8 00 00 00 00       	mov    $0x0,%eax
80103845:	eb 0b                	jmp    80103852 <mpconfig+0xab>
  *pmp = mp;
80103847:	8b 45 08             	mov    0x8(%ebp),%eax
8010384a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010384d:	89 10                	mov    %edx,(%eax)
  return conf;
8010384f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103852:	c9                   	leave  
80103853:	c3                   	ret    

80103854 <mpinit>:

void
mpinit(void)
{
80103854:	55                   	push   %ebp
80103855:	89 e5                	mov    %esp,%ebp
80103857:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
8010385a:	c7 05 44 b6 10 80 20 	movl   $0x8010f920,0x8010b644
80103861:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
80103864:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103867:	89 04 24             	mov    %eax,(%esp)
8010386a:	e8 38 ff ff ff       	call   801037a7 <mpconfig>
8010386f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103872:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103876:	0f 84 9d 01 00 00    	je     80103a19 <mpinit+0x1c5>
    return;
  ismp = 1;
8010387c:	c7 05 04 f9 10 80 01 	movl   $0x1,0x8010f904
80103883:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103886:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103889:	8b 40 24             	mov    0x24(%eax),%eax
8010388c:	a3 7c f8 10 80       	mov    %eax,0x8010f87c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103891:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103894:	83 c0 2c             	add    $0x2c,%eax
80103897:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010389a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010389d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038a0:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801038a4:	0f b7 c0             	movzwl %ax,%eax
801038a7:	8d 04 02             	lea    (%edx,%eax,1),%eax
801038aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
801038ad:	e9 f2 00 00 00       	jmp    801039a4 <mpinit+0x150>
    switch(*p){
801038b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801038b5:	0f b6 00             	movzbl (%eax),%eax
801038b8:	0f b6 c0             	movzbl %al,%eax
801038bb:	83 f8 04             	cmp    $0x4,%eax
801038be:	0f 87 bd 00 00 00    	ja     80103981 <mpinit+0x12d>
801038c4:	8b 04 85 b0 84 10 80 	mov    -0x7fef7b50(,%eax,4),%eax
801038cb:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801038cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801038d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(ncpu != proc->apicid){
801038d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038da:	0f b6 d0             	movzbl %al,%edx
801038dd:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801038e2:	39 c2                	cmp    %eax,%edx
801038e4:	74 2d                	je     80103913 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801038e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038e9:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038ed:	0f b6 d0             	movzbl %al,%edx
801038f0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801038f5:	89 54 24 08          	mov    %edx,0x8(%esp)
801038f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801038fd:	c7 04 24 72 84 10 80 	movl   $0x80108472,(%esp)
80103904:	e8 91 ca ff ff       	call   8010039a <cprintf>
        ismp = 0;
80103909:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
80103910:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103913:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103916:	0f b6 40 03          	movzbl 0x3(%eax),%eax
8010391a:	0f b6 c0             	movzbl %al,%eax
8010391d:	83 e0 02             	and    $0x2,%eax
80103920:	85 c0                	test   %eax,%eax
80103922:	74 15                	je     80103939 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103924:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103929:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010392f:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103934:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103939:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010393e:	8b 15 00 ff 10 80    	mov    0x8010ff00,%edx
80103944:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010394a:	88 90 20 f9 10 80    	mov    %dl,-0x7fef06e0(%eax)
      ncpu++;
80103950:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103955:	83 c0 01             	add    $0x1,%eax
80103958:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
      p += sizeof(struct mpproc);
8010395d:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
      continue;
80103961:	eb 41                	jmp    801039a4 <mpinit+0x150>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103966:	89 45 f4             	mov    %eax,-0xc(%ebp)
      ioapicid = ioapic->apicno;
80103969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010396c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103970:	a2 00 f9 10 80       	mov    %al,0x8010f900
      p += sizeof(struct mpioapic);
80103975:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
      continue;
80103979:	eb 29                	jmp    801039a4 <mpinit+0x150>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010397b:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
      continue;
8010397f:	eb 23                	jmp    801039a4 <mpinit+0x150>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103984:	0f b6 00             	movzbl (%eax),%eax
80103987:	0f b6 c0             	movzbl %al,%eax
8010398a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010398e:	c7 04 24 90 84 10 80 	movl   $0x80108490,(%esp)
80103995:	e8 00 ca ff ff       	call   8010039a <cprintf>
      ismp = 0;
8010399a:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
801039a1:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039a7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
801039aa:	0f 82 02 ff ff ff    	jb     801038b2 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801039b0:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801039b5:	85 c0                	test   %eax,%eax
801039b7:	75 1d                	jne    801039d6 <mpinit+0x182>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039b9:	c7 05 00 ff 10 80 01 	movl   $0x1,0x8010ff00
801039c0:	00 00 00 
    lapic = 0;
801039c3:	c7 05 7c f8 10 80 00 	movl   $0x0,0x8010f87c
801039ca:	00 00 00 
    ioapicid = 0;
801039cd:	c6 05 00 f9 10 80 00 	movb   $0x0,0x8010f900
    return;
801039d4:	eb 44                	jmp    80103a1a <mpinit+0x1c6>
  }

  if(mp->imcrp){
801039d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801039d9:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801039dd:	84 c0                	test   %al,%al
801039df:	74 39                	je     80103a1a <mpinit+0x1c6>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801039e1:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
801039e8:	00 
801039e9:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
801039f0:	e8 11 fc ff ff       	call   80103606 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039f5:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
801039fc:	e8 e8 fb ff ff       	call   801035e9 <inb>
80103a01:	83 c8 01             	or     $0x1,%eax
80103a04:	0f b6 c0             	movzbl %al,%eax
80103a07:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a0b:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a12:	e8 ef fb ff ff       	call   80103606 <outb>
80103a17:	eb 01                	jmp    80103a1a <mpinit+0x1c6>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103a19:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103a1a:	c9                   	leave  
80103a1b:	c3                   	ret    

80103a1c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a1c:	55                   	push   %ebp
80103a1d:	89 e5                	mov    %esp,%ebp
80103a1f:	83 ec 08             	sub    $0x8,%esp
80103a22:	8b 55 08             	mov    0x8(%ebp),%edx
80103a25:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a28:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a2c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a2f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a33:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a37:	ee                   	out    %al,(%dx)
}
80103a38:	c9                   	leave  
80103a39:	c3                   	ret    

80103a3a <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a3a:	55                   	push   %ebp
80103a3b:	89 e5                	mov    %esp,%ebp
80103a3d:	83 ec 0c             	sub    $0xc,%esp
80103a40:	8b 45 08             	mov    0x8(%ebp),%eax
80103a43:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a47:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a4b:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103a51:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a55:	0f b6 c0             	movzbl %al,%eax
80103a58:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a5c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a63:	e8 b4 ff ff ff       	call   80103a1c <outb>
  outb(IO_PIC2+1, mask >> 8);
80103a68:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a6c:	66 c1 e8 08          	shr    $0x8,%ax
80103a70:	0f b6 c0             	movzbl %al,%eax
80103a73:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a77:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103a7e:	e8 99 ff ff ff       	call   80103a1c <outb>
}
80103a83:	c9                   	leave  
80103a84:	c3                   	ret    

80103a85 <picenable>:

void
picenable(int irq)
{
80103a85:	55                   	push   %ebp
80103a86:	89 e5                	mov    %esp,%ebp
80103a88:	53                   	push   %ebx
80103a89:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80103a8f:	ba 01 00 00 00       	mov    $0x1,%edx
80103a94:	89 d3                	mov    %edx,%ebx
80103a96:	89 c1                	mov    %eax,%ecx
80103a98:	d3 e3                	shl    %cl,%ebx
80103a9a:	89 d8                	mov    %ebx,%eax
80103a9c:	89 c2                	mov    %eax,%edx
80103a9e:	f7 d2                	not    %edx
80103aa0:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103aa7:	21 d0                	and    %edx,%eax
80103aa9:	0f b7 c0             	movzwl %ax,%eax
80103aac:	89 04 24             	mov    %eax,(%esp)
80103aaf:	e8 86 ff ff ff       	call   80103a3a <picsetmask>
}
80103ab4:	83 c4 04             	add    $0x4,%esp
80103ab7:	5b                   	pop    %ebx
80103ab8:	5d                   	pop    %ebp
80103ab9:	c3                   	ret    

80103aba <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103aba:	55                   	push   %ebp
80103abb:	89 e5                	mov    %esp,%ebp
80103abd:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ac0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ac7:	00 
80103ac8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103acf:	e8 48 ff ff ff       	call   80103a1c <outb>
  outb(IO_PIC2+1, 0xFF);
80103ad4:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103adb:	00 
80103adc:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ae3:	e8 34 ff ff ff       	call   80103a1c <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103ae8:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103aef:	00 
80103af0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103af7:	e8 20 ff ff ff       	call   80103a1c <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103afc:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103b03:	00 
80103b04:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b0b:	e8 0c ff ff ff       	call   80103a1c <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b10:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b17:	00 
80103b18:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b1f:	e8 f8 fe ff ff       	call   80103a1c <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b24:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b2b:	00 
80103b2c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b33:	e8 e4 fe ff ff       	call   80103a1c <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b38:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b3f:	00 
80103b40:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b47:	e8 d0 fe ff ff       	call   80103a1c <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b4c:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b53:	00 
80103b54:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b5b:	e8 bc fe ff ff       	call   80103a1c <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b60:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103b67:	00 
80103b68:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b6f:	e8 a8 fe ff ff       	call   80103a1c <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103b74:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b7b:	00 
80103b7c:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b83:	e8 94 fe ff ff       	call   80103a1c <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103b88:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103b8f:	00 
80103b90:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b97:	e8 80 fe ff ff       	call   80103a1c <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103b9c:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103ba3:	00 
80103ba4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103bab:	e8 6c fe ff ff       	call   80103a1c <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103bb0:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bb7:	00 
80103bb8:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bbf:	e8 58 fe ff ff       	call   80103a1c <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103bc4:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bcb:	00 
80103bcc:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bd3:	e8 44 fe ff ff       	call   80103a1c <outb>

  if(irqmask != 0xFFFF)
80103bd8:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103bdf:	66 83 f8 ff          	cmp    $0xffffffff,%ax
80103be3:	74 12                	je     80103bf7 <picinit+0x13d>
    picsetmask(irqmask);
80103be5:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103bec:	0f b7 c0             	movzwl %ax,%eax
80103bef:	89 04 24             	mov    %eax,(%esp)
80103bf2:	e8 43 fe ff ff       	call   80103a3a <picsetmask>
}
80103bf7:	c9                   	leave  
80103bf8:	c3                   	ret    
80103bf9:	00 00                	add    %al,(%eax)
	...

80103bfc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103bfc:	55                   	push   %ebp
80103bfd:	89 e5                	mov    %esp,%ebp
80103bff:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103c02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103c09:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c12:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c15:	8b 10                	mov    (%eax),%edx
80103c17:	8b 45 08             	mov    0x8(%ebp),%eax
80103c1a:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c1c:	e8 f7 d2 ff ff       	call   80100f18 <filealloc>
80103c21:	8b 55 08             	mov    0x8(%ebp),%edx
80103c24:	89 02                	mov    %eax,(%edx)
80103c26:	8b 45 08             	mov    0x8(%ebp),%eax
80103c29:	8b 00                	mov    (%eax),%eax
80103c2b:	85 c0                	test   %eax,%eax
80103c2d:	0f 84 c8 00 00 00    	je     80103cfb <pipealloc+0xff>
80103c33:	e8 e0 d2 ff ff       	call   80100f18 <filealloc>
80103c38:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c3b:	89 02                	mov    %eax,(%edx)
80103c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c40:	8b 00                	mov    (%eax),%eax
80103c42:	85 c0                	test   %eax,%eax
80103c44:	0f 84 b1 00 00 00    	je     80103cfb <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c4a:	e8 af ee ff ff       	call   80102afe <kalloc>
80103c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c56:	0f 84 9e 00 00 00    	je     80103cfa <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
80103c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5f:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c66:	00 00 00 
  p->writeopen = 1;
80103c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c6c:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c73:	00 00 00 
  p->nwrite = 0;
80103c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c79:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c80:	00 00 00 
  p->nread = 0;
80103c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c86:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c8d:	00 00 00 
  initlock(&p->lock, "pipe");
80103c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c93:	c7 44 24 04 c4 84 10 	movl   $0x801084c4,0x4(%esp)
80103c9a:	80 
80103c9b:	89 04 24             	mov    %eax,(%esp)
80103c9e:	e8 97 0f 00 00       	call   80104c3a <initlock>
  (*f0)->type = FD_PIPE;
80103ca3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ca6:	8b 00                	mov    (%eax),%eax
80103ca8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cae:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb1:	8b 00                	mov    (%eax),%eax
80103cb3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80103cba:	8b 00                	mov    (%eax),%eax
80103cbc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cc0:	8b 45 08             	mov    0x8(%ebp),%eax
80103cc3:	8b 00                	mov    (%eax),%eax
80103cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cc8:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cce:	8b 00                	mov    (%eax),%eax
80103cd0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cd9:	8b 00                	mov    (%eax),%eax
80103cdb:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ce2:	8b 00                	mov    (%eax),%eax
80103ce4:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ceb:	8b 00                	mov    (%eax),%eax
80103ced:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cf0:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103cf3:	b8 00 00 00 00       	mov    $0x0,%eax
80103cf8:	eb 43                	jmp    80103d3d <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103cfa:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cff:	74 0b                	je     80103d0c <pipealloc+0x110>
    kfree((char*)p);
80103d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d04:	89 04 24             	mov    %eax,(%esp)
80103d07:	e8 59 ed ff ff       	call   80102a65 <kfree>
  if(*f0)
80103d0c:	8b 45 08             	mov    0x8(%ebp),%eax
80103d0f:	8b 00                	mov    (%eax),%eax
80103d11:	85 c0                	test   %eax,%eax
80103d13:	74 0d                	je     80103d22 <pipealloc+0x126>
    fileclose(*f0);
80103d15:	8b 45 08             	mov    0x8(%ebp),%eax
80103d18:	8b 00                	mov    (%eax),%eax
80103d1a:	89 04 24             	mov    %eax,(%esp)
80103d1d:	e8 9f d2 ff ff       	call   80100fc1 <fileclose>
  if(*f1)
80103d22:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d25:	8b 00                	mov    (%eax),%eax
80103d27:	85 c0                	test   %eax,%eax
80103d29:	74 0d                	je     80103d38 <pipealloc+0x13c>
    fileclose(*f1);
80103d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d2e:	8b 00                	mov    (%eax),%eax
80103d30:	89 04 24             	mov    %eax,(%esp)
80103d33:	e8 89 d2 ff ff       	call   80100fc1 <fileclose>
  return -1;
80103d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d3d:	c9                   	leave  
80103d3e:	c3                   	ret    

80103d3f <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d3f:	55                   	push   %ebp
80103d40:	89 e5                	mov    %esp,%ebp
80103d42:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d45:	8b 45 08             	mov    0x8(%ebp),%eax
80103d48:	89 04 24             	mov    %eax,(%esp)
80103d4b:	e8 0b 0f 00 00       	call   80104c5b <acquire>
  if(writable){
80103d50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d54:	74 1f                	je     80103d75 <pipeclose+0x36>
    p->writeopen = 0;
80103d56:	8b 45 08             	mov    0x8(%ebp),%eax
80103d59:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d60:	00 00 00 
    wakeup(&p->nread);
80103d63:	8b 45 08             	mov    0x8(%ebp),%eax
80103d66:	05 34 02 00 00       	add    $0x234,%eax
80103d6b:	89 04 24             	mov    %eax,(%esp)
80103d6e:	e8 e1 0c 00 00       	call   80104a54 <wakeup>
80103d73:	eb 1d                	jmp    80103d92 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103d75:	8b 45 08             	mov    0x8(%ebp),%eax
80103d78:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103d7f:	00 00 00 
    wakeup(&p->nwrite);
80103d82:	8b 45 08             	mov    0x8(%ebp),%eax
80103d85:	05 38 02 00 00       	add    $0x238,%eax
80103d8a:	89 04 24             	mov    %eax,(%esp)
80103d8d:	e8 c2 0c 00 00       	call   80104a54 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d92:	8b 45 08             	mov    0x8(%ebp),%eax
80103d95:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103d9b:	85 c0                	test   %eax,%eax
80103d9d:	75 25                	jne    80103dc4 <pipeclose+0x85>
80103d9f:	8b 45 08             	mov    0x8(%ebp),%eax
80103da2:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103da8:	85 c0                	test   %eax,%eax
80103daa:	75 18                	jne    80103dc4 <pipeclose+0x85>
    release(&p->lock);
80103dac:	8b 45 08             	mov    0x8(%ebp),%eax
80103daf:	89 04 24             	mov    %eax,(%esp)
80103db2:	e8 05 0f 00 00       	call   80104cbc <release>
    kfree((char*)p);
80103db7:	8b 45 08             	mov    0x8(%ebp),%eax
80103dba:	89 04 24             	mov    %eax,(%esp)
80103dbd:	e8 a3 ec ff ff       	call   80102a65 <kfree>
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103dc2:	eb 0b                	jmp    80103dcf <pipeclose+0x90>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103dc4:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc7:	89 04 24             	mov    %eax,(%esp)
80103dca:	e8 ed 0e 00 00       	call   80104cbc <release>
}
80103dcf:	c9                   	leave  
80103dd0:	c3                   	ret    

80103dd1 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103dd1:	55                   	push   %ebp
80103dd2:	89 e5                	mov    %esp,%ebp
80103dd4:	53                   	push   %ebx
80103dd5:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103dd8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ddb:	89 04 24             	mov    %eax,(%esp)
80103dde:	e8 78 0e 00 00       	call   80104c5b <acquire>
  for(i = 0; i < n; i++){
80103de3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103dea:	e9 a6 00 00 00       	jmp    80103e95 <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103def:	8b 45 08             	mov    0x8(%ebp),%eax
80103df2:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103df8:	85 c0                	test   %eax,%eax
80103dfa:	74 0d                	je     80103e09 <pipewrite+0x38>
80103dfc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e02:	8b 40 24             	mov    0x24(%eax),%eax
80103e05:	85 c0                	test   %eax,%eax
80103e07:	74 15                	je     80103e1e <pipewrite+0x4d>
        release(&p->lock);
80103e09:	8b 45 08             	mov    0x8(%ebp),%eax
80103e0c:	89 04 24             	mov    %eax,(%esp)
80103e0f:	e8 a8 0e 00 00       	call   80104cbc <release>
        return -1;
80103e14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e19:	e9 9d 00 00 00       	jmp    80103ebb <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e1e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e21:	05 34 02 00 00       	add    $0x234,%eax
80103e26:	89 04 24             	mov    %eax,(%esp)
80103e29:	e8 26 0c 00 00       	call   80104a54 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e31:	8b 55 08             	mov    0x8(%ebp),%edx
80103e34:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e3e:	89 14 24             	mov    %edx,(%esp)
80103e41:	e8 26 0b 00 00       	call   8010496c <sleep>
80103e46:	eb 01                	jmp    80103e49 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e48:	90                   	nop
80103e49:	8b 45 08             	mov    0x8(%ebp),%eax
80103e4c:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e52:	8b 45 08             	mov    0x8(%ebp),%eax
80103e55:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e5b:	05 00 02 00 00       	add    $0x200,%eax
80103e60:	39 c2                	cmp    %eax,%edx
80103e62:	74 8b                	je     80103def <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e64:	8b 45 08             	mov    0x8(%ebp),%eax
80103e67:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103e6d:	89 c3                	mov    %eax,%ebx
80103e6f:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e78:	03 55 0c             	add    0xc(%ebp),%edx
80103e7b:	0f b6 0a             	movzbl (%edx),%ecx
80103e7e:	8b 55 08             	mov    0x8(%ebp),%edx
80103e81:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103e85:	8d 50 01             	lea    0x1(%eax),%edx
80103e88:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8b:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103e91:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e98:	3b 45 10             	cmp    0x10(%ebp),%eax
80103e9b:	7c ab                	jl     80103e48 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e9d:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea0:	05 34 02 00 00       	add    $0x234,%eax
80103ea5:	89 04 24             	mov    %eax,(%esp)
80103ea8:	e8 a7 0b 00 00       	call   80104a54 <wakeup>
  release(&p->lock);
80103ead:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb0:	89 04 24             	mov    %eax,(%esp)
80103eb3:	e8 04 0e 00 00       	call   80104cbc <release>
  return n;
80103eb8:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103ebb:	83 c4 24             	add    $0x24,%esp
80103ebe:	5b                   	pop    %ebx
80103ebf:	5d                   	pop    %ebp
80103ec0:	c3                   	ret    

80103ec1 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ec1:	55                   	push   %ebp
80103ec2:	89 e5                	mov    %esp,%ebp
80103ec4:	53                   	push   %ebx
80103ec5:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ecb:	89 04 24             	mov    %eax,(%esp)
80103ece:	e8 88 0d 00 00       	call   80104c5b <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ed3:	eb 3a                	jmp    80103f0f <piperead+0x4e>
    if(proc->killed){
80103ed5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103edb:	8b 40 24             	mov    0x24(%eax),%eax
80103ede:	85 c0                	test   %eax,%eax
80103ee0:	74 15                	je     80103ef7 <piperead+0x36>
      release(&p->lock);
80103ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee5:	89 04 24             	mov    %eax,(%esp)
80103ee8:	e8 cf 0d 00 00       	call   80104cbc <release>
      return -1;
80103eed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ef2:	e9 b6 00 00 00       	jmp    80103fad <piperead+0xec>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ef7:	8b 45 08             	mov    0x8(%ebp),%eax
80103efa:	8b 55 08             	mov    0x8(%ebp),%edx
80103efd:	81 c2 34 02 00 00    	add    $0x234,%edx
80103f03:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f07:	89 14 24             	mov    %edx,(%esp)
80103f0a:	e8 5d 0a 00 00       	call   8010496c <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f12:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f18:	8b 45 08             	mov    0x8(%ebp),%eax
80103f1b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f21:	39 c2                	cmp    %eax,%edx
80103f23:	75 0d                	jne    80103f32 <piperead+0x71>
80103f25:	8b 45 08             	mov    0x8(%ebp),%eax
80103f28:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f2e:	85 c0                	test   %eax,%eax
80103f30:	75 a3                	jne    80103ed5 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f39:	eb 49                	jmp    80103f84 <piperead+0xc3>
    if(p->nread == p->nwrite)
80103f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f44:	8b 45 08             	mov    0x8(%ebp),%eax
80103f47:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f4d:	39 c2                	cmp    %eax,%edx
80103f4f:	74 3d                	je     80103f8e <piperead+0xcd>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f54:	89 c2                	mov    %eax,%edx
80103f56:	03 55 0c             	add    0xc(%ebp),%edx
80103f59:	8b 45 08             	mov    0x8(%ebp),%eax
80103f5c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f62:	89 c3                	mov    %eax,%ebx
80103f64:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103f6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103f6d:	0f b6 4c 19 34       	movzbl 0x34(%ecx,%ebx,1),%ecx
80103f72:	88 0a                	mov    %cl,(%edx)
80103f74:	8d 50 01             	lea    0x1(%eax),%edx
80103f77:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7a:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f87:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f8a:	7c af                	jl     80103f3b <piperead+0x7a>
80103f8c:	eb 01                	jmp    80103f8f <piperead+0xce>
    if(p->nread == p->nwrite)
      break;
80103f8e:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f92:	05 38 02 00 00       	add    $0x238,%eax
80103f97:	89 04 24             	mov    %eax,(%esp)
80103f9a:	e8 b5 0a 00 00       	call   80104a54 <wakeup>
  release(&p->lock);
80103f9f:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa2:	89 04 24             	mov    %eax,(%esp)
80103fa5:	e8 12 0d 00 00       	call   80104cbc <release>
  return i;
80103faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103fad:	83 c4 24             	add    $0x24,%esp
80103fb0:	5b                   	pop    %ebx
80103fb1:	5d                   	pop    %ebp
80103fb2:	c3                   	ret    
	...

80103fb4 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103fb4:	55                   	push   %ebp
80103fb5:	89 e5                	mov    %esp,%ebp
80103fb7:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fba:	9c                   	pushf  
80103fbb:	58                   	pop    %eax
80103fbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103fc2:	c9                   	leave  
80103fc3:	c3                   	ret    

80103fc4 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80103fc4:	55                   	push   %ebp
80103fc5:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103fc7:	fb                   	sti    
}
80103fc8:	5d                   	pop    %ebp
80103fc9:	c3                   	ret    

80103fca <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103fca:	55                   	push   %ebp
80103fcb:	89 e5                	mov    %esp,%ebp
80103fcd:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103fd0:	c7 44 24 04 c9 84 10 	movl   $0x801084c9,0x4(%esp)
80103fd7:	80 
80103fd8:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80103fdf:	e8 56 0c 00 00       	call   80104c3a <initlock>

}
80103fe4:	c9                   	leave  
80103fe5:	c3                   	ret    

80103fe6 <rqinit>:

void
rqinit(void)
{
80103fe6:	55                   	push   %ebp
80103fe7:	89 e5                	mov    %esp,%ebp
80103fe9:	83 ec 28             	sub    $0x28,%esp
  int i;
  initlock(&ready_q.lock, "ready_q");
80103fec:	c7 44 24 04 d0 84 10 	movl   $0x801084d0,0x4(%esp)
80103ff3:	80 
80103ff4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80103ffb:	e8 3a 0c 00 00       	call   80104c3a <initlock>
  for(i = 0; i < NPRIORITYS; i++)
80104000:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104007:	eb 15                	jmp    8010401e <rqinit+0x38>
    {
      ready_q.proc[i] = 0;
80104009:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010400c:	83 c0 0c             	add    $0xc,%eax
8010400f:	c7 04 85 24 ff 10 80 	movl   $0x0,-0x7fef00dc(,%eax,4)
80104016:	00 00 00 00 
void
rqinit(void)
{
  int i;
  initlock(&ready_q.lock, "ready_q");
  for(i = 0; i < NPRIORITYS; i++)
8010401a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010401e:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
80104022:	7e e5                	jle    80104009 <rqinit+0x23>
    {
      ready_q.proc[i] = 0;
    }
}
80104024:	c9                   	leave  
80104025:	c3                   	ret    

80104026 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104026:	55                   	push   %ebp
80104027:	89 e5                	mov    %esp,%ebp
80104029:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010402c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104033:	e8 23 0c 00 00       	call   80104c5b <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104038:	c7 45 f0 14 00 11 80 	movl   $0x80110014,-0x10(%ebp)
8010403f:	eb 11                	jmp    80104052 <allocproc+0x2c>
    if(p->state == UNUSED)
80104041:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104044:	8b 40 0c             	mov    0xc(%eax),%eax
80104047:	85 c0                	test   %eax,%eax
80104049:	74 27                	je     80104072 <allocproc+0x4c>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010404b:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104052:	b8 14 21 11 80       	mov    $0x80112114,%eax
80104057:	39 45 f0             	cmp    %eax,-0x10(%ebp)
8010405a:	72 e5                	jb     80104041 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010405c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104063:	e8 54 0c 00 00       	call   80104cbc <release>
  return 0;
80104068:	b8 00 00 00 00       	mov    $0x0,%eax
8010406d:	e9 cc 00 00 00       	jmp    8010413e <allocproc+0x118>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104072:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104073:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104076:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010407d:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104082:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104085:	89 42 10             	mov    %eax,0x10(%edx)
80104088:	83 c0 01             	add    $0x1,%eax
8010408b:	a3 04 b0 10 80       	mov    %eax,0x8010b004
  //set high prority
  p-> priority = 0;
80104090:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104093:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010409a:	00 00 00 
  //need to malloc size??
   p->next = 0;
8010409d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040a0:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  release(&ptable.lock);
801040a7:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801040ae:	e8 09 0c 00 00       	call   80104cbc <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801040b3:	e8 46 ea ff ff       	call   80102afe <kalloc>
801040b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040bb:	89 42 08             	mov    %eax,0x8(%edx)
801040be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040c1:	8b 40 08             	mov    0x8(%eax),%eax
801040c4:	85 c0                	test   %eax,%eax
801040c6:	75 11                	jne    801040d9 <allocproc+0xb3>
    p->state = UNUSED;
801040c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040cb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801040d2:	b8 00 00 00 00       	mov    $0x0,%eax
801040d7:	eb 65                	jmp    8010413e <allocproc+0x118>
  }
  sp = p->kstack + KSTACKSIZE;
801040d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040dc:	8b 40 08             	mov    0x8(%eax),%eax
801040df:	05 00 10 00 00       	add    $0x1000,%eax
801040e4:	89 45 f4             	mov    %eax,-0xc(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801040e7:	83 6d f4 4c          	subl   $0x4c,-0xc(%ebp)
  p->tf = (struct trapframe*)sp;
801040eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040f1:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801040f4:	83 6d f4 04          	subl   $0x4,-0xc(%ebp)
  *(uint*)sp = (uint)trapret;
801040f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040fb:	ba b0 62 10 80       	mov    $0x801062b0,%edx
80104100:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104102:	83 6d f4 14          	subl   $0x14,-0xc(%ebp)
  p->context = (struct context*)sp;
80104106:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104109:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010410c:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010410f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104112:	8b 40 1c             	mov    0x1c(%eax),%eax
80104115:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010411c:	00 
8010411d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104124:	00 
80104125:	89 04 24             	mov    %eax,(%esp)
80104128:	e8 7d 0d 00 00       	call   80104eaa <memset>
  p->context->eip = (uint)forkret;
8010412d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104130:	8b 40 1c             	mov    0x1c(%eax),%eax
80104133:	ba 40 49 10 80       	mov    $0x80104940,%edx
80104138:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010413b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010413e:	c9                   	leave  
8010413f:	c3                   	ret    

80104140 <ready1>:


int ready1(struct proc * process)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  if(!process)
80104146:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010414a:	75 07                	jne    80104153 <ready1+0x13>
    return -1;
8010414c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104151:	eb 79                	jmp    801041cc <ready1+0x8c>
  if(process->priority > NPRIORITYS || process->priority < 0)
80104153:	8b 45 08             	mov    0x8(%ebp),%eax
80104156:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010415c:	83 f8 20             	cmp    $0x20,%eax
8010415f:	7f 0d                	jg     8010416e <ready1+0x2e>
80104161:	8b 45 08             	mov    0x8(%ebp),%eax
80104164:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010416a:	85 c0                	test   %eax,%eax
8010416c:	79 07                	jns    80104175 <ready1+0x35>
    return -1;
8010416e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104173:	eb 57                	jmp    801041cc <ready1+0x8c>
  if((p = ready_q.proc[process->priority]))
80104175:	8b 45 08             	mov    0x8(%ebp),%eax
80104178:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010417e:	83 c0 0c             	add    $0xc,%eax
80104181:	8b 04 85 24 ff 10 80 	mov    -0x7fef00dc(,%eax,4),%eax
80104188:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010418b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010418f:	74 20                	je     801041b1 <ready1+0x71>
    {
      while(p->next)
80104191:	eb 09                	jmp    8010419c <ready1+0x5c>
        {
          p = p->next;
80104193:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104196:	8b 40 7c             	mov    0x7c(%eax),%eax
80104199:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return -1;
  if(process->priority > NPRIORITYS || process->priority < 0)
    return -1;
  if((p = ready_q.proc[process->priority]))
    {
      while(p->next)
8010419c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010419f:	8b 40 7c             	mov    0x7c(%eax),%eax
801041a2:	85 c0                	test   %eax,%eax
801041a4:	75 ed                	jne    80104193 <ready1+0x53>
        {
          p = p->next;
        }
      p->next = process;
801041a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801041a9:	8b 55 08             	mov    0x8(%ebp),%edx
801041ac:	89 50 7c             	mov    %edx,0x7c(%eax)
801041af:	eb 16                	jmp    801041c7 <ready1+0x87>
    }
  else
    {
      ready_q.proc[process->priority] = process;
801041b1:	8b 45 08             	mov    0x8(%ebp),%eax
801041b4:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801041ba:	8d 50 0c             	lea    0xc(%eax),%edx
801041bd:	8b 45 08             	mov    0x8(%ebp),%eax
801041c0:	89 04 95 24 ff 10 80 	mov    %eax,-0x7fef00dc(,%edx,4)
    }
  //cprintf("pnt: %d, prio: %d\n", process,  process->priority );
  return 1;
801041c7:	b8 01 00 00 00       	mov    $0x1,%eax

}
801041cc:	c9                   	leave  
801041cd:	c3                   	ret    

801041ce <ready>:

int ready(struct proc * process)
{
801041ce:	55                   	push   %ebp
801041cf:	89 e5                	mov    %esp,%ebp
801041d1:	83 ec 28             	sub    $0x28,%esp
  int ret;
  acquire(&ptable.lock);
801041d4:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801041db:	e8 7b 0a 00 00       	call   80104c5b <acquire>
  ret = ready1(process);
801041e0:	8b 45 08             	mov    0x8(%ebp),%eax
801041e3:	89 04 24             	mov    %eax,(%esp)
801041e6:	e8 55 ff ff ff       	call   80104140 <ready1>
801041eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&ptable.lock);
801041ee:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801041f5:	e8 c2 0a 00 00       	call   80104cbc <release>
  return ret;
801041fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801041fd:	c9                   	leave  
801041fe:	c3                   	ret    

801041ff <userinit>:
// Set up first user process.


void
userinit(void)
{
801041ff:	55                   	push   %ebp
80104200:	89 e5                	mov    %esp,%ebp
80104202:	83 ec 28             	sub    $0x28,%esp
  cprintf("userinit\n");
80104205:	c7 04 24 d8 84 10 80 	movl   $0x801084d8,(%esp)
8010420c:	e8 89 c1 ff ff       	call   8010039a <cprintf>
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104211:	e8 10 fe ff ff       	call   80104026 <allocproc>
80104216:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010421c:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
80104221:	e8 73 37 00 00       	call   80107999 <setupkvm>
80104226:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104229:	89 42 04             	mov    %eax,0x4(%edx)
8010422c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422f:	8b 40 04             	mov    0x4(%eax),%eax
80104232:	85 c0                	test   %eax,%eax
80104234:	75 0c                	jne    80104242 <userinit+0x43>
    panic("userinit: out of memory?");
80104236:	c7 04 24 e2 84 10 80 	movl   $0x801084e2,(%esp)
8010423d:	e8 f8 c2 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104242:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104247:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424a:	8b 40 04             	mov    0x4(%eax),%eax
8010424d:	89 54 24 08          	mov    %edx,0x8(%esp)
80104251:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
80104258:	80 
80104259:	89 04 24             	mov    %eax,(%esp)
8010425c:	e8 91 39 00 00       	call   80107bf2 <inituvm>
  p->sz = PGSIZE;
80104261:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104264:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010426a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426d:	8b 40 18             	mov    0x18(%eax),%eax
80104270:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104277:	00 
80104278:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010427f:	00 
80104280:	89 04 24             	mov    %eax,(%esp)
80104283:	e8 22 0c 00 00       	call   80104eaa <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010428b:	8b 40 18             	mov    0x18(%eax),%eax
8010428e:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104294:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104297:	8b 40 18             	mov    0x18(%eax),%eax
8010429a:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801042a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a3:	8b 40 18             	mov    0x18(%eax),%eax
801042a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042a9:	8b 52 18             	mov    0x18(%edx),%edx
801042ac:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801042b0:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801042b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b7:	8b 40 18             	mov    0x18(%eax),%eax
801042ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042bd:	8b 52 18             	mov    0x18(%edx),%edx
801042c0:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801042c4:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801042c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042cb:	8b 40 18             	mov    0x18(%eax),%eax
801042ce:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801042d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d8:	8b 40 18             	mov    0x18(%eax),%eax
801042db:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801042e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e5:	8b 40 18             	mov    0x18(%eax),%eax
801042e8:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801042ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f2:	83 c0 6c             	add    $0x6c,%eax
801042f5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801042fc:	00 
801042fd:	c7 44 24 04 fb 84 10 	movl   $0x801084fb,0x4(%esp)
80104304:	80 
80104305:	89 04 24             	mov    %eax,(%esp)
80104308:	e8 d0 0d 00 00       	call   801050dd <safestrcpy>
  p->cwd = namei("/");
8010430d:	c7 04 24 04 85 10 80 	movl   $0x80108504,(%esp)
80104314:	e8 fe e0 ff ff       	call   80102417 <namei>
80104319:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010431c:	89 42 68             	mov    %eax,0x68(%edx)
  cprintf("here\n");
8010431f:	c7 04 24 06 85 10 80 	movl   $0x80108506,(%esp)
80104326:	e8 6f c0 ff ff       	call   8010039a <cprintf>
  p->state = RUNNABLE;
8010432b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  ready(p);
80104335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104338:	89 04 24             	mov    %eax,(%esp)
8010433b:	e8 8e fe ff ff       	call   801041ce <ready>

}
80104340:	c9                   	leave  
80104341:	c3                   	ret    

80104342 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104342:	55                   	push   %ebp
80104343:	89 e5                	mov    %esp,%ebp
80104345:	83 ec 28             	sub    $0x28,%esp
  uint sz;

  sz = proc->sz;
80104348:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010434e:	8b 00                	mov    (%eax),%eax
80104350:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104353:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104357:	7e 34                	jle    8010438d <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104359:	8b 45 08             	mov    0x8(%ebp),%eax
8010435c:	89 c2                	mov    %eax,%edx
8010435e:	03 55 f4             	add    -0xc(%ebp),%edx
80104361:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104367:	8b 40 04             	mov    0x4(%eax),%eax
8010436a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010436e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104371:	89 54 24 04          	mov    %edx,0x4(%esp)
80104375:	89 04 24             	mov    %eax,(%esp)
80104378:	e8 f0 39 00 00       	call   80107d6d <allocuvm>
8010437d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104384:	75 41                	jne    801043c7 <growproc+0x85>
      return -1;
80104386:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010438b:	eb 58                	jmp    801043e5 <growproc+0xa3>
  } else if(n < 0){
8010438d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104391:	79 34                	jns    801043c7 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104393:	8b 45 08             	mov    0x8(%ebp),%eax
80104396:	89 c2                	mov    %eax,%edx
80104398:	03 55 f4             	add    -0xc(%ebp),%edx
8010439b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043a1:	8b 40 04             	mov    0x4(%eax),%eax
801043a4:	89 54 24 08          	mov    %edx,0x8(%esp)
801043a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801043af:	89 04 24             	mov    %eax,(%esp)
801043b2:	e8 90 3a 00 00       	call   80107e47 <deallocuvm>
801043b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043be:	75 07                	jne    801043c7 <growproc+0x85>
      return -1;
801043c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043c5:	eb 1e                	jmp    801043e5 <growproc+0xa3>
  }
  proc->sz = sz;
801043c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043d0:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801043d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043d8:	89 04 24             	mov    %eax,(%esp)
801043db:	e8 ab 36 00 00       	call   80107a8b <switchuvm>
  return 0;
801043e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801043e5:	c9                   	leave  
801043e6:	c3                   	ret    

801043e7 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801043e7:	55                   	push   %ebp
801043e8:	89 e5                	mov    %esp,%ebp
801043ea:	57                   	push   %edi
801043eb:	56                   	push   %esi
801043ec:	53                   	push   %ebx
801043ed:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801043f0:	e8 31 fc ff ff       	call   80104026 <allocproc>
801043f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801043fc:	75 0a                	jne    80104408 <fork+0x21>
    return -1;
801043fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104403:	e9 45 01 00 00       	jmp    8010454d <fork+0x166>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104408:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010440e:	8b 10                	mov    (%eax),%edx
80104410:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104416:	8b 40 04             	mov    0x4(%eax),%eax
80104419:	89 54 24 04          	mov    %edx,0x4(%esp)
8010441d:	89 04 24             	mov    %eax,(%esp)
80104420:	e8 b2 3b 00 00       	call   80107fd7 <copyuvm>
80104425:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104428:	89 42 04             	mov    %eax,0x4(%edx)
8010442b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010442e:	8b 40 04             	mov    0x4(%eax),%eax
80104431:	85 c0                	test   %eax,%eax
80104433:	75 2c                	jne    80104461 <fork+0x7a>
    kfree(np->kstack);
80104435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104438:	8b 40 08             	mov    0x8(%eax),%eax
8010443b:	89 04 24             	mov    %eax,(%esp)
8010443e:	e8 22 e6 ff ff       	call   80102a65 <kfree>
    np->kstack = 0;
80104443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104446:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010444d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104450:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104457:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010445c:	e9 ec 00 00 00       	jmp    8010454d <fork+0x166>
  }
  np->sz = proc->sz;
80104461:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104467:	8b 10                	mov    (%eax),%edx
80104469:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010446c:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010446e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104475:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104478:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010447b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010447e:	8b 50 18             	mov    0x18(%eax),%edx
80104481:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104487:	8b 40 18             	mov    0x18(%eax),%eax
8010448a:	89 c3                	mov    %eax,%ebx
8010448c:	b8 13 00 00 00       	mov    $0x13,%eax
80104491:	89 d7                	mov    %edx,%edi
80104493:	89 de                	mov    %ebx,%esi
80104495:	89 c1                	mov    %eax,%ecx
80104497:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010449c:	8b 40 18             	mov    0x18(%eax),%eax
8010449f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801044a6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801044ad:	eb 3d                	jmp    801044ec <fork+0x105>
    if(proc->ofile[i])
801044af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801044b8:	83 c2 08             	add    $0x8,%edx
801044bb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044bf:	85 c0                	test   %eax,%eax
801044c1:	74 25                	je     801044e8 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
801044c3:	8b 5d dc             	mov    -0x24(%ebp),%ebx
801044c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
801044cf:	83 c2 08             	add    $0x8,%edx
801044d2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044d6:	89 04 24             	mov    %eax,(%esp)
801044d9:	e8 9b ca ff ff       	call   80100f79 <filedup>
801044de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801044e1:	8d 4b 08             	lea    0x8(%ebx),%ecx
801044e4:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801044e8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
801044ec:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
801044f0:	7e bd                	jle    801044af <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801044f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044f8:	8b 40 68             	mov    0x68(%eax),%eax
801044fb:	89 04 24             	mov    %eax,(%esp)
801044fe:	e8 3a d3 ff ff       	call   8010183d <idup>
80104503:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104506:	89 42 68             	mov    %eax,0x68(%edx)

  pid = np->pid;
80104509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010450c:	8b 40 10             	mov    0x10(%eax),%eax
8010450f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  np->state = RUNNABLE;
80104512:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104515:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  ready(np);
8010451c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010451f:	89 04 24             	mov    %eax,(%esp)
80104522:	e8 a7 fc ff ff       	call   801041ce <ready>
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104527:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010452d:	8d 50 6c             	lea    0x6c(%eax),%edx
80104530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104533:	83 c0 6c             	add    $0x6c,%eax
80104536:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010453d:	00 
8010453e:	89 54 24 04          	mov    %edx,0x4(%esp)
80104542:	89 04 24             	mov    %eax,(%esp)
80104545:	e8 93 0b 00 00       	call   801050dd <safestrcpy>
  return pid;
8010454a:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
8010454d:	83 c4 2c             	add    $0x2c,%esp
80104550:	5b                   	pop    %ebx
80104551:	5e                   	pop    %esi
80104552:	5f                   	pop    %edi
80104553:	5d                   	pop    %ebp
80104554:	c3                   	ret    

80104555 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104555:	55                   	push   %ebp
80104556:	89 e5                	mov    %esp,%ebp
80104558:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
8010455b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104562:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104567:	39 c2                	cmp    %eax,%edx
80104569:	75 0c                	jne    80104577 <exit+0x22>
    panic("init exiting");
8010456b:	c7 04 24 0c 85 10 80 	movl   $0x8010850c,(%esp)
80104572:	e8 c3 bf ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104577:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010457e:	eb 44                	jmp    801045c4 <exit+0x6f>
    if(proc->ofile[fd]){
80104580:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104586:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104589:	83 c2 08             	add    $0x8,%edx
8010458c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104590:	85 c0                	test   %eax,%eax
80104592:	74 2c                	je     801045c0 <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104594:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010459a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010459d:	83 c2 08             	add    $0x8,%edx
801045a0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045a4:	89 04 24             	mov    %eax,(%esp)
801045a7:	e8 15 ca ff ff       	call   80100fc1 <fileclose>
      proc->ofile[fd] = 0;
801045ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045b5:	83 c2 08             	add    $0x8,%edx
801045b8:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801045bf:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801045c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801045c4:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801045c8:	7e b6                	jle    80104580 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
801045ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045d0:	8b 40 68             	mov    0x68(%eax),%eax
801045d3:	89 04 24             	mov    %eax,(%esp)
801045d6:	e8 4a d4 ff ff       	call   80101a25 <iput>
  proc->cwd = 0;
801045db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045e1:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  acquire(&ptable.lock);
801045e8:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801045ef:	e8 67 06 00 00       	call   80104c5b <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801045f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045fa:	8b 40 14             	mov    0x14(%eax),%eax
801045fd:	89 04 24             	mov    %eax,(%esp)
80104600:	e8 02 04 00 00       	call   80104a07 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104605:	c7 45 f0 14 00 11 80 	movl   $0x80110014,-0x10(%ebp)
8010460c:	eb 3b                	jmp    80104649 <exit+0xf4>
    if(p->parent == proc){
8010460e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104611:	8b 50 14             	mov    0x14(%eax),%edx
80104614:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010461a:	39 c2                	cmp    %eax,%edx
8010461c:	75 24                	jne    80104642 <exit+0xed>
      p->parent = initproc;
8010461e:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
80104624:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104627:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010462a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010462d:	8b 40 0c             	mov    0xc(%eax),%eax
80104630:	83 f8 05             	cmp    $0x5,%eax
80104633:	75 0d                	jne    80104642 <exit+0xed>
        wakeup1(initproc);
80104635:	a1 48 b6 10 80       	mov    0x8010b648,%eax
8010463a:	89 04 24             	mov    %eax,(%esp)
8010463d:	e8 c5 03 00 00       	call   80104a07 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104642:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104649:	b8 14 21 11 80       	mov    $0x80112114,%eax
8010464e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104651:	72 bb                	jb     8010460e <exit+0xb9>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104653:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104659:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104660:	e8 e9 01 00 00       	call   8010484e <sched>
  panic("zombie exit");
80104665:	c7 04 24 19 85 10 80 	movl   $0x80108519,(%esp)
8010466c:	e8 c9 be ff ff       	call   8010053a <panic>

80104671 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104671:	55                   	push   %ebp
80104672:	89 e5                	mov    %esp,%ebp
80104674:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104677:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
8010467e:	e8 d8 05 00 00       	call   80104c5b <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104683:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010468a:	c7 45 ec 14 00 11 80 	movl   $0x80110014,-0x14(%ebp)
80104691:	e9 9d 00 00 00       	jmp    80104733 <wait+0xc2>
      if(p->parent != proc)
80104696:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104699:	8b 50 14             	mov    0x14(%eax),%edx
8010469c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046a2:	39 c2                	cmp    %eax,%edx
801046a4:	0f 85 81 00 00 00    	jne    8010472b <wait+0xba>
        continue;
      havekids = 1;
801046aa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801046b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046b4:	8b 40 0c             	mov    0xc(%eax),%eax
801046b7:	83 f8 05             	cmp    $0x5,%eax
801046ba:	75 70                	jne    8010472c <wait+0xbb>
        // Found one.
        pid = p->pid;
801046bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046bf:	8b 40 10             	mov    0x10(%eax),%eax
801046c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kfree(p->kstack);
801046c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046c8:	8b 40 08             	mov    0x8(%eax),%eax
801046cb:	89 04 24             	mov    %eax,(%esp)
801046ce:	e8 92 e3 ff ff       	call   80102a65 <kfree>
        p->kstack = 0;
801046d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801046dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046e0:	8b 40 04             	mov    0x4(%eax),%eax
801046e3:	89 04 24             	mov    %eax,(%esp)
801046e6:	e8 18 38 00 00       	call   80107f03 <freevm>
        p->state = UNUSED;
801046eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046ee:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
801046f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046f8:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801046ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104702:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104709:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010470c:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104710:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104713:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
8010471a:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104721:	e8 96 05 00 00       	call   80104cbc <release>
        return pid;
80104726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104729:	eb 57                	jmp    80104782 <wait+0x111>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
8010472b:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010472c:	81 45 ec 84 00 00 00 	addl   $0x84,-0x14(%ebp)
80104733:	b8 14 21 11 80       	mov    $0x80112114,%eax
80104738:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010473b:	0f 82 55 ff ff ff    	jb     80104696 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104741:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104745:	74 0d                	je     80104754 <wait+0xe3>
80104747:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010474d:	8b 40 24             	mov    0x24(%eax),%eax
80104750:	85 c0                	test   %eax,%eax
80104752:	74 13                	je     80104767 <wait+0xf6>
      release(&ptable.lock);
80104754:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
8010475b:	e8 5c 05 00 00       	call   80104cbc <release>
      return -1;
80104760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104765:	eb 1b                	jmp    80104782 <wait+0x111>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104767:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010476d:	c7 44 24 04 e0 ff 10 	movl   $0x8010ffe0,0x4(%esp)
80104774:	80 
80104775:	89 04 24             	mov    %eax,(%esp)
80104778:	e8 ef 01 00 00       	call   8010496c <sleep>
  }
8010477d:	e9 01 ff ff ff       	jmp    80104683 <wait+0x12>
}
80104782:	c9                   	leave  
80104783:	c3                   	ret    

80104784 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104784:	55                   	push   %ebp
80104785:	89 e5                	mov    %esp,%ebp
80104787:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int i ;
  for(;;)
    {
      // Enable interrupts on this processor.
      sti();
8010478a:	e8 35 f8 ff ff       	call   80103fc4 <sti>

      // Loop over process table looking for process to run.
      acquire(&ptable.lock);
8010478f:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104796:	e8 c0 04 00 00       	call   80104c5b <acquire>
      for(i = 0; i < NPRIORITYS; i++)
8010479b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801047a2:	e9 8c 00 00 00       	jmp    80104833 <scheduler+0xaf>
        {
          if((p = ready_q.proc[i]))
801047a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047aa:	83 c0 0c             	add    $0xc,%eax
801047ad:	8b 04 85 24 ff 10 80 	mov    -0x7fef00dc(,%eax,4),%eax
801047b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801047b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801047bb:	74 72                	je     8010482f <scheduler+0xab>
            {
              struct proc *temp = p->next;
801047bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047c0:	8b 40 7c             	mov    0x7c(%eax),%eax
801047c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
              p->next = 0;
801047c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047c9:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
              ready_q.proc[i] = temp;
801047d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047d3:	8d 50 0c             	lea    0xc(%eax),%edx
801047d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d9:	89 04 95 24 ff 10 80 	mov    %eax,-0x7fef00dc(,%edx,4)


              //cprintf("process found with pid:%d\n", p->pid);

              proc = p;
801047e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047e3:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
              switchuvm(p);
801047e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047ec:	89 04 24             	mov    %eax,(%esp)
801047ef:	e8 97 32 00 00       	call   80107a8b <switchuvm>
              p->state = RUNNING;
801047f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047f7:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
              swtch(&cpu->scheduler, proc->context);
801047fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104804:	8b 40 1c             	mov    0x1c(%eax),%eax
80104807:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010480e:	83 c2 04             	add    $0x4,%edx
80104811:	89 44 24 04          	mov    %eax,0x4(%esp)
80104815:	89 14 24             	mov    %edx,(%esp)
80104818:	e8 33 09 00 00       	call   80105150 <swtch>
              switchkvm();
8010481d:	e8 4c 32 00 00       	call   80107a6e <switchkvm>

              // Process is done running for now.
              // It should have changed its p->state before coming back.
              proc = 0;
80104822:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104829:	00 00 00 00 

              break;
8010482d:	eb 0e                	jmp    8010483d <scheduler+0xb9>
      // Enable interrupts on this processor.
      sti();

      // Loop over process table looking for process to run.
      acquire(&ptable.lock);
      for(i = 0; i < NPRIORITYS; i++)
8010482f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104833:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
80104837:	0f 8e 6a ff ff ff    	jle    801047a7 <scheduler+0x23>

              break;
            }
        }

      release(&ptable.lock);
8010483d:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104844:	e8 73 04 00 00       	call   80104cbc <release>
    }
80104849:	e9 3c ff ff ff       	jmp    8010478a <scheduler+0x6>

8010484e <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
8010484e:	55                   	push   %ebp
8010484f:	89 e5                	mov    %esp,%ebp
80104851:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104854:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
8010485b:	e8 1a 05 00 00       	call   80104d7a <holding>
80104860:	85 c0                	test   %eax,%eax
80104862:	75 0c                	jne    80104870 <sched+0x22>
    panic("sched ptable.lock");
80104864:	c7 04 24 25 85 10 80 	movl   $0x80108525,(%esp)
8010486b:	e8 ca bc ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
80104870:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104876:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010487c:	83 f8 01             	cmp    $0x1,%eax
8010487f:	74 0c                	je     8010488d <sched+0x3f>
    panic("sched locks");
80104881:	c7 04 24 37 85 10 80 	movl   $0x80108537,(%esp)
80104888:	e8 ad bc ff ff       	call   8010053a <panic>
  if(proc->state == RUNNING)
8010488d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104893:	8b 40 0c             	mov    0xc(%eax),%eax
80104896:	83 f8 04             	cmp    $0x4,%eax
80104899:	75 0c                	jne    801048a7 <sched+0x59>
    panic("sched running");
8010489b:	c7 04 24 43 85 10 80 	movl   $0x80108543,(%esp)
801048a2:	e8 93 bc ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
801048a7:	e8 08 f7 ff ff       	call   80103fb4 <readeflags>
801048ac:	25 00 02 00 00       	and    $0x200,%eax
801048b1:	85 c0                	test   %eax,%eax
801048b3:	74 0c                	je     801048c1 <sched+0x73>
    panic("sched interruptible");
801048b5:	c7 04 24 51 85 10 80 	movl   $0x80108551,(%esp)
801048bc:	e8 79 bc ff ff       	call   8010053a <panic>
  intena = cpu->intena;
801048c1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801048c7:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801048cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
801048d0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801048d6:	8b 40 04             	mov    0x4(%eax),%eax
801048d9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048e0:	83 c2 1c             	add    $0x1c,%edx
801048e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801048e7:	89 14 24             	mov    %edx,(%esp)
801048ea:	e8 61 08 00 00       	call   80105150 <swtch>
  cpu->intena = intena;
801048ef:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801048f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048f8:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801048fe:	c9                   	leave  
801048ff:	c3                   	ret    

80104900 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	83 ec 18             	sub    $0x18,%esp

  acquire(&ptable.lock);  //DOC: yieldlock
80104906:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
8010490d:	e8 49 03 00 00       	call   80104c5b <acquire>
  ready1(proc);
80104912:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104918:	89 04 24             	mov    %eax,(%esp)
8010491b:	e8 20 f8 ff ff       	call   80104140 <ready1>
  proc->state = RUNNABLE;
80104920:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104926:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010492d:	e8 1c ff ff ff       	call   8010484e <sched>
  release(&ptable.lock);
80104932:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104939:	e8 7e 03 00 00       	call   80104cbc <release>
}
8010493e:	c9                   	leave  
8010493f:	c3                   	ret    

80104940 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	83 ec 18             	sub    $0x18,%esp
  release(&ptable.lock);
80104946:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
8010494d:	e8 6a 03 00 00       	call   80104cbc <release>
  static int first = 1;
  // Still holding ptable.lock from scheduler.

  if (first) {
80104952:	a1 20 b0 10 80       	mov    0x8010b020,%eax
80104957:	85 c0                	test   %eax,%eax
80104959:	74 0f                	je     8010496a <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
8010495b:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
80104962:	00 00 00 
    initlog();
80104965:	e8 8e e6 ff ff       	call   80102ff8 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010496a:	c9                   	leave  
8010496b:	c3                   	ret    

8010496c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
8010496c:	55                   	push   %ebp
8010496d:	89 e5                	mov    %esp,%ebp
8010496f:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104972:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104978:	85 c0                	test   %eax,%eax
8010497a:	75 0c                	jne    80104988 <sleep+0x1c>
    panic("sleep");
8010497c:	c7 04 24 65 85 10 80 	movl   $0x80108565,(%esp)
80104983:	e8 b2 bb ff ff       	call   8010053a <panic>

  if(lk == 0)
80104988:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010498c:	75 0c                	jne    8010499a <sleep+0x2e>
    panic("sleep without lk");
8010498e:	c7 04 24 6b 85 10 80 	movl   $0x8010856b,(%esp)
80104995:	e8 a0 bb ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010499a:	81 7d 0c e0 ff 10 80 	cmpl   $0x8010ffe0,0xc(%ebp)
801049a1:	74 17                	je     801049ba <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
801049a3:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801049aa:	e8 ac 02 00 00       	call   80104c5b <acquire>
    release(lk);
801049af:	8b 45 0c             	mov    0xc(%ebp),%eax
801049b2:	89 04 24             	mov    %eax,(%esp)
801049b5:	e8 02 03 00 00       	call   80104cbc <release>
  }

  // Go to sleep.
  proc->chan = chan;
801049ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c0:	8b 55 08             	mov    0x8(%ebp),%edx
801049c3:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
801049c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049cc:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801049d3:	e8 76 fe ff ff       	call   8010484e <sched>

  // Tidy up.
  proc->chan = 0;
801049d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049de:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801049e5:	81 7d 0c e0 ff 10 80 	cmpl   $0x8010ffe0,0xc(%ebp)
801049ec:	74 17                	je     80104a05 <sleep+0x99>
    release(&ptable.lock);
801049ee:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801049f5:	e8 c2 02 00 00       	call   80104cbc <release>
    acquire(lk);
801049fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801049fd:	89 04 24             	mov    %eax,(%esp)
80104a00:	e8 56 02 00 00       	call   80104c5b <acquire>
  }
}
80104a05:	c9                   	leave  
80104a06:	c3                   	ret    

80104a07 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104a07:	55                   	push   %ebp
80104a08:	89 e5                	mov    %esp,%ebp
80104a0a:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a0d:	c7 45 fc 14 00 11 80 	movl   $0x80110014,-0x4(%ebp)
80104a14:	eb 32                	jmp    80104a48 <wakeup1+0x41>
    {
      if(p->state == SLEEPING && p->chan == chan)
80104a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a19:	8b 40 0c             	mov    0xc(%eax),%eax
80104a1c:	83 f8 02             	cmp    $0x2,%eax
80104a1f:	75 20                	jne    80104a41 <wakeup1+0x3a>
80104a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a24:	8b 40 20             	mov    0x20(%eax),%eax
80104a27:	3b 45 08             	cmp    0x8(%ebp),%eax
80104a2a:	75 15                	jne    80104a41 <wakeup1+0x3a>
        {
          //cprintf("wakeup\n");
          p->state = RUNNABLE;
80104a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a2f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
          ready1(p);
80104a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a39:	89 04 24             	mov    %eax,(%esp)
80104a3c:	e8 ff f6 ff ff       	call   80104140 <ready1>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a41:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104a48:	b8 14 21 11 80       	mov    $0x80112114,%eax
80104a4d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80104a50:	72 c4                	jb     80104a16 <wakeup1+0xf>
          //cprintf("wakeup\n");
          p->state = RUNNABLE;
          ready1(p);
        }
    }
}
80104a52:	c9                   	leave  
80104a53:	c3                   	ret    

80104a54 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104a54:	55                   	push   %ebp
80104a55:	89 e5                	mov    %esp,%ebp
80104a57:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104a5a:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104a61:	e8 f5 01 00 00       	call   80104c5b <acquire>
  wakeup1(chan);
80104a66:	8b 45 08             	mov    0x8(%ebp),%eax
80104a69:	89 04 24             	mov    %eax,(%esp)
80104a6c:	e8 96 ff ff ff       	call   80104a07 <wakeup1>
  release(&ptable.lock);
80104a71:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104a78:	e8 3f 02 00 00       	call   80104cbc <release>
}
80104a7d:	c9                   	leave  
80104a7e:	c3                   	ret    

80104a7f <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104a7f:	55                   	push   %ebp
80104a80:	89 e5                	mov    %esp,%ebp
80104a82:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104a85:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104a8c:	e8 ca 01 00 00       	call   80104c5b <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a91:	c7 45 f4 14 00 11 80 	movl   $0x80110014,-0xc(%ebp)
80104a98:	eb 4f                	jmp    80104ae9 <kill+0x6a>
    if(p->pid == pid){
80104a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a9d:	8b 40 10             	mov    0x10(%eax),%eax
80104aa0:	3b 45 08             	cmp    0x8(%ebp),%eax
80104aa3:	75 3d                	jne    80104ae2 <kill+0x63>
      p->killed = 1;
80104aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab2:	8b 40 0c             	mov    0xc(%eax),%eax
80104ab5:	83 f8 02             	cmp    $0x2,%eax
80104ab8:	75 15                	jne    80104acf <kill+0x50>
        {
          p->state = RUNNABLE;
80104aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104abd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
          ready1(p);
80104ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac7:	89 04 24             	mov    %eax,(%esp)
80104aca:	e8 71 f6 ff ff       	call   80104140 <ready1>
        }
      release(&ptable.lock);
80104acf:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104ad6:	e8 e1 01 00 00       	call   80104cbc <release>
      return 0;
80104adb:	b8 00 00 00 00       	mov    $0x0,%eax
80104ae0:	eb 22                	jmp    80104b04 <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ae2:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104ae9:	b8 14 21 11 80       	mov    $0x80112114,%eax
80104aee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104af1:	72 a7                	jb     80104a9a <kill+0x1b>
        }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104af3:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104afa:	e8 bd 01 00 00       	call   80104cbc <release>
  return -1;
80104aff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b04:	c9                   	leave  
80104b05:	c3                   	ret    

80104b06 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104b06:	55                   	push   %ebp
80104b07:	89 e5                	mov    %esp,%ebp
80104b09:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b0c:	c7 45 f0 14 00 11 80 	movl   $0x80110014,-0x10(%ebp)
80104b13:	e9 db 00 00 00       	jmp    80104bf3 <procdump+0xed>
    if(p->state == UNUSED)
80104b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b1b:	8b 40 0c             	mov    0xc(%eax),%eax
80104b1e:	85 c0                	test   %eax,%eax
80104b20:	0f 84 c5 00 00 00    	je     80104beb <procdump+0xe5>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b29:	8b 40 0c             	mov    0xc(%eax),%eax
80104b2c:	83 f8 05             	cmp    $0x5,%eax
80104b2f:	77 23                	ja     80104b54 <procdump+0x4e>
80104b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b34:	8b 40 0c             	mov    0xc(%eax),%eax
80104b37:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104b3e:	85 c0                	test   %eax,%eax
80104b40:	74 12                	je     80104b54 <procdump+0x4e>
      state = states[p->state];
80104b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b45:	8b 40 0c             	mov    0xc(%eax),%eax
80104b48:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b52:	eb 07                	jmp    80104b5b <procdump+0x55>
      state = states[p->state];
    else
      state = "???";
80104b54:	c7 45 f4 7c 85 10 80 	movl   $0x8010857c,-0xc(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b5e:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b64:	8b 40 10             	mov    0x10(%eax),%eax
80104b67:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104b6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b6e:	89 54 24 08          	mov    %edx,0x8(%esp)
80104b72:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b76:	c7 04 24 80 85 10 80 	movl   $0x80108580,(%esp)
80104b7d:	e8 18 b8 ff ff       	call   8010039a <cprintf>
    if(p->state == SLEEPING){
80104b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b85:	8b 40 0c             	mov    0xc(%eax),%eax
80104b88:	83 f8 02             	cmp    $0x2,%eax
80104b8b:	75 50                	jne    80104bdd <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b90:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b93:	8b 40 0c             	mov    0xc(%eax),%eax
80104b96:	83 c0 08             	add    $0x8,%eax
80104b99:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104b9c:	89 54 24 04          	mov    %edx,0x4(%esp)
80104ba0:	89 04 24             	mov    %eax,(%esp)
80104ba3:	e8 63 01 00 00       	call   80104d0b <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104ba8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104baf:	eb 1b                	jmp    80104bcc <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bb4:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bbc:	c7 04 24 89 85 10 80 	movl   $0x80108589,(%esp)
80104bc3:	e8 d2 b7 ff ff       	call   8010039a <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104bc8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104bcc:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
80104bd0:	7f 0b                	jg     80104bdd <procdump+0xd7>
80104bd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bd5:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104bd9:	85 c0                	test   %eax,%eax
80104bdb:	75 d4                	jne    80104bb1 <procdump+0xab>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104bdd:	c7 04 24 8d 85 10 80 	movl   $0x8010858d,(%esp)
80104be4:	e8 b1 b7 ff ff       	call   8010039a <cprintf>
80104be9:	eb 01                	jmp    80104bec <procdump+0xe6>
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104beb:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bec:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104bf3:	b8 14 21 11 80       	mov    $0x80112114,%eax
80104bf8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104bfb:	0f 82 17 ff ff ff    	jb     80104b18 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104c01:	c9                   	leave  
80104c02:	c3                   	ret    
	...

80104c04 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104c04:	55                   	push   %ebp
80104c05:	89 e5                	mov    %esp,%ebp
80104c07:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c0a:	9c                   	pushf  
80104c0b:	58                   	pop    %eax
80104c0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104c0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104c12:	c9                   	leave  
80104c13:	c3                   	ret    

80104c14 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104c14:	55                   	push   %ebp
80104c15:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104c17:	fa                   	cli    
}
80104c18:	5d                   	pop    %ebp
80104c19:	c3                   	ret    

80104c1a <sti>:

static inline void
sti(void)
{
80104c1a:	55                   	push   %ebp
80104c1b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104c1d:	fb                   	sti    
}
80104c1e:	5d                   	pop    %ebp
80104c1f:	c3                   	ret    

80104c20 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104c26:	8b 55 08             	mov    0x8(%ebp),%edx
80104c29:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c2f:	f0 87 02             	lock xchg %eax,(%edx)
80104c32:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104c35:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104c38:	c9                   	leave  
80104c39:	c3                   	ret    

80104c3a <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c3a:	55                   	push   %ebp
80104c3b:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104c3d:	8b 45 08             	mov    0x8(%ebp),%eax
80104c40:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c43:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104c46:	8b 45 08             	mov    0x8(%ebp),%eax
80104c49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80104c52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c59:	5d                   	pop    %ebp
80104c5a:	c3                   	ret    

80104c5b <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104c5b:	55                   	push   %ebp
80104c5c:	89 e5                	mov    %esp,%ebp
80104c5e:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104c61:	e8 3e 01 00 00       	call   80104da4 <pushcli>
  if(holding(lk))
80104c66:	8b 45 08             	mov    0x8(%ebp),%eax
80104c69:	89 04 24             	mov    %eax,(%esp)
80104c6c:	e8 09 01 00 00       	call   80104d7a <holding>
80104c71:	85 c0                	test   %eax,%eax
80104c73:	74 0c                	je     80104c81 <acquire+0x26>
    panic("acquire");
80104c75:	c7 04 24 b9 85 10 80 	movl   $0x801085b9,(%esp)
80104c7c:	e8 b9 b8 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104c81:	8b 45 08             	mov    0x8(%ebp),%eax
80104c84:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104c8b:	00 
80104c8c:	89 04 24             	mov    %eax,(%esp)
80104c8f:	e8 8c ff ff ff       	call   80104c20 <xchg>
80104c94:	85 c0                	test   %eax,%eax
80104c96:	75 e9                	jne    80104c81 <acquire+0x26>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104c98:	8b 45 08             	mov    0x8(%ebp),%eax
80104c9b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104ca2:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104ca5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ca8:	83 c0 0c             	add    $0xc,%eax
80104cab:	89 44 24 04          	mov    %eax,0x4(%esp)
80104caf:	8d 45 08             	lea    0x8(%ebp),%eax
80104cb2:	89 04 24             	mov    %eax,(%esp)
80104cb5:	e8 51 00 00 00       	call   80104d0b <getcallerpcs>
}
80104cba:	c9                   	leave  
80104cbb:	c3                   	ret    

80104cbc <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104cbc:	55                   	push   %ebp
80104cbd:	89 e5                	mov    %esp,%ebp
80104cbf:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc5:	89 04 24             	mov    %eax,(%esp)
80104cc8:	e8 ad 00 00 00       	call   80104d7a <holding>
80104ccd:	85 c0                	test   %eax,%eax
80104ccf:	75 0c                	jne    80104cdd <release+0x21>
    panic("release");
80104cd1:	c7 04 24 c1 85 10 80 	movl   $0x801085c1,(%esp)
80104cd8:	e8 5d b8 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80104cdd:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104ce7:	8b 45 08             	mov    0x8(%ebp),%eax
80104cea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104cf1:	8b 45 08             	mov    0x8(%ebp),%eax
80104cf4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104cfb:	00 
80104cfc:	89 04 24             	mov    %eax,(%esp)
80104cff:	e8 1c ff ff ff       	call   80104c20 <xchg>

  popcli();
80104d04:	e8 e3 00 00 00       	call   80104dec <popcli>
}
80104d09:	c9                   	leave  
80104d0a:	c3                   	ret    

80104d0b <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d0b:	55                   	push   %ebp
80104d0c:	89 e5                	mov    %esp,%ebp
80104d0e:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104d11:	8b 45 08             	mov    0x8(%ebp),%eax
80104d14:	83 e8 08             	sub    $0x8,%eax
80104d17:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(i = 0; i < 10; i++){
80104d1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104d21:	eb 34                	jmp    80104d57 <getcallerpcs+0x4c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d23:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
80104d27:	74 49                	je     80104d72 <getcallerpcs+0x67>
80104d29:	81 7d f8 ff ff ff 7f 	cmpl   $0x7fffffff,-0x8(%ebp)
80104d30:	76 40                	jbe    80104d72 <getcallerpcs+0x67>
80104d32:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%ebp)
80104d36:	74 3a                	je     80104d72 <getcallerpcs+0x67>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d38:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d3b:	c1 e0 02             	shl    $0x2,%eax
80104d3e:	03 45 0c             	add    0xc(%ebp),%eax
80104d41:	8b 55 f8             	mov    -0x8(%ebp),%edx
80104d44:	83 c2 04             	add    $0x4,%edx
80104d47:	8b 12                	mov    (%edx),%edx
80104d49:	89 10                	mov    %edx,(%eax)
    ebp = (uint*)ebp[0]; // saved %ebp
80104d4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d4e:	8b 00                	mov    (%eax),%eax
80104d50:	89 45 f8             	mov    %eax,-0x8(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d53:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104d57:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
80104d5b:	7e c6                	jle    80104d23 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104d5d:	eb 13                	jmp    80104d72 <getcallerpcs+0x67>
    pcs[i] = 0;
80104d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d62:	c1 e0 02             	shl    $0x2,%eax
80104d65:	03 45 0c             	add    0xc(%ebp),%eax
80104d68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104d6e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104d72:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
80104d76:	7e e7                	jle    80104d5f <getcallerpcs+0x54>
    pcs[i] = 0;
}
80104d78:	c9                   	leave  
80104d79:	c3                   	ret    

80104d7a <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104d7a:	55                   	push   %ebp
80104d7b:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80104d80:	8b 00                	mov    (%eax),%eax
80104d82:	85 c0                	test   %eax,%eax
80104d84:	74 17                	je     80104d9d <holding+0x23>
80104d86:	8b 45 08             	mov    0x8(%ebp),%eax
80104d89:	8b 50 08             	mov    0x8(%eax),%edx
80104d8c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d92:	39 c2                	cmp    %eax,%edx
80104d94:	75 07                	jne    80104d9d <holding+0x23>
80104d96:	b8 01 00 00 00       	mov    $0x1,%eax
80104d9b:	eb 05                	jmp    80104da2 <holding+0x28>
80104d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104da2:	5d                   	pop    %ebp
80104da3:	c3                   	ret    

80104da4 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104daa:	e8 55 fe ff ff       	call   80104c04 <readeflags>
80104daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104db2:	e8 5d fe ff ff       	call   80104c14 <cli>
  if(cpu->ncli++ == 0)
80104db7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dbd:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104dc3:	85 d2                	test   %edx,%edx
80104dc5:	0f 94 c1             	sete   %cl
80104dc8:	83 c2 01             	add    $0x1,%edx
80104dcb:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104dd1:	84 c9                	test   %cl,%cl
80104dd3:	74 15                	je     80104dea <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
80104dd5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ddb:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104dde:	81 e2 00 02 00 00    	and    $0x200,%edx
80104de4:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104dea:	c9                   	leave  
80104deb:	c3                   	ret    

80104dec <popcli>:

void
popcli(void)
{
80104dec:	55                   	push   %ebp
80104ded:	89 e5                	mov    %esp,%ebp
80104def:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104df2:	e8 0d fe ff ff       	call   80104c04 <readeflags>
80104df7:	25 00 02 00 00       	and    $0x200,%eax
80104dfc:	85 c0                	test   %eax,%eax
80104dfe:	74 0c                	je     80104e0c <popcli+0x20>
    panic("popcli - interruptible");
80104e00:	c7 04 24 c9 85 10 80 	movl   $0x801085c9,(%esp)
80104e07:	e8 2e b7 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80104e0c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e12:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104e18:	83 ea 01             	sub    $0x1,%edx
80104e1b:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104e21:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e27:	85 c0                	test   %eax,%eax
80104e29:	79 0c                	jns    80104e37 <popcli+0x4b>
    panic("popcli");
80104e2b:	c7 04 24 e0 85 10 80 	movl   $0x801085e0,(%esp)
80104e32:	e8 03 b7 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104e37:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e3d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e43:	85 c0                	test   %eax,%eax
80104e45:	75 15                	jne    80104e5c <popcli+0x70>
80104e47:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e4d:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104e53:	85 c0                	test   %eax,%eax
80104e55:	74 05                	je     80104e5c <popcli+0x70>
    sti();
80104e57:	e8 be fd ff ff       	call   80104c1a <sti>
}
80104e5c:	c9                   	leave  
80104e5d:	c3                   	ret    
	...

80104e60 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	57                   	push   %edi
80104e64:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104e65:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e68:	8b 55 10             	mov    0x10(%ebp),%edx
80104e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e6e:	89 cb                	mov    %ecx,%ebx
80104e70:	89 df                	mov    %ebx,%edi
80104e72:	89 d1                	mov    %edx,%ecx
80104e74:	fc                   	cld    
80104e75:	f3 aa                	rep stos %al,%es:(%edi)
80104e77:	89 ca                	mov    %ecx,%edx
80104e79:	89 fb                	mov    %edi,%ebx
80104e7b:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104e7e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104e81:	5b                   	pop    %ebx
80104e82:	5f                   	pop    %edi
80104e83:	5d                   	pop    %ebp
80104e84:	c3                   	ret    

80104e85 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80104e85:	55                   	push   %ebp
80104e86:	89 e5                	mov    %esp,%ebp
80104e88:	57                   	push   %edi
80104e89:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104e8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e8d:	8b 55 10             	mov    0x10(%ebp),%edx
80104e90:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e93:	89 cb                	mov    %ecx,%ebx
80104e95:	89 df                	mov    %ebx,%edi
80104e97:	89 d1                	mov    %edx,%ecx
80104e99:	fc                   	cld    
80104e9a:	f3 ab                	rep stos %eax,%es:(%edi)
80104e9c:	89 ca                	mov    %ecx,%edx
80104e9e:	89 fb                	mov    %edi,%ebx
80104ea0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104ea3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104ea6:	5b                   	pop    %ebx
80104ea7:	5f                   	pop    %edi
80104ea8:	5d                   	pop    %ebp
80104ea9:	c3                   	ret    

80104eaa <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104eaa:	55                   	push   %ebp
80104eab:	89 e5                	mov    %esp,%ebp
80104ead:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80104eb0:	8b 45 08             	mov    0x8(%ebp),%eax
80104eb3:	83 e0 03             	and    $0x3,%eax
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	75 49                	jne    80104f03 <memset+0x59>
80104eba:	8b 45 10             	mov    0x10(%ebp),%eax
80104ebd:	83 e0 03             	and    $0x3,%eax
80104ec0:	85 c0                	test   %eax,%eax
80104ec2:	75 3f                	jne    80104f03 <memset+0x59>
    c &= 0xFF;
80104ec4:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104ecb:	8b 45 10             	mov    0x10(%ebp),%eax
80104ece:	c1 e8 02             	shr    $0x2,%eax
80104ed1:	89 c2                	mov    %eax,%edx
80104ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ed6:	89 c1                	mov    %eax,%ecx
80104ed8:	c1 e1 18             	shl    $0x18,%ecx
80104edb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ede:	c1 e0 10             	shl    $0x10,%eax
80104ee1:	09 c1                	or     %eax,%ecx
80104ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ee6:	c1 e0 08             	shl    $0x8,%eax
80104ee9:	09 c8                	or     %ecx,%eax
80104eeb:	0b 45 0c             	or     0xc(%ebp),%eax
80104eee:	89 54 24 08          	mov    %edx,0x8(%esp)
80104ef2:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef9:	89 04 24             	mov    %eax,(%esp)
80104efc:	e8 84 ff ff ff       	call   80104e85 <stosl>
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
80104f01:	eb 19                	jmp    80104f1c <memset+0x72>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
80104f03:	8b 45 10             	mov    0x10(%ebp),%eax
80104f06:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f11:	8b 45 08             	mov    0x8(%ebp),%eax
80104f14:	89 04 24             	mov    %eax,(%esp)
80104f17:	e8 44 ff ff ff       	call   80104e60 <stosb>
  return dst;
80104f1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104f1f:	c9                   	leave  
80104f20:	c3                   	ret    

80104f21 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f21:	55                   	push   %ebp
80104f22:	89 e5                	mov    %esp,%ebp
80104f24:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80104f27:	8b 45 08             	mov    0x8(%ebp),%eax
80104f2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  s2 = v2;
80104f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f30:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0){
80104f33:	eb 32                	jmp    80104f67 <memcmp+0x46>
    if(*s1 != *s2)
80104f35:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f38:	0f b6 10             	movzbl (%eax),%edx
80104f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f3e:	0f b6 00             	movzbl (%eax),%eax
80104f41:	38 c2                	cmp    %al,%dl
80104f43:	74 1a                	je     80104f5f <memcmp+0x3e>
      return *s1 - *s2;
80104f45:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f48:	0f b6 00             	movzbl (%eax),%eax
80104f4b:	0f b6 d0             	movzbl %al,%edx
80104f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f51:	0f b6 00             	movzbl (%eax),%eax
80104f54:	0f b6 c0             	movzbl %al,%eax
80104f57:	89 d1                	mov    %edx,%ecx
80104f59:	29 c1                	sub    %eax,%ecx
80104f5b:	89 c8                	mov    %ecx,%eax
80104f5d:	eb 1c                	jmp    80104f7b <memcmp+0x5a>
    s1++, s2++;
80104f5f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104f63:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f6b:	0f 95 c0             	setne  %al
80104f6e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104f72:	84 c0                	test   %al,%al
80104f74:	75 bf                	jne    80104f35 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104f76:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f7b:	c9                   	leave  
80104f7c:	c3                   	ret    

80104f7d <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f7d:	55                   	push   %ebp
80104f7e:	89 e5                	mov    %esp,%ebp
80104f80:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104f83:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f86:	89 45 f8             	mov    %eax,-0x8(%ebp)
  d = dst;
80104f89:	8b 45 08             	mov    0x8(%ebp),%eax
80104f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(s < d && s + n > d){
80104f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f92:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80104f95:	73 55                	jae    80104fec <memmove+0x6f>
80104f97:	8b 45 10             	mov    0x10(%ebp),%eax
80104f9a:	8b 55 f8             	mov    -0x8(%ebp),%edx
80104f9d:	8d 04 02             	lea    (%edx,%eax,1),%eax
80104fa0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80104fa3:	76 4a                	jbe    80104fef <memmove+0x72>
    s += n;
80104fa5:	8b 45 10             	mov    0x10(%ebp),%eax
80104fa8:	01 45 f8             	add    %eax,-0x8(%ebp)
    d += n;
80104fab:	8b 45 10             	mov    0x10(%ebp),%eax
80104fae:	01 45 fc             	add    %eax,-0x4(%ebp)
    while(n-- > 0)
80104fb1:	eb 13                	jmp    80104fc6 <memmove+0x49>
      *--d = *--s;
80104fb3:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104fb7:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104fbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fbe:	0f b6 10             	movzbl (%eax),%edx
80104fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fc4:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104fc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fca:	0f 95 c0             	setne  %al
80104fcd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104fd1:	84 c0                	test   %al,%al
80104fd3:	75 de                	jne    80104fb3 <memmove+0x36>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104fd5:	eb 28                	jmp    80104fff <memmove+0x82>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80104fd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fda:	0f b6 10             	movzbl (%eax),%edx
80104fdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fe0:	88 10                	mov    %dl,(%eax)
80104fe2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104fe6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104fea:	eb 04                	jmp    80104ff0 <memmove+0x73>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104fec:	90                   	nop
80104fed:	eb 01                	jmp    80104ff0 <memmove+0x73>
80104fef:	90                   	nop
80104ff0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ff4:	0f 95 c0             	setne  %al
80104ff7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104ffb:	84 c0                	test   %al,%al
80104ffd:	75 d8                	jne    80104fd7 <memmove+0x5a>
      *d++ = *s++;

  return dst;
80104fff:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105002:	c9                   	leave  
80105003:	c3                   	ret    

80105004 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105004:	55                   	push   %ebp
80105005:	89 e5                	mov    %esp,%ebp
80105007:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
8010500a:	8b 45 10             	mov    0x10(%ebp),%eax
8010500d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105011:	8b 45 0c             	mov    0xc(%ebp),%eax
80105014:	89 44 24 04          	mov    %eax,0x4(%esp)
80105018:	8b 45 08             	mov    0x8(%ebp),%eax
8010501b:	89 04 24             	mov    %eax,(%esp)
8010501e:	e8 5a ff ff ff       	call   80104f7d <memmove>
}
80105023:	c9                   	leave  
80105024:	c3                   	ret    

80105025 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105025:	55                   	push   %ebp
80105026:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105028:	eb 0c                	jmp    80105036 <strncmp+0x11>
    n--, p++, q++;
8010502a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010502e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105032:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105036:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010503a:	74 1a                	je     80105056 <strncmp+0x31>
8010503c:	8b 45 08             	mov    0x8(%ebp),%eax
8010503f:	0f b6 00             	movzbl (%eax),%eax
80105042:	84 c0                	test   %al,%al
80105044:	74 10                	je     80105056 <strncmp+0x31>
80105046:	8b 45 08             	mov    0x8(%ebp),%eax
80105049:	0f b6 10             	movzbl (%eax),%edx
8010504c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010504f:	0f b6 00             	movzbl (%eax),%eax
80105052:	38 c2                	cmp    %al,%dl
80105054:	74 d4                	je     8010502a <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105056:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010505a:	75 07                	jne    80105063 <strncmp+0x3e>
    return 0;
8010505c:	b8 00 00 00 00       	mov    $0x0,%eax
80105061:	eb 18                	jmp    8010507b <strncmp+0x56>
  return (uchar)*p - (uchar)*q;
80105063:	8b 45 08             	mov    0x8(%ebp),%eax
80105066:	0f b6 00             	movzbl (%eax),%eax
80105069:	0f b6 d0             	movzbl %al,%edx
8010506c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010506f:	0f b6 00             	movzbl (%eax),%eax
80105072:	0f b6 c0             	movzbl %al,%eax
80105075:	89 d1                	mov    %edx,%ecx
80105077:	29 c1                	sub    %eax,%ecx
80105079:	89 c8                	mov    %ecx,%eax
}
8010507b:	5d                   	pop    %ebp
8010507c:	c3                   	ret    

8010507d <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010507d:	55                   	push   %ebp
8010507e:	89 e5                	mov    %esp,%ebp
80105080:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105083:	8b 45 08             	mov    0x8(%ebp),%eax
80105086:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105089:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010508d:	0f 9f c0             	setg   %al
80105090:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105094:	84 c0                	test   %al,%al
80105096:	74 30                	je     801050c8 <strncpy+0x4b>
80105098:	8b 45 0c             	mov    0xc(%ebp),%eax
8010509b:	0f b6 10             	movzbl (%eax),%edx
8010509e:	8b 45 08             	mov    0x8(%ebp),%eax
801050a1:	88 10                	mov    %dl,(%eax)
801050a3:	8b 45 08             	mov    0x8(%ebp),%eax
801050a6:	0f b6 00             	movzbl (%eax),%eax
801050a9:	84 c0                	test   %al,%al
801050ab:	0f 95 c0             	setne  %al
801050ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801050b2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801050b6:	84 c0                	test   %al,%al
801050b8:	75 cf                	jne    80105089 <strncpy+0xc>
    ;
  while(n-- > 0)
801050ba:	eb 0d                	jmp    801050c9 <strncpy+0x4c>
    *s++ = 0;
801050bc:	8b 45 08             	mov    0x8(%ebp),%eax
801050bf:	c6 00 00             	movb   $0x0,(%eax)
801050c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801050c6:	eb 01                	jmp    801050c9 <strncpy+0x4c>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801050c8:	90                   	nop
801050c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050cd:	0f 9f c0             	setg   %al
801050d0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801050d4:	84 c0                	test   %al,%al
801050d6:	75 e4                	jne    801050bc <strncpy+0x3f>
    *s++ = 0;
  return os;
801050d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050db:	c9                   	leave  
801050dc:	c3                   	ret    

801050dd <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801050dd:	55                   	push   %ebp
801050de:	89 e5                	mov    %esp,%ebp
801050e0:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801050e3:	8b 45 08             	mov    0x8(%ebp),%eax
801050e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801050e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050ed:	7f 05                	jg     801050f4 <safestrcpy+0x17>
    return os;
801050ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050f2:	eb 35                	jmp    80105129 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
801050f4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801050f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050fc:	7e 22                	jle    80105120 <safestrcpy+0x43>
801050fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105101:	0f b6 10             	movzbl (%eax),%edx
80105104:	8b 45 08             	mov    0x8(%ebp),%eax
80105107:	88 10                	mov    %dl,(%eax)
80105109:	8b 45 08             	mov    0x8(%ebp),%eax
8010510c:	0f b6 00             	movzbl (%eax),%eax
8010510f:	84 c0                	test   %al,%al
80105111:	0f 95 c0             	setne  %al
80105114:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105118:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010511c:	84 c0                	test   %al,%al
8010511e:	75 d4                	jne    801050f4 <safestrcpy+0x17>
    ;
  *s = 0;
80105120:	8b 45 08             	mov    0x8(%ebp),%eax
80105123:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105126:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105129:	c9                   	leave  
8010512a:	c3                   	ret    

8010512b <strlen>:

int
strlen(const char *s)
{
8010512b:	55                   	push   %ebp
8010512c:	89 e5                	mov    %esp,%ebp
8010512e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105131:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105138:	eb 04                	jmp    8010513e <strlen+0x13>
8010513a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010513e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105141:	03 45 08             	add    0x8(%ebp),%eax
80105144:	0f b6 00             	movzbl (%eax),%eax
80105147:	84 c0                	test   %al,%al
80105149:	75 ef                	jne    8010513a <strlen+0xf>
    ;
  return n;
8010514b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010514e:	c9                   	leave  
8010514f:	c3                   	ret    

80105150 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105150:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105154:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105158:	55                   	push   %ebp
  pushl %ebx
80105159:	53                   	push   %ebx
  pushl %esi
8010515a:	56                   	push   %esi
  pushl %edi
8010515b:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010515c:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010515e:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105160:	5f                   	pop    %edi
  popl %esi
80105161:	5e                   	pop    %esi
  popl %ebx
80105162:	5b                   	pop    %ebx
  popl %ebp
80105163:	5d                   	pop    %ebp
  ret
80105164:	c3                   	ret    
80105165:	00 00                	add    %al,(%eax)
	...

80105168 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105168:	55                   	push   %ebp
80105169:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010516b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105171:	8b 00                	mov    (%eax),%eax
80105173:	3b 45 08             	cmp    0x8(%ebp),%eax
80105176:	76 12                	jbe    8010518a <fetchint+0x22>
80105178:	8b 45 08             	mov    0x8(%ebp),%eax
8010517b:	8d 50 04             	lea    0x4(%eax),%edx
8010517e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105184:	8b 00                	mov    (%eax),%eax
80105186:	39 c2                	cmp    %eax,%edx
80105188:	76 07                	jbe    80105191 <fetchint+0x29>
    return -1;
8010518a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010518f:	eb 0f                	jmp    801051a0 <fetchint+0x38>
  *ip = *(int*)(addr);
80105191:	8b 45 08             	mov    0x8(%ebp),%eax
80105194:	8b 10                	mov    (%eax),%edx
80105196:	8b 45 0c             	mov    0xc(%ebp),%eax
80105199:	89 10                	mov    %edx,(%eax)
  return 0;
8010519b:	b8 00 00 00 00       	mov    $0x0,%eax
}
801051a0:	5d                   	pop    %ebp
801051a1:	c3                   	ret    

801051a2 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801051a2:	55                   	push   %ebp
801051a3:	89 e5                	mov    %esp,%ebp
801051a5:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801051a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051ae:	8b 00                	mov    (%eax),%eax
801051b0:	3b 45 08             	cmp    0x8(%ebp),%eax
801051b3:	77 07                	ja     801051bc <fetchstr+0x1a>
    return -1;
801051b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ba:	eb 48                	jmp    80105204 <fetchstr+0x62>
  *pp = (char*)addr;
801051bc:	8b 55 08             	mov    0x8(%ebp),%edx
801051bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801051c2:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801051c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051ca:	8b 00                	mov    (%eax),%eax
801051cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(s = *pp; s < ep; s++)
801051cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801051d2:	8b 00                	mov    (%eax),%eax
801051d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
801051d7:	eb 1e                	jmp    801051f7 <fetchstr+0x55>
    if(*s == 0)
801051d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051dc:	0f b6 00             	movzbl (%eax),%eax
801051df:	84 c0                	test   %al,%al
801051e1:	75 10                	jne    801051f3 <fetchstr+0x51>
      return s - *pp;
801051e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
801051e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801051e9:	8b 00                	mov    (%eax),%eax
801051eb:	89 d1                	mov    %edx,%ecx
801051ed:	29 c1                	sub    %eax,%ecx
801051ef:	89 c8                	mov    %ecx,%eax
801051f1:	eb 11                	jmp    80105204 <fetchstr+0x62>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801051f3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801051f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
801051fd:	72 da                	jb     801051d9 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801051ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105204:	c9                   	leave  
80105205:	c3                   	ret    

80105206 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105206:	55                   	push   %ebp
80105207:	89 e5                	mov    %esp,%ebp
80105209:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010520c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105212:	8b 40 18             	mov    0x18(%eax),%eax
80105215:	8b 50 44             	mov    0x44(%eax),%edx
80105218:	8b 45 08             	mov    0x8(%ebp),%eax
8010521b:	c1 e0 02             	shl    $0x2,%eax
8010521e:	8d 04 02             	lea    (%edx,%eax,1),%eax
80105221:	8d 50 04             	lea    0x4(%eax),%edx
80105224:	8b 45 0c             	mov    0xc(%ebp),%eax
80105227:	89 44 24 04          	mov    %eax,0x4(%esp)
8010522b:	89 14 24             	mov    %edx,(%esp)
8010522e:	e8 35 ff ff ff       	call   80105168 <fetchint>
}
80105233:	c9                   	leave  
80105234:	c3                   	ret    

80105235 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105235:	55                   	push   %ebp
80105236:	89 e5                	mov    %esp,%ebp
80105238:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
8010523b:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010523e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105242:	8b 45 08             	mov    0x8(%ebp),%eax
80105245:	89 04 24             	mov    %eax,(%esp)
80105248:	e8 b9 ff ff ff       	call   80105206 <argint>
8010524d:	85 c0                	test   %eax,%eax
8010524f:	79 07                	jns    80105258 <argptr+0x23>
    return -1;
80105251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105256:	eb 3d                	jmp    80105295 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105258:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010525b:	89 c2                	mov    %eax,%edx
8010525d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105263:	8b 00                	mov    (%eax),%eax
80105265:	39 c2                	cmp    %eax,%edx
80105267:	73 16                	jae    8010527f <argptr+0x4a>
80105269:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010526c:	89 c2                	mov    %eax,%edx
8010526e:	8b 45 10             	mov    0x10(%ebp),%eax
80105271:	01 c2                	add    %eax,%edx
80105273:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105279:	8b 00                	mov    (%eax),%eax
8010527b:	39 c2                	cmp    %eax,%edx
8010527d:	76 07                	jbe    80105286 <argptr+0x51>
    return -1;
8010527f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105284:	eb 0f                	jmp    80105295 <argptr+0x60>
  *pp = (char*)i;
80105286:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105289:	89 c2                	mov    %eax,%edx
8010528b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010528e:	89 10                	mov    %edx,(%eax)
  return 0;
80105290:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105295:	c9                   	leave  
80105296:	c3                   	ret    

80105297 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105297:	55                   	push   %ebp
80105298:	89 e5                	mov    %esp,%ebp
8010529a:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010529d:	8d 45 fc             	lea    -0x4(%ebp),%eax
801052a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801052a4:	8b 45 08             	mov    0x8(%ebp),%eax
801052a7:	89 04 24             	mov    %eax,(%esp)
801052aa:	e8 57 ff ff ff       	call   80105206 <argint>
801052af:	85 c0                	test   %eax,%eax
801052b1:	79 07                	jns    801052ba <argstr+0x23>
    return -1;
801052b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b8:	eb 12                	jmp    801052cc <argstr+0x35>
  return fetchstr(addr, pp);
801052ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052bd:	8b 55 0c             	mov    0xc(%ebp),%edx
801052c0:	89 54 24 04          	mov    %edx,0x4(%esp)
801052c4:	89 04 24             	mov    %eax,(%esp)
801052c7:	e8 d6 fe ff ff       	call   801051a2 <fetchstr>
}
801052cc:	c9                   	leave  
801052cd:	c3                   	ret    

801052ce <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801052ce:	55                   	push   %ebp
801052cf:	89 e5                	mov    %esp,%ebp
801052d1:	53                   	push   %ebx
801052d2:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
801052d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052db:	8b 40 18             	mov    0x18(%eax),%eax
801052de:	8b 40 1c             	mov    0x1c(%eax),%eax
801052e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801052e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801052e8:	7e 30                	jle    8010531a <syscall+0x4c>
801052ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ed:	83 f8 15             	cmp    $0x15,%eax
801052f0:	77 28                	ja     8010531a <syscall+0x4c>
801052f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052f5:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801052fc:	85 c0                	test   %eax,%eax
801052fe:	74 1a                	je     8010531a <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105300:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105306:	8b 58 18             	mov    0x18(%eax),%ebx
80105309:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010530c:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105313:	ff d0                	call   *%eax
80105315:	89 43 1c             	mov    %eax,0x1c(%ebx)
syscall(void)
{
  int num;

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105318:	eb 3d                	jmp    80105357 <syscall+0x89>
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
8010531a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105320:	8d 48 6c             	lea    0x6c(%eax),%ecx
            proc->pid, proc->name, num);
80105323:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105329:	8b 40 10             	mov    0x10(%eax),%eax
8010532c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010532f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105333:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105337:	89 44 24 04          	mov    %eax,0x4(%esp)
8010533b:	c7 04 24 e7 85 10 80 	movl   $0x801085e7,(%esp)
80105342:	e8 53 b0 ff ff       	call   8010039a <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105347:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010534d:	8b 40 18             	mov    0x18(%eax),%eax
80105350:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105357:	83 c4 24             	add    $0x24,%esp
8010535a:	5b                   	pop    %ebx
8010535b:	5d                   	pop    %ebp
8010535c:	c3                   	ret    
8010535d:	00 00                	add    %al,(%eax)
	...

80105360 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105366:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105369:	89 44 24 04          	mov    %eax,0x4(%esp)
8010536d:	8b 45 08             	mov    0x8(%ebp),%eax
80105370:	89 04 24             	mov    %eax,(%esp)
80105373:	e8 8e fe ff ff       	call   80105206 <argint>
80105378:	85 c0                	test   %eax,%eax
8010537a:	79 07                	jns    80105383 <argfd+0x23>
    return -1;
8010537c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105381:	eb 50                	jmp    801053d3 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105383:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105386:	85 c0                	test   %eax,%eax
80105388:	78 21                	js     801053ab <argfd+0x4b>
8010538a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010538d:	83 f8 0f             	cmp    $0xf,%eax
80105390:	7f 19                	jg     801053ab <argfd+0x4b>
80105392:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105398:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010539b:	83 c2 08             	add    $0x8,%edx
8010539e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801053a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801053a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801053a9:	75 07                	jne    801053b2 <argfd+0x52>
    return -1;
801053ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b0:	eb 21                	jmp    801053d3 <argfd+0x73>
  if(pfd)
801053b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801053b6:	74 08                	je     801053c0 <argfd+0x60>
    *pfd = fd;
801053b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801053bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801053be:	89 10                	mov    %edx,(%eax)
  if(pf)
801053c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053c4:	74 08                	je     801053ce <argfd+0x6e>
    *pf = f;
801053c6:	8b 45 10             	mov    0x10(%ebp),%eax
801053c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053cc:	89 10                	mov    %edx,(%eax)
  return 0;
801053ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053d3:	c9                   	leave  
801053d4:	c3                   	ret    

801053d5 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801053d5:	55                   	push   %ebp
801053d6:	89 e5                	mov    %esp,%ebp
801053d8:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801053db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801053e2:	eb 30                	jmp    80105414 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801053e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
801053ed:	83 c2 08             	add    $0x8,%edx
801053f0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801053f4:	85 c0                	test   %eax,%eax
801053f6:	75 18                	jne    80105410 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801053f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105401:	8d 4a 08             	lea    0x8(%edx),%ecx
80105404:	8b 55 08             	mov    0x8(%ebp),%edx
80105407:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010540b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010540e:	eb 0f                	jmp    8010541f <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105410:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105414:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105418:	7e ca                	jle    801053e4 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010541a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010541f:	c9                   	leave  
80105420:	c3                   	ret    

80105421 <sys_dup>:

int
sys_dup(void)
{
80105421:	55                   	push   %ebp
80105422:	89 e5                	mov    %esp,%ebp
80105424:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105427:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010542a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010542e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105435:	00 
80105436:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010543d:	e8 1e ff ff ff       	call   80105360 <argfd>
80105442:	85 c0                	test   %eax,%eax
80105444:	79 07                	jns    8010544d <sys_dup+0x2c>
    return -1;
80105446:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010544b:	eb 29                	jmp    80105476 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010544d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105450:	89 04 24             	mov    %eax,(%esp)
80105453:	e8 7d ff ff ff       	call   801053d5 <fdalloc>
80105458:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010545b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010545f:	79 07                	jns    80105468 <sys_dup+0x47>
    return -1;
80105461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105466:	eb 0e                	jmp    80105476 <sys_dup+0x55>
  filedup(f);
80105468:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010546b:	89 04 24             	mov    %eax,(%esp)
8010546e:	e8 06 bb ff ff       	call   80100f79 <filedup>
  return fd;
80105473:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105476:	c9                   	leave  
80105477:	c3                   	ret    

80105478 <sys_read>:

int
sys_read(void)
{
80105478:	55                   	push   %ebp
80105479:	89 e5                	mov    %esp,%ebp
8010547b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010547e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105481:	89 44 24 08          	mov    %eax,0x8(%esp)
80105485:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010548c:	00 
8010548d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105494:	e8 c7 fe ff ff       	call   80105360 <argfd>
80105499:	85 c0                	test   %eax,%eax
8010549b:	78 35                	js     801054d2 <sys_read+0x5a>
8010549d:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801054a4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801054ab:	e8 56 fd ff ff       	call   80105206 <argint>
801054b0:	85 c0                	test   %eax,%eax
801054b2:	78 1e                	js     801054d2 <sys_read+0x5a>
801054b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054b7:	89 44 24 08          	mov    %eax,0x8(%esp)
801054bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054be:	89 44 24 04          	mov    %eax,0x4(%esp)
801054c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801054c9:	e8 67 fd ff ff       	call   80105235 <argptr>
801054ce:	85 c0                	test   %eax,%eax
801054d0:	79 07                	jns    801054d9 <sys_read+0x61>
    return -1;
801054d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d7:	eb 19                	jmp    801054f2 <sys_read+0x7a>
  return fileread(f, p, n);
801054d9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801054dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
801054df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801054e6:	89 54 24 04          	mov    %edx,0x4(%esp)
801054ea:	89 04 24             	mov    %eax,(%esp)
801054ed:	e8 f4 bb ff ff       	call   801010e6 <fileread>
}
801054f2:	c9                   	leave  
801054f3:	c3                   	ret    

801054f4 <sys_write>:

int
sys_write(void)
{
801054f4:	55                   	push   %ebp
801054f5:	89 e5                	mov    %esp,%ebp
801054f7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054fd:	89 44 24 08          	mov    %eax,0x8(%esp)
80105501:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105508:	00 
80105509:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105510:	e8 4b fe ff ff       	call   80105360 <argfd>
80105515:	85 c0                	test   %eax,%eax
80105517:	78 35                	js     8010554e <sys_write+0x5a>
80105519:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010551c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105520:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105527:	e8 da fc ff ff       	call   80105206 <argint>
8010552c:	85 c0                	test   %eax,%eax
8010552e:	78 1e                	js     8010554e <sys_write+0x5a>
80105530:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105533:	89 44 24 08          	mov    %eax,0x8(%esp)
80105537:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010553a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010553e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105545:	e8 eb fc ff ff       	call   80105235 <argptr>
8010554a:	85 c0                	test   %eax,%eax
8010554c:	79 07                	jns    80105555 <sys_write+0x61>
    return -1;
8010554e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105553:	eb 19                	jmp    8010556e <sys_write+0x7a>
  return filewrite(f, p, n);
80105555:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105558:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010555b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010555e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105562:	89 54 24 04          	mov    %edx,0x4(%esp)
80105566:	89 04 24             	mov    %eax,(%esp)
80105569:	e8 34 bc ff ff       	call   801011a2 <filewrite>
}
8010556e:	c9                   	leave  
8010556f:	c3                   	ret    

80105570 <sys_close>:

int
sys_close(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105576:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105579:	89 44 24 08          	mov    %eax,0x8(%esp)
8010557d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105580:	89 44 24 04          	mov    %eax,0x4(%esp)
80105584:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010558b:	e8 d0 fd ff ff       	call   80105360 <argfd>
80105590:	85 c0                	test   %eax,%eax
80105592:	79 07                	jns    8010559b <sys_close+0x2b>
    return -1;
80105594:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105599:	eb 24                	jmp    801055bf <sys_close+0x4f>
  proc->ofile[fd] = 0;
8010559b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055a4:	83 c2 08             	add    $0x8,%edx
801055a7:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801055ae:	00 
  fileclose(f);
801055af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055b2:	89 04 24             	mov    %eax,(%esp)
801055b5:	e8 07 ba ff ff       	call   80100fc1 <fileclose>
  return 0;
801055ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055bf:	c9                   	leave  
801055c0:	c3                   	ret    

801055c1 <sys_fstat>:

int
sys_fstat(void)
{
801055c1:	55                   	push   %ebp
801055c2:	89 e5                	mov    %esp,%ebp
801055c4:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801055c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ca:	89 44 24 08          	mov    %eax,0x8(%esp)
801055ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801055d5:	00 
801055d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055dd:	e8 7e fd ff ff       	call   80105360 <argfd>
801055e2:	85 c0                	test   %eax,%eax
801055e4:	78 1f                	js     80105605 <sys_fstat+0x44>
801055e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055e9:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801055f0:	00 
801055f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801055f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801055fc:	e8 34 fc ff ff       	call   80105235 <argptr>
80105601:	85 c0                	test   %eax,%eax
80105603:	79 07                	jns    8010560c <sys_fstat+0x4b>
    return -1;
80105605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010560a:	eb 12                	jmp    8010561e <sys_fstat+0x5d>
  return filestat(f, st);
8010560c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010560f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105612:	89 54 24 04          	mov    %edx,0x4(%esp)
80105616:	89 04 24             	mov    %eax,(%esp)
80105619:	e8 79 ba ff ff       	call   80101097 <filestat>
}
8010561e:	c9                   	leave  
8010561f:	c3                   	ret    

80105620 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105626:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105629:	89 44 24 04          	mov    %eax,0x4(%esp)
8010562d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105634:	e8 5e fc ff ff       	call   80105297 <argstr>
80105639:	85 c0                	test   %eax,%eax
8010563b:	78 17                	js     80105654 <sys_link+0x34>
8010563d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105640:	89 44 24 04          	mov    %eax,0x4(%esp)
80105644:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010564b:	e8 47 fc ff ff       	call   80105297 <argstr>
80105650:	85 c0                	test   %eax,%eax
80105652:	79 0a                	jns    8010565e <sys_link+0x3e>
    return -1;
80105654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105659:	e9 3c 01 00 00       	jmp    8010579a <sys_link+0x17a>
  if((ip = namei(old)) == 0)
8010565e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105661:	89 04 24             	mov    %eax,(%esp)
80105664:	e8 ae cd ff ff       	call   80102417 <namei>
80105669:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010566c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105670:	75 0a                	jne    8010567c <sys_link+0x5c>
    return -1;
80105672:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105677:	e9 1e 01 00 00       	jmp    8010579a <sys_link+0x17a>

  begin_trans();
8010567c:	e8 85 db ff ff       	call   80103206 <begin_trans>

  ilock(ip);
80105681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105684:	89 04 24             	mov    %eax,(%esp)
80105687:	e8 e3 c1 ff ff       	call   8010186f <ilock>
  if(ip->type == T_DIR){
8010568c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010568f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105693:	66 83 f8 01          	cmp    $0x1,%ax
80105697:	75 1a                	jne    801056b3 <sys_link+0x93>
    iunlockput(ip);
80105699:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010569c:	89 04 24             	mov    %eax,(%esp)
8010569f:	e8 52 c4 ff ff       	call   80101af6 <iunlockput>
    commit_trans();
801056a4:	e8 a6 db ff ff       	call   8010324f <commit_trans>
    return -1;
801056a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ae:	e9 e7 00 00 00       	jmp    8010579a <sys_link+0x17a>
  }

  ip->nlink++;
801056b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056b6:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801056ba:	8d 50 01             	lea    0x1(%eax),%edx
801056bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056c0:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801056c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056c7:	89 04 24             	mov    %eax,(%esp)
801056ca:	e8 e0 bf ff ff       	call   801016af <iupdate>
  iunlock(ip);
801056cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056d2:	89 04 24             	mov    %eax,(%esp)
801056d5:	e8 e6 c2 ff ff       	call   801019c0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801056da:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056dd:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801056e0:	89 54 24 04          	mov    %edx,0x4(%esp)
801056e4:	89 04 24             	mov    %eax,(%esp)
801056e7:	e8 4d cd ff ff       	call   80102439 <nameiparent>
801056ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
801056ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801056f3:	74 68                	je     8010575d <sys_link+0x13d>
    goto bad;
  ilock(dp);
801056f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f8:	89 04 24             	mov    %eax,(%esp)
801056fb:	e8 6f c1 ff ff       	call   8010186f <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105700:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105703:	8b 10                	mov    (%eax),%edx
80105705:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105708:	8b 00                	mov    (%eax),%eax
8010570a:	39 c2                	cmp    %eax,%edx
8010570c:	75 20                	jne    8010572e <sys_link+0x10e>
8010570e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105711:	8b 40 04             	mov    0x4(%eax),%eax
80105714:	89 44 24 08          	mov    %eax,0x8(%esp)
80105718:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010571b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010571f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105722:	89 04 24             	mov    %eax,(%esp)
80105725:	e8 2c ca ff ff       	call   80102156 <dirlink>
8010572a:	85 c0                	test   %eax,%eax
8010572c:	79 0d                	jns    8010573b <sys_link+0x11b>
    iunlockput(dp);
8010572e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105731:	89 04 24             	mov    %eax,(%esp)
80105734:	e8 bd c3 ff ff       	call   80101af6 <iunlockput>
    goto bad;
80105739:	eb 23                	jmp    8010575e <sys_link+0x13e>
  }
  iunlockput(dp);
8010573b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010573e:	89 04 24             	mov    %eax,(%esp)
80105741:	e8 b0 c3 ff ff       	call   80101af6 <iunlockput>
  iput(ip);
80105746:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105749:	89 04 24             	mov    %eax,(%esp)
8010574c:	e8 d4 c2 ff ff       	call   80101a25 <iput>

  commit_trans();
80105751:	e8 f9 da ff ff       	call   8010324f <commit_trans>

  return 0;
80105756:	b8 00 00 00 00       	mov    $0x0,%eax
8010575b:	eb 3d                	jmp    8010579a <sys_link+0x17a>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
8010575d:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
8010575e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105761:	89 04 24             	mov    %eax,(%esp)
80105764:	e8 06 c1 ff ff       	call   8010186f <ilock>
  ip->nlink--;
80105769:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010576c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105770:	8d 50 ff             	lea    -0x1(%eax),%edx
80105773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105776:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010577a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010577d:	89 04 24             	mov    %eax,(%esp)
80105780:	e8 2a bf ff ff       	call   801016af <iupdate>
  iunlockput(ip);
80105785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105788:	89 04 24             	mov    %eax,(%esp)
8010578b:	e8 66 c3 ff ff       	call   80101af6 <iunlockput>
  commit_trans();
80105790:	e8 ba da ff ff       	call   8010324f <commit_trans>
  return -1;
80105795:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010579a:	c9                   	leave  
8010579b:	c3                   	ret    

8010579c <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010579c:	55                   	push   %ebp
8010579d:	89 e5                	mov    %esp,%ebp
8010579f:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057a2:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801057a9:	eb 4b                	jmp    801057f6 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057ae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057b1:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801057b8:	00 
801057b9:	89 54 24 08          	mov    %edx,0x8(%esp)
801057bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801057c1:	8b 45 08             	mov    0x8(%ebp),%eax
801057c4:	89 04 24             	mov    %eax,(%esp)
801057c7:	e8 9c c5 ff ff       	call   80101d68 <readi>
801057cc:	83 f8 10             	cmp    $0x10,%eax
801057cf:	74 0c                	je     801057dd <isdirempty+0x41>
      panic("isdirempty: readi");
801057d1:	c7 04 24 03 86 10 80 	movl   $0x80108603,(%esp)
801057d8:	e8 5d ad ff ff       	call   8010053a <panic>
    if(de.inum != 0)
801057dd:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801057e1:	66 85 c0             	test   %ax,%ax
801057e4:	74 07                	je     801057ed <isdirempty+0x51>
      return 0;
801057e6:	b8 00 00 00 00       	mov    $0x0,%eax
801057eb:	eb 1b                	jmp    80105808 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f0:	83 c0 10             	add    $0x10,%eax
801057f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057f9:	8b 45 08             	mov    0x8(%ebp),%eax
801057fc:	8b 40 18             	mov    0x18(%eax),%eax
801057ff:	39 c2                	cmp    %eax,%edx
80105801:	72 a8                	jb     801057ab <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105803:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105808:	c9                   	leave  
80105809:	c3                   	ret    

8010580a <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010580a:	55                   	push   %ebp
8010580b:	89 e5                	mov    %esp,%ebp
8010580d:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105810:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105813:	89 44 24 04          	mov    %eax,0x4(%esp)
80105817:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010581e:	e8 74 fa ff ff       	call   80105297 <argstr>
80105823:	85 c0                	test   %eax,%eax
80105825:	79 0a                	jns    80105831 <sys_unlink+0x27>
    return -1;
80105827:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010582c:	e9 aa 01 00 00       	jmp    801059db <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80105831:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105834:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105837:	89 54 24 04          	mov    %edx,0x4(%esp)
8010583b:	89 04 24             	mov    %eax,(%esp)
8010583e:	e8 f6 cb ff ff       	call   80102439 <nameiparent>
80105843:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105846:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010584a:	75 0a                	jne    80105856 <sys_unlink+0x4c>
    return -1;
8010584c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105851:	e9 85 01 00 00       	jmp    801059db <sys_unlink+0x1d1>

  begin_trans();
80105856:	e8 ab d9 ff ff       	call   80103206 <begin_trans>

  ilock(dp);
8010585b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585e:	89 04 24             	mov    %eax,(%esp)
80105861:	e8 09 c0 ff ff       	call   8010186f <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105866:	c7 44 24 04 15 86 10 	movl   $0x80108615,0x4(%esp)
8010586d:	80 
8010586e:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105871:	89 04 24             	mov    %eax,(%esp)
80105874:	e8 f3 c7 ff ff       	call   8010206c <namecmp>
80105879:	85 c0                	test   %eax,%eax
8010587b:	0f 84 45 01 00 00    	je     801059c6 <sys_unlink+0x1bc>
80105881:	c7 44 24 04 17 86 10 	movl   $0x80108617,0x4(%esp)
80105888:	80 
80105889:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010588c:	89 04 24             	mov    %eax,(%esp)
8010588f:	e8 d8 c7 ff ff       	call   8010206c <namecmp>
80105894:	85 c0                	test   %eax,%eax
80105896:	0f 84 2a 01 00 00    	je     801059c6 <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010589c:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010589f:	89 44 24 08          	mov    %eax,0x8(%esp)
801058a3:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801058a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801058aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ad:	89 04 24             	mov    %eax,(%esp)
801058b0:	e8 d9 c7 ff ff       	call   8010208e <dirlookup>
801058b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801058b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058bc:	0f 84 03 01 00 00    	je     801059c5 <sys_unlink+0x1bb>
    goto bad;
  ilock(ip);
801058c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058c5:	89 04 24             	mov    %eax,(%esp)
801058c8:	e8 a2 bf ff ff       	call   8010186f <ilock>

  if(ip->nlink < 1)
801058cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058d0:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801058d4:	66 85 c0             	test   %ax,%ax
801058d7:	7f 0c                	jg     801058e5 <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
801058d9:	c7 04 24 1a 86 10 80 	movl   $0x8010861a,(%esp)
801058e0:	e8 55 ac ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801058e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058e8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801058ec:	66 83 f8 01          	cmp    $0x1,%ax
801058f0:	75 1f                	jne    80105911 <sys_unlink+0x107>
801058f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058f5:	89 04 24             	mov    %eax,(%esp)
801058f8:	e8 9f fe ff ff       	call   8010579c <isdirempty>
801058fd:	85 c0                	test   %eax,%eax
801058ff:	75 10                	jne    80105911 <sys_unlink+0x107>
    iunlockput(ip);
80105901:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105904:	89 04 24             	mov    %eax,(%esp)
80105907:	e8 ea c1 ff ff       	call   80101af6 <iunlockput>
    goto bad;
8010590c:	e9 b5 00 00 00       	jmp    801059c6 <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
80105911:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105918:	00 
80105919:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105920:	00 
80105921:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105924:	89 04 24             	mov    %eax,(%esp)
80105927:	e8 7e f5 ff ff       	call   80104eaa <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010592c:	8b 55 c8             	mov    -0x38(%ebp),%edx
8010592f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105932:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105939:	00 
8010593a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010593e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105942:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105945:	89 04 24             	mov    %eax,(%esp)
80105948:	e8 87 c5 ff ff       	call   80101ed4 <writei>
8010594d:	83 f8 10             	cmp    $0x10,%eax
80105950:	74 0c                	je     8010595e <sys_unlink+0x154>
    panic("unlink: writei");
80105952:	c7 04 24 2c 86 10 80 	movl   $0x8010862c,(%esp)
80105959:	e8 dc ab ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
8010595e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105961:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105965:	66 83 f8 01          	cmp    $0x1,%ax
80105969:	75 1c                	jne    80105987 <sys_unlink+0x17d>
    dp->nlink--;
8010596b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010596e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105972:	8d 50 ff             	lea    -0x1(%eax),%edx
80105975:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105978:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010597c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010597f:	89 04 24             	mov    %eax,(%esp)
80105982:	e8 28 bd ff ff       	call   801016af <iupdate>
  }
  iunlockput(dp);
80105987:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598a:	89 04 24             	mov    %eax,(%esp)
8010598d:	e8 64 c1 ff ff       	call   80101af6 <iunlockput>

  ip->nlink--;
80105992:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105995:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105999:	8d 50 ff             	lea    -0x1(%eax),%edx
8010599c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010599f:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801059a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059a6:	89 04 24             	mov    %eax,(%esp)
801059a9:	e8 01 bd ff ff       	call   801016af <iupdate>
  iunlockput(ip);
801059ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059b1:	89 04 24             	mov    %eax,(%esp)
801059b4:	e8 3d c1 ff ff       	call   80101af6 <iunlockput>

  commit_trans();
801059b9:	e8 91 d8 ff ff       	call   8010324f <commit_trans>

  return 0;
801059be:	b8 00 00 00 00       	mov    $0x0,%eax
801059c3:	eb 16                	jmp    801059db <sys_unlink+0x1d1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
801059c5:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
801059c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c9:	89 04 24             	mov    %eax,(%esp)
801059cc:	e8 25 c1 ff ff       	call   80101af6 <iunlockput>
  commit_trans();
801059d1:	e8 79 d8 ff ff       	call   8010324f <commit_trans>
  return -1;
801059d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059db:	c9                   	leave  
801059dc:	c3                   	ret    

801059dd <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801059dd:	55                   	push   %ebp
801059de:	89 e5                	mov    %esp,%ebp
801059e0:	83 ec 48             	sub    $0x48,%esp
801059e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801059e6:	8b 55 10             	mov    0x10(%ebp),%edx
801059e9:	8b 45 14             	mov    0x14(%ebp),%eax
801059ec:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801059f0:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801059f4:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801059f8:	8d 45 de             	lea    -0x22(%ebp),%eax
801059fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801059ff:	8b 45 08             	mov    0x8(%ebp),%eax
80105a02:	89 04 24             	mov    %eax,(%esp)
80105a05:	e8 2f ca ff ff       	call   80102439 <nameiparent>
80105a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a11:	75 0a                	jne    80105a1d <create+0x40>
    return 0;
80105a13:	b8 00 00 00 00       	mov    $0x0,%eax
80105a18:	e9 7e 01 00 00       	jmp    80105b9b <create+0x1be>
  ilock(dp);
80105a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a20:	89 04 24             	mov    %eax,(%esp)
80105a23:	e8 47 be ff ff       	call   8010186f <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105a28:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a2b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a2f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105a32:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a39:	89 04 24             	mov    %eax,(%esp)
80105a3c:	e8 4d c6 ff ff       	call   8010208e <dirlookup>
80105a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a48:	74 47                	je     80105a91 <create+0xb4>
    iunlockput(dp);
80105a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a4d:	89 04 24             	mov    %eax,(%esp)
80105a50:	e8 a1 c0 ff ff       	call   80101af6 <iunlockput>
    ilock(ip);
80105a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a58:	89 04 24             	mov    %eax,(%esp)
80105a5b:	e8 0f be ff ff       	call   8010186f <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105a60:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105a65:	75 15                	jne    80105a7c <create+0x9f>
80105a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a6a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105a6e:	66 83 f8 02          	cmp    $0x2,%ax
80105a72:	75 08                	jne    80105a7c <create+0x9f>
      return ip;
80105a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a77:	e9 1f 01 00 00       	jmp    80105b9b <create+0x1be>
    iunlockput(ip);
80105a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a7f:	89 04 24             	mov    %eax,(%esp)
80105a82:	e8 6f c0 ff ff       	call   80101af6 <iunlockput>
    return 0;
80105a87:	b8 00 00 00 00       	mov    $0x0,%eax
80105a8c:	e9 0a 01 00 00       	jmp    80105b9b <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105a91:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a98:	8b 00                	mov    (%eax),%eax
80105a9a:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a9e:	89 04 24             	mov    %eax,(%esp)
80105aa1:	e8 2c bb ff ff       	call   801015d2 <ialloc>
80105aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105aa9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105aad:	75 0c                	jne    80105abb <create+0xde>
    panic("create: ialloc");
80105aaf:	c7 04 24 3b 86 10 80 	movl   $0x8010863b,(%esp)
80105ab6:	e8 7f aa ff ff       	call   8010053a <panic>

  ilock(ip);
80105abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105abe:	89 04 24             	mov    %eax,(%esp)
80105ac1:	e8 a9 bd ff ff       	call   8010186f <ilock>
  ip->major = major;
80105ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ac9:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105acd:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ad4:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105ad8:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105adf:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ae8:	89 04 24             	mov    %eax,(%esp)
80105aeb:	e8 bf bb ff ff       	call   801016af <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105af0:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105af5:	75 6a                	jne    80105b61 <create+0x184>
    dp->nlink++;  // for ".."
80105af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105afa:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105afe:	8d 50 01             	lea    0x1(%eax),%edx
80105b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b04:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b0b:	89 04 24             	mov    %eax,(%esp)
80105b0e:	e8 9c bb ff ff       	call   801016af <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b16:	8b 40 04             	mov    0x4(%eax),%eax
80105b19:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b1d:	c7 44 24 04 15 86 10 	movl   $0x80108615,0x4(%esp)
80105b24:	80 
80105b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b28:	89 04 24             	mov    %eax,(%esp)
80105b2b:	e8 26 c6 ff ff       	call   80102156 <dirlink>
80105b30:	85 c0                	test   %eax,%eax
80105b32:	78 21                	js     80105b55 <create+0x178>
80105b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b37:	8b 40 04             	mov    0x4(%eax),%eax
80105b3a:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b3e:	c7 44 24 04 17 86 10 	movl   $0x80108617,0x4(%esp)
80105b45:	80 
80105b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b49:	89 04 24             	mov    %eax,(%esp)
80105b4c:	e8 05 c6 ff ff       	call   80102156 <dirlink>
80105b51:	85 c0                	test   %eax,%eax
80105b53:	79 0c                	jns    80105b61 <create+0x184>
      panic("create dots");
80105b55:	c7 04 24 4a 86 10 80 	movl   $0x8010864a,(%esp)
80105b5c:	e8 d9 a9 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b64:	8b 40 04             	mov    0x4(%eax),%eax
80105b67:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b6b:	8d 45 de             	lea    -0x22(%ebp),%eax
80105b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b75:	89 04 24             	mov    %eax,(%esp)
80105b78:	e8 d9 c5 ff ff       	call   80102156 <dirlink>
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	79 0c                	jns    80105b8d <create+0x1b0>
    panic("create: dirlink");
80105b81:	c7 04 24 56 86 10 80 	movl   $0x80108656,(%esp)
80105b88:	e8 ad a9 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80105b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b90:	89 04 24             	mov    %eax,(%esp)
80105b93:	e8 5e bf ff ff       	call   80101af6 <iunlockput>

  return ip;
80105b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105b9b:	c9                   	leave  
80105b9c:	c3                   	ret    

80105b9d <sys_open>:

int
sys_open(void)
{
80105b9d:	55                   	push   %ebp
80105b9e:	89 e5                	mov    %esp,%ebp
80105ba0:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ba3:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105baa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105bb1:	e8 e1 f6 ff ff       	call   80105297 <argstr>
80105bb6:	85 c0                	test   %eax,%eax
80105bb8:	78 17                	js     80105bd1 <sys_open+0x34>
80105bba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bc1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105bc8:	e8 39 f6 ff ff       	call   80105206 <argint>
80105bcd:	85 c0                	test   %eax,%eax
80105bcf:	79 0a                	jns    80105bdb <sys_open+0x3e>
    return -1;
80105bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd6:	e9 46 01 00 00       	jmp    80105d21 <sys_open+0x184>
  if(omode & O_CREATE){
80105bdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105bde:	25 00 02 00 00       	and    $0x200,%eax
80105be3:	85 c0                	test   %eax,%eax
80105be5:	74 40                	je     80105c27 <sys_open+0x8a>
    begin_trans();
80105be7:	e8 1a d6 ff ff       	call   80103206 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105bec:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105bef:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105bf6:	00 
80105bf7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105bfe:	00 
80105bff:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105c06:	00 
80105c07:	89 04 24             	mov    %eax,(%esp)
80105c0a:	e8 ce fd ff ff       	call   801059dd <create>
80105c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105c12:	e8 38 d6 ff ff       	call   8010324f <commit_trans>
    if(ip == 0)
80105c17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c1b:	75 5c                	jne    80105c79 <sys_open+0xdc>
      return -1;
80105c1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c22:	e9 fa 00 00 00       	jmp    80105d21 <sys_open+0x184>
  } else {
    if((ip = namei(path)) == 0)
80105c27:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c2a:	89 04 24             	mov    %eax,(%esp)
80105c2d:	e8 e5 c7 ff ff       	call   80102417 <namei>
80105c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c39:	75 0a                	jne    80105c45 <sys_open+0xa8>
      return -1;
80105c3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c40:	e9 dc 00 00 00       	jmp    80105d21 <sys_open+0x184>
    ilock(ip);
80105c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c48:	89 04 24             	mov    %eax,(%esp)
80105c4b:	e8 1f bc ff ff       	call   8010186f <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c53:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c57:	66 83 f8 01          	cmp    $0x1,%ax
80105c5b:	75 1c                	jne    80105c79 <sys_open+0xdc>
80105c5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c60:	85 c0                	test   %eax,%eax
80105c62:	74 15                	je     80105c79 <sys_open+0xdc>
      iunlockput(ip);
80105c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c67:	89 04 24             	mov    %eax,(%esp)
80105c6a:	e8 87 be ff ff       	call   80101af6 <iunlockput>
      return -1;
80105c6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c74:	e9 a8 00 00 00       	jmp    80105d21 <sys_open+0x184>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105c79:	e8 9a b2 ff ff       	call   80100f18 <filealloc>
80105c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c85:	74 14                	je     80105c9b <sys_open+0xfe>
80105c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c8a:	89 04 24             	mov    %eax,(%esp)
80105c8d:	e8 43 f7 ff ff       	call   801053d5 <fdalloc>
80105c92:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105c95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105c99:	79 23                	jns    80105cbe <sys_open+0x121>
    if(f)
80105c9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c9f:	74 0b                	je     80105cac <sys_open+0x10f>
      fileclose(f);
80105ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca4:	89 04 24             	mov    %eax,(%esp)
80105ca7:	e8 15 b3 ff ff       	call   80100fc1 <fileclose>
    iunlockput(ip);
80105cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105caf:	89 04 24             	mov    %eax,(%esp)
80105cb2:	e8 3f be ff ff       	call   80101af6 <iunlockput>
    return -1;
80105cb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cbc:	eb 63                	jmp    80105d21 <sys_open+0x184>
  }
  iunlock(ip);
80105cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc1:	89 04 24             	mov    %eax,(%esp)
80105cc4:	e8 f7 bc ff ff       	call   801019c0 <iunlock>

  f->type = FD_INODE;
80105cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ccc:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cd8:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cde:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105ce5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ce8:	83 e0 01             	and    $0x1,%eax
80105ceb:	85 c0                	test   %eax,%eax
80105ced:	0f 94 c2             	sete   %dl
80105cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf3:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105cf6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cf9:	83 e0 01             	and    $0x1,%eax
80105cfc:	84 c0                	test   %al,%al
80105cfe:	75 0a                	jne    80105d0a <sys_open+0x16d>
80105d00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d03:	83 e0 02             	and    $0x2,%eax
80105d06:	85 c0                	test   %eax,%eax
80105d08:	74 07                	je     80105d11 <sys_open+0x174>
80105d0a:	b8 01 00 00 00       	mov    $0x1,%eax
80105d0f:	eb 05                	jmp    80105d16 <sys_open+0x179>
80105d11:	b8 00 00 00 00       	mov    $0x0,%eax
80105d16:	89 c2                	mov    %eax,%edx
80105d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d1b:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105d21:	c9                   	leave  
80105d22:	c3                   	ret    

80105d23 <sys_mkdir>:

int
sys_mkdir(void)
{
80105d23:	55                   	push   %ebp
80105d24:	89 e5                	mov    %esp,%ebp
80105d26:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105d29:	e8 d8 d4 ff ff       	call   80103206 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105d2e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d31:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d3c:	e8 56 f5 ff ff       	call   80105297 <argstr>
80105d41:	85 c0                	test   %eax,%eax
80105d43:	78 2c                	js     80105d71 <sys_mkdir+0x4e>
80105d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d48:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105d4f:	00 
80105d50:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105d57:	00 
80105d58:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105d5f:	00 
80105d60:	89 04 24             	mov    %eax,(%esp)
80105d63:	e8 75 fc ff ff       	call   801059dd <create>
80105d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d6f:	75 0c                	jne    80105d7d <sys_mkdir+0x5a>
    commit_trans();
80105d71:	e8 d9 d4 ff ff       	call   8010324f <commit_trans>
    return -1;
80105d76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d7b:	eb 15                	jmp    80105d92 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d80:	89 04 24             	mov    %eax,(%esp)
80105d83:	e8 6e bd ff ff       	call   80101af6 <iunlockput>
  commit_trans();
80105d88:	e8 c2 d4 ff ff       	call   8010324f <commit_trans>
  return 0;
80105d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d92:	c9                   	leave  
80105d93:	c3                   	ret    

80105d94 <sys_mknod>:

int
sys_mknod(void)
{
80105d94:	55                   	push   %ebp
80105d95:	89 e5                	mov    %esp,%ebp
80105d97:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105d9a:	e8 67 d4 ff ff       	call   80103206 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105d9f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105da2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105da6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105dad:	e8 e5 f4 ff ff       	call   80105297 <argstr>
80105db2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105db5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105db9:	78 5e                	js     80105e19 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80105dbb:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105dbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dc2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105dc9:	e8 38 f4 ff ff       	call   80105206 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105dce:	85 c0                	test   %eax,%eax
80105dd0:	78 47                	js     80105e19 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105dd2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105dd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dd9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105de0:	e8 21 f4 ff ff       	call   80105206 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105de5:	85 c0                	test   %eax,%eax
80105de7:	78 30                	js     80105e19 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105de9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dec:	0f bf c8             	movswl %ax,%ecx
80105def:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105df2:	0f bf d0             	movswl %ax,%edx
80105df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105df8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105dfc:	89 54 24 08          	mov    %edx,0x8(%esp)
80105e00:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105e07:	00 
80105e08:	89 04 24             	mov    %eax,(%esp)
80105e0b:	e8 cd fb ff ff       	call   801059dd <create>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105e10:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e17:	75 0c                	jne    80105e25 <sys_mknod+0x91>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80105e19:	e8 31 d4 ff ff       	call   8010324f <commit_trans>
    return -1;
80105e1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e23:	eb 15                	jmp    80105e3a <sys_mknod+0xa6>
  }
  iunlockput(ip);
80105e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e28:	89 04 24             	mov    %eax,(%esp)
80105e2b:	e8 c6 bc ff ff       	call   80101af6 <iunlockput>
  commit_trans();
80105e30:	e8 1a d4 ff ff       	call   8010324f <commit_trans>
  return 0;
80105e35:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e3a:	c9                   	leave  
80105e3b:	c3                   	ret    

80105e3c <sys_chdir>:

int
sys_chdir(void)
{
80105e3c:	55                   	push   %ebp
80105e3d:	89 e5                	mov    %esp,%ebp
80105e3f:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105e42:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e45:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e50:	e8 42 f4 ff ff       	call   80105297 <argstr>
80105e55:	85 c0                	test   %eax,%eax
80105e57:	78 14                	js     80105e6d <sys_chdir+0x31>
80105e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5c:	89 04 24             	mov    %eax,(%esp)
80105e5f:	e8 b3 c5 ff ff       	call   80102417 <namei>
80105e64:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e6b:	75 07                	jne    80105e74 <sys_chdir+0x38>
    return -1;
80105e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e72:	eb 57                	jmp    80105ecb <sys_chdir+0x8f>
  ilock(ip);
80105e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e77:	89 04 24             	mov    %eax,(%esp)
80105e7a:	e8 f0 b9 ff ff       	call   8010186f <ilock>
  if(ip->type != T_DIR){
80105e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e82:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105e86:	66 83 f8 01          	cmp    $0x1,%ax
80105e8a:	74 12                	je     80105e9e <sys_chdir+0x62>
    iunlockput(ip);
80105e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e8f:	89 04 24             	mov    %eax,(%esp)
80105e92:	e8 5f bc ff ff       	call   80101af6 <iunlockput>
    return -1;
80105e97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e9c:	eb 2d                	jmp    80105ecb <sys_chdir+0x8f>
  }
  iunlock(ip);
80105e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea1:	89 04 24             	mov    %eax,(%esp)
80105ea4:	e8 17 bb ff ff       	call   801019c0 <iunlock>
  iput(proc->cwd);
80105ea9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105eaf:	8b 40 68             	mov    0x68(%eax),%eax
80105eb2:	89 04 24             	mov    %eax,(%esp)
80105eb5:	e8 6b bb ff ff       	call   80101a25 <iput>
  proc->cwd = ip;
80105eba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ec3:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105ec6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ecb:	c9                   	leave  
80105ecc:	c3                   	ret    

80105ecd <sys_exec>:

int
sys_exec(void)
{
80105ecd:	55                   	push   %ebp
80105ece:	89 e5                	mov    %esp,%ebp
80105ed0:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ed6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105edd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ee4:	e8 ae f3 ff ff       	call   80105297 <argstr>
80105ee9:	85 c0                	test   %eax,%eax
80105eeb:	78 1a                	js     80105f07 <sys_exec+0x3a>
80105eed:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105ef3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ef7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105efe:	e8 03 f3 ff ff       	call   80105206 <argint>
80105f03:	85 c0                	test   %eax,%eax
80105f05:	79 0a                	jns    80105f11 <sys_exec+0x44>
    return -1;
80105f07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f0c:	e9 cd 00 00 00       	jmp    80105fde <sys_exec+0x111>
  }
  memset(argv, 0, sizeof(argv));
80105f11:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105f18:	00 
80105f19:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105f20:	00 
80105f21:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105f27:	89 04 24             	mov    %eax,(%esp)
80105f2a:	e8 7b ef ff ff       	call   80104eaa <memset>
  for(i=0;; i++){
80105f2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f39:	83 f8 1f             	cmp    $0x1f,%eax
80105f3c:	76 0a                	jbe    80105f48 <sys_exec+0x7b>
      return -1;
80105f3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f43:	e9 96 00 00 00       	jmp    80105fde <sys_exec+0x111>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105f48:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f51:	c1 e2 02             	shl    $0x2,%edx
80105f54:	89 d1                	mov    %edx,%ecx
80105f56:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
80105f5c:	8d 14 11             	lea    (%ecx,%edx,1),%edx
80105f5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f63:	89 14 24             	mov    %edx,(%esp)
80105f66:	e8 fd f1 ff ff       	call   80105168 <fetchint>
80105f6b:	85 c0                	test   %eax,%eax
80105f6d:	79 07                	jns    80105f76 <sys_exec+0xa9>
      return -1;
80105f6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f74:	eb 68                	jmp    80105fde <sys_exec+0x111>
    if(uarg == 0){
80105f76:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105f7c:	85 c0                	test   %eax,%eax
80105f7e:	75 26                	jne    80105fa6 <sys_exec+0xd9>
      argv[i] = 0;
80105f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f83:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105f8a:	00 00 00 00 
      break;
80105f8e:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f92:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105f98:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f9c:	89 04 24             	mov    %eax,(%esp)
80105f9f:	e8 54 ab ff ff       	call   80100af8 <exec>
80105fa4:	eb 38                	jmp    80105fde <sys_exec+0x111>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fa9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105fb0:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105fb6:	01 d0                	add    %edx,%eax
80105fb8:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
80105fbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fc2:	89 14 24             	mov    %edx,(%esp)
80105fc5:	e8 d8 f1 ff ff       	call   801051a2 <fetchstr>
80105fca:	85 c0                	test   %eax,%eax
80105fcc:	79 07                	jns    80105fd5 <sys_exec+0x108>
      return -1;
80105fce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fd3:	eb 09                	jmp    80105fde <sys_exec+0x111>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105fd5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80105fd9:	e9 58 ff ff ff       	jmp    80105f36 <sys_exec+0x69>
  return exec(path, argv);
}
80105fde:	c9                   	leave  
80105fdf:	c3                   	ret    

80105fe0 <sys_pipe>:

int
sys_pipe(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105fe6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105fe9:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105ff0:	00 
80105ff1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ff5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ffc:	e8 34 f2 ff ff       	call   80105235 <argptr>
80106001:	85 c0                	test   %eax,%eax
80106003:	79 0a                	jns    8010600f <sys_pipe+0x2f>
    return -1;
80106005:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010600a:	e9 9b 00 00 00       	jmp    801060aa <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
8010600f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106012:	89 44 24 04          	mov    %eax,0x4(%esp)
80106016:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106019:	89 04 24             	mov    %eax,(%esp)
8010601c:	e8 db db ff ff       	call   80103bfc <pipealloc>
80106021:	85 c0                	test   %eax,%eax
80106023:	79 07                	jns    8010602c <sys_pipe+0x4c>
    return -1;
80106025:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010602a:	eb 7e                	jmp    801060aa <sys_pipe+0xca>
  fd0 = -1;
8010602c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106033:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106036:	89 04 24             	mov    %eax,(%esp)
80106039:	e8 97 f3 ff ff       	call   801053d5 <fdalloc>
8010603e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106041:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106045:	78 14                	js     8010605b <sys_pipe+0x7b>
80106047:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010604a:	89 04 24             	mov    %eax,(%esp)
8010604d:	e8 83 f3 ff ff       	call   801053d5 <fdalloc>
80106052:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106055:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106059:	79 37                	jns    80106092 <sys_pipe+0xb2>
    if(fd0 >= 0)
8010605b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010605f:	78 14                	js     80106075 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106061:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106067:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010606a:	83 c2 08             	add    $0x8,%edx
8010606d:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106074:	00 
    fileclose(rf);
80106075:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106078:	89 04 24             	mov    %eax,(%esp)
8010607b:	e8 41 af ff ff       	call   80100fc1 <fileclose>
    fileclose(wf);
80106080:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106083:	89 04 24             	mov    %eax,(%esp)
80106086:	e8 36 af ff ff       	call   80100fc1 <fileclose>
    return -1;
8010608b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106090:	eb 18                	jmp    801060aa <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106092:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106095:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106098:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010609a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010609d:	8d 50 04             	lea    0x4(%eax),%edx
801060a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a3:	89 02                	mov    %eax,(%edx)
  return 0;
801060a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060aa:	c9                   	leave  
801060ab:	c3                   	ret    

801060ac <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801060ac:	55                   	push   %ebp
801060ad:	89 e5                	mov    %esp,%ebp
801060af:	83 ec 08             	sub    $0x8,%esp
  return fork();
801060b2:	e8 30 e3 ff ff       	call   801043e7 <fork>
}
801060b7:	c9                   	leave  
801060b8:	c3                   	ret    

801060b9 <sys_exit>:

int
sys_exit(void)
{
801060b9:	55                   	push   %ebp
801060ba:	89 e5                	mov    %esp,%ebp
801060bc:	83 ec 08             	sub    $0x8,%esp
  exit();
801060bf:	e8 91 e4 ff ff       	call   80104555 <exit>
  return 0;  // not reached
801060c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060c9:	c9                   	leave  
801060ca:	c3                   	ret    

801060cb <sys_wait>:

int
sys_wait(void)
{
801060cb:	55                   	push   %ebp
801060cc:	89 e5                	mov    %esp,%ebp
801060ce:	83 ec 08             	sub    $0x8,%esp
  return wait();
801060d1:	e8 9b e5 ff ff       	call   80104671 <wait>
}
801060d6:	c9                   	leave  
801060d7:	c3                   	ret    

801060d8 <sys_kill>:

int
sys_kill(void)
{
801060d8:	55                   	push   %ebp
801060d9:	89 e5                	mov    %esp,%ebp
801060db:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801060de:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801060e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060ec:	e8 15 f1 ff ff       	call   80105206 <argint>
801060f1:	85 c0                	test   %eax,%eax
801060f3:	79 07                	jns    801060fc <sys_kill+0x24>
    return -1;
801060f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060fa:	eb 0b                	jmp    80106107 <sys_kill+0x2f>
  return kill(pid);
801060fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ff:	89 04 24             	mov    %eax,(%esp)
80106102:	e8 78 e9 ff ff       	call   80104a7f <kill>
}
80106107:	c9                   	leave  
80106108:	c3                   	ret    

80106109 <sys_getpid>:

int
sys_getpid(void)
{
80106109:	55                   	push   %ebp
8010610a:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010610c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106112:	8b 40 10             	mov    0x10(%eax),%eax
}
80106115:	5d                   	pop    %ebp
80106116:	c3                   	ret    

80106117 <sys_sbrk>:

int
sys_sbrk(void)
{
80106117:	55                   	push   %ebp
80106118:	89 e5                	mov    %esp,%ebp
8010611a:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010611d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106120:	89 44 24 04          	mov    %eax,0x4(%esp)
80106124:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010612b:	e8 d6 f0 ff ff       	call   80105206 <argint>
80106130:	85 c0                	test   %eax,%eax
80106132:	79 07                	jns    8010613b <sys_sbrk+0x24>
    return -1;
80106134:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106139:	eb 24                	jmp    8010615f <sys_sbrk+0x48>
  addr = proc->sz;
8010613b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106141:	8b 00                	mov    (%eax),%eax
80106143:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106146:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106149:	89 04 24             	mov    %eax,(%esp)
8010614c:	e8 f1 e1 ff ff       	call   80104342 <growproc>
80106151:	85 c0                	test   %eax,%eax
80106153:	79 07                	jns    8010615c <sys_sbrk+0x45>
    return -1;
80106155:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010615a:	eb 03                	jmp    8010615f <sys_sbrk+0x48>
  return addr;
8010615c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010615f:	c9                   	leave  
80106160:	c3                   	ret    

80106161 <sys_sleep>:

int
sys_sleep(void)
{
80106161:	55                   	push   %ebp
80106162:	89 e5                	mov    %esp,%ebp
80106164:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106167:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010616a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010616e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106175:	e8 8c f0 ff ff       	call   80105206 <argint>
8010617a:	85 c0                	test   %eax,%eax
8010617c:	79 07                	jns    80106185 <sys_sleep+0x24>
    return -1;
8010617e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106183:	eb 6c                	jmp    801061f1 <sys_sleep+0x90>
  acquire(&tickslock);
80106185:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
8010618c:	e8 ca ea ff ff       	call   80104c5b <acquire>
  ticks0 = ticks;
80106191:	a1 60 29 11 80       	mov    0x80112960,%eax
80106196:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106199:	eb 34                	jmp    801061cf <sys_sleep+0x6e>
    if(proc->killed){
8010619b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061a1:	8b 40 24             	mov    0x24(%eax),%eax
801061a4:	85 c0                	test   %eax,%eax
801061a6:	74 13                	je     801061bb <sys_sleep+0x5a>
      release(&tickslock);
801061a8:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
801061af:	e8 08 eb ff ff       	call   80104cbc <release>
      return -1;
801061b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061b9:	eb 36                	jmp    801061f1 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
801061bb:	c7 44 24 04 20 21 11 	movl   $0x80112120,0x4(%esp)
801061c2:	80 
801061c3:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
801061ca:	e8 9d e7 ff ff       	call   8010496c <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801061cf:	a1 60 29 11 80       	mov    0x80112960,%eax
801061d4:	89 c2                	mov    %eax,%edx
801061d6:	2b 55 f4             	sub    -0xc(%ebp),%edx
801061d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061dc:	39 c2                	cmp    %eax,%edx
801061de:	72 bb                	jb     8010619b <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801061e0:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
801061e7:	e8 d0 ea ff ff       	call   80104cbc <release>
  return 0;
801061ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061f1:	c9                   	leave  
801061f2:	c3                   	ret    

801061f3 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801061f3:	55                   	push   %ebp
801061f4:	89 e5                	mov    %esp,%ebp
801061f6:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
801061f9:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
80106200:	e8 56 ea ff ff       	call   80104c5b <acquire>
  xticks = ticks;
80106205:	a1 60 29 11 80       	mov    0x80112960,%eax
8010620a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010620d:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
80106214:	e8 a3 ea ff ff       	call   80104cbc <release>
  return xticks;
80106219:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010621c:	c9                   	leave  
8010621d:	c3                   	ret    
	...

80106220 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	83 ec 08             	sub    $0x8,%esp
80106226:	8b 55 08             	mov    0x8(%ebp),%edx
80106229:	8b 45 0c             	mov    0xc(%ebp),%eax
8010622c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106230:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106233:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106237:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010623b:	ee                   	out    %al,(%dx)
}
8010623c:	c9                   	leave  
8010623d:	c3                   	ret    

8010623e <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010623e:	55                   	push   %ebp
8010623f:	89 e5                	mov    %esp,%ebp
80106241:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106244:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
8010624b:	00 
8010624c:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106253:	e8 c8 ff ff ff       	call   80106220 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106258:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
8010625f:	00 
80106260:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106267:	e8 b4 ff ff ff       	call   80106220 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
8010626c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106273:	00 
80106274:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010627b:	e8 a0 ff ff ff       	call   80106220 <outb>
  picenable(IRQ_TIMER);
80106280:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106287:	e8 f9 d7 ff ff       	call   80103a85 <picenable>
}
8010628c:	c9                   	leave  
8010628d:	c3                   	ret    
	...

80106290 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106290:	1e                   	push   %ds
  pushl %es
80106291:	06                   	push   %es
  pushl %fs
80106292:	0f a0                	push   %fs
  pushl %gs
80106294:	0f a8                	push   %gs
  pushal
80106296:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106297:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010629b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010629d:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010629f:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801062a3:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801062a5:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801062a7:	54                   	push   %esp
  call trap
801062a8:	e8 d5 01 00 00       	call   80106482 <trap>
  addl $4, %esp
801062ad:	83 c4 04             	add    $0x4,%esp

801062b0 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801062b0:	61                   	popa   
  popl %gs
801062b1:	0f a9                	pop    %gs
  popl %fs
801062b3:	0f a1                	pop    %fs
  popl %es
801062b5:	07                   	pop    %es
  popl %ds
801062b6:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801062b7:	83 c4 08             	add    $0x8,%esp
  iret
801062ba:	cf                   	iret   
	...

801062bc <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801062bc:	55                   	push   %ebp
801062bd:	89 e5                	mov    %esp,%ebp
801062bf:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801062c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801062c5:	83 e8 01             	sub    $0x1,%eax
801062c8:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801062cc:	8b 45 08             	mov    0x8(%ebp),%eax
801062cf:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801062d3:	8b 45 08             	mov    0x8(%ebp),%eax
801062d6:	c1 e8 10             	shr    $0x10,%eax
801062d9:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801062dd:	8d 45 fa             	lea    -0x6(%ebp),%eax
801062e0:	0f 01 18             	lidtl  (%eax)
}
801062e3:	c9                   	leave  
801062e4:	c3                   	ret    

801062e5 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801062e5:	55                   	push   %ebp
801062e6:	89 e5                	mov    %esp,%ebp
801062e8:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801062eb:	0f 20 d0             	mov    %cr2,%eax
801062ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801062f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801062f4:	c9                   	leave  
801062f5:	c3                   	ret    

801062f6 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801062f6:	55                   	push   %ebp
801062f7:	89 e5                	mov    %esp,%ebp
801062f9:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801062fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106303:	e9 bf 00 00 00       	jmp    801063c7 <tvinit+0xd1>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010630b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010630e:	8b 14 95 98 b0 10 80 	mov    -0x7fef4f68(,%edx,4),%edx
80106315:	66 89 14 c5 60 21 11 	mov    %dx,-0x7feedea0(,%eax,8)
8010631c:	80 
8010631d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106320:	66 c7 04 c5 62 21 11 	movw   $0x8,-0x7feede9e(,%eax,8)
80106327:	80 08 00 
8010632a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010632d:	0f b6 14 c5 64 21 11 	movzbl -0x7feede9c(,%eax,8),%edx
80106334:	80 
80106335:	83 e2 e0             	and    $0xffffffe0,%edx
80106338:	88 14 c5 64 21 11 80 	mov    %dl,-0x7feede9c(,%eax,8)
8010633f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106342:	0f b6 14 c5 64 21 11 	movzbl -0x7feede9c(,%eax,8),%edx
80106349:	80 
8010634a:	83 e2 1f             	and    $0x1f,%edx
8010634d:	88 14 c5 64 21 11 80 	mov    %dl,-0x7feede9c(,%eax,8)
80106354:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106357:	0f b6 14 c5 65 21 11 	movzbl -0x7feede9b(,%eax,8),%edx
8010635e:	80 
8010635f:	83 e2 f0             	and    $0xfffffff0,%edx
80106362:	83 ca 0e             	or     $0xe,%edx
80106365:	88 14 c5 65 21 11 80 	mov    %dl,-0x7feede9b(,%eax,8)
8010636c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010636f:	0f b6 14 c5 65 21 11 	movzbl -0x7feede9b(,%eax,8),%edx
80106376:	80 
80106377:	83 e2 ef             	and    $0xffffffef,%edx
8010637a:	88 14 c5 65 21 11 80 	mov    %dl,-0x7feede9b(,%eax,8)
80106381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106384:	0f b6 14 c5 65 21 11 	movzbl -0x7feede9b(,%eax,8),%edx
8010638b:	80 
8010638c:	83 e2 9f             	and    $0xffffff9f,%edx
8010638f:	88 14 c5 65 21 11 80 	mov    %dl,-0x7feede9b(,%eax,8)
80106396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106399:	0f b6 14 c5 65 21 11 	movzbl -0x7feede9b(,%eax,8),%edx
801063a0:	80 
801063a1:	83 ca 80             	or     $0xffffff80,%edx
801063a4:	88 14 c5 65 21 11 80 	mov    %dl,-0x7feede9b(,%eax,8)
801063ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063b1:	8b 14 95 98 b0 10 80 	mov    -0x7fef4f68(,%edx,4),%edx
801063b8:	c1 ea 10             	shr    $0x10,%edx
801063bb:	66 89 14 c5 66 21 11 	mov    %dx,-0x7feede9a(,%eax,8)
801063c2:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801063c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801063c7:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801063ce:	0f 8e 34 ff ff ff    	jle    80106308 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801063d4:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801063d9:	66 a3 60 23 11 80    	mov    %ax,0x80112360
801063df:	66 c7 05 62 23 11 80 	movw   $0x8,0x80112362
801063e6:	08 00 
801063e8:	0f b6 05 64 23 11 80 	movzbl 0x80112364,%eax
801063ef:	83 e0 e0             	and    $0xffffffe0,%eax
801063f2:	a2 64 23 11 80       	mov    %al,0x80112364
801063f7:	0f b6 05 64 23 11 80 	movzbl 0x80112364,%eax
801063fe:	83 e0 1f             	and    $0x1f,%eax
80106401:	a2 64 23 11 80       	mov    %al,0x80112364
80106406:	0f b6 05 65 23 11 80 	movzbl 0x80112365,%eax
8010640d:	83 c8 0f             	or     $0xf,%eax
80106410:	a2 65 23 11 80       	mov    %al,0x80112365
80106415:	0f b6 05 65 23 11 80 	movzbl 0x80112365,%eax
8010641c:	83 e0 ef             	and    $0xffffffef,%eax
8010641f:	a2 65 23 11 80       	mov    %al,0x80112365
80106424:	0f b6 05 65 23 11 80 	movzbl 0x80112365,%eax
8010642b:	83 c8 60             	or     $0x60,%eax
8010642e:	a2 65 23 11 80       	mov    %al,0x80112365
80106433:	0f b6 05 65 23 11 80 	movzbl 0x80112365,%eax
8010643a:	83 c8 80             	or     $0xffffff80,%eax
8010643d:	a2 65 23 11 80       	mov    %al,0x80112365
80106442:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106447:	c1 e8 10             	shr    $0x10,%eax
8010644a:	66 a3 66 23 11 80    	mov    %ax,0x80112366
  
  initlock(&tickslock, "time");
80106450:	c7 44 24 04 68 86 10 	movl   $0x80108668,0x4(%esp)
80106457:	80 
80106458:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
8010645f:	e8 d6 e7 ff ff       	call   80104c3a <initlock>
}
80106464:	c9                   	leave  
80106465:	c3                   	ret    

80106466 <idtinit>:

void
idtinit(void)
{
80106466:	55                   	push   %ebp
80106467:	89 e5                	mov    %esp,%ebp
80106469:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
8010646c:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106473:	00 
80106474:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
8010647b:	e8 3c fe ff ff       	call   801062bc <lidt>
}
80106480:	c9                   	leave  
80106481:	c3                   	ret    

80106482 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106482:	55                   	push   %ebp
80106483:	89 e5                	mov    %esp,%ebp
80106485:	57                   	push   %edi
80106486:	56                   	push   %esi
80106487:	53                   	push   %ebx
80106488:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
8010648b:	8b 45 08             	mov    0x8(%ebp),%eax
8010648e:	8b 40 30             	mov    0x30(%eax),%eax
80106491:	83 f8 40             	cmp    $0x40,%eax
80106494:	75 3e                	jne    801064d4 <trap+0x52>
    if(proc->killed)
80106496:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010649c:	8b 40 24             	mov    0x24(%eax),%eax
8010649f:	85 c0                	test   %eax,%eax
801064a1:	74 05                	je     801064a8 <trap+0x26>
      exit();
801064a3:	e8 ad e0 ff ff       	call   80104555 <exit>
    proc->tf = tf;
801064a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064ae:	8b 55 08             	mov    0x8(%ebp),%edx
801064b1:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801064b4:	e8 15 ee ff ff       	call   801052ce <syscall>
    if(proc->killed)
801064b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064bf:	8b 40 24             	mov    0x24(%eax),%eax
801064c2:	85 c0                	test   %eax,%eax
801064c4:	0f 84 34 02 00 00    	je     801066fe <trap+0x27c>
      exit();
801064ca:	e8 86 e0 ff ff       	call   80104555 <exit>
    return;
801064cf:	e9 2b 02 00 00       	jmp    801066ff <trap+0x27d>
  }

  switch(tf->trapno){
801064d4:	8b 45 08             	mov    0x8(%ebp),%eax
801064d7:	8b 40 30             	mov    0x30(%eax),%eax
801064da:	83 e8 20             	sub    $0x20,%eax
801064dd:	83 f8 1f             	cmp    $0x1f,%eax
801064e0:	0f 87 bc 00 00 00    	ja     801065a2 <trap+0x120>
801064e6:	8b 04 85 10 87 10 80 	mov    -0x7fef78f0(,%eax,4),%eax
801064ed:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801064ef:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801064f5:	0f b6 00             	movzbl (%eax),%eax
801064f8:	84 c0                	test   %al,%al
801064fa:	75 31                	jne    8010652d <trap+0xab>
      acquire(&tickslock);
801064fc:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
80106503:	e8 53 e7 ff ff       	call   80104c5b <acquire>
      ticks++;
80106508:	a1 60 29 11 80       	mov    0x80112960,%eax
8010650d:	83 c0 01             	add    $0x1,%eax
80106510:	a3 60 29 11 80       	mov    %eax,0x80112960
      wakeup(&ticks);
80106515:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
8010651c:	e8 33 e5 ff ff       	call   80104a54 <wakeup>
      release(&tickslock);
80106521:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
80106528:	e8 8f e7 ff ff       	call   80104cbc <release>
    }
    lapiceoi();
8010652d:	e8 a2 c9 ff ff       	call   80102ed4 <lapiceoi>
    break;
80106532:	e9 41 01 00 00       	jmp    80106678 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106537:	e8 b3 c1 ff ff       	call   801026ef <ideintr>
    lapiceoi();
8010653c:	e8 93 c9 ff ff       	call   80102ed4 <lapiceoi>
    break;
80106541:	e9 32 01 00 00       	jmp    80106678 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106546:	e8 6c c7 ff ff       	call   80102cb7 <kbdintr>
    lapiceoi();
8010654b:	e8 84 c9 ff ff       	call   80102ed4 <lapiceoi>
    break;
80106550:	e9 23 01 00 00       	jmp    80106678 <trap+0x1f6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106555:	e8 9d 03 00 00       	call   801068f7 <uartintr>
    lapiceoi();
8010655a:	e8 75 c9 ff ff       	call   80102ed4 <lapiceoi>
    break;
8010655f:	e9 14 01 00 00       	jmp    80106678 <trap+0x1f6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106564:	8b 45 08             	mov    0x8(%ebp),%eax
80106567:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
8010656a:	8b 45 08             	mov    0x8(%ebp),%eax
8010656d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106571:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106574:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010657a:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010657d:	0f b6 c0             	movzbl %al,%eax
80106580:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106584:	89 54 24 08          	mov    %edx,0x8(%esp)
80106588:	89 44 24 04          	mov    %eax,0x4(%esp)
8010658c:	c7 04 24 70 86 10 80 	movl   $0x80108670,(%esp)
80106593:	e8 02 9e ff ff       	call   8010039a <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106598:	e8 37 c9 ff ff       	call   80102ed4 <lapiceoi>
    break;
8010659d:	e9 d6 00 00 00       	jmp    80106678 <trap+0x1f6>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801065a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065a8:	85 c0                	test   %eax,%eax
801065aa:	74 11                	je     801065bd <trap+0x13b>
801065ac:	8b 45 08             	mov    0x8(%ebp),%eax
801065af:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801065b3:	0f b7 c0             	movzwl %ax,%eax
801065b6:	83 e0 03             	and    $0x3,%eax
801065b9:	85 c0                	test   %eax,%eax
801065bb:	75 46                	jne    80106603 <trap+0x181>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801065bd:	e8 23 fd ff ff       	call   801062e5 <rcr2>
801065c2:	8b 55 08             	mov    0x8(%ebp),%edx
801065c5:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
801065c8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801065cf:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801065d2:	0f b6 ca             	movzbl %dl,%ecx
801065d5:	8b 55 08             	mov    0x8(%ebp),%edx
801065d8:	8b 52 30             	mov    0x30(%edx),%edx
801065db:	89 44 24 10          	mov    %eax,0x10(%esp)
801065df:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801065e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801065e7:	89 54 24 04          	mov    %edx,0x4(%esp)
801065eb:	c7 04 24 94 86 10 80 	movl   $0x80108694,(%esp)
801065f2:	e8 a3 9d ff ff       	call   8010039a <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801065f7:	c7 04 24 c6 86 10 80 	movl   $0x801086c6,(%esp)
801065fe:	e8 37 9f ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106603:	e8 dd fc ff ff       	call   801062e5 <rcr2>
80106608:	89 c2                	mov    %eax,%edx
8010660a:	8b 45 08             	mov    0x8(%ebp),%eax
8010660d:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106610:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106616:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106619:	0f b6 f0             	movzbl %al,%esi
8010661c:	8b 45 08             	mov    0x8(%ebp),%eax
8010661f:	8b 58 34             	mov    0x34(%eax),%ebx
80106622:	8b 45 08             	mov    0x8(%ebp),%eax
80106625:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106628:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010662e:	83 c0 6c             	add    $0x6c,%eax
80106631:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106634:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010663a:	8b 40 10             	mov    0x10(%eax),%eax
8010663d:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106641:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106645:	89 74 24 14          	mov    %esi,0x14(%esp)
80106649:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010664d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106651:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106654:	89 54 24 08          	mov    %edx,0x8(%esp)
80106658:	89 44 24 04          	mov    %eax,0x4(%esp)
8010665c:	c7 04 24 cc 86 10 80 	movl   $0x801086cc,(%esp)
80106663:	e8 32 9d ff ff       	call   8010039a <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106668:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010666e:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106675:	eb 01                	jmp    80106678 <trap+0x1f6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106677:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106678:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010667e:	85 c0                	test   %eax,%eax
80106680:	74 24                	je     801066a6 <trap+0x224>
80106682:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106688:	8b 40 24             	mov    0x24(%eax),%eax
8010668b:	85 c0                	test   %eax,%eax
8010668d:	74 17                	je     801066a6 <trap+0x224>
8010668f:	8b 45 08             	mov    0x8(%ebp),%eax
80106692:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106696:	0f b7 c0             	movzwl %ax,%eax
80106699:	83 e0 03             	and    $0x3,%eax
8010669c:	83 f8 03             	cmp    $0x3,%eax
8010669f:	75 05                	jne    801066a6 <trap+0x224>
    exit();
801066a1:	e8 af de ff ff       	call   80104555 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801066a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066ac:	85 c0                	test   %eax,%eax
801066ae:	74 1e                	je     801066ce <trap+0x24c>
801066b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066b6:	8b 40 0c             	mov    0xc(%eax),%eax
801066b9:	83 f8 04             	cmp    $0x4,%eax
801066bc:	75 10                	jne    801066ce <trap+0x24c>
801066be:	8b 45 08             	mov    0x8(%ebp),%eax
801066c1:	8b 40 30             	mov    0x30(%eax),%eax
801066c4:	83 f8 20             	cmp    $0x20,%eax
801066c7:	75 05                	jne    801066ce <trap+0x24c>
    yield();
801066c9:	e8 32 e2 ff ff       	call   80104900 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801066ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066d4:	85 c0                	test   %eax,%eax
801066d6:	74 27                	je     801066ff <trap+0x27d>
801066d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066de:	8b 40 24             	mov    0x24(%eax),%eax
801066e1:	85 c0                	test   %eax,%eax
801066e3:	74 1a                	je     801066ff <trap+0x27d>
801066e5:	8b 45 08             	mov    0x8(%ebp),%eax
801066e8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801066ec:	0f b7 c0             	movzwl %ax,%eax
801066ef:	83 e0 03             	and    $0x3,%eax
801066f2:	83 f8 03             	cmp    $0x3,%eax
801066f5:	75 08                	jne    801066ff <trap+0x27d>
    exit();
801066f7:	e8 59 de ff ff       	call   80104555 <exit>
801066fc:	eb 01                	jmp    801066ff <trap+0x27d>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801066fe:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801066ff:	83 c4 3c             	add    $0x3c,%esp
80106702:	5b                   	pop    %ebx
80106703:	5e                   	pop    %esi
80106704:	5f                   	pop    %edi
80106705:	5d                   	pop    %ebp
80106706:	c3                   	ret    
	...

80106708 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106708:	55                   	push   %ebp
80106709:	89 e5                	mov    %esp,%ebp
8010670b:	83 ec 14             	sub    $0x14,%esp
8010670e:	8b 45 08             	mov    0x8(%ebp),%eax
80106711:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106715:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106719:	89 c2                	mov    %eax,%edx
8010671b:	ec                   	in     (%dx),%al
8010671c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010671f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106723:	c9                   	leave  
80106724:	c3                   	ret    

80106725 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106725:	55                   	push   %ebp
80106726:	89 e5                	mov    %esp,%ebp
80106728:	83 ec 08             	sub    $0x8,%esp
8010672b:	8b 55 08             	mov    0x8(%ebp),%edx
8010672e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106731:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106735:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106738:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010673c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106740:	ee                   	out    %al,(%dx)
}
80106741:	c9                   	leave  
80106742:	c3                   	ret    

80106743 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106743:	55                   	push   %ebp
80106744:	89 e5                	mov    %esp,%ebp
80106746:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106749:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106750:	00 
80106751:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106758:	e8 c8 ff ff ff       	call   80106725 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010675d:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106764:	00 
80106765:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010676c:	e8 b4 ff ff ff       	call   80106725 <outb>
  outb(COM1+0, 115200/9600);
80106771:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106778:	00 
80106779:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106780:	e8 a0 ff ff ff       	call   80106725 <outb>
  outb(COM1+1, 0);
80106785:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010678c:	00 
8010678d:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106794:	e8 8c ff ff ff       	call   80106725 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106799:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801067a0:	00 
801067a1:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801067a8:	e8 78 ff ff ff       	call   80106725 <outb>
  outb(COM1+4, 0);
801067ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067b4:	00 
801067b5:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
801067bc:	e8 64 ff ff ff       	call   80106725 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801067c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801067c8:	00 
801067c9:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801067d0:	e8 50 ff ff ff       	call   80106725 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801067d5:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801067dc:	e8 27 ff ff ff       	call   80106708 <inb>
801067e1:	3c ff                	cmp    $0xff,%al
801067e3:	74 6c                	je     80106851 <uartinit+0x10e>
    return;
  uart = 1;
801067e5:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
801067ec:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801067ef:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801067f6:	e8 0d ff ff ff       	call   80106708 <inb>
  inb(COM1+0);
801067fb:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106802:	e8 01 ff ff ff       	call   80106708 <inb>
  picenable(IRQ_COM1);
80106807:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010680e:	e8 72 d2 ff ff       	call   80103a85 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106813:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010681a:	00 
8010681b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106822:	e8 4b c1 ff ff       	call   80102972 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106827:	c7 45 f4 90 87 10 80 	movl   $0x80108790,-0xc(%ebp)
8010682e:	eb 15                	jmp    80106845 <uartinit+0x102>
    uartputc(*p);
80106830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106833:	0f b6 00             	movzbl (%eax),%eax
80106836:	0f be c0             	movsbl %al,%eax
80106839:	89 04 24             	mov    %eax,(%esp)
8010683c:	e8 13 00 00 00       	call   80106854 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106841:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106845:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106848:	0f b6 00             	movzbl (%eax),%eax
8010684b:	84 c0                	test   %al,%al
8010684d:	75 e1                	jne    80106830 <uartinit+0xed>
8010684f:	eb 01                	jmp    80106852 <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106851:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106852:	c9                   	leave  
80106853:	c3                   	ret    

80106854 <uartputc>:

void
uartputc(int c)
{
80106854:	55                   	push   %ebp
80106855:	89 e5                	mov    %esp,%ebp
80106857:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010685a:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
8010685f:	85 c0                	test   %eax,%eax
80106861:	74 4d                	je     801068b0 <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106863:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010686a:	eb 10                	jmp    8010687c <uartputc+0x28>
    microdelay(10);
8010686c:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106873:	e8 81 c6 ff ff       	call   80102ef9 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106878:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010687c:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106880:	7f 16                	jg     80106898 <uartputc+0x44>
80106882:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106889:	e8 7a fe ff ff       	call   80106708 <inb>
8010688e:	0f b6 c0             	movzbl %al,%eax
80106891:	83 e0 20             	and    $0x20,%eax
80106894:	85 c0                	test   %eax,%eax
80106896:	74 d4                	je     8010686c <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106898:	8b 45 08             	mov    0x8(%ebp),%eax
8010689b:	0f b6 c0             	movzbl %al,%eax
8010689e:	89 44 24 04          	mov    %eax,0x4(%esp)
801068a2:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801068a9:	e8 77 fe ff ff       	call   80106725 <outb>
801068ae:	eb 01                	jmp    801068b1 <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801068b0:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801068b1:	c9                   	leave  
801068b2:	c3                   	ret    

801068b3 <uartgetc>:

static int
uartgetc(void)
{
801068b3:	55                   	push   %ebp
801068b4:	89 e5                	mov    %esp,%ebp
801068b6:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801068b9:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
801068be:	85 c0                	test   %eax,%eax
801068c0:	75 07                	jne    801068c9 <uartgetc+0x16>
    return -1;
801068c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068c7:	eb 2c                	jmp    801068f5 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801068c9:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801068d0:	e8 33 fe ff ff       	call   80106708 <inb>
801068d5:	0f b6 c0             	movzbl %al,%eax
801068d8:	83 e0 01             	and    $0x1,%eax
801068db:	85 c0                	test   %eax,%eax
801068dd:	75 07                	jne    801068e6 <uartgetc+0x33>
    return -1;
801068df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068e4:	eb 0f                	jmp    801068f5 <uartgetc+0x42>
  return inb(COM1+0);
801068e6:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801068ed:	e8 16 fe ff ff       	call   80106708 <inb>
801068f2:	0f b6 c0             	movzbl %al,%eax
}
801068f5:	c9                   	leave  
801068f6:	c3                   	ret    

801068f7 <uartintr>:

void
uartintr(void)
{
801068f7:	55                   	push   %ebp
801068f8:	89 e5                	mov    %esp,%ebp
801068fa:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801068fd:	c7 04 24 b3 68 10 80 	movl   $0x801068b3,(%esp)
80106904:	e8 a2 9e ff ff       	call   801007ab <consoleintr>
}
80106909:	c9                   	leave  
8010690a:	c3                   	ret    
	...

8010690c <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010690c:	6a 00                	push   $0x0
  pushl $0
8010690e:	6a 00                	push   $0x0
  jmp alltraps
80106910:	e9 7b f9 ff ff       	jmp    80106290 <alltraps>

80106915 <vector1>:
.globl vector1
vector1:
  pushl $0
80106915:	6a 00                	push   $0x0
  pushl $1
80106917:	6a 01                	push   $0x1
  jmp alltraps
80106919:	e9 72 f9 ff ff       	jmp    80106290 <alltraps>

8010691e <vector2>:
.globl vector2
vector2:
  pushl $0
8010691e:	6a 00                	push   $0x0
  pushl $2
80106920:	6a 02                	push   $0x2
  jmp alltraps
80106922:	e9 69 f9 ff ff       	jmp    80106290 <alltraps>

80106927 <vector3>:
.globl vector3
vector3:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $3
80106929:	6a 03                	push   $0x3
  jmp alltraps
8010692b:	e9 60 f9 ff ff       	jmp    80106290 <alltraps>

80106930 <vector4>:
.globl vector4
vector4:
  pushl $0
80106930:	6a 00                	push   $0x0
  pushl $4
80106932:	6a 04                	push   $0x4
  jmp alltraps
80106934:	e9 57 f9 ff ff       	jmp    80106290 <alltraps>

80106939 <vector5>:
.globl vector5
vector5:
  pushl $0
80106939:	6a 00                	push   $0x0
  pushl $5
8010693b:	6a 05                	push   $0x5
  jmp alltraps
8010693d:	e9 4e f9 ff ff       	jmp    80106290 <alltraps>

80106942 <vector6>:
.globl vector6
vector6:
  pushl $0
80106942:	6a 00                	push   $0x0
  pushl $6
80106944:	6a 06                	push   $0x6
  jmp alltraps
80106946:	e9 45 f9 ff ff       	jmp    80106290 <alltraps>

8010694b <vector7>:
.globl vector7
vector7:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $7
8010694d:	6a 07                	push   $0x7
  jmp alltraps
8010694f:	e9 3c f9 ff ff       	jmp    80106290 <alltraps>

80106954 <vector8>:
.globl vector8
vector8:
  pushl $8
80106954:	6a 08                	push   $0x8
  jmp alltraps
80106956:	e9 35 f9 ff ff       	jmp    80106290 <alltraps>

8010695b <vector9>:
.globl vector9
vector9:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $9
8010695d:	6a 09                	push   $0x9
  jmp alltraps
8010695f:	e9 2c f9 ff ff       	jmp    80106290 <alltraps>

80106964 <vector10>:
.globl vector10
vector10:
  pushl $10
80106964:	6a 0a                	push   $0xa
  jmp alltraps
80106966:	e9 25 f9 ff ff       	jmp    80106290 <alltraps>

8010696b <vector11>:
.globl vector11
vector11:
  pushl $11
8010696b:	6a 0b                	push   $0xb
  jmp alltraps
8010696d:	e9 1e f9 ff ff       	jmp    80106290 <alltraps>

80106972 <vector12>:
.globl vector12
vector12:
  pushl $12
80106972:	6a 0c                	push   $0xc
  jmp alltraps
80106974:	e9 17 f9 ff ff       	jmp    80106290 <alltraps>

80106979 <vector13>:
.globl vector13
vector13:
  pushl $13
80106979:	6a 0d                	push   $0xd
  jmp alltraps
8010697b:	e9 10 f9 ff ff       	jmp    80106290 <alltraps>

80106980 <vector14>:
.globl vector14
vector14:
  pushl $14
80106980:	6a 0e                	push   $0xe
  jmp alltraps
80106982:	e9 09 f9 ff ff       	jmp    80106290 <alltraps>

80106987 <vector15>:
.globl vector15
vector15:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $15
80106989:	6a 0f                	push   $0xf
  jmp alltraps
8010698b:	e9 00 f9 ff ff       	jmp    80106290 <alltraps>

80106990 <vector16>:
.globl vector16
vector16:
  pushl $0
80106990:	6a 00                	push   $0x0
  pushl $16
80106992:	6a 10                	push   $0x10
  jmp alltraps
80106994:	e9 f7 f8 ff ff       	jmp    80106290 <alltraps>

80106999 <vector17>:
.globl vector17
vector17:
  pushl $17
80106999:	6a 11                	push   $0x11
  jmp alltraps
8010699b:	e9 f0 f8 ff ff       	jmp    80106290 <alltraps>

801069a0 <vector18>:
.globl vector18
vector18:
  pushl $0
801069a0:	6a 00                	push   $0x0
  pushl $18
801069a2:	6a 12                	push   $0x12
  jmp alltraps
801069a4:	e9 e7 f8 ff ff       	jmp    80106290 <alltraps>

801069a9 <vector19>:
.globl vector19
vector19:
  pushl $0
801069a9:	6a 00                	push   $0x0
  pushl $19
801069ab:	6a 13                	push   $0x13
  jmp alltraps
801069ad:	e9 de f8 ff ff       	jmp    80106290 <alltraps>

801069b2 <vector20>:
.globl vector20
vector20:
  pushl $0
801069b2:	6a 00                	push   $0x0
  pushl $20
801069b4:	6a 14                	push   $0x14
  jmp alltraps
801069b6:	e9 d5 f8 ff ff       	jmp    80106290 <alltraps>

801069bb <vector21>:
.globl vector21
vector21:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $21
801069bd:	6a 15                	push   $0x15
  jmp alltraps
801069bf:	e9 cc f8 ff ff       	jmp    80106290 <alltraps>

801069c4 <vector22>:
.globl vector22
vector22:
  pushl $0
801069c4:	6a 00                	push   $0x0
  pushl $22
801069c6:	6a 16                	push   $0x16
  jmp alltraps
801069c8:	e9 c3 f8 ff ff       	jmp    80106290 <alltraps>

801069cd <vector23>:
.globl vector23
vector23:
  pushl $0
801069cd:	6a 00                	push   $0x0
  pushl $23
801069cf:	6a 17                	push   $0x17
  jmp alltraps
801069d1:	e9 ba f8 ff ff       	jmp    80106290 <alltraps>

801069d6 <vector24>:
.globl vector24
vector24:
  pushl $0
801069d6:	6a 00                	push   $0x0
  pushl $24
801069d8:	6a 18                	push   $0x18
  jmp alltraps
801069da:	e9 b1 f8 ff ff       	jmp    80106290 <alltraps>

801069df <vector25>:
.globl vector25
vector25:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $25
801069e1:	6a 19                	push   $0x19
  jmp alltraps
801069e3:	e9 a8 f8 ff ff       	jmp    80106290 <alltraps>

801069e8 <vector26>:
.globl vector26
vector26:
  pushl $0
801069e8:	6a 00                	push   $0x0
  pushl $26
801069ea:	6a 1a                	push   $0x1a
  jmp alltraps
801069ec:	e9 9f f8 ff ff       	jmp    80106290 <alltraps>

801069f1 <vector27>:
.globl vector27
vector27:
  pushl $0
801069f1:	6a 00                	push   $0x0
  pushl $27
801069f3:	6a 1b                	push   $0x1b
  jmp alltraps
801069f5:	e9 96 f8 ff ff       	jmp    80106290 <alltraps>

801069fa <vector28>:
.globl vector28
vector28:
  pushl $0
801069fa:	6a 00                	push   $0x0
  pushl $28
801069fc:	6a 1c                	push   $0x1c
  jmp alltraps
801069fe:	e9 8d f8 ff ff       	jmp    80106290 <alltraps>

80106a03 <vector29>:
.globl vector29
vector29:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $29
80106a05:	6a 1d                	push   $0x1d
  jmp alltraps
80106a07:	e9 84 f8 ff ff       	jmp    80106290 <alltraps>

80106a0c <vector30>:
.globl vector30
vector30:
  pushl $0
80106a0c:	6a 00                	push   $0x0
  pushl $30
80106a0e:	6a 1e                	push   $0x1e
  jmp alltraps
80106a10:	e9 7b f8 ff ff       	jmp    80106290 <alltraps>

80106a15 <vector31>:
.globl vector31
vector31:
  pushl $0
80106a15:	6a 00                	push   $0x0
  pushl $31
80106a17:	6a 1f                	push   $0x1f
  jmp alltraps
80106a19:	e9 72 f8 ff ff       	jmp    80106290 <alltraps>

80106a1e <vector32>:
.globl vector32
vector32:
  pushl $0
80106a1e:	6a 00                	push   $0x0
  pushl $32
80106a20:	6a 20                	push   $0x20
  jmp alltraps
80106a22:	e9 69 f8 ff ff       	jmp    80106290 <alltraps>

80106a27 <vector33>:
.globl vector33
vector33:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $33
80106a29:	6a 21                	push   $0x21
  jmp alltraps
80106a2b:	e9 60 f8 ff ff       	jmp    80106290 <alltraps>

80106a30 <vector34>:
.globl vector34
vector34:
  pushl $0
80106a30:	6a 00                	push   $0x0
  pushl $34
80106a32:	6a 22                	push   $0x22
  jmp alltraps
80106a34:	e9 57 f8 ff ff       	jmp    80106290 <alltraps>

80106a39 <vector35>:
.globl vector35
vector35:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $35
80106a3b:	6a 23                	push   $0x23
  jmp alltraps
80106a3d:	e9 4e f8 ff ff       	jmp    80106290 <alltraps>

80106a42 <vector36>:
.globl vector36
vector36:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $36
80106a44:	6a 24                	push   $0x24
  jmp alltraps
80106a46:	e9 45 f8 ff ff       	jmp    80106290 <alltraps>

80106a4b <vector37>:
.globl vector37
vector37:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $37
80106a4d:	6a 25                	push   $0x25
  jmp alltraps
80106a4f:	e9 3c f8 ff ff       	jmp    80106290 <alltraps>

80106a54 <vector38>:
.globl vector38
vector38:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $38
80106a56:	6a 26                	push   $0x26
  jmp alltraps
80106a58:	e9 33 f8 ff ff       	jmp    80106290 <alltraps>

80106a5d <vector39>:
.globl vector39
vector39:
  pushl $0
80106a5d:	6a 00                	push   $0x0
  pushl $39
80106a5f:	6a 27                	push   $0x27
  jmp alltraps
80106a61:	e9 2a f8 ff ff       	jmp    80106290 <alltraps>

80106a66 <vector40>:
.globl vector40
vector40:
  pushl $0
80106a66:	6a 00                	push   $0x0
  pushl $40
80106a68:	6a 28                	push   $0x28
  jmp alltraps
80106a6a:	e9 21 f8 ff ff       	jmp    80106290 <alltraps>

80106a6f <vector41>:
.globl vector41
vector41:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $41
80106a71:	6a 29                	push   $0x29
  jmp alltraps
80106a73:	e9 18 f8 ff ff       	jmp    80106290 <alltraps>

80106a78 <vector42>:
.globl vector42
vector42:
  pushl $0
80106a78:	6a 00                	push   $0x0
  pushl $42
80106a7a:	6a 2a                	push   $0x2a
  jmp alltraps
80106a7c:	e9 0f f8 ff ff       	jmp    80106290 <alltraps>

80106a81 <vector43>:
.globl vector43
vector43:
  pushl $0
80106a81:	6a 00                	push   $0x0
  pushl $43
80106a83:	6a 2b                	push   $0x2b
  jmp alltraps
80106a85:	e9 06 f8 ff ff       	jmp    80106290 <alltraps>

80106a8a <vector44>:
.globl vector44
vector44:
  pushl $0
80106a8a:	6a 00                	push   $0x0
  pushl $44
80106a8c:	6a 2c                	push   $0x2c
  jmp alltraps
80106a8e:	e9 fd f7 ff ff       	jmp    80106290 <alltraps>

80106a93 <vector45>:
.globl vector45
vector45:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $45
80106a95:	6a 2d                	push   $0x2d
  jmp alltraps
80106a97:	e9 f4 f7 ff ff       	jmp    80106290 <alltraps>

80106a9c <vector46>:
.globl vector46
vector46:
  pushl $0
80106a9c:	6a 00                	push   $0x0
  pushl $46
80106a9e:	6a 2e                	push   $0x2e
  jmp alltraps
80106aa0:	e9 eb f7 ff ff       	jmp    80106290 <alltraps>

80106aa5 <vector47>:
.globl vector47
vector47:
  pushl $0
80106aa5:	6a 00                	push   $0x0
  pushl $47
80106aa7:	6a 2f                	push   $0x2f
  jmp alltraps
80106aa9:	e9 e2 f7 ff ff       	jmp    80106290 <alltraps>

80106aae <vector48>:
.globl vector48
vector48:
  pushl $0
80106aae:	6a 00                	push   $0x0
  pushl $48
80106ab0:	6a 30                	push   $0x30
  jmp alltraps
80106ab2:	e9 d9 f7 ff ff       	jmp    80106290 <alltraps>

80106ab7 <vector49>:
.globl vector49
vector49:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $49
80106ab9:	6a 31                	push   $0x31
  jmp alltraps
80106abb:	e9 d0 f7 ff ff       	jmp    80106290 <alltraps>

80106ac0 <vector50>:
.globl vector50
vector50:
  pushl $0
80106ac0:	6a 00                	push   $0x0
  pushl $50
80106ac2:	6a 32                	push   $0x32
  jmp alltraps
80106ac4:	e9 c7 f7 ff ff       	jmp    80106290 <alltraps>

80106ac9 <vector51>:
.globl vector51
vector51:
  pushl $0
80106ac9:	6a 00                	push   $0x0
  pushl $51
80106acb:	6a 33                	push   $0x33
  jmp alltraps
80106acd:	e9 be f7 ff ff       	jmp    80106290 <alltraps>

80106ad2 <vector52>:
.globl vector52
vector52:
  pushl $0
80106ad2:	6a 00                	push   $0x0
  pushl $52
80106ad4:	6a 34                	push   $0x34
  jmp alltraps
80106ad6:	e9 b5 f7 ff ff       	jmp    80106290 <alltraps>

80106adb <vector53>:
.globl vector53
vector53:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $53
80106add:	6a 35                	push   $0x35
  jmp alltraps
80106adf:	e9 ac f7 ff ff       	jmp    80106290 <alltraps>

80106ae4 <vector54>:
.globl vector54
vector54:
  pushl $0
80106ae4:	6a 00                	push   $0x0
  pushl $54
80106ae6:	6a 36                	push   $0x36
  jmp alltraps
80106ae8:	e9 a3 f7 ff ff       	jmp    80106290 <alltraps>

80106aed <vector55>:
.globl vector55
vector55:
  pushl $0
80106aed:	6a 00                	push   $0x0
  pushl $55
80106aef:	6a 37                	push   $0x37
  jmp alltraps
80106af1:	e9 9a f7 ff ff       	jmp    80106290 <alltraps>

80106af6 <vector56>:
.globl vector56
vector56:
  pushl $0
80106af6:	6a 00                	push   $0x0
  pushl $56
80106af8:	6a 38                	push   $0x38
  jmp alltraps
80106afa:	e9 91 f7 ff ff       	jmp    80106290 <alltraps>

80106aff <vector57>:
.globl vector57
vector57:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $57
80106b01:	6a 39                	push   $0x39
  jmp alltraps
80106b03:	e9 88 f7 ff ff       	jmp    80106290 <alltraps>

80106b08 <vector58>:
.globl vector58
vector58:
  pushl $0
80106b08:	6a 00                	push   $0x0
  pushl $58
80106b0a:	6a 3a                	push   $0x3a
  jmp alltraps
80106b0c:	e9 7f f7 ff ff       	jmp    80106290 <alltraps>

80106b11 <vector59>:
.globl vector59
vector59:
  pushl $0
80106b11:	6a 00                	push   $0x0
  pushl $59
80106b13:	6a 3b                	push   $0x3b
  jmp alltraps
80106b15:	e9 76 f7 ff ff       	jmp    80106290 <alltraps>

80106b1a <vector60>:
.globl vector60
vector60:
  pushl $0
80106b1a:	6a 00                	push   $0x0
  pushl $60
80106b1c:	6a 3c                	push   $0x3c
  jmp alltraps
80106b1e:	e9 6d f7 ff ff       	jmp    80106290 <alltraps>

80106b23 <vector61>:
.globl vector61
vector61:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $61
80106b25:	6a 3d                	push   $0x3d
  jmp alltraps
80106b27:	e9 64 f7 ff ff       	jmp    80106290 <alltraps>

80106b2c <vector62>:
.globl vector62
vector62:
  pushl $0
80106b2c:	6a 00                	push   $0x0
  pushl $62
80106b2e:	6a 3e                	push   $0x3e
  jmp alltraps
80106b30:	e9 5b f7 ff ff       	jmp    80106290 <alltraps>

80106b35 <vector63>:
.globl vector63
vector63:
  pushl $0
80106b35:	6a 00                	push   $0x0
  pushl $63
80106b37:	6a 3f                	push   $0x3f
  jmp alltraps
80106b39:	e9 52 f7 ff ff       	jmp    80106290 <alltraps>

80106b3e <vector64>:
.globl vector64
vector64:
  pushl $0
80106b3e:	6a 00                	push   $0x0
  pushl $64
80106b40:	6a 40                	push   $0x40
  jmp alltraps
80106b42:	e9 49 f7 ff ff       	jmp    80106290 <alltraps>

80106b47 <vector65>:
.globl vector65
vector65:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $65
80106b49:	6a 41                	push   $0x41
  jmp alltraps
80106b4b:	e9 40 f7 ff ff       	jmp    80106290 <alltraps>

80106b50 <vector66>:
.globl vector66
vector66:
  pushl $0
80106b50:	6a 00                	push   $0x0
  pushl $66
80106b52:	6a 42                	push   $0x42
  jmp alltraps
80106b54:	e9 37 f7 ff ff       	jmp    80106290 <alltraps>

80106b59 <vector67>:
.globl vector67
vector67:
  pushl $0
80106b59:	6a 00                	push   $0x0
  pushl $67
80106b5b:	6a 43                	push   $0x43
  jmp alltraps
80106b5d:	e9 2e f7 ff ff       	jmp    80106290 <alltraps>

80106b62 <vector68>:
.globl vector68
vector68:
  pushl $0
80106b62:	6a 00                	push   $0x0
  pushl $68
80106b64:	6a 44                	push   $0x44
  jmp alltraps
80106b66:	e9 25 f7 ff ff       	jmp    80106290 <alltraps>

80106b6b <vector69>:
.globl vector69
vector69:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $69
80106b6d:	6a 45                	push   $0x45
  jmp alltraps
80106b6f:	e9 1c f7 ff ff       	jmp    80106290 <alltraps>

80106b74 <vector70>:
.globl vector70
vector70:
  pushl $0
80106b74:	6a 00                	push   $0x0
  pushl $70
80106b76:	6a 46                	push   $0x46
  jmp alltraps
80106b78:	e9 13 f7 ff ff       	jmp    80106290 <alltraps>

80106b7d <vector71>:
.globl vector71
vector71:
  pushl $0
80106b7d:	6a 00                	push   $0x0
  pushl $71
80106b7f:	6a 47                	push   $0x47
  jmp alltraps
80106b81:	e9 0a f7 ff ff       	jmp    80106290 <alltraps>

80106b86 <vector72>:
.globl vector72
vector72:
  pushl $0
80106b86:	6a 00                	push   $0x0
  pushl $72
80106b88:	6a 48                	push   $0x48
  jmp alltraps
80106b8a:	e9 01 f7 ff ff       	jmp    80106290 <alltraps>

80106b8f <vector73>:
.globl vector73
vector73:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $73
80106b91:	6a 49                	push   $0x49
  jmp alltraps
80106b93:	e9 f8 f6 ff ff       	jmp    80106290 <alltraps>

80106b98 <vector74>:
.globl vector74
vector74:
  pushl $0
80106b98:	6a 00                	push   $0x0
  pushl $74
80106b9a:	6a 4a                	push   $0x4a
  jmp alltraps
80106b9c:	e9 ef f6 ff ff       	jmp    80106290 <alltraps>

80106ba1 <vector75>:
.globl vector75
vector75:
  pushl $0
80106ba1:	6a 00                	push   $0x0
  pushl $75
80106ba3:	6a 4b                	push   $0x4b
  jmp alltraps
80106ba5:	e9 e6 f6 ff ff       	jmp    80106290 <alltraps>

80106baa <vector76>:
.globl vector76
vector76:
  pushl $0
80106baa:	6a 00                	push   $0x0
  pushl $76
80106bac:	6a 4c                	push   $0x4c
  jmp alltraps
80106bae:	e9 dd f6 ff ff       	jmp    80106290 <alltraps>

80106bb3 <vector77>:
.globl vector77
vector77:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $77
80106bb5:	6a 4d                	push   $0x4d
  jmp alltraps
80106bb7:	e9 d4 f6 ff ff       	jmp    80106290 <alltraps>

80106bbc <vector78>:
.globl vector78
vector78:
  pushl $0
80106bbc:	6a 00                	push   $0x0
  pushl $78
80106bbe:	6a 4e                	push   $0x4e
  jmp alltraps
80106bc0:	e9 cb f6 ff ff       	jmp    80106290 <alltraps>

80106bc5 <vector79>:
.globl vector79
vector79:
  pushl $0
80106bc5:	6a 00                	push   $0x0
  pushl $79
80106bc7:	6a 4f                	push   $0x4f
  jmp alltraps
80106bc9:	e9 c2 f6 ff ff       	jmp    80106290 <alltraps>

80106bce <vector80>:
.globl vector80
vector80:
  pushl $0
80106bce:	6a 00                	push   $0x0
  pushl $80
80106bd0:	6a 50                	push   $0x50
  jmp alltraps
80106bd2:	e9 b9 f6 ff ff       	jmp    80106290 <alltraps>

80106bd7 <vector81>:
.globl vector81
vector81:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $81
80106bd9:	6a 51                	push   $0x51
  jmp alltraps
80106bdb:	e9 b0 f6 ff ff       	jmp    80106290 <alltraps>

80106be0 <vector82>:
.globl vector82
vector82:
  pushl $0
80106be0:	6a 00                	push   $0x0
  pushl $82
80106be2:	6a 52                	push   $0x52
  jmp alltraps
80106be4:	e9 a7 f6 ff ff       	jmp    80106290 <alltraps>

80106be9 <vector83>:
.globl vector83
vector83:
  pushl $0
80106be9:	6a 00                	push   $0x0
  pushl $83
80106beb:	6a 53                	push   $0x53
  jmp alltraps
80106bed:	e9 9e f6 ff ff       	jmp    80106290 <alltraps>

80106bf2 <vector84>:
.globl vector84
vector84:
  pushl $0
80106bf2:	6a 00                	push   $0x0
  pushl $84
80106bf4:	6a 54                	push   $0x54
  jmp alltraps
80106bf6:	e9 95 f6 ff ff       	jmp    80106290 <alltraps>

80106bfb <vector85>:
.globl vector85
vector85:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $85
80106bfd:	6a 55                	push   $0x55
  jmp alltraps
80106bff:	e9 8c f6 ff ff       	jmp    80106290 <alltraps>

80106c04 <vector86>:
.globl vector86
vector86:
  pushl $0
80106c04:	6a 00                	push   $0x0
  pushl $86
80106c06:	6a 56                	push   $0x56
  jmp alltraps
80106c08:	e9 83 f6 ff ff       	jmp    80106290 <alltraps>

80106c0d <vector87>:
.globl vector87
vector87:
  pushl $0
80106c0d:	6a 00                	push   $0x0
  pushl $87
80106c0f:	6a 57                	push   $0x57
  jmp alltraps
80106c11:	e9 7a f6 ff ff       	jmp    80106290 <alltraps>

80106c16 <vector88>:
.globl vector88
vector88:
  pushl $0
80106c16:	6a 00                	push   $0x0
  pushl $88
80106c18:	6a 58                	push   $0x58
  jmp alltraps
80106c1a:	e9 71 f6 ff ff       	jmp    80106290 <alltraps>

80106c1f <vector89>:
.globl vector89
vector89:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $89
80106c21:	6a 59                	push   $0x59
  jmp alltraps
80106c23:	e9 68 f6 ff ff       	jmp    80106290 <alltraps>

80106c28 <vector90>:
.globl vector90
vector90:
  pushl $0
80106c28:	6a 00                	push   $0x0
  pushl $90
80106c2a:	6a 5a                	push   $0x5a
  jmp alltraps
80106c2c:	e9 5f f6 ff ff       	jmp    80106290 <alltraps>

80106c31 <vector91>:
.globl vector91
vector91:
  pushl $0
80106c31:	6a 00                	push   $0x0
  pushl $91
80106c33:	6a 5b                	push   $0x5b
  jmp alltraps
80106c35:	e9 56 f6 ff ff       	jmp    80106290 <alltraps>

80106c3a <vector92>:
.globl vector92
vector92:
  pushl $0
80106c3a:	6a 00                	push   $0x0
  pushl $92
80106c3c:	6a 5c                	push   $0x5c
  jmp alltraps
80106c3e:	e9 4d f6 ff ff       	jmp    80106290 <alltraps>

80106c43 <vector93>:
.globl vector93
vector93:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $93
80106c45:	6a 5d                	push   $0x5d
  jmp alltraps
80106c47:	e9 44 f6 ff ff       	jmp    80106290 <alltraps>

80106c4c <vector94>:
.globl vector94
vector94:
  pushl $0
80106c4c:	6a 00                	push   $0x0
  pushl $94
80106c4e:	6a 5e                	push   $0x5e
  jmp alltraps
80106c50:	e9 3b f6 ff ff       	jmp    80106290 <alltraps>

80106c55 <vector95>:
.globl vector95
vector95:
  pushl $0
80106c55:	6a 00                	push   $0x0
  pushl $95
80106c57:	6a 5f                	push   $0x5f
  jmp alltraps
80106c59:	e9 32 f6 ff ff       	jmp    80106290 <alltraps>

80106c5e <vector96>:
.globl vector96
vector96:
  pushl $0
80106c5e:	6a 00                	push   $0x0
  pushl $96
80106c60:	6a 60                	push   $0x60
  jmp alltraps
80106c62:	e9 29 f6 ff ff       	jmp    80106290 <alltraps>

80106c67 <vector97>:
.globl vector97
vector97:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $97
80106c69:	6a 61                	push   $0x61
  jmp alltraps
80106c6b:	e9 20 f6 ff ff       	jmp    80106290 <alltraps>

80106c70 <vector98>:
.globl vector98
vector98:
  pushl $0
80106c70:	6a 00                	push   $0x0
  pushl $98
80106c72:	6a 62                	push   $0x62
  jmp alltraps
80106c74:	e9 17 f6 ff ff       	jmp    80106290 <alltraps>

80106c79 <vector99>:
.globl vector99
vector99:
  pushl $0
80106c79:	6a 00                	push   $0x0
  pushl $99
80106c7b:	6a 63                	push   $0x63
  jmp alltraps
80106c7d:	e9 0e f6 ff ff       	jmp    80106290 <alltraps>

80106c82 <vector100>:
.globl vector100
vector100:
  pushl $0
80106c82:	6a 00                	push   $0x0
  pushl $100
80106c84:	6a 64                	push   $0x64
  jmp alltraps
80106c86:	e9 05 f6 ff ff       	jmp    80106290 <alltraps>

80106c8b <vector101>:
.globl vector101
vector101:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $101
80106c8d:	6a 65                	push   $0x65
  jmp alltraps
80106c8f:	e9 fc f5 ff ff       	jmp    80106290 <alltraps>

80106c94 <vector102>:
.globl vector102
vector102:
  pushl $0
80106c94:	6a 00                	push   $0x0
  pushl $102
80106c96:	6a 66                	push   $0x66
  jmp alltraps
80106c98:	e9 f3 f5 ff ff       	jmp    80106290 <alltraps>

80106c9d <vector103>:
.globl vector103
vector103:
  pushl $0
80106c9d:	6a 00                	push   $0x0
  pushl $103
80106c9f:	6a 67                	push   $0x67
  jmp alltraps
80106ca1:	e9 ea f5 ff ff       	jmp    80106290 <alltraps>

80106ca6 <vector104>:
.globl vector104
vector104:
  pushl $0
80106ca6:	6a 00                	push   $0x0
  pushl $104
80106ca8:	6a 68                	push   $0x68
  jmp alltraps
80106caa:	e9 e1 f5 ff ff       	jmp    80106290 <alltraps>

80106caf <vector105>:
.globl vector105
vector105:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $105
80106cb1:	6a 69                	push   $0x69
  jmp alltraps
80106cb3:	e9 d8 f5 ff ff       	jmp    80106290 <alltraps>

80106cb8 <vector106>:
.globl vector106
vector106:
  pushl $0
80106cb8:	6a 00                	push   $0x0
  pushl $106
80106cba:	6a 6a                	push   $0x6a
  jmp alltraps
80106cbc:	e9 cf f5 ff ff       	jmp    80106290 <alltraps>

80106cc1 <vector107>:
.globl vector107
vector107:
  pushl $0
80106cc1:	6a 00                	push   $0x0
  pushl $107
80106cc3:	6a 6b                	push   $0x6b
  jmp alltraps
80106cc5:	e9 c6 f5 ff ff       	jmp    80106290 <alltraps>

80106cca <vector108>:
.globl vector108
vector108:
  pushl $0
80106cca:	6a 00                	push   $0x0
  pushl $108
80106ccc:	6a 6c                	push   $0x6c
  jmp alltraps
80106cce:	e9 bd f5 ff ff       	jmp    80106290 <alltraps>

80106cd3 <vector109>:
.globl vector109
vector109:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $109
80106cd5:	6a 6d                	push   $0x6d
  jmp alltraps
80106cd7:	e9 b4 f5 ff ff       	jmp    80106290 <alltraps>

80106cdc <vector110>:
.globl vector110
vector110:
  pushl $0
80106cdc:	6a 00                	push   $0x0
  pushl $110
80106cde:	6a 6e                	push   $0x6e
  jmp alltraps
80106ce0:	e9 ab f5 ff ff       	jmp    80106290 <alltraps>

80106ce5 <vector111>:
.globl vector111
vector111:
  pushl $0
80106ce5:	6a 00                	push   $0x0
  pushl $111
80106ce7:	6a 6f                	push   $0x6f
  jmp alltraps
80106ce9:	e9 a2 f5 ff ff       	jmp    80106290 <alltraps>

80106cee <vector112>:
.globl vector112
vector112:
  pushl $0
80106cee:	6a 00                	push   $0x0
  pushl $112
80106cf0:	6a 70                	push   $0x70
  jmp alltraps
80106cf2:	e9 99 f5 ff ff       	jmp    80106290 <alltraps>

80106cf7 <vector113>:
.globl vector113
vector113:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $113
80106cf9:	6a 71                	push   $0x71
  jmp alltraps
80106cfb:	e9 90 f5 ff ff       	jmp    80106290 <alltraps>

80106d00 <vector114>:
.globl vector114
vector114:
  pushl $0
80106d00:	6a 00                	push   $0x0
  pushl $114
80106d02:	6a 72                	push   $0x72
  jmp alltraps
80106d04:	e9 87 f5 ff ff       	jmp    80106290 <alltraps>

80106d09 <vector115>:
.globl vector115
vector115:
  pushl $0
80106d09:	6a 00                	push   $0x0
  pushl $115
80106d0b:	6a 73                	push   $0x73
  jmp alltraps
80106d0d:	e9 7e f5 ff ff       	jmp    80106290 <alltraps>

80106d12 <vector116>:
.globl vector116
vector116:
  pushl $0
80106d12:	6a 00                	push   $0x0
  pushl $116
80106d14:	6a 74                	push   $0x74
  jmp alltraps
80106d16:	e9 75 f5 ff ff       	jmp    80106290 <alltraps>

80106d1b <vector117>:
.globl vector117
vector117:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $117
80106d1d:	6a 75                	push   $0x75
  jmp alltraps
80106d1f:	e9 6c f5 ff ff       	jmp    80106290 <alltraps>

80106d24 <vector118>:
.globl vector118
vector118:
  pushl $0
80106d24:	6a 00                	push   $0x0
  pushl $118
80106d26:	6a 76                	push   $0x76
  jmp alltraps
80106d28:	e9 63 f5 ff ff       	jmp    80106290 <alltraps>

80106d2d <vector119>:
.globl vector119
vector119:
  pushl $0
80106d2d:	6a 00                	push   $0x0
  pushl $119
80106d2f:	6a 77                	push   $0x77
  jmp alltraps
80106d31:	e9 5a f5 ff ff       	jmp    80106290 <alltraps>

80106d36 <vector120>:
.globl vector120
vector120:
  pushl $0
80106d36:	6a 00                	push   $0x0
  pushl $120
80106d38:	6a 78                	push   $0x78
  jmp alltraps
80106d3a:	e9 51 f5 ff ff       	jmp    80106290 <alltraps>

80106d3f <vector121>:
.globl vector121
vector121:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $121
80106d41:	6a 79                	push   $0x79
  jmp alltraps
80106d43:	e9 48 f5 ff ff       	jmp    80106290 <alltraps>

80106d48 <vector122>:
.globl vector122
vector122:
  pushl $0
80106d48:	6a 00                	push   $0x0
  pushl $122
80106d4a:	6a 7a                	push   $0x7a
  jmp alltraps
80106d4c:	e9 3f f5 ff ff       	jmp    80106290 <alltraps>

80106d51 <vector123>:
.globl vector123
vector123:
  pushl $0
80106d51:	6a 00                	push   $0x0
  pushl $123
80106d53:	6a 7b                	push   $0x7b
  jmp alltraps
80106d55:	e9 36 f5 ff ff       	jmp    80106290 <alltraps>

80106d5a <vector124>:
.globl vector124
vector124:
  pushl $0
80106d5a:	6a 00                	push   $0x0
  pushl $124
80106d5c:	6a 7c                	push   $0x7c
  jmp alltraps
80106d5e:	e9 2d f5 ff ff       	jmp    80106290 <alltraps>

80106d63 <vector125>:
.globl vector125
vector125:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $125
80106d65:	6a 7d                	push   $0x7d
  jmp alltraps
80106d67:	e9 24 f5 ff ff       	jmp    80106290 <alltraps>

80106d6c <vector126>:
.globl vector126
vector126:
  pushl $0
80106d6c:	6a 00                	push   $0x0
  pushl $126
80106d6e:	6a 7e                	push   $0x7e
  jmp alltraps
80106d70:	e9 1b f5 ff ff       	jmp    80106290 <alltraps>

80106d75 <vector127>:
.globl vector127
vector127:
  pushl $0
80106d75:	6a 00                	push   $0x0
  pushl $127
80106d77:	6a 7f                	push   $0x7f
  jmp alltraps
80106d79:	e9 12 f5 ff ff       	jmp    80106290 <alltraps>

80106d7e <vector128>:
.globl vector128
vector128:
  pushl $0
80106d7e:	6a 00                	push   $0x0
  pushl $128
80106d80:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106d85:	e9 06 f5 ff ff       	jmp    80106290 <alltraps>

80106d8a <vector129>:
.globl vector129
vector129:
  pushl $0
80106d8a:	6a 00                	push   $0x0
  pushl $129
80106d8c:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106d91:	e9 fa f4 ff ff       	jmp    80106290 <alltraps>

80106d96 <vector130>:
.globl vector130
vector130:
  pushl $0
80106d96:	6a 00                	push   $0x0
  pushl $130
80106d98:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106d9d:	e9 ee f4 ff ff       	jmp    80106290 <alltraps>

80106da2 <vector131>:
.globl vector131
vector131:
  pushl $0
80106da2:	6a 00                	push   $0x0
  pushl $131
80106da4:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106da9:	e9 e2 f4 ff ff       	jmp    80106290 <alltraps>

80106dae <vector132>:
.globl vector132
vector132:
  pushl $0
80106dae:	6a 00                	push   $0x0
  pushl $132
80106db0:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106db5:	e9 d6 f4 ff ff       	jmp    80106290 <alltraps>

80106dba <vector133>:
.globl vector133
vector133:
  pushl $0
80106dba:	6a 00                	push   $0x0
  pushl $133
80106dbc:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106dc1:	e9 ca f4 ff ff       	jmp    80106290 <alltraps>

80106dc6 <vector134>:
.globl vector134
vector134:
  pushl $0
80106dc6:	6a 00                	push   $0x0
  pushl $134
80106dc8:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106dcd:	e9 be f4 ff ff       	jmp    80106290 <alltraps>

80106dd2 <vector135>:
.globl vector135
vector135:
  pushl $0
80106dd2:	6a 00                	push   $0x0
  pushl $135
80106dd4:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106dd9:	e9 b2 f4 ff ff       	jmp    80106290 <alltraps>

80106dde <vector136>:
.globl vector136
vector136:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $136
80106de0:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106de5:	e9 a6 f4 ff ff       	jmp    80106290 <alltraps>

80106dea <vector137>:
.globl vector137
vector137:
  pushl $0
80106dea:	6a 00                	push   $0x0
  pushl $137
80106dec:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106df1:	e9 9a f4 ff ff       	jmp    80106290 <alltraps>

80106df6 <vector138>:
.globl vector138
vector138:
  pushl $0
80106df6:	6a 00                	push   $0x0
  pushl $138
80106df8:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106dfd:	e9 8e f4 ff ff       	jmp    80106290 <alltraps>

80106e02 <vector139>:
.globl vector139
vector139:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $139
80106e04:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106e09:	e9 82 f4 ff ff       	jmp    80106290 <alltraps>

80106e0e <vector140>:
.globl vector140
vector140:
  pushl $0
80106e0e:	6a 00                	push   $0x0
  pushl $140
80106e10:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106e15:	e9 76 f4 ff ff       	jmp    80106290 <alltraps>

80106e1a <vector141>:
.globl vector141
vector141:
  pushl $0
80106e1a:	6a 00                	push   $0x0
  pushl $141
80106e1c:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106e21:	e9 6a f4 ff ff       	jmp    80106290 <alltraps>

80106e26 <vector142>:
.globl vector142
vector142:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $142
80106e28:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106e2d:	e9 5e f4 ff ff       	jmp    80106290 <alltraps>

80106e32 <vector143>:
.globl vector143
vector143:
  pushl $0
80106e32:	6a 00                	push   $0x0
  pushl $143
80106e34:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106e39:	e9 52 f4 ff ff       	jmp    80106290 <alltraps>

80106e3e <vector144>:
.globl vector144
vector144:
  pushl $0
80106e3e:	6a 00                	push   $0x0
  pushl $144
80106e40:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106e45:	e9 46 f4 ff ff       	jmp    80106290 <alltraps>

80106e4a <vector145>:
.globl vector145
vector145:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $145
80106e4c:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106e51:	e9 3a f4 ff ff       	jmp    80106290 <alltraps>

80106e56 <vector146>:
.globl vector146
vector146:
  pushl $0
80106e56:	6a 00                	push   $0x0
  pushl $146
80106e58:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106e5d:	e9 2e f4 ff ff       	jmp    80106290 <alltraps>

80106e62 <vector147>:
.globl vector147
vector147:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $147
80106e64:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106e69:	e9 22 f4 ff ff       	jmp    80106290 <alltraps>

80106e6e <vector148>:
.globl vector148
vector148:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $148
80106e70:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106e75:	e9 16 f4 ff ff       	jmp    80106290 <alltraps>

80106e7a <vector149>:
.globl vector149
vector149:
  pushl $0
80106e7a:	6a 00                	push   $0x0
  pushl $149
80106e7c:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106e81:	e9 0a f4 ff ff       	jmp    80106290 <alltraps>

80106e86 <vector150>:
.globl vector150
vector150:
  pushl $0
80106e86:	6a 00                	push   $0x0
  pushl $150
80106e88:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106e8d:	e9 fe f3 ff ff       	jmp    80106290 <alltraps>

80106e92 <vector151>:
.globl vector151
vector151:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $151
80106e94:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106e99:	e9 f2 f3 ff ff       	jmp    80106290 <alltraps>

80106e9e <vector152>:
.globl vector152
vector152:
  pushl $0
80106e9e:	6a 00                	push   $0x0
  pushl $152
80106ea0:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106ea5:	e9 e6 f3 ff ff       	jmp    80106290 <alltraps>

80106eaa <vector153>:
.globl vector153
vector153:
  pushl $0
80106eaa:	6a 00                	push   $0x0
  pushl $153
80106eac:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106eb1:	e9 da f3 ff ff       	jmp    80106290 <alltraps>

80106eb6 <vector154>:
.globl vector154
vector154:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $154
80106eb8:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ebd:	e9 ce f3 ff ff       	jmp    80106290 <alltraps>

80106ec2 <vector155>:
.globl vector155
vector155:
  pushl $0
80106ec2:	6a 00                	push   $0x0
  pushl $155
80106ec4:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ec9:	e9 c2 f3 ff ff       	jmp    80106290 <alltraps>

80106ece <vector156>:
.globl vector156
vector156:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $156
80106ed0:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106ed5:	e9 b6 f3 ff ff       	jmp    80106290 <alltraps>

80106eda <vector157>:
.globl vector157
vector157:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $157
80106edc:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106ee1:	e9 aa f3 ff ff       	jmp    80106290 <alltraps>

80106ee6 <vector158>:
.globl vector158
vector158:
  pushl $0
80106ee6:	6a 00                	push   $0x0
  pushl $158
80106ee8:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106eed:	e9 9e f3 ff ff       	jmp    80106290 <alltraps>

80106ef2 <vector159>:
.globl vector159
vector159:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $159
80106ef4:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106ef9:	e9 92 f3 ff ff       	jmp    80106290 <alltraps>

80106efe <vector160>:
.globl vector160
vector160:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $160
80106f00:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106f05:	e9 86 f3 ff ff       	jmp    80106290 <alltraps>

80106f0a <vector161>:
.globl vector161
vector161:
  pushl $0
80106f0a:	6a 00                	push   $0x0
  pushl $161
80106f0c:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106f11:	e9 7a f3 ff ff       	jmp    80106290 <alltraps>

80106f16 <vector162>:
.globl vector162
vector162:
  pushl $0
80106f16:	6a 00                	push   $0x0
  pushl $162
80106f18:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106f1d:	e9 6e f3 ff ff       	jmp    80106290 <alltraps>

80106f22 <vector163>:
.globl vector163
vector163:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $163
80106f24:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106f29:	e9 62 f3 ff ff       	jmp    80106290 <alltraps>

80106f2e <vector164>:
.globl vector164
vector164:
  pushl $0
80106f2e:	6a 00                	push   $0x0
  pushl $164
80106f30:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106f35:	e9 56 f3 ff ff       	jmp    80106290 <alltraps>

80106f3a <vector165>:
.globl vector165
vector165:
  pushl $0
80106f3a:	6a 00                	push   $0x0
  pushl $165
80106f3c:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106f41:	e9 4a f3 ff ff       	jmp    80106290 <alltraps>

80106f46 <vector166>:
.globl vector166
vector166:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $166
80106f48:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106f4d:	e9 3e f3 ff ff       	jmp    80106290 <alltraps>

80106f52 <vector167>:
.globl vector167
vector167:
  pushl $0
80106f52:	6a 00                	push   $0x0
  pushl $167
80106f54:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106f59:	e9 32 f3 ff ff       	jmp    80106290 <alltraps>

80106f5e <vector168>:
.globl vector168
vector168:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $168
80106f60:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106f65:	e9 26 f3 ff ff       	jmp    80106290 <alltraps>

80106f6a <vector169>:
.globl vector169
vector169:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $169
80106f6c:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106f71:	e9 1a f3 ff ff       	jmp    80106290 <alltraps>

80106f76 <vector170>:
.globl vector170
vector170:
  pushl $0
80106f76:	6a 00                	push   $0x0
  pushl $170
80106f78:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106f7d:	e9 0e f3 ff ff       	jmp    80106290 <alltraps>

80106f82 <vector171>:
.globl vector171
vector171:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $171
80106f84:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106f89:	e9 02 f3 ff ff       	jmp    80106290 <alltraps>

80106f8e <vector172>:
.globl vector172
vector172:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $172
80106f90:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106f95:	e9 f6 f2 ff ff       	jmp    80106290 <alltraps>

80106f9a <vector173>:
.globl vector173
vector173:
  pushl $0
80106f9a:	6a 00                	push   $0x0
  pushl $173
80106f9c:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106fa1:	e9 ea f2 ff ff       	jmp    80106290 <alltraps>

80106fa6 <vector174>:
.globl vector174
vector174:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $174
80106fa8:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106fad:	e9 de f2 ff ff       	jmp    80106290 <alltraps>

80106fb2 <vector175>:
.globl vector175
vector175:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $175
80106fb4:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106fb9:	e9 d2 f2 ff ff       	jmp    80106290 <alltraps>

80106fbe <vector176>:
.globl vector176
vector176:
  pushl $0
80106fbe:	6a 00                	push   $0x0
  pushl $176
80106fc0:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106fc5:	e9 c6 f2 ff ff       	jmp    80106290 <alltraps>

80106fca <vector177>:
.globl vector177
vector177:
  pushl $0
80106fca:	6a 00                	push   $0x0
  pushl $177
80106fcc:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106fd1:	e9 ba f2 ff ff       	jmp    80106290 <alltraps>

80106fd6 <vector178>:
.globl vector178
vector178:
  pushl $0
80106fd6:	6a 00                	push   $0x0
  pushl $178
80106fd8:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106fdd:	e9 ae f2 ff ff       	jmp    80106290 <alltraps>

80106fe2 <vector179>:
.globl vector179
vector179:
  pushl $0
80106fe2:	6a 00                	push   $0x0
  pushl $179
80106fe4:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106fe9:	e9 a2 f2 ff ff       	jmp    80106290 <alltraps>

80106fee <vector180>:
.globl vector180
vector180:
  pushl $0
80106fee:	6a 00                	push   $0x0
  pushl $180
80106ff0:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106ff5:	e9 96 f2 ff ff       	jmp    80106290 <alltraps>

80106ffa <vector181>:
.globl vector181
vector181:
  pushl $0
80106ffa:	6a 00                	push   $0x0
  pushl $181
80106ffc:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107001:	e9 8a f2 ff ff       	jmp    80106290 <alltraps>

80107006 <vector182>:
.globl vector182
vector182:
  pushl $0
80107006:	6a 00                	push   $0x0
  pushl $182
80107008:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010700d:	e9 7e f2 ff ff       	jmp    80106290 <alltraps>

80107012 <vector183>:
.globl vector183
vector183:
  pushl $0
80107012:	6a 00                	push   $0x0
  pushl $183
80107014:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107019:	e9 72 f2 ff ff       	jmp    80106290 <alltraps>

8010701e <vector184>:
.globl vector184
vector184:
  pushl $0
8010701e:	6a 00                	push   $0x0
  pushl $184
80107020:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107025:	e9 66 f2 ff ff       	jmp    80106290 <alltraps>

8010702a <vector185>:
.globl vector185
vector185:
  pushl $0
8010702a:	6a 00                	push   $0x0
  pushl $185
8010702c:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107031:	e9 5a f2 ff ff       	jmp    80106290 <alltraps>

80107036 <vector186>:
.globl vector186
vector186:
  pushl $0
80107036:	6a 00                	push   $0x0
  pushl $186
80107038:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010703d:	e9 4e f2 ff ff       	jmp    80106290 <alltraps>

80107042 <vector187>:
.globl vector187
vector187:
  pushl $0
80107042:	6a 00                	push   $0x0
  pushl $187
80107044:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107049:	e9 42 f2 ff ff       	jmp    80106290 <alltraps>

8010704e <vector188>:
.globl vector188
vector188:
  pushl $0
8010704e:	6a 00                	push   $0x0
  pushl $188
80107050:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107055:	e9 36 f2 ff ff       	jmp    80106290 <alltraps>

8010705a <vector189>:
.globl vector189
vector189:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $189
8010705c:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107061:	e9 2a f2 ff ff       	jmp    80106290 <alltraps>

80107066 <vector190>:
.globl vector190
vector190:
  pushl $0
80107066:	6a 00                	push   $0x0
  pushl $190
80107068:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010706d:	e9 1e f2 ff ff       	jmp    80106290 <alltraps>

80107072 <vector191>:
.globl vector191
vector191:
  pushl $0
80107072:	6a 00                	push   $0x0
  pushl $191
80107074:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107079:	e9 12 f2 ff ff       	jmp    80106290 <alltraps>

8010707e <vector192>:
.globl vector192
vector192:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $192
80107080:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107085:	e9 06 f2 ff ff       	jmp    80106290 <alltraps>

8010708a <vector193>:
.globl vector193
vector193:
  pushl $0
8010708a:	6a 00                	push   $0x0
  pushl $193
8010708c:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107091:	e9 fa f1 ff ff       	jmp    80106290 <alltraps>

80107096 <vector194>:
.globl vector194
vector194:
  pushl $0
80107096:	6a 00                	push   $0x0
  pushl $194
80107098:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010709d:	e9 ee f1 ff ff       	jmp    80106290 <alltraps>

801070a2 <vector195>:
.globl vector195
vector195:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $195
801070a4:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801070a9:	e9 e2 f1 ff ff       	jmp    80106290 <alltraps>

801070ae <vector196>:
.globl vector196
vector196:
  pushl $0
801070ae:	6a 00                	push   $0x0
  pushl $196
801070b0:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801070b5:	e9 d6 f1 ff ff       	jmp    80106290 <alltraps>

801070ba <vector197>:
.globl vector197
vector197:
  pushl $0
801070ba:	6a 00                	push   $0x0
  pushl $197
801070bc:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801070c1:	e9 ca f1 ff ff       	jmp    80106290 <alltraps>

801070c6 <vector198>:
.globl vector198
vector198:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $198
801070c8:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801070cd:	e9 be f1 ff ff       	jmp    80106290 <alltraps>

801070d2 <vector199>:
.globl vector199
vector199:
  pushl $0
801070d2:	6a 00                	push   $0x0
  pushl $199
801070d4:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801070d9:	e9 b2 f1 ff ff       	jmp    80106290 <alltraps>

801070de <vector200>:
.globl vector200
vector200:
  pushl $0
801070de:	6a 00                	push   $0x0
  pushl $200
801070e0:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801070e5:	e9 a6 f1 ff ff       	jmp    80106290 <alltraps>

801070ea <vector201>:
.globl vector201
vector201:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $201
801070ec:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801070f1:	e9 9a f1 ff ff       	jmp    80106290 <alltraps>

801070f6 <vector202>:
.globl vector202
vector202:
  pushl $0
801070f6:	6a 00                	push   $0x0
  pushl $202
801070f8:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801070fd:	e9 8e f1 ff ff       	jmp    80106290 <alltraps>

80107102 <vector203>:
.globl vector203
vector203:
  pushl $0
80107102:	6a 00                	push   $0x0
  pushl $203
80107104:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107109:	e9 82 f1 ff ff       	jmp    80106290 <alltraps>

8010710e <vector204>:
.globl vector204
vector204:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $204
80107110:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107115:	e9 76 f1 ff ff       	jmp    80106290 <alltraps>

8010711a <vector205>:
.globl vector205
vector205:
  pushl $0
8010711a:	6a 00                	push   $0x0
  pushl $205
8010711c:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107121:	e9 6a f1 ff ff       	jmp    80106290 <alltraps>

80107126 <vector206>:
.globl vector206
vector206:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $206
80107128:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010712d:	e9 5e f1 ff ff       	jmp    80106290 <alltraps>

80107132 <vector207>:
.globl vector207
vector207:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $207
80107134:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107139:	e9 52 f1 ff ff       	jmp    80106290 <alltraps>

8010713e <vector208>:
.globl vector208
vector208:
  pushl $0
8010713e:	6a 00                	push   $0x0
  pushl $208
80107140:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107145:	e9 46 f1 ff ff       	jmp    80106290 <alltraps>

8010714a <vector209>:
.globl vector209
vector209:
  pushl $0
8010714a:	6a 00                	push   $0x0
  pushl $209
8010714c:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107151:	e9 3a f1 ff ff       	jmp    80106290 <alltraps>

80107156 <vector210>:
.globl vector210
vector210:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $210
80107158:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010715d:	e9 2e f1 ff ff       	jmp    80106290 <alltraps>

80107162 <vector211>:
.globl vector211
vector211:
  pushl $0
80107162:	6a 00                	push   $0x0
  pushl $211
80107164:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107169:	e9 22 f1 ff ff       	jmp    80106290 <alltraps>

8010716e <vector212>:
.globl vector212
vector212:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $212
80107170:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107175:	e9 16 f1 ff ff       	jmp    80106290 <alltraps>

8010717a <vector213>:
.globl vector213
vector213:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $213
8010717c:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107181:	e9 0a f1 ff ff       	jmp    80106290 <alltraps>

80107186 <vector214>:
.globl vector214
vector214:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $214
80107188:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010718d:	e9 fe f0 ff ff       	jmp    80106290 <alltraps>

80107192 <vector215>:
.globl vector215
vector215:
  pushl $0
80107192:	6a 00                	push   $0x0
  pushl $215
80107194:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107199:	e9 f2 f0 ff ff       	jmp    80106290 <alltraps>

8010719e <vector216>:
.globl vector216
vector216:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $216
801071a0:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801071a5:	e9 e6 f0 ff ff       	jmp    80106290 <alltraps>

801071aa <vector217>:
.globl vector217
vector217:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $217
801071ac:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801071b1:	e9 da f0 ff ff       	jmp    80106290 <alltraps>

801071b6 <vector218>:
.globl vector218
vector218:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $218
801071b8:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801071bd:	e9 ce f0 ff ff       	jmp    80106290 <alltraps>

801071c2 <vector219>:
.globl vector219
vector219:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $219
801071c4:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801071c9:	e9 c2 f0 ff ff       	jmp    80106290 <alltraps>

801071ce <vector220>:
.globl vector220
vector220:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $220
801071d0:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801071d5:	e9 b6 f0 ff ff       	jmp    80106290 <alltraps>

801071da <vector221>:
.globl vector221
vector221:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $221
801071dc:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801071e1:	e9 aa f0 ff ff       	jmp    80106290 <alltraps>

801071e6 <vector222>:
.globl vector222
vector222:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $222
801071e8:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801071ed:	e9 9e f0 ff ff       	jmp    80106290 <alltraps>

801071f2 <vector223>:
.globl vector223
vector223:
  pushl $0
801071f2:	6a 00                	push   $0x0
  pushl $223
801071f4:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801071f9:	e9 92 f0 ff ff       	jmp    80106290 <alltraps>

801071fe <vector224>:
.globl vector224
vector224:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $224
80107200:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107205:	e9 86 f0 ff ff       	jmp    80106290 <alltraps>

8010720a <vector225>:
.globl vector225
vector225:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $225
8010720c:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107211:	e9 7a f0 ff ff       	jmp    80106290 <alltraps>

80107216 <vector226>:
.globl vector226
vector226:
  pushl $0
80107216:	6a 00                	push   $0x0
  pushl $226
80107218:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010721d:	e9 6e f0 ff ff       	jmp    80106290 <alltraps>

80107222 <vector227>:
.globl vector227
vector227:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $227
80107224:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107229:	e9 62 f0 ff ff       	jmp    80106290 <alltraps>

8010722e <vector228>:
.globl vector228
vector228:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $228
80107230:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107235:	e9 56 f0 ff ff       	jmp    80106290 <alltraps>

8010723a <vector229>:
.globl vector229
vector229:
  pushl $0
8010723a:	6a 00                	push   $0x0
  pushl $229
8010723c:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107241:	e9 4a f0 ff ff       	jmp    80106290 <alltraps>

80107246 <vector230>:
.globl vector230
vector230:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $230
80107248:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010724d:	e9 3e f0 ff ff       	jmp    80106290 <alltraps>

80107252 <vector231>:
.globl vector231
vector231:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $231
80107254:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107259:	e9 32 f0 ff ff       	jmp    80106290 <alltraps>

8010725e <vector232>:
.globl vector232
vector232:
  pushl $0
8010725e:	6a 00                	push   $0x0
  pushl $232
80107260:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107265:	e9 26 f0 ff ff       	jmp    80106290 <alltraps>

8010726a <vector233>:
.globl vector233
vector233:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $233
8010726c:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107271:	e9 1a f0 ff ff       	jmp    80106290 <alltraps>

80107276 <vector234>:
.globl vector234
vector234:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $234
80107278:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010727d:	e9 0e f0 ff ff       	jmp    80106290 <alltraps>

80107282 <vector235>:
.globl vector235
vector235:
  pushl $0
80107282:	6a 00                	push   $0x0
  pushl $235
80107284:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107289:	e9 02 f0 ff ff       	jmp    80106290 <alltraps>

8010728e <vector236>:
.globl vector236
vector236:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $236
80107290:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107295:	e9 f6 ef ff ff       	jmp    80106290 <alltraps>

8010729a <vector237>:
.globl vector237
vector237:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $237
8010729c:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801072a1:	e9 ea ef ff ff       	jmp    80106290 <alltraps>

801072a6 <vector238>:
.globl vector238
vector238:
  pushl $0
801072a6:	6a 00                	push   $0x0
  pushl $238
801072a8:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801072ad:	e9 de ef ff ff       	jmp    80106290 <alltraps>

801072b2 <vector239>:
.globl vector239
vector239:
  pushl $0
801072b2:	6a 00                	push   $0x0
  pushl $239
801072b4:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801072b9:	e9 d2 ef ff ff       	jmp    80106290 <alltraps>

801072be <vector240>:
.globl vector240
vector240:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $240
801072c0:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801072c5:	e9 c6 ef ff ff       	jmp    80106290 <alltraps>

801072ca <vector241>:
.globl vector241
vector241:
  pushl $0
801072ca:	6a 00                	push   $0x0
  pushl $241
801072cc:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801072d1:	e9 ba ef ff ff       	jmp    80106290 <alltraps>

801072d6 <vector242>:
.globl vector242
vector242:
  pushl $0
801072d6:	6a 00                	push   $0x0
  pushl $242
801072d8:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801072dd:	e9 ae ef ff ff       	jmp    80106290 <alltraps>

801072e2 <vector243>:
.globl vector243
vector243:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $243
801072e4:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801072e9:	e9 a2 ef ff ff       	jmp    80106290 <alltraps>

801072ee <vector244>:
.globl vector244
vector244:
  pushl $0
801072ee:	6a 00                	push   $0x0
  pushl $244
801072f0:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801072f5:	e9 96 ef ff ff       	jmp    80106290 <alltraps>

801072fa <vector245>:
.globl vector245
vector245:
  pushl $0
801072fa:	6a 00                	push   $0x0
  pushl $245
801072fc:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107301:	e9 8a ef ff ff       	jmp    80106290 <alltraps>

80107306 <vector246>:
.globl vector246
vector246:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $246
80107308:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010730d:	e9 7e ef ff ff       	jmp    80106290 <alltraps>

80107312 <vector247>:
.globl vector247
vector247:
  pushl $0
80107312:	6a 00                	push   $0x0
  pushl $247
80107314:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107319:	e9 72 ef ff ff       	jmp    80106290 <alltraps>

8010731e <vector248>:
.globl vector248
vector248:
  pushl $0
8010731e:	6a 00                	push   $0x0
  pushl $248
80107320:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107325:	e9 66 ef ff ff       	jmp    80106290 <alltraps>

8010732a <vector249>:
.globl vector249
vector249:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $249
8010732c:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107331:	e9 5a ef ff ff       	jmp    80106290 <alltraps>

80107336 <vector250>:
.globl vector250
vector250:
  pushl $0
80107336:	6a 00                	push   $0x0
  pushl $250
80107338:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010733d:	e9 4e ef ff ff       	jmp    80106290 <alltraps>

80107342 <vector251>:
.globl vector251
vector251:
  pushl $0
80107342:	6a 00                	push   $0x0
  pushl $251
80107344:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107349:	e9 42 ef ff ff       	jmp    80106290 <alltraps>

8010734e <vector252>:
.globl vector252
vector252:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $252
80107350:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107355:	e9 36 ef ff ff       	jmp    80106290 <alltraps>

8010735a <vector253>:
.globl vector253
vector253:
  pushl $0
8010735a:	6a 00                	push   $0x0
  pushl $253
8010735c:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107361:	e9 2a ef ff ff       	jmp    80106290 <alltraps>

80107366 <vector254>:
.globl vector254
vector254:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $254
80107368:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010736d:	e9 1e ef ff ff       	jmp    80106290 <alltraps>

80107372 <vector255>:
.globl vector255
vector255:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $255
80107374:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107379:	e9 12 ef ff ff       	jmp    80106290 <alltraps>
	...

80107380 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107380:	55                   	push   %ebp
80107381:	89 e5                	mov    %esp,%ebp
80107383:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107386:	8b 45 0c             	mov    0xc(%ebp),%eax
80107389:	83 e8 01             	sub    $0x1,%eax
8010738c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107390:	8b 45 08             	mov    0x8(%ebp),%eax
80107393:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107397:	8b 45 08             	mov    0x8(%ebp),%eax
8010739a:	c1 e8 10             	shr    $0x10,%eax
8010739d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801073a1:	8d 45 fa             	lea    -0x6(%ebp),%eax
801073a4:	0f 01 10             	lgdtl  (%eax)
}
801073a7:	c9                   	leave  
801073a8:	c3                   	ret    

801073a9 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801073a9:	55                   	push   %ebp
801073aa:	89 e5                	mov    %esp,%ebp
801073ac:	83 ec 04             	sub    $0x4,%esp
801073af:	8b 45 08             	mov    0x8(%ebp),%eax
801073b2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801073b6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801073ba:	0f 00 d8             	ltr    %ax
}
801073bd:	c9                   	leave  
801073be:	c3                   	ret    

801073bf <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801073bf:	55                   	push   %ebp
801073c0:	89 e5                	mov    %esp,%ebp
801073c2:	83 ec 04             	sub    $0x4,%esp
801073c5:	8b 45 08             	mov    0x8(%ebp),%eax
801073c8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801073cc:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801073d0:	8e e8                	mov    %eax,%gs
}
801073d2:	c9                   	leave  
801073d3:	c3                   	ret    

801073d4 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801073d4:	55                   	push   %ebp
801073d5:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073d7:	8b 45 08             	mov    0x8(%ebp),%eax
801073da:	0f 22 d8             	mov    %eax,%cr3
}
801073dd:	5d                   	pop    %ebp
801073de:	c3                   	ret    

801073df <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801073df:	55                   	push   %ebp
801073e0:	89 e5                	mov    %esp,%ebp
801073e2:	8b 45 08             	mov    0x8(%ebp),%eax
801073e5:	2d 00 00 00 80       	sub    $0x80000000,%eax
801073ea:	5d                   	pop    %ebp
801073eb:	c3                   	ret    

801073ec <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801073ec:	55                   	push   %ebp
801073ed:	89 e5                	mov    %esp,%ebp
801073ef:	8b 45 08             	mov    0x8(%ebp),%eax
801073f2:	2d 00 00 00 80       	sub    $0x80000000,%eax
801073f7:	5d                   	pop    %ebp
801073f8:	c3                   	ret    

801073f9 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801073f9:	55                   	push   %ebp
801073fa:	89 e5                	mov    %esp,%ebp
801073fc:	53                   	push   %ebx
801073fd:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107400:	e8 73 ba ff ff       	call   80102e78 <cpunum>
80107405:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010740b:	05 20 f9 10 80       	add    $0x8010f920,%eax
80107410:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107413:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107416:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010741c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010741f:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107425:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107428:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010742c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010742f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107433:	83 e2 f0             	and    $0xfffffff0,%edx
80107436:	83 ca 0a             	or     $0xa,%edx
80107439:	88 50 7d             	mov    %dl,0x7d(%eax)
8010743c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010743f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107443:	83 ca 10             	or     $0x10,%edx
80107446:	88 50 7d             	mov    %dl,0x7d(%eax)
80107449:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010744c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107450:	83 e2 9f             	and    $0xffffff9f,%edx
80107453:	88 50 7d             	mov    %dl,0x7d(%eax)
80107456:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107459:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010745d:	83 ca 80             	or     $0xffffff80,%edx
80107460:	88 50 7d             	mov    %dl,0x7d(%eax)
80107463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107466:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010746a:	83 ca 0f             	or     $0xf,%edx
8010746d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107470:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107473:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107477:	83 e2 ef             	and    $0xffffffef,%edx
8010747a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010747d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107480:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107484:	83 e2 df             	and    $0xffffffdf,%edx
80107487:	88 50 7e             	mov    %dl,0x7e(%eax)
8010748a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010748d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107491:	83 ca 40             	or     $0x40,%edx
80107494:	88 50 7e             	mov    %dl,0x7e(%eax)
80107497:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010749a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010749e:	83 ca 80             	or     $0xffffff80,%edx
801074a1:	88 50 7e             	mov    %dl,0x7e(%eax)
801074a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a7:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801074ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ae:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801074b5:	ff ff 
801074b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ba:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801074c1:	00 00 
801074c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c6:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801074cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d0:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801074d7:	83 e2 f0             	and    $0xfffffff0,%edx
801074da:	83 ca 02             	or     $0x2,%edx
801074dd:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801074e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801074ed:	83 ca 10             	or     $0x10,%edx
801074f0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801074f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f9:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107500:	83 e2 9f             	and    $0xffffff9f,%edx
80107503:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107513:	83 ca 80             	or     $0xffffff80,%edx
80107516:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010751c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010751f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107526:	83 ca 0f             	or     $0xf,%edx
80107529:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010752f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107532:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107539:	83 e2 ef             	and    $0xffffffef,%edx
8010753c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107542:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107545:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010754c:	83 e2 df             	and    $0xffffffdf,%edx
8010754f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107555:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107558:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010755f:	83 ca 40             	or     $0x40,%edx
80107562:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107568:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010756b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107572:	83 ca 80             	or     $0xffffff80,%edx
80107575:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010757b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010757e:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107585:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107588:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010758f:	ff ff 
80107591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107594:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010759b:	00 00 
8010759d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a0:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801075a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075aa:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801075b1:	83 e2 f0             	and    $0xfffffff0,%edx
801075b4:	83 ca 0a             	or     $0xa,%edx
801075b7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801075bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801075c7:	83 ca 10             	or     $0x10,%edx
801075ca:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801075d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801075da:	83 ca 60             	or     $0x60,%edx
801075dd:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801075e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e6:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801075ed:	83 ca 80             	or     $0xffffff80,%edx
801075f0:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801075f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107600:	83 ca 0f             	or     $0xf,%edx
80107603:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107609:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010760c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107613:	83 e2 ef             	and    $0xffffffef,%edx
80107616:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010761c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010761f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107626:	83 e2 df             	and    $0xffffffdf,%edx
80107629:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010762f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107632:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107639:	83 ca 40             	or     $0x40,%edx
8010763c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107642:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107645:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010764c:	83 ca 80             	or     $0xffffff80,%edx
8010764f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107655:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107658:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010765f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107662:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107669:	ff ff 
8010766b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010766e:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107675:	00 00 
80107677:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010767a:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107684:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010768b:	83 e2 f0             	and    $0xfffffff0,%edx
8010768e:	83 ca 02             	or     $0x2,%edx
80107691:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801076a1:	83 ca 10             	or     $0x10,%edx
801076a4:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801076aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ad:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801076b4:	83 ca 60             	or     $0x60,%edx
801076b7:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801076bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c0:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801076c7:	83 ca 80             	or     $0xffffff80,%edx
801076ca:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801076d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d3:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801076da:	83 ca 0f             	or     $0xf,%edx
801076dd:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801076e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e6:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801076ed:	83 e2 ef             	and    $0xffffffef,%edx
801076f0:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801076f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f9:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107700:	83 e2 df             	and    $0xffffffdf,%edx
80107703:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010770c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107713:	83 ca 40             	or     $0x40,%edx
80107716:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010771c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010771f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107726:	83 ca 80             	or     $0xffffff80,%edx
80107729:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010772f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107732:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107739:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010773c:	05 b4 00 00 00       	add    $0xb4,%eax
80107741:	89 c3                	mov    %eax,%ebx
80107743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107746:	05 b4 00 00 00       	add    $0xb4,%eax
8010774b:	c1 e8 10             	shr    $0x10,%eax
8010774e:	89 c1                	mov    %eax,%ecx
80107750:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107753:	05 b4 00 00 00       	add    $0xb4,%eax
80107758:	c1 e8 18             	shr    $0x18,%eax
8010775b:	89 c2                	mov    %eax,%edx
8010775d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107760:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107767:	00 00 
80107769:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010776c:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107776:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
8010777c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010777f:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107786:	83 e1 f0             	and    $0xfffffff0,%ecx
80107789:	83 c9 02             	or     $0x2,%ecx
8010778c:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107792:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107795:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010779c:	83 c9 10             	or     $0x10,%ecx
8010779f:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801077a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a8:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801077af:	83 e1 9f             	and    $0xffffff9f,%ecx
801077b2:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801077b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077bb:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801077c2:	83 c9 80             	or     $0xffffff80,%ecx
801077c5:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801077cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ce:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801077d5:	83 e1 f0             	and    $0xfffffff0,%ecx
801077d8:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801077de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e1:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801077e8:	83 e1 ef             	and    $0xffffffef,%ecx
801077eb:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801077f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f4:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801077fb:	83 e1 df             	and    $0xffffffdf,%ecx
801077fe:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107807:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010780e:	83 c9 40             	or     $0x40,%ecx
80107811:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107817:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010781a:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107821:	83 c9 80             	or     $0xffffff80,%ecx
80107824:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010782a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782d:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107836:	83 c0 70             	add    $0x70,%eax
80107839:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107840:	00 
80107841:	89 04 24             	mov    %eax,(%esp)
80107844:	e8 37 fb ff ff       	call   80107380 <lgdt>
  loadgs(SEG_KCPU << 3);
80107849:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107850:	e8 6a fb ff ff       	call   801073bf <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107855:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107858:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010785e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107865:	00 00 00 00 
}
80107869:	83 c4 24             	add    $0x24,%esp
8010786c:	5b                   	pop    %ebx
8010786d:	5d                   	pop    %ebp
8010786e:	c3                   	ret    

8010786f <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010786f:	55                   	push   %ebp
80107870:	89 e5                	mov    %esp,%ebp
80107872:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107875:	8b 45 0c             	mov    0xc(%ebp),%eax
80107878:	c1 e8 16             	shr    $0x16,%eax
8010787b:	c1 e0 02             	shl    $0x2,%eax
8010787e:	03 45 08             	add    0x8(%ebp),%eax
80107881:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107884:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107887:	8b 00                	mov    (%eax),%eax
80107889:	83 e0 01             	and    $0x1,%eax
8010788c:	84 c0                	test   %al,%al
8010788e:	74 17                	je     801078a7 <walkpgdir+0x38>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107890:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107893:	8b 00                	mov    (%eax),%eax
80107895:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010789a:	89 04 24             	mov    %eax,(%esp)
8010789d:	e8 4a fb ff ff       	call   801073ec <p2v>
801078a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801078a5:	eb 4b                	jmp    801078f2 <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801078a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801078ab:	74 0e                	je     801078bb <walkpgdir+0x4c>
801078ad:	e8 4c b2 ff ff       	call   80102afe <kalloc>
801078b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801078b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801078b9:	75 07                	jne    801078c2 <walkpgdir+0x53>
      return 0;
801078bb:	b8 00 00 00 00       	mov    $0x0,%eax
801078c0:	eb 41                	jmp    80107903 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801078c2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801078c9:	00 
801078ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801078d1:	00 
801078d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d5:	89 04 24             	mov    %eax,(%esp)
801078d8:	e8 cd d5 ff ff       	call   80104eaa <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801078dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e0:	89 04 24             	mov    %eax,(%esp)
801078e3:	e8 f7 fa ff ff       	call   801073df <v2p>
801078e8:	89 c2                	mov    %eax,%edx
801078ea:	83 ca 07             	or     $0x7,%edx
801078ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078f0:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801078f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801078f5:	c1 e8 0c             	shr    $0xc,%eax
801078f8:	25 ff 03 00 00       	and    $0x3ff,%eax
801078fd:	c1 e0 02             	shl    $0x2,%eax
80107900:	03 45 f4             	add    -0xc(%ebp),%eax
}
80107903:	c9                   	leave  
80107904:	c3                   	ret    

80107905 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107905:	55                   	push   %ebp
80107906:	89 e5                	mov    %esp,%ebp
80107908:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010790b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010790e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107913:	89 45 ec             	mov    %eax,-0x14(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107916:	8b 45 0c             	mov    0xc(%ebp),%eax
80107919:	03 45 10             	add    0x10(%ebp),%eax
8010791c:	83 e8 01             	sub    $0x1,%eax
8010791f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107924:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107927:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010792e:	00 
8010792f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107932:	89 44 24 04          	mov    %eax,0x4(%esp)
80107936:	8b 45 08             	mov    0x8(%ebp),%eax
80107939:	89 04 24             	mov    %eax,(%esp)
8010793c:	e8 2e ff ff ff       	call   8010786f <walkpgdir>
80107941:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107944:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107948:	75 07                	jne    80107951 <mappages+0x4c>
      return -1;
8010794a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010794f:	eb 46                	jmp    80107997 <mappages+0x92>
    if(*pte & PTE_P)
80107951:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107954:	8b 00                	mov    (%eax),%eax
80107956:	83 e0 01             	and    $0x1,%eax
80107959:	84 c0                	test   %al,%al
8010795b:	74 0c                	je     80107969 <mappages+0x64>
      panic("remap");
8010795d:	c7 04 24 98 87 10 80 	movl   $0x80108798,(%esp)
80107964:	e8 d1 8b ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80107969:	8b 45 18             	mov    0x18(%ebp),%eax
8010796c:	0b 45 14             	or     0x14(%ebp),%eax
8010796f:	89 c2                	mov    %eax,%edx
80107971:	83 ca 01             	or     $0x1,%edx
80107974:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107977:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107979:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010797c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010797f:	74 10                	je     80107991 <mappages+0x8c>
      break;
    a += PGSIZE;
80107981:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
    pa += PGSIZE;
80107988:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010798f:	eb 96                	jmp    80107927 <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107991:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107992:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107997:	c9                   	leave  
80107998:	c3                   	ret    

80107999 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107999:	55                   	push   %ebp
8010799a:	89 e5                	mov    %esp,%ebp
8010799c:	53                   	push   %ebx
8010799d:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801079a0:	e8 59 b1 ff ff       	call   80102afe <kalloc>
801079a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801079a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801079ac:	75 0a                	jne    801079b8 <setupkvm+0x1f>
    return 0;
801079ae:	b8 00 00 00 00       	mov    $0x0,%eax
801079b3:	e9 99 00 00 00       	jmp    80107a51 <setupkvm+0xb8>
  memset(pgdir, 0, PGSIZE);
801079b8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801079bf:	00 
801079c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801079c7:	00 
801079c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079cb:	89 04 24             	mov    %eax,(%esp)
801079ce:	e8 d7 d4 ff ff       	call   80104eaa <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801079d3:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
801079da:	e8 0d fa ff ff       	call   801073ec <p2v>
801079df:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801079e4:	76 0c                	jbe    801079f2 <setupkvm+0x59>
    panic("PHYSTOP too high");
801079e6:	c7 04 24 9e 87 10 80 	movl   $0x8010879e,(%esp)
801079ed:	e8 48 8b ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801079f2:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
801079f9:	eb 49                	jmp    80107a44 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801079fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079fe:	8b 48 0c             	mov    0xc(%eax),%ecx
80107a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a04:	8b 50 04             	mov    0x4(%eax),%edx
80107a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a0a:	8b 58 08             	mov    0x8(%eax),%ebx
80107a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a10:	8b 40 04             	mov    0x4(%eax),%eax
80107a13:	29 c3                	sub    %eax,%ebx
80107a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a18:	8b 00                	mov    (%eax),%eax
80107a1a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107a1e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107a22:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107a26:	89 44 24 04          	mov    %eax,0x4(%esp)
80107a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a2d:	89 04 24             	mov    %eax,(%esp)
80107a30:	e8 d0 fe ff ff       	call   80107905 <mappages>
80107a35:	85 c0                	test   %eax,%eax
80107a37:	79 07                	jns    80107a40 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107a39:	b8 00 00 00 00       	mov    $0x0,%eax
80107a3e:	eb 11                	jmp    80107a51 <setupkvm+0xb8>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a40:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107a44:	b8 e0 b4 10 80       	mov    $0x8010b4e0,%eax
80107a49:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80107a4c:	72 ad                	jb     801079fb <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107a51:	83 c4 34             	add    $0x34,%esp
80107a54:	5b                   	pop    %ebx
80107a55:	5d                   	pop    %ebp
80107a56:	c3                   	ret    

80107a57 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107a57:	55                   	push   %ebp
80107a58:	89 e5                	mov    %esp,%ebp
80107a5a:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107a5d:	e8 37 ff ff ff       	call   80107999 <setupkvm>
80107a62:	a3 b8 29 11 80       	mov    %eax,0x801129b8
  switchkvm();
80107a67:	e8 02 00 00 00       	call   80107a6e <switchkvm>
}
80107a6c:	c9                   	leave  
80107a6d:	c3                   	ret    

80107a6e <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107a6e:	55                   	push   %ebp
80107a6f:	89 e5                	mov    %esp,%ebp
80107a71:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107a74:	a1 b8 29 11 80       	mov    0x801129b8,%eax
80107a79:	89 04 24             	mov    %eax,(%esp)
80107a7c:	e8 5e f9 ff ff       	call   801073df <v2p>
80107a81:	89 04 24             	mov    %eax,(%esp)
80107a84:	e8 4b f9 ff ff       	call   801073d4 <lcr3>
}
80107a89:	c9                   	leave  
80107a8a:	c3                   	ret    

80107a8b <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107a8b:	55                   	push   %ebp
80107a8c:	89 e5                	mov    %esp,%ebp
80107a8e:	53                   	push   %ebx
80107a8f:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107a92:	e8 0d d3 ff ff       	call   80104da4 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107a97:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107a9d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107aa4:	83 c2 08             	add    $0x8,%edx
80107aa7:	89 d3                	mov    %edx,%ebx
80107aa9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107ab0:	83 c2 08             	add    $0x8,%edx
80107ab3:	c1 ea 10             	shr    $0x10,%edx
80107ab6:	89 d1                	mov    %edx,%ecx
80107ab8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107abf:	83 c2 08             	add    $0x8,%edx
80107ac2:	c1 ea 18             	shr    $0x18,%edx
80107ac5:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107acc:	67 00 
80107ace:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107ad5:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107adb:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107ae2:	83 e1 f0             	and    $0xfffffff0,%ecx
80107ae5:	83 c9 09             	or     $0x9,%ecx
80107ae8:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107aee:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107af5:	83 c9 10             	or     $0x10,%ecx
80107af8:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107afe:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107b05:	83 e1 9f             	and    $0xffffff9f,%ecx
80107b08:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107b0e:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107b15:	83 c9 80             	or     $0xffffff80,%ecx
80107b18:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107b1e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107b25:	83 e1 f0             	and    $0xfffffff0,%ecx
80107b28:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107b2e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107b35:	83 e1 ef             	and    $0xffffffef,%ecx
80107b38:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107b3e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107b45:	83 e1 df             	and    $0xffffffdf,%ecx
80107b48:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107b4e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107b55:	83 c9 40             	or     $0x40,%ecx
80107b58:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107b5e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107b65:	83 e1 7f             	and    $0x7f,%ecx
80107b68:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107b6e:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107b74:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b7a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107b81:	83 e2 ef             	and    $0xffffffef,%edx
80107b84:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107b8a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b90:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107b96:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b9c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107ba3:	8b 52 08             	mov    0x8(%edx),%edx
80107ba6:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107bac:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107baf:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107bb6:	e8 ee f7 ff ff       	call   801073a9 <ltr>
  if(p->pgdir == 0)
80107bbb:	8b 45 08             	mov    0x8(%ebp),%eax
80107bbe:	8b 40 04             	mov    0x4(%eax),%eax
80107bc1:	85 c0                	test   %eax,%eax
80107bc3:	75 0c                	jne    80107bd1 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107bc5:	c7 04 24 af 87 10 80 	movl   $0x801087af,(%esp)
80107bcc:	e8 69 89 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107bd1:	8b 45 08             	mov    0x8(%ebp),%eax
80107bd4:	8b 40 04             	mov    0x4(%eax),%eax
80107bd7:	89 04 24             	mov    %eax,(%esp)
80107bda:	e8 00 f8 ff ff       	call   801073df <v2p>
80107bdf:	89 04 24             	mov    %eax,(%esp)
80107be2:	e8 ed f7 ff ff       	call   801073d4 <lcr3>
  popcli();
80107be7:	e8 00 d2 ff ff       	call   80104dec <popcli>
}
80107bec:	83 c4 14             	add    $0x14,%esp
80107bef:	5b                   	pop    %ebx
80107bf0:	5d                   	pop    %ebp
80107bf1:	c3                   	ret    

80107bf2 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107bf2:	55                   	push   %ebp
80107bf3:	89 e5                	mov    %esp,%ebp
80107bf5:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107bf8:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107bff:	76 0c                	jbe    80107c0d <inituvm+0x1b>
    panic("inituvm: more than a page");
80107c01:	c7 04 24 c3 87 10 80 	movl   $0x801087c3,(%esp)
80107c08:	e8 2d 89 ff ff       	call   8010053a <panic>
  mem = kalloc();
80107c0d:	e8 ec ae ff ff       	call   80102afe <kalloc>
80107c12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107c15:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c1c:	00 
80107c1d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c24:	00 
80107c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c28:	89 04 24             	mov    %eax,(%esp)
80107c2b:	e8 7a d2 ff ff       	call   80104eaa <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c33:	89 04 24             	mov    %eax,(%esp)
80107c36:	e8 a4 f7 ff ff       	call   801073df <v2p>
80107c3b:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107c42:	00 
80107c43:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107c47:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c4e:	00 
80107c4f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c56:	00 
80107c57:	8b 45 08             	mov    0x8(%ebp),%eax
80107c5a:	89 04 24             	mov    %eax,(%esp)
80107c5d:	e8 a3 fc ff ff       	call   80107905 <mappages>
  memmove(mem, init, sz);
80107c62:	8b 45 10             	mov    0x10(%ebp),%eax
80107c65:	89 44 24 08          	mov    %eax,0x8(%esp)
80107c69:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c73:	89 04 24             	mov    %eax,(%esp)
80107c76:	e8 02 d3 ff ff       	call   80104f7d <memmove>
}
80107c7b:	c9                   	leave  
80107c7c:	c3                   	ret    

80107c7d <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107c7d:	55                   	push   %ebp
80107c7e:	89 e5                	mov    %esp,%ebp
80107c80:	53                   	push   %ebx
80107c81:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107c84:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c87:	25 ff 0f 00 00       	and    $0xfff,%eax
80107c8c:	85 c0                	test   %eax,%eax
80107c8e:	74 0c                	je     80107c9c <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107c90:	c7 04 24 e0 87 10 80 	movl   $0x801087e0,(%esp)
80107c97:	e8 9e 88 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107c9c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80107ca3:	e9 ae 00 00 00       	jmp    80107d56 <loaduvm+0xd9>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107cab:	8b 55 0c             	mov    0xc(%ebp),%edx
80107cae:	8d 04 02             	lea    (%edx,%eax,1),%eax
80107cb1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107cb8:	00 
80107cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80107cc0:	89 04 24             	mov    %eax,(%esp)
80107cc3:	e8 a7 fb ff ff       	call   8010786f <walkpgdir>
80107cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ccb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ccf:	75 0c                	jne    80107cdd <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107cd1:	c7 04 24 03 88 10 80 	movl   $0x80108803,(%esp)
80107cd8:	e8 5d 88 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80107cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce0:	8b 00                	mov    (%eax),%eax
80107ce2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ce7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(sz - i < PGSIZE)
80107cea:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ced:	8b 55 18             	mov    0x18(%ebp),%edx
80107cf0:	89 d1                	mov    %edx,%ecx
80107cf2:	29 c1                	sub    %eax,%ecx
80107cf4:	89 c8                	mov    %ecx,%eax
80107cf6:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107cfb:	77 11                	ja     80107d0e <loaduvm+0x91>
      n = sz - i;
80107cfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d00:	8b 55 18             	mov    0x18(%ebp),%edx
80107d03:	89 d1                	mov    %edx,%ecx
80107d05:	29 c1                	sub    %eax,%ecx
80107d07:	89 c8                	mov    %ecx,%eax
80107d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d0c:	eb 07                	jmp    80107d15 <loaduvm+0x98>
    else
      n = PGSIZE;
80107d0e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107d15:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d18:	8b 55 14             	mov    0x14(%ebp),%edx
80107d1b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d21:	89 04 24             	mov    %eax,(%esp)
80107d24:	e8 c3 f6 ff ff       	call   801073ec <p2v>
80107d29:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107d2c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107d30:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107d34:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d38:	8b 45 10             	mov    0x10(%ebp),%eax
80107d3b:	89 04 24             	mov    %eax,(%esp)
80107d3e:	e8 25 a0 ff ff       	call   80101d68 <readi>
80107d43:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107d46:	74 07                	je     80107d4f <loaduvm+0xd2>
      return -1;
80107d48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d4d:	eb 18                	jmp    80107d67 <loaduvm+0xea>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107d4f:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
80107d56:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d59:	3b 45 18             	cmp    0x18(%ebp),%eax
80107d5c:	0f 82 46 ff ff ff    	jb     80107ca8 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d67:	83 c4 24             	add    $0x24,%esp
80107d6a:	5b                   	pop    %ebx
80107d6b:	5d                   	pop    %ebp
80107d6c:	c3                   	ret    

80107d6d <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107d6d:	55                   	push   %ebp
80107d6e:	89 e5                	mov    %esp,%ebp
80107d70:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107d73:	8b 45 10             	mov    0x10(%ebp),%eax
80107d76:	85 c0                	test   %eax,%eax
80107d78:	79 0a                	jns    80107d84 <allocuvm+0x17>
    return 0;
80107d7a:	b8 00 00 00 00       	mov    $0x0,%eax
80107d7f:	e9 c1 00 00 00       	jmp    80107e45 <allocuvm+0xd8>
  if(newsz < oldsz)
80107d84:	8b 45 10             	mov    0x10(%ebp),%eax
80107d87:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107d8a:	73 08                	jae    80107d94 <allocuvm+0x27>
    return oldsz;
80107d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d8f:	e9 b1 00 00 00       	jmp    80107e45 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80107d94:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d97:	05 ff 0f 00 00       	add    $0xfff,%eax
80107d9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107da1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107da4:	e9 8d 00 00 00       	jmp    80107e36 <allocuvm+0xc9>
    mem = kalloc();
80107da9:	e8 50 ad ff ff       	call   80102afe <kalloc>
80107dae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107db1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107db5:	75 2c                	jne    80107de3 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80107db7:	c7 04 24 21 88 10 80 	movl   $0x80108821,(%esp)
80107dbe:	e8 d7 85 ff ff       	call   8010039a <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dc6:	89 44 24 08          	mov    %eax,0x8(%esp)
80107dca:	8b 45 10             	mov    0x10(%ebp),%eax
80107dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
80107dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80107dd4:	89 04 24             	mov    %eax,(%esp)
80107dd7:	e8 6b 00 00 00       	call   80107e47 <deallocuvm>
      return 0;
80107ddc:	b8 00 00 00 00       	mov    $0x0,%eax
80107de1:	eb 62                	jmp    80107e45 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80107de3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107dea:	00 
80107deb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107df2:	00 
80107df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107df6:	89 04 24             	mov    %eax,(%esp)
80107df9:	e8 ac d0 ff ff       	call   80104eaa <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e01:	89 04 24             	mov    %eax,(%esp)
80107e04:	e8 d6 f5 ff ff       	call   801073df <v2p>
80107e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e0c:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107e13:	00 
80107e14:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107e18:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e1f:	00 
80107e20:	89 54 24 04          	mov    %edx,0x4(%esp)
80107e24:	8b 45 08             	mov    0x8(%ebp),%eax
80107e27:	89 04 24             	mov    %eax,(%esp)
80107e2a:	e8 d6 fa ff ff       	call   80107905 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107e2f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e39:	3b 45 10             	cmp    0x10(%ebp),%eax
80107e3c:	0f 82 67 ff ff ff    	jb     80107da9 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80107e42:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107e45:	c9                   	leave  
80107e46:	c3                   	ret    

80107e47 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107e47:	55                   	push   %ebp
80107e48:	89 e5                	mov    %esp,%ebp
80107e4a:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107e4d:	8b 45 10             	mov    0x10(%ebp),%eax
80107e50:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e53:	72 08                	jb     80107e5d <deallocuvm+0x16>
    return oldsz;
80107e55:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e58:	e9 a4 00 00 00       	jmp    80107f01 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80107e5d:	8b 45 10             	mov    0x10(%ebp),%eax
80107e60:	05 ff 0f 00 00       	add    $0xfff,%eax
80107e65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107e6d:	e9 80 00 00 00       	jmp    80107ef2 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e75:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107e7c:	00 
80107e7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e81:	8b 45 08             	mov    0x8(%ebp),%eax
80107e84:	89 04 24             	mov    %eax,(%esp)
80107e87:	e8 e3 f9 ff ff       	call   8010786f <walkpgdir>
80107e8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(!pte)
80107e8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107e93:	75 09                	jne    80107e9e <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80107e95:	81 45 ec 00 f0 3f 00 	addl   $0x3ff000,-0x14(%ebp)
80107e9c:	eb 4d                	jmp    80107eeb <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80107e9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ea1:	8b 00                	mov    (%eax),%eax
80107ea3:	83 e0 01             	and    $0x1,%eax
80107ea6:	84 c0                	test   %al,%al
80107ea8:	74 41                	je     80107eeb <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80107eaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ead:	8b 00                	mov    (%eax),%eax
80107eaf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(pa == 0)
80107eb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107ebb:	75 0c                	jne    80107ec9 <deallocuvm+0x82>
        panic("kfree");
80107ebd:	c7 04 24 39 88 10 80 	movl   $0x80108839,(%esp)
80107ec4:	e8 71 86 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80107ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ecc:	89 04 24             	mov    %eax,(%esp)
80107ecf:	e8 18 f5 ff ff       	call   801073ec <p2v>
80107ed4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
80107ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eda:	89 04 24             	mov    %eax,(%esp)
80107edd:	e8 83 ab ff ff       	call   80102a65 <kfree>
      *pte = 0;
80107ee2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ee5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107eeb:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
80107ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ef5:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ef8:	0f 82 74 ff ff ff    	jb     80107e72 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80107efe:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107f01:	c9                   	leave  
80107f02:	c3                   	ret    

80107f03 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107f03:	55                   	push   %ebp
80107f04:	89 e5                	mov    %esp,%ebp
80107f06:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80107f09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107f0d:	75 0c                	jne    80107f1b <freevm+0x18>
    panic("freevm: no pgdir");
80107f0f:	c7 04 24 3f 88 10 80 	movl   $0x8010883f,(%esp)
80107f16:	e8 1f 86 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107f1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f22:	00 
80107f23:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107f2a:	80 
80107f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f2e:	89 04 24             	mov    %eax,(%esp)
80107f31:	e8 11 ff ff ff       	call   80107e47 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107f36:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80107f3d:	eb 3c                	jmp    80107f7b <freevm+0x78>
    if(pgdir[i] & PTE_P){
80107f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f42:	c1 e0 02             	shl    $0x2,%eax
80107f45:	03 45 08             	add    0x8(%ebp),%eax
80107f48:	8b 00                	mov    (%eax),%eax
80107f4a:	83 e0 01             	and    $0x1,%eax
80107f4d:	84 c0                	test   %al,%al
80107f4f:	74 26                	je     80107f77 <freevm+0x74>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80107f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f54:	c1 e0 02             	shl    $0x2,%eax
80107f57:	03 45 08             	add    0x8(%ebp),%eax
80107f5a:	8b 00                	mov    (%eax),%eax
80107f5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f61:	89 04 24             	mov    %eax,(%esp)
80107f64:	e8 83 f4 ff ff       	call   801073ec <p2v>
80107f69:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
80107f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6f:	89 04 24             	mov    %eax,(%esp)
80107f72:	e8 ee aa ff ff       	call   80102a65 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107f77:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80107f7b:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
80107f82:	76 bb                	jbe    80107f3f <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107f84:	8b 45 08             	mov    0x8(%ebp),%eax
80107f87:	89 04 24             	mov    %eax,(%esp)
80107f8a:	e8 d6 aa ff ff       	call   80102a65 <kfree>
}
80107f8f:	c9                   	leave  
80107f90:	c3                   	ret    

80107f91 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107f91:	55                   	push   %ebp
80107f92:	89 e5                	mov    %esp,%ebp
80107f94:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f97:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f9e:	00 
80107f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fa2:	89 44 24 04          	mov    %eax,0x4(%esp)
80107fa6:	8b 45 08             	mov    0x8(%ebp),%eax
80107fa9:	89 04 24             	mov    %eax,(%esp)
80107fac:	e8 be f8 ff ff       	call   8010786f <walkpgdir>
80107fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107fb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107fb8:	75 0c                	jne    80107fc6 <clearpteu+0x35>
    panic("clearpteu");
80107fba:	c7 04 24 50 88 10 80 	movl   $0x80108850,(%esp)
80107fc1:	e8 74 85 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80107fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc9:	8b 00                	mov    (%eax),%eax
80107fcb:	89 c2                	mov    %eax,%edx
80107fcd:	83 e2 fb             	and    $0xfffffffb,%edx
80107fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd3:	89 10                	mov    %edx,(%eax)
}
80107fd5:	c9                   	leave  
80107fd6:	c3                   	ret    

80107fd7 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107fd7:	55                   	push   %ebp
80107fd8:	89 e5                	mov    %esp,%ebp
80107fda:	53                   	push   %ebx
80107fdb:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107fde:	e8 b6 f9 ff ff       	call   80107999 <setupkvm>
80107fe3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107fe6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107fea:	75 0a                	jne    80107ff6 <copyuvm+0x1f>
    return 0;
80107fec:	b8 00 00 00 00       	mov    $0x0,%eax
80107ff1:	e9 fd 00 00 00       	jmp    801080f3 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80107ff6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80107ffd:	e9 cc 00 00 00       	jmp    801080ce <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108002:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108005:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010800c:	00 
8010800d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108011:	8b 45 08             	mov    0x8(%ebp),%eax
80108014:	89 04 24             	mov    %eax,(%esp)
80108017:	e8 53 f8 ff ff       	call   8010786f <walkpgdir>
8010801c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010801f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108023:	75 0c                	jne    80108031 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108025:	c7 04 24 5a 88 10 80 	movl   $0x8010885a,(%esp)
8010802c:	e8 09 85 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80108031:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108034:	8b 00                	mov    (%eax),%eax
80108036:	83 e0 01             	and    $0x1,%eax
80108039:	85 c0                	test   %eax,%eax
8010803b:	75 0c                	jne    80108049 <copyuvm+0x72>
      panic("copyuvm: page not present");
8010803d:	c7 04 24 74 88 10 80 	movl   $0x80108874,(%esp)
80108044:	e8 f1 84 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108049:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010804c:	8b 00                	mov    (%eax),%eax
8010804e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108053:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108059:	8b 00                	mov    (%eax),%eax
8010805b:	25 ff 0f 00 00       	and    $0xfff,%eax
80108060:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mem = kalloc()) == 0)
80108063:	e8 96 aa ff ff       	call   80102afe <kalloc>
80108068:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010806b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010806f:	74 6e                	je     801080df <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108071:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108074:	89 04 24             	mov    %eax,(%esp)
80108077:	e8 70 f3 ff ff       	call   801073ec <p2v>
8010807c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108083:	00 
80108084:	89 44 24 04          	mov    %eax,0x4(%esp)
80108088:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808b:	89 04 24             	mov    %eax,(%esp)
8010808e:	e8 ea ce ff ff       	call   80104f7d <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108093:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80108096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108099:	89 04 24             	mov    %eax,(%esp)
8010809c:	e8 3e f3 ff ff       	call   801073df <v2p>
801080a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
801080a4:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801080a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
801080ac:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080b3:	00 
801080b4:	89 54 24 04          	mov    %edx,0x4(%esp)
801080b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080bb:	89 04 24             	mov    %eax,(%esp)
801080be:	e8 42 f8 ff ff       	call   80107905 <mappages>
801080c3:	85 c0                	test   %eax,%eax
801080c5:	78 1b                	js     801080e2 <copyuvm+0x10b>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801080c7:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
801080ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080d4:	0f 82 28 ff ff ff    	jb     80108002 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801080da:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080dd:	eb 14                	jmp    801080f3 <copyuvm+0x11c>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801080df:	90                   	nop
801080e0:	eb 01                	jmp    801080e3 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
801080e2:	90                   	nop
  }
  return d;

bad:
  freevm(d);
801080e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080e6:	89 04 24             	mov    %eax,(%esp)
801080e9:	e8 15 fe ff ff       	call   80107f03 <freevm>
  return 0;
801080ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801080f3:	83 c4 44             	add    $0x44,%esp
801080f6:	5b                   	pop    %ebx
801080f7:	5d                   	pop    %ebp
801080f8:	c3                   	ret    

801080f9 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801080f9:	55                   	push   %ebp
801080fa:	89 e5                	mov    %esp,%ebp
801080fc:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801080ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108106:	00 
80108107:	8b 45 0c             	mov    0xc(%ebp),%eax
8010810a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010810e:	8b 45 08             	mov    0x8(%ebp),%eax
80108111:	89 04 24             	mov    %eax,(%esp)
80108114:	e8 56 f7 ff ff       	call   8010786f <walkpgdir>
80108119:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010811c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811f:	8b 00                	mov    (%eax),%eax
80108121:	83 e0 01             	and    $0x1,%eax
80108124:	85 c0                	test   %eax,%eax
80108126:	75 07                	jne    8010812f <uva2ka+0x36>
    return 0;
80108128:	b8 00 00 00 00       	mov    $0x0,%eax
8010812d:	eb 25                	jmp    80108154 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
8010812f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108132:	8b 00                	mov    (%eax),%eax
80108134:	83 e0 04             	and    $0x4,%eax
80108137:	85 c0                	test   %eax,%eax
80108139:	75 07                	jne    80108142 <uva2ka+0x49>
    return 0;
8010813b:	b8 00 00 00 00       	mov    $0x0,%eax
80108140:	eb 12                	jmp    80108154 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108145:	8b 00                	mov    (%eax),%eax
80108147:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010814c:	89 04 24             	mov    %eax,(%esp)
8010814f:	e8 98 f2 ff ff       	call   801073ec <p2v>
}
80108154:	c9                   	leave  
80108155:	c3                   	ret    

80108156 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108156:	55                   	push   %ebp
80108157:	89 e5                	mov    %esp,%ebp
80108159:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010815c:	8b 45 10             	mov    0x10(%ebp),%eax
8010815f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(len > 0){
80108162:	e9 8b 00 00 00       	jmp    801081f2 <copyout+0x9c>
    va0 = (uint)PGROUNDDOWN(va);
80108167:	8b 45 0c             	mov    0xc(%ebp),%eax
8010816a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010816f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108172:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108175:	89 44 24 04          	mov    %eax,0x4(%esp)
80108179:	8b 45 08             	mov    0x8(%ebp),%eax
8010817c:	89 04 24             	mov    %eax,(%esp)
8010817f:	e8 75 ff ff ff       	call   801080f9 <uva2ka>
80108184:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pa0 == 0)
80108187:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010818b:	75 07                	jne    80108194 <copyout+0x3e>
      return -1;
8010818d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108192:	eb 6d                	jmp    80108201 <copyout+0xab>
    n = PGSIZE - (va - va0);
80108194:	8b 45 0c             	mov    0xc(%ebp),%eax
80108197:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010819a:	89 d1                	mov    %edx,%ecx
8010819c:	29 c1                	sub    %eax,%ecx
8010819e:	89 c8                	mov    %ecx,%eax
801081a0:	05 00 10 00 00       	add    $0x1000,%eax
801081a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801081a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081ab:	3b 45 14             	cmp    0x14(%ebp),%eax
801081ae:	76 06                	jbe    801081b6 <copyout+0x60>
      n = len;
801081b0:	8b 45 14             	mov    0x14(%ebp),%eax
801081b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801081b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801081bc:	89 d1                	mov    %edx,%ecx
801081be:	29 c1                	sub    %eax,%ecx
801081c0:	89 c8                	mov    %ecx,%eax
801081c2:	03 45 ec             	add    -0x14(%ebp),%eax
801081c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801081c8:	89 54 24 08          	mov    %edx,0x8(%esp)
801081cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
801081cf:	89 54 24 04          	mov    %edx,0x4(%esp)
801081d3:	89 04 24             	mov    %eax,(%esp)
801081d6:	e8 a2 cd ff ff       	call   80104f7d <memmove>
    len -= n;
801081db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081de:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801081e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081e4:	01 45 e8             	add    %eax,-0x18(%ebp)
    va = va0 + PGSIZE;
801081e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ea:	05 00 10 00 00       	add    $0x1000,%eax
801081ef:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801081f2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801081f6:	0f 85 6b ff ff ff    	jne    80108167 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801081fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108201:	c9                   	leave  
80108202:	c3                   	ret    
