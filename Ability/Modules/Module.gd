extends Node2D
class_name Module 

onready var sprite = $Sprite
onready var particle = $Particles2D

export (StreamTexture) var icon

export (float) var mana_multiplier = 1.1

export (String) var title = 'Test'
export (String) var description = 'Test description'

export (Array, Const.ABILITY_TYPE) var ability_tags
export (Const.MODULE_TYPE) var type
export (Array, Const.MODULE_TAG) var module_tags
export (Const.RARITY) var rarity

const common_color = Color(1, 1, 1, 1)
const magic_color = Color(0, 0.62, 1, 1)
const rare_color = Color(0.99, 0.95, 0, 1)
const legendary_color = Color(1, 0.36, 0.01, 1)
const unic_color = Color(1, 0.04, 0.69, 1)



func _ready():
	name = name + String(rand_range(1, 100))
	match rarity:
		Const.RARITY.COMMON:
			particle.modulate = common_color
		Const.RARITY.MAGIC:
			particle.modulate = magic_color
		Const.RARITY.RARE:
			particle.modulate = rare_color
		Const.RARITY.LEGENDARY:
			particle.modulate = legendary_color
		Const.RARITY.UNIC:
			particle.modulate = unic_color


func execute(ability_pool: Array, stats) -> Array:
	if !ability_tags.has(ability_pool[0].type):
		return ability_pool
	var first_ability: Ability = ability_pool[0]
	first_ability.mana_cost *= mana_multiplier
	
	match type:
		Const.MODULE_TYPE.GLOBAL:
			global_upgrade(ability_pool, stats)
		Const.MODULE_TYPE.SECOND_ABILITY:
			var last_ability = ability_pool[ability_pool.size() - 1]
			second_ability_upgrade(ability_pool, last_ability, stats)
	
	return ability_pool


func global_upgrade(ability_pool: Array, stats):
	pass

func second_ability_upgrade(ability_pool: Array, last_ability: Ability, stats):
	pass
