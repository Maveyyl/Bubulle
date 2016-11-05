extends Node2D

onready var double_game_panel = get_node('double_game_panel')

onready var game_panel_player = get_node('double_game_panel/game_panel_p1')
onready var info_panel_player = get_node('double_game_panel/info_panel_p1')

onready var game_panel_AI = get_node('double_game_panel/game_panel_p2')
onready var info_panel_AI = get_node('double_game_panel/info_panel_p2')

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	if ( Input.is_action_just_pressed("escape") ):
		scene_manager.change_scene_to_previous()
	
	if( Input.is_action_pressed("up_p1") ):
		game_panel_player.rotate_doublet_clockwise()
	if( Input.is_action_pressed("down_p1") ):
		game_panel_player.rotate_doublet_counterclockwise()
		
	if( Input.is_action_pressed("left_p1") ):
		game_panel_player.move_doublet_left()
	if( Input.is_action_pressed("right_p1") ):
		game_panel_player.move_doublet_right()
		
	if( Input.is_action_pressed("speed_p1") ):
		game_panel_player.increase_doublet_falling_speed()
	elif( !Input.is_action_pressed("speed_p1") ):
		game_panel_player.decrease_doublet_falling_speed()
	

	