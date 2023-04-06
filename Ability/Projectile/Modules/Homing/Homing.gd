extends Module


const detector = preload("res://Ability/Projectile/Modules/Homing/Detector/Detector.tscn")

func second_ability_upgrade(ability_pool: Array, last_ability: Ability, stats):
	
	if !last_ability.unic_modules.has(title):
		var dectector_instance = detector.instance()
		dectector_instance.collision_mask = last_ability.collision_mask
		last_ability.unic_modules[title] = dectector_instance
	else:
		var node: Node2D = last_ability.unic_modules.get(title)
