extends Node

const DEFAULT_PORT = 4444
const DEFAULT_IP_ADDR = "127.0.0.1"


var network_mode
var peer 

func _ready():
	set_signals()
	pass


func create_server(port):
	if( port == null ):
		port = DEFAULT_PORT
	# create network peer
	peer = NetworkedMultiplayerENet.new()
	# set it as a server listening to port DEFAULT_PORT, only 1 possible connection
	peer.create_server(port, 1)
	# link the peer to the tree
	get_tree().set_network_peer(peer)
	# our model is authoritative server, so everything is set to role master
	network_mode = NETWORK_MODE_MASTER
	get_tree().get_root().set_network_mode(network_mode)
	


	
func create_client(ip_addr, port):
	if( port == null ):
		port = DEFAULT_PORT
	# create network peer
	peer = NetworkedMultiplayerENet.new()
	# set it as a client connectiong to ip_addr to port DEFAULT_PORT
	peer.create_client(ip_addr, port)
	# link the peer to the tree
	get_tree().set_network_peer(peer)
	# our model is authoritative server, so everything is set to role slave
	network_mode = NETWORK_MODE_SLAVE
	get_tree().get_root().set_network_mode(network_mode)
	
func set_signals():
	get_tree().connect("server_disconnected", self, "server_disconnected")
	# connect signals to monitor client connexions
	get_tree().connect("network_peer_connected", self, "client_connected")
	get_tree().connect("network_peer_disconnected", self, "client_disconnected")
	
	# connect signals to monitor connexion to server
	get_tree().connect("connected_to_server", self, "connected_to_server")
	get_tree().connect("connection_failed", self, "connection_failed")
	
func server_disconnected():
	print("server disconnected")
	
func client_connected(id):
	print("client connected ", id)
func client_disconnected(id):
	print("client disconnected ", id)
	
func connected_to_server():
	print("connected to server")
func connection_failed():
	print("connection failed")
	
	