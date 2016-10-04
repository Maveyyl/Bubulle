extends Node

const DEFAULT_PORT = 4444
const DEFAULT_IP = "127.0.0.1"


var network_mode
var peer 

func _ready():
	pass


func create_server():
	# create network peer
	peer = NetworkedMultiplayerENet.new()
	# set it as a server listening to port DEFAULT_PORT
	peer.create_server(DEFAULT_PORT, 4)
	# link the peer to the tree
	get_tree().set_network_peer(peer)
	# our model is authoritative server, so everything is set to role master
	network_mode = NETWORK_MODE_MASTER
	get_tree().get_root().set_network_mode(network_mode)
	# connect signals to monitor connexions
	get_tree().connect("network_peer_connected", self, "client_connected")
	get_tree().connect("network_peer_disconnected", self, "client_disconnected")

func client_connected(id):
	print("client connected ", id)
func client_disconnected(id):
	print("client disconnected ", id)
	

	
func create_client(ip_addr):
	# create network peer
	peer = NetworkedMultiplayerENet.new()
	# set it as a client connectiong to ip_addr to port DEFAULT_PORT
	peer.create_client(ip_addr, DEFAULT_PORT)
	# link the peer to the tree
	get_tree().set_network_peer(peer)
	# our model is authoritative server, so everything is set to role slave
	network_mode = NETWORK_MODE_SLAVE
	get_tree().get_root().set_network_mode(network_mode)
	# connect signals to monitor connexions
	get_tree().connect("connected_to_server", self, "connected_to_server")
	
func connected_to_server():
	print("connected to server")
	
	