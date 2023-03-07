extends Module

var whip_node = preload("res://Weapons/Modules/ball_lightning/whip_lightning/whip_lightning.tscn")

func execute(projectile_pool: Array, stats) -> Array:
	
	var last_projectile = projectile_pool[projectile_pool.size() - 1]
	last_projectile.connect('cast', self, '_on_cast', [last_projectile.collision_mask, last_projectile.damage])
	for projectile in projectile_pool:
		projectile.speed *= 0.7

	return projectile_pool

func _on_cast(projectile, collision_mask, damage):
	call_deferred('create_whip', projectile, collision_mask, damage)

func create_whip(projectile, collision_mask, damage):
	var whip_lightning = whip_node.instance()
	projectile.connect('process', whip_lightning, '_on_spectate')
	projectile.connect('die', whip_lightning, '_on_hit')
	whip_lightning.damage = damage / 2
	whip_lightning.collision_mask = collision_mask
	ObjectRegistry.register_projectile(whip_lightning)
