extends Enemy_motion


func enter():
	owner.get_node("AnimationTree").get("parameters/playback").travel("Attack")
	owner.get_node("AnimationTree").set("parameters/Attack/blend_position", owner.player.global_position - owner.global_position)
#	call_deferred('emit_signal', "use_attack")
