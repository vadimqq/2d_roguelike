extends Panel

onready var count_label = $Label

export (StreamTexture) var icon

var style: StyleBoxTexture = null
var count = 1
var title = ''

func _ready():
	style = StyleBoxTexture.new()
	style.texture = icon
	set('custom_styles/panel', style)
	count_label.text = str(count)

func inc():
	count += 1
	count_label.text = str(count)

func dec():
	count -= 1
	count_label.text = str(count)
