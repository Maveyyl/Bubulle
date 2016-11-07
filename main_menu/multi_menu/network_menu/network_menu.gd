extends Node2D

const UI_STATES = {
	"DEFAULT": 0,
	"LISTENNING": 1,
	"CLIENT_CONNECTED": 2,
	"CONNECTING": 3,
	"CONNECTED": 4
}
var ui_state
	

# server elements
onready var server_text_edit_port = get_node("panel_server/text_edit_port")
onready var server_button_start_server = get_node("panel_server/button_start_server")
onready var server_button_stop_server = get_node("panel_server/button_stop_server")
onready var server_label_status = get_node("panel_server/label_status")
onready var server_checkbox_ready = get_node("panel_server/checkbox_ready")

# client elements
onready var client_text_edit_ip_addr = get_node("panel_client/text_edit_ip_addr")
onready var client_text_edit_port = get_node("panel_client/text_edit_port")
onready var client_button_connect_client = get_node("panel_client/button_connect_client")
onready var client_button_disconnect_client = get_node("panel_client/button_disconnect_client")
onready var client_label_status = get_node("panel_client/label_status")
onready var client_checkbox_ready = get_node("panel_client/checkbox_ready")

# neutral elements
onready var panel_game_starting = get_node("panel_game_starting")
onready var label_game_starting_status = get_node("panel_game_starting/label_game_starting_status")
onready var button_start_game = get_node("panel_game_starting/button_start_game")

func _ready():
	set_fixed_process(true)
	
	# server default values
	server_text_edit_port.set_text( str(network_manager.DEFAULT_PORT) )
	
	# client default values
	client_text_edit_ip_addr.set_text( network_manager.DEFAULT_IP_ADDR )
	client_text_edit_port.set_text( str(network_manager.DEFAULT_PORT) )

	get_tree().connect("server_disconnected", self, "server_disconnected")
	# connect signals to monitor client connexions
	get_tree().connect("network_peer_connected", self, "client_connected")
	get_tree().connect("network_peer_disconnected", self, "client_disconnected")
	
	# connect signals to monitor connexion to server
	get_tree().connect("connected_to_server", self, "connected_to_server")
	get_tree().connect("connection_failed", self, "connection_failed")
	

func _fixed_process(delta):
	if ( Input.is_action_just_pressed("escape") ):
		network_manager.disconnect()
		scene_manager.change_scene_to_previous()



# server buttons
func _on_button_start_server_pressed():
	var port = int( server_text_edit_port.get_text() )
	network_manager.create_server( port )
	set_ui_state_listenning()

func _on_button_stop_server_pressed():
	network_manager.peer.close_connection()
	set_ui_state_default()
	
func _on_server_checkbox_ready_pressed():
	rpc('set_server_ready', server_checkbox_ready.is_pressed()  )
	server_update_game_starting_status()
master func set_client_ready( readyness ):
	client_checkbox_ready.set_pressed(readyness)
	server_update_game_starting_status()

# server signals
func server_disconnected():
	set_ui_state_default()
	client_label_status.set_text("Disconnected from server")
	
func client_connected(id):
	set_ui_state_client_connected()
func client_disconnected(id):
	set_ui_state_listenning()
	server_label_status.set_text("Client disconnected")
	
	
	
	
	
	
	
	
	
	
# client buttons
func _on_button_connect_client_pressed():
	var ip_addr = client_text_edit_ip_addr.get_text()
	var port = int( client_text_edit_port.get_text() )
	network_manager.create_client(ip_addr, port)
	set_ui_state_connecting()

func _on_button_disconnect_client_pressed():
	network_manager.peer.close_connection()
	set_ui_state_default()
	
	

slave func set_server_ready( readyness ):
	server_checkbox_ready.set_pressed(readyness)
func _on_client_checkbox_ready_pressed():
	rpc('set_client_ready', client_checkbox_ready.is_pressed()  )


# client signals
func connected_to_server():
	set_ui_state_connected()
func connection_failed():
	set_ui_state_default()
	client_label_status.set_text("Connection to server failed")




# game starting panel
func server_update_game_starting_status():
	if( client_checkbox_ready.is_pressed() && server_checkbox_ready.is_pressed() ):
		rpc("client_update_game_starting_status")
		panel_game_starting.show()
		label_game_starting_status.set_text("Game ready\nto start")
		button_start_game.show()
	else:
		rpc("client_update_game_starting_status")
		panel_game_starting.hide()
		
		
slave func client_update_game_starting_status():
	if( client_checkbox_ready.is_pressed() && server_checkbox_ready.is_pressed() ):
		panel_game_starting.show()
		label_game_starting_status.set_text("Game ready\nto start\nWaiting for server\nto start")
		button_start_game.hide()
	else:
		panel_game_starting.hide()
		
		
func _on_button_start_game_pressed():
	rpc("start_game")
	start_game()
slave func start_game():
	scene_manager.change_scene_to( "multi_network" )





# UI states functions
func set_ui_state_default():
	ui_state = UI_STATES.DEFAULT
	
	server_button_start_server.show()
	server_button_stop_server.hide()
	server_checkbox_ready.hide()
	
	client_button_connect_client.show()
	client_button_disconnect_client.hide()
	client_checkbox_ready.hide()
	
	panel_game_starting.hide()
	
	server_label_status.set_text("")
	client_label_status.set_text("")
	
func set_ui_state_listenning():
	ui_state = UI_STATES.LISTENNING
	
	server_button_start_server.hide()
	server_button_stop_server.show()
	server_checkbox_ready.hide()
	
	client_button_connect_client.hide()
	client_button_disconnect_client.hide()
	client_checkbox_ready.hide()
	
	panel_game_starting.hide()
	
	server_label_status.set_text("Waiting for\nclient connection...")
	
func set_ui_state_client_connected():
	ui_state = UI_STATES.CLIENT_CONNECTED
	
	server_button_start_server.hide()
	server_button_stop_server.show()
	server_checkbox_ready.show()
	server_checkbox_ready.set_disabled(false)
	server_checkbox_ready.set_pressed(false)
	
	client_button_connect_client.hide()
	client_button_disconnect_client.hide()
	client_checkbox_ready.show()
	client_checkbox_ready.set_disabled(true)
	client_checkbox_ready.set_pressed(false)
	
	panel_game_starting.hide()
	
	server_label_status.set_text("Client connected")
	
	
	
func set_ui_state_connecting():
	ui_state = UI_STATES.CONNECTING
	
	server_button_start_server.hide()
	server_button_stop_server.hide()
	server_checkbox_ready.hide()
	
	client_button_connect_client.hide()
	client_button_disconnect_client.show()
	client_checkbox_ready.hide()
	
	panel_game_starting.hide()
	
	client_label_status.set_text("Connecting to\nserver...")
	
	
func set_ui_state_connected():
	ui_state = UI_STATES.CONNECTED
	
	server_button_start_server.hide()
	server_button_stop_server.hide()
	server_checkbox_ready.show()
	server_checkbox_ready.set_disabled(true)
	server_checkbox_ready.set_pressed(false)
	
	client_button_connect_client.hide()
	client_button_disconnect_client.show()
	client_checkbox_ready.show()
	client_checkbox_ready.set_disabled(false)
	client_checkbox_ready.set_pressed(false)
	
	panel_game_starting.hide()
	
	server_label_status.set_text("")
	client_label_status.set_text("Connected to server")



