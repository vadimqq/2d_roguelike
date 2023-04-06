extends Enemy_motion


func enter():
	owner.get_node("AnimationTree").get("parameters/playback").travel("Idle")


func update(_delta):
	var direction = get_direction()
	if direction:
		emit_signal("finished", "move")

