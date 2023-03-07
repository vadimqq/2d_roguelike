extends Enemy_motion

onready var duration = $Timer

func enter():
	owner.get_node("AnimationTree").get("parameters/playback").travel("Cast_1")
	duration.start()


func _on_Timer_timeout():
	owner.attack_1_timer.start()
	emit_signal("finished", "move")
