extends Projectile

onready var trail = $TrailLine

var temp_direction = Vector2.ZERO

func _ready():
	temp_direction = direction
	direction = direction.rotated(rand_range(-0.6, 0.6))

func _process(delta):
	if !is_homing:
		direction = lerp(direction.rotated(rand_range(-0.3, 0.3)), temp_direction, 0.01)
	trail._add_point(global_position)

func create_execute_effect():
	if execute_effect:
		var effect_instance = execute_effect.instance()
		effect_instance.global_position = global_position
		effect_instance.global_transform = global_transform
		effect_instance.emitting = true
		ObjectRegistry.register_effect(effect_instance)


func create_hit_effect():
	if hit_effect:
		var effect_instance = hit_effect.instance()
		effect_instance.global_position = global_position
		effect_instance.global_transform = global_transform
		effect_instance.emitting = true
		ObjectRegistry.register_effect(effect_instance)
