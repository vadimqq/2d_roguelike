extends Module


func execute(projectile_pool: Array, stats) -> Array:

	for projectile in projectile_pool:
		projectile.lifetime *= 1.15

	return projectile_pool
