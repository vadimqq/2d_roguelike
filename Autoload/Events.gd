extends Node

signal projectile_hit(projectile)
signal projectile_die(projectile)
signal projectile_cast(projectile)
signal projectile_process(projectile, disatnce)

signal player_cast_dash(player)
signal player_end_dash(player)

signal ability_execute(ability)
signal ability_hit(ability)
signal ability_process(ability)
signal ability_die(ability)

signal damaged(target, damage, type)
signal damaged_by_DOT(target, damage, type)
signal enemy_death(enemy)
signal boss_death


func start_game():
	SceneTranzition.change_scene("res://Game.tscn")

func quit_game():
	get_tree().quit()

func go_to_end_game_screen():
	SceneTranzition.change_scene("res://UI/EndGameScreen/EndGameScreen.tscn")

func go_to_main_menu():
	SceneTranzition.change_scene("res://UI/MainScreen/MainScreen.tscn")
