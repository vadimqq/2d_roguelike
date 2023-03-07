extends StateMachine

onready var idle = $Idle
onready var move = $Move
onready var death = $Death
onready var attack_1 = $Attack_1
onready var attack_2 = $Attack_2
onready var attack_3 = $Attack_3


func _ready():
	states_map = {
		"idle": idle,
		"move": move,
		"death": death,
		"attack_1": attack_1,
		"attack_2": attack_2,
		"attack_3": attack_3,
	}

func _change_state(state_name):
	if not _active:
		return
	if state_name in ["death"]:
		states_stack.push_back(states_map[state_name])
	._change_state(state_name)
	if state_name in ["death"]:
		_active = false

