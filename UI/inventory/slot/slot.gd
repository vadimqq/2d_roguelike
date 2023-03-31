extends Panel

onready var background_module = $TextureRect
onready var count_label = $Label
onready var description_panel = $CanvasLayer/DescriptionPanel

enum DESCRIPTION_POSITION {
	TOP,
	RIGHT,
	LEFT,
	BOTTOM
}

export (DESCRIPTION_POSITION) var description_position

export (PackedScene) var module_node

var module = null
var module_count = 0

func _process(delta):
	if !find_parent("Inventory").visible:
		description_panel.visible = false

func _ready():
	if module_node:
		module = module_node.instance()
	if module_count == 0:
		modulate = Color(0.36, 0.36, 0.36, 1)


func disabled():
	modulate = Color(0.36, 0.36, 0.36, 1)
	count_label.visible = false

func enabled():
	modulate = Color(1, 1, 1, 1)
	count_label.visible = true
	count_label.text = str(module_count)


func _on_ModuleSlot_mouse_entered():
	set_description_position()
	description_panel.visible = true
	description_panel.initialize(module)


func _on_ModuleSlot_mouse_exited():
	description_panel.visible = false


func set_description_position():
	match description_position:
		DESCRIPTION_POSITION.TOP:
			description_panel.rect_global_position = Vector2(rect_global_position.x + rect_min_size.x / 2 - description_panel.rect_min_size.x / 2, rect_global_position.y - description_panel.rect_min_size.y) 
		DESCRIPTION_POSITION.BOTTOM:
			description_panel.rect_global_position = Vector2(rect_global_position.x + rect_min_size.x / 2 - description_panel.rect_min_size.x / 2, rect_global_position.y + rect_min_size.y)
		DESCRIPTION_POSITION.RIGHT:
			description_panel.rect_global_position = Vector2(rect_global_position.x + rect_min_size.x, rect_global_position.y ) 
		DESCRIPTION_POSITION.LEFT:
			description_panel.rect_global_position = Vector2(rect_global_position.x - rect_min_size.x * 1.5 - description_panel.rect_min_size.x / 2, rect_global_position.y ) 
