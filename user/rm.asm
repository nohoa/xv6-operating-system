
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	328080e7          	jalr	808(ra) # 350 <unlink>
  30:	02054663          	bltz	a0,5c <main+0x5c>
  for(i = 1; i < argc; i++){
  34:	04a1                	addi	s1,s1,8
  36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
  3a:	a81d                	j	70 <main+0x70>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: rm files...\n");
  40:	00000597          	auipc	a1,0x0
  44:	7e058593          	addi	a1,a1,2016 # 820 <malloc+0x100>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	5f0080e7          	jalr	1520(ra) # 63a <fprintf>
    exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	2ac080e7          	jalr	684(ra) # 300 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  5c:	6090                	ld	a2,0(s1)
  5e:	00000597          	auipc	a1,0x0
  62:	7da58593          	addi	a1,a1,2010 # 838 <malloc+0x118>
  66:	4509                	li	a0,2
  68:	00000097          	auipc	ra,0x0
  6c:	5d2080e7          	jalr	1490(ra) # 63a <fprintf>
      break;
    }
  }

  exit(0);
  70:	4501                	li	a0,0
  72:	00000097          	auipc	ra,0x0
  76:	28e080e7          	jalr	654(ra) # 300 <exit>

000000000000007a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  extern int main();
  main();
  82:	00000097          	auipc	ra,0x0
  86:	f7e080e7          	jalr	-130(ra) # 0 <main>
  exit(0);
  8a:	4501                	li	a0,0
  8c:	00000097          	auipc	ra,0x0
  90:	274080e7          	jalr	628(ra) # 300 <exit>

