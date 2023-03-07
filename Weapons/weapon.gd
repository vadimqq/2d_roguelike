extends Node2D
class_name Weapon

export var Projectile: PackedScene
export (StreamTexture) var icon

signal fire
signal cooldown_finish

onready var cooldown_timer: Timer = $Cooldown
onready var spawn_position = $SpawnPosition
onready var collision = $PickupZone/CollisionShape2D

export (String) var title = ''
export (String) var description = ''

export (float) var cooldown = 1.0
export (int) var mana_cost = 5
export (int) var module_count = 5
export (int) var price = 2

var module_dict: Dictionary = {}
var cooldown_temp = 0



func _ready():
	name = name + String(rand_range(1, 100))
	cooldown_temp = cooldown
	for i in range(module_count):
		module_dict[i] = null

func _process(delta):
	if owner:
		global_position = owner.weapon_raycast.global_position
		global_rotation = owner.weapon_raycast.global_rotation

func _exit_tree():
	delete_effect()

func initialize_owner(new_owner):
	set_owner(new_owner)
	add_effect()
	global_position = owner.weapon_raycast.global_position
	

func add_effect():
	pass

func delete_effect():
	pass

func fire(raycast_rotation, projectile_mask: int) -> void:
	if get_is_cooldown() or not Projectile:
		return
	var current_mana_cost = get_current_mana_cost()
	if owner.stats.current_mana_point < current_mana_cost:
		return
	owner.stats.modify_current_mana_point(-current_mana_cost)
	cooldown_temp = owner.stats.get_cooldown_by_modifire(cooldown)
	emit_signal('fire')
	var projectile := Projectile.instance()
	projectile.global_position = spawn_position.global_position
	projectile.set_collision(owner.attack_collision_mask)
	
	var projectile_pool := [projectile]
	
	for i in module_dict.keys():
		if module_dict.get(i) != null:
			projectile_pool = module_dict.get(i).execute(projectile_pool, owner.stats)
			module_dict.get(i).upgrade(self)
	
	var counter = 1
	for upgraded_projectile in projectile_pool:
		upgraded_projectile.new_owner = owner
		upgraded_projectile.damage = owner.stats.get_modified_damage(upgraded_projectile.damage, upgraded_projectile.type)
		upgraded_projectile.global_rotation = spawn_position.global_rotation  + 0.03 * counter if counter%2 else spawn_position.global_rotation  - 0.03 * counter
		ObjectRegistry.register_projectile(upgraded_projectile)


		counter += 1
	cooldown_timer.wait_time = cooldown_temp
	cooldown_timer.start()
	cooldown_temp = cooldown

func get_is_cooldown():
	return !cooldown_timer.is_stopped()

func add_module(key, module):
	module_dict[key] = module

func delete_module(key):
	module_dict.erase(key)

func get_current_mana_cost():
	var value = mana_cost
	for i in module_dict.keys():
		if module_dict.get(i) != null:
			value = module_dict.get(i).get_mana_cost_after_multiplier(value)
	return value


func _on_Cooldown_timeout():
	emit_signal("cooldown_finish")
