extends "res://Effects/effect.gd"

var damage = 2


func _on_OneTick_timeout():
	Events.emit_signal("damaged_by_DOT", target, damage, Const.DAMAGE_TAG.FIRE)
