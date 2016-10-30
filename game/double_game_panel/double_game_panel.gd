extends Node2D


onready var game_panel_p1 = get_node('game_panel_p1')
onready var info_panel_p1 = get_node('info_panel_p1')
var p1_score = 0

onready var game_panel_p2 = get_node('game_panel_p2')
onready var info_panel_p2 = get_node('info_panel_p2')
var p2_score = 0


func _ready():
	info_panel_p1.set_doublet( generate_random_doublet() )
	info_panel_p2.set_doublet( generate_random_doublet() )
	set_fixed_process(true)
	pass
	
	
func _fixed_process(delta):
	if( game_panel_p1.state == global.GAME_PANEL_STATES.IDLE ):
		game_panel_p1.set_doublet(info_panel_p1.doublet)
		info_panel_p1.set_doublet( generate_random_doublet() )
		
	if( game_panel_p2.state == global.GAME_PANEL_STATES.IDLE ):
		game_panel_p2.set_doublet(info_panel_p2.doublet)
		info_panel_p2.set_doublet( generate_random_doublet() )
	

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

func _on_game_panel_p2_score( score ):
	p2_score += score
	info_panel_p2.set_score(score)
