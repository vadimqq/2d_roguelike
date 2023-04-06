extends Ability
class_name Channel

signal damage_tick
signal appear
signal disappear

onready var tick_timer: Timer = $TickTimer

var is_casting := false setget set_is_casting
var enemy_in_collider := []
export (bool) var is_not_spectate = false

func _ready():
	execute()

func set_is_casting(cast: bool) -> void:
	is_casting = cast



func start_appear() -> void:
	emit_signal("appear")
	appear()

func start_disappear() -> void:
	emit_signal("disappear")
	disappear()



func appear() -> void:
	pass

func disappear() -> void:
	pass

