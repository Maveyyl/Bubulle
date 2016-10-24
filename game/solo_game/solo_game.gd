extends Node2D

onready var game_panel_player = get_node('game_panel_player')


func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	if( game_panel_player.state == global.SINGLE_GAME_PANEL_STATES.IDLE ):
		game_panel_player.set_doublet(generate_random_doublet())
	
	if( Input.is_action_pressed("up") ):
		game_panel_player.rotate_doublet_clockwise()
	if( Input.is_action_pressed("down") ):
		game_panel_player.rotate_doublet_counterclockwise()
		
	if( Input.is_action_pressed("left") ):
		game_panel_player.move_doublet_left()
	if( Input.is_action_pressed("right") ):
		game_panel_player.move_doublet_right()
		
	if( Input.is_action_pressed("speed") ):
		game_panel_player.increase_doublet_falling_speed()
	elif( !Input.is_action_pressed("speed") ):
		game_panel_player.decrease_doublet_falling_speed()
	

func generate_random_doublet():
	var main_bulle = global.BULLE_SCENES[ randi()%(global.BULLE_TYPES.COUNT-1) ].instance()
	var second_bulle = global.BULLE_SCENES[ randi()%(global.BULLE_TYPES.COUNT-1) ].instance()
	var doublet = global.SCENES.DOUBLET.instance()
	doublet.set_main_bulle( main_bulle )
	doublet.set_second_bulle( second_bulle )
	return doublet
	
func return_score(score):
	print("score: ", score)