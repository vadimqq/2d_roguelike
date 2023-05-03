extends Module


const fire_arrow = preload("res://Ability/Projectile/Modules/FireArrow/FireProjectile/FireProjectile.tscn")

func get_upgrade(ability_pool: Array, root_ability: Ability, current_ability: Ability, stats):
	var fire_arrow_instance = fire_arrow.instance()
	ability_pool.push_back(fire_arrow_instance)
