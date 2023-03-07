extends Camera2D


func _process(delta):
	var mouse_pos = get_global_mouse_position()
	offset_h = (mouse_pos.x - global_position.x) / (1920.0 / 2.0)
	offset_v = (mouse_pos.y - global_position.y) / (1080.0 / 2.0)
