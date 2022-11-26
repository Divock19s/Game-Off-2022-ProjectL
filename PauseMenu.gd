extends Control
var states={"pause":1,"map":2}
var state = states.pause
var add= Vector2.ZERO
onready var player=get_parent().get_parent().get_node("Player")
func _ready():
	visible=false
	_mappa()

func _mappa():
	if Global.diamonds>0:
		$Menu/VBoxContainer/Map.disabled=false
	else:
		$Menu/VBoxContainer/Map.disabled=true

func _input(event):
	if visible:
		if ! $AudioStreamPlayer.playing and !(event is InputEventMouseMotion):
			$AudioStreamPlayer.play()
	if event.is_action_pressed("pause") and !Global.dead:
		if state==states.pause:
			get_tree().paused=!get_tree().paused
			if get_tree().paused:
				visible=true
				$Menu/VBoxContainer/Resume.grab_focus()
			else:
				visible=false
		elif state==states.map:
			state=states.pause
			$AnimationPlayer.play("Pause")
func _death():
	pass
func _mapos():
	match Global.maps:
		"res://Maps/Map1.tscn":
			add=Vector2(167,134)
			return
		"res://Maps/Map2.tscn":
			add=Vector2(167,203)
			return
		"res://Maps/Map3.tscn":
			add=Vector2(167,350)
			return
		"res://Maps/Map4.tscn":
			add=Vector2(680,208)
			return
		"res://Maps/Map5.tscn":
			add=Vector2(550,134)
			return
		"res://Maps/Map6.tscn":
			add=Vector2.ZERO
			return
		"res://Maps/Map7.tscn":
			add=Vector2.ZERO
			return
func _map():
	var pos = player.global_position*0.24
	_mapos()
	if add!=Vector2.ZERO:
		$map/player.position=pos+add
		$map/player.position.x=clamp($map/player.position.x,173,1088)
		$map/player.position.y=clamp($map/player.position.y,145,441)
	else:
		$map/player.position=Vector2(350,127)

func _on_Resume_pressed():
	if state==states.pause:
		get_tree().paused=false
		visible=false

func _on_Map_pressed():
	if state==states.pause:
		_map()
		state=states.map
		$AnimationPlayer.play("Map")


func _on_Quit_pressed():
	if state==states.pause:
		get_tree().paused=false
		var _k = get_tree().change_scene("res://Menu/MainManu.tscn")


func _on_Player_diamonds_updated(_diamonds, _dir):
	_mappa()
