extends Node

const SCENES = {
	"solo": preload("res://game/solo_game/solo_game.tscn"),
	"multi_local": preload("res://game/multi_game_local/multi_game_local.tscn"),
	"multi_network": preload("res://game/multi_game_network/multi_game_network.tscn"),

	"main_menu": preload("res://main_menu/main_menu.tscn"),
	"multi_menu": preload("res://main_menu/multi_menu/multi_menu.tscn"),
	"network_menu": preload("res://main_menu/multi_menu/network_menu/network_menu.tscn")
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
	
	
	
