extends Node


onready var main = get_node("/root/main")


const GRID_SIZE = Vector2(6, 12+2) # + 2 rows as buffer
const BULLE_SIZE = Vector2(30, 30)

var DIRECTIONS = {
	"LEFT": 0,
	"TOP": 1,
	"RIGHT": 2,
	"BOTTOM": 3,
	"COUNT": 4
}
var DIRECTIONS_NORMALS = [
	Vector2(-1,0),
	Vector2(0,-1),
	Vector2(1,0),
	Vector2(0,1)
]

var GRID_SLOT_TYPES = {
	"EMPTY": 0,
	"BULLE": 1,
	"WALL": 2,
	"COUNT": 3
}


var BULLE_TYPES = {
	"RED": 0,
	"GREEN": 1,
#	"BLUE": 2, blue not implemented yet, maybe never ever implemented
	"YELLOW": 2,
	"PURPLE": 3,
	"CYAN": 4,
	"BLACK": 5,
	"COUNT": 6
}




var SCENES = {
	"DOUBLET": preload('res://game/doublet.tscn')
}

var BULLE_SCENES = [
	preload('res://game/bulles/red/bulle_red.tscn'),
	preload('res://game/bulles/green/bulle_green.tscn'),
	preload('res://game/bulles/yellow/bulle_yellow.tscn'),
	preload('res://game/bulles/purple/bulle_purple.tscn'),
	preload('res://game/bulles/cyan/bulle_cyan.tscn'),
	preload('res://game/bulles/black/bulle_black.tscn')
]


func popping_score_computer( bulle_count ):
	return 100 + 30 * (bulle_count-4)




var BULLE_STATES = {
	"IN_DOUBLET": 0,
	"FALLING": 1,
	"IN_GRID": 2,
	"POPPING": 3
}
var DOUBLET_STATES = {
	"IDLE": 0,
	"FALLING": 1
}
var GRID_STATES = {
	"IDLE": 0,
	"SOLVING": 1
}
var SINGLE_GAME_PANEL_STATES = {
	"IDLE": 0,
	"PLACING_DOUBLET": 1,
	"PLACING_FALLING_BULLES": 2
}







func _ready():
	pass


