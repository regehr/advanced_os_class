
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
8010003a:	c7 44 24 04 bc 82 10 	movl   $0x801082bc,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 44 4c 00 00       	call   80104c92 <initlock>

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
801000be:	e8 f0 4b 00 00       	call   80104cb3 <acquire>

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
80100105:	e8 0a 4c 00 00       	call   80104d14 <release>
        return b;
8010010a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010d:	e9 93 00 00 00       	jmp    801001a5 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100112:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100119:	80 
8010011a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011d:	89 04 24             	mov    %eax,(%esp)
80100120:	e8 9f 48 00 00       	call   801049c4 <sleep>
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
8010017d:	e8 92 4b 00 00       	call   80104d14 <release>
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
80100199:	c7 04 24 c3 82 10 80 	movl   $0x801082c3,(%esp)
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
801001f0:	c7 04 24 d4 82 10 80 	movl   $0x801082d4,(%esp)
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
8010022a:	c7 04 24 db 82 10 80 	movl   $0x801082db,(%esp)
80100231:	e8 04 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100236:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023d:	e8 71 4a 00 00       	call   80104cb3 <acquire>

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
8010029e:	e8 09 48 00 00       	call   80104aac <wakeup>

  release(&bcache.lock);
801002a3:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002aa:	e8 65 4a 00 00       	call   80104d14 <release>
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
801003b5:	e8 f9 48 00 00       	call   80104cb3 <acquire>

  if (fmt == 0)
801003ba:	8b 45 08             	mov    0x8(%ebp),%eax
801003bd:	85 c0                	test   %eax,%eax
801003bf:	75 0c                	jne    801003cd <cprintf+0x33>
    panic("null fmt");
801003c1:	c7 04 24 e2 82 10 80 	movl   $0x801082e2,(%esp)
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
801004ac:	c7 45 f4 eb 82 10 80 	movl   $0x801082eb,-0xc(%ebp)
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
80100533:	e8 dc 47 00 00       	call   80104d14 <release>
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
8010055f:	c7 04 24 f2 82 10 80 	movl   $0x801082f2,(%esp)
80100566:	e8 2f fe ff ff       	call   8010039a <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 24 fe ff ff       	call   8010039a <cprintf>
  cprintf("\n");
80100576:	c7 04 24 01 83 10 80 	movl   $0x80108301,(%esp)
8010057d:	e8 18 fe ff ff       	call   8010039a <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 cf 47 00 00       	call   80104d63 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 03 83 10 80 	movl   $0x80108303,(%esp)
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
801006b0:	e8 20 49 00 00       	call   80104fd5 <memmove>
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
801006df:	e8 1e 48 00 00       	call   80104f02 <memset>
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
80100774:	e8 93 61 00 00       	call   8010690c <uartputc>
80100779:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100780:	e8 87 61 00 00       	call   8010690c <uartputc>
80100785:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078c:	e8 7b 61 00 00       	call   8010690c <uartputc>
80100791:	eb 0b                	jmp    8010079e <consputc+0x50>
  } else
    uartputc(c);
80100793:	8b 45 08             	mov    0x8(%ebp),%eax
80100796:	89 04 24             	mov    %eax,(%esp)
80100799:	e8 6e 61 00 00       	call   8010690c <uartputc>
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
801007b8:	e8 f6 44 00 00       	call   80104cb3 <acquire>
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
801007e8:	e8 71 43 00 00       	call   80104b5e <procdump>
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
801008f5:	e8 b2 41 00 00       	call   80104aac <wakeup>
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
80100919:	e8 f6 43 00 00       	call   80104d14 <release>
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
8010093e:	e8 70 43 00 00       	call   80104cb3 <acquire>
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
8010095c:	e8 b3 43 00 00       	call   80104d14 <release>
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
80100985:	e8 3a 40 00 00       	call   801049c4 <sleep>
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
80100a03:	e8 0c 43 00 00       	call   80104d14 <release>
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
80100a39:	e8 75 42 00 00       	call   80104cb3 <acquire>
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
80100a73:	e8 9c 42 00 00       	call   80104d14 <release>
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
80100a8e:	c7 44 24 04 07 83 10 	movl   $0x80108307,0x4(%esp)
80100a95:	80 
80100a96:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a9d:	e8 f0 41 00 00       	call   80104c92 <initlock>
  initlock(&input.lock, "input");
80100aa2:	c7 44 24 04 0f 83 10 	movl   $0x8010830f,0x4(%esp)
80100aa9:	80 
80100aaa:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100ab1:	e8 dc 41 00 00       	call   80104c92 <initlock>

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
80100b70:	e8 dc 6e 00 00       	call   80107a51 <setupkvm>
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
80100c0e:	e8 12 72 00 00       	call   80107e25 <allocuvm>
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
80100c4b:	e8 e5 70 00 00       	call   80107d35 <loaduvm>
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
80100cb6:	e8 6a 71 00 00       	call   80107e25 <allocuvm>
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
80100cda:	e8 6a 73 00 00       	call   80108049 <clearpteu>
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
80100d09:	e8 75 44 00 00       	call   80105183 <strlen>
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
80100d27:	e8 57 44 00 00       	call   80105183 <strlen>
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
80100d51:	e8 b8 74 00 00       	call   8010820e <copyout>
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
80100df1:	e8 18 74 00 00       	call   8010820e <copyout>
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
80100e48:	e8 e8 42 00 00       	call   80105135 <safestrcpy>

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
80100e9a:	e8 a4 6c 00 00       	call   80107b43 <switchuvm>
  freevm(oldpgdir);
80100e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ea2:	89 04 24             	mov    %eax,(%esp)
80100ea5:	e8 11 71 00 00       	call   80107fbb <freevm>
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
80100edc:	e8 da 70 00 00       	call   80107fbb <freevm>
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
80100f02:	c7 44 24 04 15 83 10 	movl   $0x80108315,0x4(%esp)
80100f09:	80 
80100f0a:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f11:	e8 7c 3d 00 00       	call   80104c92 <initlock>
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
80100f25:	e8 89 3d 00 00       	call   80104cb3 <acquire>
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
80100f4e:	e8 c1 3d 00 00       	call   80104d14 <release>
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
80100f6d:	e8 a2 3d 00 00       	call   80104d14 <release>
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
80100f86:	e8 28 3d 00 00       	call   80104cb3 <acquire>
  if(f->ref < 1)
80100f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80100f8e:	8b 40 04             	mov    0x4(%eax),%eax
80100f91:	85 c0                	test   %eax,%eax
80100f93:	7f 0c                	jg     80100fa1 <filedup+0x28>
    panic("filedup");
80100f95:	c7 04 24 1c 83 10 80 	movl   $0x8010831c,(%esp)
80100f9c:	e8 99 f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa4:	8b 40 04             	mov    0x4(%eax),%eax
80100fa7:	8d 50 01             	lea    0x1(%eax),%edx
80100faa:	8b 45 08             	mov    0x8(%ebp),%eax
80100fad:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fb0:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fb7:	e8 58 3d 00 00       	call   80104d14 <release>
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
80100fce:	e8 e0 3c 00 00       	call   80104cb3 <acquire>
  if(f->ref < 1)
80100fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd6:	8b 40 04             	mov    0x4(%eax),%eax
80100fd9:	85 c0                	test   %eax,%eax
80100fdb:	7f 0c                	jg     80100fe9 <fileclose+0x28>
    panic("fileclose");
80100fdd:	c7 04 24 24 83 10 80 	movl   $0x80108324,(%esp)
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
80101009:	e8 06 3d 00 00       	call   80104d14 <release>
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
80101053:	e8 bc 3c 00 00       	call   80104d14 <release>
  
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
80101194:	c7 04 24 2e 83 10 80 	movl   $0x8010832e,(%esp)
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
801012a0:	c7 04 24 37 83 10 80 	movl   $0x80108337,(%esp)
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
801012d5:	c7 04 24 47 83 10 80 	movl   $0x80108347,(%esp)
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
8010131c:	e8 b4 3c 00 00       	call   80104fd5 <memmove>
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
80101362:	e8 9b 3b 00 00       	call   80104f02 <memset>
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
801014ce:	c7 04 24 51 83 10 80 	movl   $0x80108351,(%esp)
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
80101566:	c7 04 24 67 83 10 80 	movl   $0x80108367,(%esp)
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
801015bc:	c7 44 24 04 7a 83 10 	movl   $0x8010837a,0x4(%esp)
801015c3:	80 
801015c4:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801015cb:	e8 c2 36 00 00       	call   80104c92 <initlock>
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
8010164d:	e8 b0 38 00 00       	call   80104f02 <memset>
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
801016a3:	c7 04 24 81 83 10 80 	movl   $0x80108381,(%esp)
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
8010174d:	e8 83 38 00 00       	call   80104fd5 <memmove>
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
80101777:	e8 37 35 00 00       	call   80104cb3 <acquire>

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
801017c1:	e8 4e 35 00 00       	call   80104d14 <release>
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
801017f5:	c7 04 24 93 83 10 80 	movl   $0x80108393,(%esp)
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
80101833:	e8 dc 34 00 00       	call   80104d14 <release>

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
8010184a:	e8 64 34 00 00       	call   80104cb3 <acquire>
  ip->ref++;
8010184f:	8b 45 08             	mov    0x8(%ebp),%eax
80101852:	8b 40 08             	mov    0x8(%eax),%eax
80101855:	8d 50 01             	lea    0x1(%eax),%edx
80101858:	8b 45 08             	mov    0x8(%ebp),%eax
8010185b:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010185e:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101865:	e8 aa 34 00 00       	call   80104d14 <release>
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
80101885:	c7 04 24 a3 83 10 80 	movl   $0x801083a3,(%esp)
8010188c:	e8 a9 ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101891:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101898:	e8 16 34 00 00       	call   80104cb3 <acquire>
  while(ip->flags & I_BUSY)
8010189d:	eb 13                	jmp    801018b2 <ilock+0x43>
    sleep(ip, &icache.lock);
8010189f:	c7 44 24 04 60 e8 10 	movl   $0x8010e860,0x4(%esp)
801018a6:	80 
801018a7:	8b 45 08             	mov    0x8(%ebp),%eax
801018aa:	89 04 24             	mov    %eax,(%esp)
801018ad:	e8 12 31 00 00       	call   801049c4 <sleep>

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
801018d7:	e8 38 34 00 00       	call   80104d14 <release>

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
80101985:	e8 4b 36 00 00       	call   80104fd5 <memmove>
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
801019b2:	c7 04 24 a9 83 10 80 	movl   $0x801083a9,(%esp)
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
801019e3:	c7 04 24 b8 83 10 80 	movl   $0x801083b8,(%esp)
801019ea:	e8 4b eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019ef:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801019f6:	e8 b8 32 00 00       	call   80104cb3 <acquire>
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
80101a12:	e8 95 30 00 00       	call   80104aac <wakeup>
  release(&icache.lock);
80101a17:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a1e:	e8 f1 32 00 00       	call   80104d14 <release>
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
80101a32:	e8 7c 32 00 00       	call   80104cb3 <acquire>
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
80101a70:	c7 04 24 c0 83 10 80 	movl   $0x801083c0,(%esp)
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
80101a94:	e8 7b 32 00 00       	call   80104d14 <release>
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
80101abf:	e8 ef 31 00 00       	call   80104cb3 <acquire>
    ip->flags = 0;
80101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ace:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad1:	89 04 24             	mov    %eax,(%esp)
80101ad4:	e8 d3 2f 00 00       	call   80104aac <wakeup>
  }
  ip->ref--;
