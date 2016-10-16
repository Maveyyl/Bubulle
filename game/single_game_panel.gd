extends Node2D




onready var grid = get_node("grid")

var state = global.SINGLE_GAME_PANEL_STATES.IDLE

var grid_pixel_size = Vector2( global.GRID_SIZE.x * global.BULLE_SIZE.x , global.GRID_SIZE.y * global.BULLE_SIZE.y )

var doublet_default_pos = Vector2( (1+global.GRID_SIZE.x/2) * global.BULLE_SIZE.x , global.BULLE_SIZE.y * 2 ) -  global.BULLE_SIZE/2
var doublet_initial_falling_speed = 0.15 # time for one half bulle size
var doublet_falling_counter = 0
var doublet
var doublet_lateral_move_timer = 0.15
var doublet_lateral_move_counter = 0

var falling_bulles_acceleration = 10 # pixel per second per second
var falling_bulles = []

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if( doublet_lateral_move_counter < doublet_lateral_move_timer ):
		doublet_lateral_move_counter+=delta

		
	if( doublet && falling_bulles.empty() ):
		state = global.SINGLE_GAME_PANEL_STATES.PLACING_DOUBLET
		doublet_falling_counter += delta
		if( doublet_falling_counter >= doublet_initial_falling_speed ):
			if( can_doublet_move_bottom() ):
				doublet_falling_counter = 0
				doublet.set_pos( doublet.get_pos() + Vector2( 0, global.BULLE_SIZE.x/2 ) )
			else:
				if( !can_doublet_main_bulle_move_bottom() ):
					grid.add_bulle( doublet.main_bulle, doublet.get_main_bulle_grid_pos(grid) )
				else:
					add_falling_bulle( doublet.main_bulle, doublet.get_main_bulle_pos() )

				if( !can_doublet_second_bulle_move_bottom() ):
					grid.add_bulle( doublet.second_bulle, doublet.get_second_bulle_grid_pos(grid) )
				else:
					add_falling_bulle( doublet.second_bulle, doublet.get_second_bulle_pos() )
				
				doublet.rotating = false
				doublet.queue_free()
				doublet = null


func add_falling_bulle( bulle, pos ):
	bulle.get_parent().remove_child(bulle)
	add_child(bulle)
	bulle.set_pos(pos)
	bulle.set_falling()
	falling_bulles.append(bulle)
	
func remove_falling_bulle( bulle ):
	falling_bulles.remove( falling_bulles.find(bulle))
	grid.add_bulle( bulle, grid.pos_to_grid_coord( bulle.get_pos() ) )
	if( falling_bulles.empty() ):
		grid.solve()
	
func set_doublet( doublet ):
	add_child(doublet)
	doublet.set_pos( doublet_default_pos )
	self.doublet = doublet
	
	
	
	
func rotate_doublet_clockwise():
	if( doublet && can_doublet_rotate_clockwise() ):
		doublet.rotate_clockwise()

func rotate_doublet_counterclockwise():
	if( doublet && can_doublet_rotate_counterclockwise() ) :
		doublet.rotate_counterclockwise()

func move_doublet_left():
	if( doublet && doublet_lateral_move_counter > doublet_lateral_move_timer):
		if( can_doublet_move_left() ):
			doublet_lateral_move_counter = 0
			doublet.set_pos( doublet.get_pos() + Vector2( -global.BULLE_SIZE.x, 0 ))
			
func move_doublet_right():
	if( doublet && doublet_lateral_move_counter > doublet_lateral_move_timer):
		if( can_doublet_move_right() ):
			doublet_lateral_move_counter = 0
			doublet.set_pos( doublet.get_pos() + Vector2( global.BULLE_SIZE.x, 0 ))


func can_doublet_rotate_clockwise():
	var new_direction = (doublet.direction +1) % global.DIRECTIONS.COUNT
	var slot_type = grid.get_neighbour_slot_type( doublet.get_main_bulle_grid_pos(grid), new_direction )
	return slot_type == global.GRID_SLOT_TYPES.EMPTY
func can_doublet_rotate_counterclockwise():
	var new_direction = (doublet.direction -1 + global.DIRECTIONS.COUNT) % global.DIRECTIONS.COUNT
	var slot_type = grid.get_neighbour_slot_type( doublet.get_main_bulle_grid_pos(grid), new_direction )
	return slot_type == global.GRID_SLOT_TYPES.EMPTY

func can_doublet_move_left( ):
	var doublet_grid_pos = doublet.get_grid_pos(grid)
	if( grid.get_neighbour_slot_type( doublet_grid_pos.main_bulle, global.DIRECTIONS.LEFT ) != global.GRID_SLOT_TYPES.EMPTY ):
		return false
	if( grid.get_neighbour_slot_type( doublet_grid_pos.second_bulle, global.DIRECTIONS.LEFT ) != global.GRID_SLOT_TYPES.EMPTY ):
		return false
	return true
func can_doublet_move_right( ):
	var doublet_grid_pos = doublet.get_grid_pos(grid)
	if( grid.get_neighbour_slot_type( doublet_grid_pos.main_bulle, global.DIRECTIONS.RIGHT ) != global.GRID_SLOT_TYPES.EMPTY ):
		return false
	if( grid.get_neighbour_slot_type( doublet_grid_pos.second_bulle, global.DIRECTIONS.RIGHT ) != global.GRID_SLOT_TYPES.EMPTY ):
		return false
	return true
	
func can_bulle_move_bottom(bulle):
	return grid.get_neighbour_slot_type( grid.pos_to_grid_coord( bulle.get_pos() ), global.DIRECTIONS.BOTTOM ) == global.GRID_SLOT_TYPES.EMPTY
func can_doublet_main_bulle_move_bottom():
	return grid.get_neighbour_slot_type( doublet.get_main_bulle_grid_pos(grid), global.DIRECTIONS.BOTTOM ) == global.GRID_SLOT_TYPES.EMPTY
func can_doublet_second_bulle_move_bottom():
	return grid.get_neighbour_slot_type( doublet.get_second_bulle_grid_pos(grid), global.DIRECTIONS.BOTTOM ) == global.GRID_SLOT_TYPES.EMPTY
func can_doublet_move_bottom():
	return can_doublet_main_bulle_move_bottom() && can_doublet_second_bulle_move_bottom()




func _draw():
	# left wall
	draw_rect( Rect2( -10, 0, 10, grid_pixel_size.y), Color(0,0,0) )
	# right wall
	draw_rect( Rect2( grid_pixel_size.x, 0, 10, grid_pixel_size.y), Color(0,0,0) )
	# top wall
	draw_rect( Rect2( 0, global.BULLE_SIZE.y*2-10, grid_pixel_size.x, 10), Color(0,0,0) )
	# bottom wall
	draw_rect( Rect2( 0, grid_pixel_size.y, grid_pixel_size.x, 10), Color(0,0,0) )
	