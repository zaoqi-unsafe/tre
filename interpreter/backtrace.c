/*
 * tré – Copyright (c) 2014 Sven Michael Klose <pixel@copei.de>
 */

#include "config.h"
#include "xxx.h"
#include "ptr.h"
#include "cons.h"
#include "atom.h"
#include "symbol.h"
#include "thread.h"

treptr treptr_backtrace;

treptr
trebacktrace_r (treptr x)
{
    RETURN_NIL(x);
    if (_CDR(x) && _CAR(x) == _CAR(_CDR(x)))
        return trebacktrace_r (_CDR(x));
    return CONS(_CAR(x), treptr_nil);
}

treptr
trebacktrace ()
{
    return trebacktrace_r (TRESYMBOL_VALUE(treptr_backtrace));
}

void
trebacktrace_init ()
{
    treptr_backtrace = treatom_get ("*BACKTRACE*", TRECONTEXT_PACKAGE());
    EXPAND_UNIVERSE(treptr_backtrace);
    TRESYMBOL_VALUE(treptr_backtrace) = treptr_nil;
}