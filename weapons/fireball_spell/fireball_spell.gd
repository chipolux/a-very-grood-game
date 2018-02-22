extends Node2D


func attack(direction):
	launch_fireball()


func launch_fireball():
	var direction = (get_global_mouse_position() - global_position).normalized()
	var projectile = load("res://weapons/fireball_spell/fireball.tscn").instance()
	add_child(projectile)
	projectile.launch(direction)