extends Module


func execute(projectile_pool: Array, stats) -> Array:
	var last_projectile = projectile_pool[projectile_pool.size() - 1]
	
	if last_projectile.movement_type == Const.MovementType.ZIGZAG:
		last_projectile.zigzag_swap_time *= 1.1
	else:
		last_projectile.movement_type = Const.MovementType.ZIGZAG
		
	for projectile in projectile_pool:
		projectile.speed *= 0.95

	return projectile_pool
