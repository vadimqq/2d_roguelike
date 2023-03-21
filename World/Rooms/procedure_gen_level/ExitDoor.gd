extends Area2D

onready var animation = $Animation

signal leaving_level

func _ready():
	animation.play("idle")

func _on_ExitDoor_body_entered(body):
	emit_signal("leaving_level")
