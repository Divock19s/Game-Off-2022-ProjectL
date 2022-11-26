extends Node2D

export var move_to =Vector2.RIGHT *8
export var speed = 3.0
onready var platform=$Platform
var follow =Vector2.ZERO

func _ready():
	_init_tween()

func _init_tween():
	var duration = move_to.length()/float(speed*8)
	$Tween.interpolate_property(self,"follow",Vector2.ZERO,move_to,duration,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,1.0)
	$Tween.interpolate_property(self,"follow",move_to,Vector2.ZERO,duration,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,duration+2.0)
	$Tween.start()

func _physics_process(delta):
	$Platform.position = $Platform.position.linear_interpolate(follow,0.075)
	$Sprite.position=lerp($Sprite.position,$Platform.position,0.5)

func _on_Tween_tween_all_completed():
	_init_tween()
