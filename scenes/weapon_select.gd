extends Node2D

signal done()

var radius = max(80, len(game_state.weapons) * 15)
var current_index
var selection_timer = Timer.new()


func _ready():
	selection_timer.one_shot = true
	selection_timer.wait_time = 0.08
	add_child(selection_timer)


func _process(delta):
	get_node("selector").position = get_pos(current_index)


func handle_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_UP and event.pressed:
		if selection_timer.is_stopped():
			current_index = (current_index + 1) % len(game_state.weapons)
			get_node("select").play()
			selection_timer.start()
	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
		if selection_timer.is_stopped():
			current_index = (current_index - 1) % len(game_state.weapons)
			get_node("select").play()
			selection_timer.start()
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		get_node("../..").set_player_weapon(current_index)
		emit_signal("done")
	if event is InputEventKey and event.scancode == KEY_F and event.pressed:
		emit_signal("done")


func get_pos(i):
	var slice = (2 * PI) / len(game_state.weapons)
	return Vector2(cos(i * slice) * radius, sin(i * slice) * radius)


func show_weapons():
	for i in range(len(game_state.weapons)):
		var weapon = game_state.weapons[i]
		var sprite = Sprite.new()
		add_child(sprite)
		sprite.set_texture(weapon["icon"])
		sprite.scale *= 4
		sprite.position = get_pos(i)