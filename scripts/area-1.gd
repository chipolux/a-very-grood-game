extends Node2D

func _ready():
	get_node("move-right").connect("body_enter", self, "move_right")
	get_node("move-left").connect("body_enter", self, "move_left")

func move_right(body):
	if body.get_name() == "player":
		get_node("/root/game").move_right(load("res://scenes/area-2.tscn"))

func move_left(body):
	if body.get_name() == "player":
		get_node("/root/game").move_left(load("res://scenes/area-3.tscn"))