extends Module

func global_upgrade(ability_pool: Array, stats):
	for ability in ability_pool:
		ability.speed *= 1.1
