extends Control

var active=false

var Texts=[]
var textIndex=0

onready var box = $Control
onready var label = $Control/RichTextLabel
onready var textTween=$TextTween
onready var boxTween=$BoxTween
onready var timer=$Timer

func _ready():
	label.percent_visible=0
	box.margin_top=-100

func _input(event):
	if active:
		if event.is_action_pressed("next"):
			_changetext()

func _start():
	$Control/Sprite.playing=true
	active=true
	_changetext()
	_text_in()

func _changetext():
	if textIndex< len(Texts):
		label.text=Texts[textIndex]
		label.percent_visible=0
		textIndex+=1
		_type()
		$Timer.start()
	else:
		$Control/Sprite.playing=false
		$Timer.stop()
		_text_out()
		active=false

func _text_in():
	textTween.interpolate_property(box,"margin_top",box.margin_top,100,0.5,
	Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	textTween.start()

func _text_out():
	textTween.interpolate_property(box,"margin_top",box.margin_top,-100,0.5,
	Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	textTween.start()


func _type():
	var time=len(label.text)/30
	textTween.interpolate_property(label,"percent_visible",0,1,time,
	Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	textTween.start()

func _on_Timer_timeout():
	_changetext()
