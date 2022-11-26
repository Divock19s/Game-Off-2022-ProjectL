extends Node2D

onready var player = $Player
onready var camera = $Player/Camera2D
onready var dia2=preload("res://Envirment/DarkBlueGem.tscn")
onready var dia4=preload("res://Envirment/RedGem.tscn")
onready var dia6=preload("res://Envirment/PurpleGem.tscn")

func _ready():
	if !Global.fog:
		!$CanvasLayer2.call_deferred("queue_free")
	camera.smoothing_enabled=false
	$"One Dore".open=Global.diamonds>0
	if Global.posa=="up":
		$Up/CollisionShape2D.set_deferred("disabled",true)
		$Timer.start()
		$Player.global_position=$up.global_position
	elif Global.posa=="up1":
		$Player.global_position=$up2.global_position
		
	elif Global.posa=="up2":
		$Player.global_position=$up3.global_position
	else:
		if Global.glo_pos!=Vector2.ZERO:
			player.global_position=Global.glo_pos
		else:
			pass
	$Drone.global_position=$Player.global_position
	camera.global_position=$Player.global_position
	camera.limit_left=0
	camera.limit_top=0
	camera.limit_right=3976
	camera.limit_bottom=384
	Global._save()

func _on_Timer_timeout():
	$Up/CollisionShape2D.set_deferred("disabled",false)

func _on_Player_diamonds_updated(diamonds, dir):
	if dir==-1:
		if diamonds==1:
			var d=dia2.instance()
			d.global_position=Vector2(3072,240)
			add_child(d)
		elif diamonds==3:
			var d=dia4.instance()
			d.global_position=Vector2(1824,192)
			add_child(d)
		elif diamonds==5:
			var d=dia6.instance()
			d.global_position=Vector2(72,272)
			add_child(d)

func _on_AnimationPlayer_animation_finished(anim_name):
	player._store_health()
	var _k = get_tree().change_scene(Global.maps)


func _on_Up3_body_entered(body):
	if "Player" in body.name:
		Global.posa="down2"
		Global.maps=("res://Maps/Map4.tscn")
		$AnimationPlayer.play("FADE")


func _on_Up2_body_entered(body):
	if "Player" in body.name:
		Global.posa="down"
		Global.maps=("res://Maps/Map4.tscn")
		$AnimationPlayer.play("FADE")

func _teleport():
	Global.posa="check"
	Global.maps="res://Maps/Map1.tscn"
	$AnimationPlayer.play("FADE")

func _on_Up_body_entered(body):
	if "Player" in body.name:
		Global.posa="down"
		Global.maps=("res://Maps/Map2.tscn")
		$AnimationPlayer.play("FADE")
