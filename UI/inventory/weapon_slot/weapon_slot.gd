extends Panel

onready var background_weapon = $TextureRect
onready var description_panel = $CanvasLayer/DescriptionPanel

enum DESCRIPTION_POSITION {
	TOP,
	RIGHT,
	LEFT,
	BOTTOM
}
export (DESCRIPTION_POSITION) var description_position

var weapon = null

func _ready():
	if weapon:
		background_weapon.texture = weapon.icon

func _process(delta):
	if !find_parent("Inventory").visible:
		description_panel.visible = false

func initialize(new_weapon):
	weapon = new_weapon
	background_weapon.texture = weapon.icon

func _on_WeaponSlot_mouse_entered():
	set_description_position()
	description_panel.visible = true
	description_panel.initialize(weapon)


func _on_WeaponSlot_mouse_exited():
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