80101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80101adc:	8b 40 08             	mov    0x8(%eax),%eax
80101adf:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae5:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ae8:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101aef:	e8 20 32 00 00       	call   80104d14 <release>
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
80101c04:	c7 04 24 ca 83 10 80 	movl   $0x801083ca,(%esp)
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
80101e9d:	e8 33 31 00 00       	call   80104fd5 <memmove>
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
80102005:	e8 cb 2f 00 00       	call   80104fd5 <memmove>
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
80102087:	e8 f1 2f 00 00       	call   8010507d <strncmp>
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
801020a1:	c7 04 24 dd 83 10 80 	movl   $0x801083dd,(%esp)
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
801020df:	c7 04 24 ef 83 10 80 	movl   $0x801083ef,(%esp)
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
801021c3:	c7 04 24 ef 83 10 80 	movl   $0x801083ef,(%esp)
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
80102209:	e8 c7 2e 00 00       	call   801050d5 <strncpy>
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
8010223b:	c7 04 24 fc 83 10 80 	movl   $0x801083fc,(%esp)
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
801022c2:	e8 0e 2d 00 00       	call   80104fd5 <memmove>
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
801022dd:	e8 f3 2c 00 00       	call   80104fd5 <memmove>
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
8010252a:	c7 44 24 04 04 84 10 	movl   $0x80108404,0x4(%esp)
80102531:	80 
80102532:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102539:	e8 54 27 00 00       	call   80104c92 <initlock>
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
801025d6:	c7 04 24 08 84 10 80 	movl   $0x80108408,(%esp)
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
801026fc:	e8 b2 25 00 00       	call   80104cb3 <acquire>
  if((b = idequeue) == 0){
80102701:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102706:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102709:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010270d:	75 11                	jne    80102720 <ideintr+0x31>
    release(&idelock);
8010270f:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102716:	e8 f9 25 00 00       	call   80104d14 <release>
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
80102789:	e8 1e 23 00 00       	call   80104aac <wakeup>
  
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
801027ab:	e8 64 25 00 00       	call   80104d14 <release>
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
801027c4:	c7 04 24 11 84 10 80 	movl   $0x80108411,(%esp)
801027cb:	e8 6a dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027d0:	8b 45 08             	mov    0x8(%ebp),%eax
801027d3:	8b 00                	mov    (%eax),%eax
801027d5:	83 e0 06             	and    $0x6,%eax
801027d8:	83 f8 02             	cmp    $0x2,%eax
801027db:	75 0c                	jne    801027e9 <iderw+0x37>
    panic("iderw: nothing to do");
801027dd:	c7 04 24 25 84 10 80 	movl   $0x80108425,(%esp)
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
801027fc:	c7 04 24 3a 84 10 80 	movl   $0x8010843a,(%esp)
80102803:	e8 32 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102808:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010280f:	e8 9f 24 00 00       	call   80104cb3 <acquire>

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
80102868:	e8 57 21 00 00       	call   801049c4 <sleep>
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
80102884:	e8 8b 24 00 00       	call   80104d14 <release>
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
80102912:	c7 04 24 58 84 10 80 	movl   $0x80108458,(%esp)
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
801029d3:	c7 44 24 04 8a 84 10 	movl   $0x8010848a,0x4(%esp)
801029da:	80 
801029db:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
801029e2:	e8 ab 22 00 00       	call   80104c92 <initlock>
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
80102a92:	c7 04 24 8f 84 10 80 	movl   $0x8010848f,(%esp)
80102a99:	e8 9c da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a9e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102aa5:	00 
80102aa6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102aad:	00 
80102aae:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab1:	89 04 24             	mov    %eax,(%esp)
80102ab4:	e8 49 24 00 00       	call   80104f02 <memset>

  if(kmem.use_lock)
80102ab9:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102abe:	85 c0                	test   %eax,%eax
80102ac0:	74 0c                	je     80102ace <kfree+0x69>
    acquire(&kmem.lock);
80102ac2:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102ac9:	e8 e5 21 00 00       	call   80104cb3 <acquire>
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
80102af7:	e8 18 22 00 00       	call   80104d14 <release>
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
80102b14:	e8 9a 21 00 00       	call   80104cb3 <acquire>
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
80102b41:	e8 ce 21 00 00       	call   80104d14 <release>
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
80102ea9:	c7 04 24 98 84 10 80 	movl   $0x80108498,(%esp)
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
80102fff:	c7 44 24 04 c4 84 10 	movl   $0x801084c4,0x4(%esp)
80103006:	80 
80103007:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010300e:	e8 7f 1c 00 00       	call   80104c92 <initlock>
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
801030c1:	e8 0f 1f 00 00       	call   80104fd5 <memmove>
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
80103213:	e8 9b 1a 00 00       	call   80104cb3 <acquire>
  while (log.busy) {
80103218:	eb 14                	jmp    8010322e <begin_trans+0x28>
    sleep(&log, &log.lock);
8010321a:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
80103221:	80 
80103222:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103229:	e8 96 17 00 00       	call   801049c4 <sleep>

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
80103248:	e8 c7 1a 00 00       	call   80104d14 <release>
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
8010327e:	e8 30 1a 00 00       	call   80104cb3 <acquire>
  log.busy = 0;
80103283:	c7 05 bc f8 10 80 00 	movl   $0x0,0x8010f8bc
8010328a:	00 00 00 
  wakeup(&log);
8010328d:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103294:	e8 13 18 00 00       	call   80104aac <wakeup>
  release(&log.lock);
80103299:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801032a0:	e8 6f 1a 00 00       	call   80104d14 <release>
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
801032c9:	c7 04 24 c8 84 10 80 	movl   $0x801084c8,(%esp)
801032d0:	e8 65 d2 ff ff       	call   8010053a <panic>
  if (!log.busy)
801032d5:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
801032da:	85 c0                	test   %eax,%eax
801032dc:	75 0c                	jne    801032ea <log_write+0x43>
    panic("write outside of trans");
801032de:	c7 04 24 de 84 10 80 	movl   $0x801084de,(%esp)
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
8010336d:	e8 63 1c 00 00       	call   80104fd5 <memmove>
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
80103401:	e8 09 47 00 00       	call   80107b0f <kvmalloc>
  mpinit();        // collect info about this machine
80103406:	e8 49 04 00 00       	call   80103854 <mpinit>
  lapicinit();
8010340b:	e8 0c f9 ff ff       	call   80102d1c <lapicinit>
  seginit();       // set up segments
80103410:	e8 9c 40 00 00       	call   801074b1 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103415:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010341b:	0f b6 00             	movzbl (%eax),%eax
8010341e:	0f b6 c0             	movzbl %al,%eax
80103421:	89 44 24 04          	mov    %eax,0x4(%esp)
80103425:	c7 04 24 f5 84 10 80 	movl   $0x801084f5,(%esp)
8010342c:	e8 69 cf ff ff       	call   8010039a <cprintf>
  picinit();       // interrupt controller
80103431:	e8 84 06 00 00       	call   80103aba <picinit>
  ioapicinit();    // another interrupt controller
80103436:	e8 82 f4 ff ff       	call   801028bd <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010343b:	e8 48 d6 ff ff       	call   80100a88 <consoleinit>
  uartinit();      // serial port
80103440:	e8 b6 33 00 00       	call   801067fb <uartinit>
  pinit();         // process table
80103445:	e8 80 0b 00 00       	call   80103fca <pinit>
  rqinit();
8010344a:	e8 97 0b 00 00       	call   80103fe6 <rqinit>
  tvinit();        // trap vectors
8010344f:	e8 5a 2f 00 00       	call   801063ae <tvinit>
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
80103471:	e8 80 2e 00 00       	call   801062f6 <timerinit>
  startothers();   // start other processors
80103476:	e8 7f 00 00 00       	call   801034fa <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010347b:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103482:	8e 
80103483:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
8010348a:	e8 76 f5 ff ff       	call   80102a05 <kinit2>
  userinit();      // first user process
8010348f:	e8 c3 0d 00 00       	call   80104257 <userinit>
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
8010349f:	e8 82 46 00 00       	call   80107b26 <switchkvm>
  seginit();
801034a4:	e8 08 40 00 00       	call   801074b1 <seginit>
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
801034c9:	c7 04 24 0c 85 10 80 	movl   $0x8010850c,(%esp)
801034d0:	e8 c5 ce ff ff       	call   8010039a <cprintf>
  idtinit();       // load idt register
801034d5:	e8 44 30 00 00       	call   8010651e <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034da:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034e0:	05 a8 00 00 00       	add    $0xa8,%eax
801034e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034ec:	00 
801034ed:	89 04 24             	mov    %eax,(%esp)
801034f0:	e8 d5 fe ff ff       	call   801033ca <xchg>
  scheduler();     // start running processes
801034f5:	e8 e2 12 00 00       	call   801047dc <scheduler>

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
80103527:	e8 a9 1a 00 00       	call   80104fd5 <memmove>

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
801036a7:	c7 44 24 04 20 85 10 	movl   $0x80108520,0x4(%esp)
801036ae:	80 
801036af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036b2:	89 04 24             	mov    %eax,(%esp)
801036b5:	e8 bf 18 00 00       	call   80104f79 <memcmp>
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
801037e8:	c7 44 24 04 25 85 10 	movl   $0x80108525,0x4(%esp)
801037ef:	80 
801037f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037f3:	89 04 24             	mov    %eax,(%esp)
801037f6:	e8 7e 17 00 00       	call   80104f79 <memcmp>
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
801038c4:	8b 04 85 68 85 10 80 	mov    -0x7fef7a98(,%eax,4),%eax
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
801038fd:	c7 04 24 2a 85 10 80 	movl   $0x8010852a,(%esp)
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
8010398e:	c7 04 24 48 85 10 80 	movl   $0x80108548,(%esp)
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
80103c93:	c7 44 24 04 7c 85 10 	movl   $0x8010857c,0x4(%esp)
80103c9a:	80 
80103c9b:	89 04 24             	mov    %eax,(%esp)
80103c9e:	e8 ef 0f 00 00       	call   80104c92 <initlock>
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
80103d4b:	e8 63 0f 00 00       	call   80104cb3 <acquire>
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
80103d6e:	e8 39 0d 00 00       	call   80104aac <wakeup>
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
80103d8d:	e8 1a 0d 00 00       	call   80104aac <wakeup>
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
80103db2:	e8 5d 0f 00 00       	call   80104d14 <release>
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
80103dca:	e8 45 0f 00 00       	call   80104d14 <release>
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
80103dde:	e8 d0 0e 00 00       	call   80104cb3 <acquire>
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
80103e0f:	e8 00 0f 00 00       	call   80104d14 <release>
        return -1;
80103e14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e19:	e9 9d 00 00 00       	jmp    80103ebb <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e1e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e21:	05 34 02 00 00       	add    $0x234,%eax
80103e26:	89 04 24             	mov    %eax,(%esp)
80103e29:	e8 7e 0c 00 00       	call   80104aac <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e31:	8b 55 08             	mov    0x8(%ebp),%edx
80103e34:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e3e:	89 14 24             	mov    %edx,(%esp)
80103e41:	e8 7e 0b 00 00       	call   801049c4 <sleep>
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
80103ea8:	e8 ff 0b 00 00       	call   80104aac <wakeup>
  release(&p->lock);
80103ead:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb0:	89 04 24             	mov    %eax,(%esp)
80103eb3:	e8 5c 0e 00 00       	call   80104d14 <release>
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
80103ece:	e8 e0 0d 00 00       	call   80104cb3 <acquire>
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
80103ee8:	e8 27 0e 00 00       	call   80104d14 <release>
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
80103f0a:	e8 b5 0a 00 00       	call   801049c4 <sleep>
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
80103f9a:	e8 0d 0b 00 00       	call   80104aac <wakeup>
  release(&p->lock);
80103f9f:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa2:	89 04 24             	mov    %eax,(%esp)
80103fa5:	e8 6a 0d 00 00       	call   80104d14 <release>
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
80103fd0:	c7 44 24 04 81 85 10 	movl   $0x80108581,0x4(%esp)
80103fd7:	80 
80103fd8:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80103fdf:	e8 ae 0c 00 00       	call   80104c92 <initlock>

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
80103fec:	c7 44 24 04 88 85 10 	movl   $0x80108588,0x4(%esp)
80103ff3:	80 
80103ff4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80103ffb:	e8 92 0c 00 00       	call   80104c92 <initlock>
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
80104033:	e8 7b 0c 00 00       	call   80104cb3 <acquire>
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
80104063:	e8 ac 0c 00 00       	call   80104d14 <release>
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
  p-> priority = 15;
80104090:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104093:	c7 80 80 00 00 00 0f 	movl   $0xf,0x80(%eax)
8010409a:	00 00 00 
  //need to malloc size??
   p->next = 0;
8010409d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040a0:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  release(&ptable.lock);
801040a7:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801040ae:	e8 61 0c 00 00       	call   80104d14 <release>

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
801040fb:	ba 68 63 10 80       	mov    $0x80106368,%edx
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
80104128:	e8 d5 0d 00 00       	call   80104f02 <memset>
  p->context->eip = (uint)forkret;
8010412d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104130:	8b 40 1c             	mov    0x1c(%eax),%eax
80104133:	ba 98 49 10 80       	mov    $0x80104998,%edx
80104138:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010413b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010413e:	c9                   	leave  
8010413f:	c3                   	ret    

80104140 <setpriority>:


int setpriority(int pid, int priority)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  if(priority > 31 || priority < 0)
80104146:	83 7d 0c 1f          	cmpl   $0x1f,0xc(%ebp)
8010414a:	7f 06                	jg     80104152 <setpriority+0x12>
8010414c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104150:	79 07                	jns    80104159 <setpriority+0x19>
    return -1;
80104152:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104157:	eb 3d                	jmp    80104196 <setpriority+0x56>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104159:	c7 45 fc 14 00 11 80 	movl   $0x80110014,-0x4(%ebp)
80104160:	eb 25                	jmp    80104187 <setpriority+0x47>
    {
      if(p->pid == pid)
80104162:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104165:	8b 40 10             	mov    0x10(%eax),%eax
80104168:	3b 45 08             	cmp    0x8(%ebp),%eax
8010416b:	75 13                	jne    80104180 <setpriority+0x40>
        {
          p->priority = priority;
8010416d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104170:	8b 55 0c             	mov    0xc(%ebp),%edx
80104173:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
          return 1;
80104179:	b8 01 00 00 00       	mov    $0x1,%eax
8010417e:	eb 16                	jmp    80104196 <setpriority+0x56>
int setpriority(int pid, int priority)
{
  struct proc *p;
  if(priority > 31 || priority < 0)
    return -1;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104180:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104187:	b8 14 21 11 80       	mov    $0x80112114,%eax
8010418c:	39 45 fc             	cmp    %eax,-0x4(%ebp)
8010418f:	72 d1                	jb     80104162 <setpriority+0x22>
        {
          p->priority = priority;
          return 1;
        }
    }
  return -1; 
80104191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104196:	c9                   	leave  
80104197:	c3                   	ret    

80104198 <ready1>:


int ready1(struct proc * process)
{
80104198:	55                   	push   %ebp
80104199:	89 e5                	mov    %esp,%ebp
8010419b:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  if(!process)
8010419e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801041a2:	75 07                	jne    801041ab <ready1+0x13>
    return -1;
801041a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041a9:	eb 79                	jmp    80104224 <ready1+0x8c>
  if(process->priority > NPRIORITYS || process->priority < 0)
801041ab:	8b 45 08             	mov    0x8(%ebp),%eax
801041ae:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801041b4:	83 f8 20             	cmp    $0x20,%eax
801041b7:	7f 0d                	jg     801041c6 <ready1+0x2e>
801041b9:	8b 45 08             	mov    0x8(%ebp),%eax
801041bc:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801041c2:	85 c0                	test   %eax,%eax
801041c4:	79 07                	jns    801041cd <ready1+0x35>
    return -1;
801041c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041cb:	eb 57                	jmp    80104224 <ready1+0x8c>
  if((p = ready_q.proc[process->priority]))
801041cd:	8b 45 08             	mov    0x8(%ebp),%eax
801041d0:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801041d6:	83 c0 0c             	add    $0xc,%eax
801041d9:	8b 04 85 24 ff 10 80 	mov    -0x7fef00dc(,%eax,4),%eax
801041e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
801041e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801041e7:	74 20                	je     80104209 <ready1+0x71>
    {
      while(p->next)
801041e9:	eb 09                	jmp    801041f4 <ready1+0x5c>
        {
          p = p->next;
801041eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801041ee:	8b 40 7c             	mov    0x7c(%eax),%eax
801041f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return -1;
  if(process->priority > NPRIORITYS || process->priority < 0)
    return -1;
  if((p = ready_q.proc[process->priority]))
    {
      while(p->next)
801041f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801041f7:	8b 40 7c             	mov    0x7c(%eax),%eax
801041fa:	85 c0                	test   %eax,%eax
801041fc:	75 ed                	jne    801041eb <ready1+0x53>
        {
          p = p->next;
        }
      p->next = process;
801041fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104201:	8b 55 08             	mov    0x8(%ebp),%edx
80104204:	89 50 7c             	mov    %edx,0x7c(%eax)
80104207:	eb 16                	jmp    8010421f <ready1+0x87>
    }
  else
    {
      ready_q.proc[process->priority] = process;
80104209:	8b 45 08             	mov    0x8(%ebp),%eax
8010420c:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104212:	8d 50 0c             	lea    0xc(%eax),%edx
80104215:	8b 45 08             	mov    0x8(%ebp),%eax
80104218:	89 04 95 24 ff 10 80 	mov    %eax,-0x7fef00dc(,%edx,4)
    }
  //cprintf("pnt: %d, prio: %d\n", process,  process->priority );
  return 1;
8010421f:	b8 01 00 00 00       	mov    $0x1,%eax

}
80104224:	c9                   	leave  
80104225:	c3                   	ret    

80104226 <ready>:

int ready(struct proc * process)
{
80104226:	55                   	push   %ebp
80104227:	89 e5                	mov    %esp,%ebp
80104229:	83 ec 28             	sub    $0x28,%esp
  int ret;
  acquire(&ptable.lock);
8010422c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104233:	e8 7b 0a 00 00       	call   80104cb3 <acquire>
  ret = ready1(process);
80104238:	8b 45 08             	mov    0x8(%ebp),%eax
8010423b:	89 04 24             	mov    %eax,(%esp)
8010423e:	e8 55 ff ff ff       	call   80104198 <ready1>
80104243:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&ptable.lock);
80104246:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
8010424d:	e8 c2 0a 00 00       	call   80104d14 <release>
  return ret;
80104252:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104255:	c9                   	leave  
80104256:	c3                   	ret    

80104257 <userinit>:
// Set up first user process.


void
userinit(void)
{
80104257:	55                   	push   %ebp
80104258:	89 e5                	mov    %esp,%ebp
8010425a:	83 ec 28             	sub    $0x28,%esp
  cprintf("userinit\n");
8010425d:	c7 04 24 90 85 10 80 	movl   $0x80108590,(%esp)
80104264:	e8 31 c1 ff ff       	call   8010039a <cprintf>
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104269:	e8 b8 fd ff ff       	call   80104026 <allocproc>
8010426e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104271:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104274:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
80104279:	e8 d3 37 00 00       	call   80107a51 <setupkvm>
8010427e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104281:	89 42 04             	mov    %eax,0x4(%edx)
80104284:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104287:	8b 40 04             	mov    0x4(%eax),%eax
8010428a:	85 c0                	test   %eax,%eax
8010428c:	75 0c                	jne    8010429a <userinit+0x43>
    panic("userinit: out of memory?");
8010428e:	c7 04 24 9a 85 10 80 	movl   $0x8010859a,(%esp)
80104295:	e8 a0 c2 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010429a:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010429f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a2:	8b 40 04             	mov    0x4(%eax),%eax
801042a5:	89 54 24 08          	mov    %edx,0x8(%esp)
801042a9:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
801042b0:	80 
801042b1:	89 04 24             	mov    %eax,(%esp)
801042b4:	e8 f1 39 00 00       	call   80107caa <inituvm>
  p->sz = PGSIZE;
801042b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042bc:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801042c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c5:	8b 40 18             	mov    0x18(%eax),%eax
801042c8:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801042cf:	00 
801042d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801042d7:	00 
801042d8:	89 04 24             	mov    %eax,(%esp)
801042db:	e8 22 0c 00 00       	call   80104f02 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e3:	8b 40 18             	mov    0x18(%eax),%eax
801042e6:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ef:	8b 40 18             	mov    0x18(%eax),%eax
801042f2:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801042f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042fb:	8b 40 18             	mov    0x18(%eax),%eax
801042fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104301:	8b 52 18             	mov    0x18(%edx),%edx
80104304:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104308:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010430c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010430f:	8b 40 18             	mov    0x18(%eax),%eax
80104312:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104315:	8b 52 18             	mov    0x18(%edx),%edx
80104318:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010431c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104320:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104323:	8b 40 18             	mov    0x18(%eax),%eax
80104326:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010432d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104330:	8b 40 18             	mov    0x18(%eax),%eax
80104333:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010433a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010433d:	8b 40 18             	mov    0x18(%eax),%eax
80104340:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434a:	83 c0 6c             	add    $0x6c,%eax
8010434d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104354:	00 
80104355:	c7 44 24 04 b3 85 10 	movl   $0x801085b3,0x4(%esp)
8010435c:	80 
8010435d:	89 04 24             	mov    %eax,(%esp)
80104360:	e8 d0 0d 00 00       	call   80105135 <safestrcpy>
  p->cwd = namei("/");
80104365:	c7 04 24 bc 85 10 80 	movl   $0x801085bc,(%esp)
8010436c:	e8 a6 e0 ff ff       	call   80102417 <namei>
80104371:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104374:	89 42 68             	mov    %eax,0x68(%edx)
  cprintf("here\n");
80104377:	c7 04 24 be 85 10 80 	movl   $0x801085be,(%esp)
8010437e:	e8 17 c0 ff ff       	call   8010039a <cprintf>
  p->state = RUNNABLE;
80104383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104386:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  ready(p);
8010438d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104390:	89 04 24             	mov    %eax,(%esp)
80104393:	e8 8e fe ff ff       	call   80104226 <ready>

}
80104398:	c9                   	leave  
80104399:	c3                   	ret    

8010439a <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010439a:	55                   	push   %ebp
8010439b:	89 e5                	mov    %esp,%ebp
8010439d:	83 ec 28             	sub    $0x28,%esp
  uint sz;

  sz = proc->sz;
801043a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043a6:	8b 00                	mov    (%eax),%eax
801043a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801043ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801043af:	7e 34                	jle    801043e5 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801043b1:	8b 45 08             	mov    0x8(%ebp),%eax
801043b4:	89 c2                	mov    %eax,%edx
801043b6:	03 55 f4             	add    -0xc(%ebp),%edx
801043b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043bf:	8b 40 04             	mov    0x4(%eax),%eax
801043c2:	89 54 24 08          	mov    %edx,0x8(%esp)
801043c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043c9:	89 54 24 04          	mov    %edx,0x4(%esp)
801043cd:	89 04 24             	mov    %eax,(%esp)
801043d0:	e8 50 3a 00 00       	call   80107e25 <allocuvm>
801043d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043dc:	75 41                	jne    8010441f <growproc+0x85>
      return -1;
801043de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043e3:	eb 58                	jmp    8010443d <growproc+0xa3>
  } else if(n < 0){
801043e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801043e9:	79 34                	jns    8010441f <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801043eb:	8b 45 08             	mov    0x8(%ebp),%eax
801043ee:	89 c2                	mov    %eax,%edx
801043f0:	03 55 f4             	add    -0xc(%ebp),%edx
801043f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043f9:	8b 40 04             	mov    0x4(%eax),%eax
801043fc:	89 54 24 08          	mov    %edx,0x8(%esp)
80104400:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104403:	89 54 24 04          	mov    %edx,0x4(%esp)
80104407:	89 04 24             	mov    %eax,(%esp)
8010440a:	e8 f0 3a 00 00       	call   80107eff <deallocuvm>
8010440f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104412:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104416:	75 07                	jne    8010441f <growproc+0x85>
      return -1;
80104418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010441d:	eb 1e                	jmp    8010443d <growproc+0xa3>
  }
  proc->sz = sz;
8010441f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104425:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104428:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
8010442a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104430:	89 04 24             	mov    %eax,(%esp)
80104433:	e8 0b 37 00 00       	call   80107b43 <switchuvm>
  return 0;
80104438:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010443d:	c9                   	leave  
8010443e:	c3                   	ret    

8010443f <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010443f:	55                   	push   %ebp
80104440:	89 e5                	mov    %esp,%ebp
80104442:	57                   	push   %edi
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104448:	e8 d9 fb ff ff       	call   80104026 <allocproc>
8010444d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104450:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80104454:	75 0a                	jne    80104460 <fork+0x21>
    return -1;
80104456:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010445b:	e9 45 01 00 00       	jmp    801045a5 <fork+0x166>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104460:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104466:	8b 10                	mov    (%eax),%edx
80104468:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010446e:	8b 40 04             	mov    0x4(%eax),%eax
80104471:	89 54 24 04          	mov    %edx,0x4(%esp)
80104475:	89 04 24             	mov    %eax,(%esp)
80104478:	e8 12 3c 00 00       	call   8010808f <copyuvm>
8010447d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104480:	89 42 04             	mov    %eax,0x4(%edx)
80104483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104486:	8b 40 04             	mov    0x4(%eax),%eax
80104489:	85 c0                	test   %eax,%eax
8010448b:	75 2c                	jne    801044b9 <fork+0x7a>
    kfree(np->kstack);
8010448d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104490:	8b 40 08             	mov    0x8(%eax),%eax
80104493:	89 04 24             	mov    %eax,(%esp)
80104496:	e8 ca e5 ff ff       	call   80102a65 <kfree>
    np->kstack = 0;
8010449b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010449e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801044a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044a8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801044af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044b4:	e9 ec 00 00 00       	jmp    801045a5 <fork+0x166>
  }
  np->sz = proc->sz;
801044b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044bf:	8b 10                	mov    (%eax),%edx
801044c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044c4:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801044c6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801044cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044d0:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801044d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044d6:	8b 50 18             	mov    0x18(%eax),%edx
801044d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044df:	8b 40 18             	mov    0x18(%eax),%eax
801044e2:	89 c3                	mov    %eax,%ebx
801044e4:	b8 13 00 00 00       	mov    $0x13,%eax
801044e9:	89 d7                	mov    %edx,%edi
801044eb:	89 de                	mov    %ebx,%esi
801044ed:	89 c1                	mov    %eax,%ecx
801044ef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801044f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044f4:	8b 40 18             	mov    0x18(%eax),%eax
801044f7:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801044fe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80104505:	eb 3d                	jmp    80104544 <fork+0x105>
    if(proc->ofile[i])
80104507:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010450d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104510:	83 c2 08             	add    $0x8,%edx
80104513:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104517:	85 c0                	test   %eax,%eax
80104519:	74 25                	je     80104540 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
8010451b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
8010451e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104524:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104527:	83 c2 08             	add    $0x8,%edx
8010452a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010452e:	89 04 24             	mov    %eax,(%esp)
80104531:	e8 43 ca ff ff       	call   80100f79 <filedup>
80104536:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104539:	8d 4b 08             	lea    0x8(%ebx),%ecx
8010453c:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104540:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80104544:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
80104548:	7e bd                	jle    80104507 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010454a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104550:	8b 40 68             	mov    0x68(%eax),%eax
80104553:	89 04 24             	mov    %eax,(%esp)
80104556:	e8 e2 d2 ff ff       	call   8010183d <idup>
8010455b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010455e:	89 42 68             	mov    %eax,0x68(%edx)

  pid = np->pid;
80104561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104564:	8b 40 10             	mov    0x10(%eax),%eax
80104567:	89 45 e0             	mov    %eax,-0x20(%ebp)
  np->state = RUNNABLE;
8010456a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010456d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  ready(np);
80104574:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104577:	89 04 24             	mov    %eax,(%esp)
8010457a:	e8 a7 fc ff ff       	call   80104226 <ready>
  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010457f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104585:	8d 50 6c             	lea    0x6c(%eax),%edx
80104588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010458b:	83 c0 6c             	add    $0x6c,%eax
8010458e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104595:	00 
80104596:	89 54 24 04          	mov    %edx,0x4(%esp)
8010459a:	89 04 24             	mov    %eax,(%esp)
8010459d:	e8 93 0b 00 00       	call   80105135 <safestrcpy>
  return pid;
801045a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
801045a5:	83 c4 2c             	add    $0x2c,%esp
801045a8:	5b                   	pop    %ebx
801045a9:	5e                   	pop    %esi
801045aa:	5f                   	pop    %edi
801045ab:	5d                   	pop    %ebp
801045ac:	c3                   	ret    

801045ad <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801045ad:	55                   	push   %ebp
801045ae:	89 e5                	mov    %esp,%ebp
801045b0:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801045b3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801045ba:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801045bf:	39 c2                	cmp    %eax,%edx
801045c1:	75 0c                	jne    801045cf <exit+0x22>
    panic("init exiting");
801045c3:	c7 04 24 c4 85 10 80 	movl   $0x801085c4,(%esp)
801045ca:	e8 6b bf ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801045cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801045d6:	eb 44                	jmp    8010461c <exit+0x6f>
    if(proc->ofile[fd]){
801045d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045e1:	83 c2 08             	add    $0x8,%edx
801045e4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045e8:	85 c0                	test   %eax,%eax
801045ea:	74 2c                	je     80104618 <exit+0x6b>
      fileclose(proc->ofile[fd]);
801045ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045f5:	83 c2 08             	add    $0x8,%edx
801045f8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045fc:	89 04 24             	mov    %eax,(%esp)
801045ff:	e8 bd c9 ff ff       	call   80100fc1 <fileclose>
      proc->ofile[fd] = 0;
80104604:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010460a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010460d:	83 c2 08             	add    $0x8,%edx
80104610:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104617:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104618:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010461c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104620:	7e b6                	jle    801045d8 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
80104622:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104628:	8b 40 68             	mov    0x68(%eax),%eax
8010462b:	89 04 24             	mov    %eax,(%esp)
8010462e:	e8 f2 d3 ff ff       	call   80101a25 <iput>
  proc->cwd = 0;
80104633:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104639:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  acquire(&ptable.lock);
80104640:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104647:	e8 67 06 00 00       	call   80104cb3 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
8010464c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104652:	8b 40 14             	mov    0x14(%eax),%eax
80104655:	89 04 24             	mov    %eax,(%esp)
80104658:	e8 02 04 00 00       	call   80104a5f <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010465d:	c7 45 f0 14 00 11 80 	movl   $0x80110014,-0x10(%ebp)
80104664:	eb 3b                	jmp    801046a1 <exit+0xf4>
    if(p->parent == proc){
80104666:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104669:	8b 50 14             	mov    0x14(%eax),%edx
8010466c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104672:	39 c2                	cmp    %eax,%edx
80104674:	75 24                	jne    8010469a <exit+0xed>
      p->parent = initproc;
80104676:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
8010467c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010467f:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104682:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104685:	8b 40 0c             	mov    0xc(%eax),%eax
80104688:	83 f8 05             	cmp    $0x5,%eax
8010468b:	75 0d                	jne    8010469a <exit+0xed>
        wakeup1(initproc);
8010468d:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104692:	89 04 24             	mov    %eax,(%esp)
80104695:	e8 c5 03 00 00       	call   80104a5f <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010469a:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
801046a1:	b8 14 21 11 80       	mov    $0x80112114,%eax
801046a6:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801046a9:	72 bb                	jb     80104666 <exit+0xb9>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801046ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b1:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801046b8:	e8 e9 01 00 00       	call   801048a6 <sched>
  panic("zombie exit");
801046bd:	c7 04 24 d1 85 10 80 	movl   $0x801085d1,(%esp)
801046c4:	e8 71 be ff ff       	call   8010053a <panic>

801046c9 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801046c9:	55                   	push   %ebp
801046ca:	89 e5                	mov    %esp,%ebp
801046cc:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801046cf:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801046d6:	e8 d8 05 00 00       	call   80104cb3 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801046db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046e2:	c7 45 ec 14 00 11 80 	movl   $0x80110014,-0x14(%ebp)
801046e9:	e9 9d 00 00 00       	jmp    8010478b <wait+0xc2>
      if(p->parent != proc)
801046ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046f1:	8b 50 14             	mov    0x14(%eax),%edx
801046f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046fa:	39 c2                	cmp    %eax,%edx
801046fc:	0f 85 81 00 00 00    	jne    80104783 <wait+0xba>
        continue;
      havekids = 1;
80104702:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104709:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010470c:	8b 40 0c             	mov    0xc(%eax),%eax
8010470f:	83 f8 05             	cmp    $0x5,%eax
80104712:	75 70                	jne    80104784 <wait+0xbb>
        // Found one.
        pid = p->pid;
80104714:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104717:	8b 40 10             	mov    0x10(%eax),%eax
8010471a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kfree(p->kstack);
8010471d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104720:	8b 40 08             	mov    0x8(%eax),%eax
80104723:	89 04 24             	mov    %eax,(%esp)
80104726:	e8 3a e3 ff ff       	call   80102a65 <kfree>
        p->kstack = 0;
8010472b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010472e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104735:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104738:	8b 40 04             	mov    0x4(%eax),%eax
8010473b:	89 04 24             	mov    %eax,(%esp)
8010473e:	e8 78 38 00 00       	call   80107fbb <freevm>
        p->state = UNUSED;
80104743:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104746:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
8010474d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104750:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104757:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010475a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104761:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104764:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104768:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010476b:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104772:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104779:	e8 96 05 00 00       	call   80104d14 <release>
        return pid;
8010477e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104781:	eb 57                	jmp    801047da <wait+0x111>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104783:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104784:	81 45 ec 84 00 00 00 	addl   $0x84,-0x14(%ebp)
8010478b:	b8 14 21 11 80       	mov    $0x80112114,%eax
80104790:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104793:	0f 82 55 ff ff ff    	jb     801046ee <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104799:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010479d:	74 0d                	je     801047ac <wait+0xe3>
8010479f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a5:	8b 40 24             	mov    0x24(%eax),%eax
801047a8:	85 c0                	test   %eax,%eax
801047aa:	74 13                	je     801047bf <wait+0xf6>
      release(&ptable.lock);
801047ac:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801047b3:	e8 5c 05 00 00       	call   80104d14 <release>
      return -1;
801047b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047bd:	eb 1b                	jmp    801047da <wait+0x111>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801047bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047c5:	c7 44 24 04 e0 ff 10 	movl   $0x8010ffe0,0x4(%esp)
801047cc:	80 
801047cd:	89 04 24             	mov    %eax,(%esp)
801047d0:	e8 ef 01 00 00       	call   801049c4 <sleep>
  }
801047d5:	e9 01 ff ff ff       	jmp    801046db <wait+0x12>
}
801047da:	c9                   	leave  
801047db:	c3                   	ret    

801047dc <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801047dc:	55                   	push   %ebp
801047dd:	89 e5                	mov    %esp,%ebp
801047df:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int i ;
  for(;;)
    {
      // Enable interrupts on this processor.
      sti();
801047e2:	e8 dd f7 ff ff       	call   80103fc4 <sti>

      // Loop over process table looking for process to run.
      acquire(&ptable.lock);
801047e7:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801047ee:	e8 c0 04 00 00       	call   80104cb3 <acquire>
      for(i = 0; i < NPRIORITYS; i++)
801047f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801047fa:	e9 8c 00 00 00       	jmp    8010488b <scheduler+0xaf>
        {
          if((p = ready_q.proc[i]))
801047ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104802:	83 c0 0c             	add    $0xc,%eax
80104805:	8b 04 85 24 ff 10 80 	mov    -0x7fef00dc(,%eax,4),%eax
8010480c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010480f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80104813:	74 72                	je     80104887 <scheduler+0xab>
            {
              struct proc *temp = p->next;
80104815:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104818:	8b 40 7c             	mov    0x7c(%eax),%eax
8010481b:	89 45 f4             	mov    %eax,-0xc(%ebp)
              p->next = 0;
8010481e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104821:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
              ready_q.proc[i] = temp;
80104828:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010482b:	8d 50 0c             	lea    0xc(%eax),%edx
8010482e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104831:	89 04 95 24 ff 10 80 	mov    %eax,-0x7fef00dc(,%edx,4)


              //cprintf("process found with pid:%d\n", p->pid);

              proc = p;
80104838:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010483b:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
              switchuvm(p);
80104841:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104844:	89 04 24             	mov    %eax,(%esp)
80104847:	e8 f7 32 00 00       	call   80107b43 <switchuvm>
              p->state = RUNNING;
8010484c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010484f:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
              swtch(&cpu->scheduler, proc->context);
80104856:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010485c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010485f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104866:	83 c2 04             	add    $0x4,%edx
80104869:	89 44 24 04          	mov    %eax,0x4(%esp)
8010486d:	89 14 24             	mov    %edx,(%esp)
80104870:	e8 33 09 00 00       	call   801051a8 <swtch>
              switchkvm();
80104875:	e8 ac 32 00 00       	call   80107b26 <switchkvm>

              // Process is done running for now.
              // It should have changed its p->state before coming back.
              proc = 0;
8010487a:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104881:	00 00 00 00 

              break;
80104885:	eb 0e                	jmp    80104895 <scheduler+0xb9>
      // Enable interrupts on this processor.
      sti();

      // Loop over process table looking for process to run.
      acquire(&ptable.lock);
      for(i = 0; i < NPRIORITYS; i++)
80104887:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010488b:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
8010488f:	0f 8e 6a ff ff ff    	jle    801047ff <scheduler+0x23>

              break;
            }
        }

      release(&ptable.lock);
80104895:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
8010489c:	e8 73 04 00 00       	call   80104d14 <release>
    }
801048a1:	e9 3c ff ff ff       	jmp    801047e2 <scheduler+0x6>

801048a6 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801048a6:	55                   	push   %ebp
801048a7:	89 e5                	mov    %esp,%ebp
801048a9:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
801048ac:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801048b3:	e8 1a 05 00 00       	call   80104dd2 <holding>
801048b8:	85 c0                	test   %eax,%eax
801048ba:	75 0c                	jne    801048c8 <sched+0x22>
    panic("sched ptable.lock");
801048bc:	c7 04 24 dd 85 10 80 	movl   $0x801085dd,(%esp)
801048c3:	e8 72 bc ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
801048c8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801048ce:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801048d4:	83 f8 01             	cmp    $0x1,%eax
801048d7:	74 0c                	je     801048e5 <sched+0x3f>
    panic("sched locks");
801048d9:	c7 04 24 ef 85 10 80 	movl   $0x801085ef,(%esp)
801048e0:	e8 55 bc ff ff       	call   8010053a <panic>
  if(proc->state == RUNNING)
801048e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048eb:	8b 40 0c             	mov    0xc(%eax),%eax
801048ee:	83 f8 04             	cmp    $0x4,%eax
801048f1:	75 0c                	jne    801048ff <sched+0x59>
    panic("sched running");
801048f3:	c7 04 24 fb 85 10 80 	movl   $0x801085fb,(%esp)
801048fa:	e8 3b bc ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
801048ff:	e8 b0 f6 ff ff       	call   80103fb4 <readeflags>
80104904:	25 00 02 00 00       	and    $0x200,%eax
80104909:	85 c0                	test   %eax,%eax
8010490b:	74 0c                	je     80104919 <sched+0x73>
    panic("sched interruptible");
8010490d:	c7 04 24 09 86 10 80 	movl   $0x80108609,(%esp)
80104914:	e8 21 bc ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104919:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010491f:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104925:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104928:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010492e:	8b 40 04             	mov    0x4(%eax),%eax
80104931:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104938:	83 c2 1c             	add    $0x1c,%edx
8010493b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010493f:	89 14 24             	mov    %edx,(%esp)
80104942:	e8 61 08 00 00       	call   801051a8 <swtch>
  cpu->intena = intena;
80104947:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010494d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104950:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104956:	c9                   	leave  
80104957:	c3                   	ret    

80104958 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104958:	55                   	push   %ebp
80104959:	89 e5                	mov    %esp,%ebp
8010495b:	83 ec 18             	sub    $0x18,%esp

  acquire(&ptable.lock);  //DOC: yieldlock
8010495e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104965:	e8 49 03 00 00       	call   80104cb3 <acquire>
  ready1(proc);
8010496a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104970:	89 04 24             	mov    %eax,(%esp)
80104973:	e8 20 f8 ff ff       	call   80104198 <ready1>
  proc->state = RUNNABLE;
80104978:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010497e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104985:	e8 1c ff ff ff       	call   801048a6 <sched>
  release(&ptable.lock);
8010498a:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104991:	e8 7e 03 00 00       	call   80104d14 <release>
}
80104996:	c9                   	leave  
80104997:	c3                   	ret    

80104998 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104998:	55                   	push   %ebp
80104999:	89 e5                	mov    %esp,%ebp
8010499b:	83 ec 18             	sub    $0x18,%esp
  release(&ptable.lock);
8010499e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801049a5:	e8 6a 03 00 00       	call   80104d14 <release>
  static int first = 1;
  // Still holding ptable.lock from scheduler.

  if (first) {
801049aa:	a1 20 b0 10 80       	mov    0x8010b020,%eax
801049af:	85 c0                	test   %eax,%eax
801049b1:	74 0f                	je     801049c2 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801049b3:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
801049ba:	00 00 00 
    initlog();
801049bd:	e8 36 e6 ff ff       	call   80102ff8 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
801049c2:	c9                   	leave  
801049c3:	c3                   	ret    

801049c4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
801049ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049d0:	85 c0                	test   %eax,%eax
801049d2:	75 0c                	jne    801049e0 <sleep+0x1c>
    panic("sleep");
801049d4:	c7 04 24 1d 86 10 80 	movl   $0x8010861d,(%esp)
801049db:	e8 5a bb ff ff       	call   8010053a <panic>

  if(lk == 0)
801049e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801049e4:	75 0c                	jne    801049f2 <sleep+0x2e>
    panic("sleep without lk");
801049e6:	c7 04 24 23 86 10 80 	movl   $0x80108623,(%esp)
801049ed:	e8 48 bb ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801049f2:	81 7d 0c e0 ff 10 80 	cmpl   $0x8010ffe0,0xc(%ebp)
801049f9:	74 17                	je     80104a12 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
801049fb:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104a02:	e8 ac 02 00 00       	call   80104cb3 <acquire>
    release(lk);
80104a07:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a0a:	89 04 24             	mov    %eax,(%esp)
80104a0d:	e8 02 03 00 00       	call   80104d14 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104a12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a18:	8b 55 08             	mov    0x8(%ebp),%edx
80104a1b:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104a1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a24:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104a2b:	e8 76 fe ff ff       	call   801048a6 <sched>

  // Tidy up.
  proc->chan = 0;
80104a30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a36:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104a3d:	81 7d 0c e0 ff 10 80 	cmpl   $0x8010ffe0,0xc(%ebp)
80104a44:	74 17                	je     80104a5d <sleep+0x99>
    release(&ptable.lock);
80104a46:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104a4d:	e8 c2 02 00 00       	call   80104d14 <release>
    acquire(lk);
80104a52:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a55:	89 04 24             	mov    %eax,(%esp)
80104a58:	e8 56 02 00 00       	call   80104cb3 <acquire>
  }
}
80104a5d:	c9                   	leave  
80104a5e:	c3                   	ret    

80104a5f <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104a5f:	55                   	push   %ebp
80104a60:	89 e5                	mov    %esp,%ebp
80104a62:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a65:	c7 45 fc 14 00 11 80 	movl   $0x80110014,-0x4(%ebp)
80104a6c:	eb 32                	jmp    80104aa0 <wakeup1+0x41>
    {
      if(p->state == SLEEPING && p->chan == chan)
80104a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a71:	8b 40 0c             	mov    0xc(%eax),%eax
80104a74:	83 f8 02             	cmp    $0x2,%eax
80104a77:	75 20                	jne    80104a99 <wakeup1+0x3a>
80104a79:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a7c:	8b 40 20             	mov    0x20(%eax),%eax
80104a7f:	3b 45 08             	cmp    0x8(%ebp),%eax
80104a82:	75 15                	jne    80104a99 <wakeup1+0x3a>
        {
          //cprintf("wakeup\n");
          p->state = RUNNABLE;
80104a84:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a87:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
          ready1(p);
80104a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a91:	89 04 24             	mov    %eax,(%esp)
80104a94:	e8 ff f6 ff ff       	call   80104198 <ready1>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a99:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104aa0:	b8 14 21 11 80       	mov    $0x80112114,%eax
80104aa5:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80104aa8:	72 c4                	jb     80104a6e <wakeup1+0xf>
          //cprintf("wakeup\n");
          p->state = RUNNABLE;
          ready1(p);
        }
    }
}
80104aaa:	c9                   	leave  
80104aab:	c3                   	ret    

80104aac <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104aac:	55                   	push   %ebp
80104aad:	89 e5                	mov    %esp,%ebp
80104aaf:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104ab2:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104ab9:	e8 f5 01 00 00       	call   80104cb3 <acquire>
  wakeup1(chan);
80104abe:	8b 45 08             	mov    0x8(%ebp),%eax
80104ac1:	89 04 24             	mov    %eax,(%esp)
80104ac4:	e8 96 ff ff ff       	call   80104a5f <wakeup1>
  release(&ptable.lock);
80104ac9:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104ad0:	e8 3f 02 00 00       	call   80104d14 <release>
}
80104ad5:	c9                   	leave  
80104ad6:	c3                   	ret    

80104ad7 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104ad7:	55                   	push   %ebp
80104ad8:	89 e5                	mov    %esp,%ebp
80104ada:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104add:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104ae4:	e8 ca 01 00 00       	call   80104cb3 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ae9:	c7 45 f4 14 00 11 80 	movl   $0x80110014,-0xc(%ebp)
80104af0:	eb 4f                	jmp    80104b41 <kill+0x6a>
    if(p->pid == pid){
80104af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af5:	8b 40 10             	mov    0x10(%eax),%eax
80104af8:	3b 45 08             	cmp    0x8(%ebp),%eax
80104afb:	75 3d                	jne    80104b3a <kill+0x63>
      p->killed = 1;
80104afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b00:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0a:	8b 40 0c             	mov    0xc(%eax),%eax
80104b0d:	83 f8 02             	cmp    $0x2,%eax
80104b10:	75 15                	jne    80104b27 <kill+0x50>
        {
          p->state = RUNNABLE;
80104b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b15:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
          ready1(p);
80104b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1f:	89 04 24             	mov    %eax,(%esp)
80104b22:	e8 71 f6 ff ff       	call   80104198 <ready1>
        }
      release(&ptable.lock);
80104b27:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104b2e:	e8 e1 01 00 00       	call   80104d14 <release>
      return 0;
80104b33:	b8 00 00 00 00       	mov    $0x0,%eax
80104b38:	eb 22                	jmp    80104b5c <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b3a:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104b41:	b8 14 21 11 80       	mov    $0x80112114,%eax
80104b46:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104b49:	72 a7                	jb     80104af2 <kill+0x1b>
        }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104b4b:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104b52:	e8 bd 01 00 00       	call   80104d14 <release>
  return -1;
80104b57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b5c:	c9                   	leave  
80104b5d:	c3                   	ret    

80104b5e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104b5e:	55                   	push   %ebp
80104b5f:	89 e5                	mov    %esp,%ebp
80104b61:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b64:	c7 45 f0 14 00 11 80 	movl   $0x80110014,-0x10(%ebp)
80104b6b:	e9 db 00 00 00       	jmp    80104c4b <procdump+0xed>
    if(p->state == UNUSED)
80104b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b73:	8b 40 0c             	mov    0xc(%eax),%eax
80104b76:	85 c0                	test   %eax,%eax
80104b78:	0f 84 c5 00 00 00    	je     80104c43 <procdump+0xe5>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b81:	8b 40 0c             	mov    0xc(%eax),%eax
80104b84:	83 f8 05             	cmp    $0x5,%eax
80104b87:	77 23                	ja     80104bac <procdump+0x4e>
80104b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b8c:	8b 40 0c             	mov    0xc(%eax),%eax
80104b8f:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104b96:	85 c0                	test   %eax,%eax
80104b98:	74 12                	je     80104bac <procdump+0x4e>
      state = states[p->state];
80104b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b9d:	8b 40 0c             	mov    0xc(%eax),%eax
80104ba0:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104ba7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104baa:	eb 07                	jmp    80104bb3 <procdump+0x55>
      state = states[p->state];
    else
      state = "???";
80104bac:	c7 45 f4 34 86 10 80 	movl   $0x80108634,-0xc(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bb6:	8d 50 6c             	lea    0x6c(%eax),%edx
80104bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bbc:	8b 40 10             	mov    0x10(%eax),%eax
80104bbf:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104bc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bc6:	89 54 24 08          	mov    %edx,0x8(%esp)
80104bca:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bce:	c7 04 24 38 86 10 80 	movl   $0x80108638,(%esp)
80104bd5:	e8 c0 b7 ff ff       	call   8010039a <cprintf>
    if(p->state == SLEEPING){
80104bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bdd:	8b 40 0c             	mov    0xc(%eax),%eax
80104be0:	83 f8 02             	cmp    $0x2,%eax
80104be3:	75 50                	jne    80104c35 <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104be8:	8b 40 1c             	mov    0x1c(%eax),%eax
80104beb:	8b 40 0c             	mov    0xc(%eax),%eax
80104bee:	83 c0 08             	add    $0x8,%eax
80104bf1:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104bf4:	89 54 24 04          	mov    %edx,0x4(%esp)
80104bf8:	89 04 24             	mov    %eax,(%esp)
80104bfb:	e8 63 01 00 00       	call   80104d63 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c00:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104c07:	eb 1b                	jmp    80104c24 <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c0c:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c10:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c14:	c7 04 24 41 86 10 80 	movl   $0x80108641,(%esp)
80104c1b:	e8 7a b7 ff ff       	call   8010039a <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104c20:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104c24:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
80104c28:	7f 0b                	jg     80104c35 <procdump+0xd7>
80104c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c2d:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c31:	85 c0                	test   %eax,%eax
80104c33:	75 d4                	jne    80104c09 <procdump+0xab>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104c35:	c7 04 24 45 86 10 80 	movl   $0x80108645,(%esp)
80104c3c:	e8 59 b7 ff ff       	call   8010039a <cprintf>
80104c41:	eb 01                	jmp    80104c44 <procdump+0xe6>
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104c43:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c44:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104c4b:	b8 14 21 11 80       	mov    $0x80112114,%eax
80104c50:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104c53:	0f 82 17 ff ff ff    	jb     80104b70 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104c59:	c9                   	leave  
80104c5a:	c3                   	ret    
	...

80104c5c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104c5c:	55                   	push   %ebp
80104c5d:	89 e5                	mov    %esp,%ebp
80104c5f:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c62:	9c                   	pushf  
80104c63:	58                   	pop    %eax
80104c64:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104c67:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104c6a:	c9                   	leave  
80104c6b:	c3                   	ret    

80104c6c <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104c6c:	55                   	push   %ebp
80104c6d:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104c6f:	fa                   	cli    
}
80104c70:	5d                   	pop    %ebp
80104c71:	c3                   	ret    

80104c72 <sti>:

static inline void
sti(void)
{
80104c72:	55                   	push   %ebp
80104c73:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104c75:	fb                   	sti    
}
80104c76:	5d                   	pop    %ebp
80104c77:	c3                   	ret    

80104c78 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104c78:	55                   	push   %ebp
80104c79:	89 e5                	mov    %esp,%ebp
80104c7b:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104c7e:	8b 55 08             	mov    0x8(%ebp),%edx
80104c81:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c84:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c87:	f0 87 02             	lock xchg %eax,(%edx)
80104c8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104c8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104c90:	c9                   	leave  
80104c91:	c3                   	ret    

80104c92 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c92:	55                   	push   %ebp
80104c93:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104c95:	8b 45 08             	mov    0x8(%ebp),%eax
80104c98:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c9b:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104c9e:	8b 45 08             	mov    0x8(%ebp),%eax
80104ca1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80104caa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104cb1:	5d                   	pop    %ebp
80104cb2:	c3                   	ret    

80104cb3 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104cb3:	55                   	push   %ebp
80104cb4:	89 e5                	mov    %esp,%ebp
80104cb6:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104cb9:	e8 3e 01 00 00       	call   80104dfc <pushcli>
  if(holding(lk))
80104cbe:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc1:	89 04 24             	mov    %eax,(%esp)
80104cc4:	e8 09 01 00 00       	call   80104dd2 <holding>
80104cc9:	85 c0                	test   %eax,%eax
80104ccb:	74 0c                	je     80104cd9 <acquire+0x26>
    panic("acquire");
80104ccd:	c7 04 24 71 86 10 80 	movl   $0x80108671,(%esp)
80104cd4:	e8 61 b8 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104cd9:	8b 45 08             	mov    0x8(%ebp),%eax
80104cdc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104ce3:	00 
80104ce4:	89 04 24             	mov    %eax,(%esp)
80104ce7:	e8 8c ff ff ff       	call   80104c78 <xchg>
80104cec:	85 c0                	test   %eax,%eax
80104cee:	75 e9                	jne    80104cd9 <acquire+0x26>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104cf0:	8b 45 08             	mov    0x8(%ebp),%eax
80104cf3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104cfa:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80104d00:	83 c0 0c             	add    $0xc,%eax
80104d03:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d07:	8d 45 08             	lea    0x8(%ebp),%eax
80104d0a:	89 04 24             	mov    %eax,(%esp)
80104d0d:	e8 51 00 00 00       	call   80104d63 <getcallerpcs>
}
80104d12:	c9                   	leave  
80104d13:	c3                   	ret    

80104d14 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104d14:	55                   	push   %ebp
80104d15:	89 e5                	mov    %esp,%ebp
80104d17:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104d1a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d1d:	89 04 24             	mov    %eax,(%esp)
80104d20:	e8 ad 00 00 00       	call   80104dd2 <holding>
80104d25:	85 c0                	test   %eax,%eax
80104d27:	75 0c                	jne    80104d35 <release+0x21>
    panic("release");
80104d29:	c7 04 24 79 86 10 80 	movl   $0x80108679,(%esp)
80104d30:	e8 05 b8 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80104d35:	8b 45 08             	mov    0x8(%ebp),%eax
80104d38:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104d49:	8b 45 08             	mov    0x8(%ebp),%eax
80104d4c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104d53:	00 
80104d54:	89 04 24             	mov    %eax,(%esp)
80104d57:	e8 1c ff ff ff       	call   80104c78 <xchg>

  popcli();
80104d5c:	e8 e3 00 00 00       	call   80104e44 <popcli>
}
80104d61:	c9                   	leave  
80104d62:	c3                   	ret    

80104d63 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d63:	55                   	push   %ebp
80104d64:	89 e5                	mov    %esp,%ebp
80104d66:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104d69:	8b 45 08             	mov    0x8(%ebp),%eax
80104d6c:	83 e8 08             	sub    $0x8,%eax
80104d6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(i = 0; i < 10; i++){
80104d72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104d79:	eb 34                	jmp    80104daf <getcallerpcs+0x4c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d7b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
80104d7f:	74 49                	je     80104dca <getcallerpcs+0x67>
80104d81:	81 7d f8 ff ff ff 7f 	cmpl   $0x7fffffff,-0x8(%ebp)
80104d88:	76 40                	jbe    80104dca <getcallerpcs+0x67>
80104d8a:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%ebp)
80104d8e:	74 3a                	je     80104dca <getcallerpcs+0x67>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d90:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d93:	c1 e0 02             	shl    $0x2,%eax
80104d96:	03 45 0c             	add    0xc(%ebp),%eax
80104d99:	8b 55 f8             	mov    -0x8(%ebp),%edx
80104d9c:	83 c2 04             	add    $0x4,%edx
80104d9f:	8b 12                	mov    (%edx),%edx
80104da1:	89 10                	mov    %edx,(%eax)
    ebp = (uint*)ebp[0]; // saved %ebp
80104da3:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104da6:	8b 00                	mov    (%eax),%eax
80104da8:	89 45 f8             	mov    %eax,-0x8(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104dab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104daf:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
80104db3:	7e c6                	jle    80104d7b <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104db5:	eb 13                	jmp    80104dca <getcallerpcs+0x67>
    pcs[i] = 0;
80104db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dba:	c1 e0 02             	shl    $0x2,%eax
80104dbd:	03 45 0c             	add    0xc(%ebp),%eax
80104dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104dc6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104dca:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
80104dce:	7e e7                	jle    80104db7 <getcallerpcs+0x54>
    pcs[i] = 0;
}
80104dd0:	c9                   	leave  
80104dd1:	c3                   	ret    

