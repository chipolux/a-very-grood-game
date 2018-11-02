extends KinematicBody2D

const MOVEMENT_SPEED = 250

var ui
var current_anim = "stand_down"
var velocity = Vector2()
var teleport_position


func _ready():
	get_node("special_player").connect("animation_finished", self, "_animation_finished")
	get_node("sprite").set_texture(game_state.player_texture)
	get_node("spell").projectile = game_state.projectiles[0]
	set_player_weapon(0)
	game_state.connect("leveled_up", get_node("special_player"), "play", ["level_up"])
	ui = get_node("ui")
	ui.get_node("hud").show()


func _physics_process(delta):
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += MOVEMENT_SPEED
	if Input.is_action_pressed("ui_left"):
		velocity.x -= MOVEMENT_SPEED
	if Input.is_action_pressed("ui_down"):
		velocity.y += MOVEMENT_SPEED
	if Input.is_action_pressed("ui_up"):
		velocity.y -= MOVEMENT_SPEED
	move_and_slide(velocity)


func _process(delta):
	var new_anim = "stand_down"
	if (velocity.y < 0):
		new_anim = "walk_up"
	elif (velocity.y > 0):
		new_anim = "walk_down"
	elif (velocity.x < 0):
		new_anim = "walk_left"
	elif (velocity.x > 0):
		new_anim = "walk_right"
	else:
		new_anim = "stand_" + current_anim.split("_")[1]
	if (new_anim != current_anim):
		current_anim = new_anim
		get_node("anim").play(current_anim)
	ui.get_node("hud/hp_bar").max_value = game_state.player_max_hp
	ui.get_node("hud/hp_bar").value = game_state.player_hp
	ui.get_node("hud/xp_bar").max_value = game_state.player_max_xp
	ui.get_node("hud/xp_bar").value = game_state.player_xp
	if not get_node("hit_player").is_playing():
		_process_enemies()


func _input(event):
	if event.is_action_pressed("attack_l"):
		attack_with_left_hand()
	if event.is_action_pressed("attack_r"):
		attack_with_right_hand()
		logger.debug("player at %s" % position)


func _process_enemies():
	for body in get_node("hitbox").get_overlapping_bodies():
		logger.debug("player hit by %s" % body.get_name())
		var direction = (global_position- body.global_position).normalized()
		move_and_slide(direction * body.KNOCKBACK)
		game_state.player_hp -= body.DAMAGE
		if game_state.player_hp <= 0:
			get_node("hit_player").play("die")
		else:
			get_node("hit_player").play("hit")


func _animation_finished(name):
	if "teleport" in name:
		_end_teleport()

func set_player_sprite(texture):
	get_node("sprite").set_texture(texture)


func set_player_weapon(i):
	var instance = game_state.weapons[i]["scene"].instance()
	instance.set_name("weapon")
	var old_weapon = get_node("weapon")
	old_weapon.set_name("old_weapon")
	old_weapon.queue_free()
	add_child(instance)
	get_node("ui/weapon_select").current_index = i


func die():
	game_state.stop_game()


func attack_with_left_hand():
	var direction = current_anim.split("_")[1]
	if has_node("weapon"):
		get_node("weapon").attack(direction)


func attack_with_right_hand():
	var direction = current_anim.split("_")[1]
	if has_node("spell"):
		get_node("spell").attack(direction)


func hide_hud():
	get_node("ui/hud").hide()


func show_hud():
	get_node("ui/hud").show()


func teleport(new_pos, hard=false):
	teleport_position = new_pos
	if hard:
		get_node("special_player").play("teleport_hard")
	else:
		get_node("special_player").play("teleport")
	get_tree().set_pause(true)


func _perform_teleport():
	position = teleport_position


func _end_teleport():
	teleport_position = null
	get_tree().set_pause(false)