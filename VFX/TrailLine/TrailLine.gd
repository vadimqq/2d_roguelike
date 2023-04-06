extends Line2D

export (int) var trail_length = 15

func _process(delta):
	while get_point_count() > trail_length:
		remove_point(0)


func _add_point(point_pos: Vector2):
	global_position = Vector2.ZERO
	global_rotation = 0
	add_point(point_pos)