0000000000000094 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9a:	87aa                	mv	a5,a0
  9c:	0585                	addi	a1,a1,1
  9e:	0785                	addi	a5,a5,1
  a0:	fff5c703          	lbu	a4,-1(a1)
  a4:	fee78fa3          	sb	a4,-1(a5)
  a8:	fb75                	bnez	a4,9c <strcpy+0x8>
    ;
  return os;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cb91                	beqz	a5,ce <strcmp+0x1e>
  bc:	0005c703          	lbu	a4,0(a1)
  c0:	00f71763          	bne	a4,a5,ce <strcmp+0x1e>
    p++, q++;
  c4:	0505                	addi	a0,a0,1
  c6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	fbe5                	bnez	a5,bc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ce:	0005c503          	lbu	a0,0(a1)
}
  d2:	40a7853b          	subw	a0,a5,a0
  d6:	6422                	ld	s0,8(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <strlen>:

uint
strlen(const char *s)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e422                	sd	s0,8(sp)
  e0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	cf91                	beqz	a5,102 <strlen+0x26>
  e8:	0505                	addi	a0,a0,1
  ea:	87aa                	mv	a5,a0
  ec:	86be                	mv	a3,a5
  ee:	0785                	addi	a5,a5,1
  f0:	fff7c703          	lbu	a4,-1(a5)
  f4:	ff65                	bnez	a4,ec <strlen+0x10>
  f6:	40a6853b          	subw	a0,a3,a0
  fa:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  fc:	6422                	ld	s0,8(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret
  for(n = 0; s[n]; n++)
 102:	4501                	li	a0,0
 104:	bfe5                	j	fc <strlen+0x20>

0000000000000106 <memset>:

void*
memset(void *dst, int c, uint n)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10c:	ca19                	beqz	a2,122 <memset+0x1c>
 10e:	87aa                	mv	a5,a0
 110:	1602                	slli	a2,a2,0x20
 112:	9201                	srli	a2,a2,0x20
 114:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 118:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11c:	0785                	addi	a5,a5,1
 11e:	fee79de3          	bne	a5,a4,118 <memset+0x12>
  }
  return dst;
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strchr>:

char*
strchr(const char *s, char c)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb99                	beqz	a5,148 <strchr+0x20>
    if(*s == c)
 134:	00f58763          	beq	a1,a5,142 <strchr+0x1a>
  for(; *s; s++)
 138:	0505                	addi	a0,a0,1
 13a:	00054783          	lbu	a5,0(a0)
 13e:	fbfd                	bnez	a5,134 <strchr+0xc>
      return (char*)s;
  return 0;
 140:	4501                	li	a0,0
}
 142:	6422                	ld	s0,8(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret
  return 0;
 148:	4501                	li	a0,0
 14a:	bfe5                	j	142 <strchr+0x1a>

000000000000014c <gets>:

char*
gets(char *buf, int max)
{
 14c:	711d                	addi	sp,sp,-96
 14e:	ec86                	sd	ra,88(sp)
 150:	e8a2                	sd	s0,80(sp)
 152:	e4a6                	sd	s1,72(sp)
 154:	e0ca                	sd	s2,64(sp)
 156:	fc4e                	sd	s3,56(sp)
 158:	f852                	sd	s4,48(sp)
 15a:	f456                	sd	s5,40(sp)
 15c:	f05a                	sd	s6,32(sp)
 15e:	ec5e                	sd	s7,24(sp)
 160:	1080                	addi	s0,sp,96
 162:	8baa                	mv	s7,a0
 164:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 166:	892a                	mv	s2,a0
 168:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16a:	4aa9                	li	s5,10
 16c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 16e:	89a6                	mv	s3,s1
 170:	2485                	addiw	s1,s1,1
 172:	0344d863          	bge	s1,s4,1a2 <gets+0x56>
    cc = read(0, &c, 1);
 176:	4605                	li	a2,1
 178:	faf40593          	addi	a1,s0,-81
 17c:	4501                	li	a0,0
 17e:	00000097          	auipc	ra,0x0
 182:	19a080e7          	jalr	410(ra) # 318 <read>
    if(cc < 1)
 186:	00a05e63          	blez	a0,1a2 <gets+0x56>
    buf[i++] = c;
 18a:	faf44783          	lbu	a5,-81(s0)
 18e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 192:	01578763          	beq	a5,s5,1a0 <gets+0x54>
 196:	0905                	addi	s2,s2,1
 198:	fd679be3          	bne	a5,s6,16e <gets+0x22>
    buf[i++] = c;
 19c:	89a6                	mv	s3,s1
 19e:	a011                	j	1a2 <gets+0x56>
 1a0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a2:	99de                	add	s3,s3,s7
 1a4:	00098023          	sb	zero,0(s3)
  return buf;
}
 1a8:	855e                	mv	a0,s7
 1aa:	60e6                	ld	ra,88(sp)
 1ac:	6446                	ld	s0,80(sp)
 1ae:	64a6                	ld	s1,72(sp)
 1b0:	6906                	ld	s2,64(sp)
 1b2:	79e2                	ld	s3,56(sp)
 1b4:	7a42                	ld	s4,48(sp)
 1b6:	7aa2                	ld	s5,40(sp)
 1b8:	7b02                	ld	s6,32(sp)
 1ba:	6be2                	ld	s7,24(sp)
 1bc:	6125                	addi	sp,sp,96
 1be:	8082                	ret

00000000000001c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c0:	1101                	addi	sp,sp,-32
 1c2:	ec06                	sd	ra,24(sp)
 1c4:	e822                	sd	s0,16(sp)
 1c6:	e04a                	sd	s2,0(sp)
 1c8:	1000                	addi	s0,sp,32
 1ca:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cc:	4581                	li	a1,0
 1ce:	00000097          	auipc	ra,0x0
 1d2:	172080e7          	jalr	370(ra) # 340 <open>
  if(fd < 0)
 1d6:	02054663          	bltz	a0,202 <stat+0x42>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	00000097          	auipc	ra,0x0
 1e4:	178080e7          	jalr	376(ra) # 358 <fstat>
 1e8:	892a                	mv	s2,a0
  close(fd);
 1ea:	8526                	mv	a0,s1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	13c080e7          	jalr	316(ra) # 328 <close>
  return r;
 1f4:	64a2                	ld	s1,8(sp)
}
 1f6:	854a                	mv	a0,s2
 1f8:	60e2                	ld	ra,24(sp)
 1fa:	6442                	ld	s0,16(sp)
 1fc:	6902                	ld	s2,0(sp)
 1fe:	6105                	addi	sp,sp,32
 200:	8082                	ret
    return -1;
 202:	597d                	li	s2,-1
 204:	bfcd                	j	1f6 <stat+0x36>

0000000000000206 <atoi>:

