extends Node2D


const solo = preload("res://game/solo_game/solo_game.tscn")
const main_menu = preload("res://main_menu/main_menu.tscn")

var current_scene

func _ready():
	change_scene_to_main_menu()
	
func change_scene_to_solo():
	if( current_scene ):
		current_scene.queue_free()
	current_scene = solo.instance()
	add_child(current_scene)
	current_scene.set_pos(Vector2(100,100))
	
	
func change_scene_to_main_menu():
	if( current_scene ):
		current_scene.queue_free()
	current_scene = main_menu.instance()
	add_child(current_scene)
	current_scene.set_pos(Vector2(100,100))