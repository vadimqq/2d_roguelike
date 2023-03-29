extends TextureProgress

export var gradient: Gradient

onready var tween := $Tween
onready var anim_player := $Animation
onready var label = $Label

func initialize(player) -> void:
	player.stats.connect("stat_changed", self, "_on_Stats_stat_changed")
	max_value = player.stats.get_max_mana_point()
	value = player.stats.current_mana_point
	tint_progress = gradient.interpolate(value / max_value)
	label.text = str(player.stats.current_mana_point) + '/' + str(player.stats.get_max_mana_point())

func _on_Stats_stat_changed(stats: Stats) -> void:
	if tween.is_active():
		tween.stop_all()
	max_value = stats.get_max_mana_point()
	tween.interpolate_property(
		self, "value", value, stats.current_mana_point, 0.5, Tween.EASE_IN, Tween.EASE_OUT
	)
	tween.start()
	label.text = str(stats.current_mana_point) + '/' + str(stats.get_max_mana_point())

func _on_Tween_tween_step(_object: Object, _key: NodePath, _elapsed: float, _tween_value: Object) -> void:
	var shield_ratio := value / max_value
	var gradient_color := gradient.interpolate(shield_ratio)
	tint_progress = gradient_color
