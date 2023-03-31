extends Module


func execute(ability_pool: Array, stats) -> Array:

	for ability in ability_pool:
		ability.damage *= 1.5

	return ability_pool