80104dd2 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104dd2:	55                   	push   %ebp
80104dd3:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104dd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd8:	8b 00                	mov    (%eax),%eax
80104dda:	85 c0                	test   %eax,%eax
80104ddc:	74 17                	je     80104df5 <holding+0x23>
80104dde:	8b 45 08             	mov    0x8(%ebp),%eax
80104de1:	8b 50 08             	mov    0x8(%eax),%edx
80104de4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dea:	39 c2                	cmp    %eax,%edx
80104dec:	75 07                	jne    80104df5 <holding+0x23>
80104dee:	b8 01 00 00 00       	mov    $0x1,%eax
80104df3:	eb 05                	jmp    80104dfa <holding+0x28>
80104df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104dfa:	5d                   	pop    %ebp
80104dfb:	c3                   	ret    

80104dfc <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104dfc:	55                   	push   %ebp
80104dfd:	89 e5                	mov    %esp,%ebp
80104dff:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104e02:	e8 55 fe ff ff       	call   80104c5c <readeflags>
80104e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104e0a:	e8 5d fe ff ff       	call   80104c6c <cli>
  if(cpu->ncli++ == 0)
80104e0f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e15:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104e1b:	85 d2                	test   %edx,%edx
80104e1d:	0f 94 c1             	sete   %cl
80104e20:	83 c2 01             	add    $0x1,%edx
80104e23:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104e29:	84 c9                	test   %cl,%cl
80104e2b:	74 15                	je     80104e42 <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
80104e2d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e33:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e36:	81 e2 00 02 00 00    	and    $0x200,%edx
80104e3c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104e42:	c9                   	leave  
80104e43:	c3                   	ret    

80104e44 <popcli>:

void
popcli(void)
{
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104e4a:	e8 0d fe ff ff       	call   80104c5c <readeflags>
80104e4f:	25 00 02 00 00       	and    $0x200,%eax
80104e54:	85 c0                	test   %eax,%eax
80104e56:	74 0c                	je     80104e64 <popcli+0x20>
    panic("popcli - interruptible");
80104e58:	c7 04 24 81 86 10 80 	movl   $0x80108681,(%esp)
80104e5f:	e8 d6 b6 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80104e64:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e6a:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104e70:	83 ea 01             	sub    $0x1,%edx
80104e73:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104e79:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e7f:	85 c0                	test   %eax,%eax
80104e81:	79 0c                	jns    80104e8f <popcli+0x4b>
    panic("popcli");
80104e83:	c7 04 24 98 86 10 80 	movl   $0x80108698,(%esp)
80104e8a:	e8 ab b6 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104e8f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e95:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e9b:	85 c0                	test   %eax,%eax
80104e9d:	75 15                	jne    80104eb4 <popcli+0x70>
80104e9f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ea5:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104eab:	85 c0                	test   %eax,%eax
80104ead:	74 05                	je     80104eb4 <popcli+0x70>
    sti();
80104eaf:	e8 be fd ff ff       	call   80104c72 <sti>
}
80104eb4:	c9                   	leave  
80104eb5:	c3                   	ret    
	...

80104eb8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104eb8:	55                   	push   %ebp
80104eb9:	89 e5                	mov    %esp,%ebp
80104ebb:	57                   	push   %edi
80104ebc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104ebd:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ec0:	8b 55 10             	mov    0x10(%ebp),%edx
80104ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ec6:	89 cb                	mov    %ecx,%ebx
80104ec8:	89 df                	mov    %ebx,%edi
80104eca:	89 d1                	mov    %edx,%ecx
80104ecc:	fc                   	cld    
80104ecd:	f3 aa                	rep stos %al,%es:(%edi)
80104ecf:	89 ca                	mov    %ecx,%edx
80104ed1:	89 fb                	mov    %edi,%ebx
80104ed3:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104ed6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104ed9:	5b                   	pop    %ebx
80104eda:	5f                   	pop    %edi
80104edb:	5d                   	pop    %ebp
80104edc:	c3                   	ret    

80104edd <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80104edd:	55                   	push   %ebp
80104ede:	89 e5                	mov    %esp,%ebp
80104ee0:	57                   	push   %edi
80104ee1:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104ee2:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ee5:	8b 55 10             	mov    0x10(%ebp),%edx
80104ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eeb:	89 cb                	mov    %ecx,%ebx
80104eed:	89 df                	mov    %ebx,%edi
80104eef:	89 d1                	mov    %edx,%ecx
80104ef1:	fc                   	cld    
80104ef2:	f3 ab                	rep stos %eax,%es:(%edi)
80104ef4:	89 ca                	mov    %ecx,%edx
80104ef6:	89 fb                	mov    %edi,%ebx
80104ef8:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104efb:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104efe:	5b                   	pop    %ebx
80104eff:	5f                   	pop    %edi
80104f00:	5d                   	pop    %ebp
80104f01:	c3                   	ret    

80104f02 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f02:	55                   	push   %ebp
80104f03:	89 e5                	mov    %esp,%ebp
80104f05:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80104f08:	8b 45 08             	mov    0x8(%ebp),%eax
80104f0b:	83 e0 03             	and    $0x3,%eax
80104f0e:	85 c0                	test   %eax,%eax
80104f10:	75 49                	jne    80104f5b <memset+0x59>
80104f12:	8b 45 10             	mov    0x10(%ebp),%eax
80104f15:	83 e0 03             	and    $0x3,%eax
80104f18:	85 c0                	test   %eax,%eax
80104f1a:	75 3f                	jne    80104f5b <memset+0x59>
    c &= 0xFF;
80104f1c:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f23:	8b 45 10             	mov    0x10(%ebp),%eax
80104f26:	c1 e8 02             	shr    $0x2,%eax
80104f29:	89 c2                	mov    %eax,%edx
80104f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f2e:	89 c1                	mov    %eax,%ecx
80104f30:	c1 e1 18             	shl    $0x18,%ecx
80104f33:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f36:	c1 e0 10             	shl    $0x10,%eax
80104f39:	09 c1                	or     %eax,%ecx
80104f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f3e:	c1 e0 08             	shl    $0x8,%eax
80104f41:	09 c8                	or     %ecx,%eax
80104f43:	0b 45 0c             	or     0xc(%ebp),%eax
80104f46:	89 54 24 08          	mov    %edx,0x8(%esp)
80104f4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f4e:	8b 45 08             	mov    0x8(%ebp),%eax
80104f51:	89 04 24             	mov    %eax,(%esp)
80104f54:	e8 84 ff ff ff       	call   80104edd <stosl>
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
80104f59:	eb 19                	jmp    80104f74 <memset+0x72>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
80104f5b:	8b 45 10             	mov    0x10(%ebp),%eax
80104f5e:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f62:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f65:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f69:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6c:	89 04 24             	mov    %eax,(%esp)
80104f6f:	e8 44 ff ff ff       	call   80104eb8 <stosb>
  return dst;
80104f74:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104f77:	c9                   	leave  
80104f78:	c3                   	ret    

80104f79 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f79:	55                   	push   %ebp
80104f7a:	89 e5                	mov    %esp,%ebp
80104f7c:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80104f7f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f82:	89 45 f8             	mov    %eax,-0x8(%ebp)
  s2 = v2;
80104f85:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f88:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0){
80104f8b:	eb 32                	jmp    80104fbf <memcmp+0x46>
    if(*s1 != *s2)
80104f8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104f90:	0f b6 10             	movzbl (%eax),%edx
80104f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f96:	0f b6 00             	movzbl (%eax),%eax
80104f99:	38 c2                	cmp    %al,%dl
80104f9b:	74 1a                	je     80104fb7 <memcmp+0x3e>
      return *s1 - *s2;
80104f9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fa0:	0f b6 00             	movzbl (%eax),%eax
80104fa3:	0f b6 d0             	movzbl %al,%edx
80104fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fa9:	0f b6 00             	movzbl (%eax),%eax
80104fac:	0f b6 c0             	movzbl %al,%eax
80104faf:	89 d1                	mov    %edx,%ecx
80104fb1:	29 c1                	sub    %eax,%ecx
80104fb3:	89 c8                	mov    %ecx,%eax
80104fb5:	eb 1c                	jmp    80104fd3 <memcmp+0x5a>
    s1++, s2++;
80104fb7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104fbb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104fbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fc3:	0f 95 c0             	setne  %al
80104fc6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104fca:	84 c0                	test   %al,%al
80104fcc:	75 bf                	jne    80104f8d <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104fce:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fd3:	c9                   	leave  
80104fd4:	c3                   	ret    

80104fd5 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104fd5:	55                   	push   %ebp
80104fd6:	89 e5                	mov    %esp,%ebp
80104fd8:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fde:	89 45 f8             	mov    %eax,-0x8(%ebp)
  d = dst;
80104fe1:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(s < d && s + n > d){
80104fe7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80104fed:	73 55                	jae    80105044 <memmove+0x6f>
80104fef:	8b 45 10             	mov    0x10(%ebp),%eax
80104ff2:	8b 55 f8             	mov    -0x8(%ebp),%edx
80104ff5:	8d 04 02             	lea    (%edx,%eax,1),%eax
80104ff8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80104ffb:	76 4a                	jbe    80105047 <memmove+0x72>
    s += n;
80104ffd:	8b 45 10             	mov    0x10(%ebp),%eax
80105000:	01 45 f8             	add    %eax,-0x8(%ebp)
    d += n;
80105003:	8b 45 10             	mov    0x10(%ebp),%eax
80105006:	01 45 fc             	add    %eax,-0x4(%ebp)
    while(n-- > 0)
80105009:	eb 13                	jmp    8010501e <memmove+0x49>
      *--d = *--s;
8010500b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010500f:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105013:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105016:	0f b6 10             	movzbl (%eax),%edx
80105019:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010501c:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010501e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105022:	0f 95 c0             	setne  %al
80105025:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105029:	84 c0                	test   %al,%al
8010502b:	75 de                	jne    8010500b <memmove+0x36>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010502d:	eb 28                	jmp    80105057 <memmove+0x82>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
8010502f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105032:	0f b6 10             	movzbl (%eax),%edx
80105035:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105038:	88 10                	mov    %dl,(%eax)
8010503a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010503e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105042:	eb 04                	jmp    80105048 <memmove+0x73>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105044:	90                   	nop
80105045:	eb 01                	jmp    80105048 <memmove+0x73>
80105047:	90                   	nop
80105048:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010504c:	0f 95 c0             	setne  %al
8010504f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105053:	84 c0                	test   %al,%al
80105055:	75 d8                	jne    8010502f <memmove+0x5a>
      *d++ = *s++;

  return dst;
80105057:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010505a:	c9                   	leave  
8010505b:	c3                   	ret    

8010505c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010505c:	55                   	push   %ebp
8010505d:	89 e5                	mov    %esp,%ebp
8010505f:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105062:	8b 45 10             	mov    0x10(%ebp),%eax
80105065:	89 44 24 08          	mov    %eax,0x8(%esp)
80105069:	8b 45 0c             	mov    0xc(%ebp),%eax
8010506c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105070:	8b 45 08             	mov    0x8(%ebp),%eax
80105073:	89 04 24             	mov    %eax,(%esp)
80105076:	e8 5a ff ff ff       	call   80104fd5 <memmove>
}
8010507b:	c9                   	leave  
8010507c:	c3                   	ret    

8010507d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010507d:	55                   	push   %ebp
8010507e:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105080:	eb 0c                	jmp    8010508e <strncmp+0x11>
    n--, p++, q++;
80105082:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105086:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010508a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010508e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105092:	74 1a                	je     801050ae <strncmp+0x31>
80105094:	8b 45 08             	mov    0x8(%ebp),%eax
80105097:	0f b6 00             	movzbl (%eax),%eax
8010509a:	84 c0                	test   %al,%al
8010509c:	74 10                	je     801050ae <strncmp+0x31>
8010509e:	8b 45 08             	mov    0x8(%ebp),%eax
801050a1:	0f b6 10             	movzbl (%eax),%edx
801050a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801050a7:	0f b6 00             	movzbl (%eax),%eax
801050aa:	38 c2                	cmp    %al,%dl
801050ac:	74 d4                	je     80105082 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801050ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050b2:	75 07                	jne    801050bb <strncmp+0x3e>
    return 0;
801050b4:	b8 00 00 00 00       	mov    $0x0,%eax
801050b9:	eb 18                	jmp    801050d3 <strncmp+0x56>
  return (uchar)*p - (uchar)*q;
801050bb:	8b 45 08             	mov    0x8(%ebp),%eax
801050be:	0f b6 00             	movzbl (%eax),%eax
801050c1:	0f b6 d0             	movzbl %al,%edx
801050c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801050c7:	0f b6 00             	movzbl (%eax),%eax
801050ca:	0f b6 c0             	movzbl %al,%eax
801050cd:	89 d1                	mov    %edx,%ecx
801050cf:	29 c1                	sub    %eax,%ecx
801050d1:	89 c8                	mov    %ecx,%eax
}
801050d3:	5d                   	pop    %ebp
801050d4:	c3                   	ret    

801050d5 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801050d5:	55                   	push   %ebp
801050d6:	89 e5                	mov    %esp,%ebp
801050d8:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801050db:	8b 45 08             	mov    0x8(%ebp),%eax
801050de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801050e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050e5:	0f 9f c0             	setg   %al
801050e8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801050ec:	84 c0                	test   %al,%al
801050ee:	74 30                	je     80105120 <strncpy+0x4b>
801050f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801050f3:	0f b6 10             	movzbl (%eax),%edx
801050f6:	8b 45 08             	mov    0x8(%ebp),%eax
801050f9:	88 10                	mov    %dl,(%eax)
801050fb:	8b 45 08             	mov    0x8(%ebp),%eax
801050fe:	0f b6 00             	movzbl (%eax),%eax
80105101:	84 c0                	test   %al,%al
80105103:	0f 95 c0             	setne  %al
80105106:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010510a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010510e:	84 c0                	test   %al,%al
80105110:	75 cf                	jne    801050e1 <strncpy+0xc>
    ;
  while(n-- > 0)
80105112:	eb 0d                	jmp    80105121 <strncpy+0x4c>
    *s++ = 0;
80105114:	8b 45 08             	mov    0x8(%ebp),%eax
80105117:	c6 00 00             	movb   $0x0,(%eax)
8010511a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010511e:	eb 01                	jmp    80105121 <strncpy+0x4c>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105120:	90                   	nop
80105121:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105125:	0f 9f c0             	setg   %al
80105128:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010512c:	84 c0                	test   %al,%al
8010512e:	75 e4                	jne    80105114 <strncpy+0x3f>
    *s++ = 0;
  return os;
80105130:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105133:	c9                   	leave  
80105134:	c3                   	ret    

80105135 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105135:	55                   	push   %ebp
80105136:	89 e5                	mov    %esp,%ebp
80105138:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010513b:	8b 45 08             	mov    0x8(%ebp),%eax
8010513e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105141:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105145:	7f 05                	jg     8010514c <safestrcpy+0x17>
    return os;
80105147:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010514a:	eb 35                	jmp    80105181 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
8010514c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105150:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105154:	7e 22                	jle    80105178 <safestrcpy+0x43>
80105156:	8b 45 0c             	mov    0xc(%ebp),%eax
80105159:	0f b6 10             	movzbl (%eax),%edx
8010515c:	8b 45 08             	mov    0x8(%ebp),%eax
8010515f:	88 10                	mov    %dl,(%eax)
80105161:	8b 45 08             	mov    0x8(%ebp),%eax
80105164:	0f b6 00             	movzbl (%eax),%eax
80105167:	84 c0                	test   %al,%al
80105169:	0f 95 c0             	setne  %al
8010516c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105170:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105174:	84 c0                	test   %al,%al
80105176:	75 d4                	jne    8010514c <safestrcpy+0x17>
    ;
  *s = 0;
80105178:	8b 45 08             	mov    0x8(%ebp),%eax
8010517b:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010517e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105181:	c9                   	leave  
80105182:	c3                   	ret    

80105183 <strlen>:

int
strlen(const char *s)
{
80105183:	55                   	push   %ebp
80105184:	89 e5                	mov    %esp,%ebp
80105186:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105189:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105190:	eb 04                	jmp    80105196 <strlen+0x13>
80105192:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105196:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105199:	03 45 08             	add    0x8(%ebp),%eax
8010519c:	0f b6 00             	movzbl (%eax),%eax
8010519f:	84 c0                	test   %al,%al
801051a1:	75 ef                	jne    80105192 <strlen+0xf>
    ;
  return n;
801051a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801051a6:	c9                   	leave  
801051a7:	c3                   	ret    

801051a8 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801051a8:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801051ac:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801051b0:	55                   	push   %ebp
  pushl %ebx
801051b1:	53                   	push   %ebx
  pushl %esi
801051b2:	56                   	push   %esi
  pushl %edi
801051b3:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801051b4:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801051b6:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801051b8:	5f                   	pop    %edi
  popl %esi
801051b9:	5e                   	pop    %esi
  popl %ebx
801051ba:	5b                   	pop    %ebx
  popl %ebp
801051bb:	5d                   	pop    %ebp
  ret
801051bc:	c3                   	ret    
801051bd:	00 00                	add    %al,(%eax)
	...

801051c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801051c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051c9:	8b 00                	mov    (%eax),%eax
801051cb:	3b 45 08             	cmp    0x8(%ebp),%eax
801051ce:	76 12                	jbe    801051e2 <fetchint+0x22>
801051d0:	8b 45 08             	mov    0x8(%ebp),%eax
801051d3:	8d 50 04             	lea    0x4(%eax),%edx
801051d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051dc:	8b 00                	mov    (%eax),%eax
801051de:	39 c2                	cmp    %eax,%edx
801051e0:	76 07                	jbe    801051e9 <fetchint+0x29>
    return -1;
801051e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e7:	eb 0f                	jmp    801051f8 <fetchint+0x38>
  *ip = *(int*)(addr);
801051e9:	8b 45 08             	mov    0x8(%ebp),%eax
801051ec:	8b 10                	mov    (%eax),%edx
801051ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801051f1:	89 10                	mov    %edx,(%eax)
  return 0;
801051f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801051f8:	5d                   	pop    %ebp
801051f9:	c3                   	ret    

801051fa <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801051fa:	55                   	push   %ebp
801051fb:	89 e5                	mov    %esp,%ebp
801051fd:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105200:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105206:	8b 00                	mov    (%eax),%eax
80105208:	3b 45 08             	cmp    0x8(%ebp),%eax
8010520b:	77 07                	ja     80105214 <fetchstr+0x1a>
    return -1;
8010520d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105212:	eb 48                	jmp    8010525c <fetchstr+0x62>
  *pp = (char*)addr;
80105214:	8b 55 08             	mov    0x8(%ebp),%edx
80105217:	8b 45 0c             	mov    0xc(%ebp),%eax
8010521a:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
8010521c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105222:	8b 00                	mov    (%eax),%eax
80105224:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(s = *pp; s < ep; s++)
80105227:	8b 45 0c             	mov    0xc(%ebp),%eax
8010522a:	8b 00                	mov    (%eax),%eax
8010522c:	89 45 f8             	mov    %eax,-0x8(%ebp)
8010522f:	eb 1e                	jmp    8010524f <fetchstr+0x55>
    if(*s == 0)
80105231:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105234:	0f b6 00             	movzbl (%eax),%eax
80105237:	84 c0                	test   %al,%al
80105239:	75 10                	jne    8010524b <fetchstr+0x51>
      return s - *pp;
8010523b:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010523e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105241:	8b 00                	mov    (%eax),%eax
80105243:	89 d1                	mov    %edx,%ecx
80105245:	29 c1                	sub    %eax,%ecx
80105247:	89 c8                	mov    %ecx,%eax
80105249:	eb 11                	jmp    8010525c <fetchstr+0x62>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010524b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010524f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105252:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105255:	72 da                	jb     80105231 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010525c:	c9                   	leave  
8010525d:	c3                   	ret    

8010525e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010525e:	55                   	push   %ebp
8010525f:	89 e5                	mov    %esp,%ebp
80105261:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105264:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010526a:	8b 40 18             	mov    0x18(%eax),%eax
8010526d:	8b 50 44             	mov    0x44(%eax),%edx
80105270:	8b 45 08             	mov    0x8(%ebp),%eax
80105273:	c1 e0 02             	shl    $0x2,%eax
80105276:	8d 04 02             	lea    (%edx,%eax,1),%eax
80105279:	8d 50 04             	lea    0x4(%eax),%edx
8010527c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010527f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105283:	89 14 24             	mov    %edx,(%esp)
80105286:	e8 35 ff ff ff       	call   801051c0 <fetchint>
}
8010528b:	c9                   	leave  
8010528c:	c3                   	ret    

8010528d <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010528d:	55                   	push   %ebp
8010528e:	89 e5                	mov    %esp,%ebp
80105290:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105293:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105296:	89 44 24 04          	mov    %eax,0x4(%esp)
8010529a:	8b 45 08             	mov    0x8(%ebp),%eax
8010529d:	89 04 24             	mov    %eax,(%esp)
801052a0:	e8 b9 ff ff ff       	call   8010525e <argint>
801052a5:	85 c0                	test   %eax,%eax
801052a7:	79 07                	jns    801052b0 <argptr+0x23>
    return -1;
801052a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ae:	eb 3d                	jmp    801052ed <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801052b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052b3:	89 c2                	mov    %eax,%edx
801052b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052bb:	8b 00                	mov    (%eax),%eax
801052bd:	39 c2                	cmp    %eax,%edx
801052bf:	73 16                	jae    801052d7 <argptr+0x4a>
801052c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052c4:	89 c2                	mov    %eax,%edx
801052c6:	8b 45 10             	mov    0x10(%ebp),%eax
801052c9:	01 c2                	add    %eax,%edx
801052cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052d1:	8b 00                	mov    (%eax),%eax
801052d3:	39 c2                	cmp    %eax,%edx
801052d5:	76 07                	jbe    801052de <argptr+0x51>
    return -1;
801052d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052dc:	eb 0f                	jmp    801052ed <argptr+0x60>
  *pp = (char*)i;
801052de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052e1:	89 c2                	mov    %eax,%edx
801052e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801052e6:	89 10                	mov    %edx,(%eax)
  return 0;
801052e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052ed:	c9                   	leave  
801052ee:	c3                   	ret    

801052ef <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801052ef:	55                   	push   %ebp
801052f0:	89 e5                	mov    %esp,%ebp
801052f2:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
801052f5:	8d 45 fc             	lea    -0x4(%ebp),%eax
801052f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801052fc:	8b 45 08             	mov    0x8(%ebp),%eax
801052ff:	89 04 24             	mov    %eax,(%esp)
80105302:	e8 57 ff ff ff       	call   8010525e <argint>
80105307:	85 c0                	test   %eax,%eax
80105309:	79 07                	jns    80105312 <argstr+0x23>
    return -1;
8010530b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105310:	eb 12                	jmp    80105324 <argstr+0x35>
  return fetchstr(addr, pp);
80105312:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105315:	8b 55 0c             	mov    0xc(%ebp),%edx
80105318:	89 54 24 04          	mov    %edx,0x4(%esp)
8010531c:	89 04 24             	mov    %eax,(%esp)
8010531f:	e8 d6 fe ff ff       	call   801051fa <fetchstr>
}
80105324:	c9                   	leave  
80105325:	c3                   	ret    

80105326 <syscall>:
[SYS_setpriority] sys_setpriority,
};

