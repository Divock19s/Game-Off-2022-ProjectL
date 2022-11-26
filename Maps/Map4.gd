extends Node2D

onready var player = $Player
onready var camera = $Player/Camera2D
onready var dia3=preload("res://Envirment/GreenGem.tscn")

func _ready():
	if !Global.fog:
		!$CanvasLayer2.call_deferred("queue_free")
	camera.smoothing_enabled=false
	$"One Dore".open=Global.diamonds>0
	if Global.posa=="left":
		$Player.global_position=$left.global_position
	elif Global.posa=="down":
		$Player.global_position=$down.global_position
	elif Global.posa=="down2":
		$Player.global_position=$down2.global_position
	elif Global.posa=="up":
		$Player.global_position=$up.global_position
	else:
		if Global.glo_pos!=Vector2.ZERO:
			player.global_position=Global.glo_pos
		else:
			pass
	$Drone.global_position=$Player.global_position
	camera.global_position=$Player.global_position
	camera.limit_left=0
	camera.limit_top=0
	camera.limit_right=1848
	camera.limit_bottom=640
	Global._save()

func _on_Player_diamonds_updated(diamonds, dir):
	if dir==-1:
		if diamonds==2:
			var d=dia3.instance()
			d.global_position=Vector2(3072,240)
			add_child(d)
func _on_AnimationPlayer_animation_finished(anim_name):
	player._store_health()
	var _k = get_tree().change_scene(Global.maps)

func _teleport():
	Global.posa="check"
	Global.maps="res://Maps/Map1.tscn"
	$AnimationPlayer.play("FADE")

func _on_downArea_body_entered(body):
	if "Player" in body.name:
		Global.posa="up1"
		Global.maps=("res://Maps/Map3.tscn")
		$AnimationPlayer.play("FADE")


func _on_downArea2_body_entered(body):
	if "Player" in body.name:
		Global.posa="up2"
		Global.maps=("res://Maps/Map3.tscn")
		$AnimationPlayer.play("FADE")

func _on_upArea_body_entered(body):
	if "Player" in body.name:
		Global.posa="down"
		Global.maps=("res://Maps/Map5.tscn")
		$AnimationPlayer.play("FADE")

func _on_leftArea_body_entered(body):
	if "Player" in body.name:
		Global.posa="right"
		Global.maps=("res://Maps/Map2.tscn")
		$AnimationPlayer.play("FADE")
