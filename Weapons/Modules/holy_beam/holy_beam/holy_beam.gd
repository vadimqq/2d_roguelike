extends Area2D

onready var animation = $Animation

var damage = 0

func _ready():
	set_as_toplevel(true)
	animation.play("cast")


func _on_HolyBeam_body_entered(body):
	Events.emit_signal("damaged",body, damage, Const.DamageType.HOLY)
