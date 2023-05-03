extends Node2D
class_name Ability

onready var timer := $LifeTimer

export (String) var title = 'Ability title'
export (String) var description = 'Ability descritption'

export (float) var cooldown = 1.0
export (int) var mana_cost = 5
export (float) var life_time = 3.0
export (int) var collision_mask = 0

export (Array, Const.ABILITY_TAGS) var tags
export (Const.DAMAGE_TAG) var damage_tag
export (Const.TRIGGER_TYPE) var trigger_type

export (int) var damage = 0
export (float) var scale_modifier = 1.0

var executor = null
var unic_modules = {}

var on_execute_ability_list := []
var on_hit_ability_list := []
var on_die_ability_list := []

func _ready():
	scale *= scale_modifier
	collision_mask = executor.attack_collision_mask
	for unic_module in unic_modules.keys():
		if unic_modules.get(unic_module):
			add_child(unic_modules.get(unic_module))
	execute()


func execute():
	Events.emit_signal("ability_execute", self)
	call_deferred('create_execute_effect')
	spawn_ability_by_arr(on_execute_ability_list)
	timer.wait_time = life_time
	timer.start()

func _process(delta):
	Events.emit_signal("ability_process", self)

func die():
	spawn_ability_by_arr(on_die_ability_list)
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

func spawn_ability_by_arr(ability_list: Array):
	for ability in ability_list:
		ability.global_position = global_position
		ability.global_rotation = global_rotation
		ability.executor = executor
		ObjectRegistry.register_ability(ability)

func spawn_ability_on_hit(ability_list: Array):
	for ability in ability_list:
		ability.global_position = global_position
		ability.global_rotation = global_rotation
		ability.executor = executor
		ObjectRegistry.register_ability(ability)
	
	ability_list.clear()
