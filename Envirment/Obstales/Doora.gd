extends StaticBody2D
onready var player=get_parent().get_node("Player")
func _hurt(_a,_b,_c,_d,_e):
	_open()
	player._diamond()
func _open():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("Open")
