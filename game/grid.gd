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
	print(Vector2(2,1)/Vector2(2,2))
	pass

func pos_to_grid_coord( pixel_pos ):
	var real_pos = pixel_pos + global.BULLE_SIZE/2
	# if fits in a slot
	if( real_pos.x % global.BULLE_SIZE.x == 0 && real_pos.y % global.BULLE_SIZE.y == 0 ):
		# compute the slot
		return real_pos / global.BULLE_SIZE
	else:
		return null
		
func has_empty_slots_bellow( grid_pos ):
	var empty_slots_bellow = false
	if( grid_pos.y+1 != global.GRID_SIZE.y ):
		for y in range(grid_pos.y+1, global.GRID_SIZE.y ):
			if( y < 0 ):
				continue
			if( bulles[grid_pos.x][y] == null ):
				var empty_slots_bellow = true
				break
	
	return empty_slots_bellow

func get_airborne_bulles_in_column( column ):
	var airborne_bulles = []
	var empty_slot_scanned = false
	
	for y in range(global.GRID_SIZE.y, 0):
		if( bulles[column][y] == null ):
			empty_slot_scanned = true
		elif( bulles[column][y] != null && empty_slot_scanned ):
			airborne_bulles.append(bulles[column][y])
			
	return airborne_bulles