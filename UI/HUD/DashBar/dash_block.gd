extends Panel


onready var progress_tex = $Progress


func set_active():
	progress_tex.visible = true

func set_disable():
	progress_tex.visible = false
