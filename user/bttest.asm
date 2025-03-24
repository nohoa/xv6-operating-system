
user/_bttest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  sleep(1);
   8:	4505                	li	a0,1
   a:	00000097          	auipc	ra,0x0
   e:	328080e7          	jalr	808(ra) # 332 <sleep>
  exit(0);
  12:	4501                	li	a0,0
  14:	00000097          	auipc	ra,0x0
  18:	28e080e7          	jalr	654(ra) # 2a2 <exit>

000000000000001c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  1c:	1141                	addi	sp,sp,-16
  1e:	e406                	sd	ra,8(sp)
  20:	e022                	sd	s0,0(sp)
  22:	0800                	addi	s0,sp,16
  extern int main();
  main();
  24:	00000097          	auipc	ra,0x0
  28:	fdc080e7          	jalr	-36(ra) # 0 <main>
  exit(0);
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	274080e7          	jalr	628(ra) # 2a2 <exit>

0000000000000036 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  36:	1141                	addi	sp,sp,-16
  38:	e422                	sd	s0,8(sp)
  3a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3c:	87aa                	mv	a5,a0
  3e:	0585                	addi	a1,a1,1
  40:	0785                	addi	a5,a5,1
  42:	fff5c703          	lbu	a4,-1(a1)
  46:	fee78fa3          	sb	a4,-1(a5)
  4a:	fb75                	bnez	a4,3e <strcpy+0x8>
    ;
  return os;
}
  4c:	6422                	ld	s0,8(sp)
  4e:	0141                	addi	sp,sp,16
  50:	8082                	ret

0000000000000052 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  52:	1141                	addi	sp,sp,-16
  54:	e422                	sd	s0,8(sp)
  56:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  58:	00054783          	lbu	a5,0(a0)
  5c:	cb91                	beqz	a5,70 <strcmp+0x1e>
  5e:	0005c703          	lbu	a4,0(a1)
  62:	00f71763          	bne	a4,a5,70 <strcmp+0x1e>
    p++, q++;
  66:	0505                	addi	a0,a0,1
  68:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	fbe5                	bnez	a5,5e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  70:	0005c503          	lbu	a0,0(a1)
}
  74:	40a7853b          	subw	a0,a5,a0
  78:	6422                	ld	s0,8(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strlen>:

uint
strlen(const char *s)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  84:	00054783          	lbu	a5,0(a0)
  88:	cf91                	beqz	a5,a4 <strlen+0x26>
  8a:	0505                	addi	a0,a0,1
  8c:	87aa                	mv	a5,a0
  8e:	86be                	mv	a3,a5
  90:	0785                	addi	a5,a5,1
  92:	fff7c703          	lbu	a4,-1(a5)
  96:	ff65                	bnez	a4,8e <strlen+0x10>
  98:	40a6853b          	subw	a0,a3,a0
  9c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  9e:	6422                	ld	s0,8(sp)
  a0:	0141                	addi	sp,sp,16
  a2:	8082                	ret
  for(n = 0; s[n]; n++)
  a4:	4501                	li	a0,0
  a6:	bfe5                	j	9e <strlen+0x20>

00000000000000a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ae:	ca19                	beqz	a2,c4 <memset+0x1c>
  b0:	87aa                	mv	a5,a0
  b2:	1602                	slli	a2,a2,0x20
  b4:	9201                	srli	a2,a2,0x20
  b6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ba:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  be:	0785                	addi	a5,a5,1
  c0:	fee79de3          	bne	a5,a4,ba <memset+0x12>
  }
  return dst;
}
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strchr>:

