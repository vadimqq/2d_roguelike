extends Enemy_motion


func enter():
	owner.get_node("AnimationTree").get("parameters/playback").travel("Attack")
	

func return_to_move():
	emit_signal("finished", "move")
