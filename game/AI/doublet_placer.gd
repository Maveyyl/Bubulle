extends Node2D

var doublet_main_bulle_goal_pos_x = 3
var doublet_second_bulle_goal_state = 0

onready var solo_game = get_parent().get_parent()

onready var game_panel = solo_game.get_node('double_game_panel/game_panel_p2')
onready var info_panel = solo_game.get_node('double_game_panel/info_panel_p2')

var doublet

var increase_speed = false

func _ready():
	set_process(true)


func set_goal_placement( d ):
	doublet_main_bulle_goal_pos_x = d[0]
	doublet_second_bulle_goal_state = d[1]
func get_goal_placement():
	return [ doublet_main_bulle_goal_pos_x, doublet_second_bulle_goal_state]

func _process(delta):
	if( !game_panel.doublet  ):
		return;
	if( doublet != game_panel.doublet ):
		doublet = game_panel.doublet
		
	var horizontally_placed = false
	var vertically_placed = false
	var r
	
	if( doublet.second_bulle_state != doublet_second_bulle_goal_state ):
		var sens = get_rot_sens(doublet.second_bulle_state, doublet_second_bulle_goal_state, global.DIRECTIONS.COUNT)
		if( sens ):
			r = game_panel.rotate_doublet_clockwise()
			if( !r ):
				vertically_placed = true
		else:
			r = game_panel.rotate_doublet_counterclockwise()
			if( !r ):
				vertically_placed = true
	else:
		vertically_placed = true
	
	if( vertically_placed ):
		if( doublet.get_main_bulle_grid_pos().x > doublet_main_bulle_goal_pos_x ):
			r = game_panel.move_doublet_left()
			if( !r ):
				horizontally_placed = true
		elif ( doublet.get_main_bulle_grid_pos().x < doublet_main_bulle_goal_pos_x ):
			r = game_panel.move_doublet_right()
			if( !r ):
				horizontally_placed = true
		else:
			horizontally_placed = true

		
	if( horizontally_placed && vertically_placed && increase_speed):
		game_panel.increase_doublet_falling_speed()
	else:
		game_panel.decrease_doublet_falling_speed()
	
func get_rot_sens( a, b, ring_size):
	return ((a-b)+ring_size)%ring_size > (ring_size/2)