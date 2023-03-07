extends Node


var shake_intensity = 0.0
var shake_duration = 0.0
var shake_type = Type.Random

enum Type {
	Random,
	Sine,
	Noise
}

var noise : OpenSimplexNoise

func _ready():
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20
	noise.persistence = 0.8


func shake(intensity, duration, type = Type.Random):
	if intensity > shake_intensity && duration > shake_duration:
		shake_intensity = intensity
		shake_duration = duration
		shake_type = type

func _process(delta):
#	var camera = get_tree().current_scene.camera
	if shake_duration <= 0:
#		camera.offset = Vector2.ZERO
		shake_intensity = 0.0
		shake_duration = 0.0
		return

	shake_duration = shake_duration - delta

	var offset = Vector2.ZERO

	match shake_type:
		Type.Random:
			offset = Vector2(randf(), randf()) * shake_intensity
		Type.Sine:
			offset = Vector2(sin(OS.get_ticks_msec() * 0.03), sin(OS.get_ticks_msec() * 0.07)) * shake_intensity * 0.5
		Type.Noise:
			var x = noise.get_noise_1d(OS.get_ticks_msec() * 0.1)
			var y = noise.get_noise_1d(OS.get_ticks_msec() * 0.1 + 100.0)
			offset = Vector2(x, y) * shake_intensity * 2.0

#	camera.offset = offset