void
syscall(void)
{
80105326:	55                   	push   %ebp
80105327:	89 e5                	mov    %esp,%ebp
80105329:	53                   	push   %ebx
8010532a:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
8010532d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105333:	8b 40 18             	mov    0x18(%eax),%eax
80105336:	8b 40 1c             	mov    0x1c(%eax),%eax
80105339:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010533c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105340:	7e 30                	jle    80105372 <syscall+0x4c>
80105342:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105345:	83 f8 16             	cmp    $0x16,%eax
80105348:	77 28                	ja     80105372 <syscall+0x4c>
8010534a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010534d:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105354:	85 c0                	test   %eax,%eax
80105356:	74 1a                	je     80105372 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105358:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010535e:	8b 58 18             	mov    0x18(%eax),%ebx
80105361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105364:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010536b:	ff d0                	call   *%eax
8010536d:	89 43 1c             	mov    %eax,0x1c(%ebx)
syscall(void)
{
  int num;

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105370:	eb 3d                	jmp    801053af <syscall+0x89>
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105372:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105378:	8d 48 6c             	lea    0x6c(%eax),%ecx
            proc->pid, proc->name, num);
8010537b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105381:	8b 40 10             	mov    0x10(%eax),%eax
80105384:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105387:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010538b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010538f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105393:	c7 04 24 9f 86 10 80 	movl   $0x8010869f,(%esp)
8010539a:	e8 fb af ff ff       	call   8010039a <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010539f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053a5:	8b 40 18             	mov    0x18(%eax),%eax
801053a8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801053af:	83 c4 24             	add    $0x24,%esp
801053b2:	5b                   	pop    %ebx
801053b3:	5d                   	pop    %ebp
801053b4:	c3                   	ret    
801053b5:	00 00                	add    %al,(%eax)
	...

801053b8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801053b8:	55                   	push   %ebp
801053b9:	89 e5                	mov    %esp,%ebp
801053bb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801053be:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801053c5:	8b 45 08             	mov    0x8(%ebp),%eax
801053c8:	89 04 24             	mov    %eax,(%esp)
801053cb:	e8 8e fe ff ff       	call   8010525e <argint>
801053d0:	85 c0                	test   %eax,%eax
801053d2:	79 07                	jns    801053db <argfd+0x23>
    return -1;
801053d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053d9:	eb 50                	jmp    8010542b <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801053db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053de:	85 c0                	test   %eax,%eax
801053e0:	78 21                	js     80105403 <argfd+0x4b>
801053e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053e5:	83 f8 0f             	cmp    $0xf,%eax
801053e8:	7f 19                	jg     80105403 <argfd+0x4b>
801053ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801053f3:	83 c2 08             	add    $0x8,%edx
801053f6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801053fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801053fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105401:	75 07                	jne    8010540a <argfd+0x52>
    return -1;
80105403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105408:	eb 21                	jmp    8010542b <argfd+0x73>
  if(pfd)
8010540a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010540e:	74 08                	je     80105418 <argfd+0x60>
    *pfd = fd;
80105410:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105413:	8b 45 0c             	mov    0xc(%ebp),%eax
80105416:	89 10                	mov    %edx,(%eax)
  if(pf)
80105418:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010541c:	74 08                	je     80105426 <argfd+0x6e>
    *pf = f;
8010541e:	8b 45 10             	mov    0x10(%ebp),%eax
80105421:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105424:	89 10                	mov    %edx,(%eax)
  return 0;
80105426:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010542b:	c9                   	leave  
8010542c:	c3                   	ret    

8010542d <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010542d:	55                   	push   %ebp
8010542e:	89 e5                	mov    %esp,%ebp
80105430:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105433:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010543a:	eb 30                	jmp    8010546c <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
8010543c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105442:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105445:	83 c2 08             	add    $0x8,%edx
80105448:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010544c:	85 c0                	test   %eax,%eax
8010544e:	75 18                	jne    80105468 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105450:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105456:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105459:	8d 4a 08             	lea    0x8(%edx),%ecx
8010545c:	8b 55 08             	mov    0x8(%ebp),%edx
8010545f:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105463:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105466:	eb 0f                	jmp    80105477 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105468:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010546c:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105470:	7e ca                	jle    8010543c <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105472:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105477:	c9                   	leave  
80105478:	c3                   	ret    

80105479 <sys_dup>:

int
sys_dup(void)
{
80105479:	55                   	push   %ebp
8010547a:	89 e5                	mov    %esp,%ebp
8010547c:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010547f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105482:	89 44 24 08          	mov    %eax,0x8(%esp)
80105486:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010548d:	00 
8010548e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105495:	e8 1e ff ff ff       	call   801053b8 <argfd>
8010549a:	85 c0                	test   %eax,%eax
8010549c:	79 07                	jns    801054a5 <sys_dup+0x2c>
    return -1;
8010549e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054a3:	eb 29                	jmp    801054ce <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801054a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054a8:	89 04 24             	mov    %eax,(%esp)
801054ab:	e8 7d ff ff ff       	call   8010542d <fdalloc>
801054b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801054b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054b7:	79 07                	jns    801054c0 <sys_dup+0x47>
    return -1;
801054b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054be:	eb 0e                	jmp    801054ce <sys_dup+0x55>
  filedup(f);
801054c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054c3:	89 04 24             	mov    %eax,(%esp)
801054c6:	e8 ae ba ff ff       	call   80100f79 <filedup>
  return fd;
801054cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801054ce:	c9                   	leave  
801054cf:	c3                   	ret    

801054d0 <sys_read>:

int
sys_read(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054d9:	89 44 24 08          	mov    %eax,0x8(%esp)
801054dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801054e4:	00 
801054e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054ec:	e8 c7 fe ff ff       	call   801053b8 <argfd>
801054f1:	85 c0                	test   %eax,%eax
801054f3:	78 35                	js     8010552a <sys_read+0x5a>
801054f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801054fc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105503:	e8 56 fd ff ff       	call   8010525e <argint>
80105508:	85 c0                	test   %eax,%eax
8010550a:	78 1e                	js     8010552a <sys_read+0x5a>
8010550c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010550f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105513:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105516:	89 44 24 04          	mov    %eax,0x4(%esp)
8010551a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105521:	e8 67 fd ff ff       	call   8010528d <argptr>
80105526:	85 c0                	test   %eax,%eax
80105528:	79 07                	jns    80105531 <sys_read+0x61>
    return -1;
8010552a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010552f:	eb 19                	jmp    8010554a <sys_read+0x7a>
  return fileread(f, p, n);
80105531:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105534:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010553a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010553e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105542:	89 04 24             	mov    %eax,(%esp)
80105545:	e8 9c bb ff ff       	call   801010e6 <fileread>
}
8010554a:	c9                   	leave  
8010554b:	c3                   	ret    

8010554c <sys_write>:

int
sys_write(void)
{
8010554c:	55                   	push   %ebp
8010554d:	89 e5                	mov    %esp,%ebp
8010554f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105552:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105555:	89 44 24 08          	mov    %eax,0x8(%esp)
80105559:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105560:	00 
80105561:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105568:	e8 4b fe ff ff       	call   801053b8 <argfd>
8010556d:	85 c0                	test   %eax,%eax
8010556f:	78 35                	js     801055a6 <sys_write+0x5a>
80105571:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105574:	89 44 24 04          	mov    %eax,0x4(%esp)
80105578:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010557f:	e8 da fc ff ff       	call   8010525e <argint>
80105584:	85 c0                	test   %eax,%eax
80105586:	78 1e                	js     801055a6 <sys_write+0x5a>
80105588:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010558b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010558f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105592:	89 44 24 04          	mov    %eax,0x4(%esp)
80105596:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010559d:	e8 eb fc ff ff       	call   8010528d <argptr>
801055a2:	85 c0                	test   %eax,%eax
801055a4:	79 07                	jns    801055ad <sys_write+0x61>
    return -1;
801055a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ab:	eb 19                	jmp    801055c6 <sys_write+0x7a>
  return filewrite(f, p, n);
801055ad:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801055b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801055b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801055ba:	89 54 24 04          	mov    %edx,0x4(%esp)
801055be:	89 04 24             	mov    %eax,(%esp)
801055c1:	e8 dc bb ff ff       	call   801011a2 <filewrite>
}
801055c6:	c9                   	leave  
801055c7:	c3                   	ret    

801055c8 <sys_close>:

int
sys_close(void)
{
801055c8:	55                   	push   %ebp
801055c9:	89 e5                	mov    %esp,%ebp
801055cb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801055ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055d1:	89 44 24 08          	mov    %eax,0x8(%esp)
801055d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801055dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055e3:	e8 d0 fd ff ff       	call   801053b8 <argfd>
801055e8:	85 c0                	test   %eax,%eax
801055ea:	79 07                	jns    801055f3 <sys_close+0x2b>
    return -1;
801055ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f1:	eb 24                	jmp    80105617 <sys_close+0x4f>
  proc->ofile[fd] = 0;
801055f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055fc:	83 c2 08             	add    $0x8,%edx
801055ff:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105606:	00 
  fileclose(f);
80105607:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010560a:	89 04 24             	mov    %eax,(%esp)
8010560d:	e8 af b9 ff ff       	call   80100fc1 <fileclose>
  return 0;
80105612:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105617:	c9                   	leave  
80105618:	c3                   	ret    

80105619 <sys_fstat>:

int
sys_fstat(void)
{
80105619:	55                   	push   %ebp
8010561a:	89 e5                	mov    %esp,%ebp
8010561c:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010561f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105622:	89 44 24 08          	mov    %eax,0x8(%esp)
80105626:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010562d:	00 
8010562e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105635:	e8 7e fd ff ff       	call   801053b8 <argfd>
8010563a:	85 c0                	test   %eax,%eax
8010563c:	78 1f                	js     8010565d <sys_fstat+0x44>
8010563e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105641:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105648:	00 
80105649:	89 44 24 04          	mov    %eax,0x4(%esp)
8010564d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105654:	e8 34 fc ff ff       	call   8010528d <argptr>
80105659:	85 c0                	test   %eax,%eax
8010565b:	79 07                	jns    80105664 <sys_fstat+0x4b>
    return -1;
8010565d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105662:	eb 12                	jmp    80105676 <sys_fstat+0x5d>
  return filestat(f, st);
80105664:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105667:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010566a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010566e:	89 04 24             	mov    %eax,(%esp)
80105671:	e8 21 ba ff ff       	call   80101097 <filestat>
}
80105676:	c9                   	leave  
80105677:	c3                   	ret    

80105678 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105678:	55                   	push   %ebp
80105679:	89 e5                	mov    %esp,%ebp
8010567b:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010567e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105681:	89 44 24 04          	mov    %eax,0x4(%esp)
80105685:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010568c:	e8 5e fc ff ff       	call   801052ef <argstr>
80105691:	85 c0                	test   %eax,%eax
80105693:	78 17                	js     801056ac <sys_link+0x34>
80105695:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105698:	89 44 24 04          	mov    %eax,0x4(%esp)
8010569c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801056a3:	e8 47 fc ff ff       	call   801052ef <argstr>
801056a8:	85 c0                	test   %eax,%eax
801056aa:	79 0a                	jns    801056b6 <sys_link+0x3e>
    return -1;
801056ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b1:	e9 3c 01 00 00       	jmp    801057f2 <sys_link+0x17a>
  if((ip = namei(old)) == 0)
801056b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801056b9:	89 04 24             	mov    %eax,(%esp)
801056bc:	e8 56 cd ff ff       	call   80102417 <namei>
801056c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056c8:	75 0a                	jne    801056d4 <sys_link+0x5c>
    return -1;
801056ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056cf:	e9 1e 01 00 00       	jmp    801057f2 <sys_link+0x17a>

  begin_trans();
801056d4:	e8 2d db ff ff       	call   80103206 <begin_trans>

  ilock(ip);
801056d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056dc:	89 04 24             	mov    %eax,(%esp)
801056df:	e8 8b c1 ff ff       	call   8010186f <ilock>
  if(ip->type == T_DIR){
801056e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801056eb:	66 83 f8 01          	cmp    $0x1,%ax
801056ef:	75 1a                	jne    8010570b <sys_link+0x93>
    iunlockput(ip);
801056f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056f4:	89 04 24             	mov    %eax,(%esp)
801056f7:	e8 fa c3 ff ff       	call   80101af6 <iunlockput>
    commit_trans();
801056fc:	e8 4e db ff ff       	call   8010324f <commit_trans>
    return -1;
80105701:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105706:	e9 e7 00 00 00       	jmp    801057f2 <sys_link+0x17a>
  }

  ip->nlink++;
8010570b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010570e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105712:	8d 50 01             	lea    0x1(%eax),%edx
80105715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105718:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010571c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010571f:	89 04 24             	mov    %eax,(%esp)
80105722:	e8 88 bf ff ff       	call   801016af <iupdate>
  iunlock(ip);
80105727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010572a:	89 04 24             	mov    %eax,(%esp)
8010572d:	e8 8e c2 ff ff       	call   801019c0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105732:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105735:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105738:	89 54 24 04          	mov    %edx,0x4(%esp)
8010573c:	89 04 24             	mov    %eax,(%esp)
8010573f:	e8 f5 cc ff ff       	call   80102439 <nameiparent>
80105744:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105747:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010574b:	74 68                	je     801057b5 <sys_link+0x13d>
    goto bad;
  ilock(dp);
8010574d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105750:	89 04 24             	mov    %eax,(%esp)
80105753:	e8 17 c1 ff ff       	call   8010186f <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105758:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010575b:	8b 10                	mov    (%eax),%edx
8010575d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105760:	8b 00                	mov    (%eax),%eax
80105762:	39 c2                	cmp    %eax,%edx
80105764:	75 20                	jne    80105786 <sys_link+0x10e>
80105766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105769:	8b 40 04             	mov    0x4(%eax),%eax
8010576c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105770:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105773:	89 44 24 04          	mov    %eax,0x4(%esp)
80105777:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010577a:	89 04 24             	mov    %eax,(%esp)
8010577d:	e8 d4 c9 ff ff       	call   80102156 <dirlink>
80105782:	85 c0                	test   %eax,%eax
80105784:	79 0d                	jns    80105793 <sys_link+0x11b>
    iunlockput(dp);
80105786:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105789:	89 04 24             	mov    %eax,(%esp)
8010578c:	e8 65 c3 ff ff       	call   80101af6 <iunlockput>
    goto bad;
80105791:	eb 23                	jmp    801057b6 <sys_link+0x13e>
  }
  iunlockput(dp);
80105793:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105796:	89 04 24             	mov    %eax,(%esp)
80105799:	e8 58 c3 ff ff       	call   80101af6 <iunlockput>
  iput(ip);
8010579e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057a1:	89 04 24             	mov    %eax,(%esp)
801057a4:	e8 7c c2 ff ff       	call   80101a25 <iput>

  commit_trans();
801057a9:	e8 a1 da ff ff       	call   8010324f <commit_trans>

  return 0;
801057ae:	b8 00 00 00 00       	mov    $0x0,%eax
801057b3:	eb 3d                	jmp    801057f2 <sys_link+0x17a>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801057b5:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
801057b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b9:	89 04 24             	mov    %eax,(%esp)
801057bc:	e8 ae c0 ff ff       	call   8010186f <ilock>
  ip->nlink--;
801057c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057c4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801057c8:	8d 50 ff             	lea    -0x1(%eax),%edx
801057cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ce:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801057d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d5:	89 04 24             	mov    %eax,(%esp)
801057d8:	e8 d2 be ff ff       	call   801016af <iupdate>
  iunlockput(ip);
801057dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e0:	89 04 24             	mov    %eax,(%esp)
801057e3:	e8 0e c3 ff ff       	call   80101af6 <iunlockput>
  commit_trans();
801057e8:	e8 62 da ff ff       	call   8010324f <commit_trans>
  return -1;
801057ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057f2:	c9                   	leave  
801057f3:	c3                   	ret    

801057f4 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801057f4:	55                   	push   %ebp
801057f5:	89 e5                	mov    %esp,%ebp
801057f7:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057fa:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105801:	eb 4b                	jmp    8010584e <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105803:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105806:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105809:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105810:	00 
80105811:	89 54 24 08          	mov    %edx,0x8(%esp)
80105815:	89 44 24 04          	mov    %eax,0x4(%esp)
80105819:	8b 45 08             	mov    0x8(%ebp),%eax
8010581c:	89 04 24             	mov    %eax,(%esp)
8010581f:	e8 44 c5 ff ff       	call   80101d68 <readi>
80105824:	83 f8 10             	cmp    $0x10,%eax
80105827:	74 0c                	je     80105835 <isdirempty+0x41>
      panic("isdirempty: readi");
80105829:	c7 04 24 bb 86 10 80 	movl   $0x801086bb,(%esp)
80105830:	e8 05 ad ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105835:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105839:	66 85 c0             	test   %ax,%ax
8010583c:	74 07                	je     80105845 <isdirempty+0x51>
      return 0;
8010583e:	b8 00 00 00 00       	mov    $0x0,%eax
80105843:	eb 1b                	jmp    80105860 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105845:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105848:	83 c0 10             	add    $0x10,%eax
8010584b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010584e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105851:	8b 45 08             	mov    0x8(%ebp),%eax
80105854:	8b 40 18             	mov    0x18(%eax),%eax
80105857:	39 c2                	cmp    %eax,%edx
80105859:	72 a8                	jb     80105803 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010585b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105860:	c9                   	leave  
80105861:	c3                   	ret    

80105862 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105862:	55                   	push   %ebp
80105863:	89 e5                	mov    %esp,%ebp
80105865:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105868:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010586b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010586f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105876:	e8 74 fa ff ff       	call   801052ef <argstr>
8010587b:	85 c0                	test   %eax,%eax
8010587d:	79 0a                	jns    80105889 <sys_unlink+0x27>
    return -1;
8010587f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105884:	e9 aa 01 00 00       	jmp    80105a33 <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80105889:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010588c:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010588f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105893:	89 04 24             	mov    %eax,(%esp)
80105896:	e8 9e cb ff ff       	call   80102439 <nameiparent>
8010589b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010589e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058a2:	75 0a                	jne    801058ae <sys_unlink+0x4c>
    return -1;
801058a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a9:	e9 85 01 00 00       	jmp    80105a33 <sys_unlink+0x1d1>

  begin_trans();
801058ae:	e8 53 d9 ff ff       	call   80103206 <begin_trans>

  ilock(dp);
801058b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058b6:	89 04 24             	mov    %eax,(%esp)
801058b9:	e8 b1 bf ff ff       	call   8010186f <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058be:	c7 44 24 04 cd 86 10 	movl   $0x801086cd,0x4(%esp)
801058c5:	80 
801058c6:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801058c9:	89 04 24             	mov    %eax,(%esp)
801058cc:	e8 9b c7 ff ff       	call   8010206c <namecmp>
801058d1:	85 c0                	test   %eax,%eax
801058d3:	0f 84 45 01 00 00    	je     80105a1e <sys_unlink+0x1bc>
801058d9:	c7 44 24 04 cf 86 10 	movl   $0x801086cf,0x4(%esp)
801058e0:	80 
801058e1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801058e4:	89 04 24             	mov    %eax,(%esp)
801058e7:	e8 80 c7 ff ff       	call   8010206c <namecmp>
801058ec:	85 c0                	test   %eax,%eax
801058ee:	0f 84 2a 01 00 00    	je     80105a1e <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801058f4:	8d 45 c8             	lea    -0x38(%ebp),%eax
801058f7:	89 44 24 08          	mov    %eax,0x8(%esp)
801058fb:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801058fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105902:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105905:	89 04 24             	mov    %eax,(%esp)
80105908:	e8 81 c7 ff ff       	call   8010208e <dirlookup>
8010590d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105910:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105914:	0f 84 03 01 00 00    	je     80105a1d <sys_unlink+0x1bb>
    goto bad;
  ilock(ip);
8010591a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010591d:	89 04 24             	mov    %eax,(%esp)
80105920:	e8 4a bf ff ff       	call   8010186f <ilock>

  if(ip->nlink < 1)
80105925:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105928:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010592c:	66 85 c0             	test   %ax,%ax
8010592f:	7f 0c                	jg     8010593d <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
80105931:	c7 04 24 d2 86 10 80 	movl   $0x801086d2,(%esp)
80105938:	e8 fd ab ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010593d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105940:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105944:	66 83 f8 01          	cmp    $0x1,%ax
80105948:	75 1f                	jne    80105969 <sys_unlink+0x107>
8010594a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010594d:	89 04 24             	mov    %eax,(%esp)
80105950:	e8 9f fe ff ff       	call   801057f4 <isdirempty>
80105955:	85 c0                	test   %eax,%eax
80105957:	75 10                	jne    80105969 <sys_unlink+0x107>
    iunlockput(ip);
80105959:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595c:	89 04 24             	mov    %eax,(%esp)
8010595f:	e8 92 c1 ff ff       	call   80101af6 <iunlockput>
    goto bad;
80105964:	e9 b5 00 00 00       	jmp    80105a1e <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
80105969:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105970:	00 
80105971:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105978:	00 
80105979:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010597c:	89 04 24             	mov    %eax,(%esp)
8010597f:	e8 7e f5 ff ff       	call   80104f02 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105984:	8b 55 c8             	mov    -0x38(%ebp),%edx
80105987:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010598a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105991:	00 
80105992:	89 54 24 08          	mov    %edx,0x8(%esp)
80105996:	89 44 24 04          	mov    %eax,0x4(%esp)
8010599a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010599d:	89 04 24             	mov    %eax,(%esp)
801059a0:	e8 2f c5 ff ff       	call   80101ed4 <writei>
801059a5:	83 f8 10             	cmp    $0x10,%eax
801059a8:	74 0c                	je     801059b6 <sys_unlink+0x154>
    panic("unlink: writei");
801059aa:	c7 04 24 e4 86 10 80 	movl   $0x801086e4,(%esp)
801059b1:	e8 84 ab ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
801059b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059b9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801059bd:	66 83 f8 01          	cmp    $0x1,%ax
801059c1:	75 1c                	jne    801059df <sys_unlink+0x17d>
    dp->nlink--;
801059c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c6:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801059ca:	8d 50 ff             	lea    -0x1(%eax),%edx
801059cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d0:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801059d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d7:	89 04 24             	mov    %eax,(%esp)
801059da:	e8 d0 bc ff ff       	call   801016af <iupdate>
  }
  iunlockput(dp);
801059df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e2:	89 04 24             	mov    %eax,(%esp)
801059e5:	e8 0c c1 ff ff       	call   80101af6 <iunlockput>

  ip->nlink--;
801059ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ed:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801059f1:	8d 50 ff             	lea    -0x1(%eax),%edx
801059f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059f7:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801059fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059fe:	89 04 24             	mov    %eax,(%esp)
80105a01:	e8 a9 bc ff ff       	call   801016af <iupdate>
  iunlockput(ip);
80105a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a09:	89 04 24             	mov    %eax,(%esp)
80105a0c:	e8 e5 c0 ff ff       	call   80101af6 <iunlockput>

  commit_trans();
80105a11:	e8 39 d8 ff ff       	call   8010324f <commit_trans>

  return 0;
80105a16:	b8 00 00 00 00       	mov    $0x0,%eax
80105a1b:	eb 16                	jmp    80105a33 <sys_unlink+0x1d1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105a1d:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
80105a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a21:	89 04 24             	mov    %eax,(%esp)
80105a24:	e8 cd c0 ff ff       	call   80101af6 <iunlockput>
  commit_trans();
80105a29:	e8 21 d8 ff ff       	call   8010324f <commit_trans>
  return -1;
80105a2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a33:	c9                   	leave  
80105a34:	c3                   	ret    

80105a35 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105a35:	55                   	push   %ebp
80105a36:	89 e5                	mov    %esp,%ebp
80105a38:	83 ec 48             	sub    $0x48,%esp
80105a3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105a3e:	8b 55 10             	mov    0x10(%ebp),%edx
80105a41:	8b 45 14             	mov    0x14(%ebp),%eax
80105a44:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105a48:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105a4c:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105a50:	8d 45 de             	lea    -0x22(%ebp),%eax
80105a53:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a57:	8b 45 08             	mov    0x8(%ebp),%eax
80105a5a:	89 04 24             	mov    %eax,(%esp)
80105a5d:	e8 d7 c9 ff ff       	call   80102439 <nameiparent>
80105a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a69:	75 0a                	jne    80105a75 <create+0x40>
    return 0;
80105a6b:	b8 00 00 00 00       	mov    $0x0,%eax
80105a70:	e9 7e 01 00 00       	jmp    80105bf3 <create+0x1be>
  ilock(dp);
80105a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a78:	89 04 24             	mov    %eax,(%esp)
80105a7b:	e8 ef bd ff ff       	call   8010186f <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105a80:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a83:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a87:	8d 45 de             	lea    -0x22(%ebp),%eax
80105a8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a91:	89 04 24             	mov    %eax,(%esp)
80105a94:	e8 f5 c5 ff ff       	call   8010208e <dirlookup>
80105a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105aa0:	74 47                	je     80105ae9 <create+0xb4>
    iunlockput(dp);
80105aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aa5:	89 04 24             	mov    %eax,(%esp)
80105aa8:	e8 49 c0 ff ff       	call   80101af6 <iunlockput>
    ilock(ip);
80105aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab0:	89 04 24             	mov    %eax,(%esp)
80105ab3:	e8 b7 bd ff ff       	call   8010186f <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105ab8:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105abd:	75 15                	jne    80105ad4 <create+0x9f>
80105abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ac2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ac6:	66 83 f8 02          	cmp    $0x2,%ax
80105aca:	75 08                	jne    80105ad4 <create+0x9f>
      return ip;
80105acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105acf:	e9 1f 01 00 00       	jmp    80105bf3 <create+0x1be>
    iunlockput(ip);
80105ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ad7:	89 04 24             	mov    %eax,(%esp)
80105ada:	e8 17 c0 ff ff       	call   80101af6 <iunlockput>
    return 0;
80105adf:	b8 00 00 00 00       	mov    $0x0,%eax
80105ae4:	e9 0a 01 00 00       	jmp    80105bf3 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105ae9:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af0:	8b 00                	mov    (%eax),%eax
80105af2:	89 54 24 04          	mov    %edx,0x4(%esp)
80105af6:	89 04 24             	mov    %eax,(%esp)
80105af9:	e8 d4 ba ff ff       	call   801015d2 <ialloc>
80105afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b05:	75 0c                	jne    80105b13 <create+0xde>
    panic("create: ialloc");
80105b07:	c7 04 24 f3 86 10 80 	movl   $0x801086f3,(%esp)
80105b0e:	e8 27 aa ff ff       	call   8010053a <panic>

  ilock(ip);
80105b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b16:	89 04 24             	mov    %eax,(%esp)
80105b19:	e8 51 bd ff ff       	call   8010186f <ilock>
  ip->major = major;
80105b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b21:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105b25:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b2c:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105b30:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b37:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b40:	89 04 24             	mov    %eax,(%esp)
80105b43:	e8 67 bb ff ff       	call   801016af <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105b48:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105b4d:	75 6a                	jne    80105bb9 <create+0x184>
    dp->nlink++;  // for ".."
80105b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b52:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b56:	8d 50 01             	lea    0x1(%eax),%edx
80105b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b5c:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b63:	89 04 24             	mov    %eax,(%esp)
80105b66:	e8 44 bb ff ff       	call   801016af <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b6e:	8b 40 04             	mov    0x4(%eax),%eax
80105b71:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b75:	c7 44 24 04 cd 86 10 	movl   $0x801086cd,0x4(%esp)
80105b7c:	80 
80105b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b80:	89 04 24             	mov    %eax,(%esp)
80105b83:	e8 ce c5 ff ff       	call   80102156 <dirlink>
80105b88:	85 c0                	test   %eax,%eax
80105b8a:	78 21                	js     80105bad <create+0x178>
80105b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8f:	8b 40 04             	mov    0x4(%eax),%eax
80105b92:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b96:	c7 44 24 04 cf 86 10 	movl   $0x801086cf,0x4(%esp)
80105b9d:	80 
80105b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ba1:	89 04 24             	mov    %eax,(%esp)
80105ba4:	e8 ad c5 ff ff       	call   80102156 <dirlink>
80105ba9:	85 c0                	test   %eax,%eax
80105bab:	79 0c                	jns    80105bb9 <create+0x184>
      panic("create dots");
80105bad:	c7 04 24 02 87 10 80 	movl   $0x80108702,(%esp)
80105bb4:	e8 81 a9 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bbc:	8b 40 04             	mov    0x4(%eax),%eax
80105bbf:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bc3:	8d 45 de             	lea    -0x22(%ebp),%eax
80105bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bcd:	89 04 24             	mov    %eax,(%esp)
80105bd0:	e8 81 c5 ff ff       	call   80102156 <dirlink>
80105bd5:	85 c0                	test   %eax,%eax
80105bd7:	79 0c                	jns    80105be5 <create+0x1b0>
    panic("create: dirlink");
80105bd9:	c7 04 24 0e 87 10 80 	movl   $0x8010870e,(%esp)
80105be0:	e8 55 a9 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80105be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be8:	89 04 24             	mov    %eax,(%esp)
80105beb:	e8 06 bf ff ff       	call   80101af6 <iunlockput>

  return ip;
80105bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105bf3:	c9                   	leave  
80105bf4:	c3                   	ret    

80105bf5 <sys_open>:

int
sys_open(void)
{
80105bf5:	55                   	push   %ebp
80105bf6:	89 e5                	mov    %esp,%ebp
80105bf8:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105bfb:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c09:	e8 e1 f6 ff ff       	call   801052ef <argstr>
80105c0e:	85 c0                	test   %eax,%eax
80105c10:	78 17                	js     80105c29 <sys_open+0x34>
80105c12:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c15:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105c20:	e8 39 f6 ff ff       	call   8010525e <argint>
80105c25:	85 c0                	test   %eax,%eax
80105c27:	79 0a                	jns    80105c33 <sys_open+0x3e>
    return -1;
80105c29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c2e:	e9 46 01 00 00       	jmp    80105d79 <sys_open+0x184>
  if(omode & O_CREATE){
80105c33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c36:	25 00 02 00 00       	and    $0x200,%eax
80105c3b:	85 c0                	test   %eax,%eax
80105c3d:	74 40                	je     80105c7f <sys_open+0x8a>
    begin_trans();
80105c3f:	e8 c2 d5 ff ff       	call   80103206 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105c44:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c47:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105c4e:	00 
80105c4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105c56:	00 
80105c57:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105c5e:	00 
80105c5f:	89 04 24             	mov    %eax,(%esp)
80105c62:	e8 ce fd ff ff       	call   80105a35 <create>
80105c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105c6a:	e8 e0 d5 ff ff       	call   8010324f <commit_trans>
    if(ip == 0)
80105c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c73:	75 5c                	jne    80105cd1 <sys_open+0xdc>
      return -1;
80105c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c7a:	e9 fa 00 00 00       	jmp    80105d79 <sys_open+0x184>
  } else {
    if((ip = namei(path)) == 0)
80105c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c82:	89 04 24             	mov    %eax,(%esp)
80105c85:	e8 8d c7 ff ff       	call   80102417 <namei>
80105c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c91:	75 0a                	jne    80105c9d <sys_open+0xa8>
      return -1;
80105c93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c98:	e9 dc 00 00 00       	jmp    80105d79 <sys_open+0x184>
    ilock(ip);
80105c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca0:	89 04 24             	mov    %eax,(%esp)
80105ca3:	e8 c7 bb ff ff       	call   8010186f <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cab:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105caf:	66 83 f8 01          	cmp    $0x1,%ax
80105cb3:	75 1c                	jne    80105cd1 <sys_open+0xdc>
80105cb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cb8:	85 c0                	test   %eax,%eax
80105cba:	74 15                	je     80105cd1 <sys_open+0xdc>
      iunlockput(ip);
80105cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cbf:	89 04 24             	mov    %eax,(%esp)
80105cc2:	e8 2f be ff ff       	call   80101af6 <iunlockput>
      return -1;
80105cc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ccc:	e9 a8 00 00 00       	jmp    80105d79 <sys_open+0x184>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105cd1:	e8 42 b2 ff ff       	call   80100f18 <filealloc>
80105cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cdd:	74 14                	je     80105cf3 <sys_open+0xfe>
80105cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ce2:	89 04 24             	mov    %eax,(%esp)
80105ce5:	e8 43 f7 ff ff       	call   8010542d <fdalloc>
80105cea:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105ced:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105cf1:	79 23                	jns    80105d16 <sys_open+0x121>
    if(f)
80105cf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cf7:	74 0b                	je     80105d04 <sys_open+0x10f>
      fileclose(f);
80105cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cfc:	89 04 24             	mov    %eax,(%esp)
80105cff:	e8 bd b2 ff ff       	call   80100fc1 <fileclose>
    iunlockput(ip);
80105d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d07:	89 04 24             	mov    %eax,(%esp)
80105d0a:	e8 e7 bd ff ff       	call   80101af6 <iunlockput>
    return -1;
80105d0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d14:	eb 63                	jmp    80105d79 <sys_open+0x184>
  }
  iunlock(ip);
80105d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d19:	89 04 24             	mov    %eax,(%esp)
80105d1c:	e8 9f bc ff ff       	call   801019c0 <iunlock>

  f->type = FD_INODE;
80105d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d24:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d30:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d36:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105d3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d40:	83 e0 01             	and    $0x1,%eax
80105d43:	85 c0                	test   %eax,%eax
80105d45:	0f 94 c2             	sete   %dl
80105d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d4b:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d51:	83 e0 01             	and    $0x1,%eax
80105d54:	84 c0                	test   %al,%al
80105d56:	75 0a                	jne    80105d62 <sys_open+0x16d>
80105d58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d5b:	83 e0 02             	and    $0x2,%eax
80105d5e:	85 c0                	test   %eax,%eax
80105d60:	74 07                	je     80105d69 <sys_open+0x174>
80105d62:	b8 01 00 00 00       	mov    $0x1,%eax
80105d67:	eb 05                	jmp    80105d6e <sys_open+0x179>
80105d69:	b8 00 00 00 00       	mov    $0x0,%eax
80105d6e:	89 c2                	mov    %eax,%edx
80105d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d73:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105d76:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105d79:	c9                   	leave  
80105d7a:	c3                   	ret    

80105d7b <sys_mkdir>:

int
sys_mkdir(void)
{
80105d7b:	55                   	push   %ebp
80105d7c:	89 e5                	mov    %esp,%ebp
80105d7e:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105d81:	e8 80 d4 ff ff       	call   80103206 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105d86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d89:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d94:	e8 56 f5 ff ff       	call   801052ef <argstr>
80105d99:	85 c0                	test   %eax,%eax
80105d9b:	78 2c                	js     80105dc9 <sys_mkdir+0x4e>
80105d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105da7:	00 
80105da8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105daf:	00 
80105db0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105db7:	00 
80105db8:	89 04 24             	mov    %eax,(%esp)
80105dbb:	e8 75 fc ff ff       	call   80105a35 <create>
80105dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105dc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dc7:	75 0c                	jne    80105dd5 <sys_mkdir+0x5a>
    commit_trans();
80105dc9:	e8 81 d4 ff ff       	call   8010324f <commit_trans>
    return -1;
80105dce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd3:	eb 15                	jmp    80105dea <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd8:	89 04 24             	mov    %eax,(%esp)
80105ddb:	e8 16 bd ff ff       	call   80101af6 <iunlockput>
  commit_trans();
80105de0:	e8 6a d4 ff ff       	call   8010324f <commit_trans>
  return 0;
80105de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105dea:	c9                   	leave  
80105deb:	c3                   	ret    

80105dec <sys_mknod>:

int
sys_mknod(void)
{
80105dec:	55                   	push   %ebp
80105ded:	89 e5                	mov    %esp,%ebp
80105def:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105df2:	e8 0f d4 ff ff       	call   80103206 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105df7:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105dfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dfe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e05:	e8 e5 f4 ff ff       	call   801052ef <argstr>
80105e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e11:	78 5e                	js     80105e71 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80105e13:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e16:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e21:	e8 38 f4 ff ff       	call   8010525e <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105e26:	85 c0                	test   %eax,%eax
80105e28:	78 47                	js     80105e71 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105e2a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e31:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105e38:	e8 21 f4 ff ff       	call   8010525e <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105e3d:	85 c0                	test   %eax,%eax
80105e3f:	78 30                	js     80105e71 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e44:	0f bf c8             	movswl %ax,%ecx
80105e47:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e4a:	0f bf d0             	movswl %ax,%edx
80105e4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e50:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105e54:	89 54 24 08          	mov    %edx,0x8(%esp)
80105e58:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105e5f:	00 
80105e60:	89 04 24             	mov    %eax,(%esp)
80105e63:	e8 cd fb ff ff       	call   80105a35 <create>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e6f:	75 0c                	jne    80105e7d <sys_mknod+0x91>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80105e71:	e8 d9 d3 ff ff       	call   8010324f <commit_trans>
    return -1;
80105e76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e7b:	eb 15                	jmp    80105e92 <sys_mknod+0xa6>
  }
  iunlockput(ip);
80105e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e80:	89 04 24             	mov    %eax,(%esp)
80105e83:	e8 6e bc ff ff       	call   80101af6 <iunlockput>
  commit_trans();
80105e88:	e8 c2 d3 ff ff       	call   8010324f <commit_trans>
  return 0;
80105e8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e92:	c9                   	leave  
80105e93:	c3                   	ret    

80105e94 <sys_chdir>:

int
sys_chdir(void)
{
80105e94:	55                   	push   %ebp
80105e95:	89 e5                	mov    %esp,%ebp
80105e97:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105e9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ea1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ea8:	e8 42 f4 ff ff       	call   801052ef <argstr>
80105ead:	85 c0                	test   %eax,%eax
80105eaf:	78 14                	js     80105ec5 <sys_chdir+0x31>
80105eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb4:	89 04 24             	mov    %eax,(%esp)
80105eb7:	e8 5b c5 ff ff       	call   80102417 <namei>
80105ebc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ebf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ec3:	75 07                	jne    80105ecc <sys_chdir+0x38>
    return -1;
80105ec5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eca:	eb 57                	jmp    80105f23 <sys_chdir+0x8f>
  ilock(ip);
80105ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ecf:	89 04 24             	mov    %eax,(%esp)
80105ed2:	e8 98 b9 ff ff       	call   8010186f <ilock>
  if(ip->type != T_DIR){
80105ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eda:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ede:	66 83 f8 01          	cmp    $0x1,%ax
80105ee2:	74 12                	je     80105ef6 <sys_chdir+0x62>
    iunlockput(ip);
80105ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee7:	89 04 24             	mov    %eax,(%esp)
80105eea:	e8 07 bc ff ff       	call   80101af6 <iunlockput>
    return -1;
80105eef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef4:	eb 2d                	jmp    80105f23 <sys_chdir+0x8f>
  }
  iunlock(ip);
80105ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef9:	89 04 24             	mov    %eax,(%esp)
80105efc:	e8 bf ba ff ff       	call   801019c0 <iunlock>
  iput(proc->cwd);
80105f01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f07:	8b 40 68             	mov    0x68(%eax),%eax
80105f0a:	89 04 24             	mov    %eax,(%esp)
80105f0d:	e8 13 bb ff ff       	call   80101a25 <iput>
  proc->cwd = ip;
80105f12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f18:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f1b:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105f1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f23:	c9                   	leave  
80105f24:	c3                   	ret    

80105f25 <sys_exec>:

int
sys_exec(void)
{
80105f25:	55                   	push   %ebp
80105f26:	89 e5                	mov    %esp,%ebp
80105f28:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f2e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f31:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f3c:	e8 ae f3 ff ff       	call   801052ef <argstr>
80105f41:	85 c0                	test   %eax,%eax
80105f43:	78 1a                	js     80105f5f <sys_exec+0x3a>
80105f45:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f56:	e8 03 f3 ff ff       	call   8010525e <argint>
80105f5b:	85 c0                	test   %eax,%eax
80105f5d:	79 0a                	jns    80105f69 <sys_exec+0x44>
    return -1;
80105f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f64:	e9 cd 00 00 00       	jmp    80106036 <sys_exec+0x111>
  }
  memset(argv, 0, sizeof(argv));
80105f69:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105f70:	00 
80105f71:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105f78:	00 
80105f79:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105f7f:	89 04 24             	mov    %eax,(%esp)
80105f82:	e8 7b ef ff ff       	call   80104f02 <memset>
  for(i=0;; i++){
80105f87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f91:	83 f8 1f             	cmp    $0x1f,%eax
80105f94:	76 0a                	jbe    80105fa0 <sys_exec+0x7b>
      return -1;
80105f96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f9b:	e9 96 00 00 00       	jmp    80106036 <sys_exec+0x111>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105fa0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fa9:	c1 e2 02             	shl    $0x2,%edx
80105fac:	89 d1                	mov    %edx,%ecx
80105fae:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
80105fb4:	8d 14 11             	lea    (%ecx,%edx,1),%edx
80105fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fbb:	89 14 24             	mov    %edx,(%esp)
80105fbe:	e8 fd f1 ff ff       	call   801051c0 <fetchint>
80105fc3:	85 c0                	test   %eax,%eax
80105fc5:	79 07                	jns    80105fce <sys_exec+0xa9>
      return -1;
80105fc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fcc:	eb 68                	jmp    80106036 <sys_exec+0x111>
    if(uarg == 0){
80105fce:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105fd4:	85 c0                	test   %eax,%eax
80105fd6:	75 26                	jne    80105ffe <sys_exec+0xd9>
      argv[i] = 0;
80105fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fdb:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105fe2:	00 00 00 00 
      break;
80105fe6:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fea:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105ff0:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ff4:	89 04 24             	mov    %eax,(%esp)
80105ff7:	e8 fc aa ff ff       	call   80100af8 <exec>
80105ffc:	eb 38                	jmp    80106036 <sys_exec+0x111>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106001:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106008:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010600e:	01 d0                	add    %edx,%eax
80106010:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
80106016:	89 44 24 04          	mov    %eax,0x4(%esp)
8010601a:	89 14 24             	mov    %edx,(%esp)
8010601d:	e8 d8 f1 ff ff       	call   801051fa <fetchstr>
80106022:	85 c0                	test   %eax,%eax
80106024:	79 07                	jns    8010602d <sys_exec+0x108>
      return -1;
80106026:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010602b:	eb 09                	jmp    80106036 <sys_exec+0x111>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
8010602d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106031:	e9 58 ff ff ff       	jmp    80105f8e <sys_exec+0x69>
  return exec(path, argv);
}
80106036:	c9                   	leave  
80106037:	c3                   	ret    

80106038 <sys_pipe>:

int
sys_pipe(void)
{
80106038:	55                   	push   %ebp
80106039:	89 e5                	mov    %esp,%ebp
8010603b:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010603e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106041:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106048:	00 
80106049:	89 44 24 04          	mov    %eax,0x4(%esp)
8010604d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106054:	e8 34 f2 ff ff       	call   8010528d <argptr>
80106059:	85 c0                	test   %eax,%eax
8010605b:	79 0a                	jns    80106067 <sys_pipe+0x2f>
    return -1;
8010605d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106062:	e9 9b 00 00 00       	jmp    80106102 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106067:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010606a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010606e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106071:	89 04 24             	mov    %eax,(%esp)
80106074:	e8 83 db ff ff       	call   80103bfc <pipealloc>
80106079:	85 c0                	test   %eax,%eax
8010607b:	79 07                	jns    80106084 <sys_pipe+0x4c>
    return -1;
8010607d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106082:	eb 7e                	jmp    80106102 <sys_pipe+0xca>
  fd0 = -1;
80106084:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010608b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010608e:	89 04 24             	mov    %eax,(%esp)
80106091:	e8 97 f3 ff ff       	call   8010542d <fdalloc>
80106096:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106099:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010609d:	78 14                	js     801060b3 <sys_pipe+0x7b>
8010609f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060a2:	89 04 24             	mov    %eax,(%esp)
801060a5:	e8 83 f3 ff ff       	call   8010542d <fdalloc>
801060aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060b1:	79 37                	jns    801060ea <sys_pipe+0xb2>
    if(fd0 >= 0)
801060b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060b7:	78 14                	js     801060cd <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
801060b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801060c2:	83 c2 08             	add    $0x8,%edx
801060c5:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801060cc:	00 
    fileclose(rf);
801060cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060d0:	89 04 24             	mov    %eax,(%esp)
801060d3:	e8 e9 ae ff ff       	call   80100fc1 <fileclose>
    fileclose(wf);
801060d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060db:	89 04 24             	mov    %eax,(%esp)
801060de:	e8 de ae ff ff       	call   80100fc1 <fileclose>
    return -1;
801060e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e8:	eb 18                	jmp    80106102 <sys_pipe+0xca>
  }
  fd[0] = fd0;
801060ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801060ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
801060f0:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801060f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801060f5:	8d 50 04             	lea    0x4(%eax),%edx
801060f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060fb:	89 02                	mov    %eax,(%edx)
  return 0;
801060fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106102:	c9                   	leave  
80106103:	c3                   	ret    

80106104 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106104:	55                   	push   %ebp
80106105:	89 e5                	mov    %esp,%ebp
80106107:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010610a:	e8 30 e3 ff ff       	call   8010443f <fork>
}
8010610f:	c9                   	leave  
80106110:	c3                   	ret    

80106111 <sys_exit>:

int
sys_exit(void)
{
80106111:	55                   	push   %ebp
80106112:	89 e5                	mov    %esp,%ebp
80106114:	83 ec 08             	sub    $0x8,%esp
  exit();
80106117:	e8 91 e4 ff ff       	call   801045ad <exit>
  return 0;  // not reached
8010611c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106121:	c9                   	leave  
80106122:	c3                   	ret    

80106123 <sys_wait>:

int
sys_wait(void)
{
80106123:	55                   	push   %ebp
80106124:	89 e5                	mov    %esp,%ebp
80106126:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106129:	e8 9b e5 ff ff       	call   801046c9 <wait>
}
8010612e:	c9                   	leave  
8010612f:	c3                   	ret    

80106130 <sys_kill>:

int
sys_kill(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106136:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106139:	89 44 24 04          	mov    %eax,0x4(%esp)
8010613d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106144:	e8 15 f1 ff ff       	call   8010525e <argint>
80106149:	85 c0                	test   %eax,%eax
8010614b:	79 07                	jns    80106154 <sys_kill+0x24>
    return -1;
8010614d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106152:	eb 0b                	jmp    8010615f <sys_kill+0x2f>
  return kill(pid);
80106154:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106157:	89 04 24             	mov    %eax,(%esp)
8010615a:	e8 78 e9 ff ff       	call   80104ad7 <kill>
}
8010615f:	c9                   	leave  
80106160:	c3                   	ret    

80106161 <sys_getpid>:

int
sys_getpid(void)
{
80106161:	55                   	push   %ebp
80106162:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106164:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010616a:	8b 40 10             	mov    0x10(%eax),%eax
}
8010616d:	5d                   	pop    %ebp
8010616e:	c3                   	ret    

8010616f <sys_sbrk>:

int
sys_sbrk(void)
{
8010616f:	55                   	push   %ebp
80106170:	89 e5                	mov    %esp,%ebp
80106172:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106175:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106178:	89 44 24 04          	mov    %eax,0x4(%esp)
8010617c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106183:	e8 d6 f0 ff ff       	call   8010525e <argint>
80106188:	85 c0                	test   %eax,%eax
8010618a:	79 07                	jns    80106193 <sys_sbrk+0x24>
    return -1;
8010618c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106191:	eb 24                	jmp    801061b7 <sys_sbrk+0x48>
  addr = proc->sz;
80106193:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106199:	8b 00                	mov    (%eax),%eax
8010619b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010619e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061a1:	89 04 24             	mov    %eax,(%esp)
801061a4:	e8 f1 e1 ff ff       	call   8010439a <growproc>
801061a9:	85 c0                	test   %eax,%eax
801061ab:	79 07                	jns    801061b4 <sys_sbrk+0x45>
    return -1;
801061ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061b2:	eb 03                	jmp    801061b7 <sys_sbrk+0x48>
  return addr;
801061b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801061b7:	c9                   	leave  
801061b8:	c3                   	ret    

801061b9 <sys_sleep>:

int
sys_sleep(void)
{
801061b9:	55                   	push   %ebp
801061ba:	89 e5                	mov    %esp,%ebp
801061bc:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801061bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801061c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061cd:	e8 8c f0 ff ff       	call   8010525e <argint>
801061d2:	85 c0                	test   %eax,%eax
801061d4:	79 07                	jns    801061dd <sys_sleep+0x24>
    return -1;
801061d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061db:	eb 6c                	jmp    80106249 <sys_sleep+0x90>
  acquire(&tickslock);
801061dd:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
801061e4:	e8 ca ea ff ff       	call   80104cb3 <acquire>
  ticks0 = ticks;
801061e9:	a1 60 29 11 80       	mov    0x80112960,%eax
801061ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801061f1:	eb 34                	jmp    80106227 <sys_sleep+0x6e>
    if(proc->killed){
801061f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061f9:	8b 40 24             	mov    0x24(%eax),%eax
801061fc:	85 c0                	test   %eax,%eax
801061fe:	74 13                	je     80106213 <sys_sleep+0x5a>
      release(&tickslock);
80106200:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
80106207:	e8 08 eb ff ff       	call   80104d14 <release>
      return -1;
8010620c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106211:	eb 36                	jmp    80106249 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106213:	c7 44 24 04 20 21 11 	movl   $0x80112120,0x4(%esp)
8010621a:	80 
8010621b:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80106222:	e8 9d e7 ff ff       	call   801049c4 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106227:	a1 60 29 11 80       	mov    0x80112960,%eax
8010622c:	89 c2                	mov    %eax,%edx
8010622e:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106231:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106234:	39 c2                	cmp    %eax,%edx
80106236:	72 bb                	jb     801061f3 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106238:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
8010623f:	e8 d0 ea ff ff       	call   80104d14 <release>
  return 0;
80106244:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106249:	c9                   	leave  
8010624a:	c3                   	ret    

8010624b <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010624b:	55                   	push   %ebp
8010624c:	89 e5                	mov    %esp,%ebp
8010624e:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106251:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
80106258:	e8 56 ea ff ff       	call   80104cb3 <acquire>
  xticks = ticks;
8010625d:	a1 60 29 11 80       	mov    0x80112960,%eax
80106262:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106265:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
8010626c:	e8 a3 ea ff ff       	call   80104d14 <release>
  return xticks;
80106271:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106274:	c9                   	leave  
80106275:	c3                   	ret    

80106276 <sys_setpriority>:


int
sys_setpriority(void)
{
80106276:	55                   	push   %ebp
80106277:	89 e5                	mov    %esp,%ebp
80106279:	83 ec 28             	sub    $0x28,%esp
  int pid;
  int priority; 
  
  if(argint(0, &pid) < 0 &&
8010627c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010627f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106283:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010628a:	e8 cf ef ff ff       	call   8010525e <argint>
8010628f:	85 c0                	test   %eax,%eax
80106291:	79 1e                	jns    801062b1 <sys_setpriority+0x3b>
     argint(0, &priority) < 0)
80106293:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106296:	89 44 24 04          	mov    %eax,0x4(%esp)
8010629a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062a1:	e8 b8 ef ff ff       	call   8010525e <argint>
sys_setpriority(void)
{
  int pid;
  int priority; 
  
  if(argint(0, &pid) < 0 &&
801062a6:	85 c0                	test   %eax,%eax
801062a8:	79 07                	jns    801062b1 <sys_setpriority+0x3b>
     argint(0, &priority) < 0)
    {
      return -1;
801062aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062af:	eb 22                	jmp    801062d3 <sys_setpriority+0x5d>
    }
  if(setpriority(pid, priority) < 0)
801062b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801062b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b7:	89 54 24 04          	mov    %edx,0x4(%esp)
801062bb:	89 04 24             	mov    %eax,(%esp)
801062be:	e8 7d de ff ff       	call   80104140 <setpriority>
801062c3:	85 c0                	test   %eax,%eax
801062c5:	79 07                	jns    801062ce <sys_setpriority+0x58>
    return -1;
801062c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062cc:	eb 05                	jmp    801062d3 <sys_setpriority+0x5d>
  return 0;
801062ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062d3:	c9                   	leave  
801062d4:	c3                   	ret    
801062d5:	00 00                	add    %al,(%eax)
	...

801062d8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801062d8:	55                   	push   %ebp
801062d9:	89 e5                	mov    %esp,%ebp
801062db:	83 ec 08             	sub    $0x8,%esp
801062de:	8b 55 08             	mov    0x8(%ebp),%edx
801062e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801062e4:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801062e8:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062eb:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801062ef:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801062f3:	ee                   	out    %al,(%dx)
}
801062f4:	c9                   	leave  
801062f5:	c3                   	ret    

801062f6 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801062f6:	55                   	push   %ebp
801062f7:	89 e5                	mov    %esp,%ebp
801062f9:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801062fc:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106303:	00 
80106304:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
8010630b:	e8 c8 ff ff ff       	call   801062d8 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106310:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106317:	00 
80106318:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010631f:	e8 b4 ff ff ff       	call   801062d8 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106324:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
8010632b:	00 
8010632c:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106333:	e8 a0 ff ff ff       	call   801062d8 <outb>
  picenable(IRQ_TIMER);
80106338:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010633f:	e8 41 d7 ff ff       	call   80103a85 <picenable>
}
80106344:	c9                   	leave  
80106345:	c3                   	ret    
	...

80106348 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106348:	1e                   	push   %ds
  pushl %es
80106349:	06                   	push   %es
  pushl %fs
8010634a:	0f a0                	push   %fs
  pushl %gs
8010634c:	0f a8                	push   %gs
  pushal
8010634e:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
8010634f:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106353:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106355:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106357:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010635b:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
8010635d:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
8010635f:	54                   	push   %esp
  call trap
80106360:	e8 d5 01 00 00       	call   8010653a <trap>
  addl $4, %esp
80106365:	83 c4 04             	add    $0x4,%esp

80106368 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106368:	61                   	popa   
  popl %gs
80106369:	0f a9                	pop    %gs
  popl %fs
8010636b:	0f a1                	pop    %fs
  popl %es
8010636d:	07                   	pop    %es
  popl %ds
8010636e:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010636f:	83 c4 08             	add    $0x8,%esp
  iret
80106372:	cf                   	iret   
	...

80106374 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106374:	55                   	push   %ebp
80106375:	89 e5                	mov    %esp,%ebp
80106377:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010637a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010637d:	83 e8 01             	sub    $0x1,%eax
80106380:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106384:	8b 45 08             	mov    0x8(%ebp),%eax
80106387:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010638b:	8b 45 08             	mov    0x8(%ebp),%eax
8010638e:	c1 e8 10             	shr    $0x10,%eax
80106391:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106395:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106398:	0f 01 18             	lidtl  (%eax)
}
8010639b:	c9                   	leave  
8010639c:	c3                   	ret    

8010639d <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010639d:	55                   	push   %ebp
8010639e:	89 e5                	mov    %esp,%ebp
801063a0:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801063a3:	0f 20 d0             	mov    %cr2,%eax
801063a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801063a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801063ac:	c9                   	leave  
801063ad:	c3                   	ret    

801063ae <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801063ae:	55                   	push   %ebp
801063af:	89 e5                	mov    %esp,%ebp
801063b1:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801063b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801063bb:	e9 bf 00 00 00       	jmp    8010647f <tvinit+0xd1>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801063c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063c6:	8b 14 95 9c b0 10 80 	mov    -0x7fef4f64(,%edx,4),%edx
801063cd:	66 89 14 c5 60 21 11 	mov    %dx,-0x7feedea0(,%eax,8)
801063d4:	80 
801063d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d8:	66 c7 04 c5 62 21 11 	movw   $0x8,-0x7feede9e(,%eax,8)
801063df:	80 08 00 
801063e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063e5:	0f b6 14 c5 64 21 11 	movzbl -0x7feede9c(,%eax,8),%edx
801063ec:	80 
801063ed:	83 e2 e0             	and    $0xffffffe0,%edx
801063f0:	88 14 c5 64 21 11 80 	mov    %dl,-0x7feede9c(,%eax,8)
801063f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063fa:	0f b6 14 c5 64 21 11 	movzbl -0x7feede9c(,%eax,8),%edx
80106401:	80 
80106402:	83 e2 1f             	and    $0x1f,%edx
80106405:	88 14 c5 64 21 11 80 	mov    %dl,-0x7feede9c(,%eax,8)
8010640c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010640f:	0f b6 14 c5 65 21 11 	movzbl -0x7feede9b(,%eax,8),%edx
80106416:	80 
80106417:	83 e2 f0             	and    $0xfffffff0,%edx
8010641a:	83 ca 0e             	or     $0xe,%edx
8010641d:	88 14 c5 65 21 11 80 	mov    %dl,-0x7feede9b(,%eax,8)
80106424:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106427:	0f b6 14 c5 65 21 11 	movzbl -0x7feede9b(,%eax,8),%edx
8010642e:	80 
8010642f:	83 e2 ef             	and    $0xffffffef,%edx
80106432:	88 14 c5 65 21 11 80 	mov    %dl,-0x7feede9b(,%eax,8)
80106439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010643c:	0f b6 14 c5 65 21 11 	movzbl -0x7feede9b(,%eax,8),%edx
80106443:	80 
80106444:	83 e2 9f             	and    $0xffffff9f,%edx
80106447:	88 14 c5 65 21 11 80 	mov    %dl,-0x7feede9b(,%eax,8)
8010644e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106451:	0f b6 14 c5 65 21 11 	movzbl -0x7feede9b(,%eax,8),%edx
80106458:	80 
80106459:	83 ca 80             	or     $0xffffff80,%edx
8010645c:	88 14 c5 65 21 11 80 	mov    %dl,-0x7feede9b(,%eax,8)
80106463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106466:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106469:	8b 14 95 9c b0 10 80 	mov    -0x7fef4f64(,%edx,4),%edx
80106470:	c1 ea 10             	shr    $0x10,%edx
80106473:	66 89 14 c5 66 21 11 	mov    %dx,-0x7feede9a(,%eax,8)
8010647a:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010647b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010647f:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106486:	0f 8e 34 ff ff ff    	jle    801063c0 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010648c:	a1 9c b1 10 80       	mov    0x8010b19c,%eax
80106491:	66 a3 60 23 11 80    	mov    %ax,0x80112360
80106497:	66 c7 05 62 23 11 80 	movw   $0x8,0x80112362
8010649e:	08 00 
801064a0:	0f b6 05 64 23 11 80 	movzbl 0x80112364,%eax
801064a7:	83 e0 e0             	and    $0xffffffe0,%eax
801064aa:	a2 64 23 11 80       	mov    %al,0x80112364
801064af:	0f b6 05 64 23 11 80 	movzbl 0x80112364,%eax
801064b6:	83 e0 1f             	and    $0x1f,%eax
801064b9:	a2 64 23 11 80       	mov    %al,0x80112364
801064be:	0f b6 05 65 23 11 80 	movzbl 0x80112365,%eax
801064c5:	83 c8 0f             	or     $0xf,%eax
801064c8:	a2 65 23 11 80       	mov    %al,0x80112365
801064cd:	0f b6 05 65 23 11 80 	movzbl 0x80112365,%eax
801064d4:	83 e0 ef             	and    $0xffffffef,%eax
801064d7:	a2 65 23 11 80       	mov    %al,0x80112365
801064dc:	0f b6 05 65 23 11 80 	movzbl 0x80112365,%eax
801064e3:	83 c8 60             	or     $0x60,%eax
801064e6:	a2 65 23 11 80       	mov    %al,0x80112365
801064eb:	0f b6 05 65 23 11 80 	movzbl 0x80112365,%eax
801064f2:	83 c8 80             	or     $0xffffff80,%eax
801064f5:	a2 65 23 11 80       	mov    %al,0x80112365
801064fa:	a1 9c b1 10 80       	mov    0x8010b19c,%eax
801064ff:	c1 e8 10             	shr    $0x10,%eax
80106502:	66 a3 66 23 11 80    	mov    %ax,0x80112366
  
  initlock(&tickslock, "time");
80106508:	c7 44 24 04 20 87 10 	movl   $0x80108720,0x4(%esp)
8010650f:	80 
80106510:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
80106517:	e8 76 e7 ff ff       	call   80104c92 <initlock>
}
8010651c:	c9                   	leave  
8010651d:	c3                   	ret    

8010651e <idtinit>:

void
idtinit(void)
{
8010651e:	55                   	push   %ebp
8010651f:	89 e5                	mov    %esp,%ebp
80106521:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106524:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
8010652b:	00 
8010652c:	c7 04 24 60 21 11 80 	movl   $0x80112160,(%esp)
80106533:	e8 3c fe ff ff       	call   80106374 <lidt>
}
80106538:	c9                   	leave  
80106539:	c3                   	ret    

8010653a <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010653a:	55                   	push   %ebp
8010653b:	89 e5                	mov    %esp,%ebp
8010653d:	57                   	push   %edi
8010653e:	56                   	push   %esi
8010653f:	53                   	push   %ebx
80106540:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106543:	8b 45 08             	mov    0x8(%ebp),%eax
80106546:	8b 40 30             	mov    0x30(%eax),%eax
80106549:	83 f8 40             	cmp    $0x40,%eax
8010654c:	75 3e                	jne    8010658c <trap+0x52>
    if(proc->killed)
8010654e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106554:	8b 40 24             	mov    0x24(%eax),%eax
80106557:	85 c0                	test   %eax,%eax
80106559:	74 05                	je     80106560 <trap+0x26>
      exit();
8010655b:	e8 4d e0 ff ff       	call   801045ad <exit>
    proc->tf = tf;
80106560:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106566:	8b 55 08             	mov    0x8(%ebp),%edx
80106569:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010656c:	e8 b5 ed ff ff       	call   80105326 <syscall>
    if(proc->killed)
80106571:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106577:	8b 40 24             	mov    0x24(%eax),%eax
8010657a:	85 c0                	test   %eax,%eax
8010657c:	0f 84 34 02 00 00    	je     801067b6 <trap+0x27c>
      exit();
80106582:	e8 26 e0 ff ff       	call   801045ad <exit>
    return;
80106587:	e9 2b 02 00 00       	jmp    801067b7 <trap+0x27d>
  }

  switch(tf->trapno){
8010658c:	8b 45 08             	mov    0x8(%ebp),%eax
8010658f:	8b 40 30             	mov    0x30(%eax),%eax
80106592:	83 e8 20             	sub    $0x20,%eax
80106595:	83 f8 1f             	cmp    $0x1f,%eax
80106598:	0f 87 bc 00 00 00    	ja     8010665a <trap+0x120>
8010659e:	8b 04 85 c8 87 10 80 	mov    -0x7fef7838(,%eax,4),%eax
801065a5:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801065a7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801065ad:	0f b6 00             	movzbl (%eax),%eax
801065b0:	84 c0                	test   %al,%al
801065b2:	75 31                	jne    801065e5 <trap+0xab>
      acquire(&tickslock);
801065b4:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
801065bb:	e8 f3 e6 ff ff       	call   80104cb3 <acquire>
      ticks++;
801065c0:	a1 60 29 11 80       	mov    0x80112960,%eax
801065c5:	83 c0 01             	add    $0x1,%eax
801065c8:	a3 60 29 11 80       	mov    %eax,0x80112960
      wakeup(&ticks);
801065cd:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
801065d4:	e8 d3 e4 ff ff       	call   80104aac <wakeup>
      release(&tickslock);
801065d9:	c7 04 24 20 21 11 80 	movl   $0x80112120,(%esp)
801065e0:	e8 2f e7 ff ff       	call   80104d14 <release>
    }
    lapiceoi();
801065e5:	e8 ea c8 ff ff       	call   80102ed4 <lapiceoi>
    break;
801065ea:	e9 41 01 00 00       	jmp    80106730 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801065ef:	e8 fb c0 ff ff       	call   801026ef <ideintr>
    lapiceoi();
801065f4:	e8 db c8 ff ff       	call   80102ed4 <lapiceoi>
    break;
801065f9:	e9 32 01 00 00       	jmp    80106730 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801065fe:	e8 b4 c6 ff ff       	call   80102cb7 <kbdintr>
    lapiceoi();
80106603:	e8 cc c8 ff ff       	call   80102ed4 <lapiceoi>
    break;
80106608:	e9 23 01 00 00       	jmp    80106730 <trap+0x1f6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010660d:	e8 9d 03 00 00       	call   801069af <uartintr>
    lapiceoi();
80106612:	e8 bd c8 ff ff       	call   80102ed4 <lapiceoi>
    break;
80106617:	e9 14 01 00 00       	jmp    80106730 <trap+0x1f6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010661c:	8b 45 08             	mov    0x8(%ebp),%eax
8010661f:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106622:	8b 45 08             	mov    0x8(%ebp),%eax
80106625:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106629:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010662c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106632:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106635:	0f b6 c0             	movzbl %al,%eax
80106638:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010663c:	89 54 24 08          	mov    %edx,0x8(%esp)
80106640:	89 44 24 04          	mov    %eax,0x4(%esp)
80106644:	c7 04 24 28 87 10 80 	movl   $0x80108728,(%esp)
8010664b:	e8 4a 9d ff ff       	call   8010039a <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106650:	e8 7f c8 ff ff       	call   80102ed4 <lapiceoi>
    break;
80106655:	e9 d6 00 00 00       	jmp    80106730 <trap+0x1f6>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010665a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106660:	85 c0                	test   %eax,%eax
80106662:	74 11                	je     80106675 <trap+0x13b>
80106664:	8b 45 08             	mov    0x8(%ebp),%eax
80106667:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010666b:	0f b7 c0             	movzwl %ax,%eax
8010666e:	83 e0 03             	and    $0x3,%eax
80106671:	85 c0                	test   %eax,%eax
80106673:	75 46                	jne    801066bb <trap+0x181>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106675:	e8 23 fd ff ff       	call   8010639d <rcr2>
8010667a:	8b 55 08             	mov    0x8(%ebp),%edx
8010667d:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106680:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106687:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010668a:	0f b6 ca             	movzbl %dl,%ecx
8010668d:	8b 55 08             	mov    0x8(%ebp),%edx
80106690:	8b 52 30             	mov    0x30(%edx),%edx
80106693:	89 44 24 10          	mov    %eax,0x10(%esp)
80106697:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010669b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010669f:	89 54 24 04          	mov    %edx,0x4(%esp)
801066a3:	c7 04 24 4c 87 10 80 	movl   $0x8010874c,(%esp)
801066aa:	e8 eb 9c ff ff       	call   8010039a <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801066af:	c7 04 24 7e 87 10 80 	movl   $0x8010877e,(%esp)
801066b6:	e8 7f 9e ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066bb:	e8 dd fc ff ff       	call   8010639d <rcr2>
801066c0:	89 c2                	mov    %eax,%edx
801066c2:	8b 45 08             	mov    0x8(%ebp),%eax
801066c5:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801066c8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801066ce:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066d1:	0f b6 f0             	movzbl %al,%esi
801066d4:	8b 45 08             	mov    0x8(%ebp),%eax
801066d7:	8b 58 34             	mov    0x34(%eax),%ebx
801066da:	8b 45 08             	mov    0x8(%ebp),%eax
801066dd:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801066e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066e6:	83 c0 6c             	add    $0x6c,%eax
801066e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801066ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066f2:	8b 40 10             	mov    0x10(%eax),%eax
801066f5:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801066f9:	89 7c 24 18          	mov    %edi,0x18(%esp)
801066fd:	89 74 24 14          	mov    %esi,0x14(%esp)
80106701:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106705:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106709:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010670c:	89 54 24 08          	mov    %edx,0x8(%esp)
80106710:	89 44 24 04          	mov    %eax,0x4(%esp)
80106714:	c7 04 24 84 87 10 80 	movl   $0x80108784,(%esp)
8010671b:	e8 7a 9c ff ff       	call   8010039a <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106720:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106726:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010672d:	eb 01                	jmp    80106730 <trap+0x1f6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010672f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106730:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106736:	85 c0                	test   %eax,%eax
80106738:	74 24                	je     8010675e <trap+0x224>
8010673a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106740:	8b 40 24             	mov    0x24(%eax),%eax
80106743:	85 c0                	test   %eax,%eax
80106745:	74 17                	je     8010675e <trap+0x224>
80106747:	8b 45 08             	mov    0x8(%ebp),%eax
8010674a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010674e:	0f b7 c0             	movzwl %ax,%eax
80106751:	83 e0 03             	and    $0x3,%eax
80106754:	83 f8 03             	cmp    $0x3,%eax
80106757:	75 05                	jne    8010675e <trap+0x224>
    exit();
80106759:	e8 4f de ff ff       	call   801045ad <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010675e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106764:	85 c0                	test   %eax,%eax
80106766:	74 1e                	je     80106786 <trap+0x24c>
80106768:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010676e:	8b 40 0c             	mov    0xc(%eax),%eax
80106771:	83 f8 04             	cmp    $0x4,%eax
80106774:	75 10                	jne    80106786 <trap+0x24c>
80106776:	8b 45 08             	mov    0x8(%ebp),%eax
80106779:	8b 40 30             	mov    0x30(%eax),%eax
8010677c:	83 f8 20             	cmp    $0x20,%eax
8010677f:	75 05                	jne    80106786 <trap+0x24c>
    yield();
80106781:	e8 d2 e1 ff ff       	call   80104958 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106786:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010678c:	85 c0                	test   %eax,%eax
8010678e:	74 27                	je     801067b7 <trap+0x27d>
80106790:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106796:	8b 40 24             	mov    0x24(%eax),%eax
80106799:	85 c0                	test   %eax,%eax
8010679b:	74 1a                	je     801067b7 <trap+0x27d>
8010679d:	8b 45 08             	mov    0x8(%ebp),%eax
801067a0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801067a4:	0f b7 c0             	movzwl %ax,%eax
801067a7:	83 e0 03             	and    $0x3,%eax
801067aa:	83 f8 03             	cmp    $0x3,%eax
801067ad:	75 08                	jne    801067b7 <trap+0x27d>
    exit();
801067af:	e8 f9 dd ff ff       	call   801045ad <exit>
801067b4:	eb 01                	jmp    801067b7 <trap+0x27d>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801067b6:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801067b7:	83 c4 3c             	add    $0x3c,%esp
801067ba:	5b                   	pop    %ebx
801067bb:	5e                   	pop    %esi
801067bc:	5f                   	pop    %edi
801067bd:	5d                   	pop    %ebp
801067be:	c3                   	ret    
	...

801067c0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	83 ec 14             	sub    $0x14,%esp
801067c6:	8b 45 08             	mov    0x8(%ebp),%eax
801067c9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067cd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801067d1:	89 c2                	mov    %eax,%edx
801067d3:	ec                   	in     (%dx),%al
801067d4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801067d7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801067db:	c9                   	leave  
801067dc:	c3                   	ret    

801067dd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801067dd:	55                   	push   %ebp
801067de:	89 e5                	mov    %esp,%ebp
801067e0:	83 ec 08             	sub    $0x8,%esp
801067e3:	8b 55 08             	mov    0x8(%ebp),%edx
801067e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801067e9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801067ed:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801067f0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801067f4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801067f8:	ee                   	out    %al,(%dx)
}
801067f9:	c9                   	leave  
801067fa:	c3                   	ret    

801067fb <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801067fb:	55                   	push   %ebp
801067fc:	89 e5                	mov    %esp,%ebp
801067fe:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106801:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106808:	00 
80106809:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106810:	e8 c8 ff ff ff       	call   801067dd <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106815:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
8010681c:	00 
8010681d:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106824:	e8 b4 ff ff ff       	call   801067dd <outb>
  outb(COM1+0, 115200/9600);
80106829:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106830:	00 
80106831:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106838:	e8 a0 ff ff ff       	call   801067dd <outb>
  outb(COM1+1, 0);
8010683d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106844:	00 
80106845:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010684c:	e8 8c ff ff ff       	call   801067dd <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106851:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106858:	00 
80106859:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106860:	e8 78 ff ff ff       	call   801067dd <outb>
  outb(COM1+4, 0);
80106865:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010686c:	00 
8010686d:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106874:	e8 64 ff ff ff       	call   801067dd <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106879:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106880:	00 
80106881:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106888:	e8 50 ff ff ff       	call   801067dd <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010688d:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106894:	e8 27 ff ff ff       	call   801067c0 <inb>
80106899:	3c ff                	cmp    $0xff,%al
8010689b:	74 6c                	je     80106909 <uartinit+0x10e>
    return;
  uart = 1;
8010689d:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
801068a4:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801068a7:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801068ae:	e8 0d ff ff ff       	call   801067c0 <inb>
  inb(COM1+0);
801068b3:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801068ba:	e8 01 ff ff ff       	call   801067c0 <inb>
  picenable(IRQ_COM1);
801068bf:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801068c6:	e8 ba d1 ff ff       	call   80103a85 <picenable>
  ioapicenable(IRQ_COM1, 0);
801068cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068d2:	00 
801068d3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801068da:	e8 93 c0 ff ff       	call   80102972 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801068df:	c7 45 f4 48 88 10 80 	movl   $0x80108848,-0xc(%ebp)
801068e6:	eb 15                	jmp    801068fd <uartinit+0x102>
    uartputc(*p);
801068e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068eb:	0f b6 00             	movzbl (%eax),%eax
801068ee:	0f be c0             	movsbl %al,%eax
801068f1:	89 04 24             	mov    %eax,(%esp)
801068f4:	e8 13 00 00 00       	call   8010690c <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801068f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801068fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106900:	0f b6 00             	movzbl (%eax),%eax
80106903:	84 c0                	test   %al,%al
80106905:	75 e1                	jne    801068e8 <uartinit+0xed>
80106907:	eb 01                	jmp    8010690a <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106909:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010690a:	c9                   	leave  
8010690b:	c3                   	ret    

8010690c <uartputc>:

void
uartputc(int c)
{
8010690c:	55                   	push   %ebp
8010690d:	89 e5                	mov    %esp,%ebp
8010690f:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106912:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106917:	85 c0                	test   %eax,%eax
80106919:	74 4d                	je     80106968 <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010691b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106922:	eb 10                	jmp    80106934 <uartputc+0x28>
    microdelay(10);
80106924:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
8010692b:	e8 c9 c5 ff ff       	call   80102ef9 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106930:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106934:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106938:	7f 16                	jg     80106950 <uartputc+0x44>
8010693a:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106941:	e8 7a fe ff ff       	call   801067c0 <inb>
80106946:	0f b6 c0             	movzbl %al,%eax
80106949:	83 e0 20             	and    $0x20,%eax
8010694c:	85 c0                	test   %eax,%eax
8010694e:	74 d4                	je     80106924 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106950:	8b 45 08             	mov    0x8(%ebp),%eax
80106953:	0f b6 c0             	movzbl %al,%eax
80106956:	89 44 24 04          	mov    %eax,0x4(%esp)
8010695a:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106961:	e8 77 fe ff ff       	call   801067dd <outb>
80106966:	eb 01                	jmp    80106969 <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106968:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106969:	c9                   	leave  
8010696a:	c3                   	ret    

8010696b <uartgetc>:

static int
uartgetc(void)
{
8010696b:	55                   	push   %ebp
8010696c:	89 e5                	mov    %esp,%ebp
8010696e:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106971:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106976:	85 c0                	test   %eax,%eax
80106978:	75 07                	jne    80106981 <uartgetc+0x16>
    return -1;
8010697a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010697f:	eb 2c                	jmp    801069ad <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106981:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106988:	e8 33 fe ff ff       	call   801067c0 <inb>
8010698d:	0f b6 c0             	movzbl %al,%eax
80106990:	83 e0 01             	and    $0x1,%eax
80106993:	85 c0                	test   %eax,%eax
80106995:	75 07                	jne    8010699e <uartgetc+0x33>
    return -1;
80106997:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010699c:	eb 0f                	jmp    801069ad <uartgetc+0x42>
  return inb(COM1+0);
8010699e:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801069a5:	e8 16 fe ff ff       	call   801067c0 <inb>
801069aa:	0f b6 c0             	movzbl %al,%eax
}
801069ad:	c9                   	leave  
801069ae:	c3                   	ret    

801069af <uartintr>:

void
uartintr(void)
{
801069af:	55                   	push   %ebp
801069b0:	89 e5                	mov    %esp,%ebp
801069b2:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801069b5:	c7 04 24 6b 69 10 80 	movl   $0x8010696b,(%esp)
801069bc:	e8 ea 9d ff ff       	call   801007ab <consoleintr>
}
801069c1:	c9                   	leave  
801069c2:	c3                   	ret    
	...

801069c4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801069c4:	6a 00                	push   $0x0
  pushl $0
801069c6:	6a 00                	push   $0x0
  jmp alltraps
801069c8:	e9 7b f9 ff ff       	jmp    80106348 <alltraps>

801069cd <vector1>:
.globl vector1
vector1:
  pushl $0
801069cd:	6a 00                	push   $0x0
  pushl $1
801069cf:	6a 01                	push   $0x1
  jmp alltraps
801069d1:	e9 72 f9 ff ff       	jmp    80106348 <alltraps>

801069d6 <vector2>:
.globl vector2
vector2:
  pushl $0
801069d6:	6a 00                	push   $0x0
  pushl $2
801069d8:	6a 02                	push   $0x2
  jmp alltraps
801069da:	e9 69 f9 ff ff       	jmp    80106348 <alltraps>

801069df <vector3>:
.globl vector3
vector3:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $3
801069e1:	6a 03                	push   $0x3
  jmp alltraps
801069e3:	e9 60 f9 ff ff       	jmp    80106348 <alltraps>

801069e8 <vector4>:
.globl vector4
vector4:
  pushl $0
801069e8:	6a 00                	push   $0x0
  pushl $4
801069ea:	6a 04                	push   $0x4
  jmp alltraps
801069ec:	e9 57 f9 ff ff       	jmp    80106348 <alltraps>

801069f1 <vector5>:
.globl vector5
vector5:
  pushl $0
801069f1:	6a 00                	push   $0x0
  pushl $5
801069f3:	6a 05                	push   $0x5
  jmp alltraps
801069f5:	e9 4e f9 ff ff       	jmp    80106348 <alltraps>

801069fa <vector6>:
.globl vector6
vector6:
  pushl $0
801069fa:	6a 00                	push   $0x0
  pushl $6
801069fc:	6a 06                	push   $0x6
  jmp alltraps
801069fe:	e9 45 f9 ff ff       	jmp    80106348 <alltraps>

80106a03 <vector7>:
.globl vector7
vector7:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $7
80106a05:	6a 07                	push   $0x7
  jmp alltraps
80106a07:	e9 3c f9 ff ff       	jmp    80106348 <alltraps>

80106a0c <vector8>:
.globl vector8
vector8:
  pushl $8
80106a0c:	6a 08                	push   $0x8
  jmp alltraps
80106a0e:	e9 35 f9 ff ff       	jmp    80106348 <alltraps>

80106a13 <vector9>:
.globl vector9
vector9:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $9
80106a15:	6a 09                	push   $0x9
  jmp alltraps
80106a17:	e9 2c f9 ff ff       	jmp    80106348 <alltraps>

80106a1c <vector10>:
.globl vector10
vector10:
  pushl $10
80106a1c:	6a 0a                	push   $0xa
  jmp alltraps
80106a1e:	e9 25 f9 ff ff       	jmp    80106348 <alltraps>

80106a23 <vector11>:
.globl vector11
vector11:
  pushl $11
80106a23:	6a 0b                	push   $0xb
  jmp alltraps
80106a25:	e9 1e f9 ff ff       	jmp    80106348 <alltraps>

80106a2a <vector12>:
.globl vector12
vector12:
  pushl $12
80106a2a:	6a 0c                	push   $0xc
  jmp alltraps
80106a2c:	e9 17 f9 ff ff       	jmp    80106348 <alltraps>

80106a31 <vector13>:
.globl vector13
vector13:
  pushl $13
80106a31:	6a 0d                	push   $0xd
  jmp alltraps
80106a33:	e9 10 f9 ff ff       	jmp    80106348 <alltraps>

80106a38 <vector14>:
.globl vector14
vector14:
  pushl $14
80106a38:	6a 0e                	push   $0xe
  jmp alltraps
80106a3a:	e9 09 f9 ff ff       	jmp    80106348 <alltraps>

80106a3f <vector15>:
.globl vector15
vector15:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $15
80106a41:	6a 0f                	push   $0xf
  jmp alltraps
80106a43:	e9 00 f9 ff ff       	jmp    80106348 <alltraps>

80106a48 <vector16>:
.globl vector16
vector16:
  pushl $0
80106a48:	6a 00                	push   $0x0
  pushl $16
80106a4a:	6a 10                	push   $0x10
  jmp alltraps
80106a4c:	e9 f7 f8 ff ff       	jmp    80106348 <alltraps>

80106a51 <vector17>:
.globl vector17
vector17:
  pushl $17
80106a51:	6a 11                	push   $0x11
  jmp alltraps
80106a53:	e9 f0 f8 ff ff       	jmp    80106348 <alltraps>

80106a58 <vector18>:
.globl vector18
vector18:
  pushl $0
80106a58:	6a 00                	push   $0x0
  pushl $18
80106a5a:	6a 12                	push   $0x12
  jmp alltraps
80106a5c:	e9 e7 f8 ff ff       	jmp    80106348 <alltraps>

80106a61 <vector19>:
.globl vector19
vector19:
  pushl $0
80106a61:	6a 00                	push   $0x0
  pushl $19
80106a63:	6a 13                	push   $0x13
  jmp alltraps
80106a65:	e9 de f8 ff ff       	jmp    80106348 <alltraps>

80106a6a <vector20>:
.globl vector20
vector20:
  pushl $0
80106a6a:	6a 00                	push   $0x0
  pushl $20
80106a6c:	6a 14                	push   $0x14
  jmp alltraps
80106a6e:	e9 d5 f8 ff ff       	jmp    80106348 <alltraps>

80106a73 <vector21>:
.globl vector21
vector21:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $21
80106a75:	6a 15                	push   $0x15
  jmp alltraps
80106a77:	e9 cc f8 ff ff       	jmp    80106348 <alltraps>

80106a7c <vector22>:
.globl vector22
vector22:
  pushl $0
80106a7c:	6a 00                	push   $0x0
  pushl $22
80106a7e:	6a 16                	push   $0x16
  jmp alltraps
80106a80:	e9 c3 f8 ff ff       	jmp    80106348 <alltraps>

80106a85 <vector23>:
.globl vector23
vector23:
  pushl $0
80106a85:	6a 00                	push   $0x0
  pushl $23
80106a87:	6a 17                	push   $0x17
  jmp alltraps
80106a89:	e9 ba f8 ff ff       	jmp    80106348 <alltraps>

80106a8e <vector24>:
.globl vector24
vector24:
  pushl $0
80106a8e:	6a 00                	push   $0x0
  pushl $24
80106a90:	6a 18                	push   $0x18
  jmp alltraps
80106a92:	e9 b1 f8 ff ff       	jmp    80106348 <alltraps>

80106a97 <vector25>:
.globl vector25
vector25:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $25
80106a99:	6a 19                	push   $0x19
  jmp alltraps
80106a9b:	e9 a8 f8 ff ff       	jmp    80106348 <alltraps>

80106aa0 <vector26>:
.globl vector26
vector26:
  pushl $0
80106aa0:	6a 00                	push   $0x0
  pushl $26
80106aa2:	6a 1a                	push   $0x1a
  jmp alltraps
80106aa4:	e9 9f f8 ff ff       	jmp    80106348 <alltraps>

80106aa9 <vector27>:
.globl vector27
vector27:
  pushl $0
80106aa9:	6a 00                	push   $0x0
  pushl $27
80106aab:	6a 1b                	push   $0x1b
  jmp alltraps
80106aad:	e9 96 f8 ff ff       	jmp    80106348 <alltraps>

80106ab2 <vector28>:
.globl vector28
vector28:
  pushl $0
80106ab2:	6a 00                	push   $0x0
  pushl $28
80106ab4:	6a 1c                	push   $0x1c
  jmp alltraps
80106ab6:	e9 8d f8 ff ff       	jmp    80106348 <alltraps>

80106abb <vector29>:
.globl vector29
vector29:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $29
80106abd:	6a 1d                	push   $0x1d
  jmp alltraps
80106abf:	e9 84 f8 ff ff       	jmp    80106348 <alltraps>

80106ac4 <vector30>:
.globl vector30
vector30:
  pushl $0
80106ac4:	6a 00                	push   $0x0
  pushl $30
80106ac6:	6a 1e                	push   $0x1e
  jmp alltraps
80106ac8:	e9 7b f8 ff ff       	jmp    80106348 <alltraps>

80106acd <vector31>:
.globl vector31
vector31:
  pushl $0
80106acd:	6a 00                	push   $0x0
  pushl $31
80106acf:	6a 1f                	push   $0x1f
  jmp alltraps
80106ad1:	e9 72 f8 ff ff       	jmp    80106348 <alltraps>

80106ad6 <vector32>:
.globl vector32
vector32:
  pushl $0
80106ad6:	6a 00                	push   $0x0
  pushl $32
80106ad8:	6a 20                	push   $0x20
  jmp alltraps
80106ada:	e9 69 f8 ff ff       	jmp    80106348 <alltraps>

80106adf <vector33>:
.globl vector33
vector33:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $33
80106ae1:	6a 21                	push   $0x21
  jmp alltraps
80106ae3:	e9 60 f8 ff ff       	jmp    80106348 <alltraps>

80106ae8 <vector34>:
.globl vector34
vector34:
  pushl $0
80106ae8:	6a 00                	push   $0x0
  pushl $34
80106aea:	6a 22                	push   $0x22
  jmp alltraps
80106aec:	e9 57 f8 ff ff       	jmp    80106348 <alltraps>

80106af1 <vector35>:
.globl vector35
vector35:
  pushl $0
80106af1:	6a 00                	push   $0x0
  pushl $35
80106af3:	6a 23                	push   $0x23
  jmp alltraps
80106af5:	e9 4e f8 ff ff       	jmp    80106348 <alltraps>

80106afa <vector36>:
.globl vector36
vector36:
  pushl $0
80106afa:	6a 00                	push   $0x0
  pushl $36
80106afc:	6a 24                	push   $0x24
  jmp alltraps
80106afe:	e9 45 f8 ff ff       	jmp    80106348 <alltraps>

80106b03 <vector37>:
.globl vector37
vector37:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $37
80106b05:	6a 25                	push   $0x25
  jmp alltraps
80106b07:	e9 3c f8 ff ff       	jmp    80106348 <alltraps>

80106b0c <vector38>:
.globl vector38
vector38:
  pushl $0
80106b0c:	6a 00                	push   $0x0
  pushl $38
80106b0e:	6a 26                	push   $0x26
  jmp alltraps
80106b10:	e9 33 f8 ff ff       	jmp    80106348 <alltraps>

80106b15 <vector39>:
.globl vector39
vector39:
  pushl $0
80106b15:	6a 00                	push   $0x0
  pushl $39
80106b17:	6a 27                	push   $0x27
  jmp alltraps
80106b19:	e9 2a f8 ff ff       	jmp    80106348 <alltraps>

80106b1e <vector40>:
.globl vector40
vector40:
  pushl $0
80106b1e:	6a 00                	push   $0x0
  pushl $40
80106b20:	6a 28                	push   $0x28
  jmp alltraps
80106b22:	e9 21 f8 ff ff       	jmp    80106348 <alltraps>

80106b27 <vector41>:
.globl vector41
vector41:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $41
80106b29:	6a 29                	push   $0x29
  jmp alltraps
80106b2b:	e9 18 f8 ff ff       	jmp    80106348 <alltraps>

80106b30 <vector42>:
.globl vector42
vector42:
  pushl $0
80106b30:	6a 00                	push   $0x0
  pushl $42
80106b32:	6a 2a                	push   $0x2a
  jmp alltraps
80106b34:	e9 0f f8 ff ff       	jmp    80106348 <alltraps>

80106b39 <vector43>:
.globl vector43
vector43:
  pushl $0
80106b39:	6a 00                	push   $0x0
  pushl $43
80106b3b:	6a 2b                	push   $0x2b
  jmp alltraps
80106b3d:	e9 06 f8 ff ff       	jmp    80106348 <alltraps>

80106b42 <vector44>:
.globl vector44
vector44:
  pushl $0
80106b42:	6a 00                	push   $0x0
  pushl $44
80106b44:	6a 2c                	push   $0x2c
  jmp alltraps
80106b46:	e9 fd f7 ff ff       	jmp    80106348 <alltraps>

80106b4b <vector45>:
.globl vector45
vector45:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $45
80106b4d:	6a 2d                	push   $0x2d
  jmp alltraps
80106b4f:	e9 f4 f7 ff ff       	jmp    80106348 <alltraps>

80106b54 <vector46>:
.globl vector46
vector46:
  pushl $0
80106b54:	6a 00                	push   $0x0
  pushl $46
80106b56:	6a 2e                	push   $0x2e
  jmp alltraps
80106b58:	e9 eb f7 ff ff       	jmp    80106348 <alltraps>

80106b5d <vector47>:
.globl vector47
vector47:
  pushl $0
80106b5d:	6a 00                	push   $0x0
  pushl $47
80106b5f:	6a 2f                	push   $0x2f
  jmp alltraps
80106b61:	e9 e2 f7 ff ff       	jmp    80106348 <alltraps>

80106b66 <vector48>:
.globl vector48
vector48:
  pushl $0
80106b66:	6a 00                	push   $0x0
  pushl $48
80106b68:	6a 30                	push   $0x30
  jmp alltraps
80106b6a:	e9 d9 f7 ff ff       	jmp    80106348 <alltraps>

80106b6f <vector49>:
.globl vector49
vector49:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $49
80106b71:	6a 31                	push   $0x31
  jmp alltraps
80106b73:	e9 d0 f7 ff ff       	jmp    80106348 <alltraps>

80106b78 <vector50>:
.globl vector50
vector50:
  pushl $0
80106b78:	6a 00                	push   $0x0
  pushl $50
80106b7a:	6a 32                	push   $0x32
  jmp alltraps
80106b7c:	e9 c7 f7 ff ff       	jmp    80106348 <alltraps>

80106b81 <vector51>:
.globl vector51
vector51:
  pushl $0
80106b81:	6a 00                	push   $0x0
  pushl $51
80106b83:	6a 33                	push   $0x33
  jmp alltraps
80106b85:	e9 be f7 ff ff       	jmp    80106348 <alltraps>

80106b8a <vector52>:
.globl vector52
vector52:
  pushl $0
80106b8a:	6a 00                	push   $0x0
  pushl $52
80106b8c:	6a 34                	push   $0x34
  jmp alltraps
80106b8e:	e9 b5 f7 ff ff       	jmp    80106348 <alltraps>

80106b93 <vector53>:
.globl vector53
vector53:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $53
80106b95:	6a 35                	push   $0x35
  jmp alltraps
80106b97:	e9 ac f7 ff ff       	jmp    80106348 <alltraps>

80106b9c <vector54>:
.globl vector54
vector54:
  pushl $0
80106b9c:	6a 00                	push   $0x0
  pushl $54
80106b9e:	6a 36                	push   $0x36
  jmp alltraps
80106ba0:	e9 a3 f7 ff ff       	jmp    80106348 <alltraps>

80106ba5 <vector55>:
.globl vector55
vector55:
  pushl $0
80106ba5:	6a 00                	push   $0x0
  pushl $55
80106ba7:	6a 37                	push   $0x37
  jmp alltraps
80106ba9:	e9 9a f7 ff ff       	jmp    80106348 <alltraps>

80106bae <vector56>:
.globl vector56
vector56:
  pushl $0
80106bae:	6a 00                	push   $0x0
  pushl $56
80106bb0:	6a 38                	push   $0x38
  jmp alltraps
80106bb2:	e9 91 f7 ff ff       	jmp    80106348 <alltraps>

80106bb7 <vector57>:
.globl vector57
vector57:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $57
80106bb9:	6a 39                	push   $0x39
  jmp alltraps
80106bbb:	e9 88 f7 ff ff       	jmp    80106348 <alltraps>

80106bc0 <vector58>:
.globl vector58
vector58:
  pushl $0
80106bc0:	6a 00                	push   $0x0
  pushl $58
80106bc2:	6a 3a                	push   $0x3a
  jmp alltraps
80106bc4:	e9 7f f7 ff ff       	jmp    80106348 <alltraps>

80106bc9 <vector59>:
.globl vector59
vector59:
  pushl $0
80106bc9:	6a 00                	push   $0x0
  pushl $59
80106bcb:	6a 3b                	push   $0x3b
  jmp alltraps
80106bcd:	e9 76 f7 ff ff       	jmp    80106348 <alltraps>

80106bd2 <vector60>:
.globl vector60
vector60:
  pushl $0
80106bd2:	6a 00                	push   $0x0
  pushl $60
80106bd4:	6a 3c                	push   $0x3c
  jmp alltraps
80106bd6:	e9 6d f7 ff ff       	jmp    80106348 <alltraps>

80106bdb <vector61>:
.globl vector61
vector61:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $61
80106bdd:	6a 3d                	push   $0x3d
  jmp alltraps
80106bdf:	e9 64 f7 ff ff       	jmp    80106348 <alltraps>

80106be4 <vector62>:
.globl vector62
vector62:
  pushl $0
80106be4:	6a 00                	push   $0x0
  pushl $62
80106be6:	6a 3e                	push   $0x3e
  jmp alltraps
80106be8:	e9 5b f7 ff ff       	jmp    80106348 <alltraps>

80106bed <vector63>:
.globl vector63
vector63:
  pushl $0
80106bed:	6a 00                	push   $0x0
  pushl $63
80106bef:	6a 3f                	push   $0x3f
  jmp alltraps
80106bf1:	e9 52 f7 ff ff       	jmp    80106348 <alltraps>

80106bf6 <vector64>:
.globl vector64
vector64:
  pushl $0
80106bf6:	6a 00                	push   $0x0
  pushl $64
80106bf8:	6a 40                	push   $0x40
  jmp alltraps
80106bfa:	e9 49 f7 ff ff       	jmp    80106348 <alltraps>

80106bff <vector65>:
.globl vector65
vector65:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $65
80106c01:	6a 41                	push   $0x41
  jmp alltraps
80106c03:	e9 40 f7 ff ff       	jmp    80106348 <alltraps>

80106c08 <vector66>:
.globl vector66
vector66:
  pushl $0
80106c08:	6a 00                	push   $0x0
  pushl $66
80106c0a:	6a 42                	push   $0x42
  jmp alltraps
80106c0c:	e9 37 f7 ff ff       	jmp    80106348 <alltraps>

80106c11 <vector67>:
.globl vector67
vector67:
  pushl $0
80106c11:	6a 00                	push   $0x0
  pushl $67
80106c13:	6a 43                	push   $0x43
  jmp alltraps
80106c15:	e9 2e f7 ff ff       	jmp    80106348 <alltraps>

80106c1a <vector68>:
.globl vector68
vector68:
  pushl $0
80106c1a:	6a 00                	push   $0x0
  pushl $68
80106c1c:	6a 44                	push   $0x44
  jmp alltraps
80106c1e:	e9 25 f7 ff ff       	jmp    80106348 <alltraps>

80106c23 <vector69>:
.globl vector69
vector69:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $69
80106c25:	6a 45                	push   $0x45
  jmp alltraps
80106c27:	e9 1c f7 ff ff       	jmp    80106348 <alltraps>

80106c2c <vector70>:
.globl vector70
vector70:
  pushl $0
80106c2c:	6a 00                	push   $0x0
  pushl $70
80106c2e:	6a 46                	push   $0x46
  jmp alltraps
80106c30:	e9 13 f7 ff ff       	jmp    80106348 <alltraps>

80106c35 <vector71>:
.globl vector71
vector71:
  pushl $0
80106c35:	6a 00                	push   $0x0
  pushl $71
80106c37:	6a 47                	push   $0x47
  jmp alltraps
80106c39:	e9 0a f7 ff ff       	jmp    80106348 <alltraps>

80106c3e <vector72>:
.globl vector72
vector72:
  pushl $0
80106c3e:	6a 00                	push   $0x0
  pushl $72
80106c40:	6a 48                	push   $0x48
  jmp alltraps
80106c42:	e9 01 f7 ff ff       	jmp    80106348 <alltraps>

80106c47 <vector73>:
.globl vector73
vector73:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $73
80106c49:	6a 49                	push   $0x49
  jmp alltraps
80106c4b:	e9 f8 f6 ff ff       	jmp    80106348 <alltraps>

80106c50 <vector74>:
.globl vector74
vector74:
  pushl $0
80106c50:	6a 00                	push   $0x0
  pushl $74
80106c52:	6a 4a                	push   $0x4a
  jmp alltraps
80106c54:	e9 ef f6 ff ff       	jmp    80106348 <alltraps>

80106c59 <vector75>:
.globl vector75
vector75:
  pushl $0
80106c59:	6a 00                	push   $0x0
  pushl $75
80106c5b:	6a 4b                	push   $0x4b
  jmp alltraps
80106c5d:	e9 e6 f6 ff ff       	jmp    80106348 <alltraps>

80106c62 <vector76>:
.globl vector76
vector76:
  pushl $0
80106c62:	6a 00                	push   $0x0
  pushl $76
80106c64:	6a 4c                	push   $0x4c
  jmp alltraps
80106c66:	e9 dd f6 ff ff       	jmp    80106348 <alltraps>

80106c6b <vector77>:
.globl vector77
vector77:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $77
80106c6d:	6a 4d                	push   $0x4d
  jmp alltraps
80106c6f:	e9 d4 f6 ff ff       	jmp    80106348 <alltraps>

80106c74 <vector78>:
.globl vector78
vector78:
  pushl $0
80106c74:	6a 00                	push   $0x0
  pushl $78
80106c76:	6a 4e                	push   $0x4e
  jmp alltraps
80106c78:	e9 cb f6 ff ff       	jmp    80106348 <alltraps>

80106c7d <vector79>:
.globl vector79
vector79:
  pushl $0
80106c7d:	6a 00                	push   $0x0
  pushl $79
80106c7f:	6a 4f                	push   $0x4f
  jmp alltraps
80106c81:	e9 c2 f6 ff ff       	jmp    80106348 <alltraps>

80106c86 <vector80>:
.globl vector80
vector80:
  pushl $0
80106c86:	6a 00                	push   $0x0
  pushl $80
80106c88:	6a 50                	push   $0x50
  jmp alltraps
80106c8a:	e9 b9 f6 ff ff       	jmp    80106348 <alltraps>

80106c8f <vector81>:
.globl vector81
vector81:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $81
80106c91:	6a 51                	push   $0x51
  jmp alltraps
80106c93:	e9 b0 f6 ff ff       	jmp    80106348 <alltraps>

80106c98 <vector82>:
.globl vector82
vector82:
  pushl $0
80106c98:	6a 00                	push   $0x0
  pushl $82
80106c9a:	6a 52                	push   $0x52
  jmp alltraps
80106c9c:	e9 a7 f6 ff ff       	jmp    80106348 <alltraps>

80106ca1 <vector83>:
.globl vector83
vector83:
  pushl $0
80106ca1:	6a 00                	push   $0x0
  pushl $83
80106ca3:	6a 53                	push   $0x53
  jmp alltraps
80106ca5:	e9 9e f6 ff ff       	jmp    80106348 <alltraps>

80106caa <vector84>:
.globl vector84
vector84:
  pushl $0
80106caa:	6a 00                	push   $0x0
  pushl $84
80106cac:	6a 54                	push   $0x54
  jmp alltraps
80106cae:	e9 95 f6 ff ff       	jmp    80106348 <alltraps>

80106cb3 <vector85>:
.globl vector85
vector85:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $85
80106cb5:	6a 55                	push   $0x55
  jmp alltraps
80106cb7:	e9 8c f6 ff ff       	jmp    80106348 <alltraps>

80106cbc <vector86>:
.globl vector86
vector86:
  pushl $0
80106cbc:	6a 00                	push   $0x0
  pushl $86
80106cbe:	6a 56                	push   $0x56
  jmp alltraps
80106cc0:	e9 83 f6 ff ff       	jmp    80106348 <alltraps>

80106cc5 <vector87>:
.globl vector87
vector87:
  pushl $0
80106cc5:	6a 00                	push   $0x0
  pushl $87
80106cc7:	6a 57                	push   $0x57
  jmp alltraps
80106cc9:	e9 7a f6 ff ff       	jmp    80106348 <alltraps>

80106cce <vector88>:
.globl vector88
vector88:
  pushl $0
80106cce:	6a 00                	push   $0x0
  pushl $88
80106cd0:	6a 58                	push   $0x58
  jmp alltraps
80106cd2:	e9 71 f6 ff ff       	jmp    80106348 <alltraps>

80106cd7 <vector89>:
.globl vector89
vector89:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $89
80106cd9:	6a 59                	push   $0x59
  jmp alltraps
80106cdb:	e9 68 f6 ff ff       	jmp    80106348 <alltraps>

80106ce0 <vector90>:
.globl vector90
vector90:
  pushl $0
80106ce0:	6a 00                	push   $0x0
  pushl $90
80106ce2:	6a 5a                	push   $0x5a
  jmp alltraps
80106ce4:	e9 5f f6 ff ff       	jmp    80106348 <alltraps>

80106ce9 <vector91>:
.globl vector91
vector91:
  pushl $0
80106ce9:	6a 00                	push   $0x0
  pushl $91
80106ceb:	6a 5b                	push   $0x5b
  jmp alltraps
80106ced:	e9 56 f6 ff ff       	jmp    80106348 <alltraps>

80106cf2 <vector92>:
.globl vector92
vector92:
  pushl $0
80106cf2:	6a 00                	push   $0x0
  pushl $92
80106cf4:	6a 5c                	push   $0x5c
  jmp alltraps
80106cf6:	e9 4d f6 ff ff       	jmp    80106348 <alltraps>

80106cfb <vector93>:
.globl vector93
vector93:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $93
80106cfd:	6a 5d                	push   $0x5d
  jmp alltraps
80106cff:	e9 44 f6 ff ff       	jmp    80106348 <alltraps>

80106d04 <vector94>:
.globl vector94
vector94:
  pushl $0
80106d04:	6a 00                	push   $0x0
  pushl $94
80106d06:	6a 5e                	push   $0x5e
  jmp alltraps
80106d08:	e9 3b f6 ff ff       	jmp    80106348 <alltraps>

80106d0d <vector95>:
.globl vector95
vector95:
  pushl $0
80106d0d:	6a 00                	push   $0x0
  pushl $95
80106d0f:	6a 5f                	push   $0x5f
  jmp alltraps
80106d11:	e9 32 f6 ff ff       	jmp    80106348 <alltraps>

80106d16 <vector96>:
.globl vector96
vector96:
  pushl $0
80106d16:	6a 00                	push   $0x0
  pushl $96
80106d18:	6a 60                	push   $0x60
  jmp alltraps
80106d1a:	e9 29 f6 ff ff       	jmp    80106348 <alltraps>

80106d1f <vector97>:
.globl vector97
vector97:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $97
80106d21:	6a 61                	push   $0x61
  jmp alltraps
80106d23:	e9 20 f6 ff ff       	jmp    80106348 <alltraps>

80106d28 <vector98>:
.globl vector98
vector98:
  pushl $0
80106d28:	6a 00                	push   $0x0
  pushl $98
80106d2a:	6a 62                	push   $0x62
  jmp alltraps
80106d2c:	e9 17 f6 ff ff       	jmp    80106348 <alltraps>

80106d31 <vector99>:
.globl vector99
vector99:
  pushl $0
80106d31:	6a 00                	push   $0x0
  pushl $99
80106d33:	6a 63                	push   $0x63
  jmp alltraps
80106d35:	e9 0e f6 ff ff       	jmp    80106348 <alltraps>

80106d3a <vector100>:
.globl vector100
vector100:
  pushl $0
80106d3a:	6a 00                	push   $0x0
  pushl $100
80106d3c:	6a 64                	push   $0x64
  jmp alltraps
80106d3e:	e9 05 f6 ff ff       	jmp    80106348 <alltraps>

80106d43 <vector101>:
.globl vector101
vector101:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $101
80106d45:	6a 65                	push   $0x65
  jmp alltraps
80106d47:	e9 fc f5 ff ff       	jmp    80106348 <alltraps>

80106d4c <vector102>:
.globl vector102
vector102:
  pushl $0
80106d4c:	6a 00                	push   $0x0
  pushl $102
80106d4e:	6a 66                	push   $0x66
  jmp alltraps
80106d50:	e9 f3 f5 ff ff       	jmp    80106348 <alltraps>

80106d55 <vector103>:
.globl vector103
vector103:
  pushl $0
80106d55:	6a 00                	push   $0x0
  pushl $103
80106d57:	6a 67                	push   $0x67
  jmp alltraps
80106d59:	e9 ea f5 ff ff       	jmp    80106348 <alltraps>

80106d5e <vector104>:
.globl vector104
vector104:
  pushl $0
80106d5e:	6a 00                	push   $0x0
  pushl $104
80106d60:	6a 68                	push   $0x68
  jmp alltraps
80106d62:	e9 e1 f5 ff ff       	jmp    80106348 <alltraps>

80106d67 <vector105>:
.globl vector105
vector105:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $105
80106d69:	6a 69                	push   $0x69
  jmp alltraps
80106d6b:	e9 d8 f5 ff ff       	jmp    80106348 <alltraps>

80106d70 <vector106>:
.globl vector106
vector106:
  pushl $0
80106d70:	6a 00                	push   $0x0
  pushl $106
80106d72:	6a 6a                	push   $0x6a
  jmp alltraps
80106d74:	e9 cf f5 ff ff       	jmp    80106348 <alltraps>

80106d79 <vector107>:
.globl vector107
vector107:
  pushl $0
80106d79:	6a 00                	push   $0x0
  pushl $107
80106d7b:	6a 6b                	push   $0x6b
  jmp alltraps
80106d7d:	e9 c6 f5 ff ff       	jmp    80106348 <alltraps>

80106d82 <vector108>:
.globl vector108
vector108:
  pushl $0
80106d82:	6a 00                	push   $0x0
  pushl $108
80106d84:	6a 6c                	push   $0x6c
  jmp alltraps
80106d86:	e9 bd f5 ff ff       	jmp    80106348 <alltraps>

80106d8b <vector109>:
.globl vector109
vector109:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $109
80106d8d:	6a 6d                	push   $0x6d
  jmp alltraps
80106d8f:	e9 b4 f5 ff ff       	jmp    80106348 <alltraps>

80106d94 <vector110>:
.globl vector110
vector110:
  pushl $0
80106d94:	6a 00                	push   $0x0
  pushl $110
80106d96:	6a 6e                	push   $0x6e
  jmp alltraps
80106d98:	e9 ab f5 ff ff       	jmp    80106348 <alltraps>

80106d9d <vector111>:
.globl vector111
vector111:
  pushl $0
80106d9d:	6a 00                	push   $0x0
  pushl $111
80106d9f:	6a 6f                	push   $0x6f
  jmp alltraps
80106da1:	e9 a2 f5 ff ff       	jmp    80106348 <alltraps>

80106da6 <vector112>:
.globl vector112
vector112:
  pushl $0
80106da6:	6a 00                	push   $0x0
  pushl $112
80106da8:	6a 70                	push   $0x70
  jmp alltraps
80106daa:	e9 99 f5 ff ff       	jmp    80106348 <alltraps>

80106daf <vector113>:
.globl vector113
vector113:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $113
80106db1:	6a 71                	push   $0x71
  jmp alltraps
80106db3:	e9 90 f5 ff ff       	jmp    80106348 <alltraps>

80106db8 <vector114>:
.globl vector114
vector114:
  pushl $0
80106db8:	6a 00                	push   $0x0
  pushl $114
80106dba:	6a 72                	push   $0x72
  jmp alltraps
80106dbc:	e9 87 f5 ff ff       	jmp    80106348 <alltraps>

80106dc1 <vector115>:
.globl vector115
vector115:
  pushl $0
80106dc1:	6a 00                	push   $0x0
  pushl $115
80106dc3:	6a 73                	push   $0x73
  jmp alltraps
80106dc5:	e9 7e f5 ff ff       	jmp    80106348 <alltraps>

80106dca <vector116>:
.globl vector116
vector116:
  pushl $0
80106dca:	6a 00                	push   $0x0
  pushl $116
80106dcc:	6a 74                	push   $0x74
  jmp alltraps
80106dce:	e9 75 f5 ff ff       	jmp    80106348 <alltraps>

80106dd3 <vector117>:
.globl vector117
vector117:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $117
80106dd5:	6a 75                	push   $0x75
  jmp alltraps
80106dd7:	e9 6c f5 ff ff       	jmp    80106348 <alltraps>

80106ddc <vector118>:
.globl vector118
vector118:
  pushl $0
80106ddc:	6a 00                	push   $0x0
  pushl $118
80106dde:	6a 76                	push   $0x76
  jmp alltraps
80106de0:	e9 63 f5 ff ff       	jmp    80106348 <alltraps>

80106de5 <vector119>:
.globl vector119
vector119:
  pushl $0
80106de5:	6a 00                	push   $0x0
  pushl $119
80106de7:	6a 77                	push   $0x77
  jmp alltraps
80106de9:	e9 5a f5 ff ff       	jmp    80106348 <alltraps>

80106dee <vector120>:
.globl vector120
vector120:
  pushl $0
80106dee:	6a 00                	push   $0x0
  pushl $120
80106df0:	6a 78                	push   $0x78
  jmp alltraps
80106df2:	e9 51 f5 ff ff       	jmp    80106348 <alltraps>

80106df7 <vector121>:
.globl vector121
vector121:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $121
80106df9:	6a 79                	push   $0x79
  jmp alltraps
80106dfb:	e9 48 f5 ff ff       	jmp    80106348 <alltraps>

80106e00 <vector122>:
.globl vector122
vector122:
  pushl $0
80106e00:	6a 00                	push   $0x0
  pushl $122
80106e02:	6a 7a                	push   $0x7a
  jmp alltraps
80106e04:	e9 3f f5 ff ff       	jmp    80106348 <alltraps>

80106e09 <vector123>:
.globl vector123
vector123:
  pushl $0
80106e09:	6a 00                	push   $0x0
  pushl $123
80106e0b:	6a 7b                	push   $0x7b
  jmp alltraps
80106e0d:	e9 36 f5 ff ff       	jmp    80106348 <alltraps>

80106e12 <vector124>:
.globl vector124
vector124:
  pushl $0
80106e12:	6a 00                	push   $0x0
  pushl $124
80106e14:	6a 7c                	push   $0x7c
  jmp alltraps
80106e16:	e9 2d f5 ff ff       	jmp    80106348 <alltraps>

80106e1b <vector125>:
.globl vector125
vector125:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $125
80106e1d:	6a 7d                	push   $0x7d
  jmp alltraps
80106e1f:	e9 24 f5 ff ff       	jmp    80106348 <alltraps>

80106e24 <vector126>:
.globl vector126
vector126:
  pushl $0
80106e24:	6a 00                	push   $0x0
  pushl $126
80106e26:	6a 7e                	push   $0x7e
  jmp alltraps
80106e28:	e9 1b f5 ff ff       	jmp    80106348 <alltraps>

80106e2d <vector127>:
.globl vector127
vector127:
  pushl $0
80106e2d:	6a 00                	push   $0x0
  pushl $127
80106e2f:	6a 7f                	push   $0x7f
  jmp alltraps
80106e31:	e9 12 f5 ff ff       	jmp    80106348 <alltraps>

80106e36 <vector128>:
.globl vector128
vector128:
  pushl $0
80106e36:	6a 00                	push   $0x0
  pushl $128
80106e38:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106e3d:	e9 06 f5 ff ff       	jmp    80106348 <alltraps>

80106e42 <vector129>:
.globl vector129
vector129:
  pushl $0
80106e42:	6a 00                	push   $0x0
  pushl $129
80106e44:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106e49:	e9 fa f4 ff ff       	jmp    80106348 <alltraps>

80106e4e <vector130>:
.globl vector130
vector130:
  pushl $0
80106e4e:	6a 00                	push   $0x0
  pushl $130
80106e50:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106e55:	e9 ee f4 ff ff       	jmp    80106348 <alltraps>

80106e5a <vector131>:
.globl vector131
vector131:
  pushl $0
80106e5a:	6a 00                	push   $0x0
  pushl $131
80106e5c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106e61:	e9 e2 f4 ff ff       	jmp    80106348 <alltraps>

80106e66 <vector132>:
.globl vector132
vector132:
  pushl $0
80106e66:	6a 00                	push   $0x0
  pushl $132
80106e68:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106e6d:	e9 d6 f4 ff ff       	jmp    80106348 <alltraps>

80106e72 <vector133>:
.globl vector133
vector133:
  pushl $0
80106e72:	6a 00                	push   $0x0
  pushl $133
80106e74:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106e79:	e9 ca f4 ff ff       	jmp    80106348 <alltraps>

80106e7e <vector134>:
.globl vector134
vector134:
  pushl $0
80106e7e:	6a 00                	push   $0x0
  pushl $134
80106e80:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106e85:	e9 be f4 ff ff       	jmp    80106348 <alltraps>

80106e8a <vector135>:
.globl vector135
vector135:
  pushl $0
80106e8a:	6a 00                	push   $0x0
  pushl $135
80106e8c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106e91:	e9 b2 f4 ff ff       	jmp    80106348 <alltraps>

80106e96 <vector136>:
.globl vector136
vector136:
  pushl $0
80106e96:	6a 00                	push   $0x0
  pushl $136
80106e98:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106e9d:	e9 a6 f4 ff ff       	jmp    80106348 <alltraps>

80106ea2 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ea2:	6a 00                	push   $0x0
  pushl $137
80106ea4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106ea9:	e9 9a f4 ff ff       	jmp    80106348 <alltraps>

80106eae <vector138>:
.globl vector138
vector138:
  pushl $0
80106eae:	6a 00                	push   $0x0
  pushl $138
80106eb0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106eb5:	e9 8e f4 ff ff       	jmp    80106348 <alltraps>

80106eba <vector139>:
.globl vector139
vector139:
  pushl $0
80106eba:	6a 00                	push   $0x0
  pushl $139
80106ebc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ec1:	e9 82 f4 ff ff       	jmp    80106348 <alltraps>

80106ec6 <vector140>:
.globl vector140
vector140:
  pushl $0
80106ec6:	6a 00                	push   $0x0
  pushl $140
80106ec8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106ecd:	e9 76 f4 ff ff       	jmp    80106348 <alltraps>

80106ed2 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ed2:	6a 00                	push   $0x0
  pushl $141
80106ed4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106ed9:	e9 6a f4 ff ff       	jmp    80106348 <alltraps>

80106ede <vector142>:
.globl vector142
vector142:
  pushl $0
80106ede:	6a 00                	push   $0x0
  pushl $142
80106ee0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106ee5:	e9 5e f4 ff ff       	jmp    80106348 <alltraps>

80106eea <vector143>:
.globl vector143
vector143:
  pushl $0
80106eea:	6a 00                	push   $0x0
  pushl $143
80106eec:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ef1:	e9 52 f4 ff ff       	jmp    80106348 <alltraps>

80106ef6 <vector144>:
.globl vector144
vector144:
  pushl $0
80106ef6:	6a 00                	push   $0x0
  pushl $144
80106ef8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106efd:	e9 46 f4 ff ff       	jmp    80106348 <alltraps>

80106f02 <vector145>:
.globl vector145
vector145:
  pushl $0
80106f02:	6a 00                	push   $0x0
  pushl $145
80106f04:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106f09:	e9 3a f4 ff ff       	jmp    80106348 <alltraps>

80106f0e <vector146>:
.globl vector146
vector146:
  pushl $0
80106f0e:	6a 00                	push   $0x0
  pushl $146
80106f10:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106f15:	e9 2e f4 ff ff       	jmp    80106348 <alltraps>

80106f1a <vector147>:
.globl vector147
vector147:
  pushl $0
80106f1a:	6a 00                	push   $0x0
  pushl $147
80106f1c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106f21:	e9 22 f4 ff ff       	jmp    80106348 <alltraps>

80106f26 <vector148>:
.globl vector148
vector148:
  pushl $0
80106f26:	6a 00                	push   $0x0
  pushl $148
80106f28:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106f2d:	e9 16 f4 ff ff       	jmp    80106348 <alltraps>

80106f32 <vector149>:
.globl vector149
vector149:
  pushl $0
80106f32:	6a 00                	push   $0x0
  pushl $149
80106f34:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106f39:	e9 0a f4 ff ff       	jmp    80106348 <alltraps>

80106f3e <vector150>:
.globl vector150
vector150:
  pushl $0
80106f3e:	6a 00                	push   $0x0
  pushl $150
80106f40:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106f45:	e9 fe f3 ff ff       	jmp    80106348 <alltraps>

80106f4a <vector151>:
.globl vector151
vector151:
  pushl $0
80106f4a:	6a 00                	push   $0x0
  pushl $151
80106f4c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106f51:	e9 f2 f3 ff ff       	jmp    80106348 <alltraps>

80106f56 <vector152>:
.globl vector152
vector152:
  pushl $0
80106f56:	6a 00                	push   $0x0
  pushl $152
80106f58:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106f5d:	e9 e6 f3 ff ff       	jmp    80106348 <alltraps>

80106f62 <vector153>:
.globl vector153
vector153:
  pushl $0
80106f62:	6a 00                	push   $0x0
  pushl $153
80106f64:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106f69:	e9 da f3 ff ff       	jmp    80106348 <alltraps>

80106f6e <vector154>:
.globl vector154
vector154:
  pushl $0
80106f6e:	6a 00                	push   $0x0
  pushl $154
80106f70:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106f75:	e9 ce f3 ff ff       	jmp    80106348 <alltraps>

80106f7a <vector155>:
.globl vector155
vector155:
  pushl $0
80106f7a:	6a 00                	push   $0x0
  pushl $155
80106f7c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106f81:	e9 c2 f3 ff ff       	jmp    80106348 <alltraps>

80106f86 <vector156>:
.globl vector156
vector156:
  pushl $0
80106f86:	6a 00                	push   $0x0
  pushl $156
80106f88:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106f8d:	e9 b6 f3 ff ff       	jmp    80106348 <alltraps>

80106f92 <vector157>:
.globl vector157
vector157:
  pushl $0
80106f92:	6a 00                	push   $0x0
  pushl $157
80106f94:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106f99:	e9 aa f3 ff ff       	jmp    80106348 <alltraps>

80106f9e <vector158>:
.globl vector158
vector158:
  pushl $0
80106f9e:	6a 00                	push   $0x0
  pushl $158
80106fa0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106fa5:	e9 9e f3 ff ff       	jmp    80106348 <alltraps>

80106faa <vector159>:
.globl vector159
vector159:
  pushl $0
80106faa:	6a 00                	push   $0x0
  pushl $159
80106fac:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106fb1:	e9 92 f3 ff ff       	jmp    80106348 <alltraps>

80106fb6 <vector160>:
.globl vector160
vector160:
  pushl $0
80106fb6:	6a 00                	push   $0x0
  pushl $160
80106fb8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106fbd:	e9 86 f3 ff ff       	jmp    80106348 <alltraps>

80106fc2 <vector161>:
.globl vector161
vector161:
  pushl $0
80106fc2:	6a 00                	push   $0x0
  pushl $161
80106fc4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106fc9:	e9 7a f3 ff ff       	jmp    80106348 <alltraps>

80106fce <vector162>:
.globl vector162
vector162:
  pushl $0
80106fce:	6a 00                	push   $0x0
  pushl $162
80106fd0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106fd5:	e9 6e f3 ff ff       	jmp    80106348 <alltraps>

80106fda <vector163>:
.globl vector163
vector163:
  pushl $0
80106fda:	6a 00                	push   $0x0
  pushl $163
80106fdc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106fe1:	e9 62 f3 ff ff       	jmp    80106348 <alltraps>

80106fe6 <vector164>:
.globl vector164
vector164:
  pushl $0
80106fe6:	6a 00                	push   $0x0
  pushl $164
80106fe8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106fed:	e9 56 f3 ff ff       	jmp    80106348 <alltraps>

80106ff2 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ff2:	6a 00                	push   $0x0
  pushl $165
80106ff4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106ff9:	e9 4a f3 ff ff       	jmp    80106348 <alltraps>

80106ffe <vector166>:
.globl vector166
vector166:
  pushl $0
80106ffe:	6a 00                	push   $0x0
  pushl $166
80107000:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107005:	e9 3e f3 ff ff       	jmp    80106348 <alltraps>

8010700a <vector167>:
.globl vector167
vector167:
  pushl $0
8010700a:	6a 00                	push   $0x0
  pushl $167
8010700c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107011:	e9 32 f3 ff ff       	jmp    80106348 <alltraps>

80107016 <vector168>:
.globl vector168
vector168:
  pushl $0
80107016:	6a 00                	push   $0x0
  pushl $168
80107018:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010701d:	e9 26 f3 ff ff       	jmp    80106348 <alltraps>

80107022 <vector169>:
.globl vector169
vector169:
  pushl $0
80107022:	6a 00                	push   $0x0
  pushl $169
80107024:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107029:	e9 1a f3 ff ff       	jmp    80106348 <alltraps>

8010702e <vector170>:
.globl vector170
vector170:
  pushl $0
8010702e:	6a 00                	push   $0x0
  pushl $170
80107030:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107035:	e9 0e f3 ff ff       	jmp    80106348 <alltraps>

8010703a <vector171>:
.globl vector171
vector171:
  pushl $0
8010703a:	6a 00                	push   $0x0
  pushl $171
8010703c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107041:	e9 02 f3 ff ff       	jmp    80106348 <alltraps>

80107046 <vector172>:
.globl vector172
vector172:
  pushl $0
80107046:	6a 00                	push   $0x0
  pushl $172
80107048:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010704d:	e9 f6 f2 ff ff       	jmp    80106348 <alltraps>

80107052 <vector173>:
.globl vector173
vector173:
  pushl $0
80107052:	6a 00                	push   $0x0
  pushl $173
80107054:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107059:	e9 ea f2 ff ff       	jmp    80106348 <alltraps>

8010705e <vector174>:
.globl vector174
vector174:
  pushl $0
8010705e:	6a 00                	push   $0x0
  pushl $174
80107060:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107065:	e9 de f2 ff ff       	jmp    80106348 <alltraps>

8010706a <vector175>:
.globl vector175
vector175:
  pushl $0
8010706a:	6a 00                	push   $0x0
  pushl $175
8010706c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107071:	e9 d2 f2 ff ff       	jmp    80106348 <alltraps>

80107076 <vector176>:
.globl vector176
vector176:
  pushl $0
80107076:	6a 00                	push   $0x0
  pushl $176
80107078:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010707d:	e9 c6 f2 ff ff       	jmp    80106348 <alltraps>

80107082 <vector177>:
.globl vector177
vector177:
  pushl $0
80107082:	6a 00                	push   $0x0
  pushl $177
80107084:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107089:	e9 ba f2 ff ff       	jmp    80106348 <alltraps>

8010708e <vector178>:
.globl vector178
vector178:
  pushl $0
8010708e:	6a 00                	push   $0x0
  pushl $178
80107090:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107095:	e9 ae f2 ff ff       	jmp    80106348 <alltraps>

8010709a <vector179>:
.globl vector179
vector179:
  pushl $0
8010709a:	6a 00                	push   $0x0
  pushl $179
8010709c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801070a1:	e9 a2 f2 ff ff       	jmp    80106348 <alltraps>

801070a6 <vector180>:
.globl vector180
vector180:
  pushl $0
801070a6:	6a 00                	push   $0x0
  pushl $180
801070a8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801070ad:	e9 96 f2 ff ff       	jmp    80106348 <alltraps>

801070b2 <vector181>:
.globl vector181
vector181:
  pushl $0
801070b2:	6a 00                	push   $0x0
  pushl $181
801070b4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801070b9:	e9 8a f2 ff ff       	jmp    80106348 <alltraps>

801070be <vector182>:
.globl vector182
vector182:
  pushl $0
801070be:	6a 00                	push   $0x0
  pushl $182
801070c0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801070c5:	e9 7e f2 ff ff       	jmp    80106348 <alltraps>

801070ca <vector183>:
.globl vector183
vector183:
  pushl $0
801070ca:	6a 00                	push   $0x0
  pushl $183
801070cc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801070d1:	e9 72 f2 ff ff       	jmp    80106348 <alltraps>

801070d6 <vector184>:
.globl vector184
vector184:
  pushl $0
801070d6:	6a 00                	push   $0x0
  pushl $184
801070d8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801070dd:	e9 66 f2 ff ff       	jmp    80106348 <alltraps>

801070e2 <vector185>:
.globl vector185
vector185:
  pushl $0
801070e2:	6a 00                	push   $0x0
  pushl $185
801070e4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801070e9:	e9 5a f2 ff ff       	jmp    80106348 <alltraps>

801070ee <vector186>:
.globl vector186
vector186:
  pushl $0
801070ee:	6a 00                	push   $0x0
  pushl $186
801070f0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801070f5:	e9 4e f2 ff ff       	jmp    80106348 <alltraps>

801070fa <vector187>:
.globl vector187
vector187:
  pushl $0
801070fa:	6a 00                	push   $0x0
  pushl $187
801070fc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107101:	e9 42 f2 ff ff       	jmp    80106348 <alltraps>

80107106 <vector188>:
.globl vector188
vector188:
  pushl $0
80107106:	6a 00                	push   $0x0
  pushl $188
80107108:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010710d:	e9 36 f2 ff ff       	jmp    80106348 <alltraps>

80107112 <vector189>:
.globl vector189
vector189:
  pushl $0
80107112:	6a 00                	push   $0x0
  pushl $189
80107114:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107119:	e9 2a f2 ff ff       	jmp    80106348 <alltraps>

8010711e <vector190>:
.globl vector190
vector190:
  pushl $0
8010711e:	6a 00                	push   $0x0
  pushl $190
80107120:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107125:	e9 1e f2 ff ff       	jmp    80106348 <alltraps>

8010712a <vector191>:
.globl vector191
vector191:
  pushl $0
8010712a:	6a 00                	push   $0x0
  pushl $191
8010712c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107131:	e9 12 f2 ff ff       	jmp    80106348 <alltraps>

80107136 <vector192>:
.globl vector192
vector192:
  pushl $0
80107136:	6a 00                	push   $0x0
  pushl $192
80107138:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010713d:	e9 06 f2 ff ff       	jmp    80106348 <alltraps>

80107142 <vector193>:
.globl vector193
vector193:
  pushl $0
80107142:	6a 00                	push   $0x0
  pushl $193
80107144:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107149:	e9 fa f1 ff ff       	jmp    80106348 <alltraps>

8010714e <vector194>:
.globl vector194
vector194:
  pushl $0
8010714e:	6a 00                	push   $0x0
  pushl $194
80107150:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107155:	e9 ee f1 ff ff       	jmp    80106348 <alltraps>

8010715a <vector195>:
.globl vector195
vector195:
  pushl $0
8010715a:	6a 00                	push   $0x0
  pushl $195
8010715c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107161:	e9 e2 f1 ff ff       	jmp    80106348 <alltraps>

80107166 <vector196>:
.globl vector196
vector196:
  pushl $0
80107166:	6a 00                	push   $0x0
  pushl $196
80107168:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010716d:	e9 d6 f1 ff ff       	jmp    80106348 <alltraps>

80107172 <vector197>:
.globl vector197
vector197:
  pushl $0
80107172:	6a 00                	push   $0x0
  pushl $197
80107174:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107179:	e9 ca f1 ff ff       	jmp    80106348 <alltraps>

8010717e <vector198>:
.globl vector198
vector198:
  pushl $0
8010717e:	6a 00                	push   $0x0
  pushl $198
80107180:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107185:	e9 be f1 ff ff       	jmp    80106348 <alltraps>

8010718a <vector199>:
.globl vector199
vector199:
  pushl $0
8010718a:	6a 00                	push   $0x0
  pushl $199
8010718c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107191:	e9 b2 f1 ff ff       	jmp    80106348 <alltraps>

80107196 <vector200>:
.globl vector200
vector200:
  pushl $0
80107196:	6a 00                	push   $0x0
  pushl $200
80107198:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010719d:	e9 a6 f1 ff ff       	jmp    80106348 <alltraps>

801071a2 <vector201>:
.globl vector201
vector201:
  pushl $0
801071a2:	6a 00                	push   $0x0
  pushl $201
801071a4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801071a9:	e9 9a f1 ff ff       	jmp    80106348 <alltraps>

801071ae <vector202>:
.globl vector202
vector202:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $202
801071b0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801071b5:	e9 8e f1 ff ff       	jmp    80106348 <alltraps>

801071ba <vector203>:
.globl vector203
vector203:
  pushl $0
801071ba:	6a 00                	push   $0x0
  pushl $203
801071bc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801071c1:	e9 82 f1 ff ff       	jmp    80106348 <alltraps>

801071c6 <vector204>:
.globl vector204
vector204:
  pushl $0
801071c6:	6a 00                	push   $0x0
  pushl $204
801071c8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801071cd:	e9 76 f1 ff ff       	jmp    80106348 <alltraps>

801071d2 <vector205>:
.globl vector205
vector205:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $205
801071d4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801071d9:	e9 6a f1 ff ff       	jmp    80106348 <alltraps>

801071de <vector206>:
.globl vector206
vector206:
  pushl $0
801071de:	6a 00                	push   $0x0
  pushl $206
801071e0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801071e5:	e9 5e f1 ff ff       	jmp    80106348 <alltraps>

801071ea <vector207>:
.globl vector207
vector207:
  pushl $0
801071ea:	6a 00                	push   $0x0
  pushl $207
801071ec:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801071f1:	e9 52 f1 ff ff       	jmp    80106348 <alltraps>

801071f6 <vector208>:
.globl vector208
vector208:
  pushl $0
801071f6:	6a 00                	push   $0x0
  pushl $208
801071f8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801071fd:	e9 46 f1 ff ff       	jmp    80106348 <alltraps>

80107202 <vector209>:
.globl vector209
vector209:
  pushl $0
80107202:	6a 00                	push   $0x0
  pushl $209
80107204:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107209:	e9 3a f1 ff ff       	jmp    80106348 <alltraps>

8010720e <vector210>:
.globl vector210
vector210:
  pushl $0
8010720e:	6a 00                	push   $0x0
  pushl $210
80107210:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107215:	e9 2e f1 ff ff       	jmp    80106348 <alltraps>

8010721a <vector211>:
.globl vector211
vector211:
  pushl $0
8010721a:	6a 00                	push   $0x0
  pushl $211
8010721c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107221:	e9 22 f1 ff ff       	jmp    80106348 <alltraps>

80107226 <vector212>:
.globl vector212
vector212:
  pushl $0
80107226:	6a 00                	push   $0x0
  pushl $212
80107228:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010722d:	e9 16 f1 ff ff       	jmp    80106348 <alltraps>

80107232 <vector213>:
.globl vector213
vector213:
  pushl $0
80107232:	6a 00                	push   $0x0
  pushl $213
80107234:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107239:	e9 0a f1 ff ff       	jmp    80106348 <alltraps>

8010723e <vector214>:
.globl vector214
vector214:
  pushl $0
8010723e:	6a 00                	push   $0x0
  pushl $214
80107240:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107245:	e9 fe f0 ff ff       	jmp    80106348 <alltraps>

8010724a <vector215>:
.globl vector215
vector215:
  pushl $0
8010724a:	6a 00                	push   $0x0
  pushl $215
8010724c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107251:	e9 f2 f0 ff ff       	jmp    80106348 <alltraps>

80107256 <vector216>:
.globl vector216
vector216:
  pushl $0
80107256:	6a 00                	push   $0x0
  pushl $216
80107258:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010725d:	e9 e6 f0 ff ff       	jmp    80106348 <alltraps>

80107262 <vector217>:
.globl vector217
vector217:
  pushl $0
80107262:	6a 00                	push   $0x0
  pushl $217
80107264:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107269:	e9 da f0 ff ff       	jmp    80106348 <alltraps>

8010726e <vector218>:
.globl vector218
vector218:
  pushl $0
8010726e:	6a 00                	push   $0x0
  pushl $218
80107270:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107275:	e9 ce f0 ff ff       	jmp    80106348 <alltraps>

8010727a <vector219>:
.globl vector219
vector219:
  pushl $0
8010727a:	6a 00                	push   $0x0
  pushl $219
8010727c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107281:	e9 c2 f0 ff ff       	jmp    80106348 <alltraps>

80107286 <vector220>:
.globl vector220
vector220:
  pushl $0
80107286:	6a 00                	push   $0x0
  pushl $220
80107288:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010728d:	e9 b6 f0 ff ff       	jmp    80106348 <alltraps>

80107292 <vector221>:
.globl vector221
vector221:
  pushl $0
80107292:	6a 00                	push   $0x0
  pushl $221
80107294:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107299:	e9 aa f0 ff ff       	jmp    80106348 <alltraps>

8010729e <vector222>:
.globl vector222
vector222:
  pushl $0
8010729e:	6a 00                	push   $0x0
  pushl $222
801072a0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801072a5:	e9 9e f0 ff ff       	jmp    80106348 <alltraps>

801072aa <vector223>:
.globl vector223
vector223:
  pushl $0
801072aa:	6a 00                	push   $0x0
  pushl $223
801072ac:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801072b1:	e9 92 f0 ff ff       	jmp    80106348 <alltraps>

801072b6 <vector224>:
.globl vector224
vector224:
  pushl $0
801072b6:	6a 00                	push   $0x0
  pushl $224
801072b8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801072bd:	e9 86 f0 ff ff       	jmp    80106348 <alltraps>

801072c2 <vector225>:
.globl vector225
vector225:
  pushl $0
801072c2:	6a 00                	push   $0x0
  pushl $225
801072c4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801072c9:	e9 7a f0 ff ff       	jmp    80106348 <alltraps>

801072ce <vector226>:
.globl vector226
vector226:
  pushl $0
801072ce:	6a 00                	push   $0x0
  pushl $226
801072d0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801072d5:	e9 6e f0 ff ff       	jmp    80106348 <alltraps>

801072da <vector227>:
.globl vector227
vector227:
  pushl $0
801072da:	6a 00                	push   $0x0
  pushl $227
801072dc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801072e1:	e9 62 f0 ff ff       	jmp    80106348 <alltraps>

801072e6 <vector228>:
.globl vector228
vector228:
  pushl $0
801072e6:	6a 00                	push   $0x0
  pushl $228
801072e8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801072ed:	e9 56 f0 ff ff       	jmp    80106348 <alltraps>

801072f2 <vector229>:
.globl vector229
vector229:
  pushl $0
801072f2:	6a 00                	push   $0x0
  pushl $229
801072f4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801072f9:	e9 4a f0 ff ff       	jmp    80106348 <alltraps>

801072fe <vector230>:
.globl vector230
vector230:
  pushl $0
801072fe:	6a 00                	push   $0x0
  pushl $230
80107300:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107305:	e9 3e f0 ff ff       	jmp    80106348 <alltraps>

8010730a <vector231>:
.globl vector231
vector231:
  pushl $0
8010730a:	6a 00                	push   $0x0
  pushl $231
8010730c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107311:	e9 32 f0 ff ff       	jmp    80106348 <alltraps>

80107316 <vector232>:
.globl vector232
vector232:
  pushl $0
80107316:	6a 00                	push   $0x0
  pushl $232
80107318:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010731d:	e9 26 f0 ff ff       	jmp    80106348 <alltraps>

80107322 <vector233>:
.globl vector233
vector233:
  pushl $0
80107322:	6a 00                	push   $0x0
  pushl $233
80107324:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107329:	e9 1a f0 ff ff       	jmp    80106348 <alltraps>

8010732e <vector234>:
.globl vector234
vector234:
  pushl $0
8010732e:	6a 00                	push   $0x0
  pushl $234
80107330:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107335:	e9 0e f0 ff ff       	jmp    80106348 <alltraps>

8010733a <vector235>:
.globl vector235
vector235:
  pushl $0
8010733a:	6a 00                	push   $0x0
  pushl $235
8010733c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107341:	e9 02 f0 ff ff       	jmp    80106348 <alltraps>

80107346 <vector236>:
.globl vector236
vector236:
  pushl $0
80107346:	6a 00                	push   $0x0
  pushl $236
80107348:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010734d:	e9 f6 ef ff ff       	jmp    80106348 <alltraps>

80107352 <vector237>:
.globl vector237
vector237:
  pushl $0
80107352:	6a 00                	push   $0x0
  pushl $237
80107354:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107359:	e9 ea ef ff ff       	jmp    80106348 <alltraps>

8010735e <vector238>:
.globl vector238
vector238:
  pushl $0
8010735e:	6a 00                	push   $0x0
  pushl $238
80107360:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107365:	e9 de ef ff ff       	jmp    80106348 <alltraps>

8010736a <vector239>:
.globl vector239
vector239:
  pushl $0
8010736a:	6a 00                	push   $0x0
  pushl $239
8010736c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107371:	e9 d2 ef ff ff       	jmp    80106348 <alltraps>

80107376 <vector240>:
.globl vector240
vector240:
  pushl $0
80107376:	6a 00                	push   $0x0
  pushl $240
80107378:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010737d:	e9 c6 ef ff ff       	jmp    80106348 <alltraps>

80107382 <vector241>:
.globl vector241
vector241:
  pushl $0
80107382:	6a 00                	push   $0x0
  pushl $241
80107384:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107389:	e9 ba ef ff ff       	jmp    80106348 <alltraps>

8010738e <vector242>:
.globl vector242
vector242:
  pushl $0
8010738e:	6a 00                	push   $0x0
  pushl $242
80107390:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107395:	e9 ae ef ff ff       	jmp    80106348 <alltraps>

8010739a <vector243>:
.globl vector243
vector243:
  pushl $0
8010739a:	6a 00                	push   $0x0
  pushl $243
8010739c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801073a1:	e9 a2 ef ff ff       	jmp    80106348 <alltraps>

801073a6 <vector244>:
.globl vector244
vector244:
  pushl $0
801073a6:	6a 00                	push   $0x0
  pushl $244
801073a8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801073ad:	e9 96 ef ff ff       	jmp    80106348 <alltraps>

801073b2 <vector245>:
.globl vector245
vector245:
  pushl $0
801073b2:	6a 00                	push   $0x0
  pushl $245
801073b4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801073b9:	e9 8a ef ff ff       	jmp    80106348 <alltraps>

801073be <vector246>:
.globl vector246
vector246:
  pushl $0
801073be:	6a 00                	push   $0x0
  pushl $246
801073c0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801073c5:	e9 7e ef ff ff       	jmp    80106348 <alltraps>

801073ca <vector247>:
.globl vector247
vector247:
  pushl $0
801073ca:	6a 00                	push   $0x0
  pushl $247
801073cc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801073d1:	e9 72 ef ff ff       	jmp    80106348 <alltraps>

801073d6 <vector248>:
.globl vector248
vector248:
  pushl $0
801073d6:	6a 00                	push   $0x0
  pushl $248
801073d8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801073dd:	e9 66 ef ff ff       	jmp    80106348 <alltraps>

801073e2 <vector249>:
.globl vector249
vector249:
  pushl $0
801073e2:	6a 00                	push   $0x0
  pushl $249
801073e4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801073e9:	e9 5a ef ff ff       	jmp    80106348 <alltraps>

801073ee <vector250>:
.globl vector250
vector250:
  pushl $0
801073ee:	6a 00                	push   $0x0
  pushl $250
801073f0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801073f5:	e9 4e ef ff ff       	jmp    80106348 <alltraps>

801073fa <vector251>:
.globl vector251
vector251:
  pushl $0
801073fa:	6a 00                	push   $0x0
  pushl $251
801073fc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107401:	e9 42 ef ff ff       	jmp    80106348 <alltraps>

80107406 <vector252>:
.globl vector252
vector252:
  pushl $0
80107406:	6a 00                	push   $0x0
  pushl $252
80107408:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010740d:	e9 36 ef ff ff       	jmp    80106348 <alltraps>

80107412 <vector253>:
.globl vector253
vector253:
  pushl $0
80107412:	6a 00                	push   $0x0
  pushl $253
80107414:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107419:	e9 2a ef ff ff       	jmp    80106348 <alltraps>

8010741e <vector254>:
.globl vector254
vector254:
  pushl $0
8010741e:	6a 00                	push   $0x0
  pushl $254
80107420:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107425:	e9 1e ef ff ff       	jmp    80106348 <alltraps>

8010742a <vector255>:
.globl vector255
vector255:
  pushl $0
8010742a:	6a 00                	push   $0x0
  pushl $255
8010742c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107431:	e9 12 ef ff ff       	jmp    80106348 <alltraps>
	...

80107438 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107438:	55                   	push   %ebp
80107439:	89 e5                	mov    %esp,%ebp
8010743b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010743e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107441:	83 e8 01             	sub    $0x1,%eax
80107444:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107448:	8b 45 08             	mov    0x8(%ebp),%eax
8010744b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010744f:	8b 45 08             	mov    0x8(%ebp),%eax
80107452:	c1 e8 10             	shr    $0x10,%eax
80107455:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107459:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010745c:	0f 01 10             	lgdtl  (%eax)
}
8010745f:	c9                   	leave  
80107460:	c3                   	ret    

80107461 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107461:	55                   	push   %ebp
80107462:	89 e5                	mov    %esp,%ebp
80107464:	83 ec 04             	sub    $0x4,%esp
80107467:	8b 45 08             	mov    0x8(%ebp),%eax
8010746a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010746e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107472:	0f 00 d8             	ltr    %ax
}
80107475:	c9                   	leave  
80107476:	c3                   	ret    

80107477 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107477:	55                   	push   %ebp
80107478:	89 e5                	mov    %esp,%ebp
8010747a:	83 ec 04             	sub    $0x4,%esp
8010747d:	8b 45 08             	mov    0x8(%ebp),%eax
80107480:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107484:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107488:	8e e8                	mov    %eax,%gs
}
8010748a:	c9                   	leave  
8010748b:	c3                   	ret    

8010748c <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
8010748c:	55                   	push   %ebp
8010748d:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010748f:	8b 45 08             	mov    0x8(%ebp),%eax
80107492:	0f 22 d8             	mov    %eax,%cr3
}
80107495:	5d                   	pop    %ebp
80107496:	c3                   	ret    

80107497 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107497:	55                   	push   %ebp
80107498:	89 e5                	mov    %esp,%ebp
8010749a:	8b 45 08             	mov    0x8(%ebp),%eax
8010749d:	2d 00 00 00 80       	sub    $0x80000000,%eax
801074a2:	5d                   	pop    %ebp
801074a3:	c3                   	ret    

801074a4 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801074a4:	55                   	push   %ebp
801074a5:	89 e5                	mov    %esp,%ebp
801074a7:	8b 45 08             	mov    0x8(%ebp),%eax
801074aa:	2d 00 00 00 80       	sub    $0x80000000,%eax
801074af:	5d                   	pop    %ebp
801074b0:	c3                   	ret    

801074b1 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801074b1:	55                   	push   %ebp
801074b2:	89 e5                	mov    %esp,%ebp
801074b4:	53                   	push   %ebx
801074b5:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801074b8:	e8 bb b9 ff ff       	call   80102e78 <cpunum>
801074bd:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801074c3:	05 20 f9 10 80       	add    $0x8010f920,%eax
801074c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801074cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ce:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801074d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d7:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801074dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e0:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801074e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e7:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801074eb:	83 e2 f0             	and    $0xfffffff0,%edx
801074ee:	83 ca 0a             	or     $0xa,%edx
801074f1:	88 50 7d             	mov    %dl,0x7d(%eax)
801074f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f7:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801074fb:	83 ca 10             	or     $0x10,%edx
801074fe:	88 50 7d             	mov    %dl,0x7d(%eax)
80107501:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107504:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107508:	83 e2 9f             	and    $0xffffff9f,%edx
8010750b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010750e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107511:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107515:	83 ca 80             	or     $0xffffff80,%edx
80107518:	88 50 7d             	mov    %dl,0x7d(%eax)
8010751b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010751e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107522:	83 ca 0f             	or     $0xf,%edx
80107525:	88 50 7e             	mov    %dl,0x7e(%eax)
80107528:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010752b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010752f:	83 e2 ef             	and    $0xffffffef,%edx
80107532:	88 50 7e             	mov    %dl,0x7e(%eax)
80107535:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107538:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010753c:	83 e2 df             	and    $0xffffffdf,%edx
8010753f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107542:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107545:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107549:	83 ca 40             	or     $0x40,%edx
8010754c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010754f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107552:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107556:	83 ca 80             	or     $0xffffff80,%edx
80107559:	88 50 7e             	mov    %dl,0x7e(%eax)
8010755c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010755f:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107566:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010756d:	ff ff 
8010756f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107572:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107579:	00 00 
8010757b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010757e:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107585:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107588:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010758f:	83 e2 f0             	and    $0xfffffff0,%edx
80107592:	83 ca 02             	or     $0x2,%edx
80107595:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010759b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010759e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801075a5:	83 ca 10             	or     $0x10,%edx
801075a8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801075ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b1:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801075b8:	83 e2 9f             	and    $0xffffff9f,%edx
801075bb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801075c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c4:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801075cb:	83 ca 80             	or     $0xffffff80,%edx
801075ce:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801075d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801075de:	83 ca 0f             	or     $0xf,%edx
801075e1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ea:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801075f1:	83 e2 ef             	and    $0xffffffef,%edx
801075f4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075fd:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107604:	83 e2 df             	and    $0xffffffdf,%edx
80107607:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010760d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107610:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107617:	83 ca 40             	or     $0x40,%edx
8010761a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107620:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107623:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010762a:	83 ca 80             	or     $0xffffff80,%edx
8010762d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107636:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010763d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107640:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107647:	ff ff 
80107649:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010764c:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107653:	00 00 
80107655:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107658:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010765f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107662:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107669:	83 e2 f0             	and    $0xfffffff0,%edx
8010766c:	83 ca 0a             	or     $0xa,%edx
8010766f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107678:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010767f:	83 ca 10             	or     $0x10,%edx
80107682:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107688:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010768b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107692:	83 ca 60             	or     $0x60,%edx
80107695:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010769b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801076a5:	83 ca 80             	or     $0xffffff80,%edx
801076a8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801076ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076b8:	83 ca 0f             	or     $0xf,%edx
801076bb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c4:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076cb:	83 e2 ef             	and    $0xffffffef,%edx
801076ce:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d7:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076de:	83 e2 df             	and    $0xffffffdf,%edx
801076e1:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ea:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076f1:	83 ca 40             	or     $0x40,%edx
801076f4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076fd:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107704:	83 ca 80             	or     $0xffffff80,%edx
80107707:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010770d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107710:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010771a:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107721:	ff ff 
80107723:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107726:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010772d:	00 00 
8010772f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107732:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107739:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010773c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107743:	83 e2 f0             	and    $0xfffffff0,%edx
80107746:	83 ca 02             	or     $0x2,%edx
80107749:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010774f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107752:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107759:	83 ca 10             	or     $0x10,%edx
8010775c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107765:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010776c:	83 ca 60             	or     $0x60,%edx
8010776f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107778:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010777f:	83 ca 80             	or     $0xffffff80,%edx
80107782:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010778b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107792:	83 ca 0f             	or     $0xf,%edx
80107795:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010779b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801077a5:	83 e2 ef             	and    $0xffffffef,%edx
801077a8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801077ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b1:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801077b8:	83 e2 df             	and    $0xffffffdf,%edx
801077bb:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801077c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c4:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801077cb:	83 ca 40             	or     $0x40,%edx
801077ce:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801077d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d7:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801077de:	83 ca 80             	or     $0xffffff80,%edx
801077e1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801077e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ea:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801077f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f4:	05 b4 00 00 00       	add    $0xb4,%eax
801077f9:	89 c3                	mov    %eax,%ebx
801077fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077fe:	05 b4 00 00 00       	add    $0xb4,%eax
80107803:	c1 e8 10             	shr    $0x10,%eax
80107806:	89 c1                	mov    %eax,%ecx
80107808:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780b:	05 b4 00 00 00       	add    $0xb4,%eax
80107810:	c1 e8 18             	shr    $0x18,%eax
80107813:	89 c2                	mov    %eax,%edx
80107815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107818:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010781f:	00 00 
80107821:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107824:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
8010782b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782e:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107837:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010783e:	83 e1 f0             	and    $0xfffffff0,%ecx
80107841:	83 c9 02             	or     $0x2,%ecx
80107844:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010784a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784d:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107854:	83 c9 10             	or     $0x10,%ecx
80107857:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010785d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107860:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107867:	83 e1 9f             	and    $0xffffff9f,%ecx
8010786a:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107870:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107873:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010787a:	83 c9 80             	or     $0xffffff80,%ecx
8010787d:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107883:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107886:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010788d:	83 e1 f0             	and    $0xfffffff0,%ecx
80107890:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107896:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107899:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801078a0:	83 e1 ef             	and    $0xffffffef,%ecx
801078a3:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801078a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ac:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801078b3:	83 e1 df             	and    $0xffffffdf,%ecx
801078b6:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801078bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078bf:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801078c6:	83 c9 40             	or     $0x40,%ecx
801078c9:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801078cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d2:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801078d9:	83 c9 80             	or     $0xffffff80,%ecx
801078dc:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801078e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e5:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801078eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ee:	83 c0 70             	add    $0x70,%eax
801078f1:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
801078f8:	00 
801078f9:	89 04 24             	mov    %eax,(%esp)
801078fc:	e8 37 fb ff ff       	call   80107438 <lgdt>
  loadgs(SEG_KCPU << 3);
80107901:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107908:	e8 6a fb ff ff       	call   80107477 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
8010790d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107910:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107916:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010791d:	00 00 00 00 
}
80107921:	83 c4 24             	add    $0x24,%esp
80107924:	5b                   	pop    %ebx
80107925:	5d                   	pop    %ebp
80107926:	c3                   	ret    

