extends Panel


onready var item_name = $VBoxContainer/Label
onready var item_description = $VBoxContainer/ScrollContainer/Label
onready var item_icon = $VBoxContainer/CenterContainer/TextureRect


func initialize(item):
	item_name.text = item.title
	item_description.text = item.description
	item_icon.texture = item.icon
