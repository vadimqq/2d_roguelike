extends GridContainer

const dash_block = preload("res://UI/HUD/DashBar/dash_block.tscn")

func initialize(player) -> void:
	player.stats.connect("stat_changed", self, "_on_Stats_stat_changed")
	create_dash_blocks(player.stats.max_dash_count)


func create_dash_blocks(amount):
	for node in get_children():
		remove_child(node)

	for i in range(amount):
		var dash_block_instance = dash_block.instance()
		add_child(dash_block_instance)

func _on_Stats_stat_changed(stats: Stats) -> void:
	if get_child_count() != stats.max_dash_count:
		create_dash_blocks(stats.max_dash_count)
	
	for i in get_child_count():
		if i <= stats.current_dash_count - 1:
			get_child(i).set_active()
		else:
			get_child(i).set_disable()
