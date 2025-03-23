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


int
sys_pgaccess(void)
{
  // lab pgtbl: your code here.
  uint64 start_va;
  int page_no ;
  uint64 abits ;

  uint64 temp = 0;

  argaddr(0,&start_va);
  argint(1,&page_no);
  argaddr(2,&abits);


  struct proc *p = myproc();
  int cnt = 0 ;
  int access[page_no+2];
  for(int i = 0 ;i <page_no +1  ;i ++){
    access[i] = 0;
  }
  for(uint64 va = start_va ; va  < start_va + page_no*PGSIZE ; va += PGSIZE){
        pte_t *pte = walk(p->pagetable,va,0);
        if(*pte & PTE_A){
           access[cnt] = 1;
        }
        //printf("%d\n",cnt);
        cnt ++;
  } 
    for(int i = 1 ;i < page_no ;i ++){
      if(access[i] == 1){
        temp |= (1 << i);
      }
    }
    //printf("value is : %ld\n",temp);

  if(copyout(p->pagetable, abits, (char*)&temp,sizeof(temp)) < 0) return -1;

  //printf("bits : %d\n",temp);

  return 0;
}

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
