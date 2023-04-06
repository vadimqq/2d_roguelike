extends Node2D

onready var timer_one_tick = $Timer

var damage_incrementor = 1.1
var mana_cost_incrementor = 1.1

var owner_ability: Channel

func _ready():
	owner_ability = find_parent('*')

func increment():
	owner_ability.damage *= damage_incrementor
	owner_ability.mana_cost *= mana_cost_incrementor
	timer_one_tick.start()

func _on_Timer_timeout():
	increment()
