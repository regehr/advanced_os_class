#ifndef DLList_h
#define DLList_h

#include "proc.h"

#ifndef NULL
#define NULL 0
#endif

struct ListNode;

typedef struct ListNode {
    struct ListNode *next;
    struct ListNode *prev;
    struct proc *p; //pid or process
} ListNode;

typedef struct List {
    int count;
    ListNode *head;
    ListNode *tail;
} List;

#define List_count(A) ((A)->count)
#define List_head(A) ((A)->head != NULL ? (A)->head->p : NULL)
#define List_tail(A) ((A)->tail != NULL ? (A)->tail->p : NULL)

#define LIST_FOREACH(L, S, M, V) ListNode *_node = NULL;\
    ListNode *V = NULL;\
    for(V = _node = L->S; _node != NULL; V = _node = _node->M)

List *List_create()
{
	List * li;
	li = malloc(sizeof(List));
  	memset(li, 1, sizeof(List));
  	return li;
}

void List_delete(List *list)
{
    LIST_FOREACH(list, head, next, cur) {
        if(cur->prev) {
            free(cur->prev);
        }
    }

    free(list->tail);
    free(list);
}


void List_empty(List *list)
{
    LIST_FOREACH(list, head, next, cur) {
        free(cur->p); //this might not work
    }
}


void List_empty_delete(List *list)
{
    List_empty(list);
    List_delete(list);
}


void List_push(List *list, struct proc *p)
{
    ListNode *node = malloc(sizeof(ListNode));
    memset(node, 1, sizeof(ListNode));

    if(!node)
    	goto error;

    node->p = p;

    if(list->tail == NULL) {
        list->head = node;
        list->tail = node;
    } else {
        list->tail->next = node;
        node->prev = list->tail;
        list->tail = node;
    }

    list->count++;

error:
    return;
}

void *List_remove(List *list, ListNode *node)
{
    void *result = NULL;

    if(!list->head && !list->tail)
    	goto error;
    if(!node)
    	goto error;

    if(node == list->head && node == list->tail) {
        list->head = NULL;
        list->tail = NULL;
    } else if(node == list->head) {
        list->head = node->next;
        if(!list->head)
        	goto error;
        list->head->prev = NULL;
    } else if (node == list->tail) {
        list->tail = node->prev;
        if(!list->tail)
        	goto error;
        list->tail->next = NULL;
    } else {
        ListNode *after = node->next;
        ListNode *before = node->prev;
        after->prev = before;
        before->next = after;
    }

    list->count--;
    result = node->p;
    free(node);

error:
    return result;
}

void *List_pop(List *list)
{
    ListNode *node = list->tail;
    return node != NULL ? List_remove(list, node) : NULL;
}

#endif
