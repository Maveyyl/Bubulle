extends Node2D

onready var double_game_panel = get_node('double_game_panel')

onready var game_panel_p1 = get_node('double_game_panel/game_panel_p1')
onready var info_panel_p1 = get_node('double_game_panel/info_panel_p1')

onready var game_panel_p2 = get_node('double_game_panel/game_panel_p2')
onready var info_panel_p2 = get_node('double_game_panel/info_panel_p2')

func _ready():
	set_process(true)
	
func _process(delta):
	if ( Input.is_action_just_pressed("escape") ):
		scene_manager.change_scene_to_previous()
		
	if( Input.is_action_pressed("up_p1") ):
		game_panel_p1.rotate_doublet_clockwise()
	if( Input.is_action_pressed("down_p1") ):
		game_panel_p1.rotate_doublet_counterclockwise()
		
	if( Input.is_action_pressed("left_p1") ):
		game_panel_p1.move_doublet_left()
	if( Input.is_action_pressed("right_p1") ):
		game_panel_p1.move_doublet_right()
		
	if( Input.is_action_pressed("speed_p1") ):
		game_panel_p1.increase_doublet_falling_speed()
	elif( !Input.is_action_pressed("speed_p1") ):
		game_panel_p1.decrease_doublet_falling_speed()
		
		
	
	if( Input.is_action_pressed("up_p2") ):
		game_panel_p2.rotate_doublet_clockwise()
	if( Input.is_action_pressed("down_p2") ):
		game_panel_p2.rotate_doublet_counterclockwise()
		
	if( Input.is_action_pressed("left_p2") ):
		game_panel_p2.move_doublet_left()
	if( Input.is_action_pressed("right_p2") ):
		game_panel_p2.move_doublet_right()
		
	if( Input.is_action_pressed("speed_p2") ):
		game_panel_p2.increase_doublet_falling_speed()
	elif( !Input.is_action_pressed("speed_p2") ):
		game_panel_p2.decrease_doublet_falling_speed()


