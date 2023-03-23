extends Node

#--------------------------------WEAPONS----------------------------------------------------
const mana_staff = preload("res://Weapon/ManaStaff/ManaStaff.tscn")

var NORAMAL_WEAPONS_POOL = [mana_staff]
var MAGIC_WEAPONS_POOL = [mana_staff, mana_staff]
var LEGENDARY_WEAPONS_POOL = [mana_staff]

var weapon_rarity_weights := {
	"NORAMAL_WEAPONS_POOL": 62,
	"MAGIC_WEAPONS_POOL": 30,
	"LEGENDARY_WEAPONS_POOL": 8,
}
#-------------------------------------------------------------------------------------------

#--------------------------------WEAPONS----------------------------------------------------
#---------CHANNEL------------
const mana_beam = preload("res://Ability/Channel/Abilities/ManaBeam/ManaBeam.tscn")
#----------------------------

#---------PROJECTILE---------
const mana_bolt = preload("res://Ability/Projectile/Abilities/ManaBolt/ManaBolt.tscn")
#----------------------------

#---------CHARGE-------------
const mana_explosion = preload("res://Ability/Charge/Abilities/ManaExplosion/ManaExplosion.tscn")
#----------------------------

var NORAMAL_ABILITY_POOL = [mana_bolt]
var MAGIC_ABILITY_POOL = [mana_beam]
var LEGENDARY_ABILITY_POOL = [mana_explosion]

var ability_rarity_weights := {
	"NORAMAL_ABILITY_POOL": 62,
	"MAGIC_ABILITY_POOL": 30,
	"LEGENDARY_ABILITY_POOL": 8,
}

#-------------------------------------------------------------------------------------------

func get_random_weapon():
	var current_pool
	randomize()
	var rarity_roll = randi()% 100 + 1
	for rarity in weapon_rarity_weights.keys():
		if rarity_roll <= weapon_rarity_weights[rarity]:
			current_pool = self[rarity]
			break
		else:
			rarity_roll -= weapon_rarity_weights[rarity]
	var random_weapon_scene = current_pool[randi() % current_pool.size()]
	var random_weapon: Weapon = random_weapon_scene.instance()
	random_weapon.ability_scene = get_random_ability()
	return random_weapon


func get_random_ability():
	var current_pool
	randomize()
	var rarity_roll = randi()% 100 + 1
	for rarity in ability_rarity_weights.keys():
		if rarity_roll <= ability_rarity_weights[rarity]:
			current_pool = self[rarity]
			break
		else:
			rarity_roll -= ability_rarity_weights[rarity]
	var ability = current_pool[randi() % current_pool.size()]
	return ability
