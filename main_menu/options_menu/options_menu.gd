extends Control

func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	if ( Input.is_action_just_pressed("escape") ):
		scene_manager.change_scene_to_previous()

func _input(event):
#	print(event)
	pass

func _on_back_button_pressed():
	scene_manager.change_scene_to_previous()
