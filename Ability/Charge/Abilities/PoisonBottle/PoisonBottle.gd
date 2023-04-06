extends Charge

export (float) var max_speed := 500.0
export (float) var min_speed := 50.0
var speed = 0
var max_dmage = damage

const hit_particle = preload("res://Ability/Charge/Abilities/PoisonBottle/HitParticle.tscn")
const poison_area = preload("res://Ability/Charge/Abilities/PoisonBottle/PoisonArea/PoisonArea.tscn")

onready var hit_box = $Hitbox
onready var hit_box_collider = $Hitbox/CollisionShape2D
onready var sprite = $Sprite

var direction = Vector2.ZERO

func _ready():
	max_dmage = damage
	hit_box_collider.set_deferred('disabled', true)
	hit_box.collision_mask = collision_mask
	tween.interpolate_property(hit_box, "scale", Vector2(0.2, 0.2), Vector2(1, 1), max_charge_duration)
	tween.interpolate_property(self, "speed", min_speed, max_speed, max_charge_duration)
	tween.interpolate_property(sprite, "scale", Vector2(0.2, 0.2), Vector2(1, 1), max_charge_duration)
	tween.interpolate_property(self, "damage", 1, max_dmage, max_charge_duration)
	tween.start()

func _physics_process(delta):
	if is_ready:
		position += direction * speed * delta


func _on_Hitbox_body_entered(body):
	Events.emit_signal("ability_hit", self)
	is_ready = false
	var particle = hit_particle.instance()
	particle.global_position = global_position
	particle.scale = sprite.scale
	ObjectRegistry.register_effect(particle)
	var poison_area_instance = poison_area.instance()
	poison_area_instance.global_position = global_position
	poison_area_instance.scale = sprite.scale
	poison_area_instance.scale_modifier = scale_modifier
	poison_area_instance.damage = damage
	poison_area_instance.life_time = life_time
	poison_area_instance.collision_mask = collision_mask
	ObjectRegistry.register_ability(poison_area_instance)
	call_deferred('die')


func _on_PoisonBottle_execute_charge():
	direction = Vector2(1, 0).rotated(rotation)
	hit_box_collider.set_deferred('disabled', false)
	tween.remove_all()
	tween.interpolate_property(sprite, "rotation_degrees", sprite.rotation_degrees, sprite.rotation_degrees + 1440, 5)
	tween.start()
