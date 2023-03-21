extends Control


func _on_Restart_button_up():
	Events.start_game()


func _on_Menu_button_up():
	Events.go_to_main_menu()
