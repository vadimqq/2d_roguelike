extends Node

onready var clue = $Clue
onready var player = $Player
onready var HUD = $UI/HUD
onready var inventory = $UI/Inventory
onready var reward_menu = $UI/RewardMenu
onready var _enemies = $Enemies

const _GAME_SAMPLES = [
	preload("res://Sounds/DavidKBD - InterstellarPack - 01 - Interstellar.ogg"),
	preload("res://Sounds/DavidKBD - InterstellarPack - 02 - Plasma Storm.ogg"),
	preload("res://Sounds/DavidKBD - InterstellarPack - 03 - Temple of Madness.ogg"),
]


var stage = 0
var current_location = null

func _ready():
	HUD.initialize(player)
	inventory.initialize(player)
	reward_menu.initialize(player)
	load_shop_location()
	remove_child(player)
	current_location.add_child(player)
	Events.connect("enemy_death", self, "_on_enemy_death")
	AudioBus.play_music_sound(_GAME_SAMPLES[randi() % _GAME_SAMPLES.size()])

func load_new_location():
	var new_location = LocationManager.get_random_location_instance()
	if current_location is Shop_room and new_location is Shop_room:
		return load_new_location()
	
	if !(current_location is Shop_room) and stage != 0 and stage%2 == 0:
		load_shop_location()
		return
	add_child(new_location)
	current_location.remove_child(player)
	new_location.add_child(player)
	remove_child(current_location)
	current_location = new_location
	
	player.global_position = Vector2.ZERO
	
	if !(new_location is Shop_room):
		stage += 1
	clue.visible = false

func load_shop_location():
	var shop = LocationManager.shop_location.instance()
	add_child(shop)
	if current_location != null:
		remove_child(current_location)
	current_location = shop
	
	player.global_position = Vector2.ZERO


func _on_enemy_death(enemy):
	enemy.call_deferred('queue_free')

func _exit_tree():
	AudioBus.stop_music_sound()
