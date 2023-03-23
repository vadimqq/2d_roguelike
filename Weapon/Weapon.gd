extends Node2D
class_name Weapon

onready var spawn_position = $SpawnPosition
onready var cooldown_timer = $CooldownTimer
onready var sprite = $Sprite

export (StreamTexture) var icon
export (String) var title = 'Test weapon'
export (String) var description = 'Test weapon description'

export var ability_scene: PackedScene
export (int) var module_count = 5

var module_dict: Dictionary = {}

var executor
var ability_instance: Ability

enum COMBAT_STATE {
	IDLE,
	ATTACK
}

var combat_state = COMBAT_STATE.IDLE

var charging_ability:Charge = null

func initialize(player):
	executor = player
	ability_instance.executor = player

func _ready():
	name = name + String(rand_range(1, 100))
	ability_instance = ability_scene.instance()
	for i in range(module_count):
		module_dict[i] = null
	initialize(owner)

func _process(delta):
	if executor:
		global_position = executor.weapon_raycast.global_position
		global_rotation = executor.weapon_raycast.global_rotation
	
	if charging_ability:
		charging_ability.global_position = spawn_position.global_position
		charging_ability.global_rotation = spawn_position.global_rotation


func execute(raycast_rotation, projectile_mask: int) -> void:
	if not ability_instance or not executor:
		return
	var current_mana_cost = get_current_mana_cost()
	if executor.stats.current_mana_point < current_mana_cost:
		cancel()
		return
	match ability_instance.type:
		Const.ABILITY_TYPE.PROJECTILE:
			if !get_is_cooldown():
				cast_projectile_ability(ability_instance, current_mana_cost)
		Const.ABILITY_TYPE.CHANNEL:
			cast_channel_ability(ability_instance, current_mana_cost)
		Const.ABILITY_TYPE.CHARGE:
			if !get_is_cooldown() and !charging_ability:
				cast_charge_ability(ability_instance, current_mana_cost)

func cancel() -> void:
	combat_state = COMBAT_STATE.IDLE
	match ability_instance.type:
		Const.ABILITY_TYPE.PROJECTILE:
			pass
		Const.ABILITY_TYPE.CHANNEL:
			ability_instance.set_is_casting(false)
			ability_instance.disappear()
		Const.ABILITY_TYPE.CHARGE:
			if charging_ability:
				charging_ability.execute_charge()

func cast_projectile_ability(projectile_ability: Projectile, mana_cost):
	var projectile: Projectile = projectile_ability.duplicate()
	projectile.global_position = spawn_position.global_position
	var projectile_pool := [projectile]

	for i in module_dict.keys():
		if module_dict.get(i) != null:
			projectile_pool = module_dict.get(i).execute(projectile_pool, executor.stats)
	var counter = 1
	for upgraded_projectile in projectile_pool:
		upgraded_projectile.damage = executor.stats.get_modified_damage(upgraded_projectile.damage, upgraded_projectile.type)
		upgraded_projectile.global_rotation = spawn_position.global_rotation  #+ 0.03 * counter if counter%2 else global_rotation  - 0.03 * counter
		ObjectRegistry.register_ability(upgraded_projectile)
		upgraded_projectile.execute()
		counter += 1

	cooldown_timer.wait_time = projectile_pool[0].cooldown
	cooldown_timer.start()
	executor.stats.modify_current_mana_point(-mana_cost)

func cast_channel_ability(channel_ability: Channel, mana_cost):
	if not channel_ability.is_inside_tree():
		ObjectRegistry.register_ability(channel_ability)
	
	if combat_state == COMBAT_STATE.IDLE:
		channel_ability.appear()
	combat_state = COMBAT_STATE.ATTACK
	channel_ability.global_position = spawn_position.global_position
	channel_ability.global_rotation = spawn_position.global_rotation
	
	if !get_is_cooldown():
		channel_ability.set_is_casting(true)
		
		executor.stats.modify_current_mana_point(-mana_cost)
		cooldown_timer.wait_time = channel_ability.cooldown
		cooldown_timer.start()

func cast_charge_ability(charge_ability, mana_cost):
	var charge: Charge = charge_ability.duplicate()
	charge.connect("execute_charge", self, "_on_charge_execute")
	charge.connect("charge_tick", self, "_on_charge_tick", [mana_cost])
	charging_ability = charge
	ObjectRegistry.register_ability(charge)
	charge.start_charge()
	
	cooldown_timer.wait_time = charge.cooldown
	cooldown_timer.start()

func get_is_cooldown():
	return !cooldown_timer.is_stopped()

func add_module(key, module):
	module_dict[key] = module

func delete_module(key):
	module_dict.erase(key)

func get_current_mana_cost():
	var value = ability_instance.mana_cost
	for i in module_dict.keys():
		if module_dict.get(i) != null:
			value = module_dict.get(i).get_mana_cost_after_multiplier(value)
	return value

func get_current_cooldown():
	return 


func _on_charge_execute():
	charging_ability = null

func _on_charge_tick(power_percent, mana_cost):
	executor.stats.modify_current_mana_point(-mana_cost)
