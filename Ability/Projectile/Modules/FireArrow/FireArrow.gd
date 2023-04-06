extends Module


const fire_arrow = preload("res://Ability/Projectile/Modules/FireArrow/FireProjectile/FireProjectile.tscn")

func second_ability_upgrade(ability_pool: Array, last_ability: Ability, stats):
	var upgrade_dict = {
		"arrow_count": 2,
		"increase_damage": 1,
	}

	if !last_ability.unic_modules.has(title):
		Events.connect("ability_execute", self, 'create_fire_arrow', [stats.get_modified_damage(last_ability.damage, Const.DAMAGE_TAG.FIRE)])
		last_ability.unic_modules[title] = upgrade_dict
	else:
		last_ability.unic_modules.get(title)["arrow_count"] += 1
	
	for projectile in ability_pool:
		projectile.speed *= 0.9

func create_fire_arrow(projectile, damage):
	var info: Dictionary = projectile.unic_modules.get(title)
	Events.disconnect("ability_execute", self, "create_fire_arrow")
	var counter = 0

	for i in range(info["arrow_count"]):
		var fire_arrow_instance = fire_arrow.instance()
		fire_arrow_instance.executor = projectile.executor
		fire_arrow_instance.collision_mask = projectile.collision_mask
		fire_arrow_instance.damage = int(float(damage) * info["increase_damage"] / 5)
		fire_arrow_instance.global_rotation = projectile.global_rotation + 0.15 * counter if counter%2 else projectile.global_rotation  - 0.15 * counter
		fire_arrow_instance.global_position = projectile.global_position
		ObjectRegistry.register_ability(fire_arrow_instance)
		fire_arrow_instance.execute()
		counter += 1
