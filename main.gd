extends Node2D


const solo = preload('res://game/single_game_panel.tscn')
const main_menu = preload('res://main_menu/main_menu.tscn')

var current_scene

func _ready():
	change_scene_to_main_menu()
	
func change_scene_to_solo():
	if( current_scene ):
		current_scene.queue_free()
	current_scene = solo.instance()
	add_child(current_scene)
	current_scene.set_pos(Vector2(100,100))
	
	var main_bulle = preload('res://game/bulles/blue/bulle_blue.tscn').instance()
	var second_bulle = preload('res://game/bulles/red/bulle_red.tscn').instance()
	var doublet = preload('res://game/doublet.tscn').instance()
	doublet.set_main_bulle( main_bulle )
	doublet.set_second_bulle( second_bulle)
	current_scene.set_doublet(doublet)
	
func change_scene_to_main_menu():
	if( current_scene ):
		current_scene.queue_free()
	current_scene = main_menu.instance()
	add_child(current_scene)
	current_scene.set_pos(Vector2(100,100))