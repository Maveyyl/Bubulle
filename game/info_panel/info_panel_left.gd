extends Node2D

onready var doublet_slot = get_node('doublet_slot')
onready var score_label = get_node('score_label')
var doublet
var score = 0

func fromDictionnary(d):
	if( d.doublet ):
		doublet = global.SCENES.DOUBLET.instance()
		doublet.fromDictionnary(d.doublet)
	score = d.score
func toDictionnary():
	var data = {}
	if( doublet ):
		data.doublet = doublet.toDictionnary()
	data.score = score
	return data

func _ready():
	pass

func set_doublet( doublet ):
	self.doublet = doublet
	doublet.set_idle()
	if( doublet.get_parent() ):
		doublet.get_parent().remove_child(doublet)
	doublet_slot.add_child(doublet)
	doublet.set_pos(Vector2(0,0))
	
func set_score (score):
	self.score = score
	score_label.set_text( str(self.score) )
	