extends Module

func get_upgrade(ability_pool: Array, root_ability: Ability, current_ability: Projectile, stats):
	current_ability.rebound_count += 1
