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
    int refcnt;
    //void* pages[MAX_SHMEM_PAGES];
    void* page;
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
    int i;
    for(i = 0; i < MAX_SHMEM_ENTRIES; i++)
    {
        shmem_entries[i].key = 0;
        shmem_entries[i].refcnt = 0;
        shmem_entries[i].page = NULL;
    }

    return 0;
}

void*
getshm(int key, int pages)
{
    // TODO: handle multiple pages requested

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
    if (open_spot >= 0)
    {
        shmem_entries[open_spot].key = key;
        if ((shmem_entries[open_spot].page = kalloc()) == 0)
            goto bad;
        
        /*
        for (i = 0; i < MIN(MAX_SHMEM_PAGES, pages); i++)
        {
            if ((shmem_entries[open_spot].data[i] = kalloc()) == 0)
                goto bad;
        }
        */
    }
    found_entry = shmem_entries[open_spot];

found:
    found_entry.refcnt += 1;
    return found_entry.page;

bad:
    shmem_entries[open_spot].key = 0;
    if (shmem_entries[open_spot].page)
        kfree(shmem_entries[open_spot].page);
    shmem_entries[open_spot].page = NULL;
    /*
    for (; i > 0; i--)
    {
        kfree(shmem_entries[open_spot].data[i]);
        shmem_entries[open_spot].data[i] = NULL;    // Probably not necessary, tho
    }
    */
bad2:
    return NULL;
}
