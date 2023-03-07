extends Node2D

onready var post_list = $PostList
onready var reroll_price_label = $Shrine/Label

var player = null
var item_list = [
	LootManager.dublicate,
	LootManager.gigantic,
	LootManager.hit_echo,
	LootManager.projectile_speed,
	LootManager.attack_speed,
	LootManager.ball_lightning,
	LootManager.increase_damage,
	LootManager.fire_arrow,
	LootManager.projectile_pierce,
	LootManager.circular_direction,
	LootManager.projectile_life_time,
	LootManager.damage_by_speed
]

var reroll_price = 5

func _ready():
	roll_items()

func _input(event):
	if player and event.is_action_pressed("action") and  LootManager.coins_amount >= reroll_price:
		roll_items()
		LootManager.modify_coins(-reroll_price)
		reroll_price =  ceil(reroll_price * 1.5)
		reroll_price_label.text = str(reroll_price)


func roll_items():
	for post in post_list.get_children():
		randomize()
		var item  = item_list[randi()%item_list.size()].instance()
		post.initialize(item)
	
#	100% дроп одного оружия в магазине
	var weapon = LootManager.get_random_reward_by_context(LootManager.weapon_rarity_weights).instance()
	weapon.global_rotation = -45
	if get_tree().current_scene.stage < 3:
		weapon.module_count = 5
	else:
		weapon.module_count = 2 * get_tree().current_scene.stage
	var random_post_num = int(rand_range(0, post_list.get_child_count()))
	post_list.get_child(random_post_num).initialize(weapon)

func _exit_tree():
	ObjectRegistry.unregister_all_items()


func _on_Area2D_body_entered(body):
	player = body

func _on_Area2D_body_exited(body):
	player = null
