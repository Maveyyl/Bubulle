extends Node2D

var doublet

func _ready():
	pass

func set_doublet_to_display( doublet ):
	self.doublet = doublet
	doublet.set_idle()