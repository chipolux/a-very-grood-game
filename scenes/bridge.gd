extends Node2D


func _ready():
	get_tree().set_pause(true)
	get_node("scene-animations").connect("animation_finished", self, "_on_animation_finished")
	get_node("scene-animations").play("opening")


func _on_animation_finished(anim_name):
	print("anim finished")
	get_tree().set_pause(false)