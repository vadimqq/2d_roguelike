extends RigidBody2D

onready var animation = $Animation

export (int) var move_speed = 250
var is_move_to_player = false
var player = null

func _process(delta):
	if is_move_to_player and player:
		global_position = global_position.move_toward(player.global_position, delta * move_speed)
	
		if global_position.distance_to(player.global_position) < 1:
			LootManager.modify_coins(5)
			call_deferred('free')

func _ready():
	animation.play("idle")
	yield(get_tree().create_timer(rand_range(0.5, 1)),"timeout")
	is_move_to_player = true
	player = get_tree().current_scene.player
