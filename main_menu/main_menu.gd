extends Node2D

const solo = preload('res://game/game.tscn')

func _ready():
	pass


func _on_button_solo_pressed():
	get_tree().change_scene_to( solo )
	pass

func _on_button_multi_pressed():
	pass

func _on_button_tutorial_pressed():
	pass

func _on_button_training_pressed():
	pass

func _on_button_options_pressed():
	pass

func _on_button_leave_pressed():
	get_tree().quit()
	pass
