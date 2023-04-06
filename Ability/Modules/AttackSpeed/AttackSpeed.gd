extends Module

func global_upgrade(ability_pool: Array, stats):
	for ability in ability_pool:
		if ability is Charge:
			ability.max_charge_duration *= 0.95
		elif ability is Projectile:
			ability.cooldown *= 0.95
		elif ability is Channel:
			ability.cooldown *= 0.95
