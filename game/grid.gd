extends Node2D


var bulles 

func _ready():
	bulles = []
	bulles.resize(global.GRID_SIZE.x)
	for x in range(global.GRID_SIZE.x):
		bulles[x] = []
		bulles[x].resize(global.GRID_SIZE.y)
	
	fixed_process(true)
	
func fixed_process(delta):
	pass

func solve():
	var neighbours = [null,null,null,null]
	for x in range(global.GRID_SIZE.x):
		for y in range(global.GRID_SIZE.y):
			if ( bulles[x][y] ):
				for direction in range(global.DIRECTIONS.COUNT):
					neighbours[direction] = get_neighbour_slot( Vector2(x,y), direction )
				bulles[x][y].set_neighbours( neighbours )
	
	
func add_bulle( bulle, grid_pos ):
	bulle.get_parent().remove_child(bulle)
	add_child(bulle)
	bulle.set_pos( grid_coord_to_pos( grid_pos ) )
	set_slot( grid_pos, bulle)
	bulle.state = global.BULLE_STATES.IN_GRID
	

func set_slot( grid_pos, item):
	bulles[grid_pos.x][grid_pos.y] = item
func get_slot( grid_pos ):
	return bulles[grid_pos.x][grid_pos.y]
func get_neighbour_grid_pos( grid_pos, direction ):
	return grid_pos + global.DIRECTIONS_NORMALS[direction]
func get_neighbour_slot_type( grid_pos, direction ):
	var slot_type
	var neighbour_grid_pos = get_neighbour_grid_pos( grid_pos, direction )
	
	if( neighbour_grid_pos.x < 0 ||
	neighbour_grid_pos.y < 0 ||
	neighbour_grid_pos.x+1 > global.GRID_SIZE.x ||
	neighbour_grid_pos.y+1 > global.GRID_SIZE.y ):
		slot_type=  global.GRID_SLOT_TYPES.WALL
	elif( get_slot(neighbour_grid_pos) != null ):
		slot_type= global.GRID_SLOT_TYPES.BULLE
	else:
		slot_type= global.GRID_SLOT_TYPES.EMPTY

	return slot_type

func get_neighbour_slot( grid_pos, direction):
	var neighbour_grid_pos = get_neighbour_grid_pos( grid_pos, direction )
	
	if( neighbour_grid_pos.x < 0 ||
	neighbour_grid_pos.y < 0 ||
	neighbour_grid_pos.x+1 > global.GRID_SIZE.x ||
	neighbour_grid_pos.y+1 > global.GRID_SIZE.y ):
		return null
	else:
		return get_slot( neighbour_grid_pos )




func pos_to_grid_coord( pixel_pos ):
	var real_pos = pixel_pos - global.BULLE_SIZE/2
	var grid_pos
	# if fits in a slot
	if( int(real_pos.x) % int(global.BULLE_SIZE.x) == 0 && int(real_pos.y) % int(global.BULLE_SIZE.y) == 0 ):
		# compute the slot
		grid_pos = real_pos / global.BULLE_SIZE
	else:
#		real_pos.y = real_pos.y - global.BULLE_SIZE.y/2
		real_pos.y = int(real_pos.y) -int(real_pos.y) % int(global.BULLE_SIZE.y)
		grid_pos = real_pos / global.BULLE_SIZE

	return grid_pos.snapped(Vector2(1,1))
	
func grid_coord_to_pos( grid_coord ):
	return grid_coord * global.BULLE_SIZE + global.BULLE_SIZE/2
		
#func has_empty_slots_bellow( grid_pos ):
#	var empty_slots_bellow = false
#	if( grid_pos.y+1 != global.GRID_SIZE.y ):
#		for y in range(grid_pos.y+1, global.GRID_SIZE.y ):
#			if( y < 0 ):
#				continue
#			if( bulles[grid_pos.x][y] == null ):
#				empty_slots_bellow = true
#				break
#	
#	return empty_slots_bellow
#	
#func get_empty_slots_bellow_count( grid_pos ):
#	var empty_slots_count = 0
#	if( grid_pos.y+1 != global.GRID_SIZE.y ):
#		for y in range(grid_pos.y+1, global.GRID_SIZE.y ):
#			if( y < 0 ):
#				continue
#			if( bulles[grid_pos.x][y] == null ):
#				empty_slots_count +=1
#	return empty_slots_count
		
