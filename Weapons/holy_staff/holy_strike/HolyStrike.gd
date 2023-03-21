extends Projectile

onready var animation = $Animation
onready var master_pivot = $MasterPivot
onready var trail_1 = $MasterPivot/TrailPivot_1/Line2D
onready var trail_2 = $MasterPivot/TrailPivot_2/Line2D
onready var trail_3 = $MasterPivot/TrailPivot_3/Line2D
onready var trail_4 = $MasterPivot/TrailPivot_4/Line2D


func _ready():
	trail_1.width *= scale_modifier
	trail_2.width *= scale_modifier
	trail_3.width *= scale_modifier
	trail_4.width *= scale_modifier
	
	animation.play("cast")
