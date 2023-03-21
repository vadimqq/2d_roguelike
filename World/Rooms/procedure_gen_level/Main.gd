extends Node2D

var Room = preload("res://src/levels/procedure_gen_level/Room.tscn")
const Shrine = preload("res://src/levels/buildings/shrines/big_shrine/item_shrine.tscn")
const Altar = preload("res://src/levels/buildings/altars/altar.tscn")
const Exit = preload("res://src/levels/procedure_gen_level/ExitDoor.tscn")
const Dummy = preload("res://src/enemies/dummy/dummy.tscn")
const Weapon_enchanter = preload("res://src/NPC/weapon_enchanter/weapon_enchanter.tscn")

const TEST = preload("res://src/levels/buildings/chest/chest.tscn")

onready var Map: TileMap = $TileMap
onready var Floor = $Floor
onready var Corridors = $Corridors
onready var UnderMap = $Undermap
onready var y_sort = $YSort
onready var Rooms = $Rooms

var tile_size = 32  # size of a tile in the TileMap
var num_rooms = 10  # number of rooms to generate
var min_size = 7  # minimum room size (in tiles)
var max_size = 8  # maximum room size (in tiles)
var hspread = 4  # horizontal spread (in pixels)
var cull = 0  # chance to cull room

var path  # AStar pathfinding object
var start_room = null
var end_room = null

var corridors_points = []


func add_player():
	y_sort.add_child(GAME_CORE.player)

func _ready():
	randomize()
	add_player()
	make_rooms()

func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(rand_range(-hspread, hspread), 0)
		var r = Room.instance()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
	# wait for movement to stop
	yield(get_tree().create_timer(1.1), 'timeout')
	# cull rooms
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector3(room.position.x, room.position.y, 0))
	yield(get_tree().create_timer(1.1), 'timeout')
	
	# generate a minimum spanning tree connecting the rooms
	path = find_mst(room_positions)
	make_map()
	generate_floor()
	generate_undermap()
	genetate_corridors()
	generate_altars()
	generate_dummy()
	generate_exit()

#FOR DEBUG!!!=======================================
#var font = preload("res://assets/RobotoBold120.tres")
#
#func _draw():
#	if start_room:
#		draw_string(font, start_room.position-Vector2(125,0), "start", Color(1,1,1))
#	if end_room:
#		draw_string(font, end_room.position-Vector2(125,0), "end", Color(1,1,1))
#	for room in $Rooms.get_children():
#		draw_rect(Rect2(room.position - room.size, room.size * 2),
#				 Color(0, 1, 0), false)
#	if path:
#		for p in path.get_points():
#			for c in path.get_point_connections(p):
#				var pp = path.get_point_position(p)
#				var cp = path.get_point_position(c)
#				draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y),
#						  Color(1, 1, 0), 15, true)
#
#func _process(delta):
#	update()
#==================================================

func reload_level():
	y_sort.remove_child(GAME_CORE.player)
	LOCATION_MANAGER.load_location(LOCATION_MANAGER.generate_level)

func _input(event):
	if event.is_action_pressed('ui_select'):
		for n in $Rooms.get_children():
			n.queue_free()
		path = null
		start_room = null
		end_room = null
		reload_level()

func find_mst(nodes):
	# Prim's algorithm
	# Given an array of positions (nodes), generates a minimum
	# spanning tree
	# Returns an AStar object
	
	# Initialize the AStar and add the first point
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	# Repeat until no more nodes remain
	while nodes:
		var min_dist = INF  # Minimum distance so far
		var min_p = null  # Position of that node
		var p = null  # Current position
		# Loop through points in path
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			# Loop through the remaining nodes
			for p2 in nodes:
				# If the node is closer, make it the closest
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
		# Insert the resulting node into the path and add
		# its connection
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		# Remove the node from the array so it isn't visited again
		nodes.erase(min_p)
	return path

