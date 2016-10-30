extends Node2D

var state = global.DOUBLET_STATES.IDLE
var main_bulle
var second_bulle
var direction = global.DIRECTIONS.TOP

# falling
var initial_falling_speed = 0.05 # time for one move
var falling_speed = 0.05
var sped_up_falling_speed = 0.0075
var falling_counter = 0

# lateral moves
var lateral_move_timer = 0.12
var lateral_move_counter = 0

# rotation
var rotation_speed = 360 # degree per second
var rotating = false
var clockwise = false
var current_rotation = 0
var rotation_goal = 0
var second_bulle_goal_pos = Vector2(0, -global.BULLE_SIZE.y ) # this is to ensure rotations update even though the rotation hasn't finished


func _ready():
	set_fixed_process(true)

	
func _fixed_process(delta):
	# counter to reduce the lateral moves happening per seconds
	if( lateral_move_counter < lateral_move_timer ):
		lateral_move_counter+=delta
	
	# if the doublet is in a rotating state
	if( rotating ):
		# memorise the initial rotation
		var previous_rot = current_rotation
		# add rotation depending on the sens of rotation
		if( clockwise ):
			current_rotation -= rotation_speed * delta
		else:
			current_rotation += rotation_speed * delta
		
		# a guard to limit the rotation to the goal position
		if( abs(rotation_goal) - abs(current_rotation) < rotation_speed * delta):
			current_rotation = rotation_goal
			rotating = false
		
		# rotate the second bulle around the main bulle
		rotate_second_bulle( current_rotation-previous_rot  )
	
	# if doublet is in a falling state
	if(  state == global.DOUBLET_STATES.FALLING ):
		# doublet falls of an half slot at a certain rate per second
		falling_counter += delta
		# whenever the counter has ecceeded its maximum
		if( falling_counter >= falling_speed ):
			# if doublet can move bottom
			if( can_move_bottom() ):
				# reset the falling counter
				# move the doublet half a slot bottom
				set_pos( get_pos() + Vector2( 0, global.BULLE_SIZE.x/8 ) * int(falling_counter/falling_speed) )
				falling_counter -=int(falling_counter/falling_speed) * falling_speed
			# if doublet cannot move bottom
			else:
				# that doublet's bulles must be placed in grid
				var game = get_parent().get_parent()
				var grid = game.grid
				
				game.remove_doublet()
				# test for both bulle if they can move bottom
				if( !can_main_bulle_move_bottom() ):
					# place bulle to grid if cannot move bottom
					game.add_bulle_to_grid( main_bulle, get_main_bulle_grid_pos() )
				else:
					# else set it as falling
					game.add_falling_bulle( main_bulle, get_main_bulle_pos() )
	
				if( !can_second_bulle_move_bottom() ):
					game.add_bulle_to_grid( second_bulle, get_second_bulle_grid_pos() )
				else:
					game.add_falling_bulle( second_bulle, get_second_bulle_pos() )
				
				# remove the doublet from the game
				rotating = false
				queue_free()

# states altering functions
func set_idle():
	state = global.DOUBLET_STATES.IDLE
func set_falling():
	state = global.DOUBLET_STATES.FALLING
	
func set_main_bulle( bulle ):
	self.main_bulle = bulle
	add_child(self.main_bulle)
	
func set_second_bulle( bulle ):
	self.second_bulle = bulle
	add_child(self.second_bulle)
	self.second_bulle.set_pos( -Vector2(0,global.BULLE_SIZE.y ) )
	
	
# falling functions	
func can_main_bulle_move_bottom():
	return get_parent().get_parent().grid.get_neighbour_slot_type( get_main_bulle_grid_pos(), global.DIRECTIONS.BOTTOM ) == global.GRID_SLOT_TYPES.EMPTY
func can_second_bulle_move_bottom():
	return get_parent().get_parent().grid.get_neighbour_slot_type( get_second_bulle_grid_pos(), global.DIRECTIONS.BOTTOM ) == global.GRID_SLOT_TYPES.EMPTY
