extends Module

var holy_beam_node = preload("res://Weapons/Modules/holy_beam/holy_beam/holy_beam.tscn")

func execute(projectile_pool: Array, stats) -> Array:
	var upgrade_dict = {
		"increase_damage": 1,
		"increase_radius": 1,
		"traveled_distance": 50,
	}
	
	var last_projectile: Projectile = projectile_pool[projectile_pool.size() - 1]
	
	if !last_projectile.unic_modules.has(title):
		last_projectile.connect('process', self, '_on_process', [last_projectile.collision_mask, stats.get_modified_damage(last_projectile.damage, Const.DamageType.HOLY)])
		last_projectile.unic_modules[title] = upgrade_dict
	else:
		last_projectile.unic_modules.get(title)["increase_damage"] += 0.1
		last_projectile.unic_modules.get(title)["increase_radius"] += 0.1
		last_projectile.unic_modules.get(title)["traveled_distance"] -= 1
	
	for projectile in projectile_pool:
		projectile.speed *= 0.9

	return projectile_pool

func _on_process(projectile, traveled_distance, collision_mask, damage):
	var info: Dictionary = projectile.unic_modules.get(title)
	if int(traveled_distance) % info["traveled_distance"] == 0:
		call_deferred('create_beam', projectile, collision_mask, damage)

func create_beam(projectile: Projectile, collision_mask, damage):
	var info: Dictionary = projectile.unic_modules.get(title)
	var holy_beam = holy_beam_node.instance()
	
	holy_beam.damage = damage * info["increase_damage"] / 3
	holy_beam.collision_mask = collision_mask
	holy_beam.global_position = projectile.global_position
	ObjectRegistry.register_projectile(holy_beam)
	holy_beam.scale *= projectile.scale_modifier * info["increase_radius"]
