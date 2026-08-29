package main
// import c "core:c"
import gs "gameState"
import rl "vendor:raylib"
import wn "window"


Program :: struct {
	window:     wn.Window,
	fps:        i32,
	game_state: gs.GameState,
}
initProgram :: proc(p: ^Program, wWidth, wHeight, target_fps: i32, title: cstring) {
	p.fps = target_fps
	//
	wn.init(&p.window, wWidth, wHeight, "HELP", {.WINDOW_RESIZABLE})
	rl.SetTargetFPS(p.fps)
	gs.init(&p.game_state, p.window.width, p.window.height)
}
updateProgram :: proc(p: ^Program) {
	gs.update(&p.game_state)
}
renderProgram :: proc(p: ^Program) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.SKYBLUE)
	rl.BeginMode2D(p.game_state.camera2D)
	rl.DrawFPS(10, 10)
	//
	gs.render(&p.game_state)
	//
	rl.EndMode2D()
	rl.EndDrawing()

}
main :: proc() {
	program: Program
	initProgram(&program, 600, 600, 60, "HELP")
	//
	for !rl.WindowShouldClose() {
		updateProgram(&program)
		renderProgram(&program)
	}
}
