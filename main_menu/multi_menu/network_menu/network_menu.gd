extends Node2D

# server elements
onready var server_text_edit_port = get_node("panel_server/text_edit_port")
onready var server_button_start_server = get_node("panel_server/button_start_server")
onready var server_button_stop_server = get_node("panel_server/button_stop_server")

# client elements
onready var client_text_edit_ip_addr = get_node("panel_client/text_edit_ip_addr")
onready var client_text_edit_port = get_node("panel_client/text_edit_port")
onready var client_button_connect_client = get_node("panel_client/button_connect_client")
onready var client_button_disconnect_client = get_node("panel_client/button_disconnect_client")

func _ready():
	# server default values
	server_text_edit_port.set_text( str(network_manager.DEFAULT_PORT) )
	
	# client default values
	client_text_edit_ip_addr.set_text( network_manager.DEFAULT_IP_ADDR )
	client_text_edit_port.set_text( str(network_manager.DEFAULT_PORT) )

# server functions
func _on_button_start_server_pressed():
	var port = int( server_text_edit_port.get_text() )
	network_manager.create_server( port )
	
	server_button_start_server.hide()
	server_button_stop_server.show()
	client_button_connect_client.hide()
	client_button_disconnect_client.hide()

func _on_button_stop_server_pressed():
	network_manager.peer.close_connection()
	
	server_button_start_server.show()
	server_button_stop_server.hide()
	client_button_connect_client.show()
	client_button_disconnect_client.hide()
	

func _on_button_connect_client_pressed():
	var ip_addr = client_text_edit_ip_addr.get_text()
	var port = int( client_text_edit_port.get_text() )
	network_manager.create_client(ip_addr, port)
	
	client_button_connect_client.hide()
	client_button_disconnect_client.show()
	server_button_start_server.hide()
	server_button_stop_server.hide()

func _on_button_disconnect_client_pressed():
	network_manager.peer.close_connection()
	
	client_button_connect_client.show()
	client_button_disconnect_client.hide()
	server_button_start_server.show()
	server_button_stop_server.hide()
