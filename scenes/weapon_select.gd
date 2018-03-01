extends Node2D

var radius = max(80, len(game_state.weapons) * 15)


func _ready():
	pass


func show_weapons():
	var slice = (2 * PI) / len(game_state.weapons)
	for i in range(len(game_state.weapons)):
		var weapon = game_state.weapons[i]
		var pos = Vector2(cos(i * slice) * radius, sin(i * slice) * radius)
		var sprite = Sprite.new()
		add_child(sprite)
		sprite.set_texture(weapon["icon"])
		sprite.scale *= 4
		sprite.position = pos