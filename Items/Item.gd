extends Node2D
class_name Item

onready var collision = $PickupZone/CollisionShape2D
onready var animation = $Animation

export (StreamTexture) var icon
export (int) var price = 2
export (String) var title = ''
export (String) var description = ''

func _ready():
	animation.play("idle")

func add_effect(player):
	pass


func remove_effect(player):
	pass
