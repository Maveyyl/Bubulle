extends Node2D

onready var single_game_panel_player = get_node('single_game_panel_player')


func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	if( single_game_panel_player.state == global.SINGLE_GAME_PANEL_STATES.IDLE ):
		single_game_panel_player.set_doublet(generate_random_doublet())
	
	if( Input.is_action_pressed("up") ):
		single_game_panel_player.rotate_doublet_clockwise()
	if( Input.is_action_pressed("down") ):
		single_game_panel_player.rotate_doublet_counterclockwise()
		
	if( Input.is_action_pressed("left") ):
		single_game_panel_player.move_doublet_left()
	if( Input.is_action_pressed("right") ):
		single_game_panel_player.move_doublet_right()
		
	if( Input.is_action_pressed("speed") ):
		single_game_panel_player.increase_doublet_falling_speed()
	elif( !Input.is_action_pressed("speed") ):
		single_game_panel_player.decrease_doublet_falling_speed()
	

func generate_random_doublet():
	var main_bulle = global.BULLE_SCENES[ randi()%(global.BULLE_TYPES.COUNT-1) ].instance()
	var second_bulle = global.BULLE_SCENES[ randi()%(global.BULLE_TYPES.COUNT-1) ].instance()
	var doublet = global.SCENES.DOUBLET.instance()
	doublet.set_main_bulle( main_bulle )
	doublet.set_second_bulle( second_bulle )
	return doublet