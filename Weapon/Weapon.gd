extends Node2D
class_name Weapon

const AFFIX_LIST_CLASS = preload("res://Autoload/AffixManager/AffixList.gd")

onready var spawn_position = $SpawnPosition
onready var cooldown_timer = $CooldownTimer
onready var sprite = $Sprite
onready var affix_ist: AFFIX_LIST_CLASS = $AffixList

export (StreamTexture) var icon
export (String) var title = 'Test weapon'
export (String) var description = 'Test weapon description'

export var ability_scene: PackedScene
export (int) var module_count = 5
export (Const.WEAPON_QUALITY) var quality
var module_dict: Dictionary = {}


var executor
var ability_instance: Ability

enum COMBAT_STATE {
	IDLE,
	ATTACK
}

var combat_state = COMBAT_STATE.IDLE

var charging_ability_list: Array = []

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
	
	if charging_ability_list.size() > 0:
		for charge in charging_ability_list:
			charge.global_position = spawn_position.global_position
			charge.global_rotation = spawn_position.global_rotation


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
			if !get_is_cooldown() and !charging_ability_list.size() > 0:
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
			if charging_ability_list.size() > 0:
				for charge in charging_ability_list:
					charge.execute_charge()

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
		upgraded_projectile.global_rotation = spawn_position.global_rotation + 0.03 * counter if counter%2 else spawn_position.global_rotation  - 0.03 * counter
		ObjectRegistry.register_ability(upgraded_projectile)
		upgraded_projectile.execute()
		counter += 1

	cooldown_timer.wait_time = projectile_pool[0].cooldown
	cooldown_timer.start()
	executor.stats.modify_current_mana_point(-mana_cost)

func cast_channel_ability(channel_ability: Channel, mana_cost):
	if not channel_ability.is_inside_tree():
		ObjectRegistry.register_ability(channel_ability)
	
	var channel_pool := [channel_ability]

	for i in module_dict.keys():
		if module_dict.get(i) != null:
			channel_pool = module_dict.get(i).execute(channel_pool, executor.stats)
	
	if combat_state == COMBAT_STATE.IDLE:
		for channel in channel_pool:
			channel.appear()
	combat_state = COMBAT_STATE.ATTACK
	for channel in channel_pool:
		channel.global_position = spawn_position.global_position
		channel.global_rotation = spawn_position.global_rotation
	
	if !get_is_cooldown():
		channel_ability.set_is_casting(true)
		
		executor.stats.modify_current_mana_point(-mana_cost)
		cooldown_timer.wait_time = channel_ability.cooldown
		cooldown_timer.start()

func cast_charge_ability(charge_ability, mana_cost):
	var charge: Charge = charge_ability.duplicate()
	charge.connect("execute_charge", self, "_on_charge_execute")
	charge.connect("charge_tick", self, "_on_charge_tick", [mana_cost])
	charging_ability_list = [charge]

	for i in module_dict.keys():
		if module_dict.get(i) != null:
			charging_ability_list = module_dict.get(i).execute(charging_ability_list, executor.stats)
	
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
	charging_ability_list = []

func _on_charge_tick(power_percent, mana_cost):
	executor.stats.modify_current_mana_point(-mana_cost)

