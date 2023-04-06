extends Channel

onready var particle = $Particles2D
onready var hit_box = $HitBox

func _ready():
	hit_box.collision_mask = collision_mask
	particle.amount *= scale_modifier


func _physics_process(delta):
	if is_casting:
		global_position +=  (get_global_mouse_position() - global_position).normalized() * 100 * delta
	if enemy_in_collider.size() > 0:
		if tick_timer.is_stopped():
			for enemy in enemy_in_collider:
				emit_signal("damage_tick")
				Events.emit_signal("damaged", enemy, damage, damage_tag)
			tick_timer.wait_time = cooldown
			tick_timer.start()

func appear() -> void:
	particle.emitting = true
	is_casting = true


func disappear() -> void:
	particle.emitting = false
	is_casting = false
	yield(get_tree().create_timer(2), "timeout")
	call_deferred('queue_free')
	


func _on_Hitbox_body_entered(body):
	enemy_in_collider.append(body)


func _on_Hitbox_body_exited(body):
	enemy_in_collider.erase(body)
