extends PanelContainer

onready var label = $Label

func initialize(text):
	label.text = text
