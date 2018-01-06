extends Node2D

const name = "ShaderFrame"

var material_node
var time = 0
var multi = 2.48
var devi = 8

func _ready():
	prints(name, "ready.")

	material_node = get_node("ShaderFrame").get_material()

	set_process(true)

func set_time(new_time):

	#if(devi > 1):
	time = new_time/devi
	devi -= 0.008
	#if(time > 1): time = new_time/6.0
	if(devi < 3):
		time = new_time * multi
		multi += 0.001

	#if(time > 2.2): time = new_time*2
	material_node.set_shader_param("time", time)

func set_audio(levels):
	var audio = levels[2]
	#material_node.set_shader_param("step_size", clamp(audio * 0.08 + 0.05, 0.0, 0.5))
	material_node.set_shader_param("scale", clamp(audio * 0.2 + 0.8, 0.5, 1.0))

func _process(delta):
	if (devi >3 or devi == 3) :
		material_node.set_shader_param("distCoeff", time)

	if (devi < 3) :
		#material_node.set_shader_param("distCoeff", 80/time)
		#if((80/time) < 1 ):
		if(time < -50): multi += 0.3
		else: multi -= 0.005
		material_node.set_shader_param("distCoeff", multi+1)
		material_node.set_shader_param("angleCoeff", multi-1.48)

	pass


func change(args):
	prints(name, "change:", args)


