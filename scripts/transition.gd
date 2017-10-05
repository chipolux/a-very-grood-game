extends Area2D

export(String, FILE, "*tscn") var scene

func _ready():
	connect("body_enter", self, "body_entered")

func body_entered(body):
	if body.get_name() == "player" and scene:
		game_state.set_scene(scene)