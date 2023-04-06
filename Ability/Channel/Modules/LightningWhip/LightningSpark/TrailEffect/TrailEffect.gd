extends Particles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _stop_draw():
	emitting = false
	yield(get_tree().create_timer(3), "timeout")
	queue_free()
