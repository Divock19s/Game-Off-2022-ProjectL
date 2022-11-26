extends Node
onready var Music=$AudioStreamPlayer
var calm=load("res://Assets/Music/GamePlay-Loop-2-Hope.mp3")
var intense=load("res://Assets/Music/Game-play-loop-Intense.mp3")
var music=true
var boss=false
var main = true
var i=0
func _play():
	if music:
		Music.volume_db=-6
		Music.stream=calm
		Music.play()
func _play_boss():
	if music:
		Music.volume_db=0
		Music.stream=intense
		Music.play()
func _on_AudioStreamPlayer_finished():
	if music:
		if boss:
			_play_boss()
		elif !main:
			_play()
