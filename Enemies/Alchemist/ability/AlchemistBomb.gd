extends Projectile

onready var trail = $TrailLine

func _process(delta):
	trail._add_point(global_position)
