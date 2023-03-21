extends Module

var whip_node = preload("res://Weapons/Modules/ball_lightning/whip_lightning/whip_lightning.tscn")

func execute(projectile_pool: Array, stats) -> Array:
	var upgrade_dict = {
		"increase_damage": 1,
	}
	
	var last_projectile: Projectile = projectile_pool[projectile_pool.size() - 1]
	
	if !last_projectile.unic_modules.has(title):
		last_projectile.connect('cast', self, '_on_cast', [last_projectile.collision_mask, stats.get_modified_damage(last_projectile.damage, Const.DamageType.LIGTHNING)])
		last_projectile.unic_modules[title] = upgrade_dict
	else:
		last_projectile.unic_modules.get(title)["increase_damage"] += 0.1
	
	for projectile in projectile_pool:
		projectile.speed *= 0.8

	return projectile_pool

func _on_cast(projectile, collision_mask, damage):
	call_deferred('create_whip', projectile, collision_mask, damage)

func create_whip(projectile, collision_mask, damage):
	var info: Dictionary = projectile.unic_modules.get(title)
	var whip_lightning = whip_node.instance()
	
	projectile.connect('process', whip_lightning, '_on_spectate')
	projectile.connect('die', whip_lightning, '_on_hit')
	whip_lightning.damage = damage * info["increase_damage"] / 2
	whip_lightning.collision_mask = collision_mask
	ObjectRegistry.register_projectile(whip_lightning)
