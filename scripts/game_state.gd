extends Node

signal leveled_up()

const SAVE_PATH = "user://save.dat"

var current_scene
var entry_node = null

# current_scene: {"some": "data"}
# should be passed to scene.import_state(scene_data[...]) before
# adding the scene to the tree and should be populated like
# scene_data[current_scene] = scene.export_state() before the scene
# is destroyed (and also for current_scene when game is saved)
var scene_data = {}

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


enum CHARACTERS { GALE, MANNY, SKELE, SPODER }
var CHARACTER_DATA = {
	CHARACTERS.GALE: {
		"name": "Gale",
		"texture": load("res://images/gale.png"),
	},
	CHARACTERS.MANNY: {
		"name": "Manny",
		"texture": load("res://images/manny.png"),
	},
	CHARACTERS.SKELE: {
		"name": "Skele",
		"texture": load("res://images/skele.png"),
	},
	CHARACTERS.SPODER: {
		"name": "Spoder",
		"texture": load("res://images/spidermang.png"),
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
	if current_scene == null:
		player_hp = 100
		player_xp = 0
		set_scene("res://scenes/prison.tscn")
	else:
		set_scene(current_scene)
	get_node("/root/main-menu").hide()

func stop_game():
	logger.debug("stop_game()")
	get_node("/root/current_scene").queue_free()
	get_node("/root/main-menu").show()

func set_scene(scene, on_node=null):
	# TODO: try replacing this with change_scene
	if get_node("/root").has_node("current_scene"):
		var old_scene = get_node("/root/current_scene")
		if old_scene.has_method("export_state"):
			scene_data[current_scene] = old_scene.export_state()
		old_scene.set_name("old_scene")
		old_scene.queue_free()
	entry_node = on_node
	var new_scene = load(scene).instance()
	if new_scene.has_method("import_state") and scene_data.has(scene):
		new_scene.import_state(scene_data[scene])
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

func save_game():
	logger.debug("save_game()")
	if get_node("/root").has_node("current_scene"):
		var scene = get_node("/root/current_scene")
		if scene.has_method("export_state"):
			scene_data[current_scene] = scene.export_state()
	var file = File.new()
	file.open(SAVE_PATH, file.WRITE)
	file.store_16(1)  # version
	file.store_var(player_weapons)
	file.store_var(player_weapon)
	file.store_var(player_spells)
	file.store_var(player_spell)
	file.store_16(player_character)
	file.store_pascal_string(player_name)
	file.store_16(player_max_hp)
	file.store_16(player_hp)
	file.store_16(player_level)
	file.store_16(player_max_xp)
	file.store_16(player_xp)
	file.store_pascal_string(current_scene)
	file.store_var(scene_data)
	file.close()

func load_game():
	logger.debug("load_game()")
	var loaded = false
	var file = File.new()
	if not file.file_exists(SAVE_PATH):
		logger.debug("no save file")
		return loaded
	file.open(SAVE_PATH, file.READ)
	var version = file.get_16()
	if version == 1:
		load_game_v1(file)
		loaded = true
	file.close()
	return loaded

func load_game_v1(f):
	logger.debug("load_game_v1()")
	player_weapons = f.get_var()
	player_weapon = f.get_var()
	player_spells = f.get_var()
	player_spell = f.get_var()
	player_character = f.get_16()
	player_name = f.get_pascal_string()
	player_max_hp = f.get_16()
	player_hp = f.get_16()
	player_level = f.get_16()
	player_max_xp = f.get_16()
	player_xp = f.get_16()
	current_scene = f.get_pascal_string()
	scene_data = f.get_var()
