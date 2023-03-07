extends "res://Enemies/Enemy.gd"


onready var animation_tree = $AnimationTree
onready var hitbox_collision = $Hitbox/CollisionShape2D
onready var preparation_color_rect = $WeaponRaycast/ColorRect
onready var dash_attack_cooldown_timer = $DashAttackCooldown
onready var dash_attack_duration_timer = $DashAttackDuration
onready var preparation_duration_timer = $PreparationDuration


export (int) var dash_damage = 10

var last_player_position = Vector2.ZERO

func _ready():
	get_upgrade_by_stage(get_tree().current_scene.stage)

func dash_attack(target, delta):
	var direction = (target - global_position).normalized() 
	var desired_velocity =  direction * stats.get_max_move_speed() * 4.5
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	velocity = move_and_slide(velocity)

func _on_Hitbox_body_entered(body):
	Events.emit_signal("damaged",body, dash_damage, Const.DamageType.PHYSIC)


func get_upgrade_by_stage(stage):
	stats.modyfy_stats({
		'hit_point': int(float(stats.hit_point) * (float(stage) / 8)),
		'mana_point': int(float(stats.mana_point) * (float(stage) / 8)),
		'mana_point_regen': int(float(stats.mana_point_regen) * (float(stage) / 8)),
		'max_move_speed': int(float(stats.max_move_speed) * (float(stage) / 20)),
		'min_move_speed': int(float(stats.min_move_speed) * (float(stage) / 20)),
		'increase_mana_point': int(float(stats.increase_mana_point) * (float(stage) / 8)),
		'increase_mana_point_regen': int(float(stats.increase_mana_point_regen) * (float(stage) / 8)),
	})
	stats.restore_all_stats()
