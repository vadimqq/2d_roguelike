extends Enemy_motion

var last_owner_position = Vector2.ZERO

func enter():
	owner.get_node("AnimationTree").get("parameters/playback").travel("Attack")
	owner.hitbox_collision.set_deferred('disabled', false)
	owner.dash_attack_duration_timer.start()
#	Vector2()
	last_owner_position = owner.global_position

func update(_delta):
	var direction = (last_owner_position.direction_to(owner.last_player_position)).normalized() 
	var desired_velocity =  direction * owner.stats.get_max_move_speed() * 4.5
	var steering = (desired_velocity - velocity) * _delta * 2.5
	velocity += steering
	velocity = owner.move_and_slide(velocity)


func _on_DashAttackDuration_timeout():
	owner.dash_attack_cooldown_timer.start()
	owner.hitbox_collision.set_deferred('disabled', true)
	emit_signal("finished", "move")
	velocity = Vector2.ZERO
