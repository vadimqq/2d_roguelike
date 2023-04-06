extends Channel

onready var hit_box := $Hitbox

func _ready():
	hit_box.collision_mask = collision_mask

func _process(delta):
	if enemy_in_collider.size() > 0:
		if tick_timer.is_stopped():
			for enemy in enemy_in_collider:
				Events.emit_signal("damaged", enemy, damage, damage_tag)
			tick_timer.wait_time = cooldown
			tick_timer.start()

func _on_Hitbox_body_entered(body):
	enemy_in_collider.append(body)


func _on_Hitbox_body_exited(body):
	enemy_in_collider.erase(body)
