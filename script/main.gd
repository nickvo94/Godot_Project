extends Node2D

var time = 0.0
var actions = {}
var action_idx = 0
var parts = []

func _ready():
	print("-----------------------------------------------------------------")
	print("Main: Init")
	print("-----------------------------------------------------------------")
	parts = get_node("parts").get_children()
	prints("Parts:", parts)

	set_process(true)
	load_actions()
	time = 0.0


func load_actions():
	var text
	var content = {}
	var file = File.new()

	print("Loading timeline...")

	file.open("config/timeline.json", File.READ)
	text = file.get_as_text()
	content.parse_json(text)
	if (typeof(content) == TYPE_DICTIONARY):
		if (content.has("actions")):
			actions = content.actions
			print("Ok.")
		else:
			print("Main: JSON load error: actions should be array")
			actions = []
	else:
		print("Main: Invalid JSON")
		actions = []


func _process(delta):

	if actions.size() == 0: return

	time = time + delta
	var done = false
	var action
	while !done:
		if (action_idx >= actions.size()):
			break

		action = actions[action_idx]
		if (action.time < time):
			prints(time, action.method)
			self.callv(action.method, action.args)
			action_idx = action_idx + 1
		else:
			done = true


func kaleido_change(args):
	prints("kaleido_change", args)
