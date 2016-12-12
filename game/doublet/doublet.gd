extends Node2D

var state = global.DOUBLET_STATES.IDLE
var main_bulle
var second_bulle
var direction = global.DIRECTIONS.TOP

var grid

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
var second_bulle_state = global.DIRECTIONS.TOP

# signals
signal placed

static func create_random( seed_ref ):
	var main_bulle_type = global.get_randi_update_seed(seed_ref)%(global.BULLE_TYPES.COUNT-1)
	var main_bulle = global.BULLE_SCENES[ main_bulle_type ].instance()
	
	var second_bulle_type = global.get_randi_update_seed(seed_ref)%(global.BULLE_TYPES.COUNT-1)
	var second_bulle = global.BULLE_SCENES[ second_bulle_type ].instance()
	var doublet = global.SCENES.DOUBLET.instance()
	doublet.set_main_bulle( main_bulle )
	doublet.set_second_bulle( second_bulle )
	return doublet

func fromDictionnary( d ):
	state = d.state

	if( main_bulle && main_bulle.type != d.main_bulle ):
		remove_child(main_bulle)
		main_bulle = null
	if( !main_bulle ):
		set_main_bulle( global.BULLE_SCENES[ d.main_bulle ].instance() )
		
		
	if( second_bulle && second_bulle.type != d.second_bulle ):
		remove_child(second_bulle)
		second_bulle = null
	if( !second_bulle ):
		set_second_bulle( global.BULLE_SCENES[ d.second_bulle ].instance() )

	set_pos( d.doublet_pos )
	second_bulle.set_pos( d.second_bulle_pos )
	direction = d.direction
	lateral_move_counter = d.lateral_move_counter
	rotating = d.rotating
	clockwise = d.clockwise
	current_rotation = d.current_rotation
	rotation_goal = d.rotation_goal
	second_bulle_goal_pos = d.second_bulle_goal_pos
func toDictionnary():
	return {
		"state": state,
		"main_bulle": main_bulle.type,
		"second_bulle": second_bulle.type,
		"doublet_pos": get_pos(),
		"second_bulle_pos": second_bulle.get_pos(),
		"direction": direction,
		"lateral_move_counter": lateral_move_counter,
		"rotating": rotating,
		"clockwise": clockwise,
		"current_rotation": current_rotation,
		"rotation_goal": rotation_goal,
		"second_bulle_goal_pos": second_bulle_goal_pos
	}


func _ready():
	set_process(true)

	
func _process(delta):
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
			# if doublet can move bottom and if network is not active or network mode is master
			if( can_move_bottom() ):
				# reset the falling counter
				# move the doublet half a slot bottom
				var pos = get_pos() + Vector2( 0, global.BULLE_SIZE.x/8 ) * int(falling_counter/falling_speed)
				set_pos( pos )
				falling_counter -=int(falling_counter/falling_speed) * falling_speed
			# if doublet cannot move bottom
			else:
				# setting bulle's pos before releasing
				main_bulle.set_pos(get_main_bulle_pos())
				second_bulle.set_pos(get_second_bulle_pos())
				emit_signal("placed", main_bulle, second_bulle)
				
				# remove the doublet from the game
				rotating = false

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
	
	
# test moving functions	
func can_bulle_move_to( grid_pos, direction ):
	return grid.get_neighbour_slot_type(grid_pos, direction) == global.GRID_SLOT_TYPES.EMPTY

func can_move_bottom():
	return ( can_bulle_move_to( get_main_bulle_grid_pos(), global.DIRECTIONS.BOTTOM ) 
		&& can_bulle_move_to( get_second_bulle_grid_pos(), global.DIRECTIONS.BOTTOM ) )

func can_move_left( ):
	return ( can_bulle_move_to( get_main_bulle_grid_pos(), global.DIRECTIONS.LEFT ) 
		&& can_bulle_move_to( get_second_bulle_grid_pos(), global.DIRECTIONS.LEFT ) ) 
	 
func can_move_right( ):
	return ( can_bulle_move_to( get_main_bulle_grid_pos(), global.DIRECTIONS.RIGHT )
		&& can_bulle_move_to( get_second_bulle_grid_pos(), global.DIRECTIONS.RIGHT ) )
	
func can_rotate_clockwise():
	var new_direction = (direction +1) % global.DIRECTIONS.COUNT
	var slot_type = grid.get_neighbour_slot_type( get_main_bulle_grid_pos(), new_direction )
	return slot_type == global.GRID_SLOT_TYPES.EMPTY
func can_rotate_counterclockwise():
	var new_direction = (direction -1 + global.DIRECTIONS.COUNT) % global.DIRECTIONS.COUNT
	var slot_type = grid.get_neighbour_slot_type( get_main_bulle_grid_pos(), new_direction )
	return slot_type == global.GRID_SLOT_TYPES.EMPTY



# falling functions
func increase_falling_speed():
	falling_speed = sped_up_falling_speed
	return true
func decrease_falling_speed():
	falling_speed = initial_falling_speed
	return true


# lateral moves
func move_left():
	if( lateral_move_counter > lateral_move_timer):
		if( can_move_left() ):
			lateral_move_counter = 0
			set_pos( get_pos() + Vector2( -global.BULLE_SIZE.x, 0 ))
			return true
		else:
			return false
	else:
		return true
			
func move_right():
	if( lateral_move_counter > lateral_move_timer):
		if( can_move_right() ):
			lateral_move_counter = 0
			set_pos( get_pos() + Vector2( global.BULLE_SIZE.x, 0 ))
			return true
		else:
			return false
	else:
		return true



# rotation
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
		second_bulle_state = (second_bulle_state + 1)%4
		return true
	elif( rotating ):
		return true
	else:
		return false

func rotate_counterclockwise():
	if( !rotating && can_rotate_counterclockwise() ):
		clockwise = false
		current_rotation = 0
		rotation_goal = 90
		rotating = true
		direction = (direction -1 + global.DIRECTIONS.COUNT) % global.DIRECTIONS.COUNT
		second_bulle_goal_pos = global.DIRECTIONS_NORMALS[ direction ]*global.BULLE_SIZE
		second_bulle_state = ((second_bulle_state - 1)+4)%4
		return true
	elif( rotating ):
		return true
	else:
		return false

	
	
# util functions
func get_main_bulle_pos():
	return get_pos()
func get_second_bulle_pos():
	return get_pos()+second_bulle_goal_pos
	

func get_main_bulle_grid_pos():
	return grid.pos_to_grid_coord( get_main_bulle_pos() )
func get_second_bulle_grid_pos():
	return grid.pos_to_grid_coord( get_second_bulle_pos() )
	
