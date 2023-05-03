extends Module

func get_upgrade(ability_pool: Array, root_ability: Ability, current_ability: Ability, stats):
	var new_ability:Ability = root_ability.duplicate()
	ability_pool.push_back(new_ability)
