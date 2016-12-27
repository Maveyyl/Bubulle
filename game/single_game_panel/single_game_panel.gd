extends Node2D

signal game_ended( is_p1_winner )
var ended = false

onready var game_panel_p1 = get_node('game_panel_p1')
onready var info_panel_p1 = get_node('info_panel_p1')
var p1_score = 0
var p1_doublet_seed_ref = [randi()]
var p1_penalty_seed_ref = [randi()]

func _ready():
	set_process(true)
	
	# create a doublet randomly and init it in the info panel
	add_random_doublet_to_pipeline( game_panel_p1, info_panel_p1, p1_doublet_seed_ref)
	
func _process(delta):
	# if game panel is IDLE
	if( game_panel_p1.state == global.GAME_PANEL_STATES.IDLE ):
		add_random_doublet_to_pipeline( game_panel_p1, info_panel_p1, p1_doublet_seed_ref )

	# if game is waiting for penalties to be placed
	if( game_panel_p1.state == global.GAME_PANEL_STATES.WAITING_FOR_PENALTIES ):
		add_random_penalties(game_panel_p1, p1_penalty_seed_ref)
		
func add_random_doublet_to_pipeline( game_panel, info_panel, seed_ref ):
	var doublet = global.SCRIPTS.DOUBLET.create_random( seed_ref )
	if( info_panel.doublet != null ):
		game_panel.set_doublet(info_panel.doublet)
	info_panel.set_doublet( doublet )
	
func add_random_penalties( game_panel, seed_ref ):
	var penalty_count
	if( game_panel.penalty_bulles > 10 ):
		penalty_count = 10
	else:
		penalty_count = game_panel.penalty_bulles
	var bulle_pos_array = global.get_penalty_random_slots( penalty_count, seed_ref )
	game_panel.add_penalties_to_game(bulle_pos_array)
	



func _on_game_panel_p1_score( score ):
	p1_score += score
	info_panel_p1.set_score(p1_score)


func game_ended( is_p1_winner ):
	print("game ended ", is_p1_winner)
	ended = true
	set_process(false)
	emit_signal("game_ended", is_p1_winner)
	
	var game_end_panel = scene_manager.SCENES.game_end.instance()
	add_child(game_end_panel)
	if( is_p1_winner ):
		game_end_panel.set_winner( "Player 1")
	else:
		game_end_panel.set_winner ( "Player 2") 
	game_end_panel.set_pos( global.GAME_END_PANEL_POS )
	
func _on_game_panel_p1_game_ended():
	game_ended( false )