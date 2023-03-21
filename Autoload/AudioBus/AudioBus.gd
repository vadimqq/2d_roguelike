extends Node

onready var stream = $AudioStreamPlayer

onready var game_sound = $GameSound
onready var menu_sound = $MenuSound
onready var music_sound = $MusicSound

var game_stream_count = 100

var music_stream_count = 1

var menu_stream_count = 1


func _ready():
	for i in range(game_stream_count):
		var audio_stream: AudioStreamPlayer = stream.duplicate()
		audio_stream.pitch_scale = 2
		game_sound.add_child(audio_stream)
	
	for i in range(music_stream_count):
		var audio_stream: AudioStreamPlayer = stream.duplicate()
		music_sound.add_child(audio_stream)
	
	for i in range(menu_stream_count):
		var audio_stream: AudioStreamPlayer = stream.duplicate()
		menu_sound.add_child(audio_stream)
	
	set_game_volume(-10)
	set_music_volume(-20)
	set_menu_volume(-20)

func play_game_sound(sound):
	for sound_stream in game_sound.get_children():
		if not sound_stream.playing:
			sound_stream.stream = sound
			sound_stream.play()
			break

func set_game_volume(value):
	for sound_stream in game_sound.get_children():
		sound_stream.volume_db = value



func play_music_sound(sound):
	for sound_stream in music_sound.get_children():
		if not sound_stream.playing:
			sound_stream.stream = sound
			sound_stream.play()
			break

func set_music_volume(value):
	for sound_stream in music_sound.get_children():
		sound_stream.volume_db = value

func stop_music_sound():
	for sound_stream in music_sound.get_children():
		sound_stream.stop()



func play_menu_sound(sound):
	for sound_stream in menu_sound.get_children():
		if not sound_stream.playing:
			sound_stream.stream = sound
			sound_stream.play()
			break

func stop_menu_sound():
	for sound_stream in menu_sound.get_children():
		sound_stream.stop()

func set_menu_volume(value):
	for sound_stream in menu_sound.get_children():
		sound_stream.volume_db = value
