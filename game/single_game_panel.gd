extends Node2D




onready var grid = get_node("grid")

var grid_pixel_size = Vector2( global.GRID_SIZE.x * global.BULLE_SIZE.x , global.GRID_SIZE.y * global.BULLE_SIZE.y )

var doublet_default_pos = Vector2( (1+global.GRID_SIZE.x/2) * global.BULLE_SIZE.x , 0 ) -  global.BULLE_SIZE/2
var doublet_initial_falling_speed = 1 # time for one half bulle size
var doublet_falling_counter = 0
var doublet

func _ready():
	set_process(true)
	pass

func _process(delta):
	if( doublet ):
		doublet_falling_counter += delta
		if( doublet_falling_counter >= doublet_initial_falling_speed ):
			doublet_falling_counter = 0
			doublet.set_pos( doublet.get_pos() + Vector2( 0, global.BULLE_SIZE.x/2 ) )
		
	
func set_doublet( doublet ):
	self.doublet = doublet
	add_child(doublet)
	self.doublet.set_pos( doublet_default_pos )
	

func _draw():
	
	# left wall
	draw_rect( Rect2( -10, 0, 10, grid_pixel_size.y), Color(0,0,0) )
	
	# right wall
	draw_rect( Rect2( grid_pixel_size.x, 0, 10, grid_pixel_size.y), Color(0,0,0) )
	
	# top wall
	draw_rect( Rect2( 0, -10, grid_pixel_size.x, 10), Color(0,0,0) )
	
	# bottom wall
	draw_rect( Rect2( 0, grid_pixel_size.y, grid_pixel_size.x, 10), Color(0,0,0) )
	