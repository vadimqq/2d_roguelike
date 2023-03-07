extends Particles2D

var node: Node2D

onready var tween = $Tween
var start = Vector2(0, 0)
var end = Vector2(1, 1)
func _ready():
	node.connect("process", self, 'on_fly')
	node.connect("die", self, 'on_quit')
	global_position = node.global_position
	set_deferred('emitting', true)
	tween.interpolate_property(self, "scale", start, end, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func on_fly(projectile):
	global_position = projectile.global_position
	rotation_degrees = node.rotation_degrees

func on_quit(projectile):
		emitting = false
		yield(get_tree().create_timer(lifetime), "timeout")
		call_deferred('queue_free')
