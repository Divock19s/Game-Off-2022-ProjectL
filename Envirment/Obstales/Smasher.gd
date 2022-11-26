extends Node2D

onready var player=get_parent().get_node("Player")
onready var collision=$Detect/CollisionShape2D
onready var dust = preload("res://Effects/BossLandDust.tscn")

func _Dust():
	var l=dust.instance()
	l.scale.x=0.8
	l.scale.y=0.8
	l.pos.x=global_position.x+3
	l.pos.y=global_position.y+13
	get_parent().add_child(l)

func _ready():
	$Container.position.y=-13.5
	$Container/Sprite.frame=1
func _on_Detect_body_entered(body):
	if "Player" in body.name:
		$AudioStreamPlayer2.play()
		$AnimationPlayer.play("Smash")
		$Container/Sprite.frame=0
		collision.set_deferred("disabled",true)
func _on_Hit_body_entered(body):
	if "Player" in body.name:
		body._kill(sign(body.global_position.x-global_position.x),2,50)
	if body.is_in_group("enemies"):
		if body.has_method("_piece"):
			body._piece()


func _on_AnimationPlayer_animation_finished(anim_name):
	if "Smash" in anim_name:
		player._shake(0.2,20,5,2)
		$AnimationPlayer.play("Restore")
		$Container/Sprite.frame=1
		_Dust()
		$AudioStreamPlayer.play()
	elif "Restore" in anim_name:
		collision.set_deferred("disabled",false)
