extends Node2D

onready var item_position = $Position2D
onready var label = $Label
onready var coin_sprite = $Sprite
onready var collider = $DetectionZone/CollisionShape2D
onready var particles = $Particles2D 
onready var description_panel = $CanvasLayer/DescriptionPanel

const _BAY_SOUND = preload("res://World/Shop/bay_sound.wav")

var player = null
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

func initialize(new_item):
	if item != null:
		ObjectRegistry.unregister_item(item)
	ObjectRegistry.register_item(new_item)
	item = new_item
	item.global_position = item_position.global_position
	if item is Weapon:
		AffixManager.get_affix(item.quality, item.affix_ist)
	label.text = str(price)
	label.visible = true
	coin_sprite.visible = true
	collider.disabled = false
	player = null
	particles.emitting = true


func _on_DetectionZone_body_entered(body):
	player = body
	description_panel.visible = true
	description_panel.initialize(item)
	description_panel.rect_global_position = global_position - Vector2(description_panel.rect_min_size.x / 2, description_panel.rect_min_size.y + 160) * description_panel.rect_scale


func _on_DetectionZone_body_exited(body):
	player = null
	description_panel.visible = false
