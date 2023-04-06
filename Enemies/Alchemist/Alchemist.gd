extends Enemy

onready var projectile = preload("res://Enemies/Alchemist/ability/AlchemistBomb.tscn")

onready var attack_cooldown := $AttackTimer
onready var spawn_position = $WeaponRaycast/SpawnPosition

func attack():
	var ability: Projectile = projectile.instance()
	ability.collision_mask = attack_collision_mask
	ability.global_position = spawn_position.global_position
	ability.executor = self
	ability.damage = self.stats.get_modified_damage(ability.damage, ability.damage_tag)
	ability.global_rotation = weapon_raycast.global_rotation
	ObjectRegistry.register_ability(ability)
	ability.execute()
