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

enum ABILITY_TYPE {
	PROJECTILE,
	CHANNEL,
	CHARGE,
}
var ABILITY_TYPE_TITLES = {
	ABILITY_TYPE.PROJECTILE: 'Projectile',
	ABILITY_TYPE.CHANNEL: 'Chanel',
	ABILITY_TYPE.CHARGE: 'Charge',
}

enum DAMAGE_TAG {
	MANA,
	FIRE,
	POISION,
	PHYSIC,
	SHADOW,
	LIGTHNING,
	HOLY,
	NATURE
}

enum PROJECTILE_TRAVEL_TYPE {
	LINE,
	CIRCULAR,
	ZIGZAG,
}

enum MODULE_TYPE {
	GLOBAL,
	SECOND_ABILITY,
}
var MODULE_TYPE_TITLES = {
	MODULE_TYPE.GLOBAL: 'GLOBAL',
	MODULE_TYPE.SECOND_ABILITY: 'Last ability',
}

enum MODULE_TAG {
	BUFF,
	DIRECTION,
	CREATOR
}
var MODULE_TAG_TITLES = {
	MODULE_TAG.BUFF: 'Buff',
	MODULE_TAG.DIRECTION: 'Change Direction',
	MODULE_TAG.CREATOR: 'Create effect',
}


enum RARITY {
	COMMON,
	MAGIC,
	RARE,
	UNIC,
	LEGENDARY
}


enum WEAPON_QUALITY {
	T1,
	T2,
	T3,
	T4,
	T5,
	T6,
	T7,
	T8,
	T9,
	T10
}
