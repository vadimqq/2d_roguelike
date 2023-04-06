extends Projectile


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.global_rotation = 0


func _on_HitBox_area_entered(area):
	area.find_parent('*').call_deferred('queue_free')
	call_deferred('queue_free')
