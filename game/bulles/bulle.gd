extends Node2D

export(int, "RED","GREEN","YELLOW","PURPLE","CYAN","BLACK") var type
var state = global.BULLE_STATES.POSITIONING

onready var extent_left = get_node("base/extent_left")
onready var extent_top = get_node("base/extent_top")
onready var extent_right = get_node("base/extent_right")
onready var extent_bottom = get_node("base/extent_bottom")

func _ready():
	pass
	
func remove_extents():
	extent_left.hide()
	extent_top.hide()
	extent_right.hide()
	extent_bottom.hide()
	
func set_positioning():
	remove_extents()
	
func set_falling():
	remove_extents()
	
func set_in_place( neighbours ):
	if( neighbours[global.DIRECTIONS.LEFT] && neighbours[global.DIRECTIONS.LEFT].type == type ):
		extent_left.show()
	if( neighbours[global.DIRECTIONS.TOP] && neighbours[global.DIRECTIONS.TOP].type == type ):
		extent_top.show()
	if( neighbours[global.DIRECTIONS.RIGHT] && neighbours[global.DIRECTIONS.RIGHT].type == type  ):
		extent_right.show()
	if( neighbours[global.DIRECTIONS.BOTTOM] && neighbours[global.DIRECTIONS.BOTTOM].type == type ):
		extent_bottom.show()
		
	