extends Projectile

onready var trail = $Trail
onready var tween = $Tween

var _target: Enemy
var drag_factor := 0.5 setget set_drag_factor

var _current_velocity := Vector2.ZERO
export (int) var max_trail_length = 15
var current_trail_length = 0

func _ready():
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(
		self, "current_trail_length", current_trail_length, max_trail_length, 3, Tween.TRANS_ELASTIC, Tween.EASE_OUT
	)
	tween.start()
	speed = rand_range(speed - 10, speed + 10)

func _process(delta):
	if _target:
		direction = global_position.direction_to(_target.global_position)
	
	var desired_velocity := direction * speed
	var previous_velocity = _current_velocity
	var change = (desired_velocity - _current_velocity) * drag_factor
	
	_current_velocity += change
	look_at(global_position + _current_velocity)
	
	trail.global_position = Vector2.ZERO
	trail.global_rotation = 0
	trail.add_point(global_position)
	
	while trail.get_point_count() > current_trail_length:
		trail.remove_point(0)

func set_drag_factor(new_value: float) -> void:
	drag_factor = clamp(new_value, 0.01, 0.5)

func _on_EnemyDetector_body_entered(body):
	if _target != null:
		return
		
	if body == null:
		return
		
	_target = body


func _on_EnemyDetector_body_exited(body):
	_target = null
