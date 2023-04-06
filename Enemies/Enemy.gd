extends KinematicBody2D
class_name Enemy

const floating_indicator = preload("res://VFX/floating_text/floating_indicator.tscn")

const _AUDIO_HIT_SAMPLES = [
	preload("res://Sounds/hit_sound/Hit_Hurt.wav"),
	preload("res://Sounds/hit_sound/Hit_Hurt2.wav"),
	preload("res://Sounds/hit_sound/Hit_Hurt3.wav"),
	preload("res://Sounds/hit_sound/Hit_Hurt4.wav"),
]

onready var stats: Stats = $Stats
onready var weapon_raycast: RayCast2D = $WeaponRaycast
onready var state_machine = $StateMachine
onready var collider = $CollisionShape2D
onready var effects_manager = $EffectsManager
onready var HUD = $EnemyHUD

export (int) var radius_attack = 100
export (int) var radius_chasing = 100

var velocity = Vector2.ZERO
var look_direction = Vector2.RIGHT setget set_look_direction
var player
var randomnum
var attack_collision_mask = 32

func set_look_direction(value):
	look_direction = value

func _ready():
	Events.connect("damaged", self, "_on_self_damaged")
	Events.connect("damaged_by_DOT", self, "_on_self_damaged")
	weapon_raycast.cast_to.x = radius_attack
	set_deferred('player', get_tree().get_nodes_in_group('Player')[0])
	HUD.initialize(self)

func _physics_process(delta):
	if weapon_raycast.transform.x.y < -0.65:
		weapon_raycast.show_behind_parent = true
	else:
		weapon_raycast.show_behind_parent = false
	if player:
		weapon_raycast.look_at(player.global_position)

func _on_self_damaged(target, damage, type):
	if not target == self:
		return
	set_deferred('player', get_tree().get_nodes_in_group('Player')[0])
	stats.modify_current_hit_point(-ceil(damage))
	var damage_popup = floating_indicator.instance()
	ObjectRegistry.register_effect(damage_popup)
	damage_popup.execute(self, ceil(damage))
	AudioBus.play_game_sound(_AUDIO_HIT_SAMPLES[randi() % _AUDIO_HIT_SAMPLES.size()])
	if has_node('Animation'):
		get_node('Animation').play("take_damage")
		
	if stats.current_hit_point <= 0:
		state_machine._change_state('death')

func emit_death():
	Events.emit_signal("enemy_death", self)
	call_deferred('queue_free')

func _on_DetectionZone_body_entered(body):
	set_deferred('player', body)
