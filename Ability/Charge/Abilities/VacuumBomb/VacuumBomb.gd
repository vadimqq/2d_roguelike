extends Charge


export (float) var max_speed := 400.0
export (float) var min_speed := 100.0
var speed = 0
var max_dmage = damage

onready var hit_box = $HitBox
onready var hit_box_collider = $HitBox/CollisionShape2D
onready var sprite = $Sprite
onready var enemy_detector = $EnemyDetector
onready var enemy_detector_collider = $EnemyDetector/CollisionShape2D
onready var animation = $Animation

var direction = Vector2.ZERO
var enemy_in_collider = []

func _ready():
	max_dmage = damage
	hit_box.collision_mask = collision_mask
	enemy_detector.collision_mask = collision_mask
	tween.interpolate_property(hit_box, "scale", Vector2(0.2, 0.2), Vector2(1, 1), max_charge_duration)
	tween.interpolate_property(self, "speed", min_speed, max_speed, max_charge_duration)
	tween.interpolate_property(self, "scale", Vector2(0.2, 0.2), Vector2(1, 1), max_charge_duration)
	tween.interpolate_property(self, "damage", 1, max_dmage, max_charge_duration)
	tween.start()


func _on_VacuumBomb_execute_charge():
	direction = Vector2(1, 0).rotated(rotation)
	hit_box_collider.set_deferred('disabled', false)


func _physics_process(delta):
	if is_ready:
		position += direction * speed * delta
		for enemy in enemy_in_collider:
			enemy.move_and_slide((global_position - enemy.global_position) * 5)


func _on_HitBox_body_entered(body):
	speed = 0
	animation.play("explosion")
#	Events.emit_signal("ability_hit", self)
#	is_ready = false
##	var explosion: Ability = explosion_scene.instance()
##	explosion.collision_mask = collision_mask
##	explosion.global_position = global_position
##	explosion.scale *= power_percent / 100
##	explosion.scale_modifier = scale_modifier
##	explosion.damage = damage
##	ObjectRegistry.register_ability(explosion)
#	call_deferred('die')
#




func _on_EnemyDetector_body_entered(body):
	if body is KinematicBody2D:
		enemy_in_collider.append(body)


func _on_EnemyDetector_body_exited(body):
	enemy_in_collider.erase(body)
