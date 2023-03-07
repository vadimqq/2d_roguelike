extends Module


func execute(projectile_pool: Array, stats) -> Array:
	var last_projectile = projectile_pool[projectile_pool.size() - 1]
	last_projectile.movement_type = Const.MovementType.CIRCULAR
	
	for projectile in projectile_pool:
		projectile.speed *= 0.95

	return projectile_pool
