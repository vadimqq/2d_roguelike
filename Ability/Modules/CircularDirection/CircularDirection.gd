extends Module

func get_upgrade(ability_pool: Array, root_ability: Ability, current_ability: Projectile, stats):
	current_ability.movement_type = Const.PROJECTILE_TRAVEL_TYPE.CIRCULAR
	
	if current_ability.movement_type == Const.PROJECTILE_TRAVEL_TYPE.CIRCULAR:
		current_ability.radius *= 1.1
	else:
		current_ability.movement_type = Const.PROJECTILE_TRAVEL_TYPE.CIRCULAR

