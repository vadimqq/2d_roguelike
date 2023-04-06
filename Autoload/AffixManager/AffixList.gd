extends Node

const AFFIX_ITEM_CLASS = preload("res://Autoload/AffixManager/AffixItem.gd")
const affix_item_scene = preload("res://Autoload/AffixManager/AffixItem.tscn")

onready var prefix_list = $PrefixList
onready var suffix_list = $SuffixList

func get_affix_count():
	return prefix_list.get_child_count() + suffix_list.get_child_count()


func add_new_prefix(prefix_data):
	if is_have_dublicate_affix(prefix_list, prefix_data["id"]):
		return false
	var prefix = affix_item_scene.instance()
	prefix_list.add_child(prefix)
	prefix.initialize(prefix_data)
	return true

func add_new_suffix(suffix_data):
	if is_have_dublicate_affix(suffix_list, suffix_data["id"]):
		return false
	var suffix = affix_item_scene.instance()
	suffix_list.add_child(suffix)
	suffix.initialize(suffix_data)
	return true


func is_have_dublicate_affix(arr: Node, id):
	for affix in arr.get_children():
		if affix.id == id:
			return true
	return false

func get_affix_dict() -> Dictionary:
	var result := {}
	for prefix in prefix_list.get_children():
		result.merge(prefix.get_dict_info())
	
	for suffix in suffix_list.get_children():
		result.merge(suffix.get_dict_info())
	
	return result
