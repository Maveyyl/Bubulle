extends Node2D

var doublet_main_bulle_goal_pos_x = 3
var doublet_second_bulle_goal_state = 0

onready var solo_game = get_parent().get_parent()

onready var game_panel = solo_game.get_node('double_game_panel/game_panel_p2')
onready var info_panel = solo_game.get_node('double_game_panel/info_panel_p2')

var doublet

func _ready():
	set_process(true)
	
func _process(delta):
	if( !game_panel.doublet  ):
		return;
	if( doublet != game_panel.doublet ):
		doublet = game_panel.doublet
		
	var horizontally_placed = false
	var vertically_placed = false
	
	if( doublet.second_bulle_state != doublet_second_bulle_goal_state ):
		var sens = get_rot_sens(doublet.second_bulle_state, doublet_second_bulle_goal_state, global.DIRECTIONS.COUNT)
		if( sens ):
			game_panel.rotate_doublet_clockwise()
		else:
			game_panel.rotate_doublet_counterclockwise()
	else:
		vertically_placed = true
	
	if( vertically_placed ):
		if( doublet.get_main_bulle_grid_pos().x > doublet_main_bulle_goal_pos_x ):
			game_panel.move_doublet_left()
		elif ( doublet.get_main_bulle_grid_pos().x < doublet_main_bulle_goal_pos_x ):
			game_panel.move_doublet_right()
		else:
			horizontally_placed = true

		
	if( horizontally_placed && vertically_placed):
		game_panel.increase_doublet_falling_speed()
	else:
		game_panel.decrease_doublet_falling_speed()
	
func get_rot_sens( a, b, ring_size):
	return ((a-b)+ring_size)%ring_size > (ring_size/2)