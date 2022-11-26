extends KinematicBody2D

signal health_updated(health)
signal diamonds_updated(diamonds,dir)
signal death()

var wallSpeed = 150
var walkSpeed = 50
var walkAcc = 500
var motion = Vector2.ZERO
var gravity = 500
var side=1
var dashDirection=1
var diamonds = Global.diamonds setget _set_diamonds
var health = Global.health setget _set_health
var dowcount = 1

var die=false
var kick=false
var dJump=true
var crouched = false
var dash =false
var dead = false
var dashable=true
var slideable=true
var shoot=false
var downKick=false
var bull=false
var sliding=false
var spawned = false
var hurtable = true

var canSlide=true
var canDoubleJump=true
var canDash=true
var canWallJump=true
var canShoot=true
var canDownKick=true
var ready = false

onready var sprite=$Sprite
onready var plAnimation=$pAnimation
onready var dashTimer=$Dashtimer
onready var wallSlideTimer=$wSlideTimer 
onready var runDustTimer=$RunDustTimer
onready var wallDustTimer=$WallDustTimer
onready var slideDustTimer=$SlideDustTimer
onready var dashEffectTimer=$DashEffectTimer
onready var downTimer=$downTimer
onready var downShape=$Down/CollisionShape2D
onready var kickShape=$Kick/CollisionShape2D
onready var DownKick=$DownKick
onready var Shoot=$Shoot
onready var camera=$Camera2D
onready var shake=$Camera2D/Tween
onready var squash=$Squash

onready var shootSound=$Shoot2
onready var attackSound=$Attack
onready var dashSound=$Dash
onready var deathSound=$Death
onready var downSound=$Down2
onready var footSound=$FootStep
onready var hitSound=$Hit
onready var hurtSound=$Hurt
onready var jumpSound=$Jump
onready var doubleJumpSound=$DoubleJump
onready var getDiamond=$GetDiamond
onready var looseDiamone=$LooseDiamond
onready var landSound=$Land
onready var slideSound=$Slide

onready var bullet=preload("res://Player/Bullet.tscn")
onready var RunDust=preload("res://Effects/WalkDust.tscn")
onready var ImpactDust=preload("res://Effects/ImpactDust.tscn")
onready var ImpactDust2=preload("res://Effects/ImpactDust2.tscn")
onready var ImpactDust3=preload("res://Effects/ImpactDust3.tscn")
onready var WallDust=preload("res://Effects/WallDust.tscn")
onready var LandDust=preload("res://Effects/LandDust.tscn")
onready var JumpDust=preload("res://Effects/JumpDust.tscn")
onready var SlideDust=preload("res://Effects/SlideDust.tscn")
onready var DashEffect=preload("res://Effects/DashEffect.tscn")
onready var explo=preload("res://Envirment/Explosion.tscn")

func _ready():
	sprite.position=Vector2.ZERO
	_set_health(Global.health)
	_set_diamonds(Global.diamonds)
	_reset_attack()
	$Ready.start()
	dead=false
	Global.dead=false

func _kill(dir,amm,kno):
		if hurtable or amm==4:
			_set_health(health-amm)
			_knock(dir,kno)
			_knock_up(kno/2)

func _shake(duration=0.2,frequency=15,amplitude=16,priority=0):
	shake._start(duration,frequency,amplitude,priority)

func _bullet():
	if !bull and Shoot.frame==1:
		var b=bullet.instance()
		b.global_position=Shoot.global_position
		b.direction=sign(Shoot.position.x)
		get_parent().add_child(b)
		bull=true

func _ImpactDust(position,x,y,color1,color2,color3,second):
	var i=ImpactDust.instance()
	i.scale.x=x
	i.scale.y=y
	i.modulate = Color8(color1,color2,color3)
	i.pos=position
	get_parent().add_child(i)
	if second:
		var i2=ImpactDust3.instance()
		i2.scale.x=x*0.5
		i2.scale.y=x*0.5
		i2.modulate = Color8(color1,color2,color3)
		i2.pos=position
		get_parent().add_child(i2)

