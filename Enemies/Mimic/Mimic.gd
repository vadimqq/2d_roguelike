extends Enemy

onready var animation = $Animation

func _ready():
	animation.play("idle")

func _on_Detection_body_entered(body):
	animation.play("attack")


func _on_DetectionZone_body_exited(body):
	animation.play("idle")
