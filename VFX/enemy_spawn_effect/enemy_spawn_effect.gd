extends Node2D

const GAME_CLASS = preload("res://Game.gd")

onready var animation = $Animation

var spawned_node: PackedScene = null

func _ready():
	animation.play("cast")


func _on_Animation_animation_finished(anim_name):
	if spawned_node and get_tree().current_scene is GAME_CLASS:
		var enemy_instance = spawned_node.instance()
		get_tree().current_scene._enemies.add_child(enemy_instance)
		enemy_instance.global_position = global_position
		call_deferred('queue_free')
	else:
		call_deferred('queue_free')
