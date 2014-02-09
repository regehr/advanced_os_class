#include "defs.h"
// TODO

#ifndef NULL
#define NULL 0
#endif

#define MAX_SHMEM_PAGES 4       // Largest number of pages requestable by a process to share with others
#define MAX_SHMEM_ENTRIES 16    // Total number of shared memory instances we can allocate

struct shmem_entry
{
    int key;
    void* pages[MAX_SHMEM_PAGES];
};

struct spinlock shmemlock;
struct shmem_entry shmem_entries[MAX_SHMEM_ENTRIES];

int
initshm()
{
    acquire(&shmemlock);

    // If we've already initialized, just leave
    if (shmem_entries != NULL)
        goto done;

    if((shmem_entries = (struct shmem_entry*)kalloc()) == 0)
    {
        if (shmem_entries)
            kfree((char*)shmem_entries);
        
        release(&shmemlock);
        return -1;
    }

    // Possibly unnecessary, but I'd like to make sure everything is zeroed out:
    int i;
    for(i = 0; i < MAX_SHMEM_ENTRIES; i++)
    {
        shmem_entries[i].key = 0;
        shmem_entries[i].pages = NULL;
    }

done:
    release(&shmemlock);
    return 0;
}

void*
getshm(int key, int pages)
{
    // Scan thru shmem entries to see if we've either already allocated a spot, or if a slot still exists to allocate:
    int i;
    int open_spot = -1;
    for (i = 0; i < MAX_SHMEM_PAGES; i++)
    {
        // Already allocated this one:
        if (shmem_entries[i].key == key)
            return shmem_entries[i].pages;
        // Found an empty spot:
        else if (shmem_entries[i].key == 0)
            open_spot = i;
    }

    // If we found an open spot, allocate desired page count (up to max)
    if (open_spot >= 0)
    {
        shmem_entries[open_spot].key = key;
        for (i = 0; i < MIN(MAX_SHMEM_PAGES, pages); i++)
        {
            if ((shmem_engries[open_spot].data[i] = kalloc()) == 0)
                goto bad;
        }
    }

    return shmem_entries[open_spot].data;

bad:
    shmem_entries[open_spot].key = 0;
    for (; i > 0; i--)
    {
        kfree(shmem_entries[open_spot].data[i]);
        shmem_entries[open_spot].data[i] = NULL;    // Probably not necessary, tho
    }

    return NULL;
}
