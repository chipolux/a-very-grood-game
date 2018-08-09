extends Control

signal done()

var master_bus
var ui_bus
var fx_bus

func _ready():
	hide()
	master_bus = AudioServer.get_bus_index("Master")
	ui_bus = AudioServer.get_bus_index("ui")
	fx_bus = AudioServer.get_bus_index("fx")
	get_node("volume_grid/volume_slider").connect("value_changed", self, "_on_volume_changed")
	get_node("volume_grid/ui_volume_slider").connect("value_changed", self, "_on_ui_volume_changed")
	get_node("volume_grid/fx_volume_slider").connect("value_changed", self, "_on_fx_volume_changed")
	get_node("quit_button").connect("pressed", self, "_on_quit_pressed")
	get_node("continue_button").connect("pressed", self, "_on_continue_pressed")

func _on_volume_changed(value):
	AudioServer.set_bus_volume_db(master_bus, linear2db(value))

func _on_ui_volume_changed(value):
	AudioServer.set_bus_volume_db(ui_bus, linear2db(value))

func _on_fx_volume_changed(value):
	AudioServer.set_bus_volume_db(fx_bus, linear2db(value))

func _on_continue_pressed():
	hide()
	get_tree().set_pause(false)
	emit_signal("done")

func _on_quit_pressed():
	get_tree().set_pause(false)
	game_state.stop_game()

func handle_input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("done")

func match_volume():
	get_node("volume_grid/volume_slider").value = db2linear(AudioServer.get_bus_volume_db(master_bus))
	get_node("volume_grid/ui_volume_slider").value = db2linear(AudioServer.get_bus_volume_db(ui_bus))
	get_node("volume_grid/fx_volume_slider").value = db2linear(AudioServer.get_bus_volume_db(fx_bus))