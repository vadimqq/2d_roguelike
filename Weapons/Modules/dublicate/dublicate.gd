extends Module

func execute(projectile_pool: Array, stats) -> Array:
	var last_projectile = projectile_pool[projectile_pool.size() - 1]
	var new_projectile = last_projectile.duplicate()
	new_projectile.set_collision(last_projectile.collision_mask)
	projectile_pool.push_back(new_projectile)
	
	for projectile in projectile_pool:
		projectile.lifetime *= 0.7

	return projectile_pool