int
atoi(const char *s)
{
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20c:	00054683          	lbu	a3,0(a0)
 210:	fd06879b          	addiw	a5,a3,-48
 214:	0ff7f793          	zext.b	a5,a5
 218:	4625                	li	a2,9
 21a:	02f66863          	bltu	a2,a5,24a <atoi+0x44>
 21e:	872a                	mv	a4,a0
  n = 0;
 220:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 222:	0705                	addi	a4,a4,1
 224:	0025179b          	slliw	a5,a0,0x2
 228:	9fa9                	addw	a5,a5,a0
 22a:	0017979b          	slliw	a5,a5,0x1
 22e:	9fb5                	addw	a5,a5,a3
 230:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 234:	00074683          	lbu	a3,0(a4)
 238:	fd06879b          	addiw	a5,a3,-48
 23c:	0ff7f793          	zext.b	a5,a5
 240:	fef671e3          	bgeu	a2,a5,222 <atoi+0x1c>
  return n;
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  n = 0;
 24a:	4501                	li	a0,0
 24c:	bfe5                	j	244 <atoi+0x3e>

000000000000024e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e422                	sd	s0,8(sp)
 252:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 254:	02b57463          	bgeu	a0,a1,27c <memmove+0x2e>
    while(n-- > 0)
 258:	00c05f63          	blez	a2,276 <memmove+0x28>
 25c:	1602                	slli	a2,a2,0x20
 25e:	9201                	srli	a2,a2,0x20
 260:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 264:	872a                	mv	a4,a0
      *dst++ = *src++;
 266:	0585                	addi	a1,a1,1
 268:	0705                	addi	a4,a4,1
 26a:	fff5c683          	lbu	a3,-1(a1)
 26e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 272:	fef71ae3          	bne	a4,a5,266 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
    dst += n;
 27c:	00c50733          	add	a4,a0,a2
    src += n;
 280:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 282:	fec05ae3          	blez	a2,276 <memmove+0x28>
 286:	fff6079b          	addiw	a5,a2,-1
 28a:	1782                	slli	a5,a5,0x20
 28c:	9381                	srli	a5,a5,0x20
 28e:	fff7c793          	not	a5,a5
 292:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 294:	15fd                	addi	a1,a1,-1
 296:	177d                	addi	a4,a4,-1
 298:	0005c683          	lbu	a3,0(a1)
 29c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a0:	fee79ae3          	bne	a5,a4,294 <memmove+0x46>
 2a4:	bfc9                	j	276 <memmove+0x28>

00000000000002a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ac:	ca05                	beqz	a2,2dc <memcmp+0x36>
 2ae:	fff6069b          	addiw	a3,a2,-1
 2b2:	1682                	slli	a3,a3,0x20
 2b4:	9281                	srli	a3,a3,0x20
 2b6:	0685                	addi	a3,a3,1
 2b8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	0005c703          	lbu	a4,0(a1)
 2c2:	00e79863          	bne	a5,a4,2d2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2c6:	0505                	addi	a0,a0,1
    p2++;
 2c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ca:	fed518e3          	bne	a0,a3,2ba <memcmp+0x14>
  }
  return 0;
 2ce:	4501                	li	a0,0
 2d0:	a019                	j	2d6 <memcmp+0x30>
      return *p1 - *p2;
 2d2:	40e7853b          	subw	a0,a5,a4
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  return 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <memcmp+0x30>

00000000000002e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e406                	sd	ra,8(sp)
 2e4:	e022                	sd	s0,0(sp)
 2e6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e8:	00000097          	auipc	ra,0x0
 2ec:	f66080e7          	jalr	-154(ra) # 24e <memmove>
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f8:	4885                	li	a7,1
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exit>:
.global exit
exit:
 li a7, SYS_exit
 300:	4889                	li	a7,2
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <wait>:
.global wait
wait:
 li a7, SYS_wait
 308:	488d                	li	a7,3
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 310:	4891                	li	a7,4
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <read>:
.global read
read:
 li a7, SYS_read
 318:	4895                	li	a7,5
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <write>:
.global write
write:
 li a7, SYS_write
 320:	48c1                	li	a7,16
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <close>:
.global close
close:
 li a7, SYS_close
 328:	48d5                	li	a7,21
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <kill>:
.global kill
kill:
 li a7, SYS_kill
 330:	4899                	li	a7,6
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <exec>:
.global exec
exec:
 li a7, SYS_exec
 338:	489d                	li	a7,7
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <open>:
.global open
open:
 li a7, SYS_open
 340:	48bd                	li	a7,15
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 348:	48c5                	li	a7,17
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 350:	48c9                	li	a7,18
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 358:	48a1                	li	a7,8
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <link>:
.global link
link:
 li a7, SYS_link
 360:	48cd                	li	a7,19
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 368:	48d1                	li	a7,20
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 370:	48a5                	li	a7,9
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <dup>:
.global dup
dup:
 li a7, SYS_dup
 378:	48a9                	li	a7,10
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 380:	48ad                	li	a7,11
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 388:	48b1                	li	a7,12
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 390:	48b5                	li	a7,13
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 398:	48b9                	li	a7,14
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a0:	1101                	addi	sp,sp,-32
 3a2:	ec06                	sd	ra,24(sp)
 3a4:	e822                	sd	s0,16(sp)
 3a6:	1000                	addi	s0,sp,32
 3a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ac:	4605                	li	a2,1
 3ae:	fef40593          	addi	a1,s0,-17
 3b2:	00000097          	auipc	ra,0x0
 3b6:	f6e080e7          	jalr	-146(ra) # 320 <write>
}
 3ba:	60e2                	ld	ra,24(sp)
 3bc:	6442                	ld	s0,16(sp)
 3be:	6105                	addi	sp,sp,32
 3c0:	8082                	ret

