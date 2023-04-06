extends Control

onready var health_bar: TextureProgress = $HealthBar

func initialize(enemy) -> void:
	enemy.stats.connect("stat_changed", self, "_on_Stats_stat_changed")
	health_bar.max_value = enemy.stats.get_max_hit_point()
	health_bar.value = enemy.stats.current_hit_point

func _on_Stats_stat_changed(stats: Stats) -> void:
	health_bar.max_value = stats.get_max_hit_point()
	health_bar.value = stats.current_hit_point
