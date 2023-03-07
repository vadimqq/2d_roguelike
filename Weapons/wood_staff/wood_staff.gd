extends Weapon


onready var animation = $Animation

func _ready():
	pass # Replace with function body.



func _on_Weapon_fire():
	animation.play("fire")
