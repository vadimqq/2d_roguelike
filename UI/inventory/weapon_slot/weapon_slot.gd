extends Panel

onready var background_weapon = $TextureRect
onready var module_count_label = $Label

var weapon = null

func _ready():
	if weapon:
		background_weapon.texture = weapon.icon
		module_count_label.text = str(weapon.module_count)
