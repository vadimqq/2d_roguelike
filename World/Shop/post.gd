extends Node2D

onready var item_position = $Position2D
onready var label = $Label
onready var sprite = $Sprite
onready var collider = $DetectionZone/CollisionShape2D
onready var particles = $Particles2D 

const _BAY_SOUND = preload("res://World/Shop/bay_sound.wav")

var player = null
var item = null


func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("action") and player and LootManager.coins_amount >= item.price:
		player.take_item(item)
		LootManager.modify_coins(-ceil(item.price))
		label.visible = false
		sprite.visible = false
		collider.disabled = true
		player = null
		item = null
		particles.emitting = true
		AudioBus.play_game_sound(_BAY_SOUND)

func initialize(new_item):
	if item != null:
		ObjectRegistry.unregister_item(item)
	ObjectRegistry.register_item(new_item)
	new_item.collision.disabled = true
	new_item.global_position = item_position.global_position
	label.text = str(ceil(new_item.price))
	
	item = new_item
	
	label.visible = true
	sprite.visible = true
	collider.disabled = false
	player = null
	particles.emitting = true


func _on_DetectionZone_body_entered(body):
	player = body


func _on_DetectionZone_body_exited(body):
	player = null
