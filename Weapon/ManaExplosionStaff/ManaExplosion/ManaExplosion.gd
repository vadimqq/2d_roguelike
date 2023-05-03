extends Projectile

onready var trail = $TrailLine

var point = Vector2.ZERO

func _ready():
	trail.width *= scale_modifier

func _process(delta):
	trail._add_point(global_position)
