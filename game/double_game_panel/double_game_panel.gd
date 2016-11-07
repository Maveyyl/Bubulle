extends Node2D


onready var game_panel_p1 = get_node('game_panel_p1')
onready var info_panel_p1 = get_node('info_panel_p1')
var p1_score = 0

onready var game_panel_p2 = get_node('game_panel_p2')
onready var info_panel_p2 = get_node('info_panel_p2')
var p2_score = 0

var next_doublet_p1
var next_doublet_p2

func _ready():
	set_fixed_process(true)
	
	if( !network_manager.is_active || network_manager.network_mode == NETWORK_MODE_MASTER ):
		var p1_doublet = global.SCRIPTS.DOUBLET.create_random()
		info_panel_p1.set_doublet( p1_doublet )
		if( network_manager.is_active ):
			rpc("set_p1_info_doublet", p1_doublet.serialize())
		
		var p2_doublet = global.SCRIPTS.DOUBLET.create_random()
		info_panel_p2.set_doublet( p2_doublet )
		if( network_manager.is_active ):
			rpc("set_p2_info_doublet", p2_doublet.serialize())

	
	
func _fixed_process(delta):
	if( !network_manager.is_active || network_manager.network_mode == NETWORK_MODE_MASTER ):
		if( game_panel_p1.state == global.GAME_PANEL_STATES.IDLE ):
			game_panel_p1.set_doublet(info_panel_p1.doublet)
			var doublet = global.SCRIPTS.DOUBLET.create_random()
			info_panel_p1.set_doublet( doublet )
			if( network_manager.is_active ):
				rpc("set_p1_info_doublet", doublet.serialize())
			
		if( game_panel_p2.state == global.GAME_PANEL_STATES.IDLE ):
			game_panel_p2.set_doublet(info_panel_p2.doublet)
			var doublet = global.SCRIPTS.DOUBLET.create_random()
			info_panel_p2.set_doublet( doublet )
			if( network_manager.is_active ):
				rpc("set_p2_info_doublet", doublet.serialize())
	else:
		if( game_panel_p1.state == global.GAME_PANEL_STATES.IDLE ):
			game_panel_p1.set_doublet(info_panel_p1.doublet)
			info_panel_p1.set_doublet( next_doublet_p1 )
			
		if( game_panel_p2.state == global.GAME_PANEL_STATES.IDLE ):
			game_panel_p2.set_doublet(info_panel_p2.doublet)
			info_panel_p2.set_doublet( next_doublet_p2 )
		
			
slave func set_p1_info_doublet(doublet_data):
	next_doublet_p1 = global.SCRIPTS.DOUBLET.deserialize(doublet_data)
	
slave func set_p2_info_doublet(doublet_data):
	next_doublet_p2 = global.SCRIPTS.DOUBLET.deserialize(doublet_data)
	

func generate_random_doublet():
	var main_bulle = global.BULLE_SCENES[ randi()%(global.BULLE_TYPES.COUNT-1) ].instance()
	var second_bulle = global.BULLE_SCENES[ randi()%(global.BULLE_TYPES.COUNT-1) ].instance()
	var doublet = global.SCENES.DOUBLET.instance()
	doublet.set_main_bulle( main_bulle )
	doublet.set_second_bulle( second_bulle )
	return doublet




func _on_game_panel_p1_score( score ):
	p1_score += score
	info_panel_p1.set_score(p1_score)
	game_panel_p2.add_penalty(global.score_to_penalty(score))

func _on_game_panel_p2_score( score ):
	p2_score += score
	info_panel_p2.set_score(score)
	game_panel_p1.add_penalty(global.score_to_penalty(score))
