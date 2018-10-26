extends CanvasLayer

onready var convo_screen = get_node("convo_screen")
onready var menu = get_node("menu")
onready var weapon_select = get_node("weapon_select")
var current_screen = null


func _ready():
	convo_screen.connect("done", self, "_screen_closed")
	menu.connect("done", self, "_screen_closed")
	weapon_select.connect("done", self, "_screen_closed")
	get_node("black").hide()


func _input(event):
	if current_screen:
		current_screen.handle_input(event)
	elif event.is_action_pressed('ui_accept') and game_state.current_npc:
		convo_screen.begin_conversation(game_state.current_npc)
		current_screen = convo_screen
	elif event.is_action_pressed('ui_accept') and game_state.current_interactable:
		game_state.current_interactable.interact()
	elif event.is_action_pressed("ui_cancel"):
		get_tree().set_pause(true)
		menu.show()
		menu.match_volume()
		current_screen = menu
	elif event.is_action_pressed("ui_weapon_select"):
		get_tree().set_pause(true)
		weapon_select.show_weapons()
		weapon_select.show()
		current_screen = weapon_select


func _screen_closed():
	current_screen.hide()
	current_screen = null
	get_tree().set_pause(false)