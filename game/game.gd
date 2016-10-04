extends Node2D

const GRID_SIZE = Vector2(6, 14) # only 6,12 are visible, the uppest 2 rows are buffer
const TILE_SIZE = Vector2(30, 30)

var BULLE_TYPE = {
	RED: 0,
	GREEN: 1,
#	BLUE: 2, blue not implemented yet, maybe never ever implemented
	YELLOW: 2,
	PURPLE: 3,
	CYAN: 4,
	BLACK: 5,
	COUNT: 6
}

var BULLE_SCENES = [
	preload('res://game/bulles/red/bulle_red.tscn'),
	preload('res://game/bulles/green/bulle_green.tscn'),
	preload('res://game/bulles/yellow/bulle_yellow.tscn'),
	preload('res://game/bulles/purple/bulle_purple.tscn'),
	preload('res://game/bulles/cyan/bulle_cyan.tscn'),
	preload('res://game/bulles/black/bulle_black.tscn')
]


func _ready():
	pass
	

