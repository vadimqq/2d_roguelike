extends Module

func execute(projectile_pool: Array, stats) -> Array:

	for projectile in projectile_pool:
		projectile.speed *= 1.1
		projectile.scale *= 0.9

	return projectile_pool
