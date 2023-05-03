extends Node

#--------------------------------WEAPONS----------------------------------------------------
const mana_staff = preload("res://Weapon/ManaStaff/ManaStaff.tscn")
#const mana_beam_staff = preload("res://Weapon/ManaBeamStaff/ManaBeamStaff.tscn")
#const mana_explosion_staff = preload("res://Weapon/ManaExplosionStaff/ManaExplosionStaff.tscn")


const fire_staff = preload("res://Weapon/FireStaff/FireStaff.tscn")
#const fire_splash_staff = preload("res://Weapon/FireSplashStaff/FireSplashStaff.tscn")


const bee_staff = preload("res://Weapon/BeeStaff/BeeStaff.tscn")


#const poison_staff = preload("res://Weapon/PoisionBottleStaff/PoisionBottleStaff.tscn")





var NORAMAL_WEAPONS_POOL = [mana_staff, fire_staff]
var MAGIC_WEAPONS_POOL = [mana_staff, bee_staff]
var LEGENDARY_WEAPONS_POOL = [mana_staff]

var weapon_rarity_weights := {
	"NORAMAL_WEAPONS_POOL": 62,
	"MAGIC_WEAPONS_POOL": 30,
	"LEGENDARY_WEAPONS_POOL": 8,
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
	return random_weapon

