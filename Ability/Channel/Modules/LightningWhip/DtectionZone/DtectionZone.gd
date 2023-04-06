extends Area2D

const spark = preload("res://Ability/Channel/Modules/LightningWhip/LightningSpark/LightningSpark.tscn")

onready var collider = $CollisionShape2D

var chance = 10
var increase_radius = 1
var increase_damage = 1

var owner_ability: Channel
var enemy_in_collider := []

func _ready():
	owner_ability = find_parent('*')
	owner_ability.connect('disappear', self, '_on_disappear')
	owner_ability.connect('damage_tick', self, '_on_damage_tick')
	collision_mask = owner_ability.collision_mask
	scale *= increase_radius

func _process(delta):
	if owner_ability.enemy_in_collider.size() > 0:
		global_position = owner_ability.enemy_in_collider[0].global_position
		collider.disabled = false

func _on_DtectionZone_body_entered(body):
	if owner_ability.enemy_in_collider.size() > 0 and body != owner_ability.enemy_in_collider[0]:
		enemy_in_collider.append(body)


func _on_DtectionZone_body_exited(body):
	if enemy_in_collider.has(body):
		enemy_in_collider.erase(body)

func _on_disappear():
	call_deferred('queue_free')

func _on_damage_tick():
	if enemy_in_collider.size() == 0:
		return
	randomize()
	var rand_num = rand_range(0, 100)
	if chance > rand_num:
		var random_target = enemy_in_collider[randi() % enemy_in_collider.size()]
		var spark_incstance: Projectile = spark.instance()
		spark_incstance.collision_mask = owner_ability.collision_mask
		spark_incstance.rotation = random_target.global_position.angle_to_point(global_position)
		spark_incstance.global_position = global_position.linear_interpolate(random_target.global_position, 0.3)
		spark_incstance.damage *= increase_damage
		ObjectRegistry.register_ability(spark_incstance);
		spark_incstance.set_target(random_target)
