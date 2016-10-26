extends Node2D



onready var panel = get_node("panel")
onready var grid = get_node("panel/grid")

var state = global.GAME_PANEL_STATES.IDLE

var grid_pixel_size = Vector2( global.GRID_SIZE.x * global.BULLE_SIZE.x , global.GRID_SIZE.y * global.BULLE_SIZE.y )

var doublet_default_pos = Vector2( (1+global.GRID_SIZE.x/2) * global.BULLE_SIZE.x , global.BULLE_SIZE.y * 2 ) -  global.BULLE_SIZE/2
var doublet_lateral_move_timer = 0.15
var doublet_lateral_move_counter = 0
var doublet

var falling_bulles_acceleration = 10 # pixel per second per second
var falling_bulles = []

var popping_bulles = []

var cumulative_score = 0
var combo_count = 0

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
		
		elif( score == 0 ):
			if( cumulative_score > 0 ):
				get_parent().return_score(cumulative_score)
			cumulative_score = 0
			combo_count = 0
	
	# if game is solving, IE chains are being eliminated and bulles are all popped
	if(  state == global.GAME_PANEL_STATES.SOLVING && popping_bulles.empty() ):
		# solve for falling bulles
		grid.solve_falling()
		
	# if there's no bulle to fall and no bulles to pop and no doublet
	if( !doublet && popping_bulles.empty() && falling_bulles.empty()):
		# game is in idle state and waits for a doublet
		state = global.GAME_PANEL_STATES.IDLE
		if( cumulative_score > 0 ):
			get_parent().return_score(cumulative_score)
			cumulative_score = 0
			combo_count = 0
	# else if doublet is present
	elif( doublet && popping_bulles.empty() && falling_bulles.empty()):
		# game is in placing doublet state
		state = global.GAME_PANEL_STATES.PLACING_DOUBLET




func set_doublet( doublet ):
	state = global.GAME_PANEL_STATES.PLACING_DOUBLET
	self.doublet = doublet
	panel.add_child(doublet)
	doublet.set_pos( doublet_default_pos )
	doublet.set_falling()
func remove_doublet( ):
	state = global.GAME_PANEL_STATES.DOUBLET_PLACED
	doublet = null

func add_bulle_to_grid( bulle, grid_pos ):
	bulle.get_parent().remove_child(bulle)
	panel.add_child(bulle)
	bulle.set_pos( grid.grid_coord_to_pos( grid_pos ) )
	bulle.set_in_grid(grid_pos)
	grid.set_slot( grid_pos, bulle)
func remove_bulle_from_grid( bulle, grid_pos ):
	grid.set_slot( grid_pos, null)
	panel.remove_child(bulle)
	
func add_falling_bulle( bulle, pos ):
	state = global.GAME_PANEL_STATES.PLACING_FALLING_BULLES
	bulle.get_parent().remove_child(bulle)
	panel.add_child(bulle)
	bulle.set_pos(pos)
	bulle.set_falling()
	falling_bulles.append(bulle)
func remove_falling_bulle( bulle ):
	falling_bulles.remove( falling_bulles.find(bulle))
	add_bulle_to_grid(  bulle, grid.pos_to_grid_coord( bulle.get_pos() ) )

func add_popping_bulle( bulle ):
	state = global.GAME_PANEL_STATES.SOLVING
	popping_bulles.append(bulle)
	bulle.set_popping()
func remove_popping_bulle( bulle ):
	popping_bulles.remove( popping_bulles.find(bulle))
	remove_bulle_from_grid(bulle, bulle.grid_pos)

	

	
	
	
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



func can_bulle_move_bottom(bulle):
	return grid.get_neighbour_slot_type( grid.pos_to_grid_coord( bulle.get_pos() ), global.DIRECTIONS.BOTTOM ) == global.GRID_SLOT_TYPES.EMPTY




#func _draw():
#	# left wall
#	draw_rect( Rect2( -10, 0, 10, grid_pixel_size.y), Color(0,0,0) )
#	# right wall
#	draw_rect( Rect2( grid_pixel_size.x, 0, 10, grid_pixel_size.y), Color(0,0,0) )
#	# top wall
#	draw_rect( Rect2( 0, global.BULLE_SIZE.y*2-10, grid_pixel_size.x, 10), Color(0,0,0) )
#	# bottom wall
#	draw_rect( Rect2( 0, grid_pixel_size.y, grid_pixel_size.x, 10), Color(0,0,0) )
#	