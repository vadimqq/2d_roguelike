extends Ability
class_name Projectile

onready var hit_box = $HitBox
onready var hit_box_collider = $HitBox/CollisionShape2D
onready var sprite = $Sprite

export var execute_effect: PackedScene
export var hit_effect: PackedScene

export (float) var speed := 100.0

#UNIC MECHANICS
export (int) var pierce_count = 0
export (int) var rebound_count = 0

export (Const.PROJECTILE_TRAVEL_TYPE) var movement_type = Const.PROJECTILE_TRAVEL_TYPE.LINE
export (float) var radius := 40.0
export (float) var zigzag_swap_time = 0.2
#==============

var traveled_distance = 0
var direction = Vector2.ZERO
var d := 0.0
var for_zigzag_swap = true
var is_first_direction_swap = true

func _ready():
	hit_box.collision_mask = collision_mask
	rotation_degrees += 90
	direction = -MathUtils.angle_to_vector2(global_rotation)

func _physics_process(delta: float) -> void:
	match movement_type:
		Const.PROJECTILE_TRAVEL_TYPE.LINE:
			travel_line(delta)
		Const.PROJECTILE_TRAVEL_TYPE.CIRCULAR:
			travel_circular(delta)
		Const.PROJECTILE_TRAVEL_TYPE.ZIGZAG:
			travel_zigzag(delta)
	
	traveled_distance += speed * delta


func travel_line(delta):
	position += direction * speed * delta

func travel_zigzag(delta):
	position += direction * speed * delta

func travel_circular(delta):
	d -= delta
	position = Vector2(
		sin(d * speed / 100) * radius,
		cos(d * speed / 100) * radius
	) + executor.global_position
	look_at(executor.global_position)


func _on_HitBox_body_entered(body):
	Events.emit_signal("ability_hit", self)
	Events.emit_signal("damaged",body, damage, damage_tag)
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
