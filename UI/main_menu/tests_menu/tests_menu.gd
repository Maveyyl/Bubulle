extends Node2D

func _ready():
	set_process(true)
	
func _process(delta):
	if ( Input.is_action_just_pressed("escape") ):
		scene_manager.change_scene_to_previous()

func _on_button_test_solo_game_simulation_pressed():
	scene_manager.change_scene_to("test_solo_game_simulation")
