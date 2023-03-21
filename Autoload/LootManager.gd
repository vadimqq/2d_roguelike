extends Node

signal coins_amount_change

const coin = preload("res://Items/coin/coin.tscn")

#--------------------------------WEAPONS----------------------------------------------------
const wood_staff = preload("res://Weapons/wood_staff/wood_staff.tscn")
const fire_wand = preload("res://Weapons/fire_wand/fire_wand.tscn")
const scythe_of_death = preload("res://Weapons/scythe_of_death/ScytheOfDeath.tscn")
const holy_staff = preload("res://Weapons/holy_staff/holy_staff.tscn")

var NORAMAL_WEAPONS_POOL = [wood_staff]
var MAGIC_WEAPONS_POOL = [fire_wand, holy_staff]
var LEGENDARY_WEAPONS_POOL = [scythe_of_death]

var weapon_rarity_weights := {
	"NORAMAL_WEAPONS_POOL": 62,
	"MAGIC_WEAPONS_POOL": 30,
	"LEGENDARY_WEAPONS_POOL": 8,
}
#-------------------------------------------------------------------------------------------

#--------------------------------MODULES----------------------------------------------------
const dublicate = preload("res://Weapons/Modules/dublicate/dublicate.tscn")
const gigantic = preload("res://Weapons/Modules/gigantic/gigantic.tscn")
const hit_echo = preload("res://Weapons/Modules/hit_echo/HitEcho.tscn")
const projectile_speed = preload("res://Weapons/Modules/increase_speed/increase_speed.tscn")
const attack_speed = preload("res://Weapons/Modules/attack_speed/attack_speed.tscn")
const ball_lightning = preload("res://Weapons/Modules/ball_lightning/ball_lightning.tscn")
const increase_damage = preload("res://Weapons/Modules/increase_damage/IncreaseDamage.tscn")
const fire_arrow = preload("res://Weapons/Modules/fire_arrow/FireArrow.tscn")
const projectile_pierce = preload("res://Weapons/Modules/projectile_pierce/ProjectilePierce.tscn")
const circular_direction = preload("res://Weapons/Modules/circular_direction/CircularDirection.tscn")
const projectile_life_time = preload("res://Weapons/Modules/projectile_life_time/ProjectileLifeTime.tscn")
const damage_by_speed = preload("res://Weapons/Modules/damage_by_speed/DamageBySpeed.tscn")
const projectile_rebound = preload("res://Weapons/Modules/projectile_rebound/ProjectileRebound.tscn")
const zigzag_direction = preload("res://Weapons/Modules/zigzag_direction/ZigzagDirection.tscn")
const holy_beam = preload("res://Weapons/Modules/holy_beam/holy_beam.tscn")

var NORAMAL_MODULES_POOL = [gigantic]
var MAGIC_MODULES_POOL = [projectile_speed, attack_speed]
var RARE_MODULES_POOL = [increase_damage, projectile_pierce]
var LEGENDARY_MODULES_POOL = [
	projectile_life_time,
	projectile_rebound
]
var UNIC_MODULES_POOL = [
	dublicate,
	hit_echo,
	ball_lightning,
	fire_arrow,
	damage_by_speed,
	zigzag_direction,
	circular_direction,
	holy_beam
]

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
