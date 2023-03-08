extends Item


func add_effect(player):
	player.stats.modyfy_stats({
		'increase_hit_point': 5
	})
