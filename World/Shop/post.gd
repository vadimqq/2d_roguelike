extends Node2D

const item_scene = preload("res://World/Shop/item.tscn")
const ITEM_CLASS = preload("res://World/Shop/item.gd")

onready var item_position = $Position2D
onready var label = $Label
onready var coin_sprite = $Sprite
onready var collider = $DetectionZone/CollisionShape2D
onready var particles = $Particles2D 
onready var description_panel = $DescriptionPanel

const _BAY_SOUND = preload("res://World/Shop/bay_sound.wav")

var player = null
var item_ui:ITEM_CLASS = null
var item = null
var price = 5

func _input(event):
	if event.is_action_pressed("action") and player and LootManager.coins_amount >= price:
		player.take_item(item)
		LootManager.modify_coins(-ceil(price))
		label.visible = false
		coin_sprite.visible = false
		collider.disabled = true
		player = null
		item = null
		particles.emitting = true
		AudioBus.play_game_sound(_BAY_SOUND)
		ObjectRegistry.unregister_item(item_ui)

func initialize(new_item):
	if item_ui != null:
		ObjectRegistry.unregister_item(item_ui)
	var item_instance:ITEM_CLASS = item_scene.instance()
	ObjectRegistry.register_item(item_instance)
	item = new_item
	item_instance.set_icon(new_item.icon)
	item_instance.global_position = item_position.global_position
	item_ui = item_instance
	
	label.text = str(price)
	label.visible = true
	coin_sprite.visible = true
	collider.disabled = false
	player = null
	particles.emitting = true
	
	description_panel.initialize(new_item)


func _on_DetectionZone_body_entered(body):
	player = body
	description_panel.visible = true


func _on_DetectionZone_body_exited(body):
	player = null
	description_panel.visible = false
