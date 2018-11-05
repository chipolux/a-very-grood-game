extends Node2D

signal done()

var radius = max(80, game_state.WEAPONS.size() * 15)
var selection_timer = Timer.new()
var current_index = 0


func _ready():
	selection_timer.one_shot = true
	selection_timer.wait_time = 0.08
	add_child(selection_timer)


func _process(delta):
	if visible and game_state.player_weapons:
		get_node("selector").position = get_pos(game_state.player_weapons[current_index])


func handle_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_UP and event.pressed:
		if selection_timer.is_stopped():
			current_index = (current_index + 1) % len(game_state.player_weapons)
			get_node("select").play()
			selection_timer.start()
	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
		if selection_timer.is_stopped():
			current_index = (current_index - 1) % len(game_state.player_weapons)
			get_node("select").play()
			selection_timer.start()
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		get_node("../..").set_weapon(game_state.player_weapons[current_index])
		emit_signal("done")
	if event is InputEventKey and event.scancode == KEY_F and event.pressed:
		emit_signal("done")


func get_pos(weapon):
	var slice = (2 * PI) / game_state.WEAPONS.size()
	return Vector2(cos(weapon * slice) * radius, sin(weapon * slice) * radius)


func show_weapons():
	current_index = game_state.player_weapons.find(game_state.player_weapon)
	for weapon in game_state.player_weapons:
		var sprite = Sprite.new()
		add_child(sprite)
		sprite.set_texture(game_state.WEAPON_DATA[weapon]["icon"])
		sprite.scale *= 4
		sprite.position = get_pos(weapon)