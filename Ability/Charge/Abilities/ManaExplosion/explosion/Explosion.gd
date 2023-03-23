extends Ability

onready var animation = $Animation
onready var hit_box_collider = $HitBox/CollisionShape2D

func _ready():
	animation.play("explosion")

func _on_Animation_animation_finished(anim_name):
	call_deferred('queue_free')


func _on_Area2D_body_entered(body):
	Events.emit_signal("damaged", body, damage, damage_tag)
