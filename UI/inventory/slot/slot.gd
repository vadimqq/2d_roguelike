extends Panel

onready var background_module = $TextureRect
onready var count_label = $Label

export (PackedScene) var module_node

var module = null
var module_count = 0

func _ready():
	if module_node:
		module = module_node.instance()
#		background_module.texture = module.icon
	if module_count == 0:
		modulate = Color(0.36, 0.36, 0.36, 1)

func initialize(player_item):
	pass

func pickFromSlot():
	pass

func putIntoSlot(new_item):
	pass

func disabled():
	modulate = Color(0.36, 0.36, 0.36, 1)
	count_label.visible = false

func enabled():
	modulate = Color(1, 1, 1, 1)
	count_label.visible = true
	count_label.text = str(module_count)

