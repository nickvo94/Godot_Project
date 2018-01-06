extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var depth = 1.0 setget set_depth

var wob = 0.0
var base_wob = 0.0

func set_depth(value):
	depth = value
	var s = Vector2(1 / depth, 1 / depth)
	var wob_s = (sin(base_wob + depth * 0.9)) * wob
	s.x += wob_s
	s.y += wob_s
	s.x = clamp(s.x, 0.02, 5.0)
	s.y = clamp(s.y, 0.02, 5.0)
	set_scale(s)
	var o = clamp(pow((1 / depth) * 2.0, 3.0), 0.0, 1.0)
	set_opacity(o)


func set_spin(base_rot, spin_amt):
	set_rot(base_rot + (depth * 0.0314 * spin_amt))


func set_wob(base, wob_amt):
	wob = wob_amt
	base_wob = base