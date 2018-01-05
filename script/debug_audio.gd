extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var audio_levels = []

func _ready():
	set_process(true)


func _draw():
	for i in range(audio_levels.size()):
		var w = audio_levels[i] * 256
		draw_rect(Rect2(0, i * 32, w, 16), Color(1,0,0,1))
		#print(w)


func _process(delta):
	pass


func set_audio(levels):
	audio_levels = levels
	update()