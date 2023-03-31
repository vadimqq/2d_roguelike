extends Module

func execute(ability_pool: Array, stats) -> Array:

	for ability in ability_pool:
		ability.life_time *= 1.15

	return ability_pool
