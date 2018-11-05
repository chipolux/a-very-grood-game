extends Node

signal leveled_up()

var current_scene
var entry_node = null

var current_npc
var current_interactable


enum WEAPONS { SWORD, HAMMER }
var WEAPON_DATA = {
	WEAPONS.SWORD: {
		"name": "Sword",
		"scene": load("res://weapons/sword/sword.tscn"),
		"icon": load("res://weapons/sword/icon.png"),
	},
	WEAPONS.HAMMER: {
		"name": "Hammer",
		"scene": load("res://weapons/hammer/hammer.tscn"),
		"icon": load("res://weapons/hammer/icon.png"),
	},
}
var player_weapons = []
var player_weapon = null


enum SPELLS { FIREBALL }
var SPELL_DATA = {
	SPELLS.FIREBALL: {
		"name": "Fireball",
		"scene": load("res://projectiles/fireball.tscn"),
	},
}
var player_spells = []
var player_spell = null


enum CHARACTERS { GALE, MANNY }
var CHARACTER_DATA = {
	CHARACTERS.GALE: {
		"name": "Gale",
		"texture": load("res://images/gale.png"),
	},
	CHARACTERS.MANNY: {
		"name": "Manny",
		"texture": load("res://images/manny.png"),
	},
}
var player_character = CHARACTERS.GALE


var player_name
var player_max_hp = 100
var player_hp = 100

var player_level = 1
var player_max_xp = 20
var player_xp = 0 setget _xp_setter


func start_game():
	logger.debug("start_game()")
	player_hp = 100
	player_xp = 0
	set_scene("res://scenes/prison.tscn")
	get_node("/root/main-menu").hide()

func stop_game():
	logger.debug("stop_game()")
	get_node("/root/current_scene").queue_free()
	get_node("/root/main-menu").show()

func set_scene(scene, on_node=null):
	# TODO: try replacing this with change_scene
	if get_node("/root").has_node("current_scene"):
		var old_scene = get_node("/root/current_scene")
		old_scene.set_name("old_scene")
		old_scene.queue_free()
	entry_node = on_node
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

func give_weapon(weapon):
	if not weapon in WEAPONS.values():
		logger.error("Tried to give player invalid weapon: %s" % weapon)
		return
	if weapon in player_weapons:
		logger.debug("Player already has weapon: %s" % weapon)
		return
	logger.debug("Gave player weapon: %s" % weapon)
	player_weapons.append(weapon)