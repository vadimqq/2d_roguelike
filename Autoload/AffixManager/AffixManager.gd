extends Node

const AFFIX_ITEM_CLASS = preload("res://Autoload/AffixManager/AfFixItem.gd")
const affix_item_scene = preload("res://Autoload/AffixManager/AffixItem.tscn")
const AFFIX_LIST_CLASS = preload("res://Autoload/AffixManager/AffixList.gd")


enum AFFIX_TIER {
	T1,
	T2,
	T3,
	T4
}


# -----------------------------------SUFFIX-------------------------------------
const increase_hit_point_id = "increase_hit_point"
const increase_hit_point_title = "Health"
var increase_hit_point_tier: Dictionary = {
	AFFIX_TIER.T1: {"id": increase_hit_point_id, "title": increase_hit_point_title, "tier": 1, "min": 1, "max": 10},
	AFFIX_TIER.T2: {"id": increase_hit_point_id, "title": increase_hit_point_title, "tier": 2, "min": 10, "max": 20},
	AFFIX_TIER.T3: {"id": increase_hit_point_id, "title": increase_hit_point_title, "tier": 3, "min": 20, "max": 30},
	AFFIX_TIER.T4: {"id": increase_hit_point_id, "title": increase_hit_point_title, "tier": 4, "min": 30, "max": 40},
}


const increase_hit_point_regen_id = "increase_hit_point_regen"
const increase_hit_point_regen_title = "Health regeneration"
var increase_hit_point_regen_tier: Dictionary = {
	AFFIX_TIER.T1: {"id": increase_hit_point_regen_id, "title": increase_hit_point_regen_title, "tier": 1, "min": 1, "max": 10},
	AFFIX_TIER.T2: {"id": increase_hit_point_regen_id, "title": increase_hit_point_regen_title, "tier": 2, "min": 10, "max": 20},
	AFFIX_TIER.T3: {"id": increase_hit_point_regen_id, "title": increase_hit_point_regen_title, "tier": 3, "min": 20, "max": 30},
	AFFIX_TIER.T4: {"id": increase_hit_point_regen_id, "title": increase_hit_point_regen_title, "tier": 4, "min": 30, "max": 40},
}

const increase_mana_point_id = "increase_mana_point"
const increase_mana_point_title = "Mana"
var increase_mana_point_tier: Dictionary = {
	AFFIX_TIER.T1: {"id": increase_mana_point_id, "title": increase_mana_point_title, "tier": 1, "min": 1, "max": 10},
	AFFIX_TIER.T2: {"id": increase_mana_point_id, "title": increase_mana_point_title, "tier": 2, "min": 10, "max": 20},
	AFFIX_TIER.T3: {"id": increase_mana_point_id, "title": increase_mana_point_title, "tier": 3, "min": 20, "max": 30},
	AFFIX_TIER.T4: {"id": increase_mana_point_id, "title": increase_mana_point_title, "tier": 4, "min": 30, "max": 40},
}

const increase_mana_point_regen_id = "increase_mana_point_regen"
const increase_mana_point_regen_title = "Mana regen"
var increase_mana_point_regen_tier: Dictionary = {
	AFFIX_TIER.T1: {"id": increase_mana_point_regen_id, "title": increase_mana_point_regen_title, "tier": 1, "min": 1, "max": 10},
	AFFIX_TIER.T2: {"id": increase_mana_point_regen_id, "title": increase_mana_point_regen_title, "tier": 2, "min": 10, "max": 20},
	AFFIX_TIER.T3: {"id": increase_mana_point_regen_id, "title": increase_mana_point_regen_title, "tier": 3, "min": 20, "max": 30},
	AFFIX_TIER.T4: {"id": increase_mana_point_regen_id, "title": increase_mana_point_regen_title, "tier": 4, "min": 30, "max": 40},
}



