#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


#define PTE_A (1 << 6)
#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
  // lab pgtbl: your code here.

   unsigned int abits=0;

  uint64 va ;
  argaddr(0, &va);

  int page ;
  argint(1,&page);

  uint64 result ;
  argaddr(2, &result);


  struct proc *p = myproc();

  for(int i = 0 ;i < page ;i ++){
    uint64 addr = va + i*PGSIZE;
    pte_t* pte = walk(p->pagetable, addr,0);
    vmprint(pte);
    if(*pte & PTE_A) {
      //printf("%d\n",i );
      //printf("accessed\n");
        abits = abits | (1 << i);
        *pte=(*pte)&(~PTE_A);
    }
  }

  if(copyout(p->pagetable,result,(char*)&abits, sizeof(abits)) < 0) return -1;

  return 0;
}
#endif

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