80107927 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107927:	55                   	push   %ebp
80107928:	89 e5                	mov    %esp,%ebp
8010792a:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010792d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107930:	c1 e8 16             	shr    $0x16,%eax
80107933:	c1 e0 02             	shl    $0x2,%eax
80107936:	03 45 08             	add    0x8(%ebp),%eax
80107939:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010793c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010793f:	8b 00                	mov    (%eax),%eax
80107941:	83 e0 01             	and    $0x1,%eax
80107944:	84 c0                	test   %al,%al
80107946:	74 17                	je     8010795f <walkpgdir+0x38>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107948:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010794b:	8b 00                	mov    (%eax),%eax
8010794d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107952:	89 04 24             	mov    %eax,(%esp)
80107955:	e8 4a fb ff ff       	call   801074a4 <p2v>
8010795a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010795d:	eb 4b                	jmp    801079aa <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010795f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107963:	74 0e                	je     80107973 <walkpgdir+0x4c>
80107965:	e8 94 b1 ff ff       	call   80102afe <kalloc>
8010796a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010796d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107971:	75 07                	jne    8010797a <walkpgdir+0x53>
      return 0;
80107973:	b8 00 00 00 00       	mov    $0x0,%eax
80107978:	eb 41                	jmp    801079bb <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010797a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107981:	00 
80107982:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107989:	00 
8010798a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010798d:	89 04 24             	mov    %eax,(%esp)
80107990:	e8 6d d5 ff ff       	call   80104f02 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107998:	89 04 24             	mov    %eax,(%esp)
8010799b:	e8 f7 fa ff ff       	call   80107497 <v2p>
801079a0:	89 c2                	mov    %eax,%edx
801079a2:	83 ca 07             	or     $0x7,%edx
801079a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079a8:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801079aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801079ad:	c1 e8 0c             	shr    $0xc,%eax
801079b0:	25 ff 03 00 00       	and    $0x3ff,%eax
801079b5:	c1 e0 02             	shl    $0x2,%eax
801079b8:	03 45 f4             	add    -0xc(%ebp),%eax
}
801079bb:	c9                   	leave  
801079bc:	c3                   	ret    

