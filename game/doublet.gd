extends Node2D

var state = global.DOUBLET_STATES.IDLE
var main_bulle
var second_bulle
var direction = global.DIRECTIONS.TOP

var rotation_speed = 360 # degree per second
var rotating = false
var clockwise = false
var current_rotation = 0
var rotation_goal = 0
var second_bulle_goal_pos = Vector2(0, -global.BULLE_SIZE.y ) # this is to ensure rotations update even though the rotation hasn't finished


func _ready():
	set_fixed_process(true)

	
func _fixed_process(delta):
	if( rotating ):
		var previous_rot = current_rotation
		if( clockwise ):
			current_rotation -= rotation_speed * delta
		else:
			current_rotation += rotation_speed * delta
			
		if( abs(rotation_goal) - abs(current_rotation) < rotation_speed * delta):
			current_rotation = rotation_goal
			rotating = false
			
		rotate_second_bulle( current_rotation-previous_rot  )

	
func set_falling():
	state = global.DOUBLET_STATES.FALLING
	
func set_main_bulle( bulle ):
	self.main_bulle = bulle
	add_child(self.main_bulle)
	
func set_second_bulle( bulle):
	self.second_bulle = bulle
	add_child(self.second_bulle)
	self.second_bulle.set_pos( -Vector2(0,global.BULLE_SIZE.y ) )
	
func get_main_bulle_pos():
	return get_pos()
func get_second_bulle_pos():
	return get_pos()+second_bulle_goal_pos
	
func get_main_bulle_grid_pos( grid ):
	return grid.pos_to_grid_coord( get_main_bulle_pos() )
func get_second_bulle_grid_pos( grid ):
	return grid.pos_to_grid_coord( get_second_bulle_pos() )
func get_grid_pos( grid ):
	return {
		'main_bulle': get_main_bulle_grid_pos( grid ),
		'second_bulle': get_second_bulle_grid_pos( grid )
	}
	
	
	
func rotate_second_bulle( deg ):
	var vector_pos = self.second_bulle.get_pos()
	vector_pos = vector_pos.rotated(deg2rad( deg))
	self.second_bulle.set_pos( vector_pos)
	
	
func rotate_clockwise():
	if( !rotating ):
		clockwise = true
		current_rotation = 0
		rotation_goal = -90
		rotating = true
		direction = (direction +1) % global.DIRECTIONS.COUNT
#		second_bulle_goal_pos = second_bulle_goal_pos.rotated( deg2rad(rotation_goal))
		second_bulle_goal_pos = global.DIRECTIONS_NORMALS[ direction ]*global.BULLE_SIZE

func rotate_counterclockwise():
	if( !rotating ):
		clockwise = false
		current_rotation = 0
		rotation_goal = 90
		rotating = true
		direction = (direction -1 + global.DIRECTIONS.COUNT) % global.DIRECTIONS.COUNT
#		second_bulle_goal_pos = second_bulle_goal_pos.rotated( deg2rad(rotation_goal))
		second_bulle_goal_pos = global.DIRECTIONS_NORMALS[ direction ]*global.BULLE_SIZE