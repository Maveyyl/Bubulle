extends Node2D


var grid_size
var bulles 

func _ready():
	bulles = []
	bulles.resize(global.GRID_SIZE.y)
	for y in range(global.GRID_SIZE.y):
		bulles[y] = []
		bulles[y].resize(global.GRID_SIZE.x)
	
	fixed_process(true)
	
func fixed_process(delta):
	pass


func _draw():
	grid_size = Vector2( global.GRID_SIZE.x * global.TILE_SIZE.x , global.GRID_SIZE.x * global.TILE_SIZE.y )
	
	# left wall
	draw_rect( Rect2( -10, 0, 10, grid_size.y), Color(0,0,0) )
	
	# right wall
	draw_rect( Rect2( grid_size.x, 0, 10, grid_size.y), Color(0,0,0) )
	
	# top wall
	draw_rect( Rect2( 0, -10, grid_size.x, 10), Color(0,0,0) )
	
	# bottom wall
	draw_rect( Rect2( 0, grid_size.y, grid_size.x, 10), Color(0,0,0) )
	