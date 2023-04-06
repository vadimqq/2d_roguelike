extends Enemy_motion


func enter():
	owner.collider.set_deferred('disabled', true)
	owner.get_node("AnimationTree").get("parameters/playback").travel("Death")
	owner.weapon_raycast.visible = false
	
