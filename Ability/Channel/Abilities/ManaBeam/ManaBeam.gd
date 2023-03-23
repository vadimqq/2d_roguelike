extends Channel

export var cast_speed := 400.0
export var max_length := 500.0
export var growth_time := 0.1


onready var beam: RayCast2D = $Beam
onready var fill := $Beam/Line2D
onready var tween := $Beam/Tween
onready var casting_particles := $CastingParticles
onready var collision_particles := $CollisionParticles
onready var beam_particles := $BeamParticles

onready var line_width: float = fill.width


func _physics_process(delta: float) -> void:
	if is_casting:
		beam.cast_to = (beam.cast_to + Vector2.RIGHT * cast_speed * delta).clamped(max_length)
		cast_beam()


func cast_beam() -> void:
	var cast_point = beam.cast_to
	beam.force_raycast_update()
	if beam.is_colliding():
		cast_point = to_local(beam.get_collision_point())
		if tick_timer.is_stopped():
			Events.emit_signal("damaged", beam.get_collider(), damage, Const.DamageType.MANA)
			tick_timer.wait_time = cooldown
			tick_timer.start()
		collision_particles.process_material.direction = Vector3(beam.get_collision_normal().x, beam.get_collision_normal().y, 0)
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

