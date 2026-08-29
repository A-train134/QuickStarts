package window
// import c "core:c"
import rl "vendor:raylib"
//
init :: initWindow

Window :: struct {
	width:  i32,
	height: i32,
	title:  cstring,
	flags:  rl.ConfigFlags,
}

initWindow :: proc(w: ^Window, width: i32, height: i32, title: cstring, flags: rl.ConfigFlags) {
	w.width = width
	w.height = height
	w.flags = flags
	w.title = title
	//
	rl.SetConfigFlags(w.flags)
	rl.InitWindow(w.width, w.height, w.title)

}
