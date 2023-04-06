extends Module

const incrementor = preload("res://Ability/Channel/Modules/ImprovedChannel/Incrementor/Incrementor.tscn")

func second_ability_upgrade(ability_pool: Array, last_ability: Ability, stats):
	if !last_ability.unic_modules.has(title):
		var incrementor_instance = incrementor.instance()
		last_ability.unic_modules[title] = incrementor_instance
	else:
		var node: Node2D = last_ability.unic_modules.get(title)
		node.mana_cost_incrementor += 0.1
		node.damage_incrementor += 0.1
