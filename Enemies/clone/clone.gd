extends "res://Enemies/Enemy.gd"


onready var animation_tree = $AnimationTree
onready var weapon = weapon_raycast.get_child(0)

func _ready():
	weapon.connect("cooldown_finish", self, "_on_cooldown_finish")
	get_upgrade_by_stage(get_tree().current_scene.stage)


func _on_cooldown_finish():
	weapon_raycast.enabled = true

func get_upgrade_by_stage(stage):
	stats.modyfy_stats({
		'hit_point': int(float(stats.hit_point) * (float(stage) / 8)),
		'mana_point': int(float(stats.mana_point) * (float(stage) / 8)),
		'mana_point_regen': int(float(stats.mana_point_regen) * (float(stage) / 8)),
		'max_move_speed': int(float(stats.max_move_speed) * (float(stage) / 20)),
		'min_move_speed': int(float(stats.min_move_speed) * (float(stage) / 20)),
		'increase_mana_point': int(float(stats.increase_mana_point) * (float(stage) / 8)),
		'increase_mana_point_regen': int(float(stats.increase_mana_point_regen) * (float(stage) / 8)),
	})
	stats.restore_all_stats()