char*
strchr(const char *s, char c)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cb99                	beqz	a5,ea <strchr+0x20>
    if(*s == c)
  d6:	00f58763          	beq	a1,a5,e4 <strchr+0x1a>
  for(; *s; s++)
  da:	0505                	addi	a0,a0,1
  dc:	00054783          	lbu	a5,0(a0)
  e0:	fbfd                	bnez	a5,d6 <strchr+0xc>
      return (char*)s;
  return 0;
  e2:	4501                	li	a0,0
}
  e4:	6422                	ld	s0,8(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret
  return 0;
  ea:	4501                	li	a0,0
  ec:	bfe5                	j	e4 <strchr+0x1a>

00000000000000ee <gets>:

char*
gets(char *buf, int max)
{
  ee:	711d                	addi	sp,sp,-96
  f0:	ec86                	sd	ra,88(sp)
  f2:	e8a2                	sd	s0,80(sp)
  f4:	e4a6                	sd	s1,72(sp)
  f6:	e0ca                	sd	s2,64(sp)
  f8:	fc4e                	sd	s3,56(sp)
  fa:	f852                	sd	s4,48(sp)
  fc:	f456                	sd	s5,40(sp)
  fe:	f05a                	sd	s6,32(sp)
 100:	ec5e                	sd	s7,24(sp)
 102:	1080                	addi	s0,sp,96
 104:	8baa                	mv	s7,a0
 106:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 108:	892a                	mv	s2,a0
 10a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 10c:	4aa9                	li	s5,10
 10e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 110:	89a6                	mv	s3,s1
 112:	2485                	addiw	s1,s1,1
 114:	0344d863          	bge	s1,s4,144 <gets+0x56>
    cc = read(0, &c, 1);
 118:	4605                	li	a2,1
 11a:	faf40593          	addi	a1,s0,-81
 11e:	4501                	li	a0,0
 120:	00000097          	auipc	ra,0x0
 124:	19a080e7          	jalr	410(ra) # 2ba <read>
    if(cc < 1)
 128:	00a05e63          	blez	a0,144 <gets+0x56>
    buf[i++] = c;
 12c:	faf44783          	lbu	a5,-81(s0)
 130:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 134:	01578763          	beq	a5,s5,142 <gets+0x54>
 138:	0905                	addi	s2,s2,1
 13a:	fd679be3          	bne	a5,s6,110 <gets+0x22>
    buf[i++] = c;
 13e:	89a6                	mv	s3,s1
 140:	a011                	j	144 <gets+0x56>
 142:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 144:	99de                	add	s3,s3,s7
 146:	00098023          	sb	zero,0(s3)
  return buf;
}
 14a:	855e                	mv	a0,s7
 14c:	60e6                	ld	ra,88(sp)
 14e:	6446                	ld	s0,80(sp)
 150:	64a6                	ld	s1,72(sp)
 152:	6906                	ld	s2,64(sp)
 154:	79e2                	ld	s3,56(sp)
 156:	7a42                	ld	s4,48(sp)
 158:	7aa2                	ld	s5,40(sp)
 15a:	7b02                	ld	s6,32(sp)
 15c:	6be2                	ld	s7,24(sp)
 15e:	6125                	addi	sp,sp,96
 160:	8082                	ret

0000000000000162 <stat>:

int
stat(const char *n, struct stat *st)
{
 162:	1101                	addi	sp,sp,-32
 164:	ec06                	sd	ra,24(sp)
 166:	e822                	sd	s0,16(sp)
 168:	e04a                	sd	s2,0(sp)
 16a:	1000                	addi	s0,sp,32
 16c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16e:	4581                	li	a1,0
 170:	00000097          	auipc	ra,0x0
 174:	172080e7          	jalr	370(ra) # 2e2 <open>
  if(fd < 0)
 178:	02054663          	bltz	a0,1a4 <stat+0x42>
 17c:	e426                	sd	s1,8(sp)
 17e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 180:	85ca                	mv	a1,s2
 182:	00000097          	auipc	ra,0x0
 186:	178080e7          	jalr	376(ra) # 2fa <fstat>
 18a:	892a                	mv	s2,a0
  close(fd);
 18c:	8526                	mv	a0,s1
 18e:	00000097          	auipc	ra,0x0
 192:	13c080e7          	jalr	316(ra) # 2ca <close>
  return r;
 196:	64a2                	ld	s1,8(sp)
}
 198:	854a                	mv	a0,s2
 19a:	60e2                	ld	ra,24(sp)
 19c:	6442                	ld	s0,16(sp)
 19e:	6902                	ld	s2,0(sp)
 1a0:	6105                	addi	sp,sp,32
 1a2:	8082                	ret
    return -1;
 1a4:	597d                	li	s2,-1
 1a6:	bfcd                	j	198 <stat+0x36>

00000000000001a8 <atoi>:

int
atoi(const char *s)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ae:	00054683          	lbu	a3,0(a0)
 1b2:	fd06879b          	addiw	a5,a3,-48
 1b6:	0ff7f793          	zext.b	a5,a5
 1ba:	4625                	li	a2,9
 1bc:	02f66863          	bltu	a2,a5,1ec <atoi+0x44>
 1c0:	872a                	mv	a4,a0
  n = 0;
 1c2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1c4:	0705                	addi	a4,a4,1
 1c6:	0025179b          	slliw	a5,a0,0x2
 1ca:	9fa9                	addw	a5,a5,a0
 1cc:	0017979b          	slliw	a5,a5,0x1
 1d0:	9fb5                	addw	a5,a5,a3
 1d2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d6:	00074683          	lbu	a3,0(a4)
 1da:	fd06879b          	addiw	a5,a3,-48
 1de:	0ff7f793          	zext.b	a5,a5
 1e2:	fef671e3          	bgeu	a2,a5,1c4 <atoi+0x1c>
  return n;
}
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret
  n = 0;
 1ec:	4501                	li	a0,0
 1ee:	bfe5                	j	1e6 <atoi+0x3e>

