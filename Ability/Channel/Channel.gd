extends Ability
class_name Channel

onready var tick_timer: Timer = $TickTimer

var is_casting := false setget set_is_casting

func set_is_casting(cast: bool) -> void:
	is_casting = cast

func appear() -> void:
	pass


func disappear() -> void:
	pass

