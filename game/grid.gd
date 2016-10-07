extends Node2D


var grid_size
var bulles 

func _ready():
	bulles = []
	bulles.resize(global.GRID_SIZE.y)
	for y in range(global.GRID_SIZE.y):
		bulles[y] = []
		bulles[y].resize(global.GRID_SIZE.x)
		for x in range(global.GRID_SIZE.x):
			bulles[y][x] = preload('res://game/bulles/blue/bulle_blue.tscn').instance()
			add_child(bulles[y][x])
			bulles[y][x].set_pos(Vector2(x * global.BULLE_SIZE.x, y * global.BULLE_SIZE.y ) + global.BULLE_SIZE/2 )
	
	fixed_process(true)
	
func fixed_process(delta):
	pass


