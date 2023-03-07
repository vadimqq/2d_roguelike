extends Item


func add_effect(player):
	player.stats.modyfy_stats({
		'max_dash_count': 1
	})
