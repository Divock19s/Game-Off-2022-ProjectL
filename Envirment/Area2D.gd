extends StaticBody2D
func _hurt(_type,_direct,_damage,_x,_y):
	get_parent().get_parent().get_parent()._teleport()
