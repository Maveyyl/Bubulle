extends Node2D

onready var solo_game = get_parent()

onready var double_game_panel = solo_game.get_node('double_game_panel')
onready var game_panel = double_game_panel.get_node('game_panel_p2')
onready var info_panel = double_game_panel.get_node('info_panel_p2')

onready var doublet_placer = get_node('doublet_placer')

var doublet

var simulation

func _ready():
	
	if( !get_viewport().is_set_as_render_target() ):
		set_process(true)
		simulation = global.SCRIPTS.SIMULATION.new()
		
		get_node('simulation_sprite').set_texture(simulation.get_root().get_render_target_texture())
	
func _exit_tree():
	if( simulation ):
		simulation.finish()

func _process(delta):
	get_node('simulation_sprite').set_texture(simulation.get_root().get_render_target_texture())
	
	# if simulation is not ready, return
	if( !simulation.ready ):
		return
		
	# if there's no doublet to place, do nothing
	if( !game_panel.doublet  ):
		return;
	
	# if there's a new doublet to place, choose random location and rotation
	if( doublet != game_panel.doublet ):
		doublet = game_panel.doublet
		
		var double_game_panel_data = double_game_panel.toDictionnary(true)
		simulation.set_base_state(double_game_panel_data)
		
		var ga = global.SCRIPTS.GA.new()
		var d = ga.run( simulation )
		doublet_placer.doublet_main_bulle_goal_pos_x = d[0]
		doublet_placer.doublet_second_bulle_goal_state = d[1]
#		
#		var d = generate_random_placement()
#		doublet_placer.doublet_main_bulle_goal_pos_x = d[0]
#		doublet_placer.doublet_second_bulle_goal_state = d[1]
#
#		simulation.run_until_new_doublet(delta)



func generate_random_placement():
	var main_bulle_pos_x = randi()%int(global.GRID_SIZE.x)
	var second_bulle_state = randi()%global.DIRECTIONS.COUNT
	while( 
		(main_bulle_pos_x == 0 && second_bulle_state == global.DIRECTIONS.LEFT) 
		|| (main_bulle_pos_x == global.GRID_SIZE.x && second_bulle_state == global.DIRECTIONS.RIGHT)
	):
		second_bulle_state = randi()%global.DIRECTIONS.COUNT
	
	return [main_bulle_pos_x, second_bulle_state]