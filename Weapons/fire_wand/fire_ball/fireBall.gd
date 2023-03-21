extends Projectile

onready var trail = $Line2D

const _AUDIO_SAMPLES = [
	preload("res://Weapons/fire_wand/fire_ball/sound/Fire_AttackF1.wav"),
	preload("res://Weapons/fire_wand/fire_ball/sound/Fire_AttackF2.wav"),
	preload("res://Weapons/fire_wand/fire_ball/sound/Fire_AttackF3.wav"),
]
const AUDIO_HIT = preload("res://Weapons/fire_wand/fire_ball/sound/hit.wav")


var point = Vector2.ZERO
export (int) var trail_length = 10

func _ready():
	trail.width *= scale_modifier
	AudioBus.play_game_sound(_AUDIO_SAMPLES[randi() % _AUDIO_SAMPLES.size()])

func _process(delta):
	trail.global_position = Vector2.ZERO
	trail.global_rotation = 0
	point = global_position
	trail.add_point(point)
	
	while trail.get_point_count() > trail_length:
		trail.remove_point(0)


func _on_fireBall_hit(current):
	AudioBus.play_game_sound(AUDIO_HIT)
