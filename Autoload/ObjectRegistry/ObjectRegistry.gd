extends Node

onready var _effects := $Effects
onready var _projectiles := $Projectiles
onready var _items := $items

func register_effect(effect: Node) -> void:
	_effects.add_child(effect)


func register_projectile(projectile: Node) -> void:
	_projectiles.add_child(projectile)


func register_item(item: Node) -> void:
	_items.add_child(item)

func unregister_item(item: Node) -> void:
	_items.remove_child(item)

func  unregister_all_items() -> void:
	for item in _items.get_children():
		_items.remove_child(item)

