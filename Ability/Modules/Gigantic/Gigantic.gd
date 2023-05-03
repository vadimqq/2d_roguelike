extends Module

func get_upgrade(ability_pool: Array, root_ability: Ability, current_ability: Ability, stats):
	current_ability.scale_modifier *= 1.1
