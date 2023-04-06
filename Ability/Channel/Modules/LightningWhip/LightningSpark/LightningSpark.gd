extends Projectile

const trail_effect = preload("res://Ability/Channel/Modules/LightningWhip/LightningSpark/TrailEffect/TrailEffect.tscn")

onready var detector = $Detector

var trail_effect_instance = null

func _ready():
	trail_effect_instance = trail_effect.instance()
	ObjectRegistry.register_effect(trail_effect_instance)
	connect("tree_exiting", trail_effect_instance, '_stop_draw')

func _process(delta):
	if trail_effect_instance:
		trail_effect_instance.global_position = global_position


func set_target(target):
	detector._target = target
