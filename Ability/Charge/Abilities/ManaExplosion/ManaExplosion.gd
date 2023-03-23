extends Charge

const explosion_scene = preload("res://Ability/Charge/Abilities/ManaExplosion/explosion/Explosion.tscn")

export (float) var max_speed := 500.0
export (float) var min_speed := 50.0
var speed = 0
var max_dmage = damage

onready var charge_particle = $Particles2D
onready var hit_box = $Hitbox
onready var hit_box_collider = $Hitbox/CollisionShape2D
onready var sprite = $Sprite

var direction = Vector2.ZERO

func _ready():
	max_dmage = damage
	hit_box.collision_mask = collision_mask
	tween.interpolate_property(charge_particle, "scale", Vector2(0.2, 0.2), Vector2(1, 1), max_charge_duration)
	tween.interpolate_property(hit_box, "scale", Vector2(0.2, 0.2), Vector2(1, 1), max_charge_duration)
	tween.interpolate_property(self, "speed", min_speed, max_speed, max_charge_duration)
	tween.interpolate_property(sprite, "scale", Vector2(0.2, 0.2), Vector2(1, 1), max_charge_duration)
	tween.interpolate_property(self, "damage", 1, max_dmage, max_charge_duration)
	tween.start()


func _on_ManaExplosion_execute_charge():
	rotation_degrees += 90
	direction = -MathUtils.angle_to_vector2(global_rotation)
	hit_box_collider.set_deferred('disabled', false)


func _physics_process(delta):
	if is_ready:
		position += direction * speed * delta


func _on_Hitbox_body_entered(body):
	Events.emit_signal("ability_hit", self)
	is_ready = false
	var explosion = explosion_scene.instance()
	explosion.global_position = global_position
	explosion.scale *= power_percent / 100
	explosion.scale_modifier = scale_modifier
	explosion.damage = damage
	ObjectRegistry.register_ability(explosion)
	call_deferred('die')
	
