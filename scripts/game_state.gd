extends Node

signal leveled_up()

var current_scene
var current_npc

var projectiles = [
	load("res://projectiles/fireball.tscn"),
	load("res://projectiles/fireball.tscn"),
	load("res://projectiles/fireball.tscn"),
]

var weapons = [
	{"name": "Sword", "icon": load("res://weapons/sword/icon.png"), "scene": load("res://weapons/sword/sword.tscn")},
	{"name": "Hammer", "icon": load("res://weapons/hammer/icon.png"), "scene": load("res://weapons/hammer/hammer.tscn")},
]

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
var player_max_hp = 100
var player_hp = 100

var player_level = 1
var player_max_xp = 20
var player_xp = 0 setget _xp_setter


func next_texture():
	var i = _textures.find(player_texture)
	player_texture = _textures[(i + 1) % _textures.size()]

func prev_texture():
	var i = _textures.find(player_texture)
	player_texture = _textures[(i - 1) % _textures.size()]

func start_game():
	logger.debug("start_game()")
	player_hp = 100
	player_xp = 0
	set_scene("res://scenes/bridge.tscn")
	get_node("/root/main-menu").hide()

func stop_game():
	logger.debug("stop_game()")
	get_node("/root/current_scene").queue_free()
	get_node("/root/main-menu").show()

func set_scene(scene):
	# TODO: try replacing this with change_scene
	if get_node("/root").has_node("current_scene"):
		var old_scene = get_node("/root/current_scene")
		old_scene.set_name("old_scene")
		old_scene.queue_free()
	var new_scene = load(scene).instance()
	new_scene.set_name("current_scene")
	get_node("/root").add_child(new_scene)
	current_scene = scene

func _xp_setter(xp):
	player_xp = xp
	if player_xp >= player_max_xp:
		player_level += 1
		player_max_xp *= 2.4
		emit_signal("leveled_up")