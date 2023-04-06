extends Node

const shop_location = preload("res://World/Rooms/Shop/Shop.tscn")

const field_location = preload("res://World/Rooms/Field/Field.tscn")

var room_list = [
	field_location,
]


func get_random_location_instance():
	randomize()
	return room_list[randi()%room_list.size()].instance()

func get_shop_location_instance():
	return shop_location.instance()
