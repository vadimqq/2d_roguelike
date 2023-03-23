extends Motion


export(float) var max_run_speed = 300.0

var is_run = false

func enter():
	speed = 0.0
	velocity = Vector2()

	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	owner.get_node("AnimationTree").get("parameters/playback").travel("Walk")

func handle_input(event):
	return .handle_input(event)


func update(_delta):
	var input_direction = get_input_direction()
	if not input_direction:
		emit_signal("finished", "idle")
	update_look_direction(input_direction)
	if Input.is_action_pressed("dash") and owner.stats.current_dash_count > 0:
		emit_signal("finished", "dash")
	is_run = false
	if Input.is_action_pressed("attack") and owner.get_current_weapon():
		owner.get_current_weapon().execute(owner.weapon_raycast.global_rotation ,1)
		speed = owner.stats.get_min_move_speed()
	else:
		speed = owner.stats.get_max_move_speed()

	move(speed, input_direction)


func move(speed, direction):
	velocity = direction.normalized() * speed
	owner.move_and_slide(velocity, Vector2(), 5, 2)
