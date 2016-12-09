extends Node2D

onready var solo_game = get_parent()

onready var double_game_panel = solo_game.get_node('double_game_panel')
onready var game_panel = double_game_panel.get_node('game_panel_p2')
onready var info_panel = double_game_panel.get_node('info_panel_p2')

onready var doublet_placer = get_node('doublet_placer')

var doublet

var simulation_scene_tree
var simulated_solo_game
var simulated_double_game_panel
var simulated_game_panel
var simulated_info_panel

func _ready():
	
	if( !get_viewport().is_set_as_render_target() ):
		
		set_process(true)
		simulation_scene_tree = SceneTree.new()
		simulation_scene_tree.get_root().set_as_render_target(true)
		simulation_scene_tree.get_root().set_render_target_update_mode(Viewport.RENDER_TARGET_UPDATE_DISABLED)
		simulation_scene_tree.get_root().set_rect(Rect2(0, 0, 0, 0))
		simulation_scene_tree.init()
		
		simulation_scene_tree.change_scene_to( scene_manager.SCENES.solo )
		
	
func _exit_tree():
	simulation_scene_tree.finish()

func _process(delta):
#	if( get_viewport().is_set_as_render_target() ):
#		return;
	
	# if simulation is not ready, return
	if( !simulation_scene_tree.get_current_scene() ):
		return
		
	# if simulation is ready and nodes haven't been memorized yet
	if( simulation_scene_tree.get_current_scene() && !simulated_solo_game ):
		# memorized simulated nodes
		simulated_solo_game = simulation_scene_tree.get_current_scene()
		simulated_double_game_panel = simulated_solo_game.get_node('double_game_panel')
		simulated_game_panel = simulated_double_game_panel.get_node('game_panel_p2')
		simulated_info_panel = simulated_double_game_panel.get_node('info_panel_p2')
	
	# if there's no doublet to place, do nothing
	if( !game_panel.doublet  ):
		return;
	
	# if there's a new doublet to place, choose random location and rotation
	if( doublet != game_panel.doublet ):
		doublet = game_panel.doublet
		var d = generate_random_placement()
		doublet_placer.doublet_main_bulle_goal_pos_x = d[0]
		doublet_placer.doublet_second_bulle_goal_state = d[1]
		
		
func generate_random_placement():
	var main_bulle_pos_x = randi()%int(global.GRID_SIZE.x)
	var second_bulle_state = randi()%global.DIRECTIONS.COUNT
	while( 
		(main_bulle_pos_x == 0 && second_bulle_state == global.DIRECTIONS.LEFT) 
		|| (main_bulle_pos_x == global.GRID_SIZE.x && second_bulle_state == global.DIRECTIONS.RIGHT)
	):
		second_bulle_state = randi()%global.DIRECTIONS.COUNT
	
	return [main_bulle_pos_x, second_bulle_state]