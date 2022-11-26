extends Control

func _ready():
	visible=false

func _input(event):
	if visible:
		if ! $AudioStreamPlayer.playing and !(event is InputEventMouseMotion):
			$AudioStreamPlayer.play()

func _on_Resume_pressed():
	get_tree().paused=false
	visible=false
	var _k = get_tree().change_scene(Global.maps)

func _on_Quit_pressed():
	get_tree().paused=false
	var _k = get_tree().change_scene("res://Menu/MainManu.tscn")


func _on_Player_death():
	get_tree().paused=!get_tree().paused
	if get_tree().paused:
		visible=true
		$CenterContainer/VBoxContainer/Resume.grab_focus()
	else:
		visible=false
