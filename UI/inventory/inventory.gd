extends Control

const SETUP_SLOT_CLASS = preload("res://UI/inventory/setup_slot/setup_slot.gd")
const ITEM_CLASS = preload("res://UI/inventory/item/item.gd")
var setup_slot_node = preload("res://UI/inventory/setup_slot/setup_slot.tscn")
var weapon_slot_node = preload("res://UI/inventory/weapon_slot/weapon_slot.tscn")


onready var module_slots = $ScrollContainer/Modules
onready var weapon_slots = $ScrollContainer2/Weapons
onready var current_setup = $Current_setup/GridContainer
onready var current_weapon_slot = $Current_setup/WeaponSlot
onready var item_list = $Item_list

var holding_item: ITEM_CLASS = null
var holding_node = null

var player: Player = null

func initialize(player_node: Player):
	player = player_node
	for slot in module_slots.get_children():
		slot.connect('gui_input', self, 'module_slot_gui_input_setup', [slot])

func update_inventory():
	for slot in module_slots.get_children():
		var count = 0
		for module in player.module_inventory_arr:
			if slot.module.title == module.title:
				count += 1
		slot.module_count = count
		if slot.module_count > 0:
			slot.enabled()
		else:
			slot.disabled()
	
	for node in weapon_slots.get_children():
		weapon_slots.remove_child(node)
	for weapon in player.weapon_inventory_arr:
		var slot = weapon_slot_node.instance()
		slot.connect('gui_input', self, 'weapon_slot_gui_input_setup', [slot])
		slot.weapon = weapon
		weapon_slots.add_child(slot)


func update_setup():
	for slot in current_setup.get_children():
		current_setup.remove_child(slot)

	var player_weapon: Weapon = player.get_current_weapon()
	if player_weapon == null:
		return

	for key in player_weapon.module_dict.keys():
		var slot_instance = setup_slot_node.instance()
		slot_instance.key = key
		slot_instance.type = Const.SlotType.MODULE
		slot_instance.inventory_type = Const.InventoryType.SETUP
		current_setup.add_child(slot_instance)
		slot_instance.connect('gui_input', self, 'slot_gui_input_setup', [slot_instance])
		if player_weapon.module_dict.get(key) != null:
			slot_instance.initialize(player_weapon.module_dict.get(key))

func update_weapon():
	var player_weapon: Weapon = player.get_current_weapon()
	
	if player_weapon:
		current_weapon_slot.initialize(player_weapon)

func update_itemlist():
	for node in item_list.get_children():
		item_list.remove_child(node)

	for item in player.item_inventory.get_children():
		var slot_instance = setup_slot_node.instance()
		slot_instance.type = Const.SlotType.ITEM
		item_list.add_child(slot_instance)
		slot_instance.initialize(item)
#
func _input(event):
	if event.is_action_pressed("inventory"):
		visible = !visible
		get_tree().paused = visible
		if visible:
			update_inventory()
			update_setup()
			update_weapon()
			update_itemlist()
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
#
func module_slot_gui_input_setup(event: InputEvent, slot):
	if event is InputEventMouseButton && !holding_item:
		if event.button_index == BUTTON_LEFT && event.pressed and slot.module_count > 0:
			var player_weapon: Weapon = player.get_current_weapon()
			var is_have_null_slot = player_weapon.module_dict.values().has(null)
			
			if player_weapon == null or !is_have_null_slot:
				return
			
			var temp_module = null
			for module in player.module_inventory_arr:
				if slot.module.title == module.title:
					temp_module = module
					break
			player.module_inventory_arr.erase(temp_module)
			update_inventory()
		
			for key in player_weapon.module_dict.keys():
				if player_weapon.module_dict[key] == null:
					player_weapon.module_dict[key] = temp_module
					break
			update_setup()


func weapon_slot_gui_input_setup(event: InputEvent, slot):
	if event is InputEventMouseButton && !holding_item:
		if event.button_index == BUTTON_LEFT && event.is_action_released("l-click"):
			if slot.weapon == null:
				return
			
			var temp_weapon = null
			for weapon in player.weapon_inventory_arr:
				if slot.weapon.name == weapon.name:
					temp_weapon = weapon
					break
			player.set_new_weapon(temp_weapon)
			update_inventory()
		
			update_weapon()
			update_setup()


func slot_gui_input_setup(event: InputEvent, slot: SETUP_SLOT_CLASS):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT && event.pressed && !holding_node && slot.item:
			var temp_module = player.get_current_weapon().module_dict.get(slot.key)
			player.get_current_weapon().module_dict[slot.key] = null
			player.module_inventory_arr.append(temp_module)
			update_inventory()
			update_setup()

		elif event.button_index == BUTTON_LEFT && event.pressed:
			if holding_item != null:
				if !slot.item && slot.type == holding_item.type:
					slot.putIntoSlot(holding_item)
					holding_item = null
##				---------------------------------------------
					player.get_current_weapon().module_dict[slot.key] = holding_node
					if slot.type == Const.SlotType.WEAPON:
						player.weapon_raycast.add_child(holding_node)
						player.get_current_weapon().initialize_owner(player)
						update_setup()
					holding_node = null
##					--------------------------------------------
				elif slot.type == holding_item.type:
					var temp_item = slot.item
					slot.pickFromSlot()
					temp_item.global_position = event.global_position
					slot.putIntoSlot(holding_item)
					holding_item = temp_item
##					--------------------------------------------
					var temp_node = player.get_current_weapon().module_dict.get(slot.key)
					if slot.inventory_type == Const.InventoryType.SETUP and slot.type == Const.SlotType.WEAPON:
						player.weapon_raycast.remove_child(player.get_current_weapon())
						player.weapon_raycast.add_child(holding_node)
						player.get_current_weapon().initialize_owner(player)
						update_setup()
					player.get_current_weapon().module_dict[slot.key] = holding_node
					holding_node = temp_node
##				--------------------------------------------

			elif slot.item:
				holding_item = slot.item
##			---------------------------------------------
				holding_node = player.get_current_weapon().module_dict.get(slot.key)
				player.get_current_weapon().module_dict[slot.key] = null
				if slot.type == Const.SlotType.WEAPON:
					player.weapon_raycast.remove_child(player.get_current_weapon())
					update_setup()
#				--------------------------------------------
				slot.pickFromSlot()

				holding_item.global_position = get_global_mouse_position()

