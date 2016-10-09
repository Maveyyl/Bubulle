extends Node2D

onready var single_game_panel_player = get_node('single_game_panel_player')


func _ready():
	set_process(true)
	
func _process(delta):
	if( !single_game_panel_player.doublet ):
		single_game_panel_player.set_doublet(generate_random_doublet())
	
	

func generate_random_doublet():
	var main_bulle = global.BULLE_SCENES[ randi()%global.BULLE_TYPES.COUNT ].instance()
	var second_bulle = global.BULLE_SCENES[ randi()%global.BULLE_TYPES.COUNT ].instance()
	var doublet = global.SCENES.DOUBLET.instance()
	doublet.set_main_bulle( main_bulle )
	doublet.set_second_bulle( second_bulle )
	return doublet