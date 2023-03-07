extends State
class_name Enemy_motion
# Collection of important methods to handle direction and animation.
#signal use_attack

var velocity = Vector2()
var randomnum 

func _ready():
	randomize_direction()
#	connect("use_attack", owner, '_on_can_use_attack')

func get_direction():
	if owner.player:
		return get_circle_position(randomnum)
	else:
		return Vector2.ZERO


func update_look_direction(direction):
	if direction and owner.look_direction != direction:
		owner.look_direction = direction

func get_circle_position(random):
		var kill_circle_centre = owner.player.global_position
		 #Distance from center to circumference of circle

		var angle = random * PI * 2;
		var x = kill_circle_centre.x + cos(angle) * owner.radius_chasing;
		var y = kill_circle_centre.y + sin(angle) * owner.radius_chasing;
		return Vector2(x, y)

func randomize_direction():
	randomize()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
