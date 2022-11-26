extends Area2D
onready var ImpactDust=preload("res://Effects/ImpactDust.tscn")
onready var ImpactDust3=preload("res://Effects/ImpactDust2.tscn")
var speed = 200
var direction = 1

func _ready():
	$Timer.start()

func _process(delta):
	position.x+=direction*speed*delta
	if direction<0:
		$Sprite.flip_h=true
		$Particles2D.position.x=2

func _ImpactDust(position,x,y,color1,color2,color3):
	var i=ImpactDust.instance()
	i.scale.x=x
	i.scale.y=y
	i.modulate = Color8(color1,color2,color3)
	i.pos=position
	get_parent().add_child(i)
	var i2=ImpactDust3.instance()
	i2.scale.x=x*0.7
	i2.scale.y=x*0.7
	i2.modulate = Color8(color1,color2,color3)
	i2.pos=position
	get_parent().add_child(i2)

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies"):
		body._hurt("Attack",direction,15,20,25)
	_ImpactDust(global_position,1,1,0,199,255)
	call_deferred("queue_free")


func _on_Timer_timeout():
	_ImpactDust(global_position,1,1,0,199,255)
	call_deferred("queue_free")
