extends Enemy_motion


func enter():
	owner.weapon.execute(owner.weapon_raycast.global_rotation, owner.attack_collision_mask)
	emit_signal("finished", "move")
