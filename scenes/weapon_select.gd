extends Node2D


var radius = max(80, len(game_state.weapons) * 15)
var current_index


func _ready():
	pass


func _process(delta):
	get_node("selector").position = get_pos(current_index)


func _input(event):
	if visible:
		if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_UP and event.pressed:
			current_index = (current_index + 1) % len(game_state.weapons)
		if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
			current_index = (current_index - 1) % len(game_state.weapons)
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
			get_node("..").set_player_weapon(current_index)
			get_tree().set_pause(false)
			hide()
		if event is InputEventKey and event.scancode == KEY_F and event.pressed:
			get_tree().set_pause(false)
			hide()
	elif event is InputEventKey and event.scancode == KEY_F and event.pressed:
		get_tree().set_pause(true)
		show_weapons()
		show()


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