extends Module

func execute(projectile_pool: Array, stats) -> Array:

	for projectile in projectile_pool:
		projectile.scale_modifier *= 1.1
		projectile.speed *= 0.95

	return projectile_pool