00000000000001f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f6:	02b57463          	bgeu	a0,a1,21e <memmove+0x2e>
    while(n-- > 0)
 1fa:	00c05f63          	blez	a2,218 <memmove+0x28>
 1fe:	1602                	slli	a2,a2,0x20
 200:	9201                	srli	a2,a2,0x20
 202:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 206:	872a                	mv	a4,a0
      *dst++ = *src++;
 208:	0585                	addi	a1,a1,1
 20a:	0705                	addi	a4,a4,1
 20c:	fff5c683          	lbu	a3,-1(a1)
 210:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 214:	fef71ae3          	bne	a4,a5,208 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
    dst += n;
 21e:	00c50733          	add	a4,a0,a2
    src += n;
 222:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 224:	fec05ae3          	blez	a2,218 <memmove+0x28>
 228:	fff6079b          	addiw	a5,a2,-1
 22c:	1782                	slli	a5,a5,0x20
 22e:	9381                	srli	a5,a5,0x20
 230:	fff7c793          	not	a5,a5
 234:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 236:	15fd                	addi	a1,a1,-1
 238:	177d                	addi	a4,a4,-1
 23a:	0005c683          	lbu	a3,0(a1)
 23e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 242:	fee79ae3          	bne	a5,a4,236 <memmove+0x46>
 246:	bfc9                	j	218 <memmove+0x28>

0000000000000248 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e422                	sd	s0,8(sp)
 24c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 24e:	ca05                	beqz	a2,27e <memcmp+0x36>
 250:	fff6069b          	addiw	a3,a2,-1
 254:	1682                	slli	a3,a3,0x20
 256:	9281                	srli	a3,a3,0x20
 258:	0685                	addi	a3,a3,1
 25a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 25c:	00054783          	lbu	a5,0(a0)
 260:	0005c703          	lbu	a4,0(a1)
 264:	00e79863          	bne	a5,a4,274 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 268:	0505                	addi	a0,a0,1
    p2++;
 26a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 26c:	fed518e3          	bne	a0,a3,25c <memcmp+0x14>
  }
  return 0;
 270:	4501                	li	a0,0
 272:	a019                	j	278 <memcmp+0x30>
      return *p1 - *p2;
 274:	40e7853b          	subw	a0,a5,a4
}
 278:	6422                	ld	s0,8(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
  return 0;
 27e:	4501                	li	a0,0
 280:	bfe5                	j	278 <memcmp+0x30>

0000000000000282 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 28a:	00000097          	auipc	ra,0x0
 28e:	f66080e7          	jalr	-154(ra) # 1f0 <memmove>
}
 292:	60a2                	ld	ra,8(sp)
 294:	6402                	ld	s0,0(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret

000000000000029a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 29a:	4885                	li	a7,1
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2a2:	4889                	li	a7,2
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <wait>:
.global wait
wait:
 li a7, SYS_wait
 2aa:	488d                	li	a7,3
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2b2:	4891                	li	a7,4
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <read>:
.global read
read:
 li a7, SYS_read
 2ba:	4895                	li	a7,5
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <write>:
.global write
write:
 li a7, SYS_write
 2c2:	48c1                	li	a7,16
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <close>:
.global close
close:
 li a7, SYS_close
 2ca:	48d5                	li	a7,21
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2d2:	4899                	li	a7,6
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <exec>:
.global exec
exec:
 li a7, SYS_exec
 2da:	489d                	li	a7,7
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <open>:
.global open
open:
 li a7, SYS_open
 2e2:	48bd                	li	a7,15
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2ea:	48c5                	li	a7,17
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2f2:	48c9                	li	a7,18
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2fa:	48a1                	li	a7,8
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <link>:
.global link
link:
 li a7, SYS_link
 302:	48cd                	li	a7,19
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 30a:	48d1                	li	a7,20
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 312:	48a5                	li	a7,9
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <dup>:
.global dup
dup:
 li a7, SYS_dup
 31a:	48a9                	li	a7,10
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 322:	48ad                	li	a7,11
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 32a:	48b1                	li	a7,12
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 332:	48b5                	li	a7,13
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 33a:	48b9                	li	a7,14
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 342:	1101                	addi	sp,sp,-32
 344:	ec06                	sd	ra,24(sp)
 346:	e822                	sd	s0,16(sp)
 348:	1000                	addi	s0,sp,32
 34a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 34e:	4605                	li	a2,1
 350:	fef40593          	addi	a1,s0,-17
 354:	00000097          	auipc	ra,0x0
 358:	f6e080e7          	jalr	-146(ra) # 2c2 <write>
}
 35c:	60e2                	ld	ra,24(sp)
 35e:	6442                	ld	s0,16(sp)
 360:	6105                	addi	sp,sp,32
 362:	8082                	ret

