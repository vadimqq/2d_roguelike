extends Node2D

const cumulative_explosion = preload("res://Effects/CumulativeExplosion/CumulativeExplosion.tscn")
const explosion = preload("res://Ability/Channel/Modules/CumulativeExplosion/Explosion/Explosion.tscn")

var owner_ability: Channel
var effects_for_explosion = 10
var effect_chance = 50


func _ready():
	owner_ability = find_parent('*')
	Events.connect("damaged", self, '_on_ability_hit')
	
func _on_ability_hit(target, damage, type):
	if owner_ability.enemy_in_collider.has(target) and target is KinematicBody2D:
		randomize()
		var rand_num = rand_range(0, 100)
		if rand_num < effect_chance:
			var cumulative_explosion_instance = cumulative_explosion.instance()
			cumulative_explosion_instance.initialize(target)
			target.effects_manager.add_effect(cumulative_explosion_instance)
			var effect_count = target.effects_manager.get_effect_count_by_title(cumulative_explosion_instance.title)
			if effect_count > effects_for_explosion:
				var explosion_instance = explosion.instance()
				explosion_instance.global_position = target.global_position
				ObjectRegistry.register_ability(explosion_instance)
				target.effects_manager.remove_effect_by_title_and_count(cumulative_explosion_instance.title, effects_for_explosion)
