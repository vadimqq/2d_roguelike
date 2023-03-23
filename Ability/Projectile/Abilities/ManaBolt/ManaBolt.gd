extends "res://Ability/Projectile/Projectile.gd"

onready var trail = $Line2D


const _AUDIO_SAMPLES = [
	preload("res://Ability/Projectile/Abilities/ManaBolt/sound/Arcane_AttackF1.wav"),
	preload("res://Ability/Projectile/Abilities/ManaBolt/sound/Arcane_AttackF2.wav"),
	preload("res://Ability/Projectile/Abilities/ManaBolt/sound/Arcane_AttackF3.wav"),
]

const _AUDIO_SAMPLES_HIT = [
	preload("res://Ability/Projectile/Abilities/ManaBolt/sound/Arcane_ImpactF1.wav"),
	preload("res://Ability/Projectile/Abilities/ManaBolt/sound/Arcane_ImpactF2.wav"),
	preload("res://Ability/Projectile/Abilities/ManaBolt/sound/Arcane_ImpactF3.wav"),
]


var point = Vector2.ZERO
export (int) var trail_length = 15

func _ready():
	trail.width *= scale_modifier

func _process(delta):
	trail.global_position = Vector2.ZERO
	trail.global_rotation = 0
	point = global_position
	trail.add_point(point)
	
	while trail.get_point_count() > trail_length:
		trail.remove_point(0)



func create_execute_effect():
	if execute_effect:
		var effect_instance = execute_effect.instance()
		effect_instance.global_position = global_position
		effect_instance.global_transform = global_transform
		effect_instance.emitting = true
		ObjectRegistry.register_effect(effect_instance)
	AudioBus.play_game_sound(_AUDIO_SAMPLES[randi() % _AUDIO_SAMPLES.size()])


func create_hit_effect():
	if hit_effect:
		var effect_instance = hit_effect.instance()
		effect_instance.global_position = global_position
		effect_instance.global_transform = global_transform
		effect_instance.emitting = true
		ObjectRegistry.register_effect(effect_instance)
	AudioBus.play_game_sound(_AUDIO_SAMPLES_HIT[randi() % _AUDIO_SAMPLES_HIT.size()])
#		CameraShake.shake(2, 0.15)
