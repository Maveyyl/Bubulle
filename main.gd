extends Node2D


const solo = preload('res://main_menu/main_menu.tscn')

func _ready():
	get_tree().change_scene_to( solo )
	pass