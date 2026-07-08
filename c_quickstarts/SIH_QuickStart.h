// TO USE:
// define anything like example.h before the define SIH_QUICKSTART
//
// #define SIH_QUICKSTART_IMPLEMENTATION
// #include "SIH_QuickStart.h"
//
//
//
#ifndef SIH_QUICKSTART
#define SIH_QUICKSTART
//
#ifndef CSTDIO_INCLUDE
#define CSTDIO_INCLUDE
#include <cstdio>
#endif
//
typedef struct Foo {
} Foo;
void testFoo();

// CODE
// #ifndef to edit
#ifdef SIH_QUICKSTART_IMPLEMENTATION
void testFoo() { printf("foo"); }

// IMPLEMENTATION
#endif
//
#endif
