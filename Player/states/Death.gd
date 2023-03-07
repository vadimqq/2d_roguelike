extends Motion


func enter():
	owner.get_node("AnimationTree").get("parameters/playback").travel("Death")
	owner.weapon_raycast.visible = false
	
