extends Module

func execute(projectile_pool: Array, stats) -> Array:

	for projectile in projectile_pool:
		projectile.rebound_count += 1

	return projectile_pool
