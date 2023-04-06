extends Module

func execute(projectile_pool: Array, stats) -> Array:
	var last_projectile = projectile_pool[projectile_pool.size() - 1]
	last_projectile.movement_type = Const.PROJECTILE_TRAVEL_TYPE.CIRCULAR
	
	if last_projectile.movement_type == Const.PROJECTILE_TRAVEL_TYPE.CIRCULAR:
		last_projectile.radius *= 1.1
	else:
		last_projectile.movement_type = Const.PROJECTILE_TRAVEL_TYPE.CIRCULAR
	for projectile in projectile_pool:
		projectile.speed *= 0.95

	return projectile_pool
