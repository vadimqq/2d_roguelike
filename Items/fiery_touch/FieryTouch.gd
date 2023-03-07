extends Item

export (int) var burning_chance = 10

const burning = preload("res://Effects/burning/Burning.tscn")

func add_effect(player):
	Events.connect("damaged", self, "_on_damage_enemy", [player])


func remove_effect(player):
	pass


func _on_damage_enemy(target, damage, type, player):
	randomize()
	if !(target is Enemy) or type != Const.DamageType.FIRE:
		return
	var rand_num = rand_range(0, 100)
	if rand_num < burning_chance:
		var burning_instance = burning.instance()
		burning_instance.damage = player.stats.get_modified_damage(burning_instance.damage, Const.DamageType.FIRE)
		burning_instance.initialize(target)
		target.effects_manager.add_effect(burning_instance)
