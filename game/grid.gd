extends Node2D


var grid_size
var bulles 

func _ready():
	bulles = []
	bulles.resize(global.GRID_SIZE.x)
	for x in range(global.GRID_SIZE.x):
		bulles[x] = []
		bulles[x].resize(global.GRID_SIZE.y)
	
	fixed_process(true)
	
func fixed_process(delta):
	pass