func make_map():
	# Create a TileMap from the generated rooms and path
	Map.clear()
	find_start_room()
	find_end_room()
	
	var positions_tuple = get_start_end_map()
	
	for x in range(positions_tuple[0].x, positions_tuple[1].x):
		for y in range(positions_tuple[0].y, positions_tuple[1].y):
			Map.set_cell(x, y, 10)
	# Carve rooms
	var corridors = []  # One corridor per connection
	corridors_points.clear()
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor()
		var pos = Map.world_to_map(room.position)
		var ul = (room.position / tile_size).floor() - s
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):
				Map.set_cell(ul.x + x, ul.y + y, 1)
		# Carve connecting corridor
		var p = path.get_closest_point(Vector3(room.position.x, room.position.y, 0))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.world_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				var end = Map.world_to_map(Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y))
				carve_path(start, end)
		corridors.append(p)
	Map.update_bitmask_region(positions_tuple[0], positions_tuple[1])
	GAME_CORE.player.global_position = start_room.position

func carve_path(pos1, pos2):
	# Carve a path between two points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0: y_diff = pow(-1.0, randi() % 2)
	# choose either x/y or y/x
	var x_y = pos1
	var y_x = pos2
	if (randi() % 2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(x, x_y.y, 1)
		Map.set_cell(x, x_y.y + y_diff, 1)
		corridors_points.append(Vector2(x, x_y.y))
		corridors_points.append(Vector2(x, x_y.y + y_diff))
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(y_x.x, y, 1)
		Map.set_cell(y_x.x + x_diff, y, 1)
		corridors_points.append(Vector2(y_x.x, y))
		corridors_points.append(Vector2(y_x.x + x_diff, y))

func find_start_room():
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x

func find_end_room():
	var max_x = -INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x

func get_start_end_map():
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position-room.size, room.get_node("CollisionShape2D").shape.extents*2)
		full_rect = full_rect.merge(r)
	var topleft = Map.world_to_map(full_rect.position)
	var bottomright = Map.world_to_map(full_rect.end)
	
	return [topleft, bottomright]

func generate_floor():
	Floor.clear()
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor()
		var pos = Map.world_to_map(room.position)
		var ul = (room.position / tile_size).floor() - s
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):
				Floor.set_cell(ul.x + x, ul.y + y, 35)

func genetate_corridors():
	Corridors.clear()
	for point in corridors_points:
		Corridors.set_cell(point.x, point.y, 35)

func generate_undermap():
	UnderMap.clear()
	var positions_tuple = get_start_end_map()
	for x in range(positions_tuple[0].x, positions_tuple[1].x):
		for y in range(positions_tuple[0].y, positions_tuple[1].y):
			UnderMap.set_cell(x, y, 37)

func generate_altars():
	for room in $Rooms.get_children():
		if room != start_room && room != end_room:
			var instance = Altar.instance()
			y_sort.add_child(instance)
			instance.global_position = room.global_position

func generate_dummy():
	var instance = TEST.instance()
	y_sort.add_child(instance)
	instance.global_position = start_room.position

func generate_shrines():
	var random_rooms = []
	for room in $Rooms.get_children():
		if room != start_room && room != end_room:
			if randi()  % 100 + 1 < 15:
				random_rooms.append(room)
	place_object_in_rooms(Shrine, random_rooms)

func place_object_in_rooms(scene: PackedScene, rooms):
	for room in rooms:
		if !(room.position * 64).distance_to(GAME_CORE.player.global_position) < 128:
			var instance = scene.instance()
			y_sort.add_child(instance)
			instance.global_position = room.position

func generate_exit():
	var exit = Exit.instance()
	end_room.add_child(exit)
	exit.global_position = end_room.position
	exit.connect("leaving_level", self, "reload_level")

func generate_weapon_enchanter():
	var instance = Weapon_enchanter.instance()
	y_sort.add_child(instance)
	instance.global_position = start_room.position
	
