package gameState
import rl "vendor:raylib"

Bouncer :: struct {
	pos:    rl.Vector2,
	delta:  rl.Vector2,
	radius: f32,
	color:  rl.Color,
	speed:  f32,
}

GameState :: struct {
	camera2D: rl.Camera2D,
	camera3D: rl.Camera3D,
	thing:    Bouncer,
	wall:     Limits,
}
Limits :: struct {
	left, right, up, down: i32,
}

init :: initGameState
update :: updateGameState
render :: renderGameState

initGameState :: proc(g: ^GameState, posX, posY: i32) {
	g.camera2D = {
		offset   = {f32(posX / 2), f32(posY / 2)},
		target   = {f32(posX / 2), f32(posY / 2)},
		rotation = 0.0,
		zoom     = 1.0,
	}
	//
	g.wall = {0, posX, 0, posY}
	//
	g.thing = {
		pos    = {f32(posX / 2), f32(posY / 2)},
		delta  = {1, 0},
		radius = 5,
		color  = rl.RED,
		speed  = 5,
	}
}

updateGameState :: proc(g: ^GameState) {
	if g.thing.pos.x + g.thing.radius >= f32(g.wall.right) {
		g.thing.delta.x *= -1
	}
	if g.thing.pos.x - g.thing.radius <= f32(g.wall.left) {
		g.thing.delta.x *= -1
	}
	g.thing.pos.x += g.thing.delta.x * g.thing.speed
	g.thing.pos.y += g.thing.delta.y * g.thing.speed

}

renderGameState :: proc(g: ^GameState) {
	rl.DrawCircle(i32(g.camera2D.target.x), i32(g.camera2D.target.y), 2, rl.BLACK)
	rl.DrawCircle(i32(g.thing.pos.x), i32(g.thing.pos.y), g.thing.radius, g.thing.color)
}
