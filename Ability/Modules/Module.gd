extends Node2D
class_name Module 

onready var sprite = $Sprite

export (StreamTexture) var icon

export (float) var mana_multiplier = 1.1

export (String) var title = 'Test'
export (String) var description = 'Test description'

export (Array, Const.ABILITY_TYPE) var ability_tags
export (Const.MODULE_TYPE) var type
export (Array, Const.MODULE_TAG) var module_tags
export (Const.RARITY) var rarity


func _ready():
	name = name + String(rand_range(1, 100))

func execute(ability_pool: Array, stats) -> Array:
	if !ability_tags.has(ability_pool[0].type):
		return ability_pool
	
	match type:
		Const.MODULE_TYPE.GLOBAL:
			global_upgrade(ability_pool, stats)
		Const.MODULE_TYPE.GLOBAL:
			var ability = ability_pool[ability_pool.size() - 1]
			second_ability_upgrade(ability, stats)
	return ability_pool


func global_upgrade(ability_pool: Array, stats):
	pass

func second_ability_upgrade(ability: Ability, stats):
	pass

func get_mana_cost_after_multiplier(mana_cost):
	return mana_cost * mana_multiplier
