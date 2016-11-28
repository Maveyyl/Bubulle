extends Control

onready var label_winner = get_node("panel/label_winner")

func _ready():
	pass
	
func set_winner( winner ):
	label_winner.set_text(winner + " Won!")

func _on_back_button_pressed():
	scene_manager.change_scene_to_previous()
