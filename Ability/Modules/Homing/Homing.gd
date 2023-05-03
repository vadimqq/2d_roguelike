extends Module


const detector = preload("res://Ability/Modules/Homing/Detector/Detector.tscn")

func get_upgrade(ability_pool: Array, root_ability: Ability, current_ability: Projectile, stats):
	if !current_ability.unic_modules.has(title):
		var dectector_instance = detector.instance()
		current_ability.unic_modules[title] = dectector_instance
	else:
		var node: Node2D = current_ability.unic_modules.get(title)