00000000000003c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c2:	7139                	addi	sp,sp,-64
 3c4:	fc06                	sd	ra,56(sp)
 3c6:	f822                	sd	s0,48(sp)
 3c8:	f426                	sd	s1,40(sp)
 3ca:	0080                	addi	s0,sp,64
 3cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ce:	c299                	beqz	a3,3d4 <printint+0x12>
 3d0:	0805cb63          	bltz	a1,466 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3d4:	2581                	sext.w	a1,a1
  neg = 0;
 3d6:	4881                	li	a7,0
 3d8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3dc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3de:	2601                	sext.w	a2,a2
 3e0:	00000517          	auipc	a0,0x0
 3e4:	4d850513          	addi	a0,a0,1240 # 8b8 <digits>
 3e8:	883a                	mv	a6,a4
 3ea:	2705                	addiw	a4,a4,1
 3ec:	02c5f7bb          	remuw	a5,a1,a2
 3f0:	1782                	slli	a5,a5,0x20
 3f2:	9381                	srli	a5,a5,0x20
 3f4:	97aa                	add	a5,a5,a0
 3f6:	0007c783          	lbu	a5,0(a5)
 3fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3fe:	0005879b          	sext.w	a5,a1
 402:	02c5d5bb          	divuw	a1,a1,a2
 406:	0685                	addi	a3,a3,1
 408:	fec7f0e3          	bgeu	a5,a2,3e8 <printint+0x26>
  if(neg)
 40c:	00088c63          	beqz	a7,424 <printint+0x62>
    buf[i++] = '-';
 410:	fd070793          	addi	a5,a4,-48
 414:	00878733          	add	a4,a5,s0
 418:	02d00793          	li	a5,45
 41c:	fef70823          	sb	a5,-16(a4)
 420:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 424:	02e05c63          	blez	a4,45c <printint+0x9a>
 428:	f04a                	sd	s2,32(sp)
 42a:	ec4e                	sd	s3,24(sp)
 42c:	fc040793          	addi	a5,s0,-64
 430:	00e78933          	add	s2,a5,a4
 434:	fff78993          	addi	s3,a5,-1
 438:	99ba                	add	s3,s3,a4
 43a:	377d                	addiw	a4,a4,-1
 43c:	1702                	slli	a4,a4,0x20
 43e:	9301                	srli	a4,a4,0x20
 440:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 444:	fff94583          	lbu	a1,-1(s2)
 448:	8526                	mv	a0,s1
 44a:	00000097          	auipc	ra,0x0
 44e:	f56080e7          	jalr	-170(ra) # 3a0 <putc>
  while(--i >= 0)
 452:	197d                	addi	s2,s2,-1
 454:	ff3918e3          	bne	s2,s3,444 <printint+0x82>
 458:	7902                	ld	s2,32(sp)
 45a:	69e2                	ld	s3,24(sp)
}
 45c:	70e2                	ld	ra,56(sp)
 45e:	7442                	ld	s0,48(sp)
 460:	74a2                	ld	s1,40(sp)
 462:	6121                	addi	sp,sp,64
 464:	8082                	ret
    x = -xx;
 466:	40b005bb          	negw	a1,a1
    neg = 1;
 46a:	4885                	li	a7,1
    x = -xx;
 46c:	b7b5                	j	3d8 <printint+0x16>