801079bd <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801079bd:	55                   	push   %ebp
801079be:	89 e5                	mov    %esp,%ebp
801079c0:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801079c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801079c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801079ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801079d1:	03 45 10             	add    0x10(%ebp),%eax
801079d4:	83 e8 01             	sub    $0x1,%eax
801079d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801079df:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801079e6:	00 
801079e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801079ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801079ee:	8b 45 08             	mov    0x8(%ebp),%eax
801079f1:	89 04 24             	mov    %eax,(%esp)
801079f4:	e8 2e ff ff ff       	call   80107927 <walkpgdir>
801079f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a00:	75 07                	jne    80107a09 <mappages+0x4c>
      return -1;
80107a02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a07:	eb 46                	jmp    80107a4f <mappages+0x92>
    if(*pte & PTE_P)
80107a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a0c:	8b 00                	mov    (%eax),%eax
80107a0e:	83 e0 01             	and    $0x1,%eax
80107a11:	84 c0                	test   %al,%al
80107a13:	74 0c                	je     80107a21 <mappages+0x64>
      panic("remap");
80107a15:	c7 04 24 50 88 10 80 	movl   $0x80108850,(%esp)
80107a1c:	e8 19 8b ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80107a21:	8b 45 18             	mov    0x18(%ebp),%eax
80107a24:	0b 45 14             	or     0x14(%ebp),%eax
80107a27:	89 c2                	mov    %eax,%edx
80107a29:	83 ca 01             	or     $0x1,%edx
80107a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2f:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a34:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107a37:	74 10                	je     80107a49 <mappages+0x8c>
      break;
    a += PGSIZE;
