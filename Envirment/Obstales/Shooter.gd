extends StaticBody2D

onready var bullet=preload("res://Enemies/Eullet.tscn")
onready var Spos=$Position2D
onready var Cast=$RayCast2D
onready var coolTimer=$CoolTimer

var shoot=false
var shot =false

export (int) var direction = -1
export (int) var distance = 50

func _ready():
	_turn(direction)

func _process(delta):
	if !shoot:
		if _Detect():
			coolTimer.start()
			$AnimatedSprite.frame=1
			shoot=true
	elif shoot and shot:
		if $AnimatedSprite.frame==2:
			_shoot()
			shot=false

func _shoot():
	var b=bullet.instance()
	b.global_position=Spos.global_position
	b.direction=sign(Spos.position.x)
	get_parent().add_child(b)

func _turn(dir):
	$AnimatedSprite.flip_h=dir==1
	Spos.position.x=dir*4
	Cast.cast_to=Vector2(distance*direction,0)

func _Detect():
	if Cast.is_colliding():
		var collider=Cast.get_collider().name
		if collider=="Player":
			return true
	


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.playing=false
	$AnimatedSprite.frame=0
	shoot=false


func _on_CoolTimer_timeout():
	$AnimatedSprite.play("Shoot")
	shot=true
