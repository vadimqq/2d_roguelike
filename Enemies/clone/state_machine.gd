extends StateMachine

onready var idle = $Idle
onready var move = $Move
onready var death = $Death
onready var attack = $Attack


func _ready():
	states_map = {
		"idle": idle,
		"move": move,
		"death": death,
		"attack": attack,
	}

func _change_state(state_name):
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	if state_name in ["death"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name)

