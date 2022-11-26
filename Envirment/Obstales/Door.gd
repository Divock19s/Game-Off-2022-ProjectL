extends StaticBody2D
onready var player=get_parent().get_parent().get_node("Player")
func _hurt(_a,_b,_c,_d,_e):
	player._diamond()
	get_parent()._open()
