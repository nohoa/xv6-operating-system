// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct kmem{
  struct spinlock lock;
  struct run *freelist;
} ;

struct kmem cpu_mem[NCPU];

void
kinit()
{
  for(int i = 0 ;i < NCPU ;i ++){
  initlock(&cpu_mem[i].lock, "kmem");
  }

  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;
  push_off();
  int id = cpuid();
  acquire(&cpu_mem[id].lock);
  r->next = cpu_mem[id].freelist;
  cpu_mem[id].freelist = r;
  release(&cpu_mem[id].lock);
  pop_off();
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  push_off();
  int id = cpuid();

  acquire(&cpu_mem[id].lock);
  r = cpu_mem[id].freelist;
  if(r)
    cpu_mem[id].freelist = r->next;
  release(&cpu_mem[id].lock);

  if(!r){
    for(int i = 0 ;i < NCPU ;i ++){
      if(i == id) continue;
      acquire(&cpu_mem[i].lock);
      struct run*r1 = cpu_mem[i].freelist;
      if(r1){
        r = r1 ;
        cpu_mem[i].freelist = r1->next;
      }
      release(&cpu_mem[i].lock);
      if(r) break;
    }
  }
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk

  pop_off();
  return (void*)r;
}