func _RunDust():
	var d=RunDust.instance()
	d.pos=global_position
	d.flipp=sign(Shoot.position.x)
	get_parent().add_child(d)
	
func _WallDust():
	var w=WallDust.instance()
	w.pos=global_position
	w.flipp=sign(Shoot.position.x)
	get_parent().add_child(w)

func _JumpDust():
	var j=JumpDust.instance()
	j.pos=global_position
	get_parent().add_child(j)

func _LandDust():
	var l=LandDust.instance()
	l.pos=global_position
	get_parent().add_child(l)

func _SlideDust():
	var s=SlideDust.instance()
	s.pos=global_position
	s.flipp=sign(Shoot.position.x)
	get_parent().add_child(s)

func _DashEffect():
	var d=DashEffect.instance()
	d.pos=global_position
	d.flipp=sign(Shoot.position.x)
	get_parent().add_child(d)

func _reset_attack():
	downShape.set_deferred("disabled",true)
	kickShape.set_deferred("disabled",true)
	DownKick.frame=9
	Shoot.frame=4

func _knock_up(amount):
	if !dead:
		_shake(0.2,7,2,0)
		_doubleJump(amount)

func _knock(amount,drctn):
	if !dead:
		_shake(0.2,7,2,0)
		motion.x=0
		motion.x+=amount*drctn

func _direction(direction):
	if direction!=0:
		if direction<0:
			sprite.flip_h=true
			Shoot.flip_h=true
			DownKick.flip_h=true
			Shoot.position.x=-9
			kickShape.position.x=-9
		else:
			sprite.flip_h=false
			Shoot.flip_h=false
			DownKick.flip_h=false
			Shoot.position.x=9
			kickShape.position.x=9
		dashDirection=direction

func _camera(dir):
	camera.position.x=lerp(camera.position.x,50*dir,0.05)

func _walk(dir):
	if dir !=0:
		motion.x += dir*walkAcc
		motion.x=clamp(motion.x,-walkSpeed,walkSpeed)
	else:
		motion.x = int(lerp(motion.x,0,0.35))

func _air(dir):
	if !is_on_floor():
		if dir !=0:
			motion.x += dir*walkAcc/4
			motion.x=clamp(motion.x,-walkSpeed,walkSpeed)
		else:
			motion.x = lerp(motion.x,0,0.05)

func _wallSlide():
	motion.y=0
	gravity = 50
	if _rightWall():
		dashDirection=-1
		sprite.flip_h = true
		Shoot.flip_h=true
		DownKick.flip_h=true
		Shoot.position.x=-9
		kickShape.position.x=-9
		side=-1
		return -1
	elif _leftWall():
		dashDirection=1
		sprite.flip_h = false
		Shoot.flip_h=false
		DownKick.flip_h=false
		Shoot.position.x=9
		kickShape.position.x=9
		side=1
		return 1

func _wallJump(jum):
	motion.y=0
	_jump(jum)
	if _rightWall():
		sprite.flip_h = true
		motion.x+= -wallSpeed
	elif _leftWall():
		sprite.flip_h = false
		motion.x+= wallSpeed

func _slide():
	$CrouchCollision.set_deferred("disabled",true)

func _crouch():
	$CrouchCollision.set_deferred("disabled",true)
	walkSpeed=20
	walkAcc=100
	crouched = true

func _uncrouch():
	$CrouchCollision.set_deferred("disabled",false)
	walkSpeed = 50
	walkAcc = 500
	crouched = false

func _jump(jum):
	motion.y+=-jum

func _doubleJump(jum):
	motion.y=0
	motion.y+=-jum

func _physics(grav,del):
	if !dash or sliding:
		motion.y+=gravity*del
		motion.y=clamp(motion.y,-gravity,gravity)
	else:
		motion.y=0
	var snap=Vector2.DOWN
	motion=move_and_slide_with_snap(motion,snap,Vector2.UP)

