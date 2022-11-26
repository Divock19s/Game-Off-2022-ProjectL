extends Area2D
signal text_done()
export (bool) var remove=false
export (int) var prog=0
onready var textbox=get_parent().get_node("Player/CanvasLayer/Text")
export (Array) var tex=[]
func _ready():
	print(Global.progress)
	if Global.progress > prog:
		call_deferred("queue_free")

func _on_Text1_body_entered(body):
	if "Player" in body.name:
		textbox.Texts=tex
		textbox.textIndex=0
		textbox._start()
		if remove:
			$Timer.start()

func _on_Timer_timeout():
	emit_signal("text_done")
	call_deferred("queue_free")
