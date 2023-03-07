extends Node

const field_location = preload("res://World/Rooms/Field/Field.tscn")
const shop_location = preload("res://World/Rooms/Shop/Shop.tscn")

var room_list = [
	field_location,
	shop_location
]


func get_random_location_instance():
	randomize()
	return room_list[randi()%room_list.size()].instance()
