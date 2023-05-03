extends Area2D

onready var collider = $CollisionShape2D

var temp_direction = Vector2.ZERO

export (float) var drag_factor := 0.025

var _target: Enemy
var owner_ability: Projectile

func _ready():
	owner_ability = find_parent('*')
	collision_mask = owner_ability.collision_mask

func _process(delta):
	if _target and is_instance_valid(_target):
		owner_ability.is_homing = true
		temp_direction = owner_ability.global_position.direction_to(_target.global_position)
		var desired_velocity = temp_direction
		var change = (desired_velocity - owner_ability.direction) * drag_factor
		owner_ability.direction += change
		owner_ability.look_at(owner_ability.global_position + owner_ability.direction)
	else:
		owner_ability.is_homing = false
		collider.set_deferred('disabled', false)


func _on_Detector_body_entered(body):
	if _target != null and is_instance_valid(_target):
		return
	if body is Enemy:
		_target = body
		collider.set_deferred('disabled', true)
		owner_ability.movement_type =  Const.PROJECTILE_TRAVEL_TYPE.LINE
		

