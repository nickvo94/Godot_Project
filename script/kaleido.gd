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
	
	
func _process(delta):
	if(devi > 3 && devi < 4) : print(time)
	if (devi >3 or devi == 3) : 
		material_node.set_shader_param("distCoeff", time)
		
	if (devi < 3) : 		
		#material_node.set_shader_param("distCoeff", 80/time)
		#if((80/time) < 1 ):
		multi -= 0.005
		material_node.set_shader_param("distCoeff", multi+1)		
		material_node.set_shader_param("angleCoeff", multi-1.48)
	
	
		
	
	pass


func change(args):
	prints(name, "change:", args)
	
	
