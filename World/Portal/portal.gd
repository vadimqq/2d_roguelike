extends Area2D

onready var animation = $Animation
onready var label = $Label

func teleport():
	get_tree().current_scene.load_new_location()

func _on_Portal_body_entered(body):
	animation.play("activate")


func _on_Portal_body_exited(body):
	animation.play("idle")
