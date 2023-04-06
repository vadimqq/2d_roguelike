extends Node

signal coins_amount_change

const coin = preload("res://Items/coin/coin.tscn")


#----------GLOBAL------------
const attack_speed = preload("res://Ability/Modules/AttackSpeed/AttackSpeed.tscn")
const gigantic = preload("res://Ability/Modules/Gigantic/Gigantic.tscn")
const increase_damage = preload("res://Ability/Modules/IncreaseDamage/IncreaseDamage.tscn")
const speed = preload("res://Ability/Modules/Speed/Speed.tscn")
const life_time = preload("res://Ability/Modules/LifeTime/LifeTime.tscn")

#----------------------------

#----------PROJECTILE--------
const direction_circular = preload("res://Ability/Projectile/Modules/CircularDirection/CircularDirection.tscn")
const fire_arrow = preload("res://Ability/Projectile/Modules/FireArrow/FireArrow.tscn")
const homing_detector = preload("res://Ability/Projectile/Modules/Homing/Homing.tscn")
const rebound = preload("res://Ability/Projectile/Modules/Rebound/Rebound.tscn")
const pierce = preload("res://Ability/Projectile/Modules/Pierce/Pierce.tscn")
const damage_by_speed = preload("res://Ability/Projectile/Modules/DamageBySpeed/DamageBySpeed.tscn")
const dublicator = preload("res://Ability/Modules/Dublicator/Dublicator.tscn")
#---------------------------

#----------CHARGE------------

#----------------------------

#----------CHANNEL-----------
const improved_channel = preload("res://Ability/Channel/Modules/ImprovedChannel/ImprovedChannel.tscn")
const orbital_shield = preload("res://Ability/Channel/Modules/OrbitalShield/OrbitalShield.tscn")
const cumulative_explosion = preload("res://Ability/Channel/Modules/CumulativeExplosion/CumulativeExplosion.tscn")
const lightning_whip = preload("res://Ability/Channel/Modules/LightningWhip/LightningWhip.tscn")
#----------------------------


var NORAMAL_MODULES_POOL = [speed, gigantic, life_time]
var MAGIC_MODULES_POOL = [attack_speed, increase_damage, rebound, pierce, damage_by_speed, improved_channel]
var RARE_MODULES_POOL = [direction_circular, homing_detector, orbital_shield]
var LEGENDARY_MODULES_POOL = [fire_arrow, dublicator]
var UNIC_MODULES_POOL = [fire_arrow, lightning_whip]

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


var coins_amount = 50000
var reward_choise_count = 3


func _ready():
	Events.connect("enemy_death", self, '_on_enemy_death')

func modify_coins(amount):
	coins_amount += amount
	emit_signal("coins_amount_change", coins_amount)

func get_random_module():
	return  get_random_reward_by_context(module_rarity_weights)

func get_items_on_boss_kill():
	var arr = []
	
	while arr.size() < reward_choise_count:
		var item = get_random_reward_by_context(items_rarity_weights)
		if !arr.has(item):
			arr.push_back(item)
	return arr

func _on_enemy_death(enemy):
	var reward = coin.instance()
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


func take_all_module_arr(count):
	var module_arr: Array = [
		speed.instance(),
		gigantic.instance(),
		life_time.instance(),
		attack_speed.instance(),
		increase_damage.instance(),
		direction_circular.instance(),
		fire_arrow.instance(),
		homing_detector.instance(),
		rebound.instance(),
		pierce.instance(),
		damage_by_speed.instance(),
		dublicator.instance(),
		improved_channel.instance(),
		orbital_shield.instance(),
		cumulative_explosion.instance(),
		lightning_whip.instance()
	]
	for i in range(count):
		module_arr.append_array(module_arr.duplicate())
	return module_arr
