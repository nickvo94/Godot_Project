extends Node2D

var sprites
var tri

var time = 0
var morph_time = 0
var speed = 1.0
var spawn_freq = 0.1
var prev_spawn = -9999
var adelta = 0
var amt_spawn_freq = 0.08
var spawn_amt = 1
var spin_amt = 0.0

var wob_amt = 0.0
var wob = 0

func _ready():
	sprites = get_node("sprites")
	for i in sprites.get_children():
		i.queue_free()
	set_process(true)
	tri = get_node("tri")


func set_time(value):
	adelta = (value - time) * speed
	morph_time += adelta
	time = value


func set_audio(levels):
	spawn_amt += (levels[8] * amt_spawn_freq)
	spawn_amt += (levels[10] * amt_spawn_freq)
	spawn_amt += (levels[12] * amt_spawn_freq)
	speed = speed * 0.8
	speed += levels[1]
	speed = clamp(speed, 0.1, 0.3)

	wob += levels[1]
	wob = clamp(wob, 0.0, 1.0)
	wob = lerp(wob, 0.0, 0.9)
	#spin_amt = spin_amt + levels[1] * 0.01
	#spin_amt = spin_amt - adelta * 0.01


func _process(delta):
	if !is_visible(): return
	#print(sprites.get_children().size())
	for i in sprites.get_children():
		var d = i.depth
		i.set_wob(time, wob * wob_amt)
		i.set_depth(d - 5.0 * adelta);
		i.set_spin(0, morph_time * 0.1 * spin_amt)
		if i.depth < 0.3:
			i.queue_free()

	if (morph_time - prev_spawn) > spawn_freq:
		prev_spawn = morph_time
		if (spawn_amt >= 1):
			spawn_amt -= 1
			var newtri = tri.duplicate()
			newtri.set_depth(8)
			newtri.show()
			newtri.set_pos(Vector2(640, 360))
			sprites.add_child(newtri)


func set_amt_wob(value):
	wob_amt = value


