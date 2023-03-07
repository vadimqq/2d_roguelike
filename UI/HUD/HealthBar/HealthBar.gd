extends TextureProgress

export var gradient: Gradient
export var danger_threshold := 0.3

onready var tween := $Tween
onready var anim_player := $Animation
onready var label = $Label

func initialize(player) -> void:
	player.stats.connect("stat_changed", self, "_on_Stats_stat_changed")
	max_value = player.stats.get_max_hit_point()
	value = player.stats.current_hit_point
	tint_progress = gradient.interpolate(value / max_value)
	label.text = str(player.stats.current_hit_point) + '/' + str(player.stats.get_max_hit_point())

func _on_Stats_stat_changed(stats: Stats) -> void:
	if stats.current_hit_point == value:
		return
	if tween.is_active():
		tween.stop_all()
	max_value = stats.get_max_hit_point()
	tween.interpolate_property(
		self, "value", value, stats.current_hit_point, 0.25, Tween.TRANS_ELASTIC, Tween.EASE_OUT
	)
	tween.start()
	label.text = str(stats.current_hit_point) + '/' + str(stats.get_max_hit_point())

func _on_Tween_tween_step(_object: Object, _key: NodePath, _elapsed: float, _tween_value: Object) -> void:
	pass
	var shield_ratio := value / max_value
	var gradient_color := gradient.interpolate(shield_ratio)
	tint_progress = gradient_color

	if shield_ratio <= danger_threshold:
		var anim: Animation = anim_player.get_animation("danger")
		var final_tint := gradient_color + Color(1.0, 1.0, 1.0, 0.0)
		anim.track_set_key_value(0, 0, gradient_color)
		anim.track_set_key_value(0, 1, final_tint)
		anim_player.play("danger")
