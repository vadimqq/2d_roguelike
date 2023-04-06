extends Node2D

signal add_effect(effect)
signal remove_effect(effect)

onready var effect_list := $effect_list
onready var effects_ui := $EffectsUI

func _ready():
	connect("remove_effect", effects_ui, "_on_remove_effect")
	connect("add_effect", effects_ui, "_on_add_effect")

func add_effect(effect: Effect):
	effect.connect("tree_exiting", effects_ui, "_on_remove_effect", [effect])
	effect_list.add_child(effect)
	emit_signal("add_effect", effect)

func remove_effect(effect: Effect):
	if effect_list.has_node(effect.name):
		effect_list.remove_child(effect)
		emit_signal("remove_effect", effect)

func get_effect_count_by_title(title):
	var result = 0
	for effect in effect_list.get_children():
		if effect.title == title:
			result += 1
	return result

func remove_effect_by_title_and_count(title, count):
	var temp_count = count
	for effect in effect_list.get_children():
		if effect.title == title and temp_count > 0:
			effect_list.remove_child(effect)
			temp_count -= 1
