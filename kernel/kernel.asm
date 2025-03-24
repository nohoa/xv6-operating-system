
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	c9010113          	addi	sp,sp,-880 # 80019c90 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0a9050ef          	jal	800058be <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	d6078793          	addi	a5,a5,-672 # 80021d90 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8d090913          	addi	s2,s2,-1840 # 80008920 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	32a080e7          	jalr	810(ra) # 80006384 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	3ca080e7          	jalr	970(ra) # 80006438 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	addi	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	daa080e7          	jalr	-598(ra) # 80005e34 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	addi	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	83250513          	addi	a0,a0,-1998 # 80008920 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	1fe080e7          	jalr	510(ra) # 800062f4 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	c8e50513          	addi	a0,a0,-882 # 80021d90 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00008497          	auipc	s1,0x8
    80000128:	7fc48493          	addi	s1,s1,2044 # 80008920 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	256080e7          	jalr	598(ra) # 80006384 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7e450513          	addi	a0,a0,2020 # 80008920 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	2f2080e7          	jalr	754(ra) # 80006438 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	7b850513          	addi	a0,a0,1976 # 80008920 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	2c8080e7          	jalr	712(ra) # 80006438 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd271>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	feb79ae3          	bne	a5,a1,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fef71ae3          	bne	a4,a5,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a801                	j	8000027a <strncmp+0x30>
    8000026c:	4501                	li	a0,0
    8000026e:	a031                	j	8000027a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret

0000000080000280 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000286:	87aa                	mv	a5,a0
    80000288:	86b2                	mv	a3,a2
    8000028a:	367d                	addiw	a2,a2,-1
    8000028c:	02d05563          	blez	a3,800002b6 <strncpy+0x36>
    80000290:	0785                	addi	a5,a5,1
    80000292:	0005c703          	lbu	a4,0(a1)
    80000296:	fee78fa3          	sb	a4,-1(a5)
    8000029a:	0585                	addi	a1,a1,1
    8000029c:	f775                	bnez	a4,80000288 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000029e:	873e                	mv	a4,a5
    800002a0:	9fb5                	addw	a5,a5,a3
    800002a2:	37fd                	addiw	a5,a5,-1
    800002a4:	00c05963          	blez	a2,800002b6 <strncpy+0x36>
    *s++ = 0;
    800002a8:	0705                	addi	a4,a4,1
    800002aa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002ae:	40e786bb          	subw	a3,a5,a4
    800002b2:	fed04be3          	bgtz	a3,800002a8 <strncpy+0x28>
  return os;
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	addi	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002bc:	1141                	addi	sp,sp,-16
    800002be:	e422                	sd	s0,8(sp)
    800002c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c2:	02c05363          	blez	a2,800002e8 <safestrcpy+0x2c>
    800002c6:	fff6069b          	addiw	a3,a2,-1
    800002ca:	1682                	slli	a3,a3,0x20
    800002cc:	9281                	srli	a3,a3,0x20
    800002ce:	96ae                	add	a3,a3,a1
    800002d0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d2:	00d58963          	beq	a1,a3,800002e4 <safestrcpy+0x28>
    800002d6:	0585                	addi	a1,a1,1
    800002d8:	0785                	addi	a5,a5,1
    800002da:	fff5c703          	lbu	a4,-1(a1)
    800002de:	fee78fa3          	sb	a4,-1(a5)
    800002e2:	fb65                	bnez	a4,800002d2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002e4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <strlen>:

int
strlen(const char *s)
{
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	cf91                	beqz	a5,80000314 <strlen+0x26>
    800002fa:	0505                	addi	a0,a0,1
    800002fc:	87aa                	mv	a5,a0
    800002fe:	86be                	mv	a3,a5
    80000300:	0785                	addi	a5,a5,1
    80000302:	fff7c703          	lbu	a4,-1(a5)
    80000306:	ff65                	bnez	a4,800002fe <strlen+0x10>
    80000308:	40a6853b          	subw	a0,a3,a0
    8000030c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret
  for(n = 0; s[n]; n++)
    80000314:	4501                	li	a0,0
    80000316:	bfe5                	j	8000030e <strlen+0x20>

0000000080000318 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000318:	1141                	addi	sp,sp,-16
    8000031a:	e406                	sd	ra,8(sp)
    8000031c:	e022                	sd	s0,0(sp)
    8000031e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000320:	00001097          	auipc	ra,0x1
    80000324:	bba080e7          	jalr	-1094(ra) # 80000eda <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000328:	00008717          	auipc	a4,0x8
    8000032c:	5c870713          	addi	a4,a4,1480 # 800088f0 <started>
  if(cpuid() == 0){
    80000330:	c139                	beqz	a0,80000376 <main+0x5e>
    while(started == 0)
    80000332:	431c                	lw	a5,0(a4)
    80000334:	2781                	sext.w	a5,a5
    80000336:	dff5                	beqz	a5,80000332 <main+0x1a>
      ;
    __sync_synchronize();
    80000338:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000033c:	00001097          	auipc	ra,0x1
    80000340:	b9e080e7          	jalr	-1122(ra) # 80000eda <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	b38080e7          	jalr	-1224(ra) # 80005e86 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	84c080e7          	jalr	-1972(ra) # 80001baa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	ece080e7          	jalr	-306(ra) # 80005234 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	094080e7          	jalr	148(ra) # 80001402 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	92c080e7          	jalr	-1748(ra) # 80005ca2 <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	a14080e7          	jalr	-1516(ra) # 80005d92 <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	af8080e7          	jalr	-1288(ra) # 80005e86 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	ae8080e7          	jalr	-1304(ra) # 80005e86 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	ad8080e7          	jalr	-1320(ra) # 80005e86 <printf>
    kinit();         // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	34a080e7          	jalr	842(ra) # 80000708 <kvminit>
    kvminithart();   // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	068080e7          	jalr	104(ra) # 8000042e <kvminithart>
    procinit();      // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	a4a080e7          	jalr	-1462(ra) # 80000e18 <procinit>
    trapinit();      // trap vectors
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	7ac080e7          	jalr	1964(ra) # 80001b82 <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	7cc080e7          	jalr	1996(ra) # 80001baa <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	e34080e7          	jalr	-460(ra) # 8000521a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	e46080e7          	jalr	-442(ra) # 80005234 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	f12080e7          	jalr	-238(ra) # 80002308 <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	5c8080e7          	jalr	1480(ra) # 800029c6 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	578080e7          	jalr	1400(ra) # 8000397e <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	f2e080e7          	jalr	-210(ra) # 8000533c <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	dcc080e7          	jalr	-564(ra) # 800011e2 <userinit>
    __sync_synchronize();
    8000041e:	0ff0000f          	fence
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	00008717          	auipc	a4,0x8
    80000428:	4cf72623          	sw	a5,1228(a4) # 800088f0 <started>
    8000042c:	b789                	j	8000036e <main+0x56>

000000008000042e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000042e:	1141                	addi	sp,sp,-16
    80000430:	e422                	sd	s0,8(sp)
    80000432:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000434:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000438:	00008797          	auipc	a5,0x8
    8000043c:	4c07b783          	ld	a5,1216(a5) # 800088f8 <kernel_pagetable>
    80000440:	83b1                	srli	a5,a5,0xc
    80000442:	577d                	li	a4,-1
    80000444:	177e                	slli	a4,a4,0x3f
    80000446:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000448:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000044c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000450:	6422                	ld	s0,8(sp)
    80000452:	0141                	addi	sp,sp,16
    80000454:	8082                	ret

0000000080000456 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000456:	7139                	addi	sp,sp,-64
    80000458:	fc06                	sd	ra,56(sp)
    8000045a:	f822                	sd	s0,48(sp)
    8000045c:	f426                	sd	s1,40(sp)
    8000045e:	f04a                	sd	s2,32(sp)
    80000460:	ec4e                	sd	s3,24(sp)
    80000462:	e852                	sd	s4,16(sp)
    80000464:	e456                	sd	s5,8(sp)
    80000466:	e05a                	sd	s6,0(sp)
    80000468:	0080                	addi	s0,sp,64
    8000046a:	84aa                	mv	s1,a0
    8000046c:	89ae                	mv	s3,a1
    8000046e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000470:	57fd                	li	a5,-1
    80000472:	83e9                	srli	a5,a5,0x1a
    80000474:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000476:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000478:	04b7f263          	bgeu	a5,a1,800004bc <walk+0x66>
    panic("walk");
    8000047c:	00008517          	auipc	a0,0x8
    80000480:	bd450513          	addi	a0,a0,-1068 # 80008050 <etext+0x50>
    80000484:	00006097          	auipc	ra,0x6
    80000488:	9b0080e7          	jalr	-1616(ra) # 80005e34 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000048c:	060a8663          	beqz	s5,800004f8 <walk+0xa2>
    80000490:	00000097          	auipc	ra,0x0
    80000494:	c8a080e7          	jalr	-886(ra) # 8000011a <kalloc>
    80000498:	84aa                	mv	s1,a0
    8000049a:	c529                	beqz	a0,800004e4 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000049c:	6605                	lui	a2,0x1
    8000049e:	4581                	li	a1,0
    800004a0:	00000097          	auipc	ra,0x0
    800004a4:	cda080e7          	jalr	-806(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004a8:	00c4d793          	srli	a5,s1,0xc
    800004ac:	07aa                	slli	a5,a5,0xa
    800004ae:	0017e793          	ori	a5,a5,1
    800004b2:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004b6:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd267>
    800004b8:	036a0063          	beq	s4,s6,800004d8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004bc:	0149d933          	srl	s2,s3,s4
    800004c0:	1ff97913          	andi	s2,s2,511
    800004c4:	090e                	slli	s2,s2,0x3
    800004c6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004c8:	00093483          	ld	s1,0(s2)
    800004cc:	0014f793          	andi	a5,s1,1
    800004d0:	dfd5                	beqz	a5,8000048c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d2:	80a9                	srli	s1,s1,0xa
    800004d4:	04b2                	slli	s1,s1,0xc
    800004d6:	b7c5                	j	800004b6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004d8:	00c9d513          	srli	a0,s3,0xc
    800004dc:	1ff57513          	andi	a0,a0,511
    800004e0:	050e                	slli	a0,a0,0x3
    800004e2:	9526                	add	a0,a0,s1
}
    800004e4:	70e2                	ld	ra,56(sp)
    800004e6:	7442                	ld	s0,48(sp)
    800004e8:	74a2                	ld	s1,40(sp)
    800004ea:	7902                	ld	s2,32(sp)
    800004ec:	69e2                	ld	s3,24(sp)
    800004ee:	6a42                	ld	s4,16(sp)
    800004f0:	6aa2                	ld	s5,8(sp)
    800004f2:	6b02                	ld	s6,0(sp)
    800004f4:	6121                	addi	sp,sp,64
    800004f6:	8082                	ret
        return 0;
    800004f8:	4501                	li	a0,0
    800004fa:	b7ed                	j	800004e4 <walk+0x8e>

00000000800004fc <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004fc:	57fd                	li	a5,-1
    800004fe:	83e9                	srli	a5,a5,0x1a
    80000500:	00b7f463          	bgeu	a5,a1,80000508 <walkaddr+0xc>
    return 0;
    80000504:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000506:	8082                	ret
{
    80000508:	1141                	addi	sp,sp,-16
    8000050a:	e406                	sd	ra,8(sp)
    8000050c:	e022                	sd	s0,0(sp)
    8000050e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000510:	4601                	li	a2,0
    80000512:	00000097          	auipc	ra,0x0
    80000516:	f44080e7          	jalr	-188(ra) # 80000456 <walk>
  if(pte == 0)
    8000051a:	c105                	beqz	a0,8000053a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000051c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000051e:	0117f693          	andi	a3,a5,17
    80000522:	4745                	li	a4,17
    return 0;
    80000524:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000526:	00e68663          	beq	a3,a4,80000532 <walkaddr+0x36>
}
    8000052a:	60a2                	ld	ra,8(sp)
    8000052c:	6402                	ld	s0,0(sp)
    8000052e:	0141                	addi	sp,sp,16
    80000530:	8082                	ret
  pa = PTE2PA(*pte);
    80000532:	83a9                	srli	a5,a5,0xa
    80000534:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000538:	bfcd                	j	8000052a <walkaddr+0x2e>
    return 0;
    8000053a:	4501                	li	a0,0
    8000053c:	b7fd                	j	8000052a <walkaddr+0x2e>

000000008000053e <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000053e:	715d                	addi	sp,sp,-80
    80000540:	e486                	sd	ra,72(sp)
    80000542:	e0a2                	sd	s0,64(sp)
    80000544:	fc26                	sd	s1,56(sp)
    80000546:	f84a                	sd	s2,48(sp)
    80000548:	f44e                	sd	s3,40(sp)
    8000054a:	f052                	sd	s4,32(sp)
    8000054c:	ec56                	sd	s5,24(sp)
    8000054e:	e85a                	sd	s6,16(sp)
    80000550:	e45e                	sd	s7,8(sp)
    80000552:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000554:	03459793          	slli	a5,a1,0x34
    80000558:	e7b9                	bnez	a5,800005a6 <mappages+0x68>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000055e:	03461793          	slli	a5,a2,0x34
    80000562:	ebb1                	bnez	a5,800005b6 <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    80000564:	c22d                	beqz	a2,800005c6 <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000566:	77fd                	lui	a5,0xfffff
    80000568:	963e                	add	a2,a2,a5
    8000056a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000056e:	892e                	mv	s2,a1
    80000570:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	ed6080e7          	jalr	-298(ra) # 80000456 <walk>
    80000588:	cd39                	beqz	a0,800005e6 <mappages+0xa8>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e7a1                	bnez	a5,800005d6 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	07390063          	beq	s2,s3,800005fe <mappages+0xc0>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x38>
    panic("mappages: va not aligned");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	886080e7          	jalr	-1914(ra) # 80005e34 <panic>
    panic("mappages: size not aligned");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ac250513          	addi	a0,a0,-1342 # 80008078 <etext+0x78>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	876080e7          	jalr	-1930(ra) # 80005e34 <panic>
    panic("mappages: size");
    800005c6:	00008517          	auipc	a0,0x8
    800005ca:	ad250513          	addi	a0,a0,-1326 # 80008098 <etext+0x98>
    800005ce:	00006097          	auipc	ra,0x6
    800005d2:	866080e7          	jalr	-1946(ra) # 80005e34 <panic>
      panic("mappages: remap");
    800005d6:	00008517          	auipc	a0,0x8
    800005da:	ad250513          	addi	a0,a0,-1326 # 800080a8 <etext+0xa8>
    800005de:	00006097          	auipc	ra,0x6
    800005e2:	856080e7          	jalr	-1962(ra) # 80005e34 <panic>
      return -1;
    800005e6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005e8:	60a6                	ld	ra,72(sp)
    800005ea:	6406                	ld	s0,64(sp)
    800005ec:	74e2                	ld	s1,56(sp)
    800005ee:	7942                	ld	s2,48(sp)
    800005f0:	79a2                	ld	s3,40(sp)
    800005f2:	7a02                	ld	s4,32(sp)
    800005f4:	6ae2                	ld	s5,24(sp)
    800005f6:	6b42                	ld	s6,16(sp)
    800005f8:	6ba2                	ld	s7,8(sp)
    800005fa:	6161                	addi	sp,sp,80
    800005fc:	8082                	ret
  return 0;
    800005fe:	4501                	li	a0,0
    80000600:	b7e5                	j	800005e8 <mappages+0xaa>

0000000080000602 <kvmmap>:
{
    80000602:	1141                	addi	sp,sp,-16
    80000604:	e406                	sd	ra,8(sp)
    80000606:	e022                	sd	s0,0(sp)
    80000608:	0800                	addi	s0,sp,16
    8000060a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000060c:	86b2                	mv	a3,a2
    8000060e:	863e                	mv	a2,a5
    80000610:	00000097          	auipc	ra,0x0
    80000614:	f2e080e7          	jalr	-210(ra) # 8000053e <mappages>
    80000618:	e509                	bnez	a0,80000622 <kvmmap+0x20>
}
    8000061a:	60a2                	ld	ra,8(sp)
    8000061c:	6402                	ld	s0,0(sp)
    8000061e:	0141                	addi	sp,sp,16
    80000620:	8082                	ret
    panic("kvmmap");
    80000622:	00008517          	auipc	a0,0x8
    80000626:	a9650513          	addi	a0,a0,-1386 # 800080b8 <etext+0xb8>
    8000062a:	00006097          	auipc	ra,0x6
    8000062e:	80a080e7          	jalr	-2038(ra) # 80005e34 <panic>

0000000080000632 <kvmmake>:
{
    80000632:	1101                	addi	sp,sp,-32
    80000634:	ec06                	sd	ra,24(sp)
    80000636:	e822                	sd	s0,16(sp)
    80000638:	e426                	sd	s1,8(sp)
    8000063a:	e04a                	sd	s2,0(sp)
    8000063c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000063e:	00000097          	auipc	ra,0x0
    80000642:	adc080e7          	jalr	-1316(ra) # 8000011a <kalloc>
    80000646:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000648:	6605                	lui	a2,0x1
    8000064a:	4581                	li	a1,0
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	b2e080e7          	jalr	-1234(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10000637          	lui	a2,0x10000
    8000065c:	100005b7          	lui	a1,0x10000
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	fa0080e7          	jalr	-96(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	6685                	lui	a3,0x1
    8000066e:	10001637          	lui	a2,0x10001
    80000672:	100015b7          	lui	a1,0x10001
    80000676:	8526                	mv	a0,s1
    80000678:	00000097          	auipc	ra,0x0
    8000067c:	f8a080e7          	jalr	-118(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000680:	4719                	li	a4,6
    80000682:	004006b7          	lui	a3,0x400
    80000686:	0c000637          	lui	a2,0xc000
    8000068a:	0c0005b7          	lui	a1,0xc000
    8000068e:	8526                	mv	a0,s1
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f72080e7          	jalr	-142(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000698:	00008917          	auipc	s2,0x8
    8000069c:	96890913          	addi	s2,s2,-1688 # 80008000 <etext>
    800006a0:	4729                	li	a4,10
    800006a2:	80008697          	auipc	a3,0x80008
    800006a6:	95e68693          	addi	a3,a3,-1698 # 8000 <_entry-0x7fff8000>
    800006aa:	4605                	li	a2,1
    800006ac:	067e                	slli	a2,a2,0x1f
    800006ae:	85b2                	mv	a1,a2
    800006b0:	8526                	mv	a0,s1
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	f50080e7          	jalr	-176(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ba:	46c5                	li	a3,17
    800006bc:	06ee                	slli	a3,a3,0x1b
    800006be:	4719                	li	a4,6
    800006c0:	412686b3          	sub	a3,a3,s2
    800006c4:	864a                	mv	a2,s2
    800006c6:	85ca                	mv	a1,s2
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f38080e7          	jalr	-200(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006d2:	4729                	li	a4,10
    800006d4:	6685                	lui	a3,0x1
    800006d6:	00007617          	auipc	a2,0x7
    800006da:	92a60613          	addi	a2,a2,-1750 # 80007000 <_trampoline>
    800006de:	040005b7          	lui	a1,0x4000
    800006e2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006e4:	05b2                	slli	a1,a1,0xc
    800006e6:	8526                	mv	a0,s1
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	f1a080e7          	jalr	-230(ra) # 80000602 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006f0:	8526                	mv	a0,s1
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	682080e7          	jalr	1666(ra) # 80000d74 <proc_mapstacks>
}
    800006fa:	8526                	mv	a0,s1
    800006fc:	60e2                	ld	ra,24(sp)
    800006fe:	6442                	ld	s0,16(sp)
    80000700:	64a2                	ld	s1,8(sp)
    80000702:	6902                	ld	s2,0(sp)
    80000704:	6105                	addi	sp,sp,32
    80000706:	8082                	ret

0000000080000708 <kvminit>:
{
    80000708:	1141                	addi	sp,sp,-16
    8000070a:	e406                	sd	ra,8(sp)
    8000070c:	e022                	sd	s0,0(sp)
    8000070e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000710:	00000097          	auipc	ra,0x0
    80000714:	f22080e7          	jalr	-222(ra) # 80000632 <kvmmake>
    80000718:	00008797          	auipc	a5,0x8
    8000071c:	1ea7b023          	sd	a0,480(a5) # 800088f8 <kernel_pagetable>
}
    80000720:	60a2                	ld	ra,8(sp)
    80000722:	6402                	ld	s0,0(sp)
    80000724:	0141                	addi	sp,sp,16
    80000726:	8082                	ret

0000000080000728 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000728:	715d                	addi	sp,sp,-80
    8000072a:	e486                	sd	ra,72(sp)
    8000072c:	e0a2                	sd	s0,64(sp)
    8000072e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000730:	03459793          	slli	a5,a1,0x34
    80000734:	e39d                	bnez	a5,8000075a <uvmunmap+0x32>
    80000736:	f84a                	sd	s2,48(sp)
    80000738:	f44e                	sd	s3,40(sp)
    8000073a:	f052                	sd	s4,32(sp)
    8000073c:	ec56                	sd	s5,24(sp)
    8000073e:	e85a                	sd	s6,16(sp)
    80000740:	e45e                	sd	s7,8(sp)
    80000742:	8a2a                	mv	s4,a0
    80000744:	892e                	mv	s2,a1
    80000746:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000748:	0632                	slli	a2,a2,0xc
    8000074a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000074e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000750:	6b05                	lui	s6,0x1
    80000752:	0935fb63          	bgeu	a1,s3,800007e8 <uvmunmap+0xc0>
    80000756:	fc26                	sd	s1,56(sp)
    80000758:	a8a9                	j	800007b2 <uvmunmap+0x8a>
    8000075a:	fc26                	sd	s1,56(sp)
    8000075c:	f84a                	sd	s2,48(sp)
    8000075e:	f44e                	sd	s3,40(sp)
    80000760:	f052                	sd	s4,32(sp)
    80000762:	ec56                	sd	s5,24(sp)
    80000764:	e85a                	sd	s6,16(sp)
    80000766:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	95850513          	addi	a0,a0,-1704 # 800080c0 <etext+0xc0>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	6c4080e7          	jalr	1732(ra) # 80005e34 <panic>
      panic("uvmunmap: walk");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	96050513          	addi	a0,a0,-1696 # 800080d8 <etext+0xd8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	6b4080e7          	jalr	1716(ra) # 80005e34 <panic>
      panic("uvmunmap: not mapped");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	96050513          	addi	a0,a0,-1696 # 800080e8 <etext+0xe8>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	6a4080e7          	jalr	1700(ra) # 80005e34 <panic>
      panic("uvmunmap: not a leaf");
    80000798:	00008517          	auipc	a0,0x8
    8000079c:	96850513          	addi	a0,a0,-1688 # 80008100 <etext+0x100>
    800007a0:	00005097          	auipc	ra,0x5
    800007a4:	694080e7          	jalr	1684(ra) # 80005e34 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007a8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ac:	995a                	add	s2,s2,s6
    800007ae:	03397c63          	bgeu	s2,s3,800007e6 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007b2:	4601                	li	a2,0
    800007b4:	85ca                	mv	a1,s2
    800007b6:	8552                	mv	a0,s4
    800007b8:	00000097          	auipc	ra,0x0
    800007bc:	c9e080e7          	jalr	-866(ra) # 80000456 <walk>
    800007c0:	84aa                	mv	s1,a0
    800007c2:	d95d                	beqz	a0,80000778 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800007c4:	6108                	ld	a0,0(a0)
    800007c6:	00157793          	andi	a5,a0,1
    800007ca:	dfdd                	beqz	a5,80000788 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007cc:	3ff57793          	andi	a5,a0,1023
    800007d0:	fd7784e3          	beq	a5,s7,80000798 <uvmunmap+0x70>
    if(do_free){
    800007d4:	fc0a8ae3          	beqz	s5,800007a8 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007d8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007da:	0532                	slli	a0,a0,0xc
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	840080e7          	jalr	-1984(ra) # 8000001c <kfree>
    800007e4:	b7d1                	j	800007a8 <uvmunmap+0x80>
    800007e6:	74e2                	ld	s1,56(sp)
    800007e8:	7942                	ld	s2,48(sp)
    800007ea:	79a2                	ld	s3,40(sp)
    800007ec:	7a02                	ld	s4,32(sp)
    800007ee:	6ae2                	ld	s5,24(sp)
    800007f0:	6b42                	ld	s6,16(sp)
    800007f2:	6ba2                	ld	s7,8(sp)
  }
}
    800007f4:	60a6                	ld	ra,72(sp)
    800007f6:	6406                	ld	s0,64(sp)
    800007f8:	6161                	addi	sp,sp,80
    800007fa:	8082                	ret

00000000800007fc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007fc:	1101                	addi	sp,sp,-32
    800007fe:	ec06                	sd	ra,24(sp)
    80000800:	e822                	sd	s0,16(sp)
    80000802:	e426                	sd	s1,8(sp)
    80000804:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	914080e7          	jalr	-1772(ra) # 8000011a <kalloc>
    8000080e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000810:	c519                	beqz	a0,8000081e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000812:	6605                	lui	a2,0x1
    80000814:	4581                	li	a1,0
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	964080e7          	jalr	-1692(ra) # 8000017a <memset>
  return pagetable;
}
    8000081e:	8526                	mv	a0,s1
    80000820:	60e2                	ld	ra,24(sp)
    80000822:	6442                	ld	s0,16(sp)
    80000824:	64a2                	ld	s1,8(sp)
    80000826:	6105                	addi	sp,sp,32
    80000828:	8082                	ret

000000008000082a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000082a:	7179                	addi	sp,sp,-48
    8000082c:	f406                	sd	ra,40(sp)
    8000082e:	f022                	sd	s0,32(sp)
    80000830:	ec26                	sd	s1,24(sp)
    80000832:	e84a                	sd	s2,16(sp)
    80000834:	e44e                	sd	s3,8(sp)
    80000836:	e052                	sd	s4,0(sp)
    80000838:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000083a:	6785                	lui	a5,0x1
    8000083c:	04f67863          	bgeu	a2,a5,8000088c <uvmfirst+0x62>
    80000840:	8a2a                	mv	s4,a0
    80000842:	89ae                	mv	s3,a1
    80000844:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	8d4080e7          	jalr	-1836(ra) # 8000011a <kalloc>
    8000084e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000850:	6605                	lui	a2,0x1
    80000852:	4581                	li	a1,0
    80000854:	00000097          	auipc	ra,0x0
    80000858:	926080e7          	jalr	-1754(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000085c:	4779                	li	a4,30
    8000085e:	86ca                	mv	a3,s2
    80000860:	6605                	lui	a2,0x1
    80000862:	4581                	li	a1,0
    80000864:	8552                	mv	a0,s4
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	cd8080e7          	jalr	-808(ra) # 8000053e <mappages>
  memmove(mem, src, sz);
    8000086e:	8626                	mv	a2,s1
    80000870:	85ce                	mv	a1,s3
    80000872:	854a                	mv	a0,s2
    80000874:	00000097          	auipc	ra,0x0
    80000878:	962080e7          	jalr	-1694(ra) # 800001d6 <memmove>
}
    8000087c:	70a2                	ld	ra,40(sp)
    8000087e:	7402                	ld	s0,32(sp)
    80000880:	64e2                	ld	s1,24(sp)
    80000882:	6942                	ld	s2,16(sp)
    80000884:	69a2                	ld	s3,8(sp)
    80000886:	6a02                	ld	s4,0(sp)
    80000888:	6145                	addi	sp,sp,48
    8000088a:	8082                	ret
    panic("uvmfirst: more than a page");
    8000088c:	00008517          	auipc	a0,0x8
    80000890:	88c50513          	addi	a0,a0,-1908 # 80008118 <etext+0x118>
    80000894:	00005097          	auipc	ra,0x5
    80000898:	5a0080e7          	jalr	1440(ra) # 80005e34 <panic>

000000008000089c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000089c:	1101                	addi	sp,sp,-32
    8000089e:	ec06                	sd	ra,24(sp)
    800008a0:	e822                	sd	s0,16(sp)
    800008a2:	e426                	sd	s1,8(sp)
    800008a4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a8:	00b67d63          	bgeu	a2,a1,800008c2 <uvmdealloc+0x26>
    800008ac:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ae:	6785                	lui	a5,0x1
    800008b0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008b2:	00f60733          	add	a4,a2,a5
    800008b6:	76fd                	lui	a3,0xfffff
    800008b8:	8f75                	and	a4,a4,a3
    800008ba:	97ae                	add	a5,a5,a1
    800008bc:	8ff5                	and	a5,a5,a3
    800008be:	00f76863          	bltu	a4,a5,800008ce <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008c2:	8526                	mv	a0,s1
    800008c4:	60e2                	ld	ra,24(sp)
    800008c6:	6442                	ld	s0,16(sp)
    800008c8:	64a2                	ld	s1,8(sp)
    800008ca:	6105                	addi	sp,sp,32
    800008cc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ce:	8f99                	sub	a5,a5,a4
    800008d0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008d2:	4685                	li	a3,1
    800008d4:	0007861b          	sext.w	a2,a5
    800008d8:	85ba                	mv	a1,a4
    800008da:	00000097          	auipc	ra,0x0
    800008de:	e4e080e7          	jalr	-434(ra) # 80000728 <uvmunmap>
    800008e2:	b7c5                	j	800008c2 <uvmdealloc+0x26>

00000000800008e4 <uvmalloc>:
  if(newsz < oldsz)
    800008e4:	0ab66b63          	bltu	a2,a1,8000099a <uvmalloc+0xb6>
{
    800008e8:	7139                	addi	sp,sp,-64
    800008ea:	fc06                	sd	ra,56(sp)
    800008ec:	f822                	sd	s0,48(sp)
    800008ee:	ec4e                	sd	s3,24(sp)
    800008f0:	e852                	sd	s4,16(sp)
    800008f2:	e456                	sd	s5,8(sp)
    800008f4:	0080                	addi	s0,sp,64
    800008f6:	8aaa                	mv	s5,a0
    800008f8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008fa:	6785                	lui	a5,0x1
    800008fc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008fe:	95be                	add	a1,a1,a5
    80000900:	77fd                	lui	a5,0xfffff
    80000902:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000906:	08c9fc63          	bgeu	s3,a2,8000099e <uvmalloc+0xba>
    8000090a:	f426                	sd	s1,40(sp)
    8000090c:	f04a                	sd	s2,32(sp)
    8000090e:	e05a                	sd	s6,0(sp)
    80000910:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000912:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000916:	00000097          	auipc	ra,0x0
    8000091a:	804080e7          	jalr	-2044(ra) # 8000011a <kalloc>
    8000091e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000920:	c915                	beqz	a0,80000954 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    80000922:	6605                	lui	a2,0x1
    80000924:	4581                	li	a1,0
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	854080e7          	jalr	-1964(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000092e:	875a                	mv	a4,s6
    80000930:	86a6                	mv	a3,s1
    80000932:	6605                	lui	a2,0x1
    80000934:	85ca                	mv	a1,s2
    80000936:	8556                	mv	a0,s5
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	c06080e7          	jalr	-1018(ra) # 8000053e <mappages>
    80000940:	ed05                	bnez	a0,80000978 <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000942:	6785                	lui	a5,0x1
    80000944:	993e                	add	s2,s2,a5
    80000946:	fd4968e3          	bltu	s2,s4,80000916 <uvmalloc+0x32>
  return newsz;
    8000094a:	8552                	mv	a0,s4
    8000094c:	74a2                	ld	s1,40(sp)
    8000094e:	7902                	ld	s2,32(sp)
    80000950:	6b02                	ld	s6,0(sp)
    80000952:	a821                	j	8000096a <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80000954:	864e                	mv	a2,s3
    80000956:	85ca                	mv	a1,s2
    80000958:	8556                	mv	a0,s5
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	f42080e7          	jalr	-190(ra) # 8000089c <uvmdealloc>
      return 0;
    80000962:	4501                	li	a0,0
    80000964:	74a2                	ld	s1,40(sp)
    80000966:	7902                	ld	s2,32(sp)
    80000968:	6b02                	ld	s6,0(sp)
}
    8000096a:	70e2                	ld	ra,56(sp)
    8000096c:	7442                	ld	s0,48(sp)
    8000096e:	69e2                	ld	s3,24(sp)
    80000970:	6a42                	ld	s4,16(sp)
    80000972:	6aa2                	ld	s5,8(sp)
    80000974:	6121                	addi	sp,sp,64
    80000976:	8082                	ret
      kfree(mem);
    80000978:	8526                	mv	a0,s1
    8000097a:	fffff097          	auipc	ra,0xfffff
    8000097e:	6a2080e7          	jalr	1698(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000982:	864e                	mv	a2,s3
    80000984:	85ca                	mv	a1,s2
    80000986:	8556                	mv	a0,s5
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	f14080e7          	jalr	-236(ra) # 8000089c <uvmdealloc>
      return 0;
    80000990:	4501                	li	a0,0
    80000992:	74a2                	ld	s1,40(sp)
    80000994:	7902                	ld	s2,32(sp)
    80000996:	6b02                	ld	s6,0(sp)
    80000998:	bfc9                	j	8000096a <uvmalloc+0x86>
    return oldsz;
    8000099a:	852e                	mv	a0,a1
}
    8000099c:	8082                	ret
  return newsz;
    8000099e:	8532                	mv	a0,a2
    800009a0:	b7e9                	j	8000096a <uvmalloc+0x86>

00000000800009a2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009a2:	7179                	addi	sp,sp,-48
    800009a4:	f406                	sd	ra,40(sp)
    800009a6:	f022                	sd	s0,32(sp)
    800009a8:	ec26                	sd	s1,24(sp)
    800009aa:	e84a                	sd	s2,16(sp)
    800009ac:	e44e                	sd	s3,8(sp)
    800009ae:	e052                	sd	s4,0(sp)
    800009b0:	1800                	addi	s0,sp,48
    800009b2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009b4:	84aa                	mv	s1,a0
    800009b6:	6905                	lui	s2,0x1
    800009b8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ba:	4985                	li	s3,1
    800009bc:	a829                	j	800009d6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009be:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009c0:	00c79513          	slli	a0,a5,0xc
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	fde080e7          	jalr	-34(ra) # 800009a2 <freewalk>
      pagetable[i] = 0;
    800009cc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009d0:	04a1                	addi	s1,s1,8
    800009d2:	03248163          	beq	s1,s2,800009f4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009d6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d8:	00f7f713          	andi	a4,a5,15
    800009dc:	ff3701e3          	beq	a4,s3,800009be <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009e0:	8b85                	andi	a5,a5,1
    800009e2:	d7fd                	beqz	a5,800009d0 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009e4:	00007517          	auipc	a0,0x7
    800009e8:	75450513          	addi	a0,a0,1876 # 80008138 <etext+0x138>
    800009ec:	00005097          	auipc	ra,0x5
    800009f0:	448080e7          	jalr	1096(ra) # 80005e34 <panic>
    }
  }
  kfree((void*)pagetable);
    800009f4:	8552                	mv	a0,s4
    800009f6:	fffff097          	auipc	ra,0xfffff
    800009fa:	626080e7          	jalr	1574(ra) # 8000001c <kfree>
}
    800009fe:	70a2                	ld	ra,40(sp)
    80000a00:	7402                	ld	s0,32(sp)
    80000a02:	64e2                	ld	s1,24(sp)
    80000a04:	6942                	ld	s2,16(sp)
    80000a06:	69a2                	ld	s3,8(sp)
    80000a08:	6a02                	ld	s4,0(sp)
    80000a0a:	6145                	addi	sp,sp,48
    80000a0c:	8082                	ret

0000000080000a0e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a0e:	1101                	addi	sp,sp,-32
    80000a10:	ec06                	sd	ra,24(sp)
    80000a12:	e822                	sd	s0,16(sp)
    80000a14:	e426                	sd	s1,8(sp)
    80000a16:	1000                	addi	s0,sp,32
    80000a18:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a1a:	e999                	bnez	a1,80000a30 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a1c:	8526                	mv	a0,s1
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	f84080e7          	jalr	-124(ra) # 800009a2 <freewalk>
}
    80000a26:	60e2                	ld	ra,24(sp)
    80000a28:	6442                	ld	s0,16(sp)
    80000a2a:	64a2                	ld	s1,8(sp)
    80000a2c:	6105                	addi	sp,sp,32
    80000a2e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a30:	6785                	lui	a5,0x1
    80000a32:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a34:	95be                	add	a1,a1,a5
    80000a36:	4685                	li	a3,1
    80000a38:	00c5d613          	srli	a2,a1,0xc
    80000a3c:	4581                	li	a1,0
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	cea080e7          	jalr	-790(ra) # 80000728 <uvmunmap>
    80000a46:	bfd9                	j	80000a1c <uvmfree+0xe>

0000000080000a48 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a48:	c679                	beqz	a2,80000b16 <uvmcopy+0xce>
{
    80000a4a:	715d                	addi	sp,sp,-80
    80000a4c:	e486                	sd	ra,72(sp)
    80000a4e:	e0a2                	sd	s0,64(sp)
    80000a50:	fc26                	sd	s1,56(sp)
    80000a52:	f84a                	sd	s2,48(sp)
    80000a54:	f44e                	sd	s3,40(sp)
    80000a56:	f052                	sd	s4,32(sp)
    80000a58:	ec56                	sd	s5,24(sp)
    80000a5a:	e85a                	sd	s6,16(sp)
    80000a5c:	e45e                	sd	s7,8(sp)
    80000a5e:	0880                	addi	s0,sp,80
    80000a60:	8b2a                	mv	s6,a0
    80000a62:	8aae                	mv	s5,a1
    80000a64:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a66:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a68:	4601                	li	a2,0
    80000a6a:	85ce                	mv	a1,s3
    80000a6c:	855a                	mv	a0,s6
    80000a6e:	00000097          	auipc	ra,0x0
    80000a72:	9e8080e7          	jalr	-1560(ra) # 80000456 <walk>
    80000a76:	c531                	beqz	a0,80000ac2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a78:	6118                	ld	a4,0(a0)
    80000a7a:	00177793          	andi	a5,a4,1
    80000a7e:	cbb1                	beqz	a5,80000ad2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a80:	00a75593          	srli	a1,a4,0xa
    80000a84:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a88:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a8c:	fffff097          	auipc	ra,0xfffff
    80000a90:	68e080e7          	jalr	1678(ra) # 8000011a <kalloc>
    80000a94:	892a                	mv	s2,a0
    80000a96:	c939                	beqz	a0,80000aec <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a98:	6605                	lui	a2,0x1
    80000a9a:	85de                	mv	a1,s7
    80000a9c:	fffff097          	auipc	ra,0xfffff
    80000aa0:	73a080e7          	jalr	1850(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aa4:	8726                	mv	a4,s1
    80000aa6:	86ca                	mv	a3,s2
    80000aa8:	6605                	lui	a2,0x1
    80000aaa:	85ce                	mv	a1,s3
    80000aac:	8556                	mv	a0,s5
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	a90080e7          	jalr	-1392(ra) # 8000053e <mappages>
    80000ab6:	e515                	bnez	a0,80000ae2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ab8:	6785                	lui	a5,0x1
    80000aba:	99be                	add	s3,s3,a5
    80000abc:	fb49e6e3          	bltu	s3,s4,80000a68 <uvmcopy+0x20>
    80000ac0:	a081                	j	80000b00 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ac2:	00007517          	auipc	a0,0x7
    80000ac6:	68650513          	addi	a0,a0,1670 # 80008148 <etext+0x148>
    80000aca:	00005097          	auipc	ra,0x5
    80000ace:	36a080e7          	jalr	874(ra) # 80005e34 <panic>
      panic("uvmcopy: page not present");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	69650513          	addi	a0,a0,1686 # 80008168 <etext+0x168>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	35a080e7          	jalr	858(ra) # 80005e34 <panic>
      kfree(mem);
    80000ae2:	854a                	mv	a0,s2
    80000ae4:	fffff097          	auipc	ra,0xfffff
    80000ae8:	538080e7          	jalr	1336(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aec:	4685                	li	a3,1
    80000aee:	00c9d613          	srli	a2,s3,0xc
    80000af2:	4581                	li	a1,0
    80000af4:	8556                	mv	a0,s5
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	c32080e7          	jalr	-974(ra) # 80000728 <uvmunmap>
  return -1;
    80000afe:	557d                	li	a0,-1
}
    80000b00:	60a6                	ld	ra,72(sp)
    80000b02:	6406                	ld	s0,64(sp)
    80000b04:	74e2                	ld	s1,56(sp)
    80000b06:	7942                	ld	s2,48(sp)
    80000b08:	79a2                	ld	s3,40(sp)
    80000b0a:	7a02                	ld	s4,32(sp)
    80000b0c:	6ae2                	ld	s5,24(sp)
    80000b0e:	6b42                	ld	s6,16(sp)
    80000b10:	6ba2                	ld	s7,8(sp)
    80000b12:	6161                	addi	sp,sp,80
    80000b14:	8082                	ret
  return 0;
    80000b16:	4501                	li	a0,0
}
    80000b18:	8082                	ret

0000000080000b1a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b1a:	1141                	addi	sp,sp,-16
    80000b1c:	e406                	sd	ra,8(sp)
    80000b1e:	e022                	sd	s0,0(sp)
    80000b20:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b22:	4601                	li	a2,0
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	932080e7          	jalr	-1742(ra) # 80000456 <walk>
  if(pte == 0)
    80000b2c:	c901                	beqz	a0,80000b3c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b2e:	611c                	ld	a5,0(a0)
    80000b30:	9bbd                	andi	a5,a5,-17
    80000b32:	e11c                	sd	a5,0(a0)
}
    80000b34:	60a2                	ld	ra,8(sp)
    80000b36:	6402                	ld	s0,0(sp)
    80000b38:	0141                	addi	sp,sp,16
    80000b3a:	8082                	ret
    panic("uvmclear");
    80000b3c:	00007517          	auipc	a0,0x7
    80000b40:	64c50513          	addi	a0,a0,1612 # 80008188 <etext+0x188>
    80000b44:	00005097          	auipc	ra,0x5
    80000b48:	2f0080e7          	jalr	752(ra) # 80005e34 <panic>

0000000080000b4c <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b4c:	ced1                	beqz	a3,80000be8 <copyout+0x9c>
{
    80000b4e:	711d                	addi	sp,sp,-96
    80000b50:	ec86                	sd	ra,88(sp)
    80000b52:	e8a2                	sd	s0,80(sp)
    80000b54:	e4a6                	sd	s1,72(sp)
    80000b56:	fc4e                	sd	s3,56(sp)
    80000b58:	f456                	sd	s5,40(sp)
    80000b5a:	f05a                	sd	s6,32(sp)
    80000b5c:	ec5e                	sd	s7,24(sp)
    80000b5e:	1080                	addi	s0,sp,96
    80000b60:	8baa                	mv	s7,a0
    80000b62:	8aae                	mv	s5,a1
    80000b64:	8b32                	mv	s6,a2
    80000b66:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b68:	74fd                	lui	s1,0xfffff
    80000b6a:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000b6c:	57fd                	li	a5,-1
    80000b6e:	83e9                	srli	a5,a5,0x1a
    80000b70:	0697ee63          	bltu	a5,s1,80000bec <copyout+0xa0>
    80000b74:	e0ca                	sd	s2,64(sp)
    80000b76:	f852                	sd	s4,48(sp)
    80000b78:	e862                	sd	s8,16(sp)
    80000b7a:	e466                	sd	s9,8(sp)
    80000b7c:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b7e:	4cd5                	li	s9,21
    80000b80:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000b82:	8c3e                	mv	s8,a5
    80000b84:	a035                	j	80000bb0 <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b86:	83a9                	srli	a5,a5,0xa
    80000b88:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b8a:	409a8533          	sub	a0,s5,s1
    80000b8e:	0009061b          	sext.w	a2,s2
    80000b92:	85da                	mv	a1,s6
    80000b94:	953e                	add	a0,a0,a5
    80000b96:	fffff097          	auipc	ra,0xfffff
    80000b9a:	640080e7          	jalr	1600(ra) # 800001d6 <memmove>

    len -= n;
    80000b9e:	412989b3          	sub	s3,s3,s2
    src += n;
    80000ba2:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000ba4:	02098b63          	beqz	s3,80000bda <copyout+0x8e>
    if(va0 >= MAXVA)
    80000ba8:	054c6463          	bltu	s8,s4,80000bf0 <copyout+0xa4>
    80000bac:	84d2                	mv	s1,s4
    80000bae:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000bb0:	4601                	li	a2,0
    80000bb2:	85a6                	mv	a1,s1
    80000bb4:	855e                	mv	a0,s7
    80000bb6:	00000097          	auipc	ra,0x0
    80000bba:	8a0080e7          	jalr	-1888(ra) # 80000456 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bbe:	c121                	beqz	a0,80000bfe <copyout+0xb2>
    80000bc0:	611c                	ld	a5,0(a0)
    80000bc2:	0157f713          	andi	a4,a5,21
    80000bc6:	05971b63          	bne	a4,s9,80000c1c <copyout+0xd0>
    n = PGSIZE - (dstva - va0);
    80000bca:	01a48a33          	add	s4,s1,s10
    80000bce:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000bd2:	fb29fae3          	bgeu	s3,s2,80000b86 <copyout+0x3a>
    80000bd6:	894e                	mv	s2,s3
    80000bd8:	b77d                	j	80000b86 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000bda:	4501                	li	a0,0
    80000bdc:	6906                	ld	s2,64(sp)
    80000bde:	7a42                	ld	s4,48(sp)
    80000be0:	6c42                	ld	s8,16(sp)
    80000be2:	6ca2                	ld	s9,8(sp)
    80000be4:	6d02                	ld	s10,0(sp)
    80000be6:	a015                	j	80000c0a <copyout+0xbe>
    80000be8:	4501                	li	a0,0
}
    80000bea:	8082                	ret
      return -1;
    80000bec:	557d                	li	a0,-1
    80000bee:	a831                	j	80000c0a <copyout+0xbe>
    80000bf0:	557d                	li	a0,-1
    80000bf2:	6906                	ld	s2,64(sp)
    80000bf4:	7a42                	ld	s4,48(sp)
    80000bf6:	6c42                	ld	s8,16(sp)
    80000bf8:	6ca2                	ld	s9,8(sp)
    80000bfa:	6d02                	ld	s10,0(sp)
    80000bfc:	a039                	j	80000c0a <copyout+0xbe>
      return -1;
    80000bfe:	557d                	li	a0,-1
    80000c00:	6906                	ld	s2,64(sp)
    80000c02:	7a42                	ld	s4,48(sp)
    80000c04:	6c42                	ld	s8,16(sp)
    80000c06:	6ca2                	ld	s9,8(sp)
    80000c08:	6d02                	ld	s10,0(sp)
}
    80000c0a:	60e6                	ld	ra,88(sp)
    80000c0c:	6446                	ld	s0,80(sp)
    80000c0e:	64a6                	ld	s1,72(sp)
    80000c10:	79e2                	ld	s3,56(sp)
    80000c12:	7aa2                	ld	s5,40(sp)
    80000c14:	7b02                	ld	s6,32(sp)
    80000c16:	6be2                	ld	s7,24(sp)
    80000c18:	6125                	addi	sp,sp,96
    80000c1a:	8082                	ret
      return -1;
    80000c1c:	557d                	li	a0,-1
    80000c1e:	6906                	ld	s2,64(sp)
    80000c20:	7a42                	ld	s4,48(sp)
    80000c22:	6c42                	ld	s8,16(sp)
    80000c24:	6ca2                	ld	s9,8(sp)
    80000c26:	6d02                	ld	s10,0(sp)
    80000c28:	b7cd                	j	80000c0a <copyout+0xbe>

0000000080000c2a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c2a:	caa5                	beqz	a3,80000c9a <copyin+0x70>
{
    80000c2c:	715d                	addi	sp,sp,-80
    80000c2e:	e486                	sd	ra,72(sp)
    80000c30:	e0a2                	sd	s0,64(sp)
    80000c32:	fc26                	sd	s1,56(sp)
    80000c34:	f84a                	sd	s2,48(sp)
    80000c36:	f44e                	sd	s3,40(sp)
    80000c38:	f052                	sd	s4,32(sp)
    80000c3a:	ec56                	sd	s5,24(sp)
    80000c3c:	e85a                	sd	s6,16(sp)
    80000c3e:	e45e                	sd	s7,8(sp)
    80000c40:	e062                	sd	s8,0(sp)
    80000c42:	0880                	addi	s0,sp,80
    80000c44:	8b2a                	mv	s6,a0
    80000c46:	8a2e                	mv	s4,a1
    80000c48:	8c32                	mv	s8,a2
    80000c4a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4e:	6a85                	lui	s5,0x1
    80000c50:	a01d                	j	80000c76 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c52:	018505b3          	add	a1,a0,s8
    80000c56:	0004861b          	sext.w	a2,s1
    80000c5a:	412585b3          	sub	a1,a1,s2
    80000c5e:	8552                	mv	a0,s4
    80000c60:	fffff097          	auipc	ra,0xfffff
    80000c64:	576080e7          	jalr	1398(ra) # 800001d6 <memmove>

    len -= n;
    80000c68:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c6c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c6e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c72:	02098263          	beqz	s3,80000c96 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c76:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c7a:	85ca                	mv	a1,s2
    80000c7c:	855a                	mv	a0,s6
    80000c7e:	00000097          	auipc	ra,0x0
    80000c82:	87e080e7          	jalr	-1922(ra) # 800004fc <walkaddr>
    if(pa0 == 0)
    80000c86:	cd01                	beqz	a0,80000c9e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c88:	418904b3          	sub	s1,s2,s8
    80000c8c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c8e:	fc99f2e3          	bgeu	s3,s1,80000c52 <copyin+0x28>
    80000c92:	84ce                	mv	s1,s3
    80000c94:	bf7d                	j	80000c52 <copyin+0x28>
  }
  return 0;
    80000c96:	4501                	li	a0,0
    80000c98:	a021                	j	80000ca0 <copyin+0x76>
    80000c9a:	4501                	li	a0,0
}
    80000c9c:	8082                	ret
      return -1;
    80000c9e:	557d                	li	a0,-1
}
    80000ca0:	60a6                	ld	ra,72(sp)
    80000ca2:	6406                	ld	s0,64(sp)
    80000ca4:	74e2                	ld	s1,56(sp)
    80000ca6:	7942                	ld	s2,48(sp)
    80000ca8:	79a2                	ld	s3,40(sp)
    80000caa:	7a02                	ld	s4,32(sp)
    80000cac:	6ae2                	ld	s5,24(sp)
    80000cae:	6b42                	ld	s6,16(sp)
    80000cb0:	6ba2                	ld	s7,8(sp)
    80000cb2:	6c02                	ld	s8,0(sp)
    80000cb4:	6161                	addi	sp,sp,80
    80000cb6:	8082                	ret

0000000080000cb8 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000cb8:	cacd                	beqz	a3,80000d6a <copyinstr+0xb2>
{
    80000cba:	715d                	addi	sp,sp,-80
    80000cbc:	e486                	sd	ra,72(sp)
    80000cbe:	e0a2                	sd	s0,64(sp)
    80000cc0:	fc26                	sd	s1,56(sp)
    80000cc2:	f84a                	sd	s2,48(sp)
    80000cc4:	f44e                	sd	s3,40(sp)
    80000cc6:	f052                	sd	s4,32(sp)
    80000cc8:	ec56                	sd	s5,24(sp)
    80000cca:	e85a                	sd	s6,16(sp)
    80000ccc:	e45e                	sd	s7,8(sp)
    80000cce:	0880                	addi	s0,sp,80
    80000cd0:	8a2a                	mv	s4,a0
    80000cd2:	8b2e                	mv	s6,a1
    80000cd4:	8bb2                	mv	s7,a2
    80000cd6:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000cd8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cda:	6985                	lui	s3,0x1
    80000cdc:	a825                	j	80000d14 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cde:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ce2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ce4:	37fd                	addiw	a5,a5,-1
    80000ce6:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cea:	60a6                	ld	ra,72(sp)
    80000cec:	6406                	ld	s0,64(sp)
    80000cee:	74e2                	ld	s1,56(sp)
    80000cf0:	7942                	ld	s2,48(sp)
    80000cf2:	79a2                	ld	s3,40(sp)
    80000cf4:	7a02                	ld	s4,32(sp)
    80000cf6:	6ae2                	ld	s5,24(sp)
    80000cf8:	6b42                	ld	s6,16(sp)
    80000cfa:	6ba2                	ld	s7,8(sp)
    80000cfc:	6161                	addi	sp,sp,80
    80000cfe:	8082                	ret
    80000d00:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000d04:	9742                	add	a4,a4,a6
      --max;
    80000d06:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000d0a:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000d0e:	04e58663          	beq	a1,a4,80000d5a <copyinstr+0xa2>
{
    80000d12:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000d14:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d18:	85a6                	mv	a1,s1
    80000d1a:	8552                	mv	a0,s4
    80000d1c:	fffff097          	auipc	ra,0xfffff
    80000d20:	7e0080e7          	jalr	2016(ra) # 800004fc <walkaddr>
    if(pa0 == 0)
    80000d24:	cd0d                	beqz	a0,80000d5e <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000d26:	417486b3          	sub	a3,s1,s7
    80000d2a:	96ce                	add	a3,a3,s3
    if(n > max)
    80000d2c:	00d97363          	bgeu	s2,a3,80000d32 <copyinstr+0x7a>
    80000d30:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000d32:	955e                	add	a0,a0,s7
    80000d34:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000d36:	c695                	beqz	a3,80000d62 <copyinstr+0xaa>
    80000d38:	87da                	mv	a5,s6
    80000d3a:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d3c:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d40:	96da                	add	a3,a3,s6
    80000d42:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d44:	00f60733          	add	a4,a2,a5
    80000d48:	00074703          	lbu	a4,0(a4)
    80000d4c:	db49                	beqz	a4,80000cde <copyinstr+0x26>
        *dst = *p;
    80000d4e:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d52:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d54:	fed797e3          	bne	a5,a3,80000d42 <copyinstr+0x8a>
    80000d58:	b765                	j	80000d00 <copyinstr+0x48>
    80000d5a:	4781                	li	a5,0
    80000d5c:	b761                	j	80000ce4 <copyinstr+0x2c>
      return -1;
    80000d5e:	557d                	li	a0,-1
    80000d60:	b769                	j	80000cea <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000d62:	6b85                	lui	s7,0x1
    80000d64:	9ba6                	add	s7,s7,s1
    80000d66:	87da                	mv	a5,s6
    80000d68:	b76d                	j	80000d12 <copyinstr+0x5a>
  int got_null = 0;
    80000d6a:	4781                	li	a5,0
  if(got_null){
    80000d6c:	37fd                	addiw	a5,a5,-1
    80000d6e:	0007851b          	sext.w	a0,a5
}
    80000d72:	8082                	ret

0000000080000d74 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d74:	7139                	addi	sp,sp,-64
    80000d76:	fc06                	sd	ra,56(sp)
    80000d78:	f822                	sd	s0,48(sp)
    80000d7a:	f426                	sd	s1,40(sp)
    80000d7c:	f04a                	sd	s2,32(sp)
    80000d7e:	ec4e                	sd	s3,24(sp)
    80000d80:	e852                	sd	s4,16(sp)
    80000d82:	e456                	sd	s5,8(sp)
    80000d84:	e05a                	sd	s6,0(sp)
    80000d86:	0080                	addi	s0,sp,64
    80000d88:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8a:	00008497          	auipc	s1,0x8
    80000d8e:	fe648493          	addi	s1,s1,-26 # 80008d70 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d92:	8b26                	mv	s6,s1
    80000d94:	04fa5937          	lui	s2,0x4fa5
    80000d98:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d9c:	0932                	slli	s2,s2,0xc
    80000d9e:	fa590913          	addi	s2,s2,-91
    80000da2:	0932                	slli	s2,s2,0xc
    80000da4:	fa590913          	addi	s2,s2,-91
    80000da8:	0932                	slli	s2,s2,0xc
    80000daa:	fa590913          	addi	s2,s2,-91
    80000dae:	040009b7          	lui	s3,0x4000
    80000db2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000db4:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db6:	0000ea97          	auipc	s5,0xe
    80000dba:	9baa8a93          	addi	s5,s5,-1606 # 8000e770 <tickslock>
    char *pa = kalloc();
    80000dbe:	fffff097          	auipc	ra,0xfffff
    80000dc2:	35c080e7          	jalr	860(ra) # 8000011a <kalloc>
    80000dc6:	862a                	mv	a2,a0
    if(pa == 0)
    80000dc8:	c121                	beqz	a0,80000e08 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000dca:	416485b3          	sub	a1,s1,s6
    80000dce:	858d                	srai	a1,a1,0x3
    80000dd0:	032585b3          	mul	a1,a1,s2
    80000dd4:	2585                	addiw	a1,a1,1
    80000dd6:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000dda:	4719                	li	a4,6
    80000ddc:	6685                	lui	a3,0x1
    80000dde:	40b985b3          	sub	a1,s3,a1
    80000de2:	8552                	mv	a0,s4
    80000de4:	00000097          	auipc	ra,0x0
    80000de8:	81e080e7          	jalr	-2018(ra) # 80000602 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dec:	16848493          	addi	s1,s1,360
    80000df0:	fd5497e3          	bne	s1,s5,80000dbe <proc_mapstacks+0x4a>
  }
}
    80000df4:	70e2                	ld	ra,56(sp)
    80000df6:	7442                	ld	s0,48(sp)
    80000df8:	74a2                	ld	s1,40(sp)
    80000dfa:	7902                	ld	s2,32(sp)
    80000dfc:	69e2                	ld	s3,24(sp)
    80000dfe:	6a42                	ld	s4,16(sp)
    80000e00:	6aa2                	ld	s5,8(sp)
    80000e02:	6b02                	ld	s6,0(sp)
    80000e04:	6121                	addi	sp,sp,64
    80000e06:	8082                	ret
      panic("kalloc");
    80000e08:	00007517          	auipc	a0,0x7
    80000e0c:	39050513          	addi	a0,a0,912 # 80008198 <etext+0x198>
    80000e10:	00005097          	auipc	ra,0x5
    80000e14:	024080e7          	jalr	36(ra) # 80005e34 <panic>

0000000080000e18 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e18:	7139                	addi	sp,sp,-64
    80000e1a:	fc06                	sd	ra,56(sp)
    80000e1c:	f822                	sd	s0,48(sp)
    80000e1e:	f426                	sd	s1,40(sp)
    80000e20:	f04a                	sd	s2,32(sp)
    80000e22:	ec4e                	sd	s3,24(sp)
    80000e24:	e852                	sd	s4,16(sp)
    80000e26:	e456                	sd	s5,8(sp)
    80000e28:	e05a                	sd	s6,0(sp)
    80000e2a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e2c:	00007597          	auipc	a1,0x7
    80000e30:	37458593          	addi	a1,a1,884 # 800081a0 <etext+0x1a0>
    80000e34:	00008517          	auipc	a0,0x8
    80000e38:	b0c50513          	addi	a0,a0,-1268 # 80008940 <pid_lock>
    80000e3c:	00005097          	auipc	ra,0x5
    80000e40:	4b8080e7          	jalr	1208(ra) # 800062f4 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e44:	00007597          	auipc	a1,0x7
    80000e48:	36458593          	addi	a1,a1,868 # 800081a8 <etext+0x1a8>
    80000e4c:	00008517          	auipc	a0,0x8
    80000e50:	b0c50513          	addi	a0,a0,-1268 # 80008958 <wait_lock>
    80000e54:	00005097          	auipc	ra,0x5
    80000e58:	4a0080e7          	jalr	1184(ra) # 800062f4 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e5c:	00008497          	auipc	s1,0x8
    80000e60:	f1448493          	addi	s1,s1,-236 # 80008d70 <proc>
      initlock(&p->lock, "proc");
    80000e64:	00007b17          	auipc	s6,0x7
    80000e68:	354b0b13          	addi	s6,s6,852 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e6c:	8aa6                	mv	s5,s1
    80000e6e:	04fa5937          	lui	s2,0x4fa5
    80000e72:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000e76:	0932                	slli	s2,s2,0xc
    80000e78:	fa590913          	addi	s2,s2,-91
    80000e7c:	0932                	slli	s2,s2,0xc
    80000e7e:	fa590913          	addi	s2,s2,-91
    80000e82:	0932                	slli	s2,s2,0xc
    80000e84:	fa590913          	addi	s2,s2,-91
    80000e88:	040009b7          	lui	s3,0x4000
    80000e8c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e8e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e90:	0000ea17          	auipc	s4,0xe
    80000e94:	8e0a0a13          	addi	s4,s4,-1824 # 8000e770 <tickslock>
      initlock(&p->lock, "proc");
    80000e98:	85da                	mv	a1,s6
    80000e9a:	8526                	mv	a0,s1
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	458080e7          	jalr	1112(ra) # 800062f4 <initlock>
      p->state = UNUSED;
    80000ea4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ea8:	415487b3          	sub	a5,s1,s5
    80000eac:	878d                	srai	a5,a5,0x3
    80000eae:	032787b3          	mul	a5,a5,s2
    80000eb2:	2785                	addiw	a5,a5,1
    80000eb4:	00d7979b          	slliw	a5,a5,0xd
    80000eb8:	40f987b3          	sub	a5,s3,a5
    80000ebc:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ebe:	16848493          	addi	s1,s1,360
    80000ec2:	fd449be3          	bne	s1,s4,80000e98 <procinit+0x80>
  }
}
    80000ec6:	70e2                	ld	ra,56(sp)
    80000ec8:	7442                	ld	s0,48(sp)
    80000eca:	74a2                	ld	s1,40(sp)
    80000ecc:	7902                	ld	s2,32(sp)
    80000ece:	69e2                	ld	s3,24(sp)
    80000ed0:	6a42                	ld	s4,16(sp)
    80000ed2:	6aa2                	ld	s5,8(sp)
    80000ed4:	6b02                	ld	s6,0(sp)
    80000ed6:	6121                	addi	sp,sp,64
    80000ed8:	8082                	ret

0000000080000eda <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000eda:	1141                	addi	sp,sp,-16
    80000edc:	e422                	sd	s0,8(sp)
    80000ede:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000ee0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000ee2:	2501                	sext.w	a0,a0
    80000ee4:	6422                	ld	s0,8(sp)
    80000ee6:	0141                	addi	sp,sp,16
    80000ee8:	8082                	ret

0000000080000eea <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000eea:	1141                	addi	sp,sp,-16
    80000eec:	e422                	sd	s0,8(sp)
    80000eee:	0800                	addi	s0,sp,16
    80000ef0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000ef2:	2781                	sext.w	a5,a5
    80000ef4:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ef6:	00008517          	auipc	a0,0x8
    80000efa:	a7a50513          	addi	a0,a0,-1414 # 80008970 <cpus>
    80000efe:	953e                	add	a0,a0,a5
    80000f00:	6422                	ld	s0,8(sp)
    80000f02:	0141                	addi	sp,sp,16
    80000f04:	8082                	ret

0000000080000f06 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f06:	1101                	addi	sp,sp,-32
    80000f08:	ec06                	sd	ra,24(sp)
    80000f0a:	e822                	sd	s0,16(sp)
    80000f0c:	e426                	sd	s1,8(sp)
    80000f0e:	1000                	addi	s0,sp,32
  push_off();
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	428080e7          	jalr	1064(ra) # 80006338 <push_off>
    80000f18:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f1a:	2781                	sext.w	a5,a5
    80000f1c:	079e                	slli	a5,a5,0x7
    80000f1e:	00008717          	auipc	a4,0x8
    80000f22:	a2270713          	addi	a4,a4,-1502 # 80008940 <pid_lock>
    80000f26:	97ba                	add	a5,a5,a4
    80000f28:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f2a:	00005097          	auipc	ra,0x5
    80000f2e:	4ae080e7          	jalr	1198(ra) # 800063d8 <pop_off>
  return p;
}
    80000f32:	8526                	mv	a0,s1
    80000f34:	60e2                	ld	ra,24(sp)
    80000f36:	6442                	ld	s0,16(sp)
    80000f38:	64a2                	ld	s1,8(sp)
    80000f3a:	6105                	addi	sp,sp,32
    80000f3c:	8082                	ret

0000000080000f3e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f3e:	1141                	addi	sp,sp,-16
    80000f40:	e406                	sd	ra,8(sp)
    80000f42:	e022                	sd	s0,0(sp)
    80000f44:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f46:	00000097          	auipc	ra,0x0
    80000f4a:	fc0080e7          	jalr	-64(ra) # 80000f06 <myproc>
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	4ea080e7          	jalr	1258(ra) # 80006438 <release>

  if (first) {
    80000f56:	00008797          	auipc	a5,0x8
    80000f5a:	94a7a783          	lw	a5,-1718(a5) # 800088a0 <first.1>
    80000f5e:	eb89                	bnez	a5,80000f70 <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f60:	00001097          	auipc	ra,0x1
    80000f64:	c62080e7          	jalr	-926(ra) # 80001bc2 <usertrapret>
}
    80000f68:	60a2                	ld	ra,8(sp)
    80000f6a:	6402                	ld	s0,0(sp)
    80000f6c:	0141                	addi	sp,sp,16
    80000f6e:	8082                	ret
    fsinit(ROOTDEV);
    80000f70:	4505                	li	a0,1
    80000f72:	00002097          	auipc	ra,0x2
    80000f76:	9d4080e7          	jalr	-1580(ra) # 80002946 <fsinit>
    first = 0;
    80000f7a:	00008797          	auipc	a5,0x8
    80000f7e:	9207a323          	sw	zero,-1754(a5) # 800088a0 <first.1>
    __sync_synchronize();
    80000f82:	0ff0000f          	fence
    80000f86:	bfe9                	j	80000f60 <forkret+0x22>

0000000080000f88 <allocpid>:
{
    80000f88:	1101                	addi	sp,sp,-32
    80000f8a:	ec06                	sd	ra,24(sp)
    80000f8c:	e822                	sd	s0,16(sp)
    80000f8e:	e426                	sd	s1,8(sp)
    80000f90:	e04a                	sd	s2,0(sp)
    80000f92:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f94:	00008917          	auipc	s2,0x8
    80000f98:	9ac90913          	addi	s2,s2,-1620 # 80008940 <pid_lock>
    80000f9c:	854a                	mv	a0,s2
    80000f9e:	00005097          	auipc	ra,0x5
    80000fa2:	3e6080e7          	jalr	998(ra) # 80006384 <acquire>
  pid = nextpid;
    80000fa6:	00008797          	auipc	a5,0x8
    80000faa:	8fe78793          	addi	a5,a5,-1794 # 800088a4 <nextpid>
    80000fae:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fb0:	0014871b          	addiw	a4,s1,1
    80000fb4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fb6:	854a                	mv	a0,s2
    80000fb8:	00005097          	auipc	ra,0x5
    80000fbc:	480080e7          	jalr	1152(ra) # 80006438 <release>
}
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	60e2                	ld	ra,24(sp)
    80000fc4:	6442                	ld	s0,16(sp)
    80000fc6:	64a2                	ld	s1,8(sp)
    80000fc8:	6902                	ld	s2,0(sp)
    80000fca:	6105                	addi	sp,sp,32
    80000fcc:	8082                	ret

0000000080000fce <proc_pagetable>:
{
    80000fce:	1101                	addi	sp,sp,-32
    80000fd0:	ec06                	sd	ra,24(sp)
    80000fd2:	e822                	sd	s0,16(sp)
    80000fd4:	e426                	sd	s1,8(sp)
    80000fd6:	e04a                	sd	s2,0(sp)
    80000fd8:	1000                	addi	s0,sp,32
    80000fda:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	820080e7          	jalr	-2016(ra) # 800007fc <uvmcreate>
    80000fe4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000fe6:	c121                	beqz	a0,80001026 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fe8:	4729                	li	a4,10
    80000fea:	00006697          	auipc	a3,0x6
    80000fee:	01668693          	addi	a3,a3,22 # 80007000 <_trampoline>
    80000ff2:	6605                	lui	a2,0x1
    80000ff4:	040005b7          	lui	a1,0x4000
    80000ff8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ffa:	05b2                	slli	a1,a1,0xc
    80000ffc:	fffff097          	auipc	ra,0xfffff
    80001000:	542080e7          	jalr	1346(ra) # 8000053e <mappages>
    80001004:	02054863          	bltz	a0,80001034 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001008:	4719                	li	a4,6
    8000100a:	05893683          	ld	a3,88(s2)
    8000100e:	6605                	lui	a2,0x1
    80001010:	020005b7          	lui	a1,0x2000
    80001014:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001016:	05b6                	slli	a1,a1,0xd
    80001018:	8526                	mv	a0,s1
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	524080e7          	jalr	1316(ra) # 8000053e <mappages>
    80001022:	02054163          	bltz	a0,80001044 <proc_pagetable+0x76>
}
    80001026:	8526                	mv	a0,s1
    80001028:	60e2                	ld	ra,24(sp)
    8000102a:	6442                	ld	s0,16(sp)
    8000102c:	64a2                	ld	s1,8(sp)
    8000102e:	6902                	ld	s2,0(sp)
    80001030:	6105                	addi	sp,sp,32
    80001032:	8082                	ret
    uvmfree(pagetable, 0);
    80001034:	4581                	li	a1,0
    80001036:	8526                	mv	a0,s1
    80001038:	00000097          	auipc	ra,0x0
    8000103c:	9d6080e7          	jalr	-1578(ra) # 80000a0e <uvmfree>
    return 0;
    80001040:	4481                	li	s1,0
    80001042:	b7d5                	j	80001026 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001044:	4681                	li	a3,0
    80001046:	4605                	li	a2,1
    80001048:	040005b7          	lui	a1,0x4000
    8000104c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000104e:	05b2                	slli	a1,a1,0xc
    80001050:	8526                	mv	a0,s1
    80001052:	fffff097          	auipc	ra,0xfffff
    80001056:	6d6080e7          	jalr	1750(ra) # 80000728 <uvmunmap>
    uvmfree(pagetable, 0);
    8000105a:	4581                	li	a1,0
    8000105c:	8526                	mv	a0,s1
    8000105e:	00000097          	auipc	ra,0x0
    80001062:	9b0080e7          	jalr	-1616(ra) # 80000a0e <uvmfree>
    return 0;
    80001066:	4481                	li	s1,0
    80001068:	bf7d                	j	80001026 <proc_pagetable+0x58>

000000008000106a <proc_freepagetable>:
{
    8000106a:	1101                	addi	sp,sp,-32
    8000106c:	ec06                	sd	ra,24(sp)
    8000106e:	e822                	sd	s0,16(sp)
    80001070:	e426                	sd	s1,8(sp)
    80001072:	e04a                	sd	s2,0(sp)
    80001074:	1000                	addi	s0,sp,32
    80001076:	84aa                	mv	s1,a0
    80001078:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000107a:	4681                	li	a3,0
    8000107c:	4605                	li	a2,1
    8000107e:	040005b7          	lui	a1,0x4000
    80001082:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001084:	05b2                	slli	a1,a1,0xc
    80001086:	fffff097          	auipc	ra,0xfffff
    8000108a:	6a2080e7          	jalr	1698(ra) # 80000728 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000108e:	4681                	li	a3,0
    80001090:	4605                	li	a2,1
    80001092:	020005b7          	lui	a1,0x2000
    80001096:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001098:	05b6                	slli	a1,a1,0xd
    8000109a:	8526                	mv	a0,s1
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	68c080e7          	jalr	1676(ra) # 80000728 <uvmunmap>
  uvmfree(pagetable, sz);
    800010a4:	85ca                	mv	a1,s2
    800010a6:	8526                	mv	a0,s1
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	966080e7          	jalr	-1690(ra) # 80000a0e <uvmfree>
}
    800010b0:	60e2                	ld	ra,24(sp)
    800010b2:	6442                	ld	s0,16(sp)
    800010b4:	64a2                	ld	s1,8(sp)
    800010b6:	6902                	ld	s2,0(sp)
    800010b8:	6105                	addi	sp,sp,32
    800010ba:	8082                	ret

00000000800010bc <freeproc>:
{
    800010bc:	1101                	addi	sp,sp,-32
    800010be:	ec06                	sd	ra,24(sp)
    800010c0:	e822                	sd	s0,16(sp)
    800010c2:	e426                	sd	s1,8(sp)
    800010c4:	1000                	addi	s0,sp,32
    800010c6:	84aa                	mv	s1,a0
  if(p->trapframe)
    800010c8:	6d28                	ld	a0,88(a0)
    800010ca:	c509                	beqz	a0,800010d4 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800010cc:	fffff097          	auipc	ra,0xfffff
    800010d0:	f50080e7          	jalr	-176(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800010d4:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800010d8:	68a8                	ld	a0,80(s1)
    800010da:	c511                	beqz	a0,800010e6 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800010dc:	64ac                	ld	a1,72(s1)
    800010de:	00000097          	auipc	ra,0x0
    800010e2:	f8c080e7          	jalr	-116(ra) # 8000106a <proc_freepagetable>
  p->pagetable = 0;
    800010e6:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010ea:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010ee:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010f2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010f6:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010fa:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010fe:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001102:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001106:	0004ac23          	sw	zero,24(s1)
}
    8000110a:	60e2                	ld	ra,24(sp)
    8000110c:	6442                	ld	s0,16(sp)
    8000110e:	64a2                	ld	s1,8(sp)
    80001110:	6105                	addi	sp,sp,32
    80001112:	8082                	ret

0000000080001114 <allocproc>:
{
    80001114:	1101                	addi	sp,sp,-32
    80001116:	ec06                	sd	ra,24(sp)
    80001118:	e822                	sd	s0,16(sp)
    8000111a:	e426                	sd	s1,8(sp)
    8000111c:	e04a                	sd	s2,0(sp)
    8000111e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001120:	00008497          	auipc	s1,0x8
    80001124:	c5048493          	addi	s1,s1,-944 # 80008d70 <proc>
    80001128:	0000d917          	auipc	s2,0xd
    8000112c:	64890913          	addi	s2,s2,1608 # 8000e770 <tickslock>
    acquire(&p->lock);
    80001130:	8526                	mv	a0,s1
    80001132:	00005097          	auipc	ra,0x5
    80001136:	252080e7          	jalr	594(ra) # 80006384 <acquire>
    if(p->state == UNUSED) {
    8000113a:	4c9c                	lw	a5,24(s1)
    8000113c:	cf81                	beqz	a5,80001154 <allocproc+0x40>
      release(&p->lock);
    8000113e:	8526                	mv	a0,s1
    80001140:	00005097          	auipc	ra,0x5
    80001144:	2f8080e7          	jalr	760(ra) # 80006438 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001148:	16848493          	addi	s1,s1,360
    8000114c:	ff2492e3          	bne	s1,s2,80001130 <allocproc+0x1c>
  return 0;
    80001150:	4481                	li	s1,0
    80001152:	a889                	j	800011a4 <allocproc+0x90>
  p->pid = allocpid();
    80001154:	00000097          	auipc	ra,0x0
    80001158:	e34080e7          	jalr	-460(ra) # 80000f88 <allocpid>
    8000115c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000115e:	4785                	li	a5,1
    80001160:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001162:	fffff097          	auipc	ra,0xfffff
    80001166:	fb8080e7          	jalr	-72(ra) # 8000011a <kalloc>
    8000116a:	892a                	mv	s2,a0
    8000116c:	eca8                	sd	a0,88(s1)
    8000116e:	c131                	beqz	a0,800011b2 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001170:	8526                	mv	a0,s1
    80001172:	00000097          	auipc	ra,0x0
    80001176:	e5c080e7          	jalr	-420(ra) # 80000fce <proc_pagetable>
    8000117a:	892a                	mv	s2,a0
    8000117c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000117e:	c531                	beqz	a0,800011ca <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001180:	07000613          	li	a2,112
    80001184:	4581                	li	a1,0
    80001186:	06048513          	addi	a0,s1,96
    8000118a:	fffff097          	auipc	ra,0xfffff
    8000118e:	ff0080e7          	jalr	-16(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001192:	00000797          	auipc	a5,0x0
    80001196:	dac78793          	addi	a5,a5,-596 # 80000f3e <forkret>
    8000119a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000119c:	60bc                	ld	a5,64(s1)
    8000119e:	6705                	lui	a4,0x1
    800011a0:	97ba                	add	a5,a5,a4
    800011a2:	f4bc                	sd	a5,104(s1)
}
    800011a4:	8526                	mv	a0,s1
    800011a6:	60e2                	ld	ra,24(sp)
    800011a8:	6442                	ld	s0,16(sp)
    800011aa:	64a2                	ld	s1,8(sp)
    800011ac:	6902                	ld	s2,0(sp)
    800011ae:	6105                	addi	sp,sp,32
    800011b0:	8082                	ret
    freeproc(p);
    800011b2:	8526                	mv	a0,s1
    800011b4:	00000097          	auipc	ra,0x0
    800011b8:	f08080e7          	jalr	-248(ra) # 800010bc <freeproc>
    release(&p->lock);
    800011bc:	8526                	mv	a0,s1
    800011be:	00005097          	auipc	ra,0x5
    800011c2:	27a080e7          	jalr	634(ra) # 80006438 <release>
    return 0;
    800011c6:	84ca                	mv	s1,s2
    800011c8:	bff1                	j	800011a4 <allocproc+0x90>
    freeproc(p);
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	ef0080e7          	jalr	-272(ra) # 800010bc <freeproc>
    release(&p->lock);
    800011d4:	8526                	mv	a0,s1
    800011d6:	00005097          	auipc	ra,0x5
    800011da:	262080e7          	jalr	610(ra) # 80006438 <release>
    return 0;
    800011de:	84ca                	mv	s1,s2
    800011e0:	b7d1                	j	800011a4 <allocproc+0x90>

00000000800011e2 <userinit>:
{
    800011e2:	1101                	addi	sp,sp,-32
    800011e4:	ec06                	sd	ra,24(sp)
    800011e6:	e822                	sd	s0,16(sp)
    800011e8:	e426                	sd	s1,8(sp)
    800011ea:	1000                	addi	s0,sp,32
  p = allocproc();
    800011ec:	00000097          	auipc	ra,0x0
    800011f0:	f28080e7          	jalr	-216(ra) # 80001114 <allocproc>
    800011f4:	84aa                	mv	s1,a0
  initproc = p;
    800011f6:	00007797          	auipc	a5,0x7
    800011fa:	70a7b523          	sd	a0,1802(a5) # 80008900 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011fe:	03400613          	li	a2,52
    80001202:	00007597          	auipc	a1,0x7
    80001206:	6ae58593          	addi	a1,a1,1710 # 800088b0 <initcode>
    8000120a:	6928                	ld	a0,80(a0)
    8000120c:	fffff097          	auipc	ra,0xfffff
    80001210:	61e080e7          	jalr	1566(ra) # 8000082a <uvmfirst>
  p->sz = PGSIZE;
    80001214:	6785                	lui	a5,0x1
    80001216:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001218:	6cb8                	ld	a4,88(s1)
    8000121a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000121e:	6cb8                	ld	a4,88(s1)
    80001220:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001222:	4641                	li	a2,16
    80001224:	00007597          	auipc	a1,0x7
    80001228:	f9c58593          	addi	a1,a1,-100 # 800081c0 <etext+0x1c0>
    8000122c:	15848513          	addi	a0,s1,344
    80001230:	fffff097          	auipc	ra,0xfffff
    80001234:	08c080e7          	jalr	140(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    80001238:	00007517          	auipc	a0,0x7
    8000123c:	f9850513          	addi	a0,a0,-104 # 800081d0 <etext+0x1d0>
    80001240:	00002097          	auipc	ra,0x2
    80001244:	158080e7          	jalr	344(ra) # 80003398 <namei>
    80001248:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000124c:	478d                	li	a5,3
    8000124e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001250:	8526                	mv	a0,s1
    80001252:	00005097          	auipc	ra,0x5
    80001256:	1e6080e7          	jalr	486(ra) # 80006438 <release>
}
    8000125a:	60e2                	ld	ra,24(sp)
    8000125c:	6442                	ld	s0,16(sp)
    8000125e:	64a2                	ld	s1,8(sp)
    80001260:	6105                	addi	sp,sp,32
    80001262:	8082                	ret

0000000080001264 <growproc>:
{
    80001264:	1101                	addi	sp,sp,-32
    80001266:	ec06                	sd	ra,24(sp)
    80001268:	e822                	sd	s0,16(sp)
    8000126a:	e426                	sd	s1,8(sp)
    8000126c:	e04a                	sd	s2,0(sp)
    8000126e:	1000                	addi	s0,sp,32
    80001270:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001272:	00000097          	auipc	ra,0x0
    80001276:	c94080e7          	jalr	-876(ra) # 80000f06 <myproc>
    8000127a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000127c:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000127e:	01204c63          	bgtz	s2,80001296 <growproc+0x32>
  } else if(n < 0){
    80001282:	02094663          	bltz	s2,800012ae <growproc+0x4a>
  p->sz = sz;
    80001286:	e4ac                	sd	a1,72(s1)
  return 0;
    80001288:	4501                	li	a0,0
}
    8000128a:	60e2                	ld	ra,24(sp)
    8000128c:	6442                	ld	s0,16(sp)
    8000128e:	64a2                	ld	s1,8(sp)
    80001290:	6902                	ld	s2,0(sp)
    80001292:	6105                	addi	sp,sp,32
    80001294:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001296:	4691                	li	a3,4
    80001298:	00b90633          	add	a2,s2,a1
    8000129c:	6928                	ld	a0,80(a0)
    8000129e:	fffff097          	auipc	ra,0xfffff
    800012a2:	646080e7          	jalr	1606(ra) # 800008e4 <uvmalloc>
    800012a6:	85aa                	mv	a1,a0
    800012a8:	fd79                	bnez	a0,80001286 <growproc+0x22>
      return -1;
    800012aa:	557d                	li	a0,-1
    800012ac:	bff9                	j	8000128a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800012ae:	00b90633          	add	a2,s2,a1
    800012b2:	6928                	ld	a0,80(a0)
    800012b4:	fffff097          	auipc	ra,0xfffff
    800012b8:	5e8080e7          	jalr	1512(ra) # 8000089c <uvmdealloc>
    800012bc:	85aa                	mv	a1,a0
    800012be:	b7e1                	j	80001286 <growproc+0x22>

00000000800012c0 <fork>:
{
    800012c0:	7139                	addi	sp,sp,-64
    800012c2:	fc06                	sd	ra,56(sp)
    800012c4:	f822                	sd	s0,48(sp)
    800012c6:	f04a                	sd	s2,32(sp)
    800012c8:	e456                	sd	s5,8(sp)
    800012ca:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800012cc:	00000097          	auipc	ra,0x0
    800012d0:	c3a080e7          	jalr	-966(ra) # 80000f06 <myproc>
    800012d4:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800012d6:	00000097          	auipc	ra,0x0
    800012da:	e3e080e7          	jalr	-450(ra) # 80001114 <allocproc>
    800012de:	12050063          	beqz	a0,800013fe <fork+0x13e>
    800012e2:	e852                	sd	s4,16(sp)
    800012e4:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012e6:	048ab603          	ld	a2,72(s5)
    800012ea:	692c                	ld	a1,80(a0)
    800012ec:	050ab503          	ld	a0,80(s5)
    800012f0:	fffff097          	auipc	ra,0xfffff
    800012f4:	758080e7          	jalr	1880(ra) # 80000a48 <uvmcopy>
    800012f8:	04054a63          	bltz	a0,8000134c <fork+0x8c>
    800012fc:	f426                	sd	s1,40(sp)
    800012fe:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001300:	048ab783          	ld	a5,72(s5)
    80001304:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001308:	058ab683          	ld	a3,88(s5)
    8000130c:	87b6                	mv	a5,a3
    8000130e:	058a3703          	ld	a4,88(s4)
    80001312:	12068693          	addi	a3,a3,288
    80001316:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000131a:	6788                	ld	a0,8(a5)
    8000131c:	6b8c                	ld	a1,16(a5)
    8000131e:	6f90                	ld	a2,24(a5)
    80001320:	01073023          	sd	a6,0(a4)
    80001324:	e708                	sd	a0,8(a4)
    80001326:	eb0c                	sd	a1,16(a4)
    80001328:	ef10                	sd	a2,24(a4)
    8000132a:	02078793          	addi	a5,a5,32
    8000132e:	02070713          	addi	a4,a4,32
    80001332:	fed792e3          	bne	a5,a3,80001316 <fork+0x56>
  np->trapframe->a0 = 0;
    80001336:	058a3783          	ld	a5,88(s4)
    8000133a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000133e:	0d0a8493          	addi	s1,s5,208
    80001342:	0d0a0913          	addi	s2,s4,208
    80001346:	150a8993          	addi	s3,s5,336
    8000134a:	a015                	j	8000136e <fork+0xae>
    freeproc(np);
    8000134c:	8552                	mv	a0,s4
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	d6e080e7          	jalr	-658(ra) # 800010bc <freeproc>
    release(&np->lock);
    80001356:	8552                	mv	a0,s4
    80001358:	00005097          	auipc	ra,0x5
    8000135c:	0e0080e7          	jalr	224(ra) # 80006438 <release>
    return -1;
    80001360:	597d                	li	s2,-1
    80001362:	6a42                	ld	s4,16(sp)
    80001364:	a071                	j	800013f0 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001366:	04a1                	addi	s1,s1,8
    80001368:	0921                	addi	s2,s2,8
    8000136a:	01348b63          	beq	s1,s3,80001380 <fork+0xc0>
    if(p->ofile[i])
    8000136e:	6088                	ld	a0,0(s1)
    80001370:	d97d                	beqz	a0,80001366 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001372:	00002097          	auipc	ra,0x2
    80001376:	69e080e7          	jalr	1694(ra) # 80003a10 <filedup>
    8000137a:	00a93023          	sd	a0,0(s2)
    8000137e:	b7e5                	j	80001366 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001380:	150ab503          	ld	a0,336(s5)
    80001384:	00002097          	auipc	ra,0x2
    80001388:	808080e7          	jalr	-2040(ra) # 80002b8c <idup>
    8000138c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001390:	4641                	li	a2,16
    80001392:	158a8593          	addi	a1,s5,344
    80001396:	158a0513          	addi	a0,s4,344
    8000139a:	fffff097          	auipc	ra,0xfffff
    8000139e:	f22080e7          	jalr	-222(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    800013a2:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800013a6:	8552                	mv	a0,s4
    800013a8:	00005097          	auipc	ra,0x5
    800013ac:	090080e7          	jalr	144(ra) # 80006438 <release>
  acquire(&wait_lock);
    800013b0:	00007497          	auipc	s1,0x7
    800013b4:	5a848493          	addi	s1,s1,1448 # 80008958 <wait_lock>
    800013b8:	8526                	mv	a0,s1
    800013ba:	00005097          	auipc	ra,0x5
    800013be:	fca080e7          	jalr	-54(ra) # 80006384 <acquire>
  np->parent = p;
    800013c2:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800013c6:	8526                	mv	a0,s1
    800013c8:	00005097          	auipc	ra,0x5
    800013cc:	070080e7          	jalr	112(ra) # 80006438 <release>
  acquire(&np->lock);
    800013d0:	8552                	mv	a0,s4
    800013d2:	00005097          	auipc	ra,0x5
    800013d6:	fb2080e7          	jalr	-78(ra) # 80006384 <acquire>
  np->state = RUNNABLE;
    800013da:	478d                	li	a5,3
    800013dc:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013e0:	8552                	mv	a0,s4
    800013e2:	00005097          	auipc	ra,0x5
    800013e6:	056080e7          	jalr	86(ra) # 80006438 <release>
  return pid;
    800013ea:	74a2                	ld	s1,40(sp)
    800013ec:	69e2                	ld	s3,24(sp)
    800013ee:	6a42                	ld	s4,16(sp)
}
    800013f0:	854a                	mv	a0,s2
    800013f2:	70e2                	ld	ra,56(sp)
    800013f4:	7442                	ld	s0,48(sp)
    800013f6:	7902                	ld	s2,32(sp)
    800013f8:	6aa2                	ld	s5,8(sp)
    800013fa:	6121                	addi	sp,sp,64
    800013fc:	8082                	ret
    return -1;
    800013fe:	597d                	li	s2,-1
    80001400:	bfc5                	j	800013f0 <fork+0x130>

0000000080001402 <scheduler>:
{
    80001402:	7139                	addi	sp,sp,-64
    80001404:	fc06                	sd	ra,56(sp)
    80001406:	f822                	sd	s0,48(sp)
    80001408:	f426                	sd	s1,40(sp)
    8000140a:	f04a                	sd	s2,32(sp)
    8000140c:	ec4e                	sd	s3,24(sp)
    8000140e:	e852                	sd	s4,16(sp)
    80001410:	e456                	sd	s5,8(sp)
    80001412:	e05a                	sd	s6,0(sp)
    80001414:	0080                	addi	s0,sp,64
    80001416:	8792                	mv	a5,tp
  int id = r_tp();
    80001418:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000141a:	00779a93          	slli	s5,a5,0x7
    8000141e:	00007717          	auipc	a4,0x7
    80001422:	52270713          	addi	a4,a4,1314 # 80008940 <pid_lock>
    80001426:	9756                	add	a4,a4,s5
    80001428:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000142c:	00007717          	auipc	a4,0x7
    80001430:	54c70713          	addi	a4,a4,1356 # 80008978 <cpus+0x8>
    80001434:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001436:	498d                	li	s3,3
        p->state = RUNNING;
    80001438:	4b11                	li	s6,4
        c->proc = p;
    8000143a:	079e                	slli	a5,a5,0x7
    8000143c:	00007a17          	auipc	s4,0x7
    80001440:	504a0a13          	addi	s4,s4,1284 # 80008940 <pid_lock>
    80001444:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001446:	0000d917          	auipc	s2,0xd
    8000144a:	32a90913          	addi	s2,s2,810 # 8000e770 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000144e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001452:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001456:	10079073          	csrw	sstatus,a5
    8000145a:	00008497          	auipc	s1,0x8
    8000145e:	91648493          	addi	s1,s1,-1770 # 80008d70 <proc>
    80001462:	a811                	j	80001476 <scheduler+0x74>
      release(&p->lock);
    80001464:	8526                	mv	a0,s1
    80001466:	00005097          	auipc	ra,0x5
    8000146a:	fd2080e7          	jalr	-46(ra) # 80006438 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000146e:	16848493          	addi	s1,s1,360
    80001472:	fd248ee3          	beq	s1,s2,8000144e <scheduler+0x4c>
      acquire(&p->lock);
    80001476:	8526                	mv	a0,s1
    80001478:	00005097          	auipc	ra,0x5
    8000147c:	f0c080e7          	jalr	-244(ra) # 80006384 <acquire>
      if(p->state == RUNNABLE) {
    80001480:	4c9c                	lw	a5,24(s1)
    80001482:	ff3791e3          	bne	a5,s3,80001464 <scheduler+0x62>
        p->state = RUNNING;
    80001486:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000148a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000148e:	06048593          	addi	a1,s1,96
    80001492:	8556                	mv	a0,s5
    80001494:	00000097          	auipc	ra,0x0
    80001498:	684080e7          	jalr	1668(ra) # 80001b18 <swtch>
        c->proc = 0;
    8000149c:	020a3823          	sd	zero,48(s4)
    800014a0:	b7d1                	j	80001464 <scheduler+0x62>

00000000800014a2 <sched>:
{
    800014a2:	7179                	addi	sp,sp,-48
    800014a4:	f406                	sd	ra,40(sp)
    800014a6:	f022                	sd	s0,32(sp)
    800014a8:	ec26                	sd	s1,24(sp)
    800014aa:	e84a                	sd	s2,16(sp)
    800014ac:	e44e                	sd	s3,8(sp)
    800014ae:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014b0:	00000097          	auipc	ra,0x0
    800014b4:	a56080e7          	jalr	-1450(ra) # 80000f06 <myproc>
    800014b8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800014ba:	00005097          	auipc	ra,0x5
    800014be:	e50080e7          	jalr	-432(ra) # 8000630a <holding>
    800014c2:	c93d                	beqz	a0,80001538 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014c4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014c6:	2781                	sext.w	a5,a5
    800014c8:	079e                	slli	a5,a5,0x7
    800014ca:	00007717          	auipc	a4,0x7
    800014ce:	47670713          	addi	a4,a4,1142 # 80008940 <pid_lock>
    800014d2:	97ba                	add	a5,a5,a4
    800014d4:	0a87a703          	lw	a4,168(a5)
    800014d8:	4785                	li	a5,1
    800014da:	06f71763          	bne	a4,a5,80001548 <sched+0xa6>
  if(p->state == RUNNING)
    800014de:	4c98                	lw	a4,24(s1)
    800014e0:	4791                	li	a5,4
    800014e2:	06f70b63          	beq	a4,a5,80001558 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014e6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014ea:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014ec:	efb5                	bnez	a5,80001568 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014ee:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014f0:	00007917          	auipc	s2,0x7
    800014f4:	45090913          	addi	s2,s2,1104 # 80008940 <pid_lock>
    800014f8:	2781                	sext.w	a5,a5
    800014fa:	079e                	slli	a5,a5,0x7
    800014fc:	97ca                	add	a5,a5,s2
    800014fe:	0ac7a983          	lw	s3,172(a5)
    80001502:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001504:	2781                	sext.w	a5,a5
    80001506:	079e                	slli	a5,a5,0x7
    80001508:	00007597          	auipc	a1,0x7
    8000150c:	47058593          	addi	a1,a1,1136 # 80008978 <cpus+0x8>
    80001510:	95be                	add	a1,a1,a5
    80001512:	06048513          	addi	a0,s1,96
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	602080e7          	jalr	1538(ra) # 80001b18 <swtch>
    8000151e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001520:	2781                	sext.w	a5,a5
    80001522:	079e                	slli	a5,a5,0x7
    80001524:	993e                	add	s2,s2,a5
    80001526:	0b392623          	sw	s3,172(s2)
}
    8000152a:	70a2                	ld	ra,40(sp)
    8000152c:	7402                	ld	s0,32(sp)
    8000152e:	64e2                	ld	s1,24(sp)
    80001530:	6942                	ld	s2,16(sp)
    80001532:	69a2                	ld	s3,8(sp)
    80001534:	6145                	addi	sp,sp,48
    80001536:	8082                	ret
    panic("sched p->lock");
    80001538:	00007517          	auipc	a0,0x7
    8000153c:	ca050513          	addi	a0,a0,-864 # 800081d8 <etext+0x1d8>
    80001540:	00005097          	auipc	ra,0x5
    80001544:	8f4080e7          	jalr	-1804(ra) # 80005e34 <panic>
    panic("sched locks");
    80001548:	00007517          	auipc	a0,0x7
    8000154c:	ca050513          	addi	a0,a0,-864 # 800081e8 <etext+0x1e8>
    80001550:	00005097          	auipc	ra,0x5
    80001554:	8e4080e7          	jalr	-1820(ra) # 80005e34 <panic>
    panic("sched running");
    80001558:	00007517          	auipc	a0,0x7
    8000155c:	ca050513          	addi	a0,a0,-864 # 800081f8 <etext+0x1f8>
    80001560:	00005097          	auipc	ra,0x5
    80001564:	8d4080e7          	jalr	-1836(ra) # 80005e34 <panic>
    panic("sched interruptible");
    80001568:	00007517          	auipc	a0,0x7
    8000156c:	ca050513          	addi	a0,a0,-864 # 80008208 <etext+0x208>
    80001570:	00005097          	auipc	ra,0x5
    80001574:	8c4080e7          	jalr	-1852(ra) # 80005e34 <panic>

0000000080001578 <yield>:
{
    80001578:	1101                	addi	sp,sp,-32
    8000157a:	ec06                	sd	ra,24(sp)
    8000157c:	e822                	sd	s0,16(sp)
    8000157e:	e426                	sd	s1,8(sp)
    80001580:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001582:	00000097          	auipc	ra,0x0
    80001586:	984080e7          	jalr	-1660(ra) # 80000f06 <myproc>
    8000158a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000158c:	00005097          	auipc	ra,0x5
    80001590:	df8080e7          	jalr	-520(ra) # 80006384 <acquire>
  p->state = RUNNABLE;
    80001594:	478d                	li	a5,3
    80001596:	cc9c                	sw	a5,24(s1)
  sched();
    80001598:	00000097          	auipc	ra,0x0
    8000159c:	f0a080e7          	jalr	-246(ra) # 800014a2 <sched>
  release(&p->lock);
    800015a0:	8526                	mv	a0,s1
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	e96080e7          	jalr	-362(ra) # 80006438 <release>
}
    800015aa:	60e2                	ld	ra,24(sp)
    800015ac:	6442                	ld	s0,16(sp)
    800015ae:	64a2                	ld	s1,8(sp)
    800015b0:	6105                	addi	sp,sp,32
    800015b2:	8082                	ret

00000000800015b4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800015b4:	7179                	addi	sp,sp,-48
    800015b6:	f406                	sd	ra,40(sp)
    800015b8:	f022                	sd	s0,32(sp)
    800015ba:	ec26                	sd	s1,24(sp)
    800015bc:	e84a                	sd	s2,16(sp)
    800015be:	e44e                	sd	s3,8(sp)
    800015c0:	1800                	addi	s0,sp,48
    800015c2:	89aa                	mv	s3,a0
    800015c4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015c6:	00000097          	auipc	ra,0x0
    800015ca:	940080e7          	jalr	-1728(ra) # 80000f06 <myproc>
    800015ce:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015d0:	00005097          	auipc	ra,0x5
    800015d4:	db4080e7          	jalr	-588(ra) # 80006384 <acquire>
  release(lk);
    800015d8:	854a                	mv	a0,s2
    800015da:	00005097          	auipc	ra,0x5
    800015de:	e5e080e7          	jalr	-418(ra) # 80006438 <release>

  // Go to sleep.
  p->chan = chan;
    800015e2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015e6:	4789                	li	a5,2
    800015e8:	cc9c                	sw	a5,24(s1)

  sched();
    800015ea:	00000097          	auipc	ra,0x0
    800015ee:	eb8080e7          	jalr	-328(ra) # 800014a2 <sched>

  // Tidy up.
  p->chan = 0;
    800015f2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015f6:	8526                	mv	a0,s1
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	e40080e7          	jalr	-448(ra) # 80006438 <release>
  acquire(lk);
    80001600:	854a                	mv	a0,s2
    80001602:	00005097          	auipc	ra,0x5
    80001606:	d82080e7          	jalr	-638(ra) # 80006384 <acquire>
}
    8000160a:	70a2                	ld	ra,40(sp)
    8000160c:	7402                	ld	s0,32(sp)
    8000160e:	64e2                	ld	s1,24(sp)
    80001610:	6942                	ld	s2,16(sp)
    80001612:	69a2                	ld	s3,8(sp)
    80001614:	6145                	addi	sp,sp,48
    80001616:	8082                	ret

0000000080001618 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001618:	7139                	addi	sp,sp,-64
    8000161a:	fc06                	sd	ra,56(sp)
    8000161c:	f822                	sd	s0,48(sp)
    8000161e:	f426                	sd	s1,40(sp)
    80001620:	f04a                	sd	s2,32(sp)
    80001622:	ec4e                	sd	s3,24(sp)
    80001624:	e852                	sd	s4,16(sp)
    80001626:	e456                	sd	s5,8(sp)
    80001628:	0080                	addi	s0,sp,64
    8000162a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000162c:	00007497          	auipc	s1,0x7
    80001630:	74448493          	addi	s1,s1,1860 # 80008d70 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001634:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001636:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001638:	0000d917          	auipc	s2,0xd
    8000163c:	13890913          	addi	s2,s2,312 # 8000e770 <tickslock>
    80001640:	a811                	j	80001654 <wakeup+0x3c>
      }
      release(&p->lock);
    80001642:	8526                	mv	a0,s1
    80001644:	00005097          	auipc	ra,0x5
    80001648:	df4080e7          	jalr	-524(ra) # 80006438 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000164c:	16848493          	addi	s1,s1,360
    80001650:	03248663          	beq	s1,s2,8000167c <wakeup+0x64>
    if(p != myproc()){
    80001654:	00000097          	auipc	ra,0x0
    80001658:	8b2080e7          	jalr	-1870(ra) # 80000f06 <myproc>
    8000165c:	fea488e3          	beq	s1,a0,8000164c <wakeup+0x34>
      acquire(&p->lock);
    80001660:	8526                	mv	a0,s1
    80001662:	00005097          	auipc	ra,0x5
    80001666:	d22080e7          	jalr	-734(ra) # 80006384 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000166a:	4c9c                	lw	a5,24(s1)
    8000166c:	fd379be3          	bne	a5,s3,80001642 <wakeup+0x2a>
    80001670:	709c                	ld	a5,32(s1)
    80001672:	fd4798e3          	bne	a5,s4,80001642 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001676:	0154ac23          	sw	s5,24(s1)
    8000167a:	b7e1                	j	80001642 <wakeup+0x2a>
    }
  }
}
    8000167c:	70e2                	ld	ra,56(sp)
    8000167e:	7442                	ld	s0,48(sp)
    80001680:	74a2                	ld	s1,40(sp)
    80001682:	7902                	ld	s2,32(sp)
    80001684:	69e2                	ld	s3,24(sp)
    80001686:	6a42                	ld	s4,16(sp)
    80001688:	6aa2                	ld	s5,8(sp)
    8000168a:	6121                	addi	sp,sp,64
    8000168c:	8082                	ret

000000008000168e <reparent>:
{
    8000168e:	7179                	addi	sp,sp,-48
    80001690:	f406                	sd	ra,40(sp)
    80001692:	f022                	sd	s0,32(sp)
    80001694:	ec26                	sd	s1,24(sp)
    80001696:	e84a                	sd	s2,16(sp)
    80001698:	e44e                	sd	s3,8(sp)
    8000169a:	e052                	sd	s4,0(sp)
    8000169c:	1800                	addi	s0,sp,48
    8000169e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016a0:	00007497          	auipc	s1,0x7
    800016a4:	6d048493          	addi	s1,s1,1744 # 80008d70 <proc>
      pp->parent = initproc;
    800016a8:	00007a17          	auipc	s4,0x7
    800016ac:	258a0a13          	addi	s4,s4,600 # 80008900 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016b0:	0000d997          	auipc	s3,0xd
    800016b4:	0c098993          	addi	s3,s3,192 # 8000e770 <tickslock>
    800016b8:	a029                	j	800016c2 <reparent+0x34>
    800016ba:	16848493          	addi	s1,s1,360
    800016be:	01348d63          	beq	s1,s3,800016d8 <reparent+0x4a>
    if(pp->parent == p){
    800016c2:	7c9c                	ld	a5,56(s1)
    800016c4:	ff279be3          	bne	a5,s2,800016ba <reparent+0x2c>
      pp->parent = initproc;
    800016c8:	000a3503          	ld	a0,0(s4)
    800016cc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800016ce:	00000097          	auipc	ra,0x0
    800016d2:	f4a080e7          	jalr	-182(ra) # 80001618 <wakeup>
    800016d6:	b7d5                	j	800016ba <reparent+0x2c>
}
    800016d8:	70a2                	ld	ra,40(sp)
    800016da:	7402                	ld	s0,32(sp)
    800016dc:	64e2                	ld	s1,24(sp)
    800016de:	6942                	ld	s2,16(sp)
    800016e0:	69a2                	ld	s3,8(sp)
    800016e2:	6a02                	ld	s4,0(sp)
    800016e4:	6145                	addi	sp,sp,48
    800016e6:	8082                	ret

00000000800016e8 <exit>:
{
    800016e8:	7179                	addi	sp,sp,-48
    800016ea:	f406                	sd	ra,40(sp)
    800016ec:	f022                	sd	s0,32(sp)
    800016ee:	ec26                	sd	s1,24(sp)
    800016f0:	e84a                	sd	s2,16(sp)
    800016f2:	e44e                	sd	s3,8(sp)
    800016f4:	e052                	sd	s4,0(sp)
    800016f6:	1800                	addi	s0,sp,48
    800016f8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016fa:	00000097          	auipc	ra,0x0
    800016fe:	80c080e7          	jalr	-2036(ra) # 80000f06 <myproc>
    80001702:	89aa                	mv	s3,a0
  if(p == initproc)
    80001704:	00007797          	auipc	a5,0x7
    80001708:	1fc7b783          	ld	a5,508(a5) # 80008900 <initproc>
    8000170c:	0d050493          	addi	s1,a0,208
    80001710:	15050913          	addi	s2,a0,336
    80001714:	02a79363          	bne	a5,a0,8000173a <exit+0x52>
    panic("init exiting");
    80001718:	00007517          	auipc	a0,0x7
    8000171c:	b0850513          	addi	a0,a0,-1272 # 80008220 <etext+0x220>
    80001720:	00004097          	auipc	ra,0x4
    80001724:	714080e7          	jalr	1812(ra) # 80005e34 <panic>
      fileclose(f);
    80001728:	00002097          	auipc	ra,0x2
    8000172c:	33a080e7          	jalr	826(ra) # 80003a62 <fileclose>
      p->ofile[fd] = 0;
    80001730:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001734:	04a1                	addi	s1,s1,8
    80001736:	01248563          	beq	s1,s2,80001740 <exit+0x58>
    if(p->ofile[fd]){
    8000173a:	6088                	ld	a0,0(s1)
    8000173c:	f575                	bnez	a0,80001728 <exit+0x40>
    8000173e:	bfdd                	j	80001734 <exit+0x4c>
  begin_op();
    80001740:	00002097          	auipc	ra,0x2
    80001744:	e58080e7          	jalr	-424(ra) # 80003598 <begin_op>
  iput(p->cwd);
    80001748:	1509b503          	ld	a0,336(s3)
    8000174c:	00001097          	auipc	ra,0x1
    80001750:	63c080e7          	jalr	1596(ra) # 80002d88 <iput>
  end_op();
    80001754:	00002097          	auipc	ra,0x2
    80001758:	ebe080e7          	jalr	-322(ra) # 80003612 <end_op>
  p->cwd = 0;
    8000175c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001760:	00007497          	auipc	s1,0x7
    80001764:	1f848493          	addi	s1,s1,504 # 80008958 <wait_lock>
    80001768:	8526                	mv	a0,s1
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	c1a080e7          	jalr	-998(ra) # 80006384 <acquire>
  reparent(p);
    80001772:	854e                	mv	a0,s3
    80001774:	00000097          	auipc	ra,0x0
    80001778:	f1a080e7          	jalr	-230(ra) # 8000168e <reparent>
  wakeup(p->parent);
    8000177c:	0389b503          	ld	a0,56(s3)
    80001780:	00000097          	auipc	ra,0x0
    80001784:	e98080e7          	jalr	-360(ra) # 80001618 <wakeup>
  acquire(&p->lock);
    80001788:	854e                	mv	a0,s3
    8000178a:	00005097          	auipc	ra,0x5
    8000178e:	bfa080e7          	jalr	-1030(ra) # 80006384 <acquire>
  p->xstate = status;
    80001792:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001796:	4795                	li	a5,5
    80001798:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000179c:	8526                	mv	a0,s1
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	c9a080e7          	jalr	-870(ra) # 80006438 <release>
  sched();
    800017a6:	00000097          	auipc	ra,0x0
    800017aa:	cfc080e7          	jalr	-772(ra) # 800014a2 <sched>
  panic("zombie exit");
    800017ae:	00007517          	auipc	a0,0x7
    800017b2:	a8250513          	addi	a0,a0,-1406 # 80008230 <etext+0x230>
    800017b6:	00004097          	auipc	ra,0x4
    800017ba:	67e080e7          	jalr	1662(ra) # 80005e34 <panic>

00000000800017be <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800017be:	7179                	addi	sp,sp,-48
    800017c0:	f406                	sd	ra,40(sp)
    800017c2:	f022                	sd	s0,32(sp)
    800017c4:	ec26                	sd	s1,24(sp)
    800017c6:	e84a                	sd	s2,16(sp)
    800017c8:	e44e                	sd	s3,8(sp)
    800017ca:	1800                	addi	s0,sp,48
    800017cc:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800017ce:	00007497          	auipc	s1,0x7
    800017d2:	5a248493          	addi	s1,s1,1442 # 80008d70 <proc>
    800017d6:	0000d997          	auipc	s3,0xd
    800017da:	f9a98993          	addi	s3,s3,-102 # 8000e770 <tickslock>
    acquire(&p->lock);
    800017de:	8526                	mv	a0,s1
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	ba4080e7          	jalr	-1116(ra) # 80006384 <acquire>
    if(p->pid == pid){
    800017e8:	589c                	lw	a5,48(s1)
    800017ea:	01278d63          	beq	a5,s2,80001804 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017ee:	8526                	mv	a0,s1
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	c48080e7          	jalr	-952(ra) # 80006438 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017f8:	16848493          	addi	s1,s1,360
    800017fc:	ff3491e3          	bne	s1,s3,800017de <kill+0x20>
  }
  return -1;
    80001800:	557d                	li	a0,-1
    80001802:	a829                	j	8000181c <kill+0x5e>
      p->killed = 1;
    80001804:	4785                	li	a5,1
    80001806:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001808:	4c98                	lw	a4,24(s1)
    8000180a:	4789                	li	a5,2
    8000180c:	00f70f63          	beq	a4,a5,8000182a <kill+0x6c>
      release(&p->lock);
    80001810:	8526                	mv	a0,s1
    80001812:	00005097          	auipc	ra,0x5
    80001816:	c26080e7          	jalr	-986(ra) # 80006438 <release>
      return 0;
    8000181a:	4501                	li	a0,0
}
    8000181c:	70a2                	ld	ra,40(sp)
    8000181e:	7402                	ld	s0,32(sp)
    80001820:	64e2                	ld	s1,24(sp)
    80001822:	6942                	ld	s2,16(sp)
    80001824:	69a2                	ld	s3,8(sp)
    80001826:	6145                	addi	sp,sp,48
    80001828:	8082                	ret
        p->state = RUNNABLE;
    8000182a:	478d                	li	a5,3
    8000182c:	cc9c                	sw	a5,24(s1)
    8000182e:	b7cd                	j	80001810 <kill+0x52>

0000000080001830 <setkilled>:

void
setkilled(struct proc *p)
{
    80001830:	1101                	addi	sp,sp,-32
    80001832:	ec06                	sd	ra,24(sp)
    80001834:	e822                	sd	s0,16(sp)
    80001836:	e426                	sd	s1,8(sp)
    80001838:	1000                	addi	s0,sp,32
    8000183a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000183c:	00005097          	auipc	ra,0x5
    80001840:	b48080e7          	jalr	-1208(ra) # 80006384 <acquire>
  p->killed = 1;
    80001844:	4785                	li	a5,1
    80001846:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001848:	8526                	mv	a0,s1
    8000184a:	00005097          	auipc	ra,0x5
    8000184e:	bee080e7          	jalr	-1042(ra) # 80006438 <release>
}
    80001852:	60e2                	ld	ra,24(sp)
    80001854:	6442                	ld	s0,16(sp)
    80001856:	64a2                	ld	s1,8(sp)
    80001858:	6105                	addi	sp,sp,32
    8000185a:	8082                	ret

000000008000185c <killed>:

int
killed(struct proc *p)
{
    8000185c:	1101                	addi	sp,sp,-32
    8000185e:	ec06                	sd	ra,24(sp)
    80001860:	e822                	sd	s0,16(sp)
    80001862:	e426                	sd	s1,8(sp)
    80001864:	e04a                	sd	s2,0(sp)
    80001866:	1000                	addi	s0,sp,32
    80001868:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	b1a080e7          	jalr	-1254(ra) # 80006384 <acquire>
  k = p->killed;
    80001872:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001876:	8526                	mv	a0,s1
    80001878:	00005097          	auipc	ra,0x5
    8000187c:	bc0080e7          	jalr	-1088(ra) # 80006438 <release>
  return k;
}
    80001880:	854a                	mv	a0,s2
    80001882:	60e2                	ld	ra,24(sp)
    80001884:	6442                	ld	s0,16(sp)
    80001886:	64a2                	ld	s1,8(sp)
    80001888:	6902                	ld	s2,0(sp)
    8000188a:	6105                	addi	sp,sp,32
    8000188c:	8082                	ret

000000008000188e <wait>:
{
    8000188e:	715d                	addi	sp,sp,-80
    80001890:	e486                	sd	ra,72(sp)
    80001892:	e0a2                	sd	s0,64(sp)
    80001894:	fc26                	sd	s1,56(sp)
    80001896:	f84a                	sd	s2,48(sp)
    80001898:	f44e                	sd	s3,40(sp)
    8000189a:	f052                	sd	s4,32(sp)
    8000189c:	ec56                	sd	s5,24(sp)
    8000189e:	e85a                	sd	s6,16(sp)
    800018a0:	e45e                	sd	s7,8(sp)
    800018a2:	e062                	sd	s8,0(sp)
    800018a4:	0880                	addi	s0,sp,80
    800018a6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800018a8:	fffff097          	auipc	ra,0xfffff
    800018ac:	65e080e7          	jalr	1630(ra) # 80000f06 <myproc>
    800018b0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800018b2:	00007517          	auipc	a0,0x7
    800018b6:	0a650513          	addi	a0,a0,166 # 80008958 <wait_lock>
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	aca080e7          	jalr	-1334(ra) # 80006384 <acquire>
    havekids = 0;
    800018c2:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800018c4:	4a15                	li	s4,5
        havekids = 1;
    800018c6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018c8:	0000d997          	auipc	s3,0xd
    800018cc:	ea898993          	addi	s3,s3,-344 # 8000e770 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018d0:	00007c17          	auipc	s8,0x7
    800018d4:	088c0c13          	addi	s8,s8,136 # 80008958 <wait_lock>
    800018d8:	a0d1                	j	8000199c <wait+0x10e>
          pid = pp->pid;
    800018da:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018de:	000b0e63          	beqz	s6,800018fa <wait+0x6c>
    800018e2:	4691                	li	a3,4
    800018e4:	02c48613          	addi	a2,s1,44
    800018e8:	85da                	mv	a1,s6
    800018ea:	05093503          	ld	a0,80(s2)
    800018ee:	fffff097          	auipc	ra,0xfffff
    800018f2:	25e080e7          	jalr	606(ra) # 80000b4c <copyout>
    800018f6:	04054163          	bltz	a0,80001938 <wait+0xaa>
          freeproc(pp);
    800018fa:	8526                	mv	a0,s1
    800018fc:	fffff097          	auipc	ra,0xfffff
    80001900:	7c0080e7          	jalr	1984(ra) # 800010bc <freeproc>
          release(&pp->lock);
    80001904:	8526                	mv	a0,s1
    80001906:	00005097          	auipc	ra,0x5
    8000190a:	b32080e7          	jalr	-1230(ra) # 80006438 <release>
          release(&wait_lock);
    8000190e:	00007517          	auipc	a0,0x7
    80001912:	04a50513          	addi	a0,a0,74 # 80008958 <wait_lock>
    80001916:	00005097          	auipc	ra,0x5
    8000191a:	b22080e7          	jalr	-1246(ra) # 80006438 <release>
}
    8000191e:	854e                	mv	a0,s3
    80001920:	60a6                	ld	ra,72(sp)
    80001922:	6406                	ld	s0,64(sp)
    80001924:	74e2                	ld	s1,56(sp)
    80001926:	7942                	ld	s2,48(sp)
    80001928:	79a2                	ld	s3,40(sp)
    8000192a:	7a02                	ld	s4,32(sp)
    8000192c:	6ae2                	ld	s5,24(sp)
    8000192e:	6b42                	ld	s6,16(sp)
    80001930:	6ba2                	ld	s7,8(sp)
    80001932:	6c02                	ld	s8,0(sp)
    80001934:	6161                	addi	sp,sp,80
    80001936:	8082                	ret
            release(&pp->lock);
    80001938:	8526                	mv	a0,s1
    8000193a:	00005097          	auipc	ra,0x5
    8000193e:	afe080e7          	jalr	-1282(ra) # 80006438 <release>
            release(&wait_lock);
    80001942:	00007517          	auipc	a0,0x7
    80001946:	01650513          	addi	a0,a0,22 # 80008958 <wait_lock>
    8000194a:	00005097          	auipc	ra,0x5
    8000194e:	aee080e7          	jalr	-1298(ra) # 80006438 <release>
            return -1;
    80001952:	59fd                	li	s3,-1
    80001954:	b7e9                	j	8000191e <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001956:	16848493          	addi	s1,s1,360
    8000195a:	03348463          	beq	s1,s3,80001982 <wait+0xf4>
      if(pp->parent == p){
    8000195e:	7c9c                	ld	a5,56(s1)
    80001960:	ff279be3          	bne	a5,s2,80001956 <wait+0xc8>
        acquire(&pp->lock);
    80001964:	8526                	mv	a0,s1
    80001966:	00005097          	auipc	ra,0x5
    8000196a:	a1e080e7          	jalr	-1506(ra) # 80006384 <acquire>
        if(pp->state == ZOMBIE){
    8000196e:	4c9c                	lw	a5,24(s1)
    80001970:	f74785e3          	beq	a5,s4,800018da <wait+0x4c>
        release(&pp->lock);
    80001974:	8526                	mv	a0,s1
    80001976:	00005097          	auipc	ra,0x5
    8000197a:	ac2080e7          	jalr	-1342(ra) # 80006438 <release>
        havekids = 1;
    8000197e:	8756                	mv	a4,s5
    80001980:	bfd9                	j	80001956 <wait+0xc8>
    if(!havekids || killed(p)){
    80001982:	c31d                	beqz	a4,800019a8 <wait+0x11a>
    80001984:	854a                	mv	a0,s2
    80001986:	00000097          	auipc	ra,0x0
    8000198a:	ed6080e7          	jalr	-298(ra) # 8000185c <killed>
    8000198e:	ed09                	bnez	a0,800019a8 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001990:	85e2                	mv	a1,s8
    80001992:	854a                	mv	a0,s2
    80001994:	00000097          	auipc	ra,0x0
    80001998:	c20080e7          	jalr	-992(ra) # 800015b4 <sleep>
    havekids = 0;
    8000199c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000199e:	00007497          	auipc	s1,0x7
    800019a2:	3d248493          	addi	s1,s1,978 # 80008d70 <proc>
    800019a6:	bf65                	j	8000195e <wait+0xd0>
      release(&wait_lock);
    800019a8:	00007517          	auipc	a0,0x7
    800019ac:	fb050513          	addi	a0,a0,-80 # 80008958 <wait_lock>
    800019b0:	00005097          	auipc	ra,0x5
    800019b4:	a88080e7          	jalr	-1400(ra) # 80006438 <release>
      return -1;
    800019b8:	59fd                	li	s3,-1
    800019ba:	b795                	j	8000191e <wait+0x90>

00000000800019bc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019bc:	7179                	addi	sp,sp,-48
    800019be:	f406                	sd	ra,40(sp)
    800019c0:	f022                	sd	s0,32(sp)
    800019c2:	ec26                	sd	s1,24(sp)
    800019c4:	e84a                	sd	s2,16(sp)
    800019c6:	e44e                	sd	s3,8(sp)
    800019c8:	e052                	sd	s4,0(sp)
    800019ca:	1800                	addi	s0,sp,48
    800019cc:	84aa                	mv	s1,a0
    800019ce:	892e                	mv	s2,a1
    800019d0:	89b2                	mv	s3,a2
    800019d2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	532080e7          	jalr	1330(ra) # 80000f06 <myproc>
  if(user_dst){
    800019dc:	c08d                	beqz	s1,800019fe <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019de:	86d2                	mv	a3,s4
    800019e0:	864e                	mv	a2,s3
    800019e2:	85ca                	mv	a1,s2
    800019e4:	6928                	ld	a0,80(a0)
    800019e6:	fffff097          	auipc	ra,0xfffff
    800019ea:	166080e7          	jalr	358(ra) # 80000b4c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019ee:	70a2                	ld	ra,40(sp)
    800019f0:	7402                	ld	s0,32(sp)
    800019f2:	64e2                	ld	s1,24(sp)
    800019f4:	6942                	ld	s2,16(sp)
    800019f6:	69a2                	ld	s3,8(sp)
    800019f8:	6a02                	ld	s4,0(sp)
    800019fa:	6145                	addi	sp,sp,48
    800019fc:	8082                	ret
    memmove((char *)dst, src, len);
    800019fe:	000a061b          	sext.w	a2,s4
    80001a02:	85ce                	mv	a1,s3
    80001a04:	854a                	mv	a0,s2
    80001a06:	ffffe097          	auipc	ra,0xffffe
    80001a0a:	7d0080e7          	jalr	2000(ra) # 800001d6 <memmove>
    return 0;
    80001a0e:	8526                	mv	a0,s1
    80001a10:	bff9                	j	800019ee <either_copyout+0x32>

0000000080001a12 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a12:	7179                	addi	sp,sp,-48
    80001a14:	f406                	sd	ra,40(sp)
    80001a16:	f022                	sd	s0,32(sp)
    80001a18:	ec26                	sd	s1,24(sp)
    80001a1a:	e84a                	sd	s2,16(sp)
    80001a1c:	e44e                	sd	s3,8(sp)
    80001a1e:	e052                	sd	s4,0(sp)
    80001a20:	1800                	addi	s0,sp,48
    80001a22:	892a                	mv	s2,a0
    80001a24:	84ae                	mv	s1,a1
    80001a26:	89b2                	mv	s3,a2
    80001a28:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a2a:	fffff097          	auipc	ra,0xfffff
    80001a2e:	4dc080e7          	jalr	1244(ra) # 80000f06 <myproc>
  if(user_src){
    80001a32:	c08d                	beqz	s1,80001a54 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a34:	86d2                	mv	a3,s4
    80001a36:	864e                	mv	a2,s3
    80001a38:	85ca                	mv	a1,s2
    80001a3a:	6928                	ld	a0,80(a0)
    80001a3c:	fffff097          	auipc	ra,0xfffff
    80001a40:	1ee080e7          	jalr	494(ra) # 80000c2a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a44:	70a2                	ld	ra,40(sp)
    80001a46:	7402                	ld	s0,32(sp)
    80001a48:	64e2                	ld	s1,24(sp)
    80001a4a:	6942                	ld	s2,16(sp)
    80001a4c:	69a2                	ld	s3,8(sp)
    80001a4e:	6a02                	ld	s4,0(sp)
    80001a50:	6145                	addi	sp,sp,48
    80001a52:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a54:	000a061b          	sext.w	a2,s4
    80001a58:	85ce                	mv	a1,s3
    80001a5a:	854a                	mv	a0,s2
    80001a5c:	ffffe097          	auipc	ra,0xffffe
    80001a60:	77a080e7          	jalr	1914(ra) # 800001d6 <memmove>
    return 0;
    80001a64:	8526                	mv	a0,s1
    80001a66:	bff9                	j	80001a44 <either_copyin+0x32>

0000000080001a68 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a68:	715d                	addi	sp,sp,-80
    80001a6a:	e486                	sd	ra,72(sp)
    80001a6c:	e0a2                	sd	s0,64(sp)
    80001a6e:	fc26                	sd	s1,56(sp)
    80001a70:	f84a                	sd	s2,48(sp)
    80001a72:	f44e                	sd	s3,40(sp)
    80001a74:	f052                	sd	s4,32(sp)
    80001a76:	ec56                	sd	s5,24(sp)
    80001a78:	e85a                	sd	s6,16(sp)
    80001a7a:	e45e                	sd	s7,8(sp)
    80001a7c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a7e:	00006517          	auipc	a0,0x6
    80001a82:	59a50513          	addi	a0,a0,1434 # 80008018 <etext+0x18>
    80001a86:	00004097          	auipc	ra,0x4
    80001a8a:	400080e7          	jalr	1024(ra) # 80005e86 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a8e:	00007497          	auipc	s1,0x7
    80001a92:	43a48493          	addi	s1,s1,1082 # 80008ec8 <proc+0x158>
    80001a96:	0000d917          	auipc	s2,0xd
    80001a9a:	e3290913          	addi	s2,s2,-462 # 8000e8c8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a9e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001aa0:	00006997          	auipc	s3,0x6
    80001aa4:	7a098993          	addi	s3,s3,1952 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001aa8:	00006a97          	auipc	s5,0x6
    80001aac:	7a0a8a93          	addi	s5,s5,1952 # 80008248 <etext+0x248>
    printf("\n");
    80001ab0:	00006a17          	auipc	s4,0x6
    80001ab4:	568a0a13          	addi	s4,s4,1384 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ab8:	00007b97          	auipc	s7,0x7
    80001abc:	cd0b8b93          	addi	s7,s7,-816 # 80008788 <states.0>
    80001ac0:	a00d                	j	80001ae2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ac2:	ed86a583          	lw	a1,-296(a3)
    80001ac6:	8556                	mv	a0,s5
    80001ac8:	00004097          	auipc	ra,0x4
    80001acc:	3be080e7          	jalr	958(ra) # 80005e86 <printf>
    printf("\n");
    80001ad0:	8552                	mv	a0,s4
    80001ad2:	00004097          	auipc	ra,0x4
    80001ad6:	3b4080e7          	jalr	948(ra) # 80005e86 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ada:	16848493          	addi	s1,s1,360
    80001ade:	03248263          	beq	s1,s2,80001b02 <procdump+0x9a>
    if(p->state == UNUSED)
    80001ae2:	86a6                	mv	a3,s1
    80001ae4:	ec04a783          	lw	a5,-320(s1)
    80001ae8:	dbed                	beqz	a5,80001ada <procdump+0x72>
      state = "???";
    80001aea:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aec:	fcfb6be3          	bltu	s6,a5,80001ac2 <procdump+0x5a>
    80001af0:	02079713          	slli	a4,a5,0x20
    80001af4:	01d75793          	srli	a5,a4,0x1d
    80001af8:	97de                	add	a5,a5,s7
    80001afa:	6390                	ld	a2,0(a5)
    80001afc:	f279                	bnez	a2,80001ac2 <procdump+0x5a>
      state = "???";
    80001afe:	864e                	mv	a2,s3
    80001b00:	b7c9                	j	80001ac2 <procdump+0x5a>
  }
}
    80001b02:	60a6                	ld	ra,72(sp)
    80001b04:	6406                	ld	s0,64(sp)
    80001b06:	74e2                	ld	s1,56(sp)
    80001b08:	7942                	ld	s2,48(sp)
    80001b0a:	79a2                	ld	s3,40(sp)
    80001b0c:	7a02                	ld	s4,32(sp)
    80001b0e:	6ae2                	ld	s5,24(sp)
    80001b10:	6b42                	ld	s6,16(sp)
    80001b12:	6ba2                	ld	s7,8(sp)
    80001b14:	6161                	addi	sp,sp,80
    80001b16:	8082                	ret

0000000080001b18 <swtch>:
    80001b18:	00153023          	sd	ra,0(a0)
    80001b1c:	00253423          	sd	sp,8(a0)
    80001b20:	e900                	sd	s0,16(a0)
    80001b22:	ed04                	sd	s1,24(a0)
    80001b24:	03253023          	sd	s2,32(a0)
    80001b28:	03353423          	sd	s3,40(a0)
    80001b2c:	03453823          	sd	s4,48(a0)
    80001b30:	03553c23          	sd	s5,56(a0)
    80001b34:	05653023          	sd	s6,64(a0)
    80001b38:	05753423          	sd	s7,72(a0)
    80001b3c:	05853823          	sd	s8,80(a0)
    80001b40:	05953c23          	sd	s9,88(a0)
    80001b44:	07a53023          	sd	s10,96(a0)
    80001b48:	07b53423          	sd	s11,104(a0)
    80001b4c:	0005b083          	ld	ra,0(a1)
    80001b50:	0085b103          	ld	sp,8(a1)
    80001b54:	6980                	ld	s0,16(a1)
    80001b56:	6d84                	ld	s1,24(a1)
    80001b58:	0205b903          	ld	s2,32(a1)
    80001b5c:	0285b983          	ld	s3,40(a1)
    80001b60:	0305ba03          	ld	s4,48(a1)
    80001b64:	0385ba83          	ld	s5,56(a1)
    80001b68:	0405bb03          	ld	s6,64(a1)
    80001b6c:	0485bb83          	ld	s7,72(a1)
    80001b70:	0505bc03          	ld	s8,80(a1)
    80001b74:	0585bc83          	ld	s9,88(a1)
    80001b78:	0605bd03          	ld	s10,96(a1)
    80001b7c:	0685bd83          	ld	s11,104(a1)
    80001b80:	8082                	ret

0000000080001b82 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b82:	1141                	addi	sp,sp,-16
    80001b84:	e406                	sd	ra,8(sp)
    80001b86:	e022                	sd	s0,0(sp)
    80001b88:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b8a:	00006597          	auipc	a1,0x6
    80001b8e:	6fe58593          	addi	a1,a1,1790 # 80008288 <etext+0x288>
    80001b92:	0000d517          	auipc	a0,0xd
    80001b96:	bde50513          	addi	a0,a0,-1058 # 8000e770 <tickslock>
    80001b9a:	00004097          	auipc	ra,0x4
    80001b9e:	75a080e7          	jalr	1882(ra) # 800062f4 <initlock>
}
    80001ba2:	60a2                	ld	ra,8(sp)
    80001ba4:	6402                	ld	s0,0(sp)
    80001ba6:	0141                	addi	sp,sp,16
    80001ba8:	8082                	ret

0000000080001baa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001baa:	1141                	addi	sp,sp,-16
    80001bac:	e422                	sd	s0,8(sp)
    80001bae:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bb0:	00003797          	auipc	a5,0x3
    80001bb4:	5b078793          	addi	a5,a5,1456 # 80005160 <kernelvec>
    80001bb8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bbc:	6422                	ld	s0,8(sp)
    80001bbe:	0141                	addi	sp,sp,16
    80001bc0:	8082                	ret

0000000080001bc2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bc2:	1141                	addi	sp,sp,-16
    80001bc4:	e406                	sd	ra,8(sp)
    80001bc6:	e022                	sd	s0,0(sp)
    80001bc8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bca:	fffff097          	auipc	ra,0xfffff
    80001bce:	33c080e7          	jalr	828(ra) # 80000f06 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bd2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bd6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bd8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001bdc:	00005697          	auipc	a3,0x5
    80001be0:	42468693          	addi	a3,a3,1060 # 80007000 <_trampoline>
    80001be4:	00005717          	auipc	a4,0x5
    80001be8:	41c70713          	addi	a4,a4,1052 # 80007000 <_trampoline>
    80001bec:	8f15                	sub	a4,a4,a3
    80001bee:	040007b7          	lui	a5,0x4000
    80001bf2:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bf4:	07b2                	slli	a5,a5,0xc
    80001bf6:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bf8:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bfc:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bfe:	18002673          	csrr	a2,satp
    80001c02:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c04:	6d30                	ld	a2,88(a0)
    80001c06:	6138                	ld	a4,64(a0)
    80001c08:	6585                	lui	a1,0x1
    80001c0a:	972e                	add	a4,a4,a1
    80001c0c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c0e:	6d38                	ld	a4,88(a0)
    80001c10:	00000617          	auipc	a2,0x0
    80001c14:	13860613          	addi	a2,a2,312 # 80001d48 <usertrap>
    80001c18:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c1a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c1c:	8612                	mv	a2,tp
    80001c1e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c20:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c24:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c28:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c2c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c30:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c32:	6f18                	ld	a4,24(a4)
    80001c34:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c38:	6928                	ld	a0,80(a0)
    80001c3a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c3c:	00005717          	auipc	a4,0x5
    80001c40:	46070713          	addi	a4,a4,1120 # 8000709c <userret>
    80001c44:	8f15                	sub	a4,a4,a3
    80001c46:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c48:	577d                	li	a4,-1
    80001c4a:	177e                	slli	a4,a4,0x3f
    80001c4c:	8d59                	or	a0,a0,a4
    80001c4e:	9782                	jalr	a5
}
    80001c50:	60a2                	ld	ra,8(sp)
    80001c52:	6402                	ld	s0,0(sp)
    80001c54:	0141                	addi	sp,sp,16
    80001c56:	8082                	ret

0000000080001c58 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c58:	1101                	addi	sp,sp,-32
    80001c5a:	ec06                	sd	ra,24(sp)
    80001c5c:	e822                	sd	s0,16(sp)
    80001c5e:	e426                	sd	s1,8(sp)
    80001c60:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c62:	0000d497          	auipc	s1,0xd
    80001c66:	b0e48493          	addi	s1,s1,-1266 # 8000e770 <tickslock>
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	00004097          	auipc	ra,0x4
    80001c70:	718080e7          	jalr	1816(ra) # 80006384 <acquire>
  ticks++;
    80001c74:	00007517          	auipc	a0,0x7
    80001c78:	c9450513          	addi	a0,a0,-876 # 80008908 <ticks>
    80001c7c:	411c                	lw	a5,0(a0)
    80001c7e:	2785                	addiw	a5,a5,1
    80001c80:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c82:	00000097          	auipc	ra,0x0
    80001c86:	996080e7          	jalr	-1642(ra) # 80001618 <wakeup>
  release(&tickslock);
    80001c8a:	8526                	mv	a0,s1
    80001c8c:	00004097          	auipc	ra,0x4
    80001c90:	7ac080e7          	jalr	1964(ra) # 80006438 <release>
}
    80001c94:	60e2                	ld	ra,24(sp)
    80001c96:	6442                	ld	s0,16(sp)
    80001c98:	64a2                	ld	s1,8(sp)
    80001c9a:	6105                	addi	sp,sp,32
    80001c9c:	8082                	ret

0000000080001c9e <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c9e:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ca2:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001ca4:	0a07d163          	bgez	a5,80001d46 <devintr+0xa8>
{
    80001ca8:	1101                	addi	sp,sp,-32
    80001caa:	ec06                	sd	ra,24(sp)
    80001cac:	e822                	sd	s0,16(sp)
    80001cae:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001cb0:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001cb4:	46a5                	li	a3,9
    80001cb6:	00d70c63          	beq	a4,a3,80001cce <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001cba:	577d                	li	a4,-1
    80001cbc:	177e                	slli	a4,a4,0x3f
    80001cbe:	0705                	addi	a4,a4,1
    return 0;
    80001cc0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cc2:	06e78163          	beq	a5,a4,80001d24 <devintr+0x86>
  }
}
    80001cc6:	60e2                	ld	ra,24(sp)
    80001cc8:	6442                	ld	s0,16(sp)
    80001cca:	6105                	addi	sp,sp,32
    80001ccc:	8082                	ret
    80001cce:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001cd0:	00003097          	auipc	ra,0x3
    80001cd4:	59c080e7          	jalr	1436(ra) # 8000526c <plic_claim>
    80001cd8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cda:	47a9                	li	a5,10
    80001cdc:	00f50963          	beq	a0,a5,80001cee <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001ce0:	4785                	li	a5,1
    80001ce2:	00f50b63          	beq	a0,a5,80001cf8 <devintr+0x5a>
    return 1;
    80001ce6:	4505                	li	a0,1
    } else if(irq){
    80001ce8:	ec89                	bnez	s1,80001d02 <devintr+0x64>
    80001cea:	64a2                	ld	s1,8(sp)
    80001cec:	bfe9                	j	80001cc6 <devintr+0x28>
      uartintr();
    80001cee:	00004097          	auipc	ra,0x4
    80001cf2:	5b6080e7          	jalr	1462(ra) # 800062a4 <uartintr>
    if(irq)
    80001cf6:	a839                	j	80001d14 <devintr+0x76>
      virtio_disk_intr();
    80001cf8:	00004097          	auipc	ra,0x4
    80001cfc:	a9e080e7          	jalr	-1378(ra) # 80005796 <virtio_disk_intr>
    if(irq)
    80001d00:	a811                	j	80001d14 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d02:	85a6                	mv	a1,s1
    80001d04:	00006517          	auipc	a0,0x6
    80001d08:	58c50513          	addi	a0,a0,1420 # 80008290 <etext+0x290>
    80001d0c:	00004097          	auipc	ra,0x4
    80001d10:	17a080e7          	jalr	378(ra) # 80005e86 <printf>
      plic_complete(irq);
    80001d14:	8526                	mv	a0,s1
    80001d16:	00003097          	auipc	ra,0x3
    80001d1a:	57a080e7          	jalr	1402(ra) # 80005290 <plic_complete>
    return 1;
    80001d1e:	4505                	li	a0,1
    80001d20:	64a2                	ld	s1,8(sp)
    80001d22:	b755                	j	80001cc6 <devintr+0x28>
    if(cpuid() == 0){
    80001d24:	fffff097          	auipc	ra,0xfffff
    80001d28:	1b6080e7          	jalr	438(ra) # 80000eda <cpuid>
    80001d2c:	c901                	beqz	a0,80001d3c <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d2e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d32:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d34:	14479073          	csrw	sip,a5
    return 2;
    80001d38:	4509                	li	a0,2
    80001d3a:	b771                	j	80001cc6 <devintr+0x28>
      clockintr();
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	f1c080e7          	jalr	-228(ra) # 80001c58 <clockintr>
    80001d44:	b7ed                	j	80001d2e <devintr+0x90>
}
    80001d46:	8082                	ret

0000000080001d48 <usertrap>:
{
    80001d48:	1101                	addi	sp,sp,-32
    80001d4a:	ec06                	sd	ra,24(sp)
    80001d4c:	e822                	sd	s0,16(sp)
    80001d4e:	e426                	sd	s1,8(sp)
    80001d50:	e04a                	sd	s2,0(sp)
    80001d52:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d54:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d58:	1007f793          	andi	a5,a5,256
    80001d5c:	e3b1                	bnez	a5,80001da0 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d5e:	00003797          	auipc	a5,0x3
    80001d62:	40278793          	addi	a5,a5,1026 # 80005160 <kernelvec>
    80001d66:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d6a:	fffff097          	auipc	ra,0xfffff
    80001d6e:	19c080e7          	jalr	412(ra) # 80000f06 <myproc>
    80001d72:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d74:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d76:	14102773          	csrr	a4,sepc
    80001d7a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d7c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d80:	47a1                	li	a5,8
    80001d82:	02f70763          	beq	a4,a5,80001db0 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d86:	00000097          	auipc	ra,0x0
    80001d8a:	f18080e7          	jalr	-232(ra) # 80001c9e <devintr>
    80001d8e:	892a                	mv	s2,a0
    80001d90:	c151                	beqz	a0,80001e14 <usertrap+0xcc>
  if(killed(p))
    80001d92:	8526                	mv	a0,s1
    80001d94:	00000097          	auipc	ra,0x0
    80001d98:	ac8080e7          	jalr	-1336(ra) # 8000185c <killed>
    80001d9c:	c929                	beqz	a0,80001dee <usertrap+0xa6>
    80001d9e:	a099                	j	80001de4 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001da0:	00006517          	auipc	a0,0x6
    80001da4:	51050513          	addi	a0,a0,1296 # 800082b0 <etext+0x2b0>
    80001da8:	00004097          	auipc	ra,0x4
    80001dac:	08c080e7          	jalr	140(ra) # 80005e34 <panic>
    if(killed(p))
    80001db0:	00000097          	auipc	ra,0x0
    80001db4:	aac080e7          	jalr	-1364(ra) # 8000185c <killed>
    80001db8:	e921                	bnez	a0,80001e08 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001dba:	6cb8                	ld	a4,88(s1)
    80001dbc:	6f1c                	ld	a5,24(a4)
    80001dbe:	0791                	addi	a5,a5,4
    80001dc0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dc6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dca:	10079073          	csrw	sstatus,a5
    syscall();
    80001dce:	00000097          	auipc	ra,0x0
    80001dd2:	2d4080e7          	jalr	724(ra) # 800020a2 <syscall>
  if(killed(p))
    80001dd6:	8526                	mv	a0,s1
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	a84080e7          	jalr	-1404(ra) # 8000185c <killed>
    80001de0:	c911                	beqz	a0,80001df4 <usertrap+0xac>
    80001de2:	4901                	li	s2,0
    exit(-1);
    80001de4:	557d                	li	a0,-1
    80001de6:	00000097          	auipc	ra,0x0
    80001dea:	902080e7          	jalr	-1790(ra) # 800016e8 <exit>
  if(which_dev == 2)
    80001dee:	4789                	li	a5,2
    80001df0:	04f90f63          	beq	s2,a5,80001e4e <usertrap+0x106>
  usertrapret();
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	dce080e7          	jalr	-562(ra) # 80001bc2 <usertrapret>
}
    80001dfc:	60e2                	ld	ra,24(sp)
    80001dfe:	6442                	ld	s0,16(sp)
    80001e00:	64a2                	ld	s1,8(sp)
    80001e02:	6902                	ld	s2,0(sp)
    80001e04:	6105                	addi	sp,sp,32
    80001e06:	8082                	ret
      exit(-1);
    80001e08:	557d                	li	a0,-1
    80001e0a:	00000097          	auipc	ra,0x0
    80001e0e:	8de080e7          	jalr	-1826(ra) # 800016e8 <exit>
    80001e12:	b765                	j	80001dba <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e14:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e18:	5890                	lw	a2,48(s1)
    80001e1a:	00006517          	auipc	a0,0x6
    80001e1e:	4b650513          	addi	a0,a0,1206 # 800082d0 <etext+0x2d0>
    80001e22:	00004097          	auipc	ra,0x4
    80001e26:	064080e7          	jalr	100(ra) # 80005e86 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e2e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e32:	00006517          	auipc	a0,0x6
    80001e36:	4ce50513          	addi	a0,a0,1230 # 80008300 <etext+0x300>
    80001e3a:	00004097          	auipc	ra,0x4
    80001e3e:	04c080e7          	jalr	76(ra) # 80005e86 <printf>
    setkilled(p);
    80001e42:	8526                	mv	a0,s1
    80001e44:	00000097          	auipc	ra,0x0
    80001e48:	9ec080e7          	jalr	-1556(ra) # 80001830 <setkilled>
    80001e4c:	b769                	j	80001dd6 <usertrap+0x8e>
    yield();
    80001e4e:	fffff097          	auipc	ra,0xfffff
    80001e52:	72a080e7          	jalr	1834(ra) # 80001578 <yield>
    80001e56:	bf79                	j	80001df4 <usertrap+0xac>

0000000080001e58 <kerneltrap>:
{
    80001e58:	7179                	addi	sp,sp,-48
    80001e5a:	f406                	sd	ra,40(sp)
    80001e5c:	f022                	sd	s0,32(sp)
    80001e5e:	ec26                	sd	s1,24(sp)
    80001e60:	e84a                	sd	s2,16(sp)
    80001e62:	e44e                	sd	s3,8(sp)
    80001e64:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e66:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e6a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e6e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e72:	1004f793          	andi	a5,s1,256
    80001e76:	cb85                	beqz	a5,80001ea6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e78:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e7c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e7e:	ef85                	bnez	a5,80001eb6 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e80:	00000097          	auipc	ra,0x0
    80001e84:	e1e080e7          	jalr	-482(ra) # 80001c9e <devintr>
    80001e88:	cd1d                	beqz	a0,80001ec6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e8a:	4789                	li	a5,2
    80001e8c:	06f50a63          	beq	a0,a5,80001f00 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e90:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e94:	10049073          	csrw	sstatus,s1
}
    80001e98:	70a2                	ld	ra,40(sp)
    80001e9a:	7402                	ld	s0,32(sp)
    80001e9c:	64e2                	ld	s1,24(sp)
    80001e9e:	6942                	ld	s2,16(sp)
    80001ea0:	69a2                	ld	s3,8(sp)
    80001ea2:	6145                	addi	sp,sp,48
    80001ea4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ea6:	00006517          	auipc	a0,0x6
    80001eaa:	47a50513          	addi	a0,a0,1146 # 80008320 <etext+0x320>
    80001eae:	00004097          	auipc	ra,0x4
    80001eb2:	f86080e7          	jalr	-122(ra) # 80005e34 <panic>
    panic("kerneltrap: interrupts enabled");
    80001eb6:	00006517          	auipc	a0,0x6
    80001eba:	49250513          	addi	a0,a0,1170 # 80008348 <etext+0x348>
    80001ebe:	00004097          	auipc	ra,0x4
    80001ec2:	f76080e7          	jalr	-138(ra) # 80005e34 <panic>
    printf("scause %p\n", scause);
    80001ec6:	85ce                	mv	a1,s3
    80001ec8:	00006517          	auipc	a0,0x6
    80001ecc:	4a050513          	addi	a0,a0,1184 # 80008368 <etext+0x368>
    80001ed0:	00004097          	auipc	ra,0x4
    80001ed4:	fb6080e7          	jalr	-74(ra) # 80005e86 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ed8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001edc:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ee0:	00006517          	auipc	a0,0x6
    80001ee4:	49850513          	addi	a0,a0,1176 # 80008378 <etext+0x378>
    80001ee8:	00004097          	auipc	ra,0x4
    80001eec:	f9e080e7          	jalr	-98(ra) # 80005e86 <printf>
    panic("kerneltrap");
    80001ef0:	00006517          	auipc	a0,0x6
    80001ef4:	4a050513          	addi	a0,a0,1184 # 80008390 <etext+0x390>
    80001ef8:	00004097          	auipc	ra,0x4
    80001efc:	f3c080e7          	jalr	-196(ra) # 80005e34 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	006080e7          	jalr	6(ra) # 80000f06 <myproc>
    80001f08:	d541                	beqz	a0,80001e90 <kerneltrap+0x38>
    80001f0a:	fffff097          	auipc	ra,0xfffff
    80001f0e:	ffc080e7          	jalr	-4(ra) # 80000f06 <myproc>
    80001f12:	4d18                	lw	a4,24(a0)
    80001f14:	4791                	li	a5,4
    80001f16:	f6f71de3          	bne	a4,a5,80001e90 <kerneltrap+0x38>
    yield();
    80001f1a:	fffff097          	auipc	ra,0xfffff
    80001f1e:	65e080e7          	jalr	1630(ra) # 80001578 <yield>
    80001f22:	b7bd                	j	80001e90 <kerneltrap+0x38>

0000000080001f24 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f24:	1101                	addi	sp,sp,-32
    80001f26:	ec06                	sd	ra,24(sp)
    80001f28:	e822                	sd	s0,16(sp)
    80001f2a:	e426                	sd	s1,8(sp)
    80001f2c:	1000                	addi	s0,sp,32
    80001f2e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	fd6080e7          	jalr	-42(ra) # 80000f06 <myproc>
  switch (n) {
    80001f38:	4795                	li	a5,5
    80001f3a:	0497e163          	bltu	a5,s1,80001f7c <argraw+0x58>
    80001f3e:	048a                	slli	s1,s1,0x2
    80001f40:	00007717          	auipc	a4,0x7
    80001f44:	87870713          	addi	a4,a4,-1928 # 800087b8 <states.0+0x30>
    80001f48:	94ba                	add	s1,s1,a4
    80001f4a:	409c                	lw	a5,0(s1)
    80001f4c:	97ba                	add	a5,a5,a4
    80001f4e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f50:	6d3c                	ld	a5,88(a0)
    80001f52:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f54:	60e2                	ld	ra,24(sp)
    80001f56:	6442                	ld	s0,16(sp)
    80001f58:	64a2                	ld	s1,8(sp)
    80001f5a:	6105                	addi	sp,sp,32
    80001f5c:	8082                	ret
    return p->trapframe->a1;
    80001f5e:	6d3c                	ld	a5,88(a0)
    80001f60:	7fa8                	ld	a0,120(a5)
    80001f62:	bfcd                	j	80001f54 <argraw+0x30>
    return p->trapframe->a2;
    80001f64:	6d3c                	ld	a5,88(a0)
    80001f66:	63c8                	ld	a0,128(a5)
    80001f68:	b7f5                	j	80001f54 <argraw+0x30>
    return p->trapframe->a3;
    80001f6a:	6d3c                	ld	a5,88(a0)
    80001f6c:	67c8                	ld	a0,136(a5)
    80001f6e:	b7dd                	j	80001f54 <argraw+0x30>
    return p->trapframe->a4;
    80001f70:	6d3c                	ld	a5,88(a0)
    80001f72:	6bc8                	ld	a0,144(a5)
    80001f74:	b7c5                	j	80001f54 <argraw+0x30>
    return p->trapframe->a5;
    80001f76:	6d3c                	ld	a5,88(a0)
    80001f78:	6fc8                	ld	a0,152(a5)
    80001f7a:	bfe9                	j	80001f54 <argraw+0x30>
  panic("argraw");
    80001f7c:	00006517          	auipc	a0,0x6
    80001f80:	42450513          	addi	a0,a0,1060 # 800083a0 <etext+0x3a0>
    80001f84:	00004097          	auipc	ra,0x4
    80001f88:	eb0080e7          	jalr	-336(ra) # 80005e34 <panic>

0000000080001f8c <fetchaddr>:
{
    80001f8c:	1101                	addi	sp,sp,-32
    80001f8e:	ec06                	sd	ra,24(sp)
    80001f90:	e822                	sd	s0,16(sp)
    80001f92:	e426                	sd	s1,8(sp)
    80001f94:	e04a                	sd	s2,0(sp)
    80001f96:	1000                	addi	s0,sp,32
    80001f98:	84aa                	mv	s1,a0
    80001f9a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f9c:	fffff097          	auipc	ra,0xfffff
    80001fa0:	f6a080e7          	jalr	-150(ra) # 80000f06 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001fa4:	653c                	ld	a5,72(a0)
    80001fa6:	02f4f863          	bgeu	s1,a5,80001fd6 <fetchaddr+0x4a>
    80001faa:	00848713          	addi	a4,s1,8
    80001fae:	02e7e663          	bltu	a5,a4,80001fda <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fb2:	46a1                	li	a3,8
    80001fb4:	8626                	mv	a2,s1
    80001fb6:	85ca                	mv	a1,s2
    80001fb8:	6928                	ld	a0,80(a0)
    80001fba:	fffff097          	auipc	ra,0xfffff
    80001fbe:	c70080e7          	jalr	-912(ra) # 80000c2a <copyin>
    80001fc2:	00a03533          	snez	a0,a0
    80001fc6:	40a00533          	neg	a0,a0
}
    80001fca:	60e2                	ld	ra,24(sp)
    80001fcc:	6442                	ld	s0,16(sp)
    80001fce:	64a2                	ld	s1,8(sp)
    80001fd0:	6902                	ld	s2,0(sp)
    80001fd2:	6105                	addi	sp,sp,32
    80001fd4:	8082                	ret
    return -1;
    80001fd6:	557d                	li	a0,-1
    80001fd8:	bfcd                	j	80001fca <fetchaddr+0x3e>
    80001fda:	557d                	li	a0,-1
    80001fdc:	b7fd                	j	80001fca <fetchaddr+0x3e>

0000000080001fde <fetchstr>:
{
    80001fde:	7179                	addi	sp,sp,-48
    80001fe0:	f406                	sd	ra,40(sp)
    80001fe2:	f022                	sd	s0,32(sp)
    80001fe4:	ec26                	sd	s1,24(sp)
    80001fe6:	e84a                	sd	s2,16(sp)
    80001fe8:	e44e                	sd	s3,8(sp)
    80001fea:	1800                	addi	s0,sp,48
    80001fec:	892a                	mv	s2,a0
    80001fee:	84ae                	mv	s1,a1
    80001ff0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ff2:	fffff097          	auipc	ra,0xfffff
    80001ff6:	f14080e7          	jalr	-236(ra) # 80000f06 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001ffa:	86ce                	mv	a3,s3
    80001ffc:	864a                	mv	a2,s2
    80001ffe:	85a6                	mv	a1,s1
    80002000:	6928                	ld	a0,80(a0)
    80002002:	fffff097          	auipc	ra,0xfffff
    80002006:	cb6080e7          	jalr	-842(ra) # 80000cb8 <copyinstr>
    8000200a:	00054e63          	bltz	a0,80002026 <fetchstr+0x48>
  return strlen(buf);
    8000200e:	8526                	mv	a0,s1
    80002010:	ffffe097          	auipc	ra,0xffffe
    80002014:	2de080e7          	jalr	734(ra) # 800002ee <strlen>
}
    80002018:	70a2                	ld	ra,40(sp)
    8000201a:	7402                	ld	s0,32(sp)
    8000201c:	64e2                	ld	s1,24(sp)
    8000201e:	6942                	ld	s2,16(sp)
    80002020:	69a2                	ld	s3,8(sp)
    80002022:	6145                	addi	sp,sp,48
    80002024:	8082                	ret
    return -1;
    80002026:	557d                	li	a0,-1
    80002028:	bfc5                	j	80002018 <fetchstr+0x3a>

000000008000202a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000202a:	1101                	addi	sp,sp,-32
    8000202c:	ec06                	sd	ra,24(sp)
    8000202e:	e822                	sd	s0,16(sp)
    80002030:	e426                	sd	s1,8(sp)
    80002032:	1000                	addi	s0,sp,32
    80002034:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002036:	00000097          	auipc	ra,0x0
    8000203a:	eee080e7          	jalr	-274(ra) # 80001f24 <argraw>
    8000203e:	c088                	sw	a0,0(s1)
}
    80002040:	60e2                	ld	ra,24(sp)
    80002042:	6442                	ld	s0,16(sp)
    80002044:	64a2                	ld	s1,8(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret

000000008000204a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000204a:	1101                	addi	sp,sp,-32
    8000204c:	ec06                	sd	ra,24(sp)
    8000204e:	e822                	sd	s0,16(sp)
    80002050:	e426                	sd	s1,8(sp)
    80002052:	1000                	addi	s0,sp,32
    80002054:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	ece080e7          	jalr	-306(ra) # 80001f24 <argraw>
    8000205e:	e088                	sd	a0,0(s1)
}
    80002060:	60e2                	ld	ra,24(sp)
    80002062:	6442                	ld	s0,16(sp)
    80002064:	64a2                	ld	s1,8(sp)
    80002066:	6105                	addi	sp,sp,32
    80002068:	8082                	ret

000000008000206a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000206a:	7179                	addi	sp,sp,-48
    8000206c:	f406                	sd	ra,40(sp)
    8000206e:	f022                	sd	s0,32(sp)
    80002070:	ec26                	sd	s1,24(sp)
    80002072:	e84a                	sd	s2,16(sp)
    80002074:	1800                	addi	s0,sp,48
    80002076:	84ae                	mv	s1,a1
    80002078:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000207a:	fd840593          	addi	a1,s0,-40
    8000207e:	00000097          	auipc	ra,0x0
    80002082:	fcc080e7          	jalr	-52(ra) # 8000204a <argaddr>
  return fetchstr(addr, buf, max);
    80002086:	864a                	mv	a2,s2
    80002088:	85a6                	mv	a1,s1
    8000208a:	fd843503          	ld	a0,-40(s0)
    8000208e:	00000097          	auipc	ra,0x0
    80002092:	f50080e7          	jalr	-176(ra) # 80001fde <fetchstr>
}
    80002096:	70a2                	ld	ra,40(sp)
    80002098:	7402                	ld	s0,32(sp)
    8000209a:	64e2                	ld	s1,24(sp)
    8000209c:	6942                	ld	s2,16(sp)
    8000209e:	6145                	addi	sp,sp,48
    800020a0:	8082                	ret

00000000800020a2 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800020a2:	1101                	addi	sp,sp,-32
    800020a4:	ec06                	sd	ra,24(sp)
    800020a6:	e822                	sd	s0,16(sp)
    800020a8:	e426                	sd	s1,8(sp)
    800020aa:	e04a                	sd	s2,0(sp)
    800020ac:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020ae:	fffff097          	auipc	ra,0xfffff
    800020b2:	e58080e7          	jalr	-424(ra) # 80000f06 <myproc>
    800020b6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020b8:	05853903          	ld	s2,88(a0)
    800020bc:	0a893783          	ld	a5,168(s2)
    800020c0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020c4:	37fd                	addiw	a5,a5,-1
    800020c6:	4751                	li	a4,20
    800020c8:	00f76f63          	bltu	a4,a5,800020e6 <syscall+0x44>
    800020cc:	00369713          	slli	a4,a3,0x3
    800020d0:	00006797          	auipc	a5,0x6
    800020d4:	70078793          	addi	a5,a5,1792 # 800087d0 <syscalls>
    800020d8:	97ba                	add	a5,a5,a4
    800020da:	639c                	ld	a5,0(a5)
    800020dc:	c789                	beqz	a5,800020e6 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020de:	9782                	jalr	a5
    800020e0:	06a93823          	sd	a0,112(s2)
    800020e4:	a839                	j	80002102 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020e6:	15848613          	addi	a2,s1,344
    800020ea:	588c                	lw	a1,48(s1)
    800020ec:	00006517          	auipc	a0,0x6
    800020f0:	2bc50513          	addi	a0,a0,700 # 800083a8 <etext+0x3a8>
    800020f4:	00004097          	auipc	ra,0x4
    800020f8:	d92080e7          	jalr	-622(ra) # 80005e86 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020fc:	6cbc                	ld	a5,88(s1)
    800020fe:	577d                	li	a4,-1
    80002100:	fbb8                	sd	a4,112(a5)
  }
}
    80002102:	60e2                	ld	ra,24(sp)
    80002104:	6442                	ld	s0,16(sp)
    80002106:	64a2                	ld	s1,8(sp)
    80002108:	6902                	ld	s2,0(sp)
    8000210a:	6105                	addi	sp,sp,32
    8000210c:	8082                	ret

000000008000210e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000210e:	1101                	addi	sp,sp,-32
    80002110:	ec06                	sd	ra,24(sp)
    80002112:	e822                	sd	s0,16(sp)
    80002114:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002116:	fec40593          	addi	a1,s0,-20
    8000211a:	4501                	li	a0,0
    8000211c:	00000097          	auipc	ra,0x0
    80002120:	f0e080e7          	jalr	-242(ra) # 8000202a <argint>
  exit(n);
    80002124:	fec42503          	lw	a0,-20(s0)
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	5c0080e7          	jalr	1472(ra) # 800016e8 <exit>
  return 0;  // not reached
}
    80002130:	4501                	li	a0,0
    80002132:	60e2                	ld	ra,24(sp)
    80002134:	6442                	ld	s0,16(sp)
    80002136:	6105                	addi	sp,sp,32
    80002138:	8082                	ret

000000008000213a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000213a:	1141                	addi	sp,sp,-16
    8000213c:	e406                	sd	ra,8(sp)
    8000213e:	e022                	sd	s0,0(sp)
    80002140:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002142:	fffff097          	auipc	ra,0xfffff
    80002146:	dc4080e7          	jalr	-572(ra) # 80000f06 <myproc>
}
    8000214a:	5908                	lw	a0,48(a0)
    8000214c:	60a2                	ld	ra,8(sp)
    8000214e:	6402                	ld	s0,0(sp)
    80002150:	0141                	addi	sp,sp,16
    80002152:	8082                	ret

0000000080002154 <sys_fork>:

uint64
sys_fork(void)
{
    80002154:	1141                	addi	sp,sp,-16
    80002156:	e406                	sd	ra,8(sp)
    80002158:	e022                	sd	s0,0(sp)
    8000215a:	0800                	addi	s0,sp,16
  return fork();
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	164080e7          	jalr	356(ra) # 800012c0 <fork>
}
    80002164:	60a2                	ld	ra,8(sp)
    80002166:	6402                	ld	s0,0(sp)
    80002168:	0141                	addi	sp,sp,16
    8000216a:	8082                	ret

000000008000216c <sys_wait>:

uint64
sys_wait(void)
{
    8000216c:	1101                	addi	sp,sp,-32
    8000216e:	ec06                	sd	ra,24(sp)
    80002170:	e822                	sd	s0,16(sp)
    80002172:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002174:	fe840593          	addi	a1,s0,-24
    80002178:	4501                	li	a0,0
    8000217a:	00000097          	auipc	ra,0x0
    8000217e:	ed0080e7          	jalr	-304(ra) # 8000204a <argaddr>
  return wait(p);
    80002182:	fe843503          	ld	a0,-24(s0)
    80002186:	fffff097          	auipc	ra,0xfffff
    8000218a:	708080e7          	jalr	1800(ra) # 8000188e <wait>
}
    8000218e:	60e2                	ld	ra,24(sp)
    80002190:	6442                	ld	s0,16(sp)
    80002192:	6105                	addi	sp,sp,32
    80002194:	8082                	ret

0000000080002196 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002196:	7179                	addi	sp,sp,-48
    80002198:	f406                	sd	ra,40(sp)
    8000219a:	f022                	sd	s0,32(sp)
    8000219c:	ec26                	sd	s1,24(sp)
    8000219e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021a0:	fdc40593          	addi	a1,s0,-36
    800021a4:	4501                	li	a0,0
    800021a6:	00000097          	auipc	ra,0x0
    800021aa:	e84080e7          	jalr	-380(ra) # 8000202a <argint>
  addr = myproc()->sz;
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	d58080e7          	jalr	-680(ra) # 80000f06 <myproc>
    800021b6:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021b8:	fdc42503          	lw	a0,-36(s0)
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	0a8080e7          	jalr	168(ra) # 80001264 <growproc>
    800021c4:	00054863          	bltz	a0,800021d4 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021c8:	8526                	mv	a0,s1
    800021ca:	70a2                	ld	ra,40(sp)
    800021cc:	7402                	ld	s0,32(sp)
    800021ce:	64e2                	ld	s1,24(sp)
    800021d0:	6145                	addi	sp,sp,48
    800021d2:	8082                	ret
    return -1;
    800021d4:	54fd                	li	s1,-1
    800021d6:	bfcd                	j	800021c8 <sys_sbrk+0x32>

00000000800021d8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021d8:	7139                	addi	sp,sp,-64
    800021da:	fc06                	sd	ra,56(sp)
    800021dc:	f822                	sd	s0,48(sp)
    800021de:	f04a                	sd	s2,32(sp)
    800021e0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021e2:	fcc40593          	addi	a1,s0,-52
    800021e6:	4501                	li	a0,0
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	e42080e7          	jalr	-446(ra) # 8000202a <argint>
  if(n < 0)
    800021f0:	fcc42783          	lw	a5,-52(s0)
    800021f4:	0807c563          	bltz	a5,8000227e <sys_sleep+0xa6>
    n = 0;
  acquire(&tickslock);
    800021f8:	0000c517          	auipc	a0,0xc
    800021fc:	57850513          	addi	a0,a0,1400 # 8000e770 <tickslock>
    80002200:	00004097          	auipc	ra,0x4
    80002204:	184080e7          	jalr	388(ra) # 80006384 <acquire>
  ticks0 = ticks;
    80002208:	00006917          	auipc	s2,0x6
    8000220c:	70092903          	lw	s2,1792(s2) # 80008908 <ticks>
  while(ticks - ticks0 < n){
    80002210:	fcc42783          	lw	a5,-52(s0)
    80002214:	c3b9                	beqz	a5,8000225a <sys_sleep+0x82>
    80002216:	f426                	sd	s1,40(sp)
    80002218:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000221a:	0000c997          	auipc	s3,0xc
    8000221e:	55698993          	addi	s3,s3,1366 # 8000e770 <tickslock>
    80002222:	00006497          	auipc	s1,0x6
    80002226:	6e648493          	addi	s1,s1,1766 # 80008908 <ticks>
    if(killed(myproc())){
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	cdc080e7          	jalr	-804(ra) # 80000f06 <myproc>
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	62a080e7          	jalr	1578(ra) # 8000185c <killed>
    8000223a:	e529                	bnez	a0,80002284 <sys_sleep+0xac>
    sleep(&ticks, &tickslock);
    8000223c:	85ce                	mv	a1,s3
    8000223e:	8526                	mv	a0,s1
    80002240:	fffff097          	auipc	ra,0xfffff
    80002244:	374080e7          	jalr	884(ra) # 800015b4 <sleep>
  while(ticks - ticks0 < n){
    80002248:	409c                	lw	a5,0(s1)
    8000224a:	412787bb          	subw	a5,a5,s2
    8000224e:	fcc42703          	lw	a4,-52(s0)
    80002252:	fce7ece3          	bltu	a5,a4,8000222a <sys_sleep+0x52>
    80002256:	74a2                	ld	s1,40(sp)
    80002258:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000225a:	0000c517          	auipc	a0,0xc
    8000225e:	51650513          	addi	a0,a0,1302 # 8000e770 <tickslock>
    80002262:	00004097          	auipc	ra,0x4
    80002266:	1d6080e7          	jalr	470(ra) # 80006438 <release>
  backtrace();
    8000226a:	00004097          	auipc	ra,0x4
    8000226e:	b5a080e7          	jalr	-1190(ra) # 80005dc4 <backtrace>
  return 0;
    80002272:	4501                	li	a0,0
}
    80002274:	70e2                	ld	ra,56(sp)
    80002276:	7442                	ld	s0,48(sp)
    80002278:	7902                	ld	s2,32(sp)
    8000227a:	6121                	addi	sp,sp,64
    8000227c:	8082                	ret
    n = 0;
    8000227e:	fc042623          	sw	zero,-52(s0)
    80002282:	bf9d                	j	800021f8 <sys_sleep+0x20>
      release(&tickslock);
    80002284:	0000c517          	auipc	a0,0xc
    80002288:	4ec50513          	addi	a0,a0,1260 # 8000e770 <tickslock>
    8000228c:	00004097          	auipc	ra,0x4
    80002290:	1ac080e7          	jalr	428(ra) # 80006438 <release>
      return -1;
    80002294:	557d                	li	a0,-1
    80002296:	74a2                	ld	s1,40(sp)
    80002298:	69e2                	ld	s3,24(sp)
    8000229a:	bfe9                	j	80002274 <sys_sleep+0x9c>

000000008000229c <sys_kill>:

uint64
sys_kill(void)
{
    8000229c:	1101                	addi	sp,sp,-32
    8000229e:	ec06                	sd	ra,24(sp)
    800022a0:	e822                	sd	s0,16(sp)
    800022a2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022a4:	fec40593          	addi	a1,s0,-20
    800022a8:	4501                	li	a0,0
    800022aa:	00000097          	auipc	ra,0x0
    800022ae:	d80080e7          	jalr	-640(ra) # 8000202a <argint>
  return kill(pid);
    800022b2:	fec42503          	lw	a0,-20(s0)
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	508080e7          	jalr	1288(ra) # 800017be <kill>
}
    800022be:	60e2                	ld	ra,24(sp)
    800022c0:	6442                	ld	s0,16(sp)
    800022c2:	6105                	addi	sp,sp,32
    800022c4:	8082                	ret

00000000800022c6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022c6:	1101                	addi	sp,sp,-32
    800022c8:	ec06                	sd	ra,24(sp)
    800022ca:	e822                	sd	s0,16(sp)
    800022cc:	e426                	sd	s1,8(sp)
    800022ce:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022d0:	0000c517          	auipc	a0,0xc
    800022d4:	4a050513          	addi	a0,a0,1184 # 8000e770 <tickslock>
    800022d8:	00004097          	auipc	ra,0x4
    800022dc:	0ac080e7          	jalr	172(ra) # 80006384 <acquire>
  xticks = ticks;
    800022e0:	00006497          	auipc	s1,0x6
    800022e4:	6284a483          	lw	s1,1576(s1) # 80008908 <ticks>
  release(&tickslock);
    800022e8:	0000c517          	auipc	a0,0xc
    800022ec:	48850513          	addi	a0,a0,1160 # 8000e770 <tickslock>
    800022f0:	00004097          	auipc	ra,0x4
    800022f4:	148080e7          	jalr	328(ra) # 80006438 <release>
  return xticks;
}
    800022f8:	02049513          	slli	a0,s1,0x20
    800022fc:	9101                	srli	a0,a0,0x20
    800022fe:	60e2                	ld	ra,24(sp)
    80002300:	6442                	ld	s0,16(sp)
    80002302:	64a2                	ld	s1,8(sp)
    80002304:	6105                	addi	sp,sp,32
    80002306:	8082                	ret

0000000080002308 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002308:	7179                	addi	sp,sp,-48
    8000230a:	f406                	sd	ra,40(sp)
    8000230c:	f022                	sd	s0,32(sp)
    8000230e:	ec26                	sd	s1,24(sp)
    80002310:	e84a                	sd	s2,16(sp)
    80002312:	e44e                	sd	s3,8(sp)
    80002314:	e052                	sd	s4,0(sp)
    80002316:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002318:	00006597          	auipc	a1,0x6
    8000231c:	0b058593          	addi	a1,a1,176 # 800083c8 <etext+0x3c8>
    80002320:	0000c517          	auipc	a0,0xc
    80002324:	46850513          	addi	a0,a0,1128 # 8000e788 <bcache>
    80002328:	00004097          	auipc	ra,0x4
    8000232c:	fcc080e7          	jalr	-52(ra) # 800062f4 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002330:	00014797          	auipc	a5,0x14
    80002334:	45878793          	addi	a5,a5,1112 # 80016788 <bcache+0x8000>
    80002338:	00014717          	auipc	a4,0x14
    8000233c:	6b870713          	addi	a4,a4,1720 # 800169f0 <bcache+0x8268>
    80002340:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002344:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002348:	0000c497          	auipc	s1,0xc
    8000234c:	45848493          	addi	s1,s1,1112 # 8000e7a0 <bcache+0x18>
    b->next = bcache.head.next;
    80002350:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002352:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002354:	00006a17          	auipc	s4,0x6
    80002358:	07ca0a13          	addi	s4,s4,124 # 800083d0 <etext+0x3d0>
    b->next = bcache.head.next;
    8000235c:	2b893783          	ld	a5,696(s2)
    80002360:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002362:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002366:	85d2                	mv	a1,s4
    80002368:	01048513          	addi	a0,s1,16
    8000236c:	00001097          	auipc	ra,0x1
    80002370:	4e8080e7          	jalr	1256(ra) # 80003854 <initsleeplock>
    bcache.head.next->prev = b;
    80002374:	2b893783          	ld	a5,696(s2)
    80002378:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000237a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000237e:	45848493          	addi	s1,s1,1112
    80002382:	fd349de3          	bne	s1,s3,8000235c <binit+0x54>
  }
}
    80002386:	70a2                	ld	ra,40(sp)
    80002388:	7402                	ld	s0,32(sp)
    8000238a:	64e2                	ld	s1,24(sp)
    8000238c:	6942                	ld	s2,16(sp)
    8000238e:	69a2                	ld	s3,8(sp)
    80002390:	6a02                	ld	s4,0(sp)
    80002392:	6145                	addi	sp,sp,48
    80002394:	8082                	ret

0000000080002396 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002396:	7179                	addi	sp,sp,-48
    80002398:	f406                	sd	ra,40(sp)
    8000239a:	f022                	sd	s0,32(sp)
    8000239c:	ec26                	sd	s1,24(sp)
    8000239e:	e84a                	sd	s2,16(sp)
    800023a0:	e44e                	sd	s3,8(sp)
    800023a2:	1800                	addi	s0,sp,48
    800023a4:	892a                	mv	s2,a0
    800023a6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023a8:	0000c517          	auipc	a0,0xc
    800023ac:	3e050513          	addi	a0,a0,992 # 8000e788 <bcache>
    800023b0:	00004097          	auipc	ra,0x4
    800023b4:	fd4080e7          	jalr	-44(ra) # 80006384 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023b8:	00014497          	auipc	s1,0x14
    800023bc:	6884b483          	ld	s1,1672(s1) # 80016a40 <bcache+0x82b8>
    800023c0:	00014797          	auipc	a5,0x14
    800023c4:	63078793          	addi	a5,a5,1584 # 800169f0 <bcache+0x8268>
    800023c8:	02f48f63          	beq	s1,a5,80002406 <bread+0x70>
    800023cc:	873e                	mv	a4,a5
    800023ce:	a021                	j	800023d6 <bread+0x40>
    800023d0:	68a4                	ld	s1,80(s1)
    800023d2:	02e48a63          	beq	s1,a4,80002406 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023d6:	449c                	lw	a5,8(s1)
    800023d8:	ff279ce3          	bne	a5,s2,800023d0 <bread+0x3a>
    800023dc:	44dc                	lw	a5,12(s1)
    800023de:	ff3799e3          	bne	a5,s3,800023d0 <bread+0x3a>
      b->refcnt++;
    800023e2:	40bc                	lw	a5,64(s1)
    800023e4:	2785                	addiw	a5,a5,1
    800023e6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023e8:	0000c517          	auipc	a0,0xc
    800023ec:	3a050513          	addi	a0,a0,928 # 8000e788 <bcache>
    800023f0:	00004097          	auipc	ra,0x4
    800023f4:	048080e7          	jalr	72(ra) # 80006438 <release>
      acquiresleep(&b->lock);
    800023f8:	01048513          	addi	a0,s1,16
    800023fc:	00001097          	auipc	ra,0x1
    80002400:	492080e7          	jalr	1170(ra) # 8000388e <acquiresleep>
      return b;
    80002404:	a8b9                	j	80002462 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002406:	00014497          	auipc	s1,0x14
    8000240a:	6324b483          	ld	s1,1586(s1) # 80016a38 <bcache+0x82b0>
    8000240e:	00014797          	auipc	a5,0x14
    80002412:	5e278793          	addi	a5,a5,1506 # 800169f0 <bcache+0x8268>
    80002416:	00f48863          	beq	s1,a5,80002426 <bread+0x90>
    8000241a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000241c:	40bc                	lw	a5,64(s1)
    8000241e:	cf81                	beqz	a5,80002436 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002420:	64a4                	ld	s1,72(s1)
    80002422:	fee49de3          	bne	s1,a4,8000241c <bread+0x86>
  panic("bget: no buffers");
    80002426:	00006517          	auipc	a0,0x6
    8000242a:	fb250513          	addi	a0,a0,-78 # 800083d8 <etext+0x3d8>
    8000242e:	00004097          	auipc	ra,0x4
    80002432:	a06080e7          	jalr	-1530(ra) # 80005e34 <panic>
      b->dev = dev;
    80002436:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000243a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000243e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002442:	4785                	li	a5,1
    80002444:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002446:	0000c517          	auipc	a0,0xc
    8000244a:	34250513          	addi	a0,a0,834 # 8000e788 <bcache>
    8000244e:	00004097          	auipc	ra,0x4
    80002452:	fea080e7          	jalr	-22(ra) # 80006438 <release>
      acquiresleep(&b->lock);
    80002456:	01048513          	addi	a0,s1,16
    8000245a:	00001097          	auipc	ra,0x1
    8000245e:	434080e7          	jalr	1076(ra) # 8000388e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002462:	409c                	lw	a5,0(s1)
    80002464:	cb89                	beqz	a5,80002476 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002466:	8526                	mv	a0,s1
    80002468:	70a2                	ld	ra,40(sp)
    8000246a:	7402                	ld	s0,32(sp)
    8000246c:	64e2                	ld	s1,24(sp)
    8000246e:	6942                	ld	s2,16(sp)
    80002470:	69a2                	ld	s3,8(sp)
    80002472:	6145                	addi	sp,sp,48
    80002474:	8082                	ret
    virtio_disk_rw(b, 0);
    80002476:	4581                	li	a1,0
    80002478:	8526                	mv	a0,s1
    8000247a:	00003097          	auipc	ra,0x3
    8000247e:	0ee080e7          	jalr	238(ra) # 80005568 <virtio_disk_rw>
    b->valid = 1;
    80002482:	4785                	li	a5,1
    80002484:	c09c                	sw	a5,0(s1)
  return b;
    80002486:	b7c5                	j	80002466 <bread+0xd0>

0000000080002488 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002488:	1101                	addi	sp,sp,-32
    8000248a:	ec06                	sd	ra,24(sp)
    8000248c:	e822                	sd	s0,16(sp)
    8000248e:	e426                	sd	s1,8(sp)
    80002490:	1000                	addi	s0,sp,32
    80002492:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002494:	0541                	addi	a0,a0,16
    80002496:	00001097          	auipc	ra,0x1
    8000249a:	492080e7          	jalr	1170(ra) # 80003928 <holdingsleep>
    8000249e:	cd01                	beqz	a0,800024b6 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024a0:	4585                	li	a1,1
    800024a2:	8526                	mv	a0,s1
    800024a4:	00003097          	auipc	ra,0x3
    800024a8:	0c4080e7          	jalr	196(ra) # 80005568 <virtio_disk_rw>
}
    800024ac:	60e2                	ld	ra,24(sp)
    800024ae:	6442                	ld	s0,16(sp)
    800024b0:	64a2                	ld	s1,8(sp)
    800024b2:	6105                	addi	sp,sp,32
    800024b4:	8082                	ret
    panic("bwrite");
    800024b6:	00006517          	auipc	a0,0x6
    800024ba:	f3a50513          	addi	a0,a0,-198 # 800083f0 <etext+0x3f0>
    800024be:	00004097          	auipc	ra,0x4
    800024c2:	976080e7          	jalr	-1674(ra) # 80005e34 <panic>

00000000800024c6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024c6:	1101                	addi	sp,sp,-32
    800024c8:	ec06                	sd	ra,24(sp)
    800024ca:	e822                	sd	s0,16(sp)
    800024cc:	e426                	sd	s1,8(sp)
    800024ce:	e04a                	sd	s2,0(sp)
    800024d0:	1000                	addi	s0,sp,32
    800024d2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024d4:	01050913          	addi	s2,a0,16
    800024d8:	854a                	mv	a0,s2
    800024da:	00001097          	auipc	ra,0x1
    800024de:	44e080e7          	jalr	1102(ra) # 80003928 <holdingsleep>
    800024e2:	c925                	beqz	a0,80002552 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800024e4:	854a                	mv	a0,s2
    800024e6:	00001097          	auipc	ra,0x1
    800024ea:	3fe080e7          	jalr	1022(ra) # 800038e4 <releasesleep>

  acquire(&bcache.lock);
    800024ee:	0000c517          	auipc	a0,0xc
    800024f2:	29a50513          	addi	a0,a0,666 # 8000e788 <bcache>
    800024f6:	00004097          	auipc	ra,0x4
    800024fa:	e8e080e7          	jalr	-370(ra) # 80006384 <acquire>
  b->refcnt--;
    800024fe:	40bc                	lw	a5,64(s1)
    80002500:	37fd                	addiw	a5,a5,-1
    80002502:	0007871b          	sext.w	a4,a5
    80002506:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002508:	e71d                	bnez	a4,80002536 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000250a:	68b8                	ld	a4,80(s1)
    8000250c:	64bc                	ld	a5,72(s1)
    8000250e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002510:	68b8                	ld	a4,80(s1)
    80002512:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002514:	00014797          	auipc	a5,0x14
    80002518:	27478793          	addi	a5,a5,628 # 80016788 <bcache+0x8000>
    8000251c:	2b87b703          	ld	a4,696(a5)
    80002520:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002522:	00014717          	auipc	a4,0x14
    80002526:	4ce70713          	addi	a4,a4,1230 # 800169f0 <bcache+0x8268>
    8000252a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000252c:	2b87b703          	ld	a4,696(a5)
    80002530:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002532:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002536:	0000c517          	auipc	a0,0xc
    8000253a:	25250513          	addi	a0,a0,594 # 8000e788 <bcache>
    8000253e:	00004097          	auipc	ra,0x4
    80002542:	efa080e7          	jalr	-262(ra) # 80006438 <release>
}
    80002546:	60e2                	ld	ra,24(sp)
    80002548:	6442                	ld	s0,16(sp)
    8000254a:	64a2                	ld	s1,8(sp)
    8000254c:	6902                	ld	s2,0(sp)
    8000254e:	6105                	addi	sp,sp,32
    80002550:	8082                	ret
    panic("brelse");
    80002552:	00006517          	auipc	a0,0x6
    80002556:	ea650513          	addi	a0,a0,-346 # 800083f8 <etext+0x3f8>
    8000255a:	00004097          	auipc	ra,0x4
    8000255e:	8da080e7          	jalr	-1830(ra) # 80005e34 <panic>

0000000080002562 <bpin>:

void
bpin(struct buf *b) {
    80002562:	1101                	addi	sp,sp,-32
    80002564:	ec06                	sd	ra,24(sp)
    80002566:	e822                	sd	s0,16(sp)
    80002568:	e426                	sd	s1,8(sp)
    8000256a:	1000                	addi	s0,sp,32
    8000256c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000256e:	0000c517          	auipc	a0,0xc
    80002572:	21a50513          	addi	a0,a0,538 # 8000e788 <bcache>
    80002576:	00004097          	auipc	ra,0x4
    8000257a:	e0e080e7          	jalr	-498(ra) # 80006384 <acquire>
  b->refcnt++;
    8000257e:	40bc                	lw	a5,64(s1)
    80002580:	2785                	addiw	a5,a5,1
    80002582:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002584:	0000c517          	auipc	a0,0xc
    80002588:	20450513          	addi	a0,a0,516 # 8000e788 <bcache>
    8000258c:	00004097          	auipc	ra,0x4
    80002590:	eac080e7          	jalr	-340(ra) # 80006438 <release>
}
    80002594:	60e2                	ld	ra,24(sp)
    80002596:	6442                	ld	s0,16(sp)
    80002598:	64a2                	ld	s1,8(sp)
    8000259a:	6105                	addi	sp,sp,32
    8000259c:	8082                	ret

000000008000259e <bunpin>:

void
bunpin(struct buf *b) {
    8000259e:	1101                	addi	sp,sp,-32
    800025a0:	ec06                	sd	ra,24(sp)
    800025a2:	e822                	sd	s0,16(sp)
    800025a4:	e426                	sd	s1,8(sp)
    800025a6:	1000                	addi	s0,sp,32
    800025a8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025aa:	0000c517          	auipc	a0,0xc
    800025ae:	1de50513          	addi	a0,a0,478 # 8000e788 <bcache>
    800025b2:	00004097          	auipc	ra,0x4
    800025b6:	dd2080e7          	jalr	-558(ra) # 80006384 <acquire>
  b->refcnt--;
    800025ba:	40bc                	lw	a5,64(s1)
    800025bc:	37fd                	addiw	a5,a5,-1
    800025be:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025c0:	0000c517          	auipc	a0,0xc
    800025c4:	1c850513          	addi	a0,a0,456 # 8000e788 <bcache>
    800025c8:	00004097          	auipc	ra,0x4
    800025cc:	e70080e7          	jalr	-400(ra) # 80006438 <release>
}
    800025d0:	60e2                	ld	ra,24(sp)
    800025d2:	6442                	ld	s0,16(sp)
    800025d4:	64a2                	ld	s1,8(sp)
    800025d6:	6105                	addi	sp,sp,32
    800025d8:	8082                	ret

00000000800025da <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025da:	1101                	addi	sp,sp,-32
    800025dc:	ec06                	sd	ra,24(sp)
    800025de:	e822                	sd	s0,16(sp)
    800025e0:	e426                	sd	s1,8(sp)
    800025e2:	e04a                	sd	s2,0(sp)
    800025e4:	1000                	addi	s0,sp,32
    800025e6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025e8:	00d5d59b          	srliw	a1,a1,0xd
    800025ec:	00015797          	auipc	a5,0x15
    800025f0:	8787a783          	lw	a5,-1928(a5) # 80016e64 <sb+0x1c>
    800025f4:	9dbd                	addw	a1,a1,a5
    800025f6:	00000097          	auipc	ra,0x0
    800025fa:	da0080e7          	jalr	-608(ra) # 80002396 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025fe:	0074f713          	andi	a4,s1,7
    80002602:	4785                	li	a5,1
    80002604:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002608:	14ce                	slli	s1,s1,0x33
    8000260a:	90d9                	srli	s1,s1,0x36
    8000260c:	00950733          	add	a4,a0,s1
    80002610:	05874703          	lbu	a4,88(a4)
    80002614:	00e7f6b3          	and	a3,a5,a4
    80002618:	c69d                	beqz	a3,80002646 <bfree+0x6c>
    8000261a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000261c:	94aa                	add	s1,s1,a0
    8000261e:	fff7c793          	not	a5,a5
    80002622:	8f7d                	and	a4,a4,a5
    80002624:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002628:	00001097          	auipc	ra,0x1
    8000262c:	148080e7          	jalr	328(ra) # 80003770 <log_write>
  brelse(bp);
    80002630:	854a                	mv	a0,s2
    80002632:	00000097          	auipc	ra,0x0
    80002636:	e94080e7          	jalr	-364(ra) # 800024c6 <brelse>
}
    8000263a:	60e2                	ld	ra,24(sp)
    8000263c:	6442                	ld	s0,16(sp)
    8000263e:	64a2                	ld	s1,8(sp)
    80002640:	6902                	ld	s2,0(sp)
    80002642:	6105                	addi	sp,sp,32
    80002644:	8082                	ret
    panic("freeing free block");
    80002646:	00006517          	auipc	a0,0x6
    8000264a:	dba50513          	addi	a0,a0,-582 # 80008400 <etext+0x400>
    8000264e:	00003097          	auipc	ra,0x3
    80002652:	7e6080e7          	jalr	2022(ra) # 80005e34 <panic>

0000000080002656 <balloc>:
{
    80002656:	711d                	addi	sp,sp,-96
    80002658:	ec86                	sd	ra,88(sp)
    8000265a:	e8a2                	sd	s0,80(sp)
    8000265c:	e4a6                	sd	s1,72(sp)
    8000265e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002660:	00014797          	auipc	a5,0x14
    80002664:	7ec7a783          	lw	a5,2028(a5) # 80016e4c <sb+0x4>
    80002668:	10078f63          	beqz	a5,80002786 <balloc+0x130>
    8000266c:	e0ca                	sd	s2,64(sp)
    8000266e:	fc4e                	sd	s3,56(sp)
    80002670:	f852                	sd	s4,48(sp)
    80002672:	f456                	sd	s5,40(sp)
    80002674:	f05a                	sd	s6,32(sp)
    80002676:	ec5e                	sd	s7,24(sp)
    80002678:	e862                	sd	s8,16(sp)
    8000267a:	e466                	sd	s9,8(sp)
    8000267c:	8baa                	mv	s7,a0
    8000267e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002680:	00014b17          	auipc	s6,0x14
    80002684:	7c8b0b13          	addi	s6,s6,1992 # 80016e48 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002688:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000268a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000268c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000268e:	6c89                	lui	s9,0x2
    80002690:	a061                	j	80002718 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002692:	97ca                	add	a5,a5,s2
    80002694:	8e55                	or	a2,a2,a3
    80002696:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000269a:	854a                	mv	a0,s2
    8000269c:	00001097          	auipc	ra,0x1
    800026a0:	0d4080e7          	jalr	212(ra) # 80003770 <log_write>
        brelse(bp);
    800026a4:	854a                	mv	a0,s2
    800026a6:	00000097          	auipc	ra,0x0
    800026aa:	e20080e7          	jalr	-480(ra) # 800024c6 <brelse>
  bp = bread(dev, bno);
    800026ae:	85a6                	mv	a1,s1
    800026b0:	855e                	mv	a0,s7
    800026b2:	00000097          	auipc	ra,0x0
    800026b6:	ce4080e7          	jalr	-796(ra) # 80002396 <bread>
    800026ba:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026bc:	40000613          	li	a2,1024
    800026c0:	4581                	li	a1,0
    800026c2:	05850513          	addi	a0,a0,88
    800026c6:	ffffe097          	auipc	ra,0xffffe
    800026ca:	ab4080e7          	jalr	-1356(ra) # 8000017a <memset>
  log_write(bp);
    800026ce:	854a                	mv	a0,s2
    800026d0:	00001097          	auipc	ra,0x1
    800026d4:	0a0080e7          	jalr	160(ra) # 80003770 <log_write>
  brelse(bp);
    800026d8:	854a                	mv	a0,s2
    800026da:	00000097          	auipc	ra,0x0
    800026de:	dec080e7          	jalr	-532(ra) # 800024c6 <brelse>
}
    800026e2:	6906                	ld	s2,64(sp)
    800026e4:	79e2                	ld	s3,56(sp)
    800026e6:	7a42                	ld	s4,48(sp)
    800026e8:	7aa2                	ld	s5,40(sp)
    800026ea:	7b02                	ld	s6,32(sp)
    800026ec:	6be2                	ld	s7,24(sp)
    800026ee:	6c42                	ld	s8,16(sp)
    800026f0:	6ca2                	ld	s9,8(sp)
}
    800026f2:	8526                	mv	a0,s1
    800026f4:	60e6                	ld	ra,88(sp)
    800026f6:	6446                	ld	s0,80(sp)
    800026f8:	64a6                	ld	s1,72(sp)
    800026fa:	6125                	addi	sp,sp,96
    800026fc:	8082                	ret
    brelse(bp);
    800026fe:	854a                	mv	a0,s2
    80002700:	00000097          	auipc	ra,0x0
    80002704:	dc6080e7          	jalr	-570(ra) # 800024c6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002708:	015c87bb          	addw	a5,s9,s5
    8000270c:	00078a9b          	sext.w	s5,a5
    80002710:	004b2703          	lw	a4,4(s6)
    80002714:	06eaf163          	bgeu	s5,a4,80002776 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80002718:	41fad79b          	sraiw	a5,s5,0x1f
    8000271c:	0137d79b          	srliw	a5,a5,0x13
    80002720:	015787bb          	addw	a5,a5,s5
    80002724:	40d7d79b          	sraiw	a5,a5,0xd
    80002728:	01cb2583          	lw	a1,28(s6)
    8000272c:	9dbd                	addw	a1,a1,a5
    8000272e:	855e                	mv	a0,s7
    80002730:	00000097          	auipc	ra,0x0
    80002734:	c66080e7          	jalr	-922(ra) # 80002396 <bread>
    80002738:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000273a:	004b2503          	lw	a0,4(s6)
    8000273e:	000a849b          	sext.w	s1,s5
    80002742:	8762                	mv	a4,s8
    80002744:	faa4fde3          	bgeu	s1,a0,800026fe <balloc+0xa8>
      m = 1 << (bi % 8);
    80002748:	00777693          	andi	a3,a4,7
    8000274c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002750:	41f7579b          	sraiw	a5,a4,0x1f
    80002754:	01d7d79b          	srliw	a5,a5,0x1d
    80002758:	9fb9                	addw	a5,a5,a4
    8000275a:	4037d79b          	sraiw	a5,a5,0x3
    8000275e:	00f90633          	add	a2,s2,a5
    80002762:	05864603          	lbu	a2,88(a2)
    80002766:	00c6f5b3          	and	a1,a3,a2
    8000276a:	d585                	beqz	a1,80002692 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000276c:	2705                	addiw	a4,a4,1
    8000276e:	2485                	addiw	s1,s1,1
    80002770:	fd471ae3          	bne	a4,s4,80002744 <balloc+0xee>
    80002774:	b769                	j	800026fe <balloc+0xa8>
    80002776:	6906                	ld	s2,64(sp)
    80002778:	79e2                	ld	s3,56(sp)
    8000277a:	7a42                	ld	s4,48(sp)
    8000277c:	7aa2                	ld	s5,40(sp)
    8000277e:	7b02                	ld	s6,32(sp)
    80002780:	6be2                	ld	s7,24(sp)
    80002782:	6c42                	ld	s8,16(sp)
    80002784:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002786:	00006517          	auipc	a0,0x6
    8000278a:	c9250513          	addi	a0,a0,-878 # 80008418 <etext+0x418>
    8000278e:	00003097          	auipc	ra,0x3
    80002792:	6f8080e7          	jalr	1784(ra) # 80005e86 <printf>
  return 0;
    80002796:	4481                	li	s1,0
    80002798:	bfa9                	j	800026f2 <balloc+0x9c>

000000008000279a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000279a:	7179                	addi	sp,sp,-48
    8000279c:	f406                	sd	ra,40(sp)
    8000279e:	f022                	sd	s0,32(sp)
    800027a0:	ec26                	sd	s1,24(sp)
    800027a2:	e84a                	sd	s2,16(sp)
    800027a4:	e44e                	sd	s3,8(sp)
    800027a6:	1800                	addi	s0,sp,48
    800027a8:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027aa:	47ad                	li	a5,11
    800027ac:	02b7e863          	bltu	a5,a1,800027dc <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800027b0:	02059793          	slli	a5,a1,0x20
    800027b4:	01e7d593          	srli	a1,a5,0x1e
    800027b8:	00b504b3          	add	s1,a0,a1
    800027bc:	0504a903          	lw	s2,80(s1)
    800027c0:	08091263          	bnez	s2,80002844 <bmap+0xaa>
      addr = balloc(ip->dev);
    800027c4:	4108                	lw	a0,0(a0)
    800027c6:	00000097          	auipc	ra,0x0
    800027ca:	e90080e7          	jalr	-368(ra) # 80002656 <balloc>
    800027ce:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027d2:	06090963          	beqz	s2,80002844 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    800027d6:	0524a823          	sw	s2,80(s1)
    800027da:	a0ad                	j	80002844 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    800027dc:	ff45849b          	addiw	s1,a1,-12
    800027e0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027e4:	0ff00793          	li	a5,255
    800027e8:	08e7e863          	bltu	a5,a4,80002878 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800027ec:	08052903          	lw	s2,128(a0)
    800027f0:	00091f63          	bnez	s2,8000280e <bmap+0x74>
      addr = balloc(ip->dev);
    800027f4:	4108                	lw	a0,0(a0)
    800027f6:	00000097          	auipc	ra,0x0
    800027fa:	e60080e7          	jalr	-416(ra) # 80002656 <balloc>
    800027fe:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002802:	04090163          	beqz	s2,80002844 <bmap+0xaa>
    80002806:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002808:	0929a023          	sw	s2,128(s3)
    8000280c:	a011                	j	80002810 <bmap+0x76>
    8000280e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002810:	85ca                	mv	a1,s2
    80002812:	0009a503          	lw	a0,0(s3)
    80002816:	00000097          	auipc	ra,0x0
    8000281a:	b80080e7          	jalr	-1152(ra) # 80002396 <bread>
    8000281e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002820:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002824:	02049713          	slli	a4,s1,0x20
    80002828:	01e75593          	srli	a1,a4,0x1e
    8000282c:	00b784b3          	add	s1,a5,a1
    80002830:	0004a903          	lw	s2,0(s1)
    80002834:	02090063          	beqz	s2,80002854 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002838:	8552                	mv	a0,s4
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	c8c080e7          	jalr	-884(ra) # 800024c6 <brelse>
    return addr;
    80002842:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002844:	854a                	mv	a0,s2
    80002846:	70a2                	ld	ra,40(sp)
    80002848:	7402                	ld	s0,32(sp)
    8000284a:	64e2                	ld	s1,24(sp)
    8000284c:	6942                	ld	s2,16(sp)
    8000284e:	69a2                	ld	s3,8(sp)
    80002850:	6145                	addi	sp,sp,48
    80002852:	8082                	ret
      addr = balloc(ip->dev);
    80002854:	0009a503          	lw	a0,0(s3)
    80002858:	00000097          	auipc	ra,0x0
    8000285c:	dfe080e7          	jalr	-514(ra) # 80002656 <balloc>
    80002860:	0005091b          	sext.w	s2,a0
      if(addr){
    80002864:	fc090ae3          	beqz	s2,80002838 <bmap+0x9e>
        a[bn] = addr;
    80002868:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000286c:	8552                	mv	a0,s4
    8000286e:	00001097          	auipc	ra,0x1
    80002872:	f02080e7          	jalr	-254(ra) # 80003770 <log_write>
    80002876:	b7c9                	j	80002838 <bmap+0x9e>
    80002878:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000287a:	00006517          	auipc	a0,0x6
    8000287e:	bb650513          	addi	a0,a0,-1098 # 80008430 <etext+0x430>
    80002882:	00003097          	auipc	ra,0x3
    80002886:	5b2080e7          	jalr	1458(ra) # 80005e34 <panic>

000000008000288a <iget>:
{
    8000288a:	7179                	addi	sp,sp,-48
    8000288c:	f406                	sd	ra,40(sp)
    8000288e:	f022                	sd	s0,32(sp)
    80002890:	ec26                	sd	s1,24(sp)
    80002892:	e84a                	sd	s2,16(sp)
    80002894:	e44e                	sd	s3,8(sp)
    80002896:	e052                	sd	s4,0(sp)
    80002898:	1800                	addi	s0,sp,48
    8000289a:	89aa                	mv	s3,a0
    8000289c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000289e:	00014517          	auipc	a0,0x14
    800028a2:	5ca50513          	addi	a0,a0,1482 # 80016e68 <itable>
    800028a6:	00004097          	auipc	ra,0x4
    800028aa:	ade080e7          	jalr	-1314(ra) # 80006384 <acquire>
  empty = 0;
    800028ae:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028b0:	00014497          	auipc	s1,0x14
    800028b4:	5d048493          	addi	s1,s1,1488 # 80016e80 <itable+0x18>
    800028b8:	00016697          	auipc	a3,0x16
    800028bc:	05868693          	addi	a3,a3,88 # 80018910 <log>
    800028c0:	a039                	j	800028ce <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028c2:	02090b63          	beqz	s2,800028f8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028c6:	08848493          	addi	s1,s1,136
    800028ca:	02d48a63          	beq	s1,a3,800028fe <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028ce:	449c                	lw	a5,8(s1)
    800028d0:	fef059e3          	blez	a5,800028c2 <iget+0x38>
    800028d4:	4098                	lw	a4,0(s1)
    800028d6:	ff3716e3          	bne	a4,s3,800028c2 <iget+0x38>
    800028da:	40d8                	lw	a4,4(s1)
    800028dc:	ff4713e3          	bne	a4,s4,800028c2 <iget+0x38>
      ip->ref++;
    800028e0:	2785                	addiw	a5,a5,1
    800028e2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028e4:	00014517          	auipc	a0,0x14
    800028e8:	58450513          	addi	a0,a0,1412 # 80016e68 <itable>
    800028ec:	00004097          	auipc	ra,0x4
    800028f0:	b4c080e7          	jalr	-1204(ra) # 80006438 <release>
      return ip;
    800028f4:	8926                	mv	s2,s1
    800028f6:	a03d                	j	80002924 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028f8:	f7f9                	bnez	a5,800028c6 <iget+0x3c>
      empty = ip;
    800028fa:	8926                	mv	s2,s1
    800028fc:	b7e9                	j	800028c6 <iget+0x3c>
  if(empty == 0)
    800028fe:	02090c63          	beqz	s2,80002936 <iget+0xac>
  ip->dev = dev;
    80002902:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002906:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000290a:	4785                	li	a5,1
    8000290c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002910:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002914:	00014517          	auipc	a0,0x14
    80002918:	55450513          	addi	a0,a0,1364 # 80016e68 <itable>
    8000291c:	00004097          	auipc	ra,0x4
    80002920:	b1c080e7          	jalr	-1252(ra) # 80006438 <release>
}
    80002924:	854a                	mv	a0,s2
    80002926:	70a2                	ld	ra,40(sp)
    80002928:	7402                	ld	s0,32(sp)
    8000292a:	64e2                	ld	s1,24(sp)
    8000292c:	6942                	ld	s2,16(sp)
    8000292e:	69a2                	ld	s3,8(sp)
    80002930:	6a02                	ld	s4,0(sp)
    80002932:	6145                	addi	sp,sp,48
    80002934:	8082                	ret
    panic("iget: no inodes");
    80002936:	00006517          	auipc	a0,0x6
    8000293a:	b1250513          	addi	a0,a0,-1262 # 80008448 <etext+0x448>
    8000293e:	00003097          	auipc	ra,0x3
    80002942:	4f6080e7          	jalr	1270(ra) # 80005e34 <panic>

0000000080002946 <fsinit>:
fsinit(int dev) {
    80002946:	7179                	addi	sp,sp,-48
    80002948:	f406                	sd	ra,40(sp)
    8000294a:	f022                	sd	s0,32(sp)
    8000294c:	ec26                	sd	s1,24(sp)
    8000294e:	e84a                	sd	s2,16(sp)
    80002950:	e44e                	sd	s3,8(sp)
    80002952:	1800                	addi	s0,sp,48
    80002954:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002956:	4585                	li	a1,1
    80002958:	00000097          	auipc	ra,0x0
    8000295c:	a3e080e7          	jalr	-1474(ra) # 80002396 <bread>
    80002960:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002962:	00014997          	auipc	s3,0x14
    80002966:	4e698993          	addi	s3,s3,1254 # 80016e48 <sb>
    8000296a:	02000613          	li	a2,32
    8000296e:	05850593          	addi	a1,a0,88
    80002972:	854e                	mv	a0,s3
    80002974:	ffffe097          	auipc	ra,0xffffe
    80002978:	862080e7          	jalr	-1950(ra) # 800001d6 <memmove>
  brelse(bp);
    8000297c:	8526                	mv	a0,s1
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	b48080e7          	jalr	-1208(ra) # 800024c6 <brelse>
  if(sb.magic != FSMAGIC)
    80002986:	0009a703          	lw	a4,0(s3)
    8000298a:	102037b7          	lui	a5,0x10203
    8000298e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002992:	02f71263          	bne	a4,a5,800029b6 <fsinit+0x70>
  initlog(dev, &sb);
    80002996:	00014597          	auipc	a1,0x14
    8000299a:	4b258593          	addi	a1,a1,1202 # 80016e48 <sb>
    8000299e:	854a                	mv	a0,s2
    800029a0:	00001097          	auipc	ra,0x1
    800029a4:	b60080e7          	jalr	-1184(ra) # 80003500 <initlog>
}
    800029a8:	70a2                	ld	ra,40(sp)
    800029aa:	7402                	ld	s0,32(sp)
    800029ac:	64e2                	ld	s1,24(sp)
    800029ae:	6942                	ld	s2,16(sp)
    800029b0:	69a2                	ld	s3,8(sp)
    800029b2:	6145                	addi	sp,sp,48
    800029b4:	8082                	ret
    panic("invalid file system");
    800029b6:	00006517          	auipc	a0,0x6
    800029ba:	aa250513          	addi	a0,a0,-1374 # 80008458 <etext+0x458>
    800029be:	00003097          	auipc	ra,0x3
    800029c2:	476080e7          	jalr	1142(ra) # 80005e34 <panic>

00000000800029c6 <iinit>:
{
    800029c6:	7179                	addi	sp,sp,-48
    800029c8:	f406                	sd	ra,40(sp)
    800029ca:	f022                	sd	s0,32(sp)
    800029cc:	ec26                	sd	s1,24(sp)
    800029ce:	e84a                	sd	s2,16(sp)
    800029d0:	e44e                	sd	s3,8(sp)
    800029d2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029d4:	00006597          	auipc	a1,0x6
    800029d8:	a9c58593          	addi	a1,a1,-1380 # 80008470 <etext+0x470>
    800029dc:	00014517          	auipc	a0,0x14
    800029e0:	48c50513          	addi	a0,a0,1164 # 80016e68 <itable>
    800029e4:	00004097          	auipc	ra,0x4
    800029e8:	910080e7          	jalr	-1776(ra) # 800062f4 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029ec:	00014497          	auipc	s1,0x14
    800029f0:	4a448493          	addi	s1,s1,1188 # 80016e90 <itable+0x28>
    800029f4:	00016997          	auipc	s3,0x16
    800029f8:	f2c98993          	addi	s3,s3,-212 # 80018920 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029fc:	00006917          	auipc	s2,0x6
    80002a00:	a7c90913          	addi	s2,s2,-1412 # 80008478 <etext+0x478>
    80002a04:	85ca                	mv	a1,s2
    80002a06:	8526                	mv	a0,s1
    80002a08:	00001097          	auipc	ra,0x1
    80002a0c:	e4c080e7          	jalr	-436(ra) # 80003854 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a10:	08848493          	addi	s1,s1,136
    80002a14:	ff3498e3          	bne	s1,s3,80002a04 <iinit+0x3e>
}
    80002a18:	70a2                	ld	ra,40(sp)
    80002a1a:	7402                	ld	s0,32(sp)
    80002a1c:	64e2                	ld	s1,24(sp)
    80002a1e:	6942                	ld	s2,16(sp)
    80002a20:	69a2                	ld	s3,8(sp)
    80002a22:	6145                	addi	sp,sp,48
    80002a24:	8082                	ret

0000000080002a26 <ialloc>:
{
    80002a26:	7139                	addi	sp,sp,-64
    80002a28:	fc06                	sd	ra,56(sp)
    80002a2a:	f822                	sd	s0,48(sp)
    80002a2c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a2e:	00014717          	auipc	a4,0x14
    80002a32:	42672703          	lw	a4,1062(a4) # 80016e54 <sb+0xc>
    80002a36:	4785                	li	a5,1
    80002a38:	06e7f463          	bgeu	a5,a4,80002aa0 <ialloc+0x7a>
    80002a3c:	f426                	sd	s1,40(sp)
    80002a3e:	f04a                	sd	s2,32(sp)
    80002a40:	ec4e                	sd	s3,24(sp)
    80002a42:	e852                	sd	s4,16(sp)
    80002a44:	e456                	sd	s5,8(sp)
    80002a46:	e05a                	sd	s6,0(sp)
    80002a48:	8aaa                	mv	s5,a0
    80002a4a:	8b2e                	mv	s6,a1
    80002a4c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a4e:	00014a17          	auipc	s4,0x14
    80002a52:	3faa0a13          	addi	s4,s4,1018 # 80016e48 <sb>
    80002a56:	00495593          	srli	a1,s2,0x4
    80002a5a:	018a2783          	lw	a5,24(s4)
    80002a5e:	9dbd                	addw	a1,a1,a5
    80002a60:	8556                	mv	a0,s5
    80002a62:	00000097          	auipc	ra,0x0
    80002a66:	934080e7          	jalr	-1740(ra) # 80002396 <bread>
    80002a6a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a6c:	05850993          	addi	s3,a0,88
    80002a70:	00f97793          	andi	a5,s2,15
    80002a74:	079a                	slli	a5,a5,0x6
    80002a76:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a78:	00099783          	lh	a5,0(s3)
    80002a7c:	cf9d                	beqz	a5,80002aba <ialloc+0x94>
    brelse(bp);
    80002a7e:	00000097          	auipc	ra,0x0
    80002a82:	a48080e7          	jalr	-1464(ra) # 800024c6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a86:	0905                	addi	s2,s2,1
    80002a88:	00ca2703          	lw	a4,12(s4)
    80002a8c:	0009079b          	sext.w	a5,s2
    80002a90:	fce7e3e3          	bltu	a5,a4,80002a56 <ialloc+0x30>
    80002a94:	74a2                	ld	s1,40(sp)
    80002a96:	7902                	ld	s2,32(sp)
    80002a98:	69e2                	ld	s3,24(sp)
    80002a9a:	6a42                	ld	s4,16(sp)
    80002a9c:	6aa2                	ld	s5,8(sp)
    80002a9e:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002aa0:	00006517          	auipc	a0,0x6
    80002aa4:	9e050513          	addi	a0,a0,-1568 # 80008480 <etext+0x480>
    80002aa8:	00003097          	auipc	ra,0x3
    80002aac:	3de080e7          	jalr	990(ra) # 80005e86 <printf>
  return 0;
    80002ab0:	4501                	li	a0,0
}
    80002ab2:	70e2                	ld	ra,56(sp)
    80002ab4:	7442                	ld	s0,48(sp)
    80002ab6:	6121                	addi	sp,sp,64
    80002ab8:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002aba:	04000613          	li	a2,64
    80002abe:	4581                	li	a1,0
    80002ac0:	854e                	mv	a0,s3
    80002ac2:	ffffd097          	auipc	ra,0xffffd
    80002ac6:	6b8080e7          	jalr	1720(ra) # 8000017a <memset>
      dip->type = type;
    80002aca:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ace:	8526                	mv	a0,s1
    80002ad0:	00001097          	auipc	ra,0x1
    80002ad4:	ca0080e7          	jalr	-864(ra) # 80003770 <log_write>
      brelse(bp);
    80002ad8:	8526                	mv	a0,s1
    80002ada:	00000097          	auipc	ra,0x0
    80002ade:	9ec080e7          	jalr	-1556(ra) # 800024c6 <brelse>
      return iget(dev, inum);
    80002ae2:	0009059b          	sext.w	a1,s2
    80002ae6:	8556                	mv	a0,s5
    80002ae8:	00000097          	auipc	ra,0x0
    80002aec:	da2080e7          	jalr	-606(ra) # 8000288a <iget>
    80002af0:	74a2                	ld	s1,40(sp)
    80002af2:	7902                	ld	s2,32(sp)
    80002af4:	69e2                	ld	s3,24(sp)
    80002af6:	6a42                	ld	s4,16(sp)
    80002af8:	6aa2                	ld	s5,8(sp)
    80002afa:	6b02                	ld	s6,0(sp)
    80002afc:	bf5d                	j	80002ab2 <ialloc+0x8c>

0000000080002afe <iupdate>:
{
    80002afe:	1101                	addi	sp,sp,-32
    80002b00:	ec06                	sd	ra,24(sp)
    80002b02:	e822                	sd	s0,16(sp)
    80002b04:	e426                	sd	s1,8(sp)
    80002b06:	e04a                	sd	s2,0(sp)
    80002b08:	1000                	addi	s0,sp,32
    80002b0a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b0c:	415c                	lw	a5,4(a0)
    80002b0e:	0047d79b          	srliw	a5,a5,0x4
    80002b12:	00014597          	auipc	a1,0x14
    80002b16:	34e5a583          	lw	a1,846(a1) # 80016e60 <sb+0x18>
    80002b1a:	9dbd                	addw	a1,a1,a5
    80002b1c:	4108                	lw	a0,0(a0)
    80002b1e:	00000097          	auipc	ra,0x0
    80002b22:	878080e7          	jalr	-1928(ra) # 80002396 <bread>
    80002b26:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b28:	05850793          	addi	a5,a0,88
    80002b2c:	40d8                	lw	a4,4(s1)
    80002b2e:	8b3d                	andi	a4,a4,15
    80002b30:	071a                	slli	a4,a4,0x6
    80002b32:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b34:	04449703          	lh	a4,68(s1)
    80002b38:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b3c:	04649703          	lh	a4,70(s1)
    80002b40:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b44:	04849703          	lh	a4,72(s1)
    80002b48:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b4c:	04a49703          	lh	a4,74(s1)
    80002b50:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b54:	44f8                	lw	a4,76(s1)
    80002b56:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b58:	03400613          	li	a2,52
    80002b5c:	05048593          	addi	a1,s1,80
    80002b60:	00c78513          	addi	a0,a5,12
    80002b64:	ffffd097          	auipc	ra,0xffffd
    80002b68:	672080e7          	jalr	1650(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b6c:	854a                	mv	a0,s2
    80002b6e:	00001097          	auipc	ra,0x1
    80002b72:	c02080e7          	jalr	-1022(ra) # 80003770 <log_write>
  brelse(bp);
    80002b76:	854a                	mv	a0,s2
    80002b78:	00000097          	auipc	ra,0x0
    80002b7c:	94e080e7          	jalr	-1714(ra) # 800024c6 <brelse>
}
    80002b80:	60e2                	ld	ra,24(sp)
    80002b82:	6442                	ld	s0,16(sp)
    80002b84:	64a2                	ld	s1,8(sp)
    80002b86:	6902                	ld	s2,0(sp)
    80002b88:	6105                	addi	sp,sp,32
    80002b8a:	8082                	ret

0000000080002b8c <idup>:
{
    80002b8c:	1101                	addi	sp,sp,-32
    80002b8e:	ec06                	sd	ra,24(sp)
    80002b90:	e822                	sd	s0,16(sp)
    80002b92:	e426                	sd	s1,8(sp)
    80002b94:	1000                	addi	s0,sp,32
    80002b96:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b98:	00014517          	auipc	a0,0x14
    80002b9c:	2d050513          	addi	a0,a0,720 # 80016e68 <itable>
    80002ba0:	00003097          	auipc	ra,0x3
    80002ba4:	7e4080e7          	jalr	2020(ra) # 80006384 <acquire>
  ip->ref++;
    80002ba8:	449c                	lw	a5,8(s1)
    80002baa:	2785                	addiw	a5,a5,1
    80002bac:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bae:	00014517          	auipc	a0,0x14
    80002bb2:	2ba50513          	addi	a0,a0,698 # 80016e68 <itable>
    80002bb6:	00004097          	auipc	ra,0x4
    80002bba:	882080e7          	jalr	-1918(ra) # 80006438 <release>
}
    80002bbe:	8526                	mv	a0,s1
    80002bc0:	60e2                	ld	ra,24(sp)
    80002bc2:	6442                	ld	s0,16(sp)
    80002bc4:	64a2                	ld	s1,8(sp)
    80002bc6:	6105                	addi	sp,sp,32
    80002bc8:	8082                	ret

0000000080002bca <ilock>:
{
    80002bca:	1101                	addi	sp,sp,-32
    80002bcc:	ec06                	sd	ra,24(sp)
    80002bce:	e822                	sd	s0,16(sp)
    80002bd0:	e426                	sd	s1,8(sp)
    80002bd2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bd4:	c10d                	beqz	a0,80002bf6 <ilock+0x2c>
    80002bd6:	84aa                	mv	s1,a0
    80002bd8:	451c                	lw	a5,8(a0)
    80002bda:	00f05e63          	blez	a5,80002bf6 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002bde:	0541                	addi	a0,a0,16
    80002be0:	00001097          	auipc	ra,0x1
    80002be4:	cae080e7          	jalr	-850(ra) # 8000388e <acquiresleep>
  if(ip->valid == 0){
    80002be8:	40bc                	lw	a5,64(s1)
    80002bea:	cf99                	beqz	a5,80002c08 <ilock+0x3e>
}
    80002bec:	60e2                	ld	ra,24(sp)
    80002bee:	6442                	ld	s0,16(sp)
    80002bf0:	64a2                	ld	s1,8(sp)
    80002bf2:	6105                	addi	sp,sp,32
    80002bf4:	8082                	ret
    80002bf6:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002bf8:	00006517          	auipc	a0,0x6
    80002bfc:	8a050513          	addi	a0,a0,-1888 # 80008498 <etext+0x498>
    80002c00:	00003097          	auipc	ra,0x3
    80002c04:	234080e7          	jalr	564(ra) # 80005e34 <panic>
    80002c08:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c0a:	40dc                	lw	a5,4(s1)
    80002c0c:	0047d79b          	srliw	a5,a5,0x4
    80002c10:	00014597          	auipc	a1,0x14
    80002c14:	2505a583          	lw	a1,592(a1) # 80016e60 <sb+0x18>
    80002c18:	9dbd                	addw	a1,a1,a5
    80002c1a:	4088                	lw	a0,0(s1)
    80002c1c:	fffff097          	auipc	ra,0xfffff
    80002c20:	77a080e7          	jalr	1914(ra) # 80002396 <bread>
    80002c24:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c26:	05850593          	addi	a1,a0,88
    80002c2a:	40dc                	lw	a5,4(s1)
    80002c2c:	8bbd                	andi	a5,a5,15
    80002c2e:	079a                	slli	a5,a5,0x6
    80002c30:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c32:	00059783          	lh	a5,0(a1)
    80002c36:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c3a:	00259783          	lh	a5,2(a1)
    80002c3e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c42:	00459783          	lh	a5,4(a1)
    80002c46:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c4a:	00659783          	lh	a5,6(a1)
    80002c4e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c52:	459c                	lw	a5,8(a1)
    80002c54:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c56:	03400613          	li	a2,52
    80002c5a:	05b1                	addi	a1,a1,12
    80002c5c:	05048513          	addi	a0,s1,80
    80002c60:	ffffd097          	auipc	ra,0xffffd
    80002c64:	576080e7          	jalr	1398(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c68:	854a                	mv	a0,s2
    80002c6a:	00000097          	auipc	ra,0x0
    80002c6e:	85c080e7          	jalr	-1956(ra) # 800024c6 <brelse>
    ip->valid = 1;
    80002c72:	4785                	li	a5,1
    80002c74:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c76:	04449783          	lh	a5,68(s1)
    80002c7a:	c399                	beqz	a5,80002c80 <ilock+0xb6>
    80002c7c:	6902                	ld	s2,0(sp)
    80002c7e:	b7bd                	j	80002bec <ilock+0x22>
      panic("ilock: no type");
    80002c80:	00006517          	auipc	a0,0x6
    80002c84:	82050513          	addi	a0,a0,-2016 # 800084a0 <etext+0x4a0>
    80002c88:	00003097          	auipc	ra,0x3
    80002c8c:	1ac080e7          	jalr	428(ra) # 80005e34 <panic>

0000000080002c90 <iunlock>:
{
    80002c90:	1101                	addi	sp,sp,-32
    80002c92:	ec06                	sd	ra,24(sp)
    80002c94:	e822                	sd	s0,16(sp)
    80002c96:	e426                	sd	s1,8(sp)
    80002c98:	e04a                	sd	s2,0(sp)
    80002c9a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c9c:	c905                	beqz	a0,80002ccc <iunlock+0x3c>
    80002c9e:	84aa                	mv	s1,a0
    80002ca0:	01050913          	addi	s2,a0,16
    80002ca4:	854a                	mv	a0,s2
    80002ca6:	00001097          	auipc	ra,0x1
    80002caa:	c82080e7          	jalr	-894(ra) # 80003928 <holdingsleep>
    80002cae:	cd19                	beqz	a0,80002ccc <iunlock+0x3c>
    80002cb0:	449c                	lw	a5,8(s1)
    80002cb2:	00f05d63          	blez	a5,80002ccc <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cb6:	854a                	mv	a0,s2
    80002cb8:	00001097          	auipc	ra,0x1
    80002cbc:	c2c080e7          	jalr	-980(ra) # 800038e4 <releasesleep>
}
    80002cc0:	60e2                	ld	ra,24(sp)
    80002cc2:	6442                	ld	s0,16(sp)
    80002cc4:	64a2                	ld	s1,8(sp)
    80002cc6:	6902                	ld	s2,0(sp)
    80002cc8:	6105                	addi	sp,sp,32
    80002cca:	8082                	ret
    panic("iunlock");
    80002ccc:	00005517          	auipc	a0,0x5
    80002cd0:	7e450513          	addi	a0,a0,2020 # 800084b0 <etext+0x4b0>
    80002cd4:	00003097          	auipc	ra,0x3
    80002cd8:	160080e7          	jalr	352(ra) # 80005e34 <panic>

0000000080002cdc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cdc:	7179                	addi	sp,sp,-48
    80002cde:	f406                	sd	ra,40(sp)
    80002ce0:	f022                	sd	s0,32(sp)
    80002ce2:	ec26                	sd	s1,24(sp)
    80002ce4:	e84a                	sd	s2,16(sp)
    80002ce6:	e44e                	sd	s3,8(sp)
    80002ce8:	1800                	addi	s0,sp,48
    80002cea:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cec:	05050493          	addi	s1,a0,80
    80002cf0:	08050913          	addi	s2,a0,128
    80002cf4:	a021                	j	80002cfc <itrunc+0x20>
    80002cf6:	0491                	addi	s1,s1,4
    80002cf8:	01248d63          	beq	s1,s2,80002d12 <itrunc+0x36>
    if(ip->addrs[i]){
    80002cfc:	408c                	lw	a1,0(s1)
    80002cfe:	dde5                	beqz	a1,80002cf6 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002d00:	0009a503          	lw	a0,0(s3)
    80002d04:	00000097          	auipc	ra,0x0
    80002d08:	8d6080e7          	jalr	-1834(ra) # 800025da <bfree>
      ip->addrs[i] = 0;
    80002d0c:	0004a023          	sw	zero,0(s1)
    80002d10:	b7dd                	j	80002cf6 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d12:	0809a583          	lw	a1,128(s3)
    80002d16:	ed99                	bnez	a1,80002d34 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d18:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d1c:	854e                	mv	a0,s3
    80002d1e:	00000097          	auipc	ra,0x0
    80002d22:	de0080e7          	jalr	-544(ra) # 80002afe <iupdate>
}
    80002d26:	70a2                	ld	ra,40(sp)
    80002d28:	7402                	ld	s0,32(sp)
    80002d2a:	64e2                	ld	s1,24(sp)
    80002d2c:	6942                	ld	s2,16(sp)
    80002d2e:	69a2                	ld	s3,8(sp)
    80002d30:	6145                	addi	sp,sp,48
    80002d32:	8082                	ret
    80002d34:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d36:	0009a503          	lw	a0,0(s3)
    80002d3a:	fffff097          	auipc	ra,0xfffff
    80002d3e:	65c080e7          	jalr	1628(ra) # 80002396 <bread>
    80002d42:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d44:	05850493          	addi	s1,a0,88
    80002d48:	45850913          	addi	s2,a0,1112
    80002d4c:	a021                	j	80002d54 <itrunc+0x78>
    80002d4e:	0491                	addi	s1,s1,4
    80002d50:	01248b63          	beq	s1,s2,80002d66 <itrunc+0x8a>
      if(a[j])
    80002d54:	408c                	lw	a1,0(s1)
    80002d56:	dde5                	beqz	a1,80002d4e <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002d58:	0009a503          	lw	a0,0(s3)
    80002d5c:	00000097          	auipc	ra,0x0
    80002d60:	87e080e7          	jalr	-1922(ra) # 800025da <bfree>
    80002d64:	b7ed                	j	80002d4e <itrunc+0x72>
    brelse(bp);
    80002d66:	8552                	mv	a0,s4
    80002d68:	fffff097          	auipc	ra,0xfffff
    80002d6c:	75e080e7          	jalr	1886(ra) # 800024c6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d70:	0809a583          	lw	a1,128(s3)
    80002d74:	0009a503          	lw	a0,0(s3)
    80002d78:	00000097          	auipc	ra,0x0
    80002d7c:	862080e7          	jalr	-1950(ra) # 800025da <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d80:	0809a023          	sw	zero,128(s3)
    80002d84:	6a02                	ld	s4,0(sp)
    80002d86:	bf49                	j	80002d18 <itrunc+0x3c>

0000000080002d88 <iput>:
{
    80002d88:	1101                	addi	sp,sp,-32
    80002d8a:	ec06                	sd	ra,24(sp)
    80002d8c:	e822                	sd	s0,16(sp)
    80002d8e:	e426                	sd	s1,8(sp)
    80002d90:	1000                	addi	s0,sp,32
    80002d92:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d94:	00014517          	auipc	a0,0x14
    80002d98:	0d450513          	addi	a0,a0,212 # 80016e68 <itable>
    80002d9c:	00003097          	auipc	ra,0x3
    80002da0:	5e8080e7          	jalr	1512(ra) # 80006384 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002da4:	4498                	lw	a4,8(s1)
    80002da6:	4785                	li	a5,1
    80002da8:	02f70263          	beq	a4,a5,80002dcc <iput+0x44>
  ip->ref--;
    80002dac:	449c                	lw	a5,8(s1)
    80002dae:	37fd                	addiw	a5,a5,-1
    80002db0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002db2:	00014517          	auipc	a0,0x14
    80002db6:	0b650513          	addi	a0,a0,182 # 80016e68 <itable>
    80002dba:	00003097          	auipc	ra,0x3
    80002dbe:	67e080e7          	jalr	1662(ra) # 80006438 <release>
}
    80002dc2:	60e2                	ld	ra,24(sp)
    80002dc4:	6442                	ld	s0,16(sp)
    80002dc6:	64a2                	ld	s1,8(sp)
    80002dc8:	6105                	addi	sp,sp,32
    80002dca:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dcc:	40bc                	lw	a5,64(s1)
    80002dce:	dff9                	beqz	a5,80002dac <iput+0x24>
    80002dd0:	04a49783          	lh	a5,74(s1)
    80002dd4:	ffe1                	bnez	a5,80002dac <iput+0x24>
    80002dd6:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002dd8:	01048913          	addi	s2,s1,16
    80002ddc:	854a                	mv	a0,s2
    80002dde:	00001097          	auipc	ra,0x1
    80002de2:	ab0080e7          	jalr	-1360(ra) # 8000388e <acquiresleep>
    release(&itable.lock);
    80002de6:	00014517          	auipc	a0,0x14
    80002dea:	08250513          	addi	a0,a0,130 # 80016e68 <itable>
    80002dee:	00003097          	auipc	ra,0x3
    80002df2:	64a080e7          	jalr	1610(ra) # 80006438 <release>
    itrunc(ip);
    80002df6:	8526                	mv	a0,s1
    80002df8:	00000097          	auipc	ra,0x0
    80002dfc:	ee4080e7          	jalr	-284(ra) # 80002cdc <itrunc>
    ip->type = 0;
    80002e00:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e04:	8526                	mv	a0,s1
    80002e06:	00000097          	auipc	ra,0x0
    80002e0a:	cf8080e7          	jalr	-776(ra) # 80002afe <iupdate>
    ip->valid = 0;
    80002e0e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e12:	854a                	mv	a0,s2
    80002e14:	00001097          	auipc	ra,0x1
    80002e18:	ad0080e7          	jalr	-1328(ra) # 800038e4 <releasesleep>
    acquire(&itable.lock);
    80002e1c:	00014517          	auipc	a0,0x14
    80002e20:	04c50513          	addi	a0,a0,76 # 80016e68 <itable>
    80002e24:	00003097          	auipc	ra,0x3
    80002e28:	560080e7          	jalr	1376(ra) # 80006384 <acquire>
    80002e2c:	6902                	ld	s2,0(sp)
    80002e2e:	bfbd                	j	80002dac <iput+0x24>

0000000080002e30 <iunlockput>:
{
    80002e30:	1101                	addi	sp,sp,-32
    80002e32:	ec06                	sd	ra,24(sp)
    80002e34:	e822                	sd	s0,16(sp)
    80002e36:	e426                	sd	s1,8(sp)
    80002e38:	1000                	addi	s0,sp,32
    80002e3a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e3c:	00000097          	auipc	ra,0x0
    80002e40:	e54080e7          	jalr	-428(ra) # 80002c90 <iunlock>
  iput(ip);
    80002e44:	8526                	mv	a0,s1
    80002e46:	00000097          	auipc	ra,0x0
    80002e4a:	f42080e7          	jalr	-190(ra) # 80002d88 <iput>
}
    80002e4e:	60e2                	ld	ra,24(sp)
    80002e50:	6442                	ld	s0,16(sp)
    80002e52:	64a2                	ld	s1,8(sp)
    80002e54:	6105                	addi	sp,sp,32
    80002e56:	8082                	ret

0000000080002e58 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e58:	1141                	addi	sp,sp,-16
    80002e5a:	e422                	sd	s0,8(sp)
    80002e5c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e5e:	411c                	lw	a5,0(a0)
    80002e60:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e62:	415c                	lw	a5,4(a0)
    80002e64:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e66:	04451783          	lh	a5,68(a0)
    80002e6a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e6e:	04a51783          	lh	a5,74(a0)
    80002e72:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e76:	04c56783          	lwu	a5,76(a0)
    80002e7a:	e99c                	sd	a5,16(a1)
}
    80002e7c:	6422                	ld	s0,8(sp)
    80002e7e:	0141                	addi	sp,sp,16
    80002e80:	8082                	ret

0000000080002e82 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e82:	457c                	lw	a5,76(a0)
    80002e84:	10d7e563          	bltu	a5,a3,80002f8e <readi+0x10c>
{
    80002e88:	7159                	addi	sp,sp,-112
    80002e8a:	f486                	sd	ra,104(sp)
    80002e8c:	f0a2                	sd	s0,96(sp)
    80002e8e:	eca6                	sd	s1,88(sp)
    80002e90:	e0d2                	sd	s4,64(sp)
    80002e92:	fc56                	sd	s5,56(sp)
    80002e94:	f85a                	sd	s6,48(sp)
    80002e96:	f45e                	sd	s7,40(sp)
    80002e98:	1880                	addi	s0,sp,112
    80002e9a:	8b2a                	mv	s6,a0
    80002e9c:	8bae                	mv	s7,a1
    80002e9e:	8a32                	mv	s4,a2
    80002ea0:	84b6                	mv	s1,a3
    80002ea2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002ea4:	9f35                	addw	a4,a4,a3
    return 0;
    80002ea6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ea8:	0cd76a63          	bltu	a4,a3,80002f7c <readi+0xfa>
    80002eac:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002eae:	00e7f463          	bgeu	a5,a4,80002eb6 <readi+0x34>
    n = ip->size - off;
    80002eb2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eb6:	0a0a8963          	beqz	s5,80002f68 <readi+0xe6>
    80002eba:	e8ca                	sd	s2,80(sp)
    80002ebc:	f062                	sd	s8,32(sp)
    80002ebe:	ec66                	sd	s9,24(sp)
    80002ec0:	e86a                	sd	s10,16(sp)
    80002ec2:	e46e                	sd	s11,8(sp)
    80002ec4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ec6:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002eca:	5c7d                	li	s8,-1
    80002ecc:	a82d                	j	80002f06 <readi+0x84>
    80002ece:	020d1d93          	slli	s11,s10,0x20
    80002ed2:	020ddd93          	srli	s11,s11,0x20
    80002ed6:	05890613          	addi	a2,s2,88
    80002eda:	86ee                	mv	a3,s11
    80002edc:	963a                	add	a2,a2,a4
    80002ede:	85d2                	mv	a1,s4
    80002ee0:	855e                	mv	a0,s7
    80002ee2:	fffff097          	auipc	ra,0xfffff
    80002ee6:	ada080e7          	jalr	-1318(ra) # 800019bc <either_copyout>
    80002eea:	05850d63          	beq	a0,s8,80002f44 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002eee:	854a                	mv	a0,s2
    80002ef0:	fffff097          	auipc	ra,0xfffff
    80002ef4:	5d6080e7          	jalr	1494(ra) # 800024c6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ef8:	013d09bb          	addw	s3,s10,s3
    80002efc:	009d04bb          	addw	s1,s10,s1
    80002f00:	9a6e                	add	s4,s4,s11
    80002f02:	0559fd63          	bgeu	s3,s5,80002f5c <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80002f06:	00a4d59b          	srliw	a1,s1,0xa
    80002f0a:	855a                	mv	a0,s6
    80002f0c:	00000097          	auipc	ra,0x0
    80002f10:	88e080e7          	jalr	-1906(ra) # 8000279a <bmap>
    80002f14:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f18:	c9b1                	beqz	a1,80002f6c <readi+0xea>
    bp = bread(ip->dev, addr);
    80002f1a:	000b2503          	lw	a0,0(s6)
    80002f1e:	fffff097          	auipc	ra,0xfffff
    80002f22:	478080e7          	jalr	1144(ra) # 80002396 <bread>
    80002f26:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f28:	3ff4f713          	andi	a4,s1,1023
    80002f2c:	40ec87bb          	subw	a5,s9,a4
    80002f30:	413a86bb          	subw	a3,s5,s3
    80002f34:	8d3e                	mv	s10,a5
    80002f36:	2781                	sext.w	a5,a5
    80002f38:	0006861b          	sext.w	a2,a3
    80002f3c:	f8f679e3          	bgeu	a2,a5,80002ece <readi+0x4c>
    80002f40:	8d36                	mv	s10,a3
    80002f42:	b771                	j	80002ece <readi+0x4c>
      brelse(bp);
    80002f44:	854a                	mv	a0,s2
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	580080e7          	jalr	1408(ra) # 800024c6 <brelse>
      tot = -1;
    80002f4e:	59fd                	li	s3,-1
      break;
    80002f50:	6946                	ld	s2,80(sp)
    80002f52:	7c02                	ld	s8,32(sp)
    80002f54:	6ce2                	ld	s9,24(sp)
    80002f56:	6d42                	ld	s10,16(sp)
    80002f58:	6da2                	ld	s11,8(sp)
    80002f5a:	a831                	j	80002f76 <readi+0xf4>
    80002f5c:	6946                	ld	s2,80(sp)
    80002f5e:	7c02                	ld	s8,32(sp)
    80002f60:	6ce2                	ld	s9,24(sp)
    80002f62:	6d42                	ld	s10,16(sp)
    80002f64:	6da2                	ld	s11,8(sp)
    80002f66:	a801                	j	80002f76 <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f68:	89d6                	mv	s3,s5
    80002f6a:	a031                	j	80002f76 <readi+0xf4>
    80002f6c:	6946                	ld	s2,80(sp)
    80002f6e:	7c02                	ld	s8,32(sp)
    80002f70:	6ce2                	ld	s9,24(sp)
    80002f72:	6d42                	ld	s10,16(sp)
    80002f74:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002f76:	0009851b          	sext.w	a0,s3
    80002f7a:	69a6                	ld	s3,72(sp)
}
    80002f7c:	70a6                	ld	ra,104(sp)
    80002f7e:	7406                	ld	s0,96(sp)
    80002f80:	64e6                	ld	s1,88(sp)
    80002f82:	6a06                	ld	s4,64(sp)
    80002f84:	7ae2                	ld	s5,56(sp)
    80002f86:	7b42                	ld	s6,48(sp)
    80002f88:	7ba2                	ld	s7,40(sp)
    80002f8a:	6165                	addi	sp,sp,112
    80002f8c:	8082                	ret
    return 0;
    80002f8e:	4501                	li	a0,0
}
    80002f90:	8082                	ret

0000000080002f92 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f92:	457c                	lw	a5,76(a0)
    80002f94:	10d7ee63          	bltu	a5,a3,800030b0 <writei+0x11e>
{
    80002f98:	7159                	addi	sp,sp,-112
    80002f9a:	f486                	sd	ra,104(sp)
    80002f9c:	f0a2                	sd	s0,96(sp)
    80002f9e:	e8ca                	sd	s2,80(sp)
    80002fa0:	e0d2                	sd	s4,64(sp)
    80002fa2:	fc56                	sd	s5,56(sp)
    80002fa4:	f85a                	sd	s6,48(sp)
    80002fa6:	f45e                	sd	s7,40(sp)
    80002fa8:	1880                	addi	s0,sp,112
    80002faa:	8aaa                	mv	s5,a0
    80002fac:	8bae                	mv	s7,a1
    80002fae:	8a32                	mv	s4,a2
    80002fb0:	8936                	mv	s2,a3
    80002fb2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fb4:	00e687bb          	addw	a5,a3,a4
    80002fb8:	0ed7ee63          	bltu	a5,a3,800030b4 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fbc:	00043737          	lui	a4,0x43
    80002fc0:	0ef76c63          	bltu	a4,a5,800030b8 <writei+0x126>
    80002fc4:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fc6:	0c0b0d63          	beqz	s6,800030a0 <writei+0x10e>
    80002fca:	eca6                	sd	s1,88(sp)
    80002fcc:	f062                	sd	s8,32(sp)
    80002fce:	ec66                	sd	s9,24(sp)
    80002fd0:	e86a                	sd	s10,16(sp)
    80002fd2:	e46e                	sd	s11,8(sp)
    80002fd4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fd6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fda:	5c7d                	li	s8,-1
    80002fdc:	a091                	j	80003020 <writei+0x8e>
    80002fde:	020d1d93          	slli	s11,s10,0x20
    80002fe2:	020ddd93          	srli	s11,s11,0x20
    80002fe6:	05848513          	addi	a0,s1,88
    80002fea:	86ee                	mv	a3,s11
    80002fec:	8652                	mv	a2,s4
    80002fee:	85de                	mv	a1,s7
    80002ff0:	953a                	add	a0,a0,a4
    80002ff2:	fffff097          	auipc	ra,0xfffff
    80002ff6:	a20080e7          	jalr	-1504(ra) # 80001a12 <either_copyin>
    80002ffa:	07850263          	beq	a0,s8,8000305e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ffe:	8526                	mv	a0,s1
    80003000:	00000097          	auipc	ra,0x0
    80003004:	770080e7          	jalr	1904(ra) # 80003770 <log_write>
    brelse(bp);
    80003008:	8526                	mv	a0,s1
    8000300a:	fffff097          	auipc	ra,0xfffff
    8000300e:	4bc080e7          	jalr	1212(ra) # 800024c6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003012:	013d09bb          	addw	s3,s10,s3
    80003016:	012d093b          	addw	s2,s10,s2
    8000301a:	9a6e                	add	s4,s4,s11
    8000301c:	0569f663          	bgeu	s3,s6,80003068 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003020:	00a9559b          	srliw	a1,s2,0xa
    80003024:	8556                	mv	a0,s5
    80003026:	fffff097          	auipc	ra,0xfffff
    8000302a:	774080e7          	jalr	1908(ra) # 8000279a <bmap>
    8000302e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003032:	c99d                	beqz	a1,80003068 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003034:	000aa503          	lw	a0,0(s5)
    80003038:	fffff097          	auipc	ra,0xfffff
    8000303c:	35e080e7          	jalr	862(ra) # 80002396 <bread>
    80003040:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003042:	3ff97713          	andi	a4,s2,1023
    80003046:	40ec87bb          	subw	a5,s9,a4
    8000304a:	413b06bb          	subw	a3,s6,s3
    8000304e:	8d3e                	mv	s10,a5
    80003050:	2781                	sext.w	a5,a5
    80003052:	0006861b          	sext.w	a2,a3
    80003056:	f8f674e3          	bgeu	a2,a5,80002fde <writei+0x4c>
    8000305a:	8d36                	mv	s10,a3
    8000305c:	b749                	j	80002fde <writei+0x4c>
      brelse(bp);
    8000305e:	8526                	mv	a0,s1
    80003060:	fffff097          	auipc	ra,0xfffff
    80003064:	466080e7          	jalr	1126(ra) # 800024c6 <brelse>
  }

  if(off > ip->size)
    80003068:	04caa783          	lw	a5,76(s5)
    8000306c:	0327fc63          	bgeu	a5,s2,800030a4 <writei+0x112>
    ip->size = off;
    80003070:	052aa623          	sw	s2,76(s5)
    80003074:	64e6                	ld	s1,88(sp)
    80003076:	7c02                	ld	s8,32(sp)
    80003078:	6ce2                	ld	s9,24(sp)
    8000307a:	6d42                	ld	s10,16(sp)
    8000307c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000307e:	8556                	mv	a0,s5
    80003080:	00000097          	auipc	ra,0x0
    80003084:	a7e080e7          	jalr	-1410(ra) # 80002afe <iupdate>

  return tot;
    80003088:	0009851b          	sext.w	a0,s3
    8000308c:	69a6                	ld	s3,72(sp)
}
    8000308e:	70a6                	ld	ra,104(sp)
    80003090:	7406                	ld	s0,96(sp)
    80003092:	6946                	ld	s2,80(sp)
    80003094:	6a06                	ld	s4,64(sp)
    80003096:	7ae2                	ld	s5,56(sp)
    80003098:	7b42                	ld	s6,48(sp)
    8000309a:	7ba2                	ld	s7,40(sp)
    8000309c:	6165                	addi	sp,sp,112
    8000309e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030a0:	89da                	mv	s3,s6
    800030a2:	bff1                	j	8000307e <writei+0xec>
    800030a4:	64e6                	ld	s1,88(sp)
    800030a6:	7c02                	ld	s8,32(sp)
    800030a8:	6ce2                	ld	s9,24(sp)
    800030aa:	6d42                	ld	s10,16(sp)
    800030ac:	6da2                	ld	s11,8(sp)
    800030ae:	bfc1                	j	8000307e <writei+0xec>
    return -1;
    800030b0:	557d                	li	a0,-1
}
    800030b2:	8082                	ret
    return -1;
    800030b4:	557d                	li	a0,-1
    800030b6:	bfe1                	j	8000308e <writei+0xfc>
    return -1;
    800030b8:	557d                	li	a0,-1
    800030ba:	bfd1                	j	8000308e <writei+0xfc>

00000000800030bc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030bc:	1141                	addi	sp,sp,-16
    800030be:	e406                	sd	ra,8(sp)
    800030c0:	e022                	sd	s0,0(sp)
    800030c2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030c4:	4639                	li	a2,14
    800030c6:	ffffd097          	auipc	ra,0xffffd
    800030ca:	184080e7          	jalr	388(ra) # 8000024a <strncmp>
}
    800030ce:	60a2                	ld	ra,8(sp)
    800030d0:	6402                	ld	s0,0(sp)
    800030d2:	0141                	addi	sp,sp,16
    800030d4:	8082                	ret

00000000800030d6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030d6:	7139                	addi	sp,sp,-64
    800030d8:	fc06                	sd	ra,56(sp)
    800030da:	f822                	sd	s0,48(sp)
    800030dc:	f426                	sd	s1,40(sp)
    800030de:	f04a                	sd	s2,32(sp)
    800030e0:	ec4e                	sd	s3,24(sp)
    800030e2:	e852                	sd	s4,16(sp)
    800030e4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030e6:	04451703          	lh	a4,68(a0)
    800030ea:	4785                	li	a5,1
    800030ec:	00f71a63          	bne	a4,a5,80003100 <dirlookup+0x2a>
    800030f0:	892a                	mv	s2,a0
    800030f2:	89ae                	mv	s3,a1
    800030f4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030f6:	457c                	lw	a5,76(a0)
    800030f8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030fa:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030fc:	e79d                	bnez	a5,8000312a <dirlookup+0x54>
    800030fe:	a8a5                	j	80003176 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003100:	00005517          	auipc	a0,0x5
    80003104:	3b850513          	addi	a0,a0,952 # 800084b8 <etext+0x4b8>
    80003108:	00003097          	auipc	ra,0x3
    8000310c:	d2c080e7          	jalr	-724(ra) # 80005e34 <panic>
      panic("dirlookup read");
    80003110:	00005517          	auipc	a0,0x5
    80003114:	3c050513          	addi	a0,a0,960 # 800084d0 <etext+0x4d0>
    80003118:	00003097          	auipc	ra,0x3
    8000311c:	d1c080e7          	jalr	-740(ra) # 80005e34 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003120:	24c1                	addiw	s1,s1,16
    80003122:	04c92783          	lw	a5,76(s2)
    80003126:	04f4f763          	bgeu	s1,a5,80003174 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000312a:	4741                	li	a4,16
    8000312c:	86a6                	mv	a3,s1
    8000312e:	fc040613          	addi	a2,s0,-64
    80003132:	4581                	li	a1,0
    80003134:	854a                	mv	a0,s2
    80003136:	00000097          	auipc	ra,0x0
    8000313a:	d4c080e7          	jalr	-692(ra) # 80002e82 <readi>
    8000313e:	47c1                	li	a5,16
    80003140:	fcf518e3          	bne	a0,a5,80003110 <dirlookup+0x3a>
    if(de.inum == 0)
    80003144:	fc045783          	lhu	a5,-64(s0)
    80003148:	dfe1                	beqz	a5,80003120 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000314a:	fc240593          	addi	a1,s0,-62
    8000314e:	854e                	mv	a0,s3
    80003150:	00000097          	auipc	ra,0x0
    80003154:	f6c080e7          	jalr	-148(ra) # 800030bc <namecmp>
    80003158:	f561                	bnez	a0,80003120 <dirlookup+0x4a>
      if(poff)
    8000315a:	000a0463          	beqz	s4,80003162 <dirlookup+0x8c>
        *poff = off;
    8000315e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003162:	fc045583          	lhu	a1,-64(s0)
    80003166:	00092503          	lw	a0,0(s2)
    8000316a:	fffff097          	auipc	ra,0xfffff
    8000316e:	720080e7          	jalr	1824(ra) # 8000288a <iget>
    80003172:	a011                	j	80003176 <dirlookup+0xa0>
  return 0;
    80003174:	4501                	li	a0,0
}
    80003176:	70e2                	ld	ra,56(sp)
    80003178:	7442                	ld	s0,48(sp)
    8000317a:	74a2                	ld	s1,40(sp)
    8000317c:	7902                	ld	s2,32(sp)
    8000317e:	69e2                	ld	s3,24(sp)
    80003180:	6a42                	ld	s4,16(sp)
    80003182:	6121                	addi	sp,sp,64
    80003184:	8082                	ret

0000000080003186 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003186:	711d                	addi	sp,sp,-96
    80003188:	ec86                	sd	ra,88(sp)
    8000318a:	e8a2                	sd	s0,80(sp)
    8000318c:	e4a6                	sd	s1,72(sp)
    8000318e:	e0ca                	sd	s2,64(sp)
    80003190:	fc4e                	sd	s3,56(sp)
    80003192:	f852                	sd	s4,48(sp)
    80003194:	f456                	sd	s5,40(sp)
    80003196:	f05a                	sd	s6,32(sp)
    80003198:	ec5e                	sd	s7,24(sp)
    8000319a:	e862                	sd	s8,16(sp)
    8000319c:	e466                	sd	s9,8(sp)
    8000319e:	1080                	addi	s0,sp,96
    800031a0:	84aa                	mv	s1,a0
    800031a2:	8b2e                	mv	s6,a1
    800031a4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031a6:	00054703          	lbu	a4,0(a0)
    800031aa:	02f00793          	li	a5,47
    800031ae:	02f70263          	beq	a4,a5,800031d2 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031b2:	ffffe097          	auipc	ra,0xffffe
    800031b6:	d54080e7          	jalr	-684(ra) # 80000f06 <myproc>
    800031ba:	15053503          	ld	a0,336(a0)
    800031be:	00000097          	auipc	ra,0x0
    800031c2:	9ce080e7          	jalr	-1586(ra) # 80002b8c <idup>
    800031c6:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031c8:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031cc:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031ce:	4b85                	li	s7,1
    800031d0:	a875                	j	8000328c <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800031d2:	4585                	li	a1,1
    800031d4:	4505                	li	a0,1
    800031d6:	fffff097          	auipc	ra,0xfffff
    800031da:	6b4080e7          	jalr	1716(ra) # 8000288a <iget>
    800031de:	8a2a                	mv	s4,a0
    800031e0:	b7e5                	j	800031c8 <namex+0x42>
      iunlockput(ip);
    800031e2:	8552                	mv	a0,s4
    800031e4:	00000097          	auipc	ra,0x0
    800031e8:	c4c080e7          	jalr	-948(ra) # 80002e30 <iunlockput>
      return 0;
    800031ec:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031ee:	8552                	mv	a0,s4
    800031f0:	60e6                	ld	ra,88(sp)
    800031f2:	6446                	ld	s0,80(sp)
    800031f4:	64a6                	ld	s1,72(sp)
    800031f6:	6906                	ld	s2,64(sp)
    800031f8:	79e2                	ld	s3,56(sp)
    800031fa:	7a42                	ld	s4,48(sp)
    800031fc:	7aa2                	ld	s5,40(sp)
    800031fe:	7b02                	ld	s6,32(sp)
    80003200:	6be2                	ld	s7,24(sp)
    80003202:	6c42                	ld	s8,16(sp)
    80003204:	6ca2                	ld	s9,8(sp)
    80003206:	6125                	addi	sp,sp,96
    80003208:	8082                	ret
      iunlock(ip);
    8000320a:	8552                	mv	a0,s4
    8000320c:	00000097          	auipc	ra,0x0
    80003210:	a84080e7          	jalr	-1404(ra) # 80002c90 <iunlock>
      return ip;
    80003214:	bfe9                	j	800031ee <namex+0x68>
      iunlockput(ip);
    80003216:	8552                	mv	a0,s4
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	c18080e7          	jalr	-1000(ra) # 80002e30 <iunlockput>
      return 0;
    80003220:	8a4e                	mv	s4,s3
    80003222:	b7f1                	j	800031ee <namex+0x68>
  len = path - s;
    80003224:	40998633          	sub	a2,s3,s1
    80003228:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000322c:	099c5863          	bge	s8,s9,800032bc <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003230:	4639                	li	a2,14
    80003232:	85a6                	mv	a1,s1
    80003234:	8556                	mv	a0,s5
    80003236:	ffffd097          	auipc	ra,0xffffd
    8000323a:	fa0080e7          	jalr	-96(ra) # 800001d6 <memmove>
    8000323e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003240:	0004c783          	lbu	a5,0(s1)
    80003244:	01279763          	bne	a5,s2,80003252 <namex+0xcc>
    path++;
    80003248:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000324a:	0004c783          	lbu	a5,0(s1)
    8000324e:	ff278de3          	beq	a5,s2,80003248 <namex+0xc2>
    ilock(ip);
    80003252:	8552                	mv	a0,s4
    80003254:	00000097          	auipc	ra,0x0
    80003258:	976080e7          	jalr	-1674(ra) # 80002bca <ilock>
    if(ip->type != T_DIR){
    8000325c:	044a1783          	lh	a5,68(s4)
    80003260:	f97791e3          	bne	a5,s7,800031e2 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003264:	000b0563          	beqz	s6,8000326e <namex+0xe8>
    80003268:	0004c783          	lbu	a5,0(s1)
    8000326c:	dfd9                	beqz	a5,8000320a <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000326e:	4601                	li	a2,0
    80003270:	85d6                	mv	a1,s5
    80003272:	8552                	mv	a0,s4
    80003274:	00000097          	auipc	ra,0x0
    80003278:	e62080e7          	jalr	-414(ra) # 800030d6 <dirlookup>
    8000327c:	89aa                	mv	s3,a0
    8000327e:	dd41                	beqz	a0,80003216 <namex+0x90>
    iunlockput(ip);
    80003280:	8552                	mv	a0,s4
    80003282:	00000097          	auipc	ra,0x0
    80003286:	bae080e7          	jalr	-1106(ra) # 80002e30 <iunlockput>
    ip = next;
    8000328a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000328c:	0004c783          	lbu	a5,0(s1)
    80003290:	01279763          	bne	a5,s2,8000329e <namex+0x118>
    path++;
    80003294:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003296:	0004c783          	lbu	a5,0(s1)
    8000329a:	ff278de3          	beq	a5,s2,80003294 <namex+0x10e>
  if(*path == 0)
    8000329e:	cb9d                	beqz	a5,800032d4 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032a0:	0004c783          	lbu	a5,0(s1)
    800032a4:	89a6                	mv	s3,s1
  len = path - s;
    800032a6:	4c81                	li	s9,0
    800032a8:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032aa:	01278963          	beq	a5,s2,800032bc <namex+0x136>
    800032ae:	dbbd                	beqz	a5,80003224 <namex+0x9e>
    path++;
    800032b0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032b2:	0009c783          	lbu	a5,0(s3)
    800032b6:	ff279ce3          	bne	a5,s2,800032ae <namex+0x128>
    800032ba:	b7ad                	j	80003224 <namex+0x9e>
    memmove(name, s, len);
    800032bc:	2601                	sext.w	a2,a2
    800032be:	85a6                	mv	a1,s1
    800032c0:	8556                	mv	a0,s5
    800032c2:	ffffd097          	auipc	ra,0xffffd
    800032c6:	f14080e7          	jalr	-236(ra) # 800001d6 <memmove>
    name[len] = 0;
    800032ca:	9cd6                	add	s9,s9,s5
    800032cc:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800032d0:	84ce                	mv	s1,s3
    800032d2:	b7bd                	j	80003240 <namex+0xba>
  if(nameiparent){
    800032d4:	f00b0de3          	beqz	s6,800031ee <namex+0x68>
    iput(ip);
    800032d8:	8552                	mv	a0,s4
    800032da:	00000097          	auipc	ra,0x0
    800032de:	aae080e7          	jalr	-1362(ra) # 80002d88 <iput>
    return 0;
    800032e2:	4a01                	li	s4,0
    800032e4:	b729                	j	800031ee <namex+0x68>

00000000800032e6 <dirlink>:
{
    800032e6:	7139                	addi	sp,sp,-64
    800032e8:	fc06                	sd	ra,56(sp)
    800032ea:	f822                	sd	s0,48(sp)
    800032ec:	f04a                	sd	s2,32(sp)
    800032ee:	ec4e                	sd	s3,24(sp)
    800032f0:	e852                	sd	s4,16(sp)
    800032f2:	0080                	addi	s0,sp,64
    800032f4:	892a                	mv	s2,a0
    800032f6:	8a2e                	mv	s4,a1
    800032f8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032fa:	4601                	li	a2,0
    800032fc:	00000097          	auipc	ra,0x0
    80003300:	dda080e7          	jalr	-550(ra) # 800030d6 <dirlookup>
    80003304:	ed25                	bnez	a0,8000337c <dirlink+0x96>
    80003306:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003308:	04c92483          	lw	s1,76(s2)
    8000330c:	c49d                	beqz	s1,8000333a <dirlink+0x54>
    8000330e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003310:	4741                	li	a4,16
    80003312:	86a6                	mv	a3,s1
    80003314:	fc040613          	addi	a2,s0,-64
    80003318:	4581                	li	a1,0
    8000331a:	854a                	mv	a0,s2
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	b66080e7          	jalr	-1178(ra) # 80002e82 <readi>
    80003324:	47c1                	li	a5,16
    80003326:	06f51163          	bne	a0,a5,80003388 <dirlink+0xa2>
    if(de.inum == 0)
    8000332a:	fc045783          	lhu	a5,-64(s0)
    8000332e:	c791                	beqz	a5,8000333a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003330:	24c1                	addiw	s1,s1,16
    80003332:	04c92783          	lw	a5,76(s2)
    80003336:	fcf4ede3          	bltu	s1,a5,80003310 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000333a:	4639                	li	a2,14
    8000333c:	85d2                	mv	a1,s4
    8000333e:	fc240513          	addi	a0,s0,-62
    80003342:	ffffd097          	auipc	ra,0xffffd
    80003346:	f3e080e7          	jalr	-194(ra) # 80000280 <strncpy>
  de.inum = inum;
    8000334a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000334e:	4741                	li	a4,16
    80003350:	86a6                	mv	a3,s1
    80003352:	fc040613          	addi	a2,s0,-64
    80003356:	4581                	li	a1,0
    80003358:	854a                	mv	a0,s2
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	c38080e7          	jalr	-968(ra) # 80002f92 <writei>
    80003362:	1541                	addi	a0,a0,-16
    80003364:	00a03533          	snez	a0,a0
    80003368:	40a00533          	neg	a0,a0
    8000336c:	74a2                	ld	s1,40(sp)
}
    8000336e:	70e2                	ld	ra,56(sp)
    80003370:	7442                	ld	s0,48(sp)
    80003372:	7902                	ld	s2,32(sp)
    80003374:	69e2                	ld	s3,24(sp)
    80003376:	6a42                	ld	s4,16(sp)
    80003378:	6121                	addi	sp,sp,64
    8000337a:	8082                	ret
    iput(ip);
    8000337c:	00000097          	auipc	ra,0x0
    80003380:	a0c080e7          	jalr	-1524(ra) # 80002d88 <iput>
    return -1;
    80003384:	557d                	li	a0,-1
    80003386:	b7e5                	j	8000336e <dirlink+0x88>
      panic("dirlink read");
    80003388:	00005517          	auipc	a0,0x5
    8000338c:	15850513          	addi	a0,a0,344 # 800084e0 <etext+0x4e0>
    80003390:	00003097          	auipc	ra,0x3
    80003394:	aa4080e7          	jalr	-1372(ra) # 80005e34 <panic>

0000000080003398 <namei>:

struct inode*
namei(char *path)
{
    80003398:	1101                	addi	sp,sp,-32
    8000339a:	ec06                	sd	ra,24(sp)
    8000339c:	e822                	sd	s0,16(sp)
    8000339e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033a0:	fe040613          	addi	a2,s0,-32
    800033a4:	4581                	li	a1,0
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	de0080e7          	jalr	-544(ra) # 80003186 <namex>
}
    800033ae:	60e2                	ld	ra,24(sp)
    800033b0:	6442                	ld	s0,16(sp)
    800033b2:	6105                	addi	sp,sp,32
    800033b4:	8082                	ret

00000000800033b6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033b6:	1141                	addi	sp,sp,-16
    800033b8:	e406                	sd	ra,8(sp)
    800033ba:	e022                	sd	s0,0(sp)
    800033bc:	0800                	addi	s0,sp,16
    800033be:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033c0:	4585                	li	a1,1
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	dc4080e7          	jalr	-572(ra) # 80003186 <namex>
}
    800033ca:	60a2                	ld	ra,8(sp)
    800033cc:	6402                	ld	s0,0(sp)
    800033ce:	0141                	addi	sp,sp,16
    800033d0:	8082                	ret

00000000800033d2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033d2:	1101                	addi	sp,sp,-32
    800033d4:	ec06                	sd	ra,24(sp)
    800033d6:	e822                	sd	s0,16(sp)
    800033d8:	e426                	sd	s1,8(sp)
    800033da:	e04a                	sd	s2,0(sp)
    800033dc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033de:	00015917          	auipc	s2,0x15
    800033e2:	53290913          	addi	s2,s2,1330 # 80018910 <log>
    800033e6:	01892583          	lw	a1,24(s2)
    800033ea:	02892503          	lw	a0,40(s2)
    800033ee:	fffff097          	auipc	ra,0xfffff
    800033f2:	fa8080e7          	jalr	-88(ra) # 80002396 <bread>
    800033f6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033f8:	02c92603          	lw	a2,44(s2)
    800033fc:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033fe:	00c05f63          	blez	a2,8000341c <write_head+0x4a>
    80003402:	00015717          	auipc	a4,0x15
    80003406:	53e70713          	addi	a4,a4,1342 # 80018940 <log+0x30>
    8000340a:	87aa                	mv	a5,a0
    8000340c:	060a                	slli	a2,a2,0x2
    8000340e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003410:	4314                	lw	a3,0(a4)
    80003412:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003414:	0711                	addi	a4,a4,4
    80003416:	0791                	addi	a5,a5,4
    80003418:	fec79ce3          	bne	a5,a2,80003410 <write_head+0x3e>
  }
  bwrite(buf);
    8000341c:	8526                	mv	a0,s1
    8000341e:	fffff097          	auipc	ra,0xfffff
    80003422:	06a080e7          	jalr	106(ra) # 80002488 <bwrite>
  brelse(buf);
    80003426:	8526                	mv	a0,s1
    80003428:	fffff097          	auipc	ra,0xfffff
    8000342c:	09e080e7          	jalr	158(ra) # 800024c6 <brelse>
}
    80003430:	60e2                	ld	ra,24(sp)
    80003432:	6442                	ld	s0,16(sp)
    80003434:	64a2                	ld	s1,8(sp)
    80003436:	6902                	ld	s2,0(sp)
    80003438:	6105                	addi	sp,sp,32
    8000343a:	8082                	ret

000000008000343c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000343c:	00015797          	auipc	a5,0x15
    80003440:	5007a783          	lw	a5,1280(a5) # 8001893c <log+0x2c>
    80003444:	0af05d63          	blez	a5,800034fe <install_trans+0xc2>
{
    80003448:	7139                	addi	sp,sp,-64
    8000344a:	fc06                	sd	ra,56(sp)
    8000344c:	f822                	sd	s0,48(sp)
    8000344e:	f426                	sd	s1,40(sp)
    80003450:	f04a                	sd	s2,32(sp)
    80003452:	ec4e                	sd	s3,24(sp)
    80003454:	e852                	sd	s4,16(sp)
    80003456:	e456                	sd	s5,8(sp)
    80003458:	e05a                	sd	s6,0(sp)
    8000345a:	0080                	addi	s0,sp,64
    8000345c:	8b2a                	mv	s6,a0
    8000345e:	00015a97          	auipc	s5,0x15
    80003462:	4e2a8a93          	addi	s5,s5,1250 # 80018940 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003466:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003468:	00015997          	auipc	s3,0x15
    8000346c:	4a898993          	addi	s3,s3,1192 # 80018910 <log>
    80003470:	a00d                	j	80003492 <install_trans+0x56>
    brelse(lbuf);
    80003472:	854a                	mv	a0,s2
    80003474:	fffff097          	auipc	ra,0xfffff
    80003478:	052080e7          	jalr	82(ra) # 800024c6 <brelse>
    brelse(dbuf);
    8000347c:	8526                	mv	a0,s1
    8000347e:	fffff097          	auipc	ra,0xfffff
    80003482:	048080e7          	jalr	72(ra) # 800024c6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003486:	2a05                	addiw	s4,s4,1
    80003488:	0a91                	addi	s5,s5,4
    8000348a:	02c9a783          	lw	a5,44(s3)
    8000348e:	04fa5e63          	bge	s4,a5,800034ea <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003492:	0189a583          	lw	a1,24(s3)
    80003496:	014585bb          	addw	a1,a1,s4
    8000349a:	2585                	addiw	a1,a1,1
    8000349c:	0289a503          	lw	a0,40(s3)
    800034a0:	fffff097          	auipc	ra,0xfffff
    800034a4:	ef6080e7          	jalr	-266(ra) # 80002396 <bread>
    800034a8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034aa:	000aa583          	lw	a1,0(s5)
    800034ae:	0289a503          	lw	a0,40(s3)
    800034b2:	fffff097          	auipc	ra,0xfffff
    800034b6:	ee4080e7          	jalr	-284(ra) # 80002396 <bread>
    800034ba:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034bc:	40000613          	li	a2,1024
    800034c0:	05890593          	addi	a1,s2,88
    800034c4:	05850513          	addi	a0,a0,88
    800034c8:	ffffd097          	auipc	ra,0xffffd
    800034cc:	d0e080e7          	jalr	-754(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034d0:	8526                	mv	a0,s1
    800034d2:	fffff097          	auipc	ra,0xfffff
    800034d6:	fb6080e7          	jalr	-74(ra) # 80002488 <bwrite>
    if(recovering == 0)
    800034da:	f80b1ce3          	bnez	s6,80003472 <install_trans+0x36>
      bunpin(dbuf);
    800034de:	8526                	mv	a0,s1
    800034e0:	fffff097          	auipc	ra,0xfffff
    800034e4:	0be080e7          	jalr	190(ra) # 8000259e <bunpin>
    800034e8:	b769                	j	80003472 <install_trans+0x36>
}
    800034ea:	70e2                	ld	ra,56(sp)
    800034ec:	7442                	ld	s0,48(sp)
    800034ee:	74a2                	ld	s1,40(sp)
    800034f0:	7902                	ld	s2,32(sp)
    800034f2:	69e2                	ld	s3,24(sp)
    800034f4:	6a42                	ld	s4,16(sp)
    800034f6:	6aa2                	ld	s5,8(sp)
    800034f8:	6b02                	ld	s6,0(sp)
    800034fa:	6121                	addi	sp,sp,64
    800034fc:	8082                	ret
    800034fe:	8082                	ret

0000000080003500 <initlog>:
{
    80003500:	7179                	addi	sp,sp,-48
    80003502:	f406                	sd	ra,40(sp)
    80003504:	f022                	sd	s0,32(sp)
    80003506:	ec26                	sd	s1,24(sp)
    80003508:	e84a                	sd	s2,16(sp)
    8000350a:	e44e                	sd	s3,8(sp)
    8000350c:	1800                	addi	s0,sp,48
    8000350e:	892a                	mv	s2,a0
    80003510:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003512:	00015497          	auipc	s1,0x15
    80003516:	3fe48493          	addi	s1,s1,1022 # 80018910 <log>
    8000351a:	00005597          	auipc	a1,0x5
    8000351e:	fd658593          	addi	a1,a1,-42 # 800084f0 <etext+0x4f0>
    80003522:	8526                	mv	a0,s1
    80003524:	00003097          	auipc	ra,0x3
    80003528:	dd0080e7          	jalr	-560(ra) # 800062f4 <initlock>
  log.start = sb->logstart;
    8000352c:	0149a583          	lw	a1,20(s3)
    80003530:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003532:	0109a783          	lw	a5,16(s3)
    80003536:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003538:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000353c:	854a                	mv	a0,s2
    8000353e:	fffff097          	auipc	ra,0xfffff
    80003542:	e58080e7          	jalr	-424(ra) # 80002396 <bread>
  log.lh.n = lh->n;
    80003546:	4d30                	lw	a2,88(a0)
    80003548:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000354a:	00c05f63          	blez	a2,80003568 <initlog+0x68>
    8000354e:	87aa                	mv	a5,a0
    80003550:	00015717          	auipc	a4,0x15
    80003554:	3f070713          	addi	a4,a4,1008 # 80018940 <log+0x30>
    80003558:	060a                	slli	a2,a2,0x2
    8000355a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000355c:	4ff4                	lw	a3,92(a5)
    8000355e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003560:	0791                	addi	a5,a5,4
    80003562:	0711                	addi	a4,a4,4
    80003564:	fec79ce3          	bne	a5,a2,8000355c <initlog+0x5c>
  brelse(buf);
    80003568:	fffff097          	auipc	ra,0xfffff
    8000356c:	f5e080e7          	jalr	-162(ra) # 800024c6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003570:	4505                	li	a0,1
    80003572:	00000097          	auipc	ra,0x0
    80003576:	eca080e7          	jalr	-310(ra) # 8000343c <install_trans>
  log.lh.n = 0;
    8000357a:	00015797          	auipc	a5,0x15
    8000357e:	3c07a123          	sw	zero,962(a5) # 8001893c <log+0x2c>
  write_head(); // clear the log
    80003582:	00000097          	auipc	ra,0x0
    80003586:	e50080e7          	jalr	-432(ra) # 800033d2 <write_head>
}
    8000358a:	70a2                	ld	ra,40(sp)
    8000358c:	7402                	ld	s0,32(sp)
    8000358e:	64e2                	ld	s1,24(sp)
    80003590:	6942                	ld	s2,16(sp)
    80003592:	69a2                	ld	s3,8(sp)
    80003594:	6145                	addi	sp,sp,48
    80003596:	8082                	ret

0000000080003598 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003598:	1101                	addi	sp,sp,-32
    8000359a:	ec06                	sd	ra,24(sp)
    8000359c:	e822                	sd	s0,16(sp)
    8000359e:	e426                	sd	s1,8(sp)
    800035a0:	e04a                	sd	s2,0(sp)
    800035a2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035a4:	00015517          	auipc	a0,0x15
    800035a8:	36c50513          	addi	a0,a0,876 # 80018910 <log>
    800035ac:	00003097          	auipc	ra,0x3
    800035b0:	dd8080e7          	jalr	-552(ra) # 80006384 <acquire>
  while(1){
    if(log.committing){
    800035b4:	00015497          	auipc	s1,0x15
    800035b8:	35c48493          	addi	s1,s1,860 # 80018910 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035bc:	4979                	li	s2,30
    800035be:	a039                	j	800035cc <begin_op+0x34>
      sleep(&log, &log.lock);
    800035c0:	85a6                	mv	a1,s1
    800035c2:	8526                	mv	a0,s1
    800035c4:	ffffe097          	auipc	ra,0xffffe
    800035c8:	ff0080e7          	jalr	-16(ra) # 800015b4 <sleep>
    if(log.committing){
    800035cc:	50dc                	lw	a5,36(s1)
    800035ce:	fbed                	bnez	a5,800035c0 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035d0:	5098                	lw	a4,32(s1)
    800035d2:	2705                	addiw	a4,a4,1
    800035d4:	0027179b          	slliw	a5,a4,0x2
    800035d8:	9fb9                	addw	a5,a5,a4
    800035da:	0017979b          	slliw	a5,a5,0x1
    800035de:	54d4                	lw	a3,44(s1)
    800035e0:	9fb5                	addw	a5,a5,a3
    800035e2:	00f95963          	bge	s2,a5,800035f4 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035e6:	85a6                	mv	a1,s1
    800035e8:	8526                	mv	a0,s1
    800035ea:	ffffe097          	auipc	ra,0xffffe
    800035ee:	fca080e7          	jalr	-54(ra) # 800015b4 <sleep>
    800035f2:	bfe9                	j	800035cc <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035f4:	00015517          	auipc	a0,0x15
    800035f8:	31c50513          	addi	a0,a0,796 # 80018910 <log>
    800035fc:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800035fe:	00003097          	auipc	ra,0x3
    80003602:	e3a080e7          	jalr	-454(ra) # 80006438 <release>
      break;
    }
  }
}
    80003606:	60e2                	ld	ra,24(sp)
    80003608:	6442                	ld	s0,16(sp)
    8000360a:	64a2                	ld	s1,8(sp)
    8000360c:	6902                	ld	s2,0(sp)
    8000360e:	6105                	addi	sp,sp,32
    80003610:	8082                	ret

0000000080003612 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003612:	7139                	addi	sp,sp,-64
    80003614:	fc06                	sd	ra,56(sp)
    80003616:	f822                	sd	s0,48(sp)
    80003618:	f426                	sd	s1,40(sp)
    8000361a:	f04a                	sd	s2,32(sp)
    8000361c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000361e:	00015497          	auipc	s1,0x15
    80003622:	2f248493          	addi	s1,s1,754 # 80018910 <log>
    80003626:	8526                	mv	a0,s1
    80003628:	00003097          	auipc	ra,0x3
    8000362c:	d5c080e7          	jalr	-676(ra) # 80006384 <acquire>
  log.outstanding -= 1;
    80003630:	509c                	lw	a5,32(s1)
    80003632:	37fd                	addiw	a5,a5,-1
    80003634:	0007891b          	sext.w	s2,a5
    80003638:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000363a:	50dc                	lw	a5,36(s1)
    8000363c:	e7b9                	bnez	a5,8000368a <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000363e:	06091163          	bnez	s2,800036a0 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003642:	00015497          	auipc	s1,0x15
    80003646:	2ce48493          	addi	s1,s1,718 # 80018910 <log>
    8000364a:	4785                	li	a5,1
    8000364c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000364e:	8526                	mv	a0,s1
    80003650:	00003097          	auipc	ra,0x3
    80003654:	de8080e7          	jalr	-536(ra) # 80006438 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003658:	54dc                	lw	a5,44(s1)
    8000365a:	06f04763          	bgtz	a5,800036c8 <end_op+0xb6>
    acquire(&log.lock);
    8000365e:	00015497          	auipc	s1,0x15
    80003662:	2b248493          	addi	s1,s1,690 # 80018910 <log>
    80003666:	8526                	mv	a0,s1
    80003668:	00003097          	auipc	ra,0x3
    8000366c:	d1c080e7          	jalr	-740(ra) # 80006384 <acquire>
    log.committing = 0;
    80003670:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003674:	8526                	mv	a0,s1
    80003676:	ffffe097          	auipc	ra,0xffffe
    8000367a:	fa2080e7          	jalr	-94(ra) # 80001618 <wakeup>
    release(&log.lock);
    8000367e:	8526                	mv	a0,s1
    80003680:	00003097          	auipc	ra,0x3
    80003684:	db8080e7          	jalr	-584(ra) # 80006438 <release>
}
    80003688:	a815                	j	800036bc <end_op+0xaa>
    8000368a:	ec4e                	sd	s3,24(sp)
    8000368c:	e852                	sd	s4,16(sp)
    8000368e:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003690:	00005517          	auipc	a0,0x5
    80003694:	e6850513          	addi	a0,a0,-408 # 800084f8 <etext+0x4f8>
    80003698:	00002097          	auipc	ra,0x2
    8000369c:	79c080e7          	jalr	1948(ra) # 80005e34 <panic>
    wakeup(&log);
    800036a0:	00015497          	auipc	s1,0x15
    800036a4:	27048493          	addi	s1,s1,624 # 80018910 <log>
    800036a8:	8526                	mv	a0,s1
    800036aa:	ffffe097          	auipc	ra,0xffffe
    800036ae:	f6e080e7          	jalr	-146(ra) # 80001618 <wakeup>
  release(&log.lock);
    800036b2:	8526                	mv	a0,s1
    800036b4:	00003097          	auipc	ra,0x3
    800036b8:	d84080e7          	jalr	-636(ra) # 80006438 <release>
}
    800036bc:	70e2                	ld	ra,56(sp)
    800036be:	7442                	ld	s0,48(sp)
    800036c0:	74a2                	ld	s1,40(sp)
    800036c2:	7902                	ld	s2,32(sp)
    800036c4:	6121                	addi	sp,sp,64
    800036c6:	8082                	ret
    800036c8:	ec4e                	sd	s3,24(sp)
    800036ca:	e852                	sd	s4,16(sp)
    800036cc:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ce:	00015a97          	auipc	s5,0x15
    800036d2:	272a8a93          	addi	s5,s5,626 # 80018940 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036d6:	00015a17          	auipc	s4,0x15
    800036da:	23aa0a13          	addi	s4,s4,570 # 80018910 <log>
    800036de:	018a2583          	lw	a1,24(s4)
    800036e2:	012585bb          	addw	a1,a1,s2
    800036e6:	2585                	addiw	a1,a1,1
    800036e8:	028a2503          	lw	a0,40(s4)
    800036ec:	fffff097          	auipc	ra,0xfffff
    800036f0:	caa080e7          	jalr	-854(ra) # 80002396 <bread>
    800036f4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036f6:	000aa583          	lw	a1,0(s5)
    800036fa:	028a2503          	lw	a0,40(s4)
    800036fe:	fffff097          	auipc	ra,0xfffff
    80003702:	c98080e7          	jalr	-872(ra) # 80002396 <bread>
    80003706:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003708:	40000613          	li	a2,1024
    8000370c:	05850593          	addi	a1,a0,88
    80003710:	05848513          	addi	a0,s1,88
    80003714:	ffffd097          	auipc	ra,0xffffd
    80003718:	ac2080e7          	jalr	-1342(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000371c:	8526                	mv	a0,s1
    8000371e:	fffff097          	auipc	ra,0xfffff
    80003722:	d6a080e7          	jalr	-662(ra) # 80002488 <bwrite>
    brelse(from);
    80003726:	854e                	mv	a0,s3
    80003728:	fffff097          	auipc	ra,0xfffff
    8000372c:	d9e080e7          	jalr	-610(ra) # 800024c6 <brelse>
    brelse(to);
    80003730:	8526                	mv	a0,s1
    80003732:	fffff097          	auipc	ra,0xfffff
    80003736:	d94080e7          	jalr	-620(ra) # 800024c6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000373a:	2905                	addiw	s2,s2,1
    8000373c:	0a91                	addi	s5,s5,4
    8000373e:	02ca2783          	lw	a5,44(s4)
    80003742:	f8f94ee3          	blt	s2,a5,800036de <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003746:	00000097          	auipc	ra,0x0
    8000374a:	c8c080e7          	jalr	-884(ra) # 800033d2 <write_head>
    install_trans(0); // Now install writes to home locations
    8000374e:	4501                	li	a0,0
    80003750:	00000097          	auipc	ra,0x0
    80003754:	cec080e7          	jalr	-788(ra) # 8000343c <install_trans>
    log.lh.n = 0;
    80003758:	00015797          	auipc	a5,0x15
    8000375c:	1e07a223          	sw	zero,484(a5) # 8001893c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003760:	00000097          	auipc	ra,0x0
    80003764:	c72080e7          	jalr	-910(ra) # 800033d2 <write_head>
    80003768:	69e2                	ld	s3,24(sp)
    8000376a:	6a42                	ld	s4,16(sp)
    8000376c:	6aa2                	ld	s5,8(sp)
    8000376e:	bdc5                	j	8000365e <end_op+0x4c>

0000000080003770 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003770:	1101                	addi	sp,sp,-32
    80003772:	ec06                	sd	ra,24(sp)
    80003774:	e822                	sd	s0,16(sp)
    80003776:	e426                	sd	s1,8(sp)
    80003778:	e04a                	sd	s2,0(sp)
    8000377a:	1000                	addi	s0,sp,32
    8000377c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000377e:	00015917          	auipc	s2,0x15
    80003782:	19290913          	addi	s2,s2,402 # 80018910 <log>
    80003786:	854a                	mv	a0,s2
    80003788:	00003097          	auipc	ra,0x3
    8000378c:	bfc080e7          	jalr	-1028(ra) # 80006384 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003790:	02c92603          	lw	a2,44(s2)
    80003794:	47f5                	li	a5,29
    80003796:	06c7c563          	blt	a5,a2,80003800 <log_write+0x90>
    8000379a:	00015797          	auipc	a5,0x15
    8000379e:	1927a783          	lw	a5,402(a5) # 8001892c <log+0x1c>
    800037a2:	37fd                	addiw	a5,a5,-1
    800037a4:	04f65e63          	bge	a2,a5,80003800 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037a8:	00015797          	auipc	a5,0x15
    800037ac:	1887a783          	lw	a5,392(a5) # 80018930 <log+0x20>
    800037b0:	06f05063          	blez	a5,80003810 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037b4:	4781                	li	a5,0
    800037b6:	06c05563          	blez	a2,80003820 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ba:	44cc                	lw	a1,12(s1)
    800037bc:	00015717          	auipc	a4,0x15
    800037c0:	18470713          	addi	a4,a4,388 # 80018940 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037c4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037c6:	4314                	lw	a3,0(a4)
    800037c8:	04b68c63          	beq	a3,a1,80003820 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037cc:	2785                	addiw	a5,a5,1
    800037ce:	0711                	addi	a4,a4,4
    800037d0:	fef61be3          	bne	a2,a5,800037c6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037d4:	0621                	addi	a2,a2,8
    800037d6:	060a                	slli	a2,a2,0x2
    800037d8:	00015797          	auipc	a5,0x15
    800037dc:	13878793          	addi	a5,a5,312 # 80018910 <log>
    800037e0:	97b2                	add	a5,a5,a2
    800037e2:	44d8                	lw	a4,12(s1)
    800037e4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037e6:	8526                	mv	a0,s1
    800037e8:	fffff097          	auipc	ra,0xfffff
    800037ec:	d7a080e7          	jalr	-646(ra) # 80002562 <bpin>
    log.lh.n++;
    800037f0:	00015717          	auipc	a4,0x15
    800037f4:	12070713          	addi	a4,a4,288 # 80018910 <log>
    800037f8:	575c                	lw	a5,44(a4)
    800037fa:	2785                	addiw	a5,a5,1
    800037fc:	d75c                	sw	a5,44(a4)
    800037fe:	a82d                	j	80003838 <log_write+0xc8>
    panic("too big a transaction");
    80003800:	00005517          	auipc	a0,0x5
    80003804:	d0850513          	addi	a0,a0,-760 # 80008508 <etext+0x508>
    80003808:	00002097          	auipc	ra,0x2
    8000380c:	62c080e7          	jalr	1580(ra) # 80005e34 <panic>
    panic("log_write outside of trans");
    80003810:	00005517          	auipc	a0,0x5
    80003814:	d1050513          	addi	a0,a0,-752 # 80008520 <etext+0x520>
    80003818:	00002097          	auipc	ra,0x2
    8000381c:	61c080e7          	jalr	1564(ra) # 80005e34 <panic>
  log.lh.block[i] = b->blockno;
    80003820:	00878693          	addi	a3,a5,8
    80003824:	068a                	slli	a3,a3,0x2
    80003826:	00015717          	auipc	a4,0x15
    8000382a:	0ea70713          	addi	a4,a4,234 # 80018910 <log>
    8000382e:	9736                	add	a4,a4,a3
    80003830:	44d4                	lw	a3,12(s1)
    80003832:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003834:	faf609e3          	beq	a2,a5,800037e6 <log_write+0x76>
  }
  release(&log.lock);
    80003838:	00015517          	auipc	a0,0x15
    8000383c:	0d850513          	addi	a0,a0,216 # 80018910 <log>
    80003840:	00003097          	auipc	ra,0x3
    80003844:	bf8080e7          	jalr	-1032(ra) # 80006438 <release>
}
    80003848:	60e2                	ld	ra,24(sp)
    8000384a:	6442                	ld	s0,16(sp)
    8000384c:	64a2                	ld	s1,8(sp)
    8000384e:	6902                	ld	s2,0(sp)
    80003850:	6105                	addi	sp,sp,32
    80003852:	8082                	ret

0000000080003854 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003854:	1101                	addi	sp,sp,-32
    80003856:	ec06                	sd	ra,24(sp)
    80003858:	e822                	sd	s0,16(sp)
    8000385a:	e426                	sd	s1,8(sp)
    8000385c:	e04a                	sd	s2,0(sp)
    8000385e:	1000                	addi	s0,sp,32
    80003860:	84aa                	mv	s1,a0
    80003862:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003864:	00005597          	auipc	a1,0x5
    80003868:	cdc58593          	addi	a1,a1,-804 # 80008540 <etext+0x540>
    8000386c:	0521                	addi	a0,a0,8
    8000386e:	00003097          	auipc	ra,0x3
    80003872:	a86080e7          	jalr	-1402(ra) # 800062f4 <initlock>
  lk->name = name;
    80003876:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000387a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000387e:	0204a423          	sw	zero,40(s1)
}
    80003882:	60e2                	ld	ra,24(sp)
    80003884:	6442                	ld	s0,16(sp)
    80003886:	64a2                	ld	s1,8(sp)
    80003888:	6902                	ld	s2,0(sp)
    8000388a:	6105                	addi	sp,sp,32
    8000388c:	8082                	ret

000000008000388e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000388e:	1101                	addi	sp,sp,-32
    80003890:	ec06                	sd	ra,24(sp)
    80003892:	e822                	sd	s0,16(sp)
    80003894:	e426                	sd	s1,8(sp)
    80003896:	e04a                	sd	s2,0(sp)
    80003898:	1000                	addi	s0,sp,32
    8000389a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000389c:	00850913          	addi	s2,a0,8
    800038a0:	854a                	mv	a0,s2
    800038a2:	00003097          	auipc	ra,0x3
    800038a6:	ae2080e7          	jalr	-1310(ra) # 80006384 <acquire>
  while (lk->locked) {
    800038aa:	409c                	lw	a5,0(s1)
    800038ac:	cb89                	beqz	a5,800038be <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038ae:	85ca                	mv	a1,s2
    800038b0:	8526                	mv	a0,s1
    800038b2:	ffffe097          	auipc	ra,0xffffe
    800038b6:	d02080e7          	jalr	-766(ra) # 800015b4 <sleep>
  while (lk->locked) {
    800038ba:	409c                	lw	a5,0(s1)
    800038bc:	fbed                	bnez	a5,800038ae <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038be:	4785                	li	a5,1
    800038c0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038c2:	ffffd097          	auipc	ra,0xffffd
    800038c6:	644080e7          	jalr	1604(ra) # 80000f06 <myproc>
    800038ca:	591c                	lw	a5,48(a0)
    800038cc:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038ce:	854a                	mv	a0,s2
    800038d0:	00003097          	auipc	ra,0x3
    800038d4:	b68080e7          	jalr	-1176(ra) # 80006438 <release>
}
    800038d8:	60e2                	ld	ra,24(sp)
    800038da:	6442                	ld	s0,16(sp)
    800038dc:	64a2                	ld	s1,8(sp)
    800038de:	6902                	ld	s2,0(sp)
    800038e0:	6105                	addi	sp,sp,32
    800038e2:	8082                	ret

00000000800038e4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038e4:	1101                	addi	sp,sp,-32
    800038e6:	ec06                	sd	ra,24(sp)
    800038e8:	e822                	sd	s0,16(sp)
    800038ea:	e426                	sd	s1,8(sp)
    800038ec:	e04a                	sd	s2,0(sp)
    800038ee:	1000                	addi	s0,sp,32
    800038f0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f2:	00850913          	addi	s2,a0,8
    800038f6:	854a                	mv	a0,s2
    800038f8:	00003097          	auipc	ra,0x3
    800038fc:	a8c080e7          	jalr	-1396(ra) # 80006384 <acquire>
  lk->locked = 0;
    80003900:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003904:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003908:	8526                	mv	a0,s1
    8000390a:	ffffe097          	auipc	ra,0xffffe
    8000390e:	d0e080e7          	jalr	-754(ra) # 80001618 <wakeup>
  release(&lk->lk);
    80003912:	854a                	mv	a0,s2
    80003914:	00003097          	auipc	ra,0x3
    80003918:	b24080e7          	jalr	-1244(ra) # 80006438 <release>
}
    8000391c:	60e2                	ld	ra,24(sp)
    8000391e:	6442                	ld	s0,16(sp)
    80003920:	64a2                	ld	s1,8(sp)
    80003922:	6902                	ld	s2,0(sp)
    80003924:	6105                	addi	sp,sp,32
    80003926:	8082                	ret

0000000080003928 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003928:	7179                	addi	sp,sp,-48
    8000392a:	f406                	sd	ra,40(sp)
    8000392c:	f022                	sd	s0,32(sp)
    8000392e:	ec26                	sd	s1,24(sp)
    80003930:	e84a                	sd	s2,16(sp)
    80003932:	1800                	addi	s0,sp,48
    80003934:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003936:	00850913          	addi	s2,a0,8
    8000393a:	854a                	mv	a0,s2
    8000393c:	00003097          	auipc	ra,0x3
    80003940:	a48080e7          	jalr	-1464(ra) # 80006384 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003944:	409c                	lw	a5,0(s1)
    80003946:	ef91                	bnez	a5,80003962 <holdingsleep+0x3a>
    80003948:	4481                	li	s1,0
  release(&lk->lk);
    8000394a:	854a                	mv	a0,s2
    8000394c:	00003097          	auipc	ra,0x3
    80003950:	aec080e7          	jalr	-1300(ra) # 80006438 <release>
  return r;
}
    80003954:	8526                	mv	a0,s1
    80003956:	70a2                	ld	ra,40(sp)
    80003958:	7402                	ld	s0,32(sp)
    8000395a:	64e2                	ld	s1,24(sp)
    8000395c:	6942                	ld	s2,16(sp)
    8000395e:	6145                	addi	sp,sp,48
    80003960:	8082                	ret
    80003962:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003964:	0284a983          	lw	s3,40(s1)
    80003968:	ffffd097          	auipc	ra,0xffffd
    8000396c:	59e080e7          	jalr	1438(ra) # 80000f06 <myproc>
    80003970:	5904                	lw	s1,48(a0)
    80003972:	413484b3          	sub	s1,s1,s3
    80003976:	0014b493          	seqz	s1,s1
    8000397a:	69a2                	ld	s3,8(sp)
    8000397c:	b7f9                	j	8000394a <holdingsleep+0x22>

000000008000397e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000397e:	1141                	addi	sp,sp,-16
    80003980:	e406                	sd	ra,8(sp)
    80003982:	e022                	sd	s0,0(sp)
    80003984:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003986:	00005597          	auipc	a1,0x5
    8000398a:	bca58593          	addi	a1,a1,-1078 # 80008550 <etext+0x550>
    8000398e:	00015517          	auipc	a0,0x15
    80003992:	0ca50513          	addi	a0,a0,202 # 80018a58 <ftable>
    80003996:	00003097          	auipc	ra,0x3
    8000399a:	95e080e7          	jalr	-1698(ra) # 800062f4 <initlock>
}
    8000399e:	60a2                	ld	ra,8(sp)
    800039a0:	6402                	ld	s0,0(sp)
    800039a2:	0141                	addi	sp,sp,16
    800039a4:	8082                	ret

00000000800039a6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039a6:	1101                	addi	sp,sp,-32
    800039a8:	ec06                	sd	ra,24(sp)
    800039aa:	e822                	sd	s0,16(sp)
    800039ac:	e426                	sd	s1,8(sp)
    800039ae:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039b0:	00015517          	auipc	a0,0x15
    800039b4:	0a850513          	addi	a0,a0,168 # 80018a58 <ftable>
    800039b8:	00003097          	auipc	ra,0x3
    800039bc:	9cc080e7          	jalr	-1588(ra) # 80006384 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039c0:	00015497          	auipc	s1,0x15
    800039c4:	0b048493          	addi	s1,s1,176 # 80018a70 <ftable+0x18>
    800039c8:	00016717          	auipc	a4,0x16
    800039cc:	04870713          	addi	a4,a4,72 # 80019a10 <disk>
    if(f->ref == 0){
    800039d0:	40dc                	lw	a5,4(s1)
    800039d2:	cf99                	beqz	a5,800039f0 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039d4:	02848493          	addi	s1,s1,40
    800039d8:	fee49ce3          	bne	s1,a4,800039d0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039dc:	00015517          	auipc	a0,0x15
    800039e0:	07c50513          	addi	a0,a0,124 # 80018a58 <ftable>
    800039e4:	00003097          	auipc	ra,0x3
    800039e8:	a54080e7          	jalr	-1452(ra) # 80006438 <release>
  return 0;
    800039ec:	4481                	li	s1,0
    800039ee:	a819                	j	80003a04 <filealloc+0x5e>
      f->ref = 1;
    800039f0:	4785                	li	a5,1
    800039f2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039f4:	00015517          	auipc	a0,0x15
    800039f8:	06450513          	addi	a0,a0,100 # 80018a58 <ftable>
    800039fc:	00003097          	auipc	ra,0x3
    80003a00:	a3c080e7          	jalr	-1476(ra) # 80006438 <release>
}
    80003a04:	8526                	mv	a0,s1
    80003a06:	60e2                	ld	ra,24(sp)
    80003a08:	6442                	ld	s0,16(sp)
    80003a0a:	64a2                	ld	s1,8(sp)
    80003a0c:	6105                	addi	sp,sp,32
    80003a0e:	8082                	ret

0000000080003a10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a10:	1101                	addi	sp,sp,-32
    80003a12:	ec06                	sd	ra,24(sp)
    80003a14:	e822                	sd	s0,16(sp)
    80003a16:	e426                	sd	s1,8(sp)
    80003a18:	1000                	addi	s0,sp,32
    80003a1a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a1c:	00015517          	auipc	a0,0x15
    80003a20:	03c50513          	addi	a0,a0,60 # 80018a58 <ftable>
    80003a24:	00003097          	auipc	ra,0x3
    80003a28:	960080e7          	jalr	-1696(ra) # 80006384 <acquire>
  if(f->ref < 1)
    80003a2c:	40dc                	lw	a5,4(s1)
    80003a2e:	02f05263          	blez	a5,80003a52 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a32:	2785                	addiw	a5,a5,1
    80003a34:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a36:	00015517          	auipc	a0,0x15
    80003a3a:	02250513          	addi	a0,a0,34 # 80018a58 <ftable>
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	9fa080e7          	jalr	-1542(ra) # 80006438 <release>
  return f;
}
    80003a46:	8526                	mv	a0,s1
    80003a48:	60e2                	ld	ra,24(sp)
    80003a4a:	6442                	ld	s0,16(sp)
    80003a4c:	64a2                	ld	s1,8(sp)
    80003a4e:	6105                	addi	sp,sp,32
    80003a50:	8082                	ret
    panic("filedup");
    80003a52:	00005517          	auipc	a0,0x5
    80003a56:	b0650513          	addi	a0,a0,-1274 # 80008558 <etext+0x558>
    80003a5a:	00002097          	auipc	ra,0x2
    80003a5e:	3da080e7          	jalr	986(ra) # 80005e34 <panic>

0000000080003a62 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a62:	7139                	addi	sp,sp,-64
    80003a64:	fc06                	sd	ra,56(sp)
    80003a66:	f822                	sd	s0,48(sp)
    80003a68:	f426                	sd	s1,40(sp)
    80003a6a:	0080                	addi	s0,sp,64
    80003a6c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a6e:	00015517          	auipc	a0,0x15
    80003a72:	fea50513          	addi	a0,a0,-22 # 80018a58 <ftable>
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	90e080e7          	jalr	-1778(ra) # 80006384 <acquire>
  if(f->ref < 1)
    80003a7e:	40dc                	lw	a5,4(s1)
    80003a80:	04f05c63          	blez	a5,80003ad8 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003a84:	37fd                	addiw	a5,a5,-1
    80003a86:	0007871b          	sext.w	a4,a5
    80003a8a:	c0dc                	sw	a5,4(s1)
    80003a8c:	06e04263          	bgtz	a4,80003af0 <fileclose+0x8e>
    80003a90:	f04a                	sd	s2,32(sp)
    80003a92:	ec4e                	sd	s3,24(sp)
    80003a94:	e852                	sd	s4,16(sp)
    80003a96:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a98:	0004a903          	lw	s2,0(s1)
    80003a9c:	0094ca83          	lbu	s5,9(s1)
    80003aa0:	0104ba03          	ld	s4,16(s1)
    80003aa4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003aa8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003aac:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ab0:	00015517          	auipc	a0,0x15
    80003ab4:	fa850513          	addi	a0,a0,-88 # 80018a58 <ftable>
    80003ab8:	00003097          	auipc	ra,0x3
    80003abc:	980080e7          	jalr	-1664(ra) # 80006438 <release>

  if(ff.type == FD_PIPE){
    80003ac0:	4785                	li	a5,1
    80003ac2:	04f90463          	beq	s2,a5,80003b0a <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ac6:	3979                	addiw	s2,s2,-2
    80003ac8:	4785                	li	a5,1
    80003aca:	0527fb63          	bgeu	a5,s2,80003b20 <fileclose+0xbe>
    80003ace:	7902                	ld	s2,32(sp)
    80003ad0:	69e2                	ld	s3,24(sp)
    80003ad2:	6a42                	ld	s4,16(sp)
    80003ad4:	6aa2                	ld	s5,8(sp)
    80003ad6:	a02d                	j	80003b00 <fileclose+0x9e>
    80003ad8:	f04a                	sd	s2,32(sp)
    80003ada:	ec4e                	sd	s3,24(sp)
    80003adc:	e852                	sd	s4,16(sp)
    80003ade:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003ae0:	00005517          	auipc	a0,0x5
    80003ae4:	a8050513          	addi	a0,a0,-1408 # 80008560 <etext+0x560>
    80003ae8:	00002097          	auipc	ra,0x2
    80003aec:	34c080e7          	jalr	844(ra) # 80005e34 <panic>
    release(&ftable.lock);
    80003af0:	00015517          	auipc	a0,0x15
    80003af4:	f6850513          	addi	a0,a0,-152 # 80018a58 <ftable>
    80003af8:	00003097          	auipc	ra,0x3
    80003afc:	940080e7          	jalr	-1728(ra) # 80006438 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b00:	70e2                	ld	ra,56(sp)
    80003b02:	7442                	ld	s0,48(sp)
    80003b04:	74a2                	ld	s1,40(sp)
    80003b06:	6121                	addi	sp,sp,64
    80003b08:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b0a:	85d6                	mv	a1,s5
    80003b0c:	8552                	mv	a0,s4
    80003b0e:	00000097          	auipc	ra,0x0
    80003b12:	3a2080e7          	jalr	930(ra) # 80003eb0 <pipeclose>
    80003b16:	7902                	ld	s2,32(sp)
    80003b18:	69e2                	ld	s3,24(sp)
    80003b1a:	6a42                	ld	s4,16(sp)
    80003b1c:	6aa2                	ld	s5,8(sp)
    80003b1e:	b7cd                	j	80003b00 <fileclose+0x9e>
    begin_op();
    80003b20:	00000097          	auipc	ra,0x0
    80003b24:	a78080e7          	jalr	-1416(ra) # 80003598 <begin_op>
    iput(ff.ip);
    80003b28:	854e                	mv	a0,s3
    80003b2a:	fffff097          	auipc	ra,0xfffff
    80003b2e:	25e080e7          	jalr	606(ra) # 80002d88 <iput>
    end_op();
    80003b32:	00000097          	auipc	ra,0x0
    80003b36:	ae0080e7          	jalr	-1312(ra) # 80003612 <end_op>
    80003b3a:	7902                	ld	s2,32(sp)
    80003b3c:	69e2                	ld	s3,24(sp)
    80003b3e:	6a42                	ld	s4,16(sp)
    80003b40:	6aa2                	ld	s5,8(sp)
    80003b42:	bf7d                	j	80003b00 <fileclose+0x9e>

0000000080003b44 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b44:	715d                	addi	sp,sp,-80
    80003b46:	e486                	sd	ra,72(sp)
    80003b48:	e0a2                	sd	s0,64(sp)
    80003b4a:	fc26                	sd	s1,56(sp)
    80003b4c:	f44e                	sd	s3,40(sp)
    80003b4e:	0880                	addi	s0,sp,80
    80003b50:	84aa                	mv	s1,a0
    80003b52:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b54:	ffffd097          	auipc	ra,0xffffd
    80003b58:	3b2080e7          	jalr	946(ra) # 80000f06 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b5c:	409c                	lw	a5,0(s1)
    80003b5e:	37f9                	addiw	a5,a5,-2
    80003b60:	4705                	li	a4,1
    80003b62:	04f76863          	bltu	a4,a5,80003bb2 <filestat+0x6e>
    80003b66:	f84a                	sd	s2,48(sp)
    80003b68:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b6a:	6c88                	ld	a0,24(s1)
    80003b6c:	fffff097          	auipc	ra,0xfffff
    80003b70:	05e080e7          	jalr	94(ra) # 80002bca <ilock>
    stati(f->ip, &st);
    80003b74:	fb840593          	addi	a1,s0,-72
    80003b78:	6c88                	ld	a0,24(s1)
    80003b7a:	fffff097          	auipc	ra,0xfffff
    80003b7e:	2de080e7          	jalr	734(ra) # 80002e58 <stati>
    iunlock(f->ip);
    80003b82:	6c88                	ld	a0,24(s1)
    80003b84:	fffff097          	auipc	ra,0xfffff
    80003b88:	10c080e7          	jalr	268(ra) # 80002c90 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b8c:	46e1                	li	a3,24
    80003b8e:	fb840613          	addi	a2,s0,-72
    80003b92:	85ce                	mv	a1,s3
    80003b94:	05093503          	ld	a0,80(s2)
    80003b98:	ffffd097          	auipc	ra,0xffffd
    80003b9c:	fb4080e7          	jalr	-76(ra) # 80000b4c <copyout>
    80003ba0:	41f5551b          	sraiw	a0,a0,0x1f
    80003ba4:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003ba6:	60a6                	ld	ra,72(sp)
    80003ba8:	6406                	ld	s0,64(sp)
    80003baa:	74e2                	ld	s1,56(sp)
    80003bac:	79a2                	ld	s3,40(sp)
    80003bae:	6161                	addi	sp,sp,80
    80003bb0:	8082                	ret
  return -1;
    80003bb2:	557d                	li	a0,-1
    80003bb4:	bfcd                	j	80003ba6 <filestat+0x62>

0000000080003bb6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bb6:	7179                	addi	sp,sp,-48
    80003bb8:	f406                	sd	ra,40(sp)
    80003bba:	f022                	sd	s0,32(sp)
    80003bbc:	e84a                	sd	s2,16(sp)
    80003bbe:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bc0:	00854783          	lbu	a5,8(a0)
    80003bc4:	cbc5                	beqz	a5,80003c74 <fileread+0xbe>
    80003bc6:	ec26                	sd	s1,24(sp)
    80003bc8:	e44e                	sd	s3,8(sp)
    80003bca:	84aa                	mv	s1,a0
    80003bcc:	89ae                	mv	s3,a1
    80003bce:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bd0:	411c                	lw	a5,0(a0)
    80003bd2:	4705                	li	a4,1
    80003bd4:	04e78963          	beq	a5,a4,80003c26 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bd8:	470d                	li	a4,3
    80003bda:	04e78f63          	beq	a5,a4,80003c38 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bde:	4709                	li	a4,2
    80003be0:	08e79263          	bne	a5,a4,80003c64 <fileread+0xae>
    ilock(f->ip);
    80003be4:	6d08                	ld	a0,24(a0)
    80003be6:	fffff097          	auipc	ra,0xfffff
    80003bea:	fe4080e7          	jalr	-28(ra) # 80002bca <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bee:	874a                	mv	a4,s2
    80003bf0:	5094                	lw	a3,32(s1)
    80003bf2:	864e                	mv	a2,s3
    80003bf4:	4585                	li	a1,1
    80003bf6:	6c88                	ld	a0,24(s1)
    80003bf8:	fffff097          	auipc	ra,0xfffff
    80003bfc:	28a080e7          	jalr	650(ra) # 80002e82 <readi>
    80003c00:	892a                	mv	s2,a0
    80003c02:	00a05563          	blez	a0,80003c0c <fileread+0x56>
      f->off += r;
    80003c06:	509c                	lw	a5,32(s1)
    80003c08:	9fa9                	addw	a5,a5,a0
    80003c0a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c0c:	6c88                	ld	a0,24(s1)
    80003c0e:	fffff097          	auipc	ra,0xfffff
    80003c12:	082080e7          	jalr	130(ra) # 80002c90 <iunlock>
    80003c16:	64e2                	ld	s1,24(sp)
    80003c18:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c1a:	854a                	mv	a0,s2
    80003c1c:	70a2                	ld	ra,40(sp)
    80003c1e:	7402                	ld	s0,32(sp)
    80003c20:	6942                	ld	s2,16(sp)
    80003c22:	6145                	addi	sp,sp,48
    80003c24:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c26:	6908                	ld	a0,16(a0)
    80003c28:	00000097          	auipc	ra,0x0
    80003c2c:	400080e7          	jalr	1024(ra) # 80004028 <piperead>
    80003c30:	892a                	mv	s2,a0
    80003c32:	64e2                	ld	s1,24(sp)
    80003c34:	69a2                	ld	s3,8(sp)
    80003c36:	b7d5                	j	80003c1a <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c38:	02451783          	lh	a5,36(a0)
    80003c3c:	03079693          	slli	a3,a5,0x30
    80003c40:	92c1                	srli	a3,a3,0x30
    80003c42:	4725                	li	a4,9
    80003c44:	02d76a63          	bltu	a4,a3,80003c78 <fileread+0xc2>
    80003c48:	0792                	slli	a5,a5,0x4
    80003c4a:	00015717          	auipc	a4,0x15
    80003c4e:	d6e70713          	addi	a4,a4,-658 # 800189b8 <devsw>
    80003c52:	97ba                	add	a5,a5,a4
    80003c54:	639c                	ld	a5,0(a5)
    80003c56:	c78d                	beqz	a5,80003c80 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003c58:	4505                	li	a0,1
    80003c5a:	9782                	jalr	a5
    80003c5c:	892a                	mv	s2,a0
    80003c5e:	64e2                	ld	s1,24(sp)
    80003c60:	69a2                	ld	s3,8(sp)
    80003c62:	bf65                	j	80003c1a <fileread+0x64>
    panic("fileread");
    80003c64:	00005517          	auipc	a0,0x5
    80003c68:	90c50513          	addi	a0,a0,-1780 # 80008570 <etext+0x570>
    80003c6c:	00002097          	auipc	ra,0x2
    80003c70:	1c8080e7          	jalr	456(ra) # 80005e34 <panic>
    return -1;
    80003c74:	597d                	li	s2,-1
    80003c76:	b755                	j	80003c1a <fileread+0x64>
      return -1;
    80003c78:	597d                	li	s2,-1
    80003c7a:	64e2                	ld	s1,24(sp)
    80003c7c:	69a2                	ld	s3,8(sp)
    80003c7e:	bf71                	j	80003c1a <fileread+0x64>
    80003c80:	597d                	li	s2,-1
    80003c82:	64e2                	ld	s1,24(sp)
    80003c84:	69a2                	ld	s3,8(sp)
    80003c86:	bf51                	j	80003c1a <fileread+0x64>

0000000080003c88 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c88:	00954783          	lbu	a5,9(a0)
    80003c8c:	12078963          	beqz	a5,80003dbe <filewrite+0x136>
{
    80003c90:	715d                	addi	sp,sp,-80
    80003c92:	e486                	sd	ra,72(sp)
    80003c94:	e0a2                	sd	s0,64(sp)
    80003c96:	f84a                	sd	s2,48(sp)
    80003c98:	f052                	sd	s4,32(sp)
    80003c9a:	e85a                	sd	s6,16(sp)
    80003c9c:	0880                	addi	s0,sp,80
    80003c9e:	892a                	mv	s2,a0
    80003ca0:	8b2e                	mv	s6,a1
    80003ca2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ca4:	411c                	lw	a5,0(a0)
    80003ca6:	4705                	li	a4,1
    80003ca8:	02e78763          	beq	a5,a4,80003cd6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cac:	470d                	li	a4,3
    80003cae:	02e78a63          	beq	a5,a4,80003ce2 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cb2:	4709                	li	a4,2
    80003cb4:	0ee79863          	bne	a5,a4,80003da4 <filewrite+0x11c>
    80003cb8:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cba:	0cc05463          	blez	a2,80003d82 <filewrite+0xfa>
    80003cbe:	fc26                	sd	s1,56(sp)
    80003cc0:	ec56                	sd	s5,24(sp)
    80003cc2:	e45e                	sd	s7,8(sp)
    80003cc4:	e062                	sd	s8,0(sp)
    int i = 0;
    80003cc6:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003cc8:	6b85                	lui	s7,0x1
    80003cca:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cce:	6c05                	lui	s8,0x1
    80003cd0:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cd4:	a851                	j	80003d68 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003cd6:	6908                	ld	a0,16(a0)
    80003cd8:	00000097          	auipc	ra,0x0
    80003cdc:	248080e7          	jalr	584(ra) # 80003f20 <pipewrite>
    80003ce0:	a85d                	j	80003d96 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ce2:	02451783          	lh	a5,36(a0)
    80003ce6:	03079693          	slli	a3,a5,0x30
    80003cea:	92c1                	srli	a3,a3,0x30
    80003cec:	4725                	li	a4,9
    80003cee:	0cd76a63          	bltu	a4,a3,80003dc2 <filewrite+0x13a>
    80003cf2:	0792                	slli	a5,a5,0x4
    80003cf4:	00015717          	auipc	a4,0x15
    80003cf8:	cc470713          	addi	a4,a4,-828 # 800189b8 <devsw>
    80003cfc:	97ba                	add	a5,a5,a4
    80003cfe:	679c                	ld	a5,8(a5)
    80003d00:	c3f9                	beqz	a5,80003dc6 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003d02:	4505                	li	a0,1
    80003d04:	9782                	jalr	a5
    80003d06:	a841                	j	80003d96 <filewrite+0x10e>
      if(n1 > max)
    80003d08:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d0c:	00000097          	auipc	ra,0x0
    80003d10:	88c080e7          	jalr	-1908(ra) # 80003598 <begin_op>
      ilock(f->ip);
    80003d14:	01893503          	ld	a0,24(s2)
    80003d18:	fffff097          	auipc	ra,0xfffff
    80003d1c:	eb2080e7          	jalr	-334(ra) # 80002bca <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d20:	8756                	mv	a4,s5
    80003d22:	02092683          	lw	a3,32(s2)
    80003d26:	01698633          	add	a2,s3,s6
    80003d2a:	4585                	li	a1,1
    80003d2c:	01893503          	ld	a0,24(s2)
    80003d30:	fffff097          	auipc	ra,0xfffff
    80003d34:	262080e7          	jalr	610(ra) # 80002f92 <writei>
    80003d38:	84aa                	mv	s1,a0
    80003d3a:	00a05763          	blez	a0,80003d48 <filewrite+0xc0>
        f->off += r;
    80003d3e:	02092783          	lw	a5,32(s2)
    80003d42:	9fa9                	addw	a5,a5,a0
    80003d44:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d48:	01893503          	ld	a0,24(s2)
    80003d4c:	fffff097          	auipc	ra,0xfffff
    80003d50:	f44080e7          	jalr	-188(ra) # 80002c90 <iunlock>
      end_op();
    80003d54:	00000097          	auipc	ra,0x0
    80003d58:	8be080e7          	jalr	-1858(ra) # 80003612 <end_op>

      if(r != n1){
    80003d5c:	029a9563          	bne	s5,s1,80003d86 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003d60:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d64:	0149da63          	bge	s3,s4,80003d78 <filewrite+0xf0>
      int n1 = n - i;
    80003d68:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003d6c:	0004879b          	sext.w	a5,s1
    80003d70:	f8fbdce3          	bge	s7,a5,80003d08 <filewrite+0x80>
    80003d74:	84e2                	mv	s1,s8
    80003d76:	bf49                	j	80003d08 <filewrite+0x80>
    80003d78:	74e2                	ld	s1,56(sp)
    80003d7a:	6ae2                	ld	s5,24(sp)
    80003d7c:	6ba2                	ld	s7,8(sp)
    80003d7e:	6c02                	ld	s8,0(sp)
    80003d80:	a039                	j	80003d8e <filewrite+0x106>
    int i = 0;
    80003d82:	4981                	li	s3,0
    80003d84:	a029                	j	80003d8e <filewrite+0x106>
    80003d86:	74e2                	ld	s1,56(sp)
    80003d88:	6ae2                	ld	s5,24(sp)
    80003d8a:	6ba2                	ld	s7,8(sp)
    80003d8c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003d8e:	033a1e63          	bne	s4,s3,80003dca <filewrite+0x142>
    80003d92:	8552                	mv	a0,s4
    80003d94:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d96:	60a6                	ld	ra,72(sp)
    80003d98:	6406                	ld	s0,64(sp)
    80003d9a:	7942                	ld	s2,48(sp)
    80003d9c:	7a02                	ld	s4,32(sp)
    80003d9e:	6b42                	ld	s6,16(sp)
    80003da0:	6161                	addi	sp,sp,80
    80003da2:	8082                	ret
    80003da4:	fc26                	sd	s1,56(sp)
    80003da6:	f44e                	sd	s3,40(sp)
    80003da8:	ec56                	sd	s5,24(sp)
    80003daa:	e45e                	sd	s7,8(sp)
    80003dac:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003dae:	00004517          	auipc	a0,0x4
    80003db2:	7d250513          	addi	a0,a0,2002 # 80008580 <etext+0x580>
    80003db6:	00002097          	auipc	ra,0x2
    80003dba:	07e080e7          	jalr	126(ra) # 80005e34 <panic>
    return -1;
    80003dbe:	557d                	li	a0,-1
}
    80003dc0:	8082                	ret
      return -1;
    80003dc2:	557d                	li	a0,-1
    80003dc4:	bfc9                	j	80003d96 <filewrite+0x10e>
    80003dc6:	557d                	li	a0,-1
    80003dc8:	b7f9                	j	80003d96 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003dca:	557d                	li	a0,-1
    80003dcc:	79a2                	ld	s3,40(sp)
    80003dce:	b7e1                	j	80003d96 <filewrite+0x10e>

0000000080003dd0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dd0:	7179                	addi	sp,sp,-48
    80003dd2:	f406                	sd	ra,40(sp)
    80003dd4:	f022                	sd	s0,32(sp)
    80003dd6:	ec26                	sd	s1,24(sp)
    80003dd8:	e052                	sd	s4,0(sp)
    80003dda:	1800                	addi	s0,sp,48
    80003ddc:	84aa                	mv	s1,a0
    80003dde:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003de0:	0005b023          	sd	zero,0(a1)
    80003de4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003de8:	00000097          	auipc	ra,0x0
    80003dec:	bbe080e7          	jalr	-1090(ra) # 800039a6 <filealloc>
    80003df0:	e088                	sd	a0,0(s1)
    80003df2:	cd49                	beqz	a0,80003e8c <pipealloc+0xbc>
    80003df4:	00000097          	auipc	ra,0x0
    80003df8:	bb2080e7          	jalr	-1102(ra) # 800039a6 <filealloc>
    80003dfc:	00aa3023          	sd	a0,0(s4)
    80003e00:	c141                	beqz	a0,80003e80 <pipealloc+0xb0>
    80003e02:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e04:	ffffc097          	auipc	ra,0xffffc
    80003e08:	316080e7          	jalr	790(ra) # 8000011a <kalloc>
    80003e0c:	892a                	mv	s2,a0
    80003e0e:	c13d                	beqz	a0,80003e74 <pipealloc+0xa4>
    80003e10:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e12:	4985                	li	s3,1
    80003e14:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e18:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e1c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e20:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e24:	00004597          	auipc	a1,0x4
    80003e28:	76c58593          	addi	a1,a1,1900 # 80008590 <etext+0x590>
    80003e2c:	00002097          	auipc	ra,0x2
    80003e30:	4c8080e7          	jalr	1224(ra) # 800062f4 <initlock>
  (*f0)->type = FD_PIPE;
    80003e34:	609c                	ld	a5,0(s1)
    80003e36:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e3a:	609c                	ld	a5,0(s1)
    80003e3c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e40:	609c                	ld	a5,0(s1)
    80003e42:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e46:	609c                	ld	a5,0(s1)
    80003e48:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e4c:	000a3783          	ld	a5,0(s4)
    80003e50:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e54:	000a3783          	ld	a5,0(s4)
    80003e58:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e5c:	000a3783          	ld	a5,0(s4)
    80003e60:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e64:	000a3783          	ld	a5,0(s4)
    80003e68:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e6c:	4501                	li	a0,0
    80003e6e:	6942                	ld	s2,16(sp)
    80003e70:	69a2                	ld	s3,8(sp)
    80003e72:	a03d                	j	80003ea0 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e74:	6088                	ld	a0,0(s1)
    80003e76:	c119                	beqz	a0,80003e7c <pipealloc+0xac>
    80003e78:	6942                	ld	s2,16(sp)
    80003e7a:	a029                	j	80003e84 <pipealloc+0xb4>
    80003e7c:	6942                	ld	s2,16(sp)
    80003e7e:	a039                	j	80003e8c <pipealloc+0xbc>
    80003e80:	6088                	ld	a0,0(s1)
    80003e82:	c50d                	beqz	a0,80003eac <pipealloc+0xdc>
    fileclose(*f0);
    80003e84:	00000097          	auipc	ra,0x0
    80003e88:	bde080e7          	jalr	-1058(ra) # 80003a62 <fileclose>
  if(*f1)
    80003e8c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e90:	557d                	li	a0,-1
  if(*f1)
    80003e92:	c799                	beqz	a5,80003ea0 <pipealloc+0xd0>
    fileclose(*f1);
    80003e94:	853e                	mv	a0,a5
    80003e96:	00000097          	auipc	ra,0x0
    80003e9a:	bcc080e7          	jalr	-1076(ra) # 80003a62 <fileclose>
  return -1;
    80003e9e:	557d                	li	a0,-1
}
    80003ea0:	70a2                	ld	ra,40(sp)
    80003ea2:	7402                	ld	s0,32(sp)
    80003ea4:	64e2                	ld	s1,24(sp)
    80003ea6:	6a02                	ld	s4,0(sp)
    80003ea8:	6145                	addi	sp,sp,48
    80003eaa:	8082                	ret
  return -1;
    80003eac:	557d                	li	a0,-1
    80003eae:	bfcd                	j	80003ea0 <pipealloc+0xd0>

0000000080003eb0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003eb0:	1101                	addi	sp,sp,-32
    80003eb2:	ec06                	sd	ra,24(sp)
    80003eb4:	e822                	sd	s0,16(sp)
    80003eb6:	e426                	sd	s1,8(sp)
    80003eb8:	e04a                	sd	s2,0(sp)
    80003eba:	1000                	addi	s0,sp,32
    80003ebc:	84aa                	mv	s1,a0
    80003ebe:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ec0:	00002097          	auipc	ra,0x2
    80003ec4:	4c4080e7          	jalr	1220(ra) # 80006384 <acquire>
  if(writable){
    80003ec8:	02090d63          	beqz	s2,80003f02 <pipeclose+0x52>
    pi->writeopen = 0;
    80003ecc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ed0:	21848513          	addi	a0,s1,536
    80003ed4:	ffffd097          	auipc	ra,0xffffd
    80003ed8:	744080e7          	jalr	1860(ra) # 80001618 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003edc:	2204b783          	ld	a5,544(s1)
    80003ee0:	eb95                	bnez	a5,80003f14 <pipeclose+0x64>
    release(&pi->lock);
    80003ee2:	8526                	mv	a0,s1
    80003ee4:	00002097          	auipc	ra,0x2
    80003ee8:	554080e7          	jalr	1364(ra) # 80006438 <release>
    kfree((char*)pi);
    80003eec:	8526                	mv	a0,s1
    80003eee:	ffffc097          	auipc	ra,0xffffc
    80003ef2:	12e080e7          	jalr	302(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ef6:	60e2                	ld	ra,24(sp)
    80003ef8:	6442                	ld	s0,16(sp)
    80003efa:	64a2                	ld	s1,8(sp)
    80003efc:	6902                	ld	s2,0(sp)
    80003efe:	6105                	addi	sp,sp,32
    80003f00:	8082                	ret
    pi->readopen = 0;
    80003f02:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f06:	21c48513          	addi	a0,s1,540
    80003f0a:	ffffd097          	auipc	ra,0xffffd
    80003f0e:	70e080e7          	jalr	1806(ra) # 80001618 <wakeup>
    80003f12:	b7e9                	j	80003edc <pipeclose+0x2c>
    release(&pi->lock);
    80003f14:	8526                	mv	a0,s1
    80003f16:	00002097          	auipc	ra,0x2
    80003f1a:	522080e7          	jalr	1314(ra) # 80006438 <release>
}
    80003f1e:	bfe1                	j	80003ef6 <pipeclose+0x46>

0000000080003f20 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f20:	711d                	addi	sp,sp,-96
    80003f22:	ec86                	sd	ra,88(sp)
    80003f24:	e8a2                	sd	s0,80(sp)
    80003f26:	e4a6                	sd	s1,72(sp)
    80003f28:	e0ca                	sd	s2,64(sp)
    80003f2a:	fc4e                	sd	s3,56(sp)
    80003f2c:	f852                	sd	s4,48(sp)
    80003f2e:	f456                	sd	s5,40(sp)
    80003f30:	1080                	addi	s0,sp,96
    80003f32:	84aa                	mv	s1,a0
    80003f34:	8aae                	mv	s5,a1
    80003f36:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f38:	ffffd097          	auipc	ra,0xffffd
    80003f3c:	fce080e7          	jalr	-50(ra) # 80000f06 <myproc>
    80003f40:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f42:	8526                	mv	a0,s1
    80003f44:	00002097          	auipc	ra,0x2
    80003f48:	440080e7          	jalr	1088(ra) # 80006384 <acquire>
  while(i < n){
    80003f4c:	0d405863          	blez	s4,8000401c <pipewrite+0xfc>
    80003f50:	f05a                	sd	s6,32(sp)
    80003f52:	ec5e                	sd	s7,24(sp)
    80003f54:	e862                	sd	s8,16(sp)
  int i = 0;
    80003f56:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f58:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f5a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f5e:	21c48b93          	addi	s7,s1,540
    80003f62:	a089                	j	80003fa4 <pipewrite+0x84>
      release(&pi->lock);
    80003f64:	8526                	mv	a0,s1
    80003f66:	00002097          	auipc	ra,0x2
    80003f6a:	4d2080e7          	jalr	1234(ra) # 80006438 <release>
      return -1;
    80003f6e:	597d                	li	s2,-1
    80003f70:	7b02                	ld	s6,32(sp)
    80003f72:	6be2                	ld	s7,24(sp)
    80003f74:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f76:	854a                	mv	a0,s2
    80003f78:	60e6                	ld	ra,88(sp)
    80003f7a:	6446                	ld	s0,80(sp)
    80003f7c:	64a6                	ld	s1,72(sp)
    80003f7e:	6906                	ld	s2,64(sp)
    80003f80:	79e2                	ld	s3,56(sp)
    80003f82:	7a42                	ld	s4,48(sp)
    80003f84:	7aa2                	ld	s5,40(sp)
    80003f86:	6125                	addi	sp,sp,96
    80003f88:	8082                	ret
      wakeup(&pi->nread);
    80003f8a:	8562                	mv	a0,s8
    80003f8c:	ffffd097          	auipc	ra,0xffffd
    80003f90:	68c080e7          	jalr	1676(ra) # 80001618 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f94:	85a6                	mv	a1,s1
    80003f96:	855e                	mv	a0,s7
    80003f98:	ffffd097          	auipc	ra,0xffffd
    80003f9c:	61c080e7          	jalr	1564(ra) # 800015b4 <sleep>
  while(i < n){
    80003fa0:	05495f63          	bge	s2,s4,80003ffe <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    80003fa4:	2204a783          	lw	a5,544(s1)
    80003fa8:	dfd5                	beqz	a5,80003f64 <pipewrite+0x44>
    80003faa:	854e                	mv	a0,s3
    80003fac:	ffffe097          	auipc	ra,0xffffe
    80003fb0:	8b0080e7          	jalr	-1872(ra) # 8000185c <killed>
    80003fb4:	f945                	bnez	a0,80003f64 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fb6:	2184a783          	lw	a5,536(s1)
    80003fba:	21c4a703          	lw	a4,540(s1)
    80003fbe:	2007879b          	addiw	a5,a5,512
    80003fc2:	fcf704e3          	beq	a4,a5,80003f8a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc6:	4685                	li	a3,1
    80003fc8:	01590633          	add	a2,s2,s5
    80003fcc:	faf40593          	addi	a1,s0,-81
    80003fd0:	0509b503          	ld	a0,80(s3)
    80003fd4:	ffffd097          	auipc	ra,0xffffd
    80003fd8:	c56080e7          	jalr	-938(ra) # 80000c2a <copyin>
    80003fdc:	05650263          	beq	a0,s6,80004020 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fe0:	21c4a783          	lw	a5,540(s1)
    80003fe4:	0017871b          	addiw	a4,a5,1
    80003fe8:	20e4ae23          	sw	a4,540(s1)
    80003fec:	1ff7f793          	andi	a5,a5,511
    80003ff0:	97a6                	add	a5,a5,s1
    80003ff2:	faf44703          	lbu	a4,-81(s0)
    80003ff6:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ffa:	2905                	addiw	s2,s2,1
    80003ffc:	b755                	j	80003fa0 <pipewrite+0x80>
    80003ffe:	7b02                	ld	s6,32(sp)
    80004000:	6be2                	ld	s7,24(sp)
    80004002:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004004:	21848513          	addi	a0,s1,536
    80004008:	ffffd097          	auipc	ra,0xffffd
    8000400c:	610080e7          	jalr	1552(ra) # 80001618 <wakeup>
  release(&pi->lock);
    80004010:	8526                	mv	a0,s1
    80004012:	00002097          	auipc	ra,0x2
    80004016:	426080e7          	jalr	1062(ra) # 80006438 <release>
  return i;
    8000401a:	bfb1                	j	80003f76 <pipewrite+0x56>
  int i = 0;
    8000401c:	4901                	li	s2,0
    8000401e:	b7dd                	j	80004004 <pipewrite+0xe4>
    80004020:	7b02                	ld	s6,32(sp)
    80004022:	6be2                	ld	s7,24(sp)
    80004024:	6c42                	ld	s8,16(sp)
    80004026:	bff9                	j	80004004 <pipewrite+0xe4>

0000000080004028 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004028:	715d                	addi	sp,sp,-80
    8000402a:	e486                	sd	ra,72(sp)
    8000402c:	e0a2                	sd	s0,64(sp)
    8000402e:	fc26                	sd	s1,56(sp)
    80004030:	f84a                	sd	s2,48(sp)
    80004032:	f44e                	sd	s3,40(sp)
    80004034:	f052                	sd	s4,32(sp)
    80004036:	ec56                	sd	s5,24(sp)
    80004038:	0880                	addi	s0,sp,80
    8000403a:	84aa                	mv	s1,a0
    8000403c:	892e                	mv	s2,a1
    8000403e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004040:	ffffd097          	auipc	ra,0xffffd
    80004044:	ec6080e7          	jalr	-314(ra) # 80000f06 <myproc>
    80004048:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000404a:	8526                	mv	a0,s1
    8000404c:	00002097          	auipc	ra,0x2
    80004050:	338080e7          	jalr	824(ra) # 80006384 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004054:	2184a703          	lw	a4,536(s1)
    80004058:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000405c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004060:	02f71963          	bne	a4,a5,80004092 <piperead+0x6a>
    80004064:	2244a783          	lw	a5,548(s1)
    80004068:	cf95                	beqz	a5,800040a4 <piperead+0x7c>
    if(killed(pr)){
    8000406a:	8552                	mv	a0,s4
    8000406c:	ffffd097          	auipc	ra,0xffffd
    80004070:	7f0080e7          	jalr	2032(ra) # 8000185c <killed>
    80004074:	e10d                	bnez	a0,80004096 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004076:	85a6                	mv	a1,s1
    80004078:	854e                	mv	a0,s3
    8000407a:	ffffd097          	auipc	ra,0xffffd
    8000407e:	53a080e7          	jalr	1338(ra) # 800015b4 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004082:	2184a703          	lw	a4,536(s1)
    80004086:	21c4a783          	lw	a5,540(s1)
    8000408a:	fcf70de3          	beq	a4,a5,80004064 <piperead+0x3c>
    8000408e:	e85a                	sd	s6,16(sp)
    80004090:	a819                	j	800040a6 <piperead+0x7e>
    80004092:	e85a                	sd	s6,16(sp)
    80004094:	a809                	j	800040a6 <piperead+0x7e>
      release(&pi->lock);
    80004096:	8526                	mv	a0,s1
    80004098:	00002097          	auipc	ra,0x2
    8000409c:	3a0080e7          	jalr	928(ra) # 80006438 <release>
      return -1;
    800040a0:	59fd                	li	s3,-1
    800040a2:	a0a5                	j	8000410a <piperead+0xe2>
    800040a4:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040a6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040a8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040aa:	05505463          	blez	s5,800040f2 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    800040ae:	2184a783          	lw	a5,536(s1)
    800040b2:	21c4a703          	lw	a4,540(s1)
    800040b6:	02f70e63          	beq	a4,a5,800040f2 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040ba:	0017871b          	addiw	a4,a5,1
    800040be:	20e4ac23          	sw	a4,536(s1)
    800040c2:	1ff7f793          	andi	a5,a5,511
    800040c6:	97a6                	add	a5,a5,s1
    800040c8:	0187c783          	lbu	a5,24(a5)
    800040cc:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040d0:	4685                	li	a3,1
    800040d2:	fbf40613          	addi	a2,s0,-65
    800040d6:	85ca                	mv	a1,s2
    800040d8:	050a3503          	ld	a0,80(s4)
    800040dc:	ffffd097          	auipc	ra,0xffffd
    800040e0:	a70080e7          	jalr	-1424(ra) # 80000b4c <copyout>
    800040e4:	01650763          	beq	a0,s6,800040f2 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040e8:	2985                	addiw	s3,s3,1
    800040ea:	0905                	addi	s2,s2,1
    800040ec:	fd3a91e3          	bne	s5,s3,800040ae <piperead+0x86>
    800040f0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040f2:	21c48513          	addi	a0,s1,540
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	522080e7          	jalr	1314(ra) # 80001618 <wakeup>
  release(&pi->lock);
    800040fe:	8526                	mv	a0,s1
    80004100:	00002097          	auipc	ra,0x2
    80004104:	338080e7          	jalr	824(ra) # 80006438 <release>
    80004108:	6b42                	ld	s6,16(sp)
  return i;
}
    8000410a:	854e                	mv	a0,s3
    8000410c:	60a6                	ld	ra,72(sp)
    8000410e:	6406                	ld	s0,64(sp)
    80004110:	74e2                	ld	s1,56(sp)
    80004112:	7942                	ld	s2,48(sp)
    80004114:	79a2                	ld	s3,40(sp)
    80004116:	7a02                	ld	s4,32(sp)
    80004118:	6ae2                	ld	s5,24(sp)
    8000411a:	6161                	addi	sp,sp,80
    8000411c:	8082                	ret

000000008000411e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000411e:	1141                	addi	sp,sp,-16
    80004120:	e422                	sd	s0,8(sp)
    80004122:	0800                	addi	s0,sp,16
    80004124:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004126:	8905                	andi	a0,a0,1
    80004128:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000412a:	8b89                	andi	a5,a5,2
    8000412c:	c399                	beqz	a5,80004132 <flags2perm+0x14>
      perm |= PTE_W;
    8000412e:	00456513          	ori	a0,a0,4
    return perm;
}
    80004132:	6422                	ld	s0,8(sp)
    80004134:	0141                	addi	sp,sp,16
    80004136:	8082                	ret

0000000080004138 <exec>:

int
exec(char *path, char **argv)
{
    80004138:	df010113          	addi	sp,sp,-528
    8000413c:	20113423          	sd	ra,520(sp)
    80004140:	20813023          	sd	s0,512(sp)
    80004144:	ffa6                	sd	s1,504(sp)
    80004146:	fbca                	sd	s2,496(sp)
    80004148:	0c00                	addi	s0,sp,528
    8000414a:	892a                	mv	s2,a0
    8000414c:	dea43c23          	sd	a0,-520(s0)
    80004150:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004154:	ffffd097          	auipc	ra,0xffffd
    80004158:	db2080e7          	jalr	-590(ra) # 80000f06 <myproc>
    8000415c:	84aa                	mv	s1,a0

  begin_op();
    8000415e:	fffff097          	auipc	ra,0xfffff
    80004162:	43a080e7          	jalr	1082(ra) # 80003598 <begin_op>

  if((ip = namei(path)) == 0){
    80004166:	854a                	mv	a0,s2
    80004168:	fffff097          	auipc	ra,0xfffff
    8000416c:	230080e7          	jalr	560(ra) # 80003398 <namei>
    80004170:	c135                	beqz	a0,800041d4 <exec+0x9c>
    80004172:	f3d2                	sd	s4,480(sp)
    80004174:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004176:	fffff097          	auipc	ra,0xfffff
    8000417a:	a54080e7          	jalr	-1452(ra) # 80002bca <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000417e:	04000713          	li	a4,64
    80004182:	4681                	li	a3,0
    80004184:	e5040613          	addi	a2,s0,-432
    80004188:	4581                	li	a1,0
    8000418a:	8552                	mv	a0,s4
    8000418c:	fffff097          	auipc	ra,0xfffff
    80004190:	cf6080e7          	jalr	-778(ra) # 80002e82 <readi>
    80004194:	04000793          	li	a5,64
    80004198:	00f51a63          	bne	a0,a5,800041ac <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000419c:	e5042703          	lw	a4,-432(s0)
    800041a0:	464c47b7          	lui	a5,0x464c4
    800041a4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041a8:	02f70c63          	beq	a4,a5,800041e0 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041ac:	8552                	mv	a0,s4
    800041ae:	fffff097          	auipc	ra,0xfffff
    800041b2:	c82080e7          	jalr	-894(ra) # 80002e30 <iunlockput>
    end_op();
    800041b6:	fffff097          	auipc	ra,0xfffff
    800041ba:	45c080e7          	jalr	1116(ra) # 80003612 <end_op>
  }
  return -1;
    800041be:	557d                	li	a0,-1
    800041c0:	7a1e                	ld	s4,480(sp)
}
    800041c2:	20813083          	ld	ra,520(sp)
    800041c6:	20013403          	ld	s0,512(sp)
    800041ca:	74fe                	ld	s1,504(sp)
    800041cc:	795e                	ld	s2,496(sp)
    800041ce:	21010113          	addi	sp,sp,528
    800041d2:	8082                	ret
    end_op();
    800041d4:	fffff097          	auipc	ra,0xfffff
    800041d8:	43e080e7          	jalr	1086(ra) # 80003612 <end_op>
    return -1;
    800041dc:	557d                	li	a0,-1
    800041de:	b7d5                	j	800041c2 <exec+0x8a>
    800041e0:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800041e2:	8526                	mv	a0,s1
    800041e4:	ffffd097          	auipc	ra,0xffffd
    800041e8:	dea080e7          	jalr	-534(ra) # 80000fce <proc_pagetable>
    800041ec:	8b2a                	mv	s6,a0
    800041ee:	30050f63          	beqz	a0,8000450c <exec+0x3d4>
    800041f2:	f7ce                	sd	s3,488(sp)
    800041f4:	efd6                	sd	s5,472(sp)
    800041f6:	e7de                	sd	s7,456(sp)
    800041f8:	e3e2                	sd	s8,448(sp)
    800041fa:	ff66                	sd	s9,440(sp)
    800041fc:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041fe:	e7042d03          	lw	s10,-400(s0)
    80004202:	e8845783          	lhu	a5,-376(s0)
    80004206:	14078d63          	beqz	a5,80004360 <exec+0x228>
    8000420a:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000420c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000420e:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004210:	6c85                	lui	s9,0x1
    80004212:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004216:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000421a:	6a85                	lui	s5,0x1
    8000421c:	a0b5                	j	80004288 <exec+0x150>
      panic("loadseg: address should exist");
    8000421e:	00004517          	auipc	a0,0x4
    80004222:	37a50513          	addi	a0,a0,890 # 80008598 <etext+0x598>
    80004226:	00002097          	auipc	ra,0x2
    8000422a:	c0e080e7          	jalr	-1010(ra) # 80005e34 <panic>
    if(sz - i < PGSIZE)
    8000422e:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004230:	8726                	mv	a4,s1
    80004232:	012c06bb          	addw	a3,s8,s2
    80004236:	4581                	li	a1,0
    80004238:	8552                	mv	a0,s4
    8000423a:	fffff097          	auipc	ra,0xfffff
    8000423e:	c48080e7          	jalr	-952(ra) # 80002e82 <readi>
    80004242:	2501                	sext.w	a0,a0
    80004244:	28a49863          	bne	s1,a0,800044d4 <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    80004248:	012a893b          	addw	s2,s5,s2
    8000424c:	03397563          	bgeu	s2,s3,80004276 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004250:	02091593          	slli	a1,s2,0x20
    80004254:	9181                	srli	a1,a1,0x20
    80004256:	95de                	add	a1,a1,s7
    80004258:	855a                	mv	a0,s6
    8000425a:	ffffc097          	auipc	ra,0xffffc
    8000425e:	2a2080e7          	jalr	674(ra) # 800004fc <walkaddr>
    80004262:	862a                	mv	a2,a0
    if(pa == 0)
    80004264:	dd4d                	beqz	a0,8000421e <exec+0xe6>
    if(sz - i < PGSIZE)
    80004266:	412984bb          	subw	s1,s3,s2
    8000426a:	0004879b          	sext.w	a5,s1
    8000426e:	fcfcf0e3          	bgeu	s9,a5,8000422e <exec+0xf6>
    80004272:	84d6                	mv	s1,s5
    80004274:	bf6d                	j	8000422e <exec+0xf6>
    sz = sz1;
    80004276:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000427a:	2d85                	addiw	s11,s11,1
    8000427c:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004280:	e8845783          	lhu	a5,-376(s0)
    80004284:	08fdd663          	bge	s11,a5,80004310 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004288:	2d01                	sext.w	s10,s10
    8000428a:	03800713          	li	a4,56
    8000428e:	86ea                	mv	a3,s10
    80004290:	e1840613          	addi	a2,s0,-488
    80004294:	4581                	li	a1,0
    80004296:	8552                	mv	a0,s4
    80004298:	fffff097          	auipc	ra,0xfffff
    8000429c:	bea080e7          	jalr	-1046(ra) # 80002e82 <readi>
    800042a0:	03800793          	li	a5,56
    800042a4:	20f51063          	bne	a0,a5,800044a4 <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    800042a8:	e1842783          	lw	a5,-488(s0)
    800042ac:	4705                	li	a4,1
    800042ae:	fce796e3          	bne	a5,a4,8000427a <exec+0x142>
    if(ph.memsz < ph.filesz)
    800042b2:	e4043483          	ld	s1,-448(s0)
    800042b6:	e3843783          	ld	a5,-456(s0)
    800042ba:	1ef4e963          	bltu	s1,a5,800044ac <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042be:	e2843783          	ld	a5,-472(s0)
    800042c2:	94be                	add	s1,s1,a5
    800042c4:	1ef4e863          	bltu	s1,a5,800044b4 <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    800042c8:	df043703          	ld	a4,-528(s0)
    800042cc:	8ff9                	and	a5,a5,a4
    800042ce:	1e079763          	bnez	a5,800044bc <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042d2:	e1c42503          	lw	a0,-484(s0)
    800042d6:	00000097          	auipc	ra,0x0
    800042da:	e48080e7          	jalr	-440(ra) # 8000411e <flags2perm>
    800042de:	86aa                	mv	a3,a0
    800042e0:	8626                	mv	a2,s1
    800042e2:	85ca                	mv	a1,s2
    800042e4:	855a                	mv	a0,s6
    800042e6:	ffffc097          	auipc	ra,0xffffc
    800042ea:	5fe080e7          	jalr	1534(ra) # 800008e4 <uvmalloc>
    800042ee:	e0a43423          	sd	a0,-504(s0)
    800042f2:	1c050963          	beqz	a0,800044c4 <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042f6:	e2843b83          	ld	s7,-472(s0)
    800042fa:	e2042c03          	lw	s8,-480(s0)
    800042fe:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004302:	00098463          	beqz	s3,8000430a <exec+0x1d2>
    80004306:	4901                	li	s2,0
    80004308:	b7a1                	j	80004250 <exec+0x118>
    sz = sz1;
    8000430a:	e0843903          	ld	s2,-504(s0)
    8000430e:	b7b5                	j	8000427a <exec+0x142>
    80004310:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004312:	8552                	mv	a0,s4
    80004314:	fffff097          	auipc	ra,0xfffff
    80004318:	b1c080e7          	jalr	-1252(ra) # 80002e30 <iunlockput>
  end_op();
    8000431c:	fffff097          	auipc	ra,0xfffff
    80004320:	2f6080e7          	jalr	758(ra) # 80003612 <end_op>
  p = myproc();
    80004324:	ffffd097          	auipc	ra,0xffffd
    80004328:	be2080e7          	jalr	-1054(ra) # 80000f06 <myproc>
    8000432c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000432e:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004332:	6985                	lui	s3,0x1
    80004334:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004336:	99ca                	add	s3,s3,s2
    80004338:	77fd                	lui	a5,0xfffff
    8000433a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000433e:	4691                	li	a3,4
    80004340:	6609                	lui	a2,0x2
    80004342:	964e                	add	a2,a2,s3
    80004344:	85ce                	mv	a1,s3
    80004346:	855a                	mv	a0,s6
    80004348:	ffffc097          	auipc	ra,0xffffc
    8000434c:	59c080e7          	jalr	1436(ra) # 800008e4 <uvmalloc>
    80004350:	892a                	mv	s2,a0
    80004352:	e0a43423          	sd	a0,-504(s0)
    80004356:	e519                	bnez	a0,80004364 <exec+0x22c>
  if(pagetable)
    80004358:	e1343423          	sd	s3,-504(s0)
    8000435c:	4a01                	li	s4,0
    8000435e:	aaa5                	j	800044d6 <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004360:	4901                	li	s2,0
    80004362:	bf45                	j	80004312 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004364:	75f9                	lui	a1,0xffffe
    80004366:	95aa                	add	a1,a1,a0
    80004368:	855a                	mv	a0,s6
    8000436a:	ffffc097          	auipc	ra,0xffffc
    8000436e:	7b0080e7          	jalr	1968(ra) # 80000b1a <uvmclear>
  stackbase = sp - PGSIZE;
    80004372:	7bfd                	lui	s7,0xfffff
    80004374:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004376:	e0043783          	ld	a5,-512(s0)
    8000437a:	6388                	ld	a0,0(a5)
    8000437c:	c52d                	beqz	a0,800043e6 <exec+0x2ae>
    8000437e:	e9040993          	addi	s3,s0,-368
    80004382:	f9040c13          	addi	s8,s0,-112
    80004386:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004388:	ffffc097          	auipc	ra,0xffffc
    8000438c:	f66080e7          	jalr	-154(ra) # 800002ee <strlen>
    80004390:	0015079b          	addiw	a5,a0,1
    80004394:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004398:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000439c:	13796863          	bltu	s2,s7,800044cc <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043a0:	e0043d03          	ld	s10,-512(s0)
    800043a4:	000d3a03          	ld	s4,0(s10)
    800043a8:	8552                	mv	a0,s4
    800043aa:	ffffc097          	auipc	ra,0xffffc
    800043ae:	f44080e7          	jalr	-188(ra) # 800002ee <strlen>
    800043b2:	0015069b          	addiw	a3,a0,1
    800043b6:	8652                	mv	a2,s4
    800043b8:	85ca                	mv	a1,s2
    800043ba:	855a                	mv	a0,s6
    800043bc:	ffffc097          	auipc	ra,0xffffc
    800043c0:	790080e7          	jalr	1936(ra) # 80000b4c <copyout>
    800043c4:	10054663          	bltz	a0,800044d0 <exec+0x398>
    ustack[argc] = sp;
    800043c8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043cc:	0485                	addi	s1,s1,1
    800043ce:	008d0793          	addi	a5,s10,8
    800043d2:	e0f43023          	sd	a5,-512(s0)
    800043d6:	008d3503          	ld	a0,8(s10)
    800043da:	c909                	beqz	a0,800043ec <exec+0x2b4>
    if(argc >= MAXARG)
    800043dc:	09a1                	addi	s3,s3,8
    800043de:	fb8995e3          	bne	s3,s8,80004388 <exec+0x250>
  ip = 0;
    800043e2:	4a01                	li	s4,0
    800043e4:	a8cd                	j	800044d6 <exec+0x39e>
  sp = sz;
    800043e6:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800043ea:	4481                	li	s1,0
  ustack[argc] = 0;
    800043ec:	00349793          	slli	a5,s1,0x3
    800043f0:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdd200>
    800043f4:	97a2                	add	a5,a5,s0
    800043f6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043fa:	00148693          	addi	a3,s1,1
    800043fe:	068e                	slli	a3,a3,0x3
    80004400:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004404:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004408:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000440c:	f57966e3          	bltu	s2,s7,80004358 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004410:	e9040613          	addi	a2,s0,-368
    80004414:	85ca                	mv	a1,s2
    80004416:	855a                	mv	a0,s6
    80004418:	ffffc097          	auipc	ra,0xffffc
    8000441c:	734080e7          	jalr	1844(ra) # 80000b4c <copyout>
    80004420:	0e054863          	bltz	a0,80004510 <exec+0x3d8>
  p->trapframe->a1 = sp;
    80004424:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004428:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000442c:	df843783          	ld	a5,-520(s0)
    80004430:	0007c703          	lbu	a4,0(a5)
    80004434:	cf11                	beqz	a4,80004450 <exec+0x318>
    80004436:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004438:	02f00693          	li	a3,47
    8000443c:	a039                	j	8000444a <exec+0x312>
      last = s+1;
    8000443e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004442:	0785                	addi	a5,a5,1
    80004444:	fff7c703          	lbu	a4,-1(a5)
    80004448:	c701                	beqz	a4,80004450 <exec+0x318>
    if(*s == '/')
    8000444a:	fed71ce3          	bne	a4,a3,80004442 <exec+0x30a>
    8000444e:	bfc5                	j	8000443e <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    80004450:	4641                	li	a2,16
    80004452:	df843583          	ld	a1,-520(s0)
    80004456:	158a8513          	addi	a0,s5,344
    8000445a:	ffffc097          	auipc	ra,0xffffc
    8000445e:	e62080e7          	jalr	-414(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    80004462:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004466:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000446a:	e0843783          	ld	a5,-504(s0)
    8000446e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004472:	058ab783          	ld	a5,88(s5)
    80004476:	e6843703          	ld	a4,-408(s0)
    8000447a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000447c:	058ab783          	ld	a5,88(s5)
    80004480:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004484:	85e6                	mv	a1,s9
    80004486:	ffffd097          	auipc	ra,0xffffd
    8000448a:	be4080e7          	jalr	-1052(ra) # 8000106a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000448e:	0004851b          	sext.w	a0,s1
    80004492:	79be                	ld	s3,488(sp)
    80004494:	7a1e                	ld	s4,480(sp)
    80004496:	6afe                	ld	s5,472(sp)
    80004498:	6b5e                	ld	s6,464(sp)
    8000449a:	6bbe                	ld	s7,456(sp)
    8000449c:	6c1e                	ld	s8,448(sp)
    8000449e:	7cfa                	ld	s9,440(sp)
    800044a0:	7d5a                	ld	s10,432(sp)
    800044a2:	b305                	j	800041c2 <exec+0x8a>
    800044a4:	e1243423          	sd	s2,-504(s0)
    800044a8:	7dba                	ld	s11,424(sp)
    800044aa:	a035                	j	800044d6 <exec+0x39e>
    800044ac:	e1243423          	sd	s2,-504(s0)
    800044b0:	7dba                	ld	s11,424(sp)
    800044b2:	a015                	j	800044d6 <exec+0x39e>
    800044b4:	e1243423          	sd	s2,-504(s0)
    800044b8:	7dba                	ld	s11,424(sp)
    800044ba:	a831                	j	800044d6 <exec+0x39e>
    800044bc:	e1243423          	sd	s2,-504(s0)
    800044c0:	7dba                	ld	s11,424(sp)
    800044c2:	a811                	j	800044d6 <exec+0x39e>
    800044c4:	e1243423          	sd	s2,-504(s0)
    800044c8:	7dba                	ld	s11,424(sp)
    800044ca:	a031                	j	800044d6 <exec+0x39e>
  ip = 0;
    800044cc:	4a01                	li	s4,0
    800044ce:	a021                	j	800044d6 <exec+0x39e>
    800044d0:	4a01                	li	s4,0
  if(pagetable)
    800044d2:	a011                	j	800044d6 <exec+0x39e>
    800044d4:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800044d6:	e0843583          	ld	a1,-504(s0)
    800044da:	855a                	mv	a0,s6
    800044dc:	ffffd097          	auipc	ra,0xffffd
    800044e0:	b8e080e7          	jalr	-1138(ra) # 8000106a <proc_freepagetable>
  return -1;
    800044e4:	557d                	li	a0,-1
  if(ip){
    800044e6:	000a1b63          	bnez	s4,800044fc <exec+0x3c4>
    800044ea:	79be                	ld	s3,488(sp)
    800044ec:	7a1e                	ld	s4,480(sp)
    800044ee:	6afe                	ld	s5,472(sp)
    800044f0:	6b5e                	ld	s6,464(sp)
    800044f2:	6bbe                	ld	s7,456(sp)
    800044f4:	6c1e                	ld	s8,448(sp)
    800044f6:	7cfa                	ld	s9,440(sp)
    800044f8:	7d5a                	ld	s10,432(sp)
    800044fa:	b1e1                	j	800041c2 <exec+0x8a>
    800044fc:	79be                	ld	s3,488(sp)
    800044fe:	6afe                	ld	s5,472(sp)
    80004500:	6b5e                	ld	s6,464(sp)
    80004502:	6bbe                	ld	s7,456(sp)
    80004504:	6c1e                	ld	s8,448(sp)
    80004506:	7cfa                	ld	s9,440(sp)
    80004508:	7d5a                	ld	s10,432(sp)
    8000450a:	b14d                	j	800041ac <exec+0x74>
    8000450c:	6b5e                	ld	s6,464(sp)
    8000450e:	b979                	j	800041ac <exec+0x74>
  sz = sz1;
    80004510:	e0843983          	ld	s3,-504(s0)
    80004514:	b591                	j	80004358 <exec+0x220>

0000000080004516 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004516:	7179                	addi	sp,sp,-48
    80004518:	f406                	sd	ra,40(sp)
    8000451a:	f022                	sd	s0,32(sp)
    8000451c:	ec26                	sd	s1,24(sp)
    8000451e:	e84a                	sd	s2,16(sp)
    80004520:	1800                	addi	s0,sp,48
    80004522:	892e                	mv	s2,a1
    80004524:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004526:	fdc40593          	addi	a1,s0,-36
    8000452a:	ffffe097          	auipc	ra,0xffffe
    8000452e:	b00080e7          	jalr	-1280(ra) # 8000202a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004532:	fdc42703          	lw	a4,-36(s0)
    80004536:	47bd                	li	a5,15
    80004538:	02e7eb63          	bltu	a5,a4,8000456e <argfd+0x58>
    8000453c:	ffffd097          	auipc	ra,0xffffd
    80004540:	9ca080e7          	jalr	-1590(ra) # 80000f06 <myproc>
    80004544:	fdc42703          	lw	a4,-36(s0)
    80004548:	01a70793          	addi	a5,a4,26
    8000454c:	078e                	slli	a5,a5,0x3
    8000454e:	953e                	add	a0,a0,a5
    80004550:	611c                	ld	a5,0(a0)
    80004552:	c385                	beqz	a5,80004572 <argfd+0x5c>
    return -1;
  if(pfd)
    80004554:	00090463          	beqz	s2,8000455c <argfd+0x46>
    *pfd = fd;
    80004558:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000455c:	4501                	li	a0,0
  if(pf)
    8000455e:	c091                	beqz	s1,80004562 <argfd+0x4c>
    *pf = f;
    80004560:	e09c                	sd	a5,0(s1)
}
    80004562:	70a2                	ld	ra,40(sp)
    80004564:	7402                	ld	s0,32(sp)
    80004566:	64e2                	ld	s1,24(sp)
    80004568:	6942                	ld	s2,16(sp)
    8000456a:	6145                	addi	sp,sp,48
    8000456c:	8082                	ret
    return -1;
    8000456e:	557d                	li	a0,-1
    80004570:	bfcd                	j	80004562 <argfd+0x4c>
    80004572:	557d                	li	a0,-1
    80004574:	b7fd                	j	80004562 <argfd+0x4c>

0000000080004576 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004576:	1101                	addi	sp,sp,-32
    80004578:	ec06                	sd	ra,24(sp)
    8000457a:	e822                	sd	s0,16(sp)
    8000457c:	e426                	sd	s1,8(sp)
    8000457e:	1000                	addi	s0,sp,32
    80004580:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004582:	ffffd097          	auipc	ra,0xffffd
    80004586:	984080e7          	jalr	-1660(ra) # 80000f06 <myproc>
    8000458a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000458c:	0d050793          	addi	a5,a0,208
    80004590:	4501                	li	a0,0
    80004592:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004594:	6398                	ld	a4,0(a5)
    80004596:	cb19                	beqz	a4,800045ac <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004598:	2505                	addiw	a0,a0,1
    8000459a:	07a1                	addi	a5,a5,8
    8000459c:	fed51ce3          	bne	a0,a3,80004594 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045a0:	557d                	li	a0,-1
}
    800045a2:	60e2                	ld	ra,24(sp)
    800045a4:	6442                	ld	s0,16(sp)
    800045a6:	64a2                	ld	s1,8(sp)
    800045a8:	6105                	addi	sp,sp,32
    800045aa:	8082                	ret
      p->ofile[fd] = f;
    800045ac:	01a50793          	addi	a5,a0,26
    800045b0:	078e                	slli	a5,a5,0x3
    800045b2:	963e                	add	a2,a2,a5
    800045b4:	e204                	sd	s1,0(a2)
      return fd;
    800045b6:	b7f5                	j	800045a2 <fdalloc+0x2c>

00000000800045b8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045b8:	715d                	addi	sp,sp,-80
    800045ba:	e486                	sd	ra,72(sp)
    800045bc:	e0a2                	sd	s0,64(sp)
    800045be:	fc26                	sd	s1,56(sp)
    800045c0:	f84a                	sd	s2,48(sp)
    800045c2:	f44e                	sd	s3,40(sp)
    800045c4:	ec56                	sd	s5,24(sp)
    800045c6:	e85a                	sd	s6,16(sp)
    800045c8:	0880                	addi	s0,sp,80
    800045ca:	8b2e                	mv	s6,a1
    800045cc:	89b2                	mv	s3,a2
    800045ce:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045d0:	fb040593          	addi	a1,s0,-80
    800045d4:	fffff097          	auipc	ra,0xfffff
    800045d8:	de2080e7          	jalr	-542(ra) # 800033b6 <nameiparent>
    800045dc:	84aa                	mv	s1,a0
    800045de:	14050e63          	beqz	a0,8000473a <create+0x182>
    return 0;

  ilock(dp);
    800045e2:	ffffe097          	auipc	ra,0xffffe
    800045e6:	5e8080e7          	jalr	1512(ra) # 80002bca <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045ea:	4601                	li	a2,0
    800045ec:	fb040593          	addi	a1,s0,-80
    800045f0:	8526                	mv	a0,s1
    800045f2:	fffff097          	auipc	ra,0xfffff
    800045f6:	ae4080e7          	jalr	-1308(ra) # 800030d6 <dirlookup>
    800045fa:	8aaa                	mv	s5,a0
    800045fc:	c539                	beqz	a0,8000464a <create+0x92>
    iunlockput(dp);
    800045fe:	8526                	mv	a0,s1
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	830080e7          	jalr	-2000(ra) # 80002e30 <iunlockput>
    ilock(ip);
    80004608:	8556                	mv	a0,s5
    8000460a:	ffffe097          	auipc	ra,0xffffe
    8000460e:	5c0080e7          	jalr	1472(ra) # 80002bca <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004612:	4789                	li	a5,2
    80004614:	02fb1463          	bne	s6,a5,8000463c <create+0x84>
    80004618:	044ad783          	lhu	a5,68(s5)
    8000461c:	37f9                	addiw	a5,a5,-2
    8000461e:	17c2                	slli	a5,a5,0x30
    80004620:	93c1                	srli	a5,a5,0x30
    80004622:	4705                	li	a4,1
    80004624:	00f76c63          	bltu	a4,a5,8000463c <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004628:	8556                	mv	a0,s5
    8000462a:	60a6                	ld	ra,72(sp)
    8000462c:	6406                	ld	s0,64(sp)
    8000462e:	74e2                	ld	s1,56(sp)
    80004630:	7942                	ld	s2,48(sp)
    80004632:	79a2                	ld	s3,40(sp)
    80004634:	6ae2                	ld	s5,24(sp)
    80004636:	6b42                	ld	s6,16(sp)
    80004638:	6161                	addi	sp,sp,80
    8000463a:	8082                	ret
    iunlockput(ip);
    8000463c:	8556                	mv	a0,s5
    8000463e:	ffffe097          	auipc	ra,0xffffe
    80004642:	7f2080e7          	jalr	2034(ra) # 80002e30 <iunlockput>
    return 0;
    80004646:	4a81                	li	s5,0
    80004648:	b7c5                	j	80004628 <create+0x70>
    8000464a:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000464c:	85da                	mv	a1,s6
    8000464e:	4088                	lw	a0,0(s1)
    80004650:	ffffe097          	auipc	ra,0xffffe
    80004654:	3d6080e7          	jalr	982(ra) # 80002a26 <ialloc>
    80004658:	8a2a                	mv	s4,a0
    8000465a:	c531                	beqz	a0,800046a6 <create+0xee>
  ilock(ip);
    8000465c:	ffffe097          	auipc	ra,0xffffe
    80004660:	56e080e7          	jalr	1390(ra) # 80002bca <ilock>
  ip->major = major;
    80004664:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004668:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000466c:	4905                	li	s2,1
    8000466e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004672:	8552                	mv	a0,s4
    80004674:	ffffe097          	auipc	ra,0xffffe
    80004678:	48a080e7          	jalr	1162(ra) # 80002afe <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000467c:	032b0d63          	beq	s6,s2,800046b6 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004680:	004a2603          	lw	a2,4(s4)
    80004684:	fb040593          	addi	a1,s0,-80
    80004688:	8526                	mv	a0,s1
    8000468a:	fffff097          	auipc	ra,0xfffff
    8000468e:	c5c080e7          	jalr	-932(ra) # 800032e6 <dirlink>
    80004692:	08054163          	bltz	a0,80004714 <create+0x15c>
  iunlockput(dp);
    80004696:	8526                	mv	a0,s1
    80004698:	ffffe097          	auipc	ra,0xffffe
    8000469c:	798080e7          	jalr	1944(ra) # 80002e30 <iunlockput>
  return ip;
    800046a0:	8ad2                	mv	s5,s4
    800046a2:	7a02                	ld	s4,32(sp)
    800046a4:	b751                	j	80004628 <create+0x70>
    iunlockput(dp);
    800046a6:	8526                	mv	a0,s1
    800046a8:	ffffe097          	auipc	ra,0xffffe
    800046ac:	788080e7          	jalr	1928(ra) # 80002e30 <iunlockput>
    return 0;
    800046b0:	8ad2                	mv	s5,s4
    800046b2:	7a02                	ld	s4,32(sp)
    800046b4:	bf95                	j	80004628 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046b6:	004a2603          	lw	a2,4(s4)
    800046ba:	00004597          	auipc	a1,0x4
    800046be:	efe58593          	addi	a1,a1,-258 # 800085b8 <etext+0x5b8>
    800046c2:	8552                	mv	a0,s4
    800046c4:	fffff097          	auipc	ra,0xfffff
    800046c8:	c22080e7          	jalr	-990(ra) # 800032e6 <dirlink>
    800046cc:	04054463          	bltz	a0,80004714 <create+0x15c>
    800046d0:	40d0                	lw	a2,4(s1)
    800046d2:	00004597          	auipc	a1,0x4
    800046d6:	eee58593          	addi	a1,a1,-274 # 800085c0 <etext+0x5c0>
    800046da:	8552                	mv	a0,s4
    800046dc:	fffff097          	auipc	ra,0xfffff
    800046e0:	c0a080e7          	jalr	-1014(ra) # 800032e6 <dirlink>
    800046e4:	02054863          	bltz	a0,80004714 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    800046e8:	004a2603          	lw	a2,4(s4)
    800046ec:	fb040593          	addi	a1,s0,-80
    800046f0:	8526                	mv	a0,s1
    800046f2:	fffff097          	auipc	ra,0xfffff
    800046f6:	bf4080e7          	jalr	-1036(ra) # 800032e6 <dirlink>
    800046fa:	00054d63          	bltz	a0,80004714 <create+0x15c>
    dp->nlink++;  // for ".."
    800046fe:	04a4d783          	lhu	a5,74(s1)
    80004702:	2785                	addiw	a5,a5,1
    80004704:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004708:	8526                	mv	a0,s1
    8000470a:	ffffe097          	auipc	ra,0xffffe
    8000470e:	3f4080e7          	jalr	1012(ra) # 80002afe <iupdate>
    80004712:	b751                	j	80004696 <create+0xde>
  ip->nlink = 0;
    80004714:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004718:	8552                	mv	a0,s4
    8000471a:	ffffe097          	auipc	ra,0xffffe
    8000471e:	3e4080e7          	jalr	996(ra) # 80002afe <iupdate>
  iunlockput(ip);
    80004722:	8552                	mv	a0,s4
    80004724:	ffffe097          	auipc	ra,0xffffe
    80004728:	70c080e7          	jalr	1804(ra) # 80002e30 <iunlockput>
  iunlockput(dp);
    8000472c:	8526                	mv	a0,s1
    8000472e:	ffffe097          	auipc	ra,0xffffe
    80004732:	702080e7          	jalr	1794(ra) # 80002e30 <iunlockput>
  return 0;
    80004736:	7a02                	ld	s4,32(sp)
    80004738:	bdc5                	j	80004628 <create+0x70>
    return 0;
    8000473a:	8aaa                	mv	s5,a0
    8000473c:	b5f5                	j	80004628 <create+0x70>

000000008000473e <sys_dup>:
{
    8000473e:	7179                	addi	sp,sp,-48
    80004740:	f406                	sd	ra,40(sp)
    80004742:	f022                	sd	s0,32(sp)
    80004744:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004746:	fd840613          	addi	a2,s0,-40
    8000474a:	4581                	li	a1,0
    8000474c:	4501                	li	a0,0
    8000474e:	00000097          	auipc	ra,0x0
    80004752:	dc8080e7          	jalr	-568(ra) # 80004516 <argfd>
    return -1;
    80004756:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004758:	02054763          	bltz	a0,80004786 <sys_dup+0x48>
    8000475c:	ec26                	sd	s1,24(sp)
    8000475e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004760:	fd843903          	ld	s2,-40(s0)
    80004764:	854a                	mv	a0,s2
    80004766:	00000097          	auipc	ra,0x0
    8000476a:	e10080e7          	jalr	-496(ra) # 80004576 <fdalloc>
    8000476e:	84aa                	mv	s1,a0
    return -1;
    80004770:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004772:	00054f63          	bltz	a0,80004790 <sys_dup+0x52>
  filedup(f);
    80004776:	854a                	mv	a0,s2
    80004778:	fffff097          	auipc	ra,0xfffff
    8000477c:	298080e7          	jalr	664(ra) # 80003a10 <filedup>
  return fd;
    80004780:	87a6                	mv	a5,s1
    80004782:	64e2                	ld	s1,24(sp)
    80004784:	6942                	ld	s2,16(sp)
}
    80004786:	853e                	mv	a0,a5
    80004788:	70a2                	ld	ra,40(sp)
    8000478a:	7402                	ld	s0,32(sp)
    8000478c:	6145                	addi	sp,sp,48
    8000478e:	8082                	ret
    80004790:	64e2                	ld	s1,24(sp)
    80004792:	6942                	ld	s2,16(sp)
    80004794:	bfcd                	j	80004786 <sys_dup+0x48>

0000000080004796 <sys_read>:
{
    80004796:	7179                	addi	sp,sp,-48
    80004798:	f406                	sd	ra,40(sp)
    8000479a:	f022                	sd	s0,32(sp)
    8000479c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000479e:	fd840593          	addi	a1,s0,-40
    800047a2:	4505                	li	a0,1
    800047a4:	ffffe097          	auipc	ra,0xffffe
    800047a8:	8a6080e7          	jalr	-1882(ra) # 8000204a <argaddr>
  argint(2, &n);
    800047ac:	fe440593          	addi	a1,s0,-28
    800047b0:	4509                	li	a0,2
    800047b2:	ffffe097          	auipc	ra,0xffffe
    800047b6:	878080e7          	jalr	-1928(ra) # 8000202a <argint>
  if(argfd(0, 0, &f) < 0)
    800047ba:	fe840613          	addi	a2,s0,-24
    800047be:	4581                	li	a1,0
    800047c0:	4501                	li	a0,0
    800047c2:	00000097          	auipc	ra,0x0
    800047c6:	d54080e7          	jalr	-684(ra) # 80004516 <argfd>
    800047ca:	87aa                	mv	a5,a0
    return -1;
    800047cc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047ce:	0007cc63          	bltz	a5,800047e6 <sys_read+0x50>
  return fileread(f, p, n);
    800047d2:	fe442603          	lw	a2,-28(s0)
    800047d6:	fd843583          	ld	a1,-40(s0)
    800047da:	fe843503          	ld	a0,-24(s0)
    800047de:	fffff097          	auipc	ra,0xfffff
    800047e2:	3d8080e7          	jalr	984(ra) # 80003bb6 <fileread>
}
    800047e6:	70a2                	ld	ra,40(sp)
    800047e8:	7402                	ld	s0,32(sp)
    800047ea:	6145                	addi	sp,sp,48
    800047ec:	8082                	ret

00000000800047ee <sys_write>:
{
    800047ee:	7179                	addi	sp,sp,-48
    800047f0:	f406                	sd	ra,40(sp)
    800047f2:	f022                	sd	s0,32(sp)
    800047f4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047f6:	fd840593          	addi	a1,s0,-40
    800047fa:	4505                	li	a0,1
    800047fc:	ffffe097          	auipc	ra,0xffffe
    80004800:	84e080e7          	jalr	-1970(ra) # 8000204a <argaddr>
  argint(2, &n);
    80004804:	fe440593          	addi	a1,s0,-28
    80004808:	4509                	li	a0,2
    8000480a:	ffffe097          	auipc	ra,0xffffe
    8000480e:	820080e7          	jalr	-2016(ra) # 8000202a <argint>
  if(argfd(0, 0, &f) < 0)
    80004812:	fe840613          	addi	a2,s0,-24
    80004816:	4581                	li	a1,0
    80004818:	4501                	li	a0,0
    8000481a:	00000097          	auipc	ra,0x0
    8000481e:	cfc080e7          	jalr	-772(ra) # 80004516 <argfd>
    80004822:	87aa                	mv	a5,a0
    return -1;
    80004824:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004826:	0007cc63          	bltz	a5,8000483e <sys_write+0x50>
  return filewrite(f, p, n);
    8000482a:	fe442603          	lw	a2,-28(s0)
    8000482e:	fd843583          	ld	a1,-40(s0)
    80004832:	fe843503          	ld	a0,-24(s0)
    80004836:	fffff097          	auipc	ra,0xfffff
    8000483a:	452080e7          	jalr	1106(ra) # 80003c88 <filewrite>
}
    8000483e:	70a2                	ld	ra,40(sp)
    80004840:	7402                	ld	s0,32(sp)
    80004842:	6145                	addi	sp,sp,48
    80004844:	8082                	ret

0000000080004846 <sys_close>:
{
    80004846:	1101                	addi	sp,sp,-32
    80004848:	ec06                	sd	ra,24(sp)
    8000484a:	e822                	sd	s0,16(sp)
    8000484c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000484e:	fe040613          	addi	a2,s0,-32
    80004852:	fec40593          	addi	a1,s0,-20
    80004856:	4501                	li	a0,0
    80004858:	00000097          	auipc	ra,0x0
    8000485c:	cbe080e7          	jalr	-834(ra) # 80004516 <argfd>
    return -1;
    80004860:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004862:	02054463          	bltz	a0,8000488a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004866:	ffffc097          	auipc	ra,0xffffc
    8000486a:	6a0080e7          	jalr	1696(ra) # 80000f06 <myproc>
    8000486e:	fec42783          	lw	a5,-20(s0)
    80004872:	07e9                	addi	a5,a5,26
    80004874:	078e                	slli	a5,a5,0x3
    80004876:	953e                	add	a0,a0,a5
    80004878:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000487c:	fe043503          	ld	a0,-32(s0)
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	1e2080e7          	jalr	482(ra) # 80003a62 <fileclose>
  return 0;
    80004888:	4781                	li	a5,0
}
    8000488a:	853e                	mv	a0,a5
    8000488c:	60e2                	ld	ra,24(sp)
    8000488e:	6442                	ld	s0,16(sp)
    80004890:	6105                	addi	sp,sp,32
    80004892:	8082                	ret

0000000080004894 <sys_fstat>:
{
    80004894:	1101                	addi	sp,sp,-32
    80004896:	ec06                	sd	ra,24(sp)
    80004898:	e822                	sd	s0,16(sp)
    8000489a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000489c:	fe040593          	addi	a1,s0,-32
    800048a0:	4505                	li	a0,1
    800048a2:	ffffd097          	auipc	ra,0xffffd
    800048a6:	7a8080e7          	jalr	1960(ra) # 8000204a <argaddr>
  if(argfd(0, 0, &f) < 0)
    800048aa:	fe840613          	addi	a2,s0,-24
    800048ae:	4581                	li	a1,0
    800048b0:	4501                	li	a0,0
    800048b2:	00000097          	auipc	ra,0x0
    800048b6:	c64080e7          	jalr	-924(ra) # 80004516 <argfd>
    800048ba:	87aa                	mv	a5,a0
    return -1;
    800048bc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048be:	0007ca63          	bltz	a5,800048d2 <sys_fstat+0x3e>
  return filestat(f, st);
    800048c2:	fe043583          	ld	a1,-32(s0)
    800048c6:	fe843503          	ld	a0,-24(s0)
    800048ca:	fffff097          	auipc	ra,0xfffff
    800048ce:	27a080e7          	jalr	634(ra) # 80003b44 <filestat>
}
    800048d2:	60e2                	ld	ra,24(sp)
    800048d4:	6442                	ld	s0,16(sp)
    800048d6:	6105                	addi	sp,sp,32
    800048d8:	8082                	ret

00000000800048da <sys_link>:
{
    800048da:	7169                	addi	sp,sp,-304
    800048dc:	f606                	sd	ra,296(sp)
    800048de:	f222                	sd	s0,288(sp)
    800048e0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048e2:	08000613          	li	a2,128
    800048e6:	ed040593          	addi	a1,s0,-304
    800048ea:	4501                	li	a0,0
    800048ec:	ffffd097          	auipc	ra,0xffffd
    800048f0:	77e080e7          	jalr	1918(ra) # 8000206a <argstr>
    return -1;
    800048f4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048f6:	12054663          	bltz	a0,80004a22 <sys_link+0x148>
    800048fa:	08000613          	li	a2,128
    800048fe:	f5040593          	addi	a1,s0,-176
    80004902:	4505                	li	a0,1
    80004904:	ffffd097          	auipc	ra,0xffffd
    80004908:	766080e7          	jalr	1894(ra) # 8000206a <argstr>
    return -1;
    8000490c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000490e:	10054a63          	bltz	a0,80004a22 <sys_link+0x148>
    80004912:	ee26                	sd	s1,280(sp)
  begin_op();
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	c84080e7          	jalr	-892(ra) # 80003598 <begin_op>
  if((ip = namei(old)) == 0){
    8000491c:	ed040513          	addi	a0,s0,-304
    80004920:	fffff097          	auipc	ra,0xfffff
    80004924:	a78080e7          	jalr	-1416(ra) # 80003398 <namei>
    80004928:	84aa                	mv	s1,a0
    8000492a:	c949                	beqz	a0,800049bc <sys_link+0xe2>
  ilock(ip);
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	29e080e7          	jalr	670(ra) # 80002bca <ilock>
  if(ip->type == T_DIR){
    80004934:	04449703          	lh	a4,68(s1)
    80004938:	4785                	li	a5,1
    8000493a:	08f70863          	beq	a4,a5,800049ca <sys_link+0xf0>
    8000493e:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004940:	04a4d783          	lhu	a5,74(s1)
    80004944:	2785                	addiw	a5,a5,1
    80004946:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000494a:	8526                	mv	a0,s1
    8000494c:	ffffe097          	auipc	ra,0xffffe
    80004950:	1b2080e7          	jalr	434(ra) # 80002afe <iupdate>
  iunlock(ip);
    80004954:	8526                	mv	a0,s1
    80004956:	ffffe097          	auipc	ra,0xffffe
    8000495a:	33a080e7          	jalr	826(ra) # 80002c90 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000495e:	fd040593          	addi	a1,s0,-48
    80004962:	f5040513          	addi	a0,s0,-176
    80004966:	fffff097          	auipc	ra,0xfffff
    8000496a:	a50080e7          	jalr	-1456(ra) # 800033b6 <nameiparent>
    8000496e:	892a                	mv	s2,a0
    80004970:	cd35                	beqz	a0,800049ec <sys_link+0x112>
  ilock(dp);
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	258080e7          	jalr	600(ra) # 80002bca <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000497a:	00092703          	lw	a4,0(s2)
    8000497e:	409c                	lw	a5,0(s1)
    80004980:	06f71163          	bne	a4,a5,800049e2 <sys_link+0x108>
    80004984:	40d0                	lw	a2,4(s1)
    80004986:	fd040593          	addi	a1,s0,-48
    8000498a:	854a                	mv	a0,s2
    8000498c:	fffff097          	auipc	ra,0xfffff
    80004990:	95a080e7          	jalr	-1702(ra) # 800032e6 <dirlink>
    80004994:	04054763          	bltz	a0,800049e2 <sys_link+0x108>
  iunlockput(dp);
    80004998:	854a                	mv	a0,s2
    8000499a:	ffffe097          	auipc	ra,0xffffe
    8000499e:	496080e7          	jalr	1174(ra) # 80002e30 <iunlockput>
  iput(ip);
    800049a2:	8526                	mv	a0,s1
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	3e4080e7          	jalr	996(ra) # 80002d88 <iput>
  end_op();
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	c66080e7          	jalr	-922(ra) # 80003612 <end_op>
  return 0;
    800049b4:	4781                	li	a5,0
    800049b6:	64f2                	ld	s1,280(sp)
    800049b8:	6952                	ld	s2,272(sp)
    800049ba:	a0a5                	j	80004a22 <sys_link+0x148>
    end_op();
    800049bc:	fffff097          	auipc	ra,0xfffff
    800049c0:	c56080e7          	jalr	-938(ra) # 80003612 <end_op>
    return -1;
    800049c4:	57fd                	li	a5,-1
    800049c6:	64f2                	ld	s1,280(sp)
    800049c8:	a8a9                	j	80004a22 <sys_link+0x148>
    iunlockput(ip);
    800049ca:	8526                	mv	a0,s1
    800049cc:	ffffe097          	auipc	ra,0xffffe
    800049d0:	464080e7          	jalr	1124(ra) # 80002e30 <iunlockput>
    end_op();
    800049d4:	fffff097          	auipc	ra,0xfffff
    800049d8:	c3e080e7          	jalr	-962(ra) # 80003612 <end_op>
    return -1;
    800049dc:	57fd                	li	a5,-1
    800049de:	64f2                	ld	s1,280(sp)
    800049e0:	a089                	j	80004a22 <sys_link+0x148>
    iunlockput(dp);
    800049e2:	854a                	mv	a0,s2
    800049e4:	ffffe097          	auipc	ra,0xffffe
    800049e8:	44c080e7          	jalr	1100(ra) # 80002e30 <iunlockput>
  ilock(ip);
    800049ec:	8526                	mv	a0,s1
    800049ee:	ffffe097          	auipc	ra,0xffffe
    800049f2:	1dc080e7          	jalr	476(ra) # 80002bca <ilock>
  ip->nlink--;
    800049f6:	04a4d783          	lhu	a5,74(s1)
    800049fa:	37fd                	addiw	a5,a5,-1
    800049fc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a00:	8526                	mv	a0,s1
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	0fc080e7          	jalr	252(ra) # 80002afe <iupdate>
  iunlockput(ip);
    80004a0a:	8526                	mv	a0,s1
    80004a0c:	ffffe097          	auipc	ra,0xffffe
    80004a10:	424080e7          	jalr	1060(ra) # 80002e30 <iunlockput>
  end_op();
    80004a14:	fffff097          	auipc	ra,0xfffff
    80004a18:	bfe080e7          	jalr	-1026(ra) # 80003612 <end_op>
  return -1;
    80004a1c:	57fd                	li	a5,-1
    80004a1e:	64f2                	ld	s1,280(sp)
    80004a20:	6952                	ld	s2,272(sp)
}
    80004a22:	853e                	mv	a0,a5
    80004a24:	70b2                	ld	ra,296(sp)
    80004a26:	7412                	ld	s0,288(sp)
    80004a28:	6155                	addi	sp,sp,304
    80004a2a:	8082                	ret

0000000080004a2c <sys_unlink>:
{
    80004a2c:	7151                	addi	sp,sp,-240
    80004a2e:	f586                	sd	ra,232(sp)
    80004a30:	f1a2                	sd	s0,224(sp)
    80004a32:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a34:	08000613          	li	a2,128
    80004a38:	f3040593          	addi	a1,s0,-208
    80004a3c:	4501                	li	a0,0
    80004a3e:	ffffd097          	auipc	ra,0xffffd
    80004a42:	62c080e7          	jalr	1580(ra) # 8000206a <argstr>
    80004a46:	1a054a63          	bltz	a0,80004bfa <sys_unlink+0x1ce>
    80004a4a:	eda6                	sd	s1,216(sp)
  begin_op();
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	b4c080e7          	jalr	-1204(ra) # 80003598 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a54:	fb040593          	addi	a1,s0,-80
    80004a58:	f3040513          	addi	a0,s0,-208
    80004a5c:	fffff097          	auipc	ra,0xfffff
    80004a60:	95a080e7          	jalr	-1702(ra) # 800033b6 <nameiparent>
    80004a64:	84aa                	mv	s1,a0
    80004a66:	cd71                	beqz	a0,80004b42 <sys_unlink+0x116>
  ilock(dp);
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	162080e7          	jalr	354(ra) # 80002bca <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a70:	00004597          	auipc	a1,0x4
    80004a74:	b4858593          	addi	a1,a1,-1208 # 800085b8 <etext+0x5b8>
    80004a78:	fb040513          	addi	a0,s0,-80
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	640080e7          	jalr	1600(ra) # 800030bc <namecmp>
    80004a84:	14050c63          	beqz	a0,80004bdc <sys_unlink+0x1b0>
    80004a88:	00004597          	auipc	a1,0x4
    80004a8c:	b3858593          	addi	a1,a1,-1224 # 800085c0 <etext+0x5c0>
    80004a90:	fb040513          	addi	a0,s0,-80
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	628080e7          	jalr	1576(ra) # 800030bc <namecmp>
    80004a9c:	14050063          	beqz	a0,80004bdc <sys_unlink+0x1b0>
    80004aa0:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004aa2:	f2c40613          	addi	a2,s0,-212
    80004aa6:	fb040593          	addi	a1,s0,-80
    80004aaa:	8526                	mv	a0,s1
    80004aac:	ffffe097          	auipc	ra,0xffffe
    80004ab0:	62a080e7          	jalr	1578(ra) # 800030d6 <dirlookup>
    80004ab4:	892a                	mv	s2,a0
    80004ab6:	12050263          	beqz	a0,80004bda <sys_unlink+0x1ae>
  ilock(ip);
    80004aba:	ffffe097          	auipc	ra,0xffffe
    80004abe:	110080e7          	jalr	272(ra) # 80002bca <ilock>
  if(ip->nlink < 1)
    80004ac2:	04a91783          	lh	a5,74(s2)
    80004ac6:	08f05563          	blez	a5,80004b50 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004aca:	04491703          	lh	a4,68(s2)
    80004ace:	4785                	li	a5,1
    80004ad0:	08f70963          	beq	a4,a5,80004b62 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004ad4:	4641                	li	a2,16
    80004ad6:	4581                	li	a1,0
    80004ad8:	fc040513          	addi	a0,s0,-64
    80004adc:	ffffb097          	auipc	ra,0xffffb
    80004ae0:	69e080e7          	jalr	1694(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ae4:	4741                	li	a4,16
    80004ae6:	f2c42683          	lw	a3,-212(s0)
    80004aea:	fc040613          	addi	a2,s0,-64
    80004aee:	4581                	li	a1,0
    80004af0:	8526                	mv	a0,s1
    80004af2:	ffffe097          	auipc	ra,0xffffe
    80004af6:	4a0080e7          	jalr	1184(ra) # 80002f92 <writei>
    80004afa:	47c1                	li	a5,16
    80004afc:	0af51b63          	bne	a0,a5,80004bb2 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004b00:	04491703          	lh	a4,68(s2)
    80004b04:	4785                	li	a5,1
    80004b06:	0af70f63          	beq	a4,a5,80004bc4 <sys_unlink+0x198>
  iunlockput(dp);
    80004b0a:	8526                	mv	a0,s1
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	324080e7          	jalr	804(ra) # 80002e30 <iunlockput>
  ip->nlink--;
    80004b14:	04a95783          	lhu	a5,74(s2)
    80004b18:	37fd                	addiw	a5,a5,-1
    80004b1a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b1e:	854a                	mv	a0,s2
    80004b20:	ffffe097          	auipc	ra,0xffffe
    80004b24:	fde080e7          	jalr	-34(ra) # 80002afe <iupdate>
  iunlockput(ip);
    80004b28:	854a                	mv	a0,s2
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	306080e7          	jalr	774(ra) # 80002e30 <iunlockput>
  end_op();
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	ae0080e7          	jalr	-1312(ra) # 80003612 <end_op>
  return 0;
    80004b3a:	4501                	li	a0,0
    80004b3c:	64ee                	ld	s1,216(sp)
    80004b3e:	694e                	ld	s2,208(sp)
    80004b40:	a84d                	j	80004bf2 <sys_unlink+0x1c6>
    end_op();
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	ad0080e7          	jalr	-1328(ra) # 80003612 <end_op>
    return -1;
    80004b4a:	557d                	li	a0,-1
    80004b4c:	64ee                	ld	s1,216(sp)
    80004b4e:	a055                	j	80004bf2 <sys_unlink+0x1c6>
    80004b50:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004b52:	00004517          	auipc	a0,0x4
    80004b56:	a7650513          	addi	a0,a0,-1418 # 800085c8 <etext+0x5c8>
    80004b5a:	00001097          	auipc	ra,0x1
    80004b5e:	2da080e7          	jalr	730(ra) # 80005e34 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b62:	04c92703          	lw	a4,76(s2)
    80004b66:	02000793          	li	a5,32
    80004b6a:	f6e7f5e3          	bgeu	a5,a4,80004ad4 <sys_unlink+0xa8>
    80004b6e:	e5ce                	sd	s3,200(sp)
    80004b70:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b74:	4741                	li	a4,16
    80004b76:	86ce                	mv	a3,s3
    80004b78:	f1840613          	addi	a2,s0,-232
    80004b7c:	4581                	li	a1,0
    80004b7e:	854a                	mv	a0,s2
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	302080e7          	jalr	770(ra) # 80002e82 <readi>
    80004b88:	47c1                	li	a5,16
    80004b8a:	00f51c63          	bne	a0,a5,80004ba2 <sys_unlink+0x176>
    if(de.inum != 0)
    80004b8e:	f1845783          	lhu	a5,-232(s0)
    80004b92:	e7b5                	bnez	a5,80004bfe <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b94:	29c1                	addiw	s3,s3,16
    80004b96:	04c92783          	lw	a5,76(s2)
    80004b9a:	fcf9ede3          	bltu	s3,a5,80004b74 <sys_unlink+0x148>
    80004b9e:	69ae                	ld	s3,200(sp)
    80004ba0:	bf15                	j	80004ad4 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004ba2:	00004517          	auipc	a0,0x4
    80004ba6:	a3e50513          	addi	a0,a0,-1474 # 800085e0 <etext+0x5e0>
    80004baa:	00001097          	auipc	ra,0x1
    80004bae:	28a080e7          	jalr	650(ra) # 80005e34 <panic>
    80004bb2:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004bb4:	00004517          	auipc	a0,0x4
    80004bb8:	a4450513          	addi	a0,a0,-1468 # 800085f8 <etext+0x5f8>
    80004bbc:	00001097          	auipc	ra,0x1
    80004bc0:	278080e7          	jalr	632(ra) # 80005e34 <panic>
    dp->nlink--;
    80004bc4:	04a4d783          	lhu	a5,74(s1)
    80004bc8:	37fd                	addiw	a5,a5,-1
    80004bca:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bce:	8526                	mv	a0,s1
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	f2e080e7          	jalr	-210(ra) # 80002afe <iupdate>
    80004bd8:	bf0d                	j	80004b0a <sys_unlink+0xde>
    80004bda:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004bdc:	8526                	mv	a0,s1
    80004bde:	ffffe097          	auipc	ra,0xffffe
    80004be2:	252080e7          	jalr	594(ra) # 80002e30 <iunlockput>
  end_op();
    80004be6:	fffff097          	auipc	ra,0xfffff
    80004bea:	a2c080e7          	jalr	-1492(ra) # 80003612 <end_op>
  return -1;
    80004bee:	557d                	li	a0,-1
    80004bf0:	64ee                	ld	s1,216(sp)
}
    80004bf2:	70ae                	ld	ra,232(sp)
    80004bf4:	740e                	ld	s0,224(sp)
    80004bf6:	616d                	addi	sp,sp,240
    80004bf8:	8082                	ret
    return -1;
    80004bfa:	557d                	li	a0,-1
    80004bfc:	bfdd                	j	80004bf2 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004bfe:	854a                	mv	a0,s2
    80004c00:	ffffe097          	auipc	ra,0xffffe
    80004c04:	230080e7          	jalr	560(ra) # 80002e30 <iunlockput>
    goto bad;
    80004c08:	694e                	ld	s2,208(sp)
    80004c0a:	69ae                	ld	s3,200(sp)
    80004c0c:	bfc1                	j	80004bdc <sys_unlink+0x1b0>

0000000080004c0e <sys_open>:

uint64
sys_open(void)
{
    80004c0e:	7131                	addi	sp,sp,-192
    80004c10:	fd06                	sd	ra,184(sp)
    80004c12:	f922                	sd	s0,176(sp)
    80004c14:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c16:	f4c40593          	addi	a1,s0,-180
    80004c1a:	4505                	li	a0,1
    80004c1c:	ffffd097          	auipc	ra,0xffffd
    80004c20:	40e080e7          	jalr	1038(ra) # 8000202a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c24:	08000613          	li	a2,128
    80004c28:	f5040593          	addi	a1,s0,-176
    80004c2c:	4501                	li	a0,0
    80004c2e:	ffffd097          	auipc	ra,0xffffd
    80004c32:	43c080e7          	jalr	1084(ra) # 8000206a <argstr>
    80004c36:	87aa                	mv	a5,a0
    return -1;
    80004c38:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c3a:	0a07ce63          	bltz	a5,80004cf6 <sys_open+0xe8>
    80004c3e:	f526                	sd	s1,168(sp)

  begin_op();
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	958080e7          	jalr	-1704(ra) # 80003598 <begin_op>

  if(omode & O_CREATE){
    80004c48:	f4c42783          	lw	a5,-180(s0)
    80004c4c:	2007f793          	andi	a5,a5,512
    80004c50:	cfd5                	beqz	a5,80004d0c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c52:	4681                	li	a3,0
    80004c54:	4601                	li	a2,0
    80004c56:	4589                	li	a1,2
    80004c58:	f5040513          	addi	a0,s0,-176
    80004c5c:	00000097          	auipc	ra,0x0
    80004c60:	95c080e7          	jalr	-1700(ra) # 800045b8 <create>
    80004c64:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c66:	cd41                	beqz	a0,80004cfe <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c68:	04449703          	lh	a4,68(s1)
    80004c6c:	478d                	li	a5,3
    80004c6e:	00f71763          	bne	a4,a5,80004c7c <sys_open+0x6e>
    80004c72:	0464d703          	lhu	a4,70(s1)
    80004c76:	47a5                	li	a5,9
    80004c78:	0ee7e163          	bltu	a5,a4,80004d5a <sys_open+0x14c>
    80004c7c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	d28080e7          	jalr	-728(ra) # 800039a6 <filealloc>
    80004c86:	892a                	mv	s2,a0
    80004c88:	c97d                	beqz	a0,80004d7e <sys_open+0x170>
    80004c8a:	ed4e                	sd	s3,152(sp)
    80004c8c:	00000097          	auipc	ra,0x0
    80004c90:	8ea080e7          	jalr	-1814(ra) # 80004576 <fdalloc>
    80004c94:	89aa                	mv	s3,a0
    80004c96:	0c054e63          	bltz	a0,80004d72 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c9a:	04449703          	lh	a4,68(s1)
    80004c9e:	478d                	li	a5,3
    80004ca0:	0ef70c63          	beq	a4,a5,80004d98 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ca4:	4789                	li	a5,2
    80004ca6:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004caa:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004cae:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004cb2:	f4c42783          	lw	a5,-180(s0)
    80004cb6:	0017c713          	xori	a4,a5,1
    80004cba:	8b05                	andi	a4,a4,1
    80004cbc:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cc0:	0037f713          	andi	a4,a5,3
    80004cc4:	00e03733          	snez	a4,a4
    80004cc8:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004ccc:	4007f793          	andi	a5,a5,1024
    80004cd0:	c791                	beqz	a5,80004cdc <sys_open+0xce>
    80004cd2:	04449703          	lh	a4,68(s1)
    80004cd6:	4789                	li	a5,2
    80004cd8:	0cf70763          	beq	a4,a5,80004da6 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004cdc:	8526                	mv	a0,s1
    80004cde:	ffffe097          	auipc	ra,0xffffe
    80004ce2:	fb2080e7          	jalr	-78(ra) # 80002c90 <iunlock>
  end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	92c080e7          	jalr	-1748(ra) # 80003612 <end_op>

  return fd;
    80004cee:	854e                	mv	a0,s3
    80004cf0:	74aa                	ld	s1,168(sp)
    80004cf2:	790a                	ld	s2,160(sp)
    80004cf4:	69ea                	ld	s3,152(sp)
}
    80004cf6:	70ea                	ld	ra,184(sp)
    80004cf8:	744a                	ld	s0,176(sp)
    80004cfa:	6129                	addi	sp,sp,192
    80004cfc:	8082                	ret
      end_op();
    80004cfe:	fffff097          	auipc	ra,0xfffff
    80004d02:	914080e7          	jalr	-1772(ra) # 80003612 <end_op>
      return -1;
    80004d06:	557d                	li	a0,-1
    80004d08:	74aa                	ld	s1,168(sp)
    80004d0a:	b7f5                	j	80004cf6 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004d0c:	f5040513          	addi	a0,s0,-176
    80004d10:	ffffe097          	auipc	ra,0xffffe
    80004d14:	688080e7          	jalr	1672(ra) # 80003398 <namei>
    80004d18:	84aa                	mv	s1,a0
    80004d1a:	c90d                	beqz	a0,80004d4c <sys_open+0x13e>
    ilock(ip);
    80004d1c:	ffffe097          	auipc	ra,0xffffe
    80004d20:	eae080e7          	jalr	-338(ra) # 80002bca <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d24:	04449703          	lh	a4,68(s1)
    80004d28:	4785                	li	a5,1
    80004d2a:	f2f71fe3          	bne	a4,a5,80004c68 <sys_open+0x5a>
    80004d2e:	f4c42783          	lw	a5,-180(s0)
    80004d32:	d7a9                	beqz	a5,80004c7c <sys_open+0x6e>
      iunlockput(ip);
    80004d34:	8526                	mv	a0,s1
    80004d36:	ffffe097          	auipc	ra,0xffffe
    80004d3a:	0fa080e7          	jalr	250(ra) # 80002e30 <iunlockput>
      end_op();
    80004d3e:	fffff097          	auipc	ra,0xfffff
    80004d42:	8d4080e7          	jalr	-1836(ra) # 80003612 <end_op>
      return -1;
    80004d46:	557d                	li	a0,-1
    80004d48:	74aa                	ld	s1,168(sp)
    80004d4a:	b775                	j	80004cf6 <sys_open+0xe8>
      end_op();
    80004d4c:	fffff097          	auipc	ra,0xfffff
    80004d50:	8c6080e7          	jalr	-1850(ra) # 80003612 <end_op>
      return -1;
    80004d54:	557d                	li	a0,-1
    80004d56:	74aa                	ld	s1,168(sp)
    80004d58:	bf79                	j	80004cf6 <sys_open+0xe8>
    iunlockput(ip);
    80004d5a:	8526                	mv	a0,s1
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	0d4080e7          	jalr	212(ra) # 80002e30 <iunlockput>
    end_op();
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	8ae080e7          	jalr	-1874(ra) # 80003612 <end_op>
    return -1;
    80004d6c:	557d                	li	a0,-1
    80004d6e:	74aa                	ld	s1,168(sp)
    80004d70:	b759                	j	80004cf6 <sys_open+0xe8>
      fileclose(f);
    80004d72:	854a                	mv	a0,s2
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	cee080e7          	jalr	-786(ra) # 80003a62 <fileclose>
    80004d7c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004d7e:	8526                	mv	a0,s1
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	0b0080e7          	jalr	176(ra) # 80002e30 <iunlockput>
    end_op();
    80004d88:	fffff097          	auipc	ra,0xfffff
    80004d8c:	88a080e7          	jalr	-1910(ra) # 80003612 <end_op>
    return -1;
    80004d90:	557d                	li	a0,-1
    80004d92:	74aa                	ld	s1,168(sp)
    80004d94:	790a                	ld	s2,160(sp)
    80004d96:	b785                	j	80004cf6 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004d98:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004d9c:	04649783          	lh	a5,70(s1)
    80004da0:	02f91223          	sh	a5,36(s2)
    80004da4:	b729                	j	80004cae <sys_open+0xa0>
    itrunc(ip);
    80004da6:	8526                	mv	a0,s1
    80004da8:	ffffe097          	auipc	ra,0xffffe
    80004dac:	f34080e7          	jalr	-204(ra) # 80002cdc <itrunc>
    80004db0:	b735                	j	80004cdc <sys_open+0xce>

0000000080004db2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004db2:	7175                	addi	sp,sp,-144
    80004db4:	e506                	sd	ra,136(sp)
    80004db6:	e122                	sd	s0,128(sp)
    80004db8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	7de080e7          	jalr	2014(ra) # 80003598 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dc2:	08000613          	li	a2,128
    80004dc6:	f7040593          	addi	a1,s0,-144
    80004dca:	4501                	li	a0,0
    80004dcc:	ffffd097          	auipc	ra,0xffffd
    80004dd0:	29e080e7          	jalr	670(ra) # 8000206a <argstr>
    80004dd4:	02054963          	bltz	a0,80004e06 <sys_mkdir+0x54>
    80004dd8:	4681                	li	a3,0
    80004dda:	4601                	li	a2,0
    80004ddc:	4585                	li	a1,1
    80004dde:	f7040513          	addi	a0,s0,-144
    80004de2:	fffff097          	auipc	ra,0xfffff
    80004de6:	7d6080e7          	jalr	2006(ra) # 800045b8 <create>
    80004dea:	cd11                	beqz	a0,80004e06 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	044080e7          	jalr	68(ra) # 80002e30 <iunlockput>
  end_op();
    80004df4:	fffff097          	auipc	ra,0xfffff
    80004df8:	81e080e7          	jalr	-2018(ra) # 80003612 <end_op>
  return 0;
    80004dfc:	4501                	li	a0,0
}
    80004dfe:	60aa                	ld	ra,136(sp)
    80004e00:	640a                	ld	s0,128(sp)
    80004e02:	6149                	addi	sp,sp,144
    80004e04:	8082                	ret
    end_op();
    80004e06:	fffff097          	auipc	ra,0xfffff
    80004e0a:	80c080e7          	jalr	-2036(ra) # 80003612 <end_op>
    return -1;
    80004e0e:	557d                	li	a0,-1
    80004e10:	b7fd                	j	80004dfe <sys_mkdir+0x4c>

0000000080004e12 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e12:	7135                	addi	sp,sp,-160
    80004e14:	ed06                	sd	ra,152(sp)
    80004e16:	e922                	sd	s0,144(sp)
    80004e18:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e1a:	ffffe097          	auipc	ra,0xffffe
    80004e1e:	77e080e7          	jalr	1918(ra) # 80003598 <begin_op>
  argint(1, &major);
    80004e22:	f6c40593          	addi	a1,s0,-148
    80004e26:	4505                	li	a0,1
    80004e28:	ffffd097          	auipc	ra,0xffffd
    80004e2c:	202080e7          	jalr	514(ra) # 8000202a <argint>
  argint(2, &minor);
    80004e30:	f6840593          	addi	a1,s0,-152
    80004e34:	4509                	li	a0,2
    80004e36:	ffffd097          	auipc	ra,0xffffd
    80004e3a:	1f4080e7          	jalr	500(ra) # 8000202a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e3e:	08000613          	li	a2,128
    80004e42:	f7040593          	addi	a1,s0,-144
    80004e46:	4501                	li	a0,0
    80004e48:	ffffd097          	auipc	ra,0xffffd
    80004e4c:	222080e7          	jalr	546(ra) # 8000206a <argstr>
    80004e50:	02054b63          	bltz	a0,80004e86 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e54:	f6841683          	lh	a3,-152(s0)
    80004e58:	f6c41603          	lh	a2,-148(s0)
    80004e5c:	458d                	li	a1,3
    80004e5e:	f7040513          	addi	a0,s0,-144
    80004e62:	fffff097          	auipc	ra,0xfffff
    80004e66:	756080e7          	jalr	1878(ra) # 800045b8 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e6a:	cd11                	beqz	a0,80004e86 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e6c:	ffffe097          	auipc	ra,0xffffe
    80004e70:	fc4080e7          	jalr	-60(ra) # 80002e30 <iunlockput>
  end_op();
    80004e74:	ffffe097          	auipc	ra,0xffffe
    80004e78:	79e080e7          	jalr	1950(ra) # 80003612 <end_op>
  return 0;
    80004e7c:	4501                	li	a0,0
}
    80004e7e:	60ea                	ld	ra,152(sp)
    80004e80:	644a                	ld	s0,144(sp)
    80004e82:	610d                	addi	sp,sp,160
    80004e84:	8082                	ret
    end_op();
    80004e86:	ffffe097          	auipc	ra,0xffffe
    80004e8a:	78c080e7          	jalr	1932(ra) # 80003612 <end_op>
    return -1;
    80004e8e:	557d                	li	a0,-1
    80004e90:	b7fd                	j	80004e7e <sys_mknod+0x6c>

0000000080004e92 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e92:	7135                	addi	sp,sp,-160
    80004e94:	ed06                	sd	ra,152(sp)
    80004e96:	e922                	sd	s0,144(sp)
    80004e98:	e14a                	sd	s2,128(sp)
    80004e9a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e9c:	ffffc097          	auipc	ra,0xffffc
    80004ea0:	06a080e7          	jalr	106(ra) # 80000f06 <myproc>
    80004ea4:	892a                	mv	s2,a0
  
  begin_op();
    80004ea6:	ffffe097          	auipc	ra,0xffffe
    80004eaa:	6f2080e7          	jalr	1778(ra) # 80003598 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004eae:	08000613          	li	a2,128
    80004eb2:	f6040593          	addi	a1,s0,-160
    80004eb6:	4501                	li	a0,0
    80004eb8:	ffffd097          	auipc	ra,0xffffd
    80004ebc:	1b2080e7          	jalr	434(ra) # 8000206a <argstr>
    80004ec0:	04054d63          	bltz	a0,80004f1a <sys_chdir+0x88>
    80004ec4:	e526                	sd	s1,136(sp)
    80004ec6:	f6040513          	addi	a0,s0,-160
    80004eca:	ffffe097          	auipc	ra,0xffffe
    80004ece:	4ce080e7          	jalr	1230(ra) # 80003398 <namei>
    80004ed2:	84aa                	mv	s1,a0
    80004ed4:	c131                	beqz	a0,80004f18 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ed6:	ffffe097          	auipc	ra,0xffffe
    80004eda:	cf4080e7          	jalr	-780(ra) # 80002bca <ilock>
  if(ip->type != T_DIR){
    80004ede:	04449703          	lh	a4,68(s1)
    80004ee2:	4785                	li	a5,1
    80004ee4:	04f71163          	bne	a4,a5,80004f26 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ee8:	8526                	mv	a0,s1
    80004eea:	ffffe097          	auipc	ra,0xffffe
    80004eee:	da6080e7          	jalr	-602(ra) # 80002c90 <iunlock>
  iput(p->cwd);
    80004ef2:	15093503          	ld	a0,336(s2)
    80004ef6:	ffffe097          	auipc	ra,0xffffe
    80004efa:	e92080e7          	jalr	-366(ra) # 80002d88 <iput>
  end_op();
    80004efe:	ffffe097          	auipc	ra,0xffffe
    80004f02:	714080e7          	jalr	1812(ra) # 80003612 <end_op>
  p->cwd = ip;
    80004f06:	14993823          	sd	s1,336(s2)
  return 0;
    80004f0a:	4501                	li	a0,0
    80004f0c:	64aa                	ld	s1,136(sp)
}
    80004f0e:	60ea                	ld	ra,152(sp)
    80004f10:	644a                	ld	s0,144(sp)
    80004f12:	690a                	ld	s2,128(sp)
    80004f14:	610d                	addi	sp,sp,160
    80004f16:	8082                	ret
    80004f18:	64aa                	ld	s1,136(sp)
    end_op();
    80004f1a:	ffffe097          	auipc	ra,0xffffe
    80004f1e:	6f8080e7          	jalr	1784(ra) # 80003612 <end_op>
    return -1;
    80004f22:	557d                	li	a0,-1
    80004f24:	b7ed                	j	80004f0e <sys_chdir+0x7c>
    iunlockput(ip);
    80004f26:	8526                	mv	a0,s1
    80004f28:	ffffe097          	auipc	ra,0xffffe
    80004f2c:	f08080e7          	jalr	-248(ra) # 80002e30 <iunlockput>
    end_op();
    80004f30:	ffffe097          	auipc	ra,0xffffe
    80004f34:	6e2080e7          	jalr	1762(ra) # 80003612 <end_op>
    return -1;
    80004f38:	557d                	li	a0,-1
    80004f3a:	64aa                	ld	s1,136(sp)
    80004f3c:	bfc9                	j	80004f0e <sys_chdir+0x7c>

0000000080004f3e <sys_exec>:

uint64
sys_exec(void)
{
    80004f3e:	7121                	addi	sp,sp,-448
    80004f40:	ff06                	sd	ra,440(sp)
    80004f42:	fb22                	sd	s0,432(sp)
    80004f44:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f46:	e4840593          	addi	a1,s0,-440
    80004f4a:	4505                	li	a0,1
    80004f4c:	ffffd097          	auipc	ra,0xffffd
    80004f50:	0fe080e7          	jalr	254(ra) # 8000204a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f54:	08000613          	li	a2,128
    80004f58:	f5040593          	addi	a1,s0,-176
    80004f5c:	4501                	li	a0,0
    80004f5e:	ffffd097          	auipc	ra,0xffffd
    80004f62:	10c080e7          	jalr	268(ra) # 8000206a <argstr>
    80004f66:	87aa                	mv	a5,a0
    return -1;
    80004f68:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f6a:	0e07c263          	bltz	a5,8000504e <sys_exec+0x110>
    80004f6e:	f726                	sd	s1,424(sp)
    80004f70:	f34a                	sd	s2,416(sp)
    80004f72:	ef4e                	sd	s3,408(sp)
    80004f74:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004f76:	10000613          	li	a2,256
    80004f7a:	4581                	li	a1,0
    80004f7c:	e5040513          	addi	a0,s0,-432
    80004f80:	ffffb097          	auipc	ra,0xffffb
    80004f84:	1fa080e7          	jalr	506(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f88:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004f8c:	89a6                	mv	s3,s1
    80004f8e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f90:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f94:	00391513          	slli	a0,s2,0x3
    80004f98:	e4040593          	addi	a1,s0,-448
    80004f9c:	e4843783          	ld	a5,-440(s0)
    80004fa0:	953e                	add	a0,a0,a5
    80004fa2:	ffffd097          	auipc	ra,0xffffd
    80004fa6:	fea080e7          	jalr	-22(ra) # 80001f8c <fetchaddr>
    80004faa:	02054a63          	bltz	a0,80004fde <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004fae:	e4043783          	ld	a5,-448(s0)
    80004fb2:	c7b9                	beqz	a5,80005000 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fb4:	ffffb097          	auipc	ra,0xffffb
    80004fb8:	166080e7          	jalr	358(ra) # 8000011a <kalloc>
    80004fbc:	85aa                	mv	a1,a0
    80004fbe:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fc2:	cd11                	beqz	a0,80004fde <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fc4:	6605                	lui	a2,0x1
    80004fc6:	e4043503          	ld	a0,-448(s0)
    80004fca:	ffffd097          	auipc	ra,0xffffd
    80004fce:	014080e7          	jalr	20(ra) # 80001fde <fetchstr>
    80004fd2:	00054663          	bltz	a0,80004fde <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004fd6:	0905                	addi	s2,s2,1
    80004fd8:	09a1                	addi	s3,s3,8
    80004fda:	fb491de3          	bne	s2,s4,80004f94 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fde:	f5040913          	addi	s2,s0,-176
    80004fe2:	6088                	ld	a0,0(s1)
    80004fe4:	c125                	beqz	a0,80005044 <sys_exec+0x106>
    kfree(argv[i]);
    80004fe6:	ffffb097          	auipc	ra,0xffffb
    80004fea:	036080e7          	jalr	54(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fee:	04a1                	addi	s1,s1,8
    80004ff0:	ff2499e3          	bne	s1,s2,80004fe2 <sys_exec+0xa4>
  return -1;
    80004ff4:	557d                	li	a0,-1
    80004ff6:	74ba                	ld	s1,424(sp)
    80004ff8:	791a                	ld	s2,416(sp)
    80004ffa:	69fa                	ld	s3,408(sp)
    80004ffc:	6a5a                	ld	s4,400(sp)
    80004ffe:	a881                	j	8000504e <sys_exec+0x110>
      argv[i] = 0;
    80005000:	0009079b          	sext.w	a5,s2
    80005004:	078e                	slli	a5,a5,0x3
    80005006:	fd078793          	addi	a5,a5,-48
    8000500a:	97a2                	add	a5,a5,s0
    8000500c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005010:	e5040593          	addi	a1,s0,-432
    80005014:	f5040513          	addi	a0,s0,-176
    80005018:	fffff097          	auipc	ra,0xfffff
    8000501c:	120080e7          	jalr	288(ra) # 80004138 <exec>
    80005020:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005022:	f5040993          	addi	s3,s0,-176
    80005026:	6088                	ld	a0,0(s1)
    80005028:	c901                	beqz	a0,80005038 <sys_exec+0xfa>
    kfree(argv[i]);
    8000502a:	ffffb097          	auipc	ra,0xffffb
    8000502e:	ff2080e7          	jalr	-14(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005032:	04a1                	addi	s1,s1,8
    80005034:	ff3499e3          	bne	s1,s3,80005026 <sys_exec+0xe8>
  return ret;
    80005038:	854a                	mv	a0,s2
    8000503a:	74ba                	ld	s1,424(sp)
    8000503c:	791a                	ld	s2,416(sp)
    8000503e:	69fa                	ld	s3,408(sp)
    80005040:	6a5a                	ld	s4,400(sp)
    80005042:	a031                	j	8000504e <sys_exec+0x110>
  return -1;
    80005044:	557d                	li	a0,-1
    80005046:	74ba                	ld	s1,424(sp)
    80005048:	791a                	ld	s2,416(sp)
    8000504a:	69fa                	ld	s3,408(sp)
    8000504c:	6a5a                	ld	s4,400(sp)
}
    8000504e:	70fa                	ld	ra,440(sp)
    80005050:	745a                	ld	s0,432(sp)
    80005052:	6139                	addi	sp,sp,448
    80005054:	8082                	ret

0000000080005056 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005056:	7139                	addi	sp,sp,-64
    80005058:	fc06                	sd	ra,56(sp)
    8000505a:	f822                	sd	s0,48(sp)
    8000505c:	f426                	sd	s1,40(sp)
    8000505e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005060:	ffffc097          	auipc	ra,0xffffc
    80005064:	ea6080e7          	jalr	-346(ra) # 80000f06 <myproc>
    80005068:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000506a:	fd840593          	addi	a1,s0,-40
    8000506e:	4501                	li	a0,0
    80005070:	ffffd097          	auipc	ra,0xffffd
    80005074:	fda080e7          	jalr	-38(ra) # 8000204a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005078:	fc840593          	addi	a1,s0,-56
    8000507c:	fd040513          	addi	a0,s0,-48
    80005080:	fffff097          	auipc	ra,0xfffff
    80005084:	d50080e7          	jalr	-688(ra) # 80003dd0 <pipealloc>
    return -1;
    80005088:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000508a:	0c054463          	bltz	a0,80005152 <sys_pipe+0xfc>
  fd0 = -1;
    8000508e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005092:	fd043503          	ld	a0,-48(s0)
    80005096:	fffff097          	auipc	ra,0xfffff
    8000509a:	4e0080e7          	jalr	1248(ra) # 80004576 <fdalloc>
    8000509e:	fca42223          	sw	a0,-60(s0)
    800050a2:	08054b63          	bltz	a0,80005138 <sys_pipe+0xe2>
    800050a6:	fc843503          	ld	a0,-56(s0)
    800050aa:	fffff097          	auipc	ra,0xfffff
    800050ae:	4cc080e7          	jalr	1228(ra) # 80004576 <fdalloc>
    800050b2:	fca42023          	sw	a0,-64(s0)
    800050b6:	06054863          	bltz	a0,80005126 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ba:	4691                	li	a3,4
    800050bc:	fc440613          	addi	a2,s0,-60
    800050c0:	fd843583          	ld	a1,-40(s0)
    800050c4:	68a8                	ld	a0,80(s1)
    800050c6:	ffffc097          	auipc	ra,0xffffc
    800050ca:	a86080e7          	jalr	-1402(ra) # 80000b4c <copyout>
    800050ce:	02054063          	bltz	a0,800050ee <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050d2:	4691                	li	a3,4
    800050d4:	fc040613          	addi	a2,s0,-64
    800050d8:	fd843583          	ld	a1,-40(s0)
    800050dc:	0591                	addi	a1,a1,4
    800050de:	68a8                	ld	a0,80(s1)
    800050e0:	ffffc097          	auipc	ra,0xffffc
    800050e4:	a6c080e7          	jalr	-1428(ra) # 80000b4c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050e8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ea:	06055463          	bgez	a0,80005152 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800050ee:	fc442783          	lw	a5,-60(s0)
    800050f2:	07e9                	addi	a5,a5,26
    800050f4:	078e                	slli	a5,a5,0x3
    800050f6:	97a6                	add	a5,a5,s1
    800050f8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050fc:	fc042783          	lw	a5,-64(s0)
    80005100:	07e9                	addi	a5,a5,26
    80005102:	078e                	slli	a5,a5,0x3
    80005104:	94be                	add	s1,s1,a5
    80005106:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000510a:	fd043503          	ld	a0,-48(s0)
    8000510e:	fffff097          	auipc	ra,0xfffff
    80005112:	954080e7          	jalr	-1708(ra) # 80003a62 <fileclose>
    fileclose(wf);
    80005116:	fc843503          	ld	a0,-56(s0)
    8000511a:	fffff097          	auipc	ra,0xfffff
    8000511e:	948080e7          	jalr	-1720(ra) # 80003a62 <fileclose>
    return -1;
    80005122:	57fd                	li	a5,-1
    80005124:	a03d                	j	80005152 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005126:	fc442783          	lw	a5,-60(s0)
    8000512a:	0007c763          	bltz	a5,80005138 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000512e:	07e9                	addi	a5,a5,26
    80005130:	078e                	slli	a5,a5,0x3
    80005132:	97a6                	add	a5,a5,s1
    80005134:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005138:	fd043503          	ld	a0,-48(s0)
    8000513c:	fffff097          	auipc	ra,0xfffff
    80005140:	926080e7          	jalr	-1754(ra) # 80003a62 <fileclose>
    fileclose(wf);
    80005144:	fc843503          	ld	a0,-56(s0)
    80005148:	fffff097          	auipc	ra,0xfffff
    8000514c:	91a080e7          	jalr	-1766(ra) # 80003a62 <fileclose>
    return -1;
    80005150:	57fd                	li	a5,-1
}
    80005152:	853e                	mv	a0,a5
    80005154:	70e2                	ld	ra,56(sp)
    80005156:	7442                	ld	s0,48(sp)
    80005158:	74a2                	ld	s1,40(sp)
    8000515a:	6121                	addi	sp,sp,64
    8000515c:	8082                	ret
	...

0000000080005160 <kernelvec>:
    80005160:	7111                	addi	sp,sp,-256
    80005162:	e006                	sd	ra,0(sp)
    80005164:	e40a                	sd	sp,8(sp)
    80005166:	e80e                	sd	gp,16(sp)
    80005168:	ec12                	sd	tp,24(sp)
    8000516a:	f016                	sd	t0,32(sp)
    8000516c:	f41a                	sd	t1,40(sp)
    8000516e:	f81e                	sd	t2,48(sp)
    80005170:	fc22                	sd	s0,56(sp)
    80005172:	e0a6                	sd	s1,64(sp)
    80005174:	e4aa                	sd	a0,72(sp)
    80005176:	e8ae                	sd	a1,80(sp)
    80005178:	ecb2                	sd	a2,88(sp)
    8000517a:	f0b6                	sd	a3,96(sp)
    8000517c:	f4ba                	sd	a4,104(sp)
    8000517e:	f8be                	sd	a5,112(sp)
    80005180:	fcc2                	sd	a6,120(sp)
    80005182:	e146                	sd	a7,128(sp)
    80005184:	e54a                	sd	s2,136(sp)
    80005186:	e94e                	sd	s3,144(sp)
    80005188:	ed52                	sd	s4,152(sp)
    8000518a:	f156                	sd	s5,160(sp)
    8000518c:	f55a                	sd	s6,168(sp)
    8000518e:	f95e                	sd	s7,176(sp)
    80005190:	fd62                	sd	s8,184(sp)
    80005192:	e1e6                	sd	s9,192(sp)
    80005194:	e5ea                	sd	s10,200(sp)
    80005196:	e9ee                	sd	s11,208(sp)
    80005198:	edf2                	sd	t3,216(sp)
    8000519a:	f1f6                	sd	t4,224(sp)
    8000519c:	f5fa                	sd	t5,232(sp)
    8000519e:	f9fe                	sd	t6,240(sp)
    800051a0:	cb9fc0ef          	jal	80001e58 <kerneltrap>
    800051a4:	6082                	ld	ra,0(sp)
    800051a6:	6122                	ld	sp,8(sp)
    800051a8:	61c2                	ld	gp,16(sp)
    800051aa:	7282                	ld	t0,32(sp)
    800051ac:	7322                	ld	t1,40(sp)
    800051ae:	73c2                	ld	t2,48(sp)
    800051b0:	7462                	ld	s0,56(sp)
    800051b2:	6486                	ld	s1,64(sp)
    800051b4:	6526                	ld	a0,72(sp)
    800051b6:	65c6                	ld	a1,80(sp)
    800051b8:	6666                	ld	a2,88(sp)
    800051ba:	7686                	ld	a3,96(sp)
    800051bc:	7726                	ld	a4,104(sp)
    800051be:	77c6                	ld	a5,112(sp)
    800051c0:	7866                	ld	a6,120(sp)
    800051c2:	688a                	ld	a7,128(sp)
    800051c4:	692a                	ld	s2,136(sp)
    800051c6:	69ca                	ld	s3,144(sp)
    800051c8:	6a6a                	ld	s4,152(sp)
    800051ca:	7a8a                	ld	s5,160(sp)
    800051cc:	7b2a                	ld	s6,168(sp)
    800051ce:	7bca                	ld	s7,176(sp)
    800051d0:	7c6a                	ld	s8,184(sp)
    800051d2:	6c8e                	ld	s9,192(sp)
    800051d4:	6d2e                	ld	s10,200(sp)
    800051d6:	6dce                	ld	s11,208(sp)
    800051d8:	6e6e                	ld	t3,216(sp)
    800051da:	7e8e                	ld	t4,224(sp)
    800051dc:	7f2e                	ld	t5,232(sp)
    800051de:	7fce                	ld	t6,240(sp)
    800051e0:	6111                	addi	sp,sp,256
    800051e2:	10200073          	sret
    800051e6:	00000013          	nop
    800051ea:	00000013          	nop
    800051ee:	0001                	nop

00000000800051f0 <timervec>:
    800051f0:	34051573          	csrrw	a0,mscratch,a0
    800051f4:	e10c                	sd	a1,0(a0)
    800051f6:	e510                	sd	a2,8(a0)
    800051f8:	e914                	sd	a3,16(a0)
    800051fa:	6d0c                	ld	a1,24(a0)
    800051fc:	7110                	ld	a2,32(a0)
    800051fe:	6194                	ld	a3,0(a1)
    80005200:	96b2                	add	a3,a3,a2
    80005202:	e194                	sd	a3,0(a1)
    80005204:	4589                	li	a1,2
    80005206:	14459073          	csrw	sip,a1
    8000520a:	6914                	ld	a3,16(a0)
    8000520c:	6510                	ld	a2,8(a0)
    8000520e:	610c                	ld	a1,0(a0)
    80005210:	34051573          	csrrw	a0,mscratch,a0
    80005214:	30200073          	mret
	...

000000008000521a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000521a:	1141                	addi	sp,sp,-16
    8000521c:	e422                	sd	s0,8(sp)
    8000521e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005220:	0c0007b7          	lui	a5,0xc000
    80005224:	4705                	li	a4,1
    80005226:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005228:	0c0007b7          	lui	a5,0xc000
    8000522c:	c3d8                	sw	a4,4(a5)
}
    8000522e:	6422                	ld	s0,8(sp)
    80005230:	0141                	addi	sp,sp,16
    80005232:	8082                	ret

0000000080005234 <plicinithart>:

void
plicinithart(void)
{
    80005234:	1141                	addi	sp,sp,-16
    80005236:	e406                	sd	ra,8(sp)
    80005238:	e022                	sd	s0,0(sp)
    8000523a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000523c:	ffffc097          	auipc	ra,0xffffc
    80005240:	c9e080e7          	jalr	-866(ra) # 80000eda <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005244:	0085171b          	slliw	a4,a0,0x8
    80005248:	0c0027b7          	lui	a5,0xc002
    8000524c:	97ba                	add	a5,a5,a4
    8000524e:	40200713          	li	a4,1026
    80005252:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005256:	00d5151b          	slliw	a0,a0,0xd
    8000525a:	0c2017b7          	lui	a5,0xc201
    8000525e:	97aa                	add	a5,a5,a0
    80005260:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005264:	60a2                	ld	ra,8(sp)
    80005266:	6402                	ld	s0,0(sp)
    80005268:	0141                	addi	sp,sp,16
    8000526a:	8082                	ret

000000008000526c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000526c:	1141                	addi	sp,sp,-16
    8000526e:	e406                	sd	ra,8(sp)
    80005270:	e022                	sd	s0,0(sp)
    80005272:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005274:	ffffc097          	auipc	ra,0xffffc
    80005278:	c66080e7          	jalr	-922(ra) # 80000eda <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000527c:	00d5151b          	slliw	a0,a0,0xd
    80005280:	0c2017b7          	lui	a5,0xc201
    80005284:	97aa                	add	a5,a5,a0
  return irq;
}
    80005286:	43c8                	lw	a0,4(a5)
    80005288:	60a2                	ld	ra,8(sp)
    8000528a:	6402                	ld	s0,0(sp)
    8000528c:	0141                	addi	sp,sp,16
    8000528e:	8082                	ret

0000000080005290 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005290:	1101                	addi	sp,sp,-32
    80005292:	ec06                	sd	ra,24(sp)
    80005294:	e822                	sd	s0,16(sp)
    80005296:	e426                	sd	s1,8(sp)
    80005298:	1000                	addi	s0,sp,32
    8000529a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000529c:	ffffc097          	auipc	ra,0xffffc
    800052a0:	c3e080e7          	jalr	-962(ra) # 80000eda <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052a4:	00d5151b          	slliw	a0,a0,0xd
    800052a8:	0c2017b7          	lui	a5,0xc201
    800052ac:	97aa                	add	a5,a5,a0
    800052ae:	c3c4                	sw	s1,4(a5)
}
    800052b0:	60e2                	ld	ra,24(sp)
    800052b2:	6442                	ld	s0,16(sp)
    800052b4:	64a2                	ld	s1,8(sp)
    800052b6:	6105                	addi	sp,sp,32
    800052b8:	8082                	ret

00000000800052ba <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052ba:	1141                	addi	sp,sp,-16
    800052bc:	e406                	sd	ra,8(sp)
    800052be:	e022                	sd	s0,0(sp)
    800052c0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052c2:	479d                	li	a5,7
    800052c4:	04a7cc63          	blt	a5,a0,8000531c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800052c8:	00014797          	auipc	a5,0x14
    800052cc:	74878793          	addi	a5,a5,1864 # 80019a10 <disk>
    800052d0:	97aa                	add	a5,a5,a0
    800052d2:	0187c783          	lbu	a5,24(a5)
    800052d6:	ebb9                	bnez	a5,8000532c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052d8:	00451693          	slli	a3,a0,0x4
    800052dc:	00014797          	auipc	a5,0x14
    800052e0:	73478793          	addi	a5,a5,1844 # 80019a10 <disk>
    800052e4:	6398                	ld	a4,0(a5)
    800052e6:	9736                	add	a4,a4,a3
    800052e8:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800052ec:	6398                	ld	a4,0(a5)
    800052ee:	9736                	add	a4,a4,a3
    800052f0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800052f4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800052f8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052fc:	97aa                	add	a5,a5,a0
    800052fe:	4705                	li	a4,1
    80005300:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005304:	00014517          	auipc	a0,0x14
    80005308:	72450513          	addi	a0,a0,1828 # 80019a28 <disk+0x18>
    8000530c:	ffffc097          	auipc	ra,0xffffc
    80005310:	30c080e7          	jalr	780(ra) # 80001618 <wakeup>
}
    80005314:	60a2                	ld	ra,8(sp)
    80005316:	6402                	ld	s0,0(sp)
    80005318:	0141                	addi	sp,sp,16
    8000531a:	8082                	ret
    panic("free_desc 1");
    8000531c:	00003517          	auipc	a0,0x3
    80005320:	2ec50513          	addi	a0,a0,748 # 80008608 <etext+0x608>
    80005324:	00001097          	auipc	ra,0x1
    80005328:	b10080e7          	jalr	-1264(ra) # 80005e34 <panic>
    panic("free_desc 2");
    8000532c:	00003517          	auipc	a0,0x3
    80005330:	2ec50513          	addi	a0,a0,748 # 80008618 <etext+0x618>
    80005334:	00001097          	auipc	ra,0x1
    80005338:	b00080e7          	jalr	-1280(ra) # 80005e34 <panic>

000000008000533c <virtio_disk_init>:
{
    8000533c:	1101                	addi	sp,sp,-32
    8000533e:	ec06                	sd	ra,24(sp)
    80005340:	e822                	sd	s0,16(sp)
    80005342:	e426                	sd	s1,8(sp)
    80005344:	e04a                	sd	s2,0(sp)
    80005346:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005348:	00003597          	auipc	a1,0x3
    8000534c:	2e058593          	addi	a1,a1,736 # 80008628 <etext+0x628>
    80005350:	00014517          	auipc	a0,0x14
    80005354:	7e850513          	addi	a0,a0,2024 # 80019b38 <disk+0x128>
    80005358:	00001097          	auipc	ra,0x1
    8000535c:	f9c080e7          	jalr	-100(ra) # 800062f4 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005360:	100017b7          	lui	a5,0x10001
    80005364:	4398                	lw	a4,0(a5)
    80005366:	2701                	sext.w	a4,a4
    80005368:	747277b7          	lui	a5,0x74727
    8000536c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005370:	18f71c63          	bne	a4,a5,80005508 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005374:	100017b7          	lui	a5,0x10001
    80005378:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000537a:	439c                	lw	a5,0(a5)
    8000537c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000537e:	4709                	li	a4,2
    80005380:	18e79463          	bne	a5,a4,80005508 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005384:	100017b7          	lui	a5,0x10001
    80005388:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000538a:	439c                	lw	a5,0(a5)
    8000538c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000538e:	16e79d63          	bne	a5,a4,80005508 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005392:	100017b7          	lui	a5,0x10001
    80005396:	47d8                	lw	a4,12(a5)
    80005398:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000539a:	554d47b7          	lui	a5,0x554d4
    8000539e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053a2:	16f71363          	bne	a4,a5,80005508 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053a6:	100017b7          	lui	a5,0x10001
    800053aa:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ae:	4705                	li	a4,1
    800053b0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053b2:	470d                	li	a4,3
    800053b4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053b6:	10001737          	lui	a4,0x10001
    800053ba:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053bc:	c7ffe737          	lui	a4,0xc7ffe
    800053c0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc9cf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053c4:	8ef9                	and	a3,a3,a4
    800053c6:	10001737          	lui	a4,0x10001
    800053ca:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053cc:	472d                	li	a4,11
    800053ce:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053d0:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800053d4:	439c                	lw	a5,0(a5)
    800053d6:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800053da:	8ba1                	andi	a5,a5,8
    800053dc:	12078e63          	beqz	a5,80005518 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053e0:	100017b7          	lui	a5,0x10001
    800053e4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800053e8:	100017b7          	lui	a5,0x10001
    800053ec:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800053f0:	439c                	lw	a5,0(a5)
    800053f2:	2781                	sext.w	a5,a5
    800053f4:	12079a63          	bnez	a5,80005528 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053f8:	100017b7          	lui	a5,0x10001
    800053fc:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005400:	439c                	lw	a5,0(a5)
    80005402:	2781                	sext.w	a5,a5
  if(max == 0)
    80005404:	12078a63          	beqz	a5,80005538 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80005408:	471d                	li	a4,7
    8000540a:	12f77f63          	bgeu	a4,a5,80005548 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000540e:	ffffb097          	auipc	ra,0xffffb
    80005412:	d0c080e7          	jalr	-756(ra) # 8000011a <kalloc>
    80005416:	00014497          	auipc	s1,0x14
    8000541a:	5fa48493          	addi	s1,s1,1530 # 80019a10 <disk>
    8000541e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005420:	ffffb097          	auipc	ra,0xffffb
    80005424:	cfa080e7          	jalr	-774(ra) # 8000011a <kalloc>
    80005428:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000542a:	ffffb097          	auipc	ra,0xffffb
    8000542e:	cf0080e7          	jalr	-784(ra) # 8000011a <kalloc>
    80005432:	87aa                	mv	a5,a0
    80005434:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005436:	6088                	ld	a0,0(s1)
    80005438:	12050063          	beqz	a0,80005558 <virtio_disk_init+0x21c>
    8000543c:	00014717          	auipc	a4,0x14
    80005440:	5dc73703          	ld	a4,1500(a4) # 80019a18 <disk+0x8>
    80005444:	10070a63          	beqz	a4,80005558 <virtio_disk_init+0x21c>
    80005448:	10078863          	beqz	a5,80005558 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    8000544c:	6605                	lui	a2,0x1
    8000544e:	4581                	li	a1,0
    80005450:	ffffb097          	auipc	ra,0xffffb
    80005454:	d2a080e7          	jalr	-726(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005458:	00014497          	auipc	s1,0x14
    8000545c:	5b848493          	addi	s1,s1,1464 # 80019a10 <disk>
    80005460:	6605                	lui	a2,0x1
    80005462:	4581                	li	a1,0
    80005464:	6488                	ld	a0,8(s1)
    80005466:	ffffb097          	auipc	ra,0xffffb
    8000546a:	d14080e7          	jalr	-748(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    8000546e:	6605                	lui	a2,0x1
    80005470:	4581                	li	a1,0
    80005472:	6888                	ld	a0,16(s1)
    80005474:	ffffb097          	auipc	ra,0xffffb
    80005478:	d06080e7          	jalr	-762(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000547c:	100017b7          	lui	a5,0x10001
    80005480:	4721                	li	a4,8
    80005482:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005484:	4098                	lw	a4,0(s1)
    80005486:	100017b7          	lui	a5,0x10001
    8000548a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000548e:	40d8                	lw	a4,4(s1)
    80005490:	100017b7          	lui	a5,0x10001
    80005494:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005498:	649c                	ld	a5,8(s1)
    8000549a:	0007869b          	sext.w	a3,a5
    8000549e:	10001737          	lui	a4,0x10001
    800054a2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800054a6:	9781                	srai	a5,a5,0x20
    800054a8:	10001737          	lui	a4,0x10001
    800054ac:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800054b0:	689c                	ld	a5,16(s1)
    800054b2:	0007869b          	sext.w	a3,a5
    800054b6:	10001737          	lui	a4,0x10001
    800054ba:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800054be:	9781                	srai	a5,a5,0x20
    800054c0:	10001737          	lui	a4,0x10001
    800054c4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800054c8:	10001737          	lui	a4,0x10001
    800054cc:	4785                	li	a5,1
    800054ce:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800054d0:	00f48c23          	sb	a5,24(s1)
    800054d4:	00f48ca3          	sb	a5,25(s1)
    800054d8:	00f48d23          	sb	a5,26(s1)
    800054dc:	00f48da3          	sb	a5,27(s1)
    800054e0:	00f48e23          	sb	a5,28(s1)
    800054e4:	00f48ea3          	sb	a5,29(s1)
    800054e8:	00f48f23          	sb	a5,30(s1)
    800054ec:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800054f0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800054f4:	100017b7          	lui	a5,0x10001
    800054f8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800054fc:	60e2                	ld	ra,24(sp)
    800054fe:	6442                	ld	s0,16(sp)
    80005500:	64a2                	ld	s1,8(sp)
    80005502:	6902                	ld	s2,0(sp)
    80005504:	6105                	addi	sp,sp,32
    80005506:	8082                	ret
    panic("could not find virtio disk");
    80005508:	00003517          	auipc	a0,0x3
    8000550c:	13050513          	addi	a0,a0,304 # 80008638 <etext+0x638>
    80005510:	00001097          	auipc	ra,0x1
    80005514:	924080e7          	jalr	-1756(ra) # 80005e34 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005518:	00003517          	auipc	a0,0x3
    8000551c:	14050513          	addi	a0,a0,320 # 80008658 <etext+0x658>
    80005520:	00001097          	auipc	ra,0x1
    80005524:	914080e7          	jalr	-1772(ra) # 80005e34 <panic>
    panic("virtio disk should not be ready");
    80005528:	00003517          	auipc	a0,0x3
    8000552c:	15050513          	addi	a0,a0,336 # 80008678 <etext+0x678>
    80005530:	00001097          	auipc	ra,0x1
    80005534:	904080e7          	jalr	-1788(ra) # 80005e34 <panic>
    panic("virtio disk has no queue 0");
    80005538:	00003517          	auipc	a0,0x3
    8000553c:	16050513          	addi	a0,a0,352 # 80008698 <etext+0x698>
    80005540:	00001097          	auipc	ra,0x1
    80005544:	8f4080e7          	jalr	-1804(ra) # 80005e34 <panic>
    panic("virtio disk max queue too short");
    80005548:	00003517          	auipc	a0,0x3
    8000554c:	17050513          	addi	a0,a0,368 # 800086b8 <etext+0x6b8>
    80005550:	00001097          	auipc	ra,0x1
    80005554:	8e4080e7          	jalr	-1820(ra) # 80005e34 <panic>
    panic("virtio disk kalloc");
    80005558:	00003517          	auipc	a0,0x3
    8000555c:	18050513          	addi	a0,a0,384 # 800086d8 <etext+0x6d8>
    80005560:	00001097          	auipc	ra,0x1
    80005564:	8d4080e7          	jalr	-1836(ra) # 80005e34 <panic>

0000000080005568 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005568:	7159                	addi	sp,sp,-112
    8000556a:	f486                	sd	ra,104(sp)
    8000556c:	f0a2                	sd	s0,96(sp)
    8000556e:	eca6                	sd	s1,88(sp)
    80005570:	e8ca                	sd	s2,80(sp)
    80005572:	e4ce                	sd	s3,72(sp)
    80005574:	e0d2                	sd	s4,64(sp)
    80005576:	fc56                	sd	s5,56(sp)
    80005578:	f85a                	sd	s6,48(sp)
    8000557a:	f45e                	sd	s7,40(sp)
    8000557c:	f062                	sd	s8,32(sp)
    8000557e:	ec66                	sd	s9,24(sp)
    80005580:	1880                	addi	s0,sp,112
    80005582:	8a2a                	mv	s4,a0
    80005584:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005586:	00c52c83          	lw	s9,12(a0)
    8000558a:	001c9c9b          	slliw	s9,s9,0x1
    8000558e:	1c82                	slli	s9,s9,0x20
    80005590:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005594:	00014517          	auipc	a0,0x14
    80005598:	5a450513          	addi	a0,a0,1444 # 80019b38 <disk+0x128>
    8000559c:	00001097          	auipc	ra,0x1
    800055a0:	de8080e7          	jalr	-536(ra) # 80006384 <acquire>
  for(int i = 0; i < 3; i++){
    800055a4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055a6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800055a8:	00014b17          	auipc	s6,0x14
    800055ac:	468b0b13          	addi	s6,s6,1128 # 80019a10 <disk>
  for(int i = 0; i < 3; i++){
    800055b0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055b2:	00014c17          	auipc	s8,0x14
    800055b6:	586c0c13          	addi	s8,s8,1414 # 80019b38 <disk+0x128>
    800055ba:	a0ad                	j	80005624 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    800055bc:	00fb0733          	add	a4,s6,a5
    800055c0:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800055c4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800055c6:	0207c563          	bltz	a5,800055f0 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800055ca:	2905                	addiw	s2,s2,1
    800055cc:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800055ce:	05590f63          	beq	s2,s5,8000562c <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    800055d2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800055d4:	00014717          	auipc	a4,0x14
    800055d8:	43c70713          	addi	a4,a4,1084 # 80019a10 <disk>
    800055dc:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055de:	01874683          	lbu	a3,24(a4)
    800055e2:	fee9                	bnez	a3,800055bc <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    800055e4:	2785                	addiw	a5,a5,1
    800055e6:	0705                	addi	a4,a4,1
    800055e8:	fe979be3          	bne	a5,s1,800055de <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055ec:	57fd                	li	a5,-1
    800055ee:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055f0:	03205163          	blez	s2,80005612 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800055f4:	f9042503          	lw	a0,-112(s0)
    800055f8:	00000097          	auipc	ra,0x0
    800055fc:	cc2080e7          	jalr	-830(ra) # 800052ba <free_desc>
      for(int j = 0; j < i; j++)
    80005600:	4785                	li	a5,1
    80005602:	0127d863          	bge	a5,s2,80005612 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80005606:	f9442503          	lw	a0,-108(s0)
    8000560a:	00000097          	auipc	ra,0x0
    8000560e:	cb0080e7          	jalr	-848(ra) # 800052ba <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005612:	85e2                	mv	a1,s8
    80005614:	00014517          	auipc	a0,0x14
    80005618:	41450513          	addi	a0,a0,1044 # 80019a28 <disk+0x18>
    8000561c:	ffffc097          	auipc	ra,0xffffc
    80005620:	f98080e7          	jalr	-104(ra) # 800015b4 <sleep>
  for(int i = 0; i < 3; i++){
    80005624:	f9040613          	addi	a2,s0,-112
    80005628:	894e                	mv	s2,s3
    8000562a:	b765                	j	800055d2 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000562c:	f9042503          	lw	a0,-112(s0)
    80005630:	00451693          	slli	a3,a0,0x4

  if(write)
    80005634:	00014797          	auipc	a5,0x14
    80005638:	3dc78793          	addi	a5,a5,988 # 80019a10 <disk>
    8000563c:	00a50713          	addi	a4,a0,10
    80005640:	0712                	slli	a4,a4,0x4
    80005642:	973e                	add	a4,a4,a5
    80005644:	01703633          	snez	a2,s7
    80005648:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000564a:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000564e:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005652:	6398                	ld	a4,0(a5)
    80005654:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005656:	0a868613          	addi	a2,a3,168
    8000565a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000565c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000565e:	6390                	ld	a2,0(a5)
    80005660:	00d605b3          	add	a1,a2,a3
    80005664:	4741                	li	a4,16
    80005666:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005668:	4805                	li	a6,1
    8000566a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000566e:	f9442703          	lw	a4,-108(s0)
    80005672:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005676:	0712                	slli	a4,a4,0x4
    80005678:	963a                	add	a2,a2,a4
    8000567a:	058a0593          	addi	a1,s4,88
    8000567e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005680:	0007b883          	ld	a7,0(a5)
    80005684:	9746                	add	a4,a4,a7
    80005686:	40000613          	li	a2,1024
    8000568a:	c710                	sw	a2,8(a4)
  if(write)
    8000568c:	001bb613          	seqz	a2,s7
    80005690:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005694:	00166613          	ori	a2,a2,1
    80005698:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000569c:	f9842583          	lw	a1,-104(s0)
    800056a0:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056a4:	00250613          	addi	a2,a0,2
    800056a8:	0612                	slli	a2,a2,0x4
    800056aa:	963e                	add	a2,a2,a5
    800056ac:	577d                	li	a4,-1
    800056ae:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056b2:	0592                	slli	a1,a1,0x4
    800056b4:	98ae                	add	a7,a7,a1
    800056b6:	03068713          	addi	a4,a3,48
    800056ba:	973e                	add	a4,a4,a5
    800056bc:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800056c0:	6398                	ld	a4,0(a5)
    800056c2:	972e                	add	a4,a4,a1
    800056c4:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056c8:	4689                	li	a3,2
    800056ca:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800056ce:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056d2:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800056d6:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056da:	6794                	ld	a3,8(a5)
    800056dc:	0026d703          	lhu	a4,2(a3)
    800056e0:	8b1d                	andi	a4,a4,7
    800056e2:	0706                	slli	a4,a4,0x1
    800056e4:	96ba                	add	a3,a3,a4
    800056e6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800056ea:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056ee:	6798                	ld	a4,8(a5)
    800056f0:	00275783          	lhu	a5,2(a4)
    800056f4:	2785                	addiw	a5,a5,1
    800056f6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056fa:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056fe:	100017b7          	lui	a5,0x10001
    80005702:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005706:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000570a:	00014917          	auipc	s2,0x14
    8000570e:	42e90913          	addi	s2,s2,1070 # 80019b38 <disk+0x128>
  while(b->disk == 1) {
    80005712:	4485                	li	s1,1
    80005714:	01079c63          	bne	a5,a6,8000572c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005718:	85ca                	mv	a1,s2
    8000571a:	8552                	mv	a0,s4
    8000571c:	ffffc097          	auipc	ra,0xffffc
    80005720:	e98080e7          	jalr	-360(ra) # 800015b4 <sleep>
  while(b->disk == 1) {
    80005724:	004a2783          	lw	a5,4(s4)
    80005728:	fe9788e3          	beq	a5,s1,80005718 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000572c:	f9042903          	lw	s2,-112(s0)
    80005730:	00290713          	addi	a4,s2,2
    80005734:	0712                	slli	a4,a4,0x4
    80005736:	00014797          	auipc	a5,0x14
    8000573a:	2da78793          	addi	a5,a5,730 # 80019a10 <disk>
    8000573e:	97ba                	add	a5,a5,a4
    80005740:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005744:	00014997          	auipc	s3,0x14
    80005748:	2cc98993          	addi	s3,s3,716 # 80019a10 <disk>
    8000574c:	00491713          	slli	a4,s2,0x4
    80005750:	0009b783          	ld	a5,0(s3)
    80005754:	97ba                	add	a5,a5,a4
    80005756:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000575a:	854a                	mv	a0,s2
    8000575c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005760:	00000097          	auipc	ra,0x0
    80005764:	b5a080e7          	jalr	-1190(ra) # 800052ba <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005768:	8885                	andi	s1,s1,1
    8000576a:	f0ed                	bnez	s1,8000574c <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000576c:	00014517          	auipc	a0,0x14
    80005770:	3cc50513          	addi	a0,a0,972 # 80019b38 <disk+0x128>
    80005774:	00001097          	auipc	ra,0x1
    80005778:	cc4080e7          	jalr	-828(ra) # 80006438 <release>
}
    8000577c:	70a6                	ld	ra,104(sp)
    8000577e:	7406                	ld	s0,96(sp)
    80005780:	64e6                	ld	s1,88(sp)
    80005782:	6946                	ld	s2,80(sp)
    80005784:	69a6                	ld	s3,72(sp)
    80005786:	6a06                	ld	s4,64(sp)
    80005788:	7ae2                	ld	s5,56(sp)
    8000578a:	7b42                	ld	s6,48(sp)
    8000578c:	7ba2                	ld	s7,40(sp)
    8000578e:	7c02                	ld	s8,32(sp)
    80005790:	6ce2                	ld	s9,24(sp)
    80005792:	6165                	addi	sp,sp,112
    80005794:	8082                	ret

0000000080005796 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005796:	1101                	addi	sp,sp,-32
    80005798:	ec06                	sd	ra,24(sp)
    8000579a:	e822                	sd	s0,16(sp)
    8000579c:	e426                	sd	s1,8(sp)
    8000579e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057a0:	00014497          	auipc	s1,0x14
    800057a4:	27048493          	addi	s1,s1,624 # 80019a10 <disk>
    800057a8:	00014517          	auipc	a0,0x14
    800057ac:	39050513          	addi	a0,a0,912 # 80019b38 <disk+0x128>
    800057b0:	00001097          	auipc	ra,0x1
    800057b4:	bd4080e7          	jalr	-1068(ra) # 80006384 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057b8:	100017b7          	lui	a5,0x10001
    800057bc:	53b8                	lw	a4,96(a5)
    800057be:	8b0d                	andi	a4,a4,3
    800057c0:	100017b7          	lui	a5,0x10001
    800057c4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800057c6:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057ca:	689c                	ld	a5,16(s1)
    800057cc:	0204d703          	lhu	a4,32(s1)
    800057d0:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800057d4:	04f70863          	beq	a4,a5,80005824 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    800057d8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057dc:	6898                	ld	a4,16(s1)
    800057de:	0204d783          	lhu	a5,32(s1)
    800057e2:	8b9d                	andi	a5,a5,7
    800057e4:	078e                	slli	a5,a5,0x3
    800057e6:	97ba                	add	a5,a5,a4
    800057e8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057ea:	00278713          	addi	a4,a5,2
    800057ee:	0712                	slli	a4,a4,0x4
    800057f0:	9726                	add	a4,a4,s1
    800057f2:	01074703          	lbu	a4,16(a4)
    800057f6:	e721                	bnez	a4,8000583e <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057f8:	0789                	addi	a5,a5,2
    800057fa:	0792                	slli	a5,a5,0x4
    800057fc:	97a6                	add	a5,a5,s1
    800057fe:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005800:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005804:	ffffc097          	auipc	ra,0xffffc
    80005808:	e14080e7          	jalr	-492(ra) # 80001618 <wakeup>

    disk.used_idx += 1;
    8000580c:	0204d783          	lhu	a5,32(s1)
    80005810:	2785                	addiw	a5,a5,1
    80005812:	17c2                	slli	a5,a5,0x30
    80005814:	93c1                	srli	a5,a5,0x30
    80005816:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000581a:	6898                	ld	a4,16(s1)
    8000581c:	00275703          	lhu	a4,2(a4)
    80005820:	faf71ce3          	bne	a4,a5,800057d8 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80005824:	00014517          	auipc	a0,0x14
    80005828:	31450513          	addi	a0,a0,788 # 80019b38 <disk+0x128>
    8000582c:	00001097          	auipc	ra,0x1
    80005830:	c0c080e7          	jalr	-1012(ra) # 80006438 <release>
}
    80005834:	60e2                	ld	ra,24(sp)
    80005836:	6442                	ld	s0,16(sp)
    80005838:	64a2                	ld	s1,8(sp)
    8000583a:	6105                	addi	sp,sp,32
    8000583c:	8082                	ret
      panic("virtio_disk_intr status");
    8000583e:	00003517          	auipc	a0,0x3
    80005842:	eb250513          	addi	a0,a0,-334 # 800086f0 <etext+0x6f0>
    80005846:	00000097          	auipc	ra,0x0
    8000584a:	5ee080e7          	jalr	1518(ra) # 80005e34 <panic>

000000008000584e <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000584e:	1141                	addi	sp,sp,-16
    80005850:	e422                	sd	s0,8(sp)
    80005852:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005854:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005858:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000585c:	0037979b          	slliw	a5,a5,0x3
    80005860:	02004737          	lui	a4,0x2004
    80005864:	97ba                	add	a5,a5,a4
    80005866:	0200c737          	lui	a4,0x200c
    8000586a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000586c:	6318                	ld	a4,0(a4)
    8000586e:	000f4637          	lui	a2,0xf4
    80005872:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005876:	9732                	add	a4,a4,a2
    80005878:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000587a:	00259693          	slli	a3,a1,0x2
    8000587e:	96ae                	add	a3,a3,a1
    80005880:	068e                	slli	a3,a3,0x3
    80005882:	00014717          	auipc	a4,0x14
    80005886:	2ce70713          	addi	a4,a4,718 # 80019b50 <timer_scratch>
    8000588a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000588c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000588e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005890:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005894:	00000797          	auipc	a5,0x0
    80005898:	95c78793          	addi	a5,a5,-1700 # 800051f0 <timervec>
    8000589c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058a0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058a4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058ac:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058b0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058b4:	30479073          	csrw	mie,a5
}
    800058b8:	6422                	ld	s0,8(sp)
    800058ba:	0141                	addi	sp,sp,16
    800058bc:	8082                	ret

00000000800058be <start>:
{
    800058be:	1141                	addi	sp,sp,-16
    800058c0:	e406                	sd	ra,8(sp)
    800058c2:	e022                	sd	s0,0(sp)
    800058c4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058c6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058ca:	7779                	lui	a4,0xffffe
    800058cc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdca6f>
    800058d0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058d2:	6705                	lui	a4,0x1
    800058d4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058d8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058da:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058de:	ffffb797          	auipc	a5,0xffffb
    800058e2:	a3a78793          	addi	a5,a5,-1478 # 80000318 <main>
    800058e6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058ea:	4781                	li	a5,0
    800058ec:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058f0:	67c1                	lui	a5,0x10
    800058f2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800058f4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058f8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058fc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005900:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005904:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005908:	57fd                	li	a5,-1
    8000590a:	83a9                	srli	a5,a5,0xa
    8000590c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005910:	47bd                	li	a5,15
    80005912:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005916:	00000097          	auipc	ra,0x0
    8000591a:	f38080e7          	jalr	-200(ra) # 8000584e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000591e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005922:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005924:	823e                	mv	tp,a5
  asm volatile("mret");
    80005926:	30200073          	mret
}
    8000592a:	60a2                	ld	ra,8(sp)
    8000592c:	6402                	ld	s0,0(sp)
    8000592e:	0141                	addi	sp,sp,16
    80005930:	8082                	ret

0000000080005932 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005932:	715d                	addi	sp,sp,-80
    80005934:	e486                	sd	ra,72(sp)
    80005936:	e0a2                	sd	s0,64(sp)
    80005938:	f84a                	sd	s2,48(sp)
    8000593a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000593c:	04c05663          	blez	a2,80005988 <consolewrite+0x56>
    80005940:	fc26                	sd	s1,56(sp)
    80005942:	f44e                	sd	s3,40(sp)
    80005944:	f052                	sd	s4,32(sp)
    80005946:	ec56                	sd	s5,24(sp)
    80005948:	8a2a                	mv	s4,a0
    8000594a:	84ae                	mv	s1,a1
    8000594c:	89b2                	mv	s3,a2
    8000594e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005950:	5afd                	li	s5,-1
    80005952:	4685                	li	a3,1
    80005954:	8626                	mv	a2,s1
    80005956:	85d2                	mv	a1,s4
    80005958:	fbf40513          	addi	a0,s0,-65
    8000595c:	ffffc097          	auipc	ra,0xffffc
    80005960:	0b6080e7          	jalr	182(ra) # 80001a12 <either_copyin>
    80005964:	03550463          	beq	a0,s5,8000598c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005968:	fbf44503          	lbu	a0,-65(s0)
    8000596c:	00001097          	auipc	ra,0x1
    80005970:	85c080e7          	jalr	-1956(ra) # 800061c8 <uartputc>
  for(i = 0; i < n; i++){
    80005974:	2905                	addiw	s2,s2,1
    80005976:	0485                	addi	s1,s1,1
    80005978:	fd299de3          	bne	s3,s2,80005952 <consolewrite+0x20>
    8000597c:	894e                	mv	s2,s3
    8000597e:	74e2                	ld	s1,56(sp)
    80005980:	79a2                	ld	s3,40(sp)
    80005982:	7a02                	ld	s4,32(sp)
    80005984:	6ae2                	ld	s5,24(sp)
    80005986:	a039                	j	80005994 <consolewrite+0x62>
    80005988:	4901                	li	s2,0
    8000598a:	a029                	j	80005994 <consolewrite+0x62>
    8000598c:	74e2                	ld	s1,56(sp)
    8000598e:	79a2                	ld	s3,40(sp)
    80005990:	7a02                	ld	s4,32(sp)
    80005992:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005994:	854a                	mv	a0,s2
    80005996:	60a6                	ld	ra,72(sp)
    80005998:	6406                	ld	s0,64(sp)
    8000599a:	7942                	ld	s2,48(sp)
    8000599c:	6161                	addi	sp,sp,80
    8000599e:	8082                	ret

00000000800059a0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059a0:	711d                	addi	sp,sp,-96
    800059a2:	ec86                	sd	ra,88(sp)
    800059a4:	e8a2                	sd	s0,80(sp)
    800059a6:	e4a6                	sd	s1,72(sp)
    800059a8:	e0ca                	sd	s2,64(sp)
    800059aa:	fc4e                	sd	s3,56(sp)
    800059ac:	f852                	sd	s4,48(sp)
    800059ae:	f456                	sd	s5,40(sp)
    800059b0:	f05a                	sd	s6,32(sp)
    800059b2:	1080                	addi	s0,sp,96
    800059b4:	8aaa                	mv	s5,a0
    800059b6:	8a2e                	mv	s4,a1
    800059b8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059ba:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059be:	0001c517          	auipc	a0,0x1c
    800059c2:	2d250513          	addi	a0,a0,722 # 80021c90 <cons>
    800059c6:	00001097          	auipc	ra,0x1
    800059ca:	9be080e7          	jalr	-1602(ra) # 80006384 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059ce:	0001c497          	auipc	s1,0x1c
    800059d2:	2c248493          	addi	s1,s1,706 # 80021c90 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059d6:	0001c917          	auipc	s2,0x1c
    800059da:	35290913          	addi	s2,s2,850 # 80021d28 <cons+0x98>
  while(n > 0){
    800059de:	0d305763          	blez	s3,80005aac <consoleread+0x10c>
    while(cons.r == cons.w){
    800059e2:	0984a783          	lw	a5,152(s1)
    800059e6:	09c4a703          	lw	a4,156(s1)
    800059ea:	0af71c63          	bne	a4,a5,80005aa2 <consoleread+0x102>
      if(killed(myproc())){
    800059ee:	ffffb097          	auipc	ra,0xffffb
    800059f2:	518080e7          	jalr	1304(ra) # 80000f06 <myproc>
    800059f6:	ffffc097          	auipc	ra,0xffffc
    800059fa:	e66080e7          	jalr	-410(ra) # 8000185c <killed>
    800059fe:	e52d                	bnez	a0,80005a68 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    80005a00:	85a6                	mv	a1,s1
    80005a02:	854a                	mv	a0,s2
    80005a04:	ffffc097          	auipc	ra,0xffffc
    80005a08:	bb0080e7          	jalr	-1104(ra) # 800015b4 <sleep>
    while(cons.r == cons.w){
    80005a0c:	0984a783          	lw	a5,152(s1)
    80005a10:	09c4a703          	lw	a4,156(s1)
    80005a14:	fcf70de3          	beq	a4,a5,800059ee <consoleread+0x4e>
    80005a18:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005a1a:	0001c717          	auipc	a4,0x1c
    80005a1e:	27670713          	addi	a4,a4,630 # 80021c90 <cons>
    80005a22:	0017869b          	addiw	a3,a5,1
    80005a26:	08d72c23          	sw	a3,152(a4)
    80005a2a:	07f7f693          	andi	a3,a5,127
    80005a2e:	9736                	add	a4,a4,a3
    80005a30:	01874703          	lbu	a4,24(a4)
    80005a34:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005a38:	4691                	li	a3,4
    80005a3a:	04db8a63          	beq	s7,a3,80005a8e <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005a3e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a42:	4685                	li	a3,1
    80005a44:	faf40613          	addi	a2,s0,-81
    80005a48:	85d2                	mv	a1,s4
    80005a4a:	8556                	mv	a0,s5
    80005a4c:	ffffc097          	auipc	ra,0xffffc
    80005a50:	f70080e7          	jalr	-144(ra) # 800019bc <either_copyout>
    80005a54:	57fd                	li	a5,-1
    80005a56:	04f50a63          	beq	a0,a5,80005aaa <consoleread+0x10a>
      break;

    dst++;
    80005a5a:	0a05                	addi	s4,s4,1
    --n;
    80005a5c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005a5e:	47a9                	li	a5,10
    80005a60:	06fb8163          	beq	s7,a5,80005ac2 <consoleread+0x122>
    80005a64:	6be2                	ld	s7,24(sp)
    80005a66:	bfa5                	j	800059de <consoleread+0x3e>
        release(&cons.lock);
    80005a68:	0001c517          	auipc	a0,0x1c
    80005a6c:	22850513          	addi	a0,a0,552 # 80021c90 <cons>
    80005a70:	00001097          	auipc	ra,0x1
    80005a74:	9c8080e7          	jalr	-1592(ra) # 80006438 <release>
        return -1;
    80005a78:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005a7a:	60e6                	ld	ra,88(sp)
    80005a7c:	6446                	ld	s0,80(sp)
    80005a7e:	64a6                	ld	s1,72(sp)
    80005a80:	6906                	ld	s2,64(sp)
    80005a82:	79e2                	ld	s3,56(sp)
    80005a84:	7a42                	ld	s4,48(sp)
    80005a86:	7aa2                	ld	s5,40(sp)
    80005a88:	7b02                	ld	s6,32(sp)
    80005a8a:	6125                	addi	sp,sp,96
    80005a8c:	8082                	ret
      if(n < target){
    80005a8e:	0009871b          	sext.w	a4,s3
    80005a92:	01677a63          	bgeu	a4,s6,80005aa6 <consoleread+0x106>
        cons.r--;
    80005a96:	0001c717          	auipc	a4,0x1c
    80005a9a:	28f72923          	sw	a5,658(a4) # 80021d28 <cons+0x98>
    80005a9e:	6be2                	ld	s7,24(sp)
    80005aa0:	a031                	j	80005aac <consoleread+0x10c>
    80005aa2:	ec5e                	sd	s7,24(sp)
    80005aa4:	bf9d                	j	80005a1a <consoleread+0x7a>
    80005aa6:	6be2                	ld	s7,24(sp)
    80005aa8:	a011                	j	80005aac <consoleread+0x10c>
    80005aaa:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005aac:	0001c517          	auipc	a0,0x1c
    80005ab0:	1e450513          	addi	a0,a0,484 # 80021c90 <cons>
    80005ab4:	00001097          	auipc	ra,0x1
    80005ab8:	984080e7          	jalr	-1660(ra) # 80006438 <release>
  return target - n;
    80005abc:	413b053b          	subw	a0,s6,s3
    80005ac0:	bf6d                	j	80005a7a <consoleread+0xda>
    80005ac2:	6be2                	ld	s7,24(sp)
    80005ac4:	b7e5                	j	80005aac <consoleread+0x10c>

0000000080005ac6 <consputc>:
{
    80005ac6:	1141                	addi	sp,sp,-16
    80005ac8:	e406                	sd	ra,8(sp)
    80005aca:	e022                	sd	s0,0(sp)
    80005acc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ace:	10000793          	li	a5,256
    80005ad2:	00f50a63          	beq	a0,a5,80005ae6 <consputc+0x20>
    uartputc_sync(c);
    80005ad6:	00000097          	auipc	ra,0x0
    80005ada:	614080e7          	jalr	1556(ra) # 800060ea <uartputc_sync>
}
    80005ade:	60a2                	ld	ra,8(sp)
    80005ae0:	6402                	ld	s0,0(sp)
    80005ae2:	0141                	addi	sp,sp,16
    80005ae4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ae6:	4521                	li	a0,8
    80005ae8:	00000097          	auipc	ra,0x0
    80005aec:	602080e7          	jalr	1538(ra) # 800060ea <uartputc_sync>
    80005af0:	02000513          	li	a0,32
    80005af4:	00000097          	auipc	ra,0x0
    80005af8:	5f6080e7          	jalr	1526(ra) # 800060ea <uartputc_sync>
    80005afc:	4521                	li	a0,8
    80005afe:	00000097          	auipc	ra,0x0
    80005b02:	5ec080e7          	jalr	1516(ra) # 800060ea <uartputc_sync>
    80005b06:	bfe1                	j	80005ade <consputc+0x18>

0000000080005b08 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b08:	1101                	addi	sp,sp,-32
    80005b0a:	ec06                	sd	ra,24(sp)
    80005b0c:	e822                	sd	s0,16(sp)
    80005b0e:	e426                	sd	s1,8(sp)
    80005b10:	1000                	addi	s0,sp,32
    80005b12:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b14:	0001c517          	auipc	a0,0x1c
    80005b18:	17c50513          	addi	a0,a0,380 # 80021c90 <cons>
    80005b1c:	00001097          	auipc	ra,0x1
    80005b20:	868080e7          	jalr	-1944(ra) # 80006384 <acquire>

  switch(c){
    80005b24:	47d5                	li	a5,21
    80005b26:	0af48563          	beq	s1,a5,80005bd0 <consoleintr+0xc8>
    80005b2a:	0297c963          	blt	a5,s1,80005b5c <consoleintr+0x54>
    80005b2e:	47a1                	li	a5,8
    80005b30:	0ef48c63          	beq	s1,a5,80005c28 <consoleintr+0x120>
    80005b34:	47c1                	li	a5,16
    80005b36:	10f49f63          	bne	s1,a5,80005c54 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005b3a:	ffffc097          	auipc	ra,0xffffc
    80005b3e:	f2e080e7          	jalr	-210(ra) # 80001a68 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b42:	0001c517          	auipc	a0,0x1c
    80005b46:	14e50513          	addi	a0,a0,334 # 80021c90 <cons>
    80005b4a:	00001097          	auipc	ra,0x1
    80005b4e:	8ee080e7          	jalr	-1810(ra) # 80006438 <release>
}
    80005b52:	60e2                	ld	ra,24(sp)
    80005b54:	6442                	ld	s0,16(sp)
    80005b56:	64a2                	ld	s1,8(sp)
    80005b58:	6105                	addi	sp,sp,32
    80005b5a:	8082                	ret
  switch(c){
    80005b5c:	07f00793          	li	a5,127
    80005b60:	0cf48463          	beq	s1,a5,80005c28 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b64:	0001c717          	auipc	a4,0x1c
    80005b68:	12c70713          	addi	a4,a4,300 # 80021c90 <cons>
    80005b6c:	0a072783          	lw	a5,160(a4)
    80005b70:	09872703          	lw	a4,152(a4)
    80005b74:	9f99                	subw	a5,a5,a4
    80005b76:	07f00713          	li	a4,127
    80005b7a:	fcf764e3          	bltu	a4,a5,80005b42 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005b7e:	47b5                	li	a5,13
    80005b80:	0cf48d63          	beq	s1,a5,80005c5a <consoleintr+0x152>
      consputc(c);
    80005b84:	8526                	mv	a0,s1
    80005b86:	00000097          	auipc	ra,0x0
    80005b8a:	f40080e7          	jalr	-192(ra) # 80005ac6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b8e:	0001c797          	auipc	a5,0x1c
    80005b92:	10278793          	addi	a5,a5,258 # 80021c90 <cons>
    80005b96:	0a07a683          	lw	a3,160(a5)
    80005b9a:	0016871b          	addiw	a4,a3,1
    80005b9e:	0007061b          	sext.w	a2,a4
    80005ba2:	0ae7a023          	sw	a4,160(a5)
    80005ba6:	07f6f693          	andi	a3,a3,127
    80005baa:	97b6                	add	a5,a5,a3
    80005bac:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005bb0:	47a9                	li	a5,10
    80005bb2:	0cf48b63          	beq	s1,a5,80005c88 <consoleintr+0x180>
    80005bb6:	4791                	li	a5,4
    80005bb8:	0cf48863          	beq	s1,a5,80005c88 <consoleintr+0x180>
    80005bbc:	0001c797          	auipc	a5,0x1c
    80005bc0:	16c7a783          	lw	a5,364(a5) # 80021d28 <cons+0x98>
    80005bc4:	9f1d                	subw	a4,a4,a5
    80005bc6:	08000793          	li	a5,128
    80005bca:	f6f71ce3          	bne	a4,a5,80005b42 <consoleintr+0x3a>
    80005bce:	a86d                	j	80005c88 <consoleintr+0x180>
    80005bd0:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005bd2:	0001c717          	auipc	a4,0x1c
    80005bd6:	0be70713          	addi	a4,a4,190 # 80021c90 <cons>
    80005bda:	0a072783          	lw	a5,160(a4)
    80005bde:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005be2:	0001c497          	auipc	s1,0x1c
    80005be6:	0ae48493          	addi	s1,s1,174 # 80021c90 <cons>
    while(cons.e != cons.w &&
    80005bea:	4929                	li	s2,10
    80005bec:	02f70a63          	beq	a4,a5,80005c20 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bf0:	37fd                	addiw	a5,a5,-1
    80005bf2:	07f7f713          	andi	a4,a5,127
    80005bf6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bf8:	01874703          	lbu	a4,24(a4)
    80005bfc:	03270463          	beq	a4,s2,80005c24 <consoleintr+0x11c>
      cons.e--;
    80005c00:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c04:	10000513          	li	a0,256
    80005c08:	00000097          	auipc	ra,0x0
    80005c0c:	ebe080e7          	jalr	-322(ra) # 80005ac6 <consputc>
    while(cons.e != cons.w &&
    80005c10:	0a04a783          	lw	a5,160(s1)
    80005c14:	09c4a703          	lw	a4,156(s1)
    80005c18:	fcf71ce3          	bne	a4,a5,80005bf0 <consoleintr+0xe8>
    80005c1c:	6902                	ld	s2,0(sp)
    80005c1e:	b715                	j	80005b42 <consoleintr+0x3a>
    80005c20:	6902                	ld	s2,0(sp)
    80005c22:	b705                	j	80005b42 <consoleintr+0x3a>
    80005c24:	6902                	ld	s2,0(sp)
    80005c26:	bf31                	j	80005b42 <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005c28:	0001c717          	auipc	a4,0x1c
    80005c2c:	06870713          	addi	a4,a4,104 # 80021c90 <cons>
    80005c30:	0a072783          	lw	a5,160(a4)
    80005c34:	09c72703          	lw	a4,156(a4)
    80005c38:	f0f705e3          	beq	a4,a5,80005b42 <consoleintr+0x3a>
      cons.e--;
    80005c3c:	37fd                	addiw	a5,a5,-1
    80005c3e:	0001c717          	auipc	a4,0x1c
    80005c42:	0ef72923          	sw	a5,242(a4) # 80021d30 <cons+0xa0>
      consputc(BACKSPACE);
    80005c46:	10000513          	li	a0,256
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	e7c080e7          	jalr	-388(ra) # 80005ac6 <consputc>
    80005c52:	bdc5                	j	80005b42 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c54:	ee0487e3          	beqz	s1,80005b42 <consoleintr+0x3a>
    80005c58:	b731                	j	80005b64 <consoleintr+0x5c>
      consputc(c);
    80005c5a:	4529                	li	a0,10
    80005c5c:	00000097          	auipc	ra,0x0
    80005c60:	e6a080e7          	jalr	-406(ra) # 80005ac6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c64:	0001c797          	auipc	a5,0x1c
    80005c68:	02c78793          	addi	a5,a5,44 # 80021c90 <cons>
    80005c6c:	0a07a703          	lw	a4,160(a5)
    80005c70:	0017069b          	addiw	a3,a4,1
    80005c74:	0006861b          	sext.w	a2,a3
    80005c78:	0ad7a023          	sw	a3,160(a5)
    80005c7c:	07f77713          	andi	a4,a4,127
    80005c80:	97ba                	add	a5,a5,a4
    80005c82:	4729                	li	a4,10
    80005c84:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c88:	0001c797          	auipc	a5,0x1c
    80005c8c:	0ac7a223          	sw	a2,164(a5) # 80021d2c <cons+0x9c>
        wakeup(&cons.r);
    80005c90:	0001c517          	auipc	a0,0x1c
    80005c94:	09850513          	addi	a0,a0,152 # 80021d28 <cons+0x98>
    80005c98:	ffffc097          	auipc	ra,0xffffc
    80005c9c:	980080e7          	jalr	-1664(ra) # 80001618 <wakeup>
    80005ca0:	b54d                	j	80005b42 <consoleintr+0x3a>

0000000080005ca2 <consoleinit>:

void
consoleinit(void)
{
    80005ca2:	1141                	addi	sp,sp,-16
    80005ca4:	e406                	sd	ra,8(sp)
    80005ca6:	e022                	sd	s0,0(sp)
    80005ca8:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005caa:	00003597          	auipc	a1,0x3
    80005cae:	a5e58593          	addi	a1,a1,-1442 # 80008708 <etext+0x708>
    80005cb2:	0001c517          	auipc	a0,0x1c
    80005cb6:	fde50513          	addi	a0,a0,-34 # 80021c90 <cons>
    80005cba:	00000097          	auipc	ra,0x0
    80005cbe:	63a080e7          	jalr	1594(ra) # 800062f4 <initlock>

  uartinit();
    80005cc2:	00000097          	auipc	ra,0x0
    80005cc6:	3cc080e7          	jalr	972(ra) # 8000608e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cca:	00013797          	auipc	a5,0x13
    80005cce:	cee78793          	addi	a5,a5,-786 # 800189b8 <devsw>
    80005cd2:	00000717          	auipc	a4,0x0
    80005cd6:	cce70713          	addi	a4,a4,-818 # 800059a0 <consoleread>
    80005cda:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cdc:	00000717          	auipc	a4,0x0
    80005ce0:	c5670713          	addi	a4,a4,-938 # 80005932 <consolewrite>
    80005ce4:	ef98                	sd	a4,24(a5)
}
    80005ce6:	60a2                	ld	ra,8(sp)
    80005ce8:	6402                	ld	s0,0(sp)
    80005cea:	0141                	addi	sp,sp,16
    80005cec:	8082                	ret

0000000080005cee <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cee:	7179                	addi	sp,sp,-48
    80005cf0:	f406                	sd	ra,40(sp)
    80005cf2:	f022                	sd	s0,32(sp)
    80005cf4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cf6:	c219                	beqz	a2,80005cfc <printint+0xe>
    80005cf8:	08054963          	bltz	a0,80005d8a <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005cfc:	2501                	sext.w	a0,a0
    80005cfe:	4881                	li	a7,0
    80005d00:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d04:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d06:	2581                	sext.w	a1,a1
    80005d08:	00003617          	auipc	a2,0x3
    80005d0c:	b7860613          	addi	a2,a2,-1160 # 80008880 <digits>
    80005d10:	883a                	mv	a6,a4
    80005d12:	2705                	addiw	a4,a4,1
    80005d14:	02b577bb          	remuw	a5,a0,a1
    80005d18:	1782                	slli	a5,a5,0x20
    80005d1a:	9381                	srli	a5,a5,0x20
    80005d1c:	97b2                	add	a5,a5,a2
    80005d1e:	0007c783          	lbu	a5,0(a5)
    80005d22:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d26:	0005079b          	sext.w	a5,a0
    80005d2a:	02b5553b          	divuw	a0,a0,a1
    80005d2e:	0685                	addi	a3,a3,1
    80005d30:	feb7f0e3          	bgeu	a5,a1,80005d10 <printint+0x22>

  if(sign)
    80005d34:	00088c63          	beqz	a7,80005d4c <printint+0x5e>
    buf[i++] = '-';
    80005d38:	fe070793          	addi	a5,a4,-32
    80005d3c:	00878733          	add	a4,a5,s0
    80005d40:	02d00793          	li	a5,45
    80005d44:	fef70823          	sb	a5,-16(a4)
    80005d48:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d4c:	02e05b63          	blez	a4,80005d82 <printint+0x94>
    80005d50:	ec26                	sd	s1,24(sp)
    80005d52:	e84a                	sd	s2,16(sp)
    80005d54:	fd040793          	addi	a5,s0,-48
    80005d58:	00e784b3          	add	s1,a5,a4
    80005d5c:	fff78913          	addi	s2,a5,-1
    80005d60:	993a                	add	s2,s2,a4
    80005d62:	377d                	addiw	a4,a4,-1
    80005d64:	1702                	slli	a4,a4,0x20
    80005d66:	9301                	srli	a4,a4,0x20
    80005d68:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d6c:	fff4c503          	lbu	a0,-1(s1)
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	d56080e7          	jalr	-682(ra) # 80005ac6 <consputc>
  while(--i >= 0)
    80005d78:	14fd                	addi	s1,s1,-1
    80005d7a:	ff2499e3          	bne	s1,s2,80005d6c <printint+0x7e>
    80005d7e:	64e2                	ld	s1,24(sp)
    80005d80:	6942                	ld	s2,16(sp)
}
    80005d82:	70a2                	ld	ra,40(sp)
    80005d84:	7402                	ld	s0,32(sp)
    80005d86:	6145                	addi	sp,sp,48
    80005d88:	8082                	ret
    x = -xx;
    80005d8a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d8e:	4885                	li	a7,1
    x = -xx;
    80005d90:	bf85                	j	80005d00 <printint+0x12>

0000000080005d92 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d92:	1101                	addi	sp,sp,-32
    80005d94:	ec06                	sd	ra,24(sp)
    80005d96:	e822                	sd	s0,16(sp)
    80005d98:	e426                	sd	s1,8(sp)
    80005d9a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005d9c:	0001c497          	auipc	s1,0x1c
    80005da0:	f9c48493          	addi	s1,s1,-100 # 80021d38 <pr>
    80005da4:	00003597          	auipc	a1,0x3
    80005da8:	96c58593          	addi	a1,a1,-1684 # 80008710 <etext+0x710>
    80005dac:	8526                	mv	a0,s1
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	546080e7          	jalr	1350(ra) # 800062f4 <initlock>
  pr.locking = 1;
    80005db6:	4785                	li	a5,1
    80005db8:	cc9c                	sw	a5,24(s1)
}
    80005dba:	60e2                	ld	ra,24(sp)
    80005dbc:	6442                	ld	s0,16(sp)
    80005dbe:	64a2                	ld	s1,8(sp)
    80005dc0:	6105                	addi	sp,sp,32
    80005dc2:	8082                	ret

0000000080005dc4 <backtrace>:
void 
backtrace (void) 
{
    80005dc4:	7179                	addi	sp,sp,-48
    80005dc6:	f406                	sd	ra,40(sp)
    80005dc8:	f022                	sd	s0,32(sp)
    80005dca:	ec26                	sd	s1,24(sp)
    80005dcc:	e84a                	sd	s2,16(sp)
    80005dce:	e44e                	sd	s3,8(sp)
    80005dd0:	1800                	addi	s0,sp,48
  printf("backtrace :\n");
    80005dd2:	00003517          	auipc	a0,0x3
    80005dd6:	94650513          	addi	a0,a0,-1722 # 80008718 <etext+0x718>
    80005dda:	00000097          	auipc	ra,0x0
    80005dde:	0ac080e7          	jalr	172(ra) # 80005e86 <printf>

static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
    80005de2:	84a2                	mv	s1,s0

  uint64 current_fp = r_fp();

  uint64 end_location1 = PGROUNDUP(current_fp);
    80005de4:	6905                	lui	s2,0x1
    80005de6:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80005de8:	9926                	add	s2,s2,s1
    80005dea:	79fd                	lui	s3,0xfffff
    80005dec:	01397933          	and	s2,s2,s3

  uint64 end_location2 = PGROUNDDOWN(current_fp);
    80005df0:	0134f9b3          	and	s3,s1,s3
  //uint64 value = *(uint64*)(current_fp-16);
  // printf("location is : %p\n",current_fp-16);
  // printf("Before is : %p\n",value);
  // printf("End is : %p\n",end_location);

  while(current_fp <= end_location1 && current_fp >= end_location2){
    80005df4:	02996963          	bltu	s2,s1,80005e26 <backtrace+0x62>
    80005df8:	0334e763          	bltu	s1,s3,80005e26 <backtrace+0x62>
    80005dfc:	e052                	sd	s4,0(sp)
    uint64 value = *(uint64*)(current_fp-8);
    printf("%p\n", value);
    80005dfe:	00003a17          	auipc	s4,0x3
    80005e02:	92aa0a13          	addi	s4,s4,-1750 # 80008728 <etext+0x728>
    80005e06:	ff84b583          	ld	a1,-8(s1)
    80005e0a:	8552                	mv	a0,s4
    80005e0c:	00000097          	auipc	ra,0x0
    80005e10:	07a080e7          	jalr	122(ra) # 80005e86 <printf>
    current_fp = *(uint64*)(current_fp-16);
    80005e14:	ff04b483          	ld	s1,-16(s1)
  while(current_fp <= end_location1 && current_fp >= end_location2){
    80005e18:	00996663          	bltu	s2,s1,80005e24 <backtrace+0x60>
    80005e1c:	ff34f5e3          	bgeu	s1,s3,80005e06 <backtrace+0x42>
    80005e20:	6a02                	ld	s4,0(sp)
    80005e22:	a011                	j	80005e26 <backtrace+0x62>
    80005e24:	6a02                	ld	s4,0(sp)
  }

    80005e26:	70a2                	ld	ra,40(sp)
    80005e28:	7402                	ld	s0,32(sp)
    80005e2a:	64e2                	ld	s1,24(sp)
    80005e2c:	6942                	ld	s2,16(sp)
    80005e2e:	69a2                	ld	s3,8(sp)
    80005e30:	6145                	addi	sp,sp,48
    80005e32:	8082                	ret

0000000080005e34 <panic>:
{
    80005e34:	1101                	addi	sp,sp,-32
    80005e36:	ec06                	sd	ra,24(sp)
    80005e38:	e822                	sd	s0,16(sp)
    80005e3a:	e426                	sd	s1,8(sp)
    80005e3c:	1000                	addi	s0,sp,32
    80005e3e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e40:	0001c797          	auipc	a5,0x1c
    80005e44:	f007a823          	sw	zero,-240(a5) # 80021d50 <pr+0x18>
  printf("panic: ");
    80005e48:	00003517          	auipc	a0,0x3
    80005e4c:	8e850513          	addi	a0,a0,-1816 # 80008730 <etext+0x730>
    80005e50:	00000097          	auipc	ra,0x0
    80005e54:	036080e7          	jalr	54(ra) # 80005e86 <printf>
  printf(s);
    80005e58:	8526                	mv	a0,s1
    80005e5a:	00000097          	auipc	ra,0x0
    80005e5e:	02c080e7          	jalr	44(ra) # 80005e86 <printf>
  printf("\n");
    80005e62:	00002517          	auipc	a0,0x2
    80005e66:	1b650513          	addi	a0,a0,438 # 80008018 <etext+0x18>
    80005e6a:	00000097          	auipc	ra,0x0
    80005e6e:	01c080e7          	jalr	28(ra) # 80005e86 <printf>
  backtrace();
    80005e72:	00000097          	auipc	ra,0x0
    80005e76:	f52080e7          	jalr	-174(ra) # 80005dc4 <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80005e7a:	4785                	li	a5,1
    80005e7c:	00003717          	auipc	a4,0x3
    80005e80:	a8f72823          	sw	a5,-1392(a4) # 8000890c <panicked>
  for(;;)
    80005e84:	a001                	j	80005e84 <panic+0x50>

0000000080005e86 <printf>:
{
    80005e86:	7131                	addi	sp,sp,-192
    80005e88:	fc86                	sd	ra,120(sp)
    80005e8a:	f8a2                	sd	s0,112(sp)
    80005e8c:	e8d2                	sd	s4,80(sp)
    80005e8e:	f06a                	sd	s10,32(sp)
    80005e90:	0100                	addi	s0,sp,128
    80005e92:	8a2a                	mv	s4,a0
    80005e94:	e40c                	sd	a1,8(s0)
    80005e96:	e810                	sd	a2,16(s0)
    80005e98:	ec14                	sd	a3,24(s0)
    80005e9a:	f018                	sd	a4,32(s0)
    80005e9c:	f41c                	sd	a5,40(s0)
    80005e9e:	03043823          	sd	a6,48(s0)
    80005ea2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ea6:	0001cd17          	auipc	s10,0x1c
    80005eaa:	eaad2d03          	lw	s10,-342(s10) # 80021d50 <pr+0x18>
  if(locking)
    80005eae:	040d1463          	bnez	s10,80005ef6 <printf+0x70>
  if (fmt == 0)
    80005eb2:	040a0b63          	beqz	s4,80005f08 <printf+0x82>
  va_start(ap, fmt);
    80005eb6:	00840793          	addi	a5,s0,8
    80005eba:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ebe:	000a4503          	lbu	a0,0(s4)
    80005ec2:	18050b63          	beqz	a0,80006058 <printf+0x1d2>
    80005ec6:	f4a6                	sd	s1,104(sp)
    80005ec8:	f0ca                	sd	s2,96(sp)
    80005eca:	ecce                	sd	s3,88(sp)
    80005ecc:	e4d6                	sd	s5,72(sp)
    80005ece:	e0da                	sd	s6,64(sp)
    80005ed0:	fc5e                	sd	s7,56(sp)
    80005ed2:	f862                	sd	s8,48(sp)
    80005ed4:	f466                	sd	s9,40(sp)
    80005ed6:	ec6e                	sd	s11,24(sp)
    80005ed8:	4981                	li	s3,0
    if(c != '%'){
    80005eda:	02500b13          	li	s6,37
    switch(c){
    80005ede:	07000b93          	li	s7,112
  consputc('x');
    80005ee2:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ee4:	00003a97          	auipc	s5,0x3
    80005ee8:	99ca8a93          	addi	s5,s5,-1636 # 80008880 <digits>
    switch(c){
    80005eec:	07300c13          	li	s8,115
    80005ef0:	06400d93          	li	s11,100
    80005ef4:	a0b1                	j	80005f40 <printf+0xba>
    acquire(&pr.lock);
    80005ef6:	0001c517          	auipc	a0,0x1c
    80005efa:	e4250513          	addi	a0,a0,-446 # 80021d38 <pr>
    80005efe:	00000097          	auipc	ra,0x0
    80005f02:	486080e7          	jalr	1158(ra) # 80006384 <acquire>
    80005f06:	b775                	j	80005eb2 <printf+0x2c>
    80005f08:	f4a6                	sd	s1,104(sp)
    80005f0a:	f0ca                	sd	s2,96(sp)
    80005f0c:	ecce                	sd	s3,88(sp)
    80005f0e:	e4d6                	sd	s5,72(sp)
    80005f10:	e0da                	sd	s6,64(sp)
    80005f12:	fc5e                	sd	s7,56(sp)
    80005f14:	f862                	sd	s8,48(sp)
    80005f16:	f466                	sd	s9,40(sp)
    80005f18:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005f1a:	00003517          	auipc	a0,0x3
    80005f1e:	82650513          	addi	a0,a0,-2010 # 80008740 <etext+0x740>
    80005f22:	00000097          	auipc	ra,0x0
    80005f26:	f12080e7          	jalr	-238(ra) # 80005e34 <panic>
      consputc(c);
    80005f2a:	00000097          	auipc	ra,0x0
    80005f2e:	b9c080e7          	jalr	-1124(ra) # 80005ac6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f32:	2985                	addiw	s3,s3,1 # fffffffffffff001 <end+0xffffffff7ffdd271>
    80005f34:	013a07b3          	add	a5,s4,s3
    80005f38:	0007c503          	lbu	a0,0(a5)
    80005f3c:	10050563          	beqz	a0,80006046 <printf+0x1c0>
    if(c != '%'){
    80005f40:	ff6515e3          	bne	a0,s6,80005f2a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005f44:	2985                	addiw	s3,s3,1
    80005f46:	013a07b3          	add	a5,s4,s3
    80005f4a:	0007c783          	lbu	a5,0(a5)
    80005f4e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f52:	10078b63          	beqz	a5,80006068 <printf+0x1e2>
    switch(c){
    80005f56:	05778a63          	beq	a5,s7,80005faa <printf+0x124>
    80005f5a:	02fbf663          	bgeu	s7,a5,80005f86 <printf+0x100>
    80005f5e:	09878863          	beq	a5,s8,80005fee <printf+0x168>
    80005f62:	07800713          	li	a4,120
    80005f66:	0ce79563          	bne	a5,a4,80006030 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005f6a:	f8843783          	ld	a5,-120(s0)
    80005f6e:	00878713          	addi	a4,a5,8
    80005f72:	f8e43423          	sd	a4,-120(s0)
    80005f76:	4605                	li	a2,1
    80005f78:	85e6                	mv	a1,s9
    80005f7a:	4388                	lw	a0,0(a5)
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	d72080e7          	jalr	-654(ra) # 80005cee <printint>
      break;
    80005f84:	b77d                	j	80005f32 <printf+0xac>
    switch(c){
    80005f86:	09678f63          	beq	a5,s6,80006024 <printf+0x19e>
    80005f8a:	0bb79363          	bne	a5,s11,80006030 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005f8e:	f8843783          	ld	a5,-120(s0)
    80005f92:	00878713          	addi	a4,a5,8
    80005f96:	f8e43423          	sd	a4,-120(s0)
    80005f9a:	4605                	li	a2,1
    80005f9c:	45a9                	li	a1,10
    80005f9e:	4388                	lw	a0,0(a5)
    80005fa0:	00000097          	auipc	ra,0x0
    80005fa4:	d4e080e7          	jalr	-690(ra) # 80005cee <printint>
      break;
    80005fa8:	b769                	j	80005f32 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005faa:	f8843783          	ld	a5,-120(s0)
    80005fae:	00878713          	addi	a4,a5,8
    80005fb2:	f8e43423          	sd	a4,-120(s0)
    80005fb6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005fba:	03000513          	li	a0,48
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	b08080e7          	jalr	-1272(ra) # 80005ac6 <consputc>
  consputc('x');
    80005fc6:	07800513          	li	a0,120
    80005fca:	00000097          	auipc	ra,0x0
    80005fce:	afc080e7          	jalr	-1284(ra) # 80005ac6 <consputc>
    80005fd2:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fd4:	03c95793          	srli	a5,s2,0x3c
    80005fd8:	97d6                	add	a5,a5,s5
    80005fda:	0007c503          	lbu	a0,0(a5)
    80005fde:	00000097          	auipc	ra,0x0
    80005fe2:	ae8080e7          	jalr	-1304(ra) # 80005ac6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fe6:	0912                	slli	s2,s2,0x4
    80005fe8:	34fd                	addiw	s1,s1,-1
    80005fea:	f4ed                	bnez	s1,80005fd4 <printf+0x14e>
    80005fec:	b799                	j	80005f32 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005fee:	f8843783          	ld	a5,-120(s0)
    80005ff2:	00878713          	addi	a4,a5,8
    80005ff6:	f8e43423          	sd	a4,-120(s0)
    80005ffa:	6384                	ld	s1,0(a5)
    80005ffc:	cc89                	beqz	s1,80006016 <printf+0x190>
      for(; *s; s++)
    80005ffe:	0004c503          	lbu	a0,0(s1)
    80006002:	d905                	beqz	a0,80005f32 <printf+0xac>
        consputc(*s);
    80006004:	00000097          	auipc	ra,0x0
    80006008:	ac2080e7          	jalr	-1342(ra) # 80005ac6 <consputc>
      for(; *s; s++)
    8000600c:	0485                	addi	s1,s1,1
    8000600e:	0004c503          	lbu	a0,0(s1)
    80006012:	f96d                	bnez	a0,80006004 <printf+0x17e>
    80006014:	bf39                	j	80005f32 <printf+0xac>
        s = "(null)";
    80006016:	00002497          	auipc	s1,0x2
    8000601a:	72248493          	addi	s1,s1,1826 # 80008738 <etext+0x738>
      for(; *s; s++)
    8000601e:	02800513          	li	a0,40
    80006022:	b7cd                	j	80006004 <printf+0x17e>
      consputc('%');
    80006024:	855a                	mv	a0,s6
    80006026:	00000097          	auipc	ra,0x0
    8000602a:	aa0080e7          	jalr	-1376(ra) # 80005ac6 <consputc>
      break;
    8000602e:	b711                	j	80005f32 <printf+0xac>
      consputc('%');
    80006030:	855a                	mv	a0,s6
    80006032:	00000097          	auipc	ra,0x0
    80006036:	a94080e7          	jalr	-1388(ra) # 80005ac6 <consputc>
      consputc(c);
    8000603a:	8526                	mv	a0,s1
    8000603c:	00000097          	auipc	ra,0x0
    80006040:	a8a080e7          	jalr	-1398(ra) # 80005ac6 <consputc>
      break;
    80006044:	b5fd                	j	80005f32 <printf+0xac>
    80006046:	74a6                	ld	s1,104(sp)
    80006048:	7906                	ld	s2,96(sp)
    8000604a:	69e6                	ld	s3,88(sp)
    8000604c:	6aa6                	ld	s5,72(sp)
    8000604e:	6b06                	ld	s6,64(sp)
    80006050:	7be2                	ld	s7,56(sp)
    80006052:	7c42                	ld	s8,48(sp)
    80006054:	7ca2                	ld	s9,40(sp)
    80006056:	6de2                	ld	s11,24(sp)
  if(locking)
    80006058:	020d1263          	bnez	s10,8000607c <printf+0x1f6>
}
    8000605c:	70e6                	ld	ra,120(sp)
    8000605e:	7446                	ld	s0,112(sp)
    80006060:	6a46                	ld	s4,80(sp)
    80006062:	7d02                	ld	s10,32(sp)
    80006064:	6129                	addi	sp,sp,192
    80006066:	8082                	ret
    80006068:	74a6                	ld	s1,104(sp)
    8000606a:	7906                	ld	s2,96(sp)
    8000606c:	69e6                	ld	s3,88(sp)
    8000606e:	6aa6                	ld	s5,72(sp)
    80006070:	6b06                	ld	s6,64(sp)
    80006072:	7be2                	ld	s7,56(sp)
    80006074:	7c42                	ld	s8,48(sp)
    80006076:	7ca2                	ld	s9,40(sp)
    80006078:	6de2                	ld	s11,24(sp)
    8000607a:	bff9                	j	80006058 <printf+0x1d2>
    release(&pr.lock);
    8000607c:	0001c517          	auipc	a0,0x1c
    80006080:	cbc50513          	addi	a0,a0,-836 # 80021d38 <pr>
    80006084:	00000097          	auipc	ra,0x0
    80006088:	3b4080e7          	jalr	948(ra) # 80006438 <release>
}
    8000608c:	bfc1                	j	8000605c <printf+0x1d6>

000000008000608e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000608e:	1141                	addi	sp,sp,-16
    80006090:	e406                	sd	ra,8(sp)
    80006092:	e022                	sd	s0,0(sp)
    80006094:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006096:	100007b7          	lui	a5,0x10000
    8000609a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000609e:	10000737          	lui	a4,0x10000
    800060a2:	f8000693          	li	a3,-128
    800060a6:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060aa:	468d                	li	a3,3
    800060ac:	10000637          	lui	a2,0x10000
    800060b0:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060b4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060b8:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060bc:	10000737          	lui	a4,0x10000
    800060c0:	461d                	li	a2,7
    800060c2:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060c6:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060ca:	00002597          	auipc	a1,0x2
    800060ce:	68658593          	addi	a1,a1,1670 # 80008750 <etext+0x750>
    800060d2:	0001c517          	auipc	a0,0x1c
    800060d6:	c8650513          	addi	a0,a0,-890 # 80021d58 <uart_tx_lock>
    800060da:	00000097          	auipc	ra,0x0
    800060de:	21a080e7          	jalr	538(ra) # 800062f4 <initlock>
}
    800060e2:	60a2                	ld	ra,8(sp)
    800060e4:	6402                	ld	s0,0(sp)
    800060e6:	0141                	addi	sp,sp,16
    800060e8:	8082                	ret

00000000800060ea <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060ea:	1101                	addi	sp,sp,-32
    800060ec:	ec06                	sd	ra,24(sp)
    800060ee:	e822                	sd	s0,16(sp)
    800060f0:	e426                	sd	s1,8(sp)
    800060f2:	1000                	addi	s0,sp,32
    800060f4:	84aa                	mv	s1,a0
  push_off();
    800060f6:	00000097          	auipc	ra,0x0
    800060fa:	242080e7          	jalr	578(ra) # 80006338 <push_off>

  if(panicked){
    800060fe:	00003797          	auipc	a5,0x3
    80006102:	80e7a783          	lw	a5,-2034(a5) # 8000890c <panicked>
    80006106:	eb85                	bnez	a5,80006136 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006108:	10000737          	lui	a4,0x10000
    8000610c:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000610e:	00074783          	lbu	a5,0(a4)
    80006112:	0207f793          	andi	a5,a5,32
    80006116:	dfe5                	beqz	a5,8000610e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006118:	0ff4f513          	zext.b	a0,s1
    8000611c:	100007b7          	lui	a5,0x10000
    80006120:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006124:	00000097          	auipc	ra,0x0
    80006128:	2b4080e7          	jalr	692(ra) # 800063d8 <pop_off>
}
    8000612c:	60e2                	ld	ra,24(sp)
    8000612e:	6442                	ld	s0,16(sp)
    80006130:	64a2                	ld	s1,8(sp)
    80006132:	6105                	addi	sp,sp,32
    80006134:	8082                	ret
    for(;;)
    80006136:	a001                	j	80006136 <uartputc_sync+0x4c>

0000000080006138 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006138:	00002797          	auipc	a5,0x2
    8000613c:	7d87b783          	ld	a5,2008(a5) # 80008910 <uart_tx_r>
    80006140:	00002717          	auipc	a4,0x2
    80006144:	7d873703          	ld	a4,2008(a4) # 80008918 <uart_tx_w>
    80006148:	06f70f63          	beq	a4,a5,800061c6 <uartstart+0x8e>
{
    8000614c:	7139                	addi	sp,sp,-64
    8000614e:	fc06                	sd	ra,56(sp)
    80006150:	f822                	sd	s0,48(sp)
    80006152:	f426                	sd	s1,40(sp)
    80006154:	f04a                	sd	s2,32(sp)
    80006156:	ec4e                	sd	s3,24(sp)
    80006158:	e852                	sd	s4,16(sp)
    8000615a:	e456                	sd	s5,8(sp)
    8000615c:	e05a                	sd	s6,0(sp)
    8000615e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006160:	10000937          	lui	s2,0x10000
    80006164:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006166:	0001ca97          	auipc	s5,0x1c
    8000616a:	bf2a8a93          	addi	s5,s5,-1038 # 80021d58 <uart_tx_lock>
    uart_tx_r += 1;
    8000616e:	00002497          	auipc	s1,0x2
    80006172:	7a248493          	addi	s1,s1,1954 # 80008910 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006176:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000617a:	00002997          	auipc	s3,0x2
    8000617e:	79e98993          	addi	s3,s3,1950 # 80008918 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006182:	00094703          	lbu	a4,0(s2)
    80006186:	02077713          	andi	a4,a4,32
    8000618a:	c705                	beqz	a4,800061b2 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000618c:	01f7f713          	andi	a4,a5,31
    80006190:	9756                	add	a4,a4,s5
    80006192:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006196:	0785                	addi	a5,a5,1
    80006198:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000619a:	8526                	mv	a0,s1
    8000619c:	ffffb097          	auipc	ra,0xffffb
    800061a0:	47c080e7          	jalr	1148(ra) # 80001618 <wakeup>
    WriteReg(THR, c);
    800061a4:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800061a8:	609c                	ld	a5,0(s1)
    800061aa:	0009b703          	ld	a4,0(s3)
    800061ae:	fcf71ae3          	bne	a4,a5,80006182 <uartstart+0x4a>
  }
}
    800061b2:	70e2                	ld	ra,56(sp)
    800061b4:	7442                	ld	s0,48(sp)
    800061b6:	74a2                	ld	s1,40(sp)
    800061b8:	7902                	ld	s2,32(sp)
    800061ba:	69e2                	ld	s3,24(sp)
    800061bc:	6a42                	ld	s4,16(sp)
    800061be:	6aa2                	ld	s5,8(sp)
    800061c0:	6b02                	ld	s6,0(sp)
    800061c2:	6121                	addi	sp,sp,64
    800061c4:	8082                	ret
    800061c6:	8082                	ret

00000000800061c8 <uartputc>:
{
    800061c8:	7179                	addi	sp,sp,-48
    800061ca:	f406                	sd	ra,40(sp)
    800061cc:	f022                	sd	s0,32(sp)
    800061ce:	ec26                	sd	s1,24(sp)
    800061d0:	e84a                	sd	s2,16(sp)
    800061d2:	e44e                	sd	s3,8(sp)
    800061d4:	e052                	sd	s4,0(sp)
    800061d6:	1800                	addi	s0,sp,48
    800061d8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800061da:	0001c517          	auipc	a0,0x1c
    800061de:	b7e50513          	addi	a0,a0,-1154 # 80021d58 <uart_tx_lock>
    800061e2:	00000097          	auipc	ra,0x0
    800061e6:	1a2080e7          	jalr	418(ra) # 80006384 <acquire>
  if(panicked){
    800061ea:	00002797          	auipc	a5,0x2
    800061ee:	7227a783          	lw	a5,1826(a5) # 8000890c <panicked>
    800061f2:	e7c9                	bnez	a5,8000627c <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061f4:	00002717          	auipc	a4,0x2
    800061f8:	72473703          	ld	a4,1828(a4) # 80008918 <uart_tx_w>
    800061fc:	00002797          	auipc	a5,0x2
    80006200:	7147b783          	ld	a5,1812(a5) # 80008910 <uart_tx_r>
    80006204:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006208:	0001c997          	auipc	s3,0x1c
    8000620c:	b5098993          	addi	s3,s3,-1200 # 80021d58 <uart_tx_lock>
    80006210:	00002497          	auipc	s1,0x2
    80006214:	70048493          	addi	s1,s1,1792 # 80008910 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006218:	00002917          	auipc	s2,0x2
    8000621c:	70090913          	addi	s2,s2,1792 # 80008918 <uart_tx_w>
    80006220:	00e79f63          	bne	a5,a4,8000623e <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006224:	85ce                	mv	a1,s3
    80006226:	8526                	mv	a0,s1
    80006228:	ffffb097          	auipc	ra,0xffffb
    8000622c:	38c080e7          	jalr	908(ra) # 800015b4 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006230:	00093703          	ld	a4,0(s2)
    80006234:	609c                	ld	a5,0(s1)
    80006236:	02078793          	addi	a5,a5,32
    8000623a:	fee785e3          	beq	a5,a4,80006224 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000623e:	0001c497          	auipc	s1,0x1c
    80006242:	b1a48493          	addi	s1,s1,-1254 # 80021d58 <uart_tx_lock>
    80006246:	01f77793          	andi	a5,a4,31
    8000624a:	97a6                	add	a5,a5,s1
    8000624c:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006250:	0705                	addi	a4,a4,1
    80006252:	00002797          	auipc	a5,0x2
    80006256:	6ce7b323          	sd	a4,1734(a5) # 80008918 <uart_tx_w>
  uartstart();
    8000625a:	00000097          	auipc	ra,0x0
    8000625e:	ede080e7          	jalr	-290(ra) # 80006138 <uartstart>
  release(&uart_tx_lock);
    80006262:	8526                	mv	a0,s1
    80006264:	00000097          	auipc	ra,0x0
    80006268:	1d4080e7          	jalr	468(ra) # 80006438 <release>
}
    8000626c:	70a2                	ld	ra,40(sp)
    8000626e:	7402                	ld	s0,32(sp)
    80006270:	64e2                	ld	s1,24(sp)
    80006272:	6942                	ld	s2,16(sp)
    80006274:	69a2                	ld	s3,8(sp)
    80006276:	6a02                	ld	s4,0(sp)
    80006278:	6145                	addi	sp,sp,48
    8000627a:	8082                	ret
    for(;;)
    8000627c:	a001                	j	8000627c <uartputc+0xb4>

000000008000627e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000627e:	1141                	addi	sp,sp,-16
    80006280:	e422                	sd	s0,8(sp)
    80006282:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006284:	100007b7          	lui	a5,0x10000
    80006288:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000628a:	0007c783          	lbu	a5,0(a5)
    8000628e:	8b85                	andi	a5,a5,1
    80006290:	cb81                	beqz	a5,800062a0 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006292:	100007b7          	lui	a5,0x10000
    80006296:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000629a:	6422                	ld	s0,8(sp)
    8000629c:	0141                	addi	sp,sp,16
    8000629e:	8082                	ret
    return -1;
    800062a0:	557d                	li	a0,-1
    800062a2:	bfe5                	j	8000629a <uartgetc+0x1c>

00000000800062a4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800062a4:	1101                	addi	sp,sp,-32
    800062a6:	ec06                	sd	ra,24(sp)
    800062a8:	e822                	sd	s0,16(sp)
    800062aa:	e426                	sd	s1,8(sp)
    800062ac:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062ae:	54fd                	li	s1,-1
    800062b0:	a029                	j	800062ba <uartintr+0x16>
      break;
    consoleintr(c);
    800062b2:	00000097          	auipc	ra,0x0
    800062b6:	856080e7          	jalr	-1962(ra) # 80005b08 <consoleintr>
    int c = uartgetc();
    800062ba:	00000097          	auipc	ra,0x0
    800062be:	fc4080e7          	jalr	-60(ra) # 8000627e <uartgetc>
    if(c == -1)
    800062c2:	fe9518e3          	bne	a0,s1,800062b2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062c6:	0001c497          	auipc	s1,0x1c
    800062ca:	a9248493          	addi	s1,s1,-1390 # 80021d58 <uart_tx_lock>
    800062ce:	8526                	mv	a0,s1
    800062d0:	00000097          	auipc	ra,0x0
    800062d4:	0b4080e7          	jalr	180(ra) # 80006384 <acquire>
  uartstart();
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	e60080e7          	jalr	-416(ra) # 80006138 <uartstart>
  release(&uart_tx_lock);
    800062e0:	8526                	mv	a0,s1
    800062e2:	00000097          	auipc	ra,0x0
    800062e6:	156080e7          	jalr	342(ra) # 80006438 <release>
}
    800062ea:	60e2                	ld	ra,24(sp)
    800062ec:	6442                	ld	s0,16(sp)
    800062ee:	64a2                	ld	s1,8(sp)
    800062f0:	6105                	addi	sp,sp,32
    800062f2:	8082                	ret

00000000800062f4 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062f4:	1141                	addi	sp,sp,-16
    800062f6:	e422                	sd	s0,8(sp)
    800062f8:	0800                	addi	s0,sp,16
  lk->name = name;
    800062fa:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062fc:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006300:	00053823          	sd	zero,16(a0)
}
    80006304:	6422                	ld	s0,8(sp)
    80006306:	0141                	addi	sp,sp,16
    80006308:	8082                	ret

000000008000630a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000630a:	411c                	lw	a5,0(a0)
    8000630c:	e399                	bnez	a5,80006312 <holding+0x8>
    8000630e:	4501                	li	a0,0
  return r;
}
    80006310:	8082                	ret
{
    80006312:	1101                	addi	sp,sp,-32
    80006314:	ec06                	sd	ra,24(sp)
    80006316:	e822                	sd	s0,16(sp)
    80006318:	e426                	sd	s1,8(sp)
    8000631a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000631c:	6904                	ld	s1,16(a0)
    8000631e:	ffffb097          	auipc	ra,0xffffb
    80006322:	bcc080e7          	jalr	-1076(ra) # 80000eea <mycpu>
    80006326:	40a48533          	sub	a0,s1,a0
    8000632a:	00153513          	seqz	a0,a0
}
    8000632e:	60e2                	ld	ra,24(sp)
    80006330:	6442                	ld	s0,16(sp)
    80006332:	64a2                	ld	s1,8(sp)
    80006334:	6105                	addi	sp,sp,32
    80006336:	8082                	ret

0000000080006338 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006338:	1101                	addi	sp,sp,-32
    8000633a:	ec06                	sd	ra,24(sp)
    8000633c:	e822                	sd	s0,16(sp)
    8000633e:	e426                	sd	s1,8(sp)
    80006340:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006342:	100024f3          	csrr	s1,sstatus
    80006346:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000634a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000634c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006350:	ffffb097          	auipc	ra,0xffffb
    80006354:	b9a080e7          	jalr	-1126(ra) # 80000eea <mycpu>
    80006358:	5d3c                	lw	a5,120(a0)
    8000635a:	cf89                	beqz	a5,80006374 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000635c:	ffffb097          	auipc	ra,0xffffb
    80006360:	b8e080e7          	jalr	-1138(ra) # 80000eea <mycpu>
    80006364:	5d3c                	lw	a5,120(a0)
    80006366:	2785                	addiw	a5,a5,1
    80006368:	dd3c                	sw	a5,120(a0)
}
    8000636a:	60e2                	ld	ra,24(sp)
    8000636c:	6442                	ld	s0,16(sp)
    8000636e:	64a2                	ld	s1,8(sp)
    80006370:	6105                	addi	sp,sp,32
    80006372:	8082                	ret
    mycpu()->intena = old;
    80006374:	ffffb097          	auipc	ra,0xffffb
    80006378:	b76080e7          	jalr	-1162(ra) # 80000eea <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000637c:	8085                	srli	s1,s1,0x1
    8000637e:	8885                	andi	s1,s1,1
    80006380:	dd64                	sw	s1,124(a0)
    80006382:	bfe9                	j	8000635c <push_off+0x24>

0000000080006384 <acquire>:
{
    80006384:	1101                	addi	sp,sp,-32
    80006386:	ec06                	sd	ra,24(sp)
    80006388:	e822                	sd	s0,16(sp)
    8000638a:	e426                	sd	s1,8(sp)
    8000638c:	1000                	addi	s0,sp,32
    8000638e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006390:	00000097          	auipc	ra,0x0
    80006394:	fa8080e7          	jalr	-88(ra) # 80006338 <push_off>
  if(holding(lk))
    80006398:	8526                	mv	a0,s1
    8000639a:	00000097          	auipc	ra,0x0
    8000639e:	f70080e7          	jalr	-144(ra) # 8000630a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063a2:	4705                	li	a4,1
  if(holding(lk))
    800063a4:	e115                	bnez	a0,800063c8 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063a6:	87ba                	mv	a5,a4
    800063a8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063ac:	2781                	sext.w	a5,a5
    800063ae:	ffe5                	bnez	a5,800063a6 <acquire+0x22>
  __sync_synchronize();
    800063b0:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063b4:	ffffb097          	auipc	ra,0xffffb
    800063b8:	b36080e7          	jalr	-1226(ra) # 80000eea <mycpu>
    800063bc:	e888                	sd	a0,16(s1)
}
    800063be:	60e2                	ld	ra,24(sp)
    800063c0:	6442                	ld	s0,16(sp)
    800063c2:	64a2                	ld	s1,8(sp)
    800063c4:	6105                	addi	sp,sp,32
    800063c6:	8082                	ret
    panic("acquire");
    800063c8:	00002517          	auipc	a0,0x2
    800063cc:	39050513          	addi	a0,a0,912 # 80008758 <etext+0x758>
    800063d0:	00000097          	auipc	ra,0x0
    800063d4:	a64080e7          	jalr	-1436(ra) # 80005e34 <panic>

00000000800063d8 <pop_off>:

void
pop_off(void)
{
    800063d8:	1141                	addi	sp,sp,-16
    800063da:	e406                	sd	ra,8(sp)
    800063dc:	e022                	sd	s0,0(sp)
    800063de:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063e0:	ffffb097          	auipc	ra,0xffffb
    800063e4:	b0a080e7          	jalr	-1270(ra) # 80000eea <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063e8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063ec:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063ee:	e78d                	bnez	a5,80006418 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063f0:	5d3c                	lw	a5,120(a0)
    800063f2:	02f05b63          	blez	a5,80006428 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063f6:	37fd                	addiw	a5,a5,-1
    800063f8:	0007871b          	sext.w	a4,a5
    800063fc:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063fe:	eb09                	bnez	a4,80006410 <pop_off+0x38>
    80006400:	5d7c                	lw	a5,124(a0)
    80006402:	c799                	beqz	a5,80006410 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006404:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006408:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000640c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006410:	60a2                	ld	ra,8(sp)
    80006412:	6402                	ld	s0,0(sp)
    80006414:	0141                	addi	sp,sp,16
    80006416:	8082                	ret
    panic("pop_off - interruptible");
    80006418:	00002517          	auipc	a0,0x2
    8000641c:	34850513          	addi	a0,a0,840 # 80008760 <etext+0x760>
    80006420:	00000097          	auipc	ra,0x0
    80006424:	a14080e7          	jalr	-1516(ra) # 80005e34 <panic>
    panic("pop_off");
    80006428:	00002517          	auipc	a0,0x2
    8000642c:	35050513          	addi	a0,a0,848 # 80008778 <etext+0x778>
    80006430:	00000097          	auipc	ra,0x0
    80006434:	a04080e7          	jalr	-1532(ra) # 80005e34 <panic>

0000000080006438 <release>:
{
    80006438:	1101                	addi	sp,sp,-32
    8000643a:	ec06                	sd	ra,24(sp)
    8000643c:	e822                	sd	s0,16(sp)
    8000643e:	e426                	sd	s1,8(sp)
    80006440:	1000                	addi	s0,sp,32
    80006442:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006444:	00000097          	auipc	ra,0x0
    80006448:	ec6080e7          	jalr	-314(ra) # 8000630a <holding>
    8000644c:	c115                	beqz	a0,80006470 <release+0x38>
  lk->cpu = 0;
    8000644e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006452:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006456:	0f50000f          	fence	iorw,ow
    8000645a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000645e:	00000097          	auipc	ra,0x0
    80006462:	f7a080e7          	jalr	-134(ra) # 800063d8 <pop_off>
}
    80006466:	60e2                	ld	ra,24(sp)
    80006468:	6442                	ld	s0,16(sp)
    8000646a:	64a2                	ld	s1,8(sp)
    8000646c:	6105                	addi	sp,sp,32
    8000646e:	8082                	ret
    panic("release");
    80006470:	00002517          	auipc	a0,0x2
    80006474:	31050513          	addi	a0,a0,784 # 80008780 <etext+0x780>
    80006478:	00000097          	auipc	ra,0x0
    8000647c:	9bc080e7          	jalr	-1604(ra) # 80005e34 <panic>
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
