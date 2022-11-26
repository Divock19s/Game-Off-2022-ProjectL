extends Node2D

func _ready():
	$AnimatedSprite.playing=false
	$AnimationPlayer.play("Start")

func _input(event):
	if event.is_action_pressed("esc"):
		$AnimationPlayer2.play("New Anim")

func _on_AnimationPlayer_animation_finished(_anim_name):
	$AnimationPlayer2.play("New Anim")

func _on_AnimationPlayer2_animation_started(anim_name):
	Global.maps="res://Maps/Map1.tscn"
	var _k = get_tree().change_scene("res://Maps/Map1.tscn")
