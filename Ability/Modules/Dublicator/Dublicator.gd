extends Module

func second_ability_upgrade(ability_pool, ability: Ability, stats):
	var new_ability:Ability = ability.duplicate()
	ability_pool.push_back(new_ability)
