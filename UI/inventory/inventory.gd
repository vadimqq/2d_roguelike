extends Control

const SLOT_CLASS = preload("res://UI/inventory/slot/slot.gd")
const ITEM_CLASS = preload("res://UI/inventory/item/item.gd")
var slot_node = preload("res://UI/inventory/slot/module_slot.tscn")

onready var module_slots = $ScrollContainer/Modules
onready var weapon_slots = $ScrollContainer2/Weapons
onready var current_setup = $Current_setup/GridContainer
onready var current_weapon_slot = $Current_setup/CurrentWeaponSlot
onready var item_list = $Item_list


var holding_item: ITEM_CLASS = null
var holding_node = null

var player: Player = null

func initialize(player_node: Player):
	player = player_node
	current_weapon_slot.connect('gui_input', self, 'slot_gui_input_setup', [current_weapon_slot])
	for key in player.module_inventory_dict.keys():
		var slot_instance = slot_node.instance()
		slot_instance.key = key
		slot_instance.type = Const.SlotType.MODULE
		slot_instance.inventory_type = Const.InventoryType.INVENTORY
		slot_instance.connect('gui_input', self, 'slot_gui_input_setup', [slot_instance])
		module_slots.add_child(slot_instance)
		if player.module_inventory_dict.get(key) != null:
			slot_instance.initialize(player.module_inventory_dict.get(key))
	for key in player.weapon_inventory_dict.keys():
		var slot_instance = slot_node.instance()
		slot_instance.key = key
		slot_instance.type = Const.SlotType.WEAPON
		slot_instance.inventory_type = Const.InventoryType.INVENTORY
		slot_instance.connect('gui_input', self, 'slot_gui_input_setup', [slot_instance])
		weapon_slots.add_child(slot_instance)
		if player.weapon_inventory_dict.get(key) != null:
			slot_instance.initialize(player.weapon_inventory_dict.get(key))

func update_inventory():
	for key in player.module_inventory_dict.keys():
		if player.module_inventory_dict.get(key) != null:
			module_slots.get_child(key).initialize(player.module_inventory_dict.get(key))
	for key in player.weapon_inventory_dict.keys():
		if player.weapon_inventory_dict.get(key) != null:
			weapon_slots.get_child(key).initialize(player.weapon_inventory_dict.get(key))

func update_setup():
	for slot in current_setup.get_children():
		current_setup.remove_child(slot)
	
	var player_weapon: Weapon = player.get_current_weapon()
	if player_weapon == null:
		return
	
	for key in player_weapon.module_dict.keys():
		var slot_instance = slot_node.instance()
		slot_instance.key = key
		slot_instance.type = Const.SlotType.MODULE
		slot_instance.inventory_type = Const.InventoryType.SETUP
		current_setup.add_child(slot_instance)
		slot_instance.connect('gui_input', self, 'slot_gui_input_setup', [slot_instance])
		if player_weapon.module_dict.get(key) != null:
			slot_instance.initialize(player_weapon.module_dict.get(key))

func update_weapon():
	var player_weapon: Weapon = player.get_current_weapon()
	if current_weapon_slot.get_child_count() > 0:
		current_weapon_slot.remove_child(current_weapon_slot.get_child(0))
	if player_weapon:
		current_weapon_slot.initialize(player_weapon)

func update_itemlist():
	for node in item_list.get_children():
		item_list.remove_child(node)

	for item in player.item_inventory.get_children():
		var slot_instance = slot_node.instance()
		slot_instance.type = Const.SlotType.ITEM
		item_list.add_child(slot_instance)
		slot_instance.initialize(item)

func _input(event):
	if event.is_action_pressed("inventory"):
		visible = !visible
		get_tree().paused = visible
		update_inventory()
		update_setup()
		update_weapon()
		update_itemlist()
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

func slot_gui_input_setup(event: InputEvent, slot: SLOT_CLASS):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holding_item != null:
				if !slot.item && slot.type == holding_item.type:
					slot.putIntoSlot(holding_item)
					holding_item = null
#					---------------------------------------------
					var context: Dictionary = get_context_by_type(slot.inventory_type, slot.type)
					context[slot.key] = holding_node
					if slot.inventory_type == Const.InventoryType.SETUP and slot.type == Const.SlotType.WEAPON:
						player.weapon_raycast.add_child(holding_node)
						player.get_current_weapon().initialize_owner(player)
						update_setup()
					holding_node = null
#					--------------------------------------------
				elif slot.type == holding_item.type:
					var temp_item = slot.item
					slot.pickFromSlot()
					temp_item.global_position = event.global_position
					slot.putIntoSlot(holding_item)
					holding_item = temp_item
					
#					--------------------------------------------
					var context: Dictionary = get_context_by_type(slot.inventory_type, slot.type)
					var temp_node = context.get(slot.key)
					if slot.inventory_type == Const.InventoryType.SETUP and slot.type == Const.SlotType.WEAPON:
						player.weapon_raycast.remove_child(player.get_current_weapon())
						player.weapon_raycast.add_child(holding_node)
						player.get_current_weapon().initialize_owner(player)
						update_setup()
					context[slot.key] = holding_node
					holding_node = temp_node
#					--------------------------------------------
					
			elif slot.item:
				holding_item = slot.item
#				---------------------------------------------
				var context: Dictionary = get_context_by_type(slot.inventory_type, slot.type)
				holding_node = context.get(slot.key)
				context[slot.key] = null
				if slot.inventory_type == Const.InventoryType.SETUP and slot.type == Const.SlotType.WEAPON:
					player.weapon_raycast.remove_child(player.get_current_weapon())
					update_setup()
#				--------------------------------------------
				slot.pickFromSlot()
				
				holding_item.global_position = get_global_mouse_position()

func get_context_by_type(inventory_type, item_type):
	match inventory_type:
		Const.InventoryType.INVENTORY:
			match item_type:
				Const.SlotType.MODULE:
					return player.module_inventory_dict
				Const.SlotType.WEAPON:
					return player.weapon_inventory_dict
		Const.InventoryType.SETUP:
			match item_type:
				Const.SlotType.MODULE:
					return player.get_current_weapon().module_dict
				Const.SlotType.WEAPON:
					return {"0": player.get_current_weapon()}
