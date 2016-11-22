extends Node2D


var bulles 


func fromDictionnary( d ):
	for x in range(global.GRID_SIZE.x):
		for y in range(global.GRID_SIZE.y):
			if( d[x][y] ):
				bulles[x][y] = global.BULLE_SCENES[ d[x][y] ].instance()
				bulles[x][y].set_in_grid(Vector2(x,y))
			else:
				d[x][y] = null
	grid.compute_neighbours()
func toDictionnary():
	var bulles_data = []
	bulles_data.resize(global.GRID_SIZE.x)
	for x in range(global.GRID_SIZE.x):
		bulles_data[x] = []
		bulles_data[x].resize(global.GRID_SIZE.y)
		for y in range(global.GRID_SIZE.y):
			if( bulles[x][y] ):
				bulles_data[x] = bulles[x][y].type
	return {
		"bulles": bulles_data
	}


func _ready():
	bulles = []
	bulles.resize(global.GRID_SIZE.x)
	for x in range(global.GRID_SIZE.x):
		bulles[x] = []
		bulles[x].resize(global.GRID_SIZE.y)
	

func compute_neighbours():
	var neighbours = [null,null,null,null]
	for x in range(global.GRID_SIZE.x):
		for y in range(global.GRID_SIZE.y):
			if ( bulles[x][y] && bulles[x][y].type != global.BULLE_TYPES.BLACK ):
				for direction in range(global.DIRECTIONS.COUNT):
					neighbours[direction] = get_neighbour_slot( Vector2(x,y), direction )
				bulles[x][y].set_neighbours( neighbours )
func solve():
	compute_neighbours()
	var score = 0
	
	var bulles_to_pop = []
	var bulles_to_pop_tmp
	for x in range(global.GRID_SIZE.x):
		for y in range(global.GRID_SIZE.y):
			if ( bulles[x][y] && bulles[x][y].type != global.BULLE_TYPES.BLACK && bulles[x][y].state != global.BULLE_STATES.POPPING):
				bulles_to_pop_tmp = bulles[x][y].explore_neighbourhood()
				if( bulles_to_pop_tmp.size() > 3 ):
					for bulleId in range(bulles_to_pop_tmp.size()):
						bulles_to_pop_tmp[bulleId].set_popping()
					score += global.popping_score_compute(bulles_to_pop_tmp.size())
					
	return score
						
func solve_falling():
	var should_fall = false
	# for each column
	for x in range(global.GRID_SIZE.x):
		should_fall = false
		
		# for each slot of the column, starting from the bottom
		for y in range(global.GRID_SIZE.y-1, 0, -1):
			# if there's a slot empty, all elements in slots above should fall
			if( !bulles[x][y] ):
				should_fall = true
			# if slot is not empty and elements should fall
			elif( should_fall ):
				# tell elements it should fall and remove these elements from the grid
				bulles[x][y].set_falling()
				set_slot( Vector2(x,y), null)

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

func can_bulle_move_to( bulle, direction ):
	var bulle_grid_pos = pos_to_grid_coord(bulle.get_pos())
	var neighbour_slot_type = get_neighbour_slot_type( bulle_grid_pos, direction )
	return neighbour_slot_type == global.GRID_SLOT_TYPES.EMPTY
	


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
		