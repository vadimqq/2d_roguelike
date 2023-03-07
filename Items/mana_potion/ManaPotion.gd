extends Item

func add_effect(player):
	Events.connect("enemy_death", self, "_on_enemy_death", [player.stats])

func _on_enemy_death(enemy, stats: Stats):
	stats.modyfy_stats({
		'increase_mana_point': 2
	})
