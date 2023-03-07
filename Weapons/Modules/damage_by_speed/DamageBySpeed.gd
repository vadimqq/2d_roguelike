extends Module

func execute(projectile_pool: Array, stats) -> Array:

	for projectile in projectile_pool:
		projectile.damage += projectile.speed / 100
		projectile.scale *= 0.95

	return projectile_pool
