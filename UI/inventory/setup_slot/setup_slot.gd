extends Panel

const WEAPON_CLASS = preload("res://Weapon/Weapon.gd")
const MODULE_CLASS = preload("res://Ability/Modules/Module.gd")
const ITEM_CLASS = preload("res://Items/Item.gd")


var module_tex = preload("res://UI/inventory/setup_slot/module_cell.png")
var weapon_tex = preload("res://UI/inventory/setup_slot/weapon_slot.png")
var item_tex = preload("res://UI/inventory/setup_slot/item_slot.png")
var item_node = preload("res://UI/inventory/item/item.tscn")

var module_style: StyleBoxTexture = null
var weapon_style: StyleBoxTexture = null
var item_style: StyleBoxTexture = null

export (Const.SlotType) var type = Const.SlotType.MODULE
export (Const.InventoryType) var inventory_type = Const.InventoryType.INVENTORY

var item = null
export (String) var key = "0"

func _ready():
	module_style = StyleBoxTexture.new()
	weapon_style = StyleBoxTexture.new()
	item_style = StyleBoxTexture.new()
	module_style.texture = module_tex
	weapon_style.texture = weapon_tex
	item_style.texture = item_tex
	
	match type:
		Const.SlotType.MODULE:
			set('custom_styles/panel', module_style)
		Const.SlotType.WEAPON:
			set('custom_styles/panel', weapon_style)
		Const.SlotType.ITEM:
			set('custom_styles/panel', item_style)
		
func initialize(player_item):
	for node in get_children():
		remove_child(node)
	
	var item_instance = item_node.instance()
	item_instance.position = Vector2(50, 50)
	add_child(item_instance)
	if player_item is MODULE_CLASS:
		item_instance.type = Const.SlotType.MODULE
	elif player_item is WEAPON_CLASS:
		item_instance.type = Const.SlotType.WEAPON
	elif player_item is ITEM_CLASS:
		item_instance.type = Const.SlotType.ITEM
	item_instance.texture_rect.texture = player_item.icon
	item_instance.name = player_item.name
	item = item_instance

func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent('Inventory')
	inventoryNode.add_child(item)
	item = null

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(50,50)
	var inventoryNode = find_parent('Inventory')
	inventoryNode.remove_child(item)
	add_child(item)

func clear_slot():
	if get_child_count() > 0:
		remove_child(get_child(0))
