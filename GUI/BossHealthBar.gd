extends Control
onready var h=$Health
onready var hu=$Hunder
onready var T=$Tween
onready var parent=get_parent().get_parent().get_parent().get_node("Boss")
func _ready():
	h.max_value=parent.max_health
	hu.max_value=parent.max_health
func _on_health_updated(health):
	h.value=health
	T.interpolate_property(hu,"value",hu.value,health,0.4,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	T.start()


func _on_Boss_health_updated(health):
	h.value=health
	T.interpolate_property(hu,"value",hu.value,health,0.4,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	T.start()
