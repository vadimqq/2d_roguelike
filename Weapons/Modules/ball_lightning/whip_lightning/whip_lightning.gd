extends Node2D


onready var raycast = $RayCast2D
onready var beam_effect = $RayCast2D/ColorRect
onready var tween := $Tween
onready var detection_zone = $DetectionZone
onready var detection_zone_collider = $DetectionZone/CollisionShape2D
onready var hit_cooldown = $HitCooldown

export var radius = 90
export (float) var cooldown = 1.0

var damage = 0
var collision_mask = 1

var current_target_position = null
var target_list = []
var hited_target_list = []

func _ready():
	detection_zone.collision_mask = collision_mask
	raycast.collision_mask = collision_mask
	hit_cooldown.wait_time = cooldown

func _process(delta):
	beam_effect.rect_size = Vector2(raycast.cast_to.x, 70)
	if hit_cooldown.is_stopped():
		if target_list.size() > 0:
			var temp_target = target_list[0]
			current_target_position = temp_target.global_position
			target_list.erase(temp_target)
			hited_target_list.push_back(temp_target)
			hit_cooldown.start()
			cast()
		if hited_target_list.size() > 0:
			var temp_target = hited_target_list[0]
			current_target_position = temp_target.global_position
			hited_target_list.erase(temp_target)
			target_list.push_back(temp_target)
			hit_cooldown.start()
			cast()

	if current_target_position:
		raycast.look_at(current_target_position)

	if raycast.is_colliding():
		Events.emit_signal("damaged",raycast.get_collider(), damage, Const.DamageType.MANA)
		cast_down()


func _on_DetectionZone_body_entered(body):
	target_list.push_back(body)

func _on_DetectionZone_body_exited(body):
	if target_list.has(body):
		target_list.erase(body)
	if hited_target_list.has(body):
		hited_target_list.erase(body)


func _on_spectate(projectile):
	global_position = projectile.global_position

func _on_hit(projectile):
	call_deferred('queue_free')


func _on_HitCooldown_timeout():
	current_target_position = null

func cast_down():
	raycast.enabled = false
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(
		raycast, "cast_to", raycast.cast_to, Vector2.ZERO, cooldown / 4, Tween.EASE_IN, Tween.EASE_OUT)
	tween.start()

func cast():
	raycast.enabled = true
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(
		raycast, "cast_to", Vector2.ZERO, Vector2(radius, 0), cooldown / 4, Tween.EASE_IN, Tween.EASE_OUT)
	tween.start()

