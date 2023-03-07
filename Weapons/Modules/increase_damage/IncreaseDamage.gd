extends Module


func execute(projectile_pool: Array, stats) -> Array:

	for projectile in projectile_pool:
		projectile.damage *= 1.1

	return projectile_pool
