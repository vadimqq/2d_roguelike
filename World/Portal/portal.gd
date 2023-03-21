extends Area2D

onready var animation = $Animation
onready var label = $Label

const TELPORT_SOUND = preload("res://World/Portal/teleport.wav")

func teleport():
	get_tree().current_scene.load_new_location()

func _on_Portal_body_entered(body):
	animation.play("activate")
	AudioBus.play_game_sound(TELPORT_SOUND)

func _on_Portal_body_exited(body):
	animation.play("idle")
	
