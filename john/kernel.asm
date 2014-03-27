
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp
8010002d:	b8 60 34 10 80       	mov    $0x80103460,%eax
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
8010003a:	c7 44 24 04 d4 82 10 	movl   $0x801082d4,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 b0 4c 00 00       	call   80104cfe <initlock>

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
801000a5:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000bd:	e8 5d 4c 00 00       	call   80104d1f <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 db 10 80       	mov    0x8010db94,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	89 c2                	mov    %eax,%edx
801000f5:	83 ca 01             	or     $0x1,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100104:	e8 77 4c 00 00       	call   80104d80 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 0c 49 00 00       	call   80104a30 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 db 10 80       	mov    0x8010db90,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017c:	e8 ff 4b 00 00       	call   80104d80 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 db 82 10 80 	movl   $0x801082db,(%esp)
8010019f:	e8 a2 03 00 00       	call   80100546 <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 58 26 00 00       	call   80102830 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 ec 82 10 80 	movl   $0x801082ec,(%esp)
801001f6:	e8 4b 03 00 00       	call   80100546 <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	89 c2                	mov    %eax,%edx
80100202:	83 ca 04             	or     $0x4,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 1b 26 00 00       	call   80102830 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 f3 82 10 80 	movl   $0x801082f3,(%esp)
80100230:	e8 11 03 00 00       	call   80100546 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023c:	e8 de 4a 00 00       	call   80104d1f <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 db 10 80       	mov    0x8010db94,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 db 10 80       	mov    %eax,0x8010db94

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	89 c2                	mov    %eax,%edx
8010028f:	83 e2 fe             	and    $0xfffffffe,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 76 48 00 00       	call   80104b18 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002a9:	e8 d2 4a 00 00       	call   80104d80 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	53                   	push   %ebx
801002b4:	83 ec 14             	sub    $0x14,%esp
801002b7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ba:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002be:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
801002c2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801002c6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801002ca:	ec                   	in     (%dx),%al
801002cb:	89 c3                	mov    %eax,%ebx
801002cd:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801002d0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801002d4:	83 c4 14             	add    $0x14,%esp
801002d7:	5b                   	pop    %ebx
801002d8:	5d                   	pop    %ebp
801002d9:	c3                   	ret    

801002da <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002da:	55                   	push   %ebp
801002db:	89 e5                	mov    %esp,%ebp
801002dd:	83 ec 08             	sub    $0x8,%esp
801002e0:	8b 55 08             	mov    0x8(%ebp),%edx
801002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801002e6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002ea:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002ed:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002f1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002f5:	ee                   	out    %al,(%dx)
}
801002f6:	c9                   	leave  
801002f7:	c3                   	ret    

801002f8 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002f8:	55                   	push   %ebp
801002f9:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002fb:	fa                   	cli    
}
801002fc:	5d                   	pop    %ebp
801002fd:	c3                   	ret    

801002fe <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002fe:	55                   	push   %ebp
801002ff:	89 e5                	mov    %esp,%ebp
80100301:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100304:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100308:	74 1c                	je     80100326 <printint+0x28>
8010030a:	8b 45 08             	mov    0x8(%ebp),%eax
8010030d:	c1 e8 1f             	shr    $0x1f,%eax
80100310:	0f b6 c0             	movzbl %al,%eax
80100313:	89 45 10             	mov    %eax,0x10(%ebp)
80100316:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010031a:	74 0a                	je     80100326 <printint+0x28>
    x = -xx;
8010031c:	8b 45 08             	mov    0x8(%ebp),%eax
8010031f:	f7 d8                	neg    %eax
80100321:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100324:	eb 06                	jmp    8010032c <printint+0x2e>
  else
    x = xx;
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010032c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100333:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100336:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100339:	ba 00 00 00 00       	mov    $0x0,%edx
8010033e:	f7 f1                	div    %ecx
80100340:	89 d0                	mov    %edx,%eax
80100342:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100349:	8d 4d e0             	lea    -0x20(%ebp),%ecx
8010034c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010034f:	01 ca                	add    %ecx,%edx
80100351:	88 02                	mov    %al,(%edx)
80100353:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
80100357:	8b 55 0c             	mov    0xc(%ebp),%edx
8010035a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010035d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100360:	ba 00 00 00 00       	mov    $0x0,%edx
80100365:	f7 75 d4             	divl   -0x2c(%ebp)
80100368:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010036b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010036f:	75 c2                	jne    80100333 <printint+0x35>

  if(sign)
80100371:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100375:	74 27                	je     8010039e <printint+0xa0>
    buf[i++] = '-';
80100377:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037d:	01 d0                	add    %edx,%eax
8010037f:	c6 00 2d             	movb   $0x2d,(%eax)
80100382:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
80100386:	eb 16                	jmp    8010039e <printint+0xa0>
    consputc(buf[i]);
80100388:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010038b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038e:	01 d0                	add    %edx,%eax
80100390:	0f b6 00             	movzbl (%eax),%eax
80100393:	0f be c0             	movsbl %al,%eax
80100396:	89 04 24             	mov    %eax,(%esp)
80100399:	e8 bb 03 00 00       	call   80100759 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010039e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003a6:	79 e0                	jns    80100388 <printint+0x8a>
    consputc(buf[i]);
}
801003a8:	c9                   	leave  
801003a9:	c3                   	ret    

801003aa <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003aa:	55                   	push   %ebp
801003ab:	89 e5                	mov    %esp,%ebp
801003ad:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003b0:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003bc:	74 0c                	je     801003ca <cprintf+0x20>
    acquire(&cons.lock);
801003be:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003c5:	e8 55 49 00 00       	call   80104d1f <acquire>

  if (fmt == 0)
801003ca:	8b 45 08             	mov    0x8(%ebp),%eax
801003cd:	85 c0                	test   %eax,%eax
801003cf:	75 0c                	jne    801003dd <cprintf+0x33>
    panic("null fmt");
801003d1:	c7 04 24 fa 82 10 80 	movl   $0x801082fa,(%esp)
801003d8:	e8 69 01 00 00       	call   80100546 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003dd:	8d 45 0c             	lea    0xc(%ebp),%eax
801003e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003ea:	e9 20 01 00 00       	jmp    8010050f <cprintf+0x165>
    if(c != '%'){
801003ef:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003f3:	74 10                	je     80100405 <cprintf+0x5b>
      consputc(c);
801003f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003f8:	89 04 24             	mov    %eax,(%esp)
801003fb:	e8 59 03 00 00       	call   80100759 <consputc>
      continue;
80100400:	e9 06 01 00 00       	jmp    8010050b <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
80100405:	8b 55 08             	mov    0x8(%ebp),%edx
80100408:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010040c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010040f:	01 d0                	add    %edx,%eax
80100411:	0f b6 00             	movzbl (%eax),%eax
80100414:	0f be c0             	movsbl %al,%eax
80100417:	25 ff 00 00 00       	and    $0xff,%eax
8010041c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010041f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100423:	0f 84 08 01 00 00    	je     80100531 <cprintf+0x187>
      break;
    switch(c){
80100429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010042c:	83 f8 70             	cmp    $0x70,%eax
8010042f:	74 4d                	je     8010047e <cprintf+0xd4>
80100431:	83 f8 70             	cmp    $0x70,%eax
80100434:	7f 13                	jg     80100449 <cprintf+0x9f>
80100436:	83 f8 25             	cmp    $0x25,%eax
80100439:	0f 84 a6 00 00 00    	je     801004e5 <cprintf+0x13b>
8010043f:	83 f8 64             	cmp    $0x64,%eax
80100442:	74 14                	je     80100458 <cprintf+0xae>
80100444:	e9 aa 00 00 00       	jmp    801004f3 <cprintf+0x149>
80100449:	83 f8 73             	cmp    $0x73,%eax
8010044c:	74 53                	je     801004a1 <cprintf+0xf7>
8010044e:	83 f8 78             	cmp    $0x78,%eax
80100451:	74 2b                	je     8010047e <cprintf+0xd4>
80100453:	e9 9b 00 00 00       	jmp    801004f3 <cprintf+0x149>
    case 'd':
      printint(*argp++, 10, 1);
80100458:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010045b:	8b 00                	mov    (%eax),%eax
8010045d:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100461:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100468:	00 
80100469:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100470:	00 
80100471:	89 04 24             	mov    %eax,(%esp)
80100474:	e8 85 fe ff ff       	call   801002fe <printint>
      break;
80100479:	e9 8d 00 00 00       	jmp    8010050b <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010047e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100481:	8b 00                	mov    (%eax),%eax
80100483:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100487:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010048e:	00 
8010048f:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100496:	00 
80100497:	89 04 24             	mov    %eax,(%esp)
8010049a:	e8 5f fe ff ff       	call   801002fe <printint>
      break;
8010049f:	eb 6a                	jmp    8010050b <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
801004a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004a4:	8b 00                	mov    (%eax),%eax
801004a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ad:	0f 94 c0             	sete   %al
801004b0:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004b4:	84 c0                	test   %al,%al
801004b6:	74 20                	je     801004d8 <cprintf+0x12e>
        s = "(null)";
801004b8:	c7 45 ec 03 83 10 80 	movl   $0x80108303,-0x14(%ebp)
      for(; *s; s++)
801004bf:	eb 17                	jmp    801004d8 <cprintf+0x12e>
        consputc(*s);
801004c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004c4:	0f b6 00             	movzbl (%eax),%eax
801004c7:	0f be c0             	movsbl %al,%eax
801004ca:	89 04 24             	mov    %eax,(%esp)
801004cd:	e8 87 02 00 00       	call   80100759 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004d2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d6:	eb 01                	jmp    801004d9 <cprintf+0x12f>
801004d8:	90                   	nop
801004d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004dc:	0f b6 00             	movzbl (%eax),%eax
801004df:	84 c0                	test   %al,%al
801004e1:	75 de                	jne    801004c1 <cprintf+0x117>
        consputc(*s);
      break;
801004e3:	eb 26                	jmp    8010050b <cprintf+0x161>
    case '%':
      consputc('%');
801004e5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ec:	e8 68 02 00 00       	call   80100759 <consputc>
      break;
801004f1:	eb 18                	jmp    8010050b <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004f3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004fa:	e8 5a 02 00 00       	call   80100759 <consputc>
      consputc(c);
801004ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100502:	89 04 24             	mov    %eax,(%esp)
80100505:	e8 4f 02 00 00       	call   80100759 <consputc>
      break;
8010050a:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010050b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010050f:	8b 55 08             	mov    0x8(%ebp),%edx
80100512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100515:	01 d0                	add    %edx,%eax
80100517:	0f b6 00             	movzbl (%eax),%eax
8010051a:	0f be c0             	movsbl %al,%eax
8010051d:	25 ff 00 00 00       	and    $0xff,%eax
80100522:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100525:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100529:	0f 85 c0 fe ff ff    	jne    801003ef <cprintf+0x45>
8010052f:	eb 01                	jmp    80100532 <cprintf+0x188>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100531:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100532:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100536:	74 0c                	je     80100544 <cprintf+0x19a>
    release(&cons.lock);
80100538:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010053f:	e8 3c 48 00 00       	call   80104d80 <release>
}
80100544:	c9                   	leave  
80100545:	c3                   	ret    

80100546 <panic>:

void
panic(char *s)
{
80100546:	55                   	push   %ebp
80100547:	89 e5                	mov    %esp,%ebp
80100549:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
8010054c:	e8 a7 fd ff ff       	call   801002f8 <cli>
  cons.locking = 0;
80100551:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
80100558:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010055b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100561:	0f b6 00             	movzbl (%eax),%eax
80100564:	0f b6 c0             	movzbl %al,%eax
80100567:	89 44 24 04          	mov    %eax,0x4(%esp)
8010056b:	c7 04 24 0a 83 10 80 	movl   $0x8010830a,(%esp)
80100572:	e8 33 fe ff ff       	call   801003aa <cprintf>
  cprintf(s);
80100577:	8b 45 08             	mov    0x8(%ebp),%eax
8010057a:	89 04 24             	mov    %eax,(%esp)
8010057d:	e8 28 fe ff ff       	call   801003aa <cprintf>
  cprintf("\n");
80100582:	c7 04 24 19 83 10 80 	movl   $0x80108319,(%esp)
80100589:	e8 1c fe ff ff       	call   801003aa <cprintf>
  getcallerpcs(&s, pcs);
8010058e:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100591:	89 44 24 04          	mov    %eax,0x4(%esp)
80100595:	8d 45 08             	lea    0x8(%ebp),%eax
80100598:	89 04 24             	mov    %eax,(%esp)
8010059b:	e8 2f 48 00 00       	call   80104dcf <getcallerpcs>
  for(i=0; i<10; i++)
801005a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005a7:	eb 1b                	jmp    801005c4 <panic+0x7e>
    cprintf(" %p", pcs[i]);
801005a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005ac:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801005b4:	c7 04 24 1b 83 10 80 	movl   $0x8010831b,(%esp)
801005bb:	e8 ea fd ff ff       	call   801003aa <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005c4:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005c8:	7e df                	jle    801005a9 <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005ca:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005d1:	00 00 00 
  for(;;)
    ;
801005d4:	eb fe                	jmp    801005d4 <panic+0x8e>

801005d6 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005d6:	55                   	push   %ebp
801005d7:	89 e5                	mov    %esp,%ebp
801005d9:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005dc:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005e3:	00 
801005e4:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005eb:	e8 ea fc ff ff       	call   801002da <outb>
  pos = inb(CRTPORT+1) << 8;
801005f0:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005f7:	e8 b4 fc ff ff       	call   801002b0 <inb>
801005fc:	0f b6 c0             	movzbl %al,%eax
801005ff:	c1 e0 08             	shl    $0x8,%eax
80100602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100605:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010060c:	00 
8010060d:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100614:	e8 c1 fc ff ff       	call   801002da <outb>
  pos |= inb(CRTPORT+1);
80100619:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100620:	e8 8b fc ff ff       	call   801002b0 <inb>
80100625:	0f b6 c0             	movzbl %al,%eax
80100628:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010062b:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010062f:	75 30                	jne    80100661 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100631:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100634:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100639:	89 c8                	mov    %ecx,%eax
8010063b:	f7 ea                	imul   %edx
8010063d:	c1 fa 05             	sar    $0x5,%edx
80100640:	89 c8                	mov    %ecx,%eax
80100642:	c1 f8 1f             	sar    $0x1f,%eax
80100645:	29 c2                	sub    %eax,%edx
80100647:	89 d0                	mov    %edx,%eax
80100649:	c1 e0 02             	shl    $0x2,%eax
8010064c:	01 d0                	add    %edx,%eax
8010064e:	c1 e0 04             	shl    $0x4,%eax
80100651:	89 ca                	mov    %ecx,%edx
80100653:	29 c2                	sub    %eax,%edx
80100655:	b8 50 00 00 00       	mov    $0x50,%eax
8010065a:	29 d0                	sub    %edx,%eax
8010065c:	01 45 f4             	add    %eax,-0xc(%ebp)
8010065f:	eb 32                	jmp    80100693 <cgaputc+0xbd>
  else if(c == BACKSPACE){
80100661:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100668:	75 0c                	jne    80100676 <cgaputc+0xa0>
    if(pos > 0) --pos;
8010066a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010066e:	7e 23                	jle    80100693 <cgaputc+0xbd>
80100670:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100674:	eb 1d                	jmp    80100693 <cgaputc+0xbd>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100676:	a1 00 90 10 80       	mov    0x80109000,%eax
8010067b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010067e:	01 d2                	add    %edx,%edx
80100680:	01 c2                	add    %eax,%edx
80100682:	8b 45 08             	mov    0x8(%ebp),%eax
80100685:	66 25 ff 00          	and    $0xff,%ax
80100689:	80 cc 07             	or     $0x7,%ah
8010068c:	66 89 02             	mov    %ax,(%edx)
8010068f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
80100693:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
8010069a:	7e 53                	jle    801006ef <cgaputc+0x119>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010069c:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006a7:	a1 00 90 10 80       	mov    0x80109000,%eax
801006ac:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006b3:	00 
801006b4:	89 54 24 04          	mov    %edx,0x4(%esp)
801006b8:	89 04 24             	mov    %eax,(%esp)
801006bb:	e8 81 49 00 00       	call   80105041 <memmove>
    pos -= 80;
801006c0:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006c4:	b8 80 07 00 00       	mov    $0x780,%eax
801006c9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006cc:	01 c0                	add    %eax,%eax
801006ce:	8b 15 00 90 10 80    	mov    0x80109000,%edx
801006d4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006d7:	01 c9                	add    %ecx,%ecx
801006d9:	01 ca                	add    %ecx,%edx
801006db:	89 44 24 08          	mov    %eax,0x8(%esp)
801006df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006e6:	00 
801006e7:	89 14 24             	mov    %edx,(%esp)
801006ea:	e8 7f 48 00 00       	call   80104f6e <memset>
  }
  
  outb(CRTPORT, 14);
801006ef:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006f6:	00 
801006f7:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006fe:	e8 d7 fb ff ff       	call   801002da <outb>
  outb(CRTPORT+1, pos>>8);
80100703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100706:	c1 f8 08             	sar    $0x8,%eax
80100709:	0f b6 c0             	movzbl %al,%eax
8010070c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100710:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100717:	e8 be fb ff ff       	call   801002da <outb>
  outb(CRTPORT, 15);
8010071c:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100723:	00 
80100724:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010072b:	e8 aa fb ff ff       	call   801002da <outb>
  outb(CRTPORT+1, pos);
80100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100733:	0f b6 c0             	movzbl %al,%eax
80100736:	89 44 24 04          	mov    %eax,0x4(%esp)
8010073a:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100741:	e8 94 fb ff ff       	call   801002da <outb>
  crt[pos] = ' ' | 0x0700;
80100746:	a1 00 90 10 80       	mov    0x80109000,%eax
8010074b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010074e:	01 d2                	add    %edx,%edx
80100750:	01 d0                	add    %edx,%eax
80100752:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100757:	c9                   	leave  
80100758:	c3                   	ret    

80100759 <consputc>:

void
consputc(int c)
{
80100759:	55                   	push   %ebp
8010075a:	89 e5                	mov    %esp,%ebp
8010075c:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
8010075f:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
80100764:	85 c0                	test   %eax,%eax
80100766:	74 07                	je     8010076f <consputc+0x16>
    cli();
80100768:	e8 8b fb ff ff       	call   801002f8 <cli>
    for(;;)
      ;
8010076d:	eb fe                	jmp    8010076d <consputc+0x14>
  }

  if(c == BACKSPACE){
8010076f:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100776:	75 26                	jne    8010079e <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100778:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010077f:	e8 a1 61 00 00       	call   80106925 <uartputc>
80100784:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010078b:	e8 95 61 00 00       	call   80106925 <uartputc>
80100790:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100797:	e8 89 61 00 00       	call   80106925 <uartputc>
8010079c:	eb 0b                	jmp    801007a9 <consputc+0x50>
  } else
    uartputc(c);
8010079e:	8b 45 08             	mov    0x8(%ebp),%eax
801007a1:	89 04 24             	mov    %eax,(%esp)
801007a4:	e8 7c 61 00 00       	call   80106925 <uartputc>
  cgaputc(c);
801007a9:	8b 45 08             	mov    0x8(%ebp),%eax
801007ac:	89 04 24             	mov    %eax,(%esp)
801007af:	e8 22 fe ff ff       	call   801005d6 <cgaputc>
}
801007b4:	c9                   	leave  
801007b5:	c3                   	ret    

801007b6 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b6:	55                   	push   %ebp
801007b7:	89 e5                	mov    %esp,%ebp
801007b9:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007bc:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801007c3:	e8 57 45 00 00       	call   80104d1f <acquire>
  while((c = getc()) >= 0){
801007c8:	e9 41 01 00 00       	jmp    8010090e <consoleintr+0x158>
    switch(c){
801007cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007d0:	83 f8 10             	cmp    $0x10,%eax
801007d3:	74 1e                	je     801007f3 <consoleintr+0x3d>
801007d5:	83 f8 10             	cmp    $0x10,%eax
801007d8:	7f 0a                	jg     801007e4 <consoleintr+0x2e>
801007da:	83 f8 08             	cmp    $0x8,%eax
801007dd:	74 68                	je     80100847 <consoleintr+0x91>
801007df:	e9 94 00 00 00       	jmp    80100878 <consoleintr+0xc2>
801007e4:	83 f8 15             	cmp    $0x15,%eax
801007e7:	74 2f                	je     80100818 <consoleintr+0x62>
801007e9:	83 f8 7f             	cmp    $0x7f,%eax
801007ec:	74 59                	je     80100847 <consoleintr+0x91>
801007ee:	e9 85 00 00 00       	jmp    80100878 <consoleintr+0xc2>
    case C('P'):  // Process listing.
      procdump();
801007f3:	e8 d2 43 00 00       	call   80104bca <procdump>
      break;
801007f8:	e9 11 01 00 00       	jmp    8010090e <consoleintr+0x158>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007fd:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100802:	83 e8 01             	sub    $0x1,%eax
80100805:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
8010080a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100811:	e8 43 ff ff ff       	call   80100759 <consputc>
80100816:	eb 01                	jmp    80100819 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100818:	90                   	nop
80100819:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010081f:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100824:	39 c2                	cmp    %eax,%edx
80100826:	0f 84 db 00 00 00    	je     80100907 <consoleintr+0x151>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010082c:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100831:	83 e8 01             	sub    $0x1,%eax
80100834:	83 e0 7f             	and    $0x7f,%eax
80100837:	0f b6 80 d4 dd 10 80 	movzbl -0x7fef222c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010083e:	3c 0a                	cmp    $0xa,%al
80100840:	75 bb                	jne    801007fd <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100842:	e9 c0 00 00 00       	jmp    80100907 <consoleintr+0x151>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100847:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010084d:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100852:	39 c2                	cmp    %eax,%edx
80100854:	0f 84 b0 00 00 00    	je     8010090a <consoleintr+0x154>
        input.e--;
8010085a:	a1 5c de 10 80       	mov    0x8010de5c,%eax
8010085f:	83 e8 01             	sub    $0x1,%eax
80100862:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
80100867:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010086e:	e8 e6 fe ff ff       	call   80100759 <consputc>
      }
      break;
80100873:	e9 92 00 00 00       	jmp    8010090a <consoleintr+0x154>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100878:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010087c:	0f 84 8b 00 00 00    	je     8010090d <consoleintr+0x157>
80100882:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100888:	a1 54 de 10 80       	mov    0x8010de54,%eax
8010088d:	89 d1                	mov    %edx,%ecx
8010088f:	29 c1                	sub    %eax,%ecx
80100891:	89 c8                	mov    %ecx,%eax
80100893:	83 f8 7f             	cmp    $0x7f,%eax
80100896:	77 75                	ja     8010090d <consoleintr+0x157>
        c = (c == '\r') ? '\n' : c;
80100898:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010089c:	74 05                	je     801008a3 <consoleintr+0xed>
8010089e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008a1:	eb 05                	jmp    801008a8 <consoleintr+0xf2>
801008a3:	b8 0a 00 00 00       	mov    $0xa,%eax
801008a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008ab:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008b0:	89 c1                	mov    %eax,%ecx
801008b2:	83 e1 7f             	and    $0x7f,%ecx
801008b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008b8:	88 91 d4 dd 10 80    	mov    %dl,-0x7fef222c(%ecx)
801008be:	83 c0 01             	add    $0x1,%eax
801008c1:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(c);
801008c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008c9:	89 04 24             	mov    %eax,(%esp)
801008cc:	e8 88 fe ff ff       	call   80100759 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008d1:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008d5:	74 18                	je     801008ef <consoleintr+0x139>
801008d7:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008db:	74 12                	je     801008ef <consoleintr+0x139>
801008dd:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008e2:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801008e8:	83 ea 80             	sub    $0xffffff80,%edx
801008eb:	39 d0                	cmp    %edx,%eax
801008ed:	75 1e                	jne    8010090d <consoleintr+0x157>
          input.w = input.e;
801008ef:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008f4:	a3 58 de 10 80       	mov    %eax,0x8010de58
          wakeup(&input.r);
801008f9:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
80100900:	e8 13 42 00 00       	call   80104b18 <wakeup>
        }
      }
      break;
80100905:	eb 06                	jmp    8010090d <consoleintr+0x157>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100907:	90                   	nop
80100908:	eb 04                	jmp    8010090e <consoleintr+0x158>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010090a:	90                   	nop
8010090b:	eb 01                	jmp    8010090e <consoleintr+0x158>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
8010090d:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
8010090e:	8b 45 08             	mov    0x8(%ebp),%eax
80100911:	ff d0                	call   *%eax
80100913:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100916:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010091a:	0f 89 ad fe ff ff    	jns    801007cd <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100920:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100927:	e8 54 44 00 00       	call   80104d80 <release>
}
8010092c:	c9                   	leave  
8010092d:	c3                   	ret    

8010092e <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010092e:	55                   	push   %ebp
8010092f:	89 e5                	mov    %esp,%ebp
80100931:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100934:	8b 45 08             	mov    0x8(%ebp),%eax
80100937:	89 04 24             	mov    %eax,(%esp)
8010093a:	e8 d3 10 00 00       	call   80101a12 <iunlock>
  target = n;
8010093f:	8b 45 10             	mov    0x10(%ebp),%eax
80100942:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100945:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010094c:	e8 ce 43 00 00       	call   80104d1f <acquire>
  while(n > 0){
80100951:	e9 a8 00 00 00       	jmp    801009fe <consoleread+0xd0>
    while(input.r == input.w){
      if(proc->killed){
80100956:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010095c:	8b 40 24             	mov    0x24(%eax),%eax
8010095f:	85 c0                	test   %eax,%eax
80100961:	74 21                	je     80100984 <consoleread+0x56>
        release(&input.lock);
80100963:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010096a:	e8 11 44 00 00       	call   80104d80 <release>
        ilock(ip);
8010096f:	8b 45 08             	mov    0x8(%ebp),%eax
80100972:	89 04 24             	mov    %eax,(%esp)
80100975:	e8 4a 0f 00 00       	call   801018c4 <ilock>
        return -1;
8010097a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010097f:	e9 a9 00 00 00       	jmp    80100a2d <consoleread+0xff>
      }
      sleep(&input.r, &input.lock);
80100984:	c7 44 24 04 a0 dd 10 	movl   $0x8010dda0,0x4(%esp)
8010098b:	80 
8010098c:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
80100993:	e8 98 40 00 00       	call   80104a30 <sleep>
80100998:	eb 01                	jmp    8010099b <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
8010099a:	90                   	nop
8010099b:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801009a1:	a1 58 de 10 80       	mov    0x8010de58,%eax
801009a6:	39 c2                	cmp    %eax,%edx
801009a8:	74 ac                	je     80100956 <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009aa:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009af:	89 c2                	mov    %eax,%edx
801009b1:	83 e2 7f             	and    $0x7f,%edx
801009b4:	0f b6 92 d4 dd 10 80 	movzbl -0x7fef222c(%edx),%edx
801009bb:	0f be d2             	movsbl %dl,%edx
801009be:	89 55 f0             	mov    %edx,-0x10(%ebp)
801009c1:	83 c0 01             	add    $0x1,%eax
801009c4:	a3 54 de 10 80       	mov    %eax,0x8010de54
    if(c == C('D')){  // EOF
801009c9:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009cd:	75 17                	jne    801009e6 <consoleread+0xb8>
      if(n < target){
801009cf:	8b 45 10             	mov    0x10(%ebp),%eax
801009d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009d5:	73 2f                	jae    80100a06 <consoleread+0xd8>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009d7:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009dc:	83 e8 01             	sub    $0x1,%eax
801009df:	a3 54 de 10 80       	mov    %eax,0x8010de54
      }
      break;
801009e4:	eb 20                	jmp    80100a06 <consoleread+0xd8>
    }
    *dst++ = c;
801009e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009e9:	89 c2                	mov    %eax,%edx
801009eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801009ee:	88 10                	mov    %dl,(%eax)
801009f0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    --n;
801009f4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009f8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009fc:	74 0b                	je     80100a09 <consoleread+0xdb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a02:	7f 96                	jg     8010099a <consoleread+0x6c>
80100a04:	eb 04                	jmp    80100a0a <consoleread+0xdc>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a06:	90                   	nop
80100a07:	eb 01                	jmp    80100a0a <consoleread+0xdc>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a09:	90                   	nop
  }
  release(&input.lock);
80100a0a:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100a11:	e8 6a 43 00 00       	call   80104d80 <release>
  ilock(ip);
80100a16:	8b 45 08             	mov    0x8(%ebp),%eax
80100a19:	89 04 24             	mov    %eax,(%esp)
80100a1c:	e8 a3 0e 00 00       	call   801018c4 <ilock>

  return target - n;
80100a21:	8b 45 10             	mov    0x10(%ebp),%eax
80100a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a27:	89 d1                	mov    %edx,%ecx
80100a29:	29 c1                	sub    %eax,%ecx
80100a2b:	89 c8                	mov    %ecx,%eax
}
80100a2d:	c9                   	leave  
80100a2e:	c3                   	ret    

80100a2f <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a2f:	55                   	push   %ebp
80100a30:	89 e5                	mov    %esp,%ebp
80100a32:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a35:	8b 45 08             	mov    0x8(%ebp),%eax
80100a38:	89 04 24             	mov    %eax,(%esp)
80100a3b:	e8 d2 0f 00 00       	call   80101a12 <iunlock>
  acquire(&cons.lock);
80100a40:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a47:	e8 d3 42 00 00       	call   80104d1f <acquire>
  for(i = 0; i < n; i++)
80100a4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a53:	eb 1f                	jmp    80100a74 <consolewrite+0x45>
    consputc(buf[i] & 0xff);
80100a55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a5b:	01 d0                	add    %edx,%eax
80100a5d:	0f b6 00             	movzbl (%eax),%eax
80100a60:	0f be c0             	movsbl %al,%eax
80100a63:	25 ff 00 00 00       	and    $0xff,%eax
80100a68:	89 04 24             	mov    %eax,(%esp)
80100a6b:	e8 e9 fc ff ff       	call   80100759 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a70:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a77:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a7a:	7c d9                	jl     80100a55 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a7c:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a83:	e8 f8 42 00 00       	call   80104d80 <release>
  ilock(ip);
80100a88:	8b 45 08             	mov    0x8(%ebp),%eax
80100a8b:	89 04 24             	mov    %eax,(%esp)
80100a8e:	e8 31 0e 00 00       	call   801018c4 <ilock>

  return n;
80100a93:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a96:	c9                   	leave  
80100a97:	c3                   	ret    

80100a98 <consoleinit>:

void
consoleinit(void)
{
80100a98:	55                   	push   %ebp
80100a99:	89 e5                	mov    %esp,%ebp
80100a9b:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a9e:	c7 44 24 04 1f 83 10 	movl   $0x8010831f,0x4(%esp)
80100aa5:	80 
80100aa6:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100aad:	e8 4c 42 00 00       	call   80104cfe <initlock>
  initlock(&input.lock, "input");
80100ab2:	c7 44 24 04 27 83 10 	movl   $0x80108327,0x4(%esp)
80100ab9:	80 
80100aba:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100ac1:	e8 38 42 00 00       	call   80104cfe <initlock>

  devsw[CONSOLE].write = consolewrite;
80100ac6:	c7 05 0c e8 10 80 2f 	movl   $0x80100a2f,0x8010e80c
80100acd:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ad0:	c7 05 08 e8 10 80 2e 	movl   $0x8010092e,0x8010e808
80100ad7:	09 10 80 
  cons.locking = 1;
80100ada:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100ae1:	00 00 00 

  picenable(IRQ_KBD);
80100ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aeb:	e8 11 30 00 00       	call   80103b01 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100af0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100af7:	00 
80100af8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aff:	e8 ee 1e 00 00       	call   801029f2 <ioapicenable>
}
80100b04:	c9                   	leave  
80100b05:	c3                   	ret    
80100b06:	66 90                	xchg   %ax,%ax

80100b08 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b08:	55                   	push   %ebp
80100b09:	89 e5                	mov    %esp,%ebp
80100b0b:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100b11:	8b 45 08             	mov    0x8(%ebp),%eax
80100b14:	89 04 24             	mov    %eax,(%esp)
80100b17:	e8 69 19 00 00       	call   80102485 <namei>
80100b1c:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b1f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b23:	75 0a                	jne    80100b2f <exec+0x27>
    return -1;
80100b25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b2a:	e9 27 04 00 00       	jmp    80100f56 <exec+0x44e>
  ilock(ip);
80100b2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b32:	89 04 24             	mov    %eax,(%esp)
80100b35:	e8 8a 0d 00 00       	call   801018c4 <ilock>
  pgdir = 0;
80100b3a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b41:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b48:	00 
80100b49:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b50:	00 
80100b51:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b57:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b5e:	89 04 24             	mov    %eax,(%esp)
80100b61:	e8 6b 12 00 00       	call   80101dd1 <readi>
80100b66:	83 f8 33             	cmp    $0x33,%eax
80100b69:	0f 86 a1 03 00 00    	jbe    80100f10 <exec+0x408>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b6f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b75:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b7a:	0f 85 93 03 00 00    	jne    80100f13 <exec+0x40b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b80:	e8 e4 6e 00 00       	call   80107a69 <setupkvm>
80100b85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b88:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b8c:	0f 84 84 03 00 00    	je     80100f16 <exec+0x40e>
    goto bad;

  // Load program into memory.
  sz = 0;
80100b92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b99:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100ba0:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100ba6:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ba9:	e9 c5 00 00 00       	jmp    80100c73 <exec+0x16b>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bb1:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bb8:	00 
80100bb9:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bbd:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bc7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bca:	89 04 24             	mov    %eax,(%esp)
80100bcd:	e8 ff 11 00 00       	call   80101dd1 <readi>
80100bd2:	83 f8 20             	cmp    $0x20,%eax
80100bd5:	0f 85 3e 03 00 00    	jne    80100f19 <exec+0x411>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bdb:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100be1:	83 f8 01             	cmp    $0x1,%eax
80100be4:	75 7f                	jne    80100c65 <exec+0x15d>
      continue;
    if(ph.memsz < ph.filesz)
80100be6:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100bec:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bf2:	39 c2                	cmp    %eax,%edx
80100bf4:	0f 82 22 03 00 00    	jb     80100f1c <exec+0x414>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bfa:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c00:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c06:	01 d0                	add    %edx,%eax
80100c08:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c16:	89 04 24             	mov    %eax,(%esp)
80100c19:	e8 1f 72 00 00       	call   80107e3d <allocuvm>
80100c1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c25:	0f 84 f4 02 00 00    	je     80100f1f <exec+0x417>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c2b:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c31:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c37:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c3d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c41:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c45:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c48:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c53:	89 04 24             	mov    %eax,(%esp)
80100c56:	e8 f2 70 00 00       	call   80107d4d <loaduvm>
80100c5b:	85 c0                	test   %eax,%eax
80100c5d:	0f 88 bf 02 00 00    	js     80100f22 <exec+0x41a>
80100c63:	eb 01                	jmp    80100c66 <exec+0x15e>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c65:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c66:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c6d:	83 c0 20             	add    $0x20,%eax
80100c70:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c73:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c7a:	0f b7 c0             	movzwl %ax,%eax
80100c7d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c80:	0f 8f 28 ff ff ff    	jg     80100bae <exec+0xa6>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c86:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c89:	89 04 24             	mov    %eax,(%esp)
80100c8c:	e8 b7 0e 00 00       	call   80101b48 <iunlockput>
  ip = 0;
80100c91:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c9b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ca0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ca5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cab:	05 00 20 00 00       	add    $0x2000,%eax
80100cb0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cbe:	89 04 24             	mov    %eax,(%esp)
80100cc1:	e8 77 71 00 00       	call   80107e3d <allocuvm>
80100cc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ccd:	0f 84 52 02 00 00    	je     80100f25 <exec+0x41d>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ce2:	89 04 24             	mov    %eax,(%esp)
80100ce5:	e8 77 73 00 00       	call   80108061 <clearpteu>
  sp = sz;
80100cea:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ced:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cf7:	e9 97 00 00 00       	jmp    80100d93 <exec+0x28b>
    if(argc >= MAXARG)
80100cfc:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d00:	0f 87 22 02 00 00    	ja     80100f28 <exec+0x420>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d10:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d13:	01 d0                	add    %edx,%eax
80100d15:	8b 00                	mov    (%eax),%eax
80100d17:	89 04 24             	mov    %eax,(%esp)
80100d1a:	e8 d0 44 00 00       	call   801051ef <strlen>
80100d1f:	f7 d0                	not    %eax
80100d21:	89 c2                	mov    %eax,%edx
80100d23:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d26:	01 d0                	add    %edx,%eax
80100d28:	83 e0 fc             	and    $0xfffffffc,%eax
80100d2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d31:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d38:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d3b:	01 d0                	add    %edx,%eax
80100d3d:	8b 00                	mov    (%eax),%eax
80100d3f:	89 04 24             	mov    %eax,(%esp)
80100d42:	e8 a8 44 00 00       	call   801051ef <strlen>
80100d47:	83 c0 01             	add    $0x1,%eax
80100d4a:	89 c2                	mov    %eax,%edx
80100d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d4f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d56:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d59:	01 c8                	add    %ecx,%eax
80100d5b:	8b 00                	mov    (%eax),%eax
80100d5d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d61:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d65:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d68:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d6f:	89 04 24             	mov    %eax,(%esp)
80100d72:	e8 af 74 00 00       	call   80108226 <copyout>
80100d77:	85 c0                	test   %eax,%eax
80100d79:	0f 88 ac 01 00 00    	js     80100f2b <exec+0x423>
      goto bad;
    ustack[3+argc] = sp;
80100d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d82:	8d 50 03             	lea    0x3(%eax),%edx
80100d85:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d88:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d8f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da0:	01 d0                	add    %edx,%eax
80100da2:	8b 00                	mov    (%eax),%eax
80100da4:	85 c0                	test   %eax,%eax
80100da6:	0f 85 50 ff ff ff    	jne    80100cfc <exec+0x1f4>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100daf:	83 c0 03             	add    $0x3,%eax
80100db2:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100db9:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dbd:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dc4:	ff ff ff 
  ustack[1] = argc;
80100dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dca:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd3:	83 c0 01             	add    $0x1,%eax
80100dd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ddd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de0:	29 d0                	sub    %edx,%eax
80100de2:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100deb:	83 c0 04             	add    $0x4,%eax
80100dee:	c1 e0 02             	shl    $0x2,%eax
80100df1:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df7:	83 c0 04             	add    $0x4,%eax
80100dfa:	c1 e0 02             	shl    $0x2,%eax
80100dfd:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e01:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e07:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e15:	89 04 24             	mov    %eax,(%esp)
80100e18:	e8 09 74 00 00       	call   80108226 <copyout>
80100e1d:	85 c0                	test   %eax,%eax
80100e1f:	0f 88 09 01 00 00    	js     80100f2e <exec+0x426>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e25:	8b 45 08             	mov    0x8(%ebp),%eax
80100e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e31:	eb 17                	jmp    80100e4a <exec+0x342>
    if(*s == '/')
80100e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e36:	0f b6 00             	movzbl (%eax),%eax
80100e39:	3c 2f                	cmp    $0x2f,%al
80100e3b:	75 09                	jne    80100e46 <exec+0x33e>
      last = s+1;
80100e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e40:	83 c0 01             	add    $0x1,%eax
80100e43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e46:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e4d:	0f b6 00             	movzbl (%eax),%eax
80100e50:	84 c0                	test   %al,%al
80100e52:	75 df                	jne    80100e33 <exec+0x32b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e54:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e5a:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e5d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e64:	00 
80100e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e68:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e6c:	89 14 24             	mov    %edx,(%esp)
80100e6f:	e8 2d 43 00 00       	call   801051a1 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7a:	8b 40 04             	mov    0x4(%eax),%eax
80100e7d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e86:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e89:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e92:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e95:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9d:	8b 40 18             	mov    0x18(%eax),%eax
80100ea0:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ea6:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ea9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eaf:	8b 40 18             	mov    0x18(%eax),%eax
80100eb2:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100eb5:	89 50 44             	mov    %edx,0x44(%eax)
  proc->next = 0;
80100eb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebe:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80100ec5:	00 00 00 
  proc->prev = 0;
80100ec8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ece:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  proc->state = RUNNABLE;
80100ed5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100edb:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  ready(proc);
80100ee2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee8:	89 04 24             	mov    %eax,(%esp)
80100eeb:	e8 7c 33 00 00       	call   8010426c <ready>
  switchuvm(proc);
80100ef0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef6:	89 04 24             	mov    %eax,(%esp)
80100ef9:	e8 5d 6c 00 00       	call   80107b5b <switchuvm>
  freevm(oldpgdir);
80100efe:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f01:	89 04 24             	mov    %eax,(%esp)
80100f04:	e8 ca 70 00 00       	call   80107fd3 <freevm>
  return 0;
80100f09:	b8 00 00 00 00       	mov    $0x0,%eax
80100f0e:	eb 46                	jmp    80100f56 <exec+0x44e>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100f10:	90                   	nop
80100f11:	eb 1c                	jmp    80100f2f <exec+0x427>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100f13:	90                   	nop
80100f14:	eb 19                	jmp    80100f2f <exec+0x427>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100f16:	90                   	nop
80100f17:	eb 16                	jmp    80100f2f <exec+0x427>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100f19:	90                   	nop
80100f1a:	eb 13                	jmp    80100f2f <exec+0x427>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100f1c:	90                   	nop
80100f1d:	eb 10                	jmp    80100f2f <exec+0x427>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100f1f:	90                   	nop
80100f20:	eb 0d                	jmp    80100f2f <exec+0x427>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100f22:	90                   	nop
80100f23:	eb 0a                	jmp    80100f2f <exec+0x427>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100f25:	90                   	nop
80100f26:	eb 07                	jmp    80100f2f <exec+0x427>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100f28:	90                   	nop
80100f29:	eb 04                	jmp    80100f2f <exec+0x427>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100f2b:	90                   	nop
80100f2c:	eb 01                	jmp    80100f2f <exec+0x427>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f2e:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f2f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f33:	74 0b                	je     80100f40 <exec+0x438>
    freevm(pgdir);
80100f35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f38:	89 04 24             	mov    %eax,(%esp)
80100f3b:	e8 93 70 00 00       	call   80107fd3 <freevm>
  if(ip)
80100f40:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f44:	74 0b                	je     80100f51 <exec+0x449>
    iunlockput(ip);
80100f46:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f49:	89 04 24             	mov    %eax,(%esp)
80100f4c:	e8 f7 0b 00 00       	call   80101b48 <iunlockput>
  return -1;
80100f51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f56:	c9                   	leave  
80100f57:	c3                   	ret    

80100f58 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f58:	55                   	push   %ebp
80100f59:	89 e5                	mov    %esp,%ebp
80100f5b:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f5e:	c7 44 24 04 2d 83 10 	movl   $0x8010832d,0x4(%esp)
80100f65:	80 
80100f66:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f6d:	e8 8c 3d 00 00       	call   80104cfe <initlock>
}
80100f72:	c9                   	leave  
80100f73:	c3                   	ret    

80100f74 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f74:	55                   	push   %ebp
80100f75:	89 e5                	mov    %esp,%ebp
80100f77:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f7a:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f81:	e8 99 3d 00 00       	call   80104d1f <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f86:	c7 45 f4 94 de 10 80 	movl   $0x8010de94,-0xc(%ebp)
80100f8d:	eb 29                	jmp    80100fb8 <filealloc+0x44>
    if(f->ref == 0){
80100f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f92:	8b 40 04             	mov    0x4(%eax),%eax
80100f95:	85 c0                	test   %eax,%eax
80100f97:	75 1b                	jne    80100fb4 <filealloc+0x40>
      f->ref = 1;
80100f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f9c:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fa3:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100faa:	e8 d1 3d 00 00       	call   80104d80 <release>
      return f;
80100faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fb2:	eb 1e                	jmp    80100fd2 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fb4:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fb8:	81 7d f4 f4 e7 10 80 	cmpl   $0x8010e7f4,-0xc(%ebp)
80100fbf:	72 ce                	jb     80100f8f <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fc1:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fc8:	e8 b3 3d 00 00       	call   80104d80 <release>
  return 0;
80100fcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fd2:	c9                   	leave  
80100fd3:	c3                   	ret    

80100fd4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fd4:	55                   	push   %ebp
80100fd5:	89 e5                	mov    %esp,%ebp
80100fd7:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100fda:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fe1:	e8 39 3d 00 00       	call   80104d1f <acquire>
  if(f->ref < 1)
80100fe6:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe9:	8b 40 04             	mov    0x4(%eax),%eax
80100fec:	85 c0                	test   %eax,%eax
80100fee:	7f 0c                	jg     80100ffc <filedup+0x28>
    panic("filedup");
80100ff0:	c7 04 24 34 83 10 80 	movl   $0x80108334,(%esp)
80100ff7:	e8 4a f5 ff ff       	call   80100546 <panic>
  f->ref++;
80100ffc:	8b 45 08             	mov    0x8(%ebp),%eax
80100fff:	8b 40 04             	mov    0x4(%eax),%eax
80101002:	8d 50 01             	lea    0x1(%eax),%edx
80101005:	8b 45 08             	mov    0x8(%ebp),%eax
80101008:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010100b:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101012:	e8 69 3d 00 00       	call   80104d80 <release>
  return f;
80101017:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010101a:	c9                   	leave  
8010101b:	c3                   	ret    

8010101c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010101c:	55                   	push   %ebp
8010101d:	89 e5                	mov    %esp,%ebp
8010101f:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80101022:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101029:	e8 f1 3c 00 00       	call   80104d1f <acquire>
  if(f->ref < 1)
8010102e:	8b 45 08             	mov    0x8(%ebp),%eax
80101031:	8b 40 04             	mov    0x4(%eax),%eax
80101034:	85 c0                	test   %eax,%eax
80101036:	7f 0c                	jg     80101044 <fileclose+0x28>
    panic("fileclose");
80101038:	c7 04 24 3c 83 10 80 	movl   $0x8010833c,(%esp)
8010103f:	e8 02 f5 ff ff       	call   80100546 <panic>
  if(--f->ref > 0){
80101044:	8b 45 08             	mov    0x8(%ebp),%eax
80101047:	8b 40 04             	mov    0x4(%eax),%eax
8010104a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010104d:	8b 45 08             	mov    0x8(%ebp),%eax
80101050:	89 50 04             	mov    %edx,0x4(%eax)
80101053:	8b 45 08             	mov    0x8(%ebp),%eax
80101056:	8b 40 04             	mov    0x4(%eax),%eax
80101059:	85 c0                	test   %eax,%eax
8010105b:	7e 11                	jle    8010106e <fileclose+0x52>
    release(&ftable.lock);
8010105d:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101064:	e8 17 3d 00 00       	call   80104d80 <release>
80101069:	e9 82 00 00 00       	jmp    801010f0 <fileclose+0xd4>
    return;
  }
  ff = *f;
8010106e:	8b 45 08             	mov    0x8(%ebp),%eax
80101071:	8b 10                	mov    (%eax),%edx
80101073:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101076:	8b 50 04             	mov    0x4(%eax),%edx
80101079:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010107c:	8b 50 08             	mov    0x8(%eax),%edx
8010107f:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101082:	8b 50 0c             	mov    0xc(%eax),%edx
80101085:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101088:	8b 50 10             	mov    0x10(%eax),%edx
8010108b:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010108e:	8b 40 14             	mov    0x14(%eax),%eax
80101091:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101094:	8b 45 08             	mov    0x8(%ebp),%eax
80101097:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010109e:	8b 45 08             	mov    0x8(%ebp),%eax
801010a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010a7:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
801010ae:	e8 cd 3c 00 00       	call   80104d80 <release>
  
  if(ff.type == FD_PIPE)
801010b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b6:	83 f8 01             	cmp    $0x1,%eax
801010b9:	75 18                	jne    801010d3 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
801010bb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010bf:	0f be d0             	movsbl %al,%edx
801010c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010c5:	89 54 24 04          	mov    %edx,0x4(%esp)
801010c9:	89 04 24             	mov    %eax,(%esp)
801010cc:	e8 ea 2c 00 00       	call   80103dbb <pipeclose>
801010d1:	eb 1d                	jmp    801010f0 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d6:	83 f8 02             	cmp    $0x2,%eax
801010d9:	75 15                	jne    801010f0 <fileclose+0xd4>
    begin_trans();
801010db:	e8 a2 21 00 00       	call   80103282 <begin_trans>
    iput(ff.ip);
801010e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010e3:	89 04 24             	mov    %eax,(%esp)
801010e6:	e8 8c 09 00 00       	call   80101a77 <iput>
    commit_trans();
801010eb:	e8 db 21 00 00       	call   801032cb <commit_trans>
  }
}
801010f0:	c9                   	leave  
801010f1:	c3                   	ret    

801010f2 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010f2:	55                   	push   %ebp
801010f3:	89 e5                	mov    %esp,%ebp
801010f5:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010f8:	8b 45 08             	mov    0x8(%ebp),%eax
801010fb:	8b 00                	mov    (%eax),%eax
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	75 38                	jne    8010113a <filestat+0x48>
    ilock(f->ip);
80101102:	8b 45 08             	mov    0x8(%ebp),%eax
80101105:	8b 40 10             	mov    0x10(%eax),%eax
80101108:	89 04 24             	mov    %eax,(%esp)
8010110b:	e8 b4 07 00 00       	call   801018c4 <ilock>
    stati(f->ip, st);
80101110:	8b 45 08             	mov    0x8(%ebp),%eax
80101113:	8b 40 10             	mov    0x10(%eax),%eax
80101116:	8b 55 0c             	mov    0xc(%ebp),%edx
80101119:	89 54 24 04          	mov    %edx,0x4(%esp)
8010111d:	89 04 24             	mov    %eax,(%esp)
80101120:	e8 67 0c 00 00       	call   80101d8c <stati>
    iunlock(f->ip);
80101125:	8b 45 08             	mov    0x8(%ebp),%eax
80101128:	8b 40 10             	mov    0x10(%eax),%eax
8010112b:	89 04 24             	mov    %eax,(%esp)
8010112e:	e8 df 08 00 00       	call   80101a12 <iunlock>
    return 0;
80101133:	b8 00 00 00 00       	mov    $0x0,%eax
80101138:	eb 05                	jmp    8010113f <filestat+0x4d>
  }
  return -1;
8010113a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010113f:	c9                   	leave  
80101140:	c3                   	ret    

80101141 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101141:	55                   	push   %ebp
80101142:	89 e5                	mov    %esp,%ebp
80101144:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101147:	8b 45 08             	mov    0x8(%ebp),%eax
8010114a:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010114e:	84 c0                	test   %al,%al
80101150:	75 0a                	jne    8010115c <fileread+0x1b>
    return -1;
80101152:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101157:	e9 9f 00 00 00       	jmp    801011fb <fileread+0xba>
  if(f->type == FD_PIPE)
8010115c:	8b 45 08             	mov    0x8(%ebp),%eax
8010115f:	8b 00                	mov    (%eax),%eax
80101161:	83 f8 01             	cmp    $0x1,%eax
80101164:	75 1e                	jne    80101184 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101166:	8b 45 08             	mov    0x8(%ebp),%eax
80101169:	8b 40 0c             	mov    0xc(%eax),%eax
8010116c:	8b 55 10             	mov    0x10(%ebp),%edx
8010116f:	89 54 24 08          	mov    %edx,0x8(%esp)
80101173:	8b 55 0c             	mov    0xc(%ebp),%edx
80101176:	89 54 24 04          	mov    %edx,0x4(%esp)
8010117a:	89 04 24             	mov    %eax,(%esp)
8010117d:	e8 bb 2d 00 00       	call   80103f3d <piperead>
80101182:	eb 77                	jmp    801011fb <fileread+0xba>
  if(f->type == FD_INODE){
80101184:	8b 45 08             	mov    0x8(%ebp),%eax
80101187:	8b 00                	mov    (%eax),%eax
80101189:	83 f8 02             	cmp    $0x2,%eax
8010118c:	75 61                	jne    801011ef <fileread+0xae>
    ilock(f->ip);
8010118e:	8b 45 08             	mov    0x8(%ebp),%eax
80101191:	8b 40 10             	mov    0x10(%eax),%eax
80101194:	89 04 24             	mov    %eax,(%esp)
80101197:	e8 28 07 00 00       	call   801018c4 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010119c:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010119f:	8b 45 08             	mov    0x8(%ebp),%eax
801011a2:	8b 50 14             	mov    0x14(%eax),%edx
801011a5:	8b 45 08             	mov    0x8(%ebp),%eax
801011a8:	8b 40 10             	mov    0x10(%eax),%eax
801011ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801011af:	89 54 24 08          	mov    %edx,0x8(%esp)
801011b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801011b6:	89 54 24 04          	mov    %edx,0x4(%esp)
801011ba:	89 04 24             	mov    %eax,(%esp)
801011bd:	e8 0f 0c 00 00       	call   80101dd1 <readi>
801011c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011c9:	7e 11                	jle    801011dc <fileread+0x9b>
      f->off += r;
801011cb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ce:	8b 50 14             	mov    0x14(%eax),%edx
801011d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011d4:	01 c2                	add    %eax,%edx
801011d6:	8b 45 08             	mov    0x8(%ebp),%eax
801011d9:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011dc:	8b 45 08             	mov    0x8(%ebp),%eax
801011df:	8b 40 10             	mov    0x10(%eax),%eax
801011e2:	89 04 24             	mov    %eax,(%esp)
801011e5:	e8 28 08 00 00       	call   80101a12 <iunlock>
    return r;
801011ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ed:	eb 0c                	jmp    801011fb <fileread+0xba>
  }
  panic("fileread");
801011ef:	c7 04 24 46 83 10 80 	movl   $0x80108346,(%esp)
801011f6:	e8 4b f3 ff ff       	call   80100546 <panic>
}
801011fb:	c9                   	leave  
801011fc:	c3                   	ret    

801011fd <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011fd:	55                   	push   %ebp
801011fe:	89 e5                	mov    %esp,%ebp
80101200:	53                   	push   %ebx
80101201:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
80101204:	8b 45 08             	mov    0x8(%ebp),%eax
80101207:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010120b:	84 c0                	test   %al,%al
8010120d:	75 0a                	jne    80101219 <filewrite+0x1c>
    return -1;
8010120f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101214:	e9 23 01 00 00       	jmp    8010133c <filewrite+0x13f>
  if(f->type == FD_PIPE)
80101219:	8b 45 08             	mov    0x8(%ebp),%eax
8010121c:	8b 00                	mov    (%eax),%eax
8010121e:	83 f8 01             	cmp    $0x1,%eax
80101221:	75 21                	jne    80101244 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
80101223:	8b 45 08             	mov    0x8(%ebp),%eax
80101226:	8b 40 0c             	mov    0xc(%eax),%eax
80101229:	8b 55 10             	mov    0x10(%ebp),%edx
8010122c:	89 54 24 08          	mov    %edx,0x8(%esp)
80101230:	8b 55 0c             	mov    0xc(%ebp),%edx
80101233:	89 54 24 04          	mov    %edx,0x4(%esp)
80101237:	89 04 24             	mov    %eax,(%esp)
8010123a:	e8 0e 2c 00 00       	call   80103e4d <pipewrite>
8010123f:	e9 f8 00 00 00       	jmp    8010133c <filewrite+0x13f>
  if(f->type == FD_INODE){
80101244:	8b 45 08             	mov    0x8(%ebp),%eax
80101247:	8b 00                	mov    (%eax),%eax
80101249:	83 f8 02             	cmp    $0x2,%eax
8010124c:	0f 85 de 00 00 00    	jne    80101330 <filewrite+0x133>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101252:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101259:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101260:	e9 a8 00 00 00       	jmp    8010130d <filewrite+0x110>
      int n1 = n - i;
80101265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101268:	8b 55 10             	mov    0x10(%ebp),%edx
8010126b:	89 d1                	mov    %edx,%ecx
8010126d:	29 c1                	sub    %eax,%ecx
8010126f:	89 c8                	mov    %ecx,%eax
80101271:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101274:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101277:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010127a:	7e 06                	jle    80101282 <filewrite+0x85>
        n1 = max;
8010127c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010127f:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
80101282:	e8 fb 1f 00 00       	call   80103282 <begin_trans>
      ilock(f->ip);
80101287:	8b 45 08             	mov    0x8(%ebp),%eax
8010128a:	8b 40 10             	mov    0x10(%eax),%eax
8010128d:	89 04 24             	mov    %eax,(%esp)
80101290:	e8 2f 06 00 00       	call   801018c4 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101295:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101298:	8b 45 08             	mov    0x8(%ebp),%eax
8010129b:	8b 50 14             	mov    0x14(%eax),%edx
8010129e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801012a4:	01 c3                	add    %eax,%ebx
801012a6:	8b 45 08             	mov    0x8(%ebp),%eax
801012a9:	8b 40 10             	mov    0x10(%eax),%eax
801012ac:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801012b0:	89 54 24 08          	mov    %edx,0x8(%esp)
801012b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801012b8:	89 04 24             	mov    %eax,(%esp)
801012bb:	e8 7f 0c 00 00       	call   80101f3f <writei>
801012c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012c7:	7e 11                	jle    801012da <filewrite+0xdd>
        f->off += r;
801012c9:	8b 45 08             	mov    0x8(%ebp),%eax
801012cc:	8b 50 14             	mov    0x14(%eax),%edx
801012cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012d2:	01 c2                	add    %eax,%edx
801012d4:	8b 45 08             	mov    0x8(%ebp),%eax
801012d7:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012da:	8b 45 08             	mov    0x8(%ebp),%eax
801012dd:	8b 40 10             	mov    0x10(%eax),%eax
801012e0:	89 04 24             	mov    %eax,(%esp)
801012e3:	e8 2a 07 00 00       	call   80101a12 <iunlock>
      commit_trans();
801012e8:	e8 de 1f 00 00       	call   801032cb <commit_trans>

      if(r < 0)
801012ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012f1:	78 28                	js     8010131b <filewrite+0x11e>
        break;
      if(r != n1)
801012f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012f9:	74 0c                	je     80101307 <filewrite+0x10a>
        panic("short filewrite");
801012fb:	c7 04 24 4f 83 10 80 	movl   $0x8010834f,(%esp)
80101302:	e8 3f f2 ff ff       	call   80100546 <panic>
      i += r;
80101307:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010130a:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101310:	3b 45 10             	cmp    0x10(%ebp),%eax
80101313:	0f 8c 4c ff ff ff    	jl     80101265 <filewrite+0x68>
80101319:	eb 01                	jmp    8010131c <filewrite+0x11f>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
8010131b:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010131c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010131f:	3b 45 10             	cmp    0x10(%ebp),%eax
80101322:	75 05                	jne    80101329 <filewrite+0x12c>
80101324:	8b 45 10             	mov    0x10(%ebp),%eax
80101327:	eb 05                	jmp    8010132e <filewrite+0x131>
80101329:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010132e:	eb 0c                	jmp    8010133c <filewrite+0x13f>
  }
  panic("filewrite");
80101330:	c7 04 24 5f 83 10 80 	movl   $0x8010835f,(%esp)
80101337:	e8 0a f2 ff ff       	call   80100546 <panic>
}
8010133c:	83 c4 24             	add    $0x24,%esp
8010133f:	5b                   	pop    %ebx
80101340:	5d                   	pop    %ebp
80101341:	c3                   	ret    
80101342:	66 90                	xchg   %ax,%ax

80101344 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101344:	55                   	push   %ebp
80101345:	89 e5                	mov    %esp,%ebp
80101347:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010134a:	8b 45 08             	mov    0x8(%ebp),%eax
8010134d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101354:	00 
80101355:	89 04 24             	mov    %eax,(%esp)
80101358:	e8 49 ee ff ff       	call   801001a6 <bread>
8010135d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101360:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101363:	83 c0 18             	add    $0x18,%eax
80101366:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010136d:	00 
8010136e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101372:	8b 45 0c             	mov    0xc(%ebp),%eax
80101375:	89 04 24             	mov    %eax,(%esp)
80101378:	e8 c4 3c 00 00       	call   80105041 <memmove>
  brelse(bp);
8010137d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101380:	89 04 24             	mov    %eax,(%esp)
80101383:	e8 8f ee ff ff       	call   80100217 <brelse>
}
80101388:	c9                   	leave  
80101389:	c3                   	ret    

8010138a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010138a:	55                   	push   %ebp
8010138b:	89 e5                	mov    %esp,%ebp
8010138d:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101390:	8b 55 0c             	mov    0xc(%ebp),%edx
80101393:	8b 45 08             	mov    0x8(%ebp),%eax
80101396:	89 54 24 04          	mov    %edx,0x4(%esp)
8010139a:	89 04 24             	mov    %eax,(%esp)
8010139d:	e8 04 ee ff ff       	call   801001a6 <bread>
801013a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a8:	83 c0 18             	add    $0x18,%eax
801013ab:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801013b2:	00 
801013b3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801013ba:	00 
801013bb:	89 04 24             	mov    %eax,(%esp)
801013be:	e8 ab 3b 00 00       	call   80104f6e <memset>
  log_write(bp);
801013c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c6:	89 04 24             	mov    %eax,(%esp)
801013c9:	e8 55 1f 00 00       	call   80103323 <log_write>
  brelse(bp);
801013ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d1:	89 04 24             	mov    %eax,(%esp)
801013d4:	e8 3e ee ff ff       	call   80100217 <brelse>
}
801013d9:	c9                   	leave  
801013da:	c3                   	ret    

801013db <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013db:	55                   	push   %ebp
801013dc:	89 e5                	mov    %esp,%ebp
801013de:	53                   	push   %ebx
801013df:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013e9:	8b 45 08             	mov    0x8(%ebp),%eax
801013ec:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013ef:	89 54 24 04          	mov    %edx,0x4(%esp)
801013f3:	89 04 24             	mov    %eax,(%esp)
801013f6:	e8 49 ff ff ff       	call   80101344 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101402:	e9 0d 01 00 00       	jmp    80101514 <balloc+0x139>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
80101407:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010140a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101410:	85 c0                	test   %eax,%eax
80101412:	0f 48 c2             	cmovs  %edx,%eax
80101415:	c1 f8 0c             	sar    $0xc,%eax
80101418:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010141b:	c1 ea 03             	shr    $0x3,%edx
8010141e:	01 d0                	add    %edx,%eax
80101420:	83 c0 03             	add    $0x3,%eax
80101423:	89 44 24 04          	mov    %eax,0x4(%esp)
80101427:	8b 45 08             	mov    0x8(%ebp),%eax
8010142a:	89 04 24             	mov    %eax,(%esp)
8010142d:	e8 74 ed ff ff       	call   801001a6 <bread>
80101432:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101435:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010143c:	e9 a3 00 00 00       	jmp    801014e4 <balloc+0x109>
      m = 1 << (bi % 8);
80101441:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101444:	89 c2                	mov    %eax,%edx
80101446:	c1 fa 1f             	sar    $0x1f,%edx
80101449:	c1 ea 1d             	shr    $0x1d,%edx
8010144c:	01 d0                	add    %edx,%eax
8010144e:	83 e0 07             	and    $0x7,%eax
80101451:	29 d0                	sub    %edx,%eax
80101453:	ba 01 00 00 00       	mov    $0x1,%edx
80101458:	89 d3                	mov    %edx,%ebx
8010145a:	89 c1                	mov    %eax,%ecx
8010145c:	d3 e3                	shl    %cl,%ebx
8010145e:	89 d8                	mov    %ebx,%eax
80101460:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101463:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101466:	8d 50 07             	lea    0x7(%eax),%edx
80101469:	85 c0                	test   %eax,%eax
8010146b:	0f 48 c2             	cmovs  %edx,%eax
8010146e:	c1 f8 03             	sar    $0x3,%eax
80101471:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101474:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101479:	0f b6 c0             	movzbl %al,%eax
8010147c:	23 45 e8             	and    -0x18(%ebp),%eax
8010147f:	85 c0                	test   %eax,%eax
80101481:	75 5d                	jne    801014e0 <balloc+0x105>
        bp->data[bi/8] |= m;  // Mark block in use.
80101483:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101486:	8d 50 07             	lea    0x7(%eax),%edx
80101489:	85 c0                	test   %eax,%eax
8010148b:	0f 48 c2             	cmovs  %edx,%eax
8010148e:	c1 f8 03             	sar    $0x3,%eax
80101491:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101494:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101499:	89 d1                	mov    %edx,%ecx
8010149b:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010149e:	09 ca                	or     %ecx,%edx
801014a0:	89 d1                	mov    %edx,%ecx
801014a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014a5:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014ac:	89 04 24             	mov    %eax,(%esp)
801014af:	e8 6f 1e 00 00       	call   80103323 <log_write>
        brelse(bp);
801014b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014b7:	89 04 24             	mov    %eax,(%esp)
801014ba:	e8 58 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
801014bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014c5:	01 c2                	add    %eax,%edx
801014c7:	8b 45 08             	mov    0x8(%ebp),%eax
801014ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801014ce:	89 04 24             	mov    %eax,(%esp)
801014d1:	e8 b4 fe ff ff       	call   8010138a <bzero>
        return b + bi;
801014d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014dc:	01 d0                	add    %edx,%eax
801014de:	eb 4e                	jmp    8010152e <balloc+0x153>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014e0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014e4:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014eb:	7f 15                	jg     80101502 <balloc+0x127>
801014ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014f3:	01 d0                	add    %edx,%eax
801014f5:	89 c2                	mov    %eax,%edx
801014f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014fa:	39 c2                	cmp    %eax,%edx
801014fc:	0f 82 3f ff ff ff    	jb     80101441 <balloc+0x66>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101502:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101505:	89 04 24             	mov    %eax,(%esp)
80101508:	e8 0a ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
8010150d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101514:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101517:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010151a:	39 c2                	cmp    %eax,%edx
8010151c:	0f 82 e5 fe ff ff    	jb     80101407 <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101522:	c7 04 24 69 83 10 80 	movl   $0x80108369,(%esp)
80101529:	e8 18 f0 ff ff       	call   80100546 <panic>
}
8010152e:	83 c4 34             	add    $0x34,%esp
80101531:	5b                   	pop    %ebx
80101532:	5d                   	pop    %ebp
80101533:	c3                   	ret    

80101534 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101534:	55                   	push   %ebp
80101535:	89 e5                	mov    %esp,%ebp
80101537:	53                   	push   %ebx
80101538:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
8010153b:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010153e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101542:	8b 45 08             	mov    0x8(%ebp),%eax
80101545:	89 04 24             	mov    %eax,(%esp)
80101548:	e8 f7 fd ff ff       	call   80101344 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
8010154d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101550:	89 c2                	mov    %eax,%edx
80101552:	c1 ea 0c             	shr    $0xc,%edx
80101555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101558:	c1 e8 03             	shr    $0x3,%eax
8010155b:	01 d0                	add    %edx,%eax
8010155d:	8d 50 03             	lea    0x3(%eax),%edx
80101560:	8b 45 08             	mov    0x8(%ebp),%eax
80101563:	89 54 24 04          	mov    %edx,0x4(%esp)
80101567:	89 04 24             	mov    %eax,(%esp)
8010156a:	e8 37 ec ff ff       	call   801001a6 <bread>
8010156f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101572:	8b 45 0c             	mov    0xc(%ebp),%eax
80101575:	25 ff 0f 00 00       	and    $0xfff,%eax
8010157a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010157d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101580:	89 c2                	mov    %eax,%edx
80101582:	c1 fa 1f             	sar    $0x1f,%edx
80101585:	c1 ea 1d             	shr    $0x1d,%edx
80101588:	01 d0                	add    %edx,%eax
8010158a:	83 e0 07             	and    $0x7,%eax
8010158d:	29 d0                	sub    %edx,%eax
8010158f:	ba 01 00 00 00       	mov    $0x1,%edx
80101594:	89 d3                	mov    %edx,%ebx
80101596:	89 c1                	mov    %eax,%ecx
80101598:	d3 e3                	shl    %cl,%ebx
8010159a:	89 d8                	mov    %ebx,%eax
8010159c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010159f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a2:	8d 50 07             	lea    0x7(%eax),%edx
801015a5:	85 c0                	test   %eax,%eax
801015a7:	0f 48 c2             	cmovs  %edx,%eax
801015aa:	c1 f8 03             	sar    $0x3,%eax
801015ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015b0:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
801015b5:	0f b6 c0             	movzbl %al,%eax
801015b8:	23 45 ec             	and    -0x14(%ebp),%eax
801015bb:	85 c0                	test   %eax,%eax
801015bd:	75 0c                	jne    801015cb <bfree+0x97>
    panic("freeing free block");
801015bf:	c7 04 24 7f 83 10 80 	movl   $0x8010837f,(%esp)
801015c6:	e8 7b ef ff ff       	call   80100546 <panic>
  bp->data[bi/8] &= ~m;
801015cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ce:	8d 50 07             	lea    0x7(%eax),%edx
801015d1:	85 c0                	test   %eax,%eax
801015d3:	0f 48 c2             	cmovs  %edx,%eax
801015d6:	c1 f8 03             	sar    $0x3,%eax
801015d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015dc:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015e1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015e4:	f7 d1                	not    %ecx
801015e6:	21 ca                	and    %ecx,%edx
801015e8:	89 d1                	mov    %edx,%ecx
801015ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ed:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015f4:	89 04 24             	mov    %eax,(%esp)
801015f7:	e8 27 1d 00 00       	call   80103323 <log_write>
  brelse(bp);
801015fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ff:	89 04 24             	mov    %eax,(%esp)
80101602:	e8 10 ec ff ff       	call   80100217 <brelse>
}
80101607:	83 c4 34             	add    $0x34,%esp
8010160a:	5b                   	pop    %ebx
8010160b:	5d                   	pop    %ebp
8010160c:	c3                   	ret    

8010160d <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
8010160d:	55                   	push   %ebp
8010160e:	89 e5                	mov    %esp,%ebp
80101610:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
80101613:	c7 44 24 04 92 83 10 	movl   $0x80108392,0x4(%esp)
8010161a:	80 
8010161b:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101622:	e8 d7 36 00 00       	call   80104cfe <initlock>
}
80101627:	c9                   	leave  
80101628:	c3                   	ret    

80101629 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101629:	55                   	push   %ebp
8010162a:	89 e5                	mov    %esp,%ebp
8010162c:	83 ec 48             	sub    $0x48,%esp
8010162f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101632:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101636:	8b 45 08             	mov    0x8(%ebp),%eax
80101639:	8d 55 dc             	lea    -0x24(%ebp),%edx
8010163c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101640:	89 04 24             	mov    %eax,(%esp)
80101643:	e8 fc fc ff ff       	call   80101344 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
80101648:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010164f:	e9 98 00 00 00       	jmp    801016ec <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
80101654:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101657:	c1 e8 03             	shr    $0x3,%eax
8010165a:	83 c0 02             	add    $0x2,%eax
8010165d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101661:	8b 45 08             	mov    0x8(%ebp),%eax
80101664:	89 04 24             	mov    %eax,(%esp)
80101667:	e8 3a eb ff ff       	call   801001a6 <bread>
8010166c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010166f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101672:	8d 50 18             	lea    0x18(%eax),%edx
80101675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101678:	83 e0 07             	and    $0x7,%eax
8010167b:	c1 e0 06             	shl    $0x6,%eax
8010167e:	01 d0                	add    %edx,%eax
80101680:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101683:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101686:	0f b7 00             	movzwl (%eax),%eax
80101689:	66 85 c0             	test   %ax,%ax
8010168c:	75 4f                	jne    801016dd <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
8010168e:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101695:	00 
80101696:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010169d:	00 
8010169e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016a1:	89 04 24             	mov    %eax,(%esp)
801016a4:	e8 c5 38 00 00       	call   80104f6e <memset>
      dip->type = type;
801016a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016ac:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
801016b0:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016b6:	89 04 24             	mov    %eax,(%esp)
801016b9:	e8 65 1c 00 00       	call   80103323 <log_write>
      brelse(bp);
801016be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016c1:	89 04 24             	mov    %eax,(%esp)
801016c4:	e8 4e eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
801016c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801016d0:	8b 45 08             	mov    0x8(%ebp),%eax
801016d3:	89 04 24             	mov    %eax,(%esp)
801016d6:	e8 e5 00 00 00       	call   801017c0 <iget>
801016db:	eb 29                	jmp    80101706 <ialloc+0xdd>
    }
    brelse(bp);
801016dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016e0:	89 04 24             	mov    %eax,(%esp)
801016e3:	e8 2f eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016f2:	39 c2                	cmp    %eax,%edx
801016f4:	0f 82 5a ff ff ff    	jb     80101654 <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016fa:	c7 04 24 99 83 10 80 	movl   $0x80108399,(%esp)
80101701:	e8 40 ee ff ff       	call   80100546 <panic>
}
80101706:	c9                   	leave  
80101707:	c3                   	ret    

80101708 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101708:	55                   	push   %ebp
80101709:	89 e5                	mov    %esp,%ebp
8010170b:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
8010170e:	8b 45 08             	mov    0x8(%ebp),%eax
80101711:	8b 40 04             	mov    0x4(%eax),%eax
80101714:	c1 e8 03             	shr    $0x3,%eax
80101717:	8d 50 02             	lea    0x2(%eax),%edx
8010171a:	8b 45 08             	mov    0x8(%ebp),%eax
8010171d:	8b 00                	mov    (%eax),%eax
8010171f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101723:	89 04 24             	mov    %eax,(%esp)
80101726:	e8 7b ea ff ff       	call   801001a6 <bread>
8010172b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010172e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101731:	8d 50 18             	lea    0x18(%eax),%edx
80101734:	8b 45 08             	mov    0x8(%ebp),%eax
80101737:	8b 40 04             	mov    0x4(%eax),%eax
8010173a:	83 e0 07             	and    $0x7,%eax
8010173d:	c1 e0 06             	shl    $0x6,%eax
80101740:	01 d0                	add    %edx,%eax
80101742:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101745:	8b 45 08             	mov    0x8(%ebp),%eax
80101748:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010174c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010174f:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101752:	8b 45 08             	mov    0x8(%ebp),%eax
80101755:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101759:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010175c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101760:	8b 45 08             	mov    0x8(%ebp),%eax
80101763:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101767:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176a:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010176e:	8b 45 08             	mov    0x8(%ebp),%eax
80101771:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101775:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101778:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010177c:	8b 45 08             	mov    0x8(%ebp),%eax
8010177f:	8b 50 18             	mov    0x18(%eax),%edx
80101782:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101785:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101788:	8b 45 08             	mov    0x8(%ebp),%eax
8010178b:	8d 50 1c             	lea    0x1c(%eax),%edx
8010178e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101791:	83 c0 0c             	add    $0xc,%eax
80101794:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010179b:	00 
8010179c:	89 54 24 04          	mov    %edx,0x4(%esp)
801017a0:	89 04 24             	mov    %eax,(%esp)
801017a3:	e8 99 38 00 00       	call   80105041 <memmove>
  log_write(bp);
801017a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ab:	89 04 24             	mov    %eax,(%esp)
801017ae:	e8 70 1b 00 00       	call   80103323 <log_write>
  brelse(bp);
801017b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b6:	89 04 24             	mov    %eax,(%esp)
801017b9:	e8 59 ea ff ff       	call   80100217 <brelse>
}
801017be:	c9                   	leave  
801017bf:	c3                   	ret    

801017c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017c6:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801017cd:	e8 4d 35 00 00       	call   80104d1f <acquire>

  // Is the inode already cached?
  empty = 0;
801017d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017d9:	c7 45 f4 94 e8 10 80 	movl   $0x8010e894,-0xc(%ebp)
801017e0:	eb 59                	jmp    8010183b <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e5:	8b 40 08             	mov    0x8(%eax),%eax
801017e8:	85 c0                	test   %eax,%eax
801017ea:	7e 35                	jle    80101821 <iget+0x61>
801017ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ef:	8b 00                	mov    (%eax),%eax
801017f1:	3b 45 08             	cmp    0x8(%ebp),%eax
801017f4:	75 2b                	jne    80101821 <iget+0x61>
801017f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f9:	8b 40 04             	mov    0x4(%eax),%eax
801017fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017ff:	75 20                	jne    80101821 <iget+0x61>
      ip->ref++;
80101801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101804:	8b 40 08             	mov    0x8(%eax),%eax
80101807:	8d 50 01             	lea    0x1(%eax),%edx
8010180a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010180d:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101810:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101817:	e8 64 35 00 00       	call   80104d80 <release>
      return ip;
8010181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181f:	eb 6f                	jmp    80101890 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101821:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101825:	75 10                	jne    80101837 <iget+0x77>
80101827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182a:	8b 40 08             	mov    0x8(%eax),%eax
8010182d:	85 c0                	test   %eax,%eax
8010182f:	75 06                	jne    80101837 <iget+0x77>
      empty = ip;
80101831:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101834:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101837:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
8010183b:	81 7d f4 34 f8 10 80 	cmpl   $0x8010f834,-0xc(%ebp)
80101842:	72 9e                	jb     801017e2 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101844:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101848:	75 0c                	jne    80101856 <iget+0x96>
    panic("iget: no inodes");
8010184a:	c7 04 24 ab 83 10 80 	movl   $0x801083ab,(%esp)
80101851:	e8 f0 ec ff ff       	call   80100546 <panic>

  ip = empty;
80101856:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101859:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010185c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185f:	8b 55 08             	mov    0x8(%ebp),%edx
80101862:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101864:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101867:	8b 55 0c             	mov    0xc(%ebp),%edx
8010186a:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101870:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101881:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101888:	e8 f3 34 00 00       	call   80104d80 <release>

  return ip;
8010188d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101890:	c9                   	leave  
80101891:	c3                   	ret    

80101892 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101892:	55                   	push   %ebp
80101893:	89 e5                	mov    %esp,%ebp
80101895:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101898:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010189f:	e8 7b 34 00 00       	call   80104d1f <acquire>
  ip->ref++;
801018a4:	8b 45 08             	mov    0x8(%ebp),%eax
801018a7:	8b 40 08             	mov    0x8(%eax),%eax
801018aa:	8d 50 01             	lea    0x1(%eax),%edx
801018ad:	8b 45 08             	mov    0x8(%ebp),%eax
801018b0:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018b3:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801018ba:	e8 c1 34 00 00       	call   80104d80 <release>
  return ip;
801018bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018c2:	c9                   	leave  
801018c3:	c3                   	ret    

801018c4 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018c4:	55                   	push   %ebp
801018c5:	89 e5                	mov    %esp,%ebp
801018c7:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018ce:	74 0a                	je     801018da <ilock+0x16>
801018d0:	8b 45 08             	mov    0x8(%ebp),%eax
801018d3:	8b 40 08             	mov    0x8(%eax),%eax
801018d6:	85 c0                	test   %eax,%eax
801018d8:	7f 0c                	jg     801018e6 <ilock+0x22>
    panic("ilock");
801018da:	c7 04 24 bb 83 10 80 	movl   $0x801083bb,(%esp)
801018e1:	e8 60 ec ff ff       	call   80100546 <panic>

  acquire(&icache.lock);
801018e6:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801018ed:	e8 2d 34 00 00       	call   80104d1f <acquire>
  while(ip->flags & I_BUSY)
801018f2:	eb 13                	jmp    80101907 <ilock+0x43>
    sleep(ip, &icache.lock);
801018f4:	c7 44 24 04 60 e8 10 	movl   $0x8010e860,0x4(%esp)
801018fb:	80 
801018fc:	8b 45 08             	mov    0x8(%ebp),%eax
801018ff:	89 04 24             	mov    %eax,(%esp)
80101902:	e8 29 31 00 00       	call   80104a30 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101907:	8b 45 08             	mov    0x8(%ebp),%eax
8010190a:	8b 40 0c             	mov    0xc(%eax),%eax
8010190d:	83 e0 01             	and    $0x1,%eax
80101910:	85 c0                	test   %eax,%eax
80101912:	75 e0                	jne    801018f4 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101914:	8b 45 08             	mov    0x8(%ebp),%eax
80101917:	8b 40 0c             	mov    0xc(%eax),%eax
8010191a:	89 c2                	mov    %eax,%edx
8010191c:	83 ca 01             	or     $0x1,%edx
8010191f:	8b 45 08             	mov    0x8(%ebp),%eax
80101922:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101925:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010192c:	e8 4f 34 00 00       	call   80104d80 <release>

  if(!(ip->flags & I_VALID)){
80101931:	8b 45 08             	mov    0x8(%ebp),%eax
80101934:	8b 40 0c             	mov    0xc(%eax),%eax
80101937:	83 e0 02             	and    $0x2,%eax
8010193a:	85 c0                	test   %eax,%eax
8010193c:	0f 85 ce 00 00 00    	jne    80101a10 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101942:	8b 45 08             	mov    0x8(%ebp),%eax
80101945:	8b 40 04             	mov    0x4(%eax),%eax
80101948:	c1 e8 03             	shr    $0x3,%eax
8010194b:	8d 50 02             	lea    0x2(%eax),%edx
8010194e:	8b 45 08             	mov    0x8(%ebp),%eax
80101951:	8b 00                	mov    (%eax),%eax
80101953:	89 54 24 04          	mov    %edx,0x4(%esp)
80101957:	89 04 24             	mov    %eax,(%esp)
8010195a:	e8 47 e8 ff ff       	call   801001a6 <bread>
8010195f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101962:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101965:	8d 50 18             	lea    0x18(%eax),%edx
80101968:	8b 45 08             	mov    0x8(%ebp),%eax
8010196b:	8b 40 04             	mov    0x4(%eax),%eax
8010196e:	83 e0 07             	and    $0x7,%eax
80101971:	c1 e0 06             	shl    $0x6,%eax
80101974:	01 d0                	add    %edx,%eax
80101976:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101979:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010197c:	0f b7 10             	movzwl (%eax),%edx
8010197f:	8b 45 08             	mov    0x8(%ebp),%eax
80101982:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101986:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101989:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010198d:	8b 45 08             	mov    0x8(%ebp),%eax
80101990:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101994:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101997:	0f b7 50 04          	movzwl 0x4(%eax),%edx
8010199b:	8b 45 08             	mov    0x8(%ebp),%eax
8010199e:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
801019a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a5:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019a9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ac:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
801019b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019b3:	8b 50 08             	mov    0x8(%eax),%edx
801019b6:	8b 45 08             	mov    0x8(%ebp),%eax
801019b9:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019bf:	8d 50 0c             	lea    0xc(%eax),%edx
801019c2:	8b 45 08             	mov    0x8(%ebp),%eax
801019c5:	83 c0 1c             	add    $0x1c,%eax
801019c8:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801019cf:	00 
801019d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801019d4:	89 04 24             	mov    %eax,(%esp)
801019d7:	e8 65 36 00 00       	call   80105041 <memmove>
    brelse(bp);
801019dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019df:	89 04 24             	mov    %eax,(%esp)
801019e2:	e8 30 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
801019e7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ea:	8b 40 0c             	mov    0xc(%eax),%eax
801019ed:	89 c2                	mov    %eax,%edx
801019ef:	83 ca 02             	or     $0x2,%edx
801019f2:	8b 45 08             	mov    0x8(%ebp),%eax
801019f5:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019f8:	8b 45 08             	mov    0x8(%ebp),%eax
801019fb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019ff:	66 85 c0             	test   %ax,%ax
80101a02:	75 0c                	jne    80101a10 <ilock+0x14c>
      panic("ilock: no type");
80101a04:	c7 04 24 c1 83 10 80 	movl   $0x801083c1,(%esp)
80101a0b:	e8 36 eb ff ff       	call   80100546 <panic>
  }
}
80101a10:	c9                   	leave  
80101a11:	c3                   	ret    

80101a12 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a12:	55                   	push   %ebp
80101a13:	89 e5                	mov    %esp,%ebp
80101a15:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a1c:	74 17                	je     80101a35 <iunlock+0x23>
80101a1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a21:	8b 40 0c             	mov    0xc(%eax),%eax
80101a24:	83 e0 01             	and    $0x1,%eax
80101a27:	85 c0                	test   %eax,%eax
80101a29:	74 0a                	je     80101a35 <iunlock+0x23>
80101a2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2e:	8b 40 08             	mov    0x8(%eax),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	7f 0c                	jg     80101a41 <iunlock+0x2f>
    panic("iunlock");
80101a35:	c7 04 24 d0 83 10 80 	movl   $0x801083d0,(%esp)
80101a3c:	e8 05 eb ff ff       	call   80100546 <panic>

  acquire(&icache.lock);
80101a41:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a48:	e8 d2 32 00 00       	call   80104d1f <acquire>
  ip->flags &= ~I_BUSY;
80101a4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a50:	8b 40 0c             	mov    0xc(%eax),%eax
80101a53:	89 c2                	mov    %eax,%edx
80101a55:	83 e2 fe             	and    $0xfffffffe,%edx
80101a58:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5b:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a61:	89 04 24             	mov    %eax,(%esp)
80101a64:	e8 af 30 00 00       	call   80104b18 <wakeup>
  release(&icache.lock);
80101a69:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a70:	e8 0b 33 00 00       	call   80104d80 <release>
}
80101a75:	c9                   	leave  
80101a76:	c3                   	ret    

80101a77 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a77:	55                   	push   %ebp
80101a78:	89 e5                	mov    %esp,%ebp
80101a7a:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a7d:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a84:	e8 96 32 00 00       	call   80104d1f <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a89:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8c:	8b 40 08             	mov    0x8(%eax),%eax
80101a8f:	83 f8 01             	cmp    $0x1,%eax
80101a92:	0f 85 93 00 00 00    	jne    80101b2b <iput+0xb4>
80101a98:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9b:	8b 40 0c             	mov    0xc(%eax),%eax
80101a9e:	83 e0 02             	and    $0x2,%eax
80101aa1:	85 c0                	test   %eax,%eax
80101aa3:	0f 84 82 00 00 00    	je     80101b2b <iput+0xb4>
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101ab0:	66 85 c0             	test   %ax,%ax
80101ab3:	75 76                	jne    80101b2b <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab8:	8b 40 0c             	mov    0xc(%eax),%eax
80101abb:	83 e0 01             	and    $0x1,%eax
80101abe:	85 c0                	test   %eax,%eax
80101ac0:	74 0c                	je     80101ace <iput+0x57>
      panic("iput busy");
80101ac2:	c7 04 24 d8 83 10 80 	movl   $0x801083d8,(%esp)
80101ac9:	e8 78 ea ff ff       	call   80100546 <panic>
    ip->flags |= I_BUSY;
80101ace:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad1:	8b 40 0c             	mov    0xc(%eax),%eax
80101ad4:	89 c2                	mov    %eax,%edx
80101ad6:	83 ca 01             	or     $0x1,%edx
80101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80101adc:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101adf:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101ae6:	e8 95 32 00 00       	call   80104d80 <release>
    itrunc(ip);
80101aeb:	8b 45 08             	mov    0x8(%ebp),%eax
80101aee:	89 04 24             	mov    %eax,(%esp)
80101af1:	e8 7d 01 00 00       	call   80101c73 <itrunc>
    ip->type = 0;
80101af6:	8b 45 08             	mov    0x8(%ebp),%eax
80101af9:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101aff:	8b 45 08             	mov    0x8(%ebp),%eax
80101b02:	89 04 24             	mov    %eax,(%esp)
80101b05:	e8 fe fb ff ff       	call   80101708 <iupdate>
    acquire(&icache.lock);
80101b0a:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101b11:	e8 09 32 00 00       	call   80104d1f <acquire>
    ip->flags = 0;
80101b16:	8b 45 08             	mov    0x8(%ebp),%eax
80101b19:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b20:	8b 45 08             	mov    0x8(%ebp),%eax
80101b23:	89 04 24             	mov    %eax,(%esp)
80101b26:	e8 ed 2f 00 00       	call   80104b18 <wakeup>
  }
  ip->ref--;
80101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2e:	8b 40 08             	mov    0x8(%eax),%eax
80101b31:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b34:	8b 45 08             	mov    0x8(%ebp),%eax
80101b37:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b3a:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101b41:	e8 3a 32 00 00       	call   80104d80 <release>
}
80101b46:	c9                   	leave  
80101b47:	c3                   	ret    

80101b48 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b48:	55                   	push   %ebp
80101b49:	89 e5                	mov    %esp,%ebp
80101b4b:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b51:	89 04 24             	mov    %eax,(%esp)
80101b54:	e8 b9 fe ff ff       	call   80101a12 <iunlock>
  iput(ip);
80101b59:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5c:	89 04 24             	mov    %eax,(%esp)
80101b5f:	e8 13 ff ff ff       	call   80101a77 <iput>
}
80101b64:	c9                   	leave  
80101b65:	c3                   	ret    

80101b66 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b66:	55                   	push   %ebp
80101b67:	89 e5                	mov    %esp,%ebp
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b6d:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b71:	77 3e                	ja     80101bb1 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b73:	8b 45 08             	mov    0x8(%ebp),%eax
80101b76:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b79:	83 c2 04             	add    $0x4,%edx
80101b7c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b87:	75 20                	jne    80101ba9 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b89:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8c:	8b 00                	mov    (%eax),%eax
80101b8e:	89 04 24             	mov    %eax,(%esp)
80101b91:	e8 45 f8 ff ff       	call   801013db <balloc>
80101b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b9f:	8d 4a 04             	lea    0x4(%edx),%ecx
80101ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ba5:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bac:	e9 bc 00 00 00       	jmp    80101c6d <bmap+0x107>
  }
  bn -= NDIRECT;
80101bb1:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bb5:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bb9:	0f 87 a2 00 00 00    	ja     80101c61 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101bbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc2:	8b 40 4c             	mov    0x4c(%eax),%eax
80101bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bcc:	75 19                	jne    80101be7 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101bce:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd1:	8b 00                	mov    (%eax),%eax
80101bd3:	89 04 24             	mov    %eax,(%esp)
80101bd6:	e8 00 f8 ff ff       	call   801013db <balloc>
80101bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bde:	8b 45 08             	mov    0x8(%ebp),%eax
80101be1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101be4:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101be7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bea:	8b 00                	mov    (%eax),%eax
80101bec:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bef:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bf3:	89 04 24             	mov    %eax,(%esp)
80101bf6:	e8 ab e5 ff ff       	call   801001a6 <bread>
80101bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c01:	83 c0 18             	add    $0x18,%eax
80101c04:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c07:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c14:	01 d0                	add    %edx,%eax
80101c16:	8b 00                	mov    (%eax),%eax
80101c18:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c1f:	75 30                	jne    80101c51 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101c21:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c2e:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c31:	8b 45 08             	mov    0x8(%ebp),%eax
80101c34:	8b 00                	mov    (%eax),%eax
80101c36:	89 04 24             	mov    %eax,(%esp)
80101c39:	e8 9d f7 ff ff       	call   801013db <balloc>
80101c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c44:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c49:	89 04 24             	mov    %eax,(%esp)
80101c4c:	e8 d2 16 00 00       	call   80103323 <log_write>
    }
    brelse(bp);
80101c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c54:	89 04 24             	mov    %eax,(%esp)
80101c57:	e8 bb e5 ff ff       	call   80100217 <brelse>
    return addr;
80101c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c5f:	eb 0c                	jmp    80101c6d <bmap+0x107>
  }

  panic("bmap: out of range");
80101c61:	c7 04 24 e2 83 10 80 	movl   $0x801083e2,(%esp)
80101c68:	e8 d9 e8 ff ff       	call   80100546 <panic>
}
80101c6d:	83 c4 24             	add    $0x24,%esp
80101c70:	5b                   	pop    %ebx
80101c71:	5d                   	pop    %ebp
80101c72:	c3                   	ret    

80101c73 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c73:	55                   	push   %ebp
80101c74:	89 e5                	mov    %esp,%ebp
80101c76:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c80:	eb 44                	jmp    80101cc6 <itrunc+0x53>
    if(ip->addrs[i]){
80101c82:	8b 45 08             	mov    0x8(%ebp),%eax
80101c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c88:	83 c2 04             	add    $0x4,%edx
80101c8b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c8f:	85 c0                	test   %eax,%eax
80101c91:	74 2f                	je     80101cc2 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c93:	8b 45 08             	mov    0x8(%ebp),%eax
80101c96:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c99:	83 c2 04             	add    $0x4,%edx
80101c9c:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca3:	8b 00                	mov    (%eax),%eax
80101ca5:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ca9:	89 04 24             	mov    %eax,(%esp)
80101cac:	e8 83 f8 ff ff       	call   80101534 <bfree>
      ip->addrs[i] = 0;
80101cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cb7:	83 c2 04             	add    $0x4,%edx
80101cba:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101cc1:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cc2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101cc6:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101cca:	7e b6                	jle    80101c82 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101ccc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccf:	8b 40 4c             	mov    0x4c(%eax),%eax
80101cd2:	85 c0                	test   %eax,%eax
80101cd4:	0f 84 9b 00 00 00    	je     80101d75 <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cda:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdd:	8b 50 4c             	mov    0x4c(%eax),%edx
80101ce0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce3:	8b 00                	mov    (%eax),%eax
80101ce5:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ce9:	89 04 24             	mov    %eax,(%esp)
80101cec:	e8 b5 e4 ff ff       	call   801001a6 <bread>
80101cf1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101cf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cf7:	83 c0 18             	add    $0x18,%eax
80101cfa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cfd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d04:	eb 3b                	jmp    80101d41 <itrunc+0xce>
      if(a[j])
80101d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d10:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d13:	01 d0                	add    %edx,%eax
80101d15:	8b 00                	mov    (%eax),%eax
80101d17:	85 c0                	test   %eax,%eax
80101d19:	74 22                	je     80101d3d <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d25:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d28:	01 d0                	add    %edx,%eax
80101d2a:	8b 10                	mov    (%eax),%edx
80101d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2f:	8b 00                	mov    (%eax),%eax
80101d31:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d35:	89 04 24             	mov    %eax,(%esp)
80101d38:	e8 f7 f7 ff ff       	call   80101534 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d3d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d44:	83 f8 7f             	cmp    $0x7f,%eax
80101d47:	76 bd                	jbe    80101d06 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d4c:	89 04 24             	mov    %eax,(%esp)
80101d4f:	e8 c3 e4 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d54:	8b 45 08             	mov    0x8(%ebp),%eax
80101d57:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5d:	8b 00                	mov    (%eax),%eax
80101d5f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d63:	89 04 24             	mov    %eax,(%esp)
80101d66:	e8 c9 f7 ff ff       	call   80101534 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6e:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d75:	8b 45 08             	mov    0x8(%ebp),%eax
80101d78:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d82:	89 04 24             	mov    %eax,(%esp)
80101d85:	e8 7e f9 ff ff       	call   80101708 <iupdate>
}
80101d8a:	c9                   	leave  
80101d8b:	c3                   	ret    

80101d8c <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d8c:	55                   	push   %ebp
80101d8d:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d92:	8b 00                	mov    (%eax),%eax
80101d94:	89 c2                	mov    %eax,%edx
80101d96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d99:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9f:	8b 50 04             	mov    0x4(%eax),%edx
80101da2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101da5:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101da8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dab:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101daf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101db2:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101db5:	8b 45 08             	mov    0x8(%ebp),%eax
80101db8:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dbf:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101dc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc6:	8b 50 18             	mov    0x18(%eax),%edx
80101dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dcc:	89 50 10             	mov    %edx,0x10(%eax)
}
80101dcf:	5d                   	pop    %ebp
80101dd0:	c3                   	ret    

80101dd1 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101dd1:	55                   	push   %ebp
80101dd2:	89 e5                	mov    %esp,%ebp
80101dd4:	53                   	push   %ebx
80101dd5:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101dd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ddb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ddf:	66 83 f8 03          	cmp    $0x3,%ax
80101de3:	75 60                	jne    80101e45 <readi+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101de5:	8b 45 08             	mov    0x8(%ebp),%eax
80101de8:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dec:	66 85 c0             	test   %ax,%ax
80101def:	78 20                	js     80101e11 <readi+0x40>
80101df1:	8b 45 08             	mov    0x8(%ebp),%eax
80101df4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101df8:	66 83 f8 09          	cmp    $0x9,%ax
80101dfc:	7f 13                	jg     80101e11 <readi+0x40>
80101dfe:	8b 45 08             	mov    0x8(%ebp),%eax
80101e01:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e05:	98                   	cwtl   
80101e06:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101e0d:	85 c0                	test   %eax,%eax
80101e0f:	75 0a                	jne    80101e1b <readi+0x4a>
      return -1;
80101e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e16:	e9 1e 01 00 00       	jmp    80101f39 <readi+0x168>
    return devsw[ip->major].read(ip, dst, n);
80101e1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e22:	98                   	cwtl   
80101e23:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101e2a:	8b 55 14             	mov    0x14(%ebp),%edx
80101e2d:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e31:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e34:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e38:	8b 55 08             	mov    0x8(%ebp),%edx
80101e3b:	89 14 24             	mov    %edx,(%esp)
80101e3e:	ff d0                	call   *%eax
80101e40:	e9 f4 00 00 00       	jmp    80101f39 <readi+0x168>
  }

  if(off > ip->size || off + n < off)
80101e45:	8b 45 08             	mov    0x8(%ebp),%eax
80101e48:	8b 40 18             	mov    0x18(%eax),%eax
80101e4b:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e4e:	72 0d                	jb     80101e5d <readi+0x8c>
80101e50:	8b 45 14             	mov    0x14(%ebp),%eax
80101e53:	8b 55 10             	mov    0x10(%ebp),%edx
80101e56:	01 d0                	add    %edx,%eax
80101e58:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e5b:	73 0a                	jae    80101e67 <readi+0x96>
    return -1;
80101e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e62:	e9 d2 00 00 00       	jmp    80101f39 <readi+0x168>
  if(off + n > ip->size)
80101e67:	8b 45 14             	mov    0x14(%ebp),%eax
80101e6a:	8b 55 10             	mov    0x10(%ebp),%edx
80101e6d:	01 c2                	add    %eax,%edx
80101e6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e72:	8b 40 18             	mov    0x18(%eax),%eax
80101e75:	39 c2                	cmp    %eax,%edx
80101e77:	76 0c                	jbe    80101e85 <readi+0xb4>
    n = ip->size - off;
80101e79:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7c:	8b 40 18             	mov    0x18(%eax),%eax
80101e7f:	2b 45 10             	sub    0x10(%ebp),%eax
80101e82:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e8c:	e9 99 00 00 00       	jmp    80101f2a <readi+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e91:	8b 45 10             	mov    0x10(%ebp),%eax
80101e94:	c1 e8 09             	shr    $0x9,%eax
80101e97:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9e:	89 04 24             	mov    %eax,(%esp)
80101ea1:	e8 c0 fc ff ff       	call   80101b66 <bmap>
80101ea6:	8b 55 08             	mov    0x8(%ebp),%edx
80101ea9:	8b 12                	mov    (%edx),%edx
80101eab:	89 44 24 04          	mov    %eax,0x4(%esp)
80101eaf:	89 14 24             	mov    %edx,(%esp)
80101eb2:	e8 ef e2 ff ff       	call   801001a6 <bread>
80101eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101eba:	8b 45 10             	mov    0x10(%ebp),%eax
80101ebd:	89 c2                	mov    %eax,%edx
80101ebf:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101ec5:	b8 00 02 00 00       	mov    $0x200,%eax
80101eca:	89 c1                	mov    %eax,%ecx
80101ecc:	29 d1                	sub    %edx,%ecx
80101ece:	89 ca                	mov    %ecx,%edx
80101ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ed3:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101ed6:	89 cb                	mov    %ecx,%ebx
80101ed8:	29 c3                	sub    %eax,%ebx
80101eda:	89 d8                	mov    %ebx,%eax
80101edc:	39 c2                	cmp    %eax,%edx
80101ede:	0f 46 c2             	cmovbe %edx,%eax
80101ee1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101ee4:	8b 45 10             	mov    0x10(%ebp),%eax
80101ee7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101eec:	8d 50 10             	lea    0x10(%eax),%edx
80101eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ef2:	01 d0                	add    %edx,%eax
80101ef4:	8d 50 08             	lea    0x8(%eax),%edx
80101ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101efa:	89 44 24 08          	mov    %eax,0x8(%esp)
80101efe:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f02:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f05:	89 04 24             	mov    %eax,(%esp)
80101f08:	e8 34 31 00 00       	call   80105041 <memmove>
    brelse(bp);
80101f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f10:	89 04 24             	mov    %eax,(%esp)
80101f13:	e8 ff e2 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f1b:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f21:	01 45 10             	add    %eax,0x10(%ebp)
80101f24:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f27:	01 45 0c             	add    %eax,0xc(%ebp)
80101f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f2d:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f30:	0f 82 5b ff ff ff    	jb     80101e91 <readi+0xc0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f36:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f39:	83 c4 24             	add    $0x24,%esp
80101f3c:	5b                   	pop    %ebx
80101f3d:	5d                   	pop    %ebp
80101f3e:	c3                   	ret    

80101f3f <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f3f:	55                   	push   %ebp
80101f40:	89 e5                	mov    %esp,%ebp
80101f42:	53                   	push   %ebx
80101f43:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f46:	8b 45 08             	mov    0x8(%ebp),%eax
80101f49:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f4d:	66 83 f8 03          	cmp    $0x3,%ax
80101f51:	75 60                	jne    80101fb3 <writei+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f53:	8b 45 08             	mov    0x8(%ebp),%eax
80101f56:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f5a:	66 85 c0             	test   %ax,%ax
80101f5d:	78 20                	js     80101f7f <writei+0x40>
80101f5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f62:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f66:	66 83 f8 09          	cmp    $0x9,%ax
80101f6a:	7f 13                	jg     80101f7f <writei+0x40>
80101f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f73:	98                   	cwtl   
80101f74:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101f7b:	85 c0                	test   %eax,%eax
80101f7d:	75 0a                	jne    80101f89 <writei+0x4a>
      return -1;
80101f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f84:	e9 49 01 00 00       	jmp    801020d2 <writei+0x193>
    return devsw[ip->major].write(ip, src, n);
80101f89:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f90:	98                   	cwtl   
80101f91:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101f98:	8b 55 14             	mov    0x14(%ebp),%edx
80101f9b:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f9f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fa2:	89 54 24 04          	mov    %edx,0x4(%esp)
80101fa6:	8b 55 08             	mov    0x8(%ebp),%edx
80101fa9:	89 14 24             	mov    %edx,(%esp)
80101fac:	ff d0                	call   *%eax
80101fae:	e9 1f 01 00 00       	jmp    801020d2 <writei+0x193>
  }

  if(off > ip->size || off + n < off)
80101fb3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb6:	8b 40 18             	mov    0x18(%eax),%eax
80101fb9:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fbc:	72 0d                	jb     80101fcb <writei+0x8c>
80101fbe:	8b 45 14             	mov    0x14(%ebp),%eax
80101fc1:	8b 55 10             	mov    0x10(%ebp),%edx
80101fc4:	01 d0                	add    %edx,%eax
80101fc6:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fc9:	73 0a                	jae    80101fd5 <writei+0x96>
    return -1;
80101fcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fd0:	e9 fd 00 00 00       	jmp    801020d2 <writei+0x193>
  if(off + n > MAXFILE*BSIZE)
80101fd5:	8b 45 14             	mov    0x14(%ebp),%eax
80101fd8:	8b 55 10             	mov    0x10(%ebp),%edx
80101fdb:	01 d0                	add    %edx,%eax
80101fdd:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101fe2:	76 0a                	jbe    80101fee <writei+0xaf>
    return -1;
80101fe4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fe9:	e9 e4 00 00 00       	jmp    801020d2 <writei+0x193>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ff5:	e9 a4 00 00 00       	jmp    8010209e <writei+0x15f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ffa:	8b 45 10             	mov    0x10(%ebp),%eax
80101ffd:	c1 e8 09             	shr    $0x9,%eax
80102000:	89 44 24 04          	mov    %eax,0x4(%esp)
80102004:	8b 45 08             	mov    0x8(%ebp),%eax
80102007:	89 04 24             	mov    %eax,(%esp)
8010200a:	e8 57 fb ff ff       	call   80101b66 <bmap>
8010200f:	8b 55 08             	mov    0x8(%ebp),%edx
80102012:	8b 12                	mov    (%edx),%edx
80102014:	89 44 24 04          	mov    %eax,0x4(%esp)
80102018:	89 14 24             	mov    %edx,(%esp)
8010201b:	e8 86 e1 ff ff       	call   801001a6 <bread>
80102020:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102023:	8b 45 10             	mov    0x10(%ebp),%eax
80102026:	89 c2                	mov    %eax,%edx
80102028:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010202e:	b8 00 02 00 00       	mov    $0x200,%eax
80102033:	89 c1                	mov    %eax,%ecx
80102035:	29 d1                	sub    %edx,%ecx
80102037:	89 ca                	mov    %ecx,%edx
80102039:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010203c:	8b 4d 14             	mov    0x14(%ebp),%ecx
8010203f:	89 cb                	mov    %ecx,%ebx
80102041:	29 c3                	sub    %eax,%ebx
80102043:	89 d8                	mov    %ebx,%eax
80102045:	39 c2                	cmp    %eax,%edx
80102047:	0f 46 c2             	cmovbe %edx,%eax
8010204a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010204d:	8b 45 10             	mov    0x10(%ebp),%eax
80102050:	25 ff 01 00 00       	and    $0x1ff,%eax
80102055:	8d 50 10             	lea    0x10(%eax),%edx
80102058:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010205b:	01 d0                	add    %edx,%eax
8010205d:	8d 50 08             	lea    0x8(%eax),%edx
80102060:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102063:	89 44 24 08          	mov    %eax,0x8(%esp)
80102067:	8b 45 0c             	mov    0xc(%ebp),%eax
8010206a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010206e:	89 14 24             	mov    %edx,(%esp)
80102071:	e8 cb 2f 00 00       	call   80105041 <memmove>
    log_write(bp);
80102076:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102079:	89 04 24             	mov    %eax,(%esp)
8010207c:	e8 a2 12 00 00       	call   80103323 <log_write>
    brelse(bp);
80102081:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102084:	89 04 24             	mov    %eax,(%esp)
80102087:	e8 8b e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010208c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010208f:	01 45 f4             	add    %eax,-0xc(%ebp)
80102092:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102095:	01 45 10             	add    %eax,0x10(%ebp)
80102098:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010209b:	01 45 0c             	add    %eax,0xc(%ebp)
8010209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020a1:	3b 45 14             	cmp    0x14(%ebp),%eax
801020a4:	0f 82 50 ff ff ff    	jb     80101ffa <writei+0xbb>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801020aa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801020ae:	74 1f                	je     801020cf <writei+0x190>
801020b0:	8b 45 08             	mov    0x8(%ebp),%eax
801020b3:	8b 40 18             	mov    0x18(%eax),%eax
801020b6:	3b 45 10             	cmp    0x10(%ebp),%eax
801020b9:	73 14                	jae    801020cf <writei+0x190>
    ip->size = off;
801020bb:	8b 45 08             	mov    0x8(%ebp),%eax
801020be:	8b 55 10             	mov    0x10(%ebp),%edx
801020c1:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801020c4:	8b 45 08             	mov    0x8(%ebp),%eax
801020c7:	89 04 24             	mov    %eax,(%esp)
801020ca:	e8 39 f6 ff ff       	call   80101708 <iupdate>
  }
  return n;
801020cf:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020d2:	83 c4 24             	add    $0x24,%esp
801020d5:	5b                   	pop    %ebx
801020d6:	5d                   	pop    %ebp
801020d7:	c3                   	ret    

801020d8 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020d8:	55                   	push   %ebp
801020d9:	89 e5                	mov    %esp,%ebp
801020db:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801020de:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020e5:	00 
801020e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801020e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801020ed:	8b 45 08             	mov    0x8(%ebp),%eax
801020f0:	89 04 24             	mov    %eax,(%esp)
801020f3:	e8 f1 2f 00 00       	call   801050e9 <strncmp>
}
801020f8:	c9                   	leave  
801020f9:	c3                   	ret    

801020fa <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801020fa:	55                   	push   %ebp
801020fb:	89 e5                	mov    %esp,%ebp
801020fd:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102100:	8b 45 08             	mov    0x8(%ebp),%eax
80102103:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102107:	66 83 f8 01          	cmp    $0x1,%ax
8010210b:	74 0c                	je     80102119 <dirlookup+0x1f>
    panic("dirlookup not DIR");
8010210d:	c7 04 24 f5 83 10 80 	movl   $0x801083f5,(%esp)
80102114:	e8 2d e4 ff ff       	call   80100546 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102119:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102120:	e9 87 00 00 00       	jmp    801021ac <dirlookup+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102125:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010212c:	00 
8010212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102130:	89 44 24 08          	mov    %eax,0x8(%esp)
80102134:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102137:	89 44 24 04          	mov    %eax,0x4(%esp)
8010213b:	8b 45 08             	mov    0x8(%ebp),%eax
8010213e:	89 04 24             	mov    %eax,(%esp)
80102141:	e8 8b fc ff ff       	call   80101dd1 <readi>
80102146:	83 f8 10             	cmp    $0x10,%eax
80102149:	74 0c                	je     80102157 <dirlookup+0x5d>
      panic("dirlink read");
8010214b:	c7 04 24 07 84 10 80 	movl   $0x80108407,(%esp)
80102152:	e8 ef e3 ff ff       	call   80100546 <panic>
    if(de.inum == 0)
80102157:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010215b:	66 85 c0             	test   %ax,%ax
8010215e:	74 47                	je     801021a7 <dirlookup+0xad>
      continue;
    if(namecmp(name, de.name) == 0){
80102160:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102163:	83 c0 02             	add    $0x2,%eax
80102166:	89 44 24 04          	mov    %eax,0x4(%esp)
8010216a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010216d:	89 04 24             	mov    %eax,(%esp)
80102170:	e8 63 ff ff ff       	call   801020d8 <namecmp>
80102175:	85 c0                	test   %eax,%eax
80102177:	75 2f                	jne    801021a8 <dirlookup+0xae>
      // entry matches path element
      if(poff)
80102179:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010217d:	74 08                	je     80102187 <dirlookup+0x8d>
        *poff = off;
8010217f:	8b 45 10             	mov    0x10(%ebp),%eax
80102182:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102185:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102187:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010218b:	0f b7 c0             	movzwl %ax,%eax
8010218e:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102191:	8b 45 08             	mov    0x8(%ebp),%eax
80102194:	8b 00                	mov    (%eax),%eax
80102196:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102199:	89 54 24 04          	mov    %edx,0x4(%esp)
8010219d:	89 04 24             	mov    %eax,(%esp)
801021a0:	e8 1b f6 ff ff       	call   801017c0 <iget>
801021a5:	eb 19                	jmp    801021c0 <dirlookup+0xc6>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
801021a7:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021a8:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801021ac:	8b 45 08             	mov    0x8(%ebp),%eax
801021af:	8b 40 18             	mov    0x18(%eax),%eax
801021b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801021b5:	0f 87 6a ff ff ff    	ja     80102125 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801021bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801021c0:	c9                   	leave  
801021c1:	c3                   	ret    

801021c2 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021c2:	55                   	push   %ebp
801021c3:	89 e5                	mov    %esp,%ebp
801021c5:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021c8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801021cf:	00 
801021d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801021d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801021d7:	8b 45 08             	mov    0x8(%ebp),%eax
801021da:	89 04 24             	mov    %eax,(%esp)
801021dd:	e8 18 ff ff ff       	call   801020fa <dirlookup>
801021e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801021e9:	74 15                	je     80102200 <dirlink+0x3e>
    iput(ip);
801021eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021ee:	89 04 24             	mov    %eax,(%esp)
801021f1:	e8 81 f8 ff ff       	call   80101a77 <iput>
    return -1;
801021f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021fb:	e9 b8 00 00 00       	jmp    801022b8 <dirlink+0xf6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102200:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102207:	eb 44                	jmp    8010224d <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102209:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010220c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102213:	00 
80102214:	89 44 24 08          	mov    %eax,0x8(%esp)
80102218:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010221b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010221f:	8b 45 08             	mov    0x8(%ebp),%eax
80102222:	89 04 24             	mov    %eax,(%esp)
80102225:	e8 a7 fb ff ff       	call   80101dd1 <readi>
8010222a:	83 f8 10             	cmp    $0x10,%eax
8010222d:	74 0c                	je     8010223b <dirlink+0x79>
      panic("dirlink read");
8010222f:	c7 04 24 07 84 10 80 	movl   $0x80108407,(%esp)
80102236:	e8 0b e3 ff ff       	call   80100546 <panic>
    if(de.inum == 0)
8010223b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010223f:	66 85 c0             	test   %ax,%ax
80102242:	74 18                	je     8010225c <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102247:	83 c0 10             	add    $0x10,%eax
8010224a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010224d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102250:	8b 45 08             	mov    0x8(%ebp),%eax
80102253:	8b 40 18             	mov    0x18(%eax),%eax
80102256:	39 c2                	cmp    %eax,%edx
80102258:	72 af                	jb     80102209 <dirlink+0x47>
8010225a:	eb 01                	jmp    8010225d <dirlink+0x9b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
8010225c:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010225d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102264:	00 
80102265:	8b 45 0c             	mov    0xc(%ebp),%eax
80102268:	89 44 24 04          	mov    %eax,0x4(%esp)
8010226c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010226f:	83 c0 02             	add    $0x2,%eax
80102272:	89 04 24             	mov    %eax,(%esp)
80102275:	e8 c7 2e 00 00       	call   80105141 <strncpy>
  de.inum = inum;
8010227a:	8b 45 10             	mov    0x10(%ebp),%eax
8010227d:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102284:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010228b:	00 
8010228c:	89 44 24 08          	mov    %eax,0x8(%esp)
80102290:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102293:	89 44 24 04          	mov    %eax,0x4(%esp)
80102297:	8b 45 08             	mov    0x8(%ebp),%eax
8010229a:	89 04 24             	mov    %eax,(%esp)
8010229d:	e8 9d fc ff ff       	call   80101f3f <writei>
801022a2:	83 f8 10             	cmp    $0x10,%eax
801022a5:	74 0c                	je     801022b3 <dirlink+0xf1>
    panic("dirlink");
801022a7:	c7 04 24 14 84 10 80 	movl   $0x80108414,(%esp)
801022ae:	e8 93 e2 ff ff       	call   80100546 <panic>
  
  return 0;
801022b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022b8:	c9                   	leave  
801022b9:	c3                   	ret    

801022ba <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022ba:	55                   	push   %ebp
801022bb:	89 e5                	mov    %esp,%ebp
801022bd:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
801022c0:	eb 04                	jmp    801022c6 <skipelem+0xc>
    path++;
801022c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801022c6:	8b 45 08             	mov    0x8(%ebp),%eax
801022c9:	0f b6 00             	movzbl (%eax),%eax
801022cc:	3c 2f                	cmp    $0x2f,%al
801022ce:	74 f2                	je     801022c2 <skipelem+0x8>
    path++;
  if(*path == 0)
801022d0:	8b 45 08             	mov    0x8(%ebp),%eax
801022d3:	0f b6 00             	movzbl (%eax),%eax
801022d6:	84 c0                	test   %al,%al
801022d8:	75 0a                	jne    801022e4 <skipelem+0x2a>
    return 0;
801022da:	b8 00 00 00 00       	mov    $0x0,%eax
801022df:	e9 88 00 00 00       	jmp    8010236c <skipelem+0xb2>
  s = path;
801022e4:	8b 45 08             	mov    0x8(%ebp),%eax
801022e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022ea:	eb 04                	jmp    801022f0 <skipelem+0x36>
    path++;
801022ec:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022f0:	8b 45 08             	mov    0x8(%ebp),%eax
801022f3:	0f b6 00             	movzbl (%eax),%eax
801022f6:	3c 2f                	cmp    $0x2f,%al
801022f8:	74 0a                	je     80102304 <skipelem+0x4a>
801022fa:	8b 45 08             	mov    0x8(%ebp),%eax
801022fd:	0f b6 00             	movzbl (%eax),%eax
80102300:	84 c0                	test   %al,%al
80102302:	75 e8                	jne    801022ec <skipelem+0x32>
    path++;
  len = path - s;
80102304:	8b 55 08             	mov    0x8(%ebp),%edx
80102307:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010230a:	89 d1                	mov    %edx,%ecx
8010230c:	29 c1                	sub    %eax,%ecx
8010230e:	89 c8                	mov    %ecx,%eax
80102310:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102313:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102317:	7e 1c                	jle    80102335 <skipelem+0x7b>
    memmove(name, s, DIRSIZ);
80102319:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102320:	00 
80102321:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102324:	89 44 24 04          	mov    %eax,0x4(%esp)
80102328:	8b 45 0c             	mov    0xc(%ebp),%eax
8010232b:	89 04 24             	mov    %eax,(%esp)
8010232e:	e8 0e 2d 00 00       	call   80105041 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102333:	eb 2a                	jmp    8010235f <skipelem+0xa5>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102335:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102338:	89 44 24 08          	mov    %eax,0x8(%esp)
8010233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010233f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102343:	8b 45 0c             	mov    0xc(%ebp),%eax
80102346:	89 04 24             	mov    %eax,(%esp)
80102349:	e8 f3 2c 00 00       	call   80105041 <memmove>
    name[len] = 0;
8010234e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102351:	8b 45 0c             	mov    0xc(%ebp),%eax
80102354:	01 d0                	add    %edx,%eax
80102356:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102359:	eb 04                	jmp    8010235f <skipelem+0xa5>
    path++;
8010235b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010235f:	8b 45 08             	mov    0x8(%ebp),%eax
80102362:	0f b6 00             	movzbl (%eax),%eax
80102365:	3c 2f                	cmp    $0x2f,%al
80102367:	74 f2                	je     8010235b <skipelem+0xa1>
    path++;
  return path;
80102369:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010236c:	c9                   	leave  
8010236d:	c3                   	ret    

8010236e <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010236e:	55                   	push   %ebp
8010236f:	89 e5                	mov    %esp,%ebp
80102371:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102374:	8b 45 08             	mov    0x8(%ebp),%eax
80102377:	0f b6 00             	movzbl (%eax),%eax
8010237a:	3c 2f                	cmp    $0x2f,%al
8010237c:	75 1c                	jne    8010239a <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
8010237e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102385:	00 
80102386:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010238d:	e8 2e f4 ff ff       	call   801017c0 <iget>
80102392:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102395:	e9 af 00 00 00       	jmp    80102449 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010239a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023a0:	8b 40 68             	mov    0x68(%eax),%eax
801023a3:	89 04 24             	mov    %eax,(%esp)
801023a6:	e8 e7 f4 ff ff       	call   80101892 <idup>
801023ab:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023ae:	e9 96 00 00 00       	jmp    80102449 <namex+0xdb>
    ilock(ip);
801023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b6:	89 04 24             	mov    %eax,(%esp)
801023b9:	e8 06 f5 ff ff       	call   801018c4 <ilock>
    if(ip->type != T_DIR){
801023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023c5:	66 83 f8 01          	cmp    $0x1,%ax
801023c9:	74 15                	je     801023e0 <namex+0x72>
      iunlockput(ip);
801023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ce:	89 04 24             	mov    %eax,(%esp)
801023d1:	e8 72 f7 ff ff       	call   80101b48 <iunlockput>
      return 0;
801023d6:	b8 00 00 00 00       	mov    $0x0,%eax
801023db:	e9 a3 00 00 00       	jmp    80102483 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
801023e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023e4:	74 1d                	je     80102403 <namex+0x95>
801023e6:	8b 45 08             	mov    0x8(%ebp),%eax
801023e9:	0f b6 00             	movzbl (%eax),%eax
801023ec:	84 c0                	test   %al,%al
801023ee:	75 13                	jne    80102403 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
801023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f3:	89 04 24             	mov    %eax,(%esp)
801023f6:	e8 17 f6 ff ff       	call   80101a12 <iunlock>
      return ip;
801023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023fe:	e9 80 00 00 00       	jmp    80102483 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102403:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010240a:	00 
8010240b:	8b 45 10             	mov    0x10(%ebp),%eax
8010240e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102415:	89 04 24             	mov    %eax,(%esp)
80102418:	e8 dd fc ff ff       	call   801020fa <dirlookup>
8010241d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102420:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102424:	75 12                	jne    80102438 <namex+0xca>
      iunlockput(ip);
80102426:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102429:	89 04 24             	mov    %eax,(%esp)
8010242c:	e8 17 f7 ff ff       	call   80101b48 <iunlockput>
      return 0;
80102431:	b8 00 00 00 00       	mov    $0x0,%eax
80102436:	eb 4b                	jmp    80102483 <namex+0x115>
    }
    iunlockput(ip);
80102438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010243b:	89 04 24             	mov    %eax,(%esp)
8010243e:	e8 05 f7 ff ff       	call   80101b48 <iunlockput>
    ip = next;
80102443:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102446:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102449:	8b 45 10             	mov    0x10(%ebp),%eax
8010244c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102450:	8b 45 08             	mov    0x8(%ebp),%eax
80102453:	89 04 24             	mov    %eax,(%esp)
80102456:	e8 5f fe ff ff       	call   801022ba <skipelem>
8010245b:	89 45 08             	mov    %eax,0x8(%ebp)
8010245e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102462:	0f 85 4b ff ff ff    	jne    801023b3 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102468:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010246c:	74 12                	je     80102480 <namex+0x112>
    iput(ip);
8010246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102471:	89 04 24             	mov    %eax,(%esp)
80102474:	e8 fe f5 ff ff       	call   80101a77 <iput>
    return 0;
80102479:	b8 00 00 00 00       	mov    $0x0,%eax
8010247e:	eb 03                	jmp    80102483 <namex+0x115>
  }
  return ip;
80102480:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102483:	c9                   	leave  
80102484:	c3                   	ret    

80102485 <namei>:

struct inode*
namei(char *path)
{
80102485:	55                   	push   %ebp
80102486:	89 e5                	mov    %esp,%ebp
80102488:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010248b:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010248e:	89 44 24 08          	mov    %eax,0x8(%esp)
80102492:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102499:	00 
8010249a:	8b 45 08             	mov    0x8(%ebp),%eax
8010249d:	89 04 24             	mov    %eax,(%esp)
801024a0:	e8 c9 fe ff ff       	call   8010236e <namex>
}
801024a5:	c9                   	leave  
801024a6:	c3                   	ret    

801024a7 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024a7:	55                   	push   %ebp
801024a8:	89 e5                	mov    %esp,%ebp
801024aa:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
801024ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801024b0:	89 44 24 08          	mov    %eax,0x8(%esp)
801024b4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801024bb:	00 
801024bc:	8b 45 08             	mov    0x8(%ebp),%eax
801024bf:	89 04 24             	mov    %eax,(%esp)
801024c2:	e8 a7 fe ff ff       	call   8010236e <namex>
}
801024c7:	c9                   	leave  
801024c8:	c3                   	ret    
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	90                   	nop

801024cc <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024cc:	55                   	push   %ebp
801024cd:	89 e5                	mov    %esp,%ebp
801024cf:	53                   	push   %ebx
801024d0:	83 ec 14             	sub    $0x14,%esp
801024d3:	8b 45 08             	mov    0x8(%ebp),%eax
801024d6:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024da:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
801024de:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801024e2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801024e6:	ec                   	in     (%dx),%al
801024e7:	89 c3                	mov    %eax,%ebx
801024e9:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801024ec:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801024f0:	83 c4 14             	add    $0x14,%esp
801024f3:	5b                   	pop    %ebx
801024f4:	5d                   	pop    %ebp
801024f5:	c3                   	ret    

801024f6 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024f6:	55                   	push   %ebp
801024f7:	89 e5                	mov    %esp,%ebp
801024f9:	57                   	push   %edi
801024fa:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024fb:	8b 55 08             	mov    0x8(%ebp),%edx
801024fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102501:	8b 45 10             	mov    0x10(%ebp),%eax
80102504:	89 cb                	mov    %ecx,%ebx
80102506:	89 df                	mov    %ebx,%edi
80102508:	89 c1                	mov    %eax,%ecx
8010250a:	fc                   	cld    
8010250b:	f3 6d                	rep insl (%dx),%es:(%edi)
8010250d:	89 c8                	mov    %ecx,%eax
8010250f:	89 fb                	mov    %edi,%ebx
80102511:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102514:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102517:	5b                   	pop    %ebx
80102518:	5f                   	pop    %edi
80102519:	5d                   	pop    %ebp
8010251a:	c3                   	ret    

8010251b <outb>:

static inline void
outb(ushort port, uchar data)
{
8010251b:	55                   	push   %ebp
8010251c:	89 e5                	mov    %esp,%ebp
8010251e:	83 ec 08             	sub    $0x8,%esp
80102521:	8b 55 08             	mov    0x8(%ebp),%edx
80102524:	8b 45 0c             	mov    0xc(%ebp),%eax
80102527:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010252b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010252e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102532:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102536:	ee                   	out    %al,(%dx)
}
80102537:	c9                   	leave  
80102538:	c3                   	ret    

80102539 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102539:	55                   	push   %ebp
8010253a:	89 e5                	mov    %esp,%ebp
8010253c:	56                   	push   %esi
8010253d:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010253e:	8b 55 08             	mov    0x8(%ebp),%edx
80102541:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102544:	8b 45 10             	mov    0x10(%ebp),%eax
80102547:	89 cb                	mov    %ecx,%ebx
80102549:	89 de                	mov    %ebx,%esi
8010254b:	89 c1                	mov    %eax,%ecx
8010254d:	fc                   	cld    
8010254e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102550:	89 c8                	mov    %ecx,%eax
80102552:	89 f3                	mov    %esi,%ebx
80102554:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102557:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010255a:	5b                   	pop    %ebx
8010255b:	5e                   	pop    %esi
8010255c:	5d                   	pop    %ebp
8010255d:	c3                   	ret    

8010255e <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010255e:	55                   	push   %ebp
8010255f:	89 e5                	mov    %esp,%ebp
80102561:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102564:	90                   	nop
80102565:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010256c:	e8 5b ff ff ff       	call   801024cc <inb>
80102571:	0f b6 c0             	movzbl %al,%eax
80102574:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102577:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010257a:	25 c0 00 00 00       	and    $0xc0,%eax
8010257f:	83 f8 40             	cmp    $0x40,%eax
80102582:	75 e1                	jne    80102565 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102584:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102588:	74 11                	je     8010259b <idewait+0x3d>
8010258a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010258d:	83 e0 21             	and    $0x21,%eax
80102590:	85 c0                	test   %eax,%eax
80102592:	74 07                	je     8010259b <idewait+0x3d>
    return -1;
80102594:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102599:	eb 05                	jmp    801025a0 <idewait+0x42>
  return 0;
8010259b:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025a0:	c9                   	leave  
801025a1:	c3                   	ret    

801025a2 <ideinit>:

void
ideinit(void)
{
801025a2:	55                   	push   %ebp
801025a3:	89 e5                	mov    %esp,%ebp
801025a5:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
801025a8:	c7 44 24 04 1c 84 10 	movl   $0x8010841c,0x4(%esp)
801025af:	80 
801025b0:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801025b7:	e8 42 27 00 00       	call   80104cfe <initlock>
  picenable(IRQ_IDE);
801025bc:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025c3:	e8 39 15 00 00       	call   80103b01 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
801025c8:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801025cd:	83 e8 01             	sub    $0x1,%eax
801025d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801025d4:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025db:	e8 12 04 00 00       	call   801029f2 <ioapicenable>
  idewait(0);
801025e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025e7:	e8 72 ff ff ff       	call   8010255e <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025ec:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025f3:	00 
801025f4:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025fb:	e8 1b ff ff ff       	call   8010251b <outb>
  for(i=0; i<1000; i++){
80102600:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102607:	eb 20                	jmp    80102629 <ideinit+0x87>
    if(inb(0x1f7) != 0){
80102609:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102610:	e8 b7 fe ff ff       	call   801024cc <inb>
80102615:	84 c0                	test   %al,%al
80102617:	74 0c                	je     80102625 <ideinit+0x83>
      havedisk1 = 1;
80102619:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
80102620:	00 00 00 
      break;
80102623:	eb 0d                	jmp    80102632 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102625:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102629:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102630:	7e d7                	jle    80102609 <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102632:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102639:	00 
8010263a:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102641:	e8 d5 fe ff ff       	call   8010251b <outb>
}
80102646:	c9                   	leave  
80102647:	c3                   	ret    

80102648 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102648:	55                   	push   %ebp
80102649:	89 e5                	mov    %esp,%ebp
8010264b:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010264e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102652:	75 0c                	jne    80102660 <idestart+0x18>
    panic("idestart");
80102654:	c7 04 24 20 84 10 80 	movl   $0x80108420,(%esp)
8010265b:	e8 e6 de ff ff       	call   80100546 <panic>

  idewait(0);
80102660:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102667:	e8 f2 fe ff ff       	call   8010255e <idewait>
  outb(0x3f6, 0);  // generate interrupt
8010266c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102673:	00 
80102674:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
8010267b:	e8 9b fe ff ff       	call   8010251b <outb>
  outb(0x1f2, 1);  // number of sectors
80102680:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102687:	00 
80102688:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
8010268f:	e8 87 fe ff ff       	call   8010251b <outb>
  outb(0x1f3, b->sector & 0xff);
80102694:	8b 45 08             	mov    0x8(%ebp),%eax
80102697:	8b 40 08             	mov    0x8(%eax),%eax
8010269a:	0f b6 c0             	movzbl %al,%eax
8010269d:	89 44 24 04          	mov    %eax,0x4(%esp)
801026a1:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
801026a8:	e8 6e fe ff ff       	call   8010251b <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
801026ad:	8b 45 08             	mov    0x8(%ebp),%eax
801026b0:	8b 40 08             	mov    0x8(%eax),%eax
801026b3:	c1 e8 08             	shr    $0x8,%eax
801026b6:	0f b6 c0             	movzbl %al,%eax
801026b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801026bd:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
801026c4:	e8 52 fe ff ff       	call   8010251b <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
801026c9:	8b 45 08             	mov    0x8(%ebp),%eax
801026cc:	8b 40 08             	mov    0x8(%eax),%eax
801026cf:	c1 e8 10             	shr    $0x10,%eax
801026d2:	0f b6 c0             	movzbl %al,%eax
801026d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801026d9:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
801026e0:	e8 36 fe ff ff       	call   8010251b <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
801026e5:	8b 45 08             	mov    0x8(%ebp),%eax
801026e8:	8b 40 04             	mov    0x4(%eax),%eax
801026eb:	83 e0 01             	and    $0x1,%eax
801026ee:	89 c2                	mov    %eax,%edx
801026f0:	c1 e2 04             	shl    $0x4,%edx
801026f3:	8b 45 08             	mov    0x8(%ebp),%eax
801026f6:	8b 40 08             	mov    0x8(%eax),%eax
801026f9:	c1 e8 18             	shr    $0x18,%eax
801026fc:	83 e0 0f             	and    $0xf,%eax
801026ff:	09 d0                	or     %edx,%eax
80102701:	83 c8 e0             	or     $0xffffffe0,%eax
80102704:	0f b6 c0             	movzbl %al,%eax
80102707:	89 44 24 04          	mov    %eax,0x4(%esp)
8010270b:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102712:	e8 04 fe ff ff       	call   8010251b <outb>
  if(b->flags & B_DIRTY){
80102717:	8b 45 08             	mov    0x8(%ebp),%eax
8010271a:	8b 00                	mov    (%eax),%eax
8010271c:	83 e0 04             	and    $0x4,%eax
8010271f:	85 c0                	test   %eax,%eax
80102721:	74 34                	je     80102757 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
80102723:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
8010272a:	00 
8010272b:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102732:	e8 e4 fd ff ff       	call   8010251b <outb>
    outsl(0x1f0, b->data, 512/4);
80102737:	8b 45 08             	mov    0x8(%ebp),%eax
8010273a:	83 c0 18             	add    $0x18,%eax
8010273d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102744:	00 
80102745:	89 44 24 04          	mov    %eax,0x4(%esp)
80102749:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102750:	e8 e4 fd ff ff       	call   80102539 <outsl>
80102755:	eb 14                	jmp    8010276b <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102757:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
8010275e:	00 
8010275f:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102766:	e8 b0 fd ff ff       	call   8010251b <outb>
  }
}
8010276b:	c9                   	leave  
8010276c:	c3                   	ret    

8010276d <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010276d:	55                   	push   %ebp
8010276e:	89 e5                	mov    %esp,%ebp
80102770:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102773:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010277a:	e8 a0 25 00 00       	call   80104d1f <acquire>
  if((b = idequeue) == 0){
8010277f:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102784:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010278b:	75 11                	jne    8010279e <ideintr+0x31>
    release(&idelock);
8010278d:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102794:	e8 e7 25 00 00       	call   80104d80 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102799:	e9 90 00 00 00       	jmp    8010282e <ideintr+0xc1>
  }
  idequeue = b->qnext;
8010279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a1:	8b 40 14             	mov    0x14(%eax),%eax
801027a4:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ac:	8b 00                	mov    (%eax),%eax
801027ae:	83 e0 04             	and    $0x4,%eax
801027b1:	85 c0                	test   %eax,%eax
801027b3:	75 2e                	jne    801027e3 <ideintr+0x76>
801027b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801027bc:	e8 9d fd ff ff       	call   8010255e <idewait>
801027c1:	85 c0                	test   %eax,%eax
801027c3:	78 1e                	js     801027e3 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
801027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027c8:	83 c0 18             	add    $0x18,%eax
801027cb:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801027d2:	00 
801027d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801027d7:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801027de:	e8 13 fd ff ff       	call   801024f6 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027e6:	8b 00                	mov    (%eax),%eax
801027e8:	89 c2                	mov    %eax,%edx
801027ea:	83 ca 02             	or     $0x2,%edx
801027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f0:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f5:	8b 00                	mov    (%eax),%eax
801027f7:	89 c2                	mov    %eax,%edx
801027f9:	83 e2 fb             	and    $0xfffffffb,%edx
801027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ff:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102804:	89 04 24             	mov    %eax,(%esp)
80102807:	e8 0c 23 00 00       	call   80104b18 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010280c:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102811:	85 c0                	test   %eax,%eax
80102813:	74 0d                	je     80102822 <ideintr+0xb5>
    idestart(idequeue);
80102815:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010281a:	89 04 24             	mov    %eax,(%esp)
8010281d:	e8 26 fe ff ff       	call   80102648 <idestart>

  release(&idelock);
80102822:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102829:	e8 52 25 00 00       	call   80104d80 <release>
}
8010282e:	c9                   	leave  
8010282f:	c3                   	ret    

80102830 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
80102833:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102836:	8b 45 08             	mov    0x8(%ebp),%eax
80102839:	8b 00                	mov    (%eax),%eax
8010283b:	83 e0 01             	and    $0x1,%eax
8010283e:	85 c0                	test   %eax,%eax
80102840:	75 0c                	jne    8010284e <iderw+0x1e>
    panic("iderw: buf not busy");
80102842:	c7 04 24 29 84 10 80 	movl   $0x80108429,(%esp)
80102849:	e8 f8 dc ff ff       	call   80100546 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010284e:	8b 45 08             	mov    0x8(%ebp),%eax
80102851:	8b 00                	mov    (%eax),%eax
80102853:	83 e0 06             	and    $0x6,%eax
80102856:	83 f8 02             	cmp    $0x2,%eax
80102859:	75 0c                	jne    80102867 <iderw+0x37>
    panic("iderw: nothing to do");
8010285b:	c7 04 24 3d 84 10 80 	movl   $0x8010843d,(%esp)
80102862:	e8 df dc ff ff       	call   80100546 <panic>
  if(b->dev != 0 && !havedisk1)
80102867:	8b 45 08             	mov    0x8(%ebp),%eax
8010286a:	8b 40 04             	mov    0x4(%eax),%eax
8010286d:	85 c0                	test   %eax,%eax
8010286f:	74 15                	je     80102886 <iderw+0x56>
80102871:	a1 38 b6 10 80       	mov    0x8010b638,%eax
80102876:	85 c0                	test   %eax,%eax
80102878:	75 0c                	jne    80102886 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
8010287a:	c7 04 24 52 84 10 80 	movl   $0x80108452,(%esp)
80102881:	e8 c0 dc ff ff       	call   80100546 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102886:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010288d:	e8 8d 24 00 00       	call   80104d1f <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102892:	8b 45 08             	mov    0x8(%ebp),%eax
80102895:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010289c:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
801028a3:	eb 0b                	jmp    801028b0 <iderw+0x80>
801028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028a8:	8b 00                	mov    (%eax),%eax
801028aa:	83 c0 14             	add    $0x14,%eax
801028ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b3:	8b 00                	mov    (%eax),%eax
801028b5:	85 c0                	test   %eax,%eax
801028b7:	75 ec                	jne    801028a5 <iderw+0x75>
    ;
  *pp = b;
801028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028bc:	8b 55 08             	mov    0x8(%ebp),%edx
801028bf:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801028c1:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801028c6:	3b 45 08             	cmp    0x8(%ebp),%eax
801028c9:	75 22                	jne    801028ed <iderw+0xbd>
    idestart(b);
801028cb:	8b 45 08             	mov    0x8(%ebp),%eax
801028ce:	89 04 24             	mov    %eax,(%esp)
801028d1:	e8 72 fd ff ff       	call   80102648 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028d6:	eb 15                	jmp    801028ed <iderw+0xbd>
    sleep(b, &idelock);
801028d8:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
801028df:	80 
801028e0:	8b 45 08             	mov    0x8(%ebp),%eax
801028e3:	89 04 24             	mov    %eax,(%esp)
801028e6:	e8 45 21 00 00       	call   80104a30 <sleep>
801028eb:	eb 01                	jmp    801028ee <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028ed:	90                   	nop
801028ee:	8b 45 08             	mov    0x8(%ebp),%eax
801028f1:	8b 00                	mov    (%eax),%eax
801028f3:	83 e0 06             	and    $0x6,%eax
801028f6:	83 f8 02             	cmp    $0x2,%eax
801028f9:	75 dd                	jne    801028d8 <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
801028fb:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102902:	e8 79 24 00 00       	call   80104d80 <release>
}
80102907:	c9                   	leave  
80102908:	c3                   	ret    
80102909:	66 90                	xchg   %ax,%ax
8010290b:	90                   	nop

8010290c <ioapicread>:
8010290c:	55                   	push   %ebp
8010290d:	89 e5                	mov    %esp,%ebp
8010290f:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102914:	8b 55 08             	mov    0x8(%ebp),%edx
80102917:	89 10                	mov    %edx,(%eax)
80102919:	a1 34 f8 10 80       	mov    0x8010f834,%eax
8010291e:	8b 40 10             	mov    0x10(%eax),%eax
80102921:	5d                   	pop    %ebp
80102922:	c3                   	ret    

80102923 <ioapicwrite>:
80102923:	55                   	push   %ebp
80102924:	89 e5                	mov    %esp,%ebp
80102926:	a1 34 f8 10 80       	mov    0x8010f834,%eax
8010292b:	8b 55 08             	mov    0x8(%ebp),%edx
8010292e:	89 10                	mov    %edx,(%eax)
80102930:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102935:	8b 55 0c             	mov    0xc(%ebp),%edx
80102938:	89 50 10             	mov    %edx,0x10(%eax)
8010293b:	5d                   	pop    %ebp
8010293c:	c3                   	ret    

8010293d <ioapicinit>:
8010293d:	55                   	push   %ebp
8010293e:	89 e5                	mov    %esp,%ebp
80102940:	83 ec 28             	sub    $0x28,%esp
80102943:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80102948:	85 c0                	test   %eax,%eax
8010294a:	0f 84 9f 00 00 00    	je     801029ef <ioapicinit+0xb2>
80102950:	c7 05 34 f8 10 80 00 	movl   $0xfec00000,0x8010f834
80102957:	00 c0 fe 
8010295a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102961:	e8 a6 ff ff ff       	call   8010290c <ioapicread>
80102966:	c1 e8 10             	shr    $0x10,%eax
80102969:	25 ff 00 00 00       	and    $0xff,%eax
8010296e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102971:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102978:	e8 8f ff ff ff       	call   8010290c <ioapicread>
8010297d:	c1 e8 18             	shr    $0x18,%eax
80102980:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102983:	0f b6 05 00 f9 10 80 	movzbl 0x8010f900,%eax
8010298a:	0f b6 c0             	movzbl %al,%eax
8010298d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102990:	74 0c                	je     8010299e <ioapicinit+0x61>
80102992:	c7 04 24 70 84 10 80 	movl   $0x80108470,(%esp)
80102999:	e8 0c da ff ff       	call   801003aa <cprintf>
8010299e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801029a5:	eb 3e                	jmp    801029e5 <ioapicinit+0xa8>
801029a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801029aa:	83 c0 20             	add    $0x20,%eax
801029ad:	0d 00 00 01 00       	or     $0x10000,%eax
801029b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801029b5:	83 c2 08             	add    $0x8,%edx
801029b8:	01 d2                	add    %edx,%edx
801029ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801029be:	89 14 24             	mov    %edx,(%esp)
801029c1:	e8 5d ff ff ff       	call   80102923 <ioapicwrite>
801029c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801029c9:	83 c0 08             	add    $0x8,%eax
801029cc:	01 c0                	add    %eax,%eax
801029ce:	83 c0 01             	add    $0x1,%eax
801029d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801029d8:	00 
801029d9:	89 04 24             	mov    %eax,(%esp)
801029dc:	e8 42 ff ff ff       	call   80102923 <ioapicwrite>
801029e1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801029e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801029e8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801029eb:	7e ba                	jle    801029a7 <ioapicinit+0x6a>
801029ed:	eb 01                	jmp    801029f0 <ioapicinit+0xb3>
801029ef:	90                   	nop
801029f0:	c9                   	leave  
801029f1:	c3                   	ret    

801029f2 <ioapicenable>:
801029f2:	55                   	push   %ebp
801029f3:	89 e5                	mov    %esp,%ebp
801029f5:	83 ec 08             	sub    $0x8,%esp
801029f8:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801029fd:	85 c0                	test   %eax,%eax
801029ff:	74 39                	je     80102a3a <ioapicenable+0x48>
80102a01:	8b 45 08             	mov    0x8(%ebp),%eax
80102a04:	83 c0 20             	add    $0x20,%eax
80102a07:	8b 55 08             	mov    0x8(%ebp),%edx
80102a0a:	83 c2 08             	add    $0x8,%edx
80102a0d:	01 d2                	add    %edx,%edx
80102a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a13:	89 14 24             	mov    %edx,(%esp)
80102a16:	e8 08 ff ff ff       	call   80102923 <ioapicwrite>
80102a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a1e:	c1 e0 18             	shl    $0x18,%eax
80102a21:	8b 55 08             	mov    0x8(%ebp),%edx
80102a24:	83 c2 08             	add    $0x8,%edx
80102a27:	01 d2                	add    %edx,%edx
80102a29:	83 c2 01             	add    $0x1,%edx
80102a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a30:	89 14 24             	mov    %edx,(%esp)
80102a33:	e8 eb fe ff ff       	call   80102923 <ioapicwrite>
80102a38:	eb 01                	jmp    80102a3b <ioapicenable+0x49>
80102a3a:	90                   	nop
80102a3b:	c9                   	leave  
80102a3c:	c3                   	ret    
80102a3d:	66 90                	xchg   %ax,%ax
80102a3f:	90                   	nop

80102a40 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a40:	55                   	push   %ebp
80102a41:	89 e5                	mov    %esp,%ebp
80102a43:	8b 45 08             	mov    0x8(%ebp),%eax
80102a46:	05 00 00 00 80       	add    $0x80000000,%eax
80102a4b:	5d                   	pop    %ebp
80102a4c:	c3                   	ret    

80102a4d <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a4d:	55                   	push   %ebp
80102a4e:	89 e5                	mov    %esp,%ebp
80102a50:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a53:	c7 44 24 04 a2 84 10 	movl   $0x801084a2,0x4(%esp)
80102a5a:	80 
80102a5b:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102a62:	e8 97 22 00 00       	call   80104cfe <initlock>
  kmem.use_lock = 0;
80102a67:	c7 05 74 f8 10 80 00 	movl   $0x0,0x8010f874
80102a6e:	00 00 00 
  freerange(vstart, vend);
80102a71:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a74:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a78:	8b 45 08             	mov    0x8(%ebp),%eax
80102a7b:	89 04 24             	mov    %eax,(%esp)
80102a7e:	e8 26 00 00 00       	call   80102aa9 <freerange>
}
80102a83:	c9                   	leave  
80102a84:	c3                   	ret    

80102a85 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a85:	55                   	push   %ebp
80102a86:	89 e5                	mov    %esp,%ebp
80102a88:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a92:	8b 45 08             	mov    0x8(%ebp),%eax
80102a95:	89 04 24             	mov    %eax,(%esp)
80102a98:	e8 0c 00 00 00       	call   80102aa9 <freerange>
  kmem.use_lock = 1;
80102a9d:	c7 05 74 f8 10 80 01 	movl   $0x1,0x8010f874
80102aa4:	00 00 00 
}
80102aa7:	c9                   	leave  
80102aa8:	c3                   	ret    

80102aa9 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102aa9:	55                   	push   %ebp
80102aaa:	89 e5                	mov    %esp,%ebp
80102aac:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab2:	05 ff 0f 00 00       	add    $0xfff,%eax
80102ab7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102abf:	eb 12                	jmp    80102ad3 <freerange+0x2a>
    kfree(p);
80102ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac4:	89 04 24             	mov    %eax,(%esp)
80102ac7:	e8 16 00 00 00       	call   80102ae2 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102acc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad6:	05 00 10 00 00       	add    $0x1000,%eax
80102adb:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102ade:	76 e1                	jbe    80102ac1 <freerange+0x18>
    kfree(p);
}
80102ae0:	c9                   	leave  
80102ae1:	c3                   	ret    

80102ae2 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102ae2:	55                   	push   %ebp
80102ae3:	89 e5                	mov    %esp,%ebp
80102ae5:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80102aeb:	25 ff 0f 00 00       	and    $0xfff,%eax
80102af0:	85 c0                	test   %eax,%eax
80102af2:	75 1b                	jne    80102b0f <kfree+0x2d>
80102af4:	81 7d 08 bc 2a 11 80 	cmpl   $0x80112abc,0x8(%ebp)
80102afb:	72 12                	jb     80102b0f <kfree+0x2d>
80102afd:	8b 45 08             	mov    0x8(%ebp),%eax
80102b00:	89 04 24             	mov    %eax,(%esp)
80102b03:	e8 38 ff ff ff       	call   80102a40 <v2p>
80102b08:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b0d:	76 0c                	jbe    80102b1b <kfree+0x39>
    panic("kfree");
80102b0f:	c7 04 24 a7 84 10 80 	movl   $0x801084a7,(%esp)
80102b16:	e8 2b da ff ff       	call   80100546 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b1b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102b22:	00 
80102b23:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b2a:	00 
80102b2b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b2e:	89 04 24             	mov    %eax,(%esp)
80102b31:	e8 38 24 00 00       	call   80104f6e <memset>

  if(kmem.use_lock)
80102b36:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b3b:	85 c0                	test   %eax,%eax
80102b3d:	74 0c                	je     80102b4b <kfree+0x69>
    acquire(&kmem.lock);
80102b3f:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b46:	e8 d4 21 00 00       	call   80104d1f <acquire>
  r = (struct run*)v;
80102b4b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b51:	8b 15 78 f8 10 80    	mov    0x8010f878,%edx
80102b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b5a:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b5f:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102b64:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b69:	85 c0                	test   %eax,%eax
80102b6b:	74 0c                	je     80102b79 <kfree+0x97>
    release(&kmem.lock);
80102b6d:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b74:	e8 07 22 00 00       	call   80104d80 <release>
}
80102b79:	c9                   	leave  
80102b7a:	c3                   	ret    

80102b7b <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b7b:	55                   	push   %ebp
80102b7c:	89 e5                	mov    %esp,%ebp
80102b7e:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b81:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b86:	85 c0                	test   %eax,%eax
80102b88:	74 0c                	je     80102b96 <kalloc+0x1b>
    acquire(&kmem.lock);
80102b8a:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b91:	e8 89 21 00 00       	call   80104d1f <acquire>
  r = kmem.freelist;
80102b96:	a1 78 f8 10 80       	mov    0x8010f878,%eax
80102b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102ba2:	74 0a                	je     80102bae <kalloc+0x33>
    kmem.freelist = r->next;
80102ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba7:	8b 00                	mov    (%eax),%eax
80102ba9:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102bae:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102bb3:	85 c0                	test   %eax,%eax
80102bb5:	74 0c                	je     80102bc3 <kalloc+0x48>
    release(&kmem.lock);
80102bb7:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102bbe:	e8 bd 21 00 00       	call   80104d80 <release>
  return (char*)r;
80102bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102bc6:	c9                   	leave  
80102bc7:	c3                   	ret    

80102bc8 <inb>:
80102bc8:	55                   	push   %ebp
80102bc9:	89 e5                	mov    %esp,%ebp
80102bcb:	83 ec 14             	sub    $0x14,%esp
80102bce:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
80102bd5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102bd9:	89 c2                	mov    %eax,%edx
80102bdb:	ec                   	in     (%dx),%al
80102bdc:	88 45 ff             	mov    %al,-0x1(%ebp)
80102bdf:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
80102be3:	c9                   	leave  
80102be4:	c3                   	ret    

80102be5 <kbdgetc>:
80102be5:	55                   	push   %ebp
80102be6:	89 e5                	mov    %esp,%ebp
80102be8:	83 ec 14             	sub    $0x14,%esp
80102beb:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102bf2:	e8 d1 ff ff ff       	call   80102bc8 <inb>
80102bf7:	0f b6 c0             	movzbl %al,%eax
80102bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c00:	83 e0 01             	and    $0x1,%eax
80102c03:	85 c0                	test   %eax,%eax
80102c05:	75 0a                	jne    80102c11 <kbdgetc+0x2c>
80102c07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c0c:	e9 20 01 00 00       	jmp    80102d31 <kbdgetc+0x14c>
80102c11:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c18:	e8 ab ff ff ff       	call   80102bc8 <inb>
80102c1d:	0f b6 c0             	movzbl %al,%eax
80102c20:	89 45 f8             	mov    %eax,-0x8(%ebp)
80102c23:	81 7d f8 e0 00 00 00 	cmpl   $0xe0,-0x8(%ebp)
80102c2a:	75 17                	jne    80102c43 <kbdgetc+0x5e>
80102c2c:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c31:	83 c8 40             	or     $0x40,%eax
80102c34:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
80102c39:	b8 00 00 00 00       	mov    $0x0,%eax
80102c3e:	e9 ee 00 00 00       	jmp    80102d31 <kbdgetc+0x14c>
80102c43:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c46:	25 80 00 00 00       	and    $0x80,%eax
80102c4b:	85 c0                	test   %eax,%eax
80102c4d:	74 44                	je     80102c93 <kbdgetc+0xae>
80102c4f:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c54:	83 e0 40             	and    $0x40,%eax
80102c57:	85 c0                	test   %eax,%eax
80102c59:	75 08                	jne    80102c63 <kbdgetc+0x7e>
80102c5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c5e:	83 e0 7f             	and    $0x7f,%eax
80102c61:	eb 03                	jmp    80102c66 <kbdgetc+0x81>
80102c63:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
80102c69:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c6c:	0f b6 80 20 90 10 80 	movzbl -0x7fef6fe0(%eax),%eax
80102c73:	83 c8 40             	or     $0x40,%eax
80102c76:	0f b6 c0             	movzbl %al,%eax
80102c79:	f7 d0                	not    %eax
80102c7b:	89 c2                	mov    %eax,%edx
80102c7d:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c82:	21 d0                	and    %edx,%eax
80102c84:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
80102c89:	b8 00 00 00 00       	mov    $0x0,%eax
80102c8e:	e9 9e 00 00 00       	jmp    80102d31 <kbdgetc+0x14c>
80102c93:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c98:	83 e0 40             	and    $0x40,%eax
80102c9b:	85 c0                	test   %eax,%eax
80102c9d:	74 14                	je     80102cb3 <kbdgetc+0xce>
80102c9f:	81 4d f8 80 00 00 00 	orl    $0x80,-0x8(%ebp)
80102ca6:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cab:	83 e0 bf             	and    $0xffffffbf,%eax
80102cae:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
80102cb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102cb6:	0f b6 80 20 90 10 80 	movzbl -0x7fef6fe0(%eax),%eax
80102cbd:	0f b6 d0             	movzbl %al,%edx
80102cc0:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cc5:	09 d0                	or     %edx,%eax
80102cc7:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
80102ccc:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102ccf:	0f b6 80 20 91 10 80 	movzbl -0x7fef6ee0(%eax),%eax
80102cd6:	0f b6 d0             	movzbl %al,%edx
80102cd9:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cde:	31 d0                	xor    %edx,%eax
80102ce0:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
80102ce5:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cea:	83 e0 03             	and    $0x3,%eax
80102ced:	8b 04 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%eax
80102cf4:	03 45 f8             	add    -0x8(%ebp),%eax
80102cf7:	0f b6 00             	movzbl (%eax),%eax
80102cfa:	0f b6 c0             	movzbl %al,%eax
80102cfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102d00:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d05:	83 e0 08             	and    $0x8,%eax
80102d08:	85 c0                	test   %eax,%eax
80102d0a:	74 22                	je     80102d2e <kbdgetc+0x149>
80102d0c:	83 7d fc 60          	cmpl   $0x60,-0x4(%ebp)
80102d10:	76 0c                	jbe    80102d1e <kbdgetc+0x139>
80102d12:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%ebp)
80102d16:	77 06                	ja     80102d1e <kbdgetc+0x139>
80102d18:	83 6d fc 20          	subl   $0x20,-0x4(%ebp)
80102d1c:	eb 10                	jmp    80102d2e <kbdgetc+0x149>
80102d1e:	83 7d fc 40          	cmpl   $0x40,-0x4(%ebp)
80102d22:	76 0a                	jbe    80102d2e <kbdgetc+0x149>
80102d24:	83 7d fc 5a          	cmpl   $0x5a,-0x4(%ebp)
80102d28:	77 04                	ja     80102d2e <kbdgetc+0x149>
80102d2a:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
80102d2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d31:	c9                   	leave  
80102d32:	c3                   	ret    

80102d33 <kbdintr>:
80102d33:	55                   	push   %ebp
80102d34:	89 e5                	mov    %esp,%ebp
80102d36:	83 ec 18             	sub    $0x18,%esp
80102d39:	c7 04 24 e5 2b 10 80 	movl   $0x80102be5,(%esp)
80102d40:	e8 71 da ff ff       	call   801007b6 <consoleintr>
80102d45:	c9                   	leave  
80102d46:	c3                   	ret    
80102d47:	90                   	nop

80102d48 <outb>:
80102d48:	55                   	push   %ebp
80102d49:	89 e5                	mov    %esp,%ebp
80102d4b:	83 ec 08             	sub    $0x8,%esp
80102d4e:	8b 55 08             	mov    0x8(%ebp),%edx
80102d51:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d54:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102d58:	88 45 f8             	mov    %al,-0x8(%ebp)
80102d5b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102d5f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102d63:	ee                   	out    %al,(%dx)
80102d64:	c9                   	leave  
80102d65:	c3                   	ret    

80102d66 <readeflags>:
80102d66:	55                   	push   %ebp
80102d67:	89 e5                	mov    %esp,%ebp
80102d69:	83 ec 10             	sub    $0x10,%esp
80102d6c:	9c                   	pushf  
80102d6d:	58                   	pop    %eax
80102d6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d74:	c9                   	leave  
80102d75:	c3                   	ret    

80102d76 <lapicw>:
80102d76:	55                   	push   %ebp
80102d77:	89 e5                	mov    %esp,%ebp
80102d79:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d7e:	8b 55 08             	mov    0x8(%ebp),%edx
80102d81:	c1 e2 02             	shl    $0x2,%edx
80102d84:	8d 14 10             	lea    (%eax,%edx,1),%edx
80102d87:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d8a:	89 02                	mov    %eax,(%edx)
80102d8c:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d91:	83 c0 20             	add    $0x20,%eax
80102d94:	8b 00                	mov    (%eax),%eax
80102d96:	5d                   	pop    %ebp
80102d97:	c3                   	ret    

80102d98 <lapicinit>:
80102d98:	55                   	push   %ebp
80102d99:	89 e5                	mov    %esp,%ebp
80102d9b:	83 ec 08             	sub    $0x8,%esp
80102d9e:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102da3:	85 c0                	test   %eax,%eax
80102da5:	0f 84 46 01 00 00    	je     80102ef1 <lapicinit+0x159>
80102dab:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102db2:	00 
80102db3:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102dba:	e8 b7 ff ff ff       	call   80102d76 <lapicw>
80102dbf:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102dc6:	00 
80102dc7:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102dce:	e8 a3 ff ff ff       	call   80102d76 <lapicw>
80102dd3:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102dda:	00 
80102ddb:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102de2:	e8 8f ff ff ff       	call   80102d76 <lapicw>
80102de7:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102dee:	00 
80102def:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102df6:	e8 7b ff ff ff       	call   80102d76 <lapicw>
80102dfb:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e02:	00 
80102e03:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e0a:	e8 67 ff ff ff       	call   80102d76 <lapicw>
80102e0f:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e16:	00 
80102e17:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e1e:	e8 53 ff ff ff       	call   80102d76 <lapicw>
80102e23:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e28:	83 c0 30             	add    $0x30,%eax
80102e2b:	8b 00                	mov    (%eax),%eax
80102e2d:	c1 e8 10             	shr    $0x10,%eax
80102e30:	25 ff 00 00 00       	and    $0xff,%eax
80102e35:	83 f8 03             	cmp    $0x3,%eax
80102e38:	76 14                	jbe    80102e4e <lapicinit+0xb6>
80102e3a:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e41:	00 
80102e42:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e49:	e8 28 ff ff ff       	call   80102d76 <lapicw>
80102e4e:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e55:	00 
80102e56:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e5d:	e8 14 ff ff ff       	call   80102d76 <lapicw>
80102e62:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e69:	00 
80102e6a:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e71:	e8 00 ff ff ff       	call   80102d76 <lapicw>
80102e76:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e7d:	00 
80102e7e:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e85:	e8 ec fe ff ff       	call   80102d76 <lapicw>
80102e8a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e91:	00 
80102e92:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e99:	e8 d8 fe ff ff       	call   80102d76 <lapicw>
80102e9e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ea5:	00 
80102ea6:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102ead:	e8 c4 fe ff ff       	call   80102d76 <lapicw>
80102eb2:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102eb9:	00 
80102eba:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102ec1:	e8 b0 fe ff ff       	call   80102d76 <lapicw>
80102ec6:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ecb:	05 00 03 00 00       	add    $0x300,%eax
80102ed0:	8b 00                	mov    (%eax),%eax
80102ed2:	25 00 10 00 00       	and    $0x1000,%eax
80102ed7:	85 c0                	test   %eax,%eax
80102ed9:	75 eb                	jne    80102ec6 <lapicinit+0x12e>
80102edb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ee2:	00 
80102ee3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102eea:	e8 87 fe ff ff       	call   80102d76 <lapicw>
80102eef:	eb 01                	jmp    80102ef2 <lapicinit+0x15a>
80102ef1:	90                   	nop
80102ef2:	c9                   	leave  
80102ef3:	c3                   	ret    

80102ef4 <cpunum>:
80102ef4:	55                   	push   %ebp
80102ef5:	89 e5                	mov    %esp,%ebp
80102ef7:	83 ec 18             	sub    $0x18,%esp
80102efa:	e8 67 fe ff ff       	call   80102d66 <readeflags>
80102eff:	25 00 02 00 00       	and    $0x200,%eax
80102f04:	85 c0                	test   %eax,%eax
80102f06:	74 29                	je     80102f31 <cpunum+0x3d>
80102f08:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102f0d:	85 c0                	test   %eax,%eax
80102f0f:	0f 94 c2             	sete   %dl
80102f12:	83 c0 01             	add    $0x1,%eax
80102f15:	a3 40 b6 10 80       	mov    %eax,0x8010b640
80102f1a:	84 d2                	test   %dl,%dl
80102f1c:	74 13                	je     80102f31 <cpunum+0x3d>
80102f1e:	8b 45 04             	mov    0x4(%ebp),%eax
80102f21:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f25:	c7 04 24 b0 84 10 80 	movl   $0x801084b0,(%esp)
80102f2c:	e8 79 d4 ff ff       	call   801003aa <cprintf>
80102f31:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102f36:	85 c0                	test   %eax,%eax
80102f38:	74 0f                	je     80102f49 <cpunum+0x55>
80102f3a:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102f3f:	83 c0 20             	add    $0x20,%eax
80102f42:	8b 00                	mov    (%eax),%eax
80102f44:	c1 e8 18             	shr    $0x18,%eax
80102f47:	eb 05                	jmp    80102f4e <cpunum+0x5a>
80102f49:	b8 00 00 00 00       	mov    $0x0,%eax
80102f4e:	c9                   	leave  
80102f4f:	c3                   	ret    

80102f50 <lapiceoi>:
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	83 ec 08             	sub    $0x8,%esp
80102f56:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102f5b:	85 c0                	test   %eax,%eax
80102f5d:	74 14                	je     80102f73 <lapiceoi+0x23>
80102f5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f66:	00 
80102f67:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f6e:	e8 03 fe ff ff       	call   80102d76 <lapicw>
80102f73:	c9                   	leave  
80102f74:	c3                   	ret    

80102f75 <microdelay>:
80102f75:	55                   	push   %ebp
80102f76:	89 e5                	mov    %esp,%ebp
80102f78:	5d                   	pop    %ebp
80102f79:	c3                   	ret    

80102f7a <lapicstartap>:
80102f7a:	55                   	push   %ebp
80102f7b:	89 e5                	mov    %esp,%ebp
80102f7d:	83 ec 1c             	sub    $0x1c,%esp
80102f80:	8b 45 08             	mov    0x8(%ebp),%eax
80102f83:	88 45 ec             	mov    %al,-0x14(%ebp)
80102f86:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f8d:	00 
80102f8e:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f95:	e8 ae fd ff ff       	call   80102d48 <outb>
80102f9a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102fa1:	00 
80102fa2:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102fa9:	e8 9a fd ff ff       	call   80102d48 <outb>
80102fae:	c7 45 fc 67 04 00 80 	movl   $0x80000467,-0x4(%ebp)
80102fb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102fb8:	66 c7 00 00 00       	movw   $0x0,(%eax)
80102fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102fc0:	8d 50 02             	lea    0x2(%eax),%edx
80102fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fc6:	c1 e8 04             	shr    $0x4,%eax
80102fc9:	66 89 02             	mov    %ax,(%edx)
80102fcc:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fd0:	c1 e0 18             	shl    $0x18,%eax
80102fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fd7:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fde:	e8 93 fd ff ff       	call   80102d76 <lapicw>
80102fe3:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102fea:	00 
80102feb:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102ff2:	e8 7f fd ff ff       	call   80102d76 <lapicw>
80102ff7:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102ffe:	e8 72 ff ff ff       	call   80102f75 <microdelay>
80103003:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
8010300a:	00 
8010300b:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103012:	e8 5f fd ff ff       	call   80102d76 <lapicw>
80103017:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
8010301e:	e8 52 ff ff ff       	call   80102f75 <microdelay>
80103023:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010302a:	eb 40                	jmp    8010306c <lapicstartap+0xf2>
8010302c:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103030:	c1 e0 18             	shl    $0x18,%eax
80103033:	89 44 24 04          	mov    %eax,0x4(%esp)
80103037:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010303e:	e8 33 fd ff ff       	call   80102d76 <lapicw>
80103043:	8b 45 0c             	mov    0xc(%ebp),%eax
80103046:	c1 e8 0c             	shr    $0xc,%eax
80103049:	80 cc 06             	or     $0x6,%ah
8010304c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103050:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103057:	e8 1a fd ff ff       	call   80102d76 <lapicw>
8010305c:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103063:	e8 0d ff ff ff       	call   80102f75 <microdelay>
80103068:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010306c:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
80103070:	7e ba                	jle    8010302c <lapicstartap+0xb2>
80103072:	c9                   	leave  
80103073:	c3                   	ret    

80103074 <initlog>:
80103074:	55                   	push   %ebp
80103075:	89 e5                	mov    %esp,%ebp
80103077:	83 ec 28             	sub    $0x28,%esp
8010307a:	90                   	nop
8010307b:	c7 44 24 04 dc 84 10 	movl   $0x801084dc,0x4(%esp)
80103082:	80 
80103083:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010308a:	e8 6f 1c 00 00       	call   80104cfe <initlock>
8010308f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103092:	89 44 24 04          	mov    %eax,0x4(%esp)
80103096:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010309d:	e8 a2 e2 ff ff       	call   80101344 <readsb>
801030a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
801030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030a8:	89 d1                	mov    %edx,%ecx
801030aa:	29 c1                	sub    %eax,%ecx
801030ac:	89 c8                	mov    %ecx,%eax
801030ae:	a3 b4 f8 10 80       	mov    %eax,0x8010f8b4
801030b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030b6:	a3 b8 f8 10 80       	mov    %eax,0x8010f8b8
801030bb:	c7 05 c0 f8 10 80 01 	movl   $0x1,0x8010f8c0
801030c2:	00 00 00 
801030c5:	e8 97 01 00 00       	call   80103261 <recover_from_log>
801030ca:	c9                   	leave  
801030cb:	c3                   	ret    

801030cc <install_trans>:
801030cc:	55                   	push   %ebp
801030cd:	89 e5                	mov    %esp,%ebp
801030cf:	83 ec 28             	sub    $0x28,%esp
801030d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801030d9:	e9 89 00 00 00       	jmp    80103167 <install_trans+0x9b>
801030de:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
801030e3:	03 45 ec             	add    -0x14(%ebp),%eax
801030e6:	83 c0 01             	add    $0x1,%eax
801030e9:	89 c2                	mov    %eax,%edx
801030eb:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801030f0:	89 54 24 04          	mov    %edx,0x4(%esp)
801030f4:	89 04 24             	mov    %eax,(%esp)
801030f7:	e8 aa d0 ff ff       	call   801001a6 <bread>
801030fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801030ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103102:	83 c0 10             	add    $0x10,%eax
80103105:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
8010310c:	89 c2                	mov    %eax,%edx
8010310e:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103113:	89 54 24 04          	mov    %edx,0x4(%esp)
80103117:	89 04 24             	mov    %eax,(%esp)
8010311a:	e8 87 d0 ff ff       	call   801001a6 <bread>
8010311f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103122:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103125:	8d 50 18             	lea    0x18(%eax),%edx
80103128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010312b:	83 c0 18             	add    $0x18,%eax
8010312e:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103135:	00 
80103136:	89 54 24 04          	mov    %edx,0x4(%esp)
8010313a:	89 04 24             	mov    %eax,(%esp)
8010313d:	e8 ff 1e 00 00       	call   80105041 <memmove>
80103142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103145:	89 04 24             	mov    %eax,(%esp)
80103148:	e8 90 d0 ff ff       	call   801001dd <bwrite>
8010314d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103150:	89 04 24             	mov    %eax,(%esp)
80103153:	e8 bf d0 ff ff       	call   80100217 <brelse>
80103158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010315b:	89 04 24             	mov    %eax,(%esp)
8010315e:	e8 b4 d0 ff ff       	call   80100217 <brelse>
80103163:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80103167:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010316c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010316f:	0f 8f 69 ff ff ff    	jg     801030de <install_trans+0x12>
80103175:	c9                   	leave  
80103176:	c3                   	ret    

80103177 <read_head>:
80103177:	55                   	push   %ebp
80103178:	89 e5                	mov    %esp,%ebp
8010317a:	83 ec 28             	sub    $0x28,%esp
8010317d:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
80103182:	89 c2                	mov    %eax,%edx
80103184:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103189:	89 54 24 04          	mov    %edx,0x4(%esp)
8010318d:	89 04 24             	mov    %eax,(%esp)
80103190:	e8 11 d0 ff ff       	call   801001a6 <bread>
80103195:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103198:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010319b:	83 c0 18             	add    $0x18,%eax
8010319e:	89 45 f0             	mov    %eax,-0x10(%ebp)
801031a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031a4:	8b 00                	mov    (%eax),%eax
801031a6:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
801031ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031b2:	eb 1b                	jmp    801031cf <read_head+0x58>
801031b4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801031b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031bd:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801031c1:	8d 51 10             	lea    0x10(%ecx),%edx
801031c4:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
801031cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031cf:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801031d4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031d7:	7f db                	jg     801031b4 <read_head+0x3d>
801031d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031dc:	89 04 24             	mov    %eax,(%esp)
801031df:	e8 33 d0 ff ff       	call   80100217 <brelse>
801031e4:	c9                   	leave  
801031e5:	c3                   	ret    

801031e6 <write_head>:
801031e6:	55                   	push   %ebp
801031e7:	89 e5                	mov    %esp,%ebp
801031e9:	83 ec 28             	sub    $0x28,%esp
801031ec:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
801031f1:	89 c2                	mov    %eax,%edx
801031f3:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801031f8:	89 54 24 04          	mov    %edx,0x4(%esp)
801031fc:	89 04 24             	mov    %eax,(%esp)
801031ff:	e8 a2 cf ff ff       	call   801001a6 <bread>
80103204:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103207:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010320a:	83 c0 18             	add    $0x18,%eax
8010320d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103210:	8b 15 c4 f8 10 80    	mov    0x8010f8c4,%edx
80103216:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103219:	89 10                	mov    %edx,(%eax)
8010321b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103222:	eb 1b                	jmp    8010323f <write_head+0x59>
80103224:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103227:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010322a:	83 c0 10             	add    $0x10,%eax
8010322d:	8b 0c 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%ecx
80103234:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103237:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
8010323b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010323f:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103244:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103247:	7f db                	jg     80103224 <write_head+0x3e>
80103249:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010324c:	89 04 24             	mov    %eax,(%esp)
8010324f:	e8 89 cf ff ff       	call   801001dd <bwrite>
80103254:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103257:	89 04 24             	mov    %eax,(%esp)
8010325a:	e8 b8 cf ff ff       	call   80100217 <brelse>
8010325f:	c9                   	leave  
80103260:	c3                   	ret    

80103261 <recover_from_log>:
80103261:	55                   	push   %ebp
80103262:	89 e5                	mov    %esp,%ebp
80103264:	83 ec 08             	sub    $0x8,%esp
80103267:	e8 0b ff ff ff       	call   80103177 <read_head>
8010326c:	e8 5b fe ff ff       	call   801030cc <install_trans>
80103271:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
80103278:	00 00 00 
8010327b:	e8 66 ff ff ff       	call   801031e6 <write_head>
80103280:	c9                   	leave  
80103281:	c3                   	ret    

80103282 <begin_trans>:
80103282:	55                   	push   %ebp
80103283:	89 e5                	mov    %esp,%ebp
80103285:	83 ec 18             	sub    $0x18,%esp
80103288:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010328f:	e8 8b 1a 00 00       	call   80104d1f <acquire>
80103294:	eb 14                	jmp    801032aa <begin_trans+0x28>
80103296:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
8010329d:	80 
8010329e:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801032a5:	e8 86 17 00 00       	call   80104a30 <sleep>
801032aa:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
801032af:	85 c0                	test   %eax,%eax
801032b1:	75 e3                	jne    80103296 <begin_trans+0x14>
801032b3:	c7 05 bc f8 10 80 01 	movl   $0x1,0x8010f8bc
801032ba:	00 00 00 
801032bd:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801032c4:	e8 b7 1a 00 00       	call   80104d80 <release>
801032c9:	c9                   	leave  
801032ca:	c3                   	ret    

801032cb <commit_trans>:
801032cb:	55                   	push   %ebp
801032cc:	89 e5                	mov    %esp,%ebp
801032ce:	83 ec 18             	sub    $0x18,%esp
801032d1:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032d6:	85 c0                	test   %eax,%eax
801032d8:	7e 19                	jle    801032f3 <commit_trans+0x28>
801032da:	e8 07 ff ff ff       	call   801031e6 <write_head>
801032df:	e8 e8 fd ff ff       	call   801030cc <install_trans>
801032e4:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
801032eb:	00 00 00 
801032ee:	e8 f3 fe ff ff       	call   801031e6 <write_head>
801032f3:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801032fa:	e8 20 1a 00 00       	call   80104d1f <acquire>
801032ff:	c7 05 bc f8 10 80 00 	movl   $0x0,0x8010f8bc
80103306:	00 00 00 
80103309:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103310:	e8 03 18 00 00       	call   80104b18 <wakeup>
80103315:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010331c:	e8 5f 1a 00 00       	call   80104d80 <release>
80103321:	c9                   	leave  
80103322:	c3                   	ret    

80103323 <log_write>:
80103323:	55                   	push   %ebp
80103324:	89 e5                	mov    %esp,%ebp
80103326:	83 ec 28             	sub    $0x28,%esp
80103329:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010332e:	83 f8 09             	cmp    $0x9,%eax
80103331:	7f 12                	jg     80103345 <log_write+0x22>
80103333:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103338:	8b 15 b8 f8 10 80    	mov    0x8010f8b8,%edx
8010333e:	83 ea 01             	sub    $0x1,%edx
80103341:	39 d0                	cmp    %edx,%eax
80103343:	7c 0c                	jl     80103351 <log_write+0x2e>
80103345:	c7 04 24 e0 84 10 80 	movl   $0x801084e0,(%esp)
8010334c:	e8 f5 d1 ff ff       	call   80100546 <panic>
80103351:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
80103356:	85 c0                	test   %eax,%eax
80103358:	75 0c                	jne    80103366 <log_write+0x43>
8010335a:	c7 04 24 f6 84 10 80 	movl   $0x801084f6,(%esp)
80103361:	e8 e0 d1 ff ff       	call   80100546 <panic>
80103366:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010336d:	eb 1d                	jmp    8010338c <log_write+0x69>
8010336f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103372:	83 c0 10             	add    $0x10,%eax
80103375:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
8010337c:	89 c2                	mov    %eax,%edx
8010337e:	8b 45 08             	mov    0x8(%ebp),%eax
80103381:	8b 40 08             	mov    0x8(%eax),%eax
80103384:	39 c2                	cmp    %eax,%edx
80103386:	74 10                	je     80103398 <log_write+0x75>
80103388:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010338c:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103391:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103394:	7f d9                	jg     8010336f <log_write+0x4c>
80103396:	eb 01                	jmp    80103399 <log_write+0x76>
80103398:	90                   	nop
80103399:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010339c:	8b 45 08             	mov    0x8(%ebp),%eax
8010339f:	8b 40 08             	mov    0x8(%eax),%eax
801033a2:	83 c2 10             	add    $0x10,%edx
801033a5:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
801033ac:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
801033b1:	03 45 f0             	add    -0x10(%ebp),%eax
801033b4:	83 c0 01             	add    $0x1,%eax
801033b7:	89 c2                	mov    %eax,%edx
801033b9:	8b 45 08             	mov    0x8(%ebp),%eax
801033bc:	8b 40 04             	mov    0x4(%eax),%eax
801033bf:	89 54 24 04          	mov    %edx,0x4(%esp)
801033c3:	89 04 24             	mov    %eax,(%esp)
801033c6:	e8 db cd ff ff       	call   801001a6 <bread>
801033cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801033ce:	8b 45 08             	mov    0x8(%ebp),%eax
801033d1:	8d 50 18             	lea    0x18(%eax),%edx
801033d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033d7:	83 c0 18             	add    $0x18,%eax
801033da:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801033e1:	00 
801033e2:	89 54 24 04          	mov    %edx,0x4(%esp)
801033e6:	89 04 24             	mov    %eax,(%esp)
801033e9:	e8 53 1c 00 00       	call   80105041 <memmove>
801033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033f1:	89 04 24             	mov    %eax,(%esp)
801033f4:	e8 e4 cd ff ff       	call   801001dd <bwrite>
801033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033fc:	89 04 24             	mov    %eax,(%esp)
801033ff:	e8 13 ce ff ff       	call   80100217 <brelse>
80103404:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103409:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010340c:	75 0d                	jne    8010341b <log_write+0xf8>
8010340e:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103413:	83 c0 01             	add    $0x1,%eax
80103416:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
8010341b:	8b 45 08             	mov    0x8(%ebp),%eax
8010341e:	8b 00                	mov    (%eax),%eax
80103420:	89 c2                	mov    %eax,%edx
80103422:	83 ca 04             	or     $0x4,%edx
80103425:	8b 45 08             	mov    0x8(%ebp),%eax
80103428:	89 10                	mov    %edx,(%eax)
8010342a:	c9                   	leave  
8010342b:	c3                   	ret    

8010342c <v2p>:
8010342c:	55                   	push   %ebp
8010342d:	89 e5                	mov    %esp,%ebp
8010342f:	8b 45 08             	mov    0x8(%ebp),%eax
80103432:	2d 00 00 00 80       	sub    $0x80000000,%eax
80103437:	5d                   	pop    %ebp
80103438:	c3                   	ret    

80103439 <p2v>:
80103439:	55                   	push   %ebp
8010343a:	89 e5                	mov    %esp,%ebp
8010343c:	8b 45 08             	mov    0x8(%ebp),%eax
8010343f:	2d 00 00 00 80       	sub    $0x80000000,%eax
80103444:	5d                   	pop    %ebp
80103445:	c3                   	ret    

80103446 <xchg>:
80103446:	55                   	push   %ebp
80103447:	89 e5                	mov    %esp,%ebp
80103449:	83 ec 10             	sub    $0x10,%esp
8010344c:	8b 55 08             	mov    0x8(%ebp),%edx
8010344f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103452:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103455:	f0 87 02             	lock xchg %eax,(%edx)
80103458:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010345b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010345e:	c9                   	leave  
8010345f:	c3                   	ret    

80103460 <main>:
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	83 e4 f0             	and    $0xfffffff0,%esp
80103466:	83 ec 10             	sub    $0x10,%esp
80103469:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103470:	80 
80103471:	c7 04 24 bc 2a 11 80 	movl   $0x80112abc,(%esp)
80103478:	e8 d0 f5 ff ff       	call   80102a4d <kinit1>
8010347d:	e8 a5 46 00 00       	call   80107b27 <kvmalloc>
80103482:	e8 49 04 00 00       	call   801038d0 <mpinit>
80103487:	e8 0c f9 ff ff       	call   80102d98 <lapicinit>
8010348c:	e8 38 40 00 00       	call   801074c9 <seginit>
80103491:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103497:	0f b6 00             	movzbl (%eax),%eax
8010349a:	0f b6 c0             	movzbl %al,%eax
8010349d:	89 44 24 04          	mov    %eax,0x4(%esp)
801034a1:	c7 04 24 0d 85 10 80 	movl   $0x8010850d,(%esp)
801034a8:	e8 fd ce ff ff       	call   801003aa <cprintf>
801034ad:	e8 84 06 00 00       	call   80103b36 <picinit>
801034b2:	e8 86 f4 ff ff       	call   8010293d <ioapicinit>
801034b7:	e8 dc d5 ff ff       	call   80100a98 <consoleinit>
801034bc:	e8 53 33 00 00       	call   80106814 <uartinit>
801034c1:	e8 80 0b 00 00       	call   80104046 <pinit>
801034c6:	e8 97 0b 00 00       	call   80104062 <rqinit>
801034cb:	e8 ea 2e 00 00       	call   801063ba <tvinit>
801034d0:	e8 5f cb ff ff       	call   80100034 <binit>
801034d5:	e8 7e da ff ff       	call   80100f58 <fileinit>
801034da:	e8 2e e1 ff ff       	call   8010160d <iinit>
801034df:	e8 be f0 ff ff       	call   801025a2 <ideinit>
801034e4:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801034e9:	85 c0                	test   %eax,%eax
801034eb:	75 05                	jne    801034f2 <main+0x92>
801034ed:	e8 10 2e 00 00       	call   80106302 <timerinit>
801034f2:	e8 7f 00 00 00       	call   80103576 <startothers>
801034f7:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801034fe:	8e 
801034ff:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103506:	e8 7a f5 ff ff       	call   80102a85 <kinit2>
8010350b:	e8 8d 0d 00 00       	call   8010429d <userinit>
80103510:	e8 1a 00 00 00       	call   8010352f <mpmain>

80103515 <mpenter>:
80103515:	55                   	push   %ebp
80103516:	89 e5                	mov    %esp,%ebp
80103518:	83 ec 08             	sub    $0x8,%esp
8010351b:	e8 1e 46 00 00       	call   80107b3e <switchkvm>
80103520:	e8 a4 3f 00 00       	call   801074c9 <seginit>
80103525:	e8 6e f8 ff ff       	call   80102d98 <lapicinit>
8010352a:	e8 00 00 00 00       	call   8010352f <mpmain>

8010352f <mpmain>:
8010352f:	55                   	push   %ebp
80103530:	89 e5                	mov    %esp,%ebp
80103532:	83 ec 18             	sub    $0x18,%esp
80103535:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010353b:	0f b6 00             	movzbl (%eax),%eax
8010353e:	0f b6 c0             	movzbl %al,%eax
80103541:	89 44 24 04          	mov    %eax,0x4(%esp)
80103545:	c7 04 24 24 85 10 80 	movl   $0x80108524,(%esp)
8010354c:	e8 59 ce ff ff       	call   801003aa <cprintf>
80103551:	e8 d4 2f 00 00       	call   8010652a <idtinit>
80103556:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010355c:	05 a8 00 00 00       	add    $0xa8,%eax
80103561:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103568:	00 
80103569:	89 04 24             	mov    %eax,(%esp)
8010356c:	e8 d5 fe ff ff       	call   80103446 <xchg>
80103571:	e8 b8 12 00 00       	call   8010482e <scheduler>

80103576 <startothers>:
80103576:	55                   	push   %ebp
80103577:	89 e5                	mov    %esp,%ebp
80103579:	53                   	push   %ebx
8010357a:	83 ec 24             	sub    $0x24,%esp
8010357d:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103584:	e8 b0 fe ff ff       	call   80103439 <p2v>
80103589:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010358c:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103591:	89 44 24 08          	mov    %eax,0x8(%esp)
80103595:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
8010359c:	80 
8010359d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035a0:	89 04 24             	mov    %eax,(%esp)
801035a3:	e8 99 1a 00 00       	call   80105041 <memmove>
801035a8:	c7 45 f0 20 f9 10 80 	movl   $0x8010f920,-0x10(%ebp)
801035af:	e9 85 00 00 00       	jmp    80103639 <startothers+0xc3>
801035b4:	e8 3b f9 ff ff       	call   80102ef4 <cpunum>
801035b9:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801035bf:	05 20 f9 10 80       	add    $0x8010f920,%eax
801035c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801035c7:	74 68                	je     80103631 <startothers+0xbb>
801035c9:	e8 ad f5 ff ff       	call   80102b7b <kalloc>
801035ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801035d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035d4:	83 e8 04             	sub    $0x4,%eax
801035d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035da:	81 c2 00 10 00 00    	add    $0x1000,%edx
801035e0:	89 10                	mov    %edx,(%eax)
801035e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035e5:	83 e8 08             	sub    $0x8,%eax
801035e8:	c7 00 15 35 10 80    	movl   $0x80103515,(%eax)
801035ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035f1:	8d 58 f4             	lea    -0xc(%eax),%ebx
801035f4:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
801035fb:	e8 2c fe ff ff       	call   8010342c <v2p>
80103600:	89 03                	mov    %eax,(%ebx)
80103602:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103605:	89 04 24             	mov    %eax,(%esp)
80103608:	e8 1f fe ff ff       	call   8010342c <v2p>
8010360d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103610:	0f b6 12             	movzbl (%edx),%edx
80103613:	0f b6 d2             	movzbl %dl,%edx
80103616:	89 44 24 04          	mov    %eax,0x4(%esp)
8010361a:	89 14 24             	mov    %edx,(%esp)
8010361d:	e8 58 f9 ff ff       	call   80102f7a <lapicstartap>
80103622:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103625:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010362b:	85 c0                	test   %eax,%eax
8010362d:	74 f3                	je     80103622 <startothers+0xac>
8010362f:	eb 01                	jmp    80103632 <startothers+0xbc>
80103631:	90                   	nop
80103632:	81 45 f0 bc 00 00 00 	addl   $0xbc,-0x10(%ebp)
80103639:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010363e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103644:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103649:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010364c:	0f 87 62 ff ff ff    	ja     801035b4 <startothers+0x3e>
80103652:	83 c4 24             	add    $0x24,%esp
80103655:	5b                   	pop    %ebx
80103656:	5d                   	pop    %ebp
80103657:	c3                   	ret    

80103658 <p2v>:
80103658:	55                   	push   %ebp
80103659:	89 e5                	mov    %esp,%ebp
8010365b:	8b 45 08             	mov    0x8(%ebp),%eax
8010365e:	2d 00 00 00 80       	sub    $0x80000000,%eax
80103663:	5d                   	pop    %ebp
80103664:	c3                   	ret    

80103665 <inb>:
80103665:	55                   	push   %ebp
80103666:	89 e5                	mov    %esp,%ebp
80103668:	83 ec 14             	sub    $0x14,%esp
8010366b:	8b 45 08             	mov    0x8(%ebp),%eax
8010366e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
80103672:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103676:	89 c2                	mov    %eax,%edx
80103678:	ec                   	in     (%dx),%al
80103679:	88 45 ff             	mov    %al,-0x1(%ebp)
8010367c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
80103680:	c9                   	leave  
80103681:	c3                   	ret    

80103682 <outb>:
80103682:	55                   	push   %ebp
80103683:	89 e5                	mov    %esp,%ebp
80103685:	83 ec 08             	sub    $0x8,%esp
80103688:	8b 55 08             	mov    0x8(%ebp),%edx
8010368b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010368e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103692:	88 45 f8             	mov    %al,-0x8(%ebp)
80103695:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103699:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010369d:	ee                   	out    %al,(%dx)
8010369e:	c9                   	leave  
8010369f:	c3                   	ret    

801036a0 <mpbcpu>:
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	a1 44 b6 10 80       	mov    0x8010b644,%eax
801036a8:	89 c2                	mov    %eax,%edx
801036aa:	b8 20 f9 10 80       	mov    $0x8010f920,%eax
801036af:	89 d1                	mov    %edx,%ecx
801036b1:	29 c1                	sub    %eax,%ecx
801036b3:	89 c8                	mov    %ecx,%eax
801036b5:	c1 f8 02             	sar    $0x2,%eax
801036b8:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
801036be:	5d                   	pop    %ebp
801036bf:	c3                   	ret    

801036c0 <sum>:
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	83 ec 10             	sub    $0x10,%esp
801036c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801036cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801036d4:	eb 13                	jmp    801036e9 <sum+0x29>
801036d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801036d9:	03 45 08             	add    0x8(%ebp),%eax
801036dc:	0f b6 00             	movzbl (%eax),%eax
801036df:	0f b6 c0             	movzbl %al,%eax
801036e2:	01 45 fc             	add    %eax,-0x4(%ebp)
801036e5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801036e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801036ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
801036ef:	7c e5                	jl     801036d6 <sum+0x16>
801036f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801036f4:	c9                   	leave  
801036f5:	c3                   	ret    

801036f6 <mpsearch1>:
801036f6:	55                   	push   %ebp
801036f7:	89 e5                	mov    %esp,%ebp
801036f9:	83 ec 28             	sub    $0x28,%esp
801036fc:	8b 45 08             	mov    0x8(%ebp),%eax
801036ff:	89 04 24             	mov    %eax,(%esp)
80103702:	e8 51 ff ff ff       	call   80103658 <p2v>
80103707:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010370a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010370d:	03 45 f4             	add    -0xc(%ebp),%eax
80103710:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103713:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103716:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103719:	eb 3f                	jmp    8010375a <mpsearch1+0x64>
8010371b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103722:	00 
80103723:	c7 44 24 04 38 85 10 	movl   $0x80108538,0x4(%esp)
8010372a:	80 
8010372b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010372e:	89 04 24             	mov    %eax,(%esp)
80103731:	e8 af 18 00 00       	call   80104fe5 <memcmp>
80103736:	85 c0                	test   %eax,%eax
80103738:	75 1c                	jne    80103756 <mpsearch1+0x60>
8010373a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103741:	00 
80103742:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103745:	89 04 24             	mov    %eax,(%esp)
80103748:	e8 73 ff ff ff       	call   801036c0 <sum>
8010374d:	84 c0                	test   %al,%al
8010374f:	75 05                	jne    80103756 <mpsearch1+0x60>
80103751:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103754:	eb 11                	jmp    80103767 <mpsearch1+0x71>
80103756:	83 45 f0 10          	addl   $0x10,-0x10(%ebp)
8010375a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010375d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103760:	72 b9                	jb     8010371b <mpsearch1+0x25>
80103762:	b8 00 00 00 00       	mov    $0x0,%eax
80103767:	c9                   	leave  
80103768:	c3                   	ret    

80103769 <mpsearch>:
80103769:	55                   	push   %ebp
8010376a:	89 e5                	mov    %esp,%ebp
8010376c:	83 ec 28             	sub    $0x28,%esp
8010376f:	c7 45 ec 00 04 00 80 	movl   $0x80000400,-0x14(%ebp)
80103776:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103779:	83 c0 0f             	add    $0xf,%eax
8010377c:	0f b6 00             	movzbl (%eax),%eax
8010377f:	0f b6 c0             	movzbl %al,%eax
80103782:	89 c2                	mov    %eax,%edx
80103784:	c1 e2 08             	shl    $0x8,%edx
80103787:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010378a:	83 c0 0e             	add    $0xe,%eax
8010378d:	0f b6 00             	movzbl (%eax),%eax
80103790:	0f b6 c0             	movzbl %al,%eax
80103793:	09 d0                	or     %edx,%eax
80103795:	c1 e0 04             	shl    $0x4,%eax
80103798:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010379b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010379f:	74 21                	je     801037c2 <mpsearch+0x59>
801037a1:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
801037a8:	00 
801037a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037ac:	89 04 24             	mov    %eax,(%esp)
801037af:	e8 42 ff ff ff       	call   801036f6 <mpsearch1>
801037b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037bb:	74 50                	je     8010380d <mpsearch+0xa4>
801037bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037c0:	eb 5f                	jmp    80103821 <mpsearch+0xb8>
801037c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037c5:	83 c0 14             	add    $0x14,%eax
801037c8:	0f b6 00             	movzbl (%eax),%eax
801037cb:	0f b6 c0             	movzbl %al,%eax
801037ce:	89 c2                	mov    %eax,%edx
801037d0:	c1 e2 08             	shl    $0x8,%edx
801037d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037d6:	83 c0 13             	add    $0x13,%eax
801037d9:	0f b6 00             	movzbl (%eax),%eax
801037dc:	0f b6 c0             	movzbl %al,%eax
801037df:	09 d0                	or     %edx,%eax
801037e1:	c1 e0 0a             	shl    $0xa,%eax
801037e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801037e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037ea:	2d 00 04 00 00       	sub    $0x400,%eax
801037ef:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
801037f6:	00 
801037f7:	89 04 24             	mov    %eax,(%esp)
801037fa:	e8 f7 fe ff ff       	call   801036f6 <mpsearch1>
801037ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103806:	74 05                	je     8010380d <mpsearch+0xa4>
80103808:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010380b:	eb 14                	jmp    80103821 <mpsearch+0xb8>
8010380d:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103814:	00 
80103815:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
8010381c:	e8 d5 fe ff ff       	call   801036f6 <mpsearch1>
80103821:	c9                   	leave  
80103822:	c3                   	ret    

80103823 <mpconfig>:
80103823:	55                   	push   %ebp
80103824:	89 e5                	mov    %esp,%ebp
80103826:	83 ec 28             	sub    $0x28,%esp
80103829:	e8 3b ff ff ff       	call   80103769 <mpsearch>
8010382e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103835:	74 0a                	je     80103841 <mpconfig+0x1e>
80103837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010383a:	8b 40 04             	mov    0x4(%eax),%eax
8010383d:	85 c0                	test   %eax,%eax
8010383f:	75 0a                	jne    8010384b <mpconfig+0x28>
80103841:	b8 00 00 00 00       	mov    $0x0,%eax
80103846:	e9 83 00 00 00       	jmp    801038ce <mpconfig+0xab>
8010384b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010384e:	8b 40 04             	mov    0x4(%eax),%eax
80103851:	89 04 24             	mov    %eax,(%esp)
80103854:	e8 ff fd ff ff       	call   80103658 <p2v>
80103859:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010385c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103863:	00 
80103864:	c7 44 24 04 3d 85 10 	movl   $0x8010853d,0x4(%esp)
8010386b:	80 
8010386c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010386f:	89 04 24             	mov    %eax,(%esp)
80103872:	e8 6e 17 00 00       	call   80104fe5 <memcmp>
80103877:	85 c0                	test   %eax,%eax
80103879:	74 07                	je     80103882 <mpconfig+0x5f>
8010387b:	b8 00 00 00 00       	mov    $0x0,%eax
80103880:	eb 4c                	jmp    801038ce <mpconfig+0xab>
80103882:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103885:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103889:	3c 01                	cmp    $0x1,%al
8010388b:	74 12                	je     8010389f <mpconfig+0x7c>
8010388d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103890:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103894:	3c 04                	cmp    $0x4,%al
80103896:	74 07                	je     8010389f <mpconfig+0x7c>
80103898:	b8 00 00 00 00       	mov    $0x0,%eax
8010389d:	eb 2f                	jmp    801038ce <mpconfig+0xab>
8010389f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a2:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801038a6:	0f b7 d0             	movzwl %ax,%edx
801038a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ac:	89 54 24 04          	mov    %edx,0x4(%esp)
801038b0:	89 04 24             	mov    %eax,(%esp)
801038b3:	e8 08 fe ff ff       	call   801036c0 <sum>
801038b8:	84 c0                	test   %al,%al
801038ba:	74 07                	je     801038c3 <mpconfig+0xa0>
801038bc:	b8 00 00 00 00       	mov    $0x0,%eax
801038c1:	eb 0b                	jmp    801038ce <mpconfig+0xab>
801038c3:	8b 45 08             	mov    0x8(%ebp),%eax
801038c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038c9:	89 10                	mov    %edx,(%eax)
801038cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ce:	c9                   	leave  
801038cf:	c3                   	ret    

801038d0 <mpinit>:
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 38             	sub    $0x38,%esp
801038d6:	c7 05 44 b6 10 80 20 	movl   $0x8010f920,0x8010b644
801038dd:	f9 10 80 
801038e0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801038e3:	89 04 24             	mov    %eax,(%esp)
801038e6:	e8 38 ff ff ff       	call   80103823 <mpconfig>
801038eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
801038ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801038f2:	0f 84 9d 01 00 00    	je     80103a95 <mpinit+0x1c5>
801038f8:	c7 05 04 f9 10 80 01 	movl   $0x1,0x8010f904
801038ff:	00 00 00 
80103902:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103905:	8b 40 24             	mov    0x24(%eax),%eax
80103908:	a3 7c f8 10 80       	mov    %eax,0x8010f87c
8010390d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103910:	83 c0 2c             	add    $0x2c,%eax
80103913:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103916:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103919:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010391c:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103920:	0f b7 c0             	movzwl %ax,%eax
80103923:	8d 04 02             	lea    (%edx,%eax,1),%eax
80103926:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103929:	e9 f2 00 00 00       	jmp    80103a20 <mpinit+0x150>
8010392e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103931:	0f b6 00             	movzbl (%eax),%eax
80103934:	0f b6 c0             	movzbl %al,%eax
80103937:	83 f8 04             	cmp    $0x4,%eax
8010393a:	0f 87 bd 00 00 00    	ja     801039fd <mpinit+0x12d>
80103940:	8b 04 85 80 85 10 80 	mov    -0x7fef7a80(,%eax,4),%eax
80103947:	ff e0                	jmp    *%eax
80103949:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010394c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010394f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103952:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103956:	0f b6 d0             	movzbl %al,%edx
80103959:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010395e:	39 c2                	cmp    %eax,%edx
80103960:	74 2d                	je     8010398f <mpinit+0xbf>
80103962:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103965:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103969:	0f b6 d0             	movzbl %al,%edx
8010396c:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103971:	89 54 24 08          	mov    %edx,0x8(%esp)
80103975:	89 44 24 04          	mov    %eax,0x4(%esp)
80103979:	c7 04 24 42 85 10 80 	movl   $0x80108542,(%esp)
80103980:	e8 25 ca ff ff       	call   801003aa <cprintf>
80103985:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
8010398c:	00 00 00 
8010398f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103992:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103996:	0f b6 c0             	movzbl %al,%eax
80103999:	83 e0 02             	and    $0x2,%eax
8010399c:	85 c0                	test   %eax,%eax
8010399e:	74 15                	je     801039b5 <mpinit+0xe5>
801039a0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801039a5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039ab:	05 20 f9 10 80       	add    $0x8010f920,%eax
801039b0:	a3 44 b6 10 80       	mov    %eax,0x8010b644
801039b5:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801039ba:	8b 15 00 ff 10 80    	mov    0x8010ff00,%edx
801039c0:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039c6:	88 90 20 f9 10 80    	mov    %dl,-0x7fef06e0(%eax)
801039cc:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801039d1:	83 c0 01             	add    $0x1,%eax
801039d4:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
801039d9:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
801039dd:	eb 41                	jmp    80103a20 <mpinit+0x150>
801039df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801039e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801039ec:	a2 00 f9 10 80       	mov    %al,0x8010f900
801039f1:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
801039f5:	eb 29                	jmp    80103a20 <mpinit+0x150>
801039f7:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
801039fb:	eb 23                	jmp    80103a20 <mpinit+0x150>
801039fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a00:	0f b6 00             	movzbl (%eax),%eax
80103a03:	0f b6 c0             	movzbl %al,%eax
80103a06:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a0a:	c7 04 24 60 85 10 80 	movl   $0x80108560,(%esp)
80103a11:	e8 94 c9 ff ff       	call   801003aa <cprintf>
80103a16:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
80103a1d:	00 00 00 
80103a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a23:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103a26:	0f 82 02 ff ff ff    	jb     8010392e <mpinit+0x5e>
80103a2c:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103a31:	85 c0                	test   %eax,%eax
80103a33:	75 1d                	jne    80103a52 <mpinit+0x182>
80103a35:	c7 05 00 ff 10 80 01 	movl   $0x1,0x8010ff00
80103a3c:	00 00 00 
80103a3f:	c7 05 7c f8 10 80 00 	movl   $0x0,0x8010f87c
80103a46:	00 00 00 
80103a49:	c6 05 00 f9 10 80 00 	movb   $0x0,0x8010f900
80103a50:	eb 44                	jmp    80103a96 <mpinit+0x1c6>
80103a52:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103a55:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103a59:	84 c0                	test   %al,%al
80103a5b:	74 39                	je     80103a96 <mpinit+0x1c6>
80103a5d:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103a64:	00 
80103a65:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103a6c:	e8 11 fc ff ff       	call   80103682 <outb>
80103a71:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a78:	e8 e8 fb ff ff       	call   80103665 <inb>
80103a7d:	83 c8 01             	or     $0x1,%eax
80103a80:	0f b6 c0             	movzbl %al,%eax
80103a83:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a87:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a8e:	e8 ef fb ff ff       	call   80103682 <outb>
80103a93:	eb 01                	jmp    80103a96 <mpinit+0x1c6>
80103a95:	90                   	nop
80103a96:	c9                   	leave  
80103a97:	c3                   	ret    

80103a98 <outb>:
80103a98:	55                   	push   %ebp
80103a99:	89 e5                	mov    %esp,%ebp
80103a9b:	83 ec 08             	sub    $0x8,%esp
80103a9e:	8b 55 08             	mov    0x8(%ebp),%edx
80103aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
80103aa4:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103aa8:	88 45 f8             	mov    %al,-0x8(%ebp)
80103aab:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103aaf:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103ab3:	ee                   	out    %al,(%dx)
80103ab4:	c9                   	leave  
80103ab5:	c3                   	ret    

80103ab6 <picsetmask>:
80103ab6:	55                   	push   %ebp
80103ab7:	89 e5                	mov    %esp,%ebp
80103ab9:	83 ec 0c             	sub    $0xc,%esp
80103abc:	8b 45 08             	mov    0x8(%ebp),%eax
80103abf:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103ac3:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103ac7:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
80103acd:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103ad1:	0f b6 c0             	movzbl %al,%eax
80103ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ad8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103adf:	e8 b4 ff ff ff       	call   80103a98 <outb>
80103ae4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103ae8:	66 c1 e8 08          	shr    $0x8,%ax
80103aec:	0f b6 c0             	movzbl %al,%eax
80103aef:	89 44 24 04          	mov    %eax,0x4(%esp)
80103af3:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103afa:	e8 99 ff ff ff       	call   80103a98 <outb>
80103aff:	c9                   	leave  
80103b00:	c3                   	ret    

80103b01 <picenable>:
80103b01:	55                   	push   %ebp
80103b02:	89 e5                	mov    %esp,%ebp
80103b04:	53                   	push   %ebx
80103b05:	83 ec 04             	sub    $0x4,%esp
80103b08:	8b 45 08             	mov    0x8(%ebp),%eax
80103b0b:	ba 01 00 00 00       	mov    $0x1,%edx
80103b10:	89 d3                	mov    %edx,%ebx
80103b12:	89 c1                	mov    %eax,%ecx
80103b14:	d3 e3                	shl    %cl,%ebx
80103b16:	89 d8                	mov    %ebx,%eax
80103b18:	89 c2                	mov    %eax,%edx
80103b1a:	f7 d2                	not    %edx
80103b1c:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103b23:	21 d0                	and    %edx,%eax
80103b25:	0f b7 c0             	movzwl %ax,%eax
80103b28:	89 04 24             	mov    %eax,(%esp)
80103b2b:	e8 86 ff ff ff       	call   80103ab6 <picsetmask>
80103b30:	83 c4 04             	add    $0x4,%esp
80103b33:	5b                   	pop    %ebx
80103b34:	5d                   	pop    %ebp
80103b35:	c3                   	ret    

80103b36 <picinit>:
80103b36:	55                   	push   %ebp
80103b37:	89 e5                	mov    %esp,%ebp
80103b39:	83 ec 08             	sub    $0x8,%esp
80103b3c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b43:	00 
80103b44:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b4b:	e8 48 ff ff ff       	call   80103a98 <outb>
80103b50:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b57:	00 
80103b58:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b5f:	e8 34 ff ff ff       	call   80103a98 <outb>
80103b64:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b6b:	00 
80103b6c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b73:	e8 20 ff ff ff       	call   80103a98 <outb>
80103b78:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103b7f:	00 
80103b80:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b87:	e8 0c ff ff ff       	call   80103a98 <outb>
80103b8c:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b93:	00 
80103b94:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b9b:	e8 f8 fe ff ff       	call   80103a98 <outb>
80103ba0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103ba7:	00 
80103ba8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103baf:	e8 e4 fe ff ff       	call   80103a98 <outb>
80103bb4:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103bbb:	00 
80103bbc:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bc3:	e8 d0 fe ff ff       	call   80103a98 <outb>
80103bc8:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103bcf:	00 
80103bd0:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bd7:	e8 bc fe ff ff       	call   80103a98 <outb>
80103bdc:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103be3:	00 
80103be4:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103beb:	e8 a8 fe ff ff       	call   80103a98 <outb>
80103bf0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103bf7:	00 
80103bf8:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bff:	e8 94 fe ff ff       	call   80103a98 <outb>
80103c04:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103c0b:	00 
80103c0c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103c13:	e8 80 fe ff ff       	call   80103a98 <outb>
80103c18:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103c1f:	00 
80103c20:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103c27:	e8 6c fe ff ff       	call   80103a98 <outb>
80103c2c:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103c33:	00 
80103c34:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c3b:	e8 58 fe ff ff       	call   80103a98 <outb>
80103c40:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103c47:	00 
80103c48:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c4f:	e8 44 fe ff ff       	call   80103a98 <outb>
80103c54:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c5b:	66 83 f8 ff          	cmp    $0xffff,%ax
80103c5f:	74 12                	je     80103c73 <picinit+0x13d>
80103c61:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c68:	0f b7 c0             	movzwl %ax,%eax
80103c6b:	89 04 24             	mov    %eax,(%esp)
80103c6e:	e8 43 fe ff ff       	call   80103ab6 <picsetmask>
80103c73:	c9                   	leave  
80103c74:	c3                   	ret    
80103c75:	66 90                	xchg   %ax,%ax
80103c77:	90                   	nop

80103c78 <pipealloc>:
80103c78:	55                   	push   %ebp
80103c79:	89 e5                	mov    %esp,%ebp
80103c7b:	83 ec 28             	sub    $0x28,%esp
80103c7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103c85:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c91:	8b 10                	mov    (%eax),%edx
80103c93:	8b 45 08             	mov    0x8(%ebp),%eax
80103c96:	89 10                	mov    %edx,(%eax)
80103c98:	e8 d7 d2 ff ff       	call   80100f74 <filealloc>
80103c9d:	8b 55 08             	mov    0x8(%ebp),%edx
80103ca0:	89 02                	mov    %eax,(%edx)
80103ca2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ca5:	8b 00                	mov    (%eax),%eax
80103ca7:	85 c0                	test   %eax,%eax
80103ca9:	0f 84 c8 00 00 00    	je     80103d77 <pipealloc+0xff>
80103caf:	e8 c0 d2 ff ff       	call   80100f74 <filealloc>
80103cb4:	8b 55 0c             	mov    0xc(%ebp),%edx
80103cb7:	89 02                	mov    %eax,(%edx)
80103cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cbc:	8b 00                	mov    (%eax),%eax
80103cbe:	85 c0                	test   %eax,%eax
80103cc0:	0f 84 b1 00 00 00    	je     80103d77 <pipealloc+0xff>
80103cc6:	e8 b0 ee ff ff       	call   80102b7b <kalloc>
80103ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cd2:	0f 84 9e 00 00 00    	je     80103d76 <pipealloc+0xfe>
80103cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cdb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103ce2:	00 00 00 
80103ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ce8:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103cef:	00 00 00 
80103cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf5:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cfc:	00 00 00 
80103cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d02:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d09:	00 00 00 
80103d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d0f:	c7 44 24 04 94 85 10 	movl   $0x80108594,0x4(%esp)
80103d16:	80 
80103d17:	89 04 24             	mov    %eax,(%esp)
80103d1a:	e8 df 0f 00 00       	call   80104cfe <initlock>
80103d1f:	8b 45 08             	mov    0x8(%ebp),%eax
80103d22:	8b 00                	mov    (%eax),%eax
80103d24:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103d2a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d2d:	8b 00                	mov    (%eax),%eax
80103d2f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
80103d33:	8b 45 08             	mov    0x8(%ebp),%eax
80103d36:	8b 00                	mov    (%eax),%eax
80103d38:	c6 40 09 00          	movb   $0x0,0x9(%eax)
80103d3c:	8b 45 08             	mov    0x8(%ebp),%eax
80103d3f:	8b 00                	mov    (%eax),%eax
80103d41:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d44:	89 50 0c             	mov    %edx,0xc(%eax)
80103d47:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d4a:	8b 00                	mov    (%eax),%eax
80103d4c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103d52:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d55:	8b 00                	mov    (%eax),%eax
80103d57:	c6 40 08 00          	movb   $0x0,0x8(%eax)
80103d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d5e:	8b 00                	mov    (%eax),%eax
80103d60:	c6 40 09 01          	movb   $0x1,0x9(%eax)
80103d64:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d67:	8b 00                	mov    (%eax),%eax
80103d69:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d6c:	89 50 0c             	mov    %edx,0xc(%eax)
80103d6f:	b8 00 00 00 00       	mov    $0x0,%eax
80103d74:	eb 43                	jmp    80103db9 <pipealloc+0x141>
80103d76:	90                   	nop
80103d77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d7b:	74 0b                	je     80103d88 <pipealloc+0x110>
80103d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d80:	89 04 24             	mov    %eax,(%esp)
80103d83:	e8 5a ed ff ff       	call   80102ae2 <kfree>
80103d88:	8b 45 08             	mov    0x8(%ebp),%eax
80103d8b:	8b 00                	mov    (%eax),%eax
80103d8d:	85 c0                	test   %eax,%eax
80103d8f:	74 0d                	je     80103d9e <pipealloc+0x126>
80103d91:	8b 45 08             	mov    0x8(%ebp),%eax
80103d94:	8b 00                	mov    (%eax),%eax
80103d96:	89 04 24             	mov    %eax,(%esp)
80103d99:	e8 7e d2 ff ff       	call   8010101c <fileclose>
80103d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103da1:	8b 00                	mov    (%eax),%eax
80103da3:	85 c0                	test   %eax,%eax
80103da5:	74 0d                	je     80103db4 <pipealloc+0x13c>
80103da7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103daa:	8b 00                	mov    (%eax),%eax
80103dac:	89 04 24             	mov    %eax,(%esp)
80103daf:	e8 68 d2 ff ff       	call   8010101c <fileclose>
80103db4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103db9:	c9                   	leave  
80103dba:	c3                   	ret    

80103dbb <pipeclose>:
80103dbb:	55                   	push   %ebp
80103dbc:	89 e5                	mov    %esp,%ebp
80103dbe:	83 ec 18             	sub    $0x18,%esp
80103dc1:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc4:	89 04 24             	mov    %eax,(%esp)
80103dc7:	e8 53 0f 00 00       	call   80104d1f <acquire>
80103dcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103dd0:	74 1f                	je     80103df1 <pipeclose+0x36>
80103dd2:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd5:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103ddc:	00 00 00 
80103ddf:	8b 45 08             	mov    0x8(%ebp),%eax
80103de2:	05 34 02 00 00       	add    $0x234,%eax
80103de7:	89 04 24             	mov    %eax,(%esp)
80103dea:	e8 29 0d 00 00       	call   80104b18 <wakeup>
80103def:	eb 1d                	jmp    80103e0e <pipeclose+0x53>
80103df1:	8b 45 08             	mov    0x8(%ebp),%eax
80103df4:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103dfb:	00 00 00 
80103dfe:	8b 45 08             	mov    0x8(%ebp),%eax
80103e01:	05 38 02 00 00       	add    $0x238,%eax
80103e06:	89 04 24             	mov    %eax,(%esp)
80103e09:	e8 0a 0d 00 00       	call   80104b18 <wakeup>
80103e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e11:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e17:	85 c0                	test   %eax,%eax
80103e19:	75 25                	jne    80103e40 <pipeclose+0x85>
80103e1b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e1e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103e24:	85 c0                	test   %eax,%eax
80103e26:	75 18                	jne    80103e40 <pipeclose+0x85>
80103e28:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2b:	89 04 24             	mov    %eax,(%esp)
80103e2e:	e8 4d 0f 00 00       	call   80104d80 <release>
80103e33:	8b 45 08             	mov    0x8(%ebp),%eax
80103e36:	89 04 24             	mov    %eax,(%esp)
80103e39:	e8 a4 ec ff ff       	call   80102ae2 <kfree>
80103e3e:	eb 0b                	jmp    80103e4b <pipeclose+0x90>
80103e40:	8b 45 08             	mov    0x8(%ebp),%eax
80103e43:	89 04 24             	mov    %eax,(%esp)
80103e46:	e8 35 0f 00 00       	call   80104d80 <release>
80103e4b:	c9                   	leave  
80103e4c:	c3                   	ret    

80103e4d <pipewrite>:
80103e4d:	55                   	push   %ebp
80103e4e:	89 e5                	mov    %esp,%ebp
80103e50:	53                   	push   %ebx
80103e51:	83 ec 24             	sub    $0x24,%esp
80103e54:	8b 45 08             	mov    0x8(%ebp),%eax
80103e57:	89 04 24             	mov    %eax,(%esp)
80103e5a:	e8 c0 0e 00 00       	call   80104d1f <acquire>
80103e5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103e66:	e9 a6 00 00 00       	jmp    80103f11 <pipewrite+0xc4>
80103e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e74:	85 c0                	test   %eax,%eax
80103e76:	74 0d                	je     80103e85 <pipewrite+0x38>
80103e78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e7e:	8b 40 24             	mov    0x24(%eax),%eax
80103e81:	85 c0                	test   %eax,%eax
80103e83:	74 15                	je     80103e9a <pipewrite+0x4d>
80103e85:	8b 45 08             	mov    0x8(%ebp),%eax
80103e88:	89 04 24             	mov    %eax,(%esp)
80103e8b:	e8 f0 0e 00 00       	call   80104d80 <release>
80103e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e95:	e9 9d 00 00 00       	jmp    80103f37 <pipewrite+0xea>
80103e9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9d:	05 34 02 00 00       	add    $0x234,%eax
80103ea2:	89 04 24             	mov    %eax,(%esp)
80103ea5:	e8 6e 0c 00 00       	call   80104b18 <wakeup>
80103eaa:	8b 45 08             	mov    0x8(%ebp),%eax
80103ead:	8b 55 08             	mov    0x8(%ebp),%edx
80103eb0:	81 c2 38 02 00 00    	add    $0x238,%edx
80103eb6:	89 44 24 04          	mov    %eax,0x4(%esp)
80103eba:	89 14 24             	mov    %edx,(%esp)
80103ebd:	e8 6e 0b 00 00       	call   80104a30 <sleep>
80103ec2:	eb 01                	jmp    80103ec5 <pipewrite+0x78>
80103ec4:	90                   	nop
80103ec5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec8:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103ece:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed1:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103ed7:	05 00 02 00 00       	add    $0x200,%eax
80103edc:	39 c2                	cmp    %eax,%edx
80103ede:	74 8b                	je     80103e6b <pipewrite+0x1e>
80103ee0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee3:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103ee9:	89 c3                	mov    %eax,%ebx
80103eeb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103ef1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ef4:	03 55 0c             	add    0xc(%ebp),%edx
80103ef7:	0f b6 0a             	movzbl (%edx),%ecx
80103efa:	8b 55 08             	mov    0x8(%ebp),%edx
80103efd:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103f01:	8d 50 01             	lea    0x1(%eax),%edx
80103f04:	8b 45 08             	mov    0x8(%ebp),%eax
80103f07:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
80103f0d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f14:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f17:	7c ab                	jl     80103ec4 <pipewrite+0x77>
80103f19:	8b 45 08             	mov    0x8(%ebp),%eax
80103f1c:	05 34 02 00 00       	add    $0x234,%eax
80103f21:	89 04 24             	mov    %eax,(%esp)
80103f24:	e8 ef 0b 00 00       	call   80104b18 <wakeup>
80103f29:	8b 45 08             	mov    0x8(%ebp),%eax
80103f2c:	89 04 24             	mov    %eax,(%esp)
80103f2f:	e8 4c 0e 00 00       	call   80104d80 <release>
80103f34:	8b 45 10             	mov    0x10(%ebp),%eax
80103f37:	83 c4 24             	add    $0x24,%esp
80103f3a:	5b                   	pop    %ebx
80103f3b:	5d                   	pop    %ebp
80103f3c:	c3                   	ret    

80103f3d <piperead>:
80103f3d:	55                   	push   %ebp
80103f3e:	89 e5                	mov    %esp,%ebp
80103f40:	53                   	push   %ebx
80103f41:	83 ec 24             	sub    $0x24,%esp
80103f44:	8b 45 08             	mov    0x8(%ebp),%eax
80103f47:	89 04 24             	mov    %eax,(%esp)
80103f4a:	e8 d0 0d 00 00       	call   80104d1f <acquire>
80103f4f:	eb 3a                	jmp    80103f8b <piperead+0x4e>
80103f51:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f57:	8b 40 24             	mov    0x24(%eax),%eax
80103f5a:	85 c0                	test   %eax,%eax
80103f5c:	74 15                	je     80103f73 <piperead+0x36>
80103f5e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f61:	89 04 24             	mov    %eax,(%esp)
80103f64:	e8 17 0e 00 00       	call   80104d80 <release>
80103f69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f6e:	e9 b6 00 00 00       	jmp    80104029 <piperead+0xec>
80103f73:	8b 45 08             	mov    0x8(%ebp),%eax
80103f76:	8b 55 08             	mov    0x8(%ebp),%edx
80103f79:	81 c2 34 02 00 00    	add    $0x234,%edx
80103f7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f83:	89 14 24             	mov    %edx,(%esp)
80103f86:	e8 a5 0a 00 00       	call   80104a30 <sleep>
80103f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f94:	8b 45 08             	mov    0x8(%ebp),%eax
80103f97:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f9d:	39 c2                	cmp    %eax,%edx
80103f9f:	75 0d                	jne    80103fae <piperead+0x71>
80103fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa4:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103faa:	85 c0                	test   %eax,%eax
80103fac:	75 a3                	jne    80103f51 <piperead+0x14>
80103fae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103fb5:	eb 49                	jmp    80104000 <piperead+0xc3>
80103fb7:	8b 45 08             	mov    0x8(%ebp),%eax
80103fba:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103fc0:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc3:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103fc9:	39 c2                	cmp    %eax,%edx
80103fcb:	74 3d                	je     8010400a <piperead+0xcd>
80103fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fd0:	89 c2                	mov    %eax,%edx
80103fd2:	03 55 0c             	add    0xc(%ebp),%edx
80103fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd8:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103fde:	89 c3                	mov    %eax,%ebx
80103fe0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103fe6:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103fe9:	0f b6 4c 19 34       	movzbl 0x34(%ecx,%ebx,1),%ecx
80103fee:	88 0a                	mov    %cl,(%edx)
80103ff0:	8d 50 01             	lea    0x1(%eax),%edx
80103ff3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff6:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
80103ffc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104000:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104003:	3b 45 10             	cmp    0x10(%ebp),%eax
80104006:	7c af                	jl     80103fb7 <piperead+0x7a>
80104008:	eb 01                	jmp    8010400b <piperead+0xce>
8010400a:	90                   	nop
8010400b:	8b 45 08             	mov    0x8(%ebp),%eax
8010400e:	05 38 02 00 00       	add    $0x238,%eax
80104013:	89 04 24             	mov    %eax,(%esp)
80104016:	e8 fd 0a 00 00       	call   80104b18 <wakeup>
8010401b:	8b 45 08             	mov    0x8(%ebp),%eax
8010401e:	89 04 24             	mov    %eax,(%esp)
80104021:	e8 5a 0d 00 00       	call   80104d80 <release>
80104026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104029:	83 c4 24             	add    $0x24,%esp
8010402c:	5b                   	pop    %ebx
8010402d:	5d                   	pop    %ebp
8010402e:	c3                   	ret    
8010402f:	90                   	nop

80104030 <readeflags>:
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	83 ec 10             	sub    $0x10,%esp
80104036:	9c                   	pushf  
80104037:	58                   	pop    %eax
80104038:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010403b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010403e:	c9                   	leave  
8010403f:	c3                   	ret    

80104040 <sti>:
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	fb                   	sti    
80104044:	5d                   	pop    %ebp
80104045:	c3                   	ret    

80104046 <pinit>:
80104046:	55                   	push   %ebp
80104047:	89 e5                	mov    %esp,%ebp
80104049:	83 ec 18             	sub    $0x18,%esp
8010404c:	c7 44 24 04 99 85 10 	movl   $0x80108599,0x4(%esp)
80104053:	80 
80104054:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
8010405b:	e8 9e 0c 00 00       	call   80104cfe <initlock>
80104060:	c9                   	leave  
80104061:	c3                   	ret    

80104062 <rqinit>:
80104062:	55                   	push   %ebp
80104063:	89 e5                	mov    %esp,%ebp
80104065:	83 ec 28             	sub    $0x28,%esp
80104068:	c7 44 24 04 a0 85 10 	movl   $0x801085a0,0x4(%esp)
8010406f:	80 
80104070:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104077:	e8 82 0c 00 00       	call   80104cfe <initlock>
8010407c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104083:	eb 15                	jmp    8010409a <rqinit+0x38>
80104085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104088:	83 c0 0c             	add    $0xc,%eax
8010408b:	c7 04 85 24 ff 10 80 	movl   $0x0,-0x7fef00dc(,%eax,4)
80104092:	00 00 00 00 
80104096:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010409a:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%ebp)
8010409e:	7e e5                	jle    80104085 <rqinit+0x23>
801040a0:	c9                   	leave  
801040a1:	c3                   	ret    

801040a2 <allocproc>:
801040a2:	55                   	push   %ebp
801040a3:	89 e5                	mov    %esp,%ebp
801040a5:	83 ec 28             	sub    $0x28,%esp
801040a8:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801040af:	e8 6b 0c 00 00       	call   80104d1f <acquire>
801040b4:	c7 45 f0 14 00 11 80 	movl   $0x80110014,-0x10(%ebp)
801040bb:	eb 11                	jmp    801040ce <allocproc+0x2c>
801040bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040c0:	8b 40 0c             	mov    0xc(%eax),%eax
801040c3:	85 c0                	test   %eax,%eax
801040c5:	74 27                	je     801040ee <allocproc+0x4c>
801040c7:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
801040ce:	b8 14 22 11 80       	mov    $0x80112214,%eax
801040d3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801040d6:	72 e5                	jb     801040bd <allocproc+0x1b>
801040d8:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801040df:	e8 9c 0c 00 00       	call   80104d80 <release>
801040e4:	b8 00 00 00 00       	mov    $0x0,%eax
801040e9:	e9 d9 00 00 00       	jmp    801041c7 <allocproc+0x125>
801040ee:	90                   	nop
801040ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040f2:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
801040f9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801040fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104101:	89 42 10             	mov    %eax,0x10(%edx)
80104104:	83 c0 01             	add    $0x1,%eax
80104107:	a3 04 b0 10 80       	mov    %eax,0x8010b004
8010410c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010410f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104116:	00 00 00 
80104119:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010411c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104123:	00 00 00 
80104126:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104129:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
80104130:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104137:	e8 44 0c 00 00       	call   80104d80 <release>
8010413c:	e8 3a ea ff ff       	call   80102b7b <kalloc>
80104141:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104144:	89 42 08             	mov    %eax,0x8(%edx)
80104147:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010414a:	8b 40 08             	mov    0x8(%eax),%eax
8010414d:	85 c0                	test   %eax,%eax
8010414f:	75 11                	jne    80104162 <allocproc+0xc0>
80104151:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104154:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
8010415b:	b8 00 00 00 00       	mov    $0x0,%eax
80104160:	eb 65                	jmp    801041c7 <allocproc+0x125>
80104162:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104165:	8b 40 08             	mov    0x8(%eax),%eax
80104168:	05 00 10 00 00       	add    $0x1000,%eax
8010416d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104170:	83 6d f4 4c          	subl   $0x4c,-0xc(%ebp)
80104174:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104177:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010417a:	89 50 18             	mov    %edx,0x18(%eax)
8010417d:	83 6d f4 04          	subl   $0x4,-0xc(%ebp)
80104181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104184:	ba 74 63 10 80       	mov    $0x80106374,%edx
80104189:	89 10                	mov    %edx,(%eax)
8010418b:	83 6d f4 14          	subl   $0x14,-0xc(%ebp)
8010418f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104192:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104195:	89 50 1c             	mov    %edx,0x1c(%eax)
80104198:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010419b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010419e:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801041a5:	00 
801041a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801041ad:	00 
801041ae:	89 04 24             	mov    %eax,(%esp)
801041b1:	e8 b8 0d 00 00       	call   80104f6e <memset>
801041b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041b9:	8b 40 1c             	mov    0x1c(%eax),%eax
801041bc:	ba 04 4a 10 80       	mov    $0x80104a04,%edx
801041c1:	89 50 10             	mov    %edx,0x10(%eax)
801041c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041c7:	c9                   	leave  
801041c8:	c3                   	ret    

801041c9 <ready1>:
801041c9:	55                   	push   %ebp
801041ca:	89 e5                	mov    %esp,%ebp
801041cc:	83 ec 10             	sub    $0x10,%esp
801041cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801041d3:	75 0a                	jne    801041df <ready1+0x16>
801041d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041da:	e9 8b 00 00 00       	jmp    8010426a <ready1+0xa1>
801041df:	8b 45 08             	mov    0x8(%ebp),%eax
801041e2:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801041e8:	83 f8 20             	cmp    $0x20,%eax
801041eb:	7f 0d                	jg     801041fa <ready1+0x31>
801041ed:	8b 45 08             	mov    0x8(%ebp),%eax
801041f0:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801041f6:	85 c0                	test   %eax,%eax
801041f8:	79 07                	jns    80104201 <ready1+0x38>
801041fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041ff:	eb 69                	jmp    8010426a <ready1+0xa1>
80104201:	8b 45 08             	mov    0x8(%ebp),%eax
80104204:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010420a:	83 c0 0c             	add    $0xc,%eax
8010420d:	8b 04 85 24 ff 10 80 	mov    -0x7fef00dc(,%eax,4),%eax
80104214:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104217:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010421b:	74 32                	je     8010424f <ready1+0x86>
8010421d:	eb 0c                	jmp    8010422b <ready1+0x62>
8010421f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104222:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104228:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010422b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010422e:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104234:	85 c0                	test   %eax,%eax
80104236:	75 e7                	jne    8010421f <ready1+0x56>
80104238:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010423b:	8b 55 08             	mov    0x8(%ebp),%edx
8010423e:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
80104244:	8b 45 08             	mov    0x8(%ebp),%eax
80104247:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010424a:	89 50 7c             	mov    %edx,0x7c(%eax)
8010424d:	eb 16                	jmp    80104265 <ready1+0x9c>
8010424f:	8b 45 08             	mov    0x8(%ebp),%eax
80104252:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104258:	8d 50 0c             	lea    0xc(%eax),%edx
8010425b:	8b 45 08             	mov    0x8(%ebp),%eax
8010425e:	89 04 95 24 ff 10 80 	mov    %eax,-0x7fef00dc(,%edx,4)
80104265:	b8 01 00 00 00       	mov    $0x1,%eax
8010426a:	c9                   	leave  
8010426b:	c3                   	ret    

8010426c <ready>:
8010426c:	55                   	push   %ebp
8010426d:	89 e5                	mov    %esp,%ebp
8010426f:	83 ec 28             	sub    $0x28,%esp
80104272:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104279:	e8 a1 0a 00 00       	call   80104d1f <acquire>
8010427e:	8b 45 08             	mov    0x8(%ebp),%eax
80104281:	89 04 24             	mov    %eax,(%esp)
80104284:	e8 40 ff ff ff       	call   801041c9 <ready1>
80104289:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010428c:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104293:	e8 e8 0a 00 00       	call   80104d80 <release>
80104298:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010429b:	c9                   	leave  
8010429c:	c3                   	ret    

8010429d <userinit>:
8010429d:	55                   	push   %ebp
8010429e:	89 e5                	mov    %esp,%ebp
801042a0:	83 ec 28             	sub    $0x28,%esp
801042a3:	c7 04 24 a8 85 10 80 	movl   $0x801085a8,(%esp)
801042aa:	e8 fb c0 ff ff       	call   801003aa <cprintf>
801042af:	e8 ee fd ff ff       	call   801040a2 <allocproc>
801042b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ba:	a3 48 b6 10 80       	mov    %eax,0x8010b648
801042bf:	e8 a5 37 00 00       	call   80107a69 <setupkvm>
801042c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042c7:	89 42 04             	mov    %eax,0x4(%edx)
801042ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042cd:	8b 40 04             	mov    0x4(%eax),%eax
801042d0:	85 c0                	test   %eax,%eax
801042d2:	75 0c                	jne    801042e0 <userinit+0x43>
801042d4:	c7 04 24 b2 85 10 80 	movl   $0x801085b2,(%esp)
801042db:	e8 66 c2 ff ff       	call   80100546 <panic>
801042e0:	ba 2c 00 00 00       	mov    $0x2c,%edx
801042e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e8:	8b 40 04             	mov    0x4(%eax),%eax
801042eb:	89 54 24 08          	mov    %edx,0x8(%esp)
801042ef:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
801042f6:	80 
801042f7:	89 04 24             	mov    %eax,(%esp)
801042fa:	e8 c3 39 00 00       	call   80107cc2 <inituvm>
801042ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104302:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
80104308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010430b:	8b 40 18             	mov    0x18(%eax),%eax
8010430e:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104315:	00 
80104316:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010431d:	00 
8010431e:	89 04 24             	mov    %eax,(%esp)
80104321:	e8 48 0c 00 00       	call   80104f6e <memset>
80104326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104329:	8b 40 18             	mov    0x18(%eax),%eax
8010432c:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
80104332:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104335:	8b 40 18             	mov    0x18(%eax),%eax
80104338:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
8010433e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104341:	8b 40 18             	mov    0x18(%eax),%eax
80104344:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104347:	8b 52 18             	mov    0x18(%edx),%edx
8010434a:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010434e:	66 89 50 28          	mov    %dx,0x28(%eax)
80104352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104355:	8b 40 18             	mov    0x18(%eax),%eax
80104358:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010435b:	8b 52 18             	mov    0x18(%edx),%edx
8010435e:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104362:	66 89 50 48          	mov    %dx,0x48(%eax)
80104366:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104369:	8b 40 18             	mov    0x18(%eax),%eax
8010436c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
80104373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104376:	8b 40 18             	mov    0x18(%eax),%eax
80104379:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
80104380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104383:	8b 40 18             	mov    0x18(%eax),%eax
80104386:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
8010438d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104390:	83 c0 6c             	add    $0x6c,%eax
80104393:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010439a:	00 
8010439b:	c7 44 24 04 cb 85 10 	movl   $0x801085cb,0x4(%esp)
801043a2:	80 
801043a3:	89 04 24             	mov    %eax,(%esp)
801043a6:	e8 f6 0d 00 00       	call   801051a1 <safestrcpy>
801043ab:	c7 04 24 d4 85 10 80 	movl   $0x801085d4,(%esp)
801043b2:	e8 ce e0 ff ff       	call   80102485 <namei>
801043b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043ba:	89 42 68             	mov    %eax,0x68(%edx)
801043bd:	c7 04 24 d6 85 10 80 	movl   $0x801085d6,(%esp)
801043c4:	e8 e1 bf ff ff       	call   801003aa <cprintf>
801043c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043cc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801043d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043d6:	89 04 24             	mov    %eax,(%esp)
801043d9:	e8 8e fe ff ff       	call   8010426c <ready>
801043de:	c9                   	leave  
801043df:	c3                   	ret    

801043e0 <growproc>:
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	83 ec 28             	sub    $0x28,%esp
801043e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043ec:	8b 00                	mov    (%eax),%eax
801043ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801043f5:	7e 34                	jle    8010442b <growproc+0x4b>
801043f7:	8b 45 08             	mov    0x8(%ebp),%eax
801043fa:	89 c2                	mov    %eax,%edx
801043fc:	03 55 f4             	add    -0xc(%ebp),%edx
801043ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104405:	8b 40 04             	mov    0x4(%eax),%eax
80104408:	89 54 24 08          	mov    %edx,0x8(%esp)
8010440c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010440f:	89 54 24 04          	mov    %edx,0x4(%esp)
80104413:	89 04 24             	mov    %eax,(%esp)
80104416:	e8 22 3a 00 00       	call   80107e3d <allocuvm>
8010441b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010441e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104422:	75 41                	jne    80104465 <growproc+0x85>
80104424:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104429:	eb 58                	jmp    80104483 <growproc+0xa3>
8010442b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010442f:	79 34                	jns    80104465 <growproc+0x85>
80104431:	8b 45 08             	mov    0x8(%ebp),%eax
80104434:	89 c2                	mov    %eax,%edx
80104436:	03 55 f4             	add    -0xc(%ebp),%edx
80104439:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010443f:	8b 40 04             	mov    0x4(%eax),%eax
80104442:	89 54 24 08          	mov    %edx,0x8(%esp)
80104446:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104449:	89 54 24 04          	mov    %edx,0x4(%esp)
8010444d:	89 04 24             	mov    %eax,(%esp)
80104450:	e8 c2 3a 00 00       	call   80107f17 <deallocuvm>
80104455:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104458:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010445c:	75 07                	jne    80104465 <growproc+0x85>
8010445e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104463:	eb 1e                	jmp    80104483 <growproc+0xa3>
80104465:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010446b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010446e:	89 10                	mov    %edx,(%eax)
80104470:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104476:	89 04 24             	mov    %eax,(%esp)
80104479:	e8 dd 36 00 00       	call   80107b5b <switchuvm>
8010447e:	b8 00 00 00 00       	mov    $0x0,%eax
80104483:	c9                   	leave  
80104484:	c3                   	ret    

80104485 <fork>:
80104485:	55                   	push   %ebp
80104486:	89 e5                	mov    %esp,%ebp
80104488:	57                   	push   %edi
80104489:	56                   	push   %esi
8010448a:	53                   	push   %ebx
8010448b:	83 ec 2c             	sub    $0x2c,%esp
8010448e:	e8 0f fc ff ff       	call   801040a2 <allocproc>
80104493:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104496:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010449a:	75 0a                	jne    801044a6 <fork+0x21>
8010449c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044a1:	e9 45 01 00 00       	jmp    801045eb <fork+0x166>
801044a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044ac:	8b 10                	mov    (%eax),%edx
801044ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044b4:	8b 40 04             	mov    0x4(%eax),%eax
801044b7:	89 54 24 04          	mov    %edx,0x4(%esp)
801044bb:	89 04 24             	mov    %eax,(%esp)
801044be:	e8 e4 3b 00 00       	call   801080a7 <copyuvm>
801044c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801044c6:	89 42 04             	mov    %eax,0x4(%edx)
801044c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044cc:	8b 40 04             	mov    0x4(%eax),%eax
801044cf:	85 c0                	test   %eax,%eax
801044d1:	75 2c                	jne    801044ff <fork+0x7a>
801044d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044d6:	8b 40 08             	mov    0x8(%eax),%eax
801044d9:	89 04 24             	mov    %eax,(%esp)
801044dc:	e8 01 e6 ff ff       	call   80102ae2 <kfree>
801044e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
801044eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044ee:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
801044f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044fa:	e9 ec 00 00 00       	jmp    801045eb <fork+0x166>
801044ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104505:	8b 10                	mov    (%eax),%edx
80104507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010450a:	89 10                	mov    %edx,(%eax)
8010450c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104513:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104516:	89 50 14             	mov    %edx,0x14(%eax)
80104519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010451c:	8b 50 18             	mov    0x18(%eax),%edx
8010451f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104525:	8b 40 18             	mov    0x18(%eax),%eax
80104528:	89 c3                	mov    %eax,%ebx
8010452a:	b8 13 00 00 00       	mov    $0x13,%eax
8010452f:	89 d7                	mov    %edx,%edi
80104531:	89 de                	mov    %ebx,%esi
80104533:	89 c1                	mov    %eax,%ecx
80104535:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
80104537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010453a:	8b 40 18             	mov    0x18(%eax),%eax
8010453d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80104544:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
8010454b:	eb 3d                	jmp    8010458a <fork+0x105>
8010454d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104553:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104556:	83 c2 08             	add    $0x8,%edx
80104559:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010455d:	85 c0                	test   %eax,%eax
8010455f:	74 25                	je     80104586 <fork+0x101>
80104561:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80104564:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010456a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010456d:	83 c2 08             	add    $0x8,%edx
80104570:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104574:	89 04 24             	mov    %eax,(%esp)
80104577:	e8 58 ca ff ff       	call   80100fd4 <filedup>
8010457c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010457f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104582:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
80104586:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
8010458a:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
8010458e:	7e bd                	jle    8010454d <fork+0xc8>
80104590:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104596:	8b 40 68             	mov    0x68(%eax),%eax
80104599:	89 04 24             	mov    %eax,(%esp)
8010459c:	e8 f1 d2 ff ff       	call   80101892 <idup>
801045a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045a4:	89 42 68             	mov    %eax,0x68(%edx)
801045a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801045aa:	8b 40 10             	mov    0x10(%eax),%eax
801045ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
801045b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801045b3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801045ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801045bd:	89 04 24             	mov    %eax,(%esp)
801045c0:	e8 a7 fc ff ff       	call   8010426c <ready>
801045c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045cb:	8d 50 6c             	lea    0x6c(%eax),%edx
801045ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801045d1:	83 c0 6c             	add    $0x6c,%eax
801045d4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801045db:	00 
801045dc:	89 54 24 04          	mov    %edx,0x4(%esp)
801045e0:	89 04 24             	mov    %eax,(%esp)
801045e3:	e8 b9 0b 00 00       	call   801051a1 <safestrcpy>
801045e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045eb:	83 c4 2c             	add    $0x2c,%esp
801045ee:	5b                   	pop    %ebx
801045ef:	5e                   	pop    %esi
801045f0:	5f                   	pop    %edi
801045f1:	5d                   	pop    %ebp
801045f2:	c3                   	ret    

801045f3 <exit>:
801045f3:	55                   	push   %ebp
801045f4:	89 e5                	mov    %esp,%ebp
801045f6:	83 ec 28             	sub    $0x28,%esp
801045f9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104600:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104605:	39 c2                	cmp    %eax,%edx
80104607:	75 0c                	jne    80104615 <exit+0x22>
80104609:	c7 04 24 dc 85 10 80 	movl   $0x801085dc,(%esp)
80104610:	e8 31 bf ff ff       	call   80100546 <panic>
80104615:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010461c:	eb 44                	jmp    80104662 <exit+0x6f>
8010461e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104624:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104627:	83 c2 08             	add    $0x8,%edx
8010462a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010462e:	85 c0                	test   %eax,%eax
80104630:	74 2c                	je     8010465e <exit+0x6b>
80104632:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104638:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010463b:	83 c2 08             	add    $0x8,%edx
8010463e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104642:	89 04 24             	mov    %eax,(%esp)
80104645:	e8 d2 c9 ff ff       	call   8010101c <fileclose>
8010464a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104650:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104653:	83 c2 08             	add    $0x8,%edx
80104656:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010465d:	00 
8010465e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104662:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104666:	7e b6                	jle    8010461e <exit+0x2b>
80104668:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010466e:	8b 40 68             	mov    0x68(%eax),%eax
80104671:	89 04 24             	mov    %eax,(%esp)
80104674:	e8 fe d3 ff ff       	call   80101a77 <iput>
80104679:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010467f:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
80104686:	c7 04 24 e9 85 10 80 	movl   $0x801085e9,(%esp)
8010468d:	e8 18 bd ff ff       	call   801003aa <cprintf>
80104692:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104699:	e8 81 06 00 00       	call   80104d1f <acquire>
8010469e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046a4:	8b 40 14             	mov    0x14(%eax),%eax
801046a7:	89 04 24             	mov    %eax,(%esp)
801046aa:	e8 1c 04 00 00       	call   80104acb <wakeup1>
801046af:	c7 45 f0 14 00 11 80 	movl   $0x80110014,-0x10(%ebp)
801046b6:	eb 3b                	jmp    801046f3 <exit+0x100>
801046b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046bb:	8b 50 14             	mov    0x14(%eax),%edx
801046be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046c4:	39 c2                	cmp    %eax,%edx
801046c6:	75 24                	jne    801046ec <exit+0xf9>
801046c8:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
801046ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046d1:	89 50 14             	mov    %edx,0x14(%eax)
801046d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046d7:	8b 40 0c             	mov    0xc(%eax),%eax
801046da:	83 f8 05             	cmp    $0x5,%eax
801046dd:	75 0d                	jne    801046ec <exit+0xf9>
801046df:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801046e4:	89 04 24             	mov    %eax,(%esp)
801046e7:	e8 df 03 00 00       	call   80104acb <wakeup1>
801046ec:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
801046f3:	b8 14 22 11 80       	mov    $0x80112214,%eax
801046f8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801046fb:	72 bb                	jb     801046b8 <exit+0xc5>
801046fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104703:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
8010470a:	e8 03 02 00 00       	call   80104912 <sched>
8010470f:	c7 04 24 f6 85 10 80 	movl   $0x801085f6,(%esp)
80104716:	e8 2b be ff ff       	call   80100546 <panic>

8010471b <wait>:
8010471b:	55                   	push   %ebp
8010471c:	89 e5                	mov    %esp,%ebp
8010471e:	83 ec 28             	sub    $0x28,%esp
80104721:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104728:	e8 f2 05 00 00       	call   80104d1f <acquire>
8010472d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104734:	c7 45 ec 14 00 11 80 	movl   $0x80110014,-0x14(%ebp)
8010473b:	e9 9d 00 00 00       	jmp    801047dd <wait+0xc2>
80104740:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104743:	8b 50 14             	mov    0x14(%eax),%edx
80104746:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010474c:	39 c2                	cmp    %eax,%edx
8010474e:	0f 85 81 00 00 00    	jne    801047d5 <wait+0xba>
80104754:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
8010475b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010475e:	8b 40 0c             	mov    0xc(%eax),%eax
80104761:	83 f8 05             	cmp    $0x5,%eax
80104764:	75 70                	jne    801047d6 <wait+0xbb>
80104766:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104769:	8b 40 10             	mov    0x10(%eax),%eax
8010476c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010476f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104772:	8b 40 08             	mov    0x8(%eax),%eax
80104775:	89 04 24             	mov    %eax,(%esp)
80104778:	e8 65 e3 ff ff       	call   80102ae2 <kfree>
8010477d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104780:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80104787:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010478a:	8b 40 04             	mov    0x4(%eax),%eax
8010478d:	89 04 24             	mov    %eax,(%esp)
80104790:	e8 3e 38 00 00       	call   80107fd3 <freevm>
80104795:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104798:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
8010479f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047a2:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
801047a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047ac:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
801047b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047b6:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
801047ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047bd:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
801047c4:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801047cb:	e8 b0 05 00 00       	call   80104d80 <release>
801047d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d3:	eb 57                	jmp    8010482c <wait+0x111>
801047d5:	90                   	nop
801047d6:	81 45 ec 88 00 00 00 	addl   $0x88,-0x14(%ebp)
801047dd:	b8 14 22 11 80       	mov    $0x80112214,%eax
801047e2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801047e5:	0f 82 55 ff ff ff    	jb     80104740 <wait+0x25>
801047eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801047ef:	74 0d                	je     801047fe <wait+0xe3>
801047f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f7:	8b 40 24             	mov    0x24(%eax),%eax
801047fa:	85 c0                	test   %eax,%eax
801047fc:	74 13                	je     80104811 <wait+0xf6>
801047fe:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104805:	e8 76 05 00 00       	call   80104d80 <release>
8010480a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010480f:	eb 1b                	jmp    8010482c <wait+0x111>
80104811:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104817:	c7 44 24 04 e0 ff 10 	movl   $0x8010ffe0,0x4(%esp)
8010481e:	80 
8010481f:	89 04 24             	mov    %eax,(%esp)
80104822:	e8 09 02 00 00       	call   80104a30 <sleep>
80104827:	e9 01 ff ff ff       	jmp    8010472d <wait+0x12>
8010482c:	c9                   	leave  
8010482d:	c3                   	ret    

8010482e <scheduler>:
8010482e:	55                   	push   %ebp
8010482f:	89 e5                	mov    %esp,%ebp
80104831:	83 ec 28             	sub    $0x28,%esp
80104834:	e8 07 f8 ff ff       	call   80104040 <sti>
80104839:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104840:	e8 da 04 00 00       	call   80104d1f <acquire>
80104845:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010484c:	e9 a6 00 00 00       	jmp    801048f7 <scheduler+0xc9>
80104851:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104854:	83 c0 0c             	add    $0xc,%eax
80104857:	8b 04 85 24 ff 10 80 	mov    -0x7fef00dc(,%eax,4),%eax
8010485e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104861:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80104865:	0f 84 88 00 00 00    	je     801048f3 <scheduler+0xc5>
8010486b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010486e:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104874:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104877:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010487a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104881:	00 00 00 
80104884:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104888:	74 0a                	je     80104894 <scheduler+0x66>
8010488a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010488d:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
80104894:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104897:	8d 50 0c             	lea    0xc(%eax),%edx
8010489a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010489d:	89 04 95 24 ff 10 80 	mov    %eax,-0x7fef00dc(,%edx,4)
801048a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048a7:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
801048ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048b0:	89 04 24             	mov    %eax,(%esp)
801048b3:	e8 a3 32 00 00       	call   80107b5b <switchuvm>
801048b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048bb:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
801048c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c8:	8b 40 1c             	mov    0x1c(%eax),%eax
801048cb:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801048d2:	83 c2 04             	add    $0x4,%edx
801048d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801048d9:	89 14 24             	mov    %edx,(%esp)
801048dc:	e8 33 09 00 00       	call   80105214 <swtch>
801048e1:	e8 58 32 00 00       	call   80107b3e <switchkvm>
801048e6:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801048ed:	00 00 00 00 
801048f1:	eb 0e                	jmp    80104901 <scheduler+0xd3>
801048f3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801048f7:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
801048fb:	0f 8e 50 ff ff ff    	jle    80104851 <scheduler+0x23>
80104901:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104908:	e8 73 04 00 00       	call   80104d80 <release>
8010490d:	e9 22 ff ff ff       	jmp    80104834 <scheduler+0x6>

80104912 <sched>:
80104912:	55                   	push   %ebp
80104913:	89 e5                	mov    %esp,%ebp
80104915:	83 ec 28             	sub    $0x28,%esp
80104918:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
8010491f:	e8 1a 05 00 00       	call   80104e3e <holding>
80104924:	85 c0                	test   %eax,%eax
80104926:	75 0c                	jne    80104934 <sched+0x22>
80104928:	c7 04 24 02 86 10 80 	movl   $0x80108602,(%esp)
8010492f:	e8 12 bc ff ff       	call   80100546 <panic>
80104934:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010493a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104940:	83 f8 01             	cmp    $0x1,%eax
80104943:	74 0c                	je     80104951 <sched+0x3f>
80104945:	c7 04 24 14 86 10 80 	movl   $0x80108614,(%esp)
8010494c:	e8 f5 bb ff ff       	call   80100546 <panic>
80104951:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104957:	8b 40 0c             	mov    0xc(%eax),%eax
8010495a:	83 f8 04             	cmp    $0x4,%eax
8010495d:	75 0c                	jne    8010496b <sched+0x59>
8010495f:	c7 04 24 20 86 10 80 	movl   $0x80108620,(%esp)
80104966:	e8 db bb ff ff       	call   80100546 <panic>
8010496b:	e8 c0 f6 ff ff       	call   80104030 <readeflags>
80104970:	25 00 02 00 00       	and    $0x200,%eax
80104975:	85 c0                	test   %eax,%eax
80104977:	74 0c                	je     80104985 <sched+0x73>
80104979:	c7 04 24 2e 86 10 80 	movl   $0x8010862e,(%esp)
80104980:	e8 c1 bb ff ff       	call   80100546 <panic>
80104985:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010498b:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104991:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104994:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010499a:	8b 40 04             	mov    0x4(%eax),%eax
8010499d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049a4:	83 c2 1c             	add    $0x1c,%edx
801049a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801049ab:	89 14 24             	mov    %edx,(%esp)
801049ae:	e8 61 08 00 00       	call   80105214 <swtch>
801049b3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801049b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049bc:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
801049c2:	c9                   	leave  
801049c3:	c3                   	ret    

801049c4 <yield>:
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	83 ec 18             	sub    $0x18,%esp
801049ca:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801049d1:	e8 49 03 00 00       	call   80104d1f <acquire>
801049d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049dc:	89 04 24             	mov    %eax,(%esp)
801049df:	e8 e5 f7 ff ff       	call   801041c9 <ready1>
801049e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ea:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801049f1:	e8 1c ff ff ff       	call   80104912 <sched>
801049f6:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801049fd:	e8 7e 03 00 00       	call   80104d80 <release>
80104a02:	c9                   	leave  
80104a03:	c3                   	ret    

80104a04 <forkret>:
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	83 ec 18             	sub    $0x18,%esp
80104a0a:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104a11:	e8 6a 03 00 00       	call   80104d80 <release>
80104a16:	a1 20 b0 10 80       	mov    0x8010b020,%eax
80104a1b:	85 c0                	test   %eax,%eax
80104a1d:	74 0f                	je     80104a2e <forkret+0x2a>
80104a1f:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
80104a26:	00 00 00 
80104a29:	e8 46 e6 ff ff       	call   80103074 <initlog>
80104a2e:	c9                   	leave  
80104a2f:	c3                   	ret    

80104a30 <sleep>:
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	83 ec 18             	sub    $0x18,%esp
80104a36:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a3c:	85 c0                	test   %eax,%eax
80104a3e:	75 0c                	jne    80104a4c <sleep+0x1c>
80104a40:	c7 04 24 42 86 10 80 	movl   $0x80108642,(%esp)
80104a47:	e8 fa ba ff ff       	call   80100546 <panic>
80104a4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104a50:	75 0c                	jne    80104a5e <sleep+0x2e>
80104a52:	c7 04 24 48 86 10 80 	movl   $0x80108648,(%esp)
80104a59:	e8 e8 ba ff ff       	call   80100546 <panic>
80104a5e:	81 7d 0c e0 ff 10 80 	cmpl   $0x8010ffe0,0xc(%ebp)
80104a65:	74 17                	je     80104a7e <sleep+0x4e>
80104a67:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104a6e:	e8 ac 02 00 00       	call   80104d1f <acquire>
80104a73:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a76:	89 04 24             	mov    %eax,(%esp)
80104a79:	e8 02 03 00 00       	call   80104d80 <release>
80104a7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a84:	8b 55 08             	mov    0x8(%ebp),%edx
80104a87:	89 50 20             	mov    %edx,0x20(%eax)
80104a8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a90:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
80104a97:	e8 76 fe ff ff       	call   80104912 <sched>
80104a9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa2:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
80104aa9:	81 7d 0c e0 ff 10 80 	cmpl   $0x8010ffe0,0xc(%ebp)
80104ab0:	74 17                	je     80104ac9 <sleep+0x99>
80104ab2:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104ab9:	e8 c2 02 00 00       	call   80104d80 <release>
80104abe:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ac1:	89 04 24             	mov    %eax,(%esp)
80104ac4:	e8 56 02 00 00       	call   80104d1f <acquire>
80104ac9:	c9                   	leave  
80104aca:	c3                   	ret    

80104acb <wakeup1>:
80104acb:	55                   	push   %ebp
80104acc:	89 e5                	mov    %esp,%ebp
80104ace:	83 ec 14             	sub    $0x14,%esp
80104ad1:	c7 45 fc 14 00 11 80 	movl   $0x80110014,-0x4(%ebp)
80104ad8:	eb 32                	jmp    80104b0c <wakeup1+0x41>
80104ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104add:	8b 40 0c             	mov    0xc(%eax),%eax
80104ae0:	83 f8 02             	cmp    $0x2,%eax
80104ae3:	75 20                	jne    80104b05 <wakeup1+0x3a>
80104ae5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ae8:	8b 40 20             	mov    0x20(%eax),%eax
80104aeb:	3b 45 08             	cmp    0x8(%ebp),%eax
80104aee:	75 15                	jne    80104b05 <wakeup1+0x3a>
80104af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104af3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104afd:	89 04 24             	mov    %eax,(%esp)
80104b00:	e8 c4 f6 ff ff       	call   801041c9 <ready1>
80104b05:	81 45 fc 88 00 00 00 	addl   $0x88,-0x4(%ebp)
80104b0c:	b8 14 22 11 80       	mov    $0x80112214,%eax
80104b11:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80104b14:	72 c4                	jb     80104ada <wakeup1+0xf>
80104b16:	c9                   	leave  
80104b17:	c3                   	ret    

80104b18 <wakeup>:
80104b18:	55                   	push   %ebp
80104b19:	89 e5                	mov    %esp,%ebp
80104b1b:	83 ec 18             	sub    $0x18,%esp
80104b1e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104b25:	e8 f5 01 00 00       	call   80104d1f <acquire>
80104b2a:	8b 45 08             	mov    0x8(%ebp),%eax
80104b2d:	89 04 24             	mov    %eax,(%esp)
80104b30:	e8 96 ff ff ff       	call   80104acb <wakeup1>
80104b35:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104b3c:	e8 3f 02 00 00       	call   80104d80 <release>
80104b41:	c9                   	leave  
80104b42:	c3                   	ret    

80104b43 <kill>:
80104b43:	55                   	push   %ebp
80104b44:	89 e5                	mov    %esp,%ebp
80104b46:	83 ec 28             	sub    $0x28,%esp
80104b49:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104b50:	e8 ca 01 00 00       	call   80104d1f <acquire>
80104b55:	c7 45 f4 14 00 11 80 	movl   $0x80110014,-0xc(%ebp)
80104b5c:	eb 4f                	jmp    80104bad <kill+0x6a>
80104b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b61:	8b 40 10             	mov    0x10(%eax),%eax
80104b64:	3b 45 08             	cmp    0x8(%ebp),%eax
80104b67:	75 3d                	jne    80104ba6 <kill+0x63>
80104b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b6c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80104b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b76:	8b 40 0c             	mov    0xc(%eax),%eax
80104b79:	83 f8 02             	cmp    $0x2,%eax
80104b7c:	75 15                	jne    80104b93 <kill+0x50>
80104b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b81:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8b:	89 04 24             	mov    %eax,(%esp)
80104b8e:	e8 36 f6 ff ff       	call   801041c9 <ready1>
80104b93:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104b9a:	e8 e1 01 00 00       	call   80104d80 <release>
80104b9f:	b8 00 00 00 00       	mov    $0x0,%eax
80104ba4:	eb 22                	jmp    80104bc8 <kill+0x85>
80104ba6:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104bad:	b8 14 22 11 80       	mov    $0x80112214,%eax
80104bb2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104bb5:	72 a7                	jb     80104b5e <kill+0x1b>
80104bb7:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80104bbe:	e8 bd 01 00 00       	call   80104d80 <release>
80104bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc8:	c9                   	leave  
80104bc9:	c3                   	ret    

80104bca <procdump>:
80104bca:	55                   	push   %ebp
80104bcb:	89 e5                	mov    %esp,%ebp
80104bcd:	83 ec 58             	sub    $0x58,%esp
80104bd0:	c7 45 f0 14 00 11 80 	movl   $0x80110014,-0x10(%ebp)
80104bd7:	e9 db 00 00 00       	jmp    80104cb7 <procdump+0xed>
80104bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bdf:	8b 40 0c             	mov    0xc(%eax),%eax
80104be2:	85 c0                	test   %eax,%eax
80104be4:	0f 84 c5 00 00 00    	je     80104caf <procdump+0xe5>
80104bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bed:	8b 40 0c             	mov    0xc(%eax),%eax
80104bf0:	83 f8 05             	cmp    $0x5,%eax
80104bf3:	77 23                	ja     80104c18 <procdump+0x4e>
80104bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bf8:	8b 40 0c             	mov    0xc(%eax),%eax
80104bfb:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104c02:	85 c0                	test   %eax,%eax
80104c04:	74 12                	je     80104c18 <procdump+0x4e>
80104c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c09:	8b 40 0c             	mov    0xc(%eax),%eax
80104c0c:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104c13:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104c16:	eb 07                	jmp    80104c1f <procdump+0x55>
80104c18:	c7 45 f4 59 86 10 80 	movl   $0x80108659,-0xc(%ebp)
80104c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c22:	8d 50 6c             	lea    0x6c(%eax),%edx
80104c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c28:	8b 40 10             	mov    0x10(%eax),%eax
80104c2b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c32:	89 54 24 08          	mov    %edx,0x8(%esp)
80104c36:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c3a:	c7 04 24 5d 86 10 80 	movl   $0x8010865d,(%esp)
80104c41:	e8 64 b7 ff ff       	call   801003aa <cprintf>
80104c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c49:	8b 40 0c             	mov    0xc(%eax),%eax
80104c4c:	83 f8 02             	cmp    $0x2,%eax
80104c4f:	75 50                	jne    80104ca1 <procdump+0xd7>
80104c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c54:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c57:	8b 40 0c             	mov    0xc(%eax),%eax
80104c5a:	83 c0 08             	add    $0x8,%eax
80104c5d:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104c60:	89 54 24 04          	mov    %edx,0x4(%esp)
80104c64:	89 04 24             	mov    %eax,(%esp)
80104c67:	e8 63 01 00 00       	call   80104dcf <getcallerpcs>
80104c6c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104c73:	eb 1b                	jmp    80104c90 <procdump+0xc6>
80104c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c78:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c80:	c7 04 24 66 86 10 80 	movl   $0x80108666,(%esp)
80104c87:	e8 1e b7 ff ff       	call   801003aa <cprintf>
80104c8c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104c90:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
80104c94:	7f 0b                	jg     80104ca1 <procdump+0xd7>
80104c96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c99:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c9d:	85 c0                	test   %eax,%eax
80104c9f:	75 d4                	jne    80104c75 <procdump+0xab>
80104ca1:	c7 04 24 6a 86 10 80 	movl   $0x8010866a,(%esp)
80104ca8:	e8 fd b6 ff ff       	call   801003aa <cprintf>
80104cad:	eb 01                	jmp    80104cb0 <procdump+0xe6>
80104caf:	90                   	nop
80104cb0:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
80104cb7:	b8 14 22 11 80       	mov    $0x80112214,%eax
80104cbc:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104cbf:	0f 82 17 ff ff ff    	jb     80104bdc <procdump+0x12>
80104cc5:	c9                   	leave  
80104cc6:	c3                   	ret    
80104cc7:	90                   	nop

80104cc8 <readeflags>:
80104cc8:	55                   	push   %ebp
80104cc9:	89 e5                	mov    %esp,%ebp
80104ccb:	83 ec 10             	sub    $0x10,%esp
80104cce:	9c                   	pushf  
80104ccf:	58                   	pop    %eax
80104cd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104cd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cd6:	c9                   	leave  
80104cd7:	c3                   	ret    

80104cd8 <cli>:
80104cd8:	55                   	push   %ebp
80104cd9:	89 e5                	mov    %esp,%ebp
80104cdb:	fa                   	cli    
80104cdc:	5d                   	pop    %ebp
80104cdd:	c3                   	ret    

80104cde <sti>:
80104cde:	55                   	push   %ebp
80104cdf:	89 e5                	mov    %esp,%ebp
80104ce1:	fb                   	sti    
80104ce2:	5d                   	pop    %ebp
80104ce3:	c3                   	ret    

80104ce4 <xchg>:
80104ce4:	55                   	push   %ebp
80104ce5:	89 e5                	mov    %esp,%ebp
80104ce7:	83 ec 10             	sub    $0x10,%esp
80104cea:	8b 55 08             	mov    0x8(%ebp),%edx
80104ced:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cf0:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cf3:	f0 87 02             	lock xchg %eax,(%edx)
80104cf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cfc:	c9                   	leave  
80104cfd:	c3                   	ret    

80104cfe <initlock>:
80104cfe:	55                   	push   %ebp
80104cff:	89 e5                	mov    %esp,%ebp
80104d01:	8b 45 08             	mov    0x8(%ebp),%eax
80104d04:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d07:	89 50 04             	mov    %edx,0x4(%eax)
80104d0a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d13:	8b 45 08             	mov    0x8(%ebp),%eax
80104d16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80104d1d:	5d                   	pop    %ebp
80104d1e:	c3                   	ret    

80104d1f <acquire>:
80104d1f:	55                   	push   %ebp
80104d20:	89 e5                	mov    %esp,%ebp
80104d22:	83 ec 18             	sub    $0x18,%esp
80104d25:	e8 3e 01 00 00       	call   80104e68 <pushcli>
80104d2a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d2d:	89 04 24             	mov    %eax,(%esp)
80104d30:	e8 09 01 00 00       	call   80104e3e <holding>
80104d35:	85 c0                	test   %eax,%eax
80104d37:	74 0c                	je     80104d45 <acquire+0x26>
80104d39:	c7 04 24 96 86 10 80 	movl   $0x80108696,(%esp)
80104d40:	e8 01 b8 ff ff       	call   80100546 <panic>
80104d45:	8b 45 08             	mov    0x8(%ebp),%eax
80104d48:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104d4f:	00 
80104d50:	89 04 24             	mov    %eax,(%esp)
80104d53:	e8 8c ff ff ff       	call   80104ce4 <xchg>
80104d58:	85 c0                	test   %eax,%eax
80104d5a:	75 e9                	jne    80104d45 <acquire+0x26>
80104d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80104d5f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104d66:	89 50 08             	mov    %edx,0x8(%eax)
80104d69:	8b 45 08             	mov    0x8(%ebp),%eax
80104d6c:	83 c0 0c             	add    $0xc,%eax
80104d6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d73:	8d 45 08             	lea    0x8(%ebp),%eax
80104d76:	89 04 24             	mov    %eax,(%esp)
80104d79:	e8 51 00 00 00       	call   80104dcf <getcallerpcs>
80104d7e:	c9                   	leave  
80104d7f:	c3                   	ret    

80104d80 <release>:
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	83 ec 18             	sub    $0x18,%esp
80104d86:	8b 45 08             	mov    0x8(%ebp),%eax
80104d89:	89 04 24             	mov    %eax,(%esp)
80104d8c:	e8 ad 00 00 00       	call   80104e3e <holding>
80104d91:	85 c0                	test   %eax,%eax
80104d93:	75 0c                	jne    80104da1 <release+0x21>
80104d95:	c7 04 24 9e 86 10 80 	movl   $0x8010869e,(%esp)
80104d9c:	e8 a5 b7 ff ff       	call   80100546 <panic>
80104da1:	8b 45 08             	mov    0x8(%ebp),%eax
80104da4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
80104dab:	8b 45 08             	mov    0x8(%ebp),%eax
80104dae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80104db5:	8b 45 08             	mov    0x8(%ebp),%eax
80104db8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104dbf:	00 
80104dc0:	89 04 24             	mov    %eax,(%esp)
80104dc3:	e8 1c ff ff ff       	call   80104ce4 <xchg>
80104dc8:	e8 e3 00 00 00       	call   80104eb0 <popcli>
80104dcd:	c9                   	leave  
80104dce:	c3                   	ret    

80104dcf <getcallerpcs>:
80104dcf:	55                   	push   %ebp
80104dd0:	89 e5                	mov    %esp,%ebp
80104dd2:	83 ec 10             	sub    $0x10,%esp
80104dd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd8:	83 e8 08             	sub    $0x8,%eax
80104ddb:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104dde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104de5:	eb 34                	jmp    80104e1b <getcallerpcs+0x4c>
80104de7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
80104deb:	74 49                	je     80104e36 <getcallerpcs+0x67>
80104ded:	81 7d f8 ff ff ff 7f 	cmpl   $0x7fffffff,-0x8(%ebp)
80104df4:	76 40                	jbe    80104e36 <getcallerpcs+0x67>
80104df6:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%ebp)
80104dfa:	74 3a                	je     80104e36 <getcallerpcs+0x67>
80104dfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dff:	c1 e0 02             	shl    $0x2,%eax
80104e02:	03 45 0c             	add    0xc(%ebp),%eax
80104e05:	8b 55 f8             	mov    -0x8(%ebp),%edx
80104e08:	83 c2 04             	add    $0x4,%edx
80104e0b:	8b 12                	mov    (%edx),%edx
80104e0d:	89 10                	mov    %edx,(%eax)
80104e0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e12:	8b 00                	mov    (%eax),%eax
80104e14:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104e17:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e1b:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
80104e1f:	7e c6                	jle    80104de7 <getcallerpcs+0x18>
80104e21:	eb 13                	jmp    80104e36 <getcallerpcs+0x67>
80104e23:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e26:	c1 e0 02             	shl    $0x2,%eax
80104e29:	03 45 0c             	add    0xc(%ebp),%eax
80104e2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104e32:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e36:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
80104e3a:	7e e7                	jle    80104e23 <getcallerpcs+0x54>
80104e3c:	c9                   	leave  
80104e3d:	c3                   	ret    

80104e3e <holding>:
80104e3e:	55                   	push   %ebp
80104e3f:	89 e5                	mov    %esp,%ebp
80104e41:	8b 45 08             	mov    0x8(%ebp),%eax
80104e44:	8b 00                	mov    (%eax),%eax
80104e46:	85 c0                	test   %eax,%eax
80104e48:	74 17                	je     80104e61 <holding+0x23>
80104e4a:	8b 45 08             	mov    0x8(%ebp),%eax
80104e4d:	8b 50 08             	mov    0x8(%eax),%edx
80104e50:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e56:	39 c2                	cmp    %eax,%edx
80104e58:	75 07                	jne    80104e61 <holding+0x23>
80104e5a:	b8 01 00 00 00       	mov    $0x1,%eax
80104e5f:	eb 05                	jmp    80104e66 <holding+0x28>
80104e61:	b8 00 00 00 00       	mov    $0x0,%eax
80104e66:	5d                   	pop    %ebp
80104e67:	c3                   	ret    

80104e68 <pushcli>:
80104e68:	55                   	push   %ebp
80104e69:	89 e5                	mov    %esp,%ebp
80104e6b:	83 ec 10             	sub    $0x10,%esp
80104e6e:	e8 55 fe ff ff       	call   80104cc8 <readeflags>
80104e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104e76:	e8 5d fe ff ff       	call   80104cd8 <cli>
80104e7b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e81:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104e87:	85 d2                	test   %edx,%edx
80104e89:	0f 94 c1             	sete   %cl
80104e8c:	83 c2 01             	add    $0x1,%edx
80104e8f:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104e95:	84 c9                	test   %cl,%cl
80104e97:	74 15                	je     80104eae <pushcli+0x46>
80104e99:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104ea2:	81 e2 00 02 00 00    	and    $0x200,%edx
80104ea8:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
80104eae:	c9                   	leave  
80104eaf:	c3                   	ret    

80104eb0 <popcli>:
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	83 ec 18             	sub    $0x18,%esp
80104eb6:	e8 0d fe ff ff       	call   80104cc8 <readeflags>
80104ebb:	25 00 02 00 00       	and    $0x200,%eax
80104ec0:	85 c0                	test   %eax,%eax
80104ec2:	74 0c                	je     80104ed0 <popcli+0x20>
80104ec4:	c7 04 24 a6 86 10 80 	movl   $0x801086a6,(%esp)
80104ecb:	e8 76 b6 ff ff       	call   80100546 <panic>
80104ed0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ed6:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104edc:	83 ea 01             	sub    $0x1,%edx
80104edf:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104ee5:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104eeb:	85 c0                	test   %eax,%eax
80104eed:	79 0c                	jns    80104efb <popcli+0x4b>
80104eef:	c7 04 24 bd 86 10 80 	movl   $0x801086bd,(%esp)
80104ef6:	e8 4b b6 ff ff       	call   80100546 <panic>
80104efb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f01:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104f07:	85 c0                	test   %eax,%eax
80104f09:	75 15                	jne    80104f20 <popcli+0x70>
80104f0b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f11:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104f17:	85 c0                	test   %eax,%eax
80104f19:	74 05                	je     80104f20 <popcli+0x70>
80104f1b:	e8 be fd ff ff       	call   80104cde <sti>
80104f20:	c9                   	leave  
80104f21:	c3                   	ret    
80104f22:	66 90                	xchg   %ax,%ax

80104f24 <stosb>:
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	57                   	push   %edi
80104f28:	53                   	push   %ebx
80104f29:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f2c:	8b 55 10             	mov    0x10(%ebp),%edx
80104f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f32:	89 cb                	mov    %ecx,%ebx
80104f34:	89 df                	mov    %ebx,%edi
80104f36:	89 d1                	mov    %edx,%ecx
80104f38:	fc                   	cld    
80104f39:	f3 aa                	rep stos %al,%es:(%edi)
80104f3b:	89 ca                	mov    %ecx,%edx
80104f3d:	89 fb                	mov    %edi,%ebx
80104f3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104f42:	89 55 10             	mov    %edx,0x10(%ebp)
80104f45:	5b                   	pop    %ebx
80104f46:	5f                   	pop    %edi
80104f47:	5d                   	pop    %ebp
80104f48:	c3                   	ret    

80104f49 <stosl>:
80104f49:	55                   	push   %ebp
80104f4a:	89 e5                	mov    %esp,%ebp
80104f4c:	57                   	push   %edi
80104f4d:	53                   	push   %ebx
80104f4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f51:	8b 55 10             	mov    0x10(%ebp),%edx
80104f54:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f57:	89 cb                	mov    %ecx,%ebx
80104f59:	89 df                	mov    %ebx,%edi
80104f5b:	89 d1                	mov    %edx,%ecx
80104f5d:	fc                   	cld    
80104f5e:	f3 ab                	rep stos %eax,%es:(%edi)
80104f60:	89 ca                	mov    %ecx,%edx
80104f62:	89 fb                	mov    %edi,%ebx
80104f64:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104f67:	89 55 10             	mov    %edx,0x10(%ebp)
80104f6a:	5b                   	pop    %ebx
80104f6b:	5f                   	pop    %edi
80104f6c:	5d                   	pop    %ebp
80104f6d:	c3                   	ret    

80104f6e <memset>:
80104f6e:	55                   	push   %ebp
80104f6f:	89 e5                	mov    %esp,%ebp
80104f71:	83 ec 0c             	sub    $0xc,%esp
80104f74:	8b 45 08             	mov    0x8(%ebp),%eax
80104f77:	83 e0 03             	and    $0x3,%eax
80104f7a:	85 c0                	test   %eax,%eax
80104f7c:	75 49                	jne    80104fc7 <memset+0x59>
80104f7e:	8b 45 10             	mov    0x10(%ebp),%eax
80104f81:	83 e0 03             	and    $0x3,%eax
80104f84:	85 c0                	test   %eax,%eax
80104f86:	75 3f                	jne    80104fc7 <memset+0x59>
80104f88:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
80104f8f:	8b 45 10             	mov    0x10(%ebp),%eax
80104f92:	c1 e8 02             	shr    $0x2,%eax
80104f95:	89 c2                	mov    %eax,%edx
80104f97:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f9a:	89 c1                	mov    %eax,%ecx
80104f9c:	c1 e1 18             	shl    $0x18,%ecx
80104f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fa2:	c1 e0 10             	shl    $0x10,%eax
80104fa5:	09 c1                	or     %eax,%ecx
80104fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104faa:	c1 e0 08             	shl    $0x8,%eax
80104fad:	09 c8                	or     %ecx,%eax
80104faf:	0b 45 0c             	or     0xc(%ebp),%eax
80104fb2:	89 54 24 08          	mov    %edx,0x8(%esp)
80104fb6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fba:	8b 45 08             	mov    0x8(%ebp),%eax
80104fbd:	89 04 24             	mov    %eax,(%esp)
80104fc0:	e8 84 ff ff ff       	call   80104f49 <stosl>
80104fc5:	eb 19                	jmp    80104fe0 <memset+0x72>
80104fc7:	8b 45 10             	mov    0x10(%ebp),%eax
80104fca:	89 44 24 08          	mov    %eax,0x8(%esp)
80104fce:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fd1:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd8:	89 04 24             	mov    %eax,(%esp)
80104fdb:	e8 44 ff ff ff       	call   80104f24 <stosb>
80104fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe3:	c9                   	leave  
80104fe4:	c3                   	ret    

80104fe5 <memcmp>:
80104fe5:	55                   	push   %ebp
80104fe6:	89 e5                	mov    %esp,%ebp
80104fe8:	83 ec 10             	sub    $0x10,%esp
80104feb:	8b 45 08             	mov    0x8(%ebp),%eax
80104fee:	89 45 f8             	mov    %eax,-0x8(%ebp)
80104ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ff4:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104ff7:	eb 32                	jmp    8010502b <memcmp+0x46>
80104ff9:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ffc:	0f b6 10             	movzbl (%eax),%edx
80104fff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105002:	0f b6 00             	movzbl (%eax),%eax
80105005:	38 c2                	cmp    %al,%dl
80105007:	74 1a                	je     80105023 <memcmp+0x3e>
80105009:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010500c:	0f b6 00             	movzbl (%eax),%eax
8010500f:	0f b6 d0             	movzbl %al,%edx
80105012:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105015:	0f b6 00             	movzbl (%eax),%eax
80105018:	0f b6 c0             	movzbl %al,%eax
8010501b:	89 d1                	mov    %edx,%ecx
8010501d:	29 c1                	sub    %eax,%ecx
8010501f:	89 c8                	mov    %ecx,%eax
80105021:	eb 1c                	jmp    8010503f <memcmp+0x5a>
80105023:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105027:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010502b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010502f:	0f 95 c0             	setne  %al
80105032:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105036:	84 c0                	test   %al,%al
80105038:	75 bf                	jne    80104ff9 <memcmp+0x14>
8010503a:	b8 00 00 00 00       	mov    $0x0,%eax
8010503f:	c9                   	leave  
80105040:	c3                   	ret    

80105041 <memmove>:
80105041:	55                   	push   %ebp
80105042:	89 e5                	mov    %esp,%ebp
80105044:	83 ec 10             	sub    $0x10,%esp
80105047:	8b 45 0c             	mov    0xc(%ebp),%eax
8010504a:	89 45 f8             	mov    %eax,-0x8(%ebp)
8010504d:	8b 45 08             	mov    0x8(%ebp),%eax
80105050:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105053:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105056:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105059:	73 55                	jae    801050b0 <memmove+0x6f>
8010505b:	8b 45 10             	mov    0x10(%ebp),%eax
8010505e:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105061:	8d 04 02             	lea    (%edx,%eax,1),%eax
80105064:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105067:	76 4a                	jbe    801050b3 <memmove+0x72>
80105069:	8b 45 10             	mov    0x10(%ebp),%eax
8010506c:	01 45 f8             	add    %eax,-0x8(%ebp)
8010506f:	8b 45 10             	mov    0x10(%ebp),%eax
80105072:	01 45 fc             	add    %eax,-0x4(%ebp)
80105075:	eb 13                	jmp    8010508a <memmove+0x49>
80105077:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010507b:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010507f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105082:	0f b6 10             	movzbl (%eax),%edx
80105085:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105088:	88 10                	mov    %dl,(%eax)
8010508a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010508e:	0f 95 c0             	setne  %al
80105091:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105095:	84 c0                	test   %al,%al
80105097:	75 de                	jne    80105077 <memmove+0x36>
80105099:	eb 28                	jmp    801050c3 <memmove+0x82>
8010509b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010509e:	0f b6 10             	movzbl (%eax),%edx
801050a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050a4:	88 10                	mov    %dl,(%eax)
801050a6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801050aa:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801050ae:	eb 04                	jmp    801050b4 <memmove+0x73>
801050b0:	90                   	nop
801050b1:	eb 01                	jmp    801050b4 <memmove+0x73>
801050b3:	90                   	nop
801050b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050b8:	0f 95 c0             	setne  %al
801050bb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801050bf:	84 c0                	test   %al,%al
801050c1:	75 d8                	jne    8010509b <memmove+0x5a>
801050c3:	8b 45 08             	mov    0x8(%ebp),%eax
801050c6:	c9                   	leave  
801050c7:	c3                   	ret    

801050c8 <memcpy>:
801050c8:	55                   	push   %ebp
801050c9:	89 e5                	mov    %esp,%ebp
801050cb:	83 ec 0c             	sub    $0xc,%esp
801050ce:	8b 45 10             	mov    0x10(%ebp),%eax
801050d1:	89 44 24 08          	mov    %eax,0x8(%esp)
801050d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801050d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801050dc:	8b 45 08             	mov    0x8(%ebp),%eax
801050df:	89 04 24             	mov    %eax,(%esp)
801050e2:	e8 5a ff ff ff       	call   80105041 <memmove>
801050e7:	c9                   	leave  
801050e8:	c3                   	ret    

801050e9 <strncmp>:
801050e9:	55                   	push   %ebp
801050ea:	89 e5                	mov    %esp,%ebp
801050ec:	eb 0c                	jmp    801050fa <strncmp+0x11>
801050ee:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801050f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801050f6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801050fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050fe:	74 1a                	je     8010511a <strncmp+0x31>
80105100:	8b 45 08             	mov    0x8(%ebp),%eax
80105103:	0f b6 00             	movzbl (%eax),%eax
80105106:	84 c0                	test   %al,%al
80105108:	74 10                	je     8010511a <strncmp+0x31>
8010510a:	8b 45 08             	mov    0x8(%ebp),%eax
8010510d:	0f b6 10             	movzbl (%eax),%edx
80105110:	8b 45 0c             	mov    0xc(%ebp),%eax
80105113:	0f b6 00             	movzbl (%eax),%eax
80105116:	38 c2                	cmp    %al,%dl
80105118:	74 d4                	je     801050ee <strncmp+0x5>
8010511a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010511e:	75 07                	jne    80105127 <strncmp+0x3e>
80105120:	b8 00 00 00 00       	mov    $0x0,%eax
80105125:	eb 18                	jmp    8010513f <strncmp+0x56>
80105127:	8b 45 08             	mov    0x8(%ebp),%eax
8010512a:	0f b6 00             	movzbl (%eax),%eax
8010512d:	0f b6 d0             	movzbl %al,%edx
80105130:	8b 45 0c             	mov    0xc(%ebp),%eax
80105133:	0f b6 00             	movzbl (%eax),%eax
80105136:	0f b6 c0             	movzbl %al,%eax
80105139:	89 d1                	mov    %edx,%ecx
8010513b:	29 c1                	sub    %eax,%ecx
8010513d:	89 c8                	mov    %ecx,%eax
8010513f:	5d                   	pop    %ebp
80105140:	c3                   	ret    

80105141 <strncpy>:
80105141:	55                   	push   %ebp
80105142:	89 e5                	mov    %esp,%ebp
80105144:	83 ec 10             	sub    $0x10,%esp
80105147:	8b 45 08             	mov    0x8(%ebp),%eax
8010514a:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010514d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105151:	0f 9f c0             	setg   %al
80105154:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105158:	84 c0                	test   %al,%al
8010515a:	74 30                	je     8010518c <strncpy+0x4b>
8010515c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010515f:	0f b6 10             	movzbl (%eax),%edx
80105162:	8b 45 08             	mov    0x8(%ebp),%eax
80105165:	88 10                	mov    %dl,(%eax)
80105167:	8b 45 08             	mov    0x8(%ebp),%eax
8010516a:	0f b6 00             	movzbl (%eax),%eax
8010516d:	84 c0                	test   %al,%al
8010516f:	0f 95 c0             	setne  %al
80105172:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105176:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010517a:	84 c0                	test   %al,%al
8010517c:	75 cf                	jne    8010514d <strncpy+0xc>
8010517e:	eb 0d                	jmp    8010518d <strncpy+0x4c>
80105180:	8b 45 08             	mov    0x8(%ebp),%eax
80105183:	c6 00 00             	movb   $0x0,(%eax)
80105186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010518a:	eb 01                	jmp    8010518d <strncpy+0x4c>
8010518c:	90                   	nop
8010518d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105191:	0f 9f c0             	setg   %al
80105194:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105198:	84 c0                	test   %al,%al
8010519a:	75 e4                	jne    80105180 <strncpy+0x3f>
8010519c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010519f:	c9                   	leave  
801051a0:	c3                   	ret    

801051a1 <safestrcpy>:
801051a1:	55                   	push   %ebp
801051a2:	89 e5                	mov    %esp,%ebp
801051a4:	83 ec 10             	sub    $0x10,%esp
801051a7:	8b 45 08             	mov    0x8(%ebp),%eax
801051aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
801051ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801051b1:	7f 05                	jg     801051b8 <safestrcpy+0x17>
801051b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051b6:	eb 35                	jmp    801051ed <safestrcpy+0x4c>
801051b8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801051bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801051c0:	7e 22                	jle    801051e4 <safestrcpy+0x43>
801051c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801051c5:	0f b6 10             	movzbl (%eax),%edx
801051c8:	8b 45 08             	mov    0x8(%ebp),%eax
801051cb:	88 10                	mov    %dl,(%eax)
801051cd:	8b 45 08             	mov    0x8(%ebp),%eax
801051d0:	0f b6 00             	movzbl (%eax),%eax
801051d3:	84 c0                	test   %al,%al
801051d5:	0f 95 c0             	setne  %al
801051d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801051dc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801051e0:	84 c0                	test   %al,%al
801051e2:	75 d4                	jne    801051b8 <safestrcpy+0x17>
801051e4:	8b 45 08             	mov    0x8(%ebp),%eax
801051e7:	c6 00 00             	movb   $0x0,(%eax)
801051ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051ed:	c9                   	leave  
801051ee:	c3                   	ret    

801051ef <strlen>:
801051ef:	55                   	push   %ebp
801051f0:	89 e5                	mov    %esp,%ebp
801051f2:	83 ec 10             	sub    $0x10,%esp
801051f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801051fc:	eb 04                	jmp    80105202 <strlen+0x13>
801051fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105202:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105205:	03 45 08             	add    0x8(%ebp),%eax
80105208:	0f b6 00             	movzbl (%eax),%eax
8010520b:	84 c0                	test   %al,%al
8010520d:	75 ef                	jne    801051fe <strlen+0xf>
8010520f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105212:	c9                   	leave  
80105213:	c3                   	ret    

80105214 <swtch>:
80105214:	8b 44 24 04          	mov    0x4(%esp),%eax
80105218:	8b 54 24 08          	mov    0x8(%esp),%edx
8010521c:	55                   	push   %ebp
8010521d:	53                   	push   %ebx
8010521e:	56                   	push   %esi
8010521f:	57                   	push   %edi
80105220:	89 20                	mov    %esp,(%eax)
80105222:	89 d4                	mov    %edx,%esp
80105224:	5f                   	pop    %edi
80105225:	5e                   	pop    %esi
80105226:	5b                   	pop    %ebx
80105227:	5d                   	pop    %ebp
80105228:	c3                   	ret    
80105229:	66 90                	xchg   %ax,%ax
8010522b:	90                   	nop

8010522c <fetchint>:
8010522c:	55                   	push   %ebp
8010522d:	89 e5                	mov    %esp,%ebp
8010522f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105235:	8b 00                	mov    (%eax),%eax
80105237:	3b 45 08             	cmp    0x8(%ebp),%eax
8010523a:	76 12                	jbe    8010524e <fetchint+0x22>
8010523c:	8b 45 08             	mov    0x8(%ebp),%eax
8010523f:	8d 50 04             	lea    0x4(%eax),%edx
80105242:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105248:	8b 00                	mov    (%eax),%eax
8010524a:	39 c2                	cmp    %eax,%edx
8010524c:	76 07                	jbe    80105255 <fetchint+0x29>
8010524e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105253:	eb 0f                	jmp    80105264 <fetchint+0x38>
80105255:	8b 45 08             	mov    0x8(%ebp),%eax
80105258:	8b 10                	mov    (%eax),%edx
8010525a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010525d:	89 10                	mov    %edx,(%eax)
8010525f:	b8 00 00 00 00       	mov    $0x0,%eax
80105264:	5d                   	pop    %ebp
80105265:	c3                   	ret    

80105266 <fetchstr>:
80105266:	55                   	push   %ebp
80105267:	89 e5                	mov    %esp,%ebp
80105269:	83 ec 10             	sub    $0x10,%esp
8010526c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105272:	8b 00                	mov    (%eax),%eax
80105274:	3b 45 08             	cmp    0x8(%ebp),%eax
80105277:	77 07                	ja     80105280 <fetchstr+0x1a>
80105279:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527e:	eb 48                	jmp    801052c8 <fetchstr+0x62>
80105280:	8b 55 08             	mov    0x8(%ebp),%edx
80105283:	8b 45 0c             	mov    0xc(%ebp),%eax
80105286:	89 10                	mov    %edx,(%eax)
80105288:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010528e:	8b 00                	mov    (%eax),%eax
80105290:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105293:	8b 45 0c             	mov    0xc(%ebp),%eax
80105296:	8b 00                	mov    (%eax),%eax
80105298:	89 45 f8             	mov    %eax,-0x8(%ebp)
8010529b:	eb 1e                	jmp    801052bb <fetchstr+0x55>
8010529d:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052a0:	0f b6 00             	movzbl (%eax),%eax
801052a3:	84 c0                	test   %al,%al
801052a5:	75 10                	jne    801052b7 <fetchstr+0x51>
801052a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
801052aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ad:	8b 00                	mov    (%eax),%eax
801052af:	89 d1                	mov    %edx,%ecx
801052b1:	29 c1                	sub    %eax,%ecx
801052b3:	89 c8                	mov    %ecx,%eax
801052b5:	eb 11                	jmp    801052c8 <fetchstr+0x62>
801052b7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801052bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
801052c1:	72 da                	jb     8010529d <fetchstr+0x37>
801052c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052c8:	c9                   	leave  
801052c9:	c3                   	ret    

801052ca <argint>:
801052ca:	55                   	push   %ebp
801052cb:	89 e5                	mov    %esp,%ebp
801052cd:	83 ec 08             	sub    $0x8,%esp
801052d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052d6:	8b 40 18             	mov    0x18(%eax),%eax
801052d9:	8b 50 44             	mov    0x44(%eax),%edx
801052dc:	8b 45 08             	mov    0x8(%ebp),%eax
801052df:	c1 e0 02             	shl    $0x2,%eax
801052e2:	8d 04 02             	lea    (%edx,%eax,1),%eax
801052e5:	8d 50 04             	lea    0x4(%eax),%edx
801052e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801052eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ef:	89 14 24             	mov    %edx,(%esp)
801052f2:	e8 35 ff ff ff       	call   8010522c <fetchint>
801052f7:	c9                   	leave  
801052f8:	c3                   	ret    

801052f9 <argptr>:
801052f9:	55                   	push   %ebp
801052fa:	89 e5                	mov    %esp,%ebp
801052fc:	83 ec 18             	sub    $0x18,%esp
801052ff:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105302:	89 44 24 04          	mov    %eax,0x4(%esp)
80105306:	8b 45 08             	mov    0x8(%ebp),%eax
80105309:	89 04 24             	mov    %eax,(%esp)
8010530c:	e8 b9 ff ff ff       	call   801052ca <argint>
80105311:	85 c0                	test   %eax,%eax
80105313:	79 07                	jns    8010531c <argptr+0x23>
80105315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531a:	eb 3d                	jmp    80105359 <argptr+0x60>
8010531c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010531f:	89 c2                	mov    %eax,%edx
80105321:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105327:	8b 00                	mov    (%eax),%eax
80105329:	39 c2                	cmp    %eax,%edx
8010532b:	73 16                	jae    80105343 <argptr+0x4a>
8010532d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105330:	89 c2                	mov    %eax,%edx
80105332:	8b 45 10             	mov    0x10(%ebp),%eax
80105335:	01 c2                	add    %eax,%edx
80105337:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010533d:	8b 00                	mov    (%eax),%eax
8010533f:	39 c2                	cmp    %eax,%edx
80105341:	76 07                	jbe    8010534a <argptr+0x51>
80105343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105348:	eb 0f                	jmp    80105359 <argptr+0x60>
8010534a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010534d:	89 c2                	mov    %eax,%edx
8010534f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105352:	89 10                	mov    %edx,(%eax)
80105354:	b8 00 00 00 00       	mov    $0x0,%eax
80105359:	c9                   	leave  
8010535a:	c3                   	ret    

8010535b <argstr>:
8010535b:	55                   	push   %ebp
8010535c:	89 e5                	mov    %esp,%ebp
8010535e:	83 ec 18             	sub    $0x18,%esp
80105361:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105364:	89 44 24 04          	mov    %eax,0x4(%esp)
80105368:	8b 45 08             	mov    0x8(%ebp),%eax
8010536b:	89 04 24             	mov    %eax,(%esp)
8010536e:	e8 57 ff ff ff       	call   801052ca <argint>
80105373:	85 c0                	test   %eax,%eax
80105375:	79 07                	jns    8010537e <argstr+0x23>
80105377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537c:	eb 12                	jmp    80105390 <argstr+0x35>
8010537e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105381:	8b 55 0c             	mov    0xc(%ebp),%edx
80105384:	89 54 24 04          	mov    %edx,0x4(%esp)
80105388:	89 04 24             	mov    %eax,(%esp)
8010538b:	e8 d6 fe ff ff       	call   80105266 <fetchstr>
80105390:	c9                   	leave  
80105391:	c3                   	ret    

80105392 <syscall>:
80105392:	55                   	push   %ebp
80105393:	89 e5                	mov    %esp,%ebp
80105395:	53                   	push   %ebx
80105396:	83 ec 24             	sub    $0x24,%esp
80105399:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010539f:	8b 40 18             	mov    0x18(%eax),%eax
801053a2:	8b 40 1c             	mov    0x1c(%eax),%eax
801053a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801053a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801053ac:	7e 30                	jle    801053de <syscall+0x4c>
801053ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b1:	83 f8 15             	cmp    $0x15,%eax
801053b4:	77 28                	ja     801053de <syscall+0x4c>
801053b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b9:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801053c0:	85 c0                	test   %eax,%eax
801053c2:	74 1a                	je     801053de <syscall+0x4c>
801053c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053ca:	8b 58 18             	mov    0x18(%eax),%ebx
801053cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d0:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801053d7:	ff d0                	call   *%eax
801053d9:	89 43 1c             	mov    %eax,0x1c(%ebx)
801053dc:	eb 3d                	jmp    8010541b <syscall+0x89>
801053de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053e4:	8d 48 6c             	lea    0x6c(%eax),%ecx
801053e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053ed:	8b 40 10             	mov    0x10(%eax),%eax
801053f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053f3:	89 54 24 0c          	mov    %edx,0xc(%esp)
801053f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801053fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801053ff:	c7 04 24 c4 86 10 80 	movl   $0x801086c4,(%esp)
80105406:	e8 9f af ff ff       	call   801003aa <cprintf>
8010540b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105411:	8b 40 18             	mov    0x18(%eax),%eax
80105414:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010541b:	83 c4 24             	add    $0x24,%esp
8010541e:	5b                   	pop    %ebx
8010541f:	5d                   	pop    %ebp
80105420:	c3                   	ret    
80105421:	66 90                	xchg   %ax,%ax
80105423:	90                   	nop

80105424 <argfd>:
80105424:	55                   	push   %ebp
80105425:	89 e5                	mov    %esp,%ebp
80105427:	83 ec 28             	sub    $0x28,%esp
8010542a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010542d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105431:	8b 45 08             	mov    0x8(%ebp),%eax
80105434:	89 04 24             	mov    %eax,(%esp)
80105437:	e8 8e fe ff ff       	call   801052ca <argint>
8010543c:	85 c0                	test   %eax,%eax
8010543e:	79 07                	jns    80105447 <argfd+0x23>
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105445:	eb 50                	jmp    80105497 <argfd+0x73>
80105447:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010544a:	85 c0                	test   %eax,%eax
8010544c:	78 21                	js     8010546f <argfd+0x4b>
8010544e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105451:	83 f8 0f             	cmp    $0xf,%eax
80105454:	7f 19                	jg     8010546f <argfd+0x4b>
80105456:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010545c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010545f:	83 c2 08             	add    $0x8,%edx
80105462:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105466:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105469:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010546d:	75 07                	jne    80105476 <argfd+0x52>
8010546f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105474:	eb 21                	jmp    80105497 <argfd+0x73>
80105476:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010547a:	74 08                	je     80105484 <argfd+0x60>
8010547c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010547f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105482:	89 10                	mov    %edx,(%eax)
80105484:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105488:	74 08                	je     80105492 <argfd+0x6e>
8010548a:	8b 45 10             	mov    0x10(%ebp),%eax
8010548d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105490:	89 10                	mov    %edx,(%eax)
80105492:	b8 00 00 00 00       	mov    $0x0,%eax
80105497:	c9                   	leave  
80105498:	c3                   	ret    

80105499 <fdalloc>:
80105499:	55                   	push   %ebp
8010549a:	89 e5                	mov    %esp,%ebp
8010549c:	83 ec 10             	sub    $0x10,%esp
8010549f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801054a6:	eb 30                	jmp    801054d8 <fdalloc+0x3f>
801054a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054b1:	83 c2 08             	add    $0x8,%edx
801054b4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801054b8:	85 c0                	test   %eax,%eax
801054ba:	75 18                	jne    801054d4 <fdalloc+0x3b>
801054bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054c5:	8d 4a 08             	lea    0x8(%edx),%ecx
801054c8:	8b 55 08             	mov    0x8(%ebp),%edx
801054cb:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
801054cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054d2:	eb 0f                	jmp    801054e3 <fdalloc+0x4a>
801054d4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801054d8:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801054dc:	7e ca                	jle    801054a8 <fdalloc+0xf>
801054de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e3:	c9                   	leave  
801054e4:	c3                   	ret    

801054e5 <sys_dup>:
801054e5:	55                   	push   %ebp
801054e6:	89 e5                	mov    %esp,%ebp
801054e8:	83 ec 28             	sub    $0x28,%esp
801054eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054ee:	89 44 24 08          	mov    %eax,0x8(%esp)
801054f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801054f9:	00 
801054fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105501:	e8 1e ff ff ff       	call   80105424 <argfd>
80105506:	85 c0                	test   %eax,%eax
80105508:	79 07                	jns    80105511 <sys_dup+0x2c>
8010550a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550f:	eb 29                	jmp    8010553a <sys_dup+0x55>
80105511:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105514:	89 04 24             	mov    %eax,(%esp)
80105517:	e8 7d ff ff ff       	call   80105499 <fdalloc>
8010551c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010551f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105523:	79 07                	jns    8010552c <sys_dup+0x47>
80105525:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010552a:	eb 0e                	jmp    8010553a <sys_dup+0x55>
8010552c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010552f:	89 04 24             	mov    %eax,(%esp)
80105532:	e8 9d ba ff ff       	call   80100fd4 <filedup>
80105537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010553a:	c9                   	leave  
8010553b:	c3                   	ret    

8010553c <sys_read>:
8010553c:	55                   	push   %ebp
8010553d:	89 e5                	mov    %esp,%ebp
8010553f:	83 ec 28             	sub    $0x28,%esp
80105542:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105545:	89 44 24 08          	mov    %eax,0x8(%esp)
80105549:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105550:	00 
80105551:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105558:	e8 c7 fe ff ff       	call   80105424 <argfd>
8010555d:	85 c0                	test   %eax,%eax
8010555f:	78 35                	js     80105596 <sys_read+0x5a>
80105561:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105564:	89 44 24 04          	mov    %eax,0x4(%esp)
80105568:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010556f:	e8 56 fd ff ff       	call   801052ca <argint>
80105574:	85 c0                	test   %eax,%eax
80105576:	78 1e                	js     80105596 <sys_read+0x5a>
80105578:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010557b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010557f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105582:	89 44 24 04          	mov    %eax,0x4(%esp)
80105586:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010558d:	e8 67 fd ff ff       	call   801052f9 <argptr>
80105592:	85 c0                	test   %eax,%eax
80105594:	79 07                	jns    8010559d <sys_read+0x61>
80105596:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559b:	eb 19                	jmp    801055b6 <sys_read+0x7a>
8010559d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801055a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801055a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801055aa:	89 54 24 04          	mov    %edx,0x4(%esp)
801055ae:	89 04 24             	mov    %eax,(%esp)
801055b1:	e8 8b bb ff ff       	call   80101141 <fileread>
801055b6:	c9                   	leave  
801055b7:	c3                   	ret    

801055b8 <sys_write>:
801055b8:	55                   	push   %ebp
801055b9:	89 e5                	mov    %esp,%ebp
801055bb:	83 ec 28             	sub    $0x28,%esp
801055be:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c1:	89 44 24 08          	mov    %eax,0x8(%esp)
801055c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801055cc:	00 
801055cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055d4:	e8 4b fe ff ff       	call   80105424 <argfd>
801055d9:	85 c0                	test   %eax,%eax
801055db:	78 35                	js     80105612 <sys_write+0x5a>
801055dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801055e4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801055eb:	e8 da fc ff ff       	call   801052ca <argint>
801055f0:	85 c0                	test   %eax,%eax
801055f2:	78 1e                	js     80105612 <sys_write+0x5a>
801055f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055f7:	89 44 24 08          	mov    %eax,0x8(%esp)
801055fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105602:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105609:	e8 eb fc ff ff       	call   801052f9 <argptr>
8010560e:	85 c0                	test   %eax,%eax
80105610:	79 07                	jns    80105619 <sys_write+0x61>
80105612:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105617:	eb 19                	jmp    80105632 <sys_write+0x7a>
80105619:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010561c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010561f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105622:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105626:	89 54 24 04          	mov    %edx,0x4(%esp)
8010562a:	89 04 24             	mov    %eax,(%esp)
8010562d:	e8 cb bb ff ff       	call   801011fd <filewrite>
80105632:	c9                   	leave  
80105633:	c3                   	ret    

80105634 <sys_close>:
80105634:	55                   	push   %ebp
80105635:	89 e5                	mov    %esp,%ebp
80105637:	83 ec 28             	sub    $0x28,%esp
8010563a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010563d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105641:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105644:	89 44 24 04          	mov    %eax,0x4(%esp)
80105648:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010564f:	e8 d0 fd ff ff       	call   80105424 <argfd>
80105654:	85 c0                	test   %eax,%eax
80105656:	79 07                	jns    8010565f <sys_close+0x2b>
80105658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010565d:	eb 24                	jmp    80105683 <sys_close+0x4f>
8010565f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105665:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105668:	83 c2 08             	add    $0x8,%edx
8010566b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105672:	00 
80105673:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105676:	89 04 24             	mov    %eax,(%esp)
80105679:	e8 9e b9 ff ff       	call   8010101c <fileclose>
8010567e:	b8 00 00 00 00       	mov    $0x0,%eax
80105683:	c9                   	leave  
80105684:	c3                   	ret    

80105685 <sys_fstat>:
80105685:	55                   	push   %ebp
80105686:	89 e5                	mov    %esp,%ebp
80105688:	83 ec 28             	sub    $0x28,%esp
8010568b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010568e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105692:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105699:	00 
8010569a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056a1:	e8 7e fd ff ff       	call   80105424 <argfd>
801056a6:	85 c0                	test   %eax,%eax
801056a8:	78 1f                	js     801056c9 <sys_fstat+0x44>
801056aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056ad:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801056b4:	00 
801056b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801056b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801056c0:	e8 34 fc ff ff       	call   801052f9 <argptr>
801056c5:	85 c0                	test   %eax,%eax
801056c7:	79 07                	jns    801056d0 <sys_fstat+0x4b>
801056c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ce:	eb 12                	jmp    801056e2 <sys_fstat+0x5d>
801056d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801056da:	89 04 24             	mov    %eax,(%esp)
801056dd:	e8 10 ba ff ff       	call   801010f2 <filestat>
801056e2:	c9                   	leave  
801056e3:	c3                   	ret    

801056e4 <sys_link>:
801056e4:	55                   	push   %ebp
801056e5:	89 e5                	mov    %esp,%ebp
801056e7:	83 ec 38             	sub    $0x38,%esp
801056ea:	8d 45 d8             	lea    -0x28(%ebp),%eax
801056ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801056f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056f8:	e8 5e fc ff ff       	call   8010535b <argstr>
801056fd:	85 c0                	test   %eax,%eax
801056ff:	78 17                	js     80105718 <sys_link+0x34>
80105701:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105704:	89 44 24 04          	mov    %eax,0x4(%esp)
80105708:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010570f:	e8 47 fc ff ff       	call   8010535b <argstr>
80105714:	85 c0                	test   %eax,%eax
80105716:	79 0a                	jns    80105722 <sys_link+0x3e>
80105718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571d:	e9 3c 01 00 00       	jmp    8010585e <sys_link+0x17a>
80105722:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105725:	89 04 24             	mov    %eax,(%esp)
80105728:	e8 58 cd ff ff       	call   80102485 <namei>
8010572d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105734:	75 0a                	jne    80105740 <sys_link+0x5c>
80105736:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010573b:	e9 1e 01 00 00       	jmp    8010585e <sys_link+0x17a>
80105740:	e8 3d db ff ff       	call   80103282 <begin_trans>
80105745:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105748:	89 04 24             	mov    %eax,(%esp)
8010574b:	e8 74 c1 ff ff       	call   801018c4 <ilock>
80105750:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105753:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105757:	66 83 f8 01          	cmp    $0x1,%ax
8010575b:	75 1a                	jne    80105777 <sys_link+0x93>
8010575d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105760:	89 04 24             	mov    %eax,(%esp)
80105763:	e8 e0 c3 ff ff       	call   80101b48 <iunlockput>
80105768:	e8 5e db ff ff       	call   801032cb <commit_trans>
8010576d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105772:	e9 e7 00 00 00       	jmp    8010585e <sys_link+0x17a>
80105777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010577a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010577e:	8d 50 01             	lea    0x1(%eax),%edx
80105781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105784:	66 89 50 16          	mov    %dx,0x16(%eax)
80105788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010578b:	89 04 24             	mov    %eax,(%esp)
8010578e:	e8 75 bf ff ff       	call   80101708 <iupdate>
80105793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105796:	89 04 24             	mov    %eax,(%esp)
80105799:	e8 74 c2 ff ff       	call   80101a12 <iunlock>
8010579e:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057a1:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801057a4:	89 54 24 04          	mov    %edx,0x4(%esp)
801057a8:	89 04 24             	mov    %eax,(%esp)
801057ab:	e8 f7 cc ff ff       	call   801024a7 <nameiparent>
801057b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801057b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801057b7:	74 68                	je     80105821 <sys_link+0x13d>
801057b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057bc:	89 04 24             	mov    %eax,(%esp)
801057bf:	e8 00 c1 ff ff       	call   801018c4 <ilock>
801057c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057c7:	8b 10                	mov    (%eax),%edx
801057c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057cc:	8b 00                	mov    (%eax),%eax
801057ce:	39 c2                	cmp    %eax,%edx
801057d0:	75 20                	jne    801057f2 <sys_link+0x10e>
801057d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d5:	8b 40 04             	mov    0x4(%eax),%eax
801057d8:	89 44 24 08          	mov    %eax,0x8(%esp)
801057dc:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801057df:	89 44 24 04          	mov    %eax,0x4(%esp)
801057e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057e6:	89 04 24             	mov    %eax,(%esp)
801057e9:	e8 d4 c9 ff ff       	call   801021c2 <dirlink>
801057ee:	85 c0                	test   %eax,%eax
801057f0:	79 0d                	jns    801057ff <sys_link+0x11b>
801057f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057f5:	89 04 24             	mov    %eax,(%esp)
801057f8:	e8 4b c3 ff ff       	call   80101b48 <iunlockput>
801057fd:	eb 23                	jmp    80105822 <sys_link+0x13e>
801057ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105802:	89 04 24             	mov    %eax,(%esp)
80105805:	e8 3e c3 ff ff       	call   80101b48 <iunlockput>
8010580a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010580d:	89 04 24             	mov    %eax,(%esp)
80105810:	e8 62 c2 ff ff       	call   80101a77 <iput>
80105815:	e8 b1 da ff ff       	call   801032cb <commit_trans>
8010581a:	b8 00 00 00 00       	mov    $0x0,%eax
8010581f:	eb 3d                	jmp    8010585e <sys_link+0x17a>
80105821:	90                   	nop
80105822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105825:	89 04 24             	mov    %eax,(%esp)
80105828:	e8 97 c0 ff ff       	call   801018c4 <ilock>
8010582d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105830:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105834:	8d 50 ff             	lea    -0x1(%eax),%edx
80105837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010583a:	66 89 50 16          	mov    %dx,0x16(%eax)
8010583e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105841:	89 04 24             	mov    %eax,(%esp)
80105844:	e8 bf be ff ff       	call   80101708 <iupdate>
80105849:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010584c:	89 04 24             	mov    %eax,(%esp)
8010584f:	e8 f4 c2 ff ff       	call   80101b48 <iunlockput>
80105854:	e8 72 da ff ff       	call   801032cb <commit_trans>
80105859:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585e:	c9                   	leave  
8010585f:	c3                   	ret    

80105860 <isdirempty>:
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	83 ec 38             	sub    $0x38,%esp
80105866:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
8010586d:	eb 4b                	jmp    801058ba <isdirempty+0x5a>
8010586f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105872:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105875:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010587c:	00 
8010587d:	89 54 24 08          	mov    %edx,0x8(%esp)
80105881:	89 44 24 04          	mov    %eax,0x4(%esp)
80105885:	8b 45 08             	mov    0x8(%ebp),%eax
80105888:	89 04 24             	mov    %eax,(%esp)
8010588b:	e8 41 c5 ff ff       	call   80101dd1 <readi>
80105890:	83 f8 10             	cmp    $0x10,%eax
80105893:	74 0c                	je     801058a1 <isdirempty+0x41>
80105895:	c7 04 24 e0 86 10 80 	movl   $0x801086e0,(%esp)
8010589c:	e8 a5 ac ff ff       	call   80100546 <panic>
801058a1:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801058a5:	66 85 c0             	test   %ax,%ax
801058a8:	74 07                	je     801058b1 <isdirempty+0x51>
801058aa:	b8 00 00 00 00       	mov    $0x0,%eax
801058af:	eb 1b                	jmp    801058cc <isdirempty+0x6c>
801058b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058b4:	83 c0 10             	add    $0x10,%eax
801058b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058bd:	8b 45 08             	mov    0x8(%ebp),%eax
801058c0:	8b 40 18             	mov    0x18(%eax),%eax
801058c3:	39 c2                	cmp    %eax,%edx
801058c5:	72 a8                	jb     8010586f <isdirempty+0xf>
801058c7:	b8 01 00 00 00       	mov    $0x1,%eax
801058cc:	c9                   	leave  
801058cd:	c3                   	ret    

801058ce <sys_unlink>:
801058ce:	55                   	push   %ebp
801058cf:	89 e5                	mov    %esp,%ebp
801058d1:	83 ec 48             	sub    $0x48,%esp
801058d4:	8d 45 cc             	lea    -0x34(%ebp),%eax
801058d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801058db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058e2:	e8 74 fa ff ff       	call   8010535b <argstr>
801058e7:	85 c0                	test   %eax,%eax
801058e9:	79 0a                	jns    801058f5 <sys_unlink+0x27>
801058eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f0:	e9 aa 01 00 00       	jmp    80105a9f <sys_unlink+0x1d1>
801058f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801058f8:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801058fb:	89 54 24 04          	mov    %edx,0x4(%esp)
801058ff:	89 04 24             	mov    %eax,(%esp)
80105902:	e8 a0 cb ff ff       	call   801024a7 <nameiparent>
80105907:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010590a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010590e:	75 0a                	jne    8010591a <sys_unlink+0x4c>
80105910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105915:	e9 85 01 00 00       	jmp    80105a9f <sys_unlink+0x1d1>
8010591a:	e8 63 d9 ff ff       	call   80103282 <begin_trans>
8010591f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105922:	89 04 24             	mov    %eax,(%esp)
80105925:	e8 9a bf ff ff       	call   801018c4 <ilock>
8010592a:	c7 44 24 04 f2 86 10 	movl   $0x801086f2,0x4(%esp)
80105931:	80 
80105932:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105935:	89 04 24             	mov    %eax,(%esp)
80105938:	e8 9b c7 ff ff       	call   801020d8 <namecmp>
8010593d:	85 c0                	test   %eax,%eax
8010593f:	0f 84 45 01 00 00    	je     80105a8a <sys_unlink+0x1bc>
80105945:	c7 44 24 04 f4 86 10 	movl   $0x801086f4,0x4(%esp)
8010594c:	80 
8010594d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105950:	89 04 24             	mov    %eax,(%esp)
80105953:	e8 80 c7 ff ff       	call   801020d8 <namecmp>
80105958:	85 c0                	test   %eax,%eax
8010595a:	0f 84 2a 01 00 00    	je     80105a8a <sys_unlink+0x1bc>
80105960:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105963:	89 44 24 08          	mov    %eax,0x8(%esp)
80105967:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010596a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010596e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105971:	89 04 24             	mov    %eax,(%esp)
80105974:	e8 81 c7 ff ff       	call   801020fa <dirlookup>
80105979:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010597c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105980:	0f 84 03 01 00 00    	je     80105a89 <sys_unlink+0x1bb>
80105986:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105989:	89 04 24             	mov    %eax,(%esp)
8010598c:	e8 33 bf ff ff       	call   801018c4 <ilock>
80105991:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105994:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105998:	66 85 c0             	test   %ax,%ax
8010599b:	7f 0c                	jg     801059a9 <sys_unlink+0xdb>
8010599d:	c7 04 24 f7 86 10 80 	movl   $0x801086f7,(%esp)
801059a4:	e8 9d ab ff ff       	call   80100546 <panic>
801059a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ac:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801059b0:	66 83 f8 01          	cmp    $0x1,%ax
801059b4:	75 1f                	jne    801059d5 <sys_unlink+0x107>
801059b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059b9:	89 04 24             	mov    %eax,(%esp)
801059bc:	e8 9f fe ff ff       	call   80105860 <isdirempty>
801059c1:	85 c0                	test   %eax,%eax
801059c3:	75 10                	jne    801059d5 <sys_unlink+0x107>
801059c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c8:	89 04 24             	mov    %eax,(%esp)
801059cb:	e8 78 c1 ff ff       	call   80101b48 <iunlockput>
801059d0:	e9 b5 00 00 00       	jmp    80105a8a <sys_unlink+0x1bc>
801059d5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801059dc:	00 
801059dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801059e4:	00 
801059e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059e8:	89 04 24             	mov    %eax,(%esp)
801059eb:	e8 7e f5 ff ff       	call   80104f6e <memset>
801059f0:	8b 55 c8             	mov    -0x38(%ebp),%edx
801059f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059f6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801059fd:	00 
801059fe:	89 54 24 08          	mov    %edx,0x8(%esp)
80105a02:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a09:	89 04 24             	mov    %eax,(%esp)
80105a0c:	e8 2e c5 ff ff       	call   80101f3f <writei>
80105a11:	83 f8 10             	cmp    $0x10,%eax
80105a14:	74 0c                	je     80105a22 <sys_unlink+0x154>
80105a16:	c7 04 24 09 87 10 80 	movl   $0x80108709,(%esp)
80105a1d:	e8 24 ab ff ff       	call   80100546 <panic>
80105a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a25:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105a29:	66 83 f8 01          	cmp    $0x1,%ax
80105a2d:	75 1c                	jne    80105a4b <sys_unlink+0x17d>
80105a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a32:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a36:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3c:	66 89 50 16          	mov    %dx,0x16(%eax)
80105a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a43:	89 04 24             	mov    %eax,(%esp)
80105a46:	e8 bd bc ff ff       	call   80101708 <iupdate>
80105a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a4e:	89 04 24             	mov    %eax,(%esp)
80105a51:	e8 f2 c0 ff ff       	call   80101b48 <iunlockput>
80105a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a59:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a5d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a63:	66 89 50 16          	mov    %dx,0x16(%eax)
80105a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a6a:	89 04 24             	mov    %eax,(%esp)
80105a6d:	e8 96 bc ff ff       	call   80101708 <iupdate>
80105a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a75:	89 04 24             	mov    %eax,(%esp)
80105a78:	e8 cb c0 ff ff       	call   80101b48 <iunlockput>
80105a7d:	e8 49 d8 ff ff       	call   801032cb <commit_trans>
80105a82:	b8 00 00 00 00       	mov    $0x0,%eax
80105a87:	eb 16                	jmp    80105a9f <sys_unlink+0x1d1>
80105a89:	90                   	nop
80105a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a8d:	89 04 24             	mov    %eax,(%esp)
80105a90:	e8 b3 c0 ff ff       	call   80101b48 <iunlockput>
80105a95:	e8 31 d8 ff ff       	call   801032cb <commit_trans>
80105a9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a9f:	c9                   	leave  
80105aa0:	c3                   	ret    

80105aa1 <create>:
80105aa1:	55                   	push   %ebp
80105aa2:	89 e5                	mov    %esp,%ebp
80105aa4:	83 ec 48             	sub    $0x48,%esp
80105aa7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105aaa:	8b 55 10             	mov    0x10(%ebp),%edx
80105aad:	8b 45 14             	mov    0x14(%ebp),%eax
80105ab0:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105ab4:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105ab8:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
80105abc:	8d 45 de             	lea    -0x22(%ebp),%eax
80105abf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80105ac6:	89 04 24             	mov    %eax,(%esp)
80105ac9:	e8 d9 c9 ff ff       	call   801024a7 <nameiparent>
80105ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ad1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ad5:	75 0a                	jne    80105ae1 <create+0x40>
80105ad7:	b8 00 00 00 00       	mov    $0x0,%eax
80105adc:	e9 7e 01 00 00       	jmp    80105c5f <create+0x1be>
80105ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae4:	89 04 24             	mov    %eax,(%esp)
80105ae7:	e8 d8 bd ff ff       	call   801018c4 <ilock>
80105aec:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105aef:	89 44 24 08          	mov    %eax,0x8(%esp)
80105af3:	8d 45 de             	lea    -0x22(%ebp),%eax
80105af6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105afd:	89 04 24             	mov    %eax,(%esp)
80105b00:	e8 f5 c5 ff ff       	call   801020fa <dirlookup>
80105b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b0c:	74 47                	je     80105b55 <create+0xb4>
80105b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b11:	89 04 24             	mov    %eax,(%esp)
80105b14:	e8 2f c0 ff ff       	call   80101b48 <iunlockput>
80105b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b1c:	89 04 24             	mov    %eax,(%esp)
80105b1f:	e8 a0 bd ff ff       	call   801018c4 <ilock>
80105b24:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105b29:	75 15                	jne    80105b40 <create+0x9f>
80105b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b2e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105b32:	66 83 f8 02          	cmp    $0x2,%ax
80105b36:	75 08                	jne    80105b40 <create+0x9f>
80105b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b3b:	e9 1f 01 00 00       	jmp    80105c5f <create+0x1be>
80105b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b43:	89 04 24             	mov    %eax,(%esp)
80105b46:	e8 fd bf ff ff       	call   80101b48 <iunlockput>
80105b4b:	b8 00 00 00 00       	mov    $0x0,%eax
80105b50:	e9 0a 01 00 00       	jmp    80105c5f <create+0x1be>
80105b55:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b5c:	8b 00                	mov    (%eax),%eax
80105b5e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b62:	89 04 24             	mov    %eax,(%esp)
80105b65:	e8 bf ba ff ff       	call   80101629 <ialloc>
80105b6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b71:	75 0c                	jne    80105b7f <create+0xde>
80105b73:	c7 04 24 18 87 10 80 	movl   $0x80108718,(%esp)
80105b7a:	e8 c7 a9 ff ff       	call   80100546 <panic>
80105b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b82:	89 04 24             	mov    %eax,(%esp)
80105b85:	e8 3a bd ff ff       	call   801018c4 <ilock>
80105b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b8d:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105b91:	66 89 50 12          	mov    %dx,0x12(%eax)
80105b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b98:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105b9c:	66 89 50 14          	mov    %dx,0x14(%eax)
80105ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ba3:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
80105ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bac:	89 04 24             	mov    %eax,(%esp)
80105baf:	e8 54 bb ff ff       	call   80101708 <iupdate>
80105bb4:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105bb9:	75 6a                	jne    80105c25 <create+0x184>
80105bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bbe:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105bc2:	8d 50 01             	lea    0x1(%eax),%edx
80105bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc8:	66 89 50 16          	mov    %dx,0x16(%eax)
80105bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bcf:	89 04 24             	mov    %eax,(%esp)
80105bd2:	e8 31 bb ff ff       	call   80101708 <iupdate>
80105bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bda:	8b 40 04             	mov    0x4(%eax),%eax
80105bdd:	89 44 24 08          	mov    %eax,0x8(%esp)
80105be1:	c7 44 24 04 f2 86 10 	movl   $0x801086f2,0x4(%esp)
80105be8:	80 
80105be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bec:	89 04 24             	mov    %eax,(%esp)
80105bef:	e8 ce c5 ff ff       	call   801021c2 <dirlink>
80105bf4:	85 c0                	test   %eax,%eax
80105bf6:	78 21                	js     80105c19 <create+0x178>
80105bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bfb:	8b 40 04             	mov    0x4(%eax),%eax
80105bfe:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c02:	c7 44 24 04 f4 86 10 	movl   $0x801086f4,0x4(%esp)
80105c09:	80 
80105c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c0d:	89 04 24             	mov    %eax,(%esp)
80105c10:	e8 ad c5 ff ff       	call   801021c2 <dirlink>
80105c15:	85 c0                	test   %eax,%eax
80105c17:	79 0c                	jns    80105c25 <create+0x184>
80105c19:	c7 04 24 27 87 10 80 	movl   $0x80108727,(%esp)
80105c20:	e8 21 a9 ff ff       	call   80100546 <panic>
80105c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c28:	8b 40 04             	mov    0x4(%eax),%eax
80105c2b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c2f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105c32:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c39:	89 04 24             	mov    %eax,(%esp)
80105c3c:	e8 81 c5 ff ff       	call   801021c2 <dirlink>
80105c41:	85 c0                	test   %eax,%eax
80105c43:	79 0c                	jns    80105c51 <create+0x1b0>
80105c45:	c7 04 24 33 87 10 80 	movl   $0x80108733,(%esp)
80105c4c:	e8 f5 a8 ff ff       	call   80100546 <panic>
80105c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c54:	89 04 24             	mov    %eax,(%esp)
80105c57:	e8 ec be ff ff       	call   80101b48 <iunlockput>
80105c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c5f:	c9                   	leave  
80105c60:	c3                   	ret    

80105c61 <sys_open>:
80105c61:	55                   	push   %ebp
80105c62:	89 e5                	mov    %esp,%ebp
80105c64:	83 ec 38             	sub    $0x38,%esp
80105c67:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c75:	e8 e1 f6 ff ff       	call   8010535b <argstr>
80105c7a:	85 c0                	test   %eax,%eax
80105c7c:	78 17                	js     80105c95 <sys_open+0x34>
80105c7e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c81:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105c8c:	e8 39 f6 ff ff       	call   801052ca <argint>
80105c91:	85 c0                	test   %eax,%eax
80105c93:	79 0a                	jns    80105c9f <sys_open+0x3e>
80105c95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c9a:	e9 46 01 00 00       	jmp    80105de5 <sys_open+0x184>
80105c9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ca2:	25 00 02 00 00       	and    $0x200,%eax
80105ca7:	85 c0                	test   %eax,%eax
80105ca9:	74 40                	je     80105ceb <sys_open+0x8a>
80105cab:	e8 d2 d5 ff ff       	call   80103282 <begin_trans>
80105cb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105cb3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105cba:	00 
80105cbb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105cc2:	00 
80105cc3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105cca:	00 
80105ccb:	89 04 24             	mov    %eax,(%esp)
80105cce:	e8 ce fd ff ff       	call   80105aa1 <create>
80105cd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cd6:	e8 f0 d5 ff ff       	call   801032cb <commit_trans>
80105cdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cdf:	75 5c                	jne    80105d3d <sys_open+0xdc>
80105ce1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce6:	e9 fa 00 00 00       	jmp    80105de5 <sys_open+0x184>
80105ceb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105cee:	89 04 24             	mov    %eax,(%esp)
80105cf1:	e8 8f c7 ff ff       	call   80102485 <namei>
80105cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cfd:	75 0a                	jne    80105d09 <sys_open+0xa8>
80105cff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d04:	e9 dc 00 00 00       	jmp    80105de5 <sys_open+0x184>
80105d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d0c:	89 04 24             	mov    %eax,(%esp)
80105d0f:	e8 b0 bb ff ff       	call   801018c4 <ilock>
80105d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d17:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d1b:	66 83 f8 01          	cmp    $0x1,%ax
80105d1f:	75 1c                	jne    80105d3d <sys_open+0xdc>
80105d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d24:	85 c0                	test   %eax,%eax
80105d26:	74 15                	je     80105d3d <sys_open+0xdc>
80105d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d2b:	89 04 24             	mov    %eax,(%esp)
80105d2e:	e8 15 be ff ff       	call   80101b48 <iunlockput>
80105d33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d38:	e9 a8 00 00 00       	jmp    80105de5 <sys_open+0x184>
80105d3d:	e8 32 b2 ff ff       	call   80100f74 <filealloc>
80105d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d49:	74 14                	je     80105d5f <sys_open+0xfe>
80105d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d4e:	89 04 24             	mov    %eax,(%esp)
80105d51:	e8 43 f7 ff ff       	call   80105499 <fdalloc>
80105d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105d59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105d5d:	79 23                	jns    80105d82 <sys_open+0x121>
80105d5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d63:	74 0b                	je     80105d70 <sys_open+0x10f>
80105d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d68:	89 04 24             	mov    %eax,(%esp)
80105d6b:	e8 ac b2 ff ff       	call   8010101c <fileclose>
80105d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d73:	89 04 24             	mov    %eax,(%esp)
80105d76:	e8 cd bd ff ff       	call   80101b48 <iunlockput>
80105d7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d80:	eb 63                	jmp    80105de5 <sys_open+0x184>
80105d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d85:	89 04 24             	mov    %eax,(%esp)
80105d88:	e8 85 bc ff ff       	call   80101a12 <iunlock>
80105d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d90:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
80105d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d9c:	89 50 10             	mov    %edx,0x10(%eax)
80105d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
80105da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dac:	83 e0 01             	and    $0x1,%eax
80105daf:	85 c0                	test   %eax,%eax
80105db1:	0f 94 c2             	sete   %dl
80105db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db7:	88 50 08             	mov    %dl,0x8(%eax)
80105dba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dbd:	83 e0 01             	and    $0x1,%eax
80105dc0:	84 c0                	test   %al,%al
80105dc2:	75 0a                	jne    80105dce <sys_open+0x16d>
80105dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dc7:	83 e0 02             	and    $0x2,%eax
80105dca:	85 c0                	test   %eax,%eax
80105dcc:	74 07                	je     80105dd5 <sys_open+0x174>
80105dce:	b8 01 00 00 00       	mov    $0x1,%eax
80105dd3:	eb 05                	jmp    80105dda <sys_open+0x179>
80105dd5:	b8 00 00 00 00       	mov    $0x0,%eax
80105dda:	89 c2                	mov    %eax,%edx
80105ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ddf:	88 50 09             	mov    %dl,0x9(%eax)
80105de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105de5:	c9                   	leave  
80105de6:	c3                   	ret    

80105de7 <sys_mkdir>:
80105de7:	55                   	push   %ebp
80105de8:	89 e5                	mov    %esp,%ebp
80105dea:	83 ec 28             	sub    $0x28,%esp
80105ded:	e8 90 d4 ff ff       	call   80103282 <begin_trans>
80105df2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105df5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105df9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e00:	e8 56 f5 ff ff       	call   8010535b <argstr>
80105e05:	85 c0                	test   %eax,%eax
80105e07:	78 2c                	js     80105e35 <sys_mkdir+0x4e>
80105e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e0c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105e13:	00 
80105e14:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105e1b:	00 
80105e1c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105e23:	00 
80105e24:	89 04 24             	mov    %eax,(%esp)
80105e27:	e8 75 fc ff ff       	call   80105aa1 <create>
80105e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e33:	75 0c                	jne    80105e41 <sys_mkdir+0x5a>
80105e35:	e8 91 d4 ff ff       	call   801032cb <commit_trans>
80105e3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e3f:	eb 15                	jmp    80105e56 <sys_mkdir+0x6f>
80105e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e44:	89 04 24             	mov    %eax,(%esp)
80105e47:	e8 fc bc ff ff       	call   80101b48 <iunlockput>
80105e4c:	e8 7a d4 ff ff       	call   801032cb <commit_trans>
80105e51:	b8 00 00 00 00       	mov    $0x0,%eax
80105e56:	c9                   	leave  
80105e57:	c3                   	ret    

80105e58 <sys_mknod>:
80105e58:	55                   	push   %ebp
80105e59:	89 e5                	mov    %esp,%ebp
80105e5b:	83 ec 38             	sub    $0x38,%esp
80105e5e:	e8 1f d4 ff ff       	call   80103282 <begin_trans>
80105e63:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e66:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e71:	e8 e5 f4 ff ff       	call   8010535b <argstr>
80105e76:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e7d:	78 5e                	js     80105edd <sys_mknod+0x85>
80105e7f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e82:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e86:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e8d:	e8 38 f4 ff ff       	call   801052ca <argint>
80105e92:	85 c0                	test   %eax,%eax
80105e94:	78 47                	js     80105edd <sys_mknod+0x85>
80105e96:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e99:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e9d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105ea4:	e8 21 f4 ff ff       	call   801052ca <argint>
80105ea9:	85 c0                	test   %eax,%eax
80105eab:	78 30                	js     80105edd <sys_mknod+0x85>
80105ead:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105eb0:	0f bf c8             	movswl %ax,%ecx
80105eb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105eb6:	0f bf d0             	movswl %ax,%edx
80105eb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105ebc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105ec0:	89 54 24 08          	mov    %edx,0x8(%esp)
80105ec4:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105ecb:	00 
80105ecc:	89 04 24             	mov    %eax,(%esp)
80105ecf:	e8 cd fb ff ff       	call   80105aa1 <create>
80105ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ed7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105edb:	75 0c                	jne    80105ee9 <sys_mknod+0x91>
80105edd:	e8 e9 d3 ff ff       	call   801032cb <commit_trans>
80105ee2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee7:	eb 15                	jmp    80105efe <sys_mknod+0xa6>
80105ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eec:	89 04 24             	mov    %eax,(%esp)
80105eef:	e8 54 bc ff ff       	call   80101b48 <iunlockput>
80105ef4:	e8 d2 d3 ff ff       	call   801032cb <commit_trans>
80105ef9:	b8 00 00 00 00       	mov    $0x0,%eax
80105efe:	c9                   	leave  
80105eff:	c3                   	ret    

80105f00 <sys_chdir>:
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	83 ec 28             	sub    $0x28,%esp
80105f06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f09:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f14:	e8 42 f4 ff ff       	call   8010535b <argstr>
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	78 14                	js     80105f31 <sys_chdir+0x31>
80105f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f20:	89 04 24             	mov    %eax,(%esp)
80105f23:	e8 5d c5 ff ff       	call   80102485 <namei>
80105f28:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f2f:	75 07                	jne    80105f38 <sys_chdir+0x38>
80105f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f36:	eb 57                	jmp    80105f8f <sys_chdir+0x8f>
80105f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f3b:	89 04 24             	mov    %eax,(%esp)
80105f3e:	e8 81 b9 ff ff       	call   801018c4 <ilock>
80105f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f46:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f4a:	66 83 f8 01          	cmp    $0x1,%ax
80105f4e:	74 12                	je     80105f62 <sys_chdir+0x62>
80105f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f53:	89 04 24             	mov    %eax,(%esp)
80105f56:	e8 ed bb ff ff       	call   80101b48 <iunlockput>
80105f5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f60:	eb 2d                	jmp    80105f8f <sys_chdir+0x8f>
80105f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f65:	89 04 24             	mov    %eax,(%esp)
80105f68:	e8 a5 ba ff ff       	call   80101a12 <iunlock>
80105f6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f73:	8b 40 68             	mov    0x68(%eax),%eax
80105f76:	89 04 24             	mov    %eax,(%esp)
80105f79:	e8 f9 ba ff ff       	call   80101a77 <iput>
80105f7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f84:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f87:	89 50 68             	mov    %edx,0x68(%eax)
80105f8a:	b8 00 00 00 00       	mov    $0x0,%eax
80105f8f:	c9                   	leave  
80105f90:	c3                   	ret    

80105f91 <sys_exec>:
80105f91:	55                   	push   %ebp
80105f92:	89 e5                	mov    %esp,%ebp
80105f94:	81 ec a8 00 00 00    	sub    $0xa8,%esp
80105f9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fa1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fa8:	e8 ae f3 ff ff       	call   8010535b <argstr>
80105fad:	85 c0                	test   %eax,%eax
80105faf:	78 1a                	js     80105fcb <sys_exec+0x3a>
80105fb1:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105fc2:	e8 03 f3 ff ff       	call   801052ca <argint>
80105fc7:	85 c0                	test   %eax,%eax
80105fc9:	79 0a                	jns    80105fd5 <sys_exec+0x44>
80105fcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fd0:	e9 cd 00 00 00       	jmp    801060a2 <sys_exec+0x111>
80105fd5:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105fdc:	00 
80105fdd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105fe4:	00 
80105fe5:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105feb:	89 04 24             	mov    %eax,(%esp)
80105fee:	e8 7b ef ff ff       	call   80104f6e <memset>
80105ff3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ffd:	83 f8 1f             	cmp    $0x1f,%eax
80106000:	76 0a                	jbe    8010600c <sys_exec+0x7b>
80106002:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106007:	e9 96 00 00 00       	jmp    801060a2 <sys_exec+0x111>
8010600c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106012:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106015:	c1 e2 02             	shl    $0x2,%edx
80106018:	89 d1                	mov    %edx,%ecx
8010601a:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
80106020:	8d 14 11             	lea    (%ecx,%edx,1),%edx
80106023:	89 44 24 04          	mov    %eax,0x4(%esp)
80106027:	89 14 24             	mov    %edx,(%esp)
8010602a:	e8 fd f1 ff ff       	call   8010522c <fetchint>
8010602f:	85 c0                	test   %eax,%eax
80106031:	79 07                	jns    8010603a <sys_exec+0xa9>
80106033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106038:	eb 68                	jmp    801060a2 <sys_exec+0x111>
8010603a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106040:	85 c0                	test   %eax,%eax
80106042:	75 26                	jne    8010606a <sys_exec+0xd9>
80106044:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106047:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010604e:	00 00 00 00 
80106052:	90                   	nop
80106053:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106056:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010605c:	89 54 24 04          	mov    %edx,0x4(%esp)
80106060:	89 04 24             	mov    %eax,(%esp)
80106063:	e8 a0 aa ff ff       	call   80100b08 <exec>
80106068:	eb 38                	jmp    801060a2 <sys_exec+0x111>
8010606a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010606d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106074:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010607a:	01 d0                	add    %edx,%eax
8010607c:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
80106082:	89 44 24 04          	mov    %eax,0x4(%esp)
80106086:	89 14 24             	mov    %edx,(%esp)
80106089:	e8 d8 f1 ff ff       	call   80105266 <fetchstr>
8010608e:	85 c0                	test   %eax,%eax
80106090:	79 07                	jns    80106099 <sys_exec+0x108>
80106092:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106097:	eb 09                	jmp    801060a2 <sys_exec+0x111>
80106099:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010609d:	e9 58 ff ff ff       	jmp    80105ffa <sys_exec+0x69>
801060a2:	c9                   	leave  
801060a3:	c3                   	ret    

801060a4 <sys_pipe>:
801060a4:	55                   	push   %ebp
801060a5:	89 e5                	mov    %esp,%ebp
801060a7:	83 ec 38             	sub    $0x38,%esp
801060aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060ad:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801060b4:	00 
801060b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801060b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060c0:	e8 34 f2 ff ff       	call   801052f9 <argptr>
801060c5:	85 c0                	test   %eax,%eax
801060c7:	79 0a                	jns    801060d3 <sys_pipe+0x2f>
801060c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ce:	e9 9b 00 00 00       	jmp    8010616e <sys_pipe+0xca>
801060d3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801060da:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060dd:	89 04 24             	mov    %eax,(%esp)
801060e0:	e8 93 db ff ff       	call   80103c78 <pipealloc>
801060e5:	85 c0                	test   %eax,%eax
801060e7:	79 07                	jns    801060f0 <sys_pipe+0x4c>
801060e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ee:	eb 7e                	jmp    8010616e <sys_pipe+0xca>
801060f0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
801060f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060fa:	89 04 24             	mov    %eax,(%esp)
801060fd:	e8 97 f3 ff ff       	call   80105499 <fdalloc>
80106102:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106105:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106109:	78 14                	js     8010611f <sys_pipe+0x7b>
8010610b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010610e:	89 04 24             	mov    %eax,(%esp)
80106111:	e8 83 f3 ff ff       	call   80105499 <fdalloc>
80106116:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106119:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010611d:	79 37                	jns    80106156 <sys_pipe+0xb2>
8010611f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106123:	78 14                	js     80106139 <sys_pipe+0x95>
80106125:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010612b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010612e:	83 c2 08             	add    $0x8,%edx
80106131:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106138:	00 
80106139:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010613c:	89 04 24             	mov    %eax,(%esp)
8010613f:	e8 d8 ae ff ff       	call   8010101c <fileclose>
80106144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106147:	89 04 24             	mov    %eax,(%esp)
8010614a:	e8 cd ae ff ff       	call   8010101c <fileclose>
8010614f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106154:	eb 18                	jmp    8010616e <sys_pipe+0xca>
80106156:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106159:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010615c:	89 10                	mov    %edx,(%eax)
8010615e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106161:	8d 50 04             	lea    0x4(%eax),%edx
80106164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106167:	89 02                	mov    %eax,(%edx)
80106169:	b8 00 00 00 00       	mov    $0x0,%eax
8010616e:	c9                   	leave  
8010616f:	c3                   	ret    

80106170 <sys_fork>:
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	83 ec 08             	sub    $0x8,%esp
80106176:	e8 0a e3 ff ff       	call   80104485 <fork>
8010617b:	c9                   	leave  
8010617c:	c3                   	ret    

8010617d <sys_exit>:
8010617d:	55                   	push   %ebp
8010617e:	89 e5                	mov    %esp,%ebp
80106180:	83 ec 08             	sub    $0x8,%esp
80106183:	e8 6b e4 ff ff       	call   801045f3 <exit>
80106188:	b8 00 00 00 00       	mov    $0x0,%eax
8010618d:	c9                   	leave  
8010618e:	c3                   	ret    

8010618f <sys_wait>:
8010618f:	55                   	push   %ebp
80106190:	89 e5                	mov    %esp,%ebp
80106192:	83 ec 08             	sub    $0x8,%esp
80106195:	e8 81 e5 ff ff       	call   8010471b <wait>
8010619a:	c9                   	leave  
8010619b:	c3                   	ret    

8010619c <sys_kill>:
8010619c:	55                   	push   %ebp
8010619d:	89 e5                	mov    %esp,%ebp
8010619f:	83 ec 28             	sub    $0x28,%esp
801061a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801061a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061b0:	e8 15 f1 ff ff       	call   801052ca <argint>
801061b5:	85 c0                	test   %eax,%eax
801061b7:	79 07                	jns    801061c0 <sys_kill+0x24>
801061b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061be:	eb 0b                	jmp    801061cb <sys_kill+0x2f>
801061c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c3:	89 04 24             	mov    %eax,(%esp)
801061c6:	e8 78 e9 ff ff       	call   80104b43 <kill>
801061cb:	c9                   	leave  
801061cc:	c3                   	ret    

801061cd <sys_getpid>:
801061cd:	55                   	push   %ebp
801061ce:	89 e5                	mov    %esp,%ebp
801061d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061d6:	8b 40 10             	mov    0x10(%eax),%eax
801061d9:	5d                   	pop    %ebp
801061da:	c3                   	ret    

801061db <sys_sbrk>:
801061db:	55                   	push   %ebp
801061dc:	89 e5                	mov    %esp,%ebp
801061de:	83 ec 28             	sub    $0x28,%esp
801061e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801061e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061ef:	e8 d6 f0 ff ff       	call   801052ca <argint>
801061f4:	85 c0                	test   %eax,%eax
801061f6:	79 07                	jns    801061ff <sys_sbrk+0x24>
801061f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061fd:	eb 24                	jmp    80106223 <sys_sbrk+0x48>
801061ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106205:	8b 00                	mov    (%eax),%eax
80106207:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010620a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010620d:	89 04 24             	mov    %eax,(%esp)
80106210:	e8 cb e1 ff ff       	call   801043e0 <growproc>
80106215:	85 c0                	test   %eax,%eax
80106217:	79 07                	jns    80106220 <sys_sbrk+0x45>
80106219:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010621e:	eb 03                	jmp    80106223 <sys_sbrk+0x48>
80106220:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106223:	c9                   	leave  
80106224:	c3                   	ret    

80106225 <sys_sleep>:
80106225:	55                   	push   %ebp
80106226:	89 e5                	mov    %esp,%ebp
80106228:	83 ec 28             	sub    $0x28,%esp
8010622b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010622e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106232:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106239:	e8 8c f0 ff ff       	call   801052ca <argint>
8010623e:	85 c0                	test   %eax,%eax
80106240:	79 07                	jns    80106249 <sys_sleep+0x24>
80106242:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106247:	eb 6c                	jmp    801062b5 <sys_sleep+0x90>
80106249:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80106250:	e8 ca ea ff ff       	call   80104d1f <acquire>
80106255:	a1 60 2a 11 80       	mov    0x80112a60,%eax
8010625a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010625d:	eb 34                	jmp    80106293 <sys_sleep+0x6e>
8010625f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106265:	8b 40 24             	mov    0x24(%eax),%eax
80106268:	85 c0                	test   %eax,%eax
8010626a:	74 13                	je     8010627f <sys_sleep+0x5a>
8010626c:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80106273:	e8 08 eb ff ff       	call   80104d80 <release>
80106278:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010627d:	eb 36                	jmp    801062b5 <sys_sleep+0x90>
8010627f:	c7 44 24 04 20 22 11 	movl   $0x80112220,0x4(%esp)
80106286:	80 
80106287:	c7 04 24 60 2a 11 80 	movl   $0x80112a60,(%esp)
8010628e:	e8 9d e7 ff ff       	call   80104a30 <sleep>
80106293:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80106298:	89 c2                	mov    %eax,%edx
8010629a:	2b 55 f4             	sub    -0xc(%ebp),%edx
8010629d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062a0:	39 c2                	cmp    %eax,%edx
801062a2:	72 bb                	jb     8010625f <sys_sleep+0x3a>
801062a4:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
801062ab:	e8 d0 ea ff ff       	call   80104d80 <release>
801062b0:	b8 00 00 00 00       	mov    $0x0,%eax
801062b5:	c9                   	leave  
801062b6:	c3                   	ret    

801062b7 <sys_uptime>:
801062b7:	55                   	push   %ebp
801062b8:	89 e5                	mov    %esp,%ebp
801062ba:	83 ec 28             	sub    $0x28,%esp
801062bd:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
801062c4:	e8 56 ea ff ff       	call   80104d1f <acquire>
801062c9:	a1 60 2a 11 80       	mov    0x80112a60,%eax
801062ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062d1:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
801062d8:	e8 a3 ea ff ff       	call   80104d80 <release>
801062dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e0:	c9                   	leave  
801062e1:	c3                   	ret    
801062e2:	66 90                	xchg   %ax,%ax

801062e4 <outb>:
801062e4:	55                   	push   %ebp
801062e5:	89 e5                	mov    %esp,%ebp
801062e7:	83 ec 08             	sub    $0x8,%esp
801062ea:	8b 55 08             	mov    0x8(%ebp),%edx
801062ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801062f0:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801062f4:	88 45 f8             	mov    %al,-0x8(%ebp)
801062f7:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801062fb:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801062ff:	ee                   	out    %al,(%dx)
80106300:	c9                   	leave  
80106301:	c3                   	ret    

80106302 <timerinit>:
80106302:	55                   	push   %ebp
80106303:	89 e5                	mov    %esp,%ebp
80106305:	83 ec 18             	sub    $0x18,%esp
80106308:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
8010630f:	00 
80106310:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106317:	e8 c8 ff ff ff       	call   801062e4 <outb>
8010631c:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106323:	00 
80106324:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010632b:	e8 b4 ff ff ff       	call   801062e4 <outb>
80106330:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106337:	00 
80106338:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010633f:	e8 a0 ff ff ff       	call   801062e4 <outb>
80106344:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010634b:	e8 b1 d7 ff ff       	call   80103b01 <picenable>
80106350:	c9                   	leave  
80106351:	c3                   	ret    
80106352:	66 90                	xchg   %ax,%ax

80106354 <alltraps>:
80106354:	1e                   	push   %ds
80106355:	06                   	push   %es
80106356:	0f a0                	push   %fs
80106358:	0f a8                	push   %gs
8010635a:	60                   	pusha  
8010635b:	66 b8 10 00          	mov    $0x10,%ax
8010635f:	8e d8                	mov    %eax,%ds
80106361:	8e c0                	mov    %eax,%es
80106363:	66 b8 18 00          	mov    $0x18,%ax
80106367:	8e e0                	mov    %eax,%fs
80106369:	8e e8                	mov    %eax,%gs
8010636b:	54                   	push   %esp
8010636c:	e8 d5 01 00 00       	call   80106546 <trap>
80106371:	83 c4 04             	add    $0x4,%esp

80106374 <trapret>:
80106374:	61                   	popa   
80106375:	0f a9                	pop    %gs
80106377:	0f a1                	pop    %fs
80106379:	07                   	pop    %es
8010637a:	1f                   	pop    %ds
8010637b:	83 c4 08             	add    $0x8,%esp
8010637e:	cf                   	iret   
8010637f:	90                   	nop

80106380 <lidt>:
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	83 ec 10             	sub    $0x10,%esp
80106386:	8b 45 0c             	mov    0xc(%ebp),%eax
80106389:	83 e8 01             	sub    $0x1,%eax
8010638c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
80106390:	8b 45 08             	mov    0x8(%ebp),%eax
80106393:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106397:	8b 45 08             	mov    0x8(%ebp),%eax
8010639a:	c1 e8 10             	shr    $0x10,%eax
8010639d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
801063a1:	8d 45 fa             	lea    -0x6(%ebp),%eax
801063a4:	0f 01 18             	lidtl  (%eax)
801063a7:	c9                   	leave  
801063a8:	c3                   	ret    

801063a9 <rcr2>:
801063a9:	55                   	push   %ebp
801063aa:	89 e5                	mov    %esp,%ebp
801063ac:	83 ec 10             	sub    $0x10,%esp
801063af:	0f 20 d0             	mov    %cr2,%eax
801063b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
801063b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801063b8:	c9                   	leave  
801063b9:	c3                   	ret    

801063ba <tvinit>:
801063ba:	55                   	push   %ebp
801063bb:	89 e5                	mov    %esp,%ebp
801063bd:	83 ec 28             	sub    $0x28,%esp
801063c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801063c7:	e9 bf 00 00 00       	jmp    8010648b <tvinit+0xd1>
801063cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063d2:	8b 14 95 98 b0 10 80 	mov    -0x7fef4f68(,%edx,4),%edx
801063d9:	66 89 14 c5 60 22 11 	mov    %dx,-0x7feedda0(,%eax,8)
801063e0:	80 
801063e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063e4:	66 c7 04 c5 62 22 11 	movw   $0x8,-0x7feedd9e(,%eax,8)
801063eb:	80 08 00 
801063ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063f1:	0f b6 14 c5 64 22 11 	movzbl -0x7feedd9c(,%eax,8),%edx
801063f8:	80 
801063f9:	83 e2 e0             	and    $0xffffffe0,%edx
801063fc:	88 14 c5 64 22 11 80 	mov    %dl,-0x7feedd9c(,%eax,8)
80106403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106406:	0f b6 14 c5 64 22 11 	movzbl -0x7feedd9c(,%eax,8),%edx
8010640d:	80 
8010640e:	83 e2 1f             	and    $0x1f,%edx
80106411:	88 14 c5 64 22 11 80 	mov    %dl,-0x7feedd9c(,%eax,8)
80106418:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010641b:	0f b6 14 c5 65 22 11 	movzbl -0x7feedd9b(,%eax,8),%edx
80106422:	80 
80106423:	83 e2 f0             	and    $0xfffffff0,%edx
80106426:	83 ca 0e             	or     $0xe,%edx
80106429:	88 14 c5 65 22 11 80 	mov    %dl,-0x7feedd9b(,%eax,8)
80106430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106433:	0f b6 14 c5 65 22 11 	movzbl -0x7feedd9b(,%eax,8),%edx
8010643a:	80 
8010643b:	83 e2 ef             	and    $0xffffffef,%edx
8010643e:	88 14 c5 65 22 11 80 	mov    %dl,-0x7feedd9b(,%eax,8)
80106445:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106448:	0f b6 14 c5 65 22 11 	movzbl -0x7feedd9b(,%eax,8),%edx
8010644f:	80 
80106450:	83 e2 9f             	and    $0xffffff9f,%edx
80106453:	88 14 c5 65 22 11 80 	mov    %dl,-0x7feedd9b(,%eax,8)
8010645a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010645d:	0f b6 14 c5 65 22 11 	movzbl -0x7feedd9b(,%eax,8),%edx
80106464:	80 
80106465:	83 ca 80             	or     $0xffffff80,%edx
80106468:	88 14 c5 65 22 11 80 	mov    %dl,-0x7feedd9b(,%eax,8)
8010646f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106472:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106475:	8b 14 95 98 b0 10 80 	mov    -0x7fef4f68(,%edx,4),%edx
8010647c:	c1 ea 10             	shr    $0x10,%edx
8010647f:	66 89 14 c5 66 22 11 	mov    %dx,-0x7feedd9a(,%eax,8)
80106486:	80 
80106487:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010648b:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106492:	0f 8e 34 ff ff ff    	jle    801063cc <tvinit+0x12>
80106498:	a1 98 b1 10 80       	mov    0x8010b198,%eax
8010649d:	66 a3 60 24 11 80    	mov    %ax,0x80112460
801064a3:	66 c7 05 62 24 11 80 	movw   $0x8,0x80112462
801064aa:	08 00 
801064ac:	0f b6 05 64 24 11 80 	movzbl 0x80112464,%eax
801064b3:	83 e0 e0             	and    $0xffffffe0,%eax
801064b6:	a2 64 24 11 80       	mov    %al,0x80112464
801064bb:	0f b6 05 64 24 11 80 	movzbl 0x80112464,%eax
801064c2:	83 e0 1f             	and    $0x1f,%eax
801064c5:	a2 64 24 11 80       	mov    %al,0x80112464
801064ca:	0f b6 05 65 24 11 80 	movzbl 0x80112465,%eax
801064d1:	83 c8 0f             	or     $0xf,%eax
801064d4:	a2 65 24 11 80       	mov    %al,0x80112465
801064d9:	0f b6 05 65 24 11 80 	movzbl 0x80112465,%eax
801064e0:	83 e0 ef             	and    $0xffffffef,%eax
801064e3:	a2 65 24 11 80       	mov    %al,0x80112465
801064e8:	0f b6 05 65 24 11 80 	movzbl 0x80112465,%eax
801064ef:	83 c8 60             	or     $0x60,%eax
801064f2:	a2 65 24 11 80       	mov    %al,0x80112465
801064f7:	0f b6 05 65 24 11 80 	movzbl 0x80112465,%eax
801064fe:	83 c8 80             	or     $0xffffff80,%eax
80106501:	a2 65 24 11 80       	mov    %al,0x80112465
80106506:	a1 98 b1 10 80       	mov    0x8010b198,%eax
8010650b:	c1 e8 10             	shr    $0x10,%eax
8010650e:	66 a3 66 24 11 80    	mov    %ax,0x80112466
80106514:	c7 44 24 04 44 87 10 	movl   $0x80108744,0x4(%esp)
8010651b:	80 
8010651c:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80106523:	e8 d6 e7 ff ff       	call   80104cfe <initlock>
80106528:	c9                   	leave  
80106529:	c3                   	ret    

8010652a <idtinit>:
8010652a:	55                   	push   %ebp
8010652b:	89 e5                	mov    %esp,%ebp
8010652d:	83 ec 08             	sub    $0x8,%esp
80106530:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106537:	00 
80106538:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010653f:	e8 3c fe ff ff       	call   80106380 <lidt>
80106544:	c9                   	leave  
80106545:	c3                   	ret    

80106546 <trap>:
80106546:	55                   	push   %ebp
80106547:	89 e5                	mov    %esp,%ebp
80106549:	57                   	push   %edi
8010654a:	56                   	push   %esi
8010654b:	53                   	push   %ebx
8010654c:	83 ec 3c             	sub    $0x3c,%esp
8010654f:	8b 45 08             	mov    0x8(%ebp),%eax
80106552:	8b 40 30             	mov    0x30(%eax),%eax
80106555:	83 f8 40             	cmp    $0x40,%eax
80106558:	75 3e                	jne    80106598 <trap+0x52>
8010655a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106560:	8b 40 24             	mov    0x24(%eax),%eax
80106563:	85 c0                	test   %eax,%eax
80106565:	74 05                	je     8010656c <trap+0x26>
80106567:	e8 87 e0 ff ff       	call   801045f3 <exit>
8010656c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106572:	8b 55 08             	mov    0x8(%ebp),%edx
80106575:	89 50 18             	mov    %edx,0x18(%eax)
80106578:	e8 15 ee ff ff       	call   80105392 <syscall>
8010657d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106583:	8b 40 24             	mov    0x24(%eax),%eax
80106586:	85 c0                	test   %eax,%eax
80106588:	0f 84 34 02 00 00    	je     801067c2 <trap+0x27c>
8010658e:	e8 60 e0 ff ff       	call   801045f3 <exit>
80106593:	e9 2b 02 00 00       	jmp    801067c3 <trap+0x27d>
80106598:	8b 45 08             	mov    0x8(%ebp),%eax
8010659b:	8b 40 30             	mov    0x30(%eax),%eax
8010659e:	83 e8 20             	sub    $0x20,%eax
801065a1:	83 f8 1f             	cmp    $0x1f,%eax
801065a4:	0f 87 bc 00 00 00    	ja     80106666 <trap+0x120>
801065aa:	8b 04 85 ec 87 10 80 	mov    -0x7fef7814(,%eax,4),%eax
801065b1:	ff e0                	jmp    *%eax
801065b3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801065b9:	0f b6 00             	movzbl (%eax),%eax
801065bc:	84 c0                	test   %al,%al
801065be:	75 31                	jne    801065f1 <trap+0xab>
801065c0:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
801065c7:	e8 53 e7 ff ff       	call   80104d1f <acquire>
801065cc:	a1 60 2a 11 80       	mov    0x80112a60,%eax
801065d1:	83 c0 01             	add    $0x1,%eax
801065d4:	a3 60 2a 11 80       	mov    %eax,0x80112a60
801065d9:	c7 04 24 60 2a 11 80 	movl   $0x80112a60,(%esp)
801065e0:	e8 33 e5 ff ff       	call   80104b18 <wakeup>
801065e5:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
801065ec:	e8 8f e7 ff ff       	call   80104d80 <release>
801065f1:	e8 5a c9 ff ff       	call   80102f50 <lapiceoi>
801065f6:	e9 41 01 00 00       	jmp    8010673c <trap+0x1f6>
801065fb:	e8 6d c1 ff ff       	call   8010276d <ideintr>
80106600:	e8 4b c9 ff ff       	call   80102f50 <lapiceoi>
80106605:	e9 32 01 00 00       	jmp    8010673c <trap+0x1f6>
8010660a:	e8 24 c7 ff ff       	call   80102d33 <kbdintr>
8010660f:	e8 3c c9 ff ff       	call   80102f50 <lapiceoi>
80106614:	e9 23 01 00 00       	jmp    8010673c <trap+0x1f6>
80106619:	e8 aa 03 00 00       	call   801069c8 <uartintr>
8010661e:	e8 2d c9 ff ff       	call   80102f50 <lapiceoi>
80106623:	e9 14 01 00 00       	jmp    8010673c <trap+0x1f6>
80106628:	8b 45 08             	mov    0x8(%ebp),%eax
8010662b:	8b 48 38             	mov    0x38(%eax),%ecx
8010662e:	8b 45 08             	mov    0x8(%ebp),%eax
80106631:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106635:	0f b7 d0             	movzwl %ax,%edx
80106638:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010663e:	0f b6 00             	movzbl (%eax),%eax
80106641:	0f b6 c0             	movzbl %al,%eax
80106644:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106648:	89 54 24 08          	mov    %edx,0x8(%esp)
8010664c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106650:	c7 04 24 4c 87 10 80 	movl   $0x8010874c,(%esp)
80106657:	e8 4e 9d ff ff       	call   801003aa <cprintf>
8010665c:	e8 ef c8 ff ff       	call   80102f50 <lapiceoi>
80106661:	e9 d6 00 00 00       	jmp    8010673c <trap+0x1f6>
80106666:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010666c:	85 c0                	test   %eax,%eax
8010666e:	74 11                	je     80106681 <trap+0x13b>
80106670:	8b 45 08             	mov    0x8(%ebp),%eax
80106673:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106677:	0f b7 c0             	movzwl %ax,%eax
8010667a:	83 e0 03             	and    $0x3,%eax
8010667d:	85 c0                	test   %eax,%eax
8010667f:	75 46                	jne    801066c7 <trap+0x181>
80106681:	e8 23 fd ff ff       	call   801063a9 <rcr2>
80106686:	8b 55 08             	mov    0x8(%ebp),%edx
80106689:	8b 5a 38             	mov    0x38(%edx),%ebx
8010668c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106693:	0f b6 12             	movzbl (%edx),%edx
80106696:	0f b6 ca             	movzbl %dl,%ecx
80106699:	8b 55 08             	mov    0x8(%ebp),%edx
8010669c:	8b 52 30             	mov    0x30(%edx),%edx
8010669f:	89 44 24 10          	mov    %eax,0x10(%esp)
801066a3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801066a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801066ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801066af:	c7 04 24 70 87 10 80 	movl   $0x80108770,(%esp)
801066b6:	e8 ef 9c ff ff       	call   801003aa <cprintf>
801066bb:	c7 04 24 a2 87 10 80 	movl   $0x801087a2,(%esp)
801066c2:	e8 7f 9e ff ff       	call   80100546 <panic>
801066c7:	e8 dd fc ff ff       	call   801063a9 <rcr2>
801066cc:	89 c2                	mov    %eax,%edx
801066ce:	8b 45 08             	mov    0x8(%ebp),%eax
801066d1:	8b 78 38             	mov    0x38(%eax),%edi
801066d4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801066da:	0f b6 00             	movzbl (%eax),%eax
801066dd:	0f b6 f0             	movzbl %al,%esi
801066e0:	8b 45 08             	mov    0x8(%ebp),%eax
801066e3:	8b 58 34             	mov    0x34(%eax),%ebx
801066e6:	8b 45 08             	mov    0x8(%ebp),%eax
801066e9:	8b 48 30             	mov    0x30(%eax),%ecx
801066ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066f2:	83 c0 6c             	add    $0x6c,%eax
801066f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066fe:	8b 40 10             	mov    0x10(%eax),%eax
80106701:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106705:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106709:	89 74 24 14          	mov    %esi,0x14(%esp)
8010670d:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106711:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106715:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106718:	89 54 24 08          	mov    %edx,0x8(%esp)
8010671c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106720:	c7 04 24 a8 87 10 80 	movl   $0x801087a8,(%esp)
80106727:	e8 7e 9c ff ff       	call   801003aa <cprintf>
8010672c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106732:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106739:	eb 01                	jmp    8010673c <trap+0x1f6>
8010673b:	90                   	nop
8010673c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106742:	85 c0                	test   %eax,%eax
80106744:	74 24                	je     8010676a <trap+0x224>
80106746:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010674c:	8b 40 24             	mov    0x24(%eax),%eax
8010674f:	85 c0                	test   %eax,%eax
80106751:	74 17                	je     8010676a <trap+0x224>
80106753:	8b 45 08             	mov    0x8(%ebp),%eax
80106756:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010675a:	0f b7 c0             	movzwl %ax,%eax
8010675d:	83 e0 03             	and    $0x3,%eax
80106760:	83 f8 03             	cmp    $0x3,%eax
80106763:	75 05                	jne    8010676a <trap+0x224>
80106765:	e8 89 de ff ff       	call   801045f3 <exit>
8010676a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106770:	85 c0                	test   %eax,%eax
80106772:	74 1e                	je     80106792 <trap+0x24c>
80106774:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010677a:	8b 40 0c             	mov    0xc(%eax),%eax
8010677d:	83 f8 04             	cmp    $0x4,%eax
80106780:	75 10                	jne    80106792 <trap+0x24c>
80106782:	8b 45 08             	mov    0x8(%ebp),%eax
80106785:	8b 40 30             	mov    0x30(%eax),%eax
80106788:	83 f8 20             	cmp    $0x20,%eax
8010678b:	75 05                	jne    80106792 <trap+0x24c>
8010678d:	e8 32 e2 ff ff       	call   801049c4 <yield>
80106792:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106798:	85 c0                	test   %eax,%eax
8010679a:	74 27                	je     801067c3 <trap+0x27d>
8010679c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067a2:	8b 40 24             	mov    0x24(%eax),%eax
801067a5:	85 c0                	test   %eax,%eax
801067a7:	74 1a                	je     801067c3 <trap+0x27d>
801067a9:	8b 45 08             	mov    0x8(%ebp),%eax
801067ac:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801067b0:	0f b7 c0             	movzwl %ax,%eax
801067b3:	83 e0 03             	and    $0x3,%eax
801067b6:	83 f8 03             	cmp    $0x3,%eax
801067b9:	75 08                	jne    801067c3 <trap+0x27d>
801067bb:	e8 33 de ff ff       	call   801045f3 <exit>
801067c0:	eb 01                	jmp    801067c3 <trap+0x27d>
801067c2:	90                   	nop
801067c3:	83 c4 3c             	add    $0x3c,%esp
801067c6:	5b                   	pop    %ebx
801067c7:	5e                   	pop    %esi
801067c8:	5f                   	pop    %edi
801067c9:	5d                   	pop    %ebp
801067ca:	c3                   	ret    
801067cb:	90                   	nop

801067cc <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801067cc:	55                   	push   %ebp
801067cd:	89 e5                	mov    %esp,%ebp
801067cf:	53                   	push   %ebx
801067d0:	83 ec 14             	sub    $0x14,%esp
801067d3:	8b 45 08             	mov    0x8(%ebp),%eax
801067d6:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067da:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
801067de:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801067e2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801067e6:	ec                   	in     (%dx),%al
801067e7:	89 c3                	mov    %eax,%ebx
801067e9:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801067ec:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801067f0:	83 c4 14             	add    $0x14,%esp
801067f3:	5b                   	pop    %ebx
801067f4:	5d                   	pop    %ebp
801067f5:	c3                   	ret    

801067f6 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801067f6:	55                   	push   %ebp
801067f7:	89 e5                	mov    %esp,%ebp
801067f9:	83 ec 08             	sub    $0x8,%esp
801067fc:	8b 55 08             	mov    0x8(%ebp),%edx
801067ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80106802:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106806:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106809:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010680d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106811:	ee                   	out    %al,(%dx)
}
80106812:	c9                   	leave  
80106813:	c3                   	ret    

80106814 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106814:	55                   	push   %ebp
80106815:	89 e5                	mov    %esp,%ebp
80106817:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010681a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106821:	00 
80106822:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106829:	e8 c8 ff ff ff       	call   801067f6 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010682e:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106835:	00 
80106836:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010683d:	e8 b4 ff ff ff       	call   801067f6 <outb>
  outb(COM1+0, 115200/9600);
80106842:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106849:	00 
8010684a:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106851:	e8 a0 ff ff ff       	call   801067f6 <outb>
  outb(COM1+1, 0);
80106856:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010685d:	00 
8010685e:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106865:	e8 8c ff ff ff       	call   801067f6 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010686a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106871:	00 
80106872:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106879:	e8 78 ff ff ff       	call   801067f6 <outb>
  outb(COM1+4, 0);
8010687e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106885:	00 
80106886:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
8010688d:	e8 64 ff ff ff       	call   801067f6 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106892:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106899:	00 
8010689a:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801068a1:	e8 50 ff ff ff       	call   801067f6 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801068a6:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801068ad:	e8 1a ff ff ff       	call   801067cc <inb>
801068b2:	3c ff                	cmp    $0xff,%al
801068b4:	74 6c                	je     80106922 <uartinit+0x10e>
    return;
  uart = 1;
801068b6:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
801068bd:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801068c0:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801068c7:	e8 00 ff ff ff       	call   801067cc <inb>
  inb(COM1+0);
801068cc:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801068d3:	e8 f4 fe ff ff       	call   801067cc <inb>
  picenable(IRQ_COM1);
801068d8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801068df:	e8 1d d2 ff ff       	call   80103b01 <picenable>
  ioapicenable(IRQ_COM1, 0);
801068e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068eb:	00 
801068ec:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801068f3:	e8 fa c0 ff ff       	call   801029f2 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801068f8:	c7 45 f4 6c 88 10 80 	movl   $0x8010886c,-0xc(%ebp)
801068ff:	eb 15                	jmp    80106916 <uartinit+0x102>
    uartputc(*p);
80106901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106904:	0f b6 00             	movzbl (%eax),%eax
80106907:	0f be c0             	movsbl %al,%eax
8010690a:	89 04 24             	mov    %eax,(%esp)
8010690d:	e8 13 00 00 00       	call   80106925 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106912:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106919:	0f b6 00             	movzbl (%eax),%eax
8010691c:	84 c0                	test   %al,%al
8010691e:	75 e1                	jne    80106901 <uartinit+0xed>
80106920:	eb 01                	jmp    80106923 <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106922:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106923:	c9                   	leave  
80106924:	c3                   	ret    

80106925 <uartputc>:

void
uartputc(int c)
{
80106925:	55                   	push   %ebp
80106926:	89 e5                	mov    %esp,%ebp
80106928:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010692b:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106930:	85 c0                	test   %eax,%eax
80106932:	74 4d                	je     80106981 <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106934:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010693b:	eb 10                	jmp    8010694d <uartputc+0x28>
    microdelay(10);
8010693d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106944:	e8 2c c6 ff ff       	call   80102f75 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106949:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010694d:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106951:	7f 16                	jg     80106969 <uartputc+0x44>
80106953:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010695a:	e8 6d fe ff ff       	call   801067cc <inb>
8010695f:	0f b6 c0             	movzbl %al,%eax
80106962:	83 e0 20             	and    $0x20,%eax
80106965:	85 c0                	test   %eax,%eax
80106967:	74 d4                	je     8010693d <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106969:	8b 45 08             	mov    0x8(%ebp),%eax
8010696c:	0f b6 c0             	movzbl %al,%eax
8010696f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106973:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010697a:	e8 77 fe ff ff       	call   801067f6 <outb>
8010697f:	eb 01                	jmp    80106982 <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106981:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106982:	c9                   	leave  
80106983:	c3                   	ret    

80106984 <uartgetc>:

static int
uartgetc(void)
{
80106984:	55                   	push   %ebp
80106985:	89 e5                	mov    %esp,%ebp
80106987:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
8010698a:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
8010698f:	85 c0                	test   %eax,%eax
80106991:	75 07                	jne    8010699a <uartgetc+0x16>
    return -1;
80106993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106998:	eb 2c                	jmp    801069c6 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
8010699a:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801069a1:	e8 26 fe ff ff       	call   801067cc <inb>
801069a6:	0f b6 c0             	movzbl %al,%eax
801069a9:	83 e0 01             	and    $0x1,%eax
801069ac:	85 c0                	test   %eax,%eax
801069ae:	75 07                	jne    801069b7 <uartgetc+0x33>
    return -1;
801069b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069b5:	eb 0f                	jmp    801069c6 <uartgetc+0x42>
  return inb(COM1+0);
801069b7:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801069be:	e8 09 fe ff ff       	call   801067cc <inb>
801069c3:	0f b6 c0             	movzbl %al,%eax
}
801069c6:	c9                   	leave  
801069c7:	c3                   	ret    

801069c8 <uartintr>:

void
uartintr(void)
{
801069c8:	55                   	push   %ebp
801069c9:	89 e5                	mov    %esp,%ebp
801069cb:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801069ce:	c7 04 24 84 69 10 80 	movl   $0x80106984,(%esp)
801069d5:	e8 dc 9d ff ff       	call   801007b6 <consoleintr>
}
801069da:	c9                   	leave  
801069db:	c3                   	ret    

801069dc <vector0>:
801069dc:	6a 00                	push   $0x0
801069de:	6a 00                	push   $0x0
801069e0:	e9 6f f9 ff ff       	jmp    80106354 <alltraps>

801069e5 <vector1>:
801069e5:	6a 00                	push   $0x0
801069e7:	6a 01                	push   $0x1
801069e9:	e9 66 f9 ff ff       	jmp    80106354 <alltraps>

801069ee <vector2>:
801069ee:	6a 00                	push   $0x0
801069f0:	6a 02                	push   $0x2
801069f2:	e9 5d f9 ff ff       	jmp    80106354 <alltraps>

801069f7 <vector3>:
801069f7:	6a 00                	push   $0x0
801069f9:	6a 03                	push   $0x3
801069fb:	e9 54 f9 ff ff       	jmp    80106354 <alltraps>

80106a00 <vector4>:
80106a00:	6a 00                	push   $0x0
80106a02:	6a 04                	push   $0x4
80106a04:	e9 4b f9 ff ff       	jmp    80106354 <alltraps>

80106a09 <vector5>:
80106a09:	6a 00                	push   $0x0
80106a0b:	6a 05                	push   $0x5
80106a0d:	e9 42 f9 ff ff       	jmp    80106354 <alltraps>

80106a12 <vector6>:
80106a12:	6a 00                	push   $0x0
80106a14:	6a 06                	push   $0x6
80106a16:	e9 39 f9 ff ff       	jmp    80106354 <alltraps>

80106a1b <vector7>:
80106a1b:	6a 00                	push   $0x0
80106a1d:	6a 07                	push   $0x7
80106a1f:	e9 30 f9 ff ff       	jmp    80106354 <alltraps>

80106a24 <vector8>:
80106a24:	6a 08                	push   $0x8
80106a26:	e9 29 f9 ff ff       	jmp    80106354 <alltraps>

80106a2b <vector9>:
80106a2b:	6a 00                	push   $0x0
80106a2d:	6a 09                	push   $0x9
80106a2f:	e9 20 f9 ff ff       	jmp    80106354 <alltraps>

80106a34 <vector10>:
80106a34:	6a 0a                	push   $0xa
80106a36:	e9 19 f9 ff ff       	jmp    80106354 <alltraps>

80106a3b <vector11>:
80106a3b:	6a 0b                	push   $0xb
80106a3d:	e9 12 f9 ff ff       	jmp    80106354 <alltraps>

80106a42 <vector12>:
80106a42:	6a 0c                	push   $0xc
80106a44:	e9 0b f9 ff ff       	jmp    80106354 <alltraps>

80106a49 <vector13>:
80106a49:	6a 0d                	push   $0xd
80106a4b:	e9 04 f9 ff ff       	jmp    80106354 <alltraps>

80106a50 <vector14>:
80106a50:	6a 0e                	push   $0xe
80106a52:	e9 fd f8 ff ff       	jmp    80106354 <alltraps>

80106a57 <vector15>:
80106a57:	6a 00                	push   $0x0
80106a59:	6a 0f                	push   $0xf
80106a5b:	e9 f4 f8 ff ff       	jmp    80106354 <alltraps>

80106a60 <vector16>:
80106a60:	6a 00                	push   $0x0
80106a62:	6a 10                	push   $0x10
80106a64:	e9 eb f8 ff ff       	jmp    80106354 <alltraps>

80106a69 <vector17>:
80106a69:	6a 11                	push   $0x11
80106a6b:	e9 e4 f8 ff ff       	jmp    80106354 <alltraps>

80106a70 <vector18>:
80106a70:	6a 00                	push   $0x0
80106a72:	6a 12                	push   $0x12
80106a74:	e9 db f8 ff ff       	jmp    80106354 <alltraps>

80106a79 <vector19>:
80106a79:	6a 00                	push   $0x0
80106a7b:	6a 13                	push   $0x13
80106a7d:	e9 d2 f8 ff ff       	jmp    80106354 <alltraps>

80106a82 <vector20>:
80106a82:	6a 00                	push   $0x0
80106a84:	6a 14                	push   $0x14
80106a86:	e9 c9 f8 ff ff       	jmp    80106354 <alltraps>

80106a8b <vector21>:
80106a8b:	6a 00                	push   $0x0
80106a8d:	6a 15                	push   $0x15
80106a8f:	e9 c0 f8 ff ff       	jmp    80106354 <alltraps>

80106a94 <vector22>:
80106a94:	6a 00                	push   $0x0
80106a96:	6a 16                	push   $0x16
80106a98:	e9 b7 f8 ff ff       	jmp    80106354 <alltraps>

80106a9d <vector23>:
80106a9d:	6a 00                	push   $0x0
80106a9f:	6a 17                	push   $0x17
80106aa1:	e9 ae f8 ff ff       	jmp    80106354 <alltraps>

80106aa6 <vector24>:
80106aa6:	6a 00                	push   $0x0
80106aa8:	6a 18                	push   $0x18
80106aaa:	e9 a5 f8 ff ff       	jmp    80106354 <alltraps>

80106aaf <vector25>:
80106aaf:	6a 00                	push   $0x0
80106ab1:	6a 19                	push   $0x19
80106ab3:	e9 9c f8 ff ff       	jmp    80106354 <alltraps>

80106ab8 <vector26>:
80106ab8:	6a 00                	push   $0x0
80106aba:	6a 1a                	push   $0x1a
80106abc:	e9 93 f8 ff ff       	jmp    80106354 <alltraps>

80106ac1 <vector27>:
80106ac1:	6a 00                	push   $0x0
80106ac3:	6a 1b                	push   $0x1b
80106ac5:	e9 8a f8 ff ff       	jmp    80106354 <alltraps>

80106aca <vector28>:
80106aca:	6a 00                	push   $0x0
80106acc:	6a 1c                	push   $0x1c
80106ace:	e9 81 f8 ff ff       	jmp    80106354 <alltraps>

80106ad3 <vector29>:
80106ad3:	6a 00                	push   $0x0
80106ad5:	6a 1d                	push   $0x1d
80106ad7:	e9 78 f8 ff ff       	jmp    80106354 <alltraps>

80106adc <vector30>:
80106adc:	6a 00                	push   $0x0
80106ade:	6a 1e                	push   $0x1e
80106ae0:	e9 6f f8 ff ff       	jmp    80106354 <alltraps>

80106ae5 <vector31>:
80106ae5:	6a 00                	push   $0x0
80106ae7:	6a 1f                	push   $0x1f
80106ae9:	e9 66 f8 ff ff       	jmp    80106354 <alltraps>

80106aee <vector32>:
80106aee:	6a 00                	push   $0x0
80106af0:	6a 20                	push   $0x20
80106af2:	e9 5d f8 ff ff       	jmp    80106354 <alltraps>

80106af7 <vector33>:
80106af7:	6a 00                	push   $0x0
80106af9:	6a 21                	push   $0x21
80106afb:	e9 54 f8 ff ff       	jmp    80106354 <alltraps>

80106b00 <vector34>:
80106b00:	6a 00                	push   $0x0
80106b02:	6a 22                	push   $0x22
80106b04:	e9 4b f8 ff ff       	jmp    80106354 <alltraps>

80106b09 <vector35>:
80106b09:	6a 00                	push   $0x0
80106b0b:	6a 23                	push   $0x23
80106b0d:	e9 42 f8 ff ff       	jmp    80106354 <alltraps>

80106b12 <vector36>:
80106b12:	6a 00                	push   $0x0
80106b14:	6a 24                	push   $0x24
80106b16:	e9 39 f8 ff ff       	jmp    80106354 <alltraps>

80106b1b <vector37>:
80106b1b:	6a 00                	push   $0x0
80106b1d:	6a 25                	push   $0x25
80106b1f:	e9 30 f8 ff ff       	jmp    80106354 <alltraps>

80106b24 <vector38>:
80106b24:	6a 00                	push   $0x0
80106b26:	6a 26                	push   $0x26
80106b28:	e9 27 f8 ff ff       	jmp    80106354 <alltraps>

80106b2d <vector39>:
80106b2d:	6a 00                	push   $0x0
80106b2f:	6a 27                	push   $0x27
80106b31:	e9 1e f8 ff ff       	jmp    80106354 <alltraps>

80106b36 <vector40>:
80106b36:	6a 00                	push   $0x0
80106b38:	6a 28                	push   $0x28
80106b3a:	e9 15 f8 ff ff       	jmp    80106354 <alltraps>

80106b3f <vector41>:
80106b3f:	6a 00                	push   $0x0
80106b41:	6a 29                	push   $0x29
80106b43:	e9 0c f8 ff ff       	jmp    80106354 <alltraps>

80106b48 <vector42>:
80106b48:	6a 00                	push   $0x0
80106b4a:	6a 2a                	push   $0x2a
80106b4c:	e9 03 f8 ff ff       	jmp    80106354 <alltraps>

80106b51 <vector43>:
80106b51:	6a 00                	push   $0x0
80106b53:	6a 2b                	push   $0x2b
80106b55:	e9 fa f7 ff ff       	jmp    80106354 <alltraps>

80106b5a <vector44>:
80106b5a:	6a 00                	push   $0x0
80106b5c:	6a 2c                	push   $0x2c
80106b5e:	e9 f1 f7 ff ff       	jmp    80106354 <alltraps>

80106b63 <vector45>:
80106b63:	6a 00                	push   $0x0
80106b65:	6a 2d                	push   $0x2d
80106b67:	e9 e8 f7 ff ff       	jmp    80106354 <alltraps>

80106b6c <vector46>:
80106b6c:	6a 00                	push   $0x0
80106b6e:	6a 2e                	push   $0x2e
80106b70:	e9 df f7 ff ff       	jmp    80106354 <alltraps>

80106b75 <vector47>:
80106b75:	6a 00                	push   $0x0
80106b77:	6a 2f                	push   $0x2f
80106b79:	e9 d6 f7 ff ff       	jmp    80106354 <alltraps>

80106b7e <vector48>:
80106b7e:	6a 00                	push   $0x0
80106b80:	6a 30                	push   $0x30
80106b82:	e9 cd f7 ff ff       	jmp    80106354 <alltraps>

80106b87 <vector49>:
80106b87:	6a 00                	push   $0x0
80106b89:	6a 31                	push   $0x31
80106b8b:	e9 c4 f7 ff ff       	jmp    80106354 <alltraps>

80106b90 <vector50>:
80106b90:	6a 00                	push   $0x0
80106b92:	6a 32                	push   $0x32
80106b94:	e9 bb f7 ff ff       	jmp    80106354 <alltraps>

80106b99 <vector51>:
80106b99:	6a 00                	push   $0x0
80106b9b:	6a 33                	push   $0x33
80106b9d:	e9 b2 f7 ff ff       	jmp    80106354 <alltraps>

80106ba2 <vector52>:
80106ba2:	6a 00                	push   $0x0
80106ba4:	6a 34                	push   $0x34
80106ba6:	e9 a9 f7 ff ff       	jmp    80106354 <alltraps>

80106bab <vector53>:
80106bab:	6a 00                	push   $0x0
80106bad:	6a 35                	push   $0x35
80106baf:	e9 a0 f7 ff ff       	jmp    80106354 <alltraps>

80106bb4 <vector54>:
80106bb4:	6a 00                	push   $0x0
80106bb6:	6a 36                	push   $0x36
80106bb8:	e9 97 f7 ff ff       	jmp    80106354 <alltraps>

80106bbd <vector55>:
80106bbd:	6a 00                	push   $0x0
80106bbf:	6a 37                	push   $0x37
80106bc1:	e9 8e f7 ff ff       	jmp    80106354 <alltraps>

80106bc6 <vector56>:
80106bc6:	6a 00                	push   $0x0
80106bc8:	6a 38                	push   $0x38
80106bca:	e9 85 f7 ff ff       	jmp    80106354 <alltraps>

80106bcf <vector57>:
80106bcf:	6a 00                	push   $0x0
80106bd1:	6a 39                	push   $0x39
80106bd3:	e9 7c f7 ff ff       	jmp    80106354 <alltraps>

80106bd8 <vector58>:
80106bd8:	6a 00                	push   $0x0
80106bda:	6a 3a                	push   $0x3a
80106bdc:	e9 73 f7 ff ff       	jmp    80106354 <alltraps>

80106be1 <vector59>:
80106be1:	6a 00                	push   $0x0
80106be3:	6a 3b                	push   $0x3b
80106be5:	e9 6a f7 ff ff       	jmp    80106354 <alltraps>

80106bea <vector60>:
80106bea:	6a 00                	push   $0x0
80106bec:	6a 3c                	push   $0x3c
80106bee:	e9 61 f7 ff ff       	jmp    80106354 <alltraps>

80106bf3 <vector61>:
80106bf3:	6a 00                	push   $0x0
80106bf5:	6a 3d                	push   $0x3d
80106bf7:	e9 58 f7 ff ff       	jmp    80106354 <alltraps>

80106bfc <vector62>:
80106bfc:	6a 00                	push   $0x0
80106bfe:	6a 3e                	push   $0x3e
80106c00:	e9 4f f7 ff ff       	jmp    80106354 <alltraps>

80106c05 <vector63>:
80106c05:	6a 00                	push   $0x0
80106c07:	6a 3f                	push   $0x3f
80106c09:	e9 46 f7 ff ff       	jmp    80106354 <alltraps>

80106c0e <vector64>:
80106c0e:	6a 00                	push   $0x0
80106c10:	6a 40                	push   $0x40
80106c12:	e9 3d f7 ff ff       	jmp    80106354 <alltraps>

80106c17 <vector65>:
80106c17:	6a 00                	push   $0x0
80106c19:	6a 41                	push   $0x41
80106c1b:	e9 34 f7 ff ff       	jmp    80106354 <alltraps>

80106c20 <vector66>:
80106c20:	6a 00                	push   $0x0
80106c22:	6a 42                	push   $0x42
80106c24:	e9 2b f7 ff ff       	jmp    80106354 <alltraps>

80106c29 <vector67>:
80106c29:	6a 00                	push   $0x0
80106c2b:	6a 43                	push   $0x43
80106c2d:	e9 22 f7 ff ff       	jmp    80106354 <alltraps>

80106c32 <vector68>:
80106c32:	6a 00                	push   $0x0
80106c34:	6a 44                	push   $0x44
80106c36:	e9 19 f7 ff ff       	jmp    80106354 <alltraps>

80106c3b <vector69>:
80106c3b:	6a 00                	push   $0x0
80106c3d:	6a 45                	push   $0x45
80106c3f:	e9 10 f7 ff ff       	jmp    80106354 <alltraps>

80106c44 <vector70>:
80106c44:	6a 00                	push   $0x0
80106c46:	6a 46                	push   $0x46
80106c48:	e9 07 f7 ff ff       	jmp    80106354 <alltraps>

80106c4d <vector71>:
80106c4d:	6a 00                	push   $0x0
80106c4f:	6a 47                	push   $0x47
80106c51:	e9 fe f6 ff ff       	jmp    80106354 <alltraps>

80106c56 <vector72>:
80106c56:	6a 00                	push   $0x0
80106c58:	6a 48                	push   $0x48
80106c5a:	e9 f5 f6 ff ff       	jmp    80106354 <alltraps>

80106c5f <vector73>:
80106c5f:	6a 00                	push   $0x0
80106c61:	6a 49                	push   $0x49
80106c63:	e9 ec f6 ff ff       	jmp    80106354 <alltraps>

80106c68 <vector74>:
80106c68:	6a 00                	push   $0x0
80106c6a:	6a 4a                	push   $0x4a
80106c6c:	e9 e3 f6 ff ff       	jmp    80106354 <alltraps>

80106c71 <vector75>:
80106c71:	6a 00                	push   $0x0
80106c73:	6a 4b                	push   $0x4b
80106c75:	e9 da f6 ff ff       	jmp    80106354 <alltraps>

80106c7a <vector76>:
80106c7a:	6a 00                	push   $0x0
80106c7c:	6a 4c                	push   $0x4c
80106c7e:	e9 d1 f6 ff ff       	jmp    80106354 <alltraps>

80106c83 <vector77>:
80106c83:	6a 00                	push   $0x0
80106c85:	6a 4d                	push   $0x4d
80106c87:	e9 c8 f6 ff ff       	jmp    80106354 <alltraps>

80106c8c <vector78>:
80106c8c:	6a 00                	push   $0x0
80106c8e:	6a 4e                	push   $0x4e
80106c90:	e9 bf f6 ff ff       	jmp    80106354 <alltraps>

80106c95 <vector79>:
80106c95:	6a 00                	push   $0x0
80106c97:	6a 4f                	push   $0x4f
80106c99:	e9 b6 f6 ff ff       	jmp    80106354 <alltraps>

80106c9e <vector80>:
80106c9e:	6a 00                	push   $0x0
80106ca0:	6a 50                	push   $0x50
80106ca2:	e9 ad f6 ff ff       	jmp    80106354 <alltraps>

80106ca7 <vector81>:
80106ca7:	6a 00                	push   $0x0
80106ca9:	6a 51                	push   $0x51
80106cab:	e9 a4 f6 ff ff       	jmp    80106354 <alltraps>

80106cb0 <vector82>:
80106cb0:	6a 00                	push   $0x0
80106cb2:	6a 52                	push   $0x52
80106cb4:	e9 9b f6 ff ff       	jmp    80106354 <alltraps>

80106cb9 <vector83>:
80106cb9:	6a 00                	push   $0x0
80106cbb:	6a 53                	push   $0x53
80106cbd:	e9 92 f6 ff ff       	jmp    80106354 <alltraps>

80106cc2 <vector84>:
80106cc2:	6a 00                	push   $0x0
80106cc4:	6a 54                	push   $0x54
80106cc6:	e9 89 f6 ff ff       	jmp    80106354 <alltraps>

80106ccb <vector85>:
80106ccb:	6a 00                	push   $0x0
80106ccd:	6a 55                	push   $0x55
80106ccf:	e9 80 f6 ff ff       	jmp    80106354 <alltraps>

80106cd4 <vector86>:
80106cd4:	6a 00                	push   $0x0
80106cd6:	6a 56                	push   $0x56
80106cd8:	e9 77 f6 ff ff       	jmp    80106354 <alltraps>

80106cdd <vector87>:
80106cdd:	6a 00                	push   $0x0
80106cdf:	6a 57                	push   $0x57
80106ce1:	e9 6e f6 ff ff       	jmp    80106354 <alltraps>

80106ce6 <vector88>:
80106ce6:	6a 00                	push   $0x0
80106ce8:	6a 58                	push   $0x58
80106cea:	e9 65 f6 ff ff       	jmp    80106354 <alltraps>

80106cef <vector89>:
80106cef:	6a 00                	push   $0x0
80106cf1:	6a 59                	push   $0x59
80106cf3:	e9 5c f6 ff ff       	jmp    80106354 <alltraps>

80106cf8 <vector90>:
80106cf8:	6a 00                	push   $0x0
80106cfa:	6a 5a                	push   $0x5a
80106cfc:	e9 53 f6 ff ff       	jmp    80106354 <alltraps>

80106d01 <vector91>:
80106d01:	6a 00                	push   $0x0
80106d03:	6a 5b                	push   $0x5b
80106d05:	e9 4a f6 ff ff       	jmp    80106354 <alltraps>

80106d0a <vector92>:
80106d0a:	6a 00                	push   $0x0
80106d0c:	6a 5c                	push   $0x5c
80106d0e:	e9 41 f6 ff ff       	jmp    80106354 <alltraps>

80106d13 <vector93>:
80106d13:	6a 00                	push   $0x0
80106d15:	6a 5d                	push   $0x5d
80106d17:	e9 38 f6 ff ff       	jmp    80106354 <alltraps>

80106d1c <vector94>:
80106d1c:	6a 00                	push   $0x0
80106d1e:	6a 5e                	push   $0x5e
80106d20:	e9 2f f6 ff ff       	jmp    80106354 <alltraps>

80106d25 <vector95>:
80106d25:	6a 00                	push   $0x0
80106d27:	6a 5f                	push   $0x5f
80106d29:	e9 26 f6 ff ff       	jmp    80106354 <alltraps>

80106d2e <vector96>:
80106d2e:	6a 00                	push   $0x0
80106d30:	6a 60                	push   $0x60
80106d32:	e9 1d f6 ff ff       	jmp    80106354 <alltraps>

80106d37 <vector97>:
80106d37:	6a 00                	push   $0x0
80106d39:	6a 61                	push   $0x61
80106d3b:	e9 14 f6 ff ff       	jmp    80106354 <alltraps>

80106d40 <vector98>:
80106d40:	6a 00                	push   $0x0
80106d42:	6a 62                	push   $0x62
80106d44:	e9 0b f6 ff ff       	jmp    80106354 <alltraps>

80106d49 <vector99>:
80106d49:	6a 00                	push   $0x0
80106d4b:	6a 63                	push   $0x63
80106d4d:	e9 02 f6 ff ff       	jmp    80106354 <alltraps>

80106d52 <vector100>:
80106d52:	6a 00                	push   $0x0
80106d54:	6a 64                	push   $0x64
80106d56:	e9 f9 f5 ff ff       	jmp    80106354 <alltraps>

80106d5b <vector101>:
80106d5b:	6a 00                	push   $0x0
80106d5d:	6a 65                	push   $0x65
80106d5f:	e9 f0 f5 ff ff       	jmp    80106354 <alltraps>

80106d64 <vector102>:
80106d64:	6a 00                	push   $0x0
80106d66:	6a 66                	push   $0x66
80106d68:	e9 e7 f5 ff ff       	jmp    80106354 <alltraps>

80106d6d <vector103>:
80106d6d:	6a 00                	push   $0x0
80106d6f:	6a 67                	push   $0x67
80106d71:	e9 de f5 ff ff       	jmp    80106354 <alltraps>

80106d76 <vector104>:
80106d76:	6a 00                	push   $0x0
80106d78:	6a 68                	push   $0x68
80106d7a:	e9 d5 f5 ff ff       	jmp    80106354 <alltraps>

80106d7f <vector105>:
80106d7f:	6a 00                	push   $0x0
80106d81:	6a 69                	push   $0x69
80106d83:	e9 cc f5 ff ff       	jmp    80106354 <alltraps>

80106d88 <vector106>:
80106d88:	6a 00                	push   $0x0
80106d8a:	6a 6a                	push   $0x6a
80106d8c:	e9 c3 f5 ff ff       	jmp    80106354 <alltraps>

80106d91 <vector107>:
80106d91:	6a 00                	push   $0x0
80106d93:	6a 6b                	push   $0x6b
80106d95:	e9 ba f5 ff ff       	jmp    80106354 <alltraps>

80106d9a <vector108>:
80106d9a:	6a 00                	push   $0x0
80106d9c:	6a 6c                	push   $0x6c
80106d9e:	e9 b1 f5 ff ff       	jmp    80106354 <alltraps>

80106da3 <vector109>:
80106da3:	6a 00                	push   $0x0
80106da5:	6a 6d                	push   $0x6d
80106da7:	e9 a8 f5 ff ff       	jmp    80106354 <alltraps>

80106dac <vector110>:
80106dac:	6a 00                	push   $0x0
80106dae:	6a 6e                	push   $0x6e
80106db0:	e9 9f f5 ff ff       	jmp    80106354 <alltraps>

80106db5 <vector111>:
80106db5:	6a 00                	push   $0x0
80106db7:	6a 6f                	push   $0x6f
80106db9:	e9 96 f5 ff ff       	jmp    80106354 <alltraps>

80106dbe <vector112>:
80106dbe:	6a 00                	push   $0x0
80106dc0:	6a 70                	push   $0x70
80106dc2:	e9 8d f5 ff ff       	jmp    80106354 <alltraps>

80106dc7 <vector113>:
80106dc7:	6a 00                	push   $0x0
80106dc9:	6a 71                	push   $0x71
80106dcb:	e9 84 f5 ff ff       	jmp    80106354 <alltraps>

80106dd0 <vector114>:
80106dd0:	6a 00                	push   $0x0
80106dd2:	6a 72                	push   $0x72
80106dd4:	e9 7b f5 ff ff       	jmp    80106354 <alltraps>

80106dd9 <vector115>:
80106dd9:	6a 00                	push   $0x0
80106ddb:	6a 73                	push   $0x73
80106ddd:	e9 72 f5 ff ff       	jmp    80106354 <alltraps>

80106de2 <vector116>:
80106de2:	6a 00                	push   $0x0
80106de4:	6a 74                	push   $0x74
80106de6:	e9 69 f5 ff ff       	jmp    80106354 <alltraps>

80106deb <vector117>:
80106deb:	6a 00                	push   $0x0
80106ded:	6a 75                	push   $0x75
80106def:	e9 60 f5 ff ff       	jmp    80106354 <alltraps>

80106df4 <vector118>:
80106df4:	6a 00                	push   $0x0
80106df6:	6a 76                	push   $0x76
80106df8:	e9 57 f5 ff ff       	jmp    80106354 <alltraps>

80106dfd <vector119>:
80106dfd:	6a 00                	push   $0x0
80106dff:	6a 77                	push   $0x77
80106e01:	e9 4e f5 ff ff       	jmp    80106354 <alltraps>

80106e06 <vector120>:
80106e06:	6a 00                	push   $0x0
80106e08:	6a 78                	push   $0x78
80106e0a:	e9 45 f5 ff ff       	jmp    80106354 <alltraps>

80106e0f <vector121>:
80106e0f:	6a 00                	push   $0x0
80106e11:	6a 79                	push   $0x79
80106e13:	e9 3c f5 ff ff       	jmp    80106354 <alltraps>

80106e18 <vector122>:
80106e18:	6a 00                	push   $0x0
80106e1a:	6a 7a                	push   $0x7a
80106e1c:	e9 33 f5 ff ff       	jmp    80106354 <alltraps>

80106e21 <vector123>:
80106e21:	6a 00                	push   $0x0
80106e23:	6a 7b                	push   $0x7b
80106e25:	e9 2a f5 ff ff       	jmp    80106354 <alltraps>

80106e2a <vector124>:
80106e2a:	6a 00                	push   $0x0
80106e2c:	6a 7c                	push   $0x7c
80106e2e:	e9 21 f5 ff ff       	jmp    80106354 <alltraps>

80106e33 <vector125>:
80106e33:	6a 00                	push   $0x0
80106e35:	6a 7d                	push   $0x7d
80106e37:	e9 18 f5 ff ff       	jmp    80106354 <alltraps>

80106e3c <vector126>:
80106e3c:	6a 00                	push   $0x0
80106e3e:	6a 7e                	push   $0x7e
80106e40:	e9 0f f5 ff ff       	jmp    80106354 <alltraps>

80106e45 <vector127>:
80106e45:	6a 00                	push   $0x0
80106e47:	6a 7f                	push   $0x7f
80106e49:	e9 06 f5 ff ff       	jmp    80106354 <alltraps>

80106e4e <vector128>:
80106e4e:	6a 00                	push   $0x0
80106e50:	68 80 00 00 00       	push   $0x80
80106e55:	e9 fa f4 ff ff       	jmp    80106354 <alltraps>

80106e5a <vector129>:
80106e5a:	6a 00                	push   $0x0
80106e5c:	68 81 00 00 00       	push   $0x81
80106e61:	e9 ee f4 ff ff       	jmp    80106354 <alltraps>

80106e66 <vector130>:
80106e66:	6a 00                	push   $0x0
80106e68:	68 82 00 00 00       	push   $0x82
80106e6d:	e9 e2 f4 ff ff       	jmp    80106354 <alltraps>

80106e72 <vector131>:
80106e72:	6a 00                	push   $0x0
80106e74:	68 83 00 00 00       	push   $0x83
80106e79:	e9 d6 f4 ff ff       	jmp    80106354 <alltraps>

80106e7e <vector132>:
80106e7e:	6a 00                	push   $0x0
80106e80:	68 84 00 00 00       	push   $0x84
80106e85:	e9 ca f4 ff ff       	jmp    80106354 <alltraps>

80106e8a <vector133>:
80106e8a:	6a 00                	push   $0x0
80106e8c:	68 85 00 00 00       	push   $0x85
80106e91:	e9 be f4 ff ff       	jmp    80106354 <alltraps>

80106e96 <vector134>:
80106e96:	6a 00                	push   $0x0
80106e98:	68 86 00 00 00       	push   $0x86
80106e9d:	e9 b2 f4 ff ff       	jmp    80106354 <alltraps>

80106ea2 <vector135>:
80106ea2:	6a 00                	push   $0x0
80106ea4:	68 87 00 00 00       	push   $0x87
80106ea9:	e9 a6 f4 ff ff       	jmp    80106354 <alltraps>

80106eae <vector136>:
80106eae:	6a 00                	push   $0x0
80106eb0:	68 88 00 00 00       	push   $0x88
80106eb5:	e9 9a f4 ff ff       	jmp    80106354 <alltraps>

80106eba <vector137>:
80106eba:	6a 00                	push   $0x0
80106ebc:	68 89 00 00 00       	push   $0x89
80106ec1:	e9 8e f4 ff ff       	jmp    80106354 <alltraps>

80106ec6 <vector138>:
80106ec6:	6a 00                	push   $0x0
80106ec8:	68 8a 00 00 00       	push   $0x8a
80106ecd:	e9 82 f4 ff ff       	jmp    80106354 <alltraps>

80106ed2 <vector139>:
80106ed2:	6a 00                	push   $0x0
80106ed4:	68 8b 00 00 00       	push   $0x8b
80106ed9:	e9 76 f4 ff ff       	jmp    80106354 <alltraps>

80106ede <vector140>:
80106ede:	6a 00                	push   $0x0
80106ee0:	68 8c 00 00 00       	push   $0x8c
80106ee5:	e9 6a f4 ff ff       	jmp    80106354 <alltraps>

80106eea <vector141>:
80106eea:	6a 00                	push   $0x0
80106eec:	68 8d 00 00 00       	push   $0x8d
80106ef1:	e9 5e f4 ff ff       	jmp    80106354 <alltraps>

80106ef6 <vector142>:
80106ef6:	6a 00                	push   $0x0
80106ef8:	68 8e 00 00 00       	push   $0x8e
80106efd:	e9 52 f4 ff ff       	jmp    80106354 <alltraps>

80106f02 <vector143>:
80106f02:	6a 00                	push   $0x0
80106f04:	68 8f 00 00 00       	push   $0x8f
80106f09:	e9 46 f4 ff ff       	jmp    80106354 <alltraps>

80106f0e <vector144>:
80106f0e:	6a 00                	push   $0x0
80106f10:	68 90 00 00 00       	push   $0x90
80106f15:	e9 3a f4 ff ff       	jmp    80106354 <alltraps>

80106f1a <vector145>:
80106f1a:	6a 00                	push   $0x0
80106f1c:	68 91 00 00 00       	push   $0x91
80106f21:	e9 2e f4 ff ff       	jmp    80106354 <alltraps>

80106f26 <vector146>:
80106f26:	6a 00                	push   $0x0
80106f28:	68 92 00 00 00       	push   $0x92
80106f2d:	e9 22 f4 ff ff       	jmp    80106354 <alltraps>

80106f32 <vector147>:
80106f32:	6a 00                	push   $0x0
80106f34:	68 93 00 00 00       	push   $0x93
80106f39:	e9 16 f4 ff ff       	jmp    80106354 <alltraps>

80106f3e <vector148>:
80106f3e:	6a 00                	push   $0x0
80106f40:	68 94 00 00 00       	push   $0x94
80106f45:	e9 0a f4 ff ff       	jmp    80106354 <alltraps>

80106f4a <vector149>:
80106f4a:	6a 00                	push   $0x0
80106f4c:	68 95 00 00 00       	push   $0x95
80106f51:	e9 fe f3 ff ff       	jmp    80106354 <alltraps>

80106f56 <vector150>:
80106f56:	6a 00                	push   $0x0
80106f58:	68 96 00 00 00       	push   $0x96
80106f5d:	e9 f2 f3 ff ff       	jmp    80106354 <alltraps>

80106f62 <vector151>:
80106f62:	6a 00                	push   $0x0
80106f64:	68 97 00 00 00       	push   $0x97
80106f69:	e9 e6 f3 ff ff       	jmp    80106354 <alltraps>

80106f6e <vector152>:
80106f6e:	6a 00                	push   $0x0
80106f70:	68 98 00 00 00       	push   $0x98
80106f75:	e9 da f3 ff ff       	jmp    80106354 <alltraps>

80106f7a <vector153>:
80106f7a:	6a 00                	push   $0x0
80106f7c:	68 99 00 00 00       	push   $0x99
80106f81:	e9 ce f3 ff ff       	jmp    80106354 <alltraps>

80106f86 <vector154>:
80106f86:	6a 00                	push   $0x0
80106f88:	68 9a 00 00 00       	push   $0x9a
80106f8d:	e9 c2 f3 ff ff       	jmp    80106354 <alltraps>

80106f92 <vector155>:
80106f92:	6a 00                	push   $0x0
80106f94:	68 9b 00 00 00       	push   $0x9b
80106f99:	e9 b6 f3 ff ff       	jmp    80106354 <alltraps>

80106f9e <vector156>:
80106f9e:	6a 00                	push   $0x0
80106fa0:	68 9c 00 00 00       	push   $0x9c
80106fa5:	e9 aa f3 ff ff       	jmp    80106354 <alltraps>

80106faa <vector157>:
80106faa:	6a 00                	push   $0x0
80106fac:	68 9d 00 00 00       	push   $0x9d
80106fb1:	e9 9e f3 ff ff       	jmp    80106354 <alltraps>

80106fb6 <vector158>:
80106fb6:	6a 00                	push   $0x0
80106fb8:	68 9e 00 00 00       	push   $0x9e
80106fbd:	e9 92 f3 ff ff       	jmp    80106354 <alltraps>

80106fc2 <vector159>:
80106fc2:	6a 00                	push   $0x0
80106fc4:	68 9f 00 00 00       	push   $0x9f
80106fc9:	e9 86 f3 ff ff       	jmp    80106354 <alltraps>

80106fce <vector160>:
80106fce:	6a 00                	push   $0x0
80106fd0:	68 a0 00 00 00       	push   $0xa0
80106fd5:	e9 7a f3 ff ff       	jmp    80106354 <alltraps>

80106fda <vector161>:
80106fda:	6a 00                	push   $0x0
80106fdc:	68 a1 00 00 00       	push   $0xa1
80106fe1:	e9 6e f3 ff ff       	jmp    80106354 <alltraps>

80106fe6 <vector162>:
80106fe6:	6a 00                	push   $0x0
80106fe8:	68 a2 00 00 00       	push   $0xa2
80106fed:	e9 62 f3 ff ff       	jmp    80106354 <alltraps>

80106ff2 <vector163>:
80106ff2:	6a 00                	push   $0x0
80106ff4:	68 a3 00 00 00       	push   $0xa3
80106ff9:	e9 56 f3 ff ff       	jmp    80106354 <alltraps>

80106ffe <vector164>:
80106ffe:	6a 00                	push   $0x0
80107000:	68 a4 00 00 00       	push   $0xa4
80107005:	e9 4a f3 ff ff       	jmp    80106354 <alltraps>

8010700a <vector165>:
8010700a:	6a 00                	push   $0x0
8010700c:	68 a5 00 00 00       	push   $0xa5
80107011:	e9 3e f3 ff ff       	jmp    80106354 <alltraps>

80107016 <vector166>:
80107016:	6a 00                	push   $0x0
80107018:	68 a6 00 00 00       	push   $0xa6
8010701d:	e9 32 f3 ff ff       	jmp    80106354 <alltraps>

80107022 <vector167>:
80107022:	6a 00                	push   $0x0
80107024:	68 a7 00 00 00       	push   $0xa7
80107029:	e9 26 f3 ff ff       	jmp    80106354 <alltraps>

8010702e <vector168>:
8010702e:	6a 00                	push   $0x0
80107030:	68 a8 00 00 00       	push   $0xa8
80107035:	e9 1a f3 ff ff       	jmp    80106354 <alltraps>

8010703a <vector169>:
8010703a:	6a 00                	push   $0x0
8010703c:	68 a9 00 00 00       	push   $0xa9
80107041:	e9 0e f3 ff ff       	jmp    80106354 <alltraps>

80107046 <vector170>:
80107046:	6a 00                	push   $0x0
80107048:	68 aa 00 00 00       	push   $0xaa
8010704d:	e9 02 f3 ff ff       	jmp    80106354 <alltraps>

80107052 <vector171>:
80107052:	6a 00                	push   $0x0
80107054:	68 ab 00 00 00       	push   $0xab
80107059:	e9 f6 f2 ff ff       	jmp    80106354 <alltraps>

8010705e <vector172>:
8010705e:	6a 00                	push   $0x0
80107060:	68 ac 00 00 00       	push   $0xac
80107065:	e9 ea f2 ff ff       	jmp    80106354 <alltraps>

8010706a <vector173>:
8010706a:	6a 00                	push   $0x0
8010706c:	68 ad 00 00 00       	push   $0xad
80107071:	e9 de f2 ff ff       	jmp    80106354 <alltraps>

80107076 <vector174>:
80107076:	6a 00                	push   $0x0
80107078:	68 ae 00 00 00       	push   $0xae
8010707d:	e9 d2 f2 ff ff       	jmp    80106354 <alltraps>

80107082 <vector175>:
80107082:	6a 00                	push   $0x0
80107084:	68 af 00 00 00       	push   $0xaf
80107089:	e9 c6 f2 ff ff       	jmp    80106354 <alltraps>

8010708e <vector176>:
8010708e:	6a 00                	push   $0x0
80107090:	68 b0 00 00 00       	push   $0xb0
80107095:	e9 ba f2 ff ff       	jmp    80106354 <alltraps>

8010709a <vector177>:
8010709a:	6a 00                	push   $0x0
8010709c:	68 b1 00 00 00       	push   $0xb1
801070a1:	e9 ae f2 ff ff       	jmp    80106354 <alltraps>

801070a6 <vector178>:
801070a6:	6a 00                	push   $0x0
801070a8:	68 b2 00 00 00       	push   $0xb2
801070ad:	e9 a2 f2 ff ff       	jmp    80106354 <alltraps>

801070b2 <vector179>:
801070b2:	6a 00                	push   $0x0
801070b4:	68 b3 00 00 00       	push   $0xb3
801070b9:	e9 96 f2 ff ff       	jmp    80106354 <alltraps>

801070be <vector180>:
801070be:	6a 00                	push   $0x0
801070c0:	68 b4 00 00 00       	push   $0xb4
801070c5:	e9 8a f2 ff ff       	jmp    80106354 <alltraps>

801070ca <vector181>:
801070ca:	6a 00                	push   $0x0
801070cc:	68 b5 00 00 00       	push   $0xb5
801070d1:	e9 7e f2 ff ff       	jmp    80106354 <alltraps>

801070d6 <vector182>:
801070d6:	6a 00                	push   $0x0
801070d8:	68 b6 00 00 00       	push   $0xb6
801070dd:	e9 72 f2 ff ff       	jmp    80106354 <alltraps>

801070e2 <vector183>:
801070e2:	6a 00                	push   $0x0
801070e4:	68 b7 00 00 00       	push   $0xb7
801070e9:	e9 66 f2 ff ff       	jmp    80106354 <alltraps>

801070ee <vector184>:
801070ee:	6a 00                	push   $0x0
801070f0:	68 b8 00 00 00       	push   $0xb8
801070f5:	e9 5a f2 ff ff       	jmp    80106354 <alltraps>

801070fa <vector185>:
801070fa:	6a 00                	push   $0x0
801070fc:	68 b9 00 00 00       	push   $0xb9
80107101:	e9 4e f2 ff ff       	jmp    80106354 <alltraps>

80107106 <vector186>:
80107106:	6a 00                	push   $0x0
80107108:	68 ba 00 00 00       	push   $0xba
8010710d:	e9 42 f2 ff ff       	jmp    80106354 <alltraps>

80107112 <vector187>:
80107112:	6a 00                	push   $0x0
80107114:	68 bb 00 00 00       	push   $0xbb
80107119:	e9 36 f2 ff ff       	jmp    80106354 <alltraps>

8010711e <vector188>:
8010711e:	6a 00                	push   $0x0
80107120:	68 bc 00 00 00       	push   $0xbc
80107125:	e9 2a f2 ff ff       	jmp    80106354 <alltraps>

8010712a <vector189>:
8010712a:	6a 00                	push   $0x0
8010712c:	68 bd 00 00 00       	push   $0xbd
80107131:	e9 1e f2 ff ff       	jmp    80106354 <alltraps>

80107136 <vector190>:
80107136:	6a 00                	push   $0x0
80107138:	68 be 00 00 00       	push   $0xbe
8010713d:	e9 12 f2 ff ff       	jmp    80106354 <alltraps>

80107142 <vector191>:
80107142:	6a 00                	push   $0x0
80107144:	68 bf 00 00 00       	push   $0xbf
80107149:	e9 06 f2 ff ff       	jmp    80106354 <alltraps>

8010714e <vector192>:
8010714e:	6a 00                	push   $0x0
80107150:	68 c0 00 00 00       	push   $0xc0
80107155:	e9 fa f1 ff ff       	jmp    80106354 <alltraps>

8010715a <vector193>:
8010715a:	6a 00                	push   $0x0
8010715c:	68 c1 00 00 00       	push   $0xc1
80107161:	e9 ee f1 ff ff       	jmp    80106354 <alltraps>

80107166 <vector194>:
80107166:	6a 00                	push   $0x0
80107168:	68 c2 00 00 00       	push   $0xc2
8010716d:	e9 e2 f1 ff ff       	jmp    80106354 <alltraps>

80107172 <vector195>:
80107172:	6a 00                	push   $0x0
80107174:	68 c3 00 00 00       	push   $0xc3
80107179:	e9 d6 f1 ff ff       	jmp    80106354 <alltraps>

8010717e <vector196>:
8010717e:	6a 00                	push   $0x0
80107180:	68 c4 00 00 00       	push   $0xc4
80107185:	e9 ca f1 ff ff       	jmp    80106354 <alltraps>

8010718a <vector197>:
8010718a:	6a 00                	push   $0x0
8010718c:	68 c5 00 00 00       	push   $0xc5
80107191:	e9 be f1 ff ff       	jmp    80106354 <alltraps>

80107196 <vector198>:
80107196:	6a 00                	push   $0x0
80107198:	68 c6 00 00 00       	push   $0xc6
8010719d:	e9 b2 f1 ff ff       	jmp    80106354 <alltraps>

801071a2 <vector199>:
801071a2:	6a 00                	push   $0x0
801071a4:	68 c7 00 00 00       	push   $0xc7
801071a9:	e9 a6 f1 ff ff       	jmp    80106354 <alltraps>

801071ae <vector200>:
801071ae:	6a 00                	push   $0x0
801071b0:	68 c8 00 00 00       	push   $0xc8
801071b5:	e9 9a f1 ff ff       	jmp    80106354 <alltraps>

801071ba <vector201>:
801071ba:	6a 00                	push   $0x0
801071bc:	68 c9 00 00 00       	push   $0xc9
801071c1:	e9 8e f1 ff ff       	jmp    80106354 <alltraps>

801071c6 <vector202>:
801071c6:	6a 00                	push   $0x0
801071c8:	68 ca 00 00 00       	push   $0xca
801071cd:	e9 82 f1 ff ff       	jmp    80106354 <alltraps>

801071d2 <vector203>:
801071d2:	6a 00                	push   $0x0
801071d4:	68 cb 00 00 00       	push   $0xcb
801071d9:	e9 76 f1 ff ff       	jmp    80106354 <alltraps>

801071de <vector204>:
801071de:	6a 00                	push   $0x0
801071e0:	68 cc 00 00 00       	push   $0xcc
801071e5:	e9 6a f1 ff ff       	jmp    80106354 <alltraps>

801071ea <vector205>:
801071ea:	6a 00                	push   $0x0
801071ec:	68 cd 00 00 00       	push   $0xcd
801071f1:	e9 5e f1 ff ff       	jmp    80106354 <alltraps>

801071f6 <vector206>:
801071f6:	6a 00                	push   $0x0
801071f8:	68 ce 00 00 00       	push   $0xce
801071fd:	e9 52 f1 ff ff       	jmp    80106354 <alltraps>

80107202 <vector207>:
80107202:	6a 00                	push   $0x0
80107204:	68 cf 00 00 00       	push   $0xcf
80107209:	e9 46 f1 ff ff       	jmp    80106354 <alltraps>

8010720e <vector208>:
8010720e:	6a 00                	push   $0x0
80107210:	68 d0 00 00 00       	push   $0xd0
80107215:	e9 3a f1 ff ff       	jmp    80106354 <alltraps>

8010721a <vector209>:
8010721a:	6a 00                	push   $0x0
8010721c:	68 d1 00 00 00       	push   $0xd1
80107221:	e9 2e f1 ff ff       	jmp    80106354 <alltraps>

80107226 <vector210>:
80107226:	6a 00                	push   $0x0
80107228:	68 d2 00 00 00       	push   $0xd2
8010722d:	e9 22 f1 ff ff       	jmp    80106354 <alltraps>

80107232 <vector211>:
80107232:	6a 00                	push   $0x0
80107234:	68 d3 00 00 00       	push   $0xd3
80107239:	e9 16 f1 ff ff       	jmp    80106354 <alltraps>

8010723e <vector212>:
8010723e:	6a 00                	push   $0x0
80107240:	68 d4 00 00 00       	push   $0xd4
80107245:	e9 0a f1 ff ff       	jmp    80106354 <alltraps>

8010724a <vector213>:
8010724a:	6a 00                	push   $0x0
8010724c:	68 d5 00 00 00       	push   $0xd5
80107251:	e9 fe f0 ff ff       	jmp    80106354 <alltraps>

80107256 <vector214>:
80107256:	6a 00                	push   $0x0
80107258:	68 d6 00 00 00       	push   $0xd6
8010725d:	e9 f2 f0 ff ff       	jmp    80106354 <alltraps>

80107262 <vector215>:
80107262:	6a 00                	push   $0x0
80107264:	68 d7 00 00 00       	push   $0xd7
80107269:	e9 e6 f0 ff ff       	jmp    80106354 <alltraps>

8010726e <vector216>:
8010726e:	6a 00                	push   $0x0
80107270:	68 d8 00 00 00       	push   $0xd8
80107275:	e9 da f0 ff ff       	jmp    80106354 <alltraps>

8010727a <vector217>:
8010727a:	6a 00                	push   $0x0
8010727c:	68 d9 00 00 00       	push   $0xd9
80107281:	e9 ce f0 ff ff       	jmp    80106354 <alltraps>

80107286 <vector218>:
80107286:	6a 00                	push   $0x0
80107288:	68 da 00 00 00       	push   $0xda
8010728d:	e9 c2 f0 ff ff       	jmp    80106354 <alltraps>

80107292 <vector219>:
80107292:	6a 00                	push   $0x0
80107294:	68 db 00 00 00       	push   $0xdb
80107299:	e9 b6 f0 ff ff       	jmp    80106354 <alltraps>

8010729e <vector220>:
8010729e:	6a 00                	push   $0x0
801072a0:	68 dc 00 00 00       	push   $0xdc
801072a5:	e9 aa f0 ff ff       	jmp    80106354 <alltraps>

801072aa <vector221>:
801072aa:	6a 00                	push   $0x0
801072ac:	68 dd 00 00 00       	push   $0xdd
801072b1:	e9 9e f0 ff ff       	jmp    80106354 <alltraps>

801072b6 <vector222>:
801072b6:	6a 00                	push   $0x0
801072b8:	68 de 00 00 00       	push   $0xde
801072bd:	e9 92 f0 ff ff       	jmp    80106354 <alltraps>

801072c2 <vector223>:
801072c2:	6a 00                	push   $0x0
801072c4:	68 df 00 00 00       	push   $0xdf
801072c9:	e9 86 f0 ff ff       	jmp    80106354 <alltraps>

801072ce <vector224>:
801072ce:	6a 00                	push   $0x0
801072d0:	68 e0 00 00 00       	push   $0xe0
801072d5:	e9 7a f0 ff ff       	jmp    80106354 <alltraps>

801072da <vector225>:
801072da:	6a 00                	push   $0x0
801072dc:	68 e1 00 00 00       	push   $0xe1
801072e1:	e9 6e f0 ff ff       	jmp    80106354 <alltraps>

801072e6 <vector226>:
801072e6:	6a 00                	push   $0x0
801072e8:	68 e2 00 00 00       	push   $0xe2
801072ed:	e9 62 f0 ff ff       	jmp    80106354 <alltraps>

801072f2 <vector227>:
801072f2:	6a 00                	push   $0x0
801072f4:	68 e3 00 00 00       	push   $0xe3
801072f9:	e9 56 f0 ff ff       	jmp    80106354 <alltraps>

801072fe <vector228>:
801072fe:	6a 00                	push   $0x0
80107300:	68 e4 00 00 00       	push   $0xe4
80107305:	e9 4a f0 ff ff       	jmp    80106354 <alltraps>

8010730a <vector229>:
8010730a:	6a 00                	push   $0x0
8010730c:	68 e5 00 00 00       	push   $0xe5
80107311:	e9 3e f0 ff ff       	jmp    80106354 <alltraps>

80107316 <vector230>:
80107316:	6a 00                	push   $0x0
80107318:	68 e6 00 00 00       	push   $0xe6
8010731d:	e9 32 f0 ff ff       	jmp    80106354 <alltraps>

80107322 <vector231>:
80107322:	6a 00                	push   $0x0
80107324:	68 e7 00 00 00       	push   $0xe7
80107329:	e9 26 f0 ff ff       	jmp    80106354 <alltraps>

8010732e <vector232>:
8010732e:	6a 00                	push   $0x0
80107330:	68 e8 00 00 00       	push   $0xe8
80107335:	e9 1a f0 ff ff       	jmp    80106354 <alltraps>

8010733a <vector233>:
8010733a:	6a 00                	push   $0x0
8010733c:	68 e9 00 00 00       	push   $0xe9
80107341:	e9 0e f0 ff ff       	jmp    80106354 <alltraps>

80107346 <vector234>:
80107346:	6a 00                	push   $0x0
80107348:	68 ea 00 00 00       	push   $0xea
8010734d:	e9 02 f0 ff ff       	jmp    80106354 <alltraps>

80107352 <vector235>:
80107352:	6a 00                	push   $0x0
80107354:	68 eb 00 00 00       	push   $0xeb
80107359:	e9 f6 ef ff ff       	jmp    80106354 <alltraps>

8010735e <vector236>:
8010735e:	6a 00                	push   $0x0
80107360:	68 ec 00 00 00       	push   $0xec
80107365:	e9 ea ef ff ff       	jmp    80106354 <alltraps>

8010736a <vector237>:
8010736a:	6a 00                	push   $0x0
8010736c:	68 ed 00 00 00       	push   $0xed
80107371:	e9 de ef ff ff       	jmp    80106354 <alltraps>

80107376 <vector238>:
80107376:	6a 00                	push   $0x0
80107378:	68 ee 00 00 00       	push   $0xee
8010737d:	e9 d2 ef ff ff       	jmp    80106354 <alltraps>

80107382 <vector239>:
80107382:	6a 00                	push   $0x0
80107384:	68 ef 00 00 00       	push   $0xef
80107389:	e9 c6 ef ff ff       	jmp    80106354 <alltraps>

8010738e <vector240>:
8010738e:	6a 00                	push   $0x0
80107390:	68 f0 00 00 00       	push   $0xf0
80107395:	e9 ba ef ff ff       	jmp    80106354 <alltraps>

8010739a <vector241>:
8010739a:	6a 00                	push   $0x0
8010739c:	68 f1 00 00 00       	push   $0xf1
801073a1:	e9 ae ef ff ff       	jmp    80106354 <alltraps>

801073a6 <vector242>:
801073a6:	6a 00                	push   $0x0
801073a8:	68 f2 00 00 00       	push   $0xf2
801073ad:	e9 a2 ef ff ff       	jmp    80106354 <alltraps>

801073b2 <vector243>:
801073b2:	6a 00                	push   $0x0
801073b4:	68 f3 00 00 00       	push   $0xf3
801073b9:	e9 96 ef ff ff       	jmp    80106354 <alltraps>

801073be <vector244>:
801073be:	6a 00                	push   $0x0
801073c0:	68 f4 00 00 00       	push   $0xf4
801073c5:	e9 8a ef ff ff       	jmp    80106354 <alltraps>

801073ca <vector245>:
801073ca:	6a 00                	push   $0x0
801073cc:	68 f5 00 00 00       	push   $0xf5
801073d1:	e9 7e ef ff ff       	jmp    80106354 <alltraps>

801073d6 <vector246>:
801073d6:	6a 00                	push   $0x0
801073d8:	68 f6 00 00 00       	push   $0xf6
801073dd:	e9 72 ef ff ff       	jmp    80106354 <alltraps>

801073e2 <vector247>:
801073e2:	6a 00                	push   $0x0
801073e4:	68 f7 00 00 00       	push   $0xf7
801073e9:	e9 66 ef ff ff       	jmp    80106354 <alltraps>

801073ee <vector248>:
801073ee:	6a 00                	push   $0x0
801073f0:	68 f8 00 00 00       	push   $0xf8
801073f5:	e9 5a ef ff ff       	jmp    80106354 <alltraps>

801073fa <vector249>:
801073fa:	6a 00                	push   $0x0
801073fc:	68 f9 00 00 00       	push   $0xf9
80107401:	e9 4e ef ff ff       	jmp    80106354 <alltraps>

80107406 <vector250>:
80107406:	6a 00                	push   $0x0
80107408:	68 fa 00 00 00       	push   $0xfa
8010740d:	e9 42 ef ff ff       	jmp    80106354 <alltraps>

80107412 <vector251>:
80107412:	6a 00                	push   $0x0
80107414:	68 fb 00 00 00       	push   $0xfb
80107419:	e9 36 ef ff ff       	jmp    80106354 <alltraps>

8010741e <vector252>:
8010741e:	6a 00                	push   $0x0
80107420:	68 fc 00 00 00       	push   $0xfc
80107425:	e9 2a ef ff ff       	jmp    80106354 <alltraps>

8010742a <vector253>:
8010742a:	6a 00                	push   $0x0
8010742c:	68 fd 00 00 00       	push   $0xfd
80107431:	e9 1e ef ff ff       	jmp    80106354 <alltraps>

80107436 <vector254>:
80107436:	6a 00                	push   $0x0
80107438:	68 fe 00 00 00       	push   $0xfe
8010743d:	e9 12 ef ff ff       	jmp    80106354 <alltraps>

80107442 <vector255>:
80107442:	6a 00                	push   $0x0
80107444:	68 ff 00 00 00       	push   $0xff
80107449:	e9 06 ef ff ff       	jmp    80106354 <alltraps>
8010744e:	66 90                	xchg   %ax,%ax

80107450 <lgdt>:
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	83 ec 10             	sub    $0x10,%esp
80107456:	8b 45 0c             	mov    0xc(%ebp),%eax
80107459:	83 e8 01             	sub    $0x1,%eax
8010745c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
80107460:	8b 45 08             	mov    0x8(%ebp),%eax
80107463:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107467:	8b 45 08             	mov    0x8(%ebp),%eax
8010746a:	c1 e8 10             	shr    $0x10,%eax
8010746d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
80107471:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107474:	0f 01 10             	lgdtl  (%eax)
80107477:	c9                   	leave  
80107478:	c3                   	ret    

80107479 <ltr>:
80107479:	55                   	push   %ebp
8010747a:	89 e5                	mov    %esp,%ebp
8010747c:	83 ec 04             	sub    $0x4,%esp
8010747f:	8b 45 08             	mov    0x8(%ebp),%eax
80107482:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107486:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010748a:	0f 00 d8             	ltr    %ax
8010748d:	c9                   	leave  
8010748e:	c3                   	ret    

8010748f <loadgs>:
8010748f:	55                   	push   %ebp
80107490:	89 e5                	mov    %esp,%ebp
80107492:	83 ec 04             	sub    $0x4,%esp
80107495:	8b 45 08             	mov    0x8(%ebp),%eax
80107498:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010749c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801074a0:	8e e8                	mov    %eax,%gs
801074a2:	c9                   	leave  
801074a3:	c3                   	ret    

801074a4 <lcr3>:
801074a4:	55                   	push   %ebp
801074a5:	89 e5                	mov    %esp,%ebp
801074a7:	8b 45 08             	mov    0x8(%ebp),%eax
801074aa:	0f 22 d8             	mov    %eax,%cr3
801074ad:	5d                   	pop    %ebp
801074ae:	c3                   	ret    

801074af <v2p>:
801074af:	55                   	push   %ebp
801074b0:	89 e5                	mov    %esp,%ebp
801074b2:	8b 45 08             	mov    0x8(%ebp),%eax
801074b5:	2d 00 00 00 80       	sub    $0x80000000,%eax
801074ba:	5d                   	pop    %ebp
801074bb:	c3                   	ret    

801074bc <p2v>:
801074bc:	55                   	push   %ebp
801074bd:	89 e5                	mov    %esp,%ebp
801074bf:	8b 45 08             	mov    0x8(%ebp),%eax
801074c2:	2d 00 00 00 80       	sub    $0x80000000,%eax
801074c7:	5d                   	pop    %ebp
801074c8:	c3                   	ret    

801074c9 <seginit>:
801074c9:	55                   	push   %ebp
801074ca:	89 e5                	mov    %esp,%ebp
801074cc:	53                   	push   %ebx
801074cd:	83 ec 24             	sub    $0x24,%esp
801074d0:	e8 1f ba ff ff       	call   80102ef4 <cpunum>
801074d5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801074db:	05 20 f9 10 80       	add    $0x8010f920,%eax
801074e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e6:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801074ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ef:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801074f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f8:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801074fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ff:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107503:	83 e2 f0             	and    $0xfffffff0,%edx
80107506:	83 ca 0a             	or     $0xa,%edx
80107509:	88 50 7d             	mov    %dl,0x7d(%eax)
8010750c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107513:	83 ca 10             	or     $0x10,%edx
80107516:	88 50 7d             	mov    %dl,0x7d(%eax)
80107519:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010751c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107520:	83 e2 9f             	and    $0xffffff9f,%edx
80107523:	88 50 7d             	mov    %dl,0x7d(%eax)
80107526:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107529:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010752d:	83 ca 80             	or     $0xffffff80,%edx
80107530:	88 50 7d             	mov    %dl,0x7d(%eax)
80107533:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107536:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010753a:	83 ca 0f             	or     $0xf,%edx
8010753d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107540:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107543:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107547:	83 e2 ef             	and    $0xffffffef,%edx
8010754a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010754d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107550:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107554:	83 e2 df             	and    $0xffffffdf,%edx
80107557:	88 50 7e             	mov    %dl,0x7e(%eax)
8010755a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010755d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107561:	83 ca 40             	or     $0x40,%edx
80107564:	88 50 7e             	mov    %dl,0x7e(%eax)
80107567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010756a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010756e:	83 ca 80             	or     $0xffffff80,%edx
80107571:	88 50 7e             	mov    %dl,0x7e(%eax)
80107574:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107577:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
8010757b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010757e:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107585:	ff ff 
80107587:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010758a:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107591:	00 00 
80107593:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107596:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010759d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a0:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801075a7:	83 e2 f0             	and    $0xfffffff0,%edx
801075aa:	83 ca 02             	or     $0x2,%edx
801075ad:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801075b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801075bd:	83 ca 10             	or     $0x10,%edx
801075c0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801075c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c9:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801075d0:	83 e2 9f             	and    $0xffffff9f,%edx
801075d3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801075d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075dc:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801075e3:	83 ca 80             	or     $0xffffff80,%edx
801075e6:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801075ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ef:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801075f6:	83 ca 0f             	or     $0xf,%edx
801075f9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107602:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107609:	83 e2 ef             	and    $0xffffffef,%edx
8010760c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107612:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107615:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010761c:	83 e2 df             	and    $0xffffffdf,%edx
8010761f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107625:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107628:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010762f:	83 ca 40             	or     $0x40,%edx
80107632:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010763b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107642:	83 ca 80             	or     $0xffffff80,%edx
80107645:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010764b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010764e:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
80107655:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107658:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010765f:	ff ff 
80107661:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107664:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010766b:	00 00 
8010766d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107670:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107677:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010767a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107681:	83 e2 f0             	and    $0xfffffff0,%edx
80107684:	83 ca 0a             	or     $0xa,%edx
80107687:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010768d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107690:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107697:	83 ca 10             	or     $0x10,%edx
8010769a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801076a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801076aa:	83 ca 60             	or     $0x60,%edx
801076ad:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801076b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b6:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801076bd:	83 ca 80             	or     $0xffffff80,%edx
801076c0:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801076c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076d0:	83 ca 0f             	or     $0xf,%edx
801076d3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076dc:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076e3:	83 e2 ef             	and    $0xffffffef,%edx
801076e6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ef:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801076f6:	83 e2 df             	and    $0xffffffdf,%edx
801076f9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801076ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107702:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107709:	83 ca 40             	or     $0x40,%edx
8010770c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107712:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107715:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010771c:	83 ca 80             	or     $0xffffff80,%edx
8010771f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107728:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
8010772f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107732:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107739:	ff ff 
8010773b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010773e:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107745:	00 00 
80107747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774a:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107754:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010775b:	83 e2 f0             	and    $0xfffffff0,%edx
8010775e:	83 ca 02             	or     $0x2,%edx
80107761:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010776a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107771:	83 ca 10             	or     $0x10,%edx
80107774:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010777a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010777d:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107784:	83 ca 60             	or     $0x60,%edx
80107787:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010778d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107790:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107797:	83 ca 80             	or     $0xffffff80,%edx
8010779a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801077a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a3:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801077aa:	83 ca 0f             	or     $0xf,%edx
801077ad:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801077b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b6:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801077bd:	83 e2 ef             	and    $0xffffffef,%edx
801077c0:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801077c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c9:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801077d0:	83 e2 df             	and    $0xffffffdf,%edx
801077d3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801077d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077dc:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801077e3:	83 ca 40             	or     $0x40,%edx
801077e6:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801077ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ef:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801077f6:	83 ca 80             	or     $0xffffff80,%edx
801077f9:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801077ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107802:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
80107809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780c:	05 b4 00 00 00       	add    $0xb4,%eax
80107811:	89 c3                	mov    %eax,%ebx
80107813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107816:	05 b4 00 00 00       	add    $0xb4,%eax
8010781b:	c1 e8 10             	shr    $0x10,%eax
8010781e:	89 c1                	mov    %eax,%ecx
80107820:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107823:	05 b4 00 00 00       	add    $0xb4,%eax
80107828:	c1 e8 18             	shr    $0x18,%eax
8010782b:	89 c2                	mov    %eax,%edx
8010782d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107830:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107837:	00 00 
80107839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010783c:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107846:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
8010784c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784f:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107856:	83 e1 f0             	and    $0xfffffff0,%ecx
80107859:	83 c9 02             	or     $0x2,%ecx
8010785c:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107862:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107865:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010786c:	83 c9 10             	or     $0x10,%ecx
8010786f:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107878:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010787f:	83 e1 9f             	and    $0xffffff9f,%ecx
80107882:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107888:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788b:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107892:	83 c9 80             	or     $0xffffff80,%ecx
80107895:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010789b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010789e:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801078a5:	83 e1 f0             	and    $0xfffffff0,%ecx
801078a8:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801078ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b1:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801078b8:	83 e1 ef             	and    $0xffffffef,%ecx
801078bb:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801078c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c4:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801078cb:	83 e1 df             	and    $0xffffffdf,%ecx
801078ce:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801078d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d7:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801078de:	83 c9 40             	or     $0x40,%ecx
801078e1:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801078e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ea:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801078f1:	83 c9 80             	or     $0xffffff80,%ecx
801078f4:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801078fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078fd:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)
80107903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107906:	83 c0 70             	add    $0x70,%eax
80107909:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107910:	00 
80107911:	89 04 24             	mov    %eax,(%esp)
80107914:	e8 37 fb ff ff       	call   80107450 <lgdt>
80107919:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107920:	e8 6a fb ff ff       	call   8010748f <loadgs>
80107925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107928:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
8010792e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107935:	00 00 00 00 
80107939:	83 c4 24             	add    $0x24,%esp
8010793c:	5b                   	pop    %ebx
8010793d:	5d                   	pop    %ebp
8010793e:	c3                   	ret    

8010793f <walkpgdir>:
8010793f:	55                   	push   %ebp
80107940:	89 e5                	mov    %esp,%ebp
80107942:	83 ec 28             	sub    $0x28,%esp
80107945:	8b 45 0c             	mov    0xc(%ebp),%eax
80107948:	c1 e8 16             	shr    $0x16,%eax
8010794b:	c1 e0 02             	shl    $0x2,%eax
8010794e:	03 45 08             	add    0x8(%ebp),%eax
80107951:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107954:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107957:	8b 00                	mov    (%eax),%eax
80107959:	83 e0 01             	and    $0x1,%eax
8010795c:	84 c0                	test   %al,%al
8010795e:	74 17                	je     80107977 <walkpgdir+0x38>
80107960:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107963:	8b 00                	mov    (%eax),%eax
80107965:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010796a:	89 04 24             	mov    %eax,(%esp)
8010796d:	e8 4a fb ff ff       	call   801074bc <p2v>
80107972:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107975:	eb 4b                	jmp    801079c2 <walkpgdir+0x83>
80107977:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010797b:	74 0e                	je     8010798b <walkpgdir+0x4c>
8010797d:	e8 f9 b1 ff ff       	call   80102b7b <kalloc>
80107982:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107985:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107989:	75 07                	jne    80107992 <walkpgdir+0x53>
8010798b:	b8 00 00 00 00       	mov    $0x0,%eax
80107990:	eb 41                	jmp    801079d3 <walkpgdir+0x94>
80107992:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107999:	00 
8010799a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801079a1:	00 
801079a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a5:	89 04 24             	mov    %eax,(%esp)
801079a8:	e8 c1 d5 ff ff       	call   80104f6e <memset>
801079ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b0:	89 04 24             	mov    %eax,(%esp)
801079b3:	e8 f7 fa ff ff       	call   801074af <v2p>
801079b8:	89 c2                	mov    %eax,%edx
801079ba:	83 ca 07             	or     $0x7,%edx
801079bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079c0:	89 10                	mov    %edx,(%eax)
801079c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801079c5:	c1 e8 0c             	shr    $0xc,%eax
801079c8:	25 ff 03 00 00       	and    $0x3ff,%eax
801079cd:	c1 e0 02             	shl    $0x2,%eax
801079d0:	03 45 f4             	add    -0xc(%ebp),%eax
801079d3:	c9                   	leave  
801079d4:	c3                   	ret    

801079d5 <mappages>:
801079d5:	55                   	push   %ebp
801079d6:	89 e5                	mov    %esp,%ebp
801079d8:	83 ec 28             	sub    $0x28,%esp
801079db:	8b 45 0c             	mov    0xc(%ebp),%eax
801079de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801079e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801079e9:	03 45 10             	add    0x10(%ebp),%eax
801079ec:	83 e8 01             	sub    $0x1,%eax
801079ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801079f7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801079fe:	00 
801079ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a02:	89 44 24 04          	mov    %eax,0x4(%esp)
80107a06:	8b 45 08             	mov    0x8(%ebp),%eax
80107a09:	89 04 24             	mov    %eax,(%esp)
80107a0c:	e8 2e ff ff ff       	call   8010793f <walkpgdir>
80107a11:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a18:	75 07                	jne    80107a21 <mappages+0x4c>
80107a1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a1f:	eb 46                	jmp    80107a67 <mappages+0x92>
80107a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a24:	8b 00                	mov    (%eax),%eax
80107a26:	83 e0 01             	and    $0x1,%eax
80107a29:	84 c0                	test   %al,%al
80107a2b:	74 0c                	je     80107a39 <mappages+0x64>
80107a2d:	c7 04 24 74 88 10 80 	movl   $0x80108874,(%esp)
80107a34:	e8 0d 8b ff ff       	call   80100546 <panic>
80107a39:	8b 45 18             	mov    0x18(%ebp),%eax
80107a3c:	0b 45 14             	or     0x14(%ebp),%eax
80107a3f:	89 c2                	mov    %eax,%edx
80107a41:	83 ca 01             	or     $0x1,%edx
80107a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a47:	89 10                	mov    %edx,(%eax)
80107a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a4c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107a4f:	74 10                	je     80107a61 <mappages+0x8c>
80107a51:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
80107a58:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
80107a5f:	eb 96                	jmp    801079f7 <mappages+0x22>
80107a61:	90                   	nop
80107a62:	b8 00 00 00 00       	mov    $0x0,%eax
80107a67:	c9                   	leave  
80107a68:	c3                   	ret    

80107a69 <setupkvm>:
80107a69:	55                   	push   %ebp
80107a6a:	89 e5                	mov    %esp,%ebp
80107a6c:	53                   	push   %ebx
80107a6d:	83 ec 34             	sub    $0x34,%esp
80107a70:	e8 06 b1 ff ff       	call   80102b7b <kalloc>
80107a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a7c:	75 0a                	jne    80107a88 <setupkvm+0x1f>
80107a7e:	b8 00 00 00 00       	mov    $0x0,%eax
80107a83:	e9 99 00 00 00       	jmp    80107b21 <setupkvm+0xb8>
80107a88:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107a8f:	00 
80107a90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107a97:	00 
80107a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a9b:	89 04 24             	mov    %eax,(%esp)
80107a9e:	e8 cb d4 ff ff       	call   80104f6e <memset>
80107aa3:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107aaa:	e8 0d fa ff ff       	call   801074bc <p2v>
80107aaf:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107ab4:	76 0c                	jbe    80107ac2 <setupkvm+0x59>
80107ab6:	c7 04 24 7a 88 10 80 	movl   $0x8010887a,(%esp)
80107abd:	e8 84 8a ff ff       	call   80100546 <panic>
80107ac2:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107ac9:	eb 49                	jmp    80107b14 <setupkvm+0xab>
80107acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ace:	8b 48 0c             	mov    0xc(%eax),%ecx
80107ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad4:	8b 50 04             	mov    0x4(%eax),%edx
80107ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ada:	8b 58 08             	mov    0x8(%eax),%ebx
80107add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae0:	8b 40 04             	mov    0x4(%eax),%eax
80107ae3:	29 c3                	sub    %eax,%ebx
80107ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae8:	8b 00                	mov    (%eax),%eax
80107aea:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107aee:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107af2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107af6:	89 44 24 04          	mov    %eax,0x4(%esp)
80107afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107afd:	89 04 24             	mov    %eax,(%esp)
80107b00:	e8 d0 fe ff ff       	call   801079d5 <mappages>
80107b05:	85 c0                	test   %eax,%eax
80107b07:	79 07                	jns    80107b10 <setupkvm+0xa7>
80107b09:	b8 00 00 00 00       	mov    $0x0,%eax
80107b0e:	eb 11                	jmp    80107b21 <setupkvm+0xb8>
80107b10:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107b14:	b8 e0 b4 10 80       	mov    $0x8010b4e0,%eax
80107b19:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80107b1c:	72 ad                	jb     80107acb <setupkvm+0x62>
80107b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b21:	83 c4 34             	add    $0x34,%esp
80107b24:	5b                   	pop    %ebx
80107b25:	5d                   	pop    %ebp
80107b26:	c3                   	ret    

80107b27 <kvmalloc>:
80107b27:	55                   	push   %ebp
80107b28:	89 e5                	mov    %esp,%ebp
80107b2a:	83 ec 08             	sub    $0x8,%esp
80107b2d:	e8 37 ff ff ff       	call   80107a69 <setupkvm>
80107b32:	a3 b8 2a 11 80       	mov    %eax,0x80112ab8
80107b37:	e8 02 00 00 00       	call   80107b3e <switchkvm>
80107b3c:	c9                   	leave  
80107b3d:	c3                   	ret    

80107b3e <switchkvm>:
80107b3e:	55                   	push   %ebp
80107b3f:	89 e5                	mov    %esp,%ebp
80107b41:	83 ec 04             	sub    $0x4,%esp
80107b44:	a1 b8 2a 11 80       	mov    0x80112ab8,%eax
80107b49:	89 04 24             	mov    %eax,(%esp)
80107b4c:	e8 5e f9 ff ff       	call   801074af <v2p>
80107b51:	89 04 24             	mov    %eax,(%esp)
80107b54:	e8 4b f9 ff ff       	call   801074a4 <lcr3>
80107b59:	c9                   	leave  
80107b5a:	c3                   	ret    

80107b5b <switchuvm>:
80107b5b:	55                   	push   %ebp
80107b5c:	89 e5                	mov    %esp,%ebp
80107b5e:	53                   	push   %ebx
80107b5f:	83 ec 14             	sub    $0x14,%esp
80107b62:	e8 01 d3 ff ff       	call   80104e68 <pushcli>
80107b67:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b6d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107b74:	83 c2 08             	add    $0x8,%edx
80107b77:	89 d3                	mov    %edx,%ebx
80107b79:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107b80:	83 c2 08             	add    $0x8,%edx
80107b83:	c1 ea 10             	shr    $0x10,%edx
80107b86:	89 d1                	mov    %edx,%ecx
80107b88:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107b8f:	83 c2 08             	add    $0x8,%edx
80107b92:	c1 ea 18             	shr    $0x18,%edx
80107b95:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107b9c:	67 00 
80107b9e:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107ba5:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107bab:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107bb2:	83 e1 f0             	and    $0xfffffff0,%ecx
80107bb5:	83 c9 09             	or     $0x9,%ecx
80107bb8:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107bbe:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107bc5:	83 c9 10             	or     $0x10,%ecx
80107bc8:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107bce:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107bd5:	83 e1 9f             	and    $0xffffff9f,%ecx
80107bd8:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107bde:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107be5:	83 c9 80             	or     $0xffffff80,%ecx
80107be8:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107bee:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107bf5:	83 e1 f0             	and    $0xfffffff0,%ecx
80107bf8:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107bfe:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107c05:	83 e1 ef             	and    $0xffffffef,%ecx
80107c08:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107c0e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107c15:	83 e1 df             	and    $0xffffffdf,%ecx
80107c18:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107c1e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107c25:	83 c9 40             	or     $0x40,%ecx
80107c28:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107c2e:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107c35:	83 e1 7f             	and    $0x7f,%ecx
80107c38:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107c3e:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
80107c44:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c4a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107c51:	83 e2 ef             	and    $0xffffffef,%edx
80107c54:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107c5a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c60:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
80107c66:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c6c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107c73:	8b 52 08             	mov    0x8(%edx),%edx
80107c76:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107c7c:	89 50 0c             	mov    %edx,0xc(%eax)
80107c7f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107c86:	e8 ee f7 ff ff       	call   80107479 <ltr>
80107c8b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c8e:	8b 40 04             	mov    0x4(%eax),%eax
80107c91:	85 c0                	test   %eax,%eax
80107c93:	75 0c                	jne    80107ca1 <switchuvm+0x146>
80107c95:	c7 04 24 8b 88 10 80 	movl   $0x8010888b,(%esp)
80107c9c:	e8 a5 88 ff ff       	call   80100546 <panic>
80107ca1:	8b 45 08             	mov    0x8(%ebp),%eax
80107ca4:	8b 40 04             	mov    0x4(%eax),%eax
80107ca7:	89 04 24             	mov    %eax,(%esp)
80107caa:	e8 00 f8 ff ff       	call   801074af <v2p>
80107caf:	89 04 24             	mov    %eax,(%esp)
80107cb2:	e8 ed f7 ff ff       	call   801074a4 <lcr3>
80107cb7:	e8 f4 d1 ff ff       	call   80104eb0 <popcli>
80107cbc:	83 c4 14             	add    $0x14,%esp
80107cbf:	5b                   	pop    %ebx
80107cc0:	5d                   	pop    %ebp
80107cc1:	c3                   	ret    

80107cc2 <inituvm>:
80107cc2:	55                   	push   %ebp
80107cc3:	89 e5                	mov    %esp,%ebp
80107cc5:	83 ec 38             	sub    $0x38,%esp
80107cc8:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107ccf:	76 0c                	jbe    80107cdd <inituvm+0x1b>
80107cd1:	c7 04 24 9f 88 10 80 	movl   $0x8010889f,(%esp)
80107cd8:	e8 69 88 ff ff       	call   80100546 <panic>
80107cdd:	e8 99 ae ff ff       	call   80102b7b <kalloc>
80107ce2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ce5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107cec:	00 
80107ced:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107cf4:	00 
80107cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf8:	89 04 24             	mov    %eax,(%esp)
80107cfb:	e8 6e d2 ff ff       	call   80104f6e <memset>
80107d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d03:	89 04 24             	mov    %eax,(%esp)
80107d06:	e8 a4 f7 ff ff       	call   801074af <v2p>
80107d0b:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107d12:	00 
80107d13:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107d17:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d1e:	00 
80107d1f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107d26:	00 
80107d27:	8b 45 08             	mov    0x8(%ebp),%eax
80107d2a:	89 04 24             	mov    %eax,(%esp)
80107d2d:	e8 a3 fc ff ff       	call   801079d5 <mappages>
80107d32:	8b 45 10             	mov    0x10(%ebp),%eax
80107d35:	89 44 24 08          	mov    %eax,0x8(%esp)
80107d39:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d43:	89 04 24             	mov    %eax,(%esp)
80107d46:	e8 f6 d2 ff ff       	call   80105041 <memmove>
80107d4b:	c9                   	leave  
80107d4c:	c3                   	ret    

80107d4d <loaduvm>:
80107d4d:	55                   	push   %ebp
80107d4e:	89 e5                	mov    %esp,%ebp
80107d50:	53                   	push   %ebx
80107d51:	83 ec 24             	sub    $0x24,%esp
80107d54:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d57:	25 ff 0f 00 00       	and    $0xfff,%eax
80107d5c:	85 c0                	test   %eax,%eax
80107d5e:	74 0c                	je     80107d6c <loaduvm+0x1f>
80107d60:	c7 04 24 bc 88 10 80 	movl   $0x801088bc,(%esp)
80107d67:	e8 da 87 ff ff       	call   80100546 <panic>
80107d6c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80107d73:	e9 ae 00 00 00       	jmp    80107e26 <loaduvm+0xd9>
80107d78:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d7e:	8d 04 02             	lea    (%edx,%eax,1),%eax
80107d81:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107d88:	00 
80107d89:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80107d90:	89 04 24             	mov    %eax,(%esp)
80107d93:	e8 a7 fb ff ff       	call   8010793f <walkpgdir>
80107d98:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107d9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107d9f:	75 0c                	jne    80107dad <loaduvm+0x60>
80107da1:	c7 04 24 df 88 10 80 	movl   $0x801088df,(%esp)
80107da8:	e8 99 87 ff ff       	call   80100546 <panic>
80107dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db0:	8b 00                	mov    (%eax),%eax
80107db2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107db7:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107dba:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107dbd:	8b 55 18             	mov    0x18(%ebp),%edx
80107dc0:	89 d1                	mov    %edx,%ecx
80107dc2:	29 c1                	sub    %eax,%ecx
80107dc4:	89 c8                	mov    %ecx,%eax
80107dc6:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107dcb:	77 11                	ja     80107dde <loaduvm+0x91>
80107dcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107dd0:	8b 55 18             	mov    0x18(%ebp),%edx
80107dd3:	89 d1                	mov    %edx,%ecx
80107dd5:	29 c1                	sub    %eax,%ecx
80107dd7:	89 c8                	mov    %ecx,%eax
80107dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107ddc:	eb 07                	jmp    80107de5 <loaduvm+0x98>
80107dde:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
80107de5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107de8:	8b 55 14             	mov    0x14(%ebp),%edx
80107deb:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107dee:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107df1:	89 04 24             	mov    %eax,(%esp)
80107df4:	e8 c3 f6 ff ff       	call   801074bc <p2v>
80107df9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107dfc:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107e00:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107e04:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e08:	8b 45 10             	mov    0x10(%ebp),%eax
80107e0b:	89 04 24             	mov    %eax,(%esp)
80107e0e:	e8 be 9f ff ff       	call   80101dd1 <readi>
80107e13:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107e16:	74 07                	je     80107e1f <loaduvm+0xd2>
80107e18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e1d:	eb 18                	jmp    80107e37 <loaduvm+0xea>
80107e1f:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
80107e26:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e29:	3b 45 18             	cmp    0x18(%ebp),%eax
80107e2c:	0f 82 46 ff ff ff    	jb     80107d78 <loaduvm+0x2b>
80107e32:	b8 00 00 00 00       	mov    $0x0,%eax
80107e37:	83 c4 24             	add    $0x24,%esp
80107e3a:	5b                   	pop    %ebx
80107e3b:	5d                   	pop    %ebp
80107e3c:	c3                   	ret    

80107e3d <allocuvm>:
80107e3d:	55                   	push   %ebp
80107e3e:	89 e5                	mov    %esp,%ebp
80107e40:	83 ec 38             	sub    $0x38,%esp
80107e43:	8b 45 10             	mov    0x10(%ebp),%eax
80107e46:	85 c0                	test   %eax,%eax
80107e48:	79 0a                	jns    80107e54 <allocuvm+0x17>
80107e4a:	b8 00 00 00 00       	mov    $0x0,%eax
80107e4f:	e9 c1 00 00 00       	jmp    80107f15 <allocuvm+0xd8>
80107e54:	8b 45 10             	mov    0x10(%ebp),%eax
80107e57:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e5a:	73 08                	jae    80107e64 <allocuvm+0x27>
80107e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e5f:	e9 b1 00 00 00       	jmp    80107f15 <allocuvm+0xd8>
80107e64:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e67:	05 ff 0f 00 00       	add    $0xfff,%eax
80107e6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107e74:	e9 8d 00 00 00       	jmp    80107f06 <allocuvm+0xc9>
80107e79:	e8 fd ac ff ff       	call   80102b7b <kalloc>
80107e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107e81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e85:	75 2c                	jne    80107eb3 <allocuvm+0x76>
80107e87:	c7 04 24 fd 88 10 80 	movl   $0x801088fd,(%esp)
80107e8e:	e8 17 85 ff ff       	call   801003aa <cprintf>
80107e93:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e96:	89 44 24 08          	mov    %eax,0x8(%esp)
80107e9a:	8b 45 10             	mov    0x10(%ebp),%eax
80107e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80107ea4:	89 04 24             	mov    %eax,(%esp)
80107ea7:	e8 6b 00 00 00       	call   80107f17 <deallocuvm>
80107eac:	b8 00 00 00 00       	mov    $0x0,%eax
80107eb1:	eb 62                	jmp    80107f15 <allocuvm+0xd8>
80107eb3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107eba:	00 
80107ebb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107ec2:	00 
80107ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ec6:	89 04 24             	mov    %eax,(%esp)
80107ec9:	e8 a0 d0 ff ff       	call   80104f6e <memset>
80107ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ed1:	89 04 24             	mov    %eax,(%esp)
80107ed4:	e8 d6 f5 ff ff       	call   801074af <v2p>
80107ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107edc:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107ee3:	00 
80107ee4:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107ee8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107eef:	00 
80107ef0:	89 54 24 04          	mov    %edx,0x4(%esp)
80107ef4:	8b 45 08             	mov    0x8(%ebp),%eax
80107ef7:	89 04 24             	mov    %eax,(%esp)
80107efa:	e8 d6 fa ff ff       	call   801079d5 <mappages>
80107eff:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f09:	3b 45 10             	cmp    0x10(%ebp),%eax
80107f0c:	0f 82 67 ff ff ff    	jb     80107e79 <allocuvm+0x3c>
80107f12:	8b 45 10             	mov    0x10(%ebp),%eax
80107f15:	c9                   	leave  
80107f16:	c3                   	ret    

80107f17 <deallocuvm>:
80107f17:	55                   	push   %ebp
80107f18:	89 e5                	mov    %esp,%ebp
80107f1a:	83 ec 28             	sub    $0x28,%esp
80107f1d:	8b 45 10             	mov    0x10(%ebp),%eax
80107f20:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107f23:	72 08                	jb     80107f2d <deallocuvm+0x16>
80107f25:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f28:	e9 a4 00 00 00       	jmp    80107fd1 <deallocuvm+0xba>
80107f2d:	8b 45 10             	mov    0x10(%ebp),%eax
80107f30:	05 ff 0f 00 00       	add    $0xfff,%eax
80107f35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f3d:	e9 80 00 00 00       	jmp    80107fc2 <deallocuvm+0xab>
80107f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f45:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f4c:	00 
80107f4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f51:	8b 45 08             	mov    0x8(%ebp),%eax
80107f54:	89 04 24             	mov    %eax,(%esp)
80107f57:	e8 e3 f9 ff ff       	call   8010793f <walkpgdir>
80107f5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
80107f5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107f63:	75 09                	jne    80107f6e <deallocuvm+0x57>
80107f65:	81 45 ec 00 f0 3f 00 	addl   $0x3ff000,-0x14(%ebp)
80107f6c:	eb 4d                	jmp    80107fbb <deallocuvm+0xa4>
80107f6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f71:	8b 00                	mov    (%eax),%eax
80107f73:	83 e0 01             	and    $0x1,%eax
80107f76:	84 c0                	test   %al,%al
80107f78:	74 41                	je     80107fbb <deallocuvm+0xa4>
80107f7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f7d:	8b 00                	mov    (%eax),%eax
80107f7f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f84:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107f87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107f8b:	75 0c                	jne    80107f99 <deallocuvm+0x82>
80107f8d:	c7 04 24 15 89 10 80 	movl   $0x80108915,(%esp)
80107f94:	e8 ad 85 ff ff       	call   80100546 <panic>
80107f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f9c:	89 04 24             	mov    %eax,(%esp)
80107f9f:	e8 18 f5 ff ff       	call   801074bc <p2v>
80107fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107faa:	89 04 24             	mov    %eax,(%esp)
80107fad:	e8 30 ab ff ff       	call   80102ae2 <kfree>
80107fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107fb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80107fbb:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
80107fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fc5:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107fc8:	0f 82 74 ff ff ff    	jb     80107f42 <deallocuvm+0x2b>
80107fce:	8b 45 10             	mov    0x10(%ebp),%eax
80107fd1:	c9                   	leave  
80107fd2:	c3                   	ret    

80107fd3 <freevm>:
80107fd3:	55                   	push   %ebp
80107fd4:	89 e5                	mov    %esp,%ebp
80107fd6:	83 ec 28             	sub    $0x28,%esp
80107fd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107fdd:	75 0c                	jne    80107feb <freevm+0x18>
80107fdf:	c7 04 24 1b 89 10 80 	movl   $0x8010891b,(%esp)
80107fe6:	e8 5b 85 ff ff       	call   80100546 <panic>
80107feb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107ff2:	00 
80107ff3:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107ffa:	80 
80107ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80107ffe:	89 04 24             	mov    %eax,(%esp)
80108001:	e8 11 ff ff ff       	call   80107f17 <deallocuvm>
80108006:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010800d:	eb 3c                	jmp    8010804b <freevm+0x78>
8010800f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108012:	c1 e0 02             	shl    $0x2,%eax
80108015:	03 45 08             	add    0x8(%ebp),%eax
80108018:	8b 00                	mov    (%eax),%eax
8010801a:	83 e0 01             	and    $0x1,%eax
8010801d:	84 c0                	test   %al,%al
8010801f:	74 26                	je     80108047 <freevm+0x74>
80108021:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108024:	c1 e0 02             	shl    $0x2,%eax
80108027:	03 45 08             	add    0x8(%ebp),%eax
8010802a:	8b 00                	mov    (%eax),%eax
8010802c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108031:	89 04 24             	mov    %eax,(%esp)
80108034:	e8 83 f4 ff ff       	call   801074bc <p2v>
80108039:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010803c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803f:	89 04 24             	mov    %eax,(%esp)
80108042:	e8 9b aa ff ff       	call   80102ae2 <kfree>
80108047:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010804b:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
80108052:	76 bb                	jbe    8010800f <freevm+0x3c>
80108054:	8b 45 08             	mov    0x8(%ebp),%eax
80108057:	89 04 24             	mov    %eax,(%esp)
8010805a:	e8 83 aa ff ff       	call   80102ae2 <kfree>
8010805f:	c9                   	leave  
80108060:	c3                   	ret    

80108061 <clearpteu>:
80108061:	55                   	push   %ebp
80108062:	89 e5                	mov    %esp,%ebp
80108064:	83 ec 28             	sub    $0x28,%esp
80108067:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010806e:	00 
8010806f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108072:	89 44 24 04          	mov    %eax,0x4(%esp)
80108076:	8b 45 08             	mov    0x8(%ebp),%eax
80108079:	89 04 24             	mov    %eax,(%esp)
8010807c:	e8 be f8 ff ff       	call   8010793f <walkpgdir>
80108081:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108084:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108088:	75 0c                	jne    80108096 <clearpteu+0x35>
8010808a:	c7 04 24 2c 89 10 80 	movl   $0x8010892c,(%esp)
80108091:	e8 b0 84 ff ff       	call   80100546 <panic>
80108096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108099:	8b 00                	mov    (%eax),%eax
8010809b:	89 c2                	mov    %eax,%edx
8010809d:	83 e2 fb             	and    $0xfffffffb,%edx
801080a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a3:	89 10                	mov    %edx,(%eax)
801080a5:	c9                   	leave  
801080a6:	c3                   	ret    

801080a7 <copyuvm>:
801080a7:	55                   	push   %ebp
801080a8:	89 e5                	mov    %esp,%ebp
801080aa:	53                   	push   %ebx
801080ab:	83 ec 44             	sub    $0x44,%esp
801080ae:	e8 b6 f9 ff ff       	call   80107a69 <setupkvm>
801080b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801080b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801080ba:	75 0a                	jne    801080c6 <copyuvm+0x1f>
801080bc:	b8 00 00 00 00       	mov    $0x0,%eax
801080c1:	e9 fd 00 00 00       	jmp    801081c3 <copyuvm+0x11c>
801080c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801080cd:	e9 cc 00 00 00       	jmp    8010819e <copyuvm+0xf7>
801080d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080d5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801080dc:	00 
801080dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801080e1:	8b 45 08             	mov    0x8(%ebp),%eax
801080e4:	89 04 24             	mov    %eax,(%esp)
801080e7:	e8 53 f8 ff ff       	call   8010793f <walkpgdir>
801080ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801080ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801080f3:	75 0c                	jne    80108101 <copyuvm+0x5a>
801080f5:	c7 04 24 36 89 10 80 	movl   $0x80108936,(%esp)
801080fc:	e8 45 84 ff ff       	call   80100546 <panic>
80108101:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108104:	8b 00                	mov    (%eax),%eax
80108106:	83 e0 01             	and    $0x1,%eax
80108109:	85 c0                	test   %eax,%eax
8010810b:	75 0c                	jne    80108119 <copyuvm+0x72>
8010810d:	c7 04 24 50 89 10 80 	movl   $0x80108950,(%esp)
80108114:	e8 2d 84 ff ff       	call   80100546 <panic>
80108119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010811c:	8b 00                	mov    (%eax),%eax
8010811e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108123:	89 45 e8             	mov    %eax,-0x18(%ebp)
80108126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108129:	8b 00                	mov    (%eax),%eax
8010812b:	25 ff 0f 00 00       	and    $0xfff,%eax
80108130:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108133:	e8 43 aa ff ff       	call   80102b7b <kalloc>
80108138:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010813b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010813f:	74 6e                	je     801081af <copyuvm+0x108>
80108141:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108144:	89 04 24             	mov    %eax,(%esp)
80108147:	e8 70 f3 ff ff       	call   801074bc <p2v>
8010814c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108153:	00 
80108154:	89 44 24 04          	mov    %eax,0x4(%esp)
80108158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010815b:	89 04 24             	mov    %eax,(%esp)
8010815e:	e8 de ce ff ff       	call   80105041 <memmove>
80108163:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80108166:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108169:	89 04 24             	mov    %eax,(%esp)
8010816c:	e8 3e f3 ff ff       	call   801074af <v2p>
80108171:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108174:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108178:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010817c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108183:	00 
80108184:	89 54 24 04          	mov    %edx,0x4(%esp)
80108188:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010818b:	89 04 24             	mov    %eax,(%esp)
8010818e:	e8 42 f8 ff ff       	call   801079d5 <mappages>
80108193:	85 c0                	test   %eax,%eax
80108195:	78 1b                	js     801081b2 <copyuvm+0x10b>
80108197:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
8010819e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801081a4:	0f 82 28 ff ff ff    	jb     801080d2 <copyuvm+0x2b>
801081aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081ad:	eb 14                	jmp    801081c3 <copyuvm+0x11c>
801081af:	90                   	nop
801081b0:	eb 01                	jmp    801081b3 <copyuvm+0x10c>
801081b2:	90                   	nop
801081b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081b6:	89 04 24             	mov    %eax,(%esp)
801081b9:	e8 15 fe ff ff       	call   80107fd3 <freevm>
801081be:	b8 00 00 00 00       	mov    $0x0,%eax
801081c3:	83 c4 44             	add    $0x44,%esp
801081c6:	5b                   	pop    %ebx
801081c7:	5d                   	pop    %ebp
801081c8:	c3                   	ret    

801081c9 <uva2ka>:
801081c9:	55                   	push   %ebp
801081ca:	89 e5                	mov    %esp,%ebp
801081cc:	83 ec 28             	sub    $0x28,%esp
801081cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801081d6:	00 
801081d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801081da:	89 44 24 04          	mov    %eax,0x4(%esp)
801081de:	8b 45 08             	mov    0x8(%ebp),%eax
801081e1:	89 04 24             	mov    %eax,(%esp)
801081e4:	e8 56 f7 ff ff       	call   8010793f <walkpgdir>
801081e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801081ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ef:	8b 00                	mov    (%eax),%eax
801081f1:	83 e0 01             	and    $0x1,%eax
801081f4:	85 c0                	test   %eax,%eax
801081f6:	75 07                	jne    801081ff <uva2ka+0x36>
801081f8:	b8 00 00 00 00       	mov    $0x0,%eax
801081fd:	eb 25                	jmp    80108224 <uva2ka+0x5b>
801081ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108202:	8b 00                	mov    (%eax),%eax
80108204:	83 e0 04             	and    $0x4,%eax
80108207:	85 c0                	test   %eax,%eax
80108209:	75 07                	jne    80108212 <uva2ka+0x49>
8010820b:	b8 00 00 00 00       	mov    $0x0,%eax
80108210:	eb 12                	jmp    80108224 <uva2ka+0x5b>
80108212:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108215:	8b 00                	mov    (%eax),%eax
80108217:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010821c:	89 04 24             	mov    %eax,(%esp)
8010821f:	e8 98 f2 ff ff       	call   801074bc <p2v>
80108224:	c9                   	leave  
80108225:	c3                   	ret    

80108226 <copyout>:
80108226:	55                   	push   %ebp
80108227:	89 e5                	mov    %esp,%ebp
80108229:	83 ec 28             	sub    $0x28,%esp
8010822c:	8b 45 10             	mov    0x10(%ebp),%eax
8010822f:	89 45 e8             	mov    %eax,-0x18(%ebp)
80108232:	e9 8b 00 00 00       	jmp    801082c2 <copyout+0x9c>
80108237:	8b 45 0c             	mov    0xc(%ebp),%eax
8010823a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010823f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108242:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108245:	89 44 24 04          	mov    %eax,0x4(%esp)
80108249:	8b 45 08             	mov    0x8(%ebp),%eax
8010824c:	89 04 24             	mov    %eax,(%esp)
8010824f:	e8 75 ff ff ff       	call   801081c9 <uva2ka>
80108254:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108257:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010825b:	75 07                	jne    80108264 <copyout+0x3e>
8010825d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108262:	eb 6d                	jmp    801082d1 <copyout+0xab>
80108264:	8b 45 0c             	mov    0xc(%ebp),%eax
80108267:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010826a:	89 d1                	mov    %edx,%ecx
8010826c:	29 c1                	sub    %eax,%ecx
8010826e:	89 c8                	mov    %ecx,%eax
80108270:	05 00 10 00 00       	add    $0x1000,%eax
80108275:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108278:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010827b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010827e:	76 06                	jbe    80108286 <copyout+0x60>
80108280:	8b 45 14             	mov    0x14(%ebp),%eax
80108283:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108286:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108289:	8b 55 0c             	mov    0xc(%ebp),%edx
8010828c:	89 d1                	mov    %edx,%ecx
8010828e:	29 c1                	sub    %eax,%ecx
80108290:	89 c8                	mov    %ecx,%eax
80108292:	03 45 ec             	add    -0x14(%ebp),%eax
80108295:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108298:	89 54 24 08          	mov    %edx,0x8(%esp)
8010829c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010829f:	89 54 24 04          	mov    %edx,0x4(%esp)
801082a3:	89 04 24             	mov    %eax,(%esp)
801082a6:	e8 96 cd ff ff       	call   80105041 <memmove>
801082ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082ae:	29 45 14             	sub    %eax,0x14(%ebp)
801082b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082b4:	01 45 e8             	add    %eax,-0x18(%ebp)
801082b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ba:	05 00 10 00 00       	add    $0x1000,%eax
801082bf:	89 45 0c             	mov    %eax,0xc(%ebp)
801082c2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801082c6:	0f 85 6b ff ff ff    	jne    80108237 <copyout+0x11>
801082cc:	b8 00 00 00 00       	mov    $0x0,%eax
801082d1:	c9                   	leave  
801082d2:	c3                   	ret    
