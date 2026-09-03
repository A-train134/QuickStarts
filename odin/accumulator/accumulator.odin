package accumulator
import "core:testing"
import "core:time"


FIXED_DELTA_TIME_NSEC: f32 : (1.0 / 60.0) * 1_000_000_000
Accumulator :: struct {
	frame_accumulator: int,
	fps:               int,
	fps_last_time:     time.Time,
	target_time_nsec:  time.Duration,
	time_accumulator:  f32,
	last_time:         time.Time,
	delta_time:        time.Duration,
	fixed_delta_time:  f32,
}
init :: proc(fixed_delta_time_nsec: f32) -> (a: Accumulator) {
	// a.frame_accumulator = 0
	// a.fps = 0
	// a.fps_last_time = 0
	// a.time_accumulator = 0
	a.last_time = time.now()
	// a.delta_time = 0
	a.fixed_delta_time = fixed_delta_time_nsec
	return a
}
limitFPS :: proc(accumulator: Accumulator) {
	time.sleep(time.Duration(accumulator.fixed_delta_time))
}
//inside accumulator loop:
//accumulator.time_accumulator -= accumulator.fixed_delta_time
outerUpdate :: proc(accumulator: ^Accumulator) {
	accumulator.frame_accumulator += 1
	accumulator.delta_time = time.since(accumulator.last_time)
	accumulator.last_time = time.now()
	accumulator.time_accumulator += f32(accumulator.delta_time)
	//
	if (time.since(accumulator.fps_last_time) >= time.Second) {
		accumulator.fps = accumulator.frame_accumulator
		accumulator.frame_accumulator = 0
		accumulator.fps_last_time = time.now()
	}
}
@(test)
accumulatorTest :: proc(t: ^testing.T) {
	accumulator := init(FIXED_DELTA_TIME_NSEC)
	testing.set_fail_timeout(t, 3 * time.Second)
	//
	for {
		outerUpdate(&accumulator)
		accumulator.time_accumulator += accumulator.fixed_delta_time
		for accumulator.time_accumulator >= accumulator.fixed_delta_time {
			accumulator.time_accumulator -= accumulator.fixed_delta_time
			return // safe exit
		}
		limitFPS(accumulator)
	}
}
