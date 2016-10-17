extends Node2D




onready var grid = get_node("grid")

var state = global.SINGLE_GAME_PANEL_STATES.IDLE

var grid_pixel_size = Vector2( global.GRID_SIZE.x * global.BULLE_SIZE.x , global.GRID_SIZE.y * global.BULLE_SIZE.y )

var doublet_default_pos = Vector2( (1+global.GRID_SIZE.x/2) * global.BULLE_SIZE.x , global.BULLE_SIZE.y * 2 ) -  global.BULLE_SIZE/2
var doublet_lateral_move_timer = 0.15
var doublet_lateral_move_counter = 0
var doublet

var falling_bulles_acceleration = 10 # pixel per second per second
var falling_bulles = []

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	pass




func remove_doublet( ):
	doublet = null
	if( state != global.SINGLE_GAME_PANEL_STATES.PLACING_FALLING_BULLES ):
		state = global.SINGLE_GAME_PANEL_STATES.IDLE
		grid.solve()

func add_bulle_to_grid( bulle, grid_pos ):
	bulle.get_parent().remove_child(bulle)
	add_child(bulle)
	bulle.set_pos( grid.grid_coord_to_pos( grid_pos ) )
	bulle.set_in_grid(grid_pos)
	grid.set_slot( grid_pos, bulle)

func add_falling_bulle( bulle, pos ):
	state = global.SINGLE_GAME_PANEL_STATES.PLACING_FALLING_BULLES
	bulle.get_parent().remove_child(bulle)
	add_child(bulle)
	bulle.set_pos(pos)
	bulle.set_falling()
	falling_bulles.append(bulle)
	
func remove_falling_bulle( bulle ):
	falling_bulles.remove( falling_bulles.find(bulle))
	add_bulle_to_grid(  bulle, grid.pos_to_grid_coord( bulle.get_pos() ) )
	if( falling_bulles.empty() ):
		state = global.SINGLE_GAME_PANEL_STATES.IDLE
		grid.solve()
	
func set_doublet( doublet ):
	self.doublet = doublet
	add_child(doublet)
	doublet.set_pos( doublet_default_pos )
	doublet.set_falling()
	state = global.SINGLE_GAME_PANEL_STATES.PLACING_DOUBLET
	
	
	
	
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




func _draw():
	# left wall
	draw_rect( Rect2( -10, 0, 10, grid_pixel_size.y), Color(0,0,0) )
	# right wall
	draw_rect( Rect2( grid_pixel_size.x, 0, 10, grid_pixel_size.y), Color(0,0,0) )
	# top wall
	draw_rect( Rect2( 0, global.BULLE_SIZE.y*2-10, grid_pixel_size.x, 10), Color(0,0,0) )
	# bottom wall
	draw_rect( Rect2( 0, grid_pixel_size.y, grid_pixel_size.x, 10), Color(0,0,0) )
	