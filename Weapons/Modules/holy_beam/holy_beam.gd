extends Module

var holy_beam_node = preload("res://Weapons/Modules/holy_beam/holy_beam/holy_beam.tscn")

func execute(projectile_pool: Array, stats) -> Array:
	
	var last_projectile: Projectile = projectile_pool[projectile_pool.size() - 1]
	
	if !last_projectile.unic_modules.has(title):
		last_projectile.connect('process', self, '_on_process', [last_projectile.collision_mask, stats.get_modified_damage(last_projectile.damage, Const.DamageType.HOLY)])
		last_projectile.unic_modules.append(title)
	else:
		last_projectile.damage *= 1.1
	for projectile in projectile_pool:
		projectile.speed *= 0.7

	return projectile_pool

func _on_process(projectile, traveled_distance, collision_mask, damage):
	if traveled_distance % 50 == 0:
		call_deferred('create_beam', projectile, collision_mask, damage)

func create_beam(projectile: Projectile, collision_mask, damage):
	var holy_beam = holy_beam_node.instance()
	holy_beam.scale *= projectile.scale_modifier
	holy_beam.damage = damage / 3
	holy_beam.collision_mask = collision_mask
	holy_beam.global_position = projectile.global_position
	ObjectRegistry.register_projectile(holy_beam)
