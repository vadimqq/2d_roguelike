extends Control

const _MENU_SAMPLE = preload("res://UI/MainScreen/DavidKBD - InterstellarPack - 06 - Hope on the Horizon.ogg")

func _ready():
	AudioBus.play_menu_sound(_MENU_SAMPLE)

func _on_StartButton_button_up():
	Events.start_game()

func _on_ExitButton_button_up():
	Events.quit_game()

func _exit_tree():
	AudioBus.stop_menu_sound()
