extends Node2D

const name = "ShaderFrame"

var material_node
var time = 0
var multi = 2.48

func _ready():
	prints(name, "ready.")

	material_node = get_node("ShaderFrame").get_material()

	set_process(true)

func set_time(new_time):
	material_node.set_shader_param("time", time)

func set_audio(levels):
	var audio = levels[2]
	#material_node.set_shader_param("step_size", clamp(audio * 0.08 + 0.05, 0.0, 0.5))
	material_node.set_shader_param("scale", clamp(audio * 0.2 + 0.8, 0.5, 1.0))

