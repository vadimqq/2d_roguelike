extends Node2D

signal add_effect(effect)
signal remove_effect(effect)

onready var effect_list = $effect_list
onready var effects_ui = $EffectsUI

func _ready():
	connect("remove_effect", effects_ui, "_on_remove_effect")
	connect("add_effect", effects_ui, "_on_add_effect")
	

func add_effect(effect: Effect):
	effect.connect("tree_exiting", effects_ui, "_on_remove_effect", [effect])
	effect_list.add_child(effect)
	emit_signal("add_effect", effect)
	

func remove_effect(effect):
	if effect_list.has_node(effect):
		effect_list.remove_child(effect)
		emit_signal("remove_effect", effect)