const SUFFIX = "_SUFFIX"
var NORMAL_SUFFIX = [
	increase_hit_point_tier[AFFIX_TIER.T1],
	increase_hit_point_regen_tier[AFFIX_TIER.T1],
	increase_mana_point_tier[AFFIX_TIER.T1],
	increase_mana_point_regen_tier[AFFIX_TIER.T1]
]
var MAGIC_SUFFIX = [
	increase_hit_point_tier[AFFIX_TIER.T2],
	increase_hit_point_regen_tier[AFFIX_TIER.T2],
	increase_mana_point_tier[AFFIX_TIER.T2],
	increase_mana_point_regen_tier[AFFIX_TIER.T2]
]
var RARE_SUFFIX = [
	increase_hit_point_tier[AFFIX_TIER.T3],
	increase_hit_point_regen_tier[AFFIX_TIER.T3],
	increase_mana_point_tier[AFFIX_TIER.T3],
	increase_mana_point_regen_tier[AFFIX_TIER.T3]
]
var LEGENDARY_SUFFIX = [
	increase_hit_point_tier[AFFIX_TIER.T4],
	increase_hit_point_regen_tier[AFFIX_TIER.T4],
	increase_mana_point_tier[AFFIX_TIER.T4],
	increase_mana_point_regen_tier[AFFIX_TIER.T4]
]
# ------------------------------------------------------------------------------


# ------------------------------------PREFIX------------------------------------
const increase_mana_damage_id = "increase_mana_damage"
const increase_mana_damage_title = "Mana damage"
var increase_mana_damage_tier: Dictionary = {
	AFFIX_TIER.T1: {"id": increase_mana_damage_id, "title": increase_mana_damage_title, "tier": 1, "min": 1, "max": 10},
	AFFIX_TIER.T2: {"id": increase_mana_damage_id, "title": increase_mana_damage_title, "tier": 2, "min": 10, "max": 20},
	AFFIX_TIER.T3: {"id": increase_mana_damage_id, "title": increase_mana_damage_title, "tier": 3, "min": 20, "max": 30},
	AFFIX_TIER.T4: {"id": increase_mana_damage_id, "title": increase_mana_damage_title, "tier": 4, "min": 30, "max": 40},
}


const increase_fire_damage_id = "increase_fire_damage"
const increase_fire_damage_title = "Fire damage"
var increase_fire_damage_tier: Dictionary = {
	AFFIX_TIER.T1: {"id": increase_fire_damage_id, "title": increase_fire_damage_title, "tier": 1, "min": 1, "max": 10},
	AFFIX_TIER.T2: {"id": increase_fire_damage_id, "title": increase_fire_damage_title, "tier": 2, "min": 10, "max": 20},
	AFFIX_TIER.T3: {"id": increase_fire_damage_id, "title": increase_fire_damage_title, "tier": 3, "min": 20, "max": 30},
	AFFIX_TIER.T4: {"id": increase_fire_damage_id, "title": increase_fire_damage_title, "tier": 4, "min": 30, "max": 40},
}

const increase_attack_speed_id = "increase_attack_speed"
const increase_attack_speed_title = "Action speed"
var increase_attack_speed_tier: Dictionary = {
	AFFIX_TIER.T1: {"id": increase_attack_speed_id, "title": increase_attack_speed_title, "tier": 1, "min": 1, "max": 10},
	AFFIX_TIER.T2: {"id": increase_attack_speed_id, "title": increase_attack_speed_title, "tier": 2, "min": 10, "max": 20},
	AFFIX_TIER.T3: {"id": increase_attack_speed_id, "title": increase_attack_speed_title, "tier": 3, "min": 20, "max": 30},
	AFFIX_TIER.T4: {"id": increase_attack_speed_id, "title": increase_attack_speed_title, "tier": 4, "min": 30, "max": 40},
}

const increase_poision_damage = "increase_poision_damage"
const increase_holy_damage = "increase_holy_damage"
const increase_shadow_damage = "increase_shadow_damage"
const increase_ligthning_damage = "increase_ligthning_damage"
const increase_physic_damage = "increase_physic_damage"


const PREFIX = "_PREFIX"
var NORMAL_PREFIX = [
	increase_mana_damage_tier[AFFIX_TIER.T1],
	increase_fire_damage_tier[AFFIX_TIER.T1],
	increase_attack_speed_tier[AFFIX_TIER.T1]
]
var MAGIC_PREFIX = [
	increase_mana_damage_tier[AFFIX_TIER.T2],
	increase_fire_damage_tier[AFFIX_TIER.T2],
	increase_attack_speed_tier[AFFIX_TIER.T2]
]
var RARE_PREFIX = [
	increase_mana_damage_tier[AFFIX_TIER.T3],
	increase_fire_damage_tier[AFFIX_TIER.T3],
	increase_attack_speed_tier[AFFIX_TIER.T3]
]
var LEGENDARY_PREFIX = [
	increase_mana_damage_tier[AFFIX_TIER.T4],
	increase_fire_damage_tier[AFFIX_TIER.T4],
	increase_attack_speed_tier[AFFIX_TIER.T4]
]
# ------------------------------------------------------------------------------


