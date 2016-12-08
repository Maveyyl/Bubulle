extends Node2D

onready var solo_game = get_parent()

onready var game_panel = get_node('../double_game_panel/game_panel_p2')
onready var info_panel = get_node('../double_game_panel/info_panel_p2')

onready var doublet_placer = get_node('doublet_placer')

var doublet

func _ready():
	set_process(true)
	
func _process(delta):
		
	if( !game_panel.doublet  ):
		return;
	
	if( doublet != game_panel.doublet ):
		doublet_placer.doublet_main_bulle_goal_pos_x = randi()%int(global.GRID_SIZE.x)
		doublet_placer.doublet_second_bulle_goal_state = randi()%4
		doublet = game_panel.doublet