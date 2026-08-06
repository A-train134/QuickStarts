// TO USE:
// define anything like example.h before the define SIH_QUICKSTART
//
// #define RAYLIB_HELPERS_IMPLEMENTATION
// #include "raylib_helpers.h"
//
//
//
#ifndef RAYLIB_HELPERS
#define RAYLIB_HELPERS
//
#ifndef ATN_RAYLIB_INCLUDE
#define ATN_RAYLIB_INCLUDE
#include "raylib.h"
#endif
//
typedef struct Accumulator {
  double time_last;
  double time_accumulator;
  int fps;
  int frames;
  double now;
  double delta_time;
  int fps_last_frames;
  double fps_last_time;
} Accumulator;
//
void initAccumulator(Accumulator *a);
void accumulatorUpdate(Accumulator *a);
void accumulatorDebugText(Accumulator a, int x, int y, int size);
// CODE
// #ifndef to edit
#ifdef RAYLIB_HELPERS_IMPLEMENTATION
void initAccumulator(Accumulator *a) {
  a->time_last = GetTime();
  a->time_accumulator = 0;
  a->fps = 60;
  a->frames = 0;
  a->now = GetTime();
  a->delta_time = 0;
  a->fps_last_frames = 0;
  a->fps_last_time = 0.0f;
}
void accumulatorUpdate(Accumulator *a) {
  a->frames++;
  a->now = GetTime();
  a->delta_time = a->now - a->time_last;
  a->time_last = a->now;
  a->time_accumulator += a->delta_time;
  double elapsed = a->now - a->fps_last_time;
  if (elapsed >= 1.0) {
    a->fps = (int)((a->frames - a->fps_last_frames) / elapsed);
    a->fps_last_frames = a->frames;
    a->fps_last_time = a->now;
  }
}
void accumulatorDebugText(Accumulator a, int x, int y, int size) {
  DrawText(TextFormat("%.3f\n%.2f\n%.3f\n%d\n", a.delta_time, a.time_last,
                      a.time_accumulator, a.fps),
           x, y, size, WHITE);
}
// IMPLEMENTATION
#endif
//
#endif
