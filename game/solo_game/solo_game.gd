extends Node2D

onready var double_game_panel = get_node('double_game_panel')

onready var game_panel_player = get_node('double_game_panel/game_panel_p1')
onready var info_panel_player = get_node('double_game_panel/info_panel_p1')

onready var game_panel_AI = get_node('double_game_panel/game_panel_p2')
onready var info_panel_AI = get_node('double_game_panel/info_panel_p2')

func _ready():
	info_panel_player.set_doublet( generate_random_doublet() )
	set_fixed_process(true)
	
func _fixed_process(delta):
	if( game_panel_player.state == global.GAME_PANEL_STATES.IDLE ):
		game_panel_player.set_doublet(info_panel_player.doublet)
		info_panel_player.set_doublet( generate_random_doublet() )
	
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
	

func generate_random_doublet():
	var main_bulle = global.BULLE_SCENES[ randi()%(global.BULLE_TYPES.COUNT-1) ].instance()
	var second_bulle = global.BULLE_SCENES[ randi()%(global.BULLE_TYPES.COUNT-1) ].instance()
	var doublet = global.SCENES.DOUBLET.instance()
	doublet.set_main_bulle( main_bulle )
	doublet.set_second_bulle( second_bulle )
	return doublet
	