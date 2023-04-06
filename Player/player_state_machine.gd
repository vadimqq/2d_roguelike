extends StateMachine

onready var idle = $Idle
onready var move = $Move
onready var dash = $Dash
onready var death = $Death

func _ready():
	states_map = {
		"idle": idle,
		"move": move,
		"dash": dash,
		"death": death,
	}


func _change_state(state_name):
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	if state_name in ["dash", "death"]:
		states_stack.push_front(states_map[state_name])
#	if state_name == "jump" and current_state == move:
#		jump.initialize(move.speed, move.velocity)
	._change_state(state_name)

func _unhandled_input(event):
	# Here we only handle input that can interrupt states, attacking in this case,
	# otherwise we let the state node handle it.
	current_state.handle_input(event)

func _input(event):
	if event.is_action_released("attack") and owner.get_current_weapon():
		owner.get_current_weapon().cancel()
