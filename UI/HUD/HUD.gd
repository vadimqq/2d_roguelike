extends Control

onready var health_bar = $HealthBar
onready var mana_bar = $ManaBar
onready var dash_bar = $DashBar
onready var animation = $Animation
onready var coin_label = $Label

func initialize(player) -> void:
	health_bar.initialize(player)
	mana_bar.initialize(player)
	dash_bar.initialize(player)
	LootManager.connect("coins_amount_change", self, "_on_coins_amout_change")
	animation.play("idle")
	_on_coins_amout_change(LootManager.coins_amount)

func _on_coins_amout_change(amount):
	coin_label.text = str(amount)