func can_move_bottom():
	return can_main_bulle_move_bottom() && can_second_bulle_move_bottom()

func increase_falling_speed():
	falling_speed = sped_up_falling_speed
func decrease_falling_speed():
	falling_speed = initial_falling_speed


# lateral moves
func can_move_left( ):
	var grid_pos = get_grid_pos()
	if( get_parent().get_parent().grid.get_neighbour_slot_type( grid_pos.main_bulle, global.DIRECTIONS.LEFT ) != global.GRID_SLOT_TYPES.EMPTY ):
		return false
	if( get_parent().get_parent().grid.get_neighbour_slot_type( grid_pos.second_bulle, global.DIRECTIONS.LEFT ) != global.GRID_SLOT_TYPES.EMPTY ):
		return false
	return true
func can_move_right( ):
	var grid_pos = get_grid_pos()
	if( get_parent().get_parent().grid.get_neighbour_slot_type( grid_pos.main_bulle, global.DIRECTIONS.RIGHT ) != global.GRID_SLOT_TYPES.EMPTY ):
		return false
	if( get_parent().get_parent().grid.get_neighbour_slot_type( grid_pos.second_bulle, global.DIRECTIONS.RIGHT ) != global.GRID_SLOT_TYPES.EMPTY ):
		return false
	return true

func move_left():
	if( lateral_move_counter > lateral_move_timer):
		if( can_move_left() ):
			lateral_move_counter = 0
			set_pos( get_pos() + Vector2( -global.BULLE_SIZE.x, 0 ))
			
func move_right():
	if( lateral_move_counter > lateral_move_timer):
		if( can_move_right() ):
			lateral_move_counter = 0
			set_pos( get_pos() + Vector2( global.BULLE_SIZE.x, 0 ))



# rotation
func can_rotate_clockwise():
	var new_direction = (direction +1) % global.DIRECTIONS.COUNT
	var slot_type = get_parent().get_parent().grid.get_neighbour_slot_type( get_main_bulle_grid_pos(), new_direction )
	return slot_type == global.GRID_SLOT_TYPES.EMPTY
func can_rotate_counterclockwise():
	var new_direction = (direction -1 + global.DIRECTIONS.COUNT) % global.DIRECTIONS.COUNT
	var slot_type = get_parent().get_parent().grid.get_neighbour_slot_type( get_main_bulle_grid_pos(), new_direction )
	return slot_type == global.GRID_SLOT_TYPES.EMPTY

func rotate_second_bulle( deg ):
	var vector_pos = self.second_bulle.get_pos()
	vector_pos = vector_pos.rotated(deg2rad( deg))
	self.second_bulle.set_pos( vector_pos)

func rotate_clockwise():
	if( !rotating && can_rotate_clockwise() ):
		clockwise = true
		current_rotation = 0
		rotation_goal = -90
		rotating = true
		direction = (direction +1) % global.DIRECTIONS.COUNT
		second_bulle_goal_pos = global.DIRECTIONS_NORMALS[ direction ]*global.BULLE_SIZE

func rotate_counterclockwise():
	if( !rotating && can_rotate_counterclockwise() ):
		clockwise = false
		current_rotation = 0
		rotation_goal = 90
		rotating = true
		direction = (direction -1 + global.DIRECTIONS.COUNT) % global.DIRECTIONS.COUNT
		second_bulle_goal_pos = global.DIRECTIONS_NORMALS[ direction ]*global.BULLE_SIZE
		

	
	
# util functions
func get_main_bulle_pos():
	return get_pos()
func get_second_bulle_pos():
	return get_pos()+second_bulle_goal_pos
	
func get_main_bulle_grid_pos():
	return get_parent().get_parent().grid.pos_to_grid_coord( get_main_bulle_pos() )
func get_second_bulle_grid_pos():
	return get_parent().get_parent().grid.pos_to_grid_coord( get_second_bulle_pos() )
func get_grid_pos( ):
	var grid = get_parent().get_parent().grid
	return {
		'main_bulle': get_main_bulle_grid_pos( ),
		'second_bulle': get_second_bulle_grid_pos( )
	}
	