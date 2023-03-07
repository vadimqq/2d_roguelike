extends Node2D


onready var animation = $Animation

var spawned_node: PackedScene = null

func _ready():
	animation.play("cast")


func _on_Animation_animation_finished(anim_name):
	if spawned_node:
		var enemy_instance = spawned_node.instance()
		get_tree().current_scene._enemies.add_child(enemy_instance)
		enemy_instance.global_position = global_position
		call_deferred('queue_free')
