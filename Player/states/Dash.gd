extends Motion

var ghost_effect = preload('res://VFX/Ghost/ghost.tscn')

onready var timer = $Timer
onready var ghost_timer = $GhostTimer

func _ready():
	ghost_timer.stop()

func enter():
	timer.start()
	ghost_timer.start()
	Engine.time_scale = 0.3
	owner.collision_layer = 1
	owner.stats.modify_dash_count(-1)
	Events.emit_signal("player_cast_dash", owner)


func handle_input(event):
	return .handle_input(event)


func update(_delta):
	move(600, owner.look_direction)
	if Input.is_action_pressed("attack") and owner.get_current_weapon():
		owner.get_current_weapon().execute(owner.weapon_raycast.global_rotation)

func move(speed, direction):
	velocity = direction.normalized() * speed
	owner.move_and_slide(velocity, Vector2(), 5, 2)


func _on_Timer_timeout():
	Engine.time_scale = 1
	Events.emit_signal("player_end_dash", owner)
	emit_signal("finished", "idle")
	ghost_timer.stop()
	owner.collision_layer = 33


func _on_GhostTimer_timeout():
	var ghost = ghost_effect.instance()
	ObjectRegistry.register_effect(ghost)
	ghost.global_position = owner.sprite.global_position
	ghost.texture = owner.sprite.texture
	ghost.vframes = owner.sprite.vframes
	ghost.hframes = owner.sprite.hframes
	ghost.frame = owner.sprite.frame