0000000000000364 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 364:	7139                	addi	sp,sp,-64
 366:	fc06                	sd	ra,56(sp)
 368:	f822                	sd	s0,48(sp)
 36a:	f426                	sd	s1,40(sp)
 36c:	0080                	addi	s0,sp,64
 36e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 370:	c299                	beqz	a3,376 <printint+0x12>
 372:	0805cb63          	bltz	a1,408 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 376:	2581                	sext.w	a1,a1
  neg = 0;
 378:	4881                	li	a7,0
 37a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 37e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 380:	2601                	sext.w	a2,a2
 382:	00000517          	auipc	a0,0x0
 386:	4ae50513          	addi	a0,a0,1198 # 830 <digits>
 38a:	883a                	mv	a6,a4
 38c:	2705                	addiw	a4,a4,1
 38e:	02c5f7bb          	remuw	a5,a1,a2
 392:	1782                	slli	a5,a5,0x20
 394:	9381                	srli	a5,a5,0x20
 396:	97aa                	add	a5,a5,a0
 398:	0007c783          	lbu	a5,0(a5)
 39c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3a0:	0005879b          	sext.w	a5,a1
 3a4:	02c5d5bb          	divuw	a1,a1,a2
 3a8:	0685                	addi	a3,a3,1
 3aa:	fec7f0e3          	bgeu	a5,a2,38a <printint+0x26>
  if(neg)
 3ae:	00088c63          	beqz	a7,3c6 <printint+0x62>
    buf[i++] = '-';
 3b2:	fd070793          	addi	a5,a4,-48
 3b6:	00878733          	add	a4,a5,s0
 3ba:	02d00793          	li	a5,45
 3be:	fef70823          	sb	a5,-16(a4)
 3c2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3c6:	02e05c63          	blez	a4,3fe <printint+0x9a>
 3ca:	f04a                	sd	s2,32(sp)
 3cc:	ec4e                	sd	s3,24(sp)
 3ce:	fc040793          	addi	a5,s0,-64
 3d2:	00e78933          	add	s2,a5,a4
 3d6:	fff78993          	addi	s3,a5,-1
 3da:	99ba                	add	s3,s3,a4
 3dc:	377d                	addiw	a4,a4,-1
 3de:	1702                	slli	a4,a4,0x20
 3e0:	9301                	srli	a4,a4,0x20
 3e2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3e6:	fff94583          	lbu	a1,-1(s2)
 3ea:	8526                	mv	a0,s1
 3ec:	00000097          	auipc	ra,0x0
 3f0:	f56080e7          	jalr	-170(ra) # 342 <putc>
  while(--i >= 0)
 3f4:	197d                	addi	s2,s2,-1
 3f6:	ff3918e3          	bne	s2,s3,3e6 <printint+0x82>
 3fa:	7902                	ld	s2,32(sp)
 3fc:	69e2                	ld	s3,24(sp)
}
 3fe:	70e2                	ld	ra,56(sp)
 400:	7442                	ld	s0,48(sp)
 402:	74a2                	ld	s1,40(sp)
 404:	6121                	addi	sp,sp,64
 406:	8082                	ret
    x = -xx;
 408:	40b005bb          	negw	a1,a1
    neg = 1;
 40c:	4885                	li	a7,1
    x = -xx;
 40e:	b7b5                	j	37a <printint+0x16>

