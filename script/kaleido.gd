extends Node2D

const name = "Kaleido"

func _ready():
	prints(name, "ready.")


func change(args):
	prints(name, "change:", args)
