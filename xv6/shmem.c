#include "defs.h"
#include "types.h"
// TODO

#ifndef NULL
#define NULL 0
#endif

#define MAX_SHMEM_PAGES 14       // Largest number of pages requestable by a process to share with others
#define MAX_SHMEM_ENTRIES 200    // Total number of shared memory instances we can allocate
// NOTE: sizeof(shmem_entry) * MAX_SHMEM_ENTRIES needs to be less than 4096
// (so it can fit on a page) To that end, ensure: 
//  (2+MAX_SHMEM_PAGES) * 4 * MAX_SHMEM_ENTRIES < 4096

// Sizeof = (1 + 1 + MAX_SHMEM_PAGES) * 4 bytes
struct shmem_entry
{
    uint key;
    uint refcnt;
    void* pages[MAX_SHMEM_PAGES];
};

struct spinlock shmemlock;
struct shmem_entry shmem_entries[MAX_SHMEM_ENTRIES];

int
initshm()
{
    initlock(&shmemlock, "shmem");

    if((shmem_entries = (struct shmem_entry*)kalloc()) == 0)
    {
        if (shmem_entries)
            kfree((char*)shmem_entries);
        
        return -1;
    }

    // Possibly unnecessary, but I'd like to make sure everything is zeroed out:
    int i,j;
    for(i = 0; i < MAX_SHMEM_ENTRIES; i++)
    {
        shmem_entries[i].key = 0;
        shmem_entries[i].refcnt = 0;
        for (j = 0; j < MAX_SHMEM_PAGES; j++)
            shmem_entries[i].pages[j] = NULL;
    }

    return 0;
}

// >=0: success
// < 0: failure
int
getshm(int key, int size, struct proc* proc, void* va)
{
    // Implementation decision: if someone requests some number of pages,
    // but they're actually going to share something already allocated: they
    // lose and just get access to the one already allocated.

    // Compute # of pages rather than # of bytes:
    int pages = PGROUNDUP(size) / PGSIZE;

    acquire(&shmemlock);

    // Scan thru shmem entries to see if we've either already allocated a spot, 
    // or if a slot still exists to allocate:
    //int i;
    int open_spot = -1;
    struct shmem_entry* found_entry;
    for (i = 0; i < MAX_SHMEM_ENTRIES; i++)
    {
        // Already allocated this one:
        if (shmem_entries[i].key == key)
        {
            found_entry = shmem_entries[i];
            goto found;
        }
            
        // Found an empty spot:
        else if (shmem_entries[i].refcnt == 0)
            open_spot = i;
    }

    // If we didn't find an open spot, and didn't find a previously allocated page
    // for the given key, we'll have to error out:
    if (open_spot < 0)
        goto bad2;

    // If we found an open spot, allocate desired page count (up to max)
    else
    {
        // Wait, first: if they asked for too many, fail out:
        if (pages > MAX_SHMEM_PAGES)
            goto bad2;
        shmem_entries[open_spot].key = key;
        for (i = 0; i < pages; i++)
            if ((shmem_entries[open_spot].pages[i] = kalloc()) == 0)
                goto bad;
    }
    found_entry = shmem_entries[open_spot];

found:
    found_entry.refcnt += 1;
    
    // For now, assume the call can't fail:
    for (i = 0; i < pages; i++)
    {
        mappages(proc->pgdir, va, PGSIZE,
                 shmem_entries[open_spot].pages[i],
                 PTE_P|PTE_W);
    }

    release(&shmemlock);
    return 0;

bad:
    shmem_entries[open_spot].key = 0;
    for (; i > 0; i--)
    {
        kfree(shmem_entries[open_spot].pages[i]);
        shmem_entries[open_spot].pages[i] = NULL;
    }

bad2:
    release(&shmemlock);
    return -1;
}
