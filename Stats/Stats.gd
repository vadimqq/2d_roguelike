extends Node
class_name Stats

signal stat_changed

onready var regen_timer = $RegenTimer
onready var dash_cooldown_timer = $DashTimer

export (int) var hit_point = 100
export (int) var hit_point_regen = 0
export (int) var mana_point = 100
export (int) var mana_point_regen = 10

export(int) var max_move_speed = 100
export(int) var min_move_speed = 50

export (int) var increase_hit_point = 0
export (int) var increase_hit_point_regen = 0
export (int) var increase_mana_point = 0
export (int) var increase_mana_point_regen = 0
export (int, 90) var increase_attack_speed = 0


export (float) var dash_cooldown = 2
export (int) var max_dash_count = 2
var current_dash_count = max_dash_count


export (int) var increase_mana_damage = 0
export (int) var increase_fire_damage = 0
export (int) var increase_poision_damage = 0
export (int) var increase_holy_damage = 0
export (int) var increase_shadow_damage = 0
export (int) var increase_ligthning_damage = 0
export (int) var increase_physic_damage = 0



var current_hit_point = 0
var current_mana_point = 0

func _ready():
	restore_all_stats()

func get_max_hit_point():
	return MathUtils.get_incremented_value(hit_point, increase_hit_point, 0)

func get_hit_point_regen():
	return MathUtils.get_incremented_value(hit_point_regen, increase_hit_point_regen, 0)

func get_max_mana_point():
	return MathUtils.get_incremented_value(mana_point, increase_mana_point, 0)

func get_mana_point_regen():
	return MathUtils.get_incremented_value(mana_point_regen, increase_mana_point_regen, 0)

func get_max_move_speed():
	return max_move_speed

func get_min_move_speed():
	return min_move_speed

func get_modified_damage(damage, type):
	match type:
		Const.DamageType.MANA:
			return MathUtils.get_incremented_value(damage, increase_mana_damage, 0)
		Const.DamageType.FIRE:
			return MathUtils.get_incremented_value(damage, increase_fire_damage, 0)
		Const.DamageType.POISION:
			return MathUtils.get_incremented_value(damage, increase_poision_damage, 0)
		Const.DamageType.PHYSIC:
			return MathUtils.get_incremented_value(damage, increase_physic_damage, 0)
		Const.DamageType.LIGTHNING:
			return MathUtils.get_incremented_value(damage, increase_ligthning_damage, 0)
		Const.DamageType.SHADOW:
			return MathUtils.get_incremented_value(damage, increase_shadow_damage, 0)
		Const.DamageType.HOLY:
			return MathUtils.get_incremented_value(damage, increase_holy_damage, 0)
	return damage

func get_cooldown_by_modifire(cooldown):
	
	return cooldown - cooldown * (float(increase_attack_speed) / 100)

func modify_current_hit_point(amount):
	if current_hit_point + int(amount) > get_max_hit_point():
		current_hit_point = get_max_hit_point()
	elif current_hit_point + int(amount) <= 0:
		current_hit_point = 0
	else:
		current_hit_point += int(amount)

	emit_signal('stat_changed', self)

func modify_current_mana_point(amount):
	if current_mana_point + int(amount) > get_max_mana_point():
		current_mana_point = get_max_mana_point()
	elif current_mana_point + int(amount) <= 0:
		current_mana_point = 0
	else:
		current_mana_point += int(amount)
	
	emit_signal('stat_changed', self)

func _on_RegenTimer_timeout():
	modify_current_mana_point(get_mana_point_regen())
	modify_current_hit_point(get_hit_point_regen())

func modyfy_stats(dict: Dictionary):
	for i in dict:
		self[i] += dict[i]

	emit_signal('stat_changed', self)
	if increase_attack_speed > 90:
		increase_attack_speed = 90
	

func restore_all_stats():
	current_hit_point = get_max_hit_point()
	current_mana_point = get_max_mana_point()

func modify_dash_count(amount):
	current_dash_count += amount
	if current_dash_count < max_dash_count:
		dash_cooldown_timer.wait_time = dash_cooldown
		dash_cooldown_timer.start()
	else:
		dash_cooldown_timer.stop()
	emit_signal('stat_changed', self)


func _on_DashTimer_timeout():
	modify_dash_count(1)
