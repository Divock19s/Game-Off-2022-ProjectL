extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer3.play("New Anim")
	$AnimationPlayer.play("Start")
	$AnimationPlayer2.play("bg")


func _on_AnimationPlayer_animation_finished(anim_name):
	MusicPlayer.boss=false
	MusicPlayer._play()
	Global.maps=("res://Maps/Map1.tscn")
	var _k = get_tree().change_scene(Global.maps)
	
