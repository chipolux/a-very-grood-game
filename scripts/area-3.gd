extends Node2D

func _ready():
	get_node("move-right").connect("body_enter", self, "move_right")

func move_right(body):
	if body.get_name() == "player":
		get_node("/root/game").move_right(load("res://scenes/area-1.tscn"))