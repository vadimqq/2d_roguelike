extends Node2D

onready var player = $Player
onready var HUD = $UI/HUD
onready var inventory = $UI/Inventory
onready var _enemies = $Enimies

const evil_eye = preload("res://Enemies/EvilEye/EvilEye.tscn")
const clone = preload("res://Enemies/clone/clone.tscn")
const spawn_effect = preload("res://VFX/enemy_spawn_effect/enemy_spawn_effect.tscn")

var enemy_list = [
	evil_eye,
	clone
]

func _ready():
	HUD.initialize(player)
	inventory.initialize(player)
#	Events.connect("enemy_death", self, '_on_enemy_death')
