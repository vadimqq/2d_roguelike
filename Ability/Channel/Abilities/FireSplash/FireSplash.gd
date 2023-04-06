extends Channel

onready var particle = $Particles2D
onready var hit_box = $HitBox
onready var tween = $Tween

func _ready():
	hit_box.collision_mask = collision_mask
	particle.amount *= scale_modifier
	particle.process_material.set('scale', 7 * scale_modifier)


func _physics_process(delta: float) -> void:
	if is_casting:
		cast_splash()


func cast_splash() -> void:
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
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(hit_box, "scale", Vector2.ZERO, Vector2(1, 1), 0.5)
	tween.start()


func disappear() -> void:
	particle.emitting = false
	is_casting = false
	yield(get_tree().create_timer(2), "timeout")
	call_deferred('queue_free')
	


func _on_HitBox_body_entered(body):
	enemy_in_collider.append(body)


func _on_HitBox_body_exited(body):
	enemy_in_collider.erase(body)
