extends Enemy_motion


func enter():
	owner.get_node("AnimationTree").get("parameters/playback").travel("Attack")
	

func go_to_death():
	emit_signal("finished", "death")
