extends Node2D

func _ready():
	get_node("move-left").connect("body_enter", self, "move_left")

func move_left(body):
	if body.get_name() == "player":
		get_node("/root/game").move_left(load("res://scenes/area-1.tscn"))