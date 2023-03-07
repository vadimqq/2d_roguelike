extends Node2D
class_name Module

export (StreamTexture) var icon
export (float) var mana_multiplier = 1.1
export (int) var price = 2

export (String) var title = ''
export (String) var description = ''

onready var animation = $Animation
onready var collision = $PickupZone/CollisionShape2D

func _ready():
	animation.play("idle")
	name = name + String(rand_range(1, 100))

func execute(projectile_pool: Array, stats) -> Array:
	return projectile_pool

func upgrade(weapon) -> void:
	pass

func get_mana_cost_after_multiplier(mana_cost):
	return mana_cost * mana_multiplier
