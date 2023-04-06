extends Module

const explosion_detector = preload("res://Ability/Channel/Modules/CumulativeExplosion/ExplosionDetector/ExplosionDetector.tscn")

func second_ability_upgrade(ability_pool: Array, last_ability: Ability, stats):
	if !last_ability.unic_modules.has(title):
		var explosion_detector_instance = explosion_detector.instance()
		last_ability.unic_modules[title] = explosion_detector_instance
	else:
		var node: Node2D = last_ability.unic_modules.get(title)
	
