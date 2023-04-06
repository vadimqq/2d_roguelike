extends Panel

onready var module_container = $ModuleContainer
onready var module_item_name = $ModuleContainer/Label
onready var module_item_description = $ModuleContainer/ScrollContainer/Label
onready var module_item_icon = $ModuleContainer/CenterContainer/TextureRect


func initialize(item):
	if item is Module:
		module_container.visible = true
		module_item_name.text = item.title
		module_item_description.text = item.description
		module_item_icon.texture = item.icon
