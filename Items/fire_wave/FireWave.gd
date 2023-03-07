extends Item

var explosion_node = preload("res://Weapons/Modules/hit_echo/explosion/explosion.tscn")

export var damage  = 5

func add_effect(player):
	Events.connect("player_end_dash",self, "_on_end_dash")

func _on_end_dash(player):
	var explosion = explosion_node.instance()
	explosion.damage = player.stats.get_modified_damage(damage, Const.DamageType.FIRE)
	explosion.scale = Vector2(1, 1)
	explosion.global_transform = player.global_transform
	explosion.collision_mask = 64
	ObjectRegistry.register_projectile(explosion)

