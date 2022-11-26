extends Node2D

onready var player = $Player
onready var camera = $Player/Camera2D
onready var dia1=preload("res://Envirment/BlueGem.tscn")

func _ready():
	if !Global.fog:
		!$CanvasLayer2.call_deferred("queue_free")
	camera.smoothing_enabled=false
	$"One Dore".open=Global.diamonds>0
	if Global.posa=="down":
		$Down/CollisionShape2D.set_deferred("disabled",true)
		$Timer.start()
		$Player.global_position=$DownSpawn.global_position
	elif Global.posa=="up":
		$Player.global_position=$TopSpawn.global_position
		
	elif Global.posa=="right":
		$Player.global_position=$RightSpawn.global_position
	else:
		if Global.glo_pos!=Vector2.ZERO:
			player.global_position=Global.glo_pos
		else:
			pass
	Global.glo_pos=0
	$Drone.global_position=$Player.global_position
	camera.global_position=$Player.global_position
	camera.limit_left=0
	camera.limit_top=0
	camera.limit_right=2232
	camera.limit_bottom=640
	Global._save()

func _on_Down_body_entered(body):
	if "Player" in body.name:
		Global.posa="up"
		Global.maps=("res://Maps/Map3.tscn")
		$AnimationPlayer.play("FADE")

func _on_Timer_timeout():
	$Down/CollisionShape2D.set_deferred("disabled",false)

func _on_Player_diamonds_updated(diamonds, dir):
	if dir==-1:
		if diamonds==0:
			var d=dia1.instance()
			d.global_position=Vector2(528,176)
			add_child(d)

func _on_Top_body_entered(body):
	if "Player" in body.name:
		Global.posa="down"
		Global.maps=("res://Maps/Map1.tscn")
		$AnimationPlayer.play("FADE")

func _teleport():
	Global.posa="check"
	Global.maps="res://Maps/Map1.tscn"
	$AnimationPlayer.play("FADE")
func _on_Right_body_entered(body):
	if "Player" in body.name:
		Global.posa="left"
		Global.maps=("res://Maps/Map4.tscn")
		$AnimationPlayer.play("FADE")

func _on_AnimationPlayer_animation_finished(anim_name):
	player._store_health()
	var _k = get_tree().change_scene(Global.maps)
