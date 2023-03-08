extends Line2D


export (int) var length = 30

var parent

func _ready():
	clear_points()
	parent = get_parent()
	
func _process(delta):
	if parent:
		global_position = Vector2.ZERO
		global_rotation = 0
		add_point(parent.global_position)

		if points.size() > length:
			remove_point(0)
