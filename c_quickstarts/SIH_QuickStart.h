#ifndef SIH_QUICKSTART
#define SIH_QUICKSTART
#include <cstdio>
//
#ifndef HELPER_IMPLEMENTATION
#define HELPER_IMPLEMENTATION
#include "helpers.h"
//
#endif
typedef struct Foo {
} Foo;
void testFoo();

// CODE
#ifdef SIH_QUICKSTART_IMPLEMENTATION
void testFoo() { printf("foo"); }

// IMPLEMENTATION
#endif
#endif
