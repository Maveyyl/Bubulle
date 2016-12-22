extends Node2D

func _ready():
	set_process(true)
	
func _process(delta):
	if ( Input.is_action_just_pressed("escape") ):
		scene_manager.change_scene_to_previous()

func _on_nightmare_button_pressed():
	pass # replace with function body


func _on_hard_button_pressed():
	scene_manager.change_scene_to("solo")


func _on_medium_button_pressed():
	pass # replace with function body


func _on_easy_button_pressed():
	pass # replace with function body


func _on_back_button_pressed():
	scene_manager.change_scene_to_previous()
