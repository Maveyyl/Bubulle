extends Node2D

onready var double_game_panel = get_node('double_game_panel')

onready var game_panel_p1 = get_node('double_game_panel/game_panel_p1')
onready var info_panel_p1 = get_node('double_game_panel/info_panel_p1')

onready var game_panel_p2 = get_node('double_game_panel/game_panel_p2')
onready var info_panel_p2 = get_node('double_game_panel/info_panel_p2')

onready var chat = get_node("chat")
var chat_focused = false

func _ready():
	
	get_tree().connect("server_disconnected", self, "server_disconnected")
	get_tree().connect("network_peer_disconnected", self, "peer_disconnected")
	set_process(true)


func server_disconnected( ):
	network_manager.disconnect()
	scene_manager.change_scene_to_previous()
func peer_disconnected( id ):
	network_manager.disconnect()
	scene_manager.change_scene_to_previous()
	
remote func sync_game( d ):
	double_game_panel.fromDictionnary( d )

func _process(delta):
	if( !network_manager.is_active ):
		set_process(false)
		return
	if ( Input.is_action_just_pressed("escape") ):
		network_manager.disconnect()
		scene_manager.change_scene_to_previous()
		
	var game_panel
	var game_panel_ad
	if( is_network_master() ):
		game_panel = game_panel_p1
		game_panel_ad = game_panel_p2
	else:
		game_panel = game_panel_p2
		game_panel_ad = game_panel_p1
		
	if( !chat_focused ):
		if( Input.is_action_pressed("up_p1") ):
			game_panel.rotate_doublet_clockwise()
		if( Input.is_action_pressed("down_p1") ):
			game_panel.rotate_doublet_counterclockwise()
			
		if( Input.is_action_pressed("left_p1") ):
			game_panel.move_doublet_left()
		if( Input.is_action_pressed("right_p1") ):
			game_panel.move_doublet_right()
			
		if( Input.is_action_pressed("speed_p1") ):
			game_panel.increase_doublet_falling_speed()
		elif( !Input.is_action_pressed("speed_p1") ):
			game_panel.decrease_doublet_falling_speed()

	rpc("sync_game", double_game_panel.toDictionnary(false))
	
func set_chat( chat ):
	remove_child(self.chat)
	chat.get_parent().remove_child(chat)
	add_child(chat)
	self.chat = chat
	
	chat.connect("chat_focus_enter", self, "chat_focus_enter")
	chat.connect("chat_focus_exit", self, "chat_focus_exit")

func chat_focus_enter():
	chat_focused = true
func chat_focus_exit():
	chat_focused = false
