extends Module

const fire_arrow = preload("res://Weapons/Modules/fire_arrow/homming_arrow/HommingArrow.tscn")

func execute(projectile_pool: Array, stats) -> Array:
	
	var last_projectile = projectile_pool[projectile_pool.size() - 1]
	if !last_projectile.unic_modules.has(title):
		last_projectile.connect('cast', self, '_on_cast', [last_projectile.collision_mask, stats.get_modified_damage(last_projectile.damage, Const.DamageType.FIRE)])
		last_projectile.unic_modules.append(title)
	else:
		last_projectile.speed *= 1.1
	
	for projectile in projectile_pool:
		projectile.speed *= 0.7

	return projectile_pool

func _on_cast(projectile, collision_mask, damage):
	call_deferred('create_fire_arrow', projectile, collision_mask, damage)

func create_fire_arrow(projectile, collision_mask, damage):
	for i in range(2):
		var fire_arrow_instance = fire_arrow.instance()
		fire_arrow_instance.global_position = projectile.global_position
		fire_arrow_instance.set_collision(collision_mask)
		fire_arrow_instance.damage = int(float(damage) / 5)
		if (i + 1)%2:
			fire_arrow_instance.global_rotation = projectile.global_rotation + 0.2 * (i + 1)
		else:
			fire_arrow_instance.global_rotation = projectile.global_rotation - 0.2 * (i + 1)
		ObjectRegistry.register_projectile(fire_arrow_instance)
