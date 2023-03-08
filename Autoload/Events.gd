extends Node

signal projectile_hit(projectile)
signal projectile_die(projectile)
signal projectile_cast(projectile)
signal projectile_process(projectile, disatnce)
signal player_cast_dash(player)
signal player_end_dash(player)

signal damaged(target, damage, type)
signal damaged_by_DOT(target, damage, type)
signal enemy_death(enemy)
signal boss_death

#signal node_spawned(node)

enum UpgradeChoices { HEALTH, SPEED, CARGO, MINING, WEAPON }

enum UITypes { UPGRADE, QUIT }
