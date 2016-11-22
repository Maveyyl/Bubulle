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



var SCRIPTS = {
	"BULLE": preload('res://game/bulles/bulle.gd'),
	"DOUBLET": preload('res://game/doublet/doublet.gd'),
	"GRID": preload('res://game/game_panel/grid.gd'),
	"GAME_PANEL": preload('res://game/game_panel/game_panel.gd')
}
var SCENES = {
	"BULLE": preload('res://game/bulles/bulle.tscn'),
	"DOUBLET": preload('res://game/doublet/doublet.tscn'),
	"GAME_PANEl": preload('res://game/game_panel/game_panel.tscn')
}

var BULLE_SCENES = [
	preload('res://game/bulles/red/bulle_red.tscn'),
	preload('res://game/bulles/green/bulle_green.tscn'),
	preload('res://game/bulles/yellow/bulle_yellow.tscn'),
	preload('res://game/bulles/purple/bulle_purple.tscn'),
	preload('res://game/bulles/cyan/bulle_cyan.tscn'),
	preload('res://game/bulles/black/bulle_black.tscn')
]


func popping_score_compute( bulle_count ):
	return 10 + 3 * (bulle_count-4)
func popping_combo_score_compute( score, combo):
	return score + ( score * 5 * (combo-1) )
func score_to_penalty( score ):
	return int(pow(score/5,0.6))


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
#var GRID_STATES = {
#	"IDLE": 0,
#	"SOLVING": 1
#}
var GAME_PANEL_STATES = {
	"IDLE": 0,
	"PLACING_DOUBLET": 1,
	"DOUBLET_PLACED": 2,
	"PLACING_FALLING_BULLES": 3,
	"SOLVED": 4,
	"SOLVING": 5,
	"WAITING_FOR_PENALTIES": 6
}




func get_penalty_random_slots(penalty_count):
	var slots_line_1 = []
	var slots_line_2 = []
	
	for i in range( GRID_SIZE.x ):
		slots_line_1.append(Vector2( i, 0) * BULLE_SIZE + BULLE_SIZE/2 )
		if( penalty_count > 5 ):
			slots_line_2.append(Vector2( i, 1) * BULLE_SIZE + BULLE_SIZE/2 )

	if( penalty_count <= 5 ):
		for i in range(6-penalty_count):
			var rand = randi()%slots_line_1.size()
			slots_line_1.remove(rand)
	else:
		for i in range(1):
			var rand = randi()%slots_line_1.size()
			slots_line_1.remove(rand)
		penalty_count-=5
		for i in range(6-penalty_count):
			var rand = randi()%slots_line_2.size()
			slots_line_2.remove(rand)
	
	for i in range(slots_line_2.size()):
		slots_line_1.append(slots_line_2[i])
		
	return slots_line_1


func _ready():
	pass


