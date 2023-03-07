extends Node2D
class_name Room_node

const spawn_effect = preload("res://VFX/enemy_spawn_effect/enemy_spawn_effect.tscn")
const portal = preload("res://World/Portal/portal.tscn")

const evil_eye = preload("res://Enemies/EvilEye/EvilEye.tscn")
const clone = preload("res://Enemies/clone/clone.tscn")
const first_boss = preload("res://Enemies/Bosses/FirstBoss/FirstBoss.tscn")

onready var spawn_duration = $SpawnDuration
onready var spawn_delay_timer = $SpawnDelay

var enemy_list = [
	evil_eye,
	clone,
]

var boss_list = [
	first_boss
]

var current_boss =  null

func spawn_enemies():
	randomize()
	var spawn_position = Vector2(rand_range(-300, 300), rand_range(-300, 300))
	var random_enemy  = enemy_list[randi()%enemy_list.size()]
	var spawn_effect_instance = spawn_effect.instance()
	spawn_effect_instance.spawned_node = random_enemy
	ObjectRegistry.register_effect(spawn_effect_instance)
	spawn_effect_instance.global_position = spawn_position
	spawn_delay_timer.wait_time = rand_range(1, 3)
	spawn_delay_timer.start()

func spawn_boss():
	randomize()
	var random_boss  = boss_list[randi()%boss_list.size()]
	var spawn_effect_instance = spawn_effect.instance()
	spawn_effect_instance.spawned_node = random_boss
	ObjectRegistry.register_effect(spawn_effect_instance)
	spawn_effect_instance.global_position = Vector2.ZERO

func _on_SpawnDelay_timeout():
	if !spawn_duration.is_stopped():
		spawn_enemies()


func _on_SpawnDuration_timeout():
	spawn_boss()

func create_portal():
	var portal_instance = portal.instance()
	portal_instance.global_position = Vector2.ZERO
	call_deferred('add_child', portal_instance)
