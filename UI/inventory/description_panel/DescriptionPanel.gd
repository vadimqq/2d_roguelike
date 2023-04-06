extends Panel

const AFFIX_LIST_CLASS = preload("res://Autoload/AffixManager/AffixList.gd")
const affix_panel = preload("res://UI/inventory/description_panel/AffixPanel/AffixPanel.tscn")

onready var module_container = $ModuleContainer
onready var module_item_name = $ModuleContainer/Label
onready var module_item_description = $ModuleContainer/ScrollContainer/Label
onready var module_item_icon = $ModuleContainer/CenterContainer/TextureRect

onready var weapon_container = $WeaponContainer
onready var weapon_item_icon = $WeaponContainer/CenterContainer/WeaponIcon
onready var weapon_item_name = $WeaponContainer/CenterContainer/Title

onready var weapon_ability_icon = $WeaponContainer/ScrollContainer/VBoxContainer/AbilityContainer/CenterContainer/AbilityIcon
onready var weapon_ability_title = $WeaponContainer/ScrollContainer/VBoxContainer/AbilityContainer/AbilityData/AbilityTitle

onready var affix_container = $WeaponContainer/ScrollContainer/VBoxContainer/WeaponAfix


func initialize(item):
	if item is Module:
		module_container.visible = true
		weapon_container.visible = false
		module_item_name.text = item.title
		module_item_description.text = item.description
		module_item_icon.texture = item.icon
	elif item is Weapon:
		var weapon_ability: Ability = item.ability_scene.instance()
		module_container.visible = false
		weapon_container.visible = true
		weapon_item_name.text = item.title
		weapon_item_icon.texture = item.icon
		weapon_ability_title.text = weapon_ability.title
		
		var weapon_affixes: AFFIX_LIST_CLASS = item.affix_ist
		for affix_panel in affix_container.get_children():
			affix_container.remove_child(affix_panel)
		
		for prefix in weapon_affixes.prefix_list.get_children():
			var panel = affix_panel.instance()
			affix_container.add_child(panel)
			panel.initialize(prefix)
#			print(prefix)

		for suffix in weapon_affixes.suffix_list.get_children():
			var panel = affix_panel.instance()
			affix_container.add_child(panel)
			panel.initialize(suffix)
#			print(suffix)
