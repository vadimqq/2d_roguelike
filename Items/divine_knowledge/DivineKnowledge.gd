extends Item


func add_effect(player):
	player.stats.modyfy_stats({
		'mana_point_regen': 2
	})
