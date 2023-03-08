extends Module

func execute(projectile_pool: Array, stats) -> Array:

	for projectile in projectile_pool:
		projectile.lifetime *= 0.95

	return projectile_pool

func upgrade(weapon: Weapon) -> void:
	weapon.cooldown_temp *= 0.8
