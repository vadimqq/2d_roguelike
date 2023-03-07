extends TextureButton

onready var icon = $Icon
onready var title = $VBoxContainer/Title
onready var description = $VBoxContainer/Description

func initialize(reward):
	title.text = reward.title
	description.text = reward.description
	icon.texture = reward.icon
