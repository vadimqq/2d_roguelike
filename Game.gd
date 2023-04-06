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


var stage = 1
var current_location = null

func _ready():
	HUD.initialize(player)
	inventory.initialize(player)
	reward_menu.initialize(player)
	load_shop_location()
	remove_child(player)
	current_location.add_child(player)
	AudioBus.play_music_sound(_GAME_SAMPLES[randi() % _GAME_SAMPLES.size()])

func load_new_location():
	var new_location = LocationManager.get_random_location_instance()
	if !(current_location is Shop_room) and stage != 0 and stage%2 == 0:
		load_shop_location()
		return
	stage += 1
	new_location.stage = stage
	load_location(new_location)

	clue.visible = false

func load_shop_location():
	var shop = LocationManager.get_shop_location_instance()
	load_location(shop)

func load_location(location):
	add_child(location)
	if current_location:
		current_location.remove_child(player)
		remove_child(current_location)
	location.add_child(player)
#	for weapon in player.weapon_inventory_arr:
#		weapon.add_module_by_count(2)
#	var current_weapon: Weapon = player.get_current_weapon()
#	if current_weapon:
#		current_weapon.add_module_by_count(2)
	current_location = location
	
	player.global_position = Vector2.ZERO


func _exit_tree():
	AudioBus.stop_music_sound()
