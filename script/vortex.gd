extends Node2D

const name = "Vortex"

var material_node
var time = 0
var morph_time = 0

export var speed = 1.0
export var step_size = 0.1
export var tail_fade = 1.0
export var amt_morph_time = 0.5
export var amt_step_change = 0.01
export var amt_tail_fade = 2.0
export var amt_repeat = 3.0


func _ready():
	prints(name, "ready.")

	material_node = get_node("Sprite").get_material()


func set_time(new_time):
	morph_time += (new_time - time) * speed
	time = new_time
	material_node.set_shader_param("time", morph_time)


func set_audio(levels):
	var audio = levels[2]
	material_node.set_shader_param("radial_repeat", amt_repeat)
	material_node.set_shader_param("fade_amt", tail_fade)
	material_node.set_shader_param("step_size", step_size + levels[1] * amt_step_change)
	material_node.set_shader_param("sharpness", clamp(audio * 0.2 + 0.8, 0.5, 1.0))
	morph_time += levels[1] * amt_morph_time
	tail_fade += levels[4] * amt_tail_fade
	tail_fade = lerp(tail_fade, 1.0, 0.1)
	#step_size -= levels[2] * amt_step_change
	#if step_size < 0.05: step_size = 0.5

func _process(delta):

	pass


func change(args):
	prints(name, "change:", args)
	material_node.set_shader_param("step_size", args[0])


func set_repeat(value):
	amt_repeat = value


func set_tail_fade(value):
	amt_tail_fade = value


func set_step_size(value):
	step_size = value


func set_amt_step_change(value):
	amt_step_change = value


func set_amt_morph_time(value):
	amt_morph_time = value


func set_speed(value):
	speed = value

