extends Node2D

onready var game = get_parent()

var grid_size

func _ready():

	pass


func _draw():
	grid_size = Vector2( game.GRID_SIZE.x * game.TILE_SIZE.x , game.GRID_SIZE.x * game.TILE_SIZE.y )
	
	# left wall
	draw_rect( Rect2( -10, 0, 10, grid_size.y), Color(0,0,0) )
	
	# right wall
	draw_rect( Rect2( grid_size.x, 0, 10, grid_size.y), Color(0,0,0) )
	
	# top wall
	draw_rect( Rect2( 0, -10, grid_size.x, 10), Color(0,0,0) )
	
	# bottom wall
	draw_rect( Rect2( 0, grid_size.y, grid_size.x, 10), Color(0,0,0) )
	