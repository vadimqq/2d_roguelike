extends Node2D
class_name Module 

onready var sprite = $Sprite
onready var particle = $Particles2D

export (StreamTexture) var icon

export (float) var mana_multiplier = 1.1

export (String) var title = 'Test'
export (String) var description = 'Test description'

export (Array, Const.ABILITY_TAGS) var ability_tags
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


func execute(root_ability: Ability, ability_pool: Array, stats) -> Array:
	var current_ability:Ability = ability_pool[ability_pool.size() - 1]
	
	if !is_compatibility(current_ability):
		return ability_pool
	current_ability.mana_cost *= mana_multiplier
	get_upgrade(ability_pool, root_ability, current_ability, stats)
	return ability_pool

func get_upgrade(ability_pool: Array, root_ability, current_ability, stats):
	pass

func is_compatibility(ability: Ability) -> bool:
	if ability_tags.has(Const.ABILITY_TAGS.ALL):
		return true
	
	for tag in ability.tags:
		if ability_tags.has(tag):
			return true
	return false
