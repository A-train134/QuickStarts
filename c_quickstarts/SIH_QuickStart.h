// TO USE:
// define anything like example.h before the define SIH_QUICKSTART
//
// #define SIH_QUICKSTART
// #include "SIH_QuickStart.h"
//
//
//
#ifndef SIH_QUICKSTART
#define SIH_QUICKSTART
#include <cstdio>
//
#ifndef EXAMPLE_IMPLEMENTATION
#define EXAMPLE_IMPLEMENTATION
#include "example.h"
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
