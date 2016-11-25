tool
extends Control

export var name = "Name"
export var action_name = "action_name"
onready var label = get_node("panel/label")
onready var button = get_node("panel/button")

func _ready():
	pass
	
func _draw():
	label.set_text(name)
	if( InputMap.has_action( action_name ) ):
		var action_list = InputMap.get_action_list(action_name)
		if( action_list.size() > 0 ): 
			button.set_text(OS.get_scancode_string(action_list[0].scancode))

	


func _on_button_pressed():
	button.set_text("?")
	set_process_input(true)
	
func _input(ev):
	if( ev.type == InputEvent.KEY && ev.pressed):
		button.set_text(OS.get_scancode_string(ev.scancode))
		set_process_input(false)