0000000000000410 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 410:	715d                	addi	sp,sp,-80
 412:	e486                	sd	ra,72(sp)
 414:	e0a2                	sd	s0,64(sp)
 416:	f84a                	sd	s2,48(sp)
 418:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 41a:	0005c903          	lbu	s2,0(a1)
 41e:	1a090a63          	beqz	s2,5d2 <vprintf+0x1c2>
 422:	fc26                	sd	s1,56(sp)
 424:	f44e                	sd	s3,40(sp)
 426:	f052                	sd	s4,32(sp)
 428:	ec56                	sd	s5,24(sp)
 42a:	e85a                	sd	s6,16(sp)
 42c:	e45e                	sd	s7,8(sp)
 42e:	8aaa                	mv	s5,a0
 430:	8bb2                	mv	s7,a2
 432:	00158493          	addi	s1,a1,1
  state = 0;
 436:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 438:	02500a13          	li	s4,37
 43c:	4b55                	li	s6,21
 43e:	a839                	j	45c <vprintf+0x4c>
        putc(fd, c);
 440:	85ca                	mv	a1,s2
 442:	8556                	mv	a0,s5
 444:	00000097          	auipc	ra,0x0
 448:	efe080e7          	jalr	-258(ra) # 342 <putc>
 44c:	a019                	j	452 <vprintf+0x42>
    } else if(state == '%'){
 44e:	01498d63          	beq	s3,s4,468 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 452:	0485                	addi	s1,s1,1
 454:	fff4c903          	lbu	s2,-1(s1)
 458:	16090763          	beqz	s2,5c6 <vprintf+0x1b6>
    if(state == 0){
 45c:	fe0999e3          	bnez	s3,44e <vprintf+0x3e>
      if(c == '%'){
 460:	ff4910e3          	bne	s2,s4,440 <vprintf+0x30>
        state = '%';
 464:	89d2                	mv	s3,s4
 466:	b7f5                	j	452 <vprintf+0x42>
      if(c == 'd'){
 468:	13490463          	beq	s2,s4,590 <vprintf+0x180>
 46c:	f9d9079b          	addiw	a5,s2,-99
 470:	0ff7f793          	zext.b	a5,a5
 474:	12fb6763          	bltu	s6,a5,5a2 <vprintf+0x192>
 478:	f9d9079b          	addiw	a5,s2,-99
 47c:	0ff7f713          	zext.b	a4,a5
 480:	12eb6163          	bltu	s6,a4,5a2 <vprintf+0x192>
 484:	00271793          	slli	a5,a4,0x2
 488:	00000717          	auipc	a4,0x0
 48c:	35070713          	addi	a4,a4,848 # 7d8 <malloc+0x116>
 490:	97ba                	add	a5,a5,a4
 492:	439c                	lw	a5,0(a5)
 494:	97ba                	add	a5,a5,a4
 496:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 498:	008b8913          	addi	s2,s7,8
 49c:	4685                	li	a3,1
 49e:	4629                	li	a2,10
 4a0:	000ba583          	lw	a1,0(s7)
 4a4:	8556                	mv	a0,s5
 4a6:	00000097          	auipc	ra,0x0
 4aa:	ebe080e7          	jalr	-322(ra) # 364 <printint>
 4ae:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b0:	4981                	li	s3,0
 4b2:	b745                	j	452 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4b4:	008b8913          	addi	s2,s7,8
 4b8:	4681                	li	a3,0
 4ba:	4629                	li	a2,10
 4bc:	000ba583          	lw	a1,0(s7)
 4c0:	8556                	mv	a0,s5
 4c2:	00000097          	auipc	ra,0x0
 4c6:	ea2080e7          	jalr	-350(ra) # 364 <printint>
 4ca:	8bca                	mv	s7,s2
      state = 0;
 4cc:	4981                	li	s3,0
 4ce:	b751                	j	452 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4d0:	008b8913          	addi	s2,s7,8
 4d4:	4681                	li	a3,0
 4d6:	4641                	li	a2,16
 4d8:	000ba583          	lw	a1,0(s7)
 4dc:	8556                	mv	a0,s5
 4de:	00000097          	auipc	ra,0x0
 4e2:	e86080e7          	jalr	-378(ra) # 364 <printint>
 4e6:	8bca                	mv	s7,s2
      state = 0;
 4e8:	4981                	li	s3,0
 4ea:	b7a5                	j	452 <vprintf+0x42>
 4ec:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 4ee:	008b8c13          	addi	s8,s7,8
 4f2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 4f6:	03000593          	li	a1,48
 4fa:	8556                	mv	a0,s5
 4fc:	00000097          	auipc	ra,0x0
 500:	e46080e7          	jalr	-442(ra) # 342 <putc>
  putc(fd, 'x');
 504:	07800593          	li	a1,120
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	e38080e7          	jalr	-456(ra) # 342 <putc>
 512:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 514:	00000b97          	auipc	s7,0x0
 518:	31cb8b93          	addi	s7,s7,796 # 830 <digits>
 51c:	03c9d793          	srli	a5,s3,0x3c
 520:	97de                	add	a5,a5,s7
 522:	0007c583          	lbu	a1,0(a5)
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	e1a080e7          	jalr	-486(ra) # 342 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 530:	0992                	slli	s3,s3,0x4
 532:	397d                	addiw	s2,s2,-1
 534:	fe0914e3          	bnez	s2,51c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 538:	8be2                	mv	s7,s8
      state = 0;
 53a:	4981                	li	s3,0
 53c:	6c02                	ld	s8,0(sp)
 53e:	bf11                	j	452 <vprintf+0x42>
        s = va_arg(ap, char*);
 540:	008b8993          	addi	s3,s7,8
 544:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 548:	02090163          	beqz	s2,56a <vprintf+0x15a>
        while(*s != 0){
 54c:	00094583          	lbu	a1,0(s2)
 550:	c9a5                	beqz	a1,5c0 <vprintf+0x1b0>
          putc(fd, *s);
 552:	8556                	mv	a0,s5
 554:	00000097          	auipc	ra,0x0
 558:	dee080e7          	jalr	-530(ra) # 342 <putc>
          s++;
 55c:	0905                	addi	s2,s2,1
        while(*s != 0){
 55e:	00094583          	lbu	a1,0(s2)
 562:	f9e5                	bnez	a1,552 <vprintf+0x142>
        s = va_arg(ap, char*);
 564:	8bce                	mv	s7,s3
      state = 0;
 566:	4981                	li	s3,0
 568:	b5ed                	j	452 <vprintf+0x42>
          s = "(null)";
 56a:	00000917          	auipc	s2,0x0
 56e:	26690913          	addi	s2,s2,614 # 7d0 <malloc+0x10e>
        while(*s != 0){
 572:	02800593          	li	a1,40
 576:	bff1                	j	552 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 578:	008b8913          	addi	s2,s7,8
 57c:	000bc583          	lbu	a1,0(s7)
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	dc0080e7          	jalr	-576(ra) # 342 <putc>
 58a:	8bca                	mv	s7,s2
      state = 0;
 58c:	4981                	li	s3,0
 58e:	b5d1                	j	452 <vprintf+0x42>
        putc(fd, c);
 590:	02500593          	li	a1,37
 594:	8556                	mv	a0,s5
 596:	00000097          	auipc	ra,0x0
 59a:	dac080e7          	jalr	-596(ra) # 342 <putc>
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	bd4d                	j	452 <vprintf+0x42>
        putc(fd, '%');
 5a2:	02500593          	li	a1,37
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	d9a080e7          	jalr	-614(ra) # 342 <putc>
        putc(fd, c);
 5b0:	85ca                	mv	a1,s2
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	d8e080e7          	jalr	-626(ra) # 342 <putc>
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	bd51                	j	452 <vprintf+0x42>
        s = va_arg(ap, char*);
 5c0:	8bce                	mv	s7,s3
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b579                	j	452 <vprintf+0x42>
 5c6:	74e2                	ld	s1,56(sp)
 5c8:	79a2                	ld	s3,40(sp)
 5ca:	7a02                	ld	s4,32(sp)
 5cc:	6ae2                	ld	s5,24(sp)
 5ce:	6b42                	ld	s6,16(sp)
 5d0:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5d2:	60a6                	ld	ra,72(sp)
 5d4:	6406                	ld	s0,64(sp)
 5d6:	7942                	ld	s2,48(sp)
 5d8:	6161                	addi	sp,sp,80
 5da:	8082                	ret

00000000000005dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5dc:	715d                	addi	sp,sp,-80
 5de:	ec06                	sd	ra,24(sp)
 5e0:	e822                	sd	s0,16(sp)
 5e2:	1000                	addi	s0,sp,32
 5e4:	e010                	sd	a2,0(s0)
 5e6:	e414                	sd	a3,8(s0)
 5e8:	e818                	sd	a4,16(s0)
 5ea:	ec1c                	sd	a5,24(s0)
 5ec:	03043023          	sd	a6,32(s0)
 5f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5f4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5f8:	8622                	mv	a2,s0
 5fa:	00000097          	auipc	ra,0x0
 5fe:	e16080e7          	jalr	-490(ra) # 410 <vprintf>
}
 602:	60e2                	ld	ra,24(sp)
 604:	6442                	ld	s0,16(sp)
 606:	6161                	addi	sp,sp,80
 608:	8082                	ret

000000000000060a <printf>:

void
printf(const char *fmt, ...)
{
 60a:	711d                	addi	sp,sp,-96
 60c:	ec06                	sd	ra,24(sp)
 60e:	e822                	sd	s0,16(sp)
 610:	1000                	addi	s0,sp,32
 612:	e40c                	sd	a1,8(s0)
 614:	e810                	sd	a2,16(s0)
 616:	ec14                	sd	a3,24(s0)
 618:	f018                	sd	a4,32(s0)
 61a:	f41c                	sd	a5,40(s0)
 61c:	03043823          	sd	a6,48(s0)
 620:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 624:	00840613          	addi	a2,s0,8
 628:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 62c:	85aa                	mv	a1,a0
 62e:	4505                	li	a0,1
 630:	00000097          	auipc	ra,0x0
 634:	de0080e7          	jalr	-544(ra) # 410 <vprintf>
}
 638:	60e2                	ld	ra,24(sp)
 63a:	6442                	ld	s0,16(sp)
 63c:	6125                	addi	sp,sp,96
 63e:	8082                	ret

0000000000000640 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 640:	1141                	addi	sp,sp,-16
 642:	e422                	sd	s0,8(sp)
 644:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 646:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64a:	00001797          	auipc	a5,0x1
 64e:	9b67b783          	ld	a5,-1610(a5) # 1000 <freep>
 652:	a02d                	j	67c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 654:	4618                	lw	a4,8(a2)
 656:	9f2d                	addw	a4,a4,a1
 658:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 65c:	6398                	ld	a4,0(a5)
 65e:	6310                	ld	a2,0(a4)
 660:	a83d                	j	69e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 662:	ff852703          	lw	a4,-8(a0)
 666:	9f31                	addw	a4,a4,a2
 668:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 66a:	ff053683          	ld	a3,-16(a0)
 66e:	a091                	j	6b2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 670:	6398                	ld	a4,0(a5)
 672:	00e7e463          	bltu	a5,a4,67a <free+0x3a>
 676:	00e6ea63          	bltu	a3,a4,68a <free+0x4a>
{
 67a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67c:	fed7fae3          	bgeu	a5,a3,670 <free+0x30>
 680:	6398                	ld	a4,0(a5)
 682:	00e6e463          	bltu	a3,a4,68a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 686:	fee7eae3          	bltu	a5,a4,67a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 68a:	ff852583          	lw	a1,-8(a0)
 68e:	6390                	ld	a2,0(a5)
 690:	02059813          	slli	a6,a1,0x20
 694:	01c85713          	srli	a4,a6,0x1c
 698:	9736                	add	a4,a4,a3
 69a:	fae60de3          	beq	a2,a4,654 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 69e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6a2:	4790                	lw	a2,8(a5)
 6a4:	02061593          	slli	a1,a2,0x20
 6a8:	01c5d713          	srli	a4,a1,0x1c
 6ac:	973e                	add	a4,a4,a5
 6ae:	fae68ae3          	beq	a3,a4,662 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6b2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6b4:	00001717          	auipc	a4,0x1
 6b8:	94f73623          	sd	a5,-1716(a4) # 1000 <freep>
}
 6bc:	6422                	ld	s0,8(sp)
 6be:	0141                	addi	sp,sp,16
 6c0:	8082                	ret

00000000000006c2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6c2:	7139                	addi	sp,sp,-64
 6c4:	fc06                	sd	ra,56(sp)
 6c6:	f822                	sd	s0,48(sp)
 6c8:	f426                	sd	s1,40(sp)
 6ca:	ec4e                	sd	s3,24(sp)
 6cc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ce:	02051493          	slli	s1,a0,0x20
 6d2:	9081                	srli	s1,s1,0x20
 6d4:	04bd                	addi	s1,s1,15
 6d6:	8091                	srli	s1,s1,0x4
 6d8:	0014899b          	addiw	s3,s1,1
 6dc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6de:	00001517          	auipc	a0,0x1
 6e2:	92253503          	ld	a0,-1758(a0) # 1000 <freep>
 6e6:	c915                	beqz	a0,71a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6ea:	4798                	lw	a4,8(a5)
 6ec:	08977e63          	bgeu	a4,s1,788 <malloc+0xc6>
 6f0:	f04a                	sd	s2,32(sp)
 6f2:	e852                	sd	s4,16(sp)
 6f4:	e456                	sd	s5,8(sp)
 6f6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 6f8:	8a4e                	mv	s4,s3
 6fa:	0009871b          	sext.w	a4,s3
 6fe:	6685                	lui	a3,0x1
 700:	00d77363          	bgeu	a4,a3,706 <malloc+0x44>
 704:	6a05                	lui	s4,0x1
 706:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 70a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 70e:	00001917          	auipc	s2,0x1
 712:	8f290913          	addi	s2,s2,-1806 # 1000 <freep>
  if(p == (char*)-1)
 716:	5afd                	li	s5,-1
 718:	a091                	j	75c <malloc+0x9a>
 71a:	f04a                	sd	s2,32(sp)
 71c:	e852                	sd	s4,16(sp)
 71e:	e456                	sd	s5,8(sp)
 720:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 722:	00001797          	auipc	a5,0x1
 726:	8ee78793          	addi	a5,a5,-1810 # 1010 <base>
 72a:	00001717          	auipc	a4,0x1
 72e:	8cf73b23          	sd	a5,-1834(a4) # 1000 <freep>
 732:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 734:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 738:	b7c1                	j	6f8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 73a:	6398                	ld	a4,0(a5)
 73c:	e118                	sd	a4,0(a0)
 73e:	a08d                	j	7a0 <malloc+0xde>
  hp->s.size = nu;
 740:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 744:	0541                	addi	a0,a0,16
 746:	00000097          	auipc	ra,0x0
 74a:	efa080e7          	jalr	-262(ra) # 640 <free>
  return freep;
 74e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 752:	c13d                	beqz	a0,7b8 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 754:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 756:	4798                	lw	a4,8(a5)
 758:	02977463          	bgeu	a4,s1,780 <malloc+0xbe>
    if(p == freep)
 75c:	00093703          	ld	a4,0(s2)
 760:	853e                	mv	a0,a5
 762:	fef719e3          	bne	a4,a5,754 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 766:	8552                	mv	a0,s4
 768:	00000097          	auipc	ra,0x0
 76c:	bc2080e7          	jalr	-1086(ra) # 32a <sbrk>
  if(p == (char*)-1)
 770:	fd5518e3          	bne	a0,s5,740 <malloc+0x7e>
        return 0;
 774:	4501                	li	a0,0
 776:	7902                	ld	s2,32(sp)
 778:	6a42                	ld	s4,16(sp)
 77a:	6aa2                	ld	s5,8(sp)
 77c:	6b02                	ld	s6,0(sp)
 77e:	a03d                	j	7ac <malloc+0xea>
 780:	7902                	ld	s2,32(sp)
 782:	6a42                	ld	s4,16(sp)
 784:	6aa2                	ld	s5,8(sp)
 786:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 788:	fae489e3          	beq	s1,a4,73a <malloc+0x78>
        p->s.size -= nunits;
 78c:	4137073b          	subw	a4,a4,s3
 790:	c798                	sw	a4,8(a5)
        p += p->s.size;
 792:	02071693          	slli	a3,a4,0x20
 796:	01c6d713          	srli	a4,a3,0x1c
 79a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 79c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7a0:	00001717          	auipc	a4,0x1
 7a4:	86a73023          	sd	a0,-1952(a4) # 1000 <freep>
      return (void*)(p + 1);
 7a8:	01078513          	addi	a0,a5,16
  }
}
 7ac:	70e2                	ld	ra,56(sp)
 7ae:	7442                	ld	s0,48(sp)
 7b0:	74a2                	ld	s1,40(sp)
 7b2:	69e2                	ld	s3,24(sp)
 7b4:	6121                	addi	sp,sp,64
 7b6:	8082                	ret
 7b8:	7902                	ld	s2,32(sp)
 7ba:	6a42                	ld	s4,16(sp)
 7bc:	6aa2                	ld	s5,8(sp)
 7be:	6b02                	ld	s6,0(sp)
 7c0:	b7f5                	j	7ac <malloc+0xea>
