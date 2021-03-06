extends Node2D


func _ready():
	set_process(true)

func _process(delta):
	if ( Input.is_action_just_pressed("escape") ):
		get_tree().quit()


func _on_button_solo_pressed():
	scene_manager.change_scene_to("solo_menu")

func _on_button_multi_pressed():
	scene_manager.change_scene_to("multi_menu")

func _on_button_tutorial_pressed():
#	scene_manager.change_scene_to("tutorial")
	pass

func _on_button_training_pressed():
	scene_manager.change_scene_to("training")

func _on_button_options_pressed():
	scene_manager.change_scene_to("options_menu")

func _on_button_leave_pressed():
	get_tree().quit()

func _on_button_fork_pressed():
	OS.execute(OS.get_executable_path(), OS.get_cmdline_args(), false)

func _on_button_test_pressed():
	scene_manager.change_scene_to("tests_menu")
