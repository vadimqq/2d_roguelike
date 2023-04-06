extends Channel

export var speed := 400.0
export var max_length := 200.0
export var growth_time := 0.1
export var rebound := 0

onready var beam: RayCast2D = $Beam
onready var fill := $Beam/Line2D
onready var tween := $Beam/Tween
onready var casting_particles := $Beam/CastingParticles
onready var collision_particles := $Beam/CollisionParticles
onready var beam_particles := $Beam/BeamParticles

onready var line_width: float = fill.width

func _ready():
	scale = Vector2(1, 1)
	max_length *= scale_modifier
func _physics_process(delta: float) -> void:
	if is_casting:
		cast_beam(delta)


func cast_beam(delta) -> void:
	beam.cast_to = (beam.cast_to + Vector2.RIGHT * speed * delta).limit_length(max_length)
	var cast_point = beam.cast_to
	beam.force_raycast_update()
	if beam.is_colliding():
		cast_point = to_local(beam.get_collision_point())
		if tick_timer.is_stopped():
			emit_signal("damage_tick")
			Events.emit_signal("damaged", beam.get_collider(), damage, Const.DAMAGE_TAG.MANA)
			tick_timer.wait_time = cooldown
			tick_timer.start()
			if not enemy_in_collider.has(beam.get_collider()):
				enemy_in_collider.push_back(beam.get_collider())
		collision_particles.process_material.direction = Vector3(beam.get_collision_normal().x, beam.get_collision_normal().y, 0)
	else:
		enemy_in_collider = []
	collision_particles.emitting = beam.is_colliding()
	fill.points[1] = cast_point
	collision_particles.position = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5


func appear() -> void:
	beam.cast_to = Vector2.ZERO
	beam.enabled = true
	fill.points[1] = Vector2.ZERO
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", 0, line_width, growth_time * 2)
	tween.start()
	casting_particles.emitting = true
	beam_particles.emitting = true
	is_casting = true


func disappear() -> void:
	beam.enabled = false
	beam.cast_to = Vector2.ZERO
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", fill.width, 0, growth_time)
	tween.start()
	
	casting_particles.emitting = false
	beam_particles.emitting = false
	collision_particles.emitting = false
	is_casting = false
	
	yield(get_tree().create_timer(growth_time * 8), "timeout")
	call_deferred('queue_free')
