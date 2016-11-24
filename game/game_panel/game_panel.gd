extends Node2D

onready var panel = get_node("panel")
onready var grid = get_node("panel/grid")

var state = global.GAME_PANEL_STATES.IDLE

var doublet_default_pos = Vector2( (1+global.GRID_SIZE.x/2) * global.BULLE_SIZE.x , global.BULLE_SIZE.y * 2 ) -  global.BULLE_SIZE/2
var doublet

var falling_bulles = []

var popping_bulle_count = 0

signal score(score)
var cumulative_score = 0
var combo_count = 0

var received_penalty = false
var penalty_bulles = 0

func fromDictionnary(d):
	for i in range(falling_bulles.size()):
		panel.remove_child(falling_bulles[i])
	falling_bulles = []
	popping_bulle_count = 0
	
	
	state = d.state
	grid.fromDictionnary(d.grid)
	if( d.has("doublet") ):
		if( doublet == null ):
			doublet = global.SCENES.DOUBLET.instance()
			panel.add_child(doublet)
		doublet.fromDictionnary( d.doublet )
		doublet.grid = grid
		add_bulle_to_game( doublet.main_bulle )
		add_bulle_to_game( doublet.second_bulle )
	elif( doublet != null):
		if( doublet.get_parent() ):
			doublet.get_parent().remove_child(doublet)
		doublet = null
		
	for i in range(d.falling_bulles.size()):
		var bulle = global.BULLE_SCENES[ d.falling_bulles[i].type ].instance()
		bulle.fromDictionnary( d.falling_bulles[i] )
		add_bulle_to_game( bulle )
		add_falling_bulle( bulle )

	popping_bulle_count = d.popping_bulle_count
	cumulative_score = d.cumulative_score
	combo_count = d.combo_count
	received_penalty = d.received_penalty
	penalty_bulles = d.penalty_bulles
func toDictionnary():
	var falling_bulles_data = []
	for i in range(falling_bulles.size()):
		falling_bulles_data.append( falling_bulles[i].toDictionnary() )

	var data = {
		"state": state,
		"grid": grid.toDictionnary(),
#		"doublet": doublet.toDictionnary(),
		"falling_bulles": falling_bulles_data,
		"popping_bulle_count": popping_bulle_count,
		"cumulative_score": cumulative_score,
		"combo_count": combo_count,
		"received_penalty": received_penalty,
		"penalty_bulles": penalty_bulles
	}
	if( doublet != null ):
		data.doublet = doublet.toDictionnary()
	
	return data


func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	# if a doublet has been placed or if was in falling bulles states but all bulles felt
	if( state ==  global.GAME_PANEL_STATES.DOUBLET_PLACED || 
		(state ==  global.GAME_PANEL_STATES.PLACING_FALLING_BULLES && falling_bulles.empty() )
	):
		# try solve the grid and eliminate chains
		var score = grid.solve()
		if( score > 0 ):
			combo_count += 1
			cumulative_score += global.popping_combo_score_compute( score, combo_count)
	
	# if game is solving, IE chains are being eliminated and bulles are all popped
	if(  state == global.GAME_PANEL_STATES.SOLVING && popping_bulle_count == 0 ):
		# solve for falling bulles
		grid.solve_falling()
		
	# if there's no bulle to fall and no bulles to pop and no doublet
	if( !doublet && popping_bulle_count == 0 && falling_bulles.empty()):
		# game is in an idle state
		# if has to receive penalties
		if( penalty_bulles != 0 && !received_penalty ):
			state = global.GAME_PANEL_STATES.WAITING_FOR_PENALTIES
		else:
			# else game is in idle state and waits for a doublet
			state = global.GAME_PANEL_STATES.IDLE
		if( cumulative_score > 0 ):
#			get_parent().return_score(cumulative_score)
			emit_signal("score", cumulative_score)
			cumulative_score = 0
			combo_count = 0
	# else if doublet is present
	elif( doublet && popping_bulle_count == 0 && falling_bulles.empty()):
		# game is in placing doublet state
		state = global.GAME_PANEL_STATES.PLACING_DOUBLET