000000000000046e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 46e:	715d                	addi	sp,sp,-80
 470:	e486                	sd	ra,72(sp)
 472:	e0a2                	sd	s0,64(sp)
 474:	f84a                	sd	s2,48(sp)
 476:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 478:	0005c903          	lbu	s2,0(a1)
 47c:	1a090a63          	beqz	s2,630 <vprintf+0x1c2>
 480:	fc26                	sd	s1,56(sp)
 482:	f44e                	sd	s3,40(sp)
 484:	f052                	sd	s4,32(sp)
 486:	ec56                	sd	s5,24(sp)
 488:	e85a                	sd	s6,16(sp)
 48a:	e45e                	sd	s7,8(sp)
 48c:	8aaa                	mv	s5,a0
 48e:	8bb2                	mv	s7,a2
 490:	00158493          	addi	s1,a1,1
  state = 0;
 494:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 496:	02500a13          	li	s4,37
 49a:	4b55                	li	s6,21
 49c:	a839                	j	4ba <vprintf+0x4c>
        putc(fd, c);
 49e:	85ca                	mv	a1,s2
 4a0:	8556                	mv	a0,s5
 4a2:	00000097          	auipc	ra,0x0
 4a6:	efe080e7          	jalr	-258(ra) # 3a0 <putc>
 4aa:	a019                	j	4b0 <vprintf+0x42>
    } else if(state == '%'){
 4ac:	01498d63          	beq	s3,s4,4c6 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4b0:	0485                	addi	s1,s1,1
 4b2:	fff4c903          	lbu	s2,-1(s1)
 4b6:	16090763          	beqz	s2,624 <vprintf+0x1b6>
    if(state == 0){
 4ba:	fe0999e3          	bnez	s3,4ac <vprintf+0x3e>
      if(c == '%'){
 4be:	ff4910e3          	bne	s2,s4,49e <vprintf+0x30>
        state = '%';
 4c2:	89d2                	mv	s3,s4
 4c4:	b7f5                	j	4b0 <vprintf+0x42>
      if(c == 'd'){
 4c6:	13490463          	beq	s2,s4,5ee <vprintf+0x180>
 4ca:	f9d9079b          	addiw	a5,s2,-99
 4ce:	0ff7f793          	zext.b	a5,a5
 4d2:	12fb6763          	bltu	s6,a5,600 <vprintf+0x192>
 4d6:	f9d9079b          	addiw	a5,s2,-99
 4da:	0ff7f713          	zext.b	a4,a5
 4de:	12eb6163          	bltu	s6,a4,600 <vprintf+0x192>
 4e2:	00271793          	slli	a5,a4,0x2
 4e6:	00000717          	auipc	a4,0x0
 4ea:	37a70713          	addi	a4,a4,890 # 860 <malloc+0x140>
 4ee:	97ba                	add	a5,a5,a4
 4f0:	439c                	lw	a5,0(a5)
 4f2:	97ba                	add	a5,a5,a4
 4f4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4f6:	008b8913          	addi	s2,s7,8
 4fa:	4685                	li	a3,1
 4fc:	4629                	li	a2,10
 4fe:	000ba583          	lw	a1,0(s7)
 502:	8556                	mv	a0,s5
 504:	00000097          	auipc	ra,0x0
 508:	ebe080e7          	jalr	-322(ra) # 3c2 <printint>
 50c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 50e:	4981                	li	s3,0
 510:	b745                	j	4b0 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 512:	008b8913          	addi	s2,s7,8
 516:	4681                	li	a3,0
 518:	4629                	li	a2,10
 51a:	000ba583          	lw	a1,0(s7)
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	ea2080e7          	jalr	-350(ra) # 3c2 <printint>
 528:	8bca                	mv	s7,s2
      state = 0;
 52a:	4981                	li	s3,0
 52c:	b751                	j	4b0 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 52e:	008b8913          	addi	s2,s7,8
 532:	4681                	li	a3,0
 534:	4641                	li	a2,16
 536:	000ba583          	lw	a1,0(s7)
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	e86080e7          	jalr	-378(ra) # 3c2 <printint>
 544:	8bca                	mv	s7,s2
      state = 0;
 546:	4981                	li	s3,0
 548:	b7a5                	j	4b0 <vprintf+0x42>
 54a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 54c:	008b8c13          	addi	s8,s7,8
 550:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 554:	03000593          	li	a1,48
 558:	8556                	mv	a0,s5
 55a:	00000097          	auipc	ra,0x0
 55e:	e46080e7          	jalr	-442(ra) # 3a0 <putc>
  putc(fd, 'x');
 562:	07800593          	li	a1,120
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	e38080e7          	jalr	-456(ra) # 3a0 <putc>
 570:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 572:	00000b97          	auipc	s7,0x0
 576:	346b8b93          	addi	s7,s7,838 # 8b8 <digits>
 57a:	03c9d793          	srli	a5,s3,0x3c
 57e:	97de                	add	a5,a5,s7
 580:	0007c583          	lbu	a1,0(a5)
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	e1a080e7          	jalr	-486(ra) # 3a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 58e:	0992                	slli	s3,s3,0x4
 590:	397d                	addiw	s2,s2,-1
 592:	fe0914e3          	bnez	s2,57a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 596:	8be2                	mv	s7,s8
      state = 0;
 598:	4981                	li	s3,0
 59a:	6c02                	ld	s8,0(sp)
 59c:	bf11                	j	4b0 <vprintf+0x42>
        s = va_arg(ap, char*);
 59e:	008b8993          	addi	s3,s7,8
 5a2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5a6:	02090163          	beqz	s2,5c8 <vprintf+0x15a>
        while(*s != 0){
 5aa:	00094583          	lbu	a1,0(s2)
 5ae:	c9a5                	beqz	a1,61e <vprintf+0x1b0>
          putc(fd, *s);
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	dee080e7          	jalr	-530(ra) # 3a0 <putc>
          s++;
 5ba:	0905                	addi	s2,s2,1
        while(*s != 0){
 5bc:	00094583          	lbu	a1,0(s2)
 5c0:	f9e5                	bnez	a1,5b0 <vprintf+0x142>
        s = va_arg(ap, char*);
 5c2:	8bce                	mv	s7,s3
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b5ed                	j	4b0 <vprintf+0x42>
          s = "(null)";
 5c8:	00000917          	auipc	s2,0x0
 5cc:	29090913          	addi	s2,s2,656 # 858 <malloc+0x138>
        while(*s != 0){
 5d0:	02800593          	li	a1,40
 5d4:	bff1                	j	5b0 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5d6:	008b8913          	addi	s2,s7,8
 5da:	000bc583          	lbu	a1,0(s7)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	dc0080e7          	jalr	-576(ra) # 3a0 <putc>
 5e8:	8bca                	mv	s7,s2
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b5d1                	j	4b0 <vprintf+0x42>
        putc(fd, c);
 5ee:	02500593          	li	a1,37
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	dac080e7          	jalr	-596(ra) # 3a0 <putc>
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	bd4d                	j	4b0 <vprintf+0x42>
        putc(fd, '%');
 600:	02500593          	li	a1,37
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	d9a080e7          	jalr	-614(ra) # 3a0 <putc>
        putc(fd, c);
 60e:	85ca                	mv	a1,s2
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	d8e080e7          	jalr	-626(ra) # 3a0 <putc>
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bd51                	j	4b0 <vprintf+0x42>
        s = va_arg(ap, char*);
 61e:	8bce                	mv	s7,s3
      state = 0;
 620:	4981                	li	s3,0
 622:	b579                	j	4b0 <vprintf+0x42>
 624:	74e2                	ld	s1,56(sp)
 626:	79a2                	ld	s3,40(sp)
 628:	7a02                	ld	s4,32(sp)
 62a:	6ae2                	ld	s5,24(sp)
 62c:	6b42                	ld	s6,16(sp)
 62e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 630:	60a6                	ld	ra,72(sp)
 632:	6406                	ld	s0,64(sp)
 634:	7942                	ld	s2,48(sp)
 636:	6161                	addi	sp,sp,80
 638:	8082                	ret

000000000000063a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 63a:	715d                	addi	sp,sp,-80
 63c:	ec06                	sd	ra,24(sp)
 63e:	e822                	sd	s0,16(sp)
 640:	1000                	addi	s0,sp,32
 642:	e010                	sd	a2,0(s0)
 644:	e414                	sd	a3,8(s0)
 646:	e818                	sd	a4,16(s0)
 648:	ec1c                	sd	a5,24(s0)
 64a:	03043023          	sd	a6,32(s0)
 64e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 652:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 656:	8622                	mv	a2,s0
 658:	00000097          	auipc	ra,0x0
 65c:	e16080e7          	jalr	-490(ra) # 46e <vprintf>
}
 660:	60e2                	ld	ra,24(sp)
 662:	6442                	ld	s0,16(sp)
 664:	6161                	addi	sp,sp,80
 666:	8082                	ret

0000000000000668 <printf>:

void
printf(const char *fmt, ...)
{
 668:	711d                	addi	sp,sp,-96
 66a:	ec06                	sd	ra,24(sp)
 66c:	e822                	sd	s0,16(sp)
 66e:	1000                	addi	s0,sp,32
 670:	e40c                	sd	a1,8(s0)
 672:	e810                	sd	a2,16(s0)
 674:	ec14                	sd	a3,24(s0)
 676:	f018                	sd	a4,32(s0)
 678:	f41c                	sd	a5,40(s0)
 67a:	03043823          	sd	a6,48(s0)
 67e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 682:	00840613          	addi	a2,s0,8
 686:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 68a:	85aa                	mv	a1,a0
 68c:	4505                	li	a0,1
 68e:	00000097          	auipc	ra,0x0
 692:	de0080e7          	jalr	-544(ra) # 46e <vprintf>
}
 696:	60e2                	ld	ra,24(sp)
 698:	6442                	ld	s0,16(sp)
 69a:	6125                	addi	sp,sp,96
 69c:	8082                	ret

000000000000069e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69e:	1141                	addi	sp,sp,-16
 6a0:	e422                	sd	s0,8(sp)
 6a2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a8:	00001797          	auipc	a5,0x1
 6ac:	9587b783          	ld	a5,-1704(a5) # 1000 <freep>
 6b0:	a02d                	j	6da <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6b2:	4618                	lw	a4,8(a2)
 6b4:	9f2d                	addw	a4,a4,a1
 6b6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ba:	6398                	ld	a4,0(a5)
 6bc:	6310                	ld	a2,0(a4)
 6be:	a83d                	j	6fc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c0:	ff852703          	lw	a4,-8(a0)
 6c4:	9f31                	addw	a4,a4,a2
 6c6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6c8:	ff053683          	ld	a3,-16(a0)
 6cc:	a091                	j	710 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ce:	6398                	ld	a4,0(a5)
 6d0:	00e7e463          	bltu	a5,a4,6d8 <free+0x3a>
 6d4:	00e6ea63          	bltu	a3,a4,6e8 <free+0x4a>
{
 6d8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6da:	fed7fae3          	bgeu	a5,a3,6ce <free+0x30>
 6de:	6398                	ld	a4,0(a5)
 6e0:	00e6e463          	bltu	a3,a4,6e8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e4:	fee7eae3          	bltu	a5,a4,6d8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6e8:	ff852583          	lw	a1,-8(a0)
 6ec:	6390                	ld	a2,0(a5)
 6ee:	02059813          	slli	a6,a1,0x20
 6f2:	01c85713          	srli	a4,a6,0x1c
 6f6:	9736                	add	a4,a4,a3
 6f8:	fae60de3          	beq	a2,a4,6b2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6fc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 700:	4790                	lw	a2,8(a5)
 702:	02061593          	slli	a1,a2,0x20
 706:	01c5d713          	srli	a4,a1,0x1c
 70a:	973e                	add	a4,a4,a5
 70c:	fae68ae3          	beq	a3,a4,6c0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 710:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 712:	00001717          	auipc	a4,0x1
 716:	8ef73723          	sd	a5,-1810(a4) # 1000 <freep>
}
 71a:	6422                	ld	s0,8(sp)
 71c:	0141                	addi	sp,sp,16
 71e:	8082                	ret

0000000000000720 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 720:	7139                	addi	sp,sp,-64
 722:	fc06                	sd	ra,56(sp)
 724:	f822                	sd	s0,48(sp)
 726:	f426                	sd	s1,40(sp)
 728:	ec4e                	sd	s3,24(sp)
 72a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 72c:	02051493          	slli	s1,a0,0x20
 730:	9081                	srli	s1,s1,0x20
 732:	04bd                	addi	s1,s1,15
 734:	8091                	srli	s1,s1,0x4
 736:	0014899b          	addiw	s3,s1,1
 73a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 73c:	00001517          	auipc	a0,0x1
 740:	8c453503          	ld	a0,-1852(a0) # 1000 <freep>
 744:	c915                	beqz	a0,778 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 746:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 748:	4798                	lw	a4,8(a5)
 74a:	08977e63          	bgeu	a4,s1,7e6 <malloc+0xc6>
 74e:	f04a                	sd	s2,32(sp)
 750:	e852                	sd	s4,16(sp)
 752:	e456                	sd	s5,8(sp)
 754:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 756:	8a4e                	mv	s4,s3
 758:	0009871b          	sext.w	a4,s3
 75c:	6685                	lui	a3,0x1
 75e:	00d77363          	bgeu	a4,a3,764 <malloc+0x44>
 762:	6a05                	lui	s4,0x1
 764:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 768:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 76c:	00001917          	auipc	s2,0x1
 770:	89490913          	addi	s2,s2,-1900 # 1000 <freep>
  if(p == (char*)-1)
 774:	5afd                	li	s5,-1
 776:	a091                	j	7ba <malloc+0x9a>
 778:	f04a                	sd	s2,32(sp)
 77a:	e852                	sd	s4,16(sp)
 77c:	e456                	sd	s5,8(sp)
 77e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 780:	00001797          	auipc	a5,0x1
 784:	89078793          	addi	a5,a5,-1904 # 1010 <base>
 788:	00001717          	auipc	a4,0x1
 78c:	86f73c23          	sd	a5,-1928(a4) # 1000 <freep>
 790:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 792:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 796:	b7c1                	j	756 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 798:	6398                	ld	a4,0(a5)
 79a:	e118                	sd	a4,0(a0)
 79c:	a08d                	j	7fe <malloc+0xde>
  hp->s.size = nu;
 79e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7a2:	0541                	addi	a0,a0,16
 7a4:	00000097          	auipc	ra,0x0
 7a8:	efa080e7          	jalr	-262(ra) # 69e <free>
  return freep;
 7ac:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7b0:	c13d                	beqz	a0,816 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b4:	4798                	lw	a4,8(a5)
 7b6:	02977463          	bgeu	a4,s1,7de <malloc+0xbe>
    if(p == freep)
 7ba:	00093703          	ld	a4,0(s2)
 7be:	853e                	mv	a0,a5
 7c0:	fef719e3          	bne	a4,a5,7b2 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 7c4:	8552                	mv	a0,s4
 7c6:	00000097          	auipc	ra,0x0
 7ca:	bc2080e7          	jalr	-1086(ra) # 388 <sbrk>
  if(p == (char*)-1)
 7ce:	fd5518e3          	bne	a0,s5,79e <malloc+0x7e>
        return 0;
 7d2:	4501                	li	a0,0
 7d4:	7902                	ld	s2,32(sp)
 7d6:	6a42                	ld	s4,16(sp)
 7d8:	6aa2                	ld	s5,8(sp)
 7da:	6b02                	ld	s6,0(sp)
 7dc:	a03d                	j	80a <malloc+0xea>
 7de:	7902                	ld	s2,32(sp)
 7e0:	6a42                	ld	s4,16(sp)
 7e2:	6aa2                	ld	s5,8(sp)
 7e4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7e6:	fae489e3          	beq	s1,a4,798 <malloc+0x78>
        p->s.size -= nunits;
 7ea:	4137073b          	subw	a4,a4,s3
 7ee:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7f0:	02071693          	slli	a3,a4,0x20
 7f4:	01c6d713          	srli	a4,a3,0x1c
 7f8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7fa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7fe:	00001717          	auipc	a4,0x1
 802:	80a73123          	sd	a0,-2046(a4) # 1000 <freep>
      return (void*)(p + 1);
 806:	01078513          	addi	a0,a5,16
  }
}
 80a:	70e2                	ld	ra,56(sp)
 80c:	7442                	ld	s0,48(sp)
 80e:	74a2                	ld	s1,40(sp)
 810:	69e2                	ld	s3,24(sp)
 812:	6121                	addi	sp,sp,64
 814:	8082                	ret
 816:	7902                	ld	s2,32(sp)
 818:	6a42                	ld	s4,16(sp)
 81a:	6aa2                	ld	s5,8(sp)
 81c:	6b02                	ld	s6,0(sp)
 81e:	b7f5                	j	80a <malloc+0xea>
