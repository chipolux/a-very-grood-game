extends Area2D

export(String, FILE, "*tscn") var scene
export(String) var entry_node = null

func _ready():
	connect("body_entered", self, "body_entered")

func body_entered(body):
	logger.debug("%s.body_entered(%s)" % [get_name(), body.get_name()])
	if body.get_name() == "player" and scene:
		game_state.set_scene(scene, entry_node)