extends Projectile


onready var trail = $Line2D

var point = Vector2.ZERO
export (int) var trail_length = 10

func _ready():
	pass # Replace with function body.


func _process(delta):
	trail.global_position = Vector2.ZERO
	trail.global_rotation = 0
	point = global_position
	trail.add_point(point)
	
	while trail.get_point_count() > trail_length:
		trail.remove_point(0)
