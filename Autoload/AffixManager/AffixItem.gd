extends Node

var id = ''
var title = ''
var value = 0
var tier = ''

func initialize(dict: Dictionary):
	if dict.has("id"):
		id = dict.get("id")
	if dict.has("title"):
		title = dict.get("title")
	if dict.has("min") and dict.has("max"):
		value = ceil(rand_range(float(dict.get("min")), float(dict.get("max"))))
	if dict.has("tier"):
		tier = dict.get("tier")


func get_dict_info() -> Dictionary:
	return {id: value}
