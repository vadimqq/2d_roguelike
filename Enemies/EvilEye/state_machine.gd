extends StateMachine

onready var idle = $Idle
onready var move = $Move
onready var death = $Death
onready var attack = $Attack
onready var preparation = $Preparation



func _ready():
	states_map = {
		"idle": idle,
		"move": move,
		"death": death,
		"attack": attack,
		"preparation": preparation
	}

func _change_state(state_name):
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	if state_name in ["death"]:
		states_stack.push_back(states_map[state_name])
	._change_state(state_name)
	if state_name in ["death"]:
		_active = false

