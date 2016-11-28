extends Node2D


func _ready():
	set_process(true)
	pass

func _process(delta):
	if ( Input.is_action_just_pressed("escape") ):
		scene_manager.change_scene_to_previous()


func _on_button_local_game_pressed():
	scene_manager.change_scene_to("multi_local")

func _on_button_network_game_pressed():
	scene_manager.change_scene_to("network_menu")



func _on_button_back_pressed():
	scene_manager.change_scene_to_previous()
