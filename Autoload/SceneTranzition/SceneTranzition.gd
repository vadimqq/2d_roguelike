extends CanvasLayer

onready var animation = $Animation


func change_scene(target: String):
	animation.play("dissolve")
	animation.connect("animation_finished", self, "_on_animation_finished", [target])


func _on_animation_finished(anim_name, target):
	animation.disconnect("animation_finished", self, "_on_animation_finished")
	get_tree().change_scene(target)
	animation.play_backwards("dissolve")