func add_bulle_to_game( bulle ):
	bulle.grid = grid
	if( bulle.is_connected( 'started_falling', self, 'add_falling_bulle' ) ):
		return
	bulle.connect('started_falling', self, 'add_falling_bulle')
	bulle.connect('stopped_falling', self, 'remove_falling_bulle')
	
	bulle.connect('started_popping', self, 'add_popping_bulle')
	bulle.connect('stopped_popping', self, 'remove_popping_bulle')
	
func set_doublet( doublet ):
	state = global.GAME_PANEL_STATES.PLACING_DOUBLET
	self.doublet = doublet
	received_penalty = false
	
	if( doublet.get_parent() != null ):
		doublet.get_parent().remove_child(doublet)
	panel.add_child(doublet)
	doublet.set_pos( doublet_default_pos )
	doublet.set_falling()
	doublet.grid = grid
	
	doublet.connect("placed", self, "remove_doublet")
	
	add_bulle_to_game(doublet.main_bulle)
	add_bulle_to_game(doublet.second_bulle)

func remove_doublet( main_bulle, second_bulle ):
	state = global.GAME_PANEL_STATES.DOUBLET_PLACED
	
	# test for both bulle if they can move bottom
	if( !grid.can_bulle_move_to( main_bulle, global.DIRECTIONS.BOTTOM ) ):
		# place bulle to grid if cannot move bottom
		add_bulle_to_grid( main_bulle )
	else:
		# else set it as falling
		main_bulle.set_falling()

	if( !grid.can_bulle_move_to( second_bulle, global.DIRECTIONS.BOTTOM  ) ):
		add_bulle_to_grid( second_bulle  )
	else:
		second_bulle.set_falling()
	
	if( doublet.get_parent() ):
		doublet.get_parent().remove_child(doublet)
	doublet = null
	
func add_penalty( penalty ):
	penalty_bulles += penalty
func remove_black_bulle( bulle ):
	remove_bulle_from_grid(bulle)
func add_penalties_to_game( bulle_pos_array ):
	received_penalty = true
	penalty_bulles -= bulle_pos_array.size()
	for i in range (bulle_pos_array.size()):
		var black_bulle = global.BULLE_SCENES[ global.BULLE_TYPES.BLACK ].instance() 
		add_bulle_to_game(black_bulle)
		black_bulle.set_pos(bulle_pos_array[i])
		black_bulle.set_falling()
	

func add_bulle_to_grid( bulle ):
	if( bulle.get_parent() != null):
		bulle.get_parent().remove_child(bulle)
	panel.add_child(bulle)
	var grid_pos = grid.pos_to_grid_coord(bulle.get_pos())
	# necessary to make sure the bulle is at the slot's position
	var grid_real_pos =  grid.grid_coord_to_pos( grid_pos )
	bulle.set_pos(grid_real_pos)
	
	bulle.set_in_grid( grid_pos )
	grid.set_slot( grid_pos, bulle)
func remove_bulle_from_grid( bulle ):
	grid.set_slot( bulle.grid_pos, null)
	panel.remove_child(bulle)
	
func add_falling_bulle( bulle ):
	state = global.GAME_PANEL_STATES.PLACING_FALLING_BULLES
	if( bulle.get_parent() ):
		bulle.get_parent().remove_child(bulle)
	panel.add_child(bulle)
	falling_bulles.append(bulle)
func remove_falling_bulle( bulle ):
	falling_bulles.remove( falling_bulles.find(bulle))
	add_bulle_to_grid( bulle )

func add_popping_bulle( bulle ):
	state = global.GAME_PANEL_STATES.SOLVING
	popping_bulle_count += 1
func remove_popping_bulle( bulle ):
	popping_bulle_count -= 1
	
	for direction in range(global.DIRECTIONS.COUNT):
		var neighbour = bulle.neighbours[direction]
		if( neighbour && neighbour.type == global.BULLE_TYPES.BLACK ):
			remove_black_bulle( neighbour )
	
	

	
	
# commands given by parents
func rotate_doublet_clockwise():
	if( doublet ):
		doublet.rotate_clockwise()
func rotate_doublet_counterclockwise():
	if( doublet ) :
		doublet.rotate_counterclockwise()

func move_doublet_left():
	if( doublet ):
		doublet.move_left()
func move_doublet_right():
	if( doublet ):
		doublet.move_right()

func increase_doublet_falling_speed():
	if( doublet ):
		doublet.increase_falling_speed()
func decrease_doublet_falling_speed():
	if( doublet ):
		doublet.decrease_falling_speed()
