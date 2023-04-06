extends Ability
class_name Charge

signal execute_charge
signal charge_tick


onready var charge_timer := $ChargeTimer
onready var tween := $Tween

export (float) var max_charge_duration = 5.0
var charge_duration = 0.1
export (float) var charge_duration_tick = 0.1
var power_percent = 0
var is_ready = false
var temp_life_time = 0

func start_charge():
	charge_timer.wait_time = charge_duration_tick
	charge_timer.start()

func execute_charge():
	charge_timer.stop()
	if tween.is_active():
		tween.stop_all()
	emit_signal("execute_charge")
	execute()
	is_ready = true

func _on_ChargeTimer_timeout():
	charge_duration += charge_duration_tick
	power_percent = ceil(charge_duration * 100 / max_charge_duration)
	
	if charge_duration >= max_charge_duration:
		power_percent = 100
		execute_charge()
	else:
		charge_timer.start()
	
	emit_signal("charge_tick", power_percent)
	
