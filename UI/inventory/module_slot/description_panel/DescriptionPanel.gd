extends Panel

const chip_node = preload("res://UI/inventory/module_slot/description_panel/ModuleChip/ModuleChip.tscn")

onready var module_name = $ModuleContainer/Title
onready var module_description = $ModuleContainer/Description
onready var module_icon = $ModuleContainer/CenterContainer/Icon
onready var module_tags_container = $ModuleContainer/ModuleTags
onready var ability_tags_container = $ModuleContainer/AbilityTags
onready var module_type = $ModuleContainer/ModuleChip

func initialize(module: Module):
	module_name.text = module.title
	module_description.text = module.description
	module_icon.texture = module.icon
	module_type.initialize(Const.MODULE_TYPE_TITLES[module.type])
	set_module_tags(module.module_tags)
	set_ability_tags(module.ability_tags)


func set_module_tags(module_tags):
	for node in module_tags_container.get_children():
		module_tags_container.remove_child(node)
	
	for tag in module_tags:
		var chip = chip_node.instance()
		module_tags_container.add_child(chip)
		chip.initialize(Const.MODULE_TAG_TITLES[tag])


func set_ability_tags(ability_tags):
	for node in ability_tags_container.get_children():
		ability_tags_container.remove_child(node)
	for tag in ability_tags:
		var chip = chip_node.instance()
		ability_tags_container.add_child(chip)
		chip.initialize(Const.ABILITY_TYPE_TITLES[tag])
