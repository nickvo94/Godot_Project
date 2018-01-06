extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var depth = 1.0 setget set_depth

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func set_depth(value):
	depth = value
	var s = Vector2(1 / depth, 1 / depth)
	set_scale(s)
	var o = clamp((1 / (depth * 8.0)) * 3.0, 0, 1)
	set_opacity(o)


func set_spin(base_rot, spin_amt):
	set_rot(base_rot + (depth * 0.0314 * spin_amt))