class_name Projectile
extends Node2D

export var trail_effect: PackedScene
export var cast_effect: PackedScene
export var hit_effect: PackedScene

export (float) var speed := 20.0
export (float) var lifetime := 3.0
export (int) var damage = 1
export (int) var pierce_count = 0
export (Const.DamageType) var type = Const.DamageType.MANA

var direction := Vector2.ZERO
var collision_mask = 1

onready var timer := $Timer
onready var hitbox := $HitBox
onready var sprite := $Sprite

signal process
signal die
signal hit
signal cast

var new_owner = null

var d := 0.0
var radius := 60.0


var movement_type = Const.MovementType.LINE

func _ready():
	set_as_toplevel(true)
	timer.connect("timeout", self, "die")
	timer.start(lifetime)
	call_deferred('create_cast_effect')
	call_deferred('create_trail_effect')
	direction = -angle_to_vector2(rotation)
	hitbox.collision_mask = collision_mask
	
	emit_signal('cast', self)
	Events.emit_signal("projectile_cast", self)

func _physics_process(delta: float) -> void:
	match movement_type:
		Const.MovementType.LINE:
			position += direction * speed * delta
		Const.MovementType.CIRCULAR:
			if new_owner:
				d += delta
				position = Vector2(
					sin(d * speed / 100) * radius,
					cos(d * speed / 100) * radius
				) + new_owner.global_position
				look_at(new_owner.global_position)
	
	emit_signal('process', self)
	Events.emit_signal("projectile_process", self)

func _on_HitBox_body_entered(body):
	Events.emit_signal("damaged",body, damage, type)
	
	emit_signal('hit', self)
	Events.emit_signal("projectile_hit", self)
	call_deferred('create_hit_effect')
	if pierce_count <= 0:
		die()
	else:
		pierce_count -= 1

func die():
	emit_signal('die', self)
	Events.emit_signal("projectile_die", self)
	
	call_deferred('queue_free')

func create_trail_effect():
	if trail_effect:
		var effect_instance = trail_effect.instance()
		effect_instance.node = self
		ObjectRegistry.register_effect(effect_instance)
		effect_instance.global_rotation = 0

func create_cast_effect():
	if cast_effect:
		var effect_instance = cast_effect.instance()
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
#		CameraShake.shake(2, 0.15)

func angle_to_vector2(angle: float) -> Vector2:
	return Vector2(sin(-angle), cos(angle))

func set_collision(new_collision_mask):
	collision_mask = new_collision_mask
