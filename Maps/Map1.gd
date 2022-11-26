extends Node2D

onready var player = $Player
onready var camera = $Player/Camera2D

func _ready():
	if !Global.fog:
		!$CanvasLayer.call_deferred("queue_free")
	camera.smoothing_enabled=false
	if Global.progress>0:
		_on_Text1_text_done()
	if Global.posa=="new":
		pass
	else:
		if Global.posa=="down":
			$Down/CollisionShape2D.set_deferred("disabled",true)
			player.global_position=$down.global_position
		elif Global.posa=="up":
			player.global_position=$up.global_position
		elif Global.posa=="right":
			player.global_position=$right.global_position
		else:
			player.global_position=Vector2(64,144)
		$Drone.global_position=$Player.global_position
		camera.global_position=$Player.global_position
	camera.limit_left=0
	camera.limit_top=0
	camera.limit_right=1664
	camera.limit_bottom=256
	Global._save()

func _on_Text1_text_done():
	if Global.progress<1:
		Global.progress=1
	$Door._open()

func _teleport():
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	player._store_health()
	var _k = get_tree().change_scene(Global.maps)


func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		Global.posa="up"
		if Global.progress<1:
			Global.progress==1
		Global.maps="res://Maps/Map2.tscn"
		$AnimationPlayer.play("FADE")


func _on_Up_body_entered(body):
	if "Player" in body.name:
		Global.posa="down"
		Global.maps="res://Maps/Map6.tscn"
		$AnimationPlayer.play("FADE")


func _on_right2_body_entered(body):
	if "Player" in body.name:
		Global.posa="left"
		Global.maps="res://Maps/Map5.tscn"
		$AnimationPlayer.play("FADE")
