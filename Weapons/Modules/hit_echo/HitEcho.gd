extends Module

var explosion_node = preload("res://Weapons/Modules/hit_echo/explosion/explosion.tscn")

func execute(projectile_pool: Array, stats) -> Array:

	var last_projectile = projectile_pool[projectile_pool.size() - 1]
	last_projectile.connect('hit', self, '_on_hit', [last_projectile.collision_mask, stats.get_modified_damage(last_projectile.damage, Const.DamageType.FIRE)])
	
	for projectile in projectile_pool:
		projectile.damage *= 0.9
	return projectile_pool

func _on_hit(projectile, collision_mask, damage):
	call_deferred('create_explosion', projectile, collision_mask, damage)

func create_explosion(projectile, collision_mask, damage):
	var explosion = explosion_node.instance()
	explosion.damage = damage
	explosion.scale = projectile.scale
	explosion.global_transform = projectile.global_transform
	explosion.collision_mask = collision_mask
	ObjectRegistry.register_projectile(explosion)