80107a39:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
    pa += PGSIZE;
80107a40:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107a47:	eb 96                	jmp    801079df <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107a49:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107a4f:	c9                   	leave  
80107a50:	c3                   	ret    

80107a51 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107a51:	55                   	push   %ebp
80107a52:	89 e5                	mov    %esp,%ebp
80107a54:	53                   	push   %ebx
80107a55:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107a58:	e8 a1 b0 ff ff       	call   80102afe <kalloc>
80107a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a64:	75 0a                	jne    80107a70 <setupkvm+0x1f>
    return 0;
80107a66:	b8 00 00 00 00       	mov    $0x0,%eax
80107a6b:	e9 99 00 00 00       	jmp    80107b09 <setupkvm+0xb8>
  memset(pgdir, 0, PGSIZE);
80107a70:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107a77:	00 
80107a78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107a7f:	00 
80107a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a83:	89 04 24             	mov    %eax,(%esp)
80107a86:	e8 77 d4 ff ff       	call   80104f02 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107a8b:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107a92:	e8 0d fa ff ff       	call   801074a4 <p2v>
80107a97:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107a9c:	76 0c                	jbe    80107aaa <setupkvm+0x59>
    panic("PHYSTOP too high");
80107a9e:	c7 04 24 56 88 10 80 	movl   $0x80108856,(%esp)
80107aa5:	e8 90 8a ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107aaa:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107ab1:	eb 49                	jmp    80107afc <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab6:	8b 48 0c             	mov    0xc(%eax),%ecx
80107ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107abc:	8b 50 04             	mov    0x4(%eax),%edx
80107abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac2:	8b 58 08             	mov    0x8(%eax),%ebx
80107ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac8:	8b 40 04             	mov    0x4(%eax),%eax
80107acb:	29 c3                	sub    %eax,%ebx
80107acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad0:	8b 00                	mov    (%eax),%eax
80107ad2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107ad6:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107ada:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107ade:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ae5:	89 04 24             	mov    %eax,(%esp)
80107ae8:	e8 d0 fe ff ff       	call   801079bd <mappages>
80107aed:	85 c0                	test   %eax,%eax
80107aef:	79 07                	jns    80107af8 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107af1:	b8 00 00 00 00       	mov    $0x0,%eax
80107af6:	eb 11                	jmp    80107b09 <setupkvm+0xb8>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107af8:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107afc:	b8 e0 b4 10 80       	mov    $0x8010b4e0,%eax
80107b01:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80107b04:	72 ad                	jb     80107ab3 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107b09:	83 c4 34             	add    $0x34,%esp
80107b0c:	5b                   	pop    %ebx
80107b0d:	5d                   	pop    %ebp
80107b0e:	c3                   	ret    

