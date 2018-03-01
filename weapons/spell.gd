extends Node2D

export(PackedScene) var projectile


func attack(direction):
	launch_projectile()


func launch_projectile():
	var direction = (get_global_mouse_position() - global_position).normalized()
	var instance = projectile.instance()
	add_child(instance)
	instance.launch(direction)