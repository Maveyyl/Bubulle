extends Node2D


var bulles 

func _ready():
	bulles = []
	bulles.resize(global.GRID_SIZE.x)
	for x in range(global.GRID_SIZE.x):
		bulles[x] = []
		bulles[x].resize(global.GRID_SIZE.y)
	

func solve():
	var game = get_parent().get_parent()
	
	var neighbours = [null,null,null,null]
	for x in range(global.GRID_SIZE.x):
		for y in range(global.GRID_SIZE.y):
			if ( bulles[x][y] && bulles[x][y].type != global.BULLE_TYPES.BLACK ):
				for direction in range(global.DIRECTIONS.COUNT):
					neighbours[direction] = get_neighbour_slot( Vector2(x,y), direction )
				bulles[x][y].set_neighbours( neighbours )
	
	var score = 0
	
	var bulles_to_pop = []
	var bulles_to_pop_tmp
	for x in range(global.GRID_SIZE.x):
		for y in range(global.GRID_SIZE.y):
			if ( bulles[x][y] && bulles[x][y].type != global.BULLE_TYPES.BLACK && bulles[x][y].state != global.BULLE_STATES.POPPING):
				bulles_to_pop_tmp = bulles[x][y].explore_neighbourhood()
				if( bulles_to_pop_tmp.size() > 3 ):
					for bulleId in range(bulles_to_pop_tmp.size()):
						game.add_popping_bulle( bulles_to_pop_tmp[bulleId] )
					score += global.popping_score_compute(bulles_to_pop_tmp.size())
					
	return score
						
func solve_falling():
	var game = get_parent().get_parent()
	var should_fall = false
	for x in range(global.GRID_SIZE.x):
		should_fall = false
		
		for y in range(global.GRID_SIZE.y-1, 0, -1):
			if( !bulles[x][y] ):
				should_fall = true
			elif( should_fall ):
				game.add_falling_bulle(bulles[x][y], bulles[x][y].get_pos())
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
		