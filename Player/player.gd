extends KinematicBody2D
class_name Player

const floating_indicator = preload("res://VFX/floating_text/floating_indicator.tscn")


const _AUDIO_HIT_SAMPLES = [
	preload("res://Sounds/hit_sound/Hit_Hurt.wav"),
	preload("res://Sounds/hit_sound/Hit_Hurt2.wav"),
	preload("res://Sounds/hit_sound/Hit_Hurt3.wav"),
	preload("res://Sounds/hit_sound/Hit_Hurt4.wav"),
]


onready var sprite = $Sprite
onready var weapon_raycast = $WeaponRaycast
onready var animation_tree = $AnimationTree
onready var animation = $AnimationPlayer
onready var stats = $Stats
onready var camera = $Camera2D
onready var pickup_zone = $PickupZone
onready var state_machine = $StateMachine
onready var item_inventory = $ItemInventory
onready var effects_manager = $EffectsManager
onready var collider = $CollisionShape2D

var module_inventory_arr := []
var weapon_inventory_arr := []

var attack_collision_mask = 64
var look_direction = Vector2.RIGHT setget set_look_direction
var items_in_range = {}
export (int) var inventory_size = 100

func _ready():
	Events.connect("damaged", self, "_on_self_damaged")
	Events.connect("damaged_by_DOT", self, "_on_self_damaged")
	Events.connect("boss_death", self, '_test_restore')


func set_look_direction(value):
	look_direction = value

func _physics_process(delta):
	weapon_raycast.look_at(get_global_mouse_position())
	animation_tree.set("parameters/Idle/blend_position", get_global_mouse_position() - global_position)
	animation_tree.set("parameters/Walk/blend_position", get_global_mouse_position() - global_position)
	
	if weapon_raycast.transform.x.y < -0.65:
		weapon_raycast.show_behind_parent = true
	else:
		weapon_raycast.show_behind_parent = false
	
	if Input.is_action_pressed("action"):
		if items_in_range.size() > 0:
			var pickup_item = items_in_range.values()[0]
			take_item(pickup_item)
			items_in_range.erase(pickup_item)
			

func take_item(item: Node2D):
	if item is Module:
		module_inventory_arr.push_back(item)
		ObjectRegistry.unregister_item(item)
		return
	elif item is Weapon:
		ObjectRegistry.unregister_item(item)
		weapon_inventory_arr.push_back(item)
		return
	elif item is Item:
		ObjectRegistry.unregister_item(item)
		item_inventory.add_child(item)
		item.add_effect(self)
		item.visible = false
		return



func _on_self_damaged(target, damage, type):
	if not target == self:
		return
	stats.modify_current_hit_point(-ceil(damage))
	var damage_popup = floating_indicator.instance()
	ObjectRegistry.register_effect(damage_popup)
	damage_popup.execute(self, ceil(damage))
	animation.play("take_damage")
	frameFreeze(0.05, 0.7)
	AudioBus.play_game_sound(_AUDIO_HIT_SAMPLES[randi() % _AUDIO_HIT_SAMPLES.size()])
	if stats.current_hit_point <= 0:
		state_machine._change_state('death')

func get_current_weapon():
	if weapon_raycast.get_child_count() > 0:
		return weapon_raycast.get_child(0)
	else:
		return null

func _on_PickupZone_area_entered(area):
	items_in_range[area.owner] = area.owner

func _on_PickupZone_area_exited(area):
	if items_in_range.has(area.owner):
		items_in_range.erase( area.owner)


func frameFreeze(time_scale, duration):
	Engine.time_scale = time_scale
	yield(get_tree().create_timer(duration * time_scale), "timeout")
	Engine.time_scale = 1

func _test_restore():
	stats.modify_current_hit_point(20)

func end_game():
	Events.go_to_end_game_screen()


func set_new_weapon(new_weapon):
	var player_weapon: Weapon = get_current_weapon()
	weapon_raycast.remove_child(player_weapon)
	weapon_inventory_arr.append(player_weapon)
	reamove_weapon_stats(player_weapon)
	
	weapon_inventory_arr.erase(new_weapon)
	weapon_raycast.add_child(new_weapon)
	new_weapon.initialize(self)
	add_weapon_stats(new_weapon)

func add_weapon_stats(weapon: Weapon):
	var affix_dict: Dictionary = weapon.affix_ist.get_affix_dict()
	stats.modyfy_stats(affix_dict)

func reamove_weapon_stats(weapon: Weapon):
	var affix_dict: Dictionary = weapon.affix_ist.get_affix_dict()
	for key in affix_dict.keys():
		affix_dict[key] = -affix_dict.get(key)

	stats.modyfy_stats(affix_dict)
