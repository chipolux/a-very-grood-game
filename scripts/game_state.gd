extends Node

var _textures = [
	load("res://images/angel.png"),
	load("res://images/gale.png"),
	load("res://images/hobo.png"),
	load("res://images/manny.png"),
	load("res://images/shelby.png"),
	load("res://images/shroom.png"),
	load("res://images/top_hat.png"),
	load("res://images/mohawk.png"),
]
var player_texture = _textures[0]
var player_name
var current_scene
var current_npc

func next_texture():
	var i = _textures.find(player_texture)
	player_texture = _textures[(i + 1) % _textures.size()]

func prev_texture():
	var i = _textures.find(player_texture)
	player_texture = _textures[(i - 1) % _textures.size()]

func start_game():
	logger.debug("start_game()")
	set_scene("res://scenes/bridge.tscn")
	get_node("/root/main-menu").hide()

func stop_game():
	logger.debug("stop_game()")
	get_node("/root/current_scene").queue_free()
	get_node("/root/main-menu").show()

func set_scene(scene):
	if get_node("/root").has_node("current_scene"):
		var old_scene = get_node("/root/current_scene")
		old_scene.set_name("old_scene")
		old_scene.queue_free()
	var new_scene = load(scene).instance()
	new_scene.set_name("current_scene")
	get_node("/root").add_child(new_scene)
	current_scene = scene