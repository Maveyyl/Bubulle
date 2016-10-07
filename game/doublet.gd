extends Node2D

var state = global.DOUBLET_STATES.IDLE
var main_bulle
var second_bulle
var direction = global.DIRECTIONS.TOP

func _ready():
	pass
	
func set_falling():
	state = global.DOUBLET_STATES.FALLING
	
func set_main_bulle( bulle ):
	self.main_bulle = bulle
	add_child(self.main_bulle)
	
func set_second_bulle( bulle):
	self.second_bulle = bulle
	add_child(self.second_bulle)
	self.second_bulle.set_pos( -Vector2(0,global.BULLE_SIZE.y ) )
	
func rotate_clockwise():
	var vector_pos = self.second_bulle.get_pos() + (global.BULLE_SIZE/2)
	vector_pos.rotate(90)
	self.second_bulle.set_pos( vector_pos - (global.BULLE_SIZE/2) )
	
func rotate_counterclockwise():
	var vector_pos = self.second_bulle.get_pos() + (global.BULLE_SIZE/2)
	vector_pos.rotate(-90)
	self.second_bulle.set_pos( vector_pos - (global.BULLE_SIZE/2) )
