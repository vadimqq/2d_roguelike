extends Node2D
class_name Effect

export (StreamTexture) var icon
export (String) var title = ''

onready var duration_timer = $Duration
onready var one_tick_timer = $OneTick

var target = null

func initialize(new_target):
	target = new_target


func _on_Duration_timeout():
	call_deferred('queue_free')
