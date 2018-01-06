extends Node2D

export var time = 0.0
export var end_time = 165.0
export var audio_decay = 0.5
export var audio_offset = 5
export var debug_audio = true
export var debug_time = true


var spec_ranges = [0.1, 0.2, 0.3, 0.35, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0]

var actions = {}
var action_idx = 0
var parts = []

onready var parts_node = get_node("parts")
onready var music = get_node("sound/StreamPlayer")

var spectrum_size = 30
var audio_spectrum
var music_length = 0
var audio_levels = [0.0]
var time_offset = 0

var tweens

func _ready():
	print("-----------------------------------------------------------------")
	print("Main: Init")
	print("-----------------------------------------------------------------")
	parts = get_node("parts").get_children()
	prints("Parts:", parts)

	set_process(true)
	load_actions()

	music.play(time)
	music_length = music.get_length()

	audio_spectrum = ImageTexture.new()
	audio_spectrum.load("sound/sound.png")
	spectrum_size = audio_spectrum.get_height() - 1

	audio_levels.resize(spec_ranges.size() - 1)
	for i in range(audio_levels.size() - 1):
		audio_levels[i] = 0.0

	tweens = get_node("tweens")

	print(spec_ranges)


func load_actions():
	var text
	var content = {}
	var file = File.new()

	print("Loading timeline...")

	file.open("config/timeline.json", File.READ)
	text = file.get_as_text()
	content.parse_json(text)
	if (typeof(content) == TYPE_DICTIONARY):
		if (content.has("global_time_ofs")):
			time_offset = content.global_time_ofs
		if (content.has("actions")):
			actions = content.actions
			print("Ok.")
		else:
			print("Main: JSON load error: actions should be array")
			actions = []
	else:
		print("Main: Invalid JSON")
		actions = []

	actions.sort_custom(self, "sort_action_by_time")
	print("Main: sorted actions by time.")


func sort_action_by_time(a, b):
	if a.has("rem"): return true
	if b.has("rem"): return false
	var atime = 0
	var btime = 0
	if a.has("time"): atime = a.time
	if b.has("time"): btime = b.time
	if atime < btime: return true
	return false


func _process(delta):
	#print(music.get_pos())

	time = time + delta

	if time > end_time: get_tree().quit()

	make_audio_levels()
	if (debug_audio): get_node("debug/audio").set_audio(audio_levels)
	if (debug_time): get_node("debug/time").set_text(str(time))
	#if ((time - floor(time)) < 0.1):
	#	print(audio_levels)

	for part in parts:
		if part.has_method("set_time"): part.set_time(time + time_offset)
		if part.has_method("set_audio"): part.set_audio(audio_levels)

	run_timeline_actions()
	update_tweens()


func run_timeline_actions():
	if actions.size() == 0: return

	var done = false
	var action
	while !done:
		if (action_idx >= actions.size()):
			break

		action = actions[action_idx]
		if ((action.time + action.ofs) < time):
			prints(time, action.target, action.method)
			if action.target == "self":
				self.callv(action.method, action.args)
			else:
				var node = parts_node.get_node(action.target)
				if node != null:
					if action.args != null:
						node.call(action.method, action.args)
					else:
						node.call(action.method)
			action_idx = action_idx + 1
		else:
			done = true


func make_audio_levels():
	var music_pos = music.get_pos() / music.get_length()
	var spectrum_pos = (audio_spectrum.get_width() - 1) * music_pos
	spectrum_pos += audio_offset
	spectrum_pos = fmod(spectrum_pos, audio_spectrum.get_width() - 1)

	var prev_levels = []
	prev_levels.resize(audio_levels.size() - 1)
	for i in range(audio_levels.size() - 1):
		prev_levels[i] = audio_levels[i]
	var level

	for step in range(spec_ranges.size() - 1):
		var start
		var end

		if step == 0: start = 0
		else: start = spec_ranges[step - 1] * spectrum_size
		end = spec_ranges[step] * spectrum_size

		level = 0.0
		for y in range(start, end):
			level += audio_spectrum.get_data().get_pixel(spectrum_pos, y, 0).r
		audio_levels[step] = level

	for i in range(audio_levels.size() - 1):
		audio_levels[i] = clamp((audio_levels[i] + prev_levels[i] * audio_decay), 0.0, 1.0)


func fade_to(name, value, time):
	prints("fade", name, value, time)
	var target = get_node("parts").get_node(name)
	if !target: return

	var tween = Tween.new()
	tween.interpolate_property(target, "visibility/opacity",
								target.get_opacity(), value,
								time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tweens.add_child(tween)
	tween.start()


func update_tweens():
	for tween in tweens.get_children():
		if tween.is_active() == false:
			tween.queue_free()
