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
	
var up_ad = false
var down_ad = false
var left_ad = false
var right_ad = false
var speed_ad = false



master func up_m( val ):
	up_ad = val
master func down_m( val ):
	down_ad = val
master func left_m( val ):
	left_ad = val
master func right_m( val ):
	right_ad = val
master func speed_m( val ):
	speed_ad = val
	
slave func up_s( val ):
	up_ad = val
slave func down_s( val ):
	down_ad = val
slave func left_s( val ):
	left_ad = val
slave func right_s( val ):
	right_ad = val
slave func speed_s( val ):
	speed_ad = val
	
func peer_disconnected():
	network_manager.disconnect()
	scene_manager.change_scene_to_previous()
	
func _fixed_process(delta):
	if ( Input.is_action_just_pressed("escape") ):
		network_manager.disconnect()
		scene_manager.change_scene_to_previous()
		
	var game_panel
	var game_panel_ad
	if( network_manager.network_mode == NETWORK_MODE_MASTER ):
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


	if( up_ad ):
		game_panel_ad.rotate_doublet_clockwise()
	if( down_ad ):
		game_panel_ad.rotate_doublet_counterclockwise()
		
	if( left_ad ):
		game_panel_ad.move_doublet_left()
	if( right_ad ):
		game_panel_ad.move_doublet_right()
		
	if( speed_ad ):
		game_panel_ad.increase_doublet_falling_speed()
	elif( !speed_ad ):
		game_panel_ad.decrease_doublet_falling_speed()
	
	
	if( network_manager.network_mode == NETWORK_MODE_MASTER ):
		if( Input.is_action_just_pressed("up_p1") ):
			rpc("up_s", true)
		if( Input.is_action_just_released("up_p1") ):
			rpc("up_s", false)
			
		if( Input.is_action_just_pressed("down_p1") ):
			rpc("down_s", true)
		if( Input.is_action_just_released("down_p1") ):
			rpc("down_s", false)
			
		if( Input.is_action_just_pressed("left_p1") ):
			rpc("left_s", true)
		if( Input.is_action_just_released("left_p1") ):
			rpc("left_s", false)
			
		if( Input.is_action_just_pressed("right_p1") ):
			rpc("right_s", true)
		if( Input.is_action_just_released("right_p1") ):
			rpc("right_s", false)
			
		if( Input.is_action_just_pressed("speed_p1") ):
			rpc("speed_s", true)
		if( Input.is_action_just_released("speed_p1") ):
			rpc("speed_s", false)
	else:
		if( Input.is_action_just_pressed("up_p1") ):
			rpc("up_m", true)
		if( Input.is_action_just_released("up_p1") ):
			rpc("up_m", false)
			
		if( Input.is_action_just_pressed("down_p1") ):
			rpc("down_m", true)
		if( Input.is_action_just_released("down_p1") ):
			rpc("down_m", false)
			
		if( Input.is_action_just_pressed("left_p1") ):
			rpc("left_m", true)
		if( Input.is_action_just_released("left_p1") ):
			rpc("left_m", false)
			
		if( Input.is_action_just_pressed("right_p1") ):
			rpc("right_m", true)
		if( Input.is_action_just_released("right_p1") ):
			rpc("right_m", false)
			
		if( Input.is_action_just_pressed("speed_p1") ):
			rpc("speed_m", true)
		if( Input.is_action_just_released("speed_p1") ):
			rpc("speed_m", false)
			