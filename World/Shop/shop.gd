extends YSort

onready var post_list = $PostList
onready var reroll_price_label = $Shrine/Label

const _BAY_SOUND = preload("res://World/Shop/bay_sound.wav")

var player = null
var reroll_price = 5

func _ready():
	roll_items()

func _input(event):
	if player and event.is_action_pressed("action") and  LootManager.coins_amount >= reroll_price:
		roll_items()
		LootManager.modify_coins(-reroll_price)
		reroll_price =  ceil(reroll_price * 1.5)
		reroll_price_label.text = str(reroll_price)
		AudioBus.play_game_sound(_BAY_SOUND)

func roll_items():
	for post in post_list.get_children():
		randomize()
		var item  = LootManager.get_random_module().instance()
		post.initialize(item)
	
#	100% дроп одного оружия в магазине
	var weapon: Weapon = WeaponManager.get_random_weapon()
	if get_tree().current_scene.stage > 9:
		weapon.quality = Const.WEAPON_QUALITY.T10
	elif get_tree().current_scene.stage > 8:
		weapon.quality = Const.WEAPON_QUALITY.T9
	elif get_tree().current_scene.stage > 7:
		weapon.quality = Const.WEAPON_QUALITY.T8
	elif get_tree().current_scene.stage > 6:
		weapon.quality = Const.WEAPON_QUALITY.T7
	elif get_tree().current_scene.stage > 5:
		weapon.quality = Const.WEAPON_QUALITY.T6
	elif get_tree().current_scene.stage > 4:
		weapon.quality = Const.WEAPON_QUALITY.T5
	elif get_tree().current_scene.stage > 3:
		weapon.quality = Const.WEAPON_QUALITY.T4
	elif get_tree().current_scene.stage > 2:
		weapon.quality = Const.WEAPON_QUALITY.T3
	elif get_tree().current_scene.stage > 1:
		weapon.quality = Const.WEAPON_QUALITY.T2
	
	weapon.global_rotation = -45
	weapon.module_count = 2 * get_tree().current_scene.stage
	var random_post_num = int(rand_range(0, post_list.get_child_count()))
	post_list.get_child(random_post_num).initialize(weapon)

func _exit_tree():
	ObjectRegistry.unregister_all_items()


func _on_Area2D_body_entered(body):
	player = body

func _on_Area2D_body_exited(body):
	player = null
