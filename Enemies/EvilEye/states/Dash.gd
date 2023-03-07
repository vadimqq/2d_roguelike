extends Enemy_motion

var ghost_effect = preload('res://VFX/Ghost/ghost.tscn')

onready var timer = $Timer
onready var ghost_timer = $GhostTimer

func _ready():
	ghost_timer.stop()

func enter():
	pass
	timer.start()
	ghost_timer.start()


func handle_input(event):
	return .handle_input(event)


func update(_delta):
	var collision_info = move(400, owner.look_direction)

func move(speed, direction):
	velocity = direction.normalized() * speed
	owner.move_and_slide(velocity, Vector2(), 5, 2)
	if owner.get_slide_count() == 0:
		return
	return owner.get_slide_collision(0)


func _on_Timer_timeout():
	emit_signal("finished", "idle")
	ghost_timer.stop()


func _on_GhostTimer_timeout():
	var ghost = ghost_effect.instance()
	ObjectRegistry.register_effect(ghost)
	ghost.global_position = owner.sprite.global_position
	ghost.texture = owner.sprite.texture
	ghost.vframes = owner.sprite.vframes
	ghost.hframes = owner.sprite.hframes
	ghost.frame = owner.sprite.frame
