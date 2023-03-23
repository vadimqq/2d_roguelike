extends Node2D

onready var sprite = $Sprite

func set_icon(tex: StreamTexture):
	sprite.texture = tex
