extends Node2D
class_name Ability

onready var timer := $LifeTimer

export (String) var title = 'Ability title'
export (String) var description = 'Ability descritption'

export (float) var cooldown = 1.0
export (int) var mana_cost = 5
export (float) var life_time = 3.0
export (int) var collision_mask = 0

export (Const.ABILITY_TYPE) var type
export (Const.DAMAGE_TAG) var damage_tag

export (int) var damage = 0
export (float) var scale_modifier = 1.0

var executor: Node2D = null
var unic_modules = {}

func _ready():
	scale *= scale_modifier
	for unic_module in unic_modules.keys():
		if unic_modules.get(unic_module) is Node:
			add_child(unic_modules.get(unic_module))


func execute():
	Events.emit_signal("ability_execute", self)
	call_deferred('create_execute_effect')
	timer.wait_time = life_time
	timer.start()

func _process(delta):
	Events.emit_signal("ability_process", self)

func die():
	Events.emit_signal("ability_die", self)
	call_deferred('create_die_effect')
	call_deferred('queue_free')


func create_execute_effect():
	pass

func create_hit_effect():
	pass

func create_die_effect():
	pass

func _on_LifeTimer_timeout():
	die()
