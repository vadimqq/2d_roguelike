extends Node

signal coins_amount_change

const coin = preload("res://Items/coin/coin.tscn")


#----------GLOBAL------------
const attack_speed = preload("res://Ability/Modules/AttackSpeed/AttackSpeed.tscn")
#----------------------------

#----------PROJECTILE--------

#----------------------------

#----------AREA--------------

#----------------------------

#----------CHARGE------------

#----------------------------

#----------CHANNEL-----------

#----------------------------


var NORAMAL_MODULES_POOL = [attack_speed]
var MAGIC_MODULES_POOL = [attack_speed]
var RARE_MODULES_POOL = [attack_speed]
var LEGENDARY_MODULES_POOL = [attack_speed]
var UNIC_MODULES_POOL = [attack_speed]

var module_rarity_weights := {
	"NORAMAL_MODULES_POOL": 62,
	"MAGIC_MODULES_POOL": 29,
	"RARE_MODULES_POOL": 5,
	"LEGENDARY_MODULES_POOL": 3,
	"UNIC_MODULES_POOL": 1
}
#-------------------------------------------------------------------------------------------

#--------------------------------ITEMS------------------------------------------------------
const mana_potion = preload("res://Items/mana_potion/ManaPotion.tscn")
const fire_wave = preload("res://Items/fire_wave/FireWave.tscn")
const mana_regen_potion = preload("res://Items/mana_regen_potion/ManaRegenPotion.tscn")
const hardy_legs = preload("res://Items/hardy_legs/HardyLags.tscn")
const fiery_touch = preload("res://Items/fiery_touch/FieryTouch.tscn")
const divine_knowledge = preload("res://Items/divine_knowledge/DivineKnowledge.tscn")
const magic_heart = preload("res://Items/magician\'s_heart/MagicianHeart.tscn")

var NORAMAL_ITEMS_POOL = [mana_potion, mana_regen_potion]
var MAGIC_ITEMS_POOL = [fire_wave]
var RARE_ITEMS_POOL = [hardy_legs, magic_heart]
var LEGENDARY_ITEMS_POOL = [fiery_touch, divine_knowledge]

var items_rarity_weights := {
	"NORAMAL_ITEMS_POOL": 62,
	"MAGIC_ITEMS_POOL": 29,
	"RARE_ITEMS_POOL": 6,
	"LEGENDARY_ITEMS_POOL": 3,
}

#-------------------------------------------------------------------------------------------


var coins_amount = 1000
var reward_choise_count = 3


func _ready():
	Events.connect("enemy_death", self, '_on_enemy_death')

func modify_coins(amount):
	coins_amount += amount
	emit_signal("coins_amount_change", coins_amount)

func get_random_reward():
	if rand_range(0, 100) < 10:
		return  get_random_reward_by_context(module_rarity_weights)
	else:
		return coin

func get_items_on_boss_kill():
	var arr = []
	
	while arr.size() < reward_choise_count:
		var item = get_random_reward_by_context(items_rarity_weights)
		if !arr.has(item):
			arr.push_back(item)
	return arr

func _on_enemy_death(enemy):
	var reward = get_random_reward().instance()
	reward.global_position = enemy.global_position
	ObjectRegistry.register_item(reward)


func get_random_reward_by_context(dict_weight):
	var current_pool
	randomize()
	var rarity_roll = randi()% 100 + 1
	for rarity in dict_weight.keys():
		if rarity_roll <= dict_weight[rarity]:
			current_pool = self[rarity]
			break
		else:
			rarity_roll -= dict_weight[rarity]
	
	return current_pool[randi() % current_pool.size()]
