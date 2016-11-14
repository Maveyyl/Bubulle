extends Node2D

onready var double_game_panel = get_node('double_game_panel')

onready var game_panel_p1 = get_node('double_game_panel/game_panel_p1')
onready var info_panel_p1 = get_node('double_game_panel/info_panel_p1')

onready var game_panel_p2 = get_node('double_game_panel/game_panel_p2')
onready var info_panel_p2 = get_node('double_game_panel/info_panel_p2')

func _ready():
	
	get_tree().connect("server_disconnected", self, "peer_disconnected")
	get_tree().connect("network_peer_disconnected", self, "peer_disconnected")
	set_fixed_process(true)
	
master var up = false
master var down = false
master var left = false
master var right = false
master var speed = false



	
func peer_disconnected( id ):
	network_manager.disconnect()
	scene_manager.change_scene_to_previous()
	
func _fixed_process(delta):
	if ( Input.is_action_just_pressed("escape") ):
		network_manager.disconnect()
		scene_manager.change_scene_to_previous()
		
	var game_panel
	var game_panel_ad
	if( is_network_master() ):
		game_panel = game_panel_p1
		game_panel_ad = game_panel_p2
	else:
		game_panel = game_panel_p2
		game_panel_ad = game_panel_p1
		
	if( Input.is_action_pressed("up_p1") ):
		game_panel.rotate_doublet_clockwise()
	if( Input.is_action_pressed("down_p1") ):
		game_panel.rotate_doublet_counterclockwise()
		
	if( Input.is_action_pressed("left_p1") ):
		game_panel.move_doublet_left()
	if( Input.is_action_pressed("right_p1") ):
		game_panel.move_doublet_right()
		
	if( Input.is_action_pressed("speed_p1") ):
		game_panel.increase_doublet_falling_speed()
	elif( !Input.is_action_pressed("speed_p1") ):
		game_panel.decrease_doublet_falling_speed()


	if( is_network_master() ):
		if( up ):
			game_panel_ad.rotate_doublet_clockwise()
		if( down ):
			game_panel_ad.rotate_doublet_counterclockwise()
			
		if( left ):
			game_panel_ad.move_doublet_left()
		if( right ):
			game_panel_ad.move_doublet_right()
			
		if( speed ):
			game_panel_ad.increase_doublet_falling_speed()
		elif( !speed ):
			game_panel_ad.decrease_doublet_falling_speed()
	else:
		if( Input.is_action_just_pressed("up_p1") ):
			rset("up", true)
		if( Input.is_action_just_released("up_p1") ):
			rset("up", false)
			
		if( Input.is_action_just_pressed("down_p1") ):
			rset("down", true)
		if( Input.is_action_just_released("down_p1") ):
			rset("down", false)
			
		if( Input.is_action_just_pressed("left_p1") ):
			rset("left", true)
		if( Input.is_action_just_released("left_p1") ):
			rset("left", false)
			
		if( Input.is_action_just_pressed("right_p1") ):
			rset("right", true)
		if( Input.is_action_just_released("right_p1") ):
			rset("right", false)
			
		if( Input.is_action_just_pressed("speed_p1") ):
			rset("speed", true)
		if( Input.is_action_just_released("speed_p1") ):
			rset("speed", false)