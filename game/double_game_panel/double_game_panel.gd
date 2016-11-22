extends Node2D


onready var game_panel_p1 = get_node('game_panel_p1')
onready var info_panel_p1 = get_node('info_panel_p1')
var p1_score = 0

onready var game_panel_p2 = get_node('game_panel_p2')
onready var info_panel_p2 = get_node('info_panel_p2')
var p2_score = 0

var next_doublet_p1
var next_doublet_p2
var penalties_pos_p1
var penalties_pos_p2

func _ready():
	set_fixed_process(true)
	
	# create a doublet randomly and init it in the info panel
	add_random_doublet_to_pipeline( game_panel_p1, info_panel_p1)
	add_random_doublet_to_pipeline( game_panel_p2, info_panel_p2)


	
func _fixed_process(delta):
	# if game panel is IDLE
	if( game_panel_p1.state == global.GAME_PANEL_STATES.IDLE ):
		add_random_doublet_to_pipeline( game_panel_p1, info_panel_p1 )
		
	if( game_panel_p2.state == global.GAME_PANEL_STATES.IDLE ):
		add_random_doublet_to_pipeline( game_panel_p2, info_panel_p2 )

	# if game is waiting for penalties to be placed
	if( game_panel_p1.state == global.GAME_PANEL_STATES.WAITING_FOR_PENALTIES ):
		add_random_penalties(game_panel_p2)
		
	if( game_panel_p2.state == global.GAME_PANEL_STATES.WAITING_FOR_PENALTIES ):
		add_random_penalties(game_panel_p2)

func add_random_doublet_to_pipeline( game_panel, info_panel):
	var doublet = global.SCRIPTS.DOUBLET.create_random()
	if( info_panel.doublet != null ):
		game_panel.set_doublet(info_panel.doublet)
	info_panel.set_doublet( doublet )
	
func add_random_penalties( game_panel ):
	var penalty_count
	if( game_panel.penalty_bulles > 10 ):
		penalty_count = 10
	else:
		penalty_count = game_panel.penalty_bulles
	var bulle_pos_array = global.get_penalty_random_slots( penalty_count )
	game_panel.add_penalties_to_game(bulle_pos_array)
	



func _on_game_panel_p1_score( score ):
	p1_score += score
	info_panel_p1.set_score(p1_score)
	game_panel_p2.add_penalty(global.score_to_penalty(score))

func _on_game_panel_p2_score( score ):
	p2_score += score
	info_panel_p2.set_score(score)
	game_panel_p1.add_penalty(global.score_to_penalty(score))
