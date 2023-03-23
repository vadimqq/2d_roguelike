extends Node

enum SlotType {
	MODULE,
	WEAPON,
	ITEM
}

enum InventoryType {
	INVENTORY,
	SETUP
}

enum DamageType {
	MANA,
	FIRE,
	POISION,
	PHYSIC,
	SHADOW,
	LIGTHNING,
	HOLY,
}

enum MovementType {
	LINE,
	CIRCULAR,
	ZIGZAG
}

enum ModuleTags {
	GLOBAL,
	SECOND_SPELL,
	MANA,
	MANA,
	FIRE,
	POISION,
	PHYSIC,
	SHADOW,
	LIGTHNING,
	HOLY,
}

var ModuleTitles = {
	[ModuleTags.GLOBAL]: 'Global',
	[ModuleTags.SECOND_SPELL]: 'Second spell',
	[ModuleTags.MANA]: 'Mana damage' ,
	[ModuleTags.FIRE]: 'Fire damage',
	[ModuleTags.POISION]: 'Poision damage',
	[ModuleTags.PHYSIC]: 'Physic damage',
	[ModuleTags.SHADOW]: 'Shadow damage',
	[ModuleTags.LIGTHNING]: 'Ligthning damage',
	[ModuleTags.HOLY]: 'Holy damage',
}

func get_tag_title_by_enum(tag):
	return ModuleTitles[tag]
#======================================

enum ABILITY_TYPE {
	PROJECTILE,
	CHANNEL,
	CHARGE,
}

enum DAMAGE_TAG {
	MANA,
	FIRE,
	POISION,
	PHYSIC,
	SHADOW,
	LIGTHNING,
	HOLY,
}

enum PROJECTILE_TRAVEL_TYPE {
	LINE,
	CIRCULAR,
	ZIGZAG
}

enum MODULE_TYPE {
	GLOBAL,
	SECOND_ABILITY,
}

enum MODULE_TAG {
	BUFF,
	DIRECTION,
	CREATOR
}

enum RARITY {
	COMMON,
	MAGIC,
	RARE,
	UNIC,
	LEGENDARY
}
