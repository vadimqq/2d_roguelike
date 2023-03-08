class_name Projectile
extends Node2D

export var cast_effect: PackedScene
export var hit_effect: PackedScene

export (float) var speed := 20.0
export (float) var lifetime := 3.0
export (int) var damage = 1
export (int) var pierce_count = 0
export (int) var rebound_count = 0
export (float) var radius := 40.0
export (float) var zigzag_swap_time = 0.2
export (float) var scale_modifier = 1.0
export (Const.DamageType) var type = Const.DamageType.MANA

var direction := Vector2.ZERO
var collision_mask = 1

onready var timer := $LifeTimer
onready var zigzag_timer = $ZigzagTimer
onready var hitbox := $HitBox
onready var sprite := $Sprite

signal process
signal die
signal hit
signal cast

var new_owner = null

var d := 0.0
var for_zigzag_swap = true
var is_first_direction_swap = true
var movement_type = Const.MovementType.LINE
var unic_modules = []
var traveled_distance = 0

func _ready():
	set_as_toplevel(true)
	timer.connect("timeout", self, "die")
	timer.start(lifetime)
	call_deferred('create_cast_effect')
	direction = -MathUtils.angle_to_vector2(rotation)
	hitbox.collision_mask = collision_mask
	
	sprite.scale *= scale_modifier
	hitbox.scale *= scale_modifier
	
	if movement_type == Const.MovementType.ZIGZAG:
		zigzag_timer.wait_time = 0.2
		zigzag_timer.start()
	
	traveled_distance += 1
	emit_signal('cast', self)
	Events.emit_signal("projectile_cast", self)


func _physics_process(delta: float) -> void:
	match movement_type:
		Const.MovementType.LINE:
			position += direction * speed * delta
		Const.MovementType.CIRCULAR:
			if new_owner:
				d -= delta
				position = Vector2(
					sin(d * speed / 100) * radius,
					cos(d * speed / 100) * radius
				) + new_owner.global_position
				look_at(new_owner.global_position)
		Const.MovementType.ZIGZAG:
			position += direction * speed * delta
	
	traveled_distance += 1
	
	emit_signal('process', self, traveled_distance)
	Events.emit_signal("projectile_process", self, traveled_distance)

func _on_HitBox_body_entered(body):
	Events.emit_signal("damaged",body, damage, type)
	
	emit_signal('hit', self)
	Events.emit_signal("projectile_hit", self)
	call_deferred('create_hit_effect')
	if pierce_count > 0:
		pierce_count -= 1
		return
	if rebound_count > 0:
		rotation_degrees -= rand_range(150, 210)
		direction = -MathUtils.angle_to_vector2(rotation)
		rebound_count -= 1
		return
	die()

func die():
	emit_signal('die', self)
	Events.emit_signal("projectile_die", self)
	
	call_deferred('queue_free')

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


func set_collision(new_collision_mask):
	collision_mask = new_collision_mask


func _on_ZigzgTimer_timeout():
	zigzag_swap_direction()

func zigzag_swap_direction():
	if is_first_direction_swap:
		rotation_degrees += 45
		zigzag_timer.wait_time = zigzag_swap_time / 2
		is_first_direction_swap = false
	else:
		rotation_degrees += 90 if for_zigzag_swap else -90
		zigzag_timer.wait_time = zigzag_swap_time
	direction = -MathUtils.angle_to_vector2(rotation)
	zigzag_timer.start()
	for_zigzag_swap = !for_zigzag_swap
