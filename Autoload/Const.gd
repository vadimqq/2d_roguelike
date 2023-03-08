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

enum PortalDirection {
	RIGHT,
	LEFT,
	TOP,
	BOTTOM
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
