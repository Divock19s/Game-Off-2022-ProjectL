extends Node

var data={"diamonds":0,"health":4,"progress":0,"FullScreen":true,"music":true,"fog":true,
"posa":"new","glo":Vector2(0,0),"mos":Vector2(0,0),"maps":"res://Story.tscn"}

var path="user://save.dat"

var siz=data.size()
var diamonds
var health
var progress
var FullScreen
var music
var fog
var dead
var posa
var glo_pos
var map_pos
var maps

func _init():
	_load()
	_set_data()

func _set_data():
	if data.size()==siz:
		diamonds = data.diamonds
		health = data.health
		progress=data.progress
		FullScreen=data.FullScreen
		music = data.music
		fog= data.fog
		dead=false
		posa=data.posa
		glo_pos=data.glo
		map_pos=data.mos
		maps=data.maps
		return
	_reset()

func _save():
	var nata={"diamonds":diamonds,"health":health,"progress":progress,"FullScreen":FullScreen,"music":music,"fog":fog,
	"posa":posa,"glo":glo_pos,"mos":map_pos,"maps":maps}
	var file = File.new()
	var error = file.open_encrypted_with_pass(path,File.WRITE,"Astalavista")
	if error == OK:
		file.store_var(nata)
		file.close()

func _load():
	var file = File.new()
	if file.file_exists(path):
		var error = file.open_encrypted_with_pass(path,File.READ,"Astalavista")
		if error == OK:
			data=file.get_var()
			file.close()

func _reset():
	var nata={"diamonds":0,"health":4,"progress":0,"FullScreen":true,"music":true,"fog":true,
	"posa":"new","glo":Vector2(0,0),"mos":Vector2(0,0),"maps":"res://Story.tscn"}
	var file = File.new()
	var error = file.open_encrypted_with_pass(path,File.WRITE,"Astalavista")
	if error == OK:
		file.store_var(nata)
		file.close()
	data=nata
	diamonds = data.diamonds
	health = data.health
	progress=data.progress
	FullScreen=data.FullScreen
	music = data.music
	fog= data.fog
	dead=false
	posa=data.posa
	glo_pos=data.glo
	map_pos=data.mos
	maps=data.maps
