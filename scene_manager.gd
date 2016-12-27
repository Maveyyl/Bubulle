extends Node

const SCENES = {
	"solo": preload("res://game/solo_game/solo_game.tscn"),
	"multi_local": preload("res://game/multi_game_local/multi_game_local.tscn"),
	"multi_network": preload("res://game/multi_game_network/multi_game_network.tscn"),
	"training": preload("res://game/training_game/training_game.tscn"),
	"test_solo_game_simulation": preload("res://game/tests/test_solo_game_simulation/test_solo_game_simulation.tscn"),

	"main_menu": preload("res://UI/main_menu/main_menu.tscn"),
	"solo_menu": preload("res://UI/main_menu/solo_menu/solo_menu.tscn"),
	"multi_menu": preload("res://UI/main_menu/multi_menu/multi_menu.tscn"),
	"network_menu": preload("res://UI/main_menu/multi_menu/network_menu/network_menu.tscn"),
	"options_menu": preload("res://UI/main_menu/options_menu/options_menu.tscn"),
	"tests_menu": preload("res://UI/main_menu/tests_menu/tests_menu.tscn"),
	
	"game_end": preload("res://UI/game_end/game_end.tscn")
}

var current_scene
var current_scene_name
var previous_scenes_names = []

func _ready():
	pass
	
func change_scene_to( scene_name, previous = false ):
	if( current_scene ):
		current_scene.queue_free()
	if( current_scene_name && !previous ):
		previous_scenes_names.push_front( current_scene_name )

	current_scene_name = scene_name
	current_scene = SCENES[scene_name].instance()
	global.main.add_child(current_scene)
	current_scene.set_pos(Vector2(0,0))
	
	if( previous_scenes_names.size() > 100 ):
		previous_scenes_names.pop_back()
		
func change_scene_to_previous( ):
	if( previous_scenes_names.size() > 0 ):
		change_scene_to ( previous_scenes_names.pop_front(), true )
	
	
	
