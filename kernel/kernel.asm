
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0023a117          	auipc	sp,0x23a
    80000004:	cd010113          	addi	sp,sp,-816 # 80239cd0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	469050ef          	jal	80005c7e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7179                	addi	sp,sp,-48
    8000001e:	f406                	sd	ra,40(sp)
    80000020:	f022                	sd	s0,32(sp)
    80000022:	ec26                	sd	s1,24(sp)
    80000024:	e84a                	sd	s2,16(sp)
    80000026:	e44e                	sd	s3,8(sp)
    80000028:	e052                	sd	s4,0(sp)
    8000002a:	1800                	addi	s0,sp,48
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002c:	03451793          	slli	a5,a0,0x34
    80000030:	e7ad                	bnez	a5,8000009a <kfree+0x7e>
    80000032:	84aa                	mv	s1,a0
    80000034:	00242797          	auipc	a5,0x242
    80000038:	d9c78793          	addi	a5,a5,-612 # 80241dd0 <end>
    8000003c:	04f56f63          	bltu	a0,a5,8000009a <kfree+0x7e>
    80000040:	47c5                	li	a5,17
    80000042:	07ee                	slli	a5,a5,0x1b
    80000044:	04f57b63          	bgeu	a0,a5,8000009a <kfree+0x7e>
    panic("kfree");

  acquire(&count_lock);
    80000048:	00009a17          	auipc	s4,0x9
    8000004c:	8f8a0a13          	addi	s4,s4,-1800 # 80008940 <count_lock>
    80000050:	8552                	mv	a0,s4
    80000052:	00006097          	auipc	ra,0x6
    80000056:	67a080e7          	jalr	1658(ra) # 800066cc <acquire>

  int index = (uint64)pa/PGSIZE;
    8000005a:	00c4d993          	srli	s3,s1,0xc
    8000005e:	0009879b          	sext.w	a5,s3
   memcount[index] -- ;
    80000062:	00009917          	auipc	s2,0x9
    80000066:	91690913          	addi	s2,s2,-1770 # 80008978 <memcount>
    8000006a:	078a                	slli	a5,a5,0x2
    8000006c:	97ca                	add	a5,a5,s2
    8000006e:	4398                	lw	a4,0(a5)
    80000070:	377d                	addiw	a4,a4,-1
    80000072:	c398                	sw	a4,0(a5)
  
  release(&count_lock);
    80000074:	8552                	mv	a0,s4
    80000076:	00006097          	auipc	ra,0x6
    8000007a:	70a080e7          	jalr	1802(ra) # 80006780 <release>

  if(memcount[(uint64)pa/PGSIZE] > 0 ) return ;
    8000007e:	098a                	slli	s3,s3,0x2
    80000080:	994e                	add	s2,s2,s3
    80000082:	00092783          	lw	a5,0(s2)
    80000086:	02f05263          	blez	a5,800000aa <kfree+0x8e>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    8000008a:	70a2                	ld	ra,40(sp)
    8000008c:	7402                	ld	s0,32(sp)
    8000008e:	64e2                	ld	s1,24(sp)
    80000090:	6942                	ld	s2,16(sp)
    80000092:	69a2                	ld	s3,8(sp)
    80000094:	6a02                	ld	s4,0(sp)
    80000096:	6145                	addi	sp,sp,48
    80000098:	8082                	ret
    panic("kfree");
    8000009a:	00008517          	auipc	a0,0x8
    8000009e:	f6650513          	addi	a0,a0,-154 # 80008000 <etext>
    800000a2:	00006097          	auipc	ra,0x6
    800000a6:	0b0080e7          	jalr	176(ra) # 80006152 <panic>
  memset(pa, 1, PGSIZE);
    800000aa:	6605                	lui	a2,0x1
    800000ac:	4585                	li	a1,1
    800000ae:	8526                	mv	a0,s1
    800000b0:	00000097          	auipc	ra,0x0
    800000b4:	1fa080e7          	jalr	506(ra) # 800002aa <memset>
  acquire(&kmem.lock);
    800000b8:	00009917          	auipc	s2,0x9
    800000bc:	8a090913          	addi	s2,s2,-1888 # 80008958 <kmem>
    800000c0:	854a                	mv	a0,s2
    800000c2:	00006097          	auipc	ra,0x6
    800000c6:	60a080e7          	jalr	1546(ra) # 800066cc <acquire>
  r->next = kmem.freelist;
    800000ca:	030a3783          	ld	a5,48(s4)
    800000ce:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000d0:	029a3823          	sd	s1,48(s4)
  release(&kmem.lock);
    800000d4:	854a                	mv	a0,s2
    800000d6:	00006097          	auipc	ra,0x6
    800000da:	6aa080e7          	jalr	1706(ra) # 80006780 <release>
    800000de:	b775                	j	8000008a <kfree+0x6e>

00000000800000e0 <freerange>:
{
    800000e0:	7179                	addi	sp,sp,-48
    800000e2:	f406                	sd	ra,40(sp)
    800000e4:	f022                	sd	s0,32(sp)
    800000e6:	ec26                	sd	s1,24(sp)
    800000e8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000ea:	6785                	lui	a5,0x1
    800000ec:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000f0:	00e504b3          	add	s1,a0,a4
    800000f4:	777d                	lui	a4,0xfffff
    800000f6:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f8:	94be                	add	s1,s1,a5
    800000fa:	0295e463          	bltu	a1,s1,80000122 <freerange+0x42>
    800000fe:	e84a                	sd	s2,16(sp)
    80000100:	e44e                	sd	s3,8(sp)
    80000102:	e052                	sd	s4,0(sp)
    80000104:	892e                	mv	s2,a1
    kfree(p);
    80000106:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000108:	6985                	lui	s3,0x1
    kfree(p);
    8000010a:	01448533          	add	a0,s1,s4
    8000010e:	00000097          	auipc	ra,0x0
    80000112:	f0e080e7          	jalr	-242(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000116:	94ce                	add	s1,s1,s3
    80000118:	fe9979e3          	bgeu	s2,s1,8000010a <freerange+0x2a>
    8000011c:	6942                	ld	s2,16(sp)
    8000011e:	69a2                	ld	s3,8(sp)
    80000120:	6a02                	ld	s4,0(sp)
}
    80000122:	70a2                	ld	ra,40(sp)
    80000124:	7402                	ld	s0,32(sp)
    80000126:	64e2                	ld	s1,24(sp)
    80000128:	6145                	addi	sp,sp,48
    8000012a:	8082                	ret

000000008000012c <kinit>:
{
    8000012c:	1141                	addi	sp,sp,-16
    8000012e:	e406                	sd	ra,8(sp)
    80000130:	e022                	sd	s0,0(sp)
    80000132:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000134:	00008597          	auipc	a1,0x8
    80000138:	edc58593          	addi	a1,a1,-292 # 80008010 <etext+0x10>
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	81c50513          	addi	a0,a0,-2020 # 80008958 <kmem>
    80000144:	00006097          	auipc	ra,0x6
    80000148:	4f8080e7          	jalr	1272(ra) # 8000663c <initlock>
  initlock(&count_lock, "c_lock");
    8000014c:	00008597          	auipc	a1,0x8
    80000150:	ecc58593          	addi	a1,a1,-308 # 80008018 <etext+0x18>
    80000154:	00008517          	auipc	a0,0x8
    80000158:	7ec50513          	addi	a0,a0,2028 # 80008940 <count_lock>
    8000015c:	00006097          	auipc	ra,0x6
    80000160:	4e0080e7          	jalr	1248(ra) # 8000663c <initlock>
  freerange(end, (void*)PHYSTOP);
    80000164:	45c5                	li	a1,17
    80000166:	05ee                	slli	a1,a1,0x1b
    80000168:	00242517          	auipc	a0,0x242
    8000016c:	c6850513          	addi	a0,a0,-920 # 80241dd0 <end>
    80000170:	00000097          	auipc	ra,0x0
    80000174:	f70080e7          	jalr	-144(ra) # 800000e0 <freerange>
}
    80000178:	60a2                	ld	ra,8(sp)
    8000017a:	6402                	ld	s0,0(sp)
    8000017c:	0141                	addi	sp,sp,16
    8000017e:	8082                	ret

0000000080000180 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000180:	1101                	addi	sp,sp,-32
    80000182:	ec06                	sd	ra,24(sp)
    80000184:	e822                	sd	s0,16(sp)
    80000186:	e426                	sd	s1,8(sp)
    80000188:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000018a:	00008517          	auipc	a0,0x8
    8000018e:	7ce50513          	addi	a0,a0,1998 # 80008958 <kmem>
    80000192:	00006097          	auipc	ra,0x6
    80000196:	53a080e7          	jalr	1338(ra) # 800066cc <acquire>
  r = kmem.freelist;
    8000019a:	00008497          	auipc	s1,0x8
    8000019e:	7d64b483          	ld	s1,2006(s1) # 80008970 <kmem+0x18>
  if(r){
    800001a2:	c4a5                	beqz	s1,8000020a <kalloc+0x8a>
    800001a4:	e04a                	sd	s2,0(sp)
    kmem.freelist = r->next;
    800001a6:	609c                	ld	a5,0(s1)
    800001a8:	00008917          	auipc	s2,0x8
    800001ac:	79890913          	addi	s2,s2,1944 # 80008940 <count_lock>
    800001b0:	02f93823          	sd	a5,48(s2)
    acquire(&count_lock);
    800001b4:	854a                	mv	a0,s2
    800001b6:	00006097          	auipc	ra,0x6
    800001ba:	516080e7          	jalr	1302(ra) # 800066cc <acquire>
    int index = (uint64)r / PGSIZE;
    800001be:	00c4d793          	srli	a5,s1,0xc
    memcount[index] = 1;
    800001c2:	2781                	sext.w	a5,a5
    800001c4:	078a                	slli	a5,a5,0x2
    800001c6:	00008717          	auipc	a4,0x8
    800001ca:	7b270713          	addi	a4,a4,1970 # 80008978 <memcount>
    800001ce:	97ba                	add	a5,a5,a4
    800001d0:	4705                	li	a4,1
    800001d2:	c398                	sw	a4,0(a5)
    release(&count_lock);
    800001d4:	854a                	mv	a0,s2
    800001d6:	00006097          	auipc	ra,0x6
    800001da:	5aa080e7          	jalr	1450(ra) # 80006780 <release>
  }
  release(&kmem.lock);
    800001de:	00008517          	auipc	a0,0x8
    800001e2:	77a50513          	addi	a0,a0,1914 # 80008958 <kmem>
    800001e6:	00006097          	auipc	ra,0x6
    800001ea:	59a080e7          	jalr	1434(ra) # 80006780 <release>


  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001ee:	6605                	lui	a2,0x1
    800001f0:	4595                	li	a1,5
    800001f2:	8526                	mv	a0,s1
    800001f4:	00000097          	auipc	ra,0x0
    800001f8:	0b6080e7          	jalr	182(ra) # 800002aa <memset>
  return (void*)r;
    800001fc:	6902                	ld	s2,0(sp)
}
    800001fe:	8526                	mv	a0,s1
    80000200:	60e2                	ld	ra,24(sp)
    80000202:	6442                	ld	s0,16(sp)
    80000204:	64a2                	ld	s1,8(sp)
    80000206:	6105                	addi	sp,sp,32
    80000208:	8082                	ret
  release(&kmem.lock);
    8000020a:	00008517          	auipc	a0,0x8
    8000020e:	74e50513          	addi	a0,a0,1870 # 80008958 <kmem>
    80000212:	00006097          	auipc	ra,0x6
    80000216:	56e080e7          	jalr	1390(ra) # 80006780 <release>
  if(r)
    8000021a:	b7d5                	j	800001fe <kalloc+0x7e>

000000008000021c <kcount>:


void kcount(int index){
    8000021c:	1101                	addi	sp,sp,-32
    8000021e:	ec06                	sd	ra,24(sp)
    80000220:	e822                	sd	s0,16(sp)
    80000222:	e426                	sd	s1,8(sp)
    80000224:	e04a                	sd	s2,0(sp)
    80000226:	1000                	addi	s0,sp,32
    80000228:	84aa                	mv	s1,a0
  acquire(&count_lock);
    8000022a:	00008917          	auipc	s2,0x8
    8000022e:	71690913          	addi	s2,s2,1814 # 80008940 <count_lock>
    80000232:	854a                	mv	a0,s2
    80000234:	00006097          	auipc	ra,0x6
    80000238:	498080e7          	jalr	1176(ra) # 800066cc <acquire>
  memcount[index] ++;
    8000023c:	048a                	slli	s1,s1,0x2
    8000023e:	00008797          	auipc	a5,0x8
    80000242:	73a78793          	addi	a5,a5,1850 # 80008978 <memcount>
    80000246:	97a6                	add	a5,a5,s1
    80000248:	4398                	lw	a4,0(a5)
    8000024a:	2705                	addiw	a4,a4,1
    8000024c:	c398                	sw	a4,0(a5)
  release(&count_lock);
    8000024e:	854a                	mv	a0,s2
    80000250:	00006097          	auipc	ra,0x6
    80000254:	530080e7          	jalr	1328(ra) # 80006780 <release>
}
    80000258:	60e2                	ld	ra,24(sp)
    8000025a:	6442                	ld	s0,16(sp)
    8000025c:	64a2                	ld	s1,8(sp)
    8000025e:	6902                	ld	s2,0(sp)
    80000260:	6105                	addi	sp,sp,32
    80000262:	8082                	ret

0000000080000264 <knum>:

int
knum(int index)
{
    80000264:	1101                	addi	sp,sp,-32
    80000266:	ec06                	sd	ra,24(sp)
    80000268:	e822                	sd	s0,16(sp)
    8000026a:	e426                	sd	s1,8(sp)
    8000026c:	e04a                	sd	s2,0(sp)
    8000026e:	1000                	addi	s0,sp,32
    80000270:	84aa                	mv	s1,a0
    acquire(&count_lock);
    80000272:	00008917          	auipc	s2,0x8
    80000276:	6ce90913          	addi	s2,s2,1742 # 80008940 <count_lock>
    8000027a:	854a                	mv	a0,s2
    8000027c:	00006097          	auipc	ra,0x6
    80000280:	450080e7          	jalr	1104(ra) # 800066cc <acquire>
    int num = memcount[index];
    80000284:	048a                	slli	s1,s1,0x2
    80000286:	00008797          	auipc	a5,0x8
    8000028a:	6f278793          	addi	a5,a5,1778 # 80008978 <memcount>
    8000028e:	97a6                	add	a5,a5,s1
    80000290:	4384                	lw	s1,0(a5)
    release(&count_lock);
    80000292:	854a                	mv	a0,s2
    80000294:	00006097          	auipc	ra,0x6
    80000298:	4ec080e7          	jalr	1260(ra) # 80006780 <release>

    return num;
    8000029c:	8526                	mv	a0,s1
    8000029e:	60e2                	ld	ra,24(sp)
    800002a0:	6442                	ld	s0,16(sp)
    800002a2:	64a2                	ld	s1,8(sp)
    800002a4:	6902                	ld	s2,0(sp)
    800002a6:	6105                	addi	sp,sp,32
    800002a8:	8082                	ret

00000000800002aa <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002aa:	1141                	addi	sp,sp,-16
    800002ac:	e422                	sd	s0,8(sp)
    800002ae:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002b0:	ca19                	beqz	a2,800002c6 <memset+0x1c>
    800002b2:	87aa                	mv	a5,a0
    800002b4:	1602                	slli	a2,a2,0x20
    800002b6:	9201                	srli	a2,a2,0x20
    800002b8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800002bc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002c0:	0785                	addi	a5,a5,1
    800002c2:	fee79de3          	bne	a5,a4,800002bc <memset+0x12>
  }
  return dst;
}
    800002c6:	6422                	ld	s0,8(sp)
    800002c8:	0141                	addi	sp,sp,16
    800002ca:	8082                	ret

00000000800002cc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002cc:	1141                	addi	sp,sp,-16
    800002ce:	e422                	sd	s0,8(sp)
    800002d0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002d2:	ca05                	beqz	a2,80000302 <memcmp+0x36>
    800002d4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	0685                	addi	a3,a3,1
    800002de:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002e0:	00054783          	lbu	a5,0(a0)
    800002e4:	0005c703          	lbu	a4,0(a1)
    800002e8:	00e79863          	bne	a5,a4,800002f8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002ec:	0505                	addi	a0,a0,1
    800002ee:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002f0:	fed518e3          	bne	a0,a3,800002e0 <memcmp+0x14>
  }

  return 0;
    800002f4:	4501                	li	a0,0
    800002f6:	a019                	j	800002fc <memcmp+0x30>
      return *s1 - *s2;
    800002f8:	40e7853b          	subw	a0,a5,a4
}
    800002fc:	6422                	ld	s0,8(sp)
    800002fe:	0141                	addi	sp,sp,16
    80000300:	8082                	ret
  return 0;
    80000302:	4501                	li	a0,0
    80000304:	bfe5                	j	800002fc <memcmp+0x30>

0000000080000306 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000306:	1141                	addi	sp,sp,-16
    80000308:	e422                	sd	s0,8(sp)
    8000030a:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    8000030c:	c205                	beqz	a2,8000032c <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000030e:	02a5e263          	bltu	a1,a0,80000332 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000312:	1602                	slli	a2,a2,0x20
    80000314:	9201                	srli	a2,a2,0x20
    80000316:	00c587b3          	add	a5,a1,a2
{
    8000031a:	872a                	mv	a4,a0
      *d++ = *s++;
    8000031c:	0585                	addi	a1,a1,1
    8000031e:	0705                	addi	a4,a4,1
    80000320:	fff5c683          	lbu	a3,-1(a1)
    80000324:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000328:	feb79ae3          	bne	a5,a1,8000031c <memmove+0x16>

  return dst;
}
    8000032c:	6422                	ld	s0,8(sp)
    8000032e:	0141                	addi	sp,sp,16
    80000330:	8082                	ret
  if(s < d && s + n > d){
    80000332:	02061693          	slli	a3,a2,0x20
    80000336:	9281                	srli	a3,a3,0x20
    80000338:	00d58733          	add	a4,a1,a3
    8000033c:	fce57be3          	bgeu	a0,a4,80000312 <memmove+0xc>
    d += n;
    80000340:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000342:	fff6079b          	addiw	a5,a2,-1
    80000346:	1782                	slli	a5,a5,0x20
    80000348:	9381                	srli	a5,a5,0x20
    8000034a:	fff7c793          	not	a5,a5
    8000034e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000350:	177d                	addi	a4,a4,-1
    80000352:	16fd                	addi	a3,a3,-1
    80000354:	00074603          	lbu	a2,0(a4)
    80000358:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000035c:	fef71ae3          	bne	a4,a5,80000350 <memmove+0x4a>
    80000360:	b7f1                	j	8000032c <memmove+0x26>

0000000080000362 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000362:	1141                	addi	sp,sp,-16
    80000364:	e406                	sd	ra,8(sp)
    80000366:	e022                	sd	s0,0(sp)
    80000368:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000036a:	00000097          	auipc	ra,0x0
    8000036e:	f9c080e7          	jalr	-100(ra) # 80000306 <memmove>
}
    80000372:	60a2                	ld	ra,8(sp)
    80000374:	6402                	ld	s0,0(sp)
    80000376:	0141                	addi	sp,sp,16
    80000378:	8082                	ret

000000008000037a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000037a:	1141                	addi	sp,sp,-16
    8000037c:	e422                	sd	s0,8(sp)
    8000037e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000380:	ce11                	beqz	a2,8000039c <strncmp+0x22>
    80000382:	00054783          	lbu	a5,0(a0)
    80000386:	cf89                	beqz	a5,800003a0 <strncmp+0x26>
    80000388:	0005c703          	lbu	a4,0(a1)
    8000038c:	00f71a63          	bne	a4,a5,800003a0 <strncmp+0x26>
    n--, p++, q++;
    80000390:	367d                	addiw	a2,a2,-1
    80000392:	0505                	addi	a0,a0,1
    80000394:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000396:	f675                	bnez	a2,80000382 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000398:	4501                	li	a0,0
    8000039a:	a801                	j	800003aa <strncmp+0x30>
    8000039c:	4501                	li	a0,0
    8000039e:	a031                	j	800003aa <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    800003a0:	00054503          	lbu	a0,0(a0)
    800003a4:	0005c783          	lbu	a5,0(a1)
    800003a8:	9d1d                	subw	a0,a0,a5
}
    800003aa:	6422                	ld	s0,8(sp)
    800003ac:	0141                	addi	sp,sp,16
    800003ae:	8082                	ret

00000000800003b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003b0:	1141                	addi	sp,sp,-16
    800003b2:	e422                	sd	s0,8(sp)
    800003b4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003b6:	87aa                	mv	a5,a0
    800003b8:	86b2                	mv	a3,a2
    800003ba:	367d                	addiw	a2,a2,-1
    800003bc:	02d05563          	blez	a3,800003e6 <strncpy+0x36>
    800003c0:	0785                	addi	a5,a5,1
    800003c2:	0005c703          	lbu	a4,0(a1)
    800003c6:	fee78fa3          	sb	a4,-1(a5)
    800003ca:	0585                	addi	a1,a1,1
    800003cc:	f775                	bnez	a4,800003b8 <strncpy+0x8>
    ;
  while(n-- > 0)
    800003ce:	873e                	mv	a4,a5
    800003d0:	9fb5                	addw	a5,a5,a3
    800003d2:	37fd                	addiw	a5,a5,-1
    800003d4:	00c05963          	blez	a2,800003e6 <strncpy+0x36>
    *s++ = 0;
    800003d8:	0705                	addi	a4,a4,1
    800003da:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800003de:	40e786bb          	subw	a3,a5,a4
    800003e2:	fed04be3          	bgtz	a3,800003d8 <strncpy+0x28>
  return os;
}
    800003e6:	6422                	ld	s0,8(sp)
    800003e8:	0141                	addi	sp,sp,16
    800003ea:	8082                	ret

00000000800003ec <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003ec:	1141                	addi	sp,sp,-16
    800003ee:	e422                	sd	s0,8(sp)
    800003f0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003f2:	02c05363          	blez	a2,80000418 <safestrcpy+0x2c>
    800003f6:	fff6069b          	addiw	a3,a2,-1
    800003fa:	1682                	slli	a3,a3,0x20
    800003fc:	9281                	srli	a3,a3,0x20
    800003fe:	96ae                	add	a3,a3,a1
    80000400:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000402:	00d58963          	beq	a1,a3,80000414 <safestrcpy+0x28>
    80000406:	0585                	addi	a1,a1,1
    80000408:	0785                	addi	a5,a5,1
    8000040a:	fff5c703          	lbu	a4,-1(a1)
    8000040e:	fee78fa3          	sb	a4,-1(a5)
    80000412:	fb65                	bnez	a4,80000402 <safestrcpy+0x16>
    ;
  *s = 0;
    80000414:	00078023          	sb	zero,0(a5)
  return os;
}
    80000418:	6422                	ld	s0,8(sp)
    8000041a:	0141                	addi	sp,sp,16
    8000041c:	8082                	ret

000000008000041e <strlen>:

int
strlen(const char *s)
{
    8000041e:	1141                	addi	sp,sp,-16
    80000420:	e422                	sd	s0,8(sp)
    80000422:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000424:	00054783          	lbu	a5,0(a0)
    80000428:	cf91                	beqz	a5,80000444 <strlen+0x26>
    8000042a:	0505                	addi	a0,a0,1
    8000042c:	87aa                	mv	a5,a0
    8000042e:	86be                	mv	a3,a5
    80000430:	0785                	addi	a5,a5,1
    80000432:	fff7c703          	lbu	a4,-1(a5)
    80000436:	ff65                	bnez	a4,8000042e <strlen+0x10>
    80000438:	40a6853b          	subw	a0,a3,a0
    8000043c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000043e:	6422                	ld	s0,8(sp)
    80000440:	0141                	addi	sp,sp,16
    80000442:	8082                	ret
  for(n = 0; s[n]; n++)
    80000444:	4501                	li	a0,0
    80000446:	bfe5                	j	8000043e <strlen+0x20>

0000000080000448 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000448:	1141                	addi	sp,sp,-16
    8000044a:	e406                	sd	ra,8(sp)
    8000044c:	e022                	sd	s0,0(sp)
    8000044e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000450:	00001097          	auipc	ra,0x1
    80000454:	d14080e7          	jalr	-748(ra) # 80001164 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000458:	00008717          	auipc	a4,0x8
    8000045c:	4b870713          	addi	a4,a4,1208 # 80008910 <started>
  if(cpuid() == 0){
    80000460:	c139                	beqz	a0,800004a6 <main+0x5e>
    while(started == 0)
    80000462:	431c                	lw	a5,0(a4)
    80000464:	2781                	sext.w	a5,a5
    80000466:	dff5                	beqz	a5,80000462 <main+0x1a>
      ;
    __sync_synchronize();
    80000468:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000046c:	00001097          	auipc	ra,0x1
    80000470:	cf8080e7          	jalr	-776(ra) # 80001164 <cpuid>
    80000474:	85aa                	mv	a1,a0
    80000476:	00008517          	auipc	a0,0x8
    8000047a:	bca50513          	addi	a0,a0,-1078 # 80008040 <etext+0x40>
    8000047e:	00006097          	auipc	ra,0x6
    80000482:	d1e080e7          	jalr	-738(ra) # 8000619c <printf>
    kvminithart();    // turn on paging
    80000486:	00000097          	auipc	ra,0x0
    8000048a:	0d8080e7          	jalr	216(ra) # 8000055e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000048e:	00002097          	auipc	ra,0x2
    80000492:	9a6080e7          	jalr	-1626(ra) # 80001e34 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000496:	00005097          	auipc	ra,0x5
    8000049a:	15e080e7          	jalr	350(ra) # 800055f4 <plicinithart>
  }

  scheduler();        
    8000049e:	00001097          	auipc	ra,0x1
    800004a2:	1ee080e7          	jalr	494(ra) # 8000168c <scheduler>
    consoleinit();
    800004a6:	00006097          	auipc	ra,0x6
    800004aa:	bbc080e7          	jalr	-1092(ra) # 80006062 <consoleinit>
    printfinit();
    800004ae:	00006097          	auipc	ra,0x6
    800004b2:	ef6080e7          	jalr	-266(ra) # 800063a4 <printfinit>
    printf("\n");
    800004b6:	00008517          	auipc	a0,0x8
    800004ba:	b6a50513          	addi	a0,a0,-1174 # 80008020 <etext+0x20>
    800004be:	00006097          	auipc	ra,0x6
    800004c2:	cde080e7          	jalr	-802(ra) # 8000619c <printf>
    printf("xv6 kernel is booting\n");
    800004c6:	00008517          	auipc	a0,0x8
    800004ca:	b6250513          	addi	a0,a0,-1182 # 80008028 <etext+0x28>
    800004ce:	00006097          	auipc	ra,0x6
    800004d2:	cce080e7          	jalr	-818(ra) # 8000619c <printf>
    printf("\n");
    800004d6:	00008517          	auipc	a0,0x8
    800004da:	b4a50513          	addi	a0,a0,-1206 # 80008020 <etext+0x20>
    800004de:	00006097          	auipc	ra,0x6
    800004e2:	cbe080e7          	jalr	-834(ra) # 8000619c <printf>
    kinit();         // physical page allocator
    800004e6:	00000097          	auipc	ra,0x0
    800004ea:	c46080e7          	jalr	-954(ra) # 8000012c <kinit>
    kvminit();       // create kernel page table
    800004ee:	00000097          	auipc	ra,0x0
    800004f2:	34a080e7          	jalr	842(ra) # 80000838 <kvminit>
    kvminithart();   // turn on paging
    800004f6:	00000097          	auipc	ra,0x0
    800004fa:	068080e7          	jalr	104(ra) # 8000055e <kvminithart>
    procinit();      // process table
    800004fe:	00001097          	auipc	ra,0x1
    80000502:	ba4080e7          	jalr	-1116(ra) # 800010a2 <procinit>
    trapinit();      // trap vectors
    80000506:	00002097          	auipc	ra,0x2
    8000050a:	906080e7          	jalr	-1786(ra) # 80001e0c <trapinit>
    trapinithart();  // install kernel trap vector
    8000050e:	00002097          	auipc	ra,0x2
    80000512:	926080e7          	jalr	-1754(ra) # 80001e34 <trapinithart>
    plicinit();      // set up interrupt controller
    80000516:	00005097          	auipc	ra,0x5
    8000051a:	0c4080e7          	jalr	196(ra) # 800055da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000051e:	00005097          	auipc	ra,0x5
    80000522:	0d6080e7          	jalr	214(ra) # 800055f4 <plicinithart>
    binit();         // buffer cache
    80000526:	00002097          	auipc	ra,0x2
    8000052a:	1a4080e7          	jalr	420(ra) # 800026ca <binit>
    iinit();         // inode table
    8000052e:	00003097          	auipc	ra,0x3
    80000532:	85a080e7          	jalr	-1958(ra) # 80002d88 <iinit>
    fileinit();      // file table
    80000536:	00004097          	auipc	ra,0x4
    8000053a:	80a080e7          	jalr	-2038(ra) # 80003d40 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000053e:	00005097          	auipc	ra,0x5
    80000542:	1be080e7          	jalr	446(ra) # 800056fc <virtio_disk_init>
    userinit();      // first user process
    80000546:	00001097          	auipc	ra,0x1
    8000054a:	f26080e7          	jalr	-218(ra) # 8000146c <userinit>
    __sync_synchronize();
    8000054e:	0ff0000f          	fence
    started = 1;
    80000552:	4785                	li	a5,1
    80000554:	00008717          	auipc	a4,0x8
    80000558:	3af72e23          	sw	a5,956(a4) # 80008910 <started>
    8000055c:	b789                	j	8000049e <main+0x56>

000000008000055e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000055e:	1141                	addi	sp,sp,-16
    80000560:	e422                	sd	s0,8(sp)
    80000562:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000564:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000568:	00008797          	auipc	a5,0x8
    8000056c:	3b07b783          	ld	a5,944(a5) # 80008918 <kernel_pagetable>
    80000570:	83b1                	srli	a5,a5,0xc
    80000572:	577d                	li	a4,-1
    80000574:	177e                	slli	a4,a4,0x3f
    80000576:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000578:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000057c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000580:	6422                	ld	s0,8(sp)
    80000582:	0141                	addi	sp,sp,16
    80000584:	8082                	ret

0000000080000586 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000586:	7139                	addi	sp,sp,-64
    80000588:	fc06                	sd	ra,56(sp)
    8000058a:	f822                	sd	s0,48(sp)
    8000058c:	f426                	sd	s1,40(sp)
    8000058e:	f04a                	sd	s2,32(sp)
    80000590:	ec4e                	sd	s3,24(sp)
    80000592:	e852                	sd	s4,16(sp)
    80000594:	e456                	sd	s5,8(sp)
    80000596:	e05a                	sd	s6,0(sp)
    80000598:	0080                	addi	s0,sp,64
    8000059a:	84aa                	mv	s1,a0
    8000059c:	89ae                	mv	s3,a1
    8000059e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800005a0:	57fd                	li	a5,-1
    800005a2:	83e9                	srli	a5,a5,0x1a
    800005a4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800005a6:	4b31                	li	s6,12
  if(va >= MAXVA)
    800005a8:	04b7f263          	bgeu	a5,a1,800005ec <walk+0x66>
    panic("walk");
    800005ac:	00008517          	auipc	a0,0x8
    800005b0:	aac50513          	addi	a0,a0,-1364 # 80008058 <etext+0x58>
    800005b4:	00006097          	auipc	ra,0x6
    800005b8:	b9e080e7          	jalr	-1122(ra) # 80006152 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005bc:	060a8663          	beqz	s5,80000628 <walk+0xa2>
    800005c0:	00000097          	auipc	ra,0x0
    800005c4:	bc0080e7          	jalr	-1088(ra) # 80000180 <kalloc>
    800005c8:	84aa                	mv	s1,a0
    800005ca:	c529                	beqz	a0,80000614 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005cc:	6605                	lui	a2,0x1
    800005ce:	4581                	li	a1,0
    800005d0:	00000097          	auipc	ra,0x0
    800005d4:	cda080e7          	jalr	-806(ra) # 800002aa <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005d8:	00c4d793          	srli	a5,s1,0xc
    800005dc:	07aa                	slli	a5,a5,0xa
    800005de:	0017e793          	ori	a5,a5,1
    800005e2:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005e6:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7fdbd227>
    800005e8:	036a0063          	beq	s4,s6,80000608 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005ec:	0149d933          	srl	s2,s3,s4
    800005f0:	1ff97913          	andi	s2,s2,511
    800005f4:	090e                	slli	s2,s2,0x3
    800005f6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005f8:	00093483          	ld	s1,0(s2)
    800005fc:	0014f793          	andi	a5,s1,1
    80000600:	dfd5                	beqz	a5,800005bc <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000602:	80a9                	srli	s1,s1,0xa
    80000604:	04b2                	slli	s1,s1,0xc
    80000606:	b7c5                	j	800005e6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000608:	00c9d513          	srli	a0,s3,0xc
    8000060c:	1ff57513          	andi	a0,a0,511
    80000610:	050e                	slli	a0,a0,0x3
    80000612:	9526                	add	a0,a0,s1
}
    80000614:	70e2                	ld	ra,56(sp)
    80000616:	7442                	ld	s0,48(sp)
    80000618:	74a2                	ld	s1,40(sp)
    8000061a:	7902                	ld	s2,32(sp)
    8000061c:	69e2                	ld	s3,24(sp)
    8000061e:	6a42                	ld	s4,16(sp)
    80000620:	6aa2                	ld	s5,8(sp)
    80000622:	6b02                	ld	s6,0(sp)
    80000624:	6121                	addi	sp,sp,64
    80000626:	8082                	ret
        return 0;
    80000628:	4501                	li	a0,0
    8000062a:	b7ed                	j	80000614 <walk+0x8e>

000000008000062c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000062c:	57fd                	li	a5,-1
    8000062e:	83e9                	srli	a5,a5,0x1a
    80000630:	00b7f463          	bgeu	a5,a1,80000638 <walkaddr+0xc>
    return 0;
    80000634:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000636:	8082                	ret
{
    80000638:	1141                	addi	sp,sp,-16
    8000063a:	e406                	sd	ra,8(sp)
    8000063c:	e022                	sd	s0,0(sp)
    8000063e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000640:	4601                	li	a2,0
    80000642:	00000097          	auipc	ra,0x0
    80000646:	f44080e7          	jalr	-188(ra) # 80000586 <walk>
  if(pte == 0)
    8000064a:	c105                	beqz	a0,8000066a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000064c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000064e:	0117f693          	andi	a3,a5,17
    80000652:	4745                	li	a4,17
    return 0;
    80000654:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000656:	00e68663          	beq	a3,a4,80000662 <walkaddr+0x36>
}
    8000065a:	60a2                	ld	ra,8(sp)
    8000065c:	6402                	ld	s0,0(sp)
    8000065e:	0141                	addi	sp,sp,16
    80000660:	8082                	ret
  pa = PTE2PA(*pte);
    80000662:	83a9                	srli	a5,a5,0xa
    80000664:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000668:	bfcd                	j	8000065a <walkaddr+0x2e>
    return 0;
    8000066a:	4501                	li	a0,0
    8000066c:	b7fd                	j	8000065a <walkaddr+0x2e>

000000008000066e <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000066e:	715d                	addi	sp,sp,-80
    80000670:	e486                	sd	ra,72(sp)
    80000672:	e0a2                	sd	s0,64(sp)
    80000674:	fc26                	sd	s1,56(sp)
    80000676:	f84a                	sd	s2,48(sp)
    80000678:	f44e                	sd	s3,40(sp)
    8000067a:	f052                	sd	s4,32(sp)
    8000067c:	ec56                	sd	s5,24(sp)
    8000067e:	e85a                	sd	s6,16(sp)
    80000680:	e45e                	sd	s7,8(sp)
    80000682:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000684:	03459793          	slli	a5,a1,0x34
    80000688:	e7b9                	bnez	a5,800006d6 <mappages+0x68>
    8000068a:	8aaa                	mv	s5,a0
    8000068c:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000068e:	03461793          	slli	a5,a2,0x34
    80000692:	ebb1                	bnez	a5,800006e6 <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    80000694:	c22d                	beqz	a2,800006f6 <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000696:	77fd                	lui	a5,0xfffff
    80000698:	963e                	add	a2,a2,a5
    8000069a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000069e:	892e                	mv	s2,a1
    800006a0:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800006a4:	6b85                	lui	s7,0x1
    800006a6:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800006aa:	4605                	li	a2,1
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8556                	mv	a0,s5
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	ed6080e7          	jalr	-298(ra) # 80000586 <walk>
    800006b8:	cd39                	beqz	a0,80000716 <mappages+0xa8>
    if(*pte & PTE_V)
    800006ba:	611c                	ld	a5,0(a0)
    800006bc:	8b85                	andi	a5,a5,1
    800006be:	e7a1                	bnez	a5,80000706 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006c0:	80b1                	srli	s1,s1,0xc
    800006c2:	04aa                	slli	s1,s1,0xa
    800006c4:	0164e4b3          	or	s1,s1,s6
    800006c8:	0014e493          	ori	s1,s1,1
    800006cc:	e104                	sd	s1,0(a0)
    if(a == last)
    800006ce:	07390063          	beq	s2,s3,8000072e <mappages+0xc0>
    a += PGSIZE;
    800006d2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800006d4:	bfc9                	j	800006a6 <mappages+0x38>
    panic("mappages: va not aligned");
    800006d6:	00008517          	auipc	a0,0x8
    800006da:	98a50513          	addi	a0,a0,-1654 # 80008060 <etext+0x60>
    800006de:	00006097          	auipc	ra,0x6
    800006e2:	a74080e7          	jalr	-1420(ra) # 80006152 <panic>
    panic("mappages: size not aligned");
    800006e6:	00008517          	auipc	a0,0x8
    800006ea:	99a50513          	addi	a0,a0,-1638 # 80008080 <etext+0x80>
    800006ee:	00006097          	auipc	ra,0x6
    800006f2:	a64080e7          	jalr	-1436(ra) # 80006152 <panic>
    panic("mappages: size");
    800006f6:	00008517          	auipc	a0,0x8
    800006fa:	9aa50513          	addi	a0,a0,-1622 # 800080a0 <etext+0xa0>
    800006fe:	00006097          	auipc	ra,0x6
    80000702:	a54080e7          	jalr	-1452(ra) # 80006152 <panic>
      panic("mappages: remap");
    80000706:	00008517          	auipc	a0,0x8
    8000070a:	9aa50513          	addi	a0,a0,-1622 # 800080b0 <etext+0xb0>
    8000070e:	00006097          	auipc	ra,0x6
    80000712:	a44080e7          	jalr	-1468(ra) # 80006152 <panic>
      return -1;
    80000716:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000718:	60a6                	ld	ra,72(sp)
    8000071a:	6406                	ld	s0,64(sp)
    8000071c:	74e2                	ld	s1,56(sp)
    8000071e:	7942                	ld	s2,48(sp)
    80000720:	79a2                	ld	s3,40(sp)
    80000722:	7a02                	ld	s4,32(sp)
    80000724:	6ae2                	ld	s5,24(sp)
    80000726:	6b42                	ld	s6,16(sp)
    80000728:	6ba2                	ld	s7,8(sp)
    8000072a:	6161                	addi	sp,sp,80
    8000072c:	8082                	ret
  return 0;
    8000072e:	4501                	li	a0,0
    80000730:	b7e5                	j	80000718 <mappages+0xaa>

0000000080000732 <kvmmap>:
{
    80000732:	1141                	addi	sp,sp,-16
    80000734:	e406                	sd	ra,8(sp)
    80000736:	e022                	sd	s0,0(sp)
    80000738:	0800                	addi	s0,sp,16
    8000073a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000073c:	86b2                	mv	a3,a2
    8000073e:	863e                	mv	a2,a5
    80000740:	00000097          	auipc	ra,0x0
    80000744:	f2e080e7          	jalr	-210(ra) # 8000066e <mappages>
    80000748:	e509                	bnez	a0,80000752 <kvmmap+0x20>
}
    8000074a:	60a2                	ld	ra,8(sp)
    8000074c:	6402                	ld	s0,0(sp)
    8000074e:	0141                	addi	sp,sp,16
    80000750:	8082                	ret
    panic("kvmmap");
    80000752:	00008517          	auipc	a0,0x8
    80000756:	96e50513          	addi	a0,a0,-1682 # 800080c0 <etext+0xc0>
    8000075a:	00006097          	auipc	ra,0x6
    8000075e:	9f8080e7          	jalr	-1544(ra) # 80006152 <panic>

0000000080000762 <kvmmake>:
{
    80000762:	1101                	addi	sp,sp,-32
    80000764:	ec06                	sd	ra,24(sp)
    80000766:	e822                	sd	s0,16(sp)
    80000768:	e426                	sd	s1,8(sp)
    8000076a:	e04a                	sd	s2,0(sp)
    8000076c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000076e:	00000097          	auipc	ra,0x0
    80000772:	a12080e7          	jalr	-1518(ra) # 80000180 <kalloc>
    80000776:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000778:	6605                	lui	a2,0x1
    8000077a:	4581                	li	a1,0
    8000077c:	00000097          	auipc	ra,0x0
    80000780:	b2e080e7          	jalr	-1234(ra) # 800002aa <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000784:	4719                	li	a4,6
    80000786:	6685                	lui	a3,0x1
    80000788:	10000637          	lui	a2,0x10000
    8000078c:	100005b7          	lui	a1,0x10000
    80000790:	8526                	mv	a0,s1
    80000792:	00000097          	auipc	ra,0x0
    80000796:	fa0080e7          	jalr	-96(ra) # 80000732 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000079a:	4719                	li	a4,6
    8000079c:	6685                	lui	a3,0x1
    8000079e:	10001637          	lui	a2,0x10001
    800007a2:	100015b7          	lui	a1,0x10001
    800007a6:	8526                	mv	a0,s1
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	f8a080e7          	jalr	-118(ra) # 80000732 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800007b0:	4719                	li	a4,6
    800007b2:	004006b7          	lui	a3,0x400
    800007b6:	0c000637          	lui	a2,0xc000
    800007ba:	0c0005b7          	lui	a1,0xc000
    800007be:	8526                	mv	a0,s1
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	f72080e7          	jalr	-142(ra) # 80000732 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800007c8:	00008917          	auipc	s2,0x8
    800007cc:	83890913          	addi	s2,s2,-1992 # 80008000 <etext>
    800007d0:	4729                	li	a4,10
    800007d2:	80008697          	auipc	a3,0x80008
    800007d6:	82e68693          	addi	a3,a3,-2002 # 8000 <_entry-0x7fff8000>
    800007da:	4605                	li	a2,1
    800007dc:	067e                	slli	a2,a2,0x1f
    800007de:	85b2                	mv	a1,a2
    800007e0:	8526                	mv	a0,s1
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	f50080e7          	jalr	-176(ra) # 80000732 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007ea:	46c5                	li	a3,17
    800007ec:	06ee                	slli	a3,a3,0x1b
    800007ee:	4719                	li	a4,6
    800007f0:	412686b3          	sub	a3,a3,s2
    800007f4:	864a                	mv	a2,s2
    800007f6:	85ca                	mv	a1,s2
    800007f8:	8526                	mv	a0,s1
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	f38080e7          	jalr	-200(ra) # 80000732 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000802:	4729                	li	a4,10
    80000804:	6685                	lui	a3,0x1
    80000806:	00006617          	auipc	a2,0x6
    8000080a:	7fa60613          	addi	a2,a2,2042 # 80007000 <_trampoline>
    8000080e:	040005b7          	lui	a1,0x4000
    80000812:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000814:	05b2                	slli	a1,a1,0xc
    80000816:	8526                	mv	a0,s1
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	f1a080e7          	jalr	-230(ra) # 80000732 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000820:	8526                	mv	a0,s1
    80000822:	00000097          	auipc	ra,0x0
    80000826:	7dc080e7          	jalr	2012(ra) # 80000ffe <proc_mapstacks>
}
    8000082a:	8526                	mv	a0,s1
    8000082c:	60e2                	ld	ra,24(sp)
    8000082e:	6442                	ld	s0,16(sp)
    80000830:	64a2                	ld	s1,8(sp)
    80000832:	6902                	ld	s2,0(sp)
    80000834:	6105                	addi	sp,sp,32
    80000836:	8082                	ret

0000000080000838 <kvminit>:
{
    80000838:	1141                	addi	sp,sp,-16
    8000083a:	e406                	sd	ra,8(sp)
    8000083c:	e022                	sd	s0,0(sp)
    8000083e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000840:	00000097          	auipc	ra,0x0
    80000844:	f22080e7          	jalr	-222(ra) # 80000762 <kvmmake>
    80000848:	00008797          	auipc	a5,0x8
    8000084c:	0ca7b823          	sd	a0,208(a5) # 80008918 <kernel_pagetable>
}
    80000850:	60a2                	ld	ra,8(sp)
    80000852:	6402                	ld	s0,0(sp)
    80000854:	0141                	addi	sp,sp,16
    80000856:	8082                	ret

0000000080000858 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000858:	715d                	addi	sp,sp,-80
    8000085a:	e486                	sd	ra,72(sp)
    8000085c:	e0a2                	sd	s0,64(sp)
    8000085e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000860:	03459793          	slli	a5,a1,0x34
    80000864:	e39d                	bnez	a5,8000088a <uvmunmap+0x32>
    80000866:	f84a                	sd	s2,48(sp)
    80000868:	f44e                	sd	s3,40(sp)
    8000086a:	f052                	sd	s4,32(sp)
    8000086c:	ec56                	sd	s5,24(sp)
    8000086e:	e85a                	sd	s6,16(sp)
    80000870:	e45e                	sd	s7,8(sp)
    80000872:	8a2a                	mv	s4,a0
    80000874:	892e                	mv	s2,a1
    80000876:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000878:	0632                	slli	a2,a2,0xc
    8000087a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000087e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000880:	6b05                	lui	s6,0x1
    80000882:	0935fb63          	bgeu	a1,s3,80000918 <uvmunmap+0xc0>
    80000886:	fc26                	sd	s1,56(sp)
    80000888:	a8a9                	j	800008e2 <uvmunmap+0x8a>
    8000088a:	fc26                	sd	s1,56(sp)
    8000088c:	f84a                	sd	s2,48(sp)
    8000088e:	f44e                	sd	s3,40(sp)
    80000890:	f052                	sd	s4,32(sp)
    80000892:	ec56                	sd	s5,24(sp)
    80000894:	e85a                	sd	s6,16(sp)
    80000896:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000898:	00008517          	auipc	a0,0x8
    8000089c:	83050513          	addi	a0,a0,-2000 # 800080c8 <etext+0xc8>
    800008a0:	00006097          	auipc	ra,0x6
    800008a4:	8b2080e7          	jalr	-1870(ra) # 80006152 <panic>
      panic("uvmunmap: walk");
    800008a8:	00008517          	auipc	a0,0x8
    800008ac:	83850513          	addi	a0,a0,-1992 # 800080e0 <etext+0xe0>
    800008b0:	00006097          	auipc	ra,0x6
    800008b4:	8a2080e7          	jalr	-1886(ra) # 80006152 <panic>
      panic("uvmunmap: not mapped");
    800008b8:	00008517          	auipc	a0,0x8
    800008bc:	83850513          	addi	a0,a0,-1992 # 800080f0 <etext+0xf0>
    800008c0:	00006097          	auipc	ra,0x6
    800008c4:	892080e7          	jalr	-1902(ra) # 80006152 <panic>
      panic("uvmunmap: not a leaf");
    800008c8:	00008517          	auipc	a0,0x8
    800008cc:	84050513          	addi	a0,a0,-1984 # 80008108 <etext+0x108>
    800008d0:	00006097          	auipc	ra,0x6
    800008d4:	882080e7          	jalr	-1918(ra) # 80006152 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800008d8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008dc:	995a                	add	s2,s2,s6
    800008de:	03397c63          	bgeu	s2,s3,80000916 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008e2:	4601                	li	a2,0
    800008e4:	85ca                	mv	a1,s2
    800008e6:	8552                	mv	a0,s4
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	c9e080e7          	jalr	-866(ra) # 80000586 <walk>
    800008f0:	84aa                	mv	s1,a0
    800008f2:	d95d                	beqz	a0,800008a8 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800008f4:	6108                	ld	a0,0(a0)
    800008f6:	00157793          	andi	a5,a0,1
    800008fa:	dfdd                	beqz	a5,800008b8 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008fc:	3ff57793          	andi	a5,a0,1023
    80000900:	fd7784e3          	beq	a5,s7,800008c8 <uvmunmap+0x70>
    if(do_free){
    80000904:	fc0a8ae3          	beqz	s5,800008d8 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80000908:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000090a:	0532                	slli	a0,a0,0xc
    8000090c:	fffff097          	auipc	ra,0xfffff
    80000910:	710080e7          	jalr	1808(ra) # 8000001c <kfree>
    80000914:	b7d1                	j	800008d8 <uvmunmap+0x80>
    80000916:	74e2                	ld	s1,56(sp)
    80000918:	7942                	ld	s2,48(sp)
    8000091a:	79a2                	ld	s3,40(sp)
    8000091c:	7a02                	ld	s4,32(sp)
    8000091e:	6ae2                	ld	s5,24(sp)
    80000920:	6b42                	ld	s6,16(sp)
    80000922:	6ba2                	ld	s7,8(sp)
  }
}
    80000924:	60a6                	ld	ra,72(sp)
    80000926:	6406                	ld	s0,64(sp)
    80000928:	6161                	addi	sp,sp,80
    8000092a:	8082                	ret

000000008000092c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000092c:	1101                	addi	sp,sp,-32
    8000092e:	ec06                	sd	ra,24(sp)
    80000930:	e822                	sd	s0,16(sp)
    80000932:	e426                	sd	s1,8(sp)
    80000934:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	84a080e7          	jalr	-1974(ra) # 80000180 <kalloc>
    8000093e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000940:	c519                	beqz	a0,8000094e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000942:	6605                	lui	a2,0x1
    80000944:	4581                	li	a1,0
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	964080e7          	jalr	-1692(ra) # 800002aa <memset>
  return pagetable;
}
    8000094e:	8526                	mv	a0,s1
    80000950:	60e2                	ld	ra,24(sp)
    80000952:	6442                	ld	s0,16(sp)
    80000954:	64a2                	ld	s1,8(sp)
    80000956:	6105                	addi	sp,sp,32
    80000958:	8082                	ret

000000008000095a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000095a:	7179                	addi	sp,sp,-48
    8000095c:	f406                	sd	ra,40(sp)
    8000095e:	f022                	sd	s0,32(sp)
    80000960:	ec26                	sd	s1,24(sp)
    80000962:	e84a                	sd	s2,16(sp)
    80000964:	e44e                	sd	s3,8(sp)
    80000966:	e052                	sd	s4,0(sp)
    80000968:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000096a:	6785                	lui	a5,0x1
    8000096c:	04f67863          	bgeu	a2,a5,800009bc <uvmfirst+0x62>
    80000970:	8a2a                	mv	s4,a0
    80000972:	89ae                	mv	s3,a1
    80000974:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000976:	00000097          	auipc	ra,0x0
    8000097a:	80a080e7          	jalr	-2038(ra) # 80000180 <kalloc>
    8000097e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000980:	6605                	lui	a2,0x1
    80000982:	4581                	li	a1,0
    80000984:	00000097          	auipc	ra,0x0
    80000988:	926080e7          	jalr	-1754(ra) # 800002aa <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000098c:	4779                	li	a4,30
    8000098e:	86ca                	mv	a3,s2
    80000990:	6605                	lui	a2,0x1
    80000992:	4581                	li	a1,0
    80000994:	8552                	mv	a0,s4
    80000996:	00000097          	auipc	ra,0x0
    8000099a:	cd8080e7          	jalr	-808(ra) # 8000066e <mappages>
  memmove(mem, src, sz);
    8000099e:	8626                	mv	a2,s1
    800009a0:	85ce                	mv	a1,s3
    800009a2:	854a                	mv	a0,s2
    800009a4:	00000097          	auipc	ra,0x0
    800009a8:	962080e7          	jalr	-1694(ra) # 80000306 <memmove>
}
    800009ac:	70a2                	ld	ra,40(sp)
    800009ae:	7402                	ld	s0,32(sp)
    800009b0:	64e2                	ld	s1,24(sp)
    800009b2:	6942                	ld	s2,16(sp)
    800009b4:	69a2                	ld	s3,8(sp)
    800009b6:	6a02                	ld	s4,0(sp)
    800009b8:	6145                	addi	sp,sp,48
    800009ba:	8082                	ret
    panic("uvmfirst: more than a page");
    800009bc:	00007517          	auipc	a0,0x7
    800009c0:	76450513          	addi	a0,a0,1892 # 80008120 <etext+0x120>
    800009c4:	00005097          	auipc	ra,0x5
    800009c8:	78e080e7          	jalr	1934(ra) # 80006152 <panic>

00000000800009cc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800009cc:	1101                	addi	sp,sp,-32
    800009ce:	ec06                	sd	ra,24(sp)
    800009d0:	e822                	sd	s0,16(sp)
    800009d2:	e426                	sd	s1,8(sp)
    800009d4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800009d6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800009d8:	00b67d63          	bgeu	a2,a1,800009f2 <uvmdealloc+0x26>
    800009dc:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800009de:	6785                	lui	a5,0x1
    800009e0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009e2:	00f60733          	add	a4,a2,a5
    800009e6:	76fd                	lui	a3,0xfffff
    800009e8:	8f75                	and	a4,a4,a3
    800009ea:	97ae                	add	a5,a5,a1
    800009ec:	8ff5                	and	a5,a5,a3
    800009ee:	00f76863          	bltu	a4,a5,800009fe <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009f2:	8526                	mv	a0,s1
    800009f4:	60e2                	ld	ra,24(sp)
    800009f6:	6442                	ld	s0,16(sp)
    800009f8:	64a2                	ld	s1,8(sp)
    800009fa:	6105                	addi	sp,sp,32
    800009fc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009fe:	8f99                	sub	a5,a5,a4
    80000a00:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a02:	4685                	li	a3,1
    80000a04:	0007861b          	sext.w	a2,a5
    80000a08:	85ba                	mv	a1,a4
    80000a0a:	00000097          	auipc	ra,0x0
    80000a0e:	e4e080e7          	jalr	-434(ra) # 80000858 <uvmunmap>
    80000a12:	b7c5                	j	800009f2 <uvmdealloc+0x26>

0000000080000a14 <uvmalloc>:
  if(newsz < oldsz)
    80000a14:	0ab66b63          	bltu	a2,a1,80000aca <uvmalloc+0xb6>
{
    80000a18:	7139                	addi	sp,sp,-64
    80000a1a:	fc06                	sd	ra,56(sp)
    80000a1c:	f822                	sd	s0,48(sp)
    80000a1e:	ec4e                	sd	s3,24(sp)
    80000a20:	e852                	sd	s4,16(sp)
    80000a22:	e456                	sd	s5,8(sp)
    80000a24:	0080                	addi	s0,sp,64
    80000a26:	8aaa                	mv	s5,a0
    80000a28:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a2a:	6785                	lui	a5,0x1
    80000a2c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a2e:	95be                	add	a1,a1,a5
    80000a30:	77fd                	lui	a5,0xfffff
    80000a32:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a36:	08c9fc63          	bgeu	s3,a2,80000ace <uvmalloc+0xba>
    80000a3a:	f426                	sd	s1,40(sp)
    80000a3c:	f04a                	sd	s2,32(sp)
    80000a3e:	e05a                	sd	s6,0(sp)
    80000a40:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000a42:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000a46:	fffff097          	auipc	ra,0xfffff
    80000a4a:	73a080e7          	jalr	1850(ra) # 80000180 <kalloc>
    80000a4e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a50:	c915                	beqz	a0,80000a84 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    80000a52:	6605                	lui	a2,0x1
    80000a54:	4581                	li	a1,0
    80000a56:	00000097          	auipc	ra,0x0
    80000a5a:	854080e7          	jalr	-1964(ra) # 800002aa <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000a5e:	875a                	mv	a4,s6
    80000a60:	86a6                	mv	a3,s1
    80000a62:	6605                	lui	a2,0x1
    80000a64:	85ca                	mv	a1,s2
    80000a66:	8556                	mv	a0,s5
    80000a68:	00000097          	auipc	ra,0x0
    80000a6c:	c06080e7          	jalr	-1018(ra) # 8000066e <mappages>
    80000a70:	ed05                	bnez	a0,80000aa8 <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a72:	6785                	lui	a5,0x1
    80000a74:	993e                	add	s2,s2,a5
    80000a76:	fd4968e3          	bltu	s2,s4,80000a46 <uvmalloc+0x32>
  return newsz;
    80000a7a:	8552                	mv	a0,s4
    80000a7c:	74a2                	ld	s1,40(sp)
    80000a7e:	7902                	ld	s2,32(sp)
    80000a80:	6b02                	ld	s6,0(sp)
    80000a82:	a821                	j	80000a9a <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80000a84:	864e                	mv	a2,s3
    80000a86:	85ca                	mv	a1,s2
    80000a88:	8556                	mv	a0,s5
    80000a8a:	00000097          	auipc	ra,0x0
    80000a8e:	f42080e7          	jalr	-190(ra) # 800009cc <uvmdealloc>
      return 0;
    80000a92:	4501                	li	a0,0
    80000a94:	74a2                	ld	s1,40(sp)
    80000a96:	7902                	ld	s2,32(sp)
    80000a98:	6b02                	ld	s6,0(sp)
}
    80000a9a:	70e2                	ld	ra,56(sp)
    80000a9c:	7442                	ld	s0,48(sp)
    80000a9e:	69e2                	ld	s3,24(sp)
    80000aa0:	6a42                	ld	s4,16(sp)
    80000aa2:	6aa2                	ld	s5,8(sp)
    80000aa4:	6121                	addi	sp,sp,64
    80000aa6:	8082                	ret
      kfree(mem);
    80000aa8:	8526                	mv	a0,s1
    80000aaa:	fffff097          	auipc	ra,0xfffff
    80000aae:	572080e7          	jalr	1394(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000ab2:	864e                	mv	a2,s3
    80000ab4:	85ca                	mv	a1,s2
    80000ab6:	8556                	mv	a0,s5
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	f14080e7          	jalr	-236(ra) # 800009cc <uvmdealloc>
      return 0;
    80000ac0:	4501                	li	a0,0
    80000ac2:	74a2                	ld	s1,40(sp)
    80000ac4:	7902                	ld	s2,32(sp)
    80000ac6:	6b02                	ld	s6,0(sp)
    80000ac8:	bfc9                	j	80000a9a <uvmalloc+0x86>
    return oldsz;
    80000aca:	852e                	mv	a0,a1
}
    80000acc:	8082                	ret
  return newsz;
    80000ace:	8532                	mv	a0,a2
    80000ad0:	b7e9                	j	80000a9a <uvmalloc+0x86>

0000000080000ad2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000ad2:	7179                	addi	sp,sp,-48
    80000ad4:	f406                	sd	ra,40(sp)
    80000ad6:	f022                	sd	s0,32(sp)
    80000ad8:	ec26                	sd	s1,24(sp)
    80000ada:	e84a                	sd	s2,16(sp)
    80000adc:	e44e                	sd	s3,8(sp)
    80000ade:	e052                	sd	s4,0(sp)
    80000ae0:	1800                	addi	s0,sp,48
    80000ae2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000ae4:	84aa                	mv	s1,a0
    80000ae6:	6905                	lui	s2,0x1
    80000ae8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000aea:	4985                	li	s3,1
    80000aec:	a829                	j	80000b06 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000aee:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000af0:	00c79513          	slli	a0,a5,0xc
    80000af4:	00000097          	auipc	ra,0x0
    80000af8:	fde080e7          	jalr	-34(ra) # 80000ad2 <freewalk>
      pagetable[i] = 0;
    80000afc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000b00:	04a1                	addi	s1,s1,8
    80000b02:	03248163          	beq	s1,s2,80000b24 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000b06:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b08:	00f7f713          	andi	a4,a5,15
    80000b0c:	ff3701e3          	beq	a4,s3,80000aee <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000b10:	8b85                	andi	a5,a5,1
    80000b12:	d7fd                	beqz	a5,80000b00 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000b14:	00007517          	auipc	a0,0x7
    80000b18:	62c50513          	addi	a0,a0,1580 # 80008140 <etext+0x140>
    80000b1c:	00005097          	auipc	ra,0x5
    80000b20:	636080e7          	jalr	1590(ra) # 80006152 <panic>
    }
  }
  kfree((void*)pagetable);
    80000b24:	8552                	mv	a0,s4
    80000b26:	fffff097          	auipc	ra,0xfffff
    80000b2a:	4f6080e7          	jalr	1270(ra) # 8000001c <kfree>
}
    80000b2e:	70a2                	ld	ra,40(sp)
    80000b30:	7402                	ld	s0,32(sp)
    80000b32:	64e2                	ld	s1,24(sp)
    80000b34:	6942                	ld	s2,16(sp)
    80000b36:	69a2                	ld	s3,8(sp)
    80000b38:	6a02                	ld	s4,0(sp)
    80000b3a:	6145                	addi	sp,sp,48
    80000b3c:	8082                	ret

0000000080000b3e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b3e:	1101                	addi	sp,sp,-32
    80000b40:	ec06                	sd	ra,24(sp)
    80000b42:	e822                	sd	s0,16(sp)
    80000b44:	e426                	sd	s1,8(sp)
    80000b46:	1000                	addi	s0,sp,32
    80000b48:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b4a:	e999                	bnez	a1,80000b60 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b4c:	8526                	mv	a0,s1
    80000b4e:	00000097          	auipc	ra,0x0
    80000b52:	f84080e7          	jalr	-124(ra) # 80000ad2 <freewalk>
}
    80000b56:	60e2                	ld	ra,24(sp)
    80000b58:	6442                	ld	s0,16(sp)
    80000b5a:	64a2                	ld	s1,8(sp)
    80000b5c:	6105                	addi	sp,sp,32
    80000b5e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b60:	6785                	lui	a5,0x1
    80000b62:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b64:	95be                	add	a1,a1,a5
    80000b66:	4685                	li	a3,1
    80000b68:	00c5d613          	srli	a2,a1,0xc
    80000b6c:	4581                	li	a1,0
    80000b6e:	00000097          	auipc	ra,0x0
    80000b72:	cea080e7          	jalr	-790(ra) # 80000858 <uvmunmap>
    80000b76:	bfd9                	j	80000b4c <uvmfree+0xe>

0000000080000b78 <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80000b78:	ce4d                	beqz	a2,80000c32 <uvmcopy+0xba>
{
    80000b7a:	7139                	addi	sp,sp,-64
    80000b7c:	fc06                	sd	ra,56(sp)
    80000b7e:	f822                	sd	s0,48(sp)
    80000b80:	f426                	sd	s1,40(sp)
    80000b82:	f04a                	sd	s2,32(sp)
    80000b84:	ec4e                	sd	s3,24(sp)
    80000b86:	e852                	sd	s4,16(sp)
    80000b88:	e456                	sd	s5,8(sp)
    80000b8a:	e05a                	sd	s6,0(sp)
    80000b8c:	0080                	addi	s0,sp,64
    80000b8e:	8aaa                	mv	s5,a0
    80000b90:	8a2e                	mv	s4,a1
    80000b92:	89b2                	mv	s3,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b94:	4901                	li	s2,0
    if((pte = walk(old, i, 0)) == 0)
    80000b96:	4601                	li	a2,0
    80000b98:	85ca                	mv	a1,s2
    80000b9a:	8556                	mv	a0,s5
    80000b9c:	00000097          	auipc	ra,0x0
    80000ba0:	9ea080e7          	jalr	-1558(ra) # 80000586 <walk>
    80000ba4:	c139                	beqz	a0,80000bea <uvmcopy+0x72>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000ba6:	611c                	ld	a5,0(a0)
    80000ba8:	0017f713          	andi	a4,a5,1
    80000bac:	c739                	beqz	a4,80000bfa <uvmcopy+0x82>
      panic("uvmcopy: page not present");

        pa = PTE2PA(*pte);
    80000bae:	00a7d713          	srli	a4,a5,0xa
        *pte = *pte & (~PTE_W);
    80000bb2:	9bed                	andi	a5,a5,-5
        *pte = *pte | PTE_COW;
    80000bb4:	1007e493          	ori	s1,a5,256
    80000bb8:	e104                	sd	s1,0(a0)

        flags = PTE_FLAGS(*pte);

        kcount(pa/PGSIZE);
    80000bba:	00c71b13          	slli	s6,a4,0xc
    80000bbe:	0007051b          	sext.w	a0,a4
    80000bc2:	fffff097          	auipc	ra,0xfffff
    80000bc6:	65a080e7          	jalr	1626(ra) # 8000021c <kcount>
    //}
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    80000bca:	3fb4f713          	andi	a4,s1,1019
    80000bce:	86da                	mv	a3,s6
    80000bd0:	6605                	lui	a2,0x1
    80000bd2:	85ca                	mv	a1,s2
    80000bd4:	8552                	mv	a0,s4
    80000bd6:	00000097          	auipc	ra,0x0
    80000bda:	a98080e7          	jalr	-1384(ra) # 8000066e <mappages>
    80000bde:	e515                	bnez	a0,80000c0a <uvmcopy+0x92>
  for(i = 0; i < sz; i += PGSIZE){
    80000be0:	6785                	lui	a5,0x1
    80000be2:	993e                	add	s2,s2,a5
    80000be4:	fb3969e3          	bltu	s2,s3,80000b96 <uvmcopy+0x1e>
    80000be8:	a81d                	j	80000c1e <uvmcopy+0xa6>
      panic("uvmcopy: pte should exist");
    80000bea:	00007517          	auipc	a0,0x7
    80000bee:	56650513          	addi	a0,a0,1382 # 80008150 <etext+0x150>
    80000bf2:	00005097          	auipc	ra,0x5
    80000bf6:	560080e7          	jalr	1376(ra) # 80006152 <panic>
      panic("uvmcopy: page not present");
    80000bfa:	00007517          	auipc	a0,0x7
    80000bfe:	57650513          	addi	a0,a0,1398 # 80008170 <etext+0x170>
    80000c02:	00005097          	auipc	ra,0x5
    80000c06:	550080e7          	jalr	1360(ra) # 80006152 <panic>
  
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c0a:	4685                	li	a3,1
    80000c0c:	00c95613          	srli	a2,s2,0xc
    80000c10:	4581                	li	a1,0
    80000c12:	8552                	mv	a0,s4
    80000c14:	00000097          	auipc	ra,0x0
    80000c18:	c44080e7          	jalr	-956(ra) # 80000858 <uvmunmap>
  return -1;
    80000c1c:	557d                	li	a0,-1
}
    80000c1e:	70e2                	ld	ra,56(sp)
    80000c20:	7442                	ld	s0,48(sp)
    80000c22:	74a2                	ld	s1,40(sp)
    80000c24:	7902                	ld	s2,32(sp)
    80000c26:	69e2                	ld	s3,24(sp)
    80000c28:	6a42                	ld	s4,16(sp)
    80000c2a:	6aa2                	ld	s5,8(sp)
    80000c2c:	6b02                	ld	s6,0(sp)
    80000c2e:	6121                	addi	sp,sp,64
    80000c30:	8082                	ret
  return 0;
    80000c32:	4501                	li	a0,0
}
    80000c34:	8082                	ret

0000000080000c36 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c36:	1141                	addi	sp,sp,-16
    80000c38:	e406                	sd	ra,8(sp)
    80000c3a:	e022                	sd	s0,0(sp)
    80000c3c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c3e:	4601                	li	a2,0
    80000c40:	00000097          	auipc	ra,0x0
    80000c44:	946080e7          	jalr	-1722(ra) # 80000586 <walk>
  if(pte == 0)
    80000c48:	c901                	beqz	a0,80000c58 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c4a:	611c                	ld	a5,0(a0)
    80000c4c:	9bbd                	andi	a5,a5,-17
    80000c4e:	e11c                	sd	a5,0(a0)
}
    80000c50:	60a2                	ld	ra,8(sp)
    80000c52:	6402                	ld	s0,0(sp)
    80000c54:	0141                	addi	sp,sp,16
    80000c56:	8082                	ret
    panic("uvmclear");
    80000c58:	00007517          	auipc	a0,0x7
    80000c5c:	53850513          	addi	a0,a0,1336 # 80008190 <etext+0x190>
    80000c60:	00005097          	auipc	ra,0x5
    80000c64:	4f2080e7          	jalr	1266(ra) # 80006152 <panic>

0000000080000c68 <cowalloc>:

int
cowalloc(pagetable_t pagetable, uint64 va)
{
  if(va >= MAXVA)
    80000c68:	57fd                	li	a5,-1
    80000c6a:	83e9                	srli	a5,a5,0x1a
    80000c6c:	10b7e863          	bltu	a5,a1,80000d7c <cowalloc+0x114>
{
    80000c70:	7139                	addi	sp,sp,-64
    80000c72:	fc06                	sd	ra,56(sp)
    80000c74:	f822                	sd	s0,48(sp)
    80000c76:	f426                	sd	s1,40(sp)
    80000c78:	f04a                	sd	s2,32(sp)
    80000c7a:	ec4e                	sd	s3,24(sp)
    80000c7c:	0080                	addi	s0,sp,64
    80000c7e:	89aa                	mv	s3,a0
    80000c80:	84ae                	mv	s1,a1
    return -1;

  uint64 pa, new_pa, va_rounded;
  int flags;

  pte_t *pte = walk(pagetable, va, 0);
    80000c82:	4601                	li	a2,0
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	902080e7          	jalr	-1790(ra) # 80000586 <walk>
    80000c8c:	892a                	mv	s2,a0

  if( pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    80000c8e:	c96d                	beqz	a0,80000d80 <cowalloc+0x118>
    80000c90:	e852                	sd	s4,16(sp)
    80000c92:	00053a03          	ld	s4,0(a0)
    80000c96:	011a7713          	andi	a4,s4,17
    80000c9a:	47c5                	li	a5,17
    80000c9c:	0ef71463          	bne	a4,a5,80000d84 <cowalloc+0x11c>

  flags = PTE_FLAGS(*pte);
  pa = PTE2PA(*pte);
  va_rounded = PGROUNDDOWN(va);
  // 不是 cow 页，且没有写权限，非法写入。
  if(!(*pte & PTE_COW) && !(*pte & PTE_W))
    80000ca0:	104a7793          	andi	a5,s4,260
    80000ca4:	c3fd                	beqz	a5,80000d8a <cowalloc+0x122>
    return -1;
  // 有写权限 or COW 位是0，该页不是COWpage
  if( (*pte & PTE_W) || !(*pte & PTE_COW))
    80000ca6:	10000713          	li	a4,256
    return 0;
    80000caa:	4501                	li	a0,0
  if( (*pte & PTE_W) || !(*pte & PTE_COW))
    80000cac:	00e78a63          	beq	a5,a4,80000cc0 <cowalloc+0x58>
    80000cb0:	6a42                	ld	s4,16(sp)
    *pte &= ~PTE_COW;
    return 0;
  }

  return -1;
}
    80000cb2:	70e2                	ld	ra,56(sp)
    80000cb4:	7442                	ld	s0,48(sp)
    80000cb6:	74a2                	ld	s1,40(sp)
    80000cb8:	7902                	ld	s2,32(sp)
    80000cba:	69e2                	ld	s3,24(sp)
    80000cbc:	6121                	addi	sp,sp,64
    80000cbe:	8082                	ret
    80000cc0:	e456                	sd	s5,8(sp)
    80000cc2:	e05a                	sd	s6,0(sp)
  pa = PTE2PA(*pte);
    80000cc4:	00aa5513          	srli	a0,s4,0xa
  if(knum(pa/PGSIZE) > 1){
    80000cc8:	00c51b13          	slli	s6,a0,0xc
    80000ccc:	00050a9b          	sext.w	s5,a0
    80000cd0:	8556                	mv	a0,s5
    80000cd2:	fffff097          	auipc	ra,0xfffff
    80000cd6:	592080e7          	jalr	1426(ra) # 80000264 <knum>
    80000cda:	4785                	li	a5,1
    80000cdc:	06a7db63          	bge	a5,a0,80000d52 <cowalloc+0xea>
    if((new_pa = (uint64) kalloc()) == 0) // 申请一个物理页。
    80000ce0:	fffff097          	auipc	ra,0xfffff
    80000ce4:	4a0080e7          	jalr	1184(ra) # 80000180 <kalloc>
    80000ce8:	892a                	mv	s2,a0
    80000cea:	c131                	beqz	a0,80000d2e <cowalloc+0xc6>
  va_rounded = PGROUNDDOWN(va);
    80000cec:	77fd                	lui	a5,0xfffff
    80000cee:	8cfd                	and	s1,s1,a5
    memmove((void *)new_pa, (const void *) pa, PGSIZE);  // 将原物理页中的内容复制到新物理页中。
    80000cf0:	6605                	lui	a2,0x1
    80000cf2:	85da                	mv	a1,s6
    80000cf4:	fffff097          	auipc	ra,0xfffff
    80000cf8:	612080e7          	jalr	1554(ra) # 80000306 <memmove>
    uvmunmap(pagetable, va_rounded, 1, 1);  // 解除虚拟页和物理页的映射关系。
    80000cfc:	4685                	li	a3,1
    80000cfe:	4605                	li	a2,1
    80000d00:	85a6                	mv	a1,s1
    80000d02:	854e                	mv	a0,s3
    80000d04:	00000097          	auipc	ra,0x0
    80000d08:	b54080e7          	jalr	-1196(ra) # 80000858 <uvmunmap>
    flags &= ~PTE_COW;  // 清除页表项中的 COW 位。
    80000d0c:	2ffa7713          	andi	a4,s4,767
    if(mappages(pagetable, va_rounded, PGSIZE, new_pa, flags) != 0){// 建立新的虚拟页和物理页的映射关系。
    80000d10:	00476713          	ori	a4,a4,4
    80000d14:	86ca                	mv	a3,s2
    80000d16:	6605                	lui	a2,0x1
    80000d18:	85a6                	mv	a1,s1
    80000d1a:	854e                	mv	a0,s3
    80000d1c:	00000097          	auipc	ra,0x0
    80000d20:	952080e7          	jalr	-1710(ra) # 8000066e <mappages>
    80000d24:	ed09                	bnez	a0,80000d3e <cowalloc+0xd6>
    80000d26:	6a42                	ld	s4,16(sp)
    80000d28:	6aa2                	ld	s5,8(sp)
    80000d2a:	6b02                	ld	s6,0(sp)
    80000d2c:	b759                	j	80000cb2 <cowalloc+0x4a>
      panic("cowalloc: kalloc");
    80000d2e:	00007517          	auipc	a0,0x7
    80000d32:	47250513          	addi	a0,a0,1138 # 800081a0 <etext+0x1a0>
    80000d36:	00005097          	auipc	ra,0x5
    80000d3a:	41c080e7          	jalr	1052(ra) # 80006152 <panic>
      kfree((void *)new_pa);
    80000d3e:	854a                	mv	a0,s2
    80000d40:	fffff097          	auipc	ra,0xfffff
    80000d44:	2dc080e7          	jalr	732(ra) # 8000001c <kfree>
      return -1;
    80000d48:	557d                	li	a0,-1
    80000d4a:	6a42                	ld	s4,16(sp)
    80000d4c:	6aa2                	ld	s5,8(sp)
    80000d4e:	6b02                	ld	s6,0(sp)
    80000d50:	b78d                	j	80000cb2 <cowalloc+0x4a>
  } else if(knum(pa/PGSIZE) == 1){
    80000d52:	8556                	mv	a0,s5
    80000d54:	fffff097          	auipc	ra,0xfffff
    80000d58:	510080e7          	jalr	1296(ra) # 80000264 <knum>
    80000d5c:	4785                	li	a5,1
    80000d5e:	02f51963          	bne	a0,a5,80000d90 <cowalloc+0x128>
    *pte &= ~PTE_COW;
    80000d62:	00093783          	ld	a5,0(s2) # 1000 <_entry-0x7ffff000>
    80000d66:	eff7f793          	andi	a5,a5,-257
    80000d6a:	0047e793          	ori	a5,a5,4
    80000d6e:	00f93023          	sd	a5,0(s2)
    return 0;
    80000d72:	4501                	li	a0,0
    80000d74:	6a42                	ld	s4,16(sp)
    80000d76:	6aa2                	ld	s5,8(sp)
    80000d78:	6b02                	ld	s6,0(sp)
    80000d7a:	bf25                	j	80000cb2 <cowalloc+0x4a>
    return -1;
    80000d7c:	557d                	li	a0,-1
}
    80000d7e:	8082                	ret
    return -1;
    80000d80:	557d                	li	a0,-1
    80000d82:	bf05                	j	80000cb2 <cowalloc+0x4a>
    80000d84:	557d                	li	a0,-1
    80000d86:	6a42                	ld	s4,16(sp)
    80000d88:	b72d                	j	80000cb2 <cowalloc+0x4a>
    return -1;
    80000d8a:	557d                	li	a0,-1
    80000d8c:	6a42                	ld	s4,16(sp)
    80000d8e:	b715                	j	80000cb2 <cowalloc+0x4a>
  return -1;
    80000d90:	557d                	li	a0,-1
    80000d92:	6a42                	ld	s4,16(sp)
    80000d94:	6aa2                	ld	s5,8(sp)
    80000d96:	6b02                	ld	s6,0(sp)
    80000d98:	bf29                	j	80000cb2 <cowalloc+0x4a>

0000000080000d9a <copyout>:
// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    80000d9a:	711d                	addi	sp,sp,-96
    80000d9c:	ec86                	sd	ra,88(sp)
    80000d9e:	e8a2                	sd	s0,80(sp)
    80000da0:	fc4e                	sd	s3,56(sp)
    80000da2:	f456                	sd	s5,40(sp)
    80000da4:	f05a                	sd	s6,32(sp)
    80000da6:	ec5e                	sd	s7,24(sp)
    80000da8:	1080                	addi	s0,sp,96
    80000daa:	8baa                	mv	s7,a0
    80000dac:	8aae                	mv	s5,a1
    80000dae:	8b32                	mv	s6,a2
    80000db0:	89b6                	mv	s3,a3
  uint64 n, va0, pa0;
  pte_t *pte;

  printf("Out\n");
    80000db2:	00007517          	auipc	a0,0x7
    80000db6:	40650513          	addi	a0,a0,1030 # 800081b8 <etext+0x1b8>
    80000dba:	00005097          	auipc	ra,0x5
    80000dbe:	3e2080e7          	jalr	994(ra) # 8000619c <printf>
  while(len > 0){
    80000dc2:	08098d63          	beqz	s3,80000e5c <copyout+0xc2>
    80000dc6:	e4a6                	sd	s1,72(sp)
    va0 = PGROUNDDOWN(dstva);
    80000dc8:	74fd                	lui	s1,0xfffff
    80000dca:	009af4b3          	and	s1,s5,s1
    if(va0 >= MAXVA) return -1;
    80000dce:	57fd                	li	a5,-1
    80000dd0:	83e9                	srli	a5,a5,0x1a
    80000dd2:	0897e763          	bltu	a5,s1,80000e60 <copyout+0xc6>
    80000dd6:	e0ca                	sd	s2,64(sp)
    80000dd8:	f852                	sd	s4,48(sp)
    80000dda:	e862                	sd	s8,16(sp)
    80000ddc:	e466                	sd	s9,8(sp)
    80000dde:	e06a                	sd	s10,0(sp)
    
      if(cowalloc(pagetable,va0) < 0){
          return -1;
      }
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000de0:	4cd5                	li	s9,21
    80000de2:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA) return -1;
    80000de4:	8c3e                	mv	s8,a5
    80000de6:	a035                	j	80000e12 <copyout+0x78>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000de8:	83a9                	srli	a5,a5,0xa
    80000dea:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000dec:	409a8533          	sub	a0,s5,s1
    80000df0:	0009061b          	sext.w	a2,s2
    80000df4:	85da                	mv	a1,s6
    80000df6:	953e                	add	a0,a0,a5
    80000df8:	fffff097          	auipc	ra,0xfffff
    80000dfc:	50e080e7          	jalr	1294(ra) # 80000306 <memmove>

    len -= n;
    80000e00:	412989b3          	sub	s3,s3,s2
    src += n;
    80000e04:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000e06:	04098363          	beqz	s3,80000e4c <copyout+0xb2>
    if(va0 >= MAXVA) return -1;
    80000e0a:	054c6e63          	bltu	s8,s4,80000e66 <copyout+0xcc>
    80000e0e:	84d2                	mv	s1,s4
    80000e10:	8ad2                	mv	s5,s4
      if(cowalloc(pagetable,va0) < 0){
    80000e12:	85a6                	mv	a1,s1
    80000e14:	855e                	mv	a0,s7
    80000e16:	00000097          	auipc	ra,0x0
    80000e1a:	e52080e7          	jalr	-430(ra) # 80000c68 <cowalloc>
    80000e1e:	04054c63          	bltz	a0,80000e76 <copyout+0xdc>
    pte = walk(pagetable, va0, 0);
    80000e22:	4601                	li	a2,0
    80000e24:	85a6                	mv	a1,s1
    80000e26:	855e                	mv	a0,s7
    80000e28:	fffff097          	auipc	ra,0xfffff
    80000e2c:	75e080e7          	jalr	1886(ra) # 80000586 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000e30:	c135                	beqz	a0,80000e94 <copyout+0xfa>
    80000e32:	611c                	ld	a5,0(a0)
    80000e34:	0157f713          	andi	a4,a5,21
    80000e38:	07971663          	bne	a4,s9,80000ea4 <copyout+0x10a>
    n = PGSIZE - (dstva - va0);
    80000e3c:	01a48a33          	add	s4,s1,s10
    80000e40:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000e44:	fb29f2e3          	bgeu	s3,s2,80000de8 <copyout+0x4e>
    80000e48:	894e                	mv	s2,s3
    80000e4a:	bf79                	j	80000de8 <copyout+0x4e>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000e4c:	4501                	li	a0,0
    80000e4e:	64a6                	ld	s1,72(sp)
    80000e50:	6906                	ld	s2,64(sp)
    80000e52:	7a42                	ld	s4,48(sp)
    80000e54:	6c42                	ld	s8,16(sp)
    80000e56:	6ca2                	ld	s9,8(sp)
    80000e58:	6d02                	ld	s10,0(sp)
    80000e5a:	a02d                	j	80000e84 <copyout+0xea>
    80000e5c:	4501                	li	a0,0
    80000e5e:	a01d                	j	80000e84 <copyout+0xea>
    if(va0 >= MAXVA) return -1;
    80000e60:	557d                	li	a0,-1
    80000e62:	64a6                	ld	s1,72(sp)
    80000e64:	a005                	j	80000e84 <copyout+0xea>
    80000e66:	557d                	li	a0,-1
    80000e68:	64a6                	ld	s1,72(sp)
    80000e6a:	6906                	ld	s2,64(sp)
    80000e6c:	7a42                	ld	s4,48(sp)
    80000e6e:	6c42                	ld	s8,16(sp)
    80000e70:	6ca2                	ld	s9,8(sp)
    80000e72:	6d02                	ld	s10,0(sp)
    80000e74:	a801                	j	80000e84 <copyout+0xea>
          return -1;
    80000e76:	557d                	li	a0,-1
    80000e78:	64a6                	ld	s1,72(sp)
    80000e7a:	6906                	ld	s2,64(sp)
    80000e7c:	7a42                	ld	s4,48(sp)
    80000e7e:	6c42                	ld	s8,16(sp)
    80000e80:	6ca2                	ld	s9,8(sp)
    80000e82:	6d02                	ld	s10,0(sp)
}
    80000e84:	60e6                	ld	ra,88(sp)
    80000e86:	6446                	ld	s0,80(sp)
    80000e88:	79e2                	ld	s3,56(sp)
    80000e8a:	7aa2                	ld	s5,40(sp)
    80000e8c:	7b02                	ld	s6,32(sp)
    80000e8e:	6be2                	ld	s7,24(sp)
    80000e90:	6125                	addi	sp,sp,96
    80000e92:	8082                	ret
      return -1;
    80000e94:	557d                	li	a0,-1
    80000e96:	64a6                	ld	s1,72(sp)
    80000e98:	6906                	ld	s2,64(sp)
    80000e9a:	7a42                	ld	s4,48(sp)
    80000e9c:	6c42                	ld	s8,16(sp)
    80000e9e:	6ca2                	ld	s9,8(sp)
    80000ea0:	6d02                	ld	s10,0(sp)
    80000ea2:	b7cd                	j	80000e84 <copyout+0xea>
    80000ea4:	557d                	li	a0,-1
    80000ea6:	64a6                	ld	s1,72(sp)
    80000ea8:	6906                	ld	s2,64(sp)
    80000eaa:	7a42                	ld	s4,48(sp)
    80000eac:	6c42                	ld	s8,16(sp)
    80000eae:	6ca2                	ld	s9,8(sp)
    80000eb0:	6d02                	ld	s10,0(sp)
    80000eb2:	bfc9                	j	80000e84 <copyout+0xea>

0000000080000eb4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000eb4:	caa5                	beqz	a3,80000f24 <copyin+0x70>
{
    80000eb6:	715d                	addi	sp,sp,-80
    80000eb8:	e486                	sd	ra,72(sp)
    80000eba:	e0a2                	sd	s0,64(sp)
    80000ebc:	fc26                	sd	s1,56(sp)
    80000ebe:	f84a                	sd	s2,48(sp)
    80000ec0:	f44e                	sd	s3,40(sp)
    80000ec2:	f052                	sd	s4,32(sp)
    80000ec4:	ec56                	sd	s5,24(sp)
    80000ec6:	e85a                	sd	s6,16(sp)
    80000ec8:	e45e                	sd	s7,8(sp)
    80000eca:	e062                	sd	s8,0(sp)
    80000ecc:	0880                	addi	s0,sp,80
    80000ece:	8b2a                	mv	s6,a0
    80000ed0:	8a2e                	mv	s4,a1
    80000ed2:	8c32                	mv	s8,a2
    80000ed4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ed6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ed8:	6a85                	lui	s5,0x1
    80000eda:	a01d                	j	80000f00 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000edc:	018505b3          	add	a1,a0,s8
    80000ee0:	0004861b          	sext.w	a2,s1
    80000ee4:	412585b3          	sub	a1,a1,s2
    80000ee8:	8552                	mv	a0,s4
    80000eea:	fffff097          	auipc	ra,0xfffff
    80000eee:	41c080e7          	jalr	1052(ra) # 80000306 <memmove>

    len -= n;
    80000ef2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000ef6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000ef8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000efc:	02098263          	beqz	s3,80000f20 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000f00:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000f04:	85ca                	mv	a1,s2
    80000f06:	855a                	mv	a0,s6
    80000f08:	fffff097          	auipc	ra,0xfffff
    80000f0c:	724080e7          	jalr	1828(ra) # 8000062c <walkaddr>
    if(pa0 == 0)
    80000f10:	cd01                	beqz	a0,80000f28 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000f12:	418904b3          	sub	s1,s2,s8
    80000f16:	94d6                	add	s1,s1,s5
    if(n > len)
    80000f18:	fc99f2e3          	bgeu	s3,s1,80000edc <copyin+0x28>
    80000f1c:	84ce                	mv	s1,s3
    80000f1e:	bf7d                	j	80000edc <copyin+0x28>
  }
  return 0;
    80000f20:	4501                	li	a0,0
    80000f22:	a021                	j	80000f2a <copyin+0x76>
    80000f24:	4501                	li	a0,0
}
    80000f26:	8082                	ret
      return -1;
    80000f28:	557d                	li	a0,-1
}
    80000f2a:	60a6                	ld	ra,72(sp)
    80000f2c:	6406                	ld	s0,64(sp)
    80000f2e:	74e2                	ld	s1,56(sp)
    80000f30:	7942                	ld	s2,48(sp)
    80000f32:	79a2                	ld	s3,40(sp)
    80000f34:	7a02                	ld	s4,32(sp)
    80000f36:	6ae2                	ld	s5,24(sp)
    80000f38:	6b42                	ld	s6,16(sp)
    80000f3a:	6ba2                	ld	s7,8(sp)
    80000f3c:	6c02                	ld	s8,0(sp)
    80000f3e:	6161                	addi	sp,sp,80
    80000f40:	8082                	ret

0000000080000f42 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000f42:	cacd                	beqz	a3,80000ff4 <copyinstr+0xb2>
{
    80000f44:	715d                	addi	sp,sp,-80
    80000f46:	e486                	sd	ra,72(sp)
    80000f48:	e0a2                	sd	s0,64(sp)
    80000f4a:	fc26                	sd	s1,56(sp)
    80000f4c:	f84a                	sd	s2,48(sp)
    80000f4e:	f44e                	sd	s3,40(sp)
    80000f50:	f052                	sd	s4,32(sp)
    80000f52:	ec56                	sd	s5,24(sp)
    80000f54:	e85a                	sd	s6,16(sp)
    80000f56:	e45e                	sd	s7,8(sp)
    80000f58:	0880                	addi	s0,sp,80
    80000f5a:	8a2a                	mv	s4,a0
    80000f5c:	8b2e                	mv	s6,a1
    80000f5e:	8bb2                	mv	s7,a2
    80000f60:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000f62:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000f64:	6985                	lui	s3,0x1
    80000f66:	a825                	j	80000f9e <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000f68:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7fdbd230>
    80000f6c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000f6e:	37fd                	addiw	a5,a5,-1
    80000f70:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000f74:	60a6                	ld	ra,72(sp)
    80000f76:	6406                	ld	s0,64(sp)
    80000f78:	74e2                	ld	s1,56(sp)
    80000f7a:	7942                	ld	s2,48(sp)
    80000f7c:	79a2                	ld	s3,40(sp)
    80000f7e:	7a02                	ld	s4,32(sp)
    80000f80:	6ae2                	ld	s5,24(sp)
    80000f82:	6b42                	ld	s6,16(sp)
    80000f84:	6ba2                	ld	s7,8(sp)
    80000f86:	6161                	addi	sp,sp,80
    80000f88:	8082                	ret
    80000f8a:	fff90713          	addi	a4,s2,-1
    80000f8e:	9742                	add	a4,a4,a6
      --max;
    80000f90:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000f94:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000f98:	04e58663          	beq	a1,a4,80000fe4 <copyinstr+0xa2>
{
    80000f9c:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000f9e:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000fa2:	85a6                	mv	a1,s1
    80000fa4:	8552                	mv	a0,s4
    80000fa6:	fffff097          	auipc	ra,0xfffff
    80000faa:	686080e7          	jalr	1670(ra) # 8000062c <walkaddr>
    if(pa0 == 0)
    80000fae:	cd0d                	beqz	a0,80000fe8 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000fb0:	417486b3          	sub	a3,s1,s7
    80000fb4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000fb6:	00d97363          	bgeu	s2,a3,80000fbc <copyinstr+0x7a>
    80000fba:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000fbc:	955e                	add	a0,a0,s7
    80000fbe:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000fc0:	c695                	beqz	a3,80000fec <copyinstr+0xaa>
    80000fc2:	87da                	mv	a5,s6
    80000fc4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000fc6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000fca:	96da                	add	a3,a3,s6
    80000fcc:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000fce:	00f60733          	add	a4,a2,a5
    80000fd2:	00074703          	lbu	a4,0(a4)
    80000fd6:	db49                	beqz	a4,80000f68 <copyinstr+0x26>
        *dst = *p;
    80000fd8:	00e78023          	sb	a4,0(a5)
      dst++;
    80000fdc:	0785                	addi	a5,a5,1
    while(n > 0){
    80000fde:	fed797e3          	bne	a5,a3,80000fcc <copyinstr+0x8a>
    80000fe2:	b765                	j	80000f8a <copyinstr+0x48>
    80000fe4:	4781                	li	a5,0
    80000fe6:	b761                	j	80000f6e <copyinstr+0x2c>
      return -1;
    80000fe8:	557d                	li	a0,-1
    80000fea:	b769                	j	80000f74 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000fec:	6b85                	lui	s7,0x1
    80000fee:	9ba6                	add	s7,s7,s1
    80000ff0:	87da                	mv	a5,s6
    80000ff2:	b76d                	j	80000f9c <copyinstr+0x5a>
  int got_null = 0;
    80000ff4:	4781                	li	a5,0
  if(got_null){
    80000ff6:	37fd                	addiw	a5,a5,-1
    80000ff8:	0007851b          	sext.w	a0,a5
}
    80000ffc:	8082                	ret

0000000080000ffe <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000ffe:	7139                	addi	sp,sp,-64
    80001000:	fc06                	sd	ra,56(sp)
    80001002:	f822                	sd	s0,48(sp)
    80001004:	f426                	sd	s1,40(sp)
    80001006:	f04a                	sd	s2,32(sp)
    80001008:	ec4e                	sd	s3,24(sp)
    8000100a:	e852                	sd	s4,16(sp)
    8000100c:	e456                	sd	s5,8(sp)
    8000100e:	e05a                	sd	s6,0(sp)
    80001010:	0080                	addi	s0,sp,64
    80001012:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001014:	00228497          	auipc	s1,0x228
    80001018:	d9448493          	addi	s1,s1,-620 # 80228da8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000101c:	8b26                	mv	s6,s1
    8000101e:	04fa5937          	lui	s2,0x4fa5
    80001022:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001026:	0932                	slli	s2,s2,0xc
    80001028:	fa590913          	addi	s2,s2,-91
    8000102c:	0932                	slli	s2,s2,0xc
    8000102e:	fa590913          	addi	s2,s2,-91
    80001032:	0932                	slli	s2,s2,0xc
    80001034:	fa590913          	addi	s2,s2,-91
    80001038:	040009b7          	lui	s3,0x4000
    8000103c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000103e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001040:	0022da97          	auipc	s5,0x22d
    80001044:	768a8a93          	addi	s5,s5,1896 # 8022e7a8 <tickslock>
    char *pa = kalloc();
    80001048:	fffff097          	auipc	ra,0xfffff
    8000104c:	138080e7          	jalr	312(ra) # 80000180 <kalloc>
    80001050:	862a                	mv	a2,a0
    if(pa == 0)
    80001052:	c121                	beqz	a0,80001092 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80001054:	416485b3          	sub	a1,s1,s6
    80001058:	858d                	srai	a1,a1,0x3
    8000105a:	032585b3          	mul	a1,a1,s2
    8000105e:	2585                	addiw	a1,a1,1
    80001060:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001064:	4719                	li	a4,6
    80001066:	6685                	lui	a3,0x1
    80001068:	40b985b3          	sub	a1,s3,a1
    8000106c:	8552                	mv	a0,s4
    8000106e:	fffff097          	auipc	ra,0xfffff
    80001072:	6c4080e7          	jalr	1732(ra) # 80000732 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001076:	16848493          	addi	s1,s1,360
    8000107a:	fd5497e3          	bne	s1,s5,80001048 <proc_mapstacks+0x4a>
  }
}
    8000107e:	70e2                	ld	ra,56(sp)
    80001080:	7442                	ld	s0,48(sp)
    80001082:	74a2                	ld	s1,40(sp)
    80001084:	7902                	ld	s2,32(sp)
    80001086:	69e2                	ld	s3,24(sp)
    80001088:	6a42                	ld	s4,16(sp)
    8000108a:	6aa2                	ld	s5,8(sp)
    8000108c:	6b02                	ld	s6,0(sp)
    8000108e:	6121                	addi	sp,sp,64
    80001090:	8082                	ret
      panic("kalloc");
    80001092:	00007517          	auipc	a0,0x7
    80001096:	12e50513          	addi	a0,a0,302 # 800081c0 <etext+0x1c0>
    8000109a:	00005097          	auipc	ra,0x5
    8000109e:	0b8080e7          	jalr	184(ra) # 80006152 <panic>

00000000800010a2 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800010a2:	7139                	addi	sp,sp,-64
    800010a4:	fc06                	sd	ra,56(sp)
    800010a6:	f822                	sd	s0,48(sp)
    800010a8:	f426                	sd	s1,40(sp)
    800010aa:	f04a                	sd	s2,32(sp)
    800010ac:	ec4e                	sd	s3,24(sp)
    800010ae:	e852                	sd	s4,16(sp)
    800010b0:	e456                	sd	s5,8(sp)
    800010b2:	e05a                	sd	s6,0(sp)
    800010b4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800010b6:	00007597          	auipc	a1,0x7
    800010ba:	11258593          	addi	a1,a1,274 # 800081c8 <etext+0x1c8>
    800010be:	00228517          	auipc	a0,0x228
    800010c2:	8ba50513          	addi	a0,a0,-1862 # 80228978 <pid_lock>
    800010c6:	00005097          	auipc	ra,0x5
    800010ca:	576080e7          	jalr	1398(ra) # 8000663c <initlock>
  initlock(&wait_lock, "wait_lock");
    800010ce:	00007597          	auipc	a1,0x7
    800010d2:	10258593          	addi	a1,a1,258 # 800081d0 <etext+0x1d0>
    800010d6:	00228517          	auipc	a0,0x228
    800010da:	8ba50513          	addi	a0,a0,-1862 # 80228990 <wait_lock>
    800010de:	00005097          	auipc	ra,0x5
    800010e2:	55e080e7          	jalr	1374(ra) # 8000663c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010e6:	00228497          	auipc	s1,0x228
    800010ea:	cc248493          	addi	s1,s1,-830 # 80228da8 <proc>
      initlock(&p->lock, "proc");
    800010ee:	00007b17          	auipc	s6,0x7
    800010f2:	0f2b0b13          	addi	s6,s6,242 # 800081e0 <etext+0x1e0>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800010f6:	8aa6                	mv	s5,s1
    800010f8:	04fa5937          	lui	s2,0x4fa5
    800010fc:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001100:	0932                	slli	s2,s2,0xc
    80001102:	fa590913          	addi	s2,s2,-91
    80001106:	0932                	slli	s2,s2,0xc
    80001108:	fa590913          	addi	s2,s2,-91
    8000110c:	0932                	slli	s2,s2,0xc
    8000110e:	fa590913          	addi	s2,s2,-91
    80001112:	040009b7          	lui	s3,0x4000
    80001116:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001118:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000111a:	0022da17          	auipc	s4,0x22d
    8000111e:	68ea0a13          	addi	s4,s4,1678 # 8022e7a8 <tickslock>
      initlock(&p->lock, "proc");
    80001122:	85da                	mv	a1,s6
    80001124:	8526                	mv	a0,s1
    80001126:	00005097          	auipc	ra,0x5
    8000112a:	516080e7          	jalr	1302(ra) # 8000663c <initlock>
      p->state = UNUSED;
    8000112e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001132:	415487b3          	sub	a5,s1,s5
    80001136:	878d                	srai	a5,a5,0x3
    80001138:	032787b3          	mul	a5,a5,s2
    8000113c:	2785                	addiw	a5,a5,1
    8000113e:	00d7979b          	slliw	a5,a5,0xd
    80001142:	40f987b3          	sub	a5,s3,a5
    80001146:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001148:	16848493          	addi	s1,s1,360
    8000114c:	fd449be3          	bne	s1,s4,80001122 <procinit+0x80>
  }
}
    80001150:	70e2                	ld	ra,56(sp)
    80001152:	7442                	ld	s0,48(sp)
    80001154:	74a2                	ld	s1,40(sp)
    80001156:	7902                	ld	s2,32(sp)
    80001158:	69e2                	ld	s3,24(sp)
    8000115a:	6a42                	ld	s4,16(sp)
    8000115c:	6aa2                	ld	s5,8(sp)
    8000115e:	6b02                	ld	s6,0(sp)
    80001160:	6121                	addi	sp,sp,64
    80001162:	8082                	ret

0000000080001164 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001164:	1141                	addi	sp,sp,-16
    80001166:	e422                	sd	s0,8(sp)
    80001168:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000116a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000116c:	2501                	sext.w	a0,a0
    8000116e:	6422                	ld	s0,8(sp)
    80001170:	0141                	addi	sp,sp,16
    80001172:	8082                	ret

0000000080001174 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001174:	1141                	addi	sp,sp,-16
    80001176:	e422                	sd	s0,8(sp)
    80001178:	0800                	addi	s0,sp,16
    8000117a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000117c:	2781                	sext.w	a5,a5
    8000117e:	079e                	slli	a5,a5,0x7
  return c;
}
    80001180:	00228517          	auipc	a0,0x228
    80001184:	82850513          	addi	a0,a0,-2008 # 802289a8 <cpus>
    80001188:	953e                	add	a0,a0,a5
    8000118a:	6422                	ld	s0,8(sp)
    8000118c:	0141                	addi	sp,sp,16
    8000118e:	8082                	ret

0000000080001190 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001190:	1101                	addi	sp,sp,-32
    80001192:	ec06                	sd	ra,24(sp)
    80001194:	e822                	sd	s0,16(sp)
    80001196:	e426                	sd	s1,8(sp)
    80001198:	1000                	addi	s0,sp,32
  push_off();
    8000119a:	00005097          	auipc	ra,0x5
    8000119e:	4e6080e7          	jalr	1254(ra) # 80006680 <push_off>
    800011a2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800011a4:	2781                	sext.w	a5,a5
    800011a6:	079e                	slli	a5,a5,0x7
    800011a8:	00227717          	auipc	a4,0x227
    800011ac:	7d070713          	addi	a4,a4,2000 # 80228978 <pid_lock>
    800011b0:	97ba                	add	a5,a5,a4
    800011b2:	7b84                	ld	s1,48(a5)
  pop_off();
    800011b4:	00005097          	auipc	ra,0x5
    800011b8:	56c080e7          	jalr	1388(ra) # 80006720 <pop_off>
  return p;
}
    800011bc:	8526                	mv	a0,s1
    800011be:	60e2                	ld	ra,24(sp)
    800011c0:	6442                	ld	s0,16(sp)
    800011c2:	64a2                	ld	s1,8(sp)
    800011c4:	6105                	addi	sp,sp,32
    800011c6:	8082                	ret

00000000800011c8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800011c8:	1141                	addi	sp,sp,-16
    800011ca:	e406                	sd	ra,8(sp)
    800011cc:	e022                	sd	s0,0(sp)
    800011ce:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800011d0:	00000097          	auipc	ra,0x0
    800011d4:	fc0080e7          	jalr	-64(ra) # 80001190 <myproc>
    800011d8:	00005097          	auipc	ra,0x5
    800011dc:	5a8080e7          	jalr	1448(ra) # 80006780 <release>

  if (first) {
    800011e0:	00007797          	auipc	a5,0x7
    800011e4:	6e07a783          	lw	a5,1760(a5) # 800088c0 <first.1>
    800011e8:	eb89                	bnez	a5,800011fa <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    800011ea:	00001097          	auipc	ra,0x1
    800011ee:	d4c080e7          	jalr	-692(ra) # 80001f36 <usertrapret>
}
    800011f2:	60a2                	ld	ra,8(sp)
    800011f4:	6402                	ld	s0,0(sp)
    800011f6:	0141                	addi	sp,sp,16
    800011f8:	8082                	ret
    fsinit(ROOTDEV);
    800011fa:	4505                	li	a0,1
    800011fc:	00002097          	auipc	ra,0x2
    80001200:	b0c080e7          	jalr	-1268(ra) # 80002d08 <fsinit>
    first = 0;
    80001204:	00007797          	auipc	a5,0x7
    80001208:	6a07ae23          	sw	zero,1724(a5) # 800088c0 <first.1>
    __sync_synchronize();
    8000120c:	0ff0000f          	fence
    80001210:	bfe9                	j	800011ea <forkret+0x22>

0000000080001212 <allocpid>:
{
    80001212:	1101                	addi	sp,sp,-32
    80001214:	ec06                	sd	ra,24(sp)
    80001216:	e822                	sd	s0,16(sp)
    80001218:	e426                	sd	s1,8(sp)
    8000121a:	e04a                	sd	s2,0(sp)
    8000121c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000121e:	00227917          	auipc	s2,0x227
    80001222:	75a90913          	addi	s2,s2,1882 # 80228978 <pid_lock>
    80001226:	854a                	mv	a0,s2
    80001228:	00005097          	auipc	ra,0x5
    8000122c:	4a4080e7          	jalr	1188(ra) # 800066cc <acquire>
  pid = nextpid;
    80001230:	00007797          	auipc	a5,0x7
    80001234:	69478793          	addi	a5,a5,1684 # 800088c4 <nextpid>
    80001238:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000123a:	0014871b          	addiw	a4,s1,1
    8000123e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001240:	854a                	mv	a0,s2
    80001242:	00005097          	auipc	ra,0x5
    80001246:	53e080e7          	jalr	1342(ra) # 80006780 <release>
}
    8000124a:	8526                	mv	a0,s1
    8000124c:	60e2                	ld	ra,24(sp)
    8000124e:	6442                	ld	s0,16(sp)
    80001250:	64a2                	ld	s1,8(sp)
    80001252:	6902                	ld	s2,0(sp)
    80001254:	6105                	addi	sp,sp,32
    80001256:	8082                	ret

0000000080001258 <proc_pagetable>:
{
    80001258:	1101                	addi	sp,sp,-32
    8000125a:	ec06                	sd	ra,24(sp)
    8000125c:	e822                	sd	s0,16(sp)
    8000125e:	e426                	sd	s1,8(sp)
    80001260:	e04a                	sd	s2,0(sp)
    80001262:	1000                	addi	s0,sp,32
    80001264:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001266:	fffff097          	auipc	ra,0xfffff
    8000126a:	6c6080e7          	jalr	1734(ra) # 8000092c <uvmcreate>
    8000126e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001270:	c121                	beqz	a0,800012b0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001272:	4729                	li	a4,10
    80001274:	00006697          	auipc	a3,0x6
    80001278:	d8c68693          	addi	a3,a3,-628 # 80007000 <_trampoline>
    8000127c:	6605                	lui	a2,0x1
    8000127e:	040005b7          	lui	a1,0x4000
    80001282:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001284:	05b2                	slli	a1,a1,0xc
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	3e8080e7          	jalr	1000(ra) # 8000066e <mappages>
    8000128e:	02054863          	bltz	a0,800012be <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001292:	4719                	li	a4,6
    80001294:	05893683          	ld	a3,88(s2)
    80001298:	6605                	lui	a2,0x1
    8000129a:	020005b7          	lui	a1,0x2000
    8000129e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800012a0:	05b6                	slli	a1,a1,0xd
    800012a2:	8526                	mv	a0,s1
    800012a4:	fffff097          	auipc	ra,0xfffff
    800012a8:	3ca080e7          	jalr	970(ra) # 8000066e <mappages>
    800012ac:	02054163          	bltz	a0,800012ce <proc_pagetable+0x76>
}
    800012b0:	8526                	mv	a0,s1
    800012b2:	60e2                	ld	ra,24(sp)
    800012b4:	6442                	ld	s0,16(sp)
    800012b6:	64a2                	ld	s1,8(sp)
    800012b8:	6902                	ld	s2,0(sp)
    800012ba:	6105                	addi	sp,sp,32
    800012bc:	8082                	ret
    uvmfree(pagetable, 0);
    800012be:	4581                	li	a1,0
    800012c0:	8526                	mv	a0,s1
    800012c2:	00000097          	auipc	ra,0x0
    800012c6:	87c080e7          	jalr	-1924(ra) # 80000b3e <uvmfree>
    return 0;
    800012ca:	4481                	li	s1,0
    800012cc:	b7d5                	j	800012b0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800012ce:	4681                	li	a3,0
    800012d0:	4605                	li	a2,1
    800012d2:	040005b7          	lui	a1,0x4000
    800012d6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012d8:	05b2                	slli	a1,a1,0xc
    800012da:	8526                	mv	a0,s1
    800012dc:	fffff097          	auipc	ra,0xfffff
    800012e0:	57c080e7          	jalr	1404(ra) # 80000858 <uvmunmap>
    uvmfree(pagetable, 0);
    800012e4:	4581                	li	a1,0
    800012e6:	8526                	mv	a0,s1
    800012e8:	00000097          	auipc	ra,0x0
    800012ec:	856080e7          	jalr	-1962(ra) # 80000b3e <uvmfree>
    return 0;
    800012f0:	4481                	li	s1,0
    800012f2:	bf7d                	j	800012b0 <proc_pagetable+0x58>

00000000800012f4 <proc_freepagetable>:
{
    800012f4:	1101                	addi	sp,sp,-32
    800012f6:	ec06                	sd	ra,24(sp)
    800012f8:	e822                	sd	s0,16(sp)
    800012fa:	e426                	sd	s1,8(sp)
    800012fc:	e04a                	sd	s2,0(sp)
    800012fe:	1000                	addi	s0,sp,32
    80001300:	84aa                	mv	s1,a0
    80001302:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001304:	4681                	li	a3,0
    80001306:	4605                	li	a2,1
    80001308:	040005b7          	lui	a1,0x4000
    8000130c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000130e:	05b2                	slli	a1,a1,0xc
    80001310:	fffff097          	auipc	ra,0xfffff
    80001314:	548080e7          	jalr	1352(ra) # 80000858 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001318:	4681                	li	a3,0
    8000131a:	4605                	li	a2,1
    8000131c:	020005b7          	lui	a1,0x2000
    80001320:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001322:	05b6                	slli	a1,a1,0xd
    80001324:	8526                	mv	a0,s1
    80001326:	fffff097          	auipc	ra,0xfffff
    8000132a:	532080e7          	jalr	1330(ra) # 80000858 <uvmunmap>
  uvmfree(pagetable, sz);
    8000132e:	85ca                	mv	a1,s2
    80001330:	8526                	mv	a0,s1
    80001332:	00000097          	auipc	ra,0x0
    80001336:	80c080e7          	jalr	-2036(ra) # 80000b3e <uvmfree>
}
    8000133a:	60e2                	ld	ra,24(sp)
    8000133c:	6442                	ld	s0,16(sp)
    8000133e:	64a2                	ld	s1,8(sp)
    80001340:	6902                	ld	s2,0(sp)
    80001342:	6105                	addi	sp,sp,32
    80001344:	8082                	ret

0000000080001346 <freeproc>:
{
    80001346:	1101                	addi	sp,sp,-32
    80001348:	ec06                	sd	ra,24(sp)
    8000134a:	e822                	sd	s0,16(sp)
    8000134c:	e426                	sd	s1,8(sp)
    8000134e:	1000                	addi	s0,sp,32
    80001350:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001352:	6d28                	ld	a0,88(a0)
    80001354:	c509                	beqz	a0,8000135e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001356:	fffff097          	auipc	ra,0xfffff
    8000135a:	cc6080e7          	jalr	-826(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000135e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001362:	68a8                	ld	a0,80(s1)
    80001364:	c511                	beqz	a0,80001370 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001366:	64ac                	ld	a1,72(s1)
    80001368:	00000097          	auipc	ra,0x0
    8000136c:	f8c080e7          	jalr	-116(ra) # 800012f4 <proc_freepagetable>
  p->pagetable = 0;
    80001370:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001374:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001378:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000137c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001380:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001384:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001388:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000138c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001390:	0004ac23          	sw	zero,24(s1)
}
    80001394:	60e2                	ld	ra,24(sp)
    80001396:	6442                	ld	s0,16(sp)
    80001398:	64a2                	ld	s1,8(sp)
    8000139a:	6105                	addi	sp,sp,32
    8000139c:	8082                	ret

000000008000139e <allocproc>:
{
    8000139e:	1101                	addi	sp,sp,-32
    800013a0:	ec06                	sd	ra,24(sp)
    800013a2:	e822                	sd	s0,16(sp)
    800013a4:	e426                	sd	s1,8(sp)
    800013a6:	e04a                	sd	s2,0(sp)
    800013a8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800013aa:	00228497          	auipc	s1,0x228
    800013ae:	9fe48493          	addi	s1,s1,-1538 # 80228da8 <proc>
    800013b2:	0022d917          	auipc	s2,0x22d
    800013b6:	3f690913          	addi	s2,s2,1014 # 8022e7a8 <tickslock>
    acquire(&p->lock);
    800013ba:	8526                	mv	a0,s1
    800013bc:	00005097          	auipc	ra,0x5
    800013c0:	310080e7          	jalr	784(ra) # 800066cc <acquire>
    if(p->state == UNUSED) {
    800013c4:	4c9c                	lw	a5,24(s1)
    800013c6:	cf81                	beqz	a5,800013de <allocproc+0x40>
      release(&p->lock);
    800013c8:	8526                	mv	a0,s1
    800013ca:	00005097          	auipc	ra,0x5
    800013ce:	3b6080e7          	jalr	950(ra) # 80006780 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013d2:	16848493          	addi	s1,s1,360
    800013d6:	ff2492e3          	bne	s1,s2,800013ba <allocproc+0x1c>
  return 0;
    800013da:	4481                	li	s1,0
    800013dc:	a889                	j	8000142e <allocproc+0x90>
  p->pid = allocpid();
    800013de:	00000097          	auipc	ra,0x0
    800013e2:	e34080e7          	jalr	-460(ra) # 80001212 <allocpid>
    800013e6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800013e8:	4785                	li	a5,1
    800013ea:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800013ec:	fffff097          	auipc	ra,0xfffff
    800013f0:	d94080e7          	jalr	-620(ra) # 80000180 <kalloc>
    800013f4:	892a                	mv	s2,a0
    800013f6:	eca8                	sd	a0,88(s1)
    800013f8:	c131                	beqz	a0,8000143c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800013fa:	8526                	mv	a0,s1
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	e5c080e7          	jalr	-420(ra) # 80001258 <proc_pagetable>
    80001404:	892a                	mv	s2,a0
    80001406:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001408:	c531                	beqz	a0,80001454 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000140a:	07000613          	li	a2,112
    8000140e:	4581                	li	a1,0
    80001410:	06048513          	addi	a0,s1,96
    80001414:	fffff097          	auipc	ra,0xfffff
    80001418:	e96080e7          	jalr	-362(ra) # 800002aa <memset>
  p->context.ra = (uint64)forkret;
    8000141c:	00000797          	auipc	a5,0x0
    80001420:	dac78793          	addi	a5,a5,-596 # 800011c8 <forkret>
    80001424:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001426:	60bc                	ld	a5,64(s1)
    80001428:	6705                	lui	a4,0x1
    8000142a:	97ba                	add	a5,a5,a4
    8000142c:	f4bc                	sd	a5,104(s1)
}
    8000142e:	8526                	mv	a0,s1
    80001430:	60e2                	ld	ra,24(sp)
    80001432:	6442                	ld	s0,16(sp)
    80001434:	64a2                	ld	s1,8(sp)
    80001436:	6902                	ld	s2,0(sp)
    80001438:	6105                	addi	sp,sp,32
    8000143a:	8082                	ret
    freeproc(p);
    8000143c:	8526                	mv	a0,s1
    8000143e:	00000097          	auipc	ra,0x0
    80001442:	f08080e7          	jalr	-248(ra) # 80001346 <freeproc>
    release(&p->lock);
    80001446:	8526                	mv	a0,s1
    80001448:	00005097          	auipc	ra,0x5
    8000144c:	338080e7          	jalr	824(ra) # 80006780 <release>
    return 0;
    80001450:	84ca                	mv	s1,s2
    80001452:	bff1                	j	8000142e <allocproc+0x90>
    freeproc(p);
    80001454:	8526                	mv	a0,s1
    80001456:	00000097          	auipc	ra,0x0
    8000145a:	ef0080e7          	jalr	-272(ra) # 80001346 <freeproc>
    release(&p->lock);
    8000145e:	8526                	mv	a0,s1
    80001460:	00005097          	auipc	ra,0x5
    80001464:	320080e7          	jalr	800(ra) # 80006780 <release>
    return 0;
    80001468:	84ca                	mv	s1,s2
    8000146a:	b7d1                	j	8000142e <allocproc+0x90>

000000008000146c <userinit>:
{
    8000146c:	1101                	addi	sp,sp,-32
    8000146e:	ec06                	sd	ra,24(sp)
    80001470:	e822                	sd	s0,16(sp)
    80001472:	e426                	sd	s1,8(sp)
    80001474:	1000                	addi	s0,sp,32
  p = allocproc();
    80001476:	00000097          	auipc	ra,0x0
    8000147a:	f28080e7          	jalr	-216(ra) # 8000139e <allocproc>
    8000147e:	84aa                	mv	s1,a0
  initproc = p;
    80001480:	00007797          	auipc	a5,0x7
    80001484:	4aa7b023          	sd	a0,1184(a5) # 80008920 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001488:	03400613          	li	a2,52
    8000148c:	00007597          	auipc	a1,0x7
    80001490:	44458593          	addi	a1,a1,1092 # 800088d0 <initcode>
    80001494:	6928                	ld	a0,80(a0)
    80001496:	fffff097          	auipc	ra,0xfffff
    8000149a:	4c4080e7          	jalr	1220(ra) # 8000095a <uvmfirst>
  p->sz = PGSIZE;
    8000149e:	6785                	lui	a5,0x1
    800014a0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800014a2:	6cb8                	ld	a4,88(s1)
    800014a4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800014a8:	6cb8                	ld	a4,88(s1)
    800014aa:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800014ac:	4641                	li	a2,16
    800014ae:	00007597          	auipc	a1,0x7
    800014b2:	d3a58593          	addi	a1,a1,-710 # 800081e8 <etext+0x1e8>
    800014b6:	15848513          	addi	a0,s1,344
    800014ba:	fffff097          	auipc	ra,0xfffff
    800014be:	f32080e7          	jalr	-206(ra) # 800003ec <safestrcpy>
  p->cwd = namei("/");
    800014c2:	00007517          	auipc	a0,0x7
    800014c6:	d3650513          	addi	a0,a0,-714 # 800081f8 <etext+0x1f8>
    800014ca:	00002097          	auipc	ra,0x2
    800014ce:	290080e7          	jalr	656(ra) # 8000375a <namei>
    800014d2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800014d6:	478d                	li	a5,3
    800014d8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800014da:	8526                	mv	a0,s1
    800014dc:	00005097          	auipc	ra,0x5
    800014e0:	2a4080e7          	jalr	676(ra) # 80006780 <release>
}
    800014e4:	60e2                	ld	ra,24(sp)
    800014e6:	6442                	ld	s0,16(sp)
    800014e8:	64a2                	ld	s1,8(sp)
    800014ea:	6105                	addi	sp,sp,32
    800014ec:	8082                	ret

00000000800014ee <growproc>:
{
    800014ee:	1101                	addi	sp,sp,-32
    800014f0:	ec06                	sd	ra,24(sp)
    800014f2:	e822                	sd	s0,16(sp)
    800014f4:	e426                	sd	s1,8(sp)
    800014f6:	e04a                	sd	s2,0(sp)
    800014f8:	1000                	addi	s0,sp,32
    800014fa:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800014fc:	00000097          	auipc	ra,0x0
    80001500:	c94080e7          	jalr	-876(ra) # 80001190 <myproc>
    80001504:	84aa                	mv	s1,a0
  sz = p->sz;
    80001506:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001508:	01204c63          	bgtz	s2,80001520 <growproc+0x32>
  } else if(n < 0){
    8000150c:	02094663          	bltz	s2,80001538 <growproc+0x4a>
  p->sz = sz;
    80001510:	e4ac                	sd	a1,72(s1)
  return 0;
    80001512:	4501                	li	a0,0
}
    80001514:	60e2                	ld	ra,24(sp)
    80001516:	6442                	ld	s0,16(sp)
    80001518:	64a2                	ld	s1,8(sp)
    8000151a:	6902                	ld	s2,0(sp)
    8000151c:	6105                	addi	sp,sp,32
    8000151e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001520:	4691                	li	a3,4
    80001522:	00b90633          	add	a2,s2,a1
    80001526:	6928                	ld	a0,80(a0)
    80001528:	fffff097          	auipc	ra,0xfffff
    8000152c:	4ec080e7          	jalr	1260(ra) # 80000a14 <uvmalloc>
    80001530:	85aa                	mv	a1,a0
    80001532:	fd79                	bnez	a0,80001510 <growproc+0x22>
      return -1;
    80001534:	557d                	li	a0,-1
    80001536:	bff9                	j	80001514 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001538:	00b90633          	add	a2,s2,a1
    8000153c:	6928                	ld	a0,80(a0)
    8000153e:	fffff097          	auipc	ra,0xfffff
    80001542:	48e080e7          	jalr	1166(ra) # 800009cc <uvmdealloc>
    80001546:	85aa                	mv	a1,a0
    80001548:	b7e1                	j	80001510 <growproc+0x22>

000000008000154a <fork>:
{
    8000154a:	7139                	addi	sp,sp,-64
    8000154c:	fc06                	sd	ra,56(sp)
    8000154e:	f822                	sd	s0,48(sp)
    80001550:	f04a                	sd	s2,32(sp)
    80001552:	e456                	sd	s5,8(sp)
    80001554:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001556:	00000097          	auipc	ra,0x0
    8000155a:	c3a080e7          	jalr	-966(ra) # 80001190 <myproc>
    8000155e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001560:	00000097          	auipc	ra,0x0
    80001564:	e3e080e7          	jalr	-450(ra) # 8000139e <allocproc>
    80001568:	12050063          	beqz	a0,80001688 <fork+0x13e>
    8000156c:	e852                	sd	s4,16(sp)
    8000156e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001570:	048ab603          	ld	a2,72(s5)
    80001574:	692c                	ld	a1,80(a0)
    80001576:	050ab503          	ld	a0,80(s5)
    8000157a:	fffff097          	auipc	ra,0xfffff
    8000157e:	5fe080e7          	jalr	1534(ra) # 80000b78 <uvmcopy>
    80001582:	04054a63          	bltz	a0,800015d6 <fork+0x8c>
    80001586:	f426                	sd	s1,40(sp)
    80001588:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000158a:	048ab783          	ld	a5,72(s5)
    8000158e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001592:	058ab683          	ld	a3,88(s5)
    80001596:	87b6                	mv	a5,a3
    80001598:	058a3703          	ld	a4,88(s4)
    8000159c:	12068693          	addi	a3,a3,288
    800015a0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800015a4:	6788                	ld	a0,8(a5)
    800015a6:	6b8c                	ld	a1,16(a5)
    800015a8:	6f90                	ld	a2,24(a5)
    800015aa:	01073023          	sd	a6,0(a4)
    800015ae:	e708                	sd	a0,8(a4)
    800015b0:	eb0c                	sd	a1,16(a4)
    800015b2:	ef10                	sd	a2,24(a4)
    800015b4:	02078793          	addi	a5,a5,32
    800015b8:	02070713          	addi	a4,a4,32
    800015bc:	fed792e3          	bne	a5,a3,800015a0 <fork+0x56>
  np->trapframe->a0 = 0;
    800015c0:	058a3783          	ld	a5,88(s4)
    800015c4:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800015c8:	0d0a8493          	addi	s1,s5,208
    800015cc:	0d0a0913          	addi	s2,s4,208
    800015d0:	150a8993          	addi	s3,s5,336
    800015d4:	a015                	j	800015f8 <fork+0xae>
    freeproc(np);
    800015d6:	8552                	mv	a0,s4
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	d6e080e7          	jalr	-658(ra) # 80001346 <freeproc>
    release(&np->lock);
    800015e0:	8552                	mv	a0,s4
    800015e2:	00005097          	auipc	ra,0x5
    800015e6:	19e080e7          	jalr	414(ra) # 80006780 <release>
    return -1;
    800015ea:	597d                	li	s2,-1
    800015ec:	6a42                	ld	s4,16(sp)
    800015ee:	a071                	j	8000167a <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800015f0:	04a1                	addi	s1,s1,8
    800015f2:	0921                	addi	s2,s2,8
    800015f4:	01348b63          	beq	s1,s3,8000160a <fork+0xc0>
    if(p->ofile[i])
    800015f8:	6088                	ld	a0,0(s1)
    800015fa:	d97d                	beqz	a0,800015f0 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800015fc:	00002097          	auipc	ra,0x2
    80001600:	7d6080e7          	jalr	2006(ra) # 80003dd2 <filedup>
    80001604:	00a93023          	sd	a0,0(s2)
    80001608:	b7e5                	j	800015f0 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000160a:	150ab503          	ld	a0,336(s5)
    8000160e:	00002097          	auipc	ra,0x2
    80001612:	940080e7          	jalr	-1728(ra) # 80002f4e <idup>
    80001616:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000161a:	4641                	li	a2,16
    8000161c:	158a8593          	addi	a1,s5,344
    80001620:	158a0513          	addi	a0,s4,344
    80001624:	fffff097          	auipc	ra,0xfffff
    80001628:	dc8080e7          	jalr	-568(ra) # 800003ec <safestrcpy>
  pid = np->pid;
    8000162c:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001630:	8552                	mv	a0,s4
    80001632:	00005097          	auipc	ra,0x5
    80001636:	14e080e7          	jalr	334(ra) # 80006780 <release>
  acquire(&wait_lock);
    8000163a:	00227497          	auipc	s1,0x227
    8000163e:	35648493          	addi	s1,s1,854 # 80228990 <wait_lock>
    80001642:	8526                	mv	a0,s1
    80001644:	00005097          	auipc	ra,0x5
    80001648:	088080e7          	jalr	136(ra) # 800066cc <acquire>
  np->parent = p;
    8000164c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001650:	8526                	mv	a0,s1
    80001652:	00005097          	auipc	ra,0x5
    80001656:	12e080e7          	jalr	302(ra) # 80006780 <release>
  acquire(&np->lock);
    8000165a:	8552                	mv	a0,s4
    8000165c:	00005097          	auipc	ra,0x5
    80001660:	070080e7          	jalr	112(ra) # 800066cc <acquire>
  np->state = RUNNABLE;
    80001664:	478d                	li	a5,3
    80001666:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000166a:	8552                	mv	a0,s4
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	114080e7          	jalr	276(ra) # 80006780 <release>
  return pid;
    80001674:	74a2                	ld	s1,40(sp)
    80001676:	69e2                	ld	s3,24(sp)
    80001678:	6a42                	ld	s4,16(sp)
}
    8000167a:	854a                	mv	a0,s2
    8000167c:	70e2                	ld	ra,56(sp)
    8000167e:	7442                	ld	s0,48(sp)
    80001680:	7902                	ld	s2,32(sp)
    80001682:	6aa2                	ld	s5,8(sp)
    80001684:	6121                	addi	sp,sp,64
    80001686:	8082                	ret
    return -1;
    80001688:	597d                	li	s2,-1
    8000168a:	bfc5                	j	8000167a <fork+0x130>

000000008000168c <scheduler>:
{
    8000168c:	7139                	addi	sp,sp,-64
    8000168e:	fc06                	sd	ra,56(sp)
    80001690:	f822                	sd	s0,48(sp)
    80001692:	f426                	sd	s1,40(sp)
    80001694:	f04a                	sd	s2,32(sp)
    80001696:	ec4e                	sd	s3,24(sp)
    80001698:	e852                	sd	s4,16(sp)
    8000169a:	e456                	sd	s5,8(sp)
    8000169c:	e05a                	sd	s6,0(sp)
    8000169e:	0080                	addi	s0,sp,64
    800016a0:	8792                	mv	a5,tp
  int id = r_tp();
    800016a2:	2781                	sext.w	a5,a5
  c->proc = 0;
    800016a4:	00779a93          	slli	s5,a5,0x7
    800016a8:	00227717          	auipc	a4,0x227
    800016ac:	2d070713          	addi	a4,a4,720 # 80228978 <pid_lock>
    800016b0:	9756                	add	a4,a4,s5
    800016b2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800016b6:	00227717          	auipc	a4,0x227
    800016ba:	2fa70713          	addi	a4,a4,762 # 802289b0 <cpus+0x8>
    800016be:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800016c0:	498d                	li	s3,3
        p->state = RUNNING;
    800016c2:	4b11                	li	s6,4
        c->proc = p;
    800016c4:	079e                	slli	a5,a5,0x7
    800016c6:	00227a17          	auipc	s4,0x227
    800016ca:	2b2a0a13          	addi	s4,s4,690 # 80228978 <pid_lock>
    800016ce:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800016d0:	0022d917          	auipc	s2,0x22d
    800016d4:	0d890913          	addi	s2,s2,216 # 8022e7a8 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800016d8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800016dc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800016e0:	10079073          	csrw	sstatus,a5
    800016e4:	00227497          	auipc	s1,0x227
    800016e8:	6c448493          	addi	s1,s1,1732 # 80228da8 <proc>
    800016ec:	a811                	j	80001700 <scheduler+0x74>
      release(&p->lock);
    800016ee:	8526                	mv	a0,s1
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	090080e7          	jalr	144(ra) # 80006780 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800016f8:	16848493          	addi	s1,s1,360
    800016fc:	fd248ee3          	beq	s1,s2,800016d8 <scheduler+0x4c>
      acquire(&p->lock);
    80001700:	8526                	mv	a0,s1
    80001702:	00005097          	auipc	ra,0x5
    80001706:	fca080e7          	jalr	-54(ra) # 800066cc <acquire>
      if(p->state == RUNNABLE) {
    8000170a:	4c9c                	lw	a5,24(s1)
    8000170c:	ff3791e3          	bne	a5,s3,800016ee <scheduler+0x62>
        p->state = RUNNING;
    80001710:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001714:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001718:	06048593          	addi	a1,s1,96
    8000171c:	8556                	mv	a0,s5
    8000171e:	00000097          	auipc	ra,0x0
    80001722:	684080e7          	jalr	1668(ra) # 80001da2 <swtch>
        c->proc = 0;
    80001726:	020a3823          	sd	zero,48(s4)
    8000172a:	b7d1                	j	800016ee <scheduler+0x62>

000000008000172c <sched>:
{
    8000172c:	7179                	addi	sp,sp,-48
    8000172e:	f406                	sd	ra,40(sp)
    80001730:	f022                	sd	s0,32(sp)
    80001732:	ec26                	sd	s1,24(sp)
    80001734:	e84a                	sd	s2,16(sp)
    80001736:	e44e                	sd	s3,8(sp)
    80001738:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000173a:	00000097          	auipc	ra,0x0
    8000173e:	a56080e7          	jalr	-1450(ra) # 80001190 <myproc>
    80001742:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001744:	00005097          	auipc	ra,0x5
    80001748:	f0e080e7          	jalr	-242(ra) # 80006652 <holding>
    8000174c:	c93d                	beqz	a0,800017c2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000174e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001750:	2781                	sext.w	a5,a5
    80001752:	079e                	slli	a5,a5,0x7
    80001754:	00227717          	auipc	a4,0x227
    80001758:	22470713          	addi	a4,a4,548 # 80228978 <pid_lock>
    8000175c:	97ba                	add	a5,a5,a4
    8000175e:	0a87a703          	lw	a4,168(a5)
    80001762:	4785                	li	a5,1
    80001764:	06f71763          	bne	a4,a5,800017d2 <sched+0xa6>
  if(p->state == RUNNING)
    80001768:	4c98                	lw	a4,24(s1)
    8000176a:	4791                	li	a5,4
    8000176c:	06f70b63          	beq	a4,a5,800017e2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001770:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001774:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001776:	efb5                	bnez	a5,800017f2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001778:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000177a:	00227917          	auipc	s2,0x227
    8000177e:	1fe90913          	addi	s2,s2,510 # 80228978 <pid_lock>
    80001782:	2781                	sext.w	a5,a5
    80001784:	079e                	slli	a5,a5,0x7
    80001786:	97ca                	add	a5,a5,s2
    80001788:	0ac7a983          	lw	s3,172(a5)
    8000178c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000178e:	2781                	sext.w	a5,a5
    80001790:	079e                	slli	a5,a5,0x7
    80001792:	00227597          	auipc	a1,0x227
    80001796:	21e58593          	addi	a1,a1,542 # 802289b0 <cpus+0x8>
    8000179a:	95be                	add	a1,a1,a5
    8000179c:	06048513          	addi	a0,s1,96
    800017a0:	00000097          	auipc	ra,0x0
    800017a4:	602080e7          	jalr	1538(ra) # 80001da2 <swtch>
    800017a8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800017aa:	2781                	sext.w	a5,a5
    800017ac:	079e                	slli	a5,a5,0x7
    800017ae:	993e                	add	s2,s2,a5
    800017b0:	0b392623          	sw	s3,172(s2)
}
    800017b4:	70a2                	ld	ra,40(sp)
    800017b6:	7402                	ld	s0,32(sp)
    800017b8:	64e2                	ld	s1,24(sp)
    800017ba:	6942                	ld	s2,16(sp)
    800017bc:	69a2                	ld	s3,8(sp)
    800017be:	6145                	addi	sp,sp,48
    800017c0:	8082                	ret
    panic("sched p->lock");
    800017c2:	00007517          	auipc	a0,0x7
    800017c6:	a3e50513          	addi	a0,a0,-1474 # 80008200 <etext+0x200>
    800017ca:	00005097          	auipc	ra,0x5
    800017ce:	988080e7          	jalr	-1656(ra) # 80006152 <panic>
    panic("sched locks");
    800017d2:	00007517          	auipc	a0,0x7
    800017d6:	a3e50513          	addi	a0,a0,-1474 # 80008210 <etext+0x210>
    800017da:	00005097          	auipc	ra,0x5
    800017de:	978080e7          	jalr	-1672(ra) # 80006152 <panic>
    panic("sched running");
    800017e2:	00007517          	auipc	a0,0x7
    800017e6:	a3e50513          	addi	a0,a0,-1474 # 80008220 <etext+0x220>
    800017ea:	00005097          	auipc	ra,0x5
    800017ee:	968080e7          	jalr	-1688(ra) # 80006152 <panic>
    panic("sched interruptible");
    800017f2:	00007517          	auipc	a0,0x7
    800017f6:	a3e50513          	addi	a0,a0,-1474 # 80008230 <etext+0x230>
    800017fa:	00005097          	auipc	ra,0x5
    800017fe:	958080e7          	jalr	-1704(ra) # 80006152 <panic>

0000000080001802 <yield>:
{
    80001802:	1101                	addi	sp,sp,-32
    80001804:	ec06                	sd	ra,24(sp)
    80001806:	e822                	sd	s0,16(sp)
    80001808:	e426                	sd	s1,8(sp)
    8000180a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000180c:	00000097          	auipc	ra,0x0
    80001810:	984080e7          	jalr	-1660(ra) # 80001190 <myproc>
    80001814:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001816:	00005097          	auipc	ra,0x5
    8000181a:	eb6080e7          	jalr	-330(ra) # 800066cc <acquire>
  p->state = RUNNABLE;
    8000181e:	478d                	li	a5,3
    80001820:	cc9c                	sw	a5,24(s1)
  sched();
    80001822:	00000097          	auipc	ra,0x0
    80001826:	f0a080e7          	jalr	-246(ra) # 8000172c <sched>
  release(&p->lock);
    8000182a:	8526                	mv	a0,s1
    8000182c:	00005097          	auipc	ra,0x5
    80001830:	f54080e7          	jalr	-172(ra) # 80006780 <release>
}
    80001834:	60e2                	ld	ra,24(sp)
    80001836:	6442                	ld	s0,16(sp)
    80001838:	64a2                	ld	s1,8(sp)
    8000183a:	6105                	addi	sp,sp,32
    8000183c:	8082                	ret

000000008000183e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000183e:	7179                	addi	sp,sp,-48
    80001840:	f406                	sd	ra,40(sp)
    80001842:	f022                	sd	s0,32(sp)
    80001844:	ec26                	sd	s1,24(sp)
    80001846:	e84a                	sd	s2,16(sp)
    80001848:	e44e                	sd	s3,8(sp)
    8000184a:	1800                	addi	s0,sp,48
    8000184c:	89aa                	mv	s3,a0
    8000184e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001850:	00000097          	auipc	ra,0x0
    80001854:	940080e7          	jalr	-1728(ra) # 80001190 <myproc>
    80001858:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000185a:	00005097          	auipc	ra,0x5
    8000185e:	e72080e7          	jalr	-398(ra) # 800066cc <acquire>
  release(lk);
    80001862:	854a                	mv	a0,s2
    80001864:	00005097          	auipc	ra,0x5
    80001868:	f1c080e7          	jalr	-228(ra) # 80006780 <release>

  // Go to sleep.
  p->chan = chan;
    8000186c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001870:	4789                	li	a5,2
    80001872:	cc9c                	sw	a5,24(s1)

  sched();
    80001874:	00000097          	auipc	ra,0x0
    80001878:	eb8080e7          	jalr	-328(ra) # 8000172c <sched>

  // Tidy up.
  p->chan = 0;
    8000187c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001880:	8526                	mv	a0,s1
    80001882:	00005097          	auipc	ra,0x5
    80001886:	efe080e7          	jalr	-258(ra) # 80006780 <release>
  acquire(lk);
    8000188a:	854a                	mv	a0,s2
    8000188c:	00005097          	auipc	ra,0x5
    80001890:	e40080e7          	jalr	-448(ra) # 800066cc <acquire>
}
    80001894:	70a2                	ld	ra,40(sp)
    80001896:	7402                	ld	s0,32(sp)
    80001898:	64e2                	ld	s1,24(sp)
    8000189a:	6942                	ld	s2,16(sp)
    8000189c:	69a2                	ld	s3,8(sp)
    8000189e:	6145                	addi	sp,sp,48
    800018a0:	8082                	ret

00000000800018a2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800018a2:	7139                	addi	sp,sp,-64
    800018a4:	fc06                	sd	ra,56(sp)
    800018a6:	f822                	sd	s0,48(sp)
    800018a8:	f426                	sd	s1,40(sp)
    800018aa:	f04a                	sd	s2,32(sp)
    800018ac:	ec4e                	sd	s3,24(sp)
    800018ae:	e852                	sd	s4,16(sp)
    800018b0:	e456                	sd	s5,8(sp)
    800018b2:	0080                	addi	s0,sp,64
    800018b4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800018b6:	00227497          	auipc	s1,0x227
    800018ba:	4f248493          	addi	s1,s1,1266 # 80228da8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800018be:	4989                	li	s3,2
        p->state = RUNNABLE;
    800018c0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800018c2:	0022d917          	auipc	s2,0x22d
    800018c6:	ee690913          	addi	s2,s2,-282 # 8022e7a8 <tickslock>
    800018ca:	a811                	j	800018de <wakeup+0x3c>
      }
      release(&p->lock);
    800018cc:	8526                	mv	a0,s1
    800018ce:	00005097          	auipc	ra,0x5
    800018d2:	eb2080e7          	jalr	-334(ra) # 80006780 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018d6:	16848493          	addi	s1,s1,360
    800018da:	03248663          	beq	s1,s2,80001906 <wakeup+0x64>
    if(p != myproc()){
    800018de:	00000097          	auipc	ra,0x0
    800018e2:	8b2080e7          	jalr	-1870(ra) # 80001190 <myproc>
    800018e6:	fea488e3          	beq	s1,a0,800018d6 <wakeup+0x34>
      acquire(&p->lock);
    800018ea:	8526                	mv	a0,s1
    800018ec:	00005097          	auipc	ra,0x5
    800018f0:	de0080e7          	jalr	-544(ra) # 800066cc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800018f4:	4c9c                	lw	a5,24(s1)
    800018f6:	fd379be3          	bne	a5,s3,800018cc <wakeup+0x2a>
    800018fa:	709c                	ld	a5,32(s1)
    800018fc:	fd4798e3          	bne	a5,s4,800018cc <wakeup+0x2a>
        p->state = RUNNABLE;
    80001900:	0154ac23          	sw	s5,24(s1)
    80001904:	b7e1                	j	800018cc <wakeup+0x2a>
    }
  }
}
    80001906:	70e2                	ld	ra,56(sp)
    80001908:	7442                	ld	s0,48(sp)
    8000190a:	74a2                	ld	s1,40(sp)
    8000190c:	7902                	ld	s2,32(sp)
    8000190e:	69e2                	ld	s3,24(sp)
    80001910:	6a42                	ld	s4,16(sp)
    80001912:	6aa2                	ld	s5,8(sp)
    80001914:	6121                	addi	sp,sp,64
    80001916:	8082                	ret

0000000080001918 <reparent>:
{
    80001918:	7179                	addi	sp,sp,-48
    8000191a:	f406                	sd	ra,40(sp)
    8000191c:	f022                	sd	s0,32(sp)
    8000191e:	ec26                	sd	s1,24(sp)
    80001920:	e84a                	sd	s2,16(sp)
    80001922:	e44e                	sd	s3,8(sp)
    80001924:	e052                	sd	s4,0(sp)
    80001926:	1800                	addi	s0,sp,48
    80001928:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000192a:	00227497          	auipc	s1,0x227
    8000192e:	47e48493          	addi	s1,s1,1150 # 80228da8 <proc>
      pp->parent = initproc;
    80001932:	00007a17          	auipc	s4,0x7
    80001936:	feea0a13          	addi	s4,s4,-18 # 80008920 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000193a:	0022d997          	auipc	s3,0x22d
    8000193e:	e6e98993          	addi	s3,s3,-402 # 8022e7a8 <tickslock>
    80001942:	a029                	j	8000194c <reparent+0x34>
    80001944:	16848493          	addi	s1,s1,360
    80001948:	01348d63          	beq	s1,s3,80001962 <reparent+0x4a>
    if(pp->parent == p){
    8000194c:	7c9c                	ld	a5,56(s1)
    8000194e:	ff279be3          	bne	a5,s2,80001944 <reparent+0x2c>
      pp->parent = initproc;
    80001952:	000a3503          	ld	a0,0(s4)
    80001956:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001958:	00000097          	auipc	ra,0x0
    8000195c:	f4a080e7          	jalr	-182(ra) # 800018a2 <wakeup>
    80001960:	b7d5                	j	80001944 <reparent+0x2c>
}
    80001962:	70a2                	ld	ra,40(sp)
    80001964:	7402                	ld	s0,32(sp)
    80001966:	64e2                	ld	s1,24(sp)
    80001968:	6942                	ld	s2,16(sp)
    8000196a:	69a2                	ld	s3,8(sp)
    8000196c:	6a02                	ld	s4,0(sp)
    8000196e:	6145                	addi	sp,sp,48
    80001970:	8082                	ret

0000000080001972 <exit>:
{
    80001972:	7179                	addi	sp,sp,-48
    80001974:	f406                	sd	ra,40(sp)
    80001976:	f022                	sd	s0,32(sp)
    80001978:	ec26                	sd	s1,24(sp)
    8000197a:	e84a                	sd	s2,16(sp)
    8000197c:	e44e                	sd	s3,8(sp)
    8000197e:	e052                	sd	s4,0(sp)
    80001980:	1800                	addi	s0,sp,48
    80001982:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001984:	00000097          	auipc	ra,0x0
    80001988:	80c080e7          	jalr	-2036(ra) # 80001190 <myproc>
    8000198c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000198e:	00007797          	auipc	a5,0x7
    80001992:	f927b783          	ld	a5,-110(a5) # 80008920 <initproc>
    80001996:	0d050493          	addi	s1,a0,208
    8000199a:	15050913          	addi	s2,a0,336
    8000199e:	02a79363          	bne	a5,a0,800019c4 <exit+0x52>
    panic("init exiting");
    800019a2:	00007517          	auipc	a0,0x7
    800019a6:	8a650513          	addi	a0,a0,-1882 # 80008248 <etext+0x248>
    800019aa:	00004097          	auipc	ra,0x4
    800019ae:	7a8080e7          	jalr	1960(ra) # 80006152 <panic>
      fileclose(f);
    800019b2:	00002097          	auipc	ra,0x2
    800019b6:	472080e7          	jalr	1138(ra) # 80003e24 <fileclose>
      p->ofile[fd] = 0;
    800019ba:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800019be:	04a1                	addi	s1,s1,8
    800019c0:	01248563          	beq	s1,s2,800019ca <exit+0x58>
    if(p->ofile[fd]){
    800019c4:	6088                	ld	a0,0(s1)
    800019c6:	f575                	bnez	a0,800019b2 <exit+0x40>
    800019c8:	bfdd                	j	800019be <exit+0x4c>
  begin_op();
    800019ca:	00002097          	auipc	ra,0x2
    800019ce:	f90080e7          	jalr	-112(ra) # 8000395a <begin_op>
  iput(p->cwd);
    800019d2:	1509b503          	ld	a0,336(s3)
    800019d6:	00001097          	auipc	ra,0x1
    800019da:	774080e7          	jalr	1908(ra) # 8000314a <iput>
  end_op();
    800019de:	00002097          	auipc	ra,0x2
    800019e2:	ff6080e7          	jalr	-10(ra) # 800039d4 <end_op>
  p->cwd = 0;
    800019e6:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800019ea:	00227497          	auipc	s1,0x227
    800019ee:	fa648493          	addi	s1,s1,-90 # 80228990 <wait_lock>
    800019f2:	8526                	mv	a0,s1
    800019f4:	00005097          	auipc	ra,0x5
    800019f8:	cd8080e7          	jalr	-808(ra) # 800066cc <acquire>
  reparent(p);
    800019fc:	854e                	mv	a0,s3
    800019fe:	00000097          	auipc	ra,0x0
    80001a02:	f1a080e7          	jalr	-230(ra) # 80001918 <reparent>
  wakeup(p->parent);
    80001a06:	0389b503          	ld	a0,56(s3)
    80001a0a:	00000097          	auipc	ra,0x0
    80001a0e:	e98080e7          	jalr	-360(ra) # 800018a2 <wakeup>
  acquire(&p->lock);
    80001a12:	854e                	mv	a0,s3
    80001a14:	00005097          	auipc	ra,0x5
    80001a18:	cb8080e7          	jalr	-840(ra) # 800066cc <acquire>
  p->xstate = status;
    80001a1c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001a20:	4795                	li	a5,5
    80001a22:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001a26:	8526                	mv	a0,s1
    80001a28:	00005097          	auipc	ra,0x5
    80001a2c:	d58080e7          	jalr	-680(ra) # 80006780 <release>
  sched();
    80001a30:	00000097          	auipc	ra,0x0
    80001a34:	cfc080e7          	jalr	-772(ra) # 8000172c <sched>
  panic("zombie exit");
    80001a38:	00007517          	auipc	a0,0x7
    80001a3c:	82050513          	addi	a0,a0,-2016 # 80008258 <etext+0x258>
    80001a40:	00004097          	auipc	ra,0x4
    80001a44:	712080e7          	jalr	1810(ra) # 80006152 <panic>

0000000080001a48 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a48:	7179                	addi	sp,sp,-48
    80001a4a:	f406                	sd	ra,40(sp)
    80001a4c:	f022                	sd	s0,32(sp)
    80001a4e:	ec26                	sd	s1,24(sp)
    80001a50:	e84a                	sd	s2,16(sp)
    80001a52:	e44e                	sd	s3,8(sp)
    80001a54:	1800                	addi	s0,sp,48
    80001a56:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a58:	00227497          	auipc	s1,0x227
    80001a5c:	35048493          	addi	s1,s1,848 # 80228da8 <proc>
    80001a60:	0022d997          	auipc	s3,0x22d
    80001a64:	d4898993          	addi	s3,s3,-696 # 8022e7a8 <tickslock>
    acquire(&p->lock);
    80001a68:	8526                	mv	a0,s1
    80001a6a:	00005097          	auipc	ra,0x5
    80001a6e:	c62080e7          	jalr	-926(ra) # 800066cc <acquire>
    if(p->pid == pid){
    80001a72:	589c                	lw	a5,48(s1)
    80001a74:	01278d63          	beq	a5,s2,80001a8e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a78:	8526                	mv	a0,s1
    80001a7a:	00005097          	auipc	ra,0x5
    80001a7e:	d06080e7          	jalr	-762(ra) # 80006780 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a82:	16848493          	addi	s1,s1,360
    80001a86:	ff3491e3          	bne	s1,s3,80001a68 <kill+0x20>
  }
  return -1;
    80001a8a:	557d                	li	a0,-1
    80001a8c:	a829                	j	80001aa6 <kill+0x5e>
      p->killed = 1;
    80001a8e:	4785                	li	a5,1
    80001a90:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a92:	4c98                	lw	a4,24(s1)
    80001a94:	4789                	li	a5,2
    80001a96:	00f70f63          	beq	a4,a5,80001ab4 <kill+0x6c>
      release(&p->lock);
    80001a9a:	8526                	mv	a0,s1
    80001a9c:	00005097          	auipc	ra,0x5
    80001aa0:	ce4080e7          	jalr	-796(ra) # 80006780 <release>
      return 0;
    80001aa4:	4501                	li	a0,0
}
    80001aa6:	70a2                	ld	ra,40(sp)
    80001aa8:	7402                	ld	s0,32(sp)
    80001aaa:	64e2                	ld	s1,24(sp)
    80001aac:	6942                	ld	s2,16(sp)
    80001aae:	69a2                	ld	s3,8(sp)
    80001ab0:	6145                	addi	sp,sp,48
    80001ab2:	8082                	ret
        p->state = RUNNABLE;
    80001ab4:	478d                	li	a5,3
    80001ab6:	cc9c                	sw	a5,24(s1)
    80001ab8:	b7cd                	j	80001a9a <kill+0x52>

0000000080001aba <setkilled>:

void
setkilled(struct proc *p)
{
    80001aba:	1101                	addi	sp,sp,-32
    80001abc:	ec06                	sd	ra,24(sp)
    80001abe:	e822                	sd	s0,16(sp)
    80001ac0:	e426                	sd	s1,8(sp)
    80001ac2:	1000                	addi	s0,sp,32
    80001ac4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001ac6:	00005097          	auipc	ra,0x5
    80001aca:	c06080e7          	jalr	-1018(ra) # 800066cc <acquire>
  p->killed = 1;
    80001ace:	4785                	li	a5,1
    80001ad0:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001ad2:	8526                	mv	a0,s1
    80001ad4:	00005097          	auipc	ra,0x5
    80001ad8:	cac080e7          	jalr	-852(ra) # 80006780 <release>
}
    80001adc:	60e2                	ld	ra,24(sp)
    80001ade:	6442                	ld	s0,16(sp)
    80001ae0:	64a2                	ld	s1,8(sp)
    80001ae2:	6105                	addi	sp,sp,32
    80001ae4:	8082                	ret

0000000080001ae6 <killed>:

int
killed(struct proc *p)
{
    80001ae6:	1101                	addi	sp,sp,-32
    80001ae8:	ec06                	sd	ra,24(sp)
    80001aea:	e822                	sd	s0,16(sp)
    80001aec:	e426                	sd	s1,8(sp)
    80001aee:	e04a                	sd	s2,0(sp)
    80001af0:	1000                	addi	s0,sp,32
    80001af2:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001af4:	00005097          	auipc	ra,0x5
    80001af8:	bd8080e7          	jalr	-1064(ra) # 800066cc <acquire>
  k = p->killed;
    80001afc:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001b00:	8526                	mv	a0,s1
    80001b02:	00005097          	auipc	ra,0x5
    80001b06:	c7e080e7          	jalr	-898(ra) # 80006780 <release>
  return k;
}
    80001b0a:	854a                	mv	a0,s2
    80001b0c:	60e2                	ld	ra,24(sp)
    80001b0e:	6442                	ld	s0,16(sp)
    80001b10:	64a2                	ld	s1,8(sp)
    80001b12:	6902                	ld	s2,0(sp)
    80001b14:	6105                	addi	sp,sp,32
    80001b16:	8082                	ret

0000000080001b18 <wait>:
{
    80001b18:	715d                	addi	sp,sp,-80
    80001b1a:	e486                	sd	ra,72(sp)
    80001b1c:	e0a2                	sd	s0,64(sp)
    80001b1e:	fc26                	sd	s1,56(sp)
    80001b20:	f84a                	sd	s2,48(sp)
    80001b22:	f44e                	sd	s3,40(sp)
    80001b24:	f052                	sd	s4,32(sp)
    80001b26:	ec56                	sd	s5,24(sp)
    80001b28:	e85a                	sd	s6,16(sp)
    80001b2a:	e45e                	sd	s7,8(sp)
    80001b2c:	e062                	sd	s8,0(sp)
    80001b2e:	0880                	addi	s0,sp,80
    80001b30:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001b32:	fffff097          	auipc	ra,0xfffff
    80001b36:	65e080e7          	jalr	1630(ra) # 80001190 <myproc>
    80001b3a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001b3c:	00227517          	auipc	a0,0x227
    80001b40:	e5450513          	addi	a0,a0,-428 # 80228990 <wait_lock>
    80001b44:	00005097          	auipc	ra,0x5
    80001b48:	b88080e7          	jalr	-1144(ra) # 800066cc <acquire>
    havekids = 0;
    80001b4c:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001b4e:	4a15                	li	s4,5
        havekids = 1;
    80001b50:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001b52:	0022d997          	auipc	s3,0x22d
    80001b56:	c5698993          	addi	s3,s3,-938 # 8022e7a8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001b5a:	00227c17          	auipc	s8,0x227
    80001b5e:	e36c0c13          	addi	s8,s8,-458 # 80228990 <wait_lock>
    80001b62:	a0d1                	j	80001c26 <wait+0x10e>
          pid = pp->pid;
    80001b64:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001b68:	000b0e63          	beqz	s6,80001b84 <wait+0x6c>
    80001b6c:	4691                	li	a3,4
    80001b6e:	02c48613          	addi	a2,s1,44
    80001b72:	85da                	mv	a1,s6
    80001b74:	05093503          	ld	a0,80(s2)
    80001b78:	fffff097          	auipc	ra,0xfffff
    80001b7c:	222080e7          	jalr	546(ra) # 80000d9a <copyout>
    80001b80:	04054163          	bltz	a0,80001bc2 <wait+0xaa>
          freeproc(pp);
    80001b84:	8526                	mv	a0,s1
    80001b86:	fffff097          	auipc	ra,0xfffff
    80001b8a:	7c0080e7          	jalr	1984(ra) # 80001346 <freeproc>
          release(&pp->lock);
    80001b8e:	8526                	mv	a0,s1
    80001b90:	00005097          	auipc	ra,0x5
    80001b94:	bf0080e7          	jalr	-1040(ra) # 80006780 <release>
          release(&wait_lock);
    80001b98:	00227517          	auipc	a0,0x227
    80001b9c:	df850513          	addi	a0,a0,-520 # 80228990 <wait_lock>
    80001ba0:	00005097          	auipc	ra,0x5
    80001ba4:	be0080e7          	jalr	-1056(ra) # 80006780 <release>
}
    80001ba8:	854e                	mv	a0,s3
    80001baa:	60a6                	ld	ra,72(sp)
    80001bac:	6406                	ld	s0,64(sp)
    80001bae:	74e2                	ld	s1,56(sp)
    80001bb0:	7942                	ld	s2,48(sp)
    80001bb2:	79a2                	ld	s3,40(sp)
    80001bb4:	7a02                	ld	s4,32(sp)
    80001bb6:	6ae2                	ld	s5,24(sp)
    80001bb8:	6b42                	ld	s6,16(sp)
    80001bba:	6ba2                	ld	s7,8(sp)
    80001bbc:	6c02                	ld	s8,0(sp)
    80001bbe:	6161                	addi	sp,sp,80
    80001bc0:	8082                	ret
            release(&pp->lock);
    80001bc2:	8526                	mv	a0,s1
    80001bc4:	00005097          	auipc	ra,0x5
    80001bc8:	bbc080e7          	jalr	-1092(ra) # 80006780 <release>
            release(&wait_lock);
    80001bcc:	00227517          	auipc	a0,0x227
    80001bd0:	dc450513          	addi	a0,a0,-572 # 80228990 <wait_lock>
    80001bd4:	00005097          	auipc	ra,0x5
    80001bd8:	bac080e7          	jalr	-1108(ra) # 80006780 <release>
            return -1;
    80001bdc:	59fd                	li	s3,-1
    80001bde:	b7e9                	j	80001ba8 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001be0:	16848493          	addi	s1,s1,360
    80001be4:	03348463          	beq	s1,s3,80001c0c <wait+0xf4>
      if(pp->parent == p){
    80001be8:	7c9c                	ld	a5,56(s1)
    80001bea:	ff279be3          	bne	a5,s2,80001be0 <wait+0xc8>
        acquire(&pp->lock);
    80001bee:	8526                	mv	a0,s1
    80001bf0:	00005097          	auipc	ra,0x5
    80001bf4:	adc080e7          	jalr	-1316(ra) # 800066cc <acquire>
        if(pp->state == ZOMBIE){
    80001bf8:	4c9c                	lw	a5,24(s1)
    80001bfa:	f74785e3          	beq	a5,s4,80001b64 <wait+0x4c>
        release(&pp->lock);
    80001bfe:	8526                	mv	a0,s1
    80001c00:	00005097          	auipc	ra,0x5
    80001c04:	b80080e7          	jalr	-1152(ra) # 80006780 <release>
        havekids = 1;
    80001c08:	8756                	mv	a4,s5
    80001c0a:	bfd9                	j	80001be0 <wait+0xc8>
    if(!havekids || killed(p)){
    80001c0c:	c31d                	beqz	a4,80001c32 <wait+0x11a>
    80001c0e:	854a                	mv	a0,s2
    80001c10:	00000097          	auipc	ra,0x0
    80001c14:	ed6080e7          	jalr	-298(ra) # 80001ae6 <killed>
    80001c18:	ed09                	bnez	a0,80001c32 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001c1a:	85e2                	mv	a1,s8
    80001c1c:	854a                	mv	a0,s2
    80001c1e:	00000097          	auipc	ra,0x0
    80001c22:	c20080e7          	jalr	-992(ra) # 8000183e <sleep>
    havekids = 0;
    80001c26:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001c28:	00227497          	auipc	s1,0x227
    80001c2c:	18048493          	addi	s1,s1,384 # 80228da8 <proc>
    80001c30:	bf65                	j	80001be8 <wait+0xd0>
      release(&wait_lock);
    80001c32:	00227517          	auipc	a0,0x227
    80001c36:	d5e50513          	addi	a0,a0,-674 # 80228990 <wait_lock>
    80001c3a:	00005097          	auipc	ra,0x5
    80001c3e:	b46080e7          	jalr	-1210(ra) # 80006780 <release>
      return -1;
    80001c42:	59fd                	li	s3,-1
    80001c44:	b795                	j	80001ba8 <wait+0x90>

0000000080001c46 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001c46:	7179                	addi	sp,sp,-48
    80001c48:	f406                	sd	ra,40(sp)
    80001c4a:	f022                	sd	s0,32(sp)
    80001c4c:	ec26                	sd	s1,24(sp)
    80001c4e:	e84a                	sd	s2,16(sp)
    80001c50:	e44e                	sd	s3,8(sp)
    80001c52:	e052                	sd	s4,0(sp)
    80001c54:	1800                	addi	s0,sp,48
    80001c56:	84aa                	mv	s1,a0
    80001c58:	892e                	mv	s2,a1
    80001c5a:	89b2                	mv	s3,a2
    80001c5c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001c5e:	fffff097          	auipc	ra,0xfffff
    80001c62:	532080e7          	jalr	1330(ra) # 80001190 <myproc>
  if(user_dst){
    80001c66:	c08d                	beqz	s1,80001c88 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001c68:	86d2                	mv	a3,s4
    80001c6a:	864e                	mv	a2,s3
    80001c6c:	85ca                	mv	a1,s2
    80001c6e:	6928                	ld	a0,80(a0)
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	12a080e7          	jalr	298(ra) # 80000d9a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001c78:	70a2                	ld	ra,40(sp)
    80001c7a:	7402                	ld	s0,32(sp)
    80001c7c:	64e2                	ld	s1,24(sp)
    80001c7e:	6942                	ld	s2,16(sp)
    80001c80:	69a2                	ld	s3,8(sp)
    80001c82:	6a02                	ld	s4,0(sp)
    80001c84:	6145                	addi	sp,sp,48
    80001c86:	8082                	ret
    memmove((char *)dst, src, len);
    80001c88:	000a061b          	sext.w	a2,s4
    80001c8c:	85ce                	mv	a1,s3
    80001c8e:	854a                	mv	a0,s2
    80001c90:	ffffe097          	auipc	ra,0xffffe
    80001c94:	676080e7          	jalr	1654(ra) # 80000306 <memmove>
    return 0;
    80001c98:	8526                	mv	a0,s1
    80001c9a:	bff9                	j	80001c78 <either_copyout+0x32>

0000000080001c9c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001c9c:	7179                	addi	sp,sp,-48
    80001c9e:	f406                	sd	ra,40(sp)
    80001ca0:	f022                	sd	s0,32(sp)
    80001ca2:	ec26                	sd	s1,24(sp)
    80001ca4:	e84a                	sd	s2,16(sp)
    80001ca6:	e44e                	sd	s3,8(sp)
    80001ca8:	e052                	sd	s4,0(sp)
    80001caa:	1800                	addi	s0,sp,48
    80001cac:	892a                	mv	s2,a0
    80001cae:	84ae                	mv	s1,a1
    80001cb0:	89b2                	mv	s3,a2
    80001cb2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001cb4:	fffff097          	auipc	ra,0xfffff
    80001cb8:	4dc080e7          	jalr	1244(ra) # 80001190 <myproc>
  if(user_src){
    80001cbc:	c08d                	beqz	s1,80001cde <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001cbe:	86d2                	mv	a3,s4
    80001cc0:	864e                	mv	a2,s3
    80001cc2:	85ca                	mv	a1,s2
    80001cc4:	6928                	ld	a0,80(a0)
    80001cc6:	fffff097          	auipc	ra,0xfffff
    80001cca:	1ee080e7          	jalr	494(ra) # 80000eb4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001cce:	70a2                	ld	ra,40(sp)
    80001cd0:	7402                	ld	s0,32(sp)
    80001cd2:	64e2                	ld	s1,24(sp)
    80001cd4:	6942                	ld	s2,16(sp)
    80001cd6:	69a2                	ld	s3,8(sp)
    80001cd8:	6a02                	ld	s4,0(sp)
    80001cda:	6145                	addi	sp,sp,48
    80001cdc:	8082                	ret
    memmove(dst, (char*)src, len);
    80001cde:	000a061b          	sext.w	a2,s4
    80001ce2:	85ce                	mv	a1,s3
    80001ce4:	854a                	mv	a0,s2
    80001ce6:	ffffe097          	auipc	ra,0xffffe
    80001cea:	620080e7          	jalr	1568(ra) # 80000306 <memmove>
    return 0;
    80001cee:	8526                	mv	a0,s1
    80001cf0:	bff9                	j	80001cce <either_copyin+0x32>

0000000080001cf2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001cf2:	715d                	addi	sp,sp,-80
    80001cf4:	e486                	sd	ra,72(sp)
    80001cf6:	e0a2                	sd	s0,64(sp)
    80001cf8:	fc26                	sd	s1,56(sp)
    80001cfa:	f84a                	sd	s2,48(sp)
    80001cfc:	f44e                	sd	s3,40(sp)
    80001cfe:	f052                	sd	s4,32(sp)
    80001d00:	ec56                	sd	s5,24(sp)
    80001d02:	e85a                	sd	s6,16(sp)
    80001d04:	e45e                	sd	s7,8(sp)
    80001d06:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001d08:	00006517          	auipc	a0,0x6
    80001d0c:	31850513          	addi	a0,a0,792 # 80008020 <etext+0x20>
    80001d10:	00004097          	auipc	ra,0x4
    80001d14:	48c080e7          	jalr	1164(ra) # 8000619c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001d18:	00227497          	auipc	s1,0x227
    80001d1c:	1e848493          	addi	s1,s1,488 # 80228f00 <proc+0x158>
    80001d20:	0022d917          	auipc	s2,0x22d
    80001d24:	be090913          	addi	s2,s2,-1056 # 8022e900 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001d28:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001d2a:	00006997          	auipc	s3,0x6
    80001d2e:	53e98993          	addi	s3,s3,1342 # 80008268 <etext+0x268>
    printf("%d %s %s", p->pid, state, p->name);
    80001d32:	00006a97          	auipc	s5,0x6
    80001d36:	53ea8a93          	addi	s5,s5,1342 # 80008270 <etext+0x270>
    printf("\n");
    80001d3a:	00006a17          	auipc	s4,0x6
    80001d3e:	2e6a0a13          	addi	s4,s4,742 # 80008020 <etext+0x20>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001d42:	00007b97          	auipc	s7,0x7
    80001d46:	a66b8b93          	addi	s7,s7,-1434 # 800087a8 <states.0>
    80001d4a:	a00d                	j	80001d6c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001d4c:	ed86a583          	lw	a1,-296(a3)
    80001d50:	8556                	mv	a0,s5
    80001d52:	00004097          	auipc	ra,0x4
    80001d56:	44a080e7          	jalr	1098(ra) # 8000619c <printf>
    printf("\n");
    80001d5a:	8552                	mv	a0,s4
    80001d5c:	00004097          	auipc	ra,0x4
    80001d60:	440080e7          	jalr	1088(ra) # 8000619c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001d64:	16848493          	addi	s1,s1,360
    80001d68:	03248263          	beq	s1,s2,80001d8c <procdump+0x9a>
    if(p->state == UNUSED)
    80001d6c:	86a6                	mv	a3,s1
    80001d6e:	ec04a783          	lw	a5,-320(s1)
    80001d72:	dbed                	beqz	a5,80001d64 <procdump+0x72>
      state = "???";
    80001d74:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001d76:	fcfb6be3          	bltu	s6,a5,80001d4c <procdump+0x5a>
    80001d7a:	02079713          	slli	a4,a5,0x20
    80001d7e:	01d75793          	srli	a5,a4,0x1d
    80001d82:	97de                	add	a5,a5,s7
    80001d84:	6390                	ld	a2,0(a5)
    80001d86:	f279                	bnez	a2,80001d4c <procdump+0x5a>
      state = "???";
    80001d88:	864e                	mv	a2,s3
    80001d8a:	b7c9                	j	80001d4c <procdump+0x5a>
  }
}
    80001d8c:	60a6                	ld	ra,72(sp)
    80001d8e:	6406                	ld	s0,64(sp)
    80001d90:	74e2                	ld	s1,56(sp)
    80001d92:	7942                	ld	s2,48(sp)
    80001d94:	79a2                	ld	s3,40(sp)
    80001d96:	7a02                	ld	s4,32(sp)
    80001d98:	6ae2                	ld	s5,24(sp)
    80001d9a:	6b42                	ld	s6,16(sp)
    80001d9c:	6ba2                	ld	s7,8(sp)
    80001d9e:	6161                	addi	sp,sp,80
    80001da0:	8082                	ret

0000000080001da2 <swtch>:
    80001da2:	00153023          	sd	ra,0(a0)
    80001da6:	00253423          	sd	sp,8(a0)
    80001daa:	e900                	sd	s0,16(a0)
    80001dac:	ed04                	sd	s1,24(a0)
    80001dae:	03253023          	sd	s2,32(a0)
    80001db2:	03353423          	sd	s3,40(a0)
    80001db6:	03453823          	sd	s4,48(a0)
    80001dba:	03553c23          	sd	s5,56(a0)
    80001dbe:	05653023          	sd	s6,64(a0)
    80001dc2:	05753423          	sd	s7,72(a0)
    80001dc6:	05853823          	sd	s8,80(a0)
    80001dca:	05953c23          	sd	s9,88(a0)
    80001dce:	07a53023          	sd	s10,96(a0)
    80001dd2:	07b53423          	sd	s11,104(a0)
    80001dd6:	0005b083          	ld	ra,0(a1)
    80001dda:	0085b103          	ld	sp,8(a1)
    80001dde:	6980                	ld	s0,16(a1)
    80001de0:	6d84                	ld	s1,24(a1)
    80001de2:	0205b903          	ld	s2,32(a1)
    80001de6:	0285b983          	ld	s3,40(a1)
    80001dea:	0305ba03          	ld	s4,48(a1)
    80001dee:	0385ba83          	ld	s5,56(a1)
    80001df2:	0405bb03          	ld	s6,64(a1)
    80001df6:	0485bb83          	ld	s7,72(a1)
    80001dfa:	0505bc03          	ld	s8,80(a1)
    80001dfe:	0585bc83          	ld	s9,88(a1)
    80001e02:	0605bd03          	ld	s10,96(a1)
    80001e06:	0685bd83          	ld	s11,104(a1)
    80001e0a:	8082                	ret

0000000080001e0c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001e0c:	1141                	addi	sp,sp,-16
    80001e0e:	e406                	sd	ra,8(sp)
    80001e10:	e022                	sd	s0,0(sp)
    80001e12:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001e14:	00006597          	auipc	a1,0x6
    80001e18:	49c58593          	addi	a1,a1,1180 # 800082b0 <etext+0x2b0>
    80001e1c:	0022d517          	auipc	a0,0x22d
    80001e20:	98c50513          	addi	a0,a0,-1652 # 8022e7a8 <tickslock>
    80001e24:	00005097          	auipc	ra,0x5
    80001e28:	818080e7          	jalr	-2024(ra) # 8000663c <initlock>
}
    80001e2c:	60a2                	ld	ra,8(sp)
    80001e2e:	6402                	ld	s0,0(sp)
    80001e30:	0141                	addi	sp,sp,16
    80001e32:	8082                	ret

0000000080001e34 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001e34:	1141                	addi	sp,sp,-16
    80001e36:	e422                	sd	s0,8(sp)
    80001e38:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e3a:	00003797          	auipc	a5,0x3
    80001e3e:	6e678793          	addi	a5,a5,1766 # 80005520 <kernelvec>
    80001e42:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001e46:	6422                	ld	s0,8(sp)
    80001e48:	0141                	addi	sp,sp,16
    80001e4a:	8082                	ret

0000000080001e4c <perform_cow>:
// called from trampoline.S
//

int perform_cow (pagetable_t pagetable, uint64 start_va){

    if(start_va >= MAXVA){
    80001e4c:	57fd                	li	a5,-1
    80001e4e:	83e9                	srli	a5,a5,0x1a
    80001e50:	00b7f463          	bgeu	a5,a1,80001e58 <perform_cow+0xc>
      return -1;
    80001e54:	557d                	li	a0,-1
      return -1;
    }
    kfree((void *)pa);
    return 1;

}
    80001e56:	8082                	ret
int perform_cow (pagetable_t pagetable, uint64 start_va){
    80001e58:	7139                	addi	sp,sp,-64
    80001e5a:	fc06                	sd	ra,56(sp)
    80001e5c:	f822                	sd	s0,48(sp)
    80001e5e:	f426                	sd	s1,40(sp)
    80001e60:	f04a                	sd	s2,32(sp)
    80001e62:	0080                	addi	s0,sp,64
    80001e64:	892a                	mv	s2,a0
    80001e66:	84ae                	mv	s1,a1
    pte_t* pte = walk(pagetable,start_va,0);
    80001e68:	4601                	li	a2,0
    80001e6a:	ffffe097          	auipc	ra,0xffffe
    80001e6e:	71c080e7          	jalr	1820(ra) # 80000586 <walk>
    80001e72:	87aa                	mv	a5,a0
    if(pte == 0){
    80001e74:	cd5d                	beqz	a0,80001f32 <perform_cow+0xe6>
    if((*pte &PTE_V) == 0) return -1;
    80001e76:	6118                	ld	a4,0(a0)
    80001e78:	00177693          	andi	a3,a4,1
    80001e7c:	557d                	li	a0,-1
    80001e7e:	c689                	beqz	a3,80001e88 <perform_cow+0x3c>
    if((*pte & PTE_COW) == 0) return 0;
    80001e80:	10077693          	andi	a3,a4,256
    80001e84:	4501                	li	a0,0
    80001e86:	e699                	bnez	a3,80001e94 <perform_cow+0x48>
}
    80001e88:	70e2                	ld	ra,56(sp)
    80001e8a:	7442                	ld	s0,48(sp)
    80001e8c:	74a2                	ld	s1,40(sp)
    80001e8e:	7902                	ld	s2,32(sp)
    80001e90:	6121                	addi	sp,sp,64
    80001e92:	8082                	ret
    80001e94:	ec4e                	sd	s3,24(sp)
    80001e96:	e852                	sd	s4,16(sp)
    80001e98:	e456                	sd	s5,8(sp)
    uint64 pa = PTE2PA(*pte);
    80001e9a:	00a75a93          	srli	s5,a4,0xa
    80001e9e:	0ab2                	slli	s5,s5,0xc
    *pte = *pte & (~PTE_COW );
    80001ea0:	eff77713          	andi	a4,a4,-257
    *pte = *pte | (PTE_W);
    80001ea4:	00476713          	ori	a4,a4,4
    80001ea8:	e398                	sd	a4,0(a5)
    uint flags = PTE_FLAGS(*pte);
    80001eaa:	2ff77993          	andi	s3,a4,767
    if((mem = kalloc()) == 0){
    80001eae:	ffffe097          	auipc	ra,0xffffe
    80001eb2:	2d2080e7          	jalr	722(ra) # 80000180 <kalloc>
    80001eb6:	8a2a                	mv	s4,a0
    80001eb8:	c139                	beqz	a0,80001efe <perform_cow+0xb2>
    memmove(mem, (char*)pa, PGSIZE);
    80001eba:	6605                	lui	a2,0x1
    80001ebc:	85d6                	mv	a1,s5
    80001ebe:	ffffe097          	auipc	ra,0xffffe
    80001ec2:	448080e7          	jalr	1096(ra) # 80000306 <memmove>
    uvmunmap(pagetable,start_va,1,0);
    80001ec6:	4681                	li	a3,0
    80001ec8:	4605                	li	a2,1
    80001eca:	85a6                	mv	a1,s1
    80001ecc:	854a                	mv	a0,s2
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	98a080e7          	jalr	-1654(ra) # 80000858 <uvmunmap>
    if(mappages(pagetable,start_va,PGSIZE,(uint64)mem,flags) != 0){
    80001ed6:	874e                	mv	a4,s3
    80001ed8:	86d2                	mv	a3,s4
    80001eda:	6605                	lui	a2,0x1
    80001edc:	85a6                	mv	a1,s1
    80001ede:	854a                	mv	a0,s2
    80001ee0:	ffffe097          	auipc	ra,0xffffe
    80001ee4:	78e080e7          	jalr	1934(ra) # 8000066e <mappages>
    80001ee8:	e91d                	bnez	a0,80001f1e <perform_cow+0xd2>
    kfree((void *)pa);
    80001eea:	8556                	mv	a0,s5
    80001eec:	ffffe097          	auipc	ra,0xffffe
    80001ef0:	130080e7          	jalr	304(ra) # 8000001c <kfree>
    return 1;
    80001ef4:	4505                	li	a0,1
    80001ef6:	69e2                	ld	s3,24(sp)
    80001ef8:	6a42                	ld	s4,16(sp)
    80001efa:	6aa2                	ld	s5,8(sp)
    80001efc:	b771                	j	80001e88 <perform_cow+0x3c>
      myproc()->killed = 1;
    80001efe:	fffff097          	auipc	ra,0xfffff
    80001f02:	292080e7          	jalr	658(ra) # 80001190 <myproc>
    80001f06:	4785                	li	a5,1
    80001f08:	d51c                	sw	a5,40(a0)
      exit(-1);
    80001f0a:	557d                	li	a0,-1
    80001f0c:	00000097          	auipc	ra,0x0
    80001f10:	a66080e7          	jalr	-1434(ra) # 80001972 <exit>
      return -1;
    80001f14:	557d                	li	a0,-1
    80001f16:	69e2                	ld	s3,24(sp)
    80001f18:	6a42                	ld	s4,16(sp)
    80001f1a:	6aa2                	ld	s5,8(sp)
    80001f1c:	b7b5                	j	80001e88 <perform_cow+0x3c>
      kfree(mem);
    80001f1e:	8552                	mv	a0,s4
    80001f20:	ffffe097          	auipc	ra,0xffffe
    80001f24:	0fc080e7          	jalr	252(ra) # 8000001c <kfree>
      return -1;
    80001f28:	557d                	li	a0,-1
    80001f2a:	69e2                	ld	s3,24(sp)
    80001f2c:	6a42                	ld	s4,16(sp)
    80001f2e:	6aa2                	ld	s5,8(sp)
    80001f30:	bfa1                	j	80001e88 <perform_cow+0x3c>
      return -1;
    80001f32:	557d                	li	a0,-1
    80001f34:	bf91                	j	80001e88 <perform_cow+0x3c>

0000000080001f36 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001f36:	1141                	addi	sp,sp,-16
    80001f38:	e406                	sd	ra,8(sp)
    80001f3a:	e022                	sd	s0,0(sp)
    80001f3c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001f3e:	fffff097          	auipc	ra,0xfffff
    80001f42:	252080e7          	jalr	594(ra) # 80001190 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f46:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001f4a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f4c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001f50:	00005697          	auipc	a3,0x5
    80001f54:	0b068693          	addi	a3,a3,176 # 80007000 <_trampoline>
    80001f58:	00005717          	auipc	a4,0x5
    80001f5c:	0a870713          	addi	a4,a4,168 # 80007000 <_trampoline>
    80001f60:	8f15                	sub	a4,a4,a3
    80001f62:	040007b7          	lui	a5,0x4000
    80001f66:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001f68:	07b2                	slli	a5,a5,0xc
    80001f6a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f6c:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001f70:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001f72:	18002673          	csrr	a2,satp
    80001f76:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001f78:	6d30                	ld	a2,88(a0)
    80001f7a:	6138                	ld	a4,64(a0)
    80001f7c:	6585                	lui	a1,0x1
    80001f7e:	972e                	add	a4,a4,a1
    80001f80:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001f82:	6d38                	ld	a4,88(a0)
    80001f84:	00000617          	auipc	a2,0x0
    80001f88:	13860613          	addi	a2,a2,312 # 800020bc <usertrap>
    80001f8c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001f8e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f90:	8612                	mv	a2,tp
    80001f92:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f94:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001f98:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001f9c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fa0:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001fa4:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001fa6:	6f18                	ld	a4,24(a4)
    80001fa8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001fac:	6928                	ld	a0,80(a0)
    80001fae:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001fb0:	00005717          	auipc	a4,0x5
    80001fb4:	0ec70713          	addi	a4,a4,236 # 8000709c <userret>
    80001fb8:	8f15                	sub	a4,a4,a3
    80001fba:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001fbc:	577d                	li	a4,-1
    80001fbe:	177e                	slli	a4,a4,0x3f
    80001fc0:	8d59                	or	a0,a0,a4
    80001fc2:	9782                	jalr	a5
}
    80001fc4:	60a2                	ld	ra,8(sp)
    80001fc6:	6402                	ld	s0,0(sp)
    80001fc8:	0141                	addi	sp,sp,16
    80001fca:	8082                	ret

0000000080001fcc <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001fcc:	1101                	addi	sp,sp,-32
    80001fce:	ec06                	sd	ra,24(sp)
    80001fd0:	e822                	sd	s0,16(sp)
    80001fd2:	e426                	sd	s1,8(sp)
    80001fd4:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001fd6:	0022c497          	auipc	s1,0x22c
    80001fda:	7d248493          	addi	s1,s1,2002 # 8022e7a8 <tickslock>
    80001fde:	8526                	mv	a0,s1
    80001fe0:	00004097          	auipc	ra,0x4
    80001fe4:	6ec080e7          	jalr	1772(ra) # 800066cc <acquire>
  ticks++;
    80001fe8:	00007517          	auipc	a0,0x7
    80001fec:	94050513          	addi	a0,a0,-1728 # 80008928 <ticks>
    80001ff0:	411c                	lw	a5,0(a0)
    80001ff2:	2785                	addiw	a5,a5,1
    80001ff4:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001ff6:	00000097          	auipc	ra,0x0
    80001ffa:	8ac080e7          	jalr	-1876(ra) # 800018a2 <wakeup>
  release(&tickslock);
    80001ffe:	8526                	mv	a0,s1
    80002000:	00004097          	auipc	ra,0x4
    80002004:	780080e7          	jalr	1920(ra) # 80006780 <release>
}
    80002008:	60e2                	ld	ra,24(sp)
    8000200a:	6442                	ld	s0,16(sp)
    8000200c:	64a2                	ld	s1,8(sp)
    8000200e:	6105                	addi	sp,sp,32
    80002010:	8082                	ret

0000000080002012 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002012:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002016:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80002018:	0a07d163          	bgez	a5,800020ba <devintr+0xa8>
{
    8000201c:	1101                	addi	sp,sp,-32
    8000201e:	ec06                	sd	ra,24(sp)
    80002020:	e822                	sd	s0,16(sp)
    80002022:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80002024:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002028:	46a5                	li	a3,9
    8000202a:	00d70c63          	beq	a4,a3,80002042 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    8000202e:	577d                	li	a4,-1
    80002030:	177e                	slli	a4,a4,0x3f
    80002032:	0705                	addi	a4,a4,1
    return 0;
    80002034:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002036:	06e78163          	beq	a5,a4,80002098 <devintr+0x86>
  }
}
    8000203a:	60e2                	ld	ra,24(sp)
    8000203c:	6442                	ld	s0,16(sp)
    8000203e:	6105                	addi	sp,sp,32
    80002040:	8082                	ret
    80002042:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002044:	00003097          	auipc	ra,0x3
    80002048:	5e8080e7          	jalr	1512(ra) # 8000562c <plic_claim>
    8000204c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000204e:	47a9                	li	a5,10
    80002050:	00f50963          	beq	a0,a5,80002062 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80002054:	4785                	li	a5,1
    80002056:	00f50b63          	beq	a0,a5,8000206c <devintr+0x5a>
    return 1;
    8000205a:	4505                	li	a0,1
    } else if(irq){
    8000205c:	ec89                	bnez	s1,80002076 <devintr+0x64>
    8000205e:	64a2                	ld	s1,8(sp)
    80002060:	bfe9                	j	8000203a <devintr+0x28>
      uartintr();
    80002062:	00004097          	auipc	ra,0x4
    80002066:	58a080e7          	jalr	1418(ra) # 800065ec <uartintr>
    if(irq)
    8000206a:	a839                	j	80002088 <devintr+0x76>
      virtio_disk_intr();
    8000206c:	00004097          	auipc	ra,0x4
    80002070:	aea080e7          	jalr	-1302(ra) # 80005b56 <virtio_disk_intr>
    if(irq)
    80002074:	a811                	j	80002088 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80002076:	85a6                	mv	a1,s1
    80002078:	00006517          	auipc	a0,0x6
    8000207c:	24050513          	addi	a0,a0,576 # 800082b8 <etext+0x2b8>
    80002080:	00004097          	auipc	ra,0x4
    80002084:	11c080e7          	jalr	284(ra) # 8000619c <printf>
      plic_complete(irq);
    80002088:	8526                	mv	a0,s1
    8000208a:	00003097          	auipc	ra,0x3
    8000208e:	5c6080e7          	jalr	1478(ra) # 80005650 <plic_complete>
    return 1;
    80002092:	4505                	li	a0,1
    80002094:	64a2                	ld	s1,8(sp)
    80002096:	b755                	j	8000203a <devintr+0x28>
    if(cpuid() == 0){
    80002098:	fffff097          	auipc	ra,0xfffff
    8000209c:	0cc080e7          	jalr	204(ra) # 80001164 <cpuid>
    800020a0:	c901                	beqz	a0,800020b0 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800020a2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800020a6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800020a8:	14479073          	csrw	sip,a5
    return 2;
    800020ac:	4509                	li	a0,2
    800020ae:	b771                	j	8000203a <devintr+0x28>
      clockintr();
    800020b0:	00000097          	auipc	ra,0x0
    800020b4:	f1c080e7          	jalr	-228(ra) # 80001fcc <clockintr>
    800020b8:	b7ed                	j	800020a2 <devintr+0x90>
}
    800020ba:	8082                	ret

00000000800020bc <usertrap>:
{
    800020bc:	1101                	addi	sp,sp,-32
    800020be:	ec06                	sd	ra,24(sp)
    800020c0:	e822                	sd	s0,16(sp)
    800020c2:	e426                	sd	s1,8(sp)
    800020c4:	e04a                	sd	s2,0(sp)
    800020c6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020c8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800020cc:	1007f793          	andi	a5,a5,256
    800020d0:	efb5                	bnez	a5,8000214c <usertrap+0x90>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800020d2:	00003797          	auipc	a5,0x3
    800020d6:	44e78793          	addi	a5,a5,1102 # 80005520 <kernelvec>
    800020da:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800020de:	fffff097          	auipc	ra,0xfffff
    800020e2:	0b2080e7          	jalr	178(ra) # 80001190 <myproc>
    800020e6:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800020e8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020ea:	14102773          	csrr	a4,sepc
    800020ee:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800020f0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800020f4:	47a1                	li	a5,8
    800020f6:	06f70363          	beq	a4,a5,8000215c <usertrap+0xa0>
    800020fa:	14202773          	csrr	a4,scause
  else if(r_scause() == 13 || r_scause() == 15 ){
    800020fe:	47b5                	li	a5,13
    80002100:	00f70763          	beq	a4,a5,8000210e <usertrap+0x52>
    80002104:	14202773          	csrr	a4,scause
    80002108:	47bd                	li	a5,15
    8000210a:	0af71463          	bne	a4,a5,800021b2 <usertrap+0xf6>
    if(perform_cow(myproc()->pagetable, PGROUNDDOWN(r_stval())) <= 0){
    8000210e:	fffff097          	auipc	ra,0xfffff
    80002112:	082080e7          	jalr	130(ra) # 80001190 <myproc>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002116:	143025f3          	csrr	a1,stval
    8000211a:	77fd                	lui	a5,0xfffff
    8000211c:	8dfd                	and	a1,a1,a5
    8000211e:	6928                	ld	a0,80(a0)
    80002120:	00000097          	auipc	ra,0x0
    80002124:	d2c080e7          	jalr	-724(ra) # 80001e4c <perform_cow>
    80002128:	06a05463          	blez	a0,80002190 <usertrap+0xd4>
  if(killed(p))
    8000212c:	8526                	mv	a0,s1
    8000212e:	00000097          	auipc	ra,0x0
    80002132:	9b8080e7          	jalr	-1608(ra) # 80001ae6 <killed>
    80002136:	e961                	bnez	a0,80002206 <usertrap+0x14a>
  usertrapret();
    80002138:	00000097          	auipc	ra,0x0
    8000213c:	dfe080e7          	jalr	-514(ra) # 80001f36 <usertrapret>
}
    80002140:	60e2                	ld	ra,24(sp)
    80002142:	6442                	ld	s0,16(sp)
    80002144:	64a2                	ld	s1,8(sp)
    80002146:	6902                	ld	s2,0(sp)
    80002148:	6105                	addi	sp,sp,32
    8000214a:	8082                	ret
    panic("usertrap: not from user mode");
    8000214c:	00006517          	auipc	a0,0x6
    80002150:	18c50513          	addi	a0,a0,396 # 800082d8 <etext+0x2d8>
    80002154:	00004097          	auipc	ra,0x4
    80002158:	ffe080e7          	jalr	-2(ra) # 80006152 <panic>
    if(killed(p))
    8000215c:	00000097          	auipc	ra,0x0
    80002160:	98a080e7          	jalr	-1654(ra) # 80001ae6 <killed>
    80002164:	e105                	bnez	a0,80002184 <usertrap+0xc8>
    p->trapframe->epc += 4;
    80002166:	6cb8                	ld	a4,88(s1)
    80002168:	6f1c                	ld	a5,24(a4)
    8000216a:	0791                	addi	a5,a5,4 # fffffffffffff004 <end+0xffffffff7fdbd234>
    8000216c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000216e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002172:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002176:	10079073          	csrw	sstatus,a5
    syscall();
    8000217a:	00000097          	auipc	ra,0x0
    8000217e:	2f2080e7          	jalr	754(ra) # 8000246c <syscall>
    80002182:	b76d                	j	8000212c <usertrap+0x70>
      exit(-1);
    80002184:	557d                	li	a0,-1
    80002186:	fffff097          	auipc	ra,0xfffff
    8000218a:	7ec080e7          	jalr	2028(ra) # 80001972 <exit>
    8000218e:	bfe1                	j	80002166 <usertrap+0xaa>
      printf("error cow page\n");
    80002190:	00006517          	auipc	a0,0x6
    80002194:	16850513          	addi	a0,a0,360 # 800082f8 <etext+0x2f8>
    80002198:	00004097          	auipc	ra,0x4
    8000219c:	004080e7          	jalr	4(ra) # 8000619c <printf>
      setkilled(myproc());
    800021a0:	fffff097          	auipc	ra,0xfffff
    800021a4:	ff0080e7          	jalr	-16(ra) # 80001190 <myproc>
    800021a8:	00000097          	auipc	ra,0x0
    800021ac:	912080e7          	jalr	-1774(ra) # 80001aba <setkilled>
    800021b0:	bfb5                	j	8000212c <usertrap+0x70>
  else if((which_dev = devintr()) != 0){
    800021b2:	00000097          	auipc	ra,0x0
    800021b6:	e60080e7          	jalr	-416(ra) # 80002012 <devintr>
    800021ba:	892a                	mv	s2,a0
    800021bc:	c901                	beqz	a0,800021cc <usertrap+0x110>
  if(killed(p))
    800021be:	8526                	mv	a0,s1
    800021c0:	00000097          	auipc	ra,0x0
    800021c4:	926080e7          	jalr	-1754(ra) # 80001ae6 <killed>
    800021c8:	c529                	beqz	a0,80002212 <usertrap+0x156>
    800021ca:	a83d                	j	80002208 <usertrap+0x14c>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800021cc:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800021d0:	5890                	lw	a2,48(s1)
    800021d2:	00006517          	auipc	a0,0x6
    800021d6:	13650513          	addi	a0,a0,310 # 80008308 <etext+0x308>
    800021da:	00004097          	auipc	ra,0x4
    800021de:	fc2080e7          	jalr	-62(ra) # 8000619c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800021e2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800021e6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800021ea:	00006517          	auipc	a0,0x6
    800021ee:	14e50513          	addi	a0,a0,334 # 80008338 <etext+0x338>
    800021f2:	00004097          	auipc	ra,0x4
    800021f6:	faa080e7          	jalr	-86(ra) # 8000619c <printf>
    setkilled(p);
    800021fa:	8526                	mv	a0,s1
    800021fc:	00000097          	auipc	ra,0x0
    80002200:	8be080e7          	jalr	-1858(ra) # 80001aba <setkilled>
    80002204:	b725                	j	8000212c <usertrap+0x70>
  if(killed(p))
    80002206:	4901                	li	s2,0
    exit(-1);
    80002208:	557d                	li	a0,-1
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	768080e7          	jalr	1896(ra) # 80001972 <exit>
  if(which_dev == 2)
    80002212:	4789                	li	a5,2
    80002214:	f2f912e3          	bne	s2,a5,80002138 <usertrap+0x7c>
    yield();
    80002218:	fffff097          	auipc	ra,0xfffff
    8000221c:	5ea080e7          	jalr	1514(ra) # 80001802 <yield>
    80002220:	bf21                	j	80002138 <usertrap+0x7c>

0000000080002222 <kerneltrap>:
{
    80002222:	7179                	addi	sp,sp,-48
    80002224:	f406                	sd	ra,40(sp)
    80002226:	f022                	sd	s0,32(sp)
    80002228:	ec26                	sd	s1,24(sp)
    8000222a:	e84a                	sd	s2,16(sp)
    8000222c:	e44e                	sd	s3,8(sp)
    8000222e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002230:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002234:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002238:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000223c:	1004f793          	andi	a5,s1,256
    80002240:	cb85                	beqz	a5,80002270 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002242:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002246:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002248:	ef85                	bnez	a5,80002280 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    8000224a:	00000097          	auipc	ra,0x0
    8000224e:	dc8080e7          	jalr	-568(ra) # 80002012 <devintr>
    80002252:	cd1d                	beqz	a0,80002290 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002254:	4789                	li	a5,2
    80002256:	06f50a63          	beq	a0,a5,800022ca <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000225a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000225e:	10049073          	csrw	sstatus,s1
}
    80002262:	70a2                	ld	ra,40(sp)
    80002264:	7402                	ld	s0,32(sp)
    80002266:	64e2                	ld	s1,24(sp)
    80002268:	6942                	ld	s2,16(sp)
    8000226a:	69a2                	ld	s3,8(sp)
    8000226c:	6145                	addi	sp,sp,48
    8000226e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002270:	00006517          	auipc	a0,0x6
    80002274:	0e850513          	addi	a0,a0,232 # 80008358 <etext+0x358>
    80002278:	00004097          	auipc	ra,0x4
    8000227c:	eda080e7          	jalr	-294(ra) # 80006152 <panic>
    panic("kerneltrap: interrupts enabled");
    80002280:	00006517          	auipc	a0,0x6
    80002284:	10050513          	addi	a0,a0,256 # 80008380 <etext+0x380>
    80002288:	00004097          	auipc	ra,0x4
    8000228c:	eca080e7          	jalr	-310(ra) # 80006152 <panic>
    printf("scause %p\n", scause);
    80002290:	85ce                	mv	a1,s3
    80002292:	00006517          	auipc	a0,0x6
    80002296:	10e50513          	addi	a0,a0,270 # 800083a0 <etext+0x3a0>
    8000229a:	00004097          	auipc	ra,0x4
    8000229e:	f02080e7          	jalr	-254(ra) # 8000619c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800022a2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800022a6:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800022aa:	00006517          	auipc	a0,0x6
    800022ae:	10650513          	addi	a0,a0,262 # 800083b0 <etext+0x3b0>
    800022b2:	00004097          	auipc	ra,0x4
    800022b6:	eea080e7          	jalr	-278(ra) # 8000619c <printf>
    panic("kerneltrap");
    800022ba:	00006517          	auipc	a0,0x6
    800022be:	10e50513          	addi	a0,a0,270 # 800083c8 <etext+0x3c8>
    800022c2:	00004097          	auipc	ra,0x4
    800022c6:	e90080e7          	jalr	-368(ra) # 80006152 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	ec6080e7          	jalr	-314(ra) # 80001190 <myproc>
    800022d2:	d541                	beqz	a0,8000225a <kerneltrap+0x38>
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	ebc080e7          	jalr	-324(ra) # 80001190 <myproc>
    800022dc:	4d18                	lw	a4,24(a0)
    800022de:	4791                	li	a5,4
    800022e0:	f6f71de3          	bne	a4,a5,8000225a <kerneltrap+0x38>
    yield();
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	51e080e7          	jalr	1310(ra) # 80001802 <yield>
    800022ec:	b7bd                	j	8000225a <kerneltrap+0x38>

00000000800022ee <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800022ee:	1101                	addi	sp,sp,-32
    800022f0:	ec06                	sd	ra,24(sp)
    800022f2:	e822                	sd	s0,16(sp)
    800022f4:	e426                	sd	s1,8(sp)
    800022f6:	1000                	addi	s0,sp,32
    800022f8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800022fa:	fffff097          	auipc	ra,0xfffff
    800022fe:	e96080e7          	jalr	-362(ra) # 80001190 <myproc>
  switch (n) {
    80002302:	4795                	li	a5,5
    80002304:	0497e163          	bltu	a5,s1,80002346 <argraw+0x58>
    80002308:	048a                	slli	s1,s1,0x2
    8000230a:	00006717          	auipc	a4,0x6
    8000230e:	4ce70713          	addi	a4,a4,1230 # 800087d8 <states.0+0x30>
    80002312:	94ba                	add	s1,s1,a4
    80002314:	409c                	lw	a5,0(s1)
    80002316:	97ba                	add	a5,a5,a4
    80002318:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000231a:	6d3c                	ld	a5,88(a0)
    8000231c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000231e:	60e2                	ld	ra,24(sp)
    80002320:	6442                	ld	s0,16(sp)
    80002322:	64a2                	ld	s1,8(sp)
    80002324:	6105                	addi	sp,sp,32
    80002326:	8082                	ret
    return p->trapframe->a1;
    80002328:	6d3c                	ld	a5,88(a0)
    8000232a:	7fa8                	ld	a0,120(a5)
    8000232c:	bfcd                	j	8000231e <argraw+0x30>
    return p->trapframe->a2;
    8000232e:	6d3c                	ld	a5,88(a0)
    80002330:	63c8                	ld	a0,128(a5)
    80002332:	b7f5                	j	8000231e <argraw+0x30>
    return p->trapframe->a3;
    80002334:	6d3c                	ld	a5,88(a0)
    80002336:	67c8                	ld	a0,136(a5)
    80002338:	b7dd                	j	8000231e <argraw+0x30>
    return p->trapframe->a4;
    8000233a:	6d3c                	ld	a5,88(a0)
    8000233c:	6bc8                	ld	a0,144(a5)
    8000233e:	b7c5                	j	8000231e <argraw+0x30>
    return p->trapframe->a5;
    80002340:	6d3c                	ld	a5,88(a0)
    80002342:	6fc8                	ld	a0,152(a5)
    80002344:	bfe9                	j	8000231e <argraw+0x30>
  panic("argraw");
    80002346:	00006517          	auipc	a0,0x6
    8000234a:	09250513          	addi	a0,a0,146 # 800083d8 <etext+0x3d8>
    8000234e:	00004097          	auipc	ra,0x4
    80002352:	e04080e7          	jalr	-508(ra) # 80006152 <panic>

0000000080002356 <fetchaddr>:
{
    80002356:	1101                	addi	sp,sp,-32
    80002358:	ec06                	sd	ra,24(sp)
    8000235a:	e822                	sd	s0,16(sp)
    8000235c:	e426                	sd	s1,8(sp)
    8000235e:	e04a                	sd	s2,0(sp)
    80002360:	1000                	addi	s0,sp,32
    80002362:	84aa                	mv	s1,a0
    80002364:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002366:	fffff097          	auipc	ra,0xfffff
    8000236a:	e2a080e7          	jalr	-470(ra) # 80001190 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000236e:	653c                	ld	a5,72(a0)
    80002370:	02f4f863          	bgeu	s1,a5,800023a0 <fetchaddr+0x4a>
    80002374:	00848713          	addi	a4,s1,8
    80002378:	02e7e663          	bltu	a5,a4,800023a4 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000237c:	46a1                	li	a3,8
    8000237e:	8626                	mv	a2,s1
    80002380:	85ca                	mv	a1,s2
    80002382:	6928                	ld	a0,80(a0)
    80002384:	fffff097          	auipc	ra,0xfffff
    80002388:	b30080e7          	jalr	-1232(ra) # 80000eb4 <copyin>
    8000238c:	00a03533          	snez	a0,a0
    80002390:	40a00533          	neg	a0,a0
}
    80002394:	60e2                	ld	ra,24(sp)
    80002396:	6442                	ld	s0,16(sp)
    80002398:	64a2                	ld	s1,8(sp)
    8000239a:	6902                	ld	s2,0(sp)
    8000239c:	6105                	addi	sp,sp,32
    8000239e:	8082                	ret
    return -1;
    800023a0:	557d                	li	a0,-1
    800023a2:	bfcd                	j	80002394 <fetchaddr+0x3e>
    800023a4:	557d                	li	a0,-1
    800023a6:	b7fd                	j	80002394 <fetchaddr+0x3e>

00000000800023a8 <fetchstr>:
{
    800023a8:	7179                	addi	sp,sp,-48
    800023aa:	f406                	sd	ra,40(sp)
    800023ac:	f022                	sd	s0,32(sp)
    800023ae:	ec26                	sd	s1,24(sp)
    800023b0:	e84a                	sd	s2,16(sp)
    800023b2:	e44e                	sd	s3,8(sp)
    800023b4:	1800                	addi	s0,sp,48
    800023b6:	892a                	mv	s2,a0
    800023b8:	84ae                	mv	s1,a1
    800023ba:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800023bc:	fffff097          	auipc	ra,0xfffff
    800023c0:	dd4080e7          	jalr	-556(ra) # 80001190 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800023c4:	86ce                	mv	a3,s3
    800023c6:	864a                	mv	a2,s2
    800023c8:	85a6                	mv	a1,s1
    800023ca:	6928                	ld	a0,80(a0)
    800023cc:	fffff097          	auipc	ra,0xfffff
    800023d0:	b76080e7          	jalr	-1162(ra) # 80000f42 <copyinstr>
    800023d4:	00054e63          	bltz	a0,800023f0 <fetchstr+0x48>
  return strlen(buf);
    800023d8:	8526                	mv	a0,s1
    800023da:	ffffe097          	auipc	ra,0xffffe
    800023de:	044080e7          	jalr	68(ra) # 8000041e <strlen>
}
    800023e2:	70a2                	ld	ra,40(sp)
    800023e4:	7402                	ld	s0,32(sp)
    800023e6:	64e2                	ld	s1,24(sp)
    800023e8:	6942                	ld	s2,16(sp)
    800023ea:	69a2                	ld	s3,8(sp)
    800023ec:	6145                	addi	sp,sp,48
    800023ee:	8082                	ret
    return -1;
    800023f0:	557d                	li	a0,-1
    800023f2:	bfc5                	j	800023e2 <fetchstr+0x3a>

00000000800023f4 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800023f4:	1101                	addi	sp,sp,-32
    800023f6:	ec06                	sd	ra,24(sp)
    800023f8:	e822                	sd	s0,16(sp)
    800023fa:	e426                	sd	s1,8(sp)
    800023fc:	1000                	addi	s0,sp,32
    800023fe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002400:	00000097          	auipc	ra,0x0
    80002404:	eee080e7          	jalr	-274(ra) # 800022ee <argraw>
    80002408:	c088                	sw	a0,0(s1)
}
    8000240a:	60e2                	ld	ra,24(sp)
    8000240c:	6442                	ld	s0,16(sp)
    8000240e:	64a2                	ld	s1,8(sp)
    80002410:	6105                	addi	sp,sp,32
    80002412:	8082                	ret

0000000080002414 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002414:	1101                	addi	sp,sp,-32
    80002416:	ec06                	sd	ra,24(sp)
    80002418:	e822                	sd	s0,16(sp)
    8000241a:	e426                	sd	s1,8(sp)
    8000241c:	1000                	addi	s0,sp,32
    8000241e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002420:	00000097          	auipc	ra,0x0
    80002424:	ece080e7          	jalr	-306(ra) # 800022ee <argraw>
    80002428:	e088                	sd	a0,0(s1)
}
    8000242a:	60e2                	ld	ra,24(sp)
    8000242c:	6442                	ld	s0,16(sp)
    8000242e:	64a2                	ld	s1,8(sp)
    80002430:	6105                	addi	sp,sp,32
    80002432:	8082                	ret

0000000080002434 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002434:	7179                	addi	sp,sp,-48
    80002436:	f406                	sd	ra,40(sp)
    80002438:	f022                	sd	s0,32(sp)
    8000243a:	ec26                	sd	s1,24(sp)
    8000243c:	e84a                	sd	s2,16(sp)
    8000243e:	1800                	addi	s0,sp,48
    80002440:	84ae                	mv	s1,a1
    80002442:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002444:	fd840593          	addi	a1,s0,-40
    80002448:	00000097          	auipc	ra,0x0
    8000244c:	fcc080e7          	jalr	-52(ra) # 80002414 <argaddr>
  return fetchstr(addr, buf, max);
    80002450:	864a                	mv	a2,s2
    80002452:	85a6                	mv	a1,s1
    80002454:	fd843503          	ld	a0,-40(s0)
    80002458:	00000097          	auipc	ra,0x0
    8000245c:	f50080e7          	jalr	-176(ra) # 800023a8 <fetchstr>
}
    80002460:	70a2                	ld	ra,40(sp)
    80002462:	7402                	ld	s0,32(sp)
    80002464:	64e2                	ld	s1,24(sp)
    80002466:	6942                	ld	s2,16(sp)
    80002468:	6145                	addi	sp,sp,48
    8000246a:	8082                	ret

000000008000246c <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000246c:	1101                	addi	sp,sp,-32
    8000246e:	ec06                	sd	ra,24(sp)
    80002470:	e822                	sd	s0,16(sp)
    80002472:	e426                	sd	s1,8(sp)
    80002474:	e04a                	sd	s2,0(sp)
    80002476:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002478:	fffff097          	auipc	ra,0xfffff
    8000247c:	d18080e7          	jalr	-744(ra) # 80001190 <myproc>
    80002480:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002482:	05853903          	ld	s2,88(a0)
    80002486:	0a893783          	ld	a5,168(s2)
    8000248a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000248e:	37fd                	addiw	a5,a5,-1
    80002490:	4751                	li	a4,20
    80002492:	00f76f63          	bltu	a4,a5,800024b0 <syscall+0x44>
    80002496:	00369713          	slli	a4,a3,0x3
    8000249a:	00006797          	auipc	a5,0x6
    8000249e:	35678793          	addi	a5,a5,854 # 800087f0 <syscalls>
    800024a2:	97ba                	add	a5,a5,a4
    800024a4:	639c                	ld	a5,0(a5)
    800024a6:	c789                	beqz	a5,800024b0 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800024a8:	9782                	jalr	a5
    800024aa:	06a93823          	sd	a0,112(s2)
    800024ae:	a839                	j	800024cc <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800024b0:	15848613          	addi	a2,s1,344
    800024b4:	588c                	lw	a1,48(s1)
    800024b6:	00006517          	auipc	a0,0x6
    800024ba:	f2a50513          	addi	a0,a0,-214 # 800083e0 <etext+0x3e0>
    800024be:	00004097          	auipc	ra,0x4
    800024c2:	cde080e7          	jalr	-802(ra) # 8000619c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800024c6:	6cbc                	ld	a5,88(s1)
    800024c8:	577d                	li	a4,-1
    800024ca:	fbb8                	sd	a4,112(a5)
  }
}
    800024cc:	60e2                	ld	ra,24(sp)
    800024ce:	6442                	ld	s0,16(sp)
    800024d0:	64a2                	ld	s1,8(sp)
    800024d2:	6902                	ld	s2,0(sp)
    800024d4:	6105                	addi	sp,sp,32
    800024d6:	8082                	ret

00000000800024d8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800024d8:	1101                	addi	sp,sp,-32
    800024da:	ec06                	sd	ra,24(sp)
    800024dc:	e822                	sd	s0,16(sp)
    800024de:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800024e0:	fec40593          	addi	a1,s0,-20
    800024e4:	4501                	li	a0,0
    800024e6:	00000097          	auipc	ra,0x0
    800024ea:	f0e080e7          	jalr	-242(ra) # 800023f4 <argint>
  exit(n);
    800024ee:	fec42503          	lw	a0,-20(s0)
    800024f2:	fffff097          	auipc	ra,0xfffff
    800024f6:	480080e7          	jalr	1152(ra) # 80001972 <exit>
  return 0;  // not reached
}
    800024fa:	4501                	li	a0,0
    800024fc:	60e2                	ld	ra,24(sp)
    800024fe:	6442                	ld	s0,16(sp)
    80002500:	6105                	addi	sp,sp,32
    80002502:	8082                	ret

0000000080002504 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002504:	1141                	addi	sp,sp,-16
    80002506:	e406                	sd	ra,8(sp)
    80002508:	e022                	sd	s0,0(sp)
    8000250a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000250c:	fffff097          	auipc	ra,0xfffff
    80002510:	c84080e7          	jalr	-892(ra) # 80001190 <myproc>
}
    80002514:	5908                	lw	a0,48(a0)
    80002516:	60a2                	ld	ra,8(sp)
    80002518:	6402                	ld	s0,0(sp)
    8000251a:	0141                	addi	sp,sp,16
    8000251c:	8082                	ret

000000008000251e <sys_fork>:

uint64
sys_fork(void)
{
    8000251e:	1141                	addi	sp,sp,-16
    80002520:	e406                	sd	ra,8(sp)
    80002522:	e022                	sd	s0,0(sp)
    80002524:	0800                	addi	s0,sp,16
  return fork();
    80002526:	fffff097          	auipc	ra,0xfffff
    8000252a:	024080e7          	jalr	36(ra) # 8000154a <fork>
}
    8000252e:	60a2                	ld	ra,8(sp)
    80002530:	6402                	ld	s0,0(sp)
    80002532:	0141                	addi	sp,sp,16
    80002534:	8082                	ret

0000000080002536 <sys_wait>:

uint64
sys_wait(void)
{
    80002536:	1101                	addi	sp,sp,-32
    80002538:	ec06                	sd	ra,24(sp)
    8000253a:	e822                	sd	s0,16(sp)
    8000253c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000253e:	fe840593          	addi	a1,s0,-24
    80002542:	4501                	li	a0,0
    80002544:	00000097          	auipc	ra,0x0
    80002548:	ed0080e7          	jalr	-304(ra) # 80002414 <argaddr>
  return wait(p);
    8000254c:	fe843503          	ld	a0,-24(s0)
    80002550:	fffff097          	auipc	ra,0xfffff
    80002554:	5c8080e7          	jalr	1480(ra) # 80001b18 <wait>
}
    80002558:	60e2                	ld	ra,24(sp)
    8000255a:	6442                	ld	s0,16(sp)
    8000255c:	6105                	addi	sp,sp,32
    8000255e:	8082                	ret

0000000080002560 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002560:	7179                	addi	sp,sp,-48
    80002562:	f406                	sd	ra,40(sp)
    80002564:	f022                	sd	s0,32(sp)
    80002566:	ec26                	sd	s1,24(sp)
    80002568:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000256a:	fdc40593          	addi	a1,s0,-36
    8000256e:	4501                	li	a0,0
    80002570:	00000097          	auipc	ra,0x0
    80002574:	e84080e7          	jalr	-380(ra) # 800023f4 <argint>
  addr = myproc()->sz;
    80002578:	fffff097          	auipc	ra,0xfffff
    8000257c:	c18080e7          	jalr	-1000(ra) # 80001190 <myproc>
    80002580:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002582:	fdc42503          	lw	a0,-36(s0)
    80002586:	fffff097          	auipc	ra,0xfffff
    8000258a:	f68080e7          	jalr	-152(ra) # 800014ee <growproc>
    8000258e:	00054863          	bltz	a0,8000259e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002592:	8526                	mv	a0,s1
    80002594:	70a2                	ld	ra,40(sp)
    80002596:	7402                	ld	s0,32(sp)
    80002598:	64e2                	ld	s1,24(sp)
    8000259a:	6145                	addi	sp,sp,48
    8000259c:	8082                	ret
    return -1;
    8000259e:	54fd                	li	s1,-1
    800025a0:	bfcd                	j	80002592 <sys_sbrk+0x32>

00000000800025a2 <sys_sleep>:

uint64
sys_sleep(void)
{
    800025a2:	7139                	addi	sp,sp,-64
    800025a4:	fc06                	sd	ra,56(sp)
    800025a6:	f822                	sd	s0,48(sp)
    800025a8:	f04a                	sd	s2,32(sp)
    800025aa:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800025ac:	fcc40593          	addi	a1,s0,-52
    800025b0:	4501                	li	a0,0
    800025b2:	00000097          	auipc	ra,0x0
    800025b6:	e42080e7          	jalr	-446(ra) # 800023f4 <argint>
  if(n < 0)
    800025ba:	fcc42783          	lw	a5,-52(s0)
    800025be:	0807c163          	bltz	a5,80002640 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800025c2:	0022c517          	auipc	a0,0x22c
    800025c6:	1e650513          	addi	a0,a0,486 # 8022e7a8 <tickslock>
    800025ca:	00004097          	auipc	ra,0x4
    800025ce:	102080e7          	jalr	258(ra) # 800066cc <acquire>
  ticks0 = ticks;
    800025d2:	00006917          	auipc	s2,0x6
    800025d6:	35692903          	lw	s2,854(s2) # 80008928 <ticks>
  while(ticks - ticks0 < n){
    800025da:	fcc42783          	lw	a5,-52(s0)
    800025de:	c3b9                	beqz	a5,80002624 <sys_sleep+0x82>
    800025e0:	f426                	sd	s1,40(sp)
    800025e2:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800025e4:	0022c997          	auipc	s3,0x22c
    800025e8:	1c498993          	addi	s3,s3,452 # 8022e7a8 <tickslock>
    800025ec:	00006497          	auipc	s1,0x6
    800025f0:	33c48493          	addi	s1,s1,828 # 80008928 <ticks>
    if(killed(myproc())){
    800025f4:	fffff097          	auipc	ra,0xfffff
    800025f8:	b9c080e7          	jalr	-1124(ra) # 80001190 <myproc>
    800025fc:	fffff097          	auipc	ra,0xfffff
    80002600:	4ea080e7          	jalr	1258(ra) # 80001ae6 <killed>
    80002604:	e129                	bnez	a0,80002646 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002606:	85ce                	mv	a1,s3
    80002608:	8526                	mv	a0,s1
    8000260a:	fffff097          	auipc	ra,0xfffff
    8000260e:	234080e7          	jalr	564(ra) # 8000183e <sleep>
  while(ticks - ticks0 < n){
    80002612:	409c                	lw	a5,0(s1)
    80002614:	412787bb          	subw	a5,a5,s2
    80002618:	fcc42703          	lw	a4,-52(s0)
    8000261c:	fce7ece3          	bltu	a5,a4,800025f4 <sys_sleep+0x52>
    80002620:	74a2                	ld	s1,40(sp)
    80002622:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002624:	0022c517          	auipc	a0,0x22c
    80002628:	18450513          	addi	a0,a0,388 # 8022e7a8 <tickslock>
    8000262c:	00004097          	auipc	ra,0x4
    80002630:	154080e7          	jalr	340(ra) # 80006780 <release>
  return 0;
    80002634:	4501                	li	a0,0
}
    80002636:	70e2                	ld	ra,56(sp)
    80002638:	7442                	ld	s0,48(sp)
    8000263a:	7902                	ld	s2,32(sp)
    8000263c:	6121                	addi	sp,sp,64
    8000263e:	8082                	ret
    n = 0;
    80002640:	fc042623          	sw	zero,-52(s0)
    80002644:	bfbd                	j	800025c2 <sys_sleep+0x20>
      release(&tickslock);
    80002646:	0022c517          	auipc	a0,0x22c
    8000264a:	16250513          	addi	a0,a0,354 # 8022e7a8 <tickslock>
    8000264e:	00004097          	auipc	ra,0x4
    80002652:	132080e7          	jalr	306(ra) # 80006780 <release>
      return -1;
    80002656:	557d                	li	a0,-1
    80002658:	74a2                	ld	s1,40(sp)
    8000265a:	69e2                	ld	s3,24(sp)
    8000265c:	bfe9                	j	80002636 <sys_sleep+0x94>

000000008000265e <sys_kill>:

uint64
sys_kill(void)
{
    8000265e:	1101                	addi	sp,sp,-32
    80002660:	ec06                	sd	ra,24(sp)
    80002662:	e822                	sd	s0,16(sp)
    80002664:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002666:	fec40593          	addi	a1,s0,-20
    8000266a:	4501                	li	a0,0
    8000266c:	00000097          	auipc	ra,0x0
    80002670:	d88080e7          	jalr	-632(ra) # 800023f4 <argint>
  return kill(pid);
    80002674:	fec42503          	lw	a0,-20(s0)
    80002678:	fffff097          	auipc	ra,0xfffff
    8000267c:	3d0080e7          	jalr	976(ra) # 80001a48 <kill>
}
    80002680:	60e2                	ld	ra,24(sp)
    80002682:	6442                	ld	s0,16(sp)
    80002684:	6105                	addi	sp,sp,32
    80002686:	8082                	ret

0000000080002688 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002688:	1101                	addi	sp,sp,-32
    8000268a:	ec06                	sd	ra,24(sp)
    8000268c:	e822                	sd	s0,16(sp)
    8000268e:	e426                	sd	s1,8(sp)
    80002690:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002692:	0022c517          	auipc	a0,0x22c
    80002696:	11650513          	addi	a0,a0,278 # 8022e7a8 <tickslock>
    8000269a:	00004097          	auipc	ra,0x4
    8000269e:	032080e7          	jalr	50(ra) # 800066cc <acquire>
  xticks = ticks;
    800026a2:	00006497          	auipc	s1,0x6
    800026a6:	2864a483          	lw	s1,646(s1) # 80008928 <ticks>
  release(&tickslock);
    800026aa:	0022c517          	auipc	a0,0x22c
    800026ae:	0fe50513          	addi	a0,a0,254 # 8022e7a8 <tickslock>
    800026b2:	00004097          	auipc	ra,0x4
    800026b6:	0ce080e7          	jalr	206(ra) # 80006780 <release>
  return xticks;
}
    800026ba:	02049513          	slli	a0,s1,0x20
    800026be:	9101                	srli	a0,a0,0x20
    800026c0:	60e2                	ld	ra,24(sp)
    800026c2:	6442                	ld	s0,16(sp)
    800026c4:	64a2                	ld	s1,8(sp)
    800026c6:	6105                	addi	sp,sp,32
    800026c8:	8082                	ret

00000000800026ca <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800026ca:	7179                	addi	sp,sp,-48
    800026cc:	f406                	sd	ra,40(sp)
    800026ce:	f022                	sd	s0,32(sp)
    800026d0:	ec26                	sd	s1,24(sp)
    800026d2:	e84a                	sd	s2,16(sp)
    800026d4:	e44e                	sd	s3,8(sp)
    800026d6:	e052                	sd	s4,0(sp)
    800026d8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800026da:	00006597          	auipc	a1,0x6
    800026de:	d2658593          	addi	a1,a1,-730 # 80008400 <etext+0x400>
    800026e2:	0022c517          	auipc	a0,0x22c
    800026e6:	0de50513          	addi	a0,a0,222 # 8022e7c0 <bcache>
    800026ea:	00004097          	auipc	ra,0x4
    800026ee:	f52080e7          	jalr	-174(ra) # 8000663c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800026f2:	00234797          	auipc	a5,0x234
    800026f6:	0ce78793          	addi	a5,a5,206 # 802367c0 <bcache+0x8000>
    800026fa:	00234717          	auipc	a4,0x234
    800026fe:	32e70713          	addi	a4,a4,814 # 80236a28 <bcache+0x8268>
    80002702:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002706:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000270a:	0022c497          	auipc	s1,0x22c
    8000270e:	0ce48493          	addi	s1,s1,206 # 8022e7d8 <bcache+0x18>
    b->next = bcache.head.next;
    80002712:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002714:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002716:	00006a17          	auipc	s4,0x6
    8000271a:	cf2a0a13          	addi	s4,s4,-782 # 80008408 <etext+0x408>
    b->next = bcache.head.next;
    8000271e:	2b893783          	ld	a5,696(s2)
    80002722:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002724:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002728:	85d2                	mv	a1,s4
    8000272a:	01048513          	addi	a0,s1,16
    8000272e:	00001097          	auipc	ra,0x1
    80002732:	4e8080e7          	jalr	1256(ra) # 80003c16 <initsleeplock>
    bcache.head.next->prev = b;
    80002736:	2b893783          	ld	a5,696(s2)
    8000273a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000273c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002740:	45848493          	addi	s1,s1,1112
    80002744:	fd349de3          	bne	s1,s3,8000271e <binit+0x54>
  }
}
    80002748:	70a2                	ld	ra,40(sp)
    8000274a:	7402                	ld	s0,32(sp)
    8000274c:	64e2                	ld	s1,24(sp)
    8000274e:	6942                	ld	s2,16(sp)
    80002750:	69a2                	ld	s3,8(sp)
    80002752:	6a02                	ld	s4,0(sp)
    80002754:	6145                	addi	sp,sp,48
    80002756:	8082                	ret

0000000080002758 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002758:	7179                	addi	sp,sp,-48
    8000275a:	f406                	sd	ra,40(sp)
    8000275c:	f022                	sd	s0,32(sp)
    8000275e:	ec26                	sd	s1,24(sp)
    80002760:	e84a                	sd	s2,16(sp)
    80002762:	e44e                	sd	s3,8(sp)
    80002764:	1800                	addi	s0,sp,48
    80002766:	892a                	mv	s2,a0
    80002768:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000276a:	0022c517          	auipc	a0,0x22c
    8000276e:	05650513          	addi	a0,a0,86 # 8022e7c0 <bcache>
    80002772:	00004097          	auipc	ra,0x4
    80002776:	f5a080e7          	jalr	-166(ra) # 800066cc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000277a:	00234497          	auipc	s1,0x234
    8000277e:	2fe4b483          	ld	s1,766(s1) # 80236a78 <bcache+0x82b8>
    80002782:	00234797          	auipc	a5,0x234
    80002786:	2a678793          	addi	a5,a5,678 # 80236a28 <bcache+0x8268>
    8000278a:	02f48f63          	beq	s1,a5,800027c8 <bread+0x70>
    8000278e:	873e                	mv	a4,a5
    80002790:	a021                	j	80002798 <bread+0x40>
    80002792:	68a4                	ld	s1,80(s1)
    80002794:	02e48a63          	beq	s1,a4,800027c8 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002798:	449c                	lw	a5,8(s1)
    8000279a:	ff279ce3          	bne	a5,s2,80002792 <bread+0x3a>
    8000279e:	44dc                	lw	a5,12(s1)
    800027a0:	ff3799e3          	bne	a5,s3,80002792 <bread+0x3a>
      b->refcnt++;
    800027a4:	40bc                	lw	a5,64(s1)
    800027a6:	2785                	addiw	a5,a5,1
    800027a8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800027aa:	0022c517          	auipc	a0,0x22c
    800027ae:	01650513          	addi	a0,a0,22 # 8022e7c0 <bcache>
    800027b2:	00004097          	auipc	ra,0x4
    800027b6:	fce080e7          	jalr	-50(ra) # 80006780 <release>
      acquiresleep(&b->lock);
    800027ba:	01048513          	addi	a0,s1,16
    800027be:	00001097          	auipc	ra,0x1
    800027c2:	492080e7          	jalr	1170(ra) # 80003c50 <acquiresleep>
      return b;
    800027c6:	a8b9                	j	80002824 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800027c8:	00234497          	auipc	s1,0x234
    800027cc:	2a84b483          	ld	s1,680(s1) # 80236a70 <bcache+0x82b0>
    800027d0:	00234797          	auipc	a5,0x234
    800027d4:	25878793          	addi	a5,a5,600 # 80236a28 <bcache+0x8268>
    800027d8:	00f48863          	beq	s1,a5,800027e8 <bread+0x90>
    800027dc:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800027de:	40bc                	lw	a5,64(s1)
    800027e0:	cf81                	beqz	a5,800027f8 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800027e2:	64a4                	ld	s1,72(s1)
    800027e4:	fee49de3          	bne	s1,a4,800027de <bread+0x86>
  panic("bget: no buffers");
    800027e8:	00006517          	auipc	a0,0x6
    800027ec:	c2850513          	addi	a0,a0,-984 # 80008410 <etext+0x410>
    800027f0:	00004097          	auipc	ra,0x4
    800027f4:	962080e7          	jalr	-1694(ra) # 80006152 <panic>
      b->dev = dev;
    800027f8:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800027fc:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002800:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002804:	4785                	li	a5,1
    80002806:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002808:	0022c517          	auipc	a0,0x22c
    8000280c:	fb850513          	addi	a0,a0,-72 # 8022e7c0 <bcache>
    80002810:	00004097          	auipc	ra,0x4
    80002814:	f70080e7          	jalr	-144(ra) # 80006780 <release>
      acquiresleep(&b->lock);
    80002818:	01048513          	addi	a0,s1,16
    8000281c:	00001097          	auipc	ra,0x1
    80002820:	434080e7          	jalr	1076(ra) # 80003c50 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002824:	409c                	lw	a5,0(s1)
    80002826:	cb89                	beqz	a5,80002838 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002828:	8526                	mv	a0,s1
    8000282a:	70a2                	ld	ra,40(sp)
    8000282c:	7402                	ld	s0,32(sp)
    8000282e:	64e2                	ld	s1,24(sp)
    80002830:	6942                	ld	s2,16(sp)
    80002832:	69a2                	ld	s3,8(sp)
    80002834:	6145                	addi	sp,sp,48
    80002836:	8082                	ret
    virtio_disk_rw(b, 0);
    80002838:	4581                	li	a1,0
    8000283a:	8526                	mv	a0,s1
    8000283c:	00003097          	auipc	ra,0x3
    80002840:	0ec080e7          	jalr	236(ra) # 80005928 <virtio_disk_rw>
    b->valid = 1;
    80002844:	4785                	li	a5,1
    80002846:	c09c                	sw	a5,0(s1)
  return b;
    80002848:	b7c5                	j	80002828 <bread+0xd0>

000000008000284a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000284a:	1101                	addi	sp,sp,-32
    8000284c:	ec06                	sd	ra,24(sp)
    8000284e:	e822                	sd	s0,16(sp)
    80002850:	e426                	sd	s1,8(sp)
    80002852:	1000                	addi	s0,sp,32
    80002854:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002856:	0541                	addi	a0,a0,16
    80002858:	00001097          	auipc	ra,0x1
    8000285c:	492080e7          	jalr	1170(ra) # 80003cea <holdingsleep>
    80002860:	cd01                	beqz	a0,80002878 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002862:	4585                	li	a1,1
    80002864:	8526                	mv	a0,s1
    80002866:	00003097          	auipc	ra,0x3
    8000286a:	0c2080e7          	jalr	194(ra) # 80005928 <virtio_disk_rw>
}
    8000286e:	60e2                	ld	ra,24(sp)
    80002870:	6442                	ld	s0,16(sp)
    80002872:	64a2                	ld	s1,8(sp)
    80002874:	6105                	addi	sp,sp,32
    80002876:	8082                	ret
    panic("bwrite");
    80002878:	00006517          	auipc	a0,0x6
    8000287c:	bb050513          	addi	a0,a0,-1104 # 80008428 <etext+0x428>
    80002880:	00004097          	auipc	ra,0x4
    80002884:	8d2080e7          	jalr	-1838(ra) # 80006152 <panic>

0000000080002888 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002888:	1101                	addi	sp,sp,-32
    8000288a:	ec06                	sd	ra,24(sp)
    8000288c:	e822                	sd	s0,16(sp)
    8000288e:	e426                	sd	s1,8(sp)
    80002890:	e04a                	sd	s2,0(sp)
    80002892:	1000                	addi	s0,sp,32
    80002894:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002896:	01050913          	addi	s2,a0,16
    8000289a:	854a                	mv	a0,s2
    8000289c:	00001097          	auipc	ra,0x1
    800028a0:	44e080e7          	jalr	1102(ra) # 80003cea <holdingsleep>
    800028a4:	c925                	beqz	a0,80002914 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800028a6:	854a                	mv	a0,s2
    800028a8:	00001097          	auipc	ra,0x1
    800028ac:	3fe080e7          	jalr	1022(ra) # 80003ca6 <releasesleep>

  acquire(&bcache.lock);
    800028b0:	0022c517          	auipc	a0,0x22c
    800028b4:	f1050513          	addi	a0,a0,-240 # 8022e7c0 <bcache>
    800028b8:	00004097          	auipc	ra,0x4
    800028bc:	e14080e7          	jalr	-492(ra) # 800066cc <acquire>
  b->refcnt--;
    800028c0:	40bc                	lw	a5,64(s1)
    800028c2:	37fd                	addiw	a5,a5,-1
    800028c4:	0007871b          	sext.w	a4,a5
    800028c8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800028ca:	e71d                	bnez	a4,800028f8 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800028cc:	68b8                	ld	a4,80(s1)
    800028ce:	64bc                	ld	a5,72(s1)
    800028d0:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800028d2:	68b8                	ld	a4,80(s1)
    800028d4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800028d6:	00234797          	auipc	a5,0x234
    800028da:	eea78793          	addi	a5,a5,-278 # 802367c0 <bcache+0x8000>
    800028de:	2b87b703          	ld	a4,696(a5)
    800028e2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800028e4:	00234717          	auipc	a4,0x234
    800028e8:	14470713          	addi	a4,a4,324 # 80236a28 <bcache+0x8268>
    800028ec:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800028ee:	2b87b703          	ld	a4,696(a5)
    800028f2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800028f4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800028f8:	0022c517          	auipc	a0,0x22c
    800028fc:	ec850513          	addi	a0,a0,-312 # 8022e7c0 <bcache>
    80002900:	00004097          	auipc	ra,0x4
    80002904:	e80080e7          	jalr	-384(ra) # 80006780 <release>
}
    80002908:	60e2                	ld	ra,24(sp)
    8000290a:	6442                	ld	s0,16(sp)
    8000290c:	64a2                	ld	s1,8(sp)
    8000290e:	6902                	ld	s2,0(sp)
    80002910:	6105                	addi	sp,sp,32
    80002912:	8082                	ret
    panic("brelse");
    80002914:	00006517          	auipc	a0,0x6
    80002918:	b1c50513          	addi	a0,a0,-1252 # 80008430 <etext+0x430>
    8000291c:	00004097          	auipc	ra,0x4
    80002920:	836080e7          	jalr	-1994(ra) # 80006152 <panic>

0000000080002924 <bpin>:

void
bpin(struct buf *b) {
    80002924:	1101                	addi	sp,sp,-32
    80002926:	ec06                	sd	ra,24(sp)
    80002928:	e822                	sd	s0,16(sp)
    8000292a:	e426                	sd	s1,8(sp)
    8000292c:	1000                	addi	s0,sp,32
    8000292e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002930:	0022c517          	auipc	a0,0x22c
    80002934:	e9050513          	addi	a0,a0,-368 # 8022e7c0 <bcache>
    80002938:	00004097          	auipc	ra,0x4
    8000293c:	d94080e7          	jalr	-620(ra) # 800066cc <acquire>
  b->refcnt++;
    80002940:	40bc                	lw	a5,64(s1)
    80002942:	2785                	addiw	a5,a5,1
    80002944:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002946:	0022c517          	auipc	a0,0x22c
    8000294a:	e7a50513          	addi	a0,a0,-390 # 8022e7c0 <bcache>
    8000294e:	00004097          	auipc	ra,0x4
    80002952:	e32080e7          	jalr	-462(ra) # 80006780 <release>
}
    80002956:	60e2                	ld	ra,24(sp)
    80002958:	6442                	ld	s0,16(sp)
    8000295a:	64a2                	ld	s1,8(sp)
    8000295c:	6105                	addi	sp,sp,32
    8000295e:	8082                	ret

0000000080002960 <bunpin>:

void
bunpin(struct buf *b) {
    80002960:	1101                	addi	sp,sp,-32
    80002962:	ec06                	sd	ra,24(sp)
    80002964:	e822                	sd	s0,16(sp)
    80002966:	e426                	sd	s1,8(sp)
    80002968:	1000                	addi	s0,sp,32
    8000296a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000296c:	0022c517          	auipc	a0,0x22c
    80002970:	e5450513          	addi	a0,a0,-428 # 8022e7c0 <bcache>
    80002974:	00004097          	auipc	ra,0x4
    80002978:	d58080e7          	jalr	-680(ra) # 800066cc <acquire>
  b->refcnt--;
    8000297c:	40bc                	lw	a5,64(s1)
    8000297e:	37fd                	addiw	a5,a5,-1
    80002980:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002982:	0022c517          	auipc	a0,0x22c
    80002986:	e3e50513          	addi	a0,a0,-450 # 8022e7c0 <bcache>
    8000298a:	00004097          	auipc	ra,0x4
    8000298e:	df6080e7          	jalr	-522(ra) # 80006780 <release>
}
    80002992:	60e2                	ld	ra,24(sp)
    80002994:	6442                	ld	s0,16(sp)
    80002996:	64a2                	ld	s1,8(sp)
    80002998:	6105                	addi	sp,sp,32
    8000299a:	8082                	ret

000000008000299c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000299c:	1101                	addi	sp,sp,-32
    8000299e:	ec06                	sd	ra,24(sp)
    800029a0:	e822                	sd	s0,16(sp)
    800029a2:	e426                	sd	s1,8(sp)
    800029a4:	e04a                	sd	s2,0(sp)
    800029a6:	1000                	addi	s0,sp,32
    800029a8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800029aa:	00d5d59b          	srliw	a1,a1,0xd
    800029ae:	00234797          	auipc	a5,0x234
    800029b2:	4ee7a783          	lw	a5,1262(a5) # 80236e9c <sb+0x1c>
    800029b6:	9dbd                	addw	a1,a1,a5
    800029b8:	00000097          	auipc	ra,0x0
    800029bc:	da0080e7          	jalr	-608(ra) # 80002758 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800029c0:	0074f713          	andi	a4,s1,7
    800029c4:	4785                	li	a5,1
    800029c6:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800029ca:	14ce                	slli	s1,s1,0x33
    800029cc:	90d9                	srli	s1,s1,0x36
    800029ce:	00950733          	add	a4,a0,s1
    800029d2:	05874703          	lbu	a4,88(a4)
    800029d6:	00e7f6b3          	and	a3,a5,a4
    800029da:	c69d                	beqz	a3,80002a08 <bfree+0x6c>
    800029dc:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800029de:	94aa                	add	s1,s1,a0
    800029e0:	fff7c793          	not	a5,a5
    800029e4:	8f7d                	and	a4,a4,a5
    800029e6:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800029ea:	00001097          	auipc	ra,0x1
    800029ee:	148080e7          	jalr	328(ra) # 80003b32 <log_write>
  brelse(bp);
    800029f2:	854a                	mv	a0,s2
    800029f4:	00000097          	auipc	ra,0x0
    800029f8:	e94080e7          	jalr	-364(ra) # 80002888 <brelse>
}
    800029fc:	60e2                	ld	ra,24(sp)
    800029fe:	6442                	ld	s0,16(sp)
    80002a00:	64a2                	ld	s1,8(sp)
    80002a02:	6902                	ld	s2,0(sp)
    80002a04:	6105                	addi	sp,sp,32
    80002a06:	8082                	ret
    panic("freeing free block");
    80002a08:	00006517          	auipc	a0,0x6
    80002a0c:	a3050513          	addi	a0,a0,-1488 # 80008438 <etext+0x438>
    80002a10:	00003097          	auipc	ra,0x3
    80002a14:	742080e7          	jalr	1858(ra) # 80006152 <panic>

0000000080002a18 <balloc>:
{
    80002a18:	711d                	addi	sp,sp,-96
    80002a1a:	ec86                	sd	ra,88(sp)
    80002a1c:	e8a2                	sd	s0,80(sp)
    80002a1e:	e4a6                	sd	s1,72(sp)
    80002a20:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002a22:	00234797          	auipc	a5,0x234
    80002a26:	4627a783          	lw	a5,1122(a5) # 80236e84 <sb+0x4>
    80002a2a:	10078f63          	beqz	a5,80002b48 <balloc+0x130>
    80002a2e:	e0ca                	sd	s2,64(sp)
    80002a30:	fc4e                	sd	s3,56(sp)
    80002a32:	f852                	sd	s4,48(sp)
    80002a34:	f456                	sd	s5,40(sp)
    80002a36:	f05a                	sd	s6,32(sp)
    80002a38:	ec5e                	sd	s7,24(sp)
    80002a3a:	e862                	sd	s8,16(sp)
    80002a3c:	e466                	sd	s9,8(sp)
    80002a3e:	8baa                	mv	s7,a0
    80002a40:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002a42:	00234b17          	auipc	s6,0x234
    80002a46:	43eb0b13          	addi	s6,s6,1086 # 80236e80 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a4a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002a4c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a4e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002a50:	6c89                	lui	s9,0x2
    80002a52:	a061                	j	80002ada <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002a54:	97ca                	add	a5,a5,s2
    80002a56:	8e55                	or	a2,a2,a3
    80002a58:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002a5c:	854a                	mv	a0,s2
    80002a5e:	00001097          	auipc	ra,0x1
    80002a62:	0d4080e7          	jalr	212(ra) # 80003b32 <log_write>
        brelse(bp);
    80002a66:	854a                	mv	a0,s2
    80002a68:	00000097          	auipc	ra,0x0
    80002a6c:	e20080e7          	jalr	-480(ra) # 80002888 <brelse>
  bp = bread(dev, bno);
    80002a70:	85a6                	mv	a1,s1
    80002a72:	855e                	mv	a0,s7
    80002a74:	00000097          	auipc	ra,0x0
    80002a78:	ce4080e7          	jalr	-796(ra) # 80002758 <bread>
    80002a7c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002a7e:	40000613          	li	a2,1024
    80002a82:	4581                	li	a1,0
    80002a84:	05850513          	addi	a0,a0,88
    80002a88:	ffffe097          	auipc	ra,0xffffe
    80002a8c:	822080e7          	jalr	-2014(ra) # 800002aa <memset>
  log_write(bp);
    80002a90:	854a                	mv	a0,s2
    80002a92:	00001097          	auipc	ra,0x1
    80002a96:	0a0080e7          	jalr	160(ra) # 80003b32 <log_write>
  brelse(bp);
    80002a9a:	854a                	mv	a0,s2
    80002a9c:	00000097          	auipc	ra,0x0
    80002aa0:	dec080e7          	jalr	-532(ra) # 80002888 <brelse>
}
    80002aa4:	6906                	ld	s2,64(sp)
    80002aa6:	79e2                	ld	s3,56(sp)
    80002aa8:	7a42                	ld	s4,48(sp)
    80002aaa:	7aa2                	ld	s5,40(sp)
    80002aac:	7b02                	ld	s6,32(sp)
    80002aae:	6be2                	ld	s7,24(sp)
    80002ab0:	6c42                	ld	s8,16(sp)
    80002ab2:	6ca2                	ld	s9,8(sp)
}
    80002ab4:	8526                	mv	a0,s1
    80002ab6:	60e6                	ld	ra,88(sp)
    80002ab8:	6446                	ld	s0,80(sp)
    80002aba:	64a6                	ld	s1,72(sp)
    80002abc:	6125                	addi	sp,sp,96
    80002abe:	8082                	ret
    brelse(bp);
    80002ac0:	854a                	mv	a0,s2
    80002ac2:	00000097          	auipc	ra,0x0
    80002ac6:	dc6080e7          	jalr	-570(ra) # 80002888 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002aca:	015c87bb          	addw	a5,s9,s5
    80002ace:	00078a9b          	sext.w	s5,a5
    80002ad2:	004b2703          	lw	a4,4(s6)
    80002ad6:	06eaf163          	bgeu	s5,a4,80002b38 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80002ada:	41fad79b          	sraiw	a5,s5,0x1f
    80002ade:	0137d79b          	srliw	a5,a5,0x13
    80002ae2:	015787bb          	addw	a5,a5,s5
    80002ae6:	40d7d79b          	sraiw	a5,a5,0xd
    80002aea:	01cb2583          	lw	a1,28(s6)
    80002aee:	9dbd                	addw	a1,a1,a5
    80002af0:	855e                	mv	a0,s7
    80002af2:	00000097          	auipc	ra,0x0
    80002af6:	c66080e7          	jalr	-922(ra) # 80002758 <bread>
    80002afa:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002afc:	004b2503          	lw	a0,4(s6)
    80002b00:	000a849b          	sext.w	s1,s5
    80002b04:	8762                	mv	a4,s8
    80002b06:	faa4fde3          	bgeu	s1,a0,80002ac0 <balloc+0xa8>
      m = 1 << (bi % 8);
    80002b0a:	00777693          	andi	a3,a4,7
    80002b0e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002b12:	41f7579b          	sraiw	a5,a4,0x1f
    80002b16:	01d7d79b          	srliw	a5,a5,0x1d
    80002b1a:	9fb9                	addw	a5,a5,a4
    80002b1c:	4037d79b          	sraiw	a5,a5,0x3
    80002b20:	00f90633          	add	a2,s2,a5
    80002b24:	05864603          	lbu	a2,88(a2)
    80002b28:	00c6f5b3          	and	a1,a3,a2
    80002b2c:	d585                	beqz	a1,80002a54 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002b2e:	2705                	addiw	a4,a4,1
    80002b30:	2485                	addiw	s1,s1,1
    80002b32:	fd471ae3          	bne	a4,s4,80002b06 <balloc+0xee>
    80002b36:	b769                	j	80002ac0 <balloc+0xa8>
    80002b38:	6906                	ld	s2,64(sp)
    80002b3a:	79e2                	ld	s3,56(sp)
    80002b3c:	7a42                	ld	s4,48(sp)
    80002b3e:	7aa2                	ld	s5,40(sp)
    80002b40:	7b02                	ld	s6,32(sp)
    80002b42:	6be2                	ld	s7,24(sp)
    80002b44:	6c42                	ld	s8,16(sp)
    80002b46:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002b48:	00006517          	auipc	a0,0x6
    80002b4c:	90850513          	addi	a0,a0,-1784 # 80008450 <etext+0x450>
    80002b50:	00003097          	auipc	ra,0x3
    80002b54:	64c080e7          	jalr	1612(ra) # 8000619c <printf>
  return 0;
    80002b58:	4481                	li	s1,0
    80002b5a:	bfa9                	j	80002ab4 <balloc+0x9c>

0000000080002b5c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002b5c:	7179                	addi	sp,sp,-48
    80002b5e:	f406                	sd	ra,40(sp)
    80002b60:	f022                	sd	s0,32(sp)
    80002b62:	ec26                	sd	s1,24(sp)
    80002b64:	e84a                	sd	s2,16(sp)
    80002b66:	e44e                	sd	s3,8(sp)
    80002b68:	1800                	addi	s0,sp,48
    80002b6a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002b6c:	47ad                	li	a5,11
    80002b6e:	02b7e863          	bltu	a5,a1,80002b9e <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002b72:	02059793          	slli	a5,a1,0x20
    80002b76:	01e7d593          	srli	a1,a5,0x1e
    80002b7a:	00b504b3          	add	s1,a0,a1
    80002b7e:	0504a903          	lw	s2,80(s1)
    80002b82:	08091263          	bnez	s2,80002c06 <bmap+0xaa>
      addr = balloc(ip->dev);
    80002b86:	4108                	lw	a0,0(a0)
    80002b88:	00000097          	auipc	ra,0x0
    80002b8c:	e90080e7          	jalr	-368(ra) # 80002a18 <balloc>
    80002b90:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002b94:	06090963          	beqz	s2,80002c06 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80002b98:	0524a823          	sw	s2,80(s1)
    80002b9c:	a0ad                	j	80002c06 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002b9e:	ff45849b          	addiw	s1,a1,-12
    80002ba2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002ba6:	0ff00793          	li	a5,255
    80002baa:	08e7e863          	bltu	a5,a4,80002c3a <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002bae:	08052903          	lw	s2,128(a0)
    80002bb2:	00091f63          	bnez	s2,80002bd0 <bmap+0x74>
      addr = balloc(ip->dev);
    80002bb6:	4108                	lw	a0,0(a0)
    80002bb8:	00000097          	auipc	ra,0x0
    80002bbc:	e60080e7          	jalr	-416(ra) # 80002a18 <balloc>
    80002bc0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002bc4:	04090163          	beqz	s2,80002c06 <bmap+0xaa>
    80002bc8:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002bca:	0929a023          	sw	s2,128(s3)
    80002bce:	a011                	j	80002bd2 <bmap+0x76>
    80002bd0:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002bd2:	85ca                	mv	a1,s2
    80002bd4:	0009a503          	lw	a0,0(s3)
    80002bd8:	00000097          	auipc	ra,0x0
    80002bdc:	b80080e7          	jalr	-1152(ra) # 80002758 <bread>
    80002be0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002be2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002be6:	02049713          	slli	a4,s1,0x20
    80002bea:	01e75593          	srli	a1,a4,0x1e
    80002bee:	00b784b3          	add	s1,a5,a1
    80002bf2:	0004a903          	lw	s2,0(s1)
    80002bf6:	02090063          	beqz	s2,80002c16 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002bfa:	8552                	mv	a0,s4
    80002bfc:	00000097          	auipc	ra,0x0
    80002c00:	c8c080e7          	jalr	-884(ra) # 80002888 <brelse>
    return addr;
    80002c04:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002c06:	854a                	mv	a0,s2
    80002c08:	70a2                	ld	ra,40(sp)
    80002c0a:	7402                	ld	s0,32(sp)
    80002c0c:	64e2                	ld	s1,24(sp)
    80002c0e:	6942                	ld	s2,16(sp)
    80002c10:	69a2                	ld	s3,8(sp)
    80002c12:	6145                	addi	sp,sp,48
    80002c14:	8082                	ret
      addr = balloc(ip->dev);
    80002c16:	0009a503          	lw	a0,0(s3)
    80002c1a:	00000097          	auipc	ra,0x0
    80002c1e:	dfe080e7          	jalr	-514(ra) # 80002a18 <balloc>
    80002c22:	0005091b          	sext.w	s2,a0
      if(addr){
    80002c26:	fc090ae3          	beqz	s2,80002bfa <bmap+0x9e>
        a[bn] = addr;
    80002c2a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002c2e:	8552                	mv	a0,s4
    80002c30:	00001097          	auipc	ra,0x1
    80002c34:	f02080e7          	jalr	-254(ra) # 80003b32 <log_write>
    80002c38:	b7c9                	j	80002bfa <bmap+0x9e>
    80002c3a:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002c3c:	00006517          	auipc	a0,0x6
    80002c40:	82c50513          	addi	a0,a0,-2004 # 80008468 <etext+0x468>
    80002c44:	00003097          	auipc	ra,0x3
    80002c48:	50e080e7          	jalr	1294(ra) # 80006152 <panic>

0000000080002c4c <iget>:
{
    80002c4c:	7179                	addi	sp,sp,-48
    80002c4e:	f406                	sd	ra,40(sp)
    80002c50:	f022                	sd	s0,32(sp)
    80002c52:	ec26                	sd	s1,24(sp)
    80002c54:	e84a                	sd	s2,16(sp)
    80002c56:	e44e                	sd	s3,8(sp)
    80002c58:	e052                	sd	s4,0(sp)
    80002c5a:	1800                	addi	s0,sp,48
    80002c5c:	89aa                	mv	s3,a0
    80002c5e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002c60:	00234517          	auipc	a0,0x234
    80002c64:	24050513          	addi	a0,a0,576 # 80236ea0 <itable>
    80002c68:	00004097          	auipc	ra,0x4
    80002c6c:	a64080e7          	jalr	-1436(ra) # 800066cc <acquire>
  empty = 0;
    80002c70:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002c72:	00234497          	auipc	s1,0x234
    80002c76:	24648493          	addi	s1,s1,582 # 80236eb8 <itable+0x18>
    80002c7a:	00236697          	auipc	a3,0x236
    80002c7e:	cce68693          	addi	a3,a3,-818 # 80238948 <log>
    80002c82:	a039                	j	80002c90 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002c84:	02090b63          	beqz	s2,80002cba <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002c88:	08848493          	addi	s1,s1,136
    80002c8c:	02d48a63          	beq	s1,a3,80002cc0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002c90:	449c                	lw	a5,8(s1)
    80002c92:	fef059e3          	blez	a5,80002c84 <iget+0x38>
    80002c96:	4098                	lw	a4,0(s1)
    80002c98:	ff3716e3          	bne	a4,s3,80002c84 <iget+0x38>
    80002c9c:	40d8                	lw	a4,4(s1)
    80002c9e:	ff4713e3          	bne	a4,s4,80002c84 <iget+0x38>
      ip->ref++;
    80002ca2:	2785                	addiw	a5,a5,1
    80002ca4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002ca6:	00234517          	auipc	a0,0x234
    80002caa:	1fa50513          	addi	a0,a0,506 # 80236ea0 <itable>
    80002cae:	00004097          	auipc	ra,0x4
    80002cb2:	ad2080e7          	jalr	-1326(ra) # 80006780 <release>
      return ip;
    80002cb6:	8926                	mv	s2,s1
    80002cb8:	a03d                	j	80002ce6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002cba:	f7f9                	bnez	a5,80002c88 <iget+0x3c>
      empty = ip;
    80002cbc:	8926                	mv	s2,s1
    80002cbe:	b7e9                	j	80002c88 <iget+0x3c>
  if(empty == 0)
    80002cc0:	02090c63          	beqz	s2,80002cf8 <iget+0xac>
  ip->dev = dev;
    80002cc4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002cc8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ccc:	4785                	li	a5,1
    80002cce:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002cd2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002cd6:	00234517          	auipc	a0,0x234
    80002cda:	1ca50513          	addi	a0,a0,458 # 80236ea0 <itable>
    80002cde:	00004097          	auipc	ra,0x4
    80002ce2:	aa2080e7          	jalr	-1374(ra) # 80006780 <release>
}
    80002ce6:	854a                	mv	a0,s2
    80002ce8:	70a2                	ld	ra,40(sp)
    80002cea:	7402                	ld	s0,32(sp)
    80002cec:	64e2                	ld	s1,24(sp)
    80002cee:	6942                	ld	s2,16(sp)
    80002cf0:	69a2                	ld	s3,8(sp)
    80002cf2:	6a02                	ld	s4,0(sp)
    80002cf4:	6145                	addi	sp,sp,48
    80002cf6:	8082                	ret
    panic("iget: no inodes");
    80002cf8:	00005517          	auipc	a0,0x5
    80002cfc:	78850513          	addi	a0,a0,1928 # 80008480 <etext+0x480>
    80002d00:	00003097          	auipc	ra,0x3
    80002d04:	452080e7          	jalr	1106(ra) # 80006152 <panic>

0000000080002d08 <fsinit>:
fsinit(int dev) {
    80002d08:	7179                	addi	sp,sp,-48
    80002d0a:	f406                	sd	ra,40(sp)
    80002d0c:	f022                	sd	s0,32(sp)
    80002d0e:	ec26                	sd	s1,24(sp)
    80002d10:	e84a                	sd	s2,16(sp)
    80002d12:	e44e                	sd	s3,8(sp)
    80002d14:	1800                	addi	s0,sp,48
    80002d16:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002d18:	4585                	li	a1,1
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	a3e080e7          	jalr	-1474(ra) # 80002758 <bread>
    80002d22:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002d24:	00234997          	auipc	s3,0x234
    80002d28:	15c98993          	addi	s3,s3,348 # 80236e80 <sb>
    80002d2c:	02000613          	li	a2,32
    80002d30:	05850593          	addi	a1,a0,88
    80002d34:	854e                	mv	a0,s3
    80002d36:	ffffd097          	auipc	ra,0xffffd
    80002d3a:	5d0080e7          	jalr	1488(ra) # 80000306 <memmove>
  brelse(bp);
    80002d3e:	8526                	mv	a0,s1
    80002d40:	00000097          	auipc	ra,0x0
    80002d44:	b48080e7          	jalr	-1208(ra) # 80002888 <brelse>
  if(sb.magic != FSMAGIC)
    80002d48:	0009a703          	lw	a4,0(s3)
    80002d4c:	102037b7          	lui	a5,0x10203
    80002d50:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002d54:	02f71263          	bne	a4,a5,80002d78 <fsinit+0x70>
  initlog(dev, &sb);
    80002d58:	00234597          	auipc	a1,0x234
    80002d5c:	12858593          	addi	a1,a1,296 # 80236e80 <sb>
    80002d60:	854a                	mv	a0,s2
    80002d62:	00001097          	auipc	ra,0x1
    80002d66:	b60080e7          	jalr	-1184(ra) # 800038c2 <initlog>
}
    80002d6a:	70a2                	ld	ra,40(sp)
    80002d6c:	7402                	ld	s0,32(sp)
    80002d6e:	64e2                	ld	s1,24(sp)
    80002d70:	6942                	ld	s2,16(sp)
    80002d72:	69a2                	ld	s3,8(sp)
    80002d74:	6145                	addi	sp,sp,48
    80002d76:	8082                	ret
    panic("invalid file system");
    80002d78:	00005517          	auipc	a0,0x5
    80002d7c:	71850513          	addi	a0,a0,1816 # 80008490 <etext+0x490>
    80002d80:	00003097          	auipc	ra,0x3
    80002d84:	3d2080e7          	jalr	978(ra) # 80006152 <panic>

0000000080002d88 <iinit>:
{
    80002d88:	7179                	addi	sp,sp,-48
    80002d8a:	f406                	sd	ra,40(sp)
    80002d8c:	f022                	sd	s0,32(sp)
    80002d8e:	ec26                	sd	s1,24(sp)
    80002d90:	e84a                	sd	s2,16(sp)
    80002d92:	e44e                	sd	s3,8(sp)
    80002d94:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002d96:	00005597          	auipc	a1,0x5
    80002d9a:	71258593          	addi	a1,a1,1810 # 800084a8 <etext+0x4a8>
    80002d9e:	00234517          	auipc	a0,0x234
    80002da2:	10250513          	addi	a0,a0,258 # 80236ea0 <itable>
    80002da6:	00004097          	auipc	ra,0x4
    80002daa:	896080e7          	jalr	-1898(ra) # 8000663c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002dae:	00234497          	auipc	s1,0x234
    80002db2:	11a48493          	addi	s1,s1,282 # 80236ec8 <itable+0x28>
    80002db6:	00236997          	auipc	s3,0x236
    80002dba:	ba298993          	addi	s3,s3,-1118 # 80238958 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002dbe:	00005917          	auipc	s2,0x5
    80002dc2:	6f290913          	addi	s2,s2,1778 # 800084b0 <etext+0x4b0>
    80002dc6:	85ca                	mv	a1,s2
    80002dc8:	8526                	mv	a0,s1
    80002dca:	00001097          	auipc	ra,0x1
    80002dce:	e4c080e7          	jalr	-436(ra) # 80003c16 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002dd2:	08848493          	addi	s1,s1,136
    80002dd6:	ff3498e3          	bne	s1,s3,80002dc6 <iinit+0x3e>
}
    80002dda:	70a2                	ld	ra,40(sp)
    80002ddc:	7402                	ld	s0,32(sp)
    80002dde:	64e2                	ld	s1,24(sp)
    80002de0:	6942                	ld	s2,16(sp)
    80002de2:	69a2                	ld	s3,8(sp)
    80002de4:	6145                	addi	sp,sp,48
    80002de6:	8082                	ret

0000000080002de8 <ialloc>:
{
    80002de8:	7139                	addi	sp,sp,-64
    80002dea:	fc06                	sd	ra,56(sp)
    80002dec:	f822                	sd	s0,48(sp)
    80002dee:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002df0:	00234717          	auipc	a4,0x234
    80002df4:	09c72703          	lw	a4,156(a4) # 80236e8c <sb+0xc>
    80002df8:	4785                	li	a5,1
    80002dfa:	06e7f463          	bgeu	a5,a4,80002e62 <ialloc+0x7a>
    80002dfe:	f426                	sd	s1,40(sp)
    80002e00:	f04a                	sd	s2,32(sp)
    80002e02:	ec4e                	sd	s3,24(sp)
    80002e04:	e852                	sd	s4,16(sp)
    80002e06:	e456                	sd	s5,8(sp)
    80002e08:	e05a                	sd	s6,0(sp)
    80002e0a:	8aaa                	mv	s5,a0
    80002e0c:	8b2e                	mv	s6,a1
    80002e0e:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002e10:	00234a17          	auipc	s4,0x234
    80002e14:	070a0a13          	addi	s4,s4,112 # 80236e80 <sb>
    80002e18:	00495593          	srli	a1,s2,0x4
    80002e1c:	018a2783          	lw	a5,24(s4)
    80002e20:	9dbd                	addw	a1,a1,a5
    80002e22:	8556                	mv	a0,s5
    80002e24:	00000097          	auipc	ra,0x0
    80002e28:	934080e7          	jalr	-1740(ra) # 80002758 <bread>
    80002e2c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002e2e:	05850993          	addi	s3,a0,88
    80002e32:	00f97793          	andi	a5,s2,15
    80002e36:	079a                	slli	a5,a5,0x6
    80002e38:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002e3a:	00099783          	lh	a5,0(s3)
    80002e3e:	cf9d                	beqz	a5,80002e7c <ialloc+0x94>
    brelse(bp);
    80002e40:	00000097          	auipc	ra,0x0
    80002e44:	a48080e7          	jalr	-1464(ra) # 80002888 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002e48:	0905                	addi	s2,s2,1
    80002e4a:	00ca2703          	lw	a4,12(s4)
    80002e4e:	0009079b          	sext.w	a5,s2
    80002e52:	fce7e3e3          	bltu	a5,a4,80002e18 <ialloc+0x30>
    80002e56:	74a2                	ld	s1,40(sp)
    80002e58:	7902                	ld	s2,32(sp)
    80002e5a:	69e2                	ld	s3,24(sp)
    80002e5c:	6a42                	ld	s4,16(sp)
    80002e5e:	6aa2                	ld	s5,8(sp)
    80002e60:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002e62:	00005517          	auipc	a0,0x5
    80002e66:	65650513          	addi	a0,a0,1622 # 800084b8 <etext+0x4b8>
    80002e6a:	00003097          	auipc	ra,0x3
    80002e6e:	332080e7          	jalr	818(ra) # 8000619c <printf>
  return 0;
    80002e72:	4501                	li	a0,0
}
    80002e74:	70e2                	ld	ra,56(sp)
    80002e76:	7442                	ld	s0,48(sp)
    80002e78:	6121                	addi	sp,sp,64
    80002e7a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002e7c:	04000613          	li	a2,64
    80002e80:	4581                	li	a1,0
    80002e82:	854e                	mv	a0,s3
    80002e84:	ffffd097          	auipc	ra,0xffffd
    80002e88:	426080e7          	jalr	1062(ra) # 800002aa <memset>
      dip->type = type;
    80002e8c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002e90:	8526                	mv	a0,s1
    80002e92:	00001097          	auipc	ra,0x1
    80002e96:	ca0080e7          	jalr	-864(ra) # 80003b32 <log_write>
      brelse(bp);
    80002e9a:	8526                	mv	a0,s1
    80002e9c:	00000097          	auipc	ra,0x0
    80002ea0:	9ec080e7          	jalr	-1556(ra) # 80002888 <brelse>
      return iget(dev, inum);
    80002ea4:	0009059b          	sext.w	a1,s2
    80002ea8:	8556                	mv	a0,s5
    80002eaa:	00000097          	auipc	ra,0x0
    80002eae:	da2080e7          	jalr	-606(ra) # 80002c4c <iget>
    80002eb2:	74a2                	ld	s1,40(sp)
    80002eb4:	7902                	ld	s2,32(sp)
    80002eb6:	69e2                	ld	s3,24(sp)
    80002eb8:	6a42                	ld	s4,16(sp)
    80002eba:	6aa2                	ld	s5,8(sp)
    80002ebc:	6b02                	ld	s6,0(sp)
    80002ebe:	bf5d                	j	80002e74 <ialloc+0x8c>

0000000080002ec0 <iupdate>:
{
    80002ec0:	1101                	addi	sp,sp,-32
    80002ec2:	ec06                	sd	ra,24(sp)
    80002ec4:	e822                	sd	s0,16(sp)
    80002ec6:	e426                	sd	s1,8(sp)
    80002ec8:	e04a                	sd	s2,0(sp)
    80002eca:	1000                	addi	s0,sp,32
    80002ecc:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ece:	415c                	lw	a5,4(a0)
    80002ed0:	0047d79b          	srliw	a5,a5,0x4
    80002ed4:	00234597          	auipc	a1,0x234
    80002ed8:	fc45a583          	lw	a1,-60(a1) # 80236e98 <sb+0x18>
    80002edc:	9dbd                	addw	a1,a1,a5
    80002ede:	4108                	lw	a0,0(a0)
    80002ee0:	00000097          	auipc	ra,0x0
    80002ee4:	878080e7          	jalr	-1928(ra) # 80002758 <bread>
    80002ee8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002eea:	05850793          	addi	a5,a0,88
    80002eee:	40d8                	lw	a4,4(s1)
    80002ef0:	8b3d                	andi	a4,a4,15
    80002ef2:	071a                	slli	a4,a4,0x6
    80002ef4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002ef6:	04449703          	lh	a4,68(s1)
    80002efa:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002efe:	04649703          	lh	a4,70(s1)
    80002f02:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002f06:	04849703          	lh	a4,72(s1)
    80002f0a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002f0e:	04a49703          	lh	a4,74(s1)
    80002f12:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002f16:	44f8                	lw	a4,76(s1)
    80002f18:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002f1a:	03400613          	li	a2,52
    80002f1e:	05048593          	addi	a1,s1,80
    80002f22:	00c78513          	addi	a0,a5,12
    80002f26:	ffffd097          	auipc	ra,0xffffd
    80002f2a:	3e0080e7          	jalr	992(ra) # 80000306 <memmove>
  log_write(bp);
    80002f2e:	854a                	mv	a0,s2
    80002f30:	00001097          	auipc	ra,0x1
    80002f34:	c02080e7          	jalr	-1022(ra) # 80003b32 <log_write>
  brelse(bp);
    80002f38:	854a                	mv	a0,s2
    80002f3a:	00000097          	auipc	ra,0x0
    80002f3e:	94e080e7          	jalr	-1714(ra) # 80002888 <brelse>
}
    80002f42:	60e2                	ld	ra,24(sp)
    80002f44:	6442                	ld	s0,16(sp)
    80002f46:	64a2                	ld	s1,8(sp)
    80002f48:	6902                	ld	s2,0(sp)
    80002f4a:	6105                	addi	sp,sp,32
    80002f4c:	8082                	ret

0000000080002f4e <idup>:
{
    80002f4e:	1101                	addi	sp,sp,-32
    80002f50:	ec06                	sd	ra,24(sp)
    80002f52:	e822                	sd	s0,16(sp)
    80002f54:	e426                	sd	s1,8(sp)
    80002f56:	1000                	addi	s0,sp,32
    80002f58:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f5a:	00234517          	auipc	a0,0x234
    80002f5e:	f4650513          	addi	a0,a0,-186 # 80236ea0 <itable>
    80002f62:	00003097          	auipc	ra,0x3
    80002f66:	76a080e7          	jalr	1898(ra) # 800066cc <acquire>
  ip->ref++;
    80002f6a:	449c                	lw	a5,8(s1)
    80002f6c:	2785                	addiw	a5,a5,1
    80002f6e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f70:	00234517          	auipc	a0,0x234
    80002f74:	f3050513          	addi	a0,a0,-208 # 80236ea0 <itable>
    80002f78:	00004097          	auipc	ra,0x4
    80002f7c:	808080e7          	jalr	-2040(ra) # 80006780 <release>
}
    80002f80:	8526                	mv	a0,s1
    80002f82:	60e2                	ld	ra,24(sp)
    80002f84:	6442                	ld	s0,16(sp)
    80002f86:	64a2                	ld	s1,8(sp)
    80002f88:	6105                	addi	sp,sp,32
    80002f8a:	8082                	ret

0000000080002f8c <ilock>:
{
    80002f8c:	1101                	addi	sp,sp,-32
    80002f8e:	ec06                	sd	ra,24(sp)
    80002f90:	e822                	sd	s0,16(sp)
    80002f92:	e426                	sd	s1,8(sp)
    80002f94:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002f96:	c10d                	beqz	a0,80002fb8 <ilock+0x2c>
    80002f98:	84aa                	mv	s1,a0
    80002f9a:	451c                	lw	a5,8(a0)
    80002f9c:	00f05e63          	blez	a5,80002fb8 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002fa0:	0541                	addi	a0,a0,16
    80002fa2:	00001097          	auipc	ra,0x1
    80002fa6:	cae080e7          	jalr	-850(ra) # 80003c50 <acquiresleep>
  if(ip->valid == 0){
    80002faa:	40bc                	lw	a5,64(s1)
    80002fac:	cf99                	beqz	a5,80002fca <ilock+0x3e>
}
    80002fae:	60e2                	ld	ra,24(sp)
    80002fb0:	6442                	ld	s0,16(sp)
    80002fb2:	64a2                	ld	s1,8(sp)
    80002fb4:	6105                	addi	sp,sp,32
    80002fb6:	8082                	ret
    80002fb8:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002fba:	00005517          	auipc	a0,0x5
    80002fbe:	51650513          	addi	a0,a0,1302 # 800084d0 <etext+0x4d0>
    80002fc2:	00003097          	auipc	ra,0x3
    80002fc6:	190080e7          	jalr	400(ra) # 80006152 <panic>
    80002fca:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002fcc:	40dc                	lw	a5,4(s1)
    80002fce:	0047d79b          	srliw	a5,a5,0x4
    80002fd2:	00234597          	auipc	a1,0x234
    80002fd6:	ec65a583          	lw	a1,-314(a1) # 80236e98 <sb+0x18>
    80002fda:	9dbd                	addw	a1,a1,a5
    80002fdc:	4088                	lw	a0,0(s1)
    80002fde:	fffff097          	auipc	ra,0xfffff
    80002fe2:	77a080e7          	jalr	1914(ra) # 80002758 <bread>
    80002fe6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002fe8:	05850593          	addi	a1,a0,88
    80002fec:	40dc                	lw	a5,4(s1)
    80002fee:	8bbd                	andi	a5,a5,15
    80002ff0:	079a                	slli	a5,a5,0x6
    80002ff2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ff4:	00059783          	lh	a5,0(a1)
    80002ff8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ffc:	00259783          	lh	a5,2(a1)
    80003000:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003004:	00459783          	lh	a5,4(a1)
    80003008:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000300c:	00659783          	lh	a5,6(a1)
    80003010:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003014:	459c                	lw	a5,8(a1)
    80003016:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003018:	03400613          	li	a2,52
    8000301c:	05b1                	addi	a1,a1,12
    8000301e:	05048513          	addi	a0,s1,80
    80003022:	ffffd097          	auipc	ra,0xffffd
    80003026:	2e4080e7          	jalr	740(ra) # 80000306 <memmove>
    brelse(bp);
    8000302a:	854a                	mv	a0,s2
    8000302c:	00000097          	auipc	ra,0x0
    80003030:	85c080e7          	jalr	-1956(ra) # 80002888 <brelse>
    ip->valid = 1;
    80003034:	4785                	li	a5,1
    80003036:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003038:	04449783          	lh	a5,68(s1)
    8000303c:	c399                	beqz	a5,80003042 <ilock+0xb6>
    8000303e:	6902                	ld	s2,0(sp)
    80003040:	b7bd                	j	80002fae <ilock+0x22>
      panic("ilock: no type");
    80003042:	00005517          	auipc	a0,0x5
    80003046:	49650513          	addi	a0,a0,1174 # 800084d8 <etext+0x4d8>
    8000304a:	00003097          	auipc	ra,0x3
    8000304e:	108080e7          	jalr	264(ra) # 80006152 <panic>

0000000080003052 <iunlock>:
{
    80003052:	1101                	addi	sp,sp,-32
    80003054:	ec06                	sd	ra,24(sp)
    80003056:	e822                	sd	s0,16(sp)
    80003058:	e426                	sd	s1,8(sp)
    8000305a:	e04a                	sd	s2,0(sp)
    8000305c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000305e:	c905                	beqz	a0,8000308e <iunlock+0x3c>
    80003060:	84aa                	mv	s1,a0
    80003062:	01050913          	addi	s2,a0,16
    80003066:	854a                	mv	a0,s2
    80003068:	00001097          	auipc	ra,0x1
    8000306c:	c82080e7          	jalr	-894(ra) # 80003cea <holdingsleep>
    80003070:	cd19                	beqz	a0,8000308e <iunlock+0x3c>
    80003072:	449c                	lw	a5,8(s1)
    80003074:	00f05d63          	blez	a5,8000308e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003078:	854a                	mv	a0,s2
    8000307a:	00001097          	auipc	ra,0x1
    8000307e:	c2c080e7          	jalr	-980(ra) # 80003ca6 <releasesleep>
}
    80003082:	60e2                	ld	ra,24(sp)
    80003084:	6442                	ld	s0,16(sp)
    80003086:	64a2                	ld	s1,8(sp)
    80003088:	6902                	ld	s2,0(sp)
    8000308a:	6105                	addi	sp,sp,32
    8000308c:	8082                	ret
    panic("iunlock");
    8000308e:	00005517          	auipc	a0,0x5
    80003092:	45a50513          	addi	a0,a0,1114 # 800084e8 <etext+0x4e8>
    80003096:	00003097          	auipc	ra,0x3
    8000309a:	0bc080e7          	jalr	188(ra) # 80006152 <panic>

000000008000309e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000309e:	7179                	addi	sp,sp,-48
    800030a0:	f406                	sd	ra,40(sp)
    800030a2:	f022                	sd	s0,32(sp)
    800030a4:	ec26                	sd	s1,24(sp)
    800030a6:	e84a                	sd	s2,16(sp)
    800030a8:	e44e                	sd	s3,8(sp)
    800030aa:	1800                	addi	s0,sp,48
    800030ac:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800030ae:	05050493          	addi	s1,a0,80
    800030b2:	08050913          	addi	s2,a0,128
    800030b6:	a021                	j	800030be <itrunc+0x20>
    800030b8:	0491                	addi	s1,s1,4
    800030ba:	01248d63          	beq	s1,s2,800030d4 <itrunc+0x36>
    if(ip->addrs[i]){
    800030be:	408c                	lw	a1,0(s1)
    800030c0:	dde5                	beqz	a1,800030b8 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800030c2:	0009a503          	lw	a0,0(s3)
    800030c6:	00000097          	auipc	ra,0x0
    800030ca:	8d6080e7          	jalr	-1834(ra) # 8000299c <bfree>
      ip->addrs[i] = 0;
    800030ce:	0004a023          	sw	zero,0(s1)
    800030d2:	b7dd                	j	800030b8 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800030d4:	0809a583          	lw	a1,128(s3)
    800030d8:	ed99                	bnez	a1,800030f6 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800030da:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800030de:	854e                	mv	a0,s3
    800030e0:	00000097          	auipc	ra,0x0
    800030e4:	de0080e7          	jalr	-544(ra) # 80002ec0 <iupdate>
}
    800030e8:	70a2                	ld	ra,40(sp)
    800030ea:	7402                	ld	s0,32(sp)
    800030ec:	64e2                	ld	s1,24(sp)
    800030ee:	6942                	ld	s2,16(sp)
    800030f0:	69a2                	ld	s3,8(sp)
    800030f2:	6145                	addi	sp,sp,48
    800030f4:	8082                	ret
    800030f6:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800030f8:	0009a503          	lw	a0,0(s3)
    800030fc:	fffff097          	auipc	ra,0xfffff
    80003100:	65c080e7          	jalr	1628(ra) # 80002758 <bread>
    80003104:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003106:	05850493          	addi	s1,a0,88
    8000310a:	45850913          	addi	s2,a0,1112
    8000310e:	a021                	j	80003116 <itrunc+0x78>
    80003110:	0491                	addi	s1,s1,4
    80003112:	01248b63          	beq	s1,s2,80003128 <itrunc+0x8a>
      if(a[j])
    80003116:	408c                	lw	a1,0(s1)
    80003118:	dde5                	beqz	a1,80003110 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    8000311a:	0009a503          	lw	a0,0(s3)
    8000311e:	00000097          	auipc	ra,0x0
    80003122:	87e080e7          	jalr	-1922(ra) # 8000299c <bfree>
    80003126:	b7ed                	j	80003110 <itrunc+0x72>
    brelse(bp);
    80003128:	8552                	mv	a0,s4
    8000312a:	fffff097          	auipc	ra,0xfffff
    8000312e:	75e080e7          	jalr	1886(ra) # 80002888 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003132:	0809a583          	lw	a1,128(s3)
    80003136:	0009a503          	lw	a0,0(s3)
    8000313a:	00000097          	auipc	ra,0x0
    8000313e:	862080e7          	jalr	-1950(ra) # 8000299c <bfree>
    ip->addrs[NDIRECT] = 0;
    80003142:	0809a023          	sw	zero,128(s3)
    80003146:	6a02                	ld	s4,0(sp)
    80003148:	bf49                	j	800030da <itrunc+0x3c>

000000008000314a <iput>:
{
    8000314a:	1101                	addi	sp,sp,-32
    8000314c:	ec06                	sd	ra,24(sp)
    8000314e:	e822                	sd	s0,16(sp)
    80003150:	e426                	sd	s1,8(sp)
    80003152:	1000                	addi	s0,sp,32
    80003154:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003156:	00234517          	auipc	a0,0x234
    8000315a:	d4a50513          	addi	a0,a0,-694 # 80236ea0 <itable>
    8000315e:	00003097          	auipc	ra,0x3
    80003162:	56e080e7          	jalr	1390(ra) # 800066cc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003166:	4498                	lw	a4,8(s1)
    80003168:	4785                	li	a5,1
    8000316a:	02f70263          	beq	a4,a5,8000318e <iput+0x44>
  ip->ref--;
    8000316e:	449c                	lw	a5,8(s1)
    80003170:	37fd                	addiw	a5,a5,-1
    80003172:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003174:	00234517          	auipc	a0,0x234
    80003178:	d2c50513          	addi	a0,a0,-724 # 80236ea0 <itable>
    8000317c:	00003097          	auipc	ra,0x3
    80003180:	604080e7          	jalr	1540(ra) # 80006780 <release>
}
    80003184:	60e2                	ld	ra,24(sp)
    80003186:	6442                	ld	s0,16(sp)
    80003188:	64a2                	ld	s1,8(sp)
    8000318a:	6105                	addi	sp,sp,32
    8000318c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000318e:	40bc                	lw	a5,64(s1)
    80003190:	dff9                	beqz	a5,8000316e <iput+0x24>
    80003192:	04a49783          	lh	a5,74(s1)
    80003196:	ffe1                	bnez	a5,8000316e <iput+0x24>
    80003198:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000319a:	01048913          	addi	s2,s1,16
    8000319e:	854a                	mv	a0,s2
    800031a0:	00001097          	auipc	ra,0x1
    800031a4:	ab0080e7          	jalr	-1360(ra) # 80003c50 <acquiresleep>
    release(&itable.lock);
    800031a8:	00234517          	auipc	a0,0x234
    800031ac:	cf850513          	addi	a0,a0,-776 # 80236ea0 <itable>
    800031b0:	00003097          	auipc	ra,0x3
    800031b4:	5d0080e7          	jalr	1488(ra) # 80006780 <release>
    itrunc(ip);
    800031b8:	8526                	mv	a0,s1
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	ee4080e7          	jalr	-284(ra) # 8000309e <itrunc>
    ip->type = 0;
    800031c2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800031c6:	8526                	mv	a0,s1
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	cf8080e7          	jalr	-776(ra) # 80002ec0 <iupdate>
    ip->valid = 0;
    800031d0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800031d4:	854a                	mv	a0,s2
    800031d6:	00001097          	auipc	ra,0x1
    800031da:	ad0080e7          	jalr	-1328(ra) # 80003ca6 <releasesleep>
    acquire(&itable.lock);
    800031de:	00234517          	auipc	a0,0x234
    800031e2:	cc250513          	addi	a0,a0,-830 # 80236ea0 <itable>
    800031e6:	00003097          	auipc	ra,0x3
    800031ea:	4e6080e7          	jalr	1254(ra) # 800066cc <acquire>
    800031ee:	6902                	ld	s2,0(sp)
    800031f0:	bfbd                	j	8000316e <iput+0x24>

00000000800031f2 <iunlockput>:
{
    800031f2:	1101                	addi	sp,sp,-32
    800031f4:	ec06                	sd	ra,24(sp)
    800031f6:	e822                	sd	s0,16(sp)
    800031f8:	e426                	sd	s1,8(sp)
    800031fa:	1000                	addi	s0,sp,32
    800031fc:	84aa                	mv	s1,a0
  iunlock(ip);
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	e54080e7          	jalr	-428(ra) # 80003052 <iunlock>
  iput(ip);
    80003206:	8526                	mv	a0,s1
    80003208:	00000097          	auipc	ra,0x0
    8000320c:	f42080e7          	jalr	-190(ra) # 8000314a <iput>
}
    80003210:	60e2                	ld	ra,24(sp)
    80003212:	6442                	ld	s0,16(sp)
    80003214:	64a2                	ld	s1,8(sp)
    80003216:	6105                	addi	sp,sp,32
    80003218:	8082                	ret

000000008000321a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000321a:	1141                	addi	sp,sp,-16
    8000321c:	e422                	sd	s0,8(sp)
    8000321e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003220:	411c                	lw	a5,0(a0)
    80003222:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003224:	415c                	lw	a5,4(a0)
    80003226:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003228:	04451783          	lh	a5,68(a0)
    8000322c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003230:	04a51783          	lh	a5,74(a0)
    80003234:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003238:	04c56783          	lwu	a5,76(a0)
    8000323c:	e99c                	sd	a5,16(a1)
}
    8000323e:	6422                	ld	s0,8(sp)
    80003240:	0141                	addi	sp,sp,16
    80003242:	8082                	ret

0000000080003244 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003244:	457c                	lw	a5,76(a0)
    80003246:	10d7e563          	bltu	a5,a3,80003350 <readi+0x10c>
{
    8000324a:	7159                	addi	sp,sp,-112
    8000324c:	f486                	sd	ra,104(sp)
    8000324e:	f0a2                	sd	s0,96(sp)
    80003250:	eca6                	sd	s1,88(sp)
    80003252:	e0d2                	sd	s4,64(sp)
    80003254:	fc56                	sd	s5,56(sp)
    80003256:	f85a                	sd	s6,48(sp)
    80003258:	f45e                	sd	s7,40(sp)
    8000325a:	1880                	addi	s0,sp,112
    8000325c:	8b2a                	mv	s6,a0
    8000325e:	8bae                	mv	s7,a1
    80003260:	8a32                	mv	s4,a2
    80003262:	84b6                	mv	s1,a3
    80003264:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003266:	9f35                	addw	a4,a4,a3
    return 0;
    80003268:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000326a:	0cd76a63          	bltu	a4,a3,8000333e <readi+0xfa>
    8000326e:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003270:	00e7f463          	bgeu	a5,a4,80003278 <readi+0x34>
    n = ip->size - off;
    80003274:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003278:	0a0a8963          	beqz	s5,8000332a <readi+0xe6>
    8000327c:	e8ca                	sd	s2,80(sp)
    8000327e:	f062                	sd	s8,32(sp)
    80003280:	ec66                	sd	s9,24(sp)
    80003282:	e86a                	sd	s10,16(sp)
    80003284:	e46e                	sd	s11,8(sp)
    80003286:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003288:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000328c:	5c7d                	li	s8,-1
    8000328e:	a82d                	j	800032c8 <readi+0x84>
    80003290:	020d1d93          	slli	s11,s10,0x20
    80003294:	020ddd93          	srli	s11,s11,0x20
    80003298:	05890613          	addi	a2,s2,88
    8000329c:	86ee                	mv	a3,s11
    8000329e:	963a                	add	a2,a2,a4
    800032a0:	85d2                	mv	a1,s4
    800032a2:	855e                	mv	a0,s7
    800032a4:	fffff097          	auipc	ra,0xfffff
    800032a8:	9a2080e7          	jalr	-1630(ra) # 80001c46 <either_copyout>
    800032ac:	05850d63          	beq	a0,s8,80003306 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800032b0:	854a                	mv	a0,s2
    800032b2:	fffff097          	auipc	ra,0xfffff
    800032b6:	5d6080e7          	jalr	1494(ra) # 80002888 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800032ba:	013d09bb          	addw	s3,s10,s3
    800032be:	009d04bb          	addw	s1,s10,s1
    800032c2:	9a6e                	add	s4,s4,s11
    800032c4:	0559fd63          	bgeu	s3,s5,8000331e <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    800032c8:	00a4d59b          	srliw	a1,s1,0xa
    800032cc:	855a                	mv	a0,s6
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	88e080e7          	jalr	-1906(ra) # 80002b5c <bmap>
    800032d6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800032da:	c9b1                	beqz	a1,8000332e <readi+0xea>
    bp = bread(ip->dev, addr);
    800032dc:	000b2503          	lw	a0,0(s6)
    800032e0:	fffff097          	auipc	ra,0xfffff
    800032e4:	478080e7          	jalr	1144(ra) # 80002758 <bread>
    800032e8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800032ea:	3ff4f713          	andi	a4,s1,1023
    800032ee:	40ec87bb          	subw	a5,s9,a4
    800032f2:	413a86bb          	subw	a3,s5,s3
    800032f6:	8d3e                	mv	s10,a5
    800032f8:	2781                	sext.w	a5,a5
    800032fa:	0006861b          	sext.w	a2,a3
    800032fe:	f8f679e3          	bgeu	a2,a5,80003290 <readi+0x4c>
    80003302:	8d36                	mv	s10,a3
    80003304:	b771                	j	80003290 <readi+0x4c>
      brelse(bp);
    80003306:	854a                	mv	a0,s2
    80003308:	fffff097          	auipc	ra,0xfffff
    8000330c:	580080e7          	jalr	1408(ra) # 80002888 <brelse>
      tot = -1;
    80003310:	59fd                	li	s3,-1
      break;
    80003312:	6946                	ld	s2,80(sp)
    80003314:	7c02                	ld	s8,32(sp)
    80003316:	6ce2                	ld	s9,24(sp)
    80003318:	6d42                	ld	s10,16(sp)
    8000331a:	6da2                	ld	s11,8(sp)
    8000331c:	a831                	j	80003338 <readi+0xf4>
    8000331e:	6946                	ld	s2,80(sp)
    80003320:	7c02                	ld	s8,32(sp)
    80003322:	6ce2                	ld	s9,24(sp)
    80003324:	6d42                	ld	s10,16(sp)
    80003326:	6da2                	ld	s11,8(sp)
    80003328:	a801                	j	80003338 <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000332a:	89d6                	mv	s3,s5
    8000332c:	a031                	j	80003338 <readi+0xf4>
    8000332e:	6946                	ld	s2,80(sp)
    80003330:	7c02                	ld	s8,32(sp)
    80003332:	6ce2                	ld	s9,24(sp)
    80003334:	6d42                	ld	s10,16(sp)
    80003336:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003338:	0009851b          	sext.w	a0,s3
    8000333c:	69a6                	ld	s3,72(sp)
}
    8000333e:	70a6                	ld	ra,104(sp)
    80003340:	7406                	ld	s0,96(sp)
    80003342:	64e6                	ld	s1,88(sp)
    80003344:	6a06                	ld	s4,64(sp)
    80003346:	7ae2                	ld	s5,56(sp)
    80003348:	7b42                	ld	s6,48(sp)
    8000334a:	7ba2                	ld	s7,40(sp)
    8000334c:	6165                	addi	sp,sp,112
    8000334e:	8082                	ret
    return 0;
    80003350:	4501                	li	a0,0
}
    80003352:	8082                	ret

0000000080003354 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003354:	457c                	lw	a5,76(a0)
    80003356:	10d7ee63          	bltu	a5,a3,80003472 <writei+0x11e>
{
    8000335a:	7159                	addi	sp,sp,-112
    8000335c:	f486                	sd	ra,104(sp)
    8000335e:	f0a2                	sd	s0,96(sp)
    80003360:	e8ca                	sd	s2,80(sp)
    80003362:	e0d2                	sd	s4,64(sp)
    80003364:	fc56                	sd	s5,56(sp)
    80003366:	f85a                	sd	s6,48(sp)
    80003368:	f45e                	sd	s7,40(sp)
    8000336a:	1880                	addi	s0,sp,112
    8000336c:	8aaa                	mv	s5,a0
    8000336e:	8bae                	mv	s7,a1
    80003370:	8a32                	mv	s4,a2
    80003372:	8936                	mv	s2,a3
    80003374:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003376:	00e687bb          	addw	a5,a3,a4
    8000337a:	0ed7ee63          	bltu	a5,a3,80003476 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000337e:	00043737          	lui	a4,0x43
    80003382:	0ef76c63          	bltu	a4,a5,8000347a <writei+0x126>
    80003386:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003388:	0c0b0d63          	beqz	s6,80003462 <writei+0x10e>
    8000338c:	eca6                	sd	s1,88(sp)
    8000338e:	f062                	sd	s8,32(sp)
    80003390:	ec66                	sd	s9,24(sp)
    80003392:	e86a                	sd	s10,16(sp)
    80003394:	e46e                	sd	s11,8(sp)
    80003396:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003398:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000339c:	5c7d                	li	s8,-1
    8000339e:	a091                	j	800033e2 <writei+0x8e>
    800033a0:	020d1d93          	slli	s11,s10,0x20
    800033a4:	020ddd93          	srli	s11,s11,0x20
    800033a8:	05848513          	addi	a0,s1,88
    800033ac:	86ee                	mv	a3,s11
    800033ae:	8652                	mv	a2,s4
    800033b0:	85de                	mv	a1,s7
    800033b2:	953a                	add	a0,a0,a4
    800033b4:	fffff097          	auipc	ra,0xfffff
    800033b8:	8e8080e7          	jalr	-1816(ra) # 80001c9c <either_copyin>
    800033bc:	07850263          	beq	a0,s8,80003420 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800033c0:	8526                	mv	a0,s1
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	770080e7          	jalr	1904(ra) # 80003b32 <log_write>
    brelse(bp);
    800033ca:	8526                	mv	a0,s1
    800033cc:	fffff097          	auipc	ra,0xfffff
    800033d0:	4bc080e7          	jalr	1212(ra) # 80002888 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800033d4:	013d09bb          	addw	s3,s10,s3
    800033d8:	012d093b          	addw	s2,s10,s2
    800033dc:	9a6e                	add	s4,s4,s11
    800033de:	0569f663          	bgeu	s3,s6,8000342a <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800033e2:	00a9559b          	srliw	a1,s2,0xa
    800033e6:	8556                	mv	a0,s5
    800033e8:	fffff097          	auipc	ra,0xfffff
    800033ec:	774080e7          	jalr	1908(ra) # 80002b5c <bmap>
    800033f0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800033f4:	c99d                	beqz	a1,8000342a <writei+0xd6>
    bp = bread(ip->dev, addr);
    800033f6:	000aa503          	lw	a0,0(s5)
    800033fa:	fffff097          	auipc	ra,0xfffff
    800033fe:	35e080e7          	jalr	862(ra) # 80002758 <bread>
    80003402:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003404:	3ff97713          	andi	a4,s2,1023
    80003408:	40ec87bb          	subw	a5,s9,a4
    8000340c:	413b06bb          	subw	a3,s6,s3
    80003410:	8d3e                	mv	s10,a5
    80003412:	2781                	sext.w	a5,a5
    80003414:	0006861b          	sext.w	a2,a3
    80003418:	f8f674e3          	bgeu	a2,a5,800033a0 <writei+0x4c>
    8000341c:	8d36                	mv	s10,a3
    8000341e:	b749                	j	800033a0 <writei+0x4c>
      brelse(bp);
    80003420:	8526                	mv	a0,s1
    80003422:	fffff097          	auipc	ra,0xfffff
    80003426:	466080e7          	jalr	1126(ra) # 80002888 <brelse>
  }

  if(off > ip->size)
    8000342a:	04caa783          	lw	a5,76(s5)
    8000342e:	0327fc63          	bgeu	a5,s2,80003466 <writei+0x112>
    ip->size = off;
    80003432:	052aa623          	sw	s2,76(s5)
    80003436:	64e6                	ld	s1,88(sp)
    80003438:	7c02                	ld	s8,32(sp)
    8000343a:	6ce2                	ld	s9,24(sp)
    8000343c:	6d42                	ld	s10,16(sp)
    8000343e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003440:	8556                	mv	a0,s5
    80003442:	00000097          	auipc	ra,0x0
    80003446:	a7e080e7          	jalr	-1410(ra) # 80002ec0 <iupdate>

  return tot;
    8000344a:	0009851b          	sext.w	a0,s3
    8000344e:	69a6                	ld	s3,72(sp)
}
    80003450:	70a6                	ld	ra,104(sp)
    80003452:	7406                	ld	s0,96(sp)
    80003454:	6946                	ld	s2,80(sp)
    80003456:	6a06                	ld	s4,64(sp)
    80003458:	7ae2                	ld	s5,56(sp)
    8000345a:	7b42                	ld	s6,48(sp)
    8000345c:	7ba2                	ld	s7,40(sp)
    8000345e:	6165                	addi	sp,sp,112
    80003460:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003462:	89da                	mv	s3,s6
    80003464:	bff1                	j	80003440 <writei+0xec>
    80003466:	64e6                	ld	s1,88(sp)
    80003468:	7c02                	ld	s8,32(sp)
    8000346a:	6ce2                	ld	s9,24(sp)
    8000346c:	6d42                	ld	s10,16(sp)
    8000346e:	6da2                	ld	s11,8(sp)
    80003470:	bfc1                	j	80003440 <writei+0xec>
    return -1;
    80003472:	557d                	li	a0,-1
}
    80003474:	8082                	ret
    return -1;
    80003476:	557d                	li	a0,-1
    80003478:	bfe1                	j	80003450 <writei+0xfc>
    return -1;
    8000347a:	557d                	li	a0,-1
    8000347c:	bfd1                	j	80003450 <writei+0xfc>

000000008000347e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000347e:	1141                	addi	sp,sp,-16
    80003480:	e406                	sd	ra,8(sp)
    80003482:	e022                	sd	s0,0(sp)
    80003484:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003486:	4639                	li	a2,14
    80003488:	ffffd097          	auipc	ra,0xffffd
    8000348c:	ef2080e7          	jalr	-270(ra) # 8000037a <strncmp>
}
    80003490:	60a2                	ld	ra,8(sp)
    80003492:	6402                	ld	s0,0(sp)
    80003494:	0141                	addi	sp,sp,16
    80003496:	8082                	ret

0000000080003498 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003498:	7139                	addi	sp,sp,-64
    8000349a:	fc06                	sd	ra,56(sp)
    8000349c:	f822                	sd	s0,48(sp)
    8000349e:	f426                	sd	s1,40(sp)
    800034a0:	f04a                	sd	s2,32(sp)
    800034a2:	ec4e                	sd	s3,24(sp)
    800034a4:	e852                	sd	s4,16(sp)
    800034a6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800034a8:	04451703          	lh	a4,68(a0)
    800034ac:	4785                	li	a5,1
    800034ae:	00f71a63          	bne	a4,a5,800034c2 <dirlookup+0x2a>
    800034b2:	892a                	mv	s2,a0
    800034b4:	89ae                	mv	s3,a1
    800034b6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800034b8:	457c                	lw	a5,76(a0)
    800034ba:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800034bc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034be:	e79d                	bnez	a5,800034ec <dirlookup+0x54>
    800034c0:	a8a5                	j	80003538 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800034c2:	00005517          	auipc	a0,0x5
    800034c6:	02e50513          	addi	a0,a0,46 # 800084f0 <etext+0x4f0>
    800034ca:	00003097          	auipc	ra,0x3
    800034ce:	c88080e7          	jalr	-888(ra) # 80006152 <panic>
      panic("dirlookup read");
    800034d2:	00005517          	auipc	a0,0x5
    800034d6:	03650513          	addi	a0,a0,54 # 80008508 <etext+0x508>
    800034da:	00003097          	auipc	ra,0x3
    800034de:	c78080e7          	jalr	-904(ra) # 80006152 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034e2:	24c1                	addiw	s1,s1,16
    800034e4:	04c92783          	lw	a5,76(s2)
    800034e8:	04f4f763          	bgeu	s1,a5,80003536 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034ec:	4741                	li	a4,16
    800034ee:	86a6                	mv	a3,s1
    800034f0:	fc040613          	addi	a2,s0,-64
    800034f4:	4581                	li	a1,0
    800034f6:	854a                	mv	a0,s2
    800034f8:	00000097          	auipc	ra,0x0
    800034fc:	d4c080e7          	jalr	-692(ra) # 80003244 <readi>
    80003500:	47c1                	li	a5,16
    80003502:	fcf518e3          	bne	a0,a5,800034d2 <dirlookup+0x3a>
    if(de.inum == 0)
    80003506:	fc045783          	lhu	a5,-64(s0)
    8000350a:	dfe1                	beqz	a5,800034e2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000350c:	fc240593          	addi	a1,s0,-62
    80003510:	854e                	mv	a0,s3
    80003512:	00000097          	auipc	ra,0x0
    80003516:	f6c080e7          	jalr	-148(ra) # 8000347e <namecmp>
    8000351a:	f561                	bnez	a0,800034e2 <dirlookup+0x4a>
      if(poff)
    8000351c:	000a0463          	beqz	s4,80003524 <dirlookup+0x8c>
        *poff = off;
    80003520:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003524:	fc045583          	lhu	a1,-64(s0)
    80003528:	00092503          	lw	a0,0(s2)
    8000352c:	fffff097          	auipc	ra,0xfffff
    80003530:	720080e7          	jalr	1824(ra) # 80002c4c <iget>
    80003534:	a011                	j	80003538 <dirlookup+0xa0>
  return 0;
    80003536:	4501                	li	a0,0
}
    80003538:	70e2                	ld	ra,56(sp)
    8000353a:	7442                	ld	s0,48(sp)
    8000353c:	74a2                	ld	s1,40(sp)
    8000353e:	7902                	ld	s2,32(sp)
    80003540:	69e2                	ld	s3,24(sp)
    80003542:	6a42                	ld	s4,16(sp)
    80003544:	6121                	addi	sp,sp,64
    80003546:	8082                	ret

0000000080003548 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003548:	711d                	addi	sp,sp,-96
    8000354a:	ec86                	sd	ra,88(sp)
    8000354c:	e8a2                	sd	s0,80(sp)
    8000354e:	e4a6                	sd	s1,72(sp)
    80003550:	e0ca                	sd	s2,64(sp)
    80003552:	fc4e                	sd	s3,56(sp)
    80003554:	f852                	sd	s4,48(sp)
    80003556:	f456                	sd	s5,40(sp)
    80003558:	f05a                	sd	s6,32(sp)
    8000355a:	ec5e                	sd	s7,24(sp)
    8000355c:	e862                	sd	s8,16(sp)
    8000355e:	e466                	sd	s9,8(sp)
    80003560:	1080                	addi	s0,sp,96
    80003562:	84aa                	mv	s1,a0
    80003564:	8b2e                	mv	s6,a1
    80003566:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003568:	00054703          	lbu	a4,0(a0)
    8000356c:	02f00793          	li	a5,47
    80003570:	02f70263          	beq	a4,a5,80003594 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003574:	ffffe097          	auipc	ra,0xffffe
    80003578:	c1c080e7          	jalr	-996(ra) # 80001190 <myproc>
    8000357c:	15053503          	ld	a0,336(a0)
    80003580:	00000097          	auipc	ra,0x0
    80003584:	9ce080e7          	jalr	-1586(ra) # 80002f4e <idup>
    80003588:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000358a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000358e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003590:	4b85                	li	s7,1
    80003592:	a875                	j	8000364e <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003594:	4585                	li	a1,1
    80003596:	4505                	li	a0,1
    80003598:	fffff097          	auipc	ra,0xfffff
    8000359c:	6b4080e7          	jalr	1716(ra) # 80002c4c <iget>
    800035a0:	8a2a                	mv	s4,a0
    800035a2:	b7e5                	j	8000358a <namex+0x42>
      iunlockput(ip);
    800035a4:	8552                	mv	a0,s4
    800035a6:	00000097          	auipc	ra,0x0
    800035aa:	c4c080e7          	jalr	-948(ra) # 800031f2 <iunlockput>
      return 0;
    800035ae:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800035b0:	8552                	mv	a0,s4
    800035b2:	60e6                	ld	ra,88(sp)
    800035b4:	6446                	ld	s0,80(sp)
    800035b6:	64a6                	ld	s1,72(sp)
    800035b8:	6906                	ld	s2,64(sp)
    800035ba:	79e2                	ld	s3,56(sp)
    800035bc:	7a42                	ld	s4,48(sp)
    800035be:	7aa2                	ld	s5,40(sp)
    800035c0:	7b02                	ld	s6,32(sp)
    800035c2:	6be2                	ld	s7,24(sp)
    800035c4:	6c42                	ld	s8,16(sp)
    800035c6:	6ca2                	ld	s9,8(sp)
    800035c8:	6125                	addi	sp,sp,96
    800035ca:	8082                	ret
      iunlock(ip);
    800035cc:	8552                	mv	a0,s4
    800035ce:	00000097          	auipc	ra,0x0
    800035d2:	a84080e7          	jalr	-1404(ra) # 80003052 <iunlock>
      return ip;
    800035d6:	bfe9                	j	800035b0 <namex+0x68>
      iunlockput(ip);
    800035d8:	8552                	mv	a0,s4
    800035da:	00000097          	auipc	ra,0x0
    800035de:	c18080e7          	jalr	-1000(ra) # 800031f2 <iunlockput>
      return 0;
    800035e2:	8a4e                	mv	s4,s3
    800035e4:	b7f1                	j	800035b0 <namex+0x68>
  len = path - s;
    800035e6:	40998633          	sub	a2,s3,s1
    800035ea:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800035ee:	099c5863          	bge	s8,s9,8000367e <namex+0x136>
    memmove(name, s, DIRSIZ);
    800035f2:	4639                	li	a2,14
    800035f4:	85a6                	mv	a1,s1
    800035f6:	8556                	mv	a0,s5
    800035f8:	ffffd097          	auipc	ra,0xffffd
    800035fc:	d0e080e7          	jalr	-754(ra) # 80000306 <memmove>
    80003600:	84ce                	mv	s1,s3
  while(*path == '/')
    80003602:	0004c783          	lbu	a5,0(s1)
    80003606:	01279763          	bne	a5,s2,80003614 <namex+0xcc>
    path++;
    8000360a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000360c:	0004c783          	lbu	a5,0(s1)
    80003610:	ff278de3          	beq	a5,s2,8000360a <namex+0xc2>
    ilock(ip);
    80003614:	8552                	mv	a0,s4
    80003616:	00000097          	auipc	ra,0x0
    8000361a:	976080e7          	jalr	-1674(ra) # 80002f8c <ilock>
    if(ip->type != T_DIR){
    8000361e:	044a1783          	lh	a5,68(s4)
    80003622:	f97791e3          	bne	a5,s7,800035a4 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003626:	000b0563          	beqz	s6,80003630 <namex+0xe8>
    8000362a:	0004c783          	lbu	a5,0(s1)
    8000362e:	dfd9                	beqz	a5,800035cc <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003630:	4601                	li	a2,0
    80003632:	85d6                	mv	a1,s5
    80003634:	8552                	mv	a0,s4
    80003636:	00000097          	auipc	ra,0x0
    8000363a:	e62080e7          	jalr	-414(ra) # 80003498 <dirlookup>
    8000363e:	89aa                	mv	s3,a0
    80003640:	dd41                	beqz	a0,800035d8 <namex+0x90>
    iunlockput(ip);
    80003642:	8552                	mv	a0,s4
    80003644:	00000097          	auipc	ra,0x0
    80003648:	bae080e7          	jalr	-1106(ra) # 800031f2 <iunlockput>
    ip = next;
    8000364c:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000364e:	0004c783          	lbu	a5,0(s1)
    80003652:	01279763          	bne	a5,s2,80003660 <namex+0x118>
    path++;
    80003656:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003658:	0004c783          	lbu	a5,0(s1)
    8000365c:	ff278de3          	beq	a5,s2,80003656 <namex+0x10e>
  if(*path == 0)
    80003660:	cb9d                	beqz	a5,80003696 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003662:	0004c783          	lbu	a5,0(s1)
    80003666:	89a6                	mv	s3,s1
  len = path - s;
    80003668:	4c81                	li	s9,0
    8000366a:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000366c:	01278963          	beq	a5,s2,8000367e <namex+0x136>
    80003670:	dbbd                	beqz	a5,800035e6 <namex+0x9e>
    path++;
    80003672:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003674:	0009c783          	lbu	a5,0(s3)
    80003678:	ff279ce3          	bne	a5,s2,80003670 <namex+0x128>
    8000367c:	b7ad                	j	800035e6 <namex+0x9e>
    memmove(name, s, len);
    8000367e:	2601                	sext.w	a2,a2
    80003680:	85a6                	mv	a1,s1
    80003682:	8556                	mv	a0,s5
    80003684:	ffffd097          	auipc	ra,0xffffd
    80003688:	c82080e7          	jalr	-894(ra) # 80000306 <memmove>
    name[len] = 0;
    8000368c:	9cd6                	add	s9,s9,s5
    8000368e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003692:	84ce                	mv	s1,s3
    80003694:	b7bd                	j	80003602 <namex+0xba>
  if(nameiparent){
    80003696:	f00b0de3          	beqz	s6,800035b0 <namex+0x68>
    iput(ip);
    8000369a:	8552                	mv	a0,s4
    8000369c:	00000097          	auipc	ra,0x0
    800036a0:	aae080e7          	jalr	-1362(ra) # 8000314a <iput>
    return 0;
    800036a4:	4a01                	li	s4,0
    800036a6:	b729                	j	800035b0 <namex+0x68>

00000000800036a8 <dirlink>:
{
    800036a8:	7139                	addi	sp,sp,-64
    800036aa:	fc06                	sd	ra,56(sp)
    800036ac:	f822                	sd	s0,48(sp)
    800036ae:	f04a                	sd	s2,32(sp)
    800036b0:	ec4e                	sd	s3,24(sp)
    800036b2:	e852                	sd	s4,16(sp)
    800036b4:	0080                	addi	s0,sp,64
    800036b6:	892a                	mv	s2,a0
    800036b8:	8a2e                	mv	s4,a1
    800036ba:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800036bc:	4601                	li	a2,0
    800036be:	00000097          	auipc	ra,0x0
    800036c2:	dda080e7          	jalr	-550(ra) # 80003498 <dirlookup>
    800036c6:	ed25                	bnez	a0,8000373e <dirlink+0x96>
    800036c8:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800036ca:	04c92483          	lw	s1,76(s2)
    800036ce:	c49d                	beqz	s1,800036fc <dirlink+0x54>
    800036d0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800036d2:	4741                	li	a4,16
    800036d4:	86a6                	mv	a3,s1
    800036d6:	fc040613          	addi	a2,s0,-64
    800036da:	4581                	li	a1,0
    800036dc:	854a                	mv	a0,s2
    800036de:	00000097          	auipc	ra,0x0
    800036e2:	b66080e7          	jalr	-1178(ra) # 80003244 <readi>
    800036e6:	47c1                	li	a5,16
    800036e8:	06f51163          	bne	a0,a5,8000374a <dirlink+0xa2>
    if(de.inum == 0)
    800036ec:	fc045783          	lhu	a5,-64(s0)
    800036f0:	c791                	beqz	a5,800036fc <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800036f2:	24c1                	addiw	s1,s1,16
    800036f4:	04c92783          	lw	a5,76(s2)
    800036f8:	fcf4ede3          	bltu	s1,a5,800036d2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800036fc:	4639                	li	a2,14
    800036fe:	85d2                	mv	a1,s4
    80003700:	fc240513          	addi	a0,s0,-62
    80003704:	ffffd097          	auipc	ra,0xffffd
    80003708:	cac080e7          	jalr	-852(ra) # 800003b0 <strncpy>
  de.inum = inum;
    8000370c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003710:	4741                	li	a4,16
    80003712:	86a6                	mv	a3,s1
    80003714:	fc040613          	addi	a2,s0,-64
    80003718:	4581                	li	a1,0
    8000371a:	854a                	mv	a0,s2
    8000371c:	00000097          	auipc	ra,0x0
    80003720:	c38080e7          	jalr	-968(ra) # 80003354 <writei>
    80003724:	1541                	addi	a0,a0,-16
    80003726:	00a03533          	snez	a0,a0
    8000372a:	40a00533          	neg	a0,a0
    8000372e:	74a2                	ld	s1,40(sp)
}
    80003730:	70e2                	ld	ra,56(sp)
    80003732:	7442                	ld	s0,48(sp)
    80003734:	7902                	ld	s2,32(sp)
    80003736:	69e2                	ld	s3,24(sp)
    80003738:	6a42                	ld	s4,16(sp)
    8000373a:	6121                	addi	sp,sp,64
    8000373c:	8082                	ret
    iput(ip);
    8000373e:	00000097          	auipc	ra,0x0
    80003742:	a0c080e7          	jalr	-1524(ra) # 8000314a <iput>
    return -1;
    80003746:	557d                	li	a0,-1
    80003748:	b7e5                	j	80003730 <dirlink+0x88>
      panic("dirlink read");
    8000374a:	00005517          	auipc	a0,0x5
    8000374e:	dce50513          	addi	a0,a0,-562 # 80008518 <etext+0x518>
    80003752:	00003097          	auipc	ra,0x3
    80003756:	a00080e7          	jalr	-1536(ra) # 80006152 <panic>

000000008000375a <namei>:

struct inode*
namei(char *path)
{
    8000375a:	1101                	addi	sp,sp,-32
    8000375c:	ec06                	sd	ra,24(sp)
    8000375e:	e822                	sd	s0,16(sp)
    80003760:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003762:	fe040613          	addi	a2,s0,-32
    80003766:	4581                	li	a1,0
    80003768:	00000097          	auipc	ra,0x0
    8000376c:	de0080e7          	jalr	-544(ra) # 80003548 <namex>
}
    80003770:	60e2                	ld	ra,24(sp)
    80003772:	6442                	ld	s0,16(sp)
    80003774:	6105                	addi	sp,sp,32
    80003776:	8082                	ret

0000000080003778 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003778:	1141                	addi	sp,sp,-16
    8000377a:	e406                	sd	ra,8(sp)
    8000377c:	e022                	sd	s0,0(sp)
    8000377e:	0800                	addi	s0,sp,16
    80003780:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003782:	4585                	li	a1,1
    80003784:	00000097          	auipc	ra,0x0
    80003788:	dc4080e7          	jalr	-572(ra) # 80003548 <namex>
}
    8000378c:	60a2                	ld	ra,8(sp)
    8000378e:	6402                	ld	s0,0(sp)
    80003790:	0141                	addi	sp,sp,16
    80003792:	8082                	ret

0000000080003794 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003794:	1101                	addi	sp,sp,-32
    80003796:	ec06                	sd	ra,24(sp)
    80003798:	e822                	sd	s0,16(sp)
    8000379a:	e426                	sd	s1,8(sp)
    8000379c:	e04a                	sd	s2,0(sp)
    8000379e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800037a0:	00235917          	auipc	s2,0x235
    800037a4:	1a890913          	addi	s2,s2,424 # 80238948 <log>
    800037a8:	01892583          	lw	a1,24(s2)
    800037ac:	02892503          	lw	a0,40(s2)
    800037b0:	fffff097          	auipc	ra,0xfffff
    800037b4:	fa8080e7          	jalr	-88(ra) # 80002758 <bread>
    800037b8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800037ba:	02c92603          	lw	a2,44(s2)
    800037be:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800037c0:	00c05f63          	blez	a2,800037de <write_head+0x4a>
    800037c4:	00235717          	auipc	a4,0x235
    800037c8:	1b470713          	addi	a4,a4,436 # 80238978 <log+0x30>
    800037cc:	87aa                	mv	a5,a0
    800037ce:	060a                	slli	a2,a2,0x2
    800037d0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800037d2:	4314                	lw	a3,0(a4)
    800037d4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800037d6:	0711                	addi	a4,a4,4
    800037d8:	0791                	addi	a5,a5,4
    800037da:	fec79ce3          	bne	a5,a2,800037d2 <write_head+0x3e>
  }
  bwrite(buf);
    800037de:	8526                	mv	a0,s1
    800037e0:	fffff097          	auipc	ra,0xfffff
    800037e4:	06a080e7          	jalr	106(ra) # 8000284a <bwrite>
  brelse(buf);
    800037e8:	8526                	mv	a0,s1
    800037ea:	fffff097          	auipc	ra,0xfffff
    800037ee:	09e080e7          	jalr	158(ra) # 80002888 <brelse>
}
    800037f2:	60e2                	ld	ra,24(sp)
    800037f4:	6442                	ld	s0,16(sp)
    800037f6:	64a2                	ld	s1,8(sp)
    800037f8:	6902                	ld	s2,0(sp)
    800037fa:	6105                	addi	sp,sp,32
    800037fc:	8082                	ret

00000000800037fe <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800037fe:	00235797          	auipc	a5,0x235
    80003802:	1767a783          	lw	a5,374(a5) # 80238974 <log+0x2c>
    80003806:	0af05d63          	blez	a5,800038c0 <install_trans+0xc2>
{
    8000380a:	7139                	addi	sp,sp,-64
    8000380c:	fc06                	sd	ra,56(sp)
    8000380e:	f822                	sd	s0,48(sp)
    80003810:	f426                	sd	s1,40(sp)
    80003812:	f04a                	sd	s2,32(sp)
    80003814:	ec4e                	sd	s3,24(sp)
    80003816:	e852                	sd	s4,16(sp)
    80003818:	e456                	sd	s5,8(sp)
    8000381a:	e05a                	sd	s6,0(sp)
    8000381c:	0080                	addi	s0,sp,64
    8000381e:	8b2a                	mv	s6,a0
    80003820:	00235a97          	auipc	s5,0x235
    80003824:	158a8a93          	addi	s5,s5,344 # 80238978 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003828:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000382a:	00235997          	auipc	s3,0x235
    8000382e:	11e98993          	addi	s3,s3,286 # 80238948 <log>
    80003832:	a00d                	j	80003854 <install_trans+0x56>
    brelse(lbuf);
    80003834:	854a                	mv	a0,s2
    80003836:	fffff097          	auipc	ra,0xfffff
    8000383a:	052080e7          	jalr	82(ra) # 80002888 <brelse>
    brelse(dbuf);
    8000383e:	8526                	mv	a0,s1
    80003840:	fffff097          	auipc	ra,0xfffff
    80003844:	048080e7          	jalr	72(ra) # 80002888 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003848:	2a05                	addiw	s4,s4,1
    8000384a:	0a91                	addi	s5,s5,4
    8000384c:	02c9a783          	lw	a5,44(s3)
    80003850:	04fa5e63          	bge	s4,a5,800038ac <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003854:	0189a583          	lw	a1,24(s3)
    80003858:	014585bb          	addw	a1,a1,s4
    8000385c:	2585                	addiw	a1,a1,1
    8000385e:	0289a503          	lw	a0,40(s3)
    80003862:	fffff097          	auipc	ra,0xfffff
    80003866:	ef6080e7          	jalr	-266(ra) # 80002758 <bread>
    8000386a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000386c:	000aa583          	lw	a1,0(s5)
    80003870:	0289a503          	lw	a0,40(s3)
    80003874:	fffff097          	auipc	ra,0xfffff
    80003878:	ee4080e7          	jalr	-284(ra) # 80002758 <bread>
    8000387c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000387e:	40000613          	li	a2,1024
    80003882:	05890593          	addi	a1,s2,88
    80003886:	05850513          	addi	a0,a0,88
    8000388a:	ffffd097          	auipc	ra,0xffffd
    8000388e:	a7c080e7          	jalr	-1412(ra) # 80000306 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003892:	8526                	mv	a0,s1
    80003894:	fffff097          	auipc	ra,0xfffff
    80003898:	fb6080e7          	jalr	-74(ra) # 8000284a <bwrite>
    if(recovering == 0)
    8000389c:	f80b1ce3          	bnez	s6,80003834 <install_trans+0x36>
      bunpin(dbuf);
    800038a0:	8526                	mv	a0,s1
    800038a2:	fffff097          	auipc	ra,0xfffff
    800038a6:	0be080e7          	jalr	190(ra) # 80002960 <bunpin>
    800038aa:	b769                	j	80003834 <install_trans+0x36>
}
    800038ac:	70e2                	ld	ra,56(sp)
    800038ae:	7442                	ld	s0,48(sp)
    800038b0:	74a2                	ld	s1,40(sp)
    800038b2:	7902                	ld	s2,32(sp)
    800038b4:	69e2                	ld	s3,24(sp)
    800038b6:	6a42                	ld	s4,16(sp)
    800038b8:	6aa2                	ld	s5,8(sp)
    800038ba:	6b02                	ld	s6,0(sp)
    800038bc:	6121                	addi	sp,sp,64
    800038be:	8082                	ret
    800038c0:	8082                	ret

00000000800038c2 <initlog>:
{
    800038c2:	7179                	addi	sp,sp,-48
    800038c4:	f406                	sd	ra,40(sp)
    800038c6:	f022                	sd	s0,32(sp)
    800038c8:	ec26                	sd	s1,24(sp)
    800038ca:	e84a                	sd	s2,16(sp)
    800038cc:	e44e                	sd	s3,8(sp)
    800038ce:	1800                	addi	s0,sp,48
    800038d0:	892a                	mv	s2,a0
    800038d2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800038d4:	00235497          	auipc	s1,0x235
    800038d8:	07448493          	addi	s1,s1,116 # 80238948 <log>
    800038dc:	00005597          	auipc	a1,0x5
    800038e0:	c4c58593          	addi	a1,a1,-948 # 80008528 <etext+0x528>
    800038e4:	8526                	mv	a0,s1
    800038e6:	00003097          	auipc	ra,0x3
    800038ea:	d56080e7          	jalr	-682(ra) # 8000663c <initlock>
  log.start = sb->logstart;
    800038ee:	0149a583          	lw	a1,20(s3)
    800038f2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800038f4:	0109a783          	lw	a5,16(s3)
    800038f8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800038fa:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800038fe:	854a                	mv	a0,s2
    80003900:	fffff097          	auipc	ra,0xfffff
    80003904:	e58080e7          	jalr	-424(ra) # 80002758 <bread>
  log.lh.n = lh->n;
    80003908:	4d30                	lw	a2,88(a0)
    8000390a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000390c:	00c05f63          	blez	a2,8000392a <initlog+0x68>
    80003910:	87aa                	mv	a5,a0
    80003912:	00235717          	auipc	a4,0x235
    80003916:	06670713          	addi	a4,a4,102 # 80238978 <log+0x30>
    8000391a:	060a                	slli	a2,a2,0x2
    8000391c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000391e:	4ff4                	lw	a3,92(a5)
    80003920:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003922:	0791                	addi	a5,a5,4
    80003924:	0711                	addi	a4,a4,4
    80003926:	fec79ce3          	bne	a5,a2,8000391e <initlog+0x5c>
  brelse(buf);
    8000392a:	fffff097          	auipc	ra,0xfffff
    8000392e:	f5e080e7          	jalr	-162(ra) # 80002888 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003932:	4505                	li	a0,1
    80003934:	00000097          	auipc	ra,0x0
    80003938:	eca080e7          	jalr	-310(ra) # 800037fe <install_trans>
  log.lh.n = 0;
    8000393c:	00235797          	auipc	a5,0x235
    80003940:	0207ac23          	sw	zero,56(a5) # 80238974 <log+0x2c>
  write_head(); // clear the log
    80003944:	00000097          	auipc	ra,0x0
    80003948:	e50080e7          	jalr	-432(ra) # 80003794 <write_head>
}
    8000394c:	70a2                	ld	ra,40(sp)
    8000394e:	7402                	ld	s0,32(sp)
    80003950:	64e2                	ld	s1,24(sp)
    80003952:	6942                	ld	s2,16(sp)
    80003954:	69a2                	ld	s3,8(sp)
    80003956:	6145                	addi	sp,sp,48
    80003958:	8082                	ret

000000008000395a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000395a:	1101                	addi	sp,sp,-32
    8000395c:	ec06                	sd	ra,24(sp)
    8000395e:	e822                	sd	s0,16(sp)
    80003960:	e426                	sd	s1,8(sp)
    80003962:	e04a                	sd	s2,0(sp)
    80003964:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003966:	00235517          	auipc	a0,0x235
    8000396a:	fe250513          	addi	a0,a0,-30 # 80238948 <log>
    8000396e:	00003097          	auipc	ra,0x3
    80003972:	d5e080e7          	jalr	-674(ra) # 800066cc <acquire>
  while(1){
    if(log.committing){
    80003976:	00235497          	auipc	s1,0x235
    8000397a:	fd248493          	addi	s1,s1,-46 # 80238948 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000397e:	4979                	li	s2,30
    80003980:	a039                	j	8000398e <begin_op+0x34>
      sleep(&log, &log.lock);
    80003982:	85a6                	mv	a1,s1
    80003984:	8526                	mv	a0,s1
    80003986:	ffffe097          	auipc	ra,0xffffe
    8000398a:	eb8080e7          	jalr	-328(ra) # 8000183e <sleep>
    if(log.committing){
    8000398e:	50dc                	lw	a5,36(s1)
    80003990:	fbed                	bnez	a5,80003982 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003992:	5098                	lw	a4,32(s1)
    80003994:	2705                	addiw	a4,a4,1
    80003996:	0027179b          	slliw	a5,a4,0x2
    8000399a:	9fb9                	addw	a5,a5,a4
    8000399c:	0017979b          	slliw	a5,a5,0x1
    800039a0:	54d4                	lw	a3,44(s1)
    800039a2:	9fb5                	addw	a5,a5,a3
    800039a4:	00f95963          	bge	s2,a5,800039b6 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800039a8:	85a6                	mv	a1,s1
    800039aa:	8526                	mv	a0,s1
    800039ac:	ffffe097          	auipc	ra,0xffffe
    800039b0:	e92080e7          	jalr	-366(ra) # 8000183e <sleep>
    800039b4:	bfe9                	j	8000398e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800039b6:	00235517          	auipc	a0,0x235
    800039ba:	f9250513          	addi	a0,a0,-110 # 80238948 <log>
    800039be:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800039c0:	00003097          	auipc	ra,0x3
    800039c4:	dc0080e7          	jalr	-576(ra) # 80006780 <release>
      break;
    }
  }
}
    800039c8:	60e2                	ld	ra,24(sp)
    800039ca:	6442                	ld	s0,16(sp)
    800039cc:	64a2                	ld	s1,8(sp)
    800039ce:	6902                	ld	s2,0(sp)
    800039d0:	6105                	addi	sp,sp,32
    800039d2:	8082                	ret

00000000800039d4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800039d4:	7139                	addi	sp,sp,-64
    800039d6:	fc06                	sd	ra,56(sp)
    800039d8:	f822                	sd	s0,48(sp)
    800039da:	f426                	sd	s1,40(sp)
    800039dc:	f04a                	sd	s2,32(sp)
    800039de:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800039e0:	00235497          	auipc	s1,0x235
    800039e4:	f6848493          	addi	s1,s1,-152 # 80238948 <log>
    800039e8:	8526                	mv	a0,s1
    800039ea:	00003097          	auipc	ra,0x3
    800039ee:	ce2080e7          	jalr	-798(ra) # 800066cc <acquire>
  log.outstanding -= 1;
    800039f2:	509c                	lw	a5,32(s1)
    800039f4:	37fd                	addiw	a5,a5,-1
    800039f6:	0007891b          	sext.w	s2,a5
    800039fa:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800039fc:	50dc                	lw	a5,36(s1)
    800039fe:	e7b9                	bnez	a5,80003a4c <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80003a00:	06091163          	bnez	s2,80003a62 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003a04:	00235497          	auipc	s1,0x235
    80003a08:	f4448493          	addi	s1,s1,-188 # 80238948 <log>
    80003a0c:	4785                	li	a5,1
    80003a0e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003a10:	8526                	mv	a0,s1
    80003a12:	00003097          	auipc	ra,0x3
    80003a16:	d6e080e7          	jalr	-658(ra) # 80006780 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003a1a:	54dc                	lw	a5,44(s1)
    80003a1c:	06f04763          	bgtz	a5,80003a8a <end_op+0xb6>
    acquire(&log.lock);
    80003a20:	00235497          	auipc	s1,0x235
    80003a24:	f2848493          	addi	s1,s1,-216 # 80238948 <log>
    80003a28:	8526                	mv	a0,s1
    80003a2a:	00003097          	auipc	ra,0x3
    80003a2e:	ca2080e7          	jalr	-862(ra) # 800066cc <acquire>
    log.committing = 0;
    80003a32:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003a36:	8526                	mv	a0,s1
    80003a38:	ffffe097          	auipc	ra,0xffffe
    80003a3c:	e6a080e7          	jalr	-406(ra) # 800018a2 <wakeup>
    release(&log.lock);
    80003a40:	8526                	mv	a0,s1
    80003a42:	00003097          	auipc	ra,0x3
    80003a46:	d3e080e7          	jalr	-706(ra) # 80006780 <release>
}
    80003a4a:	a815                	j	80003a7e <end_op+0xaa>
    80003a4c:	ec4e                	sd	s3,24(sp)
    80003a4e:	e852                	sd	s4,16(sp)
    80003a50:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003a52:	00005517          	auipc	a0,0x5
    80003a56:	ade50513          	addi	a0,a0,-1314 # 80008530 <etext+0x530>
    80003a5a:	00002097          	auipc	ra,0x2
    80003a5e:	6f8080e7          	jalr	1784(ra) # 80006152 <panic>
    wakeup(&log);
    80003a62:	00235497          	auipc	s1,0x235
    80003a66:	ee648493          	addi	s1,s1,-282 # 80238948 <log>
    80003a6a:	8526                	mv	a0,s1
    80003a6c:	ffffe097          	auipc	ra,0xffffe
    80003a70:	e36080e7          	jalr	-458(ra) # 800018a2 <wakeup>
  release(&log.lock);
    80003a74:	8526                	mv	a0,s1
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	d0a080e7          	jalr	-758(ra) # 80006780 <release>
}
    80003a7e:	70e2                	ld	ra,56(sp)
    80003a80:	7442                	ld	s0,48(sp)
    80003a82:	74a2                	ld	s1,40(sp)
    80003a84:	7902                	ld	s2,32(sp)
    80003a86:	6121                	addi	sp,sp,64
    80003a88:	8082                	ret
    80003a8a:	ec4e                	sd	s3,24(sp)
    80003a8c:	e852                	sd	s4,16(sp)
    80003a8e:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a90:	00235a97          	auipc	s5,0x235
    80003a94:	ee8a8a93          	addi	s5,s5,-280 # 80238978 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003a98:	00235a17          	auipc	s4,0x235
    80003a9c:	eb0a0a13          	addi	s4,s4,-336 # 80238948 <log>
    80003aa0:	018a2583          	lw	a1,24(s4)
    80003aa4:	012585bb          	addw	a1,a1,s2
    80003aa8:	2585                	addiw	a1,a1,1
    80003aaa:	028a2503          	lw	a0,40(s4)
    80003aae:	fffff097          	auipc	ra,0xfffff
    80003ab2:	caa080e7          	jalr	-854(ra) # 80002758 <bread>
    80003ab6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003ab8:	000aa583          	lw	a1,0(s5)
    80003abc:	028a2503          	lw	a0,40(s4)
    80003ac0:	fffff097          	auipc	ra,0xfffff
    80003ac4:	c98080e7          	jalr	-872(ra) # 80002758 <bread>
    80003ac8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003aca:	40000613          	li	a2,1024
    80003ace:	05850593          	addi	a1,a0,88
    80003ad2:	05848513          	addi	a0,s1,88
    80003ad6:	ffffd097          	auipc	ra,0xffffd
    80003ada:	830080e7          	jalr	-2000(ra) # 80000306 <memmove>
    bwrite(to);  // write the log
    80003ade:	8526                	mv	a0,s1
    80003ae0:	fffff097          	auipc	ra,0xfffff
    80003ae4:	d6a080e7          	jalr	-662(ra) # 8000284a <bwrite>
    brelse(from);
    80003ae8:	854e                	mv	a0,s3
    80003aea:	fffff097          	auipc	ra,0xfffff
    80003aee:	d9e080e7          	jalr	-610(ra) # 80002888 <brelse>
    brelse(to);
    80003af2:	8526                	mv	a0,s1
    80003af4:	fffff097          	auipc	ra,0xfffff
    80003af8:	d94080e7          	jalr	-620(ra) # 80002888 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003afc:	2905                	addiw	s2,s2,1
    80003afe:	0a91                	addi	s5,s5,4
    80003b00:	02ca2783          	lw	a5,44(s4)
    80003b04:	f8f94ee3          	blt	s2,a5,80003aa0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003b08:	00000097          	auipc	ra,0x0
    80003b0c:	c8c080e7          	jalr	-884(ra) # 80003794 <write_head>
    install_trans(0); // Now install writes to home locations
    80003b10:	4501                	li	a0,0
    80003b12:	00000097          	auipc	ra,0x0
    80003b16:	cec080e7          	jalr	-788(ra) # 800037fe <install_trans>
    log.lh.n = 0;
    80003b1a:	00235797          	auipc	a5,0x235
    80003b1e:	e407ad23          	sw	zero,-422(a5) # 80238974 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003b22:	00000097          	auipc	ra,0x0
    80003b26:	c72080e7          	jalr	-910(ra) # 80003794 <write_head>
    80003b2a:	69e2                	ld	s3,24(sp)
    80003b2c:	6a42                	ld	s4,16(sp)
    80003b2e:	6aa2                	ld	s5,8(sp)
    80003b30:	bdc5                	j	80003a20 <end_op+0x4c>

0000000080003b32 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003b32:	1101                	addi	sp,sp,-32
    80003b34:	ec06                	sd	ra,24(sp)
    80003b36:	e822                	sd	s0,16(sp)
    80003b38:	e426                	sd	s1,8(sp)
    80003b3a:	e04a                	sd	s2,0(sp)
    80003b3c:	1000                	addi	s0,sp,32
    80003b3e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003b40:	00235917          	auipc	s2,0x235
    80003b44:	e0890913          	addi	s2,s2,-504 # 80238948 <log>
    80003b48:	854a                	mv	a0,s2
    80003b4a:	00003097          	auipc	ra,0x3
    80003b4e:	b82080e7          	jalr	-1150(ra) # 800066cc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003b52:	02c92603          	lw	a2,44(s2)
    80003b56:	47f5                	li	a5,29
    80003b58:	06c7c563          	blt	a5,a2,80003bc2 <log_write+0x90>
    80003b5c:	00235797          	auipc	a5,0x235
    80003b60:	e087a783          	lw	a5,-504(a5) # 80238964 <log+0x1c>
    80003b64:	37fd                	addiw	a5,a5,-1
    80003b66:	04f65e63          	bge	a2,a5,80003bc2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003b6a:	00235797          	auipc	a5,0x235
    80003b6e:	dfe7a783          	lw	a5,-514(a5) # 80238968 <log+0x20>
    80003b72:	06f05063          	blez	a5,80003bd2 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003b76:	4781                	li	a5,0
    80003b78:	06c05563          	blez	a2,80003be2 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003b7c:	44cc                	lw	a1,12(s1)
    80003b7e:	00235717          	auipc	a4,0x235
    80003b82:	dfa70713          	addi	a4,a4,-518 # 80238978 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003b86:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003b88:	4314                	lw	a3,0(a4)
    80003b8a:	04b68c63          	beq	a3,a1,80003be2 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003b8e:	2785                	addiw	a5,a5,1
    80003b90:	0711                	addi	a4,a4,4
    80003b92:	fef61be3          	bne	a2,a5,80003b88 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003b96:	0621                	addi	a2,a2,8
    80003b98:	060a                	slli	a2,a2,0x2
    80003b9a:	00235797          	auipc	a5,0x235
    80003b9e:	dae78793          	addi	a5,a5,-594 # 80238948 <log>
    80003ba2:	97b2                	add	a5,a5,a2
    80003ba4:	44d8                	lw	a4,12(s1)
    80003ba6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003ba8:	8526                	mv	a0,s1
    80003baa:	fffff097          	auipc	ra,0xfffff
    80003bae:	d7a080e7          	jalr	-646(ra) # 80002924 <bpin>
    log.lh.n++;
    80003bb2:	00235717          	auipc	a4,0x235
    80003bb6:	d9670713          	addi	a4,a4,-618 # 80238948 <log>
    80003bba:	575c                	lw	a5,44(a4)
    80003bbc:	2785                	addiw	a5,a5,1
    80003bbe:	d75c                	sw	a5,44(a4)
    80003bc0:	a82d                	j	80003bfa <log_write+0xc8>
    panic("too big a transaction");
    80003bc2:	00005517          	auipc	a0,0x5
    80003bc6:	97e50513          	addi	a0,a0,-1666 # 80008540 <etext+0x540>
    80003bca:	00002097          	auipc	ra,0x2
    80003bce:	588080e7          	jalr	1416(ra) # 80006152 <panic>
    panic("log_write outside of trans");
    80003bd2:	00005517          	auipc	a0,0x5
    80003bd6:	98650513          	addi	a0,a0,-1658 # 80008558 <etext+0x558>
    80003bda:	00002097          	auipc	ra,0x2
    80003bde:	578080e7          	jalr	1400(ra) # 80006152 <panic>
  log.lh.block[i] = b->blockno;
    80003be2:	00878693          	addi	a3,a5,8
    80003be6:	068a                	slli	a3,a3,0x2
    80003be8:	00235717          	auipc	a4,0x235
    80003bec:	d6070713          	addi	a4,a4,-672 # 80238948 <log>
    80003bf0:	9736                	add	a4,a4,a3
    80003bf2:	44d4                	lw	a3,12(s1)
    80003bf4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003bf6:	faf609e3          	beq	a2,a5,80003ba8 <log_write+0x76>
  }
  release(&log.lock);
    80003bfa:	00235517          	auipc	a0,0x235
    80003bfe:	d4e50513          	addi	a0,a0,-690 # 80238948 <log>
    80003c02:	00003097          	auipc	ra,0x3
    80003c06:	b7e080e7          	jalr	-1154(ra) # 80006780 <release>
}
    80003c0a:	60e2                	ld	ra,24(sp)
    80003c0c:	6442                	ld	s0,16(sp)
    80003c0e:	64a2                	ld	s1,8(sp)
    80003c10:	6902                	ld	s2,0(sp)
    80003c12:	6105                	addi	sp,sp,32
    80003c14:	8082                	ret

0000000080003c16 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003c16:	1101                	addi	sp,sp,-32
    80003c18:	ec06                	sd	ra,24(sp)
    80003c1a:	e822                	sd	s0,16(sp)
    80003c1c:	e426                	sd	s1,8(sp)
    80003c1e:	e04a                	sd	s2,0(sp)
    80003c20:	1000                	addi	s0,sp,32
    80003c22:	84aa                	mv	s1,a0
    80003c24:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003c26:	00005597          	auipc	a1,0x5
    80003c2a:	95258593          	addi	a1,a1,-1710 # 80008578 <etext+0x578>
    80003c2e:	0521                	addi	a0,a0,8
    80003c30:	00003097          	auipc	ra,0x3
    80003c34:	a0c080e7          	jalr	-1524(ra) # 8000663c <initlock>
  lk->name = name;
    80003c38:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003c3c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c40:	0204a423          	sw	zero,40(s1)
}
    80003c44:	60e2                	ld	ra,24(sp)
    80003c46:	6442                	ld	s0,16(sp)
    80003c48:	64a2                	ld	s1,8(sp)
    80003c4a:	6902                	ld	s2,0(sp)
    80003c4c:	6105                	addi	sp,sp,32
    80003c4e:	8082                	ret

0000000080003c50 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003c50:	1101                	addi	sp,sp,-32
    80003c52:	ec06                	sd	ra,24(sp)
    80003c54:	e822                	sd	s0,16(sp)
    80003c56:	e426                	sd	s1,8(sp)
    80003c58:	e04a                	sd	s2,0(sp)
    80003c5a:	1000                	addi	s0,sp,32
    80003c5c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c5e:	00850913          	addi	s2,a0,8
    80003c62:	854a                	mv	a0,s2
    80003c64:	00003097          	auipc	ra,0x3
    80003c68:	a68080e7          	jalr	-1432(ra) # 800066cc <acquire>
  while (lk->locked) {
    80003c6c:	409c                	lw	a5,0(s1)
    80003c6e:	cb89                	beqz	a5,80003c80 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003c70:	85ca                	mv	a1,s2
    80003c72:	8526                	mv	a0,s1
    80003c74:	ffffe097          	auipc	ra,0xffffe
    80003c78:	bca080e7          	jalr	-1078(ra) # 8000183e <sleep>
  while (lk->locked) {
    80003c7c:	409c                	lw	a5,0(s1)
    80003c7e:	fbed                	bnez	a5,80003c70 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003c80:	4785                	li	a5,1
    80003c82:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003c84:	ffffd097          	auipc	ra,0xffffd
    80003c88:	50c080e7          	jalr	1292(ra) # 80001190 <myproc>
    80003c8c:	591c                	lw	a5,48(a0)
    80003c8e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003c90:	854a                	mv	a0,s2
    80003c92:	00003097          	auipc	ra,0x3
    80003c96:	aee080e7          	jalr	-1298(ra) # 80006780 <release>
}
    80003c9a:	60e2                	ld	ra,24(sp)
    80003c9c:	6442                	ld	s0,16(sp)
    80003c9e:	64a2                	ld	s1,8(sp)
    80003ca0:	6902                	ld	s2,0(sp)
    80003ca2:	6105                	addi	sp,sp,32
    80003ca4:	8082                	ret

0000000080003ca6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003ca6:	1101                	addi	sp,sp,-32
    80003ca8:	ec06                	sd	ra,24(sp)
    80003caa:	e822                	sd	s0,16(sp)
    80003cac:	e426                	sd	s1,8(sp)
    80003cae:	e04a                	sd	s2,0(sp)
    80003cb0:	1000                	addi	s0,sp,32
    80003cb2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003cb4:	00850913          	addi	s2,a0,8
    80003cb8:	854a                	mv	a0,s2
    80003cba:	00003097          	auipc	ra,0x3
    80003cbe:	a12080e7          	jalr	-1518(ra) # 800066cc <acquire>
  lk->locked = 0;
    80003cc2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003cc6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003cca:	8526                	mv	a0,s1
    80003ccc:	ffffe097          	auipc	ra,0xffffe
    80003cd0:	bd6080e7          	jalr	-1066(ra) # 800018a2 <wakeup>
  release(&lk->lk);
    80003cd4:	854a                	mv	a0,s2
    80003cd6:	00003097          	auipc	ra,0x3
    80003cda:	aaa080e7          	jalr	-1366(ra) # 80006780 <release>
}
    80003cde:	60e2                	ld	ra,24(sp)
    80003ce0:	6442                	ld	s0,16(sp)
    80003ce2:	64a2                	ld	s1,8(sp)
    80003ce4:	6902                	ld	s2,0(sp)
    80003ce6:	6105                	addi	sp,sp,32
    80003ce8:	8082                	ret

0000000080003cea <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003cea:	7179                	addi	sp,sp,-48
    80003cec:	f406                	sd	ra,40(sp)
    80003cee:	f022                	sd	s0,32(sp)
    80003cf0:	ec26                	sd	s1,24(sp)
    80003cf2:	e84a                	sd	s2,16(sp)
    80003cf4:	1800                	addi	s0,sp,48
    80003cf6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003cf8:	00850913          	addi	s2,a0,8
    80003cfc:	854a                	mv	a0,s2
    80003cfe:	00003097          	auipc	ra,0x3
    80003d02:	9ce080e7          	jalr	-1586(ra) # 800066cc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003d06:	409c                	lw	a5,0(s1)
    80003d08:	ef91                	bnez	a5,80003d24 <holdingsleep+0x3a>
    80003d0a:	4481                	li	s1,0
  release(&lk->lk);
    80003d0c:	854a                	mv	a0,s2
    80003d0e:	00003097          	auipc	ra,0x3
    80003d12:	a72080e7          	jalr	-1422(ra) # 80006780 <release>
  return r;
}
    80003d16:	8526                	mv	a0,s1
    80003d18:	70a2                	ld	ra,40(sp)
    80003d1a:	7402                	ld	s0,32(sp)
    80003d1c:	64e2                	ld	s1,24(sp)
    80003d1e:	6942                	ld	s2,16(sp)
    80003d20:	6145                	addi	sp,sp,48
    80003d22:	8082                	ret
    80003d24:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003d26:	0284a983          	lw	s3,40(s1)
    80003d2a:	ffffd097          	auipc	ra,0xffffd
    80003d2e:	466080e7          	jalr	1126(ra) # 80001190 <myproc>
    80003d32:	5904                	lw	s1,48(a0)
    80003d34:	413484b3          	sub	s1,s1,s3
    80003d38:	0014b493          	seqz	s1,s1
    80003d3c:	69a2                	ld	s3,8(sp)
    80003d3e:	b7f9                	j	80003d0c <holdingsleep+0x22>

0000000080003d40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003d40:	1141                	addi	sp,sp,-16
    80003d42:	e406                	sd	ra,8(sp)
    80003d44:	e022                	sd	s0,0(sp)
    80003d46:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003d48:	00005597          	auipc	a1,0x5
    80003d4c:	84058593          	addi	a1,a1,-1984 # 80008588 <etext+0x588>
    80003d50:	00235517          	auipc	a0,0x235
    80003d54:	d4050513          	addi	a0,a0,-704 # 80238a90 <ftable>
    80003d58:	00003097          	auipc	ra,0x3
    80003d5c:	8e4080e7          	jalr	-1820(ra) # 8000663c <initlock>
}
    80003d60:	60a2                	ld	ra,8(sp)
    80003d62:	6402                	ld	s0,0(sp)
    80003d64:	0141                	addi	sp,sp,16
    80003d66:	8082                	ret

0000000080003d68 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003d68:	1101                	addi	sp,sp,-32
    80003d6a:	ec06                	sd	ra,24(sp)
    80003d6c:	e822                	sd	s0,16(sp)
    80003d6e:	e426                	sd	s1,8(sp)
    80003d70:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003d72:	00235517          	auipc	a0,0x235
    80003d76:	d1e50513          	addi	a0,a0,-738 # 80238a90 <ftable>
    80003d7a:	00003097          	auipc	ra,0x3
    80003d7e:	952080e7          	jalr	-1710(ra) # 800066cc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d82:	00235497          	auipc	s1,0x235
    80003d86:	d2648493          	addi	s1,s1,-730 # 80238aa8 <ftable+0x18>
    80003d8a:	00236717          	auipc	a4,0x236
    80003d8e:	cbe70713          	addi	a4,a4,-834 # 80239a48 <disk>
    if(f->ref == 0){
    80003d92:	40dc                	lw	a5,4(s1)
    80003d94:	cf99                	beqz	a5,80003db2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d96:	02848493          	addi	s1,s1,40
    80003d9a:	fee49ce3          	bne	s1,a4,80003d92 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003d9e:	00235517          	auipc	a0,0x235
    80003da2:	cf250513          	addi	a0,a0,-782 # 80238a90 <ftable>
    80003da6:	00003097          	auipc	ra,0x3
    80003daa:	9da080e7          	jalr	-1574(ra) # 80006780 <release>
  return 0;
    80003dae:	4481                	li	s1,0
    80003db0:	a819                	j	80003dc6 <filealloc+0x5e>
      f->ref = 1;
    80003db2:	4785                	li	a5,1
    80003db4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003db6:	00235517          	auipc	a0,0x235
    80003dba:	cda50513          	addi	a0,a0,-806 # 80238a90 <ftable>
    80003dbe:	00003097          	auipc	ra,0x3
    80003dc2:	9c2080e7          	jalr	-1598(ra) # 80006780 <release>
}
    80003dc6:	8526                	mv	a0,s1
    80003dc8:	60e2                	ld	ra,24(sp)
    80003dca:	6442                	ld	s0,16(sp)
    80003dcc:	64a2                	ld	s1,8(sp)
    80003dce:	6105                	addi	sp,sp,32
    80003dd0:	8082                	ret

0000000080003dd2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003dd2:	1101                	addi	sp,sp,-32
    80003dd4:	ec06                	sd	ra,24(sp)
    80003dd6:	e822                	sd	s0,16(sp)
    80003dd8:	e426                	sd	s1,8(sp)
    80003dda:	1000                	addi	s0,sp,32
    80003ddc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003dde:	00235517          	auipc	a0,0x235
    80003de2:	cb250513          	addi	a0,a0,-846 # 80238a90 <ftable>
    80003de6:	00003097          	auipc	ra,0x3
    80003dea:	8e6080e7          	jalr	-1818(ra) # 800066cc <acquire>
  if(f->ref < 1)
    80003dee:	40dc                	lw	a5,4(s1)
    80003df0:	02f05263          	blez	a5,80003e14 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003df4:	2785                	addiw	a5,a5,1
    80003df6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003df8:	00235517          	auipc	a0,0x235
    80003dfc:	c9850513          	addi	a0,a0,-872 # 80238a90 <ftable>
    80003e00:	00003097          	auipc	ra,0x3
    80003e04:	980080e7          	jalr	-1664(ra) # 80006780 <release>
  return f;
}
    80003e08:	8526                	mv	a0,s1
    80003e0a:	60e2                	ld	ra,24(sp)
    80003e0c:	6442                	ld	s0,16(sp)
    80003e0e:	64a2                	ld	s1,8(sp)
    80003e10:	6105                	addi	sp,sp,32
    80003e12:	8082                	ret
    panic("filedup");
    80003e14:	00004517          	auipc	a0,0x4
    80003e18:	77c50513          	addi	a0,a0,1916 # 80008590 <etext+0x590>
    80003e1c:	00002097          	auipc	ra,0x2
    80003e20:	336080e7          	jalr	822(ra) # 80006152 <panic>

0000000080003e24 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003e24:	7139                	addi	sp,sp,-64
    80003e26:	fc06                	sd	ra,56(sp)
    80003e28:	f822                	sd	s0,48(sp)
    80003e2a:	f426                	sd	s1,40(sp)
    80003e2c:	0080                	addi	s0,sp,64
    80003e2e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003e30:	00235517          	auipc	a0,0x235
    80003e34:	c6050513          	addi	a0,a0,-928 # 80238a90 <ftable>
    80003e38:	00003097          	auipc	ra,0x3
    80003e3c:	894080e7          	jalr	-1900(ra) # 800066cc <acquire>
  if(f->ref < 1)
    80003e40:	40dc                	lw	a5,4(s1)
    80003e42:	04f05c63          	blez	a5,80003e9a <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003e46:	37fd                	addiw	a5,a5,-1
    80003e48:	0007871b          	sext.w	a4,a5
    80003e4c:	c0dc                	sw	a5,4(s1)
    80003e4e:	06e04263          	bgtz	a4,80003eb2 <fileclose+0x8e>
    80003e52:	f04a                	sd	s2,32(sp)
    80003e54:	ec4e                	sd	s3,24(sp)
    80003e56:	e852                	sd	s4,16(sp)
    80003e58:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003e5a:	0004a903          	lw	s2,0(s1)
    80003e5e:	0094ca83          	lbu	s5,9(s1)
    80003e62:	0104ba03          	ld	s4,16(s1)
    80003e66:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003e6a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003e6e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003e72:	00235517          	auipc	a0,0x235
    80003e76:	c1e50513          	addi	a0,a0,-994 # 80238a90 <ftable>
    80003e7a:	00003097          	auipc	ra,0x3
    80003e7e:	906080e7          	jalr	-1786(ra) # 80006780 <release>

  if(ff.type == FD_PIPE){
    80003e82:	4785                	li	a5,1
    80003e84:	04f90463          	beq	s2,a5,80003ecc <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003e88:	3979                	addiw	s2,s2,-2
    80003e8a:	4785                	li	a5,1
    80003e8c:	0527fb63          	bgeu	a5,s2,80003ee2 <fileclose+0xbe>
    80003e90:	7902                	ld	s2,32(sp)
    80003e92:	69e2                	ld	s3,24(sp)
    80003e94:	6a42                	ld	s4,16(sp)
    80003e96:	6aa2                	ld	s5,8(sp)
    80003e98:	a02d                	j	80003ec2 <fileclose+0x9e>
    80003e9a:	f04a                	sd	s2,32(sp)
    80003e9c:	ec4e                	sd	s3,24(sp)
    80003e9e:	e852                	sd	s4,16(sp)
    80003ea0:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003ea2:	00004517          	auipc	a0,0x4
    80003ea6:	6f650513          	addi	a0,a0,1782 # 80008598 <etext+0x598>
    80003eaa:	00002097          	auipc	ra,0x2
    80003eae:	2a8080e7          	jalr	680(ra) # 80006152 <panic>
    release(&ftable.lock);
    80003eb2:	00235517          	auipc	a0,0x235
    80003eb6:	bde50513          	addi	a0,a0,-1058 # 80238a90 <ftable>
    80003eba:	00003097          	auipc	ra,0x3
    80003ebe:	8c6080e7          	jalr	-1850(ra) # 80006780 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003ec2:	70e2                	ld	ra,56(sp)
    80003ec4:	7442                	ld	s0,48(sp)
    80003ec6:	74a2                	ld	s1,40(sp)
    80003ec8:	6121                	addi	sp,sp,64
    80003eca:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ecc:	85d6                	mv	a1,s5
    80003ece:	8552                	mv	a0,s4
    80003ed0:	00000097          	auipc	ra,0x0
    80003ed4:	3a2080e7          	jalr	930(ra) # 80004272 <pipeclose>
    80003ed8:	7902                	ld	s2,32(sp)
    80003eda:	69e2                	ld	s3,24(sp)
    80003edc:	6a42                	ld	s4,16(sp)
    80003ede:	6aa2                	ld	s5,8(sp)
    80003ee0:	b7cd                	j	80003ec2 <fileclose+0x9e>
    begin_op();
    80003ee2:	00000097          	auipc	ra,0x0
    80003ee6:	a78080e7          	jalr	-1416(ra) # 8000395a <begin_op>
    iput(ff.ip);
    80003eea:	854e                	mv	a0,s3
    80003eec:	fffff097          	auipc	ra,0xfffff
    80003ef0:	25e080e7          	jalr	606(ra) # 8000314a <iput>
    end_op();
    80003ef4:	00000097          	auipc	ra,0x0
    80003ef8:	ae0080e7          	jalr	-1312(ra) # 800039d4 <end_op>
    80003efc:	7902                	ld	s2,32(sp)
    80003efe:	69e2                	ld	s3,24(sp)
    80003f00:	6a42                	ld	s4,16(sp)
    80003f02:	6aa2                	ld	s5,8(sp)
    80003f04:	bf7d                	j	80003ec2 <fileclose+0x9e>

0000000080003f06 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003f06:	715d                	addi	sp,sp,-80
    80003f08:	e486                	sd	ra,72(sp)
    80003f0a:	e0a2                	sd	s0,64(sp)
    80003f0c:	fc26                	sd	s1,56(sp)
    80003f0e:	f44e                	sd	s3,40(sp)
    80003f10:	0880                	addi	s0,sp,80
    80003f12:	84aa                	mv	s1,a0
    80003f14:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003f16:	ffffd097          	auipc	ra,0xffffd
    80003f1a:	27a080e7          	jalr	634(ra) # 80001190 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003f1e:	409c                	lw	a5,0(s1)
    80003f20:	37f9                	addiw	a5,a5,-2
    80003f22:	4705                	li	a4,1
    80003f24:	04f76863          	bltu	a4,a5,80003f74 <filestat+0x6e>
    80003f28:	f84a                	sd	s2,48(sp)
    80003f2a:	892a                	mv	s2,a0
    ilock(f->ip);
    80003f2c:	6c88                	ld	a0,24(s1)
    80003f2e:	fffff097          	auipc	ra,0xfffff
    80003f32:	05e080e7          	jalr	94(ra) # 80002f8c <ilock>
    stati(f->ip, &st);
    80003f36:	fb840593          	addi	a1,s0,-72
    80003f3a:	6c88                	ld	a0,24(s1)
    80003f3c:	fffff097          	auipc	ra,0xfffff
    80003f40:	2de080e7          	jalr	734(ra) # 8000321a <stati>
    iunlock(f->ip);
    80003f44:	6c88                	ld	a0,24(s1)
    80003f46:	fffff097          	auipc	ra,0xfffff
    80003f4a:	10c080e7          	jalr	268(ra) # 80003052 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003f4e:	46e1                	li	a3,24
    80003f50:	fb840613          	addi	a2,s0,-72
    80003f54:	85ce                	mv	a1,s3
    80003f56:	05093503          	ld	a0,80(s2)
    80003f5a:	ffffd097          	auipc	ra,0xffffd
    80003f5e:	e40080e7          	jalr	-448(ra) # 80000d9a <copyout>
    80003f62:	41f5551b          	sraiw	a0,a0,0x1f
    80003f66:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003f68:	60a6                	ld	ra,72(sp)
    80003f6a:	6406                	ld	s0,64(sp)
    80003f6c:	74e2                	ld	s1,56(sp)
    80003f6e:	79a2                	ld	s3,40(sp)
    80003f70:	6161                	addi	sp,sp,80
    80003f72:	8082                	ret
  return -1;
    80003f74:	557d                	li	a0,-1
    80003f76:	bfcd                	j	80003f68 <filestat+0x62>

0000000080003f78 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003f78:	7179                	addi	sp,sp,-48
    80003f7a:	f406                	sd	ra,40(sp)
    80003f7c:	f022                	sd	s0,32(sp)
    80003f7e:	e84a                	sd	s2,16(sp)
    80003f80:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003f82:	00854783          	lbu	a5,8(a0)
    80003f86:	cbc5                	beqz	a5,80004036 <fileread+0xbe>
    80003f88:	ec26                	sd	s1,24(sp)
    80003f8a:	e44e                	sd	s3,8(sp)
    80003f8c:	84aa                	mv	s1,a0
    80003f8e:	89ae                	mv	s3,a1
    80003f90:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f92:	411c                	lw	a5,0(a0)
    80003f94:	4705                	li	a4,1
    80003f96:	04e78963          	beq	a5,a4,80003fe8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f9a:	470d                	li	a4,3
    80003f9c:	04e78f63          	beq	a5,a4,80003ffa <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003fa0:	4709                	li	a4,2
    80003fa2:	08e79263          	bne	a5,a4,80004026 <fileread+0xae>
    ilock(f->ip);
    80003fa6:	6d08                	ld	a0,24(a0)
    80003fa8:	fffff097          	auipc	ra,0xfffff
    80003fac:	fe4080e7          	jalr	-28(ra) # 80002f8c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003fb0:	874a                	mv	a4,s2
    80003fb2:	5094                	lw	a3,32(s1)
    80003fb4:	864e                	mv	a2,s3
    80003fb6:	4585                	li	a1,1
    80003fb8:	6c88                	ld	a0,24(s1)
    80003fba:	fffff097          	auipc	ra,0xfffff
    80003fbe:	28a080e7          	jalr	650(ra) # 80003244 <readi>
    80003fc2:	892a                	mv	s2,a0
    80003fc4:	00a05563          	blez	a0,80003fce <fileread+0x56>
      f->off += r;
    80003fc8:	509c                	lw	a5,32(s1)
    80003fca:	9fa9                	addw	a5,a5,a0
    80003fcc:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003fce:	6c88                	ld	a0,24(s1)
    80003fd0:	fffff097          	auipc	ra,0xfffff
    80003fd4:	082080e7          	jalr	130(ra) # 80003052 <iunlock>
    80003fd8:	64e2                	ld	s1,24(sp)
    80003fda:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003fdc:	854a                	mv	a0,s2
    80003fde:	70a2                	ld	ra,40(sp)
    80003fe0:	7402                	ld	s0,32(sp)
    80003fe2:	6942                	ld	s2,16(sp)
    80003fe4:	6145                	addi	sp,sp,48
    80003fe6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003fe8:	6908                	ld	a0,16(a0)
    80003fea:	00000097          	auipc	ra,0x0
    80003fee:	400080e7          	jalr	1024(ra) # 800043ea <piperead>
    80003ff2:	892a                	mv	s2,a0
    80003ff4:	64e2                	ld	s1,24(sp)
    80003ff6:	69a2                	ld	s3,8(sp)
    80003ff8:	b7d5                	j	80003fdc <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ffa:	02451783          	lh	a5,36(a0)
    80003ffe:	03079693          	slli	a3,a5,0x30
    80004002:	92c1                	srli	a3,a3,0x30
    80004004:	4725                	li	a4,9
    80004006:	02d76a63          	bltu	a4,a3,8000403a <fileread+0xc2>
    8000400a:	0792                	slli	a5,a5,0x4
    8000400c:	00235717          	auipc	a4,0x235
    80004010:	9e470713          	addi	a4,a4,-1564 # 802389f0 <devsw>
    80004014:	97ba                	add	a5,a5,a4
    80004016:	639c                	ld	a5,0(a5)
    80004018:	c78d                	beqz	a5,80004042 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    8000401a:	4505                	li	a0,1
    8000401c:	9782                	jalr	a5
    8000401e:	892a                	mv	s2,a0
    80004020:	64e2                	ld	s1,24(sp)
    80004022:	69a2                	ld	s3,8(sp)
    80004024:	bf65                	j	80003fdc <fileread+0x64>
    panic("fileread");
    80004026:	00004517          	auipc	a0,0x4
    8000402a:	58250513          	addi	a0,a0,1410 # 800085a8 <etext+0x5a8>
    8000402e:	00002097          	auipc	ra,0x2
    80004032:	124080e7          	jalr	292(ra) # 80006152 <panic>
    return -1;
    80004036:	597d                	li	s2,-1
    80004038:	b755                	j	80003fdc <fileread+0x64>
      return -1;
    8000403a:	597d                	li	s2,-1
    8000403c:	64e2                	ld	s1,24(sp)
    8000403e:	69a2                	ld	s3,8(sp)
    80004040:	bf71                	j	80003fdc <fileread+0x64>
    80004042:	597d                	li	s2,-1
    80004044:	64e2                	ld	s1,24(sp)
    80004046:	69a2                	ld	s3,8(sp)
    80004048:	bf51                	j	80003fdc <fileread+0x64>

000000008000404a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000404a:	00954783          	lbu	a5,9(a0)
    8000404e:	12078963          	beqz	a5,80004180 <filewrite+0x136>
{
    80004052:	715d                	addi	sp,sp,-80
    80004054:	e486                	sd	ra,72(sp)
    80004056:	e0a2                	sd	s0,64(sp)
    80004058:	f84a                	sd	s2,48(sp)
    8000405a:	f052                	sd	s4,32(sp)
    8000405c:	e85a                	sd	s6,16(sp)
    8000405e:	0880                	addi	s0,sp,80
    80004060:	892a                	mv	s2,a0
    80004062:	8b2e                	mv	s6,a1
    80004064:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004066:	411c                	lw	a5,0(a0)
    80004068:	4705                	li	a4,1
    8000406a:	02e78763          	beq	a5,a4,80004098 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000406e:	470d                	li	a4,3
    80004070:	02e78a63          	beq	a5,a4,800040a4 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004074:	4709                	li	a4,2
    80004076:	0ee79863          	bne	a5,a4,80004166 <filewrite+0x11c>
    8000407a:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000407c:	0cc05463          	blez	a2,80004144 <filewrite+0xfa>
    80004080:	fc26                	sd	s1,56(sp)
    80004082:	ec56                	sd	s5,24(sp)
    80004084:	e45e                	sd	s7,8(sp)
    80004086:	e062                	sd	s8,0(sp)
    int i = 0;
    80004088:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000408a:	6b85                	lui	s7,0x1
    8000408c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004090:	6c05                	lui	s8,0x1
    80004092:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004096:	a851                	j	8000412a <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004098:	6908                	ld	a0,16(a0)
    8000409a:	00000097          	auipc	ra,0x0
    8000409e:	248080e7          	jalr	584(ra) # 800042e2 <pipewrite>
    800040a2:	a85d                	j	80004158 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800040a4:	02451783          	lh	a5,36(a0)
    800040a8:	03079693          	slli	a3,a5,0x30
    800040ac:	92c1                	srli	a3,a3,0x30
    800040ae:	4725                	li	a4,9
    800040b0:	0cd76a63          	bltu	a4,a3,80004184 <filewrite+0x13a>
    800040b4:	0792                	slli	a5,a5,0x4
    800040b6:	00235717          	auipc	a4,0x235
    800040ba:	93a70713          	addi	a4,a4,-1734 # 802389f0 <devsw>
    800040be:	97ba                	add	a5,a5,a4
    800040c0:	679c                	ld	a5,8(a5)
    800040c2:	c3f9                	beqz	a5,80004188 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    800040c4:	4505                	li	a0,1
    800040c6:	9782                	jalr	a5
    800040c8:	a841                	j	80004158 <filewrite+0x10e>
      if(n1 > max)
    800040ca:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800040ce:	00000097          	auipc	ra,0x0
    800040d2:	88c080e7          	jalr	-1908(ra) # 8000395a <begin_op>
      ilock(f->ip);
    800040d6:	01893503          	ld	a0,24(s2)
    800040da:	fffff097          	auipc	ra,0xfffff
    800040de:	eb2080e7          	jalr	-334(ra) # 80002f8c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800040e2:	8756                	mv	a4,s5
    800040e4:	02092683          	lw	a3,32(s2)
    800040e8:	01698633          	add	a2,s3,s6
    800040ec:	4585                	li	a1,1
    800040ee:	01893503          	ld	a0,24(s2)
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	262080e7          	jalr	610(ra) # 80003354 <writei>
    800040fa:	84aa                	mv	s1,a0
    800040fc:	00a05763          	blez	a0,8000410a <filewrite+0xc0>
        f->off += r;
    80004100:	02092783          	lw	a5,32(s2)
    80004104:	9fa9                	addw	a5,a5,a0
    80004106:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000410a:	01893503          	ld	a0,24(s2)
    8000410e:	fffff097          	auipc	ra,0xfffff
    80004112:	f44080e7          	jalr	-188(ra) # 80003052 <iunlock>
      end_op();
    80004116:	00000097          	auipc	ra,0x0
    8000411a:	8be080e7          	jalr	-1858(ra) # 800039d4 <end_op>

      if(r != n1){
    8000411e:	029a9563          	bne	s5,s1,80004148 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80004122:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004126:	0149da63          	bge	s3,s4,8000413a <filewrite+0xf0>
      int n1 = n - i;
    8000412a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000412e:	0004879b          	sext.w	a5,s1
    80004132:	f8fbdce3          	bge	s7,a5,800040ca <filewrite+0x80>
    80004136:	84e2                	mv	s1,s8
    80004138:	bf49                	j	800040ca <filewrite+0x80>
    8000413a:	74e2                	ld	s1,56(sp)
    8000413c:	6ae2                	ld	s5,24(sp)
    8000413e:	6ba2                	ld	s7,8(sp)
    80004140:	6c02                	ld	s8,0(sp)
    80004142:	a039                	j	80004150 <filewrite+0x106>
    int i = 0;
    80004144:	4981                	li	s3,0
    80004146:	a029                	j	80004150 <filewrite+0x106>
    80004148:	74e2                	ld	s1,56(sp)
    8000414a:	6ae2                	ld	s5,24(sp)
    8000414c:	6ba2                	ld	s7,8(sp)
    8000414e:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004150:	033a1e63          	bne	s4,s3,8000418c <filewrite+0x142>
    80004154:	8552                	mv	a0,s4
    80004156:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004158:	60a6                	ld	ra,72(sp)
    8000415a:	6406                	ld	s0,64(sp)
    8000415c:	7942                	ld	s2,48(sp)
    8000415e:	7a02                	ld	s4,32(sp)
    80004160:	6b42                	ld	s6,16(sp)
    80004162:	6161                	addi	sp,sp,80
    80004164:	8082                	ret
    80004166:	fc26                	sd	s1,56(sp)
    80004168:	f44e                	sd	s3,40(sp)
    8000416a:	ec56                	sd	s5,24(sp)
    8000416c:	e45e                	sd	s7,8(sp)
    8000416e:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004170:	00004517          	auipc	a0,0x4
    80004174:	44850513          	addi	a0,a0,1096 # 800085b8 <etext+0x5b8>
    80004178:	00002097          	auipc	ra,0x2
    8000417c:	fda080e7          	jalr	-38(ra) # 80006152 <panic>
    return -1;
    80004180:	557d                	li	a0,-1
}
    80004182:	8082                	ret
      return -1;
    80004184:	557d                	li	a0,-1
    80004186:	bfc9                	j	80004158 <filewrite+0x10e>
    80004188:	557d                	li	a0,-1
    8000418a:	b7f9                	j	80004158 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    8000418c:	557d                	li	a0,-1
    8000418e:	79a2                	ld	s3,40(sp)
    80004190:	b7e1                	j	80004158 <filewrite+0x10e>

0000000080004192 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004192:	7179                	addi	sp,sp,-48
    80004194:	f406                	sd	ra,40(sp)
    80004196:	f022                	sd	s0,32(sp)
    80004198:	ec26                	sd	s1,24(sp)
    8000419a:	e052                	sd	s4,0(sp)
    8000419c:	1800                	addi	s0,sp,48
    8000419e:	84aa                	mv	s1,a0
    800041a0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800041a2:	0005b023          	sd	zero,0(a1)
    800041a6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800041aa:	00000097          	auipc	ra,0x0
    800041ae:	bbe080e7          	jalr	-1090(ra) # 80003d68 <filealloc>
    800041b2:	e088                	sd	a0,0(s1)
    800041b4:	cd49                	beqz	a0,8000424e <pipealloc+0xbc>
    800041b6:	00000097          	auipc	ra,0x0
    800041ba:	bb2080e7          	jalr	-1102(ra) # 80003d68 <filealloc>
    800041be:	00aa3023          	sd	a0,0(s4)
    800041c2:	c141                	beqz	a0,80004242 <pipealloc+0xb0>
    800041c4:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800041c6:	ffffc097          	auipc	ra,0xffffc
    800041ca:	fba080e7          	jalr	-70(ra) # 80000180 <kalloc>
    800041ce:	892a                	mv	s2,a0
    800041d0:	c13d                	beqz	a0,80004236 <pipealloc+0xa4>
    800041d2:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800041d4:	4985                	li	s3,1
    800041d6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800041da:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800041de:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800041e2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800041e6:	00004597          	auipc	a1,0x4
    800041ea:	3e258593          	addi	a1,a1,994 # 800085c8 <etext+0x5c8>
    800041ee:	00002097          	auipc	ra,0x2
    800041f2:	44e080e7          	jalr	1102(ra) # 8000663c <initlock>
  (*f0)->type = FD_PIPE;
    800041f6:	609c                	ld	a5,0(s1)
    800041f8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800041fc:	609c                	ld	a5,0(s1)
    800041fe:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004202:	609c                	ld	a5,0(s1)
    80004204:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004208:	609c                	ld	a5,0(s1)
    8000420a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000420e:	000a3783          	ld	a5,0(s4)
    80004212:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004216:	000a3783          	ld	a5,0(s4)
    8000421a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000421e:	000a3783          	ld	a5,0(s4)
    80004222:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004226:	000a3783          	ld	a5,0(s4)
    8000422a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000422e:	4501                	li	a0,0
    80004230:	6942                	ld	s2,16(sp)
    80004232:	69a2                	ld	s3,8(sp)
    80004234:	a03d                	j	80004262 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004236:	6088                	ld	a0,0(s1)
    80004238:	c119                	beqz	a0,8000423e <pipealloc+0xac>
    8000423a:	6942                	ld	s2,16(sp)
    8000423c:	a029                	j	80004246 <pipealloc+0xb4>
    8000423e:	6942                	ld	s2,16(sp)
    80004240:	a039                	j	8000424e <pipealloc+0xbc>
    80004242:	6088                	ld	a0,0(s1)
    80004244:	c50d                	beqz	a0,8000426e <pipealloc+0xdc>
    fileclose(*f0);
    80004246:	00000097          	auipc	ra,0x0
    8000424a:	bde080e7          	jalr	-1058(ra) # 80003e24 <fileclose>
  if(*f1)
    8000424e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004252:	557d                	li	a0,-1
  if(*f1)
    80004254:	c799                	beqz	a5,80004262 <pipealloc+0xd0>
    fileclose(*f1);
    80004256:	853e                	mv	a0,a5
    80004258:	00000097          	auipc	ra,0x0
    8000425c:	bcc080e7          	jalr	-1076(ra) # 80003e24 <fileclose>
  return -1;
    80004260:	557d                	li	a0,-1
}
    80004262:	70a2                	ld	ra,40(sp)
    80004264:	7402                	ld	s0,32(sp)
    80004266:	64e2                	ld	s1,24(sp)
    80004268:	6a02                	ld	s4,0(sp)
    8000426a:	6145                	addi	sp,sp,48
    8000426c:	8082                	ret
  return -1;
    8000426e:	557d                	li	a0,-1
    80004270:	bfcd                	j	80004262 <pipealloc+0xd0>

0000000080004272 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004272:	1101                	addi	sp,sp,-32
    80004274:	ec06                	sd	ra,24(sp)
    80004276:	e822                	sd	s0,16(sp)
    80004278:	e426                	sd	s1,8(sp)
    8000427a:	e04a                	sd	s2,0(sp)
    8000427c:	1000                	addi	s0,sp,32
    8000427e:	84aa                	mv	s1,a0
    80004280:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004282:	00002097          	auipc	ra,0x2
    80004286:	44a080e7          	jalr	1098(ra) # 800066cc <acquire>
  if(writable){
    8000428a:	02090d63          	beqz	s2,800042c4 <pipeclose+0x52>
    pi->writeopen = 0;
    8000428e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004292:	21848513          	addi	a0,s1,536
    80004296:	ffffd097          	auipc	ra,0xffffd
    8000429a:	60c080e7          	jalr	1548(ra) # 800018a2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000429e:	2204b783          	ld	a5,544(s1)
    800042a2:	eb95                	bnez	a5,800042d6 <pipeclose+0x64>
    release(&pi->lock);
    800042a4:	8526                	mv	a0,s1
    800042a6:	00002097          	auipc	ra,0x2
    800042aa:	4da080e7          	jalr	1242(ra) # 80006780 <release>
    kfree((char*)pi);
    800042ae:	8526                	mv	a0,s1
    800042b0:	ffffc097          	auipc	ra,0xffffc
    800042b4:	d6c080e7          	jalr	-660(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800042b8:	60e2                	ld	ra,24(sp)
    800042ba:	6442                	ld	s0,16(sp)
    800042bc:	64a2                	ld	s1,8(sp)
    800042be:	6902                	ld	s2,0(sp)
    800042c0:	6105                	addi	sp,sp,32
    800042c2:	8082                	ret
    pi->readopen = 0;
    800042c4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800042c8:	21c48513          	addi	a0,s1,540
    800042cc:	ffffd097          	auipc	ra,0xffffd
    800042d0:	5d6080e7          	jalr	1494(ra) # 800018a2 <wakeup>
    800042d4:	b7e9                	j	8000429e <pipeclose+0x2c>
    release(&pi->lock);
    800042d6:	8526                	mv	a0,s1
    800042d8:	00002097          	auipc	ra,0x2
    800042dc:	4a8080e7          	jalr	1192(ra) # 80006780 <release>
}
    800042e0:	bfe1                	j	800042b8 <pipeclose+0x46>

00000000800042e2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800042e2:	711d                	addi	sp,sp,-96
    800042e4:	ec86                	sd	ra,88(sp)
    800042e6:	e8a2                	sd	s0,80(sp)
    800042e8:	e4a6                	sd	s1,72(sp)
    800042ea:	e0ca                	sd	s2,64(sp)
    800042ec:	fc4e                	sd	s3,56(sp)
    800042ee:	f852                	sd	s4,48(sp)
    800042f0:	f456                	sd	s5,40(sp)
    800042f2:	1080                	addi	s0,sp,96
    800042f4:	84aa                	mv	s1,a0
    800042f6:	8aae                	mv	s5,a1
    800042f8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800042fa:	ffffd097          	auipc	ra,0xffffd
    800042fe:	e96080e7          	jalr	-362(ra) # 80001190 <myproc>
    80004302:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004304:	8526                	mv	a0,s1
    80004306:	00002097          	auipc	ra,0x2
    8000430a:	3c6080e7          	jalr	966(ra) # 800066cc <acquire>
  while(i < n){
    8000430e:	0d405863          	blez	s4,800043de <pipewrite+0xfc>
    80004312:	f05a                	sd	s6,32(sp)
    80004314:	ec5e                	sd	s7,24(sp)
    80004316:	e862                	sd	s8,16(sp)
  int i = 0;
    80004318:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000431a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000431c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004320:	21c48b93          	addi	s7,s1,540
    80004324:	a089                	j	80004366 <pipewrite+0x84>
      release(&pi->lock);
    80004326:	8526                	mv	a0,s1
    80004328:	00002097          	auipc	ra,0x2
    8000432c:	458080e7          	jalr	1112(ra) # 80006780 <release>
      return -1;
    80004330:	597d                	li	s2,-1
    80004332:	7b02                	ld	s6,32(sp)
    80004334:	6be2                	ld	s7,24(sp)
    80004336:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004338:	854a                	mv	a0,s2
    8000433a:	60e6                	ld	ra,88(sp)
    8000433c:	6446                	ld	s0,80(sp)
    8000433e:	64a6                	ld	s1,72(sp)
    80004340:	6906                	ld	s2,64(sp)
    80004342:	79e2                	ld	s3,56(sp)
    80004344:	7a42                	ld	s4,48(sp)
    80004346:	7aa2                	ld	s5,40(sp)
    80004348:	6125                	addi	sp,sp,96
    8000434a:	8082                	ret
      wakeup(&pi->nread);
    8000434c:	8562                	mv	a0,s8
    8000434e:	ffffd097          	auipc	ra,0xffffd
    80004352:	554080e7          	jalr	1364(ra) # 800018a2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004356:	85a6                	mv	a1,s1
    80004358:	855e                	mv	a0,s7
    8000435a:	ffffd097          	auipc	ra,0xffffd
    8000435e:	4e4080e7          	jalr	1252(ra) # 8000183e <sleep>
  while(i < n){
    80004362:	05495f63          	bge	s2,s4,800043c0 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    80004366:	2204a783          	lw	a5,544(s1)
    8000436a:	dfd5                	beqz	a5,80004326 <pipewrite+0x44>
    8000436c:	854e                	mv	a0,s3
    8000436e:	ffffd097          	auipc	ra,0xffffd
    80004372:	778080e7          	jalr	1912(ra) # 80001ae6 <killed>
    80004376:	f945                	bnez	a0,80004326 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004378:	2184a783          	lw	a5,536(s1)
    8000437c:	21c4a703          	lw	a4,540(s1)
    80004380:	2007879b          	addiw	a5,a5,512
    80004384:	fcf704e3          	beq	a4,a5,8000434c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004388:	4685                	li	a3,1
    8000438a:	01590633          	add	a2,s2,s5
    8000438e:	faf40593          	addi	a1,s0,-81
    80004392:	0509b503          	ld	a0,80(s3)
    80004396:	ffffd097          	auipc	ra,0xffffd
    8000439a:	b1e080e7          	jalr	-1250(ra) # 80000eb4 <copyin>
    8000439e:	05650263          	beq	a0,s6,800043e2 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800043a2:	21c4a783          	lw	a5,540(s1)
    800043a6:	0017871b          	addiw	a4,a5,1
    800043aa:	20e4ae23          	sw	a4,540(s1)
    800043ae:	1ff7f793          	andi	a5,a5,511
    800043b2:	97a6                	add	a5,a5,s1
    800043b4:	faf44703          	lbu	a4,-81(s0)
    800043b8:	00e78c23          	sb	a4,24(a5)
      i++;
    800043bc:	2905                	addiw	s2,s2,1
    800043be:	b755                	j	80004362 <pipewrite+0x80>
    800043c0:	7b02                	ld	s6,32(sp)
    800043c2:	6be2                	ld	s7,24(sp)
    800043c4:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800043c6:	21848513          	addi	a0,s1,536
    800043ca:	ffffd097          	auipc	ra,0xffffd
    800043ce:	4d8080e7          	jalr	1240(ra) # 800018a2 <wakeup>
  release(&pi->lock);
    800043d2:	8526                	mv	a0,s1
    800043d4:	00002097          	auipc	ra,0x2
    800043d8:	3ac080e7          	jalr	940(ra) # 80006780 <release>
  return i;
    800043dc:	bfb1                	j	80004338 <pipewrite+0x56>
  int i = 0;
    800043de:	4901                	li	s2,0
    800043e0:	b7dd                	j	800043c6 <pipewrite+0xe4>
    800043e2:	7b02                	ld	s6,32(sp)
    800043e4:	6be2                	ld	s7,24(sp)
    800043e6:	6c42                	ld	s8,16(sp)
    800043e8:	bff9                	j	800043c6 <pipewrite+0xe4>

00000000800043ea <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800043ea:	715d                	addi	sp,sp,-80
    800043ec:	e486                	sd	ra,72(sp)
    800043ee:	e0a2                	sd	s0,64(sp)
    800043f0:	fc26                	sd	s1,56(sp)
    800043f2:	f84a                	sd	s2,48(sp)
    800043f4:	f44e                	sd	s3,40(sp)
    800043f6:	f052                	sd	s4,32(sp)
    800043f8:	ec56                	sd	s5,24(sp)
    800043fa:	0880                	addi	s0,sp,80
    800043fc:	84aa                	mv	s1,a0
    800043fe:	892e                	mv	s2,a1
    80004400:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004402:	ffffd097          	auipc	ra,0xffffd
    80004406:	d8e080e7          	jalr	-626(ra) # 80001190 <myproc>
    8000440a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000440c:	8526                	mv	a0,s1
    8000440e:	00002097          	auipc	ra,0x2
    80004412:	2be080e7          	jalr	702(ra) # 800066cc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004416:	2184a703          	lw	a4,536(s1)
    8000441a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000441e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004422:	02f71963          	bne	a4,a5,80004454 <piperead+0x6a>
    80004426:	2244a783          	lw	a5,548(s1)
    8000442a:	cf95                	beqz	a5,80004466 <piperead+0x7c>
    if(killed(pr)){
    8000442c:	8552                	mv	a0,s4
    8000442e:	ffffd097          	auipc	ra,0xffffd
    80004432:	6b8080e7          	jalr	1720(ra) # 80001ae6 <killed>
    80004436:	e10d                	bnez	a0,80004458 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004438:	85a6                	mv	a1,s1
    8000443a:	854e                	mv	a0,s3
    8000443c:	ffffd097          	auipc	ra,0xffffd
    80004440:	402080e7          	jalr	1026(ra) # 8000183e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004444:	2184a703          	lw	a4,536(s1)
    80004448:	21c4a783          	lw	a5,540(s1)
    8000444c:	fcf70de3          	beq	a4,a5,80004426 <piperead+0x3c>
    80004450:	e85a                	sd	s6,16(sp)
    80004452:	a819                	j	80004468 <piperead+0x7e>
    80004454:	e85a                	sd	s6,16(sp)
    80004456:	a809                	j	80004468 <piperead+0x7e>
      release(&pi->lock);
    80004458:	8526                	mv	a0,s1
    8000445a:	00002097          	auipc	ra,0x2
    8000445e:	326080e7          	jalr	806(ra) # 80006780 <release>
      return -1;
    80004462:	59fd                	li	s3,-1
    80004464:	a0a5                	j	800044cc <piperead+0xe2>
    80004466:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004468:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000446a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000446c:	05505463          	blez	s5,800044b4 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    80004470:	2184a783          	lw	a5,536(s1)
    80004474:	21c4a703          	lw	a4,540(s1)
    80004478:	02f70e63          	beq	a4,a5,800044b4 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000447c:	0017871b          	addiw	a4,a5,1
    80004480:	20e4ac23          	sw	a4,536(s1)
    80004484:	1ff7f793          	andi	a5,a5,511
    80004488:	97a6                	add	a5,a5,s1
    8000448a:	0187c783          	lbu	a5,24(a5)
    8000448e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004492:	4685                	li	a3,1
    80004494:	fbf40613          	addi	a2,s0,-65
    80004498:	85ca                	mv	a1,s2
    8000449a:	050a3503          	ld	a0,80(s4)
    8000449e:	ffffd097          	auipc	ra,0xffffd
    800044a2:	8fc080e7          	jalr	-1796(ra) # 80000d9a <copyout>
    800044a6:	01650763          	beq	a0,s6,800044b4 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800044aa:	2985                	addiw	s3,s3,1
    800044ac:	0905                	addi	s2,s2,1
    800044ae:	fd3a91e3          	bne	s5,s3,80004470 <piperead+0x86>
    800044b2:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800044b4:	21c48513          	addi	a0,s1,540
    800044b8:	ffffd097          	auipc	ra,0xffffd
    800044bc:	3ea080e7          	jalr	1002(ra) # 800018a2 <wakeup>
  release(&pi->lock);
    800044c0:	8526                	mv	a0,s1
    800044c2:	00002097          	auipc	ra,0x2
    800044c6:	2be080e7          	jalr	702(ra) # 80006780 <release>
    800044ca:	6b42                	ld	s6,16(sp)
  return i;
}
    800044cc:	854e                	mv	a0,s3
    800044ce:	60a6                	ld	ra,72(sp)
    800044d0:	6406                	ld	s0,64(sp)
    800044d2:	74e2                	ld	s1,56(sp)
    800044d4:	7942                	ld	s2,48(sp)
    800044d6:	79a2                	ld	s3,40(sp)
    800044d8:	7a02                	ld	s4,32(sp)
    800044da:	6ae2                	ld	s5,24(sp)
    800044dc:	6161                	addi	sp,sp,80
    800044de:	8082                	ret

00000000800044e0 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800044e0:	1141                	addi	sp,sp,-16
    800044e2:	e422                	sd	s0,8(sp)
    800044e4:	0800                	addi	s0,sp,16
    800044e6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800044e8:	8905                	andi	a0,a0,1
    800044ea:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800044ec:	8b89                	andi	a5,a5,2
    800044ee:	c399                	beqz	a5,800044f4 <flags2perm+0x14>
      perm |= PTE_W;
    800044f0:	00456513          	ori	a0,a0,4
    return perm;
}
    800044f4:	6422                	ld	s0,8(sp)
    800044f6:	0141                	addi	sp,sp,16
    800044f8:	8082                	ret

00000000800044fa <exec>:

int
exec(char *path, char **argv)
{
    800044fa:	df010113          	addi	sp,sp,-528
    800044fe:	20113423          	sd	ra,520(sp)
    80004502:	20813023          	sd	s0,512(sp)
    80004506:	ffa6                	sd	s1,504(sp)
    80004508:	fbca                	sd	s2,496(sp)
    8000450a:	0c00                	addi	s0,sp,528
    8000450c:	892a                	mv	s2,a0
    8000450e:	dea43c23          	sd	a0,-520(s0)
    80004512:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004516:	ffffd097          	auipc	ra,0xffffd
    8000451a:	c7a080e7          	jalr	-902(ra) # 80001190 <myproc>
    8000451e:	84aa                	mv	s1,a0

  begin_op();
    80004520:	fffff097          	auipc	ra,0xfffff
    80004524:	43a080e7          	jalr	1082(ra) # 8000395a <begin_op>

  if((ip = namei(path)) == 0){
    80004528:	854a                	mv	a0,s2
    8000452a:	fffff097          	auipc	ra,0xfffff
    8000452e:	230080e7          	jalr	560(ra) # 8000375a <namei>
    80004532:	c135                	beqz	a0,80004596 <exec+0x9c>
    80004534:	f3d2                	sd	s4,480(sp)
    80004536:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004538:	fffff097          	auipc	ra,0xfffff
    8000453c:	a54080e7          	jalr	-1452(ra) # 80002f8c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004540:	04000713          	li	a4,64
    80004544:	4681                	li	a3,0
    80004546:	e5040613          	addi	a2,s0,-432
    8000454a:	4581                	li	a1,0
    8000454c:	8552                	mv	a0,s4
    8000454e:	fffff097          	auipc	ra,0xfffff
    80004552:	cf6080e7          	jalr	-778(ra) # 80003244 <readi>
    80004556:	04000793          	li	a5,64
    8000455a:	00f51a63          	bne	a0,a5,8000456e <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000455e:	e5042703          	lw	a4,-432(s0)
    80004562:	464c47b7          	lui	a5,0x464c4
    80004566:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000456a:	02f70c63          	beq	a4,a5,800045a2 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000456e:	8552                	mv	a0,s4
    80004570:	fffff097          	auipc	ra,0xfffff
    80004574:	c82080e7          	jalr	-894(ra) # 800031f2 <iunlockput>
    end_op();
    80004578:	fffff097          	auipc	ra,0xfffff
    8000457c:	45c080e7          	jalr	1116(ra) # 800039d4 <end_op>
  }
  return -1;
    80004580:	557d                	li	a0,-1
    80004582:	7a1e                	ld	s4,480(sp)
}
    80004584:	20813083          	ld	ra,520(sp)
    80004588:	20013403          	ld	s0,512(sp)
    8000458c:	74fe                	ld	s1,504(sp)
    8000458e:	795e                	ld	s2,496(sp)
    80004590:	21010113          	addi	sp,sp,528
    80004594:	8082                	ret
    end_op();
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	43e080e7          	jalr	1086(ra) # 800039d4 <end_op>
    return -1;
    8000459e:	557d                	li	a0,-1
    800045a0:	b7d5                	j	80004584 <exec+0x8a>
    800045a2:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800045a4:	8526                	mv	a0,s1
    800045a6:	ffffd097          	auipc	ra,0xffffd
    800045aa:	cb2080e7          	jalr	-846(ra) # 80001258 <proc_pagetable>
    800045ae:	8b2a                	mv	s6,a0
    800045b0:	30050f63          	beqz	a0,800048ce <exec+0x3d4>
    800045b4:	f7ce                	sd	s3,488(sp)
    800045b6:	efd6                	sd	s5,472(sp)
    800045b8:	e7de                	sd	s7,456(sp)
    800045ba:	e3e2                	sd	s8,448(sp)
    800045bc:	ff66                	sd	s9,440(sp)
    800045be:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045c0:	e7042d03          	lw	s10,-400(s0)
    800045c4:	e8845783          	lhu	a5,-376(s0)
    800045c8:	14078d63          	beqz	a5,80004722 <exec+0x228>
    800045cc:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045ce:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045d0:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800045d2:	6c85                	lui	s9,0x1
    800045d4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800045d8:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800045dc:	6a85                	lui	s5,0x1
    800045de:	a0b5                	j	8000464a <exec+0x150>
      panic("loadseg: address should exist");
    800045e0:	00004517          	auipc	a0,0x4
    800045e4:	ff050513          	addi	a0,a0,-16 # 800085d0 <etext+0x5d0>
    800045e8:	00002097          	auipc	ra,0x2
    800045ec:	b6a080e7          	jalr	-1174(ra) # 80006152 <panic>
    if(sz - i < PGSIZE)
    800045f0:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800045f2:	8726                	mv	a4,s1
    800045f4:	012c06bb          	addw	a3,s8,s2
    800045f8:	4581                	li	a1,0
    800045fa:	8552                	mv	a0,s4
    800045fc:	fffff097          	auipc	ra,0xfffff
    80004600:	c48080e7          	jalr	-952(ra) # 80003244 <readi>
    80004604:	2501                	sext.w	a0,a0
    80004606:	28a49863          	bne	s1,a0,80004896 <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    8000460a:	012a893b          	addw	s2,s5,s2
    8000460e:	03397563          	bgeu	s2,s3,80004638 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004612:	02091593          	slli	a1,s2,0x20
    80004616:	9181                	srli	a1,a1,0x20
    80004618:	95de                	add	a1,a1,s7
    8000461a:	855a                	mv	a0,s6
    8000461c:	ffffc097          	auipc	ra,0xffffc
    80004620:	010080e7          	jalr	16(ra) # 8000062c <walkaddr>
    80004624:	862a                	mv	a2,a0
    if(pa == 0)
    80004626:	dd4d                	beqz	a0,800045e0 <exec+0xe6>
    if(sz - i < PGSIZE)
    80004628:	412984bb          	subw	s1,s3,s2
    8000462c:	0004879b          	sext.w	a5,s1
    80004630:	fcfcf0e3          	bgeu	s9,a5,800045f0 <exec+0xf6>
    80004634:	84d6                	mv	s1,s5
    80004636:	bf6d                	j	800045f0 <exec+0xf6>
    sz = sz1;
    80004638:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000463c:	2d85                	addiw	s11,s11,1
    8000463e:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004642:	e8845783          	lhu	a5,-376(s0)
    80004646:	08fdd663          	bge	s11,a5,800046d2 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000464a:	2d01                	sext.w	s10,s10
    8000464c:	03800713          	li	a4,56
    80004650:	86ea                	mv	a3,s10
    80004652:	e1840613          	addi	a2,s0,-488
    80004656:	4581                	li	a1,0
    80004658:	8552                	mv	a0,s4
    8000465a:	fffff097          	auipc	ra,0xfffff
    8000465e:	bea080e7          	jalr	-1046(ra) # 80003244 <readi>
    80004662:	03800793          	li	a5,56
    80004666:	20f51063          	bne	a0,a5,80004866 <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    8000466a:	e1842783          	lw	a5,-488(s0)
    8000466e:	4705                	li	a4,1
    80004670:	fce796e3          	bne	a5,a4,8000463c <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004674:	e4043483          	ld	s1,-448(s0)
    80004678:	e3843783          	ld	a5,-456(s0)
    8000467c:	1ef4e963          	bltu	s1,a5,8000486e <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004680:	e2843783          	ld	a5,-472(s0)
    80004684:	94be                	add	s1,s1,a5
    80004686:	1ef4e863          	bltu	s1,a5,80004876 <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    8000468a:	df043703          	ld	a4,-528(s0)
    8000468e:	8ff9                	and	a5,a5,a4
    80004690:	1e079763          	bnez	a5,8000487e <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004694:	e1c42503          	lw	a0,-484(s0)
    80004698:	00000097          	auipc	ra,0x0
    8000469c:	e48080e7          	jalr	-440(ra) # 800044e0 <flags2perm>
    800046a0:	86aa                	mv	a3,a0
    800046a2:	8626                	mv	a2,s1
    800046a4:	85ca                	mv	a1,s2
    800046a6:	855a                	mv	a0,s6
    800046a8:	ffffc097          	auipc	ra,0xffffc
    800046ac:	36c080e7          	jalr	876(ra) # 80000a14 <uvmalloc>
    800046b0:	e0a43423          	sd	a0,-504(s0)
    800046b4:	1c050963          	beqz	a0,80004886 <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800046b8:	e2843b83          	ld	s7,-472(s0)
    800046bc:	e2042c03          	lw	s8,-480(s0)
    800046c0:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800046c4:	00098463          	beqz	s3,800046cc <exec+0x1d2>
    800046c8:	4901                	li	s2,0
    800046ca:	b7a1                	j	80004612 <exec+0x118>
    sz = sz1;
    800046cc:	e0843903          	ld	s2,-504(s0)
    800046d0:	b7b5                	j	8000463c <exec+0x142>
    800046d2:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800046d4:	8552                	mv	a0,s4
    800046d6:	fffff097          	auipc	ra,0xfffff
    800046da:	b1c080e7          	jalr	-1252(ra) # 800031f2 <iunlockput>
  end_op();
    800046de:	fffff097          	auipc	ra,0xfffff
    800046e2:	2f6080e7          	jalr	758(ra) # 800039d4 <end_op>
  p = myproc();
    800046e6:	ffffd097          	auipc	ra,0xffffd
    800046ea:	aaa080e7          	jalr	-1366(ra) # 80001190 <myproc>
    800046ee:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800046f0:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800046f4:	6985                	lui	s3,0x1
    800046f6:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800046f8:	99ca                	add	s3,s3,s2
    800046fa:	77fd                	lui	a5,0xfffff
    800046fc:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004700:	4691                	li	a3,4
    80004702:	6609                	lui	a2,0x2
    80004704:	964e                	add	a2,a2,s3
    80004706:	85ce                	mv	a1,s3
    80004708:	855a                	mv	a0,s6
    8000470a:	ffffc097          	auipc	ra,0xffffc
    8000470e:	30a080e7          	jalr	778(ra) # 80000a14 <uvmalloc>
    80004712:	892a                	mv	s2,a0
    80004714:	e0a43423          	sd	a0,-504(s0)
    80004718:	e519                	bnez	a0,80004726 <exec+0x22c>
  if(pagetable)
    8000471a:	e1343423          	sd	s3,-504(s0)
    8000471e:	4a01                	li	s4,0
    80004720:	aaa5                	j	80004898 <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004722:	4901                	li	s2,0
    80004724:	bf45                	j	800046d4 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004726:	75f9                	lui	a1,0xffffe
    80004728:	95aa                	add	a1,a1,a0
    8000472a:	855a                	mv	a0,s6
    8000472c:	ffffc097          	auipc	ra,0xffffc
    80004730:	50a080e7          	jalr	1290(ra) # 80000c36 <uvmclear>
  stackbase = sp - PGSIZE;
    80004734:	7bfd                	lui	s7,0xfffff
    80004736:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004738:	e0043783          	ld	a5,-512(s0)
    8000473c:	6388                	ld	a0,0(a5)
    8000473e:	c52d                	beqz	a0,800047a8 <exec+0x2ae>
    80004740:	e9040993          	addi	s3,s0,-368
    80004744:	f9040c13          	addi	s8,s0,-112
    80004748:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000474a:	ffffc097          	auipc	ra,0xffffc
    8000474e:	cd4080e7          	jalr	-812(ra) # 8000041e <strlen>
    80004752:	0015079b          	addiw	a5,a0,1
    80004756:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000475a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000475e:	13796863          	bltu	s2,s7,8000488e <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004762:	e0043d03          	ld	s10,-512(s0)
    80004766:	000d3a03          	ld	s4,0(s10)
    8000476a:	8552                	mv	a0,s4
    8000476c:	ffffc097          	auipc	ra,0xffffc
    80004770:	cb2080e7          	jalr	-846(ra) # 8000041e <strlen>
    80004774:	0015069b          	addiw	a3,a0,1
    80004778:	8652                	mv	a2,s4
    8000477a:	85ca                	mv	a1,s2
    8000477c:	855a                	mv	a0,s6
    8000477e:	ffffc097          	auipc	ra,0xffffc
    80004782:	61c080e7          	jalr	1564(ra) # 80000d9a <copyout>
    80004786:	10054663          	bltz	a0,80004892 <exec+0x398>
    ustack[argc] = sp;
    8000478a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000478e:	0485                	addi	s1,s1,1
    80004790:	008d0793          	addi	a5,s10,8
    80004794:	e0f43023          	sd	a5,-512(s0)
    80004798:	008d3503          	ld	a0,8(s10)
    8000479c:	c909                	beqz	a0,800047ae <exec+0x2b4>
    if(argc >= MAXARG)
    8000479e:	09a1                	addi	s3,s3,8
    800047a0:	fb8995e3          	bne	s3,s8,8000474a <exec+0x250>
  ip = 0;
    800047a4:	4a01                	li	s4,0
    800047a6:	a8cd                	j	80004898 <exec+0x39e>
  sp = sz;
    800047a8:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800047ac:	4481                	li	s1,0
  ustack[argc] = 0;
    800047ae:	00349793          	slli	a5,s1,0x3
    800047b2:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7fdbd1c0>
    800047b6:	97a2                	add	a5,a5,s0
    800047b8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800047bc:	00148693          	addi	a3,s1,1
    800047c0:	068e                	slli	a3,a3,0x3
    800047c2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800047c6:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800047ca:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800047ce:	f57966e3          	bltu	s2,s7,8000471a <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800047d2:	e9040613          	addi	a2,s0,-368
    800047d6:	85ca                	mv	a1,s2
    800047d8:	855a                	mv	a0,s6
    800047da:	ffffc097          	auipc	ra,0xffffc
    800047de:	5c0080e7          	jalr	1472(ra) # 80000d9a <copyout>
    800047e2:	0e054863          	bltz	a0,800048d2 <exec+0x3d8>
  p->trapframe->a1 = sp;
    800047e6:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800047ea:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800047ee:	df843783          	ld	a5,-520(s0)
    800047f2:	0007c703          	lbu	a4,0(a5)
    800047f6:	cf11                	beqz	a4,80004812 <exec+0x318>
    800047f8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800047fa:	02f00693          	li	a3,47
    800047fe:	a039                	j	8000480c <exec+0x312>
      last = s+1;
    80004800:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004804:	0785                	addi	a5,a5,1
    80004806:	fff7c703          	lbu	a4,-1(a5)
    8000480a:	c701                	beqz	a4,80004812 <exec+0x318>
    if(*s == '/')
    8000480c:	fed71ce3          	bne	a4,a3,80004804 <exec+0x30a>
    80004810:	bfc5                	j	80004800 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80004812:	4641                	li	a2,16
    80004814:	df843583          	ld	a1,-520(s0)
    80004818:	158a8513          	addi	a0,s5,344
    8000481c:	ffffc097          	auipc	ra,0xffffc
    80004820:	bd0080e7          	jalr	-1072(ra) # 800003ec <safestrcpy>
  oldpagetable = p->pagetable;
    80004824:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004828:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000482c:	e0843783          	ld	a5,-504(s0)
    80004830:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004834:	058ab783          	ld	a5,88(s5)
    80004838:	e6843703          	ld	a4,-408(s0)
    8000483c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000483e:	058ab783          	ld	a5,88(s5)
    80004842:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004846:	85e6                	mv	a1,s9
    80004848:	ffffd097          	auipc	ra,0xffffd
    8000484c:	aac080e7          	jalr	-1364(ra) # 800012f4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004850:	0004851b          	sext.w	a0,s1
    80004854:	79be                	ld	s3,488(sp)
    80004856:	7a1e                	ld	s4,480(sp)
    80004858:	6afe                	ld	s5,472(sp)
    8000485a:	6b5e                	ld	s6,464(sp)
    8000485c:	6bbe                	ld	s7,456(sp)
    8000485e:	6c1e                	ld	s8,448(sp)
    80004860:	7cfa                	ld	s9,440(sp)
    80004862:	7d5a                	ld	s10,432(sp)
    80004864:	b305                	j	80004584 <exec+0x8a>
    80004866:	e1243423          	sd	s2,-504(s0)
    8000486a:	7dba                	ld	s11,424(sp)
    8000486c:	a035                	j	80004898 <exec+0x39e>
    8000486e:	e1243423          	sd	s2,-504(s0)
    80004872:	7dba                	ld	s11,424(sp)
    80004874:	a015                	j	80004898 <exec+0x39e>
    80004876:	e1243423          	sd	s2,-504(s0)
    8000487a:	7dba                	ld	s11,424(sp)
    8000487c:	a831                	j	80004898 <exec+0x39e>
    8000487e:	e1243423          	sd	s2,-504(s0)
    80004882:	7dba                	ld	s11,424(sp)
    80004884:	a811                	j	80004898 <exec+0x39e>
    80004886:	e1243423          	sd	s2,-504(s0)
    8000488a:	7dba                	ld	s11,424(sp)
    8000488c:	a031                	j	80004898 <exec+0x39e>
  ip = 0;
    8000488e:	4a01                	li	s4,0
    80004890:	a021                	j	80004898 <exec+0x39e>
    80004892:	4a01                	li	s4,0
  if(pagetable)
    80004894:	a011                	j	80004898 <exec+0x39e>
    80004896:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004898:	e0843583          	ld	a1,-504(s0)
    8000489c:	855a                	mv	a0,s6
    8000489e:	ffffd097          	auipc	ra,0xffffd
    800048a2:	a56080e7          	jalr	-1450(ra) # 800012f4 <proc_freepagetable>
  return -1;
    800048a6:	557d                	li	a0,-1
  if(ip){
    800048a8:	000a1b63          	bnez	s4,800048be <exec+0x3c4>
    800048ac:	79be                	ld	s3,488(sp)
    800048ae:	7a1e                	ld	s4,480(sp)
    800048b0:	6afe                	ld	s5,472(sp)
    800048b2:	6b5e                	ld	s6,464(sp)
    800048b4:	6bbe                	ld	s7,456(sp)
    800048b6:	6c1e                	ld	s8,448(sp)
    800048b8:	7cfa                	ld	s9,440(sp)
    800048ba:	7d5a                	ld	s10,432(sp)
    800048bc:	b1e1                	j	80004584 <exec+0x8a>
    800048be:	79be                	ld	s3,488(sp)
    800048c0:	6afe                	ld	s5,472(sp)
    800048c2:	6b5e                	ld	s6,464(sp)
    800048c4:	6bbe                	ld	s7,456(sp)
    800048c6:	6c1e                	ld	s8,448(sp)
    800048c8:	7cfa                	ld	s9,440(sp)
    800048ca:	7d5a                	ld	s10,432(sp)
    800048cc:	b14d                	j	8000456e <exec+0x74>
    800048ce:	6b5e                	ld	s6,464(sp)
    800048d0:	b979                	j	8000456e <exec+0x74>
  sz = sz1;
    800048d2:	e0843983          	ld	s3,-504(s0)
    800048d6:	b591                	j	8000471a <exec+0x220>

00000000800048d8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800048d8:	7179                	addi	sp,sp,-48
    800048da:	f406                	sd	ra,40(sp)
    800048dc:	f022                	sd	s0,32(sp)
    800048de:	ec26                	sd	s1,24(sp)
    800048e0:	e84a                	sd	s2,16(sp)
    800048e2:	1800                	addi	s0,sp,48
    800048e4:	892e                	mv	s2,a1
    800048e6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800048e8:	fdc40593          	addi	a1,s0,-36
    800048ec:	ffffe097          	auipc	ra,0xffffe
    800048f0:	b08080e7          	jalr	-1272(ra) # 800023f4 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800048f4:	fdc42703          	lw	a4,-36(s0)
    800048f8:	47bd                	li	a5,15
    800048fa:	02e7eb63          	bltu	a5,a4,80004930 <argfd+0x58>
    800048fe:	ffffd097          	auipc	ra,0xffffd
    80004902:	892080e7          	jalr	-1902(ra) # 80001190 <myproc>
    80004906:	fdc42703          	lw	a4,-36(s0)
    8000490a:	01a70793          	addi	a5,a4,26
    8000490e:	078e                	slli	a5,a5,0x3
    80004910:	953e                	add	a0,a0,a5
    80004912:	611c                	ld	a5,0(a0)
    80004914:	c385                	beqz	a5,80004934 <argfd+0x5c>
    return -1;
  if(pfd)
    80004916:	00090463          	beqz	s2,8000491e <argfd+0x46>
    *pfd = fd;
    8000491a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000491e:	4501                	li	a0,0
  if(pf)
    80004920:	c091                	beqz	s1,80004924 <argfd+0x4c>
    *pf = f;
    80004922:	e09c                	sd	a5,0(s1)
}
    80004924:	70a2                	ld	ra,40(sp)
    80004926:	7402                	ld	s0,32(sp)
    80004928:	64e2                	ld	s1,24(sp)
    8000492a:	6942                	ld	s2,16(sp)
    8000492c:	6145                	addi	sp,sp,48
    8000492e:	8082                	ret
    return -1;
    80004930:	557d                	li	a0,-1
    80004932:	bfcd                	j	80004924 <argfd+0x4c>
    80004934:	557d                	li	a0,-1
    80004936:	b7fd                	j	80004924 <argfd+0x4c>

0000000080004938 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004938:	1101                	addi	sp,sp,-32
    8000493a:	ec06                	sd	ra,24(sp)
    8000493c:	e822                	sd	s0,16(sp)
    8000493e:	e426                	sd	s1,8(sp)
    80004940:	1000                	addi	s0,sp,32
    80004942:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004944:	ffffd097          	auipc	ra,0xffffd
    80004948:	84c080e7          	jalr	-1972(ra) # 80001190 <myproc>
    8000494c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000494e:	0d050793          	addi	a5,a0,208
    80004952:	4501                	li	a0,0
    80004954:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004956:	6398                	ld	a4,0(a5)
    80004958:	cb19                	beqz	a4,8000496e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000495a:	2505                	addiw	a0,a0,1
    8000495c:	07a1                	addi	a5,a5,8
    8000495e:	fed51ce3          	bne	a0,a3,80004956 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004962:	557d                	li	a0,-1
}
    80004964:	60e2                	ld	ra,24(sp)
    80004966:	6442                	ld	s0,16(sp)
    80004968:	64a2                	ld	s1,8(sp)
    8000496a:	6105                	addi	sp,sp,32
    8000496c:	8082                	ret
      p->ofile[fd] = f;
    8000496e:	01a50793          	addi	a5,a0,26
    80004972:	078e                	slli	a5,a5,0x3
    80004974:	963e                	add	a2,a2,a5
    80004976:	e204                	sd	s1,0(a2)
      return fd;
    80004978:	b7f5                	j	80004964 <fdalloc+0x2c>

000000008000497a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000497a:	715d                	addi	sp,sp,-80
    8000497c:	e486                	sd	ra,72(sp)
    8000497e:	e0a2                	sd	s0,64(sp)
    80004980:	fc26                	sd	s1,56(sp)
    80004982:	f84a                	sd	s2,48(sp)
    80004984:	f44e                	sd	s3,40(sp)
    80004986:	ec56                	sd	s5,24(sp)
    80004988:	e85a                	sd	s6,16(sp)
    8000498a:	0880                	addi	s0,sp,80
    8000498c:	8b2e                	mv	s6,a1
    8000498e:	89b2                	mv	s3,a2
    80004990:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004992:	fb040593          	addi	a1,s0,-80
    80004996:	fffff097          	auipc	ra,0xfffff
    8000499a:	de2080e7          	jalr	-542(ra) # 80003778 <nameiparent>
    8000499e:	84aa                	mv	s1,a0
    800049a0:	14050e63          	beqz	a0,80004afc <create+0x182>
    return 0;

  ilock(dp);
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	5e8080e7          	jalr	1512(ra) # 80002f8c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800049ac:	4601                	li	a2,0
    800049ae:	fb040593          	addi	a1,s0,-80
    800049b2:	8526                	mv	a0,s1
    800049b4:	fffff097          	auipc	ra,0xfffff
    800049b8:	ae4080e7          	jalr	-1308(ra) # 80003498 <dirlookup>
    800049bc:	8aaa                	mv	s5,a0
    800049be:	c539                	beqz	a0,80004a0c <create+0x92>
    iunlockput(dp);
    800049c0:	8526                	mv	a0,s1
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	830080e7          	jalr	-2000(ra) # 800031f2 <iunlockput>
    ilock(ip);
    800049ca:	8556                	mv	a0,s5
    800049cc:	ffffe097          	auipc	ra,0xffffe
    800049d0:	5c0080e7          	jalr	1472(ra) # 80002f8c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800049d4:	4789                	li	a5,2
    800049d6:	02fb1463          	bne	s6,a5,800049fe <create+0x84>
    800049da:	044ad783          	lhu	a5,68(s5)
    800049de:	37f9                	addiw	a5,a5,-2
    800049e0:	17c2                	slli	a5,a5,0x30
    800049e2:	93c1                	srli	a5,a5,0x30
    800049e4:	4705                	li	a4,1
    800049e6:	00f76c63          	bltu	a4,a5,800049fe <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800049ea:	8556                	mv	a0,s5
    800049ec:	60a6                	ld	ra,72(sp)
    800049ee:	6406                	ld	s0,64(sp)
    800049f0:	74e2                	ld	s1,56(sp)
    800049f2:	7942                	ld	s2,48(sp)
    800049f4:	79a2                	ld	s3,40(sp)
    800049f6:	6ae2                	ld	s5,24(sp)
    800049f8:	6b42                	ld	s6,16(sp)
    800049fa:	6161                	addi	sp,sp,80
    800049fc:	8082                	ret
    iunlockput(ip);
    800049fe:	8556                	mv	a0,s5
    80004a00:	ffffe097          	auipc	ra,0xffffe
    80004a04:	7f2080e7          	jalr	2034(ra) # 800031f2 <iunlockput>
    return 0;
    80004a08:	4a81                	li	s5,0
    80004a0a:	b7c5                	j	800049ea <create+0x70>
    80004a0c:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004a0e:	85da                	mv	a1,s6
    80004a10:	4088                	lw	a0,0(s1)
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	3d6080e7          	jalr	982(ra) # 80002de8 <ialloc>
    80004a1a:	8a2a                	mv	s4,a0
    80004a1c:	c531                	beqz	a0,80004a68 <create+0xee>
  ilock(ip);
    80004a1e:	ffffe097          	auipc	ra,0xffffe
    80004a22:	56e080e7          	jalr	1390(ra) # 80002f8c <ilock>
  ip->major = major;
    80004a26:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004a2a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004a2e:	4905                	li	s2,1
    80004a30:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004a34:	8552                	mv	a0,s4
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	48a080e7          	jalr	1162(ra) # 80002ec0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004a3e:	032b0d63          	beq	s6,s2,80004a78 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004a42:	004a2603          	lw	a2,4(s4)
    80004a46:	fb040593          	addi	a1,s0,-80
    80004a4a:	8526                	mv	a0,s1
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	c5c080e7          	jalr	-932(ra) # 800036a8 <dirlink>
    80004a54:	08054163          	bltz	a0,80004ad6 <create+0x15c>
  iunlockput(dp);
    80004a58:	8526                	mv	a0,s1
    80004a5a:	ffffe097          	auipc	ra,0xffffe
    80004a5e:	798080e7          	jalr	1944(ra) # 800031f2 <iunlockput>
  return ip;
    80004a62:	8ad2                	mv	s5,s4
    80004a64:	7a02                	ld	s4,32(sp)
    80004a66:	b751                	j	800049ea <create+0x70>
    iunlockput(dp);
    80004a68:	8526                	mv	a0,s1
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	788080e7          	jalr	1928(ra) # 800031f2 <iunlockput>
    return 0;
    80004a72:	8ad2                	mv	s5,s4
    80004a74:	7a02                	ld	s4,32(sp)
    80004a76:	bf95                	j	800049ea <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004a78:	004a2603          	lw	a2,4(s4)
    80004a7c:	00004597          	auipc	a1,0x4
    80004a80:	b7458593          	addi	a1,a1,-1164 # 800085f0 <etext+0x5f0>
    80004a84:	8552                	mv	a0,s4
    80004a86:	fffff097          	auipc	ra,0xfffff
    80004a8a:	c22080e7          	jalr	-990(ra) # 800036a8 <dirlink>
    80004a8e:	04054463          	bltz	a0,80004ad6 <create+0x15c>
    80004a92:	40d0                	lw	a2,4(s1)
    80004a94:	00004597          	auipc	a1,0x4
    80004a98:	b6458593          	addi	a1,a1,-1180 # 800085f8 <etext+0x5f8>
    80004a9c:	8552                	mv	a0,s4
    80004a9e:	fffff097          	auipc	ra,0xfffff
    80004aa2:	c0a080e7          	jalr	-1014(ra) # 800036a8 <dirlink>
    80004aa6:	02054863          	bltz	a0,80004ad6 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004aaa:	004a2603          	lw	a2,4(s4)
    80004aae:	fb040593          	addi	a1,s0,-80
    80004ab2:	8526                	mv	a0,s1
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	bf4080e7          	jalr	-1036(ra) # 800036a8 <dirlink>
    80004abc:	00054d63          	bltz	a0,80004ad6 <create+0x15c>
    dp->nlink++;  // for ".."
    80004ac0:	04a4d783          	lhu	a5,74(s1)
    80004ac4:	2785                	addiw	a5,a5,1
    80004ac6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004aca:	8526                	mv	a0,s1
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	3f4080e7          	jalr	1012(ra) # 80002ec0 <iupdate>
    80004ad4:	b751                	j	80004a58 <create+0xde>
  ip->nlink = 0;
    80004ad6:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004ada:	8552                	mv	a0,s4
    80004adc:	ffffe097          	auipc	ra,0xffffe
    80004ae0:	3e4080e7          	jalr	996(ra) # 80002ec0 <iupdate>
  iunlockput(ip);
    80004ae4:	8552                	mv	a0,s4
    80004ae6:	ffffe097          	auipc	ra,0xffffe
    80004aea:	70c080e7          	jalr	1804(ra) # 800031f2 <iunlockput>
  iunlockput(dp);
    80004aee:	8526                	mv	a0,s1
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	702080e7          	jalr	1794(ra) # 800031f2 <iunlockput>
  return 0;
    80004af8:	7a02                	ld	s4,32(sp)
    80004afa:	bdc5                	j	800049ea <create+0x70>
    return 0;
    80004afc:	8aaa                	mv	s5,a0
    80004afe:	b5f5                	j	800049ea <create+0x70>

0000000080004b00 <sys_dup>:
{
    80004b00:	7179                	addi	sp,sp,-48
    80004b02:	f406                	sd	ra,40(sp)
    80004b04:	f022                	sd	s0,32(sp)
    80004b06:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004b08:	fd840613          	addi	a2,s0,-40
    80004b0c:	4581                	li	a1,0
    80004b0e:	4501                	li	a0,0
    80004b10:	00000097          	auipc	ra,0x0
    80004b14:	dc8080e7          	jalr	-568(ra) # 800048d8 <argfd>
    return -1;
    80004b18:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004b1a:	02054763          	bltz	a0,80004b48 <sys_dup+0x48>
    80004b1e:	ec26                	sd	s1,24(sp)
    80004b20:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004b22:	fd843903          	ld	s2,-40(s0)
    80004b26:	854a                	mv	a0,s2
    80004b28:	00000097          	auipc	ra,0x0
    80004b2c:	e10080e7          	jalr	-496(ra) # 80004938 <fdalloc>
    80004b30:	84aa                	mv	s1,a0
    return -1;
    80004b32:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004b34:	00054f63          	bltz	a0,80004b52 <sys_dup+0x52>
  filedup(f);
    80004b38:	854a                	mv	a0,s2
    80004b3a:	fffff097          	auipc	ra,0xfffff
    80004b3e:	298080e7          	jalr	664(ra) # 80003dd2 <filedup>
  return fd;
    80004b42:	87a6                	mv	a5,s1
    80004b44:	64e2                	ld	s1,24(sp)
    80004b46:	6942                	ld	s2,16(sp)
}
    80004b48:	853e                	mv	a0,a5
    80004b4a:	70a2                	ld	ra,40(sp)
    80004b4c:	7402                	ld	s0,32(sp)
    80004b4e:	6145                	addi	sp,sp,48
    80004b50:	8082                	ret
    80004b52:	64e2                	ld	s1,24(sp)
    80004b54:	6942                	ld	s2,16(sp)
    80004b56:	bfcd                	j	80004b48 <sys_dup+0x48>

0000000080004b58 <sys_read>:
{
    80004b58:	7179                	addi	sp,sp,-48
    80004b5a:	f406                	sd	ra,40(sp)
    80004b5c:	f022                	sd	s0,32(sp)
    80004b5e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004b60:	fd840593          	addi	a1,s0,-40
    80004b64:	4505                	li	a0,1
    80004b66:	ffffe097          	auipc	ra,0xffffe
    80004b6a:	8ae080e7          	jalr	-1874(ra) # 80002414 <argaddr>
  argint(2, &n);
    80004b6e:	fe440593          	addi	a1,s0,-28
    80004b72:	4509                	li	a0,2
    80004b74:	ffffe097          	auipc	ra,0xffffe
    80004b78:	880080e7          	jalr	-1920(ra) # 800023f4 <argint>
  if(argfd(0, 0, &f) < 0)
    80004b7c:	fe840613          	addi	a2,s0,-24
    80004b80:	4581                	li	a1,0
    80004b82:	4501                	li	a0,0
    80004b84:	00000097          	auipc	ra,0x0
    80004b88:	d54080e7          	jalr	-684(ra) # 800048d8 <argfd>
    80004b8c:	87aa                	mv	a5,a0
    return -1;
    80004b8e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b90:	0007cc63          	bltz	a5,80004ba8 <sys_read+0x50>
  return fileread(f, p, n);
    80004b94:	fe442603          	lw	a2,-28(s0)
    80004b98:	fd843583          	ld	a1,-40(s0)
    80004b9c:	fe843503          	ld	a0,-24(s0)
    80004ba0:	fffff097          	auipc	ra,0xfffff
    80004ba4:	3d8080e7          	jalr	984(ra) # 80003f78 <fileread>
}
    80004ba8:	70a2                	ld	ra,40(sp)
    80004baa:	7402                	ld	s0,32(sp)
    80004bac:	6145                	addi	sp,sp,48
    80004bae:	8082                	ret

0000000080004bb0 <sys_write>:
{
    80004bb0:	7179                	addi	sp,sp,-48
    80004bb2:	f406                	sd	ra,40(sp)
    80004bb4:	f022                	sd	s0,32(sp)
    80004bb6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004bb8:	fd840593          	addi	a1,s0,-40
    80004bbc:	4505                	li	a0,1
    80004bbe:	ffffe097          	auipc	ra,0xffffe
    80004bc2:	856080e7          	jalr	-1962(ra) # 80002414 <argaddr>
  argint(2, &n);
    80004bc6:	fe440593          	addi	a1,s0,-28
    80004bca:	4509                	li	a0,2
    80004bcc:	ffffe097          	auipc	ra,0xffffe
    80004bd0:	828080e7          	jalr	-2008(ra) # 800023f4 <argint>
  if(argfd(0, 0, &f) < 0)
    80004bd4:	fe840613          	addi	a2,s0,-24
    80004bd8:	4581                	li	a1,0
    80004bda:	4501                	li	a0,0
    80004bdc:	00000097          	auipc	ra,0x0
    80004be0:	cfc080e7          	jalr	-772(ra) # 800048d8 <argfd>
    80004be4:	87aa                	mv	a5,a0
    return -1;
    80004be6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004be8:	0007cc63          	bltz	a5,80004c00 <sys_write+0x50>
  return filewrite(f, p, n);
    80004bec:	fe442603          	lw	a2,-28(s0)
    80004bf0:	fd843583          	ld	a1,-40(s0)
    80004bf4:	fe843503          	ld	a0,-24(s0)
    80004bf8:	fffff097          	auipc	ra,0xfffff
    80004bfc:	452080e7          	jalr	1106(ra) # 8000404a <filewrite>
}
    80004c00:	70a2                	ld	ra,40(sp)
    80004c02:	7402                	ld	s0,32(sp)
    80004c04:	6145                	addi	sp,sp,48
    80004c06:	8082                	ret

0000000080004c08 <sys_close>:
{
    80004c08:	1101                	addi	sp,sp,-32
    80004c0a:	ec06                	sd	ra,24(sp)
    80004c0c:	e822                	sd	s0,16(sp)
    80004c0e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004c10:	fe040613          	addi	a2,s0,-32
    80004c14:	fec40593          	addi	a1,s0,-20
    80004c18:	4501                	li	a0,0
    80004c1a:	00000097          	auipc	ra,0x0
    80004c1e:	cbe080e7          	jalr	-834(ra) # 800048d8 <argfd>
    return -1;
    80004c22:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004c24:	02054463          	bltz	a0,80004c4c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004c28:	ffffc097          	auipc	ra,0xffffc
    80004c2c:	568080e7          	jalr	1384(ra) # 80001190 <myproc>
    80004c30:	fec42783          	lw	a5,-20(s0)
    80004c34:	07e9                	addi	a5,a5,26
    80004c36:	078e                	slli	a5,a5,0x3
    80004c38:	953e                	add	a0,a0,a5
    80004c3a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004c3e:	fe043503          	ld	a0,-32(s0)
    80004c42:	fffff097          	auipc	ra,0xfffff
    80004c46:	1e2080e7          	jalr	482(ra) # 80003e24 <fileclose>
  return 0;
    80004c4a:	4781                	li	a5,0
}
    80004c4c:	853e                	mv	a0,a5
    80004c4e:	60e2                	ld	ra,24(sp)
    80004c50:	6442                	ld	s0,16(sp)
    80004c52:	6105                	addi	sp,sp,32
    80004c54:	8082                	ret

0000000080004c56 <sys_fstat>:
{
    80004c56:	1101                	addi	sp,sp,-32
    80004c58:	ec06                	sd	ra,24(sp)
    80004c5a:	e822                	sd	s0,16(sp)
    80004c5c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004c5e:	fe040593          	addi	a1,s0,-32
    80004c62:	4505                	li	a0,1
    80004c64:	ffffd097          	auipc	ra,0xffffd
    80004c68:	7b0080e7          	jalr	1968(ra) # 80002414 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004c6c:	fe840613          	addi	a2,s0,-24
    80004c70:	4581                	li	a1,0
    80004c72:	4501                	li	a0,0
    80004c74:	00000097          	auipc	ra,0x0
    80004c78:	c64080e7          	jalr	-924(ra) # 800048d8 <argfd>
    80004c7c:	87aa                	mv	a5,a0
    return -1;
    80004c7e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c80:	0007ca63          	bltz	a5,80004c94 <sys_fstat+0x3e>
  return filestat(f, st);
    80004c84:	fe043583          	ld	a1,-32(s0)
    80004c88:	fe843503          	ld	a0,-24(s0)
    80004c8c:	fffff097          	auipc	ra,0xfffff
    80004c90:	27a080e7          	jalr	634(ra) # 80003f06 <filestat>
}
    80004c94:	60e2                	ld	ra,24(sp)
    80004c96:	6442                	ld	s0,16(sp)
    80004c98:	6105                	addi	sp,sp,32
    80004c9a:	8082                	ret

0000000080004c9c <sys_link>:
{
    80004c9c:	7169                	addi	sp,sp,-304
    80004c9e:	f606                	sd	ra,296(sp)
    80004ca0:	f222                	sd	s0,288(sp)
    80004ca2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ca4:	08000613          	li	a2,128
    80004ca8:	ed040593          	addi	a1,s0,-304
    80004cac:	4501                	li	a0,0
    80004cae:	ffffd097          	auipc	ra,0xffffd
    80004cb2:	786080e7          	jalr	1926(ra) # 80002434 <argstr>
    return -1;
    80004cb6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cb8:	12054663          	bltz	a0,80004de4 <sys_link+0x148>
    80004cbc:	08000613          	li	a2,128
    80004cc0:	f5040593          	addi	a1,s0,-176
    80004cc4:	4505                	li	a0,1
    80004cc6:	ffffd097          	auipc	ra,0xffffd
    80004cca:	76e080e7          	jalr	1902(ra) # 80002434 <argstr>
    return -1;
    80004cce:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cd0:	10054a63          	bltz	a0,80004de4 <sys_link+0x148>
    80004cd4:	ee26                	sd	s1,280(sp)
  begin_op();
    80004cd6:	fffff097          	auipc	ra,0xfffff
    80004cda:	c84080e7          	jalr	-892(ra) # 8000395a <begin_op>
  if((ip = namei(old)) == 0){
    80004cde:	ed040513          	addi	a0,s0,-304
    80004ce2:	fffff097          	auipc	ra,0xfffff
    80004ce6:	a78080e7          	jalr	-1416(ra) # 8000375a <namei>
    80004cea:	84aa                	mv	s1,a0
    80004cec:	c949                	beqz	a0,80004d7e <sys_link+0xe2>
  ilock(ip);
    80004cee:	ffffe097          	auipc	ra,0xffffe
    80004cf2:	29e080e7          	jalr	670(ra) # 80002f8c <ilock>
  if(ip->type == T_DIR){
    80004cf6:	04449703          	lh	a4,68(s1)
    80004cfa:	4785                	li	a5,1
    80004cfc:	08f70863          	beq	a4,a5,80004d8c <sys_link+0xf0>
    80004d00:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004d02:	04a4d783          	lhu	a5,74(s1)
    80004d06:	2785                	addiw	a5,a5,1
    80004d08:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d0c:	8526                	mv	a0,s1
    80004d0e:	ffffe097          	auipc	ra,0xffffe
    80004d12:	1b2080e7          	jalr	434(ra) # 80002ec0 <iupdate>
  iunlock(ip);
    80004d16:	8526                	mv	a0,s1
    80004d18:	ffffe097          	auipc	ra,0xffffe
    80004d1c:	33a080e7          	jalr	826(ra) # 80003052 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004d20:	fd040593          	addi	a1,s0,-48
    80004d24:	f5040513          	addi	a0,s0,-176
    80004d28:	fffff097          	auipc	ra,0xfffff
    80004d2c:	a50080e7          	jalr	-1456(ra) # 80003778 <nameiparent>
    80004d30:	892a                	mv	s2,a0
    80004d32:	cd35                	beqz	a0,80004dae <sys_link+0x112>
  ilock(dp);
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	258080e7          	jalr	600(ra) # 80002f8c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004d3c:	00092703          	lw	a4,0(s2)
    80004d40:	409c                	lw	a5,0(s1)
    80004d42:	06f71163          	bne	a4,a5,80004da4 <sys_link+0x108>
    80004d46:	40d0                	lw	a2,4(s1)
    80004d48:	fd040593          	addi	a1,s0,-48
    80004d4c:	854a                	mv	a0,s2
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	95a080e7          	jalr	-1702(ra) # 800036a8 <dirlink>
    80004d56:	04054763          	bltz	a0,80004da4 <sys_link+0x108>
  iunlockput(dp);
    80004d5a:	854a                	mv	a0,s2
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	496080e7          	jalr	1174(ra) # 800031f2 <iunlockput>
  iput(ip);
    80004d64:	8526                	mv	a0,s1
    80004d66:	ffffe097          	auipc	ra,0xffffe
    80004d6a:	3e4080e7          	jalr	996(ra) # 8000314a <iput>
  end_op();
    80004d6e:	fffff097          	auipc	ra,0xfffff
    80004d72:	c66080e7          	jalr	-922(ra) # 800039d4 <end_op>
  return 0;
    80004d76:	4781                	li	a5,0
    80004d78:	64f2                	ld	s1,280(sp)
    80004d7a:	6952                	ld	s2,272(sp)
    80004d7c:	a0a5                	j	80004de4 <sys_link+0x148>
    end_op();
    80004d7e:	fffff097          	auipc	ra,0xfffff
    80004d82:	c56080e7          	jalr	-938(ra) # 800039d4 <end_op>
    return -1;
    80004d86:	57fd                	li	a5,-1
    80004d88:	64f2                	ld	s1,280(sp)
    80004d8a:	a8a9                	j	80004de4 <sys_link+0x148>
    iunlockput(ip);
    80004d8c:	8526                	mv	a0,s1
    80004d8e:	ffffe097          	auipc	ra,0xffffe
    80004d92:	464080e7          	jalr	1124(ra) # 800031f2 <iunlockput>
    end_op();
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	c3e080e7          	jalr	-962(ra) # 800039d4 <end_op>
    return -1;
    80004d9e:	57fd                	li	a5,-1
    80004da0:	64f2                	ld	s1,280(sp)
    80004da2:	a089                	j	80004de4 <sys_link+0x148>
    iunlockput(dp);
    80004da4:	854a                	mv	a0,s2
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	44c080e7          	jalr	1100(ra) # 800031f2 <iunlockput>
  ilock(ip);
    80004dae:	8526                	mv	a0,s1
    80004db0:	ffffe097          	auipc	ra,0xffffe
    80004db4:	1dc080e7          	jalr	476(ra) # 80002f8c <ilock>
  ip->nlink--;
    80004db8:	04a4d783          	lhu	a5,74(s1)
    80004dbc:	37fd                	addiw	a5,a5,-1
    80004dbe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004dc2:	8526                	mv	a0,s1
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	0fc080e7          	jalr	252(ra) # 80002ec0 <iupdate>
  iunlockput(ip);
    80004dcc:	8526                	mv	a0,s1
    80004dce:	ffffe097          	auipc	ra,0xffffe
    80004dd2:	424080e7          	jalr	1060(ra) # 800031f2 <iunlockput>
  end_op();
    80004dd6:	fffff097          	auipc	ra,0xfffff
    80004dda:	bfe080e7          	jalr	-1026(ra) # 800039d4 <end_op>
  return -1;
    80004dde:	57fd                	li	a5,-1
    80004de0:	64f2                	ld	s1,280(sp)
    80004de2:	6952                	ld	s2,272(sp)
}
    80004de4:	853e                	mv	a0,a5
    80004de6:	70b2                	ld	ra,296(sp)
    80004de8:	7412                	ld	s0,288(sp)
    80004dea:	6155                	addi	sp,sp,304
    80004dec:	8082                	ret

0000000080004dee <sys_unlink>:
{
    80004dee:	7151                	addi	sp,sp,-240
    80004df0:	f586                	sd	ra,232(sp)
    80004df2:	f1a2                	sd	s0,224(sp)
    80004df4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004df6:	08000613          	li	a2,128
    80004dfa:	f3040593          	addi	a1,s0,-208
    80004dfe:	4501                	li	a0,0
    80004e00:	ffffd097          	auipc	ra,0xffffd
    80004e04:	634080e7          	jalr	1588(ra) # 80002434 <argstr>
    80004e08:	1a054a63          	bltz	a0,80004fbc <sys_unlink+0x1ce>
    80004e0c:	eda6                	sd	s1,216(sp)
  begin_op();
    80004e0e:	fffff097          	auipc	ra,0xfffff
    80004e12:	b4c080e7          	jalr	-1204(ra) # 8000395a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004e16:	fb040593          	addi	a1,s0,-80
    80004e1a:	f3040513          	addi	a0,s0,-208
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	95a080e7          	jalr	-1702(ra) # 80003778 <nameiparent>
    80004e26:	84aa                	mv	s1,a0
    80004e28:	cd71                	beqz	a0,80004f04 <sys_unlink+0x116>
  ilock(dp);
    80004e2a:	ffffe097          	auipc	ra,0xffffe
    80004e2e:	162080e7          	jalr	354(ra) # 80002f8c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004e32:	00003597          	auipc	a1,0x3
    80004e36:	7be58593          	addi	a1,a1,1982 # 800085f0 <etext+0x5f0>
    80004e3a:	fb040513          	addi	a0,s0,-80
    80004e3e:	ffffe097          	auipc	ra,0xffffe
    80004e42:	640080e7          	jalr	1600(ra) # 8000347e <namecmp>
    80004e46:	14050c63          	beqz	a0,80004f9e <sys_unlink+0x1b0>
    80004e4a:	00003597          	auipc	a1,0x3
    80004e4e:	7ae58593          	addi	a1,a1,1966 # 800085f8 <etext+0x5f8>
    80004e52:	fb040513          	addi	a0,s0,-80
    80004e56:	ffffe097          	auipc	ra,0xffffe
    80004e5a:	628080e7          	jalr	1576(ra) # 8000347e <namecmp>
    80004e5e:	14050063          	beqz	a0,80004f9e <sys_unlink+0x1b0>
    80004e62:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004e64:	f2c40613          	addi	a2,s0,-212
    80004e68:	fb040593          	addi	a1,s0,-80
    80004e6c:	8526                	mv	a0,s1
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	62a080e7          	jalr	1578(ra) # 80003498 <dirlookup>
    80004e76:	892a                	mv	s2,a0
    80004e78:	12050263          	beqz	a0,80004f9c <sys_unlink+0x1ae>
  ilock(ip);
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	110080e7          	jalr	272(ra) # 80002f8c <ilock>
  if(ip->nlink < 1)
    80004e84:	04a91783          	lh	a5,74(s2)
    80004e88:	08f05563          	blez	a5,80004f12 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004e8c:	04491703          	lh	a4,68(s2)
    80004e90:	4785                	li	a5,1
    80004e92:	08f70963          	beq	a4,a5,80004f24 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004e96:	4641                	li	a2,16
    80004e98:	4581                	li	a1,0
    80004e9a:	fc040513          	addi	a0,s0,-64
    80004e9e:	ffffb097          	auipc	ra,0xffffb
    80004ea2:	40c080e7          	jalr	1036(ra) # 800002aa <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ea6:	4741                	li	a4,16
    80004ea8:	f2c42683          	lw	a3,-212(s0)
    80004eac:	fc040613          	addi	a2,s0,-64
    80004eb0:	4581                	li	a1,0
    80004eb2:	8526                	mv	a0,s1
    80004eb4:	ffffe097          	auipc	ra,0xffffe
    80004eb8:	4a0080e7          	jalr	1184(ra) # 80003354 <writei>
    80004ebc:	47c1                	li	a5,16
    80004ebe:	0af51b63          	bne	a0,a5,80004f74 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004ec2:	04491703          	lh	a4,68(s2)
    80004ec6:	4785                	li	a5,1
    80004ec8:	0af70f63          	beq	a4,a5,80004f86 <sys_unlink+0x198>
  iunlockput(dp);
    80004ecc:	8526                	mv	a0,s1
    80004ece:	ffffe097          	auipc	ra,0xffffe
    80004ed2:	324080e7          	jalr	804(ra) # 800031f2 <iunlockput>
  ip->nlink--;
    80004ed6:	04a95783          	lhu	a5,74(s2)
    80004eda:	37fd                	addiw	a5,a5,-1
    80004edc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ee0:	854a                	mv	a0,s2
    80004ee2:	ffffe097          	auipc	ra,0xffffe
    80004ee6:	fde080e7          	jalr	-34(ra) # 80002ec0 <iupdate>
  iunlockput(ip);
    80004eea:	854a                	mv	a0,s2
    80004eec:	ffffe097          	auipc	ra,0xffffe
    80004ef0:	306080e7          	jalr	774(ra) # 800031f2 <iunlockput>
  end_op();
    80004ef4:	fffff097          	auipc	ra,0xfffff
    80004ef8:	ae0080e7          	jalr	-1312(ra) # 800039d4 <end_op>
  return 0;
    80004efc:	4501                	li	a0,0
    80004efe:	64ee                	ld	s1,216(sp)
    80004f00:	694e                	ld	s2,208(sp)
    80004f02:	a84d                	j	80004fb4 <sys_unlink+0x1c6>
    end_op();
    80004f04:	fffff097          	auipc	ra,0xfffff
    80004f08:	ad0080e7          	jalr	-1328(ra) # 800039d4 <end_op>
    return -1;
    80004f0c:	557d                	li	a0,-1
    80004f0e:	64ee                	ld	s1,216(sp)
    80004f10:	a055                	j	80004fb4 <sys_unlink+0x1c6>
    80004f12:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004f14:	00003517          	auipc	a0,0x3
    80004f18:	6ec50513          	addi	a0,a0,1772 # 80008600 <etext+0x600>
    80004f1c:	00001097          	auipc	ra,0x1
    80004f20:	236080e7          	jalr	566(ra) # 80006152 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004f24:	04c92703          	lw	a4,76(s2)
    80004f28:	02000793          	li	a5,32
    80004f2c:	f6e7f5e3          	bgeu	a5,a4,80004e96 <sys_unlink+0xa8>
    80004f30:	e5ce                	sd	s3,200(sp)
    80004f32:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f36:	4741                	li	a4,16
    80004f38:	86ce                	mv	a3,s3
    80004f3a:	f1840613          	addi	a2,s0,-232
    80004f3e:	4581                	li	a1,0
    80004f40:	854a                	mv	a0,s2
    80004f42:	ffffe097          	auipc	ra,0xffffe
    80004f46:	302080e7          	jalr	770(ra) # 80003244 <readi>
    80004f4a:	47c1                	li	a5,16
    80004f4c:	00f51c63          	bne	a0,a5,80004f64 <sys_unlink+0x176>
    if(de.inum != 0)
    80004f50:	f1845783          	lhu	a5,-232(s0)
    80004f54:	e7b5                	bnez	a5,80004fc0 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004f56:	29c1                	addiw	s3,s3,16
    80004f58:	04c92783          	lw	a5,76(s2)
    80004f5c:	fcf9ede3          	bltu	s3,a5,80004f36 <sys_unlink+0x148>
    80004f60:	69ae                	ld	s3,200(sp)
    80004f62:	bf15                	j	80004e96 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004f64:	00003517          	auipc	a0,0x3
    80004f68:	6b450513          	addi	a0,a0,1716 # 80008618 <etext+0x618>
    80004f6c:	00001097          	auipc	ra,0x1
    80004f70:	1e6080e7          	jalr	486(ra) # 80006152 <panic>
    80004f74:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004f76:	00003517          	auipc	a0,0x3
    80004f7a:	6ba50513          	addi	a0,a0,1722 # 80008630 <etext+0x630>
    80004f7e:	00001097          	auipc	ra,0x1
    80004f82:	1d4080e7          	jalr	468(ra) # 80006152 <panic>
    dp->nlink--;
    80004f86:	04a4d783          	lhu	a5,74(s1)
    80004f8a:	37fd                	addiw	a5,a5,-1
    80004f8c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004f90:	8526                	mv	a0,s1
    80004f92:	ffffe097          	auipc	ra,0xffffe
    80004f96:	f2e080e7          	jalr	-210(ra) # 80002ec0 <iupdate>
    80004f9a:	bf0d                	j	80004ecc <sys_unlink+0xde>
    80004f9c:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004f9e:	8526                	mv	a0,s1
    80004fa0:	ffffe097          	auipc	ra,0xffffe
    80004fa4:	252080e7          	jalr	594(ra) # 800031f2 <iunlockput>
  end_op();
    80004fa8:	fffff097          	auipc	ra,0xfffff
    80004fac:	a2c080e7          	jalr	-1492(ra) # 800039d4 <end_op>
  return -1;
    80004fb0:	557d                	li	a0,-1
    80004fb2:	64ee                	ld	s1,216(sp)
}
    80004fb4:	70ae                	ld	ra,232(sp)
    80004fb6:	740e                	ld	s0,224(sp)
    80004fb8:	616d                	addi	sp,sp,240
    80004fba:	8082                	ret
    return -1;
    80004fbc:	557d                	li	a0,-1
    80004fbe:	bfdd                	j	80004fb4 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004fc0:	854a                	mv	a0,s2
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	230080e7          	jalr	560(ra) # 800031f2 <iunlockput>
    goto bad;
    80004fca:	694e                	ld	s2,208(sp)
    80004fcc:	69ae                	ld	s3,200(sp)
    80004fce:	bfc1                	j	80004f9e <sys_unlink+0x1b0>

0000000080004fd0 <sys_open>:

uint64
sys_open(void)
{
    80004fd0:	7131                	addi	sp,sp,-192
    80004fd2:	fd06                	sd	ra,184(sp)
    80004fd4:	f922                	sd	s0,176(sp)
    80004fd6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004fd8:	f4c40593          	addi	a1,s0,-180
    80004fdc:	4505                	li	a0,1
    80004fde:	ffffd097          	auipc	ra,0xffffd
    80004fe2:	416080e7          	jalr	1046(ra) # 800023f4 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004fe6:	08000613          	li	a2,128
    80004fea:	f5040593          	addi	a1,s0,-176
    80004fee:	4501                	li	a0,0
    80004ff0:	ffffd097          	auipc	ra,0xffffd
    80004ff4:	444080e7          	jalr	1092(ra) # 80002434 <argstr>
    80004ff8:	87aa                	mv	a5,a0
    return -1;
    80004ffa:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ffc:	0a07ce63          	bltz	a5,800050b8 <sys_open+0xe8>
    80005000:	f526                	sd	s1,168(sp)

  begin_op();
    80005002:	fffff097          	auipc	ra,0xfffff
    80005006:	958080e7          	jalr	-1704(ra) # 8000395a <begin_op>

  if(omode & O_CREATE){
    8000500a:	f4c42783          	lw	a5,-180(s0)
    8000500e:	2007f793          	andi	a5,a5,512
    80005012:	cfd5                	beqz	a5,800050ce <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005014:	4681                	li	a3,0
    80005016:	4601                	li	a2,0
    80005018:	4589                	li	a1,2
    8000501a:	f5040513          	addi	a0,s0,-176
    8000501e:	00000097          	auipc	ra,0x0
    80005022:	95c080e7          	jalr	-1700(ra) # 8000497a <create>
    80005026:	84aa                	mv	s1,a0
    if(ip == 0){
    80005028:	cd41                	beqz	a0,800050c0 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000502a:	04449703          	lh	a4,68(s1)
    8000502e:	478d                	li	a5,3
    80005030:	00f71763          	bne	a4,a5,8000503e <sys_open+0x6e>
    80005034:	0464d703          	lhu	a4,70(s1)
    80005038:	47a5                	li	a5,9
    8000503a:	0ee7e163          	bltu	a5,a4,8000511c <sys_open+0x14c>
    8000503e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005040:	fffff097          	auipc	ra,0xfffff
    80005044:	d28080e7          	jalr	-728(ra) # 80003d68 <filealloc>
    80005048:	892a                	mv	s2,a0
    8000504a:	c97d                	beqz	a0,80005140 <sys_open+0x170>
    8000504c:	ed4e                	sd	s3,152(sp)
    8000504e:	00000097          	auipc	ra,0x0
    80005052:	8ea080e7          	jalr	-1814(ra) # 80004938 <fdalloc>
    80005056:	89aa                	mv	s3,a0
    80005058:	0c054e63          	bltz	a0,80005134 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000505c:	04449703          	lh	a4,68(s1)
    80005060:	478d                	li	a5,3
    80005062:	0ef70c63          	beq	a4,a5,8000515a <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005066:	4789                	li	a5,2
    80005068:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000506c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005070:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005074:	f4c42783          	lw	a5,-180(s0)
    80005078:	0017c713          	xori	a4,a5,1
    8000507c:	8b05                	andi	a4,a4,1
    8000507e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005082:	0037f713          	andi	a4,a5,3
    80005086:	00e03733          	snez	a4,a4
    8000508a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000508e:	4007f793          	andi	a5,a5,1024
    80005092:	c791                	beqz	a5,8000509e <sys_open+0xce>
    80005094:	04449703          	lh	a4,68(s1)
    80005098:	4789                	li	a5,2
    8000509a:	0cf70763          	beq	a4,a5,80005168 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    8000509e:	8526                	mv	a0,s1
    800050a0:	ffffe097          	auipc	ra,0xffffe
    800050a4:	fb2080e7          	jalr	-78(ra) # 80003052 <iunlock>
  end_op();
    800050a8:	fffff097          	auipc	ra,0xfffff
    800050ac:	92c080e7          	jalr	-1748(ra) # 800039d4 <end_op>

  return fd;
    800050b0:	854e                	mv	a0,s3
    800050b2:	74aa                	ld	s1,168(sp)
    800050b4:	790a                	ld	s2,160(sp)
    800050b6:	69ea                	ld	s3,152(sp)
}
    800050b8:	70ea                	ld	ra,184(sp)
    800050ba:	744a                	ld	s0,176(sp)
    800050bc:	6129                	addi	sp,sp,192
    800050be:	8082                	ret
      end_op();
    800050c0:	fffff097          	auipc	ra,0xfffff
    800050c4:	914080e7          	jalr	-1772(ra) # 800039d4 <end_op>
      return -1;
    800050c8:	557d                	li	a0,-1
    800050ca:	74aa                	ld	s1,168(sp)
    800050cc:	b7f5                	j	800050b8 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    800050ce:	f5040513          	addi	a0,s0,-176
    800050d2:	ffffe097          	auipc	ra,0xffffe
    800050d6:	688080e7          	jalr	1672(ra) # 8000375a <namei>
    800050da:	84aa                	mv	s1,a0
    800050dc:	c90d                	beqz	a0,8000510e <sys_open+0x13e>
    ilock(ip);
    800050de:	ffffe097          	auipc	ra,0xffffe
    800050e2:	eae080e7          	jalr	-338(ra) # 80002f8c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800050e6:	04449703          	lh	a4,68(s1)
    800050ea:	4785                	li	a5,1
    800050ec:	f2f71fe3          	bne	a4,a5,8000502a <sys_open+0x5a>
    800050f0:	f4c42783          	lw	a5,-180(s0)
    800050f4:	d7a9                	beqz	a5,8000503e <sys_open+0x6e>
      iunlockput(ip);
    800050f6:	8526                	mv	a0,s1
    800050f8:	ffffe097          	auipc	ra,0xffffe
    800050fc:	0fa080e7          	jalr	250(ra) # 800031f2 <iunlockput>
      end_op();
    80005100:	fffff097          	auipc	ra,0xfffff
    80005104:	8d4080e7          	jalr	-1836(ra) # 800039d4 <end_op>
      return -1;
    80005108:	557d                	li	a0,-1
    8000510a:	74aa                	ld	s1,168(sp)
    8000510c:	b775                	j	800050b8 <sys_open+0xe8>
      end_op();
    8000510e:	fffff097          	auipc	ra,0xfffff
    80005112:	8c6080e7          	jalr	-1850(ra) # 800039d4 <end_op>
      return -1;
    80005116:	557d                	li	a0,-1
    80005118:	74aa                	ld	s1,168(sp)
    8000511a:	bf79                	j	800050b8 <sys_open+0xe8>
    iunlockput(ip);
    8000511c:	8526                	mv	a0,s1
    8000511e:	ffffe097          	auipc	ra,0xffffe
    80005122:	0d4080e7          	jalr	212(ra) # 800031f2 <iunlockput>
    end_op();
    80005126:	fffff097          	auipc	ra,0xfffff
    8000512a:	8ae080e7          	jalr	-1874(ra) # 800039d4 <end_op>
    return -1;
    8000512e:	557d                	li	a0,-1
    80005130:	74aa                	ld	s1,168(sp)
    80005132:	b759                	j	800050b8 <sys_open+0xe8>
      fileclose(f);
    80005134:	854a                	mv	a0,s2
    80005136:	fffff097          	auipc	ra,0xfffff
    8000513a:	cee080e7          	jalr	-786(ra) # 80003e24 <fileclose>
    8000513e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005140:	8526                	mv	a0,s1
    80005142:	ffffe097          	auipc	ra,0xffffe
    80005146:	0b0080e7          	jalr	176(ra) # 800031f2 <iunlockput>
    end_op();
    8000514a:	fffff097          	auipc	ra,0xfffff
    8000514e:	88a080e7          	jalr	-1910(ra) # 800039d4 <end_op>
    return -1;
    80005152:	557d                	li	a0,-1
    80005154:	74aa                	ld	s1,168(sp)
    80005156:	790a                	ld	s2,160(sp)
    80005158:	b785                	j	800050b8 <sys_open+0xe8>
    f->type = FD_DEVICE;
    8000515a:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000515e:	04649783          	lh	a5,70(s1)
    80005162:	02f91223          	sh	a5,36(s2)
    80005166:	b729                	j	80005070 <sys_open+0xa0>
    itrunc(ip);
    80005168:	8526                	mv	a0,s1
    8000516a:	ffffe097          	auipc	ra,0xffffe
    8000516e:	f34080e7          	jalr	-204(ra) # 8000309e <itrunc>
    80005172:	b735                	j	8000509e <sys_open+0xce>

0000000080005174 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005174:	7175                	addi	sp,sp,-144
    80005176:	e506                	sd	ra,136(sp)
    80005178:	e122                	sd	s0,128(sp)
    8000517a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000517c:	ffffe097          	auipc	ra,0xffffe
    80005180:	7de080e7          	jalr	2014(ra) # 8000395a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005184:	08000613          	li	a2,128
    80005188:	f7040593          	addi	a1,s0,-144
    8000518c:	4501                	li	a0,0
    8000518e:	ffffd097          	auipc	ra,0xffffd
    80005192:	2a6080e7          	jalr	678(ra) # 80002434 <argstr>
    80005196:	02054963          	bltz	a0,800051c8 <sys_mkdir+0x54>
    8000519a:	4681                	li	a3,0
    8000519c:	4601                	li	a2,0
    8000519e:	4585                	li	a1,1
    800051a0:	f7040513          	addi	a0,s0,-144
    800051a4:	fffff097          	auipc	ra,0xfffff
    800051a8:	7d6080e7          	jalr	2006(ra) # 8000497a <create>
    800051ac:	cd11                	beqz	a0,800051c8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800051ae:	ffffe097          	auipc	ra,0xffffe
    800051b2:	044080e7          	jalr	68(ra) # 800031f2 <iunlockput>
  end_op();
    800051b6:	fffff097          	auipc	ra,0xfffff
    800051ba:	81e080e7          	jalr	-2018(ra) # 800039d4 <end_op>
  return 0;
    800051be:	4501                	li	a0,0
}
    800051c0:	60aa                	ld	ra,136(sp)
    800051c2:	640a                	ld	s0,128(sp)
    800051c4:	6149                	addi	sp,sp,144
    800051c6:	8082                	ret
    end_op();
    800051c8:	fffff097          	auipc	ra,0xfffff
    800051cc:	80c080e7          	jalr	-2036(ra) # 800039d4 <end_op>
    return -1;
    800051d0:	557d                	li	a0,-1
    800051d2:	b7fd                	j	800051c0 <sys_mkdir+0x4c>

00000000800051d4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800051d4:	7135                	addi	sp,sp,-160
    800051d6:	ed06                	sd	ra,152(sp)
    800051d8:	e922                	sd	s0,144(sp)
    800051da:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800051dc:	ffffe097          	auipc	ra,0xffffe
    800051e0:	77e080e7          	jalr	1918(ra) # 8000395a <begin_op>
  argint(1, &major);
    800051e4:	f6c40593          	addi	a1,s0,-148
    800051e8:	4505                	li	a0,1
    800051ea:	ffffd097          	auipc	ra,0xffffd
    800051ee:	20a080e7          	jalr	522(ra) # 800023f4 <argint>
  argint(2, &minor);
    800051f2:	f6840593          	addi	a1,s0,-152
    800051f6:	4509                	li	a0,2
    800051f8:	ffffd097          	auipc	ra,0xffffd
    800051fc:	1fc080e7          	jalr	508(ra) # 800023f4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005200:	08000613          	li	a2,128
    80005204:	f7040593          	addi	a1,s0,-144
    80005208:	4501                	li	a0,0
    8000520a:	ffffd097          	auipc	ra,0xffffd
    8000520e:	22a080e7          	jalr	554(ra) # 80002434 <argstr>
    80005212:	02054b63          	bltz	a0,80005248 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005216:	f6841683          	lh	a3,-152(s0)
    8000521a:	f6c41603          	lh	a2,-148(s0)
    8000521e:	458d                	li	a1,3
    80005220:	f7040513          	addi	a0,s0,-144
    80005224:	fffff097          	auipc	ra,0xfffff
    80005228:	756080e7          	jalr	1878(ra) # 8000497a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000522c:	cd11                	beqz	a0,80005248 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000522e:	ffffe097          	auipc	ra,0xffffe
    80005232:	fc4080e7          	jalr	-60(ra) # 800031f2 <iunlockput>
  end_op();
    80005236:	ffffe097          	auipc	ra,0xffffe
    8000523a:	79e080e7          	jalr	1950(ra) # 800039d4 <end_op>
  return 0;
    8000523e:	4501                	li	a0,0
}
    80005240:	60ea                	ld	ra,152(sp)
    80005242:	644a                	ld	s0,144(sp)
    80005244:	610d                	addi	sp,sp,160
    80005246:	8082                	ret
    end_op();
    80005248:	ffffe097          	auipc	ra,0xffffe
    8000524c:	78c080e7          	jalr	1932(ra) # 800039d4 <end_op>
    return -1;
    80005250:	557d                	li	a0,-1
    80005252:	b7fd                	j	80005240 <sys_mknod+0x6c>

0000000080005254 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005254:	7135                	addi	sp,sp,-160
    80005256:	ed06                	sd	ra,152(sp)
    80005258:	e922                	sd	s0,144(sp)
    8000525a:	e14a                	sd	s2,128(sp)
    8000525c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000525e:	ffffc097          	auipc	ra,0xffffc
    80005262:	f32080e7          	jalr	-206(ra) # 80001190 <myproc>
    80005266:	892a                	mv	s2,a0
  
  begin_op();
    80005268:	ffffe097          	auipc	ra,0xffffe
    8000526c:	6f2080e7          	jalr	1778(ra) # 8000395a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005270:	08000613          	li	a2,128
    80005274:	f6040593          	addi	a1,s0,-160
    80005278:	4501                	li	a0,0
    8000527a:	ffffd097          	auipc	ra,0xffffd
    8000527e:	1ba080e7          	jalr	442(ra) # 80002434 <argstr>
    80005282:	04054d63          	bltz	a0,800052dc <sys_chdir+0x88>
    80005286:	e526                	sd	s1,136(sp)
    80005288:	f6040513          	addi	a0,s0,-160
    8000528c:	ffffe097          	auipc	ra,0xffffe
    80005290:	4ce080e7          	jalr	1230(ra) # 8000375a <namei>
    80005294:	84aa                	mv	s1,a0
    80005296:	c131                	beqz	a0,800052da <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005298:	ffffe097          	auipc	ra,0xffffe
    8000529c:	cf4080e7          	jalr	-780(ra) # 80002f8c <ilock>
  if(ip->type != T_DIR){
    800052a0:	04449703          	lh	a4,68(s1)
    800052a4:	4785                	li	a5,1
    800052a6:	04f71163          	bne	a4,a5,800052e8 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800052aa:	8526                	mv	a0,s1
    800052ac:	ffffe097          	auipc	ra,0xffffe
    800052b0:	da6080e7          	jalr	-602(ra) # 80003052 <iunlock>
  iput(p->cwd);
    800052b4:	15093503          	ld	a0,336(s2)
    800052b8:	ffffe097          	auipc	ra,0xffffe
    800052bc:	e92080e7          	jalr	-366(ra) # 8000314a <iput>
  end_op();
    800052c0:	ffffe097          	auipc	ra,0xffffe
    800052c4:	714080e7          	jalr	1812(ra) # 800039d4 <end_op>
  p->cwd = ip;
    800052c8:	14993823          	sd	s1,336(s2)
  return 0;
    800052cc:	4501                	li	a0,0
    800052ce:	64aa                	ld	s1,136(sp)
}
    800052d0:	60ea                	ld	ra,152(sp)
    800052d2:	644a                	ld	s0,144(sp)
    800052d4:	690a                	ld	s2,128(sp)
    800052d6:	610d                	addi	sp,sp,160
    800052d8:	8082                	ret
    800052da:	64aa                	ld	s1,136(sp)
    end_op();
    800052dc:	ffffe097          	auipc	ra,0xffffe
    800052e0:	6f8080e7          	jalr	1784(ra) # 800039d4 <end_op>
    return -1;
    800052e4:	557d                	li	a0,-1
    800052e6:	b7ed                	j	800052d0 <sys_chdir+0x7c>
    iunlockput(ip);
    800052e8:	8526                	mv	a0,s1
    800052ea:	ffffe097          	auipc	ra,0xffffe
    800052ee:	f08080e7          	jalr	-248(ra) # 800031f2 <iunlockput>
    end_op();
    800052f2:	ffffe097          	auipc	ra,0xffffe
    800052f6:	6e2080e7          	jalr	1762(ra) # 800039d4 <end_op>
    return -1;
    800052fa:	557d                	li	a0,-1
    800052fc:	64aa                	ld	s1,136(sp)
    800052fe:	bfc9                	j	800052d0 <sys_chdir+0x7c>

0000000080005300 <sys_exec>:

uint64
sys_exec(void)
{
    80005300:	7121                	addi	sp,sp,-448
    80005302:	ff06                	sd	ra,440(sp)
    80005304:	fb22                	sd	s0,432(sp)
    80005306:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005308:	e4840593          	addi	a1,s0,-440
    8000530c:	4505                	li	a0,1
    8000530e:	ffffd097          	auipc	ra,0xffffd
    80005312:	106080e7          	jalr	262(ra) # 80002414 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005316:	08000613          	li	a2,128
    8000531a:	f5040593          	addi	a1,s0,-176
    8000531e:	4501                	li	a0,0
    80005320:	ffffd097          	auipc	ra,0xffffd
    80005324:	114080e7          	jalr	276(ra) # 80002434 <argstr>
    80005328:	87aa                	mv	a5,a0
    return -1;
    8000532a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000532c:	0e07c263          	bltz	a5,80005410 <sys_exec+0x110>
    80005330:	f726                	sd	s1,424(sp)
    80005332:	f34a                	sd	s2,416(sp)
    80005334:	ef4e                	sd	s3,408(sp)
    80005336:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005338:	10000613          	li	a2,256
    8000533c:	4581                	li	a1,0
    8000533e:	e5040513          	addi	a0,s0,-432
    80005342:	ffffb097          	auipc	ra,0xffffb
    80005346:	f68080e7          	jalr	-152(ra) # 800002aa <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000534a:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000534e:	89a6                	mv	s3,s1
    80005350:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005352:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005356:	00391513          	slli	a0,s2,0x3
    8000535a:	e4040593          	addi	a1,s0,-448
    8000535e:	e4843783          	ld	a5,-440(s0)
    80005362:	953e                	add	a0,a0,a5
    80005364:	ffffd097          	auipc	ra,0xffffd
    80005368:	ff2080e7          	jalr	-14(ra) # 80002356 <fetchaddr>
    8000536c:	02054a63          	bltz	a0,800053a0 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005370:	e4043783          	ld	a5,-448(s0)
    80005374:	c7b9                	beqz	a5,800053c2 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005376:	ffffb097          	auipc	ra,0xffffb
    8000537a:	e0a080e7          	jalr	-502(ra) # 80000180 <kalloc>
    8000537e:	85aa                	mv	a1,a0
    80005380:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005384:	cd11                	beqz	a0,800053a0 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005386:	6605                	lui	a2,0x1
    80005388:	e4043503          	ld	a0,-448(s0)
    8000538c:	ffffd097          	auipc	ra,0xffffd
    80005390:	01c080e7          	jalr	28(ra) # 800023a8 <fetchstr>
    80005394:	00054663          	bltz	a0,800053a0 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005398:	0905                	addi	s2,s2,1
    8000539a:	09a1                	addi	s3,s3,8
    8000539c:	fb491de3          	bne	s2,s4,80005356 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053a0:	f5040913          	addi	s2,s0,-176
    800053a4:	6088                	ld	a0,0(s1)
    800053a6:	c125                	beqz	a0,80005406 <sys_exec+0x106>
    kfree(argv[i]);
    800053a8:	ffffb097          	auipc	ra,0xffffb
    800053ac:	c74080e7          	jalr	-908(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053b0:	04a1                	addi	s1,s1,8
    800053b2:	ff2499e3          	bne	s1,s2,800053a4 <sys_exec+0xa4>
  return -1;
    800053b6:	557d                	li	a0,-1
    800053b8:	74ba                	ld	s1,424(sp)
    800053ba:	791a                	ld	s2,416(sp)
    800053bc:	69fa                	ld	s3,408(sp)
    800053be:	6a5a                	ld	s4,400(sp)
    800053c0:	a881                	j	80005410 <sys_exec+0x110>
      argv[i] = 0;
    800053c2:	0009079b          	sext.w	a5,s2
    800053c6:	078e                	slli	a5,a5,0x3
    800053c8:	fd078793          	addi	a5,a5,-48
    800053cc:	97a2                	add	a5,a5,s0
    800053ce:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800053d2:	e5040593          	addi	a1,s0,-432
    800053d6:	f5040513          	addi	a0,s0,-176
    800053da:	fffff097          	auipc	ra,0xfffff
    800053de:	120080e7          	jalr	288(ra) # 800044fa <exec>
    800053e2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053e4:	f5040993          	addi	s3,s0,-176
    800053e8:	6088                	ld	a0,0(s1)
    800053ea:	c901                	beqz	a0,800053fa <sys_exec+0xfa>
    kfree(argv[i]);
    800053ec:	ffffb097          	auipc	ra,0xffffb
    800053f0:	c30080e7          	jalr	-976(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053f4:	04a1                	addi	s1,s1,8
    800053f6:	ff3499e3          	bne	s1,s3,800053e8 <sys_exec+0xe8>
  return ret;
    800053fa:	854a                	mv	a0,s2
    800053fc:	74ba                	ld	s1,424(sp)
    800053fe:	791a                	ld	s2,416(sp)
    80005400:	69fa                	ld	s3,408(sp)
    80005402:	6a5a                	ld	s4,400(sp)
    80005404:	a031                	j	80005410 <sys_exec+0x110>
  return -1;
    80005406:	557d                	li	a0,-1
    80005408:	74ba                	ld	s1,424(sp)
    8000540a:	791a                	ld	s2,416(sp)
    8000540c:	69fa                	ld	s3,408(sp)
    8000540e:	6a5a                	ld	s4,400(sp)
}
    80005410:	70fa                	ld	ra,440(sp)
    80005412:	745a                	ld	s0,432(sp)
    80005414:	6139                	addi	sp,sp,448
    80005416:	8082                	ret

0000000080005418 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005418:	7139                	addi	sp,sp,-64
    8000541a:	fc06                	sd	ra,56(sp)
    8000541c:	f822                	sd	s0,48(sp)
    8000541e:	f426                	sd	s1,40(sp)
    80005420:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005422:	ffffc097          	auipc	ra,0xffffc
    80005426:	d6e080e7          	jalr	-658(ra) # 80001190 <myproc>
    8000542a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000542c:	fd840593          	addi	a1,s0,-40
    80005430:	4501                	li	a0,0
    80005432:	ffffd097          	auipc	ra,0xffffd
    80005436:	fe2080e7          	jalr	-30(ra) # 80002414 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000543a:	fc840593          	addi	a1,s0,-56
    8000543e:	fd040513          	addi	a0,s0,-48
    80005442:	fffff097          	auipc	ra,0xfffff
    80005446:	d50080e7          	jalr	-688(ra) # 80004192 <pipealloc>
    return -1;
    8000544a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000544c:	0c054463          	bltz	a0,80005514 <sys_pipe+0xfc>
  fd0 = -1;
    80005450:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005454:	fd043503          	ld	a0,-48(s0)
    80005458:	fffff097          	auipc	ra,0xfffff
    8000545c:	4e0080e7          	jalr	1248(ra) # 80004938 <fdalloc>
    80005460:	fca42223          	sw	a0,-60(s0)
    80005464:	08054b63          	bltz	a0,800054fa <sys_pipe+0xe2>
    80005468:	fc843503          	ld	a0,-56(s0)
    8000546c:	fffff097          	auipc	ra,0xfffff
    80005470:	4cc080e7          	jalr	1228(ra) # 80004938 <fdalloc>
    80005474:	fca42023          	sw	a0,-64(s0)
    80005478:	06054863          	bltz	a0,800054e8 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000547c:	4691                	li	a3,4
    8000547e:	fc440613          	addi	a2,s0,-60
    80005482:	fd843583          	ld	a1,-40(s0)
    80005486:	68a8                	ld	a0,80(s1)
    80005488:	ffffc097          	auipc	ra,0xffffc
    8000548c:	912080e7          	jalr	-1774(ra) # 80000d9a <copyout>
    80005490:	02054063          	bltz	a0,800054b0 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005494:	4691                	li	a3,4
    80005496:	fc040613          	addi	a2,s0,-64
    8000549a:	fd843583          	ld	a1,-40(s0)
    8000549e:	0591                	addi	a1,a1,4
    800054a0:	68a8                	ld	a0,80(s1)
    800054a2:	ffffc097          	auipc	ra,0xffffc
    800054a6:	8f8080e7          	jalr	-1800(ra) # 80000d9a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800054aa:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800054ac:	06055463          	bgez	a0,80005514 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800054b0:	fc442783          	lw	a5,-60(s0)
    800054b4:	07e9                	addi	a5,a5,26
    800054b6:	078e                	slli	a5,a5,0x3
    800054b8:	97a6                	add	a5,a5,s1
    800054ba:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800054be:	fc042783          	lw	a5,-64(s0)
    800054c2:	07e9                	addi	a5,a5,26
    800054c4:	078e                	slli	a5,a5,0x3
    800054c6:	94be                	add	s1,s1,a5
    800054c8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800054cc:	fd043503          	ld	a0,-48(s0)
    800054d0:	fffff097          	auipc	ra,0xfffff
    800054d4:	954080e7          	jalr	-1708(ra) # 80003e24 <fileclose>
    fileclose(wf);
    800054d8:	fc843503          	ld	a0,-56(s0)
    800054dc:	fffff097          	auipc	ra,0xfffff
    800054e0:	948080e7          	jalr	-1720(ra) # 80003e24 <fileclose>
    return -1;
    800054e4:	57fd                	li	a5,-1
    800054e6:	a03d                	j	80005514 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800054e8:	fc442783          	lw	a5,-60(s0)
    800054ec:	0007c763          	bltz	a5,800054fa <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800054f0:	07e9                	addi	a5,a5,26
    800054f2:	078e                	slli	a5,a5,0x3
    800054f4:	97a6                	add	a5,a5,s1
    800054f6:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800054fa:	fd043503          	ld	a0,-48(s0)
    800054fe:	fffff097          	auipc	ra,0xfffff
    80005502:	926080e7          	jalr	-1754(ra) # 80003e24 <fileclose>
    fileclose(wf);
    80005506:	fc843503          	ld	a0,-56(s0)
    8000550a:	fffff097          	auipc	ra,0xfffff
    8000550e:	91a080e7          	jalr	-1766(ra) # 80003e24 <fileclose>
    return -1;
    80005512:	57fd                	li	a5,-1
}
    80005514:	853e                	mv	a0,a5
    80005516:	70e2                	ld	ra,56(sp)
    80005518:	7442                	ld	s0,48(sp)
    8000551a:	74a2                	ld	s1,40(sp)
    8000551c:	6121                	addi	sp,sp,64
    8000551e:	8082                	ret

0000000080005520 <kernelvec>:
    80005520:	7111                	addi	sp,sp,-256
    80005522:	e006                	sd	ra,0(sp)
    80005524:	e40a                	sd	sp,8(sp)
    80005526:	e80e                	sd	gp,16(sp)
    80005528:	ec12                	sd	tp,24(sp)
    8000552a:	f016                	sd	t0,32(sp)
    8000552c:	f41a                	sd	t1,40(sp)
    8000552e:	f81e                	sd	t2,48(sp)
    80005530:	fc22                	sd	s0,56(sp)
    80005532:	e0a6                	sd	s1,64(sp)
    80005534:	e4aa                	sd	a0,72(sp)
    80005536:	e8ae                	sd	a1,80(sp)
    80005538:	ecb2                	sd	a2,88(sp)
    8000553a:	f0b6                	sd	a3,96(sp)
    8000553c:	f4ba                	sd	a4,104(sp)
    8000553e:	f8be                	sd	a5,112(sp)
    80005540:	fcc2                	sd	a6,120(sp)
    80005542:	e146                	sd	a7,128(sp)
    80005544:	e54a                	sd	s2,136(sp)
    80005546:	e94e                	sd	s3,144(sp)
    80005548:	ed52                	sd	s4,152(sp)
    8000554a:	f156                	sd	s5,160(sp)
    8000554c:	f55a                	sd	s6,168(sp)
    8000554e:	f95e                	sd	s7,176(sp)
    80005550:	fd62                	sd	s8,184(sp)
    80005552:	e1e6                	sd	s9,192(sp)
    80005554:	e5ea                	sd	s10,200(sp)
    80005556:	e9ee                	sd	s11,208(sp)
    80005558:	edf2                	sd	t3,216(sp)
    8000555a:	f1f6                	sd	t4,224(sp)
    8000555c:	f5fa                	sd	t5,232(sp)
    8000555e:	f9fe                	sd	t6,240(sp)
    80005560:	cc3fc0ef          	jal	80002222 <kerneltrap>
    80005564:	6082                	ld	ra,0(sp)
    80005566:	6122                	ld	sp,8(sp)
    80005568:	61c2                	ld	gp,16(sp)
    8000556a:	7282                	ld	t0,32(sp)
    8000556c:	7322                	ld	t1,40(sp)
    8000556e:	73c2                	ld	t2,48(sp)
    80005570:	7462                	ld	s0,56(sp)
    80005572:	6486                	ld	s1,64(sp)
    80005574:	6526                	ld	a0,72(sp)
    80005576:	65c6                	ld	a1,80(sp)
    80005578:	6666                	ld	a2,88(sp)
    8000557a:	7686                	ld	a3,96(sp)
    8000557c:	7726                	ld	a4,104(sp)
    8000557e:	77c6                	ld	a5,112(sp)
    80005580:	7866                	ld	a6,120(sp)
    80005582:	688a                	ld	a7,128(sp)
    80005584:	692a                	ld	s2,136(sp)
    80005586:	69ca                	ld	s3,144(sp)
    80005588:	6a6a                	ld	s4,152(sp)
    8000558a:	7a8a                	ld	s5,160(sp)
    8000558c:	7b2a                	ld	s6,168(sp)
    8000558e:	7bca                	ld	s7,176(sp)
    80005590:	7c6a                	ld	s8,184(sp)
    80005592:	6c8e                	ld	s9,192(sp)
    80005594:	6d2e                	ld	s10,200(sp)
    80005596:	6dce                	ld	s11,208(sp)
    80005598:	6e6e                	ld	t3,216(sp)
    8000559a:	7e8e                	ld	t4,224(sp)
    8000559c:	7f2e                	ld	t5,232(sp)
    8000559e:	7fce                	ld	t6,240(sp)
    800055a0:	6111                	addi	sp,sp,256
    800055a2:	10200073          	sret
    800055a6:	00000013          	nop
    800055aa:	00000013          	nop
    800055ae:	0001                	nop

00000000800055b0 <timervec>:
    800055b0:	34051573          	csrrw	a0,mscratch,a0
    800055b4:	e10c                	sd	a1,0(a0)
    800055b6:	e510                	sd	a2,8(a0)
    800055b8:	e914                	sd	a3,16(a0)
    800055ba:	6d0c                	ld	a1,24(a0)
    800055bc:	7110                	ld	a2,32(a0)
    800055be:	6194                	ld	a3,0(a1)
    800055c0:	96b2                	add	a3,a3,a2
    800055c2:	e194                	sd	a3,0(a1)
    800055c4:	4589                	li	a1,2
    800055c6:	14459073          	csrw	sip,a1
    800055ca:	6914                	ld	a3,16(a0)
    800055cc:	6510                	ld	a2,8(a0)
    800055ce:	610c                	ld	a1,0(a0)
    800055d0:	34051573          	csrrw	a0,mscratch,a0
    800055d4:	30200073          	mret
	...

00000000800055da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800055da:	1141                	addi	sp,sp,-16
    800055dc:	e422                	sd	s0,8(sp)
    800055de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800055e0:	0c0007b7          	lui	a5,0xc000
    800055e4:	4705                	li	a4,1
    800055e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800055e8:	0c0007b7          	lui	a5,0xc000
    800055ec:	c3d8                	sw	a4,4(a5)
}
    800055ee:	6422                	ld	s0,8(sp)
    800055f0:	0141                	addi	sp,sp,16
    800055f2:	8082                	ret

00000000800055f4 <plicinithart>:

void
plicinithart(void)
{
    800055f4:	1141                	addi	sp,sp,-16
    800055f6:	e406                	sd	ra,8(sp)
    800055f8:	e022                	sd	s0,0(sp)
    800055fa:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800055fc:	ffffc097          	auipc	ra,0xffffc
    80005600:	b68080e7          	jalr	-1176(ra) # 80001164 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005604:	0085171b          	slliw	a4,a0,0x8
    80005608:	0c0027b7          	lui	a5,0xc002
    8000560c:	97ba                	add	a5,a5,a4
    8000560e:	40200713          	li	a4,1026
    80005612:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005616:	00d5151b          	slliw	a0,a0,0xd
    8000561a:	0c2017b7          	lui	a5,0xc201
    8000561e:	97aa                	add	a5,a5,a0
    80005620:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005624:	60a2                	ld	ra,8(sp)
    80005626:	6402                	ld	s0,0(sp)
    80005628:	0141                	addi	sp,sp,16
    8000562a:	8082                	ret

000000008000562c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000562c:	1141                	addi	sp,sp,-16
    8000562e:	e406                	sd	ra,8(sp)
    80005630:	e022                	sd	s0,0(sp)
    80005632:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005634:	ffffc097          	auipc	ra,0xffffc
    80005638:	b30080e7          	jalr	-1232(ra) # 80001164 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000563c:	00d5151b          	slliw	a0,a0,0xd
    80005640:	0c2017b7          	lui	a5,0xc201
    80005644:	97aa                	add	a5,a5,a0
  return irq;
}
    80005646:	43c8                	lw	a0,4(a5)
    80005648:	60a2                	ld	ra,8(sp)
    8000564a:	6402                	ld	s0,0(sp)
    8000564c:	0141                	addi	sp,sp,16
    8000564e:	8082                	ret

0000000080005650 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005650:	1101                	addi	sp,sp,-32
    80005652:	ec06                	sd	ra,24(sp)
    80005654:	e822                	sd	s0,16(sp)
    80005656:	e426                	sd	s1,8(sp)
    80005658:	1000                	addi	s0,sp,32
    8000565a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000565c:	ffffc097          	auipc	ra,0xffffc
    80005660:	b08080e7          	jalr	-1272(ra) # 80001164 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005664:	00d5151b          	slliw	a0,a0,0xd
    80005668:	0c2017b7          	lui	a5,0xc201
    8000566c:	97aa                	add	a5,a5,a0
    8000566e:	c3c4                	sw	s1,4(a5)
}
    80005670:	60e2                	ld	ra,24(sp)
    80005672:	6442                	ld	s0,16(sp)
    80005674:	64a2                	ld	s1,8(sp)
    80005676:	6105                	addi	sp,sp,32
    80005678:	8082                	ret

000000008000567a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000567a:	1141                	addi	sp,sp,-16
    8000567c:	e406                	sd	ra,8(sp)
    8000567e:	e022                	sd	s0,0(sp)
    80005680:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005682:	479d                	li	a5,7
    80005684:	04a7cc63          	blt	a5,a0,800056dc <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005688:	00234797          	auipc	a5,0x234
    8000568c:	3c078793          	addi	a5,a5,960 # 80239a48 <disk>
    80005690:	97aa                	add	a5,a5,a0
    80005692:	0187c783          	lbu	a5,24(a5)
    80005696:	ebb9                	bnez	a5,800056ec <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005698:	00451693          	slli	a3,a0,0x4
    8000569c:	00234797          	auipc	a5,0x234
    800056a0:	3ac78793          	addi	a5,a5,940 # 80239a48 <disk>
    800056a4:	6398                	ld	a4,0(a5)
    800056a6:	9736                	add	a4,a4,a3
    800056a8:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800056ac:	6398                	ld	a4,0(a5)
    800056ae:	9736                	add	a4,a4,a3
    800056b0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800056b4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800056b8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800056bc:	97aa                	add	a5,a5,a0
    800056be:	4705                	li	a4,1
    800056c0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800056c4:	00234517          	auipc	a0,0x234
    800056c8:	39c50513          	addi	a0,a0,924 # 80239a60 <disk+0x18>
    800056cc:	ffffc097          	auipc	ra,0xffffc
    800056d0:	1d6080e7          	jalr	470(ra) # 800018a2 <wakeup>
}
    800056d4:	60a2                	ld	ra,8(sp)
    800056d6:	6402                	ld	s0,0(sp)
    800056d8:	0141                	addi	sp,sp,16
    800056da:	8082                	ret
    panic("free_desc 1");
    800056dc:	00003517          	auipc	a0,0x3
    800056e0:	f6450513          	addi	a0,a0,-156 # 80008640 <etext+0x640>
    800056e4:	00001097          	auipc	ra,0x1
    800056e8:	a6e080e7          	jalr	-1426(ra) # 80006152 <panic>
    panic("free_desc 2");
    800056ec:	00003517          	auipc	a0,0x3
    800056f0:	f6450513          	addi	a0,a0,-156 # 80008650 <etext+0x650>
    800056f4:	00001097          	auipc	ra,0x1
    800056f8:	a5e080e7          	jalr	-1442(ra) # 80006152 <panic>

00000000800056fc <virtio_disk_init>:
{
    800056fc:	1101                	addi	sp,sp,-32
    800056fe:	ec06                	sd	ra,24(sp)
    80005700:	e822                	sd	s0,16(sp)
    80005702:	e426                	sd	s1,8(sp)
    80005704:	e04a                	sd	s2,0(sp)
    80005706:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005708:	00003597          	auipc	a1,0x3
    8000570c:	f5858593          	addi	a1,a1,-168 # 80008660 <etext+0x660>
    80005710:	00234517          	auipc	a0,0x234
    80005714:	46050513          	addi	a0,a0,1120 # 80239b70 <disk+0x128>
    80005718:	00001097          	auipc	ra,0x1
    8000571c:	f24080e7          	jalr	-220(ra) # 8000663c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005720:	100017b7          	lui	a5,0x10001
    80005724:	4398                	lw	a4,0(a5)
    80005726:	2701                	sext.w	a4,a4
    80005728:	747277b7          	lui	a5,0x74727
    8000572c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005730:	18f71c63          	bne	a4,a5,800058c8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005734:	100017b7          	lui	a5,0x10001
    80005738:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000573a:	439c                	lw	a5,0(a5)
    8000573c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000573e:	4709                	li	a4,2
    80005740:	18e79463          	bne	a5,a4,800058c8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005744:	100017b7          	lui	a5,0x10001
    80005748:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000574a:	439c                	lw	a5,0(a5)
    8000574c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000574e:	16e79d63          	bne	a5,a4,800058c8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005752:	100017b7          	lui	a5,0x10001
    80005756:	47d8                	lw	a4,12(a5)
    80005758:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000575a:	554d47b7          	lui	a5,0x554d4
    8000575e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005762:	16f71363          	bne	a4,a5,800058c8 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005766:	100017b7          	lui	a5,0x10001
    8000576a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000576e:	4705                	li	a4,1
    80005770:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005772:	470d                	li	a4,3
    80005774:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005776:	10001737          	lui	a4,0x10001
    8000577a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000577c:	c7ffe737          	lui	a4,0xc7ffe
    80005780:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47dbc98f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005784:	8ef9                	and	a3,a3,a4
    80005786:	10001737          	lui	a4,0x10001
    8000578a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000578c:	472d                	li	a4,11
    8000578e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005790:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005794:	439c                	lw	a5,0(a5)
    80005796:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000579a:	8ba1                	andi	a5,a5,8
    8000579c:	12078e63          	beqz	a5,800058d8 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800057a0:	100017b7          	lui	a5,0x10001
    800057a4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800057a8:	100017b7          	lui	a5,0x10001
    800057ac:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800057b0:	439c                	lw	a5,0(a5)
    800057b2:	2781                	sext.w	a5,a5
    800057b4:	12079a63          	bnez	a5,800058e8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800057b8:	100017b7          	lui	a5,0x10001
    800057bc:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800057c0:	439c                	lw	a5,0(a5)
    800057c2:	2781                	sext.w	a5,a5
  if(max == 0)
    800057c4:	12078a63          	beqz	a5,800058f8 <virtio_disk_init+0x1fc>
  if(max < NUM)
    800057c8:	471d                	li	a4,7
    800057ca:	12f77f63          	bgeu	a4,a5,80005908 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    800057ce:	ffffb097          	auipc	ra,0xffffb
    800057d2:	9b2080e7          	jalr	-1614(ra) # 80000180 <kalloc>
    800057d6:	00234497          	auipc	s1,0x234
    800057da:	27248493          	addi	s1,s1,626 # 80239a48 <disk>
    800057de:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800057e0:	ffffb097          	auipc	ra,0xffffb
    800057e4:	9a0080e7          	jalr	-1632(ra) # 80000180 <kalloc>
    800057e8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800057ea:	ffffb097          	auipc	ra,0xffffb
    800057ee:	996080e7          	jalr	-1642(ra) # 80000180 <kalloc>
    800057f2:	87aa                	mv	a5,a0
    800057f4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800057f6:	6088                	ld	a0,0(s1)
    800057f8:	12050063          	beqz	a0,80005918 <virtio_disk_init+0x21c>
    800057fc:	00234717          	auipc	a4,0x234
    80005800:	25473703          	ld	a4,596(a4) # 80239a50 <disk+0x8>
    80005804:	10070a63          	beqz	a4,80005918 <virtio_disk_init+0x21c>
    80005808:	10078863          	beqz	a5,80005918 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000580c:	6605                	lui	a2,0x1
    8000580e:	4581                	li	a1,0
    80005810:	ffffb097          	auipc	ra,0xffffb
    80005814:	a9a080e7          	jalr	-1382(ra) # 800002aa <memset>
  memset(disk.avail, 0, PGSIZE);
    80005818:	00234497          	auipc	s1,0x234
    8000581c:	23048493          	addi	s1,s1,560 # 80239a48 <disk>
    80005820:	6605                	lui	a2,0x1
    80005822:	4581                	li	a1,0
    80005824:	6488                	ld	a0,8(s1)
    80005826:	ffffb097          	auipc	ra,0xffffb
    8000582a:	a84080e7          	jalr	-1404(ra) # 800002aa <memset>
  memset(disk.used, 0, PGSIZE);
    8000582e:	6605                	lui	a2,0x1
    80005830:	4581                	li	a1,0
    80005832:	6888                	ld	a0,16(s1)
    80005834:	ffffb097          	auipc	ra,0xffffb
    80005838:	a76080e7          	jalr	-1418(ra) # 800002aa <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000583c:	100017b7          	lui	a5,0x10001
    80005840:	4721                	li	a4,8
    80005842:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005844:	4098                	lw	a4,0(s1)
    80005846:	100017b7          	lui	a5,0x10001
    8000584a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000584e:	40d8                	lw	a4,4(s1)
    80005850:	100017b7          	lui	a5,0x10001
    80005854:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005858:	649c                	ld	a5,8(s1)
    8000585a:	0007869b          	sext.w	a3,a5
    8000585e:	10001737          	lui	a4,0x10001
    80005862:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005866:	9781                	srai	a5,a5,0x20
    80005868:	10001737          	lui	a4,0x10001
    8000586c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005870:	689c                	ld	a5,16(s1)
    80005872:	0007869b          	sext.w	a3,a5
    80005876:	10001737          	lui	a4,0x10001
    8000587a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000587e:	9781                	srai	a5,a5,0x20
    80005880:	10001737          	lui	a4,0x10001
    80005884:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005888:	10001737          	lui	a4,0x10001
    8000588c:	4785                	li	a5,1
    8000588e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005890:	00f48c23          	sb	a5,24(s1)
    80005894:	00f48ca3          	sb	a5,25(s1)
    80005898:	00f48d23          	sb	a5,26(s1)
    8000589c:	00f48da3          	sb	a5,27(s1)
    800058a0:	00f48e23          	sb	a5,28(s1)
    800058a4:	00f48ea3          	sb	a5,29(s1)
    800058a8:	00f48f23          	sb	a5,30(s1)
    800058ac:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800058b0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800058b4:	100017b7          	lui	a5,0x10001
    800058b8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800058bc:	60e2                	ld	ra,24(sp)
    800058be:	6442                	ld	s0,16(sp)
    800058c0:	64a2                	ld	s1,8(sp)
    800058c2:	6902                	ld	s2,0(sp)
    800058c4:	6105                	addi	sp,sp,32
    800058c6:	8082                	ret
    panic("could not find virtio disk");
    800058c8:	00003517          	auipc	a0,0x3
    800058cc:	da850513          	addi	a0,a0,-600 # 80008670 <etext+0x670>
    800058d0:	00001097          	auipc	ra,0x1
    800058d4:	882080e7          	jalr	-1918(ra) # 80006152 <panic>
    panic("virtio disk FEATURES_OK unset");
    800058d8:	00003517          	auipc	a0,0x3
    800058dc:	db850513          	addi	a0,a0,-584 # 80008690 <etext+0x690>
    800058e0:	00001097          	auipc	ra,0x1
    800058e4:	872080e7          	jalr	-1934(ra) # 80006152 <panic>
    panic("virtio disk should not be ready");
    800058e8:	00003517          	auipc	a0,0x3
    800058ec:	dc850513          	addi	a0,a0,-568 # 800086b0 <etext+0x6b0>
    800058f0:	00001097          	auipc	ra,0x1
    800058f4:	862080e7          	jalr	-1950(ra) # 80006152 <panic>
    panic("virtio disk has no queue 0");
    800058f8:	00003517          	auipc	a0,0x3
    800058fc:	dd850513          	addi	a0,a0,-552 # 800086d0 <etext+0x6d0>
    80005900:	00001097          	auipc	ra,0x1
    80005904:	852080e7          	jalr	-1966(ra) # 80006152 <panic>
    panic("virtio disk max queue too short");
    80005908:	00003517          	auipc	a0,0x3
    8000590c:	de850513          	addi	a0,a0,-536 # 800086f0 <etext+0x6f0>
    80005910:	00001097          	auipc	ra,0x1
    80005914:	842080e7          	jalr	-1982(ra) # 80006152 <panic>
    panic("virtio disk kalloc");
    80005918:	00003517          	auipc	a0,0x3
    8000591c:	df850513          	addi	a0,a0,-520 # 80008710 <etext+0x710>
    80005920:	00001097          	auipc	ra,0x1
    80005924:	832080e7          	jalr	-1998(ra) # 80006152 <panic>

0000000080005928 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005928:	7159                	addi	sp,sp,-112
    8000592a:	f486                	sd	ra,104(sp)
    8000592c:	f0a2                	sd	s0,96(sp)
    8000592e:	eca6                	sd	s1,88(sp)
    80005930:	e8ca                	sd	s2,80(sp)
    80005932:	e4ce                	sd	s3,72(sp)
    80005934:	e0d2                	sd	s4,64(sp)
    80005936:	fc56                	sd	s5,56(sp)
    80005938:	f85a                	sd	s6,48(sp)
    8000593a:	f45e                	sd	s7,40(sp)
    8000593c:	f062                	sd	s8,32(sp)
    8000593e:	ec66                	sd	s9,24(sp)
    80005940:	1880                	addi	s0,sp,112
    80005942:	8a2a                	mv	s4,a0
    80005944:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005946:	00c52c83          	lw	s9,12(a0)
    8000594a:	001c9c9b          	slliw	s9,s9,0x1
    8000594e:	1c82                	slli	s9,s9,0x20
    80005950:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005954:	00234517          	auipc	a0,0x234
    80005958:	21c50513          	addi	a0,a0,540 # 80239b70 <disk+0x128>
    8000595c:	00001097          	auipc	ra,0x1
    80005960:	d70080e7          	jalr	-656(ra) # 800066cc <acquire>
  for(int i = 0; i < 3; i++){
    80005964:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005966:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005968:	00234b17          	auipc	s6,0x234
    8000596c:	0e0b0b13          	addi	s6,s6,224 # 80239a48 <disk>
  for(int i = 0; i < 3; i++){
    80005970:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005972:	00234c17          	auipc	s8,0x234
    80005976:	1fec0c13          	addi	s8,s8,510 # 80239b70 <disk+0x128>
    8000597a:	a0ad                	j	800059e4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000597c:	00fb0733          	add	a4,s6,a5
    80005980:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005984:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005986:	0207c563          	bltz	a5,800059b0 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000598a:	2905                	addiw	s2,s2,1
    8000598c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000598e:	05590f63          	beq	s2,s5,800059ec <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005992:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005994:	00234717          	auipc	a4,0x234
    80005998:	0b470713          	addi	a4,a4,180 # 80239a48 <disk>
    8000599c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000599e:	01874683          	lbu	a3,24(a4)
    800059a2:	fee9                	bnez	a3,8000597c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    800059a4:	2785                	addiw	a5,a5,1
    800059a6:	0705                	addi	a4,a4,1
    800059a8:	fe979be3          	bne	a5,s1,8000599e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800059ac:	57fd                	li	a5,-1
    800059ae:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800059b0:	03205163          	blez	s2,800059d2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800059b4:	f9042503          	lw	a0,-112(s0)
    800059b8:	00000097          	auipc	ra,0x0
    800059bc:	cc2080e7          	jalr	-830(ra) # 8000567a <free_desc>
      for(int j = 0; j < i; j++)
    800059c0:	4785                	li	a5,1
    800059c2:	0127d863          	bge	a5,s2,800059d2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800059c6:	f9442503          	lw	a0,-108(s0)
    800059ca:	00000097          	auipc	ra,0x0
    800059ce:	cb0080e7          	jalr	-848(ra) # 8000567a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800059d2:	85e2                	mv	a1,s8
    800059d4:	00234517          	auipc	a0,0x234
    800059d8:	08c50513          	addi	a0,a0,140 # 80239a60 <disk+0x18>
    800059dc:	ffffc097          	auipc	ra,0xffffc
    800059e0:	e62080e7          	jalr	-414(ra) # 8000183e <sleep>
  for(int i = 0; i < 3; i++){
    800059e4:	f9040613          	addi	a2,s0,-112
    800059e8:	894e                	mv	s2,s3
    800059ea:	b765                	j	80005992 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059ec:	f9042503          	lw	a0,-112(s0)
    800059f0:	00451693          	slli	a3,a0,0x4

  if(write)
    800059f4:	00234797          	auipc	a5,0x234
    800059f8:	05478793          	addi	a5,a5,84 # 80239a48 <disk>
    800059fc:	00a50713          	addi	a4,a0,10
    80005a00:	0712                	slli	a4,a4,0x4
    80005a02:	973e                	add	a4,a4,a5
    80005a04:	01703633          	snez	a2,s7
    80005a08:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005a0a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005a0e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a12:	6398                	ld	a4,0(a5)
    80005a14:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a16:	0a868613          	addi	a2,a3,168
    80005a1a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005a1c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005a1e:	6390                	ld	a2,0(a5)
    80005a20:	00d605b3          	add	a1,a2,a3
    80005a24:	4741                	li	a4,16
    80005a26:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005a28:	4805                	li	a6,1
    80005a2a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005a2e:	f9442703          	lw	a4,-108(s0)
    80005a32:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005a36:	0712                	slli	a4,a4,0x4
    80005a38:	963a                	add	a2,a2,a4
    80005a3a:	058a0593          	addi	a1,s4,88
    80005a3e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005a40:	0007b883          	ld	a7,0(a5)
    80005a44:	9746                	add	a4,a4,a7
    80005a46:	40000613          	li	a2,1024
    80005a4a:	c710                	sw	a2,8(a4)
  if(write)
    80005a4c:	001bb613          	seqz	a2,s7
    80005a50:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005a54:	00166613          	ori	a2,a2,1
    80005a58:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005a5c:	f9842583          	lw	a1,-104(s0)
    80005a60:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005a64:	00250613          	addi	a2,a0,2
    80005a68:	0612                	slli	a2,a2,0x4
    80005a6a:	963e                	add	a2,a2,a5
    80005a6c:	577d                	li	a4,-1
    80005a6e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005a72:	0592                	slli	a1,a1,0x4
    80005a74:	98ae                	add	a7,a7,a1
    80005a76:	03068713          	addi	a4,a3,48
    80005a7a:	973e                	add	a4,a4,a5
    80005a7c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005a80:	6398                	ld	a4,0(a5)
    80005a82:	972e                	add	a4,a4,a1
    80005a84:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005a88:	4689                	li	a3,2
    80005a8a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005a8e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005a92:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005a96:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005a9a:	6794                	ld	a3,8(a5)
    80005a9c:	0026d703          	lhu	a4,2(a3)
    80005aa0:	8b1d                	andi	a4,a4,7
    80005aa2:	0706                	slli	a4,a4,0x1
    80005aa4:	96ba                	add	a3,a3,a4
    80005aa6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005aaa:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005aae:	6798                	ld	a4,8(a5)
    80005ab0:	00275783          	lhu	a5,2(a4)
    80005ab4:	2785                	addiw	a5,a5,1
    80005ab6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005aba:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005abe:	100017b7          	lui	a5,0x10001
    80005ac2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005ac6:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005aca:	00234917          	auipc	s2,0x234
    80005ace:	0a690913          	addi	s2,s2,166 # 80239b70 <disk+0x128>
  while(b->disk == 1) {
    80005ad2:	4485                	li	s1,1
    80005ad4:	01079c63          	bne	a5,a6,80005aec <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005ad8:	85ca                	mv	a1,s2
    80005ada:	8552                	mv	a0,s4
    80005adc:	ffffc097          	auipc	ra,0xffffc
    80005ae0:	d62080e7          	jalr	-670(ra) # 8000183e <sleep>
  while(b->disk == 1) {
    80005ae4:	004a2783          	lw	a5,4(s4)
    80005ae8:	fe9788e3          	beq	a5,s1,80005ad8 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005aec:	f9042903          	lw	s2,-112(s0)
    80005af0:	00290713          	addi	a4,s2,2
    80005af4:	0712                	slli	a4,a4,0x4
    80005af6:	00234797          	auipc	a5,0x234
    80005afa:	f5278793          	addi	a5,a5,-174 # 80239a48 <disk>
    80005afe:	97ba                	add	a5,a5,a4
    80005b00:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005b04:	00234997          	auipc	s3,0x234
    80005b08:	f4498993          	addi	s3,s3,-188 # 80239a48 <disk>
    80005b0c:	00491713          	slli	a4,s2,0x4
    80005b10:	0009b783          	ld	a5,0(s3)
    80005b14:	97ba                	add	a5,a5,a4
    80005b16:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005b1a:	854a                	mv	a0,s2
    80005b1c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005b20:	00000097          	auipc	ra,0x0
    80005b24:	b5a080e7          	jalr	-1190(ra) # 8000567a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005b28:	8885                	andi	s1,s1,1
    80005b2a:	f0ed                	bnez	s1,80005b0c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005b2c:	00234517          	auipc	a0,0x234
    80005b30:	04450513          	addi	a0,a0,68 # 80239b70 <disk+0x128>
    80005b34:	00001097          	auipc	ra,0x1
    80005b38:	c4c080e7          	jalr	-948(ra) # 80006780 <release>
}
    80005b3c:	70a6                	ld	ra,104(sp)
    80005b3e:	7406                	ld	s0,96(sp)
    80005b40:	64e6                	ld	s1,88(sp)
    80005b42:	6946                	ld	s2,80(sp)
    80005b44:	69a6                	ld	s3,72(sp)
    80005b46:	6a06                	ld	s4,64(sp)
    80005b48:	7ae2                	ld	s5,56(sp)
    80005b4a:	7b42                	ld	s6,48(sp)
    80005b4c:	7ba2                	ld	s7,40(sp)
    80005b4e:	7c02                	ld	s8,32(sp)
    80005b50:	6ce2                	ld	s9,24(sp)
    80005b52:	6165                	addi	sp,sp,112
    80005b54:	8082                	ret

0000000080005b56 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005b56:	1101                	addi	sp,sp,-32
    80005b58:	ec06                	sd	ra,24(sp)
    80005b5a:	e822                	sd	s0,16(sp)
    80005b5c:	e426                	sd	s1,8(sp)
    80005b5e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005b60:	00234497          	auipc	s1,0x234
    80005b64:	ee848493          	addi	s1,s1,-280 # 80239a48 <disk>
    80005b68:	00234517          	auipc	a0,0x234
    80005b6c:	00850513          	addi	a0,a0,8 # 80239b70 <disk+0x128>
    80005b70:	00001097          	auipc	ra,0x1
    80005b74:	b5c080e7          	jalr	-1188(ra) # 800066cc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005b78:	100017b7          	lui	a5,0x10001
    80005b7c:	53b8                	lw	a4,96(a5)
    80005b7e:	8b0d                	andi	a4,a4,3
    80005b80:	100017b7          	lui	a5,0x10001
    80005b84:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005b86:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005b8a:	689c                	ld	a5,16(s1)
    80005b8c:	0204d703          	lhu	a4,32(s1)
    80005b90:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005b94:	04f70863          	beq	a4,a5,80005be4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80005b98:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b9c:	6898                	ld	a4,16(s1)
    80005b9e:	0204d783          	lhu	a5,32(s1)
    80005ba2:	8b9d                	andi	a5,a5,7
    80005ba4:	078e                	slli	a5,a5,0x3
    80005ba6:	97ba                	add	a5,a5,a4
    80005ba8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005baa:	00278713          	addi	a4,a5,2
    80005bae:	0712                	slli	a4,a4,0x4
    80005bb0:	9726                	add	a4,a4,s1
    80005bb2:	01074703          	lbu	a4,16(a4)
    80005bb6:	e721                	bnez	a4,80005bfe <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005bb8:	0789                	addi	a5,a5,2
    80005bba:	0792                	slli	a5,a5,0x4
    80005bbc:	97a6                	add	a5,a5,s1
    80005bbe:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005bc0:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005bc4:	ffffc097          	auipc	ra,0xffffc
    80005bc8:	cde080e7          	jalr	-802(ra) # 800018a2 <wakeup>

    disk.used_idx += 1;
    80005bcc:	0204d783          	lhu	a5,32(s1)
    80005bd0:	2785                	addiw	a5,a5,1
    80005bd2:	17c2                	slli	a5,a5,0x30
    80005bd4:	93c1                	srli	a5,a5,0x30
    80005bd6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005bda:	6898                	ld	a4,16(s1)
    80005bdc:	00275703          	lhu	a4,2(a4)
    80005be0:	faf71ce3          	bne	a4,a5,80005b98 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80005be4:	00234517          	auipc	a0,0x234
    80005be8:	f8c50513          	addi	a0,a0,-116 # 80239b70 <disk+0x128>
    80005bec:	00001097          	auipc	ra,0x1
    80005bf0:	b94080e7          	jalr	-1132(ra) # 80006780 <release>
}
    80005bf4:	60e2                	ld	ra,24(sp)
    80005bf6:	6442                	ld	s0,16(sp)
    80005bf8:	64a2                	ld	s1,8(sp)
    80005bfa:	6105                	addi	sp,sp,32
    80005bfc:	8082                	ret
      panic("virtio_disk_intr status");
    80005bfe:	00003517          	auipc	a0,0x3
    80005c02:	b2a50513          	addi	a0,a0,-1238 # 80008728 <etext+0x728>
    80005c06:	00000097          	auipc	ra,0x0
    80005c0a:	54c080e7          	jalr	1356(ra) # 80006152 <panic>

0000000080005c0e <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005c0e:	1141                	addi	sp,sp,-16
    80005c10:	e422                	sd	s0,8(sp)
    80005c12:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005c14:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005c18:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005c1c:	0037979b          	slliw	a5,a5,0x3
    80005c20:	02004737          	lui	a4,0x2004
    80005c24:	97ba                	add	a5,a5,a4
    80005c26:	0200c737          	lui	a4,0x200c
    80005c2a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005c2c:	6318                	ld	a4,0(a4)
    80005c2e:	000f4637          	lui	a2,0xf4
    80005c32:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005c36:	9732                	add	a4,a4,a2
    80005c38:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005c3a:	00259693          	slli	a3,a1,0x2
    80005c3e:	96ae                	add	a3,a3,a1
    80005c40:	068e                	slli	a3,a3,0x3
    80005c42:	00234717          	auipc	a4,0x234
    80005c46:	f4e70713          	addi	a4,a4,-178 # 80239b90 <timer_scratch>
    80005c4a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005c4c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005c4e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005c50:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005c54:	00000797          	auipc	a5,0x0
    80005c58:	95c78793          	addi	a5,a5,-1700 # 800055b0 <timervec>
    80005c5c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c60:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005c64:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c68:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005c6c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005c70:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005c74:	30479073          	csrw	mie,a5
}
    80005c78:	6422                	ld	s0,8(sp)
    80005c7a:	0141                	addi	sp,sp,16
    80005c7c:	8082                	ret

0000000080005c7e <start>:
{
    80005c7e:	1141                	addi	sp,sp,-16
    80005c80:	e406                	sd	ra,8(sp)
    80005c82:	e022                	sd	s0,0(sp)
    80005c84:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c86:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005c8a:	7779                	lui	a4,0xffffe
    80005c8c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbca2f>
    80005c90:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005c92:	6705                	lui	a4,0x1
    80005c94:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005c98:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c9a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005c9e:	ffffa797          	auipc	a5,0xffffa
    80005ca2:	7aa78793          	addi	a5,a5,1962 # 80000448 <main>
    80005ca6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005caa:	4781                	li	a5,0
    80005cac:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005cb0:	67c1                	lui	a5,0x10
    80005cb2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005cb4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005cb8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005cbc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005cc0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005cc4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005cc8:	57fd                	li	a5,-1
    80005cca:	83a9                	srli	a5,a5,0xa
    80005ccc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005cd0:	47bd                	li	a5,15
    80005cd2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005cd6:	00000097          	auipc	ra,0x0
    80005cda:	f38080e7          	jalr	-200(ra) # 80005c0e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005cde:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005ce2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005ce4:	823e                	mv	tp,a5
  asm volatile("mret");
    80005ce6:	30200073          	mret
}
    80005cea:	60a2                	ld	ra,8(sp)
    80005cec:	6402                	ld	s0,0(sp)
    80005cee:	0141                	addi	sp,sp,16
    80005cf0:	8082                	ret

0000000080005cf2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005cf2:	715d                	addi	sp,sp,-80
    80005cf4:	e486                	sd	ra,72(sp)
    80005cf6:	e0a2                	sd	s0,64(sp)
    80005cf8:	f84a                	sd	s2,48(sp)
    80005cfa:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005cfc:	04c05663          	blez	a2,80005d48 <consolewrite+0x56>
    80005d00:	fc26                	sd	s1,56(sp)
    80005d02:	f44e                	sd	s3,40(sp)
    80005d04:	f052                	sd	s4,32(sp)
    80005d06:	ec56                	sd	s5,24(sp)
    80005d08:	8a2a                	mv	s4,a0
    80005d0a:	84ae                	mv	s1,a1
    80005d0c:	89b2                	mv	s3,a2
    80005d0e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005d10:	5afd                	li	s5,-1
    80005d12:	4685                	li	a3,1
    80005d14:	8626                	mv	a2,s1
    80005d16:	85d2                	mv	a1,s4
    80005d18:	fbf40513          	addi	a0,s0,-65
    80005d1c:	ffffc097          	auipc	ra,0xffffc
    80005d20:	f80080e7          	jalr	-128(ra) # 80001c9c <either_copyin>
    80005d24:	03550463          	beq	a0,s5,80005d4c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005d28:	fbf44503          	lbu	a0,-65(s0)
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	7e4080e7          	jalr	2020(ra) # 80006510 <uartputc>
  for(i = 0; i < n; i++){
    80005d34:	2905                	addiw	s2,s2,1
    80005d36:	0485                	addi	s1,s1,1
    80005d38:	fd299de3          	bne	s3,s2,80005d12 <consolewrite+0x20>
    80005d3c:	894e                	mv	s2,s3
    80005d3e:	74e2                	ld	s1,56(sp)
    80005d40:	79a2                	ld	s3,40(sp)
    80005d42:	7a02                	ld	s4,32(sp)
    80005d44:	6ae2                	ld	s5,24(sp)
    80005d46:	a039                	j	80005d54 <consolewrite+0x62>
    80005d48:	4901                	li	s2,0
    80005d4a:	a029                	j	80005d54 <consolewrite+0x62>
    80005d4c:	74e2                	ld	s1,56(sp)
    80005d4e:	79a2                	ld	s3,40(sp)
    80005d50:	7a02                	ld	s4,32(sp)
    80005d52:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005d54:	854a                	mv	a0,s2
    80005d56:	60a6                	ld	ra,72(sp)
    80005d58:	6406                	ld	s0,64(sp)
    80005d5a:	7942                	ld	s2,48(sp)
    80005d5c:	6161                	addi	sp,sp,80
    80005d5e:	8082                	ret

0000000080005d60 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005d60:	711d                	addi	sp,sp,-96
    80005d62:	ec86                	sd	ra,88(sp)
    80005d64:	e8a2                	sd	s0,80(sp)
    80005d66:	e4a6                	sd	s1,72(sp)
    80005d68:	e0ca                	sd	s2,64(sp)
    80005d6a:	fc4e                	sd	s3,56(sp)
    80005d6c:	f852                	sd	s4,48(sp)
    80005d6e:	f456                	sd	s5,40(sp)
    80005d70:	f05a                	sd	s6,32(sp)
    80005d72:	1080                	addi	s0,sp,96
    80005d74:	8aaa                	mv	s5,a0
    80005d76:	8a2e                	mv	s4,a1
    80005d78:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005d7a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005d7e:	0023c517          	auipc	a0,0x23c
    80005d82:	f5250513          	addi	a0,a0,-174 # 80241cd0 <cons>
    80005d86:	00001097          	auipc	ra,0x1
    80005d8a:	946080e7          	jalr	-1722(ra) # 800066cc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005d8e:	0023c497          	auipc	s1,0x23c
    80005d92:	f4248493          	addi	s1,s1,-190 # 80241cd0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005d96:	0023c917          	auipc	s2,0x23c
    80005d9a:	fd290913          	addi	s2,s2,-46 # 80241d68 <cons+0x98>
  while(n > 0){
    80005d9e:	0d305763          	blez	s3,80005e6c <consoleread+0x10c>
    while(cons.r == cons.w){
    80005da2:	0984a783          	lw	a5,152(s1)
    80005da6:	09c4a703          	lw	a4,156(s1)
    80005daa:	0af71c63          	bne	a4,a5,80005e62 <consoleread+0x102>
      if(killed(myproc())){
    80005dae:	ffffb097          	auipc	ra,0xffffb
    80005db2:	3e2080e7          	jalr	994(ra) # 80001190 <myproc>
    80005db6:	ffffc097          	auipc	ra,0xffffc
    80005dba:	d30080e7          	jalr	-720(ra) # 80001ae6 <killed>
    80005dbe:	e52d                	bnez	a0,80005e28 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    80005dc0:	85a6                	mv	a1,s1
    80005dc2:	854a                	mv	a0,s2
    80005dc4:	ffffc097          	auipc	ra,0xffffc
    80005dc8:	a7a080e7          	jalr	-1414(ra) # 8000183e <sleep>
    while(cons.r == cons.w){
    80005dcc:	0984a783          	lw	a5,152(s1)
    80005dd0:	09c4a703          	lw	a4,156(s1)
    80005dd4:	fcf70de3          	beq	a4,a5,80005dae <consoleread+0x4e>
    80005dd8:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005dda:	0023c717          	auipc	a4,0x23c
    80005dde:	ef670713          	addi	a4,a4,-266 # 80241cd0 <cons>
    80005de2:	0017869b          	addiw	a3,a5,1
    80005de6:	08d72c23          	sw	a3,152(a4)
    80005dea:	07f7f693          	andi	a3,a5,127
    80005dee:	9736                	add	a4,a4,a3
    80005df0:	01874703          	lbu	a4,24(a4)
    80005df4:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005df8:	4691                	li	a3,4
    80005dfa:	04db8a63          	beq	s7,a3,80005e4e <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005dfe:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005e02:	4685                	li	a3,1
    80005e04:	faf40613          	addi	a2,s0,-81
    80005e08:	85d2                	mv	a1,s4
    80005e0a:	8556                	mv	a0,s5
    80005e0c:	ffffc097          	auipc	ra,0xffffc
    80005e10:	e3a080e7          	jalr	-454(ra) # 80001c46 <either_copyout>
    80005e14:	57fd                	li	a5,-1
    80005e16:	04f50a63          	beq	a0,a5,80005e6a <consoleread+0x10a>
      break;

    dst++;
    80005e1a:	0a05                	addi	s4,s4,1
    --n;
    80005e1c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005e1e:	47a9                	li	a5,10
    80005e20:	06fb8163          	beq	s7,a5,80005e82 <consoleread+0x122>
    80005e24:	6be2                	ld	s7,24(sp)
    80005e26:	bfa5                	j	80005d9e <consoleread+0x3e>
        release(&cons.lock);
    80005e28:	0023c517          	auipc	a0,0x23c
    80005e2c:	ea850513          	addi	a0,a0,-344 # 80241cd0 <cons>
    80005e30:	00001097          	auipc	ra,0x1
    80005e34:	950080e7          	jalr	-1712(ra) # 80006780 <release>
        return -1;
    80005e38:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005e3a:	60e6                	ld	ra,88(sp)
    80005e3c:	6446                	ld	s0,80(sp)
    80005e3e:	64a6                	ld	s1,72(sp)
    80005e40:	6906                	ld	s2,64(sp)
    80005e42:	79e2                	ld	s3,56(sp)
    80005e44:	7a42                	ld	s4,48(sp)
    80005e46:	7aa2                	ld	s5,40(sp)
    80005e48:	7b02                	ld	s6,32(sp)
    80005e4a:	6125                	addi	sp,sp,96
    80005e4c:	8082                	ret
      if(n < target){
    80005e4e:	0009871b          	sext.w	a4,s3
    80005e52:	01677a63          	bgeu	a4,s6,80005e66 <consoleread+0x106>
        cons.r--;
    80005e56:	0023c717          	auipc	a4,0x23c
    80005e5a:	f0f72923          	sw	a5,-238(a4) # 80241d68 <cons+0x98>
    80005e5e:	6be2                	ld	s7,24(sp)
    80005e60:	a031                	j	80005e6c <consoleread+0x10c>
    80005e62:	ec5e                	sd	s7,24(sp)
    80005e64:	bf9d                	j	80005dda <consoleread+0x7a>
    80005e66:	6be2                	ld	s7,24(sp)
    80005e68:	a011                	j	80005e6c <consoleread+0x10c>
    80005e6a:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005e6c:	0023c517          	auipc	a0,0x23c
    80005e70:	e6450513          	addi	a0,a0,-412 # 80241cd0 <cons>
    80005e74:	00001097          	auipc	ra,0x1
    80005e78:	90c080e7          	jalr	-1780(ra) # 80006780 <release>
  return target - n;
    80005e7c:	413b053b          	subw	a0,s6,s3
    80005e80:	bf6d                	j	80005e3a <consoleread+0xda>
    80005e82:	6be2                	ld	s7,24(sp)
    80005e84:	b7e5                	j	80005e6c <consoleread+0x10c>

0000000080005e86 <consputc>:
{
    80005e86:	1141                	addi	sp,sp,-16
    80005e88:	e406                	sd	ra,8(sp)
    80005e8a:	e022                	sd	s0,0(sp)
    80005e8c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005e8e:	10000793          	li	a5,256
    80005e92:	00f50a63          	beq	a0,a5,80005ea6 <consputc+0x20>
    uartputc_sync(c);
    80005e96:	00000097          	auipc	ra,0x0
    80005e9a:	59c080e7          	jalr	1436(ra) # 80006432 <uartputc_sync>
}
    80005e9e:	60a2                	ld	ra,8(sp)
    80005ea0:	6402                	ld	s0,0(sp)
    80005ea2:	0141                	addi	sp,sp,16
    80005ea4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ea6:	4521                	li	a0,8
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	58a080e7          	jalr	1418(ra) # 80006432 <uartputc_sync>
    80005eb0:	02000513          	li	a0,32
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	57e080e7          	jalr	1406(ra) # 80006432 <uartputc_sync>
    80005ebc:	4521                	li	a0,8
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	574080e7          	jalr	1396(ra) # 80006432 <uartputc_sync>
    80005ec6:	bfe1                	j	80005e9e <consputc+0x18>

0000000080005ec8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ec8:	1101                	addi	sp,sp,-32
    80005eca:	ec06                	sd	ra,24(sp)
    80005ecc:	e822                	sd	s0,16(sp)
    80005ece:	e426                	sd	s1,8(sp)
    80005ed0:	1000                	addi	s0,sp,32
    80005ed2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ed4:	0023c517          	auipc	a0,0x23c
    80005ed8:	dfc50513          	addi	a0,a0,-516 # 80241cd0 <cons>
    80005edc:	00000097          	auipc	ra,0x0
    80005ee0:	7f0080e7          	jalr	2032(ra) # 800066cc <acquire>

  switch(c){
    80005ee4:	47d5                	li	a5,21
    80005ee6:	0af48563          	beq	s1,a5,80005f90 <consoleintr+0xc8>
    80005eea:	0297c963          	blt	a5,s1,80005f1c <consoleintr+0x54>
    80005eee:	47a1                	li	a5,8
    80005ef0:	0ef48c63          	beq	s1,a5,80005fe8 <consoleintr+0x120>
    80005ef4:	47c1                	li	a5,16
    80005ef6:	10f49f63          	bne	s1,a5,80006014 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005efa:	ffffc097          	auipc	ra,0xffffc
    80005efe:	df8080e7          	jalr	-520(ra) # 80001cf2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005f02:	0023c517          	auipc	a0,0x23c
    80005f06:	dce50513          	addi	a0,a0,-562 # 80241cd0 <cons>
    80005f0a:	00001097          	auipc	ra,0x1
    80005f0e:	876080e7          	jalr	-1930(ra) # 80006780 <release>
}
    80005f12:	60e2                	ld	ra,24(sp)
    80005f14:	6442                	ld	s0,16(sp)
    80005f16:	64a2                	ld	s1,8(sp)
    80005f18:	6105                	addi	sp,sp,32
    80005f1a:	8082                	ret
  switch(c){
    80005f1c:	07f00793          	li	a5,127
    80005f20:	0cf48463          	beq	s1,a5,80005fe8 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005f24:	0023c717          	auipc	a4,0x23c
    80005f28:	dac70713          	addi	a4,a4,-596 # 80241cd0 <cons>
    80005f2c:	0a072783          	lw	a5,160(a4)
    80005f30:	09872703          	lw	a4,152(a4)
    80005f34:	9f99                	subw	a5,a5,a4
    80005f36:	07f00713          	li	a4,127
    80005f3a:	fcf764e3          	bltu	a4,a5,80005f02 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005f3e:	47b5                	li	a5,13
    80005f40:	0cf48d63          	beq	s1,a5,8000601a <consoleintr+0x152>
      consputc(c);
    80005f44:	8526                	mv	a0,s1
    80005f46:	00000097          	auipc	ra,0x0
    80005f4a:	f40080e7          	jalr	-192(ra) # 80005e86 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005f4e:	0023c797          	auipc	a5,0x23c
    80005f52:	d8278793          	addi	a5,a5,-638 # 80241cd0 <cons>
    80005f56:	0a07a683          	lw	a3,160(a5)
    80005f5a:	0016871b          	addiw	a4,a3,1
    80005f5e:	0007061b          	sext.w	a2,a4
    80005f62:	0ae7a023          	sw	a4,160(a5)
    80005f66:	07f6f693          	andi	a3,a3,127
    80005f6a:	97b6                	add	a5,a5,a3
    80005f6c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005f70:	47a9                	li	a5,10
    80005f72:	0cf48b63          	beq	s1,a5,80006048 <consoleintr+0x180>
    80005f76:	4791                	li	a5,4
    80005f78:	0cf48863          	beq	s1,a5,80006048 <consoleintr+0x180>
    80005f7c:	0023c797          	auipc	a5,0x23c
    80005f80:	dec7a783          	lw	a5,-532(a5) # 80241d68 <cons+0x98>
    80005f84:	9f1d                	subw	a4,a4,a5
    80005f86:	08000793          	li	a5,128
    80005f8a:	f6f71ce3          	bne	a4,a5,80005f02 <consoleintr+0x3a>
    80005f8e:	a86d                	j	80006048 <consoleintr+0x180>
    80005f90:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005f92:	0023c717          	auipc	a4,0x23c
    80005f96:	d3e70713          	addi	a4,a4,-706 # 80241cd0 <cons>
    80005f9a:	0a072783          	lw	a5,160(a4)
    80005f9e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005fa2:	0023c497          	auipc	s1,0x23c
    80005fa6:	d2e48493          	addi	s1,s1,-722 # 80241cd0 <cons>
    while(cons.e != cons.w &&
    80005faa:	4929                	li	s2,10
    80005fac:	02f70a63          	beq	a4,a5,80005fe0 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005fb0:	37fd                	addiw	a5,a5,-1
    80005fb2:	07f7f713          	andi	a4,a5,127
    80005fb6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005fb8:	01874703          	lbu	a4,24(a4)
    80005fbc:	03270463          	beq	a4,s2,80005fe4 <consoleintr+0x11c>
      cons.e--;
    80005fc0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005fc4:	10000513          	li	a0,256
    80005fc8:	00000097          	auipc	ra,0x0
    80005fcc:	ebe080e7          	jalr	-322(ra) # 80005e86 <consputc>
    while(cons.e != cons.w &&
    80005fd0:	0a04a783          	lw	a5,160(s1)
    80005fd4:	09c4a703          	lw	a4,156(s1)
    80005fd8:	fcf71ce3          	bne	a4,a5,80005fb0 <consoleintr+0xe8>
    80005fdc:	6902                	ld	s2,0(sp)
    80005fde:	b715                	j	80005f02 <consoleintr+0x3a>
    80005fe0:	6902                	ld	s2,0(sp)
    80005fe2:	b705                	j	80005f02 <consoleintr+0x3a>
    80005fe4:	6902                	ld	s2,0(sp)
    80005fe6:	bf31                	j	80005f02 <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005fe8:	0023c717          	auipc	a4,0x23c
    80005fec:	ce870713          	addi	a4,a4,-792 # 80241cd0 <cons>
    80005ff0:	0a072783          	lw	a5,160(a4)
    80005ff4:	09c72703          	lw	a4,156(a4)
    80005ff8:	f0f705e3          	beq	a4,a5,80005f02 <consoleintr+0x3a>
      cons.e--;
    80005ffc:	37fd                	addiw	a5,a5,-1
    80005ffe:	0023c717          	auipc	a4,0x23c
    80006002:	d6f72923          	sw	a5,-654(a4) # 80241d70 <cons+0xa0>
      consputc(BACKSPACE);
    80006006:	10000513          	li	a0,256
    8000600a:	00000097          	auipc	ra,0x0
    8000600e:	e7c080e7          	jalr	-388(ra) # 80005e86 <consputc>
    80006012:	bdc5                	j	80005f02 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80006014:	ee0487e3          	beqz	s1,80005f02 <consoleintr+0x3a>
    80006018:	b731                	j	80005f24 <consoleintr+0x5c>
      consputc(c);
    8000601a:	4529                	li	a0,10
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	e6a080e7          	jalr	-406(ra) # 80005e86 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80006024:	0023c797          	auipc	a5,0x23c
    80006028:	cac78793          	addi	a5,a5,-852 # 80241cd0 <cons>
    8000602c:	0a07a703          	lw	a4,160(a5)
    80006030:	0017069b          	addiw	a3,a4,1
    80006034:	0006861b          	sext.w	a2,a3
    80006038:	0ad7a023          	sw	a3,160(a5)
    8000603c:	07f77713          	andi	a4,a4,127
    80006040:	97ba                	add	a5,a5,a4
    80006042:	4729                	li	a4,10
    80006044:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006048:	0023c797          	auipc	a5,0x23c
    8000604c:	d2c7a223          	sw	a2,-732(a5) # 80241d6c <cons+0x9c>
        wakeup(&cons.r);
    80006050:	0023c517          	auipc	a0,0x23c
    80006054:	d1850513          	addi	a0,a0,-744 # 80241d68 <cons+0x98>
    80006058:	ffffc097          	auipc	ra,0xffffc
    8000605c:	84a080e7          	jalr	-1974(ra) # 800018a2 <wakeup>
    80006060:	b54d                	j	80005f02 <consoleintr+0x3a>

0000000080006062 <consoleinit>:

void
consoleinit(void)
{
    80006062:	1141                	addi	sp,sp,-16
    80006064:	e406                	sd	ra,8(sp)
    80006066:	e022                	sd	s0,0(sp)
    80006068:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000606a:	00002597          	auipc	a1,0x2
    8000606e:	6d658593          	addi	a1,a1,1750 # 80008740 <etext+0x740>
    80006072:	0023c517          	auipc	a0,0x23c
    80006076:	c5e50513          	addi	a0,a0,-930 # 80241cd0 <cons>
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	5c2080e7          	jalr	1474(ra) # 8000663c <initlock>

  uartinit();
    80006082:	00000097          	auipc	ra,0x0
    80006086:	354080e7          	jalr	852(ra) # 800063d6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000608a:	00233797          	auipc	a5,0x233
    8000608e:	96678793          	addi	a5,a5,-1690 # 802389f0 <devsw>
    80006092:	00000717          	auipc	a4,0x0
    80006096:	cce70713          	addi	a4,a4,-818 # 80005d60 <consoleread>
    8000609a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000609c:	00000717          	auipc	a4,0x0
    800060a0:	c5670713          	addi	a4,a4,-938 # 80005cf2 <consolewrite>
    800060a4:	ef98                	sd	a4,24(a5)
}
    800060a6:	60a2                	ld	ra,8(sp)
    800060a8:	6402                	ld	s0,0(sp)
    800060aa:	0141                	addi	sp,sp,16
    800060ac:	8082                	ret

00000000800060ae <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800060ae:	7179                	addi	sp,sp,-48
    800060b0:	f406                	sd	ra,40(sp)
    800060b2:	f022                	sd	s0,32(sp)
    800060b4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800060b6:	c219                	beqz	a2,800060bc <printint+0xe>
    800060b8:	08054963          	bltz	a0,8000614a <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800060bc:	2501                	sext.w	a0,a0
    800060be:	4881                	li	a7,0
    800060c0:	fd040693          	addi	a3,s0,-48

  i = 0;
    800060c4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800060c6:	2581                	sext.w	a1,a1
    800060c8:	00002617          	auipc	a2,0x2
    800060cc:	7d860613          	addi	a2,a2,2008 # 800088a0 <digits>
    800060d0:	883a                	mv	a6,a4
    800060d2:	2705                	addiw	a4,a4,1
    800060d4:	02b577bb          	remuw	a5,a0,a1
    800060d8:	1782                	slli	a5,a5,0x20
    800060da:	9381                	srli	a5,a5,0x20
    800060dc:	97b2                	add	a5,a5,a2
    800060de:	0007c783          	lbu	a5,0(a5)
    800060e2:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800060e6:	0005079b          	sext.w	a5,a0
    800060ea:	02b5553b          	divuw	a0,a0,a1
    800060ee:	0685                	addi	a3,a3,1
    800060f0:	feb7f0e3          	bgeu	a5,a1,800060d0 <printint+0x22>

  if(sign)
    800060f4:	00088c63          	beqz	a7,8000610c <printint+0x5e>
    buf[i++] = '-';
    800060f8:	fe070793          	addi	a5,a4,-32
    800060fc:	00878733          	add	a4,a5,s0
    80006100:	02d00793          	li	a5,45
    80006104:	fef70823          	sb	a5,-16(a4)
    80006108:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000610c:	02e05b63          	blez	a4,80006142 <printint+0x94>
    80006110:	ec26                	sd	s1,24(sp)
    80006112:	e84a                	sd	s2,16(sp)
    80006114:	fd040793          	addi	a5,s0,-48
    80006118:	00e784b3          	add	s1,a5,a4
    8000611c:	fff78913          	addi	s2,a5,-1
    80006120:	993a                	add	s2,s2,a4
    80006122:	377d                	addiw	a4,a4,-1
    80006124:	1702                	slli	a4,a4,0x20
    80006126:	9301                	srli	a4,a4,0x20
    80006128:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000612c:	fff4c503          	lbu	a0,-1(s1)
    80006130:	00000097          	auipc	ra,0x0
    80006134:	d56080e7          	jalr	-682(ra) # 80005e86 <consputc>
  while(--i >= 0)
    80006138:	14fd                	addi	s1,s1,-1
    8000613a:	ff2499e3          	bne	s1,s2,8000612c <printint+0x7e>
    8000613e:	64e2                	ld	s1,24(sp)
    80006140:	6942                	ld	s2,16(sp)
}
    80006142:	70a2                	ld	ra,40(sp)
    80006144:	7402                	ld	s0,32(sp)
    80006146:	6145                	addi	sp,sp,48
    80006148:	8082                	ret
    x = -xx;
    8000614a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000614e:	4885                	li	a7,1
    x = -xx;
    80006150:	bf85                	j	800060c0 <printint+0x12>

0000000080006152 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006152:	1101                	addi	sp,sp,-32
    80006154:	ec06                	sd	ra,24(sp)
    80006156:	e822                	sd	s0,16(sp)
    80006158:	e426                	sd	s1,8(sp)
    8000615a:	1000                	addi	s0,sp,32
    8000615c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000615e:	0023c797          	auipc	a5,0x23c
    80006162:	c207a923          	sw	zero,-974(a5) # 80241d90 <pr+0x18>
  printf("panic: ");
    80006166:	00002517          	auipc	a0,0x2
    8000616a:	5e250513          	addi	a0,a0,1506 # 80008748 <etext+0x748>
    8000616e:	00000097          	auipc	ra,0x0
    80006172:	02e080e7          	jalr	46(ra) # 8000619c <printf>
  printf(s);
    80006176:	8526                	mv	a0,s1
    80006178:	00000097          	auipc	ra,0x0
    8000617c:	024080e7          	jalr	36(ra) # 8000619c <printf>
  printf("\n");
    80006180:	00002517          	auipc	a0,0x2
    80006184:	ea050513          	addi	a0,a0,-352 # 80008020 <etext+0x20>
    80006188:	00000097          	auipc	ra,0x0
    8000618c:	014080e7          	jalr	20(ra) # 8000619c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006190:	4785                	li	a5,1
    80006192:	00002717          	auipc	a4,0x2
    80006196:	78f72d23          	sw	a5,1946(a4) # 8000892c <panicked>
  for(;;)
    8000619a:	a001                	j	8000619a <panic+0x48>

000000008000619c <printf>:
{
    8000619c:	7131                	addi	sp,sp,-192
    8000619e:	fc86                	sd	ra,120(sp)
    800061a0:	f8a2                	sd	s0,112(sp)
    800061a2:	e8d2                	sd	s4,80(sp)
    800061a4:	f06a                	sd	s10,32(sp)
    800061a6:	0100                	addi	s0,sp,128
    800061a8:	8a2a                	mv	s4,a0
    800061aa:	e40c                	sd	a1,8(s0)
    800061ac:	e810                	sd	a2,16(s0)
    800061ae:	ec14                	sd	a3,24(s0)
    800061b0:	f018                	sd	a4,32(s0)
    800061b2:	f41c                	sd	a5,40(s0)
    800061b4:	03043823          	sd	a6,48(s0)
    800061b8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800061bc:	0023cd17          	auipc	s10,0x23c
    800061c0:	bd4d2d03          	lw	s10,-1068(s10) # 80241d90 <pr+0x18>
  if(locking)
    800061c4:	040d1463          	bnez	s10,8000620c <printf+0x70>
  if (fmt == 0)
    800061c8:	040a0b63          	beqz	s4,8000621e <printf+0x82>
  va_start(ap, fmt);
    800061cc:	00840793          	addi	a5,s0,8
    800061d0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061d4:	000a4503          	lbu	a0,0(s4)
    800061d8:	18050b63          	beqz	a0,8000636e <printf+0x1d2>
    800061dc:	f4a6                	sd	s1,104(sp)
    800061de:	f0ca                	sd	s2,96(sp)
    800061e0:	ecce                	sd	s3,88(sp)
    800061e2:	e4d6                	sd	s5,72(sp)
    800061e4:	e0da                	sd	s6,64(sp)
    800061e6:	fc5e                	sd	s7,56(sp)
    800061e8:	f862                	sd	s8,48(sp)
    800061ea:	f466                	sd	s9,40(sp)
    800061ec:	ec6e                	sd	s11,24(sp)
    800061ee:	4981                	li	s3,0
    if(c != '%'){
    800061f0:	02500b13          	li	s6,37
    switch(c){
    800061f4:	07000b93          	li	s7,112
  consputc('x');
    800061f8:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800061fa:	00002a97          	auipc	s5,0x2
    800061fe:	6a6a8a93          	addi	s5,s5,1702 # 800088a0 <digits>
    switch(c){
    80006202:	07300c13          	li	s8,115
    80006206:	06400d93          	li	s11,100
    8000620a:	a0b1                	j	80006256 <printf+0xba>
    acquire(&pr.lock);
    8000620c:	0023c517          	auipc	a0,0x23c
    80006210:	b6c50513          	addi	a0,a0,-1172 # 80241d78 <pr>
    80006214:	00000097          	auipc	ra,0x0
    80006218:	4b8080e7          	jalr	1208(ra) # 800066cc <acquire>
    8000621c:	b775                	j	800061c8 <printf+0x2c>
    8000621e:	f4a6                	sd	s1,104(sp)
    80006220:	f0ca                	sd	s2,96(sp)
    80006222:	ecce                	sd	s3,88(sp)
    80006224:	e4d6                	sd	s5,72(sp)
    80006226:	e0da                	sd	s6,64(sp)
    80006228:	fc5e                	sd	s7,56(sp)
    8000622a:	f862                	sd	s8,48(sp)
    8000622c:	f466                	sd	s9,40(sp)
    8000622e:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80006230:	00002517          	auipc	a0,0x2
    80006234:	52850513          	addi	a0,a0,1320 # 80008758 <etext+0x758>
    80006238:	00000097          	auipc	ra,0x0
    8000623c:	f1a080e7          	jalr	-230(ra) # 80006152 <panic>
      consputc(c);
    80006240:	00000097          	auipc	ra,0x0
    80006244:	c46080e7          	jalr	-954(ra) # 80005e86 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006248:	2985                	addiw	s3,s3,1
    8000624a:	013a07b3          	add	a5,s4,s3
    8000624e:	0007c503          	lbu	a0,0(a5)
    80006252:	10050563          	beqz	a0,8000635c <printf+0x1c0>
    if(c != '%'){
    80006256:	ff6515e3          	bne	a0,s6,80006240 <printf+0xa4>
    c = fmt[++i] & 0xff;
    8000625a:	2985                	addiw	s3,s3,1
    8000625c:	013a07b3          	add	a5,s4,s3
    80006260:	0007c783          	lbu	a5,0(a5)
    80006264:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006268:	10078b63          	beqz	a5,8000637e <printf+0x1e2>
    switch(c){
    8000626c:	05778a63          	beq	a5,s7,800062c0 <printf+0x124>
    80006270:	02fbf663          	bgeu	s7,a5,8000629c <printf+0x100>
    80006274:	09878863          	beq	a5,s8,80006304 <printf+0x168>
    80006278:	07800713          	li	a4,120
    8000627c:	0ce79563          	bne	a5,a4,80006346 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80006280:	f8843783          	ld	a5,-120(s0)
    80006284:	00878713          	addi	a4,a5,8
    80006288:	f8e43423          	sd	a4,-120(s0)
    8000628c:	4605                	li	a2,1
    8000628e:	85e6                	mv	a1,s9
    80006290:	4388                	lw	a0,0(a5)
    80006292:	00000097          	auipc	ra,0x0
    80006296:	e1c080e7          	jalr	-484(ra) # 800060ae <printint>
      break;
    8000629a:	b77d                	j	80006248 <printf+0xac>
    switch(c){
    8000629c:	09678f63          	beq	a5,s6,8000633a <printf+0x19e>
    800062a0:	0bb79363          	bne	a5,s11,80006346 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800062a4:	f8843783          	ld	a5,-120(s0)
    800062a8:	00878713          	addi	a4,a5,8
    800062ac:	f8e43423          	sd	a4,-120(s0)
    800062b0:	4605                	li	a2,1
    800062b2:	45a9                	li	a1,10
    800062b4:	4388                	lw	a0,0(a5)
    800062b6:	00000097          	auipc	ra,0x0
    800062ba:	df8080e7          	jalr	-520(ra) # 800060ae <printint>
      break;
    800062be:	b769                	j	80006248 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800062c0:	f8843783          	ld	a5,-120(s0)
    800062c4:	00878713          	addi	a4,a5,8
    800062c8:	f8e43423          	sd	a4,-120(s0)
    800062cc:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800062d0:	03000513          	li	a0,48
    800062d4:	00000097          	auipc	ra,0x0
    800062d8:	bb2080e7          	jalr	-1102(ra) # 80005e86 <consputc>
  consputc('x');
    800062dc:	07800513          	li	a0,120
    800062e0:	00000097          	auipc	ra,0x0
    800062e4:	ba6080e7          	jalr	-1114(ra) # 80005e86 <consputc>
    800062e8:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800062ea:	03c95793          	srli	a5,s2,0x3c
    800062ee:	97d6                	add	a5,a5,s5
    800062f0:	0007c503          	lbu	a0,0(a5)
    800062f4:	00000097          	auipc	ra,0x0
    800062f8:	b92080e7          	jalr	-1134(ra) # 80005e86 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800062fc:	0912                	slli	s2,s2,0x4
    800062fe:	34fd                	addiw	s1,s1,-1
    80006300:	f4ed                	bnez	s1,800062ea <printf+0x14e>
    80006302:	b799                	j	80006248 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80006304:	f8843783          	ld	a5,-120(s0)
    80006308:	00878713          	addi	a4,a5,8
    8000630c:	f8e43423          	sd	a4,-120(s0)
    80006310:	6384                	ld	s1,0(a5)
    80006312:	cc89                	beqz	s1,8000632c <printf+0x190>
      for(; *s; s++)
    80006314:	0004c503          	lbu	a0,0(s1)
    80006318:	d905                	beqz	a0,80006248 <printf+0xac>
        consputc(*s);
    8000631a:	00000097          	auipc	ra,0x0
    8000631e:	b6c080e7          	jalr	-1172(ra) # 80005e86 <consputc>
      for(; *s; s++)
    80006322:	0485                	addi	s1,s1,1
    80006324:	0004c503          	lbu	a0,0(s1)
    80006328:	f96d                	bnez	a0,8000631a <printf+0x17e>
    8000632a:	bf39                	j	80006248 <printf+0xac>
        s = "(null)";
    8000632c:	00002497          	auipc	s1,0x2
    80006330:	42448493          	addi	s1,s1,1060 # 80008750 <etext+0x750>
      for(; *s; s++)
    80006334:	02800513          	li	a0,40
    80006338:	b7cd                	j	8000631a <printf+0x17e>
      consputc('%');
    8000633a:	855a                	mv	a0,s6
    8000633c:	00000097          	auipc	ra,0x0
    80006340:	b4a080e7          	jalr	-1206(ra) # 80005e86 <consputc>
      break;
    80006344:	b711                	j	80006248 <printf+0xac>
      consputc('%');
    80006346:	855a                	mv	a0,s6
    80006348:	00000097          	auipc	ra,0x0
    8000634c:	b3e080e7          	jalr	-1218(ra) # 80005e86 <consputc>
      consputc(c);
    80006350:	8526                	mv	a0,s1
    80006352:	00000097          	auipc	ra,0x0
    80006356:	b34080e7          	jalr	-1228(ra) # 80005e86 <consputc>
      break;
    8000635a:	b5fd                	j	80006248 <printf+0xac>
    8000635c:	74a6                	ld	s1,104(sp)
    8000635e:	7906                	ld	s2,96(sp)
    80006360:	69e6                	ld	s3,88(sp)
    80006362:	6aa6                	ld	s5,72(sp)
    80006364:	6b06                	ld	s6,64(sp)
    80006366:	7be2                	ld	s7,56(sp)
    80006368:	7c42                	ld	s8,48(sp)
    8000636a:	7ca2                	ld	s9,40(sp)
    8000636c:	6de2                	ld	s11,24(sp)
  if(locking)
    8000636e:	020d1263          	bnez	s10,80006392 <printf+0x1f6>
}
    80006372:	70e6                	ld	ra,120(sp)
    80006374:	7446                	ld	s0,112(sp)
    80006376:	6a46                	ld	s4,80(sp)
    80006378:	7d02                	ld	s10,32(sp)
    8000637a:	6129                	addi	sp,sp,192
    8000637c:	8082                	ret
    8000637e:	74a6                	ld	s1,104(sp)
    80006380:	7906                	ld	s2,96(sp)
    80006382:	69e6                	ld	s3,88(sp)
    80006384:	6aa6                	ld	s5,72(sp)
    80006386:	6b06                	ld	s6,64(sp)
    80006388:	7be2                	ld	s7,56(sp)
    8000638a:	7c42                	ld	s8,48(sp)
    8000638c:	7ca2                	ld	s9,40(sp)
    8000638e:	6de2                	ld	s11,24(sp)
    80006390:	bff9                	j	8000636e <printf+0x1d2>
    release(&pr.lock);
    80006392:	0023c517          	auipc	a0,0x23c
    80006396:	9e650513          	addi	a0,a0,-1562 # 80241d78 <pr>
    8000639a:	00000097          	auipc	ra,0x0
    8000639e:	3e6080e7          	jalr	998(ra) # 80006780 <release>
}
    800063a2:	bfc1                	j	80006372 <printf+0x1d6>

00000000800063a4 <printfinit>:
    ;
}

void
printfinit(void)
{
    800063a4:	1101                	addi	sp,sp,-32
    800063a6:	ec06                	sd	ra,24(sp)
    800063a8:	e822                	sd	s0,16(sp)
    800063aa:	e426                	sd	s1,8(sp)
    800063ac:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800063ae:	0023c497          	auipc	s1,0x23c
    800063b2:	9ca48493          	addi	s1,s1,-1590 # 80241d78 <pr>
    800063b6:	00002597          	auipc	a1,0x2
    800063ba:	3b258593          	addi	a1,a1,946 # 80008768 <etext+0x768>
    800063be:	8526                	mv	a0,s1
    800063c0:	00000097          	auipc	ra,0x0
    800063c4:	27c080e7          	jalr	636(ra) # 8000663c <initlock>
  pr.locking = 1;
    800063c8:	4785                	li	a5,1
    800063ca:	cc9c                	sw	a5,24(s1)
}
    800063cc:	60e2                	ld	ra,24(sp)
    800063ce:	6442                	ld	s0,16(sp)
    800063d0:	64a2                	ld	s1,8(sp)
    800063d2:	6105                	addi	sp,sp,32
    800063d4:	8082                	ret

00000000800063d6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800063d6:	1141                	addi	sp,sp,-16
    800063d8:	e406                	sd	ra,8(sp)
    800063da:	e022                	sd	s0,0(sp)
    800063dc:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800063de:	100007b7          	lui	a5,0x10000
    800063e2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800063e6:	10000737          	lui	a4,0x10000
    800063ea:	f8000693          	li	a3,-128
    800063ee:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800063f2:	468d                	li	a3,3
    800063f4:	10000637          	lui	a2,0x10000
    800063f8:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800063fc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006400:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006404:	10000737          	lui	a4,0x10000
    80006408:	461d                	li	a2,7
    8000640a:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000640e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006412:	00002597          	auipc	a1,0x2
    80006416:	35e58593          	addi	a1,a1,862 # 80008770 <etext+0x770>
    8000641a:	0023c517          	auipc	a0,0x23c
    8000641e:	97e50513          	addi	a0,a0,-1666 # 80241d98 <uart_tx_lock>
    80006422:	00000097          	auipc	ra,0x0
    80006426:	21a080e7          	jalr	538(ra) # 8000663c <initlock>
}
    8000642a:	60a2                	ld	ra,8(sp)
    8000642c:	6402                	ld	s0,0(sp)
    8000642e:	0141                	addi	sp,sp,16
    80006430:	8082                	ret

0000000080006432 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006432:	1101                	addi	sp,sp,-32
    80006434:	ec06                	sd	ra,24(sp)
    80006436:	e822                	sd	s0,16(sp)
    80006438:	e426                	sd	s1,8(sp)
    8000643a:	1000                	addi	s0,sp,32
    8000643c:	84aa                	mv	s1,a0
  push_off();
    8000643e:	00000097          	auipc	ra,0x0
    80006442:	242080e7          	jalr	578(ra) # 80006680 <push_off>

  if(panicked){
    80006446:	00002797          	auipc	a5,0x2
    8000644a:	4e67a783          	lw	a5,1254(a5) # 8000892c <panicked>
    8000644e:	eb85                	bnez	a5,8000647e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006450:	10000737          	lui	a4,0x10000
    80006454:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006456:	00074783          	lbu	a5,0(a4)
    8000645a:	0207f793          	andi	a5,a5,32
    8000645e:	dfe5                	beqz	a5,80006456 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006460:	0ff4f513          	zext.b	a0,s1
    80006464:	100007b7          	lui	a5,0x10000
    80006468:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000646c:	00000097          	auipc	ra,0x0
    80006470:	2b4080e7          	jalr	692(ra) # 80006720 <pop_off>
}
    80006474:	60e2                	ld	ra,24(sp)
    80006476:	6442                	ld	s0,16(sp)
    80006478:	64a2                	ld	s1,8(sp)
    8000647a:	6105                	addi	sp,sp,32
    8000647c:	8082                	ret
    for(;;)
    8000647e:	a001                	j	8000647e <uartputc_sync+0x4c>

0000000080006480 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006480:	00002797          	auipc	a5,0x2
    80006484:	4b07b783          	ld	a5,1200(a5) # 80008930 <uart_tx_r>
    80006488:	00002717          	auipc	a4,0x2
    8000648c:	4b073703          	ld	a4,1200(a4) # 80008938 <uart_tx_w>
    80006490:	06f70f63          	beq	a4,a5,8000650e <uartstart+0x8e>
{
    80006494:	7139                	addi	sp,sp,-64
    80006496:	fc06                	sd	ra,56(sp)
    80006498:	f822                	sd	s0,48(sp)
    8000649a:	f426                	sd	s1,40(sp)
    8000649c:	f04a                	sd	s2,32(sp)
    8000649e:	ec4e                	sd	s3,24(sp)
    800064a0:	e852                	sd	s4,16(sp)
    800064a2:	e456                	sd	s5,8(sp)
    800064a4:	e05a                	sd	s6,0(sp)
    800064a6:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800064a8:	10000937          	lui	s2,0x10000
    800064ac:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800064ae:	0023ca97          	auipc	s5,0x23c
    800064b2:	8eaa8a93          	addi	s5,s5,-1814 # 80241d98 <uart_tx_lock>
    uart_tx_r += 1;
    800064b6:	00002497          	auipc	s1,0x2
    800064ba:	47a48493          	addi	s1,s1,1146 # 80008930 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800064be:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800064c2:	00002997          	auipc	s3,0x2
    800064c6:	47698993          	addi	s3,s3,1142 # 80008938 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800064ca:	00094703          	lbu	a4,0(s2)
    800064ce:	02077713          	andi	a4,a4,32
    800064d2:	c705                	beqz	a4,800064fa <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800064d4:	01f7f713          	andi	a4,a5,31
    800064d8:	9756                	add	a4,a4,s5
    800064da:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800064de:	0785                	addi	a5,a5,1
    800064e0:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800064e2:	8526                	mv	a0,s1
    800064e4:	ffffb097          	auipc	ra,0xffffb
    800064e8:	3be080e7          	jalr	958(ra) # 800018a2 <wakeup>
    WriteReg(THR, c);
    800064ec:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800064f0:	609c                	ld	a5,0(s1)
    800064f2:	0009b703          	ld	a4,0(s3)
    800064f6:	fcf71ae3          	bne	a4,a5,800064ca <uartstart+0x4a>
  }
}
    800064fa:	70e2                	ld	ra,56(sp)
    800064fc:	7442                	ld	s0,48(sp)
    800064fe:	74a2                	ld	s1,40(sp)
    80006500:	7902                	ld	s2,32(sp)
    80006502:	69e2                	ld	s3,24(sp)
    80006504:	6a42                	ld	s4,16(sp)
    80006506:	6aa2                	ld	s5,8(sp)
    80006508:	6b02                	ld	s6,0(sp)
    8000650a:	6121                	addi	sp,sp,64
    8000650c:	8082                	ret
    8000650e:	8082                	ret

0000000080006510 <uartputc>:
{
    80006510:	7179                	addi	sp,sp,-48
    80006512:	f406                	sd	ra,40(sp)
    80006514:	f022                	sd	s0,32(sp)
    80006516:	ec26                	sd	s1,24(sp)
    80006518:	e84a                	sd	s2,16(sp)
    8000651a:	e44e                	sd	s3,8(sp)
    8000651c:	e052                	sd	s4,0(sp)
    8000651e:	1800                	addi	s0,sp,48
    80006520:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006522:	0023c517          	auipc	a0,0x23c
    80006526:	87650513          	addi	a0,a0,-1930 # 80241d98 <uart_tx_lock>
    8000652a:	00000097          	auipc	ra,0x0
    8000652e:	1a2080e7          	jalr	418(ra) # 800066cc <acquire>
  if(panicked){
    80006532:	00002797          	auipc	a5,0x2
    80006536:	3fa7a783          	lw	a5,1018(a5) # 8000892c <panicked>
    8000653a:	e7c9                	bnez	a5,800065c4 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000653c:	00002717          	auipc	a4,0x2
    80006540:	3fc73703          	ld	a4,1020(a4) # 80008938 <uart_tx_w>
    80006544:	00002797          	auipc	a5,0x2
    80006548:	3ec7b783          	ld	a5,1004(a5) # 80008930 <uart_tx_r>
    8000654c:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006550:	0023c997          	auipc	s3,0x23c
    80006554:	84898993          	addi	s3,s3,-1976 # 80241d98 <uart_tx_lock>
    80006558:	00002497          	auipc	s1,0x2
    8000655c:	3d848493          	addi	s1,s1,984 # 80008930 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006560:	00002917          	auipc	s2,0x2
    80006564:	3d890913          	addi	s2,s2,984 # 80008938 <uart_tx_w>
    80006568:	00e79f63          	bne	a5,a4,80006586 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000656c:	85ce                	mv	a1,s3
    8000656e:	8526                	mv	a0,s1
    80006570:	ffffb097          	auipc	ra,0xffffb
    80006574:	2ce080e7          	jalr	718(ra) # 8000183e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006578:	00093703          	ld	a4,0(s2)
    8000657c:	609c                	ld	a5,0(s1)
    8000657e:	02078793          	addi	a5,a5,32
    80006582:	fee785e3          	beq	a5,a4,8000656c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006586:	0023c497          	auipc	s1,0x23c
    8000658a:	81248493          	addi	s1,s1,-2030 # 80241d98 <uart_tx_lock>
    8000658e:	01f77793          	andi	a5,a4,31
    80006592:	97a6                	add	a5,a5,s1
    80006594:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006598:	0705                	addi	a4,a4,1
    8000659a:	00002797          	auipc	a5,0x2
    8000659e:	38e7bf23          	sd	a4,926(a5) # 80008938 <uart_tx_w>
  uartstart();
    800065a2:	00000097          	auipc	ra,0x0
    800065a6:	ede080e7          	jalr	-290(ra) # 80006480 <uartstart>
  release(&uart_tx_lock);
    800065aa:	8526                	mv	a0,s1
    800065ac:	00000097          	auipc	ra,0x0
    800065b0:	1d4080e7          	jalr	468(ra) # 80006780 <release>
}
    800065b4:	70a2                	ld	ra,40(sp)
    800065b6:	7402                	ld	s0,32(sp)
    800065b8:	64e2                	ld	s1,24(sp)
    800065ba:	6942                	ld	s2,16(sp)
    800065bc:	69a2                	ld	s3,8(sp)
    800065be:	6a02                	ld	s4,0(sp)
    800065c0:	6145                	addi	sp,sp,48
    800065c2:	8082                	ret
    for(;;)
    800065c4:	a001                	j	800065c4 <uartputc+0xb4>

00000000800065c6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800065c6:	1141                	addi	sp,sp,-16
    800065c8:	e422                	sd	s0,8(sp)
    800065ca:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800065cc:	100007b7          	lui	a5,0x10000
    800065d0:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800065d2:	0007c783          	lbu	a5,0(a5)
    800065d6:	8b85                	andi	a5,a5,1
    800065d8:	cb81                	beqz	a5,800065e8 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800065da:	100007b7          	lui	a5,0x10000
    800065de:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800065e2:	6422                	ld	s0,8(sp)
    800065e4:	0141                	addi	sp,sp,16
    800065e6:	8082                	ret
    return -1;
    800065e8:	557d                	li	a0,-1
    800065ea:	bfe5                	j	800065e2 <uartgetc+0x1c>

00000000800065ec <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800065ec:	1101                	addi	sp,sp,-32
    800065ee:	ec06                	sd	ra,24(sp)
    800065f0:	e822                	sd	s0,16(sp)
    800065f2:	e426                	sd	s1,8(sp)
    800065f4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800065f6:	54fd                	li	s1,-1
    800065f8:	a029                	j	80006602 <uartintr+0x16>
      break;
    consoleintr(c);
    800065fa:	00000097          	auipc	ra,0x0
    800065fe:	8ce080e7          	jalr	-1842(ra) # 80005ec8 <consoleintr>
    int c = uartgetc();
    80006602:	00000097          	auipc	ra,0x0
    80006606:	fc4080e7          	jalr	-60(ra) # 800065c6 <uartgetc>
    if(c == -1)
    8000660a:	fe9518e3          	bne	a0,s1,800065fa <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000660e:	0023b497          	auipc	s1,0x23b
    80006612:	78a48493          	addi	s1,s1,1930 # 80241d98 <uart_tx_lock>
    80006616:	8526                	mv	a0,s1
    80006618:	00000097          	auipc	ra,0x0
    8000661c:	0b4080e7          	jalr	180(ra) # 800066cc <acquire>
  uartstart();
    80006620:	00000097          	auipc	ra,0x0
    80006624:	e60080e7          	jalr	-416(ra) # 80006480 <uartstart>
  release(&uart_tx_lock);
    80006628:	8526                	mv	a0,s1
    8000662a:	00000097          	auipc	ra,0x0
    8000662e:	156080e7          	jalr	342(ra) # 80006780 <release>
}
    80006632:	60e2                	ld	ra,24(sp)
    80006634:	6442                	ld	s0,16(sp)
    80006636:	64a2                	ld	s1,8(sp)
    80006638:	6105                	addi	sp,sp,32
    8000663a:	8082                	ret

000000008000663c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000663c:	1141                	addi	sp,sp,-16
    8000663e:	e422                	sd	s0,8(sp)
    80006640:	0800                	addi	s0,sp,16
  lk->name = name;
    80006642:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006644:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006648:	00053823          	sd	zero,16(a0)
}
    8000664c:	6422                	ld	s0,8(sp)
    8000664e:	0141                	addi	sp,sp,16
    80006650:	8082                	ret

0000000080006652 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006652:	411c                	lw	a5,0(a0)
    80006654:	e399                	bnez	a5,8000665a <holding+0x8>
    80006656:	4501                	li	a0,0
  return r;
}
    80006658:	8082                	ret
{
    8000665a:	1101                	addi	sp,sp,-32
    8000665c:	ec06                	sd	ra,24(sp)
    8000665e:	e822                	sd	s0,16(sp)
    80006660:	e426                	sd	s1,8(sp)
    80006662:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006664:	6904                	ld	s1,16(a0)
    80006666:	ffffb097          	auipc	ra,0xffffb
    8000666a:	b0e080e7          	jalr	-1266(ra) # 80001174 <mycpu>
    8000666e:	40a48533          	sub	a0,s1,a0
    80006672:	00153513          	seqz	a0,a0
}
    80006676:	60e2                	ld	ra,24(sp)
    80006678:	6442                	ld	s0,16(sp)
    8000667a:	64a2                	ld	s1,8(sp)
    8000667c:	6105                	addi	sp,sp,32
    8000667e:	8082                	ret

0000000080006680 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006680:	1101                	addi	sp,sp,-32
    80006682:	ec06                	sd	ra,24(sp)
    80006684:	e822                	sd	s0,16(sp)
    80006686:	e426                	sd	s1,8(sp)
    80006688:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000668a:	100024f3          	csrr	s1,sstatus
    8000668e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006692:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006694:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006698:	ffffb097          	auipc	ra,0xffffb
    8000669c:	adc080e7          	jalr	-1316(ra) # 80001174 <mycpu>
    800066a0:	5d3c                	lw	a5,120(a0)
    800066a2:	cf89                	beqz	a5,800066bc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800066a4:	ffffb097          	auipc	ra,0xffffb
    800066a8:	ad0080e7          	jalr	-1328(ra) # 80001174 <mycpu>
    800066ac:	5d3c                	lw	a5,120(a0)
    800066ae:	2785                	addiw	a5,a5,1
    800066b0:	dd3c                	sw	a5,120(a0)
}
    800066b2:	60e2                	ld	ra,24(sp)
    800066b4:	6442                	ld	s0,16(sp)
    800066b6:	64a2                	ld	s1,8(sp)
    800066b8:	6105                	addi	sp,sp,32
    800066ba:	8082                	ret
    mycpu()->intena = old;
    800066bc:	ffffb097          	auipc	ra,0xffffb
    800066c0:	ab8080e7          	jalr	-1352(ra) # 80001174 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800066c4:	8085                	srli	s1,s1,0x1
    800066c6:	8885                	andi	s1,s1,1
    800066c8:	dd64                	sw	s1,124(a0)
    800066ca:	bfe9                	j	800066a4 <push_off+0x24>

00000000800066cc <acquire>:
{
    800066cc:	1101                	addi	sp,sp,-32
    800066ce:	ec06                	sd	ra,24(sp)
    800066d0:	e822                	sd	s0,16(sp)
    800066d2:	e426                	sd	s1,8(sp)
    800066d4:	1000                	addi	s0,sp,32
    800066d6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800066d8:	00000097          	auipc	ra,0x0
    800066dc:	fa8080e7          	jalr	-88(ra) # 80006680 <push_off>
  if(holding(lk))
    800066e0:	8526                	mv	a0,s1
    800066e2:	00000097          	auipc	ra,0x0
    800066e6:	f70080e7          	jalr	-144(ra) # 80006652 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800066ea:	4705                	li	a4,1
  if(holding(lk))
    800066ec:	e115                	bnez	a0,80006710 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800066ee:	87ba                	mv	a5,a4
    800066f0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800066f4:	2781                	sext.w	a5,a5
    800066f6:	ffe5                	bnez	a5,800066ee <acquire+0x22>
  __sync_synchronize();
    800066f8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800066fc:	ffffb097          	auipc	ra,0xffffb
    80006700:	a78080e7          	jalr	-1416(ra) # 80001174 <mycpu>
    80006704:	e888                	sd	a0,16(s1)
}
    80006706:	60e2                	ld	ra,24(sp)
    80006708:	6442                	ld	s0,16(sp)
    8000670a:	64a2                	ld	s1,8(sp)
    8000670c:	6105                	addi	sp,sp,32
    8000670e:	8082                	ret
    panic("acquire");
    80006710:	00002517          	auipc	a0,0x2
    80006714:	06850513          	addi	a0,a0,104 # 80008778 <etext+0x778>
    80006718:	00000097          	auipc	ra,0x0
    8000671c:	a3a080e7          	jalr	-1478(ra) # 80006152 <panic>

0000000080006720 <pop_off>:

void
pop_off(void)
{
    80006720:	1141                	addi	sp,sp,-16
    80006722:	e406                	sd	ra,8(sp)
    80006724:	e022                	sd	s0,0(sp)
    80006726:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006728:	ffffb097          	auipc	ra,0xffffb
    8000672c:	a4c080e7          	jalr	-1460(ra) # 80001174 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006730:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006734:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006736:	e78d                	bnez	a5,80006760 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006738:	5d3c                	lw	a5,120(a0)
    8000673a:	02f05b63          	blez	a5,80006770 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000673e:	37fd                	addiw	a5,a5,-1
    80006740:	0007871b          	sext.w	a4,a5
    80006744:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006746:	eb09                	bnez	a4,80006758 <pop_off+0x38>
    80006748:	5d7c                	lw	a5,124(a0)
    8000674a:	c799                	beqz	a5,80006758 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000674c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006750:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006754:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006758:	60a2                	ld	ra,8(sp)
    8000675a:	6402                	ld	s0,0(sp)
    8000675c:	0141                	addi	sp,sp,16
    8000675e:	8082                	ret
    panic("pop_off - interruptible");
    80006760:	00002517          	auipc	a0,0x2
    80006764:	02050513          	addi	a0,a0,32 # 80008780 <etext+0x780>
    80006768:	00000097          	auipc	ra,0x0
    8000676c:	9ea080e7          	jalr	-1558(ra) # 80006152 <panic>
    panic("pop_off");
    80006770:	00002517          	auipc	a0,0x2
    80006774:	02850513          	addi	a0,a0,40 # 80008798 <etext+0x798>
    80006778:	00000097          	auipc	ra,0x0
    8000677c:	9da080e7          	jalr	-1574(ra) # 80006152 <panic>

0000000080006780 <release>:
{
    80006780:	1101                	addi	sp,sp,-32
    80006782:	ec06                	sd	ra,24(sp)
    80006784:	e822                	sd	s0,16(sp)
    80006786:	e426                	sd	s1,8(sp)
    80006788:	1000                	addi	s0,sp,32
    8000678a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000678c:	00000097          	auipc	ra,0x0
    80006790:	ec6080e7          	jalr	-314(ra) # 80006652 <holding>
    80006794:	c115                	beqz	a0,800067b8 <release+0x38>
  lk->cpu = 0;
    80006796:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000679a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000679e:	0f50000f          	fence	iorw,ow
    800067a2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800067a6:	00000097          	auipc	ra,0x0
    800067aa:	f7a080e7          	jalr	-134(ra) # 80006720 <pop_off>
}
    800067ae:	60e2                	ld	ra,24(sp)
    800067b0:	6442                	ld	s0,16(sp)
    800067b2:	64a2                	ld	s1,8(sp)
    800067b4:	6105                	addi	sp,sp,32
    800067b6:	8082                	ret
    panic("release");
    800067b8:	00002517          	auipc	a0,0x2
    800067bc:	fe850513          	addi	a0,a0,-24 # 800087a0 <etext+0x7a0>
    800067c0:	00000097          	auipc	ra,0x0
    800067c4:	992080e7          	jalr	-1646(ra) # 80006152 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
