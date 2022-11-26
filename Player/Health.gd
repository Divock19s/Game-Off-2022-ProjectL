extends Control
onready var Health_tween=$Control/Tween

onready var heart1=$Control/Heart_1
onready var heart2=$Control/Heart_2
onready var heart=heart1

onready var Diamond_tween=$Diamonds/Tween

onready var diamond1 = $Diamonds/Diamond1
onready var diamond2 = $Diamonds/Diamond2
onready var diamond3 = $Diamonds/Diamond3
onready var diamond4 = $Diamonds/Diamond4
onready var diamond5 = $Diamonds/Diamond5
onready var diamond6 = $Diamonds/Diamond6
onready var diamond = diamond1

const EZ= Tween.EASE_IN_OUT
const T=Tween.TRANS_SINE
var A=1

onready var hD=$Control/Health_Duration
onready var hF=$Control/Health_Frequency 

onready var dD=$Diamonds/Diamond_Duration
onready var dF=$Diamonds/Diamond_Frequency 

func _ready():
		if Global.health==1:
			heart2.frame=1
			heart1.frame=0
		elif Global.health==2:
			heart2.frame=2
			heart1.frame=0
		elif Global.health==3:
			heart2.frame=2
			heart1.frame=1
		elif Global.health==4:
			heart2.frame=2
		if Global.diamonds==0:
			return
		if Global.diamonds>=1:
			diamond1.frame=0
		if Global.diamonds>=2:
			diamond2.frame=0
		if Global.diamonds>=3:
			diamond3.frame=0
		if Global.diamonds>=4:
			diamond4.frame=0
		if Global.diamonds>=5:
			diamond5.frame=0
		if Global.diamonds>=6:
			diamond6.frame=0

func _diamond_start(sprite):
	dD.wait_time=0.2
	dF.wait_time=0.05
	dF.start()
	dD.start()
	_shake(Diamond_tween,sprite)

func _health_start(sprite):
	hD.wait_time=1
	hF.wait_time=0.05
	hF.start()
	hD.start()
	_shake(Health_tween,sprite)

func _shake(tween,sprite):
		var rand=Vector2()
		rand.x=rand_range(-A,A)
		rand.y=rand_range(-A,A)
		tween.interpolate_property(sprite,"offset",sprite.offset,rand,0.05,T,EZ)
		tween.start()
		if sprite.modulate==Color8(255,255,255,255):
			sprite.modulate=Color8(255,255,255,0)
		elif sprite.modulate==Color8(255,255,255,0):
			sprite.modulate=Color8(255,255,255,255)
func _reset(tween,sprite):
	tween.interpolate_property(sprite,"offset",sprite.offset,Vector2.ZERO,0.05,T,EZ)
	tween.start()

func _on_Player_health_updated(health):
	var si=Global.health-health
	if sign(si)>0:
		if health==0:
			heart2.frame=0
			heart1.frame=0
			heart=heart2
			_health_start(heart)
		elif health==1:
			heart2.frame=1
			heart1.frame=0
			heart=heart2
			_health_start(heart)
		elif health==2:
			heart2.frame=2
			heart1.frame=0
			heart=heart1
			_health_start(heart)
		elif health==3:
			heart2.frame=2
			heart1.frame=1
			heart=heart1
			_health_start(heart)
	else:
		if health==1:
			heart2.frame=1
			heart1.frame=0
			heart=heart2
			_health_start(heart)
		elif health==2:
			heart2.frame=2
			heart1.frame=0
			heart=heart2
			_health_start(heart)
		elif health==3:
			heart2.frame=2
			heart1.frame=1
			heart=heart1
			_health_start(heart)
		elif health==4:
			heart2.frame=2
			heart1.frame=2
			heart=heart1
			_health_start(heart)

func _on_Health_Duration_timeout():
	_reset(Health_tween,heart)
	hF.stop()
	heart1.modulate=Color8(255,255,255,255)
	heart2.modulate=Color8(255,255,255,255)


func _on_Health_Frequency_timeout():
	_shake(Health_tween,heart)
	hF.start()


func _on_Diamond_Frequency_timeout():
	_shake(Diamond_tween,diamond)
	dF.start()


func _on_Diamond_Duration_timeout():
	_reset(Diamond_tween,diamond)
	dF.stop()
	diamond1.modulate=Color8(255,255,255,255)
	diamond2.modulate=Color8(255,255,255,255)
	diamond3.modulate=Color8(255,255,255,255)
	diamond4.modulate=Color8(255,255,255,255)
	diamond5.modulate=Color8(255,255,255,255)
	diamond6.modulate=Color8(255,255,255,255)


func _on_Player_diamonds_updated(diamonds,dir):
	_reset(Diamond_tween,diamond)
	dF.stop()
	diamond.modulate=Color8(255,255,255,255)
	if diamonds==0:
		diamond=diamond1
		diamond1.frame=1
		diamond2.frame=1
		diamond3.frame=1
		diamond4.frame=1
		diamond5.frame=1
		diamond6.frame=1
	elif diamonds==1:
		if dir<0:
			diamond=diamond2
		else:
			diamond=diamond1
		diamond1.frame=0
		diamond2.frame=1
		diamond3.frame=1
		diamond4.frame=1
		diamond5.frame=1
		diamond6.frame=1
	elif diamonds==2:
		if dir<0:
			diamond=diamond3
		else:
			diamond=diamond2
		diamond1.frame=0
		diamond2.frame=0
		diamond3.frame=1
		diamond4.frame=1
		diamond5.frame=1
		diamond6.frame=1
	elif diamonds==3:
		if dir<0:
			diamond=diamond4
		else:
			diamond=diamond3
		diamond1.frame=0
		diamond2.frame=0
		diamond3.frame=0
		diamond4.frame=1
		diamond5.frame=1
		diamond6.frame=1
	elif diamonds==4:
		if dir<0:
			diamond=diamond5
		else:
			diamond=diamond4
		diamond1.frame=0
		diamond2.frame=0
		diamond3.frame=0
		diamond4.frame=0
		diamond5.frame=1
		diamond6.frame=1
	elif diamonds==5:
		if dir<0:
			diamond=diamond6
		else:
			diamond=diamond5
		diamond1.frame=0
		diamond2.frame=0
		diamond3.frame=0
		diamond4.frame=0
		diamond5.frame=0
		diamond6.frame=1
	elif diamonds==6:
		diamond=diamond6
		diamond1.frame=0
		diamond2.frame=0
		diamond3.frame=0
		diamond4.frame=0
		diamond5.frame=0
		diamond6.frame=0
	_diamond_start(diamond)


