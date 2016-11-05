extends Node2D

onready var double_game_panel = get_node('double_game_panel')

onready var game_panel_p1 = get_node('double_game_panel/game_panel_p1')
onready var info_panel_p1 = get_node('double_game_panel/info_panel_p1')

onready var game_panel_p2 = get_node('double_game_panel/game_panel_p2')
onready var info_panel_p2 = get_node('double_game_panel/info_panel_p2')

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	if ( Input.is_action_just_pressed("escape") ):
		scene_manager.change_scene_to_previous()
