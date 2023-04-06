extends Enemy_motion


func enter():
	velocity = Vector2()
	randomize_direction()

	var direction = get_direction()
	update_look_direction(direction)
	owner.get_node("AnimationTree").get("parameters/playback").travel("Move")


func update(_delta):
	var direction = get_direction()
	if not direction:
		emit_signal("finished", "idle")
	
	if owner.weapon_raycast.is_colliding() and owner.attack_cooldown.is_stopped():
		emit_signal("finished", "attack")
	
	update_look_direction(direction)
	move(direction, _delta)
	owner.get_node("AnimationTree").set("parameters/Move/blend_position", owner.player.global_position - owner.global_position)

func move(target, delta):
	var direction = (target - owner.global_position).normalized() 
	var desired_velocity =  direction * owner.stats.get_max_move_speed()
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	velocity = owner.move_and_slide(velocity)