func get_affix(weapon_quality: int, affix_list: AFFIX_LIST_CLASS):
	var affix_count = get_affix_count_by_quality(weapon_quality)
	fill_affixes_node(affix_list, weapon_quality, affix_count)

func fill_affixes_node(affixes: AFFIX_LIST_CLASS, weapon_quality, affix_count):
	if affix_count == 0:
		return
	randomize()
	if randi()% 100 + 1 > 50 or affixes.suffix_list.get_child_count() == 2:
		var new_prefix = get_random_prefix(weapon_quality)
		if affixes.add_new_prefix(new_prefix):
			return fill_affixes_node(affixes, weapon_quality, affix_count - 1)
		else:
			return fill_affixes_node(affixes, weapon_quality, affix_count)
	else:
		var new_suffix = get_random_suffix(weapon_quality)
		if affixes.add_new_suffix(new_suffix):
			return fill_affixes_node(affixes, weapon_quality, affix_count - 1)
		else:
			return fill_affixes_node(affixes, weapon_quality, affix_count)


func get_affix_count_by_quality(weapon_quality):
	if weapon_quality >= Const.WEAPON_QUALITY.T7:
		return 4
	elif weapon_quality >= Const.WEAPON_QUALITY.T4:
		return 3
	elif weapon_quality >= Const.WEAPON_QUALITY.T2:
		return 2
	else:
		return 1

func get_random_prefix(weapon_quality):
	return get_random_affix_by_type(weapon_quality, PREFIX)

func get_random_suffix(weapon_quality):
	return get_random_affix_by_type(weapon_quality, SUFFIX)

func get_random_affix_by_type(quality, type):
	var current_pool
	randomize()
	var rarity_roll = randi()% 100 + 1
	var context = quality_weights[quality]
	for rarity in context.keys():
		if rarity_roll <= context[rarity]:
			current_pool = self[rarity+type]
			break
		else:
			rarity_roll -= context[rarity]
	return current_pool[randi() % current_pool.size()]


func roll_affix():
	pass

func roll_prefix():
	pass

func roll_suffix():
	pass

var quality_weights := {
	Const.WEAPON_QUALITY.T1: {
		"NORMAL": 62,
		"MAGIC": 29,
		"RARE": 6,
		"LEGENDARY": 3,
	},
	Const.WEAPON_QUALITY.T2: {
		"NORMAL": 60,
		"MAGIC": 30,
		"RARE": 7,
		"LEGENDARY": 3,
	},
	Const.WEAPON_QUALITY.T3: {
		"NORMAL": 56,
		"MAGIC": 32,
		"RARE": 8,
		"LEGENDARY": 4,
	},
	Const.WEAPON_QUALITY.T4: {
		"NORMAL": 50,
		"MAGIC": 35,
		"RARE": 10,
		"LEGENDARY": 5,
	},
	Const.WEAPON_QUALITY.T5: {
		"NORMAL": 45,
		"MAGIC": 37,
		"RARE": 12,
		"LEGENDARY": 6,
	},
	Const.WEAPON_QUALITY.T6: {
		"NORMAL": 35,
		"MAGIC": 40,
		"RARE": 17,
		"LEGENDARY": 8,
	},
	Const.WEAPON_QUALITY.T7: {
		"NORMAL": 25,
		"MAGIC": 35,
		"RARE": 30,
		"LEGENDARY": 10,
	},
	Const.WEAPON_QUALITY.T8: {
		"NORMAL": 20,
		"MAGIC": 33,
		"RARE": 35,
		"LEGENDARY": 12,
	},
	Const.WEAPON_QUALITY.T9: {
		"NORMAL": 10,
		"MAGIC": 28,
		"RARE": 45,
		"LEGENDARY": 17,
	},
	Const.WEAPON_QUALITY.T10: {
		"NORMAL": 5,
		"MAGIC": 25,
		"RARE": 45,
		"LEGENDARY":25, 
	},
}
