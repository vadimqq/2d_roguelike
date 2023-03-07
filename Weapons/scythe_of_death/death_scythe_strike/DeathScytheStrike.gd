extends Projectile


onready var animation = $Animation

func _ready():
	animation.play("cast")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
