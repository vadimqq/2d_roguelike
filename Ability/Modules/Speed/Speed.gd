extends Module

func execute(ability_pool: Array, stats) -> Array:

	for ability in ability_pool:
		ability.speed *= 1.1

	return ability_pool
