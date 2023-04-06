extends Node2D

const shield = preload("res://Ability/Channel/Modules/OrbitalShield/ShieldSpawner/Shield/Shield.tscn")

onready var timer_one_tick = $Timer

export (float) var increase_life_time = 1
export (float) var increase_speed = 1
export (float) var increase_scale = 1
export (float) var wait_time = 3

var owner_ability: Channel

func _ready():
	owner_ability = find_parent('*')
	timer_one_tick.wait_time = wait_time
	timer_one_tick.start()

func increment():
	var shield_instance = shield.instance()
	shield_instance.executor = owner_ability.executor
	shield_instance.life_time *= increase_life_time
	shield_instance.speed *= increase_speed
	shield_instance.scale_modifier *= increase_scale
	
	ObjectRegistry.register_ability(shield_instance)
	shield_instance.hit_box.collision_layer = owner_ability.executor.attack_collision_layer
	
	timer_one_tick.start()

func _on_Timer_timeout():
	increment()