func _roof():
	return $Up1.is_colliding() or $Up2.is_colliding()

func _leftWall():
	return $Left.is_colliding() or $Left2.is_colliding()

func _rightWall():
	return $Right.is_colliding() or $Right2.is_colliding()

func _dash(dir,slide):
	sliding=slide
	motion.x = dir*walkAcc*4
	motion.x=clamp(motion.x,-walkSpeed*6,walkSpeed*6)

func _on_Dashtimer_timeout():
	slideable=true

func _on_wSlideTimer_timeout():
	if _rightWall():
		sprite.flip_h = true
		motion.x+= -50
	elif _leftWall():
		sprite.flip_h = false
		motion.x+= 50


func _on_pAnimation_animation_finished(anim_name):
	if anim_name == "AirKick":
		kick=false
		dash=false
	elif anim_name == "Slide":
		sliding=false
		dash=false
	elif anim_name == "Kick":
		kick=false
	elif anim_name == "DownKick":
		downKick=false
	elif anim_name == "Shoot":
		shoot=false
	elif anim_name =="Death":
		Global.dead=true
		Global.health=4
		emit_signal("death")

func _on_Kick_body_entered(body):
	_ImpactDust(kickShape.global_position,1,1,0,199,255,false)
	hitSound.play()
	if body.is_in_group("enemies"):
		if !slideable:
			body._hurt("fail",dashDirection,0,0,0)
		elif dash:
			_knock(25,-dashDirection)
			body._hurt("Attack",dashDirection,30,50,70)
		elif kick:
			_knock(25,-dashDirection)
			body._hurt("Attack",dashDirection,15,40,50)
		elif shoot:
			_knock(25,-dashDirection)
			body._hurt("Attack",dashDirection,20,40,50)

func _on_Down_body_entered(body):
	downTimer.stop()
	motion.y=0
	_knock_up(200)
	hitSound.play()
	if !spawned:
		if body.is_in_group("enemies"):
			body._hurt("Attack",dashDirection,30,0,0)
		_ImpactDust(downShape.global_position,1.5,1.5,0,199,255,true)
		spawned = true


func _on_RunDustTimer_timeout():
	_RunDust()
	runDustTimer.start()


func _on_SlideDustTimer_timeout():
	_SlideDust()
	slideDustTimer.start()


func _on_DashEffectTimer_timeout():
	_DashEffect()
	dashEffectTimer.start()


func _on_WallDustTimer2_timeout():
	_WallDust()
	wallDustTimer.start()

func _die():
	var r = explo.instance()
	r.global_position=global_position
	r.modulate=Color8(0,199,255)
	get_parent().call_deferred("add_child",r)
	dead=true
	_reset_attack()

func _diamond():
	if diamonds<6:
		_set_diamonds(diamonds-1)
func _store_health():
	Global.health=health
func _set_diamonds(d):
	var prevd=diamonds
	diamonds= clamp(d,0,6)
	if diamonds!=prevd:
		if diamonds-prevd<0:
			if ready:
				looseDiamone.play()
			Global.diamonds=diamonds
			emit_signal("diamonds_updated",diamonds,-1)
		elif diamonds-prevd>0:
			if ready:
				getDiamond.play()
			Global.diamonds=diamonds
			emit_signal("diamonds_updated",diamonds,1)

func _set_health(h):
	var prevh=health
	health= clamp(h,0,4)
	if health!=prevh:
		if sign(prevh-health)>=0:
			hurtSound.play()
		else:
			getDiamond.play()
		emit_signal("health_updated",health)
	if health==0:
		deathSound.play()
		_die()
	else:
		hurtable=false
		$HurtAnimation.play("Hurt")

func _on_HurtAnimation_animation_finished(anim_name):
	hurtable=true

func _on_downTimer_timeout():
	motion.y+=800


func _on_Ready_timeout():
	ready=true


func _on_Area2D_body_entered(body):
	if !("Player" in body.name) and !body.is_in_group("enemies"):
		deathSound.play()
		_die()
