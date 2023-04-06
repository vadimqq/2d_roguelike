extends GridContainer

const effect_panel_node = preload("res://UI/Effects/EffectPanel.tscn")


func _on_add_effect(effect):
	var effect_panel = find_node_by_title(effect.title)
	
	if effect_panel:
		effect_panel.inc()
	else:
		var panel = effect_panel_node.instance()
		panel.icon = effect.icon
		panel.title = effect.title
		add_child(panel)

func _on_remove_effect(effect):
	var effect_panel = find_node_by_title(effect.title)
	if effect_panel.count <= 1:
		remove_child(effect_panel)
	else:
		effect_panel.dec()


func find_node_by_title(effect_title):
	for node in get_children():
		if node.title == effect_title:
			return node
	return null
