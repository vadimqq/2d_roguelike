extends Module

const shiel_spawner = preload("res://Ability/Channel/Modules/OrbitalShield/ShieldSpawner/ShieldSpawner.tscn")

func second_ability_upgrade(ability_pool: Array, last_ability: Ability, stats):
	if !last_ability.unic_modules.has(title):
		var shiel_spawner_instance = shiel_spawner.instance()
		last_ability.unic_modules[title] = shiel_spawner_instance
	else:
		var node: Node2D = last_ability.unic_modules.get(title)
		node.increase_life_time += 0.3
		node.increase_speed += 0.25
		node.increase_scale += 0.2
		node.wait_time *= 0.9
		
