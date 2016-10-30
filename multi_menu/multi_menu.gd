extends Node2D


func _ready():
	pass


func _on_button_local_game_pressed():
	scene_manager.change_scene_to("multi_local")

func _on_button_network_game_pressed():
	pass # replace with function body





func _on_button_back_pressed():
	scene_manager.change_scene_to_previous()
