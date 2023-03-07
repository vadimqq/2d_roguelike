extends "res://Enemies/Enemy.gd"

const fire_ball = preload("res://Enemies/Bosses/FirstBoss/FireBall.tscn")
const evil_eye = preload("res://Enemies/EvilEye/EvilEye.tscn")
const spawn_effect = preload("res://VFX/enemy_spawn_effect/enemy_spawn_effect.tscn")

onready var attack_1_timer = $Attack_1
onready var attack_2_timer = $Attack_2
onready var attack_3_timer = $Attack_3
onready var attack_spawn_position = $Sprite/AttackSpawnPosition
onready var fire_laser = $Sprite/AttackSpawnPosition/FireLaser
onready var tween = $Sprite/AttackSpawnPosition/Tween


var projectile_count = 12
var laser_radius = 360
var enemy_spawn_count = 2

func _ready():
		get_upgrade_by_stage(get_tree().current_scene.stage)

func cast_attack_1():
	randomize()
	fire_laser.is_casting = true
	tween.interpolate_property(fire_laser, "rotation_degrees", 0, laser_radius, 5.9)
	tween.start()

func cast_attack_2():
	var deg = 360 / projectile_count
	for i in range(projectile_count):
		var projectile = fire_ball.instance()
		projectile.global_position = attack_spawn_position.global_position
		projectile.set_collision(attack_collision_mask)
		projectile.rotation_degrees = i * deg
		ObjectRegistry.register_projectile(projectile)

func cast_attack_3():

	var spawn_position = global_position
	
	for i in range(enemy_spawn_count):
		var spawn_effect_instance = spawn_effect.instance()
		spawn_effect_instance.spawned_node = evil_eye
		ObjectRegistry.register_effect(spawn_effect_instance)
		spawn_effect_instance.global_position = get_circle_position(float(i) / 10)

func get_circle_position(random):
	var kill_circle_centre = global_position
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * 50;
	var y = kill_circle_centre.y + sin(angle) * 50;
	return Vector2(x, y)


func _on_Tween_tween_completed(object, key):
	if object == fire_laser:
		fire_laser.is_casting = false

func get_upgrade_by_stage(stage):
	stats.modyfy_stats({
		'hit_point': int(float(stats.hit_point) * (float(stage) / 10)),
		'mana_point': int(float(stats.mana_point) * (float(stage) / 10)),
		'mana_point_regen': int(float(stats.mana_point_regen) * (float(stage) / 10)),
		'max_move_speed': int(float(stats.max_move_speed) * (float(stage) / 20)),
		'min_move_speed': int(float(stats.min_move_speed) * (float(stage) / 20)),
		'increase_mana_point': int(float(stats.increase_mana_point) * (float(stage) / 10)),
		'increase_mana_point_regen': int(float(stats.increase_mana_point_regen) * (float(stage) / 10)),
	})
	stats.restore_all_stats()
	
	projectile_count += int(float(projectile_count) * (float(stage) / 10))
	laser_radius  += int(float(laser_radius) * (float(stage) / 10))
	enemy_spawn_count += int(float(enemy_spawn_count) * (float(stage) / 10))
