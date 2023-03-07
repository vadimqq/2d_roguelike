extends Enemy_motion


func enter():
	owner.get_node("AnimationTree").get("parameters/playback").travel("Idle")


func update(_delta):
	var direction = get_direction()
	if direction:
		emit_signal("finished", "move")
#	if Input.is_action_pressed("attack") && owner.get_current_weapon():
#		owner.get_current_weapon().fire(owner.weapon_raycast.global_rotation ,1)
