extends Node2D




onready var grid = get_node("grid")

var grid_pixel_size = Vector2( global.GRID_SIZE.x * global.BULLE_SIZE.x , global.GRID_SIZE.y * global.BULLE_SIZE.y )

var doublet_default_pos = Vector2( (1+global.GRID_SIZE.x/2) * global.BULLE_SIZE.x , global.BULLE_SIZE.y * 2 ) -  global.BULLE_SIZE/2
var doublet_initial_falling_speed = 0.25 # time for one half bulle size
var doublet_falling_counter = 0
var doublet
var doublet_lateral_move_timer = 0.15
var doublet_lateral_move_counter = 0
var falling_bulles = []

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if( doublet_lateral_move_counter < doublet_lateral_move_timer ):
		doublet_lateral_move_counter+=delta
	
	if( doublet && falling_bulles.empty()):
		doublet_falling_counter += delta
		if( doublet_falling_counter >= doublet_initial_falling_speed ):
			if( can_doublet_move_bottom() ):
				doublet_falling_counter = 0
				doublet.set_pos( doublet.get_pos() + Vector2( 0, global.BULLE_SIZE.x/2 ) )
			else:
				if( !can_doublet_main_bulle_move_bottom() ):
					grid.set_slot( doublet.get_main_bulle_grid_pos(grid), doublet.main_bulle)
					doublet.main_bulle.state = global.BULLE_STATES.IN_GRID
				else:
					falling_bulles.append( doublet.main_bulle )
					doublet.main_bulle.state = global.BULLE_STATES.FALLING
								
				if( !can_doublet_second_bulle_move_bottom() ):
					grid.set_slot( doublet.get_second_bulle_grid_pos(grid), doublet.second_bulle)
					doublet.second_bulle.state = global.BULLE_STATES.IN_GRID
				else:
					falling_bulles.append( doublet.second_bulle )
					doublet.second_bulle.state = global.BULLE_STATES.FALLING
				
				doublet = null
	
func set_doublet( doublet ):
	self.doublet = doublet
	add_child(doublet)
	self.doublet.set_pos( doublet_default_pos )
	
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
	
func can_doublet_main_bulle_move_bottom():
	return grid.get_neighbour_slot_type( doublet.get_main_bulle_grid_pos(grid), global.DIRECTIONS.BOTTOM ) == global.GRID_SLOT_TYPES.EMPTY
func can_doublet_second_bulle_move_bottom():
	print(doublet.get_second_bulle_grid_pos(grid))
	return grid.get_neighbour_slot_type( doublet.get_second_bulle_grid_pos(grid), global.DIRECTIONS.BOTTOM ) == global.GRID_SLOT_TYPES.EMPTY
func can_doublet_move_bottom():
	return can_doublet_main_bulle_move_bottom() && can_doublet_second_bulle_move_bottom()




func _draw():
	# left wall
	draw_rect( Rect2( -10, 0, 10, grid_pixel_size.y), Color(0,0,0) )
	# right wall
	draw_rect( Rect2( grid_pixel_size.x, 0, 10, grid_pixel_size.y), Color(0,0,0) )
	# top wall
	draw_rect( Rect2( 0, -10, grid_pixel_size.x, 10), Color(0,0,0) )
	# bottom wall
	draw_rect( Rect2( 0, grid_pixel_size.y, grid_pixel_size.x, 10), Color(0,0,0) )
	