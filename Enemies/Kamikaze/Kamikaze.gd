extends Enemy

const explosion_scene = preload("res://Enemies/Kamikaze/explosion/Explosion.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func explosion():
	var explosion: Ability = explosion_scene.instance()
	explosion.collision_mask = attack_collision_mask
	explosion.global_position = global_position
	explosion.damage = 5
	ObjectRegistry.register_ability(explosion)
