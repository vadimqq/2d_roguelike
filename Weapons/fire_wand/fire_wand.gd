extends Weapon


func add_effect():
	if owner:
		owner.stats.modyfy_stats({
			'increase_fire_damage': 20
		})
	
func delete_effect():
	if owner:
		owner.stats.modyfy_stats({
			'increase_fire_damage': -20
		})

