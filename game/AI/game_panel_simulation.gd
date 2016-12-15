extends Reference


var main_bulle = -1
var second_bulle = -1

var bulles = [[]]
var penalty_bulles = 0

var score = 0
var doublet_seed_ref = [0]
var penalty_seed_ref = [0]

func _init():
	bulles = []
	bulles.resize(global.GRID_SIZE.x)
	for x in range(global.GRID_SIZE.x):
		bulles[x] = []
		bulles[x].resize(global.GRID_SIZE.y)
		for y in range(global.GRID_SIZE.y):
			bulles[x][y] = -1

func fromDictionnary( d ):
	score = d.p2_score
	doublet_seed_ref = [d.p2_doublet_seed_ref[0]]
	penalty_seed_ref = [d.penalty_seed_ref[0]]
	
	penalty_bulles = d.game_panel_p2.penalty_bulles
	
	main_bulle = d.game_panel_p2.doublet.main_bulle
	second_bulle = d.game_panel_p2.doublet.second_bulle
	
	for x in range(global.GRID_SIZE.x):
		for y in range(global.GRID_SIZE.y):
			var idx = x * global.GRID_SIZE.y + y
			bulles[x][y] = d.game_panel_p2.grid.bulles[idx]
	
func generate_random_doublet():
	main_bulle = global.get_randi_update_seed(doublet_seed_ref)%(global.BULLE_TYPES.COUNT-1)
	second_bulle = global.get_randi_update_seed(doublet_seed_ref)%(global.BULLE_TYPES.COUNT-1)


func apply_gravity():
	var empty_index = -1
	for x in range(global.GRID_SIZE.x):
		empty_index = -1
		for y in range(global.GRID_SIZE.y-1,-1,-1):
			# find first empty slot
			if( empty_index == -1 && bulles[x][y] == -1 ):
				# memorize slot's index
				empty_index = y
			# once first empty slot has been found, find first non empty slot
			elif( empty_index != -1 && bulles[x][y] != -1):
				# swap it with the first empty slot
				bulles[x][empty_index] = bulles[x][y]
				bulles[x][y] = -1
				# slot on top of it is necessarily empty
				empty_index -=1


func get_neighbour_pos( pos, direction ):
	return pos + global.DIRECTIONS_NORMALS[direction]
func get_neighbour( pos, direction):
	var neighbour_pos = get_neighbour_pos(pos, direction)
	if( neighbour_pos.x < 0 ||
	neighbour_pos.y < 0 ||
	neighbour_pos.x >= global.GRID_SIZE.x ||
	neighbour_pos.y >= global.GRID_SIZE.y ):
		return -1
	else:
		return bulles[neighbour_pos.x][neighbour_pos.y]
func get_slot_type( pos ):
	if( pos.x < 0 ||
	pos.y < 0 ||
	pos.x >= global.GRID_SIZE.x ||
	pos.y >= global.GRID_SIZE.y ):
		return -2
	else:
		return bulles[pos.x][pos.y]
	
func solve():
	var solving_score = 0
	
	for x in range(global.GRID_SIZE.x):
		for y in range(global.GRID_SIZE.y):
			if( bulles[x][y] != -1 ):
				var type = bulles[x][y]
				var slots_to_pop = [ Vector2(x,y) ]
				var slots_to_explore = [ Vector2(x,y) ]
				var slots_explored = []
				
				while( !slots_to_explore.empty() ):
					var current_pos = slots_to_explore.pop_front()
					slots_explored.append(current_pos)
					for d in range(global.DIRECTIONS.COUNT):
						var neighbour_pos = get_neighbour_pos(current_pos,d)
						var neighbour_type = get_slot_type( neighbour_pos )
						if( neighbour_type == type && !slots_explored.has(neighbour_pos)):
							slots_to_pop.append( neighbour_pos )
							slots_to_explore.append( neighbour_pos )
				
				if( slots_to_pop.size() > 3 ):
					solving_score += global.popping_score_compute(slots_to_pop.size())
					for i in range(slots_to_pop.size()):
						var pos = slots_to_pop[i]
						bulles[pos.x][pos.y] = -1
	
	return solving_score


func place_doublet( goal_pos ):
	var stop = false
	var horizontally_placed = false
	var vertically_placed = false
	
	var main_bulle_pos = global.DOUBLET_DEFAULT_GRID_POS
	var second_bulle_pos = global.DOUBLET_DEFAULT_GRID_POS + global.DIRECTIONS_NORMALS[ global.DIRECTIONS.TOP ]
	var second_bulle_state = global.DIRECTIONS.TOP

	while( !stop ):
		if( second_bulle_state != goal_pos[1] ):
			var sens = get_rot_sens(second_bulle_state, goal_pos[1], global.DIRECTIONS.COUNT)
			var futur_state = ((second_bulle_state + ( 1 if sens else -1 ))+global.DIRECTIONS.COUNT)%global.DIRECTIONS.COUNT
			var futur_pos = get_neighbour_pos(main_bulle_pos, futur_state)
			var futur_pos_slot_type = get_slot_type( futur_pos )
			if( futur_pos_slot_type == -1 ):
				second_bulle_state = futur_state
				second_bulle_pos = futur_pos
			else:
				vertically_placed = true
		else:
			vertically_placed = true
			
		if( vertically_placed ): 
			var direction
			if( main_bulle_pos.x != goal_pos[0] ):
				if( main_bulle_pos.x > goal_pos[0] ):
					direction = global.DIRECTIONS.LEFT
				elif ( main_bulle_pos.x < goal_pos[0] ):
					direction = global.DIRECTIONS.RIGHT
				var main_futur_pos = get_neighbour_pos(main_bulle_pos, direction)
				var futur_pos_slot_type = get_slot_type( main_futur_pos )
				var second_futur_pos = get_neighbour_pos(second_bulle_pos, direction)
				var second_futur_pos_slot_type = get_slot_type( second_futur_pos )
				if( futur_pos_slot_type == -1 && second_futur_pos_slot_type == -1):
					main_bulle_pos.x = main_futur_pos.x
					second_bulle_pos.x = second_futur_pos.x
				else:
					horizontally_placed = true
			else:
				horizontally_placed = true
	
		if( vertically_placed && horizontally_placed ):
			stop = true
			bulles[main_bulle_pos.x][main_bulle_pos.y] = main_bulle
			bulles[second_bulle_pos.x][second_bulle_pos.y] = second_bulle
	
	apply_gravity()



func simulate_one_step():
	var combo_count = 0
	var cumulative_score = 0
	var keep_solving = true
	

	while( keep_solving ):
		keep_solving = false
		
		var solving_score = solve()
		if( solving_score > 0 ):
			combo_count += 1
			cumulative_score += global.popping_combo_score_compute( solving_score, combo_count)
			keep_solving = true
		else:
			score += cumulative_score
		apply_gravity()
	
func simulate_solution( solution ):
	var base_score = score
	for i in range(0, solution.size(), 2):
		if( i != 0 ):
			generate_random_doublet()
		place_doublet( [solution[i], solution[i+1] ] )
		simulate_one_step()
		
	var updated_score = score - base_score
	return updated_score



func get_rot_sens( a, b, ring_size):
	return ((a-b)+ring_size)%ring_size > (ring_size/2)