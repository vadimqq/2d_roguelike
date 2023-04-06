extends Projectile


onready var trail = $Trail
onready var enemy_dectector = $Detector

export (int) var trail_length = 15
var point = Vector2.ZERO

func _ready():
	enemy_dectector.collision_mask = collision_mask
	enemy_dectector.owner_ability = self
	trail.width *= scale_modifier

func _process(delta):
	trail.global_position = Vector2.ZERO
	trail.global_rotation = 0
	point = global_position
	trail.add_point(point)
	
	while trail.get_point_count() > trail_length:
		trail.remove_point(0)
	

