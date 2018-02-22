extends Node2D

export(String, FILE, "*tscn") var projectile


func attack(direction):
	launch_projectile()


func launch_projectile():
	var direction = (get_global_mouse_position() - global_position).normalized()
	var instance = load(projectile).instance()
	add_child(instance)
	instance.launch(direction)