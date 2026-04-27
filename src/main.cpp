#if defined(_WIN32)
#include "./../../raylib/zig-out/include/raylib.h"
#elif defined(__linux__)
#include "raylib.h"
#endif
// #include "./../../raylib/zig-out/include/raymath.h"
// #include <cmath>
// #include <cstdio>
#define len(Array) (sizeof(Array) / sizeof((Array)[0]))
// The Main Struct
typedef struct {
  int windowWidth;  //
  int windowHeight; //
} State;
//
//
int main(void) {
  State S = {
      .windowWidth = 1600,
      .windowHeight = 900,
  };
  //
  SetConfigFlags(FLAG_WINDOW_RESIZABLE);
  InitWindow(S.windowWidth, S.windowHeight, "QUICK");
  SetTargetFPS(60);
  Camera2D camera = {
      .offset = (Vector2){S.windowWidth * 0.5f, S.windowHeight * 0.5f},
      .target = (Vector2){S.windowWidth * 0.5f, S.windowHeight * 0.5f},
      .rotation = 0.0f,
      .zoom = 1.0f};
  while (!WindowShouldClose()) {
    if (IsWindowResized()) {
      S.windowWidth = GetScreenWidth();
      S.windowHeight = GetScreenHeight();
    }
    //
    BeginDrawing();
    BeginMode2D(camera);
    ClearBackground(BLACK);
    DrawFPS(100, 100);
    EndMode2D();
    EndDrawing();
  }
}
