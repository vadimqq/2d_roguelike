extends Module

var explosion_node = preload("res://Weapons/Modules/hit_echo/explosion/explosion.tscn")

func execute(projectile_pool: Array, stats) -> Array:
	var upgrade_dict = {
		"increase_damage": 1,
		"increase_radius": 1,
	}
	var last_projectile = projectile_pool[projectile_pool.size() - 1]
	
	if !last_projectile.unic_modules.has(title):
		last_projectile.connect('hit', self, '_on_hit', [last_projectile.collision_mask, stats.get_modified_damage(last_projectile.damage, Const.DamageType.FIRE)])
		last_projectile.unic_modules[title] = upgrade_dict
	else:
		last_projectile.unic_modules.get(title)["increase_damage"] += 0.1
		last_projectile.unic_modules.get(title)["increase_radius"] += 0.1
	
	for projectile in projectile_pool:
		projectile.damage *= 0.8
	return projectile_pool

func _on_hit(projectile, collision_mask, damage):
	call_deferred('create_explosion', projectile, collision_mask, damage)

func create_explosion(projectile, collision_mask, damage):
	var info: Dictionary = projectile.unic_modules.get(title)
	var explosion = explosion_node.instance()
	
	explosion.damage = damage * info["increase_damage"]
	explosion.global_transform = projectile.global_transform
	explosion.collision_mask = collision_mask
	ObjectRegistry.register_projectile(explosion)
	explosion.scale *= projectile.scale_modifier * info["increase_radius"]
	
