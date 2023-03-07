extends Control

const reward_panel = preload("res://UI/RewardMenu/RewardPanel.tscn")

onready var open_delay_timer = $OpenDelay
onready var reward_wrapper = $CenterContainer/HBoxContainer

var player: Player = null

func _ready():
	Events.connect("boss_death", self, '_on_open_menu')

func initialize(new_player):
	player = new_player

func open_menu():
	visible = true
	get_tree().paused = true

func close_menu():
	visible = false
	get_tree().paused = false
	get_tree().current_scene.current_location.create_portal()

func _on_open_menu():
	for node in reward_wrapper.get_children():
		reward_wrapper.remove_child(node)
	for item in LootManager.get_items_on_boss_kill():
		var reward: TextureButton = reward_panel.instance()
		var item_instance = item.instance()
		reward.connect("button_up", self, "_on_choise_reward", [item_instance])
		reward_wrapper.add_child(reward)
		reward.initialize(item_instance)
	open_delay_timer.start()

func _on_OpenDelay_timeout():
	open_menu()

func _on_choise_reward(item):
	ObjectRegistry.register_item(item)
	player.take_item(item)
	close_menu()
