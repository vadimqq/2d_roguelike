extends Enemy_motion

func enter():
	owner.get_node("AnimationTree").get("parameters/playback").travel("Preparation")
	owner.preparation_duration_timer.start()

func update(_delta):
	owner.weapon_raycast.look_at(owner.player.global_position)

func _on_PreparationDuration_timeout():
	owner.preparation_color_rect.rect_size = Vector2.ZERO
	owner.last_player_position = owner.player.global_position
	emit_signal("finished", "attack")
