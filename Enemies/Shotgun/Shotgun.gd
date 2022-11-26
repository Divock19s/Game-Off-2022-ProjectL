extends KinematicBody2D

signal health_updated(health)

var detect=false
var attack=false
var battack=false
var hurt=false
var fale=false
var turn=true
var dead=false
var stand=false
var inno = false
export (int) var direction = 1

var max_health = 40
var health = max_health setget _set_health
var speed = 20
var gravity = 500
var failDirection =1
var motion=Vector2.ZERO

onready var player=get_parent().get_node("Player")
onready var bullet=preload("res://Enemies/Eullet.tscn")
onready var Spos=$ShootPosition
onready var flor=$Floor
onready var front=$Front
onready var back=$Back
onready var animation=$AnimationPlayer
onready var DetectTimer=$DetectTimer
onready var BulletTimer=$BulletTimer
onready var ShootTimer=$ShootTimer
onready var FailTimer=$FailTimer
onready var wallTimer=$WallTimer
onready var sprite=$Sprite
onready var hitShape2=$Collide/CollisionShape2D

onready var hitSound=$Hit
onready var hurtSound=$Hurt
onready var deadSound=$Dead

func _reset():
	hitShape2.set_deferred("disabled",true)
	BulletTimer.stop()
	FailTimer.stop()

func _ready():
	sprite.position.y=-10
	_turn(direction)
func _shoot():
	var b=bullet.instance()
	b.global_position=Spos.global_position
	b.direction=sign(Spos.position.x)
	get_parent().add_child(b)

func _hurt(type="fail",direct=0,damage=0,x=0,y=0):
	hitShape2.set_deferred("disabled",true)
	if type=="fail":
		if !fale:
			fale=true
			$HurtTimer.stop()
			failDirection=direct
	else:
		if !fale:
			$HurtTimer.start()
			_knock_up(y)
			_knock(x,direct)
			hurt=true
		_set_health(health-damage)
	if direct==direction:
		_turn(1)
func _set_health(h):
	var prevh=health
	health= clamp(h,0,max_health)
	if health!=prevh:
		hurtSound.play()
		emit_signal("health_updated",health)
	if health==0:
		deadSound.play()
		dead=true

func _knock_up(amount):
	motion.y=0
	motion.y+=-amount

func _knock(amount,drctn):
	motion.x=0
	motion.x+=amount*drctn

func _fale(dir):
	failDirection=dir
	fale=true

func _move():
	motion.x+=speed*direction
	motion.x=clamp(motion.x,-speed,speed)

func _physics(delta):
	motion.y+=gravity*delta
	if motion.y>gravity:
		motion.y=gravity
	motion=move_and_slide(motion,Vector2.UP)

func _floor():
	return !flor.is_colliding()

func _back():
	var _name=back.get_collider()
	if _name!=null:
		if _name.name=="Player" :
			return true

func _front():
	return front.is_colliding()

func _detect():
	var _name=front.get_collider()
	if _name!=null:
		if _name.name=="Player" :
			if get_global_transform().origin.distance_to(front.get_collision_point()) <=20:
				return 2
			return 1
		return 3
	return 3

func _turn(dir):
	if turn:
		$Sprite.flip_h=dir==-1
		direction=dir
		flor.position.x=4*dir
		front.scale.x=dir
		front.position.x=dir*4
		back.scale.x=dir
		back.position.x=dir*-4
		Spos.position.x=dir*5
		turn=false
		wallTimer.start()


func _on_DetectTimer_timeout():
	detect=false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name=="Attack":
		battack=false
	elif anim_name=="Hurt":
		hurt=false
	elif anim_name=="StandFront":
		stand=false
	elif anim_name=="StandBack":
		stand=false
	elif anim_name=="Die":
		if !inno:
			player._diamond()
		call_deferred("queue_free")


func _on_WallTimer_timeout():
	turn=true


func _on_FailTimer_timeout():
	fale=false


func _on_ShootTimer_timeout():
	attack=true


func _on_BulletTimer_timeout():
	_shoot()


func _on_Collide_body_entered(body):
	if "Player" in body.name:
		hitSound.play()
		hitShape2.set_deferred("disabled",true)
		body._kill(direction,1,50)
		$HurtTimer.start()
	if "TileMap" in body.name:
		_piece()
func _piece():
		inno=true
		deadSound.play()
		dead=true


func _on_HurtTimer_timeout():
	hitShape2.set_deferred("disabled",false)
