extends Tween
const EZ= Tween.EASE_IN_OUT
const T=Tween.TRANS_SINE
var A=0
var P=0
onready var camera = get_parent()
onready var D=$Duration
onready var F=$Frequency 
func _start(duration,frequency,amplitude,priority):
	if priority>=P:
		P=priority
		A=amplitude
		D.wait_time=duration
		F.wait_time=1/float(frequency)
		F.start()
		D.start()
		_shake()
func _shake():
		var rand=Vector2()
		rand.x=rand_range(-A,A)
		rand.y=rand_range(-A,A)
		var _i= interpolate_property(camera,"offset",camera.offset,rand,F.wait_time,T,EZ)
		var _s= start()
func _reset():
	var _i =interpolate_property(camera,"offset",camera.offset,Vector2.ZERO,F.wait_time,T,EZ)
	var _s = start()
	P=0
func _on_Duration_timeout():
	_reset()
	F.stop()
func _on_Frequency_timeout():
	_shake()
	F.start()
