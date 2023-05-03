extends Node2D
class_name Weapon

const AFFIX_LIST_CLASS = preload("res://Autoload/AffixManager/AffixList.gd")

onready var spawn_position = $SpawnPosition
onready var cooldown_timer = $CooldownTimer
onready var sprite = $Sprite
onready var affix_ist: AFFIX_LIST_CLASS = $AffixList
onready var animation := $Animation

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

var ability_pool := []

func initialize(player):
	executor = player
	ability_instance.executor = player

func _ready():
	name = name + String(rand_range(1, 100))
	ability_instance = ability_scene.instance()
	for i in range(module_count):
		module_dict[i] = null
	initialize(owner)

func add_module_by_count(count):
	for i in range(count):
		module_dict[i + module_count] = null

func _process(delta):
	if executor:
		global_position = executor.weapon_raycast.global_position
		global_rotation = executor.weapon_raycast.global_rotation


func execute(raycast_rotation) -> void:
	if not ability_instance or not executor:
		return
	if !get_is_cooldown():
		upgrade_ability()

func upgrade_ability():
	var ability: Ability = ability_instance.duplicate()
	ability_pool = [ability]

	for i in module_dict.keys():
		if module_dict.get(i) != null:
			ability_pool = module_dict.get(i).execute(ability_instance, ability_pool, executor.stats)
	
	var current_cooldown = get_current_cooldown()
	cooldown_timer.wait_time = current_cooldown
	cooldown_timer.start()
	executor.stats.modify_current_mana_point(-ability_pool[0].mana_cost)
	if animation.has_animation('cast'):
		animation.playback_speed =  1 / current_cooldown
		animation.play('cast')
	else:
		cast_ability()

func cast_ability():
	var counter = 1
	for upgraded_ability in ability_pool:
		if upgraded_ability.trigger_type == Const.TRIGGER_TYPE.DEFAULT:
			upgraded_ability.global_position = spawn_position.global_position
			upgraded_ability.executor = executor
			upgraded_ability.damage = executor.stats.get_modified_damage(upgraded_ability.damage, upgraded_ability.damage_tag)
			if ability_pool.size() == 1:
				upgraded_ability.global_rotation = spawn_position.global_rotation
			else:
				upgraded_ability.global_rotation = spawn_position.global_rotation + 0.03 * counter if counter%2 else spawn_position.global_rotation  - 0.03 * counter
			ObjectRegistry.register_ability(upgraded_ability)
			counter += 1
	ability_pool.clear()

func get_is_cooldown():
	return !cooldown_timer.is_stopped()

func add_module(key, module):
	module_dict[key] = module

func delete_module(key):
	module_dict.erase(key)

func get_current_cooldown():
	var result = 0
	for ability in ability_pool:
		result += ability.cooldown
	return executor.stats.get_cooldown_by_modifire(result)
