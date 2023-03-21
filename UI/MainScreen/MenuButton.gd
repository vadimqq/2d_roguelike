extends TextureButton

const BUTTON_HOVER_SOUND = preload("res://UI/MainScreen/hover_sound.wav")
const BUTTON_CLICK_SOUND = preload("res://UI/MainScreen/click_sound.wav")


func _on_TextureButton_mouse_entered():
	modulate = Color(0.5, 0.5, 0.5, 1)
	AudioBus.play_game_sound(BUTTON_HOVER_SOUND)

func _on_TextureButton_mouse_exited():
	modulate = Color(1, 1, 1, 1)


func _on_TextureButton_button_up():
	AudioBus.play_game_sound(BUTTON_CLICK_SOUND)
