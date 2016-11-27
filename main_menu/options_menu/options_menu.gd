extends Control

var BINDINGS_NAME = [
	"up_p1",
	"down_p1",
	"left_p1",
	"right_p1",
	"speed_p1",
	"up_p2",
	"down_p2",
	"left_p2",
	"right_p2",
	"speed_p2"
]

onready var KEY_PICKERS = {
	"up_p1": get_node("panel_controls/key_picker_up"),
	"down_p1": get_node("panel_controls/key_picker_down"),
	"left_p1": get_node("panel_controls/key_picker_left"),
	"right_p1": get_node("panel_controls/key_picker_right"),
	"speed_p1": get_node("panel_controls/key_picker_speed"),
	
	"up_p2": get_node("panel_controls_p2/key_picker_up"),
	"down_p2": get_node("panel_controls_p2/key_picker_down"),
	"left_p2": get_node("panel_controls_p2/key_picker_left"),
	"right_p2": get_node("panel_controls_p2/key_picker_right"),
	"speed_p2": get_node("panel_controls_p2/key_picker_speed"),
}

var CURRENT_BINDINGS = {
	"up_p1": InputMap.get_action_list("up_p1")[0],
	"down_p1": InputMap.get_action_list("down_p1")[0],
	"left_p1": InputMap.get_action_list("left_p1")[0],
	"right_p1": InputMap.get_action_list("right_p1")[0],
	"speed_p1": InputMap.get_action_list("speed_p1")[0],
	
	"up_p2": InputMap.get_action_list("up_p2")[0],
	"down_p2": InputMap.get_action_list("down_p2")[0],
	"left_p2": InputMap.get_action_list("left_p2")[0],
	"right_p2": InputMap.get_action_list("right_p2")[0],
	"speed_p2": InputMap.get_action_list("speed_p2")[0]
}

var CHANGED_BINDINGS = {
	"up_p1": InputMap.get_action_list("up_p1")[0],
	"down_p1": InputMap.get_action_list("down_p1")[0],
	"left_p1": InputMap.get_action_list("left_p1")[0],
	"right_p1": InputMap.get_action_list("right_p1")[0],
	"speed_p1": InputMap.get_action_list("speed_p1")[0],
	
	"up_p2": InputMap.get_action_list("up_p2")[0],
	"down_p2": InputMap.get_action_list("down_p2")[0],
	"left_p2": InputMap.get_action_list("left_p2")[0],
	"right_p2": InputMap.get_action_list("right_p2")[0],
	"speed_p2": InputMap.get_action_list("speed_p2")[0]
}

func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	if ( Input.is_action_just_pressed("escape") ):
		scene_manager.change_scene_to_previous()

func _input(event):
#	print(event)
	pass


func _on_commit_button_pressed():
	commit_bindings( CHANGED_BINDINGS )
	scene_manager.change_scene_to_previous()

func _on_revert_button_pressed():
	key_pickers_set( CURRENT_BINDINGS )
	changed_bindings_set( CURRENT_BINDINGS )

func _on_default_button_pressed():
	key_pickers_set( global.DEFAULT_BINDINGS )
	changed_bindings_set( global.DEFAULT_BINDINGS )
	
func _on_key_picker_event_set( action_name, event ):
	CHANGED_BINDINGS[action_name] = event
	
func commit_bindings( bindings ):
	for i in range(BINDINGS_NAME.size()):
		var binding_name = BINDINGS_NAME[i]
		if( InputMap.has_action( binding_name ) && bindings[binding_name] != null ):
			InputMap.action_erase_event(binding_name, CURRENT_BINDINGS[binding_name] )
			InputMap.action_add_event(binding_name, bindings[binding_name] )
func changed_bindings_set( bindings ):
	for i in range(BINDINGS_NAME.size()):
		var binding_name = BINDINGS_NAME[i]
		CHANGED_BINDINGS[binding_name] = bindings[binding_name]
func key_pickers_set( bindings ):
	for i in range(BINDINGS_NAME.size()):
		var binding_name = BINDINGS_NAME[i]
		KEY_PICKERS[binding_name].set_event( bindings[binding_name] )




func _on_back_button_pressed():
	scene_manager.change_scene_to_previous()


