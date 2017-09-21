extends Node2D

func _ready():
	set_process_input(true)
	var area_1 = load("res://scenes/area-1.tscn").instance()
	area_1.set_name("current-area")
	add_child(area_1)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		game_state.stop_game()

func move_right(scene):
	get_tree().set_pause(true)
	var new_scene = scene.instance()
	new_scene.set_name("new-area")
	add_child(new_scene)
	var y = get_node("current-area/player").get_pos().y
	get_node("new-area/player").set_pos(Vector2(50, y))
	get_node("animation-player").play("move-right")

func move_left(scene):
	get_tree().set_pause(true)
	var new_scene = scene.instance()
	new_scene.set_name("new-area")
	add_child(new_scene)
	var y = get_node("current-area/player").get_pos().y
	get_node("new-area/player").set_pos(Vector2(750, y))
	get_node("animation-player").play("move-left")

func swap_areas():
	get_node("current-area").set_name("old-area")
	get_node("new-area").set_name("current-area")
	get_node("old-area").queue_free()
	get_tree().set_pause(false)