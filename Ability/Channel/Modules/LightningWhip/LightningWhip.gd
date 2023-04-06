extends Module

const detection_zone = preload("res://Ability/Channel/Modules/LightningWhip/DtectionZone/DtectionZone.tscn")

func second_ability_upgrade(ability_pool: Array, last_ability: Ability, stats):
	if !last_ability.unic_modules.has(title):
		var detection_zone_instance = detection_zone.instance()
		last_ability.unic_modules[title] = detection_zone_instance
	else:
		var node: Node2D = last_ability.unic_modules.get(title)
		node.chance += 5
		node.increase_radius += 0.1
		node.increase_damage += 0.1

