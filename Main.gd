extends Node

onready var clue = $Clue
onready var player = $Player
onready var HUD = $UI/HUD
onready var inventory = $UI/Inventory
onready var reward_menu = $UI/RewardMenu
onready var _enemies = $Enemies

var stage = 0
var current_location = null

func _ready():
	HUD.initialize(player)
	inventory.initialize(player)
	reward_menu.initialize(player)
	load_shop_location()
	Events.connect("enemy_death", self, "_on_enemy_death")

func load_new_location():
	var new_location = LocationManager.get_random_location_instance()
	if current_location is Shop_room and new_location is Shop_room:
		return load_new_location()
	
	add_child(new_location)
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