80107b0f <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107b0f:	55                   	push   %ebp
80107b10:	89 e5                	mov    %esp,%ebp
80107b12:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107b15:	e8 37 ff ff ff       	call   80107a51 <setupkvm>
80107b1a:	a3 b8 29 11 80       	mov    %eax,0x801129b8
  switchkvm();
80107b1f:	e8 02 00 00 00       	call   80107b26 <switchkvm>
}
80107b24:	c9                   	leave  
80107b25:	c3                   	ret    

80107b26 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107b26:	55                   	push   %ebp
80107b27:	89 e5                	mov    %esp,%ebp
80107b29:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107b2c:	a1 b8 29 11 80       	mov    0x801129b8,%eax
80107b31:	89 04 24             	mov    %eax,(%esp)
80107b34:	e8 5e f9 ff ff       	call   80107497 <v2p>
80107b39:	89 04 24             	mov    %eax,(%esp)
80107b3c:	e8 4b f9 ff ff       	call   8010748c <lcr3>
}
80107b41:	c9                   	leave  
80107b42:	c3                   	ret    

80107b43 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107b43:	55                   	push   %ebp
80107b44:	89 e5                	mov    %esp,%ebp
80107b46:	53                   	push   %ebx
80107b47:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107b4a:	e8 ad d2 ff ff       	call   80104dfc <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107b4f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b55:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107b5c:	83 c2 08             	add    $0x8,%edx
80107b5f:	89 d3                	mov    %edx,%ebx
80107b61:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107b68:	83 c2 08             	add    $0x8,%edx
80107b6b:	c1 ea 10             	shr    $0x10,%edx
80107b6e:	89 d1                	mov    %edx,%ecx
80107b70:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107b77:	83 c2 08             	add    $0x8,%edx
80107b7a:	c1 ea 18             	shr    $0x18,%edx
80107b7d:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107b84:	67 00 
80107b86:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107b8d:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107b93:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107b9a:	83 e1 f0             	and    $0xfffffff0,%ecx
80107b9d:	83 c9 09             	or     $0x9,%ecx
80107ba0:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107ba6:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107bad:	83 c9 10             	or     $0x10,%ecx
80107bb0:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107bb6:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107bbd:	83 e1 9f             	and    $0xffffff9f,%ecx
80107bc0:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107bc6:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107bcd:	83 c9 80             	or     $0xffffff80,%ecx
80107bd0:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107bd6:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107bdd:	83 e1 f0             	and    $0xfffffff0,%ecx
80107be0:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107be6:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107bed:	83 e1 ef             	and    $0xffffffef,%ecx
80107bf0:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107bf6:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107bfd:	83 e1 df             	and    $0xffffffdf,%ecx
80107c00:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107c06:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107c0d:	83 c9 40             	or     $0x40,%ecx
80107c10:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107c16:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107c1d:	83 e1 7f             	and    $0x7f,%ecx
80107c20:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107c26:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107c2c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c32:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107c39:	83 e2 ef             	and    $0xffffffef,%edx
80107c3c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107c42:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c48:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107c4e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c54:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107c5b:	8b 52 08             	mov    0x8(%edx),%edx
80107c5e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107c64:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107c67:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107c6e:	e8 ee f7 ff ff       	call   80107461 <ltr>
  if(p->pgdir == 0)
80107c73:	8b 45 08             	mov    0x8(%ebp),%eax
80107c76:	8b 40 04             	mov    0x4(%eax),%eax
80107c79:	85 c0                	test   %eax,%eax
80107c7b:	75 0c                	jne    80107c89 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107c7d:	c7 04 24 67 88 10 80 	movl   $0x80108867,(%esp)
80107c84:	e8 b1 88 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107c89:	8b 45 08             	mov    0x8(%ebp),%eax
80107c8c:	8b 40 04             	mov    0x4(%eax),%eax
80107c8f:	89 04 24             	mov    %eax,(%esp)
80107c92:	e8 00 f8 ff ff       	call   80107497 <v2p>
80107c97:	89 04 24             	mov    %eax,(%esp)
80107c9a:	e8 ed f7 ff ff       	call   8010748c <lcr3>
  popcli();
80107c9f:	e8 a0 d1 ff ff       	call   80104e44 <popcli>
}
80107ca4:	83 c4 14             	add    $0x14,%esp
80107ca7:	5b                   	pop    %ebx
80107ca8:	5d                   	pop    %ebp
80107ca9:	c3                   	ret    

80107caa <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107caa:	55                   	push   %ebp
80107cab:	89 e5                	mov    %esp,%ebp
80107cad:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107cb0:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107cb7:	76 0c                	jbe    80107cc5 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107cb9:	c7 04 24 7b 88 10 80 	movl   $0x8010887b,(%esp)
80107cc0:	e8 75 88 ff ff       	call   8010053a <panic>
  mem = kalloc();
80107cc5:	e8 34 ae ff ff       	call   80102afe <kalloc>
80107cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107ccd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107cd4:	00 
80107cd5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107cdc:	00 
80107cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce0:	89 04 24             	mov    %eax,(%esp)
80107ce3:	e8 1a d2 ff ff       	call   80104f02 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ceb:	89 04 24             	mov    %eax,(%esp)
80107cee:	e8 a4 f7 ff ff       	call   80107497 <v2p>
80107cf3:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107cfa:	00 
80107cfb:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107cff:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d06:	00 
80107d07:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107d0e:	00 
80107d0f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d12:	89 04 24             	mov    %eax,(%esp)
80107d15:	e8 a3 fc ff ff       	call   801079bd <mappages>
  memmove(mem, init, sz);
80107d1a:	8b 45 10             	mov    0x10(%ebp),%eax
80107d1d:	89 44 24 08          	mov    %eax,0x8(%esp)
80107d21:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d24:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2b:	89 04 24             	mov    %eax,(%esp)
80107d2e:	e8 a2 d2 ff ff       	call   80104fd5 <memmove>
}
80107d33:	c9                   	leave  
80107d34:	c3                   	ret    

80107d35 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107d35:	55                   	push   %ebp
80107d36:	89 e5                	mov    %esp,%ebp
80107d38:	53                   	push   %ebx
80107d39:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d3f:	25 ff 0f 00 00       	and    $0xfff,%eax
80107d44:	85 c0                	test   %eax,%eax
80107d46:	74 0c                	je     80107d54 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107d48:	c7 04 24 98 88 10 80 	movl   $0x80108898,(%esp)
80107d4f:	e8 e6 87 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107d54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80107d5b:	e9 ae 00 00 00       	jmp    80107e0e <loaduvm+0xd9>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107d60:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d63:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d66:	8d 04 02             	lea    (%edx,%eax,1),%eax
80107d69:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107d70:	00 
80107d71:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d75:	8b 45 08             	mov    0x8(%ebp),%eax
80107d78:	89 04 24             	mov    %eax,(%esp)
80107d7b:	e8 a7 fb ff ff       	call   80107927 <walkpgdir>
80107d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107d83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107d87:	75 0c                	jne    80107d95 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107d89:	c7 04 24 bb 88 10 80 	movl   $0x801088bb,(%esp)
80107d90:	e8 a5 87 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80107d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d98:	8b 00                	mov    (%eax),%eax
80107d9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(sz - i < PGSIZE)
80107da2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107da5:	8b 55 18             	mov    0x18(%ebp),%edx
80107da8:	89 d1                	mov    %edx,%ecx
80107daa:	29 c1                	sub    %eax,%ecx
80107dac:	89 c8                	mov    %ecx,%eax
80107dae:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107db3:	77 11                	ja     80107dc6 <loaduvm+0x91>
      n = sz - i;
80107db5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107db8:	8b 55 18             	mov    0x18(%ebp),%edx
80107dbb:	89 d1                	mov    %edx,%ecx
80107dbd:	29 c1                	sub    %eax,%ecx
80107dbf:	89 c8                	mov    %ecx,%eax
80107dc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107dc4:	eb 07                	jmp    80107dcd <loaduvm+0x98>
    else
      n = PGSIZE;
80107dc6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107dcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107dd0:	8b 55 14             	mov    0x14(%ebp),%edx
80107dd3:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107dd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107dd9:	89 04 24             	mov    %eax,(%esp)
80107ddc:	e8 c3 f6 ff ff       	call   801074a4 <p2v>
80107de1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107de4:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107de8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107dec:	89 44 24 04          	mov    %eax,0x4(%esp)
80107df0:	8b 45 10             	mov    0x10(%ebp),%eax
80107df3:	89 04 24             	mov    %eax,(%esp)
80107df6:	e8 6d 9f ff ff       	call   80101d68 <readi>
80107dfb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107dfe:	74 07                	je     80107e07 <loaduvm+0xd2>
      return -1;
80107e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e05:	eb 18                	jmp    80107e1f <loaduvm+0xea>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107e07:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
80107e0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e11:	3b 45 18             	cmp    0x18(%ebp),%eax
80107e14:	0f 82 46 ff ff ff    	jb     80107d60 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107e1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e1f:	83 c4 24             	add    $0x24,%esp
80107e22:	5b                   	pop    %ebx
80107e23:	5d                   	pop    %ebp
80107e24:	c3                   	ret    

80107e25 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107e25:	55                   	push   %ebp
80107e26:	89 e5                	mov    %esp,%ebp
80107e28:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107e2b:	8b 45 10             	mov    0x10(%ebp),%eax
80107e2e:	85 c0                	test   %eax,%eax
80107e30:	79 0a                	jns    80107e3c <allocuvm+0x17>
    return 0;
80107e32:	b8 00 00 00 00       	mov    $0x0,%eax
80107e37:	e9 c1 00 00 00       	jmp    80107efd <allocuvm+0xd8>
  if(newsz < oldsz)
80107e3c:	8b 45 10             	mov    0x10(%ebp),%eax
80107e3f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e42:	73 08                	jae    80107e4c <allocuvm+0x27>
    return oldsz;
80107e44:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e47:	e9 b1 00 00 00       	jmp    80107efd <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80107e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e4f:	05 ff 0f 00 00       	add    $0xfff,%eax
80107e54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107e5c:	e9 8d 00 00 00       	jmp    80107eee <allocuvm+0xc9>
    mem = kalloc();
80107e61:	e8 98 ac ff ff       	call   80102afe <kalloc>
80107e66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107e69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e6d:	75 2c                	jne    80107e9b <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80107e6f:	c7 04 24 d9 88 10 80 	movl   $0x801088d9,(%esp)
80107e76:	e8 1f 85 ff ff       	call   8010039a <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e7e:	89 44 24 08          	mov    %eax,0x8(%esp)
80107e82:	8b 45 10             	mov    0x10(%ebp),%eax
80107e85:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e89:	8b 45 08             	mov    0x8(%ebp),%eax
80107e8c:	89 04 24             	mov    %eax,(%esp)
80107e8f:	e8 6b 00 00 00       	call   80107eff <deallocuvm>
      return 0;
80107e94:	b8 00 00 00 00       	mov    $0x0,%eax
80107e99:	eb 62                	jmp    80107efd <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80107e9b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ea2:	00 
80107ea3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107eaa:	00 
80107eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107eae:	89 04 24             	mov    %eax,(%esp)
80107eb1:	e8 4c d0 ff ff       	call   80104f02 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107eb9:	89 04 24             	mov    %eax,(%esp)
80107ebc:	e8 d6 f5 ff ff       	call   80107497 <v2p>
80107ec1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107ec4:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107ecb:	00 
80107ecc:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107ed0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ed7:	00 
80107ed8:	89 54 24 04          	mov    %edx,0x4(%esp)
80107edc:	8b 45 08             	mov    0x8(%ebp),%eax
80107edf:	89 04 24             	mov    %eax,(%esp)
80107ee2:	e8 d6 fa ff ff       	call   801079bd <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107ee7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef1:	3b 45 10             	cmp    0x10(%ebp),%eax
80107ef4:	0f 82 67 ff ff ff    	jb     80107e61 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80107efa:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107efd:	c9                   	leave  
80107efe:	c3                   	ret    

80107eff <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107eff:	55                   	push   %ebp
80107f00:	89 e5                	mov    %esp,%ebp
80107f02:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107f05:	8b 45 10             	mov    0x10(%ebp),%eax
80107f08:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107f0b:	72 08                	jb     80107f15 <deallocuvm+0x16>
    return oldsz;
80107f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f10:	e9 a4 00 00 00       	jmp    80107fb9 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80107f15:	8b 45 10             	mov    0x10(%ebp),%eax
80107f18:	05 ff 0f 00 00       	add    $0xfff,%eax
80107f1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f22:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107f25:	e9 80 00 00 00       	jmp    80107faa <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107f2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f2d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f34:	00 
80107f35:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f39:	8b 45 08             	mov    0x8(%ebp),%eax
80107f3c:	89 04 24             	mov    %eax,(%esp)
80107f3f:	e8 e3 f9 ff ff       	call   80107927 <walkpgdir>
80107f44:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(!pte)
80107f47:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107f4b:	75 09                	jne    80107f56 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80107f4d:	81 45 ec 00 f0 3f 00 	addl   $0x3ff000,-0x14(%ebp)
80107f54:	eb 4d                	jmp    80107fa3 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80107f56:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f59:	8b 00                	mov    (%eax),%eax
80107f5b:	83 e0 01             	and    $0x1,%eax
80107f5e:	84 c0                	test   %al,%al
80107f60:	74 41                	je     80107fa3 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80107f62:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f65:	8b 00                	mov    (%eax),%eax
80107f67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(pa == 0)
80107f6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107f73:	75 0c                	jne    80107f81 <deallocuvm+0x82>
        panic("kfree");
80107f75:	c7 04 24 f1 88 10 80 	movl   $0x801088f1,(%esp)
80107f7c:	e8 b9 85 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80107f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f84:	89 04 24             	mov    %eax,(%esp)
80107f87:	e8 18 f5 ff ff       	call   801074a4 <p2v>
80107f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
80107f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f92:	89 04 24             	mov    %eax,(%esp)
80107f95:	e8 cb aa ff ff       	call   80102a65 <kfree>
      *pte = 0;
80107f9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107fa3:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
80107faa:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fad:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107fb0:	0f 82 74 ff ff ff    	jb     80107f2a <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80107fb6:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107fb9:	c9                   	leave  
80107fba:	c3                   	ret    

80107fbb <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107fbb:	55                   	push   %ebp
80107fbc:	89 e5                	mov    %esp,%ebp
80107fbe:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80107fc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107fc5:	75 0c                	jne    80107fd3 <freevm+0x18>
    panic("freevm: no pgdir");
80107fc7:	c7 04 24 f7 88 10 80 	movl   $0x801088f7,(%esp)
80107fce:	e8 67 85 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107fd3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107fda:	00 
80107fdb:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107fe2:	80 
80107fe3:	8b 45 08             	mov    0x8(%ebp),%eax
80107fe6:	89 04 24             	mov    %eax,(%esp)
80107fe9:	e8 11 ff ff ff       	call   80107eff <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107fee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80107ff5:	eb 3c                	jmp    80108033 <freevm+0x78>
    if(pgdir[i] & PTE_P){
80107ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ffa:	c1 e0 02             	shl    $0x2,%eax
80107ffd:	03 45 08             	add    0x8(%ebp),%eax
80108000:	8b 00                	mov    (%eax),%eax
80108002:	83 e0 01             	and    $0x1,%eax
80108005:	84 c0                	test   %al,%al
80108007:	74 26                	je     8010802f <freevm+0x74>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108009:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010800c:	c1 e0 02             	shl    $0x2,%eax
8010800f:	03 45 08             	add    0x8(%ebp),%eax
80108012:	8b 00                	mov    (%eax),%eax
80108014:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108019:	89 04 24             	mov    %eax,(%esp)
8010801c:	e8 83 f4 ff ff       	call   801074a4 <p2v>
80108021:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
80108024:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108027:	89 04 24             	mov    %eax,(%esp)
8010802a:	e8 36 aa ff ff       	call   80102a65 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010802f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108033:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
8010803a:	76 bb                	jbe    80107ff7 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010803c:	8b 45 08             	mov    0x8(%ebp),%eax
8010803f:	89 04 24             	mov    %eax,(%esp)
80108042:	e8 1e aa ff ff       	call   80102a65 <kfree>
}
80108047:	c9                   	leave  
80108048:	c3                   	ret    

80108049 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108049:	55                   	push   %ebp
8010804a:	89 e5                	mov    %esp,%ebp
8010804c:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010804f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108056:	00 
80108057:	8b 45 0c             	mov    0xc(%ebp),%eax
8010805a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010805e:	8b 45 08             	mov    0x8(%ebp),%eax
80108061:	89 04 24             	mov    %eax,(%esp)
80108064:	e8 be f8 ff ff       	call   80107927 <walkpgdir>
80108069:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010806c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108070:	75 0c                	jne    8010807e <clearpteu+0x35>
    panic("clearpteu");
80108072:	c7 04 24 08 89 10 80 	movl   $0x80108908,(%esp)
80108079:	e8 bc 84 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
8010807e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108081:	8b 00                	mov    (%eax),%eax
80108083:	89 c2                	mov    %eax,%edx
80108085:	83 e2 fb             	and    $0xfffffffb,%edx
80108088:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808b:	89 10                	mov    %edx,(%eax)
}
8010808d:	c9                   	leave  
8010808e:	c3                   	ret    

8010808f <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010808f:	55                   	push   %ebp
80108090:	89 e5                	mov    %esp,%ebp
80108092:	53                   	push   %ebx
80108093:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108096:	e8 b6 f9 ff ff       	call   80107a51 <setupkvm>
8010809b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010809e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801080a2:	75 0a                	jne    801080ae <copyuvm+0x1f>
    return 0;
801080a4:	b8 00 00 00 00       	mov    $0x0,%eax
801080a9:	e9 fd 00 00 00       	jmp    801081ab <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
801080ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801080b5:	e9 cc 00 00 00       	jmp    80108186 <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801080ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080bd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801080c4:	00 
801080c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801080c9:	8b 45 08             	mov    0x8(%ebp),%eax
801080cc:	89 04 24             	mov    %eax,(%esp)
801080cf:	e8 53 f8 ff ff       	call   80107927 <walkpgdir>
801080d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801080d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801080db:	75 0c                	jne    801080e9 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
801080dd:	c7 04 24 12 89 10 80 	movl   $0x80108912,(%esp)
801080e4:	e8 51 84 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
801080e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080ec:	8b 00                	mov    (%eax),%eax
801080ee:	83 e0 01             	and    $0x1,%eax
801080f1:	85 c0                	test   %eax,%eax
801080f3:	75 0c                	jne    80108101 <copyuvm+0x72>
      panic("copyuvm: page not present");
801080f5:	c7 04 24 2c 89 10 80 	movl   $0x8010892c,(%esp)
801080fc:	e8 39 84 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108101:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108104:	8b 00                	mov    (%eax),%eax
80108106:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010810b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010810e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108111:	8b 00                	mov    (%eax),%eax
80108113:	25 ff 0f 00 00       	and    $0xfff,%eax
80108118:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mem = kalloc()) == 0)
8010811b:	e8 de a9 ff ff       	call   80102afe <kalloc>
80108120:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108123:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108127:	74 6e                	je     80108197 <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108129:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010812c:	89 04 24             	mov    %eax,(%esp)
8010812f:	e8 70 f3 ff ff       	call   801074a4 <p2v>
80108134:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010813b:	00 
8010813c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108140:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108143:	89 04 24             	mov    %eax,(%esp)
80108146:	e8 8a ce ff ff       	call   80104fd5 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010814b:	8b 5d f0             	mov    -0x10(%ebp),%ebx
8010814e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108151:	89 04 24             	mov    %eax,(%esp)
80108154:	e8 3e f3 ff ff       	call   80107497 <v2p>
80108159:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010815c:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108160:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108164:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010816b:	00 
8010816c:	89 54 24 04          	mov    %edx,0x4(%esp)
80108170:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108173:	89 04 24             	mov    %eax,(%esp)
80108176:	e8 42 f8 ff ff       	call   801079bd <mappages>
8010817b:	85 c0                	test   %eax,%eax
8010817d:	78 1b                	js     8010819a <copyuvm+0x10b>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010817f:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
80108186:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108189:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010818c:	0f 82 28 ff ff ff    	jb     801080ba <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108192:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108195:	eb 14                	jmp    801081ab <copyuvm+0x11c>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108197:	90                   	nop
80108198:	eb 01                	jmp    8010819b <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
8010819a:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010819b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010819e:	89 04 24             	mov    %eax,(%esp)
801081a1:	e8 15 fe ff ff       	call   80107fbb <freevm>
  return 0;
801081a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081ab:	83 c4 44             	add    $0x44,%esp
801081ae:	5b                   	pop    %ebx
801081af:	5d                   	pop    %ebp
801081b0:	c3                   	ret    

801081b1 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801081b1:	55                   	push   %ebp
801081b2:	89 e5                	mov    %esp,%ebp
801081b4:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801081b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801081be:	00 
801081bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801081c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801081c6:	8b 45 08             	mov    0x8(%ebp),%eax
801081c9:	89 04 24             	mov    %eax,(%esp)
801081cc:	e8 56 f7 ff ff       	call   80107927 <walkpgdir>
801081d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801081d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d7:	8b 00                	mov    (%eax),%eax
801081d9:	83 e0 01             	and    $0x1,%eax
801081dc:	85 c0                	test   %eax,%eax
801081de:	75 07                	jne    801081e7 <uva2ka+0x36>
    return 0;
801081e0:	b8 00 00 00 00       	mov    $0x0,%eax
801081e5:	eb 25                	jmp    8010820c <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
801081e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ea:	8b 00                	mov    (%eax),%eax
801081ec:	83 e0 04             	and    $0x4,%eax
801081ef:	85 c0                	test   %eax,%eax
801081f1:	75 07                	jne    801081fa <uva2ka+0x49>
    return 0;
801081f3:	b8 00 00 00 00       	mov    $0x0,%eax
801081f8:	eb 12                	jmp    8010820c <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
801081fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081fd:	8b 00                	mov    (%eax),%eax
801081ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108204:	89 04 24             	mov    %eax,(%esp)
80108207:	e8 98 f2 ff ff       	call   801074a4 <p2v>
}
8010820c:	c9                   	leave  
8010820d:	c3                   	ret    

8010820e <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010820e:	55                   	push   %ebp
8010820f:	89 e5                	mov    %esp,%ebp
80108211:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108214:	8b 45 10             	mov    0x10(%ebp),%eax
80108217:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(len > 0){
8010821a:	e9 8b 00 00 00       	jmp    801082aa <copyout+0x9c>
    va0 = (uint)PGROUNDDOWN(va);
8010821f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108222:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108227:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010822a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108231:	8b 45 08             	mov    0x8(%ebp),%eax
80108234:	89 04 24             	mov    %eax,(%esp)
80108237:	e8 75 ff ff ff       	call   801081b1 <uva2ka>
8010823c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pa0 == 0)
8010823f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108243:	75 07                	jne    8010824c <copyout+0x3e>
      return -1;
80108245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010824a:	eb 6d                	jmp    801082b9 <copyout+0xab>
    n = PGSIZE - (va - va0);
8010824c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010824f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108252:	89 d1                	mov    %edx,%ecx
80108254:	29 c1                	sub    %eax,%ecx
80108256:	89 c8                	mov    %ecx,%eax
80108258:	05 00 10 00 00       	add    $0x1000,%eax
8010825d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108260:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108263:	3b 45 14             	cmp    0x14(%ebp),%eax
80108266:	76 06                	jbe    8010826e <copyout+0x60>
      n = len;
80108268:	8b 45 14             	mov    0x14(%ebp),%eax
8010826b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010826e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108271:	8b 55 0c             	mov    0xc(%ebp),%edx
80108274:	89 d1                	mov    %edx,%ecx
80108276:	29 c1                	sub    %eax,%ecx
80108278:	89 c8                	mov    %ecx,%eax
8010827a:	03 45 ec             	add    -0x14(%ebp),%eax
8010827d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108280:	89 54 24 08          	mov    %edx,0x8(%esp)
80108284:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108287:	89 54 24 04          	mov    %edx,0x4(%esp)
8010828b:	89 04 24             	mov    %eax,(%esp)
8010828e:	e8 42 cd ff ff       	call   80104fd5 <memmove>
    len -= n;
80108293:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108296:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108299:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010829c:	01 45 e8             	add    %eax,-0x18(%ebp)
    va = va0 + PGSIZE;
8010829f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a2:	05 00 10 00 00       	add    $0x1000,%eax
801082a7:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801082aa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801082ae:	0f 85 6b ff ff ff    	jne    8010821f <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801082b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801082b9:	c9                   	leave  
801082ba:	c3                   	ret    
