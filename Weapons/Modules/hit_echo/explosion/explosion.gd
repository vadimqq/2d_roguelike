extends Area2D

var damage = 0

onready var animation = $Animation

func _ready():
	animation.play("explosion")


func _on_Explosion_body_entered(body):
	Events.emit_signal("damaged",body, damage, Const.DamageType.FIRE)
