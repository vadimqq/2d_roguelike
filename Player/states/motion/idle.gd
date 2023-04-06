extends Motion


func enter():
	owner.get_node("AnimationTree").get("parameters/playback").travel("Idle")


func handle_input(event):
	return .handle_input(event)


func update(_delta):
	var input_direction = get_input_direction()
	if input_direction:
		emit_signal("finished", "move")
	
	if Input.is_action_pressed("attack") and owner.get_current_weapon():
		owner.get_current_weapon().execute(owner.weapon_raycast.global_rotation ,owner.attack_collision_mask)
