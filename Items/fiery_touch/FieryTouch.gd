extends Item

export (int) var burning_chance = 10

const burning = preload("res://Effects/burning/Burning.tscn")

func add_effect(player):
	Events.connect("ability_hit", self, "_on_ability_hit", [player])


func remove_effect(player):
	pass


func _on_ability_hit(ability: Ability, target, player):
	randomize()
	if !(target is Enemy) or ability.damage_tag != Const.DAMAGE_TAG.FIRE:
		return
	var rand_num = rand_range(0, 100)
	if rand_num < burning_chance:
		var burning_instance = burning.instance()
		burning_instance.damage = player.stats.get_modified_damage(burning_instance.damage, Const.DAMAGE_TAG.FIRE)
		burning_instance.initialize(target)
		target.effects_manager.add_effect(burning_instance)
