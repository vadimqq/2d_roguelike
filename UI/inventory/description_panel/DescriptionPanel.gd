extends Panel

onready var module_container = $ModuleContainer
onready var module_item_name = $ModuleContainer/Label
onready var module_item_description = $ModuleContainer/ScrollContainer/Label
onready var module_item_icon = $ModuleContainer/CenterContainer/TextureRect

onready var weapon_container = $WeaponContainer
onready var weapon_item_icon = $WeaponContainer/CenterContainer/WeaponIcon
onready var weapon_item_name = $WeaponContainer/Title

onready var weapon_ability_icon = $WeaponContainer/ScrollContainer/VBoxContainer/CenterContainer/AbilityIcon
onready var weapon_ability_title = $WeaponContainer/ScrollContainer/VBoxContainer/AbilityTitle
onready var weapon_ability_description = $WeaponContainer/ScrollContainer/VBoxContainer/AbilityDescription


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
		weapon_ability_description.text = weapon_ability.description
