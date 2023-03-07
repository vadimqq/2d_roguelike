extends Enemy_motion

onready var attack_delay = $AttackDelay

func enter():
	velocity = Vector2()
	randomize_direction()

	var direction = get_direction()
	update_look_direction(direction)
	owner.get_node("AnimationTree").get("parameters/playback").travel("Walk")


func update(_delta):
	var direction = get_direction()
	if not direction:
		emit_signal("finished", "idle")
	if owner.player:
		owner.weapon_raycast.look_at(owner.player.global_position)
	
	if attack_delay.is_stopped() and owner.weapon_raycast.is_colliding():
		if owner.attack_2_timer.is_stopped() :
			attack_delay.start()
			emit_signal("finished", "attack_2")
		elif owner.attack_3_timer.is_stopped() :
			attack_delay.start()
			emit_signal("finished", "attack_3")
		elif owner.attack_1_timer.is_stopped() :
			attack_delay.start()
			emit_signal("finished", "attack_1")
	
	update_look_direction(direction)
	move(direction, _delta)
	owner.get_node("AnimationTree").set("parameters/Walk/blend_position", owner.player.global_position - owner.global_position)
	

func move(target, delta):
	var direction = (target - owner.global_position).normalized() 
	var desired_velocity =  direction * owner.stats.get_max_move_speed()
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	velocity = owner.move_and_slide(velocity)

