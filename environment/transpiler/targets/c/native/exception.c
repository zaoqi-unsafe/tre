/*
 * tré – Copyright (c) 2014 Sven Michael Klose <pixel@copei.de>
 */

#include "ptr.h"
#include "atom.h"
#include "thread.h"
#include "symtab.h"
#include "cons.h"
#include "error.h"
#include "stream.h"
#include "main.h"
#include "exception.h"
#include "symbol.h"

trecatch catchers[TRE_NUM_CATCHERS];
int current_catcher = 0;

treptr treptr_exception;

void
treexception_catch_leave ()
{
    trestack_ptr = catchers[current_catcher--].gc_stack;
}

void
treexception_catch_enter ()
{
    catchers[++current_catcher].gc_stack = trestack_ptr;
}

void
treexception_throw (treptr x)
{
    if (current_catcher > 0) {
        SYMBOL_VALUE(treptr_exception) = x;
        trestack_ptr = catchers[current_catcher].gc_stack;
        longjmp (catchers[current_catcher].jmp, -1);
    }
    treerror_norecover (x, "Uncaught exception.");
}

void
treexception_init ()
{
    MAKE_SYMBOL("*EXCEPTION*", NIL);
    treptr_exception = symbol_get ("*EXCEPTION*");
}