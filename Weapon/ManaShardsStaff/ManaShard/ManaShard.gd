extends Projectile


const trail_effect = preload("res://Weapon/ManaShardsStaff/ManaShard/TrailEffect/TrailEffect.tscn")

var trail_effect_instance = null

func _ready():
	trail_effect_instance = trail_effect.instance()
	ObjectRegistry.register_effect(trail_effect_instance)
	connect("tree_exiting", trail_effect_instance, '_stop_draw')
	direction = direction.rotated(rand_range(-0.2, 0.2))

func _process(delta):
	if trail_effect_instance:
		trail_effect_instance.global_position = global_position
